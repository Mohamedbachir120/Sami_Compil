%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "ts.h"

    
    extern FILE* yyin;
    extern int yytext;

    extern int numero_ligne;
    extern int numero_colonne;


    int yyparse();
    int yywrap();
	int yylex();
	void yyerror(const char *str);
    int error(char *str);

%}

%union {
    char* string;
    int integer;
    char t_IdfConst[20];
   
    }

%token EQ NE LT LE GT GE
%token AFFECT PLUS MOINS MULT DIV EGAL PROD
%token PARENOUV PARENFER POINT VIRG POINTVIRG ACCOUV ACCFERM
%token CODE START END CONST WHILE EXECUTE WHEN DO OTHERWISE 

%token <t_IdfConst> IDENTIF CONSTCHAR CONSTSTRING CONSTINT CONSTREELLE 
%token <t_IdfConst> INTEGER REAL CHAR STRING  
%type <t_IdfConst>_DECLARATIONSCONST_  _VALSCONST_ _TYPESIDF_ _LISTIDF_ _DECLARATIONIDF_ _DECLARATIONS_  _EXPRESSIONARITHMETIQUE_ 
%left ADD SOUS 
%left MUL DIV

%start _CODESOURCE_ 

%%

_CODESOURCE_: CODE IDENTIF _DECLARATIONS_ START _INSTRUCTIONS_ END POINT; 


_TYPESIDF_: INTEGER {strcpy($$,"INTEGER");}|
            REAL  {strcpy($$,"REAL");} |
            CHAR   {strcpy($$,"CHAR");} |
            STRING {strcpy($$,"STRING");};

_VALSCONST_: CONSTINT       { strcpy($$,$1);}|
             CONSTREELLE    { strcpy($$,$1);}|
             CONSTCHAR      { strcpy($$,$1);}|
             CONSTSTRING    { strcpy($$,$1);}; 



_LISTIDF_: IDENTIF VIRG _LISTIDF_  { 
                            remplirTab($1);}  |
            IDENTIF                 { 
                            remplirTab($1);
                    
                                
                                    } ; 


_DECLARATIONIDF_: _TYPESIDF_  _LISTIDF_  POINTVIRG {    
        Declar d;
        while(tableVide()==0){

           d = desempiler();

           PListIdfConst* p =  rechercher_idfconst(d.name);
           strcpy(p->info.subtype,$1); 
            

        }

};


_DECLARATIONSCONST_:  CONST IDENTIF  EGAL  _VALSCONST_ POINTVIRG  {

            PListIdfConst* ele = rechercher_idfconst($2);
            PListIdfConst* ele2 = rechercher_idfconst($4);
            strcpy(ele->info.subtype,ele2->info.subtype);
};

_DECLARATIONS_: _DECLARATIONIDF_   _DECLARATIONS_ |
                _DECLARATIONSCONST_ _DECLARATIONS_|
                  ;       
                              


_EXPRESSIONARITHMETIQUE_: PARENOUV _EXPRESSIONARITHMETIQUE_  PARENFER|
                          PARENOUV _EXPRESSIONARITHMETIQUE_  PARENFER PLUS _EXPRESSIONARITHMETIQUE_ |
                          PARENOUV _EXPRESSIONARITHMETIQUE_  PARENFER MOINS _EXPRESSIONARITHMETIQUE_ |
                          PARENOUV _EXPRESSIONARITHMETIQUE_  PARENFER DIV _EXPRESSIONARITHMETIQUE_ |
                          PARENOUV _EXPRESSIONARITHMETIQUE_  PARENFER MUL _EXPRESSIONARITHMETIQUE_ |

                          IDENTIF PLUS _EXPRESSIONARITHMETIQUE_ {  
                                            
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                            if(strcmp(p->info.subtype,"CHAR")==0 || strcmp(p->info.subtype,"STRING")==0){
                                                yyerror("types incompatibles");

                                            
                                                }
                                                ;} |
                          IDENTIF MOINS _EXPRESSIONARITHMETIQUE_  {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                 if(strcmp(p->info.subtype,"CHAR")==0 || strcmp(p->info.subtype,"STRING")==0){
                                                yyerror("types incompatibles");

                                            
                                                }
                                                ;}  |
                          IDENTIF DIV _EXPRESSIONARITHMETIQUE_   {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                 if(strcmp(p->info.subtype,"CHAR")==0 || strcmp(p->info.subtype,"STRING")==0){
                                                yyerror("types incompatibles");

                                            
                                                }
                                                ;}|
                          IDENTIF MUL _EXPRESSIONARITHMETIQUE_  {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;} |

                          CONSTINT PLUS  _EXPRESSIONARITHMETIQUE_  |
                          CONSTINT MOINS  _EXPRESSIONARITHMETIQUE_  |
                          CONSTINT DIV  _EXPRESSIONARITHMETIQUE_  |
                          CONSTINT MUL  _EXPRESSIONARITHMETIQUE_  |

                          CONSTREELLE PLUS  _EXPRESSIONARITHMETIQUE_ |
                          CONSTREELLE MOINS  _EXPRESSIONARITHMETIQUE_ |
                          CONSTREELLE DIV  _EXPRESSIONARITHMETIQUE_ |
                          CONSTREELLE MUL  _EXPRESSIONARITHMETIQUE_ |
                          IDENTIF {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;}|
                          CONSTINT |
                          CONSTREELLE ;

