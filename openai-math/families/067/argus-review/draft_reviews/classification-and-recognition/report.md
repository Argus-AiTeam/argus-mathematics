# Classification, reductions and Grassmannian recognition

**Assessment: partial support, not a certified full sixfold theorem.**
The high-Picard-number and pseudoindex-four branches are applications of
known external results; the remaining pseudoindex reduction is
source-supported. The old Argus numerical audit does not discharge the
general-VMRT recognition obligation. This is not a refutation of the
original manuscript or an assertion that it is correct.

The old assertions are in
`9000067/research/MATH_STATE.json` and `PROOF_GRAPH.json`. The graph
**does contain** `C67_CP6_MAIN`, `C67_PICARD`, `C67_REDUCTION`,
`C67_D4`, and `C67_RECOGNITION`, with open statuses, not independent
support for their conclusions. "Ledger-only" here means that the old
Argus package records these broader goals without a completed corresponding
Argus proof; it does not mean they are absent from its graph. The original
manuscript, a reference rather than a second Argus draft, gives its own
arguments in Sections 1--3, 6--7 at revision
`4eaee87548250b2682affda7d05d947c05554bae`.

## Exact claims and source qualifications

| Old claim | Application actually supported |
|---|---|
| `C67_CP6_MAIN` v1 | Target: every smooth connected complex Fano sixfold with nef tangent bundle is rational homogeneous. Not established by the old bounded Argus audit. |
| `C67_PICARD` v1--v2 | For such a sixfold with `rho>=2`, Kanemitsu's strict inequality `rho>n-5` applies. |
| `C67_REDUCTION` v1 | With `rho=1`, outside `P6` and `Q6`, only pseudoindices 4 and 5 remain, using named external classification/characterization results. |
| `C67_D4` v1--v2 | The `rho=1`, pseudoindex-four CP-sixfold case is a known theorem of Watanabe. If the short old statement is read as including `rho>=2`, combine with the preceding Kanemitsu branch. |
| `C67_RECOGNITION` v1 | Conditional numerical/tangent-image/recognition chain towards `Gr(2,5)`; its actual-family geometric hypotheses must still be discharged in a full Argus proof. |

These are **pseudoindex**, not index, statements. CP means Fano with
nef tangent bundle; neither citation licenses a statement for arbitrary
Fano sixfolds.

### C67_PICARD: a known external theorem

The checked versioned primary statement is Kanemitsu,
`arxiv:1505.02952v1`, Theorem 0.2, corresponding to the publication
DOI `10.1007/s00209-016-1652-7`. Its applicable assertion is:
a Fano `n`-fold with nef tangent bundle is rational homogeneous if
`rho>n-5`. For `n=6` this means `rho>1`, exactly `rho>=2`.
It does not cover the equality `rho=1`. This is a reproduction/application
of a known result, not an old Argus contribution.

The final Springer page returned HTTP 406 during the bounded source read.
The theorem was checked in the explicitly versioned preprint, so no
claim is made that final publisher wording was independently retrieved.
This access fact does not constitute a mathematical gap in the
preprint's stated application.

### C67_REDUCTION: what the reduction needs

The fixed manuscript's `prop:pseudoindex-reduction` supplies a proof
outline. Its elementary first steps are consistent: a nonzero differential
`O(2) -> phi^*T_X`, whose splitting is nonnegative, forces minimum
degree at least two. If `d=2`, smooth connected zero-dimensional
evaluation fibres make `e` an isomorphism. The resulting nontrivial
`P1`-fibration of `X` contradicts `rho=1`: the pullback of a base
ample divisor is nonzero and nef but has fibre degree zero.

The `d=3` exclusion and the high-degree projective-space/quadric
characterizations are external, not consequences of the finite-ratio
certificate. Kanemitsu 2017, p. 1456 before Proposition 1.6, recalls
for Picard-one CP manifolds `3<=d<=n+1`, the extremal cases `P^n`
and `Q^n`, and that `d=3` leaves only `P2`, `Q3`, and the
five-dimensional homogeneous contact manifold of type `G2`. None has
dimension six. The manuscript attributes its detailed route to the
Mok--Hwang one-dimensional-VMRT classification and the
Dedieu--Hoering numerical characterization.

Thus the reduction is supported **using that known classification
background**, not independently proved from scratch by the old Argus
calculation. A proof excluding `d=3` without those inputs would need
a different argument; it was not supplied by the rank certificate.

### C67_D4: exact Watanabe scope

