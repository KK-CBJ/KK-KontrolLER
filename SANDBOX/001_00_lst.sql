/*


WITH

	obj AS(
		SELECT
			n.nspname
			,c.relname
			,1 AS _order
			,FORMAT(
				$$TRUNCATE %I.%I RESTART IDENTITY;$$
				,n.nspname
				,c.relname
			) AS sql_
		FROM pg_class c
		INNER JOIN pg_namespace n ON c.relnamespace = n.oid
			AND n.nspname = 'sandbox'
		WHERE c.relname ~* '^kontrol_'
			AND c.relkind = 'r'
			AND c.relname != 'kontrol_xml'
			AND c.relname != 'kontrol_lst_skabeloner'
	)

SELECT
	string_agg(
		sql_
		,E'\n'
		ORDER BY nspname
			,_order
			,relname
	)
FROM obj;





WITH

	obj AS(
		SELECT
			n.nspname
			,p.proname AS relname
			,2 AS _order
			,FORMAT(
				$$DROP %s IF EXISTS %I.%I(%s) CASCADE;$$
				,'FUNCTION'
				,n.nspname
				,p.proname
				,pg_get_function_identity_arguments(p.oid)
			) AS sql_
		FROM pg_proc p
		INNER JOIN pg_namespace n ON p.pronamespace = n.oid
			AND n.nspname = 'sandbox'
		WHERE p.proname ~* '^kontrol_'
			AND p.prokind = 'f'
			AND p.proname NOT IN(
				'kontrol_hofor_ejerskab'
			)

		UNION ALL

		SELECT
			n.nspname
			,c.relname
			,1 AS _order
			,FORMAT(
				$$DROP TABLE IF EXISTS %I.%I CASCADE;$$
				,n.nspname
				,c.relname
			) AS sql_
		FROM pg_class c
		INNER JOIN pg_namespace n ON c.relnamespace = n.oid
			AND n.nspname = 'sandbox'
		WHERE c.relname ~* '^kontrol_'
			AND c.relkind = 'r'
			AND c.relname != 'kontrol_xml'
			AND c.relname != 'kontrol_lst_skabeloner'
	)

SELECT
	string_agg(
		sql_
		,E'\n'
		ORDER BY nspname
			,_order
			,relname
	)
FROM obj;

-- */



-- DROP TABLE IF EXISTS sandbox.kontrol_xml;

CREATE TABLE sandbox.kontrol_xml(
	guid uuid PRIMARY KEY DEFAULT uuid_generate_v4()
	,aktiv boolean NOT NULL
	,datooprettet timestamp NOT NULL
	,geom geometry('MULTIPOLYGON', 25832)
	,titel text
	,arkiler_id text
	,_xml text NOT NULL
	,_html_rapport text
);

-- DROP VIEW sandbox.kontrol_xml_v;
CREATE VIEW sandbox.kontrol_xml_v AS

SELECT
	 guid
	,aktiv
	,datooprettet
	,geom
	,titel
	,arkiler_id
FROM sandbox.kontrol_xml ORDER BY datooprettet DESC;



-- DROP FUNCTION IF EXISTS sandbox.kontrol_xml_trg() CASCADE;
CREATE OR REPLACE FUNCTION sandbox.kontrol_xml_trg()
	RETURNS trigger
	SECURITY DEFINER
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	IF (TG_WHEN = 'AFTER') THEN

		IF (TG_OP = 'INSERT') THEN

			-- DELETE FROM sandbox.kontrol_xml k
				-- WHERE k.arkiler_id IS NULL
					-- AND (current_timestamp(0) - k.datooprettet) > '30 days'::interval;

			UPDATE sandbox.kontrol_xml k
				SET
					aktiv = CASE
								WHEN k.arkiler_id IS NULL
								THEN FALSE
								ELSE k.aktiv
							END
					,_html_rapport = NULL
			WHERE (current_timestamp(0) - k.datooprettet) > '30 days'::interval
				AND (
					k.aktiv != CASE
								WHEN k.arkiler_id IS NULL
								THEN FALSE
								ELSE k.aktiv
							END
					OR k._html_rapport IS NOT NULL
				);

			UPDATE sandbox.kontrol_xml k
				SET
					_html_rapport = sandbox.kontrol_outputfile(NEW.guid)
			WHERE k.guid = NEW.guid;

			RETURN NEW;

		END IF;

	END IF;


	IF (TG_OP = 'DELETE') THEN

		RETURN OLD;

	ELSIF (TG_OP = 'UPDATE') THEN

		NEW.guid := OLD.guid;
		NEW.datooprettet := OLD.datooprettet;
		NEW.geom := OLD.geom;
		NEW.titel := OLD.titel;
		NEW._xml := OLD._xml;



		IF OLD.aktiv IS FALSE
			AND NEW.aktiv IS FALSE
			AND (
				(
					NEW.arkiler_id IS DISTINCT FROM OLD.arkiler_id
					AND NEW.arkiler_id IS NOT NULL
				) OR (
					NEW._html_rapport IS DISTINCT FROM OLD._html_rapport
					AND NEW._html_rapport IS NOT NULL
				)
			)
		THEN

			NEW.aktiv := TRUE;

		END IF;



		IF NEW.aktiv IS FALSE THEN

			NEW._html_rapport := NULL;

		END IF;

		RETURN NEW;

	ELSIF (TG_OP = 'INSERT') THEN

		NEW.titel := TRIM(
						((xpath(
							'kontrolLER/title/text()'
							,NEW._xml::xml
						))[1])::text
					);

		RETURN NEW;

	END IF;

END $BODY$;



-- DROP TRIGGER IF EXISTS kontrol_xml_trg_iud ON sandbox.kontrol_xml;
CREATE TRIGGER kontrol_xml_trg_iud
	BEFORE INSERT OR UPDATE OR DELETE
		ON sandbox.kontrol_xml
	FOR EACH ROW
	EXECUTE PROCEDURE sandbox.kontrol_xml_trg();



-- DROP TRIGGER IF EXISTS kontrol_xml_trg_a_i ON sandbox.kontrol_xml;
CREATE TRIGGER kontrol_xml_trg_a_i
	AFTER INSERT
		ON sandbox.kontrol_xml
	FOR EACH ROW
	EXECUTE PROCEDURE sandbox.kontrol_xml_trg();





-- DROP TABLE IF EXISTS sandbox.kontrol_lst_skabeloner;

CREATE TABLE sandbox.kontrol_lst_skabeloner(
	_name text PRIMARY KEY
	,_value text NOT NULL
);





-- DROP TABLE IF EXISTS sandbox.kontrol_fme_attributter_exclude CASCADE;

CREATE TABLE sandbox.kontrol_fme_attributter_exclude(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL

	,navn text NOT NULL UNIQUE
	,beskrivelse text
);
/*
INSERT INTO sandbox.kontrol_fme_attributter_exclude(aktiv, navn, beskrivelse) VALUES
	 (TRUE	,'fid'	,'Undgå autogenererede ID''er fra importeret data (GeoPackage)')
	,(TRUE	,'id'	,'Undgå autogenererede ID''er fra importeret data (Shape)')
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_fme_filtyper CASCADE;

CREATE TABLE sandbox.kontrol_fme_filtyper(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,navn_lst text[] NOT NULL
	,beskrivelse text
);
/*
INSERT INTO sandbox.kontrol_fme_filtyper(aktiv, navn, navn_pretty, navn_lst, beskrivelse) VALUES
	 (TRUE	,'shp'	,'Shape'		,'{shp,dbf,cpg,prj,shx,qmd,idx,qix}'	,NULL)
	,(TRUE	,'gpkg'	,'GeoPackage'	,'{gpkg}'								,NULL)
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_ja_nej CASCADE;

CREATE TABLE sandbox.kontrol_lst_ja_nej(
	fid integer PRIMARY KEY
	,aktiv boolean NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,beskrivelse text
);
/*
INSERT INTO sandbox.kontrol_lst_ja_nej(fid, aktiv, navn, navn_pretty, beskrivelse) VALUES
	 (0	,TRUE	,'nej'	,'Nej'	,NULL)
	,(1	,TRUE	,'ja'	,'Ja'	,NULL)
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_fejl CASCADE;

CREATE TABLE sandbox.kontrol_lst_fejl(
	fid integer PRIMARY KEY
	,aktiv boolean NOT NULL

	,navn integer NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,beskrivelse text

	,fejl_type text UNIQUE
);
/*
INSERT INTO sandbox.kontrol_lst_fejl(fid, aktiv, navn, navn_pretty, beskrivelse, fejl_type) VALUES
	 (1	,TRUE	,1	,'Fejl'	,NULL	,'error')
	,(2	,TRUE	,0	,'Ok'	,NULL	,NULL)
	,(3	,TRUE	,-1	,'Obs'	,NULL	,'obs')
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_srid CASCADE;

CREATE TABLE sandbox.kontrol_lst_srid(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL

	,navn integer NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,navn_lst integer[] NOT NULL
	,beskrivelse text
);
/*
INSERT INTO sandbox.kontrol_lst_srid(aktiv, navn, navn_pretty, navn_lst, beskrivelse) VALUES
	 (TRUE	,25832		,'EPSG:25832'	,'{25832}'		,NULL)
	,(TRUE	,4095		,'EPSG:4095'	,'{4095,4099}'	,NULL)
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_dimensioner CASCADE;

CREATE TABLE sandbox.kontrol_lst_dimensioner(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,beskrivelse text

	,zm_flag integer NOT NULL UNIQUE
);
/*
INSERT INTO sandbox.kontrol_lst_dimensioner(aktiv, navn, navn_pretty, beskrivelse, zm_flag) VALUES
	 (TRUE	,'2d'	,'2D'	,NULL		,0)
	,(TRUE	,'3d_m'	,'3D-M'	,NULL		,1)
	,(TRUE	,'3d_z'	,'3D-Z'	,NULL		,2)
	,(TRUE	,'4d'	,'4D'	,NULL		,3)
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_snap CASCADE;

CREATE TABLE sandbox.kontrol_lst_snap(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL
	,_order integer NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,beskrivelse text

	,color_hex text NOT NULL
	,fejl integer NOT NULL
);
/*
INSERT INTO sandbox.kontrol_lst_snap(aktiv, _order, navn, navn_pretty, beskrivelse, color_hex, fejl) VALUES
	 (TRUE	,3	,'snapped'			,'Snapped'			,NULL		,'#07a925'	,0)
	,(TRUE	,2	,'asSnapped'		,'Tilnærmet snap'	,NULL		,'#9ba907'	,0)
	,(TRUE	,1	,'noSnap'			,'Ingen snap'		,NULL		,'#fdc942'	,-1)
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_systemer CASCADE;

CREATE TABLE sandbox.kontrol_lst_systemer(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL
	,_order integer NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,navn_lst text[] NOT NULL
	,beskrivelse text
);
/*
INSERT INTO sandbox.kontrol_lst_systemer(aktiv, _order, navn, navn_pretty, navn_lst, beskrivelse) VALUES
	 (TRUE	,1	,'ler'			,'LER'		,'{ler}'	,NULL)
	-- ,(TRUE	,2	,'kkafloeb'		,'Afløb'	,'{nas}'	,NULL)
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_forsyningsarter CASCADE;

CREATE TABLE sandbox.kontrol_lst_forsyningsarter(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL
	,_order integer NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,navn_lst text[] NOT NULL
	,beskrivelse text

	,color_hex text NOT NULL
);
/*
INSERT INTO sandbox.kontrol_lst_forsyningsarter(aktiv, _order, navn,  navn_pretty, navn_lst, beskrivelse, color_hex) VALUES
	 (TRUE	,1	,'foeringsroer'		,'Føringsrør'			,'{foeringsroer,foeringsror,foringsroer,foringsror}'	,NULL		,'#f5a27a')
	,(TRUE	,11	,'afloeb'			,'Afløb'				,'{afloeb,aflob}'										,NULL		,'#693d07')
	,(TRUE	,12	,'el'				,'El'					,'{el}'													,NULL		,'#d73027')
	,(TRUE	,13	,'termisk'			,'Termisk'				,'{termisk}'											,NULL		,'#d957f9')
	,(TRUE	,14	,'gas'				,'Gas'					,'{gas}'												,NULL		,'#e9af00')
	,(TRUE	,15	,'olie'				,'Olie'					,'{olie}'												,NULL		,'#000000')
	,(TRUE	,16	,'tele'				,'Telekommunikation'	,'{tele,telekom,telekommunikation}'						,NULL		,'#009900')
	,(TRUE	,17	,'vand'				,'Vand'					,'{vand}'												,NULL		,'#0070ff')
	,(TRUE	,18	,'anden'			,'Anden'				,'{anden,andet}'										,NULL		,'#00ceb3')
	,(TRUE	,98	,'ukendt'			,'Ukendt'				,'{ukendt}'												,NULL		,'#ff5500')
	,(TRUE	,99	,'omlagtfjernet'	,'Omlagt/Fjernet'		,'{omlagtfjernet}'										,NULL		,'#9e9e9e')
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_grupper CASCADE;

CREATE TABLE sandbox.kontrol_lst_grupper(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL
	,_order integer NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,navn_lst text[] NOT NULL
	,beskrivelse text
);
/*
INSERT INTO sandbox.kontrol_lst_grupper(aktiv, _order, navn, navn_pretty, navn_lst, beskrivelse) VALUES
	 (TRUE	,-1	,'snap'			,'Snap'				,'{snap}'			,NULL)
	,(TRUE	,1	,'ledning'		,'Ledning'			,'{ledning,ledninger}'		,NULL)
	,(TRUE	,2	,'komponent'	,'Komponent'		,'{komponent,komponenter}'		,NULL)
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_geometrityper CASCADE;

CREATE TABLE sandbox.kontrol_lst_geometrityper(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL
	,_order integer

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,navn_lst text[]
	,beskrivelse text

	,pg_geometritype text NOT NULL
	,navn_short text NOT NULL
);
/*
INSERT INTO sandbox.kontrol_lst_geometrityper(aktiv, _order, navn, navn_pretty, navn_lst, beskrivelse, pg_geometritype, navn_short) VALUES
	 (TRUE	,1	,'punkt'		,'Punkt'				,'{punkt,punkter,pkt,pt,pts}'		,NULL		,'POINT'				,'Pkt.')
	,(TRUE	,2	,'linje'		,'Linje'				,'{linje,linjer,linie,li}'			,NULL		,'LINESTRING'			,'Li.')
	,(TRUE	,3	,'polygon'		,'Polygon'				,'{polygon,flade,poly,fl}'			,NULL		,'POLYGON'				,'Fl.')
	,(TRUE	,99	,'collection'	,'Kompleks geometri'	,'{collection}'						,NULL		,'GEOMETRYCOLLECTION'	,'Kompl.')
;
-- */





