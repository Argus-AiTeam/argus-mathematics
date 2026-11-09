# An effective complex estimate without Noetherianity or completion

## Statement and scope

Let \(C\) be a commutative ring, \(h\geq1\), and
\(I=(z_1,\ldots,z_h)\). Let \(\mathscr T_I\) consist of the modules killed
by some power of \(I\). Suppose
\(\lambda:\mathscr T_I\longrightarrow[0,\infty]\) is additive on short
exact sequences, \(\lambda(0)=0\), and direct sums and filtered colimits
of zero-length modules killed by a common power of \(I\) have length zero.
Assume, for every positive integer \(a\),
\[
 0<\mu=\lambda(C/I)<\infty,\qquad
 \lambda(C/(z_1^a,\ldots,z_h^a))=a^h\mu,\qquad
 \lambda H_i(z_1^a,\ldots,z_h^a;C)=0\quad(i>0).
\]
Let \(F\) be a finite free complex in homological degrees \(0,\ldots,h\),
contractible locally outside \(V(I)\), with ranks \(b_i\).

**Effective verification theorem.** Every \(H_i(F)\) is killed by one
power of \(I\), has finite length, and has length zero for \(i>0\).
For \(Y=\operatorname{Proj}_C(\bigoplus_{n\geq0}I^n)\), one has, for every
integer \(k\),
\[
 \lambda\mathbb H_k(Y,F_Y)=\lambda H_k(F).
 \tag{1}
\]
This assertion does not require an alternating-rank hypothesis. If
\(\sum_i(-1)^ib_i=0\) and every differential entry belongs to \(I^s\),
\(s\geq1\), then
\[
 \lambda H_0(F)\ \geq\
 \mu s^h\left(b_0-\frac{A_h}{s}\sum_{i=0}^h b_i\right),
 \tag{2}
\]
where one may take
\[
 A_1=0,\qquad
 A_h=\max\left\{h,\frac{3(h-1)h^{h-1}}{2(h-1)!}\right\}\quad(h\geq2).
 \tag{3}
\]
In particular, the leading coefficient is one and the error is independent
of the ring, the length, the complex, and every nullhomotopy exponent.
Neither Noetherianity nor completeness of \(C\) is assumed.

This proves the assertion of `thm:complex` and gives an explicit permissible
constant not specified in the staged proof. It also verifies the stronger
degreewise comparison used in `lem:complex-euler-comparison`. It does
**not** certify the manuscript's reductions, characteristic-\(p\) argument,
perfectoid length construction, mixed-characteristic argument, or main
Lech inequality. No claim of literature novelty or independent Reviewer
acceptance is made here. The prior campaign ledger contained only its
original audit goal, not a stronger certified mathematical result.

The proof below is universal. The Python replays are finite exact
computations, not a replacement for the proof. The Lean source proves the
universal algebraic stabilization, filtration-nilpotence, and normalization
cores; it does not formalize schemes, length functions, or the entire
theorem. The precise mapping is in `lean/statement_fidelity.md`.

## 1. Algebraic control by Koszul complexes

Write \(J_a=(z_1^a,\ldots,z_h^a)\) and \(K_a=K(z_1^a,\ldots,z_h^a;C)\).
For each \(j\), \(F[1/z_j]\) is bounded exact projective and hence
contractible. Homomorphisms between finite free modules commute with this
localization. Clearing the finitely many denominators in a contracting
homotopy gives \(a_0\geq1\) such that each \(z_j^{a_0}\) acts
nullhomotopically on \(F\). Consequently \(J_{a_0}H(F)=0\) and
\[
 I^tH(F)=0,\qquad t=h(a_0-1)+1.
 \tag{4}
\]

For \(a\geq a_0\), the iterated mapping cones defining \(F\otimes K_a\)
split in the homotopy category:
\[
 F\otimes K_a\simeq\bigoplus_{T\subseteq\{1,\ldots,h\}}F[|T|].
 \tag{5}
\]
At each cone step a nullhomotopy of the relevant multiplication is
tensored with the already introduced factors. No compatibility among
different chosen homotopies is needed. The cone splitting preserves the
included original complex; thus \(F\to F\otimes K_a\) is split injective
on homology.

