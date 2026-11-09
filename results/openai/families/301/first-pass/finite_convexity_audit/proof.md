# Simultaneous trace and lower-support approximation

## Result and scope

We give an independent proof of Proposition `tc:finite-convexity` under
its stated hypotheses. In particular, the source quotients are genuine
quotients of the cone algebra, the output rank estimates hold for
**every extended trace**, and the support constants are chosen before
the final approximation. No restriction on the ideal lattice is added.

The proof also establishes a useful general principle: an exact
von Neumann realization of finitely many trace and support requirements
can be approximated against any finite separator by maps with prescribed
source-ideal vanishing and fixed hereditary range supports. Nuclearity
is used on the source quotients, not on a finite-dimensional surrogate.
The cone and realification hypotheses enter when constructing the exact
realization, not in this approximation principle.

This is a proof in ordinary operator-algebra mathematics, using the
classical inputs specified below. Only its extended-rank summation
step is formalized in `Main.lean`. Neither that formalization nor the
finite diagnostic in `verify.py` is a formal proof of the analytic
proposition. Independent review of the analytic proof and statement
fidelity remains necessary. No novelty or classification-theorem
certification is asserted here.

## 1. Exact data

Retain the manuscript's algebras
\[
 P=A\otimes\mathcal W\otimes\mathcal K,\qquad
 Q=B\otimes\mathcal W\otimes\mathcal K,\qquad
 S=C_0((0,1])\otimes P,
\]
their compatible maps \(F:T(Q)\to T(P)\) and
\(G:\mathrm{Cu}(P)\to\mathrm{Cu}(Q)\), and a finite full-support
Borel measure \(m\). Thus
\[
 d_\tau(G[a])=d_{F\tau}(a).
\]
Real scalar multiplication on these realified Cuntz semigroups and its
compatibility with rank evaluation are part of the retained invariant
structure. Stability lets us represent the classes used below by
positive elements of \(Q\).

For finitely many positive elementary tests \(s_i=f_i\otimes a_i\),
fix the manuscript's controllers \(G[a_i]\leq[b_i]\), and set
\[
 K_i=\{\tau:d_\tau(b_i)\leq1\},\qquad
 t_i^{(k)}(\tau)=\left(\int f_i^k\,dm\right)F(\tau)(a_i^k).
\]
No normalization \(m((0,1])=1\) is imposed.

Each lower requirement uses one of these same tests and data
\[
 0<r_j<m(\{f_j>\delta_j\}),\quad
 [y_j]=r_jG[(a_j-\delta_j)_+],\quad \|y_j\|\leq1,
\]
\[
 0<\eta_j<\theta_j<\delta_j^2,\quad
 0\leq g_j\leq1,\quad
 g_j|_{[0,\eta_j]}=0,\quad
 g_j|_{[\theta_j,\infty)}=1.
\]
These numbers and functions are fixed throughout the approximation.

A candidate is a c.p.c. map \(H:S\to M_k(Q)\) and contraction columns
\(v_j\in M_{k,1}(Q)\) such that, for finite constants \(C_i\),
\[
 d_{\tau\otimes\mathrm{Tr}}(H(s_i)),
 \ d_{\tau\otimes\mathrm{Tr}}(H(s_i^2))
 \leq C_i d_\tau(b_i)\quad(\tau\in T(Q)).                 \tag{1}
\]
The matrix trace in (1) is unnormalized. We prove that
\[
 \bigl((t_i^{(1)},t_i^{(2)},t_i^{(2)})_i;(y_j^2)_j\bigr) \tag{2}
\]
lies in the closed convex hull of the candidate vectors in
\(\prod_i C(K_i,\mathbb R)^3\times\prod_j Q_{\rm sa}\), with exactly
the product of the uniform and norm topologies in the manuscript.
For an empty test list there are no lower requirements and the
assertion is immediate; hence assume the test list is nonempty.

## 2. Classical inputs and the excluded objection

The non-elementary analytic inputs are recorded as assumptions in
`research/MATH_STATE.json`.

