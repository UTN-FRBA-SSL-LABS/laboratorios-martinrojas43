%{
#include <stdio.h>
int yylex();
void yyerror(const char *s) { fprintf(stderr, "Error: %s\n", s); }
%}

%token NUM

%left '+' '-'
%left '*' '/'

%%

programa:
    programa linea
  | /* vacio */
;

linea:
    exp '\n'    { printf("= %d\n", $1); }
  | '\n'        { /* linea vacia */ }
;

exp:
    exp '+' exp { $$ = $1 + $3; }
  | exp '-' exp { $$ = $1 - $3; }
  | exp '*' exp { $$ = $1 * $3; }
  | exp '/' exp { $$ = $1 / $3; }
  | '(' exp ')' { $$ = $2; }
  | NUM         { $$ = $1; }
;

%%

int main() {
    return yyparse();
}
