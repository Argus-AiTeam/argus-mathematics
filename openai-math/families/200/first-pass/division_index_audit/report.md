# The generic division-index bridge

## Result and scope

This report gives an assumption-explicit mathematical proof of
`thm:division`, including **index**, not just degree. It also isolates a
structural extension: the index proof works for any constant connected
etale finite-group cover of a positive-genus curve, with the linearized
line bundle specified below. The special binary-addition identities are
not needed for the index theorem.

The proof is submitted for independent review. It is not a Reviewer
certificate, a proof of either manuscript's remaining assembly argument,
or a resolution of EGH or lex-plus-powers. No false assertion in the
audited sections has been established. In particular, neither prescribed
splitting over `K` nor splitting at a special parameter is a refutation.
Novelty and publishable significance remain unassessed.

The separate Lean certificate proves the universal nilpotent-lifting
core in Section 7, with no proof holes. It does **not** formalize the
algebraic geometry or certify the entire division theorem by itself.
The finite computations in `verify.py` are exact regression checks and
explicit algebraic certificates, not replacements for the quantified
proof below.

## 1. Exact objects and hypotheses

Let `k` be a finitely generated extension of the original complex
constant field, and let `Delta0/k` be central division of degree `e0`.
Let `b >= 2`, `dim(U) >= 3`, and
`W <= Sym^b(U^dual)`, with `s = dim(W)`. Every nonzero geometric member
of `W` must have an irreducible factor of multiplicity one. Put

\[
 h\ge\max\left(\{2\}\cup
 \{v_p(e_0)s(p^{v_p(b)}-1):p\mid e_0\}\right),\qquad
 M\ge2h+4s+10 .
\]

Use exactly the manuscript's sum-of-powers cone `Y` and `X = P(Y)`.
Initially take exactly its curve `C`, group `G`, and genuinely
linearized line bundle `L`. Thus
`e = |G| = b^b`, `gT = b-1`,
`g(C)-1 = e(gT-1)`, and `deg(L)=e`. Define

\[
 B=(\operatorname{Pic}^0 C)^{M-1},\quad
 P=(\operatorname{Pic}^1 C)^{M-1},\quad Z=B\times P,\quad
 H=G^{M-1},\quad e_1=|H|.
\]

The action on block `m` of `Y` is an **arbitrary**
character `rho_m : H -> mu_b`. No faithfulness or special relation
among these characters is assumed. The affine linear representation
`R` is faithful. Retain the generic fields

\[
 K=k(B\times X\times R),\qquad F=K^H,
\]

the generic section space
`E = tensor_(m=2)^M H^0(C_K,A_m L^gT)`,
and the specified transport algebra

\[
 \Delta_1=\operatorname{End}_K(E)^H,\qquad
 \Delta=(\Delta_0\otimes_k F)\otimes_F\Delta_1.
\]

The assertion proved is
\(\operatorname{ind}_F(\Delta)=e_0e_1\).
None of these fields, actions, or coefficient algebras is replaced by a
specialization.

There exists an abstract embedding `k -> C`: its transcendence degree
over the prime field is that of `C`, since adjoining finitely many
elements does not change the infinite transcendence-basis cardinality.
Embed a transcendence basis and extend over the algebraic part into an
algebraic closure. Such an embedding need not fix the original
constants. The proof never requires a constants-fixing embedding.

The non-elementary background inputs are the ones recorded as external
assumptions in `research/MATH_STATE.json`: proper-support base change
and composition, manifold cohomological dimension, smooth-open
Lefschetz, the Abel-period description of a Jacobian, determinant
functoriality, algebraic Riemann-Roch, integral complex K-theory, and
faithfully flat descent/base change. Their hypotheses, source readings,
and the one historical-version limitation are recorded in
`literature/source_readings.md`. These are background theorems, not
assumptions that the manuscript's division or Euler propositions hold.

## 2. The parameter-space input really supplies the required range

