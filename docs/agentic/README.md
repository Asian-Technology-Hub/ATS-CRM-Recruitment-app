# Agentic workflow (this repository)

Vetra uses the **Avinash Agentic Software Design Pattern Catalog** so Cursor, Codex, Claude, and ChatGPT follow the same AI → human handoff.

| Layer | Path | Pattern |
| --- | --- | --- |
| Cursor always-on | `.cursor/rules/avi-agentic.mdc` | AVI-AGENT-055 |
| Project policy | `AGENTS.md` | AVI-AGENT-010 |
| Control plane | `PROJECT.yaml` | AVI-AGENT-053 |
| Reusable SOP + 60 patterns | `.agents/skills/avi-agentic-engineering/` | AVI-AGENT-001–060 |
| Project KB | `kb/` | AVI-AGENT-031 |
| ADRs | `docs/adr/` | AVI-AGENT-009 |
| PR template | `.github/PULL_REQUEST_TEMPLATE.md` | AVI-AGENT-028 |

Start at the skill: [SKILL.md](../../.agents/skills/avi-agentic-engineering/SKILL.md).

Canonical loop:

**Intent → Coordinator → scoped knowledge → specialist agents → policy-gated capabilities → deterministic execution → verification → independent review → human gate → PR → audit + memory update.**
