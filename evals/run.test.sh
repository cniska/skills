#!/usr/bin/env bash
# Unit tests for run.sh — pure bash + jq, no API calls (claude_run is stubbed).
# Run: ./run.test.sh   (exit 0 = all pass, 1 = failures)
set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=./run.sh
source "$HERE/run.sh" # sourced -> main() does not run

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

# det_check: present / absent over a transcript
assert "det present hit" "$(det_check 'x **Critical** y' '\*\*(Critical|Fix)\*\*' present)" pass
assert "det present miss" "$(det_check 'no label here' '\*\*(Critical|Fix)\*\*' present)" fail
assert "det absent hit" "$(det_check 'clean output' 'FORBIDDEN' absent)" pass
assert "det absent miss" "$(det_check 'has FORBIDDEN' 'FORBIDDEN' absent)" fail

# judge: a pass is trusted only if its evidence is a verbatim substring
T='subtotal exactly 100 returns 100 instead of 90'
claude_run() { printf '%s' '{"verdict":"pass","evidence_quote":"exactly 100"}'; }
assert "judge pass, verbatim evidence" "$(judge "$T" a)" pass
claude_run() { printf '%s' '{"verdict":"pass","evidence_quote":"not in transcript"}'; }
assert "judge pass, fabricated evidence -> fail" "$(judge "$T" a)" fail
claude_run() { printf '%s' '{"verdict":"fail","evidence_quote":""}'; }
assert "judge fail verdict" "$(judge "$T" a)" fail
claude_run() { printf '%s' 'not json at all'; }
assert "judge unparseable -> fail" "$(judge "$T" a)" fail

# run_arm: the stub routes judge calls (prompt contains ASSERTION:) vs skill runs.
skill=demo invoke=/demo task=t k=1
det_id=(has-label) det_re=('\*\*Critical\*\*') det_expect=(present)
sem_id=(sem1) sem_assertion=(a) sem_expect=(pass)

claude_run() { case "$1" in *ASSERTION:*) printf '{"verdict":"pass","evidence_quote":"bug"}' ;; *) printf '**Critical** a bug' ;; esac; }
run_arm p 1 3
assert "run_arm det 100%" "${det_rate[0]}" 100
assert "run_arm sem 100%" "${sem_rate[0]}" 100
assert "rate_of by id" "$(rate_of sem1)" 100
assert "rate_of unknown -> 0" "$(rate_of nope)" 0

claude_run() { case "$1" in *ASSERTION:*) printf '{"verdict":"pass","evidence_quote":"bug"}' ;; *) printf 'a bug, but no label' ;; esac; }
run_arm p 1 3
assert "run_arm det 0% when label absent" "${det_rate[0]}" 0

printf '\n%d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
