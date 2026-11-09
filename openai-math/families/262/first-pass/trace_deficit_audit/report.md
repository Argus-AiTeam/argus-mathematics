# Integrated matrix trace deficit: independent verification and boundary extension

## 1. Scope and source findings

This work addresses the integrated finite-matrix trace theorem, not the full
Lieb--Thirring inequality or its classification of extremizers. The source
versions are the staged OpenAI preprints dated October 5, 2026 (matrix and
equality papers) and September 23, 2026 (scalar constants paper). All source
paths below are relative to `research/openai_manuscript/`.

The matrix paper's
`Sharp-one-dimensional-Lieb-Thirring-inequalities-for-matrix-potentials-October-5-2026/build/sections/trace.tex`,
Theorem `thm:trace`, assumes Hermitian B,V in every finite dimension,
`(sI-B)^2+V >= bI` for every real s and one fixed b>0, 0<sigma<1,
and, separately, N>=0. Equation `eq:trace-deficit` states the exact remainder,
not just the comparison. Indefinite V is explicitly allowed. Its half-line
boundary matrices S,T are Hermitian but are not asserted positive.

The equality paper's
`Equality-cases-in-the-sharp-one-dimensional-matrix-Lieb-Thirring-inequality-October-5-2026/build/sections/appendix-trace.tex`,
Theorem `trace:deficit`, has the same hypotheses and exact remainder.
Its `action.tex`, Lemma `act:constraint`, uses that remainder on [1,2] to
control the commutator and algebraic equality defects with constants independent
of row count and smallest binding energy. Reproducing that bound is not a new
improvement. The trace theorem alone does not establish its action paths,
infinite-row compactness, fixed-channel decomposition, or scalar profiles.

The scalar constants paper uses its own `rank-one.tex`, Proposition
`prop:rankone`, together with the field, connecting-path, action-limit, and
spectral arguments. Its rank-one comparison is not a substitute for the
arbitrary-rank theorem considered here.

The existing ledger initially contained only the campaign objective, with no
certified trace result. The strongest mathematical prior result relevant here
is nevertheless the *staged exact deficit itself*, including the stronger
quantitative use in the equality paper. The contribution sought below is an
independent verification of that actual identity, universal kernel-checked
finite-matrix algebra, and an extension to singular, gapless symbols with a
sharp convergence criterion. It is not a claim to have improved the sharp
constant or the already stated action coercivity.

A bounded web lookup found no primary source for the specific gapless
extension. The search returned general trace-inequality material and did not
reliably index the staged preprints. This is a retrieval limitation, not proof
of novelty. Benguria--Loss (2000), cited in the manuscripts, is contextual
prior art for Riccati methods; no proposition from it is used as a substitute
for the construction proved here. Novelty and publishability remain for
independent assessment.

No false assertion of the staged trace manuscripts has been established.
In particular, allowing a zero symbol gap or dropping N>=0 would change their
literal hypotheses; examples outside those hypotheses are not refutations.

## 2. Evidence boundaries

`lean/Main.lean` certifies universal finite-matrix algebra, not Sobolev theory,
Fourier inversion, matrix functional calculus, or improper integration.
`verify.py` checks an exact algebraic certificate and exact admissible and
singular specimens, not sampled survival of the analytic theorem.
The analytic argument belongs to this report and requires independent
mathematical review. No Engineer opinion is an independent Reviewer verdict.

The Jacobian discovery, inspected typed contract, exact payload, and typed
inertia answer are retained as dedicated JSON files. The chosen operation is
`matrix.inertia.compute`; it is used only for the rational perturbation in the
specimen, not as evidence of a universal identity. Discovery reported server
0.14.0, protocol 2025-11-25. Adapter failures or UNKNOWN would be non-conclusions.

The actual Lean 4.31.0 run returned exit code 0, no proof holes, and a
successful axiom audit. Its nine declarations include Riccati averaging,
the inverse/Riccati trace contraction, the ordered adjoint-square identity,
and finite Gram positivity. Its separate statement-fidelity document states
the precise hypotheses and exclusions. This certifies the finite algebra;
it does not promote the following analytic proof to a kernel proof.

## 3. The verification and extension theorem

Write beta=sigma-1/2, p=1+sigma, r=1/sigma, q=1+r. Let B,V be
Hermitian n by n complex matrices, n>=1, and suppose

