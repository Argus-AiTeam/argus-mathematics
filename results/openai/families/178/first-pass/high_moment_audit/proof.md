# An order-uniform two-channel entry-moment bound

## Result and scope

This is an independently derived proof of the high-moment implication used
in Lemma `lem:early-high-moments`, equation `original-33`. It also gives an
abstract sparse-kernel version and an explicit, deliberately loose uniform
coefficient. It is not a proof of the main Ramanujan construction.

The inputs taken from the manuscript are listed below. They are **upstream
assumptions of this verification**, not conclusions of this audit. In
particular, the signed entry-mean bound is essential. A bound for the
absolute mean cannot replace it. The analytic implication proved here is
for every sufficiently large size, not a finite numerical test.

Let `src` denote the staged release
`research/openai_manuscript/Deterministic-nonbipartite-Ramanujan-graphs-in-every-fixed-degree-September-23-2026/build/sections/`.
The source-local inputs are:

1. `foundations.tex`, equations `original-4`--`original-7` and Lemma
   `lemma:pencil-coefficients`: bounded squared rows into unresolved
   stubs, bounded large-power columns, entry supremum \(1+o(1)\),
   locality of entries above a fixed threshold, and the formal-tail cap.
2. `early.tex`, Lemma `lem:early-low-squares`, equation `original-23`,
   together with `foundations.tex`, equation `original-10`: small
   normalized row, diagonal, and fixed-radius near-pair second moments.
3. `early.tex`, Lemmas `lem:early-entry-mean` and
   `lem:early-linearization`, equations `original-22`,
   `original-29`--`original-32`: the signed conditional mean,
   the residual second moment, and the diagonal middle-coefficient bound.
4. `setup.tex`: the scales and the order in which the fixed parameters
   and small losses are chosen.

No outside literature result is invoked in the proof below. All sums are
finite; the elementary interpolation and kernel inequalities are proved
here. The manuscript's structural/path arguments establishing input 1
and its signed-mean and residual arguments establishing input 3 remain
separate obligations in the campaign proof graph.

## Quantified theorem

Fix \(d\ge3\), \(q=d-1\), and an integer \(H\ge1\), **before choosing
the moment order**. The constant \(H\) bounds the asymptotic squared
row sums and cubic column sums of the current path kernels, uniformly
over the two output types and tracked parameters. Such an \(H\),
depending only on the preceding fixed parameters, is supplied by input 1.
The proof does not choose \(H\) after \(p\).

For each fixed even \(p\ge4\), set
\[
 T_p=(2^{40}dHp^8)^{8p},\qquad
 \kappa_p=(1+T_p)^{-1},\qquad
 \varepsilon_p=(64T_p)^{-1},
 \qquad C_*=64+8192H.                                      \tag{1}
\]
Choose an integer \(R\) with \(q^R\varepsilon_p^2\ge16\).
After these choices, take the structural and low-square losses
sufficiently small, and then \(n\) sufficiently large depending on all
the fixed choices. At every current early-phase state satisfying the
manuscript's common bootstrap assumptions and the four upstream inputs,
\[
 \mathbb E[1+F_p'+\kappa_p D_p']
 \le (1+C_*/l+u_l)(1+F_p+\kappa_pD_p),\qquad
 \sum_{\substack{l_1\le l\le dn\\l\ {\rm even}}}u_l=o(1).   \tag{2}
\]
Here \(D_p=D_p^{\rm mom}\), not the precision deviation, and
\[
 F_p=\sum_{X,Y\in\{V,S\}}\frac{\sum_{i\in X,j\in Y}|z_{ij}|^p}{|X||Y|},
 \quad
 D_p=\sum_{X\in\{V,S\}}\frac{\sum_{i\in X}|z_{ii}|^p}{|X|},
 \quad z=E/B_e,\quad M_p=1+F_p+D_p.
\]
Thus the theorem is slightly stronger in order range than the source
assertion: it allows every fixed even \(p\ge4\), at the cost of a larger
uniform coefficient. It makes no uniform-in-\(p\) assertion about the
size threshold or the summable error budgets.

More generally, the same conclusion holds for any two output spaces of
sizes at least \(l/d\) satisfying the kernel, second-moment, conditional
mean, and linearized-update properties stated in the proof. Positivity
of a graph precision is not used again once those properties are given.

## 1. Uniform kernel constants and elementary inequalities

