# A theorem-backed counterexample to AIMPL Problem 6.7

## 1. Statement, convention, and witness

AIMPL Problem 6.7 asks whether the product of a line and the cigar soliton
is the only collapsed three-dimensional steady soliton. Its page does not
define "collapsed" and does not restrict the question to gradient solitons.
We use the standard spatial, all-scales convention in Lai's Definition 3.4:

\[
 \forall\kappa>0\ \exists x\in M,\ r>0:
 \quad \sup_{B_g(x,r)}|\operatorname{Rm}|_g\le r^{-2},
 \qquad \operatorname{Vol}_g B_g(x,r)<\kappa r^3.                 \tag{C}
\]

This is an explicitly stated interpretation of AIMPL, not a definition
quoted from that problem page. The curvature hypothesis is on the entire
ball. Zero asymptotic volume ratio without that hypothesis is not sufficient.

**Witness:** choose any \((M,g,f,p)\) supplied by Yi Lai,
arXiv:2010.07272v2, Theorem 1.1, with \(n=3\) and \(\alpha=1/2\).
The theorem's parameter is a Ricci-eigenvalue ratio at a critical point
of \(f\); it is not a specified angle. No uniqueness of the chosen witness
inside this family is asserted.

We prove that this witness satisfies (C) and is not isometric to
\(\mathbb R\times\Sigma\), where \(\Sigma\) is the cigar. Its gradient
structure and positive curvature are additional properties of this witness,
not extra hypotheses imposed on AIMPL.

This is a **known-theorem-backed existential construction**, not a numerical
metric, a new analytic existence theorem, or a kernel-verified proof.
Independent Reviewer acceptance is still required.

## 2. Exact source premises

All locations below refer to the versioned PDF's printed page numbers.
The PDFs and text extractions are in `sources/`; they can be opened offline.
The article's HTML is also archived, but the initial web text extractor
returned a proof section rather than the introduction.

