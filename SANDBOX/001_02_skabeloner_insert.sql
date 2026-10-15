/*

SELECT
	FORMAT(
'TRUNCATE %1$I.%2$I;
INSERT INTO %1$I.%2$I(
	_name
	,_value
) VALUES
	%3$s;'

		,'sandbox'
		,'kontrol_lst_skabeloner'
		,string_agg(
			FORMAT(
'(
		%L
		,%L
	)'
				,_name
				,_value
			)
			,E'\n\n\t,'
			ORDER BY array_position(
						ARRAY[
							'head_html_template'
							,'head_style_css'
							,'intro_header_txt_title'
							,'intro_tbl_forklaring_overview_txt_tooltip'
							,'intro_tbl_forklaring_overview_txt_approved'
							,'intro_tbl_forklaring_overview_txt_error'
							,'intro_tbl_forklaring_overview_txt_obs'
							,'intro_child_left_html_template'
							,'intro_child_right_html_template'
							,'files_header_txt_title'
							,'files_tbl_files_overview_tooltip_html'
							,'attributes_header_txt_title'
							,'attributes_header_txt_title_no_error'
							,'attributes_tbl_attribute_missing_tooltip_html'
							,'data_overview_header_txt_title'
							,'leaflet_header_txt_title'
							,'leaflet_js'
						]
						,_name
					)
					,_name
		)
	)
FROM sandbox.kontrol_lst_skabeloner;

-- */



TRUNCATE sandbox.kontrol_lst_skabeloner RESTART IDENTITY;
INSERT INTO sandbox.kontrol_lst_skabeloner(
	_name
	,_value
) VALUES
	(
		'head_html_template'
		,'<title>KontrolLER_%1$s</title>
<meta charset="UTF-8"/>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" rel="stylesheet"/>

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin=""/>
<link rel="stylesheet" href="https://unpkg.com/leaflet-search@4.0.0/dist/leaflet-search.min.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.Default.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet-betterscale@1.0.0/L.Control.BetterScale.css"/>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.zoomhome@1.0.0/src/css/leaflet.zoomhome.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.control.layers.tree@1.1.0/L.Control.Layers.Tree.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.fullscreen@3.0.2/Control.FullScreen.css"/>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
<script src="https://unpkg.com/leaflet.wms@0.2.0/dist/leaflet.wms.js" type="text/javascript" charset="utf-8"></script>
<script src="https://unpkg.com/leaflet.markercluster@1.4.1/dist/leaflet.markercluster.js"></script>
<script src="https://unpkg.com/leaflet-search@4.0.0/dist/leaflet-search.min.js"></script>
<script src="https://unpkg.com/leaflet-betterscale@1.0.0/L.Control.BetterScale.js"></script>
<script src="https://unpkg.com/leaflet.zoomhome@1.0.0/dist/leaflet.zoomhome.js"></script>
<script src="https://unpkg.com/leaflet.control.layers.tree@1.1.0/L.Control.Layers.Tree.js"></script>
<script src="https://unpkg.com/leaflet.featuregroup.subgroup@1.0.2/dist/leaflet.featuregroup.subgroup.js"></script>
<script src="https://unpkg.com/leaflet.fullscreen@3.0.2/Control.FullScreen.js"></script>'
	)

	,(
		'head_style_css'
		,'@media print {
	/* Elementer som ikke vises ved print */
	#printreport,
	#click_on_map_div,
	#hideErrorsBtn,
	#hideLayersBtn,
	#hideExistingBtn,
	tr.tabletooltip,
	tr th .tabletooltip,
	section.leaflet-control-layers-list div.leaflet-control-layers-base,
	section.leaflet-control-layers-list div.leaflet-control-layers-separator,
	.leaflet-container div.leaflet-control-search,
	div.leaflet-control-zoom,
	div.leaflet-control-zoomhome,
	div.leaflet-bar.leaflet-control,
	div.leaflet-control-better-scale,
	div.row:has(#attribute_subsection) div:not(:has(#attribute_subsection)) {
		display: none;
	}

	body {
		padding-bottom: 0px !important;
	}

	.leaflet-popup-content-wrapper {
		-webkit-filter: drop-shadow(0 3px 14px rgba(0, 0, 0, 0.4));
	}

	/* Tykkere kanter ved print */
	.table-bordered td,
	.table-bordered th {
		border: 3pt solid #000000 !important;
	}

	/* page-break */
	body > div,
	#map,
	.table {
		page-break-inside: avoid;
	}

	.leaflet-control-layers-scrollbar {
		overflow: hidden;
	}

}

/* ------- */
/* GENEREL */
/* ------- */


/* Tilføj lidt ekstra plads i bunden */
body {
	padding-bottom: 250px;
}

.intro-parent {
	border: 1px none black;
	padding: 30px 0px 20px 20px;
	overflow: hidden;
}

.intro-child {
	float: left;
}

.intro-parent > .intro-child:first-of-type {
	width: 70%;
}

.intro-parent > .intro-child:last-of-type {
	width: 30%;
}

.intro-child .intro-child {
	width: 50%;
	padding-right: 30px;
}

.text-right {
	text-align: right;
	padding-right: 10px;
	margin-bottom: 0px;
	color: #000000;
}

.container {
	max-width: 75%;
}

#printreport {
	text-align: right;
	padding: 0px 10px 0px 10px;
}