\[
 X_s=(sI-B)^2+V\geq0\qquad(s\in\mathbb R).
\]

The polynomial det X_s is monic of degree 2n. It therefore has finitely
many real zeros. Away from them X_s is positive definite. At each real
zero s_j let 2m_j be the largest Laurent pole order among the entries
of X_s^{-1}. This order is even, and 1<=m_j<=n, as proved below.
Put m=max m_j when there are zeros, and m=0 otherwise. Define

\[
 \alpha_m=\begin{cases}0&m=0,\\
 \frac12-\frac1{2m}&m\geq1.
 \end{cases}
\]

**Theorem.** With R,P,N and c_sigma defined exactly as in the
manuscripts, the integral defining N converges absolutely in matrix
norm if and only if sigma>alpha_m. More precisely, if m>=1, put
A_j=lim_{x->0} x^{2m_j}X_{s_j+x}^{-1}. Then

\[
 \lim_{t\downarrow0}t^{\,1-1/(2m)}R(t)=
 \mathcal K:=\frac1m\csc\frac{\pi}{2m}
       \sum_{j:m_j=m} A_j^{1/(2m)}\ne0.                       \tag{0}
\]

This is a matrix-norm limit, not only a trace estimate. For m>1,
let N_epsilon denote the defining integral with lower endpoint
epsilon. Its precise divergence is

\[
\begin{cases}
 \displaystyle\lim_{\epsilon\downarrow0}
 \epsilon^{\alpha_m-\sigma}N_\epsilon
       =-\dfrac{c_\sigma}{\alpha_m-\sigma}\mathcal K,
       &0<\sigma<\alpha_m,\\[6pt]
 \displaystyle\lim_{\epsilon\downarrow0}
 \dfrac{N_\epsilon}{\log(1/\epsilon)}=-c_\sigma\mathcal K,
       &\sigma=\alpha_m .
\end{cases}                                                   \tag{0a}
\]

When N converges, it is Hermitian,
R(t)>0, and continuous Hermitian L=R^{-1}>0 and Z satisfy

\[
 V+tI=L^2+Z^2+i[B,Z],\qquad LZ+ZL+i[B,L]=0.                 \tag{1}
\]

For every positive semidefinite D, the following integrals are finite:

\[
\begin{split}
 \operatorname{tr}(NV)
 ={}&q\operatorname{tr}(ND)-\frac q p\operatorname{tr}(D^p)\\
 &+c_\sigma\int_0^\infty t^\beta\left[
 \operatorname{tr}(RZ^2)+
 q\|R^{-1/2}-R^{1/2}(tI+D)^{1/2}\|_{\rm HS}^2\right]\,dt .
                                                               \tag{2}
\end{split}
\]

In particular, with N_+ the positive spectral part of N,

\[
\begin{split}
 \operatorname{tr}(NV)-\operatorname{tr}(N_+^q)
 =c_\sigma\int_0^\infty t^\beta\left[
 \operatorname{tr}(RZ^2)+
 q\|R^{-1/2}-R^{1/2}(tI+N_+^r)^{1/2}\|_{\rm HS}^2\right]\,dt .
                                                               \tag{3}
\end{split}
\]

Equality in this comparison holds if and only if [B,V]=0 and V>=0.
In particular equality forces N>=0; that condition is not assumed in
(2)--(3).

For the *original* manuscript hypotheses, the symbol is uniformly
positive, so m=0. If, separately, N>=0, then N_+=N and (3) is exactly
the requested manuscript deficit, including both coefficients and
the displayed noncommutative factor ordering. Thus the original
theorem is verified, not assumed.

The gapless extension is not a stronger action-coercivity estimate.
Its additional content is the necessary and sufficient convergence
condition, its sharp dimension dependence, the exact leading singular
matrix (0), the power/logarithmic divergence constants (0a), and the
extension of the identity beyond uniformly positive symbols.
Uniformly over dimension n,
sigma>(n-1)/(2n) is sufficient and sharp. Sections 4--10 prove the
identity independently; Sections 11--12 prove the pole criterion and
its sharpness. No assertion about all equality cases of the
infinite-dimensional Lieb--Thirring inequality follows from this theorem.

## 4. Resolvent estimates and endpoint assumptions

