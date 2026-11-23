# Software verification with event observers

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

## What the instrumentation definitions model

### Algorithm state `S` and event type `E`

The **algorithm state** is the information the algorithm needs to continue. Its type is written `S`, and a value `s : S` is one possible state. For [Euclid](../Workshop/Algorithms/Euclid.lean#L9), `S` is `Nat × Nat`, a pair of natural numbers. After the first division, the next state is `(462, 147)`. That pair is enough to start the next division.

An **event** describes something that just happened in a form an observer can use. An event type specifies which reports are possible and what information each report contains. The generic code calls this type `E`. Each algorithm chooses its own event type. [Euclid’s event type](../Workshop/Algorithms/Euclid.lean#L3) is `EuclidEvent`, and the event `.division 1071 462 2 147` reports the dividend, divisor, quotient and remainder of the first division. The transcript needs those four numbers. The algorithm only needs its next pair.

### `AlgorithmStep S E` describes the outcome of one step

The step function has type `S → AlgorithmStep S E`. Read this as “give me the current state and I’ll tell you what happened.” [`AlgorithmStep S E`](../Workshop/Instrumentation/Basic.lean#L11) is an alias for `Option (S × E)`. Lean’s `×` makes a pair and `Option` allows that pair to be absent.

- `none` means the run has finished. There is no next state or event, so the runner keeps the current state and stops.
- `some (next, event)` supplies the next state and the report of what happened. [`AlgorithmStep.event next event`](../Workshop/Instrumentation/Basic.lean#L14), usually written `.event next event`, is a helper that constructs this outcome.

For the first division, the outcome contains `(462, 147)` and `.division 1071 462 2 147`. The runner uses the two parts for different jobs.

### `EventObserver E` describes how to keep a record

[`EventObserver E`](../Workshop/Instrumentation/Basic.lean#L3) is a Lean structure, a bundle of named fields. Given events of type `E`, the observer chooses what to remember and how to update it.

- `State : Type` chooses the type of the observer’s record. For a tally that type is `Nat`. For a transcript it is `List E`.
- `initial : State` supplies the record before any events, such as `0` or `[]`.
- `observe : State → E → State` takes the current record and one event and returns the updated record.

Here `o.State` means “the record type chosen by observer `o`.” Different observers can receive the same events and keep records of different types. The update function has access to its own record and the event fields. Its output goes back into the observer’s record.

The instrumentation module supplies three observers you can use for any event type.

- [`ignoreObserver`](../Workshop/Instrumentation/Basic.lean#L44) keeps `Unit`, a type with a single value. Every event leaves that value as it was.
- [`countObserver`](../Workshop/Instrumentation/Basic.lean#L49) keeps a natural number, starts at zero and adds one for every emitted event.
- [`traceObserver`](../Workshop/Instrumentation/Basic.lean#L54) keeps a list, starts empty and puts each new event at the front. The raw list is newest-first. `euclidTrace` reverses it to restore chronological order.

Euclid also defines observers specific to its division events. One collects quotients and another counts only divisions whose quotient is 1. Both can read the quotient field of the event. [Euclid’s specialised observers](../Workshop/Algorithms/Euclid.lean#L19)

### `runObserved` and `runPlain` repeat the step

[`runObserved`](../Workshop/Instrumentation/Basic.lean#L20) takes the step function, observer, step budget (*fuel*), starting algorithm state and starting record. Its result has type `S × o.State`, a pair consisting of the final algorithm state and the final record. Typically the starting record is `o.initial`. The loop follows this flow on a step that emits an event.

```text
current algorithm state ── step ──► next algorithm state and event
current observer record + event ── observe ──► updated observer record
```

[`runPlain`](../Workshop/Instrumentation/Basic.lean#L34) uses the same step function and budget. It follows each next algorithm state, discards the event and returns just the final algorithm state. Both runners stop when the step returns `none` or when fuel runs out. A final state at fuel exhaustion may be a partially processed state. The proof that Euclid’s chosen budget suffices is specific to Euclid.

## What Lean verifies

A `#eval` displays the result for one input. A theorem states a property for every input satisfying its assumptions, and Lean checks the proof of that statement. The first two subsections cover the three theorems in the generic instrumentation module. The last subsection explains the separate proof about Euclid’s GCD.

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

## A different example: summing a column with missing values

Suppose a column contains `4`, a missing entry, and `7`. You want the sum of the observed values and either a count of missing entries or a log of how the rows were handled. The algorithm takes each row in turn. It adds a present value to the sum and leaves the sum alone for a missing entry.

- The algorithm state `ColumnState` pairs the unread rows with the running sum. The starting state has all three rows and sum zero.
- `RowEvent` describes the outcome for a row. `.added 4` reports an included value and `.skipped` reports a missing entry. A skipped row still consumes one row and emits one event. An empty list of unread rows ends the run.
- The observer `countMissing` starts at zero and increments only on `.skipped`. The generic `traceObserver` keeps both event kinds.

The three steps give the event sequence `added 4, skipped, added 7` and the running sums `4, 4, 11`. The generic event count is **3** because every row emits an event. The missing-entry count is **1** because this observer only counts skipped rows. Replaying the chronological log through `countMissing.observe` also produces **1**.

This is a standalone example to try in a temporary Lean file in the workshop project. In the code, `some n` denotes a row with value `n`, and `none` in the list denotes a missing entry. The `none` returned by the step function has a different type and denotes that the whole run has finished.

```lean
import Workshop.Instrumentation.Proofs

namespace MissingRows

inductive RowEvent where
  | added (value : Nat)
  | skipped
  deriving Repr

abbrev ColumnState := List (Option Nat) × Nat

def step : ColumnState → AlgorithmStep ColumnState RowEvent
  | ([], _) => none
  | (some n :: rest, total) => .event (rest, total + n) (.added n)
  | (none :: rest, total) => .event (rest, total) .skipped

def countMissing : EventObserver RowEvent where
  State := Nat
  initial := 0
  observe count
    | .added _ => count
    | .skipped => count + 1

def start : ColumnState := ([some 4, none, some 7], 0)

#eval runPlain step 4 start                                       -- ([], 11)
#eval runObserved step countMissing 4 start countMissing.initial  -- (([], 11), 1)
#eval runObserved step (countObserver RowEvent) 4 start
  (countObserver RowEvent).initial                               -- (([], 11), 3)

def chronologicalLog : List RowEvent :=
  (runObserved step (traceObserver RowEvent) 4 start []).2.reverse

#eval chronologicalLog
#eval chronologicalLog.foldl countMissing.observe countMissing.initial  -- 1

example (fuel : Nat) (s : ColumnState) :
    (runObserved step countMissing fuel s countMissing.initial).1 =
      (runObserved step (traceObserver RowEvent) fuel s []).1 := by
  exact observerIndependent step countMissing (traceObserver RowEvent)
    fuel s countMissing.initial []

end MissingRows
```

The `.1` in the theorem selects the algorithm state from the observed result. The example proves that counting missing rows and collecting a trace leave exactly the same unread rows and running sum for any starting state and fuel. The `.2` used to build the log selects the observer state. The generic replay theorem also applies to this step function and the missing-entry counter. A proof that the final sum equals a separately specified sum of present values would require an additional argument about `step`, just as Euclid needs its own GCD proof.
