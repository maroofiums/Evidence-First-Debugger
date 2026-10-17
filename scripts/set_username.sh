#!/usr/bin/env bash
# Replace the <your-username> placeholder with your GitHub username.
# Usage: ./scripts/set_username.sh <github-username>
set -euo pipefail
if [ $# -ne 1 ]; then
  echo "Usage: $0 <github-username>" >&2
  exit 1
fi
USER_NAME="$1"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
grep -rl '<your-username>' --exclude-dir=.git . | while read -r f; do
  sed -i.bak "s#<your-username>#${USER_NAME}#g" "$f" && rm -f "$f.bak"
  echo "updated $f"
done