For large |s|, X_s and Y_s=(sI-B)^2 grow like s^2 I. For t>0,
X_s+tI is positive definite, and its inverse is integrable in s.
Thus R(t)>0. On compact t intervals contained in (0,infinity),
the inverse and its t derivatives have integrable norm bounds.
In particular R is continuous.

For t>=1 there is a constant c>0, independent of s,t, such that both
X_s+tI and Y_s+tI dominate c(s^2+t)I. To see this, choose M so large
that each symbol dominates s^2 I/2 for |s|>=M. On |s|<=M,
X_s+tI>=tI and Y_s+tI>=tI, and
t>=(s^2+t)/(M^2+1). The resolvent identity, with the *ordered*
product (Y_s+tI)^{-1} V (X_s+tI)^{-1}, gives

\[
 \|P(t)\|\leq C\int_\mathbb R(s^2+t)^{-2}ds=O(t^{-3/2}).
                                                               \tag{4}
\]

Under the original uniform gap R(t)=O(1) as t decreases to zero,
so P(t)=O(t^{-1/2}). More generally Section 11 proves

\[
 \|R(t)\|=O(t^{-a_m}),\quad a_m=1-\frac1{2m}\ (m\geq1).
                                                               \tag{5}
\]

Set a=1/2 in the gapped case and a=a_m otherwise. In either case
P(t)=O(t^{-a}) at zero. Consequently

\[
 \int_0^\infty t^\beta\|P(t)\|dt<\infty
 \quad\text{provided }\sigma>\alpha_m.                          \tag{6}
\]

The converse for m>1 is proved in Section 11. The proof of the
identity below uses precisely (4), (6), and
sigma+1/2-a>0, and so applies to both the original and extended cases.

## 5. Half-line existence, boundary signs, and stable spectrum

Fix t>0 and put nabla=partial_x-iB. The full-line form

\[
 a_t(\phi,\psi)=\int\bigl(
 \langle\nabla\phi,\nabla\psi\rangle+
 \langle\phi,(V+tI)\psi\rangle\bigr)dx
\]

uses inner products linear in the second variable. Its Fourier symbol
is X_s+tI. This symbol dominates c_t(1+s^2)I for some c_t>0:
combine its positive lower bound tI with quadratic growth outside
a fixed compact s interval. Fourier--Plancherel therefore makes a_t
an equivalent Hilbert inner product on H^1(R;C^n).

On a half-line, a function in H^1 with boundary value zero has a
zero extension in H^1(R); there is no delta term in its weak derivative.
The same coercivity therefore holds on the trace-zero subspace.
For prescribed v, take any H^1 extension eta with eta(0)=v.
The bounded functional phi -> -a_t(phi,eta) has a unique representing
element u in this subspace for the a_t inner product. Then
psi=eta+u is the unique H^1 weak solution with boundary value v.
This use of Hilbert-space representation is legitimate even if V
is indefinite: coercivity is on the trace-zero space and comes from
the full symbol, not from positivity of V or of a boundary matrix.

For completeness, the representation assertion follows from the
elementary Hilbert projection argument: a closed subspace admits a
nearest point because a minimizing sequence is Cauchy by the
parallelogram identity; completeness gives the minimizer and
orthogonality. Apply this to the kernel of a nonzero bounded
functional to obtain its representing vector. No Riccati or
Schrodinger comparison theorem is being imported here.

The equation gives
psi''=2iB psi'+(B^2+V+tI)psi in L^2, so psi is H^2.
Both psi and psi' vanish at the infinite end. One direct justification
is the H^1 estimate
|f(x)|^2 <= 2||f||_{L^2(x,infinity)}||f'||_{L^2(x,infinity)}
for the continuous representative, obtained by integration from a
sequence on which f tends to zero; apply it to psi and psi'.
The left half-line is identical with the direction reversed.

Define linear boundary maps by

\[
 \nabla\psi(0+)=-Sv,\qquad \nabla\psi(0-)=Tv.
\]

Integration by parts gives a_t(psi_v,psi_w)=<v,Sw> on the right
and <v,Tw> on the left. Hence S,T are Hermitian. They need not be
positive. Translation of a solution followed by uniqueness gives
nabla psi=-S psi everywhere on the right and nabla psi=T psi
everywhere on the left. The product rule

\[
 \nabla(-S\psi)=-S\nabla\psi+i[B,S]\psi
\]

now gives

