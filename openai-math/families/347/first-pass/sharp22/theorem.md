# Cyclic-integral sharpness in real dimension twenty-two

## Statement

For every integer \(m\geq1\), there are a simply connected closed Kahler
manifold \(M_m\) of real dimension \(22\), with minimal Chern number one,
and a smooth one-periodic Hamiltonian \(H_m\), such that
\[
\#\operatorname{Fix}(\phi_{H_m}^1)
=\#\operatorname{Fix}_0(\phi_{H_m}^1;H_m)
=\beta_{\mathbb Z}^{\rm cyc}(M_m)=80+5312m,
\qquad
\operatorname{SM}(M_m)=\operatorname{Morse}(M_m)=80+5344m.
\]
All fixed points are nondegenerate. In particular the cyclic-integral
bound is attained, while the stable-Morse deficit is \(32m\), unbounded
in a fixed dimension.

Here \(d(T)\) is the minimum number of generators of a finite abelian
group, \(b(W)=\sum_i\operatorname{rank}H_i(W;\mathbb Z)\), and
\[
\lambda(W)=b(W)+2\sum_i d(\operatorname{Tor}H_i(W;\mathbb Z)),\qquad
\beta_{\mathbb Z}^{\rm cyc}(W)
=b(W)+2\sum_{\epsilon=0,1}
d\left(\bigoplus_{i\equiv\epsilon\ (2)}
\operatorname{Tor}H_i(W;\mathbb Z)\right).
\]
The stable Morse number uses functions on \(W\times\mathbb R^k\) equal
to a fixed nondegenerate quadratic form outside a compact set, with
\(k=0\) allowed.

**Certification scope.** The proof below is a geometric proof using the
classical Morse-attainment theorem stated in Section 4. `verify.py`
certifies the exact integral presentations, shifted-center profiles,
invariant factors, and affine-in-\(m\) counts. `Main.lean` separately
formalizes the convolution/sharpness criterion and the all-parameter
profile arithmetic. Neither checker constructs a complex manifold or a
Morse function, nor does either formalize the dynamical argument.
Independent Reviewer certification is still required; an algebraic
certificate alone does not close the geometric claim.

## 1. Projective torsion surfaces and simultaneous disjoint centers

Let \(E=\mathbb C/(\mathbb Z+i\mathbb Z)\),
\(E_2=E\), \(E_3=\mathbb C/(\mathbb Z+\zeta_3\mathbb Z)\), and
\[
S_p=(E\times E_p)/\langle\sigma_p\rangle,\qquad
\sigma_p(z,w)=(z+1/p,\zeta_p w),\quad p=2,3.
\]
The action has order \(p\); every nonidentity power translates the first
factor nontrivially. Its quotient is therefore a smooth compact surface.

These quotients are projective without requiring a classification of
bielliptic surfaces. A degree-three line bundle on an elliptic curve
embeds it in \(\mathbb {CP}^2\): Riemann--Roch after subtracting divisors
of degrees one and two proves basepoint-freeness and separation of
points and tangent vectors. The product embeds in \(\mathbb {CP}^8\).
Take the product of the linear forms representing the \(p\) points of
each orbit. This is a holomorphic map of the quotient into
\(\mathbb P(\operatorname{Sym}^p\mathbb C^9)\). Unique factorization
recovers the unordered orbit, so the map is injective. For immersion,
a projectively zero derivative would give
\[
\sum_j \dot L_j\prod_{k\ne j}L_k=a\prod_k L_k.
\]
The orbit forms \(L_j\) are pairwise nonproportional. Restricting to
\(L_j=0\) implies that \(\dot L_j\) vanishes on that hyperplane, since
the other factors have nonzero product in its polynomial ring.
Thus each \(\dot L_j\) is proportional to \(L_j\). Immersion of the
original embedding forces the original tangent vector to vanish.
The quotient map is a local biholomorphism; compactness upgrades the
injective immersion to an embedding. The receiving projective dimensions
are \(44\) and \(164\). Segre embeddings make all products below projective.

