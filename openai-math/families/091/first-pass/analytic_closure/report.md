# Analytic closure of the soft-slab variance proposition

## Result, dependencies, and scope

This report proves `M_MOMENT`, `M_DENSITY`, and then `M_VARIANCE`, with
the literal hypotheses of `moment.tex`, `density.tex`, and
`reduction.tex`, Proposition `prop:variance`. It uses the already
independently reviewed `C_TENSOR`; it neither rebuilds its certificate
nor supplies a new review of it. The prior tensor result controlled
compact double divergences. The improvement here is the justification
of the global change of variables, the exact range closure, and the
extension to every centered even \(L^2\) test.

The conclusion is a mathematical proof using the five explicitly
recorded classical analytic inputs below. It is **not** a
computer-checked proof of elliptic regularity or of the limiting and
Hilbert-space arguments. `verify.py` checks the indicated algebra and
separately labelled finite exact diagnostics. Independent mathematical
review and independent citation attribution remain Host-owned.

No false mathematical assertion or invalid theorem invocation has
been established. In particular, changed numbering in a mutable
lecture-note PDF does not refute an unretrieved historical version.
There is no `F_` claim to manufacture. External originality,
publishability, geometric reduction, measure transfer, and completion
of the whole campaign are not asserted here.

### The precise variance theorem

Let \(n\ge2\), \(N\ge1\), \(\epsilon>0\), and let \(q\ge2\) be an
even integer. For arbitrary nonzero \(p_i\in\mathbb R^n\) and
\(h_i>0\), set

\[
 \psi_i(x)=\left(\frac{p_i\cdot x}{h_i}\right)^q,\qquad
 V(x)=\frac{\epsilon}{2}|x|^2+\sum_i\psi_i(x),\qquad
 d\mu=Z^{-1}e^{-V(x)}\,dx.
\]

Then, for **every** \(b\in\mathbb R^N\),

\[
 \operatorname{Var}_\mu\!\left(\sum_i b_i\psi_i\right)
 \le \sum_i b_i^2\,\mathbb E_\mu\psi_i.                 \tag{V}
\]

No spanning or independence assumption is imposed on the \(p_i\).
In particular, repeated or oppositely oriented vectors, singular
summand Hessians, and the case \(q=2\) are included. No bound uniform
as \(\epsilon\downarrow0\) is used or claimed.

## 1. Imported propositions and their exact use

The assumptions have been recorded through `math_state assume`,
under the Engineer identity, before using them in the proof. A bounded
source-reader task inspected the five primary PDFs. Local source
copies and selected extracted pages are in `sources/`; see
`sources/reading.md` for locators and qualifications. This lookup
does not substitute for the Host Reviewer's citation attribution.

| Ledger assumption | Precisely used input |
|---|---|
| `M_MOMENT/A_BB_BALL` | Berman--Berndtsson, DOI `10.5802/afst.1386`, Theorem 1.1 and its preceding setup, p. 651: a convex body containing zero and an **ambient positive smooth** density with barycentre zero admit a smooth convex whole-space solution of the moment equation, with gradient a diffeomorphism onto the body's interior, unique up to translation of its argument. |
| `M_MOMENT/A_KL_CAP` | Klartag, `arxiv:1309.2767v1`, Proposition 3.1, its proof, and Remark 3.5, (48): for a bounded smooth positively curved support, smooth bounded \(\rho\) with all derivatives bounded and \(D^2\rho\ge\epsilon I\), the whole-space moment potential has \(D^2\varphi\le4\epsilon^{-1}I\). The derivative bounds need only be finite separately for each truncation. |
| `M_MOMENT/A_EK_REAL` | Wang, DOI `10.4310/MRL.2012.v19.n4.a16`, Corollary 2.3, p. 942: a classical solution of a globally concave uniformly elliptic **real** equation with a \(C^\alpha\) right-hand side has an interior \(C^{2,\beta}\) bound for some \(0<\beta<\alpha\). The bound also depends on \(|F(0)|\). |
| `M_MOMENT/A_SCHAUDER` | Fernandez-Real--Ros-Oton, `arxiv:2301.01564v1`, Theorem 2.20 and Corollary 2.21, printed pp. 46--47: interior **a priori** estimates for \(a_{ij}u_{ij}=f\). The approximants used here are already smooth. Their lower-order expressions are placed on the right, with independently bounded norms at each bootstrap step. |
| `M_DENSITY/A_ELLIPTIC` | Dyatlov, author-hosted lecture notes, version November 2, 2026, Definition 14.9 and Theorem 15.2, pp. 183 and 193: smooth-coefficient elliptic differential operators of arbitrary finite order have smooth distributional nullsolutions. Apply this locally. |

