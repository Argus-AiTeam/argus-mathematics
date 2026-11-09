# Family-orbit localization for a projective completion

## Statement under investigation

Let \(B\) be smooth, connected and projective over \(\mathbb C\), and let
\(E\) be an algebraic vector bundle of rank \(r\geq2\). Use the convention
of lines for projective bundles. After a line-bundle twist making \(E^*\)
globally generated, put
\[
X=\mathbb P_B(E),\qquad W=\mathbb P_B(E\oplus\mathcal O).
\]
The torus has weight zero on \(E\) and weight one on \(\mathcal O\).
The question is Proposition `loc:factorization`, in the staged
`build/sections/04-localization.tex`: whether one upper symplectic series
\(R(z)\), congruent to the identity in positive total Novikov filtration,
simultaneously satisfies
\[
S_W(z)=R(z)\bigl(S_{B,\mathrm{tw}}(u_B,z)\oplus
S_{X,\mathrm{tw}}(u_X,z)\bigr),\qquad
\mathcal A_W(0)=c\,U_R\bigl(\mathcal A_{B,\mathrm{tw}}(u_B)
\mathcal A_{X,\mathrm{tw}}(u_X)\bigr).
\]
The two expansions of a rational function of \(z\) must not be identified.
The first fundamental solution is initially expanded at infinity; its
factorization is read after expansion at zero. Full cohomology and actual
integral curve classes, not only numerical degrees, are part of the question.

## Scope settled before the calculation

1. Coates--Givental--Tseng, *Virasoro constraints for toric bundles*,
   Forum Math. Pi 12 (2024), e4,
   DOI `10.1017/fmp.2024.2`, Section 3.1, Proposition 3.1 and Theorem 3.5,
   prove the common-\(R\) factorization for their toric bundles.
   Their fixed components are sections isomorphic to the base; each
   orbit-direction family is another copy of that base. This does not
   directly identify the evaluation correspondences of the present
   coarser one-dimensional torus action, even when \(E\) splits.
   Primary source read:
   <https://doi.org/10.1017/fmp.2024.2>.
   Its Remark 3.7 explicitly anticipates the general torus-action
   factorization while leaving systematic leg moduli and their virtual
   classes as foundational work. The simplified web extraction omitted
   that remark; the primary publisher HTML was checked directly.
   Consequently the abstract common-\(R\) formula is not a new conjecture
   of this audit. The unresolved content is its geometric justification
   in this particular family, with the stated coefficient conventions.
2. Fan, *Chern classes and Gromov--Witten theory of projective bundles*,
   `arxiv:1705.07421v2`, Theorem A (= Theorem 1.1) and Section 0.2,
   gives all-genus Chern-class dependence and uses the same projective
   completion. The stated curve labels in Theorem A are in \(N_1\).
   Reconstruction or equality indexed by numerical classes does not by
   itself give the common-\(R\) assertion with individual integral labels.
   Primary source read:
   <https://arxiv.org/html/1705.07421v2>.
3. Iritani--Koto, *Quantum cohomology of projective bundles*,
   `arxiv:2307.03696v4`, Theorem 1.7 and Corollary 1.8, provide a localized
   quantum \(D\)-module decomposition and the equivalence of generic
   semisimplicity. These are genus-zero statements, at a different
   localization in the fiber parameter; they do not supply the desired
   ancestor identity at all genera.
   Primary source read:
   <https://arxiv.org/html/2307.03696v4>.

These are scope comparisons, not unproved substitutes for the proposition.
The route "apply the split toric-bundle theorem verbatim" is excluded:
the tangent class at a \(B\)-endpoint is a class on the orbit-cover
gerbe over \(X\), not generally the pullback of a class on \(B\).
No claim of novelty or manuscript refutation follows from that distinction.

The inherited Wiki index was searched for the campaign, Virasoro,
projectivization and the cited authors; it contains no applicable entry.
No earlier result beyond the umbrella objective is present in the
campaign claim ledger.

## Load-bearing obligations

