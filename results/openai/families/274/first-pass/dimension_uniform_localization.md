# Dimension- and rank-uniform product-projection localization

## Scope and comparison with the staged sources

The target is a universal operator-norm theorem, not a finite matrix
experiment and not a claim that the parity theorem is new. Local dimensions
and all local projection ranks may grow arbitrarily with the number of sites.
No bound may depend on them. Independent mathematical review is pending.

The first staged manuscript (OpenAI, September 24, 2026,
*Product-projection localization and the QAC0 parity lower bound*) states its
theorem on `(C^2)^{tensor N}`. Its counts fix rank-one factors on selected
sites. Its load-bearing chain is:

1. `localization.tex`, `thm:localization`: circuit normal form, two independent
   counts, and inversion at the same reflection depth.
2. `depth_reduction.tex`, `lem:base`, `lem:propagation`,
   `lem:small-support`: an unnormalized Bernoulli bound at depth zero,
   low-pattern propagation, and an ordered three-factor reflection expansion.
3. `polynomial.tex`, `lem:polynomial`: degree and weighted coefficient control,
   including approximation ranges larger than the maximum count.
4. `bootstrap.tex`, `lem:backward` and the proof of `thm:localization`:
   one-sided polynomial substitution after squaring, exchange of counts in the
   inverse circuit, and a finite backward scale induction.
5. `parity.tex`, `eq:parity-average`: averaging complementary Hadamard entries
   gives the parity coefficient. This already-known qubit consequence is not
   the proposed mathematical improvement.

The second staged manuscript (OpenAI, September 24, 2026,
*Regular trajectories, pruning and quantum parity*) has a different chain:
`02-framework.tex`, `lem:degree-shift`; `03-filters.tex`,
`lem:zero-filter` and `lem:tail-filter`; `04-propagation.tex`,
`prop:propagation`; `05-transport.tex`, `lem:exponent-budget` and
`lem:tail-transport`; `06-pruning.tex`, `prop:projection-insertion`,
`cor:product-tail`, `cor:overlap-tail`, `lem:retained-layer`,
`prop:pruning`; and `07-parity.tex`, the reference-register parity proof.
Its propagation coefficient bound counts qubit Pauli strings; its retained
layer argument counts binary rank-one atoms. Neither is silently invoked
for arbitrary dimensions here. The first paper's operator-norm route avoids
both obstacles.

These are source assertions and a dependency decomposition, not a claim to
have independently certified every consequence of either paper. No false
literal assertion of a staged manuscript has been established at this point.
In particular, failure of independence for higher-rank extensions would not
refute the first paper's correctly rank-one base case.

The local Wiki index and topic descriptions contained no relevant prior
projection/localization result. A bounded external discovery search returned
the staged qubit paper and older qubit QAC0 papers, but no primary source
establishing this arbitrary-rank theorem. Its generated summary also made
unsupported claims about noncommuting projections; those claims are not used.
This is a scoped negative retrieval result, not a verified novelty claim.
The proof below will be self-contained and use no unproved localization,
Pauli expansion, pruning, Jordan-block reduction, or independence assumption.

The primary upstream `lean/docs/274.md`, obtained through the GitHub contents
API during scope, now reports a Lean formalization of the qubit localization
estimate and the positive-advantage parity bound. It explicitly says that
regular-trajectory propagation and pruning are not separately formalized.
That is stronger than the campaign's initial "Partially/Comparator" metadata.
No upstream compiler result is inherited here: the new source must pass its
own real compiler run, and its statement must cover arbitrary ranks.

The scalar Bernoulli route is retired for the extension: a vector in
`tensor_i range(P_i)` may be entangled across the counted sites when those
ranges have dimension greater than one. The replacement is an operator
inequality, which controls every vector simultaneously.

## The theorem

Let `H = tensor_{i=1}^N H_i`, where the `H_i` are arbitrary finite-dimensional
complex Hilbert spaces. On each site let `P_i,E_i` be arbitrary orthogonal
projections, possibly zero or identity, and put

