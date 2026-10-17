# Phase 2: Evidence Gathering

Collect observations, not conclusions. Present evidence as a short list of facts, each labeled with its source.

## Sources, roughly in order of cost

1. **Stack trace.** Read the deepest frame in your own code first, then the frame that called it.
2. **Input values at the point of failure.** Print, log, or use a debugger. Check types and shapes as well as values.
3. **Version control.** `git log`, `git diff`, and `git bisect` for regressions.
4. **Dependency and environment differences.** Compare lockfiles, versions, and environment variables.
5. **Logs** around the time of failure.
6. **Determinism.** Run the failure repeatedly and note whether it is stable.

## Evidence format

```
- [stack trace] KeyError: 'user_id' raised at services/auth.py:42
- [print] payload keys at line 40: ['id', 'email']
- [git log] auth.py last changed in commit a1b2c3d, three days ago
```

## Rules

- Do not state a cause in this phase.
- Quote output verbatim.
- Label anything you inferred rather than observed as an inference.
