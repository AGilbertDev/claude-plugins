# AGilbertDev conventions (always-loaded core)

These are my always-on personal conventions. They are true in my personal projects regardless of the task. Each project imports this file from its own `CLAUDE.md` (with `@.recipes/CLAUDE.md`), so it loads every session. Claude Code only auto-loads `CLAUDE.md`, not `AGENTS.md`, which is why this lives here and loads through an import. Stack rules are not here. They live in on-demand skills, listed at the bottom.

## Capturing new rules — mandatory

Every rule I give you is a standing convention, not a one-off for the current task. When I state a new rule, capture it in the shared recipes before acting on it. Core conventions go in this file in `agilbertdev-recipes`. Stack rules go in the relevant skill. Agent behaviour goes in the matching file under `agents/` in the same repo. Push the change, then update the `.recipes` submodule pointer in the current project so the rule loads back in. This rule is itself a convention, so it lives here.

**Push a recipes change straight to `main` and bump the pointer in the same breath. Do not open a pull request and do not wait for me.** This is a deliberate exception to the rule below that the default branch is mine to merge, and it applies to `agilbertdev-recipes` only, never to a project repo. The reason is that a convention I have just stated is not in force until the pointer moves, so a pull request sitting unmerged means the rule is captured on paper and absent from the session that needed it. There is nothing to review either, since the content is my own instruction written down. Commit it, push it to `main`, bump the submodule pointer in the project, and tell me it is done.

**Never use `git stash`.** Not to park a change, not to peek at another state, not to keep a tree clean while running a check. It has cost me work once already. Two reasons it is worse than it looks. It ignores submodule pointer changes, so a stash of a submodule-only change saves nothing and reports success, and a later `pop` then reaches back to some unrelated stash from a previous session and drops conflicts across the tree. If a check genuinely needs a different state, use a temporary copy of the file, `git show <ref>:<path>` piped to a scratch path, or a throwaway clone, and leave the working tree exactly where it is.

**A review comment that keeps coming back is a missing rule.** When the same point is raised on a second pull request, whether by me, by a reviewer, or by an automated one like CodeRabbit, fixing the instance is only half the job. Capture it as a convention in the right place so there is no third occurrence, because a recurring comment is evidence that the rule was never written down rather than evidence that the code was careless. The same goes for a correction I find myself repeating and for a mistake an agent makes the same way twice.

When a recurring comment is wrong, write down why it is declined rather than re-arguing it each time. A convention that records a settled refusal saves exactly as much work as one that records a settled requirement, and without it the next reviewer reopens a question that already has an answer.

## Never leave broken work in the open — mandatory

**If you break something, finish fixing it before you hand the turn back. Do not leave it sitting there for me to trip over.** A turn does not end with a broken working tree, conflict markers in a file, a dev server serving a stale or crashed build, a database whose schema disagrees with the code, a migration applied on one environment and missing on another, or a half-run script. Any of those costs me more to discover than it would have cost you to close out, and I discover them by having the app blow up in my face.

Fix it rather than reporting it. Never hand me an instruction to repair your own mess, so no "restart the dev server", no "run the seed again", no "you may want to reset that file". Restart it, run it, reset it, then tell me it is done. The only reason to hand a repair to me is that it genuinely needs credentials or a decision I alone hold, and then say so in one line rather than burying it.

Prove the fix rather than asserting it. Produce a positive result from the thing that was broken, so load the page, run the suite, query the table, and report what came back. "Should work now" is not a finding.

When you truly cannot finish, put what is still broken in the first line of your reply, in plain words, with the exact state it is in. A known break I can see is recoverable. A silent one is what wrecks an afternoon.

## An answer of mine is acted on in the same turn — mandatory

**When I answer a question, the first thing you do is deliver that answer wherever it was needed. Before anything else, in the same turn, no exceptions.** An answer that reaches you and stops there is worse than never asking, because I believe the work is moving and it is not. This has cost hours twice in one session, both times with the decision sitting in a reply while a pipeline waited on it.

The failure never looks like a failure from where you sit. You asked, I answered, the exchange felt complete, and the turn ended. Nothing errors. The gap only shows up as silence, and silence is what you are worst at noticing, which is exactly why the rule is about ordering rather than vigilance. Relay first, then report, then think about what is next.

