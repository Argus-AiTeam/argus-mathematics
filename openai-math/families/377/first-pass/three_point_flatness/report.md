# Three-point flatness: exact analytical audit

## Statement and source scope

The target is Proposition `prop:three-point`, Section 02, lines 121--206
of the staged October 4, 2026 manuscript. For every fixed finite dimension
`n`, a sequence of infinity-harmonic functions on the open unit ball with
one common Lipschitz bound and uniformly vanishing distance from affine
functions must have

```
sup_{x,y in B_(1/4), x != y}
  |U_i(x) + U_i(y) - 2 U_i((x+y)/2)| / |x-y| -> 0.
```

The supremum includes all positive separations; there is no lower bound
in terms of the affine error. The operator is the unnormalized infinity
Laplacian, with nonnegative values at upper tests and nonpositive values
at lower tests, including zero-gradient tests.

At mission opening, the ledger contained only the campaign objective,
with no reviewed mathematical result or certificate. The supplied scope
identified the small-separation Hessian contraction as unresolved, not as
a proved error. The original CIL Theorem 3.2 had not yet been checked.
The AMS article page and abstract were obtained, but the attempted AMS
PDF URL returned article-page HTML, not the theorem. The arXiv record
identifies the primary source as `arxiv:math/9207212v1`; its theorem text
still requires reading. No manuscript-specific prior result was found
in the shared semantic Wiki.

The only non-elementary input needed for this proposition is the elliptic
theorem of sums, not the parabolic theorem or any gradient-regularity
theorem. The fixed-center blow-up theorem, family-flatness argument,
anisotropic compactness, and Liouville theorem are downstream or separate
obligations and are not assumed here.

The main dependency chain is: the three-point proposition and fixed-center
affine blow-ups imply family flatness; selection and cylinder comparison
give the nonaffine fitted entire limit if power decay fails; the proposed
Liouville theorem rules out that limit; power-decaying fits yield the
stated gradient estimate. Verifying the present proposition alone does
not verify that chain or the manuscript's main theorem.

## Result

The full-quantifier three-point proposition admits the analytical proof
below. In particular, its use of three superjets, including a superjet
of `-2U`, has the correct sign and scaling. Its Hessian remainder is
uniform even when the endpoint distance is arbitrarily smaller than
the affine-approximation scale.

An explicit quantitative strengthening is also obtained. In every
finite dimension, let `U` be infinity-harmonic on `B_1`, let its
Lipschitz constant be at most `L >= 0`, and let `ell` be affine with
`epsilon = ||U-ell||_infinity < infinity`. Define

\[
 D(U)=\sup_{\substack{x,y\in B_{1/4}\\x\ne y}}
 \frac{|U(x)+U(y)-2U((x+y)/2)|}{|x-y|}.
\]

Then

\[
 \boxed{D(U)\le
 \min\{L,\;4096 L^{6/7}\epsilon^{1/7}\}.}                 \tag{T}
\]

The constant and exponent here are not claimed to be sharp. This is
an analytical verification with an exact symbolic certificate, not a
numerical experiment or a Lean/kernel formalization. Literature
priority and independent Reviewer acceptance are not asserted.

## Primary-source comparison

The arXiv primary PDF was subsequently obtained and Theorem 3.2 on
printed page 17 was read; the initial AMS access failure is therefore
not a remaining source-access blocker. `CIL1992.pdf` is the primary
source, `CIL1992.txt` its text extraction, and `CIL_Theorem_3_2.txt`
records the relevant statement and scope comparison.

The original theorem concerns upper-semicontinuous functions on
locally compact Euclidean subsets and a `C^2` test on a neighborhood
of their product. It requires a local maximum relative to that
product and gives the upper matrix bound `A + eta A^2` for every
`eta > 0`, in addition to a lower bound not used here. Continuous
functions on sufficiently small product balls meet these hypotheses.
At a triple with `r=|x-y|>0`, choose the product-ball radius smaller
than `r/8` and the distance to the surrounding boundary. The whole
product then avoids `x=y`, and the test is `C^2` on a neighborhood
of it. Thus the original neighborhood hypothesis, not merely
differentiability at the maximizing point, is satisfied. There is no
parabolic jet/time-derivative hypothesis to check in this elliptic
theorem.

