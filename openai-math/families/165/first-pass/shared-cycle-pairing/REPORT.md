# The corrected cycle pairing: scope and independent proof

## Exact question

Let a finite simple graph have a normalized plane drawing: each edge is a
simple polygonal arc, crossings are proper double points in straight portions,
and adjacent edges do not cross. Orient each edge arbitrarily. Write
`B(v,e) = 1[e ends at v] - 1[e starts at v]`. At each vertex choose any gap
in the counterclockwise order of outward spokes, and let `T_v(e,f)` be
`+1` for precedence, `-1` for reverse precedence, and zero for equality.
Let `sigma(v,e) = -B(v,e)`. The assertion under audit is

    J(e,f) = I(e,f) + (1/2) sum_v sigma(v,e) sigma(v,f) T_v(e,f),
    Bz = By = 0  ==>  sum_{e,f} z_e y_f J(e,f) = 0.

Here `I` counts every interior crossing with its determinant sign. Real
coefficients, shared edges in either direction, repeated crossings of an edge
pair, and independently chosen vertex cuts are all in scope.

## Sources and strongest prior result

The staged complete-graph paper, `build/main.tex:182-351`, defines the boundary,
the pairing (`eq:J`, lines 222-229), and the all-real-cycle assertion
(`lem:cycles`, lines 231-233). The staged bipartite paper,
`build/sections/intersections.tex:8-177`, defines the same pairing
(`eq:signed-J`) and proves it first for signed simple cycles
(`lem:cycle-pairing`, lines 47-59). Its additive-block consequence is
`lem:additive`, starting at lines 188-189.
Drawing normalization is proved, not merely cited, in that paper's
`build/sections/normalization.tex:9-157`.

The papers already give a local chord formula and a two-sided displacement
proof, including opposite traversals of shared edges. Neither a counterexample
nor a false manuscript assertion has been established in this scope pass.

There is a stronger prior formal source than the initial campaign wording
suggests: `OAI.Paper170.cycle_pairing` in
`lean/OAI/Combinatorics/CompleteCrossing/CycleIdentity.lean:133-140`
asserts the full normalized-drawing identity for arbitrary real chains.
The inspected file is byte-identical to public OpenAI/math revision
`adc7f1241b42e322a6451854ab7e4b4c146bf78a` (2026-10-06), checked through the
GitHub contents API. Its actual drawing definitions are in `Drawing.lean:36-185`:
injective continuous edge paths, finite proper spatial crossings, no triples,
polygonal parametrizations, no adjacent crossings, and angularly compatible
spoke orders. No cycle-vanishing axiom is hidden in `SpokeOrders`.
Avoiding polygonal knots at crossings is presentation data obtainable by
subdivision, not a restriction on drawing isotopy types.

The upstream toolchain is Lean 4.34.1. Its cycle theorem has a transitive
closure of 264 OAI modules (21,537 source lines); no matching precompiled
`CycleIdentity.olean` was found in the two relevant build locations probed.
These are environment observations, not a refutation and not a compiler run.
This mission will not describe the upstream source as Lean 4.31.0 evidence.

The independent route below replaces displacement and cycle-space spanning
with a direct incidence factorization. It does not claim that the identity
itself is new. Publication significance and novelty require independent review.

## Load-bearing dependencies of both papers

All downstream nodes below remain unaudited mathematical assertions, not
verified consequences of this mission.

Complete graph:

1. Normalization (`main.tex:850-934`) supplies the drawing used by cycle pairing.
2. Cycle pairing (`231-351`) and interpolation weights (`362-379`) supply
   polynomial cycle tests (`504-528`).
3. Two-triangle interpolation (`385-441`) supplies order detection (`443-491`).
4. Order detection and polynomial cycle tests supply injectivity (`560-637`).
5. Injectivity and the isotropic-image dimension argument supply the odd lower
   bound (`639-688`); vertex deletion supplies the even bound (`690-707`).
