# Finite certificates: bounded Engineer assessment

**Unit:** `finite-certificates`  
**Contribution type:** `finite_experiment_and_local_linear_certificate`  
**Assessment:** supported within the precisely bounded computational and local-linear scope below; not a universal proof.  
**Reviewer acceptance:** `pending_native_independent_review`.

## Inputs, version and attribution

This assesses the historical Argus checker and its accompanying records, not an
original manuscript or a new theorem. The read-only input directory is
`families/039/first-pass/reshaping_audit/`.
The eight inspected inputs are `verify.py`, `exact_certificate.json`,
`verification_task.json`, all four `jacobian_*.json` files, and
`jacobian_stderr.txt`. No historical ledger, draft, source, certificate or
snapshot was edited.

The checker SHA-256 is
`12212ba304991d677cf6110c9fc380df32f34c4ecf8d3745a56759bed8ff0d4b`;
the old certificate SHA-256 is
`cad9843e5cdc9bdbcb6ab21abec11a2ae2f2da60c45895175b79f44634f60acc`.
`replay_inputs_before.json` and `replay_inputs_after.json` identify and hash all
eight inputs; they agree. No novelty is claimed. Source correspondence, prose
proofs and Lean fidelity belong to other review units and are not assessed here.

## What the actual assertions establish

Line references below are to the unchanged historical `verify.py`.

* **Lines 16–65, 244–271:** Gaussian elimination uses exact rational or prime-field
  arithmetic. Jet entries are products of
  `binomial_integer(a,b) * coordinate**(a-b)`. These are **Hasse/Taylor
  coefficients**, not ordinary derivatives with factorial factors. Generalized
  integer binomials and invertible torus coordinates accommodate negative
  Laurent exponents. Multiindices have total degree at most the requested order.
* **Lines 80–118, 283–326:** the integral formal inverse is truncated at total
  degree `D=9N+1`. The checker asserts that the truncated substitution sends
  `y²+xy−x³` exactly to `xi*eta`, that each finite row projection retains its
  dimension, and that selected least terms have weight below `D+1`. Since the
  tested weights are `(1,8)`, an omitted monomial of total degree above `D`
  cannot precede these pivots. These are reliable finite leading-term checks,
  not an execution of an infinite formal-series proof.
* **Lines 180–233:** direction inequalities, determinant-one integer coordinates,
  areas and selected vertical-section lengths are asserted for a finite
  rational grid. Equality at sampled ordinates is not a universal polygon
  identity supplied by computation.
* **Lines 283–362:** six support stages are constructed for four fixed
  characteristic/dimension/degree configurations. At each of the five
  transformed stages, the code checks cardinality, the multiset of untouched
  labels, and residual-scaled polygon containment. A zero residual instead
  requires the first two exponents to be zero.
* **Lines 274–280:** gradedness is checked only when positive degrees `N`, `M`
  and `N+M` are all present in the finite family. There is no degree-zero family
  and no assertion about products outside the sampled degree range.
* **Lines 345–350, 365–385:** successive one-point ranks are nonincreasing for
  orders 0–3. The only mixed-point checks compare **maxima over 15 explicit
  normalized pairs over F5**, not ranks for every tuple across stages and not
  geometric generic maxima.
* **Lines 388–398:** `verify_jacobian()` reads archived payload/output/status
  files; it does not call an adapter or inspect a live contract. It requires the
  archived exit code 0, no timeout, the exact operation and source payload, and
  agreement of the archived rank 2 with local elimination. It does not read
  `jacobian_contract.json` or `verification_task.json`.
* **Lines 401–442:** two explicit characteristic-two compression tests preserve
  the gap `{0,2}`, including translation from `{-3,-1}`. Without
  `--write-certificate`, the complete normalized result must equal the old
  `exact_certificate.json`. The returned strings `resolved_statement`,
  `mathematical_proof`, `formal_claim` and `coverage_boundary` are **metadata**;
  equality of those strings does not prove their universal assertions. The
  checker neither reads the referenced proof nor runs Lean.

## Replay and actual toolchain

The source was inspected before execution: its only certificate write is
guarded by `--write-certificate`. That option was not supplied. The replay used:

```text
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python research/draft_reviews/finite-certificates/replay_verify.py
```

