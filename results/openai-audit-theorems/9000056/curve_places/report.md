# Curve cohomology and distinct global discrepancy-two places

## Result and scope

This note gives an independent proof of the October 7 proposition
`prop:curve-places`, including its global, rather than germwise, divisor count.
The proof uses the standard analytic inputs listed below. It is not a
computer formalization of those inputs or of the geometric argument.
Independent Reviewer acceptance and a novelty determination are still required.
Neither the termination theorem nor the publishable campaign is declared complete.

There are two additional conclusions. Restriction to a loop-preserving curve
core gives a **bijection of all discrepancy-two places**, not just an injection
of the places constructed in the proof. Also, the curve estimate itself does
not require the ambient compact fourfold to be Kahler: projectivity of the
specified resolution suffices. This does not remove Kahler hypotheses from the
separate Hodge-theoretic branch estimate.

The earlier September 24 projective manuscript, Section 6.1 (source file
`04-local-valuations.tex`), already contains the finite-monodromy parameter
argument. The October 7 manuscript already states the desired Kahler bound.
Reproving either is not a novelty claim. The additional conclusions here
isolate the precise globalization mechanism and its hypothesis dependence;
their novelty and significance have not been independently established.

## Statements

Let \(Y\) be a normal irreducible compact complex analytic fourfold with
ordinary terminal singularities. Thus local exceptional places have **log**
discrepancy greater than one; the coefficient of an exceptional divisor in
a relative canonical divisor is \(a-1\). Retain exactly the specified
projective resolution
\[
g:\widetilde Y\longrightarrow Y:
\]
its source is smooth, it is an isomorphism over \(Y_{\rm reg}\), its exceptional
divisor has simple normal crossings, and
\[
\mathcal I_{\operatorname{Sing}Y}\mathcal O_{\widetilde Y}
 =\mathcal O_{\widetilde Y}(-E_{\rm sing}),\qquad
\operatorname{Supp}E_{\rm sing}=g^{-1}(\operatorname{Sing}Y).
\]
In particular, no replacement of this resolution by an arbitrary resolution
is being made.

Let \(T\) be an irreducible curve component of \(\operatorname{Sing}Y\).
After deleting finitely many points, let \(T^o\) be connected and smooth and set
\[
j:Y_{\rm reg}\hookrightarrow Y,\quad
W=(R^2g_*\mathbb Q)|_{T^o},\quad
V=(R^2j_*\mathbb Q)|_{T^o},\quad
b=\dim_{\mathbb Q}H_c^2(T^o,V).
\]
All relevant direct-image sheaves are taken to be local systems there.
Global places mean primes on proper bimeromorphic models of the whole \(Y\),
identified by strict transform on common models, not merely valuations of a
field of global meromorphic functions.

**Theorem A (the bound, with a scope extension).** Under these hypotheses,
\[
b\leq
N_T:=\#\{E\text{ prime in }\operatorname{Exc}(g):
          g(E)=T,\ a(E;Y,0)=2\}.
\tag{1}
\]
In particular this proves the live objective when \(Y\) is compact Kahler.
There is no projectivity assumption on \(Y\).

**Theorem B (core globalization).** Delete finitely many further points so
that each global exceptional prime \(E\) dominating \(T\) has a factorization
\[
E|_{T^o}\longrightarrow\widehat T_E^o\longrightarrow T^o
\tag{2}
\]
whose first map is smooth proper with connected fibers and whose second map
is a connected finite etale cover. If \(B\subset T^o\) is a connected open
curve domain with
\(\pi_1(B)\twoheadrightarrow\pi_1(T^o)\), and \(U_B\) is an ambient open
meeting \(T\) exactly in the closed analytic subspace \(B\), then restriction
is a bijection
\[
\begin{split}
&\{\text{global places over }Y\text{ centered at }T,\ a=2\}\\
&\hspace{12mm}\longleftrightarrow
\{\text{local places over }U_B\text{ centered at }B,\ a=2\}.
\end{split}
\tag{3}
\]
Every place on either side is represented on \(g\) or its restriction.
Theorem B does not require the small factorialization used to prove (1).

## Source inputs and their exact scope

