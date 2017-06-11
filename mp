#!/bin/sh

export music_directory="/sov/Music"
this_dir="/home/sov/bin/mp--"

PATH="$PATH:$this_dir"

usage() {
    cat <<EOF
$0 opt, where opt is
    l - prints playlist
    la - printts album playlist
    n - next album
    p - previous album
    r - mpc-add-random-album.sh num
    f - current song location
    i - current song info
    h - usage
EOF
}

arg="$1"
if [ -z "$arg" ]; then
    mpc
    exit 0
fi

shift

case "$arg" in
    list|l)
        mpc_playlist "$@"
        ;;
    la)
        mpc_playlist_album "$@"
        ;;
    next-album|na|n)
        mpc_next_album next "$@"
        ;;
    p|previous)
        mpc_next_album previous "$@"
        ;;
    random|rand|r)
        mpc-add-random-album.sh "$@"
        ;;
    f|location)
        current_song_location
        ;;
    i|info)
        song_info
        ;;
    h|help|usage)
        usage
        ;;
    *)
        printf '? "%s"\n' "$@"
        usage
        ;;
esac