```
M = sum_i (I-P_i),   D = sum_i (I-E_i).
```

An uncounted site is represented by the identity projection. Let `U` have
`d` layers of reflections, with arbitrary tensor-product local unitaries
before, between, and after them. Each reflection is `I-2A_g`, with
`A_g = tensor_{i in J_g} R_{g,i}` for local orthogonal projections of
arbitrary ranks; gate supports within one reflection layer are disjoint.

**Theorem.** For every integer `d>=0` and every fixed real `0<=s<t`, there
exists `N0=N0(d,s,t)` such that for every `N>=N0` and all the data just
specified,

```
|| [M>=N^t] U[D=0]U* [M=0] || <= exp(-N^s).
```

The threshold is independent of every local dimension, projection rank,
gate arity, matrix entry, and counted subset. Vectors in the initial zero
sector may be arbitrarily entangled, including across counted sites.
If any tensor factor has dimension zero the whole operator is zero, so
we may take the local dimensions positive in the proof.

The improvement over the strongest relevant staged result is the removal
of its qubit and selected-local-rank-one restrictions. The exponent region
`0<=s<t` and circuit depth are unchanged. This is a proposed structural
extension, not a new discovery of the already stated parity lower bound.

## 1. The noncommutative base case

All inequalities in this section are Loewner inequalities. For two
idempotents `P,Q`, expansion with `P^2=P,Q^2=Q` gives the universal identity

```
P - P Q (2I-P) Q P = (P-PQP)^2.                    (1)
```

No interchange of `P` and `Q` occurs. For orthogonal projections,
`P-PQP` is self-adjoint, so (1) is a positive-square certificate. Moreover,

```
B := P Q (2I-P) Q P
   = (QP)* (QP) + ((I-P)QP)* ((I-P)QP) >= 0.        (2)
```

Thus `0<=B<=P`. Identity (2) uses `P^2=P` and self-adjointness, but does not
even need `Q^2=Q`. These facts are valid at every rank.

Let `A=tensor_i Q_i` be any product projection and `P0=tensor_i P_i=[M=0]`.
Since the count summands are local orthogonal projections,

```
2^M = tensor_i (P_i+2(I-P_i)) = tensor_i (2I-P_i).
P0 A 2^M A P0 = tensor_i B_i <= tensor_i P_i = P0. (3)
```

For completeness, tensor monotonicity follows by induction from

```
B tensor D - A tensor C
  = (B-A) tensor D + A tensor (D-C) >= 0
```

whenever `0<=A<=B` and `0<=C<=D`. Equivalently, the difference in (3)
is the telescoping sum with `B_i` on earlier sites, `P_j-B_j` on the
current site, and `P_i` on later sites. Every term is positive.
There is no assertion of scalar independence.

For real `r>=0`, the integer spectral decomposition of `M` gives
`[M>=r] <= 2^(-r) 2^M`. Compressing this inequality by `A P0` and using
(3) yields the **universal, nonasymptotic bound**

```
P0 A[M>=r] A P0 <= 2^(-r) P0,
||[M>=r] A P0||^2 <= 2^(-r).                       (4)
```

It applies to every vector, not just separable vectors. In particular
`||2^(M/2) A v||^2<=||v||^2` whenever `P0 v=v`. Local conjugation preserves
the product-projection class, so (4) proves the depth-zero theorem once
`N^(t-s)>=2/log(2)`. This includes `s=0`.

An exact higher-rank stress case is

```
P = diag(1,1,0,0),
Q = (1/25) [[9,0,12,0], [0,16,0,12],
            [12,0,16,0], [0,12,0,9]].
```

Both have rank two, `PQ!=QP`, and (1) has defect
`diag(256/625,81/625,0,0)`. On two sites, apply `Q tensor Q` to
`v=e0 tensor e0+e1 tensor e1`, which lies in the `P tensor P` zero sector
and has Schmidt rank two. The normalized binary mismatch distribution is

