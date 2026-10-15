/* DROP FUNCTION IF EXISTS sandbox.kontrol_outputfile_leaflet_js(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_outputfile_leaflet_js(
	_kontrol_guid uuid

	,OUT _html text
)
	RETURNS TEXT
	STABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	WITH

		var_json AS(
			SELECT
				j.*
			FROM sandbox.kontrol_outputfile_leaflet_var_json(
					_kontrol_guid := _kontrol_guid
				) j
		)





--
-- JSON SCRIPT
--
-- /*
		,var_json_script AS(
			SELECT
				FORMAT(
$$<script>
%s
</script>$$
					,string_agg(
						sandbox.kontrol_html_indent(
							_html := j.var_json
						)
						-- ,E'\n\n\n'
						,E'\n'
						ORDER BY ABS(j.leaflet_layer_order), j.leaflet_layer_order
					)
				) AS _html
				,MAX(var_eksisterende) AS var_eksisterende_max
				,MAX(var_fejl) AS var_fejl_max
			FROM var_json j
		)
-- */



--
-- FUNCTION STYLE
--
-- /*
		,func_style_1 AS(
			SELECT DISTINCT ON (j.leaflet_style_id)
				j.leaflet_style_id
				,j.leaflet_layer_order

				,FORMAT(
$$function %s(feature) {
%s
}$$
					,j.leaflet_style_id
					,sandbox.kontrol_html_indent(
						_html := REPLACE(
									j.featuretype_gruppe_js_style
									,'[COLOR_HEX]'
									,COALESCE(
										j.featuretype_gruppe_color_hex
										,j.forsyningsart_color_hex
									)
								)
					)
				) AS _js
			FROM var_json j
			WHERE j.leaflet_style_id IS NOT NULL
		)

		,func_style AS(
			SELECT
				string_agg(
					f._js
					,E'\n\n\n'
					ORDER BY ABS(f.leaflet_layer_order), f.leaflet_layer_order
				) AS _js
			FROM func_style_1 f
		)
-- */



