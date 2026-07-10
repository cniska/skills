# shellcheck shell=bash
# Consumed by run.sh after sourcing:
# shellcheck disable=SC2034
#
# Scenario: the comment claims an inclusive threshold ("reaches") but the code
# uses strict `>`, so an order exactly on the threshold is wrongly excluded. A
# bare model finds the bug too — so the discriminative assertions are the skill's
# CONTRACT (severity label, triggering-input shape), not the bug-finding itself.
skill="correctness-review"
invoke="/correctness-review"
task="Review the following diff for correctness bugs."
fixture="fixtures/boundary-discount.diff"
k=5

# Deterministic checks (grep -E over the transcript; graded free, no LLM).
det_id=(severity-label contract-shape)
det_re=('\*\*(Critical|Fix|Consider|Nit)\*\*' 'triggering input|fix direction|→')
det_expect=(present present)

# Semantic checks (blinded LLM judge).
sem_id=(names-trigger no-style-as-bug)
sem_assertion=(
  "The review names a CONCRETE triggering input (a specific value or scenario) AND states the wrong result it produces."
  "The review does NOT report naming, comments, formatting, or code style as a correctness bug. Mentioning them as non-issues is acceptable."
)
sem_expect=(pass pass)

# The no-skill baseline must FAIL these, or they test the model, not the skill.
baseline_must_fail=(severity-label contract-shape)
