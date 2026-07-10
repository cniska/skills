#!/usr/bin/env bash
# Behavioral evals: run a skill headless via `claude -p`, grade the transcript,
# gate on pass-rate regression. Dev-only, makes real API calls. See README.md.
# Scenario files (sourced) provide skill/task/det_*/sem_* etc:
# shellcheck disable=SC1090,SC2154

EVALS_DIR="$(cd "$(dirname "$0")" && pwd)"
BASELINE_FILE="$EVALS_DIR/baseline-results.json"

opt_baseline=0 opt_update=0 opt_yes=0 opt_skill="" opt_k=""
for a in "$@"; do
  case "$a" in
    --baseline) opt_baseline=1 ;;
    --update-baseline) opt_update=1 ;;
    --yes | -y) opt_yes=1 ;;
    --skill=*) opt_skill="${a#--skill=}" ;;
    --k=*) opt_k="${a#--k=}" ;;
  esac
done

# The single point of API access. skills=0 disables all skills (the baseline arm).
# Tests override this with a stub, so the whole harness runs offline.
claude_run() { # prompt skills
  local extra=()
  [ "$2" = 0 ] && extra=(--disable-slash-commands)
  claude -p "$1" --output-format json "${extra[@]}" | jq -r '.result // ""'
}

# Blinded per-assertion judge -> "pass"/"fail". A pass whose evidence isn't a
# verbatim substring of the output is rejected (guards hallucinated evidence).
judge() { # transcript assertion
  local raw verdict quote
  raw="$(claude_run "Grade the output against ONE assertion. Judge only this assertion.

ASSERTION: $2

Reply with ONLY: {\"verdict\":\"pass\"|\"fail\",\"evidence_quote\":\"<verbatim span, or empty>\"}

OUTPUT FOLLOWS:
$1" 0)"
  verdict="$(printf '%s' "$raw" | jq -r '.verdict // "fail"' 2>/dev/null || echo fail)"
  quote="$(printf '%s' "$raw" | jq -r '.evidence_quote // ""' 2>/dev/null || echo "")"
  if [ "$verdict" = pass ] && { [ -z "$quote" ] || [[ "$1" == *"$quote"* ]]; }; then
    echo pass
  else
    echo fail
  fi
}

det_check() { # transcript regex expect(present|absent)
  local found=0
  printf '%s' "$1" | grep -Eq -- "$2" && found=1
  if { [ "$3" = present ] && [ "$found" = 1 ]; } || { [ "$3" = absent ] && [ "$found" = 0 ]; }; then
    echo pass
  else
    echo fail
  fi
}

# Runs one arm k times and sets det_rate[]/sem_rate[] (percent, parallel to the
# scenario's det_id[]/sem_id[]). Reads the scenario arrays from the global scope.
run_arm() { # prompt skills k
  local prompt="$1" skills="$2" k="$3" t i transcript
  local dc=() sc=()
  for i in "${!det_id[@]}"; do dc[i]=0; done
  for i in "${!sem_id[@]}"; do sc[i]=0; done
  for ((t = 0; t < k; t++)); do
    transcript="$(claude_run "$prompt" "$skills")"
    for i in "${!det_id[@]}"; do
      [ "$(det_check "$transcript" "${det_re[i]}" "${det_expect[i]}")" = pass ] && dc[i]=$((dc[i] + 1))
    done
    for i in "${!sem_id[@]}"; do
      [ "$(judge "$transcript" "${sem_assertion[i]}")" = "${sem_expect[i]}" ] && sc[i]=$((sc[i] + 1))
    done
  done
  det_rate=() sem_rate=()
  for i in "${!det_id[@]}"; do det_rate[i]=$((dc[i] * 100 / k)); done
  for i in "${!sem_id[@]}"; do sem_rate[i]=$((sc[i] * 100 / k)); done
}

rate_of() { # id -> percent from the last run_arm
  local i
  for i in "${!det_id[@]}"; do [ "${det_id[i]}" = "$1" ] && { echo "${det_rate[i]}"; return; }; done
  for i in "${!sem_id[@]}"; do [ "${sem_id[i]}" = "$1" ] && { echo "${sem_rate[i]}"; return; }; done
  echo 0
}

main() {
  set -uo pipefail
  local scns=() f
  while IFS= read -r f; do
    [ -n "$opt_skill" ] && [ "$(basename "$(dirname "$f")")" != "$opt_skill" ] && continue
    scns+=("$f")
  done < <(find "$EVALS_DIR" -mindepth 2 -name '*.sh' | sort)
  [ "${#scns[@]}" -eq 0 ] && {
    echo "no scenarios found" >&2
    exit 1
  }

  local arms=1
  [ "$opt_baseline" = 1 ] && arms=2
  local est=0 sk sn
  for f in "${scns[@]}"; do
    read -r sk sn < <(
      set +u
      unset sem_id
      k=""
      source "$f"
      echo "${opt_k:-${k:-3}} ${#sem_id[@]}"
    )
    est=$((est + sk * (1 + sn) * arms))
  done

  if [ "$opt_yes" != 1 ]; then
    [ -t 0 ] || {
      echo "Refusing to run non-interactively without --yes — this makes real API calls." >&2
      exit 1
    }
    local ans
    read -r -p "~$est real \`claude -p\` calls across ${#scns[@]} scenario(s). Continue? [y/N] " ans
    case "$ans" in
      y | Y | yes | Yes) ;;
      *)
        echo "aborted."
        exit 0
        ;;
    esac
  fi

  local ver regressed=0 update_lines=()
  ver="$(claude --version 2>/dev/null | head -1)"

  for f in "${scns[@]}"; do
    unset det_id det_re det_expect sem_id sem_assertion sem_expect baseline_must_fail
    source "$f"
    local kk="${opt_k:-${k:-3}}" name key fx
    name="$(basename "$f" .sh)"
    key="$skill/$name"
    fx="$(cat "$(dirname "$f")/$fixture")"
    echo
    echo "=== $key (k=$kk, $ver) ==="
    run_arm "$invoke