```
(Pr(00),Pr(01),Pr(10),Pr(11))
  = (72097,48528,48528,41472)/210625.
Pr(1 at a specified site) = 144/337,
Pr(11) - Pr(1)^2 = 1016064/70980625 > 0.
```

Thus scalar independence fails even though the operator bound holds.
This refutes only the proposed scalar extension, not a staged assertion.

## 2. Binary subspace patterns, with no dimension cost

Write `B_d(s,t)` for the full universal theorem at the displayed depth and
exponents. Assume all fixed pairs at depth `d-1`. For fixed
`alpha,sigma>=0` and `beta>max(alpha,sigma)`, we claim uniformly

```
||[M>=N^beta] B [M<N^alpha]|| <= exp(-N^sigma),      (5)
```

where `B=V A V*`, `V` has depth `d-1`, and `A` is any product projection.

For `F` a subset of the counted sites, define
`P_i^F=I-P_i` on `F` and `P_i^F=P_i` elsewhere; let `M^F=sum_i(I-P_i^F)`.
The arbitrary-rank product projection `[M^F=0]` specifies that binary
subspace pattern exactly. The mutually orthogonal pattern projections sum
to identity on the counted register, and

```
[M<N^alpha] = sum_{|F|<N^alpha} [M^F=0],
M^F >= M-|F|I.
```

These are commuting count operators because the only two projections at a
site are `P_i,I-P_i`. Entanglement and the ranks of their ranges have no
bearing on these equalities. Zero pattern projections can simply remain
in the sum.

Choose fixed `max(alpha,sigma)<sigma'<beta'<beta`. For sufficiently large
`N`, `N^beta-N^alpha>=N^beta'`. The high-`M` projection is therefore below
`[M^F>=N^beta']` for every eligible `F`. Apply
`B_{d-1}(sigma',beta')` to `M^F`, then sum using the triangle inequality.
There are at most `(1+N)^(ceil(N^alpha)+1)` patterns, **not** a number of
local basis states. The resulting bound is

```
exp((ceil(N^alpha)+1) log(1+N)-N^sigma') <= exp(-N^sigma).
```

All exponent choices are fixed before `N` or the circuit data are chosen.
For example take `q=max(alpha,sigma)`,
`sigma'=q+(beta-q)/3`, and `beta'=q+2(beta-q)/3`.

## 3. Ordered reflection expansion for small support

Still assume all pairs at depth `d-1`. For fixed `u,w>=0` and
`t>max(u,w)`, every product projection `A` supported on `k<=N^u` sites
satisfies

```
||[M>=N^t] U A U* [M=0]|| <= exp(-N^w).            (6)
```

For `t>1` the high projection vanishes when `N>1`. Otherwise write
`U=V F L`, where `V` has depth `d-1`, `F` is the first reflection layer,
and `L` is local. The projection `A'=L A L*` has the same support.
Gates of `F` disjoint from that support commute with `A'` and cancel.
Disjointness of gate supports leaves at most `k` gates.

Expand every remaining `I-2A_g` on the two sides. The total absolute
coefficient mass is at most `3^(2k)=9^k`. Each ordered term is
`A_left A' A_right`. Within each side, selected gates are disjoint, hence
`A_left` and `A_right` are arbitrary-rank product projections. We do not
commute them past `A'`. Conjugation by `V` gives `B1 B2 B3`, each a
conjugated product projection at depth `d-1` and a contraction.

Choose `max(u,w)<w'<tau1<tau2<t` and put
`P0=[M=0]`, `H=[M>=N^t]`, `E_j=[M<N^tau_j]`. The exact decomposition is

```
H B1 B2 B3 P0
 = H B1 B2 (I-E1) B3 P0
 + H B1 (I-E2) B2 E1 B3 P0
 + H B1 E2 B2 E1 B3 P0.
```

