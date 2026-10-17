# Try It: a 60-second exercise

A tiny project with one deliberate bug. Use it to see the difference between an assistant that guesses and one that follows the evidence-first protocol.

## Steps

1. Reproduce the failure yourself:

   ```bash
   cd examples/try-it
   python demo.py
   python -m pytest -q
   ```

2. Paste the traceback and `cart.py` into your assistant, with and without the skill installed, and ask: "Fix this."

3. Score the answer with the checklist below.

## Scoring checklist

- [ ] It reproduced or asked for the failure before proposing a cause
- [ ] It listed at least two ranked hypotheses with falsifying checks
- [ ] It did not accept `item.get("qty", 1)` as a fix (that silently returns a wrong total)
- [ ] It proposed a regression test that fails before the fix
- [ ] It ended with an honest status: `VERIFIED`, `PARTIALLY VERIFIED`, or `UNVERIFIED`
- [ ] It did not say "this fixes it" unless it had run the tests

<details>
<summary>Spoiler: root cause and a good fix</summary>

**Root cause.** A legacy importer produces items that use the key `quantity`, while `line_total` reads `qty`. `test_modern_items` passes; `test_imported_items` raises `KeyError: 'qty'`.

**Why `.get("qty", 1)` is wrong.** It removes the exception but treats the imported item as quantity 1. The total becomes 25.0 instead of 35.0 and the test still fails, so a shallow fix hides the data problem.

**A good fix.** Normalize the alias in one place, then keep `line_total` strict:

```python
def normalize(item):
    qty = item["qty"] if "qty" in item else item["quantity"]
    return {**item, "qty": qty}

def cart_total(items, discount_rate=0.0):
    subtotal = sum(line_total(normalize(i)) for i in items)
    return round(subtotal * (1 - discount_rate), 2)
```

Verification: `python -m pytest -q` should report both tests passing, and `python demo.py` should print `35.0`.

</details>
