# Lean + AI: witnesses, algorithms and mathematical observation

## Audience and aim
50 minutes for mathematics staff and postgraduate researchers, pure and applied,
with no assumed Lean or programming experience. Use GitHub Codespaces entirely
in the browser. Launch before the session: the previous cold start was about four
minutes, but added imports can change that. Organisers should configure prebuilds.
The first success target is five minutes after setup, not five minutes including it.

The narrative is divisibility as a witness, Mathlib as reusable mathematics,
Euclid as an exact algorithm, observation as a separately instrumented process,
and Bézout as the bridge to inverses. Continued fractions provide one optional
mathematical destination. Repeating decimals are deliberately deferred to avoid
splitting the available time across two extensions.

## Run of show
| Time | Activity | Evidence and purpose |
| --- | --- | --- |
| 0–6 | Instructor: FirstSteps, witness for 3 ∣ 12 | Infoview goal; definition versus supplied witness |
| 6–12 | Instructor: theorem signatures, gcd, ZMod | Library reuse, casts, ring versus field |
| 12–20 | Instructor: Euclid trace and Bézout | Computation, observer theorem, inverse motivation |
| 20–28 | Participants: Exercises/01 and 02 | First witness, actual exact? search, change modulus |
| 28–42 | Participants: Exercises/03 | Vary inputs, predict trace, complete one theorem |
| 42–50 | Participants: optional continued fractions and debrief | Conjecture versus proved identity; AI reflection |

Keep the instructor demonstration to 20 minutes. The 30-minute active route
requires neither implementing recursion nor proving extended Euclid correctness.
Offer participants a choice of finite arithmetic or library-reuse theorem in 03.
The search and gcd stretch tasks can be skipped if needed, except the core
transitivity search, which participants should actually attempt.

## Mathematical boundaries
Divisibility on ℕ is ∃ c, b = a*c, checked definitionally in Arithmetic.lean.
Casts into ZMod n translate divisibility to zero. ZMod 7 is a field; ZMod 6 has
nonzero zero divisors. Units correspond to coprimality for natural casts.
Euclid terminates because a % b < b for positive b. Every observer returns the
same result as unobserved Euclid, and that result is Nat.gcd, for all inputs
including zero. These are checked theorems, not empirical checks on sample pairs.
Mathlib supplies the general Bézout identity and extended coefficients. The small
custom extended implementation is an optional reading aid with concrete checks;
we do not claim a general correctness theorem for it. Extended coefficient-state
tracing is deferred; division rows are the observer's deliberately minimal data.
The continued-fraction reconstruction is proved for the concrete [2;3,7] example,
not for all quotient traces. Rational inverse at zero is total in Lean, so a
future general theorem must state suitable hypotheses.

## AI and assessment
Ask for explanations of goals, one hint, a library search strategy, or a proposed
generalisation. Test and repair suggested code. Ask “What exactly did Lean prove?”
at each transition. Distinguish a definition proof, a library theorem, an exact
computation, a universally quantified algorithm theorem, and an observation.
Use Solutions only after trying; exercise holes are not verified mathematics.
See INSTRUCTOR.md for delivery and VALIDATION.md for reproducible checks.
