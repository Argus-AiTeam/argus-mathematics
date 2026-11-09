# Physical displacement--actual-divergence profiles in isotropic elasticity

## Result and scope

This is a proof of Proposition `prop:physical-amplitudes`, not a proof of the
manuscript's global inverse uniqueness theorem. No false assertion in the
staged physical-frame proposition or its recursion has been established.
The exact computation is a universal differential-polynomial calculation,
not a search over finitely many media. The analytic existence assertions
below use the explicitly identified standard analytic inputs.

Throughout, lambda and mu are real smooth coefficients on R^3 satisfying
mu>0 and 3lambda+2mu>0, exactly as in the manuscript. Set

\[
 m=\mu,\quad k=\lambda+\mu,\quad \ell=\lambda+2\mu=m+k.
\]

Thus k>m/3 and ell>4m/3. Fix r>0 and an arbitrary nonzero complex vector
theta satisfying the **bilinear** equation theta dot theta=0. Constants may
depend on theta, the fixed domains, and the coefficients, but not on
tau tending to positive infinity. Write h=1/tau, D=theta dot grad, and
E_tau=exp(tau theta dot x).

**Theorem 1 (physical frames).** For every t0 in (-2r,2r) there is an
interval J containing t0 and three smooth constrained transport columns
(a0,b0), defined near the closed ball B_(5r), forming a frame of
H_theta direct-sum C on D_(2r)^2 times J. Their formal amplitudes have
one fixed compact transverse support. Each column has exact smooth
physical realizations u_tau on B_(5r) such that

\[
 E_\tau^{-1}(u_\tau,\operatorname{div}u_\tau)
       \longrightarrow(a_0,b_0)\quad\hbox{in }L^2(B_{4r}),
 \qquad
 \|E_\tau^{-1}\nabla(u_\tau,\operatorname{div}u_\tau)\|_{L^2(B_{4r})}
       =O(\tau).
\]

**Theorem 2 (complete smooth profile realization).** More generally, let
(a0,b0) be any smooth constrained transport solution on a planar cylinder
D_R^2 times I, R>5r, smoothly extended by zero outside a fixed compact
set K contained in I in the transverse coordinate. On smaller cylinders
still containing the closed B_(5r), it has compatible coefficients
(aj,bj) for every j>=0, all supported in K. There is one family of exact
physical solutions on B_(5r) such that for every M,s>=0

\[
 \left\|E_{1/h}^{-1}(u_h,\operatorname{div}u_h)
               -\sum_{j=0}^{M}h^j(a_j,b_j)\right\|_{C^s(\overline B_{4r})}
       =O(h^{M+1}).
\]

Conversely, any strong local L2 limit (a,b) of conjugated exact
displacement--actual-divergence pairs satisfies the constrained transport
equations in distributions. In particular every smooth such limit is a
smooth constrained transport section. This converse does not require the
weighted derivative hypothesis.

Transverse support in these statements belongs to the **amplitudes**.
The exact displacement and the physical correction are not asserted to
be transversely supported. No auxiliary boundary data are prescribed.

## Scope findings and external inputs

The strongest prior result in the staged manuscript relevant to this
mission is the finite-order physical realization with L2 convergence and
one weighted derivative. Theorem 2 adds necessity of the constrained
system and a single complete C-infinity physical expansion, including the
actual divergence. Its novelty and publishable significance are not
established by an Engineer's proof and remain independent-review questions.

One focused literature search did not identify a verified earlier statement
of Theorem 2. Automated summaries pointing to Cekic were not accepted as
evidence: the primary abstract and Theorem 1.1 of arXiv:2309.09348v3 concern
full matrix connection-Laplacian boundary data on a trivial vector bundle.
That theorem does not by itself establish the physical
displacement--actual-divergence profile characterization. The source is
archived as `literature/cekic-v3.html`. This bounded lookup is a limitation
on the novelty assessment, not a proof of novelty.

Invertible planar frames and high-order system CGO expansions themselves
are prior art: Eskin--Ralston, arXiv:math/0403507v1, Lemma 1.1 and Section 2,
equations (2.2)--(2.4). Their Section 1 explicitly warns that a frame tending
to the identity at spatial infinity need not exist. Such a normalization,
or a prescribed planar Cauchy initial value, is not used here. That failed
normalization route is retired in the claim ledger.

