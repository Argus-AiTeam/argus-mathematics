# The torus example and the projected-cycle error

## Result and scope

The staged Example `ex:strict-cones` is correct. It gives a counterexample
to the equalities actually printed in Li--Zhang, arXiv:0708.2520v4,
Theorem 1.3, the first assertion of Corollary 1.4, and the first assertion
of Proposition 3.9. The example satisfies the fullness hypothesis as well
as the existence of a compatible form. Below, an explicit positive
projection of a closed current also disproves the disjointness inference
in the proof of their Theorem 3.7.

This is **not** a counterexample to the staged existence theorem: the
example has an explicit compatible form. Nor does this calculation prove
the staged general cone-duality theorem or the density-splitting theorem.
Independent mathematical review and the novelty/significance determination
are still required. No false assertion in the staged manuscript was
identified in this bounded investigation; the refuted assertions below
are explicitly external.

`verify.py` checks exact identities, primitives, the nonclosed projection,
the source statements, and the archived typed Jacobian result.
`exact_certificate.json` is its reproducible output, not a certificate
that a computer checked the entire differential-geometric proof.
The analytic steps not encoded by that program are proved here.

## 1. The geometric construction

Work on the closed connected torus \(T^4=\mathbb R^4/\mathbb Z^4\), with
its flat metric and volume form \(v=dx_1dx_2dx_3dx_4\), normalized to
integral one. Use the ordered two-form coordinates
\((12,13,14,23,24,34)\). Put
\[
 U=e^{12}+e^{34},\quad V=e^{13}-e^{24},\quad W=e^{14}+e^{23},
 \qquad f=\tfrac14\sin(2\pi x_1),\quad k=\tfrac14\sin(2\pi x_2),
\]
\[
 S=1+f^2+k^2,\quad r=\sqrt S,\quad A=U+fV+kW,\quad F=A/r.
\]
All functions and forms descend smoothly to the torus, and \(r\geq1\).
The three displayed constant forms are self-dual and mutually
orthogonal, of squared norm two. Their wedge matrix is \(2I_3v\).
Consequently \(*F=F\), \(|F|^2=2\), and \(F^2=2v\).

For a two-form \(\alpha\), let \(M_\alpha\) denote the skew matrix such
that \(\alpha(u,w)=u^{\mathsf T}M_\alpha w\). Our convention is
\(F(u,w)=g(Ju,w)\); thus \(J=-M_F=K/r\), where
\[
 K=\begin{pmatrix}
 0&-1&-f&-k\\
 1&0&-k&f\\
 f&k&0&-1\\
 k&-f&1&0
 \end{pmatrix}.
\]
Direct polynomial multiplication gives \(K^2=-SI_4\).
It follows that \(J^2=-I\) and \(J^{\mathsf T}J=I\).
The complex orientation is the stated orientation because
\(F^2=2v>0\). This checks the sign convention, not just an
unoriented almost-complex structure.

The orthogonal splitting for this \(J\) is
\[
 \Lambda_J^+=\mathbb RF\oplus\Lambda_g^-,
 \qquad \Lambda_J^-=\Lambda_g^+\cap F^\perp.
\]
For example it follows by using an oriented orthonormal frame
\((u,Ju,w,Jw)\); equivalently it follows by multiplying the displayed
matrix \(J\). In particular all flat anti-self-dual forms are
\(J\)-invariant.

## 2. A closed compatible form in the class of \(U\)

Set
\[
 \eta=U+2f e^{13}+2k e^{23}.
\]
Its added terms are closed because \(df\) is a multiple of \(dx_1\)
and \(dk\) is a multiple of \(dx_2\). More precisely,
\[
 \eta-U=d\left[-\frac{\cos(2\pi x_1)+\cos(2\pi x_2)}
                         {4\pi}\,dx_3\right].
\]
Thus \([\eta]=[U]\), with a globally defined periodic primitive.
Its self-dual part is \(A=rF\); its anti-self-dual part is
\[
 D=f(e^{13}+e^{24})+k(e^{23}-e^{14}).
\]
It is therefore \(J\)-invariant. The symmetric matrix
\(H=M_\eta J\), which evaluates \(\eta(u,Ju)\), satisfies
\[
 (H-rI)^2=(f^2+k^2)I,\qquad
 \det(\lambda I-H)=
       \big((\lambda-r)^2-f^2-k^2\big)^2.
\]
It has eigenvalues \(r\pm s\), where \(s=\sqrt{f^2+k^2}\), each
twice. Since \((r-s)(r+s)=1\) and \(r>s\geq0\), it is positive
definite. In this example \(s^2\leq1/8\), giving the uniform bound
\(r-s\geq1/\sqrt2\). Also \(\eta^2=2v\).
Thus \(\eta\) is closed, nondegenerate, correctly oriented, and
compatible. The flat fundamental form \(F\) need not be closed:
the almost-Kaehler hypothesis in Li--Zhang requires some compatible
form, not compatibility with a previously fixed metric.

