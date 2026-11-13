import Workshop.Logistic
import Mathlib.Tactic.Linarith

/-! Checked answers. Try the files in Exercises/ before opening this file.
`lake build` checks every theorem here; none is an unfinished exercise.
-/
namespace Workshop.Solutions

-- Unfold the helper, then check exact rational arithmetic.
theorem cycle_out : logistic (7 / 2 : ℚ) (3 / 7) = 6 / 7 := by
  norm_num [logistic]

theorem cycle_back : logistic (7 / 2 : ℚ) (6 / 7) = 3 / 7 := by
  norm_num [logistic]

-- Distinct points make this a genuine two-cycle, rather than a fixed point.
theorem cycle_distinct : (3 / 7 : ℚ) ≠ 6 / 7 := by
  norm_num

-- This is a polynomial identity for all real r and x, not a numerical test.
theorem second_iterate (r x : ℝ) :
    logistic r (logistic r x) - x =
      (logistic r x - x) * (r^2*x^2 - r*(r+1)*x + (r+1)) := by
  unfold logistic
  ring

-- Optional stretch: the interval [0,1] maps into itself when 0 ≤ r ≤ 4.
theorem invariant_interval (r x : ℝ) (hr0 : 0 ≤ r) (hr4 : r ≤ 4)
    (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    0 ≤ logistic r x ∧ logistic r x ≤ 1 := by
  unfold logistic
  have hp : 0 ≤ x * (1 - x) := mul_nonneg hx0 (sub_nonneg.mpr hx1)
  have hq : x * (1 - x) ≤ 1 / 4 := by
    nlinarith [sq_nonneg (x - 1 / 2)]
  constructor
  · exact mul_nonneg (mul_nonneg hr0 hx0) (sub_nonneg.mpr hx1)
  · calc
      r * x * (1 - x) = r * (x * (1 - x)) := by ring
      _ ≤ 4 * (x * (1 - x)) := mul_le_mul_of_nonneg_right hr4 hp
      _ ≤ 1 := by nlinarith

end Workshop.Solutions
