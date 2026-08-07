%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int  yylex(void);
void yyerror(const char *msg) { fprintf(stderr, "Error: %s\n", msg); }
%}

%token NUM
%token POW
%token UMINUS   /* token ficticio para el menos unario — ya declarado, no hay que tocarlo */

/*
 * Sin declaraciones de precedencia, esta gramática tiene múltiples
 * conflictos shift/reduce: Bison no sabe si "2 + 3 * 4" es
 * "(2+3)*4" o "2+(3*4)".
 *
 * Las declaraciones %left / %right resuelven esos conflictos:
 *   - Las que aparecen MÁS ABAJO tienen MAYOR precedencia.
 *   - %left  → asociatividad izquierda: a - b - c  se lee  (a-b)-c
 *   - %right → asociatividad derecha:  a ** b ** c se lee  a**(b**c)
 *   - UMINUS es un token ficticio para darle precedencia al menos unario.
 *     Se asigna a una regla con:  | '-' exp %prec UMINUS  { ... }
 *
 * TODO 1 — Agregar: %left '+' '-'       (menor precedencia)
 * TODO 2 — Agregar: %left '*' '/'       (mayor precedencia que + -)
 * TODO 3 — Agregar: %right POW          (mayor precedencia que * /)
 * TODO 4 — Agregar: %right UMINUS       (mayor precedencia de todas)
 */

%%

input:
    /* vacío */
  | input linea
  ;

linea:
    exp '\n'   { printf("= %d\n", $1); }
  ;

exp:
    exp '+' exp           { $$ = $1 + $3; }
  | exp '-' exp           { $$ = $1 - $3; }
  | exp '*' exp           { $$ = $1 * $3; }
  | exp '/' exp           { $$ = $1 / $3; }
  | exp POW exp           { $$ = (int)pow($1, $3); }
  | '-' exp %prec UMINUS  { $$ = 0; /* TODO 5 — Reemplazar 0 por la expresión correcta */ }
  | '(' exp ')'           { $$ = $2; }
  | NUM                   { $$ = $1; }
  ;

%%

int main(void) {
    return yyparse();
}
