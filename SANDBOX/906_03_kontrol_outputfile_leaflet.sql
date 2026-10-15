/* DROP FUNCTION IF EXISTS sandbox.kontrol_outputfile_leaflet(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_outputfile_leaflet(
	_kontrol_guid uuid

	,OUT _html text
)
	RETURNS TEXT
	STABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	SELECT
		sandbox.kontrol_html_layouter_vertical(
			_html_lst := ARRAY[
							sandbox.kontrol_html_section_header(
								_header_text := (SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'leaflet_header_txt_title')
								,_fejl_lst := ARRAY[-1]
							)
							,sandbox.kontrol_html_agg(
								_html_lst := ARRAY[
$$<div id="map">
	<div id="mapNoShow">Kortet vises ikke efter download. Åbn i stedet den hentede fil.</div>
</div>$$
												,j._html
											]
							)
						]
		)
	FROM sandbox.kontrol_outputfile_leaflet_js(
			_kontrol_guid := _kontrol_guid
		) j
	INTO _html;

	RETURN;

END $BODY$;