Take Koszul homology first in the finite double complex \(F\otimes K_a\).
All positive Koszul rows have length zero. The remaining row has terms
\((C/J_a)^{b_i}\), of finite length. Therefore every total homology
has finite length, and its length vanishes in degrees greater than \(h\).
The summand \(F[h]\) in (5) proves finiteness for \(H_0(F)\) and
length zero for \(H_i(F)\), \(i>0\). Other homology degrees are zero.
All homology modules here are in \(\mathscr T_I\), so every use of
additivity is legitimate.

## 2. The associated graded and finite thickenings

Since \(I^{h(a-1)+1}\subseteq J_a\), the \(I\)-adic filtration of \(C/J_a\)
is finite. The surjection
\[
 (C/I)[Z_1,\ldots,Z_h]/(Z_1^a,\ldots,Z_h^a)
       \longrightarrow \operatorname{gr}_I(C/J_a)
\]
has total length \(a^h\mu\) on both sides. Each piece of its kernel has
length zero: all piece lengths are nonnegative and the finite sum of
the kernel lengths is zero. In degree \(l<a\), this is exactly the map
\[
 (C/I)[Z_1,\ldots,Z_h]_l\longrightarrow I^l/I^{l+1},
 \tag{6}
\]
because \(J_a\subseteq I^{l+1}\). Thus (6) has zero-length kernel for
every \(l\), and
\[
 \lambda(C/I^M)=\mu\binom{M+h-1}{h}.
 \tag{7}
\]

On the standard blowup chart the ring is \(C[I/z_i]\subseteq C[1/z_i]\).
The element \(z_i\) is a nonzerodivisor on this ring, and \(I\) becomes
\((z_i)\). Hence
\[
 L=I\mathcal O_Y=\mathcal O_Y(1)
\]
is an invertible ideal, and \(E=V(L)=\operatorname{Proj}(\operatorname{gr}_I C)\)
is an effective Cartier divisor. Empty charts cause no problem.
The \(h\) charts and their intersections are affine.

Let \(N\) be the graded kernel in (6). A degree-zero localization of a
twist of \(N\) is a filtered colimit of its homogeneous pieces. Every
piece is killed by \(I\) and has length zero. The stipulated colimit
property therefore applies, with the **same annihilating ideal \(I\)**.
Tensoring with a finite projective module on an affine chart preserves
length zero, since the tensor product is a direct summand of finitely
many copies of that localized module. The finite affine Cech complexes
give, for every bundle \(V\) pulled back from \(\mathbb P_{\mathbb Z}^{h-1}\),
\[
 H^v(\mathbb P_{C/I}^{h-1},V(l))
       \longrightarrow H^v(E,V(l))
 \quad\text{is an isomorphism modulo length zero.}
 \tag{8}
\]

For completeness these cohomology lengths are finite even if \(C/I\)
is non-Noetherian. Represent \(V(l)\) by a finite graded module over
\(\mathbb Z[Z_1,\ldots,Z_h]\). This auxiliary ring is Noetherian, regular,
and of finite global dimension (Stacks Tags 07NF and 00OE). It admits
a finite graded projective resolution. A finite graded projective over
this ring is graded free: reduction modulo the variables is graded
projective over \(\mathbb Z\), choose a homogeneous integral basis,
lift it, and use graded Nakayama on the cokernel and the split kernel.
Sheafification gives a finite resolution by finite sums of twists.
Its successive short exact sequences are locally split because their
cokernels, starting with \(V(l)\), are vector bundles. The resolution
therefore remains exact under every base change. Each twist on
\(\mathbb P_{C/I}^{h-1}\) has finite free cohomology over \(C/I\);
the finite resolution spectral sequence proves finiteness in (8).
For \(l\geq0\), (6) and (8) identify \(I^l/I^{l+1}\) with
\(\mathbf R\Gamma(E,\mathcal O_E(l))\) modulo length zero.

