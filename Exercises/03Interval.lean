import Workshop.Logistic
import Mathlib.Tactic.Linarith

/-!
OPTIONAL STRETCH · use remaining time, or return after the workshop
For 0 ≤ r ≤ 4, show that a point in [0,1] stays in [0,1].
The four named assumptions appear in Infoview. `∧` means “and”.
Replace `sorry`; ask for one step at a time. This task is harder than the core.
-/
namespace Workshop.Exercises.Interval
open Workshop

example (r x : ℝ) (hr0 : 0 ≤ r) (hr4 : r ≤ 4)
    (hx0 : 0 ≤ x) (hx1 : x ≤ 1) :
    0 ≤ logistic r x ∧ logistic r x ≤ 1 := by
  sorry

/- Staged hints:
1. `unfold logistic`, then `constructor` splits the two inequalities.
2. Products of nonnegative numbers are nonnegative (`mul_nonneg`).
3. From (x-1/2)^2 ≥ 0, derive x*(1-x) ≤ 1/4.
   `nlinarith [sq_nonneg (x - 1 / 2)]` can check this step.
4. Bound r*(x*(1-x)) by 4*(x*(1-x)) and then by 1.

AI prompt: “Help me turn the square (x-1/2)^2 ≥ 0 into an upper bound
for x*(1-x). Explain the mathematical step before suggesting Lean.”

A complete, checked mathematical argument is in Workshop/Solutions.lean.
-/
end Workshop.Exercises.Interval
