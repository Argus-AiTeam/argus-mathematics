# Ordered-sweep entropy algebra

## Scope and dependencies

The target is the **pointwise ordered-metric and probability algebra** in
`An-integral-scalar-curvature-bound-for-real-simplicial-volume-October-5-2026/build/sections/04-entropy.tex`,
especially `eq:entropy-BC-expansion`, `eq:entropy-sharp-T`, and
`eq:entropy-v-error`. Definitions are those of
`build/sections/03-graphs.tex`, `eq:sweep-statistics`, `eq:sweep-T`, and
`eq:sweep-positive-reserve`. Arbitrary finite coordinate count, positive
probability weights without a uniform lower bound, and unbounded
`sigma_i = F_i^2/nu_i` are included.

The manuscript's graph-prescription existence theorem, localization,
one-sweep analytic inequality, conformal bootstrap, entropy iteration,
high-dimensional regular-descendant construction, and transfer theorem
are **not established by this audit**. An implication using the one-sweep
inequality must list it as a hypothesis. Neither checking this algebra nor
finding an error in it would by itself settle the main scalar-curvature
inequality.

The seeded ledger and goal have been retained. The dependency graph separates
the main integral theorem, its normalized-volume reduction, detector, entropy,
degree, transfer, and companion-vanishing inputs from the present algebra.
The strongest prior project result was an untested seeded audit objective;
there was no previous certificate of the ordered-sweep estimates.

## Previously checked external interface

Primary source: Cecchini--Schick, *Enlargeable metrics on nonspin manifolds*,
`arxiv:1810.02116v4`, Theorem 1.14(1),
<https://arxiv.org/html/1810.02116v4#S1.Thmtheorem14>.

The theorem assumes a closed oriented manifold, a smooth nonzero-degree map
to the standard flat torus, and a connected open subset of the first circle.
Only over its inverse image does it require scalar curvature at least
`k_0 > 0` and a bound `epsilon` on the **full differential**. Its conclusion is
`2*pi*epsilon >= sqrt(k_0)*Length(J)`. Part (1) has neither an upper dimension
restriction nor a spin hypothesis. These are precisely the quantifiers used
in the companion manuscript, `build/sections/07-obstruction.tex`, lines 48--66.
The dimension restriction in part (3) does not apply to part (1).

Thus a citation-only attack asserting that this quotation needs a spin or
upper-dimension hypothesis is a closed failed route. This comparison checks
the quoted interface, not the proof of the published theorem, the companion's
stabilization argument, or the companion's vanishing theorem. The present
ordered-sweep theorem does not depend on Cecchini--Schick. Independent
confirmation of the source reading remains with the Host-invoked Reviewer.

## Exact model

At a point put `q_i = N df_i`, `H_0 = h_0`, and
`H_i = H_(i-1) + q_i q_i^T`. After an invertible linear change of basis take
`H_0 = I`. Write

```
k_i = q_i^T H_(i-1)^(-1) q_i,
s_i = A_i^2 = k_i/(1+k_i),       L_i = sqrt(1+k_i),
e_i = H_(i-1)^(-1) q_i/sqrt(k_i)       (k_i > 0),
B_i = 1 - e_i^T e_i,
C_i = 1 - q_i^T H_final^(-1) q_i/s_i   (s_i > 0),
m = sum_i s_i,                  W = sum_i log L_i.
```

Zero updates have `s_i = C_i = 0`; their arbitrary unit directions contribute
zero to every assertion. Equal-color disjoint supports leave at most one
nonzero coordinate per color at a point, so this finite ordered model is the
manuscript's model, not a simultaneous or commuting-update replacement.

For arbitrary `nu_i > 0`, `sum nu_i = 1`, let `p_i = F_i^2 >= 0`,
`sum p_i = 1`, `sigma_i = p_i/nu_i`, `epsilon > 0`,
`u_i = s_i/(epsilon nu_i)`, and `bar_u = m/epsilon`.
Take `r > 0`, `a = 1/2 + theta`, `lambda = 1/2 - 2 theta`, and set

