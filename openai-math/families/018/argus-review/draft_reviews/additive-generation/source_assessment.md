# Additive generation: bounded source reading

Engineer source-reading opinion, 7 November 2026. This is not a native
independent Reviewer verdict or automatic literature attribution.
The filer of the current assumptions is `engineer:old-draft-review`;
the permitted reading opinions use `reader:additive-generation`, a distinct
ledger identity but **not a separately recruited independent reader**.

All five requested sources were obtained with HTTP 200. Only the indicated
propositions, their necessary definitions, title/version information, and
the Kosters version comparison were assessed. Local files, hashes, response
headers, and extraction paths are in [sources/manifest.json](sources/manifest.json).
No citation-check attribution command was run, because its normal literature
writes are outside this unit's boundary. All four assumption bindings remain
source-only; no canonical-ID binding has been manufactured.

## A_LOCAL_SPLIT: KMRT and Milne CFT

**KMRT, *The Book of Involutions*.** Requested URL:
<https://webhomes.maths.ed.ac.uk/~v1ranick/papers/involutions.pdf>.
The bibliographic work is the 1998 book; the obtained Edinburgh-hosted PDF
has no verified edition/revision heading and contains unresolved `(??)`
cross-references. Its PDF creation/modification metadata is 10 April 2010,
which is a file-build date, not certification of a revised edition.
Do not silently identify this file with a canonical 1998 printed version.

Section 3, Theorem (3.1)(2), printed p.31 / PDF p.49, says, with its essential
hypotheses:

> Let K/F be a separable quadratic extension of fields and let B be a central
> simple algebra over K. There is an involution of the second kind on B which
> leaves F elementwise invariant if and only if the norm N_{K/F}(B) splits.

The theorem credits Albert–Riehm–Scharlau and has no characteristic restriction.
Section 3.B, printed p.36 / PDF p.54, identifies this norm's Brauer-group
homomorphism with cohomological corestriction. The split-endomorphism discussion
on printed pp.23–24 / PDF pp.41–42 also states that involutions inducing the
nontrivial automorphism of a separable quadratic center are adjoint to
nonsingular Hermitian forms, without excluding characteristic two.

**Milne, *Class Field Theory*.** Requested and obtained URL:
<https://jmilne.org/math/CourseNotes/CFT.pdf>.
The obtained heading is **Version 4.03, August 6, 2020**, agreeing with the old
attribution. Chapter III, Theorem 2.1, printed p.103 / PDF p.112:

> For every local field K, there exists a canonical isomorphism
> inv_K : H²(K^al/K) → Q/Z.

The relevant local fields here are nonarchimedean. The corresponding Brauer
group identification is also stated in Chapter IV's “A nonarchimedean local
field” paragraph. On printed p.105 / PDF p.114, equation (30) is precisely

    inv_F ∘ Cor_{E/F} = inv_E.

In contrast, equation (29) reads

    inv_E ∘ Res_{E/F} = [E:F] inv_F.

**Deduction, not a quotation of either theorem:** for the local central simple
E-algebra B, a unitary involution gives `Cor([B])=0` by KMRT. Milne (30) then
gives `inv_E([B])=0`, hence `[B]=0` and B is split. This covers ramified and
unramified separable quadratic E/F and characteristic two. Replacing
corestriction by restriction would not be this argument. Milne's proof of an
intermediate characteristic-p lemma refers to Serre; I read the stated
all-local-fields theorem, not a fresh proof of that referenced lemma.

**Opinion:** supports `A_LOCAL_SPLIT` as a standard-input deduction. The old
proposition locators and direction of the invariant identity are correct.
KMRT's exact canonical revision remains unverified and source-only.

## A_LOCAL_ISOTROPY: EKM

**Elman–Karpenko–Merkurjev, *The Algebraic and Geometric Theory of Quadratic
Forms*.** Requested and obtained URL:
<https://sites.ualberta.ca/~karpenko/publ/Kniga.pdf>.
The old bibliography identifies the 2008 book. The obtained file has TeX
creator metadata `2008.05.01:1225` and PDF creation metadata 29 April 2010;
its exact canonical printed-edition/revision identity is not verified.
The proposition and page numbers below are checked in this actual file.

Section 36, Example 36.2(6), printed p.162 / PDF p.170:

> If F is a local field, then ū(F) = 4.

The preceding definition on printed p.161 / PDF p.169 bounds **all locally
hyperbolic quadratic forms**, not merely forms diagonalizable in
characteristic different from two. It also explicitly makes this condition
vacuous over a non-formally-real field. Every nonarchimedean local field in
this argument has no orderings.

**Deduction:** for a nonsingular E/F-Hermitian form h of dimension n, use
`q(v)=h(v,v)` on the underlying F-vector space of dimension 2n. It is an
F-quadratic form with

    q(v+w)-q(v)-q(w) = Tr_{E/F}(h(v,w)).

