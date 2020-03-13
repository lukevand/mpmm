#!/bin/sh

mpc listall | dmenu -i -l 40 | xargs -d'\n' -r -I% mpc -q insert % && notify-send -u low "Next:" "$(mpc queued)"
