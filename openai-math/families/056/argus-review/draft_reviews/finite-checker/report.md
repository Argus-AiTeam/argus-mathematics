# Exact finite verifier: inspected scope and measured replay

**Assessment: the finite certificate was successfully replayed, not the
analytic geometry.** The old output's `claim: CP_BOUND` is a label, not a
kernel verdict for that theorem. A29 does not parse the proof, check the
cited sources, or establish the full `mathematical_result` text in A04.

## Actual run

The unchanged preserved source was run with active assertions:

```text
$WORKSPACE/argus-latest/.venv/bin/python -B families/056/first-pass/curve_places/verify.py
```

The working directory was the current campaign
`campaigns/9200056`.
The interpreter was Python **3.13.5**, Anaconda build, GCC 11.2.0.
Measured subprocess wall time was **0.3054997632279992 seconds**, exit
status 0, with empty stderr. The exact command, interpreter description,
stdout, stderr and elapsed time are preserved in [runtime.json](runtime.json).
`-B` and `PYTHONDONTWRITEBYTECODE=1` avoided cache writes to the old workspace.
The verifier locates its original sibling certificate and saved Jacobian
files through `__file__`; no input was rebuilt or substituted.

```json
{"claim":"CP_BOUND","general_geometric_proof":"report.md; not machine-checked","independent_review":"required","jacobian_rank_replayed":1,"permutation_generator_pairs":617,"sharp_example_charts":4,"status":"passed","strict_discrepancy_cases":624}
```

The program explicitly refuses `-O`; this successful execution therefore
did not skip its assertions. No optional package, compiler or network
service is needed for this old replay.

## What was recomputed

| Computation | Exact coverage | What it does not establish |
|---|---|---|
| Sharp example | Gradients; four polynomial transforms, unit derivatives and singular-ideal substitutions; rank-four quadratic form; Segre and two incidence identities; displayed ranks | Normality, properness, bundle degrees, link topology or terminality without the accompanying geometric reasoning |
| Permutations | All ordered pairs of permutations in S_n for n=1,2,3,4: 1+4+36+576=617 cases | Arbitrary-size actions or geometric monodromy of W |
| Invariants/coinvariants | Vertical and horizontal ranks of generator-minus-identity maps, orbit counts, exact Reynolds idempotents and ranks | A general analytic or Hodge-theoretic implication |
| Image control | Adding one already generated redundant permutation preserves each tested group/image | All topological restriction maps; the pi1-surjective cover argument remains prose |
| S3 quotient | W=permutation_3 plus trivial plus sign, V=permutation_3 plus trivial; quotient rank 4; two independent invariant images | Every finite-group quotient, or finite monodromy of the geometric local system |
| Discrepancy signs | 1<=denominator<=12, 1<=numerator<=denominator, orders 1-4, smooth log discrepancies 2 and 3: 624 cases | The general smooth discrepancy bound, extraction or principalization |
| Negative controls | One lost-loop two-sheet action and one infinite unipotent quotient | A realized fourfold counterexample |
| Saved adapter | Exact rational row reduction of the supplied Gysin column [-1,-1], rank 1 and pivot [0] | The geometric identification of that column as the Gysin map |

The 617 cases are generator pairs, not 617 different groups. The 624 cases
also include repeated rational coefficients under different presentations.
Their minimum strict excess is 1/12 within the displayed bounds; this is
not a universal discrepancy gap. The general positivity argument is the
elementary inequality smooth_a>=2, kappa>0, order>0 implying
smooth_a+kappa*order>2, once geometry supplies those hypotheses.

The routine assigns the numbers 3-2, the Gysin column and [1] degree matrix.
It checks their arithmetic and ranks; it does not derive adjunction or
the normal/degree bundles. Conversely, its polynomial substitutions are
genuine exact identity checks, not mere comparisons of quoted constants.

## Separate live Jacobian use

Before execution, the isolated adapter discovered a small rank-operation
candidate set and inspected the exact typed contract of
`matrix.rank.compute`. It accepts a nonempty rectangular canonical-rational
matrix (at most 64 rows; the output contract bounds rank/pivots at 32).
The selected 2-by-1 QQ matrix is within both bounds. No Jacobian package
was imported into the legacy Argus environment.

The one bounded live call used
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian`.
Its exact payload is [jacobian_payload.json](jacobian_payload.json), and
the complete typed envelope is [jacobian_output.json](jacobian_output.json).
The payload is the same Gysin column as the saved input, not a substitute
for a proof note. Server `jacobian` version **0.14.0**, protocol
**2025-11-25**, returned rank **1**, pivot columns **[0]**, method
`EXACT_RATIONAL_ROW_REDUCTION`; adapter exit 0, error null, timeout false,
stderr empty. Client wall time was **3.2545889681205153 seconds**; the typed
server result reports runtime_ms=1. These are different timings, not a
performance comparison. No retry or second run was made.

The old replay independently validates the saved typed result; the live
operation only supplies a fresh bounded matrix answer. Neither is used
as support for the analytic theorem.

## Formal and external boundary

No Lean source or Lean certificate is among the 29 artifacts, and no Lean
compile was performed or claimed. Saito decomposition, rationality, GAGA,
Quot, Stein neighborhoods, small factorialization, transverse slicing,
covering-space theory, and the example's topological identifications remain
external/prose mathematics. Novelty, branch topology, local weights and
termination are outside mechanical coverage. The per-unit reports assess
those relevant implications separately. Native independent acceptance is
still required.
