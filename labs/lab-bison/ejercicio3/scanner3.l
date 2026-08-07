%{
#include "parser3.tab.h"
#include <stdlib.h>
%}

%option noyywrap

%%

[0-9]+      { yylval = atoi(yytext); return NUM; }
[ \t]       { /* ignorar espacios y tabs */ }
\n          { return '\n'; }
"**"        { return POW; }
.           { return yytext[0]; }

%%
