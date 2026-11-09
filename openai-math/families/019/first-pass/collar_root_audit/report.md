# All-sheet collar-root audit

## Exact target and scope

The target is `lem:etale-collars` in the October 6, 2026 manuscript,
`build/sections/04-tame-roots.tex`. The ground field is the algebraic closure
of a finite extension of Q_p, completed to Omega; ell is an odd prime
different from p. For every smooth proper connected curve of genus at least
two and every permitted finite family of disjoint coordinate disks, the
claim asks for one connected finite etale cover and one concentric open
subcollar in each disk such that each coordinate has an analytic ell-th
root on its *entire* inverse image.

The audit must include off-skeleton points. A construction on selected
sheets, or only on the skeleton, is not the assertion. This component does
not by itself verify the section conjecture or the subsequent patching
argument.

## Prior state

The supplied ledger contained only the open campaign objective, with no
proved collar claim or retired route. The inherited Wiki index had no
matching collar or section-conjecture entry. The strongest relevant prior
result is therefore the manuscript's own proof of this lemma. The
improvement here is an explicit proof of its all-sheet implications,
primary-source hypothesis matching, and a universal formal certificate
for the compactness step and ramification arithmetic. This is not a
claim of a new analytic theorem absent from the literature.

## Result and certification boundary

**Verification, not refutation.** The exact lemma follows from the
resolution and tame-lifting results cited by the manuscript. Neither
finiteness of the model morphism nor tameness of the resolution cover
is needed. The proof below treats every inverse sheet, including every
smooth-point disk tube. No missing hypothesis or counterexample to this
lemma was found.

The universal topological exclusion theorem and the integer identities
are formalized in `Main.lean`. Analytic geometry, existence of residue
covers, and the two external lifting/resolution theorems remain
mathematical inputs, not machine-verified conclusions. The finite
Jacobian computation is only a separately replayable bridge example;
it is not evidence for a universal analytic existence claim.

Independent Reviewer assessment of this proof, the source attributions,
and statement fidelity is still required. This result alone neither
certifies the campaign's publishability/novelty gate nor proves
`L_ell` is contained in `H`: that proposition additionally needs the
subsequent patching and point-transfer arguments. It says nothing about
roots of order divisible by p.

## Primary-source hypothesis audit

The PDFs and their `pdftotext -layout` transcriptions are in `sources/`.
They were obtained directly from the URLs in the manuscript bibliography.
The dated title pages were checked for the two undigitally versioned
author PDFs.

