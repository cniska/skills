# Contributing

Minimal workflow for contributors.

## Setup

After cloning, run bootstrap once:

```bash
./scripts/bootstrap.sh
```

This configures the Git hooks path and runs full validation (`make validate`).

## Development loop

1. Create a branch from `main`.
2. Make focused, slice-based changes.
3. Run local validation while iterating:

```bash
make validate
```

## Submission expectations

- Keep commits small and scoped to one intent.
- Use Conventional Commit format: `type(scope): description`.
- Subject line only. No commit body.
- For skill changes, each skill must live in `<name>/SKILL.md`.
- For skill changes, YAML frontmatter must include `name` and `description`.
- For skill changes, frontmatter `name` must match the directory name.
- For skill changes, `description` must start with an imperative verb.
- For skill changes, use `## Red flags` (not `## Anti-patterns`).
