#!/bin/sh
set -euf

export music_directory="${HOME}/music"
export mpmm_data="${HOME}/mpmm"
this_dir=$(dirname "$(readlink -f "$0")")

PATH="$PATH:$this_dir"

usage() {
    cat <<EOF
$0 opt, where opt is
    l|list         - prints playlist
    la             - printts album playlist
    nextalbum|na|n - next album
    previous|p     - previous album
    random|rand|r  - mpc-add-random-album.sh num
    location|f     - current song location
    info|i         - current song info
    h              - usage
    insert|s       - insert-song with dmenu
EOF
}

current_song_location() {
    printf '%s/%s\n' "$music_directory" "$(mpc -f '%file%' current)"
}

song_info() {
    current="$(current_song_location)"
    if command -v mediainfo >/dev/null; then
        mediainfo "$current"
    else
        file -b "$current"
    fi
}


arg="${1:-}"
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
    n|next)
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
        printf '? "%s"\n' "$arg" "$@"
        usage
        ;;
esac
