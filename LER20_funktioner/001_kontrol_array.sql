/* DROP FUNCTION IF EXISTS ler20.kontrol_array(
	array_as_text text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION ler20.kontrol_array(
	array_as_text text
)
	RETURNS TEXT[]
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	array_as_text := NULLIF(TRIM(array_as_text), '');


	IF array_as_text IS NULL
		OR array_as_text ~ '^{.+}$'
	THEN



	ELSIF array_as_text ~ ';' THEN

		array_as_text := string_to_array(
								regexp_replace(
									array_as_text
									,'\s*;\s*'
									,';'
									,'g'
								)
								,';'
							)::text;

	ELSIF array_as_text ~ ',' THEN

		array_as_text := string_to_array(
								regexp_replace(
									array_as_text
									,'\s*,\s*'
									,','
									,'g'
								)
								,','
							)::text;

	ELSE

		array_as_text := ('{' || array_as_text || '}');

	END IF;



	RETURN ARRAY[
		ARRAY[
			'Valid:'
			,CASE
				WHEN array_as_text IS NOT NULL
				THEN TRUE
			END::text
		]
		,ARRAY[
			'Value as text:'
			,array_as_text::text[]::text
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


ALTER FUNCTION ler20.kontrol_array(
	array_as_text text
) OWNER TO kgb_prod_ler_admin;

GRANT EXECUTE ON FUNCTION ler20.kontrol_array(
	array_as_text text
) TO PUBLIC;