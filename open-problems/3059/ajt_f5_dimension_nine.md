# AJT in dimension nine over F5

**Theorem (C3059N9).** Every A in GL_9(F5) admits x in (F5*)^9
with Ax in (F5*)^9.

**Abstract.** We prove the Alon--Jaeger--Tarsi conjecture in dimension
nine over F5. Repeated-column permanent-rank amplification handles
permanent rank at least six. At permanent rank five, an exactly
certified structural theorem supplies a sparse column in the matrix
or its inverse, allowing extension from dimension eight. The latter
case is proved here using amplification and the published even-rank
equality classification. The structural step is computer-assisted;
the argument is not a census of GL_9(F5).

**Review status.** The completed independent project review accepted
the proof, its originality and publishable significance. Final
project-local submission certification remains for the Host-invoked
independent Reviewer. This is neither unrestricted AJT, journal
acceptance nor formal kernel verification. The mathematical arguments
and accepted structural certificates are unchanged.

## Inputs and exact scope

The permanent rank of a matrix is the largest order of a square
submatrix with nonzero permanent over its field. A generalized
permutation matrix has exactly one nonzero entry in each row and
column; it and its inverse preserve the set of nowhere-zero vectors.

The self-contained proofs in `permanent_amplification.md` give:

1. **AMP3059:** If A is invertible of order m and r_k is the permanent
   rank of k horizontal copies, r_0=0 and
   r_(k+1)>=ceil((m+r_k)/2) for every k>=0.
2. **PGC3059:** Over F5, r_3=m suffices for a nowhere-zero input and
   output. The proof includes the nonzero multiplicity factorials and
   a finite-grid argument; a nonzero repeated-column permanent is not
   simply identified with an unscaled row-product coefficient.

The published equality classification used below is Kisley--Shader,
*Matrices whose permanent rank equals half their rank*,
Communications in Optimization Theory 2025, Article 49,
DOI 10.23952/cot.2025.49, Theorem 4.8, page 13 [1]:
an invertible m by m matrix in characteristic different from two
with permanent rank m/2 is generalized-permutation equivalent to a
direct sum of

    P2 = [[1,1],[1,-1]].

This source and its exact hypotheses have already been independently
read; the local PDF, extracted text and proposition excerpt are in
`literature/kisley_shader_2025.*` and
`literature/ks_theorem_passages.txt`. Only permutations and nonzero
coordinate scalings are allowed here, not arbitrary basis changes.

The independently reviewed **NS3059** says that every GL_9(F5)
matrix of permanent rank five has a column with at most three
nonzero entries in A or A^-1. Its complete proof is
`zero_profile_final.md`, with the accepted-case assembly and exact
structural certificates linked there. The independent Reviewer
recorded support at 2026-11-04T04:47:39Z in the claim ledger and
public activity. This note reuses that theorem; it does not rerun
or re-review its censuses.

## Dimension eight (H8C3059)

Let A be in GL_8(F5). By AMP3059 with k=0 its permanent rank r_1
is at least four.

If r_1>=5, then AMP3059 gives

    r_2 >= ceil((8+5)/2)=7,
    r_3 >= ceil((8+7)/2)=8.

Since there are eight rows, r_3=8. PGC3059 supplies the desired
input and output.

If r_1=4, the hypotheses of Kisley--Shader Theorem 4.8 hold:
ordinary rank is eight, permanent rank is exactly half that rank,
and characteristic five is not two. Thus

    A=L diag(P2,P2,P2,P2) R

for generalized-permutation matrices L,R. Each such matrix and its
inverse preserve the torus. In each block use input (1,2), whose
output under P2 is (3,4) in F5. Concatenating these four inputs
gives u with both u and diag(P2,P2,P2,P2)u nowhere zero. Taking
x=R^-1 u gives Ax=L diag(P2,P2,P2,P2)u, also nowhere zero.
This proves H8C3059 in both permanent-rank branches. In particular
the dimension-eight premise is proved here, rather than borrowed
from the unread boundary-preprint proof. QED.

## Permanent rank at least six in dimension nine (H6C3059)

Let A be in GL_9(F5) with r_1>=6. Then

    r_2 >= ceil((9+6)/2)=8,
    r_3 >= ceil((9+8)/2)=9.

Again r_3=9, and PGC3059 proves AJT for this entire class.
There is no sparse-column premise in this branch. QED.

## The rank-five branch and the inverse case

