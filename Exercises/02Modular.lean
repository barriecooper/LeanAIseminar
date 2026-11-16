import Workshop.Arithmetic

/-! CORE, finish by minute 28. First predict each answer, then replace `sorry`
with `by decide`'s body (`decide`). Finite computation proves these instances.
The type after `:` matters: 3*5 = 1 is false in ℕ, true in ZMod 7.
Ask AI: “Explain a cast and a typeclass to a mathematician, using this goal.” -/
example : (4 : ZMod 7) * 2 = 1 := by
  sorry
example : (2 : ZMod 6) * 3 = 0 := by
  sorry

/-! Use #check ZMod.natCast_eq_zero_iff, then apply the forward direction `.1`.
This is library reuse for arbitrary inputs, not checking finitely many cases. -/
example (a n : ℕ) (h : (a : ZMod n) = 0) : n ∣ a := by
  sorry

/-! OPTIONAL: use Workshop.inverse_of_coprime and prove coprimality by decide.
Why can you not replace 5 by 2? Do not assume every nonzero element is a unit. -/
example : (5 : ZMod 6) * (5 : ZMod 6)⁻¹ = 1 := by
  sorry
