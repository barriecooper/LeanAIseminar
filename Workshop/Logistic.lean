import Mathlib.Data.Real.Basic
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-! Shared helper: the same polynomial works over exact rationals ℚ and reals ℝ.
You can use `logistic` without learning the type parameters below.
-/
namespace Workshop

def logistic {K : Type*} [CommRing K] (r x : K) : K := r * x * (1 - x)

end Workshop
