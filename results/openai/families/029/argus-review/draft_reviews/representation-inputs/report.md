# Representation, arithmetic and smoothing inputs

**Engineer assessment: conditional support, not unconditional certification.**
The cover/datum and smoothing deductions are coherent with the specified
sources. The unproved arithmetic package and the applicability/gluing steps
must remain explicit. Native independent source attribution and acceptance
have not occurred in this round.

## Scope and versions

This unit covers `C_ARITHMETIC`, `C_THETA_INPUT`, `C_COVER_DATUM`,
`C_GLOBAL_FACTORIZATION`, `C_LOCAL_PROFILES` and `C_GAUSSIAN_SMOOTHING`.
Its draft is old `REPORT.md`, Sections 1 and 3.1. Relevant primary source
arguments are `02-arithmetic.tex`, `03-theta.tex`, and the first two
subsections of `10-whittaker-calculation.tex` at manuscript revision
`4eaee87548250b2682affda7d05d947c05554bae`. They are supporting manuscript
arguments, not additional Argus discoveries.
The old manuscript directories link to the assigned source directories;
the stated revision is the reference version read for this review, not a
claim that manuscript bytes were preserved in the old five-file snapshot.

The exact fixed setting is a cyclotomic number field containing `mu_12`,
the final finite set `S` containing the bad places, the declared additive
character and self-dual measures, an `S`-integer generator convention modulo
`Gamma=U_S^6`, and fixed local vectors. All conductor and profile constants
depend on this fixed data; no conductor-uniformity in a varying field or
varying `S` is established.

## Source comparison

The following are statements read in the obtained primary texts, not claims
that a DOI lookup or the old opinions proves their applicability.

| Proposition | Exact attribution and hypotheses | Assessment |
|---|---|---|
| Cover, center, compact sections | Kazhdan-Patterson 1984, `doi:10.1007/BF02698770`, Section 0.1, Propositions 0.1.1 and 0.1.3, printed pp.42,44. Compact canonical splitting requires residue characteristic prime to the cover degree. | Supports these local input statements. The p.41 image concerns twisted extensions; it is not by itself the p.42 center proposition. |
| Exceptional representation | Same source, Theorem I.2.9(a),(b),(f), p.72; exceptional datum, with the normalized tame hypothesis for the spherical vector. | Supports the unique subrepresentation/quotient and spherical input, not a numerical Gauss formula by itself. |
| Local uniqueness | Same source, Corollary I.3.6, p.79. The image reads `r=n-1` with `2(c+1)=0 mod n`, or `r=n`. | The specialization `(r,n,c)=(2,3,2)` satisfies the criterion. The OCR sign must not be read as noncongruence. |
| Complex model | Same source, I.6.4(c) and I.6.5(c), pp.104-105; exceptional datum, `F=C`, `r<=n`. | Supports principal-series identification and one-dimensional Whittaker space, not the subsequent differentiated Bessel estimates without calculation. |
| Global existence and genericity | Same source, compatibility after Lemma II.1.1, p.107; II.2.1, p.118; II.2.5(a),(b), p.122. The character is trivial on its rational intersection; the required tame local Whittaker spaces are nonzero, respectively one-dimensional. | Supports the conditional construction. II.2.5(a) supplies nonzero global coefficient; (b) supplies local uniqueness at every place. |
| Constant terms | Same source, Proposition II.1.2 and Theorem II.1.3, pp.110-111. Self-dual/Tamagawa measures and compatible inducing data are retained. | Supports the factored Weyl sum and continuation, not a new unrelated global estimate. |
| Corrected coefficients | KP 1985, `doi:10.1007/BF02698809`, correction p.203 to II.2.2-II.2.3 and p.130. | The auxiliary vanishing assertion is withdrawn. Stabilization is of `C_S T(S)`; rank two gives `T(S)=product_(finite v in S)(1+q_v^(-1))`. |
| Jacobi norm lift | Hoshi-Kanai, `arxiv:2105.14872v2`, dated 4 August 2022, Theorem 1.1 and its Jacobi consequence on p.2. Both characters and their product must be nontrivial. | Applies to `rho,rho,rho^2` of order three. The theorem is first a Gauss lifting theorem; its explicitly stated Jacobi consequence is the formula used here. |
| Additive duality and Poisson | Weil 1964, `doi:10.1007/BF02391012`, Chapter II Section 29 and Chapter III Section 41, equation (39). A nontrivial adelic character is trivial on the global field; test functions are Schwartz-Bruhat. | Supports self-annihilation and Poisson in this setting. It does not assert the separate profile/unfolding estimates. |
| Quadratic phases | Same Weil source, Sections 27-28 and Section 30 Proposition 5. Nondegenerate quadratic forms and compatible global additive character; the application is characteristic zero. | Section 27 reduces the local index to a normalized Gauss sum; Section 28 relates the four-variable norm form to the Hilbert symbol; Proposition 5 gives the global product one. |

