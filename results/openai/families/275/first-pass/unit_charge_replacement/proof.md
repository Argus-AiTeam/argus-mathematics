# Area-uniform Coulomb cubature and continuum-complement elimination

## Result and scope

This is an analytic proof, with separately executable exact algebraic
checks. It is not a formalization of the analytic theorem or a proof of
either complete QMA-hardness reduction.

For the construction in the unit-charge manuscript, the first bound of
`prop:nuclear-replacement` can be strengthened:

\[
 |(L_p-L_c)[u]|
 \le p(n,D)\lambda^{-1}
             \bigl(\|u\|_2^2+\|\nabla u\|_2^2\bigr).                 \tag{A}
\]

The compressed bound is \(p(n,D)\lambda^{-4/3}\), as asserted.
Assuming the upstream continuous control (6), the complementary-space
loss improves from the asserted \(p(n,D)\lambda^{-4/3}\) to
\(p(n,D)\lambda^{-9/5}\). Assuming also the continuous compressed
matrix comparison described below, equation (9) follows. All constants
are independent of \(H\) and of the horizontal area. Polynomial factors
are displayed before conversion to the manuscript's notation.

The improvement over the manuscript is the bounded vector primitive of
the Coulomb kernel, not a smaller constant in its absolute-potential
argument. A bounded search for an existing theorem giving this particular
transported, area-uniform pair of estimates found no matching primary
source. That search does not establish novelty. Publishability, novelty,
the analytic proof, and its application still require independent review.
No false assertion in the staged mathematical manuscript is claimed here.

### Sources and limitations established before using the reduction

* The staged unit manuscript's `build/sections/wells.tex` fixes
  \(h=1/k,\lambda=8k^3/\rho,D=\log\lambda\), the separated modes, and the
  meaning of \(p(n,D)\). Its `density.tex` fixes
  \(H=\lceil\lambda^5\rceil\), integer \(S\) between \(D\) and \(10D\),
  \(V_\ell\), (4), and the upstream statement (6). The present proof
  resolves (7) in `nuclei.tex` and the transfer argument in `many-body.tex`;
  it does not independently certify all the preceding spectral and
  finite-model estimates.
* Cubitt--Montanaro--Piddock, *Universal quantum Hamiltonians*,
  **arXiv:1701.05182v4**, equation (205) and Section 10.1, pp. 66--67:
  the spatially sparse branch uses a constant number of gadget rounds
  and polynomial interaction scales. This source is not an obstruction
  to the manuscripts' polynomially weighted source problem. It does not
  assert bounded-strength hardness. The exact version was obtained from
  `https://arxiv.org/pdf/1701.05182v4`; the relevant text is retained in
  `cmp-v4.txt`, lines 3497--3545.
* The binary-charge manuscript has separate load-bearing relative-tail,
  tuning, and all-state continuum propositions. Reading their statements
  is not a verification of that independent reduction. They remain open
  in the dependency graph.
* The primary public Comparator source
  `https://raw.githubusercontent.com/openai/math/main/lean/ComparatorChallenges/ContinuumCoulombHardness.lean`
  was inspected. The bodies of `unit_coulomb_qmaHard` and
  `binary_coulomb_qmaHard` are both `sorry`. Its accompanying
  `lean/docs/275.md` is therefore not evidence of completed proofs of
  those declarations. No Comparator source is staged in this campaign;
  the inspected declaration excerpt is retained as `comparator_excerpt.txt`.
* The supplied Wiki index contained no Coulomb, QMA, nuclear-replacement,
  or campaign-9000275 entry. It supplied no mathematical premise.
* The inspected Jacobian 0.14.0 operation
  `moment_functional.gaussian_quadrature.compute` only promises rational
  nodes. The actual interval moments \(1,0,1/3,0\) were submitted without
  changing the problem. The adapter returned a sidecar transport error,
  exit 2, not a mathematical answer. No conclusion uses that failed run.
  The contract, payload, output, and exit status are retained separately.

