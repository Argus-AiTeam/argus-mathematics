# One-interaction comparison for critical SK autocorrelations

## Scope and source findings

The model is the zero-field Ising model at inverse temperature one, with
independent rate-one heat-bath clocks at each site. Thus
`H = sum_k (X_k - t_k) D_k`, where `D_k` is the half difference,
`t_k = mu[X_k | X_{-k}]`, and `w_k = 1 - t_k^2`. The clock in this
report is exactly `T = n^(2/3)`, not the random-site-update clock.

The audited source is OpenAI, *Functional universality of critical SK
autocorrelations*, October 5, 2026, staged under
`research/openai_manuscript/Functional-universality-of-critical-SK-autocorrelations-October-5-2026/`.
The relevant propositions are:

| Source locator | Assertion to be checked |
|---|---|
| `08-comparison.tex`, `comparison-endpoint-multiplier` | The unnormalized endpoint energy multiplier is `(1-u^2)/(1+u s t_k)`. |
| `comparison-residual-identity` | `(b_1-M_1Y)(g) = T sum_{k in e} mu[w_k D_kY . s E_kg]`. |
| `source-44` | `R_e^2 <= (2T/z) Gamma_e`, for every base disorder and pair. |
| `source-45`, `source-46` | The first-feature residual is controlled by the quadratic-feature trace, including its averaged fourth power. |
| `comparison-fourth-derivative` | The fourth derivative of a compactified trace observable is bounded by the base sensitivities on a shrinking interaction interval. |
| `09-functional.tex`, `functional-spectral` | Joint Stieltjes-transform convergence implies local uniform convergence of the positive-time Laplace transforms. |

The first residual inequality has a specified constant and can be falsified
by an exact finite model. The other displayed bounds use unspecified
constants. A large finite ratio alone does not refute them; a counterexample
would need an unbounded family satisfying their quantifiers.

The inherited campaign ledger contains no earlier established result beyond
the audit objective. The shared wiki has no entry about this comparison
mechanism; the other SK entry concerns a different scalar pair-response
problem and supplies no input here.

## Inputs explicitly not verified

The Gaussian assertions in `07-trace.tex` are retained only as hypotheses:

1. `prop:trace-goe`, including `source-40`: the Gaussian first-feature
   traces converge jointly to finite Stieltjes transforms of a random
   nonnegative measure with finite integral against `(1+lambda)^(-1)`.
2. `prop:trace-second`, `source-43`: for Gaussian disorder the
   quadratic-feature trace tends to zero in probability, for every `z>0`.

No correctness claim is made here about Sections 02--07, the construction
of the edge process, the microscopic coefficient, or the randomness and
decay of its proposed limiting process. A conditional transfer theorem
must not be described as a verification of those inputs.

## Mathematical target

In addition to the symmetric variance-one sub-Gaussian class requested in
the mission, consider the Cramer class

`E J = 0`, `E J^2 = 1`, `E J^3 = 0`, and
`E exp(a |J|) < infinity` for some `a>0`.

The conditional conclusion proved below is transfer of the two-feature
resolvent limits and the resulting positive-time functional limit, with
the same clock and limiting coefficient. Independent review is still
required. A finite exact computation is evidence about its algebraic
ingredients, not a proof of this asymptotic assertion.

The important possible extension beyond the printed sign comparison is
that a unit sub-Gaussian moment-generating-function bound is not necessary:
the annealed overlap estimate only needs a local fourth-order
moment-generating-function expansion, and replacement only needs a
superpolynomially unlikely clipping event. Both must be proved under the
stated class, rather than assumed.

## 1. Conditional Cramer-class universality theorem

**Theorem.** Let `D` be a fixed real law satisfying the four Cramer-class
conditions above. Write `P_t` for iid entries with law
`(1-t) N(0,1) + t D`. Assume the two Gaussian inputs stated above.
Then, for every `z>0`,

`sup_{0<=t<=1} E_t B_n^[2](z) -> 0`.

For every finite positive collection `z_1,...,z_m`, the first-feature
trace vector under `D` converges to the same vector as under Gaussian
disorder. If the limiting Gaussian vector is represented by the random
spectral measure in the first input, then

`Law_D(A_{n,J}) -> Law(s -> integral exp(-s lambda) d nu(lambda))`

in `C_loc((0,infinity))`. The time is `n^(2/3)` in rate-one-per-site
units and the amplitude is `n^(1/3)`. There is no extra time change.

