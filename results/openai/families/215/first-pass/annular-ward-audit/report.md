# Fourth-order Ward mechanism: mathematical audit

## Scope and statements

This work addresses `prop:fourth` in `rotation.tex` and `prop:annulus`
in `annulus.tex` of the staged September 23, 2026 exponential-decay
manuscript. The other four manuscript goals remain separate. A spin
two-point estimate does not by itself establish a full transfer gap,
an isolated pole, a continuum limit, or exact mass asymptotics.

The finite-graph question has arbitrary prescribed spins, complex
test functions vanishing on the prescribed vertices, and an arbitrary
finite family. The annular question is uniform in the retained
nearest-neighbor subgraph, edge strengths, scale, and boundary angle.
Checking a list of graphs or scales cannot establish either statement.

## Source map

All section paths below are relative to
`research/openai_manuscript/Exponential-decay-in-two-dimensional-classical-On-models-September-23-2026/build/`.

* `sections/rotation.tex`: `eq:rotation-nonabelian-gauge`,
  `eq:rotation-B-quadratic`, `eq:rotation-B-fourth`,
  `eq:rotation-fourth-identity`, `eq:rotation-response-balance`,
  `eq:rotation-fourth-lower`, and the eleven-row contraction table.
* `sections/annulus.tex`: `lem:modes`, especially
  `eq:annulus-commutator`, `eq:annulus-test-cost`, and
  `eq:annulus-operator-factorization`; then `prop:annulus`.
* `main.tex`, lines 103-112: the manuscript explicitly distinguishes
  spin two-point decay from a full transfer gap and from uniqueness.

## Scoped prior knowledge and excluded inference

The historical second-order Ward method and the new fourth-order
mechanism are different assertions. No historical theorem will be
used to assume the fourth-order estimate or its logarithmic gain.
Likewise, absence of spontaneous magnetization does not imply
vanishing boundary-twist cost on annuli of fixed aspect ratio.
The planar low-temperature model is a warning against that inference.
The preliminary literature search found no source establishing the
specific signed-coupling annular statement; this is not a novelty proof.

The proof below is self-contained apart from elementary
finite-dimensional calculus, matrix norm inequalities, and integration
against compactly supported probability measures. These inputs will be
proved or stated explicitly, not hidden behind an assumed version of
the desired inequality.

Aru, Garban, and Sepulveda, arXiv:2212.06767v1, Theorem 1.5, constructs
translation-invariant strongly mixing subgraphs approaching the full
square lattice, on which the XY model is massive despite strong
percolation of retained edges. The statement was read at
<https://arxiv.org/html/2212.06767v1#S1.Thmtheorem5>; a passage is
retained in `ags-theorem-1-5.txt`. This rules out the inference from
strong-edge percolation alone to masslessness. It is a scope fact,
not an input to the proof below. Independent citation attribution is
left to the Host's Reviewer; no self-attribution is represented as an
independent literature check.

The Aizenman--Simon primary PDF was not obtained: Project Euclid returned
a bot-challenge page. Consequently no theorem or temperature condition
from that paper is assumed. The broad web-search response confused
continuum loop-model annulus partition functions with this lattice
boundary problem; it supplies no mathematical evidence or novelty
certification.

## Result and improvement over the staged theorem

**Theorem A (signed finite-graph family inequality).** Let \(n\geq3\).
At each integrated vertex of a finite oriented graph use any probability
measure on the closed unit ball of \(\mathbb R^n\) invariant under
rotations of the first three coordinates. The measures may differ
between vertices. Prescribe arbitrary unit-ball spins on \(P\).
Give the edges arbitrary real strengths \(|b_e|\leq\beta\).
Let \(a,b,c\) be the standard three cross-product generators, acting
as zero on the other coordinates, with \([a,b]=c\).
Define \(H,W,X,H_k,R,S,T,Q\) exactly as in the manuscript.
For every finite complex family vanishing on \(P\),
\[
 R(Q,\overline Q)\leq
 K(\beta)\|T\|_{\rm HS}^2+
 \beta\sum_{i,j}\min\{
 \|f_i\|_\infty^2\|df_j\|_2^2,
 \|f_j\|_\infty^2\|df_i\|_2^2\},
 \qquad K(\beta)=6\beta^2+4\beta^{3/2}+\beta .
\tag{A}
\]
There is no sign restriction on the strengths and no requirement of
aligned prescribed spins.

