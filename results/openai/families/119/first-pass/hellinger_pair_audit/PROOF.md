# Universal verification of the Hellinger pair interface

## Statement and scope

Use the seven rows of Table `ind:tab:parameters` in
`research/openai_manuscript/Hellinger-contraction-with-arbitrary-Boolean-output-bias-September-24-2026/build/sections/induction.tex`.
Every table entry except its row index is divided by 1000. Put

    h(p) = 2 sqrt(p(1-p)),
    lambda(h) = L + U h + V h^2,
    G(p) = h(p) (1 + (2p-1)/(1+h(p)lambda(h(p)))).

The theorem verified here is the following universal, continuous-domain
statement, not a finite test of probability pairs. For each fixed row, every

    0 < delta in [r0^2,r1^2],  0 <= p0 < p1 <= 1,

set `s^2=4 delta(1-delta)`, `z=p1-p0`, `pt=p0+t z`, and

    D = (G(p_delta)+G(p_(1-delta))-G(p0)-G(p1))/2,
    S = alpha G(p1)+(1-alpha)G(p0),
    T = z-(G(p1)-G(p0))/(4L).

Then `D>0` and `D(S+Lambda D)>mu s^2 T^2`. For `p0=p1`, both sides
of the required inequality and `D` are zero. At `delta=0` the original
inequality also holds with equality. This slightly enlarged noise range
implies exactly Lemma `lem:scalar`, assertion (1): the exact rational
comparisons

    4 r0^2(1-r0^2) <= s_lo^2,
    4 r1^2(1-r1^2) >= s_hi^2,  r1^2 < 1/2

and monotonicity of `4a(1-a)` on `[0,1/2]` put the manuscript's
`delta=(1-sqrt(1-s^2))/2` in this range. Shared endpoints work with
either complete row. This does not verify the polynomial profiles, the
base cases, the remainder of dimension induction, or the full Hellinger
theorem. Independent Reviewer acceptance and a novelty/significance
assessment are separate from this engineer's verification.

The sources for the reductions below are `sc:pair-reduction` and
`sc:interval` in `build/sections/scalar.tex` of the same manuscript.
No external literature proposition is assumed. The argument uses the
elementary product rule, the mean-value theorem, and continuous extension
of divided differences; their particular uses are justified below.

## 1. Exact algebra and the direction of the comparison

For distinct endpoint nodes define

    K = -(G[p0,p_delta,p1]+G[p0,p_(1-delta),p1])/8,
    W = 1-G[p0,p1]/(4L),
    Delta = K(S+Lambda D)-mu W^2.

Writing out the divided differences gives, without a concavity assumption,

    D = s^2 z^2 K,  T=z W,
    D(S+Lambda D)-mu s^2 T^2 = s^2 z^2 Delta.

Thus `Delta>0` implies the strict second inequality. It does NOT by itself
imply `D>0`; that assertion is proved separately in section 4.
`verify.py` checks the rational identities symbolically, not numerically.
The Lean source and its fidelity document, when certified, cover precisely
this algebraic bridge, not the analytic positivity certificate.

For `0<=y<1` put `q=sqrt(1-y^2)`, `h=2qy`, and `e=1/(1+h lambda(h))`.
The manuscript's functions are

    N(y) = 4q(y+q lambda(h))e,
    R(y) = 4q^2(q+y lambda(h))e,
    M(y) = 4{Ly+q[2L^2-1-2Uq^2+h(2LU-2Vq^2+2LVh)]}e.

Reducing numerators modulo `q^2+y^2-1` verifies the three exact identities

    G(y^2)=y^2 N(y)=4Ly^2-y^3 M(y),  G(1-y^2)=y R(y).

All rows have `lambda(h)>=L+U>=488/1000>0` for `0<=h<=1`.
Hence their denominators are positive, and `N,R` are strictly positive
for `0<=y<1`. All arguments used in this proof are at most `4/5`:
in the third region their squares are at most
`(3/5)^2+r1^2 < (4/5)^2`. Therefore these three functions are smooth on
a neighborhood of their evaluation ranges, including `y=0`.

The endpoint divided-difference identities are independently checked using
the generic Newton polynomial

    m(a)=m0+(a-u)A+(a-u)(a-i)B.

