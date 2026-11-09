# All-level Lorentz contact-to-perimeter theorem

## Result and boundary of the certification

The original assertion `lem:family-all-levels` in
`research/openai_manuscript/The-Solomon-Yau-least-volume-theorem-September-23-2026/build/sections/family.tex`,
including its sign convention and all its quantifiers, has the proof below.
No regular-value restriction, unique closest point, or positive-definite
contact matrix is needed. The load-bearing algebra is formalized for arbitrary
dimension in `Main.lean`. The geometric and measure-theoretic bridges are
proved in prose, with the three GMT inputs stated explicitly. This is **not**
a Lean proof of finite perimeter, nor verification of the full least-volume
theorem. Independent Reviewer replay, statement-fidelity approval, and
significance/novelty assessment remain open.

The previous project state had no supporting evidence for its campaign
claim. The improvement here is a universal formal algebraic certificate and
a complete local geometric argument, rather than a finite search or an
assertion that a cited index theorem is new. Nifa's already reported
curvature/index conclusions are not used in this proof.

The scope lookup was subsequently completed at the level of source
statements: Nifa v1, Theorem 1.1, explicitly states the quadratic-form
inequality for every \(f\in H^1(M)\), the average-curvature consequence,
and its Clifford equality case for closed connected non-equatorial
minimal **embeddings**, \(m\geq2\). Corollary 7.3 explicitly states
index \(m+3\) if and only if Clifford in the embedded class. Its proof
cites Perdomo's Theorem 3.1 for the reverse average inequality at that
index. The exact v1 PDF and those passages are retained in
`literature/`; none of those proofs has been audited here. There was
no Lorentz/contact-specific entry in the inherited Wiki index.

## Precise statement

Let \(m\geq2\) and let \(\Sigma^m\subset S^{m+1}\) be smooth, closed,
connected, embedded, minimal, and not totally geodesic. Choose a smooth
global unit normal \(N\) and set \(A=-dN\). Let \(\varphi\) be Euclidean
distance to the cone \(\mathcal C=C(\Sigma)\), with sign positive on the
side pointed to by \(N\). For a finite boost write
\[
 v=\tanh(\tau)a,\quad |a|=1,\quad C=\cosh\tau,\quad S=\sinh\tau,
 \quad B=I+(C-1)aa^t.
\]
At \(v=0\) choose any \(a\); every formula is independent of it.
The inverse image of \(h=\varphi(z)\) under
\[
 z=By+bSa,\qquad h=Cb+S\langle a,y\rangle
\]
is the graph \(b=\psi_v(y)\). Its extension at \(|a|=1\) is
\(\psi_a(y)=-\langle a,y\rangle\). Put
\[
 E_{v,b}=\{y\in S^{m+1}:\psi_v(y)<b\},\qquad
 \Lambda_{v,b}=\{y:\psi_v(y)=b\}.
\]
**For every** \((v,b)\in\overline B^{m+2}\times[-1,1]\), \(E_{v,b}\)
has finite perimeter. For **every** finite \(v\), **every**
\(-1<b<1\), and **every** open \(U\subset S^{m+1}\), define
\[
\begin{gathered}
 r=\sqrt{1-b^2},\quad f=\langle a,x\rangle,\quad
 g=\langle a,N(x)\rangle,\quad D=C-Sg,\\
 N'=(BN-Sa)/D,\quad h(x)=(b+Srf)/D,\\
 O_xw=Bw+S\langle a,w\rangle N'(x),\quad
 Y(x)=rO_xx+bN'(x),\\
 T=\{x\in\Sigma:rI-h(x)A(x)\text{ is positive semidefinite}\}.
\end{gathered}
\]
Then
\[
 \operatorname{Per}(E_{v,b};U)
 \leq\mathcal H^m(\Lambda_{v,b}\cap U)
 \leq\int_{T\cap Y^{-1}(U)}\det(rI-hA)\,d\mu,
 \qquad 0\leq\det(rI-hA)\leq r^m\leq1\text{ on }T.
\]

## Explicit external GMT inputs

