# The paired elliptic-family quotient

## Scope and source ledger

The immediate target is `prop:infinite-quotient` in the surface manuscript,
not either manuscript's main theorem. The source files are the staged
`build/sections/02-weighted.tex`, `03-family.tex`, `04-involution.tex`, and
`05-quotient.tex` of
`A-surface-counterexample-to-Shafarevich-holomorphic-convexity-September-23-2026`.
The fourfold construction has a separate dependency chain; no implication
from an algebraic check here to either projective construction is assumed.

The external propositions fixed before developing the argument are:

1. A pro-p presentation of positive weighted deficiency defines an infinite
   pro-p group. Source: Ershov--Jaikin-Zapirain,
   *Groups of positive weighted deficiency and their applications*,
   arXiv:1007.1489v3, Section 1.2. The section defines the supremum of
   `W(X)-W(R)-1` over pro-p presentations and explicitly states the infinitude
   implication. This is the infinitude input, not a theorem about geometric
   monodromy. The completed-algebra argument will also be given below.
2. The universal cover of a complex projective manifold with a linear
   fundamental group is holomorphically convex. Source: the publisher
   abstract of Eyssidieux--Katzarkov--Pantev--Ramachandran,
   *Linear Shafarevich conjecture*, Annals of Mathematics 176 (2012),
   1545--1581, DOI 10.4007/annals.2012.176.3.4,
   <https://annals.math.princeton.edu/2012/176-3/p04>.
   This is context, not a premise establishing infinitude of the quotient.
3. Eyssidieux--Funar, arXiv:2112.06726v1, Theorem 1.2 concerns the
   Bogomolov--Katzarkov surfaces `S(N)` built from semistable closed curves
   of genus at least two by a *uniform* ramification-index construction.
   Its exception set is `{1,2,3,4,6,8,12,16,20,24}`. It does not assert a
   universal-cover conclusion for every genus-zero marked family with
   separately chosen horizontal and vertical meridian powers. No such
   broader assertion will be used.
4. Finite etale covers of a locally finite type complex scheme are
   equivalent, by analytification, to finite etale analytic covers.
   Source: SGA 1, arXiv:math/0206203v2, Expose XII, Theoreme 5.1.
   The actual statement was read in the primary PDF, not inferred from a
   search summary. This algebraizes the finite cover of the open parameter
   curve; it has no properness hypothesis.

The passages actually read are in `sources/`. Their mathematical scope has
been read by the Engineer; independent citation attribution is still owed
to the normal Reviewer. A resolving URL alone is not that attribution.

The inherited wiki index supplied no pertinent result about this paired
family or its weighted pro-2 quotient. No earlier nontrivial mathematical
result is present in the campaign's initial ledger.

Two approaches are excluded as sufficient proofs: a negative scalar
Golod--Shafarevich expression without certified relator degrees, and a
Frattini calculation without a nonlinear filtration and normal-generation
argument. Neither settles the target.

## Result and its exact scope

The Engineer result is a proof of the quotient assertion for the actual
family, together with a structural extension from multiplication by four to
multiplication by every `n=2^r`, `r>=2`. The extension uses the same mechanism,
not a wider numerical search. There is also an exact description of the
finite geometric monodromy and a stronger, discrete free-basis statement.
No refutation was obtained.

The deterministic certificate checks exact free-group identities and
coefficients of formal noncommutative series, not sampled monodromies.
Sections 2--9 below supply the universal geometric, filtration, and
infinite-relator arguments. The certificate is not a Lean formalization
of these sections. Independent review, independent citation attribution,
and a publishability/novelty decision remain pending. In particular,
neither manuscript's main theorem is certified here.

Compared with the strongest relevant prior statement, the staged
`prop:infinite-quotient`, the additional mathematical conclusions are:
the whole dyadic family, a discrete rather than merely pro-2 difference
basis, and exact finite monodromy of order `2n^2` with augmentation
nilpotence index `2n`. At `n=4` these give order 32, depth 8, and an explicit
admissible monodromy depth `J=579`. A targeted literature lookup located
no matching published paired-family theorem. This negative retrieval is
not proof of novelty; the classical weighted-deficiency theorem itself
is explicitly not claimed as new.

## 1. Verification and extension theorem

Put `E=C/(Z+Z*omega)`, `omega^2+omega+1=0`, and let `q` be the quotient by
`iota(z)=-z`. For `n=2^r`, `r>=2`, let `f_n` be defined by
`q[n]=f_n q`. On

\[
 B=\mathbb P^1\setminus\bigl(q(E[2])\cup q(\ker(1-\omega))\bigr)
\]

take the actual marked family

\[
 \mathcal A_{n,s}=\bigcup_{j=0}^2 f_n^{-1}(\bar\omega^j s).
\]

Choose a nonzero `e_0` in `E[2]`, a nearby basepoint `s_0`, and
`x_0` over `s_0` near `e_0`. Write `e_j=omega^j e_0`. Choose the core,
based meridians, and positive pair boundaries as in Section 2 below.
Let `Gamma=pi_1(B,s_0)`, and let `D_N` be its ordinary pro-2 Magnus
filtration. Set

\[
 t=49/200,\qquad d_n=1+6n^2,
\]

and choose any integer `J` satisfying

\[
 J\ge 2n,\qquad
 d_n t\frac{(4t)^J}{1-4t}<1/100.                 \tag{1}
\]