Write \(a_i(s)=p_i(s)\). For each fixed \(p\), increasing the size
threshold makes the row \(p\)- and \(2p\)-power sums and the column
\(p\)- and \(2p\)-power sums at most \(2H\). Indeed, if the entry
supremum is \(1+\omega_n\), take
\((1+\omega_n)^{2p}\le2\). The squared row bound and cubic column
bound then give these statements directly. This step is **after**
\(p\) is fixed. It is not valid for an order growing with \(n\).

For \(2\le k\le p\), the kernel \(|a_i(s)|^k\), on uniform \(i,s\),
has row marginal \(C_p/l\) and both marginals at most
\(n^{\eta_0}/l\), for any fixed \(\eta_0>0\) and sufficiently large
\(n\). The only polylogarithmic column case is \(k=2\).
The cardinality conversion uses \(|X|\ge l/d\).

An entry above \(\varepsilon_p\) has actual distance at most \(R\).
To see this without a dependence on later loss choices, separate paths
at length \(g_0/3\). Below this length there is at most one path,
including length zero. If its distance exceeds \(R\), its weight
is at most \(q^{-R/2}\le\varepsilon_p/4\). Longer paths and the
uniform/centering correction have supremum \(o(1)\), hence contribute
at most \(\varepsilon_p/2\) for large \(n\). Also \(g_0>2R\).
Consequently one output axis cannot have above-threshold outers at
both selected endpoints.

The number of unresolved labels in an \(R\)-ball and the reverse
multiplicity of such a neighborhood are at most
\[
 B_R=d\left(1+d\sum_{j=0}^{R-1}q^j\right).                 \tag{3}
\]
Constants involving \(B_R\) will occur only in summable errors.

The normalized second-moment inputs imply, for a fixed \(\beta>0\)
chosen before \(p\), small second moments on every probability row,
on both diagonal spaces, and on
\[
 \int f\,d\mu_X=|X|^{-1}
   \sum_{\substack{i\in X,s\in S\\\operatorname{dist}(i,s)\le R}}f(i,s).
\]
The latter measure has mass at most \(B_R\), second integral at most
\(n^{-\beta}\), and \(p\)-integral at most \(l\Phi_{XS}\).
The source permits, for example, \(\beta=a/4\).

Here is the normalization calculation explicitly. The squared row of
\(E=W-P\) into \(S\) is bounded by a constant, so its normalized average
is at most \(C/(lB_e^2)\le Cn^{-.62a}\).
The row into \(V\) has squared sum at most
\(C/\alpha_*+C(1+L)^6\), by `original-10` and the operator bound
for \(P\). Dividing by \(nB_e^2\) gives
\(Cn^{-.97a}+n^{-1/3-.47a+o(1)}\).
The diagonal bounds `original-23`, divided by their respective
cardinalities and \(B_e^2\), are at most \(Cn^{\eta-.62a}\).
Finally a near-pair second integral is at most
\(n^\eta/(|X|B_e^2)\le dn^{\eta-.62a}\), since
\(|X|\ge l/d\ge l_0/d\).
With \(\eta<a/100\), each is eventually at most \(n^{-a/4}\).
This also checks both output types, rather than only stub rows.

Here are the exact inequalities used. For a finite measure of mass at
most \(B\), with second integral at most \(n^{-\beta}\) and \(p\)-integral
at most \(M\), every integer \(1\le t<p\) satisfies
\[
 \int|z|^t\le C_{B,p}n^{-\beta/(2p)}(1+M)^{t/p}            \tag{4}
\]
for sufficiently large \(n\). For \(t\le2\), use the second moment
and the mass bound. For \(2<t<p\), Holder gives
\((n^{-\beta})^{(p-t)/(p-2)}M^{(t-2)/(p-2)}\).
The two relevant exponent comparisons are
\((p-t)/(p-2)\ge1/(p-2)>1/(2p)\) and
\((t-2)/(p-2)\le t/p\). Fixed mass constants cause no difficulty.

If a nonnegative kernel \(K\) has both marginal densities at most
\(b\), Holder on the measure with density \(K\) gives
\[
 \iint K f^r g^s\le b(\int f)^r(\int g)^s,\qquad
 r,s\ge0,\quad r+s\le1.                                  \tag{5}
\]
The three integrals used by Holder are bounded by \(b\int f\),
\(b\int g\), and \(b\), respectively.

