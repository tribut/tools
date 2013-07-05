<?php

 // This program is free software; you can redistribute it and/or
 // modify it under the terms of the GNU General Public License (GPL)
 // as published by the Free Software Foundation; either version 2
 // of the License, or (at your option) any later version.
 //
 // This program is distributed in the hope that it will be useful,
 // but WITHOUT ANY WARRANTY; without even the implied warranty of
 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 // GNU General Public License for more details.
 //
 // To read the license please visit https://www.gnu.org/copyleft/gpl.html
 //
 // Felix Eckhofer <felix@tribut.de>

/* **************************************************************** */
/*      CONFIGURATION                                               */
/* **************************************************************** */
$min_width = 1;       // minimale wortlänge
$max_width = 15;      // maximale wortlänge
$def_width = 4;       // standard wortlänge
$height = 15;         // anzahl worteingabefelder
$dictfiles = array(   // wörterbuchdateien
	"Deutsche Wörter" => "german.dic",
	"Deutsche Städte" => "staedte.dic",
	"Deutsche Städte und Gemeinden" => "gemeinden.dic",
	"KFZ-Kennzeichen Deutschland" => "kfz.dic",
	"Automarken" => "autos.dic",
	"Tiere" => "tiere.dic"
);
$width_modes = array( // modi für wortlänge
	"exakt",      // "normal"
	"zwischen"    // "spezial"
); // bei änderungen hier muss die logik
   // entsprechend angepasst werden

/* **************************************************************** */
/*      DEFAULTS                                                    */
/* **************************************************************** */
$width = $def_width;  // gew. (max.) wortlänge
$dict = 0;            // nummer des gew. wörterbuchs
$dictfile = current($dictfiles); // dateiname des gew. wörterbuchs
$width_mode = 0;      // modus für wortlänge

/* **************************************************************** */
/*      USER INPUT                                                  */
/* **************************************************************** */
if (isset($_GET['show_source'])) {
	header('Content-Type: text/plain; charset=iso-8859-15');
	readfile(__FILE__);
	exit;
}
if (isset($_REQUEST['width'])) {
	$user_width = intval($_REQUEST['width']);
	if ($user_width <= $max_width  && $user_width >= $min_width) {
		$width = $user_width;
	}
}
if (isset($_REQUEST['width_mode'])) {
	$user_width_mode = intval($_REQUEST['width_mode']);
	if (!empty($width_modes[$user_width_mode])) {
		$width_mode = $user_width_mode;
	}
}
if (isset($_REQUEST['width_min'])) {
	$user_width_min = intval($_REQUEST['width_min']);
	if ($user_width_min < $max_width && $user_width_min >= $min_width) {
		$width_min = $user_width_min;
	}
	if ($width_min >= $width) {
		$width = $width_min + 1;
	}
}
if (isset($_REQUEST['dict'])) {
	$user_dict = array_values($dictfiles);
	$user_dict = $user_dict[intval($_REQUEST['dict'])];
	if (!empty($user_dict)) {
		$dict = intval($_REQUEST['dict']);
		$dictfile = $user_dict;
	}
}

/* **************************************************************** */
/*      BEGINN DOKUMENT                                             */
/* **************************************************************** */

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-15">
<meta name="description" content="Tool zum Lösen von Buchstabenrätseln (Platzhalter) wie es bei Call-In-Formaten wie 9live oder Money Express gespielt wird. Das Programm hat Listen für <?php echo implode(", ", array_flip($dictfiles)); ?>">
<meta name="author" content="Felix Eckhofer">
<meta name="robots" content="index,follow">
<title>Lösungshilfe für "Wort mit <?php echo $width; ?> Buchstaben"</title>
<script language="JavaScript" type="text/javascript">
 <!--
 function advance(currentField,nextField) {
 if (document.getElementById("field"+currentField).value.length == 1)
 document.getElementById("field"+nextField).focus();
 }
 //-->
</script> 
<style type="text/css">
html, body {
	font-family: Verdana, Helvetica, sans-serif;
}
h1 {
	text-align: center;
}
legend {
	font-size: 1.2em;
	font-weight: bold;
}
fieldset {
	margin-bottom: 2em;
}
</style>
</head>
<body>

<h1>Platzhalter-Spiel</h1>
<h2>Wort-mit-<?php echo ($width_mode==1?'(maximal)-':'') . $width; ?>-Buchstaben-Rätsel</h2>

