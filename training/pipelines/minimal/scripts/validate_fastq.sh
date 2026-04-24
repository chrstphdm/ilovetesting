#!/usr/bin/env bash
set -euo pipefail

FILE="${1:-}"

[ -n "$FILE" ]  || { echo "ERROR: usage: $0 <fastq_file>"; exit 1; }
[ -f "$FILE" ]  || { echo "ERROR: file not found: $FILE"; exit 1; }
[ -s "$FILE" ]  || { echo "ERROR: file is empty: $FILE"; exit 1; }
grep -q "^@" "$FILE" || { echo "ERROR: not a valid FASTQ: $FILE"; exit 2; }

total=$(awk 'NR%4==1' "$FILE" | wc -l)
lines=$(wc -l < "$FILE")

if (( lines % 4 != 0 )); then
    echo "ERROR: FASTQ line count not a multiple of 4: $FILE"
    exit 2
fi

echo "OK: $FILE — ${total} reads"
