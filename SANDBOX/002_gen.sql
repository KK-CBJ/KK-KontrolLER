-- DROP TABLE IF EXISTS sandbox.kontrol_inputfiles CASCADE;

CREATE TABLE sandbox.kontrol_inputfiles(
		kontrol_guid uuid,


		inputfile_fid integer
		,inputfile_id text
		,inputfile text
		,inputfile_pretty text
		,inputfile_order integer

		,inputfile_name text
		,inputfile_extension text
		,inputfile_featuretype text
		,inputfile_feature_srid integer
		,inputfile_feature_count integer
		,inputfile_feature_bounds geometry('POLYGON', 25832)

		,inputfile_filtype text
		,inputfile_filtype_pretty text

		,featuretype_fid integer
		,featuretype text
		,featuretype_pretty text
		,featuretype_order integer


		,system_fid integer
		,system text
		,system_pretty text
		,system_order integer

		,forsyningsart_fid integer
		,forsyningsart text
		,forsyningsart_pretty text
		,forsyningsart_order integer

		,gruppe_fid integer
		,gruppe text
		,gruppe_pretty text
		,gruppe_order integer

		,geometritype_fid integer
		,geometritype text
		,geometritype_pretty text
		,geometritype_short text
		,geometritype_order integer
		,pg_geometritype text


		,dimension text
		,dimension_pretty text
		,dimension_zm_flag integer

		,group_column text

		,etablering_column text
		,etablering_skaering date

		,snap_kontrol boolean
		,snap_reference boolean

		,forsyningsart_color_hex text

		,fejl integer
		,inputfile_xml xml
);






-- DROP TABLE IF EXISTS sandbox.kontrol_inputfiles_features CASCADE;

CREATE TABLE sandbox.kontrol_inputfiles_features(
		kontrol_guid uuid,


		inputfile_fid integer
		,inputfile_id text
		,inputfile text
		,inputfile_pretty text
		,inputfile_order integer


		,featuretype_fid integer
		,featuretype text
		,featuretype_pretty text
		,featuretype_order integer


		,system_fid integer
		,system text
		,system_pretty text
		,system_order integer

		,forsyningsart_fid integer
		,forsyningsart text
		,forsyningsart_pretty text
		,forsyningsart_order integer

		,gruppe_fid integer
		,gruppe text
		,gruppe_pretty text
		,gruppe_order integer

		,geometritype_fid integer
		,geometritype text
		,geometritype_pretty text
		,geometritype_short text
		,geometritype_order integer
		,pg_geometritype text


		,dimension text
		,dimension_pretty text
		,dimension_zm_flag integer

		,snap_kontrol boolean
		,snap_reference boolean

		,forsyningsart_color_hex text

		,feature_fid integer
		,feature_group text
		,feature_etablering date
		,feature_etablering_foer_skaering boolean
		,feature_eksisterende integer

		,geom geometry
		,attributes_xml xml
		,geom_xml xml

		,geom_geometritype_fid integer
		,geom_geometritype text
		,geom_geometritype_pretty text
		,geom_geometritype_short text
		,geom_geometritype_order integer
		,geom_pg_geometritype text
);






-- DROP TABLE IF EXISTS sandbox.kontrol_inputfiles_features_existing CASCADE;

CREATE TABLE sandbox.kontrol_inputfiles_features_existing(
		kontrol_guid uuid,


		inputfile_fid integer
		,inputfile_id text
		,inputfile text
		,inputfile_pretty text
		,inputfile_order integer


		,featuretype_fid integer
		,featuretype text
		,featuretype_pretty text
		,featuretype_order integer


		,system_fid integer
		,system text
		,system_pretty text
		,system_order integer

		,forsyningsart_fid integer
		,forsyningsart text
		,forsyningsart_pretty text
		,forsyningsart_order integer

		,gruppe_fid integer
		,gruppe text
		,gruppe_pretty text
		,gruppe_order integer

		,geometritype_fid integer
		,geometritype text
		,geometritype_pretty text
		,geometritype_short text
		,geometritype_order integer
		,pg_geometritype text


		,dimension text
		,dimension_pretty text
		,dimension_zm_flag integer

		,snap_kontrol boolean
		,snap_reference boolean

		,forsyningsart_color_hex text

		,feature_fid integer
		,feature_group text
		,feature_etablering date
		,feature_etablering_foer_skaering boolean
		,feature_eksisterende integer

		,geom geometry
		,attributes_xml xml
		,geom_xml xml

		,geom_geometritype_fid integer
		,geom_geometritype text
		,geom_geometritype_pretty text
		,geom_geometritype_short text
		,geom_geometritype_order integer
		,geom_pg_geometritype text
);






-- DROP TABLE IF EXISTS sandbox.kontrol_inputfiles_features_direction CASCADE;

CREATE TABLE sandbox.kontrol_inputfiles_features_direction(
		kontrol_guid uuid,


		geometritype_fid integer
		,geometritype text
		,geometritype_pretty text
		,geometritype_short text
		,geometritype_order integer
		,pg_geometritype text


		,kontrol_id text
		,geom geometry('Point', 25832)
		,attributes_xml xml
);






-- DROP TABLE IF EXISTS sandbox.kontrol_inputfiles_features_snap CASCADE;

CREATE TABLE sandbox.kontrol_inputfiles_features_snap(
		kontrol_guid uuid,


		inputfile_fid integer
		,inputfile_id text
		,inputfile text
		,inputfile_pretty text
		,inputfile_order integer


		,featuretype_fid integer
		,featuretype text
		,featuretype_pretty text
		,featuretype_order integer


		,system_fid integer
		,system text
		,system_pretty text
		,system_order integer

		,forsyningsart_fid integer
		,forsyningsart text
		,forsyningsart_pretty text
		,forsyningsart_order integer

		,gruppe_fid integer
		,gruppe text
		,gruppe_pretty text
		,gruppe_order integer

		,geometritype_fid integer
		,geometritype text
		,geometritype_pretty text
		,geometritype_short text
		,geometritype_order integer
		,pg_geometritype text


		,snap_featuretype_fid integer
		,snap_featuretype text
		,snap_featuretype_pretty text
		,snap_featuretype_order integer

		,snap_gruppe_fid integer
		,snap_gruppe text
		,snap_gruppe_pretty text
		,snap_gruppe_order integer


		,forsyningsart_color_hex text
		,snap_color_hex text

		,feature_fid text
		,geom geometry('Point', 25832)
		,fejl integer
);