# Evals

Behavioral tests for the skills. `validate.sh` proves a skill is well-formed; this proves it **works** — that loading it steers an agent to the intended behavior, and that editing the prompt didn't regress it. Bash + `jq`, matching the rest of the repo; the only dependency beyond that is the `claude` CLI.

Dev-only. It makes real `claude -p` calls, so it is **not** a per-commit hook — run it before shipping a skill change, or nightly. It never ships: `npx skills add` copies only `<name>/`, so `evals/` at the repo root is invisible to installs.

## Run

```
make eval                          # all scenarios, treatment arm, gate on regression
make eval ARGS=--baseline          # also run the no-skill arm (discrimination check)
make eval ARGS="--skill=correctness-review --k=3"
make eval ARGS=--update-baseline   # rewrite baseline-results.json from this run
make test                          # run the harness's own unit tests (offline, no API)
```

Before spending anything it prints the estimated number of `claude -p` calls and waits for a `y`. Pass `--yes`/`-y` to skip the prompt in CI; it refuses to run non-interactively without `--yes`, so it can't burn tokens by accident.

## Why it's shaped this way

Three findings from the pilot that authored the first scenario (2026-07-10, `claude-opus-4-8`) drive the design:

- **The baseline arm is not optional.** A frontier model finds a planted bug **with no skill loaded at all** — so "found the bug" tests the model, not the skill. Every scenario lists `baseline_must_fail`: assertions the no-skill arm must fail. If it passes them, the assertion is non-discriminative and proves nothing. For `boundary-discount`, at k=5:

  | Assertion | skill | no-skill baseline |
  |---|---|---|
  | found the bug | 5/5 | 5/5 — not discriminative |
  | `severity-label` | 5/5 | 0/5 |
  | `contract-shape` | 5/5 | 0/5 |

  The skill's value is the **contract** (the canonical severity vocabulary and finding shape the `review` orchestrator aggregates), not the bug-finding. Run `--baseline` when authoring a scenario to confirm discrimination.

- **Grade cheapest-first.** Deterministic `grep -E` checks run first (free, no LLM) — most regressions live here because the skills mandate *structure*, and structure is grep-able. The LLM judge handles only the paraphrase-tolerant residue. In the pilot the deterministic layer graded every discriminative assertion on its own.

- **Trust the judge narrowly.** It's blinded (sees one assertion + the output, not the skill or the expected verdict), returns a structured verdict, and a `pass` whose evidence isn't a verbatim substring of the transcript is rejected — the cheapest guard against hallucinated evidence.

Transcripts are nondeterministic, so each scenario runs `k` times (default 5) and findings are pass *rates*, gated against `baseline-results.json`; a drop is a regression (non-zero exit).

## Adding a scenario

`evals/<skill>/<name>.sh` sets, for the runner to source: `skill`, `invoke`, `task`, `fixture` (a path, staged into the prompt so the agent never sees the scenario spec — keep names neutral so they don't leak the answer), `k`, parallel `det_id/det_re/det_expect` (regex checks), parallel `sem_id/sem_assertion/sem_expect` (judge assertions), and `baseline_must_fail`. See `correctness-review/boundary-discount.sh`. Aim for 5–8 scenarios per skill including a clean-input negative and a style-bait negative; assert *behaviors*, never skill *phrasings*.

**Next skill to add: `handoff`.** Most of its contract is deterministic (section names/order, ≤5 bullets, ~150 words, closing imperative, no report-shape headings). One catch: its fixture is a session transcript (the priciest kind). The workflow is headless-friendly — no confirmation gate, and the handoff is always printed in the reply, so assert against that.
