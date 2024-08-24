#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: ./run.sh input.tex output.md"
    exit 1
fi

# Assign arguments to variables
INPUT_FILE=$1
OUTPUT_FILE=$2

# Compile the project
make

# Run the converter and redirect output to the specified output file
./parser < "$INPUT_FILE" > "$OUTPUT_FILE"

echo "Conversion successful: $OUTPUT_FILE created."

