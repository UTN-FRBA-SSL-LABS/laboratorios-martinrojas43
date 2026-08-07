%{
#include "parser2.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%option noyywrap

%%

[0-9]+                   { yylval.int_val = atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*  { strcpy(yylval.str_val, yytext); return IDENT; }
[ \t]                    { /* ignorar espacios y tabs */ }
\n                       { return '\n'; }
.                        { /* ignorar otros caracteres */ }

%%
