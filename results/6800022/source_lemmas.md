# Source-independent CCCC premise and the reciprocal source equations

## Precise replacement for the displayed-data attribution

In the mathematical proof, **CCCC model** means the following explicitly
defined meromorphic data, not an asserted transcription of Wohlgemuth's
unreadable primary display:
\[
 E_a:\quad W^2=(z^2-a^2)(z^2-1),\qquad 0<a<\alpha<1,
\]
\[
 g=\frac{(z-\alpha)(z+a)(z-1)}{(z+\alpha)W},\qquad
 dh=a\,\frac{z^2-\alpha^2}{(z^2-a^2)(z^2-1)}\,dz.       \tag{E1}
\]
A period-closing datum means that the real integrals of
\(\Phi=((g^{-1}-g)dh/2,i(g^{-1}+g)dh/2,dh)\) vanish on every
closed curve of the punctured torus.

**Explicit-model lemma.** The four branch points are the only ends of
(E1). Its compactification has genus one, its Gauss map has degree four,
and every period-closing datum is a regular complete
finite-total-curvature immersion with four individually embedded vertical
catenoidal ends. Its equatorial period has exactly one admissible root
for each \(a\), with \(a<\alpha<\sqrt a\). The parameter boundary is
not an additional four-catenoidal-end datum. Every period-closing member
of this explicit model is nonembedded, by the already independently
reviewed period/meridian calculation. None of these assertions requires
an identification with the displayed data in the 1997 article.

### Direct data and regularity proof

The double cover of the sphere has exactly four distinct simple branch
points, so \(2g(E_a)-2=2(-2)+4=0\). Write \(P_t\) for the branch point
over \(z=t\), and \(Z_\pm,N_\pm\) for the two points above
\(z=\alpha,-\alpha\), respectively. Orders of the two differentials and
the Gauss map are:

| Point | \(\operatorname{ord}g\) | \(\operatorname{ord}dh\) |
|---|---:|---:|
| \(P_{-a},P_1\) | \(1\) | \(-1\) |
| \(P_a,P_{-1}\) | \(-1\) | \(-1\) |
| \(Z_+,Z_-\) | \(1\) | \(1\) |
| \(N_+,N_-\) | \(-1\) | \(1\) |
| Either point at infinity | \(0\) | \(0\) |

At a branch point use \(z-t=\tau^2\); \(W\) has a simple zero in
\(\tau\). At infinity use \(v=1/z\): \(g\) tends to \(1\) or
\(-1\), and \(dh=-a\,dv+O(v^2)\,dv\). Thus the list is exhaustive.
The zero divisor of \(g\) has degree four. Away from the punctures,
the metric
\[
 ds^2=\tfrac14(|g|+|g|^{-1})^2|dh|^2
\]
is nonzero, including at \(Z_\pm,N_\pm\); there is no branch point of
the immersion. At each puncture it is comparable to
\(|d\tau|^2/|\tau|^4\), proving completeness.

Put
\[
 u=\frac{\alpha^2-a^2}{1-a^2}>0,\qquad
 v=\frac{a(1-\alpha^2)}{1-a^2}>0.
\]
The branch-coordinate residues of \(dh\) at
\((-a,1,a,-1)\) are \((-u,v,u,-v)\). They are real and nonzero.
The horizontal forms have double poles and zero residues: the deck
involution changes \(g\) to \(-g\), while \(dh\) is invariant, so their
Laurent coefficients in \(\tau\) have only even powers. Consequently
local real periods vanish. With \(\zeta=1/\tau\), integration gives
\[
 X_\perp=M\zeta+c+O(|\zeta|^{-1}),\qquad
 X_3=-R\log|\zeta|+c_3+O(|\zeta|^{-2}),
\]
where \(R\ne0\) is the real height residue and \(M\) is an invertible
real conformal map. Indeed the leading horizontal null vector is
\((d,\pm id)\), \(d\ne0\). Its projection is a proper local
diffeomorphism outside a sufficiently large disk; the leading term
has degree one, so the covering of a sufficiently large target
exterior has one sheet. Each end is therefore an embedded catenoidal
graph, not a multiply covered end. Curvature area is the pullback of
spherical area by the extended degree-four Gauss map, hence finite.
These local assertions do not imply global embedding.

At \(\alpha=a\) the residues at \(\pm a\) vanish; at \(\alpha=1\)
those at \(\pm1\) vanish. At \(a=0\) or \(a=1\), branch points collide.
These evaluated boundary data violate the model's four-distinct,
four-catenoidal-end conditions; no rescaled degeneration is being
silently added to the theorem.

