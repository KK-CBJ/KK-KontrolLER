/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_table_header_body(
	_data_lst text[]

	,_data_classes_lst text[]
	,_data_attributes_lst text[]

	,_row_classes_lst text[]
	,_row_attributes_lst text[]

	,_wrap_classes_lst text[]
	,_wrap_attributes_lst text[]

	,_header BOOLEAN
) CASCADE;
--*/

/*
SELECT sandbox.kontrol_html_table_header_body(
	_data_lst :=				ARRAY[
									ARRAY['colA1', 'colB1']	 -- rowOne
									,ARRAY['colA2', 'colB2']	 -- rowTwo
									,ARRAY['colA3', 'colB3']	 -- rowThree
									,ARRAY['colA4', 'colB4']	 -- rowFour
								]

	,_data_classes_lst := 		ARRAY[
									ARRAY[
										ARRAY['dataClassA', 'dataClassB']::text		-- rowOneColOne
										,ARRAY['dataClassC']::text					-- rowOneColTwo
									]::text
									,ARRAY[
										ARRAY['dataClassD']::text					-- rowTwoColOne
									]::text
								]
	,_data_attributes_lst := ARRAY[
								ARRAY[
									ARRAY[											-- rowOneColOne
										ARRAY['dataAttributeA', 'dataValueA']
										,ARRAY['dataAttributeB', 'dataValueB']
									]::text
									,ARRAY[											-- rowOneColTwo
											ARRAY['dataAttributeC', 'dataValueC']
									]::text
								]::text
								,ARRAY[
									ARRAY[											-- rowTwoColOne
										ARRAY['dataAttributeD', 'dataValueD']
									]::text
								]::text
							]

	,_row_classes_lst := 	ARRAY[
								ARRAY['rowClassA','rowClassB']::text				-- rowOne
								,ARRAY['rowClassC']::text							-- rowTwo
							]
	,_row_attributes_lst := ARRAY[
								ARRAY[
									ARRAY['rowAttributeA','rowValueA']				-- rowOne
									,ARRAY['rowAttributeB','rowValueB']				-- rowOne
								]::text
								,ARRAY[
									ARRAY['rowAttributeC','rowValueC']				-- rowTwo
								]::text
							]

	,_wrap_classes_lst := ARRAY['wrapClassA','wrapClassB']
	,_wrap_attributes_lst := ARRAY[
								ARRAY['wrapattributeA','wrapValueA']
								,ARRAY['wrapAttributeB','wrapValueB']
							]
)
-- */


