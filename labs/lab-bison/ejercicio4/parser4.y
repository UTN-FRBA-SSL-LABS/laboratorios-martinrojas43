%{
#include <stdio.h>
#include <stdlib.h>

int  yylex(void);
void yyerror(const char *msg) { fprintf(stderr, "Error: %s\n", msg); }
%}

%token NUM

%left '+' '-'
%left '*' '/'

%%

input:
    /* vacío */
  | input linea
  ;

/*
 * Sin manejo de errores, el primer token inesperado hace que yyparse()
 * retorne con fallo y el resto de la entrada nunca se procesa.
 *
 * El token especial 'error' le permite a Bison intentar recuperarse:
 * descarta tokens hasta encontrar el símbolo de sincronización (acá '\n')
 * y continúa parseando la siguiente línea.
 * Llamar a yyerrok dentro de la acción resetea el estado de error interno.
 *
 * TODO 1 — Agregar en la producción 'linea' una regla de recuperación de errores.
 *   Cuando el parser encuentra tokens inválidos, descarta hasta el '\n'
 *   y retoma el parseo de la siguiente línea.
 *
 *   Agregá esta alternativa dentro de 'linea':
 *     | error '\n'  { yyerrok; printf("Error: sintaxis invalida\n"); }
 */
linea:
    exp '\n'    { printf("= %d\n", $1); }
  ;

exp:
    exp '+' exp   { $$ = $1 + $3; }
  | exp '-' exp   { $$ = $1 - $3; }
  | exp '*' exp   { $$ = $1 * $3; }
  | exp '/' exp   { $$ = $1 / $3; }
  | '(' exp ')'   { $$ = $2; }
  | NUM           { $$ = $1; }
  ;

%%

int main(void) {
    return yyparse();
}