6. The separately counted two-page construction supplies the matching upper
   bound (`709-839`), yielding the formula in Theorem 1 (`117-126`).

Complete bipartite graph:

1. Normalization and cycle pairing supply the additive-block relation
   (`intersections.tex`, `lem:additive`).
2. The subspace-intersection lemma (`subspaces.tex:11-164`) supplies the
   rank-sum corollary (`168-214`).
3. Two-triangle interpolation supplies the rank detector
   (`detector.tex:13-165`).
4. The additive-block relation, detector, and rank-sum inequality supply the
   odd-side lower bound (`conclusion.tex:37-91`).
5. Deletion supplies the even-side bound (`94-108`); the balanced-axis
   construction supplies the upper bound (`6-35`), yielding Theorem 1
   (`introduction.tex:14-35`).

The locally proved Lagrange-weight identity is attributed to
Berrut--Trefethen, and the upper constructions have historical attributions.
No historical crossing-number estimate is needed for the present identity.
The known inputs initially recorded as assumptions were the elementary
closed-polygon intersection theorem and real cycle-space spanning, with the
exact staged passages cited. Both have been explicitly retired with reasons:
the direct incidence proof needs neither theorem. No earlier failed mathematical
route was present in the
initial project ledger.

## Independent sweep-coordinate route

Choose a generic horizontal coordinate by an orientation-preserving rotation
and subdivide edges at their bends.
Orient each resulting segment from smaller to larger horizontal coordinate.
For a segment `e=[a,b]`, define a vertex potential

    R(e,p) = 1/2                         if p=a or p=b,
             1                          if a_x<p_x<b_x and p is below e,
             0                          otherwise.

Put `T_x(p,q)=sign(q_x-p_x)` and

    K(e,f) = (T_x(a,c)-T_x(a,d)-T_x(b,c)+T_x(b,d))/2

for `f=[c,d]`. With the downward vertical ray as every vertex cut, the exact
local identity to prove is

    I(e,f) + endpoint_correction(e,f)
      = R(e,c)-R(e,d)+R(f,b)-R(f,a)-K(e,f).                 (*)

The value `1/2` at an endpoint is essential. For example, when `b=c`,
the two endpoint values contribute `1`, and the top-order correction
contributes `-1/2`; their sum is the correct `+1/2`. Setting those endpoint
values to zero would reverse this sign.

The right side of (*) factors through incidence in both variables.
Consequently its pairing with any two real chains with zero boundary is zero.
This is universal algebra, not a finite numerical test. The remaining proof
obligations are the local orientation identity (*), its passage from subdivided
segments to the original drawing, and invariance under arbitrary changes of
vertex cut.

The bounded Jacobian operation is `matrix.rank.compute` on the cut-change
matrix in `jacobian_payload.json`. Its role is a separately replayable rank
sanity check for a four-spoke cut change, not a proof of the universal identity.
The exact typed adapter response and failure status will be retained.

## Universal verification theorem and proof

**Theorem.** Under exactly the drawing hypotheses stated above, the corrected
pairing annihilates every pair of real cycle chains. In particular there is no
additional disjointness, integrality, simple-cycle, single-crossing, or
common-traversal-direction hypothesis.

### 1. The straight-segment calculation

First suppose that all distinct segment endpoints have distinct horizontal
coordinates and no three distinct endpoints are collinear. All segments in
this subsection point left to right. Write `e=[a,b]`, `f=[c,d]`, and
`g(x)=height_e(x)-height_f(x)` on their overlapping horizontal interval
`[l,r]`. If the four endpoints are distinct and `l<r`, put `h0=g(l)`,
`h1=g(r)`. Neither is zero. Each height function is affine. Thus:

* Equal endpoint signs give no crossing.
* Opposite signs give exactly one interior crossing.
* If `h0>0>h1`, its sign is positive; if `h0<0<h1`, it is negative.

