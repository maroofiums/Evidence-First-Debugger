# Common Failure Modes

Avoid the following.

1. **Fixing the symptom.** Adding a `try/except` or a `None` check without finding why the bad value appeared.
2. **Changing several things at once.** It becomes impossible to know which change worked.
3. **Trusting a single passing run** for a flaky bug. Run it enough times to be meaningful and state the count.
4. **Declaring success because the error message changed.** A different error is not a fix.
5. **A regression test that passes on the buggy code.** It does not test the bug.
6. **Silencing or deleting a failing test** instead of understanding it.
7. **Anchoring on the first hypothesis.** Keep at least two alternatives alive until a check eliminates them.
8. **Confusing correlation with cause.** A recent commit near the failure is a hypothesis, not a finding.
9. **Skipping reproduction.** Theorizing about a failure that has not been observed produces confident but unsupported conclusions.
10. **Overstating certainty.** Match the strength of the language to the strength of the evidence.
