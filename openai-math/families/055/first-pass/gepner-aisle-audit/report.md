# Quantitative verification of the quintic Gepner aisle mechanism

## 1. Result and precise scope

**Written verification theorem.** Let X be a smooth complex quintic
threefold, with the normalized characters, twist order, and two torsion-pair
definitions of the staged Gepner manuscript. Subject to the external
geometric inputs in Section 2, its actual double-tilt aisles satisfy
Phi(U_eta) contained in U_theta for independently varying endpoints on the
manuscript's square. They produce its full normalized Gepner slicing,
including full numerical support, finite Harder--Narasimhan filtrations,
direct-summand closure, both endpoint conventions, and local finiteness.
No categorical conclusion below is inferred from a search over characters.

The following quantitative strengthening is also proved:

1. The same formulas define double tilts and satisfy uniform comparison on
   **|eta_j| < 1/4000**, a square 50 times wider in each coordinate than
   the manuscript's |eta_j| < 1/200000.
2. They satisfy **Phi^3(U_alpha) contained in U_beta[1]** for independent
   **|alpha_j|, |beta_j| < 1/500000**. This smaller square lies inside the
   original manuscript square. Its radius is explicit, rather than supplied
   by a compactness argument.
3. For the unperturbed fifth-step blocks, and hence for all the resulting
   semistables, the support constant **C = 30000000** works for the Euclidean
   norm of (r,c,d,e). It also works for the coordinate l1 norm.
4. More generally, replacing uG=(5-sqrt(5))/10 by any **0 < u < 13/46**
   preserves the independent-parameter aisle inclusion on a sufficiently
   small square. This last assertion concerns aisles only: an arbitrary u
   is not asserted to be the imaginary part of a Gepner eigencharge.

The source is
`research/openai_manuscript/A-Gepner-stability-condition-on-every-smooth-quintic-threefold-September-24-2026/build/`.
The load-bearing assertions are `sections/aisles.tex`,
`lem:second-tilt`, `lem:compare-slope-cuts`, `lem:twist-aisle`,
`prop:uniform-aisle`, and the complete construction in `sections/grid.tex`.
`verify.py` checks the source anchors and records their current line numbers.
No assertion is made about the separate large-volume manuscript.

This is an Engineer's proof submitted for independent review, not a Reviewer
acceptance or a completed campaign. No false manuscript assertion has been
established, so there is no invented F_ claim or refutation verdict. The new
features relative to the strongest relevant prior result, namely the staged
manuscript's existential refinement and support constants, are the widened
geometric comparison range, the sufficient threshold 13/46, and the explicit
refinement and support bounds. Their novelty and publishable significance
remain independent-review questions.

## 2. External inputs and what is not assumed

The nonstandard geometric input is Xu, **arXiv:2511.21288v2, Theorem 1.3**.
The primary statement and its normalized coordinates were read at
<https://arxiv.org/html/2511.21288v2>. For a torsion-free slope-semistable
sheaf with x=|mu| in [0,1], it gives d/r <= g(x), where

| Interval for x | g(x) |
|---|---|
| [0,1/4] | -x/2 |
| [1/4,5/13] | x/2-1/4 |
| [5/13,6/13] | -3x/20 |
| [6/13,7/13] | x/2-3/10 |
| [7/13,8/13] | 23x/20-13/20 |
| [8/13,3/4] | x/2-1/4 |
| [3/4,1] | 3x/2-1 |

These are exactly the manuscript's coordinates:
mu = H^2 ch_1/(H^3 rk)=c/r and xi = H ch_2/(H^3 rk)=d/r.
Smoothness, the complex ground field, hyperplane polarization, positive
rank, torsion-freeness, and slope semistability are required whenever this
input is applied. Below it is applied only to actual torsion-free HN
factors, never to an arbitrary derived object. The source passage is
transcribed in `xu_theorem_1_3.txt`. Its proof is not re-audited here.

The categorical periodicity input is
**Phi=T_OX o (- tensor O_X(1)), Phi^5 is naturally isomorphic to [2]**,
with Phi an exact autoequivalence. The order matters: tensor acts first.
It is stated in Toda, **arXiv:1305.0345v3, Section 3.3, paragraph after
(13)**, read at <https://arxiv.org/html/1305.0345v3> and transcribed in
`toda_periodicity.txt`. The staged manuscript also supplies a direct
relative-kernel proof in `sections/periodicity.tex`. Matrix periodicity is
not substituted for this categorical input.

