/* DROP FUNCTION IF EXISTS ler20.kontrol_integer(
	integer_as_text text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION ler20.kontrol_integer(
	integer_as_text text
)
	RETURNS TEXT[]
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	integer_as_text := NULLIF(TRIM(LOWER(integer_as_text)), '');


	RETURN ARRAY[
		ARRAY[
			'Valid:'
			,CASE
				WHEN integer_as_text IS NOT NULL
				THEN TRUE
			END::text
		]
		,ARRAY[
			'Value as text:'
			,integer_as_text::integer::text
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


ALTER FUNCTION ler20.kontrol_integer(
	integer_as_text text
) OWNER TO kgb_prod_ler_admin;

GRANT EXECUTE ON FUNCTION ler20.kontrol_integer(
	integer_as_text text
) TO PUBLIC;