-- DROP TABLE IF EXISTS sandbox.kontrol_lst_eksisterende CASCADE;
-- IKKE IMPLEMENTERET
CREATE TABLE sandbox.kontrol_lst_eksisterende(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,beskrivelse text

	,system text NOT NULL
	,forsyningsart text NOT NULL
	,gruppe text NOT NULL
	,geometritype text NOT NULL

	,tabel_skema text NOT NULL
	,tabel_navn text NOT NULL
	,tabel_geom text NOT NULL
	,tabel_filter text
);
/*
INSERT INTO sandbox.kontrol_lst_eksisterende(aktiv, navn, navn_pretty, beskrivelse, system, forsyningsart, gruppe, geometritype, tabel_skema, tabel_navn, tabel_geom, tabel_filter) VALUES
	 (TRUE,	'ler_foeringsroer_ledning_linje'	,'LER, Føringsrør'								,NULL		,'ler'	,'foeringsroer'	,'ledning'		,'linje'	,'ler20'	,'foeringsroer_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'			,'geometri'	,NULL)

	,(TRUE,	'ler_afloeb_ledning_linje'			,'LER, Afløbsledning'							,NULL		,'ler'	,'afloeb'		,'ledning'		,'linje'	,'ler20'	,'afloeb_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_afloeb_komponent_punkt'		,'LER, Afløbskomponent, Punkt'					,NULL		,'ler'	,'afloeb'		,'komponent'	,'punkt'	,'ler20'	,'afloeb_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_afloeb_komponent_linje'		,'LER, Afløbskomponent, Linje'					,NULL		,'ler'	,'afloeb'		,'komponent'	,'linje'	,'ler20'	,'afloeb_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_afloeb_komponent_polygon'		,'LER, Afløbskomponent, Polygon'				,NULL		,'ler'	,'afloeb'		,'komponent'	,'polygon'	,'ler20'	,'afloeb_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'			,'geometri'	,NULL)

	,(TRUE,	'ler_el_ledning_linje'				,'LER, Elledning'								,NULL		,'ler'	,'el'			,'ledning'		,'linje'	,'ler20'	,'el_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(TRUE,	'ler_el_komponent_punkt'			,'LER, Elkomponent, Punkt'						,NULL		,'ler'	,'el'			,'komponent'	,'punkt'	,'ler20'	,'el_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(TRUE,	'ler_el_komponent_linje'			,'LER, Elkomponent, Linje'						,NULL		,'ler'	,'el'			,'komponent'	,'linje'	,'ler20'	,'el_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(TRUE,	'ler_el_komponent_polygon'			,'LER, Elkomponent, Polygon'					,NULL		,'ler'	,'el'			,'komponent'	,'polygon'	,'ler20'	,'el_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)

	,(TRUE,	'ler_termisk_ledning_linje'			,'LER, Termisk ledning'							,NULL		,'ler'	,'termisk'		,'ledning'		,'linje'	,'ler20'	,'termisk_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_termisk_komponent_punkt'		,'LER, Termisk komponent, Punkt'				,NULL		,'ler'	,'termisk'		,'komponent'	,'punkt'	,'ler20'	,'termisk_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_termisk_komponent_linje'		,'LER, Termisk komponent, Linje'				,NULL		,'ler'	,'termisk'		,'komponent'	,'linje'	,'ler20'	,'termisk_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_termisk_komponent_polygon'		,'LER, Termisk komponent, Polygon'				,NULL		,'ler'	,'termisk'		,'komponent'	,'polygon'	,'ler20'	,'termisk_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'			,'geometri'	,NULL)

	,(TRUE,	'ler_gas_ledning_linje'				,'LER, Gasledning'								,NULL		,'ler'	,'gas'			,'ledning'		,'linje'	,'ler20'	,'gas_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(TRUE,	'ler_gas_komponent_punkt'			,'LER, Gaskomponent, Punkt'						,NULL		,'ler'	,'gas'			,'komponent'	,'punkt'	,'ler20'	,'gas_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(TRUE,	'ler_gas_komponent_linje'			,'LER, Gaskomponent, Linje'						,NULL		,'ler'	,'gas'			,'komponent'	,'linje'	,'ler20'	,'gas_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(TRUE,	'ler_gas_komponent_polygon'			,'LER, Gaskomponent, Polygon'					,NULL		,'ler'	,'gas'			,'komponent'	,'polygon'	,'ler20'	,'gas_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)

	,(TRUE,	'ler_olie_ledning_linje'			,'LER, Olieledning'								,NULL		,'ler'	,'olie'			,'ledning'		,'linje'	,'ler20'	,'olie_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(TRUE,	'ler_olie_komponent_punkt'			,'LER, Oliekomponent, Punkt'					,NULL		,'ler'	,'olie'			,'komponent'	,'punkt'	,'ler20'	,'olie_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_olie_komponent_linje'			,'LER, Oliekomponent, Linje'					,NULL		,'ler'	,'olie'			,'komponent'	,'linje'	,'ler20'	,'olie_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_olie_komponent_polygon'		,'LER, Oliekomponent, Polygon'					,NULL		,'ler'	,'olie'			,'komponent'	,'polygon'	,'ler20'	,'olie_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)

	,(TRUE,	'ler_tele_ledning_linje'			,'LER, Telekommunikation ledning'				,NULL		,'ler'	,'tele'			,'ledning'		,'linje'	,'ler20'	,'telekommunikation_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'		,'geometri'	,NULL)
	,(TRUE,	'ler_tele_komponent_punkt'			,'LER, Telekommunikation komponent, Punkt'		,NULL		,'ler'	,'tele'			,'komponent'	,'punkt'	,'ler20'	,'telekommunikation_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'	,'geometri'	,NULL)
	,(TRUE,	'ler_tele_komponent_linje'			,'LER, Telekommunikation komponent, Linje'		,NULL		,'ler'	,'tele'			,'komponent'	,'linje'	,'ler20'	,'telekommunikation_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'	,'geometri'	,NULL)
	,(TRUE,	'ler_tele_komponent_polygon'		,'LER, Telekommunikation komponent, Polygon'	,NULL		,'ler'	,'tele'			,'komponent'	,'polygon'	,'ler20'	,'telekommunikation_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'	,'geometri'	,NULL)

	,(TRUE,	'ler_vand_ledning_linje'			,'LER, Vandledning'								,NULL		,'ler'	,'vand'			,'ledning'		,'linje'	,'ler20'	,'vand_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(TRUE,	'ler_vand_komponent_punkt'			,'LER, Vandkomponent, Punkt'					,NULL		,'ler'	,'vand'			,'komponent'	,'punkt'	,'ler20'	,'vand_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_vand_komponent_linje'			,'LER, Vandkomponent, Linje'					,NULL		,'ler'	,'vand'			,'komponent'	,'linje'	,'ler20'	,'vand_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_vand_komponent_polygon'		,'LER, Vandkomponent, Polygon'					,NULL		,'ler'	,'vand'			,'komponent'	,'polygon'	,'ler20'	,'vand_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)

	,(TRUE,	'ler_anden_ledning_linje'			,'LER, Anden ledning'							,NULL		,'ler'	,'anden'		,'ledning'		,'linje'	,'ler20'	,'anden_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(TRUE,	'ler_anden_komponent_punkt'			,'LER, Anden komponent, Punkt'					,NULL		,'ler'	,'anden'		,'komponent'	,'punkt'	,'ler20'	,'anden_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_anden_komponent_linje'			,'LER, Anden komponent, Linje'					,NULL		,'ler'	,'anden'		,'komponent'	,'linje'	,'ler20'	,'anden_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(TRUE,	'ler_anden_komponent_polygon'		,'LER, Anden komponent, Polygon'				,NULL		,'ler'	,'anden'		,'komponent'	,'polygon'	,'ler20'	,'anden_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)

	,(TRUE,	'ler_ukendt_ledning_linje'			,'LER, Ukendt ledning'							,NULL		,'ler'	,'ukendt'		,'ledning'		,'linje'	,'ler20'	,'ukendt_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_featuretyper CASCADE;

CREATE TABLE sandbox.kontrol_lst_featuretyper(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL
	,_order integer

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL
	,navn_lst text[]
	,beskrivelse text

	,system text NOT NULL
	,forsyningsart text NOT NULL
	,gruppe text NOT NULL
	,geometrityper_lst text[] NOT NULL

	,dimension text NOT NULL

	,group_column text

	,etablering_column text
	,etablering_skaering date

	,snap_kontrol boolean
	,snap_kontrol_geometrityper_lst text[]
	,snap_reference boolean
	,snap_reference_geometrityper_lst text[]

	,pakker_lst text[] NOT NULL
);
/*
INSERT INTO sandbox.kontrol_lst_featuretyper(aktiv, _order, navn, navn_pretty, navn_lst, beskrivelse, system, forsyningsart, gruppe, geometrityper_lst, dimension, group_column, etablering_column, etablering_skaering, snap_kontrol, snap_kontrol_geometrityper_lst, snap_reference, snap_reference_geometrityper_lst, pakker_lst) VALUES
	 (TRUE	,1	,'ler_foeringsroer_ledning'				,'Føringsrør'						,NULL			,NULL		,'ler'		,'foeringsroer'					,'ledning'		,'{linje}'					,'3d_z'	,'forsyningsart'	,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,NULL		,TRUE	,NULL	,'{ler_ledning_eller_trace,ler_ledning,ler_roerledning,ler_foeringsroer,generel_bemaerkning}')
	,(TRUE	,1	,'ler_afloeb_ledning'					,'Afløbsledning'					,NULL			,NULL		,'ler'		,'afloeb'						,'ledning'		,'{linje}'					,'3d_z'	,'medietype'		,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,NULL		,TRUE	,NULL	,'{ler_ledning_eller_trace,ler_ledning,ler_roerledning,ler_afloeb_ledning,generel_bemaerkning}')
	,(TRUE	,2	,'ler_afloeb_komponent'					,'Afløbskomponent'					,NULL			,NULL		,'ler'		,'afloeb'						,'komponent'	,'{punkt,linje,polygon}'	,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,'{punkt}'	,TRUE	,NULL	,'{ler_komponent,ler_afloeb_komponent,generel_bemaerkning}')
	,(TRUE	,1	,'ler_el_ledning'						,'Elledning'						,NULL			,NULL		,'ler'		,'el'							,'ledning'		,'{linje}'					,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,NULL		,TRUE	,NULL	,'{ler_ledning_eller_trace,ler_ledning,ler_el_ledning,generel_bemaerkning}')
	,(TRUE	,2	,'ler_el_komponent'						,'Elkomponent'						,NULL			,NULL		,'ler'		,'el'							,'komponent'	,'{punkt,linje,polygon}'	,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,'{punkt}'	,TRUE	,NULL	,'{ler_komponent,ler_el_komponent,generel_bemaerkning}')
	,(TRUE	,1	,'ler_termisk_ledning'					,'Termisk ledning'					,NULL			,NULL		,'ler'		,'termisk'						,'ledning'		,'{linje}'					,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,NULL		,TRUE	,NULL	,'{ler_ledning_eller_trace,ler_ledning,ler_roerledning,ler_termisk_ledning,generel_bemaerkning}')
	,(TRUE	,2	,'ler_termisk_komponent'				,'Termisk komponent'				,NULL			,NULL		,'ler'		,'termisk'						,'komponent'	,'{punkt,linje,polygon}'	,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,'{punkt}'	,TRUE	,NULL	,'{ler_komponent,ler_termisk_komponent,generel_bemaerkning}')
	,(TRUE	,1	,'ler_gas_ledning'						,'Gasledning'						,NULL			,NULL		,'ler'		,'gas'							,'ledning'		,'{linje}'					,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,NULL		,TRUE	,NULL	,'{ler_ledning_eller_trace,ler_ledning,ler_roerledning,ler_gas_ledning,generel_bemaerkning}')
	,(TRUE	,2	,'ler_gas_komponent'					,'Gaskomponent'						,NULL			,NULL		,'ler'		,'gas'							,'komponent'	,'{punkt,linje,polygon}'	,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,'{punkt}'	,TRUE	,NULL	,'{ler_komponent,ler_gas_komponent,generel_bemaerkning}')
	,(TRUE	,1	,'ler_olie_ledning'						,'Olieledning'						,NULL			,NULL		,'ler'		,'olie'							,'ledning'		,'{linje}'					,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,NULL		,TRUE	,NULL	,'{ler_ledning_eller_trace,ler_ledning,ler_roerledning,ler_olie_ledning,generel_bemaerkning}')
	,(TRUE	,2	,'ler_olie_komponent'					,'Oliekomponent'					,NULL			,NULL		,'ler'		,'olie'							,'komponent'	,'{punkt,linje,polygon}'	,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,'{punkt}'	,TRUE	,NULL	,'{ler_komponent,ler_olie_komponent,generel_bemaerkning}')
	,(TRUE	,1	,'ler_tele_ledning'						,'Telekommunikationsledning'		,NULL			,NULL		,'ler'		,'tele'							,'ledning'		,'{linje}'					,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,NULL		,TRUE	,NULL	,'{ler_ledning_eller_trace,ler_ledning,ler_tele_ledning,generel_bemaerkning}')
	,(TRUE	,2	,'ler_tele_komponent'					,'Telekommunikationskomponent'		,NULL			,NULL		,'ler'		,'tele'							,'komponent'	,'{punkt,linje,polygon}'	,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,'{punkt}'	,TRUE	,NULL	,'{ler_komponent,ler_tele_komponent,generel_bemaerkning}')
	,(TRUE	,1	,'ler_vand_ledning'						,'Vandledning'						,NULL			,NULL		,'ler'		,'vand'							,'ledning'		,'{linje}'					,'3d_z'	,NULL				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,NULL		,TRUE	,NULL	,'{ler_ledning_eller_trace,ler_ledning,ler_roerledning,generel_bemaerkning}')
	,(TRUE	,2	,'ler_vand_komponent'					,'Vandkomponent'					,NULL			,NULL		,'ler'		,'vand'							,'komponent'	,'{punkt,linje,polygon}'	,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,'{punkt}'	,TRUE	,NULL	,'{ler_komponent,ler_vand_komponent,generel_bemaerkning}')
	,(TRUE	,1	,'ler_anden_ledning'					,'Anden ledning'					,NULL			,NULL		,'ler'		,'anden'						,'ledning'		,'{linje}'					,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,NULL		,TRUE	,NULL	,'{ler_ledning_eller_trace,ler_ledning,ler_anden_ledning,generel_bemaerkning}')
	,(TRUE	,2	,'ler_anden_komponent'					,'Anden komponent'					,NULL			,NULL		,'ler'		,'anden'						,'komponent'	,'{punkt,linje,polygon}'	,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,'{punkt}'	,TRUE	,NULL	,'{ler_komponent,ler_anden_komponent,generel_bemaerkning}')
	,(TRUE	,1	,'ler_ukendt_ledning'					,'Ukendt ledning'					,NULL			,NULL		,'ler'		,'ukendt'						,'ledning'		,'{linje}'					,'3d_z'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,TRUE	,NULL		,TRUE	,NULL	,'{ler_ledning_eller_trace,ler_ledning,ler_ukendt_ledning,generel_bemaerkning}')
	,(TRUE	,1	,'ler_omlagtfjernet_ledning'			,'Omlagt/Fjernet ledning'			,NULL			,NULL		,'ler'		,'omlagtfjernet'				,'ledning'		,'{linje}'					,'2d'	,'driftsstat'		,NULL					,NULL::date			,FALSE	,NULL		,FALSE	,NULL	,'{ler_omlagtfjernet}')
	,(TRUE	,2	,'ler_omlagtfjernet_komponent'			,'Omlagt/Fjernet komponent'			,NULL			,NULL		,'ler'		,'omlagtfjernet'				,'komponent'	,'{punkt,linje,polygon}'	,'2d'	,'driftsstat'		,NULL					,NULL::date			,FALSE	,NULL		,FALSE	,NULL	,'{ler_omlagtfjernet}')

	-- ,(TRUE	,1	,'kkafloeb_afloeb_komponent_sandfang'	,'Sandfang'							,'{sandfang}'	,NULL		,'kkafloeb'	,'afloeb'		,'Komponent'	,'{Polygon}'				,'2D'	,'type'				,'etableringstidspunkt'	,'2023-07-01'::date	,FALSE	,NULL		,TRUE	,NULL	,'{}')
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_featuretype_grupper CASCADE;

CREATE TABLE sandbox.kontrol_lst_featuretype_grupper(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL
	,_order integer NOT NULL

	,navn text
	,navn_pretty text
	,navn_lst text[]
	,beskrivelse text

	,system text
	,forsyningsart text
	,gruppe text
	,geometritype text NOT NULL

	,color_hex text
	,js_style text
	,js_svg_legend text
	,CONSTRAINT featuretype_gruppe_unq UNIQUE(system, navn_pretty) -- NULLS NOT DISTINCT
);
/*
INSERT INTO sandbox.kontrol_lst_featuretype_grupper(aktiv, _order, navn, navn_pretty, navn_lst, beskrivelse, system, forsyningsart, gruppe, geometritype, color_hex) VALUES
	 (TRUE	,0	,'__frame__'	,'Omfang af indlæst data'	,'{__frame__}'						,NULL		,NULL	,NULL		,NULL			,'polygon'	,'#000000')

	,(TRUE	,1	,NULL					,NULL						,NULL						,NULL		,NULL	,NULL		,NULL			,'punkt'	,NULL)
	,(TRUE	,2	,NULL					,NULL						,NULL						,NULL		,NULL	,NULL		,NULL			,'linje'	,NULL)
	,(TRUE	,3	,NULL					,NULL						,NULL						,NULL		,NULL	,NULL		,NULL			,'polygon'	,NULL)

	,(TRUE	,4	,NULL					,NULL						,NULL						,NULL		,NULL	,NULL		,'snap'			,'punkt'	,NULL)

	,(TRUE	,10	,NULL					,NULL						,NULL						,NULL		,NULL	,NULL		,'komponent'	,'linje'	,NULL)

	,(TRUE	,21	,'broend'				,'Brønd'					,'{brønd}'					,NULL		,'ler'	,'afloeb'	,'komponent'	,'punkt'	,NULL)
	,(TRUE	,22	,'sandfang'				,'Sandfang'					,'{sandfang}'				,NULL		,'ler'	,'afloeb'	,'komponent'	,'punkt'	,NULL)
	,(TRUE	,23	,'regnvand'				,'Regnvand'					,'{regnvand}'				,NULL		,'ler'	,'afloeb'	,'ledning'		,'linje'	,'#035efc')
	,(TRUE	,24	,'draenvand'			,'Drænvand'					,'{drænvand}'				,NULL		,'ler'	,'afloeb'	,'ledning'		,'linje'	,'#56a7da')
	,(TRUE	,25	,'faellesvand'			,'Fællesvand'				,'{fællesvand}'				,NULL		,'ler'	,'afloeb'	,'ledning'		,'linje'	,'#22ab18')
	,(TRUE	,26	,'vand_uden_rensekrav'	,'Vand uden rensekrav'		,'{"vand uden rensekrav"}'	,NULL		,'ler'	,'afloeb'	,'ledning'		,'linje'	,'#09c8c6')
	,(TRUE	,27	,'spildevand'			,'Spildevand'				,'{spildevand}'				,NULL		,'ler'	,'afloeb'	,'ledning'		,'linje'	,'#c1641b')
;
-- */
/*
WITH

	cte1(_order, js_style, js_svg_legend) AS(
		VALUES
			(
0 -- Frame
,$$return {
	opacity: 1
	,color: '[COLOR_HEX]'
	,dashArray: ''
	,lineCap: 'butt'
	,lineJoin: 'miter'
	,weight: 1
	,fill: false
	,interactive: false
}$$
,$$<rect x="20%" y="20%" width="60%" height="60%" style="fill-opacity: 0; stroke: [COLOR_HEX]; stroke-width: 10%"/>$$
			)

			,(
1 -- Generelt, pkt
,$$<circle cx="50%" cy="50%" r="25%" style="fill: [COLOR_HEX]; stroke: [COLOR_HEX];"/>$$
,NULL
			)
			,(
2 -- Generelt, li
,$$return {
	opacity: feature.properties['leaflet.opacity']
	,color: '[COLOR_HEX]'
	,dashArray: ''
	,lineCap: 'square'
	,lineJoin: 'bevel'
	,weight: 3.0
	,fillOpacity: feature.properties['leaflet.fillOpacity']
	,interactive: true
}$$
,$$<line x1="2%" y1="50%" x2="98%" y2="50%" style="stroke: [COLOR_HEX]; stroke-width: 20%;"/>$$
			)
			,(
3 -- Generelt, poly
,$$return {
	opacity: feature.properties['leaflet.opacity']
	,color: '[COLOR_HEX]'
	,dashArray: ''
	,lineCap: 'butt'
	,lineJoin: 'miter'
	,weight: 1
	,fill: true
	,fillOpacity: feature.properties['leaflet.fillOpacity']
	,fillColor: '[COLOR_HEX]'
	,interactive: true
}$$
,$$<rect x="20%" y="20%" width="60%" height="60%" style="fill: [COLOR_HEX]; fill-opacity: 50%; stroke: [COLOR_HEX]; stroke-width: 10%"/>$$
			)

			,(
4 -- Snap, pkt
,$$<circle cx="50%" cy="50%" r="40%" style="fill: [COLOR_HEX]; stroke: black; stroke-width: 10%;"/>$$
,$$<circle cx="50%" cy="50%" r="32%" style="fill: [COLOR_HEX]; stroke: black; stroke-width: 10%;"/>$$
			)

			,(
10 -- Komponent, li
,$$return {
	opacity: feature.properties['leaflet.opacity']
	,color: '[COLOR_HEX]'
	,dashArray: '8'
	,lineCap: 'square'
	,lineJoin: 'bevel'
	,weight: 3.0
	,fillOpacity: feature.properties['leaflet.fillOpacity']
	,interactive: true
}$$
,$$<line x1="2%" y1="50%" x2="98%" y2="50%" style="stroke: [COLOR_HEX]; stroke-width: 20%; stroke-dasharray: 30%;"/>$$
			)

			,(
21 -- Brønd
,$$<rect x="25%" y="25%" width="50%" height="50%" style="fill: [COLOR_HEX]; stroke: [COLOR_HEX];"/>$$
,NULL
			)
			,(
22 -- Sandfang
,$$<rect x="25%" y="25%" width="50%" height="50%" style="fill: [COLOR_HEX]; stroke: [COLOR_HEX]; transform-box: fill-box; transform-origin: center; transform: rotate(45deg);"/>$$
,NULL
			)
	)

UPDATE sandbox.kontrol_lst_featuretype_grupper fg
	SET
		js_style = c.js_style
		,js_svg_legend = c.js_svg_legend
FROM cte1 c
WHERE fg._order = c._order;
-- */



