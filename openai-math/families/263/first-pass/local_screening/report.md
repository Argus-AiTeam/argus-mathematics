# Conditional local screening for correlated Coulomb states

## Result and limits of the certificate

This note gives an analytic verification of the four estimates labeled
`m:lem:screen-positive-field`, `m:lem:screen-patch`,
`m:lem:screen-count`, and `m:lem:screen-density` in the staged foundation
manuscript, including the source-free improvement of the patch estimate.
The proof below uses the actual conditional core, not a replacement
posterior or a Hartree--Fock state. It retains arbitrary finite particle
number, arbitrary nonnegative energy offset, and both prescribed scale
geometries. No false assertion in those four statements has been established.

The result is an **analytic verification theorem with exact algebraic
checks**, not a computer-checked proof of the analytic theorem.
`verify.py` checks the algebra, exponents, normalizations, coefficient
matching, recursion identities, and retained Jacobian output described
in `exact_certificate.json`. It does not check the functional analysis,
conditional disintegration, or variational inequalities. Those are proved
here and require independent mathematical review. There is no Lean
formalization, kernel verdict, novelty verdict, or independent acceptance
in this Engineer submission.

This is not a proof of the molecular excess-charge theorem, either
generalized ionization conjecture, observation transfer, or outward
propagation. Those deductions have additional obligations, recorded as
open nodes in `research/PROOF_GRAPH.json`. The inherited state contained
no proof of this shared dependency. Compared with the published
Hartree--Fock baseline, the important mathematical scope here is the
quantification over correlated finite-sector states; priority beyond the
staged manuscript is not claimed.

## 1. Exact setting and statements

Let
\[
 K(x)=|x|^{-1},\quad
 \nu=\sum_{m=1}^M z_m\delta_{R_m},\quad V=K*\nu,\quad
 Z=\sum_m z_m ,
\]
where \(M\) is finite, the \(R_m\) are distinct, and the real numbers
\(z_m\) are at least one. With two spin states, put
\[
 q_n[\psi]=\frac12\sum_i\|\nabla_i\psi\|_2^2
 -\mathbb E_\psi\sum_i V(x_i)
 +\mathbb E_\psi\sum_{i<j}K(x_i-x_j),\qquad
 E=\inf_{n\geq0}\inf_{\|\psi\|_2=1}q_n[\psi].
\]
The infimum is over the antisymmetric \(H^1\) form domain; the vacuum
has energy zero. A delta-state is any such normalized vector, in any
finite sector, with \(q_n[\psi]\leq E+\delta\), \(\delta\geq0\).
In particular, no eigenstate equation or bound \(n\leq3Z\) is used below.

We use exactly one of the following geometries in an application:

* Nuclear geometry: \(L=10^6\), all \(y\in\mathbb R^3\), and
  \(a_y=\sup\{s>0:\nu(B(y,Ls))\leq s^{-3}\}\).
* Atomic distance geometry: \(L=10^5\), \(\nu=Z\delta_0\),
  \(y\ne0\), and \(a_y=|y|/L\).

All balls are open. Set
\[
 B_y=B(y,a_y),\quad n_y=\#\{i:x_i\in B_y\},\quad
 m_{0,y}=\max(a_y^{-3},1),\quad
 m_y=m_{0,y}+\sqrt{\delta a_y},\quad e_y=m_y^2/a_y,
\]
\[
 P=\max\left(1,\sup_y\frac{\mathbb E n_y^2}{m_y^2}\right),\qquad
 J_y=\int_{|v-y|\geq40a_y}\frac{d\nu(v)}{|v-y|}
       -\sum_{|x_i-y|\geq40a_y}\frac1{|x_i-y|}.
\]
Initially only \(1\leq P\leq\max(1,n^2)<\infty\) is known.

Write
\[
 c_T=\frac3{10}(3\pi^2)^{2/3},\quad
 k=(5c_T/3)^{-3/2},\quad c_F=4\pi k,\quad
 D(f)=\frac12\iint f(x)K(x-z)f(z)\,dx\,dz .
\]
Signed compactly supported \(L^{5/3}\) functions are allowed in \(D\).

**A. Conditional positive fields.** Fix \(C_0\geq1\). The initial
deterministic cuts may be absent. Otherwise their out support has a cover
by at most \(C_0\) cells \(B_z\), and
\[
 \sum_h(|\nabla s_h|^2+|\nabla c_h|^2)
 \leq\sum_z D_z^2a_z^{-2}\mathbf1_{B_z},\qquad
 D_z^2/(a_zm_z)\leq C_0\sqrt P .
\]
Let \(X\) be their prescribed out data, as defined in Section 3, and
\(e_*=\max(e_y,\max_z e_z)\). Then
\[
 \|(\mathbb E[J_y\mid X])_+\|_2
 \leq C(C_0)\sqrt{P e_*/a_y}.                                      \tag{A}
\]
There is no comparability requirement between initial covering scales
and the target scale.

**B. Interior patch.** Write \(a=a_y,m=m_y,e=e_y\).
If \(0<\beta<1/100\), \(b=\beta a\), and
\(\beta^{-2}/(am)\leq\sqrt P\), a deterministic \(t_0\in[5a,6a]\)
can be selected so that the cut is full out on \(B(y,t_0)\), supported
in \(B(y,t_0+b)\), and has gradients at most \(C/b\).
Its actual core field is \(\Phi_X=V-K*\rho_X^c\).
There is a unique measurable nonnegative minimizer, extended by zero
outside \(\Omega=B(y,t_0-4b)\), of
\[
 \mathcal T_X(f)=c_T\int f^{5/3}-\int\Phi_X f+D(f).
\]
Put \(W=\Phi_X-K*\rho\). Then \(\rho=kW_+^{3/2}\) in \(\Omega\).
Use the radial kernel
\[
 \vartheta_b(x)=\int_{\mathrm{SO}(3)}
 b^{-6}\prod_{j=1}^3(b-|(Qx)_j|)_+\,dQ
\]
with probability Haar measure. Define \(\sigma\) by smearing exactly
the out particles at \(|x_i-y|<t_0-7b\) with \(\vartheta_b\), and set
\[
 \mathcal L=c_T\int\left[
 \sigma^{5/3}-\rho^{5/3}-\frac53\rho^{2/3}(\sigma-\rho)\right].
\]
For every sufficiently small universal \(\epsilon>0\),
\[
 \begin{split}
 \mathbb E\left[D(\sigma-\rho)+\mathcal L+\int W_-\sigma\right]
 \leq C\big[&
 \delta+(\epsilon+\sqrt\beta)Pe
 +\epsilon^{-3/2}\beta^{1/2}a^{-7}\\
 &+b^{-1}\sqrt Pm
 +b^{-2}(P^{2/3}m^{4/3}+\sqrt Pm)\big].                         \tag{B1}
 \end{split}
\]
Also
\[
 \mathbb E\int\sigma^{5/3}\leq CPe+C\{\hbox{right side of (B1)}\},
 \qquad T_o\leq C(Pe+b^{-2}\sqrt Pm),                            \tag{B2}
\]
where \(T_o\) is the out kinetic energy, and, pathwise,
\[
 W\leq V_{\rm loc}+Ca^{-4}\text{ on }B(y,3a),\qquad
 \int_{B(y,2a)}\rho\leq Ca^{-3}.                                \tag{B3}
\]
Here \(V_{\rm loc}\) is the potential of nuclei in \(B(y,20a)\).
If this local measure is zero, (B1) sharpens to
\[
 \mathbb E\left[D(\sigma-\rho)+\mathcal L+\int W_-\sigma\right]
 \leq C\big[\delta+\sqrt\beta Pe+b^{-1}\sqrt Pm
             +b^{-2}(P^{2/3}m^{4/3}+\sqrt Pm)\big],             \tag{B4}
\]
and \(W\leq Ca^{-4},\rho\leq Ca^{-6}\) on \(B(y,3a)\).
This case always applies in the atomic distance geometry.

