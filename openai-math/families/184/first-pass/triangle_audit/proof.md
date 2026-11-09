# Weighted cross-mass and triangle mass

## Exact manuscript question

Let \(G\) be a finite simple graph, with arbitrary positive vertex weights.
Write \(w(A)=\sum_{v\in A}w_v\), let \(M\) and \(T\) be the unordered
edge and triangle product-weight sums, and use the directed cross sum
\[
 e_w(A,B)=\sum_{u\in A}\sum_{v\in B\cap N(u)}w_uw_v.
\]
Overlapping sets are allowed; internal edges are counted twice. Define
\(g_x(0)=0\) and
\(g_x(s)=s(x+\max(0,\log(1/s)))\) for \(s>0\).
The hypothesis is the following assertion for **every** real \(x\ge1\)
and **every** pair \(A,B\):
\[
 w(A),w(B)\le e^x\quad\Longrightarrow\quad e_w(A,B)\le Cg_x(w(A)).
\]
The conclusion is \(T\le C_\triangle(C)M\), uniformly in graph order,
total vertex weight, and the smallest positive weight.

The definitions are in the independence manuscript's
`build/sections/introduction.tex` and `optimizer.tex`. The assertion is
`invariant.tex`, Theorem `thm:weighted-triangles`. Neither optimizing
weights nor excluding a clique is a hypothesis of this structural theorem.

## Dependency chain and scope

The structural proof uses edge-injective, weight-preserving splitting
(`invariant.tex`, `lem:invariant-preservation`), exact triangle counting
and peeling (`lem:triangle-peeling`), averaged local-walk entropy
(`entropy.tex`, `lem:entropy-smoothing`), reversed-row qualification
(`coupling.tex`, `lem:reverse-admissibility`), and coupled vertex splitting
(`lem:weighted-splitting`). Summable losses in
`prop:neighborhood-reduction` then give the uniform triangle bound.
The optimizer cross estimate and the final independent-set argument are
separate obligations, not consequences of checking the structural theorem.

The coloring manuscript adapts, rather than literally assumes, this
mechanism. Its `adjustment.tex`, `lem:local-cross`, supplies a priced local
cross estimate with an additive error. `lem:local-cross-transfer` transfers
it through directed-edge-injective projections. Its `triangles.tex`,
`lem:triangle-splitting` and `prop:triangle-bound`, add locality and
per-part participation bookkeeping to the entropy, reversed-row cutoff,
and splitting argument. The resulting triangle estimate closes the dual
inequality for `adjustment.tex`, `lem:adjustment`; `rounds.tex` applies
that adjustment to correspondence-list entries.

More precisely, the adjustment conclusion is
\(t_i+\sum_j a_jg_i^{(j)}\le Bd_i\), with
\(\sum_{j:i\in J_j}a_j\le\Lambda^4\).
The second bound concerns listed operation supports, not every coordinate
whose vector entry a drop operation might affect. The local cross estimate
has the form \(e_q(S,D)\le C_1(\eta hq(S)+e^{-3h})\), subject to its
radius and per-part hypotheses. Neither its additive error nor those
hypotheses occur in the global theorem proved below.

The abstract coloring mechanism explicitly permits arbitrarily small
positive weights. The bounds on weights imposed later in `rounds.tex`
are application invariants, not hypotheses that can repair a failure of
the abstract structural theorem. Likewise, a global triangle theorem
alone does not verify coloring's additive-error, radius, or participation
estimates.

## Inputs and exclusions

The shared Wiki index contains no matching weighted cross-mass/triangle
result. A targeted external search found no primary source for the exact
polynomial-logarithmic generalization considered below. The returned
weighted-cut and bisection references concern different statements and
are not mathematical assumptions or evidence of novelty.

Shared rejection coupling is known (the manuscript cites Kleinberg--Tardos
and Angel--Spinka). Entropy concavity, nonnegativity of relative entropy,
and the elementary total-variation bound can all be proved directly.
Any verification here must supply those arguments rather than treat the
manuscript's unverified conclusions, a comparator containing proof holes,
or a literature citation as a proved input.

A finite graph without a violating ratio cannot refute or verify an
unspecified uniform constant. A refutation of the triangle theorem must
give one fixed cross constant and an admissible family with unbounded
\(T/M\). A false intermediate assertion instead needs a complete witness
to that assertion's actual hypotheses.

## A polynomial-profile extension

