# Signed marked-cap detection

## Scope and source

The question is the **universal pointwise** inequality
`eq:pointwise-detection`, not convergence to CLE4. The source is the staged
September 23, 2026 manuscript, `build/sections/30-short-segment.tex`.
Rectangles have odd dimensions, the vertex (1,1) deleted, and the seam
particle convention of `build/sections/20-transfer.tex`. No modification of
the manuscript or its measure is made.

The literal assertions under examination are:

* `lem:marked-cap`: "The resulting vector V satisfies
  ||V|| <= M^k ||V_ordinary||", and its expansion has "precisely the
  ordinary edge multiplicities."
* `lem:color-contractions`: the same-loop signed color ratio is `uv/2`;
  the distinct-loop ratio is `-t_g t_g'/4`.
* `lem:cap-weight-decrease`: for nested separating loops,
  `U_g' <= U_g/2` and `V_g' <= V_g/2`.
* `eq:pointwise-detection`: `X_(M,I) >= q_M^2/16` on the cutoff event
  when condition (i) or (ii) holds, and `X_(M,I) >= 0` otherwise, with
  `q_M = (2M)^(-(M-1))`.

The cutoff, deep lines, eligible cap arches, source signs (++ left,
-- right), sitewise multiplicities, single-hit ranks starting at 1,
sink signs (+ on the left, - on the right), and increasing-wedge parity
are part of the assertion.

The focal source equation, without changing its quantifiers or event, is:

```tex
 X_{M,I}\ge\frac{q_M^2}{16}\,
 \1_{E_M\cap\{\textnormal{condition (i) or (ii) holds on }I\}}.
 \label{eq:pointwise-detection}
```

`exact_certificate.json` also retains the complete verbatim statements
of the three named geometric/color lemmas, the chain lemma, and the
displayed detection equation, extracted from the staged sources.

## Scoped prior results and non-results

A bounded primary-source lookup by the literature worker inspected:

1. Basok--Izyurov, **arXiv:2501.01574v1**, Section 1, Theorems 1 and 2:
   nesting-count fluctuations and convergence of the centered nesting
   field in negative Sobolev topology. Section 1 explicitly distinguishes
   topological/field information from curve convergence.
2. Kenyon, **arXiv:1105.4158v2**, Sections 4, 5.1 and 5.2, Theorem 4 and
   Corollary 5: flat-connection partition functions and the distribution
   of noncontractible-loop laminations. Nonnegative coefficients in
   that expansion are not pointwise nonnegativity of the present signed
   observable.
3. Rasmussen--Ruelle, **arXiv:1207.0385v1**, Introduction and Section II.2,
   equations (2.2)--(2.4): spin-state transfer-matrix ancestry. Section
   IV A was not inspected by that lookup.

No prior result establishing the combined tears, signed two-site
insertion, cap-local weighting and detection inequality was found in
those passages. This bounded finding is **not** a novelty certification.
The sources were obtainable. None of those external propositions will
be an assumption of the finite combinatorial verification below.
Topological convergence alone is a retired route to curve convergence,
not evidence against the pointwise claim.

The inherited project Wiki index has no matching dimer, marked-cap,
positivity, CLE, or campaign-9000226 entry.

## Dependency boundary

The main convergence theorem uses rectangle traversal tightness,
rectangle short-interval exclusion, localization, compactness,
finite-puncture identification, and no reverse passage. The present
route addresses only the signed observable underlying short-interval
exclusion. The analytic insertion bound, cap normalization, limiting
argument, localization, and final identification remain outside this
verification.

The signed-observable route has four obligations: cap gluing and its norm
comparison; exact color counting; geometric nesting-to-weight reduction;
and the alternating-chain inequality and event detection. Finite tests
are diagnostics, not substitutes for any of these universal obligations.

## Universal verification and extension

**Theorem.** Fix any real cutoff M >= 1 and any real number B with
B >= 1 and B > M-1. Retain all the manuscript's legal configurations,
three seams, deep lines, eligible arches and cutoff event E_M. Give an
eligible arch A the cap-local weight

    w_B(A) = B^(-b(A)),
    q = B^(-(M-1)),    r = (M-1)/B.