\[
 V+tI=S^2+i[B,S]=T^2-i[B,T].                                 \tag{7}
\]

Glue the solutions with their common value v at zero. The ordinary
derivative, and also the covariant derivative, has jump -(S+T)v.
Thus on the full line

\[
 (-\nabla^2+V+tI)\psi=\delta_0(S+T)v.
\]

With forward Fourier kernel exp(-isx), inversion at zero gives
v=R(t)(S+T)v/2. This evaluation is valid: the inverse symbol is
O(s^{-2}), so its Fourier inverse is continuous. Since R(t)>0,

\[
 L=(S+T)/2=R^{-1}>0,\qquad Z=(S-T)/2
\]

obey (1) by adding and subtracting (7). The Sylvester map
Z -> LZ+ZL is invertible: in an eigenbasis of L it multiplies
entry jk by the strictly positive number lambda_j+lambda_k.
Consequently Z is continuous in t. Its diagonal entries in this
basis vanish in (1), so tr Z=0.

Finally psi'=i(B+iS)psi on the right. Every eigenvector of B+iS
with eigenvalue u+iv produces exp(iux-vx) times that vector.
It is a right H^1 solution, so v>0. This proves stable spectral
location without assuming diagonalizability or positivity of S.

## 6. The noncommutative sign calculation

Multiply the second equation of (1) on the left and right by R.
The actual matrix equation is

\[
 ZR+RZ+i(RB-BR)=0.
\]

Multiply by Z and take the finite matrix trace. Cyclicity gives

\[
 i\operatorname{tr}(R[B,Z])=-2\operatorname{tr}(RZ^2).
\]

The first equation of (1) therefore gives

\[
 \operatorname{tr}(R(V+tI))
   =\operatorname{tr}L-\operatorname{tr}(RZ^2).                 \tag{8}
\]

The sign is negative, not positive. The correction
Q(t)=tr(RZ^2)=tr(ZRZ)=||R^{1/2}Z||_HS^2 is nonnegative.
These equations are formalized from the *matrix* hypotheses, not
from an assumed trace contraction. In the exact word certificate,
if C=W-L^2-Z^2-i[B,Z] and A=LZ+ZL+i[B,L], then

\[
 \operatorname{tr}(RW-L+RZ^2)
 =\operatorname{tr}(RC)+\operatorname{tr}(RARZ)
\]

modulo RL=LR=I. This is a dimension-independent certificate of the
sign calculation.

## 7. Logarithmic determinant: convergence and evaluation

Let

\[
 J(t)=\pi^{-1}\int_\mathbb R
       \log\frac{\det(X_s+tI)}{\det(Y_s+tI)}\,ds,\qquad
 F(t)=t^{-1/2}\operatorname{tr}V-J(t).
\]

All determinants here are positive. Factor the ratio using
(Y_s+tI)^{-1/2}; the perturbation inside log det is O(s^{-2}),
so the log ratio is absolutely integrable. Jacobi's determinant
derivative and the resolvent identity give a locally uniform
integrable bound for its t derivative. Differentiation under the
integral is consequently justified and

\[
 J'(t)=-\operatorname{tr}P(t),\qquad
 F'(t)=-\frac{\operatorname{tr}V}{2t^{3/2}}+\operatorname{tr}P(t).
                                                               \tag{9}
\]

The ordered factorization, with its sign as in (7), is

\[
 X_s+tI=(sI-B+iS)(sI-B-iS).
\]

If u_j+iv_j are the eigenvalues of B+iS, including algebraic
multiplicity, then v_j>0. Taking determinants gives the real factors
((s-u_j)^2+v_j^2). The denominator has centers equal to the
eigenvalues of B and widths sqrt(t).

Removing centers from symmetric-cutoff integrals is valid, although
individual logarithms are not integrable. For h(s)=log(s^2+v^2),
the derivative with respect to a of its integral on [-M,M] after
translation by a is h(M+a)-h(M-a). This tends to zero uniformly
for a in each fixed bounded interval. Integration in a therefore
shows that translation changes the cutoff integral by o(1).
After centering, differentiation with respect to v and integration
from w to v prove

\[
 \int_\mathbb R\log\frac{s^2+v^2}{s^2+w^2}\,ds=2\pi(v-w).
\]

Since sum v_j=tr S=tr L, this proves