These are assumptions of the geometric theorem, not consequences of the
Lean compiler or of the symbolic verifier.

1. **Area formula with multiplicity.** For a Lipschitz map from an
   \(m\)-rectifiable source and a measurable subset \(W\), the integral of
   the metric \(m\)-Jacobian over \(W\) equals the integral of the number of
   preimages in \(W\), with respect to \(\mathcal H^m\).
   Federer, *Colloquium lectures on geometric measure theory*, Bull. AMS
   84 (1978), 291--338, DOI
   `10.1090/S0002-9904-1978-14462-0`, section 3, pp.299--300.
2. **Finite-essential-boundary criterion.** A measurable subset of
   Euclidean space whose essential boundary has locally finite
   codimension-one Hausdorff measure has locally finite perimeter.
   Federer, same printed article, section 4, p.302, conditions (1)--(4).
   Smooth coordinate charts transfer finiteness to the sphere; no claim
   about an exact chartwise constant is used.
3. **Intrinsic perimeter representation.** On the sphere,
   \(\operatorname{Per}(E;U)=\mathcal H^m(\partial^*E\cap U)\).
   Boegelein--Duzaar--Fusco, *A quantitative isoperimetric inequality on
   the sphere*, section 2.2 of the 2013-05-09 author manuscript, pp.4--5,
   `https://cvgmt.sns.it/media/doc/paper/2146/BDF-sphere-2013-05-09.pdf`.
   The published version is Adv. Calc. Var. 10 (2017), 223--265,
   DOI `10.1515/acv-2015-0042`; the version actually read is the author PDF.

The exact source PDFs and extracted passages are in `literature/`.
The relevant Federer text includes the measurable-source hypothesis and
the multiplicity term, not just the injective special case. The BDF text
states equality of the total-variation measure with Hausdorff measure
restricted to the reduced boundary. These source readings are Engineer
readings, **not independent citation approval**. The first attempted
Numdam URL did not resolve; the manuscript's Stony Brook copy supplied
the actual printed Federer article.

## Proof

### 1. Cone contacts, including their sign

For \(z\ne0\), set \(H(z)=\max_{x\in\Sigma}\langle z,x\rangle\).
The coordinate equation \(\Delta_\Sigma x=-mx\), integrated over the
closed hypersurface, gives \(\int_\Sigma x\,d\mu=0\).
The image is full: if it lay in a great \(S^m\), its immersion into
that \(S^m\) would be a local diffeomorphism and hence, by compactness,
have image both open and closed. Its image would be that great sphere,
contrary to the non-totally-geodesic hypothesis. Consequently \(H(z)>0\):
a nonpositive continuous height function with zero integral vanishes
identically, contradicting fullness.

Compactness gives \(c=\min_{|z|=1}H(z)>0\). Minimizing the distance along
a ray \(tx\), \(t\geq0\), and then over \(x\), gives
\[
 \operatorname{dist}(z,\mathcal C)^2=|z|^2-H(z)^2,\qquad
 |\varphi(z)|\leq K|z|,\quad K=\sqrt{1-c^2}<1.
\]
Thus the cone vertex is not a closest point to \(z\ne0\), and every
closest point is \(rx\) where \(r=H(z)>0\) and \(x\) maximizes height.
At each such maximum the tangential component of \(z\) vanishes:
\(z=rx+\epsilon N(x)\), with \(|\epsilon|=|\varphi(z)|\).
The segment from \(rx\) to \(z\), with its endpoint \(rx\) removed,
misses the cone: otherwise an intermediate cone point would be closer.
It lies in one side, which near \(rx\) is the side indicated by the
sign of \(\epsilon\). Therefore \(\epsilon=\varphi(z)=h\), with the
manuscript's sign, also when the closest point is not unique.

For \(w\in T_x\Sigma\), a unit-speed source geodesic has ambient
acceleration \(-|w|^2x+\langle Aw,w\rangle N\) at contact. Hence
\[
 \nabla^2_\Sigma\langle z,x\rangle(w,w)
   =-r|w|^2+h\langle Aw,w\rangle\leq0.
\]
This proves \(rI-hA\geq0\), not the oppositely signed inequality.
The argument applies separately to every height maximum and allows
zero Hessian eigenvalues. Orthogonality also gives
\(r=\sqrt{|z|^2-h^2}\).