#printreport p {
	padding-top: 5px;
}

#printreport a {
	color: inherit;
	text-decoration: none;
}

#print_notice, #mapNoShow {
	color: red;
	font-weight: bold;
}

#mapNoShow {
    font-size: 20px;
	display: none;
}

.section_header {
	padding-left: 25px;
}

table.forklaring_overview {
	width: fit-content;
}

div:has(>div.container #attribute_subsection),
div:has(>#attribute_subsection) {
	padding-top: 0px !important;
	padding-bottom: 0px !important;
}

#attribute_subsection {
	padding-top: 40px
}


/* ---- */
/* KORT */
/* ---- */


#map {
	width: 90%;
	height: 750px;
	display: block;
	margin: auto;
	background: #FFFFFF;
	border: 2px solid black;
}



/* Skal fylde det hele for at undgå hover, når kortet ikke er aktivt */
.leaflet-bottom.leaflet-left {
	width: 100%;
	height: 100%;
	/* display: none; */
}

#click_on_map_div {
	width: 100%;
	height: 100%;
	position: relative;
	margin-left: 0px;
	margin-bottom: 0px;
}

#click_on_map_div div {
	background: rgba(0, 0, 0, 0.7);
	color: white;
	width: fit-content;
	position: absolute;
	bottom: 0;
	margin-left: 10px;
	margin-bottom: 10px;
	border-radius: 5px;
}

#click_on_map_div p {
	margin: 0px;
	padding: 10px;
	text-align: center;
	vertical-align: middle;
	font-weight: bold;
	-webkit-user-select: none; /* Safari */
	-ms-user-select: none; /* IE 10 and IE 11 */
	user-select: none; /* Standard syntax */
}



.leaflet-control-layers {
	opacity: 90%;
	max-width: 300px;
}

.leaflet-layerstree-children {
	margin-left: 15px
}

.leaflet-layerstree-opened,
.leaflet-layerstree-closed {
	margin-right: 0px;
}

.leaflet-control-layers-overlays svg,
.leaflet-control-layers-overlays input,
.leaflet-layerstree-header-label input {
	margin-right: 5px;
}

.leaflet-control-layers-overlays svg {
	height: 15px;
	width: 15px;
	margin-bottom: 3px;
}

div.leaflet-layerstree-header-pointer > span > span.leaflet-layerstree-closed,
div.leaflet-layerstree-header-pointer > span > span.leaflet-layerstree-opened {
	vertical-align: top;
}

.leaflet-popup-content,
.leaflet-control-layers-scrollbar {
	overscroll-behavior: contain;
}

.legendLayerTxt {
	word-break: break-word;
}

.leaflet-popup-content-wrapper table {
	width: 100%;
	text-align: left;
	padding: 8px;
	border: 1px solid black;
	border-collapse: collapse;
	overflow-wrap: anywhere;
}

.leaflet-popup-content-wrapper table tr {
	border-top: 1px solid #dee2e6;
	border-left: 1px solid black;
	border-right: 1px solid black;
}

.leaflet-popup-content-wrapper table th {
	width: 35%;
}

.leaflet-popup-content-wrapper tr:first-of-type th {
	text-align: center;
	border: 1px solid black;
}

div.leaflet-control-layers-overlays label {
	margin-bottom: 1px;
}

.error_pop {
	background: #f79c9c;
}
.obs_pop {
	background: #fbd182;
}
.null_pop {
	background: #e9ecef;
}

.error_pop_init div.leaflet-popup-content-wrapper,
.error_pop_init div.leaflet-popup-tip {
	background: #f79c9c;
}
.obs_pop_init div.leaflet-popup-content-wrapper,
.obs_pop_init div.leaflet-popup-tip {
	background: #fbd182;
}
.eksist_pop_init div.leaflet-popup-content-wrapper,
.eksist_pop_init div.leaflet-popup-tip {
	background: #ededed;
}

.leaflet-popup-pane.no_pop_init .pop_init div {
	display: none;
}

.leaflet-popup-pane.eksist_pop_init_only .error_pop_init div,
.leaflet-popup-pane.eksist_pop_init_only .obs_pop_init div,
.leaflet-snapNoSnap-pane.eksist_pop_init_only,
.leaflet-snapAsSnapped-pane.eksist_pop_init_only,
.leaflet-snapSnapped-pane.eksist_pop_init_only {
	display: none;
}

.pop_init {
	-webkit-user-select: none; /* Safari */
	-ms-user-select: none; /* IE 10 and IE 11 */
	user-select: none; /* Standard syntax */
	pointer-events: none;
}

.pop_init > div,
.pop_init > div > div {
	pointer-events: none;
}
/*
.pop_init .leaflet-popup-close-button {
	display: none;
}*/

.pop_init .leaflet-popup-content {
	margin: 5px 0px 5px 0px;
	text-align: center;
}

#hideErrorsBtn,
#hideLayersBtn,
#hideExistingBtn {
	z-index: 700;
	position: absolute;
	border-radius: 4px;
	border: 2px solid rgba(0, 0, 0, 0.2);
	background-clip: padding-box;
	background-color: white;
	height: 30px;
	width: 103px;
	margin-left: 5px;
	font-weight: bold;
	padding: 2px;
}

#hideErrorsBtn {
	margin-top: 44px;
}

#hideExistingBtn {
	margin-left: 113px;
}