**Theorem.** For every such `n` and `J`, the construction below has the
following properties, for every choice of a free covering-group basis
and of discrete representatives of parameter-layer bases.

* The involution relations and the counted depth-at-least-`J` relations
  define a pro-2 quotient `Q_0` of the pinched covering group. The resulting
  dense homomorphism `theta:Pi_n -> Q_0` from the *actual unpinched*
  sphere group is invariant under every element of `Gamma intersect D_J`.
* It is also invariant under the square of the distinguished local
  circuit `gamma_*`. The subgroup
  `M=<gamma_*^2>(Gamma intersect D_J)` fixes the markings and the parameter
  sign, and its parameter cover has ramification index exactly two at the
  selected point over `q(e_0)`.
* After separating the sections on this cover, kill no additional
  meridians along the distinguished fiber: they already map to one.
  Add a common `2^e` power of any lift of each of the finitely many
  other boundary images, with total upper cost less than `1/100`.
  The resulting `Q` is infinite. The map
  `rho:pi_1(U_n)->Q` has dense image on every punctured fiber,
  finite image on every boundary meridian, and trivial image on
  every distinguished-fiber meridian.

Thus `n=4` establishes precisely `prop:infinite-quotient`, including
`lem:deep-invariance`, not just the scalar inequality conditional on them.
For `n=4`, `J=579` satisfies (1) and already kills the finite geometric
action. Nothing in the theorem concludes that the subsequent
normalization, resolution, or compact-fiber image arguments in
`06-surface.tex` are correct.

## 2. Deriving the actual geometric input

### 2.1 The groups, markings, and signs

The endomorphism `1-omega` has determinant three on the lattice. Its
kernel meets `E[2]` only in zero, and its two nonzero elements are
exchanged by sign. Consequently `B` has five missing points and
`Gamma` is free of rank four. The three targets `bar(omega)^j s`
are distinct on `B`. Indeed, a coincidence lifts to `omega z=+z`
or `omega z=-z`; `1+omega` is a lattice unit, and the remaining
possibilities have been excluded in the definition of `B`.

The only critical values of `f_n` are contained in `q(E[2])`.
Thus there are `3n^2` distinct markings on every fiber. At the selected
degeneration, `n p=e_j` has `n^2` solutions for each `j`. None is
two-torsion, since even multiplication kills `E[2]`. The quotient
`q` is unramified at each such `p` and simply ramified at `e_j`.
The markings therefore have local equation `w^2=s-s_*` and form
`3n^2/2` disjoint simple pairs. The constant section `q(0)` never
meets a marking.

On the torus put

\[
 T=E\setminus\{\pm\omega^j x_0:0\le j<3\},\qquad F=\pi_1(T,0).
\]

In the complement of three disjoint pair disks choose lattice handles
`x,y` and based positive meridians `a_j,a_j^-`, so that

\[
 c_j=a_ja_j^-,\qquad [x,y]c_0c_1c_2=1.
\]

Here the superscript minus labels the *other puncture*, not a negatively
oriented meridian. A free basis is

\[
 x,y,a_0,a_1,a_2,c_0,c_1,                       \tag{2}
\]

with weights `1,1,1,1,1,2,2`. In its mod-two Magnus algebra,
`c_2=(c_0c_1)^{-1}[x,y]^{-1}` also has valuation at least two.
The exact order in this expression is fixed by the displayed surface
relation; only the lower bound is used.

The completed Magnus algebra here really gives the pro-2 topology.
Each finite truncation has a nilpotent positive ideal, so its
constant-one units form a finite 2-group. Conversely the augmentation
ideal of `F2[P]` is nilpotent for every finite 2-group `P`: choose a
central involution `z`, pass to `P/<z>`, and note that the kernel
ideal generated by `z-1` has square zero. Induction proves
nilpotence. Evaluation at the images of the free generators
therefore factors every finite 2-quotient through some Magnus
truncation; the ordinary group elements in `F2[P]` are distinct.
The truncations are cofinal in all finite 2-quotients, proving
faithfulness on the completion. Finite positive weights give a
cofinal reindexing of ordinary degree. Multiplication then gives
`nu(gh)>=min(nu(g),nu(h))`, `nu([g,h])>=nu(g)+nu(h)`, and
`nu(g^(2^e))>=2^e nu(g)`; the last follows from
`(g-1)^(2^e)=g^(2^e)-1`. These facts justify every completion and
degree estimate below, rather than adding an unrecorded pro-2
assumption.

Let

\[
 H_n=(\mathbb Z/n)^2,\quad
 K_n=\ker(F\longrightarrow H_n),
\]

where `x,y` give the coordinate generators and all meridians give zero.
This is the based multiplication cover
`[n]^{-1}(T)` with basepoint zero, so
`rank(K_n)=1+n^2(7-1)=d_n`. Quotienting this source torus by sign
gives the actual marked sphere. Denote its group by `Pi_n`, of rank
`3n^2-1`, and the based map by

\[
 p:K_n\longrightarrow\Pi_n.                    \tag{3}
\]

This map is onto, despite the branching: represent a sphere loop with
interior avoiding the four branch values and lift its interior.
At both ends the lift tends to zero, the unique point over `q(0)`.
It is a loop in the punctured source torus.

### 2.2 Corrected monodromy is actual, pure, and based

