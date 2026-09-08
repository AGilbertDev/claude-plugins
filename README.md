# claude-plugins

My Claude Code plugins. A marketplace named `agilbertdev` that holds one plugin for how I build software with agents, and one conventions plugin per stack.

> Published for viewing and reference only. It is not open source. See [License](#license).

## Contents

- [Plugins](#plugins)
- [Install into a project](#install-into-a-project)
- [Update](#update)
- [Repository layout](#repository-layout)
- [Migration status](#migration-status)
- [License](#license)

## Plugins

| Plugin             | What it holds                                                                                                                                                                                                                                   |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workflow`         | The spec-driven feature pipeline. Skills `pipeline`, `spec`, `commit`, `compliance`, `quebec-french`, `new-project`, and `tutorial-mode`. One agent, `unit-test`, which writes tests from the spec before the code exists. Hooks for the git identity and the always-on core. The `.env` deny rules. Nothing in it is tied to a stack. |
| `nuxt-conventions` | The Nuxt 4 stack. Skills `frontend`, `backend`, and `styling` carry the rules. Skills `review-checklist`, `a11y-checklist`, and `seo-checklist` carry the audits. A React or .NET counterpart can sit beside it, and a project enables only the one it uses. |

A plugin is installed into a project and updated centrally, which is what makes it different from a project template. The starter files for a new project live in a separate template repository, one per stack, with the plugins already enabled in its Claude settings.

## Install into a project

```bash
claude plugin marketplace add AGilbertDev/claude-plugins --scope project
claude plugin install workflow@agilbertdev --scope project
claude plugin install nuxt-conventions@agilbertdev --scope project
```

Choose **project** scope at the prompt, never user. This machine holds a personal and a work account, and a user-scope install would load a personal workflow into every repository, including an employer's. If it ends up at user scope by accident, undo it with `claude plugin uninstall workflow@agilbertdev --scope user` and remove the `agilbertdev` entries from `~/.claude/settings.json`. The identity guard also refuses to act on any repository whose origin remote is not under my own account, so a stray install cannot block a work commit.

Skills then show up namespaced by plugin, for example `/workflow:pipeline` and `/nuxt-conventions:styling`, and agents as `workflow:unit-test`. The project scope writes the enablement into `.claude/settings.json`, so it is committed and travels with the clone. Check what a plugin costs in context with `claude plugin details workflow@agilbertdev`.

## Update

```bash
claude plugin update workflow@agilbertdev
claude plugin update nuxt-conventions@agilbertdev
```

Every project picks the new version up on its next session. No pointer to bump, nothing to relink.

## Repository layout

```
.claude-plugin/marketplace.json       the marketplace, listing the plugins below
plugins/workflow/                     .claude-plugin/plugin.json, skills/, agents/, hooks/, settings.json
plugins/nuxt-conventions/             .claude-plugin/plugin.json, skills/, agents/
```

Validate any change before pushing with `claude plugin validate .`.

## License

All rights reserved. This code is published for viewing and reference only, and is not open source. See [LICENSE](./LICENSE).