AMP3059 with k=0 gives r_1>=ceil(9/2)=5 for every A in GL_9(F5).
The preceding section covers r_1>=6. Suppose henceforth r_1=5.
Apply the accepted NS3059 theorem to A.

If A itself has a column of support at most three, apply the accepted
SP3059 sparse-column extension, now with the established H8C3059.
For precision, that extension uses determinant expansion in the
selected column to choose an entry with nonzero cofactor. The
corresponding deleted eight-dimensional matrix is invertible.
Choose a torus input for it using H8C3059 and insert a nonzero value
t in the omitted coordinate. Rows outside the support remain
nonzero. Each of at most three supported rows forbids at most one
value of t, whereas F5* has four values. A valid t therefore exists.
The deleted row is counted among these supported rows because its
selected entry is nonzero.

If instead NS3059 supplies a sparse column only in B=A^-1, apply
that same extension to B, which is an invertible matrix of order
nine. This use of SP3059 has no permanent-rank hypothesis on B.
It gives z in (F5*)^9 with Bz in (F5*)^9. Put x=Bz. Then

    x in (F5*)^9,    Ax=z in (F5*)^9.

No invariance of permanent rank under inversion is assumed or
needed. These two alternatives cover the entire rank-five class.
Together with H6C3059 they prove C3059N9. QED.

The canonical torus remainder R_A from Q3059 is consequently nonzero
for every invertible A of order nine. This follows from the torus
point just proved; no unsupported noncancellation of its lower
homogeneous layers is asserted.

## Prior frontier, contribution and review scope

Before this assembly, the independently supported result was NS3059;
its AJT consequence was conditional on dimension eight and omitted
all permanent ranks at least six. Sections above discharge both
missing universal obligations. They yield a dimension-nine theorem,
not a finite search exclusion or another conditional sparsity
corollary. Reconstructing dimension eight or the amplification lemma
alone is not the claimed mathematical advance.

The prior-bound comparison uses the
publisher-deposited Crossref abstract for Zeng--Liu--Ratnavelu,
*Closing the Permanent-Rank Boundary for the Alon--Jaeger--Tarsi
Conjecture*, DOI 10.20944/preprints202608.1194.v1 [2]:

    https://api.crossref.org/works/10.20944%2Fpreprints202608.1194.v1
    Locator: JSON /message/abstract.

It states: "We close the missing boundary: the conjecture holds for
every n <= 2^(p-2)." It explicitly includes every GL_8(F5) matrix.
The abstract's hypotheses are prime p>=5 and a nonsingular matrix.
The bound gives eight, not nine, when p=5. This establishes what
the authors' abstract claims, not a reading or verification of their
proof. The full preprint was unavailable. Dimension eight is proved
above without relying on that unavailable proof.

The bounded primary-source lookup found no competing universal theorem
for every GL_9(F5) matrix. Its additional primary candidate,
arXiv:2608.23647v2, has a proper-extension hypothesis k>=r in its
abstract and does not cover the F5 two-vector case. The completed
independent review also inspected Nagy--Pach's 2026 group-ring paper
and the characteristic restrictions in the 2026 permanent notes
listed in `literature/permanent_rank_sources.md`. It accepted the
dimension-nine theorem as a verified-new, publishable advance over
the strongest located dimension-eight frontier. These are independent
project-review judgements, not a proof that no other result exists
or a claim of journal acceptance.

Yu's original article body was also unavailable. The amplification
and coefficient bridge are proved in `permanent_amplification.md`,
so no unread theorem from that article is a proof dependency.
Neither that bridge nor the dimension-eight reconstruction is claimed
as the new contribution. The result submitted here is precisely
universal dimension-nine AJT over F5.

## References

1. Ben Kisley and Bryan Shader, *Matrices whose permanent rank equals
   half their rank*, Communications in Optimization Theory 2025,
   Article 49, 1--14. DOI: 10.23952/cot.2025.49. Theorem 4.8,
   page 13. Primary PDF: https://cot.mathres.org/issues/COT202549.pdf.
2. Zeng--Liu--Ratnavelu, *Closing the Permanent-Rank Boundary for the
   Alon--Jaeger--Tarsi Conjecture*, preprints.org 202608.1194.v1.
   DOI: 10.20944/preprints202608.1194.v1. The author-deposited abstract
   at the Crossref URL above is used only for the prior-bound
   comparison; the full proof was not obtained.
