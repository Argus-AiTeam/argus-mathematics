# The direct-image lemma, its exceptional sign, and the optimal constant

## Statement and scope

Write \(b=\dim Z\), \(e=\dim U-\dim Z\). Under exactly the hypotheses of
`nv:direct-image` (lines 530-554 of the staged section), all three printed
conclusions hold:
\[
 R_j={w\over e!}j^e+O(j^{e-1}),\qquad
 G+\lim_{j\to\infty}{c_1(\det f_*\mathcal O_U(j\Lambda))\over jR_j}
 =B:={f_*\beta^{e+1}\over(e+1)w}\geq0,
 \tag{1}
\]
\[
 \int_U\beta^{b+e}\leq(e+1)^b w\,\operatorname{vol}_Z(B).
 \tag{2}
\]
Here \(j\) runs through sufficiently divisible positive integers and
\(\geq0\) means pseudo-effective, **not** nef.

In fact, (2) holds for every nef real \((1,1)\)-class \(\beta\) with
\(w=\int_{U_z}\beta^e>0\), without the rational splitting. The constant
\((e+1)^b\) is optimal, even on smooth projective bundles with rational
ample classes. These are mathematical proofs using the standard external
inputs specified in `sources.md`, not kernel-checked analytic theorems.
Independent review and any novelty determination remain outstanding.
Neither the manuscript's main theorem nor `nv:meromorphic` is certified here.

The important improvement over the initial, unsupported proof-graph state is
a universal proof of the analytic bridge and a comparison of **currents**.
There is no assumption that resolution preserves equidimensionality, that
the base is projective, or that a pseudo-effective class is nef.

## 1. Rank and determinant

Put \(\lambda=c_1(\Lambda)\). On every fiber, the restriction of \(\lambda\)
has a positive representative: locally on the base, subtract a potential
of a smooth representative of \(G\) from a metric potential. After clearing
denominators the fiberwise relative ampleness criterion therefore makes
\(\Lambda\) relatively ample. Relative Serre vanishing gives
\(R^if_*\mathcal O_U(j\Lambda)=0\) for \(i>0\) and sufficiently large divisible
\(j\). Compactness permits one bound on \(j\). These are input A34-RELATIVE.

Apply proper **analytic** Riemann-Roch, A34-GRR, to the derived direct image:
\[
 \operatorname{ch}(f_*\mathcal O_U(j\Lambda))\operatorname{td}(Z)
 =f_*(\exp(j\lambda)\operatorname{td}(U)).
 \tag{3}
\]
The leading terms in degrees zero and two give
\[
 R_j={f_*\lambda^e\over e!}j^e+O(j^{e-1}),\qquad
 c_1(\det f_*\mathcal O_U(j\Lambda))
 ={f_*\lambda^{e+1}\over(e+1)!}j^{e+1}+O(j^e).
 \tag{4}
\]
All Todd terms contributing to the second formula have at most \(j^e\);
this includes multiplication by \(\operatorname{td}(Z)^{-1}\).
The direct image is torsion-free: a section killed by a nonzero base
function vanishes over a dense open subset of the connected smooth source,
and hence vanishes. It need not be locally free. Its degree-two Chern
character is the first Chern class of its determinant.

Now \(f_*\lambda^e=w\), and the projection formula gives
\[
 f_*(\lambda+f^*G)^{e+1}
 =f_*\lambda^{e+1}+(e+1)wG.
 \tag{5}
\]
Terms with two or more copies of \(G\) have a remaining power of \(\lambda\)
less than the relative dimension and push forward to zero. Dividing (4)
proves (1). The errors are in a finite-dimensional cohomology space, so
this is an actual class limit. The \(\partial\bar\partial\)-lemma identifies
the real \((1,1)\) classes with their Bott-Chern classes. If \(\omega\)
represents \(\beta\), the current
\[
 S={f_*(\omega^{e+1})\over(e+1)w}
 \tag{6}
\]
is positive and closed and represents \(B\). This proves pseudo-effectivity.
No connected-fiber or flatness hypothesis entered this argument.

## 2. The equidimensional fiber-integral lemma