The proposed proof must establish the orbit-cover gerbe with its two
tangent characters, the compatible virtual gluing (not merely its
virtual rank), the preservation of *joint* endpoint moments under linear
dressing and diagonal contractions, the two-point determination of \(R\),
the descendant-background vertex conversion, and the stable-graph Wick
assembly with the very same \(R\). Coefficientwise finiteness must retain
the actual curve labels throughout.

## Verification theorem

**Theorem.** With the manuscript's conventions, Proposition
`loc:factorization` holds. Its \(u_B,u_X,R\) are unique among solutions
with positive Novikov filtration. More generally, the same statement
holds for an arbitrary algebraic \(E\), without first twisting it,
provided the Novikov completion uses an ample class on \(W\) and allows
the actual effective integral labels \((\beta,l)\), with \(l\in\mathbb Z\).
In this more general statement \(l\) is not asserted to be nonnegative.
One must not identify the two different master spaces before and after
a line-bundle twist.

The proof below is an all-orders mathematical proof using the stated
standard geometric theorems. Its finite-moment algebra is separately
kernel checked. The entire geometric theorem is **not** formalized in
Lean. Independent review of the proof, statement fidelity, citations,
significance and novelty remains outstanding.

### Geometric theorems used

We use virtual localization for the usual equivariant perfect obstruction
theory of stable maps to a smooth projective target: Graber--Pandharipande,
*Localization of virtual classes*, `arxiv:alg-geom/9708001v2`,
Introduction, equation (1), and its stable-map application there.
We also use functoriality of virtual pullbacks for **compatible**
perfect obstruction theories: Manolache, *Virtual pull-backs*,
`arxiv:0805.2065v2`, Definition 4.5, Theorem 4.8 and Corollary 4.9.
The quotient-stratification and compatibility hypotheses of that result
are checked below; an equality in \(K\)-theory alone would not suffice.

For genus zero we use the string, dilaton, splitting and topological
recursion identities, including the overruled-cone description and
the two-point identity. The precise normalization used here is that
of CGT, Section 3.4, equations (8)--(11) and the proof of Proposition 3.1.
For conversion of a descendant background and upper quantization we
use CGT, Proposition 3.6 and Section 3.5, equation (19), respectively.
The former explicitly applies to general GW-type theories, including
twisted theories. These standard identities, not a semisimple
reconstruction theorem or a splitting principle for \(E\), are the
external inputs.

### 1. The orbit-cover stack and its obstruction theory

An irreducible moving component projects to a point of \(B\): the torus
acts trivially on \(B\), and its nonconstant orbit on the component is
dense. Its image is therefore the line from \(b\in B\) to some
\(x\in X_b\). Equivariance forces a degree-\(m\) cover to have local
form \(t\mapsto t^m\). A self-node would identify the two endpoints,
whose images are different. Thus the component is smooth rational,
and its special points are among its two endpoints.

For each admissible endpoint-marking/attachment status, its stack is
\[
\mathfrak L_m=\sqrt[m]{\mathcal O_X(-1)/X}.
\]
If \(M^m=q_m^*\mathcal O_X(-1)\), its universal map is
\(\mathbb P(M\oplus\mathcal O)\to
\mathbb P(M^m\oplus\mathcal O)\to W\).
Changing a root changes this presentation by exactly its deck
automorphisms. This proves the gerbe identification in families,
not only on geometric points. The stack is smooth proper DM;
its rational cohomology is that of \(X\), and \(q_{m*}1=1/m\).
The endpoint maps are \(q_m\) and \(\pi q_m\).

On a covered fiber line,
\[
f^*T_{W/B}=\mathcal O(2m)\oplus
\mathcal O(m)^{\oplus(r-1)},\qquad
f^*\pi^*T_B=T_{B,b}\otimes\mathcal O.
\]
Both have vanishing \(H^1\). This conclusion uses the exact tangent
sequence, not a splitting of \(E\). Hence the ambient stable-map
stack is smooth along the leg, and its fixed obstruction theory
is the tangent theory of \(\mathfrak L_m\).

