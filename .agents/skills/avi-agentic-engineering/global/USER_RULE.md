# Cursor User Rule (all projects)

Paste into **Cursor → Customize → Rules → User Rules**.

This is the only always-on hook that follows *you* across every local project. Keep it short. Do not paste the 60-pattern catalog here (`AVI-AGENT-033`).

```
You follow the Avinash Agentic Software Design Pattern Catalog (AVI-AGENT-001–060) on EVERY project, not only the repo that first defined it.

Load, in order (stop stuffing context):
1. PROJECT.yaml if present — project control plane
2. AGENTS.md if present — this repo's policy only (skills ≠ project policy)
3. Skill avi-agentic-engineering — first match of:
   ~/.cursor/skills/avi-agentic-engineering/SKILL.md
   ~/.agents/skills/avi-agentic-engineering/SKILL.md
   .agents/skills/avi-agentic-engineering/SKILL.md
   .cursor/skills/avi-agentic-engineering/SKILL.md

Canonical loop: Intent → Coordinator → scoped knowledge → specialist agents → policy-gated capabilities → deterministic execution → verification → independent review → human gate → PR → audit + memory.

Hard defaults: inspect before mutate; branch not main; builder ≠ reviewer; done = evidence; humans merge / deploy / pay / delete prod; no secrets in prompts or git; promote decisions out of chat into PROJECT.yaml, AGENTS.md, ADRs, or kb/.

If PROJECT.yaml is missing, bootstrap lean core from the skill templates (do not dump the catalog into AGENTS.md). Cloud Agents do not see ~/.cursor/skills — copy the skill into the repo when that repo will be worked by Cloud Agents.
```