Here is a check of the parts of Section 04 used later. Work after a
complex embedding and write
`N = M dim(U)`, `d = N-s`, `c = M-2s+1`, and `kappa = M+2h`.
For `s=0`, the punctured cone is a sphere up to homotopy, and
`2N-2 >= kappa`; the assertions are immediate.

For `s>0`, an incidence with `[w] in P(W)` bounds the defective
Jacobian locus in the ambient affine space by
`N-M+s-1`. Each nonzero `w` has nonzero gradient somewhere, which
is all that this dimension bound requires. Every component of the
zero locus has dimension at least `d`, and the bound is strictly
smaller than `d`. Thus every component has a smooth dense open of
dimension `d`. The equations form a regular sequence; their complete
intersection is Cohen-Macaulay, generically reduced, and hence reduced.
The omitted nonzero smooth locus has complex codimension at least
`c`. The origin does not worsen this bound since `d >= c`.

The multiplicity-one condition is used for a different purpose.
A meridian about a smooth point of a simple irreducible factor gives
transitive monodromy on the `b` roots in the nonzero homogeneous
fiber. Hence that fiber is connected, even if other factors have
multiple multiplicities. The half-plane open cover in
`lem:homogeneous-joins` identifies a level of a sum of two forms
with the homotopy pushout of the two projections from the product
of their nonzero fibers. This is their join. Iteration makes the
sum-of-`M`-copies level have zero reduced integral homology through
degree `2M-2`; Tor terms in the join formula do not enter below that
degree.

For completeness, the nonproper family step is legitimate. In the
open incidence `Hcal`, the projection to the complement of `Y` is
an affine bundle with contractible fiber. The other projection has
base `O_(P(W))(1)^times` of real dimension `2s`, fiber complex
dimension `N-1`, and top compact-support degree `q=2N-2`. Proper
supports give

\[
 R^qp_!\mathbb Z=\mathbb Z,\qquad
 R^ip_!\mathbb Z=0
 \quad(q-(2M-2)\le i<q,\ i>q).
\]

The top sheaf is constant by complex orientation and connectedness of
the fibers, not by an unproved assertion of local triviality.
In total degree `q+2s-j`, `0 <= j <= 2M-2`, only the top row of
compact-support Leray can occur: the next possible row would require
base degree at least `2s-j+2M-1 > 2s`. A differential leaving the
top row has length at least `2M > 2s` and has zero target.
Duality therefore identifies the complement homology in this range
with that of `O(1)^times`, which retracts to `S^(2s-1)`.

The closed/open sequence and removal of the singular locus apply in
the desired range because

\[
 2s+\kappa-1\le 2M-2,\qquad
 \kappa\le 2c-2,\qquad
 2d-j-1>2(d-c)\quad(0\le j\le\kappa).
\]

All follow from the stated bound on `M`; none requires increasing it.
They give connectedness and vanishing of the positive reduced
homology of `Y^o` through degree `kappa`. Connectedness of the disjoint
dense smooth component loci proves geometric integrality.

Homology alone would not prove the homotopy assertion.
Hamm-Le, Theorem 1.1.3(ii), applies to the projective closure with
its algebraic singular locus deleted. Successive general hyperplane
sections down to a surface surject on fundamental groups.
Since `codim(Sing X)>h>=2`, the surface misses that locus and is
a smooth projective complete intersection. The usual smooth
projective Lefschetz flag makes it simply connected. Consequently
`X_sm` is simply connected. The circle-bundle sequence for
`O_X(-1)^times` makes `pi_1(Y^o)` an abelian quotient of `Z`;
the already proved `H_1=0` makes it zero. Hurewicz now upgrades the
homology vanishing to `kappa`-connectivity.

This also verifies that a general `h`-dimensional linear section
`D0` is smooth, lies in `X_sm`, and is the intersection of `s`
degree-`b` hypersurfaces in `P^(h+s)`.

## 3. Curve data and the transport cocycle

