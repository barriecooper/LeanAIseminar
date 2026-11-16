import Workshop.ContinuedFractions
import Workshop.Arithmetic

/-! Regression assertions for the displayed computations. Unlike bare #eval,
these make a changed expected result fail the build. No native_decide. -/
namespace Workshop
example : display 1071 462 =
    ["1071 = 2*462 + 147", "462 = 3*147 + 21", "147 = 7*21 + 0"] := by
  unfold display trace
  repeat' (rw [observe]; norm_num)
  decide
example : countSteps 1071 462 = (21, 3) := by
  unfold countSteps
  repeat' (rw [observe]; norm_num)
example : (trace 1071 462).2.length = 3 := by
  unfold trace
  repeat' (rw [observe]; norm_num)
-- The observers agree on the result for every input, not only this example.
example (a b : ℕ) : (trace a b).1 = (countSteps a b).1 := by
  rw [trace_result, countSteps_result]
example : (trace 1071 462).1 = 21 := by
  unfold trace
  repeat' (rw [observe]; norm_num)
example : extended 1071 462 = (21, -3, 7) := by
  repeat' (rw [extended]; norm_num)
example : extended 3 7 = (1, -2, 1) := by
  repeat' (rw [extended]; norm_num)
example : (Nat.gcd 1071 462, Nat.gcdA 1071 462, Nat.gcdB 1071 462) =
    (21, -3, 7) := by
  unfold Nat.gcdA Nat.gcdB Nat.xgcd
  norm_num
  repeat' (rw [Nat.xgcdAux]; norm_num)
  decide
-- Degenerate and reversed inputs, with an independent general specification.
example : euclid 0 0 = 0 := by
  repeat' (rw [euclid]; norm_num)
example : euclid 35 0 = 35 := by
  repeat' (rw [euclid]; norm_num)
example : euclid 0 35 = 35 := by
  repeat' (rw [euclid]; norm_num)
example : euclid 12 35 = 1 := by
  repeat' (rw [euclid]; norm_num)
example : (trace 0 0).2 = [] := by simp [trace, observe]
end Workshop
