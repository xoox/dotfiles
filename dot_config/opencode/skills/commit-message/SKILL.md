---
name: commit-message
description: Must use when writing or forming a git commit message — any git-commit/PR workflow that produces a commit message. Also use when about to run `git commit` with a `-m` message, when reviewing/editing a drafted commit message before it is committed.
---

# Commit Message

Enforcing overlay for other commit workflow. They owns the workflow (context gathering, convention detection, logical commits, staging, branching). This skill owns **the message**. Where these rules conflict with other commit workflow, **these rules win**.

## Foundational principle

Violating the letter of these rules is violating the spirit of these rules. The 50-char cap and body requirement exist because future readers (and `git log --oneline`) depend on them; "close enough" is the failure mode this skill exists to prevent.

## The commit-message contract

A well-formed commit message IS, in this order:

1. **Subject** — ≤50 chars; imperative mood ("Add", not "Added"/"Adds"); capitalize the initial letter **if no** `type:` prefix is used (That's conventional commit); no trailing period. **Count the characters — it must be ≤50 before you commit; do not eyeball it.** A 52-char subject fails the contract as much as a 200-char one. A subject that joins two changes with "and" (e.g. "Reject empty names … **and** add normalize helper") almost always exceeds 50 — pick the primary change for the subject, or split into two commits.
2. **One blank line** — exactly one, separating subject from body.
3. **Body** — required except for typo/version/format-only commits; wrapped at 72 chars. The body explains **WHAT changed and WHY, not HOW**, from the end-user perspective; specific (no "improved UX"-style generics). Convey purpose, not just mechanics — "greet() raises ValueError on empty input" carries purpose (empty input is now rejected); "added an if-check and a helper" does not. When the change fixes a user-facing problem, name it (e.g. "instead of returning a malformed greeting"). Implementation mechanics belong in code comments or the PR description, not the commit body.
4. **Footer** (only if issue-tracker info is provided or relevant) — at the very bottom, each line verbatim: `Resolves: #N` and/or `See also: #N, #M`. Use whichever applies; do not fabricate a line that has no real reference.

Concrete shape:

```
<subject ≤50, imperative, capitalized if no type: prefix, no period — COUNT IT>

<body wrapped at 72 — WHAT changed + WHY (purpose), not HOW;
end-user perspective; specific. Name the user-facing problem fixed.>

Resolves: #123
See also: #456, #789
```

## Quick reference

| Part | Rule | Failure it prevents |
|---|---|---|
| Subject length | ≤ 50 chars — count it; "and"-joined subjects almost always exceed 50, split or abbreviate | over-long / uncounted subjects |
| Subject mood | Imperative ("Add", not "Added"/"Adds") | past-tense / third-person |
| Subject capitalization | Capitalize initial letter **if no** `type:` prefix | lowercase non-conventional subjects |
| Subject period | None | trailing `.` |
| Subject→Body separator | Exactly one blank line | run-on / multi-blank |
| Body presence | Required except typo/version/format-only | omitted bodies |
| Body wrapping | Wrap at 72 chars | long lines |
| Body content | WHAT changed + WHY (purpose), not HOW; end-user perspective; specific; name the user-facing problem | generic "improved UX", mechanics-only body |
| Footer presence | Only if issue tracker info provided/relevant | decorative/forced footers |
| Footer format | Each line verbatim: `Resolves: #N` and/or `See also: #N, #M`; use whichever applies, at the very bottom | ad-hoc reference styles |

## Worked example

```
fix(batch): enforce 50-char subject and body rule

Subjects over 50 break `git log --oneline` wrapping in narrow terminals,
and bodies were omitted on 11 of the last 20 commits, leaving future
readers no motivation for behavior-changing diffs. Enforce a structural
contract so every non-trivial commit records what changed and why from
the user's perspective.

Resolves: #142
See also: #98
```

## Rationalization table

| Excuse | Reality |
|---|---|
| "The repo has no precedent for bodies" / "matches the repo's terse style" | Repo precedent does not override the body requirement. This skill sets the floor for every non-trivial commit regardless of repo history — a terse history is exactly the problem this skill exists to fix. |
| "The change is small enough that a subject line conveys intent" / "the diff is tiny and self-explanatory" | "Small" is not in the exception. The narrow exception is typo/version/format only. A multi-file behavior change (logic + new module + docs) needs a body; "small" is the rationalization, not the criterion. |
| "I judged a body as not worth the delay" / "under time pressure I would not draft a body" | The rule has no rush exemption. 30 extra seconds writing *why* prevents a useless log entry forever. Time pressure is the failure mode this skill exists to resist, not a valid reason to skip the body. |
| "I kept the body to factual lines so the reviewer has the gist without an essay" | A mechanics-only body is incomplete. The body needs purpose (why the change matters), not a hunk-by-hunk enumeration. "No essay" does not mean "no WHY" — one purpose line is enough. |
| "greet() raises ValueError … Adds utils.normalize helper for stripping/lowercasing … Updates README" (body describes touched files + how the helper works) | That's HOW and what-was-touched. The body is WHAT changed (observable behavior) + WHY (purpose), from the end-user perspective. Implementation mechanics belong in code comments or the PR description, not the commit body. |
| "52 chars is close enough" / "I miscounted" / "it's basically 50" | Count it. `git log --oneline` wraps at 50; 52 breaks it. "Close enough" is the exact failure the foundational principle names. Rewrite until ≤50 — there is no "almost" exemption. Two extra characters is a violation, not a rounding error. |
| "The subject has to capture both changes, so it ran long" | A subject joining two changes with "and" almost always exceeds 50. Pick the primary change for the subject, or split into two commits. One subject, one change. |
| "A 'why this matters' rationale is a fuller paragraph; I kept it terse" | Purpose is conveyed via the behavior description, not a separate essay. "greet() raises ValueError on empty input" already carries the why (empty is rejected). "Terse" does not mean "mechanics-only" — name the user-facing problem fixed and the body has its WHY. |
| "I didn't invent motivation" / "the WHY would be fabricated" / "that context wasn't given" | The WHY is the change's own user-observable impact, read from the diff — not invented context. "instead of returning a malformed greeting" is the WHY for rejecting empty input; it is not fabrication. Articulate the impact the change has on the user. |
| "ce-commit says the body is optional / 'when needed'" | This skill overrides `ce-commit` Step 4 where they conflict. `ce-commit`'s "when needed" loses here: for any commit beyond typo/version/format, the body is needed. `ce-commit` owns the workflow; this skill owns the message, and it requires the body. |

## Red flags — STOP and revise before `git commit`

- Subject not counted, or over 50 chars — count the characters and verify ≤50 before committing; do not eyeball.
- Subject joins two changes with "and" — almost always >50; pick the primary change or split into two commits.
- Subject in past tense or third person ("Added", "Adds", "Updated").
- No blank line between subject and body, or more than one.
- Code/logic/behavior/multi-file change with no body.
- Body lines over 72 chars.
- Body lists implementation steps (HOW) with no user-facing purpose — rewrite around the behavior and why it matters; name the user-facing problem fixed.
- Generic phrasing: "improved UX", "various fixes", "cleanup", "misc changes".
- Footer not at the very bottom, or non-`Resolves:`/`See also:` reference styles, or a fabricated footer with no real reference.

## Body exception — "very simple" commits

No body is required ONLY for: a typo/wording fix, a version bump, or a single-line formatting/whitespace change. Anything touching logic, behavior, schema, or multiple files gets a body. When in doubt, write the body.
