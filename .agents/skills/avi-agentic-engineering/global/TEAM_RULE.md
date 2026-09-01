# Cursor Team Rule (all team members, all repos)

Paste into **Cursor Dashboard → Team Rules**. Enable immediately. Enforce if the team must not disable it.

Team Rules take precedence over project and user rules. Keep this as a pointer; put Vetra/product constraints in each repo's `AGENTS.md`.

```
Team standard: Avinash Agentic Software Design Pattern Catalog (AVI-AGENT-001–060).

Agents load PROJECT.yaml then AGENTS.md (project policy only), then skill avi-agentic-engineering (user-global ~/.cursor/skills or repo .agents/skills). Do not paste the catalog into this team rule.

Canonical loop: Intent → Coordinator → scoped knowledge → specialist agents → policy-gated tools → verify → independent review → human merge.

Cloud Agents: install the skill into the repository (.agents/skills/avi-agentic-engineering) — user home skills are not copied to cloud workers.
```
