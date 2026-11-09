# A dimension-free ordered coefficient / positive-block implication

## Scope and source findings

This work concerns the implication `eq:pairing`--`eq:cross-L2` and
`thm:domain` in the staged **A direct proof of the complete Crouzeix
inequality**, September 26, 2026, `build/main.tex`, lines 348--453
(the domain theorem begins at line 323).
The companion is **The complete Crouzeix theorem**, September 23, 2026.
The staged sources, not a purported formalization of their final conclusions,
are the assertions under examination.

The direct manuscript distinguishes scalar results (`m=1`) from complete
results with bounded base dimension (`n<=3`), at lines 94--105. Neither settles
independent, arbitrary `n,m`. Its unweighted Faber estimate is proved using
convexity and both angular marginals (`lem:faber`, `prop:coefficients`).
The classical weighted Grunsky inequality alone is not that estimate:
the weights and the coefficient orientation must not be silently changed.
The direct source explicitly uses `s[k,j]=beta[j,k]`, not symmetry.

Upstream `openai/math`, revision
`4eaee87548250b2682affda7d05d947c05554bae`, `lean/docs/325.md`,
claims a full formalization (including arbitrary Hilbert spaces); this is a
source-scope finding, **not** a local compiler receipt. Inspection of
`lean/OAI/Analysis/DirectCrouzeix/CompleteBound.lean` found that
`complete_crouzeix` uses `expLevel_domain_bound_scaled` from `DomainBound`.
Importing that final bound would be circular for this audit.
The relevant implementation guidance is `Duality.lean`,
`weighted_coefficient_dual` (positive arbitrary finite weights, bilinear entry
pairing), and `PositiveBlocks.lean`, `positive_block_hsSq` (a positive
Hermitian block with no commutativity premise). No upstream theorem with the
constant-two conclusion will be imported here.

The companion's main statements are `thm:structural`, lines 116--130
(optimal similarity), and `thm:representation`, lines 132--150 (one positive
density at every coefficient level). Their load-bearing dependencies include
`input:analytic`, lines 550--587, `prop:projection`, lines 715--747,
`prop:extremal`, lines 386--401, and `lem:comparison`, lines 977--1062.
This audit does not replace those obligations by their conclusions.

## Mathematical statement

The theorem to be certified is an implication, not a new unconditional proof
of existence of conformal coordinates. Given the coefficient sandwich,
ordered multiplication identities, and a positive resolvent field with its
convergent Fourier expansion, its conclusion is uniform in base size,
coefficient size, degree, and tail length. The weighted dual estimates and
positive-block comparison must be *derived*, not supplied as hypotheses.

Analytic applicability still requires the exterior collar, the nonnegative
doubly normalized exterior kernel, and the absolutely convergent resolvent
expansion. Those premises are named separately in the ledger. They are
proved in the staged source, but are not inherited from an upstream
constant-two theorem or from finite experiments.

No manuscript assertion is currently declared false. In particular,
noncommuting coefficients alone do not refute an argument that explicitly
uses both multiplication orders.

## The uniform verification theorem and proof

Write `|C|_2^2=tr(C* C)` for the unnormalized squared Hilbert--Schmidt norm;
the star is conjugate transpose. Let `b_0=1,b_1,...` be a scalar polynomial
basis, with `b_k` of degree `k`. For arbitrary finite base and coefficient
dimensions, assume the following analytic data, independently of any
constant-two conclusion:

1. Evaluation is `G[A]=sum_k b_k(A) tensor C_k`. On the chosen boundary
   the squared Hilbert--Schmidt energy `B(G)` satisfies
   `sum_k |C_k|_2^2 <= B(G) <= |C_0|_2^2+2 sum_{k>=1}|C_k|_2^2`.
2. The resolvent field has the absolutely uniformly convergent expansion
   `R=sum_{k>=0} b_k(A) lambda^(-k)`, with `b_0(A)=I` and `R+R*>=0`.
3. `F` has boundary operator norm at most one. The same coefficient
   sandwich applies at **every finite degree**, including the full
   products `FG` and `GF`.

Then `||F[A]||<=2`, uniformly in both dimensions and degree. More generally,
replacing the upper nonconstant weight two by any `beta>0` gives
`||F[A]||^2<=max(4,2 beta)`. No symmetry of the exterior kernel is required.

Here is an independent proof of the implication.
For `gamma=||F[A]||>0`, choose unit top singular vectors `x,y`, and reshape
them into `n`-by-`m` matrices `X,Y` as in the manuscript. Set
`P=X*RX`, `Q=Y*RY`, `M=Y*RX`, `L=X*RY`.
Absolute convergence passes to all four compressions. Put
`a^2=sum_{k>=0}|M_k|_2^2`, a finite real number.

**Entry orientation and the off-diagonal functional.**
Expanding the two tensor factors gives

    y*G[A]x = sum_{k,i,j} (Y* b_k(A) X)[i,j] C_k[i,j].

