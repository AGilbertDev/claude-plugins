---
name: commit
description: Commit and open a pull request the AGilbertDev way. Use when reviewed work is ready to land, at the last stage of the pipeline, or when the user says commit, push, or open a PR.
---

# Commit and pull request

The git identity and the passing test suite are enforced by hooks. You do not check them by hand, and you never bypass them.

## Steps

1. Stage files by name. Never `git add -A` or `git add .`.
2. Commit with the format below.
3. Push only when the user asks, or when the pipeline reaches its pull request stage.
4. Open the pull request with the body below.
5. Leave the feature branch checked out. Never merge. Never push to the default branch.

## Message format

```
<type>: <short imperative description>

Why this change, when the diff does not say it.
```

Types are `feat`, `fix`, `chore`, `refactor`, `test`, `docs`. Lowercase, imperative, no scope, no trailing period, subject under 72 characters.

## Pull request body

```md
## What
One paragraph. What changed and why.

## Test plan
- [ ] The check that proves each acceptance criterion, taken from the spec's Verification section
- [ ] Edge cases exercised

## Notes
Assumptions made where the spec was silent. Review findings declined and why. Migrations. Anything the user must decide.
```

## Protecting the default branch

The default branch is the user's to merge, only through a pull request. Protect it on the remote with a repository ruleset on `~DEFAULT_BRANCH` that requires a pull request and blocks deletion and non-fast-forward pushes, with no bypass actors. Verify with `gh api repos/<owner>/<repo>/rules/branches/<branch>`. Never verify with a dry-run push, which skips the stage where rulesets are evaluated. Agents run with the user's credentials, so the ruleset cannot stop a merge made with their token. That is why the rule is also written down.

## Never

- `--no-verify`, or any other way around a hook.
- A force push without the user asking for it in so many words.
- Committing `.env`, `.env.*`, or anything the deny rules cover.
