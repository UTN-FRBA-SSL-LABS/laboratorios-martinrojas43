#!/usr/bin/env bash
set -euo pipefail

GRADING_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUBMISSION_ROOT="${SUBMISSION_ROOT:-$GRADING_ROOT}"
LAB="${1:-}"
MIN_SCORE="${MIN_SCORE:-60}"
GRADE_DIR="${GRADE_DIR:-$SUBMISSION_ROOT/calificaciones}"

usage() {
  echo "Uso: $0 <laboratorio>"
  echo ""
  echo "Laboratorios disponibles:"
  echo "  lab-github"
  echo "  lab-compilacion-c"
  echo "  lab-string"
  echo "  laboratorio-testing-c"
  echo "  lab-make"
  echo "  lab-flex"
  echo "  lab-bison"
}

case "$LAB" in
  lab-github|lab-compilacion-c|lab-string|laboratorio-testing-c|lab-make|lab-flex|lab-bison)
    ;;
  *)
    usage >&2
    exit 64
    ;;
esac

if ! [[ "$MIN_SCORE" =~ ^[0-9]+$ ]] || ((MIN_SCORE > 100)); then
  echo "MIN_SCORE debe ser un entero entre 0 y 100." >&2
  exit 64
fi

mkdir -p "$GRADE_DIR"
LOG_FILE="$GRADE_DIR/$LAB.log"
JSON_FILE="$GRADE_DIR/$LAB.json"
MD_FILE="$GRADE_DIR/$LAB.md"

set +e
(
  cd "$SUBMISSION_ROOT/labs/$LAB"
  MIN_SCORE="$MIN_SCORE" bash "$GRADING_ROOT/labs/$LAB/test_local.sh"
) 2>&1 | tee "$LOG_FILE"
TEST_STATUS=${PIPESTATUS[0]}
set -e

SCORE_LINE="$(
  LC_ALL=C sed $'s/\033\\[[0-9;]*m//g' "$LOG_FILE" \
    | sed -nE 's/.*Puntaje local: ([0-9]+) \/ ([0-9]+).*/\1 \2/p' \
    | tail -n 1
)"

if [[ -z "$SCORE_LINE" ]]; then
  echo "No se pudo leer el puntaje producido por $LAB." >&2
  SCORE=0
  MAX_SCORE=100
  TEST_STATUS=2
else
  read -r SCORE MAX_SCORE <<< "$SCORE_LINE"
fi

if ((TEST_STATUS == 0 && SCORE >= MIN_SCORE)); then
  PASSED=true
  STATUS="aprobado"
else
  PASSED=false
  STATUS="desaprobado"
fi

if ((MAX_SCORE == 100)); then
  COMPLETE=true
else
  COMPLETE=false
fi

json_escape() {
  local value="$1"
  value=${value//\\/\\\\}
  value=${value//\"/\\\"}
  value=${value//$'\n'/\\n}
  value=${value//$'\r'/\\r}
  value=${value//$'\t'/\\t}
  printf '%s' "$value"
}

REPOSITORY="${GITHUB_REPOSITORY:-local}"
COMMIT_SHA="${GRADE_COMMIT_SHA:-${GITHUB_SHA:-$(git -C "$SUBMISSION_ROOT" rev-parse HEAD 2>/dev/null || echo unknown)}}"
REF_NAME="${GITHUB_REF_NAME:-$(git -C "$SUBMISSION_ROOT" branch --show-current 2>/dev/null || echo local)}"
ACTOR="${GITHUB_ACTOR:-${USER:-local}}"
RUN_ID="${GITHUB_RUN_ID:-}"
RUN_ATTEMPT="${GITHUB_RUN_ATTEMPT:-}"
WORKFLOW="${GITHUB_WORKFLOW:-local}"
GRADER_REPOSITORY="${GRADER_REPOSITORY:-UTN-FRBA-SSL-LABS/laboratorios}"
GRADER_COMMIT_SHA="$(git -C "$GRADING_ROOT" rev-parse HEAD 2>/dev/null || echo unknown)"
TIMESTAMP="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"

{
  printf '{\n'
  printf '  "schema_version": 1,\n'
  printf '  "lab": "%s",\n' "$(json_escape "$LAB")"
  printf '  "score": %d,\n' "$SCORE"
  printf '  "max_score": %d,\n' "$MAX_SCORE"
  printf '  "minimum_score": %d,\n' "$MIN_SCORE"
  printf '  "passed": %s,\n' "$PASSED"
  printf '  "complete": %s,\n' "$COMPLETE"
  printf '  "status": "%s",\n' "$STATUS"
  printf '  "repository": "%s",\n' "$(json_escape "$REPOSITORY")"
  printf '  "commit_sha": "%s",\n' "$(json_escape "$COMMIT_SHA")"
  printf '  "ref": "%s",\n' "$(json_escape "$REF_NAME")"
  printf '  "actor": "%s",\n' "$(json_escape "$ACTOR")"
  printf '  "run_id": "%s",\n' "$(json_escape "$RUN_ID")"
  printf '  "run_attempt": "%s",\n' "$(json_escape "$RUN_ATTEMPT")"
  printf '  "workflow": "%s",\n' "$(json_escape "$WORKFLOW")"
  printf '  "grader_repository": "%s",\n' "$(json_escape "$GRADER_REPOSITORY")"
  printf '  "grader_commit_sha": "%s",\n' "$(json_escape "$GRADER_COMMIT_SHA")"
  printf '  "generated_at": "%s"\n' "$TIMESTAMP"
  printf '}\n'
} > "$JSON_FILE"

{
  echo "# Calificación · $LAB"
  echo ""
  echo "| Campo | Valor |"
  echo "| --- | --- |"
  echo "| Nota | **$SCORE / $MAX_SCORE** |"
  echo "| Estado | **$STATUS** |"
  echo "| Puntaje mínimo | $MIN_SCORE |"
  echo "| Repositorio | \`$REPOSITORY\` |"
  echo "| Commit | \`$COMMIT_SHA\` |"
  echo "| Rama | \`$REF_NAME\` |"
  echo "| Usuario | \`$ACTOR\` |"
  echo "| Grader oficial | \`$GRADER_REPOSITORY@$GRADER_COMMIT_SHA\` |"
  echo "| Generada | $TIMESTAMP |"
  if [[ "$COMPLETE" == "false" ]]; then
    echo ""
    echo "> Nota local parcial: hay checks remotos que requieren autenticación con GitHub."
  fi
} > "$MD_FILE"

echo ""
echo "Calificación guardada en: $JSON_FILE"
echo "Resumen guardado en: $MD_FILE"
echo "Resultado: $SCORE / $MAX_SCORE — $STATUS"

if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
  {
    echo "score=$SCORE"
    echo "max_score=$MAX_SCORE"
    echo "passed=$PASSED"
    echo "status=$STATUS"
    echo "json_file=$JSON_FILE"
    echo "markdown_file=$MD_FILE"
    echo "log_file=$LOG_FILE"
  } >> "$GITHUB_OUTPUT"
fi

exit "$TEST_STATUS"
