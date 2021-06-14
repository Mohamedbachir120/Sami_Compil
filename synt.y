%{ 
#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include "ts.h"

 

extern FILE* yyin ;
extern int nb_ligne;
extern int nb_colonne;
int yylex(); 
void yyerror (const char *message);
 

%}

%union{
int integer;
char* str;
float real;
}

%token code mc_while mc_when mc_Char mc_do mc_otherwise mc_execute mc_ecrire mc_lire mc_return point op_plus op_moins op_multiplication op_division op_affection  NE EQ LT GT LE GE paranthese_ouvrante paranthese_fermante crochet_ouvrant crochet_fermant <str>var_dec  deb fin pvg vg deux_point agm <str>mc_idf  <real>const_reel <integer>const_int <str>mc_Int <str>mc_Real <str>mc_String <str>const_dec <str>const_String
%%


// RACINE
S: code mc_idf LISTE_DEC CORPS{printf("syntaxe correcte");          	            YYACCEPT;}
;



// TYPE
TYPE :  mc_Int 
      | mc_String 
	  | mc_Char
	  | mc_Real                    /* TYPE LES VARIABLES */
;


// CONTANT 
CONST_VAR :  const_String 
			| const_int 
			| const_reel                    /* CONST_VAR */
;


// LISTE_DEC
LISTE_DEC:  DEC LISTE_DEC
          | 
;		  


// DECLARATION
DEC :  var_dec TYPE LISTE_IDF pvg   
	 | const_dec LISTE_IDF op_affection CONST_VAR pvg
;  
       	    	                           	

// LISTE_IDF
LISTE_IDF:   mc_idf vg LISTE_IDF         				
		   | mc_idf crochet_ouvrant const_int crochet_fermant vg LISTE_IDF            
		   | mc_idf crochet_ouvrant const_int crochet_fermant 	   
           | mc_idf 
;	


// CONDITION
CONDITION : Experssion OPERATEUR_LOGIQUE Experssion ;


// AFFECTATION
AFFECTATION : mc_idf op_affection const_int pvg 
            | mc_idf op_affection const_reel pvg 		 
		    | mc_idf op_affection const_String pvg
            | mc_idf op_affection Experssion pvg
			
;


// BOUCLE
BOUCLE : mc_while CONDITION mc_execute PARATHANSE_EXP LISTE_INST PARATHANSE_EXP pvg;


// CONTROLE
CONTROLE : mc_when CONDITION mc_do LISTE_INST
          | mc_when CONDITION mc_do LISTE_INST mc_otherwise LISTE_INST
;


// INSTRUCTION ECRIRE
ECRIRE : mc_ecrire paranthese_ouvrante const_String paranthese_fermante pvg;


// INSTRUCTION LIRE
LIRE : mc_lire paranthese_ouvrante LISTE_IDF paranthese_fermante pvg;


// LISTE_IDF_LIRE
LISTE_IDF_LIRE: mc_idf vg LISTE_IDF                                         	   
                 | mc_idf
;


// Experssion
Experssion :  Experssion OPERATEUR_ARITHMETIQUE T 
			| T
;

// OPERATEUR LOGIQUE
OPERATEUR_LOGIQUE :   LT		   
					| GT
					| LE		   
					| GE	   
					| NE
					| EQ
;

// OPERATEUR ARITHMETIQUE
OPERATEUR_ARITHMETIQUE : op_moins	
		               | op_plus		   	   
;


// OPERATEUR ARITHMETIQUE 2
T :    T op_multiplication F
     | T op_division F 
     | F
;

F : PARATHANSE_EXP Experssion PARATHANSE_EXP   
				| const_int  
				| const_reel  
				| mc_idf  
;


// PARATHANSE 
PARATHANSE_EXP  :  paranthese_ouvrante
             	 | paranthese_fermante
			  	 |				  
;


// LISTE_INST
LISTE_INST:   AFFECTATION LISTE_INST                                              
             | ECRIRE LISTE_INST 
			 | LIRE LISTE_INST 
			 |
;


// CORPS PROG
CORPS: deb LISTE_INST fin point                     
;


%%
void yyerror(const char* message){
	printf("erreur syntaxique ligne : %d  colonne : %d",nb_ligne,nb_colonne);
}
int main () 
{
yyin=fopen("ex.txt","r");
yyparse();
fclose(yyin);
return 0;
}