This is the only non-elementary external input. Its canonical
assumption is recorded on `C_TP_SUMS_377` as `CIL_3_2`. Independent
source attribution remains for the Host-invoked Reviewer. The
mission's writable paths do not include the citation tool's
`research/literature/` archive; no out-of-scope archive or
self-confirming independent attribution has been created.

## Proof of (T)

### Normalization and an explicit cutoff

The elementary bound `D(U) <= L` follows by comparing each endpoint
with its midpoint. If `L=0` or `epsilon=0`, the assertion follows
immediately. Otherwise divide `U,ell` by `L`. It suffices to treat
`Lip(U) <= 1`; at the end multiply the result by `L`.

Only affine errors `epsilon <= 1` will be needed. Write `w=U-ell`
and `q=grad ell`. Evaluating `ell` at the two points `e/2,-e/2`
for every unit vector gives `|q| <= 1+2 epsilon <= 3`. Consequently
`Lip(w) <= C=4`.

Suppose that a positive midpoint defect exceeds `delta |x-y|` for
some `0 < delta <= 1`. A negative defect is treated by replacing
`U,ell` by their negatives, which preserves every hypothesis.
Set `b=delta/2` and take `B_out=40`.

For an explicit dimension-independent cutoff, put

\[
 P(t)=10t^3-15t^4+6t^5,\qquad
 T(c)=(16|c|^2-1)/3.
\]

Let `B(c)=b` when `T(c)<=0`, let
`B(c)=b+(40-b)P(T(c))` when `0<T(c)<1`, and let `B(c)=40`
when `T(c)>=1`. This function is `C^2`, which is all the theorem
of sums requires. The manuscript's alternative choice of a smooth
cutoff also works.

Indeed, `P(0)=0`, `P(1)=1`, and both its first and second
derivatives vanish at the endpoints. On `[0,1]`,

\[
 P'(t)=30t^2(1-t)^2,\quad
 P''(t)=60t(1-t)(1-2t),\quad
 0\le P'\le15/8,\quad |P''|\le15.
\]

Thus `0<=P<=1`. On the transition annulus `|c|<=1/2`,
`|DT|<=16/3` and `||D^2T||=32/3`. The following bounds hold
in every finite dimension:

\[
 b\le B\le M_0=40,\qquad
 |DB|\le M_1=400,\qquad
 \|D^2B\|\le (40)(1340/3)<M_2=18000.                \tag{1}
\]

Also `B=b` on the closed quarter ball and `B=40` outside the
open half ball.

### A maximum at a positive, arbitrarily small separation

For `x,y,z` in the closed ball of radius `3/4`, with `x!=y`,
write

\[
 c=(x+y)/2,\quad h=z-c,\quad r=|x-y|,\quad
 f(r)=r-r^{3/2}/8,
\]
\[
 F=w(x)+w(y)-2w(z)-B(c)f(r)-|h|^2/r^2.
\]

Here `0<r<=3/2`, and with `nu=3/4` one has
`nu r <= f(r) <= r`. A violating pair in the quarter ball,
with `z=c`, makes `F>0`. For all triples,

\[
 F\le Cr+2C|h|-Bf(r)-|h|^2/r^2
   \le Cr+C^2r^2-Bf(r).                            \tag{2}
\]

In particular its upper limit as `r` decreases to zero is at
most zero, uniformly in the other variables. Compactness away
from this diagonal therefore gives an attained positive maximum
with `r>0`. No lower bound on that separation has been imposed.

At any positive maximum, `|w|<=epsilon` implies

\[
 r<\frac{4\epsilon}{b\nu}
   =\frac{32\epsilon}{3\delta}.                    \tag{3}
\]

Comparison with the admissible triple `(x,y,c)` gives

\[
 |h|^2/r^2\le2(w(c)-w(z))\le2C|h|,
 \qquad |h|\le2Cr^2.                              \tag{4}
\]

If `|c|>=1/2`, (2) is at most

\[
 r(C+\tfrac32 C^2-\nu B_{\rm out})=-2r<0.
\]

Thus `|c|<1/2`. When `r<=1/2048`, (4) makes the three points
strictly interior to the radius-`3/4` ball: the endpoints have
norm less than `1/2+r/2`, and `z` has norm less than
`1/2+8r^2`. This verifies the localization, including at the
smallest endpoint scales.

