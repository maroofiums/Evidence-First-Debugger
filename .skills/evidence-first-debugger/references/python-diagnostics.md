# Python Diagnostics Cheat Sheet

## General Python

```bash
python -X faulthandler script.py          # dump traceback on hard crashes
python -m pdb script.py                   # step debugger
python -c "import sys; print(sys.version); print(sys.path)"
pip list --format=freeze | grep -i <package>
pip check                                  # detect broken dependencies
```

Inline inspection:

```python
import traceback, logging
logging.basicConfig(level=logging.DEBUG)
print(type(x), getattr(x, "shape", None), repr(x)[:200])
breakpoint()
```

## pytest

```bash
pytest -x -vv path/to/test.py::test_name   # stop at first failure, verbose
pytest --lf                                # rerun last failures
pytest -p no:randomly                      # disable random ordering to test order dependence
pytest --count=20 path::test               # repeat (pytest-repeat) for flaky tests
pytest -k "name" --pdb                     # drop into debugger on failure
```

## Git

```bash
git log --oneline -20 -- path/to/file
git diff HEAD~1 -- path/to/file
git bisect start; git bisect bad; git bisect good <known-good-commit>
git bisect run pytest path/to/test.py::test_name
```

## Django / Django REST Framework

```bash
python manage.py check
python manage.py showmigrations
python manage.py makemigrations --check --dry-run
python manage.py shell                     # reproduce queries and serializers interactively
```

```python
from django.db import connection
print(queryset.query)                      # inspect generated SQL
print(connection.queries[-5:])             # recent queries when DEBUG=True
serializer.is_valid(); print(serializer.errors)
```

## FastAPI / Pydantic

```bash
uvicorn app.main:app --reload --log-level debug
curl -i -X POST http://localhost:8000/endpoint -H "Content-Type: application/json" -d '{"k": "v"}'
```

- A 422 response body lists the exact failing fields; read it before changing models.
- Check dependency overrides and async/sync mismatches (blocking calls inside `async def`).

## PyTorch

```python
print(x.shape, x.dtype, x.device, x.requires_grad)
torch.autograd.set_detect_anomaly(True)    # locate NaN/inf in backward pass
torch.isnan(x).any(), torch.isinf(x).any()
for n, p in model.named_parameters():
    print(n, p.grad is None or p.grad.abs().mean().item())
```

Common checks:

- Shape and dtype mismatch between model output and target
- `model.eval()` and `torch.no_grad()` usage during evaluation
- Tensors on different devices
- Missing `optimizer.zero_grad()`
- Loss function expecting logits vs probabilities
- Data leakage between train and validation splits