For completeness, the zero in the opposite-sign case has normalized coordinate
`t=h0/(h0-h1)`, strictly between zero and one; substituting verifies the zero.
An affine function with different endpoint values has at most one zero.
Moreover, if `u=b-a`, `v=d-c`, then

    g'(x) = u_y/u_x - v_y/v_x = -det(u,v)/(u_x v_x).

Since `u_x,v_x` are positive, the preceding sign convention is exactly the
manuscripts' ordered-tangent determinant convention. Consequently

    I(e,f) = (sign(h0)-sign(h1))/2 = H(h0)-H(h1),

where `H(h)=1[h>0]`. This proves the orientation assertion for arbitrary real
coordinates, not just for the tested examples.

Here is the complete four-distinct-endpoint table. The column `Rsum` means
`R(e,c)-R(e,d)+R(f,b)-R(f,a)`. In each overlapping case the definitions of
`h0,h1` above apply.

| Horizontal order | K | Rsum |
|---|---:|---|
| a < b < c < d | 0 | 0 |
| c < d < a < b | 0 | 0 |
| a < c < b < d | 1 | H(h0)+H(-h1) |
| a < c < d < b | 0 | H(h0)-H(h1) |
| c < a < b < d | 0 | H(-h1)-H(-h0) |
| c < a < d < b | -1 | -H(h1)-H(-h0) |

Using `H(-h)=1-H(h)` for `h!=0`, every row gives `I=Rsum-K`.
These six orders exhaust all possibilities because `a_x<b_x` and `c_x<d_x`.
The four nontrivial identities and the affine zero criterion are proved
universally over the reals in Main.lean.

There remain shared endpoints. The outward-spoke order with the downward
vertical cut lists all right-pointing rays before all left-pointing rays;
within either half-plane its comparison is `sign(det(out_e,out_f))`.
No vertical ray occurs.

| Shared endpoint | Local correction | Rsum-K |
|---|---|---|
| a=c, b<d; h=g(b) | -sign(h)/2 | H(-h)-1/2 |
| a=c, d<b; h=g(d) | -sign(h)/2 | 1/2-H(h) |
| b=d, a<c; h=g(c) | sign(h)/2 | H(h)-1/2 |
| b=d, c<a; h=g(a) | sign(h)/2 | 1/2-H(-h) |
| b=c | 1/2 | 1/2+1/2-1/2 |
| a=d | -1/2 | -1/2-1/2+1/2 |

Here endpoint inequalities mean horizontal-coordinate inequalities. For a common
start, `g` starts at zero, so its nonzero interior sign is the opposite of the
determinant sign. For a common end, `g` ends at zero, so its earlier nonzero sign
is the determinant sign. When one segment ends where the other starts, the
outward rays lie in opposite horizontal half-planes and their incidence signs
have product `-1`, giving the displayed half-signs. In all six rows the open
segments do not intersect, and `sign(h)=2H(h)-1` proves equality of the last two
columns. If both endpoints coincide, the left-to-right segments are the same:
`I=0`, the spoke comparisons and `K` are zero, and the four endpoint-potential
terms cancel. This proves (*) in every case.

### 2. Incidence factorization

Let W be the set of geometric segment endpoints and S the segments, each
oriented left to right. With `B(v,e)=1[v=dst(e)]-1[v=src(e)]`, the local
identity just proved reads

    J = B^t R^t - R B - (1/2) B^t T_x B,

where `R` has rows indexed by S and columns indexed by W. More explicitly,

    J(e,f) = sum_v B(v,e) R(f,v) - sum_v B(v,f) R(e,v)
             - (1/2) sum_{v,w} B(v,e) B(w,f) T_x(v,w).

For arbitrary real z,y, its contraction is

    z^t J y = (Bz)^t R^t y - z^t R(By) - (1/2)(Bz)^t T_x(By).

It is therefore zero if `Bz=By=0`. There is no cycle-space decomposition and no
positivity or arithmetic restriction on the coefficients. `incidence_pairing_zero`
in Main.lean proves precisely this universal statement, even for an arbitrary
real matrix B rather than only a graph incidence matrix.

