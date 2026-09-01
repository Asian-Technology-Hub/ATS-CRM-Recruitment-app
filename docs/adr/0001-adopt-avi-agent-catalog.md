# ADR 0001: Adopt the Avinash Agentic Software Design Pattern Catalog in Cursor

- **Status:** accepted
- **Date:** 2026-08-31
- **Project:** Vetra (crm-build-sanity-context)
- **Supersedes:** ad-hoc chat-only agent instructions

## Context

Development work is expected to move between Cursor, Codex, Claude, and ChatGPT, with humans merging. Informal conversation produced a stable set of ~60 patterns (orchestration, knowledge, implementation, safety, browser/tools, project architecture). Those patterns were not executable in this repo: there was no `PROJECT.yaml`, no Cursor rule, and `AGENTS.md` contained only the Next.js stamp.

## Decision

1. Formalize patterns as **`AVI-AGENT-001`–`AVI-AGENT-060`** in the reusable skill `avi-agentic-engineering`, installed **user-global** for all local Cursor projects and **in-repo** for Cloud Agents.
2. Keep **skills ≠ project policy**: catalog/SOP in the skill; product/stack rules in each repo's `AGENTS.md` / `PROJECT.yaml`.
3. Wire Cursor via User Rules + Team Rules (all projects) and a thin always-apply project rule that only points at the skill.
4. Use overlays `core` + `web-app` + `ai-agent` for this repository (no mobile/infra template bloat).

## Consequences

- Agents must inspect `PROJECT.yaml` and `AGENTS.md` before substantial edits.
- PRs are the handoff unit; merge remains a human gate.
- Durable decisions get promoted into YAML/markdown/`kb/` instead of remaining in chat.
- The Next.js auto-stamp in `AGENTS.md` stays; project policy is appended below it.

## Provenance

- Source: user-consolidated pattern list from prior Codex/agent discussions, captured in Cursor on 2026-08-31.
