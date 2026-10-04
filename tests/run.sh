#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
log=$(mktemp)
trap 'rm -f "$log"' EXIT HUP INT TERM
for test in tests/navigation.vim tests/syntax.vim tests/filetype.vim tests/indent.vim; do
    if ! "${VIM:-vim}" -Nu NONE -i NONE -n -es -V1"$log" -S "$test" >"$log" 2>&1; then
        cat "$log"
        exit 1
    fi
    printf 'PASS %s\n' "$test"
done
