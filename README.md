# Lean + AI: from divisibility to Euclid

A 50-minute browser-only workshop for mathematics staff and postgraduate
researchers. No Lean or programming experience needed. Explore proofs, library
search, exact algorithms, Bézout coefficients and modular inverses.

[![Open in Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/barriecooper/LeanAIseminar)

1. **Launch before the seminar.** Click the badge and Create codespace. A GitHub
   account and available Codespaces quota are required. When reviewing a PR,
   select its branch in the creation form. Wait for automated setup to finish.
   No local installation or participant terminal commands are needed.
2. **Open [Workshop/FirstSteps.lean](Workshop/FirstSteps.lean)** if it hasn't opened
   automatically. Click the `#eval` line to see `12` in Lean Infoview. Click after
   `by` to see the proof goal, and after `exact` to see it solved. Use **F1 →
   Lean 4: Toggle Infoview** if needed. Change `3 ∣ 12` to `4 ∣ 20` and the
   multiplier `4` to `5`: your first proof should take under five minutes.
3. **Work through the three files below** after the instructor demonstration.
   Replace `sorry` with a proof; each file gives hints. An initial `sorry` warning
   marks an unfinished task, not a verified proof. Save edits normally in the
   browser editor. Red error squiggles mean Lean has not accepted your change.

| Active time | File | What to investigate |
| --- | --- | --- |
| 20–28 min | [01 Divisibility](Exercises/01Divisibility.lean), then [02 Modular arithmetic](Exercises/02Modular.lean) | Try `exact?` in 01 task 2, then the first two calculations in 02; compare moduli 7 and 6 |
| 28–42 min | [03 Euclid](Exercises/03Euclid.lean) | Compare trace and counter on the same inputs, inspect Bézout coefficients, complete one theorem |
| 42–50 min | Optional section of 03 | Reconstruct a rational from Euclid's continued-fraction quotients |

Minimum route before minute 28: **01 task 2 (theorem search), then the first two
calculations in 02**. The first witness hole in 01 repeats FirstSteps: skip it if
comfortable. The gcd search, general cast theorem and inverse in 01/02 are
optional. Move to 03 at minute 28 even if optional holes remain.

In 03, run the adjacent `trace` and `countSteps` commands: one records three
rows and the other records `3`, while both return gcd `21`. Change both inputs
and ask what the universal observer theorem guarantees about the answer.

The instructor demonstrates the mathematical story during minutes 0–20; the
remaining 30 minutes are for your experiments. You do not need to write a
recursive algorithm. For Euclid, `1071,462` gives gcd `21` and coefficients
`-3,7`; for `3,7`, Bézout gives `1 = -2*3 + 7`, hence an inverse modulo 7.

Useful AI prompts: “Explain the current goal and give one hint”; “How can I
search Mathlib for a lemma with these hypotheses?”; “What does this cast change?”;
“What generalisation does this trace suggest, and what hypotheses are needed?”
Try the result in Lean and explain it. Lean checks the formal proposition you
wrote, which may differ from the claim you intended.

Completed proofs are in [Solutions](Solutions). The instructor's algorithm and
observer theorems are in [Workshop/Euclid.lean](Workshop/Euclid.lean); the optional
identity is in [Workshop/ContinuedFractions.lean](Workshop/ContinuedFractions.lean).
A computation, a library theorem and a conjecture are different kinds of evidence.

## Setup and organiser notes

Allow several minutes for startup (previously about four; current timing needs a
fresh Codespace rehearsal). Configure a Codespaces prebuild for the seminar
branch and region in repository Settings → Codespaces. Setup installs Lean,
fetches Mathlib artifacts and builds before attaching. Cache failure prints a
warning and falls back to compilation, which can take much longer. **Workshop
ready** appears only after a successful build. On setup failure, organisers
should inspect the creation log and rerun `bash .devcontainer/setup.sh` or rebuild
the container. Participants should ask the organiser for help.

Lean **4.24.0**, Mathlib **v4.24.0** and transitive Git revisions are pinned in
`lean-toolchain`, `lakefile.toml` and `lake-manifest.json`; setup never runs
`lake update`. Elan bootstrap is pinned to 4.1.2. Codespaces uses Ubuntu 24.04
with the Lean extension. Internet access is needed for GitHub and initial downloads.

Maintainers: `lake build` checks all complete modules and solutions through
`Workshop.lean`. Intentionally incomplete `Exercises/` files are separate; CI
also checks they open without errors, allowing their explicit `sorry` warnings.
See [validation](VALIDATION.md) for commands and results and
[the instructor guide](INSTRUCTOR.md) for pacing and manual rehearsal checks.
CI remains pull-request/manual-dispatch only.
