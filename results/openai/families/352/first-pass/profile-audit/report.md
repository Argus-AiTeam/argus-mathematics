# Exact verification and contraction matching for the shrinking profile

## Result and scope

This note proves a quantitative strengthening of the profile construction in
`build/sections/profile.tex` of the staged September 24, 2026 manuscript.
All decimals below are rationals. The numerical part is reproducible with
standard-library Python and assertions enabled:

```
$WORKSPACE/argus-live-update/.venv/bin/python -B research/profile-audit/verify.py
```

The verifier neither imports nor executes the manuscript's programs. Its
Taylor update is obtained by polynomial convolution in the multiplied ODE,
and its tangent update uses the algebra of first-order dual numbers. The
[exact certificate](exact_certificate.json) records inequalities, not
floating-point approximations.
The infinite-dimensional and asymptotic arguments below are mathematical
proofs, not claims that a Python program or Lean kernel checked analysis.

**Theorem.** Put \(R=5\cdot10^{-10}\), \(S_0=56\),
\(B=751/4\), \(C=-1215/4\), and
\[
 (k,d)^t=(-.094617116666041,.400682721856639)^t+Az,\qquad
 A=10^{-8}\begin{pmatrix}25190&-63731\\721855&359157\end{pmatrix},
 \qquad z\in Z=[-R,R]^2.
\]
Consider
\[
 E_d(p)=p'''+30s^{-1}p''+Bs^{-2}p'
                  +Cs^{-3}(p-d)+p/(1+p)=0.                 \tag{1}
\]
For every \(z\in Z\), its origin germ
\(p=d+ks^{3/2}+O(s^3)\) continues positively to \(s=56\).
In the manuscript's exact real/nonreal coordinates relative to the
four-term polynomial \(p_a\),
\[
 |q_{\rm shot}|\le .25R,\qquad
 \|(\Re\xi_{\rm shot},\Im\xi_{\rm shot})-z\|_\infty\le .13R. \tag{2}
\]
For every allowed \(d\) and \(|q|\le .26R\) there is a unique tail source
in the ball \(\|j\|_\infty\le .3R\) of the Green construction below.
Exactly one \(z\in Z\) matches its shot to such a constructed tail.
The matching self-map has Lipschitz constant less than \(.37\), and its
image is contained in \([-.38R,.38R]^2\). Its iterates from \(z_0=0\)
converge to the matching parameter \(z_\infty\), with
\[
 \|z_n-z_\infty\|_\infty\le .38(.37)^nR.                    \tag{3}
\]
The resulting \(c=(1+d)^{-1}\) and
\[
 G(y)=c(1+p(s)),\qquad s=(27/16)^{1/3}(y/c)^{2/3}
\]
satisfy every assertion of Theorem `prof:profile`, including the
differentiated expansion at every finite order and the flat flow equation.

Uniqueness in this theorem is **only** uniqueness of the matching parameter
in the specified square for the constructed small-source tail class.
There is no assertion of uniqueness among all positive global profiles.

The strongest prior result being compared is the manuscript's Brouwer
existence argument. The new mathematical conclusion relative to that
statement is quantitative contraction matching, uniqueness in this class,
and geometric convergence (3). These are not conclusions of a bounded
search. Bibliographic priority and publishable significance remain matters
for independent review; this note does not declare `novelty_status=verified_new`.
A targeted literature lookup for this exact ODE, the endpoint 56, and
uniqueness of its two-parameter shooting square did not locate an exact
prior uniqueness result. General Calabi-flow metric uniqueness and general
validated-ODE methods are not that result. A negative web lookup is not
proof of priority, and no theorem suggested by that lookup is an input.
In particular, this is not a proof of the compact Calabi-flow singularity:
`flat:inverse`, `glue:solution`, and `geo:obstruction` remain separate
unresolved claims in the proof graph.

## Classical inputs and what is not assumed

The following standard analytic results are used with their usual finite-
dimensional hypotheses, not as statements about an unspecified ODE:

* Picard existence and uniqueness on an open regular domain, smooth
  dependence and the variational equation, and continuation when the time-
  state graph remains in a compact subset of that domain.
* The holomorphic counterpart, including holomorphic dependence on finitely
  many parameters.
* Cauchy's coefficient estimate on a circle lying in the holomorphic domain,
  completeness of the indicated spaces of continuous functions or
  absolutely summable coefficients, contraction iteration, and Gronwall's
  integral inequality.

The primary ODE source actually opened is Gerald Teschl, *Ordinary
Differential Equations and Dynamical Systems*, author preliminary version
April 2012, ISBN 9780821883280:
[author's download](https://www.mat.univie.ac.at/~gerald/ftp/book-ode/ode.pdf).
The relevant locators are Theorems 2.2, 2.10, 2.11, 2.13, Lemma 2.14,
Theorems 4.1--4.2, Theorem 2.1, and Lemma 2.7. The downloaded PDF and
searchable text are in `literature/teschl-ode.*`.
For example, the fixed-point hypothesis is exactly:

> Let C be a (nonempty) closed subset of a Banach space X and let K : C
> [to] C be a contraction

and the analytic hypothesis is:

> Suppose f : [Omega] [times] [Lambda] [to] C is analytic.

Brackets transliterate symbols in the PDF, not additional hypotheses.
The analytic statements in that source are written for a scalar unknown.
Their extension here to a finite-dimensional system follows from the same
Picard proof: on a sufficiently small closed complex disk and a closed
state polydisc, the integral operator preserves the polydisc and has norm
Lipschitz constant \(L\rho<1\). Its iterates are holomorphic and converge
uniformly. The same estimate on a slightly smaller polydisc is uniform in
the initial data and parameters, giving joint holomorphic dependence.
This supplies, rather than silently assumes from a scalar citation, the
system version used below.

The primary Cauchy source actually opened is NIST DLMF **version 1.2.8,
2026-09-15**, [1.9.30--1.9.31](https://dlmf.nist.gov/1.9#E30);
the fetched page is `literature/dlmf-1.9.html`. It assumes continuity on and
inside a simple closed contour and analyticity inside, with the evaluation
point inside. On a circle of radius \(r\), its formula
\[
 f^{(n)}(0)=\frac{n!}{2\pi i}\int_{|w|=r}f(w)w^{-n-1}\,dw
\]
gives \(|[w^n]f|\le \sup_{|w|=r}|f(w)|r^{-n}\).
Applying this successively in the parameter variables gives the
polydisc estimates used below.

For clarity, contraction iteration itself needs no numerical assumption:
if \(T\) preserves a closed subset of a complete space and has constant
\(L<1\), then consecutive iterates differ by at most
\(L^n\|Tx-x\|\); the geometric series makes them Cauchy, and continuity
gives the unique fixed point. Gronwall follows by multiplying the integral
majorant by the integrating factor for its nonnegative coefficient.
For complex radial paths this argument applies to the absolute-value
majorant parametrized by real arc length.

No imported validated-ODE theorem, no unproved assertion from the supplied
verification scripts, and no finite sampling assertion is an assumption
of this proof. Pointwise shooting samples or running the authors' programs
alone cannot prove the full-square assertion (2); that route is excluded
on logical grounds, not reported as a numerical counterexample.
All cited sources have been read by the Engineer; their independent
attribution and the theorem's significance are still for the Host-invoked
Reviewer. No independent approval is being claimed.

## 1. Origin family and its full remainder

Let \(r=s^{3/2}\). Multiplication of (1) by \(s^3\) and the Euler
identities give
\[
 Q(r\partial_r)(p-d)=\frac8{27}r^2((1+p)^{-1}-1),
 \quad Q(D)=(D-1)(D+9)(D+10).
\]
Thus \(p=d+kr+\sum_{i\ge2}a_ir^i\), where
\[
 a_i=\frac{[r^{i-2}]((1+p)^{-1}-1)}
                 {(27/8)(i-1)(i+9)(i+10)}.                \tag{4}
\]
This follows coefficient by coefficient; the free coefficients really
are \(d,k\). In the coefficient algebra with norm
\(\sum|b_i|3^i\), take the ball \(\|a\|\le .2\).
On \(|k-k_0|,|d-d_0|\le .1\),
\[
 3|k|<.585,\quad |1+d|>1.30,\quad
 \|kr+a\|<.785,\quad \|(1+d+kr+a)^{-1}\|<2.
\]
Every nonfree denominator in (4) exceeds 440.
Its map has image norm at most \(27/440<.2\) and contraction
constant at most \(36/440<1\).
Uniform iteration, also on a small neighborhood of the closed polydisc,
proves holomorphic dependence and
\(3|k|+\|a\|<.8\). Coefficient induction gives uniqueness of the
analytic germ, not merely uniqueness inside the auxiliary ball.

At \(s=1\), the three term weights are
\(1,3i/2,(3i/2)(3i/2-1)\).
The latter two divided by \(3^i\) are at most \(1/2,2/3\).
The three jet functions have modulus less than 2 on the parameter
polydisc. For real parameters, the nonconstant part at \(0\le r\le1\)
has absolute value at most \(.8r/3\), proving positivity there.

The independent recurrence computes degrees 0 through 60, as elements of
the dual algebra carrying both \(z\)-variations. The omitted jet tail is
at most
\[
 E_{60}=.8(3\cdot61/2)^2\,3^{-61}<5.267\cdot10^{-26}.
\]
This uses the weighted coefficient norm and the decreasing maximum
weight, not an unjustified sum of independent coefficient bounds.
Cauchy's estimate makes either original-parameter derivative at the
center at most \(10E_{60}\). The sum of the four absolute entries
of \(A\) is \(.01169933\); hence the omitted \(z\)-derivative row
norm is at most \(.12E_{60}\).

Both normalized parameter displacements are at most \(t=.11R\).
For a jet function bounded by 2, the terms of total degree at least two
are bounded by
\[
 E_{\rm par}=2((1-t)^{-2}-1-2t)<1.816\cdot10^{-20}.
\]
There are \(n+1\) monomials of degree \(n\); this factor is included.
Combining the certified interval widths, midpoint errors, both tangent
columns, and the tails gives an initial four-state error less than
\(2\cdot10^{-19}\), with its fourth component exactly zero.
The stored fourth row of the tangent encloses the *exact rational*
\(d\)-row of \(A\); it is not replaced by a grid midpoint.

## 2. Independent recurrence and complex continuation

A grid interval \((l,u)\) means \([l/2^{256},u/2^{256}]\).
All multiplications and divisions round outwards. For negative intervals
the reciprocal is also in reversed endpoint order; it is allowed only
when the endpoints have the same strict sign. Midpoints are selected
points, never enclosures, and are charged separately.

At a step starting at \(s_c\), use \(\theta=h(s-s_c)\),
\(\mathfrak r=hs_c+\theta\), \(z=1+p\), \(E=1+d\).
The directly multiplied equation is
\[
 \mathfrak r^3z'''+30\mathfrak r^2z''
       +B\mathfrak rz'+C(z-E)
       =h^{-3}\mathfrak r^3(z^{-1}-1).                    \tag{5}
\]
Primes in (5) are \(\theta\)-derivatives.
Write \(\mathfrak r=(r_8+8\theta)/8\).
The verifier constructs the coefficients of
\((r_8+8\theta)^3\), \(8(r_8+8\theta)^2\),
and \(64(r_8+8\theta)\) by the binomial formula.
After multiplication by 2048, the coefficient of \(\theta^n\)
in (5) isolates
\(4r_8^3(n+1)(n+2)(n+3)z_{n+3}\).
All other terms are ordinary finite convolutions. This is the
`taylor_step` recurrence; it does not call the supplied `evolve`.

