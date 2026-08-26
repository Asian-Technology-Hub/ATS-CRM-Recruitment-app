# Vetra

The AI-native CRM for recruitment agencies. Agencies sign up as a **Clerk organization**, track client **companies → jobs → candidates → applications** on a kanban pipeline with interview debriefs, and (on Pro) talk to an **AI Talent Agent** powered by **Sanity Context** — hybrid structured + semantic search over CVs and interview feedback, plus action tools that go through the exact same guards as the UI.

**Stack:** Next.js 16 (App Router) · Clerk (auth, orgs, B2B billing) · Sanity (datastore + embedded Studio) · Sanity Context (MCP) · AI SDK v6 + Anthropic

## Setup from a fresh clone

### 0. Prerequisites

- Node 24+ (the seed script uses native TypeScript type-stripping)
- A [Sanity](https://sanity.io) account and a [Clerk](https://clerk.com) account
- The Clerk CLI: `npm i -g clerk` (then `clerk auth login`)
- An [Anthropic API key](https://console.anthropic.com) for the agent

```bash
npm install
cp .env.example .env.local
```

### 1. Sanity

```bash
# Create a project + dataset (grab the project id it prints)
npx sanity init --bare

# Put the project id + dataset in .env.local, then mint two tokens:
npx sanity tokens add "Vetra Context (viewer)" --role=viewer  # → SANITY_API_READ_TOKEN
npx sanity tokens add "Vetra Writer (editor)"  --role=editor  # → SANITY_API_WRITE_TOKEN
```

Set `SANITY_CONTEXT_MCP_BASE_URL=https://api.sanity.io/v2026-03-03/context/mcp/<projectId>/<dataset>` and update the `projectId` in `sanity.cli.ts` (and `studioHost` — pick your own, they're globally unique).

Then register everything Sanity Context needs:

```bash
npx sanity schema deploy                          # re-run after any schema change
npx sanity deploy                                 # a deployed Studio is REQUIRED by Sanity Context
npx sanity datasets embeddings enable production  # powers text::semanticSimilarity
npx sanity cors add http://localhost:3000 --credentials   # lets the embedded /studio talk to the API
```

Finally, open the Studio and publish one **Sanity Context** document (Structure → Sanity Context): slug `vetra`, a deny-by-default filter `orgId == "__none__"` in the GROQ tab, and paste domain instructions (see `lib/agent-prompt.ts` for the vocabulary). The app overrides the filter per request with the signed-in org — the stored one is the fail-closed fallback.

### 2. Clerk

```bash
clerk apps create "Vetra" --json     # note the application_id
clerk link --app <application_id>
clerk env pull                       # writes publishable + secret keys into .env.local
clerk enable orgs
clerk enable billing --for orgs      # if the CLI can't, use Dashboard → Billing → Settings

# Create the Free/Pro/Scale org plans + features from the checked-in config:
clerk config patch --file scripts/clerk-billing.json --dry-run
clerk config patch --file scripts/clerk-billing.json
```

One Dashboard-only step: open Billing → Plans and switch **Pro** and **Scale** to *seat-based* (5 and 20 seats) — seat caps aren't settable via the config API.

### 3. Run + seed

```bash
npm run dev
```

Sign up at http://localhost:3000, create your agency (an organization), then grab the **organization id** — Clerk Dashboard → Organizations → your org → Organization ID, or `clerk api /organizations`.

```bash
npm run seed -- org_XXXXXXXXXXXX          # 203 realistic docs: 8 companies, 15 jobs,
                                          # 60 candidates, 80 applications, 40 interviews
npm run seed:reset -- org_XXXXXXXXXXXX    # removes ONLY seeded docs
```

The seeder is **idempotent** — every document has a deterministic `vetra.seed.*` id and is `createOrReplace`d, so re-running never duplicates. All dates are relative to *now*, so "stuck in screening for 2+ weeks" demos work on any day. Seed **before** you demo the agent: embedding indexing isn't instant (`npx sanity datasets embeddings status production` shows `ready` when done).

### 4. Try the agent

The AI Talent Agent is gated behind the `ai_agent` feature (Pro/Scale). Upgrade from **Dashboard → Billing** using Clerk's dev checkout (test card `4242 4242 4242 4242`), then hit **Ask Vetra** and try:

1. "Who's stalled in screening?" *(structural)*
2. "Find React candidates with fintech experience" *(semantic, over cvText)*
3. "Who gave strong system-design answers recently?" *(hybrid — the money shot)*
4. "Move Priya Raghavan to offer and log that her final round passed" *(action tools)*

Also Pro: open any job and press **Help source candidates** — every available CV in your pool is scored against the role description with `text::semanticSimilarity` (pure Sanity embeddings, no LLM call) and shown with relative match percentages plus one-click "Add to pipeline".

## Architecture notes

- **Tenant isolation:** one dataset, `orgId` on every document. Reads are `$orgId`-parameterized from `auth()`; every mutation passes `assertOwned` ([lib/tenant.ts](lib/tenant.ts)); the agent's MCP URL carries a per-request org filter and the stored fallback denies everything ([lib/mcp.ts](lib/mcp.ts)). Never hoist the MCP client to module scope.
- **Agent tools:** the Sanity Context tools (`groq_query`, `schema_explorer`, `array_field_reader`) plus custom action tools that wrap the same server actions the UI uses ([lib/agent-tools.ts](lib/agent-tools.ts)) and two client-side tools handled in [AgentPanel](components/agent/AgentPanel.tsx).
- **Studio** is embedded at `/studio` and guarded by Sanity's own login + project membership. It sees **all tenants** — it's an operator console, never for agency users.
- **Billing:** feature-first gating with `has({ feature: "ai_agent" })`; free-tier caps in [lib/plan-limits.ts](lib/plan-limits.ts) (closing a job does not free the slot).