For auditability, the less reliably retrieved source anchors were checked
directly: `kp1984.txt` lines 1210-1244 (ordinary Jacquet functor and its exactness),
1730-1768 (I.2.9), 3260-3330 (complex statements), 3380-3450
(compatibility), 3525-3608 (constant term), 3935-3996 (II.2.1), and
4210-4248 (II.2.5). The Weil passages are lines 1325-1570 and 2127-2135.
Line numbering refers to these supplied text files, not a different edition.
The retained p.79 image resolves the uniqueness congruence where OCR is unsafe.

There is no established Weil DOI/title mismatch: the archive link itself
names `BF02391012`, the text is *Sur certains groupes d'operateurs unitaires*,
and the exact Crossref record
`https://api.crossref.org/works/10.1007/BF02391012` identifies Weil, 1964,
*Acta Mathematica* 111, pp.143-211. This bibliographic resolution is not
the theorem check; the sections above are. The failed Euclid interstitial
does not undo the separately obtained text. Similarly, Hoshi-Kanai's original
2021 identifier must not be mistaken for a claim that v2 was dated 2021.

`neukirch_retrieval.html` is a publisher book page, not the book. The
source-only assumption in the active ledger names the actual obligations:
local power-class duality/dimensions, S-units, the S-class-field assertion,
reciprocity and norm-one idele compactness. Its unverified locators are
Neukirch (1999), II Corollary (5.8), I (11.6)-(11.7), V Proposition (3.2),
VI Theorems (1.6),(7.3),(8.1) and Proposition (6.9). None is represented
as read, independently attributed or mechanically certified.

## Applicability: what the prose does establish

For the determinant-modified torus cocycle the scalar exponent is `1+4c`.
At `c=2` this is 9; the cubic symbol on two scalar lifts is therefore one,
and the scalar preimage is central. This proves the claimed split scalar
quotient in the stated cocycle, rather than identifying noncommuting lifts.
The datum on cube diagonals times scalars is presentation-independent,
trivial on the split scalars, and gives `|t|` on `diag(t^3,t^(-3))`.
That is the exceptional condition. With the Weyl-conjugate exponent and
modular factor the triple valuation step is `q^(-1)`, agreeing with the
local unit rather than an arbitrary phase choice.

For global compatibility the manuscript argues that a rational ratio which
is a cube at every completion is a global cube: otherwise its nontrivial
cyclic Kummer extension has a nonsplit unramified prime. This uses the
standard Kummer/Chebotarev consequence, not the polynomial checker.
The product formula then kills the inducing character on the rational
intersection. Extension to the required maximal abelian subgroup is part
of the global inducing construction. These hypotheses, and not only a
local uniqueness slogan, are what permit II.2.1 and II.2.5.

