---
name: review-checklist
description: How to review a diff against the Nuxt-stack conventions, with the severity scheme and the review-only quality items. Use alongside /code-review before a pull request, or when the user asks whether Nuxt code looks right.
---

# Reviewing a diff on the Nuxt stack

Load the `frontend`, `backend`, and `styling` skills and check `git diff HEAD` against every rule they state. The rules live there, not here. Then check the items below, which only matter at review time.

## Reporting

One finding per line with file, approximate line, severity, and one sentence. Severities are CRITICAL, WARNING, and SUGGESTION. Anything that could expose a secret or user data is CRITICAL and is never downgraded. End with the count per severity.

## Review-only items

- No unused imports or declared-but-unused variables.
- No `any` without a comment saying why.
- No TODO in production code without a linked issue or a `docs/TODO.md` entry.
- Every new user-facing string exists in both locale files.
- Every new route has a test in `test/` mirroring its path.
- No behaviour changed that the spec does not describe. Scope that grew mid-build goes to `docs/TODO.md`.