```
M = a(1-r) - bar_u/2,
V_i = a(sigma_i-1) + lambda(u_i-bar_u),
T = sum_i s_i [C_i + 4a^2 sigma_i B_i
              + (L_i-1)(2a(sigma_i+r)+u_i)].
```

This is exactly `T_0`; no positive term has a coefficient larger than its
manuscript coefficient. In particular `T` occurs with coefficient one.

## 1. Exact ordered identities

The rank-one inverse formula is obtained by multiplying the claimed inverse
by `H_(i-1)+q_i q_i^T`:

```
H_(i-1)^(-1) - H_i^(-1) = s_i e_i e_i^T.
```

In particular it holds for noncommuting updates. The determinant formula gives
`det H_final = product L_i^2 = exp(2W)`. Directly from metric addition and
the inverse telescope,

```
B_i = sum_(j<i) (q_j^T e_i)^2,
C_i = (1/s_i) sum_(j>i) s_j (q_i^T e_j)^2       (s_i > 0).
```

These are the manuscript's exact formulas, not commuted versions of them.
There is a useful additional **exact equality of total losses**:

```
d := sum_i s_i B_i = sum_i s_i C_i = m - m_f,
m_f := sum_i q_i^T H_final^(-1) q_i
     = n - tr(H_final^(-1)).
```

Indeed, tracing the inverse telescope gives
`n-tr(H_final^(-1)) = sum s_i |e_i|^2 = m-sum s_i B_i`.
Tracing `H_final^(-1)(H_final-I)` gives the formula for `m_f`.
The definition of `C_i` then gives the other equality. This proof includes
zero updates and has no bound on their number.

## 2. Uniform constants in the two manuscript expansions

Assume `m <= 1/4`. All eigenvalues of each `H_j` are at least one.
Since `product_i(1-s_i) >= 1-sum_i s_i = 1-m`, the determinant identity
implies

```
I <= H_j <= (1-m)^(-1) I,
1-m <= b_i := |e_i|^2 <= 1,      0 <= B_i <= m.
```

The product inequality follows inductively from
`(1-x)(1-y) >= 1-x-y` for nonnegative `x,y` with partial sums at most one.
Let `w_i=e_i/sqrt(b_i)`, `xi_ij=(w_i^T w_j)^2`.
In a forward summand the scalar factor after taking out `s_j` is

```
alpha (w_j^T H_(j-1) w_i)^2,
alpha = L_j^2 b_i b_j.
```

In a backward summand it has the same form with `H_(i-1)` and
`alpha=L_i^2 b_i b_j`. In either case

```
alpha <= 4/3,          |alpha-1| <= 2m,
||H-I|| <= 4m/3,       ||H||+1 <= 7/3.
```

For unit `v,w`, therefore,

```
|alpha(v^T H w)^2 - (v^T w)^2|
 <= (4/3)(4m/3)(7/3) + 2m < 7m.
```

Summing the exact telescopes proves the explicit, cardinality-free version
of `eq:entropy-BC-expansion`:

```
|B_i - sum_(j<i) s_j xi_ij| <= 7m^2,
|C_i - sum_(j>i) s_j xi_ij| <= 7m^2       (s_i > 0).
```

The cancellation of `s_i` in the backward formula occurs **before** the
estimate; there is no hidden lower bound on `s_i`.

Put `delta_i=(1-sigma_i)_+`, `eta=(1-r)_+`, and
`D_sigma=sum s_i delta_i`. For `theta>=0`, `4a^2>=1` and `2a>=1`.
Keep the coefficient one on `T`, drop only nonnegative terms, and use
`sigma_i B_i >= B_i-delta_i B_i`. The forward and backward contributions
are at least

```
2 sum_(i<j) s_i s_j xi_ij - 14m^3 - m D_sigma.
```

Also `L_i-1 >= s_i/2`. Since `sigma_i+r >= 0`, the self terms are at least

```
sum_i s_i^2 - (m/2) D_sigma - (m^2/2) eta.
```

Thus, for `S=sum_i s_i w_i w_i^T`,

```
T >= tr(S^2) - 14m^3 - (m^2/2)eta - (3m/2)D_sigma.       (2.1)
```

