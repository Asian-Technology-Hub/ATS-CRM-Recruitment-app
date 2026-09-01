# Project-type overlays (`AVI-AGENT-011`)

Start from a **lean core** (`PROJECT.yaml`, `AGENTS.md` overlay, `kb/`, Cursor rule pointing at `avi-agentic-engineering`). Add only the overlays the repo actually is.

| Overlay | Add | Do not add if unused |
| --- | --- | --- |
| `core` | Catalog skill, `PROJECT.yaml`, handoff/PR templates, `kb/` | — |
| `web-app` | App-router/UI verification, lint/typecheck/build, browser evidence | Mobile scaffolds, stores |
| `mobile` | Platform skills (Expo/Swift/Android), device allowlists | Next.js proxy conventions |
| `ai-agent` | MCP bus, tool contracts wrapping deterministic actions, model/policy notes, Insights/audit | A second unconstrained agent runtime |
| `infra` | Env isolation, deploy gates, production mutation = human | Prod credentials in the agent prompt |

Record overlays in each repo's `PROJECT.yaml`. Do not copy unused overlay scaffolding.
