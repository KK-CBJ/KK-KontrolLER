/* DROP FUNCTION IF EXISTS sandbox.kontrol_inputfiles_features_direction(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_inputfiles_features_direction(
	_kontrol_guid uuid
)
	RETURNS VOID
	VOLATILE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	DELETE FROM sandbox.kontrol_inputfiles_features_direction k
		WHERE k.kontrol_guid = _kontrol_guid;


	INSERT INTO sandbox.kontrol_inputfiles_features_direction
	SELECT
		_kontrol_guid
		,a.*
	FROM (
			SELECT
				gt.fid AS geometritype_fid
				,gt.navn AS geometritype
				,gt.navn_pretty AS geometritype_pretty
				,gt.navn_short AS geometritype_short
				,gt._order AS geometritype_order
				,gt.pg_geometritype

				,u.kontrol_id::text
				,ST_Force2D(
					ST_LineInterpolatePoint(
						ST_MakeLine(
							ST_GeometryN(segment.geom, 1)
							,ST_GeometryN(segment.geom, 2)
						)
						,0.5
					)
				) AS geom
				,(E'<attributes>\n'
					|| FORMAT(
						$$	<%1$s>%2$s</%1$s>$$
							,'direction'
							,DEGREES(
								ST_Azimuth(
									ST_GeometryN(segment.geom, 1)
									,ST_GeometryN(segment.geom, 2)
								)
							)::int
						)
					|| E'\n</attributes>')::xml AS attributes_xml
			FROM sandbox.kontrol_inputfiles_features f
				,UNNEST(xpath('/attributes/@fid', f.attributes_xml)) u(kontrol_id)

				-- Find knækpunkter, som danner det segment hvorpå midterpunktet er
				,LATERAL(
					SELECT
						dp.geom
					FROM (
						SELECT
							l.locate AS locate_start
							,LEAD(l.locate) OVER(ORDER BY l.locate) AS locate_end
							,ST_Collect(
								dp.geom
								,LEAD(dp.geom) OVER(ORDER BY l.locate)
							) AS geom
						FROM ST_DumpPoints(f.geom) dp
							,ST_LineLocatePoint(
								f.geom
								,dp.geom
							) l(locate)
					) dp
					WHERE 0.5 BETWEEN dp.locate_start AND dp.locate_end
					ORDER BY dp.locate_start
					LIMIT 1
				) segment

				,sandbox.kontrol_lst_geometrityper gt
			WHERE f.kontrol_guid = _kontrol_guid
				AND f.geom IS NOT NULL
				AND f.pg_geometritype ~* 'LINESTRING$'
				AND f.gruppe = 'ledning'

				AND gt.navn IN('punkt', 'Point')
				AND gt.aktiv IS TRUE
		) a;

END $BODY$;