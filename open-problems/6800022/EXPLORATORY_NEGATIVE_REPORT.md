# Exploratory negative report for campaign 6800022

## Exact objective and outcome

The exact objective, quoted verbatim from `OBJECTIVE.md`, is:

> 构造 R³ 中完备嵌入但非适当的极小曲面，或构造有限总曲率、亏格 g、端数 k>g+2 的适当嵌入极小曲面。

Equivalently, the campaign sought either a complete globally embedded
nonproper minimal surface in \(\mathbb R^3\), or a complete proper globally
embedded finite-total-curvature minimal surface with genus \(g\) and
\(k>g+2\) ends.

**Outcome: no counterexample was found.** No exact object satisfying either
branch of the objective was produced. The campaign instead established the
four independently reviewed negative boundaries below. These results exhaust
the stated families or degeneration regime only; they do not prove the
general conjecture.

## 1. Costa's \(y>1\) genus-one four-end family

For every \(y>1\), Costa's source-defined immersion \(I_y\) is not globally
injective. The reviewed calculation uses Costa's exact formulas
\[
 g(z)=a\wp(z)+b\wp(z-\omega_3)+e_3c
\]
and
\[
 c=-\frac{2(e_1S_2+e_2S_1)}{e_3(S_1+S_2)}\alpha
\]
to obtain
\[
 e_3(c-\alpha)
 =\frac{\alpha(e_1-e_2)^2}{S_1+S_2}>0.
\]
Thus the end at \(p_0\), where \(g(p_0)=\infty\), has a vertical limiting
normal, whereas the end at \(p_1\) has
\[
 g(p_1)=\frac{\alpha(e_1-e_2)^2}{S_1+S_2}
        +i\beta(e_1-e_2)
\]
and hence a nonvertical limiting normal. Hoffman--Karcher Proposition
2.2(ii), applied contrapositively to Costa's individually embedded planar
ends, forces two end neighborhoods to intersect. Therefore no member of the
complete parameter domain \(y>1\) is globally embedded, even though the
members are complete, proper as immersions, finite-total-curvature, genus one,
and have four planar embedded ends.