The first jump is controlled by `B_{d-1}(w',tau1)`. The second and third
are controlled by (5), with triples `(tau1,w',tau2)` and `(tau2,w',t)`.
Every remaining factor is a contraction. Thus each ordered term has
norm at most `3 exp(-N^w')`, and the entire expansion is at most

```
3 exp((log 9) N^u-N^w') <= exp(-N^w).
```

For explicit fixed auxiliary exponents, take `q=max(u,w)` and place
`w',tau1,tau2` at the quarter, half, and three-quarter points of `(q,t)`.
Neither projection ranks nor local dimensions enter this argument.

## 4. A self-contained coefficient-controlled polynomial

For fixed `0<a<b` and `u>(a+b)/2`, sufficiently large `N` admits a real
polynomial `p(x)=sum c_k x^k` such that

```
p(0)=1,  deg p<=N^u,  W_N(p):=sum |c_k| N^k<=exp(N^u),
|p(j)|<=exp(-N^a) for all integers 1<=j<=ceil(N^b). (7)
```

This scalar statement imposes no restriction `b<=1`. Here is its proof,
so no external approximation result is an assumption of our theorem.

Put `r=ceil(N^a)`, `m=ceil(N^b)`, and
`ell=ceil(2 sqrt(mr) log m)`. Eventually `m>=2r` and `m>=3`. Define

```
F(x)=product_{j=1}^r (1-x/j),
z(x)=(m+r-2x)/(m-r),
p(x)=F(x) T_ell(z(x))/T_ell(z(0)),
```

where `T_0=1,T_1=x,T_{j+1}=2x T_j-T_{j-1}`. The cosine recurrence
gives `|T_j(y)|<=1` on `[-1,1]`. The same recurrence gives
`T_j((h+h^-1)/2)=(h^j+h^-j)/2` for `h>0`. For
`q=sqrt(r/m)` and `h=(1+q)/(1-q)`,

```
z(0)=(h+h^-1)/2,
log h=2 integral_0^q (1-y^2)^(-1) dy >= 2q,
T_ell(z(0)) >= (1/2) exp(2 ell sqrt(r/m))
             >= (1/2) m^(4r) >= 1.
```

The exact roots of `F` settle integers `1,...,r`. On `[r,m]`,
`|F|<=m^r` and `z(x)` lies in `[-1,1]`, so
`|p(x)|<=2m^(-3r)<=exp(-N^a)` eventually. No noninteger approximation
in `(0,r)` is used.

Coefficient convolution gives `W_N(fg)<=W_N(f)W_N(g)`. Also

```
W_N(F) <= (1+N)^r,
beta:=W_N(z)=(m+r+2N)/(m-r)<=3+2N,
A:=2 beta+1<=11(1+N),
W_N(T_j(z))<=A^j.
```

The last inequality follows by induction, since
`2 beta A^j+A^(j-1)<=A^(j+1)` and
`A^2-2 beta A-1=2 beta>=0`. Dividing by the denominator, which is at
least one, proves

```
W_N(p)<=(1+N)^r (11(1+N))^ell,  deg p<=r+ell.
```

Writing `gamma=(a+b)/2`, the rounded definitions give
`r=O(N^a)`, `ell=O(N^gamma log N)`, and
`log W_N(p)=O(N^gamma (log N)^2)=o(N^u)`. These constants depend only
on the exponents. This proves (7).

## 5. One backward step and the exact inverse substitution

Assume all pairs at depth `d-1`, and suppose

```
0<=s<t<b<2t-s,   B_d(t,b).                         (8)
```

We prove `B_d(s,t)` without assuming it. Put `delta=2t-s-b>0` and choose

```
a=s+delta/4,   u=t-delta/4,   w=t-delta/8.
```

Then `s<a<u<w<t<b` and `u>(a+b)/2`. Fix arbitrary data in the theorem,
and set `C=U D U*`, `Q=[C=0]`, `P0=[M=0]`, `H=[M>=N^t]`.
Apply (7) for `a,b,u`.

