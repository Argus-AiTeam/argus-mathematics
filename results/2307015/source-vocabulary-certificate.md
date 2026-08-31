# Full-scope constituent parse and robust \(\alpha=2/3\) witness

## Result

This route repairs, rather than repeats, the rejected
`LITERAL-TRANSLATE-DENOTATION` argument.

The complete source sentence has more than the two substitutions asserted in
the earlier route. In particular, the angle-specific relation "with vertex at
\(z_0\)" can be weakened, before replacement, to the same-argument relation
"\(z_0\) lies on the boundary of the comparison region." Transporting that
weaker relation to a translated cusp gives arbitrary boundary contact. It is
a stronger truth condition than bare containment, but it is not dismissed
merely because it appears as an extra conjunct after formalization.

Under the mission's explicit no-new-atomic-predicate bar, made precise below
as an occurrence-preserving and parameter-local transformation of the single
printed comparator, all resulting readings have a finite normal form. They
use:

1. the full translated cusp or one of its two connected branches;
2. bare translated-cusp containment, exact origin retention, canonical
   boundary retention, or the closure relation already forced by containment;
3. componentwise or common translating witnesses; and
4. at most a Boolean selection of the seven definitional closure cells
   \(O,V_+,V_-,\Gamma_+,\Gamma_-,I_+,I_-\).

The reviewed all-strata domain has a positive-harmonic-measure arc in each of
the four nonorigin boundary cells and uses the same translate \(w=0\) there.
Two explicit distant translates put its entire closure strictly inside,
respectively, the upper and lower cusp branches, covering \(I_+\) and \(I_-\).
Therefore it satisfies every normal form containing a nonorigin cell. The
only remaining selector is the cusp origin; exact origin retention is already
ruled out by the printed endpoint-disc sentence and the independently
reviewed angular-null theorem. On the endpoint disk, the more general family
of selectors supported only on \(O,V_+,V_-\) is harmonic-null; every
endpoint-consistent selector contains an interior or curved cell.

The predicate

\[
Q(X,Y):\quad 0<|Y|<1\quad\hbox{and}\quad X^2=|Y|
\]

is not one of those normal forms. The nonorigin atom \(0<|Y|\) is available
after a boundary-cell split, but the unit height cutoff and the fixed
endpoint parabola are new atomic content. Thus \(Q\) remains a valid
counterexample to free pragmatic enrichment and to the previously tested
naturality principles, but not to the bounded source-vocabulary replacement
grammar assigned in this mission.

This is an Engineer proof and exact construction. `OBJ` still requires fresh
independent review of the transformation grammar and witness map.

## Primary text and stable locators

The primary source is J. G. Clunie and W. K. Hayman (eds.), "New problems,"
in *Proceedings of the Symposium on Complex Analysis, Canterbury 1973*,
LMS Lecture Note Series 12 (Cambridge University Press, 1974), pp. 155--180,
Problem 7.15, DOI `10.1017/CBO9780511662263.034`.

Cambridge product `448E4822E4E02F1F8A73D101B4BECEA2` exposes the primary
body in archived full-text hits. Its mathematical OCR is damaged, so the
ordinary words are checked at the primary locators below and the mathematical
glyphs are taken from the matching author-maintained transcription
`arxiv:1809.07200v1`, printed p. 165 (PDF p. 166), local lines 5276--5308.

**Complete angular definition.** Primary archive
`research/routes/primary-page-acquisition/cambridge-search-7-15.html:1513`;
glyph-faithful transcription
`research/literature/hayman-lingham-2018-v1.tex:5276-5281`:

> A finite point \(z\) on the boundary \(\partial D\) of \(D\) is called
> angular (relative to \(D\)) if there exists \(\varepsilon>0\) such that
> every component domain of \(D\cap\{|z-z_0|<\varepsilon\}\) which has
> \(z_0\) as a boundary point is contained in an angle less than \(\pi\)
> with vertex at \(z_0\). Angularity at \(\infty\) is similarly defined.

The displayed source alternates \(z\) and \(z_0\). Treating them as one bound
tested point is the unique variable-renaming repair that avoids an unbound
\(z_0\); below it is written \(z_0\).

**Immediate context.** Lines 5282--5296 define \(A(D)\), note that it may
have positive linear measure, and state that for arbitrary domains it is
empty or harmonic-null. This is the result to which "a similar result" in
the next sentence refers.

