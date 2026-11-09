# Essential spectrum of finite-shift dilation restrictions

**Abstract.** Let \(S\) be the zero-fill right shift on
\(L^2((0,\infty),dx)\), and let \(D\) be the self-adjoint dilation generator.
For every nonzero complex polynomial \(P\) with \(P(1)=0\) and no root in the
open unit disk, we construct singular Weyl sequences in the common domain
\(P(S)C_c^\infty(0,\infty)\), with explicit residual bounds
\(K(P,\lambda)/n\) for every real \(\lambda\). Consequently every
self-adjoint extension of this restriction of \(D\) has essential spectrum
equal to \(\mathbb R\). The conclusion transfers unitarily to the completion
in the norm \(\|P(S)f\|_2\), without assuming a bounded inverse on the
original \(L^2\) space. The construction applies the finite-shift polynomial
after a cutoff on a suitable primitive, preserving range membership despite
the failure of general cutoffs to preserve the common domain. Already for
\(P(z)=1-z\), this rules out an exclusively discrete zero-ordinate spectrum
for every extension in the stipulated metric realization, rather than only
excluding a specified eigenfunction family. The theorem is unconditional and
model-specific; it neither excludes embedded eigenvalues nor implies a
conclusion about RH or other Hilbert-Polya realizations.

## 1. Statement and domains

Work in the complex Hilbert space \(H=L^2((0,\infty),dx)\). For \(a\geq0\), let
\[
 (S_a f)(x)=
 \begin{cases}f(x-a),&x>a,\\0,&0<x\leq a.\end{cases}
 \qquad S=S_1.
\]
These are isometries, and \(S_aS_b=S_{a+b}\). Write
\(\mathcal D_0=C_c^\infty(0,\infty)\), with functions extended by zero to the
whole real line whenever translations or derivatives are used.