For separable quadratic E/F the trace is nonzero and onto F, even in
characteristic two. Nondegeneracy of h makes `h(v,-)` onto E for every
nonzero v; consequently the polar form is nondegenerate. In particular this
is a valid quadratic form, not the erroneous characteristic-two
“diagonalization” of a symmetric bilinear form. Since `2n >= 6 > 4`, the
quoted bound gives a nonzero v with `h(v,v)=0`. A Hermitian hyperbolic plane
follows: choose `h(e,f)=1` and adjust f by a multiple of e using the
surjectivity of the trace to make `h(f,f)=0`. Scaling e and f by reciprocal
elements of F supplies unbounded unitary elements.

**Opinion:** supports `A_LOCAL_ISOTROPY` under the stated local-field and
separability hypotheses. The deduction in the old sources file is valid,
including characteristic two. The precise hosted revision stays source-only.

## A_FIELD_WA: Milne ANT

**Milne, *Algebraic Number Theory*.** Requested and obtained URL:
<https://www.jmilne.org/math/CourseNotes/ANT.pdf>.
The obtained heading is **Version 3.08, July 19, 2020**, exactly as inherited.
Theorem 7.20, printed p.114 / PDF p.116, assumes nontrivial inequivalent
absolute values `|·|_1,...,|·|_n` **of a field K**, elements `a_i ∈ K`,
and `epsilon > 0`, and concludes simultaneous approximation
`|a-a_i|_i < epsilon`.

The immediately following paragraph states:

> The statement of the theorem also holds with a_i in K_i (rather than K).

Here K_i is the corresponding completion; the paragraph explicitly concludes
diagonal density in their product. There is no number-field-only hypothesis.
The inherited `field_approximation_excerpt.txt` agrees with this proposition,
its completion paragraph, and the actual version heading.

**Opinion:** supports `A_FIELD_WA` for number fields and function fields.
Weak approximation for the unitary group itself is a further Cayley argument,
assessed in the report, not a theorem quoted from these notes.

## A_SPLIT_PLACE: Kosters v2, including constants

Requested URL: <https://arxiv.org/html/1404.6345v2>.
The obtained HTML identifies **arXiv:1404.6345v2 [math.NT], 27 Jun 2016**,
but its rendered author-date line says **August 24, 2026**. To avoid assigning
that rendering date to the mathematical revision, I also obtained
<https://arxiv.org/pdf/1404.6345v2>. Its first page has the same v2 / 27 Jun
2016 identifier and a **June 28, 2016** author-date line. Theorem 1.1 and its
hypotheses agree in both copies. Both actual copies and their hashes are kept;
the HTML/PDF date discrepancy is not suppressed.

Theorem 1.1, PDF p.1, assumes a finite Galois extension M/K of function fields
over a finite field c of cardinality q, group G, and:

> Assume that c is the full constant field of M.

For a conjugacy class C and unramified primes, its displayed statement is

    #{P : deg_c(P)=n, (P,M/K)=C}
       = (#C/#G) q^n/n + O(q^(n/2)/n).

This is the introductory classical theorem that Kosters explicitly presents
as an example from his reference [3], Rosen, *Number Theory in Function
Fields*, Theorem 9.13B. It is not a claim that the displayed error-term
theorem is the new main result of Kosters' paper. Rosen was not separately
retrieved or automatically attributed in this review.

**Application:** let c = F_q be the **full constant field of k**, not
automatically F_p.

* If L and k have the same full constant field, apply Theorem 1.1 to L/k,
  C={1}. The positive main term supplies split places of all sufficiently
  large degrees.
* Otherwise the constants of L have degree two over c. Since [L:k]=2,
  necessarily `L=k F_{q²}`. Apply Theorem 1.1 to the **trivial extension
  k/k over c**, and choose sufficiently large even degrees. A degree-d
  place splits in the quadratic constant extension exactly when `2 | d`,
  as its residue field F_{q^d} then contains F_{q²}.

Thus split places exist, indeed infinitely many, in either case. Applying
the theorem to the nongeometric L/k over c would omit its full-constant-field
hypothesis and is invalid. Merely renaming the base constants F_{q²} also
does not fix that application, because k does not contain them.

The inherited Kosters excerpt and archived
`00f94a1e5f90315841586ba9e722feee.json` agree with the actual theorem and the
valid two-case deduction. Their old “independently read” label is historical
provenance, not native independent acceptance of this review.

**Opinion:** supports `A_SPLIT_PLACE` in the function-field scope actually
used by Theorem D. No number-field split-place theorem is needed here.

## Retrieval and attribution limits

No required source failed to download. Exact canonical revision identities
remain unverified for the two hosted book PDFs. Public file-build dates are
preserved but are not substituted for edition verification. Milne's two
version headings and the Kosters v2 PDF identifier were directly checked.
All dependencies remain prose/source-only in the current ledger regardless.

The unavailable Lanski lead, Sethuraman–Sury's different multiplicative
theorem, and the confused Serre-book suggestion are inherited retrieval
history, not additional primary propositions obtained or relied on here.
No new search for the additive theorem or for novelty was made.