Define X^B by the manuscript's actual modified color counts, not by an
assumed formula for their signs. Set it to zero off E_M. Then, for
every configuration,

    X^B >= 0,
    X^B >= ((1-r)^2 q^2 / 2) 1_{E_M and (i or ii)}.             (T)

The cap-vector norm comparison and the identity between the normalized
contraction and the expectation of X^B also hold. These statements have
no asymptotic or bounded-enumeration qualification.

In particular:

* **Unchanged manuscript weights B=2M:** (T) gives the coefficient
  `(M+1)^2 q_M^2/(8M^2)`, hence proves the literal, weaker coefficient
  `q_M^2/16` in `eq:pointwise-detection`.
* **Additional weights B=M:** (T) gives the coefficient
  `1/(2 M^(2M))`. This changes only the optional weights in the
  auxiliary observable, not the matching law, events, or manuscript.
  The original weights remain separately verified.

### 1. Legal uncolored gluing and the marked-cap norm

In a cap, an ordinary uncolored diagram has degree two at each interior
vertex, with a doubled edge counted twice. Its single components are
closed even cycles and paths between distinct single seam edges.
The missing-corner incoming edge is doubled, so it creates no open
single component. A pair of endpoint particle states determines the
total edge multiplicity at each seam site, including complemented rows.

For two diagrams contributing to a squared cap norm, incompatible
multiplicities give zero. With compatible multiplicities, their arch
pairings form a multigraph on the single seam sites. Each site has one
incident arch from each diagram. Thus each connected component is an
even cycle, including a possible two-edge cycle. Opposite-sign
constraints on its arches have exactly two solutions.

Replacing an arch constraint by a prescribed equal-sign tear fixes both
of its endpoints. On a component with any such tear, every remaining
unmodified path has a fixed endpoint and therefore has at most one
compatible assignment; a component without tears still has two.
Internal closed loops retain their factors of two. Consequently the
modified count for each pair of diagrams and each pair of mark lists
is at most its ordinary count. There are at most M^k ordered mark
lists on each side and all list weights lie in [0,1]. Summing this
termwise inequality and taking square roots proves

    ||V|| <= M^k ||V_ordinary||.

This proof does not assert that a torn cap itself consists of legal
matchings. Only its endpoint coefficient rule is used.

Now insert ordinary two-replica transfer between the caps. Erasing
colors preserves all cap and transfer edges and their multiplicities.
Equality of seam particle states preserves the edge multiplicities on
gluing. The middle insertion also preserves these multiplicities: on
complemented rows it changes b1,b2 in the opposite order, but not their
sum. The glued graph is therefore degree two everywhere. It consists
of doubled edges and simple even lattice cycles, hence has an ordinary
coloring into two legal perfect matchings. Conversely, cutting such a
configuration at the specified seams recovers its uncolored pieces
uniquely. Mark selections, not ordinary colorings of a torn arch, are
the additional summed choices.

An uncolored configuration with ell single cycles has exactly 2^ell
ordinary colorings. Its contribution to the modified contraction is
the modified count with the insertion sign and mark weights. Since its
probability under the ordered pair of uniform matchings is
2^ell/Z_dd, summing proves `eq:observable-contraction` exactly.
There is no omitted multiplicity or positivity assumption.

### 2. A two-state derivation of the signed color ratios

Orient the traversal parameter of each uncolored cycle arbitrarily.
Along an ordinary strand there are two coherent orientations, recorded
as + and - relative to that parameter. Giving the first matching's
edges direction black-to-white and the second's white-to-black
identifies an ordinary coloring with one of these orientations.
At a seam its signed horizontal direction is exactly q1-q2, also
when the particle convention complements edge occupancy.

A tear can be represented at any point in its selected cap arch.
Both branches point away from a source. Thus a source in the left
cap gives physical seam signs ++, while a source in the right cap
gives --, as prescribed. These are both sources, not a source and a
sink. The middle insertion gives (+,-) on its left and right sides;
both strands point toward that site, so this is a sink.