\[
 J(t)=2\operatorname{tr}(L-\sqrt t I),\qquad
 F(t)=\frac{\operatorname{tr}V}{\sqrt t}
       -2\operatorname{tr}(L-\sqrt t I).                       \tag{10}
\]

No choice of eigenvectors, differentiability of eigenvalues, or
exchange of divergent one-sided log integrals is used.

## 8. Positivity, domination, and the improper integration by parts

Put G(t)=tr(L-2 sqrt(t)I+tR). Since R=L^{-1}>0, each eigenvalue
lambda of L contributes (lambda-sqrt(t))^2/lambda>=0. Taking
the trace in (1), then using (10), gives

\[
 F(t)=t^{-1/2}\operatorname{tr}((L-\sqrt t I)^2+Z^2)\geq0.
\]

Equation (8) gives the *exact* identity

\[
 \operatorname{tr}(P(t)V)=F(t)+G(t)+Q(t).                    \tag{11}
\]

In particular all three nonnegative terms are bounded by
n||V||||P(t)||. This conclusion does not presume P>=0 or V>=0.
Equations (4)--(6) prove weighted integrability of each term and

\[
 t^{\beta+1}F(t)\longrightarrow0
 \quad\text{at both zero and infinity}.
\]

Indeed the bounds are O(t^{sigma+1/2-a}) at zero and
O(t^{sigma-1}) at infinity, with strictly positive and strictly
negative exponents respectively.

Equations (9)--(10) give tF'=-F/2-G. Integrate the derivative
of t^{beta+1}F over [epsilon,M], use the endpoint bounds, and then
pass to the improper limits. This proves

\[
 \int_0^\infty t^\beta G(t)dt
 =\sigma\int_0^\infty t^\beta F(t)dt.
\]

Integrating (11) thus proves, without any condition on the sign of N,

\[
 \operatorname{tr}(NV)=q c_\sigma\int_0^\infty t^\beta G(t)dt
            +c_\sigma\int_0^\infty t^\beta Q(t)dt.             \tag{12}
\]

## 9. Normalization, Tonelli, and the ordered square

The normalization integrand is positive, O(t^{sigma-1}) at zero,
and O(t^{sigma-2}) at infinity. Its integral is finite and nonzero.
Substitution t=yu proves the scaling identity y^sigma for every
y>0; at y=0 both sides are zero.

For D>=0 let

\[
 F_0(t,D)=t^{-1/2}\operatorname{tr}D
          -2\operatorname{tr}((tI+D)^{1/2}-\sqrt t I).
\]

A scalar eigenvalue d contributes
the nonnegative integral from 0 to d of
t^{-1/2}-(t+y)^{-1/2}. Finite-dimensional spectral decomposition,
Tonelli, and the scaling identity therefore give

\[
 c_\sigma\int_0^\infty t^\beta F_0(t,D)dt
       =p^{-1}\operatorname{tr}(D^p).                         \tag{13}
\]

Let H=(tI+D)^{1/2}, A=R^{1/2}, U=R^{-1/2}. The actual ordered
matrix square is

\[
 (U-AH)^*(U-AH)=R^{-1}+HRH-2H.
\]

Only *after taking the trace* does cyclicity replace HRH by RH^2.
Thus

\[
 \mathcal D_D(t)=\|U-AH\|_{\rm HS}^2
 =G(t)-\operatorname{tr}(P(t)D)+F_0(t,D).                    \tag{14}
\]

This uses no commutation of R and D. All three terms on the
right are absolutely integrable with weight t^beta by (6),
(11), and (13); hence so is the nonnegative square. Integrating
(14), substituting into (12), proves (2).

## 10. Spectral choice and all equality cases of the trace comparison

For D=N_+^r, finite-dimensional spectral calculus gives
tr(ND)=tr(N_+^q), tr(D^p)=tr(N_+^q), and
q(1-1/p)=1. This proves (3). For the original claim use its
separately required N>=0; no step has inferred this from symbol
positivity.

If the deficit in (3) vanishes, its two continuous nonnegative
integrands vanish for every t>0. Since R>0, first Z=0, and then
R^{1/2}(L-H)=0 gives L=H. Equation (1) now implies
V=D>=0 and [B,L]=0, hence [B,V]=0. Conversely simultaneous
diagonalization for [B,V]=0,V>=0 gives
R(t)=(tI+V)^{-1/2}, N=V^sigma, and Z=0. Both remainders vanish.
This proves precisely the equality characterization stated in
Section 3, not the manuscript's later Schrodinger equality theorem.

