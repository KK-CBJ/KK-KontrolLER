/* DROP FUNCTION IF EXISTS sandbox.kontrol_outputfile_leaflet_var_json(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_outputfile_leaflet_var_json(
	_kontrol_guid uuid
)
	RETURNS TABLE(
		leaflet_json_id text

		,leaflet_popup_id text

		,leaflet_style_id text

		,leaflet_layer_id text
		,leaflet_overlay_id text
		,leaflet_layer_cluster_id text
		,leaflet_layer_pretty text
		,leaflet_layer_order integer

		,leaflet_fid integer
		,leaflet_id text


		,featuretype_fid integer
		,featuretype text
		,featuretype_pretty text
		,featuretype_order integer


		,system_fid integer
		,system text
		,system_pretty text
		,system_order integer

		,forsyningsart_fid integer
		,forsyningsart text
		,forsyningsart_pretty text
		,forsyningsart_order integer

		,gruppe_fid integer
		,gruppe text
		,gruppe_pretty text
		,gruppe_order integer

		,geometritype_fid integer
		,geometritype text
		,geometritype_pretty text
		,geometritype_short text
		,geometritype_order integer
		,pg_geometritype text


		,forsyningsart_color_hex text
		,snap_color_hex text
		,featuretype_gruppe_color_hex text


		,featuretype_gruppe_js_style text
		,featuretype_gruppe_js_svg_legend text

		,var_json text
		,var_eksisterende integer
		,var_fejl integer
	)
	STABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	RETURN QUERY
	WITH

		features_1 AS(
			SELECT
				f.inputfile_fid
				,f.inputfile_order

				,f.featuretype_fid
				,f.featuretype
				,f.featuretype_pretty
				,f.featuretype_order


				,f.system_fid
				,f.system
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe
				,f.gruppe_pretty
				,f.gruppe_order

				,f.geometritype_fid
				,f.geometritype
				,f.geometritype_pretty
				,f.geometritype_short
				,f.geometritype_order
				,f.pg_geometritype

				,f.geom_geometritype_fid
				,f.geom_geometritype
				,f.geom_geometritype_pretty
				,f.geom_geometritype_short
				,f.geom_geometritype_order
				,f.geom_pg_geometritype


				,f.forsyningsart_color_hex
				,NULL::text AS snap_color_hex


				,f.feature_group
				,f.feature_fid
				,u.kontrol_id

				,f.geom AS geom
				,ARRAY[
					CASE
						WHEN f.feature_eksisterende = 1
						THEN NULL
						ELSE f.attributes_xml
					END
					,CASE
						WHEN f.feature_eksisterende = 1
						THEN NULL
						ELSE f.geom_xml
					END
					,FORMAT(
$$<feature>
	<inputfile>%s</inputfile>
	<inputfile_id>%s</inputfile_id>
	<fid>%s</fid>
	<group>%s</group>
	<etablering_foer_skaering>%s</etablering_foer_skaering>
	<eksisterende>%s</eksisterende>
	<eksisterende_popup>%s</eksisterende_popup>
	<eksisterende_class>%s</eksisterende_class>
</feature>$$
						,sandbox.kontrol_xml_encode(f.inputfile_pretty)
						,sandbox.kontrol_xml_encode(f.inputfile_id)
						,f.feature_fid
						,sandbox.kontrol_xml_encode(f.feature_group)
						,f.feature_etablering_foer_skaering::integer
						,f.feature_eksisterende
						,(SELECT jn.navn_pretty FROM sandbox.kontrol_lst_ja_nej jn WHERE jn.fid = f.feature_eksisterende)
						,CASE
							WHEN f.feature_eksisterende = 1
							THEN 'svgGeomExist'
						END
					)::xml
				] AS _xml

				,f.feature_eksisterende AS var_eksisterende
			FROM (
					SELECT
						*
					-- FROM sandbox.kontrol_inputfiles_features(
							-- _kontrol_guid := _kontrol_guid
					-- ) f
					FROM sandbox.kontrol_inputfiles_features f
					WHERE f.kontrol_guid = _kontrol_guid
						AND f.geom IS NOT NULL

					UNION ALL

					SELECT
						*
					-- FROM sandbox.kontrol_inputfiles_features_existing(
							-- _kontrol_guid := _kontrol_guid
					-- ) f
					FROM sandbox.kontrol_inputfiles_features_existing f
					WHERE f.kontrol_guid = _kontrol_guid
				) f
				,xmltable(
					'/*' passing f.attributes_xml
						COLUMNS
							kontrol_id text path '@fid'
				) u
			WHERE f.geom IS NOT NULL

			UNION ALL

			SELECT
				f.inputfile_fid
				,f.inputfile_order

				,f.snap_featuretype_fid AS featuretype_fid
				,f.snap_featuretype AS featuretype
				,f.snap_featuretype_pretty AS featuretype_pretty
				,f.snap_featuretype_order AS featuretype_order


				,f.system_fid
				,f.system
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.snap_gruppe_fid AS gruppe_fid
				,f.snap_gruppe AS gruppe
				,f.snap_gruppe_pretty AS gruppe_pretty
				,f.snap_gruppe_order AS gruppe_order

				,f.geometritype_fid
				,f.geometritype
				,f.geometritype_pretty
				,f.geometritype_short
				,f.geometritype_order
				,f.pg_geometritype

				,NULL::int AS geom_geometritype_fid
				,NULL::text AS geom_geometritype
				,NULL::text AS geom_geometritype_pretty
				,NULL::text AS geom_geometritype_short
				,NULL::int AS geom_geometritype_order
				,NULL::text AS geom_pg_geometritype


				,f.forsyningsart_color_hex
				,f.snap_color_hex


				,NULL::text AS feature_group
				,ROW_NUMBER() OVER()::integer AS feature_fid
				,f.feature_fid AS kontrol_id

				,f.geom
				,NULL::xml[] AS _xml

				,0 AS var_eksisterende
			-- FROM sandbox.kontrol_inputfiles_features_snap(
					-- _kontrol_guid := _kontrol_guid
			-- ) f
			FROM sandbox.kontrol_inputfiles_features_snap f
			WHERE f.kontrol_guid = _kontrol_guid
		)

		,features AS(
			SELECT DISTINCT ON(f.inputfile_fid, f.gruppe_fid, f.feature_fid)

				'json_' || array_to_string(leaflet.id, '_')
					|| CASE
							WHEN f.var_eksisterende = 1
							THEN '_eksisterende'
							ELSE ''
						END AS leaflet_json_id

				,CASE
					WHEN f.gruppe != 'snap'
						AND f.var_eksisterende = 0
					THEN 'pop_' || array_to_string(leaflet.id[1:5], '_')
				END AS leaflet_popup_id

				,CASE
					WHEN NOT(COALESCE(f.geom_pg_geometritype, f.pg_geometritype) ~* 'POINT')
					THEN 'style_' || array_to_string(leaflet.id, '_')
				END AS leaflet_style_id

				,'layer_' || array_to_string(leaflet.id, '_')
					|| CASE
							WHEN f.var_eksisterende = 1
							THEN '_eksisterende'
							ELSE ''
						END AS leaflet_layer_id
				,'overlay_' || array_to_string(leaflet.id, '_') AS leaflet_overlay_id
				,CASE
					WHEN COALESCE(f.geom_pg_geometritype, f.pg_geometritype) ~* 'POINT'
						AND f.gruppe != 'snap'
					THEN 'layer_' || array_to_string(leaflet.id[1:6], '_') || '_cluster'
				END AS leaflet_layer_cluster_id
				,CASE
					WHEN COALESCE(fg.navn, fg_fallback.navn, f.featuretype) IS NOT NULL
					THEN COALESCE(fg.navn_pretty, fg_fallback.navn_pretty, f.featuretype_pretty)
					-- ELSE f.gruppe_pretty
				END AS leaflet_layer_pretty
				-- ,DENSE_RANK() OVER(ORDER BY f.featuretype_order, COALESCE(f.geom_geometritype_order, f.geometritype_order), (COALESCE(fg.navn, fg_fallback.navn, f.featuretype) IS NOT NULL)::integer, COALESCE(fg.navn_pretty, fg_fallback.navn_pretty, f.featuretype_pretty))::integer AS leaflet_layer_order
				,DENSE_RANK() OVER(
								ORDER BY
									f.system_order
									,f.forsyningsart_order
									,f.gruppe_order
									,COALESCE(f.geom_geometritype_order, f.geometritype_order)
									,f.featuretype_order
									,(COALESCE(fg.navn, fg_fallback.navn, f.featuretype) IS NOT NULL)::integer
									,COALESCE(fg.navn_pretty, fg_fallback.navn_pretty, f.featuretype_pretty)
								)::integer AS leaflet_layer_order

				,DENSE_RANK() OVER(ORDER BY leaflet.id)::integer AS leaflet_fid
				,array_to_string(leaflet.id, '_') AS leaflet_id
				,ROW_NUMBER() OVER(PARTITION BY leaflet.id ORDER BY f.inputfile_order, f.feature_fid)::integer AS leaflet_feature_fid


				,f.featuretype_fid
				,f.featuretype
				,f.featuretype_pretty
				,f.featuretype_order


				,f.system_fid
				,f.system
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe
				,f.gruppe_pretty
				,f.gruppe_order

				,COALESCE(f.geom_geometritype_fid, f.geometritype_fid) AS geometritype_fid
				,COALESCE(f.geom_geometritype, f.geometritype) AS geometritype
				,COALESCE(f.geom_geometritype_pretty, f.geometritype_pretty) AS geometritype_pretty
				,COALESCE(f.geom_geometritype_short, f.geometritype_short) AS geometritype_short
				,COALESCE(f.geom_geometritype_order, f.geometritype_order) AS geometritype_order
				,COALESCE(f.geom_pg_geometritype, f.pg_geometritype) AS pg_geometritype


				,f.forsyningsart_color_hex
				,f.snap_color_hex
				,COALESCE(fg.color_hex, fg_fallback.color_hex) AS featuretype_gruppe_color_hex

				,f.kontrol_id


				,COALESCE(fg.js_style, fg_fallback.js_style) AS featuretype_gruppe_js_style
				,COALESCE(fg.js_svg_legend, fg_fallback.js_svg_legend, fg.js_style, fg_fallback.js_style) AS featuretype_gruppe_js_svg_legend

				,ST_Transform(ST_Force2D(f.geom), 4326) AS geom
				,f._xml

				,f.var_eksisterende
			FROM features_1 f
			INNER JOIN sandbox.kontrol_lst_featuretype_grupper fg ON fg.aktiv IS TRUE
				AND fg.geometritype = COALESCE(f.geom_geometritype, f.geometritype)
				AND (
					fg.system = f.system
					OR fg.system IS NULL
				) AND (
					fg.forsyningsart = f.forsyningsart
					OR fg.forsyningsart IS NULL
				) AND (
					fg.gruppe = f.gruppe
					OR fg.gruppe IS NULL
				) AND (
					-- COALESCE(COALESCE(f.feature_group, f.featuretype) = ANY(fg.navn_lst), FALSE)
					COALESCE(f.feature_group = ANY(ARRAY[fg.navn] || fg.navn_lst), FALSE)
					OR COALESCE(f.featuretype = ANY(ARRAY[fg.navn] || fg.navn_lst), FALSE)
					OR NULLIF(fg.navn_lst, '{}') IS NULL
				)
			INNER JOIN sandbox.kontrol_lst_featuretype_grupper fg_fallback ON fg_fallback.aktiv IS TRUE
				AND fg_fallback.geometritype = COALESCE(f.geom_geometritype, f.geometritype)
				AND fg_fallback.system IS NULL
				AND fg_fallback.forsyningsart IS NULL
				AND fg_fallback.gruppe IS NULL
				AND NULLIF(fg_fallback.navn_lst, '{}') IS NULL

			INNER JOIN array_remove(
					ARRAY[
						'ft_' || f.featuretype_fid
						,'grp_' || f.gruppe_fid
						,LOWER(f.system)
						,LOWER(f.forsyningsart)
						,LOWER(f.gruppe)
						,LOWER(f.geometritype)
						,'_' || COALESCE(COALESCE(fg.fid, fg_fallback.fid) || '_' || LOWER(COALESCE(fg.navn, fg_fallback.navn)), LOWER(f.featuretype))
						,'_as_' || LOWER(f.geom_geometritype)
					]
					,NULL
				) leaflet(id) ON TRUE
			ORDER BY f.inputfile_fid
					,f.gruppe_fid
					,f.feature_fid
					,array_length(
						array_remove(
							ARRAY[
								fg.system
								,fg.forsyningsart
								,fg.gruppe
								,NULLIF(fg.navn_lst, '{}')::text
							]
							,NULL
						)
						,1
					)
					,COALESCE(fg._order, fg_fallback._order)
					,fg.fid IS NOT NULL DESC
					,COALESCE(f.feature_group = ANY(fg.navn_lst), FALSE) DESC
					,COALESCE(f.featuretype = ANY(fg.navn_lst), FALSE) DESC
					,NULLIF(fg.navn_lst, '{}') IS NULL DESC
		)





		,features_frame_1 AS(
			SELECT
				fg.navn AS system
				,fg.navn_pretty AS system_pretty

				,gt.fid AS geometritype_fid
				,gt.navn AS geometritype
				,gt.navn_pretty AS geometritype_pretty
				,gt.navn_short AS geometritype_short
				,gt._order AS geometritype_order
				,gt.pg_geometritype


				,fg.color_hex AS featuretype_gruppe_color_hex


				,fg.js_style AS featuretype_gruppe_js_style
				,COALESCE(fg.js_svg_legend, fg.js_style) AS featuretype_gruppe_js_svg_legend

				,ST_Union(
					ST_Scale(
						t.geom
						,ST_GeomFromText('POINT(1.25 1.25)')
						,ST_Centroid(t.geom)
					)
				) AS geom

			-- FROM sandbox.kontrol_inputfiles(
					-- _kontrol_guid := _kontrol_guid
			-- ) f
			FROM sandbox.kontrol_inputfiles f
			INNER JOIN sandbox.kontrol_lst_geometrityper gt ON gt.aktiv IS TRUE
				AND gt.navn IN('polygon', 'Polygon')
			INNER JOIN sandbox.kontrol_lst_featuretype_grupper fg ON fg.aktiv IS TRUE
				AND fg.geometritype = gt.navn
				AND fg.navn = '__frame__'

			INNER JOIN ST_Transform(
					f.inputfile_feature_bounds
					,4326
				) t(geom) ON TRUE
			WHERE f.kontrol_guid = _kontrol_guid
				AND f.fejl = 0
			GROUP BY 1
				,2
				,3
				,4
				,5
				,6
				,7
				,8
				,9
				,10
				,11
		)


		,features_frame AS(
			SELECT
				'json_' || f.system AS leaflet_json_id

				,NULL::text AS leaflet_popup_id

				,'style_' || f.system AS leaflet_style_id

				,'layer_' || f.system AS leaflet_layer_id
				,'overlay_' || f.system AS leaflet_overlay_id
				,NULL::text AS leaflet_layer_cluster_id
				,NULL::text AS leaflet_layer_pretty
				,0 AS leaflet_layer_order

				,-9999::integer AS leaflet_fid
				,f.system AS leaflet_id
				,1 AS leaflet_feature_fid


				,NULL::integer AS featuretype_fid
				,f.system AS featuretype
				,NULL::text AS featuretype_pretty
				,NULL::integer AS featuretype_order


				,-9999 AS system_fid
				,f.system
				,f.system_pretty
				,-9999 AS system_order

				,NULL::integer AS forsyningsart_fid
				,NULL::text AS forsyningsart
				,NULL::text AS forsyningsart_pretty
				,NULL::integer AS forsyningsart_order

				,NULL::integer AS gruppe_fid
				,NULL::text AS gruppe
				,NULL::text AS gruppe_pretty
				,NULL::integer AS gruppe_order

				,f.geometritype_fid
				,f.geometritype
				,f.geometritype_pretty
				,f.geometritype_short
				,f.geometritype_order
				,f.pg_geometritype


				,NULL::text AS forsyningsart_color_hex
				,NULL::text AS snap_color_hex
				,f.featuretype_gruppe_color_hex

				,'0' AS kontrol_id


				,f.featuretype_gruppe_js_style
				,f.featuretype_gruppe_js_svg_legend

				,ST_Union(e.geom) AS geom
				,NULL::xml[]

				,0 AS var_eksisterende
			FROM features_frame_1 f
				,ST_Dump(f.geom) dmp
				,ST_Envelope(dmp.geom) e(geom)
			GROUP BY f.system
				,f.system_pretty

				,f.geometritype_fid
				,f.geometritype
				,f.geometritype_pretty
				,f.geometritype_short
				,f.geometritype_order
				,f.pg_geometritype

				,f.featuretype_gruppe_color_hex


				,f.featuretype_gruppe_js_style
				,f.featuretype_gruppe_js_svg_legend
		)





		,features_fejl_1 AS(
			SELECT
				f.leaflet_json_id

				,f.leaflet_layer_id
				,f.leaflet_overlay_id
				,f.leaflet_layer_pretty
				,f.leaflet_layer_order

				,f.leaflet_fid
				,f.leaflet_id
				,f.leaflet_feature_fid


				,f.featuretype_fid
				,f.featuretype_order


				,f.system_fid
				,f.system
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe
				,f.gruppe_pretty
				,f.gruppe_order

				,f.geometritype_fid
				,f.geometritype
				,f.geometritype_pretty
				,f.geometritype_short
				,f.geometritype_order
				,f.pg_geometritype


				,f.forsyningsart_color_hex
				,f.snap_color_hex
				,f.featuretype_gruppe_color_hex

				,f.kontrol_id


				,f.featuretype_gruppe_js_style
				,f.featuretype_gruppe_js_svg_legend

				,f.geom
				,MAX(xml_fejl) AS fejl_max
			FROM features f
				,UNNEST(f._xml) u(_xml)
				,UNNEST(xpath('/*/*/@fejl', u._xml)::text[]::int[]) xml_fejl
			WHERE xml_fejl != 0
				AND f.var_eksisterende = 0
			GROUP BY f.leaflet_json_id

				,f.leaflet_layer_id
				,f.leaflet_overlay_id
				,f.leaflet_layer_pretty
				,f.leaflet_layer_order

				,f.leaflet_fid
				,f.leaflet_id
				,f.leaflet_feature_fid


				,f.featuretype_fid
				,f.featuretype_order


				,f.system_fid
				,f.system
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe
				,f.gruppe_pretty
				,f.gruppe_order

				,f.geometritype_fid
				,f.geometritype
				,f.geometritype_pretty
				,f.geometritype_short
				,f.geometritype_order
				,f.pg_geometritype


				,f.forsyningsart_color_hex
				,f.snap_color_hex
				,f.featuretype_gruppe_color_hex

				,f.kontrol_id


				,f.featuretype_gruppe_js_style
				,f.featuretype_gruppe_js_svg_legend

				,f.geom
		)

		,features_fejl AS(
			SELECT
				f.leaflet_json_id || '_fejl' AS leaflet_json_id

				,NULL::text AS leaflet_popup_id

				,NULL::text AS leaflet_style_id

				,f.leaflet_layer_id || '_fejl' AS leaflet_layer_id
				,f.leaflet_overlay_id
				,NULL::text AS leaflet_layer_cluster_id
				,f.leaflet_layer_pretty
				,-1 * f.leaflet_layer_order AS leaflet_layer_order

				,-1 * f.leaflet_fid AS leaflet_fid
				,f.leaflet_id || '_fejl' AS leaflet_id
				,f.leaflet_feature_fid


				,-1 * f.featuretype_fid AS featuretype_fid
				,'fejl' AS featuretype
				,'Fejl' AS featuretype_pretty
				,-1 * f.featuretype_order AS featuretype_order


				,f.system_fid
				,f.system
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe
				,f.gruppe_pretty
				,f.gruppe_order

				,f.geometritype_fid
				,f.geometritype
				,f.geometritype_pretty
				,f.geometritype_short
				,f.geometritype_order
				,f.pg_geometritype


				,f.forsyningsart_color_hex
				,f.snap_color_hex
				,f.featuretype_gruppe_color_hex

				,f.kontrol_id


				,f.featuretype_gruppe_js_style
				,f.featuretype_gruppe_js_svg_legend

				,CASE
					WHEN f.pg_geometritype ~* 'LINESTRING$'
					THEN ST_LineInterpolatePoint(dmp.geom, 0.5)
					ELSE ST_PointOnSurface(dmp.geom)
				END AS geom
				,ARRAY[
					FORMAT(
$$<fejl>
	<content>%s</content>
	<class>%s</class>
</fejl>$$
						,err.navn_pretty
						,fejl_type || '_pop_init'
					)::xml
				] AS _xml

				,0 AS var_eksisterende
			FROM features_fejl_1 f
				,ST_Dump(f.geom) dmp
				,sandbox.kontrol_lst_fejl err
			WHERE err.navn = f.fejl_max
		)





		,features_direction AS(
			SELECT
				f.leaflet_json_id || '_direction' AS leaflet_json_id

				,NULL::text AS leaflet_popup_id

				,NULL::text AS leaflet_style_id

				,f.leaflet_layer_id || '_direction' AS leaflet_layer_id
				,f.leaflet_overlay_id
				,NULL::text AS leaflet_layer_cluster_id
				,f.leaflet_layer_pretty
				,-1 * f.leaflet_layer_order AS leaflet_layer_order

				,-1 * f.leaflet_fid AS leaflet_fid
				,f.leaflet_id || '_direction' AS leaflet_id
				,f.leaflet_feature_fid


				,-1 * f.featuretype_fid AS featuretype_fid
				,'direction' AS featuretype
				,'Retning' AS featuretype_pretty
				,-1 * f.featuretype_order AS featuretype_order


				,f.system_fid
				,f.system
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe
				,f.gruppe_pretty
				,f.gruppe_order

				,d.geometritype_fid
				,d.geometritype
				,d.geometritype_pretty
				,d.geometritype_short
				,d.geometritype_order
				,d.pg_geometritype


				,f.forsyningsart_color_hex
				,f.snap_color_hex
				,f.featuretype_gruppe_color_hex

				,f.kontrol_id


				,f.featuretype_gruppe_js_style
				,f.featuretype_gruppe_js_svg_legend

				,ST_Transform(d.geom, 4326) AS geom
				,ARRAY[
					d.attributes_xml
				] AS _xml

				,0 AS var_eksisterende
			FROM features f
				,sandbox.kontrol_inputfiles_features_direction d
			WHERE d.kontrol_guid = _kontrol_guid
				AND d.kontrol_id = f.kontrol_id
				AND f.gruppe_order > 0
		)

		,cte1 AS(
			SELECT
				f.*
				,0 AS var_fejl
			FROM features f

			UNION ALL

			SELECT
				f.*
				,0 AS var_fejl
			FROM features_frame f

			UNION ALL

			SELECT
				f.*
				,1 AS var_fejl
			FROM features_fejl f

			UNION ALL

			SELECT
				f.*
				,0 AS var_fejl
			FROM features_direction f
		)

		,features_attributes AS(
			SELECT
				c.leaflet_id
				,c.leaflet_fid
				,c.leaflet_feature_fid

				,(
					jsonb_object(
						ARRAY['search_control']
						,ARRAY[c.kontrol_id]
					)
					|| jsonb_object_agg(
							CASE
								WHEN _xml_values._value IS NOT NULL
								THEN _xml_group.name || '.' || _xml_values.name
								ELSE 'NULL'
							END
							,CASE
								WHEN _xml_values._value IS NOT NULL
								THEN _xml_values._value
							END
					)
					|| jsonb_object_agg(
							CASE
								WHEN _xml_values.fejl != 0
								THEN _xml_group.name || '.' || _xml_values.name || '.fejl'
								ELSE 'NULL'
							END
							,CASE
								WHEN _xml_values.fejl != 0
								THEN _xml_values.fejl::text
							END
					)
				) - 'NULL' AS json_properties
			FROM cte1 c
				,UNNEST(
					c._xml
						|| FORMAT(
$$<leaflet>
	<layer_id>%s</layer_id>
	<id>%s</id>
	<feature_fid>%s</feature_fid>
	<opacity>%s</opacity>
	<fillOpacity>%s</fillOpacity>
</leaflet>$$
								,c.leaflet_layer_id
								,c.leaflet_id
								,ABS(c.leaflet_feature_fid)
								,CASE
									-- WHEN c.system = '__frame__'
									-- THEN 1
									WHEN c.var_eksisterende = 1
									THEN 0.5
									-- WHEN c.pg_geometritype ~* 'POINT'
									-- THEN 1
									-- WHEN c.pg_geometritype ~* 'LINESTRING'
									-- THEN 1
									-- WHEN c.pg_geometritype ~* 'POLYGON'
									-- THEN 1
									ELSE 1
								END
								,CASE
									WHEN c.system = '__frame__'
									THEN 0
									WHEN c.var_eksisterende = 1
										AND c.pg_geometritype ~* 'POINT'
									THEN 0.4
									WHEN c.var_eksisterende = 1
										AND c.pg_geometritype ~* 'LINESTRING'
									THEN 0
									WHEN c.var_eksisterende = 1
										AND c.pg_geometritype ~* 'POLYGON'
									THEN 0.25
									WHEN c.pg_geometritype ~* 'POINT'
									THEN 1
									WHEN c.pg_geometritype ~* 'LINESTRING'
									THEN 0
									WHEN c.pg_geometritype ~* 'POLYGON'
									THEN 0.5
									ELSE 1
								END
							)::xml
				) WITH ORDINALITY u(_xml, _order)
				,xmltable(
					'/*' passing u._xml
					COLUMNS
						name text path 'name()'
				) _xml_group
				,xmltable(
					'/*/*' passing u._xml
					COLUMNS
						_order FOR ORDINALITY
						,name text path 'name()'
						,_value text path 'text()'
						,fejl integer path '@fejl' DEFAULT 0
				) _xml_values
			WHERE _xml_values._value IS NOT NULL
				OR _xml_values.fejl != 0
			GROUP BY c.leaflet_fid
				,c.leaflet_id
				,c.leaflet_feature_fid

				,c.kontrol_id
		)


	SELECT
		c.leaflet_json_id

		,c.leaflet_popup_id

		,c.leaflet_style_id

		,c.leaflet_layer_id
		,c.leaflet_overlay_id
		,c.leaflet_layer_cluster_id
		,c.leaflet_layer_pretty
		,c.leaflet_layer_order

		,c.leaflet_fid
		,c.leaflet_id


		,c.featuretype_fid
		,c.featuretype
		,c.featuretype_pretty
		,c.featuretype_order


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


		,c.forsyningsart_color_hex
		,c.snap_color_hex
		,c.featuretype_gruppe_color_hex


		,c.featuretype_gruppe_js_style
		,c.featuretype_gruppe_js_svg_legend

		,'var ' || c.leaflet_json_id || ' = '
			|| -- REPLACE(
					-- jsonb_pretty(
						jsonb_build_object(
							'type', 'FeatureCollection'
							,'name', c.leaflet_id
							,'crs', jsonb_build_object(
										'type', 'name'
										,'properties', jsonb_build_object(
														'name', 'urn:ogc:def:crs:OGC:1.3:CRS84'
													)
									)
							,'features', jsonb_agg(
											jsonb_build_object(
												'type', 'Feature'
												,'properties', fa.json_properties
												,'geometry', ST_AsGeoJSON(c.geom)::jsonb
											)
										)
						-- )
					-- )
					-- ,'    '
					-- ,E'\t'
			)::text AS var_json
			,MAX(c.var_eksisterende) AS var_eksisterende
			,c.var_fejl
	FROM cte1 c
	INNER JOIN features_attributes fa ON c.leaflet_id = fa.leaflet_id
		AND c.leaflet_fid = fa.leaflet_fid
		AND c.leaflet_feature_fid = fa.leaflet_feature_fid
	GROUP BY c.leaflet_json_id

		,c.leaflet_popup_id

		,c.leaflet_style_id

		,c.leaflet_layer_id
		,c.leaflet_overlay_id
		,c.leaflet_layer_cluster_id
		,c.leaflet_layer_pretty
		,c.leaflet_layer_order

		,c.leaflet_fid
		,c.leaflet_id


		,c.featuretype_fid
		,c.featuretype
		,c.featuretype_pretty
		,c.featuretype_order


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


		,c.forsyningsart_color_hex
		,c.snap_color_hex
		,c.featuretype_gruppe_color_hex


		,c.featuretype_gruppe_js_style
		,c.featuretype_gruppe_js_svg_legend

		,c.var_fejl;

END $BODY$;