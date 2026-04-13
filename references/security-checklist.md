# Security checklist

Use this checklist during implementation and review.

## Boundary checks

- Validate and normalize all untrusted input at boundaries.
- Enforce authorization per action, not just per route.
- Deny by default for privileged actions.
- Keep secrets in environment or secret stores, never in code.

## Execution safety

- Parameterize queries and commands.
- Resolve paths safely and block traversal attempts.
- Use explicit allowlists for dynamic operations.
- Apply timeouts and size limits to untrusted payloads.

## Operational checks

- Redact secrets from logs and error messages.
- Pin dependencies and review known vulnerabilities.
- Keep security-sensitive defaults conservative.

## Red flags

- Trusting client-provided identity or role fields.
- Building shell commands with string concatenation.
- Logging raw request bodies containing tokens or PII.
- Wide-open CORS, listeners, or admin routes by default.
