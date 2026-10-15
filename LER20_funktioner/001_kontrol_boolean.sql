/* DROP FUNCTION IF EXISTS ler20.kontrol_boolean(
	boolean_as_text text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION ler20.kontrol_boolean(
	boolean_as_text text
)
	RETURNS TEXT[]
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	boolean_as_text := NULLIF(TRIM(LOWER(boolean_as_text)), '');


	IF boolean_as_text IS NULL THEN



	ELSIF boolean_as_text IN('1', 't', 'true', 'j', 'ja', 's', 'sand') THEN

		boolean_as_text := '1';

	ELSIF boolean_as_text IN('0', 'f', 'false', 'n', 'nej', 'falsk') THEN

		boolean_as_text := '0';

	ELSE

		RAISE EXCEPTION '';

	END IF;



	RETURN ARRAY[
		ARRAY[
			'Valid:'
			,CASE
				WHEN boolean_as_text IS NOT NULL
				THEN TRUE
			END::text
		]
		,ARRAY[
			'Value as text:'
			,boolean_as_text
		]
		,ARRAY[
			'Value as text (KontrolLER):'
			,CASE
				WHEN boolean_as_text = '0'
				THEN 'nej'
				
				WHEN boolean_as_text = '1'
				THEN 'ja'
			END
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
				'Value as text (KontrolLER):'
				,NULL
			]
		];

END $BODY$;


ALTER FUNCTION ler20.kontrol_boolean(
	boolean_as_text text
) OWNER TO kgb_prod_ler_admin;

GRANT EXECUTE ON FUNCTION ler20.kontrol_boolean(
	boolean_as_text text
) TO PUBLIC;