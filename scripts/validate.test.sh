#!/usr/bin/env bash
# Unit tests for validate.sh — runs the real validator against fixture skills in
# a throwaway harness (a copy of validate.sh + its own skills/ tree), so no repo
# skills are touched. Run: ./validate.test.sh  (exit 0 = all pass, 1 = failures)
set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
VALIDATE="$HERE/validate.sh"
TMPROOT="$(mktemp -d)"
trap 'rm -rf "$TMPROOT"' EXIT

pass=0
fail=0
assert() { # desc got want
  if [ "$2" = "$3" ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    printf 'FAIL %s\n  want: [%s]\n  got:  [%s]\n' "$1" "$3" "$2"
  fi
}

V_OUT=""
V_CODE=0
# harness -> path to a fresh dir with validate.sh copied in and an empty skills/
harness() {
  local d
  d="$(mktemp -d "$TMPROOT/case-XXXXXX")"
  mkdir -p "$d/scripts" "$d/skills/demo"
  cp "$VALIDATE" "$d/scripts/validate.sh"
  printf '%s\n' "$d"
}
runv() { # harness_dir
  V_OUT="$(bash "$1/scripts/validate.sh" 2>&1)"
  V_CODE=$?
}
has() { # substring -> yes|no (searches last V_OUT)
  if printf '%s\n' "$V_OUT" | grep -qF -- "$1"; then echo yes; else echo no; fi
}

# 1. well-formed skill passes
d="$(harness)"
cat > "$d/skills/demo/SKILL.md" <<'EOF'
---
name: demo
description: Review a change for problems. Use when reviewing a diff.
---

# Demo

One line of intent.

## Red flags

- A failure mode
EOF
runv "$d"
assert "well-formed: exit 0"     "$V_CODE" 0
assert "well-formed: reports OK" "$(has 'OK: skill validation passed')" yes

# 2. missing SKILL.md
d="$(harness)"
runv "$d"
assert "missing SKILL.md: exit 1"  "$V_CODE" 1
assert "missing SKILL.md: message" "$(has 'missing SKILL.md')" yes

# 3. name does not match directory
d="$(harness)"
cat > "$d/skills/demo/SKILL.md" <<'EOF'
---
name: other
description: Review a change. Use when reviewing.
---

# Demo

## Red flags

- x
EOF
runv "$d"
assert "name mismatch: exit 1"  "$V_CODE" 1
assert "name mismatch: message" "$(has 'must match directory')" yes

# 4. missing Red flags section
d="$(harness)"
cat > "$d/skills/demo/SKILL.md" <<'EOF'
---
name: demo
description: Review a change. Use when reviewing.
---

# Demo

No red flags here.
EOF
runv "$d"
assert "no red flags: exit 1"  "$V_CODE" 1
assert "no red flags: message" "$(has "missing '## Red flags'")" yes

# 5. Anti-patterns heading rejected
d="$(harness)"
cat > "$d/skills/demo/SKILL.md" <<'EOF'
---
name: demo
description: Review a change. Use when reviewing.
---

# Demo

## Anti-patterns

- x
EOF
runv "$d"
assert "anti-patterns: exit 1"  "$V_CODE" 1
assert "anti-patterns: message" "$(has "use '## Red flags' instead")" yes

# 6. non-imperative description
d="$(harness)"
cat > "$d/skills/demo/SKILL.md" <<'EOF'
---
name: demo
description: Quickly patches things. Use when needed.
---

# Demo

## Red flags

- x
EOF
runv "$d"
assert "non-imperative: exit 1"  "$V_CODE" 1
assert "non-imperative: message" "$(has 'imperative verb')" yes

# 7. stale references/ link
d="$(harness)"
cat > "$d/skills/demo/SKILL.md" <<'EOF'
---
name: demo
description: Review a change. Use when reviewing.
---

# Demo

See references/security-checklist.md for more.

## Red flags

- x
EOF
runv "$d"
assert "references link: exit 1"  "$V_CODE" 1
assert "references link: message" "$(has "stale 'references/' link")" yes

# 8. missing frontmatter
d="$(harness)"
cat > "$d/skills/demo/SKILL.md" <<'EOF'
# Demo

No frontmatter at all.

## Red flags

- x
EOF
runv "$d"
assert "no frontmatter: exit 1"  "$V_CODE" 1
assert "no frontmatter: message" "$(has 'missing YAML frontmatter')" yes

printf '\n%d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