The prescribed curve construction has no prime-power restriction on
`b`. At `s=zeta^(-j)` the valuation of the corresponding Kummer
ratio is one and that of every other numerator is zero. Thus the
`b-1` classes are independent over `Z/b`, also for composite `b`.
One can check the extension degree without using a prime-degree
shortcut: adjoin these radicals successively. At the next numerator's
zero, every previously adjoined ratio is a unit with a `b`-th root
in the completed local ring. The previous extension therefore has
an unramified place there, while the next radical polynomial is
Eisenstein of degree `b`. Each step has degree `b`.
The resulting cover of the `t`-line has branch values `0,1,infinity`,
all of inertia order `b`. Every nontrivial subextension of
`d^b=t(t-1)/(t-2)` is ramified at `2`, whereas the first cover is
unramified there. Their intersection is trivial. Normalization of
the fiber product is connected, and equal local inertia orders
remove the original ramification. Counting cells over the complement
of the branch points, and adding their fibers, gives
`chi(T0)=2b-4(b-1)`; the etale cover then gives
`chi(C)=e*chi(T0)`. This gives the connected etale `G`-cover and
the stated genera.

The diagonal `mu_b` acts trivially on `O(b)`, so its pulled-back
linearization is genuine. The degree is `e`. The case `b=2` has
genus one, not genus zero; its generic degree-zero line is
nontrivial and is outside the degree-zero effective locus.
In every case the generic section dimension is `e` by
Riemann-Roch and the proper effective locus in degree `g(C)-1`.
It follows that `dim_K(E)=e1`.

If a nonidentity element of order `a` fixed a degree-one Picard
class, an isomorphism of its transported line with itself could
be rescaled over `C` to satisfy the cyclic group law. Etale
descent to the quotient curve would make its degree divisible by
`a`, a contradiction. Thus `H` acts freely on `P`.

For any character `xi:G->mu_b`, lift its monodromy class on the
quotient curve from `H^1(-,Z/b)` to integral `H^1`; its first
homology is free abelian. Pullback and division by `b` have
integral periods on `C`. The harmonic representative integrates
to the required character-valued circle map. The Abel-period
description extends it to `Pic^1(C)`. This works for nonfaithful
characters and nonabelian groups, since only their characters
are used. Products realize every coordinate `rho_m`.

The action on `R` makes the action on `K` faithful. Hence `K/F`
is finite Galois with group `H`. Transport of the normalized
universal lines is unique only up to scalar, but conjugation on
their section-space endomorphisms removes that ambiguity.
Descent of the endomorphism algebra, multiplication, and unit
gives a central simple algebra of degree `e1`. This step alone
does not assert division.

Now let `N` be **any** finite right `Delta`-module of reduced
rank `r`. Morita tensoring its pullback with `E` produces a
generic right `Delta0`-module `Feta` of dimension `e0*r`.
It has scalar weight **plus one** in each universal `A_m`.
The Hom-lines `J_g` have associative composition and
`J_g tensor g_*Feta ~= Feta`. A coherent lattice is obtained by
summing the finitely many transported lattices, including a
`k`-basis of the constant `Delta0` action. The Hom-line
composition permutes the summands, so the resulting coherent
sheaf `Fcal` has the corrected transport globally.

For one pair of universal lines of degrees zero and one put

\[
 D(A,V)=\det Rq_*(AV)^{-1}
         \otimes\det Rq_*A\otimes\det Rq_*V .
\]

With `g=g(C)`, its scalar exponents in `A,V` are

\[
 (-(2-g)+(1-g),\;-(2-g)+(2-g))=(-1,0).
\]

Thus `Dcal = tensor_m D(A_m,V_m)` has the inverse `A`-weight
of `Fcal` and no residual `V`-weight. This checks more than
the numerical exponents: choose local identifications of the
transported universal lines. Functoriality of determinant
maps compares their successive compositions with the
associative Hom-line composition. Any changed identification
contributes inverse scalars on `Fcal` and `Dcal`. The maps
therefore agree on overlaps and satisfy the group law
exactly. No projective scalar cocycle survives.