**Lemma (C34-LELONG).** Let \(g:V\to Z\) be proper and equidimensional,
where \(V\) is reduced and pure of dimension \(b+e\), \(Z\) is smooth of
dimension \(b\), and every fiber has dimension \(e\). If \(\alpha\) is a
smooth closed semipositive \((1,1)\)-form on local ambient embeddings of
\(V\), then \(T=g_*(\alpha^{e+1}\cap[V])\) has zero Lelong number at every
point of \(Z\).

**Proof.** Fix \(z=0\) and Euclidean coordinates on a base ball. Properness
and compactness of \(V_0\) give finitely many relatively compact embedded
neighborhoods covering the fiber. Shrink the base ball so that their compact
subneighborhoods \(K\) cover its entire inverse image. On each neighborhood
\(\alpha\) is bounded above by a constant times the ambient Euclidean form.
Expand the \((b-1)\)-st power of the base Euclidean form into coordinate
projections. It suffices to estimate each resulting integral.

Fix a subset \(J\) of \(b-1\) base coordinates. The germ
\(\{g_J=0\}\cap V\) has dimension \(e+1\): the lower bound is the
codimension inequality, and the upper bound follows from the dimension
bound \(e\) on fibers over the one-dimensional coordinate slice. Thus
generic \(e+1\) linear ambient coordinates \(\ell\) make
\[
 F=(g_J,\ell):V\longrightarrow\mathbb C^{b-1}\times\mathbb C^{e+1}
 \tag{7}
\]
a finite map of germs. One way to see finiteness is to choose the kernel
of \(\ell\) disjoint from the projectivized tangent cone of
\(\{g_J=0\}\cap V\); then \(F^{-1}(0)\) is isolated. The local finite
mapping theorem supplies a finite representative. After shrinking and
working on \(K\), its degree is bounded.

There are enough such finite projections to dominate the integrand.
Indeed, finiteness is a nonempty open condition on the linear coordinates.
The \((e+1)\)-fold wedges of coordinate forms in this open set span the
exterior-power space: a linear functional vanishing on all these wedges
would be a polynomial vanishing on an open set, hence on every decomposable
wedge. Choose a finite spanning subfamily and use equivalence of Hermitian
norms. After wedging with the fixed \(g_J\) coordinate volume form, this
bounds the integrand by a constant times a finite sum of \(F^*dV\).
This argument also covers points where \(g_J\) has deficient differential
rank: both sides of that fixed coordinate summand then vanish.

For any one of these projections define
\[
 A_\delta=\ell(K\cap g^{-1}(\overline B_\delta)).
 \tag{8}
\]
The sets \(A_\delta\) are nested compact bounded sets. Compactness gives
\(\bigcap_{\delta>0}A_\delta=\ell(K\cap V_0)\), which has zero
\(2(e+1)\)-dimensional Lebesgue measure: it is the linear image of a compact
subset of an \(e\)-dimensional analytic set. Hence
\(\operatorname{Leb}_{2(e+1)}(A_\delta)\to0\), by continuity of finite
measure from above. The finite-map area formula, with degree bound \(N\),
gives
\[
 \int_{K\cap g^{-1}(B_\delta)}F^*dV
 \leq N\,\operatorname{Leb}_{2(b-1)}(\operatorname{pr}_J B_\delta)
             \operatorname{Leb}_{2(e+1)}(A_\delta)
 =o(\delta^{2(b-1)}).
 \tag{9}
\]
Summing the finite covers and projections proves
\[
 \int_{B_\delta}T\wedge(dd^c|z|^2)^{b-1}
 =o(\delta^{2(b-1)}).
 \tag{10}
\]
This is precisely zero Lelong number. When \(b=1\), the first Euclidean
factor is a point, its volume is one, and (10) says there is no atom.
The argument integrates over the regular locus with analytic-cycle
multiplicities; singular loci have zero top-dimensional integration mass.
This proves the lemma, including singular \(V\). \(\square\)

## 3. Flattening, nefness, and the exceptional sign

