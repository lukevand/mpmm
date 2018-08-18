#!/bin/sh

pos=/tmp/old_mpd_position
if [ -f "$pos" ]; then
    track=$(cat "$pos")
    mpc play "$track"
    rm "$pos"
else
    mpc -f '%position%' current > "$pos"
    mpc play "$1"
fi
