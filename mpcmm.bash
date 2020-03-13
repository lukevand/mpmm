#!/bin/bash
set -u

if [ "$1" = "d" ]; then
    # dvorak
    forward_5='n'
    forward_60='r'
    backward_5='h'
    backward_60='g'
    mpc_status='s'
    next='.'
    prev=','
elif [ "$1" = "c" ]; then
    # colemak
    forward_5='i'
    forward_60='y'
    backward_5='n'
    backward_60='l'
    mpc_status='o'
    mpc_album_status='O'
    next='.'
    prev=','
    album_next='>'
    album_prev='<'
    toggle='p'
else
    forward_5='l'
    forward_60='o'
    backward_5='j'
    backward_60='u'
    mpc_status=';'
    mpc_album_status=':'
    next='.'
    prev=','
    album_next='>'
    album_prev='<'
    toggle='p'
fi


while read -n1 -r cmd; do
    printf \\n
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
            mpc status
            ;;
        $mpc_album_status)
            mp l
            ;;
        $next)
            mpc next
            ;;
        $prev)
            mpc prev
            ;;
        $toggle)
            mpc toggle
            ;;
        $album_prev)
            mp p
            ;;
        $album_next)
            mp n
            ;;
        q)
            exit
            ;;
    esac
done
