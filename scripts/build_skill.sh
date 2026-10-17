#!/usr/bin/env bash
# Build dist/evidence-first-debugger.skill (a zip of the skill folder).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/.skills"
mkdir -p "$ROOT/dist"
rm -f "$ROOT/dist/evidence-first-debugger.skill"
zip -qr "$ROOT/dist/evidence-first-debugger.skill" evidence-first-debugger -x "*/evals/*" "*.DS_Store"
echo "Built dist/evidence-first-debugger.skill"