## 3. Anti-invariant cohomology vanishes

Let \(\alpha\) be any smooth closed \(J\)-anti-invariant two-form.
It is flat-self-dual by the splitting above. Hence
\(\delta\alpha=-*d*\alpha=0\), so \(\Delta\alpha=0\).
For the flat torus the Hodge Laplacian acts componentwise as
\(-\sum_i\partial_i^2\). Integration by parts over a periodic
fundamental domain yields
\[
 0=\int\langle\Delta\alpha,\alpha\rangle
   =\sum_{i,j<l}\int|\partial_i\alpha_{jl}|^2.
\]
Every coefficient is constant. Thus
\(\alpha=aU+bV+cW\). Orthogonality to \(F\) gives
\(a+bf+ck=0\) everywhere. At
\((x_1,x_2)=(0,0),(1/4,0),(0,1/4)\) the resulting linear system
has determinant \(1/16\); hence \(a=b=c=0\).
This argument quantifies over all smooth closed anti-invariant forms;
the three evaluations prove independence of three known functions,
not an inference from numerical sampling. Therefore \(H_J^-=0\).

## 4. Explicit fullness, without importing a cone theorem

Here are closed invariant representatives of all six cohomology
directions. Write
\[
 s=\sin(2\pi x_1),\quad t=\sin(2\pi x_2),\quad
 c=\cos(2\pi x_1),\quad d=\cos(2\pi x_2).
\]
In the ordered two-form coordinates specified above, define
\[
 \rho_V=(16s,\,-1+4s^2-2cd,\,2st,\,2st,\,-1-2cd,\,0),
\]
\[
 \rho_W=(16t,\,2st,\,1+2cd,\,-1-2cd+4t^2,\,-2st,\,0).
\]
Their self-dual parts are respectively \(8sA\) and \(8tA\).
Thus they are \(J\)-invariant, including points where \(s\) or
\(t\) vanishes. There is no division by these functions.

The following globally periodic one-forms prove their classes and
closedness explicitly:
\[
\begin{split}
 \theta_V={}&-\frac8\pi\cos(2\pi x_1)\,dx_2\\
 &+\left[-\frac{\sin(4\pi x_1)}{2\pi}
          -\frac{\sin(2\pi x_1)\cos(2\pi x_2)}{\pi}\right]dx_3
 -\frac{\cos(2\pi x_1)\sin(2\pi x_2)}{\pi}\,dx_4,\\
 \theta_W={}&\frac8\pi\cos(2\pi x_2)\,dx_1\\
 &+\left[-\frac{\cos(2\pi x_1)\sin(2\pi x_2)}{\pi}
          -\frac{\sin(4\pi x_2)}{2\pi}\right]dx_3
 +\frac{\sin(2\pi x_1)\cos(2\pi x_2)}{\pi}\,dx_4 .
\end{split}
\]
Direct differentiation gives
\(\rho_V-V=d\theta_V\), \(\rho_W-W=d\theta_W\).
Together with \(\eta\), these realize the classes of \(U,V,W\).
The constant forms
\[
 D_1=e^{12}-e^{34},\quad D_2=e^{13}+e^{24},\quad
 D_3=e^{14}-e^{23}
\]
are closed, anti-self-dual, and hence invariant. The wedge matrix of
\((U,V,W,D_1,D_2,D_3)\) is
\(\operatorname{diag}(2,2,2,-2,-2,-2)v\).

For completeness these constant forms span all of \(H^2(T^4;\mathbb R)\),
without a purity/fullness theorem from the literature. Averaging a
closed form over all translations gives a constant-coefficient form.
For each translation by \(a\), Cartan's formula along the isotopy
\(x\mapsto x+ta\), \(0\leq t\leq1\), says the difference from the
original closed form is exact. Averaging those primitives proves the
same assertion for the translation average. Integrals over the six
coordinate two-tori show that the six constant basic two-forms are
independent. Consequently \(H_J^+=H^2(T^4;\mathbb R)\).
In particular \(J\) is \(C^\infty\)-full and pure, and \(b_2^+=3\).

## 5. Two taming classes, neither compatible

Put \(\beta_\pm=U\pm V\). These constant forms are closed.
Their invariant projections and squares are
\[
 (\beta_\pm)^J=\frac{1\pm f}{r}F,\qquad
 \beta_\pm^2=4v,\qquad \beta_+\wedge\beta_-=0.
\]
An anti-invariant two-form evaluates to zero on \((u,Ju)\).
Thus
\[
 \beta_\pm(u,Ju)=\frac{1\pm f}{r}|u|^2
                 \geq\frac1{\sqrt2}|u|^2.
\]
Both forms are symplectic tamers in the complex orientation.
The bound is global: \(1\pm f\geq3/4\) and \(r^2\leq9/8\).
There is no appeal to a finite grid.