The direct use of an arbitrary-state form error as a linearly amplified
energy error is an insufficient route: the original bound gives
\(\lambda\lambda^{-2/3}=\lambda^{1/3}\), and even (A) gives no vanishing
bound by that shortcut. The fixed gap and the mixed block must be used.
The manuscript explicitly makes this distinction; it is not a refutation.

## 1. A uniform theorem for a transported grid

Let \(0<h\le1\), let \(\Omega\subset\mathbb R^3\) be a finite union of
axis-aligned closed grid cubes of side \(h\) with disjoint interiors, and
let \(\rho>0\). On each cube use the eight tensor two-point Gauss nodes,
with mass \(w=\rho h^3/8\) at each node. Let \(G:\mathbb R^3\to\mathbb
R^3\) be a \(C^4\) diffeomorphism. Suppose its derivatives of orders
1--4 and its inverse Lipschitz constant are bounded by a fixed \(B\).
Let \(E\) contain the support of \(G-\mathrm{id}\), and let \(E_h\)
be the union of grid cubes meeting \(E\). Write \(V=|E_h\cap\Omega|\).
The result also applies to the case \(G=\mathrm{id}\), with \(V=0\).

Define, as a form on \(H^1(\mathbb R^3)\),
\[
 W(y)=\rho\int_\Omega |y-G(b)|^{-1}\,db
                      -w\sum_\alpha |y-G(a_\alpha)|^{-1}.
\]
There is a constant \(C_B\), independent of the number and placement of
cubes, such that
\[
 |W[u]|\le C_B\rho(h^3+h^4V)\|u\|_{H^1}^2.                       \tag{B}
\]
The same coefficient bounds the absolute mixed form
\(|W(u,v)|\) by \(\|u\|_{H^1}\|v\|_{H^1}\).

For compression, suppose real normalized modes \(\psi_i\), \(1\le i\le m\),
have centers \(c_i\) and satisfy
\[
 |D^\alpha\psi_i(y)|\le A e^{-a|y-c_i|}\quad (|\alpha|\le4),\qquad
 \lambda_{\min}(\Gamma)\ge\gamma_0>0,                             \tag{C}
\]
where \(A,a,\gamma_0\) are independent of the size of \(\Omega\).
Here \(\Gamma_{ij}=\langle\psi_i,\psi_j\rangle\); the modes need not be
orthogonal. If \(P\) is projection on their span, then
\[
 \|PWP\|\le C_{B,A,a}\rho\,m\gamma_0^{-1}(1+V)h^4.                \tag{D}
\]
Spin copies do not increase this one-particle norm.

If every mapped node is moved by at most \(\delta\), put \(M=\rho|\Omega|\).
The additional error obeys
\[
 |W_{\rm round}(u,v)|\le4M\delta\|\nabla u\|_2\|\nabla v\|_2,
 \qquad
 \|PW_{\rm round}P\|\le4M\delta K_P,                              \tag{E}
\]
where \(K_P=\sup_{\|v\|=1,v\in P}\|\nabla v\|_2^2\).
These statements include singular evaluation points; they are form
statements, not pointwise bounds on \(W\).

## 2. Proof of the stronger form estimate

Put \(J(x)=x/(2|x|)\) for \(x\ne0\), assigning any bounded value at
zero. Direct differentiation gives
\[
 \operatorname{div}J=|x|^{-1},\quad |J|=1/2,\quad
 |D^jJ(x)|\le C_j|x|^{-j}\quad(1\le j\le4).                      \tag{F}
\]
The divergence identity holds distributionally: integration by parts
outside a radius-\(\epsilon\) ball has an omitted boundary term bounded
by \(2\pi\epsilon^2\|\phi\|_\infty\), which tends to zero.
There is no delta mass. The verifier checks the differential identity
and exact homogeneous derivative numerators, not this distributional
passage.

Define the bounded-vector cubature error
\[
 A_h(y)=\rho\int_\Omega J(y-G(b))\,db
                           -w\sum_\alpha J(y-G(a_\alpha)).
\]
It satisfies \(\operatorname{div}A_h=W\).
On a cube, the rule annihilates the Taylor polynomial through total
degree three. The remaining error for a \(C^4\) function is bounded
by \(C\rho h^7\sup_Q|D^4f|\).

