# Number-field manuscript application

**Assessment:** The old exact-shear and difference-function application is
supported within its stated hypotheses, conditional on the arithmetic
inputs assessed separately. The unit has only **partial support** for its
entire old claim inventory, because the whole-manuscript theorem and its
remaining reductions have no proof in this draft package. This is neither
a refutation nor an independent certification of that manuscript.

## Source, attribution, and exact scope

The original is OpenAI, *The Margulis--Platonov conjecture over number
fields*, September 23, 2026. The read-only staged source matches
`MANUSCRIPTS.json` revision
`4eaee87548250b2682affda7d05d947c05554bae`, including all 11 listed TeX
files. The README supplies the author/date. Relevant anchors are
`build/sections/characters.tex` lines 1-145 and 333-361, and
`build/sections/introduction.tex` lines 1-29. The old Argus application
is Section 6 of `exact_transitivity/report.md`.

For the selected assertions, k is a number field, L/k quadratic, D a
central division L-algebra of odd degree n>=3, and * unitary. Let E be a
*-stable maximal subfield Galois over L. Let d in E^times have n distinct
L-conjugates t_i, with no t_i equal to any bar(t_j).
The character chi:U(k)->B has finite abelian target, written additively;
no continuity is assumed. The domain consists of b!=0 with
b+b*=a*a for some a in D, including a=0, and
f(b)=chi(1-a b^-1 a*).

`lem:chars-pure-shears` asserts actual nonidentity upper and lower
unipotents supported on each block. `prop:chars-difference` asserts,
for every b with both b and bd in that domain,

    f(bd)-f(b)=chi(bar(d)/d).

The full `thm:main` has substantially different quantifiers: every
absolutely almost simple simply connected k-group G and every abstract
noncentral normal N in G(k) satisfy N=delta_A^-1(W), with W open normal
in the product over anisotropic nonarchimedean places. A calculation for
odd-degree division-algebra unitary characters cannot by itself prove it.

## Matching the supported-shear theorem to the source

Set F=E^{bar}. Then E/F is a separable quadratic extension of number
fields. This F need not be the original ground field k. Theorem A
requires neither that the t_i be conjugates nor that their number be odd,
so the original hypotheses are more than sufficient; none is silently
deleted from the application.

Skolem--Noether gives D as the direct sum of E w_i with
w_i d=t_i w_i. Right multiplication by d consequently has precisely
the parameters used in the E-block matrices. Elements of E^1 are
unitaries in D. The original pair move (a,c)->(a-cd,a-c), followed by
negating the second output, is B_{-1}. Diagonal phase conjugation yields
all B_h. Thus these are actual available transformations, provided the
pair-invariance lemma holds; they are not merely abstract matrices in a
larger unrelated group.

This structural input is explicit, rather than credited to Lean:
the cached author-hosted KMRT *Book of Involutions*, Section 1,
Theorem (1.4), printed p.5, states that an embedding of a simple
subalgebra into a central simple algebra extends to an inner
automorphism. Its hypotheses hold for E inside the central simple
L-algebra D. Apply it to each L-automorphism sigma_i of E to obtain
w_i. They are eigenvectors of the left-E-linear right-d operator
with distinct eigenvalues t_i, hence independent; dim_E(D)=n makes
them a basis. The exact proposition was read in the already retrieved
`additive-generation/sources/kmrt-involutions.txt`, lines 834-837.
The hosted revision is still not identified with a canonical edition.
This standard structural assumption is recorded on both current
application claims as A_SKOLEM_NOETHER.

The explicit proof assessed in the supported-shear unit establishes
the assertion of `C_NF_SHEARS` v1. The original source itself proceeds
from projective density through a normal-subgroup extraction argument.
It does not simply identify density with membership. The alternative
Argus proof therefore does not identify a manuscript error.

## Inspecting the application bridge, not just assuming a label

The old `C_NF_PAIR` v1 deliberately left the preceding identities
outside its bounded certification. They are inspected here by ordered
algebra, independently of any claim that Lean checked them.

**Domain and well-definedness.** If a*a=0, division forces a=0.
If a'*a'=a*a!=0, v=a'a^-1 satisfies v*v=1; the defining m_b values
are conjugate. Expansion of m_b m_b* uses
b^-1(b+b*)(b*)^-1=(b*)^-1+b^-1 and gives 1.
Using ax for x*bx gives the same defining unitary, proving congruence
invariance. These steps require the division hypothesis and an abelian
character, not commutativity of D.

