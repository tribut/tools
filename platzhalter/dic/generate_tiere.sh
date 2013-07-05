#!/bin/sh
#
# integrating further lists such as the subpages of
# http://de.wiktionary.org/wiki/Verzeichnis:Ornithologie
# would be nice...

curl -f -s "http://de.wiktionary.org/w/index.php?title=Verzeichnis:Tiere&action=raw" |
	grep '^\*\[\[' |              # hopefully matches only names of animals :)
	sed -r 's#\*\[\[##;s#.*[|]##; # delete start of line "*[["
	s#\]\].*##                    # remote end of line "]] ..."
	s#-##g' |                     # remove dash from composite names
	tr 'a-zöäü' 'A-ZÖÄÜ' |
	sort -u
