#!/bin/sh

mpc listall | dmenu -i -l 40 | xargs -d'\n' -r -I% mpc -q insert % && notify-send -u low "Next:" "$(mpc queued)"
# mpc listall | fzf --reverse --select-1 | xargs -r -I% mpc -q insert % && notify-send -u low "Next:" "$(mpc queued)"
