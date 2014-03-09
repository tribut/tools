#!/bin/sh
# convert sha1 oder sha256 certificate fingerprint in hex
# to format used by chrome://net-internals for pinning
#     -- felix@tribut.de

digest="$@"
[ -z "$digest" ] && read digest

stripped="`echo -n \"$digest\" | tr -d ': \n'`"
length="`echo -n $stripped | wc -c`"

case "$length" in
	40)
		type="sha1"
		;;
	64)
		type="sha256"
		;;
	*)
		echo "Length of digest doesn't match with any supported digest (given: $length)." >&2
		echo "Please call me with hex digest as parameter or piped via stdin." >&2
		exit 1
		;;
esac

echo "$type/`echo \"$digest\" | xxd -r -p | base64`"