| Label | Primary location | Content used |
|---|---|---|
| Q | [AIMPL, Problem 6.7](http://aimpl.org/flowriemannian/6/) | The uniqueness question; no definition of collapsed on this page. |
| L0 | [Lai v2](https://arxiv.org/pdf/2010.07272v2), p. 1, opening paragraph and (1.1) | A steady gradient soliton is smooth and complete, with \(\operatorname{Ric}=\nabla^2 f\). |
| L11 | Lai v2, p. 2, paragraph before Theorem 1.1 and Theorem 1.1 | For \(n\ge3\), \(0<\alpha<1\), existence with positive curvature operator; \(p\) is critical and \(\lambda_1=\alpha\lambda_2=\alpha\lambda_3\) in dimension three. |
| L21 | Lai v2, p. 5, Definition 2.1 | The specified symmetry includes an equivariant diffeomorphism with \(\mathbb R^n\); thus this witness is connected and noncompact. |
| L13 | Lai v2, p. 3, Corollary 1.3, last sentence | In particular, all the three-dimensional examples of Theorem 1.1 are flying wings. |
| L15 | Lai v2, p. 3, Corollary 1.5 | Along the distinguished axis going to infinity, a flying wing converges smoothly, without rescaling, to a line times a cigar, whose tip scalar curvature is \(R(p)\sin^2(\theta/2)>0\), for its sector angle \(0<\theta<\pi\). |
| L34 | Lai v2, p. 13, Definition 3.4 | The curvature-controlled spatial noncollapse definition whose negation is (C). |

The analytic imports in the chosen proof are L11, L13 and L15.
We trust these published mathematical results rather than reprove their PDE
arguments or separately audit all their internal dependencies.
L0, L21 and L34 specify the source's definitions.
Lai's paragraph immediately after Theorem 1.1 already states collapse and
mentions two ways to justify it. That paragraph is recorded as prior
grounding, but **is not used as a substitute for the argument below**.
The external assumptions and their citation locators are in
`../MATH_STATE.json`; citation attribution belongs to an independent reader.

## 3. Existence, completeness, and steady equation

The exact choices \(3\ge3\) and \(0<1/2<1\) meet L11. Together with L0
and L21, it supplies a smooth complete connected noncompact three-manifold,
a smooth potential, and
\[
 \operatorname{Ric}_g=\nabla_g^2 f,\qquad
 \operatorname{Rm}_g>0,\qquad df(p)=0.
\]
In the other usual sign convention, put \(F=-f\); then
\(\operatorname{Ric}_g+\nabla_g^2F=0\). This is a steady Ricci soliton.

Positive curvature operator implies positive Ricci curvature. If desired,
scale the metric so that \(R(p)=1\); its Ricci endomorphism at \(p\) then
has spectrum
\[
       (1/5,\ 2/5,\ 2/5).                                     \tag{1}
\]
Indeed, if \(\lambda_2=\lambda_3=b\), then
\((1/2+2)b=1\). This optional normalization is only used for the
exact spectrum replay, not for the geometric normalization in section 4.
Neither normalization changes completeness, the steady equation, or (C).

## 4. Collapse: an explicit curvature-controlled construction

### 4.1 Normalize the imported pointed limit

L13 makes our particular L11 witness a flying wing, so L15 applies.
Choose a sequence \(q_i\) on its axis going to infinity. Its pointed smooth
limit is a product of a line and a positively scaled cigar.
Use the standard cigar metric
\[
 g_{\rm cig}=\frac{dx^2+dy^2}{1+x^2+y^2}
             =ds^2+\tanh^2s\,d\vartheta^2,\qquad
 x^2+y^2=\sinh^2s,\quad \vartheta\in\mathbb R/(2\pi\mathbb Z).
\]
Its tip scalar curvature is \(4\). If the limit cigar is \(a g_{\rm cig}\),
then \(a=4/[R(p)\sin^2(\theta/2)]>0\). Rescaling the original metric by
\(a^{-1}\) and changing the line coordinate makes the limit
\[
             h=dt^2+ds^2+\tanh^2s\,d\vartheta^2.               \tag{2}
\]
Write \(\widetilde g=a^{-1}g\) for this proof only.
No value of \(\theta\), \(a\), or a convergence rate is inferred from
\(\alpha=1/2\).
We also do not identify the pointed limit's basepoint with the cigar tip:
pointed smooth convergence exhausts the complete limit, so every fixed
compact cylinder used below is eventually inside its charts.

For completeness, scaling back is exact: a radius \(r\) ball for
\(\widetilde g\) is a radius \(\sqrt a\,r\) ball for \(g\);
curvature norms scale by \(a^{-1}\), and volumes by \(a^{3/2}\).
Thus every ball satisfying (C) for \(\widetilde g\) gives one for \(g\)
with the same \(\kappa\).

### 4.2 Exact cigar curvature

Set \(u=\tanh s\). For the surface warping function \(u\),
\(u'=1-u^2\), \(u''=-2u(1-u^2)\). The nonzero surface Christoffel
symbols are
\(\Gamma^s_{\vartheta\vartheta}=-uu'\) and
\(\Gamma^\vartheta_{s\vartheta}=\Gamma^\vartheta_{\vartheta s}=u'/u\).
Consequently its Gaussian curvature is
\[
              K=-u''/u=2(1-u^2)=2\operatorname{sech}^2s.
\]
The line product has only this nonzero sectional curvature. In an
orthonormal frame its curvature tensor has four nonzero entries of
magnitude \(K\), so, using the full tensor norm,
\[
       |\operatorname{Rm}_h|=2K=4\operatorname{sech}^2s
                      \le16e^{-2s}.                          \tag{3}
\]
The formula is valid at the tip by smooth extension; below we only use
\(s>0\). Also, \(2\log\cosh s\) has Hessian \(K g_{\rm cig}\),
as follows from its radial and angular Hessian entries. Thus (2) uses
the usual explicit steady cigar, not a different surface of revolution.

### 4.3 Low-volume cylinders with a strict curvature margin

Fix any real \(\kappa>0\). Choose an integer
\[
                   j>32/\kappa,\qquad r=8j.
\]
In the limit (2), put \(y_j=(0,4r,0)\), and use the open cylinder
\[
 D_j=\{\,|t|<2r,\quad 2r<s<6r,\quad
                    \vartheta\in\mathbb R/(2\pi\mathbb Z)\,\}.
\]
Its closure is compact and does not meet the tip.
From (3), the positive exponential series, and \(r=8j\ge8\),
\[
 \sup_{D_j}|\operatorname{Rm}_h|
 \le16e^{-4r}
 \le\frac{16\cdot4!}{(4r)^4}
 =\frac{3}{2r^4}
 =\frac{3}{128j^2}\,r^{-2}
 \le\frac{3}{128}\,r^{-2}
 <\frac12 r^{-2}.                                            \tag{4}
\]
Since the volume density in (2) is \(\tanh s\le1\),
\[
          \operatorname{Vol}_h D_j
          \le(4r)(4r)(2\pi)=32\pi r^2.                        \tag{5}
\]
Every curve from \(y_j\) to the boundary of this cylinder changes either
\(t\) or \(s\) by \(2r\). Its \(h\)-length is at least \(2r\),
because \(h\ge dt^2+ds^2\).

### 4.4 Transfer to actual balls in the witness

For this fixed \(j\), pointed smooth convergence supplies embeddings
\(\psi_i\) of a neighborhood of \(\overline{D_j}\) into
\((M,\widetilde g)\), for all sufficiently large \(i\).
Choose one sufficiently large that on \(\overline{D_j}\)
\[
 \tfrac34 h\le\psi_i^*\widetilde g\le\tfrac54 h,\qquad
 |\operatorname{Rm}_{\psi_i^*\widetilde g}|
                                      \le\tfrac12r^{-2}.      \tag{6}
\]
The second choice is justified by the **strict** margin in (4) and
smooth curvature convergence; it is not merely a statement about
convergence of volumes.

Set \(x_j=\psi_i(y_j)\).
The genuine ball \(B_{\widetilde g}(x_j,r)\) is contained in
\(\psi_i(D_j)\). Otherwise a path of length less than \(r\) from \(x_j\)
would first reach the boundary of this embedded cylinder.
Pulling back that initial segment and using the lower bound in (6)
gives length at least
\(\sqrt{3/4}\,(2r)=\sqrt3\,r>r\), a contradiction.
This first-exit argument rules out unnoticed short paths through the
complement of a pointed-convergence chart.

It follows from (6) that the **entire actual ball** has curvature norm
at most \(r^{-2}\). The upper metric bound gives volume density at
most \((5/4)^{3/2}<2\), so (5) gives
\[
 \frac{\operatorname{Vol}_{\widetilde g}
                B_{\widetilde g}(x_j,r)}{r^3}
 \le \frac{64\pi}{r}
 <\frac{256}{r}=\frac{32}{j}<\kappa.                          \tag{7}
\]
Here the elementary strict bound \(\pi<4\) follows, for example, by
comparing the unit disk with its circumscribed square.

Equations (6)--(7), followed by scaling back in 4.1, prove (C).
The choice of the convergence index \(i=i(j)\) is existential, supplied
by L15. No effective rate or numerical coordinate description of the
wing is claimed. This is an exact theorem-backed existence argument
for the required balls for **every real** \(\kappa>0\).

## 5. Exclusion of the cigar product

For the Riemannian product \(\mathbb R\times\Sigma\), the unit vector in
the line factor is parallel. All mixed sectional curvatures are zero,
and that vector is in the Ricci kernel at every point.
L11 gives positive curvature operator, hence positive sectional and
Ricci curvatures, at every point of our witness. An isometry preserves
these tensors. It therefore cannot identify the witness with the
product, or with a positive constant rescaling of it.

This argument needs no identification of marked points, potential
functions, tips, or symmetry axes under an isometry.

## 6. Replay and the trust boundary

From the campaign directory, execute:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python research/certificate/replay.py
```

The entry point uses only Python's standard library and also runs on a
normal Python 3 installation. It recomputes (1), the polynomial
warping/Hessian/curvature-norm identities, the exact constants in
(4)--(7), and an illustrative rational-\(\kappa\) integer choice.
It independently recomputes the diagonal spectrum and checks the saved
typed Jacobian result against that computation.
It does **not** infer mathematics from source-file names, keywords,
hashes, or a graph's status.

The saved Jacobian call can separately be repeated with:

```bash
/home/argustest/zimo/references/jacobian/.venv/bin/jacobian run \
  matrix.symmetric.rational_spectrum_claim.check \
  --file research/certificate/jacobian/spectrum-payload.json
```

Its inspected contract, exact input, exact typed output, installed version,
interface, timeout and exit status are in `jacobian/`. It certifies only
a finite rational spectrum, not a soliton or collapse.

**Not mechanically proved by the replay:** the analytic source theorems;
their faithful application; the coordinate curvature formula from the
Levi-Civita connection; smooth-limit chart existence and uniform control;
the first-exit and volume arguments; real-quantifier reasoning and
scaling; source alignment with AIMPL. These are given explicitly above
for independent mathematical reading. A replay exit code is not
independent acceptance and is not a Lean/kernel certificate.

The distinct classification probe is in `classification-probe.md`.
Its Brendle and Perelman results are not additional imported premises of
the chosen geometric proof. Compared with the prior structural-only result,
this certificate supplies the missing ballwise curvature and volume
argument and the product obstruction. The remaining delivery gate is
the normal independent Reviewer, including citation attribution.
