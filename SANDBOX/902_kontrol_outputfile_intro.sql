/* DROP FUNCTION IF EXISTS sandbox.kontrol_outputfile_intro(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_outputfile_intro(
	_kontrol_guid uuid

	,OUT _html text
)
	RETURNS TEXT
	STABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	kontrol record;

	_header text;

	_child_left text;
	_child_right text;

	_tbl_forklaring text;

BEGIN

	SELECT
		k.guid
		,k.datooprettet
		-- ,((xpath('/kontrolLER/title/text()', k._xml::xml))[1])::text AS title
		,k.titel AS title
	FROM sandbox.kontrol_xml k
	WHERE k.guid = _kontrol_guid
	INTO kontrol;



--
-- HEADER
--



	SELECT
		sandbox.kontrol_html_layouter_vertical(
			ARRAY[
				sandbox.kontrol_html_agg(
					ARRAY[
						sandbox.kontrol_html_wrap(
							_tag := 'H1'
							,_text := (SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'intro_header_txt_title')

							,_classes_lst := _classes_lst
							,_attributes_lst := _attributes_lst
						)
						,CASE
							WHEN kontrol.title IS NOT NULL
							THEN sandbox.kontrol_html_wrap(
									_tag := 'H3'
									,_text := kontrol.title

									,_classes_lst := _classes_lst
									,_attributes_lst := _attributes_lst
								)
						END
					]
				)
			]
		)
	FROM (SELECT
			ARRAY['text-center', 'report-header'] AS _classes_lst
			,ARRAY[ARRAY['style', 'color:rgb(0,0,0)']] AS _attributes_lst
		) a
	INTO _header;



--
-- CHILD LEFT
--



	_tbl_forklaring := sandbox.kontrol_html_table(
		_table_classes_lst := ARRAY['forklaring_overview']

		,_body_data_lst := ARRAY[
								ARRAY[
									sandbox.kontrol_html_tooltip(
										_html := '<p>Eksempel</p>'
										,_tooltip_tegn := '<b>?</b>'
									)
									,(SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'intro_tbl_forklaring_overview_txt_tooltip')
								]
								,ARRAY[
									sandbox.kontrol_html_error_tegn(ARRAY[0])
									,(SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'intro_tbl_forklaring_overview_txt_approved')
								]
								,ARRAY[
									sandbox.kontrol_html_error_tegn(ARRAY[1])
									,(SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'intro_tbl_forklaring_overview_txt_error')
								]
								,ARRAY[
									sandbox.kontrol_html_error_tegn(ARRAY[-1])
									,(SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'intro_tbl_forklaring_overview_txt_obs')
								]
							]
	);

	_child_left := FORMAT(
		(SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'intro_child_left_html_template')
		,sandbox.kontrol_html_indent(_tbl_forklaring)
		,sandbox.kontrol_html_error_tegn(ARRAY[0])
		,sandbox.kontrol_html_error_tegn(ARRAY[1])
	);



--
-- CHILD RIGHT
--



	_child_right := FORMAT(
		(SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'intro_child_right_html_template')
		,kontrol.guid
		,to_char(kontrol.datooprettet, 'DD-MM-YYYY HH24:MI')
	);



--
-- HTML
--

	_html := sandbox.kontrol_html_layouter_vertical(
		ARRAY[
			_header
			,sandbox.kontrol_html_layouter_vertical(
				ARRAY[
					sandbox.kontrol_html_wrap(
						'div'
						,sandbox.kontrol_html_agg(
							ARRAY[
								_child_left
								,_child_right
							]
						)

						,_classes_lst := ARRAY['intro-parent']
					)
				]
			)
		]
	);

	RETURN;

END $BODY$;