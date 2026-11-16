import Workshop.Arithmetic

/-! CORE, 20–28 minutes. Open Lean Infoview, click after `by`, then replace
`sorry`. The goal is what remains to prove; the lines above it are hypotheses.
`\dvd` types ∣; `\N` types ℕ; you can also copy the symbols below.

1. First success: supply a multiplier witnessing 4 ∣ 20.
Hint: `exact ⟨5, by norm_num⟩`. Why is the equation 20 = 4*5?
Change both numbers and predict whether a witness still exists.
AI: “Explain this goal and what an existential witness is; give one hint.”
-/
example : (4 : ℕ) ∣ 20 := by
  sorry

/-! 2. SEARCH TASK: put `exact?` in place of `sorry` below and wait for the
“Try this” suggestion. Read its signature with `#check`, then replace the search
with the suggested explicit proof. Alternatively try `apply?`.
Do this before looking at Solutions/Core.lean or Workshop/Arithmetic.lean.
AI: “How can I search Mathlib for a theorem that composes these hypotheses?” -/
example (a b c : ℕ) (hab : a ∣ b) (hbc : b ∣ c) : a ∣ c := by
  sorry

/-! 3. Stretch search: find a theorem that constructs divisibility of a gcd
from the two hypotheses. What are its explicit and implicit arguments? -/
example (d a b : ℕ) (ha : d ∣ a) (hb : d ∣ b) : d ∣ Nat.gcd a b := by
  sorry