-- DROP TABLE IF EXISTS sandbox.kontrol_lst_pakker CASCADE;

CREATE TABLE sandbox.kontrol_lst_pakker(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL
	,_order integer NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,beskrivelse text
);
/*
INSERT INTO sandbox.kontrol_lst_pakker(aktiv, _order, navn, navn_pretty, beskrivelse) VALUES
	 (TRUE	,11	,'ler_ledning_eller_trace'	,'LER: Ledning eller ledningstrace'		,NULL)
	,(TRUE	,12	,'ler_ledning'				,'LER: Ledning'							,NULL)
	,(TRUE	,13	,'ler_komponent'			,'LER: Ledningskomponent'				,NULL)
	,(TRUE	,15	,'ler_roerledning'			,'LER: Rørledning'						,NULL)

	,(TRUE	,18	,'ler_foeringsroer'			,'LER: Føringsrør'						,NULL)
	,(TRUE	,21	,'ler_afloeb_ledning'		,'LER: Afløbsledning'					,NULL)
	,(TRUE	,22	,'ler_afloeb_komponent'		,'LER: Afløbskomponent'					,NULL)
	,(TRUE	,31	,'ler_el_ledning'			,'LER: Elledning'						,NULL)
	,(TRUE	,32	,'ler_el_komponent'			,'LER: Elkomponent'						,NULL)
	,(TRUE	,41	,'ler_termisk_ledning'		,'LER: Termisk ledning'					,NULL)
	,(TRUE	,42	,'ler_termisk_komponent'	,'LER: Termisk komponent'				,NULL)
	,(TRUE	,51	,'ler_gas_ledning'			,'LER: Gasledning'						,NULL)
	,(TRUE	,52	,'ler_gas_komponent'		,'LER: Gaskomponent'					,NULL)
	,(TRUE	,61	,'ler_olie_ledning'			,'LER: Olieledning'						,NULL)
	,(TRUE	,62	,'ler_olie_komponent'		,'LER: Oliekomponent'					,NULL)
	,(TRUE	,71	,'ler_tele_ledning'			,'LER: Telekommunikationsledning'		,NULL)
	,(TRUE	,72	,'ler_tele_komponent'		,'LER: Telekommunikationskomponent'		,NULL)
	,(FALSE	,81	,'ler_vand_ledning'			,'LER: Vandledning'						,NULL)
	,(TRUE	,82	,'ler_vand_komponent'		,'LER: Vandkomponent'					,NULL)
	,(TRUE	,91	,'ler_anden_ledning'		,'LER: Anden ledning'					,NULL)
	,(TRUE	,92	,'ler_anden_komponent'		,'LER: Anden komponent'					,NULL)
	,(TRUE	,98	,'ler_ukendt_ledning'		,'LER: Ledning, ukendt forsyningsart'	,NULL)

	,(TRUE	,99	,'ler_omlagtfjernet'		,'LER: Omlagt/Fjernet'					,NULL)

	,(TRUE	,999	,'generel_bemaerkning'			,'Generel: Bemærkning'					,NULL)
;
-- */




