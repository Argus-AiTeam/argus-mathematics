# Uniform angular perturbations: verification and a sharp principal-symbol criterion

## Result and scope

The perturbation error-form estimate in the two staged manuscripts is valid
under its stated scalar coefficient contract. In particular, arbitrarily high
angular degree and arbitrarily high base frequency do not defeat that estimate.
The proof below is uniform in both; it is not a finite-frequency experiment.
It also proves the weighted raising estimate and hence scalar coercivity,
conditional on the manuscripts' stated moving-trace expansion.

There is a sharp extension: a complex, sphere-independent second-base
coefficient is allowed precisely when its scalar principal symbol is normal
under the base Poisson bracket. When that condition fails the error-form bound
fails at a fixed positive radius, even with arbitrarily small coefficients.
That obstruction is **not a counterexample to the manuscripts**, whose
second-base coefficients are real.

This is an independently derived verification theorem and a structural
extension candidate, not an independently reviewed publication or a formal
kernel proof. Novelty and publishable significance remain unverified.
The joint and scalar inverse-problem main theorems are not certified here.

The initial campaign ledger contained no earlier angular result to improve.
The improvement over a finite matrix test is an all-degree, all-parameter
argument, together with a necessary-and-sufficient cubic-symbol criterion.

## Exact manuscript assertions

In the Determination manuscript, `build/sections/05-angular.tex`:

* `ang:error-operator` defines
  \[
  E=2[T^\dagger,U]+2[U^\dagger,T]+[U^\dagger,U]
       -2(UZ+(UZ)^\dagger).
  \]
* `ang:error-form-bound` asserts, literally,
  \[
  |\langle E\varphi,\varphi\rangle|
                   \le C\varepsilon {\cal N}(\varphi)^2.
  \]
* The passage immediately preceding `ang:error-types` states:
  "It follows that \(\mathcal E\) is a sum of terms of precisely the following
  three permitted types", followed by
  \[
  \varepsilon\beta^{-1}\Psi^1\partial_y^2,\qquad
  \varepsilon\Psi^2\partial_y,\qquad
  \varepsilon\beta\Psi^3.
  \]
* `ang:coercive-estimate` asserts
  \({\cal N}(\varphi)\le C\|P_0\varphi\|\).

The scalar companion has the identical assertions at
`angular:error-operator`, `angular:error-form-bound`,
`angular:error-types`, and `angular:coercive-estimate` in
`build/sections/05-angular-estimate.tex`.
No false assertion from either manuscript has been identified by this work.

## Hypotheses and the theorem

Let \(Y\) be a fixed relatively compact base chart of a Riemannian
\(n\)-manifold, \(n\ge3\), with bounded reference geometry. Use horizontal
covariant derivatives on its tangent unit-sphere bundle, the parallel fiber
probability measure, and the base volume density. All functions below are
smooth with **compact base support**. Put
\[
 f=\log r,\quad \beta=|df|\ge\beta_0\ge1,\qquad
 \operatorname{Hess}f\le-c_0\beta g,\qquad
 |\nabla^j f|\le C_j\beta^j\quad(1\le j\le8).
\]
There is no lower bound on \(r>0\). In the geometric application also assume
\[
 \sum_{|\alpha|\le8}|\partial^\alpha h|\le\varepsilon r,\qquad
 r\beta^2\le\varepsilon .
\]
These are hypotheses, not consequences of a numerical test.

Let \(B=k\) on the spherical harmonics \({\cal H}_k\), and let \(A_i\)
be boundary traces of ambient differentiation of harmonic extensions.
Define
\[
 T=\sum A_i^*(\nabla_i+f_iB),\quad
 T^\flat=\sum A_i(-\nabla_i+f_iB),\quad
 Z=T^\flat-T^\dagger=\sum f_iA_i.
\]
Use exactly the manuscript norm
\[
 {\cal N}(v)^2=\int_Y\left(
 \|\nabla v\|_0^2+\beta^2\|v\|_1^2+
 \beta^{-1}\|\nabla v\|_{1/2}^2+\beta\|v\|_{3/2}^2\right)dV,
 \quad \|w\|_s=\|(1+B)^sw\| .
\]