The origin of `R` is fixed. Its finite equivariant Koszul
resolution gives a well-defined **derived** restriction
`beta` on `Z times X`, with a commuting right `Delta0`
action. No flatness of `Fcal` over `R` is being assumed.
Nonequivariantly,
`beta = Dcal tensor pr_(B times X)^*(eta)` for a coherent
class `eta`.

## 4. Fiber index and the arithmetic Euler divisibility

After a complex embedding, reduce the constant matrix algebra
by a primitive idempotent `epsilon`, and write `beta'=beta epsilon`.
On the connected smooth product, a finite locally free resolution
of `Fcal` has constant alternating rank `e0*r`. Derived
restrictions preserve it, and idempotent reduction divides it
by `e0`. Thus for every `x in X_sm`,

\[
 \beta'|_{Z\times x}
 =Dcal\otimes\operatorname{pr}_B^*\gamma_x,\qquad
 \operatorname{rk}(\gamma_x)=r .
\]

The determinant first Chern class is exactly
`theta = -q_*(c1(A)c1(V))`. Indeed
`-exp(a+v)+exp(a)+exp(v)` has constant term one, zero
degree-two term, and degree-four term `-av`;
the curve has no degree-four Todd term. Normalization
removes the pure parameter components. The pure degree-one
curve component of `V` cannot enter this pushforward, so
`theta` is purely mixed between the two Picard factors.

Choose symplectic bases via the Abel-period isomorphisms.
For one genus-`g` curve its mixed class can be written

\[
 \theta=\sum_{i=1}^{g}
   (a_i^B\wedge b_i^P-b_i^B\wedge a_i^P).
\]

The integral pairing matrix is unimodular, not twice a
unimodular matrix. Expanding the exterior product gives
`integral exp(theta)=(-1)^g` in these compatible orientations.
For a product, the sign is `(-1)^(g(M-1))`.
To reach top degree on `P`, every mixed summand already
uses the corresponding top degree on `B`. Therefore every
positive-degree term of `ch(gamma_x)` disappears. Picard
tangent bundles are trivial. Consequently