In fact, the proof is uniform over laws with shared bounds
`E exp(a|J|) <= M` and the same first three moments. Thus the same
conclusion holds for a sequence of such entry laws. Symmetry is
sufficient for the third-moment condition but is not necessary.

This is a conditional theorem, not a verification of the full
manuscript. The deterministic statements in Sections 2--4 and the static
overlap statement in Section 5 are unconditional.

## 2. Independent derivation of the one-interaction formulas

Fix any finite real base disorder, a pair `e={i,j}`, and `q=X_i X_j`.
After adding `theta` to `J_ij/sqrt(n)`, set `u=tanh(theta)`.
The new Gibbs law has density `(1+uq)/(1+u mu q)`. Work first with
the unnormalized measure `mu_u=(1+uq)mu`.

At endpoint `k`, condition on `X_{-k}` and let `s` be the other
endpoint spin. The two base conditional probabilities are
`(1+t_k)/2` and `(1-t_k)/2`. Their new total mass is
`1+u s t_k`, and their normalized signed first moment is

`t_k(u) = (t_k+us)/(1+u s t_k)`.

The polynomial identity

`(1+ust)^2 - (t+us)^2 = (1-t^2)(1-u^2)`, for `s^2=1`,

therefore gives

`(1+ust)(1-t_k(u)^2) = w_k (1-u^2)/(1+ust)`.

This proves the printed endpoint energy multiplier, including its
minus sign in the linear coefficient. At a nonendpoint the energy
multiplier is simply `1+uq`. These arguments never divide by `w_k`.

Write `M(u)=sum_{a>=0} u^a M_a` and `b(u)=b_0+u b_1`, as in the
manuscript. If `a_k=s t_k`, the endpoint multipliers have coefficients

`c_0=1`, `c_1=-a_k`, and
`c_a=(-a_k)^a-(-a_k)^(a-2)` for `a>=2`.

Their absolute values are at most one. The mass and nonendpoint
coefficients vanish beyond order one. Termwise weighted
Cauchy--Schwarz consequently proves the sharper coefficient bounds

`||M_a||_{M -> M*} <= 1` for `a>=1`,

and, for `a>=2`,

`||M_a Y||_* <= d sqrt(Gamma_e)`,
`|M_a(Y,Y)| <= d^2 Gamma_e`.

Here `Y=M^(-1)b_0`, `B=M(Y,Y)`, and `d^2=1+B`.
The bounds use the complexified energy norm when complex parameters
are introduced below; the same absolute-value estimates apply there.

Now test `MY=b_0` against `qg`. The mass and nonendpoint terms
cancel against `b_1(g)-M_1(Y,g)`. At an endpoint,

`D_k(qg)=s(g_+ + g_-)/2`,

and the energy coefficient of `M_1` is `-s t_k`. Thus

`D_k(qg)+s t_k D_kg = s[(1+t_k)g_+/2+(1-t_k)g_-/2] = s E_k g`.

It follows, with exactly the manuscript's orientation and normalization,
that

`r_1(g):=(b_1-M_1Y)(g) = T sum_{k in e} mu[w_k D_kY . s E_kg]`.  (2.1)

This is an identity for every test function, not an averaged-disorder
statement. It verifies `comparison-residual-identity`.

## 3. Residual bounds, with explicit constants

Weighted Cauchy--Schwarz in (2.1), `w_k<=1`, and conditional Jensen give

`|r_1(g)|^2 <= d^2 Gamma_e T sum_{k in e} mu[w_k |E_kg|^2]`

`<= 2T d^2 Gamma_e mu|g|^2 <= (2T/z)d^2 Gamma_e ||g||_M^2`.

Taking the dual norm proves the literal, specified-constant bound

`R_e^2 <= (2T/z) Gamma_e`.  (3.1)

Every site belongs to `n-1` pairs, so

`avg_e Gamma_e = (2/n) T E(Y)/(1+B) <= 2/n`.

In particular,

`avg_e R_e^2 <= (4/z)n^(-1/3)`.  (3.2)

The order-one coefficient estimate gives `||M_1Y||_*<=sqrt(B)`.
The elementary Hilbert-space inequality
`||x-y||^2<=2||x||^2+2||y||^2` then yields

`R_e^2 <= 2(||b_1||_*^2+B)/(1+B) <= 2+2||b_1||_*^2`.

For `S^[2]`, the squared norm of `qS^[2]` is one, hence