Finally a two-group splitting can retain its principal term with an
order-independent factor:
\[
 |x+y|^p\le2|x|^p+(2p)^p|y|^p.                           \tag{6}
\]
Apply convexity with weights \(1-1/(2p),1/(2p)\).
Bernoulli's inequality gives
\((1-1/(2p))^{p-1}\ge1-(p-1)/(2p)>1/2\).
We use at most six such splittings on any principal term. A generic
split into all monomials is used only on error groups.

## 2. Exact linearized terms, probability laws, and residuals

Let \(u,v\) be the selected labels and \(\bar u=v,\bar v=u\).
The old-axis linearized increment is \(T_PzT_P^T-z\), where
\(T_P=I-PUH_PU^T\). Replacing \(H_P\) by \(-\sigma hF\) gives
exactly the following eight monomials:
\[
 L^0_{ij}=\sigma h\{a_i(u)z_{vj}+a_i(v)z_{uj}
             +a_j(u)z_{iv}+a_j(v)z_{iu}\}
       +h^2\sum_{s,t\in\{u,v\}}a_i(s)a_j(t)z_{\bar s\bar t}. \tag{7}
\]
The remainder has eight one-axis and sixteen two-axis monomials.
Their coefficients are entries of
\(H_P+\sigma hF\), or
\((H_P)_{sc}(H_P)_{dt}-h^2F_{sc}F_{dt}\), with signs as appropriate.
All have power-small supremum. A same-input one-axis coefficient
is \((H_P)_{ss}\), which has the sharper conditional estimate
\[
 \mathbb E_{\bar s}
  [|(H_P)_{ss}|^k\mathbf1_{\rm valid}]
 \le C_p n^\eta n^{-c_0(k-2)}/l,\quad 2\le k\le p.         \tag{8}
\]
For a two-axis term with retained outer endpoint \(s\) and input
\(z_{ss}\), its coefficient contains \((H_P)_{ss}\). The subtracted
pure-swap coefficient is zero in this case.

The actual normalized increment is \(L_{ij}+r_{ij}\), with
\[
 |\mathbb E(\Delta z_{ij}\mid{\rm survival})|\le m_l=\mu_l/B_e,
 \quad |r_{ij}|\le1,\quad
 \mathbb E(|r_{ij}|^2\mid{\rm survival})\le\rho_l,
 \quad
 \rho_l=C_{\rm in}(n^\eta/l^2+d_m^4/l)/B_e^2.              \tag{9}
\]
The restriction \(|r|\le1\) holds eventually by the stated supremum
bound and the scales in Section 6 below.

Any nonnegative integrand under the valid, surviving pair law is
bounded by four times its independent-uniform endpoint average, for
large \(n\). Indeed the forbidden fraction is
\(O((D_g+1)/l)=o(1)\); the independent law also includes the distinct
pair correction. The factor four is independent of \(p\). Signed
first-order terms use (9), not this domination argument.

Deletion only reduces unnormalized sums of old nonnegative moments.
Changing a pair denominator to its surviving denominator costs at most
\((l/(l-2))^2\le1+16/l\), for \(l\ge4\); the diagonal denominator
cost is smaller. New stub axes are already included in \(r\).

## 3. Every intermediate Taylor power is summable

Expand \(|z+\Delta z|^p\), using that \(p\) is even. The first-order
contribution is at most
\(p m_l|z|^{p-1}\le p m_l(1+|z|^p)\).
For \(2\le k\le p\), the residual contribution is at most
\(C_p\rho_l(1+|z|^p)\), by \(|r|\le1\).
At \(k=p\), (6) retains the linear part with factor two.

Consider \(2\le k<p\) in the linear part. The following cases exhaust
all monomials, including the twenty-four remainder monomials.

* One-axis, opposite input: sum the outer \(k\)-power over its endpoint
  for \(C_p/l\), interpolate the independent input row by (4), and
  apply Holder to the output factors. The result is
  \(C_p n^{-\delta}M_p/l\), for pair or diagonal outputs.
* Two-axis, same endpoint: discard one bounded outer, integrate the
  other for \(C_p/l\), and interpolate the independent input diagonal.
* Two-axis, different endpoints: discard one bounded outer, interpolate
  the input row over the other endpoint, and apply (5) to the retained
  outer kernel. The output-row moment and input-row moment have exponents
  \((p-k)/p,k/p\), whose sum is one. For a diagonal output use its
  diagonal moment as the first function instead.
