# ai-agents

Specialist Claude Code subagents for personal AGilbertDev projects. Each agent covers one stage of the feature development pipeline and delegates clearly, so no two agents overlap in responsibility.

> Published for viewing and reference only. It is not open source. See [License](#license).

This repo is imported as a submodule inside [agilbertdev-recipes](https://github.com/AGilbertDev/agilbertdev-recipes) and installed automatically when you run `bash .recipes/bin/install` in a new project.

## Agents

| Agent           | Trigger                                                               | Color  |
| --------------- | --------------------------------------------------------------------- | ------ |
| `pipeline`      | Start of a new feature — orchestrates the full pipeline               | purple |
| `specs`         | Before any code — write the feature spec in `docs/specs/`             | purple |
| `design`        | After spec, before frontend — layout, components, Tailwind blueprints | blue   |
| `frontend`      | Implement Nuxt 4 pages, Vue 3 components, composables                 | cyan   |
| `backend`       | Implement Nitro routes, Drizzle queries, Zod schemas                  | orange |
| `compliance`    | Personal data, auth, payments, or email features                      | orange |
| `seo`           | Pages shipping to production — meta, structured data, sitemap         | yellow |
| `accessibility` | Pages and interactive components shipping to production               | purple |
| `unit-test`     | After implementation — Vitest tests for business logic                | green  |
| `code-review`   | Before every commit — bugs, security, conventions                     | pink   |
| `commit`        | Reviewed and tested — commit with AGilbertDev identity                | red    |

## Pipeline

```
specs → design → frontend / backend → compliance → seo → accessibility → unit-test → code-review → commit
```

Invoke the `pipeline` agent at the start of any feature and it will walk you through each applicable stage in order.

## Stack assumptions

These agents are written for the personal project stack: Nuxt 4, Nuxt UI 4, Tailwind 4, Turso + Drizzle ORM, Zod, Vitest, and Bun. They load the matching skills from `agilbertdev-recipes` at each step.

## Installation

Installed automatically via `agilbertdev-recipes`. Do not add this repo as a submodule directly — let the recipes install script handle it.

```bash
# From your project root, after adding .recipes
git submodule update --init --recursive
bash .recipes/bin/install
```

Agent files land in `.claude/agents/` as symlinks. That directory is gitignored, so re-run the install script after cloning on a new machine.

## License

All rights reserved. This code is published for viewing and reference only, and is not open source. See [LICENSE](./LICENSE).