Fix the manuscript's real cutoff \(\Theta\), cutoffs \(\chi_m\), and
profiles \(\phi_{m,\pm}=(\chi_m\pm\partial_m\Theta)/2\).
Let \(M\geq1\) bound the absolute values of \(\Theta\) and its coordinate
derivatives through order three, and of all four profiles and their
coordinate derivatives through order two. All bounds are global.
Mixed derivatives may also be included in \(M\), but are not needed.
These are fixed smooth compactly supported functions, so \(M<\infty\).
They can be chosen by ordinary one-dimensional smooth plateau
functions and products; no spin model parameter enters their choice.

**Theorem B (arbitrary boundary textures, explicit annular bound).**
For every model in Theorem A on any retained nearest-neighbor subgraph
of \(D_N\), \(N\geq2\), prescribe arbitrary spins \(q_x\) on the two
boundary layers. On the inner layer replace them by
\(\exp(tc)q_x\); on the outer layer leave them fixed. There are no
additional pinned interior vertices. If \(Z(t)\) is its partition
integral, including interactions between prescribed spins, then
\[
 \frac{\min_t Z(t)}{\max_t Z(t)}
 \geq 1-\frac{2^{34}M^4K(\beta)}{H_N},
 \qquad H_N=\sum_{r=1}^N\frac1r .
\tag{B}
\]
The bound is uniform in \(n\), the measures, the retained graph,
the strength signs, the prescribed boundary patterns, and the angle.
Since \(H_N\geq\log(N+1)>\log N\), it implies `prop:annulus`.

The staged theorem treats uniform \(S^2\) measures, ferromagnetic
strengths, and constant boundary directions. The extension to signed
strengths, arbitrary invariant unit-ball measures, higher-dimensional
spectators, and arbitrary boundary textures is the mathematical
improvement here; (B) also gives an explicit constant. No claim is made
that these extensions are absent from all earlier literature.

## Proof of Theorem A

### 1. Ward identities and arbitrary prescribed spins

The spin space is bounded, all products are finite, and exponentials
and their derivatives are uniformly bounded on bounded parameter
sets. Dominated differentiation therefore applies even for singular
reference measures. At an integrated vertex the change of variables
\(s_x^{\rm old}=\exp(-tf_xg)s_x^{\rm new}\) preserves its measure.
At a prescribed vertex it changes nothing if \(f_x=0\).
Commutation along a single generator gives
\(W((h+df)g)=W(hg)\), for real parameters.
In particular \(W(t(df)g)=1\).

Every local derivative coefficient
\[
 J_e(g_1,\ldots,g_k)=
 b_e s_x^T\left(\frac1{k!}\sum_{\pi\in\mathfrak S_k}
                   g_{\pi(1)}\cdots g_{\pi(k)}\right)s_y
\]
has absolute value at most \(\beta\): spins have norm at most one,
and each generator has operator norm one. This uses \(|b_e|\leq\beta\),
not \(b_e\geq0\). Differentiating the preceding Ward identity gives
\[
 \mathbb E|X_g(df)|^2\leq\beta\|df\|_2^2,\qquad
 R(h,\overline h)
 =-\mathbb E[H_2(hc,\overline h c)+|X_c(h)|^2]
 \leq\beta\|h\|_2^2.
\tag{1}
\]
For complex \(f\), split it into real and imaginary parts; \(X\) is
real on real arguments, so the two squared terms add. Complex
multilinearity then also gives \(R(h,df)=0=R(df,h)\).
No positivity of \(R\) is asserted.

### 2. Noncommuting gauge, fourth cancellation, and pairings

For real \(F_x\in\operatorname{span}(a,b)\), zero on \(P\), the
same substitution gives
\[
 W(dF)=W(B),\qquad
 B_{xy}=\log(\exp(F_x)\exp(F_y-F_x)\exp(-F_y)).
\tag{2}
\]
All products lie in the embedded \(SO(3)\) subgroup. Its logarithm
near the identity lies in the embedded three-dimensional Lie algebra,
not in the whole \(\mathfrak{so}(n)\). Multiplication of exponential
series gives
\[
 DB(0)=0,\qquad B_{xy}^{(2)}=\tfrac12[F_x,F_y].
\tag{3}
\]
For the mixed generator pattern \(a,b,a,b\), the fourth coefficient is
fixed by conjugation by the half-turn about \(a\), because the two
\(b\) labels change sign. It is also fixed by the half-turn about
\(b\). In the embedded Lie algebra the fixed spaces are respectively
\(\mathbb Ra\) and \(\mathbb Rb\), with zero intersection.
Thus \(D_{1234}B=0\). This argument would not be valid for an
arbitrary element of all of \(\mathfrak{so}(n)\); the embedded-subgroup
observation is essential to the extension.

