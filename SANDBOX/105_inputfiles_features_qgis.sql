/* DROP FUNCTION IF EXISTS sandbox.kontrol_inputfiles_features_qgis(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_inputfiles_features_qgis(
	_kontrol_guid uuid
)
	RETURNS TABLE(
		table_name text
		,layer_title_pretty text
	)
	VOLATILE
	STRICT
	SECURITY DEFINER
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	i record;
	i_agg text[];

BEGIN

	PERFORM sandbox.kontrol_inputfiles(_kontrol_guid := _kontrol_guid);
	PERFORM sandbox.kontrol_inputfiles_features(_kontrol_guid := _kontrol_guid);


	FOR i IN
		WITH

			cte1 AS(
				SELECT DISTINCT ON(f.featuretype_fid, f.geometritype_fid, f.geom_pg_geometritype)
					k.guid
					,k.titel
					,k.arkiler_id


					,f.featuretype_fid

					,f.geometritype_fid


					,f.system_pretty
					,f.forsyningsart_pretty
					,f.gruppe_pretty
					,f.geometritype_pretty
					,CASE
						WHEN f.featuretype IS NOT NULL
						THEN f.featuretype_pretty
					END AS featuretype_pretty
					,f.geom_geometritype_short


					,f.dimension_zm_flag
					,COALESCE(f.geom_pg_geometritype, f.pg_geometritype) AS geom_pg_geometritype

					,COALESCE(f.geom_geometritype_order, f.geometritype_order) AS geometritype_order
				FROM sandbox.kontrol_xml k
					-- ,sandbox.kontrol_inputfiles_features(
						-- _kontrol_guid := k.guid
					-- ) f
					,sandbox.kontrol_inputfiles_features f
				WHERE k.guid = _kontrol_guid
					AND f.kontrol_guid = _kontrol_guid
			)

		SELECT
			array_to_string(
				ARRAY[
					'_tmp'
					,c.guid::text
					,c.featuretype_fid::text
					,c.geometritype_fid::text
					,LOWER(c.geom_pg_geometritype::text)
				]
				,'_'
			)::name::text AS table_name

			,array_to_string(
				ARRAY[
					c.system_pretty || ': ' || c.forsyningsart_pretty || ' ' || c.gruppe_pretty || ' ' || c.geometritype_pretty
					,c.featuretype_pretty
					,c.geom_geometritype_short
				]
				,', '
			) AS layer_title_pretty
			,s.select_sql
		FROM cte1 c
			,sandbox.kontrol_featuretype_select_sql(
				_featuretype_fid := c.featuretype_fid
				,_kontrol_guid := c.guid
				,_dimension_zm_flag := c.dimension_zm_flag

				,_geom_pg_geometritype := c.geom_pg_geometritype

				,_arkiler_id := c.arkiler_id
			) s
		ORDER BY c.featuretype_fid
			,c.geometritype_order
	LOOP

		EXECUTE FORMAT(
$$DROP TABLE IF EXISTS sandbox.%1$I;
CREATE TABLE sandbox.%1$I AS
%2$s;


GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE sandbox.%1$I TO PUBLIC;$$

			,i.table_name
			,i.select_sql
		);

		i_agg := i_agg || ARRAY[ARRAY[i.table_name, i.layer_title_pretty]];

	END LOOP;


	RETURN QUERY
	SELECT
		i_agg[g][1] AS table_name
		,i_agg[g][2] AS layer_title_pretty
	FROM generate_series(1, array_length(i_agg, 1)) g;


END $BODY$;





/* DROP FUNCTION IF EXISTS sandbox.kontrol_inputfiles_features_qgis_clear(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_inputfiles_features_qgis_clear(
	_kontrol_guid uuid
)
	RETURNS VOID
	VOLATILE
	STRICT
	SECURITY DEFINER
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	i record;
	i_agg text[];

BEGIN

	FOR i IN
		SELECT
			n.nspname
			,c.relname
		FROM pg_class c
		INNER JOIN pg_namespace n ON c.relnamespace = n.oid
			AND n.nspname = 'sandbox'
		WHERE c.relname ~* ('^_tmp_' || _kontrol_guid::text)
			AND c.relkind = 'r'
	LOOP

		EXECUTE FORMAT(
			$$DROP TABLE IF EXISTS %1$I.%2$I;$$

			,i.nspname
			,i.relname
		);

	END LOOP;


	DELETE FROM sandbox.kontrol_inputfiles k
		WHERE k.kontrol_guid = _kontrol_guid;
	DELETE FROM sandbox.kontrol_inputfiles_features k
		WHERE k.kontrol_guid = _kontrol_guid;

END $BODY$;