For fixed \(y\), declare a cube near if its image meets a ball of radius
\(R_Bh\) about \(y\), with fixed sufficiently large \(R_B\).
There are at most \(C_B\) near cubes: their preimages lie in a ball of
radius \(C_Bh\), by the inverse Lipschitz bound. Since \(J\) is bounded,
their total error is at most \(C_B\rho h^3\), even if \(y\) is a node.

On far cubes all distances to \(y\) within an image are comparable.
The fourth-order chain rule bounds the derivative by
\[
 C_B\left(r^{-4}
            +{\bf1}_{E_h}\sum_{j=1}^3r^{-j}\right),
 \qquad r=|y-G(b)|.
\]
The first term includes \((DG)^4D^4J\).
Every other term has a derivative of \(G\) of order at least two
and hence vanishes off \(E_h\).

To sum suprema, integrate over each cube and change variables by \(G\).
Comparability of distances and the determinant bound give, for the
pure term,
\[
 h^7\sum_{\rm far}\sup_Q r^{-4}
 \le C_B h^4\int_{|x-y|\ge c_Bh}|x-y|^{-4}\,dx
 = C_B' h^3.
\]
This integral is over all of \(\mathbb R^3\), not over a box whose
volume is silently absorbed in a constant. For the other terms, where
\(r\le1\) use \(r^{-j}\le r^{-4}\); where \(r>1\) use
\(r^{-j}\le1\) and the volume bound \(|G(E_h)|\le C_BV\).
Their summed errors are at most \(C_B(h^3+h^4V)\).
Consequently
\[
                       \|A_h\|_\infty\le C_B\rho(h^3+h^4V).
\]

For compactly supported smooth \(u,v\), integration by parts gives
\[
 W(u,v)=-\int A_h\cdot
                 (\overline u\nabla v+v\nabla\overline u).
\]
Cauchy--Schwarz in the two components \((\|u\|,\|\nabla u\|)\)
and \((\|\nabla v\|,\|v\|)\) proves (B) and its mixed version.
Extension to \(H^1\) follows by density. Each Coulomb form involved is
continuous on \(H^1\), as also follows from the Hardy estimate below.
No boundary condition on \(u\) at \(\partial\Omega\) is imposed.

## 3. Compression, transport, rounding, and the actual modes

For \(f_{ij}=\psi_i\psi_j\), (C) and Leibniz's rule give uniform
exponentially decaying derivative bounds centered at \(c_i\): the other
factor and its derivatives are uniformly bounded. Define
\[
 K_{ij}(b)=\int |y-b|^{-1}f_{ij}(y)\,dy.
\]
Transferring derivatives to \(f_{ij}\), using the locally integrable
kernel, shows that derivatives through order four are uniformly bounded.
Indeed, for every exponentially bounded \(g\),
\(\sup_b\int |y-b|^{-1}|g(y)|\,dy<\infty\): split
\(|y-b|\le1\) and its complement.

More precisely,
\[
                  |D^4K_{ij}(b)|\le C(1+|b-c_i|)^{-5}.            \tag{G}
\]
For \(d=|b-c_i|\ge2\), choose a smooth cutoff equal to one for
\(|y-c_i|\le d/3\), supported in \(|y-c_i|\le d/2\), with derivative
bounds \(C_\ell d^{-\ell}\). Hold this cutoff fixed while evaluating
the derivatives at the particular \(b\). On its support differentiate
the kernel, giving \(Cd^{-5}\|f_{ij}\|_1\).
On the remaining part transfer all four derivatives to the cut-off
density. Its derivatives are bounded by
\(Ce^{-ad/6}e^{-a|y-c_i|/2}\), so their Coulomb fields are
bounded by \(Ce^{-ad/6}\). This proves (G); for \(d<2\) use the
global bound. This argument does not differentiate a cutoff depending
on the variable \(b\).

