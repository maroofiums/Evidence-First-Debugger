# Phase 3: Ranked Hypotheses

## Hypothesis table

Produce at least two to three candidates.

| Rank | Hypothesis | Evidence for | Evidence against | Falsifying check |
|------|-----------|--------------|------------------|------------------|
| 1 | ... | ... | ... | A concrete command or print statement |
| 2 | ... | ... | ... | ... |
| 3 | ... | ... | ... | ... |

## Ranking guidance

- Prefer hypotheses that explain all of the evidence over ones that explain most of it.
- Prefer simpler explanations and explanations tied to recent changes.
- Mark any hypothesis that rests on an unchecked assumption.

## Testing hypotheses

1. Run the cheapest falsifying check first. Start from rank 1 unless a lower-ranked check is far cheaper.
2. After each check, update the table: **confirmed**, **eliminated**, or **inconclusive**.
3. If every hypothesis is eliminated, return to Phase 2 with the new evidence. Do not force a fix.

## Declaring a root cause

A root cause is declared only when a check confirms it, ideally by showing that changing the suspected factor toggles the failure. State it in one or two sentences and say how it was confirmed.
