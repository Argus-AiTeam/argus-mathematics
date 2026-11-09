# Prescribed filtrations with one algebraic marking

## Result and scope

The realization implication in `lem:admissible-realization`,
`build/sections/02_transport.tex:330-575`, follows from the versioned
geometric results below. This includes residue characteristic two. In
particular, the quasi-isogeny giving the prescribed crystalline period can
be the **same algebraic quasi-isogeny** that preserves all the prime-to-p
structure tensors. This is a relative verification using published and
preprint geometric theorems, not a foundational formalization of those
theorems or a proof of Milne's rationality conjecture.

The connecting argument supplied here makes the common marking explicit.
It propagates the tensor equalities for a fixed universal quasi-isogeny,
rather than replacing that quasi-isogeny separately in each realization.
The general propagation argument and the Frobenius convention are
formalized in `Main.lean`. The separate symbolic certificate is replayed by
`python3 research/prescribed-filtration-audit/verify.py`.

Independent review and novelty assessment remain pending. No claim of a
new publishable theorem, a counterexample to the manuscript, or campaign
completion is made.

## Current Milne source, and the strongest relevant prior discussion

The current primary source is
<https://www.jmilne.org/math/articles/SVp.pdf>, retrieved on 5 November
2026. Its title page identifies **9 October 2026, v2.4**. Its PDF creation
and modification dates are 9 October 2026; the HTTP `Last-Modified` header
is 9 October 2026, 19:28:01 GMT. The local PDF, extracted text, headers,
and pages 81-83 are in `sources/`. These independent version indicators
agree. The manuscript's bibliography instead describes v2.2, 2 November
2025. Assertions about the new section 12 must therefore be attributed
to v2.4, not retroactively to the cited v2.2.

Section 12 comments on the September 23 manuscript and uses that version's
numbering. It describes the balanced-Weil dichotomy as the interesting
new step, treats CM-to-Weil reduction as known, and discusses transport
to CM varieties cautiously. It does not check the present realization
lemma, its integral tensors, or its p=2 case. Its conclusion about the
rationality proof is conditional. Section 5.21 already proposes lifting
with additional Hodge structure; it does not supply the required lifting
theorem. Thus these passages are a relevant antecedent, not an
independent certificate for the current lemma.

The improvement over that prior discussion is the explicit realization
argument below, especially the fixed-marking argument in Step 4. It does
not settle the balanced-Weil dichotomy identified by Milne as central.

## Exact statement

Use the manuscript's notation

* k = algebraic closure of F_p and K0 = Frac W(k);
* (J, X_J, Jcal) is strongly admissible, with its adapted self-dual closed
  Hodge embedding, neat level, and the canonical integral model S_K;
* J over Q_p is quasi-split;
* x in S_K(k) has a characteristic-zero lift, and C_x is its abelian
  variety;
* D_x = H_cris^1(C_x/W(k))[1/p], with the canonical structure tensors;
* F is a filtration over a finite extension K/K0, admissible as a faithful
  filtered isocrystal, whose geometric flag is in the orbit specified by
  X_J.

