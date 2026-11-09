# Uniform channel crossover: independent analytic audit

## Scope and inputs

The target is `build/sections/02-channels.tex` in the staged September 25,
2026 manuscript, specifically `lem:channel-cutoff`,
`lem:channel-expansion`, `lem:plane-coefficient`, and their implication
`eq:quantitative-density-drift`. The source is not modified. The enormous
charge is neither computed nor used as a substitute for this estimate.

The input boundary is the fixed-\(D\) spectral setup of
`01-coulomb-setup.tex`: the two simple spatial orbitals \(b,e\), their
parity and positivity, their separated rates \(0<k_0<\gamma\), the
isolated ionic singlet, the analytic small-coupling three-electron branch,
and its \(O(\lambda)\) graph-norm convergence. These are assumptions
outside this mission, not conclusions of this audit. In particular,
this report cannot certify the manuscript's main theorem.

The quantifier to be settled is: after fixing sufficiently large \(D\),
there exist \(\lambda_D>0\), \(R_D<\infty\), and constants depending on
\(D\), but not on \(0\leq\lambda\leq\lambda_D\), for the entire exterior,
including the moving crossover where
\(b\) and \(\lambda A r^{-4}\) are comparable. Sending \(r\) to infinity
at fixed positive coupling is not a proof of this quantifier.

The inherited Wiki index has no topic on this manuscript, this
uniform estimate, or the relevant Coulomb-density derivative theorem.
The nodal-plane mechanism itself is already attributed by the
manuscript to Gori-Giorgi, Gal, and Baerends, Section V.A; no novelty
claim for that mechanism is made here. Primary-source retrieval and
the scope of the cited parallel-derivative estimates are recorded in
`literature/primary_sources.txt`. In particular, that reference is not
silently treated as a parameter-uniform theorem.

## Result and verification boundary

**Theorem U (analytic verification, subject to independent review).**
Assume the Section 1 input stated above, including the displayed
two-centre energy bounds, for a fixed \(D\geq100\). There exist
\(\Lambda_D\in(0,1]\), \(R_D\geq1\), and \(C_D,c_D>0\) such that,
simultaneously for every \(\lambda\in[0,\Lambda_D]\), the following hold.
Different occurrences of \(C_D,c_D\) may have different positive values.

1. The cutoff construction has residual
   \(\|\partial_x^\nu R\|\leq C_{D,s}\lambda e^{-\sigma r}\)
   for every fixed \(s\) and \(|\nu|\leq s\), where a single
   \(\sigma>\gamma\) can be used, and
   \(\left|\partial_x^\nu(n-\|F\|^2)\right|
   \leq C_D e^{-2\sigma r}\) for \(|\nu|\leq2\).
2. The projected and complementary expansions in the source hold with
   precisely their stated differentiated remainders:
   \[
   f=A(a_0+a_1/r+a_2/r^2+E),\quad
   (\Omega^\ell E,\partial_r\Omega^\ell E,
      \partial_r^2\Omega^\ell E)
       =(O_D(r^{-3}),O_D(r^{-4}),O_D(r^{-4})),
   \]
   and
   \[
   QF=bG+\lambda A\sum_{j=2}^4r^{-j}T_j+E_Q,\qquad
   \|\partial_x^\nu E_Q\|\leq C_D\lambda A r^{-5}
       \quad(|\nu|\leq2).
   \]
   The scalar remainders without angular differentiation have an
   additional factor \(|\omega_z|\), and
   \[
   T_2(0)=T_3(0)=0,\qquad
   T_{\rm eq}:=T_4(0)
     =-a_0'(0)B_Q^{-2}QY_z\phi,\qquad
   \|T_{\rm eq}\|\geq c_D.
   \]
3. Throughout \(r\geq R_D\), including at \(\lambda=0\),
   \[
   \|F\|\geq c_D S,\quad
   S=A|\omega_z|+b+\lambda A r^{-4},\qquad b/\|F\|\leq2.
   \tag{U1}
   \]
4. With \(L=10\), \(m=e^{2kp}n\), and every \(R\geq R_D\), the maximum
   of the three suprema in `eq:quantitative-density-drift` is at most
   \[
   100\bigl(|\gamma-k|+|\gamma-k|^2\bigr)+C_D/R.
   \tag{U2}
   \]
   For all sufficiently large \(p\), with the threshold independent of
   \(\lambda\),
   \[
   n(p,z_1)/n(p,z_2)\leq20\qquad
                  (0\leq z_1\leq z_2\leq10).
   \tag{U3}
   \]

Thus given \(\eta>0\), choose \(D\) large so that the rate-difference
term at zero coupling is small, then decrease \(\Lambda_D\) by
continuity of \(k_\lambda\), then choose \(R\) large so that \(C_D/R\)
is small. None of these exterior radii depends on the individual
coupling. Constants and radii can depend on the inverse ionic gap:
the theorem does **not** assert gap-uniform radii as \(D\) varies.
Only the surviving rate-difference coefficient in (U2) is absolute.

