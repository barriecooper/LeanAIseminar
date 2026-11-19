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

Allow several minutes for a cold start and rehearse with a fresh Codespace.
Organisers can configure a Codespaces prebuild for the workshop branch and
region. If setup fails, open the creation log and rerun `bash .devcontainer/setup.sh` after fixing the reported problem.

Lean and Mathlib are pinned to v4.24.0, and the committed Lake manifest locks
transitive dependencies. The PR workflow checks the default build and runs the
full worksheet separately. In a configured Codespace, maintainers can run:

```bash
lake build
lake env lean Workshop/Tutorial.lean
```

The default build checks the library and sample solutions. The worksheet check
also prints the `#eval` outputs and should emit exactly five intentional
`sorry` warnings.
