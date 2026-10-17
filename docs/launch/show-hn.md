# Show HN Draft

**Title:** Show HN: Evidence-First Debugger, a skill that stops AI assistants from claiming unverified fixes

**Body:**

AI coding assistants often answer a bug report with a confident fix and the words "this fixes it", without having run anything. The fix frequently patches the symptom: a `.get()` or a blanket `try/except` that moves the failure somewhere else.

I wrote a skill (also provided as AGENTS.md, a Cursor rule, and Copilot instructions) that changes the workflow:

1. Observe the failure and reproduce it before theorizing.
2. List ranked hypotheses, each with evidence for, evidence against, and a cheap falsifying check.
3. Make the smallest change the confirmed root cause requires.
4. Write a regression test that fails before the fix and passes after.
5. Report exactly one status: VERIFIED, PARTIALLY VERIFIED, or UNVERIFIED. Phrases such as "this fixes it" are not allowed unless the status is VERIFIED.

It includes references for flaky tests, performance regressions, and ML training bugs (NaN loss, leakage), plus a set of adversarial evals such as "the error message changed, so it's fixed, right?".

Limitations: the skill cannot force a model to execute code; when execution is unavailable it reports UNVERIFIED and gives the commands to run. I have not benchmarked it at scale. <insert your measured eval results here, or remove this sentence>.

Repo: https://github.com/maroofiums/Evidence-First-Debugger

I would value feedback on cases where it still lets an unverified claim through.
