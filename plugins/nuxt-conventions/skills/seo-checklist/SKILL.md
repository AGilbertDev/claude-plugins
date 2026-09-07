---
name: seo-checklist
description: On-page SEO checklist for Nuxt pages, covering useSeoMeta, structured data, sitemap, robots, Core Web Vitals hints, and hreflang. Use when a public page ships or the user asks to improve search visibility.
---

# SEO checklist for Nuxt pages

Check every item on the page being shipped. Implement contained fixes directly. Otherwise report a prioritised list.

## Per-page meta

- `useSeoMeta()` with `title`, `description`, `ogTitle`, `ogDescription`, `ogImage`, and `ogUrl`.
- Title between 50 and 60 characters. Description between 140 and 160.
- `ogImage` is an absolute URL. Relative paths do not work for Open Graph.
- A canonical URL on pages with query-parameter variants.

## Structured data

- JSON-LD through `useHead` where a schema type fits the page, such as `WebPage`, `Article`, `BreadcrumbList`, or `JobPosting`.

## Crawlability

- `@nuxtjs/sitemap` configured and `sitemap.xml` generated, with dynamic routes included.
- `robots.txt` correct. Never `Disallow: /` unless every crawler is meant to be blocked.

## Core Web Vitals hints

- Images through `<NuxtImg>` with `width` and `height`. `loading="lazy"` off the fold, `fetchpriority="high"` on the LCP image.
- Fonts through `@nuxt/fonts` with `display: swap` or `optional`, so nothing shifts.
- Above-the-fold content renders server-side.

## i18n

- `hreflang` alternates for every locale on multilingual pages.
- French and English meta content both present and accurate.

## Never

- A production page without `title` and `description`.
- A keyword-stuffed description. Write for people.
