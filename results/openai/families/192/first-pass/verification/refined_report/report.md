# Exact quantitative verification of the refined reporting construction

## Result and scope

The direct proof in the staged manuscript's `01-observations.tex` and
`02-reporting.tex` is valid. No false literal assertion was found in those
sections. This is a verification, not a counterexample. Independent Reviewer
acceptance remains separate from the Engineer's conclusion.

Here is an explicit quantitative refinement of its asymptotic Gaussian
lemma. Set

\[
 m=2^{1024}+1,\quad R=\sqrt{8\log m},\quad h=m^{-3/2},\qquad
 a_i=1-R+\frac{2Ri}{m-1}\quad(0\le i<m).
\]

Take the closed intervals \(I_i=[a_i-h,a_i+h]\). For \(|u|\le R\),
select a center nearest to \(1+u\), breaking ties toward the smaller
index; outside that range select the middle center \(1\). With the
manuscript's \(p_*=\prod_i\beta_i\), \(S=\sum_i s_i^2\),
\(b=\sum_i\mu_i-1\), and \(J\), the following strict bounds hold:

\[
 \beta_i>2^{-11143},\quad p_*>2^{-11143m}>0,\quad
 S<2^{-2048},\quad
 J<\frac{3576000}{2^{124}}+\frac{4704}{2^{2560}}<2^{-101}.
\]

Consequently
\[
 \Delta_b=p_*(1+S-J)>(1-2^{-101})p_*>\tfrac34p_*.
\]

In particular a fixed positive **rational** margin
\(\eta_0=2^{-11143m-1}\) suffices for the finite-input amplification.
Every real \(C>0\) therefore has the original signed Boolean conclusion.
No numerical integration, random sampling, or infinite-parameter
construction is needed.

The staged manuscript already proves the qualitative all-\(C\) result.
The improvement here is an explicit finite width, explicit rigorous error
budget and rational gain, together with a separately compiled universal
cancellation core. This is not a claim that the Boolean theorem itself is
new. A targeted literature search found the original preprint and comparator
documentation, but did not establish priority for this quantitative
refinement. The shared Wiki index supplied no relevant Boolean-reporting
result or retired mathematical route. Search-generated claims of a complete
Lean formalization were not treated as evidence: inspection of the primary
`openai/math/lean/ComparatorChallenges/SquareRootDegree.lean` found that
its `main` theorem ends in `sorry`. This is a comparator statement, not an
independently checked proof. Novelty and publishable significance remain for
independent assessment; no `verified_new` status is asserted.

## 1. Pointwise cell decomposition, with no generic-position condition

Let \(u,z_0,\ldots,z_{m-1}\) be any inputs, let \(i=\iota(u)\), and let
\(q_j=\mathbf1_{I_j}(z_j)\). Write
\[
 B=\{\text{all tests pass}\},\quad
 P=\{\text{all tests except the selected one pass}\},\quad A=P\setminus B.
\]
The selector is total, so exactly one of its index indicators is one.
Also \(B\subseteq P\), on every input, and hence
\[
 \mathbf1_A=\sum_{i=0}^{m-1}\mathbf1_{\{\iota(u)=i\}}
                   \prod_{j\ne i}q_j-\prod_jq_j.                 \tag{1}
\]
The term indexed by \(i\) omits \(z_i\); the subtracted term omits \(u\).
Thus (1) is a sum of functions of at most \(m\) coordinates, even though
the sum itself can depend on all \(m+1\) coordinates.

An attained \(B\)-label fixes just all \(m\) leaf values; those values
already satisfy every test, so no additional condition is imposed on \(u\).
An attained \(P^c\)-label fixes \(u\), its selected index, and the other
\(m-1\) leaf values. At least one of these fixed leaves fails its test.
Therefore \(P^c\) is forced whatever the selected leaf is, and the cell
indicator depends on only those \(m\) reported coordinates. Unattained
labels have zero indicator.

These are identities on arbitrary alphabets and arbitrary tests, including
overlapping or degenerate intervals. Finite alphabets are needed only to
make the report finite-valued and its cell expansions finite. Endpoint
atoms, selector ties and score collisions do not change the argument.
When numerical scores coincide, their score-cell indicator is the finite
sum of the original disjoint label indicators.