This is a bilinear entry pairing. Complex Cauchy--Schwarz, applied to the
finite coefficients of `G` and capped by the **full** `M` energy, gives
`|y*G[A]x|^2 <= a^2 sum_k |C_k|_2^2`. Taking `G=F` shows `a>0`;
otherwise its left side is `gamma^2>0`.

**Both multiplication orders.**
The coefficient of each evaluated monomial product is
`A^(i+j) tensor (D_i E_j)`. No coefficient exchange is permitted.
The singular equations give, separately,

    y*(FG)[A]x = gamma x*G[A]x,
    y*(GF)[A]x = gamma y*G[A]y.

For each product, the off-diagonal bound followed by the lower coefficient
estimate bounds its squared functional by `a^2 B(product)`. The respective
Hilbert--Schmidt multiplier inequalities give
`B(FG)<=B(G)` and `B(GF)<=B(G)`. The upper coefficient bound for `G` then
gives each diagonal functional the weighted squared bound

    gamma^2 |diagonal(G)|^2
      <= a^2 (|C_0|_2^2+2 sum_{k>=1}|C_k|_2^2).

**Weighted duality is derived.**
For any finite complex array `p_i` and positive real weights `w_i`, suppose
`|sum_i p_i c_i|^2 <= b sum_i w_i |c_i|^2` for every test array.
Test with `c_i=conjugate(p_i)/w_i`. Both the paired value and the weighted
test energy equal the nonnegative real `d=sum_i |p_i|^2/w_i`.
Thus `d^2<=b d`, and `d<=b`, including `d=0`.
Apply this to every finite prefix of `P` and then of `Q`, with weights
one at zero and two elsewhere. Since the full sequences are square
summable, the prefixes converge, giving

    D_P=|P_0|_2^2+(1/2)sum_{k>=1}|P_k|_2^2 <= a^2/gamma^2,
    D_Q=|Q_0|_2^2+(1/2)sum_{k>=1}|Q_k|_2^2 <= a^2/gamma^2.

There is no replacement of the infinite resolvent by a truncated positive
field. Only polynomial *tests* are finite.

**Full Fourier bookkeeping.**
The means satisfy `P_0=P_0*`, `Q_0=Q_0*`, and `L_0*=M_0`, because
`b_0(A)=I`. Parseval, with the disjoint positive and negative frequencies,
therefore gives

    E_P=integral |P+P*|_2^2 = 4D_P,
    E_Q=integral |Q+Q*|_2^2 = 4D_Q,
    E_Z=integral |M+L*|_2^2
       =4|M_0|_2^2+sum_{k>=1}(|M_k|_2^2+|L_k|_2^2)
       >=a^2.

In particular, discarding `M_0` before this computation is not legitimate.
Absolute convergence justifies the Fourier identities and passage to the
full energies. The formal theorem exposes these analytic facts as premises
rather than claiming to formalize Parseval from conformal mapping.

**Positive-block inequality is derived.**
For any positive complex block `Delta=[U Z*;Z V]`, including rectangular `Z`,
let `J=diag(I,-I)`. Both `Delta` and `J Delta J` are positive. If `B=C* C`
and `A>=0`, then
`Re tr(A B)=Re tr(C A C*)>=0`; this proves trace-product positivity without
assuming that positive matrices commute. Consequently

    0 <= Re tr(Delta J Delta J)
       = |U|_2^2+|V|_2^2-2|Z|_2^2.

Apply this pointwise to the compression of the original `R+R*` by `[X Y]`
and integrate. It gives `2E_Z<=E_P+E_Q`. Combining the preceding, independently
derived estimates gives

    2a^2 <= 2E_Z <= E_P+E_Q <= 8a^2/gamma^2.

As `a>0`, `gamma<=2`. This proves the parameter-uniform implication, not just
its last scalar cancellation.

For the quantitative variant, duality uses weights `1,beta`.
If `c=max(4,2 beta)`, then
`4|P_0|^2+2 sum_{k>=1}|P_k|^2 <=
c(|P_0|^2+sum_{k>=1}|P_k|^2/beta)`, and likewise for `Q`.
The same positive-block proof gives `gamma^2<=c`.
This is a structural extension of the interface. No claim that this
quantitative observation is new to the literature is made.

## Exact adversarial computations

`verify.py` uses exact SymPy arithmetic, not numerical eigenvalue tolerances.
The three disk examples have `(n,m)=(3,2),(2,3),(2,2)`. They verify the
actual top singular equations, the full finite products in both orders,
the bilinear pairing, weighted energies, resolvent congruence, and
positive compression. All principal minors are checked exactly.
For the first two, `A` has one entry `3/2` in a square-zero block, so
`W(A)` is the disk of radius `3/4`, strictly inside the unit disk.
The boundary polynomial is `U(I-E+zE)`, with `U` a rational rotation and
`E` an orthogonal rank-one projection. It is unitary on the circle, its
coefficients do not commute, and its evaluation norm is `3/2`.
The third uses `F=(1+z)U/2` and a rational-radical top singular pair,
retaining a nonzero constant cross coefficient. These are examples
satisfying all domain hypotheses, **not** a finite search proof of the theorem.
Wrong transpose and adjoint pairings are rejected as negative controls;
they are not assertions made by the manuscript.

