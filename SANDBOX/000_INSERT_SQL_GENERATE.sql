/*

WITH

	cte1 AS(
		SELECT
			DENSE_RANK() OVER(ORDER BY array_position(
											ARRAY[
												'kontrol_fme_attributter_exclude'
												,'kontrol_fme_filtyper'
												,'kontrol_lst_ja_nej'
												,'kontrol_lst_fejl'
												,'kontrol_lst_srid'
												,'kontrol_lst_dimensioner'
												,'kontrol_lst_snap'
												,'kontrol_lst_systemer'
												,'kontrol_lst_forsyningsarter'
												,'kontrol_lst_grupper'
												,'kontrol_lst_geometrityper'
												,'kontrol_lst_eksisterende'
												,'kontrol_lst_featuretyper'
												,'kontrol_lst_featuretype_grupper'
												,'kontrol_lst_pakker'
												,'kontrol_lst_data_typer'
												,'kontrol_lst_kontrol_typer'
												,'kontrol_lst_opslagstabeller'
												,'kontrol_lst_attributter_geometri'
												,'kontrol_lst_attributter'
											]
											,c.relname
										)
										,n.nspname
										,c.relname
							) AS _row
			,n.nspname
			,c.relname
			,a.attnum
			,a.attname
			,format_type(a.atttypid, a.atttypmod) AS atttype

			,co.att_order_col
		FROM pg_class c
		INNER JOIN pg_namespace n ON c.relnamespace = n.oid
		INNER JOIN pg_attribute a ON a.attrelid = c.oid
		LEFT JOIN LATERAL(
				SELECT
					string_agg(
						QUOTE_IDENT(a_sub.attname)
						,','
					) AS att_order_col
				FROM pg_attribute a_sub
				INNER JOIN pg_constraint co ON co.conrelid = c.oid
					AND co.contype = 'p'
					AND a_sub.attnum = ANY(co.conkey)
				WHERE a_sub.attrelid = c.oid
			) co ON TRUE
		WHERE a.attnum > 0
			AND NOT(a.attisdropped)
			AND c.relkind = 'r'
			AND pg_get_serial_sequence(
					FORMAT('%I.%I', n.nspname, c.relname)
					,a.attname
				) IS NULL

			AND n.nspname = 'ler'
			AND c.relname ~* '^kontrol_'
			AND c.relname != 'kontrol_xml'
			AND c.relname != 'kontrol_lst_skabeloner'
			-- AND c.relname IN(
				-- 'kontrol_fme_attributter_exclude'
				-- ,'kontrol_fme_filtyper'
				-- ,'kontrol_lst_attributter'
			-- )
	)

	,cte2 AS(
		SELECT
			c._row
			,c.nspname
			,c.relname
			,FORMAT(
$$		SELECT
			%s AS fid

			,%L AS table_schema
			,%L AS table_name
			,ROW_NUMBER() OVER(ORDER BY %s)::int AS table_row

			,ARRAY[
				%s
			] AS att_array
		FROM %2$I.%3$I$$

				,c._row
				,c.nspname
				,c.relname
				,c.att_order_col
				,string_agg(
					FORMAT(
						'ARRAY[%L, %1$I::text, %s, %L]'
						,c.attname
						,CASE
							WHEN c.atttype IN(
									'integer'
									,'boolean'
									,'text'
								)
							THEN 'NULL'
							ELSE QUOTE_LITERAL(c.atttype)
						END
						,CASE
							WHEN c.atttype IN(
									'integer'
									,'boolean'
								)
							THEN 's'
							ELSE 'L'
						END
					)
					,E'\n\t\t\t\t,'
					ORDER BY c.attnum
				)
			) fmt_
		FROM cte1 c
		GROUP BY c._row
			,c.nspname
			,c.relname
			,c.att_order_col
	)

SELECT
	string_agg(
		fmt_
		,E'\n\n\t\tUNION ALL\n\n'
		-- ORDER BY c.nspname, c.relname
		ORDER BY c._row
	)
	,COUNT(*)
FROM cte2 c


-- */