-- DROP TABLE IF EXISTS sandbox.kontrol_lst_data_typer CASCADE;

CREATE TABLE sandbox.kontrol_lst_data_typer(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,beskrivelse text

	,kontrol_skema text
	,kontrol_navn text
	,kontrol_valid_idx integer
	,kontrol_output_idx integer
);
/*
INSERT INTO sandbox.kontrol_lst_data_typer(aktiv, navn, navn_pretty, beskrivelse, kontrol_skema, kontrol_navn, kontrol_valid_idx, kontrol_output_idx) VALUES
	 (TRUE	,'text'			,'Tekst'			,NULL		,NULL		,NULL					,NULL	,NULL)
	,(TRUE	,'tm_position'	,'Datoangivelse'	,NULL		,'ler20'	,'kontrol_tm_position'	,1		,4)
	,(TRUE	,'integer'		,'Heltal'			,NULL		,'ler20'	,'kontrol_integer'		,1		,2)
	,(TRUE	,'float'		,'Decimaltal'		,NULL		,'ler20'	,'kontrol_numeric'		,1		,2)
	,(TRUE	,'array'		,'Array'			,NULL		,'ler20'	,'kontrol_array'		,1		,2)
	,(TRUE	,'boolean'		,'Ja/Nej'			,NULL		,'ler20'	,'kontrol_boolean'		,1		,3)
	,(TRUE	,'datetime'		,'Dato/Tid'			,NULL		,'ler20'	,'kontrol_datetime'		,1		,2)
;
-- */





-- DROP TABLE IF EXISTS sandbox.kontrol_lst_kontrol_typer CASCADE;

CREATE TABLE sandbox.kontrol_lst_kontrol_typer(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,beskrivelse text
);
/*
INSERT INTO sandbox.kontrol_lst_kontrol_typer(aktiv, navn, navn_pretty, beskrivelse) VALUES
	 (TRUE	,'hidden'		,'Skjult'			,NULL)
	,(TRUE	,'no_control'	,'Ingen kontrol'	,NULL)
	,(TRUE	,'min_max'		,'Min-Max'			,NULL)
;
-- */





-- DROP TABLE IF EXISTS sandbox.kontrol_lst_opslagstabeller CASCADE;

CREATE TABLE sandbox.kontrol_lst_opslagstabeller(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,beskrivelse text

	,tabel_skema text NOT NULL
	,tabel_navn text NOT NULL
	,tabel_kolonne text NOT NULL
	,tabel_kolonne_sql_tooltip text

	,tabel_filter text
);
/*
INSERT INTO sandbox.kontrol_lst_opslagstabeller(aktiv, navn, navn_pretty, beskrivelse, tabel_skema, tabel_navn, tabel_kolonne, tabel_filter) VALUES
	 (TRUE	,'ler_faelles_drifsstatus'						,'LER, Fælles, Driftsstatus'					,NULL		,'ler20'	,'lst_driftsstatus'						,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_faelles_ejerskabsforhold'					,'LER, Fælles, Ejerskabsforhold'				,NULL		,'ler20'	,'lst_ejerskabsforholdtype'				,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_faelles_fareklasse'						,'LER, Fælles, Fareklasse'						,NULL		,'ler20'	,'lst_fareklasse'						,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_faelles_fareklasse_ikke_meget_farlig'		,'LER, Fælles, Fareklasse, uden meget farlig'	,NULL		,'ler20'	,'lst_fareklasse'						,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_faelles_indtegningsmetode'				,'LER, Fælles, Indtegningsmetode'				,NULL		,'ler20'	,'lst_indtegningsmetodetype'			,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_faelles_noejagtighedsklasse'				,'LER, Fælles, Nøjagtighedsklasse'				,NULL		,'ler20'	,'lst_noejagtighedsklasse'				,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_faelles_niveau'							,'LER, Fælles, Niveau'							,NULL		,'ler20'	,'lst_niveautype'						,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_faelles_tvaersnitsform'					,'LER, Fælles, Tværsnitsform'					,NULL		,'ler20'	,'lst_tvaersnitsformtype'				,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_faelles_forsyningsart'					,'LER, Fælles, Forsyningsart'					,NULL		,'ler20'	,'lst_forsyningsart'					,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_ledning_etableringsmetode'				,'LER, Ledning, Etableringsmetode'				,NULL		,'ler20'	,'lst_ledningsetableringsmetodetype'	,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_ledning_transporttype'					,'LER, Ledning, Transporttype'					,NULL		,'ler20'	,'lst_ledningstransporttype'			,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_afloeb_komponenttype'						,'LER, Afløb, Komponenttype'					,NULL		,'ler20'	,'lst_afloebskomponenttype'				,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_afloeb_medietype'							,'LER, Afløb, Medietype'						,NULL		,'ler20'	,'lst_medietype'						,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_afloeb_broendform'						,'LER, Afløb, Brøndform'						,NULL		,'ler20'	,'lst_broendformtype'					,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_el_ledningstype'							,'LER, El, Ledningstype'						,NULL		,'ler20'	,'lst_elledningstype'					,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_el_komponenttype'							,'LER, El, Komponenttype'						,NULL		,'ler20'	,'lst_elkomponenttype'					,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_el_relativ_niveau'						,'LER, El, Relativ niveau'						,NULL		,'ler20'	,'lst_relativniveautype'				,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_termisk_ledningstype'						,'LER, Termisk, Ledningstype'					,NULL		,'ler20'	,'lst_termiskledningstype'				,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_termisk_komponenttype'					,'LER, Termisk, Komponenttype'					,NULL		,'ler20'	,'lst_termiskkomponenttype'				,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_termisk_indholdstype'						,'LER, Termisk, Indholdstype'					,NULL		,'ler20'	,'lst_termiskledningsindholdstype'		,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_termisk_konstruktiontype'					,'LER, Termisk, Konstruktiontype'				,NULL		,'ler20'	,'lst_termiskledningkonstruktiontype'	,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_gas_ledningstype'							,'LER, Gas, Ledningstype'						,NULL		,'ler20'	,'lst_gasledningstype'					,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_gas_komponenttype'						,'LER, Gas, Komponenttype'						,NULL		,'ler20'	,'lst_gaskomponenttype'					,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_gas_medietype'							,'LER, Gas, Medietype'							,NULL		,'ler20'	,'lst_gasledningsmedietype'				,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_tele_ledningstype'						,'LER, Tele, Ledningstype'						,NULL		,'ler20'	,'lst_telekommunikationsledningstype'	,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_tele_komponenttype'						,'LER, Tele, Komponenttype'						,NULL		,'ler20'	,'lst_telekommunikationskomponenttype'	,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_vand_komponenttype'						,'LER, Vand, Komponenttype'						,NULL		,'ler20'	,'lst_vandkomponenttype'				,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_vand_tapsted'								,'LER, Vand, Tapsted'							,NULL		,'ler20'	,'lst_tapstedstype'						,'type'	,'aktiv IS TRUE')
	,(TRUE	,'ler_vand_anborsted'							,'LER, Vand, Anborsted'							,NULL		,'ler20'	,'lst_anborstedtype'					,'type'	,'aktiv IS TRUE')
;
-- */



