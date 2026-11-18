import Workshop.Algorithms.Euclid

/-!
Open Lean Infoview and click a `#check` or `#eval` line to see its result.
Click inside a proof to see the goal. Try editing the examples and replacing
the two `sorry` placeholders with proofs. If you use AI, ask it to explain
the current goal and suggest one next step, then check the suggestion in Lean.
-/

/-
# Divisibility
-/

namespace Tutorial

variable (a b c : Int) -- we declare a, b and c to be integers throughout (of type `Int`)

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
A theorem showing how to deal with `there exists`.
-/

theorem dvd_trans (hab : a ∣ b) (hbc : b ∣ c) : a ∣ c := by
  obtain ⟨m, hm⟩ := hab   -- hab is a pair consisting of a witness we call `m` and a proof `hm`
  obtain ⟨n, hn⟩ := hbc   -- hbc similarly consists of a witness `n` and a proof `hn`
  exists m * n           -- we exhibit a witness `m * n`
  grind                  -- we must prove that our witness satisfies the required equation

/-
And an alternative version showing how to deal with `for all` and how to use existing theorems.
-/

theorem quant_dvd_trans : ∀ x : Int, ∀ y : Int, ∀ z : Int, x ∣ y ∧ y ∣ z → x ∣ z := by
  intro x y z                     -- introduce concrete named objects to work with
  intro ⟨hxy, hyz⟩                -- introduce the pair of conditions `hxy` and `hyz`
  apply dvd_trans x y z hxy hyz   -- conclude by applying our previous theorem `dvd_trans`

/-
Exercise 1: Invent some of your own theorems and proofs involving divisibility. Depending on how ambitious you are, you might need to explore (with the help of AI?) new proof tactics.
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

/-
# Euclid's algorithm

A division event records the dividend, divisor, quotient and remainder.
Open the definition of `euclidStep` to see the transition. It stops at a
zero divisor. Otherwise, `.event (b, r) (.division a b q r)` supplies the next
pair and tells the observer about the division. Each observer sees the same
events and can update only its own state.
-/
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

end Tutorial
