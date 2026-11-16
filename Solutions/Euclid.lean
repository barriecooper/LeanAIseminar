import Workshop.Euclid
import Workshop.Arithmetic

example : (21 : ℤ) = -3*1071 + 7*462 := by norm_num
example (a b : ℕ) : Workshop.euclid a b = Nat.gcd a b := by
  exact Workshop.euclid_eq_gcd a b
example : (3 : ZMod 7) * (-2) = 1 := by decide
