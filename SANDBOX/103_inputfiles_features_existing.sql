/* DROP FUNCTION IF EXISTS sandbox.kontrol_inputfiles_features_existing(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_inputfiles_features_existing(
	_kontrol_guid uuid
)
	RETURNS VOID
	-- RETURNS TABLE(
		-- inputfile_fid integer
		-- ,inputfile_id text
		-- ,inputfile text
		-- ,inputfile_pretty text
		-- ,inputfile_order integer


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

		-- ,snap_kontrol boolean
		-- ,snap_reference boolean

		-- ,forsyningsart_color_hex text

		-- ,feature_fid integer
		-- ,feature_group text
		-- ,feature_etablering date
		-- ,feature_etablering_foer_skaering boolean
		-- ,feature_eksisterende integer

		-- ,geom geometry(GEOMETRY, 25832)
		-- ,attributes_xml xml
		-- ,geom_xml xml

		-- ,geom_geometritype_fid integer
		-- ,geom_geometritype text
		-- ,geom_geometritype_pretty text
		-- ,geom_geometritype_short text
		-- ,geom_geometritype_order integer
		-- ,geom_pg_geometritype text
	-- )
	-- STABLE
	VOLATILE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	DELETE FROM sandbox.kontrol_inputfiles_features_existing k
		WHERE k.kontrol_guid = _kontrol_guid;


	IF EXISTS(
		SELECT
			'1'
		FROM sandbox.kontrol_xml k
		WHERE guid = _kontrol_guid
			AND ((xpath('/kontrolLER/existingFromDB/text()', k._xml::xml))[1])::text = '1'
	) THEN

			-- RETURN QUERY
			WITH

				feature_extent AS(
					SELECT
						f.system_fid
						,f.system
						,f.system_pretty
						,f.system_order
						,f.forsyningsart_fid
						,f.forsyningsart
						,f.forsyningsart_pretty
						,f.forsyningsart_order

						,f.forsyningsart_color_hex

						,ST_Simplify(
							ST_ConcaveHull(
								ST_Union(
									ST_Buffer(f.geom, 15)
								)
								,0.5
							)
							,10
						) AS geom
					-- FROM sandbox.kontrol_inputfiles_features(
							-- _kontrol_guid := _kontrol_guid
					-- ) f
					FROM sandbox.kontrol_inputfiles_features f
					WHERE f.kontrol_guid = _kontrol_guid
					GROUP BY f.system_fid
						,f.system
						,f.system_pretty
						,f.system_order
						,f.forsyningsart_fid
						,f.forsyningsart
						,f.forsyningsart_pretty
						,f.forsyningsart_order

						,f.forsyningsart_color_hex
				)



			INSERT INTO sandbox.kontrol_inputfiles_features_existing
			SELECT
				_kontrol_guid
				,a.*
			FROM (
					SELECT
						ef.inputfile_fid
						,e.navn AS inputfile_id
						,'pgEksisterende' AS inputfile
						,e.navn_pretty AS inputfile_pretty
						,ef.inputfile_fid AS inputfile_order

						,COALESCE(ft.featuretype_fid, ef.featuretype_fid) AS featuretype_fid
						,COALESCE(ft.featuretype, _ft_.navn_lst[1]) AS featuretype
						,COALESCE(ft.featuretype_pretty, _ft_.navn_pretty) AS featuretype_pretty
						,COALESCE(ft.featuretype_order, _ft_._order) AS featuretype_order


						,f.system_fid
						,f.system
						,f.system_pretty
						,f.system_order

						,f.forsyningsart_fid
						,f.forsyningsart
						,f.forsyningsart_pretty
						,f.forsyningsart_order

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


						,COALESCE(ft.dimension, _ft_.dimension) AS dimension
						,COALESCE(ft.dimension_pretty, dim.navn_pretty) AS dimension_pretty
						,COALESCE(ft.dimension_zm_flag, dim.zm_flag) AS dimension_zm_flag


						,FALSE AS snap_kontrol
						,FALSE AS snap_reference

						,f.forsyningsart_color_hex


						,ef.feature_fid
						,t.feature_group
						,NULL::date AS feature_etablering
						,NULL::boolean AS feature_etablering_foer_skaering
						,1 AS feature_eksisterende

						,ef.geom
						,ef.attributes_xml
						,NULL::xml AS geom_xml

						,NULL::integer AS geom_geometritype_fid
						,NULL::text AS geom_geometritype
						,NULL::text AS geom_geometritype_pretty
						,NULL::text AS geom_geometritype_short
						,NULL::integer AS geom_geometritype_order
						,NULL::text AS geom_pg_geometritype

					FROM feature_extent f
					INNER JOIN sandbox.kontrol_lst_eksisterende e ON e.system = f.system
						AND e.forsyningsart = f.forsyningsart
						AND e.aktiv IS TRUE
					INNER JOIN sandbox.kontrol_existing_features(
							_eksisterende_fid := e.fid
							,_bounds := f.geom
						) ef ON TRUE


					INNER JOIN sandbox.kontrol_lst_featuretyper _ft_ ON _ft_.fid = ef.featuretype_fid
						AND _ft_.aktiv IS TRUE


					INNER JOIN sandbox.kontrol_lst_grupper grp ON grp.navn = _ft_.gruppe
						AND grp.aktiv IS TRUE

					INNER JOIN sandbox.kontrol_lst_geometrityper gt ON gt.navn = e.geometritype
						AND gt.aktiv IS TRUE

					INNER JOIN sandbox.kontrol_lst_dimensioner dim ON dim.navn = _ft_.dimension
						AND dim.aktiv IS TRUE


					-- Find evt. specifik featuretype
					LEFT JOIN LATERAL(
							SELECT
								ft.fid AS featuretype_fid
								,ft.navn_lst[1] AS featuretype
								,ft.navn_pretty AS featuretype_pretty
								,ft._order AS featuretype_order


								,ft.dimension
								,dim.navn_pretty AS dimension_pretty
								,dim.zm_flag AS dimension_zm_flag

								,ft.group_column
							FROM sandbox.kontrol_featuretype_attributes(
									CASE
										WHEN _ft_.navn_lst[1] IS NULL
										THEN ef.featuretype_fid
									END
								) ft_a
							INNER JOIN UNNEST(ft_a.attr_lst) WITH ORDINALITY lst(attr,_order) ON TRUE
							LEFT JOIN xmltable(
									('/attributes/' || lst.attr) passing ef.attributes_xml
										COLUMNS
											attr text path 'text()'
								) t ON TRUE
							LEFT JOIN sandbox.kontrol_lst_featuretyper ft ON ft.fid != ef.featuretype_fid
								AND ft.forsyningsart = f.forsyningsart
								AND ft.gruppe = _ft_.gruppe
								AND e.geometritype = ANY(_ft_.geometrityper_lst)
								AND COALESCE(t.attr, ft_a.default_value) = ANY(ft.navn_lst)

							INNER JOIN sandbox.kontrol_lst_dimensioner dim ON dim.navn = ft.dimension
								AND dim.aktiv IS TRUE

							WHERE ft_a.attr = _ft_.group_column
							ORDER BY lst._order
							LIMIT 1
					) ft ON TRUE


					LEFT JOIN xmltable(
							'/*' passing ef.attributes_xml
								COLUMNS
									feature_group text path COALESCE('/attributes/' || COALESCE(ft.group_column, _ft_.group_column) || '/text()', '/no/value')
						) t ON TRUE
				) a;

	-- ELSE

		-- RETURN QUERY
		-- SELECT
			-- NULL::integer AS inputfile_fid
			-- ,NULL::text AS inputfile_id
			-- ,NULL::text AS inputfile
			-- ,NULL::text AS inputfile_pretty
			-- ,NULL::integer AS inputfile_order


			-- ,NULL::integer AS featuretype_fid
			-- ,NULL::text AS featuretype
			-- ,NULL::text AS featuretype_pretty
			-- ,NULL::integer AS featuretype_order


			-- ,NULL::integer AS system_fid
			-- ,NULL::text AS system
			-- ,NULL::text AS system_pretty
			-- ,NULL::integer AS system_order

			-- ,NULL::integer AS forsyningsart_fid
			-- ,NULL::text AS forsyningsart
			-- ,NULL::text AS forsyningsart_pretty
			-- ,NULL::integer AS forsyningsart_order

			-- ,NULL::integer AS gruppe_fid
			-- ,NULL::text AS gruppe
			-- ,NULL::text AS gruppe_pretty
			-- ,NULL::integer AS gruppe_order

			-- ,NULL::integer AS geometritype_fid
			-- ,NULL::text AS geometritype
			-- ,NULL::text AS geometritype_pretty
			-- ,NULL::text AS geometritype_short
			-- ,NULL::integer AS geometritype_order
			-- ,NULL::text AS pg_geometritype


			-- ,NULL::text AS dimension
			-- ,NULL::text AS dimension_pretty
			-- ,NULL::integer AS dimension_zm_flag

			-- ,NULL::boolean AS snap_kontrol
			-- ,NULL::boolean AS snap_reference

			-- ,NULL::text AS forsyningsart_color_hex

			-- ,NULL::integer AS feature_fid
			-- ,NULL::text AS feature_group
			-- ,NULL::date AS feature_etablering
			-- ,NULL::boolean AS feature_etablering_foer_skaering
			-- ,NULL::integer AS feature_eksisterende

			-- ,NULL::geometry(GEOMETRY, 25832) AS geom
			-- ,NULL::xml AS attributes_xml
			-- ,NULL::xml AS geom_xml

			-- ,NULL::integer AS geom_geometritype_fid
			-- ,NULL::text AS geom_geometritype
			-- ,NULL::text AS geom_geometritype_pretty
			-- ,NULL::text AS geom_geometritype_short
			-- ,NULL::integer AS geom_geometritype_order
			-- ,NULL::text AS geom_pg_geometritype
		-- LIMIT 0;

	END IF;


END $BODY$;
