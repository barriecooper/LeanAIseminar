/-
# Divisibility
-/

variable (a b c : Int) -- we declare a, b and c to be integers throughout (of type `Int`)

/-
We can `#check` what sort of object anything is ...
-/
#check a      -- a has type `Int`
#check a ∣ b  -- a divides b has type `Prop` and is true or false depending on the inputs
#check b / a  -- b divided by a has type `Int`
#check b % a  -- b remainder a has type `Int`

/-
We can also evaluate expression with `#eval`.
-/
#eval 4 ∣ 12  -- true since 12 = 4 * 3
#eval 4 ∣ 13  -- false
#eval 12 / 4  -- 3
#eval 13 / 4  -- also 3 because this is integer arithmetic
#eval 13 % 4  -- remainder is 1 when dividing 13 by 4

#eval 13 / 4 * 4          -- integer arithmetic yields 12
#eval (13 : Rat) / 4 * 4  -- rational arithmetic yields 13

/-
We can assert statements as theorems or examples (unnamed theorems), which requires a proof.
-/

example : 4 ∣ 12 := by  -- the `by` keyword tells Lean to enter proof tactic mode
  grind                 -- a useful workhorse proof tactic that deals with many simple goals

example : ¬ (4 ∣ 13) := by
  sorry                 -- replace the `sorry` placeholder with a suitable proof tactic

/-
A theorem showing how to deal with `there exists`.
-/

theorem dvd_trans (hab : a ∣ b) (hbc : b ∣ c) : a ∣ c := by
  obtain ⟨m, hm⟩ := hab   -- hab is a pair consisting of a witness we call `m` and a proof `hm`
  obtain ⟨n, hn⟩ := hbc   -- hbc similarly consists of a witness `n` and a proof `hn`
  exists m * n            -- we exhibit a witness `m * n`
  grind                   -- we must prove that our witness satisfies the required equation

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
  | succ n ih => simp [f]
                 grind

def g : Nat → Nat
  | 0 => 1
  | n + 1 => 3 * g n + 2

#eval g 8

/-
Exercise 2: State and prove a theorem about g.
-/
/-
We can also use `if ... then ... else` conditions, e.g. to define the collatz function.
-/
def collatz (n : Nat) : Nat :=
  if n % 2 == 0 then
    n / 2
  else
    3 * n + 1

#eval collatz 11

/-
We can define taking k-steps with the collatz function recursively.
-/
def collatzSeq (n : Nat) : Nat → Nat
  | 0 => n
  | k + 1 => collatz (collatzSeq n k)

#eval collatzSeq 7 4    -- starting at 7 where do we get after 4 collatz steps?
#eval (List.range 20).map (collatzSeq 7)    -- the first 20 values starting at 7

theorem collatz_mod_four (n : Nat)
    (h : n % 4 = 1) :
    collatz n % 4 = 0 := by
  sorry

/-
# Instrumented algorithms
-/

-- PART 1: Generic instrumentation framework

structure EventObserver (E : Type) where
  State : Type
  initial : State
  observe : State → E → State

-- A transition either terminates or emits an event
-- and supplies the next mathematical state.

abbrev AlgorithmStep (S E : Type) :=
  Option (S × E)

def AlgorithmStep.event {S E : Type}
    (next : S) (e : E) : AlgorithmStep S E :=
  some (next, e)

-- Run with an observer.

def runObserved {S E : Type}
    (step : S → AlgorithmStep S E)
    (o : EventObserver E) :
    Nat → S → o.State → S × o.State
  | 0, s, obs => (s, obs)
  | fuel + 1, s, obs =>
      match step s with
      | none => (s, obs)
      | some (next, e) =>
          runObserved step o fuel next
            (o.observe obs e)

-- Run the same algorithm without observing anything.

def runPlain {S E : Type}
    (step : S → AlgorithmStep S E) :
    Nat → S → S
  | 0, s => s
  | fuel + 1, s =>
      match step s with
      | none => s
      | some (next, _) =>
          runPlain step fuel next


-- PART 2: The generic independence theorem

theorem runObserved_correct
    {S E : Type}
    (step : S → AlgorithmStep S E)
    (o : EventObserver E)
    (fuel : Nat) (s : S) (obs : o.State) :
    (runObserved step o fuel s obs).1 =
      runPlain step fuel s := by
  induction fuel generalizing s obs with
  | zero =>
      rfl
  | succ k ih =>
      cases h : step s with
      | none =>
          simp [runObserved, runPlain, h]
      | some p =>
          rcases p with ⟨next, e⟩
          simpa [runObserved, runPlain, h] using
            ih next (o.observe obs e)

theorem observerIndependent
    {S E : Type}
    (step : S → AlgorithmStep S E)
    (o₁ o₂ : EventObserver E)
    (fuel : Nat) (s : S)
    (obs₁ : o₁.State) (obs₂ : o₂.State) :
    (runObserved step o₁ fuel s obs₁).1 =
    (runObserved step o₂ fuel s obs₂).1 := by
  calc
    (runObserved step o₁ fuel s obs₁).1
        = runPlain step fuel s :=
          runObserved_correct step o₁ fuel s obs₁
    _ = (runObserved step o₂ fuel s obs₂).1 :=
          (runObserved_correct step o₂ fuel s obs₂).symm


-- PART 3: Euclid's algorithm

inductive EuclidEvent where
  | division (a b q r : Nat)
  deriving Repr

-- The mathematical algorithm: one Euclidean step.

def euclidStep (s : Nat × Nat) :
    AlgorithmStep (Nat × Nat) EuclidEvent :=
  let (a, b) := s
  if b == 0 then
    none
  else
    let q := a / b
    let r := a % b
    .event (b, r) (.division a b q r)


-- PART 4: Observers

def ignoreObserver : EventObserver EuclidEvent where
  State := Unit
  initial := ()
  observe s _ := s

def countObserver : EventObserver EuclidEvent where
  State := Nat
  initial := 0
  observe n _ := n + 1

def traceObserver : EventObserver EuclidEvent where
  State := List EuclidEvent
  initial := []
  observe xs e := e :: xs

def quotientObserver : EventObserver EuclidEvent where
  State := List Nat
  initial := []
  observe xs e :=
    match e with
    | .division _ _ q _ => q :: xs


-- PART 5: Run Euclid

def runEuclid (o : EventObserver EuclidEvent)
    (a b : Nat) : Nat × o.State :=
  let (s, obs) :=
    runObserved euclidStep o (b + 1) (a, b) o.initial
  (s.1, obs)

#eval runEuclid ignoreObserver 1071 462
-- (21, ())

#eval runEuclid countObserver 1071 462
-- (21, 3)

#eval runEuclid traceObserver 1071 462

#eval runEuclid quotientObserver 1071 462
-- (21, [7, 3, 2])

-- Reverse the trace into chronological order.

#eval
  let (g, xs) := runEuclid traceObserver 1071 462
  (g, xs.reverse)


-- PART 6: Euclid inherits observer independence

theorem euclid_independent
    (o₁ o₂ : EventObserver EuclidEvent)
    (a b : Nat) :
    (runEuclid o₁ a b).1 =
    (runEuclid o₂ a b).1 := by
  have h :=
    observerIndependent euclidStep o₁ o₂
      (b + 1) (a, b) o₁.initial o₂.initial
  simpa [runEuclid] using congrArg Prod.fst h