# AGENTS.md — LeanAIseminar

Read `WORKSHOP_BRIEF.md` before making substantive changes. This repository is
a 50-minute browser-only introduction to Lean 4 and AI for mathematics staff and
postgraduate researchers with no prior Lean experience.

## Teaching sequence

Keep `Workshop/Tutorial.lean` as the single entrypoint. Follow the worksheet
order of integer divisibility, recursion and induction, Collatz, and observable
Euclid. Include editable examples, short explanations and optional AI prompts.
Use Lean Infoview to inspect types, values and proof goals. Keep the distinction
between testing examples and proving a general statement clear.

Keep generic event runners and their proofs in `Workshop/Instrumentation/`.
Keep Euclid's event vocabulary, transition and observers in
`Workshop/Algorithms/Euclid.lean`. Observer state may differ in type and must
leave the arithmetic result unchanged. Explain that the count measures emitted
events and that reversing the accumulated trace restores chronological order.

## Build and validation

Preserve the pinned Lean toolchain, Mathlib version and committed Lake manifest.
The devcontainer installs dependencies automatically, tries the Mathlib cache
and reports setup failures. Keep the README instructions browser-only for
participants and point both the README and Codespaces to the tutorial.

The default `lake build` checks the library and sample solutions. Allow
intentional student `sorry` placeholders only in the tutorial and validate that
file with `lake env lean Workshop/Tutorial.lean`. Checked proofs must be complete
and use no trust bypasses. Verify the documented evaluation output. Keep PRs
focused and include build results. Rehearse the participant workflow in a fresh
Codespace before delivery.
