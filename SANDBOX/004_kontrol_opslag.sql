/* DROP FUNCTION IF EXISTS sandbox.kontrol_opslag(
	_tabel_skema text
	,_tabel_navn text
	,_tabel_kolonne text
	,_tabel_filter text

	,_attr_value text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_opslag(
	_tabel_skema text
	,_tabel_navn text
	,_tabel_kolonne text
	,_tabel_filter text

	,_attr_value text
)
	RETURNS TEXT[]
	STABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_attr_value_opslag text;

BEGIN

	IF _tabel_skema IS NULL
		OR _tabel_navn IS NULL
		OR _tabel_kolonne IS NULL
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
	%3$I::text
FROM %1$I.%2$I
	,ler20.kontrol_other(%4$L) _attr_value_other
WHERE %5$s%6$s
LIMIT 1$$
			,_tabel_skema
			,_tabel_navn
			,_tabel_kolonne

			,_attr_value

			,'(' || NULLIF(TRIM(_tabel_filter), '') || E')\n\t AND '
			,FORMAT(
				$$(
	%1$I IN(%2$L, LOWER(%2$L), _attr_value_other[2][2], LOWER(_attr_value_other[2][2]))
	OR REPLACE(%1$I, ' ', '') IN(REPLACE(%2$L, ' ', ''), REPLACE(LOWER(%2$L), ' ', ''), REPLACE(_attr_value_other[2][2], ' ', ''), REPLACE(LOWER(_attr_value_other[2][2]), ' ', ''))
)$$
				,_tabel_kolonne
				,_attr_value
			)
		)
		INTO _attr_value_opslag;



	RETURN ARRAY[
		ARRAY[
			'Valid:'
			,CASE
				WHEN _attr_value IS NULL
				THEN NULL
				WHEN _attr_value_opslag IS NULL
				THEN FALSE
				ELSE TRUE
			END::text
		]
		,ARRAY[
			'Value as text:'
			,COALESCE(_attr_value_opslag, _attr_value)
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