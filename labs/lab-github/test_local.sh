#!/usr/bin/env bash
# test_local.sh — Verificación local del laboratorio
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

skip() {
  local id="$1" desc="$2" pts="$3"
  echo -e "${YELLOW}⏭  $id. $desc — requiere GitHub (verificá en Actions)${RESET}"
}

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Verificación local del laboratorio"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── C1. Compilación ────────────────────────────────
check C1 "Proyecto compila" 4 \
  bash -c 'make clean -s && make -s'

# ── C2–C3. Implementación de multiplicar ───────────
check C2 "multiplicar implementada" 4 \
  bash -c '! grep -q "TODO" operaciones.c'

check C3 "multiplicar devuelve resultado correcto" 8 \
  bash -c 'make -s && ./calculadora | grep -q "3 \* 5    = 15"'

# ── C4–C5. Historial de commits ────────────────────
check C4 "Commit 'wip: experimento roto' existe" 8 \
  bash -c "git log --all --format='%s' | grep -qF 'wip: experimento roto'"

check C5 "Revert del experimento existe" 8 \
  bash -c "git log --all --format='%s' | grep -q '^Revert'"

# ── C6–C7. Calidad del código ──────────────────────
check C6 "Sin conflict markers en operaciones.c" 8 \
  bash -c "! grep -qE '^(<<<<<<<|=======|>>>>>>>)' operaciones.c"

check C7 "esPar funciona correctamente" 8 \
  bash -c 'make -s && ./calculadora | grep -q "4 es par = 1" && ./calculadora | grep -q "7 es par = 0"'

# ── C8. Mensajes de commit ─────────────────────────
check C8 "Ningún mensaje de commit vacío o muy corto" 4 \
  bash -c "! git log --format='%s' | grep -qE '^.{0,4}\$'"

# ── Detectar gh CLI ───────────────────────────────
GH_OK=false
if command -v gh &>/dev/null && gh auth status &>/dev/null 2>&1; then
  GH_OK=true
fi

# ── C9. Branch feature/mi-funcion ─────────────────
# Igual que el workflow: fetch primero para ver branches remotas ya mergeadas
git fetch --all --quiet 2>/dev/null || true
check C9 "Branch feature/mi-funcion fue creada" 4 \
  bash -c "git branch -a | grep -q 'feature/mi-funcion'"

# ── C10. PR mergeado ──────────────────────────────
if $GH_OK; then
  check C10 "PR de feature/mi-funcion a main mergeado" 4 \
    bash -c "gh pr list --state merged --base main --json headRefName \
      --jq '.[].headRefName' | grep -q 'feature/mi-funcion'"
else
  skip C10 "PR de feature/mi-funcion a main mergeado" 4
fi

# ── C11. Branch sugerencia/* ──────────────────────
check C11 "Branch sugerencia/* fue creada" 4 \
  bash -c "git branch -a | grep -q 'sugerencia/'"

# ── C12–C14. PRs y reviews ────────────────────────
if $GH_OK; then
  check C12 "PR de sugerencia/* mergeado" 4 \
    bash -c "gh pr list --state merged --base main --json headRefName \
      --jq '.[].headRefName' | grep -q 'sugerencia/'"

  check C13 "PR de sugerencia/* tiene al menos un review" 4 \
    bash -c 'PR=$(gh pr list --state merged --base main \
      --json number,headRefName \
      --jq '"'"'.[] | select(.headRefName | startswith("sugerencia/")) | .number'"'"' | head -1)
      [ -n "$PR" ] && [ "$(gh pr view "$PR" --json reviews --jq '"'"'.reviews | length'"'"')" -gt 0 ]'

  check C14 "PR de sugerencia/* aprobado por otro usuario" 7 \
    bash -c 'PR=$(gh pr list --state merged --base main \
      --json number,headRefName \
      --jq '"'"'.[] | select(.headRefName | startswith("sugerencia/")) | .number'"'"' | head -1)
      [ -n "$PR" ] && [ "$(gh pr view "$PR" --json reviews \
        --jq '"'"'[.reviews[] | select(.state == "APPROVED")] | length'"'"')" -gt 0 ]'
else
  skip C12 "PR de sugerencia/* mergeado" 4
  skip C13 "PR de sugerencia/* tiene al menos un review" 4
  skip C14 "PR de sugerencia/* aprobado por otro usuario" 7
fi

# ── C15–C21. Preguntas conceptuales ───────────────
check C15 "P1: concepto de branches" 3 \
  bash -c "grep -q 'RESPUESTA_P1=b' README.md"

check C16 "P2: flujo de review" 3 \
  bash -c "grep -q 'RESPUESTA_P2=b' README.md"

check C17 "P3: revert vs reset" 3 \
  bash -c "grep -q 'RESPUESTA_P3=c' README.md"

check C18 "P4: implementaciones de esPar" 3 \
  bash -c "grep -q 'RESPUESTA_P4=b' README.md"

check C19 "P5: commits atomicos" 3 \
  bash -c "grep -q 'RESPUESTA_P5=c' README.md"

check C20 "P6: fetch vs pull" 3 \
  bash -c "grep -q 'RESPUESTA_P6=b' README.md"

check C21 "P7: descripcion de PR" 3 \
  bash -c "grep -q 'RESPUESTA_P7=c' README.md"

# ── Resumen ────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if $GH_OK; then
  echo -e "  Puntaje local: ${SCORE} / 100"
else
  echo -e "  Puntaje local: ${SCORE} / 81 pts verificables"
  echo -e "  (C10, C12–C14 = 19 pts requieren autenticación con GitHub)"
fi
echo "  ✅ $PASS   ❌ $FAIL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ! $GH_OK; then
  echo ""
  echo "  Para verificar los checks de PRs localmente,"
  echo "  instalá gh CLI y autenticáte una sola vez:"
  echo ""
  echo "    # macOS:  brew install gh"
  echo "    # Linux:  https://cli.github.com"
  echo "    gh auth login"
  echo ""
  echo "  Después volvé a correr make test."
fi
echo ""

MIN_SCORE="${MIN_SCORE:-60}"
if ((SCORE < MIN_SCORE)); then
  echo -e "${RED}Puntaje insuficiente: $SCORE / 100 (mínimo $MIN_SCORE).${RESET}"
  exit 1
fi
