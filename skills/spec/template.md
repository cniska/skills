# Spec template

Copy the skeleton into the project's spec. Keep the section order. Drop sections that don't apply, and add domain requirement families (`ST`, `AU`, …) where the project needs them. Angle-bracket text is guidance; replace it. Refine this template over time: when a spec pattern repeats across projects, encode it here.

---

# <Project> Specification

> <One sentence: what the tool does and for whom.>

This document specifies what the tool must do, not how. Implementation choices are the builder's, provided the requirements and acceptance criteria below hold. Fixed decisions live in §Constraints; everything in §Open decisions is deliberately left open.

## 1. Purpose & context

<The problem being solved, and why the manual status quo is painful.>

**Primary user:** <who runs this, in what environment; who is explicitly not the audience.>

**Reference product** (optional): <the conceptual bar for quality, if any.>

## 2. Functional requirements

### 2.1 Core behavior

- **FR-1** — <the single most central thing the tool does.>
- **FR-2** — <…>

### 2.2 Input handling

- **FR-n** — <accepted inputs, and how bad input is rejected with an actionable message.>

### 2.3 Feature coverage

- **FR-n** — <each feature the tool must handle, mapped to its output form.>

### 2.4 Options / configuration

- **FR-n** — <each CLI flag, subcommand, or config key. Enumerate the full surface once.>

### 2.5 Edge cases requiring special handling

<The constructs a naive build gets wrong. Each is a requirement, not a nice-to-have. Give each its own ID so it earns its own test.>

- **FR-n** — <edge case, stated as the observable outcome that must hold.>

## 3. <Domain family> requirements

<Optional. A cohesive dimension the project cares about: styling, auth, UX. Use a distinct two-letter prefix (ST-1, AU-1). State the desired outcome; leave exact values to the builder.>

- **XX-1** — <…>

## 4. Non-functional requirements

- **NF-1** — <performance, reliability, portability, install footprint.>
- **NF-n** — <clear, non-crashing error behavior for each common failure mode.>

### 4.1 Testing

- **NF-n** — <the test suite that must ship and pass before release.>
- **NF-n** — <which boundaries are mocked; which §2.5 edge cases each get a dedicated test.>

## 5. Out of scope

<What v1 deliberately does not do, so scope creep has a name to bump against. Note anything moved in or out since a prior version.>

## 6. Acceptance criteria

<The tool is done for v1 when all of these hold. Each cites the requirements it exercises, and each must be stateable as a trigger → observable outcome; if you can't, it isn't yet an acceptance criterion.>

- **AC-1** — <observable, end-to-end condition; references the FRs it verifies.>
- **AC-n** — <…>

## 7. Deliverables

- **D-1** — <the working artifact.>
- **D-n** — <README, sample inputs, test suite, config from the first commit.>

## 8. Constraints (fixed)

<Decisions the builder may not revisit: runtime, language, key libraries, engineering conventions. State the decision, not the mechanism.>

- **C-1** — <…>

## 9. Open decisions (left to the builder)

<Explicitly unconstrained. Choose whatever best satisfies the requirements.>

- <decision, and the requirements that bound it.>

### Policies chosen (not open)

<Decisions already made that a reader might otherwise assume are open. State the policy and the requirement it serves.>