The deck group of \(\mathbb C^2\to S_p\) is
\(\Lambda_p\rtimes\mathbb Z^2\). The two generators of \(\mathbb Z^2\)
act on the lattice \(\Lambda_p\) by multiplication by \(\zeta_p\) and
the identity. Explicit lifts are
\((z,w)\mapsto(z+1/p,\zeta_p w)\) and
\((z,w)\mapsto(z+i,w)\); their intersection with the lattice of
translations in \(w\) is trivial. Consequently
\[
H_1(S_p;\mathbb Z)=\mathbb Z^2\oplus
\operatorname{coker}(\zeta_p-I:\Lambda_p\to\Lambda_p).
\]
In integral bases the two matrices are
\[
A_2=\begin{pmatrix}-2&0\\0&-2\end{pmatrix},\qquad
A_3=\begin{pmatrix}-1&-1\\1&-2\end{pmatrix}.
\]
Their Smith diagonals are \((2,2)\) and \((1,3)\), respectively.
For \(A_3\), the entries have gcd one and determinant three.
Write \(T_2=(\mathbb Z/2)^2\) and \(T_3=\mathbb Z/3\).
Integral Poincare duality and the universal coefficient theorem give
\(H_3(S_p)=\mathbb Z^2\) and
\(\operatorname{Tor}H_2(S_p)=T_p\). The finite torus cover implies
\(\chi(S_p)=0\), hence the free Betti ranks are
\((1,2,2,2,1)\). In particular,
\[
H_i(S_p)=
\begin{cases}
\mathbb Z,&i=0,4,\\
\mathbb Z^2\oplus T_p,&i=1,2,\\
\mathbb Z^2,&i=3,\\
0,&\text{otherwise}.
\end{cases}
\tag{1}
\]
The direct sum \(A_2\oplus A_3\) has Smith diagonal \((1,1,2,6)\).
The preserved Jacobian computation supplies integral unimodular matrices
\(U,V\) with \(U(A_2\oplus A_3)V=\operatorname{diag}(1,1,2,6)\);
the local verifier checks the equality and both determinants, rather
than trusting a claimed diagonal alone.

**Finite-union embedding lemma.** Any finite disjoint union of smooth
projective varieties of complex dimension at most \(d\) embeds
holomorphically in \(\mathbb {CP}^{2d+1}\).

Indeed, first place individual projective embeddings in independent
coordinate subspaces. In an ambient \(\mathbb {CP}^{D}\), \(D>2d+1\),
the union of secants between two distinct points has measure zero.
For every ordered component pair its parametrizing projective-line
bundle has complex dimension at most \(2d+1<D\); on a same-component
pair delete the diagonal. Sard's theorem applies on countably many
charts if this pair space is noncompact. Include cross-component
secants: they are necessary to preserve disjointness. The union of
projective tangent spaces also has measure zero, since its parametrizing
bundle has dimension at most \(2d<D\). Avoid these sets and the varieties
themselves when choosing a projection point. Projection is then
injective on the whole union and immersive on each component.
Compactness makes it an embedding. Repeating down to \(D=2d+1\)
proves the lemma.

Apply the lemma with \(d=4\), for each finite \(m\), to
\[
2m\ (S_2\times\mathbb {CP}^1),\qquad
3m\ S_3,\qquad
2m\ (S_3\times\mathbb {CP}^2).
\tag{2}
\]
Their dimensions are \(3,2,4\), so they embed disjointly in
\(\mathbb {CP}^9\). The argument is an existence proof for each \(m\),
not a claim that one embedding contains infinitely many centers.

## 2. Blowups, topology, and the complete integral decomposition

Blow up the centers (2) successively to obtain \(X_m\).
The three codimensions are \(6,7,5\), all at least two; disjointness
means later centers retain their original neighborhoods. Each blowup is
closed and Kahler. To see the latter, if \(E_Z=\mathbb P(\nu)\) is the
exceptional divisor, the curvature form \(\eta\) of \(\mathcal O(-E_Z)\)
can be chosen positive on its projective fibers.
The form \(\pi^*\omega+\varepsilon\eta\) is positive for small
\(\varepsilon>0\): \(\pi^*\omega\) is semipositive with precisely those
fiber directions as its kernel, and compactness supplies a uniform
choice of \(\varepsilon\). A metric on \(\mathcal O(-E_Z)\) with the
required restriction exists by extending the logarithm of its ratio
with any ambient metric.

Simple connectivity is also preserved. In real codimension at least
four, contracting disks for loops can be moved off the center by general
position. Every loop in the blowup can be moved off the exceptional
divisor (real codimension two); there it lies in the complement of the
center downstairs and contracts. Thus \(X_m\) is simply connected,
closed and Kahler, of complex dimension nine.

