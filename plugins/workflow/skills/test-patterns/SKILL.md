---
name: test-patterns
description: How to write a good test once you already know what to test. Craft rules for pure data versus computed logic, one fact per case, and comment discipline in test files. Use before writing or reviewing any unit test, alongside workflow:spec for what the test should check.
---

# Writing a good test

`workflow:spec` decides what a test checks. This decides how to write it once that is settled.

Grounded in Kent Beck's [Test Desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3) and Google's Testing on the Toilet series, not invented here: a test should be coupled to the code's behavior and decoupled from its structure, and it should read clearly enough that a failure explains itself without narration.

## Pure data versus computed logic

Classify the unit before deciding how to prove it.

**Computed logic** takes input and produces output through a rule of some kind. Derive the expected value independently of the implementation's own formula, so a bug the code and a copied formula would share is not invisible. `test/server/utils/computeQuotaStats.test.ts` in the time-tracking project does this correctly: expected figures are hand-computed literals, not the engine's own arithmetic run a second time.

**Pure data** is a literal, a constant, or a static config value with no computation of its own. It has no formula to independently derive from, so treating it like computed logic produces a named smell, "the ugly mirror": test code that mirrors the implementation instead of checking a behavior. Reconstructing `60 * 60 * 24` from `Date.UTC` epoch math across three cases proves nothing a direct `toBe(86400)` does not, at ten times the length. Assert a constant's value directly, in one case.

The real risk in pure data is never the arithmetic. It is the unit (a millisecond figure landing in a field documented in seconds), or two copies of the same fact drifting apart. Aim the test at that: read the actual consuming source (the config that reads it, the sibling copy it must agree with), not another way to restate the literal.

## One fact, one case

DAMP beats DRY inside a test body: duplicated setup across tests is fine, even preferred, because a test with no test of its own has to be readable in isolation. That is not license to spread one fact across several cases. If two `it` blocks would fail on exactly the same input change, they check the same fact and are one case, not two. `it.each` is for genuinely varying inputs, not for renaming the same assertion three times.

Multiple `expect` calls inside one case are fine, per Beck and the "assertion roulette" smell, as long as they are about one behavior and a failure says which one broke, with an assertion message where that is not obvious on its own.

## Comments in test files

The test's name and body are the documentation. A comment earns its place the way it does anywhere else: a hidden constraint, a subtle invariant, a fixture value that looks arbitrary but is not. Never a running narrative justifying why the test exists or what it is about to do. If a comment would still make sense with the assertion below it deleted, it is not pinned to anything and should go.
