# Quantified threshold consistency for shortcut extraction

## Statement and scope

Let H be a finite undirected loopless multigraph on at least two vertices.
Parallel edges have distinct indices. Suppose that H contains r edge-disjoint
spanning trees, where r and q are integers with 1 <= q < r. For an oriented
incidence vector b_e and a real symmetric positive definite matrix X, write

    R_X(e) = b_e^T X^(-1) b_e,
    F_s(X) = (V, {e in E(H): R_X(e) <= s}).

Let P_s(X) be the partition into maximal q-tree-packable vertex sets in F_s(X),
and let B_s(X) be all H-edges crossing that partition, not just its F_s(X)-edges.
Let K be a nonempty compact convex set of such positive definite matrices.
Let alpha > 0 and 0 <= delta < u := 1 - q/r. Assume the simultaneous response
property:

    for every X in K there is Y in K such that, for every s > 0,
    #{e in B_s(X): R_Y(e) > alpha} <= delta |B_s(X)|.       (SR)

**Theorem (quantified threshold consistency).** There is X in K for which
F_T(X) contains q edge-disjoint spanning trees, where

    T = alpha u/(u - delta)
      = alpha (r-q)/(r-q-r delta).

Every quantifier in (SR) matters: Y is chosen after X but before s, and the
crossing edges belong to H. The threshold is inclusive. There is no bound on
the graph order or on the number of threshold changes. Compactness, convexity,
positive definiteness, the packing slack, and the strict condition delta < u
are not omitted.

The theorem above is conditional on (SR). The application below proves (SR)
from the manuscript's stated hierarchy input; it does not leave (SR) as an
unproved assertion. The hierarchy input itself is an external dependency, not
a verification of its appendix, and neither result verifies the subsequent
sparsification, signing, iteration, or polynomial-time claims.

The live mission refers to a theorem "below" without providing an additional
formula in its text or OBJECTIVE.md. The displayed theorem is the explicit
quantified reading of the extraction question established here.

## Proof of the consistency theorem

We use the following standard finite-graph facts. Maximal q-tree-packable
vertex sets form a partition, and these partitions coarsen when edges are
added. For a nontrivial maximal partition with d parts,

    |E_F(P(F))| < q(d-1).                                  (1)

These are precisely Lemma `lem:packing-parts` in the companion manuscript.
For completeness, intersecting packable sets can be united by contracting
their intersection in each colored tree and adjoining a quotient tree.
This proves disjointness of maximal sets and monotonicity. To prove (1),
contract the maximal sets. If the quotient had at least q(d-1) edges,
choose an inclusion-minimal vertex set W, |W| >= 2, with
|E(W)| >= q(|W|-1). Every proper induced set J has at most q(|J|-1)
edges. Subtracting these bounds for any partition of W proves the
Nash--Williams--Tutte inequalities. The resulting q quotient trees lift
using the q internal trees, contradicting maximality. This argument uses
the classical tree-packing criterion, not merely a total-edge-count
criterion for an arbitrary graph.

First prove the conclusion for every t > T. Choose theta so that

    delta/u < theta < 1 - alpha/t.

Such a theta exists, satisfies 0 < theta < 1, and gives

    delta r < theta(r-q),       alpha/(1-theta) < t.         (2)

For each positive integer p choose a finite relative open 1/p-ball cover
of K with centers C_pj in K. Choose a response Y_pj to each center using
(SR). The continuous nonnegative weights

    w_pj(Z) = max(0, 1/p - ||Z-C_pj||)
              / sum_h max(0, 1/p - ||Z-C_ph||)

sum to one. The denominator is strictly positive because the cover is
open. Thus Phi_p(Z) = sum_j w_pj(Z) Y_pj is a continuous K-valued map.
The finite-dimensional compact-convex Brouwer theorem supplies a fixed
point X_p. Compactness gives a subsequence X_p -> X in K.