**Treat a stall alert as a bill you owe rather than a fact about a process.** When a watch reports that nothing is moving and something is waiting on a decision, the first thing to check is whether I have already given you the answer and you are sitting on it. Act on the first alert. If a second one arrives about the same wait, that is not information, it is evidence you ignored the first.

**Never report progress you have not caused.** Saying a stage is running when it is parked on an answer in your own transcript is a false status, and a false status is worse than no status, because it converts my waiting into confidence.

## Conventions over invention — mandatory

Follow the established conventions of the framework, the language, and the ecosystem, always. Use the documented way the tool already provides rather than a bespoke pattern, folder layout, or abstraction of my own. Do not invent anything. If a convention exists, it wins by default, even over something that looks cleaner to me in the moment. The only reason to depart is that I explicitly say I prefer a different way, and when I do, capture that preference as its own rule so the exception is written down rather than reinvented each time.

**Look up what already exists in the industry before designing anything. Do not reinvent.** Whatever I am building, somebody has built something close to it, and how they solved it is evidence I want before we commit to a shape rather than after. So research the existing products in the domain, read how they actually model the problem, and tell me what you found and where our shape agrees or differs. Prior art is not a formality to cite once the decision is made, it is an input to the decision, which means it comes first.

This is not the same rule as following framework conventions, and it is broader. That one is about the documented way a tool already provides. This one is about the way an industry already answers a problem, which no framework documents and which I will not know unless somebody looks. Name the products, say what each does, and be specific about mechanism rather than saying they solve it well.

Report honestly when the research says we got it wrong, and just as honestly when it says we got it right, because a comparison that only ever validates the current plan is worth nothing. When our shape differs, say whether the difference is a deliberate advantage or an accident, and say what changing course would cost from where we are. The best moment to find this out is before anything is applied or shipped, and the second best is immediately.

This rule was written from a real cost. A quota was built as an effective-dated lookup table, which is a legitimate and standard pattern, and the research done afterwards showed that tools in this exact domain solve it by locking the figure onto the record instead, which is simpler and removes a whole class of date handling. The research would have taken minutes at the start and it arrived after a feature had been built, reviewed, and opened as a pull request.

Always enforce separation of concerns. Keep client code, server code, and shared contracts apart, give each module one responsibility, and put shared logic where both sides can reach it rather than duplicating it or reaching across a boundary. In a Nuxt project this means `app/` for the client, `server/` for Nitro, and `shared/` for the contracts both use. When conventions compete, the one that preserves separation of concerns wins.

A default the tool ships with is not the same thing as its convention, so this is no reason to follow one off a cliff. When a documented default makes the site materially worse for a visitor, look for another supported configuration that gives up a feature I can afford, before either swallowing the cost or building something bespoke. Never invent a workaround to protect a feature without first checking the feature is worth its price, and give me that price in numbers. A feature is affordable when the visitor has an obvious manual path to the same place. On the portfolio, i18n's automatic language redirect lost to a one to three second blank screen, because the language toggle sits in the navbar. Turning that detection off was still using the module its documented way. Rebuilding the detection in edge middleware was not.

## Any list is customizable, modular, and extensible — mandatory

**Never hardcode a set the user might want to change. Categories, statuses, tags, types, kinds, labels, priorities, and every other list of named things are user-owned data, not constants in a file.** Assume from the first version that the set will grow, that a member will be renamed, that one will be retired without deleting the rows that reference it, and that the user will want their own on top of whatever ships as a default. Building for a fixed list and opening it up later is a migration, a contract change, and a rewrite of everything that switched on the old members, so pay for extensibility on the way in where it costs almost nothing.

What that means in practice. Ship the defaults as data the user owns rather than as a union type nothing can add to. Key related settings by the member's id so a member that does not exist yet is already accepted. Keep the display name in the i18n layer keyed by id, never in the stored value, so renaming a label never touches data. Give a member its own declared flags rather than letting code special-case one id, because a user-created member inherits the flags and cannot inherit the special case. Guarantee by construction anything a new member needs, such as a colour that is readable or a sort position that is stable, rather than curating a list of pre-approved options.