`R_e^2 <= 2+2/z`,
`avg_e R_e^4 <= (8/z)(1+1/z)n^(-1/3)`.  (3.3)

For `S^[1]`, use the stationary heat-bath process at this *fixed*
disorder. The Markov resolvent formula and Cauchy--Schwarz in the
finite measure `exp(-zs) ds` give

`||b_1||_*^2
 = n^(1/3) integral_0^infinity exp(-zs)
       E_mu[q(X_0)q(X_{Ts})rho(X_0,X_{Ts})] ds`

`<= n^(1/3) sqrt(B_n^[2](z)/z)`.

The last equality uses the exact Hilbert--Schmidt identity
`<XX^t/n, X'X'^t/n> = rho(X,X')^2`; the replicas here are time-separated
stationary spins, not conditionally independent equilibrium replicas.
Consequently

`R_e^2 <= 2+2n^(1/3)sqrt(B_n^[2](z)/z)`,  (3.4)

`avg_e R_e^4 <= (8/z)n^(-1/3)
                    +(8/z^(3/2))sqrt(B_n^[2](z))`.  (3.5)

These are explicit versions of `source-45` and `source-46`.
All statements in this section hold for every finite real base
disorder and `z>0`. No iid, Gaussian, or temperature-concentration
input was used.

## 4. Local fourth derivatives on the larger clipping window

The coefficient bounds make
`M^(-1/2)M(u)M^(-1/2)` invertible on a fixed complex disk, uniformly
in the base disorder and dimension. For example,
`||M^(-1/2)(M(u)-M)M^(-1/2)|| <= |u|/(1-|u|)`.
On a smaller fixed disk its inverse is bounded, so its Taylor
coefficients are bounded by `C^a`.

Let `r(u)=b(u)-M(u)Y` and `A(u)=b(u) M(u)^(-1) b(u)`.
Symmetry of the form gives the exact completion

`A(u)=2b(u)Y-M(u)(Y,Y)+r(u)M(u)^(-1)r(u)`.  (4.1)

For clarity, if `v=M(u)^(-1)b(u)`, then
`M(u)(v-Y,.)=r(u)` and the final term is
`M(u)(v-Y,v-Y)`. Thus (4.1) is a bilinear algebraic identity,
not an appeal to a variational maximum at a complex parameter.

Use the manuscript's

`h_e=|mu q|+|M_1(Y,Y)|/d^2+R_e+sqrt(Gamma_e)`.

The linear coefficient of `(A(u)-B)/d^2` is
`[M_1(Y,Y)+2r_1(Y)]/d^2`, whose absolute value is at most `C h_e`.
For `a>=2`, the direct form coefficient is bounded by `Gamma_e`,
and the residual-square coefficients by
`C^a(R_e^2+R_e sqrt(Gamma_e)+Gamma_e)`.
They are therefore bounded by `C^a h_e^2`.

The actual trace is `B(u)=A(u)/(1+u mu q)`. Accordingly
`delta(u)=(B(u)-B)/d^2` has a linear coefficient bounded by `C h_e`
and higher coefficients bounded by `C^a(h_e+h_e^2)`.
From (3.4) and `B_n^[2]<=1/z`,

`h_e <= C_z(1+n^(1/6))`.

More generally than the printed window, let `L_n=o(n^(1/3))`.
For `|theta|<=2L_n/sqrt(n)` we have
`|u|(1+h_e)=o(1)`. Summing the convergent coefficient series gives

`sup |delta|=o(1)`,
`|delta'|<=C h_e`, and
`|delta^(a)|<=C(h_e+h_e^2)` for `2<=a<=4`.

Since
`(1+B(u))^(-1)=d^(-2)(1+delta(u))^(-1)`, the chain rule gives the
fourth-derivative bound `C(h_e+h_e^4)`. Lower powers are absorbed using
`h_e^j<=h_e+h_e^4`, `1<=j<=4`. The derivatives of `tanh(theta)` are
bounded through order four, so the bound also holds for derivatives
in `theta`.

For a fixed finite collection, apply the multivariable chain rule and
replace `h_e` by the sum of its sensitivities. The bounds through
order four at any real base point are polynomial in `n`, since
`h_e^4=O(n^(2/3))`. This proves the printed
`comparison-fourth-derivative` and also the window needed here,
`L_n=(log n)^2`. Constants may depend on the fixed positive
resolvent parameters and the test, not on the disorder.

