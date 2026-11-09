# Uniform finite-level transfer, with the auxiliary actions retained

## Result and scope

The representation-theoretic assertion of `lem:pro-high-transfer` is valid.
The proof below works for every allowed power, not a bounded list of powers.
It never identifies the natural auxiliary action on all the growing modules
with the trivial action at a fixed marking level.

There is a useful quantitative refinement. After a preliminary shrink that
trivializes the ordinary Ext coefficient actions, **d successive p-power
restrictions kill the entire degree-d forgetting kernel**. This gives one
subgroup for an arbitrary family of comparisons with the same endpoints.
The kernel argument works over any characteristic-p field, not just a finite
one. The root/Cartier application below retains the manuscript's finite
constant field and its prescribed powers.

This is a proof of the algebraic and finite-level bridge, conditional on its
stated geometric inputs, not a proof of the coefficient or sphere theorem.
In particular, the whole integral model (`prop:mark-whole-model`),
the construction of the marked lift torsor (`prop:mark-roots`),
and the invariant-function calculation
(`cor:ind-functions`) are inputs, not newly certified results. They remain
open nodes of the campaign proof graph. No manuscript assertion has been
refuted here. Priority and publishable novelty of the refinement have not
been established; an exact-phrase literature search found no matching
quantitative statement, which is not evidence of novelty.

## 1. Precise data and quantifiers

Let k be the manuscript's finite field of characteristic p and set

\[
 A=k[[D_1,\ldots,D_d]],\quad
 A_q=A/(D_1^q,\ldots,D_d^q),\quad N_q=\operatorname{Hom}_k(A_q,k).
\]

In the application d=(m-1)(n-m)>0. An allowed q is q_0^a, where
q_0=p^{ma_0}, and h=q^{m-1}. All these powers fix k.
The translation group T has distribution algebra A. The marking group
acts continuously on each finite distribution quotient, by k-algebra
automorphisms commuting with sigma_q(D_i)=D_i^q.

The category R_U consists of rational T-representations with compatible
discrete continuous U-action, for a sufficiently small pro-p marking
subgroup U. Equivariant Ext below is Yoneda Ext in this category, not
invariants of ordinary Ext.

Fix s and nonzero classes

\[
 e_s\in\operatorname{Ext}^d_T(N_s,k),\qquad
 e'_0\in\operatorname{Ext}^d_T(k,k).
\]

Choose finite Yoneda representatives. There is an initial subgroup on
which these two representatives have trivial auxiliary action, and the
action on N_s agrees with its natural action. The theorem is