The last source has no immutable DOI/arXiv identifier known here, so
its full dated URL and locator are recorded as prose, honestly
`uncited` in the canonical-identifier ledger sense. The manuscript's
September 28 version and its Theorem 14.2 were not obtained. The
actually retrieved theorem suffices for the present proof.

We do not import the manuscript's Fathi or
Kolesnikov--Livshyts--Rotem attributions: the adjunction and compact
Hessian identity needed here are derived in Section 3.

## 2. Whole-space moment coordinates: `M_MOMENT`

In this section \(V\) is any smooth even function with
\(D^2V\ge\epsilon I\). Evenness gives \(\nabla V(0)=0\), so
\(V(x)\ge V(0)+\epsilon|x|^2/2\) and \(0<Z<\infty\).
Set \(C=4/\epsilon\). All constants below may depend on \(V,n,\epsilon\),
but not on the truncation radius.

### 2.1. Smooth truncated solutions and their initial tails

For \(R\ge2\), let

\[
 Z_R=\int_{B_R}e^{-V},\qquad
 d\mu_R=Z_R^{-1}{\bf1}_{B_R}e^{-V(x)}\,dx.
\]

Apply `A_BB_BALL` to \(\overline B_R\) and the ambient function
\(Z_R^{-1}e^{-V}\). It is positive and smooth on all of
\(\mathbb R^n\); its restriction has barycentre zero by evenness.
We obtain a smooth convex \(\varphi_R\), a gradient diffeomorphism
onto \(B_R\), and

\[
 \det D^2\varphi_R
   =Z_R\exp\{V(\nabla\varphi_R)-\varphi_R\}.             \tag{2.1}
\]