The tangent lines at the two endpoints of the universal cover are
dual. With \(p_X=c_1(\mathcal O_X(1))\),
\[
a_X=(\lambda+q_m^*p_X)/m,\qquad
a_B=-(\lambda+q_m^*p_X)/m.                    \tag{1}
\]
This follows from \(\operatorname{Hom}(M,\mathcal O)\) at \(X\)
and \(\operatorname{Hom}(\mathcal O,M)\) at \(B\), after the
degree-\(m\) torus cover. In particular the ordinary part at a
\(B\)-endpoint need not descend to \(B\).
At a node between two legs in the same fixed component the scalar
smoothing character is
\(\pm\lambda(1/m+1/m')\), never zero. A node between a leg and a
fixed-map piece has scalar character \(\pm\lambda/m\), also nonzero.

There is an independent explicit check of the entire moving leg
complex, in every degree. Temporarily mark both endpoints and put
\(a=(\lambda+q_m^*p_X)/m\) and
\(P_E(t)=\sum_{i=0}^r q_m^*\pi^*c_i(E)t^{r-i}\).
The moving Euler class is
\[
 e_T(N^{\mathrm{vir}}_{\mathfrak L_m,\;2\mathrm{pt}})
       =m!\,a^m\prod_{k=0}^{m-1}P_E(-\lambda+k a).           \tag{1a}
\]
This formula does not include the separate gerbe pushforward
factor \(1/m\). To prove it, apply the relative projective Euler
sequence on the universal cover. In \(K\)-theory,
\(R\rho_*\mathcal O_{\mathbb P(M\oplus\mathcal O)}(m)
=\bigoplus_{k=0}^m M^{-k}\otimes
\mathbb C_{-(m-k)\lambda/m}\).
Tensor with \(q_m^*\pi^*E\oplus\mathbb C_\lambda\), subtract
the Euler-sequence trivial line, and subtract the automorphism
line of the twice-pointed rational domain. Both subtracted
lines are fixed. The remaining fixed part, together with the
base tangent, is
\(q_m^*\pi^*T_B+q_m^*\pi^*E\otimes M^{-m}-1=T_X\).
The moving summands are precisely
\[
\bigoplus_{k=0}^{m-1}
 q_m^*\pi^*E\otimes M^{-k}\otimes\mathbb C_{-(m-k)\lambda/m}
\quad\oplus\quad
\bigoplus_{k=1}^m M^{-k}\otimes\mathbb C_{k\lambda/m}.
\]
Their Euler classes give (1a). All their scalar characters are
nonzero, so there is no hidden vanishing denominator. Forgetting
an endpoint divides this Euler class by its tangent \(a_F\);
equivalently its localization contribution is multiplied by
\(a_F\). This follows from the relative tangent of the
mark-forgetting morphism, not a choice of unstable sign.

### 2. Compatible diagonal gluing, including excess intersections

Label the cut branches. Let \(P_\Gamma\) be the product of the
fixed-target stable-map stacks and the leg gerbes, and let
\[
Z_\Gamma=P_\Gamma
 \mathop{\times}_{\prod_q(F_q\times F_q)}\prod_q\Delta_{F_q}.
\]
Here an entire connected fixed-map piece, including its internal
boundary, is one stable-map factor. Thus no transversality or flatness
of its evaluation maps is being assumed. The diagonals of the smooth
fixed varieties are regular embeddings, and their refined pullback
is defined even when the displayed intersection has excess dimension.

Gluing the normalized universal curves gives the branch-labeled
fixed-map stratum. Conversely, normalization at all nodes incident
to legs recovers \(Z_\Gamma\). Taking the finite graph quotient
recovers the unlabelled stratum; deck stabilizers already belong to
the gerbes.

The compatibility required for the virtual class follows from the
**relative normalization sequence of sheaves on these universal
curves**, followed by derived pushforward:
\[
R\rho_*f^*T_W\longrightarrow
\bigoplus_\alpha R\rho_{\alpha*}f_\alpha^*T_W
\longrightarrow\bigoplus_q\operatorname{ev}_q^*T_W.       \tag{2}
\]
The evaluation difference in this sequence is the differential of
the diagonal constraint. Consequently (2) maps to the cotangent
triangle of that Cartesian constraint; it is a compatible triangle
of obstruction theories, not an arbitrary decomposition of ranks.
Adding the pointed-domain deformation complexes adds the smoothing
lines \(T_{q,+}\otimes T_{q,-}\). Formation of (2) commutes with
base change, so this compatibility holds over the whole stratum.

On a fixed-map factor the connected torus acts trivially on the
pointed stable map: its automorphism group is finite. Thus the fixed
map-deformation complex there is its ordinary \(F\)-theory. On a
leg it is \(T_{\mathfrak L_m}\); the fixed node term is \(T_F\).
Every new smoothing line is moving by (1). Taking fixed parts of
(2), an exact operation for torus representations, therefore gives
precisely the obstruction theory of the displayed diagonal
pullback. Standard stable-map stacks have quotient presentations
using embedded domains; the gerbe is a quotient of the complement
of the zero section in a line bundle by \(\mathbb G_m\).
Products, these diagonal fiber products, and finite graph quotients
admit the quotient stratifications required by Manolache's theorem.
Over the appropriate finite-type prestable-domain strata the domain
base is smooth, hence pure dimensional. All the relative morphisms
are DM type.

Functoriality for these compatible theories now yields
\[
[Z_\Gamma]^{\mathrm{vir}}
 =\Delta^!\left(
       \mathop{\boxtimes}_v[\overline M_v(F_v)]^{\mathrm{vir}}
       \boxtimes\mathop{\boxtimes}_e[\mathfrak L_{m_e}]
           \right).                                      \tag{3}
\]
The construction and the compatible triangle work simultaneously
at all cut nodes, so (3) includes cycles and self-contractions.
It does not require the evaluation map to a product of diagonals
to be transverse.

The moving part consists of the inverse-Euler twists
\(R\rho_*f^*N_F\), the moving leg complexes, the node terms
\(-N_F\), and the smoothing lines. In particular a leg/fixed-vertex
flag contributes
\[
                 e_T(N_F)/(a-\psi).                       \tag{4}
\]
The numerator makes its contraction use the inverse of
\(\eta_F^t=\int_F(\,\cdot\,)/e_T(N_F)\).
At an external endpoint there is no smoothing denominator and its
map cotangent is \(-a\). These observations also fix the signs in
the subsequent two-point formulas.

### 3. Joint moments are preserved, not replaced by marginals

Let a proper cut correspondence have \(k\) attachment flags, joint
evaluation \(e\) to the product of fixed targets, coefficient \(C\)
including its virtual/Euler factors, and even tangent parts
\(\nu_1,\ldots,\nu_k\). Put \(D=\dim X\). Each \(\nu_i\) is pulled
back from a leg gerbe, so \(\nu_i^{D+1}=0\), including after gluing.
Retain the complete tensor-valued family
\[
h_{j_1,\ldots,j_k}=
e_*\left(C\prod_i\nu_i^{j_i}\right),\qquad 0\leq j_i\leq D.       \tag{5}
\]
No factorization of (5) is assumed.

For an invertible scalar \(t\) the identity
\[
(t+\nu)^{-1}
=t^{-1}\sum_{j=0}^{N-1}(-\nu t^{-1})^j,\qquad \nu^N=0,          \tag{6}
\]
has remainder \((-\nu t^{-1})^N\). Multiplication by \(t+\nu\)
proves (6), and also uniqueness of the inverse. This is exactly
the all-\(N\) ring statement compiled in `Main.lean`.
Taking \(t=a_0-s\) gives the flag denominator, with its correct
alternating sign.

More generally, scalar rational identities regular at the nonzero
characters \(a_{i0}\) can be evaluated at \(a_{i0}+\nu_i\) by their
finite Taylor expansions. If the scalar kernels have state-space
operators \(K_i(\alpha_i)\) as coefficients, the evaluation is
\[
\sum_{j_1,\ldots,j_k}
\left(\bigotimes_i
       \frac{\partial_{\alpha_i}^{j_i}K_i(a_{i0})}{j_i!}\right)
h_{j_1,\ldots,j_k}.                                         \tag{7}
\]
The derivatives in (7) act only on \(K_i\); they do not
differentiate \(C\), the moments, \(u_F\), or their dependence on
\(\lambda\).

To see why (7) agrees with actual gluing, first apply the finite
expansion on the cut stack. Projection formula and (3) identify
composition with the fixed-target evaluation correspondences with
linear operations on (5). A subsequent linear contraction commutes
with this finite sum. Contraction of several distinct cut pieces
is multilinear, so it expands as the sum over all joint indices.
This proves (7) for every finite localization graph, including
both ends of a bridge incident to the same vertex. The Lean
theorems `joint_moment_naturality`, `joint_dressing_naturality`
and `all_flag_contraction` certify exactly these algebraic steps,
for arbitrary finite index sets and truncation orders.

Replacing (5) by products of separately pushed moments would be
wrong. For \(X=\mathbb P^2\to\mathrm{pt}\), two \(B\)-flags with
multiplicities \(2,3\), \(C=1\), \(\lambda=1\), and \(s=s'=0\),
the joint pushforward of the two reciprocal tangents is \(18\);
the product of the two marginal pushforwards is \(6\).
`verify.py` checks this example and the correct joint formula with
arbitrary \(C=c_0+c_1H+c_2H^2\).
**This is not a counterexample to the manuscript:** its definition
explicitly uses the joint moments.

### 4. Determination of the common upper factor

Unmarked outgoing genus-zero trees define a positive-filtration
background \(\epsilon_F(s)\) at a fixed-map vertex. The overruled
cone identities give a unique primary parameter \(u_F\) such that,
with \(S_f=S_{F,\mathrm{tw}}(u_F,z)\),
\[
x_F(z)=[S_f(z)(\epsilon_F(z)-u_F)]_+\in zH_F[[z]].              \tag{8}
\]
The constant-term equation has linearization \(-\mathrm{id}\);
therefore formal induction in ample degree gives existence and
uniqueness of \(u_F\). No semisimplicity is involved.

For scalar independent \(w,z\), the Hessian/two-point identity is
\[
\frac{\eta_F^t(b,c)}{w+z}
+\left\langle\frac b{w-\psi},\frac c{z-\psi}
                \right\rangle_{0,\epsilon_F}
=\frac{\eta_F^t(S_f(w)b,S_f(z)c)}{w+z}.                       \tag{9}
\]
Every coefficient in (9) is rational in these variables.
Use (7) whenever a tangent class replaces \(w\).
Keeping the path from the primary marked point to the descendant
marked point in a localized two-point invariant gives
\[
\eta(b,S_W(z)c)=\eta_F^t(b|_F,S_f(z)c)
+\sum_{\rm tails}
 \frac{\eta_F^t(S_f(a)h_b,S_f(z)c)}{a+z}.                    \tag{10}
\]
The unstable marked-leg endpoint is the metric term of (9).
Thus (10), for all \(b,c\), defines
\[
(R(z)^*b)_F=b|_F+
       \sum_{\rm tails}\frac{S_f(a)h_b}{a+z},
\qquad S_W=R S_{\mathrm{bl}}.                              \tag{11}
\]
In (11) a whole fraction is interpreted by (7), not by substituting
an ordinary class after its pushforward.
All scalar characters in its denominators are nonzero, so \(R\)
is regular at zero. Every nonidentity term contains a moving leg,
and hence has positive ample degree. Symplecticity of the two
fundamental solutions, as rational identities, gives
\[
                         R(-z)^*R(z)=1.                    \tag{12}
\]

There are two more consequences of the same two-point organization.
The string equation gives \(J_W(-z)=-zS_W(z)^{-1}1\).
Its regular part restricted to \(F\) is \(-z+\epsilon_F(z)\).
Since multiplication by \(S_f\) cannot turn a strictly negative
power into a nonnegative one, (8) and (11) imply
\[
\bigoplus_Fx_F(z)=z(1-R(z)^{-1}1).                          \tag{13}
\]
For a bridge between two vertices, dress its endpoint tensors by
\(S_f(a)\) and \(S_{f'}(a')\), using (7), and call the resulting
two-ancestor kernel \(D(s,s')\). Cutting the path between the
two marks in (9) for \(W\) yields
\[
\frac{S_W(w)^*S_W(z)}{w+z}
=S_{\mathrm{bl}}(w)^*
 \left(\frac1{w+z}+D(-w,-z)\right)S_{\mathrm{bl}}(z).
\]
Consequently
\[
D(-w,-z)=\frac{R(w)^*R(z)-1}{w+z}.                         \tag{14}
\]
Equation (12) removes the apparent divisor \(w+z=0\).
The right side therefore has the required two-variable Taylor
expansion. This argument determines the translation and bridge
from the **same** \(R\), rather than postulating a second
transformation for ancestors.

### 5. Vertex conversion and all-genus assembly

At a distinguished flag, write
\[
\frac1{a-\psi}=\frac1{a-\bar\psi}
+\frac{\psi-\bar\psi}{(a-\psi)(a-\bar\psi)}.
\]
The difference divisor cuts off a genus-zero twig carrying that
flag, an arbitrary subset of the background marks, and its node.
Splitting, including its unstable metric term, gives (9)'s
primary-slot identity. Hence the flag becomes
\[
                     \frac{S_f(a)h}{a-\bar\psi}.            \tag{15}
\]
Any other evaluation classes at this flag belong to \(h\) before
applying the operator. Other ancestor powers are pulled back from
the stabilized distinguished curve, so they do not enter the
twig. Apply (7) to extend this scalar proof to the non-descending
tangents and simultaneous flags.

The descendant-background identity is
\[
\mathcal A_F(\epsilon_F;t)=c_F\,\mathcal A_F(u_F;t+x_F).
                                                               \tag{16}
\]
Here is the relevant dimension check rather than an appeal to
primary backgrounds alone. Expand \(\epsilon_F=u_F+(\epsilon_F-u_F)\)
and first forget only the primary \(u_F\)-marks. Conversion changes
each remaining extra insertion to \(x_F(\bar\psi)\). When changing
the original ancestors to ancestors retaining those new marks,
a boundary tail carrying one original mark and \(k\geq1\) new
marks has curve factor \(\overline M_{0,k+2}\), dimension \(k-1\).
The product of its \(k\) new insertions has ancestor degree at
least \(k\) by (8), and vanishes. This proves the change for all
the original powers and all subsets of forgotten marks.
Newly stable genus-zero distinguished data vanish by the same
dimension count; genus-one terms without an original mark affect
only a scalar. This proves (16) with the manuscript's stable-curve
convention, in agreement with CGT Proposition 3.6.

Now stabilize a localized map with stable distinguished curve
data. Every moving leg contracts because it is rational and has
at most two special points. Pruning unmarked rational trees and
suppressing two-flag rational chains leaves entire surviving
fixed-map factors, with their own internal stable-map boundaries.
The removed pieces are exactly ends, tails and bridges.
The restriction of each global ancestor at a surviving factor is
the ancestor which forgets the ends; at a tail it is the ancestor
at the tail's attachment. This follows by composing stabilization
with the gluing map of the surviving distinguished curves.

Equations (15)--(16) therefore replace a surviving vertex by its
twisted primary-background ancestor potential. By (11)--(13)
its substitution is precisely
\[
                 t(z)\mapsto R(z)^{-1}t(z)
                                  +z(1-R(z)^{-1}1).        \tag{17}
\]
Its bridge contraction is (14). These are the substitution and
kernel in the upper quantization formula, CGT equation (19).
The negative Darboux modes are \((-z)^{-i-1}\), which explains
the arguments \((-w,-z)\) and the signs \((-1)^{i+j}\) in (14).

Labelled flags give the exponential's factors \(1/(2^e e!)\);
the product of exponential vertex potentials supplies vertex and
marking factorials. Dividing by label permutations gives exactly
the automorphism weight of each stable graph. An edge contributes
\(\hbar\). For a connected graph its total power is
\(\sum_v(g_v-1)+e=g-1\); a loop contracts two flags at the same
vertex with the same rule. Thus the Wick expansion is the
localization expansion term by term, not merely in genus zero:
\[
\mathcal A_W(0)
 =c\,U_R\bigl(\mathcal A_{B,\mathrm{tw}}(u_B)
                    \mathcal A_{X,\mathrm{tw}}(u_X)\bigr). \tag{18}
\]
Components with no distinguished variables and the scalar
conventions in (16) give an invertible, variable-independent \(c\).

All tangent moments are even; their Taylor coefficients and the
operators \(S_f\) are parity preserving. Apply the same reasoning
in super vector spaces, keeping the order of every tensor slot.
The diagonal is the categorical coevaluation for the twisted
pairing, and the graph permutations have precisely their Koszul
signs. No even-cohomology restriction, algebraicity assumption
on insertions, or additional parity involution is used.
The virtual classes in (3) are algebraic; their cycle classes,
projection formula and diagonal contractions apply to the full
cohomology, including nonalgebraic and odd insertions.

### 6. Integral labels, completions and uniqueness

For either projective bundle of rank at least two, the integral
fiber line survives in the homology Serre sequence because
\(c_1(\mathcal O(1))\) pairs to one with it. Retraction by this
class splits the degree-two edge sequence. Thus
\[
H_2(P;\mathbb Z)\simeq H_2(B;\mathbb Z)\oplus\mathbb Z,
\qquad d\mapsto(\pi_*d,\langle p,d\rangle),
\]
including torsion. Gluing adds these *integral* classes. Every
identity above is performed before any replacement by divisor
degrees or numerical equivalence, so no such replacement occurs.

Choose \(M\) so \(p+M\pi^*H\) is ample on \(W\), and hence on
both fixed components. Every nonconstant effective piece has
positive integral ample degree; a moving degree-\(m\) leg has
degree \(m\). There are finitely many effective homology labels
of bounded ample degree, since the Chow schemes of bounded-degree
cycles have finite type and homology is constant in a connected
family. Thus fixing a curve label bounds the number and
multiplicities of the legs and all nonzero-degree pieces.
Stability bounds the remaining zero-degree pieces at fixed genus
and marking data. Cotangent powers on the fixed-map stacks and
the ordinary tangent moments on the gerbes are nilpotent.

These facts prove rationality in the loop variable coefficient
by coefficient: localization expresses the possibly non-nilpotent
equivariant map cotangent on \(W\) using the finite nilpotent
expansions on its fixed strata. Expanding that rational function
at zero has a finite lower Laurent bound. This is a different
expansion from the original one at infinity, as the proposition
requires.

The inverse and logarithm of \(R=1+\text{positive filtration}\)
exist formally. At a fixed class, genus and variable order there
are only finitely many positive-filtration edges, translations,
or logarithmic factors. On each surviving curve the ancestor
indices are bounded by \(3g_v-3+n_v\); the number of extra flags
is already bounded. These bounds prove coefficientwise existence
of the quantized action and its inverse, not just of their mode
matrices.

Finally suppose two positive-filtration pairs \((u,R)\) satisfy
the first factorization. At the first ample degree where they
differ, the difference of the fixed solutions is
\((\delta u_F\cup)/z\); all terms involving an additional positive
degree belong to higher filtration. The difference of the two
upper factors is regular at zero, so this \(z^{-1}\) coefficient
must vanish. Applying cup multiplication to the unit gives
\(\delta u_F=0\), and then \(\delta R=0\). Induction in degree
proves uniqueness. Equations (13)--(18) use this uniquely fixed
\(R\). This completes the proof.

## Exact evidence and its limits

`Main.lean` proves the finite geometric remainder and inverse for
every order, and the linear/multilinear joint-moment naturality
for every finite flag set. Lean 4.31.0 compiled it with exit code
zero, no proof holes, and a passing axiom audit. The statement
fidelity document explicitly excludes the geometric assertions.
The immutable successful certificate is
`lean_evidence/certificates/C_LOC_JET-eb1805af26b62351.json`.

The authorized Jacobian adapter's inspected operation
`matrix.symbolic.multiply.compute` checked the three-dimensional
nilpotent resolvent. Its server version, protocol, exact payload,
typed output and adapter status are in `jacobian_*.json`.
This bounded check is only an illustration; the all-orders
quantification is supplied by the Lean proof.

`verify.py` independently replays that typed product, verifies the
compiler source/fidelity binding, checks a joint-moment example,
and checks an admissible geometric coefficient:
\(B=\mathrm{pt}\), \(E=\mathbb C^2\), \(W=\mathbb P^2\),
\(X=\mathbb P^1\), class \((0,1)\). It derives the fixed \(X\)
two-point term from
\(\overline M_{0,2}(\mathbb P^1,1)=\mathbb P^1\times\mathbb P^1\),
\(\psi_2=H_1-H_2\), and inverse Euler twist \(\lambda^{-2}\).
The ambient coefficient is also computed geometrically, without
a mirror formula: the two-point degree-one evaluation map is
\(\operatorname{Bl}_{\Delta}(\mathbb P^2\times\mathbb P^2)
\to\mathbb P^2\times\mathbb P^2\), and
\(\psi_2=p_1-p_2\). Indeed, on the universal line the cotangent
class is \(-2p_2-c_1(S)\); the collision divisor is
\(p_1+p_2+c_1(S)\), giving their stated sum.
Its birational evaluation pushforward is the fundamental class.
Consequently, for a polynomial insertion \(P\) of degree at most two,
\[
S_W^{(1)}P(p)
=\int_{\mathbb P^2_q}\frac{P(q)}{z-p+q}
=-\frac{P(p-z)}{(p-z)^2(p+\lambda-z)}.
\]
The verifier evaluates that integral directly by localization
on the *target*, using the fixed point and fixed \(\mathbb P^1\);
it then computes the primary shift as the regular constant part
of \(zS_W^{(1)}1\), rather than inserting a mirror map.
The independently obtained primary shifts are
\(u_B^{(1)}=\lambda^{-2}\), \(u_X^{(1)}=-\lambda^{-2}\).
The verifier checks regularity and symplecticity of \(R^{(1)}\),
its translation, and the absence of an apparent bridge-kernel pole.
It additionally computes ends and the full two-variable bridge
directly from (1a), independently of the fundamental-solution
calculation. Here the twice-pointed leg Euler class is
\(\lambda^2(\lambda+H)\). Releasing the free endpoint gives the
end terms, and the two matching numerators give the bridge
bivector
\[
\frac1{(-\lambda-H-s)(\lambda+H-s')}.
\]
Contraction by the twisted metrics, with \(s=-w,s'=-z\),
agrees entry by entry with (14). This checks the non-descending
tangent, normal matching, gerbe degree \(m=1\), loop signs,
translation and the common bridge kernel in one admissible
geometric coefficient.
These are finite supporting checks, **not** the all-orders proof.

Replay the symbolic evidence with:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  research/family_orbit_localization/verify.py
```

For a fresh real compiler run, use:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/family_orbit_localization/Main.lean \
  --project-root . --claim C_LOC_JET \
  --statement-fidelity research/family_orbit_localization/statement_fidelity.md \
  --artifact-dir research/family_orbit_localization/lean_evidence
```

No false literal manuscript assertion has been established by this
work. In particular, the failed product-of-marginals example is
not attributed to the manuscript. The mathematical improvement
over the initial scope-only state is the explicit all-orders
compatibility argument, its checked finite-jet core, and the
arbitrary-\(E\) ample-completion formulation. CGT Remark 3.7
already anticipates the abstract formula; neither novelty nor
publishable significance is declared certified here. The final
Virasoro-transfer theorem and complete-intersection sewing remain
outside this result.
