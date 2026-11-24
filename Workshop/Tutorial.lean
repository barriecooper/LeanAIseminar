module

import Workshop.Algorithms.Euclid
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.Linarith
-- The #eval examples also use these modules at compile time.
meta import Workshop.Algorithms.Euclid
meta import Mathlib.Data.ZMod.Basic

set_option linter.unusedTactic false

/-!
Open Lean Infoview and click a `#check` or `#eval` line to see its result.
Click inside a proof to see the goal. Try editing the examples and replacing
the `sorry` placeholders with proofs. Sections marked optional can wait. If you use AI, ask it to explain
the current goal and suggest one next step, then check the suggestion in Lean.
-/

/-
# Divisibility
-/

namespace Tutorial
namespace Divisibility

variable (a b c d : Int) -- we declare a, b and c to be integers throughout (of type `Int`)

/-
We can `#check` what sort of object anything is ...
-/
#check a      -- a has type `Int`
#check a ∣ b  -- a divides b has type `Prop` and is true or false depending on the inputs
#check b / a  -- b divided by a has type `Int`
#check b % a  -- b remainder a has type `Int`

/-
We can also evaluate expressions with `#eval`.
-/
#eval (4 : Int) ∣ 12  -- true since 12 = 4 * 3
#eval (4 : Int) ∣ 13  -- false
#eval (12 : Int) / 4  -- 3
#eval (13 : Int) / 4  -- also 3 because this is integer arithmetic
#eval (13 : Int) % 4  -- remainder is 1 when dividing 13 by 4

#eval (13 : Int) / 4 * 4  -- integer arithmetic yields 12
#eval (13 : Rat) / 4 * 4  -- rational arithmetic yields 13

/-
We can assert statements as theorems or examples (unnamed theorems), which requires a proof.
-/

example : (4 : Int) ∣ 12 := by  -- the `by` keyword tells Lean to enter proof tactic mode
  grind  -- a useful workhorse proof tactic that deals with many simple goals

example : ¬ ((4 : Int) ∣ 13) := by
  sorry                 -- replace the `sorry` placeholder with a suitable proof tactic

/-
By definition, `a ∣ b` means `∃ c, b = a * c`.
-/

#check dvd_def

/-
A theorem showing how to deal with `there exists`.
-/
theorem dvd_trans (hab : a ∣ b) (hbd : b ∣ d) : a ∣ d := by
  obtain ⟨m, hm⟩ := hab   -- hab is a pair consisting of a witness we call `m` and a proof `hm`
  obtain ⟨n, hn⟩ := hbd   -- hbd similarly consists of a witness `n` and a proof `hn`
  rw [dvd_def]            -- rewrite the target using the definition of divisibility
  rw [hn, hm]             -- rewrite the target using the hypotheses
  exists m * n           -- we exhibit a witness `m * n`
  grind                  -- we must prove that our witness satisfies the required equation
  done

/-
## Exercise 1

Complete the result below, replacing the `sorry` placeholder with as many lines of
Lean code as are necessary.
-/

theorem dvd_add (hab : a ∣ b) (had : a ∣ d) : a ∣ (b + d) := by
  obtain ⟨m, hm⟩ := hab   -- hab is a pair consisting of a witness we call `m` and a proof `hm`
  obtain ⟨n, hn⟩ := had   -- hbc similarly consists of a witness `n` and a proof `hn`
  sorry
  done

/-
## Exercise 2 (optional)

Think of another result concerning divsibility. State and prove it in Lean.
-/

end Divisibility

/-
# Mathlib and arithmetic modulo 7

`(a : ZMod 7)` coerces the integer `a` to its residue class modulo 7.
Two integers have the same residue class when their difference is divisible
by 7. In particular, multiples of 7 have residue zero.
-/
#check (a : ZMod 7)
#eval ((-1 : Int) : ZMod 7)  -- 6
#eval ((13 : Int) : ZMod 7)  -- 6
#eval ((14 : Int) : ZMod 7)  -- 0

#check Int.castRingHom (ZMod 7)
#check ZMod.intCast_zmod_eq_zero_iff_dvd

example (x : Int) : (x : ZMod 7) = 0 ↔ (7 : Int) ∣ x := by
  exact ZMod.intCast_zmod_eq_zero_iff_dvd x 7

-- The canonical ring homomorphism preserves addition.
example (x y : Int) :
    (Int.castRingHom (ZMod 7)) (x + y) = (x : ZMod 7) + (y : ZMod 7) := by
  exact map_add (Int.castRingHom (ZMod 7)) x y

