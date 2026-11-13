import Workshop.Logistic

/-!
FROM AN EXACT EXAMPLE TO A GENERAL IDENTITY · about 8 minutes

Click after `by` to inspect the goal. Here r and x are arbitrary REAL numbers.
Replace `sorry` with two lines: first `unfold logistic`, then `ring`.
Inspect the goal between the lines: the first exposes the polynomial;
the second checks its algebra. Neither tactic samples numerical values.
-/
namespace Workshop.Exercises.Factorisation
open Workshop

example (r x : ℝ) :
    logistic r (logistic r x) - x =
      (logistic r x - x) * (r^2*x^2 - r*(r+1)*x + (r+1)) := by
  sorry

/- Hints, in order:
1. `unfold logistic` replaces every occurrence by r*x*(1-x).
2. `ring` proves polynomial identities by exact algebra.
3. A fixed point makes the first factor zero. Other period-two candidates
   come from the quadratic factor, and must be shown NOT to be fixed points.

Mathematical discussion (not additional formal theorems in this file):
The quadratic discriminant is r^2*(r+1)*(r-3). For r>3 it is positive.
At r=3 the quadratic has the double root x=2/3, also a fixed point.
The factorisation alone does not prove stability or attracting behaviour.
It does not prove chaos or an infinite period-doubling cascade.

AI prompt: “Explain how this factorisation separates fixed points from
possible two-cycles. Which extra claims would need proofs?”

Optional: Exercises/03Interval.lean. Checked answers: Workshop/Solutions.lean.
-/
end Workshop.Exercises.Factorisation