| Input actually used | Exact primary-source location | Hypothesis match |
|---|---|---|
| Resolution and model domination | Mochizuki--Tsujimura, RIMS Preprint 1974, **March 30, 2024**, Theorem A (printed p. 4) and Proposition 2.4(iv) (p. 50) | Descend the curve and the modified model to a finite extension of Q_p. A proper genus-at-least-two curve is hyperbolic. Take Sigma to be **all** primes: it contains p and has cardinality at least two. The residue field of the ground field is finite. The model is proper, flat, and normal. Proposition 2.4(iv) then supplies a stable source model mapping to this very model after a finite extension. It does **not** assert the model map is finite. |
| Tame lifting with loops and full inverse skeleton | ABBR, **arXiv:1303.4812v3**, Theorem 7.7 (p. 45); Definitions 2.19, 2.21, 4.25, 4.31; Section 4.27 | Supply all marked fibres, a finite harmonic graph map, tame residue maps, zero augmented ramification, and lengths in the value group. Use **no punctures**. Definition 4.31 then excludes all algebraic branch points. Definition 4.25 supplies equality of the *whole inverse skeleton*, not just inclusion. Theorem 7.7 allows loop edges; no hidden loop-free assumption from Theorem 7.4 is being imported. |
| Divisibility and nonzero prime-to-p torsion of Jacobians | Milne, *Abelian Varieties*, **January 2, 2022**, Proposition 8.1, Theorem 8.2, Remark 8.4 (pp. 12--14) | The residue field is algebraically closed, ell is prime to its characteristic, and the Jacobian has positive dimension exactly when its curve has positive genus. Multiplication by ell is surjective, and positive genus supplies nonzero ell-torsion. |
| Unit factorization | BPR, **arXiv:1404.0279v1**, Proposition 2.2(1) (p. 4), Lemmas 2.12--2.13 (p. 7) | Proposition 2.2 is stated on a **closed** strict annulus. It is not being quoted as an open-annulus theorem. The nested-annulus argument below supplies the open statement and uniform convergence on compact subannuli. |
| Reduction and semistable tubes | ABBR v3, Definition 3.8, Section 3.11, Lemma 5.17; functorial reduction in Section 5.11 | There are finitely many vertex and node tubes, but generally infinitely many smooth-point disk tubes. The proof below does not assume the latter family is finite. |
| Compactness, analytification, and type-2 points | Temkin, *Introduction to Berkovich analytic spaces*, **Jussieu 2010 preliminary lecture notes**, Fact 2.2.6(i), Definition 2.3.7, Exercise 2.3.8, Definition/Exercise 2.3.9(2), Definition 4.2.13(ii), Example/Exercise 4.2.14(iv), Fact 5.1.5 | Proper algebraic analytifications are compact and separated, hence Hausdorff. Closed annuli are affinoid and compact. The Abhyankar inequality and the type-2 definition give value-group rational rank zero; divisibility of the ground group gives equality of value groups. |

Proper analytic compactness/Hausdorffness, the value-group
characterization of type-2 points, the semistable local equations, the
identification of the Jacobian with degree-zero line bundles, and
elementary finite-etale base change are the usual foundational inputs.
They are distinguished from the formal core rather than silently
represented by axioms in Lean. The local model calculations and the
precise uses of these inputs are given below.

The irrationality and compactness hypotheses in the formal core are
essential, not decorative. Without irrationality, the one-point compact
space with N empty and w=0 contradicts interval capture at a=0.
Without compactness, take X=Q in R, N empty, and w the inclusion:
no interval about an irrational a avoids its rational image. Neither
example satisfies the complete manuscript construction; they refute
only weakened substitutes for its compactness step.

### 1. Units on the whole disk or annulus

Let A be an open annulus with coordinate S and let u be an analytic unit.
On a circle of radius rho in the ground value group, the Laurent Gauss
norm is multiplicative. Normalize u and its inverse to norm one.
Their reductions are inverse units in the Laurent polynomial ring over
the residue field, so the reduction of u is a monomial: exactly one
Laurent term dominates.

The dominating exponent cannot change inside A. On a compact subannulus
only finitely many terms can compete for the maximum. A transition
would force equality of two distinct monomial norms. Since coefficient
valuations and the value group are rational, the transition valuation
would be rational too, contradicting uniqueness on that circle.
Thus one Laurent term c*S^d dominates everywhere, including at
irrational radii; at any fixed radius convergence on a slightly larger
compact subannulus makes the maximum attained. It follows that

    u = c*S^d*(1+h),       c != 0, d in Z, |h(x)| < 1 on all of A.

The disk argument uses reductions in the polynomial ring, whose units
are constants, on nested closed disks. It gives constant norm for a disk
unit. Evaluation at a rational point shows that this norm lies in the
ground value group.

Since ell is prime to p, 1/ell is p-adically integral and the binomial
coefficients for `(1+h)^(1/ell)` are integral. For each fixed coefficient,
approximate 1/ell by nonnegative integers in Z_p; the corresponding
integer binomial coefficients converge to it and Z_p is closed. On every compact
subannulus the continuous norm of h has maximum strictly below one, so
the series converges uniformly. These functions agree on overlaps
because they are the same series. Algebraic closedness gives a root
of c. Therefore a root of S gives a root of every u, with **any integer
d, including negative d**. More precisely u itself has an ell-th root
if and only if ell divides d: sufficiency follows from this
factorization, and necessity follows by factoring a root and comparing
the unique Laurent slopes.

