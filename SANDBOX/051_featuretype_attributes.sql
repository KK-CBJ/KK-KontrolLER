/* DROP FUNCTION IF EXISTS sandbox.kontrol_featuretype_attributes(
	_featuretype_fid integer
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_featuretype_attributes(
	_featuretype_fid integer
)
	RETURNS TABLE(
		attr_fid integer
		,attr text
		,attr_pretty text
		,attr_order integer

		,attr_lst text[]

		,pakke_fid integer
		,pakke text
		,pakke_pretty text
		,pakke_order integer

		,data_type text
		,data_type_pretty text
		,nillable boolean
		,default_value text
		,restriktion_sql text
		,restriktion_beskrivelse text

		,kontrol_skema text
		,kontrol_navn text
		,kontrol_valid_idx integer
		,kontrol_output_idx integer

		,opslagstabel text
		,opslagstabel_skema text
		,opslagstabel_navn text
		,opslagstabel_kolonne text
		,opslagstabel_kolonne_sql_tooltip text
		,opslagstabel_filter text

		,kontrol_type text
		,kontrol_type_pretty text
		,fejl integer
		,fejl_pretty text
		,fejl_type text

		,enhed text

		,tooltip_html text
	)
	STABLE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	RETURN QUERY
	WITH

		cte1 AS(
			SELECT DISTINCT ON(attr.navn)

				attr.fid AS attr_fid
				,attr.navn AS attr
				,attr.navn_pretty AS attr_pretty
				,attr._order AS attr_order


				-- ,ARRAY[attr.navn] || attr.navn_lst AS attr_lst
				,CASE
					WHEN array_position(
							attr.navn_lst
							,attr.navn
						) IS NULL
					THEN ARRAY[attr.navn] || attr.navn_lst
					ELSE attr.navn_lst
				END AS attr_lst

				,p.fid AS pakke_fid
				,p.navn AS pakke
				,p.navn_pretty AS pakke_pretty
				,p._order AS pakke_order

				,attr.data_type
				,dt.navn_pretty AS data_type_pretty
				,attr.nillable
				,attr.default_value
				,NULLIF(TRIM(attr.restriktion_sql), '') AS restriktion_sql
				,attr.restriktion_beskrivelse

				,dt.kontrol_skema
				,dt.kontrol_navn
				,dt.kontrol_valid_idx
				,dt.kontrol_output_idx

				,opsl.navn AS opslagstabel
				,opsl.tabel_skema AS opslagstabel_skema
				,opsl.tabel_navn AS opslagstabel_navn
				,opsl.tabel_kolonne AS opslagstabel_kolonne
				,opsl.tabel_kolonne_sql_tooltip AS opslagstabel_kolonne_sql_tooltip
				,CASE
					WHEN opsl.fid IS NOT NULL
						AND NULLIF(TRIM(attr.opslagstabel_filter), '') IS NOT NULL
					THEN COALESCE('(' || NULLIF(TRIM(opsl.tabel_filter), '') || ') AND ', '')
							|| attr.opslagstabel_filter
					ELSE opsl.tabel_filter
				END AS opslagstabel_filter

				,kt.navn AS kontrol_type
				,kt.navn_pretty AS kontrol_type_pretty
				,err.navn AS fejl
				,err.navn_pretty AS fejl_pretty
				,err.fejl_type

				,attr.enhed

				,attr.tooltip_html
			FROM sandbox.kontrol_lst_featuretyper ft

			INNER JOIN UNNEST(ft.pakker_lst) u(pakke) ON TRUE
			INNER JOIN sandbox.kontrol_lst_pakker p ON p.navn = u.pakke
				AND p.aktiv IS TRUE

			INNER JOIN sandbox.kontrol_lst_attributter attr ON attr.pakke = u.pakke
				AND (
					ft.forsyningsart = ANY(attr.forsyningsart_incl_lst)
					OR NULLIF(attr.forsyningsart_incl_lst, '{}') IS NULL
				)
				AND (
					ft.forsyningsart != ALL(attr.forsyningsart_excl_lst)
					OR NULLIF(attr.forsyningsart_excl_lst, '{}') IS NULL
				)
				AND attr.aktiv IS TRUE

			INNER JOIN sandbox.kontrol_lst_data_typer dt ON dt.navn = attr.data_type
				AND dt.aktiv IS TRUE
			LEFT JOIN sandbox.kontrol_lst_opslagstabeller opsl ON opsl.navn = attr.opslagstabel
				AND opsl.aktiv IS TRUE
			LEFT JOIN sandbox.kontrol_lst_kontrol_typer kt ON kt.navn = attr.kontrol_type
				AND kt.aktiv IS TRUE
			LEFT JOIN sandbox.kontrol_lst_fejl err ON err.navn = attr.fejl
				AND err.aktiv IS TRUE
			WHERE ft.fid = _featuretype_fid
			ORDER BY attr.navn
				,p._order DESC
				,CASE
					WHEN ft.forsyningsart = ANY(attr.forsyningsart_incl_lst)
					THEN 1
				END
				,attr._order DESC
		)

	SELECT
		c.attr_fid
		,c.attr
		,c.attr_pretty
		,ROW_NUMBER() OVER(ORDER BY c.pakke_order, c.attr_order, c.attr)::integer AS attr_order

		,c.attr_lst

		,c.pakke_fid
		,c.pakke
		,c.pakke_pretty
		,c.pakke_order

		,c.data_type
		,c.data_type_pretty
		,c.nillable
		,c.default_value
		,c.restriktion_sql
		,c.restriktion_beskrivelse

		,c.kontrol_skema
		,c.kontrol_navn
		,c.kontrol_valid_idx
		,c.kontrol_output_idx

		,c.opslagstabel
		,c.opslagstabel_skema
		,c.opslagstabel_navn
		,c.opslagstabel_kolonne
		,c.opslagstabel_kolonne_sql_tooltip
		,c.opslagstabel_filter

		,c.kontrol_type
		,c.kontrol_type_pretty
		,c.fejl
		,c.fejl_pretty
		,c.fejl_type

		,c.enhed

		,c.tooltip_html
	FROM cte1 c
	ORDER BY attr_order;

END $BODY$;