## 5. Static overlap control without unit sub-Gaussian domination

For the mixture law let `m_t(v)=E_t exp(vJ)`. The two-sided exponential
moment makes these functions and their first four derivatives bounded
uniformly in `t` on a common neighborhood of zero. The first three
moments agree with the Gaussian moments, so

`log m_t(v)=v^2/2+O(v^4)`, uniformly in `t` and for both signs of `v`.  (5.1)

This is a local expansion. There is no assertion
`m_t(v)<=exp(v^2/2)` for all `v`; that assertion would exclude many
laws in the theorem.

Let `Z` use uniform cube probability as reference, let
`N_e=binom(n,2)`, and put `rho=n^(-1)sum_i X_i X_i'`.
Independence and (5.1), with a uniform error for every cube spin, give

`exp(N_e/(2n)-C) <= E_t Z <= exp(N_e/(2n)+C)`.

The two-replica factors have arguments
`(X_iX_j+X_i'X_j')/sqrt(n)`, of absolute value at most `2/sqrt(n)`.
Their quadratic terms sum to
`N_e/n + n rho^2/2 - 1/2`. The sum of their fourth-order errors is
bounded. Hence for any event `A` determined by the overlap,

`E_t Z_A^(2)/(E_t Z)^2
 <= C E_cube[exp(n rho^2/2) 1_A]`.  (5.2)

This establishes the analogue of `comparison-annealed-pair`, including
for nonsymmetric moment-matched disorder.

Define `I(r)=((1+r)log(1+r)+(1-r)log(1-r))/2`.
The binomial Chernoff bound gives
`P_cube(rho=r)<=exp(-nI(r))`. Since
`I'(r)-r=atanh(r)-r>0` for `0<r<1`, for each `epsilon>0`

`kappa_epsilon=I(epsilon)-epsilon^2/2>0`.

The unrestricted right side of (5.2) is at most `C(n+1)`, and its
restriction to `|rho|>=epsilon` is at most
`C(n+1)exp(-n kappa_epsilon)`. Paley--Zygmund therefore yields

`P_t(Z >= (E_t Z)/2) >= c/(n+1)`.  (5.3)

Clip entries to `[-L_n,L_n]`, `L_n=(log n)^2`, and write `Z_L`
for the clipped partition function. Exponential tails give

`P_t(Z_L != Z) <= C n^2 exp(-a L_n)`,

smaller than every inverse polynomial. Changing one clipped entry
changes `log Z_L` by at most `2L_n/sqrt(n)`. The bounded-differences
inequality gives, for fixed `eta>0`,

`P_t(|log Z_L-E_t log Z_L|>eta n)
 <= 2 exp(-c eta^2 n/L_n^2)`.  (5.4)

Both exceptional probabilities are smaller than `c/(2(n+1))` for large
`n`. Intersecting the event in (5.3) with the upper concentration event
in (5.4) proves
`E_t log Z_L >= log E_t Z-eta n-log 2`.
A second use of (5.4), with an adjustment of `eta`, consequently shows

`sup_t P_t(Z < exp(-eta n) E_t Z) -> 0`.  (5.5)

For `A={|rho|>=epsilon}`, Markov's inequality and (5.2) give
`Z_A^(2) <= exp(-3 kappa_epsilon n/4)(E_t Z)^2` with probability
tending to one. Apply (5.5) with `eta=kappa_epsilon/8` and divide by
`Z^2`. This proves

`sup_t P_t(mu^tensor2(|rho|>=epsilon)
                 > exp(-kappa_epsilon n/2)) -> 0`.  (5.6)

The argument and its constants are uniform for fixed common `a,M`.

For any nonnegative, disorder-dependent `p` with `mu p<=1` and
`||p||_infinity<=C n^K`, expansion of the squared overlap gives the
exact identity

`avg_{i<j} mu[p X_iX_j]^2
 = [n mu^tensor2(p(X)p(X')rho^2)-(mu p)^2]/(n-1)`.

On the event in (5.6) its replica integral is bounded by
`epsilon^2+C^2n^(2K)exp(-kappa_epsilon n/2)`.
First send `n` to infinity and then `epsilon` to zero.
Cauchy--Schwarz proves vanishing of the average absolute weighted
correlations in probability. That average is bounded by `mu p<=1`,
so it also vanishes in expectation, uniformly in `t` and in `p`.