For finite observations on disjoint sign blocks, any function of \(k\)
observations with cell bounds \(D_1,\ldots,D_k\) has Fourier degree at most
\(\sum D_i\): expand in their value indicators and multiply. Fourier
characters multiply by symmetric difference, whose cardinality is at most
the sum of the cardinalities. Applied to each cylinder above, the new cell
degree bound is \(mMD\), not \((m+1)MD\).

## 2. Predictor identity for different marginal distributions

Assume all inputs are independent, centered and variance one; they need
not have the same law. Put \(L=u+\sum_jz_j\). The reported-information
predictor is
\[
 q(W)=
 \begin{cases}
 b&A,\\
 \sum_jz_j&B,\\
 u+\sum_{j\ne\iota(u)}z_j&P^c.
 \end{cases}
\]
On \(B\), the error is the unrestricted independent input \(u\), so its
squared-error contribution is \(\mathbb P(B)\). On
\(E_i=P^c\cap\{\iota(u)=i\}\), the event depends only on the inputs
other than \(z_i\). Independence and unit variance give
\(\mathbb E[\mathbf1_{E_i}z_i^2]=\mathbb P(E_i)\).
There is no conditioning of the omitted variable on its own test.
The three tags partition the whole input space, so
\[
 \mathbb E(L-q(W))^2
 =\mathbb P(A^c)+\mathbb E[\mathbf1_A(L-b)^2]=1-\Delta_b.       \tag{2}
\]

By the square-integrable conditional-expectation projection theorem
(Durrett, Theorem 4.1.15), the optimal predictor has no larger error.
Orthogonality gives
\(\operatorname{Var}(\mathbb E[L\mid W])
 =\operatorname{Var}(L)-\mathbb E(L-\mathbb E[L\mid W])^2\).
Since \(\operatorname{Var}(L)=m+1\), (2) proves
\[
 \operatorname{Var}(\mathbb E[L\mid W])\ge m+\Delta_b.          \tag{3}
\]
All predictors are square-integrable, since each is constant or a
subsum of finitely many square-integrable inputs.

## 3. Gaussian subtraction: both signs and the shift

Now all inputs are independent standard normals. Every interval has
strictly positive length and a strictly positive density on it, hence
\(0<\beta_i<1\). Conditional on its interval, leaf \(i\) has mean
\(\mu_i\) and variance \(s_i^2\).

For fixed \(u=t\) and \(i=\iota(t)\), conditioning on \(P\) leaves
\(z_i\) unrestricted. Its probability is \(p_*/\beta_i\).
The conditional mean and variance of \(L-b\) are respectively
\(1+t-\mu_i\) and \(1+\sum_{j\ne i}s_j^2\). Thus
\[
 \mathbb E[\mathbf1_P(1-(L-b)^2)]=-p_*J,\qquad
 J=\int\left((1+t-\mu_{\iota(t)})^2+
            \sum_{j\ne\iota(t)}s_j^2\right)
                    \frac{\phi(t)}{\beta_{\iota(t)}}\,dt.     \tag{4}
\]
On \(B\), the center remains unrestricted and the conditional mean of
\(L-b\) is \(1\), not \(0\). Its conditional variance is \(1+S\).
Therefore
\[
 \mathbb E[\mathbf1_B(1-(L-b)^2)]=-p_*(1+S).
\]
Subtracting this negative quantity from (4) proves
\[
 \Delta_b=p_*(1+S-J).                                      \tag{5}
\]
In particular the positive \(1\) is not a sign mistake: it is the
squared conditional mean on \(B\). The independent Jacobian operation
retained here checks one affine Gaussian second-moment instance of this
calculation; it does not calculate truncated-normal moments or the
integral \(J\).

## 4. Explicit analytic bounds, including rare-event reciprocals