Two things this does not license. It is not permission to build a full editor before the feature that needs one, since the point is that the data model accepts growth rather than that every screen ships at once. And it does not override one feature per pull request, so the extensible shape belongs in the feature that touches the list and the user interface for managing it can still be its own.

## Logic belongs to the backend — mandatory

All logic is decided backend as much as possible, unless the components are frontend only. The frontend is a view with as little brain as possible. It draws what it is handed and does not work anything out for itself.

So when a value is derived rather than stored, the server derives it and sends the finished answer, and where the data layer can make the decision, make it there rather than in application code above it. A status that depends on the current time, a total, a permission, an ordering, a filter, a page of results, a label chosen between several: all of these are decided server-side and arrive resolved. Do not ship a raw row plus the rules for interpreting it and let the client apply them, and never duplicate a rule on both sides, because two copies drift and the client's copy is the one that goes stale or gets tampered with. A pseudo-status or any other derived field is a legitimate part of an API response even though no column backs it.

The exception is real and narrow: logic that is purely about presentation and has no meaning off the screen stays in the component, because the server has no business knowing about it. Which element has focus, whether a panel is open, a hover or transition state, a value formatted for display from data already resolved, a purely visual breakpoint choice. If the rule would still be true with no user interface attached, it is not presentation and it belongs to the backend.

When both sides genuinely need the same pure rule, it lives once in the shared contract layer (`shared/` in a Nuxt project) and both import it. That is the one acceptable form of sharing; copying it is not.

## No invalid states and safe recovery — mandatory

Never leave the system in a state a user or process cannot get out of. Assume any process can be abandoned partway, any token or session can expire, and any step can be interrupted, and design so the outcome is always either fully done or safely recoverable. For every flow that spans more than one step or one request, work out what happens when it stops halfway, and give the affected user a way to restart or continue that does not depend on state they no longer hold. A dead end is a bug.

Recovery must be safe. It can never become an authentication or authorization bypass, must not reveal whether an account exists, and must not let one user act on another's data. Prefer the documented recovery pattern of the framework over a bespoke one, and when in doubt fail closed and route the user back to a clean starting point rather than leaving them stranded.

## One feature per pull request — mandatory

**One feature, one pull request. Never more, whatever the reason looks like at the time.** A feature is a thing with its own spec, so two spec documents on one branch means two pull requests, not one branch with a well-written explanation.

The reason is not tidiness, it is that nobody can spec a whole app in advance and pretending otherwise is what does the damage. Scope will be discovered mid-build, because that is what building tells you. When it turns up, it belongs in the next pull request rather than this one. A feature that grows a second feature inside it stops being reviewable, loses the one-at-a-time trail the project exists to demonstrate, and makes every stage after the growth read a spec that no longer describes what is being built.

Discovering scope is not the failure. Absorbing it is. Write the finding down, finish what is open, and let it be the thing that comes next.

**The exception I will not accept is urgency.** "It touches the same files" and "splitting costs hours" are arguments for having noticed sooner, never for bundling. If splitting a branch has genuinely become expensive, that is the cost of having absorbed the scope, and the right response is to say so plainly rather than to treat the expense as permission.

A fix is not a feature and does not need its own pull request, but it does need its own paragraph saying why it is in the diff. A bug fix, a hygiene change, a missing guard, or a correction to something the feature exposed can ride along. A second thing with a spec cannot.

## Measure before you change it — mandatory

When I say something is slow or heavy, measure first and let the number pick the target. Never optimise on a hunch.

Measure the baseline a visitor actually gets. My sites are low traffic, so the function is usually cold when someone arrives and a warm request is the exception. A warm-to-warm comparison on a quiet site hides whole seconds, and it can make a fix worth seconds look worth nothing.

If the number says the thing I asked about is not the bottleneck, say so and name what is, before building anything. When I raise the same idea a third time I am describing a symptom I can see, so go and find its cause rather than explaining again why the idea will not work.

## Git identity

Commit and push with the personal AGilbertDev identity, configured locally in each repo. Never commit with a work identity on a personal repo. Personal Vercel builds also expect the personal identity. A guard hook blocks a commit or push made under a different identity, so set the local identity early.

## The default branch is mine to merge — mandatory