Following `x_0` around a parameter loop ends at
`(-1)^epsilon x_0`. The character `epsilon:Gamma->C2` is intrinsic
to the parameter double cover. The six torus punctures move in sign
pairs. At each short time interval choose disjoint small disks avoiding
all two-torsion, prescribe moving vector fields in one disk from each
sign pair, and extend by sign to its partner. Integration, patched over
finitely many intervals, gives an isotopy `H_u` fixing zero and
commuting with sign. It fixes every point of `E[2]`: their discrete
set is preserved, and the isotopy starts at the identity.

Different extensions give the same based action. Their relative
isotopy fixes the initial punctures and zero at every time. The same
construction on a homotopy of parameter paths gives the usual based
monodromy representation. All these actions commute with `iota_*`.
Consequently

\[
 \varphi_m=(\iota^{\epsilon(m)}H_1)_*
                                                               \tag{4}
\]

is a homomorphism to `Aut(F)`, fixes each of the six punctures, and
commutes with `iota_*`. On closed-torus homology it is `+id` or
`-id`, hence preserves `K_n`.

Lift `H_u` through `[n]`, starting at the identity and fixing zero.
Uniqueness of the based lift makes it commute with sign. The lift
of the corrected endpoint is `iota^epsilon` times this endpoint.
After quotienting by sign the correction disappears. If `beta_m`
denotes the actual sphere monodromy, it follows exactly that

\[
 p\varphi_m|_{K_n}=\beta_m p.                   \tag{5}
\]

There is no unspecified inner automorphism in (5).

### 2.3 Five invariant characters and the weight-two check

Choose the degree-two quotient coordinate `q` with `q(0)=infinity`,
normalized in an additive coordinate `v` at zero by
`q(z)=v^{-2}+O(1)`. It is even and `v(-z)=-v(z)`.
For each `j` the equation

\[
 Y_j^2=q(z)-\bar\omega^j s                      \tag{6}
\]

defines an unramified double cover of the moving torus complement.
Its only zeros are the two deleted `j`-punctures, and its pole at zero
has order two. With `eta=vY_j`, the equation near zero is
`eta^2=1+O(v^2)`. The points `eta=+1,-1` give global lifts of the
basepoint section over `B`. Therefore the associated character
`chi_j:F->F2` is preserved by uncorrected based monodromy.
The lift `(z,Y_j)->(-z,-Y_j)` of sign fixes each chosen sheet
over zero, so sign preserves it as well.

These three characters vanish on every `c_i`; they take value one
on both meridians of their own pair and zero on the other pairs.
Together with the two handle characters modulo two, their evaluation
matrix on `x,y,a_0,a_1,a_2` has blocks

\[
 \begin{pmatrix}I_2&0\\ *&I_3\end{pmatrix}.
\]

They are therefore a basis of the dual of the weighted degree-one
quotient. Every `varphi_m` and `iota_*` acts identically on this
five-dimensional quotient. This derives the actual input; it is not
an assumption imported from `lem:degree-one`.

Now fix any pair, write `a=a_j`, `b=a_j^-`, and `c=ab`. Purity and
orientation give `varphi(a)=w a w^{-1}`. Choose `d` with
`iota_*(a)=d b d^{-1}`. Commutation gives

\[
 \varphi(b)=w' b(w')^{-1},\qquad
 w'=\varphi(d)^{-1}\iota_*(w)d.
\]

The degree-one identity implies `[w']=[w]`; hence
`e=w'w^{-1}` has valuation at least two. Substituting
`b=a^{-1}c` and `w'=e w` gives the *universal* error word

\[
 w a w^{-1}e w a^{-1}c w^{-1}e^{-1}c^{-1}.       \tag{7}
\]

In the formal variables `a,c,w,e` with weights `1,2,1,2`, the
Magnus expansion of (7) has no nonconstant term of degree at most two.
This is checked exactly by the certificate. It can also be proved
without computation: replacing `w'` by `w` in the conjugation of `b`
changes it only by a commutator of degrees at least two and one;
conjugating `c` by `w` changes it in degree at least three.
The conclusion survives every substitution of elements satisfying
these lower bounds. It applies to all parameter loops and all pairs.
Thus each generator in (2) changes only in weight at least its weight
plus one, including `c_0,c_1`.

For completeness, this finite generator condition proves the operator
statement on the whole completed algebra. Substitution changes any
monomial of weighted degree `d` by terms of degree at least `d+1`.
Pass to series using positive weights and completeness. This proves
`prop:monodromy-raising` universally, not on finitely many loops.

## 3. The based collapse and its sphere factor

Lift the core through `[n]`. It is connected, since its handle loops
surject onto `H_n`. Its complementary disks have labels `(h,j)`,
`h in H_n`, `0<=j<3`. Collapse the whole lifted core. This kills
every disk boundary; inside a two-puncture disk it identifies the two
positive meridians as inverses. Van Kampen gives a free group on
`3n^2` positive meridians `a_{h,j}`. Let `L_n` be its free pro-2
completion, with coordinate shifts `T_1,T_2`.

The explicit homomorphism is

\[
 \Phi:\widehat F\longrightarrow L_n\rtimes H_n,\qquad
 x\mapsto T_1,\ y\mapsto T_2,\ a_j\mapsto a_{0,j},\
 c_0,c_1\mapsto1.                              \tag{8}
\]

It kills `c_2` too. On the core it is the covering character.
A lift of a core access path of handle coordinate `h`, followed by
the corresponding meridian, maps to `a_{h,j}`. Thus `Phi|K_n` is
exactly the based collapse map and has dense image.

