---
name: compliance
description: AGilbertDev's universal privacy, security, and minimum-legal baseline for every project — Québec Law 25 + Charter of the French Language (Law 101/96), PIPEDA, GDPR/UK GDPR, US state laws, COPPA, CASL/CAN-SPAM, consumer protection, accessibility (WCAG/EAA), IP & asset licensing, and digital-sales tax. Security baseline — secrets, encryption, auth, dependency & input hygiene. Use when building anything that collects data, sends email, sells to consumers, uses third-party IP/assets, or needs legal pages/consent. REQUIRED baselines. Store-specific rules (Google Play, App Store) are PROJECT-level — see the project's PLAYSTORE.md, not this skill.
---

# Compliance conventions — privacy, security, minimum legal

Universal baselines for every project. The operator is a **Québec, Canada** business shipping
**commercial software globally**, so several regimes stack. **Not legal/tax advice** — verify with a
lawyer, an accountant, and the CAI before commercial launch. These are engineering guardrails.

Governing principle: **privacy, security, and accessibility by design and by default; minimize data;
make user rights and required disclosures easy.**

> **Scope note:** This skill is what's true for _every_ project. **App-store requirements are
> project-based** (they depend on the platform shipped to) — keep those in the project's `PLAYSTORE.md`,
> not here.

---

## 1. Privacy (multi-jurisdiction)

Collect the minimum; every data point adds a declaration and risk. No analytics/ad SDKs by default.

- **Québec Law 25 (primary):** designate + publish a **privacy officer**; consent must be clear, free,
  informed, granular, purpose-specific (parental under 14); **confidentiality by default** (identify/
  locate/profile features off until opt-in); support **access, rectification, portability, erasure**;
  **assess + disclose cross-border transfer** before storing PI outside Québec (the default stack —
  Vercel/Turso/Resend — is outside Québec, so this is mandatory); run a **PIA/ÉFVP** for new PI systems;
  **breach** → notify CAI + individuals on risk of serious injury, keep a register.
- **PIPEDA (Canada federal):** commercial cross-border/interprovincial data — same accountability base.
- **GDPR + UK GDPR (EU/UK users):** lawful basis per purpose, DSARs, processing records, vendor DPAs.
- **US state laws (CCPA/CPRA etc.):** likely under thresholds, but offer access/delete; we don't sell
  data. **COPPA:** avoid by targeting **13+/18+**; never knowingly collect from under-13.

## 2. Security (baseline)

- **Secrets:** never commit secrets; `.env`/secret files are deny-read (settings baseline). No secrets in
  the client bundle — keep them server-side (Nitro/runtime config).
- **Transport & storage:** HTTPS everywhere; encrypt sensitive data in transit and at rest.
- **Auth:** owner-managed (`nuxt-auth-utils`); hash credentials, secure/HTTP-only/SameSite cookies, CSRF
  protection on state-changing routes.
- **Input:** validate everything at the server boundary with Zod before it touches the DB; parameterized
  queries via Drizzle (no string-built SQL).
- **Least privilege:** minimal scopes/permissions for tokens, DB, and the app itself.
- **Dependencies:** prefer maintained, permissive deps; keep them patched; review before adding.
- **Backups & recovery:** know how to restore data; safeguard signing/upload keys.

## 3. Minimum legal requirements (every consumer-facing project)

- **Legal pages as real routes** (`/legal/*`): Privacy Policy, Terms of Use, EULA (store apps), cookie
  notice, account-deletion page — **available in French with at least equal prominence** (see §4).
- **Consent & cookies:** only strictly-necessary storage without consent; all non-essential
  trackers/cookies **off until opt-in**, with granular accept/reject and a way to change later.
- **Data-subject rights + account deletion:** in-app **and** public web URL to delete; schema deletes
  **cascade** to all personal data; provide data **export** (portability).
- **Email (CASL / CAN-SPAM):** commercial messages need consent, sender identification, working
  unsubscribe; keep transactional vs marketing separate.
- **Consumer protection (Québec CPA + EU):** clear pricing, what's purchased, refund/cancellation terms,
  and rules on auto-renewal/subscriptions, surfaced in-app and in any store listing.
- **Accessibility:** build to **WCAG 2.2 AA** (pairs with the `accessibility` skill); satisfies the EU
  **European Accessibility Act** for EU sales.
- **Digital-sales tax:** stores often act as **Merchant of Record** and remit consumer VAT/GST/QST, but
  you still configure store tax settings and owe **income tax**; confirm **GST/QST** registration.
  **Consult an accountant** — do not guess tax.

## 4. French-language law — Charter of the French Language (Law 101 / Law 96)

Québec-specific, non-negotiable for consumer-facing software offered in Québec. (Law 101 is the Charter;
Law 96 strengthened it.)

- Consumer-facing UI, marketing, and **legal documents** available in **French**, French given **at least
  equal prominence**; contracts of adhesion available in French.
- Aligns with the standing convention that **Québécois French is the default locale** — treat French as a
  launch requirement, not a backlog item.

## 5. IP & licensing

- **Game rules:** mechanics/systems are **not** copyrightable — only the specific _expression_ (rulebook
  text, named spells/monsters/stat blocks = Product Identity) and _trademarks_ are. Build **original
  rulesets inspired by** a genre; do not copy any publisher's text, names, or marks, or imply
  affiliation. (Inspired-by, e.g. a "D&D-inspired" system, is fine; copying D&D content/marks is not.)
- **Dependencies:** all permissive (MIT/Apache-2.0/…) → commercial use OK; ship an **"Open source
  licenses"** screen; preserve Apache `NOTICE` files; never add GPL/AGPL to a proprietary product.
- **Assets (fonts/art/audio):** verify each license allows commercial use; keep an asset-license record.
- **Own IP:** keep proprietary content private; "All rights reserved."

---

## How this shows up in a Nuxt project

- `/legal/privacy`, `/legal/terms`, `/legal/eula`, `/legal/delete-account`, cookie notice — pages,
  **French (equal prominence) + English**.
- A consent composable gating all non-essential storage/trackers, **default-off**.
- Auth/DB schema with **cascading user deletion**; data **export** + deletion endpoints.
- Email with sender identification + unsubscribe (CASL); secrets server-side only.
- An "Open source licenses" screen; original (non-infringing) game rules.
- A short per-project **`COMPLIANCE.md`** tracking: privacy officer, processors + locations, PIA status,
  asset licenses, tax/registration status. Verify with counsel before commercial launch.

## Review output

Report gaps in three tiers. CRITICAL blocks shipping. WARNING is addressed soon. SUGGESTION is hygiene. Never call a feature compliant while a CRITICAL gap is open. A missing French legal page is CRITICAL. Plain-text password storage is CRITICAL in every context. Marketing email needs a consent timestamp recorded per subscriber. For the accessibility audit, use the stack plugin's a11y checklist rather than repeating it here.
