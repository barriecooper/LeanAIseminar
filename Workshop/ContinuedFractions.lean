import Workshop.Euclid

/-! OPTIONAL destination. Euclid's quotients are the continued fraction digits.
The convention here is [] ↦ 0 and [a₀; a₁, …] ↦ a₀ + 1/(a₁ + …).
For Euclid inputs a ≥ b > 0, the noninitial digits are positive. Lean's rational
inverse is total (1/0 = 0); do not infer a general CF theorem for arbitrary lists.
-/
namespace Workshop

def quotients (a b : ℕ) : List ℕ := (trace a b).2.map Division.q

def continuedFraction : List ℕ → ℚ
  | [] => 0
  | [a] => a
  | a :: rest => (a : ℚ) + 1 / continuedFraction rest

#eval quotients 1071 462  -- [2, 3, 7]
#eval continuedFraction (quotients 1071 462) -- mkRat 51 22

example : quotients 1071 462 = [2, 3, 7] := by
  unfold quotients trace
  repeat' (rw [observe]; norm_num)
example : continuedFraction [2, 3, 7] = (1071 : ℚ) / 462 := by
  norm_num [continuedFraction]
end Workshop