## 11. Sharp local convergence criterion

At a real zero s_j of det X, the rational matrix X_s^{-1}
has a Laurent expansion with finite leading pole p. It must have
a pole because its least eigenvalue tends to zero. Write its
nonzero leading Hermitian coefficient as A. Positivity of the
inverse for real s on both sides of s_j forces p even and A>=0:
an odd p would force both A and -A to be positive semidefinite,
contradicting A!=0. Thus p=2m_j. Since the denominator det X
has degree 2n, p<=2n.

The Laurent expansion implies
||X_s^{-1}|| is bounded above and below by positive multiples of
|s-s_j|^{-2m_j}. Therefore its least eigenvalue mu(s) is bounded
above and below by positive multiples of |s-s_j|^{2m_j}.
For every positive definite matrix X_s,

\[
 (\mu(s)+t)^{-1}
 \leq\operatorname{tr}(X_s+tI)^{-1}
 \leq n(\mu(s)+t)^{-1}.
\]

Integrating on a small neighborhood and substituting
s-s_j=t^{1/(2m_j)}u proves a two-sided bound by constant
multiples of t^{-1+1/(2m_j)}. The remaining s region is bounded
as t decreases to zero, including the quadratically growing tails.
The largest m_j dominates, proving

\[
 \operatorname{tr}R(t)\asymp t^{-1+1/(2m)},\qquad m\geq1.
\]

This proves (5) and sufficiency of sigma>alpha_m.
For m>1 this growth is strictly faster than t^{-1/2}, so
tr P(t)=n t^{-1/2}-tr R(t) is negative and comparable to
-t^{-1+1/(2m)} near zero. If sigma<=alpha_m its weighted
integral tends to minus infinity (logarithmically at equality).
Hence even conditional convergence of the matrix integral is
impossible. For m=1, every allowed sigma>0 already satisfies the
criterion. If there are no real zeros, compactness plus growth
give a uniform positive symbol gap. This completes necessity and
sufficiency, including all boundary cases within 0<sigma<1.

Here is the stronger matrix asymptotic (0). Work first at one root
of index m_j=k and leading coefficient A. For fixed real u!=0,
put x=t^{1/(2k)}u. The Laurent expansion gives
tX_{s_j+x}^{-1}->u^{-2k}A. The map
T -> T(I+T)^{-1} is continuous on positive semidefinite matrices, so

\[
 t(X_{s_j+x}+tI)^{-1}
   \longrightarrow A(u^{2k}I+A)^{-1}.
\]

The value at u=0 is immaterial. The least-eigenvalue bounds already
proved dominate the left side in norm by
C/(1+|u|^{2k}) on the rescaled neighborhood. Extend it by zero
outside that neighborhood and apply dominated convergence.
Diagonalizing the fixed positive semidefinite A, including its
zero eigenspace, yields

\[
 \lim_{t\downarrow0}t^{1-1/(2k)}
 \frac1\pi\int_{|s-s_j|<d}(X_s+tI)^{-1}ds
 =\frac1\pi\int_\mathbb R A(u^{2k}I+A)^{-1}du
 =\frac1k\csc\frac{\pi}{2k}\,A^{1/(2k)} .
\]

In the middle expression define the integrand arbitrarily at u=0
on the kernel of A; at all nonzero u it is unambiguous. For a positive
eigenvalue a, substitution u=a^{1/(2k)}v explains exactly the power
a^{1/(2k)}. The scalar integral is
integral_R (1+v^{2k})^{-1}dv=(pi/k)csc(pi/(2k)).
For example, integrate (1+z^{2k})^{-1} on an upper semicircle:
the upper poles are z_l=exp(i(2l+1)pi/(2k)), their residues are
-z_l/(2k), and their sum uses
sum_{l=0}^{k-1}z_l=i csc(pi/(2k)). The arc vanishes.
This derives the constant rather than appealing to a specialized
matrix spectral-factorization theorem.