| Input | Exact source used |
|---|---|
| Compact Hausdorff cone of all extended l.s.c. traces, with the cut topology | Elliott--Robert--Santiago, arxiv:0805.3122v2, Theorem 3.7 and (3.3) |
| Nuclear quotient and nuclear unitization; positive Choi-matrix criterion | Blackadar, corrected author version dated February 8, 2017, IV.3.1.13, IV.3.1.3, IV.3.2.16 |
| UCP matrix factorizations of a unital nuclear algebra | Han--Paulsen, arxiv:1009.2541v4, Corollary 3.3 |
| Nuclear representations are hyperfinite; the standard hyperfinite II models | Connes, IHES report P/76/132, Theorem 4.1 and following paragraph, Theorems 4.2.1 and 4.3.1 |
| Semifinite hyperfinite central decomposition | Haagerup--Rosenthal--Sukochev, arxiv:math/0005150v1, Section 6, p49 after (6.48) and (6.50), together with type-I decomposition |
| Central decomposition and factor projection comparison | Blackadar, III.5.1.14--15 and III.1.7.9--10 |
| Strong-star Polish operator fields and the conull measured-field framework | Vaes--Wouters, arxiv:2405.16603v2, Lemma 8.6(1), Proposition 3.2 and its proof |
| Bounded operator approximation | Kaplansky, *A theorem on rings of operators*, Theorem 1 and its bounded selfadjoint proof |

We also use the classical analytic Jankov--von Neumann uniformization
theorem: an analytic relation on standard Borel spaces with nonempty
sections has a universally measurable selector. Its use is explicit
in the proof of Vaes--Wouters Proposition 3.2. The separate original
descriptive-set-theory source was not retrieved; this standard theorem
is an explicit non-kernel input, not a purported consequence that
Vaes--Wouters prove for our particular relation. We verify the
analyticity of that relation in Section 4.

Normal trace representations, spectral calculus, noncommutative
Cauchy--Schwarz, Hahn--Banach separation, and the Riesz representation
of the dual of \(C(K,\mathbb R)\) are used in their usual forms.
No new assertion about these background theorems is intended.

Short source passages are in `sources/`. The retrieved Blackadar and
Elliott--Robert--Santiago texts are also available there. Connes's
report numbering is not attributed to the differently organized
published Annals article. In HRS, the later notation \(R_\infty\)
means a type III factor; here we always write the semifinite model
as \(R\overline\otimes B(\ell^2)\).

**The citation-only CPAP objection is excluded.** Corollary 3.3 is
unital, but a nuclear nonunital quotient has nuclear unitization, and
compressing its outgoing UCP factorization by an approximate unit
gives c.p.c. maps into the quotient. Section 5 proves this explicitly.
This objection is retired as `R_CITATION_ONLY_CPAP`; it is not a
false assertion of the manuscript and is not an `F_` claim.

## 3. Caps, continuity, and a single barycenter for all candidates

For any \(C^*\)-algebra \(C\), the rank function
\(\tau\mapsto d_\tau(b)\) is lower semicontinuous: after rescaling
\(b\) to a contraction it is the supremum of the lower
semicontinuous evaluations \(\tau(b^{1/n})\). Therefore \(K_b\)
is closed in the compact trace cone, hence compact. Additivity and
positive homogeneity of rank give convexity, including extended
weights and the zero-controller case.

Suppose \(x\geq0\) has \(d_\tau(x)\leq L<\infty\) on \(K_b\).
Functional calculus and the normal trace on its finite ideal give
\[
 \tau(x)\leq\|x\|L,\qquad
 0\leq\tau(x)-\tau((x-u)_+)\leq uL.                    \tag{3}
\]
For a convergent net \(\tau_\lambda\to\tau\) in \(K_b\), the cut
topology and (3) give
\[
 \tau(x)\leq\liminf_\lambda\tau_\lambda(x)
 \leq\limsup_\lambda\tau_\lambda(x)\leq\tau(x)+uL.
\]
Let \(u\downarrow0\). Thus this evaluation is finite continuous
affine. Squaring a positive element does not change its support
rank. This proves continuity of all three coordinates of every
candidate separately, without a common bound for different candidates.
For the targets, \(d_{F\tau}(a_i)\leq d_\tau(b_i)\); apply the same
cut-loss argument after the continuous cone map \(F\).

Here is the barycenter statement in the required noncancellative
setting. Approximate a probability measure \(\mu\) on \(K_b\)
weakly by finitely supported probability measures
\(\sum_l\lambda_{\alpha,l}\delta_{\tau_{\alpha,l}}\), omitting zero
coefficients. Their finite cone barycenters belong to \(K_b\).
Compactness gives one convergent subnet with limit \(\bar\tau\).
For **every** finite continuous affine function \(v\) on \(K_b\),
\[
 v(\bar\tau)=\lim_\alpha\sum_l\lambda_{\alpha,l}v(\tau_{\alpha,l})
             =\int v\,d\mu.                           \tag{4}
\]
The subnet is chosen in \(K_b\), not separately for each \(v\).
Consequently (4) works simultaneously for the entire, possibly
uncountable, family of candidate evaluations. For a measure of
positive finite mass multiply by its mass; split a signed measure
into its two positive parts. No subtraction of extended weights
and no uniqueness assertion for a barycenter is needed.