**Replacement clause, endpoint sentence, and question.** Primary archive
`research/routes/primary-page-acquisition/cambridge-search-translates.html:1513`
and the overlapping endpoint hit
`cambridge-search-result-is-false.html:1643`; glyph-faithful transcription
lines 5297--5304:

> the set \(B_\alpha(D)\) of \(\partial D\) whose points are defined by
> replacing the angles less than \(\pi\) with translates of
> \(\{x+iy:0<x<|y|^\alpha\}\) for a given
> \(1/2<\alpha<1\). (For \(\alpha=1/2\) the result is false as can be seen
> by taking \(D\) to be a disc.)

It then asks for which \(\alpha\in(1/2,1)\) the harmonic measure of
\(B_\alpha(D)\) is always zero, allowing the assumption that
\(\operatorname{cap}(\partial D)>0\).

**Following generalization.** Primary archive
`cambridge-search-characterise.html:1791`; glyph-faithful transcription
lines 5305--5308:

> the set obtained on replacing the angles by translates of
> \(\{x+iy:0<x<f(|y|)\}\)

for a monotone profile \(f\). This changes the comparison set but introduces
no new tested-point relation.

## Constituent-to-formula table

Let

\[
G_{\varepsilon,z_0}(U):=
\bigl[U\text{ is a component domain of }
D\cap B(z_0,\varepsilon)\bigr]\land z_0\in\partial U .
\]

The complete finite-point antecedent is

\[
\begin{aligned}
z_0\in\partial D\ \land\
\exists\varepsilon>0\ \forall U\,
\bigl(G_{\varepsilon,z_0}(U)\Rightarrow
\exists A[&
U\subset A\land \operatorname{Angle}(A)\\
&\land\operatorname{ap}(A)<\pi
\land\operatorname{vertex}(A)=z_0]\bigr).
\tag{1}
\end{aligned}
\]

| Constituent | Formula and attachment | Fate under replacement |
|---|---|---|
| finite point \(z_0\) on \(\partial D\) | \(z_0\in\partial D\) | retained |
| there exists \(\varepsilon>0\) | \(\exists\varepsilon>0\) | retained |
| every component domain of the local intersection | \(\forall U\), component predicate | retained |
| which has \(z_0\) as a boundary point | \(z_0\in\partial U\); the relative clause modifies \(U\) | retained; it cannot reattach to a later comparison object |
| is contained in | \(U\subset A\) | retained |
| an angle less than \(\pi\) | \(\exists A[\operatorname{Angle}(A)\land\operatorname{ap}(A)<\pi]\) | comparison shape replaced |
| with vertex at \(z_0\) | \(\operatorname{vertex}(A)=z_0\); the PP modifies \(A\) | deleted, retained exactly, or canonically weakened before replacement |
| angularity at infinity is similarly defined | spherical analogue | retained, but the independently reviewed finite-exit theorem gives \(\omega_D^q(\{\infty\})=0\) under the positive-capacity hypothesis |

The relative clause about \(\partial U\) occurs inside the subject NP and
cannot grammatically modify the comparison object introduced later. Boundary
contact for the comparison object instead comes from the last row concerning
the vertex.

## Finite transformation grammar

Put

\[
C_\alpha=\{X+iY:0<X<|Y|^\alpha\},\qquad
T_\alpha(w)=w+C_\alpha.
\]

The grammar is deliberately broader than pure textual substitution so that it
meets the prior Reviewer objection. It is nevertheless a transformation of
the **one occurrence** of the comparison object in (1): it may delete, retain,
weaken, or definitionally expand predicates at that occurrence, but it may
not copy the occurrence, specialize the copy at a different value of
\(\alpha\), and conjoin the result back into the generic definition.
Definitional expansion is always at the same value of the bound parameter
\(\alpha\). This occurrence-preserving, parameter-local rule is what
"no new atomic content" means in this certificate.

### Shape and anchor rules

1. **Full contextual substitution.** Delete all angle-specific predicates and
   substitute \(A=T_\alpha(w)\). This gives bare containment:
   \[
   U\subset T_\alpha(w).
   \tag{B}
   \]
