# Lean + AI seminar repository evaluation

22 November 2026 · University of Exeter, Mathematics and Statistics

Reviewed commit `0643940`, which pins Lean and Mathlib to `v4.37.0-rc1`.

## Overall assessment

The repository is a good basis for a first encounter with Lean. The worksheet gives participants one place to work, starts with arithmetic they can check by hand, and ends with an example of a guarantee about software behaviour. The full worksheet is too ambitious as a hands-on target for 50 minutes with a news opening and first-time Codespaces setup. The [workshop brief](../WORKSHOP_BRIEF.md) already allocates every minute and assumes participants can use Infoview from minute zero.

Keep the existing sequence and use three outcomes to define a successful session. Participants should change an input and predict the output, complete a small proof and watch its goal close, and explain what stays the same when they change Euclid’s observer. This gives colleagues across pure mathematics, statistics and applied mathematics a common experience without assuming programming or specialist number theory.

## Suitability of the worksheet

### Integer divisibility

The integer and rational versions of `13 / 4 * 4` make types matter immediately. The adjacent solved and unfinished divisibility examples give participants a quick first proof. The transitivity example shows what an explicit mathematical witness looks like.

Ask participants to predict `12` and `13`, edit a numeral, then copy `grind` from the solved example into the first `sorry`. Show where the goal appears and how Lean signals completion. If time allows, pause after `obtain` to read one witness equation before `grind` closes it. Give the open-ended Exercise 1 to early finishers.

### Mathlib and arithmetic modulo 7

The residues of `-1`, `13` and `14` give a concrete reading of a cast. `apply?` shows that Lean itself can look up a library fact.

Keep one residue example and a brief library-search demonstration. Explain `ZMod 7` as arithmetic on remainders. Move ring homomorphisms and the preservation proofs to follow-up. The `apply?` example switches to reversing a difference, so introduce that statement aloud before showing the suggestion.

### Recursion and induction

The two recurrences share an update rule and differ only in their starting value. Comparing them offers an accessible exercise in making a conjecture and testing it.

Show the base case and the induction hypothesis in Infoview. Ask everyone to predict what happens to parity when the initial value changes to 1. Supply an optional theorem skeleton for `g n % 2 = 1`. Exercise 2 currently asks a novice to invent the statement, express it in Lean and prove it in one step.

### Collatz

Changing a starting value illustrates an iterative process with immediate feedback. The modulo-four theorem offers a genuine next step for someone who has finished the core task.

Ask participants to predict one step, then compare two short orbits. Say explicitly that the output describes those starts and that the theorem covers one transition from any input with remainder 1 modulo 4. Give the proof challenge a hint about showing the input is odd before simplifying the branch.

### Observable Euclid

The same run returns the GCD alongside a count or a trace. This is the clearest connection to debugging simulations, tracing numerical iterations or gathering algorithm diagnostics.

Display the chronological trace and count first. Ask participants to identify a row, predict its count contribution and explain why the GCD stays fixed. Use the zero-divisor case if time permits. Introduce the raw reversed trace and quotients after the first comparison. Leave continued fractions, the generic fold and the full GCD proof for follow-up.