Sum these local limits. A root with k<m contributes zero after
the larger-m rescaling, and the nonsingular region contributes
zero as well. This proves (0); the sum is nonzero and positive
semidefinite because each maximal A_j is. Finally insert
R(t)=t^{-1+1/(2m)}(mathcal K+o(1)) into the truncated integral.
The t^{-1/2}I term is integrable for every sigma>0. Elementary
power integration, or logarithmic averaging at the critical
exponent, gives (0a) in matrix norm. Thus the divergence rate,
direction, and constant are determined, not only its existence.

## 12. Sharpness in every dimension

Let J be the n by n nilpotent Jordan block with ones on its first
superdiagonal, and put

\[
 B=(J+J^*)/2,\qquad V=J^*J-B^2,\qquad
 X_s=(sI-J)^*(sI-J).
\]

This is a nonnegative symbol of exactly the required Hermitian
quadratic form. For s!=0, the finite geometric sum gives

\[
 (sI-J)^{-1}=\sum_{k=0}^{n-1}s^{-k-1}J^k .
\]

Multiplication by sI-J telescopes to I because J^n=0;
this is an identity for every n, not an extrapolation from small
matrix tests. Consequently X_s^{-1} has leading term

\[
 s^{-2n}J^{n-1}(J^*)^{n-1}=s^{-2n}e_1e_1^* .
\]

The coefficient is nonzero, so m=n and the threshold
(n-1)/(2n) is attained. For n>=2, V is indefinite:
<e_1,Ve_1>=-1/4 whereas tr V=(n-1)/2>0.
Equation (0) here reads
t^{1-1/(2n)}R(t)->(1/n)csc(pi/(2n))e_1e_1^*;
its coefficients are exactly 1/sqrt(2) for n=2 and 2/3 for n=3.
The exact verifier displays the n=2 and n=3 instances; the
universal finite-sum proof above, not those two instances,
establishes sharpness in every dimension.

## 13. Exact noncommuting specimens

### A uniformly positive symbol with indefinite V and N>0

Take

\[
 J=\begin{pmatrix}0&1\\0&0\end{pmatrix},\quad
 B=\begin{pmatrix}0&1/2\\1/2&0\end{pmatrix},\quad
 V=\begin{pmatrix}-3/16&0\\0&13/16\end{pmatrix}.
\]

Then X_s=(sI-J)^*(sI-J)+(1/16)I >=(1/16)I
for every real s, V is indefinite, and [B,V]!=0.
Choose sigma=1/2048. The following explicit bounds prove N>0;
no numerical quadrature is used.

For |s|<=2, X_s^{-1} <=16I. For |s|>=2,
||(sI-J)v||>=(|s|-1)||v|| gives X_s>=s^2 I/4.
Thus R(t)<=R(0)<=68I/pi<=128I for all t>0.
Write M=128 and tau=2^{-16}=(2M)^{-2}. On (0,tau),
P(t)>=(1/2)t^{-1/2}I, so its weighted integral is at least
tau^sigma/(2sigma)I >=1/(4sigma)I, because 16sigma<=1.
On (tau,1), P(t)>=-MI, giving a loss at most 2M.

For t>=1, B^2=I/4 and the displayed symbol show
X_s+tI,Y_s+tI >=(s^2+t)I/2. For X use
s^2-|s|+t+1/16 >=s^2/2+t/2; the Y bound follows from
(sI-B)^2>=s^2I/2-B^2. Since ||V||<=1, the ordered
resolvent identity gives ||P(t)||<=2t^{-3/2}. The weighted
tail loss is at most 2/(1-sigma)<=4. Therefore

\[
 N/c_\sigma\geq(1/(4\sigma)-2M-4)I=252I>0.                  \tag{15}
\]

This specimen satisfies *every* original trace hypothesis, including
the separately required N>=0. The certificate checks the exact Gram
factorization, commutator, rational inequalities, and constants in
(15). Its analytic comparison estimates are justified here.
Jacobian independently returned inertia (1,1,0) for this same V;
it did not compute N or prove the trace theorem.

### Uniform symbol positivity does not by itself imply N>=0

The same two-dimensional factor with an arbitrary added gap delta>=0
is explicitly evaluable at sigma=1/2. Put
u_0=sqrt(delta)+sqrt(delta+1) and K_0=sqrt(u_0^2-1).
The calculation in the next subsection, with t replaced by t+delta
inside R, gives

\[
 \operatorname{tr}N=K_0,\qquad
 N_{11}-N_{22}=-\pi/2+\arctan K_0.                            \tag{15a}
\]

