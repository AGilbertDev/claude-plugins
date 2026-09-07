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

| Plugin             | What it holds                                                                                                                                                                                                              |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `workflow`         | The spec-driven feature pipeline. The pipeline skill, the stage agents, the commit gates as hooks, the `.env` deny rules, and the always-on personal conventions. Nothing in it is tied to a stack, so it survives a stack change. |
| `nuxt-conventions` | The Nuxt 4 stack conventions as skills, meaning frontend, backend, and styling. A React or .NET counterpart can sit beside it, and a project enables only the one it uses.                                                    |

A plugin is installed into a project and updated centrally, which is what makes it different from a project template. The starter files for a new project live in a separate template repository, one per stack, with the plugins already enabled in its Claude settings.

## Install into a project

```bash
claude plugin marketplace add AGilbertDev/claude-plugins --scope project
claude plugin install workflow@agilbertdev --scope project
claude plugin install nuxt-conventions@agilbertdev --scope project
```

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

## Migration status

This repository used to be consumed as a `.recipes` git submodule with symlinks into `.claude/`. The plugin form replaces that. Until every project has migrated, the legacy path stays in place and keeps working, meaning `bin/install`, `settings.base.json`, `skills.manifest.json`, `templates/`, and the root `CLAUDE.md` import shim. They are removed once the last project moves over. Third-party skills are still fetched with the `skills` CLI as listed in `skills.manifest.json`, and the project template takes that job over.

## License

All rights reserved. This code is published for viewing and reference only, and is not open source. See [LICENSE](./LICENSE).
