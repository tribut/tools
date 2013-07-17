#!/bin/bash
# ################################################# #
#                 duply-do-backup                   #
#                                                   #
# this script is meant to be called from cron and   #
# first starts a backup and then a purge using      #
# duply. it will not generate any output if all     #
# works smoothly. if anything goes wrong, the       #
# full log is displayed.                            #
#                                felix@eckhofer.com #
# ################################################# #

LOGFILE="`mktemp`"
PROFILE="$1"
PROFILEPATH="/etc/duply/$PROFILE"
export RSYNC_RSH='ssh -oBatchMode=yes -oLogLevel=Error' # avoid printing ssh banner

function exit_error() {
	[ -z "$@" ] || echo "$@"
	rm -f "$LOGFILE"
	exit 1
}

if [ -z "$PROFILE" ]; then
	exit_error "usage: `basename $0` backup-profile"
fi

if [ ! -d "$PROFILEPATH" ]; then
	exit_error "profile not found."
fi

echo "### Backing up ###" >> "$LOGFILE"

if ! duply "$PROFILE" backup >> "$LOGFILE"
then
	cat "$LOGFILE"
	exit_error
fi

echo "### Cleaning up ###" >> "$LOGFILE"

if ! duply "$PROFILE" purge-full --force >> "$LOGFILE"
then
	cat "$LOGFILE"
	exit_error
fi

rm "$LOGFILE"
