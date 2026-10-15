/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_agg(
	_html_lst text[]
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_agg(
	_html_lst text[]

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	_html := NULLIF(
				array_to_string(
					array_remove(
						_html_lst
						,NULL
					)
					,E'\n'
				)
				,''
			);

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_indent(
	_html text
	,_indents integer
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_indent(
	INOUT _html text
	,_indents integer DEFAULT NULL
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	IF _indents = 0 THEN

		RETURN;

	END IF;

	_indents := COALESCE(_indents, 1);


	_html := REPEAT(E'\t', _indents)
				|| regexp_replace(
						_html
						,E'\n([^\n])'
						,E'\n' || REPEAT(E'\t', _indents) || '\1'
						,'g'
					);

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_wrap(
	_tag text
	,_text text

	,_classes_lst text[]
	,_attributes_lst text[]

	,_encode boolean
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_wrap(
	_tag text
	,_text text DEFAULT NULL

	,_classes_lst text[] DEFAULT NULL -- One dimension: ARRAY['classA','classB']
	,_attributes_lst text[] DEFAULT NULL -- Two dimensions: ARRAY[ARRAY['attributeA','valueA'], ARRAY['attributeB','valueB']]

	,_encode boolean DEFAULT TRUE

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_classes_tag text;
	_attributes_tag text;

BEGIN

	_tag := NULLIF(TRIM(_tag), '');
	_text := NULLIF(TRIM(_text), '');

	IF _tag IS NULL THEN

		RETURN;

	END IF;



	-- Classes
	WITH

		cte1 AS(
			SELECT DISTINCT ON(n._class)
				u._order
				,sandbox.kontrol_xml_encode(n._class) AS _class
			FROM UNNEST(
					_classes_lst
				) WITH ORDINALITY u(_class, _order)
				,NULLIF(TRIM(u._class), '') n(_class)
			WHERE n._class IS NOT NULL
			ORDER BY n._class
				,u._order
		)

	SELECT
		' class="'
			|| string_agg(
					c._class
					,' '
					ORDER BY c._order
				)
			|| '"'
	FROM cte1 c
	INTO _classes_tag;



	-- Attributes
	WITH

		cte1 AS(
			SELECT DISTINCT ON(attribute_name)
				g
				,attribute_name
				,attribute_value
			FROM generate_series(1, array_length(_attributes_lst, 1)) g
				,sandbox.kontrol_xml_encode(NULLIF(TRIM(_attributes_lst[g][1]), '')) AS attribute_name
				,sandbox.kontrol_xml_encode(NULLIF(TRIM(_attributes_lst[g][2]), '')) AS attribute_value
			WHERE attribute_name IS NOT NULL
				AND attribute_value IS NOT NULL
			ORDER BY attribute_name
				,g
		)

	SELECT
		string_agg(
			FORMAT(
				$$ %1$s="%2$s"$$
				,c.attribute_name
				,c.attribute_value
			)
			,''
			ORDER BY c.g
		)
	FROM cte1 c
	INTO _attributes_tag;



	IF _text IS NULL THEN

		_html := FORMAT(
					'<%1$s%2$s%3$s/>'
					,_tag

					,_classes_tag
					,_attributes_tag
				);

	ELSE

		_html := FORMAT(
					'<%1$s%4$s%5$s>%2$s%3$s%2$s</%1$s>'
					,_tag

					,CASE
						WHEN (
								_text ~* '^<.+>'
								AND _text ~* '</.+>$'
							)
							OR _text ~* '^<.+/>$'
						THEN E'\n'
					END

					,CASE
						WHEN (
								_text ~* '^<.+>'
								AND _text ~* '</.+>$'
							)
							OR _text ~* '^<.+/>$'
						THEN sandbox.kontrol_html_indent(_text)
						ELSE CASE
								WHEN _encode IS TRUE
								THEN sandbox.kontrol_html_encode(_text)
								ELSE _text
							END
					END

					,_classes_tag
					,_attributes_tag
				);

	END IF;

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_wrap(
	_tag text
	,_text_lst text[]

	,_classes_lst text[]
	,_attributes_lst text[]
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_wrap(
	_tag text
	,_text_lst text[]

	,_classes_lst text[] DEFAULT NULL -- One dimension: ARRAY['classA','classB']
	,_attributes_lst text[] DEFAULT NULL -- Two dimensions: ARRAY[ARRAY['attributeA','valueA'], ARRAY['attributeB','valueB']]

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	SELECT
		string_agg(
			sandbox.kontrol_html_wrap(
				_tag := _tag
				,_text := u._text

				,_classes_lst := _classes_lst
				,_attributes_lst := _attributes_lst
			)
			,E'\n'
		)
	FROM UNNEST(_text_lst) WITH ORDINALITY u(_text, _order)
	INTO _html;

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_fejl_lst_clean(
	_fejl_lst text[]
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_fejl_lst_clean(
	_fejl_lst text[]

	,OUT _fejl_lst_clean integer[]
)
	RETURNS INTEGER[]
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	_fejl_lst_clean := ('{' 
					|| regexp_replace(
							_fejl_lst::text
							,'[\{"\}]'
							,''
							,'g'
						)
					|| '}')::integer[];

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_error_tegn(
	_fejl_lst integer[]
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_error_tegn(
	_fejl_lst integer[]

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_fejl_0 integer;
	_fejl_obs integer;
	_fejl_1 integer;

	_fejl_tegn text;
	_css_class text;

	_fejl_tegn_approved text := '&#10003;';
	_fejl_tegn_obs text := '&#33;';
	_fejl_tegn_error text := '&#10007;';

	_fejl_class_approved text := 'approved';
	_fejl_class_obs text := 'obs';
	_fejl_class_error text := 'error';

BEGIN

	IF NULLIF(_fejl_lst, '{}'::int[]) IS NOT NULL THEN

		SELECT
			COUNT(
				CASE
					WHEN u.fejl = 0
					THEN 1
				END
			) AS fejl_0
			,COUNT(
				CASE
					WHEN u.fejl = -1
					THEN 1
				END
			) AS fejl_obs
			,COUNT(
				CASE
					WHEN u.fejl > 0
					THEN 1
				END
			) AS fejl_1
		FROM UNNEST(_fejl_lst) u(fejl)
		WHERE u.fejl IS NOT NULL
		INTO _fejl_0
			,_fejl_obs
			,_fejl_1;



		IF _fejl_1 > 0 THEN

			_fejl_tegn := _fejl_tegn_error;
			_css_class := _fejl_class_error;

		ELSIF _fejl_obs > 0 THEN

			_fejl_tegn := _fejl_tegn_obs;
			_css_class := _fejl_class_obs;

		ELSIF _fejl_0 > 0 THEN

			_fejl_tegn := _fejl_tegn_approved;
			_css_class := _fejl_class_approved;

		ELSE

			RETURN;

		END IF;

		_html := FORMAT(
					$$<span class="%s">%s</span>$$
					,_css_class
					,_fejl_tegn
				);

	END IF;

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_tooltip(
	_html text
	,_tooltip_tegn text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_tooltip(
	INOUT _html text
	,_tooltip_tegn text DEFAULT NULL
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	IF NULLIF(TRIM(_html), '') IS NOT NULL THEN

		_html := FORMAT(
$$<div class="tabletooltip">
	%1$s
	<span class="tooltiptext">
%2$s
	</span>
</div>$$
					,COALESCE(
						sandbox.kontrol_html_encode(_tooltip_tegn)
						,'?'
					)
					,sandbox.kontrol_html_indent(
						_html
						,2
					)
				);

	ELSE

		_html := NULL;

	END IF;

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_section_header(
	_header_text text
	,_header_level integer
	,_fejl_lst integer[]
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_section_header(
	_header_text text
	,_header_level integer DEFAULT NULL
	,_fejl_lst integer[] DEFAULT NULL

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	_html := FORMAT(
				$$<H%1$s style="color:rgb(0,0,0)" class="text-left section_header">%2$s</H%1$s>$$
				,GREATEST(
					LEAST(
						COALESCE(
							_header_level
							,3
						)
						,6
					)
					,1
				)
				,COALESCE(sandbox.kontrol_html_error_tegn(_fejl_lst) || ' ', '') || sandbox.kontrol_html_encode(_header_text)
			);

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_subsection_header(
	_header_text text
	,_header_level integer
	,_id text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_subsection_header(
	_header_text text
	,_header_level integer DEFAULT NULL
	,_id text DEFAULT NULL

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	_html := FORMAT(
$$<div class="container">
	<H%1$s style="color:rgb(0,0,0)" class="text-left"%3$s>%2$s</H%1$s>
</div>$$
				,GREATEST(
					LEAST(
						COALESCE(
							_header_level
							,5
						)
						,6
					)
					,1
				)
				,sandbox.kontrol_html_encode(_header_text)
				,' id="' || sandbox.kontrol_html_encode(_id) || '"'
			);

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_layouter_grid(
	_html_lst text[]
	,_columns integer
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_layouter_grid(
	_html_lst text[]
	,_columns integer DEFAULT NULL

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_md_class_base integer := 12;

BEGIN

	IF NULLIF(_html_lst, '{}') IS NOT NULL THEN

		_columns := COALESCE(_columns, LEAST(array_length(_html_lst, 1), 3));

		WITH

			cte1 AS(
				SELECT
					_row
					,string_agg(
						FORMAT(
$$<div class="col-md-%2$s" style="padding:10px;border: 1px none black">
%1$s
</div>$$
							,sandbox.kontrol_html_indent(
								COALESCE(
									_html_lst[g.cell]
									,'<div></div>'
								)
							)
							,FLOOR(_md_class_base / _columns)
						)
						,E'\n'
						ORDER BY g.cell
					) AS _cell
				FROM array_length(_html_lst, 1) html_count
					,generate_series(
							1
							-- Inputs + fyld
							,html_count + (_columns - html_count % _columns) * (html_count % _columns > 0)::int
						) g(cell)
					,COALESCE(g.cell + (_columns - g.cell % _columns) * (g.cell % _columns > 0)::int) _row
				GROUP BY _row
			)

		SELECT
			FORMAT(
$$<div class="container">
%s
</div>$$
				,sandbox.kontrol_html_indent(
					string_agg(
						FORMAT(
$$<div class="row">
%s
</div>$$
							,sandbox.kontrol_html_indent(
								c._cell
							)
						)
						,E'\n'
						ORDER BY c._row
					)
				)
			)
		FROM cte1 c
		INTO _html;

	END IF;

	RETURN;

END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_html_layouter_vertical(
	_html_lst text[]
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_html_layouter_vertical(
	_html_lst text[]

	,OUT _html text
)
	RETURNS TEXT
	IMMUTABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	SELECT
		string_agg(
			FORMAT(
$$<div style="padding:10px;border: 1px none black">
%s
</div>$$
				,sandbox.kontrol_html_indent(
					u._html
				)
			)
			,E'\n'
			ORDER BY u._order
		)
	FROM UNNEST(
			_html_lst
		) WITH ORDINALITY u(_html, _order)
	WHERE u._html IS NOT NULL
	INTO _html;

	RETURN;

END $BODY$;