Sign preserves the lifted core; all four of its fixed points lie
there, since even multiplication sends them to zero. On the other
disks it acts freely. Choose the zero-index center in block `j`
as `v_j/n`, where `v_j mod lattice=e_j`. Then

\[
 b_j=-2v_j\pmod{n\mathbb Z^2},\qquad
 \sigma(a_{h,j})=a_{b_j-h,j}^{-1}.              \tag{9}
\]

The parity of `b_j` is nonzero. The minus exponent in (9) comes from
*killing the pair boundary*, not from reversing complex orientation.
Changing a core access path changes `b_j` by an even vector, and
does not affect the required hypothesis.

Downstairs the quotient core is a sphere with `3n^2/2` holes.
Killing all its boundary loops kills its fundamental group.
The remaining disks give a free group `Pi_pair,n` of rank `3n^2/2`.
The two collapses commute with `q`. Every sign fixed point was
already collapsed, and the remaining disks are exchanged in pairs,
each mapping homeomorphically to its downstairs disk. Consequently

\[
 \widehat{\Pi_{\rm pair,n}}=
 L_n/\overline{\langle\!\langle\sigma(g)g^{-1}:g\in L_n\rangle\!\rangle}.
                                                               \tag{10}
\]

In particular, for every continuous quotient `lambda:L_n->R` with
`lambda sigma=lambda`, there is a dense map `theta:Pi_n->R` with

\[
 \theta p=\lambda\Phi|_{K_n}.                   \tag{11}
\]

Combining (5), (11), and the surjectivity of `p`, an equalizer
`lambda Phi varphi_m=lambda Phi` on `K_n` implies
`theta beta_m=theta` on the entire unpinched sphere group.
There is no claim that monodromy preserves the collapse kernel.

The pro-2 topology on `K_n` is the topology induced from `F`.
If a normal subgroup `A` of `K_n` has 2-power index, intersect
its finitely many `F`-conjugates. The resulting core has quotient
in `K_n` embedded in a finite product of 2-groups, and its quotient
in `F` is an extension by `H_n`, also a 2-group.
Thus the full pro-2 completion of `K_n` is its closure in
`widehat F`, and a discrete free basis of size `d_n` is a topological
generating basis. This justifies using it later in continuous equalities.

## 4. A discrete difference basis and nonlinear filtration control

Work in one block; different blocks are independent. In the discrete
free group on `a_{i,l}`, define

\[
 u_{i l}=\delta_{T_1}^i\delta_{T_2}^l(a_{0,0}),
 \quad 0\le i,l<n,\qquad \delta_T(z)=T(z)z^{-1}.
\]

Before any index wraps around, this word begins with `a_{i,l}`
exactly once; every other letter has indices componentwise at most
`(i,l)` and strictly smaller sum. This follows by induction from the
definition of a difference. Order cells by increasing sum and then
lexicographically. The substitution is triangular:
`u_{i,l}=a_{i,l} W` with `W` using only earlier generators.
Solve `a_{i,l}=u_{i,l} W^{-1}` successively. These mutually inverse
free-group substitutions prove a **discrete** free-basis theorem
for every positive integer `n`. At `n=4` the certificate verifies
both inverse compositions by free reduction, with no truncation.
It follows also that this is a free pro-2 basis.

Give `u_{i,l,j}` weight `i+l+1`. The rest of this section uses
`n=2^r`; no assertion for a non-dyadic cyclic endpoint is made.

### 4.1 The endpoint is not a linearization argument

Suppose `T^n=1`, `w_i=delta_T^i(w_0)`, and
`nu(w_i)>=d+i` for `0<=i<n`. On formal free generators
`z_0,...,z_(n-1)` of weights `d,...,d+n-1`, put
`T'(z_i)=z_(i+1)z_i` for `i<n-1`, and fix the last generator.
This is a triangular automorphism, and `T'-1` raises algebra degree
by one. In characteristic two

\[
 (T')^n-1=(T'-1)^n.
\]

Hence `T'^n(z_0)z_0^{-1}` has degree at least `d+n`.
The positive word `T'^(n-1)(z_0)` has `z_(n-1)` exactly once,
as its first letter. Evaluation at the `w_i` preserves degree.
In applying the actual last iterate only this first letter has a
different substitution: `T(w_(n-1))=w_n w_(n-1)`.
Thus, *as an exact word identity*,

\[
 T^n(w_0)=w_n\,T'^n(z_0)|_{z_i=w_i}.
\]

Since the left side is `w_0`, `nu(w_n)>=d+n`.
This argument never assumes that `T` preserves the filtration.
The certificate checks the nonlinear prefix identity and the generic
weighted series at `n=4`; the displayed characteristic-two identity
proves it for every power of two.

Apply this to each `T_1` sequence at fixed `l,j`. Every nonendpoint
difference is the next basis element, and the endpoint has the same
required lower bound. Thus `T_1-1` raises algebra degree by one.
It also gives the `T_2` bound on each initial sequence `u_(0,l,j)`.

To propagate that bound, if `T_2(z)=v z`, commutation gives

\[
 T_2(\delta_{T_1}z)=T_1(v)(\delta_{T_1}z)v^{-1}. \tag{12}
\]