For a complex center \(Z\) of codimension \(c\), the integral formula is
\[
H_i(\operatorname{Bl}_Z A;\mathbb Z)
\cong H_i(A;\mathbb Z)\oplus
\bigoplus_{k=1}^{c-1}H_{i-2k}(Z;\mathbb Z).
\tag{3}
\]
This formula has no freeness assumption on \(H_*(Z)\). It is Theorem 4.1
of Duan--Li [DL], and can also be proved directly as follows.
Let \(\rho:E_Z\to Z\), \(\iota:E_Z\hookrightarrow\operatorname{Bl}_Z A\),
and \(h=c_1(\mathcal O_{E_Z}(1))\).
Integral Leray--Hirsch gives
\(H^k(E_Z)=\bigoplus_{j=0}^{c-1}h^j\rho^*H^{k-2j}(Z)\).
The Gysin lifts
\(-\iota_*(h^{j-1}\rho^*u)\) restrict to \(h^j\rho^*u\),
because the normal line has first Chern class \(-h\).
The quotient homeomorphism
\(\operatorname{Bl}_Z A/E_Z\cong A/Z\) identifies the relative
cohomology sequences. Those sequences show that a class restricting
to a pure \(h^0\) term on \(E_Z\) is pulled back from \(A\):
its \(h^0\) coefficient has zero connecting image, hence extends
to \(A\); the residual relative class is a pullback too.
Subtracting the Gysin lifts proves surjectivity of the proposed
cohomology splitting. Restriction to \(E_Z\) kills all positive-power
coefficients in any kernel element. The remaining ambient pullback
is injective, since the degree-one map has an integral left inverse
defined by Poincare duality. This also applies to torsion.
Finally duality in degree \(2\dim_{\mathbb C}A-i\), followed by
\(j\mapsto c-j\), gives (3).

In particular, for every integer \(i\),
\[
\begin{split}
H_i(X_m)\cong H_i(\mathbb {CP}^9)
&\oplus\left(\bigoplus_{k=1}^{5}
H_{i-2k}(S_2\times\mathbb {CP}^1)\right)^{\oplus2m}\\
&\oplus\left(\bigoplus_{k=1}^{6}H_{i-2k}(S_3)\right)^{\oplus3m}\\
&\oplus\left(\bigoplus_{k=1}^{4}
H_{i-2k}(S_3\times\mathbb {CP}^2)\right)^{\oplus2m}.
\end{split}
\tag{4}
\]
All projective-space factors have free even homology, so integral
Kunneth introduces no extra Tor terms.

## 3. Exact primary profiles, including all boundary indices

For \(r=0,1,2\), let
\[
f_r(j)=\#\{(k,l):1\leq k\leq6-r,\quad0\leq l\leq r,\quad k+l=j\}.
\]
Outside \(1\leq j\leq6\) these numbers vanish. Equation (4) gives,
in both degree lists \(1+2j\) and \(2+2j\),
\[
\operatorname{Tor}H_{1+2j}(X_m)
=\operatorname{Tor}H_{2+2j}(X_m)
\cong(\mathbb Z/2)^{ma_j}\oplus(\mathbb Z/3)^{mq_j},
\quad a_j=4f_1(j),\quad q_j=3f_0(j)+2f_2(j).
\]
The equality here means isomorphism of groups, not equality of chosen
subgroups in different degrees.

| profile, indexed from \(j=1\) | entries | sum |
|---|---|---:|
| \(f_0\) | \(1,1,1,1,1,1\) | 6 |
| \(f_1\) | \(1,2,2,2,2,1\) | 10 |
| \(f_2\) | \(1,2,3,3,2,1\) | 12 |
| \(a\) | \(4,8,8,8,8,4\) | 40 |
| \(q\) | \(5,7,9,9,7,5\) | 42 |
| \(\delta=a-q\) | \(-1,1,-1,-1,1,-1\) | -2 |

The free rank calculation from the same centers is
\[
b(X_m)=10+
m(2\cdot16\cdot5+3\cdot8\cdot6+2\cdot24\cdot4)
=10+496m.
\tag{5}
\]

