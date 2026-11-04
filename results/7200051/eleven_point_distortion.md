# Eleven-point aspect ratio in the genuine l1 metric

The target is the **unrestricted exact** minimum of maximum/minimum pairwise
distance for eleven distinct real points in five dimensions. No result below
is a certified solution of that target.

## Rational constructions

The proposed points `0`, `A_i=e_i/2-(1/6)1`,
`B_i=-e_i/2-(1/8)1` do have aspect ratio `9/8`.
For `i != j` the six pair types have distances

| Pair type | Distance | Multiplicity |
|---|---:|---:|
| `0,A_i` | `1` | 5 |
| `A_i,A_j` | `1` | 10 |
| `B_i,B_j` | `1` | 10 |
| `A_i,B_j`, `i != j` | `25/24` | 20 |
| `0,B_i` | `9/8` | 5 |
| `A_i,B_i` | `9/8` | 5 |

This verifies the proposed upper bound, **not its sharpness**.
The inspected Jacobian operation `linear.rational_solution.compute` solves
the five active equations for `(a,b,s,t,D)` as
`(1/2,1/2,1/6,1/8,9/8)`. Its typed input, typed output, server version,
protocol, and successful adapter status are retained in `jacobian/`.
It solves only that linear system, not an optimization problem.

A subsequent exact certificate gives **Delta <= 292/269 < 9/8**.
`order-search-2000.certificate.json` contains rational primal gaps and rational
dual weights for one coordinate-order cone, with optimum `292/269`.
`configuration-292-269.json` gives integer coordinates divided by the recorded
positive scale. The separate integer-only checker verifies every pair
directly, without invoking the LP solver or the gap checker.
This disproves the working hypothesis `Delta=9/8`, not Kusner's conjecture.
It supplies no unrestricted lower bound.

The refined run improves the upper bound further to **Delta <= 115/106**.
Its exact primal/dual certificate is `order-search-refined.certificate.json`,
and its direct coordinate witness is `configuration-115-106.json`.
The improvement over the previous upper bound is exactly
`292/269 - 115/106 = 17/28514`. Neither fixed-cone optimum is asserted to be
the unrestricted optimum.

## Standard complete coordinate-order encoding

Let `sigma_j` be any ordering of the eleven labels in coordinate `j`, and put
`g_{j,k}=x_{sigma_j(k+1),j}-x_{sigma_j(k),j}` for `1 <= k <= 10`.
For each coordinate prefix `S_{j,k}`, let the corresponding column of `C`
be the indicator that an unordered pair has exactly one endpoint in that
prefix. Then **all 55 distances are exactly `C g`**.

Every real configuration belongs to at least one such cone: sort each
coordinate independently. Ties are allowed and give zero gaps. An arbitrary
tie ordering affects only zero-weight cuts. Conversely, every nonnegative
gap vector gives a real configuration by cumulative sums in the five orders;
coordinate translations are immaterial. If `C g >= 1`, the points are
distinct. Thus, for fixed orders, the exact aspect-ratio optimum is the LP

```
minimize D
subject to g >= 0, Cg >= 1, Cg <= D * 1.
```

Scaling a configuration by the reciprocal of its smallest distance places it
in this LP with `D` equal to its aspect ratio. Conversely a feasible LP point
has aspect ratio at most `D`; scaling again shows equality of the infima.
Taking the minimum over **all** five-tuples of permutations is therefore
globally exact. No finite sampled subfamily can replace that minimum.

The global infimum is attained and is rational. Indeed the proposed rational
construction permits restriction to `D <= 9/8`. In each cone the distance
between its first and last labels in coordinate `j` is at least
`sum_k g_{j,k}`, so feasibility implies `0 <= sum_k g_{j,k} <= D`.
The resulting feasible slice is compact. A nonempty slice has a minimizing
vertex with rational coordinates: choose an extreme point of the minimizing
face; if its active rational constraint normals did not span the ambient
space, a nonzero common null direction would preserve all active constraints
and, for a sufficiently small displacement in both directions, all inactive
constraints, contradicting extremality. A nonsingular subsystem then gives
rational coordinates by exact linear elimination. There are finitely many
cones, so a globally minimizing rational vertex exists. This is a standard
finite-polyhedral reduction, **not a claimed novel result**.