-- DROP TABLE IF EXISTS sandbox.kontrol_lst_attributter_geometri CASCADE;

CREATE TABLE sandbox.kontrol_lst_attributter_geometri(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL
	,_order integer NOT NULL

	,navn text NOT NULL UNIQUE
	,navn_pretty text NOT NULL UNIQUE
	,beskrivelse text

	,pakke text NOT NULL

	,tooltip_html text
);
/*
INSERT INTO sandbox.kontrol_lst_attributter_geometri(aktiv, _order, pakke, navn, navn_pretty, beskrivelse, tooltip_html) VALUES
	 (TRUE	,1	,'geometri'	,'mgd'			,'Mængde'					,NULL	,NULL)
	,(TRUE	,2	,'geometri'	,'z_count'		,'Antal knudepunkter'		,NULL	,NULL)
	,(TRUE	,3	,'geometri'	,'z_min_max'	,'Z (Min/Maks)'				,NULL	,NULL)

	,(TRUE	,11	,'geometri'	,'no_geom'		,'Ingen geometri'			,NULL	,'<p>Geometrien mangler</p>')
	,(TRUE	,12	,'geometri'	,'srid'			,'Koordinatsystem'			,NULL	,E'<p>Koordinatsystemet skal være et af følgende:</p>\n<ul>\n\t<li>EPSG:4095 - "ETRS89 / DKTM3" + DVR90 koter</li>\n\t<li>EPSG:4099 - "ETRS89 / DKTM3" + DVR90 height</li>\n\t<li>EPSG:25832 - "ETRS89 / UTM zone 32N" + DVR90 koter</li>\n</ul>')
	,(TRUE	,13	,'geometri'	,'ndims'		,'Dimensioner (XYZ)'		,NULL	,'<p>Visse objekter skal være i 3D-Z</p>')
	,(TRUE	,14	,'geometri'	,'geometritype'	,'Geometritype'				,NULL	,E'<p>Geometritypen skal matche navnet på filen og må ikke være en blanding af flere geometrityper</p>\n<hr class="tooltip_break"/>\n<p>Ved denne type fejl vises geometrierne ikke nødvendigvis i kortet</p>')
	,(TRUE	,15	,'geometri'	,'singlegeom'	,'Singlegeometri'			,NULL	,E'<p>Geometrien skal være <i>singlegeometri</i></p>\n<hr class="tooltip_break"/>\n<p>Geometrien må altså ikke bestå af flere separate geometrier</p>')
	,(TRUE	,16	,'geometri'	,'min_mgd'		,'Størrelse'				,NULL	,E'<p>Geometrier skal være over en vis størrelse</p>')
	,(TRUE	,17	,'geometri'	,'valid'		,'Geometrifejl'				,NULL	,'<p>Geometrien må ikke indeholde topologiske fejl</p>')
	,(TRUE	,18	,'geometri'	,'snap'			,'Snap'						,NULL	,E'<p>Knudepunkter tjekkes for snap</p>\n<hr class="tooltip_break"/>\n<ul>\n<li><b>Ingen snap:</b><br/>Vises med gul på kortet<br/>Snapper ikke til noget indenfor rimelig afstand</li>\n<li><b>Tilnærmet snap:</b><br/>Vises med lys grøn på kortet<br/>Knudepunktet ligger så tæt på en linje eller kanten af en polygon, at det godt kan anses som snappet</li>\n<li><b>Snappet:</b><br/>Vises med mørk grøn på kortet</li>\n</ul>')
	,(TRUE	,19	,'geometri'	,'z_99'			,'Ukendte Z-koordinater'	,NULL	,'<p>Z-koordinaten må ikke være ukendt (-99) efter skæringsdatoen</p>')
	,(TRUE	,20	,'geometri'	,'z_0'			,'"0"-Z-koordinater'		,NULL	,E'<p>Z-koordinater med værdien 0 er meget usandsynlige. Typisk er det fordi Z-koordinaterne mangler</p>\n<hr class="tooltip_break"/>\n<p>Hvis Z-koordinaten er ukendt, skal den i stedet være -99, men vær opmærksom på, at der kan gælde krav som gør, at Z-koordinaten ikke må være ukendt</p>')
	,(TRUE	,21	,'geometri'	,'z_nan'		,'"NaN"-Z-koordinater'		,NULL	,'<p>Z-koordinater må ikke være "NaN" / NULL</p>')
;
-- */



-- DROP TABLE IF EXISTS sandbox.kontrol_lst_attributter CASCADE;

