# Social Post Drafts

## X / Twitter thread

1. AI assistants often say "this fixes it" without running anything. I built a skill that makes that impossible to say unless the fix was actually executed.

2. The rule: a fix is a hypothesis until it is verified by running it. Reading the code is not verification.

3. The workflow: reproduce first, collect evidence, rank at least two hypotheses with falsifying checks, make a minimal fix, write a regression test that fails before and passes after.

4. Every answer ends with one status: VERIFIED, PARTIALLY VERIFIED, or UNVERIFIED. If the assistant cannot run code, it must say UNVERIFIED and give you the commands.

5. It also covers flaky tests, performance regressions, and ML bugs like NaN loss. Works as a Claude skill, AGENTS.md, a Cursor rule, or Copilot instructions.

6. Open source, MIT. Try it and tell me where it still fails: github.com/maroofiums/Evidence-First-Debugger

## LinkedIn

Many debugging answers from AI tools sound certain and prove nothing. A `.get()` that silences a `KeyError` is not a fix; it is a postponed failure.

I open-sourced Evidence-First Debugger, a skill that enforces a simple discipline: observe, hypothesize, test, fix minimally, add a regression test, and report an honest verification status. If nothing was executed, the answer must say UNVERIFIED and list the commands to run.

It works with Claude, Cursor, and GitHub Copilot, and includes guidance for flaky tests, performance regressions, and ML training bugs.

Repository: github.com/maroofiums/Evidence-First-Debugger

I am looking for cases where it still allows an unverified claim. Issues and pull requests are welcome.

## Reddit (r/ClaudeAI, r/LocalLLaMA, r/programming; follow each community's self-promotion rules)

**Title:** I made a skill that forces AI assistants to prove a fix before calling it fixed

**Body:** Short description of the problem, the five-step workflow, one before and after example from `examples/before-after.md`, and the repository link. State the limitation clearly: it cannot force code execution, so it reports UNVERIFIED when it cannot run anything. Ask for failure cases.
