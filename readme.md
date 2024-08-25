# LaTeX to Markdown Converter

## Overview

This project is a LaTeX to Markdown converter, designed as part of the Software Lab course at IIT Delhi. The converter takes a LaTeX file as input and outputs a Markdown file with properly formatted content. The converter handles common LaTeX structures such as sections, subsections, bold, italics, code blocks, tables, and lists.

## Features

- Convert LaTeX sections, subsections, and subsubsections to Markdown headings.
- Translate LaTeX bold and italic text to Markdown bold and italics.
- Process LaTeX `verbatim` environments into Markdown code blocks.
- Handle LaTeX tables and lists (ordered and unordered).
- Convert LaTeX images into Markdown image syntax.

## Project Structure


## Requirements

- Flex
- Bison
- GCC

## Setup Instructions

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/your-username/latex2md.git
    cd latex2md
    ```

2. **Generate Parser Files**:
    ```bash
    bison -d latex2md.y
    mv y.tab.h parser.h
    ```

3. **Run Flex**:
    ```bash
    flex latex2md.l
    ```

4. **Compile**:
    ```bash
    gcc lex.yy.c y.tab.c -o latex2md -lfl
    ```

5. **Run the Converter**:
    ```bash
    ./latex2md < input.tex > output.md
    ```

## Usage

1. **Prepare Your LaTeX File**:
   Ensure your LaTeX file is correctly formatted with supported structures.

2. **Run the Converter**:
   Run the `latex2md` executable with your LaTeX file as input to generate the corresponding Markdown file.

3. **View the Output**:
   Open the generated `output.md` file to see the converted Markdown content.

## Example

Given the following LaTeX input:

```latex
\section{Introduction}
Welcome to the LaTeX to Markdown converter!

\subsection{Features}
- Converts sections to headings.
- Handles lists, tables, and code blocks.

\begin{verbatim}
def example_function():
    print("This is a code block")
\end{verbatim}


## The output in Markdown will be:

## Introduction
Welcome to the LaTeX to Markdown converter!

### Features
- Converts sections to headings.
- Handles lists, tables, and code blocks.

