# Marked-component descendant bound and its proposed extension

## Assessment and exact scope

**Engineer assessment: the supplied argument supports the descendant bound at
the level of a geometric prose proof, under its declared foundational inputs.
Its arbitrary-embedding extension uses the same argument.** This is not a
kernel proof, a new result of this review, or final Host Reviewer acceptance.
The nine algebraic groups are supporting checks, not the reason the geometric
statement is supported.

Let \(X\) be smooth, connected, complex and projective. Assume
\(-K_X\cdot C\geq2\) for every irreducible rational curve \(C\subset X\).
Let \(H\) be very ample and let the numerical degree \(\beta\) have a
nonconstant representative \(f:\mathbb P^1\to X\) with \(f^*T_X\) globally
generated. Write \(d=-K_X\cdot\beta\), \(b=H\cdot\beta\), \(h=d-2\).
The assertion is
\[
 \langle\tau_{d-2}(\mathrm{pt})\rangle_\beta\ \geq\ b^{-(d-1)} .
\]
The invariant sums over actual curve classes with that numerical degree.
Fixed \(H\)-degree gives a proper finite-type stable-map stack, so only
finitely many such classes occur. The setting is characteristic zero with
rational stack Chow groups, including stabilizer denominators.

`CDESC@1` is the manuscript specialization: \(X\) Fano of pseudoindex at
least two, and \(H=-aK_X\) for **each** positive integer \(a\) for which it
is very ample; then \(b=ad\). `CGENERAL@1` drops Fano and proportionality of
\(H\) to \(-K_X\), but retains the explicit lower bound on **every**
irreducible rational curve and the free representative. It does not assert
the bound without these hypotheses. `CBDRY@1` additionally states that under
\(-K_X\cdot C\geq\delta\geq2\), the image of a boundary type with \(u\)
root attachments has dimension at most \(h-(\delta-1)u\). This is a
boundary estimate, not a separately improved numerical descendant bound.