The following are cited analytic/algebraic inputs, not conclusions of
`verify.py`. Source scans and source-reading notes are in `sources/`.

| Input | Actual source and locator | Scope used here |
|---|---|---|
| Local analytic decomposition theorem | Saito, DOI `10.2977/PRIMS/1195173930`, Theorem 5.3.1, p. 977; Introduction Corollary 3, p. 857; Sections 5.1 and 5.4 | Projective maps of complex analytic manifolds; local smooth embeddings of the target are allowed. The constant rational Hodge module is permitted. No algebraicity or global Kahler hypothesis is imposed. Full-support identification additionally uses that the map is a resolution. |
| Rational singularities | Fujino, `arxiv:2201.11315v1`, Remark 3.8 and Theorem 3.12, pp. 30-32 | Apply locally on relatively compact klt neighborhoods; hence the higher coherent direct images of a resolution vanish. No global dlt assertion about a noncompact open is needed. |
| Scheme GAGA | SGA1 XII, `arxiv:math/0206203v2`, Sections 1.1-1.3, Corollary 4.3 and Theorem 4.4, revised pp. 239-242, 249-250 | Coherent sheaves on a proper complex scheme, including nonreduced scheme fibers. The accessed source is the revised edition, not the uninspected 1971 printing. Family algebraization also needs the explicit projective presentation given below. |
| Quot parameter spaces | Grothendieck, Bourbaki Expose 221, NUMDAM `SB_1960-1961__6__249_0`, Theorems 3.1-3.2, pp. 259-260, and the checked 1962 erratum | Each fixed-polynomial Quot is projective and finite type over the noetherian base. The unrestricted union is only locally finite type. Varying the polynomial and presentation gives a countable union, not one finite-type Picard scheme. |
| Stein neighborhoods | Forstneric, DOI `10.5802/aif.2112`, Theorem 2.1 and preceding hull discussion, pp. 735-736 | A closed Stein subvariety of a reduced paracompact, possibly singular, complex space has a Stein neighborhood. A compact in that subvariety is holomorphically convex in the Stein ambient precisely when it is so in the subvariety. |
| Full-compact small factorialization | Fujino v1, condition (P), p. 3; Section 1.11, p. 6; Theorem 1.24, p. 11; Definitions 2.32, 2.38 and Remark 2.39, pp. 22, 24; Lemma 2.42 and Remark 2.43, p. 25 | Shrink the base around the full Stein compact. Only divisors defined near its entire inverse image are tested. Fix their common Cartier multiple there before any smaller-core restriction. |

We also use the usual local terminal-singularity fact that a terminal
fourfold is smooth in codimension two; its analytic surface argument is
reviewed in Appendix A. The needed local discrepancy computations are
explained there as well. The staged October 6 canonical manuscript,
Lemma 2.3, supplies the same local fact; none of its termination conclusions
is an input. Basic analytic topology and Stein theory used below are proper
base change, Cartan A/B, the exponential sequence, continuity of Cech
cohomology on compact sets, semianalytic triangulation, and covering-space
theory. These are mathematical inputs, not mechanically checked assertions.

## 1. The natural quotient and finite monodromy

There is a canonical restriction morphism
\[
\rho:Rg_*\mathbb Q_{\widetilde Y}[4]\longrightarrow
      Rj_*\mathbb Q_{Y_{\rm reg}}[4].
\]
To see that its ordinary degree \(-2\) map along \(T^o\) is surjective,
work in one small analytic chart embedded in a smooth ambient space.
The projective local decomposition theorem supplies the full-support
summand \(IC_Y\), with inclusion restricting to the identity on the regular
open. By adjunction, its composite with \(\rho\) is the canonical
comparison \(IC_Y\to Rj_*\mathbb Q[4]\).

In the middle-perversity attaching construction, a complex
codimension-three stratum retains unshifted degrees through two.
Consequently this comparison is an isomorphism in ordinary degree
\(-2\) along \(T^o\). Taking that degree gives a surjection
\[
q:W\twoheadrightarrow V.
\tag{4}
\]
Its fiber map is exactly restriction through neighborhoods from
\(H^2(g^{-1}(t),\mathbb Q)\) to the punctured regular neighborhoods.
It is a morphism of local systems and hence monodromy-equivariant.
Only a **local** decomposition was used; no global Hodge purity or
global splitting is needed for (4).