- Exact proof: [Costa obstruction](costa-g1-k4/obstruction.md)
- Source comparison: [preserved AMS pages audit](costa-g1-k4/source/primary-pages-audit.md)
- Independent review: [source and proof review records](../activity.jsonl#L23-L24)
- Reproduction: [Costa replay](costa-g1-k4/replay.sh)
- Ledger boundary: `COSTA-EXHAUSTED`

## 2. Traizet's balanced layered small-neck regime

Consider a connected layered family satisfying Traizet's balance, plumbing,
genus, and end-asymptotic relations, and suppose globally embedded members
occur for arbitrarily small \(t>0\). This includes every family supplied by
Traizet's Theorem 1 and any degenerate balanced configuration that
independently supplies the same relations.

Embeddedness forces the limiting logarithmic growths to obey the weak order
\[
 Q_1\leq Q_2\leq\cdots\leq Q_N.
\]
Writing \(a_k=n_kc_k>0\), balance gives
\[
 \sum_{k=1}^{N-1}\frac{a_k^2}{n_k}
 =\frac12\sum_{k=1}^{N}Q_k^2.
\]
The reviewed nonnegative-coefficient identity for monotone zero-sum \(Q\),
together with weighted Cauchy--Schwarz, yields
\[
 n\geq\frac{N(N-1)}2,\qquad
 g=n-N+1\geq\frac{(N-1)(N-2)}2.
\]
Consequently \(N>g+2\) is impossible in this small-neck regime. In the
specific \(N=4,g=1\) case, connectedness leaves only the three positive neck
distributions
\[
 (2,1,1),\qquad(1,2,1),\qquad(1,1,2),
\]
all with \(n=4\), while the exact bound requires \(n\geq6\).

- Exact proof: [Traizet small-neck obstruction](traizet-neck-bound/obstruction.md)
- Source comparison: [Traizet source audit](traizet-neck-bound/source-audit.md)
- Independent review: [source and proof review records](../activity.jsonl#L30-L31)
- Reproduction: [Traizet replay](traizet-neck-bound/replay.sh)
- Ledger boundary: `TRAIZET-SMALL-NECK-EXHAUSTED`

This result does not cover an analytic continuation away from \(t=0\), other
gluing schemes, or unrelated Weierstrass constructions.

## 3. The authenticated Wohlgemuth \(k=2\) CCCC family

For the authenticated CCCC data
\[
 w^2=(x^2-1)(x^2-B^2),\qquad
 g=\frac{(x-A)(x+1)(x-B)}{(x+A)w},
\qquad B>1,\quad1<A<B,
\]
the equatorial period has exactly one root \(A_0(B)\), and the reviewed exact
pairing identities place it strictly at
\[
 1<A_0(B)<\sqrt B<B.
\]
Under \(B=1/a\) and \(A=\alpha/a\), every source-defined period root therefore
satisfies
\[
 0<a<\alpha<\sqrt a<1.
\]
There is no equal-growth root, crossing branch, second admissible root, or
endpoint root.

At every period root the positive logarithmic growth magnitudes of the two
upper ends satisfy
\[
 \lambda_B-\lambda_1=\frac{B-A^2}{B(B-1)}>0.
\]
Period closure places the outer and inner upper meridians in the same vertical
plane. Their finite endpoint order is opposite to their asymptotic logarithmic
order, so continuity forces an actual upper-end intersection; symmetry gives
the lower-end intersection. Hence every member of the complete authenticated
\(k=2\) CCCC period locus fails global embeddedness.

The source boundary values \(\alpha=a\) and \(\alpha=1\) are respectively
CCFF and CSSC degenerations, not omitted CCCC members. This report does not
claim those distinct degeneration families are exhausted.

- Exact proof: [CCCC period-locus and crossing obstruction](romon-wohlgemuth-cccc/obstruction.md)
- Source comparison: [Wohlgemuth source audit](romon-wohlgemuth-cccc/source-audit.md)
- Independent review: [period and intersection review record](../activity.jsonl#L47)
- Reproduction: [CCCC replay](romon-wohlgemuth-cccc/replay.sh)
- Ledger boundary: `CCCC-EXHAUSTED`

The exact replacement proof does not rely on Romon's unavailable 1993 thesis.

## 4. The Kato--Muroya \(\omega=0\) genus-one four-catenoidal-end class

Every Kato--Muroya \(\omega=0\) genus-one four-catenoidal-end immersion has
spinors
\[
 s_1=Q\sqrt{du},\qquad s_2=P\sqrt{du}
\]
with transition multipliers \((+1,+1)\). Its immersion spin structure is
therefore the trivial theta characteristic \(\mathcal O_E\), which is the
unique odd torus spin structure:
\[
 \operatorname{Arf}_{\mathbb F_2}=1,\qquad
 \operatorname{Arf}_{KS}=-1.
\]

If such a finite-total-curvature immersion were proper and globally embedded,
its four catenoidal ends could be capped outside a compact core by disjoint
exterior disks. The resulting closed embedded torus agrees with the original
surface along a core symplectic basis, so the two Darboux-frame quadratic
forms coincide. An embedded torus carries a bounding even spin structure,
with
\[
 \operatorname{Arf}_{\mathbb F_2}=0,\qquad
 \operatorname{Arf}_{KS}=+1,
\]
a contradiction. Thus **every** Kato--Muroya \(\omega=0\) genus-one
four-catenoidal-end surface is excluded under proper global embeddedness,
without rectangularity, reflection symmetry, or a period-locus assumption.

- Exact proof: [zero-spin Arf obstruction](kato-muroya-zero-spin/spin-obstruction/obstruction.md)
- Source comparison: [zero-spin source audit](kato-muroya-zero-spin/spin-obstruction/source-audit.md)
- Independent review: [full-class review record](../activity.jsonl#L72)
- Reproduction: [zero-spin replay](kato-muroya-zero-spin/spin-obstruction/replay.sh)
- Ledger boundary: `KM-ZERO-SPIN-EXHAUSTED`

## Limitations and unresolved complement

The four results above are exhaustive only at their stated scopes.

1. General nonzero-spin genus-one four-noids remain open. The authenticated
   CCCC family has a particular nonzero two-torsion spin class and is exhausted
   by its own meridian-crossing argument, but that does not cover every
   nonzero spin class or every four-noid period locus.
2. The complete globally embedded nonproper branch at infinite genus remains
   open. None of the four obstructions excludes an infinite-topology,
   infinite-total-curvature, nonproper construction.
3. Proper finite-total-curvature constructions with \(k>g+2\) outside the
   Costa family and Traizet's balanced layered small-neck regime remain open.
4. No immersed surface, numerical near-solution, timeout, or finite search
   boundary is presented as a candidate.

No originality claim is made for the individual source theorems or for the
campaign's reviewed obstructions. This document is a scoped negative report,
not a proof of the global conjecture.
