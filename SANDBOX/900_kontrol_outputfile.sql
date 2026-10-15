/* DROP FUNCTION IF EXISTS sandbox.kontrol_outputfile(
	_kontrol_guid uuid
) CASCADE;
--*/

CREATE OR REPLACE FUNCTION sandbox.kontrol_outputfile(
	_kontrol_guid uuid

	,OUT _html text
)
	RETURNS TEXT
	-- STABLE
	VOLATILE
	STRICT
	LANGUAGE plpgsql AS
$BODY$

BEGIN

	IF NOT EXISTS(
		SELECT
			'1'
		FROM sandbox.kontrol_xml k
		WHERE k.guid = _kontrol_guid
		)
	THEN

		RETURN;

	END IF;


/*

SELECT k.* FROM sandbox.kontrol_xml k
	,sandbox.kontrol_inputfiles(k.guid)
	,sandbox.kontrol_inputfiles_features(k.guid)
	,sandbox.kontrol_inputfiles_features_existing(k.guid)
	,sandbox.kontrol_inputfiles_features_direction(k.guid)
	,sandbox.kontrol_inputfiles_features_snap(k.guid)
WHERE k.guid = '';

-- */


	PERFORM sandbox.kontrol_inputfiles(_kontrol_guid := _kontrol_guid);
	PERFORM sandbox.kontrol_inputfiles_features(_kontrol_guid := _kontrol_guid);
	PERFORM sandbox.kontrol_inputfiles_features_existing(_kontrol_guid := _kontrol_guid);
	PERFORM sandbox.kontrol_inputfiles_features_direction(_kontrol_guid := _kontrol_guid);
	PERFORM sandbox.kontrol_inputfiles_features_snap(_kontrol_guid := _kontrol_guid);


	_html :=
		E'<!DOCTYPE html>\n'
			|| sandbox.kontrol_html_wrap(
					'html'
					,sandbox.kontrol_html_agg(
						_html_lst := ARRAY[
										-- <head>-tag
										sandbox.kontrol_outputfile_head(_kontrol_guid)

										-- <body>-tag
										,sandbox.kontrol_html_wrap(
											'body'
											,sandbox.kontrol_html_agg(
												_html_lst := ARRAY[
													-- Intro
													sandbox.kontrol_outputfile_intro(_kontrol_guid)
													,sandbox.kontrol_html_layouter_vertical(
														ARRAY[
															-- Indlæste filer
															sandbox.kontrol_outputfile_inputfiles(_kontrol_guid)
															-- Manglende attributter
															,sandbox.kontrol_outputfile_attributes(_kontrol_guid)
															-- Opsummering
															,sandbox.kontrol_outputfile_data_overview(_kontrol_guid)
															-- Leaflet
															,sandbox.kontrol_outputfile_leaflet(_kontrol_guid)
														]
													)
													-- Check
													,sandbox.kontrol_outputfile_data_check(_kontrol_guid)
												]
											)
										)
									]
								)
			);


	-- _html := regexp_replace(_html, '\n\t+', '', 'g');






	DELETE FROM sandbox.kontrol_inputfiles k
		WHERE k.kontrol_guid = _kontrol_guid;
	DELETE FROM sandbox.kontrol_inputfiles_features k
		WHERE k.kontrol_guid = _kontrol_guid;
	DELETE FROM sandbox.kontrol_inputfiles_features_existing k
		WHERE k.kontrol_guid = _kontrol_guid;
	DELETE FROM sandbox.kontrol_inputfiles_features_direction k
		WHERE k.kontrol_guid = _kontrol_guid;
	DELETE FROM sandbox.kontrol_inputfiles_features_snap k
		WHERE k.kontrol_guid = _kontrol_guid;


	RETURN;


EXCEPTION
	WHEN others THEN

		_html := FORMAT(
$$<!DOCTYPE html>
<html>
	<head>
		<title>KontrolLER_%1$s</title>
		<meta charset="UTF-8"/>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" rel="stylesheet"/>

		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"/>
	</head>
	<body>
		<div style="padding:10px;border: 1px none black">
			<div style="padding:10px;border: 1px none black">
				<H1 class="text-center report-header" style="color:rgb(255,0,0)">SYSTEMFEJL</H1>
				<H3 class="text-center report-header" style="color:rgb(0,0,0)">Kontakt: <a href="mailto:kkler@kk.dk?subject=KontrolLER%%20systemfejl,%%20ID:%%20%1$s" target="_blank">LER-kontoret</a></H3>
				<b>Fejltekst:</b>
				<p>%2$s</p>
			</div>
		</div>
	</body>
</html>$$

					,_kontrol_guid
					,sandbox.kontrol_xml_encode(SQLERRM)
				);





	DELETE FROM sandbox.kontrol_inputfiles k
		WHERE k.kontrol_guid = _kontrol_guid;
	DELETE FROM sandbox.kontrol_inputfiles_features k
		WHERE k.kontrol_guid = _kontrol_guid;
	DELETE FROM sandbox.kontrol_inputfiles_features_existing k
		WHERE k.kontrol_guid = _kontrol_guid;
	DELETE FROM sandbox.kontrol_inputfiles_features_direction k
		WHERE k.kontrol_guid = _kontrol_guid;
	DELETE FROM sandbox.kontrol_inputfiles_features_snap k
		WHERE k.kontrol_guid = _kontrol_guid;

	RETURN;

END $BODY$;

