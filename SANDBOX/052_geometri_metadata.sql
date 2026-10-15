/* DROP FUNCTION IF EXISTS sandbox.kontrol_geometri_metadata(
	_pg_geometritype text
	,_srid text
	,_zm_flag integer
	,_foer_skaering boolean

	,_geom_wkt text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_geometri_metadata(
	_pg_geometritype text
	,_srid integer
	,_zm_flag integer
	,_foer_skaering boolean

	,_geom_wkt text


	,OUT _geom geometry(GEOMETRY, 25832)

	,OUT _geom_geometritype_fid integer
	,OUT _geom_geometritype text
	,OUT _geom_geometritype_pretty text
	,OUT _geom_geometritype_short text
	,OUT _geom_geometritype_order integer
	,OUT _geom_pg_geometritype text

	-- ,OUT _mgd_type text
	-- ,OUT _mgd numeric
	-- ,OUT _mgd_enhed text
	-- ,OUT _mgd_pretty text


	-- ,OUT _z_min numeric
	-- ,OUT _z_max numeric

	-- ,OUT _z_count integer
	-- ,OUT _z_0_count integer
	-- ,OUT _z_99_count integer
	-- ,OUT _z_nan_count integer


	-- ,OUT _fejl_no_geom integer
	-- ,OUT _fejl_no_geom_pretty text

	-- ,OUT _fejl_srid integer
	-- ,OUT _fejl_srid_pretty text

	-- ,OUT _fejl_ndims integer
	-- ,OUT _fejl_ndims_pretty text

	-- ,OUT _fejl_singlegeom integer
	-- ,OUT _fejl_singlegeom_pretty text

	-- ,OUT _fejl_geometritype integer
	-- ,OUT _fejl_geometritype_pretty text

	-- ,OUT _fejl_valid integer
	-- ,OUT _fejl_valid_pretty text

	-- ,OUT _fejl_min_mgd integer
	-- ,OUT _fejl_min_mgd_pretty text

	-- ,OUT _fejl_z_0 integer
	-- ,OUT _fejl_z_0_pretty text
	-- ,OUT _fejl_z_99 integer
	-- ,OUT _fejl_z_99_pretty text
	-- ,OUT _fejl_z_nan integer
	-- ,OUT _fejl_z_nan_pretty text


	,OUT _geom_xml xml
)
	RETURNS RECORD
	STABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_crs integer;
	_crs_pretty text;


	_mgd_type text;
	_mgd numeric;
	_mgd_enhed text;
	_mgd_pretty text;


	_z_min numeric;
	_z_max numeric;

	_z_count integer;
	_z_0_count integer;
	_z_99_count integer;
	_z_nan_count integer;


	_fejl_no_geom integer;
	_fejl_no_geom_pretty text;

	_fejl_srid integer;
	_fejl_srid_pretty text;

	_fejl_ndims integer;
	_fejl_ndims_pretty text;

	_fejl_singlegeom integer;
	_fejl_singlegeom_pretty text;

	_fejl_geometritype integer;
	_fejl_geometritype_pretty text;

	_fejl_valid integer;
	_fejl_valid_pretty text;

	_fejl_min_mgd integer;
	_fejl_min_mgd_pretty text;

	_fejl_z_0 integer;
	_fejl_z_0_pretty text;
	_fejl_z_99 integer;
	_fejl_z_99_pretty text;
	_fejl_z_nan integer;
	_fejl_z_nan_pretty text;
	_fejl_z_high_low integer;
	_fejl_z_high_low_pretty text;

	_error_geom_handling text;

BEGIN

	SELECT
		s.navn
		,s.navn_pretty
	FROM sandbox.kontrol_lst_srid s
	WHERE _srid = ANY(s.navn_lst)
	INTO _crs
		,_crs_pretty;



	_geom := CASE
				WHEN COALESCE(_crs, _srid) IS NOT NULL
				THEN ST_Transform(
						ST_GeomFromText(_geom_wkt, COALESCE(_crs, _srid))
						,25832
					)
				ELSE ST_GeomFromText(_geom_wkt, 25832)
			END;


--
-- Ingen geometri
--

	IF NOT(
			_geom IS NULL
			OR ST_IsEmpty(_geom)
		)
	THEN

		_fejl_no_geom := 0;
		_fejl_no_geom_pretty := 'Indeholder geometri';

	ELSE

		_geom := NULL;
		_fejl_no_geom := 1;
		_fejl_no_geom_pretty := 'Ingen geometri';

	END IF;





	IF _fejl_no_geom = 0 THEN



	--
	-- SRID
	--

		IF _crs IS NOT NULL THEN

			_fejl_srid := 0;
			_fejl_srid_pretty := _crs_pretty;

		ELSE

			_fejl_srid := 1;
			_fejl_srid_pretty := 'EPSG:' || _srid::text;

		END IF;



	--
	-- Dimensioner
	--

		IF _zm_flag = 0 THEN

			_geom := ST_Force2D(
						CASE
							WHEN ST_NumGeometries(_geom) = 1
							THEN ST_GeometryN(_geom, 1)
							ELSE _geom
						END
					);

		END IF;


		IF ST_ZMFlag(_geom) >= _zm_flag THEN

			_fejl_ndims := 0;
			_fejl_ndims_pretty := (SELECT dim.navn_pretty FROM sandbox.kontrol_lst_dimensioner dim WHERE dim.zm_flag = _zm_flag AND dim.aktiv IS TRUE);

		ELSE

			_fejl_ndims := 1;
			_fejl_ndims_pretty := (SELECT dim.navn_pretty FROM sandbox.kontrol_lst_dimensioner dim WHERE dim.zm_flag = _zm_flag AND dim.aktiv IS TRUE);

		END IF;


		IF _zm_flag > 0 THEN

			_geom := ST_Force3DZ(
						CASE
							WHEN ST_NumGeometries(_geom) = 1
							THEN ST_GeometryN(_geom, 1)
							ELSE _geom
						END
						,-99
					);

		END IF;



	--
	-- Singlegeometri
	--

		IF ST_NumGeometries(_geom) = 1 THEN

			_fejl_singlegeom := 0;
			_fejl_singlegeom_pretty := (SELECT jn.navn_pretty FROM sandbox.kontrol_lst_ja_nej jn WHERE jn.fid = 1);

		ELSE

			_fejl_singlegeom := 1;
			_fejl_singlegeom_pretty := (SELECT jn.navn_pretty FROM sandbox.kontrol_lst_ja_nej jn WHERE jn.fid = 0);

		END IF;



	--
	-- Geometritype
	--

		SELECT
			gt.fid
			,gt.navn
/*			,CASE
				WHEN g.type = gt.pg_geometritype
				THEN gt.navn_pretty
				WHEN g.type ~* 'MULTI'
				THEN 'Multi' || gt.navn_pretty
				-- Backup, bør aldrig komme i brug
				ELSE INITCAP(
						regexp_replace(
							gt.navn_pretty
							,'^MULTI'
							,''
							,'i'
						)
					)
			END AS _geometritype_pretty
*/			,gt.navn_pretty
			,gt.navn_short
			,gt._order
			,gt.pg_geometritype

		FROM sandbox.kontrol_lst_geometrityper gt
			,GeometryType(_geom) g(type)
		WHERE g.type ~* gt.pg_geometritype
		ORDER BY (g.type = gt.pg_geometritype)::int DESC
		LIMIT 1
		INTO _geom_geometritype_fid
			,_geom_geometritype
			,_geom_geometritype_pretty
			,_geom_geometritype_short
			,_geom_geometritype_order
			,_geom_pg_geometritype;


		IF _geom_pg_geometritype = _pg_geometritype THEN

			_fejl_geometritype := 0;
			_fejl_geometritype_pretty := _geom_geometritype_pretty;

			_geom_geometritype_fid := NULL;
			_geom_geometritype := NULL;
			_geom_geometritype_pretty := NULL;
			_geom_geometritype_short := NULL;
			_geom_geometritype_order := NULL;
			_geom_pg_geometritype := NULL;

		ELSE

			_fejl_geometritype := 1;
			_fejl_geometritype_pretty := _geom_geometritype_pretty;

		END IF;



	--
	-- Valid
	--

		IF ST_IsValid(_geom) THEN

			_fejl_valid := 0;
			_fejl_valid_pretty := 'Ingen geometrifejl';

		ELSE

			_fejl_valid := 1;
			_fejl_valid_pretty := COALESCE(ST_IsValidReason(_geom), 'Geometrifejl');

		END IF;



	--
	-- Mængde
	--

		IF COALESCE(_geom_pg_geometritype, _pg_geometritype) ~* 'POINT$' THEN

			_mgd_enhed := 'stk';
			_mgd_type = 'Antal (' || _mgd_enhed || ')';
			_mgd = ST_NumGeometries(_geom)::numeric;
			_mgd_pretty = _mgd || ' ' || _mgd_enhed;


		ELSIF COALESCE(_geom_pg_geometritype, _pg_geometritype) ~* 'LINESTRING$' THEN

			_mgd_enhed := 'm';
			_mgd_type = 'Længde (' || _mgd_enhed || ')';
			_mgd = ROUND(ST_Length(_geom)::numeric, 4)::double precision;
			_mgd_pretty = ROUND(_mgd::numeric, 2)::double precision || ' ' || _mgd_enhed;


			IF _mgd > 0.05 THEN

				_fejl_min_mgd := 0;
				_fejl_min_mgd_pretty := 'Geometri med længde over 0.05 ' || _mgd_enhed;

			ELSE

				_fejl_min_mgd := 1;
				_fejl_min_mgd_pretty := 'Geometri med længde under 0.05 ' || _mgd_enhed;

			END IF;

		ELSIF COALESCE(_geom_pg_geometritype, _pg_geometritype) ~* 'POLYGON$' THEN

			_mgd_enhed := 'm²';
			_mgd_type = 'Areal (' || _mgd_enhed || ')';
			_mgd = ROUND(ST_Area(_geom)::numeric, 4)::double precision;
			_mgd_pretty = ROUND(_mgd::numeric, 2)::double precision || ' ' || _mgd_enhed;


			IF _mgd > 0.05 THEN

				_fejl_min_mgd := 0;
				_fejl_min_mgd_pretty := 'Geometri med areal over 0.05 ' || _mgd_enhed;

			ELSE

				_fejl_min_mgd := 1;
				_fejl_min_mgd_pretty := 'Geometri med areal under 0.05 ' || _mgd_enhed;

			END IF;

		END IF;



	--
	-- Koordinater (Kun, hvis NDims = 3)
	--

		IF _fejl_ndims = 0
			AND _zm_flag > 0
		THEN

			-- COUNT koordinater
			-- Min Max uden -99
			SELECT
				-- Antal
				COUNT(*) AS z_count

				-- 0
				,COUNT(
					CASE
						WHEN ST_Z(d.geom) = 0
						THEN 1
					END
				) AS z_0_count

				-- -99
				,COUNT(
					CASE
						WHEN ST_Z(d.geom) = -99
						THEN 1
					END
				) AS z_99_count

				-- NaN
				,COUNT(
					CASE
						WHEN ST_Z(d.geom) = 'NaN'::numeric
						THEN 1
					END
				) AS z_nan_count

				-- Min/Max
				,ROUND(
					MIN(
						CASE
							WHEN NOT(
									ST_Z(d.geom) = -99
									OR ST_Z(d.geom) = 'NaN'::numeric
								)
							THEN ST_Z(d.geom)
						END
					)::numeric
					,4
				)::double precision AS z_min
				,ROUND(
					MAX(
						CASE
							WHEN NOT(
									ST_Z(d.geom) = -99
									OR ST_Z(d.geom) = 'NaN'::numeric
								)
							THEN ST_Z(d.geom)
						END
					)::numeric
					,4
				)::double precision AS z_max
			FROM ST_DumpPoints(_geom) d
			INTO _z_count
				,_z_0_count
				,_z_99_count
				,_z_nan_count

				,_z_min
				,_z_max;



			-- 0
			IF _z_0_count = 0 THEN

				_fejl_z_0 := 0;
				_fejl_z_0_pretty := 'Ingen "0"-Z-koordinater';

			ELSIF _z_0_count > 0 THEN

				_fejl_z_0 := -1;
				_fejl_z_0_pretty := '"0"-Z-koordinater';

			END IF;



			-- -99
			IF _z_99_count = 0 THEN

				_fejl_z_99 := 0;
				_fejl_z_99_pretty := 'Ingen ukendte (-99) Z-koordinater';

			ELSIF _z_99_count > 0
				AND _foer_skaering IS TRUE
			THEN

				-- _fejl_z_99 := -1;
				_fejl_z_99 := 0;
				_fejl_z_99_pretty := 'Ukendte (-99) Z-koordinater før skæringsdatoen';

			ELSIF _z_99_count > 0 THEN

				_fejl_z_99 := 1;
				_fejl_z_99_pretty := 'Ukendte (-99) Z-koordinater efter skæringsdatoen';

			END IF;



			-- NaN
			IF _z_nan_count = 0 THEN

				_fejl_z_nan := 0;
				_fejl_z_nan_pretty := 'Ingen "NaN"-Z-koordinater';

			ELSIF _z_nan_count > 0 THEN

				_fejl_z_nan := 1;
				_fejl_z_nan_pretty := '"NaN"-Z-koordinater';

			END IF;



			-- High / Low
			IF _z_min < -50 OR _z_max > 200 THEN

				_fejl_z_high_low := 1;
				_fejl_z_high_low_pretty := 'Urealistiske Z-koordinater';

			ELSE

				-- _fejl_z_high_low := 0;
				-- _fejl_z_high_low_pretty := 'Ingen alt for høje/lave Z-koordinater';
				_fejl_z_high_low := NULL;
				_fejl_z_high_low_pretty := NULL;

			END IF;

		END IF;



	END IF;