CREATE OR REPLACE FUNCTION sandbox.kontrol_html_table_header_body(
	_data_lst text[]							-- Aggregate of one dimensional array

	,_data_classes_lst text[] DEFAULT NULL		-- Double aggregate (text) of one dimensional array as text
	,_data_attributes_lst text[] DEFAULT NULL	-- Double aggregate (text) of two dimensionsal array as text

	,_row_classes_lst text[] DEFAULT NULL		-- Aggregate of one dimensional array as text
	,_row_attributes_lst text[] DEFAULT NULL	-- Aggregate of two dimensionsal array as text

	,_wrap_classes_lst text[] DEFAULT NULL		-- One dimensional array
	,_wrap_attributes_lst text[] DEFAULT NULL	-- Two dimensionsal array

	,_header BOOLEAN DEFAULT FALSE

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_data_tag text := 'td';
	_row_tag text := 'tr';
	_wrap_tag text := 'tbody';

BEGIN

	IF _header IS TRUE THEN

		_data_tag := 'th';
		_wrap_tag := 'thead';

	END IF;

	WITH

		-- Data: td / th-tags
		cte1 AS(
			SELECT
				_data_row

				,string_agg(
					sandbox.kontrol_html_wrap(
						_tag := _data_tag
						,_text := _data_content

						,_classes_lst := _data_classes
						,_attributes_lst := _data_attributes
					)
					,E'\n'
					ORDER BY _data_col
				) _html
			FROM generate_series(1, array_length(_data_lst, 1)) _data_row
				,generate_series(1, array_length(_data_lst, 2)) _data_col

				,COALESCE(_data_lst[_data_row][_data_col], '<null>') _data_content

				,COALESCE((_data_classes_lst[_data_row]::text[])[_data_col]::text[]) _data_classes
				,COALESCE((_data_attributes_lst[_data_row]::text[])[_data_col]::text[]) _data_attributes
			GROUP BY _data_row
		)

		-- Row: tr-tags
		,cte2 AS(
			SELECT
				string_agg(
					sandbox.kontrol_html_wrap(
						_tag := _row_tag
						,_text := c._html

						,_classes_lst := _row_classes
						,_attributes_lst := _row_attributes
					)
					,E'\n'
					ORDER BY _data_row
				) _html
			FROM cte1 c

				,COALESCE(_row_classes_lst[_data_row]::text[]) _row_classes
				,COALESCE(_row_attributes_lst[_data_row]::text[]) _row_attributes
		)

	-- Wrap: tbody / thead-tags
	SELECT
		sandbox.kontrol_html_wrap(
			_tag := _wrap_tag
			,_text := c._html

			,_classes_lst := _wrap_classes_lst
			,_attributes_lst := _wrap_attributes_lst
		)
	FROM cte2 c
	WHERE c._html IS NOT NULL
	INTO _html;

	RETURN;

END $BODY$;




/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_table(
	_table_classes_lst text[]
	,_table_attributes_lst text[]


	,_header_data_lst text[]

	,_header_data_classes_lst text[]
	,_header_data_attributes_lst text[]

	,_header_row_classes_lst text[]
	,_header_row_attributes_lst text[]

	,_header_wrap_classes_lst text[]
	,_header_wrap_attributes_lst text[]


	,_body_data_lst text[]

	,_body_data_classes_lst text[]
	,_body_data_attributes_lst text[]

	,_body_row_classes_lst text[]
	,_body_row_attributes_lst text[]

	,_body_wrap_classes_lst text[]
	,_body_wrap_attributes_lst text[]
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_table(
	_table_classes_lst text[] DEFAULT NULL
	,_table_attributes_lst text[] DEFAULT NULL


	,_header_data_lst text[] DEFAULT NULL				-- Aggregate of one dimensional array

	,_header_data_classes_lst text[] DEFAULT NULL		-- Double aggregate (text) of one dimensional array as text
	,_header_data_attributes_lst text[] DEFAULT NULL	-- Double aggregate (text) of two dimensionsal array as text

	,_header_row_classes_lst text[] DEFAULT NULL		-- Aggregate of one dimensional array as text
	,_header_row_attributes_lst text[] DEFAULT NULL	-- Aggregate of two dimensionsal array as text

	,_header_wrap_classes_lst text[] DEFAULT NULL		-- One dimensional array
	,_header_wrap_attributes_lst text[] DEFAULT NULL	-- Two dimensionsal array


	,_body_data_lst text[] DEFAULT NULL				-- Aggregate of one dimensional array

	,_body_data_classes_lst text[] DEFAULT NULL		-- Double aggregate (text) of one dimensional array as text
	,_body_data_attributes_lst text[] DEFAULT NULL	-- Double aggregate (text) of two dimensionsal array as text

	,_body_row_classes_lst text[] DEFAULT NULL		-- Aggregate of one dimensional array as text
	,_body_row_attributes_lst text[] DEFAULT NULL	-- Aggregate of two dimensionsal array as text

	,_body_wrap_classes_lst text[] DEFAULT NULL		-- One dimensional array
	,_body_wrap_attributes_lst text[] DEFAULT NULL	-- Two dimensionsal array

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	SELECT
		sandbox.kontrol_html_wrap(
			_tag := 'table'
			,_text := sandbox.kontrol_html_agg(
							_html_lst := ARRAY[
											header._html
											,body._html
										]
						)

			,_classes_lst := ARRAY['table', 'table-bordered'] || _table_classes_lst
			,_attributes_lst := _table_attributes_lst
		)
	FROM (SELECT '1') a
	LEFT JOIN sandbox.kontrol_html_table_header_body(
			_data_lst := _header_data_lst

			,_data_classes_lst := _header_data_classes_lst
			,_data_attributes_lst := _header_data_attributes_lst

			,_row_classes_lst := _header_row_classes_lst
			,_row_attributes_lst := _header_row_attributes_lst

			,_wrap_classes_lst := _header_wrap_classes_lst
			,_wrap_attributes_lst := _header_wrap_attributes_lst

			,_header := TRUE
		) header ON TRUE
	LEFT JOIN sandbox.kontrol_html_table_header_body(
			_data_lst := _body_data_lst

			,_data_classes_lst := _body_data_classes_lst
			,_data_attributes_lst := _body_data_attributes_lst

			,_row_classes_lst := _body_row_classes_lst
			,_row_attributes_lst := _body_row_attributes_lst

			,_wrap_classes_lst := _body_wrap_classes_lst
			,_wrap_attributes_lst := _body_wrap_attributes_lst

			,_header := FALSE
		) body ON TRUE
	WHERE header._html IS NOT NULL
		OR body._html IS NOT NULL
	INTO _html;

	RETURN;

END $BODY$;




/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_table_wrap(
	_header_body_lst text[]

	,_table_classes_lst text[]
	,_table_attributes_lst text[]
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_table_wrap(
	_header_body_lst text[]

	,_table_classes_lst text[] DEFAULT NULL
	,_table_attributes_lst text[] DEFAULT NULL

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	SELECT
		sandbox.kontrol_html_wrap(
			_tag := 'table'
			,_text := sandbox.kontrol_html_agg(
							_html_lst := _header_body_lst
						)

			,_classes_lst := ARRAY['table', 'table-bordered'] || _table_classes_lst
			,_attributes_lst := _table_attributes_lst
		)
	FROM (SELECT '1') a
	WHERE array_length(_header_body_lst, 1) > 0
	INTO _html;

	RETURN;

END $BODY$;