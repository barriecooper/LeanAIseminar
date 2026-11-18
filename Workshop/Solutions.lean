import Workshop.Algorithms.Euclid

/-! Sample solutions. The worksheet has its own editable copies of the recursions. -/

namespace Solutions

example : ¬ ((4 : Int) ∣ 13) := by
  grind

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

end Solutions