Apply the cell Taylor estimate to \(K_{ij}\circ G\).
For the pure term, the sum of cell suprema times \(h^3\) is bounded by
\(C_B\int(1+|x-c_i|)^{-5}\,dx\), uniformly in \(c_i,\Omega\).
All nonpure terms use the global lower derivative bounds on \(K_{ij}\)
and occur only in \(E_h\). Thus every matrix entry is bounded by
\(C\rho(1+V)h^4\).
The entry bound gives matrix norm at most \(m\) times this bound.
Changing to orthonormal modes multiplies the matrix on both sides
by \(\Gamma^{-1/2}\), costing at most \(\gamma_0^{-1}\).
This proves (D). Also
\(K_P\le m\gamma_0^{-1}\max_i\|\nabla\psi_i\|^2\), so it is
polynomially bounded for the actual modes.

Here is why these hypotheses apply to the manuscript, without assuming
the disputed estimates. Its \(f=(1-|r|^2)_+^{16}\) is compactly
supported with more than six continuous bounded derivatives.
The positive heat-kernel formula for
\(\phi=(-\Delta+1)^{-1}f\), moving derivatives onto \(f\), gives
exponential upper bounds for derivatives through order six, with any
fixed decay exponent less than one. Positivity on the compact support
of \(f\) bounds the derivatives of \(W=-f/(2\phi)\).
The fixed-frequency Gaussian and its derivatives decay exponentially
as well. Hence the \(\psi_i\) satisfy (C), for example with a fixed
smaller exponential rate. The separated-center overlap estimate makes
\(\lambda_{\min}(\Gamma)\ge1/2\) at sufficiently large polynomial
scale. One can obtain that estimate directly by splitting the decay
between the two centers, integrating the remaining exponential, and
summing the \(m-1\) off-diagonal entries in each row.

The potentials \(\zeta(z/S)(1+b_i/\lambda)W(r-u_i)\) have
uniform derivatives through order six, since the planar supports are
disjoint, \(S\ge1\), and \(0\le b_i/\lambda<1\).
Thus \(q_t=\rho+t\Delta V_\ell/(4\pi)\ge\rho/2\), and
\(-\nabla V_\ell/(4\pi q_t)\) has uniform \(C^4\) bounds and is
zero off the well cylinders. Differentiating its flow equations and
applying the elementary integral form of Gronwall's inequality gives
uniform bounds for \(DG,\ldots,D^4G\) and for the inverse Lipschitz
constant on \(0\le t\le1\). These constants do not contain \(m,H,S\).
The flow is the identity off the cylinders and preserves the box.
Differentiating its Jacobian yields
\[
 \frac{d}{dt}\{q_t(G_t(b))\det DG_t(b)\}
 =(\partial_tq_t+\operatorname{div}(q_t{\cal V}_t))(G_t(b))
                                                    \det DG_t(b)=0.
\]
This proves the required transport and preservation of equal masses.
The union of cells meeting the cylinders has volume
\(V\le C m(S+1)\), uniformly for \(h\le1\).
This explicitly accounts for transport transitions.

For rounding, the triangle inequality gives
\[
 \left||y-b|^{-1}-|y-\widetilde b|^{-1}\right|
              \le\delta/(|y-b|\,|y-\widetilde b|).
\]
The translated Hardy inequality
\(\int |u|^2/|y-b|^2\le4\int|\nabla u|^2\) follows by integrating
\(\operatorname{div}((y-b)/|y-b|^2)=|y-b|^{-2}\) and applying
Cauchy--Schwarz, first with cutoffs and then by density.
Apply it to the two factors in the mixed form and sum the masses.
This proves (E), with no dependence on the number of nuclei except \(M\).

For the manuscript's exact choices,
\[
 \begin{split}
 |\Omega|&=8H^2S,\quad
 M=8\rho H^2S,\quad
 \#\{\text{nodes}\}=64H^2Sk^3=8\rho H^2S\lambda,\\
 M\delta_R
 &\le\frac{8\rho H^2S}{(1+H)^3(1+S)^2\lambda^3}
 \le\frac{8\rho}{HS\lambda^3}
 \le8\rho\lambda^{-8}.                                         \tag{H}
 \end{split}
\]
Only \(H\ge\lambda^5,S\ge1\) was used in the last step; the ceiling
does not cause a loss. Its upper bound \(H<\lambda^5+1\) keeps the
number of nodes polynomial. Integer \(H,S,k\) ensure exact tiling.