Choose s strictly between alpha/(1-theta) and t, avoiding the finite set
{R_X(e): e in E(H)}. All active centers satisfy

    ||C_pj-X|| < 1/p + ||X_p-X|| -> 0

uniformly in j. Each resistance is continuous on the positive definite
cone. Consequently, eventually every active center has exactly the same
threshold graph, maximal packing partition, and crossing set at s as X.
Write this common crossing set as B and M = |B|.

For each edge e in B define its bad weight

    m_pe = sum_j w_pj(X_p) 1_{R_Y_pj(e) > alpha}.

Summing (SR) over responses gives sum_{e in B} m_pe <= delta M.
Hence the number of edges with m_pe > theta is at most delta M/theta.
For every other edge the good weight is at least 1-theta.

The exact rank-one resistance equivalence is

    R_Y(e) <= alpha  iff  b_e b_e^T <= alpha Y

in positive semidefinite order. One proof is congruence by Y^(-1/2);
the rank-one matrix (Y^(-1/2)b_e)(Y^(-1/2)b_e)^T has only the possible
nonzero eigenvalue R_Y(e). Adding the good response inequalities and
using positive semidefiniteness for all other responses gives

    X_p >= ((1-theta)/alpha) b_e b_e^T,
    R_X_p(e) <= alpha/(1-theta).

It follows that at least (1-delta/theta)M edges in B obey this last
closed inequality. This count passes to X: the condition that at least
ceil((1-delta/theta)M) members of a finite edge set satisfy a continuous
closed inequality is a finite union of finite intersections of closed
sets. This does not claim that the identity of the good edges is constant
along the original sequence.

If the partition P_s(X) has d > 1 parts, the original r trees imply
M >= r(d-1). The retained edges lie in F_s(X), so (2) gives

    |E_F_s(X)(P_s(X))| >= (1-delta/theta) M
                      >= (1-delta/theta) r(d-1)
                       > q(d-1),

contradicting (1). Thus F_s(X), and therefore F_t(X), is q-tree-packable.
If M=0, connectedness of H already forces the partition to have one part.
No division by M or d-1 is made in that case.

To reach the endpoint T, take t_k = T+1/k. There are only finitely many
indexed q-tuples of pairwise edge-disjoint spanning trees in H. Some
tuple occurs for infinitely many of the matrices just constructed.
Along a further convergent subsequence in compact K, continuity of each
of its finitely many edge resistances gives R_X(e) <= T. This proves
the inclusive endpoint, including delta=0. No claim is made when
delta >= u, when the denominator need not be positive.

## Establishing the response from the hierarchy input

Here is the sole nonclassical external input used by the application:
Theorem `thm:hierarchy-power` in the companion manuscript. For every
sufficiently large integer q, every locally q-connected hierarchy in H,
and every marked collection of nonroot nodes satisfying

    |O(A)| >= |P(A)|/q,

there is a positive definite shortcut D with proper nonempty cut bound
1_S^T D 1_S <= |delta_H(S)| and average R_D on every marked O(A)
at most q^(-31/40). The cutoff q_H is independent of graph order,
hierarchy depth, and the marked collection. Here P(A)=delta_H(A) and
O(A)=E_H(A,parent(A) \ A). The assumption is the exact theorem, not
an assertion that the cited Anari--Oveis Gharan result has identical
exponents without a derivation.

The primary source `arxiv:1411.4613v4` was obtained and read, not just
registry-resolved. Its Section 3.1 definition (printed page 19) has
exactly the local connectivity and marked-boundary hypotheses with
parameters k and lambda; its Theorem 3.5 (printed page 22) supplies
average resistance at most f1(k,lambda)/k, where f1 is polylogarithmic
in k and 1/lambda, with no graph-order dependence. Its Section 1.2
defines shortcut domination on proper nonempty cuts. Substituting
k=q and lambda=1/q is admissible for q>1. For fixed absolute C and d,
the resulting bound is at most C(1+log q)^d/q, which is
o(q^(-31/40)), since (1+log q)^d/q^(9/40) tends to zero.
An absolute cutoff therefore gives the stated hierarchy input without
requiring a new proof of the companion's hierarchy appendix. The
exact source conditions and statement are retained in `aog_excerpt.txt`;
independent citation attribution is still a Reviewer obligation.