--
-- FUNCTION POP
--
-- /*
		,func_pop_1 AS(
			SELECT DISTINCT ON (j.leaflet_popup_id, ag.attr_grp)
				j.leaflet_popup_id
				,j.leaflet_layer_order
				,j.featuretype_fid
				,ag.attr_grp
				,ag.attr_grp_pretty
				,ag.attr_grp_order
			FROM var_json j
				,(VALUES
					('feature', 'Feature', 1)
					-- ,('leaflet', 'Information', 0)
					,('geometry', 'Geometri', 2)
					,('attributes', 'Data', 3)
				) ag(attr_grp, attr_grp_pretty, attr_grp_order)
			WHERE j.leaflet_popup_id IS NOT NULL
			ORDER BY j.leaflet_popup_id
				,ag.attr_grp
				,j.leaflet_layer_order
		)

		,func_pop_2 AS(
			SELECT
				f.leaflet_popup_id
				,f.leaflet_layer_order
				,f.attr_grp
				,f.attr_grp_pretty
				,f.attr_grp_order

				,a.attr
				,a.attr_pretty
				,a.attr_order

				,a.show_on_null
			FROM func_pop_1 f
				,(VALUES
					('feature', 'inputfile', 'Filnavn', 1, TRUE)
					-- ,('leaflet', 'search_id', 'ID', 1, TRUE)
					,('feature', 'group', 'Gruppe', 2, FALSE)
					,('feature', 'eksisterende_popup', 'Eksisterende', 3, TRUE)
				) a(attr_grp, attr, attr_pretty, attr_order, show_on_null)
			WHERE f.attr_grp = a.attr_grp

			UNION ALL

			SELECT
				f.leaflet_popup_id
				,f.leaflet_layer_order
				,f.attr_grp
				,f.attr_grp_pretty
				,f.attr_grp_order

				,a.attr
				,a.attr_pretty
				,a.attr_order

				,TRUE AS show_on_null
			FROM func_pop_1 f
				,sandbox.kontrol_featuretype_attributes(
					_featuretype_fid := f.featuretype_fid
				) a
			WHERE f.attr_grp = 'attributes'
				AND a.kontrol_type IS DISTINCT FROM 'hidden'

			UNION ALL

			SELECT
				f.leaflet_popup_id
				,f.leaflet_layer_order
				,f.attr_grp
				,f.attr_grp_pretty
				,f.attr_grp_order

				,a.navn AS attr
				,a.navn_pretty AS attr_pretty
				,a._order AS attr_order

				,FALSE AS show_on_null
			FROM func_pop_1 f
			INNER JOIN sandbox.kontrol_lst_attributter_geometri a ON a.aktiv IS TRUE
			WHERE f.attr_grp = 'geometry'
		)

		,func_pop_3 AS(
			SELECT
				f.leaflet_popup_id
				,f.leaflet_layer_order
				,f.attr_grp
				,f.attr_grp_pretty
				,f.attr_grp_order


				,string_agg(
					FORMAT(
						CASE
							WHEN show_on_null IS FALSE
							THEN
$$		+ (
			feature.properties['%1$s.%2$s'] !== undefined || feature.properties['%1$s.%2$s.fejl'] !== undefined
			? '<tr'
				+ (
					feature.properties['%1$s.%2$s.fejl'] === '1' ? ' class="error_pop"'
					: feature.properties['%1$s.%2$s.fejl'] === '-1' ? ' class="obs_pop"'
					: feature.properties['%1$s.%2$s'] === undefined ? ' class="null_pop"'
					: ''
				)
				+ '>\
					<th>%3$s</th>\
					<td>'
				+ (
					feature.properties['%1$s.%2$s'] !== undefined ? feature.properties['%1$s.%2$s'] : '&lt;null&gt;'
				)
				+ '</td>\
				</tr>\
				'
			: ''
		)$$
							ELSE
$$		+ '<tr'
			+ (
				feature.properties['%1$s.%2$s.fejl'] === '1' ? ' class="error_pop"'
				: feature.properties['%1$s.%2$s.fejl'] === '-1' ? ' class="obs_pop"'
				: feature.properties['%1$s.%2$s'] === undefined ? ' class="null_pop"'
				: ''
			)
			+ '>\
				<th>%3$s</th>\
				<td>'
			+ (
				feature.properties['%1$s.%2$s'] !== undefined ? feature.properties['%1$s.%2$s'] : '&lt;null&gt;'
			)
			+ '</td>\
			</tr>\
			'$$
						END
						,f.attr_grp
						,f.attr
						,f.attr_pretty
					)
					,E'\n'
					ORDER BY f.attr_order
				) AS _js

			FROM func_pop_2 f
			GROUP BY f.leaflet_popup_id
				,f.leaflet_layer_order
				,f.attr_grp
				,f.attr_grp_pretty
				,f.attr_grp_order
		)

		,func_pop_4 AS(
			SELECT
				f.leaflet_popup_id
				,f.leaflet_layer_order

				,FORMAT(
$$function %s(feature, layer) {
	layer.on('mouseout', function () {
		eval(feature.properties['leaflet.layer_id'] + '.resetStyle(layer.target)')
	});

	layer.on('mouseover', function () {
		if (typeof layer.options.layerName == 'string') {
			if (!layer.options.layerName.includes('_punkt')) {
				layer.setStyle({
					color: '#ffff00',
					fillColor: '#ffff00',
				});
			}
		}
	});

	var popupContent = '<table>\
			'
%s

		+ '</table>';

	layer.bindPopup(popupContent, { maxHeight: 400, minWidth: 550, maxWidth: 550 });
}$$
					,f.leaflet_popup_id
					,string_agg(
						FORMAT(
$$		+ '<tbody>\
			<tr>\
				<th colspan="2">%s:</th>\
			</tr>\
			'
%s
		+ '</tbody>\
			'$$
							,f.attr_grp_pretty
							,f._js
						)
						,E'\n'
						ORDER BY f.attr_grp_order
					)
				) AS _js
			FROM func_pop_3 f
			GROUP BY f.leaflet_popup_id
				,f.leaflet_layer_order
		)

		,func_pop AS(
			SELECT
				string_agg(
					-- f._js
					-- Komprimering af tabel til én linje
					SUBSTRING(f._js, '^(.+?)<table>')
						|| regexp_replace(
							SUBSTRING(f._js, '^.+?(<table>.+?</table>)')
							,'\\?\n\t*'
							,' '
							,'g'
						)
						|| SUBSTRING(f._js, '^.+?<table>.+?</table>(.+)$')
					,E'\n\n\n'
					ORDER BY ABS(f.leaflet_layer_order), f.leaflet_layer_order
				) AS _js
			FROM func_pop_4 f
		)
-- */



