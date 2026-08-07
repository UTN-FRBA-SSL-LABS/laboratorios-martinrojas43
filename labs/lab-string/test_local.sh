#!/usr/bin/env bash
# test_local.sh — Verificación local del laboratorio String
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
echo "  Verificación local del laboratorio String"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Compilación ────────────────────────────────────
check C1 "String.o compila" 3 \
  bash -c "$GCC -c String.c -o String.o"

check C2 "StringTest compila" 3 \
  bash -c "$GCC -c String.c -o String.o && $GCC StringTest.c String.o -o StringTest"

check C3 "Conversion.o compila" 3 \
  bash -c "$GCC -c String.c -o String.o && $GCC -c Conversion.c -o Conversion.o"

check C4 "ConversionTest compila" 3 \
  bash -c "$GCC -c String.c -o String.o && $GCC -c Conversion.c -o Conversion.o && \
    $GCC ConversionTest.c Conversion.o String.o -o ConversionTest"

check C5 "Todos los programas compilan" 3 \
  bash -c "$GCC -c String.c -o String.o && $GCC -c Conversion.c -o Conversion.o && \
    $GCC enlineas.c -o enlineas && \
    $GCC longitudes.c String.o -o longitudes && \
    $GCC mayorlongitud.c String.o -o mayorlongitud && \
    $GCC todosiguales.c String.o -o todosiguales && \
    $GCC suma.c Conversion.o String.o -o suma"

# ── Tests ──────────────────────────────────────────
check T1 "StringTest pasa" 25 \
  bash -c "$GCC -c String.c -o String.o && \
    $GCC StringTest.c String.o -o StringTest && ./StringTest"

check T2 "ConversionTest pasa" 15 \
  bash -c "$GCC -c String.c -o String.o && \
    $GCC -c Conversion.c -o Conversion.o && \
    $GCC ConversionTest.c Conversion.o String.o -o ConversionTest && ./ConversionTest"

# ── Programas ──────────────────────────────────────
check P1 "enlineas: salida correcta" 9 \
  bash -c "$GCC enlineas.c -o enlineas && \
    ./enlineas hola mundo | grep -x 'hola' && \
    ./enlineas hola mundo | grep -x 'mundo'"

check P2 "longitudes: salida correcta" 9 \
  bash -c "$GCC -c String.c -o String.o && \
    $GCC longitudes.c String.o -o longitudes && \
    ./longitudes hola | grep -x '4'"

check P3 "mayorlongitud: salida correcta" 9 \
  bash -c "$GCC -c String.c -o String.o && \
    $GCC mayorlongitud.c String.o -o mayorlongitud && \
    ./mayorlongitud uno largo | grep -x 'largo'"

check P4 "todosiguales: salida correcta" 9 \
  bash -c "$GCC -c String.c -o String.o && \
    $GCC todosiguales.c String.o -o todosiguales && \
    ./todosiguales igual igual | grep -x '1' && \
    ./todosiguales uno dos | grep -x '0'"

check P5 "suma: salida correcta" 9 \
  bash -c "$GCC -c String.c -o String.o && \
    $GCC -c Conversion.c -o Conversion.o && \
    $GCC suma.c Conversion.o String.o -o suma && \
    ./suma 1 2 3 | grep -x '6'"

# ── Archivos con contenido (sin puntaje oficial) ───
echo ""
echo "  — Checks informativos (sin puntaje) —"
check F1 "README.md análisis completado" 0 \
  bash -c "! grep -q '(respuesta)' README.md"

check F2 "README.md incluye la especificación de String" 0 \
  bash -c "grep -q '^### Especificación matemática$' README.md && grep -q 'Contains : String' README.md"

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