The right side is positive, so the Hessian is positive definite.
Changing variables in (2.1) shows, without any limiting argument,
that \(\nu_R=e^{-\varphi_R}dz\) is a probability and
\((\nabla\varphi_R)_\#\nu_R=\mu_R\).

For each fixed \(R\), \(\rho_R=V+\log Z_R\) and all its derivatives
are bounded on \(B_R\), since they extend smoothly to its compact
closure. The ball has smooth positively curved boundary, its
density is log-concave, and \(D^2\rho_R\ge\epsilon I\).
`A_KL_CAP` therefore gives

\[
                   0<D^2\varphi_R\le CI.              \tag{2.2}
\]

The number \(C\) is independent of \(R\); the other bounds entering
the regularity hypothesis need not be.

Translate the unique preimage of zero to zero. This is the unique
minimum. Reflection gives another solution for the same target;
uniqueness up to translation and equality of the minima's locations
make \(\varphi_R\) even. No additive normalization is being inferred
from translation uniqueness.

The preimages of \(\pm(R/2)e_j\) exist. Their finitely many supporting
planes imply

\[
              \varphi_R(z)\ge R|z|/(2\sqrt n)-b_R
\]

for a finite \(b_R\). Thus the source has an exponential tail for
each \(R\). Also \(|\nabla\varphi_R|\le R\).
Integrating \(\operatorname{div}(\eta_L z e^{-\varphi_R})\), where
\(\eta_L\) is a standard expanding cutoff, is legitimate. The term
\(z\cdot\nabla\eta_L\) is bounded and supported in the escaping
annulus, and the exponential tail makes
\(z\cdot\nabla\varphi_R\) integrable. Letting \(L\to\infty\) gives

\[
              \mathbb E_{\nu_R}z\cdot\nabla\varphi_R=n. \tag{2.3}
\]

### 2.2. Uniform coercivity, normalization, and tightness

Write \(m_R=\varphi_R(0)\) and \(g_R=\varphi_R-m_R\).
Then \(g_R\ge0\), and (2.2) with \(\nabla\varphi_R(0)=0\) gives

\[
        g_R(y)\le C|y|^2/2,\qquad
        |\nabla\varphi_R(y)|\le C|y|.                 \tag{2.4}
\]

For \(x=\nabla\varphi_R(z)\), the two supporting planes at \(z,-z\)
give the single inequality

\[
              g_R(y)\ge g_R(z)+|x\cdot y|-x\cdot z.
\]

All terms are integrable in \(z\): for this fixed \(R\),
\(0\le g_R(z)\le R|z|\), and the preceding tail applies.
Integrate against \(\nu_R\), use (2.3) and pushforward, and discard
the nonnegative \(\mathbb E_{\nu_R}g_R\). This yields

\[
                     g_R(y)\ge\int |x\cdot y|\,d\mu_R-n.
\]

On \(B_1\) every \(\mu_R\) has density at least
\(d_0=Z^{-1}\exp(-\max_{\overline B_1}V)>0\).
Rotational invariance of \(B_1\) gives the **same** positive number
\(c=d_0\int_{B_1}|x_1|dx\) for every \(R\). Consequently

\[
                   c|y|-n\le g_R(y)\le C|y|^2/2.      \tag{2.5}
\]

Since \(\nu_R\) is a probability,

\[
 (2\pi/C)^{n/2}
 \le e^{m_R}=\int e^{-g_R}
 \le e^n\int e^{-c|y|}dy<\infty.                     \tag{2.6}
\]

Let \(m_-\le m_R\le m_+\) be the resulting uniform bounds. In
particular,

\[
             e^{-\varphi_R(z)}
              \le e^{\,n-m_-}e^{-c|z|}.              \tag{2.7}
\]

This is a common integrable majorant, not merely a bound on each
source's tail with a radius-dependent constant.

### 2.3. Local smooth convergence without global lower ellipticity

Fix a source ball \(B_L\), enlarging it before each interior
estimate. Equations (2.4)--(2.6) bound \(\varphi_R\) and
\(\nabla\varphi_R\) uniformly there. Also \(Z_2\le Z_R\le Z\).
For example, (2.1) gives the uniform positive determinant bound

\[
 \det D^2\varphi_R(z)
 \ge d_L:=Z_2\exp\{V(0)-m_+-CL^2/2\}>0
 \quad (z\in B_L).
\]

If all Hessian eigenvalues are at most \(C\), their product is at
most \(C^{n-1}\) times any one eigenvalue. Thus

\[
            \delta_L I\le D^2\varphi_R\le CI,\qquad
            \delta_L=d_L/C^{n-1}>0                 \tag{2.8}
\]

on this ball. This is only a local lower bound.

Put \(f_R=V(\nabla\varphi_R)+\log Z_R-\varphi_R\).
It is uniformly bounded and Lipschitz on the chosen ball, because

\[
       \nabla f_R=D^2\varphi_R\,\nabla V(\nabla\varphi_R)
                       -\nabla\varphi_R
\]

and all arguments of \(V\) lie in a fixed compact target ball.

Here is the uniformly elliptic extension needed to invoke Wang
literally. For a slightly enlarged positive interval containing
\([\delta_L,C]\), continue \(1/t\) to a smooth positive
nonincreasing function with positive constant tails. Its integral,
with the appropriate additive constant, is a smooth concave
\(s:\mathbb R\to\mathbb R\) agreeing with \(\log t\) on that interval
and satisfying \(0<a\le s'\le b<\infty\).
Define \(F(Q)=\operatorname{tr}s(Q)\) on **all** real symmetric
matrices. In a diagonal eigenbasis, its first derivative has
eigenvalues \(s'(\lambda_i)\); its second derivative in direction
\(N\) is

\[
 \sum_i s''(\lambda_i)N_{ii}^2+
 2\sum_{i<j}
  \frac{s'(\lambda_i)-s'(\lambda_j)}{\lambda_i-\lambda_j}N_{ij}^2
 \le0,
\]

with continuous coincident-eigenvalue limits. This proves
concavity. For \(P\ge0\), integration of the first derivative gives
\(a\,\operatorname{tr}P\le F(Q+P)-F(Q)\le b\,\operatorname{tr}P\).
Since \(\|P\|_{\rm op}\le\operatorname{tr}P\le n\|P\|_{\rm op}\),
this has Wang's global operator-norm ellipticity convention.
The function \(F\), including \(F(0)\), is fixed for this ball,
independently of \(R\).

Thus \(F(D^2\varphi_R)=f_R\). Fix any input exponent
\(0<\alpha<1\). The Lipschitz bounds control its \(C^\alpha\) norm.
`A_EK_REAL`, after rescaling balls, gives a uniform interior
\(C^{2,\beta}\) bound for some \(0<\beta<\alpha\).
We do **not** claim preservation of the input exponent.

All \(\varphi_R\) are already smooth. For
\(w_{R,k}=\partial_k\varphi_R\), differentiating the logarithmic
equation gives

\[
 (D^2\varphi_R)^{-1}:D^2w_{R,k}
   =\nabla V(\nabla\varphi_R)\cdot\nabla w_{R,k}-w_{R,k}. \tag{2.9}
\]

By (2.8) and the \(C^{2,\beta}\) bound, the principal coefficients
and the **whole right side** are uniformly \(C^\beta\) on a
slightly smaller ball: \(\nabla w_{R,k}\) is a row of
\(D^2\varphi_R\). The a priori Theorem 2.20 in `A_SCHAUDER`
therefore bounds \(w_{R,k}\) in \(C^{2,\beta}\), hence
\(\varphi_R\) in \(C^{3,\beta}\). Now the coefficients and right
side of (2.9) have uniform \(C^{1,\beta}\) bounds. Apply the
a priori Corollary 2.21 and iterate on nested balls. This gives
uniform bounds for every derivative on every compact set.
No Schauder regularity theorem for an initially distributional
solution, and no theorem with unlisted lower-order coefficients,
is being invoked at this step.

Take \(R\to\infty\) through a sequence and a diagonal subsequence.
There is a locally smooth even limit \(\varphi\), satisfying (2.8)
on each fixed ball, \(0<D^2\varphi\le CI\), and

\[
             \log\det D^2\varphi
                =V(\nabla\varphi)+\log Z-\varphi.     \tag{2.10}
\]

Here \(Z_R\to Z\) by integrability of \(e^{-V}\). Also
\(\varphi(z)\ge c|z|+m_--n\).

### 2.4. Probability, pushforward, and surjectivity

Dominated convergence using (2.7) gives
\(\int e^{-\varphi}=1\). For any bounded continuous \(h\), the
same majorant and local convergence give

\[
 \int h(\nabla\varphi)e^{-\varphi}
  =\lim_R\int h(\nabla\varphi_R)e^{-\varphi_R}
  =\lim_R\int h\,d\mu_R=\int h\,d\mu.                 \tag{2.11}
\]

The final limit follows directly from \(Z_R\to Z\) and truncation
of an integrable density. Hence \((\nabla\varphi)_\#\nu=\mu\).

The positive Hessian gives a local smooth inverse. It also gives
global injectivity, since for \(z\ne w\)

\[
 (\nabla\varphi(z)-\nabla\varphi(w))\cdot(z-w)
 =\int_0^1D^2\varphi(w+t(z-w))[z-w,z-w]\,dt>0.
\]

The image is dense: an open ball disjoint from it would have zero
mass under the pushforward in (2.11), whereas \(\mu\) has a positive
density everywhere. Density and local invertibility **alone**
are not being mistaken for surjectivity.

Fix \(x_0\). Choose finitely many image points \(y_j\) within
\(1/(2\sqrt n)\) of the \(2n\) points \(x_0\pm e_i\).
For every unit vector \(v\), one coordinate has
\(|v_i|\ge1/\sqrt n\); the corresponding point then satisfies
\((y_j-x_0)\cdot v\ge1/(2\sqrt n)\).
With \(y_j=\nabla\varphi(z_j)\), the supporting planes therefore
imply

\[
 \varphi(z)-x_0\cdot z
 \ge\max_j\{(y_j-x_0)\cdot z+\varphi(z_j)-y_j\cdot z_j\}
 \ge |z|/(2\sqrt n)-b_{x_0}.
\]

This function is coercive and attains a minimum. Its gradient there
is zero, so \(\nabla\varphi=x_0\). The map is onto. Its local smooth
inverses combine with injectivity to give a global diffeomorphism.
This proves every assertion in `M_MOMENT`.

## 3. Compact adjoints and the Hessian identity

Write \(x=\nabla\varphi(z)\), \(\tau=D_z^2\varphi\),
\(M=\tau^{-1}\), using the inverse diffeomorphism for target
coordinates. The matrix \(\tau(x)\) is smooth, even, positive
definite, and bounded by \(CI\). The inverse map is odd.
Composition of a compact target test with the gradient has compact
support because its support is contained in the continuous inverse
map's image of a compact set. Thus the following adjunctions have
no boundary issue.

In source coordinates the adjoint of \(\partial_{z_k}\) is
\(\partial_k^*=x_k-\partial_k\). The chain rule and adjunction,
tested against any compact scalar function, give

\[
 \partial_k^*P_{ak}=(\delta_\mu(P\tau))_a,\qquad
 \delta_\mu W=V_jW_j-\partial_{x_j}W_j.               \tag{3.1}
\]

The test is compact, so this local identity is also valid for
smooth noncompact \(P\). Taking \(P=I\) gives the Stein identity
\(\delta_\mu\tau=x\), and hence

\[
 Af=\delta_\mu(\tau\nabla f)=x\cdot\nabla f-\tau:D^2f,\qquad
 \mathbb E hAf=\mathbb E\nabla h\cdot\tau\nabla f.     \tag{3.2}
\]

For compact smooth real \(f\), put
\(h=D_x^2f,\ P=\tau h,\ B=\tau h\tau,\ W=\delta_\mu B\), and
\(u=\delta_\mu W\). All these fields are compact. Direct
differentiation, using full symmetry of
\(C_{aik}=\partial_{z_a z_i z_k}\varphi\), gives

\[
 W_a=x_k\tau_{ai}f_{ik}-C_{aik}f_{ik}
                  -\tau_{ai}\tau_{jk}f_{ikj}
     =\partial_{z_a}[((A-1)f)(x(z))].
\]

In the last differentiation the first-gradient terms from
\(x\cdot\nabla f\) and \(-f\) cancel. Consequently

\[
       W=\tau\nabla(A-1)f,\quad u=A(A-1)f,\quad
       \mathbb E uF=\mathbb E W\cdot\nabla F
                         =\mathbb E B:D^2F          \tag{3.3}
\]

for every smooth \(F\), whether or not \(F\) is compact.
Applying these adjunctions to \(\nabla f\) gives

\[
 \|Af\|_2^2-\mathbb E fAf
  =\mathbb E\nabla f\cdot W
  =\mathbb E D^2f:B
  =\mathbb E\|\tau^{1/2}D^2f\,\tau^{1/2}\|_{\rm HS}^2. \tag{3.4}
\]

This proves, rather than assumes for this application, both compact
identities in `M_DENSITY`. It is not a statement about a
self-adjoint realization or its spectrum.

## 4. Density of the compact even range: `M_DENSITY`

Here take exactly the more general hypotheses of `lem:density`:
\(\rho>0\) is a smooth even probability density, \(\tau\) is smooth,
even, symmetric, \(0<\tau\le\Lambda I\), \(A\) has (3.2) on compact
tests, and the compact identity (3.4) holds. Let
\(\Gamma(f,h)=\nabla f\cdot\tau\nabla h\).

If one factor is compact, (3.2) remains true with the other factor
any smooth function, by inserting a cutoff which equals one near
the compact support. Thus \(\mathbb E Ak=0\) for compact \(k\).
The operator preserves parity and compact support. Its even compact
\(A(A-1)\) range therefore lies in the centered even subspace.

### 4.1. Distributional regularity

Let \(g\) be centered, even, \(L^2(\mu)\), and orthogonal to that
range. It also annihilates odd compact tests, since \(A(A-1)\)
preserves oddness. Hence it annihilates \(P f\) for every compact
test \(f\), where \(P=A(A-1)\).

The formal symmetry in (3.2) is the differential-operator identity
\(A^t(\rho h)=\rho Ah\), initially for smooth \(h\) and then for
distributions. Applying it twice gives

\[
                      P^t(\rho g)=\rho Pg=0.
\]

Smooth positivity of \(\rho\) implies \(Pg=0\) in distributions.
Its order-four principal symbol is
\((\xi\cdot\tau(x)\xi)^2\ne0\) for \(\xi\ne0\).
On each compact set \(\tau\) has a positive lower bound.
`A_ELLIPTIC`, applied locally, gives \(g\in C^\infty\).
No global ellipticity constant or operator-domain identification
has been used.

### 4.2. The necessary global \(Ag\in L^2\) estimate

Fix a smooth radial cutoff \(0\le\eta\le1\), equal to one on \(B_1\)
and zero outside \(B_2\), and set \(\eta_r(x)=\eta(x/r)\), \(r\ge1\).
There are constants \(B,K<\infty\) with

\[
  \Gamma(\eta_r)^{1/2}\le B/r,\qquad |A\eta_r|\le K.   \tag{4.1}
\]

Indeed the first follows from \(\tau\le\Lambda I\).
For the second, on the derivative support \(|x|\le2r\), so
\(|x\cdot\nabla\eta_r|\le2\|\nabla\eta\|_\infty\) and
\(|\tau:D^2\eta_r|\le n\Lambda\|D^2\eta\|_\infty/r^2\).
All derivatives and \(A\eta_r\) vanish off
\(B_{2r}\setminus B_r\). No derivative of \(\tau\) is required.

Put \(v=Ag\), which is smooth but not yet known to be \(L^2\), and

\[
 G=\|g\|_2,\qquad X_r=\|\eta_r^2v\|_2,\qquad
 Y_r^2=\mathbb E\eta_r^2\Gamma(g).
\]

If \(G=0\) the result is immediate. Otherwise all displayed
localized quantities are finite. The smooth equation \(Av=v\)
can be tested with \(\eta_r^4g\). Compact adjunction gives
\(\mathbb E v(A-1)(\eta_r^4g)=0\).
The product and chain rules give the **exact** expansion

\[
 (A-1)(\eta_r^4g)=
 \eta_r^4v+
 g(4\eta_r^3A\eta_r-12\eta_r^2\Gamma(\eta_r)-\eta_r^4)
 -8\eta_r^3\Gamma(\eta_r,g).                         \tag{4.2}
\]

Cauchy--Schwarz, (4.1), and \(0\le\eta_r\le1\) therefore give

\[
 X_r\le aG+\frac{8B}{r}Y_r,\qquad
 a=1+4K+12B^2.                                      \tag{4.3}
\]

For \(X_r=0\) this is immediate; otherwise first bound \(X_r^2\)
by \(aGX_r+(8B/r)X_rY_r\) and divide. Independently, compact
adjunction in \(\mathbb E\eta_r^2gAg\) gives

\[
 Y_r^2=\mathbb E\eta_r^2gv-
              2\mathbb E\eta_rg\Gamma(\eta_r,g)
       \le GX_r+\frac{2B}{r}GY_r.                   \tag{4.4}
\]

Combining them yields
\(Y_r^2\le aG^2+(10B/r)GY_r\). Completing the square gives, in
particular,

\[
       Y_r\le(5B+\sqrt{25B^2+a})G.
\]

Equation (4.3) now bounds \(X_r\) uniformly. Since
\(\eta_r=1\) on \(B_r\), exhaustion by balls proves
\(v=Ag\in L^2\) (and also \(\mathbb E\Gamma(g)<\infty\)).
The argument did not assume \(v\in L^2\) to obtain the bound.

We can now split, in \(L^2\),

\[
                      g=w+v,\qquad Aw=0,\quad Av=v,
                      \quad w=g-v.                 \tag{4.5}
\]

### 4.3. The harmonic part and the graph-norm approximation

Testing \(Aw=0\) with the compact function \(\eta_r^2w\) gives

\[
       \left(\mathbb E\eta_r^2\Gamma(w)\right)^{1/2}
                         \le 2B\|w\|_2/r.
\]

On a fixed ball let \(r\to\infty\). Smoothness, positivity of
\(\rho\), and positive definiteness of \(\tau\) imply
\(\nabla w=0\), so \(w\) is constant.

Similarly, testing \(Av=v\), and writing
\(Z_r^2=\mathbb E\eta_r^2\Gamma(v)\), gives

\[
                    Z_r^2\le\|v\|_2^2+
                              (2B/r)\|v\|_2Z_r .
\]

Completing the square bounds \(Z_r\) uniformly; exhaustion proves
\(\mathbb E\Gamma(v)<\infty\).

Now let \(f_r=\eta_rv\in C_c^\infty\). Directly from the product
rule,

\[
 Af_r=\eta_rv+vA\eta_r-2\Gamma(\eta_r,v).
\]

The first term tends to \(v\) in \(L^2\). The second has norm at
most \(K\|v{\bf1}_{B_{2r}\setminus B_r}\|_2\to0\).
The last has norm at most
\(2B r^{-1}(\mathbb E\Gamma(v))^{1/2}\to0\).
Also \(f_r\to v\) in \(L^2\). We have therefore proved the precise
graph-norm convergence needed here:

\[
                         f_r\to v,\qquad Af_r\to v
                         \quad\hbox{in }L^2.        \tag{4.6}
\]

Apply the **compact** Hessian identity (3.4) to these \(f_r\).
Its right side equals
\(\|Af_r\|_2^2-\mathbb E f_rAf_r\to0\).
For a fixed ball \(B_L\), \(f_r=v\) there once \(r>L\). Hence

\[
       \int_{B_L}\|\tau^{1/2}D^2v\,\tau^{1/2}\|_{\rm HS}^2\,d\mu=0.
\]

Positivity and smoothness imply \(D^2v=0\) everywhere. Thus
\(v=\alpha+\beta\cdot x\); the equation \(Av=v\) removes
\(\alpha\). Together with the constant \(w\), this proves that
**every** \(L^2\) distributional nullsolution of \(A(A-1)\) is
affine. For our even \(g\) the linear part vanishes, and centering
removes the constant. Thus \(g=0\).

The range's orthogonal complement in the centered even Hilbert
subspace is zero, so its closure is that whole subspace. This
proves `M_DENSITY`. There was no appeal to compact resolvent,
essential self-adjointness, a spectral theorem for an unconstructed
operator, or a global uniform lower Hessian bound.

## 5. Polynomial adjunction, both bounds, and duality: `M_VARIANCE`

Return to the precise slab potential. Write
\(H_i=D^2\psi_i\), \(a_i=\mathbb E\psi_i\). Since \(q\) is even,
\(\psi_i\ge0\) and

\[
 H_i=\frac{q(q-1)}{h_i^q}(p_i\cdot x)^{q-2}p_ip_i^T\ge0,\quad
 x\cdot\nabla\psi_i=q\psi_i,\quad
 H_ix=(q-1)\nabla\psi_i.                             \tag{5.1}
\]

For \(q=2\) the power in the Hessian is the constant polynomial
one, including on \(p_i\cdot x=0\).
The Gaussian term gives \(D^2V\ge\epsilon I\), \(Z\in(0,\infty)\),
and integrability of every polynomial. Every \(a_i>0\), because
\(p_i\ne0\) and the density is positive on the open complement of
its zero hyperplane. Each \(\psi_i\in L^2(\mu)\).

Section 2 supplies the moment coordinates. Section 3 verifies the
two compact hypotheses of Section 4 in these coordinates.

### 5.1. The noncompact polynomial adjunction

To extend the Stein identity from (3.2), use the compact functions
\(k_j=\eta_R\partial_j\psi_i\) in
\(\mathbb E x_jk_j=\mathbb E\tau_{jk}\partial_k k_j\), and sum:

\[
 \mathbb E\eta_R x\cdot\nabla\psi_i
 =\mathbb E\eta_R\operatorname{tr}(\tau H_i)
    +\mathbb E(\nabla\eta_R)^T\tau\nabla\psi_i .
\]

The absolute value of the last term is at most
\(C_1R^{-1}\mathbb E[|\nabla\psi_i|{\bf1}_{|x|\ge R}]\to0\),
using the upper bound on \(\tau\).
The first two terms converge by polynomial integrability and
\(\tau\le CI\). Thus

\[
                   m_i:=\mathbb E\operatorname{tr}(\tau H_i)
                       =q a_i>0.                   \tag{5.2}
\]

Only the upper bound on \(\tau\) enters this noncompact passage.

### 5.2. Two genuinely different Cauchy--Schwarz bounds

For a real even compact smooth \(f\), use the fields in (3.3).
All pairings are finite, and (3.3) with the smooth polynomial
\(\psi_i\) gives

\[
 d_i:=\mathbb E u\psi_i=\mathbb E W\cdot\nabla\psi_i
                              =\mathbb E\operatorname{tr}(BH_i).
                                                               \tag{5.3}
\]

First, in the Hilbert space of matrix fields with the integrated
Hilbert--Schmidt inner product, take
\(X=H_i^{1/2}\tau^{1/2}\) and
\(Y=H_i^{1/2}B\tau^{-1/2}\). Cyclic trace gives

\[
 \mathbb E\langle X,Y\rangle_{\rm HS}=d_i,\quad
 \mathbb E\|X\|_{\rm HS}^2=m_i,\quad
 \mathbb E\|Y\|_{\rm HS}^2=\mathbb E\operatorname{tr}(MBH_iB).
\]

The last field is compact and \(M\) is bounded on its support;
the first norm is finite by (5.2). Therefore

\[
                   d_i^2\le m_i\,\mathbb E\operatorname{tr}(MBH_iB).
                                                               \tag{5.4}
\]

Only symmetry of \(B\), not positive semidefiniteness, is used.
The positive square root of \(H_i\) need only be measurable;
no derivative or inverse of \(H_i\) is taken.

Second, (5.1)--(5.3) give

\[
 \mathbb E x^TH_ix=(q-1)m_i,\qquad
 \mathbb E x^TH_iW=(q-1)d_i.
\]

Apply Cauchy--Schwarz to \(H_i^{1/2}x\) and \(H_i^{1/2}W\).
Since \(m_i>0\) and \(q-1>0\), it yields

\[
                  \mathbb E W^TH_iW\ge(q-1)d_i^2/m_i.            \tag{5.5}
\]

This remains valid for singular \(H_i\), including its null
hyperplane and all nonspanning vector families.

### 5.3. Reviewed tensor estimate and extension

All hypotheses of the reviewed `C_TENSOR` now hold: the two
probabilities, smooth global moment diffeomorphism, positive
Hessian, and a real compact smooth test. With
\(H=D^2V=\epsilon I+\sum_iH_i\), its already certified energy
inequality, (5.4), and (5.5) give

\[
 \begin{aligned}
 \mathbb E u^2
 &\ge\mathbb E\operatorname{tr}(MBHB)+\mathbb E W^THW\\
 &\ge\sum_i\left[
       \mathbb E\operatorname{tr}(MBH_iB)+\mathbb E W^TH_iW\right]\\
 &\ge\sum_i qd_i^2/m_i
   =\sum_i d_i^2/a_i.                                \tag{5.6}
 \end{aligned}
\]

The omitted Gaussian terms are nonnegative:
\(\epsilon\operatorname{tr}(MB^2)
=\epsilon\|B M^{1/2}\|_{\rm HS}^2\) and
\(\epsilon|W|^2\). No matrices have been commuted.

By `M_DENSITY`, these \(u=A(A-1)f\) are dense in the centered
even subspace. The maps \(u\mapsto d_i(u)=\mathbb E u\psi_i\)
are continuous on \(L^2\), with norm at most \(\|\psi_i\|_2\).
There are only finitely many \(i\), and every \(a_i>0\).
Consequently (5.6) passes to **every** centered even \(L^2\) test.

For arbitrary real \(b_i\), let
\(F=\sum_i b_i\psi_i\) and \(u=F-\mathbb EF\). Then

\[
 \|u\|_2^2=\sum_i b_i d_i(u)
 \le\left(\sum_i b_i^2a_i\right)^{1/2}
      \left(\sum_i d_i(u)^2/a_i\right)^{1/2}
 \le\left(\sum_i b_i^2a_i\right)^{1/2}\|u\|_2.
\]

If \(u=0\), (V) is immediate. Otherwise divide and square.
This proves (V) with every requested quantifier and completes the
analytic proof of `M_VARIANCE`.

## 6. What the executable certificate does and does not establish

Run `python3 research/analytic_closure/verify.py` with SymPy installed.
It recomputes and compares `exact_certificate.json`, without modifying
the reviewed tensor artifacts or making network requests.

The symbolic checks verify the diffusion product and chain rules
used in (4.2), the localized energy expansions, both completed-square
eliminations, the homogeneity coefficients, the factor \(q/m_i=1/a_i\),
and the finite-index Cauchy--Schwarz orbit identity. Polynomial
homogeneity examples include even powers \(2,4,6,8\).
The separately labelled exact Gaussian \(q=2\) diagnostics include a
rank-one, nonspanning family with repeated/opposite slab directions
and mixed-sign coefficients, as well as a nonorthogonal spanning
family. These diagnostics are **not** a search over all parameters
and are **not** the proof of (V).

Uniform bounds, elliptic regularity and bootstrap, dominated
convergence, surjectivity, distributional transposition, global
energy estimates, graph-norm convergence, and Hilbert-space closure
are proved in this report and require independent mathematical
review. The script explicitly lists that limitation; a successful
run cannot close those obligations mechanically.

No new Jacobian operation fits a remaining analytic uncertainty.
The existing tensor capability finding and typed Gram-inertia
evidence are reused, not repeated or misrepresented as a certificate
of range density. No new Lean source is added: the unresolved
certification is analytic, and a formalization of an isolated scalar
identity would not settle it. The existing reviewed tensor Lean
certificate is left untouched.