We give the finite-monodromy argument to specify its algebraic content.
A compact reduced analytic curve is projective: a divisor consisting of
one smooth point on each irreducible component has positive degree on
every component; normalization and finite jet separation give ampleness.
Thus \(T\) is projective. The full complex-space fiber product
\(\mathcal F=\widetilde Y\times_Y T\), including nilpotents, has a global
relatively ample line bundle. A sufficiently high power gives a relative
closed immersion into the projectivization of a coherent sheaf on \(T\).
GAGA on \(T\), followed by an ample twist, makes that sheaf globally
generated. Hence \(\mathcal F\) embeds in \(T\times\mathbb P^M\).
Scheme GAGA algebraizes its coherent ideal in this proper algebraic
ambient. This proves the required family algebraization rather than
assuming that arbitrary proper analytic families algebraize.

For any \(t\), proper base change lifts an integral fiber class to
\(H^2(g^{-1}U_t,\mathbb Z)\) for some sufficiently small Stein neighborhood
\(U_t\). Rational singularities and Cartan B imply
\[
H^2(g^{-1}U_t,\mathcal O)=0.
\]
The exponential sequence realizes the class as the Chern class of a
holomorphic line bundle. Restriction to the whole projective scheme
fiber and scheme GAGA therefore give
\[
\operatorname{Pic}(\mathcal F_t)\otimes\mathbb Q
\twoheadrightarrow H^2(\mathcal F_t,\mathbb Q)=W_t.
\tag{5}
\]
No coherent-cohomology assertion about only the reduced fiber is being
substituted for (5).

Make \(\mathcal F\to T^o\) flat by finite puncturing. Every fiber line
bundle is a quotient of some \(\mathcal O(-n)^{\oplus r}\). Fixed
\((n,r,P)\) gives a finite-type relative Quot scheme. Restrict it to
the open where the universal quotient is invertible on the entire
pulled-back family. This open contains each point representing a line
bundle: flatness of the family and of the quotient gives local
freeness near the fiber, and properness removes the complementary bad
locus. Thus a countable collection of finite-type spaces, each carrying
an actual universal line bundle, accounts for all line bundles in (5).

Choose \(t\) outside the countably many finite closures of images of
non-dominating parameter components. Choose finitely many fiber line
bundles whose Chern classes span \(W_t\). Each belongs to a dominating
irreducible parameter component \(H\), and its universal Chern class is
a section of the pullback of \(W\). A closed point of the generic fiber
of \(H\to T^o\), spread out and normalized, supplies a finite etale
multisection over a further open. The analytification of \(H\) is path
connected. A path from the original parameter point to the multisection
shows that a finite-index subgroup of \(\pi_1(T^o,t)\) fixes the
original Chern class. Further puncturing surjects on the old fundamental
group, so it does not change this conclusion. Intersecting the
stabilizers of the finite spanning list proves that \(W\) has finite
monodromy.

Let \(G\) be that finite monodromy image. Poincare duality with local
coefficients on the oriented curve, and averaging over \(\mathbb Q\),
give
\[
b=\dim V_t{}_{\pi_1(T^o)}=\dim V_t^G,\qquad
W_t^G\twoheadrightarrow V_t^G.
\tag{6}
\]
Choose flat sections \(\sigma_1,\ldots,\sigma_b\) of \(W\) whose images
in \(V\) are independent in every fiber. For \(b=0\), (1) is immediate.
This is the only use of averaging; it is not the globalization proof.

## 2. Line bundles on a full loop-preserving compact

Remove one more point if needed, so \(T^o\) is noncompact. Its homotopy
type is a finite graph. Leray for \(g^{-1}T^o\to T^o\) therefore makes
\[
H^2(g^{-1}T^o,\mathbb Q)\longrightarrow H^0(T^o,W)
\]
surjective: the possible obstruction groups have base degree at least
two. The total space has finite algebraic triangulation type. Clear
denominators to obtain integral lifts \(\alpha_i\), multiplying the
\(\sigma_i\) by the same individual positive integers. Independence
is unchanged.