2. **Exact modifier retention.** Replace the angle shape but retain its
   distinguished vertex. The only type-preserving distinguished point of
   \(T_\alpha(w)\) supplied by its definition is the translated cusp tip
   \(w\). Thus
   \[
   \operatorname{tip}(T_\alpha(w))=z_0
   \iff w=z_0.
   \tag{O}
   \]
3. **Canonical same-argument weakening.** Before replacement use the
   angle-valid implication
   \(\operatorname{vertex}(A)=z_0\Rightarrow z_0\in\partial A\), then replace
   \(A\). This gives
   \[
   z_0\in\partial T_\alpha(w).
   \tag{BC}
   \]
   Formula (BC) is strictly stronger than (B), but its relation is a
   conservative transport of the printed vertex relation. The previous
   certificate's move from formal strictness to source inadmissibility was
   therefore invalid.
4. **Forced closure relation.** Independently of modifier retention,
   \(z_0\in\partial U\) and \(U\subset T_\alpha(w)\) imply
   \[
   z_0-w\in\overline{C_\alpha}.
   \tag{CL}
   \]
   Indeed, a sequence in \(U\) converges to \(z_0\), and its translates lie
   in \(C_\alpha\). Thus (CL) is already a logical consequence of the printed
   subject and containment clauses. It must be included before any
   adversarial definitional projection.

No other antecedent atom takes the comparison region as an argument. Hence no
other tested-point/comparison-region relation can be formed without a new
atomic formula.

### Closure expansion, branches, and adversarial projections

For \(q=z_0-w=X+iY\), necessary definitional expansion gives the disjoint
seven-cell partition of \(\overline{C_\alpha}\)

\[
\begin{array}{c|c}
O & X=0,\ Y=0\\
V_+ & X=0,\ Y>0\\
V_- & X=0,\ Y<0\\
\Gamma_+ & X=Y^\alpha,\ Y>0\\
\Gamma_- & X=(-Y)^\alpha,\ Y<0\\
I_+ & 0<X<Y^\alpha,\ Y>0\\
I_- & 0<X<(-Y)^\alpha,\ Y<0.
\end{array}
\tag{2}
\]

Write
\[
C_\alpha^+=\{0<X<Y^\alpha,\ Y>0\},\qquad
C_\alpha^-=\{0<X<(-Y)^\alpha,\ Y<0\}.
\]
The printed \(C_\alpha\) is their disjoint union. To over-approximate a sign
attachment or a reading that chooses the connected comparison component
which contains \(U\), the grammar admits the full shape, \(C_\alpha^+\), and
\(C_\alpha^-\). Their compatible closure cells are respectively

\[
\begin{array}{c|c}
C_\alpha & O,V_+,V_-,\Gamma_+,\Gamma_-,I_+,I_-\\
C_\alpha^+ & O,V_+,\Gamma_+,I_+\\
C_\alpha^- & O,V_-,\Gamma_-,I_-.
\end{array}
\tag{3}
\]

Pure expansion retains every compatible cell. To over-approximate every
canonical sign, boundary/interior, or stratum attachment, this route
additionally admits every nonempty union of compatible cells, even though
selecting a proper union is not required by compositional substitution.
Every Boolean formula using only these partition atoms reduces to one of
\(2^7-1=127\) full-shape unions or one of \(2^4-1=15\) unions for each
branch, for 157 shape-selector pairs.

This covers, among others:

- arbitrary boundary contact;
- origin versus nonorigin contact;
- the interior relation forced as a possibility by closure;
- open vertical versus curved contact;
- positive versus negative sign;
- either connected component of \(C_\alpha\); and
- every union of those choices.

It does not cover a height cutoff, tangent condition, algebraic subcurve, or
domain-dependent selector. Each would refine a cell of (2) and therefore
introduce a new atomic formula, which is exactly the mission's exclusion
rule.

### Translate scope

For any fixed shape and selector \(H\), the surface quantifier order is

\[
\exists\varepsilon>0\ \forall U\,
\bigl(G_{\varepsilon,z_0}(U)\Rightarrow
\exists w[U\subset (w+S_\alpha)\land H(z_0-w)]\bigr).
\tag{4}
\]

Inverse scope of the original indefinite comparison object gives the stronger
pointwise common-translate formula