**Never merge into the default branch, and never push to it directly. I am the only one who merges, and only through a pull request.** Work on a branch, open the pull request, and stop there. Landing it is my decision and my click, not the last step of your task, so a finished feature means an open pull request rather than a merged one.

This holds even when the work is obviously correct, the tests pass, and the review is clean. Those are arguments for opening the pull request, never for merging it. It also holds for the tidying that feels like it does not count, so no fast-forward of the default branch, no force push, no branch deletion, and no committing straight to it to fix a typo. If something on the default branch needs changing, it needs a branch and a pull request like everything else.

Protect it on the remote as well as by convention, since a rule only I remember is not protection. On GitHub that is a repository ruleset on `~DEFAULT_BRANCH` requiring a pull request and blocking deletion and non-fast-forward pushes, with no bypass actors. Verify it with `gh api repos/<owner>/<repo>/rules/branches/<branch>`, which reports the rules the server actually applies. Do not verify with `git push --dry-run`, because dry-run skips the ref-update stage where rulesets are evaluated and will happily report a push that the server would reject.

One honest limit to state rather than paper over. Agents run with my credentials, so the remote cannot tell an agent's merge from mine. The ruleset stops direct pushes and it cannot stop a merge made with my token, which is exactly why this is written as a convention too.

## Leave the working branch checked out — mandatory

**Keep the branch you are working on checked out, so I can see the work live on localhost.** The dev server serves the working tree, so whichever branch is checked out is the app I am looking at. Leaving me on the default branch, or on a different feature, or on a detached HEAD, means the running app silently stops matching the work being described, and I end up testing something other than what you changed without knowing it.

If you genuinely have to visit another branch, to run a script against it or to compare, go back the moment you are done rather than at the end of the turn. Never finish a turn on a branch other than the one the current work lives on, and if the work has just landed and the branch is gone, say which branch I am on now instead of leaving me to discover it.

This also rules out building the active feature in an isolated worktree. A worktree is the right tool when parallel agents would otherwise fight over the same files, but code that lives there is invisible to the dev server, so the feature I am supposed to be watching does not appear. When I want to see it live, the work belongs in the main working tree.

## Security

Never read `.env` or secrets files, and never print or echo their contents. This is also enforced by deny rules in `.claude/settings.json`, so a read attempt is blocked rather than trusted to good behavior.

## Confidentiality — mandatory

In any public-facing artifact, use generic descriptions only. Never name clients, their clients, or employers.

**Never mention a real person from my life, and never say where they work.** No partner, no family, no friends, no colleagues, not by name and not by relationship. "The developer's partner" identifies someone just as surely as a name does, and a public repo keeps it forever. When a real person is behind a project, describe them by role and nothing more, so "the primary user" or "a professional translator", never who they are to me. Use they/them for that person throughout, because a pronoun is one more identifying detail and a role never needs one.

**Never describe a third party's internal workings.** An employer's productivity standards, category lists, internal rates, tooling, and processes belong to them and are not mine to publish, even when a project is built around them and even when no name appears. Numbers taken from a real workplace go in as ordinary configurable defaults with no provenance attached, never as "their real numbers".

**Frame the product generically rather than around one person's job.** Build for "a freelance translator" rather than for a specific employed person, so the domain reads as a product instead of as a description of somebody's employment. This is also the better product decision, since the generic framing is the one that can serve a second user.

**This rule is about what gets published, not about what an app stores.** It governs prose, so specs, README files, commit messages, pull requests, and anything else a stranger can read. It says nothing about what my own private tools keep in their own database. Do not turn a confidentiality rule into a product constraint, do not add enforcement the user never asked for, and never let it override "do not police the user" where a project has that rule. If a real name is fine inside the app and only wrong in the docs, then only the docs need fixing.

**A confidentiality question I have not answered gets a durable home, never a pull request body.** Raising it in the body is right and it is not enough, because once the pull request merges the question survives only in the history of something closed, which is where it goes to die. It then takes a fresh review to rediscover the same breach, and the second discovery costs everything the first one already paid. So when a breach is found and the decision is mine, write it into `docs/TODO.md` with the file and the line numbers alongside raising it, so it outlives the branch whatever I decide. This rule exists because the same passage was raised on one pull request, merged unanswered, and found again by a later compliance review.

