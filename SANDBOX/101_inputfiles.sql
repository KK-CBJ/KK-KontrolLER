/* DROP FUNCTION IF EXISTS sandbox.kontrol_inputfiles(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_inputfiles(
	_kontrol_guid uuid
)
	RETURNS VOID
	-- RETURNS TABLE(
		-- inputfile_fid integer
		-- ,inputfile_id text
		-- ,inputfile text
		-- ,inputfile_pretty text
		-- ,inputfile_order integer

		-- ,inputfile_name text
		-- ,inputfile_extension text
		-- ,inputfile_featuretype text
		-- ,inputfile_feature_srid integer
		-- ,inputfile_feature_count integer
		-- ,inputfile_feature_bounds geometry('POLYGON', 25832)

		-- ,inputfile_filtype text
		-- ,inputfile_filtype_pretty text

		-- ,featuretype_fid integer
		-- ,featuretype text
		-- ,featuretype_pretty text
		-- ,featuretype_order integer


		-- ,system_fid integer
		-- ,system text
		-- ,system_pretty text
		-- ,system_order integer

		-- ,forsyningsart_fid integer
		-- ,forsyningsart text
		-- ,forsyningsart_pretty text
		-- ,forsyningsart_order integer

		-- ,gruppe_fid integer
		-- ,gruppe text
		-- ,gruppe_pretty text
		-- ,gruppe_order integer

		-- ,geometritype_fid integer
		-- ,geometritype text
		-- ,geometritype_pretty text
		-- ,geometritype_short text
		-- ,geometritype_order integer
		-- ,pg_geometritype text


		-- ,dimension text
		-- ,dimension_pretty text
		-- ,dimension_zm_flag integer

		-- ,group_column text

		-- ,etablering_column text
		-- ,etablering_skaering date

		-- ,snap_kontrol boolean
		-- ,snap_reference boolean

		-- ,forsyningsart_color_hex text

		-- ,fejl integer
		-- ,inputfile_xml xml
	-- )
	-- STABLE
	VOLATILE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	DELETE FROM sandbox.kontrol_inputfiles k
		WHERE k.kontrol_guid = _kontrol_guid;


	-- RETURN QUERY
	WITH

		cte1 AS(
			SELECT
				i.inputfile_fid
				,i.inputfile_id
				,i.inputfile
				,i.inputfile
					|| CASE
							WHEN LOWER(f.navn) = 'gpkg'
									AND i.inputfile != i.inputfile_featuretype || '.gpkg'
							THEN ': ' || i.inputfile_featuretype
							ELSE ''
						END AS inputfile_pretty
				,i.inputfile_fid AS inputfile_order

				,i.inputfile_name
				,i.inputfile_extension
				,i.inputfile_featuretype
				,i.inputfile_feature_srid
				,i.inputfile_feature_count
				,CASE
					WHEN i.inputfile_feature_srid IS NOT NULL
						AND i.inputfile_bounds_xmin IS NOT NULL
						AND i.inputfile_bounds_ymin IS NOT NULL
						AND i.inputfile_bounds_xmax IS NOT NULL
						AND i.inputfile_bounds_ymax IS NOT NULL
					THEN ST_Envelope(
							ST_Buffer(
								ST_Transform(
									ST_SetSRID(
										ST_Makebox2D(
											ST_MakePoint(i.inputfile_bounds_xmin, i.inputfile_bounds_ymin)
											,ST_MakePoint(i.inputfile_bounds_xmax, i.inputfile_bounds_ymax)
										)
										,i.inputfile_feature_srid
									)
									,25832
								)
								,5
							)
						)
				END AS inputfile_feature_bounds

				,f.navn AS inputfile_filtype
				,f.navn_pretty AS inputfile_filtype_pretty


				,u.inputfile_xml
				,i.inputfile_attributes_xml
				-- ,i.inputfile_attributes_count


				,l.inputfile_id_lst
			FROM sandbox.kontrol_xml k

			INNER JOIN UNNEST(xpath('/kontrolLER/inputFiles/inputFile', k._xml::xml)) u(inputfile_xml) ON TRUE
			INNER JOIN xmltable(
					'/*' passing u.inputfile_xml
						COLUMNS
							inputfile_fid integer path '@fid'
							,inputfile_id text path '@id'

							,inputfile text path '/inputFile/file/text()'

							,inputfile_name text path '/inputFile/fileName/text()'
							,inputfile_extension text path '/inputFile/fileExtension/text()'
							,inputfile_featuretype text path '/inputFile/featureType/text()'
							,inputfile_feature_srid integer path '/inputFile/featureSRID/text()'
							,inputfile_feature_count integer path '/inputFile/featureCount/text()'

							,inputfile_bounds_xmin numeric path '/inputFile/featureBounds/xmin/text()'
							,inputfile_bounds_ymin numeric path '/inputFile/featureBounds/ymin/text()'
							,inputfile_bounds_xmax numeric path '/inputFile/featureBounds/xmax/text()'
							,inputfile_bounds_ymax numeric path '/inputFile/featureBounds/ymax/text()'

							,inputfile_attributes_xml xml path '/inputFile/attributes'
							-- ,inputfile_attributes_count integer path 'count(/inputFile/attributes/attribute)'
				) i ON TRUE

				INNER JOIN string_to_array(
						i.inputfile_id
						,':'
					) l(inputfile_id_lst) ON TRUE

				-- Accepteres filtypen
				LEFT JOIN sandbox.kontrol_fme_filtyper f ON LOWER(f.navn) = LOWER(i.inputfile_extension)
					AND f.aktiv IS TRUE
			WHERE k.guid = _kontrol_guid
		)

		,cte2 AS(
			SELECT DISTINCT ON(c.inputfile_fid)
				c.inputfile_fid

				,ft.fid AS featuretype_fid
				,ft.navn_lst[1] AS featuretype
				,ft.navn_pretty AS featuretype_pretty
				,ft._order AS featuretype_order


				,st.fid AS system_fid
				,st.navn AS system
				,st.navn_pretty AS system_pretty
				,st._order AS system_order

				,fa.fid AS forsyningsart_fid
				,fa.navn AS forsyningsart
				,fa.navn_pretty AS forsyningsart_pretty
				,fa._order AS forsyningsart_order

				,grp.fid AS gruppe_fid
				,grp.navn AS gruppe
				,grp.navn_pretty AS gruppe_pretty
				,grp._order AS gruppe_order

				,gt.fid AS geometritype_fid
				,gt.navn AS geometritype
				,gt.navn_pretty AS geometritype_pretty
				,gt.navn_short AS geometritype_short
				,gt._order AS geometritype_order
				,gt.pg_geometritype


				,ft.dimension
				,dim.navn_pretty AS dimension_pretty
				,dim.zm_flag AS dimension_zm_flag

				,ft.group_column

				,ft.etablering_column
				,ft.etablering_skaering

				,CASE
					WHEN ft.snap_kontrol IS TRUE
						AND (
							gt.navn = ANY(ft.snap_kontrol_geometrityper_lst)
							OR NULLIF(ft.snap_kontrol_geometrityper_lst, '{}') IS NULL
						)
					THEN TRUE
					ELSE FALSE
				END AS snap_kontrol
				,CASE
					WHEN ft.snap_reference IS TRUE
						AND (
							gt.navn = ANY(ft.snap_reference_geometrityper_lst)
							OR NULLIF(ft.snap_reference_geometrityper_lst, '{}') IS NULL
						)
					THEN TRUE
					ELSE FALSE
				END AS snap_reference

				,fa.color_hex AS forsyningsart_color_hex

			FROM cte1 c

			-- Split ID
			INNER JOIN UNNEST(c.inputfile_id_lst[1:2]) WITH ordinality u(inputfile_id, _order) ON TRUE
			-- INNER JOIN string_to_array(LOWER(u.inputfile_id), '_') s(id_parts) ON TRUE

			-- Identificér de forskellige dele af ID'et
			-- INNER JOIN sandbox.kontrol_lst_forsyningsarter fa ON s.id_parts && fa.navn_lst
				-- AND fa.aktiv IS TRUE
			-- INNER JOIN sandbox.kontrol_lst_grupper grp ON s.id_parts && grp.navn_lst
				-- AND grp.aktiv IS TRUE
			-- INNER JOIN sandbox.kontrol_lst_geometrityper gt ON s.id_parts && gt.navn_lst
				-- AND gt.aktiv IS TRUE

			INNER JOIN sandbox.kontrol_lst_forsyningsarter fa ON u.inputfile_id ~* ('(^|_)(' || array_to_string(fa.navn_lst, '|') || ')(_|$)')
				AND fa.aktiv IS TRUE
			INNER JOIN sandbox.kontrol_lst_grupper grp ON u.inputfile_id ~* ('(^|_)(' || array_to_string(grp.navn_lst, '|') || ')(_|$)')
				AND grp.aktiv IS TRUE
			INNER JOIN sandbox.kontrol_lst_geometrityper gt ON u.inputfile_id ~* ('(^|_)(' || array_to_string(gt.navn_lst, '|') || ')(_|$)')
				AND gt.aktiv IS TRUE

			-- Find en featuretype, som matcher de forskellige dele af ID'et
			INNER JOIN sandbox.kontrol_lst_featuretyper ft ON ft.forsyningsart = fa.navn
				AND ft.gruppe = grp.navn
				AND gt.navn = ANY(ft.geometrityper_lst)
				AND ( -- OBS CASE sensitiv, ellers kan generelle typer lande i specifikke (fx. ledning -> Ledning)
				-- s.id_parts && ft.navn_lst
					u.inputfile_id ~ ('(^|_)(' || array_to_string(ft.navn_lst, '|') || ')(_|$)')
					OR NULLIF(ft.navn_lst, '{}') IS NULL
				)
				AND ft.aktiv IS TRUE

			INNER JOIN sandbox.kontrol_lst_systemer st ON st.navn = ft.system
				AND st.aktiv IS TRUE

			INNER JOIN sandbox.kontrol_lst_dimensioner dim ON dim.navn = ft.dimension
				AND dim.aktiv IS TRUE


			-- Sammenhold attributter
			LEFT JOIN LATERAL(
					SELECT
						SUM((t.match_count > 0)::int)::numeric / COUNT(*) AS match_pct
					FROM sandbox.kontrol_lst_featuretyper ft_sub
						,sandbox.kontrol_featuretype_attributes(ft_sub.fid) ft_a
						,xmltable(
							'/*' passing c.inputfile_attributes_xml
								COLUMNS
									match_count integer path 'count(/attributes/attribute[contains(''' || array_to_string(ft_a.attr_lst, ' ') || ''', @name)])'
						) t
					WHERE ft_sub.system = ft.system
						AND ft_sub.forsyningsart = ft.forsyningsart
						AND ft_sub.gruppe = ft.gruppe
						AND ft_a.restriktion_sql IS DISTINCT FROM 'FALSE'
						AND ft_a.kontrol_type IS DISTINCT FROM 'hidden'
					GROUP BY ft_sub.fid
					-- HAVING COUNT(*) * 5 > c.inputfile_attributes_count
					ORDER BY 1 DESC NULLS LAST
					LIMIT 1
				) ft_a ON TRUE

			WHERE c.inputfile_filtype IS NOT NULL

			-- Findes et specifikt system (defineret i navn_lst), trumfer denne
			-- Findes en specifik featuretype (defineret i navn_lst), trumfer denne
			-- Overlap mellem kolonner i fil og featuretype trumfer
			-- System sortering trumfer
			-- Featuretype (lagnavn i GPKG) trumfer filnavn
			ORDER BY c.inputfile_fid

				-- ,s.id_parts && st.navn_lst DESC NULLS LAST
				-- ,s.id_parts && ft.navn_lst DESC NULLS LAST

				,u.inputfile_id ~* ('(^|_)(' || array_to_string(st.navn_lst, '|') || ')(_|$)') DESC NULLS LAST
				,u.inputfile_id ~* ('(^|_)(' || array_to_string(ft.navn_lst, '|') || ')(_|$)') DESC NULLS LAST
				,ft_a.match_pct DESC NULLS LAST
				,st._order DESC NULLS LAST
				,u._order
		)

		,cte3 AS(
			SELECT
				c.inputfile_fid

				,c.featuretype_fid
				,c.featuretype
				,c.featuretype_pretty
				,c.featuretype_order
				-- ,DENSE_RANK() OVER(ORDER BY
										-- c.system_order
										-- ,c.forsyningsart_order
										-- ,c.gruppe_order
										-- ,c.geometritype_order
										-- ,c.featuretype_order
									-- )::integer AS featuretype_order


				,c.system_fid
				,c.system
				,c.system_pretty
				,c.system_order

				,c.forsyningsart_fid
				,c.forsyningsart
				,c.forsyningsart_pretty
				,c.forsyningsart_order

				,c.gruppe_fid
				,c.gruppe
				,c.gruppe_pretty
				,c.gruppe_order

				,c.geometritype_fid
				,c.geometritype
				,c.geometritype_pretty
				,c.geometritype_short
				,c.geometritype_order
				,c.pg_geometritype


				,c.dimension
				,c.dimension_pretty
				,c.dimension_zm_flag

				,c.group_column

				,c.etablering_column
				,c.etablering_skaering

				,c.snap_kontrol
				,c.snap_reference

				,c.forsyningsart_color_hex
			FROM cte2 c
		)

	INSERT INTO sandbox.kontrol_inputfiles
	SELECT
		_kontrol_guid
		,a.*
	FROM (
			SELECT
				c.inputfile_fid
				,c.inputfile_id
				,c.inputfile
				,c.inputfile_pretty
				,c.inputfile_order

				,c.inputfile_name
				,c.inputfile_extension
				,c.inputfile_featuretype
				,c.inputfile_feature_srid
				,c.inputfile_feature_count
				,c.inputfile_feature_bounds

				,c.inputfile_filtype
				,c.inputfile_filtype_pretty

				,c2.featuretype_fid
				,c2.featuretype
				,c2.featuretype_pretty
				,c2.featuretype_order


				,c2.system_fid
				,c2.system
				,c2.system_pretty
				,c2.system_order

				,c2.forsyningsart_fid
				,c2.forsyningsart
				,c2.forsyningsart_pretty
				,c2.forsyningsart_order

				,c2.gruppe_fid
				,c2.gruppe
				,c2.gruppe_pretty
				,c2.gruppe_order

				,c2.geometritype_fid
				,c2.geometritype
				,c2.geometritype_pretty
				,c2.geometritype_short
				,c2.geometritype_order
				,c2.pg_geometritype


				,c2.dimension
				,c2.dimension_pretty
				,c2.dimension_zm_flag

				,c2.group_column

				,c2.etablering_column
				,c2.etablering_skaering

				,c2.snap_kontrol
				,c2.snap_reference

				,c2.forsyningsart_color_hex

				,CASE
					WHEN c2.featuretype_fid IS NOT NULL
						AND c.inputfile_feature_count IS NOT NULL
					THEN 0
					ELSE 1
				END AS fejl
				,c.inputfile_xml
			FROM cte1 c
			LEFT JOIN cte3 c2 ON c2.inputfile_fid = c.inputfile_fid
		) a;

END $BODY$;