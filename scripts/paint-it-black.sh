#!/bin/sh
# set the background color in the default ubuntu bootsplash and grub
# themes to black. i like a lot of things about the default ubuntu look
# and feel but that weird purple certainly is not among those.
#     -- felix@tribut.de

notice() {
	echo "$@" >&2
}

sedfilter() {
	SOURCE="$1"
	FILTER="$2"
	[ -w "$SOURCE" ] || { notice "$SOURCE not writeable"; return 1; }
	TEMPFILE="`mktemp`"

	cp "$SOURCE" "$TEMPFILE" && sed -r "$FILTER" < "$TEMPFILE" > "$SOURCE"
	RETCODE="$?"

	if [ 0 -eq "$RETCODE" ]; then
		notice "$SOURCE: done, the changes are as follows:"
		diff -u "$TEMPFILE" "$SOURCE" >&2
	fi

	rm -f "$TEMPFILE"
	return "$RETCODE"
}

THEMEDIR="/usr/share/plymouth/themes" # xenial and up
[ -f "$THEMEDIR/ubuntu-logo/ubuntu-logo.grub" ] || THEMEDIR="/lib/plymouth/themes" # until wily

sedfilter \
	"$THEMEDIR/ubuntu-logo/ubuntu-logo.grub" \
	's/background_color [0-9]+,[0-9]+,[0-9]+/background_color 0,0,0/'
sedfilter \
	"$THEMEDIR/ubuntu-logo/ubuntu-logo.script" \
	's/^(Window.SetBackground(Top|Bottom)Color ?)\(0\.[0-9]{1,2}, 0\.[0-9]{1,2}, 0\.[0-9]{1,2}\)/\1(0.00, 0.00, 0.00)/'
sedfilter \
	"$THEMEDIR/ubuntu-text/ubuntu-text.plymouth" \
	's/^black=0x[a-fA-F0-9]{6}/black=0x000000/'

notice "You may want to run 'update-initramfs -u -k all && update-grub' now :)"

if update-alternatives --query gdm3.css 2>/dev/null | grep '^Link: ' | grep -q '/ubuntu.css$'
then
	notice "To modify the background of gdm, check 'update-alternatives --config gdm3.css'"
fi
