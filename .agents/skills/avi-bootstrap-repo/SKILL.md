---
name: avi-bootstrap-repo
description: >
  Seed the Avinash agentic harness into ANY Cursor project: PROJECT.yaml,
  AGENTS.md overlay, kb/, thin .cursor/rules, optional in-repo skill copy for
  Cloud Agents. Use when opening a repo that lacks PROJECT.yaml, when the user
  says apply avi-agentic patterns globally or to another project, or when
  bootstrapping a new repository.
---

# Bootstrap Avinash harness into a repo

The catalog skill is **global**. This skill only **seeds lean core** (`AVI-AGENT-011`). Do not copy the 60 cards into `AGENTS.md`.

## Decide scope

| Goal | Action |
| --- | --- |
| All **local** Cursor projects on this machine | Run `scripts/install-global.sh`, then paste `global/USER_RULE.md` into Cursor User Rules |
| All **team** members / repos | Paste `global/TEAM_RULE.md` into Cursor Dashboard Team Rules |
| This git repo (and Cloud Agents on it) | Run `scripts/bootstrap-repo.sh . --with-project-skill` |
| Another local git repo | `scripts/bootstrap-repo.sh /path/to/repo --with-project-skill` |

Scripts live next to `avi-agentic-engineering` (user-global or this repo):

```bash
# from a checkout that already has the skill
.agents/skills/avi-agentic-engineering/scripts/install-global.sh
.agents/skills/avi-agentic-engineering/scripts/bootstrap-repo.sh "$TARGET" --with-project-skill
```

If only the user-global skill exists:

```bash
~/.cursor/skills/avi-agentic-engineering/scripts/install-global.sh
~/.cursor/skills/avi-agentic-engineering/scripts/bootstrap-repo.sh "$TARGET" --with-project-skill
```

## After bootstrap

1. Edit `PROJECT.yaml`: `id`, `name`, `overlays`, `systems`, `policies`, load-bearing files.
2. Put **this repo's** constraints in `AGENTS.md` below any framework stamp.
3. Do not duplicate catalog cards.

## Cloud Agents

Cursor does **not** copy `~/.cursor/skills/` to Cloud Agents. Any repo a Cloud Agent will touch needs `--with-project-skill` (skill files committed) plus the thin `.cursor/rules/avi-agentic.mdc`.
