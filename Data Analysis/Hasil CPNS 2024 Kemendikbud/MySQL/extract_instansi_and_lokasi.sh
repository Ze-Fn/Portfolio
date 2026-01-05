#!/usr/bin/env bash

# Usage check
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 input_file output_file"
    exit 1
fi

input_file="$1"
output_file="$2"

grep -E 'Instansi : |Lokasi Formasi : ' "$input_file" > "$output_file"