--
-- FUNCTION VAR LAYER CLUSTER
--
-- /*
		,var_layer_cluster_1 AS(
			SELECT DISTINCT ON (j.leaflet_layer_cluster_id)
				j.leaflet_layer_cluster_id
				,j.system_order
				,j.forsyningsart_order
				,j.gruppe_order
				,j.featuretype_order

				,FORMAT(
$$var %1$s = L.markerClusterGroup({
	showCoverageOnHover: false
	,zoomToBoundsOnClick: true
	,animate: false
	,maxClusterRadius: 5
	,iconCreateFunction: function (cluster) {
		return L.divIcon({
			iconSize: L.point(12.5, 12.5)
			,className: 'svgCluster svgAnimated'
			,html: '<svg viewBox="0 0 100 100">'
				+ '	<circle cx="50%%" cy="50%%" r="40%%" style="fill: %2$s; stroke: %2$s;"/>'
				+ '</svg>'
		});
	}
});$$

					,j.leaflet_layer_cluster_id
					,j.forsyningsart_color_hex
				) AS _js

				,FORMAT(
					$$showLayersGroup.addLayer(%1$s);$$

					,j.leaflet_layer_cluster_id
				) AS _js_add_layer
			FROM var_json j
			WHERE j.leaflet_layer_cluster_id IS NOT NULL
		)

		,var_layer_cluster AS(
			SELECT
				string_agg(
					f._js
					,E'\n\n\n\n\n\n'
					ORDER BY f.system_order
							,f.forsyningsart_order
							,f.gruppe_order
							,f.featuretype_order
				) AS _js
				,string_agg(
					f._js_add_layer
					,E'\n'
					ORDER BY f.system_order
							,f.forsyningsart_order
							,f.gruppe_order
							,f.featuretype_order
				) AS _js_add_layer
			FROM var_layer_cluster_1 f
		)
-- */