Every triple of function values has this representation for distinct
nodes; its divided differences are `m02=A+(1-i)B`, `m12=A+(1-u)B`,
and `m012=B`. Rational simplification proves the `F,P_i` formulas of
`sc:case1-data` and the scaled negative second differences of
`sc:case2-data`. This explicitly checks the reversal of endpoint orientation
in the second region. It is not a test of selected functions `M` or `R`.
The cancellations yield exactly the normalized formulas implemented in
`interval_verify.cpp`.

## 2. Coverage and normalized comparison

The first region consists of
`p0=v^2 u^2,p1=v^2`, with `0<=u<=1,0<=v<=4/5`.
The second consists of
`p0=1-v^2,p1=1-v^2 u^2` with the same ranges.
For distinct pairs `v>0,u<1`. Introduce `0<=j<=r1` and

    d=j(2u+(1-u)j),  w=u+(1-u)j,
    t=sqrt(1-(1-u)d),  delta=d/(1+u).

Here

    delta=j^2+2u j(1-j)/(1+u),
    partial_u delta=2j(1-j)/(1+u)^2 >= 0,
    partial_j delta=2(u+(1-u)j)/(1+u) >= 0.

For fixed `u`, this continuous function is zero at `j=0` and at least
`r1^2` at `j=r1`. Every needed delta therefore occurs; no inverse
parameter map or differentiability of that inverse is required.
Also `u<=w,t<=1` on the entire parameter box, not merely its retained
delta subset. The exact identities

    w^2=u^2+delta(1-u^2),  t^2=1-delta(1-u^2)

identify the two interior probability nodes. The first region's certified
expression, called `A1` here, is `sc:case1`; the second, `A2`, is
`sc:case2`. The symbolic divided-difference identities give

    Case 1: K=Z/v, W=vF/(4L), S=v^2 S0, A1=Delta/v;
    Case 2: K=Z/[v^3(u+w)], W=1+F/(4Lv),
            S+Lambda D=v S1, A2=v^2(u+w)Delta.

The other identity needed in Case 1 is
`s^2(1-u^2)^2=4d(1-u)(1-w^2)`, checked symbolically.
For an actual pair all displayed scaling factors are positive:
`u+w=0` would force `u=j=0`, hence `delta=0`, which is excluded.

The first two regions cover respectively `p1<=16/25` and `p0>=9/25`.
Every remaining pair has `p0=l^2,p1=1-u^2` with
`0<=l,u<=3/5`, and `delta=r^2` with `r0<=r<=r1`.
Then

    z=1-l^2-u^2 >= 7/25, b=r^2 z,
    lp=sqrt(l^2+b), up=sqrt(u^2+b).

The independent Jacobian operation `polynomial.box.enclosure.compute`
encloses `1-l^2-u^2` by `[7/25,1]` on this exact rational box.
The request, retained polynomial and box, typed output, server version,
protocol, and successful adapter status are retained in the dedicated
JSON files. The same bound is replayed with rational arithmetic in
`verify.py`. This operation is only a gap/denominator bound; it does not
claim to settle the radical inequality.

For the third region's `P,Q,Z,W,Y0,Y1,Y2` of `sc:case3-data,sc:Y`,
factoring differences of squares gives

    G(lp^2)-G(l^2)=bP,
    G(1-up^2)-G(1-u^2)=(up-u)Q,
    b=(u+up)(up-u),  Z=(u+up)K,  Y0=(u+up)Delta.

For `delta>0`, `u+up>0`. Once `K>0` is established in section 4, `Z>0`.
If `Y0>0`, the conclusion follows. Otherwise the certificate proves
`Y1>0` and `Y2>0`. The weights

    a=2u/(u+up),  c=(up-u)/(u+up)

are nonnegative and sum to one. Their convex combination of the
brackets multiplying `Z` is

    [S+Lambda D-(1-alpha)l^2 N(l)]/(u+up).

Consequently their positive combination gives
`Z [S+Lambda D-(1-alpha)l^2 N(l)]/(u+up)-mu W^2>0`.
Since `1-alpha>0`, `N(l)>0`, and `Z>0`, restoring the discarded term
preserves strict positivity and proves `Delta>0`. The convex-combination
identity is also checked symbolically. This is where the concavity proof
is used; it is not assumed to establish either endpoint-region sign.

## 3. What the executable certificate proves

