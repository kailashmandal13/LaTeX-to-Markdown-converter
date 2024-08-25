/**
 * This file is for AST Header
 */

#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


// Enum for required AST nodes
typedef enum {
    NODE_START,
    NODE_MULTIPLE_CALL,
    NODE_LATEX,
    NODE_SECTION,
    NODE_SUBSECTION,
    NODE_SUBSUBSECTION,

    NODE_TEXTBF,
    NODE_TEXTIT,
    NODE_HREF,
    NODE_PAR,
    NODE_HRULE,
    NODE_INCLUDEGRAPHICS,
    NODE_CODE_PART,
    NODE_ENUMERATE,
    NODE_ORD_ITEM_LIST,
    NODE_ITEMIZE,
    NODE_UNORD_ITEM_LIST,
    NODE_TABULAR,
    NODE_COLUMNS,
    NODE_ACTUAL_DATA,
    NODE_ROW_AREA,
    NODE_ROW,
    NODE_SENTN,
    NODE_PARAGRAPH,
    NODE_SENTENCE,
    NODE_TEXT,
  
} NodeType;

// Structure for AST node
typedef struct ASTNode {
    NodeType type;
    char *content;  
    struct ASTNode **children;
    int children_count;
} ASTNode;

// Function declaration
ASTNode* create_node(NodeType type, const char* content);
void add_child(ASTNode* parent, ASTNode* child);
void to_markdown(ASTNode* node, FILE* output);
ASTNode *create_parent_node(NodeType type, int children_count, ...);
void print_ast(ASTNode *node, int indent);
void free_ast(ASTNode* node);

#endif