Apply this to each graded layer of \(F/I^MF\), with its induced
differential. A finite filtration and a finite complex give compatible
maps
\[
 P_M=F/I^MF\longrightarrow
 B_M=\mathbf R\Gamma(Y,F_Y/L^MF_Y)
 \tag{9}
\]
that induce isomorphisms modulo length zero in every homology degree.
This statement does not assert that the differentials of \(F\) vanish
on the layers. The same differential modulo \(I\) occurs on both sides.
All homology of \(P_M\) and \(B_M\) is \(I\)-power torsion of finite length.

## 3. Uniform-in-twist zero maps, not Serre vanishing

The following argument applies to
\(D=F_Y\otimes V\) and, when defined, to
\(D=G\otimes V\), where \(G_i=L^{-is}\otimes F_i\).
On each chart its terms are finite projective, and the complex becomes
contractible after inverting the local equation \(z_i\) of \(E\).
Clearing denominators supplies an exponent \(m_i\) such that
\(z_i^{m_i}\) acts nullhomotopically. Tensoring with any twist, or
localizing to an intersection, keeps that exponent.
Choose \(m\geq1\) at least all \(m_i\).

For every integer \(j\), the map \(D(j+m)\to D(j)\) induces zero on
the internal-homology page of the Cech double complex. The induced map
on the associated graded of total homology is zero. It lowers the
finite homology filtration by one. There are at most \(h\) Cech
filtration steps, so
\[
 H_k(D(j+M))\longrightarrow H_k(D(j))=0
 \quad\text{as a map, for }M\geq q_D:=hm.
 \tag{10}
\]
Here and below \(H_k(D(j))\) denotes hyperhomology. The displayed equality
means the map is zero, not that its target is necessarily zero.
The filtration argument concerns maps between possibly different
filtered modules; this is the version formalized in Lean.

For \(a\in I^{q_D}\), multiplication by \(a\) factors through
\(D(j+q_D)\to D(j)\). Thus \(I^{q_D}H_k(D(j))=0\).
For \(M\geq q_D\), the quotient exact sequence injects
\(H_k(D(j))\) into \(H_k(D(j)/D(j+M))\).
The quotient has finitely many \(E\)-layers, with terms finite sums
of twists of \(V|_E\); (8) makes its hyperhomology lengths finite.
This proves all the torsion and finiteness assertions about these twists.
No proper-cohomology finiteness theorem over \(C\), Serre vanishing
over \(C\), or completion is used.

## 4. Canonical stabilized images prove the comparison

The elementary image argument is worth specifying. Suppose that
\[
 H\xrightarrow{i_M} U_M\xrightarrow{\delta_M} T_M
\]
is exact at \(U_M\), and \(t:U_N\to U_M\), \(i_N:H\to U_N\) satisfy
\(t i_N=i_M\) and \(\delta_Mt=0\). Then
\[
 \operatorname{im}t=\operatorname{im}i_M.
 \tag{11}
\]
One inclusion is exactness, the other is the compatibility with \(H\).
If \(i_M\) is injective, this image is canonically \(H\).
This elementary fact has no chain condition or inverse-limit hypothesis.

On the geometric side put \(A=\mathbf R\Gamma(Y,F_Y)\).
The exact triangles
\[
 A\longrightarrow B_M\longrightarrow
       \mathbf R\Gamma(Y,F_Y(M))[1]\longrightarrow A[1]
\]
are compatible with \(N\to M\). By (10), \(H_k(A)\to H_k(B_M)\)
is injective for \(M\geq q_{F_Y}\). For \(N-M\geq q_{F_Y}\), the
transition on the third terms is zero on homology. Apply (11) to
conclude
\[
 \operatorname{im}(H_k(B_N)\to H_k(B_M))\cong H_k(A).
 \tag{12}
\]