The reciprocal update is the identity \(zb=1\) in the dual algebra
\((x,\dot x)(y,\dot y)=(xy,x\dot y+\dot xy)\).
In particular the constant coefficient is differentiated too.
Induction proves that each computed interval encloses the actual Taylor
coefficient of the reference trajectory or its first variation.
Degrees through 46 suffice for degree 44 of every twice-differentiated
component.

The exact run checks at every one of the 2304 starts
\[
 -.76<p(0)<.4,\quad |p_\theta(0)|<.06,\quad
 |p_{\theta\theta}(0)|<.01,\quad hs_c\ge32,
\]
and modulus below 6 for every entry of the actual propagated scaled
variation. Its constant fourth row is \((0,0,0,1)\).
There is one identity initialization **per block**, not per substep.

Here is the analytic enclosure needed to make the coefficient statement
an endpoint enclosure. Bootstrap \(|p(\theta)-p(0)|\le .1\)
in a disk of radius at most \(1/2\). There
\[
 |\mathfrak r|\ge31.5,\quad |1+p|>.14,\quad |p|<.86,
 \quad |p-d_0|<1.3.
\]
If \(H_2\) is the supremum of \(|p_{\theta\theta}|\) on a smaller
disk, radial integration and Gronwall give
\[
 H_2\le e^{.477}\left[.01+\tfrac12\{
 .190(.06+H_2/2)+.011(1.3)+.015625(.86/.14)\}\right].
\]
The coefficient of \(H_2\) is less than one and the solved bound is
\(H_2<.123602<.13\).
Consequently displacement is below
\(.06/2+.13/8=.04625<.1\), strictly improving the bootstrap.
The state and its first two derivatives remain bounded; (5) then bounds
the third derivative too. At any boundary point of a putative disk of
existence of radius at most \(1/2\), radial integration has a limiting
regular state. The local holomorphic system theorem extends it.
Uniform bounds give a common local radius on the compact boundary
circle; local uniqueness glues the extensions to the existing disk.
Thus the solution is holomorphic on a neighborhood of the closed disk,
not merely on real step intervals.

