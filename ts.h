#ifndef TS_H
#define TS_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();

// structure pour représenter les identifiants et les constantes

typedef struct
{    
   char name[20];
   char type[20];
   char subtype[20];
   char  val[20];
   
} IdfConst;

// structure pour représenter les mots clés et les séparateurs

typedef struct
{ 
     
   char name[20];
   char type[20];
} Cle_Sep;

typedef struct Declar
{ 
     
   char name[20];
} Declar;



typedef struct PListIdfConst {
	IdfConst info;
	struct PListIdfConst *suiv;
}PListIdfConst;

typedef PListIdfConst *ListIdfConst;


typedef struct PListCleSep {
	Cle_Sep info;
	struct PListCleSep *suiv;
}PListCleSep;

typedef PListCleSep *ListCleSep;


int Exist(char idf[]);

void afficher();

void Inserer_idf(char name[20],char type[20],char val[20],char  subtype[20]);

void Inserer_clesep(char name[20],char type[20]);
PListIdfConst* rechercher_idfconst(char name[20]);
PListCleSep* rechercher_clesep(char name[20]);

Declar desempiler();
void afficherTab();
int tablePlein();
int tableVide();
void remplirTab(char val[20]);

#endif