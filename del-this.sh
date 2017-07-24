#!/bin/sh

# If I don't like what I'm listening to, add it to a list to delete later

music_directory="/sov/Music"
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


printf "%s/%s\n" "$music_directory" "$todel" | tee --append "${HOME}"/todel_music

# Skip this song/album
$skip