<form method="get" action="<?php echo str_replace('"', '', $_SERVER['REQUEST_URI']); ?>">

<fieldset>
<legend>Einstellungen</legend>
<p>Wieviele Buchstaben sollen die gesuchten Wörter haben?</p>

<select name="width_mode" onchange="javascript:document.forms[0].submit()">
<?php
foreach ($width_modes as $index => $name) {
        echo '<option value="'.$index.'" '.($width_mode==$index?'selected':'').'>'.$name.'</option>';
}
?>
</select>

<?php
if ($width_mode == 1) { // "zwischen"
?>

<select name="width_min" onchange="javascript:document.forms[0].submit()">
<?php
for ($i = $min_width; $i <= $max_width; $i++) {
        echo '<option value="'.$i.'" '.($width_min==$i?'selected':'').'>'.$i.'</option>';
}
?>
</select>

und

<?php
} // if ($width_mode == 1)
?>

<select name="width" onchange="javascript:document.forms[0].submit()">
<?php
for ($i = $min_width; $i <= $max_width; $i++) {
	echo '<option value="'.$i.'" '.($width==$i?'selected':'').'>'.$i.'</option>';
}
?>
</select>
<p>Welches Wörterbuch soll benutzt werden?</p>
<select name="dict" onchange="javascript:document.forms[0].submit()">
<?php
$i = 0;
foreach ($dictfiles as $name => $file) {
	echo '<option value="'.$i.'" '.($dictfile==$file?'selected':'').'>'.$name.'</option>';
	$i++;
}
?>
</select>

<noscript><br><br><input name="change" type="submit" value="Übernehmen"></noscript>

<small>(<a href="https://github.com/tribut/tools/tree/master/platzhalter/dic">Quellen und Download</a>)</small>

</fieldset>

</form>

<form method="post" action="<?php echo str_replace('"', '', $_SERVER['REQUEST_URI']); ?>">

<input type="hidden" name="width" value="<?php echo $width; ?>">
<input type="hidden" name="width_min" value="<?php echo $width_min; ?>">
<input type="hidden" name="width_mode" value="<?php echo $width_mode; ?>">
<input type="hidden" name="dict" value="<?php echo $dict; ?>">

<fieldset>
<legend>Vorgabe</legend>
<p>Hier werden Buchstaben vorgegeben, die <em>auf jeden Fall zutreffen sollen</em>.</p>
<p>Wird also nach "Wort, das mit einem P beginnt" gesucht, muss im ersten Feld das 'P' eingetragen werden.</p>
<?php
$field = 0;
for ($i = 0; $i < $width; $i++) {
	$formfield = 'preset' . $i;
	$fielddata = str_replace('"', '', $_REQUEST[$formfield]);

	echo '<input id="field'.++$field.'" onKeyUp="advance('.$field.','.($field+1).')" type="text" name="' . $formfield . '" size="5" maxlength="1" value="'.(isset($_REQUEST['reset'])?'':$fielddata).'" >';
}
echo "<br>\n";
?>
</fieldset>

<fieldset>
<legend>Ausschluss</legend>
<p>Hier werden die Buchstaben vorgegeben, die an entsprechenden Stelle <em>nicht im Wort vorkommen sollen</em>.</p>
<p>Wird also in einer Reihe "WELT" eingegeben, wird nach Wörtern gesucht, die an erster Stelle kein 'W', an zweiter Stelle kein 'E', an dritter Stelle kein 'L' und an vierter Stelle kein 'T' enthalten. Gibt es für die entsprechende Position eine Vorgabe, wird das Ausschlusskriterium ignoriert.</p>
<?php
for ($i = 0; $i < $height; $i++) {
	for ($j = 0; $j < $width; $j++) {
		$formfield = 'value' . $i . $j;
		$fielddata = str_replace('"', '', $_REQUEST[$formfield]);

		echo '<input id="field'.++$field.'" onKeyUp="advance('.$field.','.($field+1).')" type="text" name="' . $formfield . '" size="5" maxlength="1" value="'.(isset($_REQUEST['reset'])?'':$fielddata).'" >';
	}
	echo "<br>\n";
}
?>
</fieldset>