The proof below establishes an analytic implication, not a finite
experiment or a Lean formalization. `verify.py` checks the exact
algebraic components, the source locations, and the saved typed
Jacobian result. It does not purport to decide elliptic estimates or
quantification over an infinite exterior. Those arguments are in the
proof and remain subject to the normal independent Reviewer.
No original extension or verified-new literature claim is asserted.

## 1. Uniform weighted localization and the cutoff

All parameters are restricted to one sufficiently small closed
interval \(I=[0,\Lambda_D]\). Analytic perturbation and the input
spectral gaps give a common ionic gap \(B_Q\geq c_D>0\), uniform
\(H^2\) bounds, \(H^2\) differences \(O_D(\lambda)\), and
\[
 k>0.99,\quad \gamma-k\geq(\gamma-k_0)/2>0,\quad |\beta|\leq C.
 \tag{1}
\]
The projections \(P_\lambda\) also differ from \(P_0\) by
\(O_D(\lambda)\). This follows by the same isolated-contour resolvent
formula used for the states; it is not an assumption that
\(P_\lambda=P_0\).

Here and below local Coulomb estimates are uniform over \(I\) for the
following elementary reason. In a relative coordinate Hardy's
inequality gives
\(\|Vv\|_2\leq\varepsilon\|\Delta v\|_2+C_\varepsilon\|v\|_2\)
for the finite sum of Coulomb multipliers, with constants uniform when
their coefficients lie in a bounded interval. A cutoff in a larger
fixed-size box, the energy identity on that box, and the Laplacian
estimate therefore give
\[
 \|v\|_{H^2(U)}
 \leq C\bigl(\|(H-E)v\|_{L^2(V)}+\|v\|_{L^2(V)}\bigr),
 \qquad U\Subset V.
 \tag{2}
\]
Indeed the cutoff commutator contains only a first derivative; the
local energy estimate bounds it using the right side before the
infinitesimal potential term is absorbed. The constants depend on the
fixed box separation and bounds on \(E\) and the coefficients, not
on their individual values in \(I\). This argument applies to
vector-valued functions with a finite spin sum.

For completeness the exterior energy bound used here does not
require an interacting threshold theorem. A smooth homogeneous
partition selects a particle with distance at least a fixed multiple
of \(\rho=(|x|^2+|y|^2)^{1/2}\). For \(\rho\) larger than a
\(D\)-dependent constant its nuclear attraction is \(O_D(\rho^{-1})\).
Each other one-particle Hamiltonian is bounded below by
\(\epsilon_b\). Drop the nonnegative repulsion. The IMS error of
the partition is \(O(\rho^{-2})\). Consequently the exterior form
lower bound is \(2\epsilon_b-O_D(\rho^{-1})\), uniformly on \(I\).

The exact margin computation is
\[
 (10/9)k_0^2-\gamma^2
 \geq 1/9-2/D-1160/(9D^2)>0\quad(D\geq100).
 \tag{3}
\]
Its right side at \(100\) is \(88/1125\) and it increases with \(D\).
Choose, once,
\[
 \gamma\sqrt{9/10}<\tau_0<\tau_1<\tau_2<k_0.
 \tag{4}
\]
Continuity of \(E_3\) permits decreasing \(\Lambda_D\) so that the
exterior form lower bound minus \(E_3(\lambda)\) exceeds
\(\tau_2^2/2\) by a positive constant outside a fixed ball.
The weighted energy identity, with a truncated Lipschitz exponent
of gradient norm at most one, then gives
\[
 \|e^{\tau_1\rho}v\|_{H^1}
 \leq C_D\bigl(\|e^{\tau_1\rho}f\|_2+
                    \|v\|_{H^1(K)}\bigr)
 \tag{5}
\]
when \((H_{3,\lambda}-E_3(\lambda))v=f\). To see the gradient
bound as well as the \(L^2\) bound, combine a small positive
multiple of the kinetic-form lower bound with the strict exterior
energy bound before applying the identity. Its extra weight cost
is accommodated by \(\tau_1<\tau_2\). Interior commutators are
supported on \(K\). Cauchy--Schwarz absorbs the source term,
and monotone truncation removes the exponent cutoff.

The unperturbed state also has the \(\tau_2\) bound, since
\(2\epsilon_b-E_3(0)=k_0^2/2\). For \(v=F_{\rm true}-F_0\),
the source in (5) is
\((E_3(\lambda)-E_3(0)-\lambda V_{\rm ee})F_0\).
Weighted Hardy, applied to \(e^{\tau_1\rho}F_0\), is valid because
its derivative is controlled by the spare \(\tau_2\) weight.
The source and the compact term are \(O_D(\lambda)\). Thus
\[
 \|e^{\tau_1\rho}F_{\rm true}\|_{H^1}
 +\|e^{\tau_1\rho}F_0\|_{H^1}\leq C_D,\qquad
 \|e^{\tau_1\rho}v\|_{H^1}\leq C_D\lambda.
 \tag{6}
\]