The standard geometric background is an explicit source-only dependency
in the ledger, not a newly formalized theorem:

- Coh(X) is noetherian; torsion-free sheaves have finite slope HN
  filtrations, with the usual slope Hom vanishing.
- Rank and first character are integral; a nonzero divisorial torsion
  sheaf has c>0; a sheaf supported in dimension at most one has d>=0,
  with d=0 precisely in dimension zero. A zero-dimensional sheaf has
  e=length/5. These assertions include zero in the evident way.
- A codimension-at-least-two quotient between torsion-free sheaves
  identifies their reflexive hulls. Reflexive hulls are coherent.
- The derived category has its ordinary bounded t-structure, long exact
  cohomology sequences, and octahedral splicing. HRS tilts are used with
  their explicit truncation construction, recalled in Section 3.
- X is proper with trivial canonical bundle and Serre functor [3].
  Thus Ext^1(T,O_X)=H^2(X,T)^*=0 for a sheaf of dimension at most one.
  Derived Hom complexes have finite-dimensional bounded cohomology.
- Weak Lefschetz, integral Chern classes, and Hirzebruch--Riemann--Roch
  give the numerical identification established in `sections/numerical.tex`:
  Knum(X)_R=R^4 and
  Knum(X) is contained in Z x Z x (1/10)Z x (1/30)Z.
  To see that this is the full numerical space rather than a quotient,
  the Euler matrix J has determinant 625 and the four line-bundle vectors
  v(O_X(k)), 0<=k<=3, have determinant one. Both identities are replayed.

Nothing in this package assumes the disputed uniform inclusion, existence
of a second-slope HN filtration, a slicing, or a support inequality.
The two canonical citations are registered as assumptions of
C55_GEPNER_VERIFY. Their independent citation attributions are still owed
by the Reviewer; the Engineer's source readings do not impersonate those
attributions. The standard background is explicitly an uncited
source-only package in the ledger.

A bounded literature lookup found no directly matching abstract
periodic-perturbed-aisle theorem. This is not a novelty proof. In
particular, the search service's suggested description of Bridgeland
Theorem 1.2 is not used as a theorem or a citation.

## 3. The second cuts really define bounded hearts

Use the aisle convention D^{<=0}, so an aisle V is closed under [1] and
its heart is V intersect (V[1])^perp. For a torsion pair (T,F) in its
heart, truncate at degree zero, then take the inverse image of the
torsion subobject of H^0_V. This constructs the aisle

    V^sharp = {E in V : H^0_V(E) in T},
    V[1] contained in V^sharp contained in V,

with heart <F[1],T>. Old orthogonality and Hom(T,F)=0 give the new
orthogonality. The two inclusions imply boundedness. This is the only
tilting fact needed here.

Fix b=+-1/2 and the ordinary slope torsion pair
(C_{>b},C_{<=b}). Its tilted heart is B_b and its aisle W_b. On B_b,
p_b=c-br belongs to (1/2)Z_{>=0}. Its zero objects have H^{-1}
slope-semistable of slope b (or zero) and H^0 supported in dimension
at most one. This follows by adding the nonnegative contributions of
the ordinary slope factors; nonzero divisorial torsion cannot contribute
zero.

For completeness, B_b is noetherian without assuming a second-slope HN
theorem. In an infinite chain of epimorphisms E_i -> E_{i+1}, let K_i
be the individual kernels. The discrete nonnegative p_b(E_i) eventually
stabilize. Then p_b(K_i)=0 and r(K_i)<=0. The ordinary H^0(E_i) form
epimorphic images of H^0(E_0) and stabilize by noetherianity of Coh(X).
The ranks r(E_i) are now increasing integers bounded above by the fixed
rank of H^0(E_i), so they stabilize too. Every remaining K_i is
therefore an ordinary sheaf of dimension at most one, and

    0 -> H^{-1}(E_i) -> H^{-1}(E_{i+1}) -> K_i -> 0.

