#!/bin/bash

# Check if both input and output files are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: ./run.sh <input.tex> <output.md>"
    exit 1
fi

# Input and Output files
input_file="$1"
output_file="$2"

# Generate the parser files with Bison
bison -d latex2md.y

# Run Flex to generate the lexer
flex latex2md.l

# Compile the generated C files
gcc lex.yy.c latex2md.tab.c -o latex2md -lfl

# Run the LaTeX to Markdown converter and save the output
./latex2md < "$input_file" > "$output_file"

# Check if the conversion was successful
if [ $? -eq 0 ]; then
    echo "Conversion successful. Output saved to $output_file"
else
    echo "Error during conversion."
fi