The old source is `9000063/research/descendant_bound/proof.md`, Statement
and scope and sections 1-7. Its frozen-manifest entry matches the present
read-only file. The reference manuscript is *The generalized Mukai
conjecture*, author OpenAI, dated September 24, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`. Its `build/sections/descendants.tex`,
section `sec:descendants`, proposition `prop:descendant-bound`, has exactly
the Fano specialization. All seven TeX reference files match the supplied
revision manifest; the old reference directory resolves to that source tree.

## Decisive argument

**Free open (`CFREE@1-3`, section 1).** A nonfree map cannot belong to a
dominant evaluating stratum of \(\operatorname{Mor}(\mathbb P^1,X)\).
Generic smoothness would make evaluation of global sections surjective at a
point. Source-point motion is already accounted for by source automorphisms.
Splitting \(f^*T_X\) then rules out every negative summand. There are only
countably many finite-type strata over all projective degrees. A very general
complex point can therefore avoid all their proper evaluation-image closures
and still lie in the open evaluation image of the given free component.
This controls special maps and covers as well as a general map.

On the irreducible-source fiber \(U\), both \(H^1(f^*T_X)\) and
\(H^1(f^*T_X(-p))\) vanish. Quotienting the marked-map deformation problem
gives smooth pure dimension \(d-2\), and the refined fiber class restricts
to \([U]\). The differential from \(\mathcal O(2)\), in characteristic
zero, and the nonnegative split summands also give \(d\geq2\).
No unobstructedness of the entire compactified fiber is needed.

**Families and contraction (`CCON@1-3`, section 2).** The construction is
made first on the smooth genus-zero projective-space stable-map stack, not
on the possibly obstructed stack of maps to \(X\). On its regular universal
curve, the sum of unmarked-side boundary divisors is Cartier. Twisting the
map line bundle by the subtree degrees changes the multidegree at a nonroot
vertex to
\[
 m_v-E_v+\sum_{\text{children }w}E_w=0
\]
and the root degree to \(b\). The identity works with contracted vertices,
chains and branching. A subtree of degree zero has an unstable leaf; a
degree-\(b\) unmarked subtree would leave an unstable contracted complement.
Thus the indicated divisor sum has precisely the permitted degrees.

The line bundle \(\mathcal O(s)\) has fiberwise \(h^0=2,h^1=0\) and
contracts every nonroot component to a pointed projective-line bundle.
The twisted map bundle after subtracting \(bs\) has multidegree zero,
\(h^0=1,h^1=0\), hence is pulled back from the base. This descends the
sections. On the root, they acquire a common zero of exactly the attached
subtree degree. Proper flat base change is applied on scheme charts.
Crucially, the ambient line bundle **and homomorphism** are pulled back to
arbitrary test families; the proof does not require the pulled-back boundary
divisor to remain Cartier or the homomorphism to remain injective. This is
why boundary-contained and non-flat base changes do not invalidate the step.

**Cotangent and stack degree (`CPSI@1`, `CSTACK@1`, section 3).** With the
mark at infinity, normalize the leading vector and translate away the first
polynomial's \(z^{b-1}\) coefficient. Division by \(b\) is allowed over
\(\mathbb C\). Residual scaling gives weights
\(1^N,2^{N+1},\ldots,b^{N+1}\). The tuple cannot vanish: otherwise all
degree would sit at a single attachment of a constant marked root, which
violates its stability. The \(b=1\) case has only the \(N\) weight-one
coordinates and is included.

Under \(z\mapsto\lambda z\), coefficient and cotangent characters are
\(\lambda^{-j}\) and \(\lambda^{-1}\). Replacing the parameter by its
inverse makes both conventions positive, so
\(\mathbb L_F=\Phi^*\mathcal O_W(1)\), not its dual.
The contraction is an isomorphism near the marking. Basepoint-free tuples
recover precisely the smooth-source maps; every tail produces a common zero.
An affine automorphism preserving the centered polynomial has no translation
part, and the remaining scaling fixes the tuple exactly when it fixes the
pointed map. This establishes degree one **as stacks**, including covers,
rather than merely degree one on coarse spaces.

**Boundary image (`CBDRY@1`, section 4).** The tuple remembers only the
root, its \(u+1\) special points and the discrete tail degrees. If the root
is nonconstant, its freeness through the chosen point makes this data have
dimension \(n+d_0+(u+1)-n-3=d_0+u-2\). If it is constant, \(u\geq2\)
and the root data instead have dimension \(u-2\), the same formula.
Each tail contains a positive-degree component, including covering
multiplicity, hence \(d-d_0\geq\delta u\). Therefore the image dimension
is at most \(h-(\delta-1)u<h\). Bounded projective degree and stability
give finitely many types. No bound on tail-space dimension or obstruction
theory is inferred. If \(h=0\), these inequalities force an empty boundary.

**Virtual localization (`CCHOW@1-3`, section 5).** Subtract the closures of
the smooth \(h\)-dimensional components from the virtual fiber class.
Their restrictions to \(U\) agree, so localization represents the difference
by an \(h\)-cycle on the boundary. Its image has dimension below \(h\),
so rational proper pushforward kills it. Degree one on the open then gives a
nonempty effective sum of image cycles. This proves effectivity **after**
pushforward, not effectivity of the original virtual class.

The contraction need not be representable at the boundary. Kresch's integral
projective covariance is not enough here. The rational separated-DM
coarse-moduli comparison gives the coefficient
\([k(A_c):k(B_c)]|I_B|/|I_A|\); dimension drop gives zero. A common multiple
\(\mathcal O_W(m)\) descends to the coarse space, which also justifies the
needed projection formula. This is an explicit application of the declared
rational formalism, not a fact checked by the script or quoted verbatim from
the Stacks summary.

**Weighted degree and conclusion (`CWEIGHT@1-2`, sections 6-7).** A
grading-preserving monomial degeneration is flat degree by degree and,
after removing the origin and quotienting, remains a family in the fixed
proper weighted projective stack. Its top cycle is a nonempty positive
integral sum of coordinate weighted substacks. For one of dimension \(h\),
the power map from \(\mathbb P^h\) pulls \(\mathcal O(1)\) back to
\(\mathcal O(1)\). Its coarse degree is \(\prod w_j/g\), while its target
generic stabilizer has order \(g=\gcd(w_j)\). Its stack degree is therefore
\(\prod w_j\), giving intersection degree \(1/\prod w_j\geq b^{-(h+1)}\).
This also includes \(h=0\), where the coordinate stack is \(B\mu_w\).
Applying this to the effective pushforward cycle and using
\(\psi=\Phi^*\xi\) proves the stated inequality.

## Foundations, attribution and versioned support

The source readings, hypotheses and limitations are in
[source_checks/source-notes.md](source_checks/source-notes.md), with actual
passage files and current-ledger citation records. They cover Behrend
`alg-geom/9601011v1`, Behrend--Fantechi `alg-geom/9601010v1`, Kresch
`math/9810166v1`, Stacks tags 0B91/04UY, and Mustata--Mustata
`math/0409569v4` and `math/0507464v5`. The original Vistoli PDF remains
unread; the declared input is the official Stacks description of rational
DM proper pushforward/coarse comparison, with the cycle-rule derivation
read separately above. The intermediate-space sources prove the relevant
projective-space technology, not arbitrary-target descendant positivity.

Relative to the **supplied manuscript**, sections 1-7 reconstruct the same
evaluation-fiber/contraction/boundary/localization/weighted-degree argument
already present in `descendants.tex`. In particular its virtual-Chow step
cannot be credited as a distinct new Argus result merely because it goes
beyond the Mustata--Mustata propositions. The inventory does not establish a
historical copying direction or originality. The proposed non-Fano,
arbitrary-\(H\) formulation broadens the hypotheses under which that reasoning
applies; the \(\delta\) formulation exposes its sharper boundary estimate.
Neither improves the Fano numerical constant or has verified novelty here.
The old bounded prior-art search was inconclusive; this review makes no
replacement novelty claim or claim of publishable significance.

All sixteen claim-version records in this unit are accounted for.
`CFREE` v2/v3 add the stable-map and virtual-open assumptions; `CCON` v2/v3
add ambient deformation and base change; `CCHOW` v2/v3 add localization and
rational proper pushforward; `CWEIGHT` v2 declares rational degree.
Their statements and statement hashes remain unchanged. The ten historical
reviewer claim supports across the two supported units and the seven
assumption supports are useful reading judgments, not ten new proofs or
kernel evidence. Their subjects match the statements, but they do not
separately pin version numbers, artifact bytes or the whole dependency set.
This assessment consequently uses the latest declared assumptions and checks
the decisive applications, rather than silently promoting an earlier revision.

## Open status and exclusions

No concrete mathematical gap was identified in the scoped descendant
argument after the checks above. It remains an unformalized prose proof
using standard external geometry. Independent Host acceptance of this
review is pending; originality of the extension is unestablished.
There is no inventoried Lean source or Lean certificate to replay.

The proof explicitly does **not** establish free-degree density, the
descendant recurrence/string conventions, the independent spectral tuple,
alternating traces, the equality-family argument, or the full Mukai theorem.
Those are addressed as unproved-in-this-old-work obligations in the
[excluded-manuscript-chain assessment](../excluded-manuscript-chain/report.md).
Neither support for this proposition nor a finite certificate closes that
chain, and this review has produced no counterexample or manuscript refutation.
