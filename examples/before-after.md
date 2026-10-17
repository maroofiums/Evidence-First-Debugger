# Before and After

Illustrative comparison. The "typical" response is a composite of a common failure pattern, not a quotation from a specific assistant.

## Prompt

> My FastAPI endpoint `POST /orders/refund` returns 500 for some clients.
> Traceback: `KeyError: 'user_id'` at `services/orders.py` line 42.
> The handler does `user_id = payload["user_id"]`. Can you fix it?

## Typical response

> The issue is that `user_id` is missing from the payload. Use `.get()`:
>
> ```python
> user_id = payload.get("user_id")
> ```
>
> This fixes the error.

Problems:

- Declares success without running anything.
- Treats the symptom. If `user_id` is absent, the next line now receives `None` and fails somewhere less obvious.
- No explanation of why the key is missing for some clients.
- No test.

## With Evidence-First Debugger

**Status: UNVERIFIED** (no code was executed in this conversation)

**Evidence so far**
- [traceback] `KeyError: 'user_id'` at `services/orders.py:42`
- [code] handler reads the raw dict, not a validated model
- [report] failure affects "some clients", not all

**Ranked hypotheses**

| Rank | Hypothesis | For | Against | Falsifying check |
|------|-----------|-----|---------|------------------|
| 1 | Some clients send a different field name (for example `id`) | Failure is client-dependent | Not yet observed | Log `payload.keys()` for a failing request |
| 2 | A schema rename was deployed and older clients were not updated | "Some clients" fits a version split | Needs release history | `git log -p -- schemas/` |
| 3 | Optional field omitted by design | Possible | A required identifier is unlikely to be optional | Check the API contract |

**Run this first**

```bash
git log --oneline -10 -- services/orders.py schemas/
# add temporarily at line 41:  print(sorted(payload.keys()))
```

**Proposed minimal fix (pending confirmation of H1 or H2):** validate input with a Pydantic model that accepts the legacy alias, instead of reading the raw dict.

**Regression test (must fail on current code):**

```python
def test_refund_accepts_legacy_id_field(client):
    r = client.post("/orders/refund", json={"id": 7, "amount": "10.00"})
    assert r.status_code == 200
```

**Verification commands**

```bash
pytest tests/test_orders.py::test_refund_accepts_legacy_id_field -x   # must fail before, pass after
pytest tests/test_orders.py
```

Paste the key-listing output and I will update the hypothesis table.
