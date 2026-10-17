# Debug Log Template

Use this log for investigations that span many steps or multiple turns. It keeps evidence, hypotheses, and decisions visible so that nothing is repeated or forgotten.

```markdown
# Debug Log: <short title>

## Symptom
- Expected:
- Actual (verbatim):
- Reproduction command:
- Environment:

## Timeline
| # | Action | Result | Conclusion |
|---|--------|--------|------------|
| 1 | Ran reproduction | KeyError: 'user_id' at orders.py:42 | Failure reproduced |
| 2 | Printed payload keys | ['id', 'amount'] | Field name differs from expectation |

## Hypotheses
| # | Hypothesis | Status | Evidence |
|---|-----------|--------|----------|
| H1 | Legacy client sends `id` | Confirmed | Step 2 |
| H2 | Missing DB row | Eliminated | Query returned the row |

## Open questions
-

## Decisions
- Chose to fix at the schema layer because ...

## Changes made
- File, change, and reason

## Verification
- Commands run, outputs, status
```

## Rules

- Append to the log; do not rewrite earlier entries.
- Record eliminated hypotheses. They prevent repeated work.
- Record the command that produced each result so that it can be re-run.