Only elementary moment, concentration, and entropy inequalities are
used here; no unverified Gaussian critical overlap theorem is imported.
For completeness, (5.3) is the inequality
`P(Z>=EZ/2)>= (EZ)^2/(4 EZ^2)`, obtained by splitting `EZ` and using
Cauchy--Schwarz. The concentration in (5.4) is the exponential-martingale
bound for independent coordinates: a centered random variable whose
range has length `c` has log mgf at most `v^2 c^2/8`; conditional
iteration and optimization give
`2 exp(-2r^2/sum c_e^2)`. Thus neither named inequality adds a
special spin-glass assumption.

## 6. Averaged sensitivities and replacement

Define the nonnegative, disorder-dependent function

`p_Y=(z|Y|^2+T sum_k w_k |D_kY|^2)/(1+B)`.

Its mass is `B/(1+B)<=1`. The Markov resolvent contraction gives
`||Y||_infinity<=||S||_infinity/z`, also for vector norms.
It follows that `||p_Y||_infinity<=C_z n^2` for `S^[1]` and
`<=C_z n^(5/3)` for `S^[2]`.
The endpoint coefficients derived in Section 2 give exactly

`|M_1(Y,Y)/(1+B)-mu[q p_Y]|<=2 Gamma_e`.  (6.1)

Section 5, with `p=1` and `p=p_Y`, controls the first two terms of
`h_e`. Both terms are bounded by constants, so their fourth powers
vanish in pair average as well. The other terms obey
`avg R_e<=C_z n^(-1/6)` and
`avg sqrt(Gamma_e)<=sqrt(2/n)`. Combining (3.3) and (3.5) gives a
deterministic sequence `epsilon_n->0` such that

`E_t avg_e(h_e+h_e^4)<=epsilon_n` for `S^[2]`,  (6.2)

`E_t avg_e(h_e+h_e^4)
 <=epsilon_n+C_z E_t sqrt(B_n^[2](z))` for `S^[1]`.  (6.3)

The deterministic average of `h_e+h_e^4` is bounded in both cases.
All these statements are uniform over the mixture parameter.

Let `Phi(J)` be a fixed smooth test of finitely many compactified
traces. Differentiating the finite product mixture gives exactly

`d/dt E_t Phi
 = sum_e E_{t,-e}[E_{x~D} Phi(J_{-e},x)
                       -E_{g~N(0,1)} Phi(J_{-e},g)]`.  (6.4)

Taylor-expand the single-entry function at zero through degree three.
The polynomial terms cancel because the first three moments match.
Independently draw a completed entry `J_e^0` from the full mixture.
On `|x|,|J_e^0|<=L_n`, every Taylor-segment point differs from this
base by at most `2L_n/sqrt(n)` in interaction units. Section 4
therefore bounds the remainder by

`C_F |x|^4 n^(-2) [h_e(J^0)+h_e(J^0)^4]`.  (6.5)

Here `h_e` denotes the sum of the finitely many sensitivities.
The fourth-moment factor is independent of the completed base.
On the complement, the real-base polynomial derivative bounds and
boundedness of `Phi` bound the remainder by
`C n^C(1+|x|^4)`. Uniform exponential tail moments make its contribution
smaller than every inverse polynomial, including after the `O(n^2)`
sum. The same holds for a bad independent completion.

Summing (6.5) in (6.4) proves

`|d/dt E_t Phi|
 <= C_F E_t avg_e(h_e+h_e^4)+o(1)`.  (6.6)

The argument is derived directly from Taylor's formula; it does not
assume an external replacement theorem with mismatched hypotheses.

First use only quadratic-feature traces. Equation (6.2) makes (6.6)
vanish uniformly. For one trace, use `F(v)=1-v`.
The Gaussian quadratic input and `B_n^[2]<=1/z` imply

`sup_t E_t[B_n^[2]/(1+B_n^[2])] -> 0`.

Since `b <= (1+1/z)b/(1+b)` for `0<=b<=1/z`, this proves the first
conclusion of the theorem and
`sup_t E_t sqrt(B_n^[2]) -> 0`.
Now (6.3) and (6.6) transfer every smooth test of the first-feature
compactifications. Smooth tests determine probability laws on the
compact cube. The Gaussian trace input has finite nonnegative
coordinates, hence its compactification has strictly positive
coordinates almost surely. The inverse map `v -> v^(-1)-1` is
therefore continuous at the limiting vector almost surely.
This proves the asserted joint resolvent convergence.

