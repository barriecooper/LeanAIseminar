/-! Event observers accumulate information alongside a state transition. -/

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

def ignoreObserver (E : Type) : EventObserver E where
  State := Unit
  initial := ()
  observe s _ := s

def countObserver (E : Type) : EventObserver E where
  State := Nat
  initial := 0
  observe n _ := n + 1

def traceObserver (E : Type) : EventObserver E where
  State := List E
  initial := []
  observe xs e := e :: xs