* A remainder one-axis term whose input equals its outer endpoint:
  integrate the other endpoint by (8), discard the bounded outer,
  and interpolate the remaining free input row. The factor \(n^\eta\)
  is smaller than the interpolation saving.
* A remainder two-axis term: retain an outer at \(s\). The possible
  inputs are \(z_{ss},z_{\bar s\bar s},z_{s\bar s},z_{\bar s s}\).
  The first uses (8), the second uses independent diagonal
  interpolation, and the last two use the preceding kernel argument.
  Extra bounded coefficients or outers are harmless.

There are finitely many interpolation exponents once \(p\) is fixed.
For example take
\(\delta_p=\min(\beta/(64p),c_0/4,c/4)>0\), where \(n^{-c}\)
bounds remainder coefficients, and choose both kernel and structural
losses below \(\delta_p/16\). All the above estimates then hold with
\(n^{-\delta_p}\), after increasing the size threshold. Constants can
depend on \(p,R\) here; none enters the nonsummable self-drift.

## 4. Pure powers for independently averaged output pairs

Two-axis terms, including diagonal inputs, have two independent
output-column integrations. Their pure contribution is
\[
 C_p(F_p+D_p)/l^2.                                       \tag{10}
\]
This remains true on \(X=Y\): the defining pair average is a product
average, not an average over distinct output labels.

A remainder one-axis term with different input and outer endpoints
has a power-small coefficient and a row integration, hence costs
\(C_p n^{-\delta_p}F_p/l\). For equal endpoints integrate (8)
first; its pure contribution is at most
\(C_p n^{\eta-c_0(p-2)}F_p/l\). Both are summable.

For the four principal one-axis terms, separate outers of size at most
\(\varepsilon_p\). Their pure moments cost at most
\(Q_p\varepsilon_p^{p-2}F_p/l\), where an \(R\)-independent
coefficient bound is
\[
 Q_p=(2^{20}p^8d^2H^2)^{4p}\le T_p.                      \tag{11}
\]
This uses \(|a|^p\mathbf1_{|a|\le\varepsilon}
\le\varepsilon^{p-2}|a|^2\). Since \(p\ge4\), (1) makes
this coefficient at most \(1\).

If both output axes have above-threshold outers at the same endpoint,
one may split all their powers with an order-dependent coefficient.
The contribution is \(C_{p,R}F_p/l^2\): sum one output column first
for \(2H/|X|\), and use that the other output has only \(B_R\)
nearby choices of the selected endpoint. This is where bounded
multiplicity of unresolved labels at one vertex is needed.

Otherwise there is one retained large term, or two with opposite
endpoints. In the latter case the two error inputs lie in the two
near neighborhoods. Expand the power of their sum **without splitting
its two pure summands**. Every mixed term is bounded by
\[
 \frac{C_p}{l^2}
   \left(\int|z|^t\,d\mu_X\right)
   \left(\int|z|^{p-t}\,d\mu_Y\right)
 \le C_{p,R} n^{-\delta_p}M_p/l,\quad 1\le t<p.            \tag{12}
\]
For the last inequality use (4) with \(M=l\Phi_{XS}\) and
\(M=l\Phi_{YS}\), and weighted arithmetic-geometric mean to bound
the product of the two moment factors by \(1+lF_p\).
Thus their pure summands retain coefficient one.

For one orientation, row integration and density domination give
\(8Hh^p\Phi_{SY}/l\). Summing the four orientations and four output
types gives at most \(64Hh^pF_p/l\). At most six uses of (6) enlarge
this by at most \(64\), not by an order-dependent power. Therefore
the principal pair self-drift is at most
\[
 4096Hh^pF_p/l.                                         \tag{13}
\]

For clarity, (11) has ample slack. There are at most 32 monomials;
a discarded group split costs \(32^{p-1}\), each of the at most six
Young remainders costs at most \((2p)^p\), and the sum of binomial
coefficients is \(2^p\). Bounded outer and diagonal multiplicities
and row/column constants are bounded by the extra factors in \(Q_p\).
No near-ball multiplicity is used in this bound. In exponent vectors
on the bases \(2,p,d,H\), \(T_p/Q_p\) is
\((240p,32p,0,0)\), all nonnegative.

## 5. Pure powers for diagonal outputs