The checked primary version is Watanabe,
`arxiv:1904.10185v1`, Theorem 2.4, corresponding to DOI
`10.1007/s10711-020-00538-2`. The relevant assertion is that a CP
sixfold with `rho=1` and pseudoindex 4 is homogeneous. The paper's
title does not add an index/coindex hypothesis to this theorem, and
the theorem does not uniquely specify a model.

The Springer page again returned HTTP 406; the versioned theorem
statement, not an unavailable publisher text, was checked. The
manuscript's Section 3 describes its intersection calculation as an
**independent argument** for this known case. The old Argus package
does not contain a separate completed audit of that independent
pseudoindex-four calculation. The external theorem suffices for the
classification branch, but must not be relabelled as verification of
the manuscript's alternative proof.

## C67_RECOGNITION: concrete remaining obligations

The numerical audit proves `S/D` is 4 or `8/3`, and supplies a finite
tangent morphism from the smooth normalization `F`. Neither statement
alone identifies the **general VMRT as a projectively embedded variety**.
In particular:

1. Establish nondegeneracy of the general tangent image in `P(T_x^*X)`
   under the hypotheses of the relevant Hwang--Mok propositions, including
   the bivector-spanning argument. Picard number one by itself is not a
   substitute for checking those hypotheses.
2. Check the general-hyperplane/sectional-genus argument with the actual
   ample, generated `L` and finite tangent map, including the exclusion
   of the `u=4` branch and determination of the degree. A ratio is not
   itself a degree computation.
3. Keep `D=(degree tau)*(degree image)` until degree one has been
   established. Prove normality and the required smooth Segre conclusion,
   not merely that the marking space `F` is the normalization of the
   through-point curve space. A minimal-degree classification allows
   singular scrolls/cones unless the relevant additional conditions are
   checked. Finiteness of `tau` does not mean it is an embedding.
4. Prove that for **general x** the actual VMRT is projectively equivalent
   to `P1 x P2` in its Segre embedding, the VMRT of `Gr(2,5)`.
   Only then apply a recognition theorem whose model, Picard-number-one
   and minimal-component hypotheses agree with the source.

The reference manuscript's Section 6 attempts precisely this chain.
These are the concrete unfinished obligations of the **old Argus
classification claim**, not discovered counterexamples or allegations
that a particular step in the original manuscript is false. The
bounded source assessment did not turn the manuscript's proposed proof
of all four into an independently certified classification.

The relevant checked source boundaries are:

| Source | What it can supply, and what it cannot |
|---|---|
| Hwang--Mok 1999, Propositions 1.2.1--1.2.2, `https://library.slmath.org/books/Book37/files/hwang.pdf` | Generic VMRT setup with `b2=1`; the nondegeneracy/bivector hypotheses still need the stated argument. |
| Eisenbud--Green--Hulek--Popescu, `arxiv:math/0404517v5`, Theorem 0.1 (Del Pezzo--Bertini), also read in `https://arxiv.org/html/math/0404517v5` | A projective variety (reduced irreducible, over an algebraically closed field) with degree `1+codim` in its span is a linear space, quadric hypersurface, rational normal scroll, or cone over the Veronese surface. This classification does not by itself identify an arbitrary finite normalization map with a smooth Segre embedding. |
| Mok, author version `https://hkumath.hku.hk/~nmok/IMR2005-09.pdf`, Section 2.1 Main Theorem | In the applicable Hermitian-symmetric case: Fano Picard-one `X`, a minimal component, and projective equivalence of the **general VMRT** to that of the compact irreducible Hermitian symmetric model of rank at least two (`Gr(2,5)` qualifies); not just an abstract normalization or one special fibre. |

Consequently the abstract recognition implication with these hypotheses
is a known-result application; their discharge for the actual sixfold
is what is not established by the old Argus package. `C67_CP6_MAIN`
remains unproved there until this branch and the cited reductions are
assembled with exact scope. The numerical certificate and the three
Lean declarations cannot fill that obligation.

## Version, attribution and review disposition

`C67_PICARD` v2 and `C67_D4` v2 add citations without changing the
natural statements; they are not new proof versions of novel theorems.
The original manuscript owns the broader classification claim.
The old Argus work is a bounded numerical reconstruction and source
audit, with classification goals recorded in its ledger/graph. No
publication novelty of the full theorem or of its recognition step was
verified here.

`C67_SCOPE_LIMITS` v1--v2 remains correct: finite computation alone
cannot establish recognition, nor can a homogeneous example or bounded
no-witness search prove the full theorem. The later historical independent
review expressly excludes classification. The present partial assessment
therefore records supported branches and a specific unresolved general-VMRT
obligation; it does not manufacture either success or an access-failure
verdict.