For \(v,w\geq0\),
\[
d((\mathbb Z/2)^v\oplus(\mathbb Z/3)^w)=\max(v,w).
\tag{6}
\]
Reduction modulo either prime gives the lower bound. Pairing
\(\min(v,w)\) factors by the Chinese remainder theorem gives invariant
factors consisting of \(|v-w|\) copies of the unpaired prime, followed
by \(\min(v,w)\) copies of \(6\). They form a divisibility chain and
achieve the lower bound.

Write \(C_m=X_m\times\mathbb {CP}^1\).
Section 5 constructs \(Y\) with free even ranks \((1,6,1)\), and we
set \(M_m=X_m\times Y\). Their primary profiles are the convolutions
with \(e_C=(1,1)\) and \(e_M=(1,6,1)\), respectively. Zero extension
is essential at both ends.

| profile per parity, divided by \(m\) | entries from \(j=1\) | sum |
|---|---|---:|
| \(e_C*a\) | \(4,12,16,16,16,12,4\) | 80 |
| \(e_C*q\) | \(5,12,16,18,16,12,5\) | 84 |
| \(e_C*\delta\) | \(-1,0,0,-2,0,0,-1\) | -4 |
| \(e_M*a\) | \(4,32,60,64,64,60,32,4\) | 320 |
| \(e_M*q\) | \(5,37,56,70,70,56,37,5\) | 336 |
| \(e_M*\delta\) | \(-1,-5,4,-6,-6,4,-5,-1\) | -16 |
| \(\max(e_M*a,e_M*q)\) | \(5,37,60,70,70,60,37,5\) | 344 |

These tables are complete, since the supports are contained in
\([1,7]\) and \([1,8]\). In particular the two positive entries in
\(e_M*\delta\) are distinct (indices \(3,6\)); their neighboring
negative entries do not overlap to create another positive entry.
The sum of its positive parts is exactly \(8\).

More generally, on any finite index set
\(\sum_j\max(a_j,q_j)=\sum_j q_j\) if and only if
\(a_j\leq q_j\) for every \(j\). This follows by summing the
nonnegative differences \(\max(a_j,q_j)-q_j\).
Here the criterion holds for \(e_C\), but fails in precisely the
two displayed places for \(e_M\).
Consequently, using both parity lists and the factor two in \(\lambda\),
\[
\begin{aligned}
\lambda(C_m)&=2b(X_m)+4(84m)=20+1328m,\\
\lambda(M_m)&=8b(X_m)+4(344m)=80+5344m,\\
\beta_{\mathbb Z}^{\rm cyc}(M_m)
&=8b(X_m)+4\max(320m,336m)=80+5312m\\
&=4\lambda(C_m).
\end{aligned}
\tag{7}
\]
These are identities for every \(m\geq0\), not extrapolations from
sampled values: copies add primary multiplicities linearly, and
\(\max(mu,mv)=m\max(u,v)\) for \(m\geq0\).
All geometric assertions in the theorem are made for \(m\geq1\).

As an adversarial boundary test, the verifier also reconstructs the
same seven-center pattern at shift lengths \(L=3,4,5,6,7\).
It is not sharp at \(L=3,4\); adjacent positive differences survive
the \((1,1)\) convolution. Thus one cannot apply an arbitrary-short-
profile assertion. The present theorem uses the explicitly checked
\(L=6\) only. This observation does not refute a manuscript assertion:
the staged sharp construction has \(L=1661\), not \(3\) or \(4\).

## 4. Stable lower bound and genuine Morse attainment

For any finite free integral complex, let
\(Z_i=\ker\partial_i\), \(B_i=\operatorname{im}\partial_{i+1}\).
The exact sequences give
\[
\operatorname{rank}C_i
=r_i+\operatorname{rank}B_i+\operatorname{rank}B_{i-1}.
\]
Smith normal form of \(B_i\subset Z_i\) shows
\(\operatorname{rank}B_i\geq d(\operatorname{Tor}H_i)\).
Summing proves the rank lower bound \(\sum_i\operatorname{rank}C_i
\geq b+2\sum_i d(\operatorname{Tor}H_i)\).