For a variable supported in \([a-h,a+h]\),
\(|\mu-a|\le h\). Also
\(\operatorname{Var}(Z)\le\mathbb E(Z-a)^2\le h^2\).
Consequently
\[
 s_i^2\le h^2,\quad S\le mh^2=m^{-2},\quad
 \beta_i\ge\frac{2h}{\sqrt{2\pi}}
           \exp\left(-\frac{(|a_i|+h)^2}{2}\right).           \tag{6}
\]
The reciprocal probabilities cannot be discarded; they are included
explicitly in the following estimates.

Elementary constants suffice: \(2<e<4\), \(1/2<\log2<1\), and
\(\pi<4\). For example, the exponential series gives \(e>2\);
bounding \(n!\ge2\cdot3^{n-2}\) for \(n\ge2\) gives
\(e\le 1+1+1/2+1/4<4\). Taking logarithms and square roots gives
the stated bounds on \(\log2\). The unit disk is strictly contained
in its area-four square, giving \(\pi<4\).

Our fixed \(m\) satisfies \(2^{1024}<m<2^{1025}\), so
\[
 1<R<96,\qquad \sqrt m>2^{512},\qquad h<1/m,\qquad h>2^{-1538}. \tag{7}
\]
For the upper bound on \(R\), use \(8\log m<8\cdot1025<96^2\);
the lower bound follows already from \(m>2\) and \(\log2>1/2\).
For the last inequality, \(m^3<2^{3075}<2^{3076}\).

### Central part

For \(|t|\le R\), nearest-center selection gives
\[
 |1+t-\mu_{\iota(t)}|\le R/(m-1)+h,\qquad
 |a_{\iota(t)}|+h\le |t|+1+R/(m-1)+h<|t|+2.
\]
Here \(R/(m-1)+h<96/(m-1)+1/m<1\); no asymptotic
qualification remains. From (6),
\(\phi(t)/\beta_{\iota(t)}\le e^{2R+2}/(2h)\).
Integration over length \(2R\) therefore gives
\[
 J_{\rm central}\le\frac{R e^{2R+2}}h
       ((R/(m-1)+h)^2+mh^2).
\]
Since \(m-1\ge m/2\), the parenthesis is less than
\(((2R+1)^2+1)/m^2<37250/m^2\). Using (7) and \(e<4\),
\[
 J_{\rm central}
 <\frac{96\cdot37250\,e^{194}}{\sqrt m}
 <\frac{3576000\cdot2^{388}}{2^{512}}
 =\frac{3576000}{2^{124}}<2^{-102}.                         \tag{8}
\]

### Tail part

The selected interval is now the middle interval, centered at \(1\).
It is contained in \([0,2]\), so its probability is at least
\(2h\phi(2)\). Also
\[
 (1+t-\mu_{\rm middle})^2+\sum_{j\ne\rm middle}s_j^2
 \le 2t^2+2h^2+mh^2\le3(1+t^2).
\]
For \(R>0\), integration by parts and the elementary Mills bound give
\[
 \int_{|t|>R}(1+t^2)\phi(t)\,dt
 =2(R\phi(R)+2\overline\Phi(R))
 \le2\phi(R)(R+2/R).
\]
Indeed \(\overline\Phi(R)\le R^{-1}\int_R^\infty t\phi(t)\,dt
=\phi(R)/R\); the boundary term \(t\phi(t)\) vanishes at infinity.
It follows that
\[
 J_{\rm tail}\le3e^2 h^{-1}(R+2/R)e^{-R^2/2}
 <4704m^{-5/2}<4704/2^{2560}<2^{-102},                      \tag{9}
\]
where \(e^{-R^2/2}=m^{-4}\), \(h^{-1}=m^{3/2}\),
\(R+2/R<98\), and \(e^2<16\).
Equations (8)-(9) prove the exact budget in the result.
The strict rational comparison is replayed by Python and by Lean.

### A uniform positive lower bound for the event

Every \(|a_i|+h<98\). Using (6), (7),
\((2\pi)^{-1/2}>1/3\), and \(e^{4802}<4^{4802}\),
\[
 \beta_i>\frac23\,2^{-1538}2^{-9604}
          =\frac23\,2^{-11142}>2^{-11143}.
\]
There are a fixed finite number \(m\) of factors, proving the bound
on \(p_*\). There is no need to expand the astronomically large
denominator of this rational lower bound in a computer file.
Equations (5), (8), and (9) give the strict positive deficit.
Writing \(p_A=\mathbb P(A)\), positivity also implies \(p_A>0\), and
\[
 \Delta_b=p_A(1-\operatorname{Var}(L\mid A)
                   -(\mathbb E[L\mid A]-b)^2)>0,
\]
so \(\operatorname{Var}(L\mid A)<1\).