If \(\gamma\) were a closed compatible representative of
\([\beta_+]\), write \(H_\gamma=M_\gamma J\). This matrix is
positive definite. For any invariant two-form \(\gamma\),
\[
 \gamma\wedge\beta_-=
   \frac{1-f}{r}\,\frac{\operatorname{tr}H_\gamma}{2}\,v.
\]
This follows from the invariant/anti-invariant splitting and
\(\langle\gamma,F\rangle=\operatorname{tr}(M_\gamma J)/2\);
the program checks the universal identity with arbitrary invariant
coefficients. The displayed four-form is strictly positive.
But Stokes' theorem on the closed torus gives
\[
 0<\int\gamma\wedge\beta_-=
     [\beta_+]\cdot[\beta_-]=0,
\]
a contradiction. Interchanging the signs proves the other class
has no compatible representative either. Thus
\[
 \mathcal K_J^c\subsetneq\mathcal K_J^t,\qquad
 \mathcal K_J^c+H_J^-=\mathcal K_J^c,
 \qquad [U]\in\mathcal K_J^c .
\]

## 6. An explicit witness to the invalid projected-cycle inference

Define the closed current
\[
 T(\alpha)=\int_{T^4}\beta_-\wedge\alpha .
\]
Because \(\beta_-\) is self-dual, its flat coefficient form is also
\(\beta_-\). Let \(P=\pi_{1,1}T\) be its invariant projection.
Its coefficient form and the complementary anti-invariant form are
\[
 P=\frac{1-f}{S}(U+fV+kW)=\frac{1-f}{r}F,\qquad Q=\beta_--P .
\]
This is a nonzero positive structure current. Indeed for any
semipositive invariant test form its evaluation is the positive
factor \((1-f)/r\) times the nonnegative \(F\)-trace. The same
calculation identifies it as a positive sum of complex-line currents.
Also \(T=P+Q\) is closed and \(Q\) is a smooth anti-invariant form.
Since \(P\) is self-dual, its being closed as a current is equivalent
to \(dP=0\). At the origin, however, direct differentiation gives
\[
 dP|_0=-\pi e^{124}-\frac{\pi}{2}e^{134}\ne0.
\]
Thus \(P\) belongs to the actual projected-cycle space
\(\pi_{1,1}\mathcal Z\), even before taking its closure, but is
not a closed positive current.

Take \(e=[\beta_+]\). It is positive on every nonzero closed
positive complex cycle: evaluate such a cycle on its tamer
\(\beta_+\), whose complex-line values have a uniform positive lower
bound. It is also an interior point of that dual cone in \(H_J^+\):
small closed representatives of a cohomology basis can be added
without losing tameness, and \(H_J^+=H^2\).

The form \(\xi_+=\eta+\rho_V\) is a specific closed invariant
representative of \(e\). Because projection is dual to inclusion of
invariant tests,
\[
 P(\xi_+)=T(\xi_+)
  =\int\beta_-\wedge\xi_+=[\beta_-]\cdot e=0.
\]
For the functional on projected cycles defined by \(e\), \(P\) is
therefore a nonzero positive current in its kernel. This is an
explicit counterexample to the sentence asserting that this kernel
and all nonzero positive structure currents are disjoint.
Positivity on **closed** complex cycles cannot be promoted to
positivity on positive **projections** of cycles.

## 7. Source-specific reconciliation

Primary sources preserved here:

* `literature/0708.2520v4.tex`: the original source obtained from
  <https://arxiv.org/src/0708.2520v4>.
* `literature/LiZhang2009.published.pdf`: the public publisher PDF,
  DOI <https://doi.org/10.4310/CAG.2009.v17.n4.a4>,
  *Communications in Analysis and Geometry* 17(4), 651--683 (2009).

The bounded primary-source investigation found the following
version correspondence; the published version retains the disputed
claims and implication:

| Author version v4 | Published version |
|---|---|
| Theorem 1.3, p. 3 | Theorem 1.1, p. 654 |
| Corollary 1.4, p. 3 | Corollary 1.1, p. 655 |
| Proposition 3.9, pp. 18--19 | Proposition 3.1, p. 672 |
| Theorem 3.7 and proof, pp. 17--18 | Theorem 3.4 and proof, p. 671 |

The relevant published pages are also preserved as
`literature/published_front_statements.txt` and
`literature/published_proof_statements.txt`. PDF text extraction drops
the negation stroke in some occurrences of \(\ne\); the exact TeX
and the rendered PDF, not those damaged extracted glyphs, determine
the nonemptiness hypothesis. No typographical refutation is inferred
from this extraction artifact.

