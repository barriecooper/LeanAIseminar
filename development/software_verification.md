# Software verification with observable Euclid

This guide follows the implementation committed at `c9ae303`. The [workshop tutorial](../Workshop/Tutorial.lean#L167) is the place to try the examples in Infoview.

## One calculation, two ways to observe it

An **event observer** collects information as an algorithm runs. In this repository, each step either reports that the run is finished or provides an event and the next algorithm state. The observer receives the event and updates its own record. Think of working through Euclid’s algorithm on paper while someone keeps either a tally of divisions or a transcript of them.

Start with `(1071, 462)`. Each division gives a quotient and a remainder. The next pair consists of the old divisor and the remainder.

```text
1071 = 2 × 462 + 147     next pair (462, 147)
 462 = 3 × 147 +  21     next pair (147, 21)
 147 = 7 ×  21 +   0     next pair (21, 0)
```

When the second component reaches zero, Euclid stops and returns the first component, 21. The tally is 3. The transcript contains three records, each holding the dividend, divisor, quotient and remainder. The count measures **emitted division events**. The final check for a zero divisor emits no event, and elapsed time plays no part in the count.

These two calls use the same inputs and return pairs. The first component is the GCD. The second is the tally or the chronological transcript. Paste the two `#eval` lines into the Euclid section of the tutorial to try them.

```lean
#eval euclidCount 1071 462
#eval euclidTrace 1071 462
```

## How the committed implementation works

[The Euclid module](../Workshop/Algorithms/Euclid.lean#L3) defines the mathematical step `euclidStep` and the event `EuclidEvent.division a b q r`. A step receives the current pair `(a, b)`. If `b = 0`, it reports that the run is finished. Otherwise it computes the quotient `q` and remainder `r`, supplies `(b, r)` as the next pair, and emits the division event.

[The instrumentation module](../Workshop/Instrumentation/Basic.lean#L3) defines `EventObserver` for any event type `E`. A Lean `structure` bundles named fields. This one has three fields.

- `State` is the type of information the observer keeps.
- `initial` is the starting value of that information.
- `observe` takes the current record and one event, and returns the updated record.

The count observer keeps a natural number, starts at zero, and adds one per event. The trace observer keeps a list, starts with an empty list, and puts each new event at the front. That makes the accumulated trace newest-first. `euclidTrace` reverses it once to restore chronological order. The repository also defines an observer that keeps only the quotients and one that counts only divisions with quotient 1.

[The generic runner](../Workshop/Instrumentation/Basic.lean#L18) carries two values. For Euclid, the **algorithm state** is the current number pair. The **observer state** is the tally, list or other record. At each step the runner asks the algorithm for the next pair and event, then gives the event to the observer. The next pair comes entirely from the algorithm. This lets the same runner work with a counting observer whose state is a number and a tracing observer whose state is a list.

## What Lean verifies

A `#eval` displays the result for one input. A theorem states a property for every input satisfying its assumptions, and Lean checks the proof of that statement. The committed code proves three distinct properties.

### Recording the run preserves the algorithm’s result

[`runObserved_correct`](../Workshop/Instrumentation/Proofs.lean#L3) says that the observed run has the same final algorithm state as the plain run for the same step function, starting state and step budget. The proof uses induction on that budget, called *fuel* in the code. With no fuel both runners return the current state. With fuel remaining, they either stop together or take the same next step. In the latter case the observer updates its own record, and the induction hypothesis applies to the rest of the run.

Since any two observers agree with the same plain run, [`observerIndependent`](../Workshop/Instrumentation/Proofs.lean#L22) proves they agree with each other on the final algorithm state. [`euclid_independent`](../Workshop/Algorithms/Euclid.lean#L48) applies this to the first component returned by `runEuclid`, for any two Euclid observers and any starting natural numbers. The result is an equality of returned arithmetic values, with scope limited to observers built through this interface. Running time and memory use can differ.

### A chronological trace can reproduce an observer’s record

[`observation_eq_trace_fold`](../Workshop/Instrumentation/Proofs.lean#L37) says that updating the observer during a run gives the same record as replaying the chronological events afterwards. Replay starts from the observer’s initial value and applies its update once per event, from first to last. Lean calls this a *left fold* (`foldl`). For the tally, replay gives `0 → 1 → 2 → 3`. For an observer whose update depends on the order of events, replaying in chronological order preserves that order. A tally alone cannot recover the transcript.

### The shared arithmetic result really is the GCD

Observer independence establishes agreement with the plain run. [`euclid_correct`](../Workshop/Algorithms/Euclid.lean#L90) establishes agreement with the specification `Nat.gcd a b`, the GCD function in Lean’s standard library. Its proof combines two facts about the plain run.

1. **Preservation.** Each division preserves the GCD of the pair. For a positive divisor, a common divisor of `a` and `b` divides `r = a - q * b`, and a common divisor of `b` and `r` divides `a = q * b + r`. The proof extends this invariant to the whole run.
2. **Enough steps.** A division with positive divisor `b` gives a remainder strictly below `b`. The wrapper supplies `b + 1` fuel, using the initial divisor. The proof shows this budget suffices to reach a pair of the form `(g, 0)`. Since `Nat.gcd g 0 = g`, the preserved GCD is exactly the first component returned by the wrapper.

The observer proof then transfers this conclusion to every observer. The tutorial’s unfinished GCD exercise lets participants explore that argument. The complete proof is in the Euclid module.