\[
 \int_Z\operatorname{ch}(\beta'|_{Z\times x})
                 \operatorname{td}(Z)=\pm r .
\tag{1}
\]

The sign is fixed; its value is immaterial for divisibility.

For the other numerical identity, let `delta:T'->Q` be any
constant finite-group torsor of projective schemes, of degree
`a`. In `K^0(Q)` set `d=[delta_*O]-a`. Multiplication by
`d` strictly lowers the dimension-of-support filtration on
`G_0(Q)`, because it has virtual rank zero on every integral
support. It is therefore nilpotent as an operator.
Since `delta^*d=0`, the projection formula gives
`(a+d)d=0` on `G_0(Q)`. Over `Q`, the operator `a+d` is
invertible by a finite geometric series. Hence `d` acts by
torsion, and the integer Euler characteristic kills its
image. This proves

\[
 \chi(T',\delta^*\alpha)=a\chi(Q,\alpha)
\tag{2}
\]

for every coherent class, without smoothness of `Q`.

Apply (2) to `(Z times X)/H`. This quotient exists and
is projective; its map from `Z times X` is a finite
etale torsor because the action on `P` is free.
The class `beta tensor O_X(l)` and its constant algebra
action descend, since `O_X(1)` is linearized.
Over **k**, every cohomology space downstairs is a module
over the **division** algebra `Delta0`. Its dimension
is divisible by `e0^2`. Therefore, for every integer `l`,

\[
 p(l)=\chi(Z\times X,\beta\otimes O_X(l))/e_0
                  \in e_0e_1\mathbb Z .
\tag{3}
\]

Flat field base change preserves these numerical Euler
characteristics, even for an embedding not fixing the
original constants. Idempotent reduction after base
change divides them by `e0`, so `p(l)` is also the Euler
characteristic of `beta' tensor O_X(l)`.
This division is performed only **after** (3) has been
obtained over `k`.

## 5. The integral projective-space family

Put `Ttor=(S^1)^M`, with `H'=rho(H)`. The principal
`H' times S^1` bundle over `(Ttor/H') times P^h`
has base dimension `M+2h`. The associated fiber is
the unit smooth cone, which is `kappa`-connected.
Cellwise section extension gives the equivariant lift
and the map `Phi:Ttor times P^h -> X_sm`.
Forgetting `H'`, the relative extension over a cylinder
has dimension `M+2h+1`, so the same connectivity gives
the claimed homotopy to `Phi0` after projection.
Circle equivariance gives
`Phi0^*O_X(-1) ~= O_(P^h)(-1)`, with no dualization.

Use the character maps of Section 3 to obtain
`vartheta:P->Ttor`. Then
`gamma(z,t)=(z,Phi(vartheta(p),t))`
is genuinely `H`-equivariant. It descends to a map
from `V times P^h`, where `V=Z/H` is smooth projective.
The pullback of `beta'` descends to an **integral**
topological K-class `tau`, not just a rational
Chern-character class.

Here is the integrality justification. Embed `V` into
`P^a` and use the complex Koszul Thom class of its
normal bundle `nu`. Its Chern character divided by
the cohomological Thom class is `td(nu)^(-1)`.
The tangent-normal sequence consequently converts
integration against `td(P^a)` to integration against
`td(V)`. The integral basis

\[
 K^0(P^a\times P^h)
   =\mathbb Z[v,u]/(v^{a+1},u^{h+1})
\]

then proves that integration lands in `K^0(P^h)`:
each `v^i` has integer Riemann-Roch integral on `P^a`.
No torsion is discarded in this step.

The covering `Z->V` has degree `e1` and pulls back
the tangent bundle. Consequently the fiber integral
of the pullback class has the form

\[
 \operatorname{ch}\left(\sum_{j=0}^h q_ju^j\right),
 \qquad q_j\in e_1\mathbb Z,\qquad
 u=1-[O_{P^h}(-1)] .
\]

The ordinary homotopy of `gamma` permits evaluation
using `Phi0`. Equation (1) at a point of `P^h`
gives `q0=plus or minus r`. Thus already `e1 | r`.
This argument would fail if equivariance were replaced
by projective equivariance, or if only rational
K-theory integrality were available; neither replacement
has been made.

## 6. Passing to the algebraic complete intersection

Take the smooth section `j:D0->X_sm` from Section 2.
Choose `h+1` linear forms without common zero on
`D0`; they give `f:D0->P^h` with the same pulled-back
tautological line as `j`. The two lifts to the
unit smooth cone are sections of the same associated
circle bundle. Relative cell extension over
`D0 times [0,1]`, of real dimension `2h+1`, makes
them homotopic. Hence `j` and `Phi0 f` are homotopic.

Riemann-Roch is now applied only to the **smooth
projective** product `Z times D0`. It gives

\[
 p_{D_0}(l)=
 \sum_{j=0}^h q_j
 \chi\!\left(D_0,(1-[O_{D_0}(-1)])^jO_{D_0}(l)\right).
\tag{4}
\]

Let `dX=dim(X)`. The defining hyperplanes have a
finite Koszul resolution of `O_D0` on `X`:
at their zero set the ambient variety is smooth and
the intersection transverse; away from it an equation
is a unit. Tensor this resolution **derivedly**
with `beta`. It follows, including when `X` is
singular, that

\[
 p_{D_0}(l)=\sum_{a=0}^{dX-h}(-1)^a
             {dX-h\choose a}p(l-a)
                       \in e_0e_1\mathbb Z .
\tag{5}
\]

The hyperplanes may be defined only after the complex
embedding: their Koszul terms still have the original
integer Euler characteristics on the right of (5).
This proves `prop:index-test` with all its quantifiers.

## 7. An independent nilpotent proof of the arithmetic step

### A universal algebraic lemma

In any commutative ring, suppose

\[
 aq=0,\qquad x^\nu=ad+pc,\qquad p^v=0.
\]

Then
\[
 x^{\nu v}q=p^vc^vq=0.
\tag{6}
\]
Indeed `x^nu q=pcq`, and commuting multiplication permits
raising both endomorphisms of the cyclic module generated
by `q` to the `v`-th power. This proof uses neither
cancellation by `p` nor an integral-domain hypothesis.
`nilpotent_lift` in `lean/Main.lean` proves (6).

Let now `A in Z[u]`, let `p` be prime, and suppose
`ord_u(A mod p)=nu`. For any `h>=nu`, write
`A mod p = u^nu B`, where `B(0)` is nonzero.
The finite coefficient recursion

\[
 D_0=B_0^{-1},\qquad
 D_n=-B_0^{-1}\sum_{i=1}^n B_iD_{n-i}
                  \pmod p
\]

constructs the inverse of `B` through degree `h-nu`.
Choose integer representatives. The coefficients
through degree `h` of `u^nu-AD` are divisible by `p`.
Separating those coefficients from the tail gives
an **exact integer polynomial identity**

\[
 u^\nu=AD+pT+u^{h+1}U .
\tag{7}
\]

This is the constructive assertion `C_DIA_BEZOUT`;
it does not assume the conclusion about `Q`.
The implementation verifies (7) as an exact identity,
not only at integer evaluation points.

Suppose `AQ=0 mod (p^v,u^(h+1))` and `h>=v*nu`,
where `v>=1`. In
`R=(Z/p^v)[u]/(u^(h+1))`, equation (7) and (6)
give `u^(nu*v) Q=0`. Since `nu*v<=h`, the
coefficient of `u^(nu*v)` in this product is
exactly `Q(0)`. Thus `p^v | Q(0)`.
This proves the manuscript's truncation lemma
for **all** its inputs, including `nu=0`.
The polynomial version of this coefficient argument,
given the explicit identity (7), is
`constant_zero_of_truncated_bezout` in the Lean source.

The degree condition is substantive. For every prime `p`,
`nu>=1`, and `v>=1`, set

\[
 A=p+u^\nu,\qquad
 Q=\sum_{i=0}^{v-1}(-p)^iu^{\nu(v-1-i)}.
\]

Then `AQ=u^(nu*v)-(-p)^v` and
`Q(0)=(-p)^(v-1)`. At `h=nu*v-1` the product
vanishes modulo `(p^v,u^(h+1))` but the
constant coefficient is not divisible by `p^v`.
These are negative controls for a **weakened**
lemma, not counterexamples to the manuscript.

### Applying it to the full family of twist indices

Set `Q_*(u)=sum_j(q_j/e1)u^j`. This has integer
coefficients by Section 5, and (4)-(5) say all its
twisted Euler characteristics are divisible by `e0`.
The complete intersection has Hilbert series

\[
 \frac{(1-t^b)^s}{(1-t)^{h+s+1}}.
\]

Finite differences of its Hilbert coefficients agree
with the Euler indices in sufficiently high degree.
Therefore the generating series of `p_D0(l)/e1`
differs from
`Q_*(1-t)(1-t^b)^s/(1-t)^(h+s+1)`
by an **integer polynomial**.
Multiply by the denominator first and reduce modulo
`e0`. Only at this polynomial stage substitute
`t=1-u`; no substitution in an infinite power
series at `t=1` is being made. The polynomial error
is a multiple of `u^(h+s+1)`. Hence

\[
 Q_*(u)(1-(1-u)^b)^s
      =0\pmod{(e_0,u^{h+s+1})}.
\]

Cancel the monomial `u^s` coefficientwise. This is
valid even over a ring with zero divisors and yields

\[
 A_b(u)^sQ_*(u)=0\pmod{(e_0,u^{h+1})},
 \qquad A_b(u)=\frac{1-(1-u)^b}{u}.
\tag{8}
\]

For each `p | e0`, write `b=p^a c` with `p` not
dividing `c`. Frobenius in `F_p[u]` gives

\[
 1-(1-u)^b=1-(1-u^{p^a})^c
                   =c\,u^{p^a}+\text{higher terms}.
\]

Thus `ord_u(A_b^s mod p)=s(p^a-1)`.
The prescribed `h` is at least this order times
`v_p(e0)`. Apply the preceding universal lemma
to (8) modulo `p^(v_p(e0))` to conclude
`p^(v_p(e0)) | Q_*(0)`.
For `p` not dividing `b`, the order is zero.
For `s=0`, `A_b^s=1`.
These boundary cases require no omitted positivity
assumption. Combining the prime powers proves

\[
 e_0\mid Q_*(0),\qquad e_0e_1\mid q_0=\pm r .
\tag{9}
\]

## 8. Why this proves index, and a structural extension

The chosen module was arbitrary. A central simple
algebra of degree `d=e0*e1` and index `i<d`
has a minimal nonzero right ideal of reduced rank
`i`: write it as `Mat_t(D)` with `deg(D)=i`.
This contradicts (9). Thus

\[
 \boxed{\operatorname{ind}_F(\Delta)
       =\operatorname{deg}_F(\Delta)=e_0e_1.}
\]

The argument has not inferred division from the
endomorphism-algebra degree calculation.
It has excluded every possible smaller simple-module
reduced rank.

There is a direct structural extension of the same
proof. Replace the special binary curve by **any**
constant connected etale `G`-cover `C->T0` of
smooth projective complex curves with `g(T0)>=1`.
Take **any** genuinely `G`-linearized line bundle
`L` of degree `|G|`, and define

\[
 E=\bigotimes_{m=2}^M H^0(C_K,A_m L^{g(T_0)}).
\]

Such a line exists, for example the pullback of
a degree-one line on `T0`. Multiplicativity of the
Euler characteristic of the etale covering gives
`g(C)-1=|G|(g(T0)-1)`. To see generic nonspeciality,
subtract an effective divisor of degree `|G|`
from `A L^g(T0)`. The resulting generic
degree-`g(C)-1` line has both cohomology groups
zero. The divisor exact sequence kills the first
cohomology of `A L^g(T0)`, and Riemann-Roch
gives section dimension `|G|`.
The free `Pic^1` and character-map arguments
apply to this cover without any special presentation
of `G`. Every subsequent step uses only these
properties, not the binary pencil or its monomial
sections. Retaining the same `U,W,b,h,M`, arbitrary
characters `H->mu_b`, faithful `R`, and generic
fields, the resulting algebra therefore has index

\[
 e_0|G|^{M-1}.
\]

This extension contains the stated `thm:division`
and leaves its uses in binary assembly unchanged.
It is a proved structural extension in the
mathematical sense of the preceding argument;
priority and novelty are not asserted.

## 9. What the executable evidence establishes

Run `python3 research/division_index_audit/verify.py`.
It checks the saved exact certificate against fresh
deterministic computations, the saved typed Jacobian
result, and the current source/fidelity hashes in the
real Lean compiler certificate. The initial certificate
can be reproduced with `--write-certificate`.

The checks cover the determinant weights, the
degree-four Riemann-Roch cancellation, explicit
exterior-algebra rank-extraction regressions,
constructive integral Bezout identities for edge and
composite-degree cases, the one-degree-below-threshold
negative controls, and the successful Lean core.
They do not turn those finite cases into the universal
proof: Sections 2-8 supply that proof using the
explicit background assumptions.

The formal certificate's scope is precisely
`C_DIA_FORMAL_CORE`. The whole division claim has
an Engineer proof judgement, not a kernel proof
or an independent Reviewer judgement. The graph
keeps both manuscripts' remaining main-theorem
dependencies open. Campaign completion, publishable
significance, and verified novelty cannot be
inferred from this handoff.

A single narrow literature lookup for this precise generic
Picard-transport index construction and its complete-intersection
stability did not identify an exact prior theorem. That limited
negative retrieval is not evidence that the structural extension
is new; the lookup's suggested neighboring works are not used
as assumptions here.
