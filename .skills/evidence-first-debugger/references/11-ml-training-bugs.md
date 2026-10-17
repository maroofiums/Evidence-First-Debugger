# Machine Learning and Training Bugs

ML bugs often produce no exception: the code runs and the result is quietly wrong. Evidence must therefore include numerical and statistical checks.

## Establish the symptom quantitatively

- Metric curves: training and validation loss per step or epoch
- First step at which the anomaly appears (NaN, divergence, plateau)
- Whether the failure is deterministic under a fixed seed

## Sanity checks to run first

1. **Overfit a single batch.** A correct model and loop should drive loss near zero on 8 to 32 examples. If not, the bug is in the model, loss, or loop, not the data volume.
2. **Check initial loss.** For classification with $C$ classes and a balanced start, expect roughly $\ln C$.
3. **Inspect one batch.** Print shapes, dtypes, label ranges, and a decoded example.
4. **Confirm train and eval modes.** `model.train()` and `model.eval()` placed correctly; `torch.no_grad()` during evaluation.

## Hypotheses by symptom

| Symptom | Common hypotheses | Falsifying check |
|---------|-------------------|------------------|
| Loss becomes NaN or inf | Learning rate too high; log of zero; division by zero; unnormalized inputs; fp16 overflow | `torch.autograd.set_detect_anomaly(True)`; lower LR by 10x; check inputs with `torch.isnan(x).any()` |
| Loss does not decrease | Missing `zero_grad`; frozen parameters; wrong loss or targets; LR too low; labels shuffled relative to inputs | Print gradient norms per parameter; overfit one batch |
| Training accuracy high, validation poor | Overfitting; data leakage; train and eval transform mismatch | Check split construction; compare preprocessing |
| Validation suspiciously perfect | Leakage between splits | Hash or ID overlap between train and validation sets |
| Shape or broadcast error | Batch dimension handling; transposed axes | Print shapes at each layer |
| Different results on each run | Unseeded randomness; non-deterministic ops | Fix seeds; enable deterministic algorithms |

## Diagnostic snippets

```python
torch.autograd.set_detect_anomaly(True)

for name, p in model.named_parameters():
    g = None if p.grad is None else p.grad.norm().item()
    print(f"{name:40s} grad_norm={g}")

print(x.shape, x.dtype, x.device, x.min().item(), x.max().item())
```

Gradient norm of the whole model, useful for explosion checks:

$$\lVert g \rVert_2 = \sqrt{\sum_i \lVert \nabla_{\theta_i} \mathcal{L} \rVert_2^2}$$

## Regression tests for ML code

- A shape test on a tiny synthetic batch
- A test that a single optimization step reduces loss on a fixed batch with a fixed seed
- A test that the loss is finite on a hand-built edge case (all-zero input, single-class batch)
- A split-leakage test asserting disjoint IDs between train and validation

## Verification note

A single training run with one seed is weak evidence. When the failure was seed-dependent, verify across several seeds and report the count.
