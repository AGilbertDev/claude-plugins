---
name: styling
description: AGilbertDev's styling conventions and visual identity for Nuxt/Tailwind projects — semantic-token theming, Hanken Grotesk type, fluid clamp() sizing, dark mode, and accessible Nuxt UI components. Use when styling components or pages, building responsive layouts, matching the brand, or setting up a theme. Pairs with nuxt-conventions:frontend.
---

# Styling conventions (Tailwind / Nuxt UI)

The visual identity shared across AGilbertDev's Nuxt projects (portfolio, time-tracking, resume). Starting defaults, adjust per project. Pairs with nuxt-conventions:frontend for component choices and icons.

## Stack & foundation

- Tailwind v4 + Nuxt UI v4. `main.css` is just `@import "tailwindcss"; @import "@nuxt/ui";` plus a small `@theme static` block.
- Utility-first. Avoid custom CSS files. When custom CSS is unavoidable, keep it in `main.css` (font var, palette ramps, base tweaks), not scattered across components.
- Self-host fonts through `@nuxt/fonts`: declare the family in `@theme static`, no manual `<link>`.

## Brand & color

- Brand sans is **Hanken Grotesk** (set as `--font-sans` in `@theme static`). Lato is the old print-only font, not for web.
- Personal/portfolio palette is **teal primary on dark navy**, inspired by Nuxt's own system. Product apps pick their own primary.
- One primary + one neutral, themed through Nuxt UI. Set them in `app.config.ts` (`ui.colors.primary`, `neutral`); never hardcode a second palette.
- Define the palette in ONE place: color ramps in `main.css` `@theme static`, semantic mapping in `app.config.ts`. A palette change is one edit, not many.
- Reserve status colors (`success`/`info`/`warning`/`error`) as fixed Nuxt UI colors so they always read the same, never recolored by the active theme.
- Derive on-brand accents from the primary with oklch relative color (`oklch(from var(--ui-primary) l c calc(h + 25))` to shift the hue toward cyan, `calc(l * 1.1)` to lighten) rather than hardcoding a second hue, so accents track a retheme.

## Semantic tokens, never raw color

- Style with Nuxt UI semantic classes: `bg-default`/`bg-muted`/`bg-elevated`, `text-highlighted`/`text-muted`/`text-dimmed`/`text-primary`, `ring-default`/`border-default`. In raw CSS use the vars (`--ui-text`, `--ui-primary`, `--ui-bg`, `--ui-border`).
- A hardcoded hex is acceptable only for a one-off decorative surface (for example a fixed image backdrop), never for text or UI chrome.

## Theming & atmospheres (optional, advanced)

- For multi-theme apps, define each theme as a `[data-theme="x"]` block in `main.css` that overrides the `--ui-color-primary-*` and `--ui-color-neutral-*` 50–950 ramps. Nuxt UI derives every surface, border, text, and hover shade from those.
- Drive it from a `useTheme` composable: independent light and dark picks persisted in separate cookies, applied to `<html data-theme>`, with a synchronous no-flash inline script in `app.vue` so the correct theme paints first.

## Dark mode

- Every project supports light + dark via `useColorMode`. Design both, not just one.
- Logos: either swap two SVGs (`dark:hidden` / `hidden dark:block`) or use one inline SVG colored with `var(--ui-text)` / `var(--ui-primary)` so it adapts to theme and mode with no extra files.
- Guard color-mode-dependent UI with `<ClientOnly>` and a sized fallback to avoid a hydration mismatch.
- On very dark canvases, lift `--ui-border` toward neutral-600 so nav, footer, and card separators stay visible.

## Typography

- Larger base text: `body { font-size: var(--text-lg) }`, and default Nuxt UI components to `size: 'md'` (with `text-md`) in `app.config.ts` so the whole UI scales up together.
- Big titles: `font-extrabold tracking-tight`. Section titles: `font-semibold`. Small eyebrow/label text: `uppercase tracking-wide` or `tracking-widest`, often `text-primary`.
- Body paragraphs: `text-justify` and `hyphens-none`. Never break a word with a hyphen anywhere on the site. Applies to prose and descriptions, not to centered headings or short subtitles.

## Fluid, single-viewport sizing (signature)

