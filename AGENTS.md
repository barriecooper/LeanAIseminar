# AGENTS.md — LeanAIseminar

## Purpose
Build a **50-minute introductory Lean 4 + AI workshop for mathematics staff and postgraduate researchers**, representing pure and applied mathematics. Allow ~20 minutes of demonstration and ~30 minutes of hands-on experimentation. The main mathematical theme is **discrete dynamical systems, particularly the logistic map, period-two orbits and the first period-doubling bifurcation**.

Participants have no Lean experience and may have no programming experience. All activities must be usable **entirely in a browser through GitHub Codespaces**. AI is a useful mathematical collaborator, not an authority: Lean should check formal claims.

Read `WORKSHOP_BRIEF.md` before making substantive changes.

## Priorities, in order
1. **Reliability:** a fresh Codespace builds and opens a working Lean exercise with Mathlib.
2. **Low friction:** first success in 5 minutes, no installation instructions, no prerequisites beyond GitHub and access to Codespaces.
3. **Mathematical interest:** meaningful experimentation, exact periodic orbits, parameter variation and a verifiable factorisation underlying period doubling.
4. **Readable Lean:** short definitions, clear explanatory comments, minimal tactics.
5. **Reproducibility:** pin Lean/Mathlib via project files; no floating dependency references for participant builds.

## Engineering conventions
- Use the standard Lean 4 / Lake / Mathlib project layout. Prefer a version-compatible Mathlib project generated using official tooling, then **commit** `lean-toolchain`, `lakefile.toml` (or the officially supported equivalent) and `lake-manifest.json`.
- Configure `.devcontainer/devcontainer.json` with Lean 4 VS Code extension `leanprover.lean4`, a suitable Codespaces image, and an automated reproducible setup. Document startup time and any prebuild recommendations; do not require manually installing Lean.
- Ensure the devcontainer **does not silently conceal setup errors**. Prefer cached Mathlib build artifacts when available (e.g., `lake exe cache get`), and fall back gracefully if needed.
- Add GitHub Actions CI that runs `lake build` against the pinned project. Ideally verify **solution** files as well as the shared starter code.
- Provide a tiny compilable smoke test immediately, then a reproducible way to validate all example/proof files. If exercise files contain `sorry` or intentionally incomplete proofs, distinguish them from the CI-checked solutions (do not count exercise `sorry` as verified).
- Keep the participant working area uncluttered; a short README should link directly to the first exercise.
- Keep generated build outputs (`.lake/`, etc.) out of git. Do not add unnecessary Python dependencies or heavyweight tooling merely to draw plots.
- No `axiom`, `native_decide` for genuinely analytic statements, `unsafe` tricks, `admit`, or unsound shortcuts. In checked solution files use no `sorry`.
- For finite rational arithmetic, `norm_num` is appropriate; for polynomial identities, `ring`; for inequalities `nlinarith` if suitable. Prefer mathematical arguments to giant automation when the aim is explanation.
- Numerical `Float` or Python experiments are **illustrations**, not proofs of period doubling or chaos. Separate calculations from exact statements over `ℚ`/`ℝ`.
- Explain subtle mathematical claims precisely: existence of a two-cycle is not the same as stability; a bifurcation plot is not a theorem about chaos.
- Keep changes small, ideally one focused PR at a time; provide tests/build results in PR descriptions. Do not modify unrelated content.

## Mathematical sanity checks
For `f r x = r*x*(1-x)`:
- At `r = 7/2`: `3/7 → 6/7 → 3/7` is an **exact** rational two-cycle.
- Fixed points solve `f r x = x`; when `r ≠ 0`, the nonzero one is `1 - 1/r`.
- Identity: `f r (f r x) - x = (f r x - x) * (r^2*x^2 - r*(r+1)*x + (r+1))`.
- The quadratic factor's discriminant is `r^2*(r+1)*(r-3)`. For `r > 3`, two distinct real period-two candidates appear, and a complete argument should show they aren't fixed points.
- The first nonzero fixed point loses local stability at `r=3`; the factorisation alone does **not** prove attracting behaviour.
If any claim or code sample fails validation, correct it rather than papering over it.

## Workflow with Codex
Start by setting up and validating the **environment alone** on a branch/PR: pinned Lean/Mathlib, Codespaces configuration, CI, README quick start and one compiled smoke-test theorem. Open a fresh Codespace and prove that Mathlib and the Lean editor work before adding the full workshop.
Then propose the pedagogical structure, implement exercises, checked solutions, and optional plotting in separate small PRs. Ask for reviewer feedback on maths and audience difficulty rather than expanding scope.

## Definition of done for the first setup PR
A fresh Codespace opens with Lean syntax highlighting and goals, `lake build` passes, a `#eval` example runs, a Mathlib tactic proof compiles, README tells a newcomer exactly which file to open, and GitHub Actions shows a successful build.
