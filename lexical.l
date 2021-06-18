%option noyywrap nodefault yylineno

%{
#include "bison.tab.h"  
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "ts.h"

int numero_ligne=1;
int numero_colonne=1;
extern YYSTYPE yylval; 

%}

IDENTIF [A-Z][A-Za-z0-9_]*
CSTINT (0+|[\+-]?[1-9][0-9]*)
CSTCHAR '([^'\\]|\\[0bntuvf'\\])'
CSTREEL [\+-]?([0-9]+\.[0-9]*|[0-9]*\.[0-9]+)
CSTSTR  \"[^\"]*\"
COMMENTAIRE \$([^\$\\]|\\.)*\$



%%


"CODE" {
    Inserer_clesep("CODE","MOT CLE"); 
	numero_colonne+=yyleng;
    return CODE;
	}
"INTEGER" {
    Inserer_clesep("INTEGER","MOT CLE"); 
    yytext=strdup(yytext);
    numero_colonne+=yyleng;
    return INTEGER;
    }
"REAL" {
    Inserer_clesep("REAL","MOT CLE"); 
    yytext=strdup(yytext);
    numero_colonne+=yyleng;
    return REAL;
      }
"STRING" {
    Inserer_clesep("STRING","MOT CLE"); 
    yytext=strdup(yytext);
    numero_colonne+=yyleng; 
    return STRING;
    }
"CHAR" {
    Inserer_clesep("CHAR","MOT CLE"); 
    yytext=strdup(yytext);
    numero_colonne+=yyleng;
     return CHAR;
     }
"CONST" {
    Inserer_clesep("CONST","MOT CLE"); 
    yytext = strdup(yytext);
    numero_colonne+=yyleng;
    return CONST;
    }
"START" {
    Inserer_clesep("START","MOT CLE"); 
     numero_colonne+=yyleng;
     return START;
     }
"END" { 
    Inserer_clesep("END","MOT CLE"); 
    numero_colonne+=yyleng;
    return END;
    }
"WHILE" {
    Inserer_clesep("WHILE","MOT CLE"); 
    numero_colonne+=yyleng;
    return WHILE;
     }
"WHEN" {
    Inserer_clesep("WHEN","MOT CLE"); 
    numero_colonne+=yyleng;
    return WHEN;
     }
"EXECUTE" {
    Inserer_clesep("EXECUTE","MOT CLE"); 
    numero_colonne+=yyleng;
    return EXECUTE;
    }
"OTHERWISE" {
    Inserer_clesep("OTHERWISE","MOT CLE"); 
    numero_colonne+=yyleng;
    return OTHERWISE;
    }
"DO" { 
    Inserer_clesep("DO","MOT CLE"); 
    numero_colonne+=yyleng;
    return DO;
    }
"PROD" {
    Inserer_clesep("PROD","MOT CLE"); 
    numero_colonne += yyleng; 
    return PROD;      
    }


\+ { 
    Inserer_clesep("PLUS","SEPARATEUR"); 
    numero_colonne+=yyleng;return PLUS;}
\- {
    Inserer_clesep("MOINS","SEPARATEUR"); 
    numero_colonne+=yyleng;return MOINS;}
\* {
    Inserer_clesep("MULT","SEPARATEUR"); 
    numero_colonne+=yyleng;return MULT;}
\/ { 
    Inserer_clesep("DIV","SEPARATEUR"); 
    numero_colonne+=yyleng;return DIV;}


":=" { 
    Inserer_clesep("AFFECT","SEPARATEUR"); 
    numero_colonne+=yyleng;return AFFECT;}
"="  {
    Inserer_clesep("EGAL","SEPARATEUR"); 
    numero_colonne += yyleng; 
    return EGAL;}  
"NE" { 
    Inserer_clesep("NE","SEPARATEUR");
    numero_colonne+=yyleng;
    return NE;
    }
"EQ" {
    Inserer_clesep("EQ","SEPARATEUR"); 
     numero_colonne+=yyleng;
     return EQ;
     }
"LT" { 
    Inserer_clesep("LT","SEPARATEUR"); 
    numero_colonne+=yyleng;
    return LT;
    }
"GT" {
    Inserer_clesep("GT","SEPARATEUR"); 
     numero_colonne+=yyleng;
     return GT;
     }
"LE" {
    Inserer_clesep("LE","SEPARATEUR"); 
     numero_colonne+=yyleng;
     return LE;
     }
"GE" {
    Inserer_clesep("GE","SEPARATEUR");
     numero_colonne+=yyleng;
     return GE;
     }



[(] { 
    Inserer_clesep("PRTOUV","SEPARATEUR"); 
    numero_colonne+=yyleng;
    return PRTOUV;
    }
[)] { 
    Inserer_clesep("PRTFERM","SEPARATEUR"); 
    numero_colonne+=yyleng;
    return PRTFERM;
    }
"{" {
    Inserer_clesep("ACOLOUV","SEPARATEUR"); 
        numero_colonne += yyleng; 
        return ACOLOUV; 
    }
"}"	{
    Inserer_clesep("ACOLFRM","SEPARATEUR"); 
        numero_colonne += yyleng; 
        return ACOLFRM; 
    }





{CSTINT} { 
    Inserer_idf(yytext,"CONSTANTE   ",yytext,"INTEGER");
    numero_colonne+=yyleng;
    char message[20];
    sprintf(message,"%s",yytext);
    strcpy(yylval.t_IdfConst,message);
    return CSTINT;}
{CSTREEL} { 
    Inserer_idf(yytext,"CONSTANTE   ",yytext,"REAL");
    numero_colonne+=yyleng;
    char message[20];
    sprintf(message,"%s",yytext);
    strcpy(yylval.t_IdfConst,message);
    return CSTREEL;}
{CSTSTR} { 
    Inserer_idf(yytext,"CONSTANTE   ",yytext,"STRING");
    numero_colonne+=yyleng;
    char message[20];
    sprintf(message,"%s",yytext);
    strcpy(yylval.t_IdfConst,message);
    return CSTSTR;}

{IDENTIF} {if(yyleng<=20){
    if(Exist(yytext)==1 && rechercher_clesep("START") == NULL ){
            char message[50];
            printf("[ERREUR SEMANTIQUE] double déclaration de l'entité %s a la ligne : %i , colonne : %i \n",yytext,numero_ligne,numero_colonne);
            return IDENTIF;
    }
    else{
        
    Inserer_idf(yytext,"IDENTIFICATEUR","","");
    numero_colonne+=yyleng;
    char message[20];
    sprintf(message,"%s",yytext);
    strcpy(yylval.t_IdfConst,message);
	return IDENTIF;
    
    }
    }
    else{
    printf("erreur lexicale : Idenficateur %s trop long > 20 caractere \n ",yytext);		
	  }
    }


";" {numero_colonne+=yyleng;return POINTVIRG;}
"," {numero_colonne+=yyleng;return VIRG;}
"." {numero_colonne+=yyleng;return POINT;}


\n   {numero_ligne++;numero_colonne=1;}

. printf("  ");

%%