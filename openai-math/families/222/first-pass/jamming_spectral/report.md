# Exact whole-line spectral endpoint audit

**Result offered for independent review.** The two manuscript endpoint
inequalities hold. The same argument and one additional integer shoot at
each endpoint give the stronger enclosures
\[
 \boxed{\frac{2936535033}{10^{10}}<\lambda(a_-)<
             \frac{2936535034}{10^{10}}},\qquad
 \boxed{\frac{2936533047}{10^{10}}<\lambda(a_+)<
             \frac{2936533048}{10^{10}}}.
\]
Each interval has width \(10^{-10}\), twenty times smaller than the
corresponding width \(2\cdot10^{-9}\) certified in the manuscript.
This is an analytic verification theorem with exact finite premises, not a
numerical experiment alone, a Lean formalization, or a Reviewer verdict.
No claim of independently established novelty or publishability is made.

## Statement and source boundary

The target is the staged September 24, 2026 manuscript
`Microscopic-jamming-in-the-negative-spherical-perceptron-September-24-2026/build/main.tex`.
Write

\[
 a_-=\frac{2936533}{10^7},\quad a_+=\frac{2936535}{10^7},
 \quad q=\tfrac12,\quad p=q-a.
\]

The reference profile is a whole-line solution of
\[
 M''+(z+2aM)M'-(1-2a)M=0,
 \qquad -1\le M'\le0,\quad M''>0,
\]
between \(H(z)=\phi(z)-z\Phi(-z)\) and \(U(z)=\phi(z)/\Phi(z)\).
The operator in question is the Friedrichs operator
\[
 H_a=-\tfrac12\partial_z^2+\tfrac12(B_a^2+B_a'),
 \qquad B_a=z/2+aM_a.
\]
The desired assertions concern its *lowest whole-line eigenvalue*:
\(\lambda(a_-)>a_-\) and \(\lambda(a_+)<a_+\).
A finite-interval matrix spectrum or a small numerical residual is not this
statement.

The load-bearing source locations are `eq:src40` (stationary profiles and
Gaussian tails), `cert:M-error` (uniform profile and derivative errors),
`cert:tail-enclosure` (the square-integrable branch at infinity),
`cert:shooting` (inward error propagation and positive matching), and
`app:code` (integer trials and assertions). The entire printed driver also
contains contraction and quadrature calculations that are not necessary for
these two endpoint signs.

## Established scope before computation

The manuscript reports, but this audit has not assumed, a successful complete
program run. Its exact endpoint seeds are input data, not eigenvalues. The
spectral signs do not require any random-model limit, pressure formula,
feasibility repair, critical-layer contraction, or mixture universality.
Those are separate open assertions in the project ledger.

The four main manuscript assertions are registered separately: the Ising
Gaussian variational pressure formula; the spherical Gaussian variational
pressure formula; the compact-spectral-law bi-orthogonally invariant spherical
pressure formula; and microscopic criticality with small Gaussian-mixture
universality. Registering them does not verify them.

The algebraic scaling-identity route cannot select the spectral parameter.
Indeed
\[
 \gamma=1-2a,\qquad \theta=\frac{2a}{1-2a}-1
 \quad\Longrightarrow\quad \gamma=(2+\theta)^{-1}
\]
for every \(0<a<1/2\), not just for a spectral root. The jamming manuscript
itself describes earlier scaling predictions and distinguishes microscopic
selection from this identity (introduction, lines 78--105 and 279--290).
This route is recorded as non-closing rather than as evidence for either
endpoint inequality.

No relevant perceptron, Riccati, or jamming topic was found in the inherited
project Wiki index. Jacobian discovery is preserved in `jacobian_find.json`
and its server/protocol identification in `jacobian_status.json`; a matching
validated whole-line ODE/eigenvalue contract has not been established by
those search results.

The inspected `polynomial.sturm_chain.compute` contract computes a finite
polynomial Sturm chain, **not** an ODE spectrum. The inspected
`polynomial.box.enclosure.compute` contract does provide an exact image
enclosure for a rational polynomial on a box. The bounded operation selected
here is genuinely applicable to the tail-residual remainder
\[
 R(d,e,y)=2dey+e^2y^2,\quad
 |d|\le7/5,\quad |e|\le24,\quad 0\le y\le1/144.
\]
It is not substituted for spectral validation. Its exact payload, raw typed
answer and adapter status are kept in dedicated JSON files. No matching
validated differential-operator eigenvalue postcondition was found among the
returned candidates; this is a contract mismatch, not evidence against the
manuscript.

The bounded Jacobian call succeeded: version `0.14.0`, MCP protocol
`2025-11-25`, operation `polynomial.box.enclosure.compute`, adapter exit zero,
with complete typed enclosure
\[
 R(d,e,y)\in[-7/15,\,89/180]\subset(-1,1).
\]
`jacobian_output.json` retains the exact input and output; the local checker
also verifies the requisite bound by rational arithmetic without depending
on the adapter.

## A posteriori verification theorem

Here is the analytic theorem behind the finite checker. Fix a rational
\(a\in[0,.41]\), and a window \([\mu-10^{-9},\mu+10^{-9}]\). On each
half-line put \(p_+=1/2\), \(p_-=1/2-a\). Suppose throughout that window
\(-.71<c=\lambda/p_\varepsilon-1<.81\), and on the negative side
\(c>-.01\). Suppose the following finite premises hold.

1. A piecewise-polynomial \(\widetilde M\) on \([-24,24]\), with exact
   \(C^1\) joins, has spatial stationary residual below \(10^{-23}\),
   boundary hinge errors below \(10^{-23}\), and
   \(-1.01\le\widetilde M'\le.01\).
2. Continuous inward Riccati trials on \([0,20]\) start within \(D^{-1}\)
   of \(T(20)\), have spatial residual below \(10^{-20}\), and magnitude
   below \(.95\). These premises hold at the middle parameter \(\mu\) and
   at each desired matching endpoint.
3. Cellwise lower drift bounds, after subtraction of \(.002\), have
   total integral greater than \(20\), total negative contribution greater
   than \(-2\), and integral over the cells indexed \(1203,\ldots,1999\)
   greater than \(8\). The cells have width \(1/100\).
4. At two matching values \(\lambda_0<\lambda_1\) in the window, the trial
   sums at zero are respectively less than \(-6\cdot10^{-14}\) and greater
   than \(6\cdot10^{-14}\).

Then the unique whole-line reference profile exists; its stated Friedrichs
operator has lowest eigenvalue strictly between \(\lambda_0\) and
\(\lambda_1\). There is no random-model or critical-limit hypothesis in this
theorem. The proof follows. In particular, profile existence is not left as
an assumption imported from the microscopic argument.

## 1. Independent construction of the reference profile

Let
\[
 {\cal L}_a f=f''+(z+2af)f'-2pf,\qquad p=\tfrac12-a>0.
\]
We first solve on \([-R,R]\) with \(M(-R)=R,\ M(R)=0\), for \(R>0\).
Shoot from \(-R\) with initial derivative \(s\in[-1,0]\).
While \(M>0\), set \(X=z+M\) and \(Y=M'\). Direct substitution gives
\[
 X''+(z+2aM)X'-X=0.
\]
For \(-1<s<0\), initially \(X=0,\ X'=1+s>0\). Its derivative cannot
first decrease through zero: there \(X''=X>0\). Hence \(X>0,\ Y>-1\)
until the first zero of \(M\). Similarly \(Y\) can cross zero only from
negative to positive, since \(Y'=2pM>0\) when \(Y=0\).
Before that crossing \(0<M\le R\) and \(-1<Y<0\). After it, while
\(M>0\), \(M'=Y\ge0\) and
\[
 Y'\le RY+2pM
\]
on the fixed interval. Thus solutions cannot blow up before reaching
\(R\) or their first zero of \(M\).

The shot \(s=-1\) is \(M=-z\) and hits zero at \(z=0<R\); the shot
\(s=0\) turns upward immediately and stays positive. A first zero of
\(M\) is transversal: \(M=M'=0\) would, by local uniqueness, give the
identically zero solution. By continuous dependence, slopes whose first
zero is before \(R\) form an open set, and slopes whose solution is still
positive at \(R\) form another open set. If no shot first vanished at
\(R\), these would disconnect \([-1,0]\). Consequently a shot does
vanish exactly at \(R\). It has \(-1<M'<0\) throughout.

The local ODE facts used here require no special existence theorem about
perceptrons: the vector field is polynomial. On a bounded state box its
integral map is a contraction for sufficiently short time; its iterates
converge geometrically. The same Lipschitz bound and Gronwall's inequality
give continuous dependence. Successive short intervals continue a solution
as long as its state remains bounded, as proved above.

Write \(k=-M'\), \(l=1-k\), and \(B=z/2+aM\). Differentiating the ODE gives
\[
 W=M''=2pMl+Xk,\qquad W'+2BW=2akl.
\]
At \(-R\), \(W=2pR(1-k)>0\); an integrating factor therefore shows
\(W>0\) throughout the finite interval.

The required value bounds are independent of this shooting construction.
For \(H=\phi-z\Phi(-z)\), \(U=\phi/\Phi\), elementary differentiation gives
\[
 H'=-\Phi(-z),\quad H''=\phi,\quad {\cal L}_aH=2aH(1+H')\ge0,
\]
\[
 U'=-U(z+U),\qquad
 {\cal L}_aU=-2(1-a)U(1+U')<0.
\]
Here \(z+U>0\), and
\(1+U'=1-zU-U^2>0\) is the variance of a standard normal conditioned
to lie below \(z\). Thus \(-1<U'<0\). The lower barrier
\(H-H(R)\) has nonnegative residual and exactly the required boundary
values, since \(H(-R)=R+H(R)\). The upper barrier \(U\) is above both
boundary values.

For comparison, subtract any such decreasing barrier \(V\) from a
solution. The difference obeys the linear equation with drift \(z+2aM\)
and zero-order coefficient \(2aV'-2p<0\). At a positive interior maximum
or negative interior minimum the usual scalar maximum-principle
contradiction applies. Hence
\[
 H(z)-H(R)\le M_R(z)\le U(z).
\]
The ODE and \(-1<M_R'<0\) give uniform bounds for the next derivatives on
every compact set. Diagonal compactness produces a \(C^2_{\rm loc}\)
whole-line solution between \(H\) and \(U\), with nonnegative curvature.

Both \(M\) and \(X\) are strictly positive. If \(M'=0\), its global
maximum forces \(M''=0\), contrary to \(M''=2pM>0\). If \(M'=-1\),
the corresponding argument with \(X'\) contradicts \(X''=X>0\).
The equation for \(W\) then makes \(W\) strictly positive when \(a>0\).
When \(a=0\), \(W'=-zW\), and a zero would force an affine profile,
inconsistent with the value barriers.

For uniqueness, two such solutions have difference \(E\) satisfying
\[
 E''+2B_1E'-(2p-2aM_2')E=0.
\]
Their difference tends to zero at both ends. On the negative side this
uses the elementary Mills bounds
\[
 x\le U(-x)\le x+x^{-1}\quad(x>0),
\]
obtained by integrating the normal tail by parts; on the positive side
both barriers tend to zero. A nonzero difference would attain a positive
maximum or negative minimum and contradict the displayed equation.
This proves uniqueness.

Finally \(W=2pMl+Xk\) implies \(W(x)\ge xk(x)\) and
\(W(-x)\ge2pxl(-x)\). Convexity and the value barriers imply the limiting
slopes \(-1\) and \(0\). Integrating the logarithmic derivatives and then
their tail integrals gives, exactly as required,
\[
 k(x)\le e^{-x^2/2},\quad M(x)\le k(x)/x,\quad
 l(-x)\le e^{-px^2},\quad X(-x)\le l(-x)/(2px).
\]
Also \(M(z)<.8\) for \(z\ge0\), and \(X(z)<.8\) for \(z\le0\), since
both corresponding Mills bounds are at most \(U(0)=\sqrt{2/\pi}<.8\).
For completeness the checker proves the last scalar inequality using
\[
 \pi>4\sum_{j=0}^{63}\frac{(-1)^j}{2j+1}>\frac{25}{8}.
\]
The first inequality follows by integrating the finite geometric-series
lower bound for \(1/(1+t^2)\) on \([0,1]\).

## 2. Residuals really imply the profile errors

Set \(E=M-\widetilde M\) and let \(r\) be the spatial residual. Subtraction,
without linearization or discarded terms, gives
\[
 E''+2BE'-(2p-2a\widetilde M')E=-r.
\]
The zero-order damping exceeds \(.17\); the residual is below \(10^{-23}\).
At each endpoint the true hinge deviation is at most
\[
 e^{-24^2/2}/24,\qquad e^{-p24^2}/(2p\,24),
\]
respectively. Adding the certified boundary error still gives less than
\(10^{-22}\). Constant barriers \(\pm10^{-22}\) therefore give
\(\|E\|_\infty<10^{-22}\). At a cell join \(E\) is \(C^1\), and either
one-sided second derivative gives the same maximum-principle contradiction.

On either half-line, with \(F=\partial_xE(\varepsilon x)\),
\[
 F'+2\beta F=f,\quad |f|<2.1\cdot10^{-22},
 \qquad \beta=\varepsilon B(\varepsilon x).
\]
On the positive side \(\beta\ge x/2\); on the negative side
\(\beta\ge px-.34\). Thus the integral of the negative part of \(2\beta\)
is at most \(.34^2/.09<1.29\), while \(\beta\le.38\) on \([0,.1]\).
Integrating the equation twice over this last interval gives
\[
 |F(0)|\le
 \frac{2\cdot10^{-22}+\tfrac12(.1)^2e^{1.29}(2.1\cdot10^{-22})}
      {.1e^{-.076}}
 <2.4\cdot10^{-21}.
\]
The integrating-factor formula on \([0,24]\) now gives
\[
 |F(x)|\le e^{1.29}(2.4\cdot10^{-21}+24\cdot2.1\cdot10^{-22})
 <4\cdot10^{-20}.
\]
All displayed scalar inequalities are checked with rational exponential
majorants, not floating-point evaluations.

## 3. Infinite Riccati tails, not a finite-boundary substitute

For \(p_\varepsilon\), \(c,d,e,T,K\) as in the manuscript, define
\[
 {\cal R}(S)=S'-2\beta S+S^2-2(q-ak-\lambda).
\]
Replacing the coefficients by their limiting values gives the exact identity
\[
 {\cal R}_0(T)=((2c-5)e+d^2)x^{-6}+2de\,x^{-8}+e^2x^{-10}.
\]
The sided ranges for \(c\) give \(|d|<1.4,\ |e|<24,\ K<3066\).
For \(x\ge12\),
\[
 x^6|{\cal R}_0(T)|\le6.62|e|+d^2+1.
\]
The last unit covers the polynomial remainder enclosed by Jacobian above.
Perturbing by \(\pm Kx^{-7}\) contributes the leading term
\(\mp2p_\varepsilon Kx^{-6}\) and a remaining cost at most
\(.7p_\varepsilon Kx^{-6}\). The true profile's Gaussian tails give
\[
 |\beta-p_\varepsilon x|\le
 \frac{.41e^{-p_\varepsilon x^2}}{2p_\varepsilon x},\quad
 |q-ak-p_\varepsilon|\le .41e^{-p_\varepsilon x^2}.
\]
Their additional residual cost is less than \(8x^{-6}\). This holds over
the entire infinite tail: \(x^n e^{-px^2}\) is decreasing there for
\(n\le6,\ p\ge.09\), not merely at the tested point \(12\).
The strict residual margin is
\[
 1.3p_\varepsilon K-(6.62|e|+d^2+9)
   =6.38|e|+2.9d^2+30>0.
\]
Consequently \(T-Kx^{-7}\) has positive residual and \(T+Kx^{-7}\)
negative residual, the correct signs for *inward* integration.

Start at \(T(R)\), \(R>12\), and integrate inward. Comparison traps the
solution between the barriers; boundedness permits continuation to \(12\).
Compactness as \(R\to\infty\) gives a trapped branch on the full tail.
Two trapped branches have difference
\[
 \Delta'=(2\beta-S_1-S_2)\Delta,\qquad
 2\beta-S_1-S_2\ge p_\varepsilon x.
\]
Integrating inward from larger \(R\) proves uniqueness. For different
eigenvalue parameters, the same equation has the extra source
\(-2(\lambda_1-\lambda_2)\). Sending the comparison point to infinity gives
\[
 |\Delta(x)|\le
 2|\lambda_1-\lambda_2|\int_x^\infty
       e^{-\int_x^t p_\varepsilon s\,ds}\,dt
 \le\frac{2|\lambda_1-\lambda_2|}{p_\varepsilon x}.
\]
Thus the branch is continuous in the eigenvalue parameter.

The bound \(|S|<.071\) follows directly from the barriers. The derivative
bound in the original lemma is also valid here: \(d,e\) have opposite
signs, and \(|e|/(|d|x^2)<1\) when \(d\ne0\), so \(xT\) has the sign of
\(c\) and magnitude at most \(|c|<.81\). Substituting the enclosure into
the Riccati equation bounds \(|xS'+S|\) by
\[
 \frac{2|d|}{x^3}+
 \frac{4|e|+6.62|e|+d^2+9+2p_\varepsilon K
       +2.64K/x^2+K^2/x^8}{x^5}
 <.00514<.0055.
\]
The checker retains \(p_\varepsilon K=10|e|+3d^2+30\) when verifying
this inequality; treating the two factors as independent worst cases
would not be justified.

Integrating \(S=c/x+O(x^{-3})\) gives
\(P(\varepsilon x)=C x^c(1+O(x^{-2}))\), \(C>0\).
Since \(\int_0^{\varepsilon x}B=p_\varepsilon x^2/2+O(1)\),
\(\psi=e^{-\int B}P\) is square integrable. Reduction of order produces
the other branch proportional to
\(x^{-c-1}e^{p_\varepsilon x^2/2}(1+o(1))\), which is not square
integrable. This identifies the correct whole-line endpoint condition.

## 4. Inward propagation and the matching signs

For a true branch \(S\) and Riccati trial \(\widetilde S\), subtraction is
exactly
\[
 E_S'=(2\beta-2\widetilde S-E_S)E_S+f_S.
\]
For the same eigenvalue the source has absolute value below \(3\cdot10^{-19}\):
it includes \(10^{-20}\) residual,
\(2a(10^{-22})(.95)\), and \(2a(4\cdot10^{-20})\).
Comparison with the middle trial over the whole eigenvalue window adds
at most \(2\cdot10^{-9}\).

Under the bootstrap \(|E_S|\le.001\), the certified cell lower drifts
are valid: the subtraction \(.002\) covers this error and the profile
error. Any subinterval's negative drift integral exceeds \(-2\), so
every inward integrating factor is at most \(e^2\). The full factor
from \(20\) to \(0\) is less than \(e^{-20}\). For \(x<12.02\), the
cells \(j\ge1203\) contribute more than \(8\); allowing all other
negative contributions costs less than \(2\), giving a factor below
\(e^{-6}\).

The initial error, including the variation of \(T(20)\) over the
eigenvalue window, is below
\[
 3066/20^7+.6\cdot10^{-9}+D^{-1}<2.41\cdot10^{-6}.
\]
Here \(|\partial_\lambda T(20)|<.6\) is checked from its explicit
rational coefficients. Variation of constants gives the source's
global and central errors \(2.9\cdot10^{-5}\) and \(4.5\cdot10^{-7}\).
Both are strictly below the bootstrap allowance, proving continuation
of every positive branch to zero throughout the window. Continuous
dependence then persists to zero; no pole or eigenbranch jump is omitted.

For a trial compared at its *own* eigenvalue, the center error per
half-line is, more sharply,
\[
 |E_S(0)|<
 (2.41\cdot10^{-6})e^{-20}
    +20e^2(3\cdot10^{-19})<3\cdot10^{-14}.
\]
The checker proves the last inequality using only \(e^{20}>10^8\)
and \(e^2<15/2\). Thus both the source's \(10^{-10}\) allowance and
the stronger allowance used in this audit are rigorous.

The matching condition is
\[
 S_-(0)+S_+(0)=0,
\]
not their difference: \(\partial_z=-\partial_x\) on the negative side.
The source trials at \((\texttt{lam}\pm10)/10^{10}\) have mismatch
less than \(-10^{-9}\) and greater than \(10^{-9}\).
The checker additionally tests \(\texttt{lam}/10^{10}\) and
\((\texttt{lam}+1)/10^{10}\); their mismatches are less than
\(-6\cdot10^{-14}\) and greater than \(6\cdot10^{-14}\).
The total error of the two halves is strictly below \(6\cdot10^{-14}\).
The exact mismatch integers are retained in `verification.json`.
Continuity therefore supplies a positive match strictly inside each
claimed smaller interval.

## 5. The match is the Friedrichs ground state

Normalize each positive half-line \(P\) to have value one at zero. At a
match the physical derivatives agree, so the two pieces form a positive
whole-line solution of
\[
 \tfrac12P''-(BP)'=-\lambda P.
\]
The conjugation \(P=e^{\int_0^z B}\psi\) gives, with the **plus** sign,
\[
 -\tfrac12\psi''+\tfrac12(B^2+B')\psi=\lambda\psi.
\]
The tail bounds above give Gaussian decay for \(\psi,\psi'\), and
\(B'=q-ak\in[p,q]\). In particular the potential is bounded below
and grows quadratically at both ends.

There is a direct identification that requires no numerical eigenvalue
ordering. For every smooth compactly supported real \(f\), integration
by parts gives the ground-state identity
\[
 \int\left(\tfrac12|f'|^2+
        \left[\tfrac12(B^2+B')-\lambda\right]|f|^2\right)\,dz
   =\tfrac12\int \psi^2 |(f/\psi)'|^2\,dz\ge0.
\]
It extends to the closed Friedrichs quadratic form. Cutoffs of \(\psi\)
converge in that form, and their Rayleigh quotients tend to \(\lambda\);
the extra error is \(\tfrac12\int\psi^2|\chi_R'|^2\to0\).
Thus the bottom of the form is exactly \(\lambda\), attained at \(\psi\).
This excludes both an excited eigenbranch and a finite-interval
boundary artifact.

## 6. What is checked exactly, and how to replay

The certificate contains only integer seeds, fixed denominators, and claimed
rational windows. Nothing in it is accepted as an already verified
residual or eigenvalue. `verify.py` regenerates every degree-18 trial and
then independently re-expands its *physical spatial equation*.
If \(C(s)=\sum c_ns^n\), the stationary residual multiplied by \(AD D^2\)
is the integer polynomial
\[
 HN^2 AD D C''+AD D(j+s)C'
       +2A\varepsilon HN CC'-(AD-2A)DC.
\]
If \(U(t)\) is an inward trial, \(\mathsf B/(AD D)=2\widetilde\beta\),
\(\mathsf K/D=\widetilde k\), and \(\lambda=\ell/LD\), its Riccati residual
multiplied by \(LD AD D^2\) is
\[
 -HN LD AD D U'-LD\mathsf B U+LD AD U^2
       +2LD D A\mathsf K+(2\ell-LD)AD D^2.
\]
The coefficient absolute sums bound the residuals on the entire closed
unit cell. Joins, reversed coordinates, derivative bounds, all drift sums,
and matching signs are checked with integers. All other scalar constants
are checked with `Fraction`; exponential upper bounds use a positive
Taylor sum plus a geometric majorant for its tail, and lower bounds use
positive partial sums. There is no NumPy, IEEE rounding, quadrature,
random sampling, external solver, or hidden ODE library in this verifier.

Run from the campaign root:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  research/jamming_spectral/verify.py \
  --source research/openai_manuscript/Microscopic-jamming-in-the-negative-spherical-perceptron-September-24-2026/build/main.tex \
  --self-test --details
```

The `--source` option parses, but never executes, the printed listing and
checks the selected seeds, normalization constants, and the final parameter
denominator. The mapping of the stated differential equations and operator
to these polynomials is the explicit mathematical derivation above, not
something that AST comparison proves. Without `--source`, the script and
`exact_certificate.json` are a standalone finite-premise replay.

Five rejection tests alter the parameter denominator, a claimed endpoint
window, an exact integer to a floating value, a stationary polynomial, and
a Riccati polynomial. Each must be rejected. These checks use explicit
exceptions, not removable Python `assert` statements. A nonzero exit is
not classified as a mathematical refutation.

## Scope, improvement, and remaining review

The strongest prior enclosure used for comparison is the manuscript's
`cert:lambda-window` and reproduction subsection, not a fabricated earlier
local theorem. The new intervals are contained in those source intervals
and are twenty times narrower. The additional upper shoots at
\((\texttt{lam}+1)/10^{10}\), together with the sharper analytic center
error, are what earn this improvement; merely rerunning the original
program would not earn it.

All specialized analytic inputs for this spectral theorem have proofs
above: stationary-profile existence and uniqueness, Gaussian tails,
residual-to-error comparison, infinite-tail Riccati selection,
uniform inward continuation, continuity in the trial eigenvalue, and
identification of the lowest Friedrichs eigenvalue. The mathematical
argument still requires independent human review; the script is not a
kernel check of real analysis. No external specialized literature theorem
is used as an undischarged assumption, and the manuscript's reported full
floating-point driver execution is not an assumption.

This work does **not** prove uniqueness in the parameter \(a\) of a root
of \(\lambda(a)=a\), nor selection of that root by the microscopic model,
the pressure formulas, feasibility repair, critical-limit existence, or
mixture universality. It neither verifies nor refutes those assertions.
There is no identified false manuscript assertion to enter as an `F_`
claim on the basis of these checks. Independent Reviewer confirmation,
significance, and novelty assessment remain outstanding; the campaign is
not declared complete by the Engineer.