--
-- FUNCTION VAR LAYER
--
-- /*
		,var_layer_1 AS(
			SELECT DISTINCT ON (j.leaflet_layer_id)
				j.leaflet_layer_id
				,j.system_order
				,j.forsyningsart_order
				,j.gruppe_order
				,j.featuretype_order



				,CASE
					WHEN j.system = '__frame__'
					THEN FORMAT(
$$var %1$s = new L.geoJson(%2$s, {
	attribution: ''
	,interactive: false
	,dataVar: '%2$s'
	,layerName: '%1$s'
	,style: %3$s
});$$

							,j.leaflet_layer_id
							,j.leaflet_json_id
							,j.leaflet_style_id
						)



					WHEN j.var_fejl = 1
					THEN FORMAT(
$$var %1$s = new L.geoJson(%2$s, {
	attribution: ''
	,interactive: false
	,dataVar: '%2$s'
	,layerName: '%1$s'
	,pointToLayer: function (feature, latlng) {
		var context = {
			feature: feature
			,variables: {}
		};
		return L.popup(latlng, {
			autoClose: false
			,autoPan: false
			,closeOnClick: false
			,closeButton: false
			,className: 'pop_init ' + feature.properties['fejl.class']
			,content: feature.properties['fejl.content']
		});
	}
});$$

							,j.leaflet_layer_id
							,j.leaflet_json_id
						)



					WHEN j.gruppe = 'snap'
					THEN FORMAT(
$$var %1$s = new L.geoJson(%2$s, {
	attribution: ''
	,interactive: false
	,dataVar: '%2$s'
	,layerName: '%1$s'
	,pointToLayer: function (feature, latlng) {
		var context = {
			feature: feature
			,variables: {}
		};
		return L.marker(latlng, {
				icon: L.divIcon({
					iconSize: L.point(12.5, 12.5)
					,className: 'svgSnapMarker %3$s'
					,html: '<svg viewBox="0 0 100 100">'
							+ '	%4$s'
							+ '</svg>'
				})
		});
	}
});$$

							,j.leaflet_layer_id
							,j.leaflet_json_id

							,j.featuretype
							,REPLACE(
								j.featuretype_gruppe_js_style
								,'[COLOR_HEX]'
								,j.snap_color_hex
							)
						)



					WHEN j.featuretype = 'direction'
						AND featuretype_fid < 0
					THEN FORMAT(
$$var %1$s = new L.geoJson(%2$s, {
	attribution: ''
	,interactive: false
	,dataVar: '%2$s'
	,layerName: '%1$s'
	,pointToLayer: function (feature, latlng) {
		var context = {
			feature: feature
			,variables: {}
		};
		return L.marker(latlng, {
				icon: L.divIcon({
					iconSize: L.point(12.5, 12.5)
					,className: 'svgDirectionMarker'
					,html: '<svg viewBox="0 0 100 100">'
							+ '	<polygon points="50 15, 80 80, 20 80" style="transform-box: fill-box; transform-origin: center; transform: rotate(' + feature.properties['attributes.direction'] + 'deg);"/>'
							+ '</svg>'
				})
		});
	}
});$$

							,j.leaflet_layer_id
							,j.leaflet_json_id
						)



					WHEN j.pg_geometritype ~* 'POINT'
					THEN FORMAT(
$$var %1$s = new L.geoJson(%2$s, {
	attribution: ''
	,interactive: %3$s
	// ,filter: existingFilter
	,dataVar: '%2$s'
	,layerName: '%1$s'%4$s
	,pointToLayer: function (feature, latlng) {
		var context = {
			feature: feature
			,variables: {}
		};
		return L.marker(latlng, {
				icon: L.divIcon({
					iconSize: L.point(12.5, 12.5)
					,className: 'svgPointMarker %5$s'
					,html: '<svg viewBox="0 0 100 100">'
							+ '	%6$s'
							+ '</svg>'
				})
		});
	}
});$$

							,j.leaflet_layer_id
							,j.leaflet_json_id

							,CASE
								WHEN var_eksisterende = 1
								THEN 'false'
								ELSE 'true'
							END
							,E'\n\t,onEachFeature: ' || j.leaflet_popup_id
							,CASE
								WHEN var_eksisterende = 1
								THEN ' svgGeomExist'
								ELSE ' svgAnimated'
							END
							,REPLACE(
								j.featuretype_gruppe_js_style
								,'[COLOR_HEX]'
								,COALESCE(
									j.featuretype_gruppe_color_hex
									,j.forsyningsart_color_hex
								)
							)
						)



					ELSE FORMAT(
$$var %1$s = new L.geoJson(%2$s, {
	attribution: ''
	,interactive: %3$s
	// ,filter: existingFilter
	,renderer: object_renderer
	,dataVar: '%2$s'
	,layerName: '%1$s'%4$s
	,style: %5$s
});$$

							,j.leaflet_layer_id
							,j.leaflet_json_id

							,CASE
								WHEN var_eksisterende = 1
								THEN 'false'
								ELSE 'true'
							END
							,E'\n\t,onEachFeature: ' || j.leaflet_popup_id

							,j.leaflet_style_id
						)
				END AS _js

			FROM var_json j
			WHERE j.leaflet_layer_id IS NOT NULL
		)

		,var_layer AS(
			SELECT
				string_agg(
					f._js
					,E'\n\n\n\n\n\n'
					ORDER BY f.system_order
							,f.forsyningsart_order
							,f.gruppe_order
							,f.featuretype_order
							,f.leaflet_layer_id
				) AS _js
			FROM var_layer_1 f
		)
-- */