<fieldset>
<legend>Zulässige Buchstaben</legend>
<p>Wenn das Feld ausgefüllt wird, werden nur Worte gesucht, die sich aus den <em>Buchstaben der Eingabe bilden lassen</em>.</p>
<p>Wird hier also zum Beipiel "Brocken" eingegeben, lässt sich daraus BOCK bilden, nicht aber ECKE oder BRATEN).</p>
<input type="text" name="buildfrom" size="20" value="<?php echo str_replace('"','',$_REQUEST['buildfrom']) ?>">
</fieldset>

<input name="go" type="submit" value="Anzeigen">
<input name="reset" type="submit" value="Eingaben zurücksetzen">

</form>

<?php
if (isset($_REQUEST['go'])){

for ($i = 0; $i < $width; $i++) {
	for ($j = 0; $j < $height; $j++) {
		$formfield = 'value' . $j . $i;
		if (preg_match('/^[A-ZÖÄÜa-zöäüß]$/', $_REQUEST[$formfield])) {
			$values[$i][$j] = mb_strtoupper($_REQUEST[$formfield]);
		}
	}
	@$values[$i] = array_unique($values[$i]);
}

$query = '';
for ($i = $width - 1; $i >= 0; $i--) {
	if (preg_match('/^[A-ZÖÄÜa-zöäüß]$/', $_REQUEST['preset' .$i])){
		$query = '['.mb_strtoupper($_REQUEST['preset' .$i]).']' . $query;
	}else{
		$subquery = '';
		for ($j = 0; $j < $height; $j++) {
			if (isset($values[$i][$j]))
				$subquery .= $values[$i][$j];
		}
	
		if (empty($subquery)) {
			$query = '([A-ZÖÄÜß()&,0-9. -])' . $query;
		}else{
			$query = '([^' . $subquery . ' \n\r.])' . $query;
		}
	}

	if ($width_mode == 1 && $i >= $width_min) { // character can be optional
		$query = '(' . $query . ')?';
	}
}

$query = '/^' . $query . '$/';
// echo $query;

$words = file($dictfile);
$match = preg_grep($query, $words);

function is_built_from($word)
{
	$filter = mb_strtoupper($_REQUEST['buildfrom']);
	if (empty($filter)) {
		return true;
	}
	$wordarray = preg_split('//', trim($word), -1, PREG_SPLIT_NO_EMPTY);
	foreach($wordarray as $char) {
		if (substr_count($filter, $char) < substr_count($word, $char)) {
			return false;
		}
	}
	return true;
}

$match = array_filter($match, 'is_built_from');

echo '<h2>' . count($match) . ' Treffer</h2>';
echo '<div style="padding: 1em 2em; background: #cdcdcd;"><tt>';
foreach($match as $word) {
	echo '   '.$word.'<br>';
}
echo '</tt></div>';

} // isset($_REQUEST['go'])

?>

<div style="margin: 3em 1em 0 1em; border: 1px black dashed; text-align: center; font-size: 0.7em">
<p>
  Fragen / Anregungen / Kontakt / neues Wörterbuch: <a target="_blank" href="https://tribut.de/kontakt" >hier abgeben</a>
</p>
<p>
  <!--[if lte IE 8]><span style="filter: FlipH; -ms-filter: "FlipH"; display: inline-block;"><![endif]-->
  <span style="-moz-transform: scaleX(-1); -o-transform: scaleX(-1); -webkit-transform: scaleX(-1); transform: scaleX(-1); display: inline-block;">
    &copy;
  </span>
  <!--[if lte IE 8]></span><![endif]--> Der <a href="?show_source">Quelltext dieses Programms</a> (<a href="https://github.com/tribut/tools/tree/master/platzhalter">GitHub</a>) steht unter der <a href="https://www.gnu.org/copyleft/gpl.html" target="_blank">GNU GPL</a> zur Verfügung.
  <span style="white-space: nowrap;">
    Letzte Änderung: <?php echo date ("d.m.Y H:i", filemtime(__FILE__))?>.
  </span>
</p>
</div>

<p style="text-align: right; margin: 1em;">
  <a href="https://flattr.com/submit/auto?user_id=dxbi&url=https://extern.tribut.de/platzhalter&title=Platzhalter&description=L%C3%B6sungshilfe%20f%C3%BCr%20Wortr%C3%A4tsel&language=de&tags=php&category=software"><img src="https://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" /></a>
</p>

</body>
</html>

