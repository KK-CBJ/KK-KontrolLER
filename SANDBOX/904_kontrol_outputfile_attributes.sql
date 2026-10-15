
/* DROP FUNCTION IF EXISTS sandbox.kontrol_outputfile_attributes(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_outputfile_attributes(
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

		inputfiles AS(
			SELECT DISTINCT ON(f.inputfile_fid, ft.featuretype_fid)
				f.inputfile_fid
				,f.inputfile_pretty
				,f.inputfile_order

				,ft.featuretype_fid
				,ft.featuretype_pretty
				,ft.featuretype_order

				,t.inputfile_attributes_xml
			FROM sandbox.kontrol_inputfiles f
				,xmltable(
					'/*' passing f.inputfile_xml
						COLUMNS
							inputfile_attributes_xml xml path '/inputFile/attributes'
				) t
				,sandbox.kontrol_inputfiles_features ft
			WHERE f.kontrol_guid = _kontrol_guid
				AND f.fejl = 0
				AND f.kontrol_guid = ft.kontrol_guid
				AND f.inputfile_fid = ft.inputfile_fid
		)

		,featuretype_attributes AS(
			SELECT
				i.inputfile_fid
				,i.inputfile_pretty
				,i.inputfile_order

				,i.featuretype_fid
				,i.featuretype_pretty
				,i.featuretype_order

				,sandbox.kontrol_html_table_header_body(
					_data_lst := array_agg(
									ARRAY[
										sandbox.kontrol_html_tooltip(
											_html := sandbox.kontrol_html_agg(
															ARRAY[
																'<p>Mulig navngivning:</p>'
																,sandbox.kontrol_html_wrap(
																	_tag := 'ul'
																	,_text := sandbox.kontrol_html_wrap(
																		_tag := 'li'
																		,_text_lst := ft_a.attr_lst
																	)
																)
															]
													)
											,_tooltip_tegn := '<span>&#10007;</span>'
										)
										,ft_a.attr_pretty
									]
									ORDER BY ft_a.attr_order
								)

					,_data_classes_lst := array_agg(
											ARRAY[
												ARRAY[COALESCE(ft_a.fejl_type, 'error_marker')]::text
											]::text
											ORDER BY ft_a.attr_order
										)
				) AS _html

			FROM inputfiles i
				,sandbox.kontrol_featuretype_attributes(
					_featuretype_fid := i.featuretype_fid
				) ft_a
				,xmltable(
					'/*' passing i.inputfile_attributes_xml
						COLUMNS
							match_count integer path 'count(/attributes/attribute[contains(''' || array_to_string(ft_a.attr_lst, ' ') || ''', @name)])'
				) t
			WHERE ft_a.kontrol_type IS DISTINCT FROM 'hidden'
				AND ft_a.kontrol_type IS DISTINCT FROM 'hidden_attr'
				AND t.match_count = 0
			GROUP BY i.inputfile_fid
				,i.inputfile_pretty
				,i.inputfile_order

				,i.featuretype_fid
				,i.featuretype_pretty
				,i.featuretype_order
		)


		,cte1 AS(
			SELECT
				fa.inputfile_fid
				,fa.inputfile_pretty
				,fa.inputfile_order


				,sandbox.kontrol_html_table_wrap(
					_header_body_lst := ARRAY[
											sandbox.kontrol_html_table_header_body(
												_data_lst := ARRAY[
																ARRAY[
																	sandbox.kontrol_html_tooltip(
																		_html := (SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'attributes_tbl_attribute_missing_tooltip_html')
																	)
																	,'<span>' || REPLACE(fa.inputfile_pretty, ': ', ':<br/>') || '</span>'
																]
															]

												,_header := TRUE
											)
										]
										|| array_agg(
												sandbox.kontrol_html_agg(
													_html_lst := ARRAY[
																	sandbox.kontrol_html_table_header_body(
																		_data_lst := ARRAY[
																						ARRAY[
																							fa.featuretype_pretty
																						]
																					]

																		,_data_attributes_lst := ARRAY[
																									ARRAY[
																										ARRAY[
																											ARRAY['colspan', '2']
																										]::text
																									]::text
																								]

																		,_header := TRUE
																	)
																	,fa._html
																]
												)
												ORDER BY fa.featuretype_order
											)

					,_table_classes_lst := ARRAY['attribute_missing']
				) AS _html

				,array_agg(1) AS fejl_lst
			FROM featuretype_attributes fa
			GROUP BY fa.inputfile_fid
				,fa.inputfile_pretty
				,fa.inputfile_order
		)

		,cte2 AS(
			SELECT
				sandbox.kontrol_html_layouter_grid(
					_html_lst := array_agg(
									c._html
									ORDER BY c.inputfile_order
								)
					,_columns := 3
				) AS _html

				,sandbox.kontrol_html_fejl_lst_clean(
					_fejl_lst := array_agg(c.fejl_lst::text)
				) AS fejl_lst
			FROM cte1 c
		)

	SELECT
		sandbox.kontrol_html_layouter_vertical(
			_html_lst := ARRAY[
								sandbox.kontrol_html_section_header(
									_header_text := (
														SELECT
															_value
														FROM sandbox.kontrol_lst_skabeloner
														WHERE _name = CASE
																		WHEN c.fejl_lst IS NOT NULL
																		THEN 'attributes_header_txt_title'
																		ELSE 'attributes_header_txt_title_no_error'
																	END
													)
									,_fejl_lst := COALESCE(c.fejl_lst, ARRAY[0])
								)
								,c._html
							]
		) AS _html
	FROM (SELECT '1') a
	LEFT JOIN cte2 c ON TRUE
	INTO _html;

	RETURN;

END $BODY$;