In the smooth compactification of \(T^o\), remove disjoint small
coordinate discs at its punctures and call the remaining compact
bordered surface \(K\). Choose semianalytic boundaries. Its interior
carries all loops, and it is Runge in \(T^o\): each component of the
complement runs out to a missing point, so none is relatively compact.
The latter is the holomorphic-convexity criterion on an open Riemann
surface; loop retention alone would not have established convexity.

Remove the discarded points and the other singular components from an
ambient open \(Y^o\), so that \(T^o\) is closed there. Forstneric's
theorem with empty compact gives a Stein neighborhood \(\Omega\) of
\(T^o\) in \(Y^o\), despite singularities of \(Y^o\).
The hull statement makes \(K\) holomorphically convex in \(\Omega\).

The compact semianalytic set \(g^{-1}K\) is locally contractible.
Continuity of Cech cohomology on neighborhoods, and its agreement here
with singular cohomology, extend the restrictions of all \(\alpha_i\)
to a common open neighborhood of \(g^{-1}K\) in \(\widetilde Y\).
Properness then gives an ambient neighborhood \(U_0\) of \(K\) whose
full inverse image lies in that neighborhood. Choose a connected
Stein open \(U\) with
\[
K\subset U\Subset\Omega\cap U_0.
\]
Rational singularities, Cartan B and the exponential sequence turn
the integral extensions into line bundles \(L_i\) on \(g^{-1}U\).
Their fiber classes on \(K\) are the chosen \(\sigma_i\).

Before any small modification, choose actual divisor representatives.
The coherent rank-one sheaf \(g_*L_i\) has a section nonzero at a regular
point by Cartan A. Its pullback is a nonzero section of \(L_i\).
Its zero divisor \(A_i\) is a globally defined Cartier divisor on
\(g^{-1}U\).

