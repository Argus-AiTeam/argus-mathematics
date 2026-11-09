# October literal polynomial, stabilization, and fibres

**Engineering verdict: supported in the precise scope below.** This is a reconstruction of supplied work, not a new counterexample, a novelty determination, or independent acceptance. The obstruction used for noncoordinateness is assessed separately in `../october-unrestricted-obstruction/report.md`.

## Sources, versions, and exact claims

The reference is OpenAI, *A stable coordinate that is not a coordinate in four variables*, October 5, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`, as identified by the existing campaign `9100049/MANUSCRIPTS.json`. The author and date occur in `build/source/main.tex`. The relevant statements are `prop:polynomial`, `prop:stable`, `prop:fibers` in `02-construction.tex`, and `thm:main`, `cor:fibers` in `01-introduction.tex`. The six source digests were matched to that manifest by the shared source assessment; no new source manifest or repository checkout was made.

The old draft is `9000049/research/stable_core_certificate/report.md`, particularly section 5, with its `verify.py`, `exact_certificate.json`, `Main.lean`, and staged formal sources. Campaign prefixes abbreviate `campaigns/`. The preserved snapshot is a copy of the arguments, not an additional mathematical contribution.

Over \(k=\mathbb C\), let
\[
 Q=x_2^2-x_4^2+x_1x_3,\qquad
 f=x_1-2Q\{Q(x_2+x_4)+x_1x_4\}.
\]
The four assigned version-1 claims are:

| Old claim | Exact scope | Engineering verdict |
|---|---|---|
| `C_OCT_PRESENTATION` | The quotient \(A=k[p,s,u,F,J]/(H)\) below is \(k^{[4]}\), with its distinguished \(p\) equal to this literal \(f\). | supported |
| `C_OCT_STABILITY` | \(f\) becomes a coordinate after adjoining exactly one independent variable; the automorphism need not preserve the original four-variable subring. | supported |
| `C_OCT_FIBERS` | Every scheme fibre \(f=\lambda\), including \(\lambda=0\), has coordinate algebra \(k^{[3]}\). | supported by the algebraic proof below, not asserted by the eight printed Lean roots |
| `C_OCT_NONCOORD` | \(f\) has total degree five, is not a coordinate, is a one-stable coordinate, and every fibre inclusion in \(\mathbb A^4\) is nonrectifiable. | supported, using the separately reviewed unrestricted obstruction |

These are parts of one October construction, not four unrelated examples. The unchanged natural statement of `C_STABLE_CORE_VERIFY` versions 1, 2, and 3 uses the presentation and stabilization reviewed here. The failed v2 formal artifact is not retrospectively called a proof: the obstruction report records its error and the repaired v3.

## Checked polynomial presentation and signs

In the five-variable polynomial ring put
\[
 x=s^2-u^2+pF,\quad
 H=x^2F-(1+2sx)J-pJ^2-u,\quad A=P/(H).
\]
Take
\[
 M=\begin{pmatrix}F&s-u\\s+u&-p\end{pmatrix},\quad
 e=(x,-J)^{\mathsf t},\quad n=(J,x)^{\mathsf t},\quad N=ne^{\mathsf t}.
\]
Here \(e^{\mathsf t}n=0\), so \(N^2=0\) and \(\det(1-2N)=1\). The substitution \(M'=(1-2N)M\), keeping \(J\) fixed, preserves \(x=-\det M\). Therefore it also preserves the expressions \(e,n,N\) used in its own formula. Its inverse is genuinely the polynomial substitution \(M=(1+2N)M'\), not an inverse requiring a denominator or an unverified implicit solution.

Writing \(M'\) in the same four-entry form gives \(u'=u-e^{\mathsf t}Me\) and \(H=-J-u'\). Eliminate the monic variable \(u'\). The resulting coordinates on \(A\) are \(p',s',F',J\), and the inverse lower-right entry gives
\[
 x=(s')^2-J^2+p'F',\qquad
 p=p'-2x\{x(s'+J)+p'J\}.
\]
Thus \((p',s',F',J)=(x_1,x_2,x_3,x_4)\) gives exactly the printed signs in \(f\). There is no exchange of \(s'+J\) for \(s'-J\), and the eliminated equation is \(u'=-J\), not \(u'=J\).

Every term of \(f\) has total degree at most five. At \(x_1=x_3=x_4=0\), it becomes \(-2x_2^5\), proving degree exactly five over \(\mathbb C\); this is not a sampled degree estimate. Also \(f(0,0,0,0)=0\), \(f(1,0,0,0)=1\), so \(p\) is a nonzero nonunit, as the filtration argument later requires.

## Checked stabilization and global elimination

Set \(y=s+x(x+u^2)\), \(z=sx+pJ\). Expansion gives
\[
 xy-z(z+1)=p(H+u).
\]
After inverting \(p\), the actual inverse coordinates are
\[
 s=y-x(x+u^2),\quad F=(x-s^2+u^2)/p,\quad J=(z-sx)/p.
\]
In these coordinates \(\Delta=-p\partial_u\) fixes \(p,x,y,z\). Its values on the original generators are
\[
 \Delta u=-p,\quad \Delta s=2pxu,\quad
 \Delta F=-4sxu-2u,\quad \Delta J=-2x^2u,\quad \Delta p=0.
\]
They lie in \(P\), so the restriction preserves \(P\). Local nilpotence follows from the polynomial-coordinate localization, with \(P\hookrightarrow P[p^{-1}]\) injective; alternatively the replay checks terminating iterates on all five generators. The Leibniz rule then gives local nilpotence on every polynomial. No assertion that arbitrary localization preserves an arbitrary LND is used.

Differentiating the displayed identity in the polynomial domain gives \(\Delta H=p\). Consequently \(\exp(w\Delta)\) and \(\exp(-w\Delta)\) are mutually inverse polynomial automorphisms, fix \(p\), and transport the equation \(H\) to \(H+pw\). This only uses factorial denominators over characteristic zero. The formal source instead proves integral explicit substitutions and their inverses, so its shift construction itself needs no factorial divisions.

Let \(x_0=s^2-u^2\) and
\[
 L=x_0^2F-(1+2sx_0)J,\qquad
 N_0=(1-2sx_0)F+4s^2J.
\]
The coefficient determinant is one, with inverse
\[
 F=4s^2L+(1+2sx_0)N_0,\qquad
 J=-(1-2sx_0)L+x_0^2N_0.
\]
Expansion gives \(H=L-u+pQ_0\), where
\[
 Q_0=2x_0F^2+pF^3-2sFJ-J^2.
\]
Since \(Q_0\) is independent of \(w\), \(w'=w+Q_0\) is a polynomial shear, including after the invertible \(L,N_0\) substitution. Hence
\[
 A[w]\simeq P[w]/(H+pw)
 \simeq k[p,s,u,L,N_0,w']/(L-u+pw')
 \simeq k[p,s,u,N_0,w'].
\]
The distinguished \(p\) is fixed at every step. Composing with the four-variable presentation produces an ambient automorphism of \(k[x_1,x_2,x_3,x_4,w]\) sending the embedded \(f\) to its first coordinate. This is stronger than merely having an abstract polynomial fivefold.

## All fibres and nonrectifiability

At \(p=0\), the same determinant-one substitution gives
\[
 A/(p)=k[s,u,L,N_0]/(L-u)\simeq k[s,u,N_0].
\]
At \(\lambda\ne0\), the localized inverse is valid on the whole fibre, and the quadric identity gives
\[
 A/(p-\lambda)\simeq
 k[x,y,z,u]/(xy-z(z+1)-\lambda u)\simeq k[x,y,z].
\]
The last step eliminates \(u\) using the invertible constant \(\lambda\). This does not cancel \(p\) at the zero fibre.

The separate obstruction unit proves that any coordinate system containing \(p\) would yield a nonzero LND \(E\) of the exact ring \(B\) with \(0\ne h\in I\cap\ker E\), and proves this impossible. Under the checked presentation, \(f\) is therefore not a coordinate. This is a proof using a universally quantified obstruction, not the result of enumerating derivations or checking the degree of \(f\).

Each fibre quotient is a polynomial domain, so \((f-\lambda)\) is its prime defining ideal. If an ambient automorphism rectified that embedding, it would carry the defining ideal to a coordinate-hyperplane ideal. Two generators of the same nonzero principal ideal in the polynomial domain differ by a unit, and its units are the nonzero constants. Thus a constant multiple of \(f-\lambda\) would be a coordinate, making \(f\) a coordinate after a translation, a contradiction. The conclusion concerns the given embedding, not a failure of the abstract fibre to be affine space.

## Formal fidelity, evidence, and limits

The staged `Definitions.lean` defines `R n` as `MvPolynomial (Fin n) C`, `IsCoordinate` by an actual complex algebra automorphism sending the polynomial to `X 0`, and `stabilize` by `Fin.castSucc` into five variables. No original-subring preservation condition is smuggled into `IsOneStableCoordinate`. `IsAffineThreeSpaceFiber` is an algebra equivalence of the quotient, not a set bijection. `IsRectifiableFiber` uses an automorphism carrying the actual defining ideal to `(X 0)`.

| Proof component | Actual formal declarations |
|---|---|
| Polynomial inverse and equation transport | `MatrixChange.quad_change`, `pChange_add`, `sChange_add`, `uChange_add`, `FChange_add`, `relation_change_neg_one` |
| Both quotient-map composites | `Presentation.toPolynomial_fromPolynomial`, `fromPolynomial_toPolynomial`, `polynomialPresentation` |
| Exact literal polynomial and independent fifth variable | `Presentation.originalPresentation_p`, `polynomialPresentation_p`, `stabilizedPresentation_p` |
| Actual inverse shift, not a premise that a shift exists | `ExponentialShift.shift_comp_neg`, `shiftEquiv`, `shift_H` |
| Determinant-one substitution, shear, linear relation | `Linearization.equiv`, `h_expansion`, `shearEquiv`, `normalization_stabilized_h` |
| Both final quotient-map composites | `StabilizedQuotient.out_comp_into`, `into_comp_out`, `equiv_p` |
| Unconditional five-variable automorphism | `Stabilization.stablePresentationEquiv`, `f_isOneStableCoordinate` |
| Literal wrapper conclusions | `IndependentStableCore.literal_matches`, `literal_noncoordinate`, `literal_one_stable`, `stable_core_verify` |

The conditional helper `oneStable_of_presentations` is not used as an unproved assertion: its two presentation-equivalence hypotheses and both image equations are supplied by the preceding explicit constructions. The wrapper's literal equality is definitional and was compared with the printed natural-language polynomial, including the zero-to-one-based variable renaming.

The shared fresh `../october-unrestricted-obstruction/main_replay.json` records actual Lean 4.31.0 wrapper re-elaboration, exit 0, with only foundational printed axioms. It reuses precompiled imports and is not a fresh 92-source rebuild. There is no new current-campaign `.lean` artifact or current kernel-status claim. Definitions of `PolynomialPackage` and `FiberPackage` are definitions, **not proofs** of either package. The eight printed roots establish the literal noncoordinate/one-stable assertions, but do not themselves assert total degree five, all fibre equivalences, or all nonrectifiability conclusions. Those additional claims have the prose proofs above; they are not rejected merely because the wrapper does not encode them.

The single fresh `../september-construction-critical-point/exact_replay.json` reproduces all 81 old exact checks. The first 41 entries cover the signed quadric, matrix nilpotence and inverse, literal transport, terminating generator iterates, exponential invariants, determinant-one inverse, \(H=L-u+pQ_0\), and the \(p=0\) boundary. This finite exact algebra supports the formulas, not by itself the universal noncoordinateness conclusion. No unchanged computation was rerun for this unit.

No unproved external classification theorem is needed for these constructions. The hypotheses are the stated complex base, independent polynomial variables, polynomial/quotient algebra, and the separately reviewed unrestricted obstruction. Attribution is to the supplied October manuscript and reused implementation, not to this review. Global priority, significance, and independent acceptance remain unestablished. No unresolved mathematical step was identified within this unit; the explicit formal-coverage and import-trust limits remain.