$task

$fx" 1 "$kk"

    local all_id=() all_pct=() i id pct base tag reg
    for i in "${!det_id[@]}"; do
      all_id+=("${det_id[i]}")
      all_pct+=("${det_rate[i]}")
    done
    for i in "${!sem_id[@]}"; do
      all_id+=("${sem_id[i]}")
      all_pct+=("${sem_rate[i]}")
    done
    for i in "${!all_id[@]}"; do
      id="${all_id[i]}"
      pct="${all_pct[i]}"
      base="$(jq -r --arg k "$key" --arg id "$id" '.[$k][$id] // empty' "$BASELINE_FILE" 2>/dev/null || true)"
      tag="" reg=""
      if [ -n "$base" ]; then
        tag=" (was ${base}%)"
        [ "$pct" -lt "$base" ] && {
          reg="  REGRESSION"
          regressed=1
        }
      fi
      printf '  %3d%%  %s%s%s\n' "$pct" "$id" "$tag" "$reg"
      update_lines+=("$key"$'\t'"$id"$'\t'"$pct")
    done

    if [ "$opt_baseline" = 1 ]; then
      run_arm "$task

$fx" 0 "$kk"
      echo "  no-skill baseline (must fail these to discriminate):"
      local mf r w
      for mf in ${baseline_must_fail[@]+"${baseline_must_fail[@]}"}; do
        r="$(rate_of "$mf")"
        w=""
        [ "$r" -gt 0 ] && w="  WEAK"
        printf '     %s: %d%%%s\n' "$mf" "$r" "$w"
      done
    fi
  done

  if [ "$opt_update" = 1 ]; then
    printf '%s\n' "${update_lines[@]}" |
      jq -Rn '[inputs | split("\t") | {k: .[0], id: .[1], pct: (.[2] | tonumber)}]
              | reduce .[] as $r ({}; .[$r.k][$r.id] = $r.pct)' > "$BASELINE_FILE"
    echo
    echo "wrote $BASELINE_FILE"
  fi

  echo
  if [ "$regressed" = 1 ]; then
    echo "RESULT: regression"
    exit 1
  fi
  echo "RESULT: ok"
}

# Run only when executed, not when sourced (so tests can drive the functions).
if ! (return 0 2> /dev/null); then main "$@"; fi