The maximum row norm of the scaled four-state Jacobian on that disk is
less than 2.1. Each propagated variation column therefore has norm
less than \(6e^{1.05}<17.146<32\); the state entries are also below 32.
Cauchy's formula at radius \(1/2\), evaluated at \(\theta=1/8\), gives
for every state and tangent component the tail allowance
\[
 32\sum_{n\ge45}4^{-n}=(128/3)4^{-45}<48\,4^{-45}.         \tag{6}
\]
This estimate is applied to each derivative component as a holomorphic
function; differentiating a value-tail bound would not justify (6).
All exponential upper bounds in the code are rational Taylor sums of
degree 80, with their positive tails bounded geometrically by the next
term divided by \(1-x/82\).

On the real substep, displacement is at most
\(.06/8+.13/128=.008515625<.01\).
The minimum of the starting lower bounds for \(1+p\), minus a grid
upper bound for .01, is therefore a lower bound \(m_j\) on the
whole reference block.

## 3. Physical transfers and uniform propagation

There are 32 blocks of length \(1/32\) on \([1,2]\), 32 of
length \(1/16\) on \([2,4]\), 32 of length \(1/8\) on \([4,8]\),
and 192 of length \(1/4\) on \([8,56]\).
Every block has eight substeps. With
\(S_j=\operatorname{diag}(1,\ell_j,\ell_j^2,1)\), its physical
transfer is \(S_j^{-1}TS_j\), not the scaled transfer \(T\).
The width checks are made **after** this conjugation:
the physical state widths are below \(10^{-19}\) and the physical
transfer entry widths are below \(10^{-15}\).
Hence the reference jumps are below \(10^{-19}\), and each transfer
entry differs from its selected midpoint by less than \(10^{-15}\).
All fourth-component errors vanish.