The proof uses the following precise external propositions.

1. Forstneric, *Oka manifolds*, DOI 10.1016/j.crma.2009.07.005,
   Theorem 1.1, p. 1018, and its following homogeneous-fiber paragraph:
   a holomorphic bundle over a reduced Stein space with CAP fibers obeys
   the Oka principle for sections. In particular this applies to a
   holomorphic GL_n(C) frame bundle over a disk.
2. Salo--Tzou, arXiv:0709.2282v2, Lemma 2.1, equation (6):
   for every real s, a convexified limiting weight gives
   (h/sqrt(epsilon)) times the H_h^(s+2) norm bounded by the H_h^s
   norm of the conjugated minus h^2 Laplacian, when
   h is sufficiently smaller than epsilon and epsilon sufficiently small.
3. Smooth elliptic system interior regularity and its local parametrix
   estimate. The retrieved author-hosted Dyatlov notes, dated November 2,
   2026, give Theorem 16.1, Remark 16.2, Proposition 16.6 and the matrix
   parametrix discussion in Section 15.2.3. Uniformity for the scaled
   family is justified below rather than assumed.
4. The complex Hahn--Banach extension theorem and Hilbert-space Riesz
   representation theorem.
5. Local Sobolev embedding on R^3: H^t controls C^s on a smaller compact
   set when t>s+3/2. This standard theorem is used only to express
   the complete smooth expansion in C^s rather than local Sobolev norms.

The primary texts are archived in `literature/` below this directory.
The Engineer read the relevant statements; independent attribution is
still required. The currently served Dyatlov PDF is not the October 2
version cited by the manuscript. Its changed theorem numbering supplies
no refutation of that older citation. No relevant elasticity page was
found in the inherited cross-campaign Wiki.

## 1. Unrestricted-jet differential identities

For an independent pair U=(a,b), use exactly the manuscript operators:

\[
\begin{split}
 R_i(U)&=m\Delta a_i+k\partial_i b+
   \sum_jm_j(\partial_j a_i+\partial_i a_j)+\lambda_i b,\\
 S(U)&=\ell\Delta b+2\nabla k\cdot\nabla b
       +2\nabla m\cdot\Delta a
       +2\sum_{i,j}m_{ij}\partial_i a_j+(\Delta\lambda)b,\\
 P&=m\Delta+\nabla m\cdot\nabla,\qquad
 q(U)=\operatorname{div}a-b,\qquad T(U)=\theta\cdot a.
\end{split}
\]

Expanding div sigma gives L a=R(a,div a). If v=div a, differentiating R
gives

\[
\begin{split}
 \operatorname{div}R(U)
  ={}&m\Delta v+\nabla m\cdot\nabla v+k\Delta b
       +(\nabla k+\nabla\lambda)\cdot\nabla b\\
    &+2\nabla m\cdot\Delta a+
       2\sum_{i,j}m_{ij}\partial_i a_j+(\Delta\lambda)b .
\end{split}
\]

Since k=lambda+m and ell=k+m, subtraction gives the identity

\[
 \operatorname{div}R(U)-S(U)=Pq(U).                 \tag{1}
\]

There are no restrictions on the coefficient or amplitude jets in (1).
In particular S(a,div a)=div(L a).

Let C_m(a)_i=sum_j m_j(partial_j a_i+partial_i a_j). Direct cancellation
also gives

\[
\begin{split}
mS(U)-2\nabla m\cdot R(U)
={}&m\ell\Delta b+(2m\nabla k-2k\nabla m)\cdot\nabla b\\
 &+2m\sum_{i,j}m_{ij}\partial_i a_j-2\nabla m\cdot C_m(a)\\
 &+(m\Delta\lambda-2\nabla m\cdot\nabla\lambda)b.     \tag{2}
\end{split}
\]

Consequently (m^(-1)R,ell^(-1)(S-2m^(-1)grad m dot R)) has principal
part Delta Id_4. Positivity supplies the nonzero denominators.

Replacing every amplitude derivative partial_j by partial_j+tau theta_j
gives, under theta dot theta=0,

\[
 R_\tau=R+\tau R^\theta,\quad S_\tau=S+\tau S^\theta,\quad
 P_\tau=P+\tau P^\theta,\qquad P^\theta=2mD+(Dm),
\]

