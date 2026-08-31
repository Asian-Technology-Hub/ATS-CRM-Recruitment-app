# Avinash Agentic Software Design Pattern Catalog

IDs are stable. Cite them in plans, PRs, and `AGENTS.md` (`AVI-AGENT-NNN`).

Machine index: [`patterns.yaml`](patterns.yaml). Cursor mapping: [`cursor-playbook.md`](cursor-playbook.md).

Legend for each card: **Structure** · **Apply** · **Cursor** · **Anti-pattern** · **Related**.

---

## Orchestration

### AVI-AGENT-001 — Coordinator + Scoped Implementers + Independent Reviewers

**Structure:** Coordinator → scoped implementation agents → independent reviewer(s) → integration.

**Apply:** Substantial work spanning more than one component or risk domain.

**Cursor:** Parent agent owns architecture and merge of diffs. Use `Task` with isolated prompts for components. After integration, launch `code-reviewer` (CodeRabbit). Cloud Agents: do not let one long context implement everything.

**Anti-pattern:** Implementer reviews its own PR as the only gate; a single chat thread that "just keeps going" across the whole codebase.

**Related:** 003, 004, 005, 006.

### AVI-AGENT-002 — Intent Router / Agent Dispatcher

**Structure:** User intent → classify → select agent/skill/MCP/model/workflow → execute → aggregate.

**Apply:** Every incoming request, including follow-ups. Re-evaluate class if the user shifts from question to implementation.

**Cursor:** Match to skills (`avi-agentic-engineering`, Clerk, Sanity, design), MCP namespaces, and `Task` subtypes (`explore`, `computerUse`, `code-reviewer`). Prefer the smallest path.

**Anti-pattern:** Defaulting every message to "write code"; loading every MCP and skill.

**Related:** 003, 046, 059.

### AVI-AGENT-003 — Specialized Agent Pipeline

**Structure:** Discovery → ranking → analysis → planning → implementation → verification → deployment.

**Apply:** Work with clear stages and different skills per stage (search vs coding vs test vs deploy).

**Cursor:** `explore` → plan artifact → implementation agent → tests/browser → `code-reviewer`. Do not ask the implementer to also be the only verifier.

**Anti-pattern:** One generalist improvising deploy credentials in the same turn as UI copy.

**Related:** 001, 027, 060.

### AVI-AGENT-004 — Hierarchical Agent Decomposition

**Structure:** Goal → epics → tasks → agent assignments → atomic tool operations.

**Apply:** Large codebases; anything that would overflow a single context window if done naively.

**Cursor:** Write the epic/task split into the plan. Each `Task` prompt includes only its subtree, acceptance criteria, and forbidden files.

**Anti-pattern:** Recursive splitting with no owner; orphan subagents that never get integrated.

**Related:** 001, 005, 053.

### AVI-AGENT-005 — Parallel-Agent Fan-Out / Fan-In

**Structure:** Coordinator → {Agent A, Agent B, Agent C} → synthesis.

**Apply:** Independent files/packages/docs with no shared write set.

**Cursor:** Multiple `Task` calls in one turn. Serialize when two agents would patch the same file. Synthesis is the coordinator's job (conflicts, APIs, types).

**Anti-pattern:** Parallel writes to the same module; fan-out without a merge plan.

**Related:** 001, 026.

### AVI-AGENT-006 — Independent Verification Agent

**Structure:** Builder ≠ Reviewer.

**Apply:** After any substantial diff (security, tenancy, billing, agent tools, data model).

**Cursor:** `subagent_type: code-reviewer` with the real diff. Optional `security-review` when the user asks. Do not paste the builder's rationale as if it were findings.

**Anti-pattern:** "LGTM" from the same agent that wrote the patch; skipping review because tests passed.

**Related:** 001, 027, 028.

---

## Implementation and project shape

### AVI-AGENT-007 — Plan-Before-Build

**Structure:** Inspect → understand → plan → sanity-check → approve → implement.

**Apply:** Default for all non-trivial mutations. Skip only for truly local, obvious edits.

**Cursor:** Read files and Next.js `node_modules/next/dist/docs/` *before* patches. For ambiguous architecture, stop at a plan rather than guessing.