For selected transfers \(\widetilde M_j\) put
\(\widetilde T_{i,j}=\widetilde M_{i-1}\cdots\widetilde M_j\).
The independent run checks **every** ordered endpoint pair. It proves
\[
 m_j>.23,\quad \|Z_0\|<.02,\quad
 \|\widetilde T_{i,j}\|\le8500,\quad
 \sum_{j<i}\|\widetilde T_{i,j+1}^{(3)}\|\le570000,
\]
\[
 \sum_{j<i}\ell_jm_j^{-3}
           \|\widetilde T_{i,j+1}^{(3)}\|\le246000,\qquad
 \|\widetilde T_{i,0}Z_0\|\le2.7.                          \tag{7}
\]
Here \(Z_0\) denotes the initial tangent, not the parameter square.
The weighted summand is rounded upwards, including its dimensions:
if \(D\) is the grid integer bounding the leading-block norm and
\(r_j=2^{256}m_j\), its bound is
\(\lceil D\,2^{512}/(h_jr_j^3)\rceil\).
The reverse inner loop accumulates the summand *before* multiplying by
\(\widetilde M_j\), so the index is \(j+1\), as required.

For exact transfers, expansion by error positions gives
\[
 \|T_{i,j}-\widetilde T_{i,j}\|
 \le8500((1+8500(4\cdot10^{-15}))^{288}-1)<.001.
\]
Every intervening approximate subproduct, even an empty one, is bounded
by 8500; no exponential of a large individual matrix norm is used.
The resulting exact bounds are \(8501\), \(580000\), \(250000\),
and \(2.72\) for the corresponding quantities in (7).
The weighted sum uses \(\sum\ell_j=55\), rather than 288.

Between ordered interior points of a single block the scaled real
Jacobian has norm at most
\[
 30/32+B/32^2+2|C|/32^3+(1/64)/.23^2.
\]
Its exponential over a block is below 4.3.
Conjugation by \(S_j\) can enlarge the full physical norm, so no such
bound on that full norm is asserted. It does not enlarge either the
first-row norm or the maximum norm of the third column: their scaling
factors are respectively
\((1,\ell_j,\ell_j^2,1)\) and
\((\ell_j^2,\ell_j,1,\ell_j^2)\).
These two partial bounds, both at most 4.3, are precisely what follows.