If `nu(z)>=d` and `nu(v),nu(delta_T1 z)>=d+1`,
the already proved `T_1` estimate gives
`nu(T_1(v)v^{-1})>=d+2`; the conjugation error has degree at least
`2d+2>=d+2`. Equation (12) proves the next bound. Induction proves
that `T_2-1` raises degree on the full algebra.

### 4.2 Sign on the full algebra

At `a_(0,j)`, (9), the shift estimates, and the equality of the
linear terms of `g` and `g^{-1}` in characteristic two give
`nu(sigma(a_(0,j))a_(0,j)^{-1})>=2`.
For either shift,

\[
 T^{-1}-T=T^{-1}(1-T^2),\qquad T^2-1=(T-1)^2.
\]

Therefore `delta_(T^-1) z` and `delta_T z` agree modulo degree
`d+2` whenever `nu(z)>=d`. If `sigma(z)=v z`, use

\[
 \sigma(\delta_T z)=T^{-1}(v)(\delta_{T^{-1}}z)v^{-1}.             \tag{13}
\]

When `nu(v)>=d+1`, the inverse-shift error has degree at least
`d+2` and the conjugation error at least `2d+2`.
Thus (13) propagates the sign bound first along `T_2` differences
and then along `T_1` differences. Sign changes every basis element
only in weight at least one higher, hence raises degree on the
whole completed algebra.

For `n=4`, `verify.py` independently computes both translations and
all twelve admissible sign automorphisms in the **inverse discrete
basis**, and expands every generator error through its first possible
degree. There are 224 such generator checks. Absence of lower
coefficients is an exact finite presentation certificate for a
universal completed-algebra statement, not an experiment on group
elements. The excluded `b=(0,0)` has fixed disks and differential
rank six; it is not silently treated as admissible.

## 5. Half as many relations impose the entire involution

The Frattini module of one block is

\[
 R=\mathbb F_2[\xi,\eta]/(\xi^n,\eta^n),\quad
 T_1=1+\xi,\ T_2=1+\eta.
\]

The images of the difference generators are exactly `xi^i eta^l`.
From (9), sign on this module is

\[
 f\longmapsto (1+\xi)^{b_1}(1+\eta)^{b_2}
 f((1+\xi)^{-1}-1,(1+\eta)^{-1}-1).
\]

Its part increasing polynomial degree by one is

\[
 d=(\bar b_1\xi+\bar b_2\eta)+
        \xi^2\partial_\xi+\eta^2\partial_\eta.                  \tag{14}
\]

Set `u=bar(b_1)xi+bar(b_2)eta` and choose an independent binary linear
coordinate `v`. Frobenius makes the change of coordinates preserve
the ideal of `n`th powers. The vector field sends every binary
linear coordinate to its square. Thus

\[
 R=\mathbb F_2[u,v]/(u^n,v^n),\qquad
 d=u+u^2\partial_u+v^2\partial_v .
\]

On an even power `u^a` the first part sends it to `u^(a+1)`;
on an odd power it vanishes. The `v` part squares to zero,
as does the `u` part, and they commute, so `d^2=0`.
Let `C` be the span of `u^a v^b` with even `a` and `0<=a,b<n`.
The odd-`u` projection of `d|C` is multiplication by `u`, an
isomorphism onto the odd-`u` monomials. Consequently

\[
 R=C\oplus dC,\qquad \ker d=\operatorname{im}d=dC.               \tag{15}
\]

For each monomial of `C`, expand in `xi,eta`, and take the product
of the corresponding difference-basis generators in fixed order.
Call it `g`, and give it weight `w_g=a+b+1`. Then `nu(g)>=w_g`.
The *nonlinear* result of Section 4, not (14) alone, proves

\[
 r_g=\sigma(g)g^{-1},\qquad \nu(r_g)\ge w_g+1.                  \tag{16}
\]

The lowest Frattini vectors of `g,r_g` are a homogeneous basis by
(15). Their actual vectors are a basis too: in a putative dependence,
look at its lowest assigned weight. It would be a dependence among
that homogeneous basis. Thus the `g,r_g`, or equivalently
`g,sigma(g)`, topologically generate the free pro-2 group.
Here the Frattini generation criterion follows by passing a proper
closed subgroup to a finite 2-quotient and then to a maximal subgroup
of index two.

Let `N_sigma` be the closed normal subgroup generated by these `r_g`.
The exact identity `sigma(r_g)=r_g^{-1}` makes it sign invariant.
The quotient is generated by the images of the `g`; sign fixes
each one there. Hence sign is the identity on the whole quotient.
These relations impose **all** involution equalities, not just
linear equalities.

There are `3n^2/2` of them. Their weight polynomials are

\[
 \begin{split}
 P_n(t)&=3t(1+t+\cdots+t^{n-1})^2,\\
 G_n(t)&=3t(1+t^2+\cdots+t^{n-2})(1+t+\cdots+t^{n-1}),\\
 P_n&=(1+t)G_n.
 \end{split}                                                   \tag{17}
\]

The relation cost is at most `t G_n`. At `n=4` all full Frattini
actions are checked against the independently computed nonlinear
word actions. Both `C,dC` and `C,sigma C` have rank sixteen for
every admissible displacement. Jacobian independently returned
rank sixteen for the explicit `C,dC` matrix. Its operation does
not address the geometric or pro-2 arguments.

## 6. Filtration transfer and all deep monodromies