Use the source's \(\chi,\zeta\), and set
\(F=F_0+\chi v\) and \(W=\zeta\sum_i|x-y_i|^{-1}\).
The separation \(|x-y_i|\geq r/4\) on the support of \(\zeta\)
gives all operator-norm symbol bounds
\(\|\partial_x^\nu W\|\leq C_\nu r^{-1-|\nu|}\).
The cutoff residual identity is exactly
\[
 R=(1-\chi)\mathcal L_\lambda F_0+
              [\mathcal L_\lambda,\chi]v,\quad
 \mathcal L_\lambda F_0=
 \{\lambda(|y_1-y_2|^{-1}+W)-E_3(\lambda)+E_3(0)\}F_0.
 \tag{7}
\]
Here \(k^2/2+B=H_{\rm ion}-E_3(\lambda)\); no ionic energy
term has been lost. The first term of (7) is supported on
\(|y|\geq r/3\), and the commutator is supported in
\(r/3\leq|y|\leq r/2\). Both have the factor \(\lambda\)
in their norm bounds, the latter by (6).

The derivative issue in (7) is not resolved by differentiating an
uncut Coulomb eigenfunction arbitrarily. On the commutator support
\(x\) is separated from both \(y_i\) and from the nuclei.
Apply difference quotients in \(x\) to the equation for \(v\)
on nested boxes. Every differentiated coefficient is bounded there.
The ionic singular coefficients are independent of \(x\);
the ionic Coulomb factor in the source is controlled by Hardy
after each derivative of the product state \(F_0\).
Induction using (2) therefore controls any fixed number of
\(x\)-derivatives of \(v\), and their first \(y\)-derivatives,
by \(C_{D,s}\lambda\) in weighted local \(L^2\).
The first term of (7) needs only \(x\)-derivatives of \(F_0\)
and the bounded cutoff interaction. These are controlled in
the same way, without any electron-electron \(x\)-singularity.
Summing fixed-size boxes has bounded overlap; a small loss
from \(\tau_1\) to \(\tau_0\) also absorbs polynomial cutoff
and rotation factors. Hilbert-valued Sobolev embedding in \(x\),
using two extra derivatives, gives pointwise fiber estimates.
Since \(\rho\geq\sqrt{10/9}\,r\) on every tail support, choose
\[
 \gamma<\sigma<\tau_0\sqrt{10/9}.
 \tag{8}
\]
Equations (6)--(8) prove the residual estimate with this same
\(\sigma\) for every fixed finite derivative order.

For density derivatives one must also cover collisions \(x=y_i\)
in the discarded region. Expand the three pair-cutoff identities
into a finite sum. Each term defines clusters of near edges, of
diameter at most \(4\), with distinct clusters separated by at
least \(1\). On nested boxes of displacements less than \(1/8\)
that separation remains positive. In the cluster containing \(x\),
replace every other coordinate by its difference from \(x\).
Differentiation of \(x\) in these variables is the sum of the
particle derivatives in that cluster. It kills every internal
Coulomb singularity; outside-cluster singularities are independent
of it; the remaining coefficients are smooth with uniformly
bounded derivatives. The cluster lies away from the nuclei
when \(r>D+5\).

Thus the same difference-quotient induction (2) applies in these
three translation directions to either state in (6). The kinetic
form after this fixed linear change of coordinates is uniformly
elliptic; there are only finitely many possible clusters. The
pair-cutoff derivatives are supported at positive separations.
After the coordinate change, differentiate the integrated products
\[
 n-\|F\|^2
  =\int\bigl((1-\chi^2)|v|^2+
                   2(1-\chi)\operatorname{Re}(\overline{F_0}v)\bigr).
 \tag{9}
\]
Every resulting term is supported on \(|y|\geq r/3\) and is
a product of two factors with the weighted local estimates (6).
Cauchy--Schwarz in the ionic variables and Sobolev embedding
in the three translation directions give \(C_D e^{-2\sigma r}\),
through two derivatives. The differentiations under the integral
are justified first with compact configuration cutoffs and then
by the same weighted bounds. This proves assertion 1.
It also proves \(F-F_0=O_D(\lambda)\) with every fixed finite
number of \(x\)-derivatives on fixed exterior annuli.
This explicit parameter tracking is the extra argument not supplied
by merely citing the fixed-Hamiltonian parallel-derivative theorem.

## 2. Ionic moments, comparison, and the scalar remainder

The ionic moment statements used in finite multipole matching follow
from the isolated spectral gap, not from an operator-norm multipole
series on the whole ionic Hilbert space. Let
\(\rho_y=(1+|y|^2)^{1/2}\). Conjugating the ionic operator by
\(e^{s\rho_y}\) adds a first-order term of relative bound \(O(s)\)
and a bounded \(O(s+s^2)\) term. On a common isolated contour,
the unweighted resolvent maps \(L^2\) to \(H^2\) uniformly.
For small \(s>0\) the conjugated resolvents therefore exist by
the inverse perturbation formula, uniformly on \(I\).
Apply the contour projection to a compactly supported vector with
nonzero overlap at zero coupling, then shorten \(I\) to preserve
that overlap. This proves a common exponential \(H^2_y\) bound
for \(\phi_\lambda\).

