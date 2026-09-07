---
name: backend
description: AGilbertDev's backend conventions for personal Nuxt/Nitro projects — database, validation, server routes, auth, and email. Use when working on server routes, the database layer, schemas, or auth in a personal project. Starting defaults, adjust per project.
---

# Backend conventions (Nuxt / Nitro)

These are defaults for personal projects. Adjust per project when a project's needs differ.

## Database

- Turso (libSQL) with Drizzle ORM. SQLite dialect: `drizzle-orm/libsql` + `sqliteTable`, not the Postgres or MySQL cores.
- Define schema in Drizzle, derive validation with `drizzle-zod`.
- Migrations with `drizzle-kit`.

### Dynamic rows are translated in a `translations` table, never in the i18n files

**Any table holding rows the user creates needs its names translated, and those translations live in a single `translations` table rather than in the locale JSON.** The i18n files carry interface copy, which ships with the app and is known at build time. A row the user invents at runtime has a name nobody can put in a locale file, so it needs somewhere in the database to hold one name per locale.

One shared `translations` table rather than a name column per locale on every table, and rather than a separate translation table per entity. It holds the dynamic, non-interface strings for the whole app, keyed by which table and row the string belongs to, which field it is, and which locale it is in. Adding a translated entity later then costs no schema change at all, which is the same reason quotas are keyed by category id rather than bolted onto a category record.

Keep the boundary clean. A string that exists because the interface says it, such as a button label, a heading or an error, belongs to i18n and never to this table. A string that exists because the user typed it belongs to this table and never to i18n. Nothing is duplicated across both.

**Every form that creates such a row collects every supported locale at once, so the create screen shows a French input and an English input side by side rather than one input and a promise to translate later.** A row saved in one language only is a row that renders as a gap or as the wrong language for the other, and asking the user to come back and fill it in is the kind of half-finished state the no-invalid-states rule exists to prevent. This project is French first and English second, so the French input leads.

### A migration is for schema, not for data the seed owns

Write a migration when the database structure changes. A table, a column, an index, a constraint, a type. Do not write one to rewrite rows that only exist because the dev seed put them there, because the seed already owns those rows and rebuilds them on the next run, so the migration duplicates work that is about to happen anyway and then sits in the history implying a structural change that never occurred.

Check who owns the rows before reaching for a migration. Dev and test data is seed-owned and dev-only, so it is fixed by editing the seed. Real user data is migration-owned, and only that needs a backfill.

This matters most when a stored value is renamed or split. If a column is free text with no CHECK, enum, or foreign key, then new values are already storable and there is no DDL to write at all, so the only question left is who rewrites the existing rows. And when a rename splits one value into two, a backfill has to pick a side for a distinction the old rows never recorded, which writes a guess permanently into the history. Rewriting the seed avoids inventing that answer. If real user rows are affected and the mapping is genuinely unknowable, stop and ask rather than choosing for the user.

### Migrations are additive and are never edited in place

**A migration file is append-only once it exists. Every change to the schema is a new numbered file, never an edit to an old one.** This holds even when the old file has not been applied anywhere yet, and even when editing it would produce a tidier history, because "has this run somewhere" is a question about every database that has ever pointed at this repo rather than about the one on the desk right now.

The reason is that a runner decides what to apply by comparing files against a ledger, and a ledger keyed on the filename cannot see that a file's contents changed. An edit to an already-applied file is skipped in silence, and the code then expects a schema the database does not have. A ledger storing a hash catches this, which is one of the real arguments for using the tool's own migrator rather than a bespoke runner.

Additive also governs the SQL. Prefer adding a table, a column or an index over rewriting or removing one, and when something genuinely has to go, let the removal be its own file so it can be reasoned about on its own. A destructive statement is not forbidden and it is never bundled, so a `DROP COLUMN` rides alone rather than sharing a file with the additions around it.

