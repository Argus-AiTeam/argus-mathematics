# Fixed-scale radial comparison from the manuscript's rank hypotheses

## Result and scope

Fix a selected interior rank point p as in `differentiability.tex`: all
the f_C are differentiable at p, the moving-point directional conclusion
holds, there are three singleton times tau_i with distinct projective
directions d_i, and the three fixed common-normalization times t_i have
compact, pairwise projectively disjoint allowed direction sets D_p(t_i).
Then there is a finite C_p, independent of the integer T, such that

    for every T >= 2 there is h_p,T > 0;
    for every fixed 0 < h < h_p,T, eventually in j,
    V_j(p,h/T) >= U_j(p,h)/(C_p T),
    U_j(p,h/T) <= C_p V_j(p,h)/T.

This verifies `zoom.tex`, `eq:radial-comparison`, at the exact requested
quantifier order. It does not assert a common configuration threshold
over radii or points. No literal manuscript assertion is refuted.
The global halving-line theorem and the existence/measure of the selected
good part are outside this local result.

`Main.lean` proves the normalized analytic implication, including
noncollapse, inverse squeezing, projective conditioning, Euclidean
radial inequalities, and the diagonal quantifier principle. The
identification of the manuscript's objects with its hypotheses is
proved below in ordinary mathematics and is explicitly separated from
what Lean checks in `statement_fidelity.md`.

## Prior result and the mathematical improvement

Artstein-Avidan--Slomka, arXiv:1604.01762v1, Theorem 1.1, concerns an
injective map taking whole parallel families onto parallel lines and
concludes affine additivity; continuity then gives real affine
linearity. The actual statement and its following continuity remark
were read at <https://arxiv.org/html/1604.01762v1>. That theorem does
not supply sequence-level boundedness or prevent collapse before a
limit is obtained. It is not assumed in this proof.

The independently proved compactness theorem here allows continuous
maps that need not be injective, need not have expanding images, and
need not preserve lines exactly at finite indices. A common
linewise bounded-turning constant and the full moving-point limiting
direction condition suffice. Its complete proof is in `WebNotes.md`
and in the `ThreeDirection` namespace of `Main.lean`. This is a
structural strengthening of the manuscript's three-foliation lemma,
not merely compilation of pre-existing comparator code. No exhaustive
literature novelty claim is made before independent review.

## 1. Construct the normalized data, not a noncollapse assumption

Write R_j=(r_A,j,r_B,j):R^2 -> D=(0,1)^2 for the rank homeomorphism,
q_j=R_j^{-1}(p), and choose a fixed invertible B taking the three
projective d_i directions to horizontal, vertical, and slope one.
Let S_j take the three physical tau_i directions to those same
canonical families. Discarding finitely many configurations makes
all the chosen physical directions distinct and fixes their time
orders. This has no effect on any eventual assertion.

For small h>0 choose c_h,j>0 so that

    F_h,j(x) = B(R_j(q_j + c_h,j S_j^{-1}x)-p)/h

has max-norm |F_h,j(e1)|_infinity=1. Existence uses only continuity
along the forward tau_1 ray and properness over a compact subset of
the open rank square. The ray starts at zero and eventually exits
the closed max unit ball contained in B(D-p)/h. No estimate on c_h,j
is used.

On its actual domain set

    G_h,j(y) = c_h,j^{-1} S_j(R_j^{-1}(p+h B^{-1}y)-q_j).

Extend it arbitrarily outside that domain. Always G_h,j(F_h,j(x))=x.
Every fixed bounded set of rank inputs belongs to the domain for
all sufficiently small h; the extension is never used in a conclusion.

Choose the common physical normalization Q_j to send t_1,t_2,t_3
to the canonical triple. This is a permissible prescribed common
triple in the manuscript. A different prescribed fixed triple is a
single fixed linear change and only modifies C_p by a finite factor.
Put A0_j=Q_j S_j^{-1}, A_j=A0_j/|A0_j|_op, and
s_h,j=c_h,j |A0_j|_op>0. The exact identity is

    L_j(p+h w)-L_j(p) = s_h,j A_j G_h,j(Bw).

Thus |A_j|_op=1 is a choice of scalar normalization, not a lower
singular-value hypothesis. Both this identity and the positivity of
the scalar are carried explicitly in `NormalizedRankData`.

## 2. Rank monotonicity gives bounded turning