\[
\begin{split}
R^\theta(a,b)&=2mDa+(Dm)a+\theta(kb+\nabla m\cdot a),\\
S^\theta(a,b)&=2\ell Db+2(Dk)b+4\nabla m\cdot Da
                                      +2(D\nabla m)\cdot a.
\end{split}
\]

Before imposing nullity the omitted tau^2 terms are exactly
m(theta dot theta)a, (theta dot theta)(ell b+2grad m dot a),
and m(theta dot theta)b, respectively. Thus the null condition is
bilinear, not a Hermitian convention hidden in the calculation.

Conjugating (1), the divergence and defect become div+tau theta dot and
q+tau T. The coefficient of tau gives

\[
 \operatorname{div}R^\theta(U)+\theta\cdot R(U)-S^\theta(U)
                 =PT(U)+P^\theta q(U).             \tag{3}
\]

This degree-one identity even holds before imposing nullity. The
degree-two identity, after imposing nullity, is

\[
 \theta\cdot R^\theta(U)=P^\theta T(U).              \tag{4}
\]

These are identities for every independent pair, including all
higher-order amplitudes whose normal component need not vanish.

`verify.py` expands the operators from these definitions with arbitrary
smooth SymPy functions. It verifies (1)--(4), all full non-null
factorizations, (2), and the physical scalar-defect identity exactly.
It does not replace arbitrary jets by polynomial or constant examples.

## 2. Rank, frames, and transverse support

Write theta=alpha+i beta with real alpha,beta. Nullity implies
|alpha|=|beta|=rho>0 and alpha dot beta=0. The positively oriented
orthonormal coordinates in the alpha/rho, beta/rho and cross-product
directions give D=2rho partial_bar_z. The kernel H_theta of the
nonzero linear functional a maps to theta dot a has complex dimension
two. On H_theta direct-sum C, the coefficient of D is

\[
 C(x)=
 \begin{pmatrix}
 2m&0&0\\0&2m&0\\4p&4q&2\ell
 \end{pmatrix},\qquad \det C=8m^2\ell>0,             \tag{5}
\]

where p,q are grad m evaluated on any fixed basis of H_theta. Hence the
system is exactly a rank-three planar first-order system. The inspected
and executed Jacobian operation `matrix.symbolic.determinant.compute`
returns (5) over Q(m,ell,p,q). The payload, typed response, protocol,
server version, and successful adapter status are retained; the replay
independently recomputes the determinant. This operation supplies only
(5), not analytic PDE solvability.

For completeness, here is the required planar construction. A Cauchy
transform T_C satisfies partial_bar_z T_C f=f, and, for support in a
disk of radius delta, ||T_C f||_infinity<=C delta||f||_infinity. The
bound follows by integrating 1/|z-w| over that disk; the right-inverse
identity follows from the distributional identity
partial_bar_z(1/(pi z))=delta_0. Thus

\[
 V=I+T_C(\chi A V)
\]

is a contraction on bounded matrix functions on a small disk.
Taking its operator norm strictly less than 1/3 ensures
||V-I||_infinity<1/2. Interior regularity for partial_bar_z and repeated
differentiation give a smooth invertible local frame.

Two local frames have holomorphic transition matrix V_i^(-1)V_j.
Their frame bundle is a holomorphic GL_n(C) bundle, smoothly trivial in
the original trivialization. The disk is Stein; the Oka proposition
listed above supplies a global holomorphic frame section, hence a
smooth invertible frame solving the original equation on that disk.

To obtain local smooth dependence on t, fix a frame V0 at t0 on a
larger disk, write V=V0 W, and set
B=V0^(-1)(A(z,t)-A(z,t0))V0. On a compactly supported planar cutoff
B tends uniformly to zero as t tends to t0. The same Neumann series
solves W=I+T_C(chi B W) on a smaller disk. Its inverse operator and
all t derivatives are continuous in operator norm on L-infinity.
Interior elliptic regularity applied successively to the differentiated
equations gives joint smoothness, with bounds on smaller compact sets.

Finally the formula

\[
 v=V T_C(\chi V^{-1}F)                              \tag{6}
\]