Theorem 1.3 assumes \(C^\infty\)-fullness and
\(\mathcal K_J^c\ne\varnothing\); Sections 2 and 4 check both
directly. Corollary 1.4 assumes a four-manifold and a nonempty
compatible cone. Its \(b^+=1\) restriction qualifies only its final
"in particular" assertion, not its first equality. Proposition 3.9
asserts
\(\mathcal K_J^t\cap H_J^{1,1}=\mathcal K_J^c\) under nonemptiness
of the compatible cone; here \(H_J^{1,1}=H^2\), so it too fails.
None of these statements assumes integrability or fixes the flat
metric as the metric of a compatible form.

The proof of Theorem 3.7 constructs a functional on
\(\overline{\pi_{1,1}\mathcal Z}/\overline{\pi_{1,1}\mathcal B}\).
Its decisive sentence is:

> "By our choice of \(e\), as subsets of
> \(\mathcal E_{1,1}(M)_{\mathbb R}\), \(L\) and
> \(\mathfrak C(J)\backslash\{0\}\) are disjoint."

Section 6 disproves that sentence under its stated premise.
Theorem 3.7 is then invoked for the false equality in Proposition 3.9
and the reverse inclusion in Theorem 1.3. The other inclusion,
\(\mathcal K_J^c+H_J^-\subseteq\mathcal K_J^t\), is valid:
closed anti-invariant forms vanish on complex lines.
This investigation does not refute the \(b^+=1\) special conclusion.

The exact v4 source statements are reproduced in
`exact_certificate.json`; the program requires their literal
whitespace-normalized text. External false claims have ledger IDs
prefixed `F_EXTERNAL_`, never manuscript provenance.

The current arXiv record was reported by the bounded source
investigation to list v4 (September 15, 2009) as latest, and its
unversioned PDF to agree with v4. No relevant correction or matching
strict-cone counterexample was verified in that bounded search.
This is **not** an assertion that no correction or precedent exists,
and does not establish novelty. The source investigation also
identified arXiv:0812.3680v2, Theorem 2.3, as a prior general
purity/fullness result in dimension four; our argument does not rely
on it, because the required representatives are explicit.

The staged October 6 manuscript asserts cone-sum equality only
when \(h_J^-=b_2^+-1\). Here these numbers are 0 and 2, respectively.
Its claimed necessary strict-positivity test correctly excludes
\([\beta_\pm]\), since their intersection is zero. Consequently the
example and these necessary conditions do not conflict. Their
general sufficiency, and the manuscript's general existence proof,
remain separate open audit obligations in the proof graph.

## 8. Structural extension and evidence boundaries

The same strict-cone construction works with arbitrary smooth
one-periodic real functions \(f(x_1),k(x_2)\) having zero means,
both nonconstant, and \(\|f\|_\infty<1\). Define \(F,J,\eta\) by
the same formulas. The universal identities in Sections 1--2 still
give compatibility for every finite value of \(f,k\). Zero means
give periodic primitives of \(2f\,dx_1\) and \(2k\,dx_2\), so
\([\eta]=[U]\). The harmonic argument and independence of the two
variables give \(H_J^-=0\). The two constant forms \(U\pm V\)
tame, and their zero intersection excludes compatible
representatives exactly as before. No smallness condition on \(k\)
is needed. The explicit fullness formulas of Section 4 are asserted
only for the sine specialization; they are not silently extended
to this larger family. Novelty of this extension is not established.

Jacobian 0.14.0, protocol 2025-11-25, was discovered and its exact
typed contract inspected before running
`matrix.symbolic.characteristic_polynomial.compute`. The payload
is the polynomial matrix \(K\), not the square-root expression \(J\).
It returned \((\lambda^2+S)^2\) in 44 ms, with adapter exit code
zero. The raw discovery, contract, exact payload, typed output and
status are in `jacobian/`. This operation does not accept
differential forms, a smooth positivity quantifier, or a cohomology
claim. Its output is used only for the characteristic polynomial,
and is independently replayed by SymPy; it is not substituted for
any analytic argument.

The persisted certificate also replays from its own directory.
`adversarial_controls.json` records that reversing the quaternion
sign or the wedge orientation is rejected by an exact nonzero
remainder, rather than producing a success-shaped answer.

`Main.lean` formalizes the polynomial endomorphism, its normalized
square, its norm identity, the decisive wedge products, and the
elementary positivity implications. `statement_fidelity.md`
states the exact boundary. Flat harmonicity, periodic primitives
as global de Rham arguments, Stokes' theorem, positive-current
duality, and the source interpretation are not Lean-certified.
No imported external cone theorem is assumed true in this proof.
