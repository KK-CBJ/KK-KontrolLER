/* DROP FUNCTION IF EXISTS sandbox.kontrol_featuretype_select_sql(
	_featuretype_fid integer
	,_kontrol_guid uuid
	,_geom_geometritype_fid integer
	,_arkiler_id text
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_featuretype_select_sql(
	_featuretype_fid integer
	,_kontrol_guid uuid
	,_dimension_zm_flag integer

	,_geom_pg_geometritype text

	,_arkiler_id text

	,OUT select_sql text
)
	RETURNS TEXT
	STABLE
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	SELECT
		FORMAT(


$$SELECT
	t.feature_fid
	,f.inputfile_id
	,f.feature_eksisterende
	,f.geom::geometry(%3$L, 25832)

	,%6$L::text AS arkiler_id

%7$s
-- FROM sandbox.kontrol_inputfiles_features(
		-- _kontrol_guid := %2$L::uuid
	-- ) f
FROM sandbox.kontrol_inputfiles_features f
	,xmltable(
		'/*' passing f.attributes_xml
			COLUMNS
				feature_fid text path '@fid'

%8$s
	) t
WHERE f.kontrol_guid = %2$L::uuid
	AND f.featuretype_fid = %1$s
	AND %4$s
	AND COALESCE(f.geom_pg_geometritype, f.pg_geometritype) = %5$L
	AND f.geom IS NOT NULL
	AND f.feature_eksisterende = 0$$


			,_featuretype_fid
			,_kontrol_guid

			,CASE
				WHEN _dimension_zm_flag >= 2
				THEN 'GEOMETRYZ'
				ELSE 'GEOMETRY'
			END

			,'f.dimension_zm_flag = ' || _dimension_zm_flag::text
			,_geom_pg_geometritype


			,_arkiler_id


			,string_agg(
				FORMAT(
					'	,t.%I'
					,f.attr
				)
				,E'\n'
				ORDER BY f.attr_order
			)
			,string_agg(
				FORMAT(
					$$				,%1$I text path '/attributes/%1$I/text()'$$
					,f.attr
				)
				,E'\n'
				ORDER BY f.attr_order
			)
		)
	FROM sandbox.kontrol_featuretype_attributes(
			_featuretype_fid := _featuretype_fid
		) f
	INTO select_sql;


END $BODY$;