This bounds the geometric stable Morse number too, including indefinite
quadratic stabilizations. Write the quadratic form at infinity as
\(Q(u,v)=-|u|^2+|v|^2\), with \(u\in\mathbb R^\nu\).
For an admissible Morse function \(F\), choose a core radius \(R_0\),
\(A>\max_{\text{core}}\{|F|,|Q|\}\), and \(T>R_0\) with \(T^2>A\).
On \(K=W\times\overline B_T\), the endpoint sublevels at \(-A,A\)
are exactly those of \(Q\). On the side sphere the only possible
critical values of \(Q\) are \(\pm T^2\), so none lie in the band.
Choose a gradient-like vector field tangent to that side boundary
using a boundary field, a collar, and a partition of unity.
The ordinary Morse attachment theorem then gives a finite free
relative complex with one generator per critical point. Its homology
is \(H_*(K_+,K_-;\mathbb Z)\).

Shrinking \(v\) to zero retracts this pair to
\[
W\times\left(D_T^\nu,\{u: \sqrt A\leq|u|\leq T\}\right).
\]
The relative disk--annulus homology is \(\mathbb Z\) in degree \(\nu\)
and zero otherwise, so relative Kunneth identifies the complex's
homology with \(H_{*-\nu}(W;\mathbb Z)\).
For \(\nu=0\) the pair is a point and the empty set; both definite
signatures are covered. For \(k=0\) use the ordinary Morse complex.
Thus every admissible \(F\) has at least \(\lambda(W)\) critical points.

The one substantive geometric attainment input is the classical
Morse theorem, as stated explicitly by Cerf [C, Theorem 2,
Section 1(c), printed p. 117; proof in Section 6]:
a compact boundaryless simply connected smooth \(n\)-manifold,
\(n\geq6\), admits an excellent Morse function with
\[
\#\operatorname{Crit}_i=r_i+t_i+t_{i-1},\qquad
t_i=d(\operatorname{Tor}H_i).
\tag{8}
\]
The canonical decomposition in that statement is into cyclic invariant
factors, not separate primary factors. We use (8) only in dimensions
20 and 22. Its primary text, including hypotheses and the definition
of excellent function, is available in `literature/cerf1962.pdf`;
`cerf_theorem2.txt` identifies the passage. The initially attempted
Smale 1963 PDF was inaccessible and is not an additional dependency.

The manifolds \(C_m,M_m\) are simply connected and closed, with those
dimensions. An ordinary Morse function is an allowed stabilization
with \(k=0\). Combining (8) with the lower bound proves
\[
\operatorname{SM}(W)=\operatorname{Morse}(W)=\lambda(W)
\quad (W=C_m,M_m).
\tag{9}
\]
In particular an ordinary function \(h_m:C_m\to\mathbb R\) with
exactly \(20+1328m\) nondegenerate critical points really exists;
the argument does not merely minimize an abstract integral complex.

## 5. The Hamiltonian involution and minimal Chern number

Let \(Y\) be the blowup of
\(\mathbb {CP}^1\times\mathbb {CP}^1\) at its four coordinate corners.
The diagonal circle action
\((z,w)\mapsto(e^{2\pi it}z,e^{2\pi it}w)\)
preserves the centers and lifts holomorphically. Average a Kahler form
over the circle. The same complement argument as in Section 2 proves
that \(Y\) is simply connected. If \(V\) generates the action,
Cartan's formula shows that \(\iota_V\omega_Y\) is closed; since
\(H^1(Y;\mathbb R)=0\), it equals \(dk\).
With convention \(\omega(X_f,\cdot)=df\), the action is Hamiltonian
and \(k/2\) generates the half-turn \(g_Y\) at time one.

Downstairs the half-turn fixes just the four corners. Its derivative
at every corner is \(-I\), including corners with opposite circle
weights: \(e^{\pi i}=e^{-\pi i}=-1\).
In the local blowup model \((\ell,v)\), \(v\in\ell\subset\mathbb C^2\),
the lift is \((\ell,v)\mapsto(\ell,-v)\).
Thus its entire fixed set consists of the four exceptional lines
\(E_j\cong\mathbb {CP}^1\); its tangent derivative is \(+I\) and its
normal derivative is \(-I\). Equivariant blowdown rules out any other
fixed points.