Set

    u0 = r^(-1/16),  q = floor((1-u0)r),
    alpha = r^(-1/2),
    K = {X symmetric: X >= L_H + I/n,
         1_S^T X 1_S <= 3 |delta_H(S)| for proper nonempty S}.

For sufficiently large r, q >= r/2, q >= q_H, q > 1, and r >= 2^31.
K is nonempty because L_H+I/n belongs to it; connectedness gives
|S|/n < 1 <= |delta_H(S)|. It is convex and closed. The singleton
cut bounds control diagonal entries, and positive semidefiniteness
gives |X_vw|^2 <= X_vv X_ww, so it is bounded and hence compact.
Its elements are uniformly at least I/n.

Fix X in K. The B_s(X) are nested decreasing finite edge sets. In every
occupied dyadic bin 2^a <= |B_s(X)| < 2^(a+1), choose the finest
partition occurring in that bin. List these representatives from fine
to coarse as P_0,...,P_(l-1), with crossing sets B_i of size M_i,
and append the root partition P_l={V}, B_l=empty.

The distinct representative parts, all singletons, and V form a
laminar hierarchy. Its nonsingleton parts are q-edge-connected because
each contains q disjoint trees in an appropriate F_s(X); the root
is r-tree-packable. Every nonroot O-boundary is a nontrivial cut in its
parent's q-edge-connected induced subgraph, so its size is at least q.
If a part changes between adjacent representatives,
its immediate parent in the hierarchy is exactly its containing part
at the next representative. An earlier representative cannot contribute
an intermediate superset, and a later one cannot contribute an
intermediate subset. Adding singleton leaves cannot do so either.

Apply the hierarchy input to this one hierarchy, marking precisely
the nodes satisfying |O(A)| >= |P(A)|/q. Put Y=L_H+I/n+D. It belongs
to K by the cut bounds, and inverse monotonicity yields

    average_{e in O(A)} R_Y(e)
       <= q^(-31/40) <= r^(-3/4)                         (3)

on marked nodes. The last inequality follows from q >= r/2 and
r >= 2^31 (equivalently q^31 >= r^30).

For transition j, every edge in B_j \ B_(j+1) joins two changing
parts with the same parent and belongs to both their O-boundaries.
The sum of full boundaries of changing parts is at most 2M_j.
Unmarked O-boundaries therefore cover at most 2M_j/q edges.
By (3), the number of edges in a marked O-boundary with R_Y > alpha
is at most r^(-1/4)|O(A)|. The total bad disappearing count is at most

    2(r^(-1/4) + 1/q) M_j.                               (4)

Overcounting edges only increases this upper bound. The selected
dyadic exponents strictly decrease. If 2^a <= M_i < 2^(a+1), then

    sum_{j>=i} M_j <= sum_{b=0}^a 2^(b+1)
                    = 2^(a+2)-2 < 4M_i.                 (5)

Every edge of B_i disappears at one of these transitions. Equations
(4)--(5) give at most 8(r^(-1/4)+1/q)M_i bad edges in B_i.
For an arbitrary s with M_s>0, its bin representative is finer,
so B_s is a subset of B_i and M_i<2M_s. Therefore

    #{e in B_s(X): R_Y(e)>alpha}
       <= 16(r^(-1/4)+1/q) M_s
       <= 40 r^(-1/4) M_s.                              (6)

The final inequality holds at a sufficiently large absolute r.
For M_s=0 it is immediate. The matrix Y was chosen only once,
so (6) is genuinely simultaneous for all s. This proves (SR);
it is not a premise imported from the desired extraction conclusion.

