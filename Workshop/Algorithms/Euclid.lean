import Workshop.Instrumentation.Proofs

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

def quotientObserver : EventObserver EuclidEvent where
  State := List Nat
  initial := []
  observe xs e :=
    match e with
    | .division _ _ q _ => q :: xs

/-- Count division events with quotient one. -/
def countQuotientOne : EventObserver EuclidEvent where
  State := Nat
  initial := 0
  observe n
    | .division _ _ q _ => if q = 1 then n + 1 else n

def runEuclid (o : EventObserver EuclidEvent)
    (a b : Nat) : Nat × o.State :=
  let (s, obs) :=
    runObserved euclidStep o (b + 1) (a, b) o.initial
  (s.1, obs)

/-- Return the arithmetic result and the number of division events. -/
def euclidCount (a b : Nat) : Nat × Nat :=
  runEuclid (countObserver EuclidEvent) a b

/-- Return the arithmetic result and division events in chronological order. -/
def euclidTrace (a b : Nat) : Nat × List EuclidEvent :=
  let (gcd, events) := runEuclid (traceObserver EuclidEvent) a b
  (gcd, events.reverse)

theorem euclid_independent
    (o₁ o₂ : EventObserver EuclidEvent)
    (a b : Nat) :
    (runEuclid o₁ a b).1 =
    (runEuclid o₂ a b).1 := by
  have h :=
    observerIndependent euclidStep o₁ o₂
      (b + 1) (a, b) o₁.initial o₂.initial
  simpa [runEuclid] using congrArg Prod.fst h

private theorem euclid_gcd_step (a b : Nat) :
    Nat.gcd a b = Nat.gcd b (a % b) := by
  calc
    Nat.gcd a b = Nat.gcd b a := Nat.gcd_comm _ _
    _ = Nat.gcd (a % b) b := Nat.gcd_rec _ _
    _ = Nat.gcd b (a % b) := Nat.gcd_comm _ _

/-- The final pair has the same GCD even if the runner exhausts its fuel. -/
theorem euclid_gcd_preserved (fuel a b : Nat) :
    Nat.gcd (runPlain euclidStep fuel (a, b)).1
      (runPlain euclidStep fuel (a, b)).2 = Nat.gcd a b := by
  induction fuel generalizing a b with
  | zero => rfl
  | succ fuel ih =>
      by_cases hb : b = 0
      · simp [runPlain, euclidStep, hb]
      · simpa [runPlain, euclidStep, AlgorithmStep.event, hb, euclid_gcd_step a b]
          using ih b (a % b)

/-- If the fuel exceeds the divisor, the runner reaches a zero divisor. -/
theorem euclid_fuel_sufficient (fuel a b : Nat) (h : b < fuel) :
    (runPlain euclidStep fuel (a, b)).2 = 0 := by
  induction fuel generalizing a b with
  | zero => omega
  | succ fuel ih =>
      by_cases hb : b = 0
      · simp [runPlain, euclidStep, hb]
      · have hrem := Nat.mod_lt a (Nat.pos_of_ne_zero hb)
        have hfuel : a % b < fuel := by omega
        simpa [runPlain, euclidStep, AlgorithmStep.event, hb]
          using ih b (a % b) hfuel

theorem euclid_correct (o : EventObserver EuclidEvent) (a b : Nat) :
    (runEuclid o a b).1 = Nat.gcd a b := by
  have h := euclid_gcd_preserved (b + 1) a b
  rw [euclid_fuel_sufficient (b + 1) a b (Nat.lt_succ_self b), Nat.gcd_zero_right] at h
  simpa only [runEuclid, runObserved_correct] using h
