# Testing patterns

Use this checklist when writing or reviewing tests.

## Coverage priorities

- Test observable behavior through public interfaces.
- Cover new branches and meaningful error paths.
- Add at least one boundary case when behavior depends on input shape.
- Keep happy path, failure path, and edge path separate.

## Quality checks

- Name tests as behavior statements.
- Keep one reason to fail per test.
- Mock external boundaries only (DB, network, filesystem).
- Prefer deterministic inputs over timers, sleeps, and global state.
- Clean up temp state and fixtures.

## Red flags

- Tests asserting private implementation details.
- Snapshot-only tests without behavioral assertions.
- Broad mocking of internal modules.
- Duplicate tests with no new scenario.