## 7. Functional passage, including mass at infinity

For a random nonnegative measure `nu_n` on `[0,infinity)`, set
`d eta_n=(1+lambda)^(-1)d nu_n` and view it as a finite measure on
the compact space `K=[0,infinity]`, initially giving no mass to infinity.
Its total mass is the Stieltjes transform at `z=1`, so joint transform
convergence makes the laws of `eta_n` tight.

For `z>0`, the function
`k_z(lambda)=(1+lambda)/(z+lambda)`, with `k_z(infinity)=1`,
is continuous on `K`. A countable dense set of positive parameters
including `1` determines a finite measure on `K`, even if it has an
atom at infinity. Indeed `k_1=1` and
`k_z=1+(1-z)/(z+lambda)`. Uniform limits also supply the case `z=1`
for the reciprocal functions `r_z=(z+lambda)^(-1)`.
The identity
`r_z r_w=(r_z-r_w)/(w-z)` for `z!=w`, and a uniform limit for `z=w`,
make their closed linear span with `1` an algebra separating all
points of `K`. It is therefore dense in `C(K)`.

Every subsequential law of `eta_n` is consequently the law of the
given limiting `eta=(1+lambda)^(-1)nu`, with no atom at infinity.
Joint convergence of the determining tests, not convergence of their
expectations, is essential at this step.

For `0<a<=s<=b<infinity`, the functions
`h_s(lambda)=(1+lambda)exp(-s lambda)`, `h_s(infinity)=0`,
form a compact set in `C(K)`. A finite uniform-norm net, together
with bounded total mass along a weakly convergent measure sequence,
shows that `eta -> (s -> integral h_s d eta)` is continuous into
`C([a,b])`. The continuous mapping theorem on a countable compact
exhaustion proves the spectral continuity principle in
`09-functional.tex`.

For the finite SK chain, take the spectral measure of `TH` paired
with the coordinates `n^(-1/3)X_i` and sum over `i`.
Its Stieltjes transform is precisely `B_n(z)` and its Laplace
transform is

`sum_i n^(-2/3)<X_i,exp(-s TH)X_i>_mu
 = n^(1/3) C_{n,J}(s n^(2/3))`.

Thus the trace comparison gives the claimed functional convergence
without changing the clock. Properties of the proposed Gaussian
limit such as nondegeneracy, decay, and the value of its microscopic
coefficient are not established by this continuity argument.

## 8. Exact and formal evidence: what is and is not certified

`verify.py` uses only Python's standard library and exact rational
arithmetic. Its models have `n=8`, `T=4`, and exactly the manuscript's
feature scales `1/2` and `1/8`. For each specified rational edge
parameter `a_ij`, set `J_ij/sqrt(n)=atanh(a_ij)`. The Gibbs weights
are proportional to `product_(i<j)(1+a_ij X_iX_j)`, so every
probability, conditional mean, form, resolvent, and coefficient checked
by the program is rational.

The three models are independent spins, a frustrated triangle, and a
near-frozen frustrated triangle, with all other couplings zero. The
five spectator spins are reduced by their exact Fourier characters;
this is an invariant-subspace decomposition of the full 256-state
chain, not sampling. Three internal pairs, three core-to-spectator
types of multiplicity five, and the spectator-pair type of multiplicity
ten account for every one of the 28 pairs. Both features and two
positive values of `z` are checked.

The program checks each residual covector against all tests in its
sector, the endpoint energy multiplier at nonzero rational `u`,
the constant in (3.1), the explicit bounds (3.3)--(3.5), the exact
pair-average energy identity, and residual-square completion.
The order-four compactification coefficients are computed by exact
resolvent recurrences. The fourth derivative in `theta`, if the
`u`-series coefficients are `v_a`, is `24v_4-16v_2`, since
`tanh(theta)=theta-theta^3/3+O(theta^5)`.
Finite coefficients alone do not prove an unspecified uniform
fourth-derivative bound.

Before that computation, Jacobian's installed contract was discovered
and inspected through the required isolated Argus adapter.
The single operation `matrix.inverse.compute` was run on an
integer-scaled eight-dimensional Gibbs mass form. Discovery,
contract, exact payload, typed output, server/protocol versions,
and adapter exit status are retained in the named JSON files.
The standalone verifier checks both products of the returned inverse
and independently reconstructs it. A timeout or adapter error would
fail replay, not be counted as mathematical evidence.

