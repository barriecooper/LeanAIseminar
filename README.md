# Lean + AI workshop

A 50-minute introduction to Lean 4 for mathematics staff and postgraduate
researchers. We start with integer divisibility and use Mathlib to explore
arithmetic modulo 7. Then we reason about a recurrence by induction, experiment
with Collatz iterates, and collect observations from Euclid's division steps.

[![Open in Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/barriecooper/LeanAIseminar)

1. Click **Open in Codespaces**, then **Create codespace**. You need a GitHub
   account with available Codespaces quota. For a PR rehearsal, select the PR
   branch in the creation form.
2. Wait for setup to finish. Codespaces installs Lean and Mathlib automatically.
3. Open **[Workshop/Tutorial.lean](Workshop/Tutorial.lean)** if it has not opened
   automatically. Click the first `#check` or `#eval` lines to see output in Lean
   Infoview. Click inside a proof to see its goal. If needed, use **F1** →
   **Lean 4: Toggle Infoview**.
4. Work through that file in order. Change inputs to the calculations and try
   replacing the core `sorry` placeholders with proofs. Save the multiplication
   exercise, observer trace-fold section, and AI-assisted GCD proof for optional
   work. Lean warns about any remaining placeholders.

[Sample exercise solutions](Workshop/Solutions.lean) are available when you want
to compare approaches. The full GCD correctness proof is in
[Workshop/Algorithms/Euclid.lean](Workshop/Algorithms/Euclid.lean).

## Workshop setup and validation

Rehearse with a fresh Codespace before the workshop. The creation log reports
time for Lean setup, dependency checkout and Mathlib cache retrieval, and the
workshop build. Lean and Mathlib are pinned to v4.24.0, and the committed Lake
manifest locks transitive dependencies.

Codespaces and the PR workflow both run `bash .devcontainer/setup.sh`. It
fetches precompiled artifacts for `Mathlib.Data.ZMod.Basic` and its dependencies,
then checks that Lake can use them before building the workshop. If setup
fails, check the creation log and connectivity to GitHub and
`mathlib4.lean-cache.cloud`, then rerun the script. Maintainers can try the
Azure mirror with `USE_FRO_CACHE=0 bash .devcontainer/setup.sh`. To allow a
potentially lengthy source build if cache setup fails, explicitly run
`WORKSHOP_ALLOW_SOURCE_BUILD=1 bash .devcontainer/setup.sh`.

### Optional Codespaces prebuild

In the repository's **Settings → Codespaces**, a maintainer can select **Set
up prebuild**, choose the workshop branch and devcontainer configuration, and
select the regions attendees will use. Use an update trigger that covers the
workshop revision. Wait for the prebuild to finish, then open a fresh browser
Codespace on that branch in a configured region and check that Infoview opens
on the tutorial. The prebuild runs the setup command before attendees connect.

### Maintainer checks

The PR workflow checks the default build and runs the full worksheet separately.
In a configured Codespace, maintainers can run:

```bash
lake build
lake env lean Workshop/Tutorial.lean
```

The default build checks the library and sample solutions. The worksheet check
also prints the `#eval` outputs and should emit exactly four intentional
`sorry` warnings.
