#!/usr/bin/env python3
"""Validate the skill structure.

Checks:
  1. SKILL.md has YAML frontmatter with name and description.
  2. SKILL.md is under 500 lines.
  3. Every file in references/ is linked from SKILL.md.
  4. Every relative markdown link in the repository resolves to an existing file.
  5. evals/evals.json is valid and each eval has an id, prompt, and expectations.
Exit code is non-zero if any check fails.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILL_DIR = ROOT / ".skills" / "evidence-first-debugger"
SKILL_MD = SKILL_DIR / "SKILL.md"
errors = []


def fail(msg):
    errors.append(msg)
    print(f"FAIL: {msg}")


def ok(msg):
    print(f"ok:   {msg}")


# 1. Frontmatter
text = SKILL_MD.read_text(encoding="utf-8")
m = re.match(r"^---\n(.*?)\n---\n", text, re.DOTALL)
if not m:
    fail("SKILL.md is missing YAML frontmatter")
else:
    fm = m.group(1)
    for key in ("name", "description"):
        if not re.search(rf"^{key}:\s*\S", fm, re.MULTILINE):
            fail(f"frontmatter missing '{key}'")
    if not errors:
        ok("frontmatter has name and description")

# 2. Length
n_lines = len(text.splitlines())
if n_lines > 500:
    fail(f"SKILL.md has {n_lines} lines (limit 500)")
else:
    ok(f"SKILL.md length {n_lines} lines")

# 3. References linked from SKILL.md
for ref in sorted((SKILL_DIR / "references").glob("*.md")):
    if f"references/{ref.name}" not in text:
        fail(f"{ref.name} is not linked from SKILL.md")
    else:
        ok(f"{ref.name} linked from SKILL.md")

# 4. Relative links resolve
link_re = re.compile(r"\[[^\]]*\]\(([^)\s]+)\)")
for md in ROOT.rglob("*.md"):
    if ".git/" in str(md):
        continue
    for target in link_re.findall(md.read_text(encoding="utf-8")):
        if target.startswith(("http://", "https://", "mailto:", "#")):
            continue
        path = target.split("#")[0]
        if not path:
            continue
        if not (md.parent / path).resolve().exists():
            fail(f"{md.relative_to(ROOT)}: broken link -> {target}")
ok("relative link check complete")

# 5. Evals
evals_path = SKILL_DIR / "evals" / "evals.json"
try:
    data = json.loads(evals_path.read_text(encoding="utf-8"))
    ids = [e["id"] for e in data["evals"]]
    if len(ids) != len(set(ids)):
        fail("duplicate eval ids")
    for e in data["evals"]:
        if not e.get("prompt") or not e.get("expectations"):
            fail(f"eval {e.get('id')} missing prompt or expectations")
    if data.get("skill_name") != "evidence-first-debugger":
        fail("evals skill_name does not match skill name")
    ok(f"evals.json valid ({len(ids)} evals)")
except Exception as exc:  # noqa: BLE001
    fail(f"evals.json invalid: {exc}")

print()
if errors:
    print(f"{len(errors)} problem(s) found")
    sys.exit(1)
print("All checks passed")
