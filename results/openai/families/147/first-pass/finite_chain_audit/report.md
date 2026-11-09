# Finite-chain endpoint isolation

## Scope and primary-source record

This audit concerns `thm:lens-lines` and `thm:lens-points` in
`Rigidity-of-Smooth-Billiards-with-a-Continuous-Caustic-Collar-September-24-2026/build/sections/04-continuation.tex`.
It does not certify the near-boundary Birkhoff theorem, the analytic
regularization in Sections 2--3, or the subsequent no-patch theorem.
The manuscript is the source of the assertion under examination, not an
assumption that it is true.

The relevant source passages are:

| Location in `04-continuation.tex` | Assertion requiring examination |
|---|---|
| lines 119--216, `cont:web-continuation` | Formal weighted web relations converge, continue through the positive rectangle, and extend to the common-coordinate edge. |
| lines 225--235, `thm:lens-lines` | Intermediate lines and their derivatives are algebraic over the endpoint differential field. |
| lines 291--338 | Higher profile jets can be eliminated in a finite localized polynomial ring. |
| lines 339--384 | A nonisolated finite core gives coefficientwise convergent profile variations reaching the edge. |
| lines 385--442 | The scaled line action has constant stationary value, forcing the leading profile variation to vanish. |
| lines 443--488 | A generic, injective evaluation lifts scalar algebraicity to function-field algebraicity. |
| lines 495--508, `thm:lens-points` | Point and edge determination requires the area coefficient in addition to endpoint positions. |
| paragraphs at lines 510, 562, 628, 665, 768 | Mixed-data elimination, web continuation, scaled point action, and function-field return. |
| lines 974--981, `thm:no-patch` | Endpoint algebraicity is subsequently used in a different continuation argument. |

Two literal passages fix the fidelity requirements:

> "The variations are initially formal; to compare them as the impacts
> coalesce, we need convergence and continuation to the coalescing edge."

> "Allow the interior occurrences of the graph to be independent functions
> \(F_i\), while keeping \(F_0=F_k=F\) fixed."

In the line case **all positive-order** endpoint derivatives of the critical
value are prescribed; its additive constant is not. In the point case only
**mixed** endpoint derivatives are prescribed; an additive function of each
endpoint separately is not prescribed. A counterexample using less data,
changing the endpoint graphs, reversing a length branch, or dropping the real
positive-curvature base configuration would not refute these assertions.

At the start of this mission the ledger contained only the campaign objective,
with no earlier mathematical certificate. A targeted search of the supplied
Wiki index for billiards, Birkhoff, lens determination, finite webs, and
coalescence found no relevant page. Consequently no inherited Wiki proposition
is used.

### Literature boundary

A bounded primary-source search did not locate an earlier statement or a
counterexample to this exact arbitrary-length, independent-profile
factorization/isolation principle. That is not a proof of novelty.

* Bialy--Mironov, *Annals of Mathematics* 196 (2022), Section 2,
  DOI `10.4007/annals.2022.196.1.2`, gives the one-step support action and twist,
  not arbitrary-chain factorization uniqueness.
* Glutsyuk, `arxiv:1405.5990v4`, Theorems 1.7 and 5.6, classifies
  four-reflective analytic billiards. Open families of periodic quadrilaterals
  are different data from the endpoint-action germ here.
* Plakhov--Tabachnikov--Treschev, `arxiv:1602.07961v1`, Theorem 1,
  gives nonunique two-mirror systems for a parallel-beam correspondence.
  That is only a Lagrangian subset of ray data, not the two-variable action
  germ or the specified coalescing branch.
* Glutsyuk, `arxiv:2005.02657v5`, Theorems 1.9--1.11, concerns density of
  reflection pseudogroups, not equality of fixed-length factorizations.
* Glutsyuk--Izmestiev--Tabachnikov, `arxiv:1909.09028v1`, Theorem 3,
  is local but assumes string-construction/foliation properties.
* Noakes--Stoyanov, `arxiv:1402.6445`, Theorem 1.2 and Corollary 1.3,
  uses global exterior travelling-time data for disjoint convex obstacles.

Goldberg--Lychagin, `arxiv:math/0605124v1`, Sections 1--2, and
Henaut, DOI `10.4007/annals.2004.159.425`, concern the classical finite-type
theory of abelian web relations. Their existence does **not** by itself imply
weighted mirror-factorization uniqueness. In particular, the search service's
suggestion that maximal-rank web theory automatically gives this uniqueness
is not used as a mathematical input.

The standard algebraic inputs actually used below are Noetherianity of a
finite-type localized algebra, complex algebraic curve selection, and
algebraicity of an isolated point over its coefficient field. They will be
distinguished from the web and scaling arguments proved here. The directly
read Noetherian source is the Stacks Project, Lemma 10.31.1 (Tag `00FN`):

> Any finitely generated ring over a Noetherian ring is Noetherian.
> Any localization of a Noetherian ring is Noetherian.

The directly read field-theoretic source is the Stacks Project,
Theorem 10.34.1 (Tag `00FV`):

> For any maximal ideal \(\mathfrak m\subset k[x_1,\ldots,x_n]\)
> the field extension \(\kappa(\mathfrak m)/k\) is finite.

No literature theorem about billiard rigidity is being assumed to establish
the local isolation assertion.

### Computational boundary