/- Optional exercise. Adapt the addition proof to multiplication. -/
example (x y : Int) :
    (Int.castRingHom (ZMod 7)) (x * y) = (x : ZMod 7) * (y : ZMod 7) := by
  sorry

example (x y z : Int) (h : x ∣ y - z) : x ∣ z - y := by
  apply?

/-
Read the suggestion in Infoview. Replace `apply?` with the explicit proof
using the suggested Mathlib theorem, then explain why reversing the
difference preserves divisibility. The earlier witness proof constructs a
multiplier and checks its equation. Here a library theorem supplies the
implication from the given divisibility hypothesis.
-/

/-
# Recursion and induction
-/

def f : Nat → Nat
  | 0 => 0
  | n + 1 => 3 * f n + 2

#eval f 8

theorem f_even (n : Nat) : 2 ∣ f n := by
  induction n with
  | zero => simp [f]
  | succ n ih =>
      simp [f]
      grind

def g : Nat → Nat
  | 0 => 1
  | n + 1 => 3 * g n + 2

#eval g 8

/-
Exercise 2: State and prove a theorem about g.
-/

/-
## Optional: induction on labelled binary trees

A leaf stores a value of type `α`. A branch stores a value of the same type
at its root, along with its left and right subtrees. We'll use natural numbers
for the labels.
-/

inductive LabelledTree (α : Type) where
  | leaf (value : α)
  | branch (value : α) (left right : LabelledTree α)

namespace LabelledTree

#check LabelledTree.branch

-- Join two trees under a new root labelled 4.
def sample : LabelledTree Nat :=
  .branch 4 (.leaf 2) (.branch 7 (.leaf 1) (.leaf 3))

-- Build a tree recursively, putting n at the root of countdown n.
def countdown : Nat → LabelledTree Nat
  | 0 => .leaf 0
  | n + 1 => .branch (n + 1) (countdown n) (.leaf 0)

def sum : LabelledTree Nat → Nat
  | .leaf value => value
  | .branch value left right => value + (sum left + sum right)

#eval sum sample         -- 17
#eval sum (countdown 3)  -- 6

-- Draw each branch with its left child above its right child.
def draw (tree : LabelledTree Nat) : String :=
  let rec drawAt (tree : LabelledTree Nat) (linePrefix childPrefix : String) : String :=
    match tree with
    | .leaf value => linePrefix ++ toString value
    | .branch value left right =>
      linePrefix ++ toString value ++ "\n" ++
        drawAt left (childPrefix ++ "├─ ") (childPrefix ++ "│  ") ++ "\n" ++
        drawAt right (childPrefix ++ "└─ ") (childPrefix ++ "   ")
  drawAt tree "" ""

-- Put the cursor on a #eval line to see the diagram in Infoview.
#eval IO.println (draw sample)
#eval IO.println (draw (countdown 2))

def mirror : LabelledTree α → LabelledTree α
  | .leaf value => .leaf value
  | .branch value left right => .branch value (mirror right) (mirror left)

#eval IO.println (draw (mirror sample))

/-
Mirroring preserves the sum of the labels. In the branch case, look in
Infoview for one induction hypothesis per subtree. Once both hypotheses
have been used, the two subtrees' sums appear in opposite orders.
-/
theorem sum_mirror (tree : LabelledTree Nat) : sum (mirror tree) = sum tree := by
  induction tree with
  | leaf value => rfl
  | branch value left right ihLeft ihRight =>
    simp only [mirror, sum, ihLeft, ihRight]
    grind

-- Apply a function to every vertex label.
def map (f : α → β) : LabelledTree α → LabelledTree β
  | .leaf value => .leaf (f value)
  | .branch value left right => .branch (f value) (map f left) (map f right)

#eval sum (map (fun value => 2 * value) sample)  -- 34

/-
Exercise. Predict what happens to the sum if each label is tripled.
Try it on sample, then adapt sum_map_double to prove your prediction for
every tree. Use Infoview to see the arithmetic goal before `omega`.
-/
theorem sum_map_double (tree : LabelledTree Nat) :
    sum (map (fun value => 2 * value) tree) = 2 * sum tree := by
  induction tree with
  | leaf value => rfl
  | branch value left right ihLeft ihRight =>
    simp only [map, sum, ihLeft, ihRight]
    grind

end LabelledTree

/-
## Optional: cooling halfway to room temperature

A mug starts at 80°C in a 20°C room. In this model, each step takes the
mean of the current temperature and room temperature, halving the gap.
We use rational numbers so half degrees are kept exactly.
-/
def coolingStep (temp room : ℚ) : ℚ :=
  (temp + room) / 2