The local observer executes the original file with
`runpy.run_path(source, run_name="__main__")` and effective
`sys.argv=[<old>/verify.py]`. Return-only tracing captures the existing
`certificate`, `support_checks` and `jet_rank` results without replacing checker
functions, modifying arithmetic or repeating the experiments.

Actual runtime: **CPython 3.13.5**, Anaconda build
`(main, Jun 12 2025, 16:09:02) [GCC 11.2.0]`; executable
`$WORKSPACE/argus-latest/.venv/bin/python`, resolving to
`$WORKSPACE/miniconda3/bin/python3.13`. Optimization was 0, assertions were
enabled, and bytecode writing was disabled.

The durable direct runner completed with **exit 0**; observed checker duration
was **4.75045 seconds**. Its task is
`old039-finite-certificates-replay-20261107-7a16a9fe`, run
`old039-finite-certificates-replay-20261107-7a16a9fe-1794073960685865363`.
`replay_submission.json` preserves the submitted state and `check_with`
receipt; `replay_task_status.json` records completion. The direct-run timeout
was 600 seconds. No package installation was needed.

`replay_stdout.txt` contains:

```json
{"formal_proof_replayed_by_python": false, "independent_review": "pending", "rational_geometry_cases": 60, "status": "verified", "support_compositions": 4}
```

Stderr is empty. **Full structured old/new certificate equality is true**, not
merely equality of this short stdout summary. The saved certificate is also
byte-for-byte identical. See `replay_certificate.json`,
`replay_comparison.json` and `validation.json`.

The historical `verification_task.json` records only **submitted** state,
task `reshaping-exact-replay`, a 180-second timeout and an old runner
`check_with` command. It supplies neither a completion result nor the actual
old checker Python version. The current successful replay must not be
misrepresented as missing historical execution metadata.

## Exact sampled coverage

### Geometry and supports

The 60 rational geometry cases are the Cartesian product:

* `A ∈ {1/7,1,3,11/2}`;
* `B ∈ {2/9,2,7/3}`;
* `dw ∈ {1/32,1/8,1/4,3/10,333/1000}`;
* `H=AB`, `d=max(3/A,2/B)`, `w=(dw)/d`.

Each case checks sections at five abscissae
`{-b,-b/2,0,a/3,a}` for two polygons and four abscissae
`{0,w/3,w/2,w}` for the final tent.

All support experiments instead fix
`A=3, B=2, H=6, d=1, w=3/10`, giving
`a=16/3, b=2/3, t=8, i=4, p=q=1`, and final first-two-coordinate
intercepts `(3/10,20)`.

| Arithmetic | Dimension | Original intercepts | Degrees | Cardinalities | Truncation degrees |
|---|---:|---|---|---|---|
| Q | 2 | `(3,2)` | 1,2 | 7,19 | 10,19 |
| F2 | 3 | `(3,2,2/3)` | 1,2,3 | 7,22,50 | 10,19,28 |
| F3 | 3 | `(3,2,2/3)` | 1,2,3 | 7,22,50 | 10,19,28 |
| F5 | 2 | `(3,2)` | 1,2,3,4 | 7,19,37,61 | 10,19,28,37 |

The stage order, used in every rank vector below, is:

0. original simplex;
1. nodal weighted least terms;
2. shear `(x,y)↦(x−y,y)`, then axis-1 compression;
3. unimodular change `[[1,-1],[-3,4]]`;
4. axis-0 compression;
5. axis-1 compression.

There are 12 degree/configuration cases, 72 stage supports, 12 truncated node
identities, 60 transformed-stage cardinality checks, 60 label-multiset checks,
and 78 ordered degree-pair gradedness inclusions. In dimension two, the
untouched label is empty. In each dimension-three configuration its fibers are:

| Degree | Third-coordinate label : multiplicity |
|---:|---|
| 1 | `0:7` |
| 2 | `0:19, 1:3` |
| 3 | `0:37, 1:12, 2:1` |

Only degree 3, label 2, tests residual degree zero in the F2/F3 experiments.
This is not a test of a degree-zero graded component or arbitrary label sets.
Complete stage supports and labels are in `replay_stage_supports.json`.

### Actual one-point ranks

Every evaluation point is `(1,...,1)`. Orders 0–3 give 48 profiles and **288
matrix-rank evaluations**, asserting 240 successive-stage inequalities. For
dimension two the row counts are 1,3,6,10; for dimension three they are
1,4,10,20. Every order-0 rank vector is `(1,1,1,1,1,1)`.

