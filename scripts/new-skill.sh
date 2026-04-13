#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  cat >&2 <<'USAGE'
Usage: ./scripts/new-skill.sh <kebab-case-name> <imperative description>

Example:
  ./scripts/new-skill.sh api-review "Review API compatibility and contract drift. Use when changing public interfaces."
USAGE
}

if [[ $# -lt 2 ]]; then
  usage
  exit 2
fi

skill_name="$1"
shift
skill_description="$*"

if [[ ! "$skill_name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
  echo "error: skill name must be kebab-case: $skill_name" >&2
  exit 1
fi

skill_dir="$ROOT_DIR/$skill_name"
skill_file="$skill_dir/SKILL.md"

if [[ -e "$skill_dir" ]]; then
  echo "error: skill directory already exists: $skill_dir" >&2
  exit 1
fi

title="$(echo "$skill_name" | tr '-' ' ' | awk '{for (i=1;i<=NF;i++) { $i=toupper(substr($i,1,1)) substr($i,2) }}1')"

mkdir -p "$skill_dir"
cat > "$skill_file" <<EOF_SKILL
---
name: $skill_name
description: $skill_description
---

# $title

State the intent in one short paragraph. Keep it direct and specific.

## Workflow

1. Define scope and success criteria.
2. Read the relevant code and conventions before editing.
3. Execute one focused change at a time.
4. Verify with concrete evidence (tests, checks, or output).
5. Summarize what changed and what is intentionally out of scope.

## See also

- `<related-skill>`
- `references/<relevant-checklist>.md`

## Red flags

- Skipping verification
- Expanding scope mid-task
- Advice without concrete evidence
EOF_SKILL

echo "Created $skill_file"
echo "Next: edit the content, then run ./scripts/validate.sh"
