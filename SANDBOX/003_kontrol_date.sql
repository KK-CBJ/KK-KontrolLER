/* DROP FUNCTION IF EXISTS sandbox.kontrol_date(
	date_as_text text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_date(
	date_as_text text
)
	RETURNS TEXT[]
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	format_string text;
	date_as_date date;

BEGIN

	IF date_as_text IS NOT NULL THEN

		IF date_as_text ~* '^\d{8}$' THEN

			format_string := 'YYYYMMDD';
			date_as_date := to_date(date_as_text, format_string);

		ELSIF date_as_text ~* '^\d{2}[-/\.]\d{2}[-/\.]\d{4}$' THEN

			format_string := 'DD-MM-YYYY';
			date_as_date := to_date(date_as_text, format_string);

		ELSIF date_as_text ~* '^\d{4}[-/\.]\d{2}[-/\.]\d{2}$' THEN

			format_string := 'YYYY-MM-DD';
			date_as_date := to_date(date_as_text, format_string);

		ELSIF date_as_text ~* '^\d{14}$' THEN

			format_string := 'YYYYMMDDHH24MISS';
			date_as_date := to_date(date_as_text, format_string);

		ELSIF date_as_text ~* '^\d{2}[-/\.]\d{4}$' THEN

			format_string := 'MM-YYYY';
			date_as_date := to_date(date_as_text, format_string);

		ELSIF date_as_text ~* '^\d{4}[-/\.]\d{2}$' THEN

			format_string := 'YYYY-MM';
			date_as_date := to_date(date_as_text, format_string);

		ELSIF date_as_text ~* '^\d{4}$' THEN

			format_string := 'YYYY';
			date_as_date := to_date(date_as_text, format_string);

		ELSE

			RAISE EXCEPTION '';

		END IF;

	END IF;



	RETURN ARRAY[
		ARRAY[
			'Valid:'
			,CASE
				WHEN date_as_text IS NULL
				THEN NULL
				ELSE TRUE
			END::text
		]
		,ARRAY[
			'Value as text:'
			,TO_CHAR(date_as_date, 'YYYY-MM-DD')
		]
	];


EXCEPTION
	WHEN others THEN

		RETURN ARRAY[
			ARRAY[
				'Valid:'
				,FALSE::text
			]
			,ARRAY[
				'Value as text:'
				,NULL
			]
		];

END $BODY$;


ALTER FUNCTION sandbox.kontrol_date(
	date_as_text text
) OWNER TO kgb_prod_ler_admin;

GRANT EXECUTE ON FUNCTION sandbox.kontrol_date(
	date_as_text text
) TO PUBLIC;