For the algebraic side set \(A_a=F\otimes K_a\) and \(Q_a=A_a/F\).
Filter \(Q_a\) by Koszul degrees \(1,\ldots,h\), an increasing
filtration by subcomplexes. Each associated graded complex is a sum
of shifts of \(F\). The standard transition \(K_b\to K_a\) is the
identity in degree zero and on the component indexed by a nonempty
set \(T\) is multiplication by
\(\prod_{j\in T}z_j^{b-a}\). If \(b-a\geq t\), (4) makes the
transition zero on the homology of every graded piece. It therefore
lowers the homology filtration by one. Factoring through \(h\)
successive transitions shows
\[
 H_k(Q_b)\longrightarrow H_k(Q_a)=0
       \quad\text{as a map whenever }b-a\geq ht.
 \tag{13}
\]
For \(a\geq a_0\), (5) makes \(H_k(F)\to H_k(A_a)\) injective.
The exact sequences for \(F\to A_a\to Q_a\), (13), and (11) now give
\[
 \operatorname{im}(H_k(A_b)\to H_k(A_a))\cong H_k(F)
       \quad(a\geq a_0,\ b-a\geq ht).
 \tag{14}
\]
The augmentations \(A_a\to F/J_aF\) commute with transitions and
induce isomorphisms modulo length zero. Indeed, the augmentation
\(K_a\to C/J_a\) has cone with zero-length homology by the stipulated
Koszul hypotheses; tensoring the finite free complex \(F\) preserves
this conclusion by a finite homology-first spectral sequence.
Thus (14) also holds modulo length zero for the \(J_a\)-quotient tower.

It remains to pass to ordinary powers, not to an inverse limit.
Work in the Serre quotient of \(\mathscr T_I\) by zero-length modules,
so that all the preceding modulo-zero isomorphisms are genuine
isomorphisms. The containments
\[
 I^{h(a-1)+1}\subseteq J_a\subseteq I^a
 \tag{15}
\]
provide the needed finite maps. Fix \(a_*\geq a_0\).
For \(M\geq h(a_*-1)+1\), the composite
\(H_k(F)\to H_k(P_M)\to H_k(F/J_{a_*}F)\) is injective,
so its first arrow is injective in this quotient.
For such fixed \(M\), choose \(a\geq\max\{M,a_0\}\) and
\(b\geq a+ht\). For \(N\geq h(b-1)+1\), factor the transition through
\[
 P_N\longrightarrow F/J_bF\longrightarrow F/J_aF\longrightarrow P_M.
 \tag{16}
\]
By (14), its image is contained in the image of \(H_k(F)\).
Compatibility with the maps from \(F\) gives the opposite inclusion.
Thus the eventual image in the ordinary-power tower is canonically
\(H_k(F)\) in the Serre quotient.

Finally choose \(M,N\) large enough for both this assertion and (12).
The commuting square (9) at levels \(M,N\) has vertical isomorphisms
in the Serre quotient. Isomorphisms in a commuting square identify
the images of the horizontal arrows. Those images are \(H_k(F)\)
and \(H_k(A)\), respectively. Both have finite length, so their
lengths agree. This proves (1). There is **no** exchange of homology
with a limit, no appeal to formal functions, and no completion of \(C\).

If alternating rank is zero, the Euler characteristic of
\(F_Y(j)/F_Y(j+1)\) is
\[
 \left(\sum_i(-1)^ib_i\right)
       \sum_v(-1)^v\lambda H^v(E,\mathcal O_E(j))=0.
 \tag{17}
\]
Euler additivity is permissible by the finiteness already proved.
It makes \(\chi_\lambda(F_Y(j))\) independent of \(j\).
A finite resolution of \(V\) by twists, as in Section 2, remains
exact on \(Y\). Tensor with \(F_Y\) and take Euler characteristics:
\[
 \chi_\lambda(F_Y\otimes V)=\operatorname{rank}(V)\lambda H_0(F).
 \tag{18}
\]
The sign convention is \((-1)^{i-v}=(-1)^{i+v}\).

## 5. Integral root bundles