Each point blowup adds one free generator to \(H_2\) and changes no
other Betti rank. Hence \(Y\) has free homology of even ranks
\((1,6,1)\), as used above. Moreover
\[
\langle c_1(TY),[E_j]\rangle
=\deg T\mathbb {CP}^1+\deg\mathcal O(-1)=2-1=1.
\tag{10}
\]
For \(M_m=X_m\times Y\), the product form makes
\(g=\operatorname{id}_{X_m}\times g_Y\) Hamiltonian. Its fixed set is
the disjoint union of four symplectic components \(X_m\times E_j\),
each diffeomorphic to \(C_m\). The product is simply connected, closed,
Kahler and of complex dimension \(9+2=11\).
The \(X_m\)-directions are trivial on the sphere \(\{x\}\times E_j\),
so (10) gives a sphere of Chern number one in \(M_m\).
The image of \(c_1:\pi_2(M_m)\to\mathbb Z\) is therefore exactly
\(\mathbb Z\): its minimal positive generator is one.

## 6. Exact fixed-point exhaustion, nondegeneracy and periodicity

Transport \(h_m\) to each fixed component. Extend these functions to
the ambient manifold in disjoint tubular neighborhoods with cutoffs,
and average the extension with its pullback by \(g\), obtaining a
smooth \(g\)-invariant \(f\). At a fixed point of \(g\),
the tangent space splits symplectically as \(E^+\oplus E^-\), the
two derivative eigenspaces. Indeed, the two eigenspaces are
symplectically orthogonal, so each restriction is nondegenerate.
Invariance forces \(df|_{E^-}=0\).
Consequently \(X_f\) is tangent to the fixed components and restricts
there to their prescribed Hamiltonian vector fields.
In particular its zeros on a component are exactly
\(\operatorname{Crit}(h_m)\).