WITH

	__data__ AS(
		SELECT
			1 AS fid

			,'ler' AS table_schema
			,'kontrol_fme_attributter_exclude' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_fme_attributter_exclude

		UNION ALL

		SELECT
			2 AS fid

			,'ler' AS table_schema
			,'kontrol_fme_filtyper' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['navn_lst', navn_lst::text, 'text[]', 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_fme_filtyper

		UNION ALL

		SELECT
			3 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_ja_nej' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['fid', fid::text, NULL, 's']
				,ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_ja_nej

		UNION ALL

		SELECT
			4 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_fejl' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['fid', fid::text, NULL, 's']
				,ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 's']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['fejl_type', fejl_type::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_fejl

		UNION ALL

		SELECT
			5 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_srid' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 's']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['navn_lst', navn_lst::text, 'integer[]', 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_srid

		UNION ALL

		SELECT
			6 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_dimensioner' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['zm_flag', zm_flag::text, NULL, 's']
			] AS att_array
		FROM ler.kontrol_lst_dimensioner

		UNION ALL

		SELECT
			7 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_snap' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['_order', _order::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['color_hex', color_hex::text, NULL, 'L']
				,ARRAY['fejl', fejl::text, NULL, 's']
			] AS att_array
		FROM ler.kontrol_lst_snap

		UNION ALL

		SELECT
			8 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_systemer' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['_order', _order::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['navn_lst', navn_lst::text, 'text[]', 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_systemer

		UNION ALL

		SELECT
			9 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_forsyningsarter' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['_order', _order::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['navn_lst', navn_lst::text, 'text[]', 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['color_hex', color_hex::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_forsyningsarter

		UNION ALL

		SELECT
			10 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_grupper' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['_order', _order::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['navn_lst', navn_lst::text, 'text[]', 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_grupper

		UNION ALL

		SELECT
			11 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_geometrityper' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['_order', _order::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['navn_lst', navn_lst::text, 'text[]', 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['pg_geometritype', pg_geometritype::text, NULL, 'L']
				,ARRAY['navn_short', navn_short::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_geometrityper

		UNION ALL

		SELECT
			12 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_eksisterende' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['system', system::text, NULL, 'L']
				,ARRAY['forsyningsart', forsyningsart::text, NULL, 'L']
				,ARRAY['gruppe', gruppe::text, NULL, 'L']
				,ARRAY['geometritype', geometritype::text, NULL, 'L']
				,ARRAY['tabel_skema', tabel_skema::text, NULL, 'L']
				,ARRAY['tabel_navn', tabel_navn::text, NULL, 'L']
				,ARRAY['tabel_geom', tabel_geom::text, NULL, 'L']
				,ARRAY['tabel_filter', tabel_filter::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_eksisterende

		UNION ALL

		SELECT
			13 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_featuretyper' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['_order', _order::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['navn_lst', navn_lst::text, 'text[]', 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['system', system::text, NULL, 'L']
				,ARRAY['forsyningsart', forsyningsart::text, NULL, 'L']
				,ARRAY['gruppe', gruppe::text, NULL, 'L']
				,ARRAY['geometrityper_lst', geometrityper_lst::text, 'text[]', 'L']
				,ARRAY['dimension', dimension::text, NULL, 'L']
				,ARRAY['group_column', group_column::text, NULL, 'L']
				,ARRAY['etablering_column', etablering_column::text, NULL, 'L']
				,ARRAY['etablering_skaering', etablering_skaering::text, 'date', 'L']
				,ARRAY['snap_kontrol', snap_kontrol::text, NULL, 's']
				,ARRAY['snap_kontrol_geometrityper_lst', snap_kontrol_geometrityper_lst::text, 'text[]', 'L']
				,ARRAY['snap_reference', snap_reference::text, NULL, 's']
				,ARRAY['snap_reference_geometrityper_lst', snap_reference_geometrityper_lst::text, 'text[]', 'L']
				,ARRAY['pakker_lst', pakker_lst::text, 'text[]', 'L']
			] AS att_array
		FROM ler.kontrol_lst_featuretyper

		UNION ALL

		SELECT
			14 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_featuretype_grupper' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['_order', _order::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['navn_lst', navn_lst::text, 'text[]', 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['system', system::text, NULL, 'L']
				,ARRAY['forsyningsart', forsyningsart::text, NULL, 'L']
				,ARRAY['gruppe', gruppe::text, NULL, 'L']
				,ARRAY['geometritype', geometritype::text, NULL, 'L']
				,ARRAY['color_hex', color_hex::text, NULL, 'L']
				,ARRAY['js_style', js_style::text, NULL, 'L']
				,ARRAY['js_svg_legend', js_svg_legend::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_featuretype_grupper

		UNION ALL

		SELECT
			15 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_pakker' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['_order', _order::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_pakker

		UNION ALL

		SELECT
			16 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_data_typer' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['kontrol_skema', kontrol_skema::text, NULL, 'L']
				,ARRAY['kontrol_navn', kontrol_navn::text, NULL, 'L']
				,ARRAY['kontrol_valid_idx', kontrol_valid_idx::text, NULL, 's']
				,ARRAY['kontrol_output_idx', kontrol_output_idx::text, NULL, 's']
			] AS att_array
		FROM ler.kontrol_lst_data_typer

		UNION ALL

		SELECT
			17 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_kontrol_typer' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_kontrol_typer

		UNION ALL

		SELECT
			18 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_opslagstabeller' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['tabel_skema', tabel_skema::text, NULL, 'L']
				,ARRAY['tabel_navn', tabel_navn::text, NULL, 'L']
				,ARRAY['tabel_kolonne', tabel_kolonne::text, NULL, 'L']
				,ARRAY['tabel_filter', tabel_filter::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_opslagstabeller

		UNION ALL

		SELECT
			19 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_attributter_geometri' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['_order', _order::text, NULL, 's']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['pakke', pakke::text, NULL, 'L']
				,ARRAY['tooltip_html', tooltip_html::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_attributter_geometri

		UNION ALL

		SELECT
			20 AS fid

			,'ler' AS table_schema
			,'kontrol_lst_attributter' AS table_name
			,ROW_NUMBER() OVER(ORDER BY fid)::int AS table_row

			,ARRAY[
				ARRAY['aktiv', aktiv::text, NULL, 's']
				,ARRAY['_order', _order::text, NULL, 's']
				,ARRAY['forsyningsart_incl_lst', forsyningsart_incl_lst::text, 'text[]', 'L']
				,ARRAY['forsyningsart_excl_lst', forsyningsart_excl_lst::text, 'text[]', 'L']
				,ARRAY['pakke', pakke::text, NULL, 'L']
				,ARRAY['navn_pretty', navn_pretty::text, NULL, 'L']
				,ARRAY['navn', navn::text, NULL, 'L']
				,ARRAY['navn_lst', navn_lst::text, 'text[]', 'L']
				,ARRAY['beskrivelse', beskrivelse::text, NULL, 'L']
				,ARRAY['data_type', data_type::text, NULL, 'L']
				,ARRAY['nillable', nillable::text, NULL, 's']
				,ARRAY['default_value', default_value::text, NULL, 'L']
				,ARRAY['opslagstabel', opslagstabel::text, NULL, 'L']
				,ARRAY['opslagstabel_filter', opslagstabel_filter::text, NULL, 'L']
				,ARRAY['kontrol_type', kontrol_type::text, NULL, 'L']
				,ARRAY['fejl', fejl::text, NULL, 's']
				,ARRAY['enhed', enhed::text, NULL, 'L']
				,ARRAY['restriktion_beskrivelse', restriktion_beskrivelse::text, NULL, 'L']
				,ARRAY['restriktion_sql', restriktion_sql::text, NULL, 'L']
				,ARRAY['tooltip_html', tooltip_html::text, NULL, 'L']
			] AS att_array
		FROM ler.kontrol_lst_attributter
)



	,tabs AS(
		SELECT
			4 AS tab_width
	)

	,cte1 AS(
		SELECT DISTINCT
			d.fid

			,d.table_schema
			,d.table_name
			,0 AS table_row

			,'header' AS header_value
			,g AS header_value_order
			,header_value_count

			,QUOTE_IDENT(d.att_array[g][1]) AS att_header_value

		FROM __data__ d
			,array_length(att_array, 1) header_value_count
			,generate_series(1, header_value_count) g

		UNION ALL

		SELECT
			d.fid

			,d.table_schema
			,d.table_name
			,d.table_row

			,'value' AS header_value
			,g AS header_value_order
			,header_value_count

			,CASE
				WHEN d.att_array[g][4] = 'L'
					AND d.att_array[g][2] ~* E'\n|\t'
				THEN 'E'
				ELSE ''
			END
				|| CASE
					WHEN d.att_array[g][4] = 'L'
						AND d.att_array[g][2] ~* E'\n|\t'
					THEN REPLACE(
							REPLACE(
								REPLACE(
									f
									,E'\\'
									,E'\\\\'
								)
								,E'\n'
								,'\n'
							)
							,E'\t'
							,'\t'
						)
					ELSE f
				END AS att_header_value

		FROM __data__ d
			,array_length(att_array, 1) header_value_count
			,generate_series(1, header_value_count) g
			,COALESCE(
				FORMAT(
					'%' || d.att_array[g][4]
					-- ,d.att_array[g][2]
					,CASE
						WHEN d.att_array[g][4] = 's'
						THEN COALESCE(d.att_array[g][2], 'NULL')
						ELSE d.att_array[g][2]
					END
				)
				|| COALESCE('::' || d.att_array[g][3], '')
			) f


		ORDER BY fid
			,header_value
			,table_row
			,header_value_order
	)

	,cte2 AS(
		SELECT
			c.fid

			,c.table_schema
			,c.table_name
			,c.table_row

			,c.header_value
			,c.header_value_order
			,c.header_value_count

			,c.att_header_value

			,LENGTH(c.att_header_value) + 1 + 1 * (c.header_value_order = 1)::int AS lgd

		FROM cte1 c
	)

	,cte3 AS(
		SELECT
			c.fid

			,c.table_schema
			,c.table_name
			,c.table_row

			,c.header_value
			,c.header_value_order
			,c.header_value_count

			,c.att_header_value

			,t.tab_width
			,LENGTH(c.att_header_value) + 1 + 1 * (c.header_value_order = 1)::int AS lgd
			,MAX(c.lgd) OVER(PARTITION BY c.fid, c.header_value_order) + t.tab_width - MAX(c.lgd) OVER(PARTITION BY c.fid, c.header_value_order) % t.tab_width AS lgd_pr_col

		FROM cte2 c
			,tabs t
		ORDER BY c.fid
			,c.header_value
			,c.table_row
			,c.header_value_order
	)

	,cte4 AS(
		SELECT
			c.fid

			,c.table_schema
			,c.table_name
			,c.table_row

			,c.header_value
			,c.header_value_order

			,c.att_header_value
				|| REPEAT(
						E'\t'
						,CEILING(
							(c.lgd_pr_col - c.lgd)::float / c.tab_width
						)::int * (c.header_value_order < c.header_value_count)::int
					) AS att_header_value

		FROM cte3 c
		ORDER BY c.fid
			,c.header_value
			,c.table_row
			,c.header_value_order
	)

	,cte5 AS(
		SELECT
			c.fid

			,c.table_schema
			,c.table_name
			,c.table_row

			,c.header_value

			,FORMAT(
				CASE
					WHEN c.header_value = 'header'
					THEN ' %s'
					ELSE '(%s)'
				END

				,string_agg(
					c.att_header_value
					,','
					ORDER BY c.header_value_order
				)
			) AS att_header_value

		FROM cte4 c
		GROUP BY c.fid

			,c.table_schema
			,c.table_name
			,c.table_row

			,c.header_value
		ORDER BY c.fid
			,c.header_value
			,c.table_row
	)

	,cte6 AS(
		SELECT
			c.fid

			,c.table_schema
			,c.table_name

			,array_agg(
				c.att_header_value
				ORDER BY c.table_row
			) AS att_header_value

		FROM cte5 c
		GROUP BY c.fid

			,c.table_schema
			,c.table_name
		ORDER BY c.fid
	)

SELECT
	string_agg(
		FORMAT(
$$-- TRUNCATE %I.%I;
INSERT INTO %1$I.%I(
	 %s
) VALUES
	 %s
;$$

			,'sandbox'
			-- ,c.table_schema
			,c.table_name

			,att_header_value[1]
			,array_to_string(
				att_header_value[2:]
				,E'\n\t,'
			)
		)
		,E'\n\n\n\n\n'
		ORDER BY c.fid
	)
FROM cte6 c