Put a short **Do first** route at the top of [the tutorial](../Workshop/Tutorial.lean) with the exact edits and expected feedback. Introduce `Int`, `Nat`, `Prop`, `∣` and `⊢` where they first matter. For the first task, participants only need to edit digits and a tactic name. For those writing new statements, mention that the editor accepts `\dvd` for `∣`. [Lean’s notation guide](https://lean-lang.org/theorem_proving_in_lean4/Quantifiers-and-Equality/)

## Suggested 50-minute run of show

- **0–7**

  Launch the browser workflow from a projected link. One presenter gives the Lean and AI opening while the other helps with GitHub sign-in, branch selection and setup.

- **7–17**

  Read a type, predict and edit an evaluation, then close the first `sorry`. Briefly show a divisibility witness if the room is ready.

- **17–23**

  Show one modulo-7 calculation and a library lookup. Use this slot for a short AI demonstration.

- **23–32**

  Compare the two recurrences and read an induction goal. Offer the scaffolded oddness proof to early finishers.

- **32–39**

  Change a Collatz input and compare observations with the statement of the one-step theorem.

- **39–47**

  Predict and compare Euclid’s count and chronological trace. Read the observer-independence statement in plain English.

- **47–50**

  Ask participants to explain the difference between evaluating examples and checking a general proof. Point to solutions and optional exercises.

Keep the opening short enough that late arrivals can still catch the first edit. If using Verso, a few browser-ready slides suffice. Show the recent result, display a small goal in Infoview, and leave the launch link and first task visible. As of 22 November, the Lean and Mathlib communities reported that their checks confirmed both Alpöge’s Claude-assisted proof and its match to Mathlib’s statement of the Riemann Hypothesis. Clay still listed the problem under **Unsolved problems** on its prize page. Attribute both statuses and refresh them before the seminar. Use the worksheet to show what that means in practice. Lean checks a proof of a precise statement, and people still need to understand the statement and explain the argument. [Alpöge’s announcement](https://alpo.ge/remark.pdf) · [Lean and Mathlib verification](https://leanprover-community.github.io/blog/posts/riemann-hypothesis/) · [Clay’s prize status](https://www.claymath.org/millennium-problems/)

Give AI one visible role early. Use the divisibility example with hypothesis `h : x ∣ y - z` and goal `x ∣ z - y`. Ask an assistant to explain the goal in plain English and suggest one Lean proof step using the existing imports and pinned version. Compare the suggestion with Lean’s `apply?` result and try it in the editor. Have the presenters run this once so participants can follow without an AI account. The advanced GCD prompts already give a good model for breaking a larger proof into small questions.

## Browser readiness and delivery risks

1. **Align the README with the launch route.** The current badge opens the upstream repository. If participants should fork first, give them the browser steps **Fork → Create fork → Code → Codespaces → Create codespace**, plus the exact workshop branch. The updated pin was one commit ahead of the local `origin/gihan_version` tracking ref at review time. Confirm the intended revision is published and appears in a fresh participant fork. If saving or publishing work to a fork is unnecessary in the session, the direct launch reduces friction. GitHub documents opening a Codespace before forking when the user has permission to fork. [README launch instructions](../README.md#lean--ai-workshop) · [GitHub’s automatic forking guidance](https://docs.github.com/en/codespaces/developing-in-a-codespace/using-source-control-in-your-codespace#about-automatic-forking)
2. **Update the version and cache guidance together.** The README still says `v4.24.0`. The cache client at the new Mathlib pin uses `cache.mathlib.org` and no longer reads `USE_FRO_CACHE`, so the documented mirror switch and setup failure advice are stale. The setup script’s targeted cache request, availability check and stage timings are worth retaining. Verify a cold setup against the selected commit before relying on the new release candidate in the seminar. [Setup script](../.devcontainer/setup.sh#L35) · [Pinned Mathlib cache documentation](https://github.com/leanprover-community/mathlib4/blob/31ce06eaadf4a200c0e1407c5f10953cf606b8f8/Cache/README.md#public-cache-endpoint)
3. **Rehearse as a participant from a fresh fork.** Time sign-in through the first visible `#eval` in VS Code for the Web, confirm the tutorial opens and Infoview shows a goal, then replace the first `sorry`. Test from the intended account type and network. If relying on a prebuild, confirm it is offered on that launch route. Ask attendees to check GitHub sign-in and Codespaces access in advance. If a participant is still waiting at minute seven, have them work alongside a neighbour or follow the presenter’s ready Codespace until theirs comes up. [Devcontainer configuration](../.devcontainer/devcontainer.json) · [GitHub prebuild availability](https://docs.github.com/en/codespaces/prebuilding-your-codespaces/about-github-codespaces-prebuilds)

## Technical validation

- **`lake build`**

  Passed locally. Lean warned that `Workshop/Solutions.lean` imports Mathlib from a file outside the module system under this pin.

- **`lake env lean Workshop/Tutorial.lean`**

  Passed with exactly five intentional `sorry` warnings. In a temporary copy, replacing the first `sorry` with `grind` closed the goal, and replacing `apply?` with its suggestion `exact dvd_sub_comm.mp h` also checked.

- **Evaluations and participant edits**

  The arithmetic examples produced their annotated values. The recurrence returned `f 8 = 6560` and `g 8 = 13121`. Four Collatz steps from 7 gave 17, and changing the start to 8 gave 4. Euclid returned 21 with three division events for `(1071, 462)`, and the chronological quotients were `[2, 3, 7]`. Additional count and trace checks passed for `(35, 15)` and `(35, 0)`. The ignored observer’s unit value prints as `PUnit.unit` under this pin, while the worksheet comment shows `()`.

- **Checked proofs**

  The generic runner keeps algorithm state and observer state separate. The trace prepends each event and reverses the list for chronological order. The observer-independence theorem preserves the arithmetic result for arbitrary observers, including observers with different state types. A local `#print axioms` spot check of the main instrumentation and Euclid theorems and two sample solutions found only standard Lean axioms.

- **Provisioning**

  The setup script passed shell syntax checking, and the local Mathlib target was available without rebuilding. The local checks used an existing dependency cache. Cold cache download, browser launch, Infoview behaviour and time to first interaction remain unverified. The GitHub CLI check in Codex reported a failed login for the `default` credential source. The maintainer’s terminal reported a successful login via the macOS keyring. A fresh Codespaces rehearsal remains pending.

Before the seminar, the priorities are to publish the workshop revision, align the README and setup guidance with the actual participant route, rehearse that route in a fresh browser Codespace, and mark the short hands-on path in the worksheet.
