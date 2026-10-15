-- TRUNCATE sandbox.kontrol_fme_attributter_exclude RESTART IDENTITY;
INSERT INTO sandbox.kontrol_fme_attributter_exclude(
	  aktiv	,navn	,beskrivelse
) VALUES
	 (true	,'fid'	,'Undgå autogenererede ID''er fra importeret data (GeoPackage)')
	,(true	,'id'	,'Undgå autogenererede ID''er fra importeret data (Shape)')
;




-- TRUNCATE sandbox.kontrol_fme_filtyper RESTART IDENTITY;
INSERT INTO sandbox.kontrol_fme_filtyper(
	  aktiv	,navn	,navn_pretty	,navn_lst										,beskrivelse
) VALUES
	 (true	,'shp'	,'Shape'		,'{shp,dbf,cpg,prj,shx,qmd,idx,qix}'::text[]	,NULL)
	,(true	,'gpkg'	,'GeoPackage'	,'{gpkg}'::text[]								,NULL)
;




-- TRUNCATE sandbox.kontrol_lst_ja_nej RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_ja_nej(
	  fid	,aktiv	,navn	,navn_pretty	,beskrivelse
) VALUES
	 (0		,true	,'nej'	,'Nej'			,NULL)
	,(1		,true	,'ja'	,'Ja'			,NULL)
;




-- TRUNCATE sandbox.kontrol_lst_fejl RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_fejl(
	  fid	,aktiv	,navn	,navn_pretty	,beskrivelse	,fejl_type
) VALUES
	 (1		,true	,1		,'Fejl'			,NULL			,'error')
	,(2		,true	,0		,'Ok'			,NULL			,NULL)
	,(3		,true	,-1		,'Obs'			,NULL			,'obs')
;




-- TRUNCATE sandbox.kontrol_lst_srid RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_srid(
	  aktiv	,navn	,navn_pretty	,navn_lst					,beskrivelse
) VALUES
	 (true	,25832	,'EPSG:25832'	,'{25832}'::integer[]		,NULL)
	,(true	,4095	,'EPSG:4095'	,'{4095,4099}'::integer[]	,NULL)
;




-- TRUNCATE sandbox.kontrol_lst_dimensioner RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_dimensioner(
	  aktiv	,navn	,navn_pretty	,beskrivelse	,zm_flag
) VALUES
	 (true	,'2d'	,'2D'			,NULL			,0)
	,(true	,'3d_m'	,'3D-M'			,NULL			,1)
	,(true	,'3d_z'	,'3D-Z'			,NULL			,2)
	,(true	,'4d'	,'4D'			,NULL			,3)
;




-- TRUNCATE sandbox.kontrol_lst_snap RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_snap(
	  aktiv	,_order	,navn			,navn_pretty		,beskrivelse	,color_hex	,fejl
) VALUES
	 (true	,3		,'snapped'		,'Snapped'			,NULL			,'#07a925'	,0)
	,(true	,2		,'asSnapped'	,'Tilnærmet snap'	,NULL			,'#9ba907'	,0)
	,(true	,1		,'noSnap'		,'Ingen snap'		,NULL			,'#fdc942'	,-1)
;




-- TRUNCATE sandbox.kontrol_lst_systemer RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_systemer(
	  aktiv	,_order	,navn	,navn_pretty	,navn_lst					,beskrivelse
) VALUES
	 (true	,-1	,'ler'	,'LER'				,'{ler,bilag2_1}'::text[]	,NULL)
;

INSERT INTO sandbox.kontrol_lst_systemer(
	  aktiv	,_order	,navn	,navn_pretty	,navn_lst							,beskrivelse
) VALUES
	 (true	,1	,'kkafloeb'	,'KK Afløb'		,'{kkafloeb,afl,bilag2_2}'::text[]	,NULL)
;




-- TRUNCATE sandbox.kontrol_lst_forsyningsarter RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_forsyningsarter(
	  aktiv	,_order	,navn				,navn_pretty			,navn_lst																,beskrivelse	,color_hex
) VALUES
	 (true	,1		,'foeringsroer'		,'Føringsrør'			,'{foeringsroer,foeringsror,foringsroer,føringsrør,foringsror}'::text[]	,NULL			,'#f5a27a')
	,(true	,11		,'afloeb'			,'Afløb'				,'{afloeb,afløb,aflob}'::text[]											,NULL			,'#693d07')
	,(true	,12		,'el'				,'El'					,'{el}'::text[]															,NULL			,'#d73027')
	,(true	,13		,'termisk'			,'Termisk'				,'{termisk}'::text[]													,NULL			,'#d957f9')
	,(true	,14		,'gas'				,'Gas'					,'{gas}'::text[]														,NULL			,'#e9af00')
	,(true	,15		,'olie'				,'Olie'					,'{olie}'::text[]														,NULL			,'#000000')
	,(true	,16		,'tele'				,'Telekommunikation'	,'{tele,telekom,telekommunikation}'::text[]								,NULL			,'#009900')
	,(true	,17		,'vand'				,'Vand'					,'{vand}'::text[]														,NULL			,'#0070ff')
	,(true	,18		,'anden'			,'Anden'				,'{anden,andet}'::text[]												,NULL			,'#00ceb3')
	,(true	,98		,'ukendt'			,'Ukendt'				,'{ukendt}'::text[]														,NULL			,'#ff5500')
	,(true	,99		,'omlagtfjernet'	,'Omlagt/Fjernet'		,'{omlagtfjernet}'::text[]												,NULL			,'#9e9e9e')
;




-- TRUNCATE sandbox.kontrol_lst_grupper RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_grupper(
	  aktiv	,_order	,navn			,navn_pretty	,navn_lst							,beskrivelse
) VALUES
	 (true	,-1		,'snap'			,'Snap'			,'{snap}'::text[]					,NULL)
	,(true	,1		,'ledning'		,'Ledning'		,'{ledning,ledninger}'::text[]		,NULL)
	,(true	,3		,'komponent'	,'Komponent'	,'{komponent,komponenter}'::text[]	,NULL)
;

INSERT INTO sandbox.kontrol_lst_grupper(
	  aktiv	,_order	,navn			,navn_pretty	,navn_lst							,beskrivelse
) VALUES
	 (true	,2		,'knude'		,'Knude'		,'{knude,kn,knuder}'::text[]			,NULL)
	,(true	,2		,'konstr'		,'Konstruktion'	,'{konstr,konstruktion,kons}'::text[]	,NULL)
;




-- TRUNCATE sandbox.kontrol_lst_geometrityper RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_geometrityper(
	  aktiv	,_order	,navn			,navn_pretty			,navn_lst											,beskrivelse	,pg_geometritype		,navn_short
) VALUES
	 (true	,1		,'Point'		,'Punkt'				,'{punkt,punkter,pkt,pt,pts}'::text[]				,NULL			,'POINT'				,'Pkt.')
	,(true	,2		,'Line'			,'Linje'				,'{linje,linjer,linier,linie,li}'::text[]			,NULL			,'LINESTRING'			,'Li.')
	,(true	,3		,'Polygon'		,'Polygon'				,'{polygon,polygoner,flader,flade,poly,fl}'::text[]	,NULL			,'POLYGON'				,'Fl.')
	,(true	,99		,'collection'	,'Kompleks geometri'	,'{collection}'::text[]								,NULL			,'GEOMETRYCOLLECTION'	,'Kompl.')
;