#eval coolingStep 80 20                      -- 50
#eval coolingStep (coolingStep 80 20) 20      -- 35

/- Try different temperatures. Before reading the proof, predict where the
   next temperature lies when the mug starts at or above room temperature.
   Click after `constructor` in Infoview to see the two inequalities. -/
theorem coolingStep_between (room temp : ℚ) (h : room ≤ temp) :
    room ≤ coolingStep temp room ∧ coolingStep temp room ≤ temp := by
  unfold coolingStep
  grind

/-
# Collatz dynamics

We can also use `if ... then ... else` conditions, e.g. to define the collatz function.
-/
def collatz (n : Nat) : Nat :=
  if n % 2 == 0 then
    n / 2
  else
    3 * n + 1

#eval collatz 10  -- 5
#eval collatz 11  -- 34

/-
We can define taking k-steps with the collatz function recursively.
-/
def collatzSeq (n : Nat) : Nat → Nat
  | 0 => n
  | k + 1 => collatz (collatzSeq n k)

#eval collatzSeq 7 4    -- starting at 7 where do we get after 4 collatz steps?
#eval (List.range 20).map (collatzSeq 7)    -- the first 20 values starting at 7

/- Exercise 3: Prove that a number with remainder 1 modulo 4 takes the odd
   branch and lands on a multiple of 4. -/
theorem collatz_mod_four (n : Nat)
    (h : n % 4 = 1) :
    collatz n % 4 = 0 := by
  sorry

example (n : Nat) (hp : 1 < n) (h : n % 4 = 1) :
    collatzSeq n 3 < n := by
  simp [collatzSeq, collatz]
  grind


example (n : Nat) (h : ∃ k, n = 2 * k + 1) : ∃ m, collatz n = 2 * m := by
  obtain ⟨k, rfl⟩ := h
  unfold collatz
  use 3 * k + 2
  simp
  grind

/-
# Euclid's algorithm

A division event records the dividend, divisor, quotient and remainder.
Open the definition of `euclidStep` to see the transition. It stops at a
zero divisor. Otherwise, `.event (b, r) (.division a b q r)` supplies the next
pair and tells the observer about the division. Each observer sees the same
events and can update only its own state.
-/

def euclid (a b : ℕ) :=
  if _h : b = 0 then a else euclid b (a % b)
  termination_by b
  decreasing_by
  apply Nat.mod_lt
  exact Nat.ne_zero_iff_zero_lt.mp _h

lemma euclid_eq_euclid_mod_of_ne_zero (a b : ℕ) (h : b ≠ 0) : euclid a b = euclid b (a % b) := by
  conv_lhs =>
    unfold euclid
  simp [h]

lemma euclid_zero_eq (a : ℕ) : euclid a 0 = a := by
  unfold euclid
  exact ite_eq_left rfl

example (a b : ℕ) : euclid a b ∣ a ∧ euclid a b ∣ b := by
  induction b using Nat.strong_induction_on generalizing a with
  | ind b ih =>
  by_cases hb : b = 0
  · subst hb
    rw [euclid_zero_eq]
    simp
  · rw [euclid_eq_euclid_mod_of_ne_zero _ _ hb]
    have rem_lt : a % b < b := by
      refine Nat.mod_lt a ?_
      exact Nat.ne_zero_iff_zero_lt.mp hb
    specialize ih (a % b) rem_lt b
    have h3 : b * (a / b) + a % b = a := Nat.div_add_mod a b
    rcases ih with ⟨midb, midr⟩
    constructor
    · nth_rewrite 2 [←h3]
      apply dvd_add
      · exact Nat.dvd_mul_right_of_dvd midb (a / b)
      exact midr
    exact midb

example (a b d : ℕ) (h : d ∣ a ∧ d ∣ b) : d ∣ euclid a b := by
 induction b using Nat.strong_induction_on generalizing a d with
 | ind b ih =>
  by_cases hb : b = 0
  · subst hb
    rw [euclid_zero_eq]
    grind
  · rw [euclid_eq_euclid_mod_of_ne_zero _ _ hb]
    apply ih
    · refine Nat.mod_lt a ?_
      exact Nat.zero_lt_of_ne_zero hb
    simp_all only [and_imp, true_and]
    obtain ⟨left, right⟩ := h
    exact (Nat.dvd_mod_iff right).mpr left


#check EuclidEvent.division
#check euclidStep
#eval euclidStep (1071, 462)  -- some ((462, 147), division 1071 462 2 147)