**Anti-pattern:** Grep-and-patch; generating files that duplicate existing utilities.

**Related:** 008, 009, 054.

### AVI-AGENT-008 — Branch → Diff → Test → Approve

**Structure:** branch → patch → diff → tests/build → review → PR → merge.

**Apply:** All code mutation in this org's workflow. Cloud Agents already require this.

**Cursor:** `cursor/<descriptive-name>-*` feature branches; never commit secrets; never merge unless the user explicitly asked.

**Anti-pattern:** Editing `main`; rewriting `node_modules`; "fixing" generated files that `next dev` will recreate (except when intentionally committing `AGENTS.md` Next.js stamps).

**Related:** 021, 024, 051.

### AVI-AGENT-009 — Spec-Driven / Artifact-Driven Development

**Structure:** Intent persisted as `PROJECT.yaml`, markdown docs, `AGENTS.md`, ADRs, plans, tasks, PRs/issues.

**Apply:** Decisions that must survive the chat; multi-session work; handoff.

**Cursor:** Use `templates/`. Link GitHub artifacts. Do not rely on conversation history as the spec.

**Anti-pattern:** Architecture that exists only in a thread; contradictory docs and code with no ADR.

**Related:** 037, 052, 053.

### AVI-AGENT-010 — Skills vs Project Rules Separation

**Structure:** Skills = reusable domain/tool knowledge. `AGENTS.md` / `CLAUDE.md` / `PROJECT.yaml` = this repo's constraints, gates, and architecture.

**Apply:** Always. When adding guidance, choose the layer.

**Cursor:** Put catalog/SOP in `avi-*` skills; put Vetra tenancy and Next 16 `proxy.ts` in `AGENTS.md`. Cursor rules (`.cursor/rules`) should point at both, not duplicate the catalog.

**Anti-pattern:** 2k-line `AGENTS.md` that copies Clerk/Sanity tutorials; skills that hard-code one repo's paths as if they were universal.

**Related:** 011, 032, 055.

### AVI-AGENT-011 — Lean Core + Project-Type Overlays

**Structure:** Lean core template + overlays (`web-app`, `mobile`, `ai-agent`, `infra`).

**Apply:** New repos and this catalog's templates. Record overlays in `PROJECT.yaml`.

**Cursor:** This CRM uses `core` + `web-app` + `ai-agent`. Do not drop mobile/infra scaffolding here.

**Anti-pattern:** Copy-paste of a monorepo mega-template into a simple app.

**Related:** 010, 053.

---

## Integration architecture

### AVI-AGENT-012 — Resident Core + Thin Adapters

**Structure:** Chrome extension / CLI / desktop UI / MCP / native messaging → local core daemon. Adapters transport; they do not duplicate business logic.

**Apply:** Browser trainers, endpoint control, multi-surface agents.

**Cursor:** In this repo, Server Actions are the core; `lib/agent-tools.ts` and UI buttons are thin adapters (`AVI-AGENT` analogue).

**Anti-pattern:** Divergent permission checks in the chat tools vs the form actions.

**Related:** 013, 015, 059.

### AVI-AGENT-013 — Unified Gateway / Adapter Pattern

**Structure:** Agent → unified gateway → Provider A / B / C.

**Apply:** Models, MCP, creative-resource APIs, org integrations.

**Cursor:** Prefer existing gateways (`lib/mcp.ts`, Clerk `auth()`). Do not add a second Anthropic client beside the AI SDK route without a reason.

**Anti-pattern:** Each feature invents its own provider SDK wrapper.

**Related:** 014, 015, 046.

### AVI-AGENT-014 — Provider-Agnostic Tool Contract

**Structure:** `agent → search_asset()` (capability), not `agent → Envato API`. Same for models: capability, not a hard-coded vendor name in business logic.

**Apply:** When introducing tools the orchestrator might swap.

**Cursor:** Zod tool names describe *jobs* (`move_application`), not vendors. Model choice stays in the route/config.

**Anti-pattern:** `callClaude()` inside a domain module.

**Related:** 013, 016, 046.

### AVI-AGENT-015 — MCP as Capability Bus

**Structure:** Agents → MCP capability layer → GitHub / browser / Drive / Asana / analytics / messaging / databases / infra.

