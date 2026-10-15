/* DROP FUNCTION IF EXISTS sandbox.kontrol_outputfile_inputfiles(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_outputfile_inputfiles(
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
			SELECT
				f.inputfile_pretty
				,f.inputfile_order
				,f.inputfile_feature_count

				,f.featuretype_pretty

				,f.system_pretty
				,f.forsyningsart_pretty
				,f.gruppe_pretty
				,f.geometritype_pretty

				,f.fejl
			-- FROM sandbox.kontrol_inputfiles(
					-- _kontrol_guid := _kontrol_guid
			-- ) f
			FROM sandbox.kontrol_inputfiles f
			WHERE f.kontrol_guid = _kontrol_guid
		)

		,cte1 AS(
			SELECT
				sandbox.kontrol_html_layouter_grid(
					ARRAY[
						sandbox.kontrol_html_table(
							_table_classes_lst := ARRAY['files_overview']

							,_header_data_lst := ARRAY[
													ARRAY[
														sandbox.kontrol_html_tooltip(
															_html := (SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'files_tbl_files_overview_tooltip_html')
														)
														,'Filnavn'
														,'Featuretype'

														,'System'
														,'Forsyningsart'
														,'Gruppe'
														,'Geometri'

														,'Antal'
													]
												]
							,_body_data_lst := array_agg(
												ARRAY[
													sandbox.kontrol_html_error_tegn(ARRAY[c.fejl])
													,c.inputfile_pretty
													,COALESCE(c.featuretype_pretty, '')

													,COALESCE(c.system_pretty, '')
													,COALESCE(c.forsyningsart_pretty, '')
													,COALESCE(c.gruppe_pretty, '')
													,COALESCE(c.geometritype_pretty, '')

													,COALESCE(c.inputfile_feature_count::text, '0')
												]
												ORDER BY c.fejl DESC
													,c.inputfile_order
											)
						)
					]
				) AS _html

				,array_agg(c.fejl) AS fejl_lst
			FROM inputfiles c
		)


	SELECT
		sandbox.kontrol_html_layouter_vertical(
			_html_lst := ARRAY[
								sandbox.kontrol_html_section_header(
									_header_text := (SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'files_header_txt_title')
									,_fejl_lst := c.fejl_lst
								)
								,c._html
							]
		) AS _html
	FROM cte1 c
	WHERE c.fejl_lst IS NOT NULL
	INTO _html;

	RETURN;

END $BODY$;