Define the unitary logarithmic transform and the dilation operator by
\[
 (Mf)(t)=e^{t/2}f(e^t),\qquad
 D=M^{-1}(-2i\,d/dt)M,\qquad
 \operatorname{Dom}D=M^{-1}H^1(\mathbb R).
 \tag{1}
\]
Thus \(Df=-i(2xf'+f)\) on \(\mathcal D_0\). Throughout,
\(\sigma_{\rm ess}\) means the spectrum with the isolated eigenvalues of finite
multiplicity removed.

**Theorem.** Let \(P\) be a nonzero complex polynomial with \(P(1)=0\) and
no root in the open unit disk. Then:

1. \(P(S)\) is bounded and injective with dense range.
   The space \(P(S)\mathcal D_0\) is dense in \(H\) and is contained in
   \(\mathcal D_0\). The symmetric operator
   \[
   T_P=D|_{P(S)\mathcal D_0}
   \tag{2}
   \]
   has the self-adjoint extension \(D\).
2. The completion \(\mathcal K_P\) of \(\mathcal D_0\) in
   \(\|f\|_P=\|P(S)f\|_2\) is unitarily identified with \(H\) by the extension
   \(U_P\) of \(P(S)\).
3. For each real \(\lambda\), the explicit functions in (16) below give unit
   vectors \(u_n\in\operatorname{Dom}T_P\), supported in \([2^n,\infty)\), with
   \[
   \|(D-\lambda)u_n\|_2\leq K(P,\lambda)/n
   \quad(n\geq N(P,\lambda)),
   \tag{3}
   \]
   where (15) specifies finite constants and an integer threshold.
4. Every self-adjoint extension \(A\supset T_P\) satisfies
   \[
   \sigma_{\rm ess}(A)=\sigma(A)=\mathbb R.
   \tag{4}
   \]
   The same holds for every self-adjoint extension of
   \(H_{P,0}=U_P^{-1}T_PU_P\) in \(\mathcal K_P\). None has compact resolvent
   or a spectrum consisting exactly of a locally finite discrete set of
   zeta-zero ordinates.

Part 4 does **not** assert absolute continuity for arbitrary extensions, exclude
embedded eigenvalues, identify their eigenfunctions, or address other
Hilbert-space norms or Hilbert-Polya models.

### Proof of the operator and metric preliminaries

The change of variables \(x=e^t\) proves that \(M\) is unitary. Under the
unitary Fourier transform with phase \(e^{-it\xi}\), the operator
\(-2i\,d/dt\) on \(H^1(\mathbb R)\) is multiplication by \(2\xi\) on its
maximal domain. Multiplication by this real function is self-adjoint; hence
(1) is self-adjoint. This also establishes the domain, rather than choosing an
endpoint condition for a formal differential expression.

For \(P(z)=\sum_{k=0}^d p_kz^k\),
\(\|P(S)\|\leq\sum_k|p_k|\), and finite right translations preserve
\(\mathcal D_0\). The root condition implies \(p_0\ne0\).
If \(P(S)f=0\), its restriction to \((0,1)\) gives \(p_0f=0\).
Inductively, on \((j,j+1)\) all terms with \(k\geq1\) either vanish by
zero-fill or involve strips already shown to vanish. Thus \(f=0\).

For dense range, factor \(P\) over \(\mathbb C\). A factor \(S-rI\) with
\(|r|>1\) is invertible by the norm-convergent Neumann series. For \(|r|=1\),
\[
 ((S-rI)^*g)(x)=g(x+1)-\overline r\,g(x).
\]
An element of this kernel has the same \(L^2\) norm on every unit strip.
Square integrability therefore forces every strip norm to be zero. Thus
\(\ker(S-rI)^*=\{0\}\), so \(S-rI\) has dense range.
A product of bounded dense-range operators has dense range: continuity gives
\(\overline{B(CH)}\supset\overline{BH}=H\) if \(\overline{CH}=H\).
This proves dense range of \(P(S)\). Density of \(\mathcal D_0\) and boundedness
of \(P(S)\) then give density of \(P(S)\mathcal D_0\).

It follows that (2) is densely defined and symmetric, and is extended by the
self-adjoint operator \(D\). The map \(P(S)\) on \(\mathcal D_0\) is an
isometry for the indicated metric norm and has dense image. It therefore
extends to a unitary \(U_P:\mathcal K_P\to H\).

This is a completion statement, not a boundedly invertible similarity on the
original \(H\). Indeed, write \(P(z)=(1-z)R(z)\) and put
\(v_N=N^{-1/2}{\bf1}_{(0,N)}\), for integer \(N\geq1\). Then
\[
 \|v_N\|_2=1,\qquad
 \|(I-S)v_N\|_2^2=2/N,\qquad
 \|P(S)v_N\|_2\leq\|R(S)\|\sqrt{2/N}.
 \tag{5}
\]
There is no positive lower bound for \(P(S)\) on \(H\), nor on its dense
subspace \(\mathcal D_0\). Completing all of \(H\) in the metric norm would
give the same completion, since \(\mathcal D_0\) is also dense for that norm.

The domain of \(H_{P,0}\) is the embedded copy of \(\mathcal D_0\) in
\(\mathcal K_P\), and
\[
 H_{P,0}\psi=U_P^{-1}D\,P(S)\psi .
 \tag{6}
\]
Here \(U_P^{-1}\) takes values in the completion. Formula (6) does not assume
that \(D\,P(S)\psi\) belongs to the range of \(P(S)\) acting on the original
\(L^2\) space. This is the domain-correct meaning of the conjugation.

## 2. A smooth cutoff with exact bounds

The following deliberately coarse constants make the construction fully
explicit; their size is not a claimed extremal result. Set \(v(t)=t(1-t)\) and
\[
 \chi(t)=
 \begin{cases}\exp(-1/v(t)),&0<t<1,\\0,&\text{otherwise}.\end{cases}
\]
Define integer polynomials and integer bounds, for every \(j\geq0\), by
\[
 A_0(t)=1,\qquad
 A_{j+1}(t)=v(t)^2A_j'(t)+v'(t)(1-2jv(t))A_j(t),
 \qquad
 U_j=(2j)!\sum_\ell |[t^\ell]A_j(t)|.
 \tag{7}
\]
On \(0<t<1\), induction by the product rule gives
\[
 \chi^{(j)}(t)=e^{-1/v(t)}v(t)^{-2j}A_j(t).
 \tag{8}
\]
All these derivatives tend to zero at both endpoints: polynomials are bounded
there and \(y^k e^{-y}\to0\) as \(y\to\infty\). For example this limit follows
from \(e^y\geq y^{k+1}/(k+1)!\). Thus the zero extension of \(\chi\) is smooth.

On \([0,1]\), a polynomial is bounded in absolute value by the sum of the
absolute values of its coefficients. The inequality
\(y^{2j}e^{-y}\leq(2j)!\) therefore proves
\[
 \|\chi^{(j)}\|_2\leq U_j .
 \tag{9}
\]
For a rational lower bound, on \([1/3,2/3]\) one has \(v(t)\geq2/9\).
The elementary series bound \(e<3\) gives
\(\chi(t)\geq e^{-9/2}>e^{-5}>1/243\). Consequently
\[
 \|\chi\|_2>1/(243\sqrt3)>h,\qquad h:=1/486.
 \tag{10}
\]
Here \(e<3\) follows directly from \(k!\geq2^{k-1}\) for \(k\geq2\),
with strict inequality for some terms in the exponential series.

For later replay, the first polynomials and constants are
\[
 A_1=1-2t,\quad
 A_2=1-6t+12t^2-12t^3+6t^4,\qquad
 U_0=1,\quad U_1=6,\quad U_2=888.
 \tag{11}
\]
The bound on \(v\) also follows from
\(v(t)=1/4-(t-1/2)^2\); the retained Jacobian enclosure computes its exact
range enclosure \([2/9,1/4]\) on \(|t-1/2|\leq1/6\).
Neither that finite computation nor (11) substitutes for the all-order
induction (7)-(9).

## 3. Exact finite-difference and commutator estimates

Let \(m\geq1\) be the multiplicity of the zero of \(P\) at 1. Write
\[
 P(z)=(1-z)^mQ(z),\quad
 Q(z)=\sum_{k=0}^r b_kz^k,\quad Q(1)\ne0,\quad d=m+r.
\]
For \(\psi\in\mathcal D_0\), the fundamental theorem of calculus, iterated
\(m\) times on its smooth zero extension, gives the **exact identity**
\[
 (I-S)^m\psi(x)=
 \int_{[0,1]^m}\psi^{(m)}(x-t_1-\cdots-t_m)\,dt .
 \tag{12}
\]
For \(m=1\) this is \(\psi(x)-\psi(x-1)=\int_0^1\psi'(x-t)\,dt\).
Applying \(I-S\), then this same identity to the integrand, proves the
inductive step. There is no boundary distribution, since \(\psi\) vanishes
on a neighborhood of zero.

Put \(f=\psi^{(m)}\). Commutation of right shifts gives
\[
 P(S)\psi=\sum_{k=0}^r b_k
       \int_{[0,1]^m} S_{k+t_1+\cdots+t_m}f\,dt .
 \tag{13}
\]
For each fixed \(\psi\) these integrands are smooth, have their supports in
a common compact subset of \((0,\infty)\), and have uniformly bounded
derivatives. Integration and application of \(D\) may therefore be interchanged.

Introduce the finite constants
\[
 q=|Q(1)|>0,\qquad
 B_0=\sum_{k=0}^r|b_k|,\qquad
 B_1=\sum_{k=0}^r|b_k|(k+m/2).
\]
The identities
\[
 S_af-f=-\int_0^a S_sf'\,ds,\qquad
 (D-\lambda)S_af=S_a(D-\lambda)f-2iaS_af'
\]
hold on the smooth zero extensions, including at the translation boundary.
Minkowski's inequality, the isometry of \(S_a\), and
\(\int_{[0,1]^m}(k+\sum_jt_j)\,dt=k+m/2\) imply
\[
 \begin{split}
 \|P(S)\psi-Q(1)f\|_2&\leq B_1\|f'\|_2,\\
 \|P(S)\psi\|_2&\geq q\|f\|_2-B_1\|f'\|_2,\\
 \|(D-\lambda)P(S)\psi\|_2
   &\leq B_0\|(D-\lambda)f\|_2+2B_1\|f'\|_2 .
 \end{split}
 \tag{14}
\]
These estimates apply to arbitrary complex coefficients of \(P\); positivity
of the averaging measure for \(Q\) is neither assumed nor needed.

## 4. Explicit common-domain singular Weyl sequences

Fix \(\lambda\in\mathbb R\), and set
\[
 \alpha=-\tfrac12+\tfrac{i\lambda}{2},\qquad
 R_m(X)=\prod_{\ell=1}^m(X+\alpha+\ell)=\sum_{j=0}^m c_jX^j,
 \qquad
 (X+\alpha)R_m(X)=\sum_{j=0}^{m+1}d_jX^j .
\]
In particular \(c_0\ne0\): every factor \(\alpha+\ell\) has positive
real part \(\ell-1/2\). Using (7), define
\[
 \begin{split}
 A&=\sum_{j=1}^m |c_j|U_j,&
 B&=\sum_{j=0}^m |c_j|U_{j+1},&
 C&=\sum_{j=0}^{m+1}|d_j|U_j,\\
 \kappa&=q|c_0|h,&
 N(P,\lambda)&=\max\{1,\lceil 2(qA+B_1C)/\kappa\rceil\},&
 K(P,\lambda)&=4(B_0B+B_1C)/\kappa .
 \end{split}
 \tag{15}
\]
All sums and products here are finite, \(\kappa>0\), and the estimates involve
no root or spectral sampling.

For integer \(n\geq N(P,\lambda)\), put
\[
 s_n(x)=\frac{\log x-n\log2}{n},\qquad
 \psi_n(x)=x^{m+\alpha}\chi(s_n(x)),\qquad
 f_n=\psi_n^{(m)},\qquad
 u_n=\frac{P(S)\psi_n}{\|P(S)\psi_n\|_2}.
 \tag{16}
\]
The power uses the real logarithm of \(x>0\).
Both \(\psi_n\) and all its derivatives belong to \(\mathcal D_0\), with
support in \([2^n,2^ne^n]\).

Successive differentiation proves, for every smooth \(F\) and every exponent
\(\beta\),
\[
 \frac{d}{dx}\bigl(x^\beta F(s_n(x))\bigr)
  =x^{\beta-1}\bigl(\beta+n^{-1}\partial_s\bigr)F(s_n(x)).
\]
The \(m\) factors so obtained commute. Therefore
\[
 \begin{split}
 f_n(x)&=x^\alpha\sum_{j=0}^m c_j n^{-j}\chi^{(j)}(s_n(x)),\\
 f_n'(x)&=x^{\alpha-1}\sum_{j=0}^{m+1}d_j n^{-j}\chi^{(j)}(s_n(x)),\\
 (D-\lambda)f_n(x)
   &=-\frac{2i}{n}x^\alpha
       \sum_{j=0}^m c_j n^{-j}\chi^{(j+1)}(s_n(x)).
 \end{split}
 \tag{17}
\]
The last identity uses \(-i(2\alpha+1)=\lambda\), with no asymptotic error.

For every \(F\) supported in \([0,1]\), the change of variables \(s=s_n(x)\)
and \(\operatorname{Re}\alpha=-1/2\) give
\[
 \|x^\alpha F(s_n(x))\|_2=\sqrt n\,\|F\|_2,\qquad
 \|x^{\alpha-1}F(s_n(x))\|_2\leq 2^{-n}\sqrt n\,\|F\|_2 .
 \tag{18}
\]
Applying (9)-(10), the triangle inequality, and \(n^{-j}\leq n^{-1}\)
for \(j\geq1\), equations (17)-(18) give
\[
 \begin{split}
 \|f_n\|_2&\geq\sqrt n\,(|c_0|h-A/n),\\
 \|f_n'\|_2&\leq2^{-n}\sqrt n\,C,\\
 \|(D-\lambda)f_n\|_2&\leq2\sqrt n\,B/n .
 \end{split}
 \tag{19}
\]
Inserting these bounds into (14) yields
\[
 \begin{split}
 \|P(S)\psi_n\|_2
  &\geq\sqrt n\,(\kappa-qA/n-B_1C2^{-n}),\\
 \|(D-\lambda)P(S)\psi_n\|_2
  &\leq2\sqrt n\,(B_0B/n+B_1C2^{-n}).
 \end{split}
 \tag{20}
\]
For integers \(n\geq1\), \(2^{-n}\leq1/n\). The choice of \(N\) thus makes
the first parenthesis at least \(\kappa/2>0\), justifying normalization.
More precisely,
\[
 \|(D-\lambda)u_n\|_2
 \leq
 \frac{2(B_0B/n+B_1C2^{-n})}
      {\kappa-qA/n-B_1C2^{-n}}
 \leq \frac{K(P,\lambda)}n .
 \tag{21}
\]

Every shift in \(P(S)\) is nonnegative, so
\[
 \operatorname{supp}u_n\subset [2^n,2^ne^n+d].
 \tag{22}
\]
In particular, for any \(g\in H\),
\[
 |\langle g,u_n\rangle|
 \leq\|{\bf1}_{[2^n,\infty)}g\|_2\longrightarrow0.
 \tag{23}
\]
This proves weak convergence to zero, not just approximate eigenvector
behavior. No assertion of graph-norm density of \(P(S)\mathcal D_0\) was used.

## 5. Why the conclusion holds for every extension

Let \(A\) be any self-adjoint extension of \(T_P\).
The vectors (16) are in its domain, and on these vectors only,
\[
 (A-\lambda)u_n=(T_P-\lambda)u_n=(D-\lambda)u_n.
 \tag{24}
\]
An arbitrary extension is not being identified with \(D\).

For completeness, the singular-sequence implication can be seen directly.
If \(\lambda\notin\sigma(A)\), boundedness of the inverse of \(A-\lambda\)
contradicts unit norm and (21). If \(\lambda\) were an isolated eigenvalue
of finite multiplicity, let \(E\) be its finite-rank spectral projection and
choose a spectral gap \(\delta>0\) from \(\lambda\) to the rest of the spectrum.
The spectral theorem gives
\[
 \|(A-\lambda)u_n\|_2\geq\delta\|(I-E)u_n\|_2 .
\]
But \(Eu_n\to0\) in norm by (23) and finite rank, so the right side tends to
\(\delta\), a contradiction. This proves \(\lambda\in\sigma_{\rm ess}(A)\).
Since \(\lambda\) was arbitrary and a self-adjoint spectrum is real, (4) follows.

There is also a direct compact-resolvent contradiction. If
\(R=(A-i)^{-1}\) were compact, (23) would give \(Ru_n\to0\) in norm, whereas
\[
 u_n=R(A-\lambda)u_n+(\lambda-i)Ru_n
\]
and (21) would then give \(\|u_n\|_2\to0\).

Finally, unitary conjugation by \(U_P\) bijects the self-adjoint extensions of
(6) with those of (2), preserves their spectra and essential spectra, and
preserves compactness of resolvents. This proves the completion statement
with its full domain qualification.

## 6. BBM specialization, with the convention stated

Take \(P(z)=1-z\), \(\Delta=I-S\), and the zero-fill shift of Section 1.
Then \(m=1\), \(Q=1\), \(q=B_0=1\), and \(B_1=1/2\).
With \(\alpha=-1/2+i\lambda/2\) and
\(\rho=|\alpha+1|=\sqrt{1+\lambda^2}/2\), the constants reduce exactly to
\[
 \begin{split}
 A&=6,\qquad B=6\rho+888,\qquad
 C=\rho^2+6|\lambda|+888,\qquad \kappa=\rho/486,\\
 N&=\max\{1,\lceil(12+C)/\kappa\rceil\},\qquad
 K=4(B+C/2)/\kappa .
 \end{split}
 \tag{25}
\]
The primitive is simply
\[
 \psi_n(x)=x^{1/2+i\lambda/2}\chi(s_n(x)),\qquad
 \Delta\psi_n(x)=\int_0^1\psi_n'(x-t)\,dt .
 \tag{26}
\]
For example, at \(\lambda=0\), (25) gives the exact, intentionally loose
values \(N=875043\) and \(K=5190966\). These numbers are arithmetic examples,
not the justification of the theorem for other \(\lambda\) or other \(P\).

Every self-adjoint extension of
\(D|_{\Delta\mathcal D_0}\), and every corresponding extension of (6) in the
\(\Delta\)-metric completion, therefore has essential spectrum \(\mathbb R\).
This strengthens an exclusion of a specified eigenfunction family to an
obstruction independent of the eigenfunction ansatz and of the choice of
self-adjoint extension.

BBM's original formal expression is \(\Delta^{-1}D\Delta\), with states
\(-\zeta(z,x+1)\) and \(E=i(2z-1)\). The original analytic translation convention
must not be silently equated with zero-fill on a half-line. The present
corollary concerns exactly the zero-fill metric realization defined above and
in the Liu source below, and any realization extending the specified common
domain. It is not a claim about every possible interpretation of BBM's formal
expression. For \(z=1/2+it\), the stated energy is \(-2t\); either sign or
rescaling of a discrete ordinate list is excluded by (4).

## 7. Exact replay and its limits

The retained Jacobian discovery and inspected contract are
`jacobian_identity_discovery.json` and `jacobian_box_contract.json`.
The bounded operation is `polynomial.box.enclosure.compute`, with exact input
`finite_shift_box_payload.json` and full typed output
`finite_shift_box_output.json`. The output preserves the sidecar server version,
protocol, operation request, and result; the adjacent process record preserves
exit, timeout, and error information. This operation checks only the cutoff
interval bound, not a theorem about unbounded operators.

`check_finite_shift_certificate.py` performs 28 exact checks of the rational
interval bound, the displayed integer cutoff constants, the symbolic
differential identities underlying (7), (14), and (17), and the BBM arithmetic
in (25). Its saved output is `finite_shift_exact_certificate.json`. With
SymPy available, the retained replay command, run from the campaign root, is:

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
    research/check_finite_shift_certificate.py
```

The all-order finite-difference identity is proved by induction in (12);
the universal quantifiers and analytic domain/limit arguments are supplied by
this proof, not by a finite collection of numerical checks. There is no Lean
certificate and no assertion of kernel-checked functional analysis.

The saved arithmetic output is retained as generated, including its
`independent_review: "not_performed"` and `novelty_status: "unverified"`
fields. The arithmetic program cannot assess those questions. Subsequent
independent analytic review and exact replay are recorded separately in
`roles/reviewer/progress.json`, not by relabeling the program's output.

## 8. Relation to the closest prior results

The closest comparison is Liu's zero-fill \(\Delta\)-metric restriction,
not an unspecified interpretation of the formal BBM conjugation. References
below use the displayed versions and proposition locators. A result about a
different norm, domain, or chosen extension is not transferred to the present
realization without proof.

* **Kejun Liu**, *Metric completion of the Bender-Brody-Mueller Hamiltonian:
  dilation spectrum and missing eigenstates*,
  [arXiv:2607.19067v1](https://arxiv.org/abs/2607.19067v1),
  DOI [10.1088/1674-1056/aeb248](https://doi.org/10.1088/1674-1056/aeb248).
  Supplemental Lemma S6 and Theorem S7 give the \(P=1-z\) completion;
  Theorem S9 gives the selected free realization's spectrum. Theorems S12
  and S14 give infinite deficiency indices and adjoint eigenspaces.
  Theorem S15 and Corollary S16 exclude the specified BBM states from the
  completion. These results do not by themselves determine the essential
  spectra of all self-adjoint extensions.
* **Bender, Brody, Mueller**, *Hamiltonian for the zeros of the Riemann zeta
  function*, [arXiv:1608.03679v4](https://arxiv.org/abs/1608.03679v4),
  DOI [10.1103/PhysRevLett.118.130201](https://doi.org/10.1103/PhysRevLett.118.130201):
  equation (1), the pseudo-Hermiticity discussion, and the final domain and
  self-adjointness qualifications.
* **Bellissard**, [arXiv:1704.02644v1](https://arxiv.org/abs/1704.02644v1),
  Problems 1-2; **BBM's reply**,
  [arXiv:1705.06767v1](https://arxiv.org/abs/1705.06767v1), Issues 1-2 and 4:
  half-line translation/domain problems, ordinary-\(L^2\) normalizability, and
  the distinction between formal identities and self-adjointness.
* **Bender and Brody**, [arXiv:1710.04411v2](https://arxiv.org/abs/1710.04411v2),
  DOI [10.1088/1751-8121/aab068](https://doi.org/10.1088/1751-8121/aab068),
  "Relation to the Berry-Keating system": its assertion about a bounded
  inverse of the difference operator is not imported into this zero-fill
  \(L^2\) setting, where (5) forbids one.
* **Moxley**, DOI
  [10.1063/1.5012170](https://doi.org/10.1063/1.5012170),
  [HAL manuscript v2](https://hal.science/hal-01620984v2/file/ICMSAr15.pdf),
  pages 3-4, equations (7)-(15): a transformation with a different
  \(L^2(1,\infty)\) setting, not the common-domain extension theorem here.
* **Endres and Steiner**,
  [arXiv:0912.3183v5](https://arxiv.org/abs/0912.3183v5),
  DOI [10.1088/1751-8113/43/9/095204](https://doi.org/10.1088/1751-8113/43/9/095204),
  Section 2, equations (10)-(20): the usual half-line dilation decomposition
  and essential self-adjointness. Their operator is \(D/2\) at \(\hbar=1\);
  their compact-graph extension results concern a different setting.

Against the strongest directly relevant result, Liu's supplement, the
additional conclusion already matters at \(P=1-z\): neither a different
eigenfunction ansatz nor a different self-adjoint extension of this common
restriction can produce an exclusively discrete spectrum. The proof does not
infer this from the free extension, adjoint eigenfunctions, or infinite
deficiency indices; those failed inference routes remain retired in the ledger.

This is a stronger obstruction to the *purely discrete realization target*,
not a logical strengthening of every Liu proposition. In particular, (4) does
not imply nonmembership of the specified BBM states in the completion, the free
extension's simple absolute continuity, or the deficiency-index calculation.
Those are separate results. In particular, Liu's state exclusion already
applies independently of the extension, but only to the specified vectors;
the present obstruction applies independently of the eigenfunction ansatz,
but only to the exclusively discrete total-spectrum target.

## 9. Comparison with general extension and localization results

This comparison separates the standard spectral inference from the
operator-specific construction. None of these sources has a polynomial-root
hypothesis corresponding to the one in Section 1. Their hypotheses must be
verified for the *range-restricted domain*, not just for the formal dilation
expression. Source passages are retained in
`literature/extension_primary_excerpts.txt` and
`literature/localization_primary_excerpts.txt`; their independent attributions
are recorded under `L1275-SOURCE-COMPARISON` in `MATH_STATE.json`.

### 9.1 Weyl's criterion is the standard step; extension invariance is conditional

Gerald Teschl, *Mathematical Methods in Quantum Mechanics*, second edition
(2014), ISBN 978-1-4704-1704-8,
[author-hosted text](https://www.mat.univie.ac.at/~gerald/ftp/book-schroe/schroe2.pdf),
Lemma 6.17, printed pp. 170-171, is precisely the singular Weyl criterion
proved in the form needed in Section 5. Once the sequences are in
\(P(S)\mathcal D_0\), its application to **every** extension is immediate.
There is no new extension theorem in that implication.

The same book, Theorem 6.19, pp. 171-172, gives equality of essential spectra
for two self-adjoint operators whose resolvent difference is compact at one
common resolvent point. Theorem 6.20, p. 172, obtains invariance over **all**
extensions from equal **finite** defect indices. The latter cannot cover even
\(P=1-z\), whose indices are infinite by the already attributed Liu S12.
The former would give an alternative proof if, for every extension \(A\), one
established
\[
 (A-i)^{-1}-(D-i)^{-1}\ \hbox{compact}.
 \tag{27}
\]
Neither the common restriction nor Hilbert-space density establishes (27).
We do not claim that (27) is false for this family; it is an additional
unproved hypothesis, not a supplied shortcut.

The distinction is substantive at infinite deficiency. Alessandro
Michelangeli, *On creating new essential spectrum by self-adjoint extension
of gapped operators*,
[arXiv:2304.02579v3](https://arxiv.org/pdf/2304.02579v3),
equation (1.1), pp. 1-2, and Corollary 3.6, p. 16, treats a densely defined
symmetric **gapped** operator with infinite deficiency index in an
infinite-dimensional complex Hilbert space. For any closed subset \(K\) of
the closure of its gap, **there exists** an extension whose essential spectrum
contains \(K\). For a finite gap \((a,b)\), the gap assumption is
\[
 \|(T-(a+b)/2)f\|\geq (b-a)\|f\|/2\quad(f\in\operatorname{Dom}T).
\]
The source also identifies the gap condition with existence of an extension
having no spectrum in that open interval. Choosing a singleton inside the
gap therefore shows how essential spectra of extensions can differ. This is
not a counterexample to our theorem: (21) rules out such a gap for \(T_P\).
It is a counterexample to *automatic* extension invariance at infinite
deficiency. The source's existential quantifier and conclusion "contains \(K\)"
must not be changed into a universal assertion or an equality.

All three Teschl criteria use the Hilbert norm of the operator being tested.
Here that is \(H\), or its unitary counterpart \(\mathcal K_P\), not the
original \(L^2\) norm of the preimages \(\psi_n\).

### 9.2 Localization at infinity requires hypotheses on each realization

V. Georgescu and A. Iftimovici, *Localizations at infinity and essential
spectrum of quantum Hamiltonians: I. General theory*,
[arXiv:math-ph/0506051v2](https://arxiv.org/pdf/math-ph/0506051v2),
DOI [10.1142/S0129055X06002693](https://doi.org/10.1142/S0129055X06002693),
Theorem 1.2, p. 3, expresses essential spectrum as the closure of the union
of spectra of localizations at infinity. Its setting is \(L^2(X)\) for a
locally compact noncompact abelian group with Haar measure, and its
self-adjoint observable must be affiliated to the specified algebra.
Equation (1.3), p. 2, requires, for a resolvent \(R_z\),
\[
 \|[V_k,R_z]\|\longrightarrow0\quad(k\longrightarrow0),\qquad
 \|(U_a-I)R_z\|\longrightarrow0\quad(a\longrightarrow0),
 \tag{28}
\]
where \(U_a\) is group translation and \(V_k\) is character multiplication.
These are operator-norm requirements, not strong continuity of translations.

After \(M\), the chosen free realization is \(2p\) on \(L^2(\mathbb R,dt)\),
and Corollary 4.2, p. 23, covers it through the continuous divergent symbol
\(2\xi\). This theory is not restricted to semibounded operators. But an
arbitrary extension of \(T_P\) is not identified with \(D\) on its entire
domain. Its resolvent is not specified by its values on the common
restriction. One would still have to establish (28) for each extension and
identify localizations whose spectra cover \(\mathbb R\).

The domain-based sufficient criterion, Proposition 4.4, p. 24, explicitly
requires character multiplication to preserve \(\operatorname{Dom}A\), a
divergent momentum-regularity bound on that domain, and a small-commutator
condition in the associated graph-domain spaces. These are not consequences
of \(P(S)\mathcal D_0\subseteq\operatorname{Dom}A\).
The paper's discrete finite-translation examples, p. 4, concern specified
operators and coefficients, not arbitrary self-adjoint extensions of
polynomial *range restrictions*. Moreover, additive shift in \(x\) becomes
a variable displacement in \(\log x\), not translation on this group.

Thus the localization theorem supplies a possible general framework, but no
verified off-the-shelf application to every \(A\) in (4). Establishing the
needed resolvent hypotheses could be stronger and more extension-dependent
work than the common-domain construction in Sections 3-4.

### 9.3 A precise cutoff-domain obstruction to a standard localization argument

Y. Last and B. Simon, *The essential spectrum of Schrodinger, Jacobi, and CMV
operators*, [arXiv:math/0503391v2](https://arxiv.org/pdf/math/0503391v2),
DOI [10.1007/BF02790275](https://doi.org/10.1007/BF02790275),
pp. 6-7, Proposition 2.1 and Theorem 2.3, localize residuals using a
self-adjoint partition of unity \(j_\alpha\) that preserves the operator
domain. In the unbounded case the commutator-square form must satisfy
\[
 \langle f,Cf\rangle\leq
 \delta(\|Af\|^2+\|f\|^2),\qquad
 C=2\sum_\alpha[A,j_\alpha]^*[A,j_\alpha].
 \tag{29}
\]
Their Theorem 3.7, p. 12, identifies essential spectra of
\(-\Delta+V\) for uniformly continuous bounded \(V\) on
\(L^2(\mathbb R^\nu)\) through translated-potential limits. Theorem 3.5,
p. 11, treats specified bounded-coefficient Jacobi realizations on
\(\ell^2(\mathbb Z^\nu)\). Neither supplies (29) and domain preservation
for arbitrary extensions of \(T_P\).

Here there is an elementary, exact reason not to assume that spatial cutoffs
preserve the common domain. For a compactly supported smooth \(f\), put
\[
 (\Pi f)(t)=\sum_{j=0}^{\infty}f(t+j),\qquad 0<t<1.
\]
The sum is finite. Zero-fill gives \(\Pi(S^k f)=\Pi f\), so
\[
 \Pi(P(S)f)=P(1)\Pi f=0.
 \tag{30}
\]
Choose nonzero \(\psi\in C_c^\infty(N+1/4,N+1/2)\) for any nonnegative
integer \(N\), and a smooth cutoff \(h\) supported in \((N,N+1)\), equal
to one on \(\operatorname{supp}\psi\). Since \(p_0\ne0\), disjointness of
the translated supports gives
\[
 hP(S)\psi=p_0\psi,\qquad
 \Pi(p_0\psi)(t)=p_0\psi(N+t)\not\equiv0.
 \tag{31}
\]
Consequently \(hP(S)\psi\notin P(S)\mathcal D_0\). This holds arbitrarily
far from the endpoint and for every polynomial in the theorem.
It is a diagnostic about the **common domain**, not a claim that no extension
has a cutoff-invariant larger domain; the free extension \(D\) does.

The construction (16) avoids this obstruction by placing a cutoff on a
primitive and **then** applying \(P(S)\). It obtains exact range membership
without assuming a multiplier calculus on the common domain or on every
extension. The \(x^m\) factor compensates for the \(m\)-fold difference:
the fixed shifts are approximated by derivatives in (12)-(14), while the
dilation wave and its slowly varying logarithmic envelope survive in (17).
Normalization is controlled by \(Q(1)c_0\ne0\), not by an unavailable lower
bound for \(P(S)\). This is the operator-specific step the general
localization results do not provide.

### 9.4 Nonlocal decomposition principles are not arbitrary-domain theorems

D. Lenz and P. Stollmann, *On the decomposition principle and a Persson
type theorem for general regular Dirichlet forms*,
[arXiv:1705.10398v2](https://arxiv.org/pdf/1705.10398v2),
DOI [10.4171/JST/272](https://doi.org/10.4171/JST/272),
Theorem 2.3, p. 6, assumes a regular Dirichlet form on \(L^2(X,m)\) whose
associated self-adjoint operator \(\mathcal L\) is spatially locally compact.
For a closed finite-capacity set \(B\), the prescribed exterior Dirichlet
realization \(\mathcal L_{X\setminus B}\) has the same essential spectrum.
The source includes genuinely nonlocal examples, but retains closed,
nonnegative Markovian form structure, the local compactness condition of
Definition 2.1, and that particular exterior restriction.

These are not hypotheses of the present problem: the dilation generator is
not semibounded; the range restriction is not identified with removal of a
finite-capacity set; and the theorem does not quantify over all self-adjoint
extensions of a given symmetric restriction. The Hilbert topology alone
does not supply the missing form structure. Passing to \(A^2\) would not
automatically create a regular Dirichlet form or identify an exterior domain.

## 10. Contribution and scope of the obstruction

The contribution is a **concrete range-compatible singular-sequence
construction for a dilation generator**, valid for every stated finite
multiplicity and every admissible complex polynomial. Its constants depend
on \(P\) and \(\lambda\); no uniform estimate over all polynomials is claimed.
It yields an extension-independent obstruction in a specified Hilbert
completion, without classifying the extensions or their boundary data.
It is not a new Weyl criterion, a general invariance theorem for infinite
deficiency, or a new free-dilation spectral decomposition.

Its relevance is already present at \(P=1-z\). In the stipulated zero-fill
metric realization, changing self-adjoint extension cannot repair the absence
of an exclusively discrete spectrum, even if one abandons the specified
Hurwitz-zeta eigenfunctions. That closes a different possibility from the
known state-exclusion and free-extension results. The polynomial family makes
the mechanism stable under every allowed finite filter, but polynomial
generality by itself is not evidence of field-level significance.

There are important limits to the technical claim. Repeated fundamental
theorem of calculus, the primitive \(x^{m+\alpha}\), and slowly varying
logarithmic cutoffs are elementary ingredients. Last-Simon already exhibits
inverse-length localization residuals; (3) is not a claimed optimal rate or
quantitative spectral-density improvement, and its coarse constants are not
an extremal result. What must be assessed is the domain-compatible combination
and the resulting obstruction, not the length of its estimates. The theorem
does not exclude embedded eigenvalues, all formal BBM interpretations,
different Hilbert metrics, or Hilbert-Polya constructions in general. It
establishes no implication toward or against RH.

The comparison above verifies that the **stated hypotheses** of the selected
general results do not automatically supply this theorem. It does
not prove that no alternative routine deduction or earlier equivalent
range-domain result exists. The comparison is limited to the primary texts
and propositions identified in Sections 8-9. A historical lead, Hartman's *On the Essential
Spectra of Symmetric Operators in Hilbert Space*
([JSTOR record 2372451](https://www.jstor.org/stable/2372451)), could not be
opened through the publisher's access challenge; no proposition or
non-subsumption verdict is attributed to it. The Last-Simon publisher endpoint
returned HTTP 406, but the specified arXiv full text was read. The narrow
dilation/range-domain searches found no verified matching theorem; that
bounded no-hit is not an originality certificate.

The relevant positive comparison is constructive: the same vectors lie in
the restriction shared by all extensions, so neither the choice of extension
nor a replacement eigenfunction ansatz can remove any real parameter from
the essential spectrum.
The original-space inverse is not used to obtain this conclusion. This is
the mathematical improvement over knowledge of the free realization and
exclusion of the BBM states, rather than an inference from a literature
search returning no match.

The result addresses an operator-theoretic obstruction for a candidate
Hilbert-Polya realization: in this particular zero-fill metric completion,
no self-adjoint extension of the specified common restriction has its whole
spectrum equal to a locally finite discrete list of zeta-zero ordinates.
It is a family-level analytic theorem with exact algebraic support, not a
finite-search exclusion or an objection to the literal wording of the
Hilbert-Polya question. It asserts no new Weil-positivity, Jensen-polynomial,
de Bruijn-Newman, zero-density, or pair-correlation bound. Its scope is that
of a focused operator-theory or mathematical-physics note, not a solution of
the Millennium problem or a general obstruction to spectral realizations.