The operator \(B+P\) is invertible into \(H^2_y\). Its conjugated
finite-rank term is bounded by the localization just obtained,
so the same argument shows that \(B_Q^{-1}Q\) maps an
exponentially localized input to an exponentially localized
\(H^2_y\) output after decreasing the weight. Polynomial moments
are absorbed by another decrease of weight. Only finitely many
such operations will be needed. These weighted resolvents and
vectors are continuous in \(\lambda\) on a smaller interval.

Taylor's formula on \(|y|\leq3r/4\), with the exponential tail
outside it, now proves every finite localized multipole expansion
and its Cartesian symbol remainder. In particular
\(QW\phi=O_D(r^{-2})\),
\(PW\phi=(2/r+O_D(r^{-2}))\phi\).
Inversion symmetry of the axial, reflection-even ionic state gives
\(\langle\phi,W_2\phi\rangle=0\); the nuclear dipole also vanishes.

Write a vector as \(\phi f+q\). In its ionic quadratic form,
absorb the off-diagonal \(O_D(\lambda r^{-2})|f|\|q\|\)
into half the \(Q\)-gap by Young's inequality. For large \(r\)
the retained half-gap also dominates \(2\lambda/r\) on \(q\).
This proves
\[
 B+\lambda W\geq2\lambda/r-C_D/r^2.
 \tag{10}
\]
The Hilbert-space norm inequality, obtained by pairing the equation
with \(F/(\|F\|^2+\varepsilon^2)^{1/2}\) and then taking the limit,
is
\[
 (-\Delta/2+k^2/2-(2-2\lambda)/r-C_D/r^2)\|F\|
                  \leq\|R\|.
 \tag{11}
\]
The ionic term is handled by its closed quadratic form. For
positive supersolutions, exterior comparison follows by testing
the positive part of the difference with expanding cutoffs:
the scalar zeroth-order coefficient is positive outside a fixed
ball, the inner boundary is dominated, and both functions have
exponential \(L^2\) decay, so the outer cutoff error vanishes.
This also applies after angular differentiation.

Applied to \(A(1-M/r)\), the operator in (11), divided by \(A\),
has \(r^{-2}\) coefficient
\(kM-\beta(\beta+1)/2-C_D\).
A uniform large \(M\), then an inner radius \(r>2M\), make it
a positive supersolution. The annular bounds of Section 1 give
a common multiple dominating the boundary and source. Hence
\(\|F\|=O_D(A)\). The \(Q\)-equation has source
\(-\lambda QW\phi f+QR=O_D(A/r^2)\).
Its scalar norm inequality retains the positive ionic gap;
a multiple of \(A/r^2\) is a supersolution, giving
\(\|QF\|=O_D(A/r^2)\).

Rotation fields in \(x\) commute with \(B,P,Q,\Delta_x\).
For a nonzero number of rotations,
\(\|\Omega^jW\|=O(r^{-1})\) but
\(\|\Omega^jW\phi\|=O_D(r^{-2})\), since the monopole is constant
on the sphere. Also \(\Omega^ju=O_D(r^{-3})\).
In induction on the number of rotations, every commutator source
is \(O_D(A/r^2)\): split each lower derivative into \(P+Q\);
the \(P\) term uses the improved bound on \(W\phi\), and the
\(Q\) term uses \(Q\Omega^iF=O_D(A/r^2)\).
The two comparisons just proved therefore give both bounds with
any fixed finite number of angular derivatives.

Here is the radial argument with its constants and regularity
requirements made explicit. Put \(h=f/A\) and
\[
 K_j=-\Delta_{\mathbb S^2}/2
              -(\beta-j)(\beta-j+1)/2.
 \]
Conjugating the projected equation gives
\[
 -h''/2+(k-(\beta+1)/r)h'
       +K_0h/r^2+c_3h/r^3=O_D(r^{-4}),
 \tag{12}
\]
in every fixed angular \(C^s\) norm. The off-diagonal term has
order \(r^{-4}\), since both \(PWQ\) and \(QF/A\) have order
\(r^{-2}\). The localized multipoles control the other terms.

