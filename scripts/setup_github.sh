#!/usr/bin/env bash
# One-time repository setup using the GitHub CLI (gh). Run after the first push.
# Requires: gh auth login
# Usage: ./scripts/setup_github.sh <github-username>/<repo>
set -euo pipefail
REPO="${1:?Usage: $0 <owner>/<repo>}"

gh repo edit "$REPO" \
  --description "Claude skill and agent instructions that make AI coding assistants debug with evidence, ranked hypotheses, regression tests, and honest verification status." \
  --enable-discussions \
  --enable-issues

for t in claude-skills claude-code ai-agents debugging llm prompt-engineering developer-tools code-review testing agents-md cursor-rules github-copilot software-engineering root-cause-analysis pytest python; do
  gh repo edit "$REPO" --add-topic "$t"
done

gh label create "new-language-reference" --repo "$REPO" --color 0e8a16 --description "Diagnostics reference for another language" --force
gh label create "good first issue" --repo "$REPO" --color 7057ff --force
gh label create "help wanted" --repo "$REPO" --color 008672 --force

gh issue create --repo "$REPO" --title "Add Node.js diagnostics reference" \
  --label "new-language-reference,good first issue,help wanted" \
  --body "Add references/node-diagnostics.md modeled on python-diagnostics.md: debugger flags, test runner repeat and fail-fast options, profiling, and common Node.js hypotheses (event loop blocking, unhandled promise rejections, module resolution). Link it from SKILL.md and the README, then run python scripts/validate_skill.py."
gh issue create --repo "$REPO" --title "Add Go diagnostics reference" \
  --label "new-language-reference,good first issue,help wanted" \
  --body "Add references/go-diagnostics.md: delve, go test -race -count, pprof, and common Go hypotheses (data races, goroutine leaks, nil interface values, shadowed variables). Link it from SKILL.md and the README, then run python scripts/validate_skill.py."
gh issue create --repo "$REPO" --title "Add Rust diagnostics reference" \
  --label "new-language-reference,good first issue,help wanted" \
  --body "Add references/rust-diagnostics.md: RUST_BACKTRACE, cargo test flags, cargo flamegraph, and common Rust hypotheses (borrow and lifetime misunderstandings, integer overflow in release builds, async blocking). Link it from SKILL.md and the README, then run python scripts/validate_skill.py."

echo "Done. Upload assets/social-preview.png manually under Settings > General > Social preview."