The exact polynomial replay computes the same logarithm in the ring
\[
 \mathbb Q[x_1,\ldots,x_4,y_1,\ldots,y_4]
 [t_1,\ldots,t_4]/(t_1^2,\ldots,t_4^2).
\]
Each \(x_j,y_j\) is an indeterminate endpoint value. Discarding
squares in the four labeled parameters does not change any derivative
with each label used once. All six quadratic coefficients and the
entire fourth coefficient are checked, not sampled.

Set \(A_1=u_i a,A_2=\overline{u_i}b,
A_3=\overline{u_j}a,A_4=u_jb\).
The fourth composition rule in (2) has no singleton blocks by
\(DB=0\), and its one-block term vanishes by the fourth cancellation.
Only pair partitions remain. The \(13|24\) partition vanishes.
The other two, each occurring once, are
\[
 (S_i c,\overline{S_j}c),\qquad
 (S_{ij}c,-\overline{S_{ij}}c).
\]
Consequently
\[
 D^4W(A_1,A_2,A_3,A_4)
 =-R(S_i,\overline{S_j})+R(S_{ij},\overline{S_{ij}}).
\tag{4}
\]
In particular the sign of the second term is positive.
The conjugations and gradient corrections are formalized in
`Main.lean`. Complex arguments in (3)-(4) are extensions of real
derivative identities; no complex change of integration variables
is used.

Summing (4) gives the manuscript's response balance. Since
\[
 S(f,g)+\tfrac12d(fg)=\tfrac12(f_x+f_y)\,dg,\quad
 S(f,g)-\tfrac12d(fg)=-\tfrac12(g_x+g_y)\,df,
\]
and \(fg=0\) on \(P\), (1) bounds its cross-response sum by the
minimum-pair term in (A).

### 3. All fifteen partitions, the square, and eleven errors

Differentiate \(\exp H\) four times, with the four labels independent.
Its fifteen terms correspond to the fifteen set partitions.
The four partitions in
\((X_1X_2+H_{12})(X_3X_4+H_{34})\) sum over \(i,j\) to
\[
 \mathbb E\left|\sum_i
   (X_a(u_i)X_b(\overline{u_i})
                    +H_2(u_i a,\overline{u_i}b))\right|^2\geq0.
\tag{5}
\]
Write \(t_e(l)=T_{el}\) and
\(\rho_e^2=\sum_l|T_{el}|^2\). The identity
\[
 t_e=d\left(\sum_i u_i(e)\overline{f_i}\right)
\tag{6}
\]
shows that both \(t_e\) and its conjugate are admissible gradients.
Their currents have squared expectations at most \(\beta\rho_e^2\).

For completeness, the universal four-slot kernel underlying every
remaining contraction is
\[
 \sum_{i,j}u_i(e_1)\overline{u_i(e_2)}
               \overline{u_j(e_3)}u_j(e_4)
 =T_{e_1e_2}T_{e_4e_3}.
\tag{7}
\]
This follows by factoring the independent finite sums, for every
family cardinality. `kernel_factor` and `contraction_table` in
`Main.lean` prove (7) and the eleven specializations universally.
The script separately enumerates all fifteen partitions and checks
that the eleven rows are exactly the complement of (5).

| Terms | Contracted current or kernel | Total absolute bound |
|---|---|---|
| \(H_{13}X_2X_4\) | \(X_b(t_e)X_b(\overline t_e)\) | \(\beta^2\|T\|_{\rm HS}^2\) |
| \(H_{14}X_2X_3\) | \(X_b(t_e)X_a(t_e)\) | \(\beta^2\|T\|_{\rm HS}^2\) |
| \(H_{23}X_1X_4\) | \(X_a(\overline t_e)X_b(\overline t_e)\) | \(\beta^2\|T\|_{\rm HS}^2\) |
| \(H_{24}X_1X_3\) | \(X_a(\overline t_e)X_a(t_e)\) | \(\beta^2\|T\|_{\rm HS}^2\) |
| \(H_{13}H_{24}\) | \(T_{el}\overline{T_{el}}\) | \(\beta^2\|T\|_{\rm HS}^2\) |
| \(H_{14}H_{23}\) | \(T_{el}^2\), not \(|T_{el}|^2\) | \(\beta^2\|T\|_{\rm HS}^2\) |
| \(H_{123}X_4\) | \(T_{ee}X_b(\overline t_e)\) | \(\beta^{3/2}\|T\|_{\rm HS}^2\) |
| \(H_{124}X_3\) | \(T_{ee}X_a(t_e)\) | \(\beta^{3/2}\|T\|_{\rm HS}^2\) |
| \(H_{134}X_2\) | \(T_{ee}X_b(t_e)\) | \(\beta^{3/2}\|T\|_{\rm HS}^2\) |
| \(H_{234}X_1\) | \(T_{ee}X_a(\overline t_e)\) | \(\beta^{3/2}\|T\|_{\rm HS}^2\) |
| \(H_{1234}\) | \(T_{ee}^2\) | \(\beta\|T\|_{\rm HS}^2\) |

