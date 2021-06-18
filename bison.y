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
%token AFFECT PLUS MOINS MULT DIV EGAL 
%token PRTOUV PRTFERM POINT VIRG POINTVIRG ACOLOUV ACOLFRM
%token CODE START END CONST WHILE EXECUTE WHEN DO OTHERWISE PROD

%token <t_IdfConst> IDENTIF CSTCHAR CSTSTR CSTINT CSTREEL 
%token <t_IdfConst> INTEGER REAL CHAR STRING 
%type <t_IdfConst>_CSTDECLARE_  _CSTVAL_ _IDFTYPE_ _IDFLIST_ _IDFDECLARE_ _DECLARATIONS_  _EXPRESSIONARTH_ _PARAMPROD_
%left ADD SOUS 
%left MUL DIV

%start _CODESOURCE_ 

%%

_CODESOURCE_: CODE IDENTIF _DECLARATIONS_ START _INSTRUCTIONS_ END POINT; 


_IDFTYPE_: INTEGER {strcpy($$,"INTEGER");}|
            REAL  {strcpy($$,"REAL");} |
            CHAR   {strcpy($$,"CHAR");} |
            STRING {strcpy($$,"STRING");};

_CSTVAL_: CSTINT       { strcpy($$,$1);}|
             CSTREEL    { strcpy($$,$1);}|
             CSTCHAR      { strcpy($$,$1);}|
             CSTSTR    { strcpy($$,$1);}; 



_IDFLIST_: IDENTIF VIRG _IDFLIST_  { 
                            remplirTab($1);}  |
            IDENTIF                 { 
                            remplirTab($1);
                    
                                
                                    } ; 


_IDFDECLARE_: _IDFTYPE_  _IDFLIST_  POINTVIRG {    
        Declar d;
        while(tableVide()==0){

           d = desempiler();

           PListIdfConst* p =  rechercher_idfconst(d.name);
           strcpy(p->info.subtype,$1); 
            

        }

};


_CSTDECLARE_:  CONST IDENTIF  EGAL  _CSTVAL_ POINTVIRG  {

            PListIdfConst* ele = rechercher_idfconst($2);
            PListIdfConst* ele2 = rechercher_idfconst($4);
            strcpy(ele->info.subtype,ele2->info.subtype);
};

_DECLARATIONS_: _IDFDECLARE_   _DECLARATIONS_ |
                _CSTDECLARE_ _DECLARATIONS_|
                  ;       
                              


_EXPRESSIONARTH_: PRTOUV _EXPRESSIONARTH_  PRTFERM|
                          PRTOUV _EXPRESSIONARTH_  PRTFERM PLUS _EXPRESSIONARTH_ |
                          PRTOUV _EXPRESSIONARTH_  PRTFERM MOINS _EXPRESSIONARTH_ |
                          PRTOUV _EXPRESSIONARTH_  PRTFERM DIV _EXPRESSIONARTH_ {if(strcmp($5,"0")==0 || strcmp($5,"0.0")==0){yyerror("division par zero");}} |
                          PRTOUV _EXPRESSIONARTH_  PRTFERM MUL _EXPRESSIONARTH_ |

                          IDENTIF PLUS _EXPRESSIONARTH_ {  
                                            
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                            if(strcmp(p->info.subtype,"CHAR")==0 || strcmp(p->info.subtype,"STRING")==0){
                                                yyerror("types incompatibles");

                                            
                                                }
                                                ;} |
                          IDENTIF MOINS _EXPRESSIONARTH_  {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                 if(strcmp(p->info.subtype,"CHAR")==0 || strcmp(p->info.subtype,"STRING")==0){
                                                yyerror("types incompatibles");

                                            
                                                }
                                                ;}  |
                          IDENTIF DIV _EXPRESSIONARTH_   {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                 if(strcmp(p->info.subtype,"CHAR")==0 || strcmp(p->info.subtype,"STRING")==0){
                                                yyerror("types incompatibles");

                                            
                                                }
                                                if(strcmp($3,"0")==0 || strcmp($3,"0.0")==0){yyerror("division par zero");}
                                                ;}|
                          IDENTIF MUL _EXPRESSIONARTH_  {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;} |

                          CSTINT PLUS  _EXPRESSIONARTH_  |
                          CSTINT MOINS  _EXPRESSIONARTH_  |
                          CSTINT DIV  _EXPRESSIONARTH_ {if(strcmp($3,"0")==0 || strcmp($3,"0.0")==0){yyerror("division par zero");}} |
                          CSTINT MUL  _EXPRESSIONARTH_  |

                          CSTREEL PLUS  _EXPRESSIONARTH_ |
                          CSTREEL MOINS  _EXPRESSIONARTH_ |
                          CSTREEL DIV  _EXPRESSIONARTH_ {if(strcmp($3,"0")==0 || strcmp($3,"0.0")==0){yyerror("division par zero");}} |
                          CSTREEL MUL  _EXPRESSIONARTH_ |
                          IDENTIF {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;}|
                          CSTINT {strcpy($$,$1);}|
                          CSTREEL {strcpy($$,$1);} ;

