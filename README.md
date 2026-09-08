# claude-plugins

My Claude Code plugins. A marketplace named `agilbertdev` that holds one plugin for how I build software with agents, and one conventions plugin per stack.

> My own setup, published so the method can be read and tried. It is not open source. The licence permits running it to evaluate my work, and nothing beyond that. See [Try it](#try-it) and [License](#license).

## Contents

- [Plugins](#plugins)
- [Try it](#try-it)
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

## Try it

Meant for anyone evaluating my work. It takes a scratch directory and about a minute, and it touches nothing else on your machine.

```bash
mkdir /tmp/try-agilbertdev && cd /tmp/try-agilbertdev && git init
claude plugin marketplace add AGilbertDev/claude-plugins --scope project
claude plugin install workflow@agilbertdev --scope project
claude
```

Then ask for a feature, or type `/workflow:pipeline` to see the flow, `/workflow:spec` for the spec template, and `claude plugin details workflow@agilbertdev` for what it costs in context.

Three things worth knowing before you run it.

**Use project scope, as written above.** At user scope it would load my conventions into every repository on your machine, which is not what you want and is the one mistake I made myself.

**Two hooks will act on your commits.** One blocks a command that reads or writes a secrets file. One runs the project's own test script before a `git commit` and blocks the commit when it fails, which is slow if the suite is slow. Both are in `plugins/workflow/hooks/` and both have tests. A third checks the git identity and will do nothing in your repositories, because it only acts when the origin remote is under my own account.

**Only one plugin is general.** `workflow` carries the pipeline and is free of any stack. `nuxt-conventions` is my Nuxt setup down to the icon set, so install it only if you want to see how stack rules are separated from the process.

Removing it again is two commands.

```bash
claude plugin uninstall workflow@agilbertdev --scope project
claude plugin marketplace remove agilbertdev
```

## Adding it to one of my projects

These are my own notes, kept here because the workflow only means something with its wiring shown. If you are evaluating rather than adopting, [Try it](#try-it) is the shorter path.

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

All rights reserved, with one narrow permission. Anyone may install and run it as published to evaluate my work. That covers running it and nothing else, so not adopting it in your own projects, not adapting it, and not redistributing it. See [LICENSE](./LICENSE).
