# Validation report — 16 November 2026

## Executed in the implementation environment
- Lean 4.24.0, commit 797c613; Mathlib locked revision
  f897ebcf72cd16f89ab4577d0c826cd14afaafc7 (v4.24.0).
- `lake build`: passed, 1128 jobs including all complete workshop modules,
  Solutions/Core and Solutions/Euclid, and regression assertions. Workshop and
  Solutions builds use warnings as errors, rejecting accidental sorry holes.
- Every `Exercises/*.lean` compiled independently: no errors, ten intentional
  sorry warnings. Every exercise hole has a compiled completion in Solutions.
- Ran `exact?` on both search tasks: suggested `Nat.dvd_trans hab hbc` and
  `Nat.dvd_gcd ha hb`. Printed Nat.instDvd: ∃ c, b = a*c.
- Ran `.devcontainer/setup.sh` successfully with the environment workarounds
  below; it reached “Workshop ready”. SHA-256 checks confirmed setup preserved
  lean-toolchain, lakefile.toml and lake-manifest.json unchanged.
- `bash -n .devcontainer/setup.sh` and `git diff --check`: passed.

Displayed output and checked assertions agree:

```text
FirstSteps: 12
1071 = 2*462 + 147
462 = 3*147 + 21
147 = 7*21 + 0
trace result: 21
extended 1071 462: (21, -3, 7)
Mathlib (gcd, gcdA, gcdB): (21, -3, 7)
extended 3 7: (1, -2, 1)
quotients: [2, 3, 7]
continued fraction: mkRat 51 22
```

The general observer-result and gcd-specification theorems compile. Concrete
regressions also cover zero and reversed inputs. The custom extended algorithm
has concrete checks only; Mathlib supplies the general Bézout theorem. Continued
fraction reconstruction is a concrete identity, not a universal theorem.

## Reproduce in a configured Codespace (maintainer commands)

```bash
bash .devcontainer/setup.sh
lake build
for exercise in Exercises/*.lean; do
  lake env lean "$exercise" || exit 1
done
lake env lean Workshop/Euclid.lean
lake env lean Workshop/ContinuedFractions.lean
```

CI runs setup/build, checks dependency pins, then checks exercise scaffolding on
pull requests and manual dispatch. It has no push trigger. Remote CI status is
reported on the PR separately from these local results.

## Environment limitations and manual checks
This managed environment's Elan compiler download and Azure Mathlib cache requests
received proxy 403 responses. For validation only, downloaded the official Lean
4.24.0 release asset directly from GitHub and linked it with Elan. Used Mathlib's
supported `USE_FRO_CACHE=1` alternate cache and a writable `MATHLIB_CACHE_DIR`.
These workarounds do not change repository toolchain or dependency pins. Normal
setup retains its existing explicit cache-failure fallback to source compilation.

No fresh GitHub Codespace, browser Lean editor/Infoview interaction, prebuild,
or timed audience rehearsal was available in this environment. Command-line
compilation and #eval do not establish those checks. Before delivery, follow
INSTRUCTOR.md: launch the PR branch in a fresh Codespace, verify extension/goals,
make the witness edit, try the theorem search in the editor, run the traces,
and time both startup and the 30-minute active route. The historical four-minute
startup and five-minute first-proof target have not been remeasured here.

## Review follow-up: two observers and pacing
Added countSteps alongside trace, with adjacent participant evaluations on the
same inputs. Compiled trace_result and countSteps_result each apply the universal
observe_result theorem; a further checked example shows their answers agree for
all inputs. Exact regressions check countSteps 1071 462 = (21, 3) and that the
trace has three rows (its gcd 21 and row contents remain checked separately).

Re-ran `lake build`: passed (1128 jobs), including all sample completions in
Solutions. Rechecked all three exercise files: no errors, only the same ten
intentional sorry warnings. The minimum pre-Euclid route is now the transitivity
search and two finite modular calculations; the repeated witness is explicitly
skippable, and further searches, general casts and inverses are optional.
Hosted Codespaces/editor/Infoview and timed novice rehearsal remain manual
acceptance checks to perform after these edits; they have not been claimed here.