For an actual shot let \(\delta=p-p_{\rm ref}\) on a block.
The exact nonlinear remainder in its third equation is
\[
 N_{\rm ref}(\delta)
       =\frac{\delta^2}{(1+p_{\rm ref})^2(1+p_{\rm ref}+\delta)}.
\]
Under \(|\delta|\le14R\), it has absolute value at most
\(1.001(14R)^2/m_j^3\).
Duhamel's formula, the zero fourth component of errors, and (7) bound
the endpoint error relative to \(T_{i,0}Z_0z\) by
\[
 580000\,10^{-19}+8501(2\,10^{-19})
            +4.3(250000)(1.001)(14R)^2
       =.1055747504R<.11R.                                \tag{8}
\]
The first-row interior bound is
\[
 4.3(2.72+.11)R+
           4.3(1.001)(14R)^2/.23^3<12.169035R<14R.
\]
The bootstrap starts at \(s=1\) and improves strictly at endpoints,
at new reference starts, and in interiors. Also
\(1+p\ge .23-14R>0\). On a bounded time interval, (1) is a linear
system for \(p',p''\) with bounded coefficients and bounded forcing
once \(p\) obeys this bound; Gronwall prevents derivative escape.
This proves existence and positivity for **every** parameter in the
square. It is not inference from sampled trajectories.

## 4. Exact coordinates, tail polynomial, and projection

Write
\[
 D_*(\lambda)=\lambda^3+(15/56)\lambda^2+
                 (B/(2\cdot56^2))\lambda+1+C/(2\cdot56^3).
\]
Its derivative is positive on the real axis because
\((15/56)^2-3B/(2\cdot56^2)=-453/25088<0\).
Exact rational sign evaluations enclose its real root in
\((-1.08659,-1.08655)\).
Put \(\lambda_0=-r\), \(\lambda_1=u+iv\) with \(v>0\).
Vieta gives \(u=(r-15/56)/2\),
\(u^2+v^2=(1+C/(2\cdot56^3))/r\).
Interval arithmetic proves
\[
 .40933<u<.40938,\quad .8671<v<.86721,\quad
 |\lambda_1|<.959,\quad E=(r+u)^2+v^2>2.9895>1.729^2.
\]
The projection rows are obtained by solving the Vandermonde system:
the complex row for root \(i\) is
\((\lambda_j\lambda_k,-\lambda_j-\lambda_k,1)/D_*'(\lambda_i)\).
Taking its real and imaginary parts gives the exact \(\Gamma\).
The code encloses these explicit expressions, proving
\[
 |\Gamma_{ab}-\Lambda_{ab}|<.001,\quad
 \|\Gamma_q\|_1<.92,\quad
 \|\Gamma_{\Re\xi}\|_1,\|\Gamma_{\Im\xi}\|_1<.68.
\]
It also verifies the convolution constants
\(M_0<1.96,M_1<1.92,M_2<1.88\) and
\((u|D_*'(\lambda_1)|)^{-1}<.82\).
Indeed \(D_*'(-r)=E\) and
\(|D_*'(u+iv)|=2v\sqrt E\).

The four coefficients
\[
 a=Cd,\quad b=a^2+567a,\quad
 c_3=2ab-a^3+(2025/4)b,
\]
\[
 c_4=b^2+2ac_3-3a^2b+a^4+(567/2)c_3
\]
give \(p_a=\sum_{j=1}^4d_js^{-3j}\).
The verifier checks cancellation through degree four as identities in
\(\mathbb Q[d]\), not at finitely many \(d\).
On the wider interval \([.40068272185,.40068272187]\), exact intervals
prove coefficient bounds
\((122,54200,12500000,5100000000)\) and \(d\)-derivative bounds
\((304,100000,65000000,100000000000)\).
These imply
\[
 \|P_a(d)-P_a(d_0)\|_\infty\le .01|d-d_0|.                \tag{9}
\]

The independent endpoint computation, with
\(Y=(\widetilde T_{288,0}Z_0)_{\mathrm{top}\,3}\), proves
\[
 \|U_{288}-P_a(d_0)\|_\infty<.04R,\quad
 \|\Lambda(U_{288}-P_a(d_0))\|_\infty<.006R,
\]
\[
 \|(\Lambda Y)_q\|_1<.116,\quad
 \|(\Lambda Y)_{\rm nonreal}-I_2\|<.001.
 \tag{10}
\]
The \(d\)-row of \(A\) has norm less than .011.
Applying (8)--(10), the projection error .003, and the row bounds gives
respectively
\[
 .006+.003(.04)+.116+.003(2.7)
       +.92(.11+.001(.02)+.01(.011))=.2315396<.25,
\]
\[
 .006+.003(.04)+.001+.003(2.7)
       +.68(.11+.001(.02)+.01(.011))=.0901084<.13.
\]
This proves (2) with room to spare.

## 5. Half-line construction

The four term bounds at \(s=56\) are
\[
 b_*=(.00070,1.8\cdot10^{-6},8.1\cdot10^{-9},3.2\cdot10^{-11}).
\]
Writing \(T=\sum b_{*,j}\), the parts above degree four in the
second, third, and fourth powers have sums
\[
 T^2-b_1^2-2b_1b_2-2b_1b_3-b_2^2,\quad
 T^3-b_1^3-3b_1^2b_2,\quad T^4-b_1^4.
\]
They are below \(8\cdot10^{-14},2\cdot10^{-14},3\cdot10^{-15}\).
Higher powers are at most \(.001^5/(1-.001)\).
The remaining differential term is bounded by
\((243/4)b_4/56^3\).
Thus \(\|e_a\|_\infty=\|E_d(p_a)\|_\infty<3\cdot10^{-13}\).
Every absolute monomial decreases for \(s\ge56\); this proves the
whole-half-line estimate. The residual and each derivative tend to zero.

Let \(v_i=(1,\lambda_i,\lambda_i^2)^t\),
\(\beta_i=1/D_*'(\lambda_i)\). For bounded real continuous \(j\), set
\[
 {\cal V}(s)=q e^{\lambda_0(s-56)}v_0
 +\beta_0v_0\int_{56}^s e^{\lambda_0(s-u)}j(u)\,du
 -\sum_{i=1}^2\beta_iv_i\int_s^\infty
                           e^{\lambda_i(s-u)}j(u)\,du.    \tag{11}
\]
The partial fraction identities
\(\sum\beta_i=\sum\lambda_i\beta_i=0\),
\(\sum\lambda_i^2\beta_i=1\) show that its entries are
\((V,V',V'')\), with \(D_*(\partial_s)V=j\).
All integrals converge absolutely. Boundedness rules out arbitrary
growing homogeneous modes; (11) is the unique bounded solution with
stable coordinate \(q\) at 56. This is a linear Green representation,
not an assumed nonlinear stable-manifold theorem.

For \(i=0,1,2\),
\(\|V^{(i)}\|_\infty\le|\lambda_0|^i|q|+M_i\|j\|_\infty\).
Consequently \(\|V\|_\infty\le .848R\) in the stated \(q,j\) balls,
and \(|p_a+V|<.001\).
For \(N(p)=p^2/(1+p)\), \(|N'(p)|<.0021\) on this range.
This last full-interval inequality was also checked by the authorized
Jacobian operation `polynomial.box.enclosure.compute`, server 0.14.0,
protocol 2025-11-25. For \(0\le x\le.001\) it enclosed
\[
 .0021(1-x)^2-(2x+x^2)
       \ \in\ [948021/10^{10},21/10000]\subset(0,\infty).
\]
Since \(|N'(p)|\le(2|p|+|p|^2)/(1-|p|)^2\), this proves exactly the
needed uniform assertion. The exact payload and typed output are kept in
`jacobian_payload.json` and `jacobian_result.json`, and the standalone
verifier replays their enclosure without trusting the server.
The adapter returned exit 0 with a complete typed output; no timeout,
transport failure, or unknown result is counted as evidence.

Equation (1) for \(p=p_a+V\) is equivalent to
\[
 j=-e_a-(30/s-15/56)V''
       -(B/s^2-B/(2\cdot56^2))V'
       -(C/s^3-C/(2\cdot56^3))V+N(p_a+V)-N(p_a).
                                                               \tag{12}
\]
The coefficient differences are bounded on the *entire* half-line by
\(15/56,B/(2\cdot56^2),|C|/(2\cdot56^3)\).
The source contraction constant is below
\[
 (15/56)(1.88)+(B/(2\cdot56^2))(1.92)
       +( |C|/(2\cdot56^3)+.0021)(1.96)<.57.
\]
The coefficient of the stable homogeneous term is below .36.
The right side of (12) is bounded by
\[
 3\cdot10^{-13}+.36(.26R)+.57(.3R)=.2652R<.3R.
\]
Contraction iteration gives its unique source in this ball. The resulting
solution is smooth by (1), and its nonreal coordinate obeys
\(|\xi_{\rm tail}|<.82(.3R)=.246R<.25R\).
Iteration from zero stays in the closed subspace of functions tending
to zero: the exponential convolution operators preserve that subspace
and \(e_a\to0\). Hence \(p,p',p''\to0\).
Uniform contraction estimates also prove continuous dependence on \(q,d\).

## 6. Two-shot estimate and the new contraction matching

This section is the strengthening beyond the manuscript's existence
argument. It does not assume differentiability estimates for a merely
bounded shooting error.

Let \(z,w\in Z\), and let \(D=\|z-w\|_\infty>0\).
The two-shot initial residual after subtracting \(Z_0(z-w)\) has
Lipschitz constant below \(10^{-9}\).
To see this, write the holomorphic origin jet in normalized parameters.
For each degree \(n\ge2\), the row-sum Lipschitz bound on the square is
at most \(2n(n+1)(.11)^nR^{n-1}\).
Summing gives
\[
 .44((1-.11R)^{-3}-1).
\]
Add the first-variation tail \(.12E_{60}\), the two midpoint errors
bounded by \(10^{-20}\), and three grid units. The verifier checks the
total is below \(10^{-9}\). State midpoint constants cancel when
subtracting the shots. The exact \(d\)-row has zero residual.

For a fixed reference block set \(a=1+p_{\rm ref}\ge m_j\).
On \(|x|\le14R\),
\[
 N_{\rm ref}'(x)=\frac{x(2a+x)}{a^2(a+x)^2},\qquad
 |N_{\rm ref}'(x)|\le
   \frac{2.01(14R)}{m_j^3},                              \tag{13}
\]
because \((2+\eta)/(1-\eta)^2<2.01\) for
\(\eta=14R/.23\).
The real interval between the two perturbations stays in this range,
so (13) bounds their nonlinear forcing difference.

Bootstrap \(|p_z-p_w|\le13D\) at all reached interior points.
Reference jumps now cancel. Duhamel and the exact sums from section 3
bound the endpoint residual relative to \(T_{i,0}Z_0(z-w)\) by
\[
 ED,\qquad
 E=8501(10^{-9})+
          4.3(250000)(2.01)(14R)(13)<.197.
\]
The interior estimate, in units of \(D\), is
\[
 4.3(2.72+E)+4.3(2.01)(14R)(13)/.23^3<13.              \tag{14}
\]
It starts from the origin Lipschitz bound and improves strictly.
Thus the bootstrap proves (13)--(14) for every pair of shots, including
points in different substeps. No derivative is inferred from a \(C^0\)
error bound.

Projecting this difference by the same exact \(\Gamma\), subtracting
the identity in the nonreal rows, and using (9) yields
\[
 \operatorname{Lip}(q_{\rm shot})
  \le .116+.003(2.7)+.92(.197+.001(.02)+.01(.011))<.31,
\]
\[
 \operatorname{Lip}(\xi_{\rm shot}^{\mathbb R}-{\rm id})
  \le .001+.003(2.7)+.68(.197+.001(.02)+.01(.011))<.15.   \tag{15}
\]
The latter norm is the maximum norm of the pair, not the complex modulus.

For the tail's \(d\)-dependence put
\[
 A_i=\sum_{j=1}^4
    (\text{bound on }|\partial_dd_j|)
       (3j)(3j+1)\cdots(3j+i-1)56^{-3j-i},
\]
with the empty product one. Then
\[
 \|\partial_de_a\|_\infty
 \le A_3+(30/56)A_2+(B/56^2)A_1+
           (|C|/56^3)(1+A_0)+A_0/.999^2<.004,
 \qquad A_0<.001735.
\]
Since \(|N''(p)|\le2/.999^3<2.01\), the \(d\)-coefficient
in (12), with \(q,j\) fixed, is less than
\(.004+2.01(.848R)(.001735)<.005\).
For two tail fixed points, therefore,
\[
 \|j_1-j_2\|_\infty
       \le\frac{.36|q_1-q_2|+.005|d_1-d_2|}{1-.57}.
\]
The stable homogeneous mode contributes nothing to the initial nonreal
coordinate in (11). Hence the composite tail coordinate, as a function
of the shooting parameter, is Lipschitz at most
\[
 L_{\rm tail}
   =\frac{.82(.36(.31)+.005(.011))}{.43}.
\]

Define \({\cal B}(z)=z-\xi_{\rm shot}^{\mathbb R}(z)
                         +\xi_{\rm tail}^{\mathbb R}(q_{\rm shot}(z),d(z))\).
By (2) and the tail coordinate bound it maps \(Z\) into \(.38Z\).
By (15),
\[
 \operatorname{Lip}({\cal B})\le .15+L_{\rm tail}<.37.   \tag{16}
\]
The closed square is complete, so it has a unique fixed point. This
proves the exact existence and class-restricted uniqueness assertion.
At that point \(d,q,\xi,\bar\xi\) agree, so the Vandermonde basis
identifies all three physical jet entries. Ordinary uniqueness glues
the two solutions. Equation (3) follows from (16) and
\(z_\infty\in .38Z\).

## 7. All differentiated asymptotics

This step is infinite, analytic, and independent of the finite
arithmetic certificate; checking four coefficients would not prove it.
The matched solution has \(p,p',p''\to0\) and stays away from \(-1\).
Solving (1) for \(p'''\) and differentiating inductively proves that all
derivatives of \(p\) are bounded on a late half-line.

Formal substitution in \(t=s^{-3}\) determines coefficients \(d_j\)
uniquely at every order: the coefficient of the new \(d_jt^j\)
in \(p/(1+p)\) is one, while the other contributions use earlier
coefficients. The source at first order is \(-Cd\,t\).
No convergence of the formal infinite series is claimed.
For \(p_J=\sum_{j=1}^Jd_js^{-3j}\), including \(p_0=0\),
its exact finite residual satisfies, with \(N=3(J+1)\),
\[
 e_J^{(\ell)}=O(s^{-N-\ell})\quad(\ell\ge0);
\]
this follows by analyticity of the finite rational expression at \(t=0\).

Set \(W=p-p_J\). The exact divided difference yields
\[
 W'''+W=-e_J-a_2W''-a_1W'-a_0W,
\]
\[
 a_2=30/s,\quad a_1=B/s^2,\quad
 a_0=C/s^3+((1+p)(1+p_J))^{-1}-1.
\]
Their sum of absolute values tends to zero, and all their derivatives
are bounded on a sufficiently late half-line.
The Green construction for \(\partial_s^3+1\), with roots
\(-1,(1\pm i\sqrt3)/2\), gives a bounded operator \(K_S\) from a source
to its three-entry jet with norm at most \(5/3\).
In the weighted source norm \(\|j\|_N=\sup_{s\ge S}s^N|j(s)|\),
it has norm at most 2 when \(S\ge2N\):
for \(S\le u\le s\),
\((s/u)^N\le e^{N(s-u)/S}\), so the forward decay rate is at least
\(1/2\); the two backward rates are already \(1/2\).
The three integral bounds sum to \(2/3+2/3+2/3=2\).

Choose \(S\ge2N\) so late that
\(2\sup_{s\ge S}\sum|a_i|<1\).
Let \(H\) be the stable homogeneous jet whose stable coordinate at \(S\)
equals that of the *actual* remainder.
The source equation
\[
 j=-e_J-\sum_{i=0}^2a_i(H_i+(K_Sj)_i)
\]
is a contraction both in the bounded norm and in the weight-\(N\) norm.
The weighted solution is bounded, so bounded-space uniqueness identifies
the two. The actual jet is bounded, as is \(W'''+W\).
Variation of constants forces its growing-mode integrals to start at
infinity, giving exactly the representation \(H+K_Sj\).
It is therefore the weighted solution. This is the necessary
identification: boundedness alone would not have implied the desired
polynomial weight.

It follows that \(W,W',W''=O(s^{-N})\).
The differential equation and repeated differentiation give
\(W^{(\ell)}=O(s^{-N})\) for every fixed \(\ell\).
For the desired extra derivative decay apply this last conclusion to
a deeper truncation \(K\ge J+\ell\), and write
\[
 (p-p_J)^{(\ell)}
   =(p-p_K)^{(\ell)}
      +\sum_{j=J+1}^Kd_j(s^{-3j})^{(\ell)}
   =O(s^{-3(J+1)-\ell}).
\]
The starting half-line and constants may depend on \(J,\ell\), as
the theorem permits. This proves the quantified all-order assertion.

## 8. Returning to the profile and flat flow

Since \(s^{-3}=(16/27)c^2y^{-2}\), the chain rule gives the claimed
expansion for \(G\), with
\(g_j=c\,d_j((16/27)c^2)^j\).
More explicitly, a \(y\)-derivative of order \(\ell\) of a remainder
is a finite sum of \(s^m y^{-\ell}\partial_s^m\) terms; the estimates
just proved give exactly \(y^{-2(J+1)-\ell}\).
Taking sufficiently deep truncations also proves that every derivative
of \(u\mapsto G(u^{-1/2})\) has its Taylor limit at \(u=0\), hence a
smooth one-sided extension.

At the other endpoint \(r=\sqrt{27}\,y/(4c)\), so analyticity in \(r\)
is analyticity in \(y\), \(G(0)=c(1+d)=1\), and
\(G'(0)=k\sqrt{27}/4<0\).
The finite positive interval and the uniform positive tail prove that
\(G\) is bounded above and bounded away from zero globally.
Multiplication of (1) by \(s^3\) reverses the Euler calculation in
section 1, giving
\[
 Q(y\partial_y)(G-1)=\tfrac12y^2(1/G-1/c).
\]

For completeness, write \(D=y\partial_y\),
\(P(D)=(D-2)Q(D)\), \(h=(G-1)/y\).
Application of \(D-2\) to the last equation gives
\(P(D)(G-1)=-y^2DG/(2G^2)\).
On a monomial the flat operator identity is
\[
 x(x\partial_x^2+12\partial_x)^2[x^{-1}(g-1)]
       =x^{-2}P(x\partial_x)(g-1).
\]
With \(g(t,x)=G(x/\sqrt{-t})\),
\(g_t=DG/(2(-t))\), and these identities imply
\(F_t+(1+xF)^2(x\partial_x^2+12\partial_x)^2F=0\).
Here \(F=(-t)^{-1/2}h(x/\sqrt{-t})\).
The identity holds first for \(x>0\); smoothness of
\(h(y)=\int_0^1G'(\tau y)\,d\tau\) extends it to \(x=0\).

## Evidence boundary

The independently implemented exact verifier checks the continuum
certificate's finite arithmetic, not a sample grid of parameters.
The analytic proof above explains why those finite inequalities imply
uniform continuation, matching, and the infinite asymptotic statement.
No false literal manuscript assertion has been established in this
scope; there is therefore no refutation claim to register.
No Lean source has been created: the load-bearing obligations here are
analytic ODE enclosures and weighted infinite-dimensional arguments, not
an isolated delicate algebraic identity usefully resolved by a routine
formalization.

The independent Reviewer must replay the verifier and assess this proof,
statement fidelity, the classical source attributions, and the
significance/novelty of the quantitative strengthening. Neither this note
nor the exact certificate substitutes an Engineer judgement for that
review.

The full independent run completed with exit 0; its initial durable run
took 29.6 seconds. After adding explicit binding of the replayed Jacobian
polynomial to its typed source, a fresh complete replay against the
persisted certificate also returned exit 0. An optimized (`-O`) invocation
was explicitly refused with exit 1, as required. These observations are
execution results, not independent review or a novelty determination.