CREATE TABLE sandbox.kontrol_lst_attributter(
	fid SERIAL PRIMARY KEY
	,aktiv boolean NOT NULL
	,_order integer NOT NULL

	,navn text NOT NULL
	,navn_pretty text NOT NULL
	,navn_lst text[]
	,beskrivelse text

	,pakke text NOT NULL

	,data_type text NOT NULL
	,nillable boolean NOT NULL
	,default_value text
	,restriktion_sql text
	,restriktion_beskrivelse text

	,opslagstabel text
	,opslagstabel_filter text

	,kontrol_type text
	,fejl integer NOT NULL

	,enhed text

	,forsyningsart_incl_lst text[]
	,forsyningsart_excl_lst text[]

	,tooltip_html text
);
/*
INSERT INTO sandbox.kontrol_lst_attributter(aktiv, _order, pakke, navn, navn_pretty, navn_lst, beskrivelse, data_type, nillable, kontrol_type, fejl, enhed, forsyningsart_incl_lst, forsyningsart_excl_lst) VALUES
	 (TRUE	,1	,'ler_ledning_eller_trace'	,'driftsstatus'							,'Driftsstatus'							,'{driftsstatus,driftsstat}'						,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_ledning_eller_trace'	,'ejerskabsforhold'						,'Ejerskabsforhold'						,'{ejerskabsforhold,ejerskabsf}'					,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,3	,'ler_ledning_eller_trace'	,'etableringstidspunkt'					,'Etableringstidspunkt'					,'{etableringstidspunkt,etab_tid}'					,NULL		,'tm_position'	,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,4	,'ler_ledning_eller_trace'	,'fareklasse'							,'Fareklasse'							,'{fareklasse,fareklas}'							,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,'{el,termisk,gas,tele,vand}')
	,(TRUE	,4	,'ler_ledning_eller_trace'	,'fareklasse'							,'Fareklasse'							,'{fareklasse,fareklas}'							,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,'{tele,vand}'		,NULL)
	,(TRUE	,4	,'ler_ledning_eller_trace'	,'fareklasse'							,'Fareklasse'							,'{fareklasse,fareklas}'							,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,'{el,termisk,gas}'	,NULL)
	,(TRUE	,5	,'ler_ledning_eller_trace'	,'id'									,'ID'									,'{id}'												,NULL		,'text'			,TRUE	,'hidden'		,0		,NULL		,NULL				,NULL)
	,(TRUE	,6	,'ler_ledning_eller_trace'	,'indtegningsmetode'					,'Indtegningsmetode'					,'{indtegningsmetode,indteg_met}'					,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,7	,'ler_ledning_eller_trace'	,'noejagtighedsklasse'					,'Nøjagtighedsklasse'					,'{noejagtighedsklasse,nojagt_kla}'					,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(FALSE	,8	,'ler_ledning_eller_trace'	,'registreringfra'						,'Registrering fra'						,'{registreringfra,regist_fra}'						,NULL		,'datetime'		,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,9	,'ler_ledning_eller_trace'	,'sikkerhedshensyn'						,'Sikkerhedshensyn'						,'{sikkerhedshensyn,sik_hensyn}'					,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,10	,'ler_ledning_eller_trace'	,'vejledendedybde'						,'Vejledende dybde'						,'{vejledendedybde,vejl_dybd}'						,NULL		,'float'		,TRUE	,NULL			,0		,'mm'		,NULL				,'{foeringsroer,el,tele}')
	,(TRUE	,10	,'ler_ledning_eller_trace'	,'vejledendedybde'						,'Vejledende dybde'						,'{vejledendedybde,vejl_dybd}'						,NULL		,'float'		,TRUE	,NULL			,-1		,'mm'		,'{foeringsroer}'	,NULL)
	,(TRUE	,10	,'ler_ledning_eller_trace'	,'vejledendedybde'						,'Vejledende dybde'						,'{vejledendedybde,vejl_dybd}'						,NULL		,'float'		,TRUE	,NULL			,-1		,'mm'		,'{el,tele}'		,NULL)
	,(FALSE	,11	,'ler_ledning_eller_trace'	,'bilag'								,'Bilag'								,'{bilag}'											,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(FALSE	,12	,'ler_ledning_eller_trace'	,'kontaktprofiltiltekniskespoergsmaal'	,'Kontaktprofil til tekniske spørgsmål'	,'{kontaktprofiltiltekniskespoergsmaal,kontakt}'	,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_ledning'				,'niveau'								,'Niveau'								,'{niveau}'											,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_ledning'				,'indeholderledninger'					,'Indeholder ledninger'					,'{indeholderledninger,indeh_led}'					,NULL		,'boolean'		,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,3	,'ler_ledning'				,'ledningsetableringsmetode'			,'Ledningsetableringsmetode'			,'{ledningsetableringsmetode,etablmetod}'			,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,4	,'ler_ledning'				,'liggeriledning'						,'Ligger i ledning'						,'{liggeriledning,lig_i_led}'						,NULL		,'boolean'		,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,5	,'ler_ledning'				,'udvendigdiameter'						,'Udvendig diameter'					,'{udvendigdiameter,udven_dm}'						,NULL		,'float'		,TRUE	,NULL			,-1		,'mm'		,NULL				,'{el,tele}')
	,(TRUE	,5	,'ler_ledning'				,'udvendigdiameter'						,'Udvendig diameter'					,'{udvendigdiameter,udven_dm}'						,NULL		,'float'		,TRUE	,NULL			,1		,'mm'		,'{el,tele}'		,NULL)
	,(TRUE	,6	,'ler_ledning'				,'udvendigfarve'						,'Udvendig farve'						,'{udvendigfarve,udvend_far,udven_farv}'			,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,7	,'ler_ledning'				,'udvendigmateriale'					,'Udvendig materiale'					,'{udvendigmateriale,udven_mate}'					,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(FALSE	,8	,'ler_ledning'				,'indeholdtledning'						,'Indeholdt ledning'					,'{indeholdtledning,indh_ledn}'						,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(FALSE	,9	,'ler_ledning'				,'startkomponent'						,'Startkomponent'						,'{startkomponent,startkomp}'						,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(FALSE	,10	,'ler_ledning'				,'slutkomponent'						,'Slutkomponent'						,'{slutkomponent,slutkomp}'							,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_komponent'			,'driftsstatus'							,'Driftsstatus'							,'{driftsstatus,driftsstat}'						,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_komponent'			,'ejerskabsforhold'						,'Ejerskabsforhold'						,'{ejerskabsforhold,ejerskabsf}'					,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,3	,'ler_komponent'			,'etableringstidspunkt'					,'Etableringstidspunkt'					,'{etableringstidspunkt,etab_tid}'					,NULL		,'tm_position'	,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,4	,'ler_komponent'			,'fareklasse'							,'Fareklasse'							,'{fareklasse,fareklas}'							,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,NULL				,'{el}')
	,(TRUE	,4	,'ler_komponent'			,'fareklasse'							,'Fareklasse'							,'{fareklasse,fareklas}'							,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,'{el}'				,NULL)
	,(FALSE	,5	,'ler_komponent'			,'id'									,'ID'									,'{id}'												,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,6	,'ler_komponent'			,'materiale'							,'Materiale'							,'{materiale}'										,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,7	,'ler_komponent'			,'noejagtighedsklasse'					,'Nøjagtighedsklasse'					,'{noejagtighedsklasse,nojagt_kla}'					,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,NULL				,NULL)
	,(FALSE	,8	,'ler_komponent'			,'registreringfra'						,'Registrering fra'						,'{registreringfra,regist_fra}'						,NULL		,'datetime'		,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,9	,'ler_komponent'			,'sikkerhedshensyn'						,'Sikkerhedshensyn'						,'{sikkerhedshensyn,sik_hensyn}'					,NULL		,'text'			,TRUE	,'no_control'	,0		,NULL		,NULL				,NULL)
	,(TRUE	,10	,'ler_komponent'			,'vejledendedybde'						,'Vejledende dybde'						,'{vejledendedybde,vejl_dybd}'						,NULL		,'float'		,TRUE	,NULL			,-1		,'mm'		,NULL				,NULL)
	,(FALSE	,11	,'ler_komponent'			,'bilag'								,'Bilag'								,'{bilag}'											,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(FALSE	,12	,'ler_komponent'			,'kontaktprofiltiltekniskespoergsmaal'	,'Kontaktprofil til tekniske spørgsmål'	,'{kontaktprofiltiltekniskespoergsmaal,kontakt}'	,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,13	,'ler_komponent'			,'niveau'								,'Niveau'								,'{niveau}'											,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,NULL				,NULL)
	,(FALSE	,14	,'ler_komponent'			,'tilknyttetledning'					,'Tilknyttet ledning'					,'{tilknyttetledning,tilkny_led}'					,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_roerledning'			,'tvaersnitsform'						,'Tværsnitsform'						,'{tvaersnitsform,tvaerform}'						,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_roerledning'			,'udvendigbredde'						,'Udvendig bredde'						,'{udvendigbredde,udven_bre}'						,NULL		,'float'		,TRUE	,NULL			,-1		,'mm'		,NULL				,NULL)
	,(TRUE	,3	,'ler_roerledning'			,'udvendighoejde'						,'Udvendig højde'						,'{udvendighoejde,udven_hoj}'						,NULL		,'float'		,TRUE	,NULL			,-1		,'mm'		,NULL				,NULL)
	,(TRUE	,1	,'ler_foeringsroer'			,'forsyningsart'						,'Forsyningsart'						,'{forsyningsart,forsyn_art}'						,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_ukendt_ledning'		,'supplerendeinfo'						,'Supplerende info'						,'{supplerendeinfo,supp_info}'						,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_afloeb_ledning'		,'harfod'								,'Har fod'								,'{harfod}'											,NULL		,'boolean'		,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_afloeb_ledning'		,'ledningstransporttype'				,'Ledningstransporttype'				,'{ledningstransporttype,trans_type}'				,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,3	,'ler_afloeb_ledning'		,'medietype'							,'Medietype'							,'{medietype,med_typ}'								,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_el_ledning'			,'type'									,'Type'									,'{type,led_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_el_ledning'			,'afdaekning'							,'Afdækning'							,'{afdaekning}'										,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,3	,'ler_el_ledning'			,'antalkabler'							,'Antal kabler'							,'{antalkabler,ant_kabler}'							,NULL		,'integer'		,TRUE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,4	,'ler_el_ledning'			,'kabeltype'							,'Kabeltype'							,'{kabeltype}'										,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,5	,'ler_el_ledning'			,'spaendingsniveau'						,'Spændingsniveau'						,'{spaendingsniveau,spaend_niv}'					,NULL		,'float'		,TRUE	,NULL			,1		,'kV'		,NULL				,NULL)
	,(TRUE	,1	,'ler_termisk_ledning'		,'type'									,'Type'									,'{type,led_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_termisk_ledning'		,'indhold'								,'Indhold'								,'{indhold,indh_type}'								,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,3	,'ler_termisk_ledning'		,'konstruktion'							,'Konstruktion'							,'{konstruktion,konst_type}'						,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,4	,'ler_termisk_ledning'		,'temperatur'							,'Temperatur'							,'{temperatur}'										,NULL		,'float'		,TRUE	,NULL			,0		,'Cel'		,NULL				,NULL)
	,(TRUE	,5	,'ler_termisk_ledning'		,'tryk'									,'Tryk'									,'{tryk}'											,NULL		,'float'		,TRUE	,NULL			,0		,'bar'		,NULL				,NULL)
	,(TRUE	,1	,'ler_gas_ledning'			,'type'									,'Type'									,'{type,led_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_gas_ledning'			,'tryk'									,'Tryk'									,'{tryk}'											,NULL		,'float'		,TRUE	,NULL			,0		,'bar'		,NULL				,NULL)
	,(TRUE	,3	,'ler_gas_ledning'			,'medietype'							,'Medietype'							,'{medietype,med_typ}'								,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_olie_ledning'			,'tryk'									,'Tryk'									,'{tryk}'											,NULL		,'float'		,TRUE	,NULL			,0		,'bar'		,NULL				,NULL)
	,(TRUE	,2	,'ler_olie_ledning'			,'type'									,'Type'									,'{type,led_type}'									,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_tele_ledning'			,'type'									,'Type'									,'{type,led_type}'									,NULL		,'text'			,TRUE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_anden_ledning'		,'forsyningsart'						,'Forsyningsart'						,'{forsyningsart,forsyn_art}'						,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_anden_ledning'		,'tvaersnitsform'						,'Tværsnitsform'						,'{tvaersnitsform,tvaerform}'						,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,3	,'ler_anden_ledning'		,'type'									,'Type'									,'{type,led_type}'									,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,4	,'ler_anden_ledning'		,'udvendigbredde'						,'Udvendig bredde'						,'{udvendigbredde,udven_bre}'						,NULL		,'float'		,TRUE	,NULL			,0		,'mm'		,NULL				,NULL)
	,(TRUE	,5	,'ler_anden_ledning'		,'udvendighoejde'						,'Udvendig højde'						,'{udvendighoejde,udven_hoj}'						,NULL		,'float'		,TRUE	,NULL			,0		,'mm'		,NULL				,NULL)
	,(TRUE	,1	,'ler_afloeb_komponent'		,'type'									,'Type'									,'{type,komp_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_afloeb_komponent'		,'broendform'							,'Brøndform'							,'{broendform,brondform}'							,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,3	,'ler_afloeb_komponent'		,'bunddiameterbredde'					,'Bund, diameter/bredde'				,'{bunddiameterbredde,bund_dm_br}'					,NULL		,'float'		,TRUE	,NULL			,0		,'mm'		,NULL				,NULL)
	,(TRUE	,4	,'ler_afloeb_komponent'		,'bundlaengde'							,'Bund, længde'							,'{bundlaengde,bundlaengd}'							,NULL		,'float'		,TRUE	,NULL			,0		,'mm'		,NULL				,NULL)
	,(TRUE	,5	,'ler_afloeb_komponent'		,'bundkote'								,'Bundkote'								,'{bundkote}'										,NULL		,'float'		,TRUE	,'min_max'		,0		,NULL		,NULL				,NULL)
	,(TRUE	,6	,'ler_afloeb_komponent'		,'medietype'							,'Medietype'							,'{medietype,med_typ}'								,NULL		,'text'			,TRUE	,NULL			,0		,NULL		,NULL				,NULL)
	,(TRUE	,7	,'ler_afloeb_komponent'		,'topkote'								,'Topkote'								,'{topkote}'										,NULL		,'float'		,TRUE	,'min_max'		,0		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_el_komponent'			,'type'									,'Type'									,'{type,komp_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_el_komponent'			,'relativniveau'						,'Relativ niveau for blok'				,'{relativniveau,niv_blok}'							,NULL		,'text'			,TRUE	,NULL			,-1		,NULL		,NULL				,NULL)
	,(TRUE	,3	,'ler_el_komponent'			,'spaendingsniveau'						,'Spændingsniveau'						,'{spaendingsniveau,spaend_niv}'					,NULL		,'float'		,TRUE	,NULL			,0		,'kV'		,NULL				,NULL)
	,(TRUE	,1	,'ler_termisk_komponent'	,'type'									,'Type'									,'{type,komp_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_gas_komponent'		,'type'									,'Type'									,'{type,komp_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_gas_komponent'		,'topkote'								,'Topkote'								,'{topkote}'										,NULL		,'float'		,TRUE	,'min_max'		,0		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_olie_komponent'		,'type'									,'Type'									,'{type,komp_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_tele_komponent'		,'type'									,'Type'									,'{type,komp_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_vand_komponent'		,'type'									,'Type'									,'{type,komp_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_vand_komponent'		,'tapstedstype'							,'Tapstedstype'							,'{tapstedstype,tapst_type}'						,NULL		,'text'			,TRUE	,NULL			,-1		,NULL		,NULL				,NULL)
	,(TRUE	,3	,'ler_vand_komponent'		,'anborsted'							,'Anborsted'							,'{anborsted}'										,NULL		,'text'			,TRUE	,NULL			,-1		,NULL		,NULL				,NULL)
	,(TRUE	,4	,'ler_vand_komponent'		,'bundkote'								,'Bundkote'								,'{bundkote}'										,NULL		,'float'		,TRUE	,'min_max'		,0		,NULL		,NULL				,NULL)
	,(TRUE	,5	,'ler_vand_komponent'		,'stutskote'							,'Stutskote'							,'{stutskote}'										,NULL		,'float'		,TRUE	,'min_max'		,-1		,NULL		,NULL				,NULL)
	,(TRUE	,6	,'ler_vand_komponent'		,'topkote'								,'Topkote'								,'{topkote}'										,NULL		,'float'		,TRUE	,'min_max'		,0		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_anden_komponent'		,'forsyningsart'						,'Forsyningsart'						,'{forsyningsart,forsyn_art}'						,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_anden_komponent'		,'type'									,'Type'									,'{type,komp_type}'									,NULL		,'text'			,FALSE	,NULL			,1		,NULL		,NULL				,NULL)
	,(TRUE	,1	,'ler_omlagtfjernet'		,'gml_id'								,'GML ID'								,'{gml_id}'											,NULL		,'text'			,TRUE	,'no_control'	,1		,NULL		,NULL				,NULL)
	,(TRUE	,2	,'ler_omlagtfjernet'		,'objecttype'							,'Objekttype'							,'{objecttype}'										,NULL		,'text'			,TRUE	,'no_control'	,1		,NULL		,NULL				,NULL)
	,(FALSE	,3	,'ler_omlagtfjernet'		,'id'									,'ID'									,'{id}'												,NULL		,'text'			,TRUE	,'no_control'	,0		,NULL		,NULL				,NULL)
	,(TRUE	,4	,'ler_omlagtfjernet'		,'driftsstatus'							,'Driftsstatus'							,'{driftsstatus,driftsstat}'						,NULL		,'text'			,TRUE	,NULL			,-1		,NULL		,NULL				,NULL)


	,(TRUE	,1	,'generel_bemaerkning'		,'bemaerkning'							,'Bemærkning'							,'{bemaerkning,bemaerkn}'							,NULL		,'text'			,TRUE	,'no_control'	,0		,NULL		,NULL				,NULL)
;
-- */