_PARAMPROD_: _PARAMPROD_ VIRG _PARAMPROD_ | 
            IDENTIF PLUS _PARAMPROD_ {  
                                            
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;} |
            IDENTIF MOINS _PARAMPROD_ {  
                                            
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;}|
            IDENTIF MULT _PARAMPROD_ {  
                                            
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;} |
            IDENTIF DIV _PARAMPROD_ {  
                                            
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                            if(strcmp($3,"0")==0 || strcmp($3,"0.0")==0){yyerror("division par zero");}
                                                ;}|
            CSTINT PLUS _PARAMPROD_ |
            CSTINT MOINS _PARAMPROD_ |
            CSTINT DIV _PARAMPROD_  {if(strcmp($3,"0")==0 || strcmp($3,"0.0")==0){yyerror("division par zero");}}|
            CSTINT MULT _PARAMPROD_ |
            CSTREEL MULT _PARAMPROD_ |
            CSTREEL DIV _PARAMPROD_ {if(strcmp($3,"0")==0 || strcmp($3,"0.0")==0){yyerror("division par zero");}} |
            CSTREEL PLUS _PARAMPROD_ |
            CSTREEL MOINS _PARAMPROD_ |
            IDENTIF {  
                                            
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            };} |
            CSTINT |
            CSTREEL;

                         
_AFFECTATION_: IDENTIF AFFECT _EXPRESSIONARTH_  POINTVIRG {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }

                                                ;}|
               IDENTIF AFFECT CSTSTR POINTVIRG {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;}|
                IDENTIF AFFECT CSTCHAR POINTVIRG  {  
                                            PListIdfConst* p =  rechercher_idfconst($1);
                                            if(strcmp(p->info.subtype,"")==0){
                                                yyerror("variable non déclaré");
                                            }
                                                ;} |
                IDENTIF AFFECT PROD PRTOUV _PARAMPROD_ PRTFERM POINTVIRG ;

_INSTRUCTIONS_: _AFFECTATION_  _INSTRUCTIONS_ |
                _CONTROLE_ _INSTRUCTIONS_ |
                _BOUCLE_ _INSTRUCTIONS_ |
                _BOUCLE_ |
                _CONTROLE_ |
                _AFFECTATION_   ;  

_CONDITIONS_: PRTOUV  _EXPRESSIONARTH_ EQ _EXPRESSIONARTH_  PRTFERM |
              PRTOUV  _EXPRESSIONARTH_ LE _EXPRESSIONARTH_  PRTFERM |
              PRTOUV  _EXPRESSIONARTH_ LT _EXPRESSIONARTH_  PRTFERM |
              PRTOUV  _EXPRESSIONARTH_ GT _EXPRESSIONARTH_  PRTFERM |
              PRTOUV  _EXPRESSIONARTH_ GE _EXPRESSIONARTH_  PRTFERM |
              PRTOUV  _EXPRESSIONARTH_ NE _EXPRESSIONARTH_  PRTFERM |
              _EXPRESSIONARTH_ EQ _EXPRESSIONARTH_ |
              _EXPRESSIONARTH_ LE _EXPRESSIONARTH_ |
              _EXPRESSIONARTH_ LT _EXPRESSIONARTH_ |
              _EXPRESSIONARTH_ GT _EXPRESSIONARTH_ |
              _EXPRESSIONARTH_ GE _EXPRESSIONARTH_ |
              _EXPRESSIONARTH_ NE _EXPRESSIONARTH_ ;


          

_CONTROLE_: WHEN _CONDITIONS_  DO _INSTRUCTIONS_ OTHERWISE _INSTRUCTIONS_  ;                            

_BOUCLE_: WHILE _CONDITIONS_ EXECUTE  ACOLOUV _INSTRUCTIONS_ ACOLFRM POINTVIRG ;                




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