The local \(J\) coefficient is bounded *inside* the expectation before
Cauchy--Schwarz; it is not assumed independent of the currents.
For each of the first four rows the bound is
\(\beta\sqrt{\beta\rho_e^2}\sqrt{\beta\rho_e^2}\), summed over \(e\).
The next two use \(|T_{el}^2|=|T_{el}|^2\).
For each cubic row use
\[
 \beta^{3/2}\sum_e T_{ee}\rho_e
 \leq\beta^{3/2}
       \left(\sum_e T_{ee}^2\right)^{1/2}
       \left(\sum_e\rho_e^2\right)^{1/2}
 \leq\beta^{3/2}\|T\|_{\rm HS}^2.
\]
The last row uses the same diagonal sub-sum.
Complex conjugation interchanges \(i,j\) in the full fourth sum,
so that sum is real. Retain (5) and subtract the eleven bounds.
This proves its lower bound \(-K(\beta)\|T\|_{\rm HS}^2\);
the response balance (4) now proves (A).

## Proof of Theorem B

### 4. Exact collective form and explicit profile errors

Use the four manuscript frequency groups with
\(r=\|p\|_\infty\), \(1\leq r\leq N\),
\(\pm p_m>0\), and normalization \(r^{-3/2}\).
The tests vanish on both boundary layers. On a direction-\(j\) edge,
\[
 S(f_p,\overline f_p)
 =-i r^{-3}\phi(x/N)\phi((x+e_j)/N)
                      \sin(\pi p_j/(8N)).
\]
Groups with \(m\ne j\) cancel under reflection of \(p_j\).
The two remaining groups have opposite sine sums. Swapping the two
coordinates identifies the common positive sum, hence
\[
 Q=-i\lambda_N\widetilde h,\qquad
 \lambda_N=N\sum_{r_p\leq N,\ p_1>0}
                 r_p^{-3}\sin(\pi p_1/(8N)).
\tag{8}
\]
Every summand is nonnegative. On the face \(p_1=r\) there are \(2r+1\)
frequencies. Concavity of sine on \([0,\pi/2]\) gives
\(\sin(\pi r/(8N))\geq r/(4N)\); thus
\(\lambda_N\geq\sum_r(2r+1)/(4r^2)\geq H_N/2\).