The two traversal orientations form a two-state space, in the ordered
basis (-,+). Ordinary propagation is the identity. With rows denoting
outgoing and columns incoming states, a source and sink have matrices

    S = [[0,0],[1,0]],    T = [[0,1],[0,0]].

Counting assignments on a closed cycle is the trace of the composed
transitions (last transition on the left). This follows by summing the state
at every junction, so it counts the endpoint rules directly. In
particular,

    tr(I)=2,   tr(ST)=tr(TS)=1,
    tr(STST)=1,   S^2=T^2=0.

With two sources and two sinks on one loop, the trace is one precisely
when the events alternate cyclically, and zero otherwise. Equivalently
there is one sink on each of the two source-to-source arcs. A marked
loop without an available sink has trace zero. With sources on two
different loops, one sink must lie on each, and each loop has trace
one. All unmarked loop factors cancel in the ratio. This also proves
that a remote source can be moved inside the same middle-seam arch
without changing the calculation or its multiplicity.

Rank all single hits of the *whole* middle seam increasingly, starting
at 1, and set sigma_r=(-1)^r. The exterior deletion/creation parity is
`-sigma_i sigma_j`: there are j-i-1 single hits strictly between.
On a fixed simple loop, sigma agrees with the oriented horizontal
intersection sign up to a single common factor epsilon in {+1,-1}.
Indeed the interior/exterior status alternates at its successive
hits; every other disjoint loop contributes an even number of hits
between any two of them, since both selected points have the same
status relative to that other loop.

For sources on one loop, direct both complementary arcs from the left
mark to the right mark. Their directions are opposite relative to the
coherent whole-loop orientation. Thus for one sink on each arc the
extra minus in the insertion parity cancels, leaving the product of
the two arc-intersection signs. Summing all such pairs gives

    (1/2) (sum over first arc) (sum over second arc) = uv/2.    (C1)

These are unordered distinct sink pairs: each has a unique member on
each arc, so there is no extra factor of two. The whole-loop
intersection in the first arc's orientation is u-v. For a simple
polygon it is in {-1,0,1}: along the seam, the indicator of its
interior changes only at these transverse crossings and telescopes
between the endpoints of I. Integers with |u-v|<=1 have uv>=0, and
uv>=1 when both are nonzero.

For distinct marked loops, the ratio of modified to ordinary counts
is 1/4 for every pair with one sink on each. There is no arc reversal
to cancel the insertion minus. Summing gives

    -(1/4) (sum of sigma on g in I) (sum on h in I)
      = -t_g t_h/4.                                        (C2)

This derives both ratios from the actual source and sink rules. In
particular it does not replace signed counting by a putative positive
observable.

### 3. Endpoint chains and the geometric cap reduction

Let A,B be the lower and upper endpoints of I, off the graph. For a
loop g let d(g) count its strictly enclosing loops. Just below a hit
entering g, exactly its ancestors contain the nearby point of the
seam. Therefore its rank sign is -(-1)^d(g); leaving has the opposite
sign. Telescoping yields

    t_g = -(-1)^d(g) (1_{B inside g} - 1_{A inside g}).         (N)

Thus only loops separating A and B have t_g != 0. They form at most
two chains: the ancestors of A but not B, and those of B but not A.
After their common ancestors are omitted, signs alternate within
each chain, and the two outer signs are opposite. Consecutive
members of one chain have consecutive ancestor depths: an ancestor
between two separators would itself separate the endpoints. This
justifies the two-chain reduction without discarding intervening
weights or changing the ranks.

Here is the essential cap-geometric step. Suppose separating g'
lies inside separating g, and A' is any eligible arch of g' in one
cap. Since g reaches the middle seam, it is not entirely in that cap.
Its intersections with the open cap are disjoint simple arches.
Close each such arch A by its cap-seam interval to form a polygonal
disk D_A. In the open cap the indicator of the interior of g is,
modulo two, the sum of the indicators of these D_A. Both sides
change at exactly the same boundary arcs and are zero sufficiently
far into the unbounded side of the cap. This proves the identity
cell by cell in the finite polygonal subdivision; no smoothness or
continuum limit is required.