#hideErrorsBtn:hover,
#hideLayersBtn:hover,
#hideExistingBtn:hover {
	background-color: #f4f4f4;
}

.leaflet-container div.leaflet-control-search,
.leaflet-container div.leaflet-bar.leaflet-control {
	margin-top: 4px
}

.leaflet-container div.leaflet-control-zoomhome.leaflet-bar.leaflet-control {
	margin-top: 10px
}

.leaflet-container div.leaflet-control-search .search-tooltip {
	overscroll-behavior: contain;
}

.leaflet-control-better-scale {
	right: 25px;
}

.svgCluster svg,
.svgSnapMarker svg,
.svgPointMarker svg,
.svgSearchControl svg {
	width: 100%;
	height: 100%;
	display: block;
	margin-top: 1px;
}

.svgAnimated:hover svg * {
	fill: #ffff00 !important;
	stroke: #ffff00 !important;
}


div.svgCluster.leaflet-marker-icon svg * {
	stroke: black;
	stroke-width: 10%;
}

div.svgSnapMarker.leaflet-marker-icon,
div.svgDirectionMarker.leaflet-marker-icon,
div.svgGeomExist.leaflet-marker-icon {
	pointer-events: none;
}

.svgSearchControl svg *{
	fill-opacity: 0;
	stroke: #0f0;
}

.svgDirectionMarker svg *{
	fill: grey;
	stroke: black;
	stroke-width: 10%;
}

.svgDirectionMarker svg{
	transform: translate(-1px, -1px);
}


div.svgSnapMarker svg *,
svg.svgSnapMarker * {
	stroke: black;
	stroke-width: 10%;
}

div.svgSnapMarker.snapped svg *,
svg.svgSnapMarker.snapped * {
	fill: #07a925;
}

div.svgSnapMarker.asSnapped svg *,
svg.svgSnapMarker.asSnapped * {
	fill: #9ba907;
}

div.svgSnapMarker.noSnap svg *,
svg.svgSnapMarker.noSnap * {
	fill: #fdc942;
}


div.svgPointMarker svg *,
svg.svgPointMarker * {
	/* stroke: black; */
	stroke-width: 5%;
}


div.svgPointMarker.svgGeomExist  svg * {
	opacity: 40%;
}


div.svgPointAfloeb svg *,
svg.svgPointAfloeb * {
	fill: #693d07;
	stroke: #693d07;
}

div.svgPointFoeringsror svg *,
svg.svgPointFoeringsror * {
	fill: #f5a27a;
	stroke: #f5a27a;
}

div.svgPointEl svg *,
svg.svgPointEl * {
	fill: #d73027;
	stroke: #d73027;
}

div.svgPointTermisk svg *,
svg.svgPointTermisk * {
	fill: #d957f9;
	stroke: #d957f9;
}

div.svgPointGas svg *,
svg.svgPointGas * {
	fill: #e9af00;
	stroke: #e9af00;
}

div.svgPointOlie svg *,
svg.svgPointOlie * {
	fill: #000000;
	stroke: #000000;
}

div.svgPointTele svg *,
svg.svgPointTele * {
	fill: #009900;
	stroke: #009900;
}

div.svgPointVand svg *,
svg.svgPointVand * {
	fill: #0070ff;
	stroke: #0070ff;
}

div.svgPointAndet svg *,
svg.svgPointAndet * {
	fill: #00ceb3;
	stroke: #00ceb3;
}

div.svgPointOmlagtfjernet svg *,
svg.svgPointOmlagtfjernet * {
	fill: #9e9e9e;
	stroke: #9e9e9e;
}





/* ----- */
/* TABLE */
/* ----- */


.table thead th {
	text-align: center;
	vertical-align: middle;
}

/* Første kolonne med fejl-symbol */
table.forklaring_overview tbody tr td:first-of-type,
table.files_overview tbody tr td:first-of-type,
table.attribute_missing tbody tr td:first-of-type,
table.attributes tbody tr td:first-of-type {
	vertical-align: middle;
	text-align: center;
	width: 50px;
}

table.attributes tbody tr td:last-of-type
,table.files_overview tbody tr td:last-of-type {
	vertical-align: middle;
	text-align: right;
	width: 80px;
}

table.attributes tr {
	overflow-wrap: anywhere;
}

/* table.data_overview td:first-of-type {
	width: 65%;
} */

table.data_overview tbody tr td.tbl_header
,table.data_overview tbody tr td.tbl_subheader {
	vertical-align: middle;
	font-weight: bold;
}

table.data_overview tbody tr td.tbl_header {
	text-align: left;
}

table.data_overview tbody tr td.tbl_subheader {
	text-align: right;
	padding-left: 25px;
	font-size: 14px;
}

table.data_overview tbody .tbl_count {
	text-align: right;
	vertical-align: middle;
	width: 18%;
}


/* ------------- */
/* TABLE TOOLTIP */
/* ------------- */


table tr {
	position: relative;
}

table div.tabletooltip span.tooltiptext {
	inset: 0 0 auto;
	margin: auto;
	width: fit-content;

	background: rgba(0, 0, 0, 0.7);
	border-radius: 5px;
	padding: 3px;
	color: #fff;
	font-size: 12px;
	font-weight: bold;
	display: none;
	text-align: left;

	/* Position the tooltip */
	position: absolute;
	z-index: 1;
	top: 50%;
	left: 90px;
	margin-left: -60px;
}

