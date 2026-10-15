/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_opslag(
	_tabel_skema text
	,_tabel_navn text
	,_tabel_kolonne text
	,_tabel_kolonne_sql_tooltip text
	,_tabel_filter text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_opslag(
	_tabel_skema text
	,_tabel_navn text
	,_tabel_kolonne text
	,_tabel_kolonne_sql_tooltip text
	,_tabel_filter text

	,OUT _html text
)
	RETURNS TEXT
	STABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_lst_count integer;

BEGIN

	IF _tabel_skema IS NULL
		OR _tabel_navn IS NULL
		OR _tabel_kolonne IS NULL
	THEN

		RETURN;

	END IF;



	EXECUTE FORMAT(
$$SELECT
	string_agg(
		CASE
			WHEN %3$I = 'ukendt'
			THEN E'\t<br/>\n'
			ELSE ''
		END
		|| FORMAT(
			'	<li>%%s</li>'
			,sandbox.kontrol_xml_encode(%3$I || COALESCE(' (' || %4$s || ')', ''))
		)
		,E'\n'
		ORDER BY CASE
					WHEN %3$I = 'ukendt'
					THEN 1
					ELSE 0
				END
				,CASE
					WHEN %3$I ~* 'other: '
					THEN 1
					ELSE 0
				END
				,%3$I
	)
	,COUNT(*)
FROM %1$I.%2$I%5$s$$
			,_tabel_skema
			,_tabel_navn
			,_tabel_kolonne
			,COALESCE(_tabel_kolonne_sql_tooltip, 'NULL')

			,E'\nWHERE ' || NULLIF(TRIM(_tabel_filter), '')
		)
		INTO _html
			,_lst_count;



		_lst_count := NULLIF(CEILING(_lst_count::numeric / 15), 1);



		_html := FORMAT(
$$<p>Tilladte værdier:</p>
<ul%2$s>
%1$s
</ul>$$
					,_html
					,' class="ul-columns" style="columns: ' || _lst_count || '; -webkit-columns: ' || _lst_count || '; -moz-columns: ' || _lst_count || ';"'
				);

-- EXCEPTION
	-- WHEN others THEN

		-- RETURN;

END $BODY$;