- Pages are built to fit one viewport without scrolling on desktop: wrap content in `min-h-full flex items-center` and let it scale to fit.
- Scale type, spacing, gaps, and image sizes with `clamp()` rather than fixed `sm:`/`lg:` steps. Pattern: `text-[clamp(1.5rem,1.6vw+0.5rem,3.5rem)]`, `gap-[clamp(0.75rem,2vh,1.5rem)]`, `size-[clamp(10rem,28vw,16rem)]` — a mobile minimum, a fluid middle, a large-screen maximum.
- Mobile-first otherwise: use `min-h-dvh` (not `min-h-screen`), and step padding and margin up at `sm:` and `lg:`.

## Layout

- Build the shell from Nuxt UI Pro layout components: `UHeader` + `UMain` + `UFooter`; pages with `UPage`/`UPageBody`/`UPageHeader`/`UPageHero`; nav via `UNavigationMenu`; dividers via `USeparator`.
- Horizontal padding scale: `px-6 sm:px-6 lg:px-8` (a touch more on mobile). Set it once globally through `ui.container` in `app.config.ts` so every section agrees.
- Space stacked sections with fluid vertical padding, for example `py-[clamp(4rem,10vh,8rem)]`.
- Container widths step up: `lg:max-w-5xl xl:max-w-6xl 2xl:max-w-7xl` for wide layouts, `max-w-2xl` for prose, `lg:max-w-md` for forms. Center with `mx-auto`.

## Components

- Buttons: `UButton` with `color` + `variant`. Primary action is solid primary, often with a leading `icon` and a bold trailing arrow (`trailingIcon="i-ph-arrow-right-bold"`). Secondary is `color="neutral" variant="outline"`. Icon-only (social links, toggles) is `variant="ghost"` plus an `aria-label`. Register custom sizes in `app.config.ts` for oversized CTAs (for example a `2xl`); make oversized buttons scale down on mobile (`text-base ... sm:text-xl`) and stack full width so long labels never truncate.
- Cards: `rounded-2xl bg-default ring ring-default` (a ring, not a border), `hover:ring-primary`; on media, `group-hover:scale-105` with `transition`.
- Round media (avatars, portraits): size by width with `aspect-square` (`w-full` inside a width-bounded wrapper), never by height with `w-auto`. Height-driven sizing stretches into an oval the moment a narrow column constrains the width. It must always be a perfect circle.
- Tags: `UBadge color="neutral" variant="subtle" size="sm"`.
- Forms: `UForm` + `UFormField` + `UInput`/`UTextarea` (`class="w-full"`), `space-y-4`, a `validate` function returning an errors array, real `autocomplete` values, a right-aligned submit button with a `:loading` state, and `UAlert variant="subtle"` for success and error.

## Accessibility (non-negotiable)

- Skip-to-content link: `sr-only focus:not-sr-only`, targeting a `tabindex="-1"` `UMain#main-content`.
- Focus ring on every interactive element: `focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary`.
- `aria-label` on every icon-only button and link.
- Lean on semantic tokens so contrast holds in both light and dark.

## Motion

- Subtle and purposeful only (a card hover scale, a flip on the locale toggle). Always gate transitions behind `@media (prefers-reduced-motion: reduce)`.

## Signature glow (optional, on-brand)

- A slow spinning gradient border is the signature accent. Implement it once as a `.btn-glow` utility in `main.css`: an absolutely-positioned `::before` with `border-radius: inherit`, a `conic-gradient` masked into a thin ring (`mask` + `mask-composite: exclude`), an animatable `--btn-angle` through CSS `@property` spinning slowly (about 7s), and a soft `box-shadow` glow. Reveal it on `:hover`; a `.glow-on` modifier keeps it lit permanently (used around the portrait). Gate the spin behind `prefers-reduced-motion`. Put the ring `::before` above the content (`z-index: 1`) so it shows over media that reaches the edge.
- Keep the ring on-brand and legible on any button color: sweep between the brand colors (teal and a hue-shifted cyan) with a lighter glint, all derived from the primary via oklch relative color so nothing hardcodes a second hue.
- A faint page-level glow (a large, low-opacity radial of the primary, hue-shifted) anchored top-right and bled down through the first sections adds depth. Keep it fainter on the dark canvas so it never muddies the navy.
