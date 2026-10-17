# No-Execution Mode

Use this mode when code cannot be run in the current environment.

## Principles

- Do not pretend to have run anything.
- Still follow the full workflow.

## Procedure

1. Build hypotheses from the evidence the user provided.
2. Give the user specific diagnostic commands for the evidence and hypothesis-testing phases, and explain what each possible result would mean.
3. Deliver the fix and the regression test, both marked **UNVERIFIED**.
4. Provide verification commands and the output that would confirm success versus failure.
5. Ask the user to paste the output back, then update the hypothesis table.

## Example closing block

```
Status: UNVERIFIED

Please run:
  pytest tests/test_orders.py::test_refund_rejects_negative_amount -x
  pytest tests/test_orders.py

Expected if the fix is correct: the first command passes, the second shows no new failures.
Expected if the hypothesis was wrong: the first command still fails with the original KeyError.
```