**C. Counts.** Uniformly for every target and every delta-state,
\[
 \mathbb E n_y^2\leq C\left(\max(a_y^{-6},1)+\delta a_y\right).
                                                                    \tag{C}
\]
In particular \(P\leq C\).

**D. Fine and raw density.** There is a universal \(a_0>0\).
For \(a=a_y<a_0\), \(\delta\leq a^{-7+1/50}\), and \(b=a^{6/5}\),
the patch just specified satisfies
\[
 \mathbb E\left[D(\sigma-\rho)+\mathcal L+\int W_-\sigma\right]
 \leq Ca^{-7+1/50},\qquad \mathbb E\int\sigma^{5/3}\leq Ca^{-7},       \tag{D1}
\]
\[
 \int_{B(y,4a)}\rho_\psi^{5/3}\leq Ca^{-7}.                           \tag{D2}
\]
The last density is the raw spin-summed quantum density.
All constants in B--D are independent of particle number, offset,
nuclear charges, and nuclear positions.

## 2. Scope baselines and what is not assumed

Three primary sources were opened before resolving the proof:

1. Solovej, *The ionization conjecture in Hartree-Fock theory*,
   Annals 158 (2003), 509--576, DOI
   `10.4007/annals.2003.158.509`, publisher Abstract:
   https://annals.math.princeton.edu/2003/158-2/p04 .
   Its boundedness results are explicitly Hartree--Fock results.
   The passage read is retained in `source_sol03.txt`.
2. Solovej, *A New Look at Thomas-Fermi Theory*,
   `arxiv:1601.00497v1`, Section 3, equations (1)--(2):
   https://arxiv.org/html/1601.00497v1 .
   These are the full-model iterated large-\(Z\), then large-\(m\),
   conjectures. The immediately following discussion distinguishes the
   full many-body problem from Hartree--Fock. The equations and passage
   are retained in `source_sol16.txt`.
3. Hundertmark--Pattakos--Schulz, *On the Excess Charge Problem of Atoms*,
   `arxiv:2504.18487v1`, Section 1 and Proposition 2.5 / (2.9):
   https://arxiv.org/html/2504.18487v1 .
   In particular \(N_c(Z)<1.1185Z+4Z^{1/3}\) for \(Z\geq4\);
   this is not a uniform excess bound. See `source_hps25.txt`.

These are scope/provenance assumptions of `C_SCREEN_KNOWN_SCOPE`,
not premises used to prove A--D. They were read by the Engineer;
independent citation attribution is still owed at handoff. Merely
resolving their identifiers, or the Engineer agreeing with its own
citations, would not discharge that obligation.

The inherited Wiki index had no screening/ionization/Thomas--Fermi
entry. A targeted content search found only unrelated word matches.
A targeted filename search found no campaign reviewed-facts index.
Thus no reusable reviewed screening result was obtained from those
local resources. This is a bounded retrieval result, not a novelty search.

The bulk-asymptotics-only route has been retired in the claim ledger,
with its reason. Knowing \(A_Z=-cZ^{7/3}+o(Z^{7/3})\) and
\(B_Z=-cZ^{7/3}+o(Z^{7/3})\) places no order-one bound on \(A_Z-B_Z\):
one may add an arbitrary \(o(Z^{7/3})\) difference. Likewise bulk-density
convergence need not control a vanishing fraction of mass in the tail.
Solovej's Section 2 makes precisely this scale distinction. This failed
route is not an error attributed to the staged manuscripts.

## 3. Analytic preliminaries and the prescribed conditional law

### 3.1 Finiteness of the all-sector energy

Here is an elementary bound sufficient to avoid assuming a minimizing
sector. First consider one nucleus of charge \(Z\) at \(R\).
At each configuration order \(r_i=|x_i-R|\) increasingly. Since
\(|x_i-x_j|\leq2r_j\) for \(i<j\),
\[
 -Z\sum_j r_j^{-1}+\sum_{i<j}K(x_i-x_j)
 \geq\sum_j\big((j-1)/2-Z\big)r_j^{-1}
 \geq-Z\sum_{j\leq \min(n,K_0)}r_j^{-1},
\]
where \(K_0=\lceil2Z\rceil\).
Pointwise Cauchy--Schwarz and the three-dimensional Hardy inequality
give, with \(T=\frac12\sum_i\|\nabla_i\psi\|_2^2\),
\[
 \mathbb E\sum_{j\leq\min(n,K_0)}r_j^{-1}
 \leq\sqrt{K_0}\left(\mathbb E\sum_i|x_i-R|^{-2}\right)^{1/2}
 \leq\sqrt{8K_0T}.
\]
Thus \(q_n\geq T-Z\sqrt{8K_0T}\geq-2K_0Z^2\), independently of \(n\).
Hardy's inequality follows, for smooth compactly supported \(u\),
by integrating \(\operatorname{div}(x/|x|^2)=|x|^{-2}\) against
\(|u|^2\), applying Cauchy--Schwarz, and then using \(H^1\) density.

For the molecular potential, write its form as the average, with
weights \(z_m/Z\), of the same form with a single charge \(Z\) at \(R_m\).
The kinetic and pair terms have total weight one. The bound just proved
therefore applies unchanged. Consequently \(-\infty<E\leq0\).
This is only a coarse finiteness bound, not an ionization theorem.
The same Hardy argument makes all absolute Coulomb forms finite on
each fixed finite-sector \(H^1\) domain.

### 3.2 Geometry and normalization

In the nuclear geometry the admissible radii form a downward closed
nonempty bounded interval. It includes \(Z^{-1/3}\); finiteness follows
by eventually enclosing all nuclei. Increasing open balls show that
the supremum is admissible. If \(s=a_x-|x-y|/L>0\), then
\(B(y,Ls)\subset B(x,La_x)\), and \(s\) is admissible at \(y\).
Interchanging \(x,y\) proves
\[
 |a_x-a_y|\leq|x-y|/L,\qquad
 \nu(B(y,La_y))\leq a_y^{-3}.
                                                                    \tag{3.1}
\]
In the atomic geometry the Lipschitz bound is immediate and the
open ball \(B(y,La_y)\) contains no nucleus.

