#!/bin/sh

usage() {
    cat <<EOF
    playlist|play|p    - mpc-playlist
    next-album|na|n    - mpc-next-album
    random|rand|r num  - mpc-add-random-album.sh num
    h                  - usage
EOF
}

mpc_albums() {
    mpc -f '%position% %album%' playlist | uniq --skip-fields=1
}

mpc_playlist() {
    case "$1" in
        a)
            mpc_albums | grep --color=auto --fixed-strings \
                              --context "${2:-10}" -- "$(mpc --format '%album%')$"
            ;;
        *)
            mpc playlist | grep --line-number --color=auto --fixed-strings \
                                --line-regexp --context "${2:-10}" -- "$(mpc current)"
            ;;
    esac
}

# {{{ mpc-next-album

play_track()
{
    track="$1"
    if [ "$track" ]; then
        mpc "$extra_opts" play "$track"
    else
        printf '%s failed, track is empty\n' "$0" 2>&1
        exit 1
    fi
}


at_end()
{
    mpc_albums | "$head_tail" -n1 | grep -F -- "$current" >/dev/null
}


next_album()
{
    track=$(mpc_albums | grep -F "$grep_context" -- "$current" | \
                "$head_tail" -n1 | cut -d' ' -f1)
    play_track "$track"
}


mpc_next_album() {
    skip_num="${2:-1}"
    extra_opts="${3:--v}"

    # If $skip_num doesn't match the pattern [0-9]*
    if ! expr "$skip_num" : '[0-9]*' >/dev/null; then
        printf '%s is not a number\n' "$skip_num"
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

    if at_end >/dev/null; then
        printf 'Back to the start...\n\n'
        mpc "$extra_opts" play 1
    else
        next_album
    fi
}

# }}} mpc-next-album

# Pass $2 to the other function
case "$1" in
    list|l)
        mpc_playlist "${2:-1}"
        ;;
    la)
        mpc_playlist a
        ;;
    next-album|na|n)
        mpc_next_album next "${2:-1}"
        ;;
    p)
        mpc_next_album previous "${2:-1}"
        ;;
    random|rand|r)
        mpc-add-random-album.sh "${2:-1}"
        ;;
    h)
        usage
        ;;
    *)
        printf '? "%s"\n' "$1"
        usage
        ;;
esac