Put \(n=h-1\). If \(n=0\), use \(\mathcal O\) on \(\mathbb P^0_{\mathbb Z}\).
Otherwise multiplication of binary linear forms defines
\[
 f:(\mathbb P^1_{\mathbb Z})^n\longrightarrow\mathbb P^n_{\mathbb Z},
       \qquad f^*\mathcal O(1)=\mathcal O(1,\ldots,1).
 \tag{19}
\]
It is proper and has finite geometric fibers, since a nonzero binary
form has only finitely many ordered linear factorizations up to the
scalars removed by the projective coordinates. Thus \(f\) is finite
(Stacks Tag 02LS).

On a field fiber, local source and target rings are regular and have
equal dimensions: the residue extensions are finite and both ambient
varieties are smooth of dimension \(n\). The local fiber has dimension
zero. The source is Cohen--Macaulay, so miracle flatness (Tag 00R4)
applies at every point. The schemes in (19) and \(\operatorname{Spec}\mathbb Z\)
are locally Noetherian and the source is flat over \(\mathbb Z\).
Fiberwise flatness (Tag 039D) consequently makes \(f\) flat over
\(\mathbb Z\). This is an application **over \(\mathbb Z\)**; none of
these criteria is applied with the possibly non-Noetherian ring \(C\).
Hence \(f\) is finite locally free. Its rank is \(n!\): at the
characteristic-zero geometric generic point the form has \(n\) distinct
linear factors, the function-field extension is separable, and its
ordered factorizations give exactly \(n!\) reduced points. Rank is
constant because \(\mathbb P^n_{\mathbb Z}\) is connected.

For integers \(r_1>\cdots>r_n\), set
\[
 V=f_*\mathcal O(-1-r_1,\ldots,-1-r_n).
 \tag{20}
\]
It is a vector bundle of rank \(n!\), compatible with arbitrary base
change. By the projection formula and affine exactness of finite
pushforward, its cohomology at twist \(a\) is that of
\(\mathcal O(a-1-r_1,\ldots,a-1-r_n)\).
The two-term Laurent-polynomial Cech calculation on \(\mathbb P^1\)
gives finite free cohomology in degree zero for exponent \(m\geq0\),
in degree one for \(m\leq-2\), and zero for \(m=-1\), with Euler rank
\(m+1\). These Cech complexes split over \(\mathbb Z\); their tensor
product therefore has the same cohomology after every base change.
It follows that \(V(a)\) is acyclic if \(a=r_j\), and otherwise has
cohomology in the single degree
\[
 v(a)=\#\{j:r_j>a\},\qquad \chi(V(a))=\prod_{j=1}^n(a-r_j).
 \tag{21}
\]
Over \(C/I\), the length Euler characteristic is \(\mu\) times (21).
Equation (8) gives the same statement on \(E\), modulo length zero.
Thus the use of the Eisenbud--Schreyer construction needs no unproved
integral or base-change strengthening of their theorem.

## 6. Positivity on both sides of degree zero

Since entries of the differential of \(F\) lie in \(I^s\), the matrices
of \(G_i=L^{-is}\otimes F_i\) have regular entries after division by
the local equation to power \(s\). Thus \(G\) is a complex and
\(F_Y\subseteq G\) is an inclusion of complexes.
Choose integer roots satisfying
\[
 -(j+1)s<r_j<-js\qquad(1\leq j\leq h-1).
 \tag{22}
\]
Let \(D=G\otimes V\). The term of degree \(i\) in its \(l\)-th
\(E\)-layer is \(V(l-is)^{b_i}|_E\).

For \(l\geq0\), every index \(j\geq i\) has \(r_j<-is\leq l-is\);
hence \(v(l-is)\leq i\). The \(E\)-layer has no negative total-degree
hyperhomology modulo length zero. A finite layer filtration gives
the same statement for \(D/D(M)\). For \(M\geq q_D\), (10) injects
\(H_k(D)\) into \(H_k(D/D(M))\), so its length is zero for \(k<0\).