\[
\exists\varepsilon>0\ \exists w\ \forall U\,
\bigl(G_{\varepsilon,z_0}(U)\Rightarrow
U\subset (w+S_\alpha)\land H(z_0-w)\bigr).
\tag{5}
\]

For robustness, the witness below even uses one global \(w\) for every
point in the positive-measure witness set. A fixed branch can likewise be
chosen either componentwise or commonly; the construction satisfies the
stronger common choice. Universal quantification over every translate,
rotations, scalings, or a collective union of translates is not generated by
"an angle" or "translates of."

## Exhaustiveness proof

Consider any reading produced by:

1. retaining every non-comparator constituent of (1);
2. substituting, at the same bound \(\alpha\), the displayed translated cusp
   or a selected connected branch for the one angle comparator;
3. deleting the vertex modifier, retaining it exactly, or applying its
   canonical boundary weakening;
4. retaining the closure consequence forced by containment and
   \(z_0\in\partial U\);
5. applying same-parameter equivalent definitions and, adversarially,
   selecting a union of compatible canonical cells (2)--(3); and
6. choosing componentwise, pointwise-common, or witness-set-common scope.

There is one occurrence of the comparator and one comparison-object modifier.
Steps 2--3 therefore put the explicit anchor into exactly one of the normal
forms \(\top\), \(O\), or the compatible part of
\(\partial C_\alpha\). Step 4 puts every containing translate into the
closure partition even when the modifier was deleted. Step 5 gives exactly
the 157 nonempty shape-selector pairs above; conjunction with \(O\) simply
reduces a selector to \(O\) or to the empty relation. Step 6 changes only the
position of \(\exists w\) and the branch choice. Thus the machine-readable
lattice contains \(157\cdot3=471\) scope-labelled normal forms. This proves
by structural exhaustion that there are no further normal forms in the
stated grammar.

Allowing arbitrary logical weakenings that themselves contain fresh atoms
would destroy exhaustiveness: for example
\((w=z_0)\lor Q(z_0-w)\) is weaker than origin anchoring but imports all of
\(Q\). Such free enrichment is precisely what "without adding lexical or
atomic predicates" forbids. The proof claims no exhaustiveness for that
unbounded pragmatic class.

There is a subtler forbidden copy operation. One may specialize the displayed
shape at the endpoint and derive \(X^2=|Y|\) on
\(\Gamma_{1/2,+}\cup\Gamma_{1/2,-}\), but conjoining that specialized atom to
the generic \(\Gamma_{\alpha,\pm}\) duplicates the sole comparator occurrence
at a second parameter. The endpoint parenthesis is a truth constraint on the
resulting definition, not a second defining relative clause. Consequently
\[
q\in\Gamma_{\alpha,+}\cup\Gamma_{\alpha,-}
\quad\land\quad X^2=|Y|
\]
is outside the occurrence-preserving grammar even though every symbol in its
second conjunct appears after separately specializing the displayed set.
Without parameter locality, this formula is a genuine endpoint-consistent
counterselector and no finite source-faithful conclusion follows. The present
claim is explicitly conditional on the structural replacement grammar, not
on the broader slogan "uses no unfamiliar symbols."

## Atom-by-atom provenance of \(Q\)

Write \(t=|Y|\).

| Proposed atom | Source status |
|---|---|
| \(0<t\) | Derivable after selecting the union \(V_+\cup V_-\cup\Gamma_+\cup\Gamma_-\); not forced by bare containment or full boundary contact because the origin remains. |
| \(t<1\) | Not derivable. The constant \(1\) bounds the dimensionless exponent \(\alpha\), while \(\varepsilon\) bounds points of \(U\) relative to \(z_0\). Neither bounds the relative translation coordinate \(z_0-w\). Reusing the symbol \(<\) on these new arguments would create a new atomic formula. |
| \(X^2=t\) | At \(\alpha=1/2\) this is the curved-boundary equation \(X=t^\alpha\) with \(X\ge0\). For generic \(\alpha\), and in particular \(\alpha=2/3\), the curved atom is \(X=t^\alpha\), equivalently \(X^3=t^2\) at the target. Obtaining both equations requires a second comparator occurrence specialized at \(1/2\). The endpoint-disc sentence is a truth constraint, not a license for that cross-parameter copy. |

Thus \(Q\) cannot be obtained from the printed atoms by the finite grammar.
The following general-profile sentence changes \(t^\alpha\) to \(f(t)\) and
does not supply either missing atom.

