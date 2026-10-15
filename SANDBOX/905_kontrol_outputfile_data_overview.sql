/* DROP FUNCTION IF EXISTS sandbox.kontrol_outputfile_data_overview(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_outputfile_data_overview(
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

		features AS(
			SELECT
				f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_pretty
				,f.gruppe_order

				,f.featuretype_order

				,COALESCE(f.geom_geometritype_order, f.geometritype_order) AS geometritype_order

				,CASE
					WHEN f.featuretype IS NOT NULl
					THEN f.featuretype_pretty || COALESCE( ': ' || f.feature_group, '')
					ELSE f.feature_group
				END

				,g.mgd_type
				,g.mgd_enhed
				,g.mgd

				,g.z_min
				,g.z_max

				,g.z_0_count
				,g.z_99_count
				,g.z_nan_count

				,(NOT(f.pg_geometritype ~* f.geom_pg_geometritype
					OR f.geom_pg_geometritype ~* f.pg_geometritype))::integer AS fejl_geometritype
			-- FROM sandbox.kontrol_inputfiles_features(
					-- _kontrol_guid := _kontrol_guid
			-- ) f
			FROM sandbox.kontrol_inputfiles_features f
				,xmltable(
					'/*' passing f.geom_xml
						COLUMNS
							mgd_type text path '/geometry/mgd_type/text()'
							,mgd_enhed text path '/geometry/mgd_enhed/text()'
							,mgd numeric path '/geometry/mgd/text()'

							,z_min numeric path '/geometry/z_min/text()'
							,z_max numeric path '/geometry/z_max/text()'

							,z_0_count numeric path '/geometry/z_0_count/text()'
							,z_99_count numeric path '/geometry/z_99_count/text()'
							,z_nan_count numeric path '/geometry/z_nan_count/text()'
				) g
			WHERE f.kontrol_guid = _kontrol_guid
				AND f.feature_eksisterende = 0
		)

		,features_mgd_type_1 AS(
			SELECT
				f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_pretty
				,f.gruppe_order

				,f.featuretype_order

				,f.geometritype_order

				,f.feature_group

				,f.mgd_type
				,f.mgd_enhed

				,SUM(mgd) AS mgd
				,COUNT(mgd) AS mgd_count

				,MIN(f.z_min) AS z_min
				,MAX(f.z_max) AS z_max

				,SUM(f.z_0_count) AS z_0_count
				,SUM(f.z_99_count) AS z_99_count
				,SUM(f.z_nan_count) AS z_nan_count

				,MAX(f.fejl_geometritype) AS fejl_geometritype
			FROM features f
			WHERE f.mgd IS NOT NULL
			GROUP BY f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_pretty
				,f.gruppe_order

				,f.featuretype_order

				,f.geometritype_order

				,f.feature_group

				,f.mgd_type
				,f.mgd_enhed
		)

		,features_mgd_type AS(
			SELECT
				f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_pretty
				,f.gruppe_order

				,f.geometritype_order

				,f.mgd_type

				-- Subtabel med oversigt grupperet pr. type
				,sandbox.kontrol_html_agg(
					ARRAY[
						sandbox.kontrol_html_table_header_body(
							_data_lst := ARRAY[
											ARRAY[
												FORMAT(
													$$<span>%s</span>$$
													,COALESCE(
														sandbox.kontrol_html_error_tegn(
															CASE
																WHEN MAX(f.fejl_geometritype) > 0
																THEN ARRAY[1]
															END
														) || ' '
														, ''
													)
													|| sandbox.kontrol_xml_encode(f.mgd_type) -- || ' pr. type')
												)
											] || array_remove(
													ARRAY[
														CASE
															WHEN f.mgd_enhed IS DISTINCT FROM 'stk'
															THEN sandbox.kontrol_html_wrap(
																	_tag := 'span'
																	,_text := 'Antal (stk)'
																)
														END
													]
													,NULL
												)
										]

							,_data_classes_lst := ARRAY[
														(
															ARRAY[
																ARRAY['tbl_subheader']::text
															]
															|| array_remove(
																ARRAY[
																	CASE
																		WHEN f.mgd_enhed IS DISTINCT FROM 'stk'
																		THEN ARRAY['tbl_subheader']::text
																	END
																]
																,NULL
															)
														)::text
													]
							,_data_attributes_lst := ARRAY[
														ARRAY[
															ARRAY[
																ARRAY['colspan', CASE WHEN f.mgd_enhed IS DISTINCT FROM 'stk' THEN '2' ELSE '3' END]
															]::text
														]::text
													]

							,_header := FALSE
						)
						,sandbox.kontrol_html_table_header_body(
							_data_lst := array_agg(
												CASE
													WHEN f.mgd_enhed IS DISTINCT FROM 'stk'
													THEN ARRAY[f.feature_group, f.mgd::int::text, f.mgd_count::int::text]
													ELSE ARRAY[f.feature_group, f.mgd::int::text]
												END
												-- ARRAY[f.feature_group, f.mgd::int::text]
												ORDER BY f.featuretype_order, f.feature_group NULLS FIRST
											)

							,_data_classes_lst := array_agg(
													CASE
														WHEN f.mgd_enhed IS DISTINCT FROM 'stk'
														THEN ARRAY[
																ARRAY[NULL]::text
																,ARRAY['tbl_count']::text
																,ARRAY['tbl_count']::text
															]::text
														ELSE ARRAY[
																ARRAY[NULL]::text
																,ARRAY['tbl_count']::text
															]::text
													END
													ORDER BY f.featuretype_order, f.feature_group NULLS FIRST
												)
							,_data_attributes_lst := array_agg(
													CASE
														WHEN f.mgd_enhed IS DISTINCT FROM 'stk'
														THEN NULL::text
														ELSE ARRAY[
																ARRAY[
																	ARRAY['colspan', '2']
																]::text
															]::text
													END
													ORDER BY f.featuretype_order, f.feature_group NULLS FIRST
												)

							,_header := FALSE
						)
					]
				) AS _html

				,SUM(f.mgd) AS mgd

				,MIN(f.z_min) AS z_min
				,MAX(f.z_max) AS z_max

				,SUM(f.z_0_count) AS z_0_count
				,SUM(f.z_99_count) AS z_99_count
				,SUM(f.z_nan_count) AS z_nan_count

				,MAX(f.fejl_geometritype) AS fejl_geometritype
			FROM features_mgd_type_1 f
			GROUP BY f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_pretty
				,f.gruppe_order

				,f.geometritype_order

				,f.mgd_type
				,f.mgd_enhed
		)

		-- Tabel pr system / forsyningsart / gruppe
		,features_gruppe AS(
			SELECT
				f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_pretty
				,f.gruppe_order

				,sandbox.kontrol_html_agg(
					ARRAY[
						sandbox.kontrol_html_table_header_body(
							_data_lst := ARRAY[
												ARRAY[f.gruppe_pretty]
											]

							,_data_classes_lst := ARRAY[
														ARRAY[
															ARRAY['tbl_header']::text
														]::text
													]
							,_data_attributes_lst := ARRAY[
														ARRAY[
															ARRAY[
																ARRAY['colspan', '3']
															]::text
														]::text
													]

							,_header := FALSE
						)
						,sandbox.kontrol_html_table_header_body(
							_data_lst := CASE
												WHEN MIN(f.z_min) IS NOT NULL
												THEN ARRAY[
														ARRAY['Z (Min/Maks)', ROUND(MIN(f.z_min)::numeric, 4)::double precision::text || ' - ' || ROUND(MAX(f.z_max)::numeric, 4)::double precision::text]
														,ARRAY[
																FORMAT(
																	$$<span>%s</span>$$
																	,COALESCE(
																		sandbox.kontrol_html_error_tegn(
																			CASE
																				WHEN SUM(f.z_0_count) > 0
																				THEN ARRAY[-1]
																			END
																		) || ' '
																		, ''
																	)
																	|| sandbox.kontrol_xml_encode('"0"-Z-koordinater')
																)
																,SUM(f.z_0_count)::text
														]
														,ARRAY[
																FORMAT(
																	$$<span>%s</span>$$
																	,COALESCE(
																		sandbox.kontrol_html_error_tegn(
																			CASE
																				WHEN SUM(f.z_99_count) > 0
																				THEN ARRAY[-1]
																			END
																		) || ' '
																		, ''
																	)
																	|| sandbox.kontrol_xml_encode('Ukendte (-99) Z-koordinater')
																)
																,SUM(f.z_99_count)::text
														]
														,ARRAY[
																FORMAT(
																	$$<span>%s</span>$$
																	,COALESCE(
																		sandbox.kontrol_html_error_tegn(
																			CASE
																				WHEN SUM(f.z_nan_count) > 0
																				THEN ARRAY[1]
																			END
																		) || ' '
																		, ''
																	)
																	|| sandbox.kontrol_xml_encode('"NaN"-Z-koordinater')
																)
																,SUM(f.z_nan_count)::text
														]
													]
											END
											|| array_agg(
												ARRAY[
													FORMAT(
														$$<span>%s</span>$$
														,COALESCE(
															sandbox.kontrol_html_error_tegn(
																CASE
																	WHEN f.fejl_geometritype > 0
																	THEN ARRAY[1]
																END
															) || ' '
															, ''
														)
														|| sandbox.kontrol_xml_encode(f.mgd_type)
													)
													,f.mgd::int::text
												]
												ORDER BY f.geometritype_order
											)


							,_data_classes_lst := ARRAY[
													ARRAY[
														ARRAY[NULL]::text
														,ARRAY['tbl_count']::text
													]::text
													,ARRAY[
														ARRAY[NULL]::text
														,ARRAY['tbl_count']::text
													]::text
													,ARRAY[
														ARRAY[NULL]::text
														,ARRAY['tbl_count']::text
													]::text
													,ARRAY[
														ARRAY[NULL]::text
														,ARRAY['tbl_count']::text
													]::text
												]
												|| array_agg(
															ARRAY[
																ARRAY[NULL]::text
																,ARRAY['tbl_count']::text
															]::text
														)

							,_data_attributes_lst := ARRAY[
														ARRAY[
															ARRAY[
																ARRAY['colspan', '2']
															]::text
														]::text
														,ARRAY[
															ARRAY[
																ARRAY['colspan', '2']
															]::text
														]::text
														,ARRAY[
															ARRAY[
																ARRAY['colspan', '2']
															]::text
														]::text
														,ARRAY[
															ARRAY[
																ARRAY['colspan', '2']
															]::text
														]::text
													]
													|| array_agg(
																ARRAY[
																	ARRAY[
																		ARRAY['colspan', '2']
																	]::text
																]::text
															)

							,_header := FALSE
						)
					]
						|| array_agg(f._html ORDER BY f.geometritype_order)
				) AS _html
				,ARRAY[
					CASE
						WHEN SUM(f.z_nan_count) > 0
						THEN 1
					END
					,CASE
						WHEN MAX(f.fejl_geometritype) > 0
						THEN 1
					END
				] AS _fejl_lst
			FROM features_mgd_type f
			GROUP BY f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_pretty
				,f.gruppe_order
		)

		,features_forsyningsart AS(
			SELECT
				f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,sandbox.kontrol_html_table_wrap(
					_header_body_lst := ARRAY[
											sandbox.kontrol_html_table_header_body(
												_data_lst := ARRAY[
																	ARRAY[f.forsyningsart_pretty]
																]

												,_data_attributes_lst := ARRAY[
																			ARRAY[
																				ARRAY[
																					ARRAY['colspan', '3']
																				]::text
																			]::text
																		]

												,_header := TRUE
											)
										]
											|| array_agg(f._html ORDER BY f.gruppe_order)

					,_table_classes_lst := ARRAY['data_overview']
				) AS _html
				,sandbox.kontrol_html_fejl_lst_clean(
					array_agg(
						f._fejl_lst::text
					)
				) AS _fejl_lst
			FROM features_gruppe f
			GROUP BY f.system_pretty
				,f.system_order

				,f.forsyningsart_pretty
				,f.forsyningsart_order
		)

		,features_system AS(
			SELECT
				f.system_pretty
				,f.system_order


				,sandbox.kontrol_html_layouter_vertical(
					_html_lst := ARRAY[
									sandbox.kontrol_html_subsection_header(
										_header_text := 'System: ' || f.system_pretty
										,_header_level := 4
										,_id := 'data_overview_subsection'
									)
									,sandbox.kontrol_html_layouter_grid(
										_html_lst := array_agg(
														f._html
														ORDER BY f.forsyningsart_order
													)
										,_columns := 2
									)
								]
				) AS _html

				,sandbox.kontrol_html_fejl_lst_clean(
					array_agg(
						f._fejl_lst::text
					)
				) AS _fejl_lst
			FROM features_forsyningsart f
			GROUP BY f.system_pretty
				,f.system_order
		)

	SELECT
		sandbox.kontrol_html_layouter_vertical(
			_html_lst := ARRAY[
								sandbox.kontrol_html_section_header(
									_header_text := (SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'data_overview_header_txt_title')
									,_fejl_lst := sandbox.kontrol_html_fejl_lst_clean(
														array_agg(
															f._fejl_lst::text
														)
													) || ARRAY[-1]
								)
								,sandbox.kontrol_html_agg(array_agg(f._html ORDER BY f.system_order))
							]
		) AS _html
	FROM features_system f
	INTO _html;

	RETURN;

END $BODY$;