%pointer
%option noyywrap

 /* ── Sección de definiciones ERX ───────────────────────────────────────
   Las definiciones permiten nombrar expresiones regulares para reutilizarlas.
   Formato:   nombre   expresion_regular
   Uso en reglas:  {nombre}
   ─────────────────────────────────────────────────────────────────── */

 /* Definición ya dada como ejemplo: */
digitoHexa      [0-9a-fA-F]

 /* TODO 1 — Definir 'digito' como cualquier dígito decimal [0-9]        */

 /* TODO 2 — Definir 'letra' como letra mayúscula, minúscula o guión bajo */

 /* TODO 3 — Definir 'identificador' usando {letra} y {digito}
   Pista: empieza con {letra}, seguido de cero o más ({letra}|{digito}) */

%%

 /* ── Reglas usando las definiciones ─────────────────────────────────── */

 /* Regla ya dada como ejemplo: usa {digitoHexa} y muestra yyleng */
0[xX]{digitoHexa}+  { printf("constante hexadecimal de longitud %d: %s\n", yyleng, yytext); }

 /* TODO 4 — Regla para constante decimal usando {digito}
   Pista: empieza con dígito 1-9 (no cero), seguido de cero o más {digito}
   Acción esperada: printf("constante decimal de longitud %d: %s\n", yyleng, yytext);    */

 /* TODO 5 — Regla para identificador usando {identificador}
   Acción esperada: printf("identificador de longitud %d: %s\n", yyleng, yytext);        */

[ \t\n]     { }
.           { printf("caracter no reconocido: %s\n", yytext); }

%%

int main(void) {
    yylex();
    return 0;
}