**Sylvester step.** T(e)=ed-d*e is L-linear. Over a splitting field its
eigenvalues are t_i-bar(t_j), all nonzero. Thus T is invertible.
Writing A=a*a and C=c*c, solve T(e)=A-d*C. Taking adjoints shows
T(C-e*)=A-d*C, so uniqueness gives e+e*=C and then
ed+d*e*=A. If e=0, division gives a=c=0. Conversely T has zero
kernel, which is needed when recovering a pair from a given b.

**Pair move and noncommutative identity.** Put b=ed and
z=b*+e-a*c. Without reordering factors,

    z+z*=(a-c)*(a-c),
    zd+d*z*=(a-cd)*(a-cd).

The move is invertible since d!=1: its kernel gives a=c and
c(d-1)=0. Thus its nonzero input has z!=0. Set

    P=ce^-1-ab^-1,  Q=(b*)^-1 z e^-1,
    M=m_b,  N=m_e*,  w=c-a.

Expanding P*P with C=e+e* and A=b+b* gives Q+Q*.
Also Q=(b^-1)*(zd)b^-1, since d b^-1=e^-1; hence
f(Q)=f(zd). The displayed source identities

    Pe=-ab^-1 z+Mw,
    b*P*=z(e*)^-1 c*+w*N

follow directly from the same A,C relations. To check the crucial
three-unitaries identity rather than infer it from commutative
experiments, substitute these two expressions into
1-PQ^-1P*, using Q^-1=e z^-1 b*. The part not containing
-M w z^-1 w*N reduces to

    N+ab^-1(e(e*)^-1 c*+w*N).

The identity c*N=-e(e*)^-1 c* reduces this to MN. Therefore

    1-PQ^-1P*=M(1-w z^-1 w*)N=m_b m_z m_e*.

Applying chi gives f(zd)=f(b)+f(z)-f(e), exactly pair invariance.
All inverses exist by the established nonzero conditions. This checks
the local bridge in prose; it is not a new formal certificate or a
verification of all source-manuscript reductions.

## Transitivity, evaluation, and quantifiers

Once Z U(k)=D is accepted with the arithmetic qualifications of its
unit, the conditional-transitivity proof applies to the actual block
shears above. It gives a constant F_d on nonzero pairs.

For e=(d-bar(d))^-1, e*=-e and
ed+d*e*=1. Taking a=1,c=0 therefore gives m_e=1 and
m_ed=1-(ed)^-1=bar(d)/d. This ratio lies in E^1, so chi is defined
on it. This evaluates the constant with the correct order and sign.

Finally, if b,bd are in the stated domain, choose c,a from their
defining equations. The unique Sylvester solution is e=b. The pair
cannot be zero, since that would put the nonzero b in ker(T).
Thus the conclusion has the claimed "whenever b,bd are in the domain"
quantifier, not merely an identity on pairs constructed in advance.
This recovers `C_NF_DIFFERENCE` v1.

## Claim dispositions and concrete open obligations

| Old claim | Disposition |
| --- | --- |
| C_NF_SHEARS v1 | Supported specialization of the assessed Theorem A. |
| C_NF_DIFFERENCE v1 | Supported application, conditional on the separately recorded arithmetic inputs; the local bridge and evaluation are checked above. |
| C_NF_PAIR v1 | Its original exclusion from machine certification is correct. Its ordered algebra is supported by this handwritten inspection, not by Main.lean. |
| C_NF_MAIN v1 | Unresolved by this evidence; no whole-manuscript verdict follows. |
| C_NF_REMAINING v1 | Explicit open dependency, not an omitted certified theorem. |
| C9000018 v1 | Historical family task, shared with the function-field unit; not a mathematical success claim. |

For the last two mathematical entries, the gap is concrete: the package
has no proof chain from arbitrary (G,N) to this odd-degree unitary
character situation, no certification of the later signature-domain
and cyclic-field steps, no completion of "Continuity and the final
vanishing" in characters.tex, and no verification of the remaining
recurrence, finite-group, exceptional-type, or structural reductions.
The finite-character assertion `thm:no-characters` is stronger than the
difference identity alone. The introduction's further congruence
consequences likewise are not consequences certified by this package.

The formal core, fresh compiler run, and 26-check symbolic replay are
reused only in their algebraic scopes. No independent novelty, full
geometry, continuity, MP theorem, or acceptance is claimed. The strongest
old result is not strengthened here; the improvement is a more explicit
claim-to-evidence and application-fidelity assessment.
