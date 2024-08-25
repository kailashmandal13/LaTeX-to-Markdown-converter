/**
 * This file is for AST program, but i didn't included it in latex2md.y file as it was giving error & AST was not able to generate
 */
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "l2m_ast.h"

// Function to create new AST node
ASTNode* tnew_node(NodeType type, const char* content) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "memory failed\n");
        exit(1);
    }
    node->type = type;
    if (content) {
        node->content = strdup(content);
    } else {
        node->content = NULL;
    }
    node->children = NULL;
    node->children_count = 0;
    return node;
}

// adding a child node to a parent node
void adding_child(ASTNode* parent, ASTNode* child) {
    if (!parent || !child) return;
    parent->children_count++;
    parent->children = (ASTNode**)realloc(parent->children, sizeof(ASTNode*) * parent->children_count);
    if (!parent->children) {
        fprintf(stderr, "memory failed\n");
        exit(1);
    }
    
    parent->children[parent->children_count - 1] = child;
}

// creating a parent node with their resp number of children
ASTNode *parent_node(NodeType type, int children_count) {
    ASTNode *node = tnew_node(type, NULL);
    node->children = (ASTNode **)malloc(children_count * sizeof(ASTNode *));
    if (!node->children) {
        fprintf(stderr, "memory failed\n");
        exit(1);
    }
    node->children_count = children_count;

    va_list args;
    va_start(args, children_count);
    for (int i = 0; i < children_count; i++) {
        node->children[i] = va_arg(args, ASTNode *);
    }
    va_end(args);

    return node;
}


// printing an AST node (for debugging)
void show_ast(ASTNode *node, int indent) {
    if (!node) return;

    for (int i = 0; i < indent; i++) printf("  ");

    switch (node->type) {
        case NODE_SECTION: printf("Section: "); break;
        case NODE_SUBSECTION: printf("Subsection: "); break;
        case NODE_SUBSUBSECTION: printf("Subsubsection: "); break;
        case NODE_TEXTBF: printf("Bold: "); break;
        case NODE_TEXTIT: printf("Italic: "); break;
        case NODE_HRULE: printf("Horizontal Rule\n"); break;
        case NODE_PAR: printf("Paragraph Break\n"); break;
        case NODE_INCLUDEGRAPHICS: printf("Include Graphics: "); break;
        case NODE_HREF: printf("Hyperlink: "); break;
        case NODE_ENUMERATE: printf("Enumerate List\n"); break;
        case NODE_ITEMIZE: printf("Itemize List\n"); break;
        case NODE_CODE_PART: printf("Code Part: "); break;
        case NODE_PARAGRAPH: printf("Paragraph:\n"); break;
        case NODE_TABULAR: printf("Tabular:\n"); break;
        case NODE_ROW: printf("Row:\n"); break;
        case NODE_TEXT: printf("Text: "); break;
        default: printf("Unknown Node\n"); break;
    }

    if (node->content && node->type != NODE_HRULE && node->type != NODE_PAR && node->type != NODE_ENUMERATE && node->type != NODE_ITEMIZE && node->type != NODE_PARAGRAPH && node->type != NODE_TABULAR && node->type != NODE_ROW) {
        printf("%s\n", node->content);
    }

    for (int i = 0; i < node->children_count; i++) {
        print_ast(node->children[i], indent + 1);
    }
}



// convert an AST node to Markdown

void converting2_markdown(ASTNode* node, FILE* output) {
    if (!node) return;

    switch (node->type) {
        case NODE_SECTION:
            fprintf(output, "# %s\n\n", node->content);
            break;
        case NODE_SUBSECTION:
            fprintf(output, "## %s\n\n", node->content);
            break;
        case NODE_SUBSUBSECTION:
            fprintf(output, "### %s\n\n", node->content);
            break;
        case NODE_TEXTBF:
            fprintf(output, "**");
            for (int i = 0; i < node->children_count; i++) {
                converting2_markdown(node->children[i], output);
            }
            fprintf(output, "**");
            break;
        case NODE_TEXTIT:
            fprintf(output, "*");
            for (int i = 0; i < node->children_count; i++) {
                converting2_markdown(node->children[i], output);
            }
            fprintf(output, "*");
            break;
        case NODE_HRULE:
            fprintf(output, "---\n\n");
            break;
        case NODE_PAR:
            fprintf(output, "\n");
            break;
        case NODE_INCLUDEGRAPHICS:
            if (node->children_count >= 1) {
                const char *path = node->children[0]->content;
                const char *alt = (node->children_count > 1) ? node->children[1]->content : "";
                fprintf(output, "![%s](%s)\n\n", alt, path);
            }
            break;
        case NODE_HREF:
            if (node->children_count >= 2) {
                const char *url = node->children[0]->content;
                const char *text = node->children[1]->content;
                fprintf(output, "[%s](%s)", text, url);
            }
            break;
        case NODE_ENUMERATE:
            for (int i = 0; i < node->children_count; i++) {
                fprintf(output, "1. ");
                converting2_markdown(node->children[i], output);
                fprintf(output, "\n");
            }
            fprintf(output, "\n");
            break;
        case NODE_ITEMIZE:
            for (int i = 0; i < node->children_count; i++) {
                fprintf(output, "- ");
                converting2_markdown(node->children[i], output);
                fprintf(output, "\n");
            }
            fprintf(output, "\n");
            break;
        case NODE_CODE_PART:
            fprintf(output, "`%s`", node->content);
            break;
        case NODE_PARAGRAPH:
            for (int i = 0; i < node->children_count; i++) {
                converting2_markdown(node->children[i], output);
            }
            fprintf(output, "\n\n");
            break;
        case NODE_TABULAR:
            for (int i = 0; i < node->children_count; i++) {
                ASTNode *row = node->children[i];
                for (int j = 0; j < row->children_count; j++) {
                    fprintf(output, "%s", row->children[j]->content);
                    if (j < row->children_count - 1) {
                        fprintf(output, " | ");
                    }
                }
                fprintf(output, "\n");
                if (i == 0) { // After header row, add separator
                    for (int j = 0; j < row->children_count; j++) {
                        fprintf(output, "---");
                        if (j < row->children_count - 1) {
                            fprintf(output, " | ");
                        }
                    }
                    fprintf(output, "\n");
                }
            }
            fprintf(output, "\n");
            break;
        case NODE_TEXT:
            fprintf(output, "%s", node->content);
            break;
        // Handle other cases as needed
        default:
            // For any unhandled node types, process children
            for (int i = 0; i < node->children_count; i++) {
                converting2_markdown(node->children[i], output);
            }
            break;
    }
}


// freeing the memory used by an AST
void fr_ast(ASTNode *node) {
    if (!node) return;

    for (int i = 0; i < node->children_count; i++) {
        fr_ast(node->children[i]);
    }

    free(node->content);
    free(node->children);
    free(node);
}