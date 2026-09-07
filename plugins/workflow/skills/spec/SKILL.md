---
name: spec
description: How to write and maintain a feature spec, with the template and the design principles every spec must check. Use at the spec stage of the pipeline, when the user asks for a spec, or when a feature changes and its spec must follow.
---

# Writing a spec

A spec is the contract for one feature. It is short, current, and testable. The pipeline writes it in plan mode with the user and commits it before any code exists. The unit-test agent derives its tests from it, so every acceptance criterion must be something a test can check.

## Rules

- One spec per feature, kept current. When the feature changes, edit its spec. Never add a second spec for the same feature. Git history holds how it changed.
- Path is `docs/specs/<domain>/<feature>.md`. Kebab-case, grouped by app area the way pages and components are, never a flat folder.
- Under 150 lines. Longer means two features.
- Acceptance criteria are numbered `AC1`, `AC2`, and so on. Each one is observable.
- Enumerate abandoned and interrupted paths, not just the happy path. Any flow spanning more than one step, request, token, or session says what happens when it stops halfway and how the user recovers.
- Ask open questions one at a time. Never assume scope.
- No implementation code in a spec.

## Template

```md
# <Feature name>

## Intent
One paragraph. What it does and why it exists.

## Prior art
Which existing products solve this, and by what mechanism. Where our shape agrees or differs, and why.

## Inputs
Query params, body fields, settings, or user actions.

## Outputs and acceptance criteria
AC1. ...
AC2. ...

## Design
Only when the feature has UI. See below.

## Edge cases and interrupted paths
What happens at each failure and each half-finished state, and how the user recovers.

## Out of scope
What this feature deliberately does not do, and where that work goes.

## Verification
The exact commands and manual checks that prove each AC. This becomes the pull request's test plan.

## Open questions
Decisions still needed. Blank when none.
```

## The design section

Prose and class lists, never markup. Layout regions and their purpose. Component hierarchy using the stack's primitives first. Token and sizing decisions. Responsive behaviour. Motion, gated behind reduced motion. Follow the stack plugin's styling skill for the specifics.

## Principles every spec must check

**Look up the industry first.** Somebody has built something close to this. Research the existing products, read how they model the problem, and say where our shape agrees or differs. Name the products and be specific about mechanism. Report honestly when the research says we got it wrong. When our shape differs, say whether the difference is deliberate or accidental, and what changing course would cost. This comes before the shape is chosen.

**Any list is customizable, modular, and extensible.** Categories, statuses, tags, types, labels, and priorities are user-owned data, not constants. Assume the set will grow, that a member will be renamed, that one will be retired without deleting the rows that reference it. Ship defaults as data. Key related settings by member id. Keep display names in the i18n layer keyed by id. Give members declared flags rather than special-casing an id in code. Guarantee by construction anything a new member needs, such as a readable colour or a stable sort position. This is not permission to build the management screen before the feature that needs it.

**Logic belongs to the backend.** The frontend is a view with as little brain as possible. Derived values arrive resolved. A status that depends on the current time, a total, a permission, an ordering, a filter, a page of results, a label chosen between several. A derived field with no column behind it is a legitimate part of a response. Only presentation stays in the component. Focus, open and closed state, hover, transitions, a visual breakpoint, and display formatting of resolved data. If the rule would still be true with no user interface attached, it belongs to the backend. A pure rule both sides need lives once in the shared contract layer.

**No invalid states and safe recovery.** Assume any process can be abandoned partway and any token can expire. The outcome is either fully done or safely recoverable. Recovery never becomes an auth bypass, never reveals whether an account exists, and never lets one user act on another's data. Prefer the framework's documented recovery pattern. When in doubt, fail closed and route the user back to a clean start.

**Measure before you change it.** When something is slow or heavy, measure first and let the number pick the target. Measure the cold baseline a visitor actually gets. If the number says the suspected thing is not the bottleneck, say so and name what is.

**A costly default loses to the visitor.** A default a tool ships with is not its convention. When a documented default makes the site materially worse for a visitor, look for another supported configuration that gives up a feature I can afford. Give me the price in numbers. A feature is affordable when the visitor has an obvious manual path to the same place.
