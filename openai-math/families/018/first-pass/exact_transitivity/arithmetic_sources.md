# Arithmetic inputs and bounded retrieval

The independent source-retrieval worker read the following primary sources.
This file distinguishes the propositions actually retrieved from deductions
made here. No claim of an independent Reviewer verdict is made.

## Local involutions and Brauer invariants

Knus--Merkurjev--Rost--Tignol, *The Book of Involutions*, AMS Colloquium
Publications 44 (1998), Section 3, Theorem (3.1)(2), printed page 31
(PDF page 49), in the accessible author-hosted version:

https://webhomes.maths.ed.ac.uk/~v1ranick/papers/involutions.pdf

The statement read says that for a separable quadratic extension K/F and
a central simple K-algebra B, an involution inducing the nonidentity
automorphism exists if and only if the norm algebra N_{K/F}(B) splits.
There is no characteristic restriction. Section 3.B identifies this
norm with Brauer corestriction. The hosted PDF has unresolved
cross-references and no explicit revision date, so no unverified
canonical version identifier is assigned to it.

J. S. Milne, *Class Field Theory*, version 4.03, August 6, 2020,
Chapter III, Theorem 2.1, printed page 103 (PDF page 112), and equation
(30), printed page 105 (PDF page 114):

https://jmilne.org/math/CourseNotes/CFT.pdf

The local invariant is an isomorphism Br(F) -> Q/Z for a nonarchimedean
local field, and equation (30) states

    inv_F cor_{K/F} = inv_K.

Thus a unitary involution makes the local Brauer class zero after
corestriction, and this identity forces its original invariant to be
zero. The algebra is split. This deduction explicitly uses
corestriction, not the different invariant formula for restriction.

## Hermitian isotropy, including characteristic two

Elman--Karpenko--Merkurjev, *The Algebraic and Geometric Theory of
Quadratic Forms*, AMS Colloquium Publications 56 (2008), Section 36,
Example 36.2(6), printed page 162 (PDF page 170), with the preceding
definition on printed page 161:

https://sites.ualberta.ca/~karpenko/publ/Kniga.pdf

The statement read is: "If F is a local field, then bar-u(F)=4."
The barred invariant bounds all locally hyperbolic quadratic forms;
the surrounding statements include positive characteristic. At a
nonarchimedean local field there are no orderings, so this bounds the
dimension of an anisotropic quadratic form.

For an E/F-Hermitian form h, q(v)=h(v,v) is an F-quadratic form on
the underlying 2n-dimensional vector space, with polar form
Tr_{E/F}(h(v,w)). These formulas hold in characteristic two for
separable E/F. Thus n>=3 gives dimension at least 6>4 and a nonzero
isotropic vector for h. This is a deduction from the cited
quadratic-form bound, not a quotation of a Hermitian-form theorem.

## Other standard inputs and limits of retrieval

Field weak approximation was subsequently retrieved directly in
J. S. Milne, *Algebraic Number Theory*, version 3.08, July 19, 2020,
Theorem 7.20, printed page 114:

https://www.jmilne.org/math/CourseNotes/ANT.pdf

The theorem applies to any field with finitely many nontrivial
inequivalent absolute values. It gives simultaneous approximation
to elements of the field; the immediately following paragraph
extends the targets to the respective completions and states
diagonal density. Thus it applies to function fields as well as
number fields, regardless of the notes' title. The actual statement,
its completion paragraph, and the version heading are preserved in
`field_approximation_excerpt.txt`. The earlier web-search suggestion
confused two different Serre books and was not used.

For existence of a split place in the function-field argument, the
primary source actually read is Michiel Kosters, *A short proof of a
Chebotarev density theorem for function fields*,
**arXiv:1404.6345v2**, Theorem 1.1:

https://arxiv.org/html/1404.6345v2

For a finite Galois extension M/K over F_q with F_q the full
constant field of M, the theorem counts unramified degree-n places
with Frobenius class C as

    (#C/#G) q^n/n + O(q^(n/2)/n).

For a geometric quadratic extension L/k, apply it with C={1}.
For a nongeometric quadratic extension, L is precisely the
quadratic constant-field extension of k. Apply the same theorem
to the *trivial* extension k/k and n even; it supplies places of
arbitrarily large even degree. Such places split in L, since their
residue fields contain the quadratic extension of the constant
field. This two-case argument does not misapply the full-constant-field
hypothesis to a nongeometric extension. The initial search summary
did make that unjustified shortcut and was discarded, not cited.

These are explicit external assumptions, not facts earned by Lean.
Weak approximation for U itself is proved by the Cayley argument in
the report rather than imported from a simply connected theorem.

The finite-quotient assertion for finitely generated global-field
subrings is proved elementarily in Lemma B; the bounded search did
not locate a precise primary-source proposition for it. No external
normalization-finiteness, unit-rank, or divisor-class result is used.

The bounded lookup found no independent source for the exact abstract
additive-generation statement Z U(k)=D in the stated odd-degree
global setting. This is neither a novelty certificate nor an
assertion that such a source does not exist. Lanski's *Unitary
Invariance in Algebraic Algebras* was an unavailable lead (AMS
returned HTTP 403; JSTOR was blocked), so no theorem is attributed
to it. Sethuraman--Sury's *A Note on the Special Unitary Group of a
Division Algebra*, Proceedings AMS 134(2), pages 351--354,
Theorem 1.1, concerns multiplicative commutators over a function field
over a number field; it does not establish this additive assertion.

Source-only ledger citations retain the versions, theorem locators,
URLs, and the distinction between source statements and deductions
in prose. No supporting canonical-citation attribution or independent
Reviewer verdict has been manufactured. The Reviewer must assess
these arithmetic dependencies independently. They are not attached
as assumptions of the purely algebraic Lean claim.