This proves `eq:entropy-sharp-T`, with explicit constants no larger than
14 for its three displayed error terms. In fact (2.1) needs only `r>0`,
not the manuscript's restriction near one. The eigenvalues of `S` are
nonnegative and have sum `m`; the identity
`n sum lambda_j^2 - (sum lambda_j)^2 = sum_(j<k)(lambda_j-lambda_k)^2`
proves `tr(S^2)>=m^2/n`. No simultaneous diagonalization of the updates
was used.

## 3. A nonperturbative reserve theorem

For **all** `m`, not just `m<=1/4`, the same definitions satisfy

```
T >= Phi_n(m) - sum_i s_i(B_i+L_i-1)delta_i
                 - eta sum_i s_i(L_i-1),                 (3.1)
Phi_n(m) := 2[m-n(1-exp(-m/n))].
```

Here `n>=1`, `r>0`, `sigma_i>=0`, and `theta>=0` are sufficient; probability
normalization is not needed. This is an independent structural strengthening
of the perturbative scalar reserve estimate.

To prove it, the exact total-loss equality gives

```
T >= 2d + 2 sum_i s_i(L_i-1)
        - sum_i s_i(B_i+L_i-1)delta_i - eta sum_i s_i(L_i-1).
```

Set `G=2W-m=sum_i[-log(1-s_i)-s_i]>=0`.
For `L>=1`,

```
L-L^(-1)-2log L >= 0,
d/dL [L-L^(-1)-2log L] = (L-1)^2/L^2.
```

Consequently `s_i(L_i-1) >= -log(1-s_i)-s_i`, and the positive baseline
above is at least `2[m-m_f+G]`.

If `lambda_1,...,lambda_n>0` are the eigenvalues of `H_final^(-1)`,
their product is `exp(-2W)`. The elementary inequality `exp(t)>=1+t`,
applied after centering their logarithms, gives
`sum lambda_j >= n exp(-2W/n)`. This is the required arithmetic-geometric
mean inequality, with no restriction on the eigendirections. Therefore
`m_f<=f_n(2W)`, where `f_n(x)=n(1-exp(-x/n))`.
For `x>=0`, `0<=f_n'(x)<=1`, so
`f_n(m+G)<=f_n(m)+G`. Substitution proves (3.1).

For `0<=s<=1/4`, the inequality `L-1<=s` follows on squaring from
`(1-s)(1+s)^2-1=s(1-s-s^2)>=0`. Hence, if `m<=1/4`,

```
T >= Phi_n(m) - 2m D_sigma - m^2 eta
  >= m^2/n - m^3/(3n^2) - 2m D_sigma - m^2|r-1|.        (3.2)
```

The last line uses
`exp(-x)>=1-x+x^2/2-x^3/6` for `x>=0`. Subtracting the cubic from
`exp(-x)` gives a function whose first four initial values (orders 0--3)
are zero and whose fourth derivative is positive; four integrations prove
the assertion on the entire nonnegative half-line. Thus the exact
coefficient `1/n` is not inferred from examples or a numerical fit.

### Sharpness over arbitrarily many coordinates

The function in (3.1) is the infimum of its baseline
`2d+2 sum s_i(L_i-1)` for fixed `m` and dimension `n`.
For each integer `k>m/n`, make `k` updates in each of `n` mutually orthogonal
directions, each with `s_i=m/(nk)`. These are realized by positive rank-one
updates: in a direction currently having eigenvalue `h`, add the square
`h*s_i/(1-s_i)`. Then

```
m_f = n[1-(1-m/(nk))^k],
sum s_i(L_i-1) = m[(1-m/(nk))^(-1/2)-1] -> 0,
m_f -> n(1-exp(-m/n)).
```

So the baseline tends to `Phi_n(m)` as `k` tends to infinity. In the actual
`T`, take `sigma_i=r=1`, let `theta` tend to zero, and let `epsilon`
tend to infinity with equal `nu_i=1/(nk)`; the additional nonnegative
terms tend to zero as well. This establishes sharpness over the algebraic
class, not over graphs satisfying the unverified prescription PDE.
It also explains why a global replacement `T>=m^2/n` would be false,
whereas the manuscript correctly allows cubic errors.
For completeness the limit follows by squeezing
`-k log(1-x/k)` between `x` and `x/(1-x/k)`, with `x=m/n`, and then
using continuity of the exponential. No finite sweep search is being used
to infer this limiting optimality.

