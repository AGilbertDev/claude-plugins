---
name: spec
description: How to write a feature spec and the design principles every spec must check. Use at the spec stage of the pipeline, or when the user asks for a spec, a data model decision, or a feature design review.
---

# Writing a spec

This skill is rewritten in the next step of the rebuild. For now it holds the design principles that used to sit in the always-on core. Check every one of them while writing a spec.

## Look up the industry first

Somebody has built something close to whatever I am building. Research the existing products in the domain, read how they model the problem, and say where our shape agrees or differs. Name the products and be specific about mechanism. Report honestly when the research says we got it wrong, and just as honestly when it says we got it right. When our shape differs, say whether the difference is a deliberate advantage or an accident, and what changing course would cost. This comes before the shape is chosen, not after.

## Any list is customizable, modular, and extensible

Never hardcode a set the user might want to change. Categories, statuses, tags, types, kinds, labels, and priorities are user-owned data, not constants in a file. Assume the set will grow, that a member will be renamed, that one will be retired without deleting the rows that reference it, and that the user will add their own on top of the defaults.

In practice. Ship the defaults as data the user owns rather than as a union type. Key related settings by the member's id so a member that does not exist yet is already accepted. Keep display names in the i18n layer keyed by id, never in the stored value. Give a member its own declared flags rather than letting code special-case one id. Guarantee by construction anything a new member needs, such as a readable colour or a stable sort position.

This is not permission to build a full editor before the feature that needs one. The data model accepts growth. The management screen can be its own feature.

## Logic belongs to the backend

The frontend is a view with as little brain as possible. It draws what it is handed. When a value is derived rather than stored, the server derives it and sends the finished answer. A status that depends on the current time, a total, a permission, an ordering, a filter, a page of results, a label chosen between several. All of these arrive resolved. A derived field with no column behind it is a legitimate part of a response.

The one exception is presentation. Focus, open and closed state, hover and transition, a purely visual breakpoint choice, and formatting for display from data already resolved stay in the component. If the rule would still be true with no user interface attached, it belongs to the backend. When both sides genuinely need the same pure rule, it lives once in the shared contract layer and both import it. Copying it is not sharing.

## No invalid states and safe recovery

Never leave the system in a state a user or process cannot get out of. Assume any process can be abandoned partway, any token or session can expire, and any step can be interrupted. Design so the outcome is either fully done or safely recoverable. For every flow that spans more than one step or one request, write down what happens when it stops halfway, and give the affected user a way to restart that does not depend on state they no longer hold. A dead end is a bug.

Recovery must be safe. It can never become an authentication or authorization bypass, must not reveal whether an account exists, and must not let one user act on another's data. Prefer the framework's documented recovery pattern. When in doubt, fail closed and route the user back to a clean start.

## Measure before you change it

When something is slow or heavy, measure first and let the number pick the target. Measure the baseline a visitor actually gets, which on a low-traffic site is a cold function. A warm-to-warm comparison hides whole seconds. If the number says the suspected thing is not the bottleneck, say so and name what is, before building anything.

## A costly default loses to the visitor

A default a tool ships with is not the same as its convention. When a documented default makes the site materially worse for a visitor, look for another supported configuration that gives up a feature I can afford, before swallowing the cost or building something bespoke. Give me the price in numbers. A feature is affordable when the visitor has an obvious manual path to the same place.
