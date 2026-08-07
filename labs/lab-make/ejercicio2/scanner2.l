%{
#include <stdio.h>
%}

%%

[0-9]+      { printf("Numero: %s\n", yytext); }
[ \t\n]+    { /* ignorar espacios y saltos de linea */ }
.           { /* ignorar otros caracteres */ }

%%

int main() {
    yylex();
    return 0;
}

int yywrap() { return 1; }
