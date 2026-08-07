#!/usr/bin/env bash
# test_local.sh — Verificación local del laboratorio Testing C
# Ejecutá: make test  (o  bash test_local.sh)
set -euo pipefail

PASS=0
FAIL=0
SCORE=0

GCC="gcc -Wall -Wextra -std=c99"

GREEN='\033[0;32m'
RED='\033[0;31m'
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
echo "  Verificación local del laboratorio Testing C"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Compilación ────────────────────────────────────
check 1 "El codigo compila sin errores" 5 \
  bash -c "$GCC src/programa.c src/carrito.c -o programa_ci"

check 2 "test_unitarios compila" 5 \
  bash -c "$GCC tests/test_unitarios.c src/carrito.c -o test_unitarios_ci"

check 3 "test_integracion compila" 5 \
  bash -c "$GCC tests/test_integracion.c src/carrito.c -o test_integracion_ci"

# ── Tests ──────────────────────────────────────────
check 4 "test_unitarios pasa (bugs corregidos)" 15 \
  bash -c "$GCC tests/test_unitarios.c src/carrito.c -o test_unitarios_ci && ./test_unitarios_ci"

check 5 "test_integracion tiene al menos un test y pasa" 10 \
  bash -c "$GCC tests/test_integracion.c src/carrito.c -o test_integracion_ci && ./test_integracion_ci | grep -q '\[OK\]'"

# ── Salida funcional ───────────────────────────────
check 6 "El programa imprime el total correcto (2800)" 10 \
  bash -c "$GCC src/programa.c src/carrito.c -o programa_ci && ./programa_ci | grep -q '2800'"

# ── Archivos de salida ─────────────────────────────
check 7 "salidas/test_unitarios.txt existe" 3 \
  bash -c "test -f salidas/test_unitarios.txt"

check 8 "salidas/test_integracion.txt existe" 3 \
  bash -c "test -f salidas/test_integracion.txt"

# ── Respuestas cerradas ────────────────────────────
check R1 "TOTAL_PROGRAMA=2050" 5 \
  bash -c "grep -qE '^TOTAL_PROGRAMA=2050$' README.md"

check R2 "TEST_PRECIO_UNITARIO_PASA=SI" 5 \
  bash -c "grep -qiE '^TEST_PRECIO_UNITARIO_PASA=SI$' README.md"

check R3 "TEST_TOTAL_CANTIDAD_PASA=NO" 5 \
  bash -c "grep -qiE '^TEST_TOTAL_CANTIDAD_PASA=NO$' README.md"

check R4 "TESTS_UNITARIOS_PASAN=SI" 5 \
  bash -c "grep -qiE '^TESTS_UNITARIOS_PASAN=SI$' README.md"

check R5 "TEST_INTEGRACION_PASA=SI" 5 \
  bash -c "grep -qiE '^TEST_INTEGRACION_PASA=SI$' README.md"

check R6 "BUG_EN_FUNCION_1=carrito_total" 7 \
  bash -c "grep -qiE '^BUG_EN_FUNCION_1=carrito_total$' README.md"

check R7 "BUG_EN_FUNCION_2=carrito_agregar" 7 \
  bash -c "grep -qiE '^BUG_EN_FUNCION_2=carrito_agregar$' README.md"

check R8 "COBERTURA_COMPLETA tiene valor (SI o NO)" 5 \
  bash -c "grep -qiE '^COBERTURA_COMPLETA=(SI|NO)$' README.md"

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