--
-- ADD LAYER
--
-- /*
		,add_layer_1 AS(
			SELECT DISTINCT ON (j.leaflet_layer_id)
				j.leaflet_layer_id
				,j.leaflet_layer_order
				,j.geometritype_order
				,j.system_order
				,j.forsyningsart_order
				,j.gruppe_order
				,j.featuretype_order
				,j.var_eksisterende
				,j.var_fejl

				,CASE
					WHEN j.system = '__frame__'
					THEN FORMAT(
$$boundsGroup.addLayer(%1$s);
%2$s = L.featureGroup([%1$s]);
showLayersGroup.addLayer(%2$s);$$

							,j.leaflet_layer_id
							,j.leaflet_overlay_id
						)



					WHEN j.gruppe = 'snap'
					THEN FORMAT(
$$%2$s = L.featureGroup([%1$s]);$$

							,j.leaflet_layer_id
							,j.leaflet_overlay_id
						)



					WHEN j.var_fejl = 1
					THEN FORMAT(
$$errorsGroup.addLayer(%1$s);
%2$s.addLayer(%1$s);$$

							,j.leaflet_layer_id
							,j.leaflet_overlay_id
						)



					WHEN j.featuretype = 'direction'
						AND featuretype_fid < 0
					THEN FORMAT(
$$%2$s.addLayer(%1$s);$$

							,j.leaflet_layer_id
							,j.leaflet_overlay_id
						)



					WHEN j.pg_geometritype ~* 'POINT'
						AND var_eksisterende = 1
					THEN FORMAT(
$$if (typeof %2$s !== 'undefined') {
	%2$s.addLayer(L.featureGroup.subGroup(%3$s, [%1$s]));
} else {
	%2$s = L.featureGroup.subGroup(%3$s, [%1$s]);
}
if (!showLayersGroup.hasLayer(%2$s)) {
	showLayersGroup.addLayer(%2$s);
}
filterGroup.push(%1$L);
if (!overlayGroup.includes(%2$L)) {
	overlayGroup.push(%2$L);
}$$

							,j.leaflet_layer_id
							,j.leaflet_overlay_id

							,j.leaflet_layer_cluster_id
						)



					WHEN var_eksisterende = 1
					THEN FORMAT(
$$if (typeof %2$s !== 'undefined') {
	%2$s.addLayer(L.featureGroup([%1$s]));
} else {
	%2$s = L.featureGroup([%1$s]);
}
if (!showLayersGroup.hasLayer(%2$s)) {
	showLayersGroup.addLayer(%2$s);
}
filterGroup.push(%1$L);
if (!overlayGroup.includes(%2$L)) {
	overlayGroup.push(%2$L);
}$$

							,j.leaflet_layer_id
							,j.leaflet_overlay_id
						)



					WHEN j.pg_geometritype ~* 'POINT'
					THEN FORMAT(
$$searchGroup.addLayer(%1$s);
%2$s = L.featureGroup([L.featureGroup.subGroup(%3$s, [%1$s])]);
showLayersGroup.addLayer(%2$s);
filterGroup.push(%1$L);
overlayGroup.push(%2$L);$$

							,j.leaflet_layer_id
							,j.leaflet_overlay_id

							,j.leaflet_layer_cluster_id
						)



					ELSE FORMAT(
$$searchGroup.addLayer(%1$s);
%2$s = L.featureGroup([%1$s]);
showLayersGroup.addLayer(%2$s);
filterGroup.push(%1$L);
overlayGroup.push(%2$L);$$

							,j.leaflet_layer_id
							,j.leaflet_overlay_id
						)
				END AS _js
			FROM var_json j
			WHERE j.leaflet_layer_id IS NOT NULL
		)

		,add_layer AS(
			SELECT
				string_agg(
					f._js
					,E'\n\n\n'
					ORDER BY f.geometritype_order DESC
						,ABS(f.leaflet_layer_order)
						,f.leaflet_layer_order DESC
						,f.var_eksisterende
						,f.var_fejl
						,f.system_order
						,f.forsyningsart_order
						,f.gruppe_order
						,f.featuretype_order
						,f.leaflet_layer_id
				) AS _js
			FROM add_layer_1 f
		)
-- */