**Apply:** External systems. Prefer MCP (or an equivalent typed tool layer) over one-off curl in the prompt.

**Cursor:** Use discovered MCP namespaces; call `GetDynamicTools` before `CallDynamicTool`. Sanity Context is the content bus for Ask Vetra.

**Anti-pattern:** Pasting API keys into the model and asking it to "just fetch".

**Related:** 016, 018, 057.

### AVI-AGENT-016 — Capability Registry

**Structure:** Capabilities expose name, schema, permissions, cost, latency, risk, provider, health. Orchestrator selects dynamically.

**Apply:** Multi-MCP / multi-model harnesses; future OpenRouter catalog.

**Cursor:** Today: tool descriptors on the AI SDK route + Cursor MCP catalog. Do not assume a tool exists — discover it.

**Anti-pattern:** Hard-coded tool lists that drift from the server.

**Related:** 002, 015, 048.

---

## Safety and governance

### AVI-AGENT-017 — Policy-Gated Capability Execution

**Structure:** read → reversible action → code/data mutation → high-risk external action. Stronger authorization at each level.

**Apply:** Every tool call class. Cloud Agent file edits are "code mutation"; `gh` write, payments, prod are high-risk.

**Cursor:** Follow product + Cursor safety rules. Do not open/close PRs or merge unless asked. Do not use write-capable `gh`.

**Anti-pattern:** Same autonomy for `Read` and "delete production dataset".

**Related:** 018, 020, 060.

### AVI-AGENT-018 — Least-Privilege Agents

**Structure:** Agent → scoped capability set for the current assignment.

**Apply:** Subagents, CI, browser, credentials.

**Cursor:** Subagent prompts list allowed paths. Do not hand unrestricted shell + every secret to an explore agent.

**Anti-pattern:** Global `.env` dump into every Task prompt.

**Related:** 019, 023, 024.

### AVI-AGENT-019 — Allowlists Instead of Generic Execution

**Structure:** Repository, site/domain, command, tool, and model allowlists.

**Apply:** Browser agents, endpoint control, OpenCode model rollout.

**Cursor:** `navigate_to` must stay inside `/dashboard` in this app. Prefer known package-manager commands (`pnpm`) over arbitrary curl-to-disk.

**Anti-pattern:** Unrestricted `shell` + unrestricted browser as the default.

**Related:** 017, 047.

### AVI-AGENT-020 — Human Approval Gates

**Structure:** Research autonomous; code patch → review; merge → approval; payment/send/delete/production → explicit authorization.

**Apply:** Default autonomy gradient for this catalog.

**Cursor:** Prepare the PR; do not merge. Do not spend money. Do not disable tenant filters "to test".

**Anti-pattern:** Agent merges its own PR; agent "temporarily" widens `groqFilter`.

**Related:** 008, 017, 060.

### AVI-AGENT-021 — Reversible-by-Default Actions

**Structure:** draft vs send; branch vs main; soft delete vs hard delete; preview vs publish.

**Apply:** Email, CMS, git, browser automation.

