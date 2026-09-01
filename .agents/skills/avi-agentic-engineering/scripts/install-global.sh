#!/usr/bin/env bash
# Install avi-agentic-engineering as a *user-level* Cursor skill so it applies
# to every local project on this machine (AVI-AGENT-010, AVI-AGENT-055).
#
# Cloud Agents, remote SSH, and other workers do NOT receive ~/.cursor/skills.
# For those, also run scripts/bootstrap-repo.sh --with-project-skill in each repo.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ ! -f "$ROOT/SKILL.md" ]]; then
  echo "install-global.sh: expected SKILL.md at $ROOT" >&2
  exit 1
fi

copy_skill() {
  local src="$1"
  local dest="$2"
  if [[ ! -f "$src/SKILL.md" ]]; then
    echo "skip (no SKILL.md): $src"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  local src_r dest_r
  src_r="$(cd "$src" && pwd)"
  mkdir -p "$dest"
  dest_r="$(cd "$dest" && pwd)"
  if [[ "$src_r" == "$dest_r" ]]; then
    echo "already $dest_r"
    return 0
  fi
  rm -rf "$dest"
  mkdir -p "$dest"
  tar -C "$src_r" -cf - --exclude='.git' . | tar -C "$dest" -xf -
  echo "installed $dest"
}

install_named() {
  local src="$1"
  local name
  name="$(basename "$src")"
  copy_skill "$src" "${HOME}/.cursor/skills/${name}"
  copy_skill "$src" "${HOME}/.agents/skills/${name}"
  copy_skill "$src" "${HOME}/.claude/skills/${name}"
  copy_skill "$src" "${HOME}/.codex/skills/${name}"
}

install_named "$ROOT"

BOOTSTRAP="$(cd "$ROOT/../avi-bootstrap-repo" 2>/dev/null && pwd || true)"
if [[ -n "${BOOTSTRAP}" && -f "${BOOTSTRAP}/SKILL.md" ]]; then
  install_named "$BOOTSTRAP"
fi

echo
echo "Desktop Cursor still needs a User Rule (once):"
echo "  Cursor → Customize → Rules → User Rules"
echo "  paste: $ROOT/global/USER_RULE.md"
echo
echo "Optional (Team/Enterprise): Dashboard → Team Rules ← global/TEAM_RULE.md"
echo
echo "Other git repos (including Cloud Agents):"
echo "  $ROOT/scripts/bootstrap-repo.sh /path/to/repo --with-project-skill"