--
-- VAR OVERLAY SNAP
--
-- /*
		,var_overlay_snap_svg_1 AS(
			SELECT DISTINCT ON (j.leaflet_overlay_id)
				j.system_fid
				,j.forsyningsart_fid
				,j.gruppe_fid

				,j.forsyningsart_color_hex
				,j.snap_color_hex

				,ROW_NUMBER() OVER(PARTITION BY j.system_fid, j.forsyningsart_fid ORDER BY j.featuretype_order)::integer - 1 AS _position
				,COUNT(*) OVER(PARTITION BY j.system_fid, j.forsyningsart_fid)::integer - 1 AS _position_ct
			FROM var_json j
			WHERE j.leaflet_overlay_id IS NOT NULL
				AND j.gruppe = 'snap'
		)

		,var_overlay_snap_svg AS(
			SELECT
				v.system_fid
				,v.forsyningsart_fid
				,v.gruppe_fid


				,FORMAT(
$$'<svg viewBox="0 0 100 100" class="svgOverlay">'
%s
		+ '<line x1="20%%" y1="90%%" x2="80%%" y2="90%%" style="stroke: %s; stroke-width: 15%%;"/>'
		+ '<svg>'
		+ $$

					,string_agg(
						FORMAT(
							$$		+ '<circle cx="%s%%" cy="35%%" r="20%%" style="fill: %s; stroke: black; stroke-width: 5%%;"/>'$$
							,c.x_pct
							,v.snap_color_hex
						)
						,E'\n'
						ORDER BY v._position
					)
					,v.forsyningsart_color_hex
				) AS svg_overlay_snap
			FROM var_overlay_snap_svg_1 v
				,(VALUES
					(20, 25, 60)
				) svg(_base, _afstand, _spaend)
				,COALESCE(
					svg._base + svg._afstand * v._position + (svg._spaend - svg._afstand * v._position_ct) / 2
				) c(x_pct)
			GROUP BY v.system_fid
				,v.forsyningsart_fid
				,v.gruppe_fid

				,v.forsyningsart_color_hex
		)
-- */



