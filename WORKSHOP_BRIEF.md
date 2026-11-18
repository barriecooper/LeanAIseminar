# Workshop brief — Lean + AI

A 50-minute browser-only workshop for mathematics staff and postgraduate
researchers. No prior Lean or programming experience is assumed. Allow about
20 minutes of demonstration and 30 minutes of participant work.

Use [Workshop/Tutorial.lean](Workshop/Tutorial.lean) throughout.

| Time | Activity |
| --- | --- |
| 0–8 min | Open Lean Infoview, inspect integer operations with `#check`, and compare integer and rational division with `#eval`. |
| 8–15 min | Prove divisibility with `grind`, then unpack and construct witnesses in transitivity. |
| 15–20 min | Evaluate the recurrence and walk through the proof of evenness by induction. |
| 20–30 min | Try the divisibility and recurrence exercises. Ask AI to explain a current goal or suggest a next tactic, and check it in Lean. |
| 30–40 min | Compare Collatz iterates for different starting points. Try proving the modulo-four statement. |
| 40–50 min | Compare Euclid's count, trace and quotients on a new pair. Discuss what observer independence guarantees. |

The Collatz output illustrates particular orbits. The modulo-four exercise proves
a one-step property. Euclid's trace records the divisions and its quotients
give the continued fraction for the running example. The observer independence
theorem says changing the observer preserves the arithmetic result.

Before delivery, time the setup and activities in a fresh Codespace. Confirm
that Infoview displays evaluations and goals and that the two student
placeholders appear as warnings.