Every summand of `D` is the arbitrary-rank local projection `I-E_i`.
Expansion of `D^k` has at most `N^k` ordered monomials. Repeated indices
collapse by idempotence; distinct-site factors commute. Every resulting
monomial is a product projection supported on at most `k` sites.
Using (6) termwise for `k<=deg p<=N^u` gives

```
||H p(C) P0|| <= exp(N^u-N^w),    ||p(C)||<=exp(N^u). (9)
```

The constant term contributes zero to the first inequality because
`H P0=0`. There is no rank-dependent expansion of a local projection.

The square and substitution must have the following order:

```
||H Q P0||^2 = ||H Q P0 Q H||
 <= ||H p(C) P0 Q H|| + ||H(Q-p(C))P0 Q H||
 <= ||H p(C) P0|| + ||(Q-p(C))P0 Q||.              (10)
```

This is the norm of `T T*` for `T=H Q P0`, not a commutation rule.
Only the leftmost `Q` was replaced. The integer spectrum of `C` and (7)
now give, after splitting at `N^b`,

```
||(Q-p(C))P0 Q||
 <= exp(-N^a)+(1+exp(N^u)) ||[C>=N^b]P0 Q||.       (11)
```

The error vanishes at zero and is small at every positive integer below
the cutoff; the polynomial may be large above it.

Each reflection layer is self-adjoint; its inverse has the same disjoint
gates. Reversing all factors, without commuting overlapping factors,
therefore leaves `U*` at depth `d`. Unitary conjugation gives exactly

```
||[C>=N^b]P0 Q||
 = ||[D>=N^b] U*[M=0]U [D=0]||
 <= exp(-N^t).                                   (12)
```

The last line uses the already assumed **universal** assertion `B_d(t,b)`
with the two counts exchanged. It is not an assumption about the target
pair `(s,t)`.

Combining (9)--(12),

```
||H Q P0||^2
 <= exp(N^u-N^w)+exp(-N^a)+(1+exp(N^u))exp(-N^t).   (13)
```

Every term is eventually at most `(1/3)exp(-2N^s)` because `w>u`,
`t>u`, and `a,w,t>s`. Taking square roots proves `B_d(s,t)`, including
`s=0`. The strict power gaps pay for the square root and every constant.

## 6. Finite scale induction and uniformity

Depth zero was proved in (4). Induct on `d`, assuming the entire theorem
at depth `d-1` for every fixed exponent pair. For a target
`0<=s<t<=1`, let

```
g=t-s,   eta=g^2/100,   K=ceil(2/g),
s_0=s, t_0=t,
s_{i+1}=t_i,   t_{i+1}=2t_i-s_i-3eta.
```

The exact recurrence gives

```
g_i=t_i-s_i=g-3i eta,
t_i=t+i g-(3eta/2)i(i+1).
```

Since `0<g<=1`, `K<=2/g+1<=3/g`; hence for every `i<=K`,
`3i eta<=9g/100<g/2`. Thus `g_i>g/2` and
`t_K=t+sum_{i=1}^K g_i>t+Kg/2>=t+1>1`.
Let `J<=K` be the first index with `t_J>1`. At that exponent the tail
is zero for `N>1`, irrespective of dimensions, because `M<=NI`.

Work backwards. For each `i<J`,

```
t_i < t_{i+1} = 2t_i-s_i-3eta < 2t_i-s_i.
```

The assertion already proved at index `i+1` is
`B_d(s_{i+1},t_{i+1})=B_d(t_i,t_{i+1})`. Section 5 therefore proves
`B_d(s_i,t_i)`. The finite chain reaches the target. For `t>1`, the
theorem was trivial from the outset.

This proves every depth. At a fixed depth and pair, the scale chain is
finite; each step calls only finitely many fixed tuples at depth `d-1`.
Monomials, supports, and binary patterns may vary in number with `N`,
but all share the **same** preceding-depth threshold. Their costs have
already been paid in (5), (6), and (9). Taking the maximum of finitely
many thresholds preserves uniformity. No threshold uniform over every
real exponent pair is claimed or needed.

