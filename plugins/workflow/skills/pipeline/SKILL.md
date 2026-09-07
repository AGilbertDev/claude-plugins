---
name: pipeline
description: Run a feature through the spec-driven pipeline from the main session, spec first, then build, test, review, and pull request. Rewritten in the next step of the rebuild.
disable-model-invocation: true
---

# Pipeline

Not ready yet. The next step of the rebuild turns this into the main-session orchestrator that replaces the `pipeline` agent. Until then, the rules below are parked here so nothing is lost while the always-on core shrinks.

## One feature per pull request

One feature, one pull request, never more. A feature is a thing with its own spec, so two spec documents on one branch means two pull requests. Scope discovered mid-build belongs in the next pull request. Write the finding down, finish what is open, and let it be the thing that comes next. Urgency is not an exception. "It touches the same files" is an argument for having noticed sooner. A fix is not a feature and can ride along, with its own paragraph in the description saying why it is in the diff.

## The default branch is mine to merge

Never merge into the default branch and never push to it directly. Work on a branch, open the pull request, and stop. This holds when the tests pass and the review is clean. No fast-forward, no force push, no branch deletion, no typo fix straight to main. Protect it on the remote too, with a repository ruleset on `~DEFAULT_BRANCH` requiring a pull request and blocking deletion and non-fast-forward pushes, with no bypass actors. Verify with `gh api repos/<owner>/<repo>/rules/branches/<branch>`, never with `git push --dry-run`, which skips the stage where rulesets are evaluated. One honest limit. Agents run with my credentials, so the ruleset cannot stop a merge made with my token, which is why this is a convention too.

## Leave the working branch checked out

The dev server serves the working tree, so the checked-out branch is the app I am looking at. Never finish a turn on a branch other than the one the current work lives on. If you must visit another branch, go back the moment you are done. Do not build the active feature in an isolated worktree, since code there is invisible to the dev server.

## Running stage agents

Run every stage whose inputs are ready in parallel, in one message, in the foreground. Only a real input dependency justifies waiting, and then name the output being waited on. Never launch a replacement agent against the same working tree while the original might still be running. Two agents writing one file is not a race you can referee afterwards. Silence is not death. Before declaring an agent dead, check something that would have moved if it were alive.

## An open confidentiality question gets a durable home

When a confidentiality problem is found and the decision is mine, write it into `docs/TODO.md` with the file and line numbers, in addition to raising it. A question left only in a pull request body dies when the pull request merges.