For \(l<0\), every \(j\leq i-1\) has
\(r_j>-(j+1)s\geq-is>l-is\). Thus \(v(l-is)\geq i-1\), with a
vacuous lower bound when \(i=0\). The layer has no total degree
greater than one, modulo length zero. This applies to \(D(-M)/D\).
The zero map \(H_k(D)\to H_k(D(-M))\), for large \(M\), makes
\(H_{k+1}(D(-M)/D)\to H_k(D)\) surjective. Thus the length of
\(H_k(D)\) is zero for \(k>0\). All lengths are finite by Section 3.
We have proved
\[
 \chi_\lambda(D)=\lambda H_0(D)\geq0.
 \tag{23}
\]

In degree \(i\), \(G/F_Y\) has layers \(\mathcal O_E(l)^{b_i}\),
\(-is\leq l\leq-1\). Euler additivity, (18), and (21) give
\[
 0\leq n!\lambda H_0(F)+
       \mu\sum_{i=1}^h(-1)^ib_i S_i,\qquad
 S_i=\sum_{l=-is}^{-1}\prod_{j=1}^n(l-r_j).
 \tag{24}
\]
This also checks both orientation choices: the layer twists are negative,
and the sign is \((-1)^i\), not \((-1)^{i+1}\).

## 7. A completely explicit error bound

Assume \(h\geq2\). Put \(H(x)=\prod_{i=1}^h(x+i)\).
Rolle's theorem and degree show that \(H'\) has one simple root
\(\rho_j\) in each interval \((-(j+1),-j)\).
Write \(\rho_j=-j-\delta\), \(0<\delta<1\). The logarithmic derivative
identity gives
\[
 \sum_{i=1}^j\frac1{j+\delta-i}
       =\sum_{i=j+1}^h\frac1{i-j-\delta}.
 \tag{25}
\]
The left side is at least \(1/\delta\), the right side at most
\((h-j)/(1-\delta)\), so
\(\delta\geq1/(h-j+1)\geq1/h\).
The right side is at least \(1/(1-\delta)\), the left side at most
\(j/\delta\), so \(1-\delta\geq1/(j+1)\geq1/h\).
Thus every root is at least \(1/h\) from both endpoints.

