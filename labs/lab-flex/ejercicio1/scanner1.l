%pointer
%option noyywrap

%%

 /* ── Reglas ya implementadas ────────────────────────── */

 /* Constante octal: 0 seguido de dígitos octales (o solo 0) */
0[0-7]*         { printf("constante octal: %s\n", yytext); }

 /* Ignorar espacios, tabs y saltos de línea */
[ \t\n]         { }

 /* ── TODO: completar las siguientes reglas ──────────── */

 /* TODO 1 — Constante decimal (ej: 123, 456, 9)
   Pista: empieza con un dígito del 1-9, seguido de cero o más dígitos [0-9]
   Acción esperada: printf("constante decimal: %s\n", yytext);           */

 /* TODO 2 — Constante hexadecimal (ej: 0x1A, 0xFF, 0xDEAD)
   Pista: empieza con 0x o 0X, seguido de uno o más dígitos hexadecimales
   Acción esperada: printf("constante hexadecimal: %s\n", yytext);       */

 /* TODO 3 — Identificador (ej: miVariable, _count, hola_mundo)
   Pista: empieza con letra o _, seguido de letras, dígitos o _
   Acción esperada: printf("identificador: %s\n", yytext);               */

 /* TODO 4 — Comodín: cualquier carácter no reconocido por las reglas anteriores
   Pista: el patrón . coincide con cualquier carácter
   Acción esperada: printf("caracter no reconocido: %s\n", yytext);      */

%%

int main(void) {
    yylex();
    return 0;
}
