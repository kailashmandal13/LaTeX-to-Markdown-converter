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
%token SECTION SUBSECTION SUBSUBSEC BRACT_L BRACT_R BOLD ITALIC ITEM IMAGE HYPERLINK HLINE PARAGRAPH BKSLS
%token BEG_ITEMIZE END_ITEMIZE BEG_CODE END_CODE BEG_TAB END_TAB BEG_ENUM END_ENUM TAB_CELL_SEP ROW_END
%token <string> TEXT

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
    | code_block
    | tabular

    
section:
    SECTION BRACT_L TEXT BRACT_R {printf("# %s\n", $3);};
subsection:
    SUBSECTION BRACT_L TEXT BRACT_R {printf("## %s\n", $3);};
subsubsection:
    SUBSUBSEC BRACT_L TEXT BRACT_R {printf("### %s\n", $3);};
textbf:
    BOLD TEXT {printf("**%s**\n", $2);};
textit:
    ITALIC TEXT {printf("_%s_\n", $2);};
href:
    HYPERLINK BRACT_L TEXT BRACT_R BRACT_L TEXT BRACT_R {printf("%s%s\n",$3,$6);};
par:
    PARAGRAPH {printf("\n\n");};
hrule:
    HLINE {printf("\n---------\n");};
includegraphics:
    IMAGE TEXT BRACT_L TEXT BRACT_R {printf("![Image %s](%s)",$2,$4);};

code_block:
    BEG_CODE TEXT END_CODE { printf("```\n%s\n```\n", $2);};

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
    BEG_TAB rows END_TAB { printf("\n"); };
rows:
    row
    | rows row;
row:
    TEXT TAB_CELL_SEP TEXT ROW_END { printf("| %s | %s |\n", $1, $3); };





%%

/* User code section */
int main(void) {
    return yyparse();  /* Start the parsing process */
}

void yyerror(const char *s) {
    fprintf(stderr, "Hey unfortunately you got a: %s\n", s);  /* This will Print the error messages */
}