### 3. Genericization and subdivision do not add a drawing hypothesis

A normalized drawing has finitely many polygonal pieces. Remove unnecessary
straight subdivision points at crossings so each crossing lies strictly inside
two pieces. Its geometric endpoint set consists of graph vertices and bends,
with shared graph endpoints identified. Nonincident pieces that do not meet
are disjoint compact sets and have positive separation. Existing crossings
have nonzero determinants and intersection parameters strictly between zero
and one; their parameters and signs persist under sufficiently small endpoint
perturbations. Distinct spatial crossing points remain distinct by choosing
disjoint small neighborhoods of them. At a shared endpoint, distinct outward
spokes have a positive angular separation, so a sufficiently small perturbation
creates no additional meeting and preserves their circular order. Consecutive
pieces of a simple edge obey the same condition. Thus finitely many open
conditions preserve simplicity, proper crossings, absence of adjacent
crossings, and all vertex rotations simultaneously.

Inside that open neighborhood choose endpoint coordinates avoiding the finitely
many collinearity equations for triples of distinct endpoints. Each determinant
equation is a nonzero polynomial in the independently variable endpoint
coordinates; a nonzero real polynomial cannot vanish on an open set (induct
on the number of variables using the univariate root bound). A finite union
is avoided by applying this fact to the product polynomial. Next choose an
orientation-preserving rotation whose horizontal projection avoids the finitely
many perpendicular directions to
differences of distinct endpoints. This gives the generic situation used
above. These choices do not change any signed crossing or circular order.
They are auxiliary presentation choices, not stronger manuscript hypotheses.

Subdivide original graph edges into these straight pieces. If the fixed
orientation of a piece agrees with the original traversal put its coefficient
equal to z_e, and otherwise to -z_e; do likewise for y. At every artificial
bend the two signed incidence contributions cancel. At an original vertex
their sum is the original boundary. Thus original cycle chains lift to segment
cycle chains.

The segment interior-intersection sum is exactly the original sum, including
every repeated crossing. Pieces of the same original simple edge have no
interior crossings. At an original vertex the incidence-weighted coefficients
on each outward spoke agree before and after subdivision. At an artificial
bend the two local endpoint-coefficient vectors have the form
`(-z_e,z_e)` and `(-y_e,y_e)`, up to the same ordering. Their pairing with
any skew two-by-two order matrix is zero. Thus subdivision adds zero local
correction, even when both chains use that original edge in opposite directions.
The zero segment pairing is exactly the original corrected pairing.

### 4. Every vertex-order cut

Move one cut counterclockwise past the initial group of spokes S, and let
`u(e)=1[e in S]`. Directly comparing the two orders gives

    T_new(e,f)-T_old(e,f) = 2(u(f)-u(e)).

For endpoint coefficients `a_e=sigma(v,e)z_e` and `b_f=sigma(v,f)y_f`,
the change of the half-order pairing is

    (sum_e a_e)(sum_f b_f u(f)) - (sum_e a_e u(e))(sum_f b_f).

Both unweighted sums vanish because z,y are cycles. Main.lean's `cut_change`
proves this for arbitrary real vectors. Any two gaps differ by such a move;
apply it independently at every vertex. This completes the universal proof.

### 5. Independent check of the manuscripts' displacement convention

There is a second, independent local orientation check. For directed chords
with start coefficient -1 and end coefficient +1, cutting before the first
start reduces the half-order expression to minus the second chord's endpoint
sum on the counterclockwise arc to the first end. That arc lies on the right
of the first directed chord. The expression is +1 for a right-to-left crossing,
-1 for the reverse, and zero otherwise. The verifier checks all 24 directed
four-endpoint order types at all four cuts using exact determinants.

