/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_LATEX2MD_TAB_H_INCLUDED
# define YY_YY_LATEX2MD_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    SECTION = 258,                 /* SECTION  */
    SUBSECTION = 259,              /* SUBSECTION  */
    SUBSUBSEC = 260,               /* SUBSUBSEC  */
    BRACT_L = 261,                 /* BRACT_L  */
    BRACT_R = 262,                 /* BRACT_R  */
    BOLD = 263,                    /* BOLD  */
    ITALIC = 264,                  /* ITALIC  */
    ITEM = 265,                    /* ITEM  */
    IMAGE = 266,                   /* IMAGE  */
    HYPERLINK = 267,               /* HYPERLINK  */
    HLINE = 268,                   /* HLINE  */
    PARAGRAPH = 269,               /* PARAGRAPH  */
    SQ_BL = 270,                   /* SQ_BL  */
    SQ_BR = 271,                   /* SQ_BR  */
    HL = 272,                      /* HL  */
    BEG_ITEMIZE = 273,             /* BEG_ITEMIZE  */
    END_ITEMIZE = 274,             /* END_ITEMIZE  */
    BEG_CODE = 275,                /* BEG_CODE  */
    END_CODE = 276,                /* END_CODE  */
    BEG_TAB = 277,                 /* BEG_TAB  */
    END_TAB = 278,                 /* END_TAB  */
    BEG_ENUM = 279,                /* BEG_ENUM  */
    END_ENUM = 280,                /* END_ENUM  */
    TAB_CELL_SEP = 281,            /* TAB_CELL_SEP  */
    ROW_END = 282,                 /* ROW_END  */
    DOC = 283,                     /* DOC  */
    END = 284,                     /* END  */
    TEXT = 285                     /* TEXT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 22 "latex2md.y"

    char *string;
   // ASTNode *node;

#line 99 "latex2md.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_LATEX2MD_TAB_H_INCLUDED  */
