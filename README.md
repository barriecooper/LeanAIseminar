# Lean + AI: from iteration to bifurcation

One simple rule, surprising orbits — and exact claims you can check yourself.
This 50-minute workshop is for mathematics staff and postgraduate researchers
new to Lean: a 20-minute demonstration followed by the 30-minute exploration below.
Everything runs in your browser; no programming experience or local installation needed.

[![Open in Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/barriecooper/LeanAIseminar)

1. Click **Open in Codespaces**, then **Create codespace**. You need a GitHub
   account and available Codespaces quota. For a PR preview, select its branch.
2. Wait for setup to finish and say **Workshop ready**. This can take several
   minutes on a cold start; the activity timings start **after** setup.
3. Open **[Exercises/01TwoCycle.lean](Exercises/01TwoCycle.lean)** in the editor.
   Use **F1 → Lean 4: Toggle Infoview** if the goal panel is missing. Click just
   after the first `by`, replace `sorry` with `norm_num [logistic]`, and click
   after the tactic. Infoview should say **No goals**. You've checked an exact
   step of a period-two orbit!

`sorry` means an unfinished exercise, not a proof. Remove it to complete a task;
a checked proof has no sorry warning or error. You can experiment and undo freely.
The setup smoke test is [Workshop/FirstSteps.lean](Workshop/FirstSteps.lean).

## Open the numerical playground

In the Codespace browser editor, use **F1 → Tasks: Run Task → Workshop: open
numerical explorer**. This starts a small server using the container's Python;
no packages are installed. Port **8000**, labelled **Logistic-map explorer**, should
open in a browser tab. If it doesn't, open the editor's **Ports** panel, find 8000,
and click its **Open in Browser** globe icon. Keep the port visibility **Private**.
If the Ports panel is hidden, use **F1 → Ports: Focus on Ports View**.

The page at the forwarded port's root shows an orbit and bifurcation diagram.
Try **2.5 → 3.2 → 3.5 → 3.9**, then change the initial value and the number of
transient iterations to skip. All controls work with a keyboard. A text summary
accompanies the orbit, and the page includes a numerical/proof distinction.

If needed, the same server can be started in the Codespace terminal:

```bash
python3 -m http.server 8000 --bind 0.0.0.0 --directory visualisation
```

Leave that terminal running. If the port is already in use, reuse its existing
server; **Tasks: Terminate Task** stops the task. No outside CDN or plotting library
is used. If scripting is unavailable, open the page's **static fallback diagram**
([repository copy](visualisation/fallback.svg), fixed settings). You can also
save the whole `visualisation/` folder and open `index.html` locally offline.

## Your 30-minute exploration

| Minutes | Try this | Question to discuss |
| --- | --- | --- |
| 0–5 | Complete the first goal in [01TwoCycle](Exercises/01TwoCycle.lean); inspect Infoview before and after the tactic. | What proposition did Lean actually check? |
| 5–12 | Open the playground; try the four presets with x₀ = 0.2. Change the transient, then try x₀ = 0. | Do the pictures depend on the starting point or on how long you wait? |
| 12–17 | Finish the return step and distinctness in 01TwoCycle. In the plot, set r = 3.5, x₀ = 0.42857142857142855 and transient = 0. | How does a rounded numerical illustration differ from the exact rational two-cycle? |
| 17–25 | Open [02Factorisation](Exercises/02Factorisation.lean). Unfold the helper, inspect the new goal, then use `ring`. | Which factor describes fixed points? What would make another root a genuine two-cycle? |
| 25–28 | Revisit a plot prediction, or begin the optional [03Interval](Exercises/03Interval.lean) with its staged hints. | Why should [0,1] map into itself for 0 ≤ r ≤ 4? |
| 28–30 | Compare with [checked solutions](Workshop/Solutions.lean); explain one result to a neighbour. | Which claims are now proved, and which remain observations or questions? |

The helpers are already written. The core tasks use only `norm_num [logistic]`,
`unfold logistic` and `ring`; the stretch task is optional and can be finished later.
To type symbols yourself, Lean accepts `\Q` for ℚ and `\R` for ℝ, followed by a space.

Use AI as a collaborator, and check its suggestions in Lean. For example:

- “Explain my current Lean goal and suggest one next tactic. Why does it apply?”
- “I predict two alternating values from this plot. What exact statement could
  test that conjecture, and what would still be unproved?”
- “This tactic failed. Explain the error and help me debug one step without
  replacing the whole proof.”

## What the mathematics says

The rule is `f r x = r*x*(1-x)`. Over ℚ, **3/7 → 6/7 → 3/7 at r = 7/2**,
with distinct points. Over ℝ, Lean checks the identity

```text
f r (f r x) - x = (f r x - x) * (r²x² - r(r+1)x + (r+1)).
```

For discussion, the quadratic discriminant is `r²(r+1)(r−3)`, positive for r > 3.
At r = 3 its repeated root is 2/3, also a fixed point. To get a genuine two-cycle
from quadratic roots, one must also exclude fixed points. The identity alone
proves neither stability nor attracting behaviour. The discriminant and this
root discussion are explanatory mathematics, not additional checked theorems here.
At r = 3.5 the exact two-cycle exists even though nearby numerical orbits can
approach a four-cycle; existence and attraction are different questions.

The playground uses finite, floating-point calculations. A short irregular orbit
does not establish chaos; neither the plot nor these Lean tasks proves an infinite
period-doubling cascade. The checked stretch solution proves interval invariance.

## For instructors and maintainers

Before delivery, follow the [fresh-Codespace checklist and validation notes](docs/VALIDATION.md).
Allow several minutes for cold setup; use a **Codespaces prebuild** for the workshop
branch and region (repository Settings → Codespaces). Setup caches only required
Mathlib imports. If its cache service fails, it warns and builds from source,
which takes substantially longer. It prints **Workshop ready** only after success.
On failure inspect the creation log, correct the reported issue, and rerun
`bash .devcontainer/setup.sh` or rebuild the container.

Lean **4.24.0**, Mathlib **v4.24.0**, and every transitive Git revision remain pinned
by `lean-toolchain`, `lakefile.toml`, and `lake-manifest.json`. Setup never runs
`lake update`. Elan bootstrap is pinned to 4.1.2. CI runs on **pull requests and
manual workflow_dispatch only**, with no push trigger on main.

```bash
lake build                         # smoke test + all checked solutions
lake env lean Workshop/FirstSteps.lean  # explicit #eval outputs: 5 and mkRat 1 2
lake clean workshop && lake build  # rebuild workshop, reuse Mathlib artifacts
node --test tests/explorer.test.cjs # numerical implementation checks (maintainers)
node scripts/generate-fallback.cjs # regenerate static SVG, no dependencies
```

`Workshop.lean` imports every verified solution. `Exercises/` is separate from
that import tree and intentionally contains `sorry`. Do not count its holes as
verified. The optional browser test and screenshot are described in the validation
notes. Please review the mathematical explanations and whether the difficulty
and pacing fit first-time users.
