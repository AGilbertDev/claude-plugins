---
name: new-project
description: AGilbertDev's playbook for starting a new personal project. Scaffolds a Nuxt app, wires in the agilbertdev-recipes submodule, and sets the shared Bun, ESLint, Prettier, husky, and i18n baseline. Use when creating a new repo or bootstrapping a project from scratch.
---

# New project setup

The ordered playbook for starting a new AGilbertDev personal project. It scaffolds the app, wires in the recipes, and sets the shared tooling baseline. Stack details live in `nuxt-conventions:frontend`, `nuxt-conventions:backend`, and `nuxt-conventions:styling`, so follow those for the nuxt.config modules, theming, and the database layer.

## Stack baseline

- Nuxt 4 with Vue 3 and vue-router. Bun is the package manager and the task runner.
- The frontend is Nuxt UI v4, Tailwind v4, and `@nuxt/fonts`. Follow `nuxt-conventions:frontend` and `nuxt-conventions:styling`.
- Server-state reads and writes use TanStack Query (`@tanstack/vue-query`), registered once in an SSR-hydrated Nuxt plugin, with the query-key factory and the query and mutation composables described in `nuxt-conventions:frontend`.
- Localization is `@nuxtjs/i18n` with Québécois French as the default locale and English second.
- TypeScript across the whole project.
- A backend, when the project needs one, follows `nuxt-conventions:backend` (Turso libSQL with Drizzle, Zod, `nuxt-auth-utils` for owner-managed auth, Resend for email).
- Deploy on Vercel with the personal identity.

## Steps

1. Scaffold the app with Bun and set the personal git identity locally.

   ```bash
   bunx nuxi@latest init <name>
   cd <name>
   git config user.name "AGilbertDev"
   git config user.email "alexandre.gilbert.dev@gmail.com"
   ```

2. Add the runtime and dev dependencies.

   ```bash
   bun add @nuxt/ui @nuxt/fonts @nuxtjs/i18n
   bun add -D @nuxt/eslint eslint prettier eslint-config-prettier eslint-plugin-prettier eslint-plugin-perfectionist husky lint-staged typescript
   ```

   Register the modules in nuxt.config, then set up `main.css` and `app.config.ts` following `nuxt-conventions:styling`.

3. Wire in the recipes, then ignore the generated skills.

   ```bash
   git submodule add https://github.com/AGilbertDev/agilbertdev-recipes.git .recipes
   bash .recipes/bin/install
   ```

   `bin/install` symlinks the local skills into `.claude/skills/`, downloads the third-party skills there as real folders, merges the security baseline into `.claude/settings.json`, and wires the conventions core into your `CLAUDE.md`. It writes a `skills-lock.json` at the root.

4. Add the tooling configs below (`.gitignore`, `.prettierrc`, `eslint.config.mjs`, the husky pre-commit, and the package.json scripts).

5. Add an `AGENTS.md` from the template below, keeping only this project's own facts.

6. Make the first commit. The downloaded skills and the lock file stay out of git because `bin/install` regenerates them.
   ```bash
   git add .
   git commit -m "chore: scaffold project and add agilbertdev-recipes"
   ```

## .gitignore

```
# Nuxt dev/build outputs
.output
.data
.nuxt
.nitro
.cache
dist

# Node dependencies
node_modules

# Logs
logs
*.log

# Misc
.DS_Store
.fleet
.idea

# Local env files
.env
.env.*
!.env.example

# agent skills (downloaded, re-installable from .recipes)
.claude/skills/
skills-lock.json
```

Commit a `.env.example` with the keys and no values. Never commit `.env`.

## package.json scripts and lint-staged

```json
{
  "scripts": {
    "build": "nuxt build",
    "dev": "nuxt dev --host localhost --port 8080",
    "generate": "nuxt generate",
    "preview": "nuxt preview",
    "postinstall": "git submodule update --init --recursive && nuxt prepare",
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --check .",
    "format:fix": "prettier --write .",
    "prepare": "husky",
    "recipes:update": "git submodule update --remote --recursive && git add .recipes"
  },
  "lint-staged": {
    "*.{js,ts,vue}": ["eslint --fix", "prettier --write"]
  }
}
```

`postinstall` runs `git submodule update --init --recursive` before `nuxt prepare`, so every `bun i` restores the `.recipes` submodule (and the nested `agents` repo it carries) to exactly the commits the project pins. It is deterministic and safe to run on every install. On a fresh clone it also does the submodule init for you, so `bun i` alone brings the agents and skills online. This syncs to the pinned commits, it does not pull anything forward.

`recipes:update` is the deliberate counterpart. Run `bun run recipes:update` when you actually want to move the recipes and agents to their latest push. It pulls every submodule to its remote tip and stages the pointer bump for you to review and commit. Keep this out of `postinstall`: pulling to latest mutates the working tree and silently changes which agents run, so it should be an explicit choice, never a side effect of installing dependencies.

## .prettierrc

```json
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "none",
  "printWidth": 100
}
```

## eslint.config.mjs

Extend the generated Nuxt config with Prettier, then add the perfectionist sorting and the alphabetical Vue attribute order.

```js
import perfectionist from 'eslint-plugin-perfectionist'
import eslintPluginPrettierRecommended from 'eslint-plugin-prettier/recommended'
import withNuxt from './.nuxt/eslint.config.mjs'

export default withNuxt([
  eslintPluginPrettierRecommended,
  {
    plugins: { perfectionist },
    rules: {
      'perfectionist/sort-named-imports': ['warn'],
      'perfectionist/sort-interfaces': ['warn'],
      'perfectionist/sort-imports': ['warn'],
      'vue/attributes-order': ['warn', { alphabetical: true }],
    },
  },
])
```

## Husky pre-commit

Initialize husky once, then run lint-staged through Bun on every commit.

```bash
bunx husky init
echo 'bun lint-staged' > .husky/pre-commit
```

## AGENTS.md template

Keep it short. It holds only this project's own facts and points to the recipes for everything shared.

````markdown
# <project-name>

<one-line description>. Solo project.

## Conventions and skills

This repo uses the shared [agilbertdev-recipes](https://github.com/AGilbertDev/agilbertdev-recipes) (vendored as the `.recipes` submodule). Personal conventions and the curated skill set come from there, not from this file. After cloning:

```bash
git submodule update --init && bash .recipes/bin/install
```

Personal conventions load from the always-loaded core (`@.recipes/CLAUDE.md`), with stack rules in the `nuxt-conventions:frontend`, `nuxt-conventions:backend`, and `nuxt-conventions:styling`.

## Collaboration

State one mode. Either tutorial mode (a learning project, follow the `tutorial-mode` skill, do not write the code for me) or hand-built (Claude advises and reviews only).

## Stack

Nuxt 4, Nuxt UI 4, Tailwind 4, @nuxtjs/i18n. Add Turso + Drizzle, nuxt-auth-utils, Zod, and Resend when a backend is needed.
````

## On another machine

A cloned project restores its skills with the two install commands, which are already in the AGENTS.md template.

```bash
git submodule update --init && bash .recipes/bin/install
```