## 4. Tiny weights and the weighted defect

Let `0<theta<=1/16`, `a=1/2+theta`, and `lambda=1/2-2theta`.
The identity
`a(sigma_i-1)=V_i-lambda(u_i-bar_u)` gives

```
delta_i <= 2|V_i| + |u_i-bar_u|.
```

For every `c'>0`, scalar completion of squares yields

```
2m u |V| <= c' V^2 + (m^2/c')u^2,
m u |d| <= c' theta d^2 + (m^2/(4c' theta))u^2.
```

Since `theta+1/4<=1`, summing against `epsilon nu_i` gives

```
m D_sigma
 <= c' epsilon [E V_i^2 + theta Var u]
    + [m^2/(c' theta)] epsilon [bar_u^2+Var u].           (4.1)
```

This is `eq:entropy-v-error` with first-line constant 2 and
`C_(c')=1/c'`. The only moment identity used is
`E u_i^2=bar_u^2+Var u`. All sums are finite for each instance.
Their magnitudes may diverge as a weight tends to zero; the constants do not.
In particular neither `sigma_i<=1` nor a lower bound on `nu_i` has been used.

`Main.lean`, declaration `weighted_probability_defect`, formalizes (4.1)
for an arbitrary finite index type and even permits zero weights when
`u_i` and `sigma_i` are given as finite numbers. The actual manuscript uses
positive weights and defines those numbers by division; the formal theorem
is applied after that definition, not at a division by zero.
Its exact statement and remaining fidelity obligation are described in
`statement_fidelity.md`.
The fresh Lean 4.31.0 run returned `exit_code=0`, `proof_holes=[]`;
its claim-bound archive is named in `lean_verify_result.json`.
No compiler result is being attached to the larger matrix theorem.

## 5. Explicit critical entropy budget

Fix `n>=1`, `epsilon_* > 0`, `0<c<=1`, and `K>=1`. Choose

```
D >= max(1,8K/c),
0 < l <= min(1,1/(16D),1/(4K)),     theta=Dl,
epsilon >= epsilon_*,              0 <= m <= Kl,
3/4 <= r <= 5/4.
```

Define `H=K^2+K+n` and the explicit constant

```
C_raw = K^3/(3n^2) + 16K^4/(c D epsilon_*) + 4D^2 K
      + 5K^2/6 + 5n/8
      + 2H^2/(c epsilon_*) + HK/epsilon_* + 5/4,
C_crit = (4/3) C_raw.
```

For any real number `Q` satisfying just the pointwise lower bound

```
Q >= T + c epsilon(M^2 + E V_i^2 + theta Var u)
         - 4theta^2 m - r l^3,                            (5.1)
```

one has the quantified conclusion

```
Q >= l m + 2l r W - n r l log(1+l) - C_crit r l^3.        (5.2)
```

All constants are independent of coordinate count, metric eigendirections,
the smallest probability weight, and the largest `sigma_i` or `u_i`.
Hypothesis (5.1) follows from the manuscript one-sweep bound if that analytic
bound is true, `delta_0<=epsilon l^3`, and its square coefficient is at
least `c`. The derivative and boost reserves have only been dropped.

Here are the estimates with the constants exposed. Use (4.1) with `c'=c/8`.
Since `m/theta<=K/D<=c/8`, absorb its variance remainder to obtain

```
2m D_sigma <= (c/4)epsilon E V_i^2
             + (c/2)epsilon theta Var u
             + 16m^4/(c theta epsilon).
```

The last term is at most `16K^4 l^3/(cD epsilon_*)`.
The logarithmic integral estimate
`-log(1-s)<=s+s^2/[2(1-m)]` gives
`W<=m/2+m^2/3` when `m<=1/4`.
Also `log(1+l)>=l-l^2/2`. Thus the budget's right side before its
error is at most

```
2lm - nl^2 + (K+n)l^2|r-1| + (5K^2/6+5n/8)l^3.
```

Combine this with (3.2), `4theta^2 m<=4D^2 K l^3`, and
`|r-1|<=2|M|+bar_u`. The total `r-1` coefficient is at most `H l^2`,
and

