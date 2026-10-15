/* DROP FUNCTION IF EXISTS sandbox.kontrol_data_type(
	_kontrol_skema text
	,_kontrol_navn text
	,_kontrol_valid_idx text
	,_kontrol_output_idx text

	,_attr_value text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_data_type(
	_kontrol_skema text
	,_kontrol_navn text
	,_kontrol_valid_idx integer
	,_kontrol_output_idx integer

	,_attr_value text
)
	RETURNS TEXT[]
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_attr_valid_as_data_type text;
	_attr_value_as_data_type text;

BEGIN

	IF _kontrol_skema IS NULL
		OR _kontrol_navn IS NULL
		OR _kontrol_valid_idx IS NULL
		OR _kontrol_output_idx IS NULL
	THEN

		RETURN ARRAY[
			ARRAY[
				'Valid:'
				,NULL::text
			]
			,ARRAY[
				'Value as text:'
				,_attr_value
			]
		];

	END IF;



	EXECUTE FORMAT(
$$SELECT
	kontrol[%4$s][2]
	,kontrol[%5$s][2]
FROM %1$I.%2$I(%3$L) kontrol$$
			,_kontrol_skema
			,_kontrol_navn

			,_attr_value

			,_kontrol_valid_idx
			,_kontrol_output_idx
		)
		INTO _attr_valid_as_data_type
			,_attr_value_as_data_type;



	RETURN ARRAY[
		ARRAY[
			'Valid:'
			,CASE
				WHEN _attr_value IS NULL
				THEN NULL
				ELSE _attr_valid_as_data_type
			END::text
		]
		,ARRAY[
			'Value as text:'
			,COALESCE(_attr_value_as_data_type, _attr_value)
		]
	];


-- EXCEPTION
	-- WHEN others THEN

		-- RETURN ARRAY[
			-- ARRAY[
				-- 'Valid:'
				-- ,FALSE::text
			-- ]
			-- ,ARRAY[
				-- 'Value as text:'
				-- ,_attr_value
			-- ]
			-- ,ARRAY[
				-- 'Error Msg:'
				-- ,SQLERRM
			-- ]
		-- ];

END $BODY$;