`interval_verify.cpp` is a new implementation from the displayed
recursions, not an invocation, translation, or include of the author's
C++ program. Its only inputs are a row number and a region number.
`verify.py` checks that all ten constants in every row agree both with
the LaTeX table and with the new implementation.

An interval has closed rational endpoints `lo/10^12,hi/10^12`.
Floor and ceiling use exact signed integer division. Multiplication checks
all four products. Reciprocals require a strictly positive lower endpoint.
Square roots use integer Newton iteration and an exact square comparison.
Every stored endpoint is guarded by `abs(endpoint)<=10^18`.
Products are at most `10^36`, hence fit signed 128-bit integers.
Integer-root radicands are at most `10^30`, and the root iteration starts
at a power of two below `2*sqrt(n)`; its products also fit. Addition,
subtraction, and derivative errors use at most `4*10^18`, below signed
64-bit overflow. The exact rational delta-exclusion cross-products
at depth at most 14 are below `10^28`, also below signed 128-bit overflow.
No floating-point operation is used.

Seven-slot tuples represent values and the divided differences
`01,02,12,012`. Their rules are

    (ab)012=a0 b012+a01 b12+a012 b2,
    (1/c)012=-(1/c0)[c012/c2+c01(1/c)12],
    (sqrt(c))012=[c012-(sqrt(c))01(sqrt(c))12]
                  /[(sqrt(c))0+(sqrt(c))2].

The three first-difference formulas follow from the same product rule.
These equations are obtained by solving `ac=1` and `a^2=c`;
they never divide by a node distance. For a smooth function the ordinary
divided differences extend continuously to repeated nodes, with a double
node giving the derivative and a triple node giving half the second
derivative. Thus these algebraic rules enclose the repeated-node values
as well. Interval addition, multiplication, positive reciprocal, and
positive root preserve inclusion, so induction through these finite
expression trees proves that every computed slot is an enclosure.

The special function `E(a,b)=a^2/(a+b)` on `0<=a<=b`, extended by zero
at the origin, uses

    h=a/(a+b) in [0,1/2],  E=ah,
    dE=h(2-h) da-h^2 db.

Direct division, when defined on the whole interval, is intersected with
`[0,1/2]`. Otherwise this entire interval is used, not a chosen value
of the undefined ratio. The cone is convex, and the differential
coefficients are bounded there. Integrating along an interior segment
and then taking its limit proves the same Lipschitz bound at the
origin. The underlying coordinate maps are smooth wherever a derivative
attempt is accepted, so this also justifies the composed mean-value
bound at the nondifferentiable corner. The order relations needed for
this rule were proved on the entire boxes in section 2.

Each initial box is recursively bisected in all three coordinates.
Its exact endpoints have dyadic denominators; only their enclosing
interval representation is rounded. Closed children cover the parent,
including every subdivision face. In regions 1 and 2, monotonicity of
delta permits exclusion ONLY if its exact corner bounds lie strictly
outside `[r0^2,r1^2]`. Equality is retained.

A retained box is accepted by positive interval lower bounds, or by
the following uniform bound. Write each coordinate as `xi=ci+hi eta_i`
with `abs(eta_i)<=1`. Automatic differentiation encloses the three
derivatives in these normalized coordinates using the chain rule.
If `Ic` encloses the value at the exact center and `Ji` encloses its
normalized derivative on the full box, then

    inf(Ic) > sum_i max(abs(inf Ji),abs(sup Ji))

implies strict positivity throughout that closed box by integration
along the center-to-point segment. Different components of the third
region's disjunction may use different sufficient tests.

Only the two known-nonnegative radicands `l^2+b,u^2+b` have their
negative interval lower endpoints clipped to zero for VALUE evaluation.
This is sound because `b>=0` on the whole true box. Derivative evaluation
never clips and rejects a root singularity. Every invalid attempt is
counted and is uncertified; it triggers subdivision, not acceptance.
An uncertified leaf at the maximum depth terminates the program with a
nonzero exit code and its exact grid indices. There is no numerical
threshold, sampling fallback, or success-shaped error path.

The depth limits are the manuscript's 8,8,8,7,8,8,8 for both endpoint
regions and 14,7,7,7,7,7,7 for the third. The resulting integer counts
and strict positive margins are in `exact_certificate.json`.
`verify.py` re-executes all 21 trees and checks the full-tree accounting
identities and all recorded results. The leaf theorem proves positivity
on each retained closed box. Finite induction up each tree proves the
three normalized signs over their complete boxes, subject only to the
explicit delta restriction. The conclusion is universal over real
parameters, not limited to grid points.

