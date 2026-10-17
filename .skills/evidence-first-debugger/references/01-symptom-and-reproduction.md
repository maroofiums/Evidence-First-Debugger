# Phase 1: Symptom and Reproduction

## Establish the symptom

Record precisely:

- Expected behavior versus actual behavior
- Exact error text, exit code, or wrong output, quoted verbatim and not paraphrased
- Environment: language and library versions, OS, relevant configuration, inputs
- Frequency: always, intermittent, or only under specific conditions
- What changed recently: commit, dependency bump, configuration, data

If a critical detail is missing and cannot be obtained by running something yourself, ask for it. Ask only for what blocks progress.

## Reproduce before theorizing

- If execution is available, run the failing command or test and capture the real output.
- Reduce to a minimal reproduction: strip inputs, dependencies, and code until the failure remains but nothing extraneous does.
- If the failure cannot be reproduced, say so explicitly. That is itself evidence and points toward environment, data, timing, or concurrency.
- Record the reproduction command. It is reused in the verification gate.

## Minimization checklist

- [ ] Can the input be made smaller while the failure persists?
- [ ] Can unrelated modules, middleware, or fixtures be removed?
- [ ] Does it fail in a fresh virtual environment?
- [ ] Does it fail deterministically? Run it several times and record the count.