For any of the fixed radii used below (at most a fixed multiple of
\(100a_y\)), (3.1) makes all nearby scales comparable to \(a_y\).
A finite mesh therefore covers such a ball by a fixed number of
cells of comparable scales. In the atomic case these balls remain
in \(y\ne0\), since \(L=10^5\). No lower bound on atomic \(a_y\) is used.

For every \(a>0\), with \(m_0=\max(a^{-3},1)\) and
\(m=m_0+\sqrt{\delta a}\),
\[
 m\geq1,\quad am\geq1,\quad am^{2/3}\geq1,\quad am_0^{1/3}\geq1,
 \quad
 \max(a^{-7},a^{-1},\delta)\leq e
 \leq4\max(a^{-7},a^{-1},\delta).                               \tag{3.2}
\]
These follow by splitting \(a\leq1\) and \(a\geq1\), and using
\(u^2+v^2\leq(u+v)^2\leq2(u^2+v^2)\).
In particular \(\delta\leq e_y\), and comparable \(a\)'s give
comparable \(m\)'s and \(e\)'s, uniformly in \(\delta\).

### 3.3 Coulomb facts

For compact signed \(f\in L^{5/3}\), the local kernel belongs to
\(L^{5/2}\); Holder's inequality gives continuity and local boundedness
of \(K*f\), and compact support gives \(O(1/|x|)\) decay at infinity.
For smooth approximations, integration by parts in
\(-\Delta(K*f)=4\pi f\) yields
\[
 \|\nabla(K*f)\|_2^2=8\pi D(f),\qquad
 \left|\int f\chi\right|
 \leq C\sqrt{D(f)}\|\nabla\chi\|_2\quad(\chi\in C_c^\infty).       \tag{3.3}
\]
The Coulomb bilinear form is continuous on \(L^{5/3}\) functions in
a fixed compact set: local Holder bounds control the potential and
the \(L^1\) norm is controlled there. Applying the smooth identity
to differences proves convergence of the potential gradients and
extends (3.3). This also proves positivity of \(D\) and its weak lower
semicontinuity as a continuous convex quadratic form.

The angular mean of \(K\) on a sphere of radius \(r\), evaluated at
distance \(d\), is \(1/\max(r,d)\); this follows by direct angular
integration. Hence convolution with a radial nonnegative probability
decreases \(K\), with equality outside its support. The difference
of two independent radial displacements is radial. Consequently
smearing a positive density decreases its direct energy, and smearing
distinct points decreases each pair interaction.

For a local nuclear mass \(Q\) and a ball of radius comparable to \(a\),
weighted convexity and integration of \(|x-R|^{-s}\) give, for
\(s=3/2,5/2\),
\[
 \int_B V_Q^s\leq C Q^s a^{3-s}.                                \tag{3.4}
\]
Indeed \((\sum z_j u_j)^s\leq Q^{s-1}\sum z_j u_j^s\), and the
integral of \(|x-R|^{-s}\) over any such ball is at most \(Ca^{3-s}\).
In particular \(Q\leq a^{-3}\) gives \(\int_B V_Q^{5/2}\leq Ca^{-7}\).

### 3.4 Occupation and the coarse kinetic inequality

For an antisymmetric \(r\)-particle vector \(u\), the occupation
operator of a unit spin orbital is a projection. Thus its one-body
matrix is at most \(\|u\|_2^2\) times the identity. Integrating auxiliary
variables and summing vectors whose squared norms sum to one preserves
this bound.

If \(0\leq\gamma\leq1\) has finite trace, use an eigen-expansion of
\(\gamma\). The Fourier projection \(P_s\) onto \(|p|^2/2\leq s\)
has diagonal bounded by \(Cs^{3/2}\), including the two spins.
The triangle inequality in the weighted orbital/spin Hilbert space gives
\[
 \sum_{\alpha,\sigma}\lambda_\alpha
 |((1-P_s)u_\alpha)(x,\sigma)|^2
 \geq(\sqrt{\rho_\gamma(x)}-Cs^{3/4})_+^2 .
\]
Integrate in \(s>0\) and \(x\). The left side is
\(\operatorname{Tr}(-\Delta/2)\gamma\) by the layer-cake formula and
Plancherel; substituting \(s=\rho_\gamma^{2/3}t\) on the right gives
\[
 \operatorname{Tr}(-\Delta/2)\gamma\geq c\int\rho_\gamma^{5/3}.     \tag{3.5}
\]
Truncation handles an infinite kinetic trace. No sharp constant is
asserted in (3.5).

### 3.5 Cuts, slices, and the exact identity

Take a finite deterministic list of nonnegative Lipschitz pairs
\((s_h,c_h)\), \(s_h^2+c_h^2=1\), and put
\[
 p_h=s_h\prod_{\ell<h}c_\ell,\quad c=\prod_hc_h,\quad
 o=(\sum_h p_h^2)^{1/2}.
\]
Then \(o^2+c^2=1\). For each subset \(I\) of particle labels let
\(\psi_I=\prod_{i\in I}o(x_i)\prod_{i\notin I}c(x_i)\psi\).
Their squared norms sum to one. In the squared law of this family,
record \(I\) and all out positions and spins \(u\). Decorate each
out coordinate with \(h\) with probabilities \(p_h^2/o^2\).
These are exactly the manuscript data \(X\).

For \(\kappa_I(u)=\int|\psi_I(u,\xi)|^2\,d\xi>0\), the core vector is
\(\chi_X(\xi)=\psi_I(u,\xi)/\sqrt{\kappa_I(u)}\).
Its phase is retained. The decoration depends only on \(u\), so it
does not change this slice. Fubini makes it a normalized \(H^1\)
vector almost surely, antisymmetric in its core variables.
Define \(e_X=q_{n-|I|}[\chi_X]\) and its density \(\rho_X^c\);
use \(e_X=\rho_X^c=0\) for a vacuum slice.
All finite-system integrals below are absolutely finite by the form
bounds and the finite partition.

The product gradient expansion, with cancellation of
\(o\nabla o+c\nabla c=0\), gives
\[
 q_n[\psi]+\mathrm{IMS}
 =\mathbb E e_X+T_o-\mathbb E\sum_{i\ {\rm out}}\Phi_X(x_i)
              +\mathbb E\sum_{i<j\ {\rm out}}K(x_i-x_j),          \tag{3.6}
\]
\[
 T_o=\frac12\sum_I\sum_{i\in I}\|\nabla_i\psi_I\|_2^2,\qquad
 0\leq\mathrm{IMS}\leq
 \frac12\mathbb E_\psi\sum_i\sum_h
 (|\nabla s_h|^2+|\nabla c_h|^2)(x_i).                           \tag{3.7}
\]
For the error bound, differentiate the first-out factors successively:
\[
 \sum_h|\nabla p_h|^2+|\nabla c|^2
 =\sum_h\left(\prod_{\ell<h}c_\ell^2\right)
 (|\nabla s_h|^2+|\nabla c_h|^2),\qquad
 |\nabla o|^2\leq\sum_h|\nabla p_h|^2 .
\]
In (3.6), the core--out repulsion is exactly the conditional
integral against \(\rho_X^c\), which explains \(\Phi_X\).
The out one-body matrix is at most one by the occupation argument.
Its density is \(o^2\rho_\psi\), and its kinetic trace is \(T_o\).
Therefore
\[
 T_o\geq c\int(o^2\rho_\psi)^{5/3}.                              \tag{3.8}
\]

