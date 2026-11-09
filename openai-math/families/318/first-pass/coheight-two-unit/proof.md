# Ordinary coheight-two coefficient audit

## Scope and comparison with the reviewed result

The live question is Proposition `prop:constant-module` of the generic-prime
manuscript, at p=5, n=3, t=1, m=2. Here P_3 is the unit group of the maximal
order in the invariant-1/3 division algebra over Q_5. The coefficient is the
literal algebraic connected-marking union B_conn,G, G=GL_2(Z_5), with common
finite frame level and pole bound on each compact cochain source. Completion,
perfection, a dimension count, and a change of the specified xi_i are not
substitutes for the requested assertion.

The previously independently reviewed canonical kernels beta_1^j, 13 <= j <= 16,
in degrees 494, 532, 570, 608 remain mathematically correct. Their proof and
compiler evidence are unchanged. They are **known results**, not an original
contribution of this campaign.

The primary comparison source is *Weak chromatic splitting fails at n=p for
every odd prime p*, proof produced by Claude, written up and verified by
Agnes Beaudry and Tomer Schlank, hexagon:2610.00138v1. The source PDF and its
layout-preserving extracted text are archived at
`research/literature/beaudry-schlank-weak-csc.{pdf,txt}`.
Corollary 2.5 explicitly treats

    p >= 5, p <= n < sqrt(2)(p-1), n^2 < 2j <= 2(p-1)^2.

Together with Lemma 2.1 and Theorem 2.6 it gives the actual canonical-map
kernels, not merely an upper-filtration estimate. At p=n=5 the inequalities
are exactly 25 < 2j <= 32, hence j=13,14,15,16. The broader height window and
the whole power interval therefore also predate the proposed strengthening.
In particular this window does NOT include height six at prime five.
The source was opened and these propositions were read; a search-engine
summary incorrectly conflated this paper with the staged OpenAI manuscript
and is not evidence for the comparison.

## Exact target

Choose a finite field k satisfying the manuscript's Honda-definition
conditions and [k:F_5] prime to 5; k=F_(5^6) is an admissible example.
The target is the specified unital cup map

    exterior_k(e_1,e_2) -> H_cts^*(P_3,B_conn,G),
    e_1 |-> xi_1 * 1, e_2 |-> xi_2 * 1,
    degree(e_1)=1, degree(e_2)=3,

and the vanishing of the action of the specified xi_3. This target is not yet
proved or refuted in this note. The results below are an all-degree
group-cohomological reduction and a conditional unit criterion, not a
certificate for the ordinary coefficient theorem.

## 1. Central contraction in every degree

Let H be a topological group, z a central element, and M a continuous
k[H]-module on which z acts by a scalar lambda, with lambda-1 invertible.
Use continuous equivariant homogeneous cochains:

    C^q(H,M) = {f:H^(q+1) -> M : f(hg_0,...,hg_q)=h f(g_0,...,g_q)}.

There is a contraction of this entire cochain complex, not just of its
finite-dimensional approximations. On the homogeneous bar chains put

    P[g_0,...,g_q]
      = sum_(j=0)^q (-1)^j
        [g_0,...,g_j,zg_j,...,zg_q].

The boundary satisfies

    boundary P + P boundary = [zg_0,...,zg_q] - [g_0,...,g_q].

To check the identity in arbitrary degree, delete a vertex strictly before
or after the repeated transition vertex. Its term cancels the corresponding
term in P boundary, with the opposite sign. The two deletions at a transition
cancel those at the adjacent transition. Only the all-z and all-identity
end faces remain, with signs + and -. This also proves the formula in
degree zero, where the boundary out of a single vertex is zero.

Centrality makes P equivariant for the diagonal left H-action. The maps
of profinite sources in its finite sum are continuous. Transposing P
therefore gives a continuous cochain homotopy h with

    delta h + h delta = (lambda-1) id.

Multiplying h by (lambda-1)^(-1) contracts the complex. In degree zero
this says that a fixed vector must be zero. No finite cohomological
dimension, degeneration assertion, completion, or infinite averaging
is used. The same formula works on a stipulated finite-stage,
bounded-pole cochain complex whenever these finite coefficient maps are
defined there: a finite sum uses one common stage and pole bound.

### Application to the prescribed proper support coefficients

For t=1,m=2 choose z=[2] I_2, where [2] is the order-four Teichmuller
lift of 2 in Z_5. This is central in G=GL_2(Z_5).
It fixes all rational planes and flags. In a term whose smallest plane
has dimension r, the manuscript's compact orientation has scalar
weight -r. The **single** prescribed volume line has scalar weight +2.
There is no translation Ext factor at t=1. Thus the scalar is

    lambda_r = 2^(2-r) in F_5.