### Exact normalization and reuse of the accepted analytic proof

The substitution
\[
 x=z/a,\quad A=\alpha/a,\quad B=1/a,\quad w=W/a^2
                                                               \tag{E2}
\]
is an invertible change of variables for \(a>0\). It gives exactly
\[
 w^2=(x^2-1)(x^2-B^2),\quad
 g=\frac{(x-A)(x+1)(x-B)}{(x+A)w},\quad
 dh=\frac{x^2-A^2}{(x^2-1)(x^2-B^2)}\,dx .
                                                               \tag{E3}
\]
It preserves the actual null forms, not only the compact curve.
The normalization certificate `verify_source_premises.py` checks the
curve, Gauss numerator, height differential, and all four residues
exactly. Its bounded Jacobian operation independently evaluates the
three rational products in this substitution; it says nothing about
the historical attribution or the geometric proof.

The initial typed request was rejected with `INVALID_REQUEST`,
`matrix.budget_exceeded`: the operation cannot bound cancellation through
a multi-term denominator. Its exact payload and structured refusal remain
in `jacobian-payload-model-normalization.json` and
`jacobian-output-model-normalization.json`. The admitted replacement
checks the height identity after clearing the explicit curve polynomial;
the rational identity itself is checked independently in the replay.
The replacement's files have the suffix `-cleared.json`. The initial
refusal is a tool-domain fact, not support or refutation of any lemma.

For clarity, reduction to one real period is internal to (E1).
The holomorphic involution \(T(z,W)=(-z,W)\) satisfies
\(g\circ T=1/g\) and \(T^*dh=-dh\); consequently
\(T^*\phi_1=\phi_1\) and \(T^*\phi_2=-\phi_2\).
It is the elliptic negation involution and acts as \(-1\) on
\(H_1(E_a)\). Since the horizontal residues vanish, all complex
\(\phi_1\) periods are zero. The rational differential \(dh\)
descends to the sphere with only real residues, so all its periods
are purely imaginary.

Complex conjugation \(K\) satisfies \(K^*\phi_2=-\overline{\phi_2}\).
The real part of its period vanishes on the invariant homology
line. The anti-invariant line is represented by twice the imaginary
equatorial arc \(0\) to \(i\infty\), closed using \(T\).
This cycle is nontrivial: its integral of the holomorphic
differential \(dx/w\) is
\[
 -2i\int_0^\infty
 \frac{dt}{\sqrt{(t^2+1)(t^2+B^2)}}\ne0.
\]
Thus closing this arc's real \(\phi_2\) displacement closes all
remaining real periods. Puncture loops already have zero real
periods. This argument uses the actual null forms, not the primary
article's existence assertion.

The unchanged `../romon-wohlgemuth-cccc/obstruction.md`, equations
(4)-(17), derives the remaining real equatorial period directly from
(E3), not from an imported existence theorem:
\[
 P(B,A)=\int_0^\infty
 \frac{A^2(B+t^2)+2A(B-1)t^2-t^4-Bt^2}
 {((t^2+1)(t^2+B^2))^{3/2}}\,dt.
                                                               \tag{E4}
\]
Its derivative in \(A>0\) is strictly positive. The exact inversion
pairings there give \(P(B,1)<0<P(B,\sqrt B)\), hence a unique root
\(1<A_0(B)<\sqrt B\). The same reviewed proof evaluates this symmetry period, proves the positive finite meridian
offset, and forces actual upper/lower end intersections. Its proof,
exact replay, and independent verdict are unchanged; they are applied
here to precisely the expressions they evaluated. The direct
regularity proof above does not substitute numerical data for that
analytic argument.

The reviewed full-data anchor identification in
`../kato-muroya-nonzero-reciprocal-fixed/torsion_obstruction.md`,
Section 2, likewise produces (E3) by its explicit quotient and spinor
divisors. Therefore the accepted continuation proof and negative-spin
transport need **only this explicit model**, not the missing primary
display. The spin computation is also internal: the half-divisor of
\(dh/(2g)\) is \(N_++N_--P_{-a}-P_1\), whose class is
\(\mathcal O(P_{-a}-P_1)\). Twice this class is principal, but the
class is nonzero because a degree-one map from a torus to the sphere
does not exist.

