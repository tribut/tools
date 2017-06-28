#!/bin/sh

curl -f -s http://ftp.tu-chemnitz.de/pub/Local/urz/ding/de-en/de-en.txt.gz |
	gzip -d |            # uncompress
	sed -r 's#.*:: ##;   # delete german
	/^#.*/d;             # delete comments
	s/ ?[;|] ?/\
/g;                      # split alternative forms into seperate lines
	s# ?[([{].*##;       # delete annotations and metadata
	/ [^ ]/d;            # delete composite phrases
	/\.\.\.$/d;          # delete word-parts
	s# $##;              # delete trailing white space
	' |
	tr 'a-zöäü' 'A-ZÖÄÜ' |
	sort -u

