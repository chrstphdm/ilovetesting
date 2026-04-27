#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-}"

[ -n "$FILE" ] || { echo "ERROR: usage: $0 <records.tsv>"; exit 1; }
[ -f "$FILE" ] || { echo "ERROR: file not found: $FILE"; exit 1; }

lines=$(wc -l < "$FILE")
if [ "$lines" -lt 2 ]; then
    echo "ERROR: file is empty or has no data rows: $FILE"
    exit 1
fi

header=$(head -1 "$FILE")
if [ "$header" != $'id\tgroup\tvalue' ]; then
    echo "ERROR: unexpected header: $header"
    exit 1
fi

invalid_cols=$(tail -n +2 "$FILE" | awk -F'\t' 'NF != 3 { print NR+1": "$0 }')
if [ -n "$invalid_cols" ]; then
    echo "ERROR: rows with wrong number of columns:"
    echo "$invalid_cols"
    exit 1
fi

invalid_values=$(tail -n +2 "$FILE" | awk -F'\t' '$3 !~ /^[0-9]+(\.[0-9]+)?$/ { print NR+1": "$3 }')
if [ -n "$invalid_values" ]; then
    echo "ERROR: non-numeric values in column 'value':"
    echo "$invalid_values"
    exit 1
fi

echo "OK: $(( lines - 1 )) records validated"
