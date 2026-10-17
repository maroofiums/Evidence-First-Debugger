---
name: evidence-first-debugger
description: Investigate bugs, test failures, crashes, wrong outputs, flaky behavior, and performance regressions using collected evidence, ranked hypotheses, minimal fixes, and regression tests, and never claim a fix works without verification. Use this skill whenever the user reports a bug, error, traceback, failing test, unexpected output, "it works on my machine" problem, intermittent failure, or asks "why is this broken", "fix this", "debug this", or "what is wrong with this code", even if they do not say the word "debug". Also use it when reviewing a proposed fix to decide whether it has actually been verified.
---

# Evidence-First Debugger

A disciplined debugging workflow. The core rule: **a fix is a hypothesis until it has been verified by execution.** Plausible reasoning is not verification.

## Operating principles

1. **Evidence before theory.** Do not propose a cause until something has been observed: an error message, a stack trace, a log line, a failing test, a diff, an actual value.
2. **Multiple hypotheses, ranked.** Never commit to the first idea. List at least two to three candidates and rank them by likelihood given the evidence.
3. **Every hypothesis must be falsifiable.** State a cheap check that would prove each one wrong.
4. **Minimal fix.** Change the smallest amount of code that addresses the confirmed root cause.
5. **Regression test.** Every fix ships with a test that fails before the fix and passes after it.
6. **No unverified success claims.** Use the verification vocabulary and never upgrade a status without running something.

## Workflow

Follow the phases in order. Read each reference file when you reach its phase.

| Phase | Goal | Reference |
|-------|------|-----------|
| 1. Symptom and reproduction | Pin down expected vs actual; reproduce and minimize | `references/01-symptom-and-reproduction.md` |
| 2. Evidence gathering | Collect observations, not conclusions | `references/02-evidence-gathering.md` |
| 3. Hypotheses | Rank candidates; define falsifying checks; test them | `references/03-hypotheses.md` |
| 4. Fix and regression test | Minimal change; test that fails before and passes after | `references/04-fix-and-regression-test.md` |
| 5. Verification gate | Run everything; assign VERIFIED, PARTIALLY VERIFIED, or UNVERIFIED | `references/05-verification-gate.md` |
| 6. Report | Deliver findings in a consistent structure | `references/06-report-template.md` |

Additional references, read only when relevant:

- `references/07-no-execution-mode.md`: when code cannot be run in the current environment.
- `references/08-failure-modes.md`: common debugging mistakes to avoid.
- `references/09-flaky-and-concurrency.md`: intermittent failures, races, hangs, order dependence.
- `references/10-performance-regressions.md`: slowdowns, profiling, query counts, before and after measurement.
- `references/11-ml-training-bugs.md`: NaN loss, non-decreasing loss, leakage, shape errors, silent ML bugs.
- `references/12-debug-log-template.md`: running log for long or multi-turn investigations.
- `references/python-diagnostics.md`: concrete commands for Python, pytest, Django, FastAPI, and PyTorch.

## Verification statuses (always required)

- **VERIFIED**: the reproduction and tests were executed after the fix and passed. Include the command and the relevant output.
- **PARTIALLY VERIFIED**: some checks ran and passed; others could not run. State exactly which.
- **UNVERIFIED**: the fix was not executed. Provide the commands the user should run.

Forbidden phrasing unless status is VERIFIED: "this fixes it", "this should resolve it", "the bug is fixed", "that's the problem". Use calibrated language such as "the evidence points to" or "this is expected to fix it, pending the commands below".

## Scaling the process

For a small, obvious bug, compress the report to: symptom, evidence, root cause, fix, test, verification status. The verification status line is never omitted.