--
-- VAR OVERLAY
--
-- /*
		,var_overlay_1 AS(
			SELECT DISTINCT ON (j.leaflet_overlay_id)
				j.leaflet_layer_pretty
				,j.leaflet_layer_order
				,COUNT(j.leaflet_layer_pretty) OVER(PARTITION BY j.system_fid, j.forsyningsart_fid, j.gruppe_fid, j.geometritype_fid)::integer AS layer_count

				,j.system_fid
				,j.system
				,j.system_pretty

				,j.forsyningsart_fid
				,j.forsyningsart
				,j.forsyningsart_pretty

				,j.gruppe_fid
				,j.gruppe
				,j.gruppe_pretty

				,j.geometritype_fid
				,j.geometritype
				,j.geometritype_short


				,j.forsyningsart_color_hex

				,FORMAT(
$${
	label: '<svg viewBox="0 0 100 100" class="svgOverlay">'
		+ '%2$s'
		+ '</svg>'
		+ '<text class="legendLayerTxt">[LAYER_NAME]</text>'
	,layer: %1$s
}$$
					,j.leaflet_overlay_id
					,REPLACE(
						j.featuretype_gruppe_js_svg_legend
						,'[COLOR_HEX]'
						,COALESCE(
							j.featuretype_gruppe_color_hex
							,j.snap_color_hex
							,j.forsyningsart_color_hex
						)
					)
				) AS svg_overlay
			FROM var_json j
			WHERE j.leaflet_overlay_id IS NOT NULL
				AND var_fejl = 0
				AND NOT(
						j.featuretype = 'direction'
						AND featuretype_fid < 0
					)
		)

		,var_overlay_2 AS(
			SELECT
				MIN(o.leaflet_layer_order) AS leaflet_layer_order
				,COUNT(o.forsyningsart_pretty) OVER(PARTITION BY o.system_fid, o.forsyningsart_fid)::integer AS layer_count

				,o.system_fid
				,o.system
				,o.system_pretty

				,o.forsyningsart_fid
				,o.forsyningsart
				,o.forsyningsart_pretty

				,o.gruppe_fid
				,o.gruppe
				,o.gruppe_pretty
					|| CASE
							WHEN COUNT(o.gruppe_pretty) OVER(PARTITION BY o.system_fid, o.forsyningsart_fid, o.gruppe_fid)::integer > 1
							THEN ' (' || o.geometritype_short || ')'
							ELSE ''
						END AS gruppe_pretty

				,o.geometritype_fid
				,o.geometritype
				,o.geometritype_short


				,o.forsyningsart_color_hex

				,FORMAT(
					CASE
						WHEN o.layer_count > 0
						THEN
$${
	label: %s'<b>[LAYER_NAME]</b>'
	,selectAllCheckbox: true
	,collapsed: true
	,children: [
%s
	]
}$$



						ELSE '%2$s'
					END

					,s.svg_overlay_snap
					,sandbox.kontrol_html_indent(
						_html := string_agg(
									CASE
										WHEN o.layer_count > 0
										THEN REPLACE(
												o.svg_overlay
												,'[LAYER_NAME]'
												,COALESCE(o.leaflet_layer_pretty, o.gruppe_pretty)
											)
										ELSE o.svg_overlay
									END
									,E'\n,'
									ORDER BY o.leaflet_layer_order
								)
								,_indents := CASE
												WHEN o.layer_count > 0
												THEN 2
												ELSE 0
											END
					)
				) AS svg_overlay
			FROM var_overlay_1 o
			LEFT JOIN var_overlay_snap_svg s ON s.system_fid = o.system_fid
				AND s.forsyningsart_fid = o.forsyningsart_fid
				AND s.gruppe_fid = o.gruppe_fid
			GROUP BY o.layer_count

				,o.system_fid
				,o.system
				,o.system_pretty

				,o.forsyningsart_fid
				,o.forsyningsart
				,o.forsyningsart_pretty

				,o.gruppe_fid
				,o.gruppe
				,o.gruppe_pretty

				,o.geometritype_fid
				,o.geometritype
				,o.geometritype_short


				,o.forsyningsart_color_hex
				,s.svg_overlay_snap
		)

		,var_overlay_3 AS(
			SELECT
				MIN(o.leaflet_layer_order) AS leaflet_layer_order
				,COUNT(o.forsyningsart_pretty) OVER(PARTITION BY o.system_fid)::integer AS layer_count

				,o.system_fid
				,o.system
				,o.system_pretty

				,o.forsyningsart_fid
				,o.forsyningsart
				,o.forsyningsart_pretty

				,FORMAT(
					CASE
						WHEN o.layer_count > 0
						THEN
$${
	label: '<svg viewBox="0 0 100 100" class="svgOverlay">'
		+ '<polyline points="5,85 40,20 60,80 95,15" style="fill-opacity: 0; stroke: %s; stroke-width: 10%%; stroke-linejoin: round; stroke-linecap: round;"/>'
		+ '</svg>'
		+ '<b>%s</b>'
	,selectAllCheckbox: true
	,collapsed: %s
	,children: [
%s
	]
}$$



						ELSE '%4$s'
					END

					,o.forsyningsart_color_hex
					,o.forsyningsart_pretty
					,CASE
						WHEN COUNT(o.forsyningsart_pretty) OVER()::integer < 5
						THEN 'false'
						ELSE 'true'
					END
					,sandbox.kontrol_html_indent(
						_html := string_agg(
									CASE
										WHEN o.layer_count > 0
										THEN REPLACE(
												o.svg_overlay
												,'[LAYER_NAME]'
												,o.gruppe_pretty
											)
										ELSE o.svg_overlay
									END
									,E'\n,'
									ORDER BY o.leaflet_layer_order
								)
								,_indents := CASE
												WHEN o.layer_count > 0
												THEN 2
												ELSE 0
											END
					)
				) AS svg_overlay
			FROM var_overlay_2 o
			GROUP BY o.layer_count

				,o.system_fid
				,o.system
				,o.system_pretty

				,o.forsyningsart_fid
				,o.forsyningsart
				,o.forsyningsart_pretty


				,o.forsyningsart_color_hex
		)

		,var_overlay_4 AS(
			SELECT
				MIN(o.leaflet_layer_order) AS leaflet_layer_order

				,o.system_fid
				,o.system
				,o.system_pretty

				,FORMAT(
					CASE
						WHEN SUM((o.system_fid > 0)::integer) OVER()::integer > 1
							AND o.layer_count > 0
						THEN
$${
	label: '<b>%s</b>'
	,selectAllCheckbox: true
	,collapsed: false
	,children: [
%s
	]
}$$



						ELSE '%2$s'
					END

					,o.system_pretty
					,sandbox.kontrol_html_indent(
						_html := string_agg(
									REPLACE(
										o.svg_overlay
										,'[LAYER_NAME]'
										,o.system_pretty
									)
									,E'\n,'
									ORDER BY o.leaflet_layer_order
								)
								,_indents := CASE
												WHEN o.layer_count > 0
												THEN 2
												ELSE 0
											END
					)
				) AS svg_overlay
			FROM var_overlay_3 o
			GROUP BY o.layer_count

				,o.system_fid
				,o.system
				,o.system_pretty
		)

		,var_overlay AS(
			SELECT
				FORMAT(
$$var overlayMaps = [
%s
];$$
					,sandbox.kontrol_html_indent(
							_html := string_agg(
										v.svg_overlay
										,E'\n,'
										ORDER BY leaflet_layer_order
									)
					)
				) AS _js
			FROM var_overlay_4 v
		)

-- */



