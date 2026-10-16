# Phase 6: Report Template

Use this structure for the final report. Omit a section only if it genuinely does not apply.

```markdown
## Summary
One or two sentences: symptom, root cause, status.

## Symptom and reproduction
Expected vs actual, environment, reproduction command.

## Evidence
- [source] observation
- [source] observation

## Hypotheses
Ranked table with the final status of each: confirmed / eliminated / inconclusive.

## Root cause
What is wrong, where, and why. How it was confirmed.

## Fix
Minimal diff with a short rationale.

## Regression test
Test code and confirmation of fail-before / pass-after.

## Verification
Status: VERIFIED | PARTIALLY VERIFIED | UNVERIFIED
Commands run and their output, or commands the user must run.

## Residual risks
Related issues noticed but not changed; assumptions still unchecked.
```

## Compact form for small bugs

```markdown
Symptom: ...
Evidence: ...
Root cause: ...
Fix: ...
Test: ...
Status: VERIFIED | PARTIALLY VERIFIED | UNVERIFIED
```
