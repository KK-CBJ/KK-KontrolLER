/* DROP FUNCTION IF EXISTS sandbox.kontrol_restriktion_sql(
	_attr text
	,_restriktion_sql text

	,_attributes_xml xml
	,_etablering_foer_skaering boolean

	,_geometritype text
	,_z_99_count integer
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_restriktion_sql(
	_attr text
	,_restriktion_sql text

	,_attributes_xml xml
	,_etablering_foer_skaering boolean

	,_geometritype text
	,_z_99_count integer
)
	RETURNS TEXT[]
	STABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_restriktion_valid text;

BEGIN

	IF _restriktion_sql IS NULL THEN

		RETURN ARRAY[
			ARRAY[
				'Valid:'
				,NULL::text
			]
		];

	END IF;


	_restriktion_sql := regexp_replace(
							REPLACE(
								_restriktion_sql
								,'[KOLONNE]'
								,'[' || _attr || ']'
							)
							,'\[([^\]]+)\]'
							,'sandbox.kontrol_xml_decode((xpath($$/attributes/\1/text()$$, _attributes_xml))[1]::text)'
							,'g'
						);


	EXECUTE FORMAT(
$$SELECT
	%s
FROM (
		SELECT
			%L::xml AS _attributes_xml
			,%L::boolean AS etablering_foer_skaering
			,%L::text AS geometritype
			,%L::integer AS z_99_count
	) a$$
			,_restriktion_sql
			,_attributes_xml
			,COALESCE(_etablering_foer_skaering, FALSE)
			,_geometritype
			,COALESCE(_z_99_count, 0)
		)
		INTO _restriktion_valid;



	RETURN ARRAY[
		ARRAY[
			'Valid:'
			,COALESCE(_restriktion_valid::text, TRUE::text)
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
				-- 'Error Msg:'
				-- ,NULLIF(SQLERRM, '')
			-- ]
		-- ];

END $BODY$;