Given a nonzero global functional, choose a pure tensor where it is
nonzero, enlarge the final `S` before fixing arithmetic data, and normalize
each exterior functional at its distinguished vector. Varying one tensor
factor at a time and using uniqueness proves factorization on pure tensors.
At the remaining finite set, finite-dimensional twisted Jacquet quotients
give a finite sum of products. This avoids the false auxiliary assertion
withdrawn in 1985 and avoids an unnormalized infinite product.

The arithmetic linear-algebra step is not merely "the book was unavailable".
For each of the 2- and 3-power-class spaces it needs ambient dimension
`2s_f+2r` and an injective localized S-unit image of dimension `s_f+r`.
The kernel would yield an everywhere unramified Kummer extension split
at `S`, excluded by the stipulated trivial S-class group. Reciprocity and
`-1 in F^(x6)` make that half-dimensional image isotropic for an alternating
pairing, so symplectic linear algebra gives a complement `B`. Norm-one
idele compactness then gives balanced generators. These are concrete
mathematical premises whose verification, not a download success, would
discharge this portion.

The Gauss correction has a concrete construction in `02-arithmetic.tex`
lines 411-573. Over `Q(omega)`, divisibility, norm and the congruence
`J(rho,rho)=-1 mod 3` identify `J` with the negative primary generator.
Primary generators multiply, defining a unitary angular Hecke character;
norm pullback and the stated Jacobi lifting sign give the character over
`F`. The ordinary angular exponents are `+1` or `-1`, with no radial factor.
For the quadratic correction, normalize the Weil index by the index of
`x^2`. The global product and the Hilbert-symbol defect restrict to a
genuine finite class character on isotropic `B`. Arbitrary prime signs
alone would not suffice; the provided construction is why the correction
is compatible globally.

## Profiles and exact smoothing

At finite `S`, upper-root averaging can produce `1_U` after choosing a
vector nonzero near one and a compact open subgroup inside the relevant
sixth powers and character kernels. At complex places the Jacquet integral
has the `K_(1/3)` profile. A first derivative supplies the angular weight
needed to cancel the correction character. Fixed compact rotations remain
first Lie derivatives, not a row-dependent unbounded family.

The complex integrand bound integrates to `O(rho^(2/3))` near zero;
integration by parts gives `O_N(rho^(2/3-N))` at infinity. At finite places
upper-root invariance gives a large-norm cutoff. The ordinary Jacquet module
has possible triple-step magnitudes `q^(-1),q^(-2)`. Exactness and the
eventual recurrence give polynomial times those powers, absorbed by any
small-norm exponent below `1/3`. The fixed finite profile family therefore
has two-ended decay after norm derivatives. A dependent complex norm and
weighted product integrals transfer this to norm sheets. These are analytic
prose deductions; the local symbolic certificate does not test them.

The Mellin convention gives
`Vhat(s)=C A^s [Gamma(s+5/6)Gamma(s+7/6)]^r`.
Using `R(s)=exp(s^2)/Vhat(s)` and
`K(T)=(2 pi i)^(-1) integral R(s)T^s ds` gives
`Khat(-s)=R(s)`, hence `integral K(T)V(uT)dT/T=P_G(u)`.
Reciprocal gamma factors are entire and the Gaussian controls vertical
growth on every fixed strip. Moving the contour gives all absolute
moments of `K`. This checks the sign and the exchanges needed both for
`uT` and reflected `u/T`. Angular averaging, not a finite residue identity,
kills the two radial constant terms.

## Remaining obligation and attribution

The strongest supported statement is the conditional representation/arithmetic
reduction just described. To upgrade it to unconditional certification one
must discharge the specified localization, reciprocity, compatible generator
and inducing-character premises, and independently attribute the cited
propositions with their exact hypotheses. That is a mathematical dependency,
not evidence that the estimate is false. No erroneous manuscript theorem
or new global representation theorem has been established.

The active ledger recorded the previously obtained source status and these
imported assumptions before substantive checking. It deliberately contains
no self-issued supporting literature attributions. Its citation status remains
open for the distinct reader/native Reviewer; old reviewer-labelled opinions
do not supply this round's acceptance.