| Characteristic | Dimension | Degree | Order 1 | Order 2 | Order 3 |
|---:|---:|---:|---|---|---|
| 0 | 2 | 1 | 3,3,3,3,2,2 | 6,4,4,4,3,3 | 7,5,5,5,4,4 |
| 0 | 2 | 2 | 3,3,3,3,2,2 | 6,6,6,6,3,3 | 10,8,8,8,4,4 |
| 2 | 3 | 1 | 3,3,3,3,2,2 | 6,4,4,4,3,3 | 7,5,5,5,4,4 |
| 2 | 3 | 2 | 4,4,4,4,3,3 | 9,8,8,8,5,5 | 13,11,11,11,7,7 |
| 2 | 3 | 3 | 4,4,4,4,3,3 | 10,10,10,10,6,6 | 17,16,16,16,8,8 |
| 3 | 3 | 1 | 3,3,3,3,2,2 | 6,4,4,4,2,2 | 7,5,5,5,3,3 |
| 3 | 3 | 2 | 4,4,4,4,3,3 | 9,8,8,8,4,4 | 13,11,11,11,5,5 |
| 3 | 3 | 3 | 4,4,4,4,3,3 | 10,10,10,10,6,6 | 17,16,16,16,7,7 |
| 5 | 2 | 1 | 3,3,3,3,2,2 | 6,4,4,4,3,3 | 7,5,5,5,4,4 |
| 5 | 2 | 2 | 3,3,3,3,2,2 | 6,6,6,6,3,3 | 10,8,8,8,4,4 |
| 5 | 2 | 3 | 3,3,3,3,2,2 | 6,6,6,6,3,3 | 10,10,10,10,4,4 |
| 5 | 2 | 4 | 3,3,3,3,3,3 | 6,6,6,6,5,5 | 10,10,10,10,7,7 |

The characteristic dependence is real: degree-one final second exponents are
`{0,1,2,3,4,5,16}` over F2 and `{0,1,3,6,9,12,15}` over F3, with third
coordinate zero. Compression has not silently been replaced by consecutive
exponents.

### Actual mixed-point finite-field maxima

Only F5, dimension two, is tested. For each degree and profile, the first point
is `(1,1)` and the second ranges through
`{1,2,3,4}² \ {(1,1)}`: **15 distinct normalized tuples**. This gives
`4×2×6×15 = 720` matrix-rank evaluations, 8 maximum profiles and 40
successive-maximum inequalities.

| Degree | Orders | Maxima at stages 0,1,2,3,4,5 |
|---:|---|---|
| 1 | 0,1 | 4,4,4,4,3,3 |
| 1 | 1,2 | 7,6,6,6,5,5 |
| 2 | 0,1 | 4,4,4,4,3,3 |
| 2 | 1,2 | 9,9,9,9,5,5 |
| 3 | 0,1 | 4,4,4,4,3,3 |
| 3 | 1,2 | 9,9,9,9,5,5 |
| 4 | 0,1 | 4,4,4,4,4,4 |
| 4 | 1,2 | 9,9,9,9,8,8 |

Thus **1,008 jet-rank evaluations** were observed in the single replay.
`replay_jet_ranks.json` records every actual rank, point, order, matrix shape,
degree and stage; it is not just the published maxima.

## Arithmetic and the finite-field maximum limitation

Characteristic zero means exact `fractions.Fraction` arithmetic over Q, not
floating point or symbolic arbitrary real inputs. Positive-characteristic
computations are over the explicit **prime fields** F2, F3 and F5 using modular
inverses and exact integer binomial coefficients. There are no extension-field
point searches or generic-coordinate calculations. Extending the scalar field
does preserve the rank of a fixed displayed matrix, but does not make the
enumerated rational point configurations exhaustive over that extension.

In particular, a maximum over F5-rational torus pairs can be **smaller** than
the maximum over an algebraic closure or the rank at generic coordinates: a
nonzero minor polynomial may vanish at every base-field rational point. Hence
inequalities between these finite maxima alone do not prove the corresponding
generic maximum-rank inequalities. The code supplies no argument that the
sampled tuples attain geometric generic maxima. This is a scope limitation,
not a counterexample to the universal theorem.

