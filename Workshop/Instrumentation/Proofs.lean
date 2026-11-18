import Workshop.Instrumentation.Basic

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
