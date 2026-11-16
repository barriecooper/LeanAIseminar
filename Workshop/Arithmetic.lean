import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.NormNum
import Lean.Elab.Tactic.LibrarySearch

/-! Read the types before the tactics. `ℕ` is the natural numbers; `∣` is a
proposition. `⟨c, proof⟩` supplies an existential witness and its equation. -/
namespace Workshop

-- This really is the definition, including the multiplication orientation.
theorem divides_iff (a b : ℕ) : a ∣ b ↔ ∃ c, b = a * c := Iff.rfl

example : (3 : ℕ) ∣ 12 := by
  exact ⟨4, by norm_num⟩

-- Read these signatures in Infoview; implicit arguments are inferred.
#check dvd_trans
#check Nat.dvd_gcd
#check ZMod.natCast_eq_zero_iff
#check ZMod.isUnit_iff_coprime
#check ZMod.coe_mul_inv_eq_one

example (a b c : ℕ) (hab : a ∣ b) (hbc : b ∣ c) : a ∣ c := by
  exact dvd_trans hab hbc

-- A cast sends a natural number into a different mathematical structure.
-- ZMod 7 is a field (7 is prime); ZMod 6 is a ring with zero divisors.
example : (3 : ZMod 7) * 5 = 1 := by decide
example : (2 : ZMod 6) * 3 = 0 := by decide
example : (2 : ZMod 6) ≠ 0 ∧ (3 : ZMod 6) ≠ 0 := by decide

-- The exact bridge between the proposition and modular arithmetic, for all n.
-- ZMod 0 is ℤ, so the statement also handles n = 0 honestly.
theorem cast_zero (a n : ℕ) : (a : ZMod n) = 0 ↔ n ∣ a := by
  exact ZMod.natCast_eq_zero_iff a n

-- Coprimality, rather than merely being nonzero, guarantees an inverse.
theorem inverse_of_coprime (a n : ℕ) (h : Nat.Coprime a n) :
    (a : ZMod n) * (a : ZMod n)⁻¹ = 1 := by
  exact ZMod.coe_mul_inv_eq_one a h

example : IsUnit (5 : ZMod 6) := by
  exact (ZMod.isUnit_iff_coprime 5 6).2 (by decide)
example : ¬ IsUnit (2 : ZMod 6) := by
  intro h
  have hc : Nat.Coprime 2 6 := (ZMod.isUnit_iff_coprime 2 6).1 h
  exact (by decide : ¬ Nat.Coprime 2 6) hc
end Workshop