Here is the proposed independent theorem. It weakens the cross hypothesis,
not the positivity or simplicity requirements.

**Theorem.** For every integer \(p\ge1\) and real \(C\ge1\), put
\[
 E=C^2 42^p+C2^p,\quad k=3p+5,\quad
 A=k+2+E,\quad a=18(A+1),\quad X=(16a(p+6))^4.
\]
If a finite simple positive-weighted graph satisfies, for every real
\(x\ge p\) and all \(U,V\subseteq V(G)\),
\[
 w(U),w(V)\le e^x\quad\Longrightarrow\quad
 e_w(U,V)\le Cg_{p,x}(w(U)),\qquad
 g_{p,x}(s)=s(x+\log^+(1/s))^p,\quad g_{p,x}(0)=0,
 \tag{P}
\]
then
\[
 T_G(w)\le 2(1+e^X/3)M_G(w).                 \tag{1}
\]
Moreover, the hypotheses form a strictly weaker uniform hierarchy as
\(p\) increases: for every pair of integers \(1\le q<p\), there is
a family satisfying (P) with exponent \(p\) and fixed constant \(2^p\)
for which no fixed exponent-\(q\) cross constant works.

For \(p=1\), (P) is exactly the manuscript hypothesis. For \(p>1\),
the conclusion applies to genuinely larger uniformly controlled weighted
families. The explicit constant is intentionally not optimized.
This is a candidate new structural generalization, not a claim that the
manuscript is false or that literature novelty has been independently
certified.

### 1. Preservation and exact counting

For \(x\ge p\), \(g_{p,x}\) is nondecreasing. On \(0<s<1\) its derivative
is
\[
 (x+\log(1/s))^{p-1}(x+\log(1/s)-p)\ge0;
\]
on \(s>1\) it is \(x^p\). The values match at 1 and the limit at 0 is 0.
If a weight-preserving homomorphism \(\rho:H\to G\) is injective on
directed edges, then
\[
 e_{H,w}(U,V)\le e_{G,w}(\rho U,\rho V),\qquad
 w(\rho U)\le w(U),\quad w(\rho V)\le w(V).
\]
Thus (P) transfers with the same \(p,C\), including overlapping sets.
The map is also injective on unordered edges. A neighborhood of one
copy maps injectively to the old neighborhood. A triangle maps to three
distinct old vertices, and two triangles cannot have the same image:
each of the three old edges has at most one preimage edge. Consequently
\(M_H\le M_G\), \(T_H\le T_G\), and projected neighborhood masses
do not increase. These facts persist under finite composition.

With \(s_u=w(N(u))\), \(c_{uv}=w(N(u)\cap N(v))\), and
\(h_u=\sum_{v\in N(u)}w_vc_{uv}\), count each unordered triangle by
its three edges or six directed edges:
\[
 \sum_{\{u,v\}\in E}w_uw_vc_{uv}=3T,\qquad
 \sum_u w_uh_u=6T.                          \tag{2}
\]
If all \(s_u\le L\), then \(3T\le LM\). Deleting an edge with current
\(c_{uv}<\tau\) destroys exactly \(w_uw_vc_{uv}\) triangle mass.
Charge a triangle only when its first edge is deleted. The total loss
is at most \(\tau M\). In the remaining graph every nonisolated vertex
has \(s_u\ge\tau\) and \(h_u\ge\tau s_u\). This proves the peeling
statement without a lower bound on individual weights.

### 2. Local walks and a polynomial-profile entropy bound

Assume now
\[
 x\ge\max(32,(p+6)^2),\qquad
 s_u\le e^x,\qquad c_{uv}\ge1/x\quad(uv\in E),\qquad T>0.
 \tag{3}
\]
Discard isolated vertices. On \(N(u)\), define
\[
 \pi_u(v)=w_vc_{uv}/h_u,\quad
 P_u(v,z)=w_z{\bf1}_{vz\in E}/c_{uv},\quad
 Q_u=(I+P_u)/2,\quad K_u^j=P_uQ_u^j .
\]
All are stochastic. Detailed balance for \(P_u\) is the identity
\(\pi_u(v)P_u(v,z)=w_vw_z{\bf1}_{vz\in E}/h_u\).
Since \(K_u^j\) is a polynomial in \(P_u\), it too is reversible and
stationary for \(\pi_u\). Commutation gives
\[
 K_u^j(v,y)=\sum_zQ_u^j(v,z)P_u(z,y)\le xw_y.                 \tag{4}
\]
Let \(Z=6T=\sum_uw_uh_u\) and
\(\mu(u,v)=w_uw_vc_{uv}/Z\) on directed edges. A further \(P_u\)-step
gives each ordered triangle \((u,v,z)\) probability \(w_uw_vw_z/Z\).
Write
\[
 {\cal H}_w(r)=\sum_{y:r(y)>0}r(y)\log(w_y/r(y)),\quad
 H_j=\mathbb E_\mu{\cal H}_w(K_u^j(v,\cdot)),\quad R=\lceil x\rceil .
\]
Equation (4) gives \(H_j\ge-\log x\) for every \(j\).