Unmapped Gauss nodes have mutual separation at least \(h/3\).
The inverse Lipschitz bound therefore gives separation at least
\(h/(3B)\) after transport. At sufficiently large scale,
\(2\delta_R<h/(3B)\), so rounded nodes remain distinct.
The physical positions are rational because both the rounded positions
and \(\lambda=8k^3/\rho\) are rational.

Combining (B)--(H), \(h^3=8/(\rho\lambda)\), and \(h\le1\), gives
\[
 \epsilon_f\le C(1+m(S+1))\lambda^{-1},\qquad
 \epsilon_c\le C m(1+m(S+1))\lambda^{-4/3}
                         +32\rho K_P\lambda^{-8}.               \tag{I}
\]
Constants may depend on the fixed well, cutoff, and \(\rho\), but
not on \(n,D,\lambda,H\). Since \(m\) is polynomial in \(n\) and
\(S\le10D\), (I) proves (7), with a stronger first exponent.

## 4. All-state complement elimination with explicit constants

This section is an abstract consequence of (I) and (6), not an
independent proof of (6). Set \(Q=I-P\), and assume
\[
 QL_cQ\ge cQ,\qquad L_c\ge-\Delta/2-C,\qquad
 \|L_cP\|\le a,\quad a\le p(n,D)\lambda^{-9/10},                  \tag{J}
\]
with fixed \(c>0,C\ge0\). Decomposing a one-particle vector and
using \(2a xy\le(c/2)y^2+(2a^2/c)x^2\) gives
\[
 L_c\ge(c/2)Q-bI,\qquad b=a+2a^2/c.
\]
For \(m\) particles, let \(\Pi=\prod_{\ell=1}^mP_\ell\) and
\(A=\sum_\ell(L_c)_\ell\). Since
\(\sum_\ell Q_\ell\ge I-\Pi\), if \(mb\le c/4\), then
\(A[q]\ge g\|q\|^2\) for \(q\in\ker\Pi\), with \(g=c/4\).
Also \(A\ge\frac12\sum_\ell(-\Delta_\ell)-Cm\).
Take the convex combination with kinetic weight
\[
 \theta=\frac{g}{2(g+Cm+1)},\qquad
 \kappa=\frac{g}{4(g+Cm+1)}.
\]
It gives \(A[q]\ge\kappa\|q\|_1^2\); the \(L^2\) coefficient
is at least \(g/2\), and the gradient coefficient is exactly
\(\kappa\). In particular \(\kappa^{-1}\) is polynomial in \(m\).

Let \(L^2=1+mK_P\), and write
\({\cal H}=A+\sum_\ell W_\ell+\lambda^{-1}{\cal R}\).
The mixed version of (I), applied fiberwise, gives
\[
 \left|\sum_\ell W_\ell(u,v)\right|
       \le\eta\|u\|_1\|v\|_1,\qquad \eta=m\epsilon_f .
\]
For \(w\in\Pi\), one has \(\|w\|_1\le L\|w\|\) and
\(\|Aw\|\le ma\|w\|\).
Fiberwise Hardy gives
\(\||y_\ell-y_s|^{-1}w\|\le2\|\nabla_\ell w\|\).
Consequently
\[
 \|{\cal R}w\|\le R_0\|w\|,\qquad
                         R_0=m(m-1)\sqrt{K_P}.
\]
These statements hold on the entire tensor product of the spin modes,
and hence on every antisymmetric spin sector. The projections preserve
the \(H^1\) domain: derivatives in a projected coordinate are controlled
by \(K_P\), and the other derivatives commute with that projection.