#eval runEuclid (ignoreObserver EuclidEvent) 1071 462  -- (21, ())
#eval runEuclid (countObserver EuclidEvent) 1071 462   -- (21, 3)
#eval runEuclid (traceObserver EuclidEvent) 1071 462   -- reverse order
#eval euclidTrace 1071 462                            -- chronological order
#eval runEuclid quotientObserver 1071 462             -- (21, [7, 3, 2])
#eval
  let (gcd, quotients) := runEuclid quotientObserver 1071 462
  (gcd, quotients.reverse)                            -- (21, [2, 3, 7])

/-
The divisions are 1071 = 2 × 462 + 147, 462 = 3 × 147 + 21 and
147 = 7 × 21 + 0. The quotients [2, 3, 7] give the continued fraction for
1071/462. The count is the number of division events. A trace also gives
the count through its length. The count observer stores just a number, so
recovering the actual events from it would require running Euclid again.
-/
example (a b : Nat) :
    (runEuclid (countObserver EuclidEvent) a b).1 =
    (runEuclid (traceObserver EuclidEvent) a b).1 := by
  exact euclid_independent _ _ a b

/- Exercise 4: Try another input pair with all three observers. Predict the
   count from the trace, then try a pair with second input zero. -/

/-
## Optional: collecting observations from the trace

`observation_eq_trace_fold` says updating an observer as events occur gives
the same state as folding its update function over the chronological trace.
The trace observer prepends events, so `euclidTrace` reverses them before
the fold. The quotient observer also prepends, so both results below store
the quotients in reverse order.

The theorem works with any observer state. For example, a greedy colouring
observer could keep separate counts for starting a vertex, inspecting a
neighbour, testing a colour and assigning a colour.
-/
#eval (euclidTrace 1071 462).2.foldl
  quotientObserver.observe quotientObserver.initial  -- [7, 3, 2]

example (a b : Nat) :
    (runEuclid quotientObserver a b).2 =
      (euclidTrace a b).2.foldl quotientObserver.observe quotientObserver.initial := by
  exact observation_eq_trace_fold euclidStep quotientObserver (b + 1) (a, b)

/-
Optional exercise. `countQuotientOne` counts divisions whose quotient is 1.
Use the generic theorem to prove its online count agrees with the fold.
-/
theorem countQuotientOne_eq_trace_fold (a b : Nat) :
    (runEuclid countQuotientOne a b).2 =
      (euclidTrace a b).2.foldl countQuotientOne.observe countQuotientOne.initial := by
  sorry

/-
## Optional AI-assisted challenge: prove Euclid computes the GCD

Evaluations test individual inputs. Observer independence establishes that
observers agree on the result. The proof that this result equals `Nat.gcd`
has three stages.

1. GCD preservation. Show that a division preserves the GCD of the pair,
   then extend this to the plain run by induction on fuel.
2. Fuel bound. Show that the divisor decreases at each division, so
   `b + 1` fuel reaches a pair with second component zero.
3. Observer and runner. Use `runObserved_correct` to reduce the observed
   result to the first component of the plain run. Apply the first two
   stages and the GCD rule for a zero second argument.

Ask AI one question at a time and check each suggested lemma with `#check`
and each proof step in Lean Infoview. Try these prompts.

* What invariant relates the GCD of the current pair to the starting pair?
  Which Lean lemmas express the remainder step?
* If the divisor is positive, which Lean lemma bounds the next divisor?
  How does that inequality support induction on the fuel?
* Once the final divisor is zero, how can I use `runObserved_correct`
  to finish the proof for an arbitrary observer?

The full instructor proof is `euclid_correct` in Workshop/Algorithms/Euclid.lean.
-/
example (o : EventObserver EuclidEvent) (a b : Nat) :
    (runEuclid o a b).1 = Nat.gcd a b := by
  -- First relate the observed run to the plain run.
  simp only [runEuclid, runObserved_correct]
  have gcd_preserved := euclid_gcd_preserved (b + 1) a b
  have final_divisor_zero :=
    euclid_fuel_sufficient (b + 1) a b (Nat.lt_succ_self b)
  -- With a zero divisor, the GCD is the first component of the final pair.
  rw [final_divisor_zero, Nat.gcd_zero_right] at gcd_preserved
  exact gcd_preserved

/-
# Optional: statistics

## Simpson's paradox on a solver benchmark

                A solved    B solved
Easy              3 / 4       6 / 9
Hard              3 / 9       1 / 4

