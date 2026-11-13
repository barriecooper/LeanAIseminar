# Workshop brief — Lean + AI: from iteration to bifurcation

## Audience and constraints
- Mathematics academic staff and PGRs, pure and applied; most are new to Lean.
- 50 minutes total; around **30 minutes hands-on** with Lean/AI.
- Browser-only: GitHub repository with launchable Codespace; no terminal setup by participants.
- Aim: a joyful mathematical discovery, **not** a survey of Lean syntax.

## Candidate run of show
- 0–5 min: striking logistic-map bifurcation diagram and research question.
- 5–12 min: what Lean checks; one tiny live proof, show goals.
- 12–20 min: numerical orbit and exact period-two theorem demonstrated.
- 20–30 min hands-on: modify logistic-map parameter and starting point, observe long-term behaviour.
- 30–40 min hands-on: prove an exact two-cycle and/or polynomial factorisation, with AI guidance.
- 40–50 min hands-on/debrief: optional challenge (invariant interval, existence of 2-cycles, distinguish existence from attraction), AI reflection.

## Core mathematical material
Define the logistic map as `f r x = r*x*(1-x)`. Use rational arithmetic for exact orbit verification and real arithmetic for identities/inequalities. Separate numerical plots (e.g. Python or Float) clearly from formally proved statements.

Include easy, intermediate and adventurous options:
1. Easy: `r=7/2`, exact cycle `3/7 ↦ 6/7 ↦ 3/7`; prove with `norm_num`.
2. Intermediate: prove `f r (f r x) - x = (f r x - x) * (r^2*x^2 - r*(r+1)*x + (r+1))` by `ring`. Use the quadratic and its discriminant to discuss emergence at `r=3`.
3. Stretch: prove `f_r([0,1]) ⊆ [0,1]` for `0 ≤ r ≤ 4`; derive nontrivial cycle solutions for `r>3`; explore local stability only if time allows.
4. Optional exploratory directions: tent map, sensitivity to initial conditions, periodic windows, period-doubling at further parameters. Do not claim formal proofs of chaos or a period-doubling cascade unless actually established.

## Participant experience
- Exercises are in editable, concise Lean files with explanatory mathematical prose as comments.
- Every challenge provides a statement, hints, and an optional AI prompt (for example: “Explain the current Lean goal and suggest one next tactic; don't finish the proof”).
- Keep working code compiling wherever practical, e.g. use `example ... := by` with guided placeholders only in exercise files.
- Avoid introducing a large tactic inventory. Primary choices: `rfl`, `rw`, `norm_num`, `ring`, `constructor`, `nlinarith`, as needed. Do not require understanding advanced Mathlib structure.
- Provide complete checked solutions separately; avoid hiding proofs behind opaque tactics when an explanation would help.
- If visualisation is included, provide a static pre-generated bifurcation diagram in the repo so the session does not depend on installing Python plotting libraries or a Jupyter kernel.

## AI and formal proof
- Encourage exploratory prompts, conjectures and tactic explanations rather than copy-paste-only completion.
- Contrast observing a pattern, testing many examples, verifying an exact instance, and proving a general theorem.
- Remind participants Lean verifies the formal proposition given to it, not necessarily the intended informal claim.
- AI outputs may contain bugs or incorrect mathematical reasoning: test, repair, and explain.

## Delivery and acceptance
- README should have a **single obvious “Open in Codespaces” path** and workshop entrypoint.
- Codespace should have a short, reliable cold start, ideally using a prebuild.
- Have one instructor-tested path that fits 30 minutes, with stretch goals for fast learners.
- Check all formal claims with the pinned compiler and test plots independently.
- Avoid fragile internet dependencies at workshop time beyond GitHub/Codespaces availability.
