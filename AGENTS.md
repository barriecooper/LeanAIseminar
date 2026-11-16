# AGENTS.md — LeanAIseminar

## Purpose and priorities
Read WORKSHOP_BRIEF.md before substantive changes. Build a 50-minute browser-only
Lean + AI seminar for mathematics staff and PGRs, almost all new to Lean:
divisibility → Mathlib/gcd → Euclid and observation → Bézout → modular inverses.
Continued fractions are optional. Prioritise a reliable Codespace, a first proof
within five minutes after setup, mathematical interest, readable scaffolding,
and reproducibility. Participants need no terminal commands or local software.

## Engineering and mathematics
- Preserve Lean 4.24.0, Mathlib v4.24.0 and the committed dependency lockfile.
  Never run lake update during workshop setup. Keep .lake out of git.
- Keep the Codespaces Lean extension, automated setup, visible failures and
  graceful cache fallback. Update the cache import list when adding imports.
- Preserve PR-only/manual-dispatch Actions; do not add push-triggered CI on main.
- `lake build` must include every complete module and Solutions file via
  Workshop.lean. Exercises contain intentional sorry holes and are excluded.
  Compile every suggested completion in Solutions. Check displayed computations
  with assertions in Workshop/Validation.lean, not just informal output comments.
- No sorry, admit, custom axioms, unsafe or trust bypasses in checked code.
  Use Mathlib APIs verified in the pinned version; prefer library reuse over
  recreating number theory. `decide` is suitable for finite exact examples.
- Separate proof from definitions, library reuse, computation, algorithm
  correctness and unproved observations. Casts and types must be explicit enough
  for a mathematician to read. ZMod n is not always a field; nonzero does not
  imply invertible for composite n. Coprimality gives a unit.
- Keep the observer interface small. Prove that observers preserve the algorithm
  result and that the result agrees with Nat.gcd. Explain decreasing remainders.
  Do not describe a custom extended algorithm as generally verified unless it is.
- Sanity checks: 1071 = 2*462+147, 462 = 3*147+21, 147 = 7*21;
  gcd = 21 = -3*1071+7*462, quotients [2;3,7] = 51/22.
  For 3 and 7, 1 = -2*3+7; the inverse of 3 modulo 7 is 5.
- Keep the required route feasible in 30 active minutes. No recursive programming
  required of students; use Infoview and #eval, no extra server or large UI.
- AI prompts should invite hints, lemma discovery, debugging and generalisations.
  Lean checks the proposition supplied, not the intended informal mathematics.

## Review and delivery
Start from main. Keep the scope focused; do not build on the unmerged experiment
in PR #6. PRs reference issues with `Refs #N`, not automatic closure keywords.
Include actual build evidence and distinguish manual Codespaces checks performed
from checks still needed. Ask reviewers for feedback on maths, timing and the
in-browser experience; do not claim an unperformed rehearsal or editor check.
