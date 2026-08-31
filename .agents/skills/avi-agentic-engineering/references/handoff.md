# AI → human handoff SOP

Handoff unit is a **reviewable artifact** (usually a PR), not a chat summary (`AVI-AGENT-008`, `AVI-AGENT-028`).

## Before you ping a human

1. **Branch** is pushed; working tree matches the PR.
2. **Intent** is in the PR body (problem, approach, out of scope).
3. **Traceability:** link Asana/GitHub issue if they exist (`AVI-AGENT-052`). Cite `AVI-AGENT-*` only when it affected a decision.
4. **Evidence:** commands run + outcomes; UI path tested or substitute named.
5. **Independent review** completed for substantial diffs (`AVI-AGENT-006`). Include the reviewer's outcome.
6. **Risks and rollback:** what is reversible; what is not (`AVI-AGENT-021`, `AVI-AGENT-029`).
7. **Open questions** are explicit — do not hide them in commit noise (`AVI-AGENT-054`).
8. **Memory:** durable decisions written to `PROJECT.yaml` / ADR / `AGENTS.md` / `kb/` (`AVI-AGENT-037`).
9. **Human gates remaining:** merge, deploy, billing, production data — listed, not performed (`AVI-AGENT-020`).

## PR body (minimum)

Use `templates/pr-body.md`. Required headings:

- Summary
- Approach (or link to a plan)
- Evidence
- Risk and rollback
- Human gates still required
- Knowledge updates

## What the human is expected to do

| Gate | Human |
| --- | --- |
| Merge | Review diff + evidence; merge |
| Product / domain policy | Confirm refusals and autonomy rules in `AGENTS.md` still hold |
| Security boundaries | Confirm load-bearing files in `PROJECT.yaml` are unchanged or intentionally changed |
| Deploy | Their release process — agents do not ship production |
| Secrets/providers | Rotate or inject credentials out of band |

## What not to hand off

- Uncommitted local experiments
- Failing typecheck/lint "for the reviewer to finish"
- A verbal claim that the UI works, with no path exercised
- Raw secrets or `.env.local` contents
