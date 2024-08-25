%{
/* C code for necessary includes and declarations */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Declare Flex functions and variables */
int yylex(void);
void yyerror(const char *s);

/* External variables used in lexer */
extern char *yytext;
%}

%define parse.error verbose

%union{
    char *string;
}

/* Token declarations from Flex */
%token SECTION SUBSECTION SUBSUBSEC BRACT_L BRACT_R BOLD ITALIC ITEM IMAGE HYPERLINK HLINE PARAGRAPH SQ_BL SQ_BR BACKSLS HL
%token BEG_ITEMIZE END_ITEMIZE BEG_CODE END_CODE BEG_TAB END_TAB BEG_ENUM END_ENUM TAB_CELL_SEP ROW_END
%token <string> TEXT 

%type <string> code_part text sentence row row_area sentn


%%

/* Grammar rules and actions */

start:
    multiple_call;
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
    SECTION BRACT_L TEXT BRACT_R {printf("# %s\n", $3);};
subsection:
    SUBSECTION BRACT_L TEXT BRACT_R {printf("## %s\n", $3);};
subsubsection:
    SUBSUBSEC BRACT_L TEXT BRACT_R {printf("### %s\n", $3);};
textbf:
    BOLD BRACT_L TEXT BRACT_R {printf("**%s**\n", $3);};
textit:
    ITALIC BRACT_L TEXT BRACT_R {printf("_%s_\n", $3);};
href:
    HYPERLINK BRACT_L TEXT BRACT_R BRACT_L TEXT BRACT_R {printf("%s%s\n",$3,$6);};
par:
    PARAGRAPH {printf("\n\n");};
hrule:
    HLINE {printf("\n---------\n");};
includegraphics:
    IMAGE SQ_BL TEXT BACKSLS TEXT SQ_BR BRACT_L TEXT BRACT_R {printf("![Image](%s)\n",$8);};

code_part:
    BEG_CODE sentence END_CODE { printf("\n```\n %s\n```\n", $2);};

/* list:
    ordered_list
    | unordered_list;

ordered_list:
    BEGIN_ENUMERATE ordered_items END_ENUMERATE { printf("\n"); };
;*/

enumerate:
    BEG_ENUM ord_item_list END_ENUM {printf("\n");};
ord_item_list:
    ITEM TEXT { printf("1. %s\n", $2); }
    | ord_item_list ITEM TEXT { printf("1. %s\n", $3); };

itemize:
    BEG_ITEMIZE unord_item_list END_ITEMIZE { printf("\n");};
unord_item_list:
    ITEM TEXT { printf("- %s\n", $2); }
    | unord_item_list ITEM TEXT { printf("- %s\n", $3);};


tabular:
    BEG_TAB BRACT_L columns BRACT_R actual_data END_TAB { printf("\n"); };

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
        size_t len = strlen($1) + strlen($3) + 4;  // 4 for " | " and null terminator
        $$ = malloc(len);
        if ($$ != NULL) {
            sprintf($$, "%s | %s", $1, $3);       // Replacing & with |
        }
        free($1);
        free($3);
    }
    ;
sentn:
    text { $$ = strdup($1); }
    | sentn TAB_CELL_SEP text {
        size_t len = strlen($1) + 2 + strlen($3) + 1;
        $$ = malloc(len);
        if ($$ != NULL) {
            sprintf($$, "%s | %s", $1, $3);            // Replacing & with |
        }
        free($1);
        free($3);
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
    sentence {printf("%s", $1);}
    ;
sentence:
    text {$$ = $1;}
    | sentence text {$$ = strcat($1, $2);}
    ;
text:
    TEXT { $$ = strdup($1);};



%%

/* User code section */
int main(void) {
    return yyparse();  /* Start the parsing process */
}

void yyerror(const char *s) {
    fprintf(stderr, "Hey unfortunately you got a: %s\n", s);  /* This will Print the error messages */
}