There is one joint law for every finite appended list: first sample
the raw configuration, then independently assign each coordinate its
first-out stage or final core with probabilities \(p_h^2,c^2\).
Appending a cut splits only the old core label. Forgetting the new
out coordinates and their labels recovers the old observation.
In particular \(\sigma(X_{\rm old})\subset\sigma(X_{\rm new})\),
and for the **same raw variable** \(J_y\),
\[
 \|(\mathbb E[J_y\mid X_{\rm old}])_+\|_2
 \leq\|(\mathbb E[J_y\mid X_{\rm new}])_+\|_2.                    \tag{3.9}
\]
This follows from the tower property and conditional Jensen.
It does not identify two different conditional core densities.
All kernels used in disintegration are Borel on standard Borel
spaces. Ratios on nonzero slices give measurable versions; harmonic
fields admit continuous versions on source-free balls. Suprema of
those fields can be taken over a countable dense set.

## 4. The two sharp quantum comparisons

### 4.1 Upper trials, including data-dependent densities

Fix one admissible core slice and a nonnegative compactly supported
\(f\in L^{5/3}\), whose packet support is separated from the allowed
core region. Let \(g\) be a fixed real smooth radial unit \(L^2\)
function in the unit ball, \(g_b(x)=b^{-3/2}g(x/b)\). Integrate the
projectors of
\[
 g_b(x-z)e^{ip\cdot x}\mathbf1_{\tau=\sigma}
\]
over the two spins and \(|p|\leq(3\pi^2 f(z))^{1/3}\), with measure
\(dz\,dp/(2\pi)^3\). The unrestricted resolution is the identity
by Plancherel, so \(0\leq\gamma\leq1\), and direct momentum integration
gives
\[
 \operatorname{Tr}\gamma=\int f,\quad \rho_\gamma=g_b^2*f,\quad
 \operatorname{Tr}(-\Delta/2)\gamma
 =c_T\int f^{5/3}+\tfrac12\|\nabla g\|_2^2b^{-2}\int f.          \tag{4.1}
\]
Positive-eigenvalue orbitals have finite kinetic energy and are
supported in the packet region.

Truncate to finitely many eigenvectors and independently occupy each
with its eigenvalue as Bernoulli parameter. Each outcome is a finite
Slater determinant, possibly vacuum. Its mean pair energy is direct
minus nonnegative exchange, at most the direct energy. Wedge it with
the correlated core. Separation of supports makes the normalized
wedge energy equal to the sum of group energies plus direct
core--trial repulsion; no independence inside the core is required.
Every realization has a finite particle number and energy at least
\(E\). Average and then remove the eigen-truncation. Truncated
densities increase to the bounded compact density \(g_b^2*f\);
kinetic traces and direct energies converge, and all nuclear and
core cross terms converge. Radial smearing decreases \(D\).
Consequently
\[
 E\leq e_X+c_T\int f^{5/3}+Cb^{-2}\int f
                 -\int\Phi_X(g_b^2*f)+D(f).                    \tag{4.2}
\]
The vacuum gives \(E\leq e_X\).

This is a pointwise inequality for every \(f\) and every good core
slice. In later uses the unique minimizer \(f=f(X)\) is measurable
and the displayed terms are integrable. We average (4.2), not a
measurable selection of Slater determinants. A data-dependent trial
therefore causes neither a posterior substitution nor an admissibility
loss. Noninteger trial mass is legitimate because every Bernoulli
outcome is in an integer sector and \(E\) bounds all sectors.

### 4.2 Lower comparison for the actual radial fine density

On a cube of side \(b\), the spin-two Neumann levels are
\(\pi^2|m|^2/(2b^2)\), \(m\in\mathbb N_0^3\), twice each.
Attach unit cubes in the positive octant to lattice points of
radius at most \(s\). Their union lies in the octant ball of radius
\(s+\sqrt3\). Thus the number of levels is at most
\((\pi/3)(s+\sqrt3)^3\), and the \(j\)-th ordered radius is at least
\(((3j/\pi)^{1/3}-\sqrt3)_+\).
Using \((x-d)_+^2\geq x^2-2dx\), summing, and comparing powers
with integrals gives, for \(r\) particles,
\[
 \sum_{j=1}^r\lambda_j
 \geq b^{-2}\left[c_T r^{5/3}-C(r^{4/3}+r)\right].             \tag{4.3}
\]
The leading coefficient is
\(\frac12\pi^2(3/\pi)^{2/3}\frac35
  =\frac3{10}(3\pi^2)^{2/3}\), exactly (4.1).

For a fixed grid, split the out configuration into cube assignments.
Restriction is a Neumann-form restriction, not a zero extension;
there is no boundary localization cost. Slicing all other variables
leaves antisymmetry within each cube. The occupation/minimum-level
bound (4.3), integrated over the auxiliary variables and summed over
assignments, gives the leading random density
\(\sum_C n_C b^{-3}\mathbf1_C\). The error is at most
\(Cb^{-2}(n_o^{4/3}+n_o)\), since \(\sum_C n_C^{4/3}\leq n_o^{4/3}\).

Average over a uniform translation of the grid and over rotations.
For a fixed configuration, the average cell density is
\(\sum_{i\ {\rm out}}\vartheta_b(\cdot-x_i)\): the same-cube
probability is \(\prod_j(1-|x_j|/b)_+\). Convexity of the power
integral and then monotonicity on discarding particles yield, for
**any measurable retained subset**,
\[
 T_o\geq\mathbb E\left[c_T\int\sigma^{5/3}
                    -Cb^{-2}(n_o^{4/3}+n_o)\right].             \tag{4.4}
\]
Discarding happens after the full-density inequality, so no
antisymmetry of a data-dependent retained subset is asserted.

Finally discard out pairs not both retained, smear each retained
point radially, and use Section 3.3. The distinct smeared pair energies
decrease, while each self energy is at most \(C/b\) by scaling and
the bounded compact kernel. Hence, pathwise,
\[
 \sum_{i<j\ {\rm out}}K(x_i-x_j)\geq D(\sigma)-Cn_o/b.           \tag{4.5}
\]

## 5. Proof of A: a noncircular conditional positive-field recursion

### 5.1 A trial at one deterministic target

