---
name: skill-test
description: Test a changed skill against unlike real repos before publishing. Use after materially changing a skill, before pushing it.
---

# Skill test

A skill is an instruction to a model, so the only real test is running it. Reading a changed skill tells you it *reads* well; running it against real projects tells you whether it *holds up*. Dry-run the skill via subagents on real repos, collect their friction reports, and act only on findings that converge.

Diversity beats count: three repos that differ in shape (stack, release model, docs-heaviness, process discipline) expose more than ten that rhyme. A gap that only one shape can reveal — a release with no command, a project with no spec — never shows up on lookalikes.

## Workflow

1. **Pick 2–3 unlike repos.** Choose for difference in the dimension the skill touches — not convenience. If the change affects release handling, pick repos that release differently; if it affects doc structure, pick a docs-heavy and a docs-light one.
2. **Run in test-only mode.** One subagent per repo, in parallel. Each agent reads the changed skill in full, applies it to its repo, and writes output where it can be inspected without committing — uncommitted in the working tree, or a scratch path. Never commit or push from a test run.
3. **Demand a friction report.** Each agent reports: what it produced, the judgment calls the skill left it to make, where the skill's guidance was ambiguous or fought the repo's reality, and what it did differently than the skill seemed to expect. The report is the product; the output artifact is evidence.
4. **Act on convergence.** The same friction from independent runs is a defect in the skill — fix it. Friction from a single run is usually a legitimate per-project judgment call — leave it; encoding a rule for it cuts against delegating judgment to the model.
5. **Fold fixes and re-verify.** Apply the convergent fixes to the skill, then re-run the worst-affected repo if the fix changed behavior materially. Clean up test outputs, or hand them to the user if they turned out better than what the repos had.

## Red flags

- Shipping a materially changed skill because it reads well
- Test repos that rhyme — same stack, same shape, same conventions
- Encoding a rule for friction only one run hit
- Ignoring convergent friction because each report resolved it "fine on its own"
- Test runs that commit, push, or leave the target repos dirty without telling the user
- Skipping the friction report and judging only the output artifact
