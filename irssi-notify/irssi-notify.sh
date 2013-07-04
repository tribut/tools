#!/bin/sh
#
# irssi-notify, 2007, felix@tribut.de

HOST="jason" # where to connect to
FILE="/home/irssi/.irssi/fnotify" # on remote host
ICON="$HOME/.local/share/icons/ksirc.png" # on local host

ssh "$HOST" "tail -n 5 $FILE; > $FILE; tail -f $FILE" |
	sed -ru "
		s/&/\&amp;/g;
		s/</\&lt;/g;
		s/>/\&gt;/g;
		s%(#[a-zA-Z]+ )&lt;([^>]{0,20})&gt;%\1<b>\2</b> %g
		s%(https?://[^ ]+(\.[a-zA-Z]{1,3})?)%<a href=\"\1\">\1</a>%g;" |
#		s%([a-zA-Z0-9+_-]+@[^ ]+\.[a-zA-Z]{1,3})%<a href=\"mailto:\1\">\1</a>%g;" |
	while read heading message
	do
		notify-send -i gtk-dialog-info -t 0 -u critical -i "$ICON" -- "${heading} (irssi on $HOST)" "${message}"
	done

notify-send -i gtk-dialog-info -t 0 -u critical -- "CONNECTION LOST (irssi on $HOST)" "The connection to $HOST was lost. Panic!"
