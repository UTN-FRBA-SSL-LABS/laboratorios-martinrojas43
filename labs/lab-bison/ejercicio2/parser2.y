%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int  yylex(void);
void yyerror(const char *msg) { fprintf(stderr, "Error: %s\n", msg); }
%}

/*
 * %union define los posibles tipos que puede tener yylval.
 * Cada token o no-terminal puede usar un miembro distinto de la union.
 * Bison se encarga de que $N acceda automáticamente al miembro correcto.
 */
%union {
    int  int_val;
    /* TODO 1 — Agregar un miembro para cadenas: char str_val[64]; */
}

/* Declaración de tokens con su tipo semántico */
%token <int_val>  NUM             /* Ejemplo: NUM usa el miembro int_val */
/* TODO 2 — Declarar IDENT con el tipo str_val: %token <str_val> IDENT  */

/* TODO 3 — Declarar el tipo de la producción 'item': %type <int_val> item */
/*          (cambiar int_val por el miembro adecuado una vez que agregues str_val) */

%%

input:
    /* vacío */
  | input item
  ;

item:
    NUM '\n'   { printf("Numero: %d\n", $1); }   /* Ejemplo: ya implementado */
  | /* TODO 4 — Agregar regla para IDENT '\n' que imprima: "Identificador: <nombre>\n" */
  ;

%%

int main(void) {
    return yyparse();
}
