#!/bin/sh

curl -f -s "http://de.wikipedia.org/w/index.php?title=Liste_der_St%C3%A4dte_in_Deutschland&action=raw" |
	grep '^:\[\[' |              # hopefully matches only names of cities :)
	sed -r 's#:\[\[##;s#.*[|]##; # delete start of line ":[["
	s#\]\].*##;                  # remote end of line "]] ..."
	s# (am|vor|im|bei|auf|in|an) .*##i;                 # remove common suffixes
	s# [aibv]\..*##i;                                   # remove common suffixes (abbrev)
	s# [(].*##; s#/.*##' |                              # remove suffixes
	tr 'a-zöäü' 'A-ZÖÄÜ' |
	sort -u