### 2. Residue covers with all marked fibres present

Let D be a smooth proper connected residue curve and P,Q distinct marks.
Surjectivity of multiplication by ell on its Jacobian supplies a
degree-zero divisor E for which P-Q+ell*E is principal, say div(f).
At P and Q its orders are respectively 1 and -1 modulo ell, while every
other order is zero modulo ell. The Kummer extension z^ell=f therefore
has degree ell (f is not an ell-th power), is cyclic and connected, is
totally tamely ramified over P,Q, and is unramified elsewhere.
Every other mark has ell distinct preimages. Tame Riemann--Hurwitz gives

    2*g(D')-2 = ell*(2*g(D)-2) + 2*(ell-1),    hence g(D') = ell*g(D).

If g(D)>0, choose a line bundle L of exact order ell. A trivialization
of L^ell makes the usual algebra `sum_(j=0)^(ell-1) L^j` a finite
etale cyclic cover. It is connected: a nontrivial degree-zero line
bundle has no global sections, so this proper cover has global
functions equal to the residue field, not a product of fields.
All marks again have ell distinct preimages. Its genus satisfies
`2*g(D')-2 = ell*(2*g(D)-2)`.

These are actual residue-curve maps, not just numerical ramification
profiles. Thus no unaddressed Hurwitz existence condition is being
passed to ABBR.

### 3. Stable node roots, including separating edges

First let e lie on a simple circuit of the stable skeleton. A loop is
allowed: its two incident directions are two distinct marked points on
the same residue normalization. At each circuit vertex use the cover
from Section 2 ramified at precisely its two circuit marks. Elsewhere
use ell identity copies of each residue curve.

For each circuit edge put one edge above it, with factor ell and
length divided by ell. For every other edge put ell edges of factor
one, matching all the unramified marked fibres at both ends. This
includes chords and noncircuit loops. Each circuit vertex has local
degree ell in **every** direction; each identity-copy vertex has local
degree one. Every point over every mark has an incident edge end, as
Definition 2.19 requires. Lengths remain rational.

The residue ramification contribution `2*(ell-1)` is exactly the sum
of the two circuit-edge contributions, so augmented ramification is
zero. At a circuit vertex the new valence is `2+ell*(val-2)` and

    2*(ell*g)-2 + (2+ell*(val-2)) = ell*(2*g-2+val) > 0.

The cover is connected. A vertex outside the circuit lifts a path
to the circuit and ends at the single lifted circuit vertex over its
endpoint. Identity-copy vertices therefore do not create isolated
sheets. ABBR Theorem 7.7 now lifts the data over the **fixed curve**.
There are no punctures, so the lift is finite etale.

For a separating e, cut its interior and retain the two boundary
marks. Each side contains a circuit or a positive-genus vertex:
otherwise a genus-zero tree with N>0 vertices would have total valence
`2*N-1`, including the boundary half-edge, while stability requires
at least `3*N`. These inequalities are inconsistent.

Make a connected degree-ell unramified covering of each side. If the
side contains a circuit, use a connected cyclic topological graph
cover, with identity residue maps. If it has a positive-genus vertex,
use that vertex's connected etale residue cover from Section 2 and
ell identity copies elsewhere, matching every marked fibre.
In the latter case all lifted paths to the distinguished vertex end
on its single source vertex, proving connectedness. Each covered side
has exactly ell preimages of its boundary mark.

Glue those marks pairwise to obtain ell factor-one edges over e.
After deleting any one of these edges the two connected covered
sides remain joined by another. Hence **every** edge over e is now
nonseparating. The residue maps are unramified, all edge factors
are one, and augmented ramification vanishes. At a vertex of local
degree d the stability weight is multiplied by d, so this
triangulation is still stable. Lift by ABBR.

