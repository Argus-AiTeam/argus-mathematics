# The normalized-fragment inequality

## Source scope

The target is `diagram:fragment` in
`research/openai_manuscript/A-hyperbolic-group-with-no-geometric-CAT0-action-September-25-2026/build/sections/03-diagrams.tex`.
Its assertion is conditional on `diagram:rank-bound` for every collection of
at most `8A` distinct occurrences, including all fan prerequisites of each top.
The parameters are `0 < alpha, delta < 1` and `7 alpha < beta < 1`;
`f = 2 - alpha`, `p = 3 - beta`, and
`kappa = min(beta - 7 alpha, alpha / 5, delta)`.

The following source findings were recorded before executing a mathematical
search.

* `02-model.tex`, `def:template`, `eq:model-counts`, and the cone construction:
  the fan graphs are three copies of `K_{2,3}`, one `K_{2,2}`, and three
  three-edge stars. The exceptional fan has ports at its two line vertices
  and at `X_D`; an incidence at `X_D` carries a loose-side payment.
* `03-diagrams.tex`, `diagram:normal-form`: the proposed normalization has
  simple macro cycles, no equal-index same-occurrence cancellations, and
  cyclic fan links with distinct radial labels and at most five steps.
  The source separately asserts preservation of a prescribed lifted
  two-cycle. That global assertion has not been verified.
* `diagram:weighted-rank`: weights are `t_a` on loose top fields, `t_e` on
  decoration fields, and `w_b = max(r_b, max_{a -> b} t_a)` on fan fields.
  Shared prerequisites are retained even at fans not visited by a selected
  polygon. The layer sets must be closed under all seven prerequisites.
* `diagram:apex`: the difficult case is a dominant occurrence of multiplicity
  greater than the number of represented fan vertices. A fragment can select
  an arbitrary proper subset of a full cyclic link, not just one interval.
  Multiplicities and the number of fan vertices have no global size bound.
* `diagram:fragment`: the conclusion is `kappa A <= B`, not merely a bound
  for connected disks. `B` counts radial as well as letter boundary sides.
* The main-theorem frontier also contains sampling (`prop:sampling`),
  limiting energy/configuration (`prop:configuration`), geometric obstruction
  (`prop:no-configuration`), diagonal selection (`lem:completion-diagonal`),
  and finite-model transfer (`lem:completion-transfer`). None is verified by
  a theorem about normalized fragments.

The existing claim `C9000257` and context `CTX9000257` are retained.
There was no earlier mathematical certificate in the campaign ledger.
The inherited Wiki index has no page about this manuscript or fragment bound.

## Prior results and scope of dependence

The manuscript cites Ollivier, *Sharp phase transition theorems for
hyperbolicity of random groups*, DOI `10.1007/s00039-004-0470-y`,
Section 2, and Antoniuk--Friedgut--Luczak, *A sharp threshold for collapse
of the random triangular group*, DOI `10.4171/GGD/417`, Section 3, as
background for repeated-relator counting. These are comparison references,
not imported lemmas for the conditional finite-combinatorial argument.
An initial web-search response confused both bibliographic records and is
not accepted as a primary-source lookup or as evidence of originality.
No external theorem is currently assumed for the proposed finite argument.