At most one endpoint has an above-threshold outer for a fixed \(i\).
If it is \(u\), the retained diagonal contribution is exactly
\[
 A=2\sigma h a_i(u)z_{vi},\qquad
 B=h^2 a_i(u)^2z_{vv}.                                  \tag{14}
\]
The pure \(A\) contribution is a transfer from the pair family:
\[
 \mathbb E_{i,u,v}|A|^p\le C_pF_p/l.                     \tag{15}
\]
Its \(2^p\) is not uniform, and is not claimed to be. Conversely,
the pure \(B\) contribution uses a row \(2p\)-sum, and gives
a diagonal self-term at most \(32Hh^{2p}D_p/l\) before the
bounded principal splittings. After them it is at most
\[
 2048Hh^{2p}D_p/l.                                      \tag{16}
\]

For a mixed power \(|A|^t|B|^{p-t}\), the outer exponent is
\(2p-t\ge p+1\). Sum that row in \(u\) first, for \(C_p/l\).
For each \(v\), (4) on the row in \(i\) gives a saving in the
positive power \(|z_{vi}|^t\). Holder against
\(|z_{vv}|^{p-t}\) then gives
\(C_p n^{-\delta_p}M_p/l\).

The off-diagonal two-axis input \(z_{uv}\) has at least one small
outer, so its pure contribution is
\(C_p\varepsilon_p^pF_p/l\), a pair-to-diagonal transfer.
A small same-end diagonal input costs
\(Q_p\varepsilon_p^{2p-2}D_p/l\le D_p/l\).
Small one-axis terms again transfer pair moments, with coefficient
at most \(T_p/l\) after summing all such contributions.

For a remainder one-axis term with the same input endpoint, (8) gives
\[
 C_p n^{\eta-c_0(p-2)}\Phi_{SX}/l.
\]
With opposite input, its small coefficient and row integration give
\(C_p n^{-cp}\Phi_{SX}/l\).
A remainder two-axis term permits summing a column over \(i\),
independent of its input; its coefficient is power-small and it costs
\(C_p n^{-cp}(F_p+D_p)/l\).
These cases exhaust all remainder terms.

In particular there is **no** \(C_pD_p/l\) diagonal self-amplification
left over from (14). Its mixed powers gained a power saving; its
\(A\) pure power belongs to the other moment family. This distinction
is especially important for degree three, where \(2h\) can exceed one.

## 6. Combining the channels and summing the deterministic budgets

Absorbing all summable terms into \(v_lM_p\), the preceding bounds,
including the denominator changes, give
\[
 \begin{split}
 \mathbb EF_p'&\le(1+A_0/l)F_p+T_pD_p/l^2+v_lM_p,\\
 \mathbb ED_p'&\le(1+A_0/l)D_p+T_pF_p/l+v_lM_p,
 \end{split}                                             \tag{17}
\]
where \(A_0=63+8192H=C_*-1\).
For example one may take
\[
 v_l=K_p\{m_l+\rho_l+n^{-\delta_p}/l+l^{-2}\},             \tag{18}
\]
where \(K_p=T_p^8(1+C_{\rm in}+B_R)^{16p}\) and \(C_{\rm in}\ge1\)
bounds the finitely many constants in the supplied coefficient and
residual estimates for this fixed \(p\). Increasing \(C_{\rm in}\)
if necessary is allowed. It affects (18), never \(A_0\).
The excess products caused by multiplying a denominator correction
by an already present \(1/l\) term are included in \(K_p/l^2\).

For completeness the scalar absorption is an exact algebraic inequality,
not a spectral-radius heuristic. With \(\kappa=(1+T_p)^{-1}\), put
\[
 u_l=\frac{T_p}{\kappa l^2}+
          \frac{1+\kappa}{\kappa}v_l.                    \tag{19}
\]
Multiply the second inequality of (17) by \(\kappa\), add the first
and the constant 1, and compare with
\((1+(A_0+1)/l+u_l)(1+F_p+\kappa D_p)\).
The difference is
\[
 \frac{A_0+1}{l}+\frac{T_p}{\kappa l^2}
 +(1+\kappa)(\kappa^{-1}-1)v_l
 +F_p\left\{\frac{1-\kappa T_p}{l}+\frac{T_p}{\kappa l^2}
                 +(1+\kappa)(\kappa^{-1}-1)v_l\right\}
 +\frac{\kappa D_p}{l}\ \ge0.                            \tag{20}
\]
All terms are nonnegative, since \(0<\kappa\le1\) and
\(\kappa T_p\le1\). This proves (2) with the explicit constant in (1).