solves the inhomogeneous equation on a smaller disk. It preserves any
fixed compact t support because T_C acts only in z. On a compact set of
parameters needing several local frames, take a finite partition of
unity in t and sum (6); D annihilates that partition, and the resulting
solution still vanishes at every t where F vanishes. No global
t-dependent normalization is needed.

Choose a local frame for the rank-three system on a disk larger than
B_(5r) and an interval I0 about t0. Multiplication by a smooth
chi(t), supported compactly in I0 and equal to one on J, preserves the
homogeneous equation. Extension by zero in t is smooth. The columns
are still a frame on D_(2r)^2 times J and have the same compact
transverse support K=supp chi.

## 3. Compatibility at every order

Let U_j=(a_j,b_j), q_j=div a_j-b_j and U_(-1)=q_(-1)=0. Given the
constrained leading column, require for j>=1

\[
 R^\theta U_j=-R U_{j-1},\quad
 S^\theta U_j=-S U_{j-1},\quad T U_j=-q_{j-1}.       \tag{7}
\]

For j=1, apply (3) to U0 and use its three homogeneous equations.
It gives theta dot R U0=P^theta q0. For j>=2, the previous
vector and scalar equations and (1) imply

\[
 \operatorname{div}R^\theta U_{j-1}-S^\theta U_{j-1}
       =-Pq_{j-2}=PTU_{j-1}.
\]

These terms cancel in (3), again giving

\[
 \theta\cdot R U_{j-1}=P^\theta q_{j-1}.            \tag{8}
\]

There is no loss of a source equation or restriction on higher-order
jets in this cancellation.

Take the constant vector n_theta=bar(theta)/(theta dot bar(theta)).
Its denominator is the positive Hermitian square norm of the
nonzero theta, and theta dot n_theta=1. The particular pair

\[
 U_j^p=(-q_{j-1}n_\theta,0)
\]

has the prescribed normal component. By (4) and (8) the vector source
-R U_(j-1)-R^theta U_j^p has zero theta contraction. The remaining
unknown belongs to H_theta direct-sum C and solves an inhomogeneous
square system with invertible coefficient (5). Formula (6) solves it.
All sources, their derivatives, and the particular pair are supported
in K, so the complete next amplitude is supported in exactly the same
allowed compact transverse set.

Choose decreasing planar radii R_j converging to R_infinity>5r.
At each finite j the preceding construction applies on the next smaller
disk; alternatively a finite parameter cover handles a general compact
K. Thus induction constructs every U_j, all defined on the common open
cylinder D_(R_infinity)^2 times R. This proves both the finite and
infinite formal recursion. It is not an assertion that the formal
series converges.

The Lean declarations `normal_source_of_leading`,
`normal_source_of_step`, `normal_source_all_orders` and
`particular_source_tangent` check exactly the algebra of (8) and the
subtracted source for arbitrary additive groups and maps satisfying
(1), (3), and (4). Their hypotheses are identified, not hidden analytic
assumptions; `statement_fidelity.md` specifies this boundary.

## 4. Exact telescoping and physical residual

For N>=4 write A_N=sum_(j=0)^N h^j a_j and B_N=sum_(j=0)^N h^j b_j.
Equation (7) cancels every interior coefficient, leaving

\[
\begin{split}
 R_\tau(A_N,B_N)&=h^N R(a_N,b_N),\\
 S_\tau(A_N,B_N)&=h^N S(a_N,b_N),\\
 \operatorname{div}A_N+h^{-1}\theta\cdot A_N-B_N&=h^N q_N.
                                                               \tag{9}
\end{split}
\]

The finite identities hold for every N, not just for tested orders.
Lean's `vector_telescope` and `divergence_telescope` prove their
h-multiplied forms over every module and every natural N. Division by
h is legitimate here because h>0.

The physical trial displacement is E_tau A_N, not an independently
chosen augmented pair. Linearity in the scalar argument of R and (9)
give the exact physical residual

\[
\begin{split}
 f_h&=E_\tau^{-1}L(E_\tau A_N)\\
 &=h^N\bigl[R(a_N,b_N)+k\nabla q_N+(\nabla\lambda)q_N\bigr]
                       +h^{N-1}k\theta q_N.        \tag{10}
\end{split}
\]

