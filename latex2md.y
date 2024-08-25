%{
/*All declarations */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
/*#include "l2m_ast.h" */   //removed the AST dependencies for handling errors

/* Declaring functions and variables */
int yylex(void);
void yyerror(const char *s);

/* External var used in lexer */
extern char *yytext;

// Declaring the root of the AST
// ASTNode *root;

%}

%define parse.error verbose

%union{
    char *string;
   // ASTNode *node;
}

/* FLex Token declarations */
%token <string> SECTION SUBSECTION SUBSUBSEC BRACT_L BRACT_R BOLD ITALIC ITEM IMAGE HYPERLINK HLINE PARAGRAPH SQ_BL SQ_BR HL
%token BEG_ITEMIZE END_ITEMIZE BEG_CODE END_CODE BEG_TAB END_TAB BEG_ENUM END_ENUM TAB_CELL_SEP ROW_END DOC END
%token <string> TEXT 
%type <node> section subsection subsubsection textbf textit hrule par includegraphics href enumerate itemize paragraph tabular ord_item_list unord_item_list

%type <string> code_part text sentence row row_area sentn


%%

/* All the Grammar rules and its actions */

start:
    DOC multiple_call END
multiple_call:
    latex 
    | multiple_call latex; 
latex : 
    section
    | subsection
    | subsubsection
    | textbf
    | textit
    | hrule
    | par
    | includegraphics
    | href
    | enumerate
    | itemize
    | code_part
    | paragraph
    | tabular;

    
section:
    SECTION BRACT_L TEXT BRACT_R {printf("# %s\n", $3); /*$$ = create_node(NODE_SECTION, $3);*/ };
subsection:
    SUBSECTION BRACT_L TEXT BRACT_R {printf("## %s\n", $3); /*$$ = create_node(NODE_SUBSECTION,$3);*/ };
subsubsection:
    SUBSUBSEC BRACT_L TEXT BRACT_R {printf("### %s\n", $3); /*$$ = create_node(NODE_SUBSUBSECTION,$3);*/ };
textbf:
    BOLD BRACT_L TEXT BRACT_R {printf("**%s**\n", $3); /*$$ = create_parent_node(NODE_TEXTBF, 1, $3); */};
textit:
    ITALIC BRACT_L TEXT BRACT_R {printf("_%s_\n", $3); /*$$ = create_parent_node(NODE_TEXTBF, 1, $3);*/ };
href:
    HYPERLINK BRACT_L TEXT BRACT_R BRACT_L TEXT BRACT_R {printf("%s%s\n",$3,$6); /*$$ = create_parent_node(NODE_HREF, 2, create_node(NODE_TEXT, $3), create_node(NODE_TEXT, $5)); */};
par:
    PARAGRAPH {printf("\n\n"); /*$$ = create_node(NODE_PAR, NULL);*/ };
hrule:
    HLINE {printf("\n---------\n"); /*$$ = create_node(NODE_HRULE, NULL);*/ };
includegraphics:
    IMAGE SQ_BL TEXT SQ_BR BRACT_L TEXT BRACT_R {printf("![Image](%s)\n",$6); /*$$ = create_parent_node(NODE_INCLUDEGRAPHICS, 1, create_node(NODE_TEXT, $3));*/ };

code_part:
    BEG_CODE sentence END_CODE { printf("\n```\n %s\n```\n", $2); /*$$ = create_node(NODE_CODE_PART, $2);*/ };

enumerate:
    BEG_ENUM ord_item_list END_ENUM {printf("\n"); /*$$ = $2;*/};
ord_item_list:
    ITEM TEXT { printf("1. %s\n", $2); /*$$ = create_node(NODE_ENUMERATE, $2);*/ }
    | ord_item_list ITEM TEXT { printf("1. %s\n", $3); /*add_child($1, create_node(NODE_ENUMERATE,$3));*/};

itemize:
    BEG_ITEMIZE unord_item_list END_ITEMIZE { printf("\n"); /*$$ = $2;*/};
unord_item_list:
    ITEM TEXT { printf("- %s\n", $2); /*$$ = create_node(NODE_ITEMIZE, $2);*/ }
    | unord_item_list ITEM TEXT { printf("- %s\n", $3); /*add_child($1, create_node(NODE_ITEMIZE, $3));*/};


tabular:
    BEG_TAB BRACT_L columns BRACT_R actual_data END_TAB { printf("\n"); /*$$ = create_node(NODE_TABULAR, $2);*/};

columns:
    TEXT
    | columns TEXT;
actual_data:
    HL row_area HL  { printf("\n"); }
    | row_area;
row_area:
    row ROW_END { printf("| %s |\n", $1); free($1);}
    | row_area HL row ROW_END { printf("| %s |\n| --- | --- |\n", $3); free($3);}
    | row_area row ROW_END { printf("| %s |\n", $2); free($2); };
row:
    sentn { $$ = $1; }
    | row TAB_CELL_SEP sentn {
        size_t len = strlen($1) + strlen($3) + 4;  // writing 4 for " | " and null terminator
        $$ = malloc(len);
        if ($$ != NULL) {
            sprintf($$, "%s | %s", $1, $3);       // here Replacing & with |
        }
        free($1);
        free($3);
    }
    ;
sentn:
    text { $$ = strdup($1); /*$$ = create_parent_node(NODE_SENTN, $1);*/ }
    | sentn TAB_CELL_SEP text {
        size_t len = strlen($1) + 2 + strlen($3) + 1; 
        $$ = malloc(len);
        if ($$ != NULL) {
            sprintf($$, "%s | %s", $1, $3);            // Replacing & with |
        }
        free($1);
        free($3);
        /*add_child($1, create_node(NODE_SENTN, $3));*/

    }
    | sentn text {
        size_t len = strlen($1) + strlen($2) + 1;
        $$ = malloc(len);
        if ($$ != NULL) {
            sprintf($$, "%s%s", $1, $2);
        }
        free($1);
        free($2);
    }
    ;

paragraph:
    sentence {printf("%s", $1); /*$$ = create_parent_node(NODE_PARAGRAPH, 1, $1);*/}
    ;
sentence:
    text {$$ = $1;}
    | sentence text {$$ = strcat($1, $2);}
    ;
text:
    TEXT { $$ = strdup($1);};



%%

/* User code section */
int main(int argc, char **argv) {
    yyparse();
  /*  if (root != NULL) {
        FILE *output = fopen("output.md", "w");
        if (output != NULL) {
            to_markdown(root, output);
            fclose(output);
        }
        free_ast(root);
    }*/
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Hey unfortunately you got a: %s\n", s);  /* This will Print the error messages */
}
