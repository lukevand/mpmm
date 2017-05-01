#!/bin/sh
# Needs: mpc

if [ "$1" = "-h" ]
then
	cat <<- EOF
	Usage: $(basename $0) regexp
	if no regexp is provided, the current album is removed from playlist.
	EOF
	exit 1
fi
album=$(mpc -f "%album%" playlist | grep -i -- "$1" | head -n 1)
if [ -n "$album" ]
then
	mpc -f "%position% %album%" playlist | grep -F -- "$album" | \
		cut -d ' ' -f1 | mpc del
	printf 'Album "%s" removed from playlist.\n' "$album"
fi
