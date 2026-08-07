#!/usr/bin/env bash
# test_local.sh — Verificación local del laboratorio Flex
# Ejecutá: make test  (o  bash test_local.sh)
set -euo pipefail

PASS=0
FAIL=0
SCORE=0

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

check() {
  local id="$1" desc="$2" pts="$3"
  shift 3
  if "$@" &>/dev/null; then
    echo -e "${GREEN}✅ $id. $desc (+$pts pts)${RESET}"
    PASS=$((PASS + 1))
    SCORE=$((SCORE + pts))
  else
    echo -e "${RED}❌ $id. $desc (0 / $pts pts)${RESET}"
    FAIL=$((FAIL + 1))
  fi
}

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Verificación local del laboratorio Flex"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

MISSING=""
for tool in flex gcc; do
  command -v $tool &>/dev/null || MISSING="$MISSING $tool"
done
if [ -n "$MISSING" ]; then
  echo -e "${YELLOW}⚠️  Herramientas faltantes:$MISSING${RESET}"
  echo -e "${YELLOW}   Instalá con: sudo apt-get install -y flex gcc${RESET}"
  echo -e "${YELLOW}   (macOS: brew install flex gcc)${RESET}"
  echo ""
fi

# ── Ejercicio 1: yytext y comodín ──────────────────
check E1.1 "scanner1.l compila" 5 \
  bash -c 'cd ejercicio1 && flex scanner1.l && gcc lex.yy.c -o scanner1'

check E1.2 "Reconoce constante decimal" 5 \
  bash -c "cd ejercicio1 && ./scanner1 < entrada.txt | grep -q 'constante decimal'"

check E1.3 "Reconoce constante octal" 5 \
  bash -c "cd ejercicio1 && ./scanner1 < entrada.txt | grep -q 'constante octal'"

check E1.4 "Reconoce identificador" 5 \
  bash -c "cd ejercicio1 && ./scanner1 < entrada.txt | grep -q 'identificador'"

check E1.5 "Regla comodin reconoce caracter no reconocido" 5 \
  bash -c "cd ejercicio1 && ./scanner1 < entrada.txt | grep -q 'caracter no reconocido'"

# ── Ejercicio 2: Definiciones ERX y yyleng ─────────
check E2.1 "scanner2.l compila" 5 \
  bash -c 'cd ejercicio2 && flex scanner2.l && gcc lex.yy.c -o scanner2'

check E2.2 "Usa definiciones ERX en las reglas" 5 \
  bash -c "grep -qE '\{[a-z]' ejercicio2/scanner2.l"

check E2.3 "Imprime longitud con yyleng" 5 \
  bash -c "cd ejercicio2 && ./scanner2 < entrada.txt | grep -qi 'longitud'"

check E2.4 "Longitud correcta para 'abc' (3 caracteres)" 5 \
  bash -c "cd ejercicio2 && ./scanner2 < entrada.txt | grep -q 'longitud 3'"

check E2.5 "Longitud correcta para 'miVariable' (10 caracteres)" 5 \
  bash -c "cd ejercicio2 && ./scanner2 < entrada.txt | grep -q 'longitud 10'"

# ── Ejercicio 3: Variables globales y funciones ─────
check E3.1 "scanner3.l compila con misfunciones.c" 5 \
  bash -c 'cd ejercicio3 && flex scanner3.l && gcc lex.yy.c misfunciones.c -o scanner3'

check E3.2 "Reconoce e imprime identificadores" 5 \
  bash -c "cd ejercicio3 && ./scanner3 < entrada.txt | grep -q 'identificador: abc'"

check E3.3 "Contador de tokens correcto (4 tokens)" 10 \
  bash -c "cd ejercicio3 && ./scanner3 < entrada.txt | grep -q 'Tokens totales: 4'"

check E3.4 "Llama a duplicar() correctamente (El doble es: 8)" 5 \
  bash -c "cd ejercicio3 && ./scanner3 < entrada.txt | grep -q 'El doble es: 8'"

# ── Ejercicio 4: Reconocedor de tokens ─────────────
check E4.1 "scanner4.l compila" 5 \
  bash -c 'cd ejercicio4 && flex scanner4.l && gcc lex.yy.c -o scanner4'

check E4.2 "Retorna y muestra token NUMBER" 5 \
  bash -c "cd ejercicio4 && echo '42' | ./scanner4 | grep -q 'TOKEN NUMBER'"

check E4.3 "Retorna y muestra token IDENT" 5 \
  bash -c "cd ejercicio4 && echo 'miVar' | ./scanner4 | grep -q 'TOKEN IDENT'"

# ── Preguntas de reflexión ─────────────────────────
check P1 "Regla por defecto de Flex" 4 \
  bash -c "grep -qE '^P1=ECHO$' README.md"

check P2 "Desempate entre reglas de igual longitud" 3 \
  bash -c "grep -qE '^P2=LA_PRIMERA$' README.md"

check P3 "Variable yyleng" 3 \
  bash -c "grep -qiE '^P3=SI$' README.md"

# ── Resumen ────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  Puntaje local: ${SCORE} / 100"
echo "  ✅ $PASS   ❌ $FAIL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

MIN_SCORE="${MIN_SCORE:-60}"
if ((SCORE < MIN_SCORE)); then
  echo -e "${RED}Puntaje insuficiente: $SCORE / 100 (mínimo $MIN_SCORE).${RESET}"
  exit 1
fi