Fix a nonisolated starting vertex \(v\), and use the same sets for every
center \(u\in N(v)\):
\[
 S_0=N(v),\qquad
 S_{i+1}=S_i\cup\{y:w(N(y)\cap S_i)\ge x^{-6}e^{-x}\}.
\]
Double counting bounds
\(\sum_yw_yw(N(y)\cap S_i)\le e^xw(S_i)\), so
\[
 w(S_R)\le e^x(1+e^{2x}x^6)^R\le e^{20x^2}.                \tag{5}
\]
Indeed, \(R\le2x\), \(6\log x\le x\), and
\(\log(1+e^{2x}x^6)\le4x\) for \(x\ge32\).
For the first scalar inequality, \(x-6\log x\) is increasing there and
\(6\log32=30\log2\le30<32\).

An induction using (4) gives
\[
 K_u^i(v,N(u)\setminus S_i)\le ix^{-4}\quad(0\le i\le R).
 \tag{6}
\]
For the induction step, already escaped mass contributes at most
\(ix^{-4}\). For \(y\notin S_{i+1}\) and \(z\in S_i\), the lazy walk
cannot stay at \(z=y\); the additional mass arriving at \(y\in N(u)\)
is at most
\[
 \sum_{z\in N(u)\cap S_i\cap N(y)}xw_z\,xw_y
 \le x^{-4}e^{-x}w_y.
 \]
Summing over \(N(u)\) contributes at most \(x^{-4}\).

Set
\[
 B_v=\{u\in N(v):w(N(u)\cap S_R)>x^k\},\qquad k=3p+5.
\]
Apply (P) first at \(20x^2\), using (5), \(s_v\le e^x\), and
\(s_v\ge1/x\):
\[
 x^kw(B_v)\le e_w(N(v),S_R)
 \le Cs_v(20x^2+\log^+(1/s_v))^p
 \le C21^p x^{2p}s_v.
 \tag{7}
\]
For every \(b\ge0\), monotonicity of \(g_{p,x}\) and the breakpoint
\(e^{-x}\) give
\[
 g_{p,x}(b)\le(2x)^p\max(b,e^{-x})\le(2x)^p(b+e^{-x}).
 \tag{8}
\]
The symmetry of \(\mu\), the exact conditional law, and \(h_v\ge s_v/x\)
now give a second application of (P), at \(x\):
\[
\begin{split}
 {\mathbb P}_\mu(u\in B_v\mid v)
 &= e_w(B_v,N(v))/h_v\\
 &\le C2^p x^{p+1}(w(B_v)+e^{-x})/s_v\\
 &\le C^2 42^p x^{-4}+C2^p x^{p+2}e^{-x}
 \le E x^{-4}.                                           \tag{9}
\end{split}
\]
For the last inequality, \(\log x\le\sqrt x\) for \(x\ge1\);
one can minimize \(z-2\log z\) at \(z=2\) and use \(\log2\le1\).
Since \(x\ge(p+6)^2\), this implies
\((p+6)\log x\le x\), and hence \(e^{-x}\le x^{-(p+6)}\).
This is the only new tail threshold needed for polynomial profiles.

For a probability row supported on a positive-weight set of mass \(m\),
\({\cal H}_w(r)\le\log m\). To see this, normalize its reference
weights and use \(\sum r\log(r/q)\ge0\), which follows directly from
\(-\log t\ge1-t\) and \(\sum q=1\).
On a pair outside \(B_v\), (6) puts at least \(1-\delta\) of the row in
a set of weight at most \(x^k\), with \(\delta\le Rx^{-4}<1\).
Conditioning on that set and its complement yields
\[
 {\cal H}_w(K_u^R(v,\cdot))\le\log2+k\log x+\delta x.
\]
The complement contributes zero when it is empty or has zero
probability. The first set cannot have zero weight because its
probability is positive. On bad pairs use the unconditional bound \(x\).
Averaging and applying (9) gives
\[
 H_R\le\log2+k\log x+Rx^{-3}+Ex^{-3}
 \le(k+2+E)\log x=A\log x.                              \tag{10}
\]
Here \(\log2\le\log x\), \(Rx^{-3}\le2/x^2\le\log x\),
and \(x^{-3}\le\log x\). No estimate uses a minimum atom weight.

