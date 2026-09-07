---
name: frontend
description: AGilbertDev's frontend conventions for Nuxt/Vue projects — component and composable choices, solution priority, icons, and page performance. Use when building UI, components, or pages in a personal Nuxt project, or when a page is slow and you need to find what is actually costing the time. Pairs with nuxt-conventions:styling for Tailwind and theming.
---

# Frontend conventions (Nuxt / Vue)

## Solution priority

Reach for solutions in this order, and stop at the first that fits:

1. Nuxt UI components and composables
2. Nuxt core features
3. Custom Vue
4. Tailwind utilities for styling gaps

Look up the official docs and explain the reasoning rather than guessing. When naming a component or API, name it exactly (for example `UFormField` with a `UInput` inside) so it is easy to look up.

## Components

- Prefer Nuxt UI primitives (`UButton`, `UCard`, `UForm`, `UModal`, `UTable`, `UInput`, and so on) before building custom.
- Vue 3 Composition API with `<script setup>`. Keep components small and composable; pull shared logic into composables.

## Creating a row the user names

A form that creates a row carrying a user-supplied name collects that name in **every supported locale at once**, so the screen shows a French field and an English field side by side rather than one field and a promise to translate later. French leads, since the app is French first.

The names go to the `translations` table described in `nuxt-conventions:backend`, never into the locale JSON files. Interface copy is i18n and ships with the app. A name the user invents at runtime is data and lives in the database. Do not let a component read one from the other.

## Data mutations and cache invalidation

Always invalidate the client cache after a mutation. Any write that changes server state (a `$fetch` POST, PATCH, or DELETE) must be followed by refreshing whatever client-side cache reads that state, so the UI reflects the change without a full page reload.

- Data loaded with `useFetch` or `useAsyncData`: call the returned `refresh()` after the write, or `refreshNuxtData(key)` for a shared key.
- State that lives in the `nuxt-auth-utils` session (anything read off `user`): call `fetch()` from `useUserSession()` after the write so `user` re-reads.
- State derived from the session once does not re-derive when `user` re-reads. A `useState` seeded from `user` (for example the `useTheme` light and dark ids) and the active i18n locale keep their first value, so re-apply them by hand in the same success handler by setting the `useTheme` state and calling `setLocale`. Refreshing the session alone leaves these looking reverted.
- An optimistic local update is fine for responsiveness, but the authoritative refetch still has to run so the cache and the server agree.

Never rely on the next navigation or reload to pick up a change. A stale client cache after a mutation is a bug.

## Server state with TanStack Query

Use TanStack Query (`@tanstack/vue-query`) for reading and writing server state, layered on Nuxt's data fetching. Register it once in a Nuxt plugin with SSR hydration, dehydrating on the `app:rendered` hook and hydrating on the client.

- Query keys live in one factory file, `app/queries/keys.ts`, exported as a `queryKeys` object with a function per key. A key is never hand-typed at a call site, so the keys a mutation invalidates always match the queries that produced them.
- Query and mutation composables live in `app/composables/`, auto-imported, named `useXxxQuery` and `useXxxMutation`. A page reads and writes server state through these composables rather than a bare `$fetch`.
- Every mutation invalidates the affected query keys in `onSuccess` with `queryClient.invalidateQueries`. Session-backed state is not in the query cache, so it is still refreshed through `useUserSession().fetch()` in the same `onSuccess`, following the mutations section above.

## Loading state on submit

Every form submit shows a loading state on its submit control while the write is in flight. Bind the submit `UButton`'s `:loading` to the mutation's `isPending`, or to the local in-flight flag when the write is not a TanStack mutation, and keep the control disabled until it settles. A slow write is then never mistaken for a dead button and cannot be double-submitted.

## Icons

- Phosphor is the default set, via the Nuxt UI icon prop (`i-ph-*`). Match the icon weight to the text it sits with: use the `-bold` variants next to bold or large text so the glyph does not look thin, and scale the icon up as the text scales. Pick one weight family per project and stay consistent.
- Simple Icons for brand and logo marks only (`i-simple-icons-*`).

## Page composition

- Build a long landing or portfolio page as one route that scrolls through sections, each its own component under `components/home/` (hero, about, experience, and so on), assembled in the page. Keep the page file a thin list of those sections.
- A small reusable `SectionHeader` component (a mono `text-primary` kicker plus the section `h2`) keeps headers consistent. Exactly one `h1` (the hero), one `h2` per section, in order.
- For in-page anchor nav, keep the section ids in one composable (for example `useSectionId`) so the nav links and each `<section :id>` always agree. On a bilingual site make the ids locale-aware there (`#a-propos` / `#about`), and translate the current hash when toggling locale so the toggle stays on the same section.

## Performance

Find the bottleneck before changing anything, in this order.

1. **TTFB.** Is the page cached at the CDN, or does every visit run a function? On Vercel, `curl -sI <url> | grep -i x-vercel-cache`. `MISS` every time means nothing is cached. Measure a request after the site has been idle, because on a quiet site the cold start is the normal arrival.
2. **Render-blocking CSS.** The stylesheet in the head holds up the first paint.
3. **The JS bundle.** Run `nuxi analyze` rather than guessing what is in it. Module scripts are deferred, so the bundle blocks interactivity rather than paint.
4. **Fonts.** Count the files and weights actually rendered, not the ones configured.

A skeleton only helps for something that arrives on a later request than the markup. Server-rendered text ships in the same response as any skeleton standing in for it, so the skeleton waits exactly as long and then shows a grey box first. An image is a separate request, so `@nuxt/image`'s `placeholder` is worth having.

### Prerendering and i18n

`routeRules: { '/': { prerender: true } }` puts a page on the CDN and removes the function, which on a quiet site is the biggest win available.

It does not combine with browser-language detection. A prerendered page gets no request, so `detectBrowserLanguage` has nothing to read and silently never fires. ISR does not rescue it either, because i18n writes its cookie on every render and Vercel will not cache a response carrying `set-cookie`. On a prerendered bilingual site, set `detectBrowserLanguage: false` and let the language toggle do the switching. `hreflang` and the canonicals still send search engines to the right URL, so only the first-visit redirect is lost.

## Scroll reveal

- Reveal sections on scroll with a small client plugin: add a `js` class to `<html>`, hide `[data-reveal]` elements only when that class is present (so a no-JS render still shows everything), then add an `is-in` class through an `IntersectionObserver` on mount and after each navigation. Stagger children with a `--reveal-i` custom property. Gate the whole effect behind `prefers-reduced-motion`.

## Pages

- `useSeoMeta()` on every page component, with `title` and `description` at minimum. The `seo-checklist` skill has the full list for public pages.
- Keep components small. A second `<script setup>` concern means a split.

## i18n

- `useI18n()` for every user-facing string. Never hardcode copy in a template.
- Add the `fr` and `en` keys at the same time, in the matching locale files.

## Boundaries

- Never write server route or database code in a `.vue` file.
- Be a view with as little brain as possible. Draw what the server hands you. A derived value arrives resolved. When the response lacks the data you need, the fix is a backend change, not a computation here.
- Only presentation logic belongs in a component. Focus, open and closed state, hover and transition, a visual breakpoint, and display formatting of resolved data.
- Never let a component be the only thing enforcing a rule. Mirror it on the server.
- When both sides need the same pure rule, import it from `shared/`. Never copy it.
