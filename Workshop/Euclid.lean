import Mathlib.Data.Nat.GCD.Basic
import Mathlib.Data.Int.GCD
import Mathlib.Tactic.NormNum

/-! Instructor demonstration: the observer receives a division step and updates
only its own data. It cannot change the next pair of remainders. -/
namespace Workshop

structure Division where
  a : ℕ
  b : ℕ
  q : ℕ
  r : ℕ
  deriving Repr, DecidableEq

-- The second input decreases: a % b < b when b ≠ 0.
def euclid (a b : ℕ) : ℕ :=
  if _h : b = 0 then a else euclid b (a % b)
termination_by b
decreasing_by exact Nat.mod_lt _ (Nat.pos_of_ne_zero _h)

def observe (visit : σ → Division → σ) (a b : ℕ) (data : σ) : ℕ × σ :=
  if _h : b = 0 then (a, data)
  else observe visit b (a % b) (visit data ⟨a, b, a / b, a % b⟩)
termination_by b
decreasing_by exact Nat.mod_lt _ (Nat.pos_of_ne_zero _h)

-- Any observer, any initial data, any inputs: observation preserves the answer.
theorem observe_result (visit : σ → Division → σ) (a b : ℕ) (data : σ) :
    (observe visit a b data).1 = euclid a b := by
  induction b using Nat.strong_induction_on generalizing a data with
  | h b ih =>
    by_cases hb : b = 0
    · simp [observe, euclid, hb]
    · rw [observe, euclid]
      simp only [hb, ↓reduceDIte]
      exact ih (a % b) (Nat.mod_lt a (Nat.pos_of_ne_zero hb)) b _

theorem euclid_eq_gcd (a b : ℕ) : euclid a b = Nat.gcd a b := by
  induction b using Nat.strong_induction_on generalizing a with
  | h b ih =>
    by_cases hb : b = 0
    · simp [euclid, hb]
    · rw [euclid]
      simp only [hb, ↓reduceDIte]
      rw [ih (a % b) (Nat.mod_lt a (Nat.pos_of_ne_zero hb)) b]
      calc
        b.gcd (a % b) = (a % b).gcd b := Nat.gcd_comm _ _
        _ = b.gcd a := (Nat.gcd_rec b a).symm
        _ = a.gcd b := Nat.gcd_comm _ _

def trace (a b : ℕ) : ℕ × List Division :=
  observe (fun rows row => rows ++ [row]) a b []

-- A second observer: retain only the number of divisions, not their rows.
def countSteps (a b : ℕ) : ℕ × ℕ :=
  observe (fun count _ => count + 1) a b 0

-- Two applications of the same universal theorem; recorded data can differ.
theorem trace_result (a b : ℕ) : (trace a b).1 = euclid a b := by
  exact observe_result (fun rows row => rows ++ [row]) a b []

theorem countSteps_result (a b : ℕ) : (countSteps a b).1 = euclid a b := by
  exact observe_result (fun count _ => count + 1) a b 0

def display (a b : ℕ) : List String :=
  (trace a b).2.map fun d => s!"{d.a} = {d.q}*{d.b} + {d.r}"

#eval display 1071 462
#eval trace 1071 462 -- gcd 21 and three division rows
#eval countSteps 1071 462 -- (21, 3): same gcd, only a count recorded

-- Built-in extended Euclid: integer coefficients can be negative.
#check Nat.gcdA
#check Nat.gcdB
#check Nat.gcd_eq_gcd_ab
#eval (Nat.gcd 1071 462, Nat.gcdA 1071 462, Nat.gcdB 1071 462)

example (a b : ℕ) : (Nat.gcd a b : ℤ) =
    (a : ℤ) * Nat.gcdA a b + (b : ℤ) * Nat.gcdB a b := by
  exact Nat.gcd_eq_gcd_ab a b

-- Optional implementation: unwind the recursion to obtain Bézout coefficients.
-- If g = b*s + (a-q*b)*t, then g = a*t + b*(s-q*t).
-- Mathlib verifies its own gcdA/gcdB above. This teaching implementation
-- has concrete checks in Validation, but no general correctness theorem here.
def extended (a b : ℕ) : ℕ × ℤ × ℤ :=
  if _h : b = 0 then (a, 1, 0)
  else
    let (g, s, t) := extended b (a % b)
    (g, t, s - (a / b : ℕ) * t)
termination_by b
decreasing_by exact Nat.mod_lt _ (Nat.pos_of_ne_zero _h)

#eval extended 1071 462
#eval extended 3 7

end Workshop
