# Scalar pair-response audit

## Scope and source conventions

The question is whether Lemma `inv:sector-response`, including (H2), in
`The-low-temperature-Sherrington-Kirkpatrick-free-energy-limiting-law-September-24-2026/build/sections/05-inverse.tex`
follows from its kernel (A8), its normalized one-spin recursion, and the
companion's signed attachment rules. Both sectors, arbitrary finite
resolutions, arbitrary fixed old-label topologies, and the mass-weighted
estimates are in scope. The main fluctuation and limiting-law theorems
remain unverified by this local audit.

The reference measure is always the positive normalized scalar tree law.
The signed coefficients are not probabilities. In (A8) the disconnected
term is the product of two separately averaged pair moments, evaluated on
their restrictions of the common final topology. Coincident labels from
different pairs are allowed; the two arguments of any one pair are
distinct.

The exact starting data are:

1. The recursion and scalar PDE in limiting-law `02-foundations.tex`,
   subsection "Scalar references and Laplace tests", with terminal mass
   one, terminal value `log(cosh(z))`, and zero initial field.
2. Kernel (A8) in the same section, in the proof of
   `found:cavity-quotient`.
3. Signed real-power differentiation and attachment in the companion
   `foundations.tex`, Section 2, especially the finite-tree
   differentiation rule and `lem:found-attachment`: terminal
   coincidences have weight one, a new occupied-edge split has weight
   minus its mass length, and an existing mass-v fork with d children
   has weight `-(d-1)v`.
4. The conditional source-Hessian identity in the companion
   `lem:found-source`. Its elementary normalized tilted-expectation
   differentiation formula is printed in its proof.

These are source-specific inputs, not an appeal to the companion's main
fluctuation theorem. Their exact hypotheses must be kept during the
derivation. No external asymptotic SK theorem is needed for this local
question. The source bibliography identifies PE as the dated staged
companion; it supplies no DOI or arXiv identifier for PE.

The inherited project ledger contains only the campaign objective, with
no established response theorem or previous certified counterexample.
The project wiki index has no matching SK or pair-response entry.

An unconstrained assignment of abstract pair/four-spin moments is not an
admissible scalar-model counterexample: admissibility must come from the
normalized recursion. Finite tree checks likewise do not prove the
quantified response lemma. These are excluded routes, not negative
evidence about the lemma.

## Main dependency frontier

The scale manuscript asserts variance `n^(1/3+o(1))` for fixed
`1 < beta < infinity`. Its introduction routes this through finite-tree
calculus, optimized comparisons, cubic cavity closure, profile
identification, finite propagation, and the positive Laplace window.

The limiting-law manuscript asserts quantitative moment convergence with
a strictly positive variance prefactor, then all-integer distributional
convergence of the variance-normalized free energy. Its new summable
size comparison uses the pair inverse. The inverse in turn needs both
response sectors, Hessian positivity, and mass-weighted differences;
boundedness of finitely many matrices alone does not supply its claimed
absolute attachment domination.

No main theorem is marked proved on the strength of this decomposition.

## Result and its exact scope

**Verification theorem.** With the scalar model and signed allocation
conventions specified above, Lemma `inv:sector-response` is valid for
every finite strictly increasing real mass resolution, every monotone
step scalar clock, and every fixed finite old-label tree. This includes
both sector actions, (H2), the positive Hessian, the mass-weighted
successive and mixed differences, and the zero-field small-time bound.
Flat clocks are obtained by continuity. The incoming mass can tend to
zero only after the block denominators have been combined, as in the
manuscript; an individual normalized block average is not uniformly
bounded by this argument.

There is a stronger structural conclusion not stated in the manuscript:
the Hessian kernels are **decreasing in the Loewner order as the
starting prefix advances**. Their decrements are exact Gram-energy
integrals. In fact the full joint field/profile Hessian has a
conditional Gram representation and is a positive-semidefinite
matrix supermartingale, including at bounded stopping prefixes.
The energy theorem below also holds for a bounded
nonnegative, not necessarily monotone scalar profile and a smooth
convex terminal continuation, whenever the indicated derivatives and
moments exist and the impulse limits are integrable. The uniform
Ising constants below are asserted only in the manuscript's
mass-one monotone setting, not uniformly over this larger class.

This is a proof in the normalized scalar model, not an experiment or a
proof of either SK asymptotic main theorem. The algebraic core has a
separate executable certificate and Lean statement. The analytic
derivation and its translation to the manuscript require independent
mathematical review; a compiler does not certify those parts.

### Prior art actually inspected

