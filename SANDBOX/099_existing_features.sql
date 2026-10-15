/* DROP FUNCTION IF EXISTS sandbox.kontrol_existing_features(
	_eksisterende_fid integer
	,_bounds geometry('GEOMETRY', 25832)
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_existing_features(
	_eksisterende_fid integer
	,_bounds geometry('GEOMETRY', 25832)
)
	RETURNS TABLE(
		inputfile_fid integer
		,featuretype_fid integer
		,feature_fid integer
		,geom geometry('GEOMETRY', 25832)
		,attributes_xml xml
	)
	STABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	i record;

	_sql_template text;
	_sql_agg text[];
	_sql text;

BEGIN

	-- Opret SQL-skabelon
	WITH

		cte1 AS(
			SELECT DISTINCT ON(e.fid)
				e.fid AS eksisterende_fid
				,ft.fid AS featuretype_fid

				,e.tabel_skema
				,e.tabel_navn
				,e.tabel_geom
				,e.tabel_filter
			FROM sandbox.kontrol_lst_eksisterende e
			INNER JOIN sandbox.kontrol_lst_featuretyper ft ON ft.system = e.system
				AND ft.forsyningsart = e.forsyningsart
				AND ft.gruppe = e.gruppe
				AND e.geometritype = ANY(ft.geometrityper_lst)
				AND ft.aktiv IS TRUE

			WHERE e.fid = _eksisterende_fid
				AND e.aktiv IS TRUE
			-- WHERE e.fid = 4
			ORDER BY e.fid
				,ft._order
		)


		,eksisterende_attr AS(
			-- Alm. tabel
			SELECT
				e.eksisterende_fid
				,e.featuretype_fid

				,e.tabel_skema
				,e.tabel_navn
				,e.tabel_geom
				,e.tabel_filter

				,a.attnum
				,a.attname::text
			FROM cte1 e
			INNER JOIN pg_namespace n ON n.nspname = e.tabel_skema
			INNER JOIN pg_class c ON c.relname = e.tabel_navn
				AND c.relnamespace = n.oid
			INNER JOIN pg_attribute a ON a.attrelid = c.oid
			WHERE NOT(e.tabel_navn ~* '\(')
				AND a.attnum > 0
				AND a.attisdropped IS FALSE
				AND a.attname != e.tabel_geom

			UNION ALL

			-- Funktion
			SELECT
				e.eksisterende_fid
				,e.featuretype_fid

				,e.tabel_skema
				,e.tabel_navn
				,e.tabel_geom
				,e.tabel_filter

				,u._order AS attnum
				,p.proargnames[u._order] AS attname
			FROM cte1 e
			INNER JOIN pg_namespace n ON n.nspname = e.tabel_skema
			INNER JOIN pg_proc p ON p.proname = SUBSTRING(e.tabel_navn, '^(.+?)\(')
				AND p.pronamespace = n.oid
			INNER JOIN UNNEST(
					p.proargmodes
				) WITH ORDINALITY u(proargmode, _order) ON TRUE
			WHERE e.tabel_navn ~* '\('
				AND u.proargmode = 't'
				AND p.proargnames[u._order] != e.tabel_geom
		)

		,feature_attributes AS(
			SELECT DISTINCT ON(e.attname)
				e.eksisterende_fid
				,e.featuretype_fid

				,e.tabel_skema
				,e.tabel_navn
				,e.tabel_geom
				,e.tabel_filter

				,e.attname
				,ft_a.attr
			FROM eksisterende_attr e
				,sandbox.kontrol_featuretype_attributes(
					_featuretype_fid := e.featuretype_fid
				) ft_a
			WHERE e.attname = ANY(ft_a.attr_lst)
				AND ft_a.kontrol_type IS DISTINCT FROM 'hidden'
			ORDER BY e.attname
				,array_position(ft_a.attr_lst, e.attname)
		)

	SELECT
		FORMAT(
$$SELECT
			%4$s AS inputfile_fid
			,%5$s AS featuretype_fid
			,ST_Intersection(
				ST_Force2D(%3$I)
				,'[BOUNDS]'::geometry('GEOMETRY', 25832)
			) AS geom
			,%7$s AS attributes_xml
		FROM %1$I.%2$s
		WHERE ST_Intersects(
				%3$I
				,'[BOUNDS]'::geometry('GEOMETRY', 25832)
			)%6$s$$

			,ft.tabel_skema
			,ft.tabel_navn
			,ft.tabel_geom

			,ft.eksisterende_fid
			,ft.featuretype_fid


			,' AND ' || NULLIF(TRIM(ft.tabel_filter), '')

			,string_agg(
				FORMAT(
					$$COALESCE(E'\n\t<%1$s>' || sandbox.kontrol_xml_encode(%2$I::text) || '</%1$s>', '')$$
					,ft.attr
					,ft.attname
				)
				,E'\n\t\t\t\t|| '
				ORDER BY ft.attr
			)
		)
	FROM feature_attributes ft
	GROUP BY
		ft.eksisterende_fid
		,ft.featuretype_fid

		,ft.tabel_skema
		,ft.tabel_navn
		,ft.tabel_geom
		,ft.tabel_filter
	INTO _sql_template;


	FOR i IN
		SELECT
			dmp.geom AS bounds
			,ST_XMin(dmp.geom) AS x_min
			,ST_YMin(dmp.geom) AS y_min
			,ST_XMax(dmp.geom) AS x_max
			,ST_YMax(dmp.geom) AS y_max
		FROM ST_Dump(_bounds) dmp
		WHERE NOT(ST_IsEmpty(dmp.geom))
			AND dmp.geom IS NOT NULL
			AND ST_IsValid(dmp.geom)
	LOOP

		_sql_agg := _sql_agg
					|| REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(
										_sql_template
										,'[BOUNDS]'
										,i.bounds::text
									)
									,'[XMIN]'
									,i.x_min::text
								)
								,'[YMIN]'
								,i.y_min::text
							)
							,'[XMAX]'
							,i.x_max::text
						)
						,'[YMAX]'
						,i.y_max::text
					);

	END LOOP;



	_sql_agg := NULLIF(
					array_remove(
						_sql_agg
						,NULL
					)
					,'{}'
				);



	IF _sql_template IS NULL
		OR _sql_agg IS NULL
	THEN

		RETURN QUERY
		SELECT
			NULL::int AS inputfile_fid
			,NULL::int AS featuretype_fid
			,NULL::int AS feature_fid
			,NULL::geometry('GEOMETRY', 25832) AS geom
			,NULL::xml AS attributes_xml
		LIMIT 0;

	ELSE

		_sql := FORMAT(
$$WITH

	cte1 AS(
		%s
	)

	,cte2 AS(
		SELECT
			inputfile_fid
			,featuretype_fid
			,ROW_NUMBER() OVER()::integer AS feature_fid
			,geom
			,attributes_xml
		FROM cte1
	)

SELECT
	-inputfile_fid
	,featuretype_fid
	,feature_fid
	,geom


	,('<attributes fid="-'
		|| lpad(
				inputfile_fid::text
				,GREATEST(CEILING(log10(MAX(inputfile_fid) OVER()))::int, 2)
				,'0'
			)
		|| '-'
		|| lpad(
				feature_fid::text
				,GREATEST(CEILING(log10(MAX(feature_fid) OVER()))::int, 2)
				,'0'
			)
		|| E'">'
		|| attributes_xml
		|| E'\n</attributes>')::xml AS attributes_xml
FROM cte2;$$

				,array_to_string(
					_sql_agg
					,E'\n\t\tUNION\n\t\t'
				)
			);



		RETURN QUERY
		EXECUTE _sql;

	END IF;

END $BODY$;