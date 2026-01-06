#!/usr/bin/env bash

# Usage:
# ./no_participant_cleaner.sh input.csv output.csv

INPUT="$1"
OUTPUT="$2"

if [ -z "$INPUT" ] || [ -z "$OUTPUT" ]; then
    echo "Usage: $0 input.csv output.csv"
    exit 1
fi

awk '
{
    lines[NR] = $0
}
END {
    # Step 1: prepend null, to all lines
    for (i = 1; i <= NR; i++) {
        prefixed[i] = "null," lines[i]
    }

    # Step 2: detect (1) blocks with no participant
    for (i = 1; i <= NR; i++) {

        # line starts with "(" e.g. (1)
        if (lines[i] ~ /^\(/) {

            # next line exists AND does NOT start with digit
            if (i + 1 <= NR && lines[i + 1] !~ /^[0-9]/) {

                # override this line and two above it
                for (j = i - 2; j <= i; j++) {
                    if (j >= 1) {
                        prefixed[j] = "\"No Participant\"," lines[j]
                    }
                }
            }
        }
    }

    # Step 3: output
    for (i = 1; i <= NR; i++) {
        print prefixed[i]
    }
}
' "$INPUT" > "$OUTPUT"
