%pointer
%option noyywrap

%{
#include <stdio.h>
#include "misfunciones.h"

 /* Variable global para contar los tokens reconocidos */
int contadorTokens = 0;
%}

letra           [a-zA-Z_]
digito          [0-9]
identificador   {letra}({letra}|{digito})*

%%

{identificador}  {
    /* TODO 1 — Incrementar contadorTokens en 1 */
   
    /* TODO 2 — Imprimir el identificador reconocido
       Formato esperado: printf("identificador: %s\n", yytext);  */
}

[ \t\n]         { }

.               { printf("caracter no reconocido: %s\n", yytext); }

%%

int main(void) {
    yylex();

    /* TODO 3 — Imprimir el total de tokens al finalizar
       Formato esperado: printf("Tokens totales: %d\n", contadorTokens);          */

    /* TODO 4 — Imprimir el doble del total usando la función duplicar()
       Formato esperado: printf("El doble es: %d\n", duplicar(contadorTokens));   */

    return 0;
}