```
H l^2|r-1|
 <= (c/2)epsilon M^2
      + [2H^2/(c epsilon_*)+HK/epsilon_*]l^3.
```

Finally `m^2/n-2lm+nl^2=(m/sqrt(n)-sqrt(n)l)^2>=0`;
`r<=5/4` covers the error in (5.1), and `r>=3/4` converts `C_raw l^3`
to `C_crit r l^3`. This proves (5.2), including the exact critical
`m^2/n` coefficient.

## 6. All-regime algebra and the retained surplus

The critical theorem extends to the entire pointwise budget with explicit
parameters. This closes the separate coarse algebra obligation as well;
only the analytic sweep construction remains a hypothesis.

First, for every `m>=0`,

```
Phi_n(m) >= m^2/(n+m).                                    (6.1)
```

Indeed, `1-exp(-t)>=t/(1+t)`, by `exp(t)>=1+t`.
For `0<=t<=x`, the latter is at least `t/(1+x)`.
Integrating `Phi_n(m)=2n integral_0^(m/n)(1-exp(-t))dt`
proves (6.1).

Write `P` for any reserve at least
`T+c epsilon(M^2+E V_i^2+theta Var u)`. Fix

```
e = epsilon_*,
m_0 = min(1/4,e/16),
eta_0 = m_0/[16(n+m_0)],
k_m = min(1/2, m_0/[4(n+m_0)], c e/(512n),
          3 eta_0^3/(64n^2)),
kappa = min(1/[16+3/k_m+4/c], c e/(576m_0)).
```

These are positive, depend only on `n,e,c`, and have no coordinate-count
dependence. We claim

```
P >= kappa(m+rW)
    if m>=m_0 or |1-r|>=1/4.                              (6.2)
```

Here is a quantitative proof of the `m` bound for `m>=m_0`.
Put `S_L=sum s_i(L_i-1)`, and note
`T>=d+r S_L+sum s_i(L_i-1)u_i`.
For `m>=2n`, `d=m-m_f>=m-n>=m/2`.
For `m_0<=m<=2n` and `r>=1/2`,

```
T >= (d+S_L)/2 >= Phi_n(m)/4
  >= [m_0/(4(n+m_0))]m.
```

For `r<1/2` and `|M|>=1/16`,
`c epsilon M^2>=c e/256>=c e m/(512n)`.
In the remaining case `r<1/2`, `|M|<1/16`, the formula for `M` and
`1/2<=a<=9/16` give `3/8<=bar_u<=5/4`, hence
`epsilon=m/bar_u<=16n/3`.
If some `s_i>=eta_0`, then, since `nu_i<=1`,

```
s_i(L_i-1)u_i >= s_i^3/(2epsilon)
              >= 3 eta_0^3/(32n)
              >= [3 eta_0^3/(64n^2)]m.
```

If instead every `s_i<eta_0`, then
`2W<=m/(1-eta_0)<=m+2eta_0 m`.
The 1-Lipschitz property of `f_n` used in Section 3 and (6.1) imply

```
d >= Phi_n(m)/2 - 2eta_0 m
  >= [m_0/(4(n+m_0))]m.
```

Thus `P>=k_m m` for every `m>=m_0`.

For the volume bound, indices with `s_i>=1/16` satisfy
`r log L_i<=16r s_i(L_i-1)`, so their contribution to `rW` is
at most `16P`. The other indices satisfy `log L_i<=s_i`, and contribute
at most `rm`. If `r<=2`, this is at most `2P/k_m`. If `r>2`, then
`|M|>=r/4+bar_u/2`, so
`c epsilon M^2>=c rm/4`. Hence
`m+rW<=(16+3/k_m+4/c)P`, proving (6.2) for `m>=m_0`.

If `m<m_0` and `|1-r|>=1/4`, then
`bar_u<=1/16`, `|M|>=|1-r|/4`, and `W<=m`.
The elementary inequality `1+r<=36(1-r)^2` on this region gives

```
m+rW <= 36m_0(1-r)^2 <= [576m_0/(c e)]P.
```