All coefficients in (10) are fixed smooth functions near the closed
B_(5r). Therefore, in every fixed unweighted local Sobolev norm,
f_h=O(h^(N-1))=O(tau^(1-N)).

## 5. Physical solvability without coefficient smallness

The normalized augmented operator from (2) is
Delta Id_4+sum A_j partial_j+A_0. Apply the Salo--Tzou proposition
with s=-1 and phi=-Re(theta dot x), a nonconstant linear limiting
weight, componentwise. Conjugated first-order terms multiplied by h^2
are bounded from H_h^1 to H_h^(-1) by C1 h, uniformly when
h/epsilon is small. Choose epsilon>0 small enough that
C1 is absorbed by the coefficient 1/sqrt(epsilon) on the left,
then choose h sufficiently small relative to this fixed epsilon.
No coefficient is required to be small.

The factor exp(phi^2/(2epsilon)) and its inverse are fixed smooth
multipliers near the closed ball; their H_h^(+/-1) bounds are uniform
in h, though not in epsilon. Removing this factor after absorption
is valid because no further absorption uses those constants.
The oscillatory factor exp(-i Im(theta) dot x/h) shifts h xi by a
fixed vector in Fourier space, so its H_h^(+/-1) bounds are also
uniform. Thus, for compactly supported smooth augmented V,

\[
 \|E_\tau^{-1}V\|_{H_h^1}
       \le Ch\|E_\tau^{-1}{\cal L}V\|_{H_h^{-1}}.   \tag{11}
\]

For a physical test vector w use V=(w,div w). By (1), the augmented
forcing consists of smooth coefficient multiples of Lw and div Lw.
With F=E_tau^(-1)Lw,

\[
 E_\tau^{-1}\operatorname{div}(Lw)
       =\operatorname{div}F+h^{-1}\theta\cdot F.
\]

Fourier multiplication gives ||partial_j F||_(H_h^-1)
<=h^(-1)||F||_L2, and smooth compactly localized coefficient
multiplication is uniformly bounded in that norm. The displacement
component of (11) therefore gives

\[
 \|E_\tau^{-1}w\|_{L^2}\le C\|E_\tau^{-1}Lw\|_{L^2}.              \tag{12}
\]

Set A_theta=E_tau^(-1)L E_tau. Since the coefficients are real and
L is formally self-adjoint,
A_theta^*=A_(-bar(theta)). This is another fixed nonzero bilinear
null direction, so (12) also bounds test vectors by their adjoint
images. For any f in L2, the functional

\[
 A_\theta^*v\longmapsto(v,f)_{L^2}
\]

is well defined and has norm at most C||f||. Hahn--Banach and Riesz
produce z with (A_theta^*v,z)=(v,f) and ||z||<=C||f||.
Conjugating this equality if the inner product is linear in its first
argument gives the distributional equation A_theta z=f. This is a
right inverse for the physical displacement operator, not for an
independent scalar equation.

## 6. Uniform interior estimates and both correction rates

The principal symbol of minus L is
m|xi|^2 Id+k xi tensor xi. It is uniformly positive on each compact
set for real xi; in particular its inverse has the uniform symbol
bounds required for elliptic system regularity.

On B(x0,2h), put x=x0+h y and multiply A_theta z=f by h^2.
All scaled coefficients, with every fixed number of y derivatives,
are uniformly bounded as x0 ranges over a fixed compact set and
0<h<=h0. The order-two part stays uniformly elliptic. The
coefficients depend smoothly on (x0,h), including h=0, on this compact
parameter set.

Here is why the usual fixed-ball estimate has a uniform constant:
the matrix inverse of its principal symbol is an order-minus-two
symbol. Its differentiated symbol bounds follow from the inverse
matrix formula and the common ellipticity bound. The finite
parametrix construction with nested fixed cutoffs therefore has
uniform symbol seminorms, as do the lower-order corrections and
smoothing remainder. Sobolev mapping bounds for that parametrix give
uniform fixed-ball H^2 estimates. The same construction to more
orders gives, for every fixed s>=0, the H^(s+2) version. This is the
matrix version of the local estimate in the cited elliptic
regularity source; scalar division of symbols is replaced by the
matrix inverse, with no change in orders or parameter bounds.

Rescaling and covering a smaller ball by h-balls, with uniformly
bounded overlap of doubled balls, yields