## 4. Repeated nodes, concavity, and singular probability limits

The first two strict normalized sign checks include `u=1`.
Fix any permitted `delta>0` and choose `j=delta`; this lies in
`[0,r1]` since `delta<=r1^2<r1`. Then `w=t=1`.
In the first region `S0=N(v)>0` and its `Z^2` term vanishes.
The remaining subtracted term is nonnegative, so its strict inequality
forces `Z>0`, without assuming a sign for `K`.
In the second region `S1=R(v)>0`, and its subtracted term is likewise
nonnegative, so it too forces `Z>0`.

For `v>0`, continuous repeated-node extension gives `K=-G''(p)/8`.
The first region supplies `G''<0` for `0<p<=16/25`; the second for
`9/25<=p<1`. They cover `(0,1)`. Therefore `G` is strictly concave
there. The defining expression is continuous on `[0,1]` with
`G(0)=G(1)=0`. A continuous concave extension has positive interpolation
deficit for distinct endpoints and a weight strictly between zero and
one: equality would force affinity on the intervening segment, contrary
to the strict second derivative on its interior. This proves `D>0`
and `K>0` also for pairs containing 0 or 1. It supplies the sign used
only subsequently in the third-region convex combination.

No derivative of `G` at 1 or second derivative at 0 is asserted.
The normalized smooth functions, not those singular derivatives, are
what the endpoint boxes certify. The corner `u=i=0` in the first
region is handled by the continuous, Lipschitz `E` formula.
The possible third-region corner `r=u=0` is handled by value-only
radical enclosures and the disjunction, not division by `u+up` there.
That division is used only for actual `delta>0`.
The cases `v=0`, `u=1`, and `delta=0` in the normalized boxes are
included in their sign certificate, but algebraic divisions by `v`,
`z`, or `u+up` are used only for the nondegenerate pairs specified in
sections 1 and 2. Repeated original endpoints are settled directly,
including both probability-boundary points.

Combining the endpoint signs, this independent concavity argument,
the third-region disjunction, and the algebraic bridge proves the stated
universal pair theorem and the literal manuscript assertion (1).
No false manuscript assertion is inferred from a failed sufficient
interval test, and no manuscript refutation is claimed.

## Recorded verification

The complete independent run passed all 21 trees: 781,013 visited boxes,
97,624 subdivision nodes, 46,388 excluded leaves, and 637,001
sign-certified leaves (26,644 by values and 610,357 by derivatives or
mixed tests). There were zero failed terminal leaves. The 885 invalid
arithmetic attempts all remained uncertified and were subdivided.
The smallest recorded sufficient normalized margin is exactly
`2568/10^12`; this is not a uniform margin for the unnormalized pair
gap, whose positive scaling factors can tend to zero.

The 18 symbolic identities, all seven noise-bound and table-fidelity
checks, and the retained exact Jacobian enclosure passed.
The fresh Lean 4.31.0 compile of `Main.lean` returned `exit_code=0`,
`proof_holes=[]`, and axiom-audit exit code 0. Its claim-bound archive is
`certificates/C119_PAIR_ALGEBRA-e79ad749afd88d84.json`.
This compiler result establishes only the precisely delimited algebraic
claim described in `statement_fidelity.md`; it is not substituted for
review of this analytic argument or the interval checker.

Relative to the manuscript's asserted native arithmetic execution, this
work adds an independently authored checker, symbolic orientation and
cancellation checks, an explicit noncircular boundary-to-concavity
argument, a strict theorem on each row's entire enlarged delta interval,
and kernel certification of the original-variable algebraic bridge.
It does not claim that these observations constitute a novel resolution
of the full conjecture. The independent Reviewer must assess the theorem,
the source-to-statement fidelity, and any publication-level significance.

## Replay

From the campaign root, with SymPy and a C++17 compiler available:

    $WORKSPACE/argus-live-update/.venv/bin/python research/hellinger_pair_audit/verify.py

The optional `--write-certificate` emits the deterministic certificate
after a successful complete proof. `--algebra-only` checks the symbolic
identities, table fidelity, noise bounds, and retained Jacobian result;
that option alone does NOT prove the universal theorem.
