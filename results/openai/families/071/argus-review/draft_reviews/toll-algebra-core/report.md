# Extended per-visit accounting and scalar algebra

## Statement fidelity

This unit covers all five versions of **C_TOLL_CORE** in the old
`9000071/research/MATH_STATE.json`, not five different mathematical results.
The two `tagged_jump_audit/Main.lean` copies are byte-identical, as are the
two fidelity documents. The preserved source digest is
`43e678fb5a04a9015a40850547d93b35c493273c598728bd12cff87bdd01c227`;
the fidelity digest is
`741a9fbd680e35e7392f7f39fff0c8790ceb20259a9682ea285fc52e5cee1bd9`.
The versioned index contains the exact encoded source and claim hashes.
These are Argus formalizations of standard sum/algebra facts used by
Sections 1-3 and 5-6 of the old proof, not a formalization of the manuscripts.

In namespace `TaggedJumpAudit` the final source proves:

| Declaration | Exact quantified scope |
|---|---|
| `per_visit_glue` | Arbitrary types `A,I,J`, weight `w:A -> ENNReal`, maps `left:I -> A`, `right:J -> A`, and `p:A`: the sum over `I + (Unit + J)` equals `sum left + w(p) + sum right`. |
| `junction_paid` | The same data and an extended nonnegative `budget`, assuming `w(p)<=budget`, give the corresponding upper bound with `budget` replacing `w(p)`. |
| `normalization_identity` | For real `k>1`, `k*(1-2*((k-1)/(4*k)))-1=(k-1)/2`. |
| `normalization_positive` | Under the same hypothesis, the left side is positive. |
| `sharpness_deficit` | For real `n>0`, `1-(n/(n+1))^2=(2*n+1)/(n+1)^2`. |
| `sharpness_error_bound` | For real `n>0`, that deficit is strictly less than `2/(n+1)`. |

No injectivity or finiteness hypothesis identifies repeated images:
different indices can map to the same `p`. Extended nonnegative sums allow
infinite internal tolls without subtracting infinities. Mathlib's sum-type
`tsum` decomposition and monotonicity prove the first two declarations.
Field simplification uses the nonzero denominators furnished by `k>1`
and `n>0`; ring and ordered-field reasoning prove the remainder.
The real-parameter statements specialize to the integer sharpness family,
but do not themselves prove its geometric construction or a limit theorem.

Crucially, the disjoint visit-index type is **given** to the formal theorem.
It does not prove that a glued topological path has precisely that visit
decomposition. The old prose supplies that bridge. Neither the formal
statement nor its fidelity note contains dust disks, gates, coarea,
Sobolev functions, compatibility (P), conformal maps or manuscript-wide
quantifiers. Compilation cannot certify those omitted objects.

## Historical versions and certificates

| Claim version | Disposition |
|---|---|
| 1 | Natural statement only; no bound mechanical record. |
| 2, 3 | Intermediate formal statements; no mechanical record bound to either version. |
| 4 | `lean-C_TOLL_CORE-1ca3d7334aa8`, certificate `C_TOLL_CORE-eb061cb3b642797f.json`: `inconclusive`, type error in `junction_paid`, exit 1. |
| 5 | `lean-C_TOLL_CORE-098895923f87`, certificate `C_TOLL_CORE-734c2b23c09eaa46.json`: `supports`, exit 0, no proof holes. |

The earlier certificate's exact subject hash is
`1e539302b1c92cf0a852787ab0679c5c5162d4f80d5a881010cdfc3d428f4df2`,
which is **version 4**, not version 3. Its source digest is
`d200c72dda655ab9e80b4cd51476d9a1cd16131bcff07c741bc27881cc4e79f4`.
The later subject is version 5,
`2fbf8901b72bc0812cf470cab322bb47088a46209cee1874fa8ca049c45b5449`,
with the current preserved source digest above. Both archives' source text
matches their respective claim's formal statement. The fidelity digest is
unchanged. A failed earlier encoding is not a counterexample to the natural
sum identity, and successful version-5 evidence cannot be assigned to earlier
versions.

The old successful record reports Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Lake 5.0.0-src and elan
4.2.3, using the recorded Mathlib workspace
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
Its axiom-audit command also exited 0, but no nonempty explicit axiom list
was archived: do not infer an axiom-free result from that empty output.
This retains the ordinary Lean/Mathlib trust boundary.
The submit receipt and compile log are run provenance, not additional
certificates or mathematical results.

Old Reviewer judgment `judgement-C_TOLL_CORE-8617a0fd7741` supports the
successful version-5 subject. It is historical reading material here.
The present review claim does **not** cite that certificate as its own
mechanical evidence.

## Current replay and its boundaries

The unchanged exact checker first failed under the required legacy Argus
interpreter because SymPy was absent. A probed existing non-Argus interpreter,
`$WORKSPACE/miniconda3/bin/python3` (Python 3.13.5, SymPy 1.14.0),
then passed the checker. It checked the archived source/fidelity hashes,
certificate-to-latest-claim binding, sum budgets and scalar/radial identities.
See `research/replay/exact_checker_system_python.json` and its environment
record. This is not a fresh Lean compilation.

A separate bounded direct replay with the currently installed Lean 4.31.0
failed at `import Mathlib`: `unknown module prefix 'Mathlib'`. The log and
exit-1 record are `research/replay/lean_replay.log` and
`lean_replay_status.json`. That run is **unverified because of the import
environment**, not a mathematical failure or a new successful certificate.
No historical file, workspace, lakefile or certificate was altered, and no
new unchecked `.lean` file was added.

Current Jacobian discovery and exact contract inspection preceded one
60-second-bounded replay of `polynomial.sos.decomposition.check`.
Server 0.14.0 / protocol `2025-11-25` returned `is_valid=true`,
method `EXACT_COEFFICIENT_IDENTITY`, adapter exit 0, with no error or timeout.
The dedicated JSON payload, typed contract, output and exit records are under
`research/replay/jacobian_*`. The polynomial identity is

    a^2*d^2 - 2*a*b*c*d + b^2*c^2 = (a*d-b*c)^2.

The existing checker also binds this to
`(a^2+b^2)*(c^2+d^2)-(a*c+b*d)^2`.
It is the scalar Cauchy-Schwarz determinant identity, not an integral
inequality application or a theorem about geometric paths. Neither this
typed success nor a compiler/import failure changes the analytic assessment.

**Assessment:** the exact formal statement faithfully captures the stipulated
accounting/algebra core, with valid version-specific historical support and a
successful current scalar replay. Current fresh formal compilation remains
unverified. Novel mathematics, full geometry and current independent acceptance
are not claimed.
