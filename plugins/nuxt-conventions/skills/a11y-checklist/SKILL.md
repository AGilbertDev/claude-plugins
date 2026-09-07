---
name: a11y-checklist
description: WCAG 2.2 AA checklist for Nuxt pages and Vue components, covering keyboard, focus, ARIA, contrast, media, forms, and structure. Use when a page or interactive component ships, or when keyboard or screen-reader behaviour is broken.
---

# Accessibility checklist for Nuxt pages

Report findings with file, line, the WCAG criterion, and a severity of CRITICAL or WARNING. Implement contained fixes directly. Report architectural ones. Pair with the generic `accessibility` skill when it is installed in the project.

Start with the build-time rules the `styling` skill owns. Skip link, focus ring, `aria-label` on icon-only controls, and semantic HTML for controls. A missing `aria-label` is CRITICAL. Then audit the items below.

## Keyboard

- Every interactive element reachable with Tab in a logical order.
- Focus never trapped outside an intentional modal.
- Custom components such as dropdowns and dialogs implement the correct ARIA pattern.

## Focus visibility

- The focus ring meets 3:1 contrast against adjacent colours.

## ARIA

- `aria-labelledby` or a visible label on every form field.
- No ARIA role on an element that already has the right native semantics.
- Dialogs carry `aria-modal="true"` and manage focus on open and close.
- Live regions for dynamic updates such as toasts and errors.
- `UApp` receives the locale, so Nuxt UI's own strings announce in French on a French page.

## Colour and contrast

- Body text 4.5:1. Large text 3:1. UI components and focus indicators 3:1.
- Nothing conveyed by colour alone.

## Images and media

- Decorative images have `alt=""`. Informative images have descriptive `alt`.
- Videos with speech have captions.

## Forms

- Every input has a visible associated `<label>`, not only a placeholder.
- Errors tied to their input with `aria-describedby`.
- Required fields marked with `aria-required="true"` and visibly.

## Structure

- One `<h1>`, then `<h2>` to `<h6>` in order without skipped levels.
- Landmarks present. `<header>`, `<nav>`, `<main>`, `<footer>`.
- Lists are `<ul>` or `<ol>`, never a run of `<div>`.

## Never

- `tabindex` above 0.