This conclusion does not contradict the reviewed
`GENERAL-PROFILE-Q-COMPLETION`: that route correctly showed that \(Q\) can be
added uniformly and naturally. The present route answers a different
question—whether its atoms are generated by the source replacement—and the
answer is no.

## Reconciliation with the prior refutation

The independent review of
`research/routes/literal-quantifier-all-strata/certificate.md` made two
points:

1. formal strictness relative to bare containment does not by itself exclude
   boundary contact or another anchoring repair; and
2. the nontrivial problem framing makes the vacuous bare reading
   pragmatically suspect.

Both points are accepted here. The old claim that bare containment is the
*only* endpoint-consistent literal truth condition is not reused and should
remain refuted. Boundary contact is included by rule 3, the closure
consequence by rule 4, and every canonical anchoring refinement by the
seven-cell over-approximation. The
argument no longer needs to infer authorial intention or to prefer the
vacuous reading: one frozen construction works under every surviving normal
form.

## Exact endpoint classification of the lattice

The endpoint sentence is used only to eliminate normal forms, not to create
new atoms. For a disk and \(\alpha=1/2\):

- an allowed interior cell \(I_+\) or \(I_-\) admits the whole boundary,
  because a bounded disk fits strictly inside a sufficiently distant
  translate of the corresponding widening branch;
- an allowed curved cell \(\Gamma_+\) or \(\Gamma_-\) admits a nondegenerate
  arc by the independently reviewed endpoint-contact construction and its
  reflection;
- origin contact is angular and harmonic-null by the reviewed pinned
  obstruction; and
- vertical contact can occur only at the disk's leftmost point, hence is
  harmonic-null by the disk Poisson density.

Therefore a compatible selector is endpoint-consistent exactly when it
contains at least one of
\[
I_+,\ I_-,\ \Gamma_+,\ \Gamma_-.
\tag{6}
\]
For the full shape the seven nonempty selectors contained in
\(\{O,V_+,V_-\}\) are endpoint-inconsistent. For either branch the three
nonempty selectors contained in its compatible origin/vertical pair are
endpoint-inconsistent. This corrects the tempting but false statement that
origin-only is the sole endpoint-inconsistent selector.

## Frozen all-strata witness under every survivor

Reuse, without rebuilding, the independently reviewed certificate
`research/routes/all-strata-model-domain/certificate.md`. At
\(\alpha=2/3\), let

\[
\begin{aligned}
U_+&=\{x+iy:1<y<3,\ 0<x<y^{2/3}\},\\
U_-&=\{x+iy:-3<y<-1,\ 0<x<(-y)^{2/3}\},\\
R&=\{x+iy:1/4<x<1/2,\ -2<y<2\},\\
D&=U_+\cup R\cup U_-,\qquad p=3/8.
\end{aligned}
\]

For \(4/3<u<7/5\), the four reviewed open arcs are

\[
\begin{aligned}
E_{v,+}&=\{iu^3\},&
E_{c,+}&=\{u^2+iu^3\},\\
E_{v,-}&=\{-iu^3\},&
E_{c,-}&=\{u^2-iu^3\}.
\end{aligned}
\]

For every point \(z_0\) of any arc,

\[
D\cap B(z_0,1/8)=C_{2/3}\cap B(z_0,1/8).
\tag{7}
\]

Consequently the same \(w=0\) works for every point, every relevant
component, every sign, and both boundary types. Two more exact common
translates handle the interior cells. Since
\[
\overline D\subset\{0\le x\le3^{2/3},\ -3\le y\le3\},
\]
put
\[
w_+=-1-100i,\qquad w_-=-1+100i.
\]
For \(z=x+iy\in\overline D\), relative to either translate,
\[
1\le X=x+1<4,\qquad |Y|\ge97>8=4^{3/2}.
\]
Thus \(X<|Y|^{2/3}\); the sign is positive for \(w_+\) and negative for
\(w_-\). Hence
\[
\overline D\subset w_++I_+,\qquad
\overline D\subset w_-+I_-.
\tag{8}
\]

The exact map is:

