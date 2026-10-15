/* DROP FUNCTION IF EXISTS sandbox.kontrol_xml_encode(
	_xml text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_xml_encode(
	INOUT _xml text
)
	RETURNS TEXT
	IMMUTABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	SELECT
		replace(
			replace(
				replace(
					replace(
						replace(
							_xml
							,'&'
							,'&amp;'
						)
						,'<'
						,'&lt;'
					)
					,'>'
					,'&gt;'
				)
				,''''
				,'&apos;'
			)
			,'"'
			,'&quot;'
		)
	INTO _xml;

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_xml_decode(
	_xml text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_xml_decode(
	INOUT _xml text
)
	RETURNS TEXT
	IMMUTABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	SELECT
		replace(
			replace(
				replace(
					replace(
						replace(
							_xml
							,'&quot;'
							,'"'
						)
						,'&lt;'
						,'<'
					)
					,'&gt;'
					,'>'
				)
				,'&apos;'
				,''''
			)
			,'&amp;'
			,'&'
		)
	INTO _xml;

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_encode(
	_html text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_encode(
	INOUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	IF NOT(
			(
				_html ~* '^<.+>'
				AND _html ~* '</.+>$'
			)
			OR _html ~* '^<.+/>$'
		)
	THEN

		_html := sandbox.kontrol_xml_encode(_html);

		SELECT
			NULLIF(COALESCE(REPEAT('&nbsp;', length(m[1])), '') || COALESCE(m[2], ''), '')
		FROM regexp_match(_html,'^(\s*)([^\s].*)$') m
		INTO _html;

		_html := REPLACE(
					_html
					,E'\n'
					,'</br>'
				);

	END IF;

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_decode(
	_html text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_decode(
	INOUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	_html := sandbox.kontrol_xml_decode(_html);

	_html := REPLACE(
				REPLACE(
					_html
					,'&nbsp;'
					' '
				)
				,'</br>'
				,E'\n'
			);

	RETURN;

END $BODY$;