For r=0 it is 4, with (lambda_r-1)^(-1)=2. For r=1 it is 2,
with inverse 1. The preceding explicit contraction kills both proper
plane terms in all group-cohomological degrees. For r=2 it is 1:
the ambient line is not killed. In fact its full G-character is
det^(-1) det = 1, not merely a trivial central character.

Consequently, **for the stated finite support incidence resolution with
these orientations**, its ambient edge becomes an equivalence after
R Gamma(G,-). This proves the proper-term elimination needed in
`lem:weight-vanishing` at the selected parameters without using the
Sorensen spectral sequence or a parabolic root bound.

The assertion is conditional on the specified support presentation
being the one compared with the literal ordinary coefficients. It
does not construct that ordinary comparison. In particular it would
be incorrect to identify the resulting ambient line with the original
coefficient unit solely from this contraction.

## 2. A finite sign and product cross-check

The four-dimensional graded leading-symbol Lie model for a pro-5
Iwahori in GL_2 has dual exterior generators e,f,h,z and differential

    d e = d f = d z = 0,       d h = -e f.

Their diagonal-torus weights are (-1,1),(1,-1),(0,0),(0,0).
Its torus-invariant subcomplex has ordered basis

    1; h,z; ef,hz; efh,efz; efhz.

The only nonzero differentials in this basis are

    h |-> -ef,                hz |-> -efz.

It therefore has Hilbert polynomial 1+s+s^3+s^4.
Representatives 1,z,efh,zefh have exterior multiplication, including
zefh=-efhz. The ordered top pairing is perfect. The script constructs
the whole 16-dimensional exterior complex, checks the differential
and its Leibniz signs, extracts the actual finite-torus invariants,
computes kernels modulo images, and checks the product, rather than
only comparing dimensions.

This is a finite Lie-model calculation. It is not by itself a
calculation of the infinite group G, much less of P_3 with ordinary
B_conn,G. The independent primary-source reader verified the relevant
constant-group comparison in Dotto--Le Hung,
arXiv:2507.13500v1, Theorem 1.1 and Propositions 5.5, 5.7, 5.12.
Here the ground field is Q_5, e=f=1, h=a, and 5>a+1 for a=2,3.
The division calculation is for **full** units and initially uses
F_(5^a), not F_5; finite coefficient extension and descent of homogeneous
exterior generators are needed. Neither that source nor this finite
complex supplies the nonconstant ordinary coefficient comparison.

The coefficient descent for the constant input is elementary. A finite
projective resolution for each of the compact groups in these ranks
shows that constant cohomology commutes with finite extension of F_5.
Its indecomposable quotient therefore has one F_5-dimension in each
of degrees 1,3 for rank two, and 1,3,5 for rank three, and no others.
Choose homogeneous lifts of those indecomposables over F_5. After
extension to the source's coefficient field they generate the exterior
algebra: in a finite connected graded algebra, generation can be
checked in the indecomposable quotient by induction on degree.
Their odd squares vanish in characteristic five, so they define an
exterior-algebra map. After extension it is a surjection between spaces
of the same finite dimension and hence an isomorphism. Faithfulness
descends the isomorphism. Extension to the admissible k is then
immediate. This proves existence of a constant exterior presentation;
it does not identify these chosen lifts with the specified xi_i or
prove their action on B_conn,G. Those distinctions are precisely why
`C318CO2ACTION` remains open.

## 3. Conditional criterion for the actual unit

Let A=exterior_k(a_1,a_2), with degrees 1,3 and top degree 4.
Let M be a finite graded unital k-algebra obtained as the actual
ordinary coefficient cohomology. Suppose that a faithful flat
scalar extension R gives a comparison

    Hom_k(M^i,k) tensor R ~= A^(4-i) tensor R,

linear for the **specified** constant classes: xi_1,xi_2 act on the
right by a_1,a_2, and xi_3 acts by zero, with the graded transpose
convention. These are hypotheses, not conclusions of the finite
calculation above.

The exterior top pairing identifies the reindexed dual regular
module with the regular module. Hence M tensor R is a free
rank-one A tensor R-module, generated in degree zero. In particular
M^0 is one-dimensional over k. The actual coefficient unit is
nonzero: every frame algebra is a nonzero unital k-algebra, its
pullbacks preserve 1, and there are no degree-minus-one boundaries.
Therefore M^0=k*1.

The element 1 tensor 1 is a **basis** of M^0 tensor R. Under the
module comparison it is a unit multiple of a degree-zero generator.
It follows that the specified cup map based on 1, not on a newly
chosen generator, is an isomorphism after scalar extension. Its
kernel and cokernel vanish by faithfulness. The zero xi_3 action
descends in the same way. Odd squares vanish since char(k)=5.

