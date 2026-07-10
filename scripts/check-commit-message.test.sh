#!/usr/bin/env bash
# Unit tests for check-commit-message.sh — pure, no side effects.
# Run: ./check-commit-message.test.sh  (exit 0 = all pass, 1 = failures)
set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
CHECK="$HERE/check-commit-message.sh"

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

# code SUBJECT [BODY] -> exit code of the checker (0 pass, 1 reject, 2 usage)
code() { "$CHECK" "$@" >/dev/null 2>&1; echo "$?"; }

# All allowed types accepted — ci/build/perf were added this cycle, lock them in.
assert "feat accepted"     "$(code 'feat: add thing')"      0
assert "fix accepted"      "$(code 'fix: correct thing')"   0
assert "refactor accepted" "$(code 'refactor: reshape')"    0
assert "docs accepted"     "$(code 'docs: note a thing')"   0
assert "test accepted"     "$(code 'test: cover a case')"   0
assert "chore accepted"    "$(code 'chore: tidy up')"       0
assert "ci accepted"       "$(code 'ci: run bash tests')"   0
assert "build accepted"    "$(code 'build: bundle output')" 0
assert "perf accepted"     "$(code 'perf: speed up loop')"  0

# Scope and breaking marker
assert "scope accepted"      "$(code 'feat(review): add mode')" 0
assert "breaking accepted"   "$(code 'feat!: drop old api')"    0
assert "scope+breaking"      "$(code 'fix(git)!: change flag')" 0

# Rejections
assert "unknown type rejected"  "$(code 'wip: half done')"       1
assert "no type rejected"       "$(code 'just some words')"      1
assert "missing space rejected" "$(code 'feat:no space')"        1
assert "body rejected"          "$(code 'feat: x' 'a body line')" 1
assert "non-ascii rejected"     "$(code 'feat: add café menu')"  1
assert "empty subject is usage" "$(code '')"                     2

# Length boundary: 72 chars ok, 73 too long.
s72="feat: $(printf 'x%.0s' {1..66})"
s73="feat: $(printf 'x%.0s' {1..67})"
assert "72 chars accepted" "${#s72}:$(code "$s72")" "72:0"
assert "73 chars rejected" "${#s73}:$(code "$s73")" "73:1"

printf '\n%d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
