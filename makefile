# Makefile for Flex and Bison Project

# Compiler and tools
CC = gcc
FLEX = flex
BISON = bison

# Files
LEX_FILE = latex2md.l
BISON_FILE = latex2md.y
LEX_OUTPUT = lex.yy.c
BISON_OUTPUT = latex2md.tab.c
BISON_HEADER = latex2md.tab.h
EXECUTABLE = parser

# Build targets

all: $(EXECUTABLE)

# Generate the Bison parser
$(BISON_OUTPUT) $(BISON_HEADER): $(BISON_FILE)
	$(BISON) -t -d -v $(BISON_FILE)

# Generate the Flex scanner
$(LEX_OUTPUT): $(LEX_FILE)
	$(FLEX) $(LEX_FILE)

# Compile the executable
$(EXECUTABLE): $(LEX_OUTPUT) $(BISON_OUTPUT)
	$(CC) $(LEX_OUTPUT) $(BISON_OUTPUT) -o $(EXECUTABLE)

# Clean up build files
clean:
	rm -f $(LEX_OUTPUT) $(BISON_OUTPUT) $(BISON_HEADER) $(EXECUTABLE) *.output

# Run the parser
run: $(EXECUTABLE)
	./$(EXECUTABLE) < input.tex

.PHONY: all clean run