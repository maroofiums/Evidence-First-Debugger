# Worked Example: Training Loss Becomes NaN

Illustrative report. Output shown is representative, not copied from a real run.

## Summary
Loss becomes `nan` at step 412 of a text classifier. Root cause: `log(softmax(x))` computed manually underflows to `log(0)` for confident predictions. Fix: use `log_softmax` (or `CrossEntropyLoss` on logits). Status: VERIFIED.

## Symptom and reproduction
- Expected: finite, decreasing loss.
- Actual: `step 411 loss=0.2143`, `step 412 loss=nan`.
- Reproduction: `python train.py --seed 0 --max-steps 500`

## Evidence
- [log] First NaN at step 412 with seed 0; same step with seed 0 on rerun (deterministic).
- [anomaly mode] `RuntimeError: Function 'LogBackward0' returned nan values in its 0th output.`
- [print] Minimum softmax probability in the failing batch: `0.0`
- [config] Learning rate 3e-4 (unchanged from a run that trained successfully)

## Hypotheses

| Rank | Hypothesis | For | Against | Falsifying check | Result |
|------|-----------|-----|---------|------------------|--------|
| 1 | `log(0)` from manual softmax then log | Anomaly points to `LogBackward0`; min prob is 0.0 | None | Replace with `log_softmax`; NaN should disappear | Confirmed |
| 2 | Learning rate too high | Common NaN cause | Same LR worked before | Lower LR 10x; NaN should move or vanish | Eliminated (NaN persisted at same step) |
| 3 | Corrupt input batch | Possible at step 412 | Inputs finite | `torch.isnan(batch).any()` | Eliminated |

## Root cause
The loss was written as `-(y * torch.log(torch.softmax(logits, -1))).sum()`. When a logit gap is large, a softmax probability underflows to exactly 0 and `log(0) = -inf`, which produces NaN in the product and in the gradient. Confirmed by replacing the expression and observing the NaN disappear at step 412.

## Fix

```python
# before
loss = -(y_onehot * torch.log(torch.softmax(logits, dim=-1))).sum(dim=-1).mean()

# after
loss = torch.nn.functional.cross_entropy(logits, y_index)
```

The numerically stable form uses the log-sum-exp identity:

$$\log \mathrm{softmax}(x)_i = x_i - \log \sum_j e^{x_j}$$

## Regression test

```python
def test_loss_is_finite_for_extreme_logits():
    logits = torch.tensor([[1000.0, -1000.0, 0.0]])
    target = torch.tensor([1])
    loss = compute_loss(logits, target)
    assert torch.isfinite(loss)
```

Fail-before: the original implementation returned `nan` for this input. Pass-after: the fixed implementation returned a finite value.

## Verification
Status: VERIFIED

```
$ pytest tests/test_loss.py -q
.                                         [100%]
$ python train.py --seed 0 --max-steps 500
step 412 loss=0.1987 ... step 500 loss=0.1421
```

Re-run with seeds 0, 1, 2: no NaN in any run (3 of 3).

## Residual risks
Mixed-precision training was not tested. If fp16 is enabled later, loss scaling should be re-checked.
