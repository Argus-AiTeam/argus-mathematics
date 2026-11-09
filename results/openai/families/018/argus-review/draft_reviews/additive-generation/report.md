# Existing-draft review: additive generation

**Unit:** `additive-generation`. **Role:** Engineer analysis, not the native
independent Reviewer. **Assessment:** the exact equality is supported by the
draft's argument, with the explicit reconstructions below, conditional on the
accepted standard arithmetic inputs. I found no failed local-to-exact
implication. This is not mechanical closure or independent acceptance.
Novelty remains **unverified**.

## 1. Claim, hypotheses, provenance, and versions

Let k be a number field or a global function field, let L/k be a **separable
quadratic** extension, and let D be a central division L-algebra of **odd degree
n >= 3**, with an involution `*` inducing the nonidentity automorphism of L/k.
Write

    U(k) = {u in D^× : u* u = 1},
    M = Z U(k) = {finite sums of integer multiples of elements of U(k)}.

The exact claim is

    M = (D,+).

This is equality of abstract additive groups, not equality of closures,
linear spans, or multiplicative groups. In characteristic p the integer
coefficients reduce to F_p.

The surrounding original setting includes a star-stable maximal subfield
E Galois over L; in the function-field application E=LF with F/k cyclic of
odd degree, and the original parameter restrictions, including
`d bar(d) not in k`, are retained by the coverage index. None of those
parameter choices is used in this additive lemma. This review does not
weaken the other units' hypotheses.

The old source is `9000018/research/exact_transitivity/report.md`, Section 5,
lines 317–397, Theorem D. Its equality already appears in the staged original
manuscripts as:

* Number-field `build/sections/characters.tex`, lines 282–331,
  `lem:chars-additive-span`.
* Function-field `build/paper/08-characters.tex`, lines 183–249,
  `char:additive-span`.

These are in the September 23 and October 5, 2026 manuscript trees identified
by the index, revision `4eaee87548250b2682affda7d05d947c05554bae`.
Only the additive passages and narrowly adjacent phase/lattice passages were
read for attribution/base-field distinctions; the rest of the manuscripts
was not audited here.

**Classification:** Theorem D is a unified reconstruction of these existing
additive-generation lemmas, not an independently discovered new result.
Its Cayley proof of approximation and geometric linear-span argument make
the arithmetic dependencies explicit and cover characteristic two.
Although parts of the proof do not use oddness or divisionality, no proposed
extension to a larger class of algebras is accepted or registered here.
Nothing in this unit certifies either full Margulis–Platonov theorem.

All eight old `C_ET_ADDITIVE` versions have the **same natural statement**,
including the same equality and denominator-clearing claim:

| Version | Change in dependency accounting |
|---|---|
| 1 | Equality recorded without external assumption entries. |
| 2 | Adds `A_LOCAL_SPLIT`. |
| 3 | Adds `A_LOCAL_ISOTROPY`. |
| 4 | Adds generic `A_FIELD_WA`. |
| 5 | Adds generic `A_SPLIT_PLACE`. |
| 6 | Adds precise `A_FIELD_WA_MILNE`; the generic entry is still present. |
| 7 | Adds precise `A_SPLIT_PLACE_KOSTERS`; the generic entry is still present. |
| 8 | Retires the two generic duplicates in favor of the retrieved propositions. |

This is a dependency clarification, **not eight results**. The pre-assessment
current `R_ADD` versions 1–5 likewise keep one statement while adding the four
source-only assumptions. This review adds judgments to that existing claim,
not a new theorem statement.

## 2. External inputs and actual source retrieval

The detailed proposition readings, short quotations, hypotheses, URLs,
page locators, and attribution comparisons are in
[source_assessment.md](source_assessment.md). Raw PDFs/HTML, extracted text,
HTTP headers, hashes, and actual versions are retained under
[sources/manifest.json](sources/manifest.json).

| Current assumption | Actual source read and comparison |
|---|---|
| `A_FIELD_WA` | Milne ANT **v3.08, July 19, 2020**, Theorem 7.20 and completion paragraph, printed p.114 / PDF p.116. Any field with nontrivial inequivalent absolute values, not just number fields. Matches the inherited excerpt. |
| `A_LOCAL_SPLIT` | KMRT Section 3, (3.1)(2), p.31 / PDF p.49, plus its norm/corestriction definition; Milne CFT **v4.03, August 6, 2020**, III.2.1 and (30), pp.103,105 / PDF pp.112,114. The hosted KMRT revision is not canonically verified. |
| `A_LOCAL_ISOTROPY` | EKM Section 36, definition and Example 36.2(6), pp.161–162 / PDF pp.169–170. The obtained file has TeX metadata 2008-05-01 and PDF-build metadata 2010-04-29; exact canonical book revision unverified. |
| `A_SPLIT_PLACE` | Kosters **arXiv:1404.6345v2**, Theorem 1.1, checked in requested HTML and the same v2 PDF. Full-constant-field hypothesis is essential. The HTML's rendered author date is August 24, 2026, while the v2 PDF says June 28, 2016 and carries the 27 Jun 2016 v2 identifier. |