**This reaches the git history, which is the part that is hard to undo.** A public repo keeps every past commit, pull request title, and review comment, so scrubbing the working tree fixes the present and leaves the past intact. Get it right on the way in. When something does slip through, say plainly that the history still holds it and let me decide whether a rewrite is worth it, rather than quietly cleaning the tree and reporting it as done.

## Writing voice (any prose, including docs, blog, commit messages, UI copy, and PR text)

Humble, honest, and direct. No corporate fluff, and never overclaim skills or results. Write complete sentences like a human. Never use a dash or a colon to join or separate clauses. No em-dashes, no `---` dividers, and no rhetorical setups like "The goal was simple". Prefer plain words and short sentences.

One settled exception, recorded so it stops being reopened. The `— mandatory` suffix on a section heading in this file stays. It labels a heading rather than joining two clauses in a sentence, every mandatory section already carries it, and consistency across the headings is worth more than applying a prose rule where there is no prose. A reviewer flagging it is declined on that basis.

Write English in English. Do not reach for a French word when an English one exists, and do not keep repeating a French term as jargon just because a file, a branch, or a past feature was named that way. Say "simplifying pass", not "alléger". If a French name is already baked into a filename or a spec, refer to the thing in plain English and link the file, rather than turning its name into vocabulary. This is about my English prose only, and it takes nothing away from the Québécois French rules below, which govern actual French copy.

## Talking to me — mandatory

Keep it short. Ask one question at a time, and wait for the answer before asking the next one. Never stack two or three decisions into one turn, and never bundle a question with a wall of context around it. Give me the short version by default and let me ask for more, because a long brief costs me more to read than a follow-up question costs to answer.

Short phrases over full paragraphs when we are working. This is about our conversation, not about prose that ships. The writing voice above still governs docs, commit messages, pull requests, and UI copy, where complete sentences are right.

## Language (Québécois French)

**French punctuation uses a real no-break space before `? ! : ;`, and that character is U+00A0.** Not U+202F, the narrow no-break space, and not a plain space. Write it into the locale file as the literal character rather than as an escape, since a JSON `\u00a0` renders correctly and then reads as a plain space to every grep, every diff and every reviewer, which is how one gets deleted by accident.

**Check it with `grep -P '\x{00A0}'` and never with `grep -P '\xc2\xa0'`.** The byte-pair form looks right, because U+00A0 really is `c2 a0` in UTF-8, and it silently reports nothing when `grep` is a wrapper around `ugrep`, which reads those escapes as two codepoints in a UTF-8 locale rather than as two bytes. That is a confident false negative on exactly the check that is meant to catch a stripped character. Prove whichever form you use against a probe file holding a known U+00A0 before trusting its silence, and prefer a committed test asserting the rule over a command run by hand.

All French copy is Québécois, never français de France. Follow my own usage. Write "dans mon temps libre" rather than "sur mon temps libre", treat "un stack" and "mon stack" as masculine, and use "outils" rather than "outillage". Colloquial Québécois fits my voice, for example "le fun à faire". Write what I would actually say, and never adjust toward France French.

## Running agents — mandatory

**Parallelise everything that has no dependency on everything else.** Launch every stage whose inputs are ready in one message. Design and backend do not wait for each other. Accessibility and unit tests do not wait for each other. Only a real input dependency justifies a stage waiting, and when one does, name the output it is waiting for rather than serialising out of habit.

**Background or foreground is your call, but always leave me a hint that something is running.** A silent finished turn is indistinguishable from being stuck, and I will ask whether you are working. One line naming what is in flight is enough.

**Show me work in progress rather than handing the turn back and going quiet.** A short reply while an agent is still running reads as finished, so I ask whether you have stopped, and the answer costs us both a round trip. Prefer keeping the turn visibly active: do the foreground work that does not depend on the agent, verify something, prepare the next stage's brief. When there genuinely is nothing to do but wait, say what is running and what you are waiting for in those words, so the message reads as a progress report rather than as a conclusion. Never end a turn in a way that looks like an answer when it is actually a wait.

**A hint at launch is not enough. Arm a liveness watch that keeps reporting, so waiting is never ambiguous.** One line when the agent starts goes stale within a minute, and after that a working agent and a dead one look exactly the same from where I sit, which leaves me waiting on a corpse with no way to tell. Never hand back a turn whose only evidence of progress is a sentence I have to trust. Arm something that speaks on its own: a monitor or a background poll that emits when real output lands and, just as importantly, emits when nothing has changed for a few minutes. Silence must mean the watch is broken, never "probably still fine".