**Cursor:** Feature branches, Sanity drafts vs published (this app's agent already excludes drafts in MCP filter — keep it). Prefer additive flags.

**Anti-pattern:** Irreversible cleanup as step 1 of a refactor.

**Related:** 008, 026.

### AVI-AGENT-022 — Append-Only Agent Audit Trail

**Structure:** Events with agent, task, tool, input ref, decision, action, result, cost, timestamp, approval, rollback ref.

**Apply:** Browser automation, OpenCode, enterprise governance, Ask Vetra Insights.

**Cursor:** Prefer existing telemetry (Sanity Insights on `/api/agent`) over a parallel log. For coding agents, the PR + commits are the audit trail; keep messages descriptive.

**Anti-pattern:** Unstructured "I think it worked" with no artifact.

**Related:** 028, 038, 058.

### AVI-AGENT-023 — Secret Isolation / Redaction

**Structure:** agent → credential alias → secret broker → provider. Logs and prompts redact secrets.

**Apply:** All tokens (Sanity, Clerk, Anthropic).

**Cursor:** `.env.local` only. Never print tokens. Never commit `.env*`. Cite env var *names* in docs.

**Anti-pattern:** Pasting `sk-` or Sanity tokens into chat, commits, or screenshots.

**Related:** 018, 024.

---

## Isolation and transactions

### AVI-AGENT-024 — Dedicated Safe Execution Environment

**Structure:** Dev Chrome profile, git worktrees/branches, staging, scoped repos, venv, controlled endpoints.

**Apply:** Any agent with shell or browser.

**Cursor:** This workspace is the sandbox. Do not target production Sanity datasets for experiments; do not use the operator Studio as an end-user test.

**Anti-pattern:** Running destructive seed `--reset` against a shared production org without being asked.

**Related:** 018, 025.

### AVI-AGENT-025 — Sandboxed Agent Workspace

**Structure:** Task → disposable workspace → artifacts → verification → promotion.

**Apply:** Parallel experiments, flaky installs, generated sites.

**Cursor:** Cloud `best-of-n-runner` / worktrees when isolating risky refactors. Throw away failed workspaces.

**Anti-pattern:** Half-applied experiments left on the main working tree.

**Related:** 005, 026.

### AVI-AGENT-026 — Transactional Agent Execution

**Structure:** prepare → validate → execute → verify → commit. On failure: rollback.

**Apply:** Multi-file refactors, data migrations, seed scripts.

**Cursor:** Keep the branch commitable; if verification fails, fix or revert — do not leave the tree half-migrated.

**Anti-pattern:** Five files patched, types failing, "will fix later" as the handoff.

**Related:** 008, 027, 029.

---

## Quality

### AVI-AGENT-027 — Verification Loop

**Structure:** execute → observe → compare to acceptance criteria → repair → retest.

**Apply:** After every implementation slice.

**Cursor:** Run the commands in `PROJECT.yaml` / `AGENTS.md`. For UI, click through the flow. Hunt regressions on shared state/routes.

**Anti-pattern:** Trusting compile success as product success; screenshot-only "verification".

**Related:** 006, 028, 029.

### AVI-AGENT-028 — Evidence-Based Completion

**Structure:** Done = artifacts (tests, screenshots, build, diff, endpoint, query, PR, audit event).

**Apply:** Definition of done for agents.

**Cursor:** Cite commands and outcomes in the PR. For Ask Vetra changes, include a sample GROQ or route behavior.

**Anti-pattern:** "The feature should work now."

**Related:** 022, 027.

### AVI-AGENT-029 — Failure-Aware Agent Workflow

**Structure:** Model expected result, timeout, tool unavailable, partial mutation, permission denied, ambiguous result, verification failure — each with recovery.

**Apply:** MCP, browser, CI, long jobs.

**Cursor:** If a tool namespace is `needsAuth`, do not fake success. If lint fails, fix or report with logs. Do not retry destructive commands blindly.

**Anti-pattern:** Infinite rebuild loops; ignoring 401/403 from Clerk/Sanity.

**Related:** 026, 030.

### AVI-AGENT-030 — Heartbeat + Timeout + Cancellation

**Structure:** request ID, heartbeat, timeout, cancellation, structured error — no indefinite blocking calls.

**Apply:** Local MCP bridges, long generations, Playwright.

**Cursor:** Bound `block_until_ms` on shells; do not wait forever on `next dev`. Cancel stuck jobs rather than stacking duplicates.

**Anti-pattern:** Starting a second `pnpm dev` on the same port "to be sure".

**Related:** 029, 058.

---

## Knowledge and context

### AVI-AGENT-031 — Project-Scoped Knowledge Base

**Structure:** Project → project KB → agents.

**Apply:** URLs, notes, professional references, templates for *this* product.

**Cursor:** `kb/` in this repo. Do not load a personal second brain.

**Anti-pattern:** Global bookmark dump in every prompt.

**Related:** 032, 033, 035.

### AVI-AGENT-032 — Shared Organizational Knowledge + Project Overlay

**Structure:** global principles → org standards → department → project → current task.

**Apply:** Multi-repo orgs. Retrieve only relevant layers.

**Cursor:** Catalog skill = org layer. `AGENTS.md` = project. Plan = task.

**Anti-pattern:** Flattening every layer into one mega-prompt.

**Related:** 010, 034.

### AVI-AGENT-033 — Retrieval-on-Demand Instead of Prompt Stuffing

**Structure:** query → retrieve relevant context → rank → inject.

**Apply:** Skills, docs, `kb/`, Elastic/Sanity search.

**Cursor:** Read the one skill/reference needed. Sanity Context: GROQ, not "paste the dataset".

**Anti-pattern:** Attaching the entire README + catalog + all Clerk skills.

**Related:** 034, 039.

### AVI-AGENT-034 — Context Compression / Progressive Disclosure

**Structure:** summary → relevant document → relevant section → source artifact.

**Apply:** Long docs (`README.md` is huge — start from `PROJECT.yaml` and key files).

**Cursor:** Use offsets/limits on `Read`. Quote load-bearing files, not whole READMEs.

**Anti-pattern:** Reading 800-line README into every turn.

**Related:** 033, 053.

### AVI-AGENT-035 — Source-Provenance Pattern

**Structure:** For each fact/resource: source URL/file, capture date, author, project, tags, notes, confidence, derived artifacts.

**Apply:** `kb/` items, bookmarks, YouTube-derived skills.

**Cursor:** Use `templates/kb-item.md`. Do not state vendor behavior without a doc path.

**Anti-pattern:** Unsourced "best practices" that contradict this repo.

**Related:** 036, 038.

### AVI-AGENT-036 — Knowledge Promotion

**Structure:** raw resource → reviewed resource → project knowledge → reusable organizational skill.

**Apply:** Tutorial transcripts (`avi-*` skills), competitive notes.

**Cursor:** Do not treat a blog post as policy until reviewed. Skills are the promotion target for reusable how-to.

**Anti-pattern:** Copying a random article into `AGENTS.md`.

**Related:** 010, 044.

### AVI-AGENT-037 — Conversation → Structured Memory

**Structure:** conversation decision → `PROJECT.yaml` / ADR / `AGENTS.md` / task.

**Apply:** End of any session that decided architecture or SOP.

**Cursor:** This catalog install is an example: patterns left chat and became files.

**Anti-pattern:** "We'll remember that" with no artifact.

**Related:** 009, 022.

### AVI-AGENT-038 — Temporal Memory

**Structure:** what, when, source, previous state, current state.

**Apply:** Preference evolution, schema migrations, policy changes.

**Cursor:** Git history + ADRs. Update `PROJECT.yaml` `status`/`stage` when the project moves.

**Anti-pattern:** Overwriting decisions with no trail.

**Related:** 022, 039.

### AVI-AGENT-039 — Graph + Vector + Structured Memory

**Structure:** Vector (semantic) + graph (relationships) + SQL/docs (authoritative) + event/timeline (history).

**Apply:** Second-brain and this CRM (GROQ structure + embeddings).

**Cursor:** Do not add a vector DB to Vetra; Content Lake embeddings already cover semantic search. Structured tenant data stays in Sanity documents.

**Anti-pattern:** Forcing everything into one embedding index.

**Related:** 033, 015.

### AVI-AGENT-040 — Bounded Personal Context

**Structure:** knowledge × identity × relationship × permission → allowable answer.

**Apply:** Personal agents; also multi-tenant product agents.

**Cursor:** Ask Vetra is org-bounded. Coding agents: do not leak `.env` or other tenants' seed data into public PRs.

**Anti-pattern:** Same context for public blog and private family agent.

**Related:** 018, 023.

---

## Browser and human workflow

### AVI-AGENT-041 — Browser as Agent Sensor + Actuator

**Structure:** observe page → understand → suggest/execute → verify DOM/state.

**Apply:** UI verification and in-product agents with client tools.

**Cursor:** Browser tools after UI changes. In-app: `get_current_page` / `navigate_to`.

**Anti-pattern:** Claiming UI works from code inspection alone when browser tools exist.

**Related:** 027, 042.

### AVI-AGENT-042 — Contextual Capability Injection

**Structure:** current URL/page → classify workflow → activate relevant agent/tools.

**Apply:** Extension-bar organizers; Ask Vetra empty-state suggestions.

**Cursor:** Keep page-specific suggestions in the dock; do not enable Studio operator tools on `/dashboard`.

**Anti-pattern:** Every tool visible on every site.

**Related:** 002, 016.

### AVI-AGENT-043 — Observe → Learn → Automate

**Structure:** human workflow → record → generalize → Playwright/Puppeteer skill → verify.

**Apply:** Browser trainer; repetitive QA.

**Cursor:** Automate only after the flow is stable. Prefer Playwright against this app's dashboard once selectors are documented.

**Anti-pattern:** Recording a flaky demo and promoting it to CI immediately.

**Related:** 044, 045.

### AVI-AGENT-044 — Demonstration-to-Skill

**Structure:** video/transcript/demo → principles → workflow → skill → enforce on future work.

**Apply:** `avi-*` skills (this catalog is one).

**Cursor:** New reusable SOP → `.agents/skills/avi-*/`, not a one-off rule dump.

**Anti-pattern:** Transcript pasted into `AGENTS.md`.

**Related:** 010, 036, 056.

### AVI-AGENT-045 — Human Workflow Augmentation Before Full Automation

**Structure:** Assist in the existing flow, then automate mature/repetitive slices.

**Apply:** Bookmarks, subscriptions, job applications, recruiter CRM.

**Cursor:** Ask Vetra drafts and clerical acts; humans decide hire/reject. Coding agents draft PRs; humans merge.

**Anti-pattern:** Full autonomy on day one of an unreliable workflow.

**Related:** 020, 060.

---

## Models and compute

### AVI-AGENT-046 — Model Router

**Structure:** task classification → model selection (quality, coding, multimodal, latency, cost, context, privacy).

**Apply:** OpenRouter/OpenCode; Cursor model picker when the user specifies.

**Cursor:** Use the model the user/harness assigned. Do not silently switch. For subagents, only listed slugs; otherwise `inherit`.

**Anti-pattern:** Hard-coding Claude inside domain code; ignoring the user's model request.

**Related:** 002, 014, 047.

### AVI-AGENT-047 — Curated Model Catalog

**Structure:** Approved 6–8 models, not the entire provider zoo.

**Apply:** Org rollouts.

**Cursor:** If the user names an unavailable subagent model, say so and list available slugs — do not substitute quietly.

**Anti-pattern:** "Latest" unbounded model IDs in production config.

**Related:** 019, 046.

### AVI-AGENT-048 — Budget-Aware Routing

**Structure:** quality requirement + cost ceiling + role policy → model/tool.

**Apply:** Preventing agentic cash burn.

**Cursor:** Prefer `explore`/cheaper paths for grep-like work; reserve full implementation + browser for product changes. Don't spawn unbounded parallel agents for a one-line fix.

**Anti-pattern:** Fan-out of max models on a typo fix.

**Related:** 005, 049.

### AVI-AGENT-049 — Escalation Routing

**Structure:** small/fast → failure/uncertainty → strong reasoning → human.

**Apply:** Classification, then repair.

**Cursor:** Try a focused fix; if types/architecture conflict, stop and escalate in the PR/plan rather than looping.

**Anti-pattern:** Immediately using the largest model for every file touch.

**Related:** 046, 020.

### AVI-AGENT-050 — Multi-Model Consensus / Critique

**Structure:** Model A proposes, B critiques, C/reviewer validates.

**Apply:** High-value architecture, security-sensitive tenancy changes.

**Cursor:** Implementation agent + independent `code-reviewer`. Optional second model only when the user asks or the decision is load-bearing (`lib/mcp.ts`, `lib/tenant.ts`).

**Anti-pattern:** Three models bikeshedding button copy.

**Related:** 006, 001.

---

## Project management

### AVI-AGENT-051 — Source-of-Truth Separation

**Structure:** GitHub owns code/PRs/technical issues. Asana owns parent workstream. Links connect records.

**Apply:** Dual-system orgs. Do not force Asana fields into git or vice versa.

**Cursor:** PRs via `ManagePullRequest`. Do not invent Asana tasks unless asked. Put the Asana URL in `PROJECT.yaml` when it exists.

**Anti-pattern:** Duplicating the full backlog in both systems without links.

**Related:** 052, 053.

### AVI-AGENT-052 — Bidirectional Traceability

**Structure:** Project ↔ Asana task ↔ GitHub issue ↔ branch ↔ commit ↔ PR ↔ release.

**Apply:** So an agent can reconstruct *why* a change exists.

**Cursor:** Branch names + PR body + `PROJECT.yaml` links. Mention issue/task IDs when known.

**Anti-pattern:** Drive-by commits with no parent work item on substantial features.

**Related:** 009, 051.

### AVI-AGENT-053 — Machine-Readable Project Metadata

**Structure:** `PROJECT.yaml` + human markdown: project, status, owners, systems, repos, architecture, links, policies.

**Apply:** Every repo using this catalog.

**Cursor:** Read `PROJECT.yaml` first. Keep it truthful when architecture changes.

**Anti-pattern:** YAML that drifts; putting essays into YAML.

**Related:** 009, 011, 034.

### AVI-AGENT-054 — Progressive Project Formalization

**Structure:** Capture known facts + sources + decisions + open questions; deepen architecture only as the project advances.

**Apply:** Idea-stage vs implementation-stage repos.

**Cursor:** Vetra is `implementation` — constraints above are binding. New ideas: don't demand a full ADR set on day one.

**Anti-pattern:** Either no spec at all, or a 40-page spec for a spike.

**Related:** 007, 009.

---

## Unifying harness patterns

### AVI-AGENT-055 — Agent Harness Over Ad-Hoc Prompting

**Structure:** rules + skills + context + tools + workflows + verification + logs — not one giant prompt.

**Apply:** All serious projects (this one included).

**Cursor:** `.cursor/rules` + `AGENTS.md` + skills + MCP + CI commands. Improve the harness when you learn a lesson (`AVI-AGENT-056`).

**Anti-pattern:** 10k-token custom prompt pasted into every chat.

**Related:** 010, 056, 057.

### AVI-AGENT-056 — Evolving Agent Harness

**Structure:** Continuously add skills, rules, verification, scripts, summaries, failure cases.

**Apply:** After incidents and successful patterns.

**Cursor:** If a tenant bug almost ships, add a policy line to `AGENTS.md` and a test — not just a PR comment.

**Anti-pattern:** Same failure every week with no harness change.

**Related:** 044, 055.

### AVI-AGENT-057 — Control Plane / Execution Plane Separation

**Structure:** Control plane = goals, policies, decomposition, permissions, budgets, project state. Execution plane = Codex/Claude/Cursor, browser, MCP, CI, shell, APIs.

**Apply:** Ecosystem governance.

**Cursor:** `PROJECT.yaml` + this catalog = control. The agent's tools = execution. Do not let execution redefine policy.

**Anti-pattern:** A shell script that "temporarily" disables `assertOwned`.

**Related:** 015, 017, 053.

### AVI-AGENT-058 — Event-Driven Agent Architecture

**Structure:** Events (email, PR, bookmark, upload, expiry, page, Asana) trigger workflows — not only human prompts.

**Apply:** Automations, webhooks (`app/api/webhooks/route.ts`).

**Cursor:** Implement webhook handlers as deterministic code; use the LLM only for interpretation/exceptions (`AVI-AGENT-059`).

**Anti-pattern:** Polling with an LLM every minute "to see if something happened".

**Related:** 022, 059.

### AVI-AGENT-059 — Agent → Workflow → Deterministic Tool

**Structure:** LLM decides what should happen → deterministic workflow executes → LLM interprets exceptions/results.

**Apply:** Default for writes. This CRM already wraps Server Actions.

**Cursor:** Keep business rules in TypeScript. The model chooses tools; it does not reimplement tenancy.

**Anti-pattern:** Model-authored GROQ *mutations* or raw Sanity patches from the prompt.

**Related:** 012, 014, 017.

### AVI-AGENT-060 — Autonomy Gradient

**Structure:** recommend → draft → execute reversible action → execute mutation → autonomous operation. Increase only when reliability and governance support it.

**Apply:** Product copilot and coding agents.

**Cursor:** Coding agents: high autonomy on reversible branch work; zero autonomy on merge/prod. Ask Vetra: clerical writes only when the user clearly instructs; no hiring decisions.

**Anti-pattern:** Same autonomy for README typos and production billing.

**Related:** 017, 020, 045.