All required downloads succeeded. The two hosted book PDFs remain
source-only, not silently equated with verified canonical editions.
Kosters introduces Theorem 1.1 as the classical theorem from Rosen,
Theorem 9.13B; it is not presented here as his new error-term result.
The inherited Kosters excerpt and archived literature JSON match the actual
statement, but are not authority by virtue of their old reading labels.

Other elementary/standard facts used explicitly below are: finite-dimensional
algebra base change and semisimplicity for a separable center; the Hermitian
description of split unitary involutions (also checked in the same KMRT PDF,
pp.23–24); nonzero trace for a separable quadratic field extension; density of
local points in nonempty opens of these smooth rational groups; the separating
element criterion for a one-variable function field over a perfect field;
local compactness; and PID lattice/CRT facts. They are explained where used,
not asserted to have been proved by a certificate.

No automatic literature attribution was made. The permitted assumption
judgments are source-reading opinions under `reader:additive-generation`,
distinct from the filer but not native independent acceptance.

## 3. Central coefficients and the function-field base

M is a unital subring: products of unitary elements are unitary, so products
of finite integer sums again belong to M.

In characteristic zero use only `A=Z`, `K_0=Q` initially. It would be
illegitimate to regard M as a Q-module before rational denominators have
actually been obtained.

In characteristic p, a **central** nonconstant norm-one phase is needed.
Let c=F_q be the full constant field of k. For a geometric quadratic L/k,
Kosters 1.1 over c, with identity Frobenius, supplies split places. If L has
larger constants, their degree is two and `L=k F_{q²}`. Apply the same theorem
to the trivial extension k/k over c and take large **even** degrees: these
places split in L. This verifies `A_SPLIT_PLACE` in exactly the scope needed.

At a split place v, write its two extensions as w and bar(w). Field weak
approximation gives `a in L^×` with `ord_w(a)=1`,
`ord_bar(w)(a)=0`. For `r=a/bar(a)`, the valuations are 1 and -1 and
`r bar(r)=1`. Thus r is a scalar unitary element of D. Its trace

    t_0 = r + r^-1

lies in `k ∩ M` and has valuation -1 at v, since its two summands have
different valuations. In particular it is nonconstant and not a p-th power.
The separating-element criterion gives a **finite separable** extension
`k/F_p(t_0)`. L and the center of D are consequently separable over this base.

Use `A=F_p[t_0]`, `K_0=F_p(t_0)`. A is a central polynomial PID contained in M,
so M is an A-module and D is finite-dimensional over K_0.

**Finiteness/base-field distinction:** `F_p[r+r^-1]` is an **infinite**
polynomial ring, not a finite field. Its quotients by nonzero ideals are
finite; k and L are finite over its **fraction field**. It is not necessary
that F_p be the full constant field of k, or that M be finite as an A-module.
In fact the final M=D is not a finite A-module. Nor may an arbitrary phase
from the larger maximal subfield E replace this central r: its trace might
lie only in E's fixed field rather than k and need not act centrally on D.
The draft's explicit choice `r in L^1` avoids that failure.

## 4. Cayley parametrization and weak approximation, also in characteristic two

Choose `theta in L \ k`; separability ensures
`theta-bar(theta) != 0`. On the open of the Hermitian k-vector space
`H={x : x*=x}` where `x+bar(theta)` is invertible, put

    c(x) = (x+theta)(x+bar(theta))^-1.

Since x commutes with the central scalars, `c(x)* c(x)=1`. Conversely, on the
unitary open where `u-1` is invertible,

    x = (u-1)^-1 (theta-u bar(theta))

is Hermitian and inverts this map. One can verify the adjoint directly using
`u*=u^-1`; all rational expressions involved commute with u. There is **no
division by 2** or requirement to choose a nonzero skew scalar. These are
inverse rational maps in characteristic two as well.

The open is nonempty geometrically and locally: the group is smooth,
geometrically connected, and becomes GL_n after splitting the center.
A proper algebraic closed subset cannot contain an analytic neighborhood
of a smooth local point; in this rational setting this also follows from
polynomial nonvanishing in local coordinates. Thus the Cayley open is dense
in every local analytic group, including in positive characteristic.

Given finitely many local unitary targets, first approximate them by points
of these opens, pull back to H, apply field weak approximation coordinate by
coordinate, and map back. Invertibility is open, so the resulting global
parameter is admissible. This proves weak approximation for U itself,
rather than assuming an unrelated simply connected approximation theorem.

