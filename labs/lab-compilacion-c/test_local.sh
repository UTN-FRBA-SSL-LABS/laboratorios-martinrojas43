#!/usr/bin/env bash
# test_local.sh — Verificación local del laboratorio Proceso de Compilación
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
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Verificación local — Proceso de Compilación"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Archivos generados ─────────────────────────────
check T1  "programa.i existe" 2 \
  bash -c "test -f programa.i"

check T2  "No hay #define en programa.i (macros expandidas)" 3 \
  bash -c "test -f programa.i && ! grep -q '^#define' programa.i"

check T3  "VERSION expandido a '1.0' en programa.i" 3 \
  bash -c "grep -q '\"1\.0\"' programa.i"

check T4  "CUADRADO(LIMITE) expandido a ((5) * (5)) en programa.i" 3 \
  bash -c "grep -qF '((5) * (5))' programa.i"

check T5  "Comentarios eliminados de programa.i" 2 \
  bash -c "! grep -q 'Archivo fuente principal' programa.i"

check T6  "programa.i incluye headers completos (>500 lineas)" 2 \
  bash -c 'test $(wc -l < programa.i) -gt 500'

check T7  "programa.s existe" 2 \
  bash -c "test -f programa.s"

check T8  "sumar definida en programa.s" 3 \
  bash -c "grep -qE '^(sumar|_sumar):' programa.s"

check T9  "area_circulo llamada pero no definida en programa.s" 4 \
  bash -c "grep -q 'area_circulo' programa.s && ! grep -qE '^(area_circulo|_area_circulo):' programa.s"

check T10 "nm_programa_o.txt tiene area_circulo como U (indefinido)" 4 \
  bash -c "test -f salidas/nm_programa_o.txt && grep -qE 'U.*(area_circulo|_area_circulo)' salidas/nm_programa_o.txt"

check T11 "nm_ejecutable.txt tiene area_circulo como T (resuelto)" 4 \
  bash -c "test -f salidas/nm_ejecutable.txt && grep -qE 'T.*(area_circulo|_area_circulo)' salidas/nm_ejecutable.txt"

check T12 "salida_debug.txt contiene [DEBUG]" 3 \
  bash -c "test -f salidas/salida_debug.txt && grep -q '\[DEBUG\]' salidas/salida_debug.txt"

check T13 "Los fuentes compilan y producen factorial(5)=120" 5 \
  bash -c "gcc -Wall programa.c matematica.c -o programa_ci && ./programa_ci | grep -q '120'"

check T14 "programa.o NO esta commiteado" 2 \
  bash -c "! test -f programa.o"

# ── Respuestas cerradas ────────────────────────────
check R1  "LINEAS_I es un numero de 3 o 4 digitos" 4 \
  bash -c "grep -qE '^LINEAS_I=[0-9]{3,4}$' README.md"

check R2  "CUADRADO_EN_I=NO" 4 \
  bash -c "grep -qiE '^CUADRADO_EN_I=NO$' README.md"

check R3  "NOMBRE_MACRO_VERSION=VERSION" 4 \
  bash -c "grep -qE '^NOMBRE_MACRO_VERSION=VERSION$' README.md"

check R4  "COMENTARIOS_EN_I=NO" 4 \
  bash -c "grep -qiE '^COMENTARIOS_EN_I=NO$' README.md"

check R5  "DEBUG_ACTIVA_CODIGO=SI" 5 \
  bash -c "grep -qiE '^DEBUG_ACTIVA_CODIGO=SI$' README.md"

check R6  "AREA_EN_S=LLAMADA" 5 \
  bash -c "grep -qiE '^AREA_EN_S=LLAMADA$' README.md"

check R7  "LLAMADAS_EN_S=SI" 4 \
  bash -c "grep -qiE '^LLAMADAS_EN_S=SI$' README.md"

check R8  "TIPO_AREA_EN_O=U" 5 \
  bash -c "grep -qE '^TIPO_AREA_EN_O=U$' README.md"

check R9  "ETAPA_QUE_RESUELVE=ENLAZADO" 4 \
  bash -c "grep -qiE '^ETAPA_QUE_RESUELVE=ENLAZADO$' README.md"

check R10 "EJECUTABLE_O=NO" 4 \
  bash -c "grep -qiE '^EJECUTABLE_O=NO$' README.md"

check R11 "TIPO_AREA_ENLAZADO=T" 4 \
  bash -c "grep -qE '^TIPO_AREA_ENLAZADO=T$' README.md"

check R12 "SIMBOLOS_U_FINAL=SI" 5 \
  bash -c "grep -qiE '^SIMBOLOS_U_FINAL=SI$' README.md"

check R13 "FACTORIAL_5=120" 6 \
  bash -c "grep -qE '^FACTORIAL_5=120$' README.md"

# ── Resumen ────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "  Puntaje local: ${SCORE} / 100"
echo "  ✅ $PASS   ❌ $FAIL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

MIN_SCORE="${MIN_SCORE:-60}"
if ((SCORE < MIN_SCORE)); then
  echo -e "${RED}Puntaje insuficiente: $SCORE / 100 (mínimo $MIN_SCORE).${RESET}"
  exit 1
fi
