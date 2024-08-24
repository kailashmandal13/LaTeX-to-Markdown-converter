%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "latex2md.tab.h"
    

extern void yyerror(const char *s);
    
%}

%%
\\section                       { return SECTION; }
\\subsection                    { return SUBSECTION; }
\\subsubsection                 { return SUBSUBSEC; }
\\                              { return BKSLS; }
\{                              { return BRACT_L; }
\}                              { return BRACT_R; }

\\textbf                        { return BOLD; }
\\textit                        { return ITALIC; }
\\hrule                         { return HLINE; }
\\par                           { return PARAGRAPH; }
\\begin\{itemize\}              { return BEG_ITEMIZE;/* this will handle the start of itemize list */ }
\\item                          { return ITEM; }
\\end\{itemize\}                { return END_ITEMIZE;/* This will handle end of itemize list */ }

\\begin\{enumerate\}            { return BEG_ENUM;/* this will handle the start of enumerate list */ }
\\end\{enumerate\}              { return END_ENUM;/* This will handle end of enumerate list */ }

\\begin\{verbatim\}              { return BEG_CODE;/* this will handle the start of code block */ }             
\\end\{verbatim\}                { return END_CODE;/* This will handle end of code block */ }

\\includegraphics                { return IMAGE; }

\\begin\{tabular\}               { return BEG_TAB;/* this will handle the start table */ }
\\end\{tabular\}                   { return END_TAB;/* this will handle the start table */ }
\&                              { return TAB_CELL_SEP; }
\\\\[^\n]*                      { return ROW_END; }

[a-zA-Z0-9:/.\@,_()!+%""-=][a-zA-Z0-9:=.\_()!+%""-@, \t\n]* { /* Handle newlines i text */  yylval.string = strdup(yytext); 
                            return TEXT; }
                            
\\href                           { return HYPERLINK; }

[ \t\n]+                   { /* ignore whitespace */ }
\%[^\n]*                  { /* ignore comments */ }
.                         { /* Ignore unrecognized input */ }


%%

int yywrap() {
    return 1;
}