# A constructive universal pruning verification

## Result and scope

The arbitrary-relation pruning lemma in the staged `02-pruning.tex` is
verified by the universal argument below. Its shared-coefficient kernel
restriction, independent lifts, and ensuing dimension inequality are proved
in `Main.lean`. The matching construction, explicit simultaneous coefficient
choice, and conversion to pruning are proved here. This is not a claim that
the entire pruning lemma, or Seymour's conjecture, has been formalized in
this audit.

The constructive strengthening of the manuscript's coefficient choice is
particularly simple: enumerate the arrows by `e = 0,...,m-1`, and take

    a_e = b_e = 2^(2^e).

Thus the two coefficient arrays can even be equal, and every occurrence of
an arrow in different coordinate blocks has exactly the same coefficient.
No replacement by independent coefficients for different occurrences is
being made.

**Theorem.** Let `X` be any finite set, with any binary relation, including
loops. Let `R,C` be subsets of `X x X`, counted as separate families.
Use exactly the conflict, coverage, `H`, and `Z` definitions in the
manuscript. There are conflict-free subfamilies `R',C'` retaining every
initially conflict-free member and satisfying

    |R \ R'| + |C \ C'| <= |H| + |{z in Z : no survivor covers z}|.

The proof also works for four finite coordinate sets `P,I,S,J`, with
independent relations `E` from `P` to `I` and `F` from `S` to `J`,
`R` contained in `P x J`, and `C` contained in `I x S`. This rectangular
form is equivalent to a four-coloured instance of an arbitrary binary
relation; it is not claimed as a strictly stronger combinatorial result.

## 1. One explicit assignment realizes all structural ranks

Let a sparse matrix have at most one independently indexed allowed entry
in each position. Give its allowed positions distinct indices `e` and
put `w_e = 2^(2^e)` there, leaving other entries zero.

For any square submatrix, its nonzero determinant terms correspond
exactly to perfect matchings of its support. A term has absolute value

    product_e_in_M w_e = 2^(sum_e_in_M 2^e).

Two different permutations use different sets of positions. Uniqueness
of binary expansion therefore gives different exponents for their terms.
If at least one term occurs, let `d` be the largest exponent. Every
other exponent is a distinct integer smaller than `d`, so the sum of
the absolute values of all other terms is at most

    sum_(h=0)^(d-1) 2^h = 2^d - 1 < 2^d.

The leading term cannot cancel. The determinant is nonzero if and only
if the support has a perfect matching. The empty determinant is `1`.
It follows from the minor definition of rank that every submatrix has
rank equal to the maximum size of a matching in its support. Indeed,
any nonzero minor supplies a matching; conversely, the endpoints of a
maximum matching supply a square submatrix with a nonzero determinant.
The same support gives an upper bound on rank for *every* assignment.
Consequently this single assignment is of maximum support rank on
every submatrix simultaneously, over both the rationals and the reals.

Apply this construction to the arrow array of `X`, with entry `w_(x,y)`
for `x -> y`. Use that array for both `a` and `b`. For the rectangular
version, apply it separately to the two relation arrays.

For `L`, a matching minor is block diagonal by the second coordinate
`j`; each block is a submatrix of the first relation array, or its
transpose. Every block determinant is nonzero by the preceding argument.
Repeating a coefficient in other blocks causes no problem: the
determinant of the whole minor is the *product* of these nonzero
numbers. The corresponding statement for `N^T` uses blocks with `i`
fixed and the second relation array. Each `D^{p,i}` is a submatrix of
that second array. All the manuscript's required ranks therefore hold
at this one, explicitly specified, positive integer assignment.

This discharges the simultaneous-choice issue without an appeal to
genericity, a probability argument, or an external matching-rank theorem.

## 2. Choose the augmented matching

Build the bipartite graph with parts `R + Z_L` and `C + Z_R`. Its edges
are the original conflicts and the two types of original-to-point
coverage edges; there are no `Z_L`--`Z_R` edges. All four vertex types
are disjoint even if their displayed coordinates agree.

Choose a maximum matching with the fewest original--original edges.
Let `k` be their number, and let `alpha,beta` be its
`R`--`Z_R` and `Z_L`--`C` edges, of sizes `ell,t`.

The matching `alpha` is maximum in its own subgraph. Otherwise, an
`alpha`-augmenting path starts at an `alpha`-unmatched original left
vertex and ends at an `alpha`-unmatched `Z_R` vertex. The latter is
unmatched in the full matching, and the internal vertices are matched
by `alpha`. If the start is unmatched in the full graph, the path
increases the matching size. If instead it is matched by an
original--original edge, remove that edge and augment on the path:
the size is preserved and `k` decreases. Both are contradictions.
The proof for `beta` is the same with sides exchanged.