_AFFECTATION_: IDENTIF AFFECT _EXPRESSIONARITHMETIQUE_  POINTVIRG {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }

                                                ;}|
               IDENTIF AFFECT CONSTSTRING POINTVIRG {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;}|
                IDENTIF AFFECT CONSTCHAR POINTVIRG  {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;};

_INSTRUCTIONS_: _AFFECTATION_  _INSTRUCTIONS_ |
                _CONTROLE_ _INSTRUCTIONS_ |
                _BOUCLE_ _INSTRUCTIONS_ |
                _BOUCLE_ |
                _CONTROLE_ |
                _AFFECTATION_   ;  

_CONDITIONS_: PARENOUV  _EXPRESSIONARITHMETIQUE_ EQ _EXPRESSIONARITHMETIQUE_  PARENFER |
              PARENOUV  _EXPRESSIONARITHMETIQUE_ LE _EXPRESSIONARITHMETIQUE_  PARENFER |
              PARENOUV  _EXPRESSIONARITHMETIQUE_ LT _EXPRESSIONARITHMETIQUE_  PARENFER |
              PARENOUV  _EXPRESSIONARITHMETIQUE_ GT _EXPRESSIONARITHMETIQUE_  PARENFER |
              PARENOUV  _EXPRESSIONARITHMETIQUE_ GE _EXPRESSIONARITHMETIQUE_  PARENFER |
              PARENOUV  _EXPRESSIONARITHMETIQUE_ NE _EXPRESSIONARITHMETIQUE_  PARENFER |
              _EXPRESSIONARITHMETIQUE_ EQ _EXPRESSIONARITHMETIQUE_ |
              _EXPRESSIONARITHMETIQUE_ LE _EXPRESSIONARITHMETIQUE_ |
              _EXPRESSIONARITHMETIQUE_ LT _EXPRESSIONARITHMETIQUE_ |
              _EXPRESSIONARITHMETIQUE_ GT _EXPRESSIONARITHMETIQUE_ |
              _EXPRESSIONARITHMETIQUE_ GE _EXPRESSIONARITHMETIQUE_ |
              _EXPRESSIONARITHMETIQUE_ NE _EXPRESSIONARITHMETIQUE_ ;


          

_CONTROLE_: WHEN _CONDITIONS_  DO _INSTRUCTIONS_ OTHERWISE _INSTRUCTIONS_  ;                            

_BOUCLE_: WHILE _CONDITIONS_ EXECUTE  ACCOUV _INSTRUCTIONS_ ACCFERM POINTVIRG ;                




%%

void yyerror(const char* message) {
    if(strcmp(message,"syntax error")==0){
        fprintf(
        stderr, 
        "[%s] (ligne = %i, colonne = %i)\n",
        message, 
        numero_ligne, 
        numero_colonne
    );
    } else{
      
      fprintf(
        stderr, 
        "[%s] (ligne = %i, colonne = %i)\n",
        message, 
        numero_ligne, 
        numero_colonne
    );
       }
	
    
}

int error(char* message) {
    fprintf(
        stdout, 
        "\t\t\t\t\t [ERREUR SEMANTIQUE] %s (ligne = %i, colonne = %i)\n", 
        message, 
        numero_ligne, 
        numero_colonne
    );
    return 0;
}


int main(int argc, char *argv[]) {
    yyin=fopen("ex.txt","r");
    yyparse();
    afficher();
    fclose(yyin);
    return 0;
}