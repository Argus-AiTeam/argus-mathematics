# CM pinned-kernel evidence assessment

**Unit:** `cm-kernel`. **Assessment:** the exact target replay is
**unverified**, not a proved theorem and not a refuted mathematical claim.
The existing evidence is source acquisition, cache work and an incomplete
build. The fresh bounded import diagnostic did not elaborate the target.
Native independent acceptance remains pending.

## Exact object and version

The old Argus draft is Campaign 9000032's
`research/cm_dependency_audit/report.tex`, Section 6, its `verify.py`,
source/dependency manifests, compiler journal, acquisition/build/cache
outputs, receipts and `lean/statement_fidelity.md`. The ledger claim is
`CM-KERNEL` v1. The source theorem is OpenAI's

```text
OAI.AlgebraicGeometry.HodgeConjecture.MainSolution.hodge_conjecture_for_cm_abelian_varieties
```

at recorded commit `4eaee87548250b2682affda7d05d947c05554bae`.
Its source-written type is assessed separately in
`../cm-applicability/report.md`. It is not a local Lean formalization of
the AG/DS reductions or their all-powers consequences.

The source declares `leanprover/lean4:v4.34.1`. Both its upstream
`lean/lake-manifest.json` and the old dependency manifest name Mathlib
`d13f23b723b8a846827a245b89c10fc7d3f11612`.
A fresh direct binary probe returned:

```text
Lean (version 4.34.1, x86_64-unknown-linux-gnu, commit 5045d0056413266e57c625dcd7c365b10e377c52, Release)
```

No toolchain installation, Lake workspace creation, dependency rebuild,
source patch, Git operation or substitution of the host's 4.31.0 Mathlib
environment was performed.

## What the inspected verifier would actually certify

The whole old `verify.py` was read before any diagnostic was executed.
It requires all of the following, rather than accepting a successful
cache download:

1. The source manifest's exact reachable acyclic import closure, source
   digests and actual import lists.
2. A successful complete build covering every local module, with
   source-bound compiler-journal records and matching compiled objects.
3. An actual successful, hole-free native `lean/lean_check.json`, bound
   to `lean/Main.lean` and its fidelity document.
4. The source's declared dependency pins and actual compiler version.
5. A fresh trust-zero replay, an elaborated target statement and
   compiler-produced transitive axiom lists for both the published target
   and the local replay declaration. Only `propext`, `Classical.choice`
   and `Quot.sound` are allowed by that verifier.

Only then does its `main()` write `exact_certificate.json`.
Even that certificate explicitly excludes mechanical certification of
ordinary-geometric interpretation and independent Reviewer acceptance.
The verifier's structure is appropriately stricter than the available
old evidence. Its intended admission checks must not be confused with
checks that actually succeeded.

## Historical records and present artifact availability

The source manifest lists **33,168 local OAI modules** and **1,918
external modules**: 1,915 Mathlib and three Lean modules. These are one
target's imported closure, not 33,168 original Argus drafts.

The stored `upstream_replay.json` has **exit code 1**, 19,727 successful
modules out of 33,168, and eight failure records. Reading the journal's
latest record for each module independently gives **19,735 distinct
modules = 19,727 successful + eight failed**, with **no target-module
record**. These are recorded historical successes, not currently
available or trusted compiled objects. The failures include
`Divisors.LineBundles.Scheme.SupportedCycleClass` and seven other
dependency-frontier modules. The first stored failure reports an
unavailable Mathlib import search root, not a counterexample to a theorem.

The current assigned old artifact set has none of:

```text
lean/Main.lean
lean/lean_check.json
exact_certificate.json
replay/.lake/build/lib/lean/OAI/AlgebraicGeometry/HodgeConjecture/MainSolution.olean
```

A bounded exact-filename search inside the assigned CM audit also found
no alternative `OAI/.../HodgeConjecture/MainSolution.olean`. This says
nothing about unassigned host resources. The legacy replay and dependency
compiled-library search directories in its declared environment are
currently absent. No missing alias or source tree was rebuilt.

The old fidelity document names `CMDependencyAudit.cm_input_kernel` in
`Main.lean`, but that wrapper was not preserved as an existing file.
Its intended theorem cannot be treated as an extant elaborated
declaration, let alone as kernel evidence. The imported source target
itself is present.

The receipts saying `submitted`, `running` or `live=true` are historical
artifacts. This review neither treated those labels as live process facts
nor inspected or modified their old process IDs. Cache/acquisition exit
zero and intermediate compiles do not imply target success.

## Fresh bounded measurements, not a full rebuild

The reproducible `probe.py` and its exact `replay_probe.json` are in this
unit. The probe reads old inputs only and writes here.
It invoked only the inspected verifier's **read-only** `check_sources`
function, with bytecode writing disabled, not its certificate-writing
`main()`. That preflight finished in about **29.1 seconds**, exit **0**:

```text
source import closure and all recorded source digests match: 33168
```

This verifies the local OAI source closure against its existing manifest;
it is not compilation, external dependency proof verification, or
independent authentication of a repository history.

Using the fresh-probed **4.34.1** binary, the source-declared dependency
search paths and a **20-second bound**, the diagnostic passed this exact
input to `lean --trust=0 -j1 --stdin`:

```text
import OAI.AlgebraicGeometry.HodgeConjecture.MainSolution
#check OAI.AlgebraicGeometry.HodgeConjecture.MainSolution.hodge_conjecture_for_cm_abelian_varieties
#print OAI.AlgebraicGeometry.HodgeConjecture.MainSolution.hodge_conjecture_for_cm_abelian_varieties
#print axioms OAI.AlgebraicGeometry.HodgeConjecture.MainSolution.hodge_conjecture_for_cm_abelian_varieties
```

It returned **exit 1**, no timeout, in about **0.16 seconds**, at the
first import:

```text
error: unknown module prefix 'OAI'
```

The exact command, input, stdout, stderr, paths and timing are preserved
in the JSON. Consequently no elaborated target type, successful target
proof, proof-hole verdict, or transitive axiom report was produced.
In particular, an unavailable axiom list is **not the empty list**.
The probe issued no native Lean evidence and no claim-ledger mechanical
certificate. No unchanged diagnostic was rerun.

## Mathematical assessment and concrete remaining obligation

This is more than a missing-access verdict. The actual source theorem
and its final proof were inspected: `MainSolution` obtains a native
geometric cycle from `Reference.GeometricAlgebraicity`, transports it
through the **same component supports**, and uses the nonzero rational
normalization comparison in `Reference.ComponentComparison` and
`IntrinsicCycleSpan`. That is a substantive and correctly identified
proof strategy for the written statement, not an unrelated finite
algebraic certificate. Its ordinary-geometric interpretation is assessed
in the applicability unit; its validity cannot be inferred merely from
these final source lines.

The missing obligation is a completed **source-bound, exact-pin**
replay of that declaration and its prerequisites, followed by the actual
elaborated statement and declaration-specific transitive axiom output.
The present build/import failure is an environment/evidence obstruction,
not a mathematical disproof. Reading text for occurrences of `sorry`
or `axiom` would not discharge it. Neither would cache completion, the
19,727 historical module successes, an unrelated local certificate, a
different Mathlib version, or a purported success receipt.

A full rebuild of the 33,168-module closure is not necessary to assess
this old draft honestly and would expand this bounded review into its
unfinished original execution program. It was not started. The old
report itself disclaims completed kernel evidence. This review records
that limit precisely rather than fabricating a conclusion or declaring
the imported theorem false. It is certificate-reuse work, not an
independent new proof or a novelty claim.
