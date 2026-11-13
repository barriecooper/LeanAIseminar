# Lean + AI workshop

A browser-based introduction to Lean 4 and Mathlib for mathematics staff and
postgraduate researchers. This first infrastructure PR provides a working smoke
test; the full workshop exercises will follow separately.

[![Open in Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/barriecooper/LeanAIseminar)

1. Click **Open in Codespaces**, then **Create codespace** (a GitHub account and
   available Codespaces quota are required). When reviewing a PR, select its branch
   in the creation form.
2. Wait for container setup to finish. Lean and Mathlib are installed automatically;
   you do not need to run terminal commands or install anything on your computer.
3. Open **[Workshop/FirstSteps.lean](Workshop/FirstSteps.lean)** in the file explorer
   if it has not opened automatically. Click the `#eval` lines: Lean Infoview should
   show `5` and `mkRat 1 2` (the exact rational number 1/2). Click just before
   `norm_num` or `ring` to see a proof goal;
   click after the tactic to see it solved. If needed, use the command palette
   (**F1**) → **Lean 4: Toggle Infoview**.
4. Try changing `2 + 3`, then change it back. The rational example and the two
   proofs should have no error squiggles.

Allow several minutes for a cold start; download speed and machine size matter,
so the five-minute first-success target still needs timing in a fresh Codespace.
If Mathlib's cache service is unavailable, setup prints a warning and compiles
from source, which can take substantially longer. Setup only reports **Workshop
ready** after `lake build` succeeds. A failed setup is not a ready environment:
open the creation log, fix the reported problem, then rerun
`bash .devcontainer/setup.sh` in the Codespace terminal (or rebuild the container).

For organisers: configure a **Codespaces prebuild** in repository Settings →
Codespaces for the workshop branch and region before the session. The
`onCreateCommand` installs dependencies, fetches the starter's Mathlib caches and
builds during prebuild creation; `waitFor` prevents attaching before it finishes.
Test a fresh participant Codespace shortly before delivery. Codespaces and initial
dependency/cache downloads require internet access.

## Reproducibility and validation

Lean **4.24.0** and Mathlib **v4.24.0** are paired. `lean-toolchain` pins the
compiler; `lakefile.toml` selects Mathlib; the committed `lake-manifest.json` locks
Mathlib and every transitive dependency to a Git commit. Participant setup uses
that lockfile and never runs `lake update`. Elan's bootstrap release is pinned to
4.1.2. The devcontainer uses Ubuntu 24.04 and the `leanprover.lean4` extension.

In a configured Codespace, `lake build` checks the default `Workshop` library,
including `Workshop/FirstSteps.lean` through `Workshop.lean`. All current examples
are complete, with no `sorry`. Add future checked modules to this import tree;
keep deliberately incomplete exercises separate from checked solutions.

Maintainer checks (also useful when recovering setup):

```bash
bash .devcontainer/setup.sh  # install, retrieve caches, build; safe to rerun
lake env lean Workshop/FirstSteps.lean  # display #eval output explicitly
lake clean workshop
lake build                 # clean rebuild of workshop targets, reusing Mathlib
```

For a fully fresh dependency test, use a new checkout without `.lake/` and run the
setup script. GitHub Actions does this on pushes and pull requests and checks that
setup leaves the pinned project files unchanged. To upgrade, deliberately update
the Lean/Mathlib pair, run `lake update`, commit the new lockfile and retest a fresh
Codespace. Do not update dependencies during a workshop.
