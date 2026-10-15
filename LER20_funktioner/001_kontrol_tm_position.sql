/* DROP FUNCTION IF EXISTS ler20.kontrol_tm_position(
	tm_position_as_text text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION ler20.kontrol_tm_position(
	tm_position_as_text text
)
	RETURNS TEXT[]
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_ler_skaering_before text := 'før 1. juli 2023';
	_ler_skaering_date date := '2023-07-01'::date;
	_ler_skaering_format text := 'YYYY-MM-dd';

	_ler_before text := 'før ';
	_ler_before_format text := 'Before ';

	format_string text;
	tm_position_as_date date;
	tm_position_before boolean := FALSE;

BEGIN

	IF tm_position_as_text IS NULL THEN



	ELSIF tm_position_as_text = _ler_skaering_before THEN

		format_string = _ler_skaering_format;
		tm_position_as_date = _ler_skaering_date;
		tm_position_before = TRUE;

	ELSE


		IF tm_position_as_text ~* '^før ' THEN

			tm_position_before = TRUE;
			tm_position_as_text = COALESCE(
									SUBSTRING(
										LOWER(tm_position_as_text)
										,'^' || _ler_before || '(.+)$'
									)
									,tm_position_as_text
								);

		END IF;



		IF tm_position_as_text ~* '^\d{2}[-/\.]\d{2}[-/\.]\d{4}$' THEN

			format_string := 'DD-MM-YYYY';
			tm_position_as_date := to_date(tm_position_as_text, format_string);

		ELSIF tm_position_as_text ~* '^\d{4}[-/\.]\d{2}[-/\.]\d{2}$' THEN

			format_string := 'YYYY-MM-DD';
			tm_position_as_date := to_date(tm_position_as_text, format_string);

		ELSIF tm_position_as_text ~* '^\d{14}$' THEN

			format_string := 'YYYYMMDDHH24MISS';
			tm_position_as_date := to_date(tm_position_as_text, format_string);

		ELSIF tm_position_as_text ~* '^\d{2}[-/\.]\d{4}$' THEN

			format_string := 'MM-YYYY';
			tm_position_as_date := to_date(tm_position_as_text, format_string);

		ELSIF tm_position_as_text ~* '^\d{4}[-/\.]\d{2}$' THEN

			format_string := 'YYYY-MM';
			tm_position_as_date := to_date(tm_position_as_text, format_string);

		ELSIF tm_position_as_text ~* '^\d{4}$' THEN

			format_string := 'YYYY';
			tm_position_as_date := to_date(tm_position_as_text, format_string);

		ELSE

			RAISE EXCEPTION '';

		END IF;

	END IF;



	RETURN ARRAY[
		ARRAY[
			'Valid:'
			,CASE
				WHEN tm_position_as_text IS NULL
				THEN NULL
				WHEN tm_position_before
					AND tm_position_as_date > _ler_skaering_date
				THEN FALSE
				ELSE TRUE
			END::text
		]
		,ARRAY[
			'Value as text:'
			,CASE
				WHEN tm_position_before
					AND tm_position_as_date <= _ler_skaering_date
				THEN _ler_before_format
				ELSE ''
			END || LEFT(TO_CHAR(tm_position_as_date, 'YYYY-MM-DD'), LENGTH(format_string))
		]
		,ARRAY[
			'Before LER2.0:'
			,CASE
				WHEN tm_position_as_text IS NOT NULL
				THEN tm_position_as_date - tm_position_before::int < _ler_skaering_date
				ELSE FALSE
			END::text
		]
		,ARRAY[
			'Value as text (KontrolLER):'
			,CASE
				WHEN tm_position_before
				THEN _ler_before
				ELSE ''
			END || RIGHT(TO_CHAR(tm_position_as_date, 'DD-MM-YYYY'), LENGTH(format_string))
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
			,ARRAY[
				'Before LER2.0:'
				,FALSE::text
			]
			,ARRAY[
				'Value as text (KontrolLER):'
				,NULL
			]
		];

END $BODY$;


ALTER FUNCTION ler20.kontrol_tm_position(
	tm_position_as_text text
) OWNER TO kgb_prod_ler_admin;

GRANT EXECUTE ON FUNCTION ler20.kontrol_tm_position(
	tm_position_as_text text
) TO PUBLIC;