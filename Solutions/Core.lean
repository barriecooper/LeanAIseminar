import Workshop.Arithmetic

-- Checked completions of every hole in Exercises/01 and Exercises/02.
example : (4 : ℕ) ∣ 20 := by
  exact ⟨5, by norm_num⟩
example (a b c : ℕ) (hab : a ∣ b) (hbc : b ∣ c) : a ∣ c := by
  exact dvd_trans hab hbc
example (d a b : ℕ) (ha : d ∣ a) (hb : d ∣ b) : d ∣ Nat.gcd a b := by
  exact Nat.dvd_gcd ha hb
example : (4 : ZMod 7) * 2 = 1 := by decide
example : (2 : ZMod 6) * 3 = 0 := by decide
example (a n : ℕ) (h : (a : ZMod n) = 0) : n ∣ a := by
  exact (ZMod.natCast_eq_zero_iff a n).1 h
example : (5 : ZMod 6) * (5 : ZMod 6)⁻¹ = 1 := by
  exact Workshop.inverse_of_coprime 5 6 (by decide)