\[
 \sum_{j=0}^{s+2}h^j\|\nabla^j z\|_{L^2(B')}
 \le C_s\left(\|z\|_{L^2(B)}
               +h^2\sum_{j=0}^{s}h^j
                                  \|\nabla^j f\|_{L^2(B)}\right).             \tag{13}
\]

One first squares and sums the ball estimates; the finite sum of
derivative norms is equivalent to its square-sum. Enlarging the
intermediate compact ball if necessary proves (13) for any
B' compactly contained in B. For fixed h, elliptic regularity also
gives smoothness when f is smooth.

Apply the physical right inverse on B_(5r) to -f_h from (10).
It gives r_h with

\[
 A_\theta r_h=-f_h,\qquad \|r_h\|_{L^2(B_{5r})}=O(h^{N-1}).
\]

Equation (13) with s=0 on B_(4r) gives

\[
 \|r_h\|+h\|\nabla r_h\|+h^2\|\nabla^2r_h\|=O(h^{N-1}).          \tag{14}
\]

Its **actual conjugated divergence** is
d_h=div r_h+h^(-1)theta dot r_h. The product rule and (14), with
theta constant, imply

\[
\begin{split}
 \|d_h\|+h\|\nabla d_h\|
 &\le C h^{-1}\bigl(\|r_h\|+h\|\nabla r_h\|
                              +h^2\|\nabla^2r_h\|\bigr)\\
 &=O(h^{N-2})=O(\tau^{2-N}).                       \tag{15}
\end{split}
\]

This accounts for both derivative losses, rather than identifying
an independent scalar correction with a divergence.

Now u_tau=E_tau(A_N+r_h) is a smooth exact solution on B_(5r).
By (9) its conjugated physical pair is exactly

\[
 {\cal A}_h=(A_N+r_h,\ B_N+h^N q_N+d_h).
\]

The finite smooth expansions, (14), and (15) give
cal A_h converging to (a0,b0) strongly in L2 and
||cal A_h||+h||grad cal A_h||=O(1). Since
E_tau^(-1)partial_j(E_tau cal A_h)
=partial_j cal A_h+h^(-1)theta_j cal A_h,
the required weighted derivative norm is O(tau).
This proves Theorem 1, for every admissible medium and every fixed
nonzero null theta.

## 7. A single complete smooth expansion

The infinite recursion above is defined on a common cylinder of
radius R_infinity>5r. Choose a compact cylinder Q, with interior
containing the closed B_(5r), inside that common cylinder. Let p_s
be increasing C^s seminorms on Q for pairs. Choose a smooth scalar
cutoff eta equal to one near zero and zero on [1,infinity).
For j>=1 choose positive epsilon_j tending to zero, with
epsilon_j<=2^(-j), sufficiently small that

\[
 \epsilon_j^{\,j/2}p_j(U_j)\le2^{-j}.
\]

The parameter-dependent pair

\[
 U(h)=U_0+\sum_{j\ge1}h^j\eta(h/\epsilon_j)U_j
       =(a(h),b(h))
\]

is locally a finite sum for each h>0, is smooth in x, and retains
the transverse support K. For fixed M,s, its tail has
p_s norm O(h^(M+1)): for all sufficiently large j,
j-M-1>=j/2 and j>=s, and a nonzero summand has h<=epsilon_j.
The finitely many remaining tail terms obey the same bound, and
the factors for j<=M equal one for sufficiently small h. This
proves a full C-infinity asymptotic expansion on Q without
assuming convergence of the formal series.

The recursions cancel every coefficient in R_tau U(h),
S_tau U(h), and
div a(h)+h^(-1)theta dot a(h)-b(h).
Indeed a differential operator of order two and parameter growth
at most h^(-2) preserves arbitrarily high asymptotic order after
choosing a sufficiently long truncation. Thus the three defects
are O(h^M) in every fixed C^s norm, for every M.
The physical scalar-defect identity used in (10) then shows

\[
 f(h)=E_{1/h}^{-1}L(E_{1/h}a(h))
       =O(h^M)\quad\hbox{in every }C^s(Q),\ \hbox{for all }M.
\]

Choose a physical correction for each h using the same uniform
L2 estimate (12). Its L2 norm is flat in h, and (13) makes every
local derivative flat as well. Its actual conjugated divergence
and all its local derivatives are also flat; the extra factor
h^(-1) only shifts an arbitrarily high power. Sobolev embedding
on an intermediate ball gives C^s flatness on the closed B_(4r).
The exact solutions E_(1/h)(a(h)+r(h)) consequently have the single
complete physical expansion asserted in Theorem 2. Smooth
dependence of the selected exact solution on h is not asserted
or needed.

## 8. Necessity of all constrained leading equations

Let (a_h,b_h)=E_(1/h)^(-1)(u_h,div u_h) converge strongly in
L2_loc. Actual divergence gives

\[
 \theta\cdot a_h=h b_h-h\operatorname{div}a_h.
\]

For every compactly supported test function the right side tends
to zero, transferring the derivative to the test function.
Hence theta dot a=0. Since the exact physical pair satisfies
both augmented equations, null conjugation gives

\[
 R^\theta(a_h,b_h)+hR(a_h,b_h)=0,\qquad
 S^\theta(a_h,b_h)+hS(a_h,b_h)=0 .
\]

Fixed smooth differential operators act continuously from locally
bounded L2 families to distributions. The h-multiplied terms
therefore vanish and the remaining terms pass to the limit.
Thus R^theta(a,b)=S^theta(a,b)=0 in distributions. This proves the
converse, including its lack of a derivative-bound assumption.

## Exact fixture and negative controls

These examples check implementation and statement fidelity only.
For lambda=mu=1 and theta=(1,i,0), a rank-three leading frame is

\[
 ((1,i,0),0),\quad ((0,0,1),0),\quad (-x_1(1,i,0),1).
\]

The corresponding exact conjugated displacements are the first
two constant vectors and
-x1(1,i,0)+2h(1,0,0). For the third column, div a0=-1 but
the actual conjugated divergence is 1. The missing normal term
theta dot a1=2 accounts for the difference. `verify.py` checks
all physical equations exactly for symbolic tau, the frame
determinant 1, a deliberately wrong compatibility sign, and the
divergence defect -2 obtained by omitting that normal term.
These deliberately mutated statements are not errors attributed
to the manuscript.

## Manuscript correspondence and evidence boundary

| Manuscript label | Independently established statement |
|---|---|
| `lem:augmented-system`, `eq:augmented-identity` | (1), the physical operator expansion, and (2) |
| `eq:leading-operators` | Full non-null factorizations and their null restrictions |
| `eq:normal-transport-component` | (4), for arbitrary independent pairs |
| `lem:planar-frames` | Disk frames, local parameter dependence, and (6) |
| `eq:physical-recursion`, `eq:transport-compatibility` | (3), (7), (8), and the all-order algebra |
| `eq:truncated-vector-residual`, `eq:truncated-divergence` | (9), for every N |
| `eq:physical-truncated-residual` | Exact (10), hence O(tau^(1-N)) |
| `prop:carleman`, `cor:physical-solvability` | (11), (12), and the physical adjoint argument |
| `lem:scaled-interior` | (13), including the uniform system constants |
| `eq:physical-remainder-two-derivatives`, `eq:physical-divergence-remainder` | (14), (15), hence O(tau^(2-N)) actual-divergence correction |
| `prop:physical-amplitudes`, `eq:physical-leading-limit` | Theorem 1, including rank, amplitude support, actual divergence, and weighted derivatives |

`python3 verify.py` replays the universal exact identities and the
separately labelled fixture. The Lean source formalizes only the
conditional compatibility and finite-sum algebra for all orders;
it does not formalize the analytic proof. Its genuine compiler
outcome, when recorded, is in `lean_verification.json` and the
claim-bound certificate beside `Main.lean`. The successful real Lean 4.31.0
run has exit code 0 and no proof holes; `normal_source_all_orders` depends
only on propositional extensionality, and the finite-sum theorems use only
the usual library axioms, not `sorryAx`. The replay compares the current
formal source and fidelity document to the compiler's recorded digests
and checks the claim-bound native certificate. It does not recompile Lean
or elevate the analytic proof to a formal theorem. Statement fidelity
and the cited analytic inputs require independent human review.
No claim here certifies the subsequent transport matching,
projective-direction holomorphic comparison, conic rigidity,
coefficient recovery, or global inverse uniqueness.
