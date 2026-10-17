# Evidence-First Debugger

**Stop AI assistants from saying "this fixes it" when nothing was run.**

A skill and set of agent instructions that make AI coding assistants debug the way a careful engineer does: observe, rank hypotheses, make a minimal fix, prove it with a regression test, and report an honest verification status.

![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)
![Claude Skill](https://img.shields.io/badge/Claude-skill-informational.svg)
![AGENTS.md](https://img.shields.io/badge/AGENTS.md-supported-success.svg)
![Cursor](https://img.shields.io/badge/Cursor-rule-success.svg)
![Copilot](https://img.shields.io/badge/Copilot-instructions-success.svg)

![Evidence-First Debugger](assets/social-preview.png)

---

## The problem

Ask an assistant about a `KeyError` and a typical answer is:

```python
user_id = payload.get("user_id")   # "This fixes the error."
```

Nothing was run. The failure has only moved: the next line now receives `None`. There is no explanation of why the key was missing, and no test.

## What this changes

| Typical assistant answer | With Evidence-First Debugger |
|--------------------------|------------------------------|
| Proposes a cause from the first symptom | Reproduces and collects evidence before naming a cause |
| One confident explanation | At least two ranked hypotheses, each with a falsifying check |
| Patches the symptom (`.get()`, blanket `try/except`) | Minimal fix aimed at the confirmed root cause |
| No test, or a test that passes on the buggy code | Regression test that fails before the fix and passes after |
| "This fixes it" | One of `VERIFIED`, `PARTIALLY VERIFIED`, or `UNVERIFIED` |
| One passing run on a flaky bug counts as success | Repeated runs required, with the run count stated |

See the full side-by-side in [examples/before-after.md](examples/before-after.md).

## Quick start

Choose the tool you use.

### Claude Code or Claude.ai

```bash
git clone https://github.com/maroofiums/Evidence-First-Debugger.git
cd Evidence-First-Debugger
./install.sh            # installs into ./.claude/skills in the current directory
./install.sh --user     # or install for your user account (~/.claude/skills)
```

For Claude.ai, upload `evidence-first-debugger.skill` from the [Releases](https://github.com/maroofiums/Evidence-First-Debugger/releases) page under Settings, Capabilities.

### Cursor, Codex, GitHub Copilot, and other agents

Copy the portable instruction files into your project:

```bash
./install.sh --agents
```

This copies `AGENTS.md`, `.cursor/rules/evidence-first-debugger.mdc`, and `.github/copilot-instructions.md`.

| Tool | File used |
|------|-----------|
| Claude Code, Claude.ai | `.skills/evidence-first-debugger/` (full skill with references) |
| Claude Code (project instructions) | `CLAUDE.md` |
| Codex, other AGENTS.md readers | `AGENTS.md` |
| Cursor | `.cursor/rules/evidence-first-debugger.mdc` |
| GitHub Copilot | `.github/copilot-instructions.md` |

The agent files contain the condensed protocol. The Claude skill additionally loads detailed references on demand.

## Core principles

1. **Evidence before theory.** No cause is proposed until something has been observed.
2. **Ranked hypotheses.** At least two to three candidates, each with a falsifying check.
3. **Minimal fix.** Only the change the confirmed root cause requires.
4. **Regression test.** Must fail on the original code and pass on the fixed code.
5. **No unverified success claims.** A fix is a hypothesis until executed.

## How it works

```
Symptom --> Reproduce --> Evidence --> Ranked hypotheses --> Test hypotheses
                                                                   |
        Report <-- Verification gate <-- Regression test <-- Minimal fix
```

| Phase | Goal | Reference |
|-------|------|-----------|
| 1. Symptom and reproduction | Pin down expected vs actual; reproduce and minimize | [01-symptom-and-reproduction.md](.skills/evidence-first-debugger/references/01-symptom-and-reproduction.md) |
| 2. Evidence gathering | Collect observations, not conclusions | [02-evidence-gathering.md](.skills/evidence-first-debugger/references/02-evidence-gathering.md) |
| 3. Hypotheses | Rank candidates and run falsifying checks | [03-hypotheses.md](.skills/evidence-first-debugger/references/03-hypotheses.md) |
| 4. Fix and regression test | Minimal change; fail-before, pass-after test | [04-fix-and-regression-test.md](.skills/evidence-first-debugger/references/04-fix-and-regression-test.md) |
| 5. Verification gate | Execute everything and assign a status | [05-verification-gate.md](.skills/evidence-first-debugger/references/05-verification-gate.md) |
| 6. Report | Consistent final structure | [06-report-template.md](.skills/evidence-first-debugger/references/06-report-template.md) |

Specialized references:

- [07-no-execution-mode.md](.skills/evidence-first-debugger/references/07-no-execution-mode.md): behavior when code cannot be run
- [08-failure-modes.md](.skills/evidence-first-debugger/references/08-failure-modes.md): common debugging mistakes
- [09-flaky-and-concurrency.md](.skills/evidence-first-debugger/references/09-flaky-and-concurrency.md): intermittent failures, races, hangs
- [10-performance-regressions.md](.skills/evidence-first-debugger/references/10-performance-regressions.md): profiling and measured before/after results
- [11-ml-training-bugs.md](.skills/evidence-first-debugger/references/11-ml-training-bugs.md): NaN loss, leakage, silent ML failures
- [12-debug-log-template.md](.skills/evidence-first-debugger/references/12-debug-log-template.md): log for long investigations
- [python-diagnostics.md](.skills/evidence-first-debugger/references/python-diagnostics.md): commands for Python, pytest, Django, FastAPI, and PyTorch

## Verification statuses

Every report ends with exactly one status.

| Status | Meaning |
|--------|---------|
| `VERIFIED` | Reproduction, regression test, and surrounding suite were executed after the fix and passed. |
| `PARTIALLY VERIFIED` | Some checks ran and passed; others could not run. The report states which. |
| `UNVERIFIED` | Nothing was executed. The report supplies commands for the user to run. |

Phrases such as "this fixes it" or "the bug is fixed" are forbidden unless the status is `VERIFIED`.

## Examples

- [examples/before-after.md](examples/before-after.md): a typical answer next to an evidence-first answer for the same bug.
- [examples/worked-example.md](examples/worked-example.md): FastAPI `KeyError`, with hypothesis table, regression test, and `VERIFIED` status.
- [examples/pytorch-nan-loss.md](examples/pytorch-nan-loss.md): NaN loss traced to `log(softmax(x))` underflow, with a finite-loss regression test.

The examples are illustrative; their command output is representative, not copied from real runs.

## Evaluation

`.skills/evidence-first-debugger/evals/evals.json` contains six prompts with verifiable expectations, including adversarial cases such as "the error message changed, so it's fixed, right?" and "I added a sleep and it passes".

Measured results: _not yet published_. Run the evals with and without the skill and record real pass rates here before making any performance claims.

## FAQ

**Does it make the model run my code?**
No. A skill cannot force execution. When the assistant cannot run code, it must report `UNVERIFIED` and give you the exact commands to run. When it can run code, it must run the reproduction and tests before claiming success.

**Is this only for Python?**
The method is language-independent. The bundled diagnostics reference focuses on Python, pytest, Django, FastAPI, and PyTorch. Contributions for other languages are welcome.

**Will it slow down simple bugs?**
For small, obvious bugs the report compresses to six lines: symptom, evidence, root cause, fix, test, status.

**How is this different from a generic "think step by step" prompt?**
It adds hard requirements that can be checked: falsifiable hypotheses, a regression test that fails first, and a fixed vocabulary of verification statuses with forbidden phrasing.

## Show that you use it

If a repository adopts this protocol, add this badge to its README:

```markdown
[![Debugged with Evidence-First](https://img.shields.io/badge/debugging-evidence--first-2f81f7)](https://github.com/maroofiums/Evidence-First-Debugger)
```

## Contributing

Contributions are welcome, especially:

- Diagnostics references for other languages (Node.js, Go, Rust, Java)
- Additional evals, particularly cases where the skill still allows an unverified claim
- Real, measured evaluation results

See [CONTRIBUTING.md](CONTRIBUTING.md) and the [Code of Conduct](CODE_OF_CONDUCT.md). If you find a failure, open a [skill gap report](.github/ISSUE_TEMPLATE/skill-gap.md).

## Publishing your copy

```bash
python scripts/validate_skill.py
git remote add origin https://github.com/maroofiums/Evidence-First-Debugger.git
git push -u origin main --tags
./scripts/setup_github.sh maroofiums/Evidence-First-Debugger   # description, topics, labels, starter issues
```

Forks can replace the username throughout with `./scripts/set_username.sh <github-username>` (it rewrites `<your-username>` placeholders only, so it is a no-op on this repository).

Pushing a tag such as `v0.3.0` triggers the release workflow, which validates the repository and attaches `evidence-first-debugger.skill` to a GitHub release.

## Validation

```bash
python scripts/validate_skill.py
```

The script checks frontmatter, the 500-line limit for `SKILL.md`, that every reference file is linked, that relative markdown links resolve, and that `evals.json` is well formed. The same check runs in GitHub Actions on every push and pull request.

## Repository Structure

```
evidence-first-debugger/
├── README.md
├── CHANGELOG.md
├── LICENSE
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── AGENTS.md                           # portable instructions (Codex, Cursor, others)
├── CLAUDE.md                           # Claude Code project instructions
├── install.sh
├── assets/social-preview.png
├── docs/launch/                        # launch kit and GitHub setup notes
├── .cursor/rules/evidence-first-debugger.mdc
├── .github/
│   ├── workflows/validate.yml          # CI: structure, link, and eval checks
│   ├── ISSUE_TEMPLATE/skill-gap.md
│   ├── copilot-instructions.md
│   └── pull_request_template.md
├── scripts/
│   └── validate_skill.py
├── .skills/
│   └── evidence-first-debugger/
│       ├── SKILL.md                    # entry point: principles, workflow table, statuses
│       ├── evals/evals.json            # six test prompts with verifiable expectations
│       └── references/
│           ├── 01-symptom-and-reproduction.md
│           ├── 02-evidence-gathering.md
│           ├── 03-hypotheses.md
│           ├── 04-fix-and-regression-test.md
│           ├── 05-verification-gate.md
│           ├── 06-report-template.md
│           ├── 07-no-execution-mode.md
│           ├── 08-failure-modes.md
│           ├── 09-flaky-and-concurrency.md
│           ├── 10-performance-regressions.md
│           ├── 11-ml-training-bugs.md
│           ├── 12-debug-log-template.md
│           └── python-diagnostics.md
└── examples/
    ├── before-after.md
    ├── worked-example.md
    └── pytorch-nan-loss.md
```

`SKILL.md` is intentionally short. Detailed instructions live in `references/` and are loaded only when the relevant phase is reached (progressive disclosure).

## License

Released under the [MIT License](LICENSE).
