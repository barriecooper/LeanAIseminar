# Instructor guide

Read WORKSHOP_BRIEF.md for the narrative and mathematical boundaries. Rehearse
against the PR branch, with the exact Codespaces experience participants use.

## Before delivery
Configure a prebuild. Open a fresh Codespace early and time setup; previous
four-minute startup is historical, not a measurement of this version. Confirm
FirstSteps opens, extension activates, #eval shows 12, and clicking before/after
the witness proof shows a goal/“No goals”. Make a successful edit in the browser.
Open every exercise; expected sorry warnings are fine, red errors are not.
Confirm exact? offers a suggestion and that replacing it with the suggestion works.
These editor checks require manual rehearsal; see VALIDATION.md for what was
actually checked during implementation.

## Demonstration, 0–20 minutes
- 0–6: FirstSteps. Interpret the goal, supply a witness, explain the equation's
  orientation. Change to 4 ∣ 20. Show Arithmetic.divides_iff as a definition proof.
- 6–12: Explain how mathematicians reuse a library. Show a theorem signature and
  its hypotheses, leaving the transitivity search for participants to attempt.
  `ℕ`, `ℤ`, `ZMod 7` are different types. Casts are maps between them; typeclasses
  let Lean find the appropriate arithmetic laws (a ring, sometimes a field).
  Contrast 3*5 = 1 modulo 7 with 2*3 = 0 modulo 6. Show cast_zero and
  inverse_of_coprime. An inverse operation's syntax does not guarantee a unit.
- 12–20: Run display 1071 462: three Euclidean divisions, gcd 21. Read the observer
  API as “record a row without choosing the next state”. State observe_result
  (all observers) and euclid_eq_gcd (all inputs), and explain decreasing b.
  Show extended and Mathlib gcdA/gcdB: 21 = -3*1071+7*462. Then 3,7 yields
  1 = -2*3+7, giving residue 5 as inverse. The custom extended code is tested on
  these examples; the general Bézout proof shown uses Mathlib's verified API.

## Active work, 20–50 minutes
Pairs help: one predicts the mathematics, one edits, then swap. At minute 28 move
to 03 even if optional tasks in 01/02 remain. At minute 42 invite continued
fractions or more core experiments. Required completions: witness, theorem-search
transitivity, one modular calculation, and one of the two main Euclid theorems.
Other holes are optional practice with complete checked solutions available.

A useful Euclid experiment is reversing inputs; another is b = 0, including
(0,0). Ask whether the observer theorem still applies. Propose an observer that
counts steps rather than storing rows; observe_result covers it too. Students
need not read the strong-induction proof to understand its quantified statement.

Optional continued fractions: [2;3,7] means 2 + 1/(3 + 1/7) = 51/22.
Compare with 1071/462, change inputs and formulate a conjecture. The repository
checks this concrete identity, not universal reconstruction. Explain total
rational division before discussing arbitrary lists containing zero digits.

During the last active minutes ask participants to classify what they used:
witness proof, library reuse, exact finite computation, algorithm correctness,
or observed pattern. AI can explain or suggest; Lean checks the precise statement.
Ask reviewers/participants whether the search task and inverse bridge are clear,
and whether the required route fits 30 minutes. Do not expand to decimal periods
until this route has been rehearsed successfully.