A genuinely nonsymmetric exterior example is
`h(lambda)=lambda+(1/32)lambda^(-2)`. In reciprocal coordinates
`u=1/lambda,v=1/mu`, set

    H=1-a(uv^2+u^2v),
    s=-u H_u/H=a(uv^2+2u^2v)/H,  a=1/32.

Thus `s_12=a` and `s_21=2a`, explicitly disproving the *tempting extra*
symmetry assumption, not the manuscript. For `|lambda|,|mu|>3/4`,
`|H-1|<2a/(3/4)^3=4/27<1`, so the divided difference never vanishes;
this proves exterior collar injectivity, including the derivative on the
diagonal. On the unit circle the positive-curvature numerator of
`1+lambda h''/h'=(1+4a u^3)/(1-2a u^3)` is at least
`1-2a-8a^2=119/128>0`. The simple, regularly parametrized boundary has
strictly increasing tangent angle and hence bounds a strictly convex
domain. Its orientation is positive, as follows also by deforming `a`
to zero without a zero derivative.

The exact numerator of `K=1+s+conjugate(s)` is

    1+2a Re(u^2v)-4a^2(1+Re(v/u)) >=119/128.

The denominator is `|H|^2>0`. Its correction has only strictly mixed
frequencies, so both angular marginals are one. This directly validates
the orientation-sensitive analytic premise on a nonsymmetric example.

For a genuinely infinite tail take `h(lambda)=lambda+r/lambda`, `0<r<1`,
the convex ellipse, `A=0`, `F=1`, and `x=y=1`. Then

    R=(1-r/lambda^2)/(1+r/lambda^2),
    R_0=1, R_(2k)=2(-r)^k, R_(2k+1)=0.

The resolvent Hermitian part is strictly positive, since its real-part
numerator is `1-r^2`. Exact summation gives
`a^2=1+4r^2/(1-r^2)`, `D=1+2r^2/(1-r^2)`, and boundary energy `4D`.
The dual energy remaining after index `2N` is exactly
`2r^(2N+2)/(1-r^2)`, which tends to zero but is not zero at any finite
cut-off. The script certifies these identities symbolically.

## Jacobian and formal certification

Discovery selected `matrix.symmetric.rational_spectrum_claim.check`.
The exact inspected contract, payload, and typed result are retained in
`jacobian_contract.json`, `jacobian_payload.json`, and `jacobian_result.json`.
Jacobian 0.14.0, protocol 2025-11-25, returned `VALID` for a rational
four-by-four block with complete spectrum `0,0,2,2`. A separate exact Gram
factorization and equality in the positive-block estimate are replayed by
`verify.py`. The adapter exited zero; no timeout, incomplete result, or
`UNKNOWN` was counted as evidence.

This operation matches a bounded rational positivity example, but its contract
does **not** prove a complex, parameter-uniform or infinite-tail theorem.
That mismatch is explicit rather than stretching the operation's meaning.
The uniform algebraic implication is instead proved in `Main.lean`, using
only Mathlib and no upstream Crouzeix conclusion. Its statement and analytic
boundary are mapped in `statement_fidelity.md`.

Compared with the preceding source-only findings, the advance is an
independently authored universal ordered-test / weighted-dual / positive-block
proof, with both unbounded coefficient prefixes and genuinely nonsymmetric
and infinite-tail exact checks. The analytic input claims and the companion
structural construction remain separately visible in the proof graph.
Independent replay, statement-fidelity approval, and any publishability or
novelty decision belong to the Host-invoked Reviewer. This report does not
declare the campaign complete.

The installed `lean_evidence verify` accepts the source as a positional
argument, rather than the mission example's `--source` spelling. The
equivalent invocation uses the required interpreter, campaign root, claim,
and fidelity document. The compiler receipt and archived claim certificate
remain authoritative for its actual exit code and proof-hole list.

The official run completed under Lean **4.31.0** with compiler exit code
**0**, axiom-audit exit code **0**, and **`proof_holes=[]`**.
It recorded mechanical support on `V_DIRECT_CORE` in
`certificates/V_DIRECT_CORE-56e8cd66af6da3e2.json`; `lean_check.json`
and `compile.log` retain the actual compiler result and transcript.
The five printed core declarations depend only on `propext`,
`Classical.choice`, and `Quot.sound`, not a Crouzeix axiom.

Replaying the exact computations requires only SymPy:

    $WORKSPACE/argus-live-update/.venv/bin/python research/crouzeix_core/verify.py

The default replay recomputes and compares `exact_certificate.json`.
No network access or Jacobian service is needed to replay the saved
Jacobian result: its complete spectrum and Gram factorization are
independently recomputed.

The author has **not** submitted independent Reviewer verdicts.
The cited analytic source premises in `D_DOMAIN` and `S_STRUCTURAL`
and the source-scope citations still require the independent reader's
attribution. None is an external assumption of the formal conditional
`V_DIRECT_CORE` theorem: they concern its application to the manuscript
and the separate unformalized analytic constructions.