Apply the nonseparating construction to every edge over e, and take a
connected component of the finite fibre product of the resulting
covers. It dominates each factor: its projection to a connected
factor is nonempty, finite etale, and has open and closed image,
hence is surjective. Thus every previously constructed root survives.
This also handles any finite family of original node annuli.

#### Why this gives entire annuli, not only skeleton roots

For a tame lift g the inverse-skeleton equality is part of ABBR
Definition 4.25. An off-skeleton open ball upstairs cannot map to the
base skeleton. Its connected image lies in one complementary base
ball. By continuity its unique attachment point maps to that ball's
unique attachment point. Retractions therefore commute on all these
balls, as well as on the graph. Consequently, if e is the open target
edge, `g^(-1)(tau^(-1)(e))` is exactly the disjoint union of the
annuli corresponding to the graph edges above e.

On each factor-ell inverse annulus the pulled-back target coordinate
has Laurent exponent +ell or -ell. Section 1 supplies its analytic
root on that **whole annulus**, including its attached open balls.
For the factor-one bridge precover the original coordinate pulls back
to a unit; rooting its new source coordinate then roots this unit by
Section 1. There are no additional inverse disk components left
unaccounted for in this tame-lift step.

### 4. Universal all-sheet capture for a model morphism

Here f may be wild. Assume only that a finite cover f:Y0 -> C extends
from a stable source model to a semistable target model. Let A be a
target node annulus with coordinate t. Let N be the union of **all**
source node tubes whose nodes map to the target node. This is a finite
union of open annuli; every one maps into A, by functorial reduction.

Choose irrational a strictly between the additive endpoint valuations
of A, and rational alpha,beta with

    endpoint_lower < alpha < a < beta < endpoint_upper.

Let K be the closed annular window `alpha <= v(t) <= beta`, and put
X=f^(-1)(K), with its subspace topology. Proper analytic compactness
makes X compact; the union N intersected with X is open in X.
The function w=v(f^*t) is finite and continuous on X.

Every x in X outside N has rational w(x). Indeed:

1. If x reduces to a component generic point, it is the corresponding
   type-2 model vertex. Its completed residue field has the ground
   value group, so w(x) is rational.
2. If x reduces to a smooth closed point q, then q maps to the target
   node. Its **entire open disk tube** maps into A, not merely the
   selected point x. The pulled-back t is a unit on that disk.
   Section 1 makes its norm constant in the ground value group, so
   w(x) is rational.
3. If x reduces to a node, reduction compatibility forces that node
   to map to the target node. Then x is already in N, contrary to its
   selection.

For completeness, type-2 rationality here does not follow merely from
the word "vertex": type 2 has value-group rational rank zero over the
ground group. That group is divisible, and is a subgroup of the real
additive value group. A torsion extension within the reals of a
divisible subgroup is trivial. Hence its values really are rational.

The closed subset X minus N is compact. Its continuous image F under
w is compact and thus closed in the reals, and contains only rational
numbers. In particular a is not in F. Choose rational

    alpha < q_minus < a < q_plus < beta

inside an open interval disjoint from F. Then **every** point of Y0
whose t-valuation lies between q_minus and q_plus belongs to N:
it first belongs to X because that interval lies inside the closed
window, and then cannot belong to X minus N. This is exactly
`CollarRootAudit.rational_collar_capture`.

The radii, with the necessary order reversal, are

    r = p^(-q_plus) < R = p^(-q_minus).

They are in abs(Omega*) because q_minus,q_plus are rational.
The resulting concentric collar A' is contained in A and satisfies
`f^(-1)(A') subset N` on the **whole proper analytic curve**.
There was no finiteness assumption on the family of smooth disk tubes,
and no finiteness assumption on the model morphism.

### 5. Applying capture to every prescribed disk

Descend C and the finitely many algebraic points b_i to a finite
p-adic field extension. After stable/semistable reduction and a further
finite extension, the b_i are disjoint smooth sections. In an integral
local parameter u_i at such a section, repeated blowups produce a
chain of node annuli

    |pi|^(j+1) < |u_i| < |pi|^j.