## 4. Exact realization, including extended weights

Fix finitely many selected traces, each associated with a test whose
controller has finite rank at that trace, and finitely many bounded
selfadjoint functionals on \(Q\). We construct the realization needed
for an arbitrary separator. This section does not assume that \(F\)
commutes with a direct integral of weights.

### 4.1. Normal traces for selected weights

For a selected \(\tau\), let \(I_\tau=\operatorname{Fin}(\tau)\)
and \(K_\tau=\operatorname{Ker}(\tau)\). The trace representation of
\(I_\tau/K_\tau\) has weak closure \(N_\tau\) and a faithful normal
semifinite trace \(T_\tau\). It may be chosen separably acting:
a separable densely finite ideal has a countable approximate unit of
finite-trace cuts, and the resulting \(L^2\) space is separable.
Extend the representation nondegenerately from the ideal to \(Q\).
Its image remains in \(N_\tau\), since for an approximate unit \(u_l\)
of \(I_\tau\),
\(\pi_\tau(q)\pi_\tau(u_l)\to\pi_\tau(q)\) strongly.

Take the direct sum of these representations, a faithful separable
representation, and the GNS representations for the positive parts
of the finitely many bounded functionals. Write \(M=\pi(Q)''\).
Restriction to the \(\tau\)-summand is a normal surjective
homomorphism \(\vartheta_\tau:M\to N_\tau\): its image is a von
Neumann algebra containing \(\pi_\tau(Q)\), and conversely is
contained in \(N_\tau\). Set
\[
 \widehat\tau=T_\tau\circ\vartheta_\tau.
\]
It is a normal semifinite trace, possibly nonfaithful, and agrees
with \(\tau\) on \(I_\tau\). In particular,
\[
 d_{\widehat\tau}(\pi(c))=d_\tau(c)
 \quad(c\in(I_\tau)_+).                               \tag{5}
\]
The zero representation is harmless. The central supports of these
trace summands may overlap: each \(\widehat\tau\) is defined by its
own normal quotient, not by adding the traces of other summands.
Each designated bounded functional is normal on \(M\).

### 4.2. Factorwise realization

The nondegenerate image of a stable algebra is properly infinite:
multiplier isometries of \(Q\) extend normally to isometries in \(M\)
with orthogonal ranges. This remains true in almost every factor
of its central decomposition.

Consider such a factor \(M_x\). In a type-I factor the dimension
rank on \(\mathrm{Cu}(Q)\) takes only \(0,\infty\). Indeed, a finite
nonzero integer value \(n\), multiplied in the realified semigroup
by \(1/(2n)\), would give dimension \(1/2\), impossible in a type-I
factor. The transported rank data consequently specify only a zero
ideal. An infinite amplification of a faithful separable
representation of the corresponding quotient of \(S\), embedded in
\(B(\ell^2)\subseteq M_x\), has exactly these ranks. The same
construction works in a type-III factor, where all nonzero
projections have the same infinite dimension.

For a type-\(\mathrm{II}_\infty\) factor choose a faithful normal
semifinite dimension trace \(T_x\), only for this factorwise existence
argument, and put
\[
 \nu=m\otimes F(T_x\circ\pi_x),\qquad I=\operatorname{Fin}(\nu),
 \qquad K=\operatorname{Ker}(\nu).
\]
The trace representation of the nuclear algebra \(I/K\) has
separably acting hyperfinite semifinite weak closure \(N\).
Its representation extends from \(I\) to \(S\) by the action of
\(S\) on its ideal.

There is a trace-preserving normal injection of \(N\) into an
infinite corner of \(M_x\). Here are details that include arbitrary
semifinite central densities. Decompose \(N\) as a countable sum of
\(L^\infty(X_j,\mu_j^0)\overline\otimes N_j\), with
\[
 N_j\in\{M_n,\ B(\ell^2),\ R,\ R\overline\otimes B(\ell^2)\}.
\]
The faithful semifinite trace has a central density \(h_j\) with
\(0<h_j<\infty\) almost everywhere; absorb it in the sigma-finite
measure \(\mu_j=h_j\mu_j^0\).
An abelian \(L^\infty(X_j,\mu_j)\) embeds trace-preservingly in
\(L^\infty([0,\infty),dt)\): partition into finite-measure pieces,
replace atoms by intervals of the same mass, and use the standard
diffuse measure-space isomorphism on the remainder. The embedding
may be nonunital. This abelian algebra embeds diagonally in
\(R\overline\otimes B(\ell^2)\), and every \(N_j\) also embeds
trace-preservingly there. Tensor the two embeddings, use the
trace-preserving isomorphism of its tensor square with itself, and
put the countable summands in orthogonal matrix corners.
Finally, an arbitrary separably acting \(\mathrm{II}_\infty\)
factor contains a trace-preserving copy of this model: choose a
trace-one corner, nested unital dyadic matrix algebras there, and
then matrix-amplify their weak closure in the infinite corner.

