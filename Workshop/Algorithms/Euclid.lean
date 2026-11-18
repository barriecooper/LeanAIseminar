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