-- TRUNCATE sandbox.kontrol_lst_eksisterende RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_eksisterende(
	  aktiv	,navn								,navn_pretty									,beskrivelse	,system	,forsyningsart	,gruppe			,geometritype	,tabel_skema	,tabel_navn															,tabel_geom	,tabel_filter
) VALUES
	 (true	,'ler_foeringsroer_ledning_linje'	,'LER, Føringsrør'								,NULL			,'ler'	,'foeringsroer'	,'ledning'		,'Line'			,'ler20'		,'foeringsroer_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'			,'geometri'	,NULL)
	,(true	,'ler_afloeb_ledning_linje'			,'LER, Afløbsledning'							,NULL			,'ler'	,'afloeb'		,'ledning'		,'Line'			,'ler20'		,'afloeb_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_afloeb_komponent_punkt'		,'LER, Afløbskomponent, Punkt'					,NULL			,'ler'	,'afloeb'		,'komponent'	,'Point'		,'ler20'		,'afloeb_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_afloeb_komponent_linje'		,'LER, Afløbskomponent, Linje'					,NULL			,'ler'	,'afloeb'		,'komponent'	,'Line'			,'ler20'		,'afloeb_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_afloeb_komponent_polygon'		,'LER, Afløbskomponent, Polygon'				,NULL			,'ler'	,'afloeb'		,'komponent'	,'Polygon'		,'ler20'		,'afloeb_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'			,'geometri'	,NULL)
	,(true	,'ler_el_ledning_linje'				,'LER, Elledning'								,NULL			,'ler'	,'el'			,'ledning'		,'Line'			,'ler20'		,'el_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(true	,'ler_el_komponent_punkt'			,'LER, Elkomponent, Punkt'						,NULL			,'ler'	,'el'			,'komponent'	,'Point'		,'ler20'		,'el_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(true	,'ler_el_komponent_linje'			,'LER, Elkomponent, Linje'						,NULL			,'ler'	,'el'			,'komponent'	,'Line'			,'ler20'		,'el_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(true	,'ler_el_komponent_polygon'			,'LER, Elkomponent, Polygon'					,NULL			,'ler'	,'el'			,'komponent'	,'Polygon'		,'ler20'		,'el_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_termisk_ledning_linje'		,'LER, Termisk ledning'							,NULL			,'ler'	,'termisk'		,'ledning'		,'Line'			,'ler20'		,'termisk_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_termisk_komponent_punkt'		,'LER, Termisk komponent, Punkt'				,NULL			,'ler'	,'termisk'		,'komponent'	,'Point'		,'ler20'		,'termisk_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_termisk_komponent_linje'		,'LER, Termisk komponent, Linje'				,NULL			,'ler'	,'termisk'		,'komponent'	,'Line'			,'ler20'		,'termisk_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_termisk_komponent_polygon'	,'LER, Termisk komponent, Polygon'				,NULL			,'ler'	,'termisk'		,'komponent'	,'Polygon'		,'ler20'		,'termisk_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'			,'geometri'	,NULL)
	,(true	,'ler_gas_ledning_linje'			,'LER, Gasledning'								,NULL			,'ler'	,'gas'			,'ledning'		,'Line'			,'ler20'		,'gas_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(true	,'ler_gas_komponent_punkt'			,'LER, Gaskomponent, Punkt'						,NULL			,'ler'	,'gas'			,'komponent'	,'Point'		,'ler20'		,'gas_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(true	,'ler_gas_komponent_linje'			,'LER, Gaskomponent, Linje'						,NULL			,'ler'	,'gas'			,'komponent'	,'Line'			,'ler20'		,'gas_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(true	,'ler_gas_komponent_polygon'		,'LER, Gaskomponent, Polygon'					,NULL			,'ler'	,'gas'			,'komponent'	,'Polygon'		,'ler20'		,'gas_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_olie_ledning_linje'			,'LER, Olieledning'								,NULL			,'ler'	,'olie'			,'ledning'		,'Line'			,'ler20'		,'olie_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(true	,'ler_olie_komponent_punkt'			,'LER, Oliekomponent, Punkt'					,NULL			,'ler'	,'olie'			,'komponent'	,'Point'		,'ler20'		,'olie_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_olie_komponent_linje'			,'LER, Oliekomponent, Linje'					,NULL			,'ler'	,'olie'			,'komponent'	,'Line'			,'ler20'		,'olie_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_olie_komponent_polygon'		,'LER, Oliekomponent, Polygon'					,NULL			,'ler'	,'olie'			,'komponent'	,'Polygon'		,'ler20'		,'olie_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_tele_ledning_linje'			,'LER, Telekommunikation ledning'				,NULL			,'ler'	,'tele'			,'ledning'		,'Line'			,'ler20'		,'telekommunikation_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'		,'geometri'	,NULL)
	,(true	,'ler_tele_komponent_punkt'			,'LER, Telekommunikation komponent, Punkt'		,NULL			,'ler'	,'tele'			,'komponent'	,'Point'		,'ler20'		,'telekommunikation_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'	,'geometri'	,NULL)
	,(true	,'ler_tele_komponent_linje'			,'LER, Telekommunikation komponent, Linje'		,NULL			,'ler'	,'tele'			,'komponent'	,'Line'			,'ler20'		,'telekommunikation_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'	,'geometri'	,NULL)
	,(true	,'ler_tele_komponent_polygon'		,'LER, Telekommunikation komponent, Polygon'	,NULL			,'ler'	,'tele'			,'komponent'	,'Polygon'		,'ler20'		,'telekommunikation_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'	,'geometri'	,NULL)
	,(true	,'ler_vand_ledning_linje'			,'LER, Vandledning'								,NULL			,'ler'	,'vand'			,'ledning'		,'Line'			,'ler20'		,'vand_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(true	,'ler_vand_komponent_punkt'			,'LER, Vandkomponent, Punkt'					,NULL			,'ler'	,'vand'			,'komponent'	,'Point'		,'ler20'		,'vand_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_vand_komponent_linje'			,'LER, Vandkomponent, Linje'					,NULL			,'ler'	,'vand'			,'komponent'	,'Line'			,'ler20'		,'vand_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_vand_komponent_polygon'		,'LER, Vandkomponent, Polygon'					,NULL			,'ler'	,'vand'			,'komponent'	,'Polygon'		,'ler20'		,'vand_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_anden_ledning_linje'			,'LER, Anden ledning'							,NULL			,'ler'	,'anden'		,'ledning'		,'Line'			,'ler20'		,'anden_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'					,'geometri'	,NULL)
	,(true	,'ler_anden_komponent_punkt'		,'LER, Anden komponent, Punkt'					,NULL			,'ler'	,'anden'		,'komponent'	,'Point'		,'ler20'		,'anden_komponent_punkt([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_anden_komponent_linje'		,'LER, Anden komponent, Linje'					,NULL			,'ler'	,'anden'		,'komponent'	,'Line'			,'ler20'		,'anden_komponent_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_anden_komponent_polygon'		,'LER, Anden komponent, Polygon'				,NULL			,'ler'	,'anden'		,'komponent'	,'Polygon'		,'ler20'		,'anden_komponent_polygon([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
	,(true	,'ler_ukendt_ledning_linje'			,'LER, Ukendt ledning'							,NULL			,'ler'	,'ukendt'		,'ledning'		,'Line'			,'ler20'		,'ukendt_ledning_linje([XMIN],[YMIN],[XMAX],[YMAX])'				,'geometri'	,NULL)
;

INSERT INTO sandbox.kontrol_lst_eksisterende(
	  aktiv	,navn								,navn_pretty								,beskrivelse	,system		,forsyningsart	,gruppe			,geometritype	,tabel_skema	,tabel_navn															,tabel_geom	,tabel_filter
) VALUES
	 (true	,'kkafloeb_afloeb_ledning_linje'	,'KK Afløb, Afløbsledning'					,NULL			,'kkafloeb'	,'afloeb'		,'ledning'		,'Line'			,'aflob'		,'f_ledninger_l'													,'geom'	,$$geom && ST_SetSRID(ST_MakeBox2D(ST_MakePoint([XMIN], [YMIN]),ST_MakePoint([XMAX],[YMAX])),25832) AND status IS DISTINCT FROM 'Fjernet' AND ledning_type IN('Ledning')$$)
	,(true	,'kkafloeb_afloeb_knude_punkt'		,'KK Afløb, Knuder'							,NULL			,'kkafloeb'	,'afloeb'		,'knude'		,'Point'		,'aflob'		,'f_knuder_p'														,'geom'	,$$geom && ST_SetSRID(ST_MakeBox2D(ST_MakePoint([XMIN], [YMIN]),ST_MakePoint([XMAX],[YMAX])),25832) AND status IS DISTINCT FROM 'Fjernet' AND knude_type IN('Brønd')$$)
	,(true	,'kkafloeb_afloeb_konstr_punkt'		,'KK Afløb, Konstruktioner, Punkt'			,NULL			,'kkafloeb'	,'afloeb'		,'konstr'		,'Point'		,'aflob'		,'f_konstruktioner'													,'geom'	,$$geom && ST_SetSRID(ST_MakeBox2D(ST_MakePoint([XMIN], [YMIN]),ST_MakePoint([XMAX],[YMAX])),25832) AND status IS DISTINCT FROM 'Fjernet' AND geometri_type = 'ST_Point'		 AND konstruktion_type IN('Sandfang', 'Bassin')$$)
	,(true	,'kkafloeb_afloeb_konstr_linje'		,'KK Afløb, Konstruktioner, Linje'			,NULL			,'kkafloeb'	,'afloeb'		,'konstr'		,'Line'			,'aflob'		,'f_konstruktioner'													,'geom'	,$$geom && ST_SetSRID(ST_MakeBox2D(ST_MakePoint([XMIN], [YMIN]),ST_MakePoint([XMAX],[YMAX])),25832) AND status IS DISTINCT FROM 'Fjernet' AND geometri_type = 'ST_LineString'	 AND konstruktion_type IN('Sandfang', 'Bassin')$$)
	,(true	,'kkafloeb_afloeb_konstr_polygon'	,'KK Afløb, Konstruktioner, Polygon'		,NULL			,'kkafloeb'	,'afloeb'		,'konstr'		,'Polygon'		,'aflob'		,'f_konstruktioner'													,'geom'	,$$geom && ST_SetSRID(ST_MakeBox2D(ST_MakePoint([XMIN], [YMIN]),ST_MakePoint([XMAX],[YMAX])),25832) AND status IS DISTINCT FROM 'Fjernet' AND geometri_type = 'ST_Polygon'		 AND konstruktion_type IN('Sandfang', 'Bassin')$$)
;




-- TRUNCATE sandbox.kontrol_lst_featuretyper RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_featuretyper(
	  aktiv	,_order	,navn									,navn_pretty					,navn_lst		,beskrivelse	,system		,forsyningsart		,gruppe			,geometrityper_lst					,dimension	,group_column		,etablering_column		,etablering_skaering	,snap_kontrol	,snap_kontrol_geometrityper_lst	,snap_reference	,snap_reference_geometrityper_lst	,pakker_lst
) VALUES
	 (true	,1		,'ler_foeringsroer_ledning'				,'Føringsrør'					,NULL::text[]	,NULL			,'ler'		,'foeringsroer'		,'ledning'		,'{Line}'::text[]					,'3d_z'		,'forsyningsart'	,'etableringstidspunkt'	,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{ler_ledning_eller_trace,ler_ledning,ler_generel_bemaerkning,ler_roerledning,ler_foeringsroer}'::text[])
	,(true	,1		,'ler_ukendt_ledning'					,'Ukendt ledning'				,NULL::text[]	,NULL			,'ler'		,'ukendt'			,'ledning'		,'{Line}'::text[]					,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{ler_ledning_eller_trace,ler_ledning,ler_generel_bemaerkning,ler_ukendt_ledning}'::text[])
	,(true	,1		,'ler_afloeb_ledning'					,'Afløbsledning'				,NULL::text[]	,NULL			,'ler'		,'afloeb'			,'ledning'		,'{Line}'::text[]					,'3d_z'		,'medietype'		,'etableringstidspunkt'	,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{ler_ledning_eller_trace,ler_ledning,ler_generel_bemaerkning,ler_roerledning,ler_afloeb_ledning}'::text[])
	,(true	,2		,'ler_afloeb_komponent'					,'Afløbskomponent'				,NULL::text[]	,NULL			,'ler'		,'afloeb'			,'komponent'	,'{Line,Polygon,Point}'::text[]	,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,'{Point}'::text[]				,true			,NULL::text[]						,'{ler_komponent,ler_generel_bemaerkning,ler_afloeb_komponent}'::text[])
	,(true	,1		,'ler_el_ledning'						,'Elledning'					,NULL::text[]	,NULL			,'ler'		,'el'				,'ledning'		,'{Line}'::text[]					,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{ler_ledning_eller_trace,ler_ledning,ler_generel_bemaerkning,ler_el_ledning}'::text[])
	,(true	,2		,'ler_el_komponent'						,'Elkomponent'					,NULL::text[]	,NULL			,'ler'		,'el'				,'komponent'	,'{Line,Polygon,Point}'::text[]	,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,'{Point}'::text[]				,true			,NULL::text[]						,'{ler_komponent,ler_generel_bemaerkning,ler_el_komponent}'::text[])
	,(true	,1		,'ler_termisk_ledning'					,'Termisk ledning'				,NULL::text[]	,NULL			,'ler'		,'termisk'			,'ledning'		,'{Line}'::text[]					,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{ler_ledning_eller_trace,ler_ledning,ler_generel_bemaerkning,ler_roerledning,ler_termisk_ledning}'::text[])
	,(true	,2		,'ler_termisk_komponent'				,'Termisk komponent'			,NULL::text[]	,NULL			,'ler'		,'termisk'			,'komponent'	,'{Line,Polygon,Point}'::text[]	,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,'{Point}'::text[]				,true			,NULL::text[]						,'{ler_komponent,ler_generel_bemaerkning,ler_termisk_komponent}'::text[])
	,(true	,1		,'ler_gas_ledning'						,'Gasledning'					,NULL::text[]	,NULL			,'ler'		,'gas'				,'ledning'		,'{Line}'::text[]					,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{ler_ledning_eller_trace,ler_ledning,ler_generel_bemaerkning,ler_roerledning,ler_gas_ledning}'::text[])
	,(true	,2		,'ler_gas_komponent'					,'Gaskomponent'					,NULL::text[]	,NULL			,'ler'		,'gas'				,'komponent'	,'{Line,Polygon,Point}'::text[]	,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,'{Point}'::text[]				,true			,NULL::text[]						,'{ler_komponent,ler_generel_bemaerkning,ler_gas_komponent}'::text[])
	,(true	,1		,'ler_olie_ledning'						,'Olieledning'					,NULL::text[]	,NULL			,'ler'		,'olie'				,'ledning'		,'{Line}'::text[]					,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{ler_ledning_eller_trace,ler_ledning,ler_generel_bemaerkning,ler_roerledning,ler_olie_ledning}'::text[])
	,(true	,2		,'ler_olie_komponent'					,'Oliekomponent'				,NULL::text[]	,NULL			,'ler'		,'olie'				,'komponent'	,'{Line,Polygon,Point}'::text[]	,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,'{Point}'::text[]				,true			,NULL::text[]						,'{ler_komponent,ler_generel_bemaerkning,ler_olie_komponent}'::text[])
	,(true	,1		,'ler_tele_ledning'						,'Telekommunikationsledning'	,NULL::text[]	,NULL			,'ler'		,'tele'				,'ledning'		,'{Line}'::text[]					,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{ler_ledning_eller_trace,ler_ledning,ler_generel_bemaerkning,ler_tele_ledning}'::text[])
	,(true	,2		,'ler_tele_komponent'					,'Telekommunikationskomponent'	,NULL::text[]	,NULL			,'ler'		,'tele'				,'komponent'	,'{Line,Polygon,Point}'::text[]	,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,'{Point}'::text[]				,true			,NULL::text[]						,'{ler_komponent,ler_generel_bemaerkning,ler_tele_komponent}'::text[])
	,(true	,1		,'ler_vand_ledning'						,'Vandledning'					,NULL::text[]	,NULL			,'ler'		,'vand'				,'ledning'		,'{Line}'::text[]					,'3d_z'		,NULL				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{ler_ledning_eller_trace,ler_ledning,ler_generel_bemaerkning,ler_roerledning}'::text[])
	,(true	,2		,'ler_vand_komponent'					,'Vandkomponent'				,NULL::text[]	,NULL			,'ler'		,'vand'				,'komponent'	,'{Line,Polygon,Point}'::text[]	,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,'{Point}'::text[]				,true			,NULL::text[]						,'{ler_komponent,ler_generel_bemaerkning,ler_vand_komponent}'::text[])
	,(true	,1		,'ler_anden_ledning'					,'Anden ledning'				,NULL::text[]	,NULL			,'ler'		,'anden'			,'ledning'		,'{Line}'::text[]					,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{ler_ledning_eller_trace,ler_ledning,ler_generel_bemaerkning,ler_anden_ledning}'::text[])
	,(true	,2		,'ler_anden_komponent'					,'Anden komponent'				,NULL::text[]	,NULL			,'ler'		,'anden'			,'komponent'	,'{Line,Polygon,Point}'::text[]	,'3d_z'		,'type'				,'etableringstidspunkt'	,'2023-07-01'::date		,true			,'{Point}'::text[]				,true			,NULL::text[]						,'{ler_komponent,ler_generel_bemaerkning,ler_anden_komponent}'::text[])
	,(true	,1		,'ler_omlagtfjernet_ledning'			,'Omlagt/Fjernet ledning'		,NULL::text[]	,NULL			,'ler'		,'omlagtfjernet'	,'ledning'		,'{Line}'::text[]					,'2d'		,NULL				,NULL					,NULL::date				,false			,NULL::text[]					,false			,NULL::text[]						,'{ler_omlagtfjernet}'::text[])
	,(true	,2		,'ler_omlagtfjernet_komponent'			,'Omlagt/Fjernet komponent'		,NULL::text[]	,NULL			,'ler'		,'omlagtfjernet'	,'komponent'	,'{Point,Line,Polygon}'::text[]	,'2d'		,NULL				,NULL					,NULL::date				,false			,NULL::text[]					,false			,NULL::text[]						,'{ler_omlagtfjernet}'::text[])
;

INSERT INTO sandbox.kontrol_lst_featuretyper(
	  aktiv	,_order	,navn									,navn_pretty								,navn_lst													,beskrivelse	,system		,forsyningsart		,gruppe			,geometrityper_lst					,dimension	,group_column			,etablering_column		,etablering_skaering	,snap_kontrol	,snap_kontrol_geometrityper_lst	,snap_reference	,snap_reference_geometrityper_lst	,pakker_lst
) VALUES
	 (true	,0		,'kkafloeb_afloeb_ledning'				,'Ledning'									,NULL::text[]												,NULL			,'kkafloeb'	,'afloeb'			,'ledning'		,'{Line}'::text[]					,'3d_z'		,'ledning_type'			,'datoetableret'		,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,/*'{
																																																																																																																	kkafloeb_afloeb_ledning_type
																																																																																																																	,kkafloeb_afloeb_ledning_linie
																																																																																																																	,kkafloeb_afloeb_ledning_generel_etablering
																																																																																																																	,kkafloeb_afloeb_ledning_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_ledning_generel_ler
																																																																																																																	,kkafloeb_afloeb_ledning_ledning
																																																																																																																	,kkafloeb_afloeb_ledning_roer
																																																																																																																	,kkafloeb_afloeb_klimatilp
																																																																																																																}'*/'{kkafloeb_afloeb_ledning_type}'::text[])

	,(true	,1		,'kkafloeb_afloeb_ledning_ledn'			,'Almindelig ledning'						,'{ledn,Ledning}'::text[]									,NULL			,'kkafloeb'	,'afloeb'			,'ledning'		,'{Line}'::text[]					,'3d_z'		,'medie'				,'datoetableret'		,'2023-07-01'::date		,true			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_ledning_type_ledn
																																																																																																																	,kkafloeb_afloeb_ledning_linie
																																																																																																																	,kkafloeb_afloeb_ledning_generel_etablering
																																																																																																																	,kkafloeb_afloeb_ledning_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_ledning_generel_ler
																																																																																																																	,kkafloeb_afloeb_ledning_ledning
																																																																																																																	,kkafloeb_afloeb_ledning_roer
																																																																																																																}'::text[])
	,(true	,2		,'kkafloeb_afloeb_ledning_strmvj'		,'Strømningsvej'							,'{strmvj,Strømningsvej}'::text[]							,NULL			,'kkafloeb'	,'afloeb'			,'ledning'		,'{Line}'::text[]					,'3d_z'		,NULL			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,false			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_ledning_type_strmvj
																																																																																																																	,kkafloeb_afloeb_ledning_linie
																																																																																																																	,kkafloeb_afloeb_ledning_generel_etablering
																																																																																																																	,kkafloeb_afloeb_klimatilp
																																																																																																																}'::text[])


	,(true	,0		,'kkafloeb_afloeb_knude'				,'Knude'									,NULL::text[]												,NULL			,'kkafloeb'	,'afloeb'			,'knude'		,'{Point}'::text[]					,'2d'		,'knude_type'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,/*'{
																																																																																																																	kkafloeb_afloeb_knude_type
																																																																																																																	,kkafloeb_afloeb_knude_knude
																																																																																																																	,kkafloeb_afloeb_knude_generel_etablering
																																																																																																																	,kkafloeb_afloeb_knude_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_knude_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_knude_generel_ler
																																																																																																																	,kkafloeb_afloeb_knude_funktion
																																																																																																																	,kkafloeb_afloeb_knude_broend
																																																																																																																	,kkafloeb_afloeb_knude_udloeb
																																																																																																																	,kkafloeb_afloeb_knude_afsp
																																																																																																																	,kkafloeb_afloeb_knude_ovrl
																																																																																																																	,kkafloeb_afloeb_knude_pmpst
																																																																																																																	,kkafloeb_afloeb_knude_retnreg
																																																																																																																	,kkafloeb_afloeb_knude_sep
																																																																																																																	,kkafloeb_afloeb_knude_ventil
																																																																																																																	,kkafloeb_afloeb_knude_bstk
																																																																																																																}'*/'{kkafloeb_afloeb_knude_type}'::text[])

	,(true	,1		,'kkafloeb_afloeb_knude_broend'			,'Brønd'									,'{broend,Brønd}'::text[]									,NULL			,'kkafloeb'	,'afloeb'			,'knude'		,'{Point}'::text[]					,'2d'		,'broend'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_knude_type_broend
																																																																																																																	,kkafloeb_afloeb_knude_knude
																																																																																																																	,kkafloeb_afloeb_knude_generel_etablering
																																																																																																																	,kkafloeb_afloeb_knude_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_knude_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_knude_generel_ler
																																																																																																																	,kkafloeb_afloeb_knude_funktion
																																																																																																																	,kkafloeb_afloeb_knude_broend
																																																																																																																	,kkafloeb_afloeb_knude_bstk
																																																																																																																	,kkafloeb_afloeb_knude_bstk_dksl
																																																																																																																	,kkafloeb_afloeb_knude_bstk_rtspr
																																																																																																																	,kkafloeb_afloeb_knude_bstk_nedlb
																																																																																																																}'::text[])
	,(false	,2		,'kkafloeb_afloeb_knude_udloeb'			,'Udløb'									,'{udloeb,Udløb}'::text[]									,NULL			,'kkafloeb'	,'afloeb'			,'knude'		,'{Point}'::text[]					,'2d'		,'medie'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_knude_type_udloeb
																																																																																																																	,kkafloeb_afloeb_knude_knude
																																																																																																																	,kkafloeb_afloeb_knude_generel_etablering
																																																																																																																	,kkafloeb_afloeb_knude_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_knude_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_knude_generel_ler
																																																																																																																	,kkafloeb_afloeb_knude_funktion
																																																																																																																	,kkafloeb_afloeb_knude_udloeb
																																																																																																																}'::text[])
	,(true	,3		,'kkafloeb_afloeb_knude_afsp'			,'Afspærring'								,'{afsp,Afspærring}'::text[]								,NULL			,'kkafloeb'	,'afloeb'			,'knude'		,'{Point}'::text[]					,'2d'		,'afspaerring'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_knude_type_afsp
																																																																																																																	,kkafloeb_afloeb_knude_knude
																																																																																																																	,kkafloeb_afloeb_knude_generel_etablering
																																																																																																																	,kkafloeb_afloeb_knude_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_knude_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_knude_generel_ler
																																																																																																																	,kkafloeb_afloeb_knude_funktion
																																																																																																																	,kkafloeb_afloeb_knude_afsp
																																																																																																																}'::text[])
	,(true	,4		,'kkafloeb_afloeb_knude_ovrl'			,'Overløbskant'								,'{ovrl,Overløbskant}'::text[]								,NULL			,'kkafloeb'	,'afloeb'			,'knude'		,'{Point}'::text[]					,'2d'		,'overloeb_type'		,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_knude_type_ovrl
																																																																																																																	,kkafloeb_afloeb_knude_knude
																																																																																																																	,kkafloeb_afloeb_knude_generel_etablering
																																																																																																																	,kkafloeb_afloeb_knude_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_knude_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_knude_generel_ler
																																																																																																																	,kkafloeb_afloeb_knude_funktion
																																																																																																																	,kkafloeb_afloeb_knude_ovrl
																																																																																																																}'::text[])
	,(true	,5		,'kkafloeb_afloeb_knude_pmpst'			,'Pumpested'								,'{pmpst,Pumpested}'::text[]								,NULL			,'kkafloeb'	,'afloeb'			,'knude'		,'{Point}'::text[]					,'2d'		,'pumpested'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_knude_type_pmpst
																																																																																																																	,kkafloeb_afloeb_knude_knude
																																																																																																																	,kkafloeb_afloeb_knude_generel_etablering
																																																																																																																	,kkafloeb_afloeb_knude_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_knude_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_knude_generel_ler
																																																																																																																	,kkafloeb_afloeb_knude_funktion
																																																																																																																	,kkafloeb_afloeb_knude_pmpst
																																																																																																																}'::text[])
	,(true	,6		,'kkafloeb_afloeb_knude_retnreg'		,'Retningsregulering'						,'{retnreg,Retningsregulering}'::text[]						,NULL			,'kkafloeb'	,'afloeb'			,'knude'		,'{Point}'::text[]					,'2d'		,'retnings_regulering'	,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_knude_type_retnreg
																																																																																																																	,kkafloeb_afloeb_knude_knude
																																																																																																																	,kkafloeb_afloeb_knude_generel_etablering
																																																																																																																	,kkafloeb_afloeb_knude_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_knude_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_knude_generel_ler
																																																																																																																	,kkafloeb_afloeb_knude_funktion
																																																																																																																	,kkafloeb_afloeb_knude_retnreg
																																																																																																																}'::text[])
	,(true	,7		,'kkafloeb_afloeb_knude_sep'			,'Separator'								,'{sep,Separator}'::text[]									,NULL			,'kkafloeb'	,'afloeb'			,'knude'		,'{Point}'::text[]					,'2d'		,'separator'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_knude_type_sep
																																																																																																																	,kkafloeb_afloeb_knude_knude
																																																																																																																	,kkafloeb_afloeb_knude_generel_etablering
																																																																																																																	,kkafloeb_afloeb_knude_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_knude_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_knude_generel_ler
																																																																																																																	,kkafloeb_afloeb_knude_funktion
																																																																																																																	,kkafloeb_afloeb_knude_sep
																																																																																																																}'::text[])
	,(true	,8		,'kkafloeb_afloeb_knude_ventil'			,'Ventil'									,'{ventil,Ventil}'::text[]									,NULL			,'kkafloeb'	,'afloeb'			,'knude'		,'{Point}'::text[]					,'2d'		,'ventil'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_knude_type_ventil
																																																																																																																	,kkafloeb_afloeb_knude_knude
																																																																																																																	,kkafloeb_afloeb_knude_generel_etablering
																																																																																																																	,kkafloeb_afloeb_knude_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_knude_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_knude_generel_ler
																																																																																																																	,kkafloeb_afloeb_knude_funktion
																																																																																																																	,kkafloeb_afloeb_knude_ventil
																																																																																																																}'::text[])


	,(true	,0		,'kkafloeb_afloeb_konstr'				,'Konstruktion'								,NULL::text[]												,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Point,Line,Polygon}'::text[]	,'2d'		,'konstruktion_type'	,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,false			,NULL::text[]						,/*'{
																																																																																																																	kkafloeb_afloeb_konstr_type
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_ovrlbyg
																																																																																																																	,kkafloeb_afloeb_konstr_pmpst
																																																																																																																	,kkafloeb_afloeb_konstr_regbyg
																																																																																																																	,kkafloeb_afloeb_konstr_smlkons
																																																																																																																	,kkafloeb_afloeb_konstr_udloebbyg
																																																																																																																	,kkafloeb_afloeb_konstr_udsklbyg
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_mgsn
																																																																																																																	,kkafloeb_afloeb_konstr_bassin
																																																																																																																	,kkafloeb_afloeb_konstr_nedsiv
																																																																																																																	,kkafloeb_afloeb_konstr_rens
																																																																																																																	,kkafloeb_afloeb_konstr_tank
																																																																																																																	,kkafloeb_afloeb_konstr_udskl
																																																																																																																	,kkafloeb_afloeb_konstr_kote
																																																																																																																	,kkafloeb_afloeb_konstr_rende
																																																																																																																	,kkafloeb_afloeb_klimatilp
																																																																																																																}'*/'{kkafloeb_afloeb_konstr_type}'::text[])

	,(true	,1		,'kkafloeb_afloeb_konstr_broendbyg'		,'Brøndbygværk'								,'{broendbyg,Brøndbygværk}'::text[]							,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'medie'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_broendbyg
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																}'::text[])
	,(true	,2		,'kkafloeb_afloeb_konstr_etgbroend'		,'Etagebrønd'								,'{etgbroend,Etagebrønd}'::text[]							,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'medie'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_etgbroend
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																}'::text[])
	,(true	,3		,'kkafloeb_afloeb_konstr_ovrlbyg'		,'Overløbsbygværk'							,'{ovrlbyg,Overløbsbygværk}'::text[]						,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'overloeb'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_ovrlbyg
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_ovrlbyg
																																																																																																																}'::text[])
	,(true	,4		,'kkafloeb_afloeb_konstr_pmpst'			,'Pumpestation'								,'{pmpst,Pumpestation}'::text[]								,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'pumpestation'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_pmpst
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_pmpst
																																																																																																																}'::text[])
	,(true	,5		,'kkafloeb_afloeb_konstr_regbyg'		,'Reguleringsbygværk'						,'{regbyg,Reguleringsbygværk}'::text[]						,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'regulering'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_regbyg
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_regbyg
																																																																																																																}'::text[])
	,(true	,6		,'kkafloeb_afloeb_konstr_smlkons'		,'Samlekonstruktion'						,'{smlkons,Samlekonstruktion}'::text[]						,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Point,Line,Polygon}'::text[]	,'2d'		,'saml_kons_type'		,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_smlkons
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_smlkons
																																																																																																																}'::text[])
	,(true	,7		,'kkafloeb_afloeb_konstr_udloebbyg'		,'Udløbsbygværk'							,'{udloebbyg,Udløbsbygværk}'::text[]						,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'medie'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_udloebbyg
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_udloebbyg
																																																																																																																}'::text[])
	,(true	,8		,'kkafloeb_afloeb_konstr_udsklbyg'		,'Udskillerbygværk'							,'{udsklbyg,Udskillerbygværk}'::text[]						,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'medie'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_udsklbyg
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_udsklbyg
																																																																																																																}'::text[])
	,(true	,9		,'kkafloeb_afloeb_konstr_mgsn'			,'Magasin'									,'{mgsn,Magasin}'::text[]									,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'magasin'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_mgsn
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_mgsn
																																																																																																																}'::text[])
	,(true	,10		,'kkafloeb_afloeb_konstr_bassin'		,'Bassin'									,'{bassin,Bassin}'::text[]									,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'bassin'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_bassin
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_mgsn
																																																																																																																	,kkafloeb_afloeb_konstr_bassin
																																																																																																																}'::text[])
	,(true	,11		,'kkafloeb_afloeb_konstr_nedsiv'		,'Nedsivningsanlæg'							,'{nedsiv,Nedsivningsanlæg}'::text[]						,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'nedsivning'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_nedsiv
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_mgsn
																																																																																																																	,kkafloeb_afloeb_konstr_nedsiv
																																																																																																																}'::text[])
	,(true	,12		,'kkafloeb_afloeb_konstr_rens'			,'Renseanlæg'								,'{rens,Renseanlæg}'::text[]								,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'renseanlaeg'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_rens
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_mgsn
																																																																																																																	,kkafloeb_afloeb_konstr_rens
																																																																																																																}'::text[])
	,(true	,13		,'kkafloeb_afloeb_konstr_sandfang'		,'Sandfang'									,'{sandfang,Sandfang}'::text[]								,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'medie'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_sandfang
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																}'::text[])
	,(true	,14		,'kkafloeb_afloeb_konstr_tank'			,'Tank'										,'{tank,Tank}'::text[]										,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'tank'					,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_tank
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_tank
																																																																																																																}'::text[])
	,(true	,15		,'kkafloeb_afloeb_konstr_udskl'			,'Udskiller'								,'{udskl,Udskiller}'::text[]								,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'udskiller'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_udskl
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_udskl
																																																																																																																}'::text[])
	,(true	,16		,'kkafloeb_afloeb_konstr_trktaarn'		,'Tryktårn'									,'{trktaarn,Tryktårn}'::text[]								,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'magasin'				,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_trktaarn
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_mgsn
																																																																																																																}'::text[])

	,(true	,17		,'kkafloeb_afloeb_konstr_kote'			,'Kote'										,'{kote,Kote}'::text[]										,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Point}'::text[]					,'2d'		,'kote_type'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_kote
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_kote
																																																																																																																}'::text[])
	,(true	,18		,'kkafloeb_afloeb_konstr_lndskb'		,'Landskabselement med hydraulisk effekt'	,'{lndskb,Landskabselement med hydraulisk effekt}'::text[]	,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Point,Line,Polygon}'::text[]	,'2d'		,'saml_kons_type'		,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_lndskb
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_smlkons
																																																																																																																	,kkafloeb_afloeb_klimatilp
																																																																																																																}'::text[])
	,(true	,19		,'kkafloeb_afloeb_konstr_prmblbef'	,'Permeabel befæstelse'						,'{prmblbef,Permeabel befæstelse}'::text[]				,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'knude_type'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,('{
																																																																																																																	kkafloeb_afloeb_konstr_type_prmblbef
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_mgsn'
																																																																																																																	/* ,kkafloeb_afloeb_konstr_nedsiv */
																																																																																																																	|| ',kkafloeb_afloeb_klimatilp
																																																																																																																}')::text[])
	,(true	,20		,'kkafloeb_afloeb_konstr_regnbed'		,'Regnbed'									,'{regnbed,Regnbed}'::text[]								,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'knude_type'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,('{
																																																																																																																	kkafloeb_afloeb_konstr_type_regnbed
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_mgsn'
																																																																																																																	/* ,kkafloeb_afloeb_konstr_nedsiv */
																																																																																																																	|| ',kkafloeb_afloeb_klimatilp
																																																																																																																}')::text[])
	,(true	,21		,'kkafloeb_afloeb_konstr_rende'			,'Rende'									,'{rende,Rende}'::text[]									,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Line}'::text[]					,'2d'		,'rende_type'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,'{
																																																																																																																	kkafloeb_afloeb_konstr_type_rende
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_rende
																																																																																																																}'::text[])
	,(true	,21		,'kkafloeb_afloeb_konstr_grft'			,'Grøft'									,'{grøft,Grøft}'::text[]										,NULL			,'kkafloeb'	,'afloeb'			,'konstr'		,'{Polygon}'::text[]				,'2d'		,'knude_type'			,'datoetableret'		,'2023-07-01'::date		,false			,NULL::text[]					,true			,NULL::text[]						,('{
																																																																																																																	kkafloeb_afloeb_konstr_type_grft
																																																																																																																	,kkafloeb_afloeb_konstr_flade
																																																																																																																	,kkafloeb_afloeb_konstr_generel_etablering
																																																																																																																	,kkafloeb_afloeb_konstr_generel_koter_mv
																																																																																																																	,kkafloeb_afloeb_konstr_generel_noejagtighed
																																																																																																																	,kkafloeb_afloeb_konstr_generel_ler
																																																																																																																	,kkafloeb_afloeb_konstr_konstruktion
																																																																																																																	,kkafloeb_afloeb_konstr_reservoir
																																																																																																																	,kkafloeb_afloeb_konstr_mgsn'
																																																																																																																	/* ,kkafloeb_afloeb_konstr_nedsiv */
																																																																																																																	|| ',kkafloeb_afloeb_klimatilp
																																																																																																																}')::text[])
;




-- TRUNCATE sandbox.kontrol_lst_featuretype_grupper RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_featuretype_grupper(
	  aktiv	,_order	,navn					,navn_pretty				,navn_lst							,beskrivelse	,system	,forsyningsart	,gruppe			,geometritype	,color_hex	,js_style																																																																					,js_svg_legend
) VALUES
	 (true	,0		,'__frame__'			,'Omfang af indlæst data'	,'{__frame__}'::text[]				,NULL			,NULL	,NULL			,NULL			,'Polygon'		,'#000000'	,E'return {\n\topacity: 1\n\t,color: ''[COLOR_HEX]''\n\t,dashArray: ''''\n\t,lineCap: ''butt''\n\t,lineJoin: ''miter''\n\t,weight: 1\n\t,fill: false\n\t,interactive: false\n}'																												,'<rect x="20%" y="20%" width="60%" height="60%" style="fill-opacity: 0; stroke: [COLOR_HEX]; stroke-width: 10%"/>')
	,(true	,1		,NULL					,NULL						,NULL::text[]						,NULL			,NULL	,NULL			,NULL			,'Point'		,NULL		,'<circle cx="50%" cy="50%" r="25%" style="fill: [COLOR_HEX]; stroke: [COLOR_HEX];"/>'																																																		,NULL)
	,(true	,2		,NULL					,NULL						,NULL::text[]						,NULL			,NULL	,NULL			,NULL			,'Line'		,NULL		,E'return {\n\topacity: feature.properties[''leaflet.opacity'']\n\t,color: ''[COLOR_HEX]''\n\t,dashArray: ''''\n\t,lineCap: ''square''\n\t,lineJoin: ''bevel''\n\t,weight: 3.0\n\t,fillOpacity: feature.properties[''leaflet.fillOpacity'']\n}'												,'<line x1="2%" y1="50%" x2="98%" y2="50%" style="stroke: [COLOR_HEX]; stroke-width: 20%;"/>')
	,(true	,3		,NULL					,NULL						,NULL::text[]						,NULL			,NULL	,NULL			,NULL			,'Polygon'		,NULL		,E'return {\n\topacity: feature.properties[''leaflet.opacity'']\n\t,color: ''[COLOR_HEX]''\n\t,dashArray: ''''\n\t,lineCap: ''butt''\n\t,lineJoin: ''miter''\n\t,weight: 1\n\t,fill: true\n\t,fillOpacity: feature.properties[''leaflet.fillOpacity'']\n\t,fillColor: ''[COLOR_HEX]''\n}'	,'<rect x="20%" y="20%" width="60%" height="60%" style="fill: [COLOR_HEX]; fill-opacity: 50%; stroke: [COLOR_HEX]; stroke-width: 10%"/>')
	,(true	,4		,NULL					,NULL						,NULL::text[]						,NULL			,NULL	,NULL			,'snap'			,'Point'		,NULL		,'<circle cx="50%" cy="50%" r="40%" style="fill: [COLOR_HEX]; stroke: black; stroke-width: 10%;"/>'																																															,'<circle cx="50%" cy="50%" r="32%" style="fill: [COLOR_HEX]; stroke: black; stroke-width: 10%;"/>')
	,(true	,10		,NULL					,NULL						,NULL::text[]						,NULL			,NULL	,NULL			,'komponent'	,'Line'		,NULL		,E'return {\n\topacity: feature.properties[''leaflet.opacity'']\n\t,color: ''[COLOR_HEX]''\n\t,dashArray: ''8''\n\t,lineCap: ''square''\n\t,lineJoin: ''bevel''\n\t,weight: 3.0\n\t,fillOpacity: feature.properties[''leaflet.fillOpacity'']\n}'											,'<line x1="2%" y1="50%" x2="98%" y2="50%" style="stroke: [COLOR_HEX]; stroke-width: 20%; stroke-dasharray: 30%;"/>')
	,(true	,21		,'broend'				,'Brønd'					,'{brønd}'::text[]					,NULL			,'ler'	,'afloeb'		,'komponent'	,'Point'		,NULL		,'<rect x="25%" y="25%" width="50%" height="50%" style="fill: [COLOR_HEX]; stroke: [COLOR_HEX];"/>'																																															,NULL)
	,(true	,22		,'sandfang'				,'Sandfang'					,'{sandfang}'::text[]				,NULL			,'ler'	,'afloeb'		,'komponent'	,'Point'		,NULL		,'<rect x="25%" y="25%" width="50%" height="50%" style="fill: [COLOR_HEX]; stroke: [COLOR_HEX]; transform-box: fill-box; transform-origin: center; transform: rotate(45deg);"/>'																											,NULL)
	,(true	,23		,'regnvand'				,'Regnvand'					,'{regnvand}'::text[]				,NULL			,'ler'	,'afloeb'		,'ledning'		,'Line'		,'#035efc'	,NULL																																																																						,NULL)
	,(true	,24		,'draenvand'			,'Drænvand'					,'{drænvand}'::text[]				,NULL			,'ler'	,'afloeb'		,'ledning'		,'Line'		,'#56a7da'	,NULL																																																																						,NULL)
	,(true	,25		,'faellesvand'			,'Fællesvand'				,'{fællesvand}'::text[]				,NULL			,'ler'	,'afloeb'		,'ledning'		,'Line'		,'#22ab18'	,NULL																																																																						,NULL)
	,(true	,26		,'vand_uden_rensekrav'	,'Vand uden rensekrav'		,'{"vand uden rensekrav"}'::text[]	,NULL			,'ler'	,'afloeb'		,'ledning'		,'Line'		,'#09c8c6'	,NULL																																																																						,NULL)
	,(true	,27		,'spildevand'			,'Spildevand'				,'{spildevand}'::text[]				,NULL			,'ler'	,'afloeb'		,'ledning'		,'Line'		,'#c1641b'	,NULL																																																																						,NULL)
;

INSERT INTO sandbox.kontrol_lst_featuretype_grupper(
	  aktiv	,_order	,navn					,navn_pretty				,navn_lst							,beskrivelse	,system	,forsyningsart	,gruppe			,geometritype	,color_hex	,js_style																																																																					,js_svg_legend
) VALUES
	 (true	,110		,NULL					,NULL						,NULL::text[]						,NULL			,'kkafloeb'	,'afloeb'		,'konstr'		,'Line'		,NULL		,E'return {\n\topacity: feature.properties[''leaflet.opacity'']\n\t,color: ''[COLOR_HEX]''\n\t,dashArray: ''8''\n\t,lineCap: ''square''\n\t,lineJoin: ''bevel''\n\t,weight: 3.0\n\t,fillOpacity: feature.properties[''leaflet.fillOpacity'']\n}'											,'<line x1="2%" y1="50%" x2="98%" y2="50%" style="stroke: [COLOR_HEX]; stroke-width: 20%; stroke-dasharray: 30%;"/>')
	,(true	,121		,'broend'				,'Brønd'					,'{Brønd}'::text[]					,NULL			,'kkafloeb'	,'afloeb'		,'knude'		,'Point'	,NULL		,'<rect x="25%" y="25%" width="50%" height="50%" style="fill: [COLOR_HEX]; stroke: [COLOR_HEX];"/>'																																															,NULL)
	,(true	,123		,'regnvand'				,'Regnvand'					,'{Regnvand}'::text[]				,NULL			,'kkafloeb'	,'afloeb'		,'ledning'		,'Line'		,'#035efc'	,NULL																																																																						,NULL)
	,(true	,124		,'draenvand'			,'Drænvand'					,'{Drænvand}'::text[]				,NULL			,'kkafloeb'	,'afloeb'		,'ledning'		,'Line'		,'#56a7da'	,NULL																																																																						,NULL)
	,(true	,125		,'faellesvand'			,'Fællesvand'				,'{Fællesvand}'::text[]				,NULL			,'kkafloeb'	,'afloeb'		,'ledning'		,'Line'		,'#22ab18'	,NULL																																																																						,NULL)
	,(true	,126		,'vand_uden_rensekrav'	,'Vand uden rensekrav'		,'{"Vand uden rensekrav"}'::text[]	,NULL			,'kkafloeb'	,'afloeb'		,'ledning'		,'Line'		,'#09c8c6'	,NULL																																																																						,NULL)
	,(true	,127		,'spildevand'			,'Spildevand'				,'{Spildevand}'::text[]				,NULL			,'kkafloeb'	,'afloeb'		,'ledning'		,'Line'		,'#c1641b'	,NULL																																																																						,NULL)
;

INSERT INTO sandbox.kontrol_lst_featuretype_grupper(
	  aktiv	,_order	,navn					,navn_pretty				,navn_lst							,beskrivelse	,system	,forsyningsart	,gruppe			,geometritype	,color_hex	,js_style																																																																					,js_svg_legend
) VALUES
	 (true	,201		,'teknikskab'			,'Teknikskab'				,'{teknikskab}'::text[]				,NULL			,'ler'		,'el'			,'komponent'	,'Point'	,NULL		,'<rect x="12.5%" y="30%" width="75%" height="40" style="fill: [COLOR_HEX]; stroke: [COLOR_HEX];"/>'																																															,NULL)
	,(true	,202		,'kabelbroend'			,'Kabelbrønd'				,'{kabelbrønd}'::text[]				,NULL			,'ler'		,'el'			,'komponent'	,'Point'	,NULL		,'<rect x="25%" y="25%" width="50%" height="50%" style="fill: [COLOR_HEX]; stroke: [COLOR_HEX];"/>'																																															,NULL)
;




-- TRUNCATE sandbox.kontrol_lst_pakker RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_pakker(
	  aktiv	,_order	,navn						,navn_pretty							,beskrivelse
) VALUES
	 (true	,1		,'ler_ledning_eller_trace'	,'LER: Ledning eller ledningstrace'		,NULL)
	,(true	,2		,'ler_ledning'				,'LER: Ledning'							,NULL)
	,(true	,3		,'ler_komponent'			,'LER: Ledningskomponent'				,NULL)
	,(true	,9		,'ler_generel_bemaerkning'	,'LER: Generel: Bemærkning'				,NULL)
	,(true	,11		,'ler_roerledning'			,'LER: Rørledning'						,NULL)
	,(true	,12		,'ler_foeringsroer'			,'LER: Føringsrør'						,NULL)
	,(true	,21		,'ler_afloeb_ledning'		,'LER: Afløbsledning'					,NULL)
	,(true	,22		,'ler_afloeb_komponent'		,'LER: Afløbskomponent'					,NULL)
	,(true	,31		,'ler_el_ledning'			,'LER: Elledning'						,NULL)
	,(true	,32		,'ler_el_komponent'			,'LER: Elkomponent'						,NULL)
	,(true	,41		,'ler_termisk_ledning'		,'LER: Termisk ledning'					,NULL)
	,(true	,42		,'ler_termisk_komponent'	,'LER: Termisk komponent'				,NULL)
	,(true	,51		,'ler_gas_ledning'			,'LER: Gasledning'						,NULL)
	,(true	,52		,'ler_gas_komponent'		,'LER: Gaskomponent'					,NULL)
	,(true	,61		,'ler_olie_ledning'			,'LER: Olieledning'						,NULL)
	,(true	,62		,'ler_olie_komponent'		,'LER: Oliekomponent'					,NULL)
	,(true	,71		,'ler_tele_ledning'			,'LER: Telekommunikationsledning'		,NULL)
	,(true	,72		,'ler_tele_komponent'		,'LER: Telekommunikationskomponent'		,NULL)
	,(true	,81		,'ler_vand_ledning'			,'LER: Vandledning'						,NULL)
	,(true	,82		,'ler_vand_komponent'		,'LER: Vandkomponent'					,NULL)
	,(true	,91		,'ler_anden_ledning'		,'LER: Anden ledning'					,NULL)
	,(true	,92		,'ler_anden_komponent'		,'LER: Anden komponent'					,NULL)
	,(true	,98		,'ler_ukendt_ledning'		,'LER: Ledning, ukendt forsyningsart'	,NULL)
	,(true	,99		,'ler_omlagtfjernet'		,'LER: Omlagt/Fjernet'					,NULL)
;

INSERT INTO sandbox.kontrol_lst_pakker(
	  aktiv	,_order	,navn						,navn_pretty							,beskrivelse
) VALUES
	 (true	,101		,'kkafloeb_afloeb_ledning_type'					,'KK Afløb: Ledning, Type'					,NULL)

	,(true	,102		,'kkafloeb_afloeb_ledning_type_ledn'			,'KK Afløb: Ledning, Type, Ledning (Type)'		,NULL)
	,(true	,102		,'kkafloeb_afloeb_ledning_type_strmvj'			,'KK Afløb: Ledning, Type, Strømningsvej'		,NULL)

	,(true	,110		,'kkafloeb_afloeb_ledning_linie'				,'KK Afløb: Ledning, Linie'					,NULL)

	,(true	,111		,'kkafloeb_afloeb_ledning_generel_etablering'	,'KK Afløb: Ledning, Etablering'			,NULL)
	,(true	,112		,'kkafloeb_afloeb_ledning_generel_noejagtighed'	,'KK Afløb: Ledning, Nøjagtighed'			,NULL)
	,(true	,113		,'kkafloeb_afloeb_ledning_generel_ler'			,'KK Afløb: Ledning, LER'					,NULL)

	,(true	,121		,'kkafloeb_afloeb_ledning_ledning'				,'KK Afløb: Ledning, Ledning'				,NULL)
	,(true	,122		,'kkafloeb_afloeb_ledning_roer'					,'KK Afløb: Ledning, Rør'					,NULL)


	,(true	,201		,'kkafloeb_afloeb_knude_type'					,'KK Afløb: Knude, Type'					,NULL)

	,(true	,202		,'kkafloeb_afloeb_knude_type_broend'			,'KK Afløb: Knude, Type, Brønd'					,NULL)
	,(true	,202		,'kkafloeb_afloeb_knude_type_udloeb'			,'KK Afløb: Knude, Type, Udløb'					,NULL)
	,(true	,202		,'kkafloeb_afloeb_knude_type_afsp'				,'KK Afløb: Knude, Type, Afspærring'			,NULL)
	,(true	,202		,'kkafloeb_afloeb_knude_type_ovrl'				,'KK Afløb: Knude, Type, Overløbskant'			,NULL)
	,(true	,202		,'kkafloeb_afloeb_knude_type_pmpst'				,'KK Afløb: Knude, Type, Pumpested'				,NULL)
	,(true	,202		,'kkafloeb_afloeb_knude_type_retnreg'			,'KK Afløb: Knude, Type, Retningsregulering'	,NULL)
	,(true	,202		,'kkafloeb_afloeb_knude_type_sep'				,'KK Afløb: Knude, Type, Separator'				,NULL)
	,(true	,202		,'kkafloeb_afloeb_knude_type_ventil'			,'KK Afløb: Knude, Type, Ventil'				,NULL)

	,(true	,210		,'kkafloeb_afloeb_knude_knude'					,'KK Afløb: Knude, Knude'					,NULL)

	,(true	,211		,'kkafloeb_afloeb_knude_generel_etablering'		,'KK Afløb: Knude, Etablering'				,NULL)
	,(true	,212		,'kkafloeb_afloeb_knude_generel_koter_mv'		,'KK Afløb: Knude, Koter mv.'				,NULL)
	,(true	,213		,'kkafloeb_afloeb_knude_generel_noejagtighed'	,'KK Afløb: Knude, Nøjagtighed'				,NULL)
	,(true	,214		,'kkafloeb_afloeb_knude_generel_ler'			,'KK Afløb: Knude, LER'						,NULL)

	,(true	,221		,'kkafloeb_afloeb_knude_funktion'				,'KK Afløb: Knude, Funktion'				,NULL)

	,(true	,231		,'kkafloeb_afloeb_knude_broend'					,'KK Afløb: Knude, Brønd'					,NULL)
	,(true	,232		,'kkafloeb_afloeb_knude_udloeb'					,'KK Afløb: Knude, Udløb'					,NULL)
	,(true	,233		,'kkafloeb_afloeb_knude_afsp'					,'KK Afløb: Knude, Afspærring'				,NULL)
	,(true	,234		,'kkafloeb_afloeb_knude_ovrl'					,'KK Afløb: Knude, Overløbskant'			,NULL)
	,(true	,235		,'kkafloeb_afloeb_knude_pmpst'					,'KK Afløb: Knude, Pumpested'				,NULL)
	,(true	,236		,'kkafloeb_afloeb_knude_retnreg'				,'KK Afløb: Knude, Retningsregulering'		,NULL)
	,(true	,237		,'kkafloeb_afloeb_knude_sep'					,'KK Afløb: Knude, Separator'				,NULL)
	,(true	,238		,'kkafloeb_afloeb_knude_ventil'					,'KK Afløb: Knude, Ventil'					,NULL)

	,(true	,271		,'kkafloeb_afloeb_knude_bstk'					,'KK Afløb: Knude, Bestykning'				,NULL)
	,(false	,272		,'kkafloeb_afloeb_knude_bstk_dksl'				,'KK Afløb: Knude, Bestykning, Dæksel'				,NULL)
	,(false	,273		,'kkafloeb_afloeb_knude_bstk_rtspr'				,'KK Afløb: Knude, Bestykning, Rottespærre'				,NULL)
	,(false	,274		,'kkafloeb_afloeb_knude_bstk_nedlb'				,'KK Afløb: Knude, Bestykning, Nedløbsrist'				,NULL)


	,(true	,301		,'kkafloeb_afloeb_konstr_type'					,'KK Afløb: Konstruktion, Type'				,NULL)

	,(true	,302		,'kkafloeb_afloeb_konstr_type_broendbyg'		,'KK Afløb: Konstruktion, Type, Brøndbygværk'			,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_etgbroend'		,'KK Afløb: Konstruktion, Type, Etagebrønd'				,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_ovrlbyg'			,'KK Afløb: Konstruktion, Type, Overløbsbygværk'		,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_pmpst'			,'KK Afløb: Konstruktion, Type, Pumpestation'			,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_regbyg'			,'KK Afløb: Konstruktion, Type, Reguleringsbygværk'		,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_smlkons'			,'KK Afløb: Konstruktion, Type, Samlekonstruktion'		,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_udloebbyg'		,'KK Afløb: Konstruktion, Type, Udløbsbygværk'			,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_udsklbyg'			,'KK Afløb: Konstruktion, Type, Udskillerbygværk'		,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_mgsn'				,'KK Afløb: Konstruktion, Type, Magasin'				,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_bassin'			,'KK Afløb: Konstruktion, Type, Bassin'					,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_nedsiv'			,'KK Afløb: Konstruktion, Type, Nedsivningsanlæg'		,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_rens'				,'KK Afløb: Konstruktion, Type, Renseanlæg'				,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_sandfang'			,'KK Afløb: Konstruktion, Type, Sandfang'				,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_tank'				,'KK Afløb: Konstruktion, Type, Tank'					,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_udskl'			,'KK Afløb: Konstruktion, Type, Udskiller'				,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_trktaarn'			,'KK Afløb: Konstruktion, Type, Tryktårn'				,NULL)

	,(true	,302		,'kkafloeb_afloeb_konstr_type_kote'				,'KK Afløb: Konstruktion, Type, Kote'									,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_lndskb'			,'KK Afløb: Konstruktion, Type, Landskabselement med hydraulisk effekt'	,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_prmblbef'			,'KK Afløb: Konstruktion, Type, Permeabel befæstelse'					,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_regnbed'			,'KK Afløb: Konstruktion, Type, Regnbed'								,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_rende'			,'KK Afløb: Konstruktion, Type, Rende'									,NULL)
	,(true	,302		,'kkafloeb_afloeb_konstr_type_grft'				,'KK Afløb: Konstruktion, Type, Grøft'									,NULL)

	,(true	,310		,'kkafloeb_afloeb_konstr_flade'					,'KK Afløb: Konstruktion, Flade'				,NULL)

	,(true	,311		,'kkafloeb_afloeb_konstr_generel_etablering'	,'KK Afløb: Konstruktion, Etablering'			,NULL)
	,(true	,312		,'kkafloeb_afloeb_konstr_generel_koter_mv'		,'KK Afløb: Konstruktion, Koter mv.'			,NULL)
	,(true	,313		,'kkafloeb_afloeb_konstr_generel_noejagtighed'	,'KK Afløb: Konstruktion, Nøjagtighed'			,NULL)
	,(true	,314		,'kkafloeb_afloeb_konstr_generel_ler'			,'KK Afløb: Konstruktion, LER'					,NULL)

	,(true	,321		,'kkafloeb_afloeb_konstr_konstruktion'			,'KK Afløb: Konstruktion, Konstruktion'			,NULL)

	,(true	,333		,'kkafloeb_afloeb_konstr_ovrlbyg'				,'KK Afløb: Konstruktion, Overløbsbygværk'		,NULL)
	,(true	,334		,'kkafloeb_afloeb_konstr_pmpst'					,'KK Afløb: Konstruktion, Pumpestation'			,NULL)
	,(true	,335		,'kkafloeb_afloeb_konstr_regbyg'				,'KK Afløb: Konstruktion, Reguleringsbygværk'	,NULL)
	,(true	,336		,'kkafloeb_afloeb_konstr_smlkons'				,'KK Afløb: Konstruktion, Samlekonstruktion'	,NULL)
	,(true	,337		,'kkafloeb_afloeb_konstr_udloebbyg'				,'KK Afløb: Konstruktion, Udløbsbygværk'		,NULL)
	,(true	,338		,'kkafloeb_afloeb_konstr_udsklbyg'				,'KK Afløb: Konstruktion, Udskillerbygværk'		,NULL)
	,(true	,339		,'kkafloeb_afloeb_konstr_reservoir'				,'KK Afløb: Konstruktion, Reservoir'			,NULL)
	,(true	,340		,'kkafloeb_afloeb_konstr_mgsn'					,'KK Afløb: Konstruktion, Magasin'				,NULL)
	,(true	,341		,'kkafloeb_afloeb_konstr_bassin'				,'KK Afløb: Konstruktion, Bassin'				,NULL)
	,(true	,342		,'kkafloeb_afloeb_konstr_nedsiv'				,'KK Afløb: Konstruktion, Nedsivningsanlæg'		,NULL)
	,(true	,343		,'kkafloeb_afloeb_konstr_rens'					,'KK Afløb: Konstruktion, Renseanlæg'			,NULL)
	,(true	,345		,'kkafloeb_afloeb_konstr_tank'					,'KK Afløb: Konstruktion, Tank'					,NULL)
	,(true	,346		,'kkafloeb_afloeb_konstr_udskl'					,'KK Afløb: Konstruktion, Udskiller'			,NULL)

	,(true	,350		,'kkafloeb_afloeb_konstr_kote'					,'KK Afløb: Konstruktion, Kote'					,NULL)
	,(true	,350		,'kkafloeb_afloeb_konstr_rende'					,'KK Afløb: Konstruktion, Rende'				,NULL)


	,(false	,999		,'kkafloeb_afloeb_klimatilp'					,'KK Afløb: Klimatilpasningsanlæg'				,NULL)
;




-- TRUNCATE sandbox.kontrol_lst_data_typer RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_data_typer(
	  aktiv	,navn			,navn_pretty		,beskrivelse	,kontrol_skema	,kontrol_navn			,kontrol_valid_idx	,kontrol_output_idx
) VALUES
	 (true	,'text'			,'Tekst'			,NULL			,NULL			,NULL					,NULL				,NULL)
	,(true	,'tm_position'	,'Datoangivelse'	,NULL			,'ler20'		,'kontrol_tm_position'	,1					,4)
	,(true	,'integer'		,'Heltal'			,NULL			,'ler20'		,'kontrol_integer'		,1					,2)
	,(true	,'float'		,'Decimaltal'		,NULL			,'ler20'		,'kontrol_numeric'		,1					,2)
	,(true	,'array'		,'Array'			,NULL			,'ler20'		,'kontrol_array'		,1					,2)
	,(true	,'boolean'		,'Ja/Nej'			,NULL			,'ler20'		,'kontrol_boolean'		,1					,3)
	,(true	,'datetime'		,'Dato/Tid'			,NULL			,'ler20'		,'kontrol_datetime'		,1					,2)
	,(true	,'date'			,'Dato'				,NULL			,'ler'			,'kontrol_date'			,1					,2)
;




-- TRUNCATE sandbox.kontrol_lst_kontrol_typer RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_kontrol_typer(
	  aktiv	,navn			,navn_pretty						,beskrivelse
) VALUES
	 (true	,'hidden'		,'Skjult'							,NULL)
	,(true	,'hidden_attr'	,'Ingen tjek om attributten findes'	,NULL)
	,(true	,'no_control'	,'Ingen kontrol'					,NULL)
	,(true	,'min_max'		,'Min-Max'							,NULL)
;




-- TRUNCATE sandbox.kontrol_lst_opslagstabeller RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_opslagstabeller(
	  aktiv	,navn										,navn_pretty									,beskrivelse	,tabel_skema	,tabel_navn								,tabel_kolonne	,tabel_filter
) VALUES
	 (true	,'ler_faelles_drifsstatus'					,'LER: Fælles, Driftsstatus'					,NULL			,'ler20'		,'lst_driftsstatus'						,'type'			,'aktiv IS TRUE')
	,(true	,'ler_faelles_ejerskabsforhold'				,'LER: Fælles, Ejerskabsforhold'				,NULL			,'ler20'		,'lst_ejerskabsforholdtype'				,'type'			,'aktiv IS TRUE')
	,(true	,'ler_faelles_fareklasse'					,'LER: Fælles, Fareklasse'						,NULL			,'ler20'		,'lst_fareklasse'						,'type'			,'aktiv IS TRUE')
	,(true	,'ler_faelles_fareklasse_ikke_meget_farlig'	,'LER: Fælles, Fareklasse, uden meget farlig'	,NULL			,'ler20'		,'lst_fareklasse'						,'type'			,'aktiv IS TRUE')
	,(true	,'ler_faelles_indtegningsmetode'			,'LER: Fælles, Indtegningsmetode'				,NULL			,'ler20'		,'lst_indtegningsmetodetype'			,'type'			,'aktiv IS TRUE')
	,(true	,'ler_faelles_noejagtighedsklasse'			,'LER: Fælles, Nøjagtighedsklasse'				,NULL			,'ler20'		,'lst_noejagtighedsklasse'				,'type'			,'aktiv IS TRUE')
	,(true	,'ler_faelles_niveau'						,'LER: Fælles, Niveau'							,NULL			,'ler20'		,'lst_niveautype'						,'type'			,'aktiv IS TRUE')
	,(true	,'ler_faelles_tvaersnitsform'				,'LER: Fælles, Tværsnitsform'					,NULL			,'ler20'		,'lst_tvaersnitsformtype'				,'type'			,'aktiv IS TRUE')
	,(true	,'ler_faelles_forsyningsart'				,'LER: Fælles, Forsyningsart'					,NULL			,'ler20'		,'lst_forsyningsart'					,'type'			,'aktiv IS TRUE')
	,(true	,'ler_ledning_etableringsmetode'			,'LER: Ledning, Etableringsmetode'				,NULL			,'ler20'		,'lst_ledningsetableringsmetodetype'	,'type'			,'aktiv IS TRUE')
	,(true	,'ler_afloeb_transporttype'					,'LER: Afløb, Transporttype'					,NULL			,'ler20'		,'lst_ledningstransporttype'			,'type'			,'aktiv IS TRUE')
	,(true	,'ler_afloeb_medietype'						,'LER: Afløb, Medietype'						,NULL			,'ler20'		,'lst_medietype'						,'type'			,'aktiv IS TRUE')
	,(true	,'ler_afloeb_komponenttype'					,'LER: Afløb, Komponenttype'					,NULL			,'ler20'		,'lst_afloebskomponenttype'				,'type'			,'aktiv IS TRUE')
	,(true	,'ler_afloeb_broendform'					,'LER: Afløb, Brøndform'						,NULL			,'ler20'		,'lst_broendformtype'					,'type'			,'aktiv IS TRUE')
	,(true	,'ler_el_ledningstype'						,'LER: El, Ledningstype'						,NULL			,'ler20'		,'lst_elledningstype'					,'type'			,'aktiv IS TRUE')
	,(true	,'ler_el_komponenttype'						,'LER: El, Komponenttype'						,NULL			,'ler20'		,'lst_elkomponenttype'					,'type'			,'aktiv IS TRUE')
	,(true	,'ler_el_relativ_niveau'					,'LER: El, Relativ niveau'						,NULL			,'ler20'		,'lst_relativniveautype'				,'type'			,'aktiv IS TRUE')
	,(true	,'ler_termisk_ledningstype'					,'LER: Termisk, Ledningstype'					,NULL			,'ler20'		,'lst_termiskledningstype'				,'type'			,'aktiv IS TRUE')
	,(true	,'ler_termisk_komponenttype'				,'LER: Termisk, Komponenttype'					,NULL			,'ler20'		,'lst_termiskkomponenttype'				,'type'			,'aktiv IS TRUE')
	,(true	,'ler_termisk_indholdstype'					,'LER: Termisk, Indholdstype'					,NULL			,'ler20'		,'lst_termiskledningsindholdstype'		,'type'			,'aktiv IS TRUE')
	,(true	,'ler_termisk_konstruktiontype'				,'LER: Termisk, Konstruktiontype'				,NULL			,'ler20'		,'lst_termiskledningkonstruktiontype'	,'type'			,'aktiv IS TRUE')
	,(true	,'ler_gas_ledningstype'						,'LER: Gas, Ledningstype'						,NULL			,'ler20'		,'lst_gasledningstype'					,'type'			,'aktiv IS TRUE')
	,(true	,'ler_gas_komponenttype'					,'LER: Gas, Komponenttype'						,NULL			,'ler20'		,'lst_gaskomponenttype'					,'type'			,'aktiv IS TRUE')
	,(true	,'ler_gas_medietype'						,'LER: Gas, Medietype'							,NULL			,'ler20'		,'lst_gasledningsmedietype'				,'type'			,'aktiv IS TRUE')
	,(true	,'ler_tele_ledningstype'					,'LER: Tele, Ledningstype'						,NULL			,'ler20'		,'lst_telekommunikationsledningstype'	,'type'			,'aktiv IS TRUE')
	,(true	,'ler_tele_komponenttype'					,'LER: Tele, Komponenttype'						,NULL			,'ler20'		,'lst_telekommunikationskomponenttype'	,'type'			,'aktiv IS TRUE')
	,(true	,'ler_vand_komponenttype'					,'LER: Vand, Komponenttype'						,NULL			,'ler20'		,'lst_vandkomponenttype'				,'type'			,'aktiv IS TRUE')
	,(true	,'ler_vand_tapsted'							,'LER: Vand, Tapsted'							,NULL			,'ler20'		,'lst_tapstedstype'						,'type'			,'aktiv IS TRUE')
	,(true	,'ler_vand_anborsted'						,'LER: Vand, Anborsted'							,NULL			,'ler20'		,'lst_anborstedtype'					,'type'			,'aktiv IS TRUE')
;

INSERT INTO sandbox.kontrol_lst_opslagstabeller(
	  aktiv	,navn										,navn_pretty										,beskrivelse												,tabel_skema	,tabel_navn								,tabel_kolonne	,tabel_kolonne_sql_tooltip										,tabel_filter
) VALUES
	 (true	,'kkafloeb_faelles_ja_nej'					,'KK Afløb: Fælles, Ja/Nej'							,NULL														,'aflob'		,'lst_ja_nej'							,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_faelles_status'					,'KK Afløb: Fælles, Status'							,NULL														,'aflob'		,'lst_status'							,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt'' AND beskrivelse NOT IN(''Fjernet'')')
	,(true	,'kkafloeb_faelles_dato_noejagtighed'		,'KK Afløb: Fælles, Dato nøjagtighed'				,NULL														,'aflob'		,'lst_dato_noejagtighed'				,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_faelles_noejagtighed'			,'KK Afløb: Fælles, Nøjagtighed'					,NULL														,'aflob'		,'lst_noejagtighed'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_faelles_ler_fareklasse'			,'KK Afløb: Fælles, Fareklasse'						,NULL														,'aflob'		,'lst_ler_fareklasse'					,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_faelles_placering'				,'KK Afløb: Fælles, Placering'						,NULL														,'aflob'		,'lst_placering'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_faelles_materiale'				,'KK Afløb: Fælles, Materiale'						,NULL														,'aflob'		,'lst_materiale'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_faelles_medie'					,'KK Afløb: Fælles, Medie'							,NULL														,'aflob'		,'lst_medie'							,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_faelles_miljoeklasse'			,'KK Afløb: Fælles, Miljøklasse'					,NULL														,'aflob'		,'lst_miljoeklasse'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')

	,(true	,'kkafloeb_ledning_ledning_type'			,'KK Afløb: Ledning, Type'							,NULL														,'aflob'		,'lst_ledning_type'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_ledning_ledning_kategori'		,'KK Afløb: Ledning, Kategori'						,NULL														,'aflob'		,'lst_ledning_kategori'					,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt'' AND beskrivelse NOT IN(''Strømningsvej'')')
	,(true	,'kkafloeb_ledning_ledning_funktion'		,'KK Afløb: Ledning, Funktion'						,NULL														,'aflob'		,'lst_ledning_funktion'					,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_ledning_ledning_transport'		,'KK Afløb: Ledning, Transportform'					,NULL														,'aflob'		,'lst_ledning_transport'				,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_ledning_tvaerprofil'				,'KK Afløb: Ledning, Tværprofil'					,NULL														,'aflob'		,'lst_tvaerprofil'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')

	,(true	,'kkafloeb_knude_knude_type'				,'KK Afløb: Knude, Type'							,NULL														,'aflob'		,'lst_knude_type'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt'' AND beskrivelse IN(''Brønd'', ' || /*''Udløb'', */ '''Afspærring'', ''Overløbskant'', ''Pumpested'', ''Retningsregulering'', ''Separator'', ''Ventil'')')
	,(true	,'kkafloeb_knude_broend'					,'KK Afløb: Knude, Brønd'							,NULL														,'aflob'		,'lst_broend'							,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_broendform'				,'KK Afløb: Knude, Brønd, form'						,NULL														,'aflob'		,'lst_broendform'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_afspaerring'				,'KK Afløb: Knude, Afspærring'						,NULL														,'aflob'		,'lst_afspaerring'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_overloeb_type'				,'KK Afløb: Knude, Overløbskant'					,NULL														,'aflob'		,'lst_overloeb_type'					,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_overloeb_beregning'		,'KK Afløb: Knude, Overløbskant, beregningsmetode'	,NULL														,'aflob'		,'lst_overloeb_beregning'				,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_overloebkant'				,'KK Afløb: Knude, Overløbskant, formkant'			,NULL														,'aflob'		,'lst_overloebkant'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_pumpested'					,'KK Afløb: Knude, Pumpested'						,NULL														,'aflob'		,'lst_pumpested'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_retnings_regulering'		,'KK Afløb: Knude, Retningsregulering'				,NULL														,'aflob'		,'lst_retnings_regulering'				,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_separator'					,'KK Afløb: Knude, Separator'						,NULL														,'aflob'		,'lst_separator'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_ventil'					,'KK Afløb: Knude, Ventil'							,NULL														,'aflob'		,'lst_ventil'							,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_daeksel_ristform'			,'KK Afløb: Knude, Bestykning, Dæksel-/ Ristform'	,NULL														,'aflob'		,'lst_daeksel_ristform'					,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_knude_rottespaerre'				,'KK Afløb: Knude, Bestykning, Rottespærre'			,NULL														,'aflob'		,'lst_rottespaerre'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')

	,(true	,'kkafloeb_konstr_konstruktion_type'		,'KK Afløb: Konstruktion, Type'						,NULL														,'aflob'		,'lst_konstruktion_type'				,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_overloeb'					,'KK Afløb: Konstruktion, Overløbsbygværk'			,NULL														,'aflob'		,'lst_overloeb'							,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_pumpestation'				,'KK Afløb: Konstruktion, Pumpestation'				,NULL														,'aflob'		,'lst_pumpestation'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_regulering'				,'KK Afløb: Konstruktion, Reguleringsbygværk'		,NULL														,'aflob'		,'lst_regulering'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_samlekonstruktion_type'	,'KK Afløb: Konstruktion, Samlekonstruktion'		,'OBS Ekstra test på attribut ift. geometritype'			,'aflob'		,'lst_samlekonstruktion_type'			,'beskrivelse'	,'array_to_string(geometri_typer, '', '')'						,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_magasin'					,'KK Afløb: Konstruktion, Magasin'					,NULL														,'aflob'		,'lst_magasin'							,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_bassin'					,'KK Afløb: Konstruktion, Bassin'					,NULL														,'aflob'		,'lst_bassin'							,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_nedsivning'				,'KK Afløb: Konstruktion, Nedsivningsanlæg'			,NULL														,'aflob'		,'lst_nedsivning'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_renseanlaeg'				,'KK Afløb: Konstruktion, Renseanlæg'				,NULL														,'aflob'		,'lst_renseanlaeg'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_tank'						,'KK Afløb: Konstruktion, Tank'						,NULL														,'aflob'		,'lst_tank'								,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_udskiller'				,'KK Afløb: Konstruktion, Udskiller'				,NULL														,'aflob'		,'lst_udskiller'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_kote_type'				,'KK Afløb: Konstruktion, Kote'						,NULL														,'aflob'		,'lst_kote_type'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
	,(true	,'kkafloeb_konstr_rende_type'				,'KK Afløb: Konstruktion, Rende'					,NULL														,'aflob'		,'lst_rende_type'						,'beskrivelse'	,NULL															,'aktiv = 1 AND beskrivelse != ''Ukendt''')
;




-- TRUNCATE sandbox.kontrol_lst_attributter_geometri RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_attributter_geometri(
	  aktiv	,_order	,navn			,navn_pretty				,beskrivelse	,pakke		,tooltip_html
) VALUES
	 (true	,1		,'mgd'			,'Mængde'							,NULL			,'geometri'	,NULL)
	,(true	,2		,'z_count'		,'Antal knudepunkter'				,NULL			,'geometri'	,NULL)
	,(true	,3		,'z_min_max'	,'Z (Min/Maks)'						,NULL			,'geometri'	,NULL)
	,(true	,11		,'no_geom'		,'Ingen geometri'					,NULL			,'geometri'	,'<p>Geometrien må ikke være NULL eller "tom" (eks. POINT EMPTY)</p>')
	,(true	,12		,'srid'			,'Koordinatsystem'					,NULL			,'geometri'	,E'<p>Koordinatsystemet skal være et af følgende:</p>\n<ul>\n\t<li>EPSG:4095 - "ETRS89 / DKTM3" + DVR90 koter</li>\n\t<li>EPSG:4099 - "ETRS89 / DKTM3" + DVR90 height</li>\n\t<li>EPSG:25832 - "ETRS89 / UTM zone 32N" + DVR90 koter</li>\n</ul>')
	,(true	,13		,'ndims'		,'Dimensioner (XYZ)'				,NULL			,'geometri'	,E'<p>Objektets dimension (XY og evt. Z) skal stemme overens med gældende krav.</p>\n<hr class="tooltip_break"/>\n<p>Typisk 2D eller 3D-Z</p>')
	,(true	,14		,'geometritype'	,'Geometritype'						,NULL			,'geometri'	,E'<p>Geometritypen skal matche navnet på filen og må ikke være en blanding af flere geometrityper</p>\n<hr class="tooltip_break"/>\n<p>Eksempelvis et filnavn med afloeb_ledning_linje skal indeholder linestrings</p>\n<hr class="tooltip_break"/>\n<p>Ved denne type fejl vises geometrierne ikke nødvendigvis i kortet</p>')
	,(true	,15		,'singlegeom'	,'Singlegeometri'					,NULL			,'geometri'	,E'<p>Geometrien skal være <i>singlegeometri</i></p>\n<hr class="tooltip_break"/>\n<p>Objektet må altså ikke bestå af flere separate geometrier</p>')
	,(true	,16		,'min_mgd'		,'Størrelse'						,NULL			,'geometri'	,'<p>Geometrier skal være over en vis størrelse</p>')
	,(true	,17		,'valid'		,'Geometrifejl'						,NULL			,'geometri'	,E'<p>Geometrien må ikke indeholde topologiske fejl</p>\n<hr class="tooltip_break"/>\n<p>Her anvendes PostGIS'' ST_IsValid og evt. fejl beskrives med ST_IsValidReason</p>')
	,(true	,18		,'snap'			,'Snap'								,NULL			,'geometri'	,E'<p>Ledningers endepunkter og punktkomponenter tjekkes for snap</p>\n<hr class="tooltip_break"/>\n<p>Manglende snap er ikke nødvendigvis en fejl</p>\n<hr class="tooltip_break"/>\n<ul>\n<li><b>Ingen snap:</b><br/>Vises med gul på kortet<br/>Snapper ikke til noget indenfor rimelig afstand</li>\n<li><b>Tilnærmet snap:</b><br/>Vises med lys grøn på kortet<br/>Knudepunktet ligger så tæt på en linje eller kanten af en polygon, at det godt kan anses som snappet</li>\n<li><b>Snappet:</b><br/>Vises med mørk grøn på kortet</li>\n</ul>')
	,(true	,19		,'z_99'			,'Ukendte Z-koordinater'			,NULL			,'geometri'	,E'<p>Z-koordinaten må ikke være ukendt (-99)</p>\n<hr class="tooltip_break"/>\n<p>Ukendte Z-koordinater kan forekomme, hvis der afleveres gamle data, typisk fra før 1. juli 2023</p>')
	,(true	,20		,'z_0'			,'"0"-Z-koordinater'				,NULL			,'geometri'	,E'<p>Z-koordinater med værdien 0 er meget usandsynlige. Typisk er det fordi Z-koordinaterne mangler</p>\n<hr class="tooltip_break"/>\n<p>Hvis Z-koordinaten er ukendt, skal den i stedet være -99, men vær opmærksom på, at der kan gælde krav som gør, at Z-koordinaten ikke må være ukendt</p>')
	,(true	,21		,'z_nan'		,'"NaN"-Z-koordinater'				,NULL			,'geometri'	,E'<p>Z-koordinater må ikke være "NaN" (Not a Number) / NULL</p>\n<hr class="tooltip_break"/>\n<p>Denne fejl forekommer meget sjældent, men kan typisk opstå, hvis geometrier splittes under bestemte forhold, bl.a. med snap via andre lag</p>')
	,(true	,22		,'z_high_low'	,'Urealistiske Z-koordinater'		,NULL			,'geometri'	,'<p>Z-koordinater skal være realistiske</p>')
;




-- TRUNCATE sandbox.kontrol_lst_attributter RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_attributter(
	  aktiv	,_order	,forsyningsart_incl_lst		,forsyningsart_excl_lst					,pakke						,navn_pretty							,navn									,navn_lst							,beskrivelse	,data_type		,nillable	,default_value						,opslagstabel						,opslagstabel_filter		,kontrol_type	,fejl	,enhed	,restriktion_beskrivelse	,restriktion_sql																																																																											,tooltip_html
) VALUES
	 (true	,1		,NULL::text[]				,NULL::text[]							,'ler_ledning_eller_trace'	,'Driftsstatus'							,'driftsstatus'							,'{driftsstat}'::text[]				,NULL			,'text'			,false		,'i drift'							,'ler_faelles_drifsstatus'			,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [KOLONNE] = ''ukendt''\n\tTHEN FALSE\nEND'																																																						,'<p>Ukendt kun før skæringsdatoen</p>')
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_ledning_eller_trace'	,'Ejerskabsforhold'						,'ejerskabsforhold'						,'{ejerskabsf}'::text[]				,NULL			,'text'			,false		,'ejet af udleverende ledningsejer'	,'ler_faelles_ejerskabsforhold'		,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_ledning_eller_trace'	,'Etableringstidspunkt'					,'etableringstidspunkt'					,'{etab_tid}'::text[]				,NULL			,'tm_position'	,false		,NULL								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,E'<p>Format: DD-MM-ÅÅÅÅ</p>\n<br/>\n<p>"før 1. juli 2023" kan også angives</p>')
	,(true	,4		,NULL::text[]				,'{el,termisk,gas,tele,vand}'::text[]	,'ler_ledning_eller_trace'	,'Fareklasse'							,'fareklasse'							,'{fareklas}'::text[]				,NULL			,'text'			,false		,'ikke farlig'						,'ler_faelles_fareklasse'			,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [KOLONNE] = ''ukendt''\n\tTHEN FALSE\nEND'																																																						,'<p>Ukendt kun før skæringsdatoen</p>')
	,(true	,4		,'{tele,vand}'::text[]		,NULL::text[]							,'ler_ledning_eller_trace'	,'Fareklasse'							,'fareklasse'							,'{fareklas}'::text[]				,NULL			,'text'			,false		,'ikke farlig'						,'ler_faelles_fareklasse'			,'type != ''meget farlig'''	,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [KOLONNE] = ''ukendt''\n\tTHEN FALSE\nEND'																																																						,'<p>Ukendt kun før skæringsdatoen</p>')
	,(true	,4		,'{el,termisk,gas}'::text[]	,NULL::text[]							,'ler_ledning_eller_trace'	,'Fareklasse'							,'fareklasse'							,'{fareklas}'::text[]				,NULL			,'text'			,false		,'farlig'							,'ler_faelles_fareklasse'			,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [KOLONNE] = ''ukendt''\n\tTHEN FALSE\nEND'																																																						,'<p>Ukendt kun før skæringsdatoen</p>')
	,(false	,5		,NULL::text[]				,NULL::text[]							,'ler_ledning_eller_trace'	,'ID'									,'id'									,NULL::text[]						,NULL			,'text'			,true		,NULL								,NULL								,NULL						,'hidden'		,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,6		,NULL::text[]				,NULL::text[]							,'ler_ledning_eller_trace'	,'Indtegningsmetode'					,'indtegningsmetode'					,'{indteg_met}'::text[]				,NULL			,'text'			,true		,'nøjagtigt'						,'ler_faelles_indtegningsmetode'	,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,7		,NULL::text[]				,NULL::text[]							,'ler_ledning_eller_trace'	,'Nøjagtighedsklasse'					,'noejagtighedsklasse'					,'{nojagt_kla}'::text[]				,NULL			,'text'			,false		,'<= 0.25 m'						,'ler_faelles_noejagtighedsklasse'	,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [ejerskabsforhold] = ''ejet af udleverende ledningsejer''\n\t\tAND [KOLONNE] = ''ukendt''\n\tTHEN FALSE\nEND'																																					,'<p>Ukendt kun før skæringsdatoen</p>')
	,(false	,8		,NULL::text[]				,NULL::text[]							,'ler_ledning_eller_trace'	,'Registrering fra'						,'registreringfra'						,'{regist_fra}'::text[]				,NULL			,'datetime'		,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,9		,NULL::text[]				,NULL::text[]							,'ler_ledning_eller_trace'	,'Sikkerhedshensyn'						,'sikkerhedshensyn'						,'{sik_hensyn}'::text[]				,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 500\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 500 karakterer</p>')
	-- ,(true	,10		,NULL::text[]				,'{foeringsroer,el,tele}'::text[]		,'ler_ledning_eller_trace'	,'Vejledende dybde'						,'vejledendedybde'						,'{vejl_dybd}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0\n\tTHEN FALSE\n\tWHEN [niveau] = ''under terræn''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																																																																	,E'<p>Skal være &gt;= 0</p>\n<br/>\n<p>Skal være angivet, hvis niveau er "under terræn"</p>')
	-- ,(true	,10		,'{foeringsroer}'::text[]	,NULL::text[]							,'ler_ledning_eller_trace'	,'Vejledende dybde'						,'vejledendedybde'						,'{vejl_dybd}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0\n\tTHEN FALSE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND z_99_count > 0\n\t\tAND [forsyningsart] IN(''el'', ''telekommunikation'')\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [niveau] = ''under terræn''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																							,E'<p>Skal være &gt;= 0</p>\n<br/>\n<p>Skal være angivet, hvis niveau er "under terræn"</p>\n<p>Skal være angivet, hvis følgende gælder:</p>\n<ul>\n<li>den primære forsyningsart er "el" eller "telekommunikation"</li>\n<li>etableringstidspunktet er efter skæringsdatoen</li>\n<li>de vertikale koordinater i geometrien er ukendt-værdien på -99</li>\n</ul>')
	-- ,(true	,10		,'{el,tele}'::text[]		,NULL::text[]							,'ler_ledning_eller_trace'	,'Vejledende dybde'						,'vejledendedybde'						,'{vejl_dybd}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0\n\tTHEN FALSE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND z_99_count > 0\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [niveau] = ''under terræn''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [niveau] = ''under terræn''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'								,E'<p>Skal være &gt;= 0</p>\n<br/>\n<p>Skal være angivet, hvis niveau er "under terræn"</p>\n<p>Skal være angivet, hvis følgende gælder:</p>\n<ul>\n<li>etableringstidspunktet er efter skæringsdatoen</li>\n<li>de vertikale koordinater i geometrien er ukendt-værdien på -99</li>\n</ul>')
	,(true	,10		,NULL::text[]				,'{foeringsroer,el,tele}'::text[]		,'ler_ledning_eller_trace'	,'Vejledende dybde'						,'vejledendedybde'						,'{vejl_dybd}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0\n\tTHEN FALSE\nEND'																																																																	,E'<p>Skal være &gt;= 0</p>')
	,(true	,10		,'{foeringsroer}'::text[]	,NULL::text[]							,'ler_ledning_eller_trace'	,'Vejledende dybde'						,'vejledendedybde'						,'{vejl_dybd}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0\n\tTHEN FALSE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND z_99_count > 0\n\t\tAND [forsyningsart] IN(''el'', ''telekommunikation'')\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																							,E'<p>Skal være &gt;= 0</p>\n<p>Skal være angivet, hvis følgende gælder:</p>\n<ul>\n<li>den primære forsyningsart er "el" eller "telekommunikation"</li>\n<li>etableringstidspunktet er efter skæringsdatoen</li>\n<li>de vertikale koordinater i geometrien er ukendt-værdien på -99</li>\n</ul>')
	,(true	,10		,'{el,tele}'::text[]		,NULL::text[]							,'ler_ledning_eller_trace'	,'Vejledende dybde'						,'vejledendedybde'						,'{vejl_dybd}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0\n\tTHEN FALSE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND z_99_count > 0\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																																						,E'<p>Skal være &gt;= 0</p>\n<p>Skal være angivet, hvis følgende gælder:</p>\n<ul>\n<li>etableringstidspunktet er efter skæringsdatoen</li>\n<li>de vertikale koordinater i geometrien er ukendt-værdien på -99</li>\n</ul>')
	,(false	,11		,NULL::text[]				,NULL::text[]							,'ler_ledning_eller_trace'	,'Bilag'								,'bilag'								,NULL::text[]						,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,12		,NULL::text[]				,NULL::text[]							,'ler_ledning_eller_trace'	,'Kontaktprofil til tekniske spørgsmål'	,'kontaktprofiltiltekniskespoergsmaal'	,'{kontakt}'::text[]				,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_ledning'				,'Niveau'								,'niveau'								,NULL::text[]						,NULL			,'text'			,false		,'under terræn'						,'ler_faelles_niveau'				,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,2		,NULL::text[]				,NULL::text[]							,'ler_ledning'				,'Indeholder ledninger'					,'indeholderledninger'					,'{indeh_led}'::text[]				,NULL			,'boolean'		,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,3		,NULL::text[]				,NULL::text[]							,'ler_ledning'				,'Ledningsetableringsmetode'			,'ledningsetableringsmetode'			,'{etablmetod}'::text[]				,NULL			,'text'			,true		,NULL								,'ler_ledning_etableringsmetode'	,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,4		,NULL::text[]				,NULL::text[]							,'ler_ledning'				,'Ligger i ledning'						,'liggeriledning'						,'{lig_i_led}'::text[]				,NULL			,'boolean'		,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,5		,NULL::text[]				,'{el,tele}'::text[]					,'ler_ledning'				,'Udvendig diameter'					,'udvendigdiameter'						,'{udven_dm}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN [tvaersnitsform] IS NULL\n\tTHEN TRUE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [tvaersnitsform] = ''cirkulær''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [tvaersnitsform] != ''cirkulær''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'	,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Skal være angivet, hvis følgende gælder:</p>\n<ul>\n<li>etableringstidspunktet er efter skæringsdatoen</li>\n<li>tværsnitsformen er "cirkulær"</li>\n</ul>\n<hr class="tooltip_break"/>\n<b>MEN må ikke være angivet, hvis tværsnitsformen ikke er "cirkulær"</b>')
	,(true	,5		,'{el,tele}'::text[]		,NULL::text[]							,'ler_ledning'				,'Udvendig diameter'					,'udvendigdiameter'						,'{udven_dm}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																																												,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Skal være angivet, hvis følgende gælder:</p>\n<ul>\n<li>etableringstidspunktet er efter skæringsdatoen</li>\n</ul>')
	,(false	,6		,NULL::text[]				,NULL::text[]							,'ler_ledning'				,'Udvendig farve'						,'udvendigfarve'						,'{udven_farv,udvend_far}'::text[]	,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 50\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 50 karakterer</p>')
	,(true	,7		,NULL::text[]				,NULL::text[]							,'ler_ledning'				,'Udvendig materiale'					,'udvendigmateriale'					,'{udven_mate}'::text[]				,NULL			,'text'			,false		,NULL								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 50\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 50 karakterer</p>')
	,(false	,8		,NULL::text[]				,NULL::text[]							,'ler_ledning'				,'Indeholdt ledning'					,'indeholdtledning'						,'{indh_ledn}'::text[]				,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,9		,NULL::text[]				,NULL::text[]							,'ler_ledning'				,'Startkomponent'						,'startkomponent'						,'{startkomp}'::text[]				,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,10		,NULL::text[]				,NULL::text[]							,'ler_ledning'				,'Slutkomponent'						,'slutkomponent'						,'{slutkomp}'::text[]				,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Driftsstatus'							,'driftsstatus'							,'{driftsstat}'::text[]				,NULL			,'text'			,false		,'i drift'							,'ler_faelles_drifsstatus'			,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Ejerskabsforhold'						,'ejerskabsforhold'						,'{ejerskabsf}'::text[]				,NULL			,'text'			,false		,'ejet af udleverende ledningsejer'	,'ler_faelles_ejerskabsforhold'		,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Etableringstidspunkt'					,'etableringstidspunkt'					,'{etab_tid}'::text[]				,NULL			,'tm_position'	,false		,NULL								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,4		,NULL::text[]				,'{el,termisk,gas}'::text[]				,'ler_komponent'			,'Fareklasse'							,'fareklasse'							,'{fareklas}'::text[]				,NULL			,'text'			,false		,'ikke farlig'						,'ler_faelles_fareklasse'			,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,4		,'{el,termisk,gas}'::text[]	,NULL::text[]							,'ler_komponent'			,'Fareklasse'							,'fareklasse'							,'{fareklas}'::text[]				,NULL			,'text'			,false		,'farlig'							,'ler_faelles_fareklasse'			,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,5		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'ID'									,'id'									,NULL::text[]						,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,6		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Materiale'							,'materiale'							,NULL::text[]						,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 50\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 50 karakterer</p>')
	,(true	,7		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Nøjagtighedsklasse'					,'noejagtighedsklasse'					,'{nojagt_kla}'::text[]				,NULL			,'text'			,false		,'<= 0.25 m'						,'ler_faelles_noejagtighedsklasse'	,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,8		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Registrering fra'						,'registreringfra'						,'{regist_fra}'::text[]				,NULL			,'datetime'		,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,9		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Sikkerhedshensyn'						,'sikkerhedshensyn'						,'{sik_hensyn}'::text[]				,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 500\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 500 karakterer</p>')
	-- ,(true	,10		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Vejledende dybde'						,'vejledendedybde'						,'{vejl_dybd}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0\n\tTHEN FALSE\n\tWHEN [niveau] = ''under terræn''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																																														,E'<p>Skal være &gt;= 0</p>\n<br/>\n<p>Skal være angivet, hvis niveau er "under terræn"</p>')
	,(true	,10		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Vejledende dybde'						,'vejledendedybde'						,'{vejl_dybd}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0\n\tTHEN FALSE\nEND'																																																																	,E'<p>Skal være &gt;= 0</p>')
	,(false	,11		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Bilag'								,'bilag'								,NULL::text[]						,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,12		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Kontaktprofil til tekniske spørgsmål'	,'kontaktprofiltiltekniskespoergsmaal'	,'{kontakt}'::text[]				,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,13		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Niveau'								,'niveau'								,NULL::text[]						,NULL			,'text'			,false		,NULL								,'ler_faelles_niveau'				,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(false	,14		,NULL::text[]				,NULL::text[]							,'ler_komponent'			,'Tilknyttet ledning'					,'tilknyttetledning'					,'{tilkny_led}'::text[]				,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_generel_bemaerkning'	,'Bemærkning'							,'note_intern'							,'{bemaerkning,bemaerkn}'::text[]	,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 500\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 500 karakterer</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_roerledning'			,'Tværsnitsform'						,'tvaersnitsform'						,'{tvaerform}'::text[]				,NULL			,'text'			,false		,'cirkulær'							,'ler_faelles_tvaersnitsform'		,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_roerledning'			,'Udvendig bredde'						,'udvendigbredde'						,'{udven_bre}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [tvaersnitsform] != ''cirkulær''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [tvaersnitsform] = ''cirkulær''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'												,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Skal være angivet, hvis følgende gælder:</p>\n<ul>\n<li>etableringstidspunktet er efter skæringsdatoen</li>\n<li>tværsnitsformen ikke er "cirkulær"</li>\n</ul>\n<hr class="tooltip_break"/>\n<b>MEN må ikke være angivet, hvis tværsnitsformen er "cirkulær"</b>')
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_roerledning'			,'Udvendig højde'						,'udvendighoejde'						,'{udven_hoj}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [tvaersnitsform] != ''cirkulær''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [tvaersnitsform] = ''cirkulær''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'												,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Skal være angivet, hvis følgende gælder:</p>\n<ul>\n<li>etableringstidspunktet er efter skæringsdatoen</li>\n<li>tværsnitsformen ikke er "cirkulær"</li>\n</ul>\n<hr class="tooltip_break"/>\n<b>MEN må ikke være angivet, hvis tværsnitsformen er "cirkulær"</b>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_foeringsroer'			,'Primær forsyningsart'					,'forsyningsart'						,'{forsyn_art}'::text[]				,NULL			,'text'			,true		,NULL								,'ler_faelles_forsyningsart'		,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_ukendt_ledning'		,'Supplerende info'						,'supplerendeinfo'						,'{supp_info}'::text[]				,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 500\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 500 karakterer</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_afloeb_ledning'		,'Har fod'								,'harfod'								,NULL::text[]						,NULL			,'boolean'		,false		,'nej'								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_afloeb_ledning'		,'Ledningstransporttype'				,'ledningstransporttype'				,'{trans_type}'::text[]				,NULL			,'text'			,false		,'gravitation'						,'ler_afloeb_transporttype'			,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_afloeb_ledning'		,'Medietype'							,'medietype'							,'{med_typ}'::text[]				,NULL			,'text'			,false		,'regnvand'							,'ler_afloeb_medietype'				,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_afloeb_komponent'		,'Type'									,'type'									,'{komp_type}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_afloeb_komponenttype'			,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_afloeb_komponent'		,'Brøndform'							,'broendform'							,'{brondform}'::text[]				,NULL			,'text'			,true		,NULL								,'ler_afloeb_broendform'			,NULL						,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN NOT(COALESCE([type], '''') = ''brønd'')\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\n\tWHEN [type] = ''brønd''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																																				,'<p>Angives kun for typen "brønd"</p>')
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_afloeb_komponent'		,'Bund, diameter/bredde'				,'bunddiameterbredde'					,'{bund_dm_br}'::text[]				,NULL			,'float'		,false		,NULL								,NULL								,NULL						,NULL			,1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																	,'<p>Skal være &gt; 0</p>')
	,(true	,4		,NULL::text[]				,NULL::text[]							,'ler_afloeb_komponent'		,'Bund, længde'							,'bundlaengde'							,'{bundlaengd}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN NOT(\n\t\t\tCOALESCE([type], '''') = ''brønd''\n\t\t\tAND COALESCE([broendform], '''') IN(''kvadratisk'', ''rektangulær'')\n\t\t)\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\n\tWHEN [type] = ''brønd''\n\t\tAND [broendform] IN(''kvadratisk'', ''rektangulær'')\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																			,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Angives kun, hvis følgende gælder:</p>\n<ul>\n<li>typen er "brønd"</li>\n<li>brøndformen er "kvadratisk" eller "rektangulær"</li>\n</ul>')
	,(true	,5		,NULL::text[]				,NULL::text[]							,'ler_afloeb_komponent'		,'Bundkote'								,'bundkote'								,NULL::text[]						,NULL			,'float'		,false		,NULL								,NULL								,NULL						,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(true	,6		,NULL::text[]				,NULL::text[]							,'ler_afloeb_komponent'		,'Medietype'							,'medietype'							,'{med_typ}'::text[]				,NULL			,'text'			,false		,'regnvand'							,'ler_afloeb_medietype'				,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,7		,NULL::text[]				,NULL::text[]							,'ler_afloeb_komponent'		,'Topkote'								,'topkote'								,NULL::text[]						,NULL			,'float'		,false		,NULL								,NULL								,NULL						,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_el_ledning'			,'Type'									,'type'									,'{led_type}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_el_ledningstype'				,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_el_ledning'			,'Afdækning'							,'afdaekning'							,NULL::text[]						,NULL			,'text'			,false		,NULL								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 50\n\tTHEN FALSE\nEND'																																																																	,E'<p>Maks 50 karakterer</p>\n<br/>\n<p>Eksempelvis mursten, halve flange rør, markeringsbånd, dækbånd</p>')
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_el_ledning'			,'Antal kabler'							,'antalkabler'							,'{ant_kabler}'::text[]				,NULL			,'integer'		,false		,'1'								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																	,'<p>Skal være &gt; 0</p>')
	,(true	,4		,NULL::text[]				,NULL::text[]							,'ler_el_ledning'			,'Kabeltype'							,'kabeltype'							,NULL::text[]						,NULL			,'text'			,false		,NULL								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 50\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 50 karakterer</p>')
	,(true	,5		,NULL::text[]				,NULL::text[]							,'ler_el_ledning'			,'Spændingsniveau'						,'spaendingsniveau'						,'{spaend_niv}'::text[]				,NULL			,'float'		,false		,NULL								,NULL								,NULL						,NULL			,1		,'kV'	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_el_komponent'			,'Type'									,'type'									,'{komp_type}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_el_komponenttype'				,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_el_komponent'			,'Relativ niveau for blok'				,'relativniveau'						,'{niv_blok}'::text[]				,NULL			,'text'			,true		,NULL								,'ler_el_relativ_niveau'			,NULL						,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN NOT(COALESCE([type], '''') = ''rørblok'')\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																				,'<p>Må kun være angivet, hvis typen er "rørblok"</p>')
	,(false	,3		,NULL::text[]				,NULL::text[]							,'ler_el_komponent'			,'Spændingsniveau'						,'spaendingsniveau'						,'{spaend_niv}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,0		,'kV'	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_termisk_ledning'		,'Type'									,'type'									,'{led_type}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_termisk_ledningstype'			,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_termisk_ledning'		,'Indhold'								,'indhold'								,'{indh_type}'::text[]				,NULL			,'text'			,true		,NULL								,'ler_termisk_indholdstype'			,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_termisk_ledning'		,'Konstruktion'							,'konstruktion'							,'{konst_type}'::text[]				,NULL			,'text'			,true		,NULL								,'ler_termisk_konstruktiontype'		,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,4		,NULL::text[]				,NULL::text[]							,'ler_termisk_ledning'		,'Temperatur'							,'temperatur'							,NULL::text[]						,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,0		,'Cel'	,NULL						,NULL																																																																														,NULL)
	,(true	,5		,NULL::text[]				,NULL::text[]							,'ler_termisk_ledning'		,'Tryk'									,'tryk'									,NULL::text[]						,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,0		,'bar'	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_termisk_komponent'	,'Type'									,'type'									,'{komp_type}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_termisk_komponenttype'		,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_gas_ledning'			,'Type'									,'type'									,'{led_type}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_gas_ledningstype'				,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_gas_ledning'			,'Tryk'									,'tryk'									,NULL::text[]						,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,0		,'bar'	,NULL						,NULL																																																																														,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_gas_ledning'			,'Medietype'							,'medietype'							,'{med_typ}'::text[]				,NULL			,'text'			,true		,NULL								,'ler_gas_medietype'				,NULL						,NULL			,0		,NULL	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_gas_komponent'		,'Type'									,'type'									,'{komp_type}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_gas_komponenttype'			,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_gas_komponent'		,'Topkote'								,'topkote'								,NULL::text[]						,NULL			,'float'		,true		,NULL								,NULL								,NULL						,'min_max'		,0		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_olie_ledning'			,'Tryk'									,'tryk'									,NULL::text[]						,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,0		,'bar'	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_olie_ledning'			,'Type'									,'type'									,'{led_type}'::text[]				,NULL			,'text'			,true		,NULL								,NULL								,NULL						,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 50\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 50 karakterer</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_olie_komponent'		,'Type'									,'type'									,'{komp_type}'::text[]				,NULL			,'text'			,false		,NULL								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 50\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 50 karakterer</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_tele_ledning'			,'Type'									,'type'									,'{led_type}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_tele_ledningstype'			,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_tele_komponent'		,'Type'									,'type'									,'{komp_type}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_tele_komponenttype'			,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_vand_komponent'		,'Type'									,'type'									,'{komp_type}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_vand_komponenttype'			,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_vand_komponent'		,'Tapstedstype'							,'tapstedstype'							,'{tapst_type}'::text[]				,NULL			,'text'			,true		,NULL								,'ler_vand_tapsted'					,NULL						,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN NOT(COALESCE([type], '''') = ''tapsted'')\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\n\tWHEN [type] = ''tapsted''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																																																				,'<p>Angives kun for typen "tapsted"</p>')
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_vand_komponent'		,'Anborsted'							,'anborsted'							,NULL::text[]						,NULL			,'text'			,true		,NULL								,'ler_vand_anborsted'				,NULL						,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN NOT(COALESCE([type], '''') = ''tilslutningspunkt'')\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\n\tWHEN [type] = ''tilslutningspunkt''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																																																		,'<p>Angives kun for typen "tilslutningspunkt"</p>')
	,(true	,4		,NULL::text[]				,NULL::text[]							,'ler_vand_komponent'		,'Bundkote'								,'bundkote'								,NULL::text[]						,NULL			,'float'		,false		,NULL								,NULL								,NULL						,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(true	,5		,NULL::text[]				,NULL::text[]							,'ler_vand_komponent'		,'Stutskote'							,'stutskote'							,NULL::text[]						,NULL			,'float'		,true		,NULL								,NULL								,NULL						,'min_max'		,-1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\n\tWHEN NOT(COALESCE([type], '''') IN(''tapsted'', ''ventil''))\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\n\tWHEN [type] IN(''tapsted'', ''ventil'')\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																																					,'<p>Angives kun for typerne "tapsted" og "ventil"</p>')
	,(true	,6		,NULL::text[]				,NULL::text[]							,'ler_vand_komponent'		,'Topkote'								,'topkote'								,NULL::text[]						,NULL			,'float'		,false		,NULL								,NULL								,NULL						,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_anden_ledning'		,'Forsyningsart'						,'forsyningsart'						,'{forsyn_art}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_faelles_forsyningsart'		,'type ~* ''^other: '''		,NULL			,1		,NULL	,NULL						,NULL																																																																														,'<p>Forsyningsarten må ikke være en af de prædefinerede værdier fra kodelisten Forsyningsart. Note: Hvis man har behov for at afgive oplysninger om en ledning som har en forsyningsart som er prædefineret i kodelisten Forsyningsart, så skal man i stedet for AndenLedning bruge den subklasse af Ledning som hører til den forsyningsart. Fx Telekommunikationsledning for forsyningsarten telekommunikation.</p>')
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_anden_ledning'		,'Tværsnitsform'						,'tvaersnitsform'						,'{tvaerform}'::text[]				,NULL			,'text'			,false		,'cirkulær'							,'ler_faelles_tvaersnitsform'		,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_anden_ledning'		,'Type'									,'type'									,'{led_type}'::text[]				,NULL			,'text'			,false		,NULL								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 50\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 50 karakterer</p>')
	,(true	,4		,NULL::text[]				,NULL::text[]							,'ler_anden_ledning'		,'Udvendig bredde'						,'udvendigbredde'						,'{udven_bre}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [tvaersnitsform] != ''cirkulær''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [tvaersnitsform] = ''cirkulær''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'												,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Skal være angivet, hvis følgende gælder:</p>\n<ul>\n<li>etableringstidspunktet er efter skæringsdatoen</li>\n<li>tværsnitsformen ikke er "cirkulær"</li>\n</ul>\n<hr class="tooltip_break"/>\n<b>MEN må ikke være angivet, hvis tværsnitsformen er "cirkulær"</b>')
	,(true	,5		,NULL::text[]				,NULL::text[]							,'ler_anden_ledning'		,'Udvendig højde'						,'udvendighoejde'						,'{udven_hoj}'::text[]				,NULL			,'float'		,true		,NULL								,NULL								,NULL						,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN etablering_foer_skaering IS FALSE\n\t\tAND [tvaersnitsform] != ''cirkulær''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [tvaersnitsform] = ''cirkulær''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'												,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Skal være angivet, hvis følgende gælder:</p>\n<ul>\n<li>etableringstidspunktet er efter skæringsdatoen</li>\n<li>tværsnitsformen ikke er "cirkulær"</li>\n</ul>\n<hr class="tooltip_break"/>\n<b>MEN må ikke være angivet, hvis tværsnitsformen er "cirkulær"</b>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_anden_komponent'		,'Forsyningsart'						,'forsyningsart'						,'{forsyn_art}'::text[]				,NULL			,'text'			,false		,NULL								,'ler_faelles_forsyningsart'		,'type ~* ''^other: '''		,NULL			,1		,NULL	,NULL						,NULL																																																																														,'<p>Forsyningsarten må ikke være en af de prædefinerede værdier fra kodelisten Forsyningsart. Note: Hvis man har behov for at afgive oplysninger om en ledning som har en forsyningsart som er prædefineret i kodelisten Forsyningsart, så skal man i stedet for AndenLedning bruge den subklasse af Ledning som hører til den forsyningsart. Fx Telekommunikationsledning for forsyningsarten telekommunikation.</p>')
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_anden_komponent'		,'Type'									,'type'									,'{komp_type}'::text[]				,NULL			,'text'			,false		,NULL								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 50\n\tTHEN FALSE\nEND'																																																																	,'<p>Maks 50 karakterer</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'ler_omlagtfjernet'		,'GML ID'								,'gml_id'								,NULL::text[]						,NULL			,'text'			,true		,NULL								,NULL								,NULL						,'no_control'	,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'ler_omlagtfjernet'		,'Objekttype'							,'objecttype'							,NULL::text[]						,NULL			,'text'			,true		,NULL								,NULL								,NULL						,'no_control'	,0		,NULL	,NULL						,NULL																																																																														,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'ler_omlagtfjernet'		,'Fjernet'								,'fjernet'								,NULL::text[]						,NULL			,'boolean'		,true		,'ja'								,NULL								,NULL						,NULL			,1		,NULL	,NULL						,NULL																																																																														,NULL)
;

/* -- TRUNCATE sandbox.kontrol_lst_attributter RESTART IDENTITY; */
INSERT INTO sandbox.kontrol_lst_attributter(
	  aktiv	,_order	,forsyningsart_incl_lst		,forsyningsart_excl_lst					,pakke											,navn_pretty							,navn									,navn_lst																,beskrivelse																																																		,data_type		,nillable	,default_value						,opslagstabel								,opslagstabel_filter							,kontrol_type	,fejl	,enhed	,restriktion_beskrivelse	,restriktion_sql																																																																																									,tooltip_html
) VALUES
	 -- (true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_type'					,'Ledningstype'							,'ledning_type'							,'{type,ledn_type}'::text[]												,'Ledningens type definerer hvilke attributter er relevante'																																						,'text'			,false		,NULL								,'kkafloeb_ledning_ledning_type'			,NULL											,NULL			,1		,NULL	,'Fejler altid, skal lande i specifik featuretype'	,'FALSE'																																																																																												,NULL)
	 (true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_type'					,'Ledningstype'							,'ledning_type'							,'{type,ledn_type}'::text[]												,'Ledningens type definerer hvilke attributter er relevante'																																						,'text'			,false		,'Ledning'							,'kkafloeb_ledning_ledning_type'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_type_ledn'			,'Ledningstype'							,'ledning_type'							,'{type,ledn_type}'::text[]												,'Ledningens type definerer hvilke attributter er relevante'																																						,'text'			,false		,'Ledning'							,'kkafloeb_ledning_ledning_type'			,'beskrivelse = ''Ledning'''					,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_type_strmvj'			,'Ledningstype'							,'ledning_type'							,'{type,ledn_type}'::text[]												,'Ledningens type definerer hvilke attributter er relevante'																																						,'text'			,false		,'Strømningsvej'					,'kkafloeb_ledning_ledning_type'			,'beskrivelse = ''Strømningsvej'''				,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,21		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_linie'				,'Status'								,'status'								,'{driftsstatus,driftsstat}'::text[]									,'Livscyklus'																																																		,'text'			,false		,'I brug'							,'kkafloeb_faelles_status'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_generel_etablering'	,'Etableringsdato'						,'datoetableret'						,'{dato_etabl,etableringstidspunkt,etab_tid}'::text[]					,'Dato for den fysiske etablering'																																													,'date'			,false		,NULL								,NULL										,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_generel_etablering'	,'Etableringsdato, nøjagtighed'			,'datoetableret_noejagtighed'			,'{noej_etabl,dato_noej,etabl_noej}'::text[]							,'Nøjagtigheden af dato for den fysiske etablering'																																									,'text'			,true		,NULL								,'kkafloeb_faelles_dato_noejagtighed'		,NULL											,'hidden_attr'	,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,14		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_generel_noejagtighed'	,'Nøjagtighed, XY'						,'noejagtighed_xy'						,'{noejagt_xy,noejagtighedsklasse,nojagt_kla}'::text[]					,'Nøjagtigheden for X/Y-koordinater'																																												,'text'			,false		,'+/- 0,25m'						,'kkafloeb_faelles_noejagtighed'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,16		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_generel_noejagtighed'	,'Nøjagtighed, Z'						,'noejagtighed_z_topkote'				,'{noejagt_z,noejagtighedsklasse,nojagt_kla}'::text[]					,'Nøjagtigheden for Z-koordinater (topkote)'																																										,'text'			,false		,'+/- 0,25m'						,'kkafloeb_faelles_noejagtighed'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,21		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_generel_ler'			,'Fareklasse'							,'fareklasse'							,'{fareklas}'::text[]													,'Fareklasse jf. LER. Default ved NULL: ikke farlig'																																								,'text'			,false		,'Ikke farlig'						,'kkafloeb_faelles_ler_fareklasse'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,23		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_generel_ler'			,'Sikkerhedshensyn'						,'sikkerhedshensyn'						,'{sik_hensyn}'::text[]													,'Sikkerhedshensyn jf. LER'																																															,'text'			,true		,NULL								,NULL										,NULL											,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 500\n\tTHEN FALSE\nEND'																																																																															,'<p>Maks 500 karakterer</p>')
	,(true	,25		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_generel_ler'			,'Placering'							,'placering'							,'{niveau}'::text[]														,'Placering ift. terræn jf. LER'																																													,'text'			,false		,'Under terræn'						,'kkafloeb_faelles_placering'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_ledning'				,'Ledningskategori'						,'ledning_kategori'						,'{kategori}'::text[]													,'Hvordan ledningen overordnet set indgår i netværket'																																								,'text'			,false		,'Stikledning'						,'kkafloeb_ledning_ledning_kategori'		,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_ledning'				,'Ledningsfunktion'						,'ledning_funktion'						,'{funktion}'::text[]													,'Ledningens funktion i netværket. Kan betragtes som underklassifikation til ledningskategorien'																													,'text'			,false		,'Alm. Ledning'						,'kkafloeb_ledning_ledning_funktion'		,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_ledning'				,'Transportform'						,'ledning_transport'					,'{transport,ledningstransporttype,trans_type}'::text[]					,'Transportform i ledning'																																															,'text'			,false		,'Gravitation'						,'kkafloeb_ledning_ledning_transport'		,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,4		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_ledning'				,'Medie'								,'medie'								,'{medietype,med_typ}'::text[]											,'Medie, som løber i ledningen'																																														,'text'			,false		,'Regnvand'							,'kkafloeb_faelles_medie'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,10		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_ledning'				,'Fald'									,'fald_prm'								,'{fald}'::text[]														,'Ledningens gennemsnitlige fald fra start til slut regnet over den plane længde (o/oo). Faldet svarer ikke til det fald, der kan udregnes'																			,'float'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'‰'	,NULL						,NULL																																																																																												,NULL)
	,(true	,13		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_ledning'				,'Bemærkning'							,'bemaerkning'							,'{bemaerkn,note_intern}'::text[]										,'Bemærkning'																																																		,'text'			,true		,NULL								,NULL										,NULL											,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 250\n\tTHEN FALSE\nEND'																																																																															,'<p>Maks 250 karakterer</p>')

	,(true	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_roer'					,'Materiale'							,'roer_materiale'						,'{materiale,udvendigmateriale,udven_mate}'::text[]						,'Rørets materiale'																																																	,'text'			,false		,NULL								,'kkafloeb_faelles_materiale'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,6		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_roer'					,'Tværprofil'							,'roer_tvaerprofil'						,'{tvaerprof,tvaerprofil,tvaersnitsform,tvaerform}'::text[]				,'Rørets form'																																																		,'text'			,false		,'Cirkulært'						,'kkafloeb_ledning_tvaerprofil'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,7		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_roer'					,'Handelsmål'							,'roer_handelsmaal_mm'					,'{handels_ml,handelsmaal,udvendigdiameter,udven_dm}'::text[]			,'Dimension (mm)'																																																	,'float'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(true	,11		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_roer'					,'Bredde, udvendig'						,'roer_bredde_udvendig_mm'				,'{bredde_udv,bredde_udvendig,udvendigbredde,udven_bre}'::text[]		,'Bredde, udvendig (mm)'																																															,'float'		,true		,NULL								,NULL										,NULL											,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN [roer_tvaerprofil] != ''Cirkulært''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [roer_tvaerprofil] = ''Cirkulært''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																			,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Angives kun når tværprofil ikke er "Cirkulært"</p>')
	,(true	,12		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_roer'					,'Højde, udvendig'						,'roer_hoejde_udvendig_mm'				,'{hoejde_udv,hoejde_udvendig,udvendighoejde,udven_hoj}'::text[]		,'Højde, udvendig (mm)'																																																,'float'		,true		,NULL								,NULL										,NULL											,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN [roer_tvaerprofil] != ''Cirkulært''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [roer_tvaerprofil] = ''Cirkulært''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																			,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Angives kun når tværprofil ikke er "Cirkulært"</p>')
	,(true	,16		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_ledning_roer'					,'Med fod'								,'roer_medfod'							,'{medfod,harfod}'::text[]												,'Røret er med fod'																																																	,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)


	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_type'					,'Knudetype'							,'knude_type'							,'{type,komp_type}'::text[]												,'Knudens type definerer hvilke attributter er relevante'																																							,'text'			,false		,NULL								,'kkafloeb_knude_knude_type'				,NULL											,NULL			,1		,NULL	,'Fejler altid, skal lande i specifik featuretype'	,'FALSE'																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_type_broend'			,'Knudetype'							,'knude_type'							,'{type,komp_type}'::text[]												,'Knudens type definerer hvilke attributter er relevante'																																							,'text'			,false		,'Brønd'							,'kkafloeb_knude_knude_type'				,'beskrivelse = ''Brønd'''						,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_type_udloeb'			,'Knudetype'							,'knude_type'							,'{type,komp_type}'::text[]												,'Knudens type definerer hvilke attributter er relevante'																																							,'text'			,false		,'Udløb'							,'kkafloeb_knude_knude_type'				,'beskrivelse = ''Udløb'''						,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_type_afsp'				,'Knudetype'							,'knude_type'							,'{type,komp_type}'::text[]												,'Knudens type definerer hvilke attributter er relevante'																																							,'text'			,false		,'Afspærring'						,'kkafloeb_knude_knude_type'				,'beskrivelse = ''Afspærring'''					,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_type_ovrl'				,'Knudetype'							,'knude_type'							,'{type,komp_type}'::text[]												,'Knudens type definerer hvilke attributter er relevante'																																							,'text'			,false		,'Overløbskant'						,'kkafloeb_knude_knude_type'				,'beskrivelse = ''Overløbskant'''				,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_type_pmpst'				,'Knudetype'							,'knude_type'							,'{type,komp_type}'::text[]												,'Knudens type definerer hvilke attributter er relevante'																																							,'text'			,false		,'Pumpested'						,'kkafloeb_knude_knude_type'				,'beskrivelse = ''Pumpested'''					,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_type_retnreg'			,'Knudetype'							,'knude_type'							,'{type,komp_type}'::text[]												,'Knudens type definerer hvilke attributter er relevante'																																							,'text'			,false		,'Retningsregulering'				,'kkafloeb_knude_knude_type'				,'beskrivelse = ''Retningsregulering'''			,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_type_sep'				,'Knudetype'							,'knude_type'							,'{type,komp_type}'::text[]												,'Knudens type definerer hvilke attributter er relevante'																																							,'text'			,false		,'Separator'						,'kkafloeb_knude_knude_type'				,'beskrivelse = ''Separator'''					,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_type_ventil'			,'Knudetype'							,'knude_type'							,'{type,komp_type}'::text[]												,'Knudens type definerer hvilke attributter er relevante'																																							,'text'			,false		,'Ventil'							,'kkafloeb_knude_knude_type'				,'beskrivelse = ''Ventil'''						,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,11		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_knude'					,'Navn'									,'navn_tidl'							,'{navn}'::text[]														,'Tidligere navne for knuden. Styres af databasen'																																									,'text'			,true		,NULL								,NULL										,NULL											,'no_control'	,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,16		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_knude'					,'Status'								,'status'								,'{driftsstatus,driftsstat}'::text[]									,'Livscyklus'																																																		,'text'			,false		,'I brug'							,'kkafloeb_faelles_status'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_generel_etablering'		,'Etableringsdato'						,'datoetableret'						,'{dato_etabl,etableringstidspunkt,etab_tid}'::text[]					,'Dato for den fysiske etablering'																																													,'date'			,false		,NULL								,NULL										,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_generel_etablering'		,'Etableringsdato, nøjagtighed'			,'datoetableret_noejagtighed'			,'{noej_etabl,dato_noej,etabl_noej}'::text[]							,'Nøjagtigheden af dato for den fysiske etablering'																																									,'text'			,true		,NULL								,'kkafloeb_faelles_dato_noejagtighed'		,NULL											,'hidden_attr'	,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_generel_koter_mv'		,'Bundkote'								,'bundkote'								,NULL::text[]															,'Bundkote i meter over havet jf. anvendt kotesystem'																																								,'float'		,false		,NULL								,NULL										,NULL											,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(true	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_generel_koter_mv'		,'Topkote'								,'topkote'								,NULL::text[]															,'Topkote i meter over havet jf. anvendt kotesystem'																																								,'float'		,false		,NULL								,NULL										,NULL											,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(true	,15		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_generel_noejagtighed'	,'Nøjagtighed, XY'						,'noejagtighed_xy'						,'{noejagt_xy,noejagtighedsklasse,nojagt_kla}'::text[]					,'Nøjagtigheden for X/Y-koordinater'																																												,'text'			,false		,'+/- 0,25m'						,'kkafloeb_faelles_noejagtighed'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,17		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_generel_noejagtighed'	,'Nøjagtighed, bundkote'				,'noejagtighed_bundkote'				,'{noejagt_bd,noejagtighedsklasse,nojagt_kla}'::text[]					,'Nøjagtigheden for bundkote'																																														,'text'			,false		,'+/- 0,25m'						,'kkafloeb_faelles_noejagtighed'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,21		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_generel_noejagtighed'	,'Nøjagtighed, topkote'					,'noejagtighed_topkote'					,'{noejagt_tp,noejagtighedsklasse,nojagt_kla}'::text[]					,'Nøjagtigheden for topkote'																																														,'text'			,false		,'+/- 0,25m'						,'kkafloeb_faelles_noejagtighed'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,26		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_generel_ler'			,'Fareklasse'							,'fareklasse'							,'{fareklas}'::text[]													,'Fareklasse jf. LER. Default ved NULL: ikke farlig'																																								,'text'			,false		,'Ikke farlig'						,'kkafloeb_faelles_ler_fareklasse'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,27		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_generel_ler'			,'Sikkerhedshensyn'						,'sikkerhedshensyn'						,'{sik_hensyn}'::text[]													,'Sikkerhedshensyn jf. LER'																																															,'text'			,true		,NULL								,NULL										,NULL											,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 500\n\tTHEN FALSE\nEND'																																																																															,'<p>Maks 500 karakterer</p>')

	,(true	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_funktion'				,'Medie'								,'medie'								,'{medietype,med_typ}'::text[]											,'Typen af medie i knuden'																																															,'text'			,false		,'Regnvand'							,'kkafloeb_faelles_medie'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,4		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_funktion'				,'Materiale'							,'materiale'							,'{udvendigmateriale,udven_mate}'::text[]								,'Knudens materiale'																																																,'text'			,true		,NULL								,'kkafloeb_faelles_materiale'				,NULL											,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN [knude_type] = ''Brønd'' AND [KOLONNE] IS NULL\n\tTHEN FALSE\nEND'																																																																									,'<p>Skal være angivet, hvis typen er "Brønd"</p>')
	,(true	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_funktion'				,'Bemærkning'							,'bemaerkning'							,'{bemaerkn,note_intern}'::text[]										,'Bemærkning'																																																		,'text'			,true		,NULL								,NULL										,NULL											,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 250\n\tTHEN FALSE\nEND'																																																																															,'<p>Maks 250 karakterer</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_broend'					,'Brønd, type'							,'broend'								,NULL::text[]															,'Typen af brønd'																																																	,'text'			,false		,'Rendestens brønd'					,'kkafloeb_knude_broend'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_broend'					,'Brønd, form'							,'broendform'							,'{brondform}'::text[]													,'Brøndens form'																																																	,'text'			,false		,'Cirkulær'							,'kkafloeb_knude_broendform'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_broend'					,'Bund, diameter/bredde'				,'bund_diameter_bredde_mm'				,'{bund_dm_br}'::text[]													,'Diameter eller bredde. Handelsmål (mm)'																																											,'integer'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(true	,6		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_broend'					,'Bund, længde'							,'bund_laengde_mm'						,'{bundlaengd}'::text[]													,'Længde af brøndbund målt i afløbsledningens længderetning ved firkantet brønd. Indvendigt mål (mm)'																												,'integer'		,true		,NULL								,NULL										,NULL											,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN [broendform] != ''Cirkulær''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [broendform] = ''Cirkulær''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																							,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Angives kun når brøndform ikke er "Cirkulær"</p>')
	,(false	,9		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_broend'					,'Kritisk kote'							,'kritiskkote'							,'{kritisk_kt}'::text[]													,'Angiver koten til det kritiske niveau, som modsvarer det funktionskrav der er defineret for hhv. afløbssystemet og for regnvand på terræn. Det kan f.eks. svare til opstuvning på terræn én gang hvert tiende år'	,'float'		,true		,NULL								,NULL										,NULL											,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')

	,(false	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_udloeb'					,'Recipientkote'						,'recipientkote'						,'{recip_kt}'::text[]													,'Kote for vandspejl ved udløb'																																														,'float'		,false		,NULL								,NULL										,NULL											,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(false	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_udloeb'					,'Dykket udløb'							,'dykket_udloeb'						,'{dykket}'::text[]														,'Dykket udløb'																																																		,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_afsp'					,'Afspærring, type'						,'afspaerring'							,'{afsp}'::text[]														,'Typen af afspærring'																																																,'text'			,false		,NULL								,'kkafloeb_knude_afspaerring'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_afsp'					,'Maks. vandføring'						,'afsp_vandfoering_max_ls'				,'{afsp_vandf}'::text[]													,'Dimensioneret maksimal vandføring (l/sek)'																																										,'float'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'l/sek',NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')

	,(true	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ovrl'					,'Overløbskant, type'					,'overloeb_type'						,'{ovrl_type}'::text[]													,'Typen af overløb'																																																	,'text'			,false		,'Overløb'							,'kkafloeb_knude_overloeb_type'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ovrl'					,'Beregningsmetode'						,'overloeb_beregning'					,'{ovrl_bereg}'::text[]													,'Beregningsmetode for beregning i hydrauliske modeller'																																							,'text'			,false		,NULL								,'kkafloeb_knude_overloeb_beregning'		,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ovrl'					,'Formkant'								,'formkant'								,NULL::text[]															,'Form på kant'																																																		,'text'			,false		,NULL								,'kkafloeb_knude_overloebkant'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,4		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ovrl'					,'Funktionstid'							,'funktionstid_t_aar'					,'{funk_tid}'::text[]													,'Angiver hvor mange timer overløbsbygværket i gennemsnit forventes at aflaste pr år (timer/år)'																													,'integer'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'t/år'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ovrl'					,'Kantkote'								,'kantkote'								,NULL::text[]															,'Kantkote (m)'																																																		,'float'		,false		,NULL								,NULL										,NULL											,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(false	,6		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ovrl'					,'Kantlængde'							,'kantlaengde_m'						,'{kantlaengd}'::text[]													,'Effektiv kantlængde (m)'																																															,'float'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'m'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,7		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ovrl'					,'Maks. vandføring'						,'ovrl_vandfoering_max_ls'				,'{ovrl_vandf}'::text[]													,'Dimensioneret maksimal vandføring (l/sek) i overløbet'																																							,'float'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'l/sek',NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,8		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ovrl'					,'Bøjeklap'								,'boejeklap'							,NULL::text[]															,'Er overløbskanten monteret med bøjeklap'																																											,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,9		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ovrl'					,'Internt'								,'internt'								,NULL::text[]															,'Markering, om det er et internt overløb til anden ledning i afløbsnettet'																																			,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,10		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ovrl'					,'Regulerbart'							,'regulerbart'							,'{regulerbar}'::text[]													,'Regulerbar kant, f.eks. en højderegulering. Er der tilknyttet anden regulering, skal dette registreres særskilt, og funktionerne samles i en konstruktion'														,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_pmpst'					,'Pumpested, type'						,'pumpested'							,NULL::text[]															,'Typen af pumpested'																																																,'text'			,false		,NULL								,'kkafloeb_knude_pumpested'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_pmpst'					,'Antal pumper'							,'antal_pumper'							,'{ant_pumper}'::text[]													,'Antal pumper på pumpestedet'																																														,'integer'		,false		,'1'								,NULL										,NULL											,NULL			,1		,'stk'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_pmpst'					,'Løftehøjde ved maks. flow'			,'loeftehoejde_mvs'						,'{lft_hoejd}'::text[]													,'Løftehøjde ved max flow (mVs)'																																													,'float'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'mVs'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,4		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_pmpst'					,'Maks. flow'							,'max_flow_ls'							,'{max_flow}'::text[]													,'Max flowkapacitet (l/sek). Bruges bl.a. til benchmarking'																																							,'float'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'l/sek',NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_pmpst'					,'Parallel installation'				,'parallel_pumper'						,'{parallel}'::text[]													,'Markering af om pumperne (hvis flere) er sat i parallel installation'																																				,'text'			,false		,'Ja'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_retnreg'				,'Retningsregulering, type'				,'retnings_regulering'					,'{retnreg}'::text[]													,'Typen af retningsregulering'																																														,'text'			,false		,NULL								,'kkafloeb_knude_retnings_regulering'		,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_sep'					,'Separator, type'						,'separator'							,NULL::text[]															,'Typen af separator'																																																,'text'			,false		,NULL								,'kkafloeb_knude_separator'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ventil'					,'Ventil, type'							,'ventil'								,NULL::text[]															,'Typen af ventil'																																																	,'text'			,false		,NULL								,'kkafloeb_knude_ventil'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_ventil'					,'Åbningsgrad'							,'vnt_aktuel_aabningsgrad_pct'			,'{aabninggrd}'::text[]													,'Aktuel åbningsgrad (0-100%) 0 = Lukket, 100 = fuldt åben'																																							,'integer'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'%'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0 OR [KOLONNE]::numeric > 100\n\tTHEN FALSE\nEND'																																																																								,'<p>Skal være mellem 0 og 100</p>')

	,(true	,9		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk'					,'Vandlås'								,'vandlaas_bstk'						,'{vndls_bstk}'::text[]													,'Brønden er udstyret med vandlås'																																													,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL /* 'beskrivelse = ''Ja''' */				,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,333	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk'					,'Sandfangsbund'						,'sandfangsbund_bstk'					,'{sfng_bstk}'::text[]													,'Sandfangsbund'																																																	,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL /* 'beskrivelse = ''Ja''' */				,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,112	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk'					,'Dæksel'								,'daeksel_bstk'							,'{dksl_bstk}'::text[]													,'Dæksel'																																																			,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL /* 'beskrivelse = ''Ja''' */				,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,231	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk'					,'Rottespærre'							,'rottespaerre_bstk'					,'{rtspr_bstk}'::text[]													,'Rottespærre'																																																		,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL /* 'beskrivelse = ''Ja''' */				,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,412	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk'					,'Nedløbsrist'							,'nedloebsrist_bstk'					,'{nedlb_bstk}'::text[]													,'Nedløbsrist'																																																		,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL /* 'beskrivelse = ''Ja''' */				,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,112	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_dksl'				,'Dæksel'								,'daeksel_bstk'							,'{dksl_bstk}'::text[]													,'Dæksel'																																																			,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL /* 'beskrivelse = ''Ja''' */				,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,113	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_dksl'				,'Dæksel, form'							,'daeksel_form'							,'{dksl_form}'::text[]													,'Dækslets form'																																																	,'text'			,true		,NULL								,'kkafloeb_knude_daeksel_ristform'			,NULL											,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [daeksel_bstk] = ''Ja''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [daeksel_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																				,'<p>Angives kun når dæksel er "Ja"</p>')
	,(false	,114	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_dksl'				,'Dæksel, materiale'					,'daeksel_materiale'					,'{dksl_mat}'::text[]													,'Dækslets materiale'																																																,'text'			,true		,NULL								,'kkafloeb_faelles_materiale'				,NULL											,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [daeksel_bstk] = ''Ja''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [daeksel_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																				,'<p>Angives kun når dæksel er "Ja"</p>')
	,(false	,115	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_dksl'				,'Dæksel, diameter/bredde'				,'daeksel_diameter_bredde_mm'			,'{dksl_dm_br}'::text[]													,'Diameter eller bredde, udvendig (mm)'																																												,'integer'		,true		,NULL								,NULL										,NULL											,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN [daeksel_bstk] = ''Ja''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [daeksel_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																									,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Angives kun når dæksel er "Ja"</p>')
	,(false	,116	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_dksl'				,'Dæksel, længde'						,'daeksel_laengde_mm'					,'{dksl_lgd}'::text[]													,'Længde (mm)'																																																		,'integer'		,true		,NULL								,NULL										,NULL											,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN [daeksel_bstk] = ''Ja''\n\t\tAND [daeksel_form] != ''Rundt''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [daeksel_bstk] = ''Ja''\n\t\tAND [daeksel_form] = ''Rundt''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\n\tWHEN [daeksel_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'			,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Angives kun når dæksel er "Ja" og dæksel, form ikke er "Rundt"</p>')
	,(false	,124	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_dksl'				,'Dæksel, lås'							,'daeksel_laas'							,'{dksl_laas}'::text[]													,'Dækslet har lås'																																																	,'text'			,true		,NULL								,'kkafloeb_faelles_ja_nej'					,'beskrivelse = ''Ja'''							,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [daeksel_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																																							,'<p>Angives kun når dæksel er "Ja" og med lås</p>')
	,(true	,231	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_rtspr'				,'Rottespærre'							,'rottespaerre_bstk'					,'{rtspr_bstk}'::text[]													,'Rottespærre'																																																		,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL /* 'beskrivelse = ''Ja''' */				,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,232	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_rtspr'				,'Rottespærre, type'					,'rottespaerre'							,'{rtspr}'::text[]														,'Typen af rottespærre'																																																,'text'			,true		,NULL								,'kkafloeb_knude_rottespaerre'				,NULL											,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [rottespaerre_bstk] = ''Ja''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [rottespaerre_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																		,'<p>Angives kun når rottespærre er "Ja"</p>')
	,(true	,412	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_nedlb'				,'Nedløbsrist'							,'nedloebsrist_bstk'					,'{nedlb_bstk}'::text[]													,'Nedløbsrist'																																																		,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL /* 'beskrivelse = ''Ja''' */				,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,413	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_nedlb'				,'Nedløbsrist, form'					,'rist_form'							,NULL::text[]															,'Nedløbsristens form'																																																,'text'			,true		,NULL								,'kkafloeb_knude_daeksel_ristform'			,NULL											,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [nedloebsrist_bstk] = ''Ja''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [nedloebsrist_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																		,'<p>Angives kun når nedløbsrist er "Ja"</p>')
	,(false	,414	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_nedlb'				,'Nedløbsrist, materiale'				,'rist_materiale'						,'{rist_mat}'::text[]													,'Nedløbsristens materiale'																																															,'text'			,true		,NULL								,'kkafloeb_faelles_materiale'				,NULL											,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [nedloebsrist_bstk] = ''Ja''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [nedloebsrist_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																		,'<p>Angives kun når nedløbsrist er "Ja"</p>')
	,(false	,415	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_nedlb'				,'Nedløbsrist, diameter/bredde'			,'rist_diameter_bredde_mm'				,'{rist_dm_br}'::text[]													,'Diameter eller bredde, udvendig (mm)'																																												,'integer'		,true		,NULL								,NULL										,NULL											,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN [nedloebsrist_bstk] = ''Ja''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [nedloebsrist_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																						,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Angives kun når nedløbsrist er "Ja"</p>')
	,(false	,416	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_nedlb'				,'Nedløbsrist, længde'					,'rist_laengde_mm'						,'{rist_lgd}'::text[]													,'Længde (mm)'																																																		,'integer'		,true		,NULL								,NULL										,NULL											,NULL			,-1		,'mm'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN [nedloebsrist_bstk] = ''Ja''\n\t\tAND [rist_form] != ''Rundt''\n\t\tAND [KOLONNE] IS NULL\n\tTHEN FALSE\n\tWHEN [nedloebsrist_bstk] = ''Ja''\n\t\tAND [rist_form] = ''Rundt''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\n\tWHEN [nedloebsrist_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'	,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Angives kun når nedløbsrist er "Ja" og nedløbsrist, form ikke er "Rundt"</p>')
	,(false	,419	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_nedlb'				,'Nedløbsrist, kuppelformet'			,'rist_kuppelformet'					,'{rist_kuppl}'::text[]													,'Nedløbsristen er kuppelformet'																																													,'text'			,true		,NULL								,'kkafloeb_faelles_ja_nej'					,'beskrivelse = ''Ja'''							,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [nedloebsrist_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																																					,'<p>Angives kun når nedløbsrist er "Ja" og med kuppelformet rist</p>')
	,(false	,422	,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_knude_bstk_nedlb'				,'Nedløbsrist, lås'						,'rist_laas'							,NULL::text[]															,'Nedløbsristen har lås'																																															,'text'			,true		,NULL								,'kkafloeb_faelles_ja_nej'					,'beskrivelse = ''Ja'''							,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [nedloebsrist_bstk] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																																					,'<p>Angives kun når nedløbsrist er "Ja" og med lås</p>')


--	  aktiv	,_order	,forsyningsart_incl_lst		,forsyningsart_excl_lst					,pakke											,navn_pretty							,navn									,navn_lst																,beskrivelse																																																		,data_type		,nillable	,default_value								,opslagstabel								,opslagstabel_filter											,kontrol_type	,fejl	,enhed	,restriktion_beskrivelse	,restriktion_sql																																																																																									,tooltip_html
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type'					,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,NULL										,'kkafloeb_konstr_konstruktion_type'		,NULL															,NULL			,1		,NULL	,'Fejler altid, skal lande i specifik featuretype'	,'FALSE'																																																																																					,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_broendbyg'		,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Brøndbygværk'								,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Brøndbygværk'''								,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_etgbroend'		,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Etagebrønd'								,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Etagebrønd'''									,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_ovrlbyg'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Overløbsbygværk'							,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Overløbsbygværk'''							,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_pmpst'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Pumpestation'								,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Pumpestation'''								,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_regbyg'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Reguleringsbygværk'						,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Reguleringsbygværk'''							,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_smlkons'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Samlekonstruktion'						,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Samlekonstruktion'''							,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_udloebbyg'		,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Udløbsbygværk'							,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Udløbsbygværk'''								,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_udsklbyg'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Udskillerbygværk'							,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Udskillerbygværk'''							,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_mgsn'				,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Magasin'									,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Magasin'''									,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_bassin'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Bassin'									,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Bassin'''										,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_nedsiv'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Nedsivningsanlæg'							,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Nedsivningsanlæg'''							,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_rens'				,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Renseanlæg'								,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Renseanlæg'''									,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_sandfang'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Sandfang'									,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Sandfang'''									,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_tank'				,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Tank'										,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Tank'''										,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_udskl'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Udskiller'								,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Udskiller'''									,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_trktaarn'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Tryktårn'									,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Tryktårn'''									,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_kote'				,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Kote'										,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Kote'''										,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_lndskb'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Landskabselement med hydraulisk effekt'	,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Landskabselement med hydraulisk effekt'''		,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_prmblbef'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Permeabel befæstelse'						,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Permeabel befæstelse'''						,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_regnbed'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Regnbed'									,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Regnbed'''									,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_rende'			,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Rende'									,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Rende'''										,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,0		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_type_grft'				,'Konstruktionstype'					,'konstruktion_type'					,'{type,komp_type}'::text[]												,'Konstruktionens type definerer hvilke attributter er relevante'																																					,'text'			,false		,'Grøft'									,'kkafloeb_konstr_konstruktion_type'		,'beskrivelse = ''Grøft'''										,'hidden'		,0		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,14		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_flade'					,'Navn'									,'navn_tidl'							,'{navn}'::text[]														,'Tidligere navne for konstruktionen. Styres af databasen'																																							,'text'			,true		,NULL								,NULL										,NULL											,'no_control'	,0		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,19		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_flade'					,'Status'								,'status'								,'{driftsstatus,driftsstat}'::text[]									,'Livscyklus'																																																		,'text'			,false		,'I brug'							,'kkafloeb_faelles_status'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_generel_etablering'	,'Etableringsdato'						,'datoetableret'						,'{dato_etabl,etableringstidspunkt,etab_tid}'::text[]					,'Dato for den fysiske etablering'																																													,'date'			,false		,NULL								,NULL										,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_generel_etablering'	,'Etableringsdato, nøjagtighed'			,'datoetableret_noejagtighed'			,'{noej_etabl,dato_noej,etabl_noej}'::text[]							,'Nøjagtigheden af dato for den fysiske etablering'																																									,'text'			,true		,NULL								,'kkafloeb_faelles_dato_noejagtighed'		,NULL											,'hidden_attr'	,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_generel_koter_mv'		,'Bundkote, udvendig'					,'bundkote_udvendig'					,'{bundkote}'::text[]													,'Konstruktionens bundkote udvendig'																																												,'float'		,false		,NULL								,NULL										,NULL											,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(true	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_generel_koter_mv'		,'Topkote, udvendig'					,'topkote_udvendig'						,'{topkote}'::text[]													,'Konstruktionens topkote udvendig'																																													,'float'		,false		,NULL								,NULL										,NULL											,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')

	,(true	,16		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_generel_noejagtighed'	,'Nøjagtighed, XY'						,'noejagtighed_xy'						,'{noejagt_xy,noejagtighedsklasse,nojagt_kla}'::text[]					,'Nøjagtigheden for X/Y-koordinater'																																												,'text'			,false		,'+/- 0,25m'						,'kkafloeb_faelles_noejagtighed'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,18		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_generel_noejagtighed'	,'Nøjagtighed, bundkote'				,'noejagtighed_bundkote'				,'{noejagt_bd,noejagtighedsklasse,nojagt_kla}'::text[]					,'Nøjagtigheden for bundkote'																																														,'text'			,false		,'+/- 0,25m'						,'kkafloeb_faelles_noejagtighed'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,22		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_generel_noejagtighed'	,'Nøjagtighed, topkote'					,'noejagtighed_topkote'					,'{noejagt_tp,noejagtighedsklasse,nojagt_kla}'::text[]					,'Nøjagtigheden for topkote'																																														,'text'			,false		,'+/- 0,25m'						,'kkafloeb_faelles_noejagtighed'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,27		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_generel_ler'			,'Fareklasse'							,'fareklasse'							,'{fareklas}'::text[]													,'Fareklasse jf. LER. Default ved NULL: ikke farlig'																																								,'text'			,false		,'Ikke farlig'						,'kkafloeb_faelles_ler_fareklasse'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,28		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_generel_ler'			,'Sikkerhedshensyn'						,'sikkerhedshensyn'						,'{sik_hensyn}'::text[]													,'Sikkerhedshensyn jf. LER'																																															,'text'			,true		,NULL								,NULL										,NULL											,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 500\n\tTHEN FALSE\nEND'																																																																															,'<p>Maks 500 karakterer</p>')

	,(true	,4		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_konstruktion'			,'Medie'								,'medie'								,'{medietype,med_typ}'::text[]											,'Typen af medie i konstruktionen'																																													,'text'			,false		,'Regnvand'							,'kkafloeb_faelles_medie'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,6		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_konstruktion'			,'Materiale'							,'materiale'							,'{udvendigmateriale,udven_mate}'::text[]								,'Konstruktionens materiale'																																														,'text'			,true		,NULL								,'kkafloeb_faelles_materiale'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,7		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_konstruktion'			,'Bemærkning'							,'bemaerkning'							,'{bemaerkn,note_intern}'::text[]										,'Bemærkning'																																																		,'text'			,true		,NULL								,NULL										,NULL											,NULL			,0		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 250\n\tTHEN FALSE\nEND'																																																																															,'<p>Maks 250 karakterer</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_ovrlbyg'				,'Overløbsbygværk, type'				,'overloeb'								,NULL::text[]															,'Typen af overløbsbygværk'																																															,'text'			,false		,NULL								,'kkafloeb_konstr_overloeb'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_pmpst'					,'Pumpestation, type'					,'pumpestation'							,'{pmpst}'::text[]														,'Typen af pumpestation'																																															,'text'			,false		,NULL								,'kkafloeb_konstr_pumpestation'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_pmpst'					,'Miljøklasse'							,'pumpest_miljoeklasse'					,'{pmpst_milj}'::text[]													,'Klasseinddeling i relation til begreber i benchmarking - knytter sig til, om der er lavet ekstra tiltag i relation til sikring af arbejdsmiljø'																	,'text'			,false		,NULL								,'kkafloeb_faelles_miljoeklasse'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_regbyg'				,'Reguleringsbygværk, type'				,'regulering'							,NULL::text[]															,'Reguleringsformål'																																																,'text'			,false		,NULL								,'kkafloeb_konstr_regulering'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_smlkons'				,'Samlekonstruktion, type'				,'saml_kons_type'						,'{smlkn_type}'::text[]													,'Typen af samlekonstruktion'																																														,'text'			,false		,NULL								,'kkafloeb_konstr_samlekonstruktion_type'	,NULL											,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN NOT(EXISTS(SELECT ''1'' FROM aflob.lst_samlekonstruktion_type l WHERE l.beskrivelse = [KOLONNE] AND geometritype = ANY(l.geometri_typer)))\n\tTHEN FALSE\nEND'																																																																																												,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_smlkons'				,'Beskrivelse'							,'saml_kons_beskrivelse'				,'{smlkn_besk}'::text[]													,'Beskrivelse'																																																		,'text'			,false		,NULL								,NULL										,NULL											,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 250\n\tTHEN FALSE\nEND'																																																																															,'<p>Maks 250 karakterer</p>')

	,(false	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_udloebbyg'				,'Brinksikring'							,'brinksikring'							,'{brinksik}'::text[]													,'Der er brinksikring'																																																,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(false	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_udsklbyg'				,'Beskrivelse'							,'udskiller_beskrivelse'				,'{udskl_besk}'::text[]													,'Beskrivelse'																																																		,'text'			,false		,NULL								,NULL										,NULL											,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 250\n\tTHEN FALSE\nEND'																																																																															,'<p>Maks 250 karakterer</p>')

	,(true	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_reservoir'				,'Vandspejlskote'						,'vandspejlskote'						,'{vsp_kt}'::text[]														,'Normal-vandspejlskote i reservoir (m)'																																											,'float'		,true		,NULL								,NULL										,NULL											,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(false	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_reservoir'				,'Maks. vandspejlskote'					,'max_vandspejlskote'					,'{vsp_kt_mx}'::text[]													,'Største accepterede normalvandspejlskote i reservoir (m)'																																							,'float'		,true		,NULL								,NULL										,NULL											,'min_max'		,0		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(false	,4		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_reservoir'				,'Kote, kronekant'						,'kronekant_kote'						,'{kr_kant_kt}'::text[]													,'Kote ved kronekant'																																																,'float'		,true		,NULL								,NULL										,NULL											,'min_max'		,0		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(false	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_reservoir'				,'Kote, serviceniveau'					,'serviceniveau_kote'					,'{service_kt}'::text[]													,'Angiver koten til det kritiske niveau, som modsvarer det funktionskrav der er defineret for hhv. afløbssystemet og for regnvand på terræn. Det kan f.eks. svare til opstuvning på terræn én gang hvert tiende år'	,'float'		,true		,NULL								,NULL										,NULL											,'min_max'		,0		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')
	,(false	,6		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_reservoir'				,'Aktiv volumen'						,'aktiv_volumen_m3'						,'{aktiv_vol}'::text[]													,'Det aktive hydrauliske volumen (m3). Mindste acceptable volumen = MaxVolumen-AktivVolumen'																														,'float'		,true		,NULL								,NULL										,NULL											,NULL			,0		,'m³'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,7		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_reservoir'				,'Maks. volumen'						,'max_volumen_m3'						,'{max_vol}'::text[]													,'Største mulige volumen (v/overløbskoten) (m3)'																																									,'float'		,true		,NULL								,NULL										,NULL											,NULL			,0		,'m³'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_mgsn'					,'Type, magasin'						,'magasin'								,NULL::text[]															,'Typen af magasin'																																																	,'text'			,false		,'Bassinmagasin'					,'kkafloeb_konstr_magasin'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_mgsn'					,'Afløbsvandføring'						,'afloebsvandfoering_ls'				,'{afl_vandf}'::text[]													,'Afløbsvandføring (l/sek)'																																															,'float'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'l/sek',NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_mgsn'					,'Lukket'								,'magasin_lukket'						,'{lukket}'::text[]														,'Er reservoiret lukket'																																															,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_bassin'				,'Bassin'								,'bassin'								,NULL::text[]															,'Typen af bassin'																																																	,'text'			,false		,'Åbent Bassin'						,'kkafloeb_konstr_bassin'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_bassin'				,'Miljøklasse'							,'bassin_miljoeklasse'					,'{bassi_milj}'::text[]													,'Klasseinddeling i relation til begreber i benchmarking - knytter sig til, om der er lavet ekstra tiltag i relation til sikring af arbejdsmiljø'																	,'text'			,false		,NULL								,'kkafloeb_faelles_miljoeklasse'			,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_bassin'				,'Vedligeholdelsesareal'				,'vedligeholdelsesareal_m2'				,'{vedl_areal}'::text[]													,'Det samlede areal for bassin og udenomsareal, som skal vedligeholdes. Anvendes ved værdiansættelse (m2)'																											,'integer'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'m²'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,4		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_bassin'				,'Vådvolumen'							,'vaadvolumen_m3'						,'{vaadvol}'::text[]													,'Volumen af permanent vandspejl i bassinet (m3)'																																									,'float'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'m³'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_bassin'				,'Mekanisk styring'						,'mekanisk_styring'						,'{mekanisk_s}'::text[]													,'Bassinet er udstyrret med en mekanisk styring. Skal anvendes i forbindelse med benchmarking af rørbassiner'																										,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_nedsiv'				,'Nedsivningsanlæg, type'				,'nedsivning'							,NULL::text[]															,'Typen af nedsivningsanlæg'																																														,'text'			,false		,NULL								,'kkafloeb_konstr_nedsivning'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_nedsiv'				,'Filtermedie'							,'filtermedie'							,'{flt_medie}'::text[]													,'Filtermediet i nedsivningsanlægget'																																												,'text'			,false		,NULL								,NULL										,NULL											,NULL			,1		,NULL	,NULL						,E'CASE\n\tWHEN LENGTH([KOLONNE]) > 250\n\tTHEN FALSE\nEND'																																																																															,'<p>Maks 250 karakterer</p>')
	,(false	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_nedsiv'				,'Nedsivningskapacitet'					,'infiltrationskapacitet_lsm2'			,'{infil_kap}'::text[]													,'Nedsivningskapacitet i l/sek/m2'																																													,'float'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'l/sek/m2'	,NULL					,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\nEND'																																																																															,'<p>Skal være &gt; 0</p>')
	,(false	,4		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_nedsiv'				,'Porevolumen'							,'porevolumen_pct'						,'{porevol}'::text[]													,'Hulrumsprocent (%)'																																																,'integer'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'%'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0 OR [KOLONNE]::numeric > 100\n\tTHEN FALSE\nEND'																																																																								,'<p>Skal være mellem 0 og 100</p>')
	,(false	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_nedsiv'				,'Rensegrad'							,'rensegrad_pct'						,'{rensegrad}'::text[]													,'Rensegrad i procent (%)'																																															,'integer'		,false		,NULL								,NULL										,NULL											,NULL			,1		,'%'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric < 0 OR [KOLONNE]::numeric > 100\n\tTHEN FALSE\nEND'																																																																								,'<p>Skal være mellem 0 og 100</p>')
	,(false	,6		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_nedsiv'				,'Spuling mulig'						,'spuling'								,NULL::text[]															,'Spuling er mulig'																																																	,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_rens'					,'Renseanlæg, type'						,'renseanlaeg'							,'{rens}'::text[]														,'Typen af renseanlæg'																																																,'text'			,false		,NULL								,'kkafloeb_konstr_renseanlaeg'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_rens'					,'Biologisk rensning'					,'biologisk_rensning'					,'{biologisk}'::text[]													,'Der foregår biologisk rensning'																																													,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_rens'					,'Denitrifikation'						,'denitritifikation'					,'{denitritif}'::text[]													,'Der foregår denitritifikation'																																													,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,4		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_rens'					,'Kemisk rensning'						,'kemisk_rensning'						,'{kemisk}'::text[]														,'Der foregår kemisk rensning'																																														,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_rens'					,'Mekanisk rensning'					,'mekanisk_rensning'					,'{mekanisk_r}'::text[]													,'Der foregår mekanisk rensning'																																													,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,6		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_rens'					,'Minirenseanlæg'						,'minirenseanlaeg'						,'{minirens}'::text[]													,'Det er et minirenseanlæg'																																															,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(false	,7		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_rens'					,'Nitrifikation'						,'nitrifikation'						,'{nitrif}'::text[]														,'Der foregår nitrifikation'																																														,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_tank'					,'Tank, type'							,'tank'									,NULL::text[]															,'Typen af tank'																																																	,'text'			,false		,NULL								,'kkafloeb_konstr_tank'						,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_udskl'					,'Udskiller, type'						,'udskiller'							,NULL::text[]															,'Typen af udskiller'																																																,'text'			,false		,NULL								,'kkafloeb_konstr_udskiller'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_kote'					,'Kote, type'							,'kote_type'							,NULL::text[]															,'Typen af kote ved det givne punkt'																																												,'text'			,false		,NULL								,'kkafloeb_konstr_kote_type'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,2		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_kote'					,'Kote'									,'kote'									,NULL::text[]															,'Kote (m)'																																																			,'float'		,false		,NULL								,NULL										,NULL											,'min_max'		,1		,NULL	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= -99\n\tTHEN FALSE\nEND'																																																																														,'<p>Ved ukendt må værdien -99 ikke benyttes</p>')

	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_konstr_rende'					,'Rende, type'							,'rende_type'							,NULL::text[]															,'Typen af rende'																																																	,'text'			,false		,'Linjedræn'						,'kkafloeb_konstr_rende_type'				,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)

--	  aktiv	,_order	,forsyningsart_incl_lst		,forsyningsart_excl_lst					,pakke											,navn_pretty							,navn									,navn_lst																,beskrivelse																																																		,data_type		,nillable	,default_value						,opslagstabel								,opslagstabel_filter							,kontrol_type	,fejl	,enhed	,restriktion_beskrivelse	,restriktion_sql																																																																																									,tooltip_html
	,(true	,1		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_klimatilp'					,'Klimatilpasningsanlæg'				,'klimatilpasningsanlaeg'				,'{klm_anlaeg}'::text[]													,'Ledningen angives som klimatilpasningsanlæg'																																										,'text'			,false		,'Nej'								,'kkafloeb_faelles_ja_nej'					,NULL											,NULL			,1		,NULL	,NULL						,NULL																																																																																												,NULL)
	,(true	,3		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_klimatilp'					,'Afledning'							,'klima_afledning'						,'{klm_afledn}'::text[]													,'Afledning som klimatilpasningsfunktion'																																											,'text'			,true		,NULL								,'kkafloeb_faelles_ja_nej'					,'beskrivelse = ''Ja'''							,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [klimatilpasningsanlaeg] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																																				,'<p>Angives kun når klimatilpasningsanlæg er "Ja" og med afledning som funktion</p>')
	,(true	,4		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_klimatilp'					,'Fordampning'							,'klima_fordampning'					,'{klm_fordam}'::text[]													,'Fordampning som klimatilpasningsfunktion'																																											,'text'			,true		,NULL								,'kkafloeb_faelles_ja_nej'					,'beskrivelse = ''Ja'''							,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [klimatilpasningsanlaeg] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																																				,'<p>Angives kun når klimatilpasningsanlæg er "Ja" og med fordampning som funktion</p>')
	,(true	,5		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_klimatilp'					,'Nedsivning'							,'klima_nedsivning'						,'{klm_nedsiv}'::text[]													,'Nedsivning som klimatilpasningsfunktion'																																											,'text'			,true		,NULL								,'kkafloeb_faelles_ja_nej'					,'beskrivelse = ''Ja'''							,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [klimatilpasningsanlaeg] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																																				,'<p>Angives kun når klimatilpasningsanlæg er "Ja" og med nedsivning som funktion</p>')
	,(true	,6		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_klimatilp'					,'Regulering'							,'klima_regulering'						,'{klm_reg}'::text[]													,'Regulering som klimatilpasningsfunktion'																																											,'text'			,true		,NULL								,'kkafloeb_faelles_ja_nej'					,'beskrivelse = ''Ja'''							,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [klimatilpasningsanlaeg] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																																				,'<p>Angives kun når klimatilpasningsanlæg er "Ja" og med regulering som funktion</p>')
	,(true	,7		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_klimatilp'					,'Rensning'								,'klima_rensning'						,'{klm_rens}'::text[]													,'Rensning som klimatilpasningsfunktion'																																											,'text'			,true		,NULL								,'kkafloeb_faelles_ja_nej'					,'beskrivelse = ''Ja'''							,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [klimatilpasningsanlaeg] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																																				,'<p>Angives kun når klimatilpasningsanlæg er "Ja" og med rensning som funktion</p>')
	,(true	,8		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_klimatilp'					,'Reservoir'							,'klima_reservoir'						,'{klm_reserv}'::text[]													,'Reservoir som klimatilpasningsfunktion'																																											,'text'			,true		,NULL								,'kkafloeb_faelles_ja_nej'					,'beskrivelse = ''Ja'''							,NULL			,-1		,NULL	,NULL						,E'CASE\n\tWHEN [klimatilpasningsanlaeg] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																																				,'<p>Angives kun når klimatilpasningsanlæg er "Ja" og med reservoir som funktion</p>')
	,(true	,9		,NULL::text[]				,NULL::text[]							,'kkafloeb_afloeb_klimatilp'					,'Hældning '							,'haeldning_prm'						,'{haeldning}'::text[]													,'Ledningens gennemsnitlige hældning (o/oo)'																																										,'float'		,true		,NULL								,NULL										,NULL											,NULL			,-1		,'‰'	,NULL						,E'CASE\n\tWHEN [KOLONNE]::numeric <= 0\n\tTHEN FALSE\n\tWHEN [klimatilpasningsanlaeg] != ''Ja''\n\t\tAND [KOLONNE] IS NOT NULL\n\tTHEN FALSE\nEND'																																																									,E'<p>Skal være &gt; 0</p>\n<br/>\n<p>Angives kun når klimatilpasningsanlæg er "Ja" og anlagt med specifik hældning</p>')
;