## 5. The local closures really are the full local algebras

Fix a finite prime pi of A, let K be the completion of K_0, and let
`C=closure(M)` in `D_K`. Since A is dense in O_K, closed additivity and the
A-module property imply that C is an O_K-module. Separability gives a
product of finite local field centers, so D_K is a semisimple K-algebra.
The preceding simultaneous approximation puts the **whole product** of
unitary groups above pi inside C.

### 5.1 The divisible part is an ideal

Set `W=intersection_(r>=0) pi^r C`. Every term is closed; W is O_K-stable and
stable under division by pi, hence a closed K-vector space. Global unitary
elements preserve C and W on both sides because M is a ring; approximation
and closedness extend that preservation to all local unitary elements.

Their K-linear span is D_K. Here is a precise justification of the draft's
compressed independent-factor assertion. Over an algebraic closure, the
unitary group has independent pairs

    (g_i,g_i^-t),  g_i in GL_n.

If a linear functional on the ambient product vanished on all these points,
varying one g_i and replacing it by `lambda g_i` would make
`a lambda + b lambda^-1` constant in lambda. On an infinite field the three
Laurent functions `1,lambda,lambda^-1` are linearly independent, even in
characteristic two. Therefore both coefficients and that constant vanish.
Invertible matrices span each matrix algebra, so the functional is zero on
every factor. Local points are Zariski dense by the Cayley open, which
descends this conclusion to K. Stability under these spanning elements
makes W a **two-sided ideal**.

Importantly, the K-span assertion by itself would not imply `C=D_K`,
because C is initially only an O_K-module. The following unboundedness step
is indispensable.

### 5.2 Nonsplit finite places: corestriction, then Hermitian isotropy

At a nonsplit place let F=k_v, E=L_w. They are nonarchimedean local fields
with E/F separable quadratic, possibly ramified and possibly characteristic
two. KMRT gives `Cor_{E/F}([D_w])=0`. Milne's **corestriction** identity
`inv_F Cor = inv_E` makes `[D_w]=0`; thus `D_w=M_n(E)`.
The restriction formula with its degree factor is not a substitute.

The involution is adjoint to a nonsingular n-dimensional Hermitian form h.
Use the 2n-dimensional F-quadratic form `q(v)=h(v,v)`. Its polar form is
`Tr_{E/F} h(v,w)`, nondegenerate by separability and nonsingularity.
There are no orderings at these fields, so EKM's barred-u bound 4 applies.
As `2n>=6`, h has a nonzero isotropic vector, also in characteristic two.
A hyperbolic plane and its reciprocal diagonal scalings give an unbounded
sequence in this local unitary group.

Take such a sequence and identities in all other components of the product
in C. Normalize by `pi^{r_j}`, `r_j -> infinity`, into a compact annulus in
the finite-dimensional K-space, and extract a nonzero limit. All other
components tend to zero. For each fixed r the normalized terms eventually
belong to `pi^r C`, so closedness puts the limit in W. Hence W meets this
simple factor nontrivially.

### 5.3 Split finite places

At a split place the two simple algebras may themselves be nonsplit matrix
algebras over division algebras; no splitting assertion about either is
needed. The involution exchanges them, and central reciprocal scalars
`(pi^-j,pi^j)` are unitary. After multiplication by `pi^j` their limit is
`(1,0)`, with zero in all other components; reversing them gives `(0,1)`.
Both limits belong to W by the same divisibility/closedness argument.

A two-sided ideal that meets a simple factor nontrivially contains it.
Every simple factor therefore lies in W, proving

    W = D_K, hence C = D_K.

This establishes local density, not yet abstract additive generation.

## 6. Global span, a full lattice, and exact denominator clearing

If `S=K_0 M` were a proper K_0-subspace of D, its scalar extension to K
would be a proper closed subspace containing C. Since `C=D_K`, this is
impossible. Select a K_0-basis from M; its A-span is a full free A-lattice
`Lambda ⊂ M`. This does not assert an unproved integrality or finite-module
property for M.

For `x=pi^-j lambda`, `lambda in Lambda`, `j>=1`, local density gives
`a in M` such that `a-x` belongs to the completed lattice at pi.
In coordinates relative to a basis of Lambda, a has only finitely many
denominators at other primes. Let N be their product with sufficient
exponents, excluding pi. Then `(N,pi)=1`. CRT chooses

    q in A,  q=0 mod N,  q=1 mod pi^j.

At pi, `q(a-x)` is integral in the lattice. At every other prime rho,
both qa and qx are integral: q clears a's denominators and x has none
there. The intersection of all these finite-prime local lattices inside
`K_0 Lambda` is exactly Lambda, coordinatewise over the PID A. Thus

    qa-qx in Lambda,       (q-1)x in Lambda.