## 5. Transfer under precisely the stated moment assumptions

Fix the parameters above once and for all, including \(b\).
For fixed \(r=m+1\), independent copies of \(Z_n\Rightarrow G\)
converge jointly to independent standard normals. One elementary
justification is to factor the joint distribution functions, whose
Gaussian limiting factors are continuous.

For any measurable \(g\) with Gaussian-null discontinuities and
\(|g(z)|\le K(1+\sum z_i^2)\), clip its values to \([-T,T]\).
The clipped function has no new discontinuities outside those of \(g\).
Durrett's Theorem 3.10.1(i),(vi) gives convergence of its expectations.
The inequality
\[
 \mathbb E|g(\mathbf Z_n)|^2
 \le K^2(r+1)(1+\sum_i\mathbb EZ_{n,i}^4)
\]
is bounded uniformly in \(n\). Hence its first-moment clipping error
is at most this bound divided by \(T\). The analogous Gaussian error
also tends to zero. First let \(n\) tend to infinity and then \(T\)
tend to infinity. This proves transfer without supposing convergence
of conditional laws or exchanging an uncontrolled conditional variance.
It also proves the needed uniform-integrability instance directly
(consistent with Durrett's Theorem 4.6.2).

For our \(g=\mathbf1_A(1-(L-b)^2)\),
\[
 |g|\le1+2b^2+2r\sum_i z_i^2.
\]
The exceptional event's boundary is contained in the finitely many
coordinate hyperplanes at interval endpoints, selector midpoints,
and \(\pm R\). These have Gaussian measure zero. Discrete approximants
may put mass on those hyperplanes: their conventions are already
fixed, and the null-discontinuity theorem still applies.

It follows that \(\mathbb Eg(\mathbf Z_n)\to\Delta_b>3p_*/4\).
Eventually \(\mathbb Eg>p_*/2>\eta_0\). Applying (3), with no
Gaussian assumption on these finite inputs, gives retained variance
strictly greater than \(m+\eta_0\). This verifies both hypotheses
of the manuscript's amplification criterion, unconditionally.

## 6. Every amplification stage is finite; every real C is covered

Let \(F\) be a finite-valued observation on \(N\) independent signs,
let \(H_N\) be their sum, and put \(T=\mathbb E[H_N\mid F]\).
Then \(\mathbb ET=0\). Assume \(v=\mathbb ET^2>0\) and cell bound
\(D>0\). For \(M\) independent copies let
\[
 Z_M=(T_1+\cdots+T_M)/\sqrt{Mv}.
\]
It is centered and variance one. The classical iid CLT (Durrett,
Theorem 3.4.1) applies to this *fixed* law. Expansion of the fourth
power, using independence and zero means, gives
\[
 \mathbb EZ_M^4=\frac{\mathbb ET^4}{Mv^2}+3\frac{M-1}{M}.
\]
The law is finite-valued, so the right side is bounded uniformly in
\(M\). There is no assertion of a fourth-moment bound uniform over
different amplification stages.

The normalized score has cell bound \(MD\), even if some tuples give
the same score, and its actual score is \(\sqrt{Mv}Z_M\).
For \(m+1\) such disjoint blocks, the tower property (Durrett,
Theorem 4.1.13) shows that the new report has retained variance
\[
 v'=Mv\,\operatorname{Var}
       (\mathbb E[\sum_{i=0}^m Z_{M,i}\mid W])
       >Mv(m+\eta_0)
\]
for some sufficiently large **finite** \(M\). Section 1 gives
\(D'=mMD\). Therefore \(v'/D'>(1+\eta_0/m)v/D\).
All Gaussian parameters and \(\eta_0\) stay fixed.

Start with one revealed sign, with \(v=D=1\). For each finite stage,
the preceding paragraph selects a finite integer \(M\) for the current
law. If desired take the least integer after which the required strict
inequality holds for every larger integer; its set is nonempty by
transfer. Induction gives a finite observation at each finite stage,
on \(N'=(m+1)MN\) signs with a finite range and finite positive
retained variance. There is no single \(M\) asserted to work for all
stages, and no infinite iteration is performed.

For any real \(C>0\), put \(a=\eta_0/m>0\).
Bernoulli's inequality gives \((1+a)^k\ge1+ka\).
The Archimedean property supplies a finite natural \(k\) with
\(1+ka>4C^2\); for example any \(k>4C^2/a\) suffices.
After \(k\) stages choose the resulting \(F\), for which \(v/D>4C^2\).

Finally take \(M\) new independent copies and
\(f=\operatorname{sign}(\sum_{\ell=1}^M T_\ell)\), assigning \(+1\)
at zero. This is a Boolean function with degree at most \(MD\).
Conditioning on the tuple, and then using the sign identity even at
ties, gives the **signed** equality
\[
 \sum_i\widehat f(\{i\})
 =\mathbb E[fH_{MN}]
 =\mathbb E|\sum_{\ell=1}^M T_\ell|
 =\sqrt{Mv}\,\mathbb E|Z_M|.
\]
The CLT and the bounded second moments give
\(\mathbb E|Z_M|\to\sqrt{2/\pi}>1/2\).
For example the tail expectation beyond \(T\) is at most \(1/T\),
which directly justifies passing from clipped absolute values.
Since \(\pi<4\), the displayed limiting lower bound is strict.
Some finite \(M\) therefore gives
\[
 \sum_i\widehat f(\{i\})>\tfrac12\sqrt{Mv}
        >C\sqrt{MD}\ge C\sqrt{\deg f}.
\]
The sum is positive, whereas every constant Boolean function has
zero singleton coefficients. Thus \(f\) is nonconstant and the number
of signs is a positive finite integer. The conclusion is valid for
every positive real \(C\), not just an integer or a sampled set.

## 7. Exact and formal evidence: what each item proves

From the campaign root, run
`python3 research/verification/refined_report/verify.py`.
An absolute path to the script also works from any other working directory.
It recomputes and compares `exact_certificate.json`.
It uses only Python's standard library and exact rational/integer
arithmetic. The certificate contains:

- The exact rational inequalities in Sections 4 and 6.
- Exhaustive finite truth tables for cancellation at widths 1 through 8.
- Finite-alphabet cylinder diagnostics with endpoints, selector ties,
  fallback, overlapping interval boundaries and score collisions.
- Exact conditional variances and predictor errors for nonidentical,
  independent centered variance-one marginals, including degenerate tests.
- Fourth-moment and signed-readout diagnostics, including zero ties.
- An independent replay of every contraction in the bounded Jacobian
  affine-Gaussian moment output, bound to its exact payload.

The finite diagnostics are **not** proofs for all alphabets or all \(C\).
The universal statements are proved above. `Main.lean` separately proves
the arbitrary-alphabet pointwise cancellation and cylinder invariance,
ordinary-cell equivalence, the exact error-budget inequality, the
deficit algebra, and finite unbounded iteration of a positive factor.
Its exact scope is specified in `statement_fidelity.md`. In particular,
neither this report nor the ledger calls the whole analytic Boolean
theorem `closed_kernel`. The actual Lean 4.31.0 run returned `exit_code=0`,
`proof_holes=[]`, and an axiom-audit exit code of zero; only `RR_LEAN_CORE`
has earned `closed_kernel`. Its immutable compiler certificate is
`certificates/RR_LEAN_CORE-0158b1e8e02637ce.json`, paired with the current
unchanged source and statement-fidelity document.

The primary Durrett PDF, extracted text, and located statement passages
are included for independent citation attribution. The dependencies are
registered against the version-specific PDF URL and theorem locators.
The Engineer read the sources; the Host-invoked Reviewer must independently
confirm the mathematics and citations rather than inherit a self-check.
No assumption about novelty, Gaussian gain, convergence of conditional
variances, or a stage-uniform averaging count is hidden in the proof.
