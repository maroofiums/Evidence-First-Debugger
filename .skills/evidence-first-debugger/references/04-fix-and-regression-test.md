# Phase 4: Fix and Regression Test

## Minimal fix

- State the root cause first.
- Change only what the root cause requires.
- Explain why the fix addresses the cause and not only the symptom.
- List anything noticed but deliberately not changed.
- Avoid drive-by refactors, formatting changes, and unrelated cleanups in the same change.

## Regression test requirements

The test must:

- Encode the bug's exact trigger, using the minimal reproduction.
- **Fail on the original code** and **pass on the fixed code**.
- Be deterministic: no sleeps, real network calls, or reliance on test ordering.
- Have a name that describes the behavior, for example `test_refund_rejects_negative_amount`.

## Confirming fail-before and pass-after

When execution is available:

```bash
git stash            # remove the fix, keep the test
pytest path/to/test_file.py::test_name   # must FAIL
git stash pop        # restore the fix
pytest path/to/test_file.py::test_name   # must PASS
```

If the test passes on the original code, it does not test the bug. Rewrite it.
