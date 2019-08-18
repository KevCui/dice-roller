#!/usr/bin/env bash
#
# Dice roller
#
#/ Usage:
#/   ./roll.sh [n]d[s]
#/
#/ Options:
#/   n      number of dice(s)
#/   s      dice side
#/
#/ Examples:
#/   \e[32m- Roll 3 d20:\e[0m
#/     ~$ ./roll.sh \e[33m3d20\e[0m
#/
#/   \e[32m- Roll 1 d2:\e[0m
#/     ~$ ./roll.sh \e[33md2\e[0m

set -e
set -u

usage() {
    # Display usage message
    printf "%b\n" "$(grep '^#/' "$0" | cut -c4-)" && exit 0
}

set_var() {
    # Declare variables used in script
	expr "$*" : ".*--help" > /dev/null && usage
    _DICE="${1:-}"
    if [[ "$_DICE" =~ ^([[:digit:]])?+d[[:digit:]]+$ ]]; then
        _DICE_NUM=${_DICE%d*}
        _DICE_SIDE=${_DICE#*d}
    else
        echo "Wrong dice!" && usage
    fi
}

check_var() {
    # Check $_DICE_NUM and $_DICE_SIDE
    if [[ -z "$_DICE_NUM" || "$_DICE_NUM" == 0 ]]; then
        _DICE_NUM=1
    fi
    if [[ -z "$_DICE_SIDE" || "$_DICE_SIDE" == 0 ]]; then
        echo "Missing dice side d?, like: d4, d6, d8..." & usage
    fi
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
    local side num s n
    side="$1"
    num="$2"
    n=""
    s=""
    for ((i=1; i<=num; i++));do
        spinning 2
        n="$((1 + RANDOM % side))"
        s=$((s+n))
        printf "\b%s\t" "$n"
    done

    if [[ "$2" -gt 1 ]]; then
        printf "\nTotal: %s\n" "$s"
    else
        printf "\n"
    fi
}

main() {
    set_var "$@"
    check_var
    roll "$_DICE_SIDE" "$_DICE_NUM"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