In an orthogonal infinite corner put an infinite multiple of a
faithful separable representation of \(S/I\), inside a copy of
\(B(\ell^2)\) with finite positive trace on minimal projections.
This second summand vanishes on \(I\); every positive element
outside \(I\) has infinite trace and support rank in this summand.
The first summand gives \(\nu\) on \(I\). Thus the combined
homomorphism \(l_x:S\to M_x\) has
\[
 T_x\circ l_x=\nu,\qquad
 d_{T_x}(l_x(f\otimes a))
       =m(\{f>0\})d_{F(T_x\circ\pi_x)}(a).             \tag{6}
\]
Empty summands are simply omitted. The construction permits a zero
map when the prescribed quotient and trace are zero.

### 4.3. Select the maps and all support witnesses together

Include a countable family of elementary rectangle cuts sufficient
for the finite tests, their rational spectral partitions, and the
finitely many specified \(\delta_j\)'s. For each such
\(u=f\otimes a\), choose \(c_u\in Q_+\) with
\[
 [c_u]=m(\{f>0\})G[a].
\]
A zero scalar means \(c_u=0\). Equation (6), and the zero-ideal
construction in the other factor types, imply
\[
 \operatorname{supp}(l_x(u))\sim\operatorname{supp}(\pi_x(c_u)).
                                                               \tag{7}
\]

Code a contractive homomorphism on a countable dense rational
*-algebra of \(S\) by uniformly bounded operator coordinates, and
adjoin contraction coordinates \(w_u\) implementing (7).
Bounded multiplication and adjoints are strong-star continuous;
norm bounds are Borel. The support operation is the strong limit of
\(a(a+1/n)^{-1}\), hence is Borel on the positive bounded balls.
The measurable von Neumann field and its bounded strong-star balls
are the fields in Vaes--Wouters Lemma 8.6(1). Thus all the algebraic,
norm, membership, approximation and support equations are
countably many Borel conditions in a standard Borel code space.
The admissible relation is Borel, in particular analytic.

The lower comparison witnesses can be included in this same code.
Let
\[
 q_{j,x}=\operatorname{supp}
 l_x((f_j-\delta_j)_+\otimes(a_j-\delta_j)_+).
\]
Factor dimensions and \(r_j<m(\{f_j>\delta_j\})\) give
\(\operatorname{supp}(\pi_x(y_j))\precsim q_{j,x}\).
This includes zero dimensions and both infinite dimension cases.
Adjoin contractions \(v_{j,x}\) with initial projection
\(\operatorname{supp}(\pi_x(y_j))\) and final projection at most
\(q_{j,x}\); these are again Borel conditions.
Every factorwise section is nonempty by Section 4.2 and factor
projection comparison.

Analytic uniformization now provides a selector measurable for the
completed central measure. Replace its countably many bounded
coordinates by measurable representatives on one common conull
set. They assemble as decomposable operators in \(M\). The
algebraic relations give a homomorphism \(l:S\to M\), and all the
chosen support and lower-comparison witnesses assemble with it.
This does not assert an everywhere Borel selector, a measurable
normalization of \(T_x\), or an interchange of \(F\) with integration.

### 4.4. Evaluate moments on finite constants, not on a field of weights

For a selected \(\tau\) associated with test \(i\), choose constants
\(c_{u,v}\) representing
\[
 m(\{f_i>u\})G[(a_i-v)_+]\quad(u,v\geq0\text{ rational}).
\]
Their \(\tau\)-ranks are at most \(m((0,1])d_\tau(b_i)<\infty\);
therefore \(c_{u,v}\in I_\tau\). Applying the **single normal trace**
\(\widehat\tau\) to the assembled equivalences (7), using (5),
gives
\[
 \widehat\tau\bigl(\operatorname{supp}
 l((f_i-u)_+\otimes(a_i-v)_+)\bigr)
  =m(\{f_i>u\})d_{F\tau}((a_i-v)_+).                 \tag{8}
\]
In particular \(\operatorname{supp}(l(s_i))\) has finite
\(\widehat\tau\)-trace.

