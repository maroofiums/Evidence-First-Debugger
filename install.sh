#!/usr/bin/env bash
# Install Evidence-First Debugger.
# Usage:
#   ./install.sh                 # install into the current project (.claude/skills)
#   ./install.sh --user          # install for the current user (~/.claude/skills)
#   ./install.sh --agents        # also copy AGENTS.md, Cursor rule, and Copilot instructions into the current directory
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL="$SRC/.skills/evidence-first-debugger"
TARGET=".claude/skills"
AGENTS=0

for arg in "$@"; do
  case "$arg" in
    --user) TARGET="$HOME/.claude/skills" ;;
    --agents) AGENTS=1 ;;
    -h|--help) sed -n 2,7p "$0"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

mkdir -p "$TARGET"
rm -rf "$TARGET/evidence-first-debugger"
cp -r "$SKILL" "$TARGET/evidence-first-debugger"
echo "Installed skill to $TARGET/evidence-first-debugger"

if [ "$AGENTS" -eq 1 ]; then
  cp "$SRC/AGENTS.md" ./AGENTS.md
  mkdir -p .cursor/rules .github
  cp "$SRC/.cursor/rules/evidence-first-debugger.mdc" .cursor/rules/
  cp "$SRC/.github/copilot-instructions.md" .github/copilot-instructions.md
  echo "Copied AGENTS.md, Cursor rule, and Copilot instructions"
fi
