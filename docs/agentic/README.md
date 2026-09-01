# Agentic workflow (all Cursor projects)

The **Avinash Agentic Software Design Pattern Catalog** (`AVI-AGENT-001`–`060`) is a **global Cursor harness**, not a Vetra-only SOP.

| Layer | Where | Applies to |
| --- | --- | --- |
| User Rule | Cursor → Customize → Rules ← `global/USER_RULE.md` | Every **local** project |
| Team Rule | Cursor Dashboard ← `global/TEAM_RULE.md` | Every team member / repo (Team plan) |
| User-level skill | `~/.cursor/skills/avi-agentic-engineering/` | Every **local** project on that machine |
| In-repo skill | `.agents/skills/avi-agentic-engineering/` | **Cloud Agents** (they cannot see `~/`) |
| Project overlay | `PROJECT.yaml` + `AGENTS.md` | That repository only |

Canonical files in this checkout: [SKILL.md](../../.agents/skills/avi-agentic-engineering/SKILL.md).

## Install once (your laptop)

```bash
.agents/skills/avi-agentic-engineering/scripts/install-global.sh
```

Then paste [USER_RULE.md](../../.agents/skills/avi-agentic-engineering/global/USER_RULE.md) into User Rules.

## Seed another git repo

```bash
.agents/skills/avi-agentic-engineering/scripts/bootstrap-repo.sh /path/to/other-repo --with-project-skill
```

Or invoke the `avi-bootstrap-repo` skill in Agent chat.

`--with-project-skill` is required if Cloud Agents will work in that repo.

Canonical loop:

**Intent → Coordinator → scoped knowledge → specialist agents → policy-gated capabilities → deterministic execution → verification → independent review → human gate → PR → audit + memory update.**