The coefficient assignment in section 1 gives `rank L = ell`,
`rank N = rank N^T = t`, with the original endpoints of `alpha`
and `beta` giving bases of the respective column images.

## 3. The four maps and their complete row equations

Work over the rationals. With all unlisted entries zero, set

    L_(i,j),(p,j) = a_pi,       N_(i,s),(i,j) = b_sj,
    B_(p,s),(p,j) = b_sj,       A_(i,s),(p,s) = a_pi.

Their coordinate sets are respectively `Z x R`, `C x Z`, `H x R`,
and `C x H`. For each original row-column pair `((i,s),(p,j))`,
there is at most one intermediate coordinate for either product:
`(i,j)` for `NL`, and `(p,s)` for `AB`. If the endpoints conflict,
both coordinates are present and both products have entry
`a_pi b_sj`. In a nonconflict at least one factor is zero on each
route. Thus `NL = AB`, including cases where any coordinate set is
empty.

Extend vectors on `R,C` by zero outside those families. For
`u in ker B`, the complete equation at `(p,s) in H` is

    sum_(j : (p,j) in R) b_sj u_pj = 0.

For `v in ker N^T`, the complete equation at `(i,j) in Z` is

    sum_(s : (i,s) in C) b_sj v_is = 0.

No summands from another first coordinate can enter either equation.
This is the zero-extension interpretation of the hypotheses `hB,hNt`
in the formal theorem `conflict_kernel`.

## 4. Maximum-support kernels and restriction

For completeness, here is the rank-perturbation argument.
If `D x = 0`, `D^T y = 0`, and `x_j y_s != 0` at an allowed entry,
put `D' = D + e_s e_j^T`. Then `D' x = x_j e_s`, so `e_s`
belongs to `im D'`. Also `D w = D' w - w_j e_s`, so
`im D` is contained in `im D'`. But `y` annihilates `im D`
and does not annihilate `e_s`, making the containment strict.
This contradicts maximum support rank. Therefore

    x_j y_s = 0 at every allowed entry.

This proof is formalized by `perturbation_kernel_product` and
`support_maximal_kernel`, over an arbitrary field.

Now fix `p -> i`, and let

    J_p = {j : (p,j) in R},       S_i = {s : (i,s) in C},
    D^{p,i} = (b_sj)_(s in S_i, j in J_p).

If a row `s` has an allowed entry, its conflict puts `(p,s)` in `H`;
the complete `B` equation above places `(u_pj)_(j in J_p)` in the
right kernel. A row without allowed entries has zero equation even
when `(p,s)` is absent from `H`. Similarly, every nonzero column
puts `(i,j)` in `Z`; the `N^T` equation places
`(v_is)_(s in S_i)` in the left kernel. A zero column has zero
equation even if its coordinate is absent from `Z`.

Section 1 supplies maximum support rank of this local `D^{p,i}`.
The preceding kernel theorem gives, for *every* pair of global kernel
vectors,

    u_pj v_is = 0 whenever ((p,j),(i,s)) is a conflict,
    u in ker B, v in ker N^T.

The formal declaration `conflict_kernel` proves this entire restriction,
including the absent-row and absent-column cases. It uses a zero-padded
local matrix on all of `S x J`; deleting its identically zero rows and
columns gives the restricted matrix just displayed.
The hypothetical perturbation is only of this local matrix; it need
not preserve the ranks of other matrices at the fixed assignment.

## 5. Independent kernel lifts

For each original--original matching edge `(r_m,c_m)`, use the basis
columns from section 2 to solve

    u_m = e_(r_m) + a combination of the alpha original endpoints, L u_m = 0,
    v_m = e_(c_m) + a combination of the beta original endpoints, N^T v_m = 0.

The matching makes the original endpoints disjoint from the alpha and
beta endpoints. Thus `u_m(r_n)` is the Kronecker delta and
`v_m(c_m) = 1`.

Section 4, with `v = v_m`, says that every `u in ker B` vanishes
at `r_m`. If `sum_m theta_m B u_m = 0`, the single vector
`u = sum_m theta_m u_m` belongs to `ker B`; its `r_m` coordinate
is `theta_m`. Every coefficient vanishes. The images `B u_m`
are consequently linearly independent. Moreover,

    A B u_m = N L u_m = 0.

There are therefore `k` independent vectors in `ker A`.
The declarations `lift_images_independent` and
`kernel_lifts_dimension` prove exactly these assertions, not merely
the independence of the original lifts.

