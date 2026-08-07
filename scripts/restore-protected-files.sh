#!/usr/bin/env bash
set -euo pipefail

SUBMISSION_ROOT="${SUBMISSION_ROOT:-$PWD}"
CANONICAL_ROOT="${CANONICAL_ROOT:-$SUBMISSION_ROOT/.grading}"
OWNER_ACTOR="${OWNER_ACTOR:-santiagoferreiros}"
RESTORE_PUSH="${RESTORE_PUSH:-false}"
MANIFEST_NAME=".grading-protected"
CANONICAL_SHA="$(git -C "$CANONICAL_ROOT" rev-parse HEAD 2>/dev/null || echo unknown)"
GRADING_VERSION="$(tr -d '\r\n' < "$CANONICAL_ROOT/.grading-version" 2>/dev/null || echo unknown)"

write_output() {
  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    echo "restored=$1" >> "$GITHUB_OUTPUT"
    echo "canonical_sha=$CANONICAL_SHA" >> "$GITHUB_OUTPUT"
    echo "grading_version=$GRADING_VERSION" >> "$GITHUB_OUTPUT"
  fi
}

if [[ "${GITHUB_ACTOR:-}" == "$OWNER_ACTOR" ]]; then
  echo "El push pertenece al owner ($OWNER_ACTOR); no se restaura infraestructura."
  write_output false
  exit 0
fi

if [[ ! -d "$SUBMISSION_ROOT/.git" ]]; then
  echo "No se encontró un repositorio Git en $SUBMISSION_ROOT" >&2
  exit 66
fi

if [[ ! -f "$CANONICAL_ROOT/$MANIFEST_NAME" ]]; then
  echo "Falta el manifiesto canónico: $MANIFEST_NAME" >&2
  exit 66
fi

protected_paths=()
while IFS= read -r entry || [[ -n "$entry" ]]; do
  if [[ -z "$entry" || "$entry" == \#* ]]; then
    continue
  fi
  if [[ "$entry" == /* || "$entry" == *".."* ]]; then
    echo "Entrada insegura en $MANIFEST_NAME: $entry" >&2
    exit 66
  fi

  if [[ "$entry" == */ ]]; then
    relative="${entry%/}"
    source="$CANONICAL_ROOT/$relative"
    destination="$SUBMISSION_ROOT/$relative"
    if [[ ! -d "$source" ]]; then
      echo "Falta el directorio canónico: $relative" >&2
      exit 66
    fi
    mkdir -p "$destination"
    rsync -a --delete "$source/" "$destination/"
    protected_paths+=("$relative")
    continue
  fi

  matches=()
  while IFS= read -r match; do
    matches+=("$match")
  done < <(compgen -G "$CANONICAL_ROOT/$entry" || true)
  if ((${#matches[@]} == 0)); then
    echo "La entrada del manifiesto no encontró archivos: $entry" >&2
    exit 66
  fi

  for source in "${matches[@]}"; do
    relative="${source#"$CANONICAL_ROOT/"}"
    destination="$SUBMISSION_ROOT/$relative"
    mkdir -p "$(dirname "$destination")"
    rsync -a "$source" "$destination"
    protected_paths+=("$relative")
  done
done < "$CANONICAL_ROOT/$MANIFEST_NAME"

git -C "$SUBMISSION_ROOT" add -A -- "${protected_paths[@]}"

if git -C "$SUBMISSION_ROOT" diff --cached --quiet; then
  echo "La infraestructura docente coincide con la versión canónica."
  write_output false
  exit 0
fi

echo "Se detectaron cambios en infraestructura docente; fueron restaurados:"
git -C "$SUBMISSION_ROOT" diff --cached --name-status
write_output true

if [[ "$RESTORE_PUSH" != "true" ]]; then
  echo "Restauración preparada localmente; no se creó ni publicó un commit."
  exit 0
fi

git -C "$SUBMISSION_ROOT" config user.name "github-actions[bot]"
git -C "$SUBMISSION_ROOT" config user.email "41898282+github-actions[bot]@users.noreply.github.com"
git -C "$SUBMISSION_ROOT" commit -m "chore: restaurar infraestructura docente (${CANONICAL_SHA:0:12}) [skip ci]"
git -C "$SUBMISSION_ROOT" push origin "HEAD:${GITHUB_REF_NAME}"