Each coordinate of B^{-1}F_h,j is a translated, positively rescaled
original rank coordinate along a normalized physical line. It is
monotone along each of the three source families. At an intermediate
segment point, each coordinate difference from the first endpoint
is therefore no larger in absolute value than the endpoint difference.
This is `RankGeometry.CoordinateSegmentControl`.

In the max norm, applying B and B^{-1} gives the common bound

    |F_h,j((1-t)x+t y)-F_h,j(x)|_infinity
      <= H |F_h,j(y)-F_h,j(x)|_infinity,
    H=|B|_op |B^{-1}|_op,   0<=t<=1.

`RankGeometry.turning_of_coordinates` checks this implication.
The source-to-target orientation signs may differ; no monotonicity
of F after the B change is presumed.

## 3. A valid cutoff from monotone squeezing

There is a cutoff N(h,k) with the following property: for every
positive h_k -> 0 and j_k >= max(k,N(h_k,k)), the expansion

    r_C,j_k(p+h_k w)
      = f_C(p)+h_k gradient(f_C)(p).w+o(h_k)

holds uniformly on every fixed bounded set of w, for every fixed C.
The same expansion holds on every further subsequence.

Here is a precise construction that does not assume local uniform
convergence to a possibly discontinuous f_C. Use the common countable
Cartesian dense grid on which all the finite coordinates were extracted.
For each fixed h,k, choose a finite Cartesian subgrid covering a rank
box around p of zoom radius

    R(h,k)=min(k, dist_infinity(p,boundary D)/(4h)),

with mesh at most h/(k+1), and slightly enlarge the box to allow
bracketing. Choose N(h,k) so that, at all these finitely many nodes
and for the first k coordinate functions, the finite-grid values are
within h/(k+1) of their extracted grid limits.

For each fixed zoom ball and fixed C, eventually the finite box
covers that ball and C is among the first k functions. Monotonicity
squeezes each value between nearby grid limits. The lower monotone
extension defining f_C also brackets each extracted grid limit
between nearby values of f_C. Differentiability at p therefore bounds
both bracketing errors by h times a quantity tending to zero, uniformly
on this fixed zoom ball; the grid mesh and grid-convergence errors
contribute O(h/(k+1)). This proves the claimed expansion.

In particular, this construction does NOT assert
sup |r_C,j-f_C|<=h/k on an entire fixed ball, does not interchange
the two limits, and requires no rate uniform in h or p.

For any moving pair on a canonical source line with finite image
limits a,b, the corresponding rank zoom endpoints are bounded.
The expansion and physical monotonicity of each r_C give all the
directional sign constraints on B^{-1}(b-a). At tau_i the allowed set
is a singleton, so b-a is parallel to the canonical direction i.
If the physical ordering reverses with j, take either order on a
subsequence; the conclusion concerns an unoriented line and is unchanged.
Zero displacement is allowed. This proves precisely
`ThreeDirection.MovingDirections`, including moving base points and
all further subsequences, on every admissible diagonal.

## 4. Noncollapse is proved, not inserted

The `ThreeDirection` theorem applies with the derived H. On any
admissible diagonal and any subsequence it produces a further
subsequence on which F converges locally uniformly to sigma id,
where sigma is -1 or 1. The proof first obtains finite-radius bounds
by triangle completion, propagates them to bounded source regions,
and then obtains exact scalar rigidity of every compact cluster map.
See `WebNotes.md` for the detailed argument. Neither equicontinuity
nor boundedness on source compact sets is an input.

## 5. The inverse rank order is already in the level-graph geometry

It remains to justify the inverse order used instead of a Jordan
curve theorem. An A-level graph has chord slopes in [ell_A,u_A];
a B-level graph has chord slopes in [ell_B,u_B]. Both windows lie
in K', separated from K and all the tau_i. Each scalar coordinate
of S_j is a linear functional with kernel a tau_1 or tau_2 direction.
Its value on the forward chord vector (1,s) consequently has a
constant nonzero sign throughout both slope intervals.

Along a B-level graph increasing r_A increases the original horizontal
coordinate; along an A-level graph increasing r_B decreases it.
These are exactly the signs established in `rank-limits.tex`.
Hence each scalar coordinate of

    w -> G_h,j(Bw)

is monotone in each rank coordinate, with its appropriate two signs.
On a max ball inside (D-p)/h, a comparison of two rank points follows
by changing one coordinate at a time; the intermediate corner remains
in that ball. This is the formal hypothesis `RankOrderOn`.
The signs may depend on the configuration, which the Lean theorem
explicitly permits. Every fixed ball is in the domain eventually.