## 6. The augmented matching bound

Rank-nullity, the preceding dimension bound, and `AB = NL` give

    |H| = dim ker A + rank A >= k + rank(NL).

Restriction of `N` to `im L` gives

    rank(NL) >= rank L - dim ker N = ell + t - |Z|.

For clarity, the first inequality follows because the kernel of that
restriction embeds in `ker N`, not from a claim that those kernels
are equal. In Lean this is `composition_rank_bound`; combining it
with the independent lifts is `augmented_rank_bound`. Thus

    k + ell + t <= |H| + |Z|.

The left side is the size of the selected maximum matching. This
bound consequently applies to *every* matching in the augmented
graph. None of these arguments requires nonempty coordinate sets.

## 7. A pruning with the full cost and retention clause

Starting at every unmatched left vertex, traverse nonmatching edges
left-to-right and matching edges right-to-left. Let the reached sets
be `W_L,W_R`. A reached unmatched right vertex would give an
augmenting path, which is impossible. The endpoints of every matched
edge are either both reached or both unreached: reaching a right
endpoint reaches its mate; a matched left endpoint can only be
entered through its mate.

The set `K = (V_L \ W_L) + W_R` covers every edge. An edge from a
reached left vertex to an unreached right vertex could be neither
nonmatching (it would be traversed) nor matching (its endpoints have
equal reachability). The cover contains exactly one endpoint of
each matched edge and no unmatched vertices. Its size is at most
`|H|+|Z|`. It omits every isolated vertex.

Delete exactly the original members in `K`, obtaining `R',C'`.
No conflict survives. If a surviving member covers `z in Z`,
the opposite copy of `z` must belong to `K`. Different points
require different new vertices in `K`. If `q` points of `Z`
are uncovered by all survivors, this gives

    deleted originals <= |K| - (|Z| - q) <= |H| + q.

Finally, every initially conflict-free original member is isolated
in the augmented graph. For example, if `(p,j)` covered `(i,j) in Z`,
a conflict witnessing membership in `Z` would provide `(i,s) in C`
with `s -> j`. It would conflict with `(p,j)` since `p -> i`,
a contradiction. The other side is identical. The cover therefore
retains all initially conflict-free members. If there are no conflicts,
one may simply retain everything. This also handles the empty set and
empty-family cases, and completes the universal proof.

The replay also checks the stored Lean source/fidelity hashes and
hole-free compiler result and compares the stored Jacobian typed
request and response. These are consistency checks on existing tool
evidence, not new compiler or adapter runs.

## Replay and provenance

Run `python3 research/pruning-core/verify.py` from the campaign root.
It recomputes `exact_certificate.json` using only integer and rational
arithmetic from the Python standard library. The nontrivial instance
has both kernels nonzero, at least one original--original matched edge,
independent nonzero `B`-lifts, shared coefficients, and identical
coordinate pairs present as distinct initially conflict-free members
on the two sides. The script additionally checks all 4,105 labeled
instances of order at most two, allowing loops and arbitrary overlapping
families. These finite checks are supplementary experiments, not the
universal proof.

The separate Jacobian typed payload is a `3 x 3` local symbolic
matrix with both kernels nontrivial. The inspected operation
`matrix.symbolic.rank.compute` returned exact rank `2` with pivot
columns `0,2`. Its payload, typed response, protocol, version, and
adapter status are preserved separately. This calculation is not
used to extrapolate any universal conclusion.

The strongest prior result used for comparison is the staged universal
pruning proof, particularly `lem:kernel-support`,
`eq:pruning-maps`, `eq:conflict-kernel`, and
`eq:pruning-rank-bound`. The mathematical improvement here is an
explicit positive integer, single-array simultaneous assignment;
the certification improvement is a real Lean proof of the complete
kernel restriction, lift independence, and dimension bound. No
external proposition is an unproved dependency: the structural-rank
and matching-to-cover arguments are supplied in full instead of
assuming the cited Edmonds or Konig theorems.

A targeted literature lookup located the original OpenAI manuscript
but did not establish an independent antecedent for this exact
certificate. Absence of such a search result is not a novelty proof.
The binary-weight isolation idea itself is not claimed as new.
The upstream primary scope document
`https://raw.githubusercontent.com/openai/math/main/lean/docs/173.md`
advertises a main-theorem formalization and links a comparator;
this audit neither evaluates that separate formalization nor claims
that no other formalization exists. Publication significance and
novelty require independent review. No false literal manuscript
assertion has been identified in this mission.
