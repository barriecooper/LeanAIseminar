module

public import Workshop.Instrumentation.Basic

public section

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

/-- An online observer agrees with a left fold over the chronological trace. -/
theorem observation_eq_trace_fold
    {S E : Type}
    (step : S → AlgorithmStep S E)
    (o : EventObserver E)
    (fuel : Nat) (s : S) :
    (runObserved step o fuel s o.initial).2 =
      (runObserved step (traceObserver E) fuel s []).2.reverse.foldl
        o.observe o.initial := by
  -- Start the online observer with the state computed from the trace so far.
  have go (k : Nat) (current : S) (events : List E) :
      (runObserved step o k current
        (events.reverse.foldl o.observe o.initial)).2 =
        (runObserved step (traceObserver E) k current events).2.reverse.foldl
          o.observe o.initial := by
    induction k generalizing current events with
    | zero => rfl
    | succ k ih =>
        cases h : step current with
        | none => simp [runObserved, h]
        | some p =>
            obtain ⟨next, e⟩ := p
            simpa [runObserved, h, traceObserver, List.reverse_cons, List.foldl_append]
              using ih next (e :: events)
  exact go fuel s []