If \(\eta\le\kappa/2\), positivity of \({\cal R}\) gives
\({\cal H}[q]\ge(\kappa/2)\|q\|_1^2\).
The compressed form has norm at most
\[
                    d=ma+m\epsilon_c+\lambda^{-1}R_0.
\]
Require \(d\le\kappa/4\), and let \(E_\Pi\) be its lowest eigenvalue.
The mixed block is bounded by
\[
 |{\cal H}(q,w)|\le\beta\|q\|_1\|w\|,\qquad
                \beta=ma+\lambda^{-1}R_0+\eta L.
\]
For a normalized \(u=w+q\) and \(\alpha=\kappa/4\),
\[
 \begin{split}
 {\cal H}[u]-E_\Pi
 &\ge\alpha\|q\|_1^2-2\beta\|q\|_1\|w\|\\
 &\ge-\beta^2\|w\|^2/\alpha
 \ge-4\beta^2/\kappa.                                          \tag{K}
 \end{split}
\]
The middle inequality is the exact identity
\(\alpha y^2-2\beta xy+\beta^2x^2/\alpha
  =(\alpha y-\beta x)^2/\alpha\).
This is the square-completion component formalized in Lean.
Testing a minimizing vector in \(\Pi\) gives the upper bound.

All required smallness conditions are polynomial: \(K_P,L,R_0,m\)
and \(\kappa^{-1}\) are polynomial in \(n,D\), while (I) and (J)
decay as fixed positive powers of \(\lambda\). In particular
\[
 \beta\le p(n,D)\lambda^{-9/10},\qquad
 E_\Pi-p(n,D)\lambda^{-9/5}
       \le\inf\operatorname{Spec}{\cal H}\le E_\Pi.              \tag{L}
\]
This implies (8). No eigenvector or binding hypothesis for the full
operator was used.

## 5. Precisely conditional transfer to equation (9)

The remaining upstream matrix input is
\[
 \left\|\lambda\,\Pi(A+\lambda^{-1}{\cal R})\Pi-H_d\right\|
                  \le\delta_0,\qquad
 \delta_0\le p(n,D)\lambda^{-1/10},                              \tag{M}
\]
after the fixed identification with the finite fermion space.
It packages the continuous one-body compression, the retained direct
repulsion, Gram correction, and the polynomial counting of creation
and annihilation monomials. Those are separate manuscript obligations;
this proof neither assumes (7) nor assumes an all-state version of (M).

Finite-dimensional variational comparison, (D), and (K) give the
explicit transfer inequality
\[
 \left|\lambda\inf\operatorname{Spec}{\cal H}-E(H_d)\right|
       \le\delta_0+\lambda m\epsilon_c
                                      +4\lambda\beta^2/\kappa.  \tag{N}
\]
The last two terms are respectively
\(p(n,D)\lambda^{-1/3}\) and
\(p(n,D)\lambda^{-4/5}\); both fit within
\(p(n,D)\lambda^{-1/10}\). This is (9), conditional exactly on
(J) and (M), not on any presumed absence of continuum states.

## 6. What the executable evidence certifies

Run
`$WORKSPACE/argus-live-update/.venv/bin/python research/unit_charge_replacement/verify.py`.
It checks exact tensor moments, the kernel and primitive differential
identities and homogeneous derivative bounds, the rounding polynomial
inequality, mass/count identities, square completion, convex-combination
coefficients, and the scale exponents for all parameters symbolically.
It compares the result with `exact_certificate.json`; it is not a
finite-size search or a numerical quadrature experiment.

`Main.lean` separately proves the degree-three tensor moment identity,
the quadratic square-completion lower bound, and the positive-variable
rounding denominator inequality. `statement_fidelity.md` describes the
precise formal statements. The official Lean 4.31.0 run succeeded with
exit code zero, no proof holes, and a successful axiom audit; its current
certificate is
`lean/certificates/C_UCR_CORE-5ddb6652cc950c48.json`.
It checks these statements only. The analytic integrations, ODE regularity,
Sobolev-domain passages, and applicability of (J) and (M) are not
formalized; they remain explicitly visible to the independent Reviewer.
