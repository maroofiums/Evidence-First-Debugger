# Worked Example: FastAPI Endpoint Returns 500

## Summary
`POST /orders/refund` returns HTTP 500 for some requests. Root cause: the handler assumes `payload["user_id"]` exists, but the upstream client sends `id`. Status: VERIFIED.

## Symptom and reproduction
- Expected: 200 with refund receipt.
- Actual: 500 Internal Server Error.
- Reproduction: `pytest tests/test_orders.py::test_refund_legacy_client -x`

## Evidence
- [stack trace] `KeyError: 'user_id'` at `services/orders.py:42`
- [print] payload keys at line 40: `['id', 'amount']`
- [git log] `orders.py` last changed three days ago (renamed `id` to `user_id` in the schema)

## Hypotheses

| Rank | Hypothesis | For | Against | Falsifying check | Result |
|------|-----------|-----|---------|------------------|--------|
| 1 | Legacy client sends `id`, handler expects `user_id` | Printed keys show `id` | None | Send payload with `user_id`; expect success | Confirmed |
| 2 | Database row missing | Refund path touches DB | Error is a `KeyError`, not a DB exception | Query the row directly | Eliminated |
| 3 | Pydantic model out of date | Recent schema change | Handler reads raw dict | Inspect model definition | Inconclusive, not the cause |

## Root cause
The handler reads from the raw request dict instead of the validated Pydantic model, so the renamed field is not normalized. Confirmed: sending `user_id` succeeds; sending `id` reproduces the failure.

## Fix
Read `user_id` from the validated model, and accept `id` as an alias in the schema:

```python
class RefundRequest(BaseModel):
    user_id: int = Field(alias="id")
    amount: Decimal
    model_config = ConfigDict(populate_by_name=True)
```

## Regression test

```python
def test_refund_legacy_client(client):
    r = client.post("/orders/refund", json={"id": 7, "amount": "10.00"})
    assert r.status_code == 200
```

Fail-before: the test failed with the original `KeyError`. Pass-after: it passed once the fix was restored.

## Verification
Status: VERIFIED

```
$ pytest tests/test_orders.py -q
.......                                   [100%]
7 passed in 0.41s
```

## Residual risks
Other handlers may also read raw dicts. Not changed in this fix; recommend a follow-up audit.
