#!/bin/sh
#
# needs xls2csv from catdoc

# data from https://www.destatis.de/DE/ZahlenFakten/LaenderRegionen/Regionales/Gemeindeverzeichnis/Administrativ/AdministrativeUebersicht.html ("Politisch selbstständige Gemeinden")
xls2csv -q3 data/AuszugGV2QAktuell.xls |
	sed 's#^,#"",#;s#,,#,"",#g;s#,,#,"",#g;s#,$#,""#' | # escape empty fields (for awk)
	awk -F"\",\"" '{ print $7","$8 }' |                 # filter gemeinde-nr, gemeinde-name
	grep -E "^[0-9]+," |                                # only show entries with gemeinde-nr
	sed -r 's#[^,]+,##;s#,[^,]+$##                      # remove gemeinde-nr, gemeinde-typ
	s# (am|vor|im|bei|auf|in|an) .*##i;                 # remove common suffixes
	s# [aibv]\..*##i;                                   # remove common suffixes (abbrev)
	s# [(].*##; s#/.*##' |                              # remove suffixes
	tr 'a-zöäü' 'A-ZÖÄÜ' |
	sort -u
