#!/bin/sh
# set the background color in the default ubuntu bootsplash and grub
# themes to black. i like a lot of things about the default ubuntu look
# and feel but that weird purple certainly is not among those.
#     -- felix@tribut.de

sedfilter() {
	SOURCE="$1"
	FILTER="$2"
	[ -w "$SOURCE" ] || { echo "$SOURCE not writeable" >&2; return 1; }
	TEMPFILE="`mktemp`"

	cp "$SOURCE" "$TEMPFILE" && sed -r "$FILTER" < "$TEMPFILE" > "$SOURCE"
	RETCODE="$?"

	if [ 0 -eq "$RETCODE" ]; then
		echo "## Filter successfully applied to $SOURCE, the changes are as follows:" >&2
		diff -u "$TEMPFILE" "$SOURCE" >&2
		echo
	fi

	rm -f "$TEMPFILE"
	return "$RETCODE"
}

sedfilter \
	/lib/plymouth/themes/ubuntu-logo/ubuntu-logo.grub \
	's/background_color [0-9]+,[0-9]+,[0-9]+/background_color 0,0,0/'
sedfilter \
	/lib/plymouth/themes/ubuntu-logo/ubuntu-logo.script \
	's/^(Window.SetBackground(Top|Bottom)Color ?)\(0\.[0-9]{1,2}, 0\.[0-9]{1,2}, 0\.[0-9]{1,2}\)/\1(0.00, 0.00, 0.00)/'
sedfilter \
	/lib/plymouth/themes/ubuntu-text/ubuntu-text.plymouth \
	's/^black=0x[a-fA-F0-9]{6}/black=0x000000/'