Fujino Section 1.11 supplies a semianalytic Stein compact
\(K'\Subset U\) with \(K\subset\operatorname{int}K'\).
For example start with a point compact and enclose a relatively
compact neighborhood containing \(K\) in the construction of that
section. Its condition (P4) tests analytic sets defined near all of
\(K'\), not only global analytic subsets of \(U\).

Apply Theorem 1.24 to \((U,0)\), the identity morphism and \(K'\).
The identity is projective, \(U\) is terminal and hence klt, and its
canonical sheaf is rationally invertible. On this Stein space an actual
canonical divisor representative exists, also by Fujino Remark 2.43.
After the permitted shrinking **around \(K'\)**, obtain
\[
\ell:Y'\longrightarrow U
\]
small and projective, with \(Y'\) Q-factorial **over \(K'\)**.
Smallness and the Q-Cartier canonical sheaf give crepancy by reflexive
extension from the common codimension-one open. Thus \(Y'\) is terminal.
It is also an isomorphism over \(U_{\rm reg}\). Indeed a relatively
ample line bundle there would be the pullback of its invertible
rank-one reflexive trace on the smooth base, by smallness and
reflexivity. A positive-dimensional fiber would have degree zero
against that relatively ample bundle, which is impossible.

Let \(D_i'\) be the strict transform of \(g_*A_i\).
These are a finite prescribed list of integral analytic Weil divisors
defined on the whole current \(Y'\). Their locally finite supports meet
the compact \(\ell^{-1}K'\) in only finitely many prime components.
Definition 2.38 applies to those divisors near the **whole** compact.
Lemma 2.42, using rational singularities of the terminal \(Y'\),
gives a common \(n>0\) for which all \(nD_i'\) are Cartier on one
neighborhood of \(\ell^{-1}K'\). By properness it contains the full
inverse image of some neighborhood \(U_1\) of \(K'\). Put
\[
N_i=\mathcal O(nD_i')|_{\ell^{-1}U_1}.
\]
On the regular locus they agree with \(L_i^{\otimes n}\).
This obtains fixed line bundles before any smaller-core restriction.
It does **not** infer Q-factoriality over a smaller compact, the
invalid inference explicitly warned against in Remark 2.39.

## 3. The degree map is injective

Choose connected nested curve domains
\(B_0\Subset B_1\Subset\operatorname{int}K\), with \(B_0\) carrying all
loops of \(T^o\). Work in an ambient open making \(B_1\) closed.
Local finiteness and properness leave only finitely many components
of \(\ell^{-1}B_1\) near \(\ell^{-1}\overline B_0\).
Smallness gives \(\dim\operatorname{Exc}(\ell)\leq2\); hence general
fibers above \(B_1\) have dimension at most one.

Remove from \(B_0\) the finitely many values near \(\overline B_0\) of
fiber-dimension jumps, vertical components, branching and critical
values of the normalized surface families, and values where intersections
or normalization failures contain an entire fiber curve. These are
discrete analytic sets on the larger domain \(B_1\).
The resulting \(B\) is connected and still surjects on
\(\pi_1(T^o)\). The irreducible surface components \(S_1,\ldots,S_s\)
dominating \(B\) have normalized Stein factorizations
\[
\widehat S_\alpha\longrightarrow C_\alpha\longrightarrow B,
\]
smooth proper connected curve families over connected finite etale
covers. Components are counted **after** restriction. For a fixed
\(t\in B\), the pairs \((\alpha,c)\), \(c\in(C_\alpha)_t\), give
distinct irreducible curves and exhaust all curves in \(\ell^{-1}(t)\).
The normalization fibers map birationally to those curves.

Define integers
\[
d_{\alpha i}=\deg(N_i|_{(\widehat S_\alpha)_c}).
\]
They are constant on the connected \(C_\alpha\); in particular every
sheet belonging to this one surface family has the same degree vector.
Suppose \(\sum_i u_i d_{\alpha i}=0\) for every \(\alpha\), with
\(u_i\in\mathbb Q\). Every irreducible curve in the at-most-one-dimensional
projective fiber \(F'_t=\ell^{-1}(t)\) has degree zero against
\(\sum_i u_i c_1(N_i)\).

The top rational homology of a compact complex curve has the fundamental
classes of its irreducible components as a basis; zero-dimensional
components contribute nothing. Nilpotents do not change this topology.
The universal coefficient theorem therefore makes the restricted
class zero in \(H^2(F'_t,\mathbb Q)\).
Proper base change and restriction through \(\ell^{-1}U_{\rm reg}
\simeq U_{\rm reg}\) give the natural map
\[
(R^2\ell_*\mathbb Q)_t\longrightarrow (R^2j_*\mathbb Q)_t.
\]
The image of that zero class is, by the regular-locus bundle agreement,
\[
n\sum_i u_iq(\sigma_i(t)).
\]
Independence in (6) forces every \(u_i=0\). Thus the actual map
\[
\mathbb Q^b\longrightarrow\mathbb Q^s,\qquad
(u_i)\longmapsto(\sum_i u_id_{\alpha i})_\alpha
\tag{7}
\]
is injective and \(b\leq s\). This checks all fiber curves, not just
one chosen curve on each sheet.

## 4. Discrepancy and globalization: proof of Theorem B

First prove the assertion for arbitrary local places of log discrepancy
two; it is stronger than what is needed for the surfaces \(S_\alpha\).
The intrinsic relative canonical divisor of the fixed resolution is
\[
K_{\widetilde Y/Y}=\sum_E\kappa_EE,\qquad \kappa_E>0.
\tag{8}
\]
It is defined by meromorphic comparison of a common invertible
pluricanonical power, so no global canonical divisor representative on
the compact \(Y\) is needed. Terminality supplies the strict signs.

Let \(v\) be a local place over \(U_B\), centered at \(B\), with log
discrepancy two. If \(v\) were exceptional over the smooth
\(g^{-1}U_B\), then its log discrepancy there would be at least two.
Its center lies in \(g^{-1}(\operatorname{Sing}Y)\); principalization
puts it inside some \(E\), so \(\operatorname{ord}_v(E)>0\).
All other orders are nonnegative. The composition formula gives
\[
a(v;U_B,0)
=a(v;g^{-1}U_B,0)+\sum_E\kappa_E\operatorname{ord}_v(E)>2,
\tag{9}
\]
a contradiction. Hence \(v\) is already a prime on \(g^{-1}U_B\).
It is a component of the restriction of a global exceptional prime
with image \(T\). Indeed, its image is \(B\) on a nonempty open
subset of that prime, so the global generic image dimension is one;
its irreducible closed image contains \(B\) and must be \(T\).
That prime has log discrepancy two on \(Y\).
The same argument for a global place shows that **every** global
place counted in (3) is on \(g\); in particular their number is finite.

To establish (2), a global \(E\) is smooth by the SNC condition and
is irreducible. Its Stein factor over the compact curve \(T\) is a
normal irreducible compact curve, finite over \(T\). Remove its
finitely many branch and critical values. Doing this for the finite
list of \(E\)'s gives (2) simultaneously.

The connected finite cover \(\widehat T_E^o\to T^o\) corresponds to a
transitive finite permutation action of \(\pi_1(T^o)\).
Surjectivity of \(\pi_1(B)\to\pi_1(T^o)\) preserves that transitivity,
so its restriction to \(B\) is still connected. The inverse image
\(E|_B\), a smooth proper family with connected fibers over that cover,
is connected. A connected complex manifold is irreducible.
Thus each such global \(E\) restricts to **one** prime, not several.
Together with (9), this proves both directions and uniqueness in (3).

Now apply this to the constructed surfaces. Terminality makes \(Y'\)
smooth at a general point of each \(S_\alpha\). Blow up its coherent
ideal and normalize. Above its dense smooth part there is exactly
one exceptional prime; the smooth codimension-two blowup has log
discrepancy two. Crepancy of \(\ell\) gives a local place \(v_\alpha\)
over \(U_B\) centered at \(B\) with the same log discrepancy.
Different \(S_\alpha\)'s give different places because their centers
on \(Y'\) differ. Theorem B gives different global primes on \(g\).
Consequently
\[
b\ \leq\ s\ \leq\ N_T,
\]
proving Theorem A. Every geometric hypothesis in the live objective
has been retained. All arguments above also apply to compact complex
\(Y\), without an ambient Kahler assumption, which proves the stated
scope extension.

## 5. A sharp, globally realized example

Let
\[
X=\{x_0x_1-x_2x_3=0\}\subset\mathbb P^4,\qquad
p=[0:0:0:0:1],\qquad Y=X\times\mathbb P^1.
\]
The partial derivatives show that \(p\) is the only singular point
of \(X\). It is a normal threefold hypersurface. Blowing up \(p\)
resolves it: the four affine blowup charts have strict-transform
equations \(a-bc=0\) or \(ab-c=0\), each with a unit partial
derivative. The singular ideal becomes the exceptional parameter.
The exceptional quadric is the smooth irreducible
\(Q\simeq\mathbb P^1\times\mathbb P^1\).
For \(g=(\operatorname{Bl}_pX)\times\mathbb P^1\to Y\) there is one
global exceptional prime \(Q\times\mathbb P^1\), and its relative
canonical coefficient is
\[
(4-1)-2=1,\qquad a=2.
\]
The same positive-coefficient discrepancy argument as (9) proves
terminality, including places above the resolution. Thus this is a
compact projective, hence compact Kahler, fourfold satisfying all
the original hypotheses, not a local germ substituted for them.

The normal line bundle of \(Q\) is \(\mathcal O_Q(-1,-1)\).
The link is its circle bundle, and the Gysin sequence computes
\[
H^2(\text{link},\mathbb Q)
=\mathbb Q^2/\mathbb Q(1,1),\qquad \dim=1.
\]
The local system along \(T=\{p\}\times\mathbb P^1\) is constant.
After any finite puncturing \(b_T=1=N_T\), so (1) is sharp.
A small resolution has exceptional curve \(\mathbb P^1\); the
tautological degree-one bundle gives the degree matrix \([1]\).
The certificate checks the displayed polynomial transforms, the
rank-four quadric, the Gysin matrix and the degree matrix exactly.
The normal-bundle, circle-bundle and Gysin identifications are
explained mathematical topology, not assertions established by Python.

## 6. Mechanical scope, controls, and downstream consequence

Run `python3 research/curve_places/verify.py`. It uses only the standard
library and compares its exact computations with `exact_certificate.json`.
No network, Jacobian service or optional numerical package is required for
replay. A saved Jacobian `matrix.rank.compute` result is independently
replayed, not trusted as an oracle.

The mechanically checked items are the sharp example's chart identities
and ranks; finite permutation-action invariant/coinvariant/orbit identities
for all ordered pairs of generators on at most four sheets; an explicit
nontrivial finite-group invariant-lift calculation; and exact rational
discrepancy sign tests with stated finite bounds.

Two negative controls prevent overinterpretation. Dropping a loop in a
two-sheet transitive permutation cover makes two local components out
of one global component. An infinite unipotent representation has a
surjective quotient for which invariant lifts fail. Neither is asserted
to be a counterexample realized by a fourfold satisfying the theorem.
They exclude only the corresponding invalid proof shortcuts.
The general geometric theorem rests on Sections 1-4, not on passing
these finite searches. No Lean file is supplied: formalizing only
averaging or orbit arithmetic would not certify the analytic implication.

The two discarded shortcuts are recorded as retired routes in the claim
ledger: working only over a simply connected disc, and using exactness
of invariants without proving finite monodromy.

For downstream impact, summing (1) over singular curves contained in
\(Q\) gives \(\sum_Tb_T\leq\tau_Y(Q)\); different centers give different
global places. With the **separate** Section 05 estimate
\[
\beta(Q)-\sum_jc_2(Q_j^\nu)\leq\sum_T b_T
\]
this proves the branch inequality. With the **separate** Section 07
local bracket bounds and positive weights on these distinct places, it
then supplies the singular-curve contribution to nonnegative junction
difficulty. Those topological, weight and descent assertions, and the
companion relative programs, remain outside this bounded mission.

The ledger records cited inputs rather than pretending they were proved
by the finite verifier. Its support verdicts are Engineer opinions only;
the scoped proof-graph goal and its obligations remain open pending
independent review. The campaign goal has not been closed. The measured
citation status has six propositions awaiting independent attribution
and two source-only standard-input groups. The mission's write boundary permits source
archives here but not `research/literature/`, where the official
`citation_check attribute` command writes; no out-of-scope archive was
created and no citation was falsely marked independently accepted.

## Appendix A. Local terminal and discrepancy facts

Here is the analytic reduction behind the standard codimension-two
smoothness input, to make its use explicit. At a hypothetical general
codimension-two singular point, slice by two general local parameters.
Klt rationality gives Cohen--Macaulayness, so these parameters form a
regular sequence. The slice is regular away from isolated points and
is normal by Serre's criterion. Take it transverse to a resolution and
its exceptional strata. Adjunction for the regular sequence restricts
the relative canonical equation to a resolution of the surface, with
all exceptional coefficients positive.

For a terminal normal surface take its minimal resolution. If any
exceptional curves remain, their intersection matrix is negative
definite. For the positive relative canonical divisor \(A\), some
\(A\cdot E<0\), hence \(K\cdot E<0\). Since \(E^2<0\), integral
adjunction forces \(p_a(E)=0\), \(E^2=-1\), and \(K\cdot E=-1\).
This contradicts minimality. Thus a terminal surface is smooth.
The transverse surface through a general singular fourfold point would
instead have embedding dimension greater than two, a contradiction.
The classical analytic negative-definiteness and contraction facts in
this surface argument are standard inputs (Grauert's exceptional-curve
criterion); this paragraph is not a formalization of that theory.
The original Grauert source was not retrieved in this mission; this
classical input remains source-only for independent review.

On a smooth space, blowing up a smooth codimension-\(c\) center has
relative canonical coefficient \(c-1\) and log discrepancy \(c\), by
the determinant of its coordinate Jacobian. Exceptional places over a
smooth space have log discrepancy at least two. Relative canonical
comparisons compose, giving the **plus** sign in (9). In particular
the coefficient \(\kappa_E\) there is \(a(E;Y,0)-1>0\), not the
log discrepancy itself and not its negative.