On a sufficiently small disk t_i/u_i is an analytic unit, hence has
constant norm c_i in abs(Omega*). Thus these are also concentric
t_i-annuli, with both radii multiplied by c_i. Taking j large puts
them inside the original B_i. Only the curve, points, parameters u_i,
and finite modifications need descent; no hidden descent hypothesis
on an infinite analytic power-series expression for t_i is needed.
The resulting proper semistable model is normal, as is also seen
locally from the node equation xy=pi^m, and need not be stable.
Forget the sections as markings.

By the precise RNS input above, there is a connected finite etale
cover with a **stable** model mapping to this modified target model,
after finite extension. Split the reduction and choose a geometric
connected component. Base change to Omega gives f:Y0 -> C_Omega with
the required model morphism. The stable source has genus at least
two, since a connected degree-d unramified cover has
`2*g(Y0)-2=d*(2*g(C)-2)>0`.

Apply Section 4 separately to the finitely many target node annuli.
For each i it gives A_i' and a finite union N_i of source stable node
annuli such that `f^(-1)(A_i') subset N_i`. On every annulus in N_i,
the pullback of t_i is a unit. Apply Section 3 simultaneously to all
the annuli in all the N_i, obtaining one connected finite etale
g:Y -> Y0 on whose full inverse images their source coordinates have
ell-th roots. Section 1 then gives roots of every f^*t_i on
`g^(-1)(N_i)`. Restricting them gives roots on

    (f o g)^(-1)(A_i') subset g^(-1)(N_i).

Different node tubes are disjoint, so the roots chosen on their
inverse images require no compatibility gluing. The composite
Y -> C_Omega is connected and finite etale. These are precisely all
the quantifiers and conclusions of `lem:etale-collars`.

## Reproducible evidence

`Main.lean` proves a universal compact-space theorem rather than a
finite approximation to it, and universally verifies the arithmetic
used in the circuit and separating-edge constructions. Its separate
statement-fidelity document records exactly the unformalized bridges.
The authorized `lean_evidence verify --claim C9000019-COLLAR-CORE`
command creates the actual compiler record and a source-bound archive.

`jacobian_payload.json` is the ell=3 separating-edge example after
contracting each connected covered side to one vertex: three distinct
parallel edges. The three two-edge cycles cover each edge exactly
twice. The typed Jacobian result records server 0.14.0, protocol
2025-11-25, the exact payload, and the successful output. This
illustrates, but does not replace, the universal deletion argument
in Section 3. `verify.py` independently reconstructs its incidence,
cycle multiplicities, connectedness after each edge deletion, and
the accompanying exact arithmetic.

The exact certificate explicitly separates those finite computations,
the source-bound Lean theorems, the external analytic inputs, and the
unperformed independent review. It does not declare this component
to be a counterexample, a novel publishable result, or a proof of
the section conjecture.

The completed replay returned Lean exit code 0, an empty proof-hole
list, a successful axiom audit, and a recorded mechanical certificate
for `C9000019-COLLAR-CORE`; its ledger status is `closed_kernel`.
Both official structural checks returned 0 at the campaign root.
The full analytic claim remains `supported` by the Engineer's proof,
not kernel-closed. All six external-source attributions and the
statement-fidelity reading still await independent Reviewer assessment.

Run the complete local replay from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/collar_root_audit/verify.py
```

This replays the finite checks, performs a real Lean 4.31.0 compile
through the authorized `lean_evidence verify --claim` entry point,
checks its source/fidelity-bound archive, runs both campaign-local
official checks, and generates `exact_certificate.json`. Missing tools,
compiler failures, proof holes, failed ledger checks, and adapter
non-results are errors, never success-shaped substitutes. It does not
re-run the remote Jacobian operation: it independently replays the
preserved typed result.