We need a uniform small-period exclusion, not an informal smallness
argument. Any smooth vector field on a compact manifold has
\(\tau>0\) such that a trajectory returning in time
\(0<T<\tau\) is stationary. To prove this, choose finitely many
coordinate balls and smaller balls covering the manifold. Uniform
speed bounds keep each sufficiently short trajectory in one larger
chart, where the coordinate vector field has a uniform Lipschitz
constant \(L>0\). For a closed trajectory \(y:[0,T]\to\mathbb R^d\),
put \(a=\max_t|y'(t)|\), attained at \(t_0\).
Since \(\int_0^T y'(t)\,dt=0\) and
\(|y(t)-y(t_0)|\leq Ta\), we have
\[
a=\left|T^{-1}\int_0^T(v(y(t_0))-v(y(t)))\,dt\right|
\leq LTa.
\]
Choosing \(LT<1\) forces \(a=0\).

Let \(\psi^s\) be the flow of \(X_f\).
The equality \(f\circ g=f\) implies that \(g\) commutes with this
flow. Set \(\Phi_\varepsilon=\psi^\varepsilon\circ g\), with
\(2\varepsilon<\tau\). If \(\Phi_\varepsilon(x)=x\), then
\(\psi^{2\varepsilon}(x)=\Phi_\varepsilon^2(x)=x\).
The period exclusion forces \(X_f(x)=0\). Now the original equation
forces \(g(x)=x\), so \(x\) is a prescribed critical point.
Conversely each prescribed critical point is fixed by both maps.
This proves equality of fixed sets globally, not just locally near
the components.

At such an equilibrium, the linearization \(A=D X_f\) preserves the
two eigenspaces, and \(D\psi^\varepsilon=e^{\varepsilon A}\).
On \(E^+\), the identity
\(\omega(A^+u,v)=\operatorname{Hess}(h_m)(u,v)\) makes \(A^+\)
invertible. Therefore
\[
\frac{e^{\varepsilon A^+}-I}{\varepsilon}\longrightarrow A^+,
\qquad -e^{\varepsilon A^-}-I\longrightarrow-2I
\]
are both invertible for sufficiently small positive \(\varepsilon\).
They are exactly the tangent and normal blocks of
\(D\Phi_\varepsilon-I\), up to a nonzero scalar in the first block.
There are finitely many critical points, so one \(\varepsilon>0\)
satisfies every nondegeneracy requirement and the period bound.

Finally choose smooth nonnegative \(a,b\), of integral one, supported
in successive disjoint subintervals of \((0,1)\). The Hamiltonian
\[
H_m(t,x,y)=a(t)k(y)/2+\varepsilon b(t)f(x,y)
\]
first follows the half-turn and then follows \(\psi\) for time
\(\varepsilon\). It vanishes near the endpoints, so its extension to
\(\mathbb R/\mathbb Z\) is smooth and has time-one map
\(\Phi_\varepsilon\). All fixed-point loops are contractible because
\(M_m\) is simply connected. The complete count is therefore
\[
4\,\#\operatorname{Crit}(h_m)=4(20+1328m)=80+5312m.
\]
Equations (7), (9), and (10) prove every assertion of the theorem.

## 7. Comparison, provenance, and limitations of the novelty claim

The two strongest staged comparator statements are:

| existing result | real dimension | fixed points | stable Morse |
|---|---:|---:|---:|
| OpenAI dimension-22 paper, Theorem 1.1 | 22 | \(80+1952m\) | \(80+1968m\) |
| OpenAI cyclic-sharp paper, Theorem 1.1 | 3332 | \(1872232\), cyclic-sharp | \(1872264\) |
| theorem proved above | 22 | \(80+5312m\), cyclic-sharp | \(80+5344m\) |

The dimension-22 comparator has cyclic count \(80+1920m\), below its
fixed count by \(32m\). The improvement above is exact cyclic sharpness
in a fixed real dimension, with unbounded absolute stable-Morse deficit.
It is not a claim of optimal dimension or an improved relative deficit:
our ratio is \(32m/(80+5344m)=2m/(5+334m)\), asymptotic to \(1/167\);
the existing nonsharp dimension-22 ratio tends to \(1/123\).

The seven-center pattern is already in the staged cyclic-sharp paper.
The simultaneous finite-union projection lemma is already in the staged
dimension-22 paper. The new statement is their combined short-profile
specialization and arbitrary-copy family, with its endpoint interactions
checked and its algebraic core formalized independently. It would be
incorrect to present either ingredient as newly invented here.
The research worker compared the public sources at openai/math commit
`4eaee87548250b2682affda7d05d947c05554bae` and searched for the precise
combined family and coefficients; no separately stated primary theorem
with these counts was found. This is bounded prior-art evidence, not an
exhaustive proof of priority or a substitute for independent assessment
of publishability. The project wiki's available title/description index
contained no relevant stable-Morse or Arnold result.

No false literal manuscript assertion was established in this audit.
The other three manuscript branches remain open; their inclusion in
the ledger and graph is decomposition, not certification.

## Exact replay and formal declarations

From the campaign root, the standalone exact replay is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/sharp22/verify.py
```

The preserved source-bound Lean result is a real Lean 4.31.0 success,
`exit_code=0`, `proof_holes=[]`. Its immutable certificate is
`certificates/C9000347_SHARP22_CORE-86a7eed83e8beede.json`.
The main all-parameter declaration is `Sharp22.parametric_counts`;
`Sharp22.sharpness_criterion`, `Sharp22.convolution_difference`, and
the support and scaling lemmas expose its load-bearing algebra.
The installed tool takes the source positionally, so its replay command is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify --project-root . --claim C9000347_SHARP22_CORE research/sharp22/Main.lean --statement-fidelity research/sharp22/statement_fidelity.md
```

`statement_fidelity.md` specifies exactly what is formalized and what is
not. An altered exact-certificate deficit was rejected with a nonzero
exit in the negative-control replay. These mechanical outcomes do not
constitute an independent review of the prose geometry or of novelty.

### Cited propositions

[C] J. Cerf, *Travaux de Smale sur la structure des varietes*,
Seminaire Bourbaki, expose 230, February 1962, pp. 113-128,
Theorem 2 (p. 117), proof in Section 6.
Canonical identifier: `numdam:SB_1961-1962__7__113_0`.
<https://www.numdam.org/item/SB_1961-1962__7__113_0.pdf>.

[DL] H. Duan and B. Li, *Topology of Blow-ups and Enumerative Geometry*,
`arxiv:0906.4152v7`, Theorem 4.1, equations (4.2)-(4.3), pp. 12-13.
<https://arxiv.org/pdf/0906.4152v7>.

[BX] S. Bai and G. Xu, *Arnold conjecture over integers*,
`arxiv:2209.08599v1`, Theorem A, equation (1.1), p. 2.
At minimal Chern number one its cyclic-integral lower bound is the
\(\beta_{\mathbb Z}^{\rm cyc}\) attained here. This is an interpretation
of the result, not an input to the construction.
<https://arxiv.org/pdf/2209.08599v1>.
