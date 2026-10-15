/* DROP FUNCTION IF EXISTS sandbox.kontrol_outputfile_head(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_outputfile_head(
	_kontrol_guid uuid

	,OUT _html text
)
	RETURNS TEXT
	STABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	_html := sandbox.kontrol_html_wrap(
		'head'
		,FORMAT(
			(SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'head_html_template')
			,_kontrol_guid
		)
			|| FORMAT(
$$
<style>
%s
</style>$$
					,sandbox.kontrol_html_indent(
						(SELECT _value FROM sandbox.kontrol_lst_skabeloner WHERE _name = 'head_style_css')
					)
				)
	);

	RETURN;

END $BODY$;