There are at most \(50N^2\) retained edges: the containing square has
at most \(25N^2\) vertices and at most two positive outgoing edges per
vertex. Therefore \(\|h\|_2^2\leq50M^2\) and
\(\|h+\widetilde h\|_\infty\leq3M^2/N\).
At an edge midpoint \(z\), with \(d=1/(2N)\), Taylor's integral
remainder gives
\[
 |h-N^{-1}\partial_j\Theta(z)|\leq M/(24N^3).
\]
For \(q(v)=\phi(z-ve_j)\phi(z+ve_j)\), \(q'(0)=0\) and
\(|q''(v)|\leq4M^2\). Hence
\(|q(d)-q(0)|\leq M^2/(2N^2)\).
Use \(\phi_{j,+}^2-\phi_{j,-}^2=\partial_j\Theta\).
It follows that \(|h_e-\widetilde h_e|\leq2M^2/N^3\), and
\[
 \|h-\widetilde h\|_1\leq100M^2/N.
\tag{9}
\]
Deletion of vertices or edges cannot increase any of these estimates.

### 5. Both family costs are logarithmic, for every scale

A half-plane frequency group has exactly
\((2r+1)+2(r-1)=4r-1\) modes on shell \(r\); all four groups have at
most \(16r\). The discrete product rule gives
\[
 \|f_p\|_\infty^2\leq M^2r^{-3},\qquad
 |df_p(e)|\leq\frac{M r^{-3/2}}N(1+r/2)
       \leq\frac{3M}{2N\sqrt r}.
\]
Thus \(\|df_p\|_2^2\leq128M^2/r\).
For \(s\leq r\), use the supremum of the shell-\(r\) function in the
minimum. Counting all pairs on the shells, then both shell orders,
gives
\[
 \sum_{i,j}\min\{\cdots\}
 \leq 2\cdot16^2\cdot128\,M^4
                     \sum_{r=1}^N\sum_{s=1}^r r^{-2}
 =2^{16}M^4H_N.
\tag{10}
\]

For the HS cost, work in one profile group on the \(16N\)-periodic
torus. Its distinct waves \(F_{xp}=\exp(2\pi i p\cdot x/(16N))\)
satisfy \(F^*F=(16N)^2I\). Indeed, each off-diagonal entry is a
product of geometric sums, at least one with a nontrivial root of
unity and hence zero; each diagonal entry is \((16N)^2\).
Set \(U_p=\sqrt{r_p}\,df_p\).
The exact factorization of its direction-\(j\) block is
\[
 U_j=P_jM_{\Delta_j\phi}F\operatorname{diag}(r_p^{-1})
 +P_jM_{\phi^{(j)}}F
             \operatorname{diag}((e^{2\pi i p_j/(16N)}-1)/r_p).
\tag{11}
\]
Here restriction \(P_j\) has norm at most one,
\(\|\Delta_j\phi\|_\infty\leq M/N\), and the last diagonal norm
is at most \(1/(2N)\). Thus
\(\|U_j\|_{\rm op}\leq16M+8M\leq32M\) and
\(\|U\|_{\rm op}^2\leq2^{11}M^2\).

For matrices, \(\|AB\|_{\rm HS}\leq\|A\|_{\rm op}\|B\|_{\rm HS}\)
follows by applying the operator inequality to every column;
the right-multiplication version follows by adjoints.
Since \(T_{\rm group}=U\operatorname{diag}(r_p^{-1})U^*\),
\[
 \|T_{\rm group}\|_{\rm HS}^2
 \leq2^{22}M^4\sum_p r_p^{-2}
 \leq2^{24}M^4H_N.
\]
The squared triangle/Cauchy inequality over four groups gives
\[
 \|T\|_{\rm HS}^2\leq4\sum_{\rm groups}
           \|T_{\rm group}\|_{\rm HS}^2\leq2^{28}M^4H_N.
\tag{12}
\]
This proves the asserted logarithmic cost without mode-by-mode
triangle bounds. In particular it does not replace (12) by a finite
Fourier experiment.

### 6. Response transfer without assuming positivity

At any twist \(t\), (A), (8), (10), and (12) give
\[
 R_t(\widetilde h,\widetilde h)
 \leq (2^{30}K(\beta)+2^{18}\beta)M^4/H_N .
\tag{13}
\]
Bilinearity gives a *positive* factor \(\lambda_N^2\) from
\(R_t(-i\lambda_N\widetilde h,i\lambda_N\widetilde h)\).

If \(R_t(h,h)\leq0\), the desired positive upper bound already holds.
Otherwise (1) implies
\(\mathbb E_tX_c(h)^2\leq50\beta M^2\).
Put \(d=h-\widetilde h\). Pointwise,
\(|X_c(d)|\leq\beta\|d\|_1\leq100\beta M^2/N\).
Consequently
\[
 |\mathbb E_t(X_c(h)^2-X_c(\widetilde h)^2)|
 \leq1600\beta^{3/2}M^4/N+10000\beta^2M^4/N^2.
\]
The local second-derivative error is at most
\(\beta\|d\|_1\|h+\widetilde h\|_\infty
\leq300\beta M^4/N^2\).
Use \(H_N\leq N\) and (13). Coefficient comparison in
\(v=\sqrt\beta\geq0\) gives
\[
 R_t(h,h)\leq\delta_N,\qquad
 \delta_N=2^{31}M^4K(\beta)/H_N.
\tag{14}
\]
Specifically \(2^{31}K-(2^{30}K+2^{18}\beta+
1600\beta^{3/2}+10000\beta^2+300\beta)\) has coefficients
\(1073479380,4294965696,6442440944\) at \(v^2,v^3,v^4\),
respectively, all positive. This covers every temperature, not a
bounded parameter range.

As a check on the logical necessity of this transfer, one edge with
both spins prescribed as \(e_1,e_2\), \(b=1\), has \(X_c(1)=-1\),
\(H_2(c,c)=0\), and \(R(1,1)=-1\). This is not a counterexample to
the manuscript, which explicitly does not assume positivity of \(R\).

### 7. Boundary gauge and periodic ODE

In the law at \(t\), the change of variables with potential
\(s\Theta(x/N)c\) cancels every edge twist and maps the prescribed
inner spin \(\exp(tc)q_x\) to \(\exp((t+s)c)q_x\). It fixes every
outer spin, regardless of its direction. Thus
\[
 W_t(shc)=Z(t+s)/Z(t),\qquad R_t(h,h)=-Z''(t)/Z(t).
\]
The partition integral is positive, smooth, and \(2\pi\)-periodic.
Write \(Z(t_0)=Z_{\max}\). Then \(Z'(t_0)=0\), and (14) gives
\(Z''\geq-\delta_N Z\geq-\delta_N Z_{\max}\).
Any point is within distance \(\pi\) of \(t_0\) along the circle.
Integrating twice along that direction gives
\[
 Z(t)\geq Z_{\max}(1-\pi^2\delta_N/2)
         \geq Z_{\max}(1-8\delta_N).
\]
This is (B), including cases where one or both boundary layers are
absent from the retained graph. If \(\beta=0\), \(Z\) is constant
and both theorems hold directly.

## Consequence for the staged spin-decay argument

For the original nonnegative-coupling \(S^2\) model with both boundary
layers aligned, `clusters.tex`, `eq:crossing-partition-ratio`, identifies
the pinned crossing probability with \(1-Z(\pi)/Z(0)\).
Theorem B supplies its uniform \(O(1/H_N)\) bound. The simultaneous
pinning comparison, disjoint-annulus independence, connection-path
counting, and higher-component reduction remain separate arguments.
They are recorded as the open obligation `L_SPIN_CLUSTER_TRANSFER`;
this audit has not independently certified all of them.
In particular the signed extension of Theorem B does not inherit
ferromagnetic cluster monotonicity.

No false literal assertion was established in `rotation.tex` or
`annulus.tex`, so no `F_` refutation claim is warranted. The retired
spin-decay-to-full-gap inference was expressly *excluded* by the
manuscript, not a flaw attributed to it.

## Exact and formal evidence, and its limits

`verify.py` uses only the Python standard library. Run
`python3 research/annular-ward-audit/verify.py`.
It replays the universal rational gauge jets, the complete partition
enumeration and contraction wiring, exact scale-independent constant
accounting, and the retained typed Jacobian result. It also checks
that the successful Lean record matches both current formal files.
The coefficient ring carries arbitrary endpoint indeterminates;
there is no graph-size, family-size, temperature, or scale cutoff in
the theorem.

The adapter operation was
`matrix.symbolic.characteristic_polynomial.compute`, server 0.14.0,
protocol 2025-11-25. Its retained payload is the symbolic matrix
\(xa+yb\). It returns
\(\det(\lambda I-xa-yb)=\lambda^3+(x^2+y^2)\lambda\).
The script independently replays the determinant and matrix cube
relation. This is a local algebraic check, not an external proof of
Theorem B. The discovery query found no directly matching BCH
operation, so a nearby operation was not presented as one.
`jacobian-status.json` records adapter exit code zero; the complete
typed result is retained in `jacobian-output.json`.

`Main.lean` has a real Lean 4.31.0 successful compile, exit code zero
and no proof holes. `statement_fidelity.md` separates exactly what
is formalized from the analytic reasoning. The compiler does not
certify dominated differentiation, the matrix logarithm, the norm
estimates, Fourier orthogonality, Taylor remainders, or the ODE proof.
Those are proved above and require the Host's independent Reviewer.
The exact certificate is therefore an engineer's parameter-uniform
theorem and exact algebra record, not an already independently
accepted or wholly kernel-checked annular theorem.

The campaign's publishable target and exploratory mode remain
unchanged. Significance and literature novelty are for independent
review; neither a finite exclusion nor an unverified novelty claim
is being used to declare campaign completion.

At engineer handoff the official `math_state check` and
`proof_graph_check check` both exited zero against the exact project root
`campaigns/9000215`, after
the final ledger and graph changes. The exact replay also exited zero.
Public role progress records these outcomes and the pending independent
review; no source files of the staged manuscripts were changed.