\[
 \exists U_*\ \forall q\geq s\text{ allowed}:\quad
 \lambda_q[d]\operatorname{Coind}_q(e'_0)\iota_{s,q}
       =c\,e_s
 \quad\text{in }\operatorname{Ext}^d_{R_{U_*}}(N_s,k).             \tag{1}
\]

Here iota is dual to A_q -> A_s, lambda_q is evaluation at
the socle monomial of A_q, and c is nonzero. With the canonical
monomial pairings used below, c can even be chosen independently of q.
Renormalizing the lambda_q to Cartier transfers changes c to nonzero
constants depending on q; this makes no change to the quantifier in (1).

## 2. Finite extensions and the descent spectral sequence

Let C be the finite-length A-module category and D the category of
maximal-ideal-power-torsion A-modules. A finitely generated submodule of an
object of D is finite length: finitely many generators are killed by a
common maximal-ideal power. Thus D=Ind(C).
Coulembier, arXiv:2003.12219v2, Theorem 2.2.1(1), gives equality of Yoneda
Ext between finite endpoints in C and D. Stacks tag 08XW,
Lemma 47.3.9(2), gives an ordinary A-injective resolution inside D:
embed into an injective I and replace it by its maximal-ideal-power-torsion
submodule. This submodule is injective over A and the cokernel remains
torsion. Consequently

\[
 \operatorname{Ext}^b_C(E,F)=\operatorname{Ext}^b_A(E,F)
                          =\operatorname{Ext}^b_T(E,F).          \tag{2}
\]

These are finite-dimensional and vanish above d. Indeed this holds for
E=F=k by the Koszul resolution, then for all finite-length endpoints
by their composition series and the long exact sequences in each variable.

An equivalent finite-diagram description is important here. Finite
endpoints of an extension in a comodule category admit a finite
subextension: lift a finite set of generators of the right endpoint,
then those of the new kernel, and continue; include the entire left
endpoint at the last step. Prescribed finite subdiagrams can be retained
during this construction. For a finite Yoneda zigzag, regard occurrences
of vertices as distinct, and process its finite acyclic directed path
in an order compatible with its arrows. At each new vertex retain the
images of its already chosen predecessors. This gives a finite zigzag.
This proves both finite representability and finite comparison.

For completeness the equivariant spectral sequence used here is

\[
 E_2^{a,b}(U)
   =H^a_{\mathrm{cts}}\bigl(U,\operatorname{Ext}^b_T(E,F)\bigr)
   \ \Longrightarrow\ \operatorname{Ext}^{a+b}_{R_U}(E,F).       \tag{3}
\]

There is no replacement of equivariant Ext by invariant ordinary Ext in
(3). To construct it, view U as the proconstant affine group with coordinate
coalgebra C_lc(U,k). The coordinate space of T semidirect U is
O(T) tensor C_lc(U,k). In the right-translation action of T, changing the
T-coordinate by the inverse of the retained U-coordinate identifies the
restriction of a cofree representation with a cofree T-representation.
Its T-invariants are a cofree discrete U-representation. Such U-coinduction
is exact: a locally constant function on the compact U has finite image,
whose finitely many values can be lifted across a vector-space surjection.
Cofree resolutions therefore give the spectral sequence for successive
T- and U-invariants. Tensoring by the dual of finite E gives (3).

This construction is natural under restriction to open subgroups.
Its total-degree-j filtration is finite,

\[
 H^j_U=F^0_U\supset F^1_U\supset\cdots\supset F^{j+1}_U=0,
 \qquad
 \ker(H^j_U\longrightarrow\operatorname{Ext}^j_T(E,F))=F^1_U.   \tag{4}
\]

The edge map is the forgetting map: its degree-zero U-cochain component
is the underlying T-extension. Its image lies in invariant ordinary Ext.
The (0,j) limiting term is a subspace of the (0,j) second-page term,
so (4) identifies its kernel, not just a subgroup of that kernel.

Each ordinary Ext action is discrete continuous. A finite representative
uses finitely many matrix coefficients; after shrinking U to fix these,
the endpoints, and the finite distribution quotient, give its middle
terms trivial auxiliary action. This subgroup fixes the represented class.
A finite basis then has a common open stabilizer.

Over finite k, all equivariant Ext groups are finite sets. One independent
source for the needed finite-dimensional continuous cohomology is
Emerton, Asterisque 331 (2010), section 1.2 and Propositions 2.1.9 and
2.2.6. An admissible injective resolution has finite-dimensional invariants
when the group is compact; its derived invariants are continuous
cohomology. Apply this to the finite coefficients on the second page of
(3). Only finitely many terms contribute to each total degree.
This verifies the finiteness input of `lem:pro-common-shrink`.

## 3. Two proofs of a common shrink, and the quantitative refinement

First, a direct proof of the manuscript's version needs no uniformization
of the growing coinduced representations. For one class in the forgetting
kernel, choose a finite equivariant representative and a finite ordinary
T-Yoneda comparison with zero, using section 2. Restrict U to fix the
finitely many modules of the original representative. Restrict further
to fix the finite translation coefficients of the comparison. Give the
comparison terms trivial auxiliary action. All its arrows are then
equivariant, so this one class vanishes after restriction.
The kernel is finite over finite k. The intersection of the finitely
many subgroups for its elements kills the entire kernel. These are
classes with fixed endpoints E,F, not one class chosen separately for
every q.

Here is a stronger, parameter-universal argument. It also explains why a
finite coefficient field is unnecessary for common shrinking.

**Restriction theorem.** Let k be any characteristic-p field, with finite
endpoints E,F, and suppose the ordinary T-Ext coefficients in degrees
0 through j are finite-dimensional and discrete continuous. Choose
a sufficiently small uniform subgroup U_0 acting trivially on these
coefficients. Put U_a=U_0^{p^a}, using the iterated closed power subgroups.
Then restriction from U_0 to U_j kills the degree-j forgetting kernel.

Only the following power-tower property is used: each U_a has
mod-p cohomology generated under cup products by H^1. For the marking
groups one may first choose a sufficiently small equi-p-valued subgroup;
its ordered power bases give the same property for every U_a.
Lazard, Chapter V, 2.2.7.1, supplies such an open subgroup, and
Proposition 2.5.7.1 supplies the exterior cohomology algebra.
Equivalently, for a uniform group with ordered generators g_i, its
standard valuation is
t+min_i v_p(z_i) on product_i g_i^{z_i}, with t=1 for odd p and t=2 for
p=2. The power subgroups have ordered bases g_i^{p^a} and are again
equi-p-valued. The distinction t=2 is needed at p=2:
powerfulness there means [U,U] is contained in U^4.

For trivial coefficients,

\[
 \operatorname{res}:H^a(U_b,k)\longrightarrow H^a(U_{b+1},k)
       \text{ is zero for }a>0.                                \tag{5}
\]

Indeed a continuous homomorphism U_b -> (F_p,+) kills all pth powers,
so restriction kills H^1. Cup-product generation kills every positive
degree. Scalar extension from F_p to an arbitrary k is valid on the
continuous cochain complexes: every locally constant function from a
compact space has finite image, contained in a finite-dimensional
F_p-subspace. Tensoring is exact. The same assertion holds with any
trivial finite-dimensional k-vector coefficient.

Apply (5) to every positive-a column of the second page of (3).
Naturality makes the maps zero on the corresponding limiting terms.
Thus, for 1<=a<=j,

\[
 \operatorname{res}_{U_{b+1}}^{U_b}(F^a_{U_b})
                        \subset F^{a+1}_{U_{b+1}}.              \tag{6}
\]

Starting with the kernel F^1, j successive restrictions put it in
F^{j+1}=0. This proves the theorem, including j=0, when the kernel is
already zero. Notice that (6) does not say that one restriction
necessarily kills the kernel; hidden higher-filtration components are
the reason for the j steps.
If U_0 has uniform rank e, this additional shrink has index p^{ej}:
each consecutive power subgroup has index p^e. This index statement
precedes any optional further refinement to a normal product subgroup.

An arbitrary proper open subgroup is NOT sufficient for (5).
For example restriction in H^1 from Z_p^2 to p Z_p x Z_p preserves
the second coordinate. That false assertion appeared in a web-search
summary, not in the staged manuscript or in the primary source. It is
not used here.

## 4. The ordinary top coefficient: all parameters, with signs

Let A^(q)=k[[D_1^q,...,D_d^q]]. The monomials D^alpha,
0<=alpha_i<q, form an A^(q)-basis of A. Let kappa_q extract the
coefficient of D_1^{q-1}...D_d^{q-1} in this relative basis.
The pairing kappa_q(ab) identifies

\[
 A\otimes_{A^{(q)}}E
       \simeq\operatorname{Hom}_{A^{(q)}}(A,E).                 \tag{7}
\]

Its basis matrix is the complementary-monomial permutation matrix.
In one coordinate 0<=alpha,beta<q, a sum congruent to q-1 modulo q
can only be q-1: the alternatives are negative or at least 2q-1,
outside [0,2q-2]. Tensoring the coordinate pairings proves (7)
in every dimension. This is a plain-module identification; no
equivariance of kappa_q is asserted.

Its specialization at E=k is

\[
 \alpha_q:A_q\longrightarrow N_q,\quad
 \alpha_q(a)(b)=[D^{(q-1){\bf1}}](ab).
\]

A direct multiplication gives

\[
 \alpha_q^{-1}\iota_{s,q}\alpha_s(a)
       =D^{(q-s){\bf1}}a,\qquad
 \lambda_q\alpha_q(a)=a(0).                                    \tag{8}
\]

For the first equality, extract the top coefficient after multiplication
by the displayed monomial; it selects exactly the smaller top coefficient,
and factors through A_s. For the second, evaluate at the socle monomial.

Use the cohomological Koszul resolution K_s in degrees -d through 0.
On the exterior basis e_I its differential is

\[
 d_s(e_I)=\sum_{j\in I}(-1)^{\operatorname{pos}(j,I)}
                         D_j^s e_{I\setminus\{j\}}.
\]

For any integers q>=s>=1, the lift of (8) from K_s to K_q is

\[
 f_I=\prod_{j\notin I}D_j^{q-s}.                               \tag{9}
\]

For a removed coordinate j, the two sides of the chain-map identity
have exponent q and s+(q-s), respectively. Every other coordinate
has the same exponent on both sides. The exterior sign is the same
position on both sides. Hence (9) is a chain map in arbitrary dimension,
including q=s. Its coefficient in the top exterior degree is the empty
product, exactly 1, not a q-dependent nilpotent or zero scalar.

Let z_i denote the parameters on the source copy of A^(q).
A representative of the generator of Ext^d(k,k) is top projection
from the Koszul resolution on z_1,...,z_d followed by augmentation.
Exact extension of scalars in (7) changes this resolution into K_q;
the coinduced extension is represented by top projection to A_q[d].
Pushing out by lambda_q is top projection followed by augmentation to k.
Pulling back along (8), using (9), leaves that top coefficient equal to 1.
This proves that the ordinary composite is a nonzero generator.
If e'_0 and e_s have top coefficients a_0 and a_s, respectively, its
coefficient relative to e_s is c=a_0/a_s, independent of q.

Successive pairings are coherent: for q=st the selected exponent in
one coordinate is

\[
 (s-1)+s(t-1)=st-1.                                           \tag{10}
\]

The tensor product proves the same statement in all coordinates.
This also checks the direction of the inclusion and of the augmentation;
reversing the Yoneda pullback would not give (9).

## 5. Restoring the actual auxiliary actions

Choose an initial pro-p uniform marking group on which the fixed
finite diagrams for e_s and e'_0 have trivial auxiliary action, with
N_s carrying its natural action. The inclusion sigma_q commutes with
the marking action. Therefore coinduction of e'_0 has its natural
semidirect-product action for every q at this very same subgroup.
Indeed, on a parameter, sigma_q(u(D_i)) and u(D_i)^q are the same
formal series: q is a p-power and fixes every coefficient in k.
The inclusion N_s -> N_q is equivariant, since it is dual to an
equivariant quotient.

The line Hom_T(N_q,k) is one-dimensional and has continuous auxiliary
action. A pro-p group has no nontrivial continuous character to k^*:
its image is a finite p-group, and a characteristic-p field has no
nontrivial p-power roots of unity. Thus the canonical nonzero lambda_q
is equivariant for every q. No simultaneous triviality of N_q is needed.

Consequently every difference

\[
 \delta_q=\lambda_q[d]\operatorname{Coind}_q(e'_0)\iota_{s,q}
                                      -c e_s
\]

belongs to the ONE group
Ext^d_{R_{U_0}}(N_s,k), and section 4 puts every delta_q in its
forgetting kernel. Refine U_0, once, to trivialize the finitely many
ordinary Ext coefficient actions for this fixed pair in degrees 0
through d. Section 3 now kills every delta_q on U_0^{p^d}.
One further normal product congruence subgroup contained in it may be
chosen if that indexing convention is required. Restricting an equality
preserves it. This proves (1), with the original quantifier order.

## 6. Root/coinduction compatibility over one fixed marking base

Here the geometric input must be stated, rather than silently replaced
by a formal-module identity. Put R_infty=colim B_V at full markings.
The manuscript's lift-torsor input is the affine T-torsor P with

\[
 O(P)=R_\infty^{\mathrm{perf}},\quad
 P/[p^\ell]T=\operatorname{Spec}R_\infty^{1/h},
 \quad \ell=(m-1)a_0a,\ h=p^{m\ell}.                            \tag{11}
\]

The Honda relations give Fr_h(tz)=[p^\ell]t Fr_h(z).
On P absolute h-powering is an isomorphism, and on T it identifies T
with the subgroup [p^\ell]T, not with all of T. The equations commute
with the auxiliary marking actions and with G. These are precisely
the source hypotheses used here; (11) has not been re-proved by the
polynomial calculation in section 4.

Over full markings, evaluation of coinduced equivariant functions gives
the natural induction-in-stages isomorphism

\[
 V_{\operatorname{Coind}_q(E)}
       \simeq\pi_* (V_E\text{ on }P/[p^\ell]T)
       \simeq (V_E)^{1/h}.                                    \tag{12}
\]

One can check this after a faithfully flat torsor trivialization:
evaluation identifies a T-equivariant coinduced function with an
[p^\ell]T-equivariant E-valued function on P. Explicitly use a right
torsor and left representations. Write H=[p^\ell]T and realize
coinduction as functions F with F(ht)=h F(t), with
(g F)(t)=F(tg). A section Phi satisfies Phi(zg)=g^{-1}Phi(z).
Evaluation sends it to psi(z)=Phi(z)(1); then
psi(zh)=h^{-1}psi(z). Its inverse is
Phi(z)(t)=psi(zt^{-1}). These two formulas are inverse and verify the
stated equivariance, including the inverse in the associated-bundle
convention. They work functorially on group-scheme points and hence
on the coordinate comodule. Neither requires a chosen torsor point.
The power identity identifies the latter
associated bundle with the transported root bundle. Evaluation and its
inverse commute with marking changes, G, and every E-arrow. Applying
evaluation twice is evaluation for induction in stages. The equalities
Fr_{h_1} Fr_{h_2}=Fr_{h_1h_2} and
[p^{ell_1}][p^{ell_2}]=[p^{ell_1+ell_2}] give coherence of (12),
not merely equality of its ranks.

Fix U contained in the subgroup of section 5, and put R=B_U.
This base does not vary in the following argument.
The full lift object over R is a pro-torsor for T semidirect U.
For each fixed finite representation diagram, including a coinduced
diagram, choose L and an open normal U' in U fixing the finite
translation quotient and the diagram. Then

\[
 [p^L]T\rtimes U'\ \triangleleft\ T\rtimes U.
\]

Indeed [p^L]T is U-stable, U' is normal, and translation conjugation
of U' changes its translation coordinate only by [p^L]T because U'
acts trivially on T/[p^L]T. The quotient cover is finite faithfully
flat over THIS R, with group
(T/[p^L]T) semidirect (U/U'). It descends the finite associated bundles,
their arrows, and their exactness, by Stacks tag 023N.
The cover and U' can depend on q. They are covers of R, NOT
new choices of the marking base.

Here is also a direct check on the root base in (12).
Powering is a U-equivariant bijection
R_infty^{1/h} -> R_infty, hence

\[
 (R_\infty^{1/h})^U=(R_\infty^U)^{1/h}=R^{1/h}.                \tag{13}
\]

Relative Frobenius for an etale algebra is an isomorphism
(Stacks tag 0EBS). Passing through the finite etale marking algebras
and then their filtered union gives
R_infty tensor_R R^{1/h}=R_infty^{1/h}.
Thus the right side of (12) is the descent of the root of V_E over
the fixed R, with restriction of scalars from R^{1/h} to R.
Its rank is h^r dim_k E=q^d dim_k E, not dim_k E.
The U-equivariance of evaluation makes the descent data on both
sides agree. Faithful flatness then descends (12) and every arrow
to R, for ALL q, without trivializing the high auxiliary actions.
This proves the finite-stage assertion needed from `prop:trans-roots`.

## 7. Cartier normalization and actual G-cochain operations

The additional geometric input used for normalization is that an
invariant algebraic unit of a finite marked coefficient model is a
constant in k. This is the consequence of `cor:ind-functions` stated
explicitly in the manuscript. A root unit has the same property:
its hth power is invariant in R, and k is perfect.

At one sufficiently deep marking stage fix the first Frobenius
translation quotient and a basis of its Lie space. For m>1 it is
alpha_p^r. Its action on R^{1/p} gives a frame of R-derivations delta_i.
The operators

\[
 \partial_i(b)=(\delta_i(b^{1/p}))^p
\]

are k-linear derivations of R. In a p-basis their coefficient matrix
is the pth power of the invertible matrix for delta_i, so they give
a frame. They commute with G, since the torsor action and powering
do. The dual top wedge is a G-invariant volume eta at this fixed stage.

The p-basis Cartier formula shows that

\[
 T_{\eta,h}(z)=\operatorname{Cartier}^{\log_p h}(z^h\eta)/\eta
\]

is R-linear and a generator of
Hom_R(R^{1/h},R) as an R^{1/h}-module. The complementary-monomial
pairing proves perfectness, including for the formal power series
and finite etale coefficients in use here.

The nonzero invariant integral of a finite translation quotient has
the same generator property. To see it on its local finite Hopf
algebra H, the radical of (a,b) |-> lambda(ab) is a translation-stable
ideal. If it is proper it lies in the augmentation ideal. Applying
id tensor counit to its coaction forces the radical to be zero.
It cannot be the whole algebra because lambda is nonzero.
For clarity, translation stability follows from the invariant-integral
identity
sum a_(1) lambda(a_(2)b) = sum S(b_(1)) lambda(a b_(2)).
If a is in the radical the right side is zero for every b, so its
coaction lies in H tensor radical. This identity follows by inserting
invariance into its right side and using the antipode identity.
The resulting perfect pairing descends from a torsor trivialization.
Thus the augmentation tau_q on the root algebra has the form
T_{\eta,h}(u_q z), for a UNIQUE source unit u_q.

G-equivariance and uniqueness make u_q invariant. The preceding
invariant-unit input makes it a nonzero element of k, not just a unit
of the root ring. In particular tau_{q_0}=c_0 T_{\eta,h_0}.
Equation (10) and the whole-diagram coherence (12) show that the
iterated canonical augmentation is tau_{q_0^a}. Cancellation of the
intermediate volume factors gives, after powering,

\[
 \tau_{q_0^a}=c_0^a S^a,\qquad
 S(f)=\operatorname{Cartier}^{\log_p h_0}(f\eta)/\eta.            \tag{14}
\]

All constants are untwisted because the powers fix k.
This supplies the part of `prop:trans-cartier` needed for the
cochain comparison. The geometric invariant-unit premise is essential
and remains an explicit dependency of the audit.

The whole-model pole bound also uses just one matrix. Retain the stated
finite free model A' over the parameter ring and its basis b_i.
The map T_{\eta,h_0}, extended by projection e and then inclusion into
A'[1/x], is a finite matrix over the localized parameter ring, in the
root basis b_i^{1/h_0} t^{alpha/h_0}, 0<=alpha_i<h_0. Its entries have
a common pole bound c. Expanding the root of f in x^{-D}A' in that
basis gives

\[
 S(x^{-D}A')\subset
       x^{-\lceil D/h_0\rceil-c}A' \quad(D\in\mathbb Z).
\]

In particular D_{a+1}<=D_a/h_0+c+1 bounds successive pole orders.
Its geometric-sum solution is
D_a<=h_0^{-a}D+(c+1)(1-h_0^{-a})/(1-h_0^{-1}).
Any integer D_0>(c+1)/(1-h_0^{-1}) gives a stable lattice and eventually
contains every fixed bounded-pole lattice under iteration. This is
the bound for the ONE normalized S; its proof does not choose a new
matrix at each iterate.

Now fix any ONE U contained in U_* and a finite diagram for e'_0.
The associated diagram consists of finite locally free R-modules,
including its kernels. Every successive surjection therefore has
an R-linear section. Choose these sections once. They need NOT be
G-equivariant, nor come from T-equivariant splittings.
Successive lifting and group differentials define the connecting
cocycle operator B for e'_0.

Root transport is a functor on R-modules and R-linear maps, not just
on representation arrows. Conjugate the roots of these chosen
sections by (12) to obtain sections of the coinduced diagram.
This is legitimate even though the original sections are not
representation maps: (12) commutes with the surjections they split.
Powering identifies these root sections with the original sections
and commutes with every G-cochain differential. Therefore the
coinduced connecting operator is conjugate to the ONE fixed B.

Apply the exact associated-bundle functor to the equality (1).
Equality of finite Yoneda classes gives equality of connecting
operations on actual continuous G-cohomology: finite comparisons
descend to the covers in section 6, and the long exact sequences
are natural. Continuous cochain exactness can also be seen directly
by the chosen R-linear sections, which have bounded denominators
on each bounded-pole coefficient step.
For a cocycle w with values in R^{1/h_s}, inclusion into R^{1/h}
and (14) now give

\[
 c\, e_s[w]=c_0^a S^a[\mathcal B(w^h)],
 \qquad q=q_0^a\geq s.                                       \tag{15}
\]

Both sides are in the actual H^{j+d}_{cts}(G,R) at this fixed U.
This is `eq:pro-boundary-transfer`, up to the permitted nonzero
scalar. It is neither an equality only after forgetting auxiliary
actions nor an equality only in a germ of marking levels.

Finally B has a fixed pole loss C_U. Choose finite projective
realizations and whole lattices for the finitely many bundles.
The fixed sections are finite matrices with bounded x-poles.
Compactness of G and the bounded-step topology give one action bound;
g(x)/x is an integral unit, so translating lattices by powers of x
does not change that bound. The finitely many lifting and differential
steps have a total fixed loss C_U. After the fixed root denominator
is cleared, a positive representative has order tending to infinity
under its hth powers. Thus the order of B(w^h) is at least that
growing order minus C_U. The estimate is for B, not for separately
chosen operators on the increasing coinduced diagrams.
No bound uniform over different U is required.

## 8. What the executable evidence proves

`verify.py` uses only the Python standard library. It checks the exact
coefficient identities underlying (7)--(10), the signed Koszul
comparison, and the affine filtration-shift induction underlying (6).
These are coordinate/induction schemas for arbitrary dimension and
parameters, not a search through finitely many parameter values.
It also independently replays the one finite rational chain-map
diagnostic returned by Jacobian 0.14.0, with its exact input bound to
the saved output. That diagnostic is explicitly NOT an infinite-parameter
certificate or evidence about equivariant Ext.

The existence and naturality of (3), the interpretation of its
filtration, the geometric inputs (11) and the invariant-unit premise,
and the descent and cochain argument in sections 5--7 are mathematical
proof obligations for the independent Reviewer. The executable does
not represent them as kernel-checked facts. No Lean file is claimed.

Compared with the manuscript's finite-cardinality common-shrink
argument, the refinement gives the explicit d-step restriction bound
and additional index p^{rank(U_0)d}, and removes the finite-field
requirement from the kernel theorem. Canonical ordinary normalizations
also make the Ext scalar independent of q, whereas the manuscript
allows a different scalar for every q. The finite-base root and
cochain argument independently verifies an already asserted bridge;
it is not claimed to be a novel theorem merely because it was re-proved.
The other geometric, countability, coefficient, descent, and novelty
nodes are not closed.

The primary-source excerpts are in `literature/`. The official citation
attribution command has a fixed archive destination
`research/literature/`, outside this mission's writable paths. It has
not been run under a different project root or patched to evade that
boundary. Its ledger queue therefore remains open for the normal
independent review path; saved source readings are not mislabeled as
automatic citation-check certificates.