### Correct jet scaling and the order of the auxiliary limit

At an interior maximum use the test

\[
 \Psi=\ell(x)+\ell(y)-2\ell(z)+B(c)f(r)+|h|^2/r^2.
\]

Set `e=(x-y)/r` and

\[
 a=Bf'(r)-2|h|^2/r^3.
\]

Componentwise differentiation, without any restriction on dimension,
gives

\[
 p_1=D_x\Psi=q+\tfrac12 f DB-h/r^2+ae,\qquad
 p_2=D_y\Psi=q+\tfrac12 f DB-h/r^2-ae,
\]
\[
 p_0=-D_z\Psi/2=q-h/r^2.                           \tag{5}
\]

The function `-2U` is infinity-harmonic: an upper test for it,
divided by `-2`, is a lower test for `U`, and the infinity
Laplacian scales by `(-2)^3`. Continuity of the operator extends
the inequalities to the closed superjets in CIL Theorem 3.2.
Consequently the theorem, applied to `U,U,-2U`, supplies

\[
 X_1[p_1]\ge0,\quad X_2[p_2]\ge0,\quad X_3[-2p_0]\ge0,
 \quad \operatorname{diag}(X_1,X_2,X_3)\le A+\eta A^2,
\]

where `A=D^2 Psi`. The third inequality also gives
`X_3[p_0]=X_3[-2p_0]/4>=0`. Hence, for
`sigma=(p_1,p_2,p_0)`,

\[
 0\le A[\sigma]+\eta|A\sigma|^2
 \quad\hbox{for every }\eta>0,
 \qquad A[\sigma]\ge0.                             \tag{6}
\]

The maximizing triple, `A`, and `sigma` are fixed here; only the
matrices `X_j` may depend on `eta`. No convergence or boundedness
of those matrices is asserted or needed. For example, if
`A[sigma]<0`, choosing
`eta=-A[sigma]/(2(1+|A sigma|^2))` immediately contradicts (6).
This limit is taken separately at each triple, not uniformly as
`r` tends to zero.

### The complete dimension-free Hessian contraction

Let

\[
 H=h/r^2,\quad \beta=DB(c),\quad
 v=(p_1+p_2)/2=q-H+\tfrac12 f\beta,\quad
 s=\sqrt r,\quad t=1-s/8,\quad k=1-3s/16.
\]

Moving `(x,y,z)` on its straight line of velocity `sigma` gives
`dot c=v`, `dot h=-f beta/2`, and `dot r=2a`.
Since the endpoint relative velocity is exactly `2ae`, one also
has `ddot r=0`: locally the distance is `r+2a tau`, not an
approximation with an uncontrolled angular term.

For arbitrary `h,dot h,dot r`, with `ddot h=ddot r=0`,

\[
 (|h|^2/r^2)^{\ddot{\ }}
 =2|\dot h|^2/r^2-8\dot r\langle h,\dot h\rangle/r^3
       +6\dot r^2|h|^2/r^4.
\]

Substitution gives the exact identity

\[
 \begin{split}
 A[\sigma]={}&-\frac{3Ba^2}{8s}
 +4ak\langle\beta,v\rangle
 +r t D^2B[v]\\
 &+\tfrac12t^2|\beta|^2
 +8at\langle H,\beta\rangle+24a^2|H|^2.             \tag{7}
 \end{split}
\]

This is the entire quadratic form, including all localization
terms. Its derivation uses only arbitrary-coordinate differential
identities and inner products. It is not a reduction to a chosen
number of spatial dimensions.

Suppose now that `r<=delta/2048`. From (4), `|H|<=8`.
Since `f'>=5/8` on `0<r<=3/2`,

\[
 a\ge (5/8)b-8C^2r\ge\delta/4=b/2,\qquad a\le40.
\]

For `r<=1`, (1) and (5) imply

\[
 |v|\le Q+2C+M_1/2=3+8+200=211=:V.
\]

In (7), `0<t,k<=1`. Cauchy--Schwarz and (1) therefore bound
the five remaining terms above by

\[
 \begin{split}
 R={}&4M_0M_1V+M_2V^2+\tfrac12M_1^2
       +16M_0CM_1+96M_0^2C^2\\
   ={}&818443600.                                  \tag{8}
 \end{split}
\]