Two failures this rule was written from, both in one session. A migration was edited in place on the recorded basis that it had never been applied, which was true and which still left the assumption sitting in a comment where no future run could check it. And `drizzle-kit generate` was run in a project keeping no meta snapshot, so it read the entire existing schema as new and emitted a full `CREATE TABLE` for every table, which the runner then tried to apply over a live database. The first is a rule about files. The second is why the idempotency rule below is not optional.

### Migrations must be idempotent and crash-resistant

Every migration must be safe to re-run and must complete even after a partial failure or a crash, so running it again always drives the schema to the target state no matter where a prior run stopped. Never write a migration that only works against one exact starting state.

- Use `IF NOT EXISTS` / `IF EXISTS` wherever the SQLite dialect supports it: `CREATE TABLE IF NOT EXISTS`, `CREATE INDEX IF NOT EXISTS`, `DROP TABLE IF EXISTS`, `DROP INDEX IF EXISTS`.
- SQLite does not support `IF [NOT] EXISTS` on `ALTER TABLE ADD COLUMN` or `DROP COLUMN`, so guard those instead. Read `PRAGMA table_info(<table>)` first and skip the statement when the column already matches the target, or run through a runner that catches the benign `duplicate column name` and `no such column` errors and continues rather than aborting the whole migration.
- Make backfills re-runnable. Use `INSERT ... WHERE NOT EXISTS` or `INSERT OR IGNORE` so a second run does not duplicate rows.
- Apply through a runner that executes statement by statement and continues past statements that are already satisfied, so a crashed migration finishes cleanly on the next run rather than getting stuck halfway.

## Validation

- Zod for all input validation. Validate at the server boundary (request body, params, query) before touching the database.

## Server routes

- `defineEventHandler` with `readValidatedBody` or `getValidatedQuery` and the Zod schema, so the input is validated before anything else runs.
- Upserts are idempotent, keyed on a stable id or hash.
- `useRuntimeConfig()` for every secret and environment value. Never `process.env` in a handler. The Turso token is server-side only and never reaches a composable or the client bundle.
- `createError({ statusCode, message })` for expected failures. Let Nitro handle the unexpected ones. Never swallow an exception.

- Nitro server routes under `server/`. Keep handlers thin: validate, call a small typed function, return. Push reusable logic into `server/utils`.

## List endpoints

List endpoints paginate, sort, and search on the server, never on the client. The client sends the page, page size, sort column, sort direction, and search term as query params, and the endpoint returns only the rows for that page plus a total count. Client-side sorting or filtering only reorders the rows already loaded, so it silently breaks the moment the list spans more than one page. Do the work where the whole dataset lives.

- Accept `page`, `pageSize`, `sort`, `order`, and `search` as validated query params. Use `z.coerce.number()` for the numeric ones with sane defaults and a max page size.
- Whitelist the sortable columns with a Zod enum. Never sort by a raw column name taken from the query string.
- Return the page rows plus a `total` count so the client can render pagination without loading everything.
- Push the paging, sorting, and filtering against the full dataset. When a list is assembled in memory from more than one source, filter and sort the merged set before slicing the page, not after.

## Auth

- Owner-managed auth with `nuxt-auth-utils`. No public signup and no third-party identity providers unless a project explicitly needs them.

## Email

- Resend for transactional email.

## Tooling

- Bun for scripts and seeding.

## Ownership of logic

- Own every decision the client would otherwise make. A derived value is resolved before it is sent, so the response carries the finished answer rather than a raw row plus the rules for reading it. A derived field with no column behind it is legitimate. Document it as derived on the response type.
- Push the decision into the query when the data layer can make it, with a `CASE` expression or a computed column, rather than looping over rows in application code. Pass what the comparison needs, such as the current instant in the user's timezone, as a bound parameter.
- A rule enforced only in a component is not enforced. When both sides need the same pure rule, it lives once in `shared/` and both import it.

## Recovery

- Never leave data or auth in a state the user cannot recover from. Writes and multi-step flows can be interrupted and tokens can expire, so each outcome is fully applied or safely restartable. Recovery fails closed. It never becomes an auth bypass, never reveals whether an account exists, and never lets one user act on another's data.