The formal inverse-squeezing theorem uses four fixed forward sample
points near a target rank point. Their forward images approach the
four target orthants; inverse rank order traps each inverse coordinate
between the corresponding exact sample preimages. It gives local
uniform inverse convergence to sigma id without assuming inverse
continuity, inverse tightness, or surjectivity of an extension.

## 6. Derive the projective separation and linear conditioning

Let xi_i,j be a max-unit representative of the physical t_i direction
in the S_j-normalized plane. Form the compact, symmetrized sets

    E_i = { +/- B d / |B d|_infinity : d in D_p(t_i) }.

The projectivizations of the D_p(t_i) are compact and pairwise disjoint.
Therefore det(u,v) is nonzero on each E_i x E_l, i!=l.
Compactness gives one delta0>0 bounding all three absolute
determinants below.

Consider any admissible diagonal. If the xi triples failed the
delta0/2 separation infinitely often, restrict to those indices,
apply the proved forward compactness theorem, and extract limits of
the three max-unit xi vectors. Uniform convergence on the max unit
ball gives F(xi_i,j)-F(0) -> sigma xi_i. The moving-point directional
constraints at t_i put the limiting direction in E_i. Continuity of
determinant contradicts the assumed failure. Consequently, on every
admissible diagonal, all three determinants are eventually at least
delta=delta0/2. This constant depends on p and the fixed triples,
not on T, h, or the chosen diagonal.

By construction A_j takes these three input directions to the
canonical output triple. They meet `RankGeometry.Projective`, have
max norm one, and are delta-separated. These are exactly the
`normalizer_geometry` data; no singular-value lower bound is an input.

The formal theorem `RankGeometry.normalized_triple_bounds` proves:
for each delta>0 there is a>0, uniformly for all such norm-one
linear normalizers A and all x,

    a |x|_infinity <= |A x|_infinity <= |x|_infinity.

Its compactness proof is explicit. A singular candidate must annihilate
two of the three independent input lines, since its three output
directions are distinct. Cramer's identity then forces A=0, contrary
to norm one. The compact set of normalized triples, normalizers and
unit test vectors thus has a strictly positive minimum image norm.
This supplies, rather than assumes, the constants a and b=1 in the
radial estimate.

## 7. Euclidean radial comparison and the order of quantifiers

The formal Euclidean norm is sqrt(x_1^2+x_2^2), not the product max
norm. Put K=|B|_op+|B^{-1}|_op+1 and C_p=16 K^2/a.
For fixed T, uniform inverse error at most 1/(4KT) on the max unit
ball implies the two radial inequalities, by the derived linear
bounds and the elementary equivalence

    |x|_infinity <= |x|_2 <= 2 |x|_infinity.

The positive normalization scalar cancels. The value of C_p is
independent of T. `NormalizedRankData.iterated_radial_with_constant`
checks this estimate.

Finally suppose one fixed T violates the stated iterated conclusion.
There would be arbitrarily small FIXED h for which failures occur at
arbitrarily late configuration indices. Choose such h_k with
0<h_k<min(radius,1/(k+1)), then choose a failing
j_k>=max(k,N(h_k,k)). This is an admissible diagonal consisting
entirely of failures. Forward compactness, inverse squeezing, and the
derived linear bounds make both inequalities hold eventually on a
further subsequence, a contradiction.
`iterated_of_diagonal_subsequence` verifies this exact selection.

The formal conclusion is pairwise over every outer-circle and
inner-circle point. Continuity of the actual inverse rank map on
the two compact circles supplies their extrema. The pairwise
conclusion is therefore equivalent to the manuscript's U,V form,
not a substitute statement.

## Computational evidence

`verify.py` reruns the real Lean compiler through the official Argus
evidence command, checks the transitive axiom reports, replays a
rational primal/dual certificate for one normalized triangle bound,
and runs both official checks at the campaign root.

The inspected Jacobian operation was
`optimization.linear.rational_general_optimum.compute`. Its exact
payload and structured response are in `jacobian_payload.json` and
`jacobian_output.json`. The adapter rejected the payload at its
simplex-basis admission limit (exit 2), before mathematical execution.
This is a non-conclusion and is not support or refutation. The
standalone rational primal/dual replay is independent of that failed
adapter call; the general triangle bound is proved in Lean.