Crisanti and De Dominicis, *Replica Fourier Transform: Properties and
Applications*, arXiv:1410.4023v1, Sections 1--2, explicitly formulate the
replica space with decreasing integer block sizes and integer branching
ratios, and describe block diagonalization of four-replica Hessians.
The inspected passage in Section 2 states:

> "an ordered sequence of \(R+2\) integer \(p_k>p_{k+1}\), with
> \(p_0=n\) and \(p_{R+1}=1\), and the requirement that
> \(p_k/p_{k+1}\) is integer"

Source: <https://arxiv.org/html/1410.4023v1>, Section 2, preceding (1).
De Dominicis, Carlucci and Temesvari,
arXiv:cond-mat/9703132v1, abstract, likewise identifies block
diagonalization of four-replica matrices as its subject:
<https://arxiv.org/abs/cond-mat/9703132v1>.

Thus the integer sector decomposition is not claimed as new. These
inspected passages do not establish the real-power normalized-law
identification or the exact energy identity below. The automated search
also returned generic claims about rigorous inverse domination from
overlap Gram matrices; no corresponding proposition was obtained, and
those claims are not used. Novelty of the strengthened energy theorem
is a question for the independent Reviewer, not a consequence of a
search failing to find a match.

## 1. Scalar identities obtained from the recursion

Write \(T=K_{R+1}\), \(m_s=V_z(s,Z_s)\), and
\(\chi_s=V_{zz}(s,Z_s)\). Conditional expectations below use the
normalized forward law, never the unweighted Gaussian law. On a
constant-mass interval \([s,t]\) the starting recursion is
\[
 V(s,z)=p^{-1}\log\mathbf E\exp\{pV(t,z+\sqrt{t-s}\,G)\},
\]
with ordinary expectation at \(p=0\). Differentiating this heat
semigroup gives the stated PDE. Its normalized positive transition is
the corresponding Doob transform; differentiating its density gives
drift \(pV_z\). Bounded spin gradients make the finite Gaussian
differentiations integrable. The PDE and Ito's rule now give
\[
 dm_s=\chi_s\,dW_s,\qquad
 d\chi_s=-\alpha(s)\chi_s^2\,ds+V_{zzz}(s,Z_s)\,dW_s.                 \tag{1}
\]
The terminal conditional spin mean is \(\tanh Z_T\).
Differentiating a normalized transition gives, for its mass \(p\),
\[
 D{\cal T}_pF=\mathbf E_p DF,\qquad
 D^2{\cal T}_pF=\mathbf E_pD^2F+
                   p\,\operatorname{Cov}_p(DF,DF).                 \tag{2}
\]
Iteration proves the conditional source-Hessian formula, without a
replica continuation. Since the remaining masses belong to \([0,1]\),
\(0\le\chi_s\le1-m_s^2\le1\).

For \(s\le y\), set
\[
 L^y(s,z)=\tfrac12\mathbf E_{s,z}m_y^2,\qquad
 \psi_y(s)=L^y_z(s,Z_s).
\]
The first profile derivative is
\[
 D_\alpha V(A,z)[\eta]
       =\int_A^T\eta(y)L^y(A,z)\,dy.                                \tag{3}
\]
Indeed its linearized PDE has generator
\(\frac12\partial_{zz}+\alpha V_z\partial_z\), zero terminal value,
and source \(\eta V_z^2/2\). This proves (3) by its diffusion
representation. Differentiating the backward equation for \(L^y\)
in its starting field gives
\[
 d\psi_y(s)=-\alpha(s)\chi_s\psi_y(s)\,ds+
                    L^y_{zz}(s,Z_s)\,dW_s,\quad
 \psi_y(y)=m_y\chi_y.                                               \tag{4}
\]
All these equations concatenate across a finite number of step
boundaries; no time derivative of the step profile is taken.

The fixed spatial derivatives used below have resolution-independent
bounds in the mass-one Ising setting. One way to see this without
estimates for a long stochastic flow is to differentiate a normalized
spin moment by a common source. Each derivative is a finite signed
spin-moment sum. Its extra slot uses the real-power product rule,
including the normalization derivative. The attachment total-variation
bound for a fixed number of slots, and a root normalization coefficient
of magnitude at most one, give a constant depending only on the number
of derivatives. Repeating this argument also bounds the derivatives of
\(L^y\) needed here. All spin factors have absolute value at most one.
In particular \(|\psi_y(s)|+|L^y_{zz}(s,Z_s)|\le C\), with no
dependence on the smallest mass or the number of steps. This argument
uses the finite-source calculus, not a bound exponential in clock
length.

## 2. A prefix Gram-energy theorem