Suppose
\[
 U=c^{ij}(y)\partial_i\partial_j+B^i(y)\partial_i+C(y),\qquad
 c^{ij}=c^{ji}\in{\mathbb R}.
\]
The \(c^{ij}\) are sphere-independent scalars. All angular operators are
scalar classical pseudodifferential operators. For base order \(j=0,1,2\),
assume angular order at most \(2-j\), size at most
\(\delta\beta^{-j}\), and five base derivatives with an extra allowance
\(C_\ell\beta^\ell\). The seminorm bounds are on all the finitely many
angular Sobolev/symbol orders used in the proof. In particular the statement
does not identify an arbitrary matrix operator with a scalar symbol.

**Theorem 1 (uniform perturbation and coercivity).** There is a constant
\(C_E\), independent of angular degree, \(r\), \(\beta_0\), and the shrinking
parameter, such that
\[
 |\langle Ev,v\rangle|
       \le C_E(\delta+\delta^2/\beta_0){\cal N}(v)^2.                 \tag{1}
\]
This estimate does not need zero fiber mean. For functions of zero mean
on every fiber, there is \(c_R>0\), uniform in the same parameters, such
that
\[
 \|Tv\|^2-\|T^\flat v\|^2\ge c_R{\cal N}(v)^2.                    \tag{2}
\]
If \(J\) is a uniformly bounded angular operator of order one with no
base derivatives, then, after choosing \(\beta_0\) large and \(\delta\)
small using only the fixed bounds,
\[
 {\cal N}(v)\le C\|(2T+U+J)v\| .                                 \tag{3}
\]
The proof applies to every smooth compactly base-supported \(v\), not
just to a transfer density, a finite collection of harmonics, or a
frequency-constrained class.

**Theorem 2 (sharp complex extension).** Allow \(c^{ij}\) to be complex,
with the same bounds, and set
\[
 c(y,\xi)=c^{ij}(y)\xi_i\xi_j,\qquad
 K(y,\xi)=\sum_j\bigl(
    \partial_{\xi_j}\bar c\,\partial_{y_j}c
       -\partial_{\xi_j}c\,\partial_{y_j}\bar c\bigr).              \tag{4}
\]
Then (1) holds if \(K=0\) identically. Conversely, if \(K\ne0\) somewhere,
there is no finite constant in (1), even for a fixed choice of all parameters
and for zero-fiber-mean functions. Thus (4), not reality by itself, is the
exact principal-base obstruction to this error-form method.
For example any common constant phase times a real symmetric coefficient
is allowed. This is a generalization of the error-form statement, not an
assertion that a geometric metric may be complex.

## Proof of the uniform error-form bound

We spell out the filtration argument; a combined total-order label without
the following base-order cancellation would not suffice.