/*

SELECT
	COUNT(*)
	,FORMAT(
$$WITH

	cte1(fid, pakke, navn, forsyningsart_incl_lst, default_value, opslagstabel, opslagstabel_filter, restriktion_sql, tooltip_html) AS(
		VALUES
			%s
	)

UPDATE sandbox.kontrol_lst_attributter k
	SET
		default_value = NULLIF(c.default_value, '')
		,opslagstabel = NULLIF(c.opslagstabel, '')
		,opslagstabel_filter = NULLIF(c.opslagstabel_filter, '')
		,restriktion_sql = NULLIF(c.restriktion_sql, '')
		,tooltip_html = NULLIF(c.tooltip_html, '')
FROM cte1 c
WHERE k.pakke = c.pakke
	AND k.navn = c.navn
	AND k.forsyningsart_incl_lst IS NOT DISTINCT FROM c.forsyningsart_incl_lst;$$

		,string_agg(
			FORMAT(
$BODY$(
				%L::integer
				,%L::text
				,%L::text
				,%L::text[]


-- default_value
,$$%s$$
-- opslagstabel
,$$%s$$
-- opslagstabel_filter
,$$%s$$
-- restriktion_sql
,$$%s$$
-- tooltip_html
,$$%s$$
			)$BODY$

				,a.fid
				,a.pakke
				,a.navn
				,a.forsyningsart_incl_lst
				,a.default_value
				,a.opslagstabel
				,a.opslagstabel_filter
				,a.restriktion_sql
				,a.tooltip_html
			)
			,E'\n\n\n\n\t\t\t,'
			ORDER BY p._order, a._order
		)
	)
FROM sandbox.kontrol_lst_attributter a
INNER JOIN sandbox.kontrol_lst_pakker p ON p.navn = a.pakke
WHERE default_value IS NOT NULL
	OR opslagstabel IS NOT NULL
	OR opslagstabel_filter IS NOT NULL
	OR restriktion_sql IS NOT NULL
	OR tooltip_html IS NOT NULL;

-- */

