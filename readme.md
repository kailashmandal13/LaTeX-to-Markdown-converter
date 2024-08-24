# LaTeX to Markdown Converter

This project is an implementation of a LaTeX to Markdown converter as part of the COP701 course at IIT Delhi. The project uses Flex for lexical analysis and Bison for parsing, generating equivalent Markdown output from LaTeX input.

## Features

- **Section to Headings**: Converts `\section{}` and `\subsection{}` to `#` and `##` Markdown headings.
- **Italics and Bold**: Converts `\textit{}` and `\textbf{}` to `_` and `**` in Markdown.
- **Hyperlinks**: Converts `\href{}{}` to `[text](url)` in Markdown.
- **Lists**: Converts `itemize` and `enumerate` environments to unordered and ordered lists.
- **Code Blocks**: Converts `verbatim` environment to Markdown code blocks.
- **Paragraphs**: Handles `\par` as Markdown paragraphs.
- **Horizontal Lines**: Converts `\hrule` to `---` in Markdown.

## Project Structure

- `latex2md.l`: The Flex file responsible for lexical analysis and generating Markdown from LaTeX.
- `README.md`: This documentation file.

## How to Run

1. **Build the Lexer:**
   ```bash
   flex latex2md.l
   gcc lex.yy.c -o latex2md -lfl