In particular

\[
 A[\sigma]\le-\frac{3b^3}{32\sqrt r}+R
             =-\frac{3\delta^3}{256\sqrt r}+R.      \tag{9}
\]

All constants are fixed independently of the maximizing triple,
dimension, affine slope, and endpoint-to-approximation scale
ratio. Equations (7)--(9) explicitly justify the manuscript's
`O(1)` remainder.

### An exact threshold and the final quantifiers

Let

\[
 N=R+1=818443601,\quad
 \kappa=\left(\frac3{512N}\right)^2,\quad
 E_0=\frac{3\kappa}{32}.
\]

Exact rational comparisons give `0<kappa<1/2048` and
`E_0^(-1)<=4096^7`. If

\[
 \epsilon\le E_0\delta^7,                          \tag{10}
\]

then (3) gives `r<kappa delta^6`. Since `0<delta<=1`, this
implies both the interior condition `r<1/2048` and
`r<delta/2048` needed above. Moreover
`sqrt r < 3 delta^3/(512N)`. Thus (9) implies

\[
 A[\sigma]\le -2N+R=-R-2<0,
\]

contrary to (6). A positive defect exceeding `delta r` cannot
exist under (10); applying the same argument to `-U` excludes
negative defects of that magnitude as well.

For `0<epsilon<E_0`, choose
`delta=(epsilon/E_0)^(1/7)`. For larger affine errors use the
elementary bound `D(U)<=1`. This proves, in the normalized case,

\[
 D(U)\le\min\{1,E_0^{-1/7}\epsilon^{1/7}\}
       \le\min\{1,4096\epsilon^{1/7}\}.
\]

Rescaling amplitudes proves (T). It immediately proves the
manuscript's sequential proposition for a common finite `L`,
with no condition at all on how the positive endpoint distances
compare with `epsilon_i`.

## Exact certificate and its limits

Run, from any working directory,

```
$WORKSPACE/argus-live-update/.venv/bin/python \
  research/three_point_flatness/verify.py
```

when the campaign is the working directory; otherwise use the
absolute script path. The script locates its companion data
relative to itself. It uses Python's exact rational arithmetic
and SymPy, not floating-point tolerances or random sampling.

The symbolic calculation checks (5) at an arbitrary coordinate
index, the radial and midpoint velocities, the full identity (7)
using five unrestricted inner-product scalars, the cutoff and
its derivative bounds, and exact nonnegative-factor
decompositions for every remainder bound. It checks all constants
and thresholds in (8)--(10), including the explicit constant
4096. The nonnegative factors' hypotheses are proved in the
analytical argument above, not inferred from sample values.

The isolated Jacobian adapter was discovered and its exact typed
contract inspected before custom algebra. One bounded
`quadratic_form.evaluate.compute` call evaluated the actual
scalar Hessian at `r=1/16`, `B=1`, `DB=0`, `h=q=0`, with
`sigma=(61/64,-61/64,0)`. It returned `-11163/8192`, with exit
code 0 and no error or timeout. The exact payload and full typed
output, including server version and protocol, are preserved
in dedicated JSON files. The verifier derives that diagnostic
Hessian independently and replays its exact value. This scalar
diagnostic is explicitly not the proof of the universal claim.

The program does not prove CIL Theorem 3.2, compactness of the
localization domain, Cauchy--Schwarz, or the statement fidelity
of this report in a formal kernel. Those portions are the
analytical proof and its declared standard external input.
No `.lean` source or kernel-closure claim is made. Independent
Reviewer replay, source attribution, and significance assessment
remain necessary before acceptance.

## Improvement over the initial state and remaining frontier

The initial state had no verified assertion and an unresolved
small-separation contraction. This work supplies a complete
all-separation proof, an exact dimension-free contraction,
explicit remainder and error thresholds, and the quantitative
bound (T). No false literal manuscript assertion was found in
the scoped proposition or sum-rule invocation, so no refutation
claim is manufactured.

The fixed-center blow-up argument and every downstream claim
remain unreviewed. In particular this certificate is not a
proof of family flatness, the Liouville theorem, power decay,
or the main `C^{1,alpha}` estimate. It is not a declaration
that the overall publishable counterexample campaign is complete.
