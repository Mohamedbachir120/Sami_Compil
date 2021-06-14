#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_CMN_LEN 100

int main(int argc, char *argv[])
{
    
        system("flex lexical.l && bison -d bison.y &&  cc lex.yy.c bison.tab.c ts.c  -o compilateur && ./compilateur");
    

    return 0;
}
