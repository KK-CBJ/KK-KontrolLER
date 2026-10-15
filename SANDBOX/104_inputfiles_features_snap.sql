/* DROP FUNCTION IF EXISTS sandbox.kontrol_inputfiles_features_snap(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_inputfiles_features_snap(
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


		-- ,snap_featuretype_fid integer
		-- ,snap_featuretype text
		-- ,snap_featuretype_pretty text
		-- ,snap_featuretype_order integer

		-- ,snap_gruppe_fid integer
		-- ,snap_gruppe text
		-- ,snap_gruppe_pretty text
		-- ,snap_gruppe_order integer


		-- ,forsyningsart_color_hex text
		-- ,snap_color_hex text

		-- ,feature_fid text
		-- ,geom geometry('Point', 25832)
		-- ,fejl integer
	-- )
	-- STABLE
	VOLATILE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

DECLARE

	_precision integer := 3;
	_srid integer := 25832;

	_max_distance numeric := 0.5;

BEGIN

	DELETE FROM sandbox.kontrol_inputfiles_features_snap k
		WHERE k.kontrol_guid = _kontrol_guid;


	-- RETURN QUERY
	WITH

		features AS(
			SELECT
				ROW_NUMBER() OVER() AS geom_fid

				,f.inputfile_fid
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

				,f.geometritype_order
				,f.pg_geometritype


				,f.snap_kontrol
				,f.snap_reference

				,f.forsyningsart_color_hex

				,u.feature_fid::text


				,r.geom
			-- FROM sandbox.kontrol_inputfiles_features(
					-- _kontrol_guid := _kontrol_guid
			-- ) f
			FROM sandbox.kontrol_inputfiles_features f
				,UNNEST(xpath('/attributes/@fid', f.attributes_xml)) u(feature_fid)
				,ST_GeomFromText(
					ST_AsText( -- ST_AsText anvendes for også at reducere Z-koordinat
						ST_ReducePrecision( -- ST_ReducePrecision først for at minimere geometri-fejl
							ST_Force2D(
								f.geom
							)
							,POWER(10, _precision * -1)
							-- ,POWER(10, 4 * -1)
						)
						,_precision
						-- ,4
					)
					,_srid
					-- ,25832
				) r(geom)
			WHERE f.kontrol_guid = _kontrol_guid
				AND f.geom IS NOT NULL
				AND f.geom_pg_geometritype IS NULL
		)




		,reference_pts AS(
			SELECT
				array_agg(f.geom_fid) AS geom_fid_lst

				,f.system_fid
				,f.forsyningsart_fid

				,dmp.geom
			FROM features f
				,ST_DumpPoints(f.geom) dmp
			WHERE f.snap_reference IS TRUE
			GROUP BY f.system_fid
				,f.forsyningsart_fid

				,dmp.geom
		)

		,reference_geom AS(
			SELECT
				array_agg(f.geom_fid) AS geom_fid_lst

				,f.system_fid
				,f.forsyningsart_fid

				,f.geom
			FROM features f
			WHERE f.snap_reference IS TRUE
			GROUP BY f.system_fid
				,f.forsyningsart_fid

				,f.geom
		)



		,kontrol_pts AS(
			SELECT
				f.geom_fid

				,f.system_fid
				,f.forsyningsart_fid


				,f.gruppe_order
				,f.geometritype_order

				,st.geom
			FROM features f
				,ST_Dump(f.geom) dmp
				,ST_StartPoint(dmp.geom) st(geom)
			WHERE f.snap_kontrol IS TRUE
				AND f.pg_geometritype ~* 'LINESTRING$'

			UNION ALL

			SELECT
				f.geom_fid

				,f.system_fid
				,f.forsyningsart_fid


				,f.gruppe_order
				,f.geometritype_order

				,st.geom
			FROM features f
				,ST_Dump(f.geom) dmp
				,ST_EndPoint(dmp.geom) st(geom)
			WHERE f.snap_kontrol IS TRUE
				AND f.pg_geometritype ~* 'LINESTRING$'

			UNION ALL

			SELECT
				f.geom_fid

				,f.system_fid
				,f.forsyningsart_fid


				,f.gruppe_order
				,f.geometritype_order

				,st.geom
			FROM features f
				,ST_Dump(f.geom) dmp
				,ST_DumpPoints(dmp.geom) st
			WHERE f.snap_kontrol IS TRUE
				AND NOT(f.pg_geometritype ~* 'LINESTRING$')
		)



		-- Find snappet punkt
		,kontrol_step_1 AS(
			SELECT
				k.geom_fid

				,k.system_fid
				,k.forsyningsart_fid


				,k.gruppe_order
				,k.geometritype_order

				,s.snap_featuretype

				,k.geom
			FROM kontrol_pts k
			LEFT JOIN LATERAL(
				SELECT
					'snapped' AS snap_featuretype
				FROM reference_pts r
				WHERE k.system_fid = r.system_fid
					AND k.forsyningsart_fid = r.forsyningsart_fid
					AND k.geom_fid != ANY(r.geom_fid_lst)
					AND k.geom <-> r.geom = 0
				LIMIT 1
			) s ON TRUE
		)

		-- Find snappet geometri (tilnærmet)
		,kontrol_step_2 AS(
			SELECT
				k.geom_fid

				,k.system_fid
				,k.forsyningsart_fid


				,k.gruppe_order
				,k.geometritype_order

				,s.snap_featuretype

				,k.geom
			FROM kontrol_step_1 k
			LEFT JOIN LATERAL(
				SELECT
					'asSnapped' AS snap_featuretype
				FROM reference_geom r
				WHERE k.system_fid = r.system_fid
					AND k.forsyningsart_fid = r.forsyningsart_fid
					AND k.geom_fid != ANY(r.geom_fid_lst)
					AND k.geom <-> r.geom <= POWER(10, _precision * -1)
					-- AND k.geom <-> r.geom <= POWER(10, 4 * -1)
				LIMIT 1
			) s ON TRUE
			WHERE k.snap_featuretype IS NULL
		)

		-- Find ingen snap indenfor max distance
		,kontrol_step_3 AS(
			SELECT
				k.geom_fid

				,k.system_fid
				,k.forsyningsart_fid


				,k.gruppe_order
				,k.geometritype_order

				,s.snap_featuretype

				,k.geom
			FROM kontrol_step_2 k
			LEFT JOIN LATERAL(
				SELECT
					'noSnap' AS snap_featuretype
				FROM reference_geom r
				WHERE k.system_fid = r.system_fid
					AND k.forsyningsart_fid = r.forsyningsart_fid
					AND k.geom_fid != ANY(r.geom_fid_lst)
					AND k.geom <-> r.geom <= _max_distance
					-- AND k.geom <-> r.geom <= 0.5
			) s ON TRUE
			WHERE k.snap_featuretype IS NULL
		)



		,snap_1 AS(
			SELECT DISTINCT ON(k.system_fid, k.forsyningsart_fid, k.geom)
				k.geom_fid

				,k.system_fid
				,k.forsyningsart_fid


				,k.gruppe_order
				,k.geometritype_order

				,k.geom



				,s.fid AS snap_featuretype_fid
				,s.navn AS snap_featuretype
				,s.navn_pretty AS snap_featuretype_pretty
				,s._order AS snap_featuretype_order

				,s.fejl
				,s.color_hex

				,ST_ClusterKMeans(k.geom, 1, POWER(10, (_precision - 1) * -1)) OVER(PARTITION BY k.system_fid, k.forsyningsart_fid, s.fid) AS cluster_fid
				-- ,ST_ClusterDBSCAN(k.geom, POWER(10, (_precision - 1) * -1), 1) OVER(PARTITION BY k.system_fid, k.forsyningsart_fid, s.fid) AS cluster_fid

				-- ,ST_ClusterKMeans(k.geom, 1, POWER(10, (4 - 1) * -1)) OVER(PARTITION BY k.system_fid, k.system_fid, s.fid) AS cluster_fid
				-- ,ST_ClusterDBSCAN(k.geom, POWER(10, (4 - 1) * -1), 1) OVER(PARTITION BY k.system_fid, k.system_fid, s.fid) AS cluster_fid
			FROM (
					SELECT
						*
					FROM kontrol_step_1 k
					WHERE k.snap_featuretype IS NOT NULL

					UNION ALL

					SELECT
						*
					FROM kontrol_step_2 k
					WHERE k.snap_featuretype IS NOT NULL

					UNION ALL

					SELECT
						*
					FROM kontrol_step_3 k
					WHERE k.snap_featuretype IS NOT NULL
				) k
			INNER JOIN sandbox.kontrol_lst_snap s ON s.navn = k.snap_featuretype
				AND s.aktiv IS TRUE
			ORDER BY k.system_fid
				,k.forsyningsart_fid
				,k.geom

				,s._order

				,k.gruppe_order
				,k.geometritype_order
		)

		,snap AS(
			SELECT DISTINCT ON(s.system_fid, s.forsyningsart_fid, s.snap_featuretype, s.cluster_fid)
				s.geom_fid

				,s.geom



				,s.snap_featuretype_fid
				,s.snap_featuretype
				,s.snap_featuretype_pretty
				,s.snap_featuretype_order

				,s.fejl
				,s.color_hex
			FROM snap_1 s
			ORDER BY s.system_fid
				,s.forsyningsart_fid
				,s.snap_featuretype
				,s.cluster_fid

				,s.gruppe_order
				,s.geometritype_order
		)



	INSERT INTO sandbox.kontrol_inputfiles_features_snap
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

				,gt.fid AS geometritype_fid
				,gt.navn AS geometritype
				,gt.navn_pretty AS geometritype_pretty
				,gt.navn_short AS geometritype_short
				,gt._order AS geometritype_order
				,gt.pg_geometritype


				,s.snap_featuretype_fid
				,s.snap_featuretype
				,s.snap_featuretype_pretty
				,s.snap_featuretype_order

				,grp.fid AS snap_gruppe_fid
				,grp.navn AS snap_gruppe
				,grp.navn_pretty AS snap_gruppe_pretty
				,grp._order AS snap_gruppe_order


				,f.forsyningsart_color_hex
				,s.color_hex AS snap_color_hex

				,f.feature_fid
				,s.geom
				,s.fejl
			FROM snap s
			INNER JOIN features f ON f.geom_fid = s.geom_fid
			INNER JOIN sandbox.kontrol_lst_grupper grp ON grp.navn = 'snap'
				AND grp.aktiv IS TRUE
			INNER JOIN sandbox.kontrol_lst_geometrityper gt ON gt.navn IN('punkt', 'Point')
				AND gt.aktiv IS TRUE
		) a;

END $BODY$;