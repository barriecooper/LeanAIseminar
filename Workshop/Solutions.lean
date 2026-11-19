import Workshop.Algorithms.Euclid
import Mathlib.Data.ZMod.Basic

/-! Sample solutions. The worksheet has its own editable copies of the recursions. -/

namespace Solutions

example : ¬ ((4 : Int) ∣ 13) := by
  grind

-- Optional Mathlib exercise. The canonical cast preserves multiplication.
example (x y : Int) :
    (Int.castRingHom (ZMod 7)) (x * y) = (x : ZMod 7) * (y : ZMod 7) := by
  exact map_mul (Int.castRingHom (ZMod 7)) x y

def g : Nat → Nat
  | 0 => 1
  | n + 1 => 3 * g n + 2

-- Exercise 2. Each term is odd.
theorem g_odd (n : Nat) : g n % 2 = 1 := by
  induction n with
  | zero => decide
  | succ n ih =>
      simp [g]
      grind

def collatz (n : Nat) : Nat :=
  if n % 2 == 0 then n / 2 else 3 * n + 1

-- Exercise 3. A remainder of 1 modulo 4 forces an odd input.
theorem collatz_mod_four (n : Nat) (h : n % 4 = 1) :
    collatz n % 4 = 0 := by
  simp [collatz]
  grind

-- Optional observer exercise.
theorem countQuotientOne_eq_trace_fold (a b : Nat) :
    (runEuclid countQuotientOne a b).2 =
      (euclidTrace a b).2.foldl countQuotientOne.observe countQuotientOne.initial := by
  exact observation_eq_trace_fold euclidStep countQuotientOne (b + 1) (a, b)

end Solutions