The torsion-free terms agree in codimension one and embed, compatibly,
in a fixed coherent reflexive hull. Noetherianity of that hull makes
the chain stabilize. Hence eventually K_i=0.

Take N_b^eta=d-bc+ur+eta_1 c+eta_0 r, with |eta_j|<delta.
At slope b, Xu gives

    N_b^eta(F)/r(F) <= u - 3/10 + (3/2)delta.

If this is strictly negative, N_b^eta is nonnegative on p_b=0 objects
of B_b, and vanishes on precisely the zero-dimensional sheaves. Define
high and low, T_b^eta and F_b^eta, exactly as in the manuscript: high
means p_b=0 or N_b^eta>0, low means p_b>0 and N_b^eta<=0; T is the
class whose nonzero quotients are high, F the class whose nonzero
subobjects are low.

High objects are extension closed: N is nonnegative on the p=0
terms, and a high term with p>0 contributes strictly positive N.
Induced quotient filtrations show that T is quotient and extension
closed. Every high subobject contains a nonzero T-subobject. Indeed,
choose a high subobject A with minimal p(A). If p(A)=0, every quotient
has p=0. Otherwise a low quotient Q has p(Q)>0, and its kernel has
strictly positive N and strictly smaller p than A, a contradiction.

Noetherianity gives a maximal T-subobject of every object; sums are
again in T. Its quotient cannot contain a high subobject, by the
previous paragraph and inverse images. It thus belongs to F.
A nonzero image of a T-to-F morphism would be both high and low.
This proves the torsion pair and hence the bounded double-tilt heart
A_b^eta=<F_b^eta[1],T_b^eta> and aisle U_b^eta.

On this heart N_b^eta>=0. If its numerical class is zero, write it as
an extension of T by F[1]. Both contributions to N are nonnegative,
so both vanish. A nonzero high T with N=0 has p=0 and is
zero-dimensional. A nonzero F has p(F)>0, so p(T)-p(F)<0, contrary
to the zero numerical class. Thus F=0; length(T)/5=e(T)=0 gives
T=0. No nonzero object of any of these hearts has zero numerical
class. This is an actual-object assertion, not lattice discreteness.

## 4. A geometric comparison criterion

Set s=13/23. Xu's two pieces on [1/2,s] give the exact universal bound

    max_{1/2<=x<=s} (g(x)-x/2) = -13/46.

The maximum is certified by checking endpoints of each affine piece,
not by sampling. Hence sheaf values of N_- on [-s,-1/2] and N_+ on
[1/2,s] are strictly negative whenever

    m_strip = 13/46-u-(1+s)delta > 0.

Assume also u>delta, the boundary margin in Section 3, and

    m_compare = 1/2-u/s-3delta > 0.                 (4.1)

We prove U_+^alpha contained in U_-^theta for independent alpha,theta
with coordinates of magnitude less than delta.

Let Mcal be the torsion-free sheaves with all slopes in (-1/2,1/2],
and Lcal=B_- intersect B_+. In B_-, (Lcal,Mcal) is a torsion pair:
remove torsion and slopes above 1/2 from H^0(E) and take its remaining
quotient in Mcal. Its kernel is in Lcal, and the slope and cohomological
vanishings give Hom(Lcal,Mcal)=0. Thus

    B_+ = <Mcal[1],Lcal>,
    W_-[1] contained in W_+ contained in W_-.

In particular W_+[1] is already contained in U_-^theta. It remains to
show Hom(T_+^alpha,F_-^theta)=0.

Suppose a nonzero such morphism exists. In B_+, remove the Mcal[1]
subobject of its source, since Hom(Mcal[1],B_-)=0. This leaves a
quotient E_0 in Lcal intersect T_+^alpha. In B_-, factor its map
through the Lcal torsion subobject of the target. Take kernel K and
nonzero image Q in B_-. If K_L is the Lcal torsion part of K, the
quotient U'=E_0/K_L belongs to Lcal and remains in T_+^alpha:
the triangle K_L -> E_0 -> U' has all three terms in both hearts
and is short exact in B_+. We obtain the genuine B_- exact sequence

    0 -> S -> U' -> Q -> 0,
    S=K/K_L in Mcal,  0!=Q in F_-^theta.          (4.2)

