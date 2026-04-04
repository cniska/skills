# Agent Skills

Engineering skills for AI coding agents. Each skill is a step-by-step workflow the agent follows — not reference documentation. Compatible with [agentskills.io](https://agentskills.io).

I wrote these to work more efficiently with AI coding agents. They are opinionated, based on 15+ years of building production software, and encode the workflow I actually follow. They took shape while building [Acolyte](https://github.com/cniska/acolyte), where generic prompts did not hold up across sessions; the agent would drift, second-guess itself, or produce noise instead of findings.

Some ideas refined after reviewing [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills).

## Install

```
npx skills add cniska/skills
```

Or pick individual skills:

```
npx skills add cniska/skills -s plan
```

## Skills

| Phase | Skill | Description |
|-------|-------|------------|
| **Plan** | explore | Ask questions one at a time until the task is clear. Read the code instead of asking when possible. |
| | plan | Design a feature through dialogue. The plan emerges from conversation, not isolation. Slice vertically. |
| **Build** | build | Implement in thin vertical slices. Verify and commit after each slice. |
| | tdd | Red-green-refactor. One test, one implementation, one refactor pass. Mock at boundaries, not internals. |
| | debug | Stop the line. Reproduce, localize, reduce, fix root cause, guard with a test, verify. |
| | design | Design interfaces that are hard to misuse. Contract first, Hyrum's Law, validate at boundaries. |
| | simplify | Reduce complexity while preserving behavior. Understand before touching (Chesterton's Fence). |
| | git | Atomic commits, clean history, short-lived branches. Rewrite local history before pushing. |
| | deprecation | Code is a liability. Build the replacement first, migrate consumers, remove completely. |
| **Review** | review | Run all review dimensions against the branch diff. Severity labels, change sizing, fix-all policy. |
| | style | Naming, control flow, pattern consistency. Enforces local conventions, not generic style guides. |
| | architecture | Boundaries, indirection pressure, contract integrity. If a layer carries no policy, remove it. |
| | security | Trust boundaries, execution safety, secret exposure. Only reports concrete attack paths. |
| | tests | Coverage gaps, edge cases, test quality. Mock at boundaries only. Does not demand 100% coverage. |
| | docs | Doc drift, terminology gaps, outdated names after refactors. |
| **Ship** | pr | Create a pull request. Runs verification and review before opening. |
| | issue | Create a GitHub issue. Check for duplicates, show a draft, get approval before creating. |

## Principles

These show up across multiple skills and form the shared engineering philosophy.

| Principle | In practice | Skills |
|-----------|------------|--------|
| Vertical slices | Build one complete path through the stack at a time | build, plan |
| Contract first | Define the interface before implementing it; the schema is the source of truth | design, build |
| SRP | One responsibility per module, one logical change per commit | architecture, build, git |
| YAGNI | Don't build for hypothetical future requirements | architecture, design |
| Stop the line | When something breaks, stop building; errors compound | debug |
| Prove-It pattern | For bugs, write a failing test first to prove the bug exists | debug, tdd |
| Mock at boundaries | Mock external systems (database, network, APIs), not internal functions | tdd, tests |
| DAMP over DRY | In tests, prefer descriptive and meaningful phrases over eliminating duplication | tdd |
| Rule of 3 | Don't extract a shared function until you have three instances | simplify, style |
| Chesterton's Fence | Before removing code you don't understand, first understand why it exists | simplify |
| Hyrum's Law | All observable behaviors become dependencies; be deliberate about what you expose | design, deprecation |
| Code as liability | Value comes from functionality, not code volume; less code is better | deprecation |
| Save-point pattern | Commit early when exploring; uncommitted work can't be reverted | git |
| Evidence threshold | Findings need concrete code references, not speculation | review skills |

## How they work

Every review skill has the same structure: scope, evidence threshold, workflow, output format, red flags. The evidence threshold is what matters. Findings need concrete code references or plausible failure scenarios. No speculative concerns, no generic style dogma.

The skills compose. `/review` runs all five review dimensions and deduplicates. `/pr` gates on `/review` before creating the pull request. You can run any skill individually if that is all you need.

## License

MIT