In the support corner of \(l\), the multiplier images of
\(f_i\otimes1\) and \(1\otimes a_i\) commute. Equation (8)
specifies their finite joint spectral measure on upper rectangles
in the strictly positive quadrant. Such rectangles determine the
measure there; its values are those of the product of \(m\)'s
spectral measure for \(f_i\) and the spectral rank measure for
\(a_i\) under \(F\tau\). Rational step approximations and normal
monotone convergence give
\[
 \widehat\tau(l(s_i^k))=t_i^{(k)}(\tau),\qquad k=1,2. \tag{9}
\]
The coordinate axes contribute zero to these moments.
Since \(l\) is a homomorphism, (9) also gives
\(\widehat\tau(l(s_i)^2)=t_i^{(2)}(\tau)\).

Functional calculus gives
\(q_j\leq1_{(\delta_j^2,\infty)}(l(s_j))\).
Because \(g_j=1\) on \([\theta_j,\infty)\) and
\(\theta_j<\delta_j^2\), the assembled lower witnesses satisfy
\[
 y_jv_j^*g_j(l(s_j))v_jy_j=y_j^2.                    \tag{10}
\]
Equations (9)--(10) give the simultaneous exact realization.

## 5. Quotient-first, fixed-support approximation principle

This section applies more generally to any separable nuclear source
\(S\), once the exact realization in Section 4 is available.
Fix that realization and the finite separator data before making
any approximations.

### 5.1. Central sectors and compact hereditary supports

Let \(z_i\) be the central support of \(b_i\) in \(M\). Set
\[
 z_E=\prod_{i\in E}z_i\prod_{i\notin E}(1-z_i),
 \qquad E\subseteq\{1,\ldots,n\}.
\]
These central projections are orthogonal and sum to \(1\).
For \(i\notin E\), the support identities and
\(G[a_i]\leq[b_i]\) imply \(z_El(s_i)=0\).
Consequently \(s_i\) and \(s_i^2\) are in the kernel of this
sector homomorphism.

Let \(J_E\) be the source ideal generated by those \(s_i\) with
\(i\notin E\), and let
\[
 I_E=\bigcap_{i\in E}\operatorname{Ideal}_Q(b_i),
 \qquad I_\varnothing=Q.
\]
The weak closure of \(I_E\) has central support
\(\prod_{i\in E}z_i\), which dominates \(z_E\).
Choose positive contractive approximate-unit elements \(e_E\in I_E\)
with compact Cuntz support. For example, continuous cuts, vanishing
on a neighborhood of zero, of a strictly positive element of \(I_E\)
form such an approximate unit. If \(I_E=0\), use \(e_E=0\).
Their strong limit is the support of \(I_E\), so
\[
 \psi_E(s)=e_Ez_El(s)e_E                              \tag{11}
\]
converges strongly star to \(z_El(s)\).
It takes values in
\(\operatorname{Her}(e_E)''=p_EMp_E\), where
\(p_E=\operatorname{supp}(e_E)\), and factors through \(S/J_E\)
**exactly**.

For \(i\in E\), compact Cuntz support inside
\(\operatorname{Ideal}(b_i)\) implies
\[
 [e_E]\leq N_{E,i}[b_i]\quad\text{for some }N_{E,i}\in\mathbb N.
                                                               \tag{12}
\]
Indeed a compact cut bounding \([e_E]\) is compactly contained in
a class from that ideal, whereas the largest class of the ideal
is \(\sup_N N[b_i]\). Compact containment gives a finite \(N\).
This argument works in an arbitrary ideal lattice. It is not a
claim that every element of an ideal is bounded by a finite
multiple of its generator.

### 5.2. Choose the compressions before the matrix approximation

Put \(D_0(s)=\operatorname{diag}_E(z_El(s))\) and
\(D_e(s)=\operatorname{diag}_E(\psi_E(s))\).
For a selected trace belonging to test \(i\), sectors excluding
\(i\) are zero. On the other sectors the positive operators
\(A=z_El(s_i)\) and \(B=z_El(s_i^2)\) have finite first moments,
and \(A\) has finite \(L^2(\widehat\tau)\)-norm, by (9).

For clarity, bounded strong convergence alone is not being used on
an infinite trace support. If \(A\geq0\) is trace-integrable and
\(e\) is a positive contraction converging strongly to the identity
on its support, Cauchy--Schwarz gives
\[
 \|eAe-A\|_1
 \leq2\|A^{1/2}\|_2\|(1-e)A^{1/2}\|_2\longrightarrow0.          \tag{13}
\]
The last convergence follows by applying the bounded normal
functional \(x\mapsto\widehat\tau(A^{1/2}xA^{1/2})\)
to \((1-e)^2\).
For a bounded \(L^2\) positive \(A\),
\[
 \|eAe-A\|_2\leq2\|(1-e)A\|_2,\qquad
 |\widehat\tau((eAe)^2)-\widehat\tau(A^2)|
 \leq4\|A\|_2\|(1-e)A\|_2\longrightarrow0.                    \tag{14}
\]
Apply (13) to the first and second inputs and (14) to the square
coordinate. All constants here concern the finitely selected weights.

