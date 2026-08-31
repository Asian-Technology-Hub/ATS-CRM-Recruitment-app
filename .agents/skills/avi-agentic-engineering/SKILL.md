---
name: avi-agentic-engineering
description: >
  Avinash agentic SOP and pattern catalog (AVI-AGENT-001–060) for Cursor, Codex,
  Claude, and ChatGPT. Use for any non-trivial software work: routing intent,
  coordinating scoped agents, plan-before-build, branch/PR handoff, independent
  review, policy-gated tools, verification with evidence, project KB, and
  AI-to-human handoff. Trigger on workflow, SOP, AGENTS.md, PROJECT.yaml,
  multi-agent, review, merge gates, or when starting substantial implementation.
---

# Avinash agentic engineering (Cursor)

Canonical loop:

**Intent → Coordinator → scoped context/knowledge → specialist agents → policy-gated capabilities → deterministic execution → verification → independent review → human gate where required → artifact/PR → audit + memory update.**

This skill is **reusable capability**. Repo-specific policy lives in `AGENTS.md` and `PROJECT.yaml` (`AVI-AGENT-010`). If those files are missing, create them from `templates/` before large work — do not invent policy in chat.

## When to load what

| Need | Read |
| --- | --- |
| How to run a task in Cursor | this file |
| Pattern definition, anti-patterns | `references/catalog.md` (one ID or one category) |
| Cursor feature → pattern map | `references/cursor-playbook.md` |
| AI → human handoff checklist | `references/handoff.md` |
| Machine index | `references/patterns.yaml` |
| Copy-paste artifacts | `templates/` |
| Overlay definitions | `references/overlays.md` |

Do not ingest the whole catalog on every turn (`AVI-AGENT-033`).

## Intent router (`AVI-AGENT-002`)

Classify the request, then select the smallest capable path:

| Class | Default path |
| --- | --- |
| Question / explore | Read-only. No branch, no mutation. |
| Trivial edit (one obvious file, no architecture) | Inspect → patch on feature branch → evidence → PR if the environment expects one. |
| Substantial implementation | Coordinator loop below. |
| Research / design | Discovery → plan artifact → human gate before code. |
| Incident / debug | Observe evidence first; no speculative rewrites. |
| Governance (secrets, prod, billing, merge) | Stop; require explicit human authorization. |

If the request mixes "fix and also give me an exploit/PoC", do the fix only.

## Coordinator loop (`AVI-AGENT-001`, `004`, `005`, `007`)

For substantial work, **you** are the coordinator unless the user named another.

1. **Inspect** — tree, `PROJECT.yaml`, `AGENTS.md`, relevant skills, existing tests. No edits yet.
2. **Scope** — goal → bounded tasks. Prefer isolated components over one giant context.
3. **Plan** — short plan (use `templates/implementation-plan.md` when the change spans subsystems). Sanity-check against load-bearing files listed in `PROJECT.yaml`.
4. **Dispatch**
   - Independent subsystems → parallel `Task` / subagents (`AVI-AGENT-005`).
   - Sequential dependencies → pipeline (`AVI-AGENT-003`): discovery → implementation → verification.
   - Each implementer gets only the files, tools, and secrets it needs (`AVI-AGENT-018`).
5. **Integrate** on the feature branch. Do not commit secrets. Do not push to `main`.
6. **Verify** against acceptance criteria (`AVI-AGENT-027`). Tool exit 0 is not task success.
7. **Independent review** — `code-reviewer` / CodeRabbit (`AVI-AGENT-006`). Do not be the only reviewer of your own diff.
8. **Handoff** — PR + evidence + open questions (`references/handoff.md`). Human merges (`AVI-AGENT-020`).

## Mutation policy (`AVI-AGENT-008`, `017`, `021`, `024`)

```
branch → patch → diff → tests/build → review → PR → (human) merge
```

- Prefer draft/preview/soft-delete/feature-branch over send/publish/hard-delete/main.
- Development agents stay in the workspace, not production consoles.
- High-risk actions (merge, production data, payments, credential minting, unrestricted shell toward prod) need an explicit user instruction.

## Evidence bar (`AVI-AGENT-028`)

"Done" requires at least one observable artifact appropriate to the change:

- passing `pnpm typecheck` / `pnpm lint` / tests
- `pnpm build` when runtime or UI contracts changed
- UI: exercise the flow in a browser (or document the substitute)
- PR with a diff humans can review
- for agent/MCP changes: a concrete query or request/response, not a claim

## Memory update (`AVI-AGENT-031`, `037`)

Before finishing, promote durable output out of the thread:

- facts/decisions → `PROJECT.yaml` or `docs/adr/`
- operating rules → `AGENTS.md`
- reusable how-to → an `avi-*` skill, not the repo prompt
- URLs/notes → `kb/` items with source provenance (`AVI-AGENT-035`)

## Anti-patterns (global)

- One agent owns an entire large implementation in a single unbounded context
- Implementing before inspecting
- Editing `main` or installed artifacts in place
- Copying a giant template into every repo (use lean core + overlays)
- Stuffing the full second brain or full catalog into the prompt
- Treating the builder's self-summary as review
- Hard-coding a vendor where a capability contract exists
- Declaring done because a tool call returned

## Catalog index

Orchestration `001–006` · Implementation `007–011` · Integration `012–016` · Safety `017–023` · Isolation `024–026` · Quality `027–030` · Knowledge `031–040` · Browser `041–045` · Models `046–050` · Project mgmt `051–054` · Unifying `055–060`.

Full cards: `references/catalog.md`.
