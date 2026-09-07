---
name: quebec-french
description: Rules for writing Québécois French copy, including the U+00A0 no-break space before ? ! : ; and how to check it. Use before writing or reviewing any French UI copy, locale file, or French prose.
---

# Québécois French copy

All French copy is Québécois, never français de France. Follow my own usage. Write "dans mon temps libre" rather than "sur mon temps libre", treat "un stack" and "mon stack" as masculine, and use "outils" rather than "outillage". Colloquial Québécois fits my voice, for example "le fun à faire". Write what I would actually say, and never adjust toward France French.

Every visible French string must be researched and correct, never guessed. When a term has an established Québec usage in the domain, use that one.

## Punctuation

French punctuation uses a real no-break space before `? ! : ;`, and that character is U+00A0. Not U+202F, the narrow no-break space, and not a plain space. Write it into the locale file as the literal character rather than as an escape. A JSON ` ` renders correctly and then reads as a plain space to every grep, diff, and reviewer, which is how one gets deleted by accident.

## Checking it

Check with `grep -P '\x{00A0}'` and never with `grep -P '\xc2\xa0'`. The byte-pair form looks right and silently reports nothing when `grep` is a wrapper around `ugrep`, which reads those escapes as two codepoints in a UTF-8 locale. Prove whichever form you use against a probe file holding a known U+00A0 before trusting its silence. Prefer a committed test asserting the rule over a command run by hand.

## Dates

`Intl.DateTimeFormat` produces no French ordinal, so "1 août" comes out where French wants "1er août". Use `formatToParts` with `Intl.PluralRules` of type `ordinal`. For `fr-CA` it returns `one` for 1 and `other` for everything else, which is exactly the French rule.
