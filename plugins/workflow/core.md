# AGilbertDev core conventions

Personal projects only. The workflow plugin loads this at session start. Stack rules live in the stack plugins. Process rules live in the workflow skills.

## Who you work with

Solo developer. Docs and config steer Claude and my future self, not teammates.

## Talking to me

Peer programmer register. Short sentences, plain English. One question at a time, then wait. One step at a time. When I answer, act on the answer before anything else in the turn.

## Rules and corrections

A correction is not automatically a rule. Save it to memory first. When it recurs, promote it to its home in the `claude-plugins` repo. Core rules here, process rules in a workflow skill, stack rules in the stack plugin, never-skip gates as hooks. Validate, push to main, then `claude plugin update`. A review comment that keeps coming back is a missing rule. When a recurring comment is wrong, write down why it is declined.

## Finish what you break

Never end a turn with a broken tree, conflict markers, a stale dev server, or a half-applied migration. Fix it, prove the fix with a real result, then report. If you cannot finish, say what is broken in your first line.

## Git

Commit and push as AGilbertDev, configured locally in each repo. A hook blocks any other identity. Never merge into the default branch and never push to it. Open a pull request and stop. Never use `git stash`. Leave the working branch checked out so localhost shows the work.

## Security

Never read or print `.env` or secrets files. Deny rules and a hook enforce it.

## Confidentiality

Public prose stays generic. Never name clients, employers, or people from my life, not by name and not by relationship. Describe a real user by role, with they/them. Never describe a third party's internal workings. Workplace numbers ship as plain configurable defaults with no provenance. This governs prose, meaning specs, README files, commits, and pull requests. It does not constrain what an app stores. A slip also lives in git history, so say so plainly instead of quietly cleaning the tree.

## Writing voice

Humble, honest, direct. Complete sentences. No corporate fluff and no overclaiming. Never join or separate clauses with a dash or a colon. No em-dashes, no `---` dividers, no setups like "The goal was simple". Write English in English, with no French jargon in English prose.

## French

All French copy is Québécois, never France French. Load `/workflow:quebec-french` before writing or reviewing French copy.

## Engineering

Follow the framework's documented way. Do not invent patterns. Keep client, server, and shared contracts apart. Measure before you optimise, on the cold baseline a visitor actually gets. Look up how the industry already solves a problem before designing. Never silence stderr on a check you will conclude from. Before trusting a negative result, prove the instrument can show a positive.

## Features

A feature, page, route, or non-trivial fix goes through `/workflow:pipeline`. Small fixes do not. One feature per pull request.