For every integer \(s\geq h\), choose \(r_j=\lfloor s\rho_j\rfloor\).
The endpoint distance is at least one before rounding, so these
integers satisfy (22), are distinct, and obey
\(|r_j/s-\rho_j|\leq1/s\).
Define
\[
 P(x)=\prod_{j=1}^{h-1}(x-\rho_j)=H'(x)/h,\qquad
 P_s(x)=\prod_{j=1}^{h-1}(x-r_j/s).
 \tag{26}
\]
On \([-h,0]\) every factor has absolute value at most \(h\).
Telescoping the product difference and differentiating the product give
\[
 \|P_s-P\|_\infty\leq\frac{(h-1)h^{h-2}}s,\qquad
 \|P'\|_\infty\leq(h-1)h^{h-2}.
 \tag{27}
\]
In each subinterval of length \(1/s\), the error between the integral
of \(P\) and its left endpoint value times \(1/s\) is bounded by
\(\|P'\|_\infty/(2s^2)\). There are \(is\) subintervals. Consequently
\[
 \left|\frac{S_i}{s^h}-\int_{-i}^0P(x)\,dx\right|
 \leq i\|P_s-P\|_\infty+\frac{i}{2s}\|P'\|_\infty
 \leq\frac{3(h-1)h^{h-1}}{2s}.
 \tag{28}
\]
For every \(1\leq i\leq h\),
\[
 \int_{-i}^0P(x)\,dx=\frac{H(0)-H(-i)}h=(h-1)!.
 \tag{29}
\]
Write \(S_i/s^h=n!+\epsilon_i\), where
\(|\epsilon_i|\leq E_h/s\) and \(E_h=3(h-1)h^{h-1}/2\).
Using \(\sum_{i=1}^h(-1)^ib_i=-b_0\), (24) becomes
\[
 0\leq n!\bigl(\lambda H_0(F)-\mu s^h b_0\bigr)
       +\mu s^h\sum_{i=1}^h(-1)^ib_i\epsilon_i.
 \tag{30}
\]
Because \(b_i\geq0\), the last sum is at most
\((E_h/s)\sum_{i=1}^h b_i\). Divide by the positive number \(n!\)
to obtain (2) for \(s\geq h\), with (3).
For \(1\leq s<h\), \(A_h\geq h>s\) and \(b_0\leq\sum_i b_i\),
so the right side of (2) is nonpositive. Nonnegativity proves (2)
there as well. If \(h=1\), the root product is empty and \(S_1=s\);
(24) and \(b_0=b_1\) prove the exact bound with \(A_1=0\).

Only (27)--(30) contribute numerical errors. The cutoffs in Sections 1,
3, and 4 establish exact zero maps and exact comparisons modulo length
zero; they never enter \(A_h\). This proves the claimed uniformity.

## 8. Sharpness with a genuinely non-Noetherian base

The leading coefficient one cannot be replaced by any larger constant
with an error tending to zero at fixed ranks, even within the literal
non-Noetherian scope. Let
\[
 A=\mathbb Q[u_1,u_2,\ldots],\quad K=\operatorname{Frac}(A),\quad
 C=A[z_1,\ldots,z_h],\quad I=(z_1,\ldots,z_h),
 \qquad \lambda(M)=\dim_K(M\otimes_A K).
\]
Infinite dimension is assigned length infinity. Localization is exact,
so this is additive. Zero-length modules localize to zero; arbitrary
direct sums and filtered colimits of them localize to zero as well.
Here \(\mu=1\), \(C/J_a\) is free over \(A\) with basis
\(\{z^\alpha:0\leq\alpha_j<a\}\), and the powers of the distinct
polynomial variables form a regular sequence. Thus every length and
Koszul hypothesis holds. Both \(A\) and \(C\) are non-Noetherian.

For \(F=K(z_1^s,\ldots,z_h^s;C)\), the ranks are \(\binom hi\),
the alternating rank is zero, every nonzero differential entry lies
in \(I^s\), and the usual wedge contraction makes \(F\) contractible
where any \(z_j\) is invertible. It has only zeroth homology, whose
length is exactly \(s^h\). The support, ranks, Koszul, and length
hypotheses are all satisfied. This is a sharpness construction,
**not** a counterexample to the manuscript.
For any proposed leading coefficient \(1+\eta\), \(\eta>0\),
and any fixed dimension-only error constant \(B_h\), the claimed
bound fails on this family once \(s>B_h2^h/\eta\).
The finite Laurent-monomial replays check the differential and
contraction signs and quotient bases in this family, not the existence
of infinitely many independent variables by finite enumeration.

## Dependencies and exact replay

The nontrivial external inputs used in the proof are standard finite
graded resolutions, proper finite-fiber morphisms being finite, miracle
flatness, and fiberwise flatness. Their precise hypotheses and primary
passages are stored in `literature/stacks_inputs.txt` and recorded as
assumptions on the relevant ledger claims. Independent citation
confirmation remains for the Host-invoked Reviewer. In particular,
neither an unchecked citation nor an Engineer judgement is represented
as independent certification.

The scoped Ma, Heitmann--Ma, and CLMST propositions are recorded on the
separate main-theorem claim, with their exact versioned primary PDFs.
They are not inputs to (1)--(3). Certifying these citations does not
certify their applications elsewhere in the manuscript.

Run `python3 research/complex_estimate/verify.py` from the campaign root
for the exact computational replays described in `exact_certificate.json`.
The replay checks the retained Jacobian response without contacting its
server, exact root-count and polynomial identities, explicit integer-root
choices and error bounds in its stated finite range, a nontrivial
filtered-tower example, and the sharp monomial-Koszul family. It also
requires the real official Lean certificate for the universal core.