At a target \(v\), put \(a=a_v\). Append a deterministic cut full
out on \(B(v,40a)\), supported on \(B(v,80a)\), with gradients
\(O(a^{-1})\). Let \(X'\) be the enlarged data and
\(h=\mathbb E[J_v\mid X']\).
The core vanishes on \(B(v,40a)\). In (4.2) use uniform packet
centers of mass \(M\) in \(B(v,a)\), with packet width \(a\).
Both the core field and the nuclear field from sources at distance
at least \(40a\) have exactly their center value under this radial
average. Near nuclei add nonnegative attraction. In addition,
\(J_v\) subtracts the far out particles, whereas \(\Phi_{X'}\)
does not. Therefore
\[
 E\leq e_{X'}-Mh
             +C(M^{5/3}/a^2+M/a^2+M^2/a).                     \tag{5.1}
\]
The three costs follow by scaling a uniform density and its direct
energy. For \(ah>K m_{0,v}\), choose \(M=\lambda ah\).
After dividing the costs by \(Mh\), the ratios are
\[
 C\lambda^{2/3}/[a(ah)^{1/3}],\quad C/[a(ah)],\quad C\lambda.
\]
By (3.2), choose a universal small \(\lambda>0\) and then a
universal large \(K\) to make their sum at most \(1/2\).
For \(ah\leq K m_{0,v}\) use the vacuum. Enlarging a universal
constant gives, for all data,
\[
 E\leq e_{X'}-c a h_+^2+C m_{0,v}^2/a.                         \tag{5.2}
\]

### 5.2 A lower comparison for a finite accumulated cut list

Start at \(v_0=y,X_0=X\). At step \(j\) append the cut of Section
5.1 at the deterministic target \(v_j\), producing \(X_{j+1}\).
The accumulated out support is covered by at most \(C(j+1)\)
cells \(B_z\). Each new cell has scale comparable to that of a
preceding target or cell. Every possible next target will lie in
one of their doubled balls, denoted \(\mathcal U_j\).
If \(a_{\min}>0\) is the minimum initial target/covering scale,
local comparability and (3.2) give
\[
 a_z\geq C^{-(j+1)}a_{\min},\qquad e_z\leq C^{j+1}e_* .        \tag{5.3}
\]
The initial cells and \(y\) need not have comparable scales; their
finite minimum and maximum are exactly what (5.3) uses.

We have
\[
 \|n_o\|_2\leq\sqrt P\sum_zm_z,\qquad
 \mathrm{IMS}\leq C^{j+1}P e_* .                              \tag{5.4}
\]
For an initial cell its error contribution is bounded by
\[
 D_z^2a_z^{-2}\mathbb E n_z
 \leq\sqrt P\,\frac{D_z^2}{a_zm_z}e_z\leq C_0P e_z.
\]
For an appended cut use \(a_zm_z\geq1\) and its universal
scaled gradient bound. Summing a linear number of cells is
absorbed by \(C^{j+1}\).

Fix the current enlarged data \(X'=X_{j+1}\) and a covering cell.
Let \(V_z\) be the potential of nuclei in \(B(z,4a_z)\);
let \(H_z(v)\) be the conditional raw signed field of all sources
outside that fixed ball. It is harmonic on \(3B_z\).
For \(v\in2B_z\), the \(J_v\) exclusion contains \(B(z,4a_z)\).
The extra electrons in \(H_z\) only lower it. The extra nuclei
have charge at most \(Ca_z^{-3}\) and distance at least \(2a_z\).
Consequently
\[
 H_z(v)\leq\mathbb E[J_v\mid X']+Ca_z^{-4}.                    \tag{5.5}
\]
The use of the fixed exclusion for \(H_z\), unlike the moving
exclusion in \(J_v\), is essential for harmonicity.

Define numerical norms
\[
 G(v,X')=\sqrt{a_v/e_*}\,
             \|(\mathbb E[J_v\mid X'])_+\|_2,\qquad
 H=\sup_{v\in\mathcal U_j}G(v,X').
\]
The positive part of a harmonic function is subharmonic.
Apply its ball submean inequality on \(B_z\), then Minkowski,
(5.5), nearby scale comparability, and \(a_z^{-7}\leq e_z\).
This proves
\[
 \|\sup_{B_z}(H_z)_+\|_2
 \leq C a_z^{-3}\int_{2B_z}\|(H_z(v))_+\|_2\,dv
 \leq C^{j+1}\sqrt{e_*/a_z}\,(1+H).                            \tag{5.6}
\]

For an out electron at a point in \(B_z\), the core field is at most
\(V_z+H_z\) plus the potential of the out sources outside
\(B(z,4a_z)\). The latter is bounded by
\[
 C\sum_\ell n_\ell/\max(a_\ell,a_z).                            \tag{5.7}
\]
When \(a_\ell\) and \(a_z\) are comparable, the far exclusion
gives distance at least \(3a_z\). When \(a_\ell>2a_z\),
Lipschitzness implies \(|\ell-z|\geq L(a_\ell-a_z)\), so points
of \(B_\ell\) are a fixed multiple of \(a_\ell\) away from \(B_z\).
This proves (5.7), including widely separated initial scales.
Since \(\|n_\ell\|_2\leq\sqrt{P e_\ell a_\ell}\) and
\(\sqrt{a_\ell}/\max(a_\ell,a_z)\leq a_z^{-1/2}\),
its \(L^2\) norm is at most \(C^{j+1}\sqrt{P e_*/a_z}\).

Assign each out point to one covering cell. For the local nuclear
terms use (3.4), the coarse out kinetic bound (3.8), and Young's
inequality. For multiple cells the power of their number is at
most another \(C^{j+1}\). Thus the singular attractions cost
at most \(C^{j+1}e_*\). For the harmonic and addback terms use
Cauchy--Schwarz with
\(\|n_z\|_2\leq\sqrt{P e_z a_z}\), (5.6), and (5.7).
Drop the nonnegative out pair repulsion in (3.6). The result is
\[
 q_n[\psi]+\mathrm{IMS}
 \geq\mathbb E e_{X'}-C^{j+1}e_*(P+\sqrt P H).                 \tag{5.8}
\]
No conditional positive-field estimate for this accumulated list
has been assumed in deriving (5.8).

### 5.3 Growth contradiction

Average (5.2) at \(v_j\) and combine it with (5.8).
Use \(q_n[\psi]-E\leq\delta\leq e_*\), (5.3)--(5.4), and (3.9)
for the same raw \(J_{v_j}\). After increasing \(C\geq1\), independently
of the system and \(j\),
\[
 G(v_j,X_j)^2
 \leq C^{j+1}\left(P+\sqrt P\sup_{v\in\mathcal U_j}
                                  G(v,X_{j+1})\right).        \tag{5.9}
\]
Put \(g_j=G(v_j,X_j)/\sqrt P\).
If \(g_j^2\geq2C^{j+1}\), a deterministic target approximating
the numerical supremum may be selected with
\[
 g_{j+1}\geq g_j^2/(4C^{j+1}).                                 \tag{5.10}
\]
The supremum is finite by (5.3) and the elementary fixed-system
bound on \(J_v\). Nothing is selected from sampled cut data.

For \(c=\log C,d=\log4\), the scalar recurrence
\(\ell_{j+1}\geq2\ell_j-(j+1)c-d\) has the exact lower bound
\[
 \ell_j\geq2^j\ell_0-(2^{j+1}-j-2)c-(2^j-1)d.                 \tag{5.11}
\]
This follows by induction; `verify.py` checks the coefficient
identities for the induction, not a finite list of sample iterates.
If \(\ell_0>2c+d+M\), then \(\ell_j\geq2^jM\).
Choose a universal \(M>0\) large enough that
\(2^{j+1}M\geq\log2+(j+1)c\) for all \(j\).
The selection condition is then preserved for every step.

But pointwise \(J_v\leq Z/(40a_v)\); conditional expectation and
(5.3) imply
\[
 G(v_j,X_j)\leq C^{j+1}\frac{Z}{40\sqrt{e_*a_{\min}}}.          \tag{5.12}
\]
For this fixed system the last factor is finite. Its logarithm
plus the linear term in \(j\) cannot dominate \(2^jM\).
Thus \(g_0\) is universally bounded (with the stated \(C_0\)
dependence), proving A. The fixed-system prefactor in the
contradiction is not part of the resulting universal constant.
Neither \(P\leq C\) nor a positive lower bound on all atomic
scales has entered the argument.

## 6. Proof of B: a complete interior comparison

### 6.1 Selecting one deterministic cut

For \(t\in[5a,6a]\), take sine/cosine cut factors transitioning
over width \(b\). Out particles not retained have
\(t-7b\leq|x_i-y|\leq t+b\).
For each fixed pair of raw particles, including the diagonal
pair, the set of such \(t\)'s has length at most \(8b\).
Integrating the square of the raw shell count in \(t\) and then
expectation gives a bound \(8b\,\mathbb E N_{7a}^2\), where
\(N_{7a}\) counts particles in \(B(y,7a)\).
A comparable-cell cover gives
\(\mathbb E N_{7a}^2\leq CPm^2\).
Similarly Fubini and (3.4) give
\[
 \int_{5a}^{6a}\int_{\{t-7b\leq|x-y|\leq t+b\}}
                V_{\rm loc}^{5/2}\,dx\,dt
 \leq Cb\,a^{-7}.
\]
Select one \(t_0\) by averaging the sum of the two normalized
nonnegative quantities. For this single deterministic cut,
\[
 \mathbb E n_{\rm del}^2\leq C\beta Pm^2,\quad
 \mathbb E n_o^2\leq CPm^2,\quad
 \mathrm{IMS}\leq Cb^{-2}\sqrt Pm,\quad
 \int_{\rm shell}V_{\rm loc}^{5/2}\leq C\beta a^{-7}.            \tag{6.1}
\]
The last two count/IMS bounds also follow directly from the cover.

There is a nonnegative random scalar \(F\) such that, on the cut
support and on \(\Omega\),
\[
 \Phi_X\leq V_{\rm loc}+F,\qquad
 \|F\|_2\leq C\sqrt Pm/a.                                     \tag{6.2}
\]
Indeed the raw conditional signed field from outside \(B(y,20a)\)
is harmonic on \(B(y,10a)\); those electrons are all core
particles, since the out support is within \(7a\).
As in (5.5), this harmonic field at \(v\in B(y,10a)\) is at most
\(\mathbb E[J_v\mid X]+Ca^{-4}\).
Apply the harmonic submean estimate and A at comparable nearby
targets, taking \(F\) to dominate its positive supremum on \(B(y,7a)\).
The cut support has a fixed comparable-scale cover, and its
gradient coefficients are at most \(C\beta^{-1}\).
The condition \(\beta^{-2}/(am)\leq\sqrt P\) verifies A's
gradient hypothesis with a fixed universal \(C_0\).
Thus its constant does not acquire a hidden dependence on \(\beta\).
Finally \(a^{-4}\leq m/a\) absorbs the comparison error.

### 6.2 Minimizer, measurability, and integrability

The core is separated from \(\Omega\) by \(4b\).
Its potential is bounded and smooth there, so
\(\Phi_X\in L^{5/2}(\Omega)\) for every good slice.
Young's inequality makes \(\mathcal T_X\) coercive on the positive
cone of \(L^{5/3}(\Omega)\). The direct method applies: bounded
sequences are weakly compact, the cone is weakly closed, and
both the convex kinetic power and \(D\) are weakly lower
semicontinuous. Strict convexity of the kinetic term gives
uniqueness. The Euler inequality and complementary slackness give
\[
 \tfrac53c_T\rho^{2/3}-\Phi_X+K*\rho\geq0,\qquad
 (\tfrac53c_T\rho^{2/3}-\Phi_X+K*\rho)\rho=0,
\]
equivalently \(\rho=kW_+^{3/2}\).
The variational inequalities follow first for bounded
variations and then by truncation, so no positivity at a
nuclear point is assumed.

The minimizer map is continuous from \(L^{5/2}\) fields to
\(L^{5/3}\) densities. To see this, convergent fields give bounded
minimizers. Any weak limit minimizes the limiting functional,
by lower semicontinuity and comparison with its unique minimizer.
Minimum values converge. Lower semicontinuity of \(D\) then
forces convergence of kinetic norms; uniform convexity upgrades
weak to strong \(L^{5/3}\) convergence.
Joint measurability of the conditional field, with separability
of \(L^{5/2}(\Omega)\), and this continuity give measurability
of the unique minimizer. No choice among minimizers is needed.

Write \(M_\rho=\int\rho\). The diameter of \(\Omega\) is at most
\(12a\), so \(D(\rho)\geq M_\rho^2/(24a)\).
The minimum is nonpositive. Absorbing the local nuclear
attraction by (3.4) and Young's inequality in (6.2) gives
\[
 M_\rho\leq C(aF+a^{-3}),\qquad
 \int\rho^{5/3}\leq C(aF^2+a^{-7}).                            \tag{6.3}
\]
If \(V_{\rm loc}=0\), the same argument gives the sharper
\[
 M_\rho\leq CaF,\qquad \int\rho^{5/3}\leq CaF^2.                \tag{6.4}
\]
In particular
\(\mathbb E M_\rho\leq C\sqrt Pm\) and
\(\mathbb E\int\rho^{5/3}\leq CPe\).
These bounds justify averaging every following trial error.

### 6.3 Upper energy

Centers in \(\overline\Omega\) and width-\(b\) packets stay at least
\(3b\) from the core. The core potential is unchanged by radial
averaging. Every nonlocal nucleus is harmonic on the packets.
The loss in nuclear attraction is bounded, at the center, by
\[
 V_b^{\rm loss}(x)=
 \sum_{R_m\in B(y,20a)}
 \frac{z_m}{|x-R_m|}\mathbf1_{\{|x-R_m|\leq2b\}} .
\]
Weighted convexity and \(Q\leq a^{-3}\) give
\[
 \int(V_b^{\rm loss})^{5/2}
 \leq C Q^{5/2} b^{1/2}\leq C\beta^{1/2}a^{-7}.                \tag{6.5}
\]
Apply (4.2) to the measurable minimizer and Young's inequality:
\[
 E\leq e_X+\mathcal T_X(\rho)+Cb^{-2}M_\rho
          +C\epsilon\int\rho^{5/3}
          +C\epsilon^{-3/2}\beta^{1/2}a^{-7}.                  \tag{6.6}
\]
If \(V_{\rm loc}=0\), all averaging is harmonic and the last
two terms are absent.

### 6.4 Lower energy

Reserve a small fraction \(\epsilon T_o\). By (3.8), Young's
inequality, (6.1), and (6.5), it absorbs both the nuclear loss
from fine smearing and the deleted particles' local nuclear
attraction at cost \(C\epsilon^{-3/2}\beta^{1/2}a^{-7}\).
For deleted particles the remaining field costs at most
\[
 \mathbb E(F n_{\rm del})
 \leq\|F\|_2\|n_{\rm del}\|_2\leq C\sqrt\beta Pe.               \tag{6.7}
\]
The retained kernels lie in \(\Omega\), because their radius
is \(\sqrt3b<3b\) and their centers lie within \(t_0-7b\).
The core potential is harmonic on them; the only loss in replacing
their nuclear attractions by smeared attractions is the same
nonnegative \(V_b^{\rm loss}\) at their actual positions.
Use (4.4) on the remaining kinetic fraction and (4.5) on pairs
in (3.6). With
\[
 \mathcal R=\epsilon^{-3/2}\beta^{1/2}a^{-7}
  +\sqrt\beta Pe+b^{-1}\sqrt Pm
  +b^{-2}(P^{2/3}m^{4/3}+\sqrt Pm)
\]
this proves
\[
 q_n[\psi]+\mathrm{IMS}
 \geq\mathbb E[e_X+\mathcal T_X(\sigma)
                       -\epsilon c_T\int\sigma^{5/3}]
       -C\mathcal R.                                         \tag{6.8}
\]
Here
\(\mathbb E n_o^{4/3}\leq(\mathbb E n_o^2)^{2/3}\);
there is no hidden higher-count moment.

The Euler equation and quadratic expansion of \(D\) give the exact
identity
\[
 \mathcal T_X(\sigma)-\mathcal T_X(\rho)
 =D(\sigma-\rho)+\mathcal L+\int W_-\sigma.                    \tag{6.9}
\]
For clarity, the derivative left over after the tangent kinetic
term is
\(\tfrac53c_T\rho^{2/3}-W=W_+-W=W_-\).
It pairs with \(\sigma\); its pairing with \(\rho\) is zero.
This fixes the sign and location of the negative-field penalty.

There is also a useful explicit coercivity bound for the remainder.
For nonnegative \(u,v\),
\[
 3u^5-5u^3v^2+2v^5
 =(u-v)^2(3u^3+6u^2v+4uv^2+2v^3)\geq0.                      \tag{6.10}
\]
If \(u\geq2v\), one third of the right side is at least \(u^5/4\).
If \(u<2v\), nonnegativity implies a lower bound
\(u^5/4-8v^5\). Substituting \(u=\sigma^{1/3},v=\rho^{1/3}\) yields
\[
 \mathcal L\geq(c_T/4)\int\sigma^{5/3}-8c_T\int\rho^{5/3}.      \tag{6.11}
\]
Thus for universal small \(\epsilon\), the kinetic loss in
(6.8) is absorbed by half the remainder, with error
\(C\epsilon\int\rho^{5/3}\).

Average (6.6), subtract from (6.8), use
\(q_n[\psi]\leq E+\delta\), and apply (6.1), (6.3), and (6.11).
The packet cost is \(Cb^{-2}\mathbb E M_\rho
\leq Cb^{-2}\sqrt Pm\). The other minimizer errors are
\(C\epsilon Pe\). This gives B1; multiplying a universal
constant restores the full nonnegative remainder after absorption.
Equation (6.11) also gives the first assertion of B2.

If \(V_{\rm loc}=0\), no nuclear loss is present in either
comparison. Use all of \(T_o\) in (4.4), without reserving any
fraction. Both the core and nuclear fields are exactly preserved
by the radial averages. Delete only the \(F n_{\rm del}\) term
as in (6.7), and use (6.4) in the upper packet error.
Subtracting the two energies and using (6.9) proves B4 with
its full convex remainder and no epsilon terms.

### 6.5 The separate out kinetic bound

Every core slice has \(e_X\geq E\). In (3.6), drop pair
repulsion, use (6.2), and absorb the local nuclear attraction
with half of the coarse kinetic bound (3.8). By (6.1),
\[
 T_o/2\leq\delta+\mathrm{IMS}+Ca^{-7}+\mathbb E(F n_o)
 \leq C(Pe+b^{-2}\sqrt Pm).
\]
This proves the second assertion of B2. It uses no eigenstate
equation and no density estimate to be proved later.

### 6.6 Pathwise interior bounds

The core vanishes in \(B(y,4a)\subset\Omega\). There, in distributions,
\[
 \Delta W=-4\pi\nu+c_F W_+^{3/2}.                              \tag{6.12}
\]
Let \(s=4a\), \(r=|x-y|\), and
\[
 U(x)=V_{\rm loc}(x)+B(x),\qquad
 B(x)=C s^4(s^2-r^2)^{-4}.
\]
Direct differentiation gives
\[
 \Delta B=
 C s^4\frac{24s^2+56r^2}{(s^2-r^2)^6}
 \leq\frac{80C s^6}{(s^2-r^2)^6}.
\]
Choose a universal \(C\) with \(80C\leq c_F C^{3/2}\).
Then \(\Delta B\leq c_F B^{3/2}\leq c_F U^{3/2}\).
On this ball \(\Delta V_{\rm loc}=-4\pi\nu\).

The difference \(W-V_{\rm loc}\) is bounded above for each
fixed system and slice: far nuclei have bounded potential,
and both core and TF potentials are nonnegative.
It is locally \(H^1\), by cancellation of nuclear singularities
and (3.3). Since \(B\) diverges at the boundary,
\((W-U)_+\) is compactly supported in the ball.
Subtract (6.12) from the supersolution inequality, or equivalently
test their difference, to obtain
\[
 -\int|\nabla(W-U)_+|^2
 \geq c_F\int_{\{W>U\}}(W_+^{3/2}-U^{3/2})(W-U)\geq0 .
\]
The local \(L^{5/2}\) potentials give locally \(L^{5/3}\)
nonlinearities; compact \(H^1\) approximation justifies the test.
All point sources have canceled before testing.
Thus \(W\leq U\).

On \(B(y,3a)\), \(B\leq Ca^{-4}\), proving the field part of B3.
By the Euler equation, (3.4) with \(s=3/2\), and \(Q\leq a^{-3}\),
\[
 \int_{B(y,2a)}\rho
 \leq C\int_{B(y,2a)}(V_{\rm loc}^{3/2}+a^{-6})
 \leq C(Q^{3/2}a^{3/2}+a^{-3})\leq Ca^{-3}.
\]
If \(V_{\rm loc}=0\), the Euler equation also gives
\(\rho\leq Ca^{-6}\) on \(B(y,3a)\). These are deterministic
bounds for every good conditional slice, not bounds on an average
field. This completes B.

## 7. Proof of C: closing the provisional count constant

Fix small universal \(\epsilon\), then \(\beta\), in that order.
It suffices to rule out large \(P\); when \(P\geq\beta^{-4}\),
\(\beta^{-2}/(am)\leq\sqrt P\) follows from (3.2), so B applies
at every target.

Every raw particle in \(B_y\) is full out and retained; its kernel
is inside \(B(y,1.1a)\). Choose \(0\leq\chi\leq1\), equal to
one there, supported in \(B(y,2a)\), with
\(\|\nabla\chi\|_2\leq C\sqrt a\).
Use B3 and the signed Coulomb test (3.3):
\[
 n_y\leq\int\chi\sigma
 \leq Ca^{-3}+C\sqrt{aD(\sigma-\rho)},\qquad
 \mathbb E n_y^2\leq Ca^{-6}+Ca\,\mathbb E D(\sigma-\rho).
                                                                    \tag{7.1}
\]
Divide by \(Pm^2\), insert B1, and use
\(\delta a\leq m^2,\ a^{-6}\leq m^2\).
The resulting bound is
\[
 \frac{\mathbb E n_y^2}{Pm^2}\leq
 K\left[
 P^{-1}+\epsilon+\sqrt\beta
 +\epsilon^{-3/2}\beta^{1/2}P^{-1}
 +\frac{\beta^{-1}}{\sqrt Pm}
 +\frac{\beta^{-2}}{P^{1/3}am^{2/3}}
 +\frac{\beta^{-2}}{\sqrt Pam}\right],                         \tag{7.2}
\]
where \(K\geq1\) is universal and independent of all chosen small
parameters. In particular A's constant in B did not depend on
\(\beta\), as checked in Section 6.1.

Here is an explicit noncircular order of constants. Let
\(\epsilon_*>0\) be a universal smallness threshold for B.
Choose \(0<\epsilon<\epsilon_*\) with
\(K\epsilon\leq1/32\), then \(0<\beta<1/100\) with
\(K\sqrt\beta\leq1/32\).
Choose a fixed \(P_0>1\), at least \(\beta^{-4}\), and at least
each of
\[
 32K,\quad 32K\epsilon^{-3/2}\sqrt\beta,\quad
 (32K\beta^{-1})^2,\quad
 (32K\beta^{-2})^3,\quad (32K\beta^{-2})^2.                     \tag{7.3}
\]
Since \(m,am,am^{2/3}\geq1\), each of the seven terms in (7.2),
including its \(K\), is at most \(1/32\) for \(P>P_0\).
The ratio is therefore at most \(7/32<1/2\), uniformly in \(y\).
Taking the supremum gives
\(\sup_y\mathbb E n_y^2/m_y^2\leq P/2\), contrary to the
definition of \(P>P_0>1\).
Thus \(P\leq P_0\), independent of every system parameter.
Finally
\(m_y^2\leq2\max(a_y^{-6},1)+2\delta a_y\), proving C.

This argument uses A with provisional finite \(P\), then B with
that same provisional \(P\), and only then closes \(P\).
Neither a count assumption in A nor a choice of small parameters
depending on the unknown value of \(P\) is made.

## 8. Proof of D: exact exponents and the raw density

Take \(\beta=a^{1/5}\), \(\epsilon=a^{1/50}\), \(b=a^{6/5}\).
Choose universal \(a_0<1\) small enough for B's beta and epsilon
thresholds. If \(\delta\leq a^{-7+1/50}\), then
\[
 m\leq a^{-3}+a^{-3+1/100}\leq2a^{-3},\quad
 e\leq4a^{-7},\quad
 \beta^{-2}/(am)\leq a^{8/5}\leq1\leq\sqrt P.                 \tag{8.1}
\]
C gives \(P\leq P_0\).
The powers of \(a\) in B1, respectively, are
\[
 \begin{array}{c|c}
 \hbox{term}&\hbox{upper-bound exponent}\\ \hline
 \delta&-349/50\\
 \epsilon Pe&-349/50\\
 \sqrt\beta Pe&-69/10\\
 \epsilon^{-3/2}\beta^{1/2}a^{-7}&-693/100\\
 b^{-1}\sqrt Pm&-21/5\\
 b^{-2}P^{2/3}m^{4/3}&-32/5\\
 b^{-2}\sqrt Pm&-27/5
 \end{array}
\]
Every exponent is at least \(-349/50=-7+1/50\).
For \(0<a<1\) this is the correct inequality direction for an
upper bound. B1 and the first assertion of B2 therefore give D1.
The second assertion of B2 gives \(T_o\leq Ca^{-7}\), since
the extra error has exponent \(-27/5>-7\).
On \(B(y,4a)\) the cut is full out, so its one-body density
\(o^2\rho_\psi\) equals the **raw** \(\rho_\psi\).
Applying (3.8) to that density proves D2.

No positive lower bound on the atomic distance scale was used
in (8.1) or anywhere in the proof. Large nuclear charges, arbitrary
correlations, rare cut data, and arbitrarily large finite sectors
are all included.

## 9. Executable scope and independent review boundary

Run, from any working directory:

```
$WORKSPACE/argus-live-update/.venv/bin/python \
  families/263/first-pass/local_screening/verify.py
```

Only the standard library and retained JSON files are needed.
The script reconstructs the factorization returned by Jacobian with
independent rational arithmetic. It checks the full homogeneous
two-variable identity (6.10), the exact positive coefficients used
for convexity/coercivity, the cube/packet coefficient equality after
cubing, the supersolution numerator, the symbolic induction
coefficients in (5.11), every normalization in (7.2), and every
exponent and threshold comparison in Section 8. These are exact
identities/inequalities, not floating-point fits or parameter samples.

Jacobian was used only through the authorized Argus adapter.
The inspected operation was `polynomial.factor.compute`; its exact
payload and typed result, including protocol `2025-11-25`, server
`0.14.0`, and operation id, are retained in
`jacobian_request.json` and `jacobian_output.json`.
The observed adapter exit status was zero; the typed result was
complete, not a timeout or UNKNOWN. Only its product reconstruction
is used; irreducibility of its cubic factor is unnecessary.

The decisive analytic questions for independent review are:
the one-law nesting in (3.9); pointwise admissibility of (4.2);
Neumann restriction and averaging in (4.4); the incomparable-scale
addback in (5.7); uniform constants in (5.9); the nuclear-loss
absorption in (6.8); and the order of constants (7.3).
All have explicit arguments above. A successful script run alone
is not an independent confirmation of any of them.

The mathematical deliverable is the proof of A--D and its exact
algebraic replay. Independent review, citation attribution, and
any claim of publishable novelty remain separate obligations.
