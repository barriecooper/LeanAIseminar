import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-! Open this file first. These small examples check that Lean and Mathlib work.
Click a `#eval` line to see its output in the Lean Infoview.
Click inside a proof to see its current goal.
-/

#eval 2 + 3  -- 5

-- The ℚ annotation makes this exact rational arithmetic, not floating point.
#eval (1 / 3 + 1 / 6 : ℚ)  -- mkRat 1 2 (the rational number 1/2)

-- A calculation is also a proposition that Lean can check.
example : (1 / 3 + 1 / 6 : ℚ) = 1 / 2 := by
  norm_num

-- Mathlib's ring tactic checks polynomial identities.
example (x y : ℚ) : (x + y)^2 = x^2 + 2*x*y + y^2 := by
  ring
