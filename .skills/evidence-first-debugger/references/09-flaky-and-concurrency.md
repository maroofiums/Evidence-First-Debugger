# Flaky Tests, Race Conditions, and Concurrency Bugs

Intermittent failures need a different evidence strategy: a single run proves almost nothing.

## Step 1: Measure the failure rate

Run the failing test repeatedly and record the count. Report results as "failed 7 of 50 runs", never "sometimes fails".

```bash
pytest path/to/test.py::test_name --count=50 -x      # pytest-repeat
for i in $(seq 1 50); do pytest -q path/to/test.py::test_name || echo "FAIL $i"; done
```

## Step 2: Classify the flakiness

| Pattern | Likely category | Falsifying check |
|---------|-----------------|------------------|
| Fails only when the full suite runs | Shared state or test-order dependence | Run the test alone; run with `-p no:randomly`; bisect the test order |
| Fails under load or in CI only | Timing, resource limits | Add artificial delay; constrain CPU; compare CI and local versions |
| Fails near midnight, month end, or DST | Time and timezone | Freeze or shift the clock |
| Different result each run with same input | Unseeded randomness, set or dict ordering | Fix seeds; sort iterables before comparing |
| Hangs or deadlocks | Lock ordering, blocking call in async code | Dump all thread or task stacks while hung |
| Passes with a `sleep`, fails without | Race condition masked by delay | Replace sleep with an explicit wait on a condition |

## Step 3: Make it deterministic

- Fix random seeds (`random.seed`, `numpy.random.seed`, `torch.manual_seed`).
- Freeze time with a clock fixture.
- Replace real network, filesystem, and database dependencies with controlled fakes.
- Force ordering with explicit synchronization (events, barriers), not sleeps.

## Step 4: Verify a flaky fix

A fix for an intermittent bug is VERIFIED only after a statistically meaningful number of runs. A reasonable minimum: if the original failure rate was `p`, run at least `3 / p` iterations without failure. For `p = 0.1`, that is about 30 runs. State the number of runs in the report.

## Python diagnostics for hangs

```python
import faulthandler, sys
faulthandler.dump_traceback_later(30, exit=True)   # dump all thread stacks after 30 s
```

```bash
py-spy dump --pid <PID>        # inspect a running process without stopping it
```

## Common culprits

- Module-level mutable state (caches, singletons) shared between tests
- Database rows not rolled back between tests
- `async` code awaiting tasks that were never started, or fire-and-forget tasks that outlive the test
- Reliance on dictionary or set iteration order in assertions