table div.tabletooltip:hover span.tooltiptext {
	display: block;
	padding: 10px;
	margin-right: -150px;
}

table div.tabletooltip:hover span.tooltiptext p {
	margin: auto;
}

table div.tabletooltip:hover span.tooltiptext hr.tooltip_break {
	margin: auto;
	height: 8px;
}

table div.tabletooltip:hover span.tooltiptext ul {
	margin: 0px 0px 0px 0px;
}

table div.tabletooltip:hover span.tooltiptext ul.ul-columns li {
	padding-right: 10px;
}

table.attributes tbody span.tooltiptext {
	font-family: Consolas, Monaco, ''Lucida Console'', monospace;
}


/* ------------------ */
/* TABLE ERROR MARKER */
/* ------------------ */


.approved {
	font-weight: bold;
	color: forestgreen;
}
.error {
	font-weight: bold;
	color: red;
}
.obs {
	font-weight: bold;
	color: orange;
}
.error_marker {
	font-weight: bold;
	color: black;
}'
	)

	,(
		'intro_header_txt_title'
		,'KontrolLER rapport af ledningsoplysninger'
	)

	,(
		'intro_tbl_forklaring_overview_txt_tooltip'
		,'Placér musen over symbolet for at se, hvad fejlen kan skyldes'
	)

	,(
		'intro_tbl_forklaring_overview_txt_approved'
		,'Data lever op til kravene i LER2.0/Tegningskravene'
	)

	,(
		'intro_tbl_forklaring_overview_txt_error'
		,'Data lever ikke op til kravene i LER2.0/Tegningskravene'
	)

	,(
		'intro_tbl_forklaring_overview_txt_obs'
		,'Kontrollér om det afleverede stemmer overens med det anlagte'
	)

	,(
		'intro_child_left_html_template'
		,'<div class="intro-child">
	<div>
		<H4>Hvordan håndteres rapporten?</H4>
		<p>Hvert afsnit er illustreret med følgende symboler:</p>
	</div>
%1$s
	<br/>
	<div class="intro-child">
		<H6>Hvis der ikke er fejl i rapporten</H6>
		<p>Hvis der <b><u>ikke</u></b> er fejl i rapporten (%2$s), er det stadig vigtigt at sikre, at de indlæste data <b><i>stemmer overens med det anlagte.</i></b></p>
		<span>Eksempel:</span>
		<ul>
			<li>Rapporten indeholder 7 brønde, men der er anlagt 10</li>
			<li>Rapporten indeholder 2 ledningsforløb, men der er anlagt 3</li>
			<li>Vejen ligger i kote 5, men Z-koordinaterne går fra 7-11</li>
			<li>Den udvendige diameter er sat til 110mm, men ledningen er 160mm</li>
		</ul>
	</div>
	<div class="intro-child">
		<H6>Hvis der er fejl i rapporten</H6>
		<p>Hvis der <b><u>er</u></b> fejl i rapporten, skal disse rettes, hvorefter KontrolLER kan køres igen med de nye rettelser.
			<br/>
			Ved de fleste kontroller, vil der være en kort tekst (<b>?</b>), som beskriver hvad, der kan være skyld i fejlen, og hvordan den kan udbedres.
			<br/>
			Under afsnittene Ledning/Komponent vil det være udspecificeret hvilker filer, der indeholder fejlene. Dette ses ved at placere musen over fejl-symbolet (%3$s).
		</p>
	</div>
</div>'
	)

	,(
		'intro_child_right_html_template'
		,'<div class="intro-child">
	<p class="text-right" id="kontroldato"><b>Dato:</b> %2$s</p>
	<p class="text-right" id="kontrol_uuid"><b>ID:</b> %1$s</p>
	<p class="text-right" id="ler_kontakt">Ved spørgsmål kontakt <a href="mailto:kkler@kk.dk" target="_blank">LER-kontoret</a></p>
	<!-- <p class="text-right" style="color: red;"><b>OBS! Eksisterende data kommer <b>IKKE</b> med i rapporten lige nu</b></p> -->
	<br/>
	<div id="printreport">
		<button id="print_button" type="submit">
			<a onclick="if (document.querySelector(''#mapNoShow'')) {document.getElementById(''mapNoShow'').style.display = ''block'';} if (document.querySelector(''.leaflet-map-pane'')) {document.getElementsByClassName(''leaflet-map-pane'')[0].remove();} if (document.querySelector(''.leaflet-control-container'')) {document.getElementsByClassName(''leaflet-control-container'')[0].remove();} document.getElementById(''print_notice'').remove();document.getElementById(''print_button'').remove();this.href=''data:text/html;charset=UTF-8,''+encodeURIComponent(document.documentElement.outerHTML)" href="#" download="Kontrol-LER_%1$s.html">Download</a>
		</button>
		<button onclick="window.print()">Print</button>
		<p id="print_notice" class="text-right">Husk altid at downloade rapporten</p>
		<p class="text-right">Vær opmærksom på kortets<br/>placering ved print</p>
	</div>
</div>'
	)

	,(
		'files_header_txt_title'
		,'Filer indlæst'
	)

	,(
		'files_tbl_files_overview_tooltip_html'
		,'<p>Kun filtyperne GeoPackage (.gpkg) eller Shape (.shp med tilhørende .dbf, .cpg, .prj og .shx) godtages</p>
<hr class="tooltip_break"/>
<p>Der meddelses fejl, hvis</p>
<ul>
	<li>Intet data indlæses fra filerne</li>
	<li>Filerne ikke lever op til navngivning</li>
	<ul>
		<li>[afloeb/el/tele/termisk/andet/foeringsror/vand/gas/olie/omlagtfjernet]_[komponent/ledning]_[punkt/polygon/linje]</li>
		<li>Fx afloeb_komponent_punkt</li>
	</ul>
</ul>
<hr class="tooltip_break"/>
<p>For GeoPackage gælder navngivningen for lagnavnet i filen over navngivningen af filen</p>'
	)

	,(
		'attributes_header_txt_title'
		,'Manglende kolonner (attributter) i indlæste filer'
	)

	,(
		'attributes_header_txt_title_no_error'
		,'Ingen manglende kolonner (attributter) i indlæste filer'
	)

	,(
		'attributes_tbl_attribute_missing_tooltip_html'
		,'<p>
	Indmålingsfilens attributliste skal indeholde alle attributter (kolonner) iht. KK''s tegningskrav
	<br/>
	Du kan med fordel bruge KK''s LER-skabeloner, som indeholder alle attributter (kolonner)
	<br/>
	<br/>
	Placér musen over (<span class="error_marker" style="color: #fff;">&#10007;</span>) for at se muligheder for navngivning af attributten (kolonnen)
	<br/>
	<br/>
	Attributter markeret med (<span class="error">&#10007;</span>) skal udfyldes
	<hr class="tooltip_break"/>
	Attributter markeret med (<span class="obs">&#10007;</span>) skal udfyldes, hvis de konkrete betingelser er mødt iht. KK''s tegningskrav
</p>'
	)

	,(
		'data_overview_header_txt_title'
		,'Opsummering af data'
	)

	,(
		'leaflet_header_txt_title'
		,'Kontrollér placeringen af de indlæste data'
	)

	,(
		'leaflet_js'
		,'// Ensure no show after download
document.getElementById(''mapNoShow'').style.display = ''none''



// Create Map
const map = L.map(''map'', {
	maxZoom: 28
	,zoomSnap: 0.25
	,zoomDelta: 0.25
	,scrollWheelZoom: false
	,dragging: false
	,wheelDebounceTime: 0
	,zoomControl: false
}).setView([0, 0], 0);



// Pane for snap symbols to always be on top
// GeoJSON layer not compatible with pane, so moved with JS in onLayerAddRemove
map.createPane(''snapPaneNoSnap'');
map.getPane(''snapPaneNoSnap'').style.zIndex = 652;
map.createPane(''snapPaneAsSnapped'');
map.getPane(''snapPaneAsSnapped'').style.zIndex = 651;
map.createPane(''snapPaneSnapped'');
map.getPane(''snapPaneSnapped'').style.zIndex = 650;



// Maintain searchGroup on add/remove layer
// Maintain snapMarkers
function onLayerAddRemove(e) {
	// snapMarkers
	markerPane = document.getElementsByClassName(''leaflet-marker-pane'')[0]
	snapPaneNoSnap = document.getElementsByClassName(''leaflet-snapNoSnap-pane'')[0]
	snapPaneAsSnapped = document.getElementsByClassName(''leaflet-snapAsSnapped-pane'')[0]
	snapPaneSnapped = document.getElementsByClassName(''leaflet-snapSnapped-pane'')[0]

	snapMarkers = markerPane.getElementsByClassName(''svgSnapMarker'')
	n = snapMarkers.length;

	if (n > 0) {
		for (var i = 0; i < n; i++) {
			if (snapMarkers[i].classList.contains(''noSnap'')) {
				snapPaneNoSnap.appendChild(markerPane.removeChild(snapMarkers[i]))
			} else if (snapMarkers[i].classList.contains(''asSnapped'')) {
				snapPaneAsSnapped.appendChild(markerPane.removeChild(snapMarkers[i]))
			} else {
				snapPaneSnapped.appendChild(markerPane.removeChild(snapMarkers[i]))
			}
		}
	}



	// searchGroup
	searchGroupActive.clearLayers()

	searchGroup.eachLayer(function(layer) {
		var layerName = layer.options.layerName
		var overlayName = layerName.replace(''layer'', ''overlay'')
		var mapHasLayer = eval(''map.hasLayer('' + overlayName + '')'')

		if (mapHasLayer) {
			searchGroupActive.addLayer(layer);
		}
	})
}



// Zoom + ZoomExtents button
var zoomHome = L.Control.zoomHome({
	zoomHomeTitle: ''Hjem''
	,zoomInTitle: ''Zoom ind''
	,zoomOutTitle: ''Zoom ud''
});

zoomHome.addTo(map);



// Fullscreen
var fullScreen = L.control.fullscreen({
	position: ''topleft'', // change the position of the button can be topleft, topright, bottomright or bottomleft, default topleft
	title: ''Fuldskærm'', // change the title of the button, default Full Screen
	titleCancel: ''Forlad fuldskærm'', // change the title of the button when fullscreen is on, default Exit Full Screen
	content: null, // change the content of the button, can be HTML, default null
	forceSeparateButton: true, // force separate button to detach from zoom buttons, default false
	forcePseudoFullscreen: true, // force use of pseudo full screen even if full screen API is available, default false
	fullscreenElement: false // Dom element to render in full screen, false by default, fallback to map._container
});

fullScreen.addTo(map);



// Scalebar
var scaleBar = L.control.betterscale({
	position: ''bottomright''
	,metric: true
	,imperial: false
});

scaleBar.addTo(map);



// Click in map to activate
L.Control.ClickOnMapBox = L.Control.extend({
	onAdd: function(map) {
		var text = L.DomUtil.create(''div'');
		text.id = ''click_on_map_div'';
		text.innerHTML = ''<div><p>Klik i kortet for at aktivere</p></div>'';
		return text;
	},
	onRemove: function(map) {
		// Nothing to do here
	}
});

L.control.ClickOnMapBox = function(opts) {
	return new L.Control.ClickOnMapBox(opts);
}

const clickOnMapDiv = L.control.ClickOnMapBox({
	position: ''bottomleft''
}).addTo(map);

map.on(''click'', function() {
	map.scrollWheelZoom.enable();
	map.dragging.enable();
	clickOnMapDiv.remove();
});



// Show or hide layers panel
function hideLayers() {
	var elements = document.getElementsByClassName(''leaflet-control-layers''),
	n = elements.length;
	for (var i = 0; i < n; i++) {
		var e = elements[i];
		if (e.style.display != ''none'') {
			e.style.display = ''none'';
			if (i == 0) {
				document.getElementById(''hideLayersBtn'').innerHTML = ''Vis lagvælger''
			}
		} else {
			e.style.display = ''block'';
			if (i == 0) {
				document.getElementById(''hideLayersBtn'').innerHTML = ''Skjul lagvælger''
			}
		}
	}
}

L.Control.hideLayers = L.Control.extend({
	onAdd: function(map) {
		var text = L.DomUtil.create(''button'');
		text.id = ''hideLayersBtn'';
		text.onclick = function() {
			hideLayers();
		};
		text.innerHTML = ''Skjul lagvælger''
		return text;
		},
		onRemove: function(map) {
			// Nothing to do here
		}
});

L.control.hideLayers = function(opts) {
	return new L.Control.hideLayers(opts);
}

const hideLayersHtml = L.control.hideLayers({
	position: ''topleft''
}).addTo(map);



// Show or hide existing button
var varHideExisting = ''0'';

//function existingFilter(feature) {
//	if (varHideExisting == ''1'') {
//		if (feature.properties[''feature.eksisterende''] == ''0'') {
//			return true
//		} else {
//			return false
//		}
//	} else if (varHideExisting == ''-1'') {
//		if (feature.properties[''feature.eksisterende''] == ''1'') {
//			return true
//		} else {
//			return false
//		}
//	} else {
//		// varHideExisting = ''0''
//		return true
//	}
//}


function hideExisting() {
	if (varHideExisting == ''0'') {
		varHideExisting = ''1''
		if (document.querySelector(''#hideExistingBtn'')) {
			document.getElementById(''hideExistingBtn'').innerHTML = ''Vis kun eksist.''
		}

	} else if (varHideExisting == ''1'') {
		varHideExisting = ''-1''
		if (document.querySelector(''#hideExistingBtn'')) {
			document.getElementById(''hideExistingBtn'').innerHTML = ''Vis alt''
		}

		var elements = document.querySelectorAll(''.leaflet-popup-pane, .leaflet-snapNoSnap-pane, .leaflet-snapAsSnapped-pane, .leaflet-snapSnapped-pane''),
		n = elements.length;
		for (var i = 0; i < n; i++) {
			var e = elements[i];

			if (!e.classList.contains(''eksist_pop_init_only'')) {
				e.classList.add(''eksist_pop_init_only'')
			}

		}

	} else {
		varHideExisting = ''0''
		if (document.querySelector(''#hideExistingBtn'')) {
			document.getElementById(''hideExistingBtn'').innerHTML = ''Skjul eksist.''
		}

		var elements = document.querySelectorAll(''.leaflet-popup-pane, .leaflet-snapNoSnap-pane, .leaflet-snapAsSnapped-pane, .leaflet-snapSnapped-pane''),
		n = elements.length;
		for (var i = 0; i < n; i++) {
			var e = elements[i];

			if (e.classList.contains(''eksist_pop_init_only'')) {
				e.classList.remove(''eksist_pop_init_only'')
				// Update popups position
				errorsGroup.eachLayer(function(layer) {
					layer.eachLayer(function(layerPop) {
						layerPop.update()
					})
				})
			}

		}
	}



	// Opdatér alle lag

	// Layer selector
	layerControl = document.getElementsByClassName(''leaflet-control-layers-overlays'')[0]

	layerControlPre = layerControl.cloneNode(true)
	layersTreePre = layerControlPre.querySelectorAll(''.leaflet-layerstree-opened,.leaflet-layerstree-closed,.leaflet-layerstree-children'')




	// Stop fading popups temporarily
	map._fadeAnimated = false


	layerAddGrp = []
	overlayGroup.forEach(function(layer) {
		var layerAdd = eval(''map.hasLayer('' + layer + '')'')

		if (layerAdd) {
			eval(''map.removeLayer('' + layer + '');'');
			layerAddGrp.push(layer)
		}
	})

	filterGroup.forEach(function(layer) {
		eval(layer + ''.clearLayers();'');
		layerJSON = layer.replace(''layer'', ''json'')

		if (varHideExisting == ''1'') {
			if (!layer.endsWith(''_eksisterende'')) {
				eval(layer + ''.addData('' + layerJSON + '');'');
			}
		} else if (varHideExisting == ''-1'') {
			if (layer.endsWith(''_eksisterende'')) {
				eval(layer + ''.addData('' + layerJSON + '');'');
			}
		} else {
			// varHideExisting = ''0''
			eval(layer + ''.addData('' + layerJSON + '');'');
		}
	})

	overlayGroup.forEach(function(layer) {

		if (layerAddGrp.includes(layer)) {
			eval(''map.addLayer('' + layer + '');'');
		}
	})


	// Enable fade
	map._fadeAnimated = true




	// Reset layer selector
	layersTree = layerControl.querySelectorAll(''.leaflet-layerstree-opened,.leaflet-layerstree-closed,.leaflet-layerstree-children'')
	for (var i = 0; i < layersTree.length; i++) {

		if (layersTree[i].classList.contains(''leaflet-layerstree-hide'') && !layersTreePre[i].classList.contains(''leaflet-layerstree-hide'')) {
			layersTree[i].classList.remove(''leaflet-layerstree-hide'')
		} else if (layersTreePre[i].classList.contains(''leaflet-layerstree-hide'') && !layersTree[i].classList.contains(''leaflet-layerstree-hide'')) {
			layersTree[i].classList.add(''leaflet-layerstree-hide'')
		}

	}
}

L.Control.hideExisting = L.Control.extend({
	onAdd: function(map) {
		var text = L.DomUtil.create(''button'');
		text.id = ''hideExistingBtn'';
		text.onclick = function() {
				hideExisting();
		};
		if (varHideExisting == ''0'') {
			text.innerHTML = ''Skjul eksist.''
		} else if (varHideExisting == ''1'') {
			text.innerHTML = ''Vis kun eksist.''
		} else {
			text.innerHTML = ''Vis alt''
		}
		return text;
	},
	onRemove: function(map) {
		// Nothing to do here
	}
});

L.control.hideExisting = function(opts) {
	return new L.Control.hideExisting(opts);
}

	// if any existing elements appear on map: ''1'' = ''1'' (show button) otherwise  ''1'' == '''' (hide button)
if (''1'' == ''[__EXISTING__]'') {
	const hideExistingHtml = L.control.hideExisting({
		position: ''topleft''
	}).addTo(map);
}



// Show or hide errors button
function hideErrors() {
	var elements = document.getElementsByClassName(''leaflet-popup-pane''),
	n = elements.length;
	for (var i = 0; i < n; i++) {
		var e = elements[i];
		if (e.classList.contains(''no_pop_init'')) {
			e.classList.remove(''no_pop_init'')
			if (document.querySelector(''#hideErrorsBtn'')) {
				document.getElementById(''hideErrorsBtn'').innerHTML = ''Skjul bobler''
			}
			// Update popups position
			errorsGroup.eachLayer(function(layer) {
				layer.eachLayer(function(layerPop) {
					layerPop.update()
				})
			})
		} else {
			e.classList.add(''no_pop_init'')
			if (document.querySelector(''#hideErrorsBtn'')) {
				document.getElementById(''hideErrorsBtn'').innerHTML = ''Vis bobler''
			}
		}
	}
}

L.Control.hideErrors = L.Control.extend({
	onAdd: function(map) {
		var text = L.DomUtil.create(''button'');
		text.id = ''hideErrorsBtn'';
		text.onclick = function() {
				hideErrors();
		};
		text.innerHTML = ''Skjul bobler''
		return text;
	},
	onRemove: function(map) {
		// Nothing to do here
	}
});

L.control.hideErrors = function(opts) {
	return new L.Control.hideErrors(opts);
}

// if any error popups are generated: ''1'' = ''1'' (show button) otherwise  ''1'' == '''' (hide button)
if (''1'' == ''[__ERRORS__]'') {
	const hideErrorsHtml = L.control.hideErrors({
		position: ''topleft''
	}).addTo(map);
}



// Search control
var searchGroup = new L.featureGroup([]);
var searchGroupActive = new L.featureGroup([]);
var searchMarkerGroup = new L.featureGroup([]);

var searchControl = new L.Control.Search({
	layer: searchGroupActive,
	propertyName: ''search_control'',
	marker: false,
	initial: false,
	firstTipSubmit: true,
	textPlaceholder: ''Søg på ID'',
	textCancel: ''Ryd'',
	textErr: ''Intet fundet'',
	moveToLocation: function(latlng, title, map) {
		//console.log(latlng.layer.feature.geometry.type)
		if (latlng.layer.feature.geometry.type == ''Point'') {
			map.setView(latlng, 22);
		} else {
			var zoom = map.getBoundsZoom(latlng.layer.getBounds(), false);
			map.setView(latlng, zoom);
		}
	}
});

searchControl.on(''search:locationfound'', function(e) {
	if (e.layer.feature.geometry.type == ''Point'') {

		searchMarkerGroup.clearLayers();
		var searchLatlng = e.layer._latlng;
		var searchMarker = new L.marker(searchLatlng, {
			interactive: false
			,icon: L.divIcon({
				iconSize: L.point(32, 32)
				,className: ''svgSearchControl''
				,html: ''<svg viewBox="0 0 100 100">''
						+ ''	<circle cx="50%" cy="50%" r="30%" style="stroke-width: 10%;"/>''
						+ ''</svg>''
			})
		});

		searchMarkerGroup.addLayer(searchMarker);

		searchMarkersDiv = document.getElementsByClassName(''svgSearchControl'')
		n = searchMarkersDiv.length;
		for (var i = 0; i < n; i++) {
			var e = searchMarkersDiv[i];
			e.style.zIndex = (parseInt(e.style.zIndex) - 1).toString()
		}

	} else {
		e.layer.setStyle({
			fillColor: ''#3f0'',
			color: ''#0f0''
		});
	}
}).on(''search:collapsed'', function(e) {
	searchMarkerGroup.clearLayers();

	searchGroup.eachLayer(function(layer) {
		layer.resetStyle(layer.target);
	});
});

map.addControl(searchControl);



// General definition to be used on all themes
var object_renderer = L.canvas({
	tolerance: 5
});



//
// QGIS2WEB FUNCTIONS
//
map.attributionControl.setPrefix(''<a href="https://github.com/tomchadwin/qgis2web" target="_blank">qgis2web</a> &middot; <a href="https://leafletjs.com" title="A JS library for interactive maps">Leaflet</a> &middot; <a href="https://qgis.org">QGIS</a>'');

var boundsGroup = new L.featureGroup([]);

function setBounds() {
	if (boundsGroup.getLayers().length) {
		map.fitBounds(boundsGroup.getBounds());
	}
}



//
// DATA + LAYERS
//
var showLayersGroup = new L.featureGroup([]);
var errorsGroup = new L.featureGroup([]);

var overlayGroup = [];
var filterGroup = [];



[__JS__]



//
// Basemaps
//

// var basis_sagsbehandlerkort = L.tileLayer.wms("https://api.dataforsyningen.dk/forvaltning2?token=b95cc072101126dcb1497a22b00fed44", {
var basis_sagsbehandlerkort = L.WMS.overlay("https://api.dataforsyningen.dk/wms/forvaltning2?token=b95cc072101126dcb1497a22b00fed44", {
	layers: ''Basis_kort,Stednavne_basiskort,Kommunegraense,Vejnavne_basiskort,Husnummer''
	,format: ''image/png''
	,transparent: true
	,attribution: ''&copy; <a href="https://www.klimadatastyrelsen.dk/om-os/vilkaar-og-priser" target="_blank">KDS</a>''
	,maxNativeZoom: 20
	,maxZoom: 28
});

var basis_skaermkort_daempet = L.WMS.overlay("https://api.dataforsyningen.dk/topo_skaermkort_DAF?token=b95cc072101126dcb1497a22b00fed44", {
	layers: ''dtk_skaermkort_daempet''
	,format: ''image/png''
	,transparent: true
	,attribution: ''&copy; <a href="https://www.klimadatastyrelsen.dk/om-os/vilkaar-og-priser" target="_blank">KDS</a>''
	,maxNativeZoom: 20
	,maxZoom: 28
});

var basis_orto_foraar = L.WMS.overlay("https://api.dataforsyningen.dk/orto_foraar_DAF?token=b95cc072101126dcb1497a22b00fed44", {
	layers: ''orto_foraar''
	,format: ''image/png''
	,transparent: true
	,attribution: ''&copy; <a href="https://www.geodanmark.dk/home/vejledninger/vilkaar-for-data-anvendelse/" target="_blank">GeoDanmark</a>''
	,maxNativeZoom: 20
	,maxZoom: 28
});

var basis_osm = L.tileLayer(''https://tile.openstreetmap.org/{z}/{x}/{y}.png'', {
	maxNativeZoom: 19
	,maxZoom: 28
	,attribution: ''&copy; <a href="http://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>''
});

var basis_no_layer = L.tileLayer('''', {maxZoom: 28});



var baseLayerStartup = basis_sagsbehandlerkort;
var baseMaps = [
	{label: ''Intet baggrundskort'', layer: basis_no_layer}
	,{label: ''Sagsbehandlerkort'', layer: basis_sagsbehandlerkort}
	,{label: ''Skærmkort, dæmpet'', layer: basis_skaermkort_daempet}
	,{label: ''Ortofoto'', layer: basis_orto_foraar}
//	,{label: ''OpenStreetMap'', layer: basis_osm}
];



//
// QGIS2WEB
//

var layerControl = L.control.layers.tree(baseMaps, overlayMaps,{
	collapsed: false
	,closedSymbol: ''&#x25B6;''
	,openedSymbol: ''&#x25BC;''
}).addTo(map);

setBounds();
zoomHome.setHomeZoom(map.getBoundsZoom(boundsGroup.getBounds(), false))
zoomHome.setHomeBounds(boundsGroup.getBounds())



// Remove all layers added by SearchControl
map.eachLayer(function(layer) {
	map.removeLayer(layer)
})



// Add base layer
map.addLayer(baseLayerStartup)



// Add layers
showLayersGroup.eachLayer(function(layer) {
	map.addLayer(layer)
})



// Maintain searchGroup
map.on(''layerremove'', onLayerAddRemove);
map.on(''layeradd'', onLayerAddRemove);



// Add searchMarker
map.addLayer(searchMarkerGroup)'
	);