| Normal-form cell | Positive-measure witness set |
|---|---|
| \(V_+\) | \(E_{v,+}\) |
| \(V_-\) | \(E_{v,-}\) |
| \(\Gamma_+\) | \(E_{c,+}\) |
| \(\Gamma_-\) | \(E_{c,-}\) |
| \(I_+\) | all of \(\partial D\), with \(w_+\) |
| \(I_-\) | all of \(\partial D\), with \(w_-\) |

Any nonempty cell union other than \(O\) contains at least one row of this
table after intersection with its shape-compatibility row (3). For a boundary
row, \(w=0\), \(\varepsilon=1/8\), and the matching sign branch work. For an
interior row, (8) contains all of \(D\), so any \(\varepsilon>0\) works and
the same \(w_\pm\) admits all finite boundary points. Bare containment is
covered by either interior row. Formulas (4), (5), common branch selection,
and even the unprinted witness-set-common strengthening are all satisfied.

The origin-only normal form is \(w=z_0\). Every connected local component
then lies in one quadrant, so the admitted set is angular. The independently
reviewed `PINNED-GLOBAL-OBSTRUCTION` and angular-point theorem make it
harmonic-null for every \(\alpha>0\). It contradicts the primary sentence
that a disc gives a false zero-measure result at \(\alpha=1/2\), and is
therefore not an endpoint-consistent reading.

The domain is a bounded Jordan domain containing \(p\). Its boundary contains
the segment \([i,3i]\). A line segment of Euclidean length \(L\) has
logarithmic capacity \(L/4\) by affine invariance from
\(\operatorname{cap}([-1,1])=1/2\); hence this segment has capacity exactly
\(2/4=1/2\), and \(\operatorname{cap}(\partial D)\ge1/2\). By the reviewed Jordan boundary
correspondence argument, each of the four nonempty open arcs has strictly
positive harmonic measure from \(p\), and from every pole in \(D\).

The infinity clause cannot add a missed positive-measure case. The
independently reviewed `COMPONENT-VACUITY-ZERO` theorem proves that positive
finite-boundary capacity forces Brownian exit at a finite point almost
surely, so \(\omega_D^q(\{\infty\})=0\) whenever infinity is a boundary point.
Prime-end reinterpretation would change the stated Euclidean-boundary
objective.

It follows that for every endpoint-consistent normal form in the finite,
occurrence-preserving, parameter-local source-vocabulary grammar,

\[
\omega_D^q(B_{2/3}(D))>0\qquad(q\in D).
\tag{9}
\]

This is an exact construction and proof, not a finite experiment.

## Why the witness does not accidentally defeat \(Q\)

On all four arcs, \(|Y|=u^3\) and

\[
\frac{64}{27}<|Y|<\frac{343}{125}.
\]

In particular \(|Y|>1\), so \(Q\) rejects every frozen arc already at its
height cutoff. This is desirable evidence that the conclusion rests on the
atomic-provenance proof, not on a geometry that somehow satisfies every free
predicate.

After bounded discovery and typed-contract inspection, Jacobian 0.14.0
operation `arithmetic.real_quadratic.order.compute` compared \(64/27\) with
\(1\). Protocol `2025-11-25` returned `GT` with exact difference \(37/27\)
in 1 ms. The exact payload, raw typed output, discovery results, contract,
server metadata, and adapter status
`exit_status=0, error=null, timeout=false, incomplete_output=false` are
preserved in the adjacent `jacobian-*.json` files. This checks only the exact
height separation; it is not evidence for the syntactic exhaustion or
harmonic-measure statement.

## Replay and review boundary

From the campaign root:

```text
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/full-scope-parse-robust-witness/verify_certificate.py
```

The replay checks the four primary-text archives, the glyph-faithful source
block, generates all 157 compatible shape-selector pairs and all 471
scope-labelled normal forms, classifies endpoint survivors, verifies a target
witness assignment for every nonorigin selector, checks the exact distant
translate inequalities, checks the atom-by-atom \(Q\) classification and
cross-parameter-copy exclusion, replays the exact Jacobian transaction, and
requires existing independent ledger support for the frozen geometry,
harmonic measure, endpoint construction, target-\(Q\) exclusion, origin
obstruction, and finite-exit theorem. It does not rerun or re-certify
unchanged geometry.

Independent review must decide whether the finite no-new-atomic-predicate
grammar faithfully implements the mission bar. Only then may the new
source-membership conclusion support `OBJ`.