The Argus Jacobian adapter reports server `jacobian` version `0.14.0`,
protocol `2025-11-25`. Discovery returned bounded rational-polynomial
elimination and univariate truncated rational-series operations.
The inspected operation `polynomial.ideal.elimination.compute` accepts at
most eight variables over \(\mathbb Q\), with an enforced finite wall-time
budget. It is suitable for a small complex power-sum obstruction, but is
not a contract for analytic continuation, coefficientwise convergence,
arbitrary chain length, or specialization of meromorphic function fields.

The first bounded adapter calculation uses the first three power sums and
the saturation equation \(u f_1=1\). Its exact input is
`jacobian_payload.json`. A unit elimination ideal would exclude a nonzero
first coordinate in that three-variable limiting problem, not establish
the endpoint-isolation theorem. Custom exact code, if used below, is for
the symbolic jet/scale identities and independent replay not supplied by
that finite typed contract.

Checking limiting power sums alone is an insufficient route: it says
nothing about whether an algebraically admissible formal profile variation
converges and reaches the coalescing edge. That route is explicitly retired
in the claim ledger, rather than promoted to a verification theorem.

## 1. The local theorem

The result below is a **mathematical proof with an exact symbolic replay of
its algebraic identities**, not a computer proof of analytic continuation.
Independent review is still required. No false assertion in the two
isolation arguments has been established.

**Theorem 1 (local finite-chain profile isolation).** Fix \(k\geq2\).

**Line case.** Let \(h\) be a real-analytic support germ on a real interval,
with \(r=h+h''>0\). For \(b=a+\delta\), \(\delta>0\) sufficiently small,
take the stationary branch of
\[
 S_h(a,b)=\mathop{\rm crit}_{\alpha_1,\ldots,\alpha_{k-1}}
 \sum_{i=1}^k
 2h\!\left({\alpha_{i-1}+\alpha_i\over2}\right)
 \sin\!\left({\alpha_i-\alpha_{i-1}\over2}\right),
 \qquad \alpha_0=a,\quad\alpha_k=b,
\]
on which \(\alpha_i=a+i\delta/k+O(\delta^2)\).
Allow its \(k\) profile occurrences to become independent formal
one-variable germs \(h_i\). At any sufficiently small positive, generic
base configuration, the finite core consisting of the interior
half-angle exponentials and the profile jets through
\(m_0=\max(2,k)\) is an isolated point of the localized algebraic set
obtained by matching **every positive-order endpoint derivative** of \(S_h\).

**Point case.** Let \(F\) be a real-analytic graph germ, \(F''\ne0\).
Fix \(F_0=F_k=F\), and use the stationary branch near equal steps of
\[
 T_F(a,b)=\mathop{\rm crit}_{x_1,\ldots,x_{k-1}}
 \sum_{i=1}^k \ell_i,\qquad
 \ell_i^2=(x_i-x_{i-1})^2+
       (F_i(x_i)-F_{i-1}(x_{i-1}))^2,
\]
where \(x_0=a,x_k=b\), and the roots at the base configuration are
positive real chord lengths. Allow only the \(k-1\) interior profiles to
vary independently. The core consisting of \(x_i\), their profile jets
through \(m_0\), and the nonzero length roots is isolated when **all
mixed endpoint derivatives** of \(T_F\) are matched.

Both assertions exclude complex formal deformations of these cores.
They assert set-theoretic isolation, **not** reducedness of the matching
scheme or injectivity of its linearized equations.
The core functions are algebraic over the respective endpoint-data
fields. For each fixed chain and germ, finitely many endpoint derivatives
occur in the resulting polynomial relations. No explicit, boundary-uniform
order \(N(k)\) is asserted.

For clarity, the local data fields can be taken to be the differential fields
generated, in the line case, by \(e^{ia},e^{ib}\) and
\(-\partial_aS_h,\partial_bS_h\), and, in the point case, by
\(a,b,F(a),F(b)\) and \(\partial_a\partial_b T_F\).
Derivations are \(\partial_a,\partial_b\), and constants are allowed.
Half-angle radicals may temporarily be adjoined; their elimination does not
alter algebraicity over the original fields.

This theorem does **not** assume a globally integrable billiard, a caustic
collar, periodicity, or a jointly analytic conjugacy. Those extra hypotheses
are needed elsewhere in the manuscript, not for this local statement.

**Theorem 2 (sharp nonlinear order in the scaled models).** Let \(r\ne0\)
and take the formal stationary branches at \(z_i(0)=1/k\),
\(\sum z_i=1\), of
\[
 G_L(x)=\mathop{\rm crit}\sum_i
       \left(-{r z_i^3\over24}+x f_i z_i\right)                       \tag{L}
\]
and
\[
 G_P(x)=\mathop{\rm crit}\sum_i\left(
       -{r^2z_i^3\over24}
       -{r x(f_i+f_{i-1})z_i\over2}
       +{x^2(f_i-f_{i-1})^2\over2z_i}\right),\quad f_0=f_k=0.          \tag{P}
\]
All \(f_i\) may be complex. If the coefficients of \(x,\ldots,x^k\)
in \(G_L\) vanish, all \(f_i=0\). If the coefficients of
\(x^2,\ldots,x^k\) in \(G_P\) vanish, all \(f_i=0\), including the
resulting linear coefficient of \(G_P\). These orders are sharp:
for every \(k\), nonzero complex directions exist for which the first
nonconstant coefficient in (L), or the first coefficient beyond degree
one in (P), occurs exactly in degree \(k\).

The sharp order concerns the **scaled stationary models**, not an
endpoint-jet bound for the unscaled analytic problem.

