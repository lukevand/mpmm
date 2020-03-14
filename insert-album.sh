#!/bin/sh
output_album=$(mpc list album | dmenu -i -l 20)
if [ -z "$output_album" ]; then
    return
fi
mpc find album "$output_album" | tac | while read -r song; do mpc insert "$song"; done

