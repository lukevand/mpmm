#!/bin/sh

# if [ ! -n "$1" ]; then
#     echo "Usage: mppush [number]"
#     exit 1
# fi

pos="$TMP"/old_mpd_position
if [ -f "$pos" ]; then
    track=$(cat "$pos")
    mpc play "$track"
    rm "$pos"
else
    mpc -f '%position%' current > "$pos"
    mpc play "$1"
fi
