#!/bin/sh

music_directory="/sov/Music"

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


mpc_albums() {
    mpc -f '%position% %album%' playlist | uniq --skip-fields=1
}


mpc_playlist_album() {
    mpc_albums | grep --color=auto -F  --context "${1:-10}" \
                      -- "$(mpc --format '%album%')$"
}


mpc_playlist() {
    mpc playlist | grep --line-number --color=auto -F       \
                        --line-regexp --context "${1:-10}"  \
                        -- "$(mpc current)"
}


play_track() {
    local track
    track="$1"
    if [ "$track" ]; then
        mpc "$extra_opts" play "$track"
    else
        printf '%s failed, track is empty\n' "$0" 2>&1
        exit 1
    fi
}


at_end() {
    local head_tail current
    head_tail="$1"
    current="$2"
    mpc_albums | "$head_tail" -n1 | grep -F -- "$current" >/dev/null
}


next_album() {
    local track
    track=$(mpc_albums | grep -F "$grep_context" -- "$current" | \
                "$head_tail" -n1 | cut -d' ' -f1)
    play_track "$track"
}


mpc_next_album() {
    local skip_num extra_opts
    local grep_context head_tail
    skip_num="${2:-1}"
    extra_opts="${3:--v}"

    # If $skip_num doesn't match the pattern [0-9]*
    if ! expr "$skip_num" : '[0-9]*' >/dev/null; then
        echo "Usage: $0 (n|next-album) [previous|next] [num_to_skip] [extra_mpc_opt]"
        exit 1
    fi

    current=$(mpc -f '%album%' current)

    case "$1" in
        p|prev|previous|0)
            grep_context="-B${skip_num}"
            head_tail='head'
            ;;
        *)
            grep_context="-A${skip_num}"
            head_tail='tail'
            ;;
    esac

    if at_end "$head_tail" "$current" >/dev/null; then
        printf 'Back to the start...\n\n'
        mpc "$extra_opts" play 1
    else
        next_album
    fi
}


current_song() {
    printf "%s/%s\n" "$music_directory" "$(mpc -f '%file%' current)"
}


song_info() {
    file -b "$(current_song)"
}


arg="$1"
if [ -z "$arg" ]; then
    usage
    exit 1
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
    p)
        mpc_next_album previous "$@"
        ;;
    random|rand|r)
        mpc-add-random-album.sh "$@"
        ;;
    f)
        current_song
        ;;
    i)
        song_info
        ;;
    h)
        usage
        ;;
    *)
        printf '? "%s"\n' "$@"
        usage
        ;;
esac
