import Mathlib.Tactic.NormNum
import Workshop.Algorithms.Euclid

/-! Sample solutions. The worksheet has its own editable copies of the recursions. -/

namespace Solutions

example : ¬ ((4 : Int) ∣ 13) := by
  norm_num

-- One possible theorem for Exercise 1.
example (n : Int) : 4 ∣ 12 * n := by
  exists 3 * n
  grind

def g : Nat → Nat
  | 0 => 1
  | n + 1 => 3 * g n + 2

-- Exercise 2. Each term is odd.
theorem g_odd (n : Nat) : g n % 2 = 1 := by
  induction n with
  | zero => decide
  | succ n ih =>
      simp only [g]
      omega

def collatz (n : Nat) : Nat :=
  if n % 2 == 0 then n / 2 else 3 * n + 1

-- Exercise 3. A remainder of 1 modulo 4 forces an odd input.
theorem collatz_mod_four (n : Nat) (h : n % 4 = 1) :
    collatz n % 4 = 0 := by
  have odd : n % 2 = 1 := by omega
  simp [collatz, odd]
  omega

-- Exercise 4. A zero divisor stops immediately without emitting any events.
example (a : Nat) : euclidCount a 0 = (a, 0) := by rfl
example (a : Nat) : euclidTrace a 0 = (a, []) := by rfl
example (a : Nat) : runEuclid quotientObserver a 0 = (a, []) := by rfl

end Solutions