An interior point of A' is inside g, hence is in at least one D_A.
The connected interior of A' cannot leave that disk without crossing
A or the cap seam. Its two seam endpoints are therefore strictly
between those of A. They cannot coincide, since the lattice loops
are disjoint. The extremal longitudinal coordinate of D_A is attained
on its boundary arch or the seam. Since A' reaches the deep line,
A does too. Hence **this containing arch is eligible**, a fact not
supplied by an abstract nesting diagram alone.

Every eligible arch strictly spanning A also strictly spans A', and
A supplies one more. Consequently b(A')>=b(A)+1 and
w_B(A')<=w_B(A)/B. If there are any inner eligible arches, at least
one eligible outer arch exists. The cutoff on *all* eligible arches
in the cap then gives at most M-1 inner choices, rather than M. Counts are integers
but these inequalities are real inequalities, so this also covers
nonintegral cutoffs without changing E_M.
For the left-cap totals U and right-cap totals V this proves

    U_g' <= ((M-1)/B) max_{A subset g} w_B(A) <= r U_g,
    V_g' <= r V_g.                                         (G)

A zero outer total forces a zero inner total. If no inner choice
exists, (G) holds directly, including M=1. Finally b(A)<=M-1,
so every positive total is at least q. These arguments use actual
eligible arches, not assumptions that all nested loops visit both
deep regions.

**Elementary polygonal justification of the separation facts.** No
smooth Jordan-curve or Schoenflies theorem is needed here. Subdivide
the finitely many lattice edges at the seams. For a closed simple
polygon P, assign to each complementary cell the parity chi_P of
intersections of a generic ray to infinity with P. Moving the ray
across a vertex changes its number of intersections by an even
number; thus this parity is well defined, zero far away, and changes
by one across each edge of P. A function with those jumps and that
exterior value is unique: the difference of two candidates has zero
jump across every cell adjacency and is consequently constant.

The cell values immediately on the left of an oriented simple
polygon remain the same along an edge and through a vertex. At a
vertex of degree two, the two local left-hand sectors are connected
without crossing the path, whether the path turns or goes straight.
The right-hand value is the opposite one. Thus the oriented crossing
sign equals a fixed sign times the change of chi_P along the seam.
This proves the whole-loop intersection bound and the rank-sign
comparison used above.

For two disjoint polygons P,Q, chi_P is constant along Q and chi_Q
is constant along P. Their values cannot both be one: in that case
the indicator of the union of their parity regions would have zero
jump at either boundary and value zero at infinity, yet would be one
near either polygon. If both values are zero, the product chi_P chi_Q
has zero jump everywhere and vanishes at infinity, so their parity
regions are disjoint. If chi_P is one along Q and chi_Q zero along
P, the function chi_Q(1-chi_P) similarly has zero jump and exterior
value zero; the parity region of Q is contained in that of P.
This proves the required laminarity and endpoint ancestor chains.

Likewise, the D_A argument needs only the bounded parity-one region
of the polygon formed by A and its seam segment, not a separately
assumed disk theorem. Its boundary in the open cap is exactly A,
and its trace just inside the seam is one exactly between A's
endpoints. The parity sum has the same jumps as chi_g in that
half-plane and vanishes on its far side; uniqueness proves the
identity used in the cap reduction. A disjoint connected A' keeps
the same value until its endpoints, establishing strict spanning.
Outside the longitudinal range of A and the seam, this parity
region is empty, which proves the deep-line assertion as well.
All these are finite cell arguments; they do not assume the weight
inequality they establish.

### 4. Universal signed positivity and quantitative detection

By (C1)--(C2) the observable splits as X^B=S_same+D, where S_same is
the sum of the weighted nonnegative same-loop terms and

    D = -(1/4) sum_{g != h} U_g V_h t_g t_h.                  (D)

Nonseparating loops vanish from (D). On one separator chain write
weights in outer-to-inner order as U_i,V_i. For any nonnegative
r-decaying sequence, induction on its length gives

    (1-r) z_i <= z_i-z_{i+1}+z_{i+2}-... <= z_i.             (A)

For the induction, the tail alternating sum is between zero and
z_{i+1}<=r z_i. This proof includes empty tails and zeros.
Grouping (D) by its outer member gives the within-chain contribution

    (1/4) sum_i [U_i (V_{i+1}-V_{i+2}+...)
                   + V_i (U_{i+1}-U_{i+2}+...)].             (W)

Every summand is nonnegative by (A). For two chains, after absorbing
their opposite outer signs, the cross contribution is

    (1/4) [A_U(C1) A_V(C2) + A_U(C2) A_V(C1)],              (K)

where A is the alternating sum from the head. This is nonnegative
as well. Formulas (W) and (K) exactly partition the ordered sum (D);
they are not bounds on only part of it.

For completeness they prove the manuscript's more general abstract
`lem:two-chain-positivity`, not just the geometric event. If any
off-diagonal U_i V_j is positive within one chain, positivity
propagates outward by (G). In the group of the outer index its
relevant first inner weight and outer weight are at least q.
That group is at least `(1-r)q^2/4`. A positive off-diagonal product
between chains similarly gives at least `(1-r)^2 q^2/4` from
one product in (K). At r=1/2 this is q^2/16 as stated.

For the actual event (ii) there is a stronger fact: in the absence
of (i), **each of the two tested loops has positive weights in both
caps**, not merely one off-diagonal product. If they lie in one
chain, its first two members each have U,V>=q, because zero
weights propagate inward. Both terms in the first group of (W)
then give together at least `(1-r)q^2/2`, which is at least
`(1-r)^2 q^2/2`. If they lie in different chains, all four head
weights are at least q, and both products in (K) give together at
least `(1-r)^2 q^2/2`.

It remains to justify the event-to-mark assertion, rather than
assuming it. A tested arc has one endpoint in each deep region.
The corresponding loop meets the middle seam, and each endpoint
belongs to a unique eligible arch in its cap. Moving that endpoint
to the source within the same cap arch crosses no part of I.
If the tested arc has intersection a and the whole oriented loop
has intersection e, the two mark-to-mark sums have product a(a-e),
also when the tested arc starts at the right. Under (i),
a is an integer different from 0 and e, while e is -1,0, or 1.
Thus a(a-e)>=1. This one same-loop term is at least q^2/2.
All the remaining same-loop terms and D are nonnegative.

Under (ii) without (i), each nonzero tested-arc sum equals its
whole-loop sum, so each tested loop separates A,B and has one
eligible arch in each cap. The preceding two-chain threshold
therefore applies. This proves (T) in both cases.
Off E_M the observable and the indicator are both zero. Missing
deep regions, empty intervals, and endpoints outside the rectangle
are covered: the event is then either empty or the same indicator
and crossing arguments apply unchanged.

### 5. Optimization of the additional weight family

The guaranteed coefficient in (T) is

    c(B) = (B-M+1)^2 / (2 B^(2M)).

It is maximized over B>=1, B>M-1 at B=M. For integer M>=2 set
x=B-M+1>0. The arithmetic-geometric mean inequality for x and
M-1 copies of 1 gives

    B^M = (x+M-1)^M >= M^M x.

Thus c(B)<=1/(2 M^(2M)), with equality at x=1. One can avoid
invoking that inequality as an external result: the function
`M log((x+M-1)/M)-log(x)` has derivative
`(M-1)(x-1)/(x(x+M-1))`, is minimized at x=1, and is zero there.
For M=1, c(B)=1/2 for every B>=1; B=1 is an optimizer,
but is not the unique one.
The derivative proof applies to every real M>1, not just integer
cutoffs. Thus the original real-cutoff convention is preserved.
This is optimization of this **proved lower bound and weight
family**, not a claim that the actual geometric detection constant
is sharp among all possible observables.

## Computational and formal meaning

`verify.py` checks legal nearest-neighbor perfect matchings before
constructing any diagrams. It extracts single loops and cap arches
from their edge multisets. A parity-constraint propagation counts the
modified assignments directly on all three cut seams; it never uses
(C1) or (C2) to produce the count being compared with those formulas.
Its independent admissibility checks include the missing corner,
degree-one matching condition, cycle simplicity, ordinary denominator,
strict cap spanning, and the precise insertion sign.

The finite diagnostics include all 99 uncolored configurations from
the 225 ordered matching pairs of the 5 by 3 rooted rectangle, a
deterministic 384-configuration diagnostic in the 5 by 5 rooted
rectangle, and explicit legally completed three-nested-loop and
two-chain examples in 9 by 9 and 9 by 15 rooted rectangles.
Additional 5 by 3 and 7 by 5 examples test the boundary cutoff M=1
and the nonintegral cutoff M=5/2, respectively. Their bounds are
evaluated as exact rationals by using q^2 directly; no fractional
power is approximated.
The latter examples have negative **individual** marked-loop terms;
the complete observable, not those terms separately, is tested.
These are exact rational tests, not evidence that finite enumeration
settles the unbounded theorem.

The verifier checks both B=2M (including the literal manuscript bound)
and B=M, with the sharper decay (M-1)/B, on the same independently
counted signed assignments. In the 9 by 9 example it checks 846 raw
sink counts and finds 16 negative individual mark-pair sums; the
9 by 15 example checks 8,096 raw sink counts and has 96 negative
individual mark-pair sums. This explicitly exercises the cancellation
mechanism rather than checking only examples whose summands are all
positive.

Selected exact replay values (intervals list the included seam rows):

| Rectangle | M | Interval | Negative mark-pair sums | X with B=2M | X with B=M |
|---|---:|---|---:|---:|---:|
| 5 by 3 | 1 | 1--3 | 0 | 1/2 | 1/2 |
| 7 by 5 | 5/2 | 1--3 | 0 | 1/10 | 1/5 |
| 9 by 9 | 3 | 1--3 | 2 | 31/432 | 7/54 |
| 9 by 15 | 4 | 2--10 | 2 | 65/128 | 17/32 |

For example, the 9 by 9 row has original detection floor 1/20736
and additional-weight floor 1/1458. The certificate records each
selected mark pair's signed color ratio and both exact weight
products, not only the final total. Its complete matchings allow
their legality to be checked without trusting a schematic drawing.

`Main.lean` formalizes the arbitrary-length alternating-chain
positivity and head-detection bounds, the integer same-loop sign
argument, the finite color-product summations, and the local
source/sink trace identities. `statement_fidelity.md` explicitly
separates those compiler-checked assertions from the polygonal and
cap-gluing proofs above. The entire geometric theorem is not claimed
as `closed_kernel`.

No false manuscript assertion has been established by this route.
In particular there is no refutation of the convergence conclusion.
The theorem above independently verifies and strengthens one
load-bearing mechanism. Its correctness, statement fidelity,
significance and novelty still require the Host-invoked independent
Reviewer; the bounded literature lookup cannot certify novelty.

The two canonical citations recorded on the **scope-only** claim
`C_CAP_SCOPE` still require independent `citation_check attribute`
records. The literature worker opened the sources, but that is not
the same as an archived attribution. Neither cited theorem is an
assumption of `C_CAP_DETECTION`, `C_CAP_GENERALIZED`, or
`C_CAP_FORMAL`. No independent attribution or Reviewer acceptance
has been invented.

## Replay

Run from the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/cap_positivity/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/cap_positivity/Main.lean --statement-fidelity research/cap_positivity/statement_fidelity.md --claim C_CAP_FORMAL --project-root . --timeout 90
```

The first command replays the legal examples and counts and checks that
the current formal source and fidelity text match the archived compiler
certificate. It does not rerun Lean or treat the geometric proof as
compiler-checked. The second command is the real Lean replay, including
the hole audit and claim-ledger recording. Its already completed
Engineer run returned exit code 0 and `proof_holes=[]` under Lean 4.31.0.
Independent Reviewer replay and approval remain outstanding.
