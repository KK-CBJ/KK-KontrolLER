
/* DROP FUNCTION IF EXISTS sandbox.kontrol_outputfile_data_check(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_outputfile_data_check(
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

		features_1 AS(
			SELECT
				f.system_fid
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe_pretty
				,f.gruppe_order

				,f.inputfile_fid
				,f.inputfile_pretty
				,f.inputfile_order

				,f.featuretype_fid

				,u.feature_fid::text
				,f.attributes_xml
				,f.geom_xml
			-- FROM sandbox.kontrol_inputfiles_features(
					-- _kontrol_guid := _kontrol_guid
			-- ) f
			FROM sandbox.kontrol_inputfiles_features f
				,UNNEST(xpath('/attributes/@fid', f.attributes_xml)) u(feature_fid)
			WHERE f.kontrol_guid = _kontrol_guid
				AND f.feature_eksisterende = 0
		)

		,features AS(
			SELECT
				f.inputfile_fid
				,f.inputfile_pretty
				,f.inputfile_order

				,f.system_fid
				,f.forsyningsart_fid
				,f.gruppe_fid

				,f.feature_fid
				,f.attributes_xml



				,ft_a.attr_fid
				,ft_a.attr

				,ft_a.pakke_fid
				,ft_a.data_type

				,ft_a.kontrol_type
			FROM features_1 f
				,sandbox.kontrol_featuretype_attributes(
					_featuretype_fid := f.featuretype_fid
				) ft_a
			WHERE ft_a.kontrol_type IS DISTINCT FROM 'hidden'
				AND ft_a.kontrol_type IS DISTINCT FROM 'no_control'

			UNION ALL

			SELECT
				f.inputfile_fid
				,f.inputfile_pretty
				,f.inputfile_order

				,f.system_fid
				,f.forsyningsart_fid
				,f.gruppe_fid

				,f.feature_fid
				,f.geom_xml AS attributes_xml



				,ag.fid AS attr_fid
				,ag.navn AS attr

				,-1 AS pakke_fid
				,NULL::text AS data_type

				,NULL::text AS kontrol_type
			FROM features_1 f
				,sandbox.kontrol_lst_attributter_geometri ag
			WHERE ag.aktiv IS TRUE
		)




		,feature_attributes_1 AS(
			SELECT
				f.inputfile_fid
				,f.inputfile_pretty
				,f.inputfile_order

				,f.system_fid
				,f.gruppe_fid

				,f.feature_fid



				,f.attr_fid
				,f.attr

				,f.pakke_fid



				,t._value
				,t.fejl

				,MIN(
					CASE
						WHEN f.kontrol_type = 'min_max'
							AND f.data_type IN('integer', 'float')
							AND t.fejl = 0
						THEN t._value
					END::numeric
				) OVER(PARTITION BY f.system_fid, f.gruppe_fid, f.forsyningsart_fid, f.attr_fid, t.fejl) AS min_value
				,MAX(
					CASE
						WHEN f.kontrol_type = 'min_max'
							AND f.data_type IN('integer', 'float')
							AND t.fejl = 0
						THEN t._value
					END::numeric
				) OVER(PARTITION BY f.system_fid, f.gruppe_fid, f.forsyningsart_fid, f.attr_fid, t.fejl) AS max_value

				,ROW_NUMBER() OVER(
								PARTITION BY f.system_fid, f.gruppe_fid, f.attr_fid, t.fejl
								ORDER BY CASE
											WHEN f.data_type IN('integer', 'float')
												AND t.fejl = 0
											THEN t._value
										END::numeric
										,t._value NULLS FIRST
				) AS row_value
				-- ,COUNT(*) OVER(PARTITION BY f.inputfile_fid, f.attr_fid, t._value, t.fejl) AS inputfile_count
				,COUNT(*) OVER(PARTITION BY f.inputfile_fid, f.attr_fid, t.fejl, CASE
																					WHEN f.kontrol_type = 'min_max'
																							AND f.data_type IN('integer', 'float')
																							AND t.fejl = 0
																					THEN '1'
																					ELSE t._value
																				END) AS inputfile_count

			FROM features f
				,xmltable(
					'/*' passing f.attributes_xml
						COLUMNS
							_value text path '/*/' || f.attr || '/text()'
							,fejl integer path'/*/' || f.attr || '/@fejl'
				) t
			WHERE t.fejl IS NOT NULL
				AND (
					f.kontrol_type IS DISTINCT FROM 'hidden_attr'
					OR t._value IS NOT NULL
				)

			UNION ALL

			-- Snap
			SELECT
				f.inputfile_fid
				,f.inputfile_pretty
				,f.inputfile_order

				,f.system_fid
				,f.gruppe_fid

				,f.feature_fid



				,ag.fid AS attr_fid
				,ag.navn AS attr

				,-1 AS pakke_fid



				,f.snap_featuretype_pretty AS _value
				,f.fejl

				,NULL::numeric AS min_value
				,NULL::numeric AS max_value

				,ROW_NUMBER() OVER(
								PARTITION BY f.system_fid, f.gruppe_fid, ag.fid, f.fejl
								ORDER BY f.snap_featuretype_pretty NULLS FIRST
				) AS row_value
				,COUNT(*) OVER(PARTITION BY f.inputfile_fid, ag.fid, f.snap_featuretype_pretty, f.fejl) AS inputfile_count

			-- FROM sandbox.kontrol_inputfiles_features_snap(
					-- _kontrol_guid := _kontrol_guid
			-- ) f
			FROM sandbox.kontrol_inputfiles_features_snap f
				,sandbox.kontrol_lst_attributter_geometri ag
			WHERE f.kontrol_guid = _kontrol_guid
				AND ag.navn = 'snap'
				AND ag.aktiv IS TRUE
				AND f.fejl IS NOT NULL
		)

		,feature_attributes_2 AS(
			SELECT
				fa.inputfile_fid
				,fa.inputfile_pretty
				,fa.inputfile_order

				,fa.system_fid
				,fa.gruppe_fid



				,fa.attr_fid
				,fa.attr

				,fa.pakke_fid



				,c._value
				,fa.fejl
				,COUNT(fa.fejl) AS fejl_count

				,MIN(fa.row_value) AS row_value
				,fa.inputfile_count
				,MAX(fa.inputfile_count) OVER(PARTITION BY fa.system_fid, fa.gruppe_fid, fa.attr_fid, c._value, fa.fejl) AS inputfile_count_max

				,array_agg(DISTINCT fa.feature_fid ORDER BY fa.feature_fid) AS feature_fid_lst

			FROM feature_attributes_1 fa
				,COALESCE(
					CASE
						WHEN fa.min_value = fa.max_value
						THEN fa.max_value::text
						ELSE fa.min_value || ' - ' || fa.max_value
					END
					,fa._value
				) c(_value)
			GROUP BY fa.inputfile_fid
				,fa.inputfile_pretty
				,fa.inputfile_order

				,fa.system_fid
				,fa.gruppe_fid



				,fa.attr_fid
				,fa.attr

				,fa.pakke_fid



				,c._value
				,fa.fejl

				,fa.inputfile_count
		)

		,feature_attributes_3 AS(
			SELECT
				fa.system_fid
				,fa.gruppe_fid

				,fa.attr_fid
				,fa.attr

				,fa.pakke_fid

				,fa._value
				,fa.fejl
				,SUM(fa.fejl_count) AS fejl_count

				,MIN(fa.row_value) AS row_value
				,string_agg(
					FORMAT(
						'<p%2$s>%1$s</p>'

						,sandbox.kontrol_html_encode(
							lpad(
								fa.inputfile_count::text
								,GREATEST(CEILING(log10(inputfile_count_max))::int, 1)
							)
								|| ' | '
								|| fa.inputfile_pretty
						)
						,FORMAT(
							' title="%s"'
							,array_to_string(
								ARRAY['ID:']
								|| CASE
										WHEN array_length(feature_fid_lst, 1) > 10
										THEN feature_fid_lst[1:10] || ARRAY['m.fl.']
										ELSE feature_fid_lst
									END
								,'&#13;&#10;&nbsp;&nbsp;'
							)
						)
					)
					,E'\n'
					ORDER BY inputfile_order
				) AS inputfile_count_html

			FROM feature_attributes_2 fa
			GROUP BY fa.system_fid
				,fa.gruppe_fid

				,fa.attr_fid
				,fa.attr

				,fa.pakke_fid

				,fa._value
				,fa.fejl
		)

		,feature_attributes AS(
			SELECT
				fa.system_fid
				,fa.gruppe_fid

				,fa.attr_fid
				,fa.attr

				,fa.pakke_fid

				,array_agg(
					ARRAY[
						sandbox.kontrol_html_tooltip(
							fa.inputfile_count_html
							,sandbox.kontrol_html_error_tegn(ARRAY[fa.fejl])
						)
						,sandbox.kontrol_xml_decode(fa._value)
						-- ,sandbox.kontrol_xml_decode(
							-- CASE
								-- WHEN LENGTH(fa._value) > 50
								-- THEN LEFT(fa._value, 50) || '...'
								-- ELSE fa._value
							-- END
						-- )
						,fa.fejl_count::text
					]
					ORDER BY CASE
								WHEN fa.fejl > 0
								THEN 1
								WHEN fa.fejl < 0
								THEN 2
								ELSE 3
							END
							,fa.row_value
				) AS _body_data_lst

				,array_agg(fa.fejl) AS _fejl_lst
			FROM feature_attributes_3 fa
			GROUP BY fa.system_fid
				,fa.gruppe_fid

				,fa.attr_fid
				,fa.attr

				,fa.pakke_fid
		)





		,feature_attributes_header_1 AS(
			(SELECT DISTINCT ON(f.system_fid, f.forsyningsart_fid, f.gruppe_fid, ft_a.attr_fid)
				f.system_fid
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe_pretty
				,f.gruppe_order

				,ft_a.attr_fid
				,ft_a.attr
				,ft_a.attr_pretty
				,ft_a.attr_order

				,ft_a.attr_lst

				,ft_a.pakke_fid
				,ft_a.pakke_pretty
				,ft_a.pakke_order

				,ft_a.data_type_pretty
				,ft_a.nillable
				,ft_a.default_value

				,ft_a.enhed
				,ft_a.tooltip_html

				,ft_a.opslagstabel_skema
				,ft_a.opslagstabel_navn
				,ft_a.opslagstabel_kolonne
				,ft_a.opslagstabel_kolonne_sql_tooltip
				,ft_a.opslagstabel_filter
			FROM features_1 f
				,sandbox.kontrol_featuretype_attributes(
					_featuretype_fid := f.featuretype_fid
				) ft_a
			WHERE ft_a.kontrol_type IS DISTINCT FROM 'hidden'
				AND ft_a.kontrol_type IS DISTINCT FROM 'no_control'
			ORDER BY f.system_fid, f.forsyningsart_fid, f.gruppe_fid, ft_a.attr_fid,f.featuretype_fid)

			UNION

			SELECT DISTINCT ON(f.system_fid, f.forsyningsart_fid, f.gruppe_fid, ag.fid)
				f.system_fid
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe_pretty
				,f.gruppe_order

				,ag.fid AS attr_fid
				,ag.navn AS attr
				,ag.navn_pretty AS attr_pretty
				,ag._order AS attr_order

				,NULL AS navn_lst

				,-1 AS pakke_fid
				,'Geometri' AS pakke_pretty
				,-1 AS pakke_order

				,NULL::text data_type_pretty
				,NULL::boolean nillable
				,NULL::text default_value

				,NULL::text AS enhed
				,ag.tooltip_html

				,NULL::text AS opslagstabel_skema
				,NULL::text AS opslagstabel_navn
				,NULL::text AS opslagstabel_kolonne
				,NULL::text AS opslagstabel_kolonne_sql_tooltip
				,NULL::text AS opslagstabel_filter
			FROM features_1 f
				,sandbox.kontrol_lst_attributter_geometri ag
			WHERE ag.aktiv IS TRUE
		)

		,feature_attributes_header_2 AS(
			SELECT
				fa.system_fid
				,fa.system_pretty
				,fa.system_order

				,fa.gruppe_fid
				,fa.gruppe_pretty
				,fa.gruppe_order

				,array_agg(fa.forsyningsart_pretty ORDER BY fa.forsyningsart_order) AS forsyningsart_lst
				,MIN(fa.forsyningsart_order) AS forsyningsart_min_order

				,fa.attr_fid
				,fa.attr
				,fa.attr_pretty
				,fa.attr_order

				,fa.attr_lst

				,fa.pakke_fid
				,fa.pakke_pretty
				,fa.pakke_order

				,fa.data_type_pretty
				,fa.nillable
				,fa.default_value

				,fa.enhed
				,fa.tooltip_html

				,fa.opslagstabel_skema
				,fa.opslagstabel_navn
				,fa.opslagstabel_kolonne
				,fa.opslagstabel_kolonne_sql_tooltip
				,fa.opslagstabel_filter
			FROM feature_attributes_header_1 fa
			GROUP BY fa.system_fid
				,fa.system_pretty
				,fa.system_order

				,fa.gruppe_fid
				,fa.gruppe_pretty
				,fa.gruppe_order

				,fa.attr_fid
				,fa.attr
				,fa.attr_pretty
				,fa.attr_order

				,fa.attr_lst

				,fa.pakke_fid
				,fa.pakke_pretty
				,fa.pakke_order

				,fa.data_type_pretty
				,fa.nillable
				,fa.default_value

				,fa.enhed
				,fa.tooltip_html

				,fa.opslagstabel_skema
				,fa.opslagstabel_navn
				,fa.opslagstabel_kolonne
				,fa.opslagstabel_kolonne_sql_tooltip
				,fa.opslagstabel_filter
		)

		,feature_attributes_header AS(
			SELECT
				fa.system_fid
				,fa.system_pretty
				,fa.system_order

				,fa.gruppe_fid
				,fa.gruppe_pretty
				,fa.gruppe_order

				,fa.forsyningsart_min_order

				,fa.attr_fid
				,fa.attr_order

				,fa.pakke_fid
				,fa.pakke_pretty
				,fa.pakke_order

				,ARRAY[
					ARRAY[
						COALESCE(a.tooltip_html, '')
						,CASE
							WHEN COUNT(*) OVER(PARTITION BY fa.system_fid, fa.gruppe_fid, fa.pakke_fid, fa.attr) > 1
							THEN FORMAT(
									$$<span>%s</span>$$
									,sandbox.kontrol_xml_encode(fa.attr_pretty)
										|| '<br/>'
										|| '(' || sandbox.kontrol_xml_encode(
												array_to_string(
													fa.forsyningsart_lst
													,', '
												)
											)
										|| ')'
								)
							ELSE fa.attr_pretty
						END
						,'Antal'
					]
				] AS _header_data_lst
			FROM feature_attributes_header_2 fa
				,sandbox.kontrol_html_tooltip(
					NULLIF(
						array_to_string(
							array_remove(
								ARRAY[
									'<p>Mulig navngivning: ' || array_to_string(fa.attr_lst, ', ') || '</p>'
									,'<p>Datatype: ' || fa.data_type_pretty || '</p>'
									,'<p>Standardværdi: ' || sandbox.kontrol_xml_encode(fa.default_value) || '</p>'
									,'<p>NULL tilladt: ' || (SELECT jn.navn_pretty FROM sandbox.kontrol_lst_ja_nej jn WHERE jn.fid = fa.nillable::integer) || '</p>'
									,'<p>Enhed: ' || fa.enhed || '</p>'
									,sandbox.kontrol_html_opslag(
										_tabel_skema := fa.opslagstabel_skema
										,_tabel_navn := fa.opslagstabel_navn
										,_tabel_kolonne := fa.opslagstabel_kolonne
										,_tabel_kolonne_sql_tooltip := fa.opslagstabel_kolonne_sql_tooltip
										,_tabel_filter := fa.opslagstabel_filter
									)
									,fa.tooltip_html
								]
								,NULL
							)
							,E'\n<hr class="tooltip_break"/>\n'
						)
						,''
					)
				) a(tooltip_html)
		)





		,cte1 AS(
			SELECT
				fa_header.system_fid
				,fa_header.system_pretty
				,fa_header.system_order

				,fa_header.gruppe_fid
				,fa_header.gruppe_pretty
				,fa_header.gruppe_order

				,fa_header.pakke_fid
				,fa_header.pakke_pretty
				,fa_header.pakke_order


				,sandbox.kontrol_html_layouter_vertical(
					_html_lst := ARRAY[
									sandbox.kontrol_html_subsection_header(
										_header_text := fa_header.gruppe_pretty || ' | ' || fa_header.pakke_pretty
										,_id := 'attribute_subsection'
									)
									,sandbox.kontrol_html_layouter_grid(
										_html_lst := array_agg(
														sandbox.kontrol_html_table(
															_table_classes_lst := ARRAY['attributes']
															,_header_data_lst := fa_header._header_data_lst
															,_body_data_lst := fa._body_data_lst
														)
														ORDER BY fa_header.attr_order, fa_header.forsyningsart_min_order
													)
										,_columns := 3
									)
								]
				) AS _html
				,sandbox.kontrol_html_fejl_lst_clean(
					array_agg(
						fa._fejl_lst::text
					)
				) AS _fejl_lst
			FROM feature_attributes_header fa_header
			INNER JOIN feature_attributes fa ON fa_header.system_fid = fa.system_fid
				AND fa_header.gruppe_fid = fa.gruppe_fid
				AND fa_header.attr_fid = fa.attr_fid
				AND fa_header.pakke_fid = fa.pakke_fid
			GROUP BY fa_header.system_fid
				,fa_header.system_pretty
				,fa_header.system_order

				,fa_header.gruppe_fid
				,fa_header.gruppe_pretty
				,fa_header.gruppe_order

				,fa_header.pakke_fid
				,fa_header.pakke_pretty
				,fa_header.pakke_order
		)

		,cte2 AS(
			SELECT
				c.system_fid
				,c.system_order

				,c.gruppe_fid
				,c.gruppe_order

				,sandbox.kontrol_html_layouter_vertical(
					_html_lst := ARRAY[
									sandbox.kontrol_html_section_header(
										_header_text := c.system_pretty || ': ' || c.gruppe_pretty
										,_fejl_lst := sandbox.kontrol_html_fejl_lst_clean(
															array_agg(
																c._fejl_lst::text
															)
														)
									)
									,sandbox.kontrol_html_agg(array_agg(c._html ORDER BY c.pakke_order))
								]
				) AS _html
			FROM cte1 c
			GROUP BY c.system_fid
				,c.system_pretty
				,c.system_order

				,c.gruppe_fid
				,c.gruppe_pretty
				,c.gruppe_order
		)

	SELECT
		sandbox.kontrol_html_layouter_vertical(
			_html_lst := array_agg(c._html ORDER BY c.system_order, c.gruppe_order)
		) AS _html
	FROM cte2 c
	INTO _html;

	RETURN;

END $BODY$;