The threshold dependence can be made effective directly from the proof.
For example, for `C>0`, integer `k>=0`, and `epsilon>0`,

```
N >= exp(max(1, C (k+1)! / epsilon^(k+1)))
   implies C (log N)^k <= N^epsilon.
```

Indeed use the `(k+1)`-st nonnegative term of the exponential series at
`epsilon log N`. Together with `N^epsilon>=C` this bounds all the
displayed polynomial/entropy terms. To implement the proof's thresholds:
use the depth-zero threshold; the two fixed previous-depth calls in each
use of (5); the three fixed calls in (6); the polynomial's rounded
degree/coefficient bounds in (7); and, in (13), the three inequalities

```
N^w >= N^u+2N^s+log 3,
N^a >= 2N^s+log 3,
N^t >= N^u+2N^s+log 6.
```

Their strict exponent gaps give finite thresholds by the preceding
elementary bound. Finally take maxima backwards along the finite chain
and then through the finite depth tree. This specifies dependencies
using only `d,s,t` and numerical constants; no hidden dimension, rank,
state, or gate parameter occurs.

## 7. Exact and formal evidence: what is and is not certified

`research/verify.py` checks the universal identities by exact coefficient
normalization in the free algebra subject only to the explicitly stated
idempotent relations. It checks the tensor monotonicity induction identity,
ordered reflection substitution, positive-gap parameter identities, and
the scale recurrence symbolically. Those are universal certificates, not
inferences from a bounded matrix search. Exact rational noncommuting
rank-two examples, an entangled zero-sector example, degenerate
projections, and a polynomial construction serve only as additional
falsification checks.

`research/Main.lean` separately proves the arbitrary-ring defect identity,
its arbitrary-finite-complex-matrix positive-square consequence, positivity
of the weighted block, the independently sized tensor-order induction
step, and the general compressed-tail implication. Its exact quantifiers
and the boundary of the formalization are stated in
`research/statement_fidelity.md`. The rest of the theorem is the
self-contained mathematical proof above; it is not mislabelled as a
kernel-checked full circuit theorem.

Jacobian 0.14.0, MCP protocol 2025-11-25, was queried for the projection/SOS
subproblem. The inspected polynomial SOS contract is commutative over QQ
and cannot certify (1) for noncommuting operators. The inspected
`matrix.subsystem.psd_order.decide` contract does fit an exact bounded
matrix falsification check. It was executed once on (1)'s rank-two
noncommuting example. The exact request and typed output are preserved in
`research/jacobian_projection_payload.json` and
`research/jacobian_projection_output.json`; the adapter exited zero and
reported inertia `(2 positive,0 negative,2 zero)`. This finite result is
not used as a proof of the universal theorem.

No original manuscript assertion is refuted by the extension or by the
correlated higher-rank example. The unsupported scalar higher-rank route
is recorded separately and retired. The new theorem's correctness,
statement fidelity, publication significance, and originality remain
subject to the Host's independent Reviewer; no Reviewer verdict is
manufactured by the Engineer.

The exact verifier completed successfully, including 54 rational projection
rank-pair cases and the universal free-algebra/symbolic checks. The fresh
Lean 4.31.0 run and its declaration audit both exited zero, with
`proof_holes=[]`. The compiler-earned record for `C_DIM_CORE` is
`research/certificates/C_DIM_CORE-226cb13096ae45f7.json`; the ledger reports
that core as `closed_kernel` with no undischarged assumptions. The full
analytic circuit theorem remains a prose proof awaiting independent review.
An initial run failed on notation scope and a Kronecker entry simplification;
the corrected source was recompiled, rather than treating that failure as
mathematical evidence.

To replay the exact certificate from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/verify.py
```

For a fresh real formal replay, the installed CLI takes the source
positionally:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify --project-root . --claim C_DIM_CORE research/Main.lean --statement-fidelity research/statement_fidelity.md
```
