#!/bin/bash
set -u

# dvorak
# forward_5='n'
# forward_60='r'
# backward_5='h'
# backward_60='g'
# mpc_status='s'
# next='.'
# prev=','

# colemak
forward_5='i'
forward_60='y'
backward_5='n'
backward_60='l'
mpc_status='o'
next='.'
prev=','


# -n1 is a bash extension.
# It reads one character in and doesn't wait for enter.
while read -n1 -r cmd; do
    case "$cmd" in
        $forward_5)
            mpc -q seek +5
            ;;
        $forward_60)
            mpc -q seek +60
            ;;
        $backward_5)
            mpc -q seek -5
            ;;
        $backward_60)
            mpc -q seek -60
            ;;
        $mpc_status)
            printf '\n'
            mpc status
            ;;
        $next)
            printf '\n'
            mpc next
            ;;
        $prev)
            printf '\n'
            mpc prev
            ;;
        q)
            printf '\n'
            exit
            ;;
    esac
done