## Exact fixed-cone dual verification

For nonnegative rational pair weights `p,q` satisfying

```
sum(q) = 1, C^T(p-q) <= 0,
```

every feasible gap vector satisfies

```
sum(p) <= p^T Cg <= q^T Cg <= D.
```

The first inequality uses `Cg >= 1`, the second uses `g >= 0`,
and the last uses `Cg <= D*1`. A feasible rational primal with
`D=sum(p)` proves the optimum **for those orders only**.
`eleven_point_distortion.py verify` checks every displayed condition using
`fractions.Fraction`, and also compares the gap distances with direct l1
distances from cumulative coordinates.

The initial candidate's tie-broken order cone has exact optimum `9/8`, but
other cones containing different tie resolutions permit improvements.
This is why a certificate for one apparently natural sign pattern cannot
prove the proposed global optimum.

## A small global gap, conditional on equilateral exclusion

**Elementary consequence, not a sharp or claimed publishable result.**
If no eleven-point unit equilateral family exists in l1^5, then

```
Delta >= 1 + 1/11^26.
```

Here is a uniform exact argument covering all coordinate orders without
enumeration. Fix the globally minimizing order cone and translate label 0
to zero in each coordinate. Use its other 50 coordinate values and `D` as
51 real variables. The coordinate-order inequalities have integral
coefficients, zero right-hand sides, and at most two nonzero coefficients,
each equal to `1` or `-1`. Each distance is a linear form with at most ten
nonzero coefficients, each `1` or `-1`. The inequalities requiring that
distance to be at least one or at most `D` therefore have integral
right-hand sides and row squared norm at most 11.

Restrict temporarily to `1 <= D <= 9/8`. This polytope is compact:
after translation each coordinate has absolute value at most `D`,
because its absolute difference from label 0 is at most that pair's l1
distance. The exact construction `292/269 < 9/8` shows that the global
minimizer has the artificial upper constraint inactive. Choose a vertex
of its minimizing face. It is also a vertex of the original polyhedron:
otherwise a two-sided feasible segment through it would, by linearity
and minimality of `D`, lie in the same minimizing face.

Select 51 independent active original constraints, with matrix `B`.
All their right-hand sides are integers and every row of `B` has squared
norm at most 11. Thus `B` is a nonsingular integer matrix and

```
1 <= |det B| <= 11^(51/2) < 11^26.
```

The determinant inequality follows by orthogonalizing the rows: the
absolute determinant is the product of the lengths of the orthogonal
residuals, each no longer than its original row.
Exact linear elimination (equivalently, the integer adjugate formula)
expresses `D=N/|det B|` for an integer `N`.
By the assumed equilateral exclusion, this attained `D` is not one.
Feasibility gives `D>=1`, so `N>=|det B|+1` and
`D>=1+1/|det B|>1+1/11^26`, proving the displayed weaker closed bound.

If Gallinger's exclusion is accepted, it supplies the hypothesis of this
corollary. This elementary denominator estimate does not identify Delta,
and is far from matching `115/106`. It is not a replacement for the
mission's required sharp global lower-bound certificate.

## Source boundary and remaining gap

Gallinger's September 2026 paper, DOI `10.5281/zenodo.22984024`, Theorem 1.1,
asserts `e(l1^5)=10` and `e(l1^6)=12`. The original campaign's earlier
`d<=4` boundary was an August 2026 audit cutoff.
The pinned Lean statements do use the genuine `PiLp 1` metric and match
Theorem 1.1 and Corollary 6.2. The exact source reading and its limitations
are in `gallinger/statement_fidelity.md`.

The unchanged source fails in the alternate installed Lean 4.31.0/Mathlib
environment at `Cardinality.lean:26`: the newer
`ENat.natCast_add_one_le_iff` is unavailable. Six earlier modules compile.
This dependency-version failure is not a refutation of the paper.

