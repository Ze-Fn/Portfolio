#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

INPUT_FILE=$1
OUTPUT_FILE=$2

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

# Use tr to delete the newline character
tr -d '\n' < "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Success: Newlines removed. Output saved to '$OUTPUT_FILE'."