Use analytic projective flattening and resolution (A34-FLATTEN):
\[
 p:Z'\to Z,\quad g:\overline U\to Z',\quad
 r:U'\to\overline U,\quad f'=g r,\quad q:U'\to U.
 \tag{11}
\]
Here \(p,q\) are modifications, \(Z',U'\) are smooth compact Kähler,
and the **reduced main transform** \(\overline U\), not necessarily \(U'\),
is equidimensional of relative dimension \(e\). Let
\(\overline q:\overline U\to U\). The form \(\overline q^*\omega\) is smooth
on the local product embedding \(\overline U\subset U\times Z'\).
Since \(r_*[U']=[\overline U]\), the projection formula for currents gives
\[
 S':={f'_*(q^*\omega)^{e+1}\over(e+1)w}
 ={g_*((\overline q^*\omega)^{e+1}\cap[\overline U])\over(e+1)w}.
 \tag{12}
\]
Section 2 applies to the right side. Thus \(S'\) has zero Lelong numbers
everywhere, even though resolving \(\overline U\) can create larger fibers.
By A34-REG, its class \(B'\) is nef. Also \(p_*S'=S\), by
\(pf'=fq\) and the projection formula for the modification \(q\).

Here is a direct proof of the exceptional comparison, avoiding both
relative negativity and any identification of a cohomological kernel.

**Lemma (C34-EXCEPTIONAL).** If \(p:Z'\to Z\) is a modification of smooth
complex manifolds, \(S,S'\) are positive closed \((1,1)\)-currents,
\(p_*S'=S\), and every Lelong number of \(S'\) is zero, then
\[
 p^*S=S'+[D],\qquad D\geq0\ \text{\(p\)-exceptional}.
 \tag{13}
\]

**Proof.** The pullback \(p^*S\) exists and is positive by pulling back local
plurisubharmonic potentials. The real closed order-zero current
\(R=p^*S-S'\) is supported on the exceptional locus, because \(p\) is an
isomorphism on its complement.

For completeness, the order-zero support theorem needed here can be seen
locally. Along the smooth locus of a divisor \(\{z_1=0\}\), multiplication
by \(z_1,\bar z_1\) kills a measure current supported there. Closedness then
gives \(dz_1\wedge R=d\bar z_1\wedge R=0\). Its only possible \((1,1)\)
component is normal-normal; the remaining closedness equations say its
tangential scalar distribution has zero derivatives. It is constant.
Consequently \(R=a[E]\) there. After subtracting these constants for the
irreducible exceptional divisors, the remainder is supported on an analytic
set of complex codimension at least two. On its smooth strata the same
argument gives four independent normal one-forms annihilating a degree-two
current, so the current is zero. Descending through the lower-dimensional
singular strata proves the remainder is zero.

Thus \(R=\sum a_i[E_i]\). At a generic smooth point of \(E_i\), additivity
of the Lelong numbers of the two positive currents in this equality gives
\[
 a_i=\nu(p^*S,E_i)-\nu(S',E_i)=\nu(p^*S,E_i)\geq0.
 \tag{14}
\]
This proves (13). In base dimension one a modification is an isomorphism,
so the sum is empty. \(\square\)

Applying the lemma to (6), (12) proves the printed sign
\[
 B'=p^*B-\{D\},\qquad D\geq0.
 \tag{15}
\]
Volume monotonicity and modification invariance (A34-VOL) now give
\[
 \int_{Z'}(B')^b=\operatorname{vol}(B')
 \leq\operatorname{vol}(p^*B)=\operatorname{vol}(B).
 \tag{16}
\]
The assertion is not that \(B\) itself is nef.

## 4. The mixed-intersection bound

Let \(C=B'+\varepsilon\kappa\), with \(\kappa\) Kähler on \(Z'\) and
\(\varepsilon>0\), and put
\[
 I_k=\int_{U'}(q^*\beta)^{e+k}(f'^*C)^{b-k},\quad 0\leq k\leq b.
 \tag{17}
\]
These are mixed intersections of nef real classes. They are positive:
on the common dense open set where \(q\) is locally biholomorphic and
\(f'\) is a submersion, the first form is positive definite and the
second has rank \(b\), giving a strictly positive integrand. Moreover
\[
 I_0=w\int_{Z'}C^b,\qquad
 I_1=(e+1)w\int_{Z'}B'C^{b-1}\leq(e+1)I_0.
 \tag{18}
\]
A34-KT gives \(I_k^2\geq I_{k-1}I_{k+1}\).
Dividing by the positive denominators shows that
\(I_{k+1}/I_k\leq I_k/I_{k-1}\). Multiplication yields
\[
 I_b\leq I_0(I_1/I_0)^b\leq(e+1)^b w\int_{Z'}C^b.
 \tag{19}
\]
For \(b=1\) this just uses (18); no nonexistent middle inequality is needed.
The exact polynomial propagation identity in `verify.py` is another
division-free check of the sign in this step.

Since \(q\) is a modification, \(I_b=\int_U\beta^{b+e}\). Let
\(\varepsilon\downarrow0\) and use (16). This proves (2) universally.
Notice that sections 2-4 used no rational splitting of \(\beta\).

For the nef extension choose a Kähler class \(\eta\) on \(U\) and apply
the already proved result to \(\beta_\delta=\beta+\delta\eta\).
Then \(w_\delta\to w>0\) and
\(f_*\beta_\delta^{e+1}/((e+1)w_\delta)\to B\).
Pseudo-effectivity is closed and analytic volume is continuous (A34-VOL).
Taking \(\delta\downarrow0\), and using
\(\operatorname{vol}_U(\beta)=\int_U\beta^{b+e}\), proves the stated extension.

## 5. Optimality and exact test families

Use the quotient convention for
\(f:U=\mathbb P_{\mathbb P^b}(\mathcal O(1)\oplus\mathcal O^{\oplus e})
\to\mathbb P^b\). Put \(H=f^*c_1(\mathcal O_{\mathbb P^b}(1))\),
\(\xi=c_1(\mathcal O_U(1))\), and \(\beta=\xi+tH\), with rational \(t>0\).
The bundle is globally generated. Its relative embedding into a product of
projective spaces shows that \(\xi+tH\) is ample for every such \(t\).
All printed hypotheses hold with \(G=tH\), \(\Lambda=\mathcal O_U(1)\).

The projective-bundle relation and normalization are
\[
 \xi^{e+1}=H\xi^e,\quad H^{b+1}=0,\quad\int_U\xi^eH^b=1.
 \tag{20}
\]
Consequently
\[
 w=1,\quad B=(t+1/(e+1))H,\quad
 \int_U\beta^{e+b}=\sum_{i=0}^b\binom{e+b}{i}t^i.
 \tag{21}
\]
For every \(1\leq i\leq b\),
\[
 {\binom{e+b}{i}\over\binom bi}
 =\prod_{r=0}^{i-1}{e+b-r\over b-r}\leq(e+1)^i,
 \tag{22}
\]
since \((e+1)d-(e+d)=e(d-1)\geq0\) for \(d=b-r\geq1\).
Thus (2) is also visible coefficientwise in this family. More importantly,
\[
 \lim_{t\downarrow0,\ t\in\mathbb Q}
 {\int_U\beta^{e+b}\over w\,\operatorname{vol}(B)}=(e+1)^b.
 \tag{23}
\]
This proves optimality among the original **ample** examples by a limit;
it does not assert that \(t=0\) is Kähler.

In the same example \(R_j=\binom{j+e}{e}\) and
\[
 c_1(\det f_*\mathcal O_U(j))
 =\binom{j+e}{e+1}H={jR_j\over e+1}H.
 \tag{24}
\]
The second identity follows by summing the exponents of any one variable
over all degree-\(j\) monomials in \(e+1\) variables: symmetry assigns one
\((e+1)\)-st of the total degree to each variable. It proves the determinant
normalization exactly, not just asymptotically.

For \(e=1,b=2,t=1\), (21) gives volume \(7\), \(B=\tfrac32H\), and right
side \(9\). The rational moment polytope has slices
\(\{y,z\geq0:y+z\leq1+x\}\), \(0\leq x\leq1\). Its Euclidean volume is
\(\int_0^1(1+x)^2/2\,dx=7/6\). The inspected Jacobian operation returns
exactly \(7/6\); its exact payload and typed output are preserved under
`jacobian/`. This is a toric example check, not an analytic proof oracle.

For a genuinely **non-equidimensional** example, let
\(p:Y=\operatorname{Bl}_z\mathbb P^b\to\mathbb P^b\), \(b\geq2\), with
exceptional divisor \(E\). On \(\mathbb P^e\times Y\) take
\(\beta=H_f+H-\delta E\), \(0<\delta<1\) rational, and
\(f=p\circ\operatorname{pr}_Y\). It is ample. Its fiber over \(z\) has
dimension \(e+b-1\), while its general fiber has dimension \(e\).
Flattening by \(p\) has main transform \(\mathbb P^e\times Y\), and
\[
 w=1,\quad B=H,\quad B'=H-\delta E,\quad D=\delta E,\quad
 \int(B')^b=1-\delta^b,\quad
 \int\beta^{e+b}=\binom{e+b}{b}(1-\delta^b).
 \tag{25}
\]
For product representatives \(S'\) is a smooth Kähler form in \(B'\).
The current comparison (13) therefore shows that the original \(S\)
has Lelong number \(\delta\) at \(z\) (pullback to the point blowup computes
that Lelong number). Thus it is false to claim zero Lelong numbers before
flattening merely because the source form is smooth. For \(e=1,b=2\),
\(\delta=1/2\), the two sides of (2) are \(9/4\) and \(4\);
\(\int(B')^2=3/4\).

For divisible \(j\) the sheaf in this example is
\[
 \left(\mathcal O_{\mathbb P^b}(j)\otimes
                 \mathcal I_z^{\delta j}\right)^{\oplus\binom{j+e}{e}}.
 \tag{26}
\]
Since \(z\) has codimension at least two, its determinant has class
\(jR_jH\), agreeing exactly with (1), although the sheaf need not be locally
free. Formula (25) also certifies the direction of the exceptional
subtraction; reversing its sign would violate nefness on a line of \(E\).

## 6. Applicability to `nv:diagonal-mass`

In the actual construction \(d=\dim Z=2n+1\), \(n\geq2\).
The smooth projective bundle \(E=\mathbb P_Z(\Omega_Z)\to Z\) has relative
dimension \(d-1\). A smooth projective modification \(h:U\to E\) and the
displayed rational-divisor approximation give
\[
 \beta=f^*(2M)+c_1\!\left(s h^*\mathcal O_E(1)-\mathcal O_U(D')\right),
 \quad f=(E\to Z)h.
 \tag{27}
\]
Both spaces are smooth connected compact Kähler, \(f\) is surjective
projective, \(b=d\geq1\), \(e=d-1\geq1\), \(s,D'\) are rational, and
\(\beta\) is Kähler. The class \(2M\) may remain real. Thus every printed
hypothesis is met, without an assumption about the dimensions of special
fibers or the projectivity of \(Z\). In particular
\[
 R_j={w\over(d-1)!}j^{d-1}+O(j^{d-2}),\quad
 B=2M+\lim_j{c_1(\mathcal F_j)\over jR_j},\quad
 \int_U\beta^{2d-1}\leq d^d w\,\operatorname{vol}(B).
 \tag{28}
\]
This verifies the use of `nv:direct-image` in that lemma. It does not
silently verify the existence/order-retention of the rational approximation,
the later slope bounds, or the choice of \(s\); those are separate graph
obligations.

## What the executable certificate does and does not prove

Run `python3 research/direct-image-volume/verify.py`. It checks exact
polynomial identities, monomial determinant counts, the intersection
formulas and inequality orientation in (20)-(26), and source-binding of the
single Jacobian call. Its negative controls reject an incorrect volume,
an altered payload, and a reversed exceptional sign.

The analytic finite-projection argument, regularization, flattening,
Riemann-Roch, volume properties, Kähler geometry, and interpretation of
these intersection rings are mathematical proof/source obligations, not
facts decided by a finite computation. They are explicitly separated in
`exact_certificate.json`. No Lean source is supplied: formalizing only the
elementary ratio identity would not reduce the disputed analytic
uncertainty. The initial ledger contained no prior certified result to
supersede. Independent Reviewer replay is the next required step.
