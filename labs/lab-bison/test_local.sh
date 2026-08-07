#!/usr/bin/env bash
# test_local.sh — Verificación local del laboratorio Bison
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
echo "  Verificación local del laboratorio Bison"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

MISSING=""
for tool in bison flex gcc; do
  command -v $tool &>/dev/null || MISSING="$MISSING $tool"
done
if [ -n "$MISSING" ]; then
  echo -e "${YELLOW}⚠️  Herramientas faltantes:$MISSING${RESET}"
  echo -e "${YELLOW}   Instalá con: sudo apt-get install -y bison flex gcc${RESET}"
  echo -e "${YELLOW}   (macOS: brew install bison flex gcc)${RESET}"
  echo ""
fi

# ── Ejercicio 1 ────────────────────────────────────
check E1.1 "parser1.y compila" 5 \
  bash -c 'cd ejercicio1 && bison -d parser1.y && flex scanner1.l && gcc lex.yy.c parser1.tab.c -o calc1'

check E1.2 "Suma correctamente (3 + 4 = 7)" 5 \
  bash -c "cd ejercicio1 && echo '3 + 4' | ./calc1 | grep -q '= 7'"

check E1.3 "Resta correctamente (10 - 3 = 7)" 5 \
  bash -c "cd ejercicio1 && echo '10 - 3' | ./calc1 | grep -q '= 7'"

check E1.4 "Multiplicacion correctamente (2 * 5 = 10)" 5 \
  bash -c "cd ejercicio1 && echo '2 * 5' | ./calc1 | grep -q '= 10'"

check E1.5 "Division correctamente (8 / 2 = 4)" 5 \
  bash -c "cd ejercicio1 && echo '8 / 2' | ./calc1 | grep -q '= 4'"

# ── Ejercicio 2 ────────────────────────────────────
check E2.1 "parser2.y compila" 5 \
  bash -c 'cd ejercicio2 && bison -d parser2.y && flex scanner2.l && gcc lex.yy.c parser2.tab.c -o calc2'

check E2.2 "Usa %union con miembro str_val" 5 \
  bash -c "grep -q 'str_val' ejercicio2/parser2.y"

check E2.3 "Declara token IDENT" 5 \
  bash -c "grep -qE '%token.*IDENT' ejercicio2/parser2.y"

check E2.4 "Imprime numero correctamente" 5 \
  bash -c "cd ejercicio2 && echo '42' | ./calc2 | grep -q 'Numero: 42'"

check E2.5 "Imprime identificador correctamente" 5 \
  bash -c "cd ejercicio2 && echo 'hola' | ./calc2 | grep -q 'Identificador: hola'"

# ── Ejercicio 3 ────────────────────────────────────
check E3.1 "parser3.y compila" 5 \
  bash -c 'cd ejercicio3 && bison -d parser3.y && flex scanner3.l && gcc lex.yy.c parser3.tab.c -o calc3 -lm'

check E3.2 "Declara precedencia con %left" 5 \
  bash -c "grep -q '%left' ejercicio3/parser3.y"

check E3.3 "Precedencia correcta: 2 + 3 * 4 = 14" 5 \
  bash -c "cd ejercicio3 && printf '2 + 3 * 4\n' | ./calc3 | grep -q '= 14'"

check E3.4 "Asociatividad izquierda: 10 - 2 - 3 = 5" 5 \
  bash -c "cd ejercicio3 && printf '10 - 2 - 3\n' | ./calc3 | grep -q '= 5'"

check E3.5 "Menos unario: -5 + 10 = 5" 5 \
  bash -c "cd ejercicio3 && printf -- '-5 + 10\n' | ./calc3 | grep -q '= 5'"

# ── Ejercicio 4 ────────────────────────────────────
check E4.1 "parser4.y compila" 5 \
  bash -c 'cd ejercicio4 && bison -d parser4.y && flex scanner4.l && gcc lex.yy.c parser4.tab.c -o calc4'

check E4.2 "Procesa expresion valida antes del error (= 7)" 5 \
  bash -c "cd ejercicio4 && ./calc4 < entrada.txt | grep -q '= 7'"

check E4.3 "Continua tras error y procesa expresion valida (= 10)" 5 \
  bash -c "cd ejercicio4 && ./calc4 < entrada.txt | grep -q '= 10'"

# ── Preguntas de reflexión ─────────────────────────
check P1 "Resolucion de conflictos por defecto en Bison" 4 \
  bash -c "grep -qE '^P1=SHIFT$' README.md"

check P2 "Precedencia segun orden de declaraciones" 3 \
  bash -c "grep -qiE '^P2=SI$' README.md"

check P3 "Efecto de yyerrok" 3 \
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