This proves (6.2) everywhere asserted. To check the elementary inequality,
substitute `r=5/4+x` or `r=3/4-x`; its difference becomes respectively
`36x^2+17x` or `36x^2+19x+1/2`, for `x>=0`.

For the noncritical small region, `m<m_0`, `3/4<r<5/4`, use

```
T >= (3/4)(d+S_L) >= (3/8)Phi_n(m) >= b_n m^2,
b_n := 3/[8(n+1/4)].
```

Choose

```
K = max(1,12/b_n),       D = max(1,8K/c),
l_0 = min(1,1/(16D),1/(4K),b_n K/(16D^2),kappa/(16D^2)),
C_full = max(1,C_crit),  gamma=1/4,
```

where `C_crit` is Section 5's explicit constant with this `K,D`.
For `0<l<=l_0` put `theta=Dl`. Let
`B=l m+2l rW-nrl log(1+l)`. On the coarse region,
`B<=2l(m+rW)<=2lP/kappa`, while
`4theta^2m<=4D^2l^2P/kappa`.
Their sum is at most `(1/8+1/4)P`, leaving more than `gamma P`.
On the small region with `m>=Kl`, `W<=2m/3` gives `B<=3lm`.
The choices of `K` and `l_0` bound each of `B` and `4theta^2m`
by `b_n m^2/4`. On the remaining critical region apply Section 5.
Consequently, for **every** finite ordered model and probability family,

```
Q >= P-4theta^2m-r l^3
  implies
Q >= l m+2l rW-nrl log(1+l)-C_full r l^3
     + (P/4) 1_{m>=m_0 or |1-r|>=1/4}.                    (6.3)
```

The theorem quantifies over all `epsilon>=e`, every `r>0`, arbitrarily
many ordered updates, and every positive finite probability law.
All constants have been given explicitly.

To apply (6.3) to the manuscript, **assume** its analytic sweep proposition,
take `P=Pi_p` and `delta_0<=epsilon l^3`, and use
`N^2 e_(h_+)(Y)<=m/r`. Multiplication by
`epsilon/(rN^2)=1/(rl)` turns the cubic error into `C_full l^2`,
the volume term into `2W`, and the retained reserve into
`epsilon Pi_p/(4rN^2)` on the coarse region. The term `lm` pays for
`l epsilon e_(h_+)(Y)`. This is precisely the algebraic implication needed
for `lem:entropy-increment`, with dimensional constants once `e,c` are fixed
dimensionally by the manuscript.

## Certification boundaries

`verify.py` checks universal polynomial, sum-of-squares, and derivative
identities used above with exact arithmetic, independently recomputes the
archived Jacobian determinant, and challenges the literal finite-dimensional
definitions on deterministic noncommuting and degenerate-probability examples.
Those finite challenges are **not** the proof for arbitrary coordinate count:
Sections 1--6 give that proof, and the weighted core has a real Lean run.
The Reviewer must still check the universal matrix/calculus argument and
the statement-fidelity document.
The exact replay also compares the live Lean and fidelity texts with the
compiler archive, so a later source or interpretation edit is not silently
accepted.

From the campaign root, replay the persistent certificate with

```
$WORKSPACE/argus-live-update/.venv/bin/python research/entropy_increment_audit/verify.py
```

The compiler-backed record can be regenerated with

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/entropy_increment_audit/Main.lean --statement-fidelity research/entropy_increment_audit/statement_fidelity.md --claim C_LEAN_WEIGHTED_DEFECT --project-root .
```

Section 6 proves the separate noncritical/coarse algebra obligation
`C_ENTROPY_COARSE` and the conditional full budget
`C_FULL_ALGEBRAIC_INCREMENT`. No result here supplies the analytic graphs
assumed in (5.1) and (6.3), or independently proves the entire analytic
`lem:entropy-increment`. The result closes its ordered and probability
algebra under explicitly recorded hypotheses.

A targeted literature search for the specific nonperturbative function and
ordered-reserve inequality found no exact match, but returned no primary
source establishing priority. **Novelty and publishable significance remain
unverified**, not `verified_new`; standard rank-one inverse/determinant
identities are not being claimed as new. Independent review is pending,
and campaign-level publishable completion is not asserted.
