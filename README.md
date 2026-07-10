# Agent Skills

Engineering skills for AI coding agents. Compatible with [agentskills.io](https://agentskills.io).

```
plan → build → review
```

I wrote these to work more efficiently with AI coding agents. They are opinionated, based on 15+ years of building production software, and encode the workflow I actually follow. They took shape while building [Acolyte](https://github.com/cniska/acolyte), where generic prompts did not hold up across sessions.

Some ideas were refined after reviewing [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills).

## Motivation

This repo exists to encode a practical engineering workflow for AI coding agents in my own tone and decision style. The goal is consistent execution quality across sessions, not generic prompt patterns.

## How I update these skills

Maintenance inputs: daily use in my own projects, gaps observed in real sessions, selective upstream review (for example Addy updates) as a signal, and external feedback when it aligns with these principles.

I add guidance when it:

- repeats in real work
- improves quality, speed, or risk profile
- can be verified with concrete checks
- fits the way I want agents to operate

I remove or simplify guidance when it:

- no longer changes outcomes
- becomes outdated
- duplicates other skills
- drifts toward generic "corp" voice without adding value

## Install

```
npx skills add cniska/skills
```

## Local setup

Use Make targets for setup and checks:

```
make bootstrap
```

`make bootstrap` configures Git hooks and runs validation.

Active pre-push hook: [`.githook/pre-push`](.githook/pre-push).

## Skills

| Phase | Skill | Description |
|-------|-------|------------|
| **Plan** | [spec](spec/SKILL.md) | State what to build, not how; labelled, traceable requirements |
| | [plan](plan/SKILL.md) | Design through dialogue, slice vertically |
| | [design](design/SKILL.md) | Hard-to-misuse interfaces, contract first, validate at boundaries |
| **Build** | [build](build/SKILL.md) | Vertical slices — implement, verify, commit, repeat |
| | [tdd](tdd/SKILL.md) | Red-green-refactor, mock at boundaries |
| | [sdd](sdd/SKILL.md) | Verify library and API behavior in primary sources before implementing |
| | [debug](debug/SKILL.md) | Stop the line, reproduce, fix root cause, guard with test |
| | [simplify](simplify/SKILL.md) | Reduce complexity, Chesterton's Fence, preserve behavior |
| | [git](git/SKILL.md) | Conventional commits, rebase to sync, squash to land |
| | [deprecation](deprecation/SKILL.md) | Build replacement first, migrate consumers, remove completely |
| **Review** | [review](review/SKILL.md) | All review dimensions — self, PR, or path mode |
| | [style-review](style-review/SKILL.md) | Local conventions, naming, control flow, readability |
| | [architecture-review](architecture-review/SKILL.md) | Boundaries, indirection pressure, contract integrity |
| | [security-review](security-review/SKILL.md) | Trust boundaries, execution safety, concrete attack paths only |
| | [test-review](test-review/SKILL.md) | Coverage gaps, edge cases, test quality |
| | [doc-review](doc-review/SKILL.md) | Drift detection, terminology, outdated names |
| **Meta** | [agents-md](agents-md/SKILL.md) | Create or update AGENTS.md project rules |
| | [issue](issue/SKILL.md) | File a GitHub issue — check duplicates, draft, get approval |
| | [pr](pr/SKILL.md) | Self-review gated PR create or description update |
| | [handoff](handoff/SKILL.md) | Brief the next session on the next move, then reset context |

## Design

Each skill is one self-contained file — `<name>/SKILL.md`, with YAML frontmatter (`name` matching the directory, `description` starting with an imperative verb) and a terse Markdown body. A few conventions hold across the set:

- **Self-contained.** A skill depends on nothing outside its own directory — `npx skills add` copies only `<name>/`, so shared or repo-root files never ship. Guidance is inlined, not linked out.
- **Compose by name.** Skills reference each other by name in `## See also` (`build`, `review`, …), never by path — no cross-directory links to break.
- **Terse and imperative.** Intent, workflow, and a `## Red flags` section of failure modes. No filler.
- **Provider-neutral.** Skills name capability tiers (`fast` / `standard` / `powerful`), not specific models — see below.

`make validate` enforces the mechanical parts (frontmatter, `## Red flags`, no cross-directory links).

## Model tiers

Skills reference three capability tiers instead of provider-specific model names. Map them to whatever you're running:

| Tier | Role | Examples |
|------|------|---------|
| `fast` | Parallel reads, cheap context gathering | Haiku, GPT-4o-mini, Gemini Flash |
| `standard` | Default session model | Sonnet, GPT-4o, Gemini Pro |
| `powerful` | Synthesis, high-stakes analysis, high reasoning effort | Opus, o1, Gemini Ultra |

## Principles

| Principle | In practice | Skills |
|-----------|------------|--------|
| Vertical slices | One complete path through the stack at a time | build, plan |
| Contract first | Schema before implementation | design, build |
| SRP | One responsibility per module, one change per commit | architecture-review, build, git |
| YAGNI | Don't build for hypothetical requirements | architecture-review, design |
| Stop the line | Something breaks — stop, don't push past it | debug |
| Prove-It pattern | Failing test before fix | debug, tdd |
| Mock at boundaries | Mock external systems, not internal functions | tdd, test-review |
| DAMP over DRY | Descriptive tests over deduplicated tests | tdd |
| Rule of 3 | Extract after three instances, not before | simplify, style-review |
| Chesterton's Fence | Understand before removing | simplify |
| Hyrum's Law | All observable behavior becomes a commitment | design, deprecation |
| Code as liability | Less code serving the same purpose is better | deprecation |
| Source over memory | Verify framework behavior in primary docs before implementation | sdd |
| Save-point pattern | Commit early when exploring uncertain changes | git |
| Evidence threshold | Concrete references, not speculation | review skills |

## Validate skills

Run the validator before publishing changes:

```
make validate
```

`make validate` is the supported command. It runs [`./scripts/validate.sh`](scripts/validate.sh) under the hood.

CI runs the same validation on pull requests and pushes to `main` via [`.github/workflows/validate.yml`](.github/workflows/validate.yml).

CI also validates commit messages on pull requests via [`.github/workflows/commit-messages.yml`](.github/workflows/commit-messages.yml).

## Create a new skill

Use the Make target:

```
make new-skill NAME=<kebab-case-name> DESC="<imperative description>"
```

`make new-skill` is the supported command. It runs [`./scripts/new-skill.sh`](scripts/new-skill.sh) under the hood.

For all available commands:

```
make help
```

Bootstrap script: [`./scripts/bootstrap.sh`](scripts/bootstrap.sh)

Template reference: [`SKILL_TEMPLATE.md`](SKILL_TEMPLATE.md).

## License

MIT