--
-- XML
--

	SELECT

		(E'<geometry>\n'
			|| string_agg(
					FORMAT(
						CASE
							WHEN xml_lst[g][3] IS NULL
							THEN $$	<%1$s%3$s/>$$
							ELSE $$	<%1$s%3$s>%2$s</%1$s>$$
						END

						,xml_lst[g][1]
						-- ,xml_lst[g][3]
						,sandbox.kontrol_xml_encode(xml_lst[g][3])

						,' fejl="' || xml_lst[g][2] || '"'
					)
					,E'\n'
					ORDER BY g
				)
			|| E'\n</geometry>')::xml
	FROM (
			SELECT
				ARRAY[
					 ARRAY['mgd_type'	,NULL::text	,_mgd_type]
					,ARRAY['mgd'		,NULL::text	,_mgd::text]
					,ARRAY['mgd_enhed'	,NULL::text	,_mgd_enhed]
					,ARRAY['mgd_pretty'	,NULL::text	,_mgd_pretty]

					,ARRAY['z_min'		,NULL::text	,_z_min::text]
					,ARRAY['z_max'		,NULL::text	,_z_max::text]
					,ARRAY['z_min_max'	,NULL::text	,CASE
														WHEN _z_min = _z_max
														THEN _z_max::text
														ELSE _z_min || ' - ' || _z_max
													END
						]

					,ARRAY['z_count'		,NULL::text	,_z_count::text]
					,ARRAY['z_0_count'		,NULL::text	,_z_0_count::text]
					,ARRAY['z_99_count'		,NULL::text	,_z_99_count::text]
					,ARRAY['z_nan_count'	,NULL::text	,_z_nan_count::text]


					,ARRAY['z_0'			,_fejl_z_0::text			,_fejl_z_0_pretty]
					,ARRAY['z_99'			,_fejl_z_99::text			,_fejl_z_99_pretty]
					,ARRAY['z_nan'			,_fejl_z_nan::text			,_fejl_z_nan_pretty]
					,ARRAY['z_high_low'		,_fejl_z_high_low::text		,_fejl_z_high_low_pretty]
					,ARRAY['no_geom'		,_fejl_no_geom::text		,_fejl_no_geom_pretty]
					,ARRAY['srid'			,_fejl_srid::text			,_fejl_srid_pretty]
					,ARRAY['ndims'			,_fejl_ndims::text			,_fejl_ndims_pretty]
					,ARRAY['singlegeom'		,_fejl_singlegeom::text		,_fejl_singlegeom_pretty]
					,ARRAY['geometritype'	,_fejl_geometritype::text	,_fejl_geometritype_pretty]
					,ARRAY['valid'			,_fejl_valid::text			,_fejl_valid_pretty]
					,ARRAY['min_mgd'		,_fejl_min_mgd::text		,_fejl_min_mgd_pretty]


					
				] AS xml_lst
		) a
		,generate_series(1, array_length(xml_lst, 1)) g
	WHERE xml_lst[g][3] IS NOT NULL
	INTO _geom_xml;


	RETURN;