Set \(V_j=(z_Ev_j)_E\). It is a contraction column, because
\(\sum_Ez_E=1\). Since \(g_j(0)=0\), (10) becomes
\[
 y_jV_j^*g_j(D_0(s_j))V_jy_j=y_j^2.
\]
Bounded strong-star functional calculus gives
\(g_j(D_e(s_j))\to g_j(D_0(s_j))\).
Thus we may choose the finitely many \(e_E\)'s far enough out to
make all selected trace errors and all designated normal-functional
errors as small as desired. **Fix them now**, and then fix the
integers \(N_{E,i}\) in (12).

If a selected trace is attached to \(i\in E\), (12) and (5) imply
\[
 \widehat\tau(p_E)=d_\tau(e_E)
       \leq N_{E,i}d_\tau(b_i)<\infty.                        \tag{15}
\]
Here \(e_E\in\operatorname{Ideal}(b_i)\subseteq I_\tau\), so (5)
really applies. If \(i\notin E\), no claim that (15) is finite is
made or needed: the corresponding tested outputs will be exactly zero.

### 5.3. Matrix factorizations within the fixed hereditary support

The quotient \(R_E=S/J_E\) is nuclear. Its unitization is nuclear
by the extension \(0\to R_E\to\widetilde R_E\to\mathbb C\to0\).
Here is the explicit nonunital CPAP argument. Given a finite subset
of \(R_E\) and an error \(\epsilon>0\), first choose a positive
contractive approximate-unit element \(u\in R_E\) with
\(\|uxu-x\|<\epsilon/2\) on that set. Next use Han--Paulsen on
\(\widetilde R_E\) with error below \(\epsilon/2\), obtaining UCP
maps \(\alpha:\widetilde R_E\to M_d\) and
\(\beta:M_d\to\widetilde R_E\). Restrict \(\alpha\) to \(R_E\)
and replace \(\beta\) by \(\beta_0(a)=u\beta(a)u\in R_E\).
Both maps are c.p.c. and
\[
 \|\beta_0\alpha(x)-x\|
 \leq\|\beta\alpha(x)-x\|+\|uxu-x\|<\epsilon.                  \tag{16}
\]

Compose \(\beta_0\) with the fixed map \(\psi_E\).
Its positive Choi matrix has a positive square root in
\(M_d(\operatorname{Her}(e_E)'')\). Bounded selfadjoint
Kaplansky approximation, followed by continuous positive functional
calculus, approximates that square root strongly star by uniformly
bounded elements of \(M_d(\operatorname{Her}(e_E))\).
Their products give positive Choi matrices and hence completely
positive maps \(\beta_\lambda:M_d\to\operatorname{Her}(e_E)\).
Their norms are uniformly bounded, and they converge strongly star
on matrix units to \(\psi_E\beta_0\).

These approximating maps need not initially be contractive.
With \(t_\lambda=\beta_\lambda(1)\), replace them by
\[
 \beta'_\lambda(a)=
 \max(1,t_\lambda)^{-1/2}\beta_\lambda(a)
 \max(1,t_\lambda)^{-1/2}.                                 \tag{17}
\]
Functional calculus is in the unitization of the hereditary algebra.
The new map remains in that algebra and is c.p.c., since its unit
value is \(t_\lambda/\max(1,t_\lambda)\leq1\).
The limit unit value is at most \(p_E\); hence the conjugating
factors in (17) converge strongly star to the unit of \(p_EMp_E\).
The desired strong-star limit is unchanged.

After composing with \(\alpha\) and the quotient map, (16)--(17)
therefore give c.p.c. maps
\[
 H_E:S/J_E\longrightarrow\operatorname{Her}(e_E)\subseteq Q
                                                               \tag{18}
\]
approximating the fixed \(\psi_E\) on the required finite tests.
There is no assertion of a norm approximation of \(\psi_E\) by
maps into \(Q\). Strong-star approximation suffices: for every
selected trace to which this sector contributes, (15) makes the
trace on \(p_EMp_E\) a bounded normal functional. Bounded strong-star
convergence on that one fixed support gives convergence of first
traces, second-input traces, and square traces. The norm error in
(16) can first be chosen small relative to these fixed finite trace
masses; then the Choi approximation is chosen. This order does not
let a support constant grow while its trace error is being estimated.