`Main.lean` formalizes the universally quantified binary tilt,
variance and half-difference identities, their finite weighted sum,
conditional Jensen, two-endpoint Cauchy--Schwarz, endpoint coefficient
recurrence, and bilinear residual-square completion. Its separate
statement-fidelity document names the declarations and exposes their
hypotheses. Compiler results, not this report, determine whether that
formal evidence is valid. The analytic comparison and functional
theorem are prose proofs requiring independent mathematical review.

The completed exact run passed 84 representative cases and 1,320
displaced residual-square completion checks. The recorded Lean 4.31.0
run has `exit_code=0`, `proof_holes=[]`, and axiom-audit exit code zero.
Its immutable claim certificate is
`certificates/C_CR227_ALGEBRA-18bba928e1d4e631.json` in this directory.
The source and statement-fidelity document have not changed since that
run. These are engineering results, not independent Reviewer approval.

To replay the finite certificate, from the campaign root run:

```bash
python3 research/critical_resolvent_comparison/verify.py
```

To compile and record the finite algebra:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/critical_resolvent_comparison/Main.lean --statement-fidelity research/critical_resolvent_comparison/statement_fidelity.md --claim C_CR227_ALGEBRA --project-root .
```

## 9. Primary-source comparison and originality boundary

A bounded primary-source check examined the following propositions:

- Chatterjee, *A generalization of the Lindeberg principle*,
  DOI `10.1214/009117906000000575`,
  [arXiv:math/0508519v3](https://arxiv.org/pdf/math/0508519v3),
  Theorem 1.1, electronic-reprint page 2. It bounds smooth replacement
  by conditional first/second-moment discrepancies and a third-moment,
  third-derivative remainder. It is an established general method,
  not a critical stationary heat-bath process theorem.
- Carmona--Hu, *Universality in Sherrington--Kirkpatrick's spin glass
  model*, DOI `10.1016/j.anihpb.2005.04.001`,
  [published primary source](https://www.numdam.org/item/10.1016/j.anihpb.2005.04.001.pdf),
  Theorem 1, journal page 216, under equation (1), and Remark 3,
  page 217. Centered variance-one disorder with finite third absolute
  moment has the same limiting free energy; the displayed error is
  `9 E|J|^3 beta^3/sqrt(N)`. It is a static free-energy theorem, with
  weaker moment assumptions but a different observable.
- The target manuscript, public repository version
  [`adc7f1241b42e322a6451854ab7e4b4c146bf78a`](https://github.com/openai/math/tree/adc7f1241b42e322a6451854ab7e4b4c146bf78a/preprints/Functional-universality-of-critical-SK-autocorrelations-October-5-2026),
  Theorem 1.1 and Sections 8--9. It already states the stationary
  functional result for Gaussian/sign laws and already contains the
  two-feature fourth-derivative mechanism verified here.
- The companion *Universality of critical quench autocorrelations in
  the Sherrington--Kirkpatrick model*, October 5, 2026, at that public
  repository version, Theorem 1.1, states a joint stationary/quench
  process result for the same two laws and imports the target's
  stationary result. It is not independent confirmation of the
  broader entry-law theorem.

The primary-source search did not obtain a stationary critical
`n^(2/3)`-clock Ising process theorem for the wider Cramer class.
That absence does not prove novelty. The mathematical improvement
over the strongest directly relevant printed result is the conditional
extension to zero-third-moment Cramer laws, including unbounded
non-sub-Gaussian laws and nonsymmetric moment-matched laws, together
with uniformity for a common exponential-moment envelope.
Neither the Lindeberg method nor the manuscript's two-feature
construction is claimed as new.

For a concrete strict tail extension, a variance-one centered Laplace
law has moment-generating function `1/(1-v^2/2)` for `|v|<sqrt(2)`.
It has an exponential moment but is not sub-Gaussian. A concrete
nonsymmetric example is `J=X/sqrt(2)` for

`P(X=-2)=1/5`, `P(X=-1)=1/4`, `P(X=1)=1/2`, `P(X=3)=1/20`.

Its unscaled moments of orders zero through four are
`1,0,2,0,8`, checked exactly by the verifier. Thus the extension
is not merely a rewording of symmetry.

No false literal manuscript assertion has been established in the
audited mechanism. In particular, no `F_...` refutation claim is
manufactured from a failed computation or an unspecified constant.
Originality, statement fidelity, the analytic proofs, and
publishability remain questions for the independently invoked Reviewer.