The actual pinned environment has now been replayed successfully:
all **19 unchanged source modules**, including `Audit.lean`, compile on
Lean 4.33.1 with the declared mathematical dependency revisions.
The source bytes match the pinned GitHub archive. The 63 audited declarations
depend only on `propext`, `Classical.choice`, and `Quot.sound`.
The complete compiler commands, exit codes, and measured module durations
are in `gallinger/build-pinned-direct.json`; the statement and axiom output
is in `gallinger/build-pinned-direct.log`.

The official fresh `lean_evidence verify --claim C_GALLINGER` run also
returns success, no proof holes, and audit exit zero. Its current certificate
is
`gallinger/source/KusnerL1/certificates/C_GALLINGER-a972e7ea588800a7.json`.
The ledger derives `closed_kernel` for the encoded source claim.
An earlier missing-import verification record was an invocation failure and
is superseded, not a mathematical counterexample.
The replay uses local path dependencies to avoid Git; it does not modify
the upstream proof sources or mathematical dependency revisions.

Expanded upstream support modules and third-party Lean sources are stored in
the existing revision-pinned `gallinger/source.tar.gz`, dependency archives,
and toolchain archive. The operational `ArchiveCache.lean` download helper
is stored separately in `gallinger/pinned-env/cache-helper.tar.gz`; it is not
a mathematical proof. `source/KusnerL1/Main.lean`, its declaration-specific
fidelity document, both historical certificates, compiler logs and receipts,
and the compiled import caches retain their original paths.
No campaign-authored mathematical proof is archived by this layout change.

`python3 research/gallinger/source_layout.py roundtrip` checks archive
integrity, revision roots, exact restoration bytes and reversible source
expansion. `python3 research/gallinger/replay.py --pinned` restores the
upstream sources for the build and removes only those it restored afterwards;
it refuses to discard edited sources. Explicit `restore` and `archive`
operations are also available. The archive operation verifies all selected
files before removing any expanded copies. It leaves executable tools,
compiled dependencies and historical scientific evidence in place.

This settles the Engineer's build prerequisite and supports the stated
main-theorem correspondence. It does **not** certify the later manuscript
arguments outside that dependency chain, independently approve this reading
of the paper, establish novelty, or determine the exact aspect ratio.
The preceding independent Reviewer has now accepted the main-theorem
correspondence and recorded supporting proposition attribution. That source
checkpoint is no longer the blocker. It does not certify the new endpoint
reduction below or establish a sharp aspect-ratio theorem.

A bounded web lookup did not locate an exact eleven-point distortion theorem.
That negative retrieval is not evidence that the present construction is new.
The source claim, construction, fixed-cone certificates, global optimum,
and publishability are separate questions.

The unresolved mathematical obligation is an unrestricted sharp lower bound:
either a complete structural cover with exact certificates, or an analytic
argument that is sharp at a rational extremizer. Neither the sampled order
search nor the Gallinger equilateral theorem supplies that obligation.
The campaign remains incomplete and must continue after review of this
checkpoint; `115/106` must not be promoted from an upper bound to an exact
answer.

The continuation develops a complete endpoint-incidence cover in
`endpoint_chain_cover.md`: 66 loopless five-edge multigraph cases, including
ties and constant coordinates. Five cases have the analytic lower bounds
`2` or `26/21`, above the recorded upper bound. However, each of the
remaining 61 cases admits an exact unit metric after the cut-chain
compatibility constraint is dropped. This decisive relaxation obstruction
does not determine Delta; it identifies the nonconvex condition a sharp
global proof must retain.

## Replaying the exact coordinate evidence

The following commands use integer or rational arithmetic only:

```
python3 research/check_integer_configuration.py research/configuration-115-106.json
python3 research/eleven_point_distortion.py verify --file research/order-search-refined.certificate.json
```

The first checks all 55 distances directly from the displayed coordinates.
The second checks primal feasibility and all 50 dual cut inequalities for
the recorded cone. Neither needs SciPy. SciPy is used only to discover
candidate primal/dual vectors and is not trusted by either exact check.