## Application and improvement over the source

Let u=1-q/r, which is at least u0. With delta=40 r^(-1/4)
and sufficiently large r, delta<u0<=u. The consistency theorem gives
q disjoint trees whose edges all have resistance at most

    alpha u/(u-delta)
      <= r^(-1/2)/(1-40 r^(-3/16)).                      (7)

The matrix also satisfies L_H <= X and the manuscript's proper-cut
upper bound. For r large enough that 40 r^(-3/16) <= 1/2,
(7) is at most 2r^(-1/2), in particular below the source's
4r^(-1/2). The bound is (1+o(1))r^(-1/2) rather than the
source's fixed constant 4; the inclusive endpoint is also justified.
The exact hierarchy-derived error in (6) can be used instead of 40
for a slightly smaller bound. None of these constants depends on n.

This is an independent verification and quantitative strengthening
of the extraction bridge **conditional on the hierarchy theorem**.
It is not a counterexample and not a proof of the complete strong
thin-tree theorem. No false literal manuscript assertion has been
identified in this trace, so no refutation judgement is manufactured.
Novelty beyond this explicit comparison requires independent review;
the inherited Wiki index had no directly matching thin-tree entry.

## Certification boundary

The companion sources are under
`research/openai_manuscript/The-strong-thin-tree-conjecture-September-23-2026/build/source/`.
The exact source locators are `sections/extraction.tex`, Lemma
`lem:response` and Theorem `thm:extraction`; `sections/hierarchy.tex`,
Theorem `thm:hierarchy-power`; and `sections/preliminaries.tex`,
Lemmas `lem:resistance-order` and `lem:packing-parts`.

`ExtractionConsistency.threshold_consistency` in `Main.lean` now checks
the complete abstract compact consistency argument, including its
continuous convexification of arbitrary responses, subsequence limit,
stable threshold pattern, packing contradiction, and inclusive endpoint.
It takes Brouwer's fixed-point property as an explicit external premise.
It does not assume that the discontinuous response itself is continuous,
or that a suitable interpolating map or consistent matrix already exists.

Here is the precise application dictionary for its other interfaces.
`B` is B_s(X); identical edge-threshold patterns give identical threshold
graphs and hence identical maximal packing partitions. `Packed X s`
means q-tree-packability of F_s(X), extending the same inclusive edge
formula to all real s. It is monotone. Its locus in K times R is closed:
for each fixed q-tuple of disjoint trees the finitely many inequalities
R_X(e)-s<=0 are continuous closed conditions, and there are only finitely
many tuples. If packing fails at positive s, set d=|P_s(X)|-1>0.
The original r trees give r*d<=|B|, and the strict quotient obstruction
gives fewer than q*d threshold edges in B. Actual inverse resistances
are continuous on K because inversion is continuous on nonsingular
matrices. These are exact graph-to-interface proofs, not new conjectural
response assumptions. The response hypothesis is discharged by (3)--(6).

The separate Lean statement-fidelity document records all these explicit
interfaces and names the checked declarations. Neither the Brouwer input
nor the graph interpretation or the hierarchy literature theorem is
silently promoted to an unconditional formal proof. The Python certificate
replays exact identities and finite adversarial cases and binds the real
compiler result to its source and fidelity document; finite tests are not
presented as proof of the universal theorem.

## Reproduction

From the campaign root, the exact replay is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/extraction_consistency/verify.py
```

The real compiler command, not a simulated compiler verdict, is:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/extraction_consistency/Main.lean --statement-fidelity research/extraction_consistency/statement_fidelity.md --project-root . --claim C_TC_COMPACT_CORE
```

The archived certificate records Lean 4.31.0, exit code zero and no proof
holes. `C_TC_COMPACT_CORE` remains explicitly conditional on its Brouwer
input, and independent statement-fidelity, source attribution and
publication-significance review remain required.
