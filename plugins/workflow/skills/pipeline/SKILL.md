---
name: pipeline
description: Build one feature through the spec-driven pipeline. Use for any feature, page, route, or non-trivial fix in a personal project. Spec approved in plan mode, then a hands-off build, tests, review, and an open pull request. Not for small fixes.
argument-hint: <the feature, in one or two sentences>
---

# Pipeline

You are the orchestrator, and you run in the main session. You can talk to the user, use plan mode, and launch agents. There are two human gates, the spec and the pull request. Between them you do not stop to ask.

## Stage 0. Frame

1. Restate the feature in two sentences. If the user gave none, ask for it. One question, then wait.
2. Read `AGENTS.md` and any existing spec in `docs/specs/` that touches the same area.
3. Confirm the tree is clean and you are on the default branch. Create `feat/<kebab-name>` and check it out.
4. Run the project's test and lint scripts. Record the exit codes and counts as the baseline. Never pipe these commands, since a pipe hides the exit code.

## Stage 1. Spec, the first human gate

1. Enter plan mode. Load `/workflow:spec` and follow it.
2. Research prior art in the domain before choosing a shape. Name the products and the mechanism.
3. Write the plan as the spec draft. Sections, in order. Intent. Inputs. Outputs and acceptance criteria, numbered `AC1`, `AC2`, and so on. Design, only when the feature has UI, kept to the component hierarchy and the token decisions. Edge cases and interrupted paths. Out of scope. Verification, meaning the exact commands and manual checks that prove it works. Open questions.
4. Ask open questions one at a time with the question tool. Never dump a list.
5. Keep the spec under 150 lines. A longer spec is a feature that should be two.
6. On approval, write it to `docs/specs/<domain>/<feature>.md`, commit it alone as the first commit on the branch, and leave plan mode. No implementation code exists before this commit.

## Stage 2. Build, hands-off

Pick the stages that apply from the table below. Run independent stages in parallel, in the foreground, in one message. Never launch a second agent against the same files while the first might still be running.

| Stage | Applies when | How |
| --- | --- | --- |
| Implement | Always | You write it, in the main session, with the stack skills loaded. Follow the spec. |
| Unit tests | Any logic changed | Launch the `workflow:unit-test` agent with the spec path. It writes tests from the spec, not from your code. |
| Compliance | Personal data, auth, payments, email, or a public page | Load `/workflow:compliance` and walk its checklist. Fix what is contained. Log the rest in the PR. |
| Accessibility | Any UI change | Load the `accessibility` skill and walk its checklist. Fix what is contained. |
| SEO | A new public page | Load the `seo` skill and walk its checklist. |
| Code review | Always | Run `/code-review`. Fix every finding you agree with. Say why for any you decline. |

Rules for the build.

- If the spec is silent on something, follow the most conventional assumption and record it in the PR body. Do not ask.
- If the gap changes the contract, stop. Amend the spec, commit the amendment, and ask once. Then continue.
- Scope discovered mid-build goes into `docs/TODO.md`, not into this branch. One feature per pull request. A fix can ride along with its own paragraph in the PR body. A second thing with a spec cannot.
- The gate. Test and lint scripts exit 0, run by you, unpiped, on the final tree. Failing tests block the pull request. No bypass.
- Silence is not death. Before declaring an agent dead, check something that would have moved if it were alive.

## Stage 3. Pull request, the second human gate

1. Stage files by name. Never `git add -A`.
2. Commit. Format is `<type>: <imperative subject>` under 72 characters, lowercase, no scope, no trailing period. Types are `feat`, `fix`, `chore`, `refactor`, `test`, `docs`. Explain the why in the body when it is not obvious.
3. If the project keeps a build trail, its `AGENTS.md` says so. Append the entry and the ledger row before pushing.
4. Push the branch and open the pull request. Body sections are `## What`, `## Test plan`, `## Notes`. Notes carry the assumptions you made, the findings you declined, and anything the user must decide.
5. Leave the feature branch checked out so localhost shows the work. Never merge. Never push to the default branch.
6. Report in five lines or fewer. Branch, pull request link, test and lint result, stages skipped and why, decisions waiting on the user.

## Standing rules

- The default branch is the user's to merge, only through a pull request. This holds when tests pass and the review is clean. Protect it on the remote with a ruleset on `~DEFAULT_BRANCH` and verify with `gh api repos/<owner>/<repo>/rules/branches/<branch>`, never with a dry-run push.
- Never finish a turn on a branch other than the one the current work lives on. Do not build the active feature in a worktree. The dev server cannot see it.
- An open confidentiality question gets a durable home in `docs/TODO.md`, with file and line numbers, in addition to being raised.
