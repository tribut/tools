#!/bin/sh

curl -f -s "http://de.wikipedia.org/w/index.php?title=Liste_der_Kfz-Kennzeichen_in_Deutschland&action=raw" |
	grep -E "'''[A-Z0-9]+'''" |              # hopefully matches only names of animals :)
	sed -r "s#[^']+'''##;
	s#'''.*##" |
	tr 'a-zöäü' 'A-ZÖÄÜ' |
	sort -u