There is an important distinction here: a merely nonzero scalar
over R need not be a unit. One cannot replace the preceding
basis argument by "the image is nonzero". The exact verifier
includes the dual-number negative control: multiplication by the
nonzero nilpotent epsilon on (F_5[epsilon]/epsilon^2)^4 has rank
4 out of 8 over F_5 and is not an isomorphism. The Lean theorem
uses an invertible scalar over a commutative ring, or a nonzero
scalar over a field. It does not confuse these hypotheses.

## 4. What still prevents a decision of the live question

The all-degree central contraction removes the proper geometric support
rows. The conditional unit criterion removes an ambiguity in the last
linear-algebra step. Neither proves the ordinary input of Section 3.
The following two assertions remain open in the campaign ledger:

1. `C318CO2ORDINARY`: the natural comparison for the literal algebraic
   connected-marking union, using common finite stages and pole bounds,
   survives the compact-lattice/stable-transfer replacement and the
   connected corestriction limit, with its actual cochain action.
2. `C318CO2ACTION`: that action is the actual block restriction of the
   specified rank-three classes, rather than a replacement exterior basis.

The precise dependency trace is `prop:transpose-comparison` in
05-support, `prop:compact-finiteness` in 08-compact,
`prop:pole-removal` in 09-boundary, `full:stable-cutoff`,
`full:trace-descent`, `prop:full-frame-comparison`, and
`full:corestriction` in 10-full-frame, and
`full:surviving-module` in 10-constant-module. The last assertion also
requires `prop:modification-transport` and `thm:stable-generators`.
The degree calculation itself is consistent:

    n^2+m-(t+2)m-m(t-1)-t^2 = 9+2-6-0-1 = 4.

Primary Tang Theorems 3.2 and 3.14(i), Proposition 3.21;
Anschuetz--Le Bras Corollary 3.11; and Pignon--Ywanne Corollary
3.2.4, Proposition 4.3.1, and Corollary 5.3.2 with its proof were
obtained and inspected at the versions cited by the manuscript.
Their quoted local assertions matched the uses checked here.
This is not an independent proof of the entire intervening comparison:
in particular no cited proposition simply identifies the literal
ordinary connected-marking cohomology and its specified action.

No exact counterexample to `prop:constant-module` has been found.
No unbridgeable gap has been proved. A completed substitute, the
finite Lie model, or the absence of a literature match does not close
either obligation above. `R318-CO2-CENTRAL-ALONE` is retired for this
specific insufficiency; `R318-CO2-ORDINARY` remains open.

The executable certificate is a **checkpoint**, not campaign completion
or a publication-novelty claim. Independent Reviewer replay on
2026-11-05 accepted the support contraction and conditional unit
criterion within exactly this scope. The previously accepted kernel
evidence has not been rebuilt or rerun.

The continuation `ordinary-comparison.md` now proves the finite
stable-cutoff step and follows actual connected corestriction,
retaining common bounds and original constant-cochain maps.
Its new Lean source is separate from the unchanged reviewed source.
The ordinary bridge is an implication with explicit finite-lattice
finiteness and geometric-comparison premises; it does not silently
discharge either premise or identify the specified xi_i. The new
comparison argument still requires independent review.

## 5. Exact and formal evidence for this checkpoint

Run `python3 research/coheight-two-unit/verify.py` from the campaign root.
The default mode recomputes the mathematical checks and compares their
results with `exact_certificate.json`; it does not rewrite the expected
answer. The certificate records both unresolved obligations explicitly.
The 13 bar-prism degrees are finite replay checks of the formula proved
for all degrees in Section 1. The 16-element exterior complex is only
the finite Lie model of Section 2. Neither computation is being presented
as an infinite ordinary cohomology calculation.

The inspected Jacobian operation `prime_field.matrix.rank.compute`
returned rank two for the exact eight-by-eight invariant differential.
The independently constructed differential agrees with the preserved
request and typed response in `jacobian-payload.json` and
`jacobian-output.json`. The adapter exited zero, with no error or timeout;
`jacobian-status.json` records that operational result. This checks a
finite algebraic calculation only.

The actual Lean 4.31.0 compiler and proof-hole audit both exited zero,
with `proof_holes=[]`. The official verifier attached the result only to
`C318CO2ALG`, under
`certificates/C318CO2ALG-a2bbfe535d25b3bd.json`.
Its source and fidelity hashes are checked against the current files by
the executable replay. The formal theorem proves the invertible-scalar
unit criterion and the division step for an assumed scalar homotopy;
the bar-prism construction remains the prose proof in Section 1.
The grading interpretation, ordinary comparison, specified Morava
classes, almost-category comparison, and independent statement-fidelity
review are not compiler results.

This improves the present audit by replacing the proper-support
vanishing calculation with an explicit all-degree contraction and by
isolating the actual-unit basis argument from a false nonzero-scalar
argument over a nonfield. It does not improve the reviewed kernel
range, which was already known, and does not establish a new
publication-level result. The ordinary route remains unresolved rather
than being retired as mathematically impossible.