Choose any finite deterministic list of marker times \(y_1,\ldots,y_d\)
in \([0,T]\). At a starting time \(A\), a marker before \(A\)
represents the field direction \((m_y,0)\), with \(m_y\) held fixed
during differentiation; a marker after \(A\) represents
\((0,\delta_y)\). Let \(B(A)\) be the expectation of the corresponding
joint field/profile Hessian of \(V(A,Z_A)\).

For \(y\le z\), differentiating (3) and its linearized PDE gives
\[
 B_{yz}(A)=
 \begin{cases}
 \mathbf E[m_y m_z\chi_A],&z\le A,\\
 \mathbf E[m_y\psi_z(A)],&y\le A\le z,\\
 \mathbf E[m_y\psi_z(y)]
   +\displaystyle\int_A^y\alpha(s)\mathbf E[\psi_y(s)\psi_z(s)]\,ds,
       &A\le y.
 \end{cases}                                                       \tag{5}
\]
For clarity, the mixed-profile source before taking impulses is
\[
 \eta m\,D_zD_\alpha V[\eta']
 +\eta' m\,D_zD_\alpha V[\eta]
 +\alpha D_zD_\alpha V[\eta]D_zD_\alpha V[\eta'].
\]
Concentrating the two bounded directions at distinct times gives the
third line of (5). Taking the common continuous limit gives its
diagonal value \(\mathbf E[m_y^2\chi_y]\) for the first term.
There is no product of delta distributions in this calculation.
The three cases match at \(A=y,z\), by (4).

Define a single, continuous switching response
\[
 v_y(s)=
 \begin{cases}
 \psi_y(s),&s\le y,\\
 m_y\chi_s,&s\ge y.
 \end{cases}
\]
Equations (1) and (4), with a past marker frozen, show in all
three cases of (5) that
\[
 \frac{d}{dA}B_{yz}(A)
       =-\alpha(A)\mathbf E[v_y(A)v_z(A)]\quad\hbox{a.e.}             \tag{6}
\]
In the last case this is just differentiation of the lower integration
limit. In the first two cases it is the drift in (1) or (4).
Continuity at the markers prevents any additional atom.

At \(A=T\), all markers are past and
\(B_{yz}(T)=\mathbf E[m_y m_z\chi_T]\). Consequently
\[
 \boxed{\quad
 B(A)=\mathbf E[\chi_T\,\mathbf m\mathbf m^{\mathsf T}]
       +\int_A^T\alpha(s)\mathbf E[
                         \mathbf v(s)\mathbf v(s)^{\mathsf T}]\,ds .
 \quad}                                                            \tag{7}
\]
For any real vector \(f\), its quadratic form is
\[
 f^{\mathsf T}B(A)f
 =\mathbf E[\chi_T(\sum_y f_y m_y)^2]
   +\int_A^T\alpha(s)\mathbf E[(\sum_y f_y v_y(s))^2]\,ds\ge0.        \tag{8}
\]
The same calculation between \(A\le A'\) proves
\[
 B(A)-B(A')=\int_A^{A'}\alpha(s)\mathbf E[
                         \mathbf v(s)\mathbf v(s)^{\mathsf T}]\,ds
 \succeq0.                                                         \tag{9}
\]
This proves the energy theorem for arbitrary finite dimension and
arbitrary marker coincidences, not just for a tested list of trees.
Its proof uses nonnegative \(\alpha\) and convex terminal value but
not monotonicity of \(\alpha\). For general bounded nonnegative
profiles the same identity follows by step approximation when the
regularity/integrability in the theorem statement permits passing (3)
and (5) to the limit.

For the manuscript, take the marker list \(y_t=K_t\) and starting
times \(A_k=K_{k-1}\), with \(A_0=0\). Then \(B(A_k)=B^k\) and
\[
 B^k-B^{k+1}
 =p_k\int_{K_{k-1}}^{K_k}
             \mathbf E[\mathbf v(s)\mathbf v(s)^{\mathsf T}]\,ds
 \succeq0.                                                         \tag{10}
\]
Thus the manuscript's entrywise weighted bound is part of an exact
positive-semidefinite decrement identity. This is the precise
improvement over its stated bound.

### Conditional form, the full field coordinate, and stopping prefixes

The expectation in (7) is not essential. Include a further coordinate
`*` for the unit starting-field direction and set
\(m_*=1\), \(v_*(s)=\chi_s\). Let \(H_A\) be the actual
joint Hessian evaluated at the revealed prefix, on this field
direction and the switching marker directions, before averaging that
prefix. Past marker values are still held fixed in this Hessian.
For its mixed field entries,
\[
 (H_A)_{**}=\chi_A,\qquad
 (H_A)_{*y}=
 \begin{cases}
 \psi_y(A),&A\le y,\\
 m_y\chi_A,&A\ge y.
 \end{cases}
\]
The marker-marker entries are the conditional versions of (5),
with \(\mathbf E_A\) in place of \(\mathbf E\). In particular,
before the earlier marker \(y\le z\), the entry solves the
linearized PDE with source
\(\alpha\psi_y\psi_z\) and boundary \(m_y\psi_z(y)\) at \(y\).
Ito's formula gives, on every interval between the fixed markers,
\[
 dH_s=-\alpha(s)\,\mathbf v_*(s)\mathbf v_*(s)^{\mathsf T}\,ds+dN_s,
 \qquad
 (H_T)_{ij}=\chi_T m_i m_j,                                      \tag{E1}
\]
where \(N\) is a symmetric matrix of local martingales and the
vectors now include `*`. For the field-field and field-marker
entries this is (1) and (4); for the other entries it is their
mixed linearized PDE, or (1)/(4) once a marker is past.
All boundaries match, including repeated markers, so (E1) has no
boundary atom.

Under the boundedness established above, the compensated process in
(E1) is uniformly integrable. Conditional expectation to \(T\)
therefore proves the stronger identity
\[
 \boxed{\quad
 H_A=\mathbf E_A\!\left[
   \chi_T\,\mathbf m_*\mathbf m_*^{\mathsf T}
    +\int_A^T\alpha(s)\,
          \mathbf v_*(s)\mathbf v_*(s)^{\mathsf T}\,ds\right].
 \quad}                                                         \tag{E2}
\]
It is a positive-semidefinite matrix almost surely. When all markers
are future, this is a pointwise Gram certificate for the full joint
field/profile Hessian, not just for the special averaged directions
in the manuscript. Thus it also supplies joint convexity on these
finite impulse directions without a stochastic-control
representation.

For bounded stopping times \(\sigma\le\tau\le T\), optional
sampling of the same compensated process gives
\[
 H_\sigma-\mathbf E_\sigma H_\tau
   =\mathbf E_\sigma\int_\sigma^\tau\alpha(s)
            \mathbf v_*(s)\mathbf v_*(s)^{\mathsf T}\,ds\succeq0.   \tag{E3}
\]
In the more general convex-terminal, nonnegative-profile version,
this stopping-time statement uses the same boundedness or uniform
integrability hypothesis on the compensated process. The deterministic
expected kernel is therefore Loewner decreasing, but the random
Hessian is **not** claimed to be pathwise decreasing: its martingale
part need not vanish. Nor does (E3) claim a pair inverse for arbitrary
random old-label topologies. These are distinct statements.

## 3. Pair decomposition, including marked old labels

For the combinatorics only, let \(p_i\) be decreasing integer block
sizes with terminal size one and sufficiently large branching ratios.
Normalized block sums give \(P_iP_j=P_{\min(i,j)}\); their differences
\(E_0=P_0\), \(E_i=P_i-P_{i-1}\) are orthogonal idempotents summing
to the identity. These statements concern leaf coordinates, not
Gaussian expectations at integer replica counts.

If \(E_k\epsilon=\epsilon\), the row sum on sheet \(t\) of
\(\epsilon_a+\epsilon_b\) is \(d_t^k\epsilon_a\), where
\[
 d_t^k=p_t-p_{t+1}
       +p_t{\bf1}_{k\le t}-p_{t+1}{\bf1}_{k\le t+1}.                \tag{11}
\]
For \(k\le t\), \(k=t+1\), and \(k>t+1\), respectively, this is
\(2(p_t-p_{t+1})\), \(p_t-2p_{t+1}\), and \(p_t-p_{t+1}\).
The cross terms between distinct \(E_k\)'s vanish in the unordered
pair inner product. The squared norm is
\(\sum_t d_t^k f_t^2\sum_a\epsilon_a^2\).
This proves the printed additive projection formula by taking row sums.
The remainder has row sum zero on every sheet, with the sum over all
other children together, not separately within each child.

Here is the algebraic reason this transfers to real masses. At a node
with incoming mass \(a\), child mass \(b\), and \(q\) occupied
children, \(h\) new distinct children have coefficient
\[
 b^h(a/b-q)^{\underline h}
             =\prod_{j=0}^{h-1}(a-(q+j)b).                         \tag{12}
\]
This follows by the labeled product rule for the actual positive
power, for every real positive \(a,b\). A slot assigned to an old
child is not counted again as a new child; slots in the same child
are not forced into different children. Terminal slots on an existing
leaf are retained. The one-slot rule telescopes to the occupied-edge
densities and the existing-fork atoms stated in scope. More explicitly,
for an enclosing mass \(a\), \(r\) occupied leaves, edge lengths
\(\ell_e\), and forks of mass \(u_v\) with \(d_v\) occupied children,
the endpoint telescoping identity is
\[
 \sum_e\ell_e+\sum_v(d_v-1)u_v=r-a.
\]
The signed attachment total is therefore \(a\) and its total
variation is \(2r-a\). Successive allocations have uniformly bounded
variation for any fixed number of slots. Allocation order invariance
is obtained by assigning a distinct formal derivative to each slot:
commuting these derivatives gives the same labeled partition at every
node, before any topology-dependent input is evaluated.

To transfer a counting identity, mark each entire input genealogy
with its old labels, clear the nonzero block denominators, and compare
the coefficient of each marked expression. It is a polynomial in
independent branching ratios. The integer identity holds at every
sufficiently large integer choice of these ratios; successive
one-variable polynomial identities make it identically zero. This
argument does not analytically continue a Gaussian moment. It
continues only its coefficient, and (12) identifies that coefficient
with the actual real-power rule.

After substituting increasing real masses all three denominators in
(11) are strictly negative and nonzero. The same projection and row-zero
identities therefore hold with every old-label input variable still
distinguished. This also covers a pair argument that is itself an old
label. Marginalizing unused positive-law branches changes none of the
pair or four-spin moments. Forgetting the old-label variables before
this coefficient comparison would not prove the stated quantifier.

Old forks need not already be resolution cuts. Insert their finitely
many masses as cuts, retaining the zero clock increments this can
create, and pass from separated clocks by continuity. If a pair input
depends on the exact new fork coordinates within a sheet, first use
simple functions on finite refinements of those coordinates, with
the old-fork atoms and coincidence strata kept separately. For any
fixed output tree, the finitely many relevant allocation spaces are
finite unions of mass-coordinate simplices and their atomic strata.
The preceding identities hold for these simple functions. Their
bounded approximation passes through the signed sums by the uniform
total-variation bound just proved. Thus the result applies to bounded
measurable inputs, and to integrable inputs whenever all displayed
operators are defined, not just to sheet-constant tests. No limit in
the number of scalar steps or division by a vanishing mass is hidden
in this passage.

## 4. Row-zero action directly from (A8)

Condition on the shared prefix of an input \(p_t\)-block. For leaves
in the same child put
\(C_{ac}=\mathbf E_t[\tau_a\tau_c]-m_t^2\), and put \(C_{ac}=0\)
for different children. If \(a,b\) and \(c,d\) each occupy different
children, conditional independence gives
\[
 \mathbf E_t[\tau_a\tau_b\tau_c\tau_d]
 =m_t^4+m_t^2(C_{ac}+C_{ad}+C_{bc}+C_{bd})
              +C_{ac}C_{bd}+C_{ad}C_{bc}.                         \tag{13}
\]
Every occupied child contains at most two of these four slots.
Thus (13) also includes repeated leaf slots through
\(C_{aa}=1-m_t^2\). The seven possible child-coincidence patterns
are an exhaustive local classification, independent of tree depth.
The executable checks each pattern symbolically.

The constant and one-end terms disappear against a sheetwise
row-zero input. The disconnected term of (A8) disappears too:
the input pair moment is constant on its block and sheet. If the
output pair does not lie in two children of this same input block,
the remaining moment depends on at most one input endpoint and its
row-zero sum vanishes. Thus sheets do not mix. The two orderings of
the input pair cancel the factor \(1/2\) in (A8), leaving
\(C\otimes C\).

On a child, write
\[
 L_j=\mathbf E_t m_j^2-m_t^2,\quad L_t=0,\qquad
 L_{R+1}=1-m_t^2.
\]
Then \(C=\sum_{j=t+1}^{R+1}(L_j-L_{j-1})p_jP_j\).
Its eigenvalue on child index \(i\) is
\[
 a_i=\sum_{j=i}^{R+1}p_j(L_j-L_{j-1})
                          =\mathbf E_t\chi_{i-1},                 \tag{14}
\]
where the last equality is (2) iterated conditionally. Applying (14)
at both ends and averaging the common prefix proves exactly
\[
 g_t^{il}=\mathbf E[
             (\mathbf E_t\chi_{i-1})(\mathbf E_t\chi_{l-1})].
\]
The child row sum of \(C\) is constant, so its tensor action preserves
the aggregate row-zero condition. The real-power coefficient rule
retains all the cancellations just used with arbitrary marked inputs.

## 5. Additive response and the sign in (H2)

The kernel preserves sheet-additive arrays on each \(E_k\). Indeed
tree invariance reduces its one-leaf sums to nested block projections;
on an \(E_k\) range each such projection is zero or the identity.
Symmetry of the output pair gives a multiple of
\(\epsilon_a+\epsilon_b\). It is therefore enough to identify the
quadratic form in the sheet coefficients.

Choose a balanced plus/minus coloring at depth \(k\), for \(k>0\);
for \(k=0\) choose the constant plus coloring. For integer counting
normalize \(\sum_a\epsilon_a^2=p_0\). For real powers the colored
fork is a product of two child integrals, each to power
\(p_{k-1}/(2p_k)\). Set
\[
 h_j(K_j-K_{j-1})=f_j-f_{j-1},\quad f_{-1}=0,\qquad
 G_j=\sum_{s\le j}h_s^2(K_s-K_{s-1}),\quad s_t=p_{t+1}-p_t.
\]
Multiplying a leaf's Gaussian increments by
\(1+\theta\epsilon h_j\) gives first pair covariance variation
\((\epsilon_a+\epsilon_b)f_t\) and quadratic coefficient
\(\epsilon_a\epsilon_bG_t\). The covariance Hessian of the normalized
root log partition is its spin covariance, including its disconnected
product. Its contraction, after subtracting covariance acceleration,
is
\(\sum_t d_t^k f_t({\bf M}^kf)_t\).
The diagonal spin squares have zero covariance and do not enter this
Hessian. The acceleration itself is
\[
 G_{R+1}-\sum_{t\ge k}s_tG_t\mathbf E m_t^2
                 -p_kG_{k-1}\mathbf E m_{k-1}^2,                  \tag{15}
\]
with the last term absent when \(k=0\).

This identification is valid at real powers directly: differentiating
the colored child integrals by the labeled product rule gives (12)
for two hits, including two hits on one child. Differentiating the
root logarithm produces the product of separately averaged pair
moments in (A8), not a second four-spin moment. The two pair sums are
concatenated before allocation, and each factor is evaluated on its
own restriction. The normalization derivative is essential here.

Here is a full local calculation of the remaining scalar curvature.
Put
\[
 A=K_{k-1},\quad F=f_{k-1},\quad p=p_k,\quad
 u=m_A,\quad c=\chi_A,\quad
 \eta=2\sum_{t\ge k}s_tf_t\delta_{K_t},\quad
 J=D_\alpha V(A)[\eta].
\]
Let \({\cal Z}\) be the weighted sum of the pre-fork Gaussian
increments. For \(k=0\), put \(A=F={\cal Z}=0\).
The opposite first variations cancel pointwise at a colored fork.
Its second root variation is therefore
\[
 \mathbf E[\ddot V+2{\cal Z}\dot V_z+{\cal Z}^2c].                  \tag{16}
\]
Moving all step times to \(K_t+2\theta f_t+\theta^2G_t\) gives
\[
 \begin{split}
 \dot V&=f_{R+1}-F(c+pu^2)-J,\\
 \ddot V&=G_{R+1}-G_{k-1}(c+pu^2)
    -\sum_{t\ge k}s_tG_t\mathbf E_A m_t^2
    -2\sum_{t\ge k}s_tf_t^2\mathbf E_A\chi_t^2\\
 &\quad+4F^2V_{AA}-4FJ_A+D_{\alpha\alpha}^2V[\eta,\eta].
 \end{split}                                                       \tag{17}
\]
For example, moving a mass jump right by a displacement decreases its
profile by that jump times the displacement; (3) gives its first
variation. Differentiating the marker time gives
\(\partial_t\mathbf E_A m_t^2=\mathbf E_A\chi_t^2\), from (1),
which accounts for the coefficient \(-2\) in the second line.
The terminal mass-one extension contributes only the printed
spatial constant. Bounded impulses can first be spread over short
intervals; (5) makes their coincident-time limits continuous.

It remains to integrate (16) under the *normalized* prefix law. Its
telescoping density, apart from a constant, is
\[
 \exp\{pV(A,Z_A)-\sum_{t<k}s_tV(K_t,Z_{K_t})\}.
\]
The weighted Gaussian directional derivative sends \(Z_{K_t}\) to
\(f_t\). Define
\[
 S=\sum_{t<k}s_tf_tm_t,\quad
 Q_{\rm past}=\sum_{t<k}s_tf_t^2\chi_t,\quad
 H=pFu-S,\quad N'=pF^2c-Q_{\rm past}.
\]
Gaussian integration by parts differentiates this density as well as
an endpoint test \(Y\):
\[
 \begin{split}
 \mathbf E[{\cal Z}Y]&=\mathbf E[FY_z+HY],\\
 \mathbf E[({\cal Z}^2-G_{k-1})Y]
  &=\mathbf E[F^2Y_{zz}+2FHY_z+(H^2+N')Y].
 \end{split}                                                       \tag{18}
\]
The starting-time PDE also gives
\[
 4V_{AA}=c_{zz}+2pc^2+4pu c_z+4p^2u^2c,\qquad
 -4J_A=2J_{zz}+4puJ_z.                                            \tag{19}
\]

Substitute (17)--(19) into (16), subtract (15), and cancel.
The entire delicate prefix cancellation is the following universal
polynomial identity (the script and Lean check it with all variables
independent):
\[
 \begin{split}
 &F^2(c_{zz}+2pc^2+4pu c_z+4p^2u^2c)
       +2FJ_{zz}+4pFuJ_z\\
 &+2F\{-F(c_{zz}+2pc^2+2pu c_z)-J_{zz}\}
       +2H\{-F(c_z+2pu c)-J_z\}\\
 &+F^2c_{zz}+2FHc_z+(H^2+pF^2c-Q_{\rm past})c\\
 &\hspace{12pt}=-pF^2c^2-Q_{\rm past}c
                    +(pFu+S)^2c+2(pFu+S)J_z .
 \end{split}                                                       \tag{20}
\]
Thus the residual quadratic form is
\[
 -pF^2\mathbf Ec^2-\sum_{t<k}s_tf_t^2\mathbf E[\chi_t c]
 -2\sum_{t\ge k}s_tf_t^2\mathbf E\chi_t^2
 +\mathbf E D^2_{z,\alpha}V(A)[\xi,\xi],
\quad
 \xi=(pFu+S,\eta).                                                 \tag{21}
\]
For \(t<k\),
\(\mu_t^k=s_t+p_k{\bf1}_{t=k-1}\); for \(t\ge k\),
\(\mu_t^k=2s_t\). Therefore
\[
 \xi=\sum_t\mu_t^kf_t\beta_t,\qquad
 \text{(21)}=-\sum_t\mu_t^kg_t^kf_t^2+
                    \sum_{r,t}\mu_r^k\mu_t^kB_{rt}^kf_rf_t .
\]
Since \(d_t^k=-\mu_t^k\), comparison with the covariance
contraction and polarization gives, with the correct minus sign,
\[
 ({\bf M}^kf)_r=g_r^kf_r-\sum_t B_{rt}^k\mu_t^kf_t,\qquad
 g_t^k=\mathbf E[\chi_t\chi_{\max(k-1,t)}].                         \tag{22}
\]
All \(\mu_t^k\) are positive for increasing masses, so recovering
the matrix from its weighted quadratic form loses no row. For
\(k=0\), there are no prefix terms, and the same calculation with
\(\mu_t^0=2s_t\) applies. For \(k=R+1\), all markers are
past and the future-profile terms are absent. These endpoint sectors
are not omitted.

## 6. Every estimate required by the lemma

Equation (10) and the uniform bound on \(v\) give
\[
 \|B^{k+1}-B^k\|_\infty\le C p_k(K_k-K_{k-1}).                     \tag{23}
\]
For \(g_t(A)=\mathbf E[\chi_t\chi_{\max(A,K_t)}]\), its
derivative vanishes before \(K_t\) and equals
\(-\alpha(A)\mathbf E[\chi_t\chi_A^2]\) afterwards.
It is continuous at the marker. Hence
\[
 0\le g_t^k-g_t^{k+1}\le p_k(K_k-K_{k-1}),\qquad
 0\le g_t^k\le\mathbf E\chi_t^2.                                  \tag{24}
\]
The upper bound follows by conditioning (1) on the earlier prefix
and multiplying by its nonnegative susceptibility.

For a row-zero multiplier let \(a_i=\mathbf E_r\chi_{i-1}\).
The same drift gives
\[
 a_i-a_{i+1}
  =p_i\int_{K_{i-1}}^{K_i}\mathbf E_r\chi_s^2\,ds,\qquad
 0\le a_i\le\chi_r.                                                \tag{25}
\]
It follows that \(0\le g_r^{il}\le\mathbf E\chi_r^2\), each
successive difference is at most \(p_i\Delta K_i\), and the mixed
difference is bounded by
\(p_i p_l\Delta K_i\Delta K_l\). The mixed formula is exactly
the expectation of the product of the two differences in (25),
also when \(i=l\); no independence of those differences is assumed.

For the inverse's child multiplier, interpolate the two factors in
\(\mathbf E[a_i a_l]\) separately. If the resulting bilinear
function is \(g=g_{00}+xg_{10}+yg_{01}+xyg_{11}\), then
\[
 \partial_{xy}(1-bg)^{-1}
 =\frac{b\,\partial_{xy}g}{(1-bg)^2}
       +\frac{2b^2\,\partial_xg\,\partial_yg}{(1-bg)^3}.             \tag{26}
\]
The interpolation is a convex combination of the four endpoint
kernels, all at most \(\mathbf E\chi_r^2\). Thus the strict gap
controls (26), and integrating it gives the required product bound
with both mass factors. Single differences use the first derivative.

The evaluation-time Lipschitz bounds follow directly from (1),
(4), and (5). When the later marker varies,
\(\partial_yL^y(s)=\mathbf E_s\chi_y^2/2\). When the earlier
marker varies, Ito's product rule applies to \(m_y\psi_z(y)\);
the drift is
\(-\alpha\chi_y m_y\psi_z(y)+\chi_yL^z_{zz}(y,Z_y)\).
All terms are bounded by the fixed-source bounds in Section 1.
The integral in (5) has length at most \(T\). The three expressions
match when markers meet or cross \(A\), so the bounds are global
with polynomial constants in \(1+T\), not constants multiplied by
the number of steps. The same product rule treats the susceptibilities
in \(g^k\). Formula (7) also bounds \(B\) by \(C(1+T)\).

Finally suppose \(A=0\), \(Z_0=0\), and \(y\le z\).
Field parity makes both \(m_y\) and \(\psi_z(y)\) odd functions
of \(Z_y\), vanishing at zero. Their derivatives are bounded, so
\[
 |\mathbf E[m_y\psi_z(y)]|\le C\mathbf E Z_y^2
                           \le C(y+y^2).
\]
The last bound uses bounded drift and Brownian variance \(y\).
The integral in (5) is at most \(Cy\). Hence
\[
 |B^0_{rt}|\le C(1+T)K_{\min(r,t)},                               \tag{27}
\]
which implies the stated small-earlier-time estimate.

Restricting to retained sheets just removes input and output
coordinates in these identities. The bounds and Gram positivity
survive restriction. No inverse estimate is obtained by taking
absolute values before these cancellations. The subsequent
resolution-independent inverse construction and the SK size
comparison have not been independently certified here.

## 7. Exact and formal evidence boundaries

`verify.py` checks the universal polynomial cancellation (20), the
local real-power induction step (12), all seven exhaustive local
child patterns in (13), the three row-mass cases, both one-sheet
additive sectors including the disconnected term, and the reciprocal
mixed derivative (26). These are identities over rational function
fields, not floating-point comparisons. The one-sheet formulas use
actual scalar moments \(q=\mathbf E m^2\), \(r=\mathbf E m^4\);
they are a sign check, not a license to choose inadmissible moments
for a counterexample.

The installed Jacobian 0.14.0 adapter was inspected before custom
algebra. One bounded `matrix.symbolic.multiply.compute` operation
checks the Hessian contraction
\((pFu+S)\{c(pFu+S)+2J_z\}+Q\) exactly. Its request, typed
answer, protocol, server version, and runtime are preserved in
`jacobian_payload.json`, `jacobian_result.json`, and the corresponding
contract/status JSON files. The modular-polynomial operation was
not used as evidence for an identity over the reals.

`Main.lean` formalizes the universal algebraic identities and finite
weighted-square positivity in arbitrary finite dimension.
`statement_fidelity.md` explicitly excludes the PDE, stochastic
calculus, source-law admissibility, and old-tree coefficient transfer
from what the compiler proves. `exact_certificate.json` has the same
separation. None of these artifacts asserts an independent Reviewer
verdict or that either manuscript's main theorem has been proved.

The official Lean 4.31.0 run completed with exit code zero and
`proof_holes=[]`; its certificate is attached to `C_PAIR_ALGEBRA` in
the existing claim ledger. The original source and fidelity document
have not been edited since that run. Replay the persistent exact
certificate with:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/pair_response/verify.py
```

The replay needs Python 3 and SymPy, reads the saved typed Jacobian
answer and official Lean result, and makes no service calls or random
draws. It checks the source/fidelity hashes required by the official
compiler record. It does not convert an analytical argument awaiting
review into mechanical evidence.
