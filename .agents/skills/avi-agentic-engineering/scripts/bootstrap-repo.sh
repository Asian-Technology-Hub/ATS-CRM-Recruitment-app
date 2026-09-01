#!/usr/bin/env bash
# Seed lean-core agent harness in ANY git repo (AVI-AGENT-011).
#
# Usage:
#   bootstrap-repo.sh [TARGET_DIR] [--with-project-skill]
#
# Default: PROJECT.yaml (if missing), kb/, docs/adr/, thin .cursor/rules pointer.
# --with-project-skill: also copy the catalog skill into the repo (required for
# Cursor Cloud Agents, which cannot see ~/.cursor/skills).
set -euo pipefail

SKILL_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="."
WITH_SKILL=0

for arg in "$@"; do
  case "$arg" in
    --with-project-skill) WITH_SKILL=1 ;;
    --help|-h)
      sed -n '2,12p' "$0"
      exit 0
      ;;
    *) TARGET="$arg" ;;
  esac
done

TARGET="$(cd "$TARGET" && pwd)"
if [[ ! -f "$SKILL_ROOT/SKILL.md" ]]; then
  echo "bootstrap-repo.sh: skill root missing SKILL.md" >&2
  exit 1
fi

mkdir -p "$TARGET/kb" "$TARGET/docs/adr" "$TARGET/.cursor/rules" "$TARGET/.cursor/skills/avi-agentic-engineering"

if [[ ! -f "$TARGET/PROJECT.yaml" ]]; then
  cp "$SKILL_ROOT/templates/PROJECT.yaml" "$TARGET/PROJECT.yaml"
  echo "wrote $TARGET/PROJECT.yaml"
else
  echo "keep existing $TARGET/PROJECT.yaml"
fi

if [[ ! -f "$TARGET/kb/README.md" ]]; then
  cat > "$TARGET/kb/README.md" <<'EOF'
# Project knowledge base (`AVI-AGENT-031`)

Project-scoped notes only. Use the kb-item template from `avi-agentic-engineering`. Retrieve on demand — do not inject this folder into every prompt.
EOF
  echo "wrote $TARGET/kb/README.md"
fi

# Thin Cursor rule — never duplicate the catalog.
cat > "$TARGET/.cursor/rules/avi-agentic.mdc" <<'EOF'
---
description: Avinash agentic SOP pointer for this repo. Catalog is global; this file is not the catalog.
alwaysApply: true
---

# Avinash agentic SOP

Follow `AVI-AGENT-001`–`060`. Do not paste the catalog into this rule.

**Load order**

1. `PROJECT.yaml` if present
2. `AGENTS.md` if present (project policy only)
3. Skill `avi-agentic-engineering`, first match:
   - `~/.cursor/skills/avi-agentic-engineering/SKILL.md`
   - `~/.agents/skills/avi-agentic-engineering/SKILL.md`
   - `.agents/skills/avi-agentic-engineering/SKILL.md`
   - `.cursor/skills/avi-agentic-engineering/SKILL.md`

If `PROJECT.yaml` is missing, bootstrap from the skill templates (`AVI-AGENT-011`).
EOF
echo "wrote $TARGET/.cursor/rules/avi-agentic.mdc"

cat > "$TARGET/.cursor/skills/avi-agentic-engineering/SKILL.md" <<'EOF'
---
name: avi-agentic-engineering
description: >
  Pointer to the Avinash agentic SOP (AVI-AGENT-001–060). Prefer the user-global
  skill; this stub exists so Agent can discover the name in this repo.
---

Read the first existing SKILL.md:

1. `~/.cursor/skills/avi-agentic-engineering/SKILL.md`
2. `~/.agents/skills/avi-agentic-engineering/SKILL.md`
3. `.agents/skills/avi-agentic-engineering/SKILL.md`
EOF

if [[ ! -f "$TARGET/AGENTS.md" ]]; then
  {
    echo "# Project agent policy"
    echo
    cat "$SKILL_ROOT/templates/AGENTS.overlay.md"
  } > "$TARGET/AGENTS.md"
  echo "wrote $TARGET/AGENTS.md"
else
  echo "keep existing $TARGET/AGENTS.md (append overlay from templates/AGENTS.overlay.md if needed)"
fi

if [[ "$WITH_SKILL" -eq 1 ]]; then
  DEST="$TARGET/.agents/skills/avi-agentic-engineering"
  mkdir -p "$(dirname "$DEST")"
  rm -rf "$DEST"
  mkdir -p "$DEST"
  tar -C "$SKILL_ROOT" -cf - --exclude='.git' . | tar -C "$DEST" -xf -
  echo "copied skill → $DEST (Cloud Agent fallback)"
fi

echo
echo "Bootstrapped $TARGET"
echo "Fill PROJECT.yaml (name, overlays, commands, load-bearing files)."