/*
WITH

	cte1(fid, pakke, navn, forsyningsart_incl_lst, default_value, opslagstabel, opslagstabel_filter, restriktion_sql, tooltip_html) AS(
		VALUES
			(
				'1'::integer
				,'ler_ledning_eller_trace'::text
				,'driftsstatus'::text
				,NULL::text[]


-- default_value
,$$i drift$$
-- opslagstabel
,$$ler_faelles_drifsstatus$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN etablering_foer_skaering IS FALSE
		AND [KOLONNE] = 'ukendt'
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Ukendt kun før skæringsdatoen</p>$$
			)



			,(
				'2'::integer
				,'ler_ledning_eller_trace'::text
				,'ejerskabsforhold'::text
				,NULL::text[]


-- default_value
,$$ejet af udleverende ledningsejer$$
-- opslagstabel
,$$ler_faelles_ejerskabsforhold$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'3'::integer
				,'ler_ledning_eller_trace'::text
				,'etableringstidspunkt'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$<p>Format: DD-MM-ÅÅÅÅ</p>
<br/>
<p>"før 1. juli 2023" kan også angives</p>$$
			)



			,(
				'4'::integer
				,'ler_ledning_eller_trace'::text
				,'fareklasse'::text
				,NULL::text[]


-- default_value
,$$ikke farlig$$
-- opslagstabel
,$$ler_faelles_fareklasse$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN etablering_foer_skaering IS FALSE
		AND [KOLONNE] = 'ukendt'
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Ukendt kun før skæringsdatoen</p>$$
			)



			,(
				'5'::integer
				,'ler_ledning_eller_trace'::text
				,'fareklasse'::text
				,'{tele,vand}'::text[]


-- default_value
,$$ikke farlig$$
-- opslagstabel
,$$ler_faelles_fareklasse$$
-- opslagstabel_filter
,$$type != 'meget farlig'$$
-- restriktion_sql
,$$CASE
	WHEN etablering_foer_skaering IS FALSE
		AND [KOLONNE] = 'ukendt'
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Ukendt kun før skæringsdatoen</p>$$
			)



			,(
				'6'::integer
				,'ler_ledning_eller_trace'::text
				,'fareklasse'::text
				,'{el,termisk,gas}'::text[]


-- default_value
,$$farlig$$
-- opslagstabel
,$$ler_faelles_fareklasse$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN etablering_foer_skaering IS FALSE
		AND [KOLONNE] = 'ukendt'
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Ukendt kun før skæringsdatoen</p>$$
			)



			,(
				'8'::integer
				,'ler_ledning_eller_trace'::text
				,'indtegningsmetode'::text
				,NULL::text[]


-- default_value
,$$nøjagtigt$$
-- opslagstabel
,$$ler_faelles_indtegningsmetode$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'9'::integer
				,'ler_ledning_eller_trace'::text
				,'noejagtighedsklasse'::text
				,NULL::text[]


-- default_value
,$$<= 0.25 m$$
-- opslagstabel
,$$ler_faelles_noejagtighedsklasse$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN etablering_foer_skaering IS FALSE
		AND [ejerskabsforhold] = 'ejet af udleverende ledningsejer'
		AND [KOLONNE] = 'ukendt'
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Ukendt kun før skæringsdatoen</p>$$
			)



			,(
				'11'::integer
				,'ler_ledning_eller_trace'::text
				,'sikkerhedshensyn'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 500
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 500 karakterer</p>$$
			)



			,(
				'13'::integer
				,'ler_ledning_eller_trace'::text
				,'vejledendedybde'::text
				,'{foeringsroer}'::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric < 0
	THEN FALSE
	WHEN etablering_foer_skaering IS FALSE
		AND z_99_count > 0
		AND [forsyningsart] IN('el', 'telekommunikation')
		AND [KOLONNE] IS NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt;= 0</p>
<br/>
<p>Skal være angivet, hvis følgende gælder:</p>
<ul>
<li>den primære forsyningsart er "el" eller "telekommunikation"</li>
<li>etableringstidspunktet er efter skæringsdatoen</li>
<li>de vertikale koordinater i geometrien er ukendt-værdien på -99</li>
</ul>$$
			)



			,(
				'14'::integer
				,'ler_ledning_eller_trace'::text
				,'vejledendedybde'::text
				,'{el,tele}'::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric < 0
	THEN FALSE
	WHEN etablering_foer_skaering IS FALSE
		AND z_99_count > 0
		AND [KOLONNE] IS NULL
	THEN FALSE
	WHEN etablering_foer_skaering IS FALSE
		AND [niveau] = 'under terræn'
		AND [KOLONNE] IS NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt;= 0</p>
<br/>
<p>Skal være angivet, hvis følgende gælder:</p>
<ul>
<li>etableringstidspunktet er efter skæringsdatoen</li>
<li>de vertikale koordinater i geometrien er ukendt-værdien på -99</li>
</ul>$$
			)



			,(
				'12'::integer
				,'ler_ledning_eller_trace'::text
				,'vejledendedybde'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric < 0
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt;= 0</p>$$
			)



			,(
				'17'::integer
				,'ler_ledning'::text
				,'niveau'::text
				,NULL::text[]


-- default_value
,$$under terræn$$
-- opslagstabel
,$$ler_faelles_niveau$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'19'::integer
				,'ler_ledning'::text
				,'ledningsetableringsmetode'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_ledning_etableringsmetode$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'22'::integer
				,'ler_ledning'::text
				,'udvendigdiameter'::text
				,'{el,tele}'::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= 0
	THEN FALSE
	WHEN etablering_foer_skaering IS FALSE
		AND [KOLONNE] IS NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt; 0</p>
<br/>
<p>Skal være angivet, hvis følgende gælder:</p>
<ul>
<li>etableringstidspunktet er efter skæringsdatoen</li>
</ul>$$
			)



			,(
				'21'::integer
				,'ler_ledning'::text
				,'udvendigdiameter'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= 0
	THEN FALSE
	WHEN [tvaersnitsform] IS NULL
	THEN TRUE
	WHEN etablering_foer_skaering IS FALSE
		AND [tvaersnitsform] = 'cirkulær'
		AND [KOLONNE] IS NULL
	THEN FALSE
	WHEN [tvaersnitsform] != 'cirkulær'
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt; 0</p>
<br/>
<p>Skal være angivet, hvis følgende gælder:</p>
<ul>
<li>etableringstidspunktet er efter skæringsdatoen</li>
<li>tværsnitsformen er "cirkulær"</li>
</ul>
<hr class="tooltip_break"/>
<b>MEN må ikke være angivet, hvis tværsnitsformen ikke er "cirkulær"</b>$$
			)



			,(
				'23'::integer
				,'ler_ledning'::text
				,'udvendigfarve'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 50
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 50 karakterer</p>$$
			)



			,(
				'24'::integer
				,'ler_ledning'::text
				,'udvendigmateriale'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 50
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 50 karakterer</p>$$
			)



			,(
				'28'::integer
				,'ler_komponent'::text
				,'driftsstatus'::text
				,NULL::text[]


-- default_value
,$$i drift$$
-- opslagstabel
,$$ler_faelles_drifsstatus$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'29'::integer
				,'ler_komponent'::text
				,'ejerskabsforhold'::text
				,NULL::text[]


-- default_value
,$$ejet af udleverende ledningsejer$$
-- opslagstabel
,$$ler_faelles_ejerskabsforhold$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'32'::integer
				,'ler_komponent'::text
				,'fareklasse'::text
				,'{el}'::text[]


-- default_value
,$$farlig$$
-- opslagstabel
,$$ler_faelles_fareklasse$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'31'::integer
				,'ler_komponent'::text
				,'fareklasse'::text
				,NULL::text[]


-- default_value
,$$ikke farlig$$
-- opslagstabel
,$$ler_faelles_fareklasse$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'34'::integer
				,'ler_komponent'::text
				,'materiale'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 50
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 50 karakterer</p>$$
			)



			,(
				'35'::integer
				,'ler_komponent'::text
				,'noejagtighedsklasse'::text
				,NULL::text[]


-- default_value
,$$<= 0.25 m$$
-- opslagstabel
,$$ler_faelles_noejagtighedsklasse$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'37'::integer
				,'ler_komponent'::text
				,'sikkerhedshensyn'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 500
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 500 karakterer</p>$$
			)



			,(
				'38'::integer
				,'ler_komponent'::text
				,'vejledendedybde'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric < 0
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt;= 0</p>$$
			)



			,(
				'41'::integer
				,'ler_komponent'::text
				,'niveau'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_faelles_niveau$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'43'::integer
				,'ler_roerledning'::text
				,'tvaersnitsform'::text
				,NULL::text[]


-- default_value
,$$cirkulær$$
-- opslagstabel
,$$ler_faelles_tvaersnitsform$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'44'::integer
				,'ler_roerledning'::text
				,'udvendigbredde'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= 0
	THEN FALSE
	WHEN etablering_foer_skaering IS FALSE
		AND [tvaersnitsform] != 'cirkulær'
		AND [KOLONNE] IS NULL
	THEN FALSE
	WHEN [tvaersnitsform] = 'cirkulær'
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt; 0</p>
<br/>
<p>Skal være angivet, hvis følgende gælder:</p>
<ul>
<li>etableringstidspunktet er efter skæringsdatoen</li>
<li>tværsnitsformen ikke er "cirkulær"</li>
</ul>
<hr class="tooltip_break"/>
<b>MEN må ikke være angivet, hvis tværsnitsformen er "cirkulær"</b>$$
			)



			,(
				'45'::integer
				,'ler_roerledning'::text
				,'udvendighoejde'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= 0
	THEN FALSE
	WHEN etablering_foer_skaering IS FALSE
		AND [tvaersnitsform] != 'cirkulær'
		AND [KOLONNE] IS NULL
	THEN FALSE
	WHEN [tvaersnitsform] = 'cirkulær'
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt; 0</p>
<br/>
<p>Skal være angivet, hvis følgende gælder:</p>
<ul>
<li>etableringstidspunktet er efter skæringsdatoen</li>
<li>tværsnitsformen ikke er "cirkulær"</li>
</ul>
<hr class="tooltip_break"/>
<b>MEN må ikke være angivet, hvis tværsnitsformen er "cirkulær"</b>$$
			)



			,(
				'46'::integer
				,'ler_foeringsroer'::text
				,'forsyningsart'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_faelles_forsyningsart$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'48'::integer
				,'ler_afloeb_ledning'::text
				,'harfod'::text
				,NULL::text[]


-- default_value
,$$nej$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'49'::integer
				,'ler_afloeb_ledning'::text
				,'ledningstransporttype'::text
				,NULL::text[]


-- default_value
,$$gravitation$$
-- opslagstabel
,$$ler_ledning_transporttype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'50'::integer
				,'ler_afloeb_ledning'::text
				,'medietype'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_afloeb_medietype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'72'::integer
				,'ler_afloeb_komponent'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_afloeb_komponenttype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'73'::integer
				,'ler_afloeb_komponent'::text
				,'broendform'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_afloeb_broendform$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN NOT(COALESCE([type], '') = 'brønd')
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Må kun være angivet, hvis typen er "brønd"</p>$$
			)



			,(
				'74'::integer
				,'ler_afloeb_komponent'::text
				,'bunddiameterbredde'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= 0
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt; 0</p>$$
			)



			,(
				'75'::integer
				,'ler_afloeb_komponent'::text
				,'bundlaengde'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= 0
	THEN FALSE
	WHEN NOT(
			COALESCE([type], '') = 'brønd'
			AND COALESCE([broendform], '') IN('kvadratisk', 'rektangulær')
		)
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt; 0</p>
<br/>
<p>Må kun være angivet, hvis følgende gælder:</p>
<ul>
<li>typen er "brønd"</li>
<li>brøndformen er "kvadratisk" eller "rektangulær"</li>
</ul>$$
			)



			,(
				'76'::integer
				,'ler_afloeb_komponent'::text
				,'bundkote'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= -99
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Ved ukendt må værdien -99 ikke benyttes</p>$$
			)



			,(
				'77'::integer
				,'ler_afloeb_komponent'::text
				,'medietype'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_afloeb_medietype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'78'::integer
				,'ler_afloeb_komponent'::text
				,'topkote'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= -99
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Ved ukendt må værdien -99 ikke benyttes</p>$$
			)



			,(
				'51'::integer
				,'ler_el_ledning'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_el_ledningstype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'52'::integer
				,'ler_el_ledning'::text
				,'afdaekning'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 50
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 50 karakterer</p>
<br/>
<p>Eksempelvis mursten, halve flange rør, markeringsbånd, dækbånd</p>$$
			)



			,(
				'53'::integer
				,'ler_el_ledning'::text
				,'antalkabler'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= 0
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt; 0</p>$$
			)



			,(
				'54'::integer
				,'ler_el_ledning'::text
				,'kabeltype'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 50
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 50 karakterer</p>$$
			)



			,(
				'79'::integer
				,'ler_el_komponent'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_el_komponenttype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'80'::integer
				,'ler_el_komponent'::text
				,'relativniveau'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_el_relativ_niveau$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN NOT(COALESCE([type], '') = 'rørblok')
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Må kun være angivet, hvis typen er "rørblok"</p>$$
			)



			,(
				'56'::integer
				,'ler_termisk_ledning'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_termisk_ledningstype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'57'::integer
				,'ler_termisk_ledning'::text
				,'indhold'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_termisk_indholdstype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'58'::integer
				,'ler_termisk_ledning'::text
				,'konstruktion'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_termisk_konstruktiontype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'82'::integer
				,'ler_termisk_komponent'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_termisk_komponenttype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'61'::integer
				,'ler_gas_ledning'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_gas_ledningstype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'63'::integer
				,'ler_gas_ledning'::text
				,'medietype'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_gas_medietype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'83'::integer
				,'ler_gas_komponent'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_gas_komponenttype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'84'::integer
				,'ler_gas_komponent'::text
				,'topkote'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= -99
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Ved ukendt må værdien -99 ikke benyttes</p>$$
			)



			,(
				'65'::integer
				,'ler_olie_ledning'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 50
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 50 karakterer</p>$$
			)



			,(
				'85'::integer
				,'ler_olie_komponent'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 50
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 50 karakterer</p>$$
			)



			,(
				'66'::integer
				,'ler_tele_ledning'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_tele_ledningstype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'86'::integer
				,'ler_tele_komponent'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_tele_komponenttype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'87'::integer
				,'ler_vand_komponent'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_vand_komponenttype$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'88'::integer
				,'ler_vand_komponent'::text
				,'tapstedstype'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_vand_tapsted$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN NOT(COALESCE([type], '') = 'tapsted')
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Må kun være angivet, hvis typen er "tapsted"</p>$$
			)



			,(
				'89'::integer
				,'ler_vand_komponent'::text
				,'anborsted'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_vand_anborsted$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN NOT(COALESCE([type], '') = 'tilslutningspunkt')
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Må kun være angivet, hvis typen er "tilslutningspunkt"</p>$$
			)



			,(
				'90'::integer
				,'ler_vand_komponent'::text
				,'bundkote'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= -99
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Ved ukendt må værdien -99 ikke benyttes</p>$$
			)



			,(
				'91'::integer
				,'ler_vand_komponent'::text
				,'stutskote'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= -99
	THEN FALSE
	WHEN NOT(COALESCE([type], '') IN('tapsted', 'ventil'))
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Må kun være angivet, hvis typen er "tapsted" eller "ventil"</p>$$
			)



			,(
				'92'::integer
				,'ler_vand_komponent'::text
				,'topkote'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= -99
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Ved ukendt må værdien -99 ikke benyttes</p>$$
			)



			,(
				'67'::integer
				,'ler_anden_ledning'::text
				,'forsyningsart'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_faelles_forsyningsart$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN NOT([KOLONNE] ~* '^other: ')
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Forsyningsarten må ikke være en af de prædefinerede værdier fra kodelisten Forsyningsart. Note: Hvis man har behov for at afgive oplysninger om en ledning som har en forsyningsart som er prædefineret i kodelisten Forsyningsart, så skal man i stedet for AndenLedning bruge den subklasse af Ledning som hører til den forsyningsart. Fx Telekommunikationsledning for forsyningsarten telekommunikation.</p>$$
			)



			,(
				'68'::integer
				,'ler_anden_ledning'::text
				,'tvaersnitsform'::text
				,NULL::text[]


-- default_value
,$$cirkulær$$
-- opslagstabel
,$$ler_faelles_tvaersnitsform$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$$$
-- tooltip_html
,$$$$
			)



			,(
				'69'::integer
				,'ler_anden_ledning'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 50
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 50 karakterer</p>$$
			)



			,(
				'70'::integer
				,'ler_anden_ledning'::text
				,'udvendigbredde'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= 0
	THEN FALSE
	WHEN etablering_foer_skaering IS FALSE
		AND [tvaersnitsform] != 'cirkulær'
		AND [KOLONNE] IS NULL
	THEN FALSE
	WHEN [tvaersnitsform] = 'cirkulær'
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt; 0</p>
<br/>
<p>Skal være angivet, hvis følgende gælder:</p>
<ul>
<li>etableringstidspunktet er efter skæringsdatoen</li>
<li>tværsnitsformen ikke er "cirkulær"</li>
</ul>
<hr class="tooltip_break"/>
<b>MEN må ikke være angivet, hvis tværsnitsformen er "cirkulær"</b>$$
			)



			,(
				'71'::integer
				,'ler_anden_ledning'::text
				,'udvendighoejde'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN [KOLONNE]::numeric <= 0
	THEN FALSE
	WHEN etablering_foer_skaering IS FALSE
		AND [tvaersnitsform] != 'cirkulær'
		AND [KOLONNE] IS NULL
	THEN FALSE
	WHEN [tvaersnitsform] = 'cirkulær'
		AND [KOLONNE] IS NOT NULL
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Skal være &gt; 0</p>
<br/>
<p>Skal være angivet, hvis følgende gælder:</p>
<ul>
<li>etableringstidspunktet er efter skæringsdatoen</li>
<li>tværsnitsformen ikke er "cirkulær"</li>
</ul>
<hr class="tooltip_break"/>
<b>MEN må ikke være angivet, hvis tværsnitsformen er "cirkulær"</b>$$
			)



			,(
				'93'::integer
				,'ler_anden_komponent'::text
				,'forsyningsart'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$ler_faelles_forsyningsart$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN NOT([KOLONNE] ~* '^other: ')
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Forsyningsarten må ikke være en af de prædefinerede værdier fra kodelisten Forsyningsart. Note: Hvis man har behov for at afgive oplysninger om en ledning som har en forsyningsart som er prædefineret i kodelisten Forsyningsart, så skal man i stedet for AndenLedning bruge den subklasse af Ledning som hører til den forsyningsart. Fx Telekommunikationsledning for forsyningsarten telekommunikation.</p>$$
			)



			,(
				'94'::integer
				,'ler_anden_komponent'::text
				,'type'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 50
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 50 karakterer</p>$$
			)



			,(
				'47'::integer
				,'ler_ukendt_ledning'::text
				,'supplerendeinfo'::text
				,NULL::text[]


-- default_value
,$$$$
-- opslagstabel
,$$$$
-- opslagstabel_filter
,$$$$
-- restriktion_sql
,$$CASE
	WHEN LENGTH([KOLONNE]) > 500
	THEN FALSE
END$$
-- tooltip_html
,$$<p>Maks 500 karakterer</p>$$
			)
	)

UPDATE sandbox.kontrol_lst_attributter k
	SET
		default_value = NULLIF(c.default_value, '')
		,opslagstabel = NULLIF(c.opslagstabel, '')
		,opslagstabel_filter = NULLIF(c.opslagstabel_filter, '')
		,restriktion_sql = NULLIF(c.restriktion_sql, '')
		,tooltip_html = NULLIF(c.tooltip_html, '')
FROM cte1 c
WHERE k.pakke = c.pakke
	AND k.navn = c.navn
	AND k.forsyningsart_incl_lst IS NOT DISTINCT FROM c.forsyningsart_incl_lst;
-- */