## 2. Existence and nondegeneracy of the original branch

Write \(\alpha_i=a+\delta u_i\), or \(x_i=a+\delta u_i\), and
\(z_i=u_i-u_{i-1}\), with \(u_0=0,u_k=1\).
Subtract, respectively, the fixed telescoping integrals
\(\int_a^b h\) and \(\int_a^b\sqrt{1+F'^2}\).
The resulting actions, divided by \(\delta^3\), extend analytically to
\(\delta=0\), with limits
\[
 -{r(a)\over24}\sum z_i^3,\qquad
 -{F''(a)^2\over24(1+F'(a)^2)^{3/2}}\sum z_i^3.                       \tag{1}
\]
These expansions hold with every fixed number of derivatives in \(u\)
near \(u_i=i/k\). They follow by Taylor expansion of one edge; the
line coefficient is \(-(h+h'')/24\), and the graph chord-minus-arc
coefficient is \(-F''^2/[24(1+F'^2)^{3/2}]\).

Let \(D_{k-1}\) be the tridiagonal matrix with diagonal 2 and adjacent
diagonal entries \(-1\). Its determinant is \(k\): the determinants
satisfy \(d_n=2d_{n-1}-d_{n-2}\), \(d_0=1,d_1=2\), hence \(d_n=n+1\).
The Hessians of the two limits in the interior \(u\)-coordinates are
\[
 -{r\over4k}D_{k-1},\qquad
 -{F''^2\over4k(1+F'^2)^{3/2}}D_{k-1}.                               \tag{2}
\]
They are invertible. The analytic implicit-function theorem gives the
claimed real-analytic branch \(u_i=i/k+O(\delta)\), with positive real
steps for small positive \(\delta\). It also gives an invertible stationary
Hessian at every such positive configuration, uniformly on compact
subintervals after shrinking \(\delta_*\).

Only the elementary analytic implicit-function theorem is needed here:
after multiplying by the inverse constant Hessian, its equation is
\(v=H(a,\delta,v)\) with \(H_v=0\) at the base point; on a smaller
polydisk this is a contraction. Iteration is locally uniformly
holomorphic and proves the asserted analytic dependence.

## 3. Finite algebraic elimination without assuming convergence

All statements in this section are formal at a fixed positive basepoint.
The stationary Hessian is invertible, so the formal implicit solution
in the endpoint increments is computed recursively by the same Hessian
inverse. In the line coordinates use \(s_i=e^{i\alpha_i/2}\).
The trigonometric factors and their derivatives are rational in the \(s_i\);
the endpoint \(s_0,s_k\) are algebraic over endpoint directions.
In the point case adjoin the length roots and their quadratic equations.

For \(m>m_0\), changing an \(m\)-th profile jet, while keeping lower
jets fixed, changes the endpoint Taylor series of the unreduced action
first in degree \(m\). Its gradient in the stationary variables changes
first in degree \(m-1\); the stationary point moves first in degree
\(m-1\). The correction to the critical value beyond direct substitution
has degree at least \(2m-2>m\). Consequently the new jets enter the
\(m\)-th critical-value tensor linearly, with columns
\[
 2\sin d_i\,(\nabla\psi_i)^{\otimes m}
 \quad\hbox{or}\quad
 w_i\,(\nabla x_i)^{\otimes m},                                     \tag{3}
\]
where \(\psi_i=(\alpha_{i-1}+\alpha_i)/2\) and
\[
 w_i={F(x_i)-F(x_{i-1})\over\ell_i}
       -{F(x_{i+1})-F(x_i)\over\ell_{i+1}}.
\]
These \(w_i\) are nonzero: at the positive branch
\(w_i=-F''(a)\delta/[k(1+F'(a)^2)^{3/2}]+O(\delta^2)\).

For lines use \((a,\delta)\). The slopes
\(\rho_i=\psi_{i,\delta}/\psi_{i,a}\) tend to
\((i-\tfrac12)/k\), and \(\psi_{i,a}\to1\).
The \(k\) tensor components with \(0,\ldots,k-1\)
\(\delta\)-derivatives have determinant
\[
 \left(\prod_i 2\sin d_i\,\psi_{i,a}^{\,m}\right)
       \prod_{i<j}(\rho_j-\rho_i)\ne0.                              \tag{4}
\]
For points use \((a,b)\). There are \(k-1\) unknown jets and use
components with \(1,\ldots,k-1\) \(b\)-derivatives. Put
\(\rho_i=x_{i,b}/x_{i,a}\). The determinant is
\[
 \left(\prod_{i=1}^{k-1}w_i x_{i,a}^{\,m}\rho_i\right)
       \prod_{i<j}(\rho_j-\rho_i)\ne0,                              \tag{5}
\]
since \(x_{i,a}\to1-i/k\), \(x_{i,b}\to i/k\).
Every component used in (5) is mixed, as \(m>k\).
The gradients in (3) are already rational in second-order profile
jets and endpoint data by differentiated stationarity.

Solve (4) or (5) at each order. Every higher profile jet is a rational
function of the finite core and the given data. All denominators lie
in the multiplicative system generated by a **fixed finite** collection:
the roots and coordinate factors, Hessian determinant, weights,
chosen nonzero coordinate derivatives, and slope differences.
The remainder equations, including the unused tensor components and
all low-order matching equations, therefore generate an ideal in one
finite-type localized algebra over the endpoint-data field.
Noetherianity makes that ideal finitely generated.

This construction does not say that an arbitrary possible profile jet
sequence converges. Convergence of variation coefficients, which is what
is actually required, is proved next.

## 4. The finite-web analytic bridge

Here is a self-contained version of the continuation argument sufficient
for both applications.

**Lemma 3.** Let \(\psi_i,w_i,B\) be analytic near a real rectangle
\(I\times(0,\delta_*)\), with real \(\psi_i\), nonzero weights and
pairwise distinct gradient directions. A formal relation
\[
             \sum_{i=1}^m w_i f_i(\psi_i)=B                         \tag{6}
\]
at one interior point makes the one-variable formal germs \(f_i\)
convergent and continuable along that rectangle. If
\(\psi_i=a+O(\delta)\), \(\psi_{i,a}=1+O(\delta)\) analytically at
\(\delta=0\), their continuations extend as one-variable analytic
germs near every compact interior subinterval of \(I\).
Neither weights nor \(B\) need be bounded at the edge.

**Proof.** Locally choose a transverse coordinate \(a\), so
\(A_i=\psi_{i,a}\ne0\), and put \(B_i=\psi_{i,\delta}\),
\(\rho_i=B_i/A_i\), \(F_{i,l}=f_i^{(l)}(\psi_i)\).
Differentiate (6) by
\(\partial_a^{m-r}\partial_\delta^r\), \(0\leq r<m\).
The matrix of the top derivatives \(F_{i,m}\) is
\((w_i A_i^m\rho_i^r)\), invertible by (4).
Thus each \(F_{i,m}\) is affine-linear in the finite vector
\(V=(F_{i,l}:l<m)\), with analytic coefficients. The chain rules give
a full system
\[
             V_a=M_aV+c_a,\qquad V_\delta=M_\delta V+c_\delta.       \tag{7}
\]

Take the original vector's finite constant term as initial value.
First solve the \(a\)-equation on the section through the basepoint,
then solve the \(\delta\)-equation with that section as initial data.
Linear analytic ODE existence follows directly from Picard iteration:
on a compact segment, iterated integral terms are bounded by
\(C^nL^n/n!\); the same estimate on a smaller complex neighborhood
gives analytic dependence on the other coordinate.
The constructed solution has the same formal Taylor series as the
original formal solution of the two successive initial-value problems.
The unused equation in (7), the relation (6), and the chain-rule
constraints have analytic residuals with zero Taylor series.
They vanish identically near the basepoint. Since \(\psi_i\) is a
submersion, a local analytic section of \(\psi_i\) recovers a convergent
one-variable \(f_i\) with the prescribed formal series.

Linear ODEs extend through every compact coordinate segment in the
positive rectangle. In our applications the original \(a\)-direction
is transverse throughout a sufficiently small rectangle. The preceding
successive construction then gives an analytic \(V\) on every smaller
positive rectangle. Its residuals vanish throughout by the identity
theorem. In the general local formulation, coordinate patches and
uniqueness give the same continuation; a real rectangle is simply
connected. No approach to \(\delta=0\) is involved in this step.

For the edge take \(J\Subset I\) and a sufficiently small fixed
\(\delta_1>0\). The edge assumptions give, for every \(\psi\) near
\(J\) and \(0<\delta\leq\delta_1\), a unique solution
\(a_i(\psi,\delta)\in I\) of \(\psi_i(a_i,\delta)=\psi\).
Along that path,
\[
 {d\over d\delta}F_{i,0}(a_i(\psi,\delta),\delta)
 =-{B_i\over A_i} A_iF_{i,1}+B_iF_{i,1}=0.                         \tag{8}
\]
Its value is therefore the analytic function
\(F_{i,0}(a_i(\psi,\delta_1),\delta_1)\) of \(\psi\) on the fixed
positive section. This function is the required extension.
In particular (8), rather than a boundedness assertion for (7),
justifies the edge passage. \(\square\)

## 5. From a nonisolated algebraic core to analytic coefficients

Suppose the actual core were nonisolated. A positive-dimensional
algebraic component through it has a nonconstant formal arc in
\(\mathbb C[[\epsilon]]\). Only this standard formal curve-selection
fact is required; convergence of the arc is unnecessary.
One proof takes an algebraic curve through the point, normalizes it,
and completes its local discrete valuation ring to
\(\mathbb C[[\epsilon]]\). The exact formal proposition used is
recorded in `literature/formal_curve_selection.txt`.
All localized denominators are units on the arc because their constant
terms at the actual core are nonzero.

Every eliminated higher jet is consequently in \(\mathbb C[[\epsilon]]\).
Moving the sampled centers back to their original locations is
well-defined in \(\mathbb C[[\epsilon,z]]\): a center shift is
\(O(\epsilon)\), so in
\(\sum c_n(\epsilon)(z-c(\epsilon))^n/n!\) the coefficient of
\(\epsilon^jz^l\) receives contributions only from \(n\leq j+l\).
This is not an unjustified translation of a divergent series by a
nonzero numerical amount.

The profiles now have expansions
\[
 h_i^\epsilon=h+\sum_{j\geq p}\epsilon^j f_{i,j}
 \quad\hbox{or}\quad
 F_i^\epsilon=F+\sum_{j\geq p}\epsilon^j f_{i,j},\qquad p\geq1,       \tag{9}
\]
with some \(f_{i,p}\ne0\); in the point case
\(f_{0,j}=f_{k,j}=0\).
If every profile variation vanished, formal implicit uniqueness of the
stationary point, and uniqueness of the nonzero root branches, would
make the core arc constant. Thus a least such \(p\) exists.

Matching all positive endpoint derivatives says, formally, that
\(\Delta S=\sum_j K_j\epsilon^j\), with constant \(K_j\).
Matching mixed derivatives says
\(\Delta T=\sum_j[U_j(a)+V_j(b)]\epsilon^j\).
The separation follows coefficient by coefficient from
\(\partial_a\partial_b\Delta T=0\) in the two-variable formal series
ring; an immaterial constant can be moved between \(U_j,V_j\).

At perturbation order \(j\), the first variation in the new unknown
coefficient is (6), with the original sampling coordinates and weights.
All other terms use only lower perturbation orders and the original
stationary Hessian inverse. They are analytic on the positive rectangle
by induction. For lines there are \(k\) unknowns \(f_{i,j}\).
For points include \(U_j,V_j\) as two further one-variable unknowns,
of weights \(-1,-1\), sampled at \(a,b\).
Their \(k+1\) foliation slopes tend respectively to
\(1/k,\ldots,(k-1)/k,0,1\), so they are distinct.
All sampling coordinates are \(a+O(\delta)\) with \(a\)-derivative
\(1+O(\delta)\).

Lemma 3 proves, inductively, that every coefficient in (9), and every
\(U_j,V_j\), converges, continues, and reaches the edge.
For any fixed finite number of coefficients and derivatives one may
choose a common neighborhood of \(J\Subset I\).
No common radius, bound in \(j\), or convergence of the full
\(\epsilon\)-series is asserted or used.

The matching critical-value identities also hold after this
continuation: each coefficient is analytic on the positive rectangle
and agrees with the prescribed formal identity near the basepoint.
Analytic uniqueness continues that identity.

## 6. Coefficientwise stationary convergence

Fix \(a\in J\), substitute
\[
        \epsilon=e\,\delta^{2/p},\qquad x=e^p,
\]
and keep \(e\) formal while letting the real \(\delta\downarrow0\).
Fractional powers here are positive real powers of \(\delta\), not
an assertion of holomorphicity in \(\delta^{2/p}\) at zero.

For lines divide the integral-subtracted action by \(\delta^3\).
An order-\(j\) profile term contributes
\[
 e^j\delta^{\,2j/p-2}
       \bigl(f_{i,j}(a)z_i+O(\delta)\bigr).                          \tag{10}
\]
Thus only \(j=p\) survives, and the limit is (L).

For points multiply the arc-subtracted action by \(g^{3/2}/\delta^3\),
where \(g=1+F'(a)^2\), \(r=F''(a)\).
For one edge with vertices \(u_{i-1},u_i\), the term of its first
vertical variation having coefficient \(F'(a)/\sqrt g\) telescopes
**exactly**, including the values of the varying profiles at their
moving vertices, because endpoint variations vanish. The next term is
\[
 {r\delta(u_i+u_{i-1})\over2g^{3/2}}.
\]
At the leading perturbation order summation by parts gives
\[
 \sum_i(u_i+u_{i-1})(f_i-f_{i-1})
             =-\sum_i(f_i+f_{i-1})z_i.                             \tag{11}
\]
The second vertical derivative of an edge length is
\(1/(\delta z_i g^{3/2})+O(1)\).
Consequently the remaining leading terms are exactly (P).
An order \(j>p\) in the linear variation has factor
\(\delta^{2j/p-2}\); mixed quadratic perturbations with orders \(j,l\)
have factor \(\delta^{2(j+l)/p-4}\), which is positive unless
\(j=l=p\). Terms with \(n\geq3\) vertical perturbations carry at least
\(\delta^{n-2}\). All disappear. Derivatives of the profiles cause no
extra surviving term: the constant first-variation term has already
telescoped with their full moving-vertex values.

Here is why these limits commute with taking a *formal stationary
value*. Work modulo \(e^{N+1}\) for an arbitrary fixed \(N\).
Only finitely many coefficients from Section 5 are involved; their
derivatives near \(a\) are bounded. The rescaled actions and every
needed stationary-variable derivative have coefficientwise limits
near equal steps. Their constant-in-\(e\) stationary points tend to
equal steps and their Hessians tend to the invertible matrices (2).
The coefficient of degree \(n\) of the stationary point is that
Hessian inverse times an expression involving only input coefficients
of degrees at most \(n\) and already determined stationary coefficients
of lower degrees. Induction on \(n\leq N\) proves convergence of each
coefficient, then of the stationary value.
Since \(N\) was arbitrary this proves the required coefficientwise
limit. There is no exchange of an infinite sum and a limit.

In the line case the coefficient of \(e^j\) in the matched difference
is \(K_j\delta^{2j/p-3}\). Boundedness at \(j=p\) forces \(K_p=0\);
at \(j=mp\), \(m\geq2\), the exponent \(2m-3>0\).
Hence (L) has **constant** stationary value.

In the point case the corresponding coefficient is
\[
 g^{3/2}\delta^{2j/p-3}
                 [U_j(a)+V_j(a+\delta)].
\]
The bracket is bounded by Section 5. At \(j=p\), boundedness also
forces \(U_p(a)+V_p(a)=0\), leaving at most a finite linear term
after division by \(\delta\). For \(j=mp\geq2p\) the displayed
expression tends to zero. The limiting action depends only on
\(x=e^p\), so (P) has **affine** stationary value.

## 7. Complex algebraic obstruction, including its finite order

There is an exact reduction between the two scaled variational problems,
stronger than just their parallel power-sum calculations.

**Theorem 2A (point-to-line stationary-value reduction).** For every
\(k\geq2\), \(r\ne0\), and complex \(f_0=f_k=0,f_1,\ldots,f_{k-1}\),
the entire formal stationary value (P) equals the formal stationary value
of (L) with curvature parameter \(R=r^2\) and its \(k\) profile
coefficients \(c_j=-rf_j\), \(0\leq j<k\).
If \(w_j(0)=1/k\) are the latter stationary steps, extend them cyclically
by \(w_k=w_0\). The former stationary steps are
\[
                         z_i={w_{i-1}+w_i\over2}.                  \tag{19}
\]
This statement is about stationary branches; (19) is not asserted to
be an invertible linear change of all step variables. In particular
no such invertibility is used when \(k\) is even.

**Proof.** The line stationarity equations are
\[
                -{r^2w_j^2\over8}-rxf_j=\lambda.
\]
For one edge put \(A=w_{i-1}\), \(B=w_i\), \(z=(A+B)/2\).
They imply
\[
 rx(f_i+f_{i-1})=-2\lambda-{r^2(A^2+B^2)\over8},\qquad
 x(f_i-f_{i-1})={rz(A-B)\over4}.                                   \tag{20}
\]
Substitution into the point edge derivative gives exactly \(\lambda\).
Thus (19) satisfies point stationarity and its sum constraint.
Its constant steps are \(1/k\), so formal implicit uniqueness
identifies it with the point branch. The point edge value simplifies to
\[
                \lambda z+{r^2(A^3+B^3)\over24}.                   \tag{21}
\]
The line vertex value simplifies to
\(\lambda w_j+r^2w_j^3/12\).
Sum (21) cyclically: every cube occurs twice, and both step sums
equal 1. The stationary values coincide. \(\square\)

The identities (20)--(21) and the stationary derivative identity are
parameter-free rational/polynomial identities checked exactly by
`verify.py`; cyclic summation proves the result for arbitrary \(k\).
This reduction is not stated in the staged proof. Its novelty relative
to other literature has not been independently established.

For either model each edge term obeys the exact weighted identity
\[
                 z\,\partial_z H+2x\,\partial_x H=3H.              \tag{12}
\]
If \(\lambda=\partial_{z_i}H_i\) is the common stationary multiplier,
the envelope rule and \(\sum z_i=1\) give
\(\lambda=3G-2xG'\).
All computations take place in \(\mathbb C[[x]]\); division by \(z_i\)
is valid because its constant term is \(1/k\).

For (L), \(G_0=-r/(24k^2)\). If \(G=G_0\), then
\(\lambda=-r/(8k^2)\), and stationarity gives
\[
 z_i={1\over k}\sqrt{1+{8k^2\over r}xf_i},\qquad
          \sum_i\sqrt{1+{8k^2\over r}xf_i}=k.                      \tag{13}
\]
Each root denotes the unique formal root with constant term 1.
The binomial coefficient \(\binom{1/2}{m}\) is nonzero for every
integer \(m\geq1\). Comparing coefficients in (13) gives
\(\sum_i f_i^m=0\).

Only the first \(k\) power sums are needed. Indeed, put
\(E(t)=\prod_i(1-f_i t)=\sum_{j=0}^k(-1)^j e_jt^j\).
The product rule, or multiplication of
\(-tE'(t)/E(t)=\sum_{m\geq1}(\sum_i f_i^m)t^m\),
gives Newton's identities. Induction on \(j\leq k\) gives \(e_j=0\),
so the monic polynomial with roots \(f_i\) is \(T^k\).
Every \(f_i=0\), over \(\mathbb C\), not merely over \(\mathbb R\).
The same argument modulo \(x^{k+1}\), using
\(\lambda=3G_0+O(x^{k+1})\), proves the finite-order statement of
Theorem 2 for (L).

For (P), write \(G_0=-r^2/(24k^2)\), \(G=G_0+g_1x\).
Then \(\lambda=3G_0+g_1x\), and direct completion of squares gives
\[
 \left({rz_i\over2}+{x(f_i-f_{i-1})\over z_i}\right)^2
                =-2\lambda-2rxf_{i-1},\qquad
 \left({rz_i\over2}-{x(f_i-f_{i-1})\over z_i}\right)^2
                =-2\lambda-2rxf_i.                               \tag{14}
\]
The roots on the left have constant term \(r/(2k)\), even if \(r<0\).
Add both roots on every edge and use \(\sum z_i=1\).
Since \(f_0=f_k=0\), the endpoint root occurs twice and each interior
root twice. Dividing by 2 yields the simpler \(k\)-term identity
\[
  \sqrt{1-\beta xg_1}
   +\sum_{i=1}^{k-1}\sqrt{1-\beta x(g_1+rf_i)}=k,
               \qquad \beta={8k^2\over r^2}.                      \tag{15}
\]
Newton's identities applied to the \(k\) numbers
\(g_1,g_1+rf_1,\ldots,g_1+rf_{k-1}\) force all of them to vanish.
Thus \(g_1=0\) and every \(f_i=0\).
Again (14)--(15) modulo \(x^{k+1}\) prove the finite-order assertion
when \(G=G_0+g_1x+O(x^{k+1})\).

Alternatively, Theorem 2A reduces the point obstruction completely to
the line obstruction: subtract the common coefficient \(g_1\) from
every \(c_j\). This subtracts \(g_1x\) from the line stationary value
without changing its stationary point. The constant-value line result
forces \(c_j-g_1=0\) for all \(j\). Since \(c_0=0\), \(g_1=0\), and
every \(f_i=0\). The same reasoning works modulo \(x^{k+1}\).

Apply this pointwise for every \(a\in J\) to \(f_i=f_{i,p}(a)\).
Analytic uniqueness then makes every leading coefficient in (9)
zero on its original germ, contradicting the choice of \(p\).
The finite core is isolated. This completes the isolation, including
the analytic-to-algebraic bridge, for every \(k\).

### Sharpness in the models

Let \(\zeta\) be a primitive \(k\)-th root of unity.
For (L), take \(f_i=\zeta^{i-1}\).
Writing \(c=8k^2/r\) and
\(\lambda=-r v/(8k^2)\), the stationary constraint is
\[
                  \sum_{i=0}^{k-1}\sqrt{v+cx\zeta^i}=k.
\]
It uniquely determines \(v(0)=1\). The geometric-sum identity
\(\sum_i\zeta^{im}=0\) for \(1\leq m<k\), and \(=k\) for \(m=k\),
gives
\[
 v=1-2\binom{1/2}{k}c^k x^k+O(x^{k+1}),\qquad
 [x^k]G_L={r\binom{1/2}{k}c^k\over4k^2(3-2k)}\ne0.               \tag{16}
\]

For (P), put \(f_i=(\zeta^i-1)/r\), \(0\leq i\leq k\).
Its actual linear coefficient is
\(-r\sum_{i=1}^{k-1}f_i/k=1\).
Set \(\lambda=3G_0+x+\mu(x)\).
Equation (14) and the stationary constraint become
\[
                  \sum_{i=0}^{k-1}
                   \sqrt{1-\beta x\zeta^i-\beta\mu}=k.
\]
They determine
\[
 \mu={2\binom{1/2}{k}(-\beta)^k\over\beta}x^k+O(x^{k+1}),\qquad
 [x^k]G_P={2\binom{1/2}{k}(-\beta)^k\over\beta(3-2k)}\ne0.         \tag{17}
\]
For completeness these root formulas really describe the stationary
point, not just necessary equations: let
\(a_i=(r/(2k))\sqrt{1-\beta x\zeta^i-\beta\mu}\) and
\(z_i=(a_{i-1}+a_i)/r\).
The difference of consecutive squares gives
\(a_{i-1}-a_i=2x(f_i-f_{i-1})/z_i\), so both equations (14),
stationarity, and \(\sum z_i=1\) hold. Formal implicit uniqueness
identifies this branch with (P).

Since \(\binom{1/2}{k}\ne0\) and \(3-2k\ne0\), (16)--(17) prove
sharpness for every integer \(k\geq2\).
For example, the complex vector \((1,\zeta,\zeta^2)\), \(k=3\),
has vanishing first and second power sums but nonzero third power sum.
A quadratic positivity argument cannot replace the complex argument.
This is an obstruction to a shortcut, not a flaw asserted in the manuscript.

## 8. Lifting isolated values to function fields

We spell this out because an arbitrary numerical specialization would
not suffice.

First, a scalar fact: an isolated complex point of an affine algebraic
set defined over a subfield \(K\subset\mathbb C\) has coordinates
algebraic over \(K\). Pass to an algebraic closure \(\overline K\)
inside \(\mathbb C\). A positive-dimensional irreducible component
over \(\overline K\) has only positive-dimensional components after
extension to \(\mathbb C\): Noether normalization gives a finite
surjection to affine space of that dimension, and algebraically closed
base extension preserves dimension. It cannot contain an isolated
point. The isolated point must therefore come from a zero-dimensional
component over \(\overline K\), whose coordinates lie in \(\overline K\)
by the Nullstellensatz. Localization is harmless: an open neighborhood
of a point on a positive-dimensional component cannot isolate it.

Now work with the actual analytic functions on one connected
neighborhood of the real positive rectangle. Choose a **countable**
constant field containing \(\mathbb Q(i)\) and the finitely/countably
many numerical coordinate constants used. Let \(K'\) be generated
over it by the endpoint-data functions, all their derivatives, and the
actual finite radical branches used in the coordinates. Let \(H\)
also contain the actual finite core functions. These are countable
fields of meromorphic functions; their nonzero members are countable.

Choose a real positive basepoint avoiding the zeros and poles of
every nonzero member of \(H\). Such a point exists. The restriction
of a nonzero holomorphic germ to an open totally real rectangle cannot
be identically zero; its real zero set has measure zero.
One elementary proof of the latter uses one-variable isolated zeros
on almost every line and induction/Fubini on Taylor coefficients.
The same applies to a meromorphic numerator or denominator.
A countable union of these null sets cannot fill a real rectangle.
Evaluation at the chosen point is therefore an **injective field
homomorphism on \(H\)**.

The finite-core equations are over the evaluated endpoint field
\({\rm ev}(K')\). By isolation and the scalar fact, each evaluated core
coordinate satisfies a nonzero polynomial over \({\rm ev}(K')\).
Lift its coefficients through the injective evaluation map to \(K'\).
Substituting the actual core function gives an element of \(H\) whose
evaluation is zero. Injectivity makes that element the zero function.
The lifted polynomial is nonzero because its nonzero coefficients
remain nonzero. This is precisely where including the actual core
functions in \(H\) was necessary.

Thus the core germs are algebraic over \(K'\). The radical extensions
are algebraic, so transitivity gives algebraicity over the original
endpoint-data field. Each polynomial has finitely many coefficients,
and each coefficient uses finitely many endpoint derivatives; hence
the germwise finiteness assertion follows.
No effective or boundary-uniform jet order is inferred from this
Noetherian argument.

Finally let \(q\) be algebraic over a characteristic-zero differential
field \(K\), with minimal polynomial \(P(Z)\in K[Z]\).
It is separable, so \(P_Z(q)\ne0\), and for either derivation \(D\),
\[
                         Dq=-{(DP)(q)\over P_Z(q)}.
\]
This belongs to \(K(q)\). Induction gives every derivative in a finite
algebraic extension. The proof of Theorem 1 is complete.

## 9. Return to the manuscript's geometric fields

For unoriented lines in an affine chart normalize their equation
\(A x+B y=C\) by a local square root of \(A^2+B^2\).
The oriented normal \(n_\theta\), signed distance \(p\), and
\(e^{i\theta}\) are algebraic over the projective line coordinates.
The chosen half-angle exponentials are further radicals.
Angle **derivatives**, not the angle logarithms themselves, are
rational in these normal coordinates and their derivatives.
Near glancing the Jacobian from \((y,t)\) to endpoint angles
is \(k\phi'(y)^2\ne0\) at \(t=0\); its inverse changes derivations
using endpoint jets. The endpoint derivatives of the critical value
are \(-p_0,p_k\), giving exactly the line data in Theorem 1.
The contact formulas recover intermediate offsets from the core.
Eliminating the radical extensions proves the asserted line
algebraicity.

For points choose a regular abscissa on the boundary graph. Endpoint
point jets give all graph jets there. In the manuscript's convention
\[
 n_\theta=(\cos\theta,\sin\theta),\qquad
 e_\theta=(-\sin\theta,\cos\theta),\qquad p=P_0\cdot n_\theta,
\]
so \(e_\theta'=-n_\theta\), \(n_\theta'=e_\theta\).
Writing \(P_0=P_0(a)\), endpoint differentiation gives
\[
 T_a=-P_{0,a}\cdot e_\theta,\quad
 T_{ab}=(P_{0,a}\cdot n_\theta)\theta_b,\quad
 dp\wedge d\theta=(P_{0,a}\cdot n_\theta)\,da\wedge d\theta.
\]
Therefore the sign in the manuscript is **positive**:
\[
                     T_{ab}\,da\wedge db=dp\wedge d\theta.          \tag{18}
\]
The first edge is \(L(y+t/2,t)\).
The change \((y,t)\mapsto(y+t/2,t)\) has determinant 1, so it leaves
\(A(t)\,dy\wedge dt\) unchanged. If
\(J=\det[\partial(a,b)/\partial(y,t)]\ne0\), (18) yields
\(T_{ab}=A(t)/J\). Differentiating gives all required mixed data,
with no appeal to the unknown pure first derivatives.
This verifies the exact extra datum used by `thm:lens-points`.

Graph values recover all points, and joining consecutive distinct
points recovers the edges rationally. The separability calculation
above gives their derivatives. Translation of the index interval
changes \((y,t)\) by a linear shear. Polynomial identities persist
under analytic continuation on the generic nondegenerate locus.
No no-patch or later rigidity assertion was used in this argument.

Thus, **conditional on the upstream jointly analytic glancing
parametrization stated in Section 3**, the two endpoint-isolation
arguments supply the claimed germwise algebraicity for every fixed
\(k\geq2\). This conclusion does not verify that upstream theorem or
the downstream no-patch argument.

## 10. Exact replay and limits of certification

Run, from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/finite_chain_audit/verify.py
```

`verify.py` checks the edge Taylor coefficients, moving-offset
telescoping coefficient, weighted homogeneity, completed-square
identities, the area-form sign and half-shift, determinant recurrence,
Newton identities and exact complex sharpness examples. It independently
replays the preserved bounded Jacobian ideal and refuses any adapter
outcome other than `COMPUTED`.
`exact_certificate.json` records those exact outputs and their scope.

The engineer's run on 2026-11-05 passed all **136 exact zero-residual
checks**. Cyclotomic stationary branches were replayed for \(k=2,3,4,5\);
limiting determinant instances were checked for \(k=2,\ldots,8\).
The separately preserved Jacobian call returned `COMPUTED`, the unit
elimination ideal, in 567 ms with CLI exit 0. None of those measurements
is being represented as an exhaustive analytic counterexample search.

The arbitrary-\(k\) conclusions are proved by the explicit general
arguments in Sections 2--9. Finite examples in the replay are **finite
checks**, not an exhaustive search over analytic profiles or a proof by
testing finitely many chain lengths. The analytic web continuation,
formal stationary limit, algebraic curve-selection input, and generic
function-field lift are prose mathematics requiring independent review.
No Lean kernel verification, global Birkhoff verification, independent
Reviewer acceptance, or verified-new novelty determination is claimed.

The comparison with the prior recorded state is concrete: the ledger
previously held only the campaign objective; this work supplies the
complete local bridge, a local theorem without a caustic-collar
assumption, the exact point-to-line stationary-value reduction, and the
sharp degree-\(k\) complex obstruction in both scaled models.
The primary-source search establishes only that no
antecedent was found within its stated boundary.

The campaign's publishable target remains open until the independent
Reviewer assesses the proof, exact replay, citations and significance.
If accepted only as a verification/reconstruction of the manuscript's
local argument, it is a checkpoint, not permission to stop the
independent counterexample campaign.