If a bounded Banach-valued \(H\) satisfies
\(-H''/2+(k-(\beta+1)/r)H'=G\), \(\|G\|\leq C_D r^{-q}\),
\(q>1\), direct integration gives
\[
 H'=2e^{2kr}r^{-2(\beta+1)}
             \int_r^\infty e^{-2ks}s^{2(\beta+1)}G(s)\,ds.
 \tag{13}
\]
Any other integration constant produces an exponentially growing
branch of \(H\), incompatible with boundedness. For \(r\) above
a uniform constant, use
\(\log(s/r)\leq(s-r)/r\), (1), and bounded \(\beta\) to bound
the kernel by \(C e^{-\kappa(s-r)}\) with \(\kappa>0\).
It follows that \(\|H'\|\leq C_D r^{-q}\).
Integration gives a limit and an \(O_D(r^{1-q})\) error;
the equation gives \(H''=O_D(r^{-q})\).
No derivative of \(G\) has been assumed.

Initially (12) gives \(q=2\), so \(h=a_0+O_D(r^{-1})\).
The exact conjugated action on \(r^{-j}a(\omega)\) is
\[
 -jk r^{-j-1}a+r^{-j-2}K_ja.
 \tag{14}
\]
Set \(a_1=K_0a_0/k\) and
\(a_2=(K_1a_1+c_3a_0)/(2k)\). Subtracting these terms in order,
(13) first improves the remainder to \(O_D(r^{-2})\), then to
\(E=O_D(r^{-3})\), with
\(E'=O_D(r^{-4})\) and \(E''=O_D(r^{-4})\).
Use finitely more angular derivatives before each step to obtain
the same statements in every requested angular norm. Reflection
makes the functions and their radial remainders odd. The bounded
first angular derivative and the mean-value theorem give the factor
\(|t|\), \(t=\omega_z\), also for \(E'\) and \(E''\).
In particular, no unsupported \(E''=O_D(r^{-5})\) is used.

On a fixed sphere the cutoff construction converges in angular
\(C^s\) at rate \(O_D(\lambda)\). Since
\(\|f/A-a_0\|_{C^1}\leq C_D/r\) uniformly, first choosing a
large radius and then sending \(\lambda\) to zero proves
\(a_0^\lambda\to a_0^0\) in \(C^1\).
At zero coupling \(e>0\) on the upper half-space.
The scalar function \(A_0t(1+M/r)\) is a subsolution there:
after division by \(A_0t\), the \(r^{-2}\) coefficient is
\(1-\beta_0(\beta_0+1)/2-k_0M\).
Choose \(M\) large, then the starting radius large.
On the inner hemisphere \(e/t\) extends to a positive function
at the equator by the boundary point lemma; its compact minimum
is positive. Exterior comparison proves \(a_0^0/t\geq c_D\).
Oddness and \(C^1\) convergence imply
\[
 a_0^\lambda/t\geq c_D,\qquad a_0^{\lambda\,\prime}(0)\geq c_D
 \tag{15}
\]
after decreasing \(I\). The identical scalar comparison and radial
integration for \(b>0\), without \(t\), give its expansion with
positive angular leading coefficient, all needed angular derivatives,
and two radial derivatives. In particular
\[
 c_D e^{-\gamma r}r^{2/\gamma-1}
       \leq b(r,\omega)\leq C_D e^{-\gamma r}r^{2/\gamma-1}.
 \tag{16}
\]
This proves the slow-channel assertions, including uniformity of
the differentiated remainders.

## 3. Complementary matching and ordinary derivative bounds

The conjugated \(Q\)-operator on \(r^{-j}T\) is exactly, to each
finite matching order,
\[
 r^{-j}B_QT-jk r^{-j-1}T+r^{-j-2}K_jT+
       \sum_{m\geq2}r^{-j-m}C_mT,\quad
 C_m=U_m+\lambda QW_mQ.
 \tag{17}
\]
All these operations are on the localized coefficients of Section 2,
not on arbitrary ionic vectors. With the source coefficients \(S_j\)
printed in the manuscript, define
\[
 B_QT_2=S_2,\quad B_QT_3=S_3+2kT_2,\quad
 B_QT_4=S_4+3kT_3-(K_2+C_2)T_2.
 \tag{18}
\]
Weighted inverses and finite moment losses prove uniform localization
and angular smoothness of these vectors. They all have distinguished
spin up.

At \(t=0\) every \(S_j\) vanishes, as do \(T_2,T_3\).
Only the angular Laplacian term survives in the third equation:
\[
 T_4(0)=\tfrac12B_Q^{-1}\Delta_{\mathbb S^2}T_2(0)
       =-a_0'(0)B_Q^{-2}QY_z\phi.
 \tag{19}
\]
To verify the sign and factor without suppressing a product-rule
term, write \(T_2=-a_0B_Q^{-1}QW_2\phi\).
On the equator \(a_0=\Delta_{\mathbb S^2}a_0=0\);
\(\nabla a_0=a_0'(0)e_z\) and
\(\partial_tW_2=Y_z\). The cross term is therefore
\(-2a_0'(0)B_Q^{-1}QY_z\phi\).
The exact angular two-jet computation is also checked by the
standalone verifier and the saved Jacobian Laplacian operation.

Ionic reflection makes \(Y_z\phi\) odd and orthogonal to \(\phi\).
It is nonzero: its multiplier vanishes only on a measure-zero
hyperplane. Injectivity of \(B_Q^{-2}\), (15), and continuity in
the smaller weighted spaces imply a common positive lower bound
on (19). At the equator axial symmetry leaves \(Y_z\phi\) invariant,
so \(T_{\rm eq}\) is independent of equatorial azimuth.

Subtract \(bG+\lambda A\sum_{j=2}^4r^{-j}T_j\) from \(QF\).
The retained \(bG\) has residual
\[
 bQ\{\lambda(|y_1-y_2|^{-1}+W)-E_3(\lambda)+E_3(0)\}G
                   =O_D(\lambda b).
 \tag{20}
\]
Parity, not a claim that \(G\) remains an excited eigenvector,
gives \(Q_\lambda G=G\). Hardy controls its ionic Coulomb factor.
Equation (1) and the differentiated scalar expansion of \(b\)
give \(b/A\leq C_D e^{-\epsilon_D r}r^{C_D}\),
\(\epsilon_D=(\gamma-k_0)/2>0\). Thus (20), with two
ordinary derivatives, is \(O_D(\lambda A r^{-5})\).
This absorption uses a fixed positive rate separation, not a
radius proportional to \(\log(1/\lambda)\).

Matching (18) leaves a slow residual of the same size, with two
ordinary derivatives. The unretained scalar term is multiplied by
\(\lambda QW\phi=O_D(\lambda r^{-2})\), and its second radial
derivative is only required to be \(O_D(r^{-4})\).
Finite localized multipole remainders have the symbol bounds
already proved. \(QR\) is exponentially smaller, with its factor
\(\lambda\). Consequently \(E_Q\) solves a gapped \(Q\)-equation
with a source \(J\) satisfying
\[
 \|\partial_x^\nu J\|\leq C_D\lambda A r^{-5},
                      \qquad |\nu|\leq2.
 \tag{21}
\]
On a fixed starting annulus \(E_Q=O_D(\lambda)\).
Indeed \(Q_\lambda-Q_0=O_D(\lambda)\), \(F_\lambda-F_0\)
has that rate there, the \(T_j\) are uniformly bounded, and
\(Q_0F_0=bG\). Comparing norms against a multiple of
\(\lambda A r^{-5}\), using the positive \(Q\)-gap as in
Section 2, proves \(\|E_Q\|\leq C_D\lambda A r^{-5}\).
The boundary multiple is independent of positive \(\lambda\)
because the boundary numerator has a factor \(\lambda\).
At zero coupling \(E_Q=0\) by its definition.

Here is a local derivative upgrade that includes the unbounded
ionic operator. For compactly supported
\(v\in H_x^2(\mathcal K)\cap L_x^2(\operatorname{Dom}B_Q)\),
Fourier transformation and the spectral theorem give
\[
 \|D_x^2v\|_2+\|B_Qv\|_2
       \leq C\|(-\Delta_x/2+B_Q)v\|_2.
 \tag{22}
\]
The inequality is the pointwise multiplier bound
\(|\xi|^2+b\leq2(|\xi|^2/2+b)\), \(b\geq0\),
followed by the triangle inequality for the two norms.
For a local equation first apply a cutoff energy identity to
control the gradient, then apply (22) with a second cutoff.
All other coefficients and their first two \(x\)-derivatives
are bounded operators on exterior unit balls, uniformly in
the center and \(\lambda\). Difference quotients commute with
\(B_Q\). Two differentiations and nested applications of (22)
therefore give
\[
 \|E_Q\|_{H_x^4(B(x,1/2);\mathcal K)}
 \leq C_D\bigl(\|E_Q\|_{L_x^2(B(x,2))}
                        +\|J\|_{H_x^2(B(x,2))}\bigr)
 \leq C_D\lambda A(r)r^{-5}.
 \tag{23}
\]
The last step uses (21), the norm bound, and bounded variation
of \(A\) on unit balls. Hilbert-valued \(H^4(\mathbb R^3)
\hookrightarrow C^{2,\alpha}\), \(0<\alpha<1/2\), proves the
two ordinary derivative bounds. This establishes assertion 2.

## 4. Three scales, with no division by the coupling

Put \(t=\omega_z\) and
\[
 M=\phi f+bG+\lambda A r^{-4}T_{\rm eq}.
 \]
By the spin decomposition in the source,
\(\|G\|^2=2\) and \(\|G_\uparrow\|^2=\|G_\downarrow\|^2=1\).
For every spin-up \(Q\)-vector \(V\),
\[
 (1-1/\sqrt2)(2b^2+\|V\|^2)
 \leq\|bG+V\|^2
 \leq(1+1/\sqrt2)(2b^2+\|V\|^2).
 \tag{24}
\]
This is Cauchy--Schwarz and
\(2|b|\|V\|\leq(2b^2+\|V\|^2)/\sqrt2\);
it does not assume the fast and induced terms are orthogonal.
The \(P\) term is orthogonal to both. Equations (15), (19),
and the scalar remainder imply
\[
 \|M\|\geq c_D(A|t|+b+\lambda A r^{-4})=c_D S.
 \tag{25}
\]
The exact expansion, including its endpoint factor, gives
\[
 \|F-M\|\leq C_D\lambda A(r^{-2}|t|+r^{-5}).
 \tag{26}
\]
For \(r\geq1\), \(0\leq\lambda\leq1\), its right side is at
most \(C_D S/r\): the first term is at most
\(A|t|/r\), and the second is \((\lambda A r^{-4})/r\).
This argument is valid when \(\lambda=0\), without taking a
quotient by \(\lambda\). Choosing \(R_D\) so that (26) is at
most \(\|M\|/2\) proves the first part of (U1).
The distinguished-down component of \(M\) has norm exactly \(b\).
Thus \(\|F\|\geq\|M\|/2\geq b/2\), proving its absolute ratio.

By (16) and (8) the twice-differentiated density cutoff error
divided by \(\|F\|^2\) is bounded by
\(C_D e^{-2(\sigma-\gamma)r}r^{C_D}\leq C_D/r\),
after enlarging \(R_D\). In particular \(n>0\) in the exterior.
Compact positivity follows from the Section 1 compact convergence.

## 5. Differentiated comparisons and the moving crossover

Let \(D_r=\partial_r+k\) and \(\delta=k-\gamma\).
For an explicit slow term,
\[
 D_r(A r^{-j}a)=(\beta-j)A r^{-j-1}a,\qquad
 D_r^2(A r^{-j}a)=(\beta-j)(\beta-j-1)A r^{-j-2}a.
 \tag{27}
\]
For the scalar remainder the corresponding expressions are
\(A(E'+\beta E/r)\) and
\(A(E''+2\beta E'/r+\beta(\beta-1)E/r^2)\).
Their oddness bounds them by \(C_D A|t|/r\), or better.
The zeros of \(T_2,T_3\) and
\(T_4=T_{\rm eq}+O_D(|t|)\) give the same relative bound
for every explicit complementary term using the first or third
part of \(S\). The differentiated error satisfies, directly,
\[
 \|D_r^jE_Q\|\leq C_D\lambda A r^{-5}\leq C_DS/r,
                          \quad j=0,1,2.
 \tag{28}
\]
The fast scalar expansion gives
\(D_rb=\delta b+O_D(b/r)\) and
\(D_r^2b=\delta^2b+O_D(b/r)\).
Using (U1), therefore,
\[
 \|D_rF-\delta bG\|+
 \|D_r^2F-\delta^2bG\|\leq C_D\|F\|/r.
 \tag{29}
\]
This is a uniform exterior estimate, not merely a fixed-coupling
little-oh statement.

For horizontal derivatives fix horizontal azimuth and \(z\), and set
\(s=p/r\). In the cone \(0\leq z\leq p/2\),
\[
 \partial_p=s\partial_r-st\,\partial_t/r,\quad
 \partial_pt=-st/r,\quad \partial_ps=t^2/r.
 \tag{30}
\]
The latitude coordinate is nonsingular there. Acting once or twice
with its angular part retains a factor \(t\) for every smooth
coefficient vanishing at the equator, since
\((t\partial_t)^2=t\partial_t+t^2\partial_t^2\).
For \(T_4\), derivatives of its constant equatorial part vanish,
and the remaining angular terms are bounded using \(A|t|\).
The ordinary bounds handle \(E_Q\). Thus
\[
 \|(\partial_p+ks)F-\delta s bG\|
                           \leq C_D\|F\|/r.
 \tag{31}
\]
On the fixed strip, \(1-s=O_L(p^{-2})\), its derivative is
\(O_L(p^{-3})\), and \(t=O_L(p^{-1})\).
Applying (27)--(30) to the explicit terms, with (28) for the
error, gives for \(D_p=\partial_p+k\)
\[
 \|D_pF-\delta bG\|+
 \|D_p^2F-\delta^2bG\|\leq C_D\|F\|/p.
 \tag{32}
\]
For clarity, when a coefficient vanishes at the equator its two
horizontal derivatives use \(t a'(t)\) and
\(t a'(t)+t^2a''(t)\), both \(O_D(|t|)\);
the coefficients generated by differentiating \(s,t,r^{-1}\)
have an additional inverse power of \(r\).
All nonvanishing \(T_{\rm eq}\) contributions retain the factor
\(\lambda A r^{-4}\). This accounts for every scale in (32),
including the smallest vertical values \(z=0\).

There is no hidden crossover exception in (28)--(32).
Writing \(a=A|t|\), \(c=\lambda A r^{-4}\), \(q=1/r\),
the only potentially dangerous relative numerator in (26) is
\(\lambda q^2a+qc\). The exact nonnegative difference is
\[
 q(a+b+c)-(\lambda q^2a+qc)
       =qa(1-\lambda)+\lambda qa(1-q)+qb\geq0.
 \tag{33}
\]
Every derivative-error numerator in (28) is at most \(C_Dqc\).
Equations (33) and (25), not an eventual-tail dominance argument,
are what allow one radius for the whole closed coupling interval.

## 6. Density constants and the vertical ratio

Since \(\|bG\|/\|F\|\leq2\sqrt2\), (29), (31), and (32),
with the product rule for the squared norm, yield
\[
 \begin{split}
 |(\partial_r+2k)\|F\|^2|/\|F\|^2
       &\leq4\sqrt2|\delta|+C_D/r,\\
 |(\partial_p+2ks)\|F\|^2|/\|F\|^2
       &\leq4\sqrt2|\delta|+C_D/r,\\
 |(\partial_p+2k)^2\|F\|^2|/\|F\|^2
       &\leq(16+4\sqrt2)\delta^2+C_D/p
                  \quad(0\leq z\leq L).
 \end{split}
 \tag{34}
\]
For the last identity use exactly
\[
 (\partial_p+2k)^2\|F\|^2
       =2\|D_pF\|^2+2\operatorname{Re}\langle F,D_p^2F\rangle.
 \]
All cross-error terms are \(O_D(1/p)\), since \(\delta\) is
uniformly bounded. The density cutoff error and its two derivatives
are relatively \(O_D(1/r)\), as proved after (26). Replacing
\(\|F\|^2\) by \(n\), or multiplying by \(e^{2kp}\), therefore
preserves these bounds with that error. Summing the strip first
and second bounds uses
\(4\sqrt2<6\), \(16+4\sqrt2<22\), both below \(100\).
Taking suprema proves (U2) with the explicit form \(C_D/R\)
of the source's vanishing function \(\rho_D(R)\).

For the ratio fix \(0\leq z\leq L\). Since
\(r-p=O_L(p^{-1})\), the expansions and (15)--(19) give
\[
 C_z=\phi a_0'(0)A(p)z/p+b(p,0)G+
                  \lambda A(p)p^{-4}T_{\rm eq},\qquad
 \|F(p,z)-C_z\|\leq(C_D/p)\|C_z\|.
 \tag{35}
\]
In detail \(A(r)/A(p)=1+O_D(p^{-1})\);
\(a_0(t)=a_0'(0)t+O_D(t^3)\); the lower scalar terms contribute
\(O_D(A(p)z/p^2)\);
\(b(p,z)/b(p,0)=1+O_D(p^{-1})\);
the \(T_2,T_3\) contributions are
\(O_D(\lambda A(p)z/p^3)\); and the remaining complementary
errors are \(O_D(\lambda A(p)p^{-5})\).
Each is controlled by its corresponding term of the three-scale
sum; (24) converts that sum to \(\|C_z\|\).
These statements remain valid uniformly at \(z=0\) and \(\lambda=0\).

By (24) the squared comparison norm lies between
\(c_-Q(z)\) and \(c_+Q(z)\), where \(c_\pm=1\pm1/\sqrt2\) and
\[
 Q(z)=|a_0'(0)|^2A(p)^2z^2/p^2+
                2b(p,0)^2+\lambda^2A(p)^2p^{-8}\|T_{\rm eq}\|^2.
 \]
This is nondecreasing in \(z\). Choose a common \(p\) threshold
so that the norm error in (35) and the relative density cutoff
error are each at most \(1/10\). For \(z_1\leq z_2\),
\[
 \frac{n(p,z_1)}{n(p,z_2)}
 \leq (11/9)^3\,\frac{c_+}{c_-}
 = (11/9)^3(3+2\sqrt2)
 <6(11/9)^3<20.
 \tag{36}
\]
This proves (U3) and completes the uniform implication.

## Source findings, limitations, and handoff

The exact source anchors, also checked by the verifier, are:

| Assertion | Lines in `02-channels.tex` |
|---|---:|
| `lem:channel-cutoff`; residual; density cutoff error | 130; 149; 155 |
| Cutoff residual identity | 247 |
| `lem:channel-expansion`; differentiated scalar remainder | 378; 396 |
| Scalar channel recursion | 515 |
| `lem:plane-coefficient`; complementary remainder | 559; 569 |
| Equatorial coefficient; complementary recursion | 580; 619 |
| Three-scale lower bound; quantitative density drift | 773; 878 |

The algebra tested here supports, rather than refutes, the quoted
recursions. The proof does not identify a false literal assertion.
In particular the extra parameter tracking required for a citation
is supplied above; the fact that a cited fixed-parameter theorem
does not itself state a uniform-family result is **not** being
misreported as a counterexample to the manuscript.

The literature reader obtained the exact requested arXiv versions.
The source already knows the nodal-plane mechanism, and its
asymptotic matching is not a uniform differentiated remainder theorem.
One targeted search found no matching uniform crossover theorem;
that bounded negative retrieval is not evidence of novelty.
The publisher endpoints were unavailable to that reader.
No use of their uninspected published revisions is made.

The independent Reviewer must judge the analytic proof, its Section 1
input boundary, and source fidelity, and rerun `verify.py`. No
independent-review verdict, publishability decision, or main-theorem
closure is asserted by the Engineer. The remaining graph nodes,
including the angle gap, ensemble transfer, obstruction, and charge
selection, remain open. No `.lean` file is introduced: the selected
uncertainty is analytic and is not replaced by a formal coefficient
calculation.