### 3. Entropy increment, with one common time

For probability rows \(r,s\), let
\(D(r\Vert s)=\sum_{r_y>0}r_y\log(r_y/s_y)\).
A mixture \(b=\sum_z\lambda_zr_z\) satisfies the exact identity
\[
 \sum_z\lambda_zD(r_z\Vert b)
 ={\cal H}_w(b)-\sum_z\lambda_z{\cal H}_w(r_z).
\]
Every divergence occurring here is finite when \(\lambda_z>0\).
Apply this with \(r_z=K_u^j(z,\cdot)\) and
\(\lambda_z=Q_u(v,z)\). Stationarity of \(\pi_u\) implies
\[
 H_{j+1}-H_j
 =\mathbb E_{\mu Q}D(K_u^j(z,\cdot)\Vert K_u^{j+1}(v,\cdot))\ge0.
 \tag{11}
\]
Thus some **single** \(j<R\), shared by all neighborhoods, has increment
at most \((A+1)\log x/x\).

For completeness, write \(b(r,s)=\sum_y\sqrt{r_ys_y}\).
The tangent inequality \(\log t\le t-1\), applied to
\(\sqrt{s_y/r_y}/b(r,s)\) and averaged with weights \(r_y\), gives
\(D(r\Vert s)\ge-2\log b(r,s)\ge2(1-b(r,s))\).
Cauchy--Schwarz gives
\(\|r-s\|_{\rm TV}\le\sqrt{2(1-b(r,s))}\le\sqrt{D(r\Vert s)}\).
Zero-overlap cases are interpreted with infinite divergence.
Using this inequality, Cauchy--Schwarz on the probability average,
and \(Q=(I+P)/2\), with
\(a_v=K_u^j(v,\cdot)\) and \(b_v=K_u^{j+1}(v,\cdot)\), gives
\[
\begin{split}
 \mathbb E_{\mu P}\|a_v-a_z\|_{\rm TV}
 &\le \mathbb E_\mu\|a_v-b_v\|_{\rm TV}
       +\mathbb E_{\mu P}\|a_z-b_v\|_{\rm TV}\\
 &=2\mathbb E_{\mu Q}\|a_z-b_v\|_{\rm TV}\\
 &\le 2\sqrt{A+1}\sqrt{\log x/x}.
                                                               \tag{12}
\end{split}
\]
The equality is between the two terms on the preceding line and the
lazy-walk expectation, not an asserted equality in the triangle
inequality. Put \(B=2\sqrt{A+1}\).

### 4. Reverse qualification and simultaneous coupling

