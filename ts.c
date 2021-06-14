#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ts.h"
#include <assert.h>

ListIdfConst listeIdfConst = NULL;

ListCleSep listeCleSep = NULL;

Declar tabDeclar[20];


int tete= -1;

void remplirTab(char val[20]){
    tete++;
    assert(tete < 20);
    Declar temp;
    strcpy(temp.name,val);
    tabDeclar[tete]=temp;
    
}
Declar desempiler(){

    Declar temp;
    temp = tabDeclar[tete];
    tete--;
    return temp;
}
int tableVide(){
    if(tete==-1){
        return 1;
    }
    return 0;
}

int tablePlein(){
    if(tete==19){
        return 1;
    }else{
        return 0;
    }
}
void afficherTab(){
    int i=0;
    for(i;i<=19;i++){
        fprintf(stdout,"%s \n",tabDeclar[i].name);
    }
}




int Exist(char idf[]) {
	ListIdfConst t;
	t=listeIdfConst;
    
	while(t!=NULL ) {
		if(strcmp(t->info.name,idf) == 0) return 1;
		t=t->suiv;
	}
	return 0;
}

void afficher(){

        ListIdfConst l=listeIdfConst;   
        // affichage des tables des IDF et constantes 

                printf("/***************Table des symboles IDF et Constantes *************/\n");

                puts("Nom d'entité              | type (Idf,Const)  |       sous-type (Entier - Réel - chaine)      | Valeur      "); 
                puts("------------------------------------------------------------------------------------------------------------");   

                while(l!=NULL ) {

                            fprintf(stdout,"%-15s           |%-15s            |%-15s          |%-15s\n",l->info.name,l->info.type,l->info.subtype,l->info.val);     

                 
               
                
                    l=l->suiv;
                }


        ListCleSep l2= listeCleSep;   

        // affichage des tables des mots clés et séparateurs

                printf("\n/***************Table des symboles mots clés *************/\n\n");

                puts("    |Nom d'entité                    |type                \n");    
                puts("    |------------                    |----\n");

                while(l2!=NULL ) {

                fprintf(stdout,"    |%-15s                 |%-15s            \n",l2->info.name,l2->info.type);     
                l2=l2->suiv;                
                }
}

void Inserer_idf(char name[20],char type[20],char val[20],char  subtype[20]){

    IdfConst info;
    PListIdfConst* nouveau =(PListIdfConst*)  malloc(sizeof(PListIdfConst));
   
    strcpy(info.name,name);
    strcpy(info.type,type);
    strcpy(info.val,val);
    strcpy(info.subtype,subtype);
    nouveau->info=info;

    if(Exist(name)==0){
        if(listeIdfConst != NULL){
        ListIdfConst temp=listeIdfConst;
        while(temp->suiv !=NULL){
            temp=temp->suiv;
        }
       
            temp->suiv=nouveau;

    }
    else
    {
        listeIdfConst= nouveau;
    }
     nouveau->suiv=NULL;

    }

}

void Inserer_clesep(char name[20],char type[20]){

    Cle_Sep info ;
    strcpy(info.name,name);
    strcpy(info.type,type);
    PListCleSep* nouveau =(PListCleSep*)  malloc(sizeof(PListCleSep));
    nouveau->info=info;
    nouveau->suiv=NULL;

    if(listeCleSep != NULL){
    ListCleSep temp=listeCleSep;

    
        while(temp->suiv !=NULL){
            temp=temp->suiv;
        }
    temp->suiv=nouveau;
   
    }
    else{
   
     listeCleSep = nouveau;
     

    }

}

PListIdfConst* rechercher_idfconst(char name[20])
{
    ListIdfConst t;
	t=listeIdfConst;
    
	while(t!=NULL ) {
		if(strcmp(t->info.name,name) == 0) return t;
	
		t=t->suiv;
	}
	return t;
}

PListCleSep* rechercher_clesep(char name[20])
{
    ListCleSep t;
	t=listeCleSep;
    
	while(t!=NULL ) {
		if(strcmp(t->info.name,name) == 0) return t;
	
		t=t->suiv;
	}
	return t;
}
