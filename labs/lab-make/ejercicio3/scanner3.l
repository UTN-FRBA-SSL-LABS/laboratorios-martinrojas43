%{
#include "parser3.tab.h"
#include <stdlib.h>
%}

%%

[0-9]+      { yylval = atoi(yytext); return NUM; }
"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"("         { return '('; }
")"         { return ')'; }
"\n"        { return '\n'; }
[ \t]+      { /* ignorar espacios */ }
.           { /* ignorar otros */ }

%%

int yywrap() { return 1; }
