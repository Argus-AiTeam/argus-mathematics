# Actual transported BMP edge images

The target is equation `eq:image-equality` in `build/05-comparison.tex`,
not combinatorial invariance itself. A failure of this equation would not,
without an additional argument, refute equality of KL polynomials.
No false manuscript assertion has been established.

## Exact construction, rather than a character proxy

The independent implementation in `verify.py` uses the construction in
Fiebig, *The combinatorics of Coxeter categories*, arXiv:math/0512176v3,
Section 6.1 (PDF page 18). The primary PDF and extracted text are retained
as `research/fiebig-0512176v3.pdf` and `.txt`. The definition is recorded as
assumption `BMP_DEFINITION` of `C_BMP_CONSTRUCTION`; independent citation
attribution is still required. No character formula, desired image
equality, or terminal-kernel freeness is used by the computation.

In type A, write

    A = QQ[x_1,...,x_(n-1)],  x_i = e_i-e_n.

The label of a left transposition `(i,j)` is `x_i-x_j`, with `x_n=0`.
Extending scalars to the manuscript's real coefficient field is faithful
and flat. It preserves all the kernels, images, quotients, and minimal
graded covers in this construction.

At a vertex `x`, let `V` be the direct sum of already constructed stalks
at vertices strictly above `x`. For each internal edge, impose the
polynomial matrix equation for its two endpoint maps modulo its label.
If `D:V -> W` is the concatenated matrix and `Q` is the diagonal matrix
of these edge labels, the projection to `V` of

    syz([D | Q])

is exactly the full module of sections above `x`. Projection to the
outgoing edge coordinates gives the boundary image, modulo the outgoing
label relations. All these are polynomial-module operations over QQ,
not evaluations at sample points.

Take homogeneous components of these generators, in the grading shifted
by the target stalk generators. They still generate the full boundary
module: its defining equations are homogeneous, so every component is
itself a section image. Process these generators in increasing degree
and retain a generator exactly when its normal form modulo the label
relations and previously retained generators is nonzero. This is a
minimal homogeneous generating set. In a dependence of its classes modulo
the homogeneous maximal ideal, the maximal-degree generator with a
nonzero scalar coefficient would have belonged to the module generated
by earlier generators, contrary to its selection. Thus the associated
free cover is the graded projective cover in the canonical BMP recursion.

The same syzygy projection computes every later-edge kernel `L_x(F)`.
To compare embedded edge images in a stalk of rank `r`, add
`alpha_e A^r` to each image in `A^r` and reduce generators in both
directions using exact module Groebner bases. Consequently a passing
comparison tests the whole embedded module, including a possible
higher-codimension defect.

## Labels, orientations, and the prescribed scalar

Bruhat comparisons use the sorted-prefix criterion for permutations.
Edges are exactly increasing left transpositions. If `(i,j)` sends `x`
upward to `y`, let

    K = {k : i<k<j and pos_x(i)<pos_x(k)<pos_x(j)}.

Then `length(y)-length(x)=1+2|K|`. Each `k` gives the A2 root plane
on `{i,k,j}`, in which the relative length jump is three. All other
root-plane contributions to `k_Pi` are zero. Hence the manuscript's
scalar, up to a nonzero constant, is

    f_e = product_(k in K) (x_i-x_k) modulo (x_i-x_j).

The code checks the displayed length identity at every comparison.

Each tested map is an actual isomorphism of ranked Hasse digraphs;
no arbitrary edge permutation is substituted. Mapped reflection edges
are checked to remain left-reflection edges. Every schedule comes from
explicit linear functionals `h,f` with

    h_i = n-i,  h(e_i-e_j)=j-i>0,
    priority(i,j) = (f_i-f_j)/(j-i).

Priorities are exact rational numbers, checked pairwise distinct.
Thus each order is geometrically realized on the entire type-A root
system. Edges with equal reflection labels do not meet a vertex.

## A resolved concern about localized flabbiness

The distinction between relative and ambient order is real, but is not
a flaw in this proof. The manuscript explicitly acknowledges it in
`03-dihedral.tex:151-153` and `04-localization.tex:222-223`.
The argument at `04-localization.tex:240-262` does not require a relative
upward set to be the intersection of an ambient upward set.

Here is a complete argument. Maintain a section on a set `S` upper closed
under surviving, plane-labeled edges. Start with the relative upward set.
Choose an ambient-maximal missing vertex `a`. Every vertex strictly
above `a` is already in `S`; this ambient upward set has a section.
Localized ambient flabbiness gives an extension of that section. Keep
only its value at `a`, leaving every prescribed value unchanged.
Compatibility with prescribed higher neighbors follows from the chosen
extension. A prescribed lower neighbor cannot be joined to `a` by a
surviving edge, by the upper-closure invariant; vanished edge modules
impose no condition. The invariant persists. Finite induction completes
the extension. This closes this particular concern, without proving
the remaining decomposition or image-equality assertions.

