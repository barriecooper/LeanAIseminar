import Mathlib.Tactic.NormNum

/-! START HERE. Click after `by` to see a goal in Lean Infoview; click after
`exact` to see it solved. F1 → Lean 4: Toggle Infoview if the pane is hidden.
`a ∣ b` means there exists a natural multiplier c with b = a*c.
-/
#eval 3 * 4 -- 12

-- A first proof: choose the multiplier 4, then check the equation.
example : (3 : ℕ) ∣ 12 := by
  exact ⟨4, by norm_num⟩

/-! Try changing this to 4 ∣ 20 and supplying the new multiplier.
This is constructing a witness, not asking Lean to accept an AI's assertion.
Next, open Exercises/01Divisibility.lean; its `sorry` placeholders are your tasks.
-/