In particular delta=1/48 gives the uniformly positive symbol with
V=diag(-11/48,37/48), and

\[
 N=\operatorname{diag}\left(
 \frac{1/\sqrt3-\pi/3}{2},
 \frac{1/\sqrt3+\pi/3}{2}\right).
\]

Its first eigenvalue is strictly negative. Thus the original N>=0
assumption is genuinely separate from uniform symbol positivity.
This does not refute either manuscript, both of which include it.
For completely exact sign bounds, pi/4 is the integral from 0 to 1
of 1/(1+x^2). The eight-term alternating polynomial has positive
remainder x^16/(1+x^2), and its integral is greater than 3/4.
Hence pi>3; the same integral is less than 1, giving pi<4.
These elementary bounds also certify the strict sign in (16).

### An exactly evaluable gapless symbol

For the same J,B, now take V=diag(-1/4,3/4), with no added gap,
and sigma=1/2. Its pole order is four, so sigma>1/4 is admissible.
Here c_sigma=1/2, q=3. With
u=sqrt(t)+sqrt(t+1) and K=sqrt(u^2-1), direct integration gives
R diagonal and

\[
 R_{11}=\frac{1+\sqrt{(t+1)/t}}K,\quad
 R_{22}=\frac{1+\sqrt{t/(t+1)}}K,\quad
 \operatorname{tr}R=2K'(t).
\]

One elementary justification of this quartic integral avoids
residue or branch assumptions. For C>0 and A+2sqrt(C)>0, substitute
s=sqrt(C)/v on the positive half-line to get I_2=sqrt(C)I_0
for the integrals of s^2 and 1 over s^4+A s^2+C on the full
line. Then y=s-sqrt(C)/s maps (0,infinity) onto R and gives
I_2+sqrt(C)I_0=2pi/sqrt(A+2sqrt(C)).
Apply this with A=2t, C=t(t+1); the off-diagonal integral is odd.

Moreover

\[
 (R_{11}-R_{22})dt=\frac{2\,du}{u\sqrt{u^2-1}} .
\]

The latter integral from u=1 to infinity equals pi. Also
2sqrt(t)-K(t) tends to zero at infinity and K(0)=0.
Consequently

\[
 N=\operatorname{diag}(-\pi/4,\pi/4),\quad
 \operatorname{tr}(NV)-\operatorname{tr}(N_+^3)
       =\frac{\pi(16-\pi^2)}{64}>0.                           \tag{16}
\]

The verifier checks the polynomial factorization, exact changes of
variables, derivatives, limits, and symbolic values in (16).
The branch conditions t>0,u>1 and the elementary integrals are
explained above, rather than inferred from floating-point agreement.
This is an example of the extension, **not a counterexample** to
either staged theorem: it lacks their uniform gap and has N not >=0.

## 14. What the certificate establishes

Run `python3 research/trace_deficit_audit/verify.py --self-test`.
The script requires SymPy; the actual run used the installed version 1.14.0.
The verifier recomputes universal ordered word identities and a
relation witness modulo inverse cancellation and cyclicity; these
apply in every finite dimension. It also checks exact rational
Gram factorizations, pole orders, scalar substitutions, the explicit
N>0 bound, and consistency of the actual Lean compiler certificate
with the unedited source and fidelity document. Mutation tests must
reject altered signs, hypotheses, pole orders, and positivity bounds.

The free-word proof is not a sample over matrices. The finitely
displayed Jordan specimens are exact examples, not a proof by
testing all dimensions. The analytic convergence, half-line,
logarithmic, and integral arguments are the proofs in Sections
4--13; the Python output explicitly leaves their independent
review outstanding. In particular reading a compiler JSON record
is not described as rerunning the Lean compiler.

No literal false manuscript assertion was found, so no artificial
F_ claim or `refutes` judgement is manufactured. The gapless
divergence examples explain why changing hypotheses needs work;
they do not refute claims with b>0.

The three source-scope assumptions in `C_TD_SCOPE` still require an
independent reader's attribution. They document what the manuscripts
claim; the mathematical verification and extension do not assume those
claims true. Likewise, novelty and publishability are not certified by
an unsuccessful web search or by the Engineer's judgements. The Host's
independent Reviewer must assess the analytic proof, statement fidelity,
source readings, and significance before campaign acceptance.