## Historical and fresh Jacobian boundary

The historical five-file record is internally consistent: operation
`prime_field.matrix.rank.compute`, server **0.14.0**, protocol **2025-11-25**,
transport `mcp-stdio`, rank 2, adapter exit 0, no timeout and empty stderr.
Its payload is the characteristic-two matrix `[[1,1],[0,1]]` with explicit
`columns=2`.

The fresh capability check used **only**
`$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian`
for Jacobian. That interpreter is also CPython 3.13.5 with the build above.
All direct-runner invocations used the mandated `argus-latest` interpreter;
Jacobian was not imported into Argus or probed using that interpreter.

Discovery requested at most three operations for
`matrix rank over a prime finite field`. It returned:
`finite_field.linear_map.rank.compute`, `prime_field.matrix.rank.compute`,
and `matrix.symbolic.rank.compute`. Only the exact second operation was
inspected and run. The complete typed contract is in `jacobian_inspect.json`;
the assessment made **before** execution is
`jacobian_contract_assessment.json`.

The inspected input type is `PrimeFieldMatrixRequest`, requiring `matrix`
of type `PrimeFieldMatrix`, with required `prime`, `entries`, `columns` and
no additional properties. Its semantic contract requires a prime in
`[2,2147483647]`, at most 256 rows, 1–256 columns for nonempty rows, matching
row lengths and declared columns, and canonical residue entries. The output
is `PrimeFieldMatrixRankResult`, requiring `prime`, retained `source` and
nonnegative integer `rank`. The operation is marked read-only.

The exact historical 88-byte payload was preserved byte-for-byte as
`jacobian_payload.json`, SHA-256
`a48321347a42c0723cc6303c8ffbad8a867aba82aa06e73cb91033a06fe68fa9`.
It fits that contract directly. Exactly **one** mathematical operation ran:

```text
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation prime_field.matrix.rank.compute --payload-file families/039/argus-review/draft_reviews/finite-certificates/jacobian_payload.json --timeout 45
```

Result: **prime 2, rank 2, exact retained source**, server **0.14.0**,
protocol **2025-11-25**, `math.run` over `mcp-stdio`, reported operation runtime
1 ms. The adapter and durable task both exited **0**; there was no timeout,
UNKNOWN result, transport error or structured error, and stderr was empty.
The enclosing process timeout was 75 seconds and direct-run timeout 120
seconds. Find/inspect/run outputs, individual structured statuses, submitted
task/run IDs, `check_with` receipts and completion statuses are all saved
locally as `jacobian_{find,inspect,run}*.json` and corresponding stderr files.
No task remains running.

**Separate manual assessment:** the displayed matrix has determinant
`1·1−1·0=1` in F2, so the linear coordinate map is invertible. The tangent cone
of `y²+xy−x³` in characteristic two is `y(y+x)`; `y` and `y+x` are distinct
linear forms. Thus the local linear-rank/distinct-tangent claim is correct
independently of adapter success. Neither this determinant nor the adapter
operation certifies the entire nonlinear formal coordinate change or any
global geometric construction.

## Concrete outstanding universal obligations

The finite checks do not discharge:

1. all admissible real intercepts and `dw<1/3`, including unsampled directions
   and all polygon sections;
2. every positive degree and characteristic, unbounded formal-series
   constructions and the coherent all-degree graded family;
3. arbitrary dimension, label sets and residual slices, beyond the displayed
   `(3,2,2/3)` three-dimensional cases and their single zero-residual fiber;
4. arbitrary numbers of points, mixed jet orders and field extensions, with
   **geometric generic** rank transfer rather than finite rational maxima;
5. the full universal composition argument and its geometric prerequisites.

Consequently this unit does **not** independently prove `C_RS_STRONG`,
`C_RS_COMPOSITION`, `C_RS_HEIGHT`, or any maximality theorem. It does not
refute a manuscript or settle the other review units. Its finished result is
a reproducible bounded experiment plus a checked local linear certificate.
`verdict.json` gives the structured assessment and evidence map. All 25 saved
artifact-consistency checks in `validation.json` passed, including rank-table
agreement, exact payload identity, completed receipts and unchanged old input
hashes; this validation did not run another matrix experiment. Acceptance
remains with the native independent Reviewer.