Then after a finite extension K'/K there are y in S_K(k), an algebraic
quasi-isogeny b:C_x -> C_y, and a lift ytilde over O_K', such that b
preserves the canonical crystalline tensors and every canonical
prime-to-p tensor and

    b^* Fil^1 H_dR^1(C_ytilde/K') = F^1.

The pullback here uses the actual crystalline realization of b. It is
not an arbitrarily chosen isomorphism of rational isocrystals. All field
extensions used in constructing the desired point are finite. The
auxiliary completed algebraic closure is used only to describe periods,
Hecke orbits, and geometric connected components.

## External mathematical inputs actually used

The local PDFs and their extracted text in `sources/` are the versions
read. The ledger records these inputs as assumptions, not as theorems
proved by the algebraic certificate.

| Input | Exact source and locator | Content used and restrictions |
|---|---|---|
| Adapted integral model | Kisin-Zhou, arXiv:2505.02165v1, Definition 2.1.6, Proposition 2.1.9, Theorem 2.1.12, sections 2.1.13-2.1.14, pp.7-10 | Closed embedding on a self-dual lattice; canonical tensor shtuka and its faithful p-divisible-group realization; local formal comparison. At p=2, strong admissibility explicitly includes reduced relative roots. |
| Period image | Pappas-Rapoport, arXiv:2106.08270v6, section 3.1.1 and Proposition 3.1.1(i), equation (3.1.9), pp.50-52 | The crystalline period map is etale; its image is the admissible locus. That locus is detected by a representation whose inverse image of the target center is central, for a local Shimura datum with the required Kottwitz invariant. |
| Marked integral pullback | Pappas-Rapoport, same version, Proposition 3.5.1, pp.66-67; section 4.1, p.76; Definition 4.5.1 and section 4.5.2, pp.85-86; sections 4.10.1-4.10.3, pp.102-106 | The tensor-compatible RZ space is an open-and-closed part of the marked Siegel pullback. Its map to S_K respects the universal shtuka. Once representable, its generic fiber and Breuil-Kisin specialization are the specified ones. The global center split-rank condition must be checked. |
| Representability without a p>2 restriction | Gleason-Lim-Xu, arXiv:2208.07195v3, Corollary 6.3 and proof, pp.42-44 | For global Hodge-type data the marked RZ space equals the integral local Shimura variety. This supplies condition U; it is not left conjectural. |
| Components and compatible Hecke points | Gleason-Lim-Xu, same version, Corollary 3.13, p.25, and the Hecke diagrams in the proof of Corollary 6.3, pp.43-44 | Specializations of the G(Q_p) period-fiber orbit of an initial lift meet every connected component of the ADLV. The diagram identifies these with the actual at-p Hecke quasi-isogenies in the marked pullback. The locator is **Corollary** 3.13; a reference to “Theorem 3.13” in the later proof is a harmless internal label mismatch. |
| Weak admissibility clause only | Colmez-Fontaine, doi:10.1007/s002220000042, author version `CF.pdf`, Introduction p.2 and Theorem A | Weakly admissible filtered (phi,N)-modules are admissible over the complete discrete-valuation fields with perfect residue field specified there. With N=0 the representation is crystalline. There is no odd-prime restriction. |

Two standard facts used below admit short direct arguments: a nonempty
etale rigid fiber over a complete field has a point over a finite
extension; and a section of a constant finite etale sheaf is constant on
each connected component. The latter is exactly the propagation
principle formalized here. No companion CM Hodge theorem is used.

Kisin's 2017 Proposition 1.4.15 was also read, because PR cites it for the
description of an isogeny class. It characterizes existence of a
simultaneously tensor-preserving quasi-isogeny. By itself that
characterization does not identify a previously fixed crystalline
marking. The argument below does not use it to silently change b, nor
does it extend its original hypotheses to p=2 by assertion.

## Proof

### 1. Check the global and integral hypotheses

The strongly admissible adapted embedding is a closed embedding
Jcal -> GL(Lambda), with Lambda self-dual. It factors through the
symplectic lattice stabilizer: the generic symplectic-similitude
identities extend by flatness, and self-duality makes the multiplier a
unit. Its schematic closure is Jcal itself. Thus the embedding is in
particular a dilated immersion of the kind used in PR section 4.5.2.
The group scheme is the full connected Bruhat-Tits stabilizer, not an
unrelated smooth model. This checks PR's global Hodge-type condition.
KZ Theorem 2.1.12 identifies the integral model and its canonical shtuka
with the one to which that theory applies.

Here is also the global center condition sometimes hidden in this
application. Let c be the similitude character. A real central element
with c=1 commutes with h(i) and preserves the definite form
psi(v,h(i)w), after choosing its sign. Its image is therefore compact.
Faithfulness gives real split rank at most one for the center. The
rational weight torus is central and nontrivial, and c on it is t^2
or t^-2. It supplies one rational split direction. Consequently both
split ranks in PR (4.1.1) are one.

KZ section 2.1.14 gives [b_x] in B(J,mu^-1), including its Kottwitz
condition. This is essential in using PR (3.1.9); admissibility of a
faithful representation without the local-Shimura invariant condition
would not be an adequate substitute.

Enlarge K finitely to contain the completed local reflex field and the
field defining F.

### 2. Lift the prescribed flag, not just some admissible flag

The faithful representation gives a closed immersion from the
J-filtration variety into the appropriate GL filtration variety. Indeed
the parabolic for a cocharacter is detected by existence of the
conjugation limit, so its intersection with J is the J-parabolic.
The given K-rational filtration, geometrically in the image, therefore
determines a unique K-rational J-flag f_F.

Use cohomological coordinates via the marked Siegel RZ period map. For
a deformation H with marking q:H_k -> C_x[p^infinity], the period on
D_x is

    (q^*)^-1 Fil^1 H_dR^1(H).

This specifies the duality and Frobenius descent, without extending
sigma to a ramified filtration field.

Admissibility of (D_x,F) means there is a crystalline representation
realizing these data. Crystalline and filtered de Rham comparison glue
the associated modification of its vector bundle to the trivial bundle
of that representation. Thus the GL flag is in the GL admissible locus.
For a faithful representation rho, any element whose image is central
in GL commutes with rho(J), and hence is central in J. PR (3.1.9), with
the Kottwitz condition already checked, now puts f_F in the J
admissible locus.

It is the image of the etale crystalline period map at the stipulated
parahoric level. The fiber over f_F is nonempty. An etale rigid space
over K is locally zero-dimensional over K; the residue field of a
classical point in a nonempty affinoid neighborhood is finite over K.
After a finite extension, choose

    z in M(Jcal,b_x,mu)(K), with pi_GM(z)=f_F.

This selects the integral level and the annular Frobenius-compatible
framing. No arbitrary Galois-stable lattice is inserted afterwards.

### 3. Retain the entire framed integral point

By GLX Corollary 6.3, the integral local Shimura variety is represented
by the marked tensor-compatible formal RZ space of PR section 4.10.1.
By PR Proposition 3.5.1 its generic fiber is the local Shimura variety
used in Step 2. A classical K-point of that fiber extends to an O_K
point of the formal space: take a formal affine chart, or a member of
its standard generic-fiber covering containing the point; its ring
maps to O_K and its ideal of definition maps to topologically
nilpotent elements.

The formal map to the completion of S_K gives a lift ytilde of a point
y. Pullback of the universal abelian scheme realizes the faithful
p-divisible group of z. The Jcal-torsor, its integral tensors, and
its annular framing are those of this same point. In particular
Breuil-Kisin reduction and specialization have not been independently
chosen: PR Proposition 3.5.1(iii) compares them for the point already
constructed.

The marked Siegel construction supplies one algebraic special-fiber
p-quasi-isogeny b:C_x -> C_y. One way to see why no algebraicity of
an arbitrary p-divisible automorphism is being asserted is to multiply
q^-1 by a power of p, take its finite kernel inside C_x[p^infinity],
and take the quotient abelian variety. The resulting quasi-isogeny,
with the tautological identification of its p-divisible group with
H_k, has marking q^-1. A nonalgebraic automorphism of the framing
p-divisible group changes that tautological identification; it is
not asserted to be an endomorphism of C_x.

These quasi-isogenies form the universal quasi-isogeny on the reduced
special fiber, locally after bounding the p-denominator, and agree on
overlaps. The defining crystalline tensors are preserved because the
RZ open-and-closed locus is defined by precisely that equality in PR
section 4.10.1. Its marking on D_x is therefore the desired one.

### 4. The fixed b also preserves every prime-to-p tensor

This is the extra connecting argument that prevents substitution of
unrelated local quasi-isogenies.

Let T be the perfect reduced special fiber of this marked RZ space.
Keep the identity prime-to-p coordinate. Over T the one universal
b identifies the prime-to-p Tate local systems of the target abelian
family with those of the constant source C_x. Fix alpha and ell != p.
After clearing the denominator of its rational tensor, the difference
between the pulled-back target tensor and the source tensor reduces,
for every n, to a section of a **constant finite etale sheaf** on T.
Such a section is a locally constant function on the underlying
topological space. Equality with zero is clopen. This argument is
local for the p-denominator; b is invertible on integral ell-adic
Tate modules, so the descriptions agree on overlaps.

Choose the initial characteristic-zero lift of x, with its identity
special-fiber marking. Its G(Q_p) Hecke orbit consists of actual
at-p quasi-isogenies of abelian varieties, preserving the canonical
structure tensors in characteristic zero in every realization.
Each orbit point is defined after a finite extension, since its
finite p-power subgroup and finite-level Hecke data are defined
after a finite extension. Its specialization preserves the same
prime-to-p tensors.

The Hecke diagrams in GLX's proof of Corollary 6.3 identify these
specialized quasi-isogenies with **the universal b evaluated at
those points**, not merely with another quasi-isogeny to the same
abelian variety. GLX Corollary 3.13 says their specializations meet
every connected component of the ADLV, which is T by the integral
identification.

A locally constant discrepancy that is zero at one point of every
connected component is zero everywhere. Apply this to each alpha,
ell and n. Separation of the ell-adic tensor lattice gives equality
over Z_ell after clearing the denominator, hence over Q_ell.
The quasi-isogeny b was fixed before alpha, ell, or n was selected.
It therefore preserves all the prime-to-p tensors simultaneously.
In particular y lies in the manuscript's tensor isogeny class I_x.

This propagation statement is
`PrescribedFiltration.propagate_tensor_equalities` in `Main.lean`.
The geometric facts producing T, b, its finite etale discrepancy
sections, and its Hecke witnesses remain external to that Lean theorem.

### 5. Identify the exact filtration

The RZ marking is q=b^-1 on the p-divisible groups, with the
tautological identification of Step 3. Contravariance gives
q^*=(b^*)^-1. Since pi_GM(z)=f_F, the marked period convention in
Step 2 gives

    F^1 = (q^*)^-1 Fil^1 H_dR^1(C_ytilde)
        = b^* Fil^1 H_dR^1(C_ytilde).

There is no further conjugation by a self-quasi-isogeny, and no
replacement of b to arrange the other realizations. This proves
the stated realization implication.

### 6. Weak admissibility and p=2

For the manuscript's last sentence, descend to the stated finite
local field H. Every descended Frobenius subobject extends to a
subisocrystal over K0; its Hodge and Newton numbers are unchanged by
this scalar extension. The weak-admissibility inequalities and total
equality therefore hold on the descended object. Colmez-Fontaine
Theorem A with N=0 gives a crystalline representation; scalar
extension gives admissibility as required in Step 2.

The CF author version actually states its theorem in a
perfect-residue-field setup, broader than finite residue fields.
No removal of the manuscript's finite-descent hypothesis is needed
or claimed as a novel result here.

At p=2 the reduced-root and R-smoothness hypotheses are exactly
those in KZ's strong admissibility. KZ's adapted embedding and
model theorem include this case. GLX Corollaries 3.13 and 6.3
have no odd-prime exclusion. The proof uses those theorems rather
than the older restricted CM-lifting results mentioned in GLX's
introduction. Neither the finite etale propagation argument nor
the marking identity divides by p-1 or by 2.

## Exact algebraic core and a route that fails

Write dual(a) = (a^-1)^t. KZ's convention on cohomology is

    F_x = rho^vee(sigma(b_x)) sigma.

For the cohomological lattice basis rho^vee(sigma(g)), the matrix of
this semilinear operator is

    rho^vee(sigma(g))^-1 rho^vee(sigma(b_x))
        sigma(rho^vee(sigma(g)))
      = rho^vee(sigma(g^-1 b_x sigma(g))).

This is an identity of group homomorphisms, with their indicated
Frobenius compatibility, in every dimension. The two Frobenius
theorems in `Main.lean` prove that identity without a field-size,
dimension, or prime restriction. They do not model a Frobenius
extension to K.

The Jacobian calculation solves the actual change-of-basis equations
S A = B sigma(S) in the family

    b = [[0,1],[-1/p,0]],   g = [[1,t],[0,1]],
    u = sigma(t), v = sigma^2(t), S = dual(sigma(g)).

It gives

    A = [[-v,1],[-p-u*v,u]],   det(A)=p.

The typed input, operation contract, and output are kept as dedicated
JSON files. The universal symbolic identity is independently
recomputed by `verify.py`; generic rational-function output is not
misdescribed as a case split or a proof of geometric realization.
At p=2, the unramified quadratic relation t^2+t+1=0 gives a
nontrivial Frobenius t -> -1-t. The script checks the displayed
formula there and exhibits the different matrix obtained by
omitting the outer sigma. This is a diagnostic of a **wrong
convention**, not a counterexample to the manuscript's formula.

There is also a genuine obstruction to an insufficient proof route.
Over Z_2 let

    L = [[1,0],[1,2]],   e = [[1,0],[0,0]].

For every s in Z_2,

    L^-1 diag(1,1+2s) L = [[1,0],[s,1+2s]]

is integral and invertible, whereas

    L^-1 e L = [[1,0],[-1/2,0]]

is not integral. Thus a stable lattice need not carry the rational
projector tensor integrally. The standard lattice does carry it.
This kills the arbitrary-stable-lattice shortcut, not the
existential realization statement, which is allowed to choose its
integral level and to move in the tensor isogeny class.

## What remains unverified

The fresh Lean 4.31.0 run compiled all four declarations with exit code zero,
no proof holes, and a successful axiom audit. Its mechanical evidence is
attached only to `PF-CORE`, in
`lean-evidence/certificates/PF-CORE-1814cc54e847468b.json`. It does not certify
`PF-REALIZATION` or independently approve the statement-fidelity reading.

The cited geometric theorems, their applicability checks, the
finite-etale interpretation of discrepancies, and the identification
of the universal abelian marking require mathematical reading by
the independent Reviewer. Lean checks the stated abstract
algebraic/topological core only; Python checks the exact symbolic
and integral calculations only. Neither compiler output nor the
source-version extraction proves the remaining manuscript claims.

In the manuscript graph, this lemma feeds the prescribed-filtration
clause of transport, which combines with the constrained filtration
theorem and the rational divisor identity in the nonvanishing branch
of the balanced-Weil dichotomy. CM transport, CM-to-Weil reduction,
and pullback functoriality then enter the rationality theorem.
Algebraic specialization has the additional, still unverified
companion CM Hodge theorem as a separate dependency. That theorem
is not an assumption of this realization proof or of the main
rationality proof.