The primary texts were subsequently opened: Ollivier
[`arxiv:math/0301187v3`, Section 2.2, Proposition 6](https://arxiv.org/html/math/0301187v3#S2.SS2)
and Antoniuk--Friedgut--Luczak
[`arxiv:1403.3516v2`, Section 3, Lemma 5 and its proof](https://arxiv.org/html/1403.3516v2#S3).
Both handle repeated ordinary relators using constraint graphs and a
multiplicity filtration. Those results are not directly invoked for nested
fan prerequisites. This is a limited originality comparison, not a claim that
the literature contains no comparable generalization. In particular, the
manuscript itself already asserts the weaker fragment theorem.

The source's occurrence-rank event and the existence of chain-preserving
normal forms remain separate open dependencies. Establishing a conditional
inequality does not prove either dependency, asphericity, hyperbolicity, or
the CAT(0) obstruction.

## Strengthened local theorem

Reconstructing the seven fans from the binary projective plane gives a useful
sharpening. A radial-label-simple link has at most four fan-triangle steps:
the only five-label fan is bipartite with two point representatives, so a
five-step simple circuit must contain a top turn. Further, the three ports
and equal-index cancellation permit at most one turn of a fixed top occurrence
at any fan vertex.

For a nonempty selected subset of a full normalized link, write `d` for
selected turns, `x` for dominant turns, `y` for other turns, `q` for selected
fan triangles, `p` for selected exceptional-port incidences, and `j` for the
partial-link indicator. The strengthened local inequalities are

    4 - 2d <= q + p + 3j,
    2(x - y) <= q + p + 3j,
    2j <= number of selected/unselected transitions,
    q <= 4.

The Python enumeration is an exact local computation, not by itself a proof
for bounded or unbounded diagrams. The formal source proves both exhaustiveness
of this finite local classification and its universal aggregation with
arbitrary occurrence multiplicities.

## Universal aggregation

Choose a maximum-weight representative in every unsigned field-value class.
At level `j`, a class is present exactly when its representative is present.
Deleting that representative therefore leaves precisely the unsigned
coincidence rank of the level set. Charge each internal letter contact to
one of its two nonrepresentative endpoints. Equal-index cancellation excludes
loops, and injectivity of actual side copies makes this a capacity-respecting
charge even in a multigraph with arbitrary cycles and repeated contacts.
Summing the rank bounds over all levels proves the weighted-rank estimate.
Each level retains every prerequisite, since `w_b >= t_a` whenever `a -> b`.
Neither the number of levels nor any occurrence multiplicity is bounded.

For one fan put `D = sum d`, `Q_b = sum q`, `P_b = sum p`, and `J_b = sum j`.
If `w_b = r_b`, the turn-incidence budget gives `D <= S_b`. Summing the first
local inequality gives

    D + 2(w_b - S_b) <= (Q_b + P_b)/2 + 3J_b/2.

If `w_b > r_b`, choose one prerequisite top of multiplicity `w_b` as dominant
for this entire occurrence. Its selected turns have total `X`; all other
turns have total `Y`, with `Y <= S_b - w_b`. The second local inequality,
summed over the fan's arbitrarily many links, gives the same estimate.
This accounts for prerequisite tops that do not visit the fan and for
arbitrarily many tops sharing it.

There are at least three turns on every selected simple macro polygon,
`sum S_b = 7T`, `Q <= 4 sum r_b <= 4W`, and `2 sum J_b <= B_rad`.
Combining the summed apex estimate with weighted rank, and setting
`Delta = (beta - 7 alpha)T + alpha W + delta E`, gives

    2 Delta <= B_raw + 3 sum J_b
            <= B_raw + 3 B_rad/2.

Consequently, for real positive parameters and
`kappa4 = min(beta - 7 alpha, alpha/4, delta)`,

    4 kappa4 (T + Q + E) <= 2 B_raw + 3 B_rad <= 3 B.

This improves the manuscript's conditional bound to
`A <= 3 B/(4 kappa4)`, and in particular implies `A <= B/kappa`.
It does not produce a normal picture or certify any topology-changing
normalization.

## Direct proof of the local theorem

The local inequalities also admit a short proof without trusting an
enumeration.

For a full link with no top turn, the link is a simple circuit in a simple
bipartite fan graph. The canceled two-step backtrack is excluded, so it has
at least four triangle steps. For a full link with one top turn, its other
steps form a fan path between distinct ports. Between two ordinary line ports
that path has length at least two. If one port is `X_D`, it has length at least
one and the turn contributes one loose-side payment. Thus `q+p >= 2`.
For two or more turns, `4-2d <= 0`. These three cases give the first inequality
when the link is full.

If a selected subset is proper, it is still nonempty. With no selected turn it
has at least one selected triangle, so `4 <= q+3`. With one selected turn,
`4-2d=2 <= q+p+3`; with at least two selected turns the inequality is immediate.
This proves the ordinary partial-link estimate without restricting the number
of selected runs.

Every fan has only three ports. Two turns of the same designated occurrence
would either share a port, and then be consecutive and forbidden by indexed-side
cancellation, or use four distinct ports, which is impossible. Hence `x <= 1`.
If the link is partial, `2(x-y) <= 2 <= q+p+3`. If it is full, the only case
with positive `x-y` is `x=1,y=0`, which is the one-turn case already proved.
This gives the dominant inequality.

Every triangle step uses one point-representative endpoint. The full link uses
each radial label at most once, so each such endpoint is incident to at most
two triangle steps. There are at most two point representatives, proving
`q <= 4` even before restricting to the selected subset. Likewise an indexed
fan edge can occur twice only in a two-step triangle backtrack, already
excluded. Thus each indexed fan field is used at most once per represented
apex instance.

A nonempty proper subset of a cyclic sequence has a transition from selected
to unselected and one from unselected to selected. This proves `2j` is at most
the number of radial boundary transitions.

The local constants used here cannot be reduced on local information alone.
In `K_{2,3}`, the circuit with radial labels `(0,2,1,3,4)` has four fan steps
and one turn between line ports `3,4`; selecting all its steps gives `q=4`.
In the four-triangle circuit `(0,2,1,3)`, selecting a single triangle gives
`d=p=0,q=j=1`. The coefficient of `j` in the doubled ordinary inequality
must therefore be at least three. Neither example asserts global optimality
of the final filling constant.

## Translation from a manuscript normal picture

Index **distinct** top, fan, and decoration occurrences, not individual copies.
Use selected copy counts for `top` and `decoration`. At each represented
fan-apex instance list the full radial labels, full step kinds, and exactly the
selected steps. The normal-form properties imply `LocalPattern.valid`, and
the number of represented links is precisely `r_b`. In the weight-dominant
case choose one maximizing prerequisite top once for the entire fan
occurrence; the local designated color is relative to that same occurrence
at every instance.

The top-turn budget and its total follow by counting the turns of each
selected simple macro polygon. The independently reconstructed macro graph
has fifteen vertices, twenty-two edges, and 213 simple cycles up to rotation
and reversal. Every one visits at least three point vertices. All seven fan
slots are retained even if its macro cycle visits only three of them.

Index all loose top fields, all fields of retained fan occurrences, and all
decoration fields, with shared fan fields indexed only once. Choose a
maximum-weight representative in each actual unsigned-generator class.
Index each internal letter contact by its two distinct actual side copies.
The local field-capacity theorem, simple macro polygons, and indexed
decoration copies place those sides in the required weight slots.
Same-position contacts are exactly the equal-index cancellations excluded
by normal form.

Every positive-weight fan either has a positive requiring top, or has a
represented apex with no selected top turn and therefore a selected fan
triangle. Consequently the number of retained fans is at most `7T+Q`.
The numbers of retained tops and decorations are at most `T` and `E`.
Every threshold collection is therefore within `8A`, including every one of
its shared prerequisites. This is proved in `Incidence.occurrence_bound`,
not added as an extra size assumption.

The contact-side identity gives `raw_count`. Each cyclic mask transition is
one radial side with exactly one selected face, giving `radial_count`.
The rank event in the manuscript then supplies exactly `rank_bound`.
These observations establish the source-to-data implication for already
normalized pictures; they do not justify making such a picture from an
arbitrary lifted two-cycle.

## Formal verification

The prescribed Lean 4.31.0 compiler and axiom audit both completed with exit
code zero and `proof_holes=[]`. The run recorded mechanical support for
`D_CORE_257` version 3 and archived its exact source and statement-fidelity
document at
`certificates/D_CORE_257-b6df4f0ba04767ee.json`.
`verify.py --write-certificate` also completed its independent exact
reconstruction and both campaign-local structural checks. This is a genuine
compiler result, not a manually assigned kernel status.

The local classification uses `decide +kernel`. The universal layer,
prerequisite, contact-capacity, occurrence-support, and deficit arguments
are proved in Lean rather than delegated to the Python finite experiment.
Independent source-to-statement fidelity review has not yet been obtained.

## Comparison and unresolved dependencies

Relative to the manuscript, the improvements are `alpha/5` to `alpha/4` and
the coefficient of radial boundary from two to three halves in the doubled
defect estimate. The output is a proof and a formal verification theorem,
not a counterexample or a claim that a finite search proves a global result.
The compiler checks all finite occurrence counts through universally
quantified types and arbitrary link lists, not an enumerated range of diagram
sizes. Its only exhaustive search is the complete, structurally bounded
single-link classification.

No false manuscript assertion was established in this scoped work.
In particular, no refutation of normal-form existence or lifted-chain
preservation is claimed. The occurrence-rank probability event, normalization,
separator globalization, sampling, energy, geometric obstruction, selection,
and finite-model transfer remain unverified. Independent statement-fidelity,
originality, and publication-significance review is still required.
