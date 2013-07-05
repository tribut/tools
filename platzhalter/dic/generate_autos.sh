#!/bin/sh

RAW="`mktemp`"
OUT="`mktemp`"

curl -f -s "http://de.wikipedia.org/w/index.php?title=Liste_von_Automobilmarken&action=raw" > "$RAW"
grep '^|\[\[' "$RAW" |            # brands with links
	sed -r 's#^\|\[\[##;          # remove start of line "|[["
	s#[^]]+\|##;                  # remove link text if existing
	s#\]\].*##                    # remove end of line "]] ..."
	' >> "$OUT"

grep -E '^\|[^[|]+\|\|' "$RAW" |  # brands without links
	sed -r 's#^\|##;              # remove start of line "|"
	s#\|.*##                      # remove end of line "| ..."
	' >> "$OUT"

grep -E "^\|data-sort-value[^|]+\|[^']" "$RAW" | # brands with special characters
	sed -r 's#^\|[a-z-]+="##;     # remove start of line "|data-sort-value=\""
	s#".*##;                      # remove end of line "\" ..."
	s# &$##;                      # remove trailing &
	' >> "$OUT"

tr 'a-zöäü' 'A-ZÖÄÜ' < "$OUT" | sort -u
rm -f "$RAW" "$OUT"
