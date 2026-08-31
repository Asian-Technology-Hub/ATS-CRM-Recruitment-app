<!-- BEGIN:nextjs-agent-rules -->

# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` (resolved from this file's directory; in monorepos the `next` package may not be visible from the repo root) before writing any code. Heed deprecation notices.

This block is written and re-added by `next dev` — verify at `node_modules/next/dist/server/lib/generate-agent-files.js`. Removing it from a diff only re-creates the uncommitted change; committing it with your work keeps the tree clean.

<!-- END:nextjs-agent-rules -->

# Vetra — project agent policy

Reusable workflow lives in the **`avi-agentic-engineering`** skill, not here (`AVI-AGENT-010`). This file is **project policy**: what is true of *this* repository.

Control plane: [`PROJECT.yaml`](PROJECT.yaml). Pattern IDs: `AVI-AGENT-001` … `AVI-AGENT-060`.

## Operating instructions

1. Read `PROJECT.yaml`, then this file, then the skill SOP if the work is more than a trivial edit.
2. Inspect before mutating (`AVI-AGENT-007`). Prefer a short written plan for multi-file work.
3. Work on a feature branch; hand off via PR (`AVI-AGENT-008`, `AVI-AGENT-051`).
4. Verify with evidence (`AVI-AGENT-027`, `AVI-AGENT-028`). UI changes need browser (or closest substitute) verification, not a screenshot-only claim.
5. After substantial diffs, run an independent `code-reviewer` pass (`AVI-AGENT-006`).
6. Pause for a human at merge, production mutation, billing, and secret handling (`AVI-AGENT-017`–`021`).
7. Promote lasting decisions into `PROJECT.yaml`, `docs/`, `kb/`, or this file (`AVI-AGENT-037`). Do not leave architecture only in chat.

## Architecture constraints (do not violate)

- **One tenant enforcement path.** Identity is `auth()` from Clerk. Never take `orgId` from the model, the client, or a tool argument.
- **MCP client is per-request.** Tenant filter lives in the URL (`lib/mcp.ts`). Do not hoist a module-level MCP client.
- **Stored Sanity Context filter is fail-closed** (`orgId == "__none__"`). App overrides per request.
- **Agent writes wrap the same Server Actions as the UI** (`lib/agent-tools.ts` → `lib/actions/`). Do not add a second mutation path.
- **Ask Vetra does not hire, reject, or rank people for rejection.** Retrieval and clerical actions only (`lib/agent-prompt.ts`).
- **Studio `/studio` is an operator console** — all tenants. Product UI is `/dashboard` only.
- **Violet is AI-only** (`docs/design-language.md`).
- Next.js 16 uses `proxy.ts` (not `middleware.ts`) for Clerk.

## Stack overlays

- **web-app:** App Router, Server Actions, `pnpm`, TypeScript strict.
- **ai-agent:** Sanity Context MCP, Vercel AI SDK v6, org-scoped GROQ, Insights telemetry.

## Commands

| Check | Command |
| --- | --- |
| Types | `pnpm typecheck` |
| Lint | `pnpm lint` |
| Build | `pnpm build` |
| Dev | `pnpm dev` |

## Knowledge

Project notes, URLs, and professional references go in [`kb/`](kb/). Do not inject a global second brain. Retrieve on demand (`AVI-AGENT-031`, `AVI-AGENT-033`).
