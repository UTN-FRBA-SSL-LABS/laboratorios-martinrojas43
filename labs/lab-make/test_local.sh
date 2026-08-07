#!/usr/bin/env bash
# test_local.sh — Verificación local del laboratorio Make
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
echo "  Verificación local del laboratorio Make"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Verificar herramientas necesarias
MISSING=""
for tool in make gcc flex bison; do
  command -v $tool &>/dev/null || MISSING="$MISSING $tool"
done
if [ -n "$MISSING" ]; then
  echo -e "${YELLOW}⚠️  Herramientas faltantes:$MISSING${RESET}"
  echo -e "${YELLOW}   Instalá con: sudo apt-get install -y make gcc flex bison${RESET}"
  echo -e "${YELLOW}   (macOS: brew install make gcc flex bison)${RESET}"
  echo ""
fi

# ── Ejercicio 1: Makefile básico con gcc ──────────
check E1.1 "make genera el ejecutable" 5 \
  bash -c 'cd ejercicio1 && make -s && test -f suma'

check E1.2 "Suma correcta (3 + 4 = 7)" 5 \
  bash -c "cd ejercicio1 && make -s && echo '3 4' | ./suma | grep -q '3 + 4 = 7'"

check E1.3 "Suma correcta (10 + 5 = 15)" 5 \
  bash -c "cd ejercicio1 && make -s && echo '10 5' | ./suma | grep -q '10 + 5 = 15'"

check E1.4 "make clean elimina el ejecutable" 5 \
  bash -c 'cd ejercicio1 && make -s && make clean -s && ! test -f suma'

check E1.5 "Makefile usa la variable \$(CC)" 5 \
  bash -c "grep -q '\$(CC)' ejercicio1/Makefile"

# ── Ejercicio 2: Makefile con Flex ────────────────
check E2.1 "make genera el ejecutable" 5 \
  bash -c 'cd ejercicio2 && make -s && test -f scanner2'

check E2.2 "Reconoce numero 42" 5 \
  bash -c "cd ejercicio2 && make -s && echo '42' | ./scanner2 | grep -q 'Numero: 42'"

check E2.3 "Reconoce numero 7" 5 \
  bash -c "cd ejercicio2 && make -s && echo '7' | ./scanner2 | grep -q 'Numero: 7'"

check E2.4 "make clean elimina los archivos generados" 5 \
  bash -c 'cd ejercicio2 && make -s && make clean -s && ! test -f scanner2 && ! test -f lex.yy.c'

check E2.5 "Makefile invoca flex" 5 \
  bash -c "grep -q 'flex' ejercicio2/Makefile"

# ── Ejercicio 3: Makefile con Flex + Bison ────────
check E3.1 "make genera el ejecutable" 5 \
  bash -c 'cd ejercicio3 && make -s && test -f calc3'

check E3.2 "Calcula 3 + 4 = 7" 5 \
  bash -c "cd ejercicio3 && make -s && printf '3 + 4\n' | ./calc3 | grep -q '= 7'"

check E3.3 "Calcula 10 - 3 = 7" 5 \
  bash -c "cd ejercicio3 && make -s && printf '10 - 3\n' | ./calc3 | grep -q '= 7'"

check E3.4 "Calcula 2 * 5 = 10" 5 \
  bash -c "cd ejercicio3 && make -s && printf '2 * 5\n' | ./calc3 | grep -q '= 10'"

check E3.5 "Makefile invoca bison" 5 \
  bash -c "grep -q 'bison' ejercicio3/Makefile"

# ── Ejercicio 4: Makefile avanzado ────────────────
check E4.1 "make genera el ejecutable" 5 \
  bash -c 'cd ejercicio4 && make -s && test -f programa'

check E4.2 "Calcula Suma: 8" 5 \
  bash -c "cd ejercicio4 && make -s && echo '5 3' | ./programa | grep -q 'Suma: 8'"

check E4.3 "Makefile usa regla de patron %.o" 5 \
  bash -c "grep -q '%.o' ejercicio4/Makefile"

# ── Preguntas de reflexión ─────────────────────────
check P1 "Segunda ejecucion sin cambios no recompila" 4 \
  bash -c "grep -qE '^P1=NO_RECOMPILA$' README.md"

check P2 "clean no genera un archivo" 3 \
  bash -c "grep -qE '^P2=NO$' README.md"

check P3 "Para que sirve .PHONY" 3 \
  bash -c "grep -qE '^P3=PARA_EVITAR_CONFLICTOS_DE_NOMBRES$' README.md"

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