A coefficient at base order \(j\) in a class \((m,s)\) has angular
order at most \(m-j\) and size \(O(\beta^{s-j})\). Base differentiation
of a coefficient costs at most one factor \(\beta\).
In a product of classes \((m,s)\), \((m',s')\), a Leibniz term with
\(\ell\) base derivatives on coefficients has:
\[
 j=j_1+j_2-\ell,\quad
 \text{angular order}\le m+m'-j-\ell,\quad
 \text{size}=O(\beta^{s+s'-j}).
 \tag{5}
\]
For \(\ell\ge1\) this loses at least one total order. For \(\ell=0\),
the scalar angular commutator loses one angular order. This last assertion
uses the scalar classical calculus, not commutativity of the operators:
only their principal symbols commute.
Adjoints preserve the upper class, including lower-order terms.

Here \(T,T^\dagger\) have class \((2,1)\) and base order at most one,
\(U\) has class \((2,0)\), and \(Z\) has class \((1,1)\) and base order
zero. The linear part of \(E\) therefore has class at most \((3,1)\)
and size \(O(\delta)\); the quadratic part has class at most \((3,0)\)
and size \(O(\delta^2)\).

For completeness, write the base density as \(\mu(y)dy\) in an
orthonormal sphere trivialization. Direct adjunction gives
\[
\begin{split}
 W:=U^\dagger-U={}&
 [2\mu^{-1}\partial_j(\mu c^{ij})-B^i-(B^i)^*]\partial_i\\
 &+\mu^{-1}\partial_i\partial_j(\mu c^{ij})
 -\mu^{-1}\partial_i(\mu(B^i)^*)+C^*-C.                           \tag{6}
\end{split}
\]
It has base order at most one and retains class \((2,0)\).
In \([T^\dagger,U]\), \([U^\dagger,T]\), and \([W,U]\), a term
of base order three can only be a zero-hit commutator with \(c^{ij}\).
It is **exactly zero**, since \(c^{ij}\) is sphere-independent.
Terms with a coefficient derivative already have base order at most two.
Also \([U^\dagger,U]=[W,U]\), and \(UZ\) has base order at most two.
This proves that all terms, not just principal angular symbols, have
one of the three upper types
\[
 \delta\beta^{-1}\Psi^1\partial^2,\quad
 \delta\Psi^2\partial,\quad
 \delta\beta\Psi^3,                                               \tag{7}
\]
with the quadratic part smaller by \(\delta/\beta_0\).
In particular no angular-degree cutoff or relationship between base
frequency and angular degree was inserted.

Here are the form estimates behind (7). For the first type integrate
once in the base, using compact support. Its principal term is bounded
by
\[
 C\delta\int\beta^{-1}\|\partial v\|_{1/2}^2.
\]
The differentiated coefficient has angular order one and size \(O(\delta)\).
Its form is bounded by the same estimate used for the second type:
\[
 C\delta\int\|\partial v\|_{1/2}\|v\|_{3/2}
 \le {C\delta\over2}\int
    \left(\beta^{-1}\|\partial v\|_{1/2}^2+
                       \beta\|v\|_{3/2}^2\right).                 \tag{8}
\]
Using a stronger target Sobolev norm for that lower-order term is harmless.
The third type is bounded by \(C\delta\int\beta\|v\|_{3/2}^2\).
The derivative of the weight is included: the profile hypotheses imply
\(|d\beta|\le C\beta^2\) and \(|d(\beta^{-1})|\le C\).
Coordinate/horizontal derivative changes add a bounded angular first
derivative, controlled by the same expressions, since \(\beta\ge1\).
Volume-density derivatives and a fixed partition have these lower orders.

These are bounded-operator Sobolev estimates on the entire sphere, not
pointwise symbol substitutions. Uniformity follows from the uniform
finite symbol/operator seminorms in the hypotheses. Applying the same
argument to class \((3,0)\), and using \(\beta\ge\beta_0\), gives the
factor \(\delta^2/\beta_0\). This proves (1).

## Proof of the weighted raising estimate

We include this argument so that (3) does not assume the disputed
coercivity statement. Work at one input degree \(k\ge1\); output degrees
of \(T\) and \(T^\flat\) make summation orthogonal.
Use harmonic homogeneous polynomials and the Fischer norm with
\(\|z^\alpha\|^2=\alpha!\). Gaussian integration, followed by its radial
integral, gives
\[
 \|v\|_{\rm F}^2=N_k\|v\|_{S}^2,\qquad
 N_k=n(n+2)\cdots(n+2k-2).
\]
For a harmonic homogeneous polynomial, all Wick pairings internal to
one factor vanish by trace-freeness; the remaining pairings give exactly
the Fischer pairing. This proves the Gaussian identity without invoking
a literature theorem.

Write \(a_i=\partial_{z_i}\), \(d=k+n/2-1\), and
\(D_i^\pm=\pm\nabla_i+kf_i\). Harmonic projection of \(\sum z_iq_i\),
\(q_i\in{\cal H}_k\), is
\[
 \sum z_iq_i-\frac{|z|^2}{2d}\sum a_iq_i.
\]
Indeed \(\Delta(|z|^2s)=4d\,s\) for harmonic \(s\) of degree \(k-1\).
Fischer orthogonality then gives its norm squared as
\[
 \sum\|q_i\|^2+\sum_{ij}(a_jq_i,a_iq_j)
                  -d^{-1}\|\sum a_iq_i\|^2 .
\]
Also \(A_i^*=(N_{k+1}/N_k)\Pi_{k+1}z_i=(2d+2)\Pi_{k+1}z_i\).
Consequently \(N_k\) times the raising/lowering norm difference is
\[
 (2d+2)\left[\|D^+v\|^2+
 \sum_{ij}(a_jD_i^+v,a_iD_j^+v)
       -d^{-1}\|\sum a_iD_i^+v\|^2\right]
                  -2d\|\sum a_iD_i^-v\|^2 .                     \tag{9}
\]
All these norms include base integration and the Fischer fiber norm.

Set \(H_{ij}=2k\operatorname{Hess}(f)_{ij}\), and let \(H[av]\)
be its integrated contraction against \(a_iv,a_jv\). Moving a \(D^+\)
across the pairing and using
\([D_j^-,D_i^+]=-H_{ij}+\text{curvature}\) gives
\[
\begin{split}
 \sum_{ij}(a_jD_i^+v,a_iD_j^+v)
      &=\|\sum a_iD_i^-v\|^2-H[av]+O(k^2)\|v\|^2,\\
 \|\sum a_iD_i^+v\|^2
      &\le k\|D^-v\|^2-H[av]+O(k^2)\|v\|^2,\\
 \|D^-v\|^2&=\|D^+v\|^2+\int\operatorname{tr}H\,|v|^2.            \tag{10}
\end{split}
\]
For the inequality the reordered term is
\(\sum_{ij}(a_iD_j^-v,a_jD_i^-v)\), at most
\(\sum_{ij}\|a_iD_j^-v\|^2=k\|D^-v\|^2\).
For the first equality the reordered term is the displayed divergence
square. These observations fix both signs in (10).
Curvature acts on a degree-\(k\) symmetric tensor with norm \(O(k)\);
the pair of contractions has norm \(O(k)\), since
\(\sum\|a_iw\|^2=k\|w\|^2\). Thus the error bound \(O(k^2)\) is
uniform, including all tensor-index curvature terms.

Substitution of the first formula into (9) yields, with \(q=2+2/d\),
\[
 q\left[d\|D^+v\|^2-\|\sum a_iD_i^+v\|^2-dH[av]\right]
              +2\|\sum a_iD_i^-v\|^2+O(k^3)\|v\|^2.              \tag{11}
\]
Choose
\[
 \theta={n-2\over8(n-1)},\qquad
 0<c_1\le\min(1,c_0),\qquad \zeta=c_1/\beta.
\]
Apply (10) to the constant fraction \(1-\theta\) of the negative
divergence square. On the other fraction use the pointwise bound
\[
 |\sum a_iD_i^+v|^2\le
 (1-\zeta)(k+n-1)|D^+v|^2+
 \zeta\left(2|\sum a_iD_i^-v|^2+8k^3\beta^2|v|^2\right).         \tag{12}
\]
The first bound uses the Fischer contraction norm at most
\(k+n-1\); it follows by restricting the full polynomial creation/
annihilation operators, for which
\(\sum a_i a_i^*=k+n-1\) on degree \(k-1\).
The second uses \(D^++D^-=2kf\) and
\(|\sum f_i a_iv|^2\le k\beta^2|v|^2\).
Only the latter pointwise inequality is multiplied by the variable
\(\zeta\); no integration by parts is performed with that multiplier.

The retained coefficient of \(|D^+v|^2\) is exactly
\[
 q\left[{3(n-2)\over8}+
              \theta c_1(k+n-1)/\beta\right]
 \ge {3(n-2)\over4}+2\theta c_1 k/\beta.                         \tag{13}
\]
The coefficient of \(|\sum a_iD_i^-v|^2\) is
\(2-2q\theta\zeta\ge7/6\), using \(q\le10/3\), \(\theta\le1/8\),
and \(\zeta\le1\).
The Hessian term is
\[
 -q\left[(d-1+\theta)H[av]+(1-\theta)k\int\operatorname{tr}H|v|^2\right].
\]
Its lower bound is
\[
 2q c_0 k^2\int\beta
       [\,k+(11n-14)/8\,]|v|^2
 \ge2q c_0 k^3\int\beta|v|^2 .
\]
The negative remainder of (12) is at most
\(8q\theta c_1 k^3\int\beta|v|^2\), leaving at least
\(q c_0 k^3\int\beta|v|^2\ge2c_0 k^3\int\beta|v|^2\).
If the curvature remainder is bounded by \(K k^3\|v\|^2\),
choosing \(\beta_0\ge K/c_0\) leaves \(c_0 k^3\int\beta|v|^2\).

Let \(A=\|D^+v\|^2\), \(D=\int(k/\beta)|D^+v|^2\), and
\(H_0=\int k^3\beta|v|^2\). Equation (11) is therefore at least
\[
 {3(n-2)\over4}A+2\theta c_1D+c_0H_0 .
\]
The cross term in \(A\) is
\(-k\int\Delta f\,|v|^2\ge0\), so
\(A\ge\|\nabla v\|^2+\int k^2\beta^2|v|^2\).
Furthermore
\((k/\beta)|\nabla v|^2\le2(k/\beta)|D^+v|^2+2k^3\beta|v|^2\).
For \(k\ge1\) these imply exactly
\[
 N_k{\cal N}(v)^2\le4A+4D+12H_0 .
\]
Thus one may take
\[
 c_R=\min\{3(n-2)/16,\ \theta c_1/2,\ c_0/12\}.                  \tag{14}
\]
Divide by \(N_k\) and sum the degree components. Smooth functions
follow by spectral approximation; the estimates have no dependence
on the truncation, and smooth compactly supported functions converge
in all the Sobolev norms used here. This proves (2).

## Coercivity and the manuscript hypotheses

Free noncommutative expansion, using \(T^\flat=T^\dagger+Z\), gives
\[
 \|(2T+U)v\|^2-\|(2T^\flat+U^\dagger)v\|^2
 =4(\|Tv\|^2-\|T^\flat v\|^2)+\langle Ev,v\rangle.                \tag{15}
\]
Choose \(C_E(\delta+\delta^2/\beta_0)\le2c_R\). Dropping the
nonnegative second square gives
\({\cal N}(v)\le(2c_R)^{-1/2}\|(2T+U)v\|\).
Since \(\|Jv\|\le C_J\beta_0^{-1}{\cal N}(v)\), increasing the
fixed lower threshold once more absorbs \(J\), proving (3).

For the staged operators, \(\delta=\varepsilon\),
\(c^{ij}=rQ^{ij}\) is real symmetric and sphere-independent,
and the stated trace expansion gives \(P_0=2T+U+J\).
The two smallness assumptions give the three coefficient bounds:
\[
 r=O(\varepsilon\beta^{-2}),\quad
 r f_i=O(\varepsilon\beta^{-1}),\quad
 r(\partial_i f_j+f_if_j)=O(\varepsilon).
\]
The anisotropic contraction \((h^{ij}/r)A_i^*A_j^*\) has angular
order two and size \(O(\varepsilon)\).
Differentiating a normalized coefficient through five base derivatives
costs the permitted factors of \(\beta\); differentiating \(h/r\)
uses no more than five derivatives of \(h\).
The moving-trace construction uses at most one additional derivative
of its coefficients, within its six and the stated eight profile/
smallness derivatives.
There is no additional assumption of compact support on \(r\), of
finiteness of angular degree, or of a relation between the two
frequencies. Only the test function is compactly base-supported.

For the joint manuscript, the scalar estimate may be applied entrywise
before the matrix comparison. Its stated identity for \(P-P_0\), with
\(K_i\in\Psi^0\), \(\nabla K_i\in\beta\Psi^0\), and bounded drifts, gives
\[
 \|(P-P_0)v\|\le C(\|v\|_{H^1_{\rm fiber}}+\|r\nabla v\|)
 \le C(\beta_0^{-1}+\varepsilon\beta_0^{-2}){\cal N}(v).
\]
This is absorbable after the same ordered choices of thresholds.
No squared-norm commutator involving matrix-valued principal symbols
has been used.

The trace expansion itself depends on the geometric Dirichlet construction;
this work verifies its stated analytic implication, not every global
continuation, bootstrap, or inverse-problem step. This distinction is also
recorded as an explicit ledger assumption.

## Proof of the sharp criterion

For complex \(c^{ij}\), the leading base coefficient of \(U^\dagger\)
is \(\bar c^{ij}\).
The fourth-base symbol in \([U^\dagger,U]\) vanishes by scalar
commutativity. Its third-base symbol is exactly \(K\) of (4).
All zero-hit products with the first-base coefficients cancel because
\(c,\bar c\) commute with angular operators. Terms from the base density
are lower-order symbols whose zero-hit products cancel in the same way.
Thus neither a drift nor a choice of density changes \(K\).
The other terms of \(E\) have no third-base coefficient: their only
candidate is an angular commutator with \(c^{ij}\) or \(\bar c^{ij}\).

If \(K=0\), all base orders are at most two. The count calculation (5)
still applies directly to \([U^\dagger,U]\), proving (1).
This argument avoids incorrectly using (6), which need not have base
order one in the complex case.

If \(K(y_0,\xi_0)\ne0\), it is purely imaginary.
Choose a real smooth nonzero cutoff \(\chi\) compactly supported in a
small region where \(-iK(y,\xi_0)\) has a fixed nonzero sign, and a
smooth degree-one fiber section \(w\) of unit norm in a trivialization.
For
\[
 v_\lambda(y,\omega)=\chi(y)e^{i\lambda\,y\cdot\xi_0}w(y,\omega)
\]
each fiber mean is zero, and
\[
 \langle Ev_\lambda,v_\lambda\rangle
 =\lambda^3\int(-iK(y,\xi_0))\chi^2\,dV+O(\lambda^2),\qquad
 {\cal N}(v_\lambda)^2=O(\lambda^2).
\]
All parameters and coefficient seminorms are fixed in this limit.
The leading integral is nonzero, proving necessity.

An explicit example is \(U=a(1+iy_1)\Delta_y\), with any sufficiently
small fixed \(a>0\). Its cubic symbol is
\(K=4ia^2\xi_1|\xi|^2\); along \(\xi=e_1\) the leading form is
\(4a^2\lambda^3\int\chi^2\).
It can satisfy the abstract size bounds on a fixed chart with a
concave profile, but **violates the manuscript's real principal
coefficient hypothesis**. It is not entered as a refutation claim.

## Literature and evidence interpretation

The scalar calculus used in (5), (7), and (8) is an external standard
result: M. S. Joshi, *Introduction to Pseudo-Differential Operators*,
arXiv:math/9906155v1, Theorems 5.4--5.5 and 6.3, and Section 11.
The source was obtained and read by the separate literature worker.
It establishes composition, scalar principal-symbol cancellation, and
Sobolev boundedness; the parameter weights and base-order cancellation
above are proved here, not attributed to that source.

A bounded prior-art lookup also read Paternain--Salo,
*Carleman estimates for geodesic X-ray transforms*,
arXiv:1805.02163v2, Theorems 6.1 and 6.3
(published DOI:10.24033/asens.2557).
Those results assume strictly negative sectional curvature, rather than
the present negative Hessian, and do not supply the stated derivative-
containing perturbation theorem. They are related background, not an
assumption of this proof. No novelty conclusion follows from this lookup.

`verify.py` checks the exact norm identity in the free noncommutative
algebra, the all-\(k,n\) rational identities and positivity bounds in
(9)--(14), the complete filtration/base-order bookkeeping, the weighted
Young identity, and the complex principal-symbol obstruction.
`exact_certificate.json` records those outputs without assigning an
independent Reviewer verdict. The script does not purport to formalize
Sobolev calculus or replace the analytic proof.

The Jacobian adapter's one bounded exact operation checks
\(\Delta((x^2+y^2+z^2)(x^2-y^2))=14(x^2-y^2)\).
This is a normalization check of the projection formula, not a proof for
all degrees. Its exact payload and unmodified typed adapter response are
stored separately. The universal identity is proved above.

Replay:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/angular_coercivity/verify.py
```
