/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
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
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_BISON_TAB_H_INCLUDED
# define YY_YY_BISON_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    EQ = 258,
    NE = 259,
    LT = 260,
    LE = 261,
    GT = 262,
    GE = 263,
    AFFECT = 264,
    PLUS = 265,
    MOINS = 266,
    MULT = 267,
    DIV = 268,
    EGAL = 269,
    PROD = 270,
    PARENOUV = 271,
    PARENFER = 272,
    POINT = 273,
    VIRG = 274,
    POINTVIRG = 275,
    ACCOUV = 276,
    ACCFERM = 277,
    CODE = 278,
    START = 279,
    END = 280,
    CONST = 281,
    WHILE = 282,
    EXECUTE = 283,
    WHEN = 284,
    DO = 285,
    OTHERWISE = 286,
    IDENTIF = 287,
    CONSTCHAR = 288,
    CONSTSTRING = 289,
    CONSTINT = 290,
    CONSTREELLE = 291,
    INTEGER = 292,
    REAL = 293,
    CHAR = 294,
    STRING = 295,
    ADD = 296,
    SOUS = 297,
    MUL = 298
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 23 "bison.y"

    char* string;
    int integer;
    char t_IdfConst[20];
   
    

#line 109 "bison.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_BISON_TAB_H_INCLUDED  */
