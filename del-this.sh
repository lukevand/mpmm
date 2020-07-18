#!/bin/sh

music_directory=$(awk '/music_directory/ { gsub(/"/, ""); print $2 }' ~/.config/mpd/mpd.conf)
todel=$(mpc -f '%file%' current)

case "$1" in
    s|song)
        printf "adding current song\n"
        skip="mpc next"
        ;;
    *)
        todel=$(dirname "$todel")
        skip="mp n"
        ;;
esac


printf "%s/%s\n" "$music_directory" "$todel" | tee -a "${HOME}"/todel_music

# Skip this song/album
$skip