--
-- SCRIPT
--
-- /*
	SELECT
		json._html
			|| FORMAT(
$$
<script>
%s
</script>$$
			,sandbox.kontrol_html_indent(
				_html := REPLACE(
							REPLACE(
								REPLACE(
									(SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'leaflet_js')
									,'[__ERRORS__]'
									,json.var_fejl_max::text
								)
								,'[__EXISTING__]'
								-- ,0::text
								-- ,(
									-- SELECT
										-- ((xpath('/kontrolLER/existingFromDB/text()', k._xml::xml))[1])::text
									-- FROM sandbox.kontrol_xml k
									-- WHERE guid = _kontrol_guid
								-- )
								,GREATEST(
									json.var_eksisterende_max
									-- ,(
										-- SELECT
											-- ((xpath('/kontrolLER/existingFromDB/text()', k._xml::xml))[1])::text
										-- FROM sandbox.kontrol_xml k
										-- WHERE guid = _kontrol_guid
									-- )
									,0
								)::text
							)
							,'[__JS__]'
							,array_to_string(
								array_remove(
									ARRAY[
										style._js
										,pop._js
										,layer_cluster._js
										,layer._js
										,add_layer._js
										,layer_cluster._js_add_layer
										,overlay._js
									]
									,NULL
								)
								,E'\n\n\n\n\n'
							)
						)
			)
		) AS _html
	FROM var_json_script json
	LEFT JOIN func_style style ON TRUE
	LEFT JOIN func_pop pop ON TRUE
	LEFT JOIN var_layer_cluster layer_cluster ON TRUE
	LEFT JOIN var_layer layer ON TRUE
	LEFT JOIN add_layer ON TRUE
	LEFT JOIN var_overlay overlay ON TRUE
	INTO _html;

	RETURN;

END $BODY$;