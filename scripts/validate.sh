#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
status=0

# Allowed first words for imperative descriptions used in this repo.
readonly IMPERATIVE_VERBS='implement|review|debug|deprecate|design|explore|manage|create|run|simplify|drive|ground'

if command -v rg >/dev/null 2>&1; then
  has_red_flags() { rg -q '^## Red flags$' "$1"; }
  has_anti_patterns() { rg -q '^## Anti-patterns$' "$1"; }
else
  has_red_flags() { grep -qE '^## Red flags$' "$1"; }
  has_anti_patterns() { grep -qE '^## Anti-patterns$' "$1"; }
fi

while IFS= read -r -d '' skill_dir; do
  skill_name="$(basename "$skill_dir")"
  skill_file="$skill_dir/SKILL.md"

  if [[ ! -f "$skill_file" ]]; then
    echo "ERROR: missing SKILL.md in $skill_name"
    status=1
    continue
  fi

  frontmatter="$(awk '
    NR==1 && $0=="---" {in_frontmatter=1; next}
    in_frontmatter && $0=="---" {exit}
    in_frontmatter {print}
  ' "$skill_file")"

  if [[ -z "$frontmatter" ]]; then
    echo "ERROR: missing YAML frontmatter in $skill_file"
    status=1
    continue
  fi

  fm_name="$(printf '%s\n' "$frontmatter" | sed -n 's/^name:[[:space:]]*//p' | head -n1)"
  fm_description="$(printf '%s\n' "$frontmatter" | sed -n 's/^description:[[:space:]]*//p' | head -n1)"

  if [[ -z "$fm_name" || -z "$fm_description" ]]; then
    echo "ERROR: frontmatter requires both name and description in $skill_file"
    status=1
  fi

  if [[ "$fm_name" != "$skill_name" ]]; then
    echo "ERROR: frontmatter name '$fm_name' must match directory '$skill_name' in $skill_file"
    status=1
  fi

  first_word="$(printf '%s\n' "$fm_description" | sed -E 's/^[[:space:]]*([[:alpha:]-]+).*$/\1/' | tr '[:upper:]' '[:lower:]')"
  if [[ ! "$first_word" =~ ^($IMPERATIVE_VERBS)$ ]]; then
    echo "ERROR: description should start with an imperative verb in $skill_file"
    echo "  got first word: '$first_word'"
    status=1
  fi

  if ! has_red_flags "$skill_file"; then
    echo "ERROR: missing '## Red flags' section in $skill_file"
    status=1
  fi

  if has_anti_patterns "$skill_file"; then
    echo "ERROR: use '## Red flags' instead of '## Anti-patterns' in $skill_file"
    status=1
  fi

done < <(find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d \
  ! -name '.*' \
  ! -name 'references' \
  ! -name 'scripts' \
  -print0)

if [[ $status -eq 0 ]]; then
  echo "OK: skill validation passed"
fi

exit $status