EXCEPTION
	WHEN internal_error THEN

	IF SQLERRM = 'geometry requires more points' THEN

		_error_geom_handling := SUBSTRING(
									_geom_wkt
									,'^.+?\(+([\d\s\.]+)[,\)].*$'
								);

		IF _error_geom_handling IS NOT NULL THEN

			_geom_wkt := FORMAT(
							'POINT(%s)'
							,_error_geom_handling
						);

			_geom := CASE
						WHEN COALESCE(_crs, _srid) IS NOT NULL
						THEN ST_Transform(
								ST_GeomFromText(_geom_wkt, COALESCE(_crs, _srid))
								,25832
							)
						ELSE ST_GeomFromText(_geom_wkt, 25832)
					END;

			SELECT
				gt.fid
				,gt.navn
				,CASE
					WHEN g.type = gt.pg_geometritype
					THEN gt.navn_pretty
					WHEN g.type ~* 'MULTI'
					THEN 'Multi' || gt.navn_pretty
					-- Backup, bør aldrig komme i brug
					ELSE INITCAP(
							regexp_replace(
								gt.navn_pretty
								,'^MULTI'
								,''
								,'i'
							)
						)
				END AS _geometritype_pretty
				,gt.navn_short
				,gt._order
				,gt.pg_geometritype

			FROM sandbox.kontrol_lst_geometrityper gt
				,GeometryType(_geom) g(type)
			WHERE g.type ~* gt.pg_geometritype
			ORDER BY (g.type = gt.pg_geometritype)::int DESC
			LIMIT 1
			INTO _geom_geometritype_fid
				,_geom_geometritype
				,_geom_geometritype_pretty
				,_geom_geometritype_short
				,_geom_geometritype_order
				,_geom_pg_geometritype;

		END IF;

	END IF;

SELECT

	(E'<geometry>\n'
		|| string_agg(
				FORMAT(
					CASE
						WHEN xml_lst[g][3] IS NULL
						THEN $$	<%1$s%3$s/>$$
						ELSE $$	<%1$s%3$s>%2$s</%1$s>$$
					END

					,xml_lst[g][1]
					-- ,xml_lst[g][3]
					,sandbox.kontrol_xml_encode(xml_lst[g][3])

					,' fejl="' || xml_lst[g][2] || '"'
				)
				,E'\n'
				ORDER BY g
			)
		|| E'\n</geometry>')::xml
FROM (
		SELECT
			ARRAY[
				 ARRAY['valid'			,1::text			,SQLERRM]
			] AS xml_lst
	) a
	,generate_series(1, array_length(xml_lst, 1)) g
WHERE xml_lst[g][3] IS NOT NULL
INTO _geom_xml;

	RETURN;

END $BODY$;