Represent `L_n rtimes H_n` on its completed Magnus algebra `A_L`
by left multiplication for `L_n` and by shifts for `H_n`.
The operators assigned by (8) to `x-1,y-1,a_j-1` raise degree
by one; those assigned to `c_0-1,c_1-1` are zero and satisfy the
weight-two bounds. Substitute these operators for the seven
Magnus variables of `F`. A word of weight `s` raises operator
degree by at least `s`; positive weights make the substitution
convergent on every finite truncation.

If `nu_F(f)>=s` and `Phi(f)=(l,h)`, apply its error operator
to `1 in A_L`. A shift fixes one, so the result is `l-1`.
Thus `nu_L(l)>=s`. This proves `lem:transfer` on the whole
completion; on `widehat K_n` the `H_n` component is trivial.

By Section 2, the four generator actions of `Gamma` differ
from the identity by degree-raising operators. Their actions on
every finite truncation are unipotent over `F2`, hence lie in
a finite 2-group. Thus the action extends continuously to
`widehat Gamma`. Substituting their four error operators in
the ordinary parameter Magnus expansion gives

\[
 (\varphi_m-1)(A_{F,\ge d})\subset A_{F,\ge d+N}
 \quad(m\in D_N).                                               \tag{18}
\]

Preservation of `widehat K_n` extends by continuity from the
actual action. The leading part injects
`D_N/D_(N+1)` into the `4^N`-dimensional word space.
The quotient is elementary abelian: squares and commutators
increase degree beyond `N`. Choose at most `4^N` discrete
representatives `M_N` of a basis. Density supplies them in
the required open cosets.

For a fixed free basis `k_1,...,k_(d_n)` of `K_n`, impose

\[
 \Phi(\varphi_m(k_i)k_i^{-1}),\quad
 m\in M_N,\ N\ge J,\ 1\le i\le d_n.                            \tag{19}
\]

Equation (18) and the transfer just proved give degree at least
`N+1`. The complete upper cost is therefore

\[
 d_n\sum_{N\ge J}4^N t^{N+1}
 =d_n t(4t)^J/(1-4t).                                         \tag{20}
\]

There are only finitely many assigned bounds below any fixed
degree, and this infinite sum converges since `4t<1`.

Let `f_K:widehat K_n -> Q_0` be the resulting map.
Each imposed `m` gives equality of two homomorphisms on the
generating basis, hence on the entire completion.
The set

\[
 \{m\in\widehat\Gamma:f_K\varphi_m=f_K\}
\]

is a closed subgroup: composition and inverses preserve the
equalities, and continuity gives closedness. It contains every
`M_N`, `N>=J`. These sets topologically generate `D_J`,
because successively removing a leading component approximates
any element modulo all `D_N`. Consequently the equality holds
on *all* of `D_J`.

By (10), (16), and (11), `f_K` factors through `Pi_n`.
Equations (5) and (11), with the surjectivity of `p`, now prove
`theta beta_m=theta` for every actual `m in Gamma intersect D_J`.
This is the infinite-relator equalizer argument that finite
checks or a rank computation cannot replace.

## 7. Exact finite geometric monodromy

This improves the coarse containment in `H^3 rtimes C2` in
`lem:finite-geometric-monodromy`. The connected unramified cover

\[
 (q[n])^{-1}(B)\longrightarrow B
\]

is regular of degree `2n^2` with deck group
`H_n rtimes C2`, sign acting by inversion. Connectedness holds
because only finitely many points have been removed from the torus.
Its monodromy is therefore the whole deck group.

Choose `alpha_0` with `n alpha_0=x_0`, and use
`omega^j alpha_0` to label the three marking blocks. If a
continued lift ends at `delta alpha_0+tau`, where `delta=+1`
or `-1` and `tau in E[n]`, quotienting by sign identifies its
marking action with

\[
 h\longmapsto \delta h+\omega^j t,\qquad t=\delta\tau.           \tag{21}
\]

The parameter sign is `delta`. Thus the joint action is exactly
this *single* generalized dihedral group, not three independent
translation groups. For `n>=4` its action on the first marking
block is already faithful.

Its group algebra over `F2` has generators
`X=x-1,Y=y-1,S=s-1` and basis

\[
 X^iY^jS^k,\quad 0\le i,j<n,\quad k=0,1.                       \tag{22}
\]

They form a basis because the change from the ordinary group
basis is triangular. We have `X^n=Y^n=S^2=0`, `XY=YX`, and

\[
 SX=XS+\sum_{a=2}^{n-1}X^a+\sum_{a=2}^{n-1}X^a S,             \tag{23}
\]

with the analogous formula for `Y`. Every term on the right
has degree at least two. The subspace spanned by the normal
forms (22) of total degree at least `d` is taken into the
degree-at-least-`d+1` subspace by right multiplication by
`X,Y,S`. Since these generate the augmentation ideal as a
left ideal, induction identifies that subspace with its `d`th
power. The maximum degree in (22) is `2n-1`, whose top
monomial is nonzero. The exact augmentation nilpotence index
is therefore `2n`.

Any parameter Magnus word of degree at least `2n` maps to
zero in this augmentation ideal; hence `D_(2n)` kills the
entire actual finite marking/sign action. At `n=4` the
certificate computes its powers with dimensions

\[
 32,31,28,23,16,9,4,1,0,
\]

and verifies all compositions of the 32 marking permutations.
With `e_0=1/2`, compatible lattice lifts give
`b_0=(3,0),b_1=(0,3),b_2=(1,1)`. The distinguished circuit
is the reflection `((3,0),-1)`: it is nontrivial in sign,
and its marking permutation is 24 transpositions.

Its square acts on each local pair disk by a full twist.
A full twist acts on that disk group by conjugation by its
boundary. It acts trivially after killing the boundary,
so `gamma_*^2` acts trivially on `Pi_pair,n`. This is a
geometric statement about the local equation `w^2=s-s_*`,
not an inference from its order-two finite permutation.

## 8. The parameter cover and boundary relations

By (1) and Section 7, `Gamma_J=Gamma intersect D_J`
fixes every marking and has trivial sign. The subgroup
`M=<gamma_*^2>Gamma_J` has finite index because `Gamma_J`
is normal and open. Both generators of `M` fix `theta`:
use Section 6 for `Gamma_J` and the full-twist argument
for `gamma_*^2`. Moreover `gamma_*` is not in `M`, since
its sign is nontrivial, whereas `gamma_*^2` is in `M`.
Thus
`<gamma_*> intersect M=<gamma_*^2>` exactly.

The finite connected cover `B'->B` classified by `M` is
algebraic by the primary Riemann existence theorem recorded
above. Normalize the projective base in its function field
to compactify it to the smooth projective curve `C'`.
Its chosen ramification index over `s_*` is exactly two.
The markings split into disjoint algebraic sections over
`B'`, since `M` fixes their labels.

Their complement `U_n` is the actual punctured-sphere
bundle over `B'`. The section `q(0)` gives

\[
 \pi_1(U_n)=\Pi_n\rtimes M .
\]

For example, the fiber injection follows because an open
curve is aspherical. Define `rho_0` by `theta` on the fiber
and by one on the section group. This is a homomorphism
because the established equalities are for the actual
based action, not an outer action.

Extend the sections across `C'` and blow up their
collisions. This terminates: at every collision a blowup
decreases the sum of pairwise intersection multiplicities.
The fibers and the full boundary stay reduced and simple
normal crossing. Locally a section is `w=g(u)` at a
smooth point of a multiplicity-one fiber; after blowing
up it is still transverse to the new multiplicity-one
component. It cannot pass through a vertical node, since
the differential of the projection `u=wb` vanishes
there while the section's projection has derivative one.
This proves the induction and finiteness of the remaining
boundary components.

At the distinguished point the index-two base change makes
the local equation `w^2=u^2`. A single blowup at each pair
gives the unmarked main sphere and `3n^2/2` tails.
A main-component meridian is the section circuit and is
killed by `rho_0`. In a tail chart `w=uv`, a meridian
at fixed slope of sufficiently large modulus is
`u=epsilon exp(i theta), w=c epsilon exp(i theta)`.
Trivialize the pair motion by an isotopy supported inside
that slope. The loop is the section circuit followed by
the pair boundary, up to conjugacy and inversion.
Both have already been killed. Thus all distinguished
vertical meridians have trivial image.

Let `mu_1,...,mu_b` be based meridians of all other
boundary components. Lift their images in `Q_0` to
`l_1,...,l_b in L_n`; these lifts exist because a quotient
of a compact pro-2 group is surjective, not merely dense.
Every nonidentity lift has degree at least one. Adding
`l_i^(2^e)` therefore has cost at most `b t^(2^e)`.
For every finite `b`, choose `2^e>=bit_length(b)+7`.
Since `t<1/4` and `b<2^bit_length(b)` when `b>0`,
this gives cost less than `1/128`, hence less than
`1/100`; `b=0` is immediate.

All distinguished equalities and all monodromy equalities
survive this quotient. Every other meridian now has order
dividing `2^e`. The dense image of each fiber remains dense
under a continuous surjective quotient. Notice the order
of choices: first `J`, then the finite cover and
compactification, then `b` and `e`. There is no bound
on the number of boundary components being assumed
before choosing the parameter cover.

## 9. Infinitude, including the countable-relator completion

At `t=49/200`, exact arithmetic gives

\[
 G_4(t)=\frac{65806513251003}{64000000000000},\qquad
 1-G_4(t)+\frac1{50}
 =-\frac{526513251003}{64000000000000}<-\frac1{125}.             \tag{24}
\]

For every dyadic `n>=4`, both factors in the expression
for `G_n` in (17) contain those for `G_4` with nonnegative
additional coefficients. Thus `G_n(t)>=G_4(t)`.
The involution and the two remaining relation families
give the strict upper bound

\[
 1-P_n(t)+tG_n(t)+1/100+1/100
 \le 1-G_4(t)+1/50<0.                                        \tag{25}
\]

For `n=4`, direct rational comparison makes 579 the
first integer `J>=8` with (20) less than `1/100`.
No floating-point logarithm or cutoff is used.

Here is why (25) proves infinitude even with the infinite
relator family. Let `A` be the completed weighted free
Magnus algebra, `I` the closed two-sided ideal generated
by all `r-1`, and `R=A/I` with the quotient filtration.
Put `C(s)=dim R/R_(>=s)` for positive integers `s`,
and zero otherwise. First-letter decomposition gives a
surjection

\[
 \bigoplus_i R/R_{\ge s-w_i}\longrightarrow R_{>0}/R_{\ge s}.
\]

Its kernel is spanned, modulo this truncation, by the
first-letter coefficient vectors of the relators times
right coefficients. A relator assigned degree `v`
contributes at most `C(s-v)` dimensions. To justify
this assertion, write `r-1=sum U_i f_i`. In a product
`a(r-1)h`, the positive-degree part of `a` has
first-letter coefficients zero in `R`; only its
constant part contributes the vector `(f_i)h`.
It has shifted degree at least `v`, and only `h`
modulo degree `s-v` matters. Closure adds no vectors
beyond their span in a finite-dimensional truncation.
Only finitely many assigned degrees are relevant there.
Consequently

\[
 C(s)-\sum_i C(s-w_i)+\sum_r C(s-v_r)\ge1.                     \tag{26}
\]

If the presented pro-2 group were finite of order `m`,
its image would span each truncated algebra: every
variable is the image of `g_i-1`, and products of
these are linear combinations of group elements.
The truncated unit-group map kills every relator and
factors through this finite quotient. Thus `C(s)<=m`.
Multiply (26) by `t^(s-1)` and sum over `s>=1`.
Boundedness of `C` and convergence of the nonnegative
relator sum justify all rearrangements. The result is

\[
 \left(1-\sum_i t^{w_i}+\sum_r t^{v_r}\right)
       \sum_{s\ge1}C(s)t^{s-1}\ge\frac1{1-t},
\]

contrary to (25). This is also precisely the
positive-weighted-deficiency implication recorded
from Ershov--Jaikin-Zapirain. It establishes infinitude
for every allowed representative and lift choice,
not merely for an unlisted favorable presentation.
This completes the theorem.

The same unchanged count cannot certify the dyadic
case `n=2`: there `G_2(t)=3t(1+t)<15/16` whenever
`t<1/4`. This is a limitation of this presentation
and cost estimate, not a proof that its quotient is
finite and not a counterexample to any manuscript claim.

## 10. Replay, source correspondence, and remaining review

Run from the campaign root:

```
python3 research/surface_weighted_audit/verify.py
```

The default recomputes and compares `exact_certificate.json`
without writing it. `--write` regenerates it, and
`--certificate PATH` tests another proposed certificate.
Seven internally altered certificates (geometric displacement,
cyclic endpoint, involution rank, depth, margin, and two
type changes) must be rejected. All arithmetic is integer or rational; the only
coefficient field in the Magnus and group-algebra calculations
is exactly `F2`.

The certificate contains the two-sided free-group basis
substitutions, every admissible sign displacement, complete
first-allowed-degree coefficient lists, finite monodromy
permutations, augmentation-ideal dimensions, and exact
rational weight bounds. The abstract infinite family of
parameter representatives is not enumerated: Sections 2,
6, and 9 prove the estimates and equalities for **every**
permitted representative. Calling this enumeration of
infinite relators, or formal kernel verification of the
geometric proof, would be incorrect.

The retained Jacobian evidence consists of the inspected typed
contract, exact payload, exact typed result, and exit/timeout
status in dedicated JSON files. The executed operation is
`prime_field.matrix.rank.compute`, server `0.14.0`,
protocol `2025-11-25`; the adapter returned rank 16,
exit zero, without timeout. The discovery results exposed
no matching operation for geometric based monodromy or a
complete weighted pro-2 argument. The rank operation was
used only for the finite linear subclaim it actually accepts.

| Manuscript source label | Independent argument here | Exact code support |
|---|---|---|
| `lem:family`, `prop:based-monodromy` | Sections 2.1--2.2 | Lattice, puncture count, finite action model |
| `lem:degree-one`, `prop:monodromy-raising` | Section 2.3 | Universal weight-two error word |
| `lem:pinched-sphere` | Section 3, based maps (3), (5), (8), (11) | Sign displacements and free disk pairing |
| `lem:shift-basis` | Section 4, including every cyclic endpoint | Exact inverse words and 224 nonlinear checks |
| `prop:involution` | Section 5, nonlinear degree plus normal generation | All 12 full Frattini actions; two rank-16 bases |
| `lem:transfer` | Section 6, operator substitution evaluated at one | Certified degrees of the shift inputs |
| `lem:deep-invariance` | Section 6, continuous equalizer and all layers | Exact convergent cost at `J=579` |
| `lem:finite-geometric-monodromy` | Section 7, stronger exact image theorem | All 32 actions and augmentation powers |
| `lem:distinguished-meridians` | Section 8, actual blowup-chart loops | No finite experiment substituted for this proof |
| `lem:weighted-gs`, `prop:infinite-quotient` | Sections 8--9 | Exact rational strict margin |

Both manuscripts' main chains are recorded in
`research/PROOF_GRAPH.json` and `research/MATH_STATE.json`.
The surface chain after this bottleneck is
`local-detection -> rational-special-fiber -> infinite-special-image
-> rational-hull -> thm:main`. Those geometric steps remain open
here. The separate fourfold chain is
`arrangement/orbifold-surface -> kernel-compatible hyperbolic models
-> path criterion -> true orbifold relations/cyclic image
-> projective realization and ambient blowdown
-> cyclic embedding -> large-group reduction -> thm:main`;
its correctness is also open.

The Engineer supports the theorem and its displayed proof, but
has not supplied an independent Reviewer judgement. Citation
attributions must be filed by someone other than the Engineer
who recorded the assumptions. The normal Reviewer must judge
the universal arguments, scope, and mathematical significance;
neither a passing script nor a structurally valid ledger grants
`closed_kernel`, `verified_new`, or campaign completion.
