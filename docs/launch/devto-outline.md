# Article Outline

**Working title:** Why "This Fixes It" Is the Most Dangerous Sentence in AI-Assisted Debugging

1. **Hook.** A realistic `KeyError` and the `.get()` answer that hides the problem.
2. **The failure pattern.** Confident answers, symptom patching, no reproduction, no test.
3. **The principle.** A fix is a hypothesis until executed. Introduce the three statuses.
4. **The workflow.** Evidence, ranked hypotheses with falsifying checks, minimal fix, regression test that fails first.
5. **Side-by-side.** Use `examples/before-after.md`.
6. **Hard cases.** Flaky tests (why one passing run proves little, and the 3/p rule), performance (measure first), ML (overfit one batch, NaN diagnosis).
7. **Making it portable.** Claude skill, AGENTS.md, Cursor rule, Copilot instructions.
8. **Evaluation.** Describe the adversarial evals and report real measured results only.
9. **Limitations.** Cannot force execution; depends on the model following instructions; evals are small.
10. **Call to action.** Repository link, request for failure cases, invitation to add language references.
