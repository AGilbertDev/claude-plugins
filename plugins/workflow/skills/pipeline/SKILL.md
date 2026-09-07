---
name: pipeline
description: Build one feature through the spec-driven pipeline. Use for any feature, page, route, or non-trivial fix in a personal project. Spec approved in plan mode, then tests first, a hands-off build, browser verification, review, and an open pull request. Not for small fixes.
argument-hint: <the feature, in one or two sentences>
---

# Pipeline

You are the orchestrator, and you run in the main session. You can talk to the user, use plan mode, and launch agents. There are two human gates, the spec and the pull request. Between them you do not stop to ask.

## Stage 0. Frame

1. Restate the feature in two sentences. If the user gave none, ask for it. One question, then wait.
2. Read `AGENTS.md` and any spec in `docs/specs/` that touches the same area.
3. Confirm the tree is clean and you are on the default branch. Create `feat/<kebab-name>` and check it out.
4. Run the project's test and lint scripts. Record exit codes and counts as the baseline. Never pipe these commands, since a pipe hides the exit code.

## Stage 1. Spec, the first human gate

1. Enter plan mode. Load `/workflow:spec` and write the spec as the plan, following its template and rules.
2. Open questions go to the user one at a time, through the question tool.
3. On approval, write the spec to its path, commit it alone as the first commit on the branch, and leave plan mode. No implementation code exists before this commit.

## Stage 2. Build, hands-off

Pick the stages that apply. Run independent stages in parallel, in the foreground, in one message. Never launch a second agent against the same files while the first might still be running.

| Stage | Applies when | How |
| --- | --- | --- |
| Tests first | Any logic changed | Launch the `workflow:unit-test` agent with the spec path and the test command. The tests arrive failing. Never edit them to make them pass. |
| Implement | Always | You write it, in the main session, with the stack skills loaded, until the tests pass. |
| Checklists | Per feature | The stack plugin's `review-checklist` always. Its `a11y-checklist` for any UI change. Its `seo-checklist` for a new public page. `/workflow:compliance` for personal data, auth, payments, email, or a public page. Fix what is contained. Log the rest in the pull request. |
| Browser verification | Any UI change | Start the dev server. Drive it with the Playwright tools. Check every acceptance criterion with a visible outcome. Record the result per criterion in the pull request test plan. |
| Code review | Always | Run `/code-review`. Fix every finding you agree with. Say why for any you decline. |

Rules for the build.

- If the spec is silent on something, follow the most conventional assumption and record it in the pull request body. Do not ask.
- If the gap changes the contract, stop. Amend the spec, commit the amendment, and ask once. Then continue.
- Scope discovered mid-build goes into `docs/TODO.md`, not into this branch. One feature per pull request. A fix can ride along with its own paragraph in the pull request body. A second thing with a spec cannot.
- A confidentiality problem the user must decide goes into `docs/TODO.md` with file and line numbers, in addition to being raised.
- Build in the main working tree, never in a worktree. The dev server cannot see a worktree.
- The gate. Test and lint scripts exit 0, run by you, unpiped, on the final tree. Failing tests block the pull request. No bypass.
- Silence is not death. Before declaring an agent dead, check something that would have moved if it were alive.

## Stage 3. Pull request, the second human gate

1. If the project keeps a build trail, its `AGENTS.md` says so. Append the entry and the ledger row first.
2. Load `/workflow:commit` and follow it. Commit, push the branch, open the pull request, leave the branch checked out.
3. Report in five lines or fewer. Branch, pull request link, test and lint result, stages skipped and why, decisions waiting on the user.