Cover death, not just progress. A watch that only fires on success is the same failure again, because a crash, a hang, and a finished run all present as quiet. Emit on new files, new commits, and a stall, and prefer a slightly noisy watch over one that can go silent while something is wrong. Do not spam a fixed heartbeat either; report state changes plus a stall alert, so every message I get means something happened.

**Never silence stderr on a check you are about to draw a conclusion from.** `2>/dev/null` on a diagnostic turns a missing tool, a permission error or a typo into a clean empty result, and an empty result reads as a confident negative. That is how "nothing is listening on that port" gets reported when the truth was that the command did not exist. Keep `2>&1` on anything whose output becomes evidence, and read the error text rather than the line count, because "command not found" is itself one line and looks exactly like a header with no rows.

Before trusting a negative, confirm the instrument can produce a positive. If a check reports the absence of something, prove it can see that thing when it is definitely there, by creating one and looking for it. A tool that reports nothing because it is broken and a world that genuinely contains nothing are indistinguishable from the output alone, and only the second one is a finding.

**Probe running agents on a bounded timeout, in a loop. They crash, and they crash silently.** Never fire an agent and then wait on a single open-ended call, because that is how five minutes disappear on a dead loop. A crashed agent usually leaves nothing behind, so treat "still running" as a claim to re-check rather than a fact, and look at the working tree for real output rather than trusting a status.

When a probe shows an agent died, say so plainly, say what it had produced if anything, and restart it. Never report a crashed agent's work as finished and never guess at what it would have returned.

**Silence is not death, and declaring death has a cost. Prove the agent is gone before you replace it.** An agent parked between turns, an agent thinking, and an agent that crashed all look identical from outside, so a quiet transcript is the one piece of evidence that cannot tell them apart. Before you conclude an agent is dead, check something that would definitely have moved if it were alive, and check that your instrument can show life at all. A watch reading a file that only ever holds the launch prompt will report every agent as idle forever, which is a broken instrument reporting a confident negative rather than a finding.

**Never launch a replacement against the same working tree or the same output path while the original might still be running.** Two agents writing one file is not a race you can referee afterwards, because the loser's work is gone and neither one knows it happened. If a replacement is genuinely needed, either confirm the original is gone first or point the replacement somewhere else and reconcile the two results yourself.

This is written from three occurrences, two of them in a single session. A coordinator declared a spec agent dead after three minutes, launched a duplicate against the same path, and the second overwrote the first. An orchestrator's own liveness watch reported two working agents as dead because it was reading files that never grow. And the project's build trail already recorded the same collision from an earlier feature, which is what makes it a missing rule rather than an accident.

## Context

Solo developer on personal projects. Docs and config steer Claude and my future self, not teammates.

## Agent pipeline — mandatory

Do not write implementation code directly. Every feature, page, route, bug fix, or non-trivial change must go through the agent pipeline.

**How to start:** invoke the `pipeline` agent. It will ask what you are building, build a stage plan, and hand off to each specialist in order. The full sequence is:

`specs` → `design` → `frontend` / `backend` → `compliance` → `seo` → `accessibility` → `unit-test` → `code-review` → `commit`

Stages that do not apply to a given feature are skipped. Specs and code review are never skipped.

The specialist agents live in `.claude/agents/agilbertdev/`, symlinked from the `agents/` folder of the shared recipes repo. They are plain markdown files — the instructions work regardless of which AI tool is running them. A project may add its own agent as a real `.md` file at the top level of `.claude/agents/` to override or extend the shared set.

## On-demand skills

Load these by name when the task matches. They carry the stack rules so this core stays small.

- `my-frontend-conventions` for Nuxt and Vue components, composables, solution priority, and icons.
- `my-styling-conventions` for Tailwind, theming, the visual identity, responsive layout, and accessibility.
- `my-backend-conventions` for server routes, the database, validation, auth, and email.
- `new-project` when scaffolding a new repo from scratch.
- `tutorial-mode` only when a project opts in to learning-by-building.
