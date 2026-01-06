#!/usr/bin/env bash

INPUT="$1"
OUTPUT="$2"

if [ -z "$INPUT" ] || [ -z "$OUTPUT" ]; then
    echo "Usage: $0 input.csv output.csv"
    exit 1
fi

awk '
BEGIN {
    RS="\""
    ORS=""
}

NR % 2 == 1 {
    # Outside quotes → keep exactly as-is
    gsub(/\r?\n/, "\n")
    print
}

NR % 2 == 0 {
    # Inside quotes → collapse ALL whitespace (including newlines) into spaces
    gsub(/\r?\n/, " ")
    gsub(/[[:space:]]+/, " ")
    print "\"" $0 "\""
}
' "$INPUT" > "$OUTPUT"