The **exact identity**

    x = qa - (qa-qx) - (q-1)x

puts x in M, since `qa in M` and both subtracted terms are in Lambda.
For `j=0` membership is immediate. Partial fractions over the PID A express
every element of `K_0 Lambda` as a finite sum of these prime-power pieces
and lattice elements. Consequently `D=K_0 Lambda ⊂ M`, as claimed.

**Number-field rational/phase denominators:** a rational parametrization of
a unitary phase is not permission to divide in M, and a Q-linear span is
not exact additive membership. The proof never makes that inference.
Here `A=Z`; N is an integer prime to the chosen rational prime, and CRT
produces an integer q, prime to that prime and congruent to 1 modulo its
required power. It is this identity that supplies each rational
denominator, including powers of 2. No rational scalar-unitary phase is
assumed to equal `1/p`.

**Function-field denominators:** the same argument takes place over
`F_p[t_0]`, not over the full field k and not over a claimed finite ring.
Polynomial parts are already in the lattice, so no additional condition at
the infinite place of K_0 is needed. No archimedean integrality condition
is needed in the number-field case either.

This completes the decisive exactness step. Being dense at every place
alone would not have completed it.

## 7. Focused diagnostics and evidence limits

The authored [identity_checks.py](identity_checks.py) was run with
`$WORKSPACE/argus-latest/.venv/bin/python`; its reproducible output
is [identity_checks.json](identity_checks.json).

* Over F_4/F_2, all 512 Hermitian 3-by-3 matrices were enumerated. The 368
  admissible Cayley cases satisfied unitarity and the stated inverse;
  144 singular denominators were excluded, not incorrectly inverted.
* The underlying 6-dimensional quadratic form had polar rank 6; its
  trace-polar identity was checked on all 4,096 pairs of vectors. There
  were 27 nonzero isotropic vectors in this finite model.
* Evaluations of `1,lambda,lambda^-1` were independent in characteristic
  two. A rational CRT fixture with `p=5`, `j=2`, `q=4851` satisfied the
  exact clearing identity with integral correction terms.

These are finite **identity diagnostics** in a split algebra, not a
counterexample/test of the global division hypotheses, a proof of a local
u-invariant bound, or a certification of Theorem D. The proof assessment
above supplies the general argument. **No Lean proof covers this theorem.**
The algebraic formal-core certificates cannot certify its arithmetic or
the abstract subgroup equality.

## 8. Failed/inapplicable approaches and remaining obligations

* Zariski density, local additive density, or a field-linear span alone
  does not imply membership in M. The ideal and CRT steps above are the
  actual repairs to those insufficient shortcuts.
* The nongeometric shortcut applying Chebotarev directly to L/k while
  omitting the full-constant-field condition is invalid. The two-case
  argument above fixes it; neither F_p nor the constants of L may be
  substituted blindly as the theorem's base constants.
* Lanski's *Unitary Invariance in Algebraic Algebras* is only an inherited
  inaccessible lead (old AMS 403 / JSTOR blockage). No proposition from it
  was obtained or relied on here; its inaccessibility is not a mathematical
  verdict.
* The inherited Sethuraman–Sury Theorem 1.1 concerns multiplicative
  commutators over a function field over a number field, not this additive
  equality over a global field. It supplies no missing exactness step.
* The old confused Serre-book suggestion was not used. Neither unit-rank
  nor degree-zero divisor-class finiteness, needed in adjacent shear
  arguments, is an additional dependency of this additive theorem.

No fatal mathematical gap remains in this reconstructed proof **assuming
the stated standard inputs**. The concrete limits still outstanding are
verification/acceptance obligations, not a fabricated failed implication:

1. The exact canonical editions of the hosted KMRT/EKM PDFs are unverified;
   their actual local proposition readings are retained source-only.
2. The four arithmetic assumptions are supported source-reading inputs,
   not mechanically proved results or automated literature attributions.
   If any is not accepted, the conditional proof stops at precisely its
   use described in Sections 3–5.
3. There is no formal proof of this equality; the finite diagnostics cannot
   discharge that obligation.
4. Native Host-invoked independent review and any family-level completion
   decision remain pending. No new novelty search was authorized or made.

The existing claim `R_ADD` receives an Engineer `supports` judgment for this
conditional argument; the four assumptions receive the permitted source
reading judgments. [ledger_judgments.json](ledger_judgments.json) preserves
the actual command receipts. After those ledger changes, both official
checkers run at the exact campaign root; actual return codes and output
are in [validation.json](validation.json) and summarized in
[verdict.json](verdict.json). A missing current `research/PROOF_GRAPH.json`
is outside this unit's write boundary and is not repaired or represented
as a successful graph check.
