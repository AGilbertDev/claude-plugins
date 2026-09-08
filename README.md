# claude-plugins

My Claude Code plugins. A marketplace named `agilbertdev` that holds one plugin for how I build software with agents, and one conventions plugin per stack.

> My own setup, published so the method can be read. It is not open source and not a package for general use. The licence allows viewing and nothing else. See [License](#license).

## Contents

- [Plugins](#plugins)
- [Adding it to one of my projects](#adding-it-to-one-of-my-projects)
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

## Adding it to one of my projects

These are my own notes. The repository is public so the method can be read, and the licence allows reading and nothing else. It is not a package on offer, and none of it is written to be useful to anybody else's setup.

Every project of mine already declares the marketplace and both plugins in a committed `.claude/settings.json`, so opening one is usually all it takes. **Do not accept the install prompt.** It defaults to user scope, which puts a personal workflow into every repository on the machine, including an employer's. Run the commands instead, with the scope spelled out.

```bash
claude plugin marketplace add AGilbertDev/claude-plugins --scope project
claude plugin install workflow@agilbertdev --scope project
claude plugin install nuxt-conventions@agilbertdev --scope project
```

A project that does not declare them yet needs the same three commands plus the two entries in its own `.claude/settings.json`, which the commands write.

If a user-scope install happens anyway, undo it.

```bash
claude plugin uninstall workflow@agilbertdev --scope user
claude plugin uninstall nuxt-conventions@agilbertdev --scope user
# then delete the agilbertdev entries from ~/.claude/settings.json
```

The identity guard is written to survive that mistake. It reads the owner out of the origin remote and refuses to act unless the repository is under my own account, so a stray install cannot block a commit in somebody else's repository.

Skills then show up namespaced by plugin, for example `/workflow:pipeline` and `/nuxt-conventions:styling`, and agents as `workflow:unit-test`. Project scope writes the enablement into `.claude/settings.json`, so it is committed and travels with the clone. Check what a plugin costs in context with `claude plugin details workflow@agilbertdev`.

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
