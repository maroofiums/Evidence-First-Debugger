# Performance Regressions

Treat "it is slow" as a symptom that must be quantified before any hypothesis is formed.

## Step 1: Define and measure

Record:

- The operation that is slow, with the input size
- The current measurement and the expected or previous measurement
- The measurement method, repeated enough times to estimate variance

Never claim an improvement from a single timing. Report the median over several runs and the spread.

## Step 2: Localize with a profiler, not intuition

```bash
python -m cProfile -o out.prof script.py
python -c "import pstats; pstats.Stats('out.prof').sort_stats('cumulative').print_stats(20)"
py-spy record -o profile.svg -- python script.py        # sampling profiler, low overhead
```

```python
import time
t0 = time.perf_counter()
...
print(f"elapsed: {time.perf_counter() - t0:.4f}s")
```

## Step 3: Hypotheses specific to performance

| Hypothesis | Falsifying check |
|------------|------------------|
| N+1 database queries | Count queries per request (`connection.queries`, SQL logging) |
| Missing index | `EXPLAIN ANALYZE` on the slow query |
| Algorithmic complexity regression (for example O(n) to O(n^2)) | Time at input sizes n, 2n, 4n and inspect the growth |
| Repeated work in a loop | Profiler call counts |
| Blocking call inside `async def` | Event-loop lag measurement; check for sync I/O |
| Memory pressure or swapping | Resource monitor during the run |
| Dependency or runtime version change | Run the same benchmark on the previous version |

## Step 4: Verify

- Re-measure with the same method and input as the baseline.
- Report before and after numbers with the run count.
- Add a regression guard where practical, such as a query-count assertion or a coarse time bound with generous margin.

```python
def test_order_list_uses_constant_queries(client, django_assert_max_num_queries):
    with django_assert_max_num_queries(5):
        client.get("/orders/")
```

## Caution

Do not optimize code that the profile does not implicate. A fix that is not measured is UNVERIFIED.
