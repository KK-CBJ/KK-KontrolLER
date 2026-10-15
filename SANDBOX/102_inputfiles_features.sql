/* DROP FUNCTION IF EXISTS sandbox.kontrol_inputfiles_features(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_inputfiles_features(
	_kontrol_guid uuid
)
	RETURNS VOID
	-- RETURNS TABLE(
		-- inputfile_fid integer
		-- ,inputfile_id text
		-- ,inputfile text
		-- ,inputfile_pretty text
		-- ,inputfile_order integer


		-- ,featuretype_fid integer
		-- ,featuretype text
		-- ,featuretype_pretty text
		-- ,featuretype_order integer


		-- ,system_fid integer
		-- ,system text
		-- ,system_pretty text
		-- ,system_order integer

		-- ,forsyningsart_fid integer
		-- ,forsyningsart text
		-- ,forsyningsart_pretty text
		-- ,forsyningsart_order integer

		-- ,gruppe_fid integer
		-- ,gruppe text
		-- ,gruppe_pretty text
		-- ,gruppe_order integer

		-- ,geometritype_fid integer
		-- ,geometritype text
		-- ,geometritype_pretty text
		-- ,geometritype_short text
		-- ,geometritype_order integer
		-- ,pg_geometritype text


		-- ,dimension text
		-- ,dimension_pretty text
		-- ,dimension_zm_flag integer

		-- ,snap_kontrol boolean
		-- ,snap_reference boolean

		-- ,forsyningsart_color_hex text

		-- ,feature_fid integer
		-- ,feature_group text
		-- ,feature_etablering date
		-- ,feature_etablering_foer_skaering boolean
		-- ,feature_eksisterende integer

		-- ,geom geometry(GEOMETRY, 25832)
		-- ,attributes_xml xml
		-- ,geom_xml xml

		-- ,geom_geometritype_fid integer
		-- ,geom_geometritype text
		-- ,geom_geometritype_pretty text
		-- ,geom_geometritype_short text
		-- ,geom_geometritype_order integer
		-- ,geom_pg_geometritype text
	-- )
	-- STABLE
	VOLATILE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	DELETE FROM sandbox.kontrol_inputfiles_features k
		WHERE k.kontrol_guid = _kontrol_guid;


	-- RETURN QUERY
	WITH

		inputfiles AS(
			SELECT
				f.inputfile_fid
				,f.inputfile_id
				,f.inputfile
				,f.inputfile_pretty
				,f.inputfile_order

				,f.inputfile_feature_srid


				,f.featuretype_fid
				,f.featuretype
				,f.featuretype_pretty
				,f.featuretype_order


				,f.system_fid
				,f.system
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe
				,f.gruppe_pretty
				,f.gruppe_order

				,f.geometritype_fid
				,f.geometritype
				,f.geometritype_pretty
				,f.geometritype_short
				,f.geometritype_order
				,f.pg_geometritype


				,f.dimension
				,f.dimension_pretty
				,f.dimension_zm_flag

				,f.group_column

				,f.etablering_column
				,f.etablering_skaering

				,f.snap_kontrol
				,f.snap_reference

				,f.forsyningsart_color_hex

				,f.inputfile_xml
			-- FROM sandbox.kontrol_inputfiles(
					-- _kontrol_guid := _kontrol_guid
			-- ) f
			FROM sandbox.kontrol_inputfiles f
			WHERE f.kontrol_guid = _kontrol_guid
				AND f.fejl = 0
		)





		,features_1 AS(
			SELECT
				i.inputfile_fid
				,i.inputfile_id
				,i.inputfile
				,i.inputfile_pretty
				,i.inputfile_order


				,COALESCE(ft.featuretype_fid, i.featuretype_fid) AS featuretype_fid
				,COALESCE(ft.featuretype, i.featuretype) AS featuretype
				,COALESCE(ft.featuretype_pretty, i.featuretype_pretty) AS featuretype_pretty
				,COALESCE(ft.featuretype_order, i.featuretype_order) AS featuretype_order


				,i.system_fid
				,i.system
				,i.system_pretty
				,i.system_order

				,i.forsyningsart_fid
				,i.forsyningsart
				,i.forsyningsart_pretty
				,i.forsyningsart_order

				,i.gruppe_fid
				,i.gruppe
				,i.gruppe_pretty
				,i.gruppe_order

				,i.geometritype_fid
				,i.geometritype
				,i.geometritype_pretty
				,i.geometritype_short
				,i.geometritype_order
				,i.pg_geometritype


				,COALESCE(ft.dimension, i.dimension) AS dimension
				,COALESCE(ft.dimension_pretty, i.dimension_pretty) AS dimension_pretty
				,COALESCE(ft.dimension_zm_flag, i.dimension_zm_flag) AS dimension_zm_flag


				,COALESCE(ft.snap_kontrol, i.snap_kontrol) AS snap_kontrol
				,COALESCE(ft.snap_reference, i.snap_reference) AS snap_reference

				,i.forsyningsart_color_hex

				,f.feature_fid



				,i.inputfile_feature_srid

				,COALESCE(ft.group_column, i.group_column) AS group_column

				,COALESCE(ft.etablering_column, i.etablering_column) AS etablering_column
				,COALESCE(ft.etablering_skaering, i.etablering_skaering) AS etablering_skaering
				,f.geom_wkt
				,u.feature_xml
			FROM inputfiles i
			INNER JOIN UNNEST(xpath('/inputFile/features/feature', i.inputfile_xml)) u(feature_xml) ON TRUE
			INNER JOIN xmltable(
					'/*' passing u.feature_xml
						COLUMNS
							feature_fid integer path '@fid'
							,geom_wkt text path '/feature/geometry/text()'
				) f ON TRUE

			-- Find evt. specifik featuretype
			LEFT JOIN LATERAL(
					SELECT
						ft.fid AS featuretype_fid
						,ft.navn_lst[1] AS featuretype
						,ft.navn_pretty AS featuretype_pretty
						,ft._order AS featuretype_order


						,ft.dimension
						,dim.navn_pretty AS dimension_pretty
						,dim.zm_flag AS dimension_zm_flag

						,ft.group_column

						,ft.etablering_column
						,ft.etablering_skaering

						,CASE
							WHEN ft.snap_kontrol IS TRUE
								AND (
									i.geometritype = ANY(ft.snap_kontrol_geometrityper_lst)
									OR NULLIF(ft.snap_kontrol_geometrityper_lst, '{}') IS NULL
								)
							THEN TRUE
							ELSE FALSE
						END AS snap_kontrol
						,CASE
							WHEN ft.snap_reference IS TRUE
								AND (
									i.geometritype = ANY(ft.snap_reference_geometrityper_lst)
									OR NULLIF(ft.snap_reference_geometrityper_lst, '{}') IS NULL
								)
							THEN TRUE
							ELSE FALSE
						END AS snap_reference
					FROM sandbox.kontrol_featuretype_attributes(
							CASE
								WHEN i.featuretype IS NULL
								THEN i.featuretype_fid
							END
						) ft_a
					INNER JOIN UNNEST(ft_a.attr_lst) WITH ORDINALITY lst(attr,_order) ON TRUE
					LEFT JOIN xmltable(
							('/feature/attributes/' || lst.attr) passing u.feature_xml
								COLUMNS
									attr text path 'text()'
						) t ON TRUE
					LEFT JOIN sandbox.kontrol_lst_featuretyper ft ON ft.fid != i.featuretype_fid
						AND ft.forsyningsart = i.forsyningsart
						AND ft.gruppe = i.gruppe
						AND i.geometritype = ANY(ft.geometrityper_lst)
						AND COALESCE(t.attr, ft_a.default_value) = ANY(ft.navn_lst)

					INNER JOIN sandbox.kontrol_lst_dimensioner dim ON dim.navn = ft.dimension
						AND dim.aktiv IS TRUE

					WHERE ft_a.attr = i.group_column
					ORDER BY lst._order
					LIMIT 1
			) ft ON TRUE

			-- OLD
			-- Find evt. specifik featuretype
			/* LEFT JOIN LATERAL(
					SELECT
						ft.fid AS featuretype_fid
						,ft.navn_lst[1] AS featuretype
						,ft.navn_pretty AS featuretype_pretty
						,ft._order AS featuretype_order


						,ft.dimension
						,dim.navn_pretty AS dimension_pretty
						,dim.zm_flag AS dimension_zm_flag

						,ft.group_column

						,ft.etablering_column
						,ft.etablering_skaering

						,CASE
							WHEN ft.snap_kontrol IS TRUE
								AND (
									i.geometritype = ANY(ft.snap_kontrol_geometrityper_lst)
									OR NULLIF(ft.snap_kontrol_geometrityper_lst, '{}') IS NULL
								)
							THEN TRUE
							ELSE FALSE
						END AS snap_kontrol
						,CASE
							WHEN ft.snap_reference IS TRUE
								AND (
									i.geometritype = ANY(ft.snap_reference_geometrityper_lst)
									OR NULLIF(ft.snap_reference_geometrityper_lst, '{}') IS NULL
								)
							THEN TRUE
							ELSE FALSE
						END AS snap_reference
					FROM sandbox.kontrol_featuretype_attributes(
							CASE
								WHEN i.featuretype IS NULL
								THEN i.featuretype_fid
							END
						) ft_a
					INNER JOIN UNNEST(ft_a.attr_lst) WITH ORDINALITY lst(attr,_order) ON TRUE
					INNER JOIN xmltable(
							('/feature/attributes/' || lst.attr) passing u.feature_xml
								COLUMNS
									attr text path 'text()'
						) t ON TRUE
					LEFT JOIN sandbox.kontrol_lst_featuretyper ft ON ft.forsyningsart = i.forsyningsart
						AND ft.gruppe = i.gruppe
						AND i.geometritype = ANY(ft.geometrityper_lst)
						AND t.attr = ANY(ft.navn_lst)

					INNER JOIN sandbox.kontrol_lst_dimensioner dim ON dim.navn = ft.dimension
						AND dim.aktiv IS TRUE

					WHERE ft_a.attr = i.group_column
					ORDER BY lst._order
					LIMIT 1
			) ft ON TRUE */
		)





		,feature_attributes_1 AS(
			SELECT DISTINCT ON(f.inputfile_fid, f.feature_fid, ft_a.attr_fid)
				f.inputfile_fid
				,f.feature_fid


				,ft_a.attr
				,ft_a.attr_order

				,sandbox.kontrol_xml_encode(opsl.kontrol[2][2]) AS _value

				,((dt.kontrol[1][2])::boolean = FALSE)::int AS fejl_data_type
				,((opsl.kontrol[1][2])::boolean = FALSE)::int AS fejl_opslag

			FROM features_1 f
				,sandbox.kontrol_featuretype_attributes(
					_featuretype_fid := f.featuretype_fid
				) ft_a

				,UNNEST(ft_a.attr_lst) WITH ORDINALITY u(attr, _order)
				,UNNEST(
					COALESCE(
						NULLIF(
							xpath(
								'/feature/attributes/' || u.attr || '/text()'
								,f.feature_xml
							)::text[]
							,'{}'
						)
						,ARRAY[NULL::text]
					)
						|| sandbox.kontrol_xml_encode(ft_a.default_value)
				) WITH ORDINALITY attr(_value, _order)
				,NULLIF(TRIM(regexp_replace(attr._value, E'^\n+|\n+$', '', 'g')), '') tr(_value)


				,sandbox.kontrol_data_type(
					_kontrol_skema := ft_a.kontrol_skema
					,_kontrol_navn := ft_a.kontrol_navn
					,_kontrol_valid_idx := ft_a.kontrol_valid_idx
					,_kontrol_output_idx := ft_a.kontrol_output_idx

					,_attr_value := sandbox.kontrol_xml_decode(tr._value)
				) dt(kontrol)

				,sandbox.kontrol_opslag(
					_tabel_skema := ft_a.opslagstabel_skema
					,_tabel_navn := ft_a.opslagstabel_navn
					,_tabel_kolonne := ft_a.opslagstabel_kolonne
					,_tabel_filter := ft_a.opslagstabel_filter

					,_attr_value := dt.kontrol[2][2]
				) opsl(kontrol)


			WHERE tr._value IS NOT NULL
			ORDER BY f.inputfile_fid
				,f.feature_fid
				,ft_a.attr_fid
				,attr._order
				,u._order
		)

		,feature_attributes AS(
			SELECT
				fa.inputfile_fid
				,fa.feature_fid


				,(E'<attributes>\n'
					|| string_agg(
							FORMAT(
								$$	<%1$s%3$s%4$s>%2$s</%1$s>$$
								,fa.attr
								,fa._value

								,' fejl_data_type="' || fa.fejl_data_type || '"'
								,' fejl_opslag="' || fa.fejl_opslag || '"'
							)
							,E'\n'
							ORDER BY fa.attr_order
						)
					|| E'\n</attributes>')::xml AS attributes_xml

			FROM feature_attributes_1 fa
			GROUP BY fa.inputfile_fid
				,fa.feature_fid
		)







		,features AS(
			SELECT
				f.inputfile_fid
				,f.inputfile_id
				,f.inputfile
				,f.inputfile_pretty
				,f.inputfile_order


				,f.featuretype_fid
				,f.featuretype
				,f.featuretype_pretty
				,f.featuretype_order


				,f.system_fid
				,f.system
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe
				,f.gruppe_pretty
				,f.gruppe_order

				,f.geometritype_fid
				,f.geometritype
				,f.geometritype_pretty
				,f.geometritype_short
				,f.geometritype_order
				,f.pg_geometritype


				,f.dimension
				,f.dimension_pretty
				,f.dimension_zm_flag


				,f.snap_kontrol
				,f.snap_reference

				,f.forsyningsart_color_hex

				,f.feature_fid
				,t.feature_group
				,fe.feature_etablering
				,fs.feature_etablering_foer_skaering
				,c.feature_eksisterende

				,m._geom AS geom
				,fa.attributes_xml
				,m._geom_xml AS geom_xml

				,m._geom_geometritype_fid AS geom_geometritype_fid
				,m._geom_geometritype AS geom_geometritype
				,m._geom_geometritype_pretty AS geom_geometritype_pretty
				,m._geom_geometritype_short AS geom_geometritype_short
				,m._geom_geometritype_order AS geom_geometritype_order
				,m._geom_pg_geometritype AS geom_pg_geometritype


			FROM features_1 f
			LEFT JOIN feature_attributes fa ON fa.inputfile_fid = f.inputfile_fid
				AND fa.feature_fid = f.feature_fid
			LEFT JOIN xmltable(
					'/*' passing fa.attributes_xml
						COLUMNS
							feature_group text path COALESCE('/attributes/' || f.group_column || '/text()', '/no/value')
							,feature_etablering text path COALESCE('/attributes/' || f.etablering_column || '/text()', '/no/value')

							,note_intern text path '/attributes/note_intern/text()'
				) t ON TRUE



			INNER JOIN ler20.kontrol_tm_position(t.feature_etablering) tm_position ON TRUE
			INNER JOIN COALESCE(
							CASE
								WHEN LEFT(tm_position[2][2], 6) = 'Before'
								THEN -1
								ELSE 0
							END
							+ to_date(
								SUBSTRING(tm_position[4][2], '[\d-]+$')
								,RIGHT('DD-MM-YYYY', LENGTH(SUBSTRING(tm_position[4][2], '[\d-]+$')))
							)
				) fe(feature_etablering) ON TRUE
			INNER JOIN COALESCE(fe.feature_etablering < f.etablering_skaering, FALSE) fs(feature_etablering_foer_skaering) ON TRUE


			INNER JOIN COALESCE((t.note_intern ~* '^eksisterende$')::integer, 0) c(feature_eksisterende) ON TRUE


			INNER JOIN sandbox.kontrol_geometri_metadata(
				_pg_geometritype := f.pg_geometritype
				,_srid := f.inputfile_feature_srid
				,_zm_flag := f.dimension_zm_flag
				,_foer_skaering := fs.feature_etablering_foer_skaering

				,_geom_wkt := f.geom_wkt
			) m ON TRUE
		)







		,feature_attributes_fejl_1 AS(
			SELECT
				f.inputfile_fid
				,f.feature_fid


				,ft_a.attr
				,ft_a.attr_order

				,sandbox.kontrol_xml_encode(_value) AS _value

				,GREATEST(
					-- Nillable
					(ft_a.nillable IS FALSE
						AND _value IS NULL)::int

					,(fejl_data_type[1])::text::int
					,(fejl_opslag[1])::text::int

					,((restriktion.kontrol[1][2])::boolean = FALSE)::int
				) AS fejl
			FROM features f
				,sandbox.kontrol_featuretype_attributes(
					_featuretype_fid := f.featuretype_fid
				) ft_a

				,xpath(
					'/attributes/' || ft_a.attr
					,f.attributes_xml
				) attr_xml


				,sandbox.kontrol_xml_decode((xpath('/*/text()', attr_xml[1]))[1]::text) _value

				,xpath('/*/@fejl_data_type', attr_xml[1]) fejl_data_type
				,xpath('/*/@fejl_opslag', attr_xml[1]) fejl_opslag

				,sandbox.kontrol_restriktion_sql(
					_attr := ft_a.attr
					,_restriktion_sql := ft_a.restriktion_sql

					,_attributes_xml := f.attributes_xml
					,_etablering_foer_skaering := f.feature_etablering_foer_skaering

					,_geometritype := COALESCE(f.geom_geometritype, f.geometritype)
					,_z_99_count := (xpath('/geometry/z_99_count/text()', f.geom_xml))[1]::text::int
				) restriktion(kontrol)
			WHERE f.feature_eksisterende = 0

			UNION ALL

			SELECT
				f.inputfile_fid
				,f.feature_fid


				,ft_a.attr
				,ft_a.attr_order

				,sandbox.kontrol_xml_encode(_value) AS _value

				,NULL::integer AS fejl
			FROM features f
				,sandbox.kontrol_featuretype_attributes(
					_featuretype_fid := f.featuretype_fid
				) ft_a

				,xpath(
					'/attributes/' || ft_a.attr
					,f.attributes_xml
				) attr_xml


				,sandbox.kontrol_xml_decode((xpath('/*/text()', attr_xml[1]))[1]::text) _value
			WHERE f.feature_eksisterende = 1
		)

		,feature_attributes_fejl AS(
			SELECT
				fa.inputfile_fid
				,fa.feature_fid


				,('<attributes fid="'
					|| lpad(
							fa.inputfile_fid::text
							,GREATEST(CEILING(log10(MAX(fa.inputfile_fid) OVER()))::int, 2)
							,'0'
						)
					|| '-'
					|| lpad(
							fa.feature_fid::text
							,GREATEST(CEILING(log10(MAX(fa.feature_fid) OVER()))::int, 2)
							,'0'
						)
					|| E'">\n'
					|| string_agg(
							FORMAT(
								CASE
									WHEN fa._value IS NULL
									THEN $$	<%1$s%3$s/>$$
									ELSE $$	<%1$s%3$s>%2$s</%1$s>$$
								END

								,fa.attr
								,fa._value

								,' fejl="' || fa.fejl || '"'
							)
							,E'\n'
							ORDER BY fa.attr_order
						)
					|| E'\n</attributes>')::xml AS attributes_xml
			FROM feature_attributes_fejl_1 fa
			GROUP BY fa.inputfile_fid
				,fa.feature_fid
		)



	INSERT INTO sandbox.kontrol_inputfiles_features
	SELECT
		_kontrol_guid
		,a.*
	FROM (
			SELECT
				f.inputfile_fid
				,f.inputfile_id
				,f.inputfile
				,f.inputfile_pretty
				,f.inputfile_order


				,f.featuretype_fid
				,f.featuretype
				,f.featuretype_pretty
				,f.featuretype_order


				,f.system_fid
				,f.system
				,f.system_pretty
				,f.system_order

				,f.forsyningsart_fid
				,f.forsyningsart
				,f.forsyningsart_pretty
				,f.forsyningsart_order

				,f.gruppe_fid
				,f.gruppe
				,f.gruppe_pretty
				,f.gruppe_order

				,f.geometritype_fid
				,f.geometritype
				,f.geometritype_pretty
				,f.geometritype_short
				,f.geometritype_order
				,f.pg_geometritype


				,f.dimension
				,f.dimension_pretty
				,f.dimension_zm_flag


				,f.snap_kontrol
				,f.snap_reference

				,f.forsyningsart_color_hex

				,f.feature_fid
				,f.feature_group
				,f.feature_etablering
				,f.feature_etablering_foer_skaering
				,f.feature_eksisterende

				,f.geom
				,fa.attributes_xml
				,f.geom_xml

				,f.geom_geometritype_fid
				,f.geom_geometritype
				,f.geom_geometritype_pretty
				,f.geom_geometritype_short
				,f.geom_geometritype_order
				,f.geom_pg_geometritype

			FROM features f
			INNER JOIN feature_attributes_fejl fa ON fa.inputfile_fid = f.inputfile_fid
				AND fa.feature_fid = f.feature_fid
		) a;

END $BODY$;
