#!/usr/bin/env bash
#
# Dice roller
#
#/ Usage:
#/   ./roll.sh [n]d[s] ...
#/
#/ Options:
#/   n      number of dice(s)
#/   s      dice side
#/
#/ Examples:
#/   \e[32m- Roll 3d20:\e[0m
#/     $ ./roll.sh \e[33m3d20\e[0m
#/
#/   \e[32m- Roll 1d2:\e[0m
#/     $ ./roll.sh \e[33md2\e[0m
#/
#/   \e[32m- Roll 5d2, 4d8 and 1d20:\e[0m
#/     $ ./roll.sh \e[33m5d2 4d8 d20\e[0m

set -e
set -u

usage() {
    # Display usage message
    printf "%b\n" "$(grep '^#/' "$0" | cut -c4-)" && exit 0
}

set_var() {
    # Declare variables used in script
	expr "$*" : ".*--help" > /dev/null && usage
    _DICE_NUM=()
    _DICE_SIDE=()
    local n s
    n=0
    s=0
    for dice in "$@"; do
        if [[ "$dice" =~ ^([[:digit:]])*d[[:digit:]]+$ ]]; then
            n=${dice%d*}
            s=${dice#*d}
            if [[ -z "$n" || "$n" == 0 ]]; then
                n=1
            fi
            if [[ -z "$s" || "$s" == 0 ]]; then
                echo "Missing dice side, like: d4, d6, d8..." & usage
            fi
            _DICE_NUM+=("$n")
            _DICE_SIDE+=("$s")
        else
            echo "Wrong dice: $dice!" && usage
        fi
    done
}

spinning() {
    # Show spinning progress bar
    # $1: n round
    local s i p
    s=0
    i=0
    p='-\|/'
    while [[ $((i/4+1)) -le "$1" ]]; do
      i=$((i+1))
      s=$(((s+1)%4))
      printf "\b%s${p:$s:1}"
      sleep .1
    done
}

roll() {
    # Roll dice(s)
    # $1: side
    # $2: number
    local side num s n i
    side="$1"
    num="$2"
    n=0
    s=0

    printf "%sd%s:\t" "$num" "$side" >&2
    for ((i=1; i<=num; i++));do
        spinning 2 >&2
        n=$((1 + RANDOM % side))
        s=$((s+n))
        printf "\b%s\t" "$n" >&2
    done

    printf "%s" "$s"
}

main() {
    set_var "$@"

    local s n i
    s=0
    n=0
    for ((i=0; i<${#_DICE_NUM[@]}; i++)); do
        n=$(roll "${_DICE_SIDE[$i]}" "${_DICE_NUM[$i]}")
        s=$((s+n))
        printf "\n"
    done

    if [[ "$s" -gt 0 ]]; then
        printf "%s\nTotal: %s\n" "---" "$s"
    else
        usage
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
