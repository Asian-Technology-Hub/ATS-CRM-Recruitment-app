# Cursor playbook — mapping harness features to AVI-AGENT IDs

Use this when deciding *how* to run work inside Cursor (IDE or Cloud Agent). Pattern semantics live in `catalog.md`.

## Always on

| Cursor mechanism | Patterns |
| --- | --- |
| `.cursor/rules/avi-agentic.mdc` (`alwaysApply`) | 010, 055 |
| `AGENTS.md` + `PROJECT.yaml` | 009, 010, 053 |
| `CLAUDE.md` → `@AGENTS.md` | 010 |
| Feature branch `cursor/<name>-*` + PR | 008, 020, 051 |

## Routing and orchestration

| If you need… | Use | Patterns |
| --- | --- | --- |
| Classify the request | Skill SOP intent table | 002 |
| Map the repo | `Task` `explore`, or targeted Grep/Read | 007, 033 |
| Parallel independent edits | Multiple `Task` in one turn, disjoint files | 005 |
| Recursive split | Plan with epics/tasks; scoped `Task` prompts | 004 |
| Staged pipeline | explore → implement → verify → `code-reviewer` | 003, 001 |
| Independent review | `code-reviewer` (CodeRabbit); `security-review` only if asked | 006, 050 |
| UI verification | Browser / `computerUse` | 027, 041 |
| User asked Bugbot-style review | `bugbot` subagent only | 006 |

Do not use `CreateGoal` unless the user explicitly asked for a goal.

## Tools and MCP

| If you need… | Use | Patterns |
| --- | --- | --- |
| External capability | `GetDynamicTools` then `CallDynamicTool` | 015, 016 |
| GitHub read | `gh` read-only / Github MCP | 051 |
| PR create/update | `ManagePullRequest` (not `gh pr create`) | 008, 020 |
| Clerk/Sanity/design how-to | existing skills in `.agents/skills/` | 010, 033 |
| Model the user named | that model; listed slugs only for Task | 046, 047 |

## Policy gates in this harness

| Action | Allowed? | Patterns |
| --- | --- | --- |
| Edit files on a feature branch | Yes, after inspect | 007, 008 |
| Commit and push working branch | Yes (Cloud Agent) | 008 |
| Merge / close / reopen PR | Only if user explicitly asked | 020 |
| `gh` write (issues, PR create) | No — use the harness PR tool | 017 |
| Print or commit secrets | Never | 023 |
| Production data / billing mutations | Only with explicit user ask | 017, 024 |
| Disable security filters "to test" | Never | 019, 020 |

## Verification

Run the commands in `PROJECT.yaml` / `AGENTS.md`. Prefer those over ad-hoc tool success. UI: exercise the changed flow and shared surfaces that read the same state.

## Memory promotion at session end

| Decision type | Write to | Patterns |
| --- | --- | --- |
| Status, systems, links | `PROJECT.yaml` | 053, 037 |
| Operating constraint | `AGENTS.md` | 010 |
| Reusable SOP | `.agents/skills/avi-*/` | 010, 056 |
| URL / note / reference | `kb/` | 031, 035 |
| Architecture choice | `docs/adr/` | 009 |
