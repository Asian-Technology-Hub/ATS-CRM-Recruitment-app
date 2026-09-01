# Avinash agentic catalog — adopted in Cursor

- **project:** vetra-crm
- **captured:** 2026-08-31
- **source_url:** conversation with coding agents (Codex / Cursor)
- **source_file:** .agents/skills/avi-agentic-engineering/
- **author:** Avinash
- **tags:** [sop, cursor, agents, handoff]
- **confidence:** high
- **status:** project

## Notes

The 60-pattern catalog (`AVI-AGENT-001`–`060`) is the development workflow for **every Cursor project**, not only this CRM.

- **Global:** `scripts/install-global.sh` → `~/.cursor/skills/` plus User Rule / Team Rule pointers
- **Per repo overlay:** `PROJECT.yaml` + `AGENTS.md` (this CRM’s tenancy/stack rules)
- **Cloud Agents:** in-repo `.agents/skills/` copy (`bootstrap-repo.sh --with-project-skill`) because `~/` skills are not synced to cloud workers

## Derived artifacts

- `.agents/skills/avi-agentic-engineering/`
- `PROJECT.yaml`
- `AGENTS.md` (policy overlay below the Next.js stamp)
- `.cursor/rules/avi-agentic.mdc`
- `docs/adr/0001-adopt-avi-agent-catalog.md`