It remains to verify the whole-phase budgets, rather than a single
step. Write \(a=10^{-4}\), use the source's fixed-factor scale
conventions, and take \(\eta<a/100\) as well as the smaller interpolation
losses already required. The signed-mean and residual formulas imply
\[
 \begin{split}
 \sum_l m_l \le C[&
 n^{-.76a}+n^{\eta-.60a}
 +n^{-1/3-.383a}+n^{\eta-.31a}
 +n^{-1/3+.275a}\log n],\\
 \sum_l\rho_l\le C[&
 n^{\eta-.62a}+n^{-2/3+.55a}\log n].
 \end{split}                                             \tag{21}
\]
Here we used \(l_0\asymp n^{2/3+.15a}\),
\(\alpha_*\asymp n^{-1/3+a/2}\),
\(q^{L/2}\asymp\sqrt{l_0}n^{-.29a}\),
\(B_e=n^{.31a}/\sqrt{l_0}\),
\(d_m=n^{.33a}/\sqrt{l_0}\),
\(v_*=.125a\), and \(D_g=O(n^{.002a})\).
Summing over all integers only enlarges the even-indexed budgets.

The residual supremum divided by \(B_e\) is bounded by a constant times
\[
 n^{-1/3+.275a}+n^{-.01a}+n^{-2/3-.13a}=o(1),             \tag{22}
\]
which justifies \(|r|\le1\). All exponents in (21) are strictly negative.
Also \(\sum l^{-2}=O(l_0^{-1})\) and
\(\sum n^{-\delta_p}/l=O(n^{-\delta_p}\log n)=o(1)\).
Thus (18)--(19) have total \(o(1)\) for every fixed \(p\).
The very large constants \(T_p,\kappa_p^{-1},K_p,B_R\) are fixed
before this limit, exactly as required.

## Exact evidence and limitations

`verify.py` checks the generic polynomial in (7), all twenty-four
remainder forms, the required same-end middle factors, the diagonal
reduction (14), the interpolation exponent comparisons for every order,
the denominator inequality, the nonnegative-coefficient identity (20),
and every exponent in (21)--(22) using exact rational arithmetic.
It also computes a complete finite-state closure proving the source's
pure-swap, at-most-one-error index-word classification for **all word
lengths**, not merely words up to an experimental cutoff.

The Jacobian operation
`matrix.symbolic.characteristic_polynomial.compute` is used only on the
two-channel transfer matrix \(\left[\begin{smallmatrix}0&Tx\\T&0\end{smallmatrix}\right]\).
Its exact answer \(\lambda^2-T^2x\) is supplementary algebraic evidence
for the transfer asymmetry, not a proof of the analytic estimates.
The exact payload, typed response, adapter exit status, protocol, and
server version are preserved separately.

`Main.lean`, declaration `HighMomentAudit.weighted_drift`, formalizes
only the scalar absorption claim `C_HM_WEIGHT`. Its exact quantifiers,
hypotheses, and relation to (17)--(20) are specified separately in
`statement_fidelity.md`. A successful fresh compiler record, not the
presence of this source file, is required for formal evidence.

The fresh Lean 4.31.0 run has compiler exit code 0, an empty proof-hole
list, and a successful axiom audit. The kernel recorded it on
`C_HM_WEIGHT`, with the immutable certificate
`certificates/C_HM_WEIGHT-688c017c6a22ebfa.json`.
The exact replay also verifies that the current source, fidelity
document, archived certificate, and current claim version agree.

From the campaign root, replay with:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/high_moment_audit/verify.py
```

The previously strongest statement relevant to this bounded mission is
the manuscript's qualitative existence of a uniform coefficient for
sufficiently large fixed even orders. The present verification supplies
the explicit coefficient in (1), treats every fixed even order at least
four, and separates the exact scalar compiler theorem from the remaining
analytic and source-local dependencies. It does not improve the
manuscript's graph-construction theorem.

Neither executable replay nor this scalar formalization proves Holder,
the upstream path estimates, or the complete graph construction. The
all-size analytic proof is the argument above; its source-local
dependencies and its statement fidelity still require independent human
review. No manuscript assertion has been refuted by this work, and no
small-graph experiment is being called a manuscript counterexample.
Novelty and publishable significance are not certified by an arithmetic
replay or a scalar compilation.
