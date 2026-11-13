import Workshop.Logistic

/-!
FIRST SUCCESS · about 5 minutes, once Codespace setup has finished

Open this file in the editor. Use F1 → Lean 4: Toggle Infoview if needed.
Click just after `by` below: Infoview shows the goal (the claim to prove).
Replace the first `sorry` with `norm_num [logistic]`. Click after your tactic:
Infoview should say “No goals”. Wait for Lean to finish checking the file.

`sorry` is a deliberately unfinished proof: its warning is NOT verification.
A completed task has neither a sorry warning nor a red error in its proof.
ℚ means exact rational arithmetic; this is not a rounded decimal calculation.
`[logistic]` tells the tactic to use our pre-populated definition r*x*(1-x).
-/
namespace Workshop.Exercises.TwoCycle
open Workshop

example : logistic (7 / 2 : ℚ) (3 / 7) = 6 / 7 := by
  sorry

-- Now check the return journey with the same tactic.
example : logistic (7 / 2 : ℚ) (6 / 7) = 3 / 7 := by
  sorry

-- Why is this period TWO, rather than a fixed point? Check distinctness.
example : (3 / 7 : ℚ) ≠ 6 / 7 := by
  sorry

/- Hints, in order:
1. The first two goals need `norm_num [logistic]`.
2. Distinctness only needs `norm_num`.
3. Try a wrong destination, such as 5/7, and read the error; then undo it.

AI prompt: “Explain the current Lean goal and what [logistic] does.
Suggest one next tactic, and explain why it applies.”

Compare your proofs with Workshop/Solutions.lean afterwards.
Next: Exercises/02Factorisation.lean.
-/
end Workshop.Exercises.TwoCycle