For a finite family of probability rows \(r_i\) on a finite set \(J\),
sample one common sequence \((Z_t,U_t)\), with \(Z_t\) uniform on \(J\)
and \(U_t\) uniform on \([0,1]\). Row \(i\) takes the first \(Z_t\)
for which \(U_t\le r_i(Z_t)\). Its output \(Y_i\) has law \(r_i\):
each trial accepts with probability \(1/|J|\), with accepted-label
probabilities proportional to \(r_i\). All finitely many rows stop
almost surely. If \(d=\|r_i-r_{i'}\|_{\rm TV}\), the first trial
accepted by either is accepted by both with probability
\((1-d)/(1+d)\). Hence
\[
 {\mathbb P}(Y_i\ne Y_{i'})\le 2d/(1+d)\le2d.
 \tag{13}
\]
The label vector has values in the finite set \(J^I\); its induced law
therefore has finite support. This reproves a known coupling, not a
new claim about the coupling literature.

Apply (13) to all rows of \(K_u=K_u^j\) at each \(u\).
Call the label \(y\) on incidence \((u,v)\) qualified when
\(K_u(y,v)\ge w_ve^{-\sqrt x}\).
Under \(\mu(u,v)K_u(v,y)\), detailed balance gives the exact
exchange symmetry \((u,v,y)\stackrel{\rm law}=(u,y,v)\).
On its support the two kernel entries are positive. Therefore
\[
 \ell=\log(w_v/K_u(y,v)),\qquad
 \mathbb E\ell=H_j\le A\log x,\qquad \ell\ge-\log x.
\]
Markov's inequality applied to \(\ell+\log x\) gives
\[
 {\mathbb P}(\text{unqualified})
 \le\delta_x:=\frac{(A+1)\log x}{\sqrt x+\log x}.
 \tag{14}
\]
This is an averaged statement, not an individual-row entropy bound.
The generic exchange and shifted-Markov arguments are formalized in
`Main.lean`.

### 5. Splitting and a single-step estimate

For a fixed label outcome, make one copy \((u,y)\) of weight \(w_u\)
for each nonempty group of neighbors with common qualified label \(y\).
Keep an old edge exactly when both incidence labels qualify, between
the copies designated by those labels. Each edge has at most one
preimage. The total weight of a group is at most
\[
 \sum_{v:\,Y_{u,v}=y,\ {\rm qualified}} w_v
 \le e^{\sqrt x}\sum_v K_u(y,v)\le e^{\sqrt x}.
 \tag{15}
\]
Neighbors of a fixed copy have distinct old images, so (15) is its
actual neighborhood bound.

An old triangle survives precisely when its labels agree at each of
three corners and all six incidences qualify. Every new triangle
projects to an old one, with unchanged weight and multiplicity at most
one. Under the ordered triangle law, (12)--(14) and a union bound give
\[
 \frac{\mathbb E(T-T')}{T}
 \le6B\sqrt{\log x/x}+6\delta_x
 \le6(B+A+1)\frac{\log x}{\sqrt x}
 \le a\frac{\log x}{\sqrt x}.                           \tag{16}
\]
The middle inequality uses \(\log x\ge1\); the last uses
\(\sqrt{A+1}\le A+1\). Finite support supplies an outcome attaining at
least the expected retained mass. It is not necessary to assume
independence between corner-failure events.

For an arbitrary graph with neighborhoods at most \(e^x\), first peel
at \(1/x\), then split. If peeling leaves no edge, take the empty graph.
Otherwise (3) holds and the preceding proof applies. Provided
\(\varepsilon(x)=a\log x/\sqrt x\le1\), the resulting graph satisfies
\[
 \max s'_u\le e^{\sqrt x},\quad M'\le M,\quad T'\le T,\quad
 T'\ge(1-\varepsilon(x))T-M/x,                          \tag{17}
\]
and retains (P). The empty-graph case follows from \(T\le M/x\).
The case with edges follows by multiplying the peeling bound by
\(1-\varepsilon(x)\in[0,1]\).

For \(p=1\), the entire walk argument is valid already for \(x\ge32\),
not merely the convenient general threshold 49: the exponential series
gives \(e^{32}\ge32^{16}/16!>32^7\), and \(x-7\log x\) is increasing
on \(x\ge32\). Thus \(e^{-x}\le x^{-7}\) throughout the manuscript's
stated range. Every other walk estimate above requires only \(x\ge32\).
In this case (10) has exactly the manuscript value
\(A=10+42C^2+2C\), and (12), (14), and the middle bound in (16)
recover its stated entropy, reverse-admissibility, and splitting
constants. The coarser \(a\) is used only for the explicit extension.

### 6. Uniform iteration, not a bounded experiment

Let \(f(t)=\log t/\sqrt t\). On \(t\ge32\), \(f\) decreases and
\(f(t^2)/f(t)=2/\sqrt t\le1/2\). Write \(Q=16a(p+6)>1\),
so \(X=Q^4\). Then \(X\ge\max(32,(p+6)^2)\), and
\[
 2af(X)=8a\log Q/Q^2\le8a/Q
 =1/(2(p+6))\le1/2.                                   \tag{18}
\]
Only \(\log Q\le Q\) is used in this deliberately loose bound.

Choose any finite \(x_0\ge1\) bounding all neighborhood masses by
\(e^{x_0}\). While \(x_i>X\), apply (17) and set
\(x_{i+1}=\sqrt{x_i}\). The number \(m\) of steps is finite:
\(\log x_i=2^{-i}\log x_0\). The case \(m=0\) is allowed.
If \(m>0\), the used parameters in reverse order are
\(y,y^2,y^4,\ldots\), with \(y>X\). Thus
\[
 \sum_{i<m}\varepsilon(x_i)\le2af(X)\le1/2,\qquad
 \sum_{i<m}1/x_i\le2/X\le1.                            \tag{19}
\]
Both estimates follow from finite geometric domination, not passage
to a limit depending on graph order.

Let \(T_i,M_i\) be the successive masses. Edge-injective preservation
gives \(0\le T_i\le T_0\) and \(0\le M_i\le M_0\). Rearrange (17):
\[
 T_i-T_{i+1}\le\varepsilon(x_i)T_0+M_0/x_i.
\]
Summing and using (19) proves \(T_m\ge T_0/2-M_0\).
The terminal normalization (2) gives
\(3T_m\le e^X M_m\le e^X M_0\). Combining these proves (1).
The finite telescoping and terminal algebra, for arbitrary sequence
length, are formalized in `Main.lean`. No one-step graph conclusion
is inferred merely from that formal recurrence theorem: (17) was
proved above. A finite sequence is extended constantly after its terminal
index, with zero further losses, to match the formal sequence domain.

### 7. The hypotheses really are strictly weaker

Fix integers \(1\le q<p\). For any integer
\(n\ge\max(4,p^2)\), take a single edge with weights
\[
 \alpha=2^{-n},\qquad \beta=n^p .
\]
It satisfies exponent-\(p\) (P) with the fixed constant \(2^p\).
Indeed, for every \(x\ge p\) and every \(B\), check the four possibilities
for \(A\). The empty set contributes zero. If \(A=\{\alpha\}\), its
cross mass is at most \(\alpha n^p\), whereas
\[
 g_{p,x}(\alpha)=\alpha(x+n\log2)^p\ge2^{-p}\alpha n^p.
\]
Here \(\log2\ge1/2\). If \(A=\{\beta\}\), the cross mass is at most
\(\alpha\beta\le\beta x^p=g_{p,x}(\beta)\).
If \(A\) is both endpoints, the directed cross mass is at most
\(2\alpha\beta\le\beta\le(\alpha+\beta)x^p=g_{p,x}(\alpha+\beta)\).
These bounds hold even without restricting \(B\), so they certainly
cover every eligible pair.

For exponent \(q\), use \(x=n\), \(A=\{\alpha\}\),
\(B=\{\beta\}\). These sets are eligible: \(\alpha\le e^n\) and
\(\log\beta=p\log n\le p\sqrt n\le n\).
Also \(x=n\ge q\). Any exponent-\(q\) cross constant must satisfy
\[
 C_q\ge\frac{n^p}{(n+n\log2)^q}
 \ge2^{-q}n^{p-q}\ \longrightarrow\ \infty.             \tag{20}
\]
The bounds \(1/2\le\log2\le1\) follow from
\(\log t\le t-1\) at \(t=1/2\) and \(t=2\).
The power inequalities behind both endpoint verification and (20)
are formalized for all natural exponents in `Main.lean`.
This family separates hypotheses; its triangle mass is zero. It is
**not** a counterexample to either manuscript or a lower bound on the
best constant in (1).

## Certification boundary

The preceding proof addresses every finite graph and every positive
weight vector under (P), and derives, rather than assumes, the
one-step entropy and splitting estimates. The theorem is not a finite
exhaustion claim. Its proof is a mathematical proof requiring an
independent reader; only the algebraic core named in
`statement_fidelity.md` is kernel-formalized.

The executable checks and the bounded Jacobian triangle-count operation
are supplementary exact checks of signs, normalizations, orientation,
and asymmetric-weight kernels. They do not prove a universal graph
theorem by sampling. No false literal manuscript assertion has been
identified, so there is currently no justified `F_` refutation claim.
The optimizer lemma, the complete independence theorem, and the
coloring-specific local adaptation remain outside the proved result.

The exact replay uses only Python's standard library:

```bash
python3 research/triangle_audit/verify.py --check
```

It checks the persisted certificate, rational graph identities, logarithm
coefficients in the entropy identity, source-bound Jacobian output, and
the current source and statement-fidelity digests of the real compiler
certificate. It does not replace independent reading of this proof.
To obtain a new compiler run, use the authorized interpreter and module:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/triangle_audit/Main.lean --statement-fidelity research/triangle_audit/statement_fidelity.md --artifact-dir research/triangle_audit --claim C_TRIANGLE_UNIVERSAL_CORE --project-root .
```