Which solver has the higher success rate at each difficulty?
Predict the overall winner, then evaluate the pooled rates in Infoview.
-/
#eval (3 / 4 : ℚ) > 6 / 9  -- true
#eval (3 / 9 : ℚ) > 1 / 4  -- true
#eval (6 / 13 : ℚ) < 7 / 13  -- true

/- An overall rate is a weighted average. The weight is the share of easy
   problems, expressed as a fraction between zero and one. -/
def benchmarkRate (easyShare easyRate hardRate : ℚ) : ℚ :=
  easyShare * easyRate + (1 - easyShare) * hardRate

/- Let p and q be the shares of easy problems for A and B. How much higher
   must B's share be for B to win overall? Try proving the two directions
   of the equivalence separately after unfolding `benchmarkRate`. -/
theorem benchmark_reversal (p q : ℚ) :
    benchmarkRate p (3 / 4) (3 / 9) < benchmarkRate q (6 / 9) (1 / 4)
      ↔ 1 / 5 < q - p := by
  unfold benchmarkRate
  constructor <;> intro h <;> linarith

/- The threshold is 20 percentage points. As a follow-up, use the same share
   w for both solvers and prove that A leads by exactly 1 / 12. -/
example (w : ℚ) :
    benchmarkRate w (3 / 4) (3 / 9) -
      benchmarkRate w (6 / 9) (1 / 4) = 1 / 12 := by
  unfold benchmarkRate
  linarith

/-
## Why the median minimises absolute error

Three sensors report 20, 21 and 1000. Choose one estimate and add its
absolute errors against all three readings. Try a few estimates.
-/
def absoluteLoss (low middle high estimate : ℚ) : ℚ :=
  |high - estimate| + |estimate - low| + |estimate - middle|

#eval absoluteLoss 20 21 1000 20  -- 981
#eval absoluteLoss 20 21 1000 21  -- 980

/- For any sorted triple, moving away from the middle reading increases the
   loss by at least the distance moved. Before reading the proof, ask which
   two terms you could pair and what lower bound their sum must satisfy.

   The triangle inequality bounds the error from the two outer readings
   below by high - low. The middle reading attains that bound and makes the
   third error zero. Use Infoview to inspect `outerBound` before the final
   arithmetic step. -/

/-
One way to prove this is to use the result `abs__sub_le`, which states that
`|a - c| ≤ |a - b| + |b - c|`
-/

#check abs_sub_le

theorem median_loss_gap (low middle high estimate : ℚ)
    (hllm : low ≤ middle) (hmlh : middle ≤ high) :
    (absoluteLoss low middle high middle) + |estimate - middle| ≤
      absoluteLoss low middle high estimate := by
  unfold absoluteLoss
  simp
  have h2 : |high - middle| + |middle - low| = |high - low| := by grind
  rw [h2]
  apply abs_sub_le


/- theorem median_loss_gap (low middle high estimate : ℚ)
    (low_le_middle : low ≤ middle) (middle_le_high : middle ≤ high) :
    absoluteLoss low middle high middle + |estimate - middle| ≤
      absoluteLoss low middle high estimate := by
  have span_nonneg : 0 ≤ high - low :=
    sub_nonneg.mpr (low_le_middle.trans middle_le_high)
  have outerBound : high - low ≤ |high - estimate| + |estimate - low| := by
    simpa only [abs_of_nonneg span_nonneg] using abs_sub_le high estimate low
  unfold absoluteLoss
  rw [abs_of_nonneg (sub_nonneg.mpr middle_le_high),
    abs_of_nonneg (sub_nonneg.mpr low_le_middle), sub_self middle, abs_zero, add_zero]
  linarith
 -/

example (low middle high estimate : ℚ)
    (low_le_middle : low ≤ middle) (middle_le_high : middle ≤ high) :
    absoluteLoss low middle high middle + |estimate - middle| ≤
      absoluteLoss low middle high estimate := by
  have span_nonneg : 0 ≤ high - low :=
    sub_nonneg.mpr (low_le_middle.trans middle_le_high)
  have outerBound : high - low ≤ |high - estimate| + |estimate - low| := by
    simpa only [abs_of_nonneg span_nonneg] using abs_sub_le high estimate low
  unfold absoluteLoss
  rw [abs_of_nonneg (sub_nonneg.mpr middle_le_high),
    abs_of_nonneg (sub_nonneg.mpr low_le_middle), sub_self middle, abs_zero, add_zero]
  linarith
/- Stretch. Prove the same bound for five sorted readings. Pair the smallest
   with the largest, then the second-smallest with the second-largest.
   Which terms are left, and where are both pairwise bounds attained? -/

end Tutorial