There is no assertion that S belongs to B_+.

Write A=H^{-1}(Q). If A has a top slope factor with slope in
[-s,-1/2], that saturated factor shifted by [1] is an actual high
subobject of Q in B_-, contradicting Q in F_-^theta. Thus all slopes
of A are <-s. Similarly, the bottom positive-rank slope quotient of
H^0(U') is an actual B_+ quotient of U'. A slope in (1/2,s] would
make it low, so every positive-rank slope of H^0(U') is >s.

For any L in Lcal, ordinary cohomology gives

    c(L) >= (r(H^{-1}L)+r(H^0L))/2 >= |r(L)|/2.

Divisorial torsion only improves this inequality. The stronger slope
conclusions above give

    c(Q) >= -s r(Q),    c(U') >= s r(U').

All HN factors of S have |mu|<=1/2, where g<=0, so d(S)<=0.
Let C=c(Q)+c(U'). Then C>=0; equality would force c(Q)=r(Q)=0,
so p_-(Q)=0, impossible for a nonzero F_- object. Thus C>0.
Adding the two stronger slope tests yields C>=s r(S).

Additivity in (4.2), with no derived-rank sign assumption, now gives

    N_-^theta(Q)-N_+^alpha(U')
      = C/2 - u r(S) - d(S)
        +theta_1 c(Q)+theta_0 r(Q)-alpha_1 c(U')-alpha_0 r(U').

The last four terms have absolute value at most 3delta C, because
|r(L)|<=2c(L). Since u>=0 and r(S)<=C/s, the expression is at least
m_compare C-d(S)>0. Yet the left side is <=0. This contradiction proves
the Hom vanishing, hence the aisle comparison. It is the universal
separation encoded by `comparison_separation` in Lean.

The sufficient threshold is transparent. The two closed inequalities
20u+13s<=13 and 2u<=s imply 46u<=13. Equality is attained at
(u,s)=(13/46,13/23). Thus 13/46 is optimal for these two sufficient
strip/rank inequalities; it is **not** a proved failure of categorical
inclusion at the endpoint or beyond it.

For every 0<u<13/46, choose

    delta = min(u/4, (13/46-u)/10).

All four strict margins above hold: u-delta>0,
3/10-u-(3/2)delta>0, 13/46-u-(36/23)delta>0, and
1/2-(23/13)u-3delta>0. The Lean proof quantifies over any positive
delta satisfying these two upper bounds; their minimum is positive.

## 5. The twist and the enlarged independent square

O_X in B_- has p_-=1/2 and N_-=u+theta_0>0. It has no p_-=0
subobject: neither a sheaf of dimension at most one nor a slope
-1/2 sheaf shifted by [1] maps to O_X. A low quotient would leave a
p=0 kernel and is therefore impossible. Hence O_X belongs to A_-^theta.

O_X[1] in B_+ also has p_+=1/2, but N_+=-u-alpha_0<0.
There are no maps to it from p_+=0 objects: the slope-1/2 part
vanishes by slope Hom vanishing, and the dimension-at-most-one
part by Ext^1(T,O_X)=H^2(T)^*=0. Every nonzero subobject has p=1/2,
with p=0 quotient of nonnegative N. Its N is strictly negative.
Consequently O_X[1] lies in F_+^alpha and O_X[2] in A_+^alpha.

If B belongs to U_+^alpha and j>=2, Serre duality yields

    Ext^j(O_X,B) = Hom(B[j-1],O_X[2])^* = 0.

The last vanishing is heart orthogonality; it applies to every object
of the aisle, not just its heart. In the twist triangle

    B -> T_OX(B) -> RHom(O_X,B) tensor O_X[1] -> B[1],

the third term is a finite direct sum of O_X[1-j] with j<=1.
All these nonnegative shifts of O_X belong to U_-^theta, as does B
by Section 4. Extension closure proves
T_OX(U_+^alpha) contained in U_-^theta.

Tensoring by O_X(1) takes B_- to B_+ and preserves p. The exact shear is

    N_+^alpha(E(1)) = N_-^eta(E),
    alpha_1=eta_1,  alpha_0=eta_0-eta_1.

It therefore transports both quotient/subobject tests and their
torsion pairs. For |eta_j|<delta/2 its sheared coordinates lie in the
open delta square. Combining with the twist proves the independent
comparison Phi U_eta contained in U_theta on the delta/2 square.
Applying powers of Phi to that already proved inclusion entails no
additional parameter shear.

For u=uG, exact squaring gives

    27/100 <= uG < 138197/500000 < 7/25.

Take delta=1/2000 and s=13/23. The four margins are positive even on
replacing uG by this rational upper bound where appropriate. Their
exact lower bounds are recorded in `exact_certificate.json`.
Thus |eta_j|<1/4000 is valid. In particular every original manuscript
parameter and every endpoint used below is allowed.

## 6. An explicit fifth-step refinement

In normalized coordinates put N(v)=d+c/2+uG r. The exact numerical
matrix M of Phi is the manuscript's matrix. Let t=t0>0. The charge is
equivalently

    Z(v)/5 = -uG r/2 -(uG+1/12)c -d/2 -e + i t N(v),
    t^2=3/4-uG,   t>1/2.

The eigencharge equation and M^5=I are checked exactly. The latter is
only numerical periodicity; categorical Phi^5=[2] remains the separately
stated input. Set N_i=N(M^{-i}v) and a=5uG-1. Direct algebra gives

    N_0 + a N_1 + a N_2 + N_3 = 0,     a >= 7/20.        (6.1)

Before imposing 5uG^2-5uG+1=0, the residual row is
-(5u^2-5u+1)(3,35/6,5,10). This identity, not a floating-point
angle test, is the positive circuit used below.

Write w=M^{-1}v, x=N_1, y=N_2. The coordinate map
w -> (r(w),c(w),x,y) has determinant 5uG, so is invertible.
In those coordinates the endpoint rows r(v),c(v),r(M^{-3}v),c(M^{-3}v)
are

    (5u-4,   -1/u,       -5+1/u,  -1/u),
    (1,       1,          0,       0),
    (5u-4,    5-3/u,     -5+3/u,  -3/u),
    (3-5u,   -4+2/u,      5-2/u,   2/u).

For 1/4<=u<=3/10 and 10/3<=1/u<=4, upper bounds on their absolute
coefficients are

    (3,4,2,4), (1,1,0,0), (3,7,7,12), (2,4,3,8).

These are bounds on entire affine intervals, not a test of selected
objects. Hence, if x,y>=0 and X=|r(w)|+|c(w)|, the sum T of the
absolute endpoint rank/first-character coordinates satisfies

    T <= 16X + 24(x+y).                              (6.2)

Now put D_i^eta=Phi^i U_eta. All following statements concern actual
objects. Suppose

    E in D_3^alpha intersect (D_0^beta[1])^perp,
    |alpha_j|,|beta_j| < h=1/500000.

Coarse independent nesting puts E in the endpoint hearts and, for
every gamma in the enlarged square |gamma_j|<1/4000, in the hearts
of D_1^gamma and D_2^gamma. Aisle membership follows from
D_3^alpha contained in D_i^gamma contained in D_0^beta;
orthogonality follows from D_i^gamma[1] contained in D_0^beta[1].
These inclusions are independent of E and of the endpoint parameters.

Apply positivity to v=[E]. The unperturbed middle tests give x,y>=0.
Testing the four corners gamma_j=+-1/8000 at index one gives

    X/8000 <= x.

The endpoint tests give N_0>=-h(|r(v)|+|c(v)|) and
N_3>=-h(|r(M^{-3}v)|+|c(M^{-3}v)|). Combining (6.1) and (6.2),

    (7/20)(x+y) <= a(x+y) = -N_0-N_3
      <= T/500000 <= (128024/500000)(x+y).

The right coefficient is strictly smaller than 7/20, so x=y=0
and X=0. Invertibility of the middle coordinate map yields v=0.
The endpoint heart has no nonzero zero-class object, so E=0.
This avoids both compactness and any assumption that every numerical
vector is realizable.

To turn the zero intersection into aisle inclusion, take E in D_3^alpha
and its D_0^beta truncation

    A -> E -> H^0_{D_0^beta}(E) -> A[1],
    A in D_0^beta[1].

Categorical periodicity gives A[1] in D_0^beta[2]=D_5^beta,
which is contained in D_3^alpha by coarse nesting. The zeroth
cohomology is therefore in the zero intersection just proved.
It vanishes, and E belongs to D_0^beta[1].

Define V_k^eta=Phi^m U_eta[j] for k=2m+5j. Changing representatives
by (m,j)->(m+5q,j-2q) leaves the aisle unchanged by Phi^5=[2].
The new inclusion is V_1^alpha contained in V_0^beta. Transporting
it gives, for all k and independent endpoints in the h square,

    V_{k+1}^alpha contained in V_k^beta,
    V_{k+5}^eta=V_k^eta[1],   Phi V_k^eta=V_{k+2}^eta.

This proves the full geometric refinement with an explicit square.

## 7. Full numerical support, with an explicit constant

Set V_k=V_k^0, H_k=V_k intersect V_{k+5}^perp, and
S_k=V_k intersect V_{k+1}^perp. H_k is a bounded heart.
An object of S_k also belongs to H_{k+1}[-1]. The two charge-positivity
tests are

    Im(exp(-i pi k/5) Z(E)) >= 0,
    Im(exp(-i pi (k+1)/5) Z(E)) <= 0.

Their intersection is exactly the closed sector with phase in
[k/5,(k+1)/5], together with zero.

For every eta in the closed square |eta_j|<=rho=1/1000000,
independent refined nesting gives

    V_k contained in V_{k-1}^eta,
    V_{k-1}^eta[1]=V_{k+4}^eta contained in V_{k+1}.

Thus the same actual object E in S_k belongs to the heart of
V_{k-1}^eta for all these eta. Write k-1=2m+5j and take the actual
object F=Phi^{-m}E[-j], with w=[F]. It belongs to every A_eta
in that square. The four corner inequalities imply

    X=|r(w)|+|c(w)| <= 1000000 N(w).                 (7.1)

Let Q=|Z(E)|=|Z(F)|. Then 0<=N(w)<=2Q/5 since t>1/2.
The real charge formula and uG<7/25 imply

    |d(w)| <= N(w)+X/2,
    |e(w)| <= Q/5+X/2+|d(w)|/2.

Consequently

    ||w||_1 <= (9/4)X+(3/2)N(w)+Q/5
             <= (4500004/5)Q < 1000000 Q.

Choose m in {0,1,2,3,4}; the arbitrary j changes only the sign of a
numerical class. The exact induced l1 operator norms of M^m are

    1, 55/6, 68/3, 82/3, 38/3.

Hence ||[E]||_1<=30000000|Z(E)|. The Euclidean norm is no larger,
so the same C works for it. If Q=0, (7.1) and the coordinate
inequalities force w=0. Because F is an actual object of A_0, the
zero-class exclusion in Section 3 gives F=0 and hence E=0.
Every nonzero block object therefore has nonzero charge in the
stated sector. No positivity assertion on arbitrary vectors was used.

## 8. Finite block filtrations and refinement

Blocks are extension closed. If j>k, then S_j is contained in V_{k+1}
and Hom(S_j,S_k)=0. Boundedness puts any object E in
V_l intersect V_h^perp for integers l<h. Truncate at V_{l+1},
obtaining A -> E -> B, with B in V_{l+1}^perp. Since E and A[1]
belong to V_l, B belongs to S_l. Also B[-1] belongs to V_h^perp:
for F in V_h, F[1] lies in V_{l+1}, so Hom(F,B[-1])=0.
The rotated triangle then puts A in V_h^perp. Iterate until index h,
where the remainder is in V_h intersect V_h^perp and is zero.
This is a finite block filtration with decreasing indices when read
from subobject to quotient.

In H_k this gives the torsion pair

    T_k=<S_{k+4},S_{k+3},S_{k+2},S_{k+1}>,  F_k=S_k.

Its decomposition triangle is a short exact sequence in H_k. Thus
S_k is closed under subobjects in H_k. A subobject F of E in S_k is
saturated in the block precisely when E/F is also in S_k.

Put a=k/5, b=(k+1)/5 and
q_k(z)=Re(exp(-i pi(a+b)/2)z). Since cos(pi/10)>1/2 and every
nonzero numerical lattice vector has Euclidean norm at least 1/30,
Section 7 gives the explicit lower bound

    q_k(Z(E)) >= 1/(60C) = 1/1800000000

for every nonzero block object. This additive positive quantity
bounds the length of every filtration of a fixed object with
nonzero block factors.

For a saturated subobject F of E, its complement is a block object,
so q_k(Z(F))<=q_k(Z(E)). Hence

    ||[F]|| <= C |Z(F)| <= 2C q_k(Z(E)).

Only finitely many full lattice classes, and therefore finitely many
phases and charge magnitudes, occur. Choose F with largest phase and,
among those, largest magnitude. The choice exists even if infinitely
many subobjects share its class. A saturated subobject of F remains
saturated in E, so F is block-semistable. If a saturated subobject G
of E/F had larger phase, its preimage would violate maximal phase
of F by the strict see-saw property in a sector of width less than pi.
If it had equal phase, its preimage would violate maximal magnitude.
Thus the phases decrease strictly. Repeat on E/F. The positive
projection bound forces termination. This proves finite block HN
filtrations without a discreteness assumption on the charge image.

For the unsaturated test, let G be an alleged destabilizing subobject
of a block-semistable E. Its phase g satisfies a<g<=b. Saturate by
taking the preimage Gbar of the T_k part of E/G. The added factors
have phases in [b,a+1]. All charges in this sum have phases in
[g,a+1], whose width is strictly less than one because g>a.
Their sum is nonzero and has phase at least g. Since Gbar is a block
object and is saturated in E, this contradicts block semistability.
The strict g>a excludes the antipodal endpoint; no endpoint is
discarded without justification.

For a nonzero morphism between block-semistable objects, its image is
a subobject of the target in S_k. Its kernel is consequently saturated
in the source. See-saw and the unsaturated test imply
phase(source)<=phase(image)<=phase(target). This proves the required
Hom vanishing within a block.

## 9. Slicing, endpoints, and local finiteness

Define P(phi) as finite extension closure of block-semistables assigned
phase phi. At a grid endpoint include generators from both adjacent
blocks. Within-block Hom vanishing is Section 8; between distinct
blocks, strictly larger phase implies larger index, so the block Hom
vanishing applies. Extension induction gives the slicing Hom axiom.

Splice each finite block filtration with its finite block refinements.
The phases are weakly decreasing globally and strictly decreasing
inside a block. Merge adjacent equal-phase factors into their
extensions. Equalities can occur only at shared endpoints, so the
definition using both blocks is exactly what is needed. This yields
a finite strictly decreasing HN filtration.

The equivalences [1] and Phi transport (H_k,S_k) to the pairs at
k+5 and k+2, preserve saturated subobjects and semistability, and
increase assigned phases by 1 and 2/5 respectively. Their inverses
give the equalities P(phi+1)=P(phi)[1] and
Phi P(phi)=P(phi+2/5). An extension of generators on one phase ray
has nonzero positive charge on that ray and inherits the same support
constant by the triangle inequality and additivity of magnitude
along the ray.

For every real c, cut the finite HN filtration into either of the pairs

    (P((c,infinity)), P((-infinity,c])),
    (P([c,infinity)), P((-infinity,c))).

They are orthogonal; the first component is [1]-closed and the second
[-1]-closed. Splicing gives a decomposition triangle for every object.
They are actual mutual orthogonals: if an object is left orthogonal
to the lower component, apply Hom(-,lower truncation) to its triangle.
The identity of the lower truncation is zero because both neighboring
Hom terms vanish, including the term from the upper truncation [1].
The dual argument uses the lower truncation [-1]. Thus both
components are closed under direct summands, and they form bounded
t-structures.

The hearts are respectively P((c,c+1]) and P([c,c+1)). Every interval
category is the intersection of its corresponding upper and lower
cuts. One small point prevents an illicit cancellation here: a
nonempty decreasing filtration cannot have zero total object.
The identity of its first factor remains nonzero in the successive
total objects because Hom(first factor,later factor[-1])=0.
Thus the exterior truncations of a grouped filtration vanish exactly
when their groups are empty. This proves the interval description
for either choice of endpoint and, in particular, direct-summand
closure of every P(phi).

Let I have endpoints a<=b and b-a<1. Use the bounded heart
P((a,a+1]) if a is excluded, or P([a,a+1)) if it is included.
Cutting at b gives a torsion pair in this heart whose torsion-free
class is exactly P(I), with equality at b put on the required side.
For clarity, any torsion-free class F of a torsion pair in an
abelian heart H is quasi-abelian with the following concrete formulas.
For f:A->B in F, write K=ker_H f, J=im_H f, Q=coker_H f and t(Q)
for its torsion part. Its internal kernel is K, its internal cokernel
is Q/t(Q), its coimage is J, and its image is the preimage of t(Q)
in B. Therefore strict monomorphisms are precisely ambient
monomorphisms with cokernel in F, and strict epimorphisms are
precisely ambient epimorphisms between objects of F. Ambient
pushouts of strict monomorphisms stay in F by extension closure;
ambient pullbacks of strict epimorphisms stay in F by subobject
closure in a direct sum. This proves quasi-abelianity and identifies
the strict exact sequences with ambient short exact sequences
whose three terms lie in F.

Finally let w=b-a<1 and
q_I(z)=Re(exp(-i pi(a+b)/2)z). Every nonzero semistable in I has

    q_I(Z(E)) >= cos(pi w/2)/(30C) > 0.

Every nonzero object of P(I) is a finite extension of such objects
and has the same positive lower bound. On every strict exact
sequence the projection is additive, by the ambient description
just proved. Each nonzero quotient of a strict filtration consumes
at least this lower bound, so both increasing and decreasing
strict chains in a fixed object are finite. P(I) has finite length.
This proves local finiteness for every interval of width less than
one, with all four choices of finite endpoints, not just for
generic cuts.

The charge is numerical, has Z(O_x)=-1, and is the normalized
eigencharge. The support, slicing, covariance, HN, and local-finiteness
assertions now give the full claimed stability condition relative to
the explicit external inputs.

## 10. Replay boundary and independent review

Run the exact arithmetic replay with

    $WORKSPACE/argus-live-update/.venv/bin/python research/gepner-aisle-audit/verify.py

It compares its recomputed output with `exact_certificate.json`.
The verifier proves universal affine inequalities by endpoint
reduction on specified pieces, exact rational matrix identities, and
the stated bounds. These are not bounded no-witness experiments.
The source binding checks formulas and labels; it is not a parser
that verifies categorical prose.

`Main.lean` formalizes the matrix identities, golden-parameter
enclosure, criterion threshold and margins, universal comparison
separation, four-corner control, positive circuit, endpoint identities,
kernel separation, explicit scalar refinement, and support arithmetic.
`statement_fidelity.md` states its exact limits. In particular the
Lean proof is not a formalization of sheaves, functors, torsion pairs,
or the slicing. C55_CORE, not C55_GEPNER_VERIFY, receives compiler
evidence. The full theorem requires the independent reader to check
Sections 2--9.

The successful Lean 4.31.0 run has compiler exit code 0, axiom-audit
exit code 0, and `proof_holes=[]`. Its durable certificate is
`lean-evidence/certificates/C55_CORE-16b808fb34f65fe6.json`.
The exact replay also checks that the current source, statement-fidelity
document, and claim binding match that compiled snapshot. The ledger
derives `closed_kernel` for C55_CORE only; it does not thereby close
the categorical theorem.

One inspected, bounded Jacobian operation was attempted:
`optimization.linear.rational_general_optimum.compute`. Its payload
encoded the two sufficient threshold inequalities. Admission failed
before execution because the normalizer's possible simplex bases
exceeded its bound. The exact payload, structured error, adapter
exit status, server version, and protocol are preserved in dedicated
JSON files. The error supplies no support or refutation; the
threshold is instead proved by a two-line rational linear
combination and in Lean. There was no retry with a nearby operation.

The retired numerical-only route in MATH_STATE records its precise
obstruction: character identities alone cannot certify actual-object
membership or truncations. This theorem closes those obligations by
written proofs, with exact algebraic replay supporting the delicate
steps. Independent Reviewer replay, source attribution, statement
fidelity, and assessment of significance/novelty remain required;
the Engineer has not supplied a Reviewer identity or verdict.
