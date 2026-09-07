---
name: new-project
description: Start a new personal project from the right template. Use when creating a new repo or bootstrapping a project from scratch.
---

# New project

The starter files live in a template repository, one per stack, so nothing is scaffolded by hand and nothing drifts. Pick the template, create from it, rename the placeholders. The conventions and the pipeline arrive with the plugins the template already enables.

## Templates

| Stack | Template |
| --- | --- |
| Nuxt 4 | [`AGilbertDev/nuxt-project-template`](https://github.com/AGilbertDev/nuxt-project-template) |

There is no React or .NET template yet. When one is needed, build it the same way and add its own conventions plugin beside `nuxt-conventions`, so the `workflow` plugin stays free of any stack.

## Steps

1. Create the repository and clone it.

   ```bash
   gh repo create <name> --template AGilbertDev/nuxt-project-template --private --clone
   cd <name>
   ```

2. Set the personal identity locally, before anything is committed. The identity hook blocks a commit under any other name.

   ```bash
   git config user.name "AGilbertDev"
   git config user.email "<the personal email>"
   ```

3. Install and check the app boots.

   ```bash
   bun install
   bun run dev
   ```

4. Rename the placeholders. The project name in `package.json`, the title and tagline in both locale files, and every angle-bracket placeholder in `AGENTS.md`. Fill in what the project is, who uses it, and anything it will never trade away.

5. Delete `shared/greeting.ts` and its test once the project has logic of its own. They exist so a fresh clone runs green and the first pull request report has something to measure.

6. Protect the default branch, since a convention only one person remembers is not protection.

   ```bash
   gh api -X PUT repos/AGilbertDev/<name>/rulesets --input - <<'JSON'
   { "name": "default branch", "target": "branch", "enforcement": "active",
     "conditions": { "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] } },
     "rules": [{ "type": "pull_request" }, { "type": "deletion" }, { "type": "non_fast_forward" }] }
   JSON
   ```

   Verify with `gh api repos/AGilbertDev/<name>/rules/branches/main`, which reports what the server actually applies. Never verify with a dry-run push, since dry-run skips the stage where rulesets are evaluated.

7. Commit and push the renamed template as the first commit.

## What arrives with it

The template already carries the stack, the tooling, Vitest with its exclusions file, the pull request report from `AGilbertDev/test-report`, a devcontainer, and `.claude/settings.json` enabling the `workflow` and `nuxt-conventions` plugins at project scope. Claude offers to install them on the first session in the new repository.

Nothing here is copied between projects. Updating every project at once is `claude plugin update workflow@agilbertdev`.

## Adding a backend

The template ships the client only. When the project needs a server, follow `nuxt-conventions:backend` and add Turso with Drizzle, Zod, `nuxt-auth-utils` for owner-managed auth, and Resend for email. Put the schema and the routes under `server/`, the contracts both sides import under `shared/`, and mirror every new module in `test/`.