### 2. The graph exists at every level

The signed distance is 1-Lipschitz. On the same side this is the usual
distance estimate; on opposite sides the joining segment meets the cone,
and the two distances are bounded by the two segment lengths.
For fixed \(v,y\), set
\[
 F(b)=Cb+S\langle a,y\rangle-\varphi(By+bSa).
\]
For \(b_2>b_1\), \(F(b_2)-F(b_1)\geq(C-S)(b_2-b_1)>0\).
This bound also gives the two infinite limits, so the intermediate-value
theorem gives a unique zero, continuously dependent on \(v,y\).
At a graph point with \(|y|=1\), Lorentz invariance gives
\[
 1-b^2=|z|^2-h^2\geq(1-K^2)|z|^2>0.
\]
Here \(z=0\) would imply \(h=0\) and, by the inverse boost,
\(y=0\), which is impossible. Thus \(|\psi_v|<1\).
Moreover
\[
 |\psi_v(y)+\langle v,y\rangle|
   =|h|/C\leq K/(C\sqrt{1-K^2}),
\]
uniformly for \(|y|=1\). This proves the claimed joint extension
\(\psi_a(y)=-\langle a,y\rangle\) as \(|v|\to1\).

### 3. Source-dependent Lorentz algebra and the actual differential

The identities \(C^2-S^2=1\), \(C>S\geq0\), and \(|g|\leq1\)
give \(D\geq C-S>0\). Direct bilinear expansion gives
\[
 B^2=I+S^2aa^t,\quad |BN-Sa|^2=D^2,\quad
 \langle Bw,N'\rangle=-S\langle a,w\rangle\quad(w\perp N).
\]
Consequently \(|N'|=1\), \(O_xw\perp N'\), and
\(\langle O_xw,O_xu\rangle=\langle w,u\rangle\) for \(w,u\perp N\).
Since \(x\perp N\), \(Y=rO_xx+bN'\) has unit length.
These are dimension-independent identities, not an identification
of all the maps \(O_x\) with one ambient rotation.

Hold \(v,b\), hence \(a,C,S,r\), fixed. At an arbitrary source
direction write \(dx=w\), \(dN=k=-Aw\).
Then \(df=\langle a,w\rangle\), \(dg=\langle a,k\rangle\), and the
ordinary quotient rule gives
\[
 dN'=\frac{Bk}{D}+
       \frac{S\langle a,k\rangle}{D^2}(BN-Sa)=D^{-1}O_xk.
\]
The full product rule, retaining the variation of \(N'\), now gives
\[
\begin{aligned}
 dY
 &=r(Bw+S\langle a,w\rangle N'+Sf\,dN')+b\,dN'\\
 &=rO_xw+(b+rSf)D^{-1}O_xk\\
 &=O_x(rw-hAw).
\end{aligned}
\]
Here \(O_x\) is linear at this one source point. Since \(w,Aw\) are
in \(N^\perp\), its isometry property proves the metric identity
\[
 J_mY=|\det(rI-hA)|.
\]
Equivalently, in orthonormal source and ambient frames,
\(dY=QH\), \(Q^tQ=I\), \(H=rI-hA\), so
\(\det((QH)^tQH)=\det(H)^2\) and the metric Jacobian is
\(\sqrt{\det((QH)^tQH)}=|\det H|\). This also holds at rank loss.

`Main.lean` proves these bilinear, first-order-jet, spectral, and
rectangular-Gram identities. The identification of the explicit jets
with manifold differentials uses the smooth maps and ordinary
chain/quotient rules just displayed; this analytic identification is
not itself formalized.

### 4. Every level is covered by the semidefinite source

Fix any finite \(v\), any \(-1<b<1\), and any \(y\in\Lambda_{v,b}\).
Transform \((y,b)\) to its graph point \((z,h)\). A cone contact from
step 1 has \(z=r_zx+hN(x)\), and invariance gives
\(r_z^2=|z|^2-h^2=1-b^2=r^2\), so \(r_z=r>0\).
The inverse height equation is \(b=Dh-Srf\).
Solving it gives exactly the displayed \(h(x)\), and substituting in
the inverse spatial equation gives exactly \(y=Y(x)\).
Step 1 gives \(x\in T\). Thus
\[
 \Lambda_{v,b}\subset Y(T).
\]
This uses existence, not uniqueness or smooth dependence, of a closest
point. Conversely, \(T\) need not consist only of genuine contacts;
the excess only increases the integral upper bound.

On \(T\), the \(m\) eigenvalues of \(H=rI-hA\) are nonnegative and
have sum \(mr-h\operatorname{tr}A=mr\). AM-GM gives
\[
 0\leq\det H\leq r^m.
\]
There is no division by an eigenvalue or by \(h\). Mathlib's spectral
theorem and AM-GM prove this for arbitrary finite real semidefinite
matrices in `psd_determinant_bounds` and
`contact_matrix_metric_jacobian_bounds`, including singular matrices.

### 5. Localization and finite perimeter, with no exceptional values

The map \(Y\) is smooth on the compact source because \(D>0\); \(T\)
is closed. For open \(U\), \(W=T\cap Y^{-1}(U)\) is Borel.
The area formula, applied in source charts and with multiplicity,
gives
\[
\begin{aligned}
 \mathcal H^m(\Lambda_{v,b}\cap U)
 &\leq \mathcal H^m(Y(W))\\
 &\leq\int_W J_mY\,d\mu
   =\int_W\det(rI-hA)\,d\mu.
\end{aligned}
\]
The right side is at most \(r^m|\Sigma|<\infty\). No selection of
closest points is integrated, and neither an inverse function theorem
nor Sard's theorem is used.

The set \(E\) is open and \(\partial E\subset\Lambda\), since \(\psi_v\)
is continuous. Its essential boundary is therefore contained in
\(\Lambda\). The finite-essential-boundary criterion in charts gives
finite perimeter. The intrinsic representation, not a distorted
chartwise inequality, gives the constant one:
\[
 \operatorname{Per}(E;U)=\mathcal H^m(\partial^*E\cap U)
 \leq\mathcal H^m(\Lambda\cap U).
\]
This argument was made for an arbitrary fixed \(b\); there is no
almost-every-level step.

For finite \(v\), \(E_{v,-1}=\varnothing\) and
\(E_{v,1}=S^{m+1}\). For \(|v|=1\), the sets are the round caps
\(\{\langle v,y\rangle>-b\}\); their perimeter is
\(\sigma_m(1-b^2)^{m/2}\). At the two endpoints it is zero:
the upper cap can omit a single point, which does not change perimeter.
Thus every parameter in the closed parameter space is covered.

## A structural extension, and what it does not claim

The same proof works without minimality if the smooth closed two-sided
embedded spherical hypersurface satisfies \(H(z)=\max_\Sigma\langle
z,x\rangle>0\) for every \(z\ne0\) (equivalently, the origin is in the
interior of its convex hull). Keep the same signed distance and all the
same definitions. Write \(\mathcal H_A=\operatorname{tr}A\), without
dividing by \(m\). The localized conclusion is
\[
 \operatorname{Per}(E;U)\leq\mathcal H^m(\Lambda\cap U)
 \leq\int_{T\cap Y^{-1}(U)}\det(rI-hA)\,d\mu
 \leq\int_{T\cap Y^{-1}(U)}
       (r-h\mathcal H_A/m)^m\,d\mu.
\]
On \(T\), the base \(r-h\mathcal H_A/m\) is nonnegative, being the
average eigenvalue. Compactness makes the integral finite. The formal
generic trace theorem applies with this average in place of `r`.
This is a weighted geometric extension; no claim of previously unknown
literature priority or publishable significance is inferred from it.

## Adversarial checks and reproducibility

`verify.py` proves the symbolic identities by exact rational-function
arithmetic and polynomial reduction by \(C^2-S^2-1\) and
\(r^2+b^2-1\), independently differentiates the actual source-varying
formulas, and checks a source-bound official Lean certificate. Its
geometric examples are **tests**, not substitutes for the universal
proof. The symbolic coefficient vectors represent seven formal
generators with indeterminate Gram entries; seven is the number of
vectors occurring in an identity, not a sampled ambient dimension.
The determinant inequalities in arbitrary dimension are proved by Lean,
not inferred from these examples. The examples are on the actual
embedded minimal Clifford torus in \(S^3\)
with
\[
 x=(1,1,1,1)/2,\quad N=(1,1,-1,-1)/2,\quad
 \kappa=(-1,1),\quad A=-dN.
\]
This product of circles is smooth, compact, connected and embedded;
its normal differentiates to \(+1\) on the first circle and \(-1\)
on the second, so the stated curvatures and minimality follow.
For arbitrary \(z=(z_u,z_v)\in\mathbb R^2\times\mathbb R^2\),
\[
 \varphi(z)=(|z_u|-|z_v|)/\sqrt2,\quad
 r_z=(|z_u|+|z_v|)/\sqrt2.
\]
Indeed a cone point has equal component lengths \(t\), and minimizing
\((|z_u|-t)^2+(|z_v|-t)^2\), \(t\geq0\), gives
\(t=(|z_u|+|z_v|)/2\). This proves geometric admissibility, including
nonunique closest directions when a component vanishes.

The tests include both signed degenerate unboosted contacts, a genuine
finite boosted contact with \(C=5/4,S=3/4,b=0,h=3/7\), and a
nonunique degenerate boosted contact with
\(r=2/\sqrt5,b=1/\sqrt5,h=r\). Dropping source variation or reversing
the shape sign fails explicit negative controls. An unconstrained
noncontact example with \(b=12/13,r=5/13\) violates the unrestricted
Jacobian bound; its contact matrix is indefinite and its level is
empty, so it is **not** a counterexample to the manuscript.

The Jacobian adapter's generic discovery did not expose a universal
Lorentz/differentiation proof operation. After inspecting the exact
typed factorization contract, one bounded matching move factors the
normal-norm residual
\[
 |BN-Sa|^2-D^2=(C^2-S^2-1)(g^2-1).
\]
The server version, protocol, operation, payload and typed result are
retained in `jacobian_*.json`. This factorization supports only that
algebraic move, not the geometric theorem. A failed or incomplete
adapter result would not count as a mathematical verdict.

Run the exact replay from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/lorentz_contact/verify.py
```

For a fresh real compiler replay use `verify.py --replay-lean`, through
the host's durable runner if it may exceed two minutes. This invokes the
prescribed `lean_evidence verify` with claim `C349_LORENTZ_ALGEBRA`.
The default replay checks the current source/fidelity against the
recorded compiler certificate rather than silently recompiling it.
`exact_certificate.json` records the exact obligations and examples;
failed obligations produce a nonzero exit.

The official prescribed run obtained `exit_code=0`, `audit_exit_code=0`,
and `proof_holes=[]` under Lean 4.31.0. It recorded mechanical evidence
for `C349_LORENTZ_ALGEBRA` at
`certificates/C349_LORENTZ_ALGEBRA-0904f3e198c4b026.json`.
The ledger derives `closed_kernel` for **that algebraic claim only**;
its natural-language statement fidelity still requires human review.
The exact symbolic replay passed all 13 identities, five geometric
examples (one deliberately inadmissible), and five negative controls.

## Downstream impact

The original contact-to-localized-perimeter bridge is valid under the
stated GMT inputs, including at the degenerate and nonunique contacts
that could invalidate an almost-every-level argument. It supplies
the restricted integrands used in the manuscript's subsequent
no-concentration proof. It does **not** establish uniform
no-concentration at infinite boosts, projective detection, the
strict-loss deformation, curvature/index rigidity, min-max existence,
or the cone induction. Those remain open graph nodes. In particular,
neither the global volume theorem nor campaign-level novelty has been
certified by this bounded result.