### 5.4. Genuine candidates and the whole-cap bound

Put the finitely many maps (18) in separate, **unnormalized**
matrix blocks. Their direct sum \(H:S\to M_k(Q)\) is c.p.c.,
because its norm is the maximum of the block norms.
For \(i\notin E\), both \(H_E(s_i)\) and \(H_E(s_i^2)\) vanish
exactly by the source quotient. For \(i\in E\), every output is
supported on \(p_E\), so (12) gives
\[
 d_\tau(H_E(s_i)),\ d_\tau(H_E(s_i^2))
       \leq N_{E,i}d_\tau(b_i)\quad(\tau\in T(Q)).
\]
Consequently
\[
 d_{\tau\otimes\mathrm{Tr}}(H(s_i)),
 \ d_{\tau\otimes\mathrm{Tr}}(H(s_i^2))
 \leq\left(\sum_{E\ni i}N_{E,i}\right)d_\tau(b_i)              \tag{19}
\]
for every extended trace. In particular the left side is zero
when the controller rank is zero, finite throughout the cap, and
unrestricted when its allowed bound is infinite.
There has been no division or cancellation of extended ranks.
The formal declaration `FiniteConvexity.sector_rank_bound` proves
exactly this scalar summation step; its companion declarations
prove the zero-controller and finite-cap conclusions.

Rectangular bounded Kaplansky density approximates the columns
\(V_j\) by contraction columns over \(Q\). For completeness,
embed a column and its adjoint in an off-diagonal selfadjoint
matrix, use bounded selfadjoint approximation, and compress to
that corner. This gives strong-star convergence of both the column
and its adjoint without increasing the norm.
Bounded multiplication and continuous functional calculus then
give the designated lower-functional approximations to those for
\(D_e\). Combining with Section 5.2 gives approximations to \(y_j^2\).
All selected trace coordinates converge to (9).

The result is a genuine candidate satisfying (1), not just an
operator in \(M\) or a matrix support model. The same candidate
approximates any prescribed finite list of separator evaluations.
It is not claimed to approximate the entire target uniformly by
a single candidate; convexification is the next step.

## 6. Closed-convex-hull conclusion

If (2) were outside the closed convex hull, real Hahn--Banach
separation would give a continuous real linear functional separating
it by a positive gap. On each \(C(K_i,\mathbb R)\) coordinate the
functional is integration against a finite signed measure; on the
algebra coordinates it is given by bounded selfadjoint functionals.
Section 3 replaces each of the positive and negative measure parts
by its mass times one barycenter evaluation, for the target and
**all** candidates simultaneously. There are at most \(6n\) selected
traces, with repetitions allowed, and all have finite controller
rank on their associated test.

Section 4 realizes these finite values exactly, and Section 5
approximates all of them by one genuine candidate with (19).
Choose the individual errors so that their sum weighted by the
finitely many scalar coefficients is less than half the separating
gap. This contradicts strict separation. It proves the proposition
with exactly the prescribed uniform-cap and algebra-norm topology.

Notice the logical order: a finite list of selected weights is
used to defeat a separator; the candidate's **admissibility** is
nevertheless proved for all extended weights by (19). Pointwise
trace approximation has not been substituted for whole-cap control.

## 7. Lower-support constants after normalized averaging

This is a separate consequence used downstream of the proposition.
It verifies the normalization and approximation constants, rather
than declaring the later diagonal or correction arguments proved.

Take a finite rational convex combination with coefficients
\(\lambda_\alpha>0\), common denominator \(N\), and multiplicities
\(n_\alpha=N\lambda_\alpha\). Zero-pad the internal spaces to a
common size. In
\(M_k(Q)\otimes M_N\), use
\(\tau\otimes\mathrm{Tr}_k\otimes\mathrm{tr}_N\), where only the
last factor is normalized. For any positive block input \(x_\alpha\),
\[
 \begin{split}
 \tau(x_{\rm av})&=\sum_\alpha\lambda_\alpha\tau(x_\alpha),\\
 \tau(x_{\rm av}^2)&=\sum_\alpha\lambda_\alpha\tau(x_\alpha^2),\\
 d_\tau((x_{\rm av}-\eta)_+)
   &=\sum_\alpha\lambda_\alpha d_\tau((x_\alpha-\eta)_+).
 \end{split}                                               \tag{20}
\]
These are block trace and support identities, valid also at
infinity. Dividing by an internal matrix size would be incorrect.
A trace-preserving folding with the manuscript's convention leaves
(20) unchanged.

