#!/bin/bash

# DIFF_PARAMS="-aur --color=auto"
DIFF_PARAMS="-aur"

# Precondition check
which jq > /dev/null || (echo "jq is required" && exit 1)

# Arg check
for arg in "$@"; do
    shift
    case "$arg" in
        "--vim")
            vim="true"
            ;;
        *)
            set -- "$@" "$arg"
    esac
done

json1="$1"
json2="$2"
stat "$json1" > /dev/null || exit $?
stat "$json2" > /dev/null || exit $?

# Main
sorted1=$(mktemp --suffix=.jsondiff)
sorted2=$(mktemp --suffix=.jsondiff)

jq -S . "$json1" > "$sorted1"
jq -S . "$json2" > "$sorted2"

[ "$vim" ] && cmd=vimdiff || cmd="diff $DIFF_PARAMS"
echo "================================================"
echo $sorted1
echo $sorted2
echo $cmd

$cmd "$sorted1" "$sorted2"

# Tear down
rm "$sorted1"
rm "$sorted2"