For shared spokes, the verifier uses actual distinct rational points on a
circle, with opposite displacements at each shared spoke. At an outward
source spoke a fixed-orientation left shift moves counterclockwise; at an
inward target spoke it moves clockwise. It checks every orientation assignment
and every pair of directed passages on their union of two, three, or four
spokes, including all cuts. The diagonal comparison averages to zero.
`shared_spoke_average` proves the accompanying bilinear cancellation for
arbitrary real endpoint weights, not just +/-1. This agrees with the
manuscript convention and is not used to assume the sweep identity.

## Classification and certification boundary

The mathematical result above is a complete universal verification proof of
the shared identity and an explicit incidence-factorization formula. The
deterministic experiments are separate finite checks, not its logical basis.
Main.lean kernel-checks the universal algebra, affine crossing criterion,
local sign identities, cut change, and shared-spoke cancellation. Its
`cycle_pairing` declaration **explicitly assumes** the geometric bridge proved
above; genericization, subdivision, and the geometric interpretation of the
tables are not encoded as Lean topology. That boundary is also recorded as
`A_SWEEP_GEOMETRY` in the ledger. A successful compiler run must not be reported
as an unconditional kernel proof of the whole geometric theorem.

No manuscript assertion is refuted by these results. The prior source already
states and proves the identity; this work supplies a different calculation,
exact adversarial checks, and a Lean 4.31.0 certificate for its universal
algebraic reduction. Novelty and publishable significance remain unestablished
until independent Reviewer assessment. Neither claimed crossing-number
formula has been certified by this mission.

## Measured exact evidence and replay

The final Lean 4.31.0 run returned `exit_code=0`, `proof_holes=[]`, and
`audit_exit_code=0`. The current immutable certificate is
`certificates/C_CYCLE_PAIRING-73c8fbda5ba382ee.json`. The claim correctly reports
`conditional_kernel`, with precisely `A_SWEEP_GEOMETRY` undischarged. Earlier
failed compiler attempts are not supporting evidence; the recorded successful
source and statement-fidelity digests match the current files.

The independently implemented rational-arithmetic verifier passed:

| Exact check | Measured coverage |
|---|---:|
| Directed chord order types and cuts | 96 |
| Shared-spoke displacements, orientations, and cuts | 10,112 |
| Generic segment instances, including shared endpoints and self-pairing | 3,289 |
| All vertex-cut choices in the three normalized graph fixtures | 373 |
| All edge-orientation choices in those fixtures, at a fixed cut choice | 352 |

These are finite experiments. The shared-spoke cases include 1,856 cases
with two shared spokes, 6,720 with one, and 1,536 with none. The graph fixtures
include two cycles with a common edge and two disjoint graph cycles with eight
spatial crossings, seven between a single pair of edges. That pair's signed
count is `+1`, canceled by another pair's `-1`. The verifier checks drawing
admissibility and computes complete rational cycle bases by exact incidence
rank, not just selected cycles. Every corrected cycle Gram matrix is zero.
The Jacobian adapter returned rank two and pivots `[0,1]`, independently
replayed by exact row reduction; its server was 0.14.0, protocol 2025-11-25,
with adapter exit status zero.

Run the standalone replay, from the campaign root, with:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/shared-cycle-pairing/verify.py
```

The recorded official compiler invocation is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify \
  --project-root . --claim C_CYCLE_PAIRING \
  --statement-fidelity research/shared-cycle-pairing/STATEMENT_FIDELITY.md \
  research/shared-cycle-pairing/Main.lean
```

This installed CLI takes the source positionally, not with `--source`.
Do not edit either formal file while a verification run is active. The standalone
replay checks the recorded compiler version, proof-hole list, kernel audit, and
both source digests as well as recomputing its mathematical experiments.

**Review status:** no independent Reviewer verdict has been performed or
attributed by Engineer. This is a known-result verification checkpoint, not a
newness claim or terminal completion of the publishable counterexample campaign.
Reviewer must assess the universal geometric proof and statement fidelity.
If accepted only as a known result, Planner must continue on an unresolved
downstream route rather than re-open this identity or broaden its conclusion.