Write
\[
 T=\sum_\alpha\lambda_\alpha
       yv_\alpha^*g(H_\alpha(s))v_\alpha y,\qquad
 \|T-y^2\|<\epsilon^2/2,
\]
and \(p=1_{(\epsilon,\infty)}(y)\).
Then \(pTp\geq(\epsilon^2/2)p\).
If \(y=0\), the desired inequality is immediate.
If the rightmost rank in (20) is infinite and \(y\ne0\), it is also
immediate. In the remaining case every contributing
\(g(H_\alpha(s))\) has finite rank, since \(g\) vanishes on
\([0,\eta]\). A row factorization puts \(T\) Cuntz below their
finite direct sum; the norm estimate gives
\((y^2-\epsilon^2/2)_+\precsim T\).
Thus \(p\) has finite rank as well.

All these cuts consequently belong to the finite ideal of the
given extended trace. In its induced normal trace representation,
traciality, \(v_\alpha v_\alpha^*\leq1\), and \(0\leq g\leq1\)
give
\[
 \frac{\epsilon^2}{2}\tau(p)
 \leq\tau(pTp)
 \leq\|y\|^2\sum_\alpha\lambda_\alpha
                  d_\tau((H_\alpha(s)-\eta)_+).
\]
Here \(\tau(p)\) denotes the normal trace of the support of the
constant cut, namely \(d_\tau((y-\epsilon)_+)\).
Using (20) yields, for every extended trace,
\[
 d_\tau((y-\epsilon)_+)
 \leq \frac{2\|y\|^2}{\epsilon^2}
           d_\tau((H_{\rm av}(s)-\eta)_+).                  \tag{21}
\]
Neither the constant nor \(\eta\) depends on \(N\), on the number
of candidates, or on their internal dimensions.

## 8. Why range-only approximation is a retired route

There is a genuine stabilized-algebra example showing why the
source quotient in Section 5 cannot be dropped. It is **not**
a counterexample to the proposition.

Let \(D=\mathcal W\otimes\mathcal K\) and \(P=Q=D\oplus D\),
with \(F,G\) the identity. Choose a nonzero compactly Cuntz
supported positive contraction \(d\in D\), put \(a=b=(d,0)\),
and choose \(s=f\otimes a\ne0\).
Choose \(t\) with \(f(t)>0\), a positive norm-one functional
\(\omega\) on \(C_0((0,1])\otimes D\) nonzero on \(f\otimes d\),
and \(0\ne c\in D_+\) contractive. On the direct-sum source define
\[
 H_n(x_1,x_2)=
    \bigl(x_1(t),\, n^{-1}\omega(x_1)c\bigr).
\]
Each \(H_n\) is c.p.c. and converges in map norm to the
homomorphism \(H_0(x_1,x_2)=(x_1(t),0)\).
For the ideal weight of \(D\oplus0\),
\[
 d_\tau(b)=0,\qquad d_\tau(H_n(s))=\infty
 \quad(n\geq1).
\]
No finite rank constant can repair these approximants. Quotienting
the second sector source by the first source summand excludes this
leakage exactly. The manuscript already requires this operation.
The bounded rational LP in `jacobian_payload.json` is only a scalar
diagnostic of the missing-zero condition: range-only leakage can
equal \(1\), whereas a quotient-first variable is exactly \(0\).
Its optimum is not transferred into a counterexample to the
manuscript, and no such transfer is claimed.

## 9. Mathematical improvement and remaining scope

The prior campaign state contained an ideal-transport comparator
and an unresolved question about simultaneous finite approximation.
The argument here resolves that finite bridge in ordinary
mathematics: it supplies exact source vanishing, one fixed support
per sector before final approximation, a whole-cap bound for every
extended weight, and the averaging constant (21).
Selecting the lower comparison witnesses together with the maps
also makes explicit which measurable relation must be uniformized.

No flawed literal manuscript assertion was found in this bounded
argument. The two retired shortcuts are not assertions the
manuscript makes, so inventing `F_` claims for them would be
misleading. The correction, point-corner passage, uniqueness, and
final intertwining remain separate open nodes in the dependency
graph. This proof does not certify the full classification theorem.

## Replaying the exact evidence

Run `python3 research/finite_convexity_audit/verify.py` from the
campaign root. It independently checks the rational LP's primal-dual
certificate, the finite convention examples, and the binding of the
successful real Lean run to the current source, fidelity document,
and ledger claim. It does not rerun Lean by default.
Add `--compile` for a fresh Lean 4.31.0 run through the authorized
Argus interpreter; that mode also records the compiler outcome and
runs both official campaign-local checks. Neither mode substitutes
for reading the analytic proof or independently attributing its
literature inputs.