The ambient flabbiness used here also follows directly from the finite
canonical construction: extend an ambient upward section by selecting an
ambient-maximal missing vertex; the section already assigned strictly
above it defines an element of its full boundary image, which lifts
through its defining free cover. Repeat downward. Flat localization
commutes with these finite section kernels and preserves the surjections,
so it preserves this extension property. Thus this argument does not
silently assume freeness of a partial upward kernel.

## Exact measurements obtained so far

For the order with `f_i=2^(i-1)`, the two singular S4 tops `3412,4231`
give 76 genuine interval isomorphisms and 266 distinct embedded-module
comparisons, all equal. The source bottom is required to have an
actually constructed BMP stalk with more than one generator.
For top `34512` in S5, the corresponding counts are 2,688 genuine
isomorphisms and 934 distinct module comparisons, again all equal.
These are finite experiments, not a proof of the quantified assertion.

The cross-type test `type_b_targets.py` constructs B3 as the 48 signed
permutations generated by adjacent swaps and last-coordinate sign change.
It checks the Coxeter orders `3,4,2`, verifies that its nine root-labeled
reflections are exactly the conjugates of simple generators, and builds
strong Bruhat order from increasing reflection edges. Every target
Hasse graph is checked to recover its entire interval order by transitive
closure. For the two singular S4 source sheaves, there are 436 genuine
interval isomorphisms to B3 intervals. The six explicitly listed
geometric B3 orders give 2,616 schedules and 324 distinct embedded-module
comparisons, all equal. This uses the already computed actual source
sheaves; it does not reconstruct or assume a target BMP sheaf.
It remains a finite cross-type experiment.

The broader run requesting all 32 pattern-containing S5 tops and ten
geometric orders hit its configured 1,800-second hard timeout. Its
structured terminal status is `a5_orders_status.json`; no completed
`search_a5_orders.json` was emitted. Consequently this run supplies
neither an all-S5 exclusion nor a witness. Constructor-progress lines
are not promoted to completed module-comparison certificates.

The implementation previously saved the aggregate only at termination.
It now atomically persists the mathematical prefix after every completed
source top, distinguishes a checkpoint from an exhausted search, and
states whether an isomorphism limit was reached. A controlled interruption
after the first completed source top preserves that exact prefix; a
separate normal-completion test produces the explicit complete state.
The timed-out family has not been relaunched. Its retired route records
the runtime failure, not a mathematical exclusion.

One independently replayed scalar membership uses the singular sheaf
with top `3412` and edge `1234 -> 3214`, label `x1-x3`.
Here the later lower edge is `1234 -> 2134`, and the upper later set is
empty. The actual lower image has representatives `x2-x3, x1-x3`;
the required scalar is `x1-x2`. The identity

    x1-x2 = (x1-x3) - (x2-x3)

checks membership directly. Jacobian operation
`polynomial.ideal.normal_form.compute`, server 0.14.0, protocol
2025-11-25, returns `COMPUTED`, `in_ideal=true`, zero remainder, adapter
exit code zero. Its exact payload, typed output, discovery, contract,
and adapter status are retained in the dedicated JSON files.
This certifies this one membership only.

## What remains

The global equation is not settled by these computations. The
manuscript's deficit argument requires the edge-image inclusion uniformly
at every smaller-rank upper kernel. No finite list of passing examples
establishes that inclusion or the full induction. In particular no
refutation judgement, independent acceptance, publishable significance,
or verified novelty is claimed.

## Uniform formal certification of the deficit implication

`Main.lean` proves `TransportedEdgeRigidity.no_hidden_deficits` for
arbitrary index types, schedule lengths, and nonnegative varying transfer
weights. Let `U` be the exact elementary-transfer trajectory, `D` the
pointwise subtrajectory, and `delta_k=M_k D_k-D_(k+1)>=0`. Then

    (U_(k+1)-D_(k+1)) = M_k (U_k-D_k) + delta_k.

For `M_k=id+t_k E_(a_k,b_k)` and any nonnegative vector `v`,
`M_k v>=v`. Starting from equal initial states, the error is therefore
coordinatewise nonnegative and nondecreasing. Equality of the final
states forces every intermediate error, and consequently every step
deficit, to vanish. Neither acyclicity nor distinct edge endpoints is
needed for this implication.

The official Lean 4.31.0 compiler and axiom audit both exit zero, with
`proof_holes=[]`, and the evidence is attached to
`C_DEFICIT_RIGIDITY`. The precise statement and its explicit limitations
are fixed in `statement_fidelity.md`; independent fidelity review has
not yet occurred. The immutable compiler certificate is
`certificates/C_DEFICIT_RIGIDITY-39d98dfcaab08137.json`.

Thus a higher-codimension defect cannot hide from the deficit argument
*if* all its local inequalities and the endpoint equality hold. This
does not prove those hypotheses for every BMP sheaf. It is a uniform
conditional formal verification of one load-bearing implication, not a
uniform verification of the full transported-edge mechanism, not a new
proof of KL invariance, and not a publishable campaign completion.

Compared with the prior source-based frontier, the substantive additions
are actual polynomial-module equalities on singular intervals, genuine
cross-type transported schedules, and a kernel-checked uniform
conditional deficit implication. The unresolved geometric inputs have
not been promoted to theorems by those measurements.
