#!/bin/sh

song=$(mpc listall | dmenu -i -l 20)
if [ "$song" ]; then
    echo "$song" | while read -r song; do
        mpc --verbose insert "$song"
    done
fi
