# Phase 5: Verification Gate

A fix is not reported as working until this gate has been passed by execution.

## Checks to run

1. The original reproduction command from Phase 1.
2. The new regression test.
3. The surrounding test suite, or the relevant subset.

For flaky or intermittent bugs, run the reproduction enough times to be meaningful and state how many runs were performed.

## Status assignment

| Status | Meaning | Required content |
|--------|---------|------------------|
| VERIFIED | All three checks were executed after the fix and passed | Commands and relevant output |
| PARTIALLY VERIFIED | Some checks ran and passed; others could not run | Which ran, which did not, and why |
| UNVERIFIED | Nothing was executed | Exact commands for the user and the output that distinguishes success from failure |

## Rules

- Never upgrade a status without running something.
- A changed error message is not a fix.
- A passing run of the regression test alone does not verify the fix if the original reproduction was not rerun.
- Do not claim VERIFIED based on reading the code.

## Forbidden phrasing unless status is VERIFIED

- "This fixes it."
- "This should resolve the issue."
- "The bug is fixed."
- "That was the problem."

## Calibrated alternatives

- "The evidence points to X as the cause."
- "This change is expected to fix the failure, pending the commands below."
- "Status: UNVERIFIED. Please run the following and share the output."