The grouped-growth calculation in `literature/comparison.md` uses only
the same four residues: both oriented-normal group products equal
\(-uv\). Thus its defect vanishes throughout this model; its positive
value on the accepted asymmetric arcs separates them from this entire
model under every similarity or reparameterization. This establishes
the mathematical increment over the strongest earlier accepted model
obstruction without authenticating a historical formula.

## What remains inconclusive, and what it is not used to prove

`../romon-wohlgemuth-cccc/reviewer-wohlgemuth-family-excerpt.txt`
authenticates the primary parameter quantifiers, Theorem 11's
period-existence assertion, and its boundary sentences. It expressly
does **not** expose the displayed formula. The independent inconclusive
record `research/literature/ec80f3a78b507568b4376c7f9a2809a1.json`
and the original `CCCC-FAMILY-DATA` versions are retained unchanged.

The missing proposition is exactly: **Wohlgemuth's displayed \(k=2\)
data on printed pp. 15-16 are (E1), up to (E2).** It is not
confirmed, refuted, or needed by the theorem. The live mathematical
premise is now the explicit-model lemma, with the historical assumption
retired for this stated reason. In particular, the certificate does not
claim a primary-source identification of every member of the 1997
display or a classification theorem from Romon's unread thesis.

The existing independent originality/significance receipt
`/home/argustest/zimo/.argus-campaign-6800022-run2/projects/0f2d784a6dfc/handoffs/b0d24e3c49b9/round-0002.json`
and `roles/reviewer/progress.json` expressly compare the reviewed CCCC
model and the inspected Kato--Muroya/Perez--Ros hypotheses. Their
verdicts are preserved. The source-dependency split and the explicit-model
premise were independently accepted in mission `e4e6f877e439`, round 1,
by `reviewer:copilot-l2-e4e6f877e439`. The supporting judgment
`judgement-CCCC-FAMILY-DATA-aa50e19fa6e8` is bound to
`CCCC-FAMILY-DATA` version 3 in `MATH_STATE.json`. This admission
does not authenticate the historical display or constitute final
campaign-level certification.

## Three unchanged reciprocal source premises

The common inspected primary passage is
`../kato-muroya-nonzero-reciprocal-fixed/reviewer-source-passages.txt`.
It was read from version-of-record images by the independent
`reviewer:copilot-l2`. The following exact assumption-bound supporting
judgments already exist in `MATH_STATE.json`:

| Claim / assumption | Primary proposition actually needed | Existing independent judgment |
|---|---|---|
| `KM-NONZERO-RECIPROCAL-FIXED-DECISION` / `KM2012-THEOREM73-IMMERSION` | Section 2's n-noid definition; (7.4)-(7.5), Theorem 7.3, pp. 957-959, including distinct punctures, nonzero weights and degree \(n\) | `judgement-KM2012-THEOREM73-IMMERSION-f9d261a02eaf` |
| `KM-RECIPROCAL-LOCAL` / `KM2012-RECIPROCAL-LOCAL` | (3.4), Proposition 4.2, (7.4)-(7.5), Theorem 7.3: spinors, reflection coefficients, local equations and the signed zero | `judgement-KM2012-RECIPROCAL-LOCAL-38b7f8ff4b0d` |
| `KM-RECIPROCAL-PERIODS` / `KM2012-RECIPROCAL-PERIODS` | Lemmas 3.1-3.4 and both cycles in (7.5), including fixed-puncture, diagonal, off-orbit and logarithmic terms, and the separate degree condition | `judgement-KM2012-RECIPROCAL-PERIODS-07609dfed709` |

The unique-zero consequence used in the local reduction follows from
the inspected sigma quotient (3.4): the exponential factor has no zero,
the numerator has one simple translated sigma zero, and the denominator
has one simple pole modulo the period lattice. Lemma 3.1(iii) identifies
the zero as the retained signed \(s\). This is not an assumption that
the positive sign may replace the negative one.

The source's n-noid definition concerns individually embedded ends;
none of these three assumptions asserts global embedding. The local
coefficient equations and the two cycle equations are transcribed
explicitly in the preserved passage and in `reduction.md`, equations
(2)-(6), with the same source signs. No equation or degree condition is
weakened here.

`verify_source_premises.py --record-prior-citations` archives this
already completed reading as literature evidence only after checking
each existing judgment against its exact current assumption reference,
original reader, and unchanged passage path. The archive note cites
the original judgment and identifies the action as an archival import.
It does not generate a new independent reader, refile an assumption,
or replace the prior mathematics. Admission of the changed CCCC premise
is now independently recorded in the receipt above. Final project-level
certification remains with the normal independent Reviewer path.
