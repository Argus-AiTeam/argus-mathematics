# First contact in a finite-range-dependent environment

## Scope and known status

The target is Proposition `prop:first-contact`, equations
`eq:first-contact-prefix-sum` through `eq:first-contact-bin`, in the staged
October 5, 2026 finite-range manuscript's `build/manuscript/posteriors.tex`.
The comparison source is the September 23 strict-ellipticity manuscript's
`build/06-posterior-contact.tex`. The latter assumes iid rows and is not
evidence for the finite-range extension.

Throughout, the environment is the full infinite stationary field of
nearest-neighbor transition rows on Z^d, with common ellipticity lower bound
kappa > 0 and independence of the row sigma-fields of deterministic sets
at infinity-distance greater than R. In particular, independence is not
asserted for merely disjoint sets. Marks 0 and 1 have constant transition
weight lambda for each permitted step; the residual mark has weight
omega(x,e)-2 lambda. The script has length M > d R + 1 and weight
xi = lambda^M.

The proposition is conditional on p_+ p_- > 0. Its quantifiers are all
integers M <= k < r < N with r-k >= R, with a constant depending on the
environment law and fixed marking parameters, not on these integers.
The positive path is conditioned on the exact script event D_N^+, not
merely on T_N < T_{-1}. The negative relative path is independent of the
positive path before endpoint alignment. Contacts use all departures,
including constant-weight departures, and the negative path's entire
infinite range. Neither a contact time nor a regeneration time is treated
as a stopping time in the positive path filtration.

A bounded primary-source lookup by the separate literature reader found
the first-moment calculation in Kesselheim--Molinaro--Patton--Singla,
arXiv:2608.01616v1, section 1.1:
for a finite-horizon simplex posterior with initial coordinates mu_e,
E sum_e max_i w_i(e) <= sum_e [mu_e + mu_e log(1/mu_e)]
<= 1 + log m. This does not certify the exponential-moment assertion or
the contact estimate. The lookup did not identify a source proving
sharpness of the logarithm-squared loss or a matching general
random-kernel contact theorem. That is a search limitation, not a novelty
certificate. Ville (1939), the specified Kikuchi (1992) locator, and the
headline zero-one and ballisticity theorems have not been independently
certified by this mission. No external theorem from those sources will
be assumed in the proof below.

The intended mathematical deliverables are (i) a proof of the proposition
in its full finite-range setting, via a general posterior/weak-L1 product
inequality, and (ii) an exact family testing the optimality of that
abstract inequality. A finite-state experiment cannot establish the
infinite-environment proposition. A sharpness example for an abstraction
cannot be relabelled as a counterexample to the RWRE estimate.

## Results and their scope

The proof below establishes the first-contact proposition in the full
finite-range setting. It does not establish any of the three manuscripts'
headline theorems. No false assertion in the selected proposition has
been identified. In particular, its stopped-posterior argument does not
silently assume iid rows or conditional densities.

There is a stronger finite-anchor statement. Replace the endpoint ball
by any finite set of m possible anchors on height N-1; the anchor can be
selected by any measurable finite-valued function of the positive
marked path through T_N. A cemetery value is allowed, and is excluded
from the event being bounded. Put B = log(m+1), delta = Delta, and
L_delta = log(e/delta). Then

\[
 P(\mathcal C)
 \le {4\kappa^{-dR}\over p_+p_-}
       \min\{48 B\delta L_\delta^2,\ m\delta L_\delta\}.       \tag{1}
\]

Both terms are zero at delta = 0. For the manuscript's endpoint ball,
m <= (2N^2+1)^(d-1), so B <= (2d-1) log(2N). In particular the
following explicit, script-cost-free constant suffices:

\[
 P(\mathcal C_{k,r,N})
 \le {192(2d-1)\kappa^{-dR}\over p_+p_-}
       \log(2N)\Delta\log^2(e/\Delta).                       \tag{2}
\]

The factor xi cancels between the lower-prefix mass and the bridge
normalizer. No claim is made that this numerical constant is optimal.

An independent structural result is that the product inequality behind
(1) has an explicit matching logarithm-squared lower family when m
grows with the inverse rare-event scale, and a matching single-logarithm
lower family in the saturated regime. These are simplex posterior
martingales, not RWRE examples. This distinguishes a limitation of the
method from any claimed optimality of the actual RWRE bound.

The proof is ordinary mathematics. `verify.py` replays exact rational
models and the certificate. `Main.lean` formalizes the universally
quantified binomial and finite-sum lower-moment core only, as delimited
in `statement_fidelity.md`. The probability-space interpretation and
the infinite-environment upper bound are not Lean-formalized.
Independent mathematical review and novelty assessment remain necessary.

## 1. The posterior/weak-L1 product theorem

**Theorem 1.** Let m>=1, and let w_i(e), 1 <= e <= m, be nonnegative martingales
in one filtration, with sum_e w_i(e) <= 1. On any joint probability
space with this entire martingale-path marginal, let

\[
 S=\sum_{e=1}^m\sup_{i\ge0}w_i(e),\qquad 0\le H\le1,
 \qquad P(H\ge t)\le\min(1,\delta/t)\quad(t>0).
\]

For 0 < delta <= 1,

\[
 E[SH]\le
 \min\{48\log(m+1)\delta\log^2(e/\delta),
             \ m\delta\log(e/\delta)\}.                    \tag{3}
\]

If delta = 0, H = 0 almost surely and the product expectation is zero.
No martingale property is required in a filtration revealing H or any
environment.

**Proof of the martingale estimate.** Write
A_i(e) = max_{j<=i} w_j(e), A_i = sum_e A_i(e), and B = log(m+1).
For u > 0, stop one coordinate at its first crossing of u, first on
a finite horizon. The martingale identity and nonnegativity give the
conditional crossing bound w_i(e)/u. Increasing the horizon preserves
this bound. Each coordinate is at most one. Conditional integration
over u in [A_i(e),1] therefore gives

\[
 E[A_\infty(e)-A_i(e)\mid\mathcal F_i]
 \le w_i(e)\log(1/A_i(e))
 \le w_i(e)\log(1/w_i(e)).
\]

A zero current coordinate stays zero at all future integer times,
conditionally almost surely. Adding the missing mass to the vector
and applying concavity of log bounds its entropy by log(m+1). Thus

\[
 E[S-A_i\mid\mathcal F_i]\le B.                             \tag{4}
\]

The same statement at a finite-valued stopping time follows by splitting
over its values; localization gives it on the event that the stopping
time is finite. Also A_0 <= 1 and
0 <= A_i-A_{i-1} <= sum_e w_i(e) <= 1.
Set b = 2B+1. The first strict crossing of 1+b has probability at most
1/2 by (4). At any strict crossing of 1+jb the overshoot is at most one,
so crossing 1+(j+1)b requires a further increase greater than 2B.
Conditional Markov inequality and (4), split over the finite crossing
time, give

\[
 P(S>1+jb)\le2^{-j}\quad(j\ge0).                            \tag{5}
\]

This argument may be performed at finite horizons and then increased;
it uses no integrability of a stopping time.

Since B >= log 2 >= 1/2, we have b/B <= 4. Summing (5) over successive
threshold intervals yields

\[
 E\exp(S/(16B))
 \le e^{1/8}\left(1+{e^{1/4}\over1-e^{1/4}/2}\right)
 \le {40\over7}<8.                                         \tag{6}
\]

Here e^x <= 1/(1-x), 0 <= x < 1, follows directly from its power
series. For any event V of probability p > 0 on the larger joint
space, Jensen applied conditionally on V now gives

\[
 E[S\,1_V]\le16B p\log(8/p)
              \le48B p\log(e/p).                          \tag{7}
\]

The zero-probability case follows from S <= m. Formula (7) uses the
martingale-path marginal only, not a purported enlarged-filtration
martingale.

**Proof of (3).** The function g(p)=p log(e/p) is increasing on [0,1].
Tonelli's theorem, (7), and the tail hypothesis give, with
L = log(1/delta),

\[
\begin{aligned}
 E[SH]
 &=\int_0^1 E[S\,1_{\{H\ge t\}}]\,dt\\
 &\le48B\left(\delta+
       \int_\delta^1{\delta\over t}\log(et/\delta)\,dt\right)\\
 &=48B\delta(1+L+L^2/2)
 \le48B\delta(1+L)^2.
\end{aligned}
\]

The same layer-cake calculation gives E H <= delta(1+L). Since
S <= m pathwise, this proves the second term of (3) as well.
The value at a single integration threshold is immaterial.

## 2. Infinite-environment verification of the contact mechanism

### 2.1 Separated marked weights and exact bridge normalization

For a fixed finite marked word c, its quenched weight is a product of
constants and functions of rows in Act(c). Consequently it is
independent of every nonnegative function of rows farther than R from
Act(c). This is exactly the sigma-field independence in the model,
not an independence of arbitrary disjoint paths. Repeated departures
use the same row and are retained within that product.

For a deterministic forbidden set F, a walk killed on its first
arrival in F, including that arrival, uses only rows in F's complement.
Finite killed cylinders give this assertion first for finite events.
Their generated sigma-field gives it for every measurable killed-path
event, including survival forever and a later visit to a prescribed
set. No finite-time approximation is being asserted to equal an
infinite survival probability.

The raw event D_H^+ consists of hitting H-M before -1 and then taking
the constant-weight M-step script, so

\[
 P_0(D_H^+)=\xi u^+_{H-M}.                                  \tag{8}
\]

In every such prefix, all active departures are strictly below H-M.
A suffix remaining at or above H is separated from them by more than
R. The probability of such a suffix is the same p_+ for every fixed
prefix, by stationarity and separated-row independence. Thus,
conditioning on a cut at H under the non-backtracking law gives
exactly the raw marked prefix through T_H conditioned on D_H^+.
The slab parsing is determined by the candidates not undercut within
that prefix: a suffix above H cannot undercut any of them, because H
is a strict record. Splitting at these candidates is unique, and no
new script can straddle a selected boundary without overlapping the
script ending there. Thus prefix and parsed-list descriptions give
the same conditional path marginal. This proves
the bridge interpretation needed here without assuming a duration
moment or the manuscript's other main estimates.

Uniform ellipticity implies exit from every bounded-height slab:
from any interior site, a fixed finite number h of upward axial steps
exits, with probability at least kappa^h. Successive h-step trials
bound survival after j trials by (1-kappa^h)^j. This holds under every
quenched law in the full-measure ellipticity set. In particular,
u_n^+ >= p_+ and all stopped paths used below are almost surely finite.

### 2.2 The exact first-contact sum

Enumerate the marked prefixes a_0 realizing D_k^+, ending at z of
height k. Every active departure of a_0 has height below k-M.
For each fixed a_0, enumerate upper words a from z, with all vertices
in [k,N-1] in height and terminal y of height at least r.
Let

\[
 w(a_0a;e)=P_0(D_N^+,\ L=e\mid\hbox{marked prefix }a_0a).
\]

In the manuscript L is the lateral endpoint, restricted to the finite
endpoint ball. In the finite-anchor extension L is the prescribed
finite-valued anchor selector. These are the original conditional
probabilities, not probabilities recomputed in a new environment.

All active departures of a have height at least k. The active sets of
a_0 and a are therefore separated, giving
W(a_0a)=W(a_0)W(a). For a raw negative path from its deterministic
anchor b_e=(N-1,e), let V(a) require:
it stays at height at most N-1 forever, avoids the closed
R-neighborhood of Dep(a) forever, and visits the closed
R-neighborhood of y. Every departure of a counts, regardless of mark.

For each pair of paths in the desired event, a_0 is unique, and a is
the unique prefix ending at the first contact after T_k. Conversely
the avoidance and visit conditions enforce precisely that first contact.
If the terminal site occurred earlier as a departure, V(a) is empty.
Countable nonnegative summation gives the exact identity

\[
 P(\mathcal C)= {1\over \xi u^+_{N-M}p_-}
  \sum_{a_0}W(a_0)\sum_e\sum_a
    W(a)w(a_0a;e)P_{b_e}(V(a)).                            \tag{9}
\]

There is no stopping-time assertion at the first contact, which depends
on the full negative path.

### 2.3 Shared-environment transfer before classification

Fix a word a and set B(a) to be the closed R-neighborhood of Dep(a).
The quenched probability P_{b_e,omega}(V(a)) is a function only of
rows outside B(a), by the killed-path argument. Those rows are farther
than R from every active departure of a. Therefore

\[
 W(a)P_{b_e}(V(a))
  =E_Q[p_\omega(a)P_{b_e,\omega}(V(a))].                   \tag{10}
\]

This is an unclassified identity. Multiplying its two sides by a
fresh environment-dependent exit-bin indicator would not be justified.
Instead, use (10) to realize the inner sum of (9) in a fresh Q
environment, running X from z and a negative path from b_e
independently conditional on that environment. Keep W(a_0) outside
this experiment. Only then classify retained contact prefixes by the
fresh environment's exit probabilities. For each realized pair, at
most one prefix is retained. This pathwise uniqueness prevents any
sum over competing contact times.

### 2.4 Exact equality of the stopped posterior-path laws

Under the original raw law conditioned on a_0, the coordinates
w_i(e)=P_0(D_N^+,L=e | a_0, continuation through time i)
are nonnegative martingales of total mass at most one. Stop them at
the first arrival at k-1 or N.

Every departure of a stopped continuation c has height at least k.
Thus, for every such finite stopped cylinder,

\[
 P_0(c\mid a_0)=W(a_0c)/W(a_0)=W(c).                      \tag{11}
\]

The last step into k-1 uses its departure row at height k; it does not
use a row at k-1. Cylinder equality and almost sure slab exit prove
equality of the entire stopped path laws with the fresh comparison
path stopped at zeta=T_{k-1} wedge T_N. Equation (11) also applies to
interior cylinders of every deterministic length before the stop.

Evaluate the same deterministic original-posterior functions along X
and freeze them at zeta. The vector has exactly the original stopped
martingale-path law, jointly for all e. Let M(e) be its running
maximum and S=sum_e M(e). At a lower-boundary arrival, the posterior
need not be zero: it still concerns success before the original
barrier -1. Nothing identifies laws after a departure from k-1.
Revealing the fresh environment need not preserve any martingale
property. The marginal theorem in section 1 is exactly what avoids
that invalid inference.

### 2.5 Quenched exits and the weak-L1 variable

For k <= y_1 < N set
q_y=P_{y,omega}(T_{k-1}<T_N). Upward and downward axial paths
give 0 < q_y < 1 in every uniformly elliptic environment.
Let H be zero if X does not reach r before zeta; otherwise let H
be the maximum q_{X_i} over T_r <= i < zeta. This is a finite
maximum almost surely, not a maximum over a truncated experiment.

For fixed omega, the first visit in this time range to q >= t is a
stopping time in the quenched filtration. Its conditional chance of
subsequently leaving through k-1 is at least t. Splitting over finite
values of the time and averaging gives

\[
 tP(H\ge t)\le P_z(T_r<T_{k-1}<T_N)
   =u^+_{r-k}-u^+_{N-k}=\Delta.                            \tag{12}
\]

The equality is the difference of the nested events
{T_r<T_{k-1}} and {T_N<T_{k-1}}, followed by stationarity.
Almost sure slab exit removes the possibility that, after T_r,
neither boundary is ever reached.

If a retained contact is at y with q_y in [t,2t), a negative-path
site y' satisfies ||y-y'||_infinity <= R. Since y_1 >= r,
r-k >= R, and the negative path stays below N, both sites are
interior. A coordinate-monotone path from y to y' stays interior and
has length at most dR. Following it before exiting yields

\[
 q_y\ge\kappa^{dR}q_{y'},\qquad
 q_{y'}<2\kappa^{-dR}t.                                   \tag{13}
\]

Set c_R=2 kappa^(-dR). For every fixed environment and anchor, the raw
negative path has probability at most c_R t of both staying below N
forever and visiting any interior site with q <= c_R t.
Indeed, stop at its first visit to that set. On the non-backtracking
event its next slab exit must be at k-1; its conditional probability
is at most q <= c_R t. Earlier visits below k-1 cause no problem:
the argument concerns the next exit after this stopping time.
If c_R t >= 1 the same bound follows simply from probability <= 1.

### 2.6 Bin summation and constants

For dyadic t=2^(-j), j>=1, classify the retained prefix in the
shared environment by q_y in [t,2t). This partition covers every
possible retained q_y. Its posterior factor is at most M(e), and it
requires H >= t. Conditional independence of X and the negative
path, together with the preceding negative-path bound and uniqueness,
gives for fixed a_0 the bin contribution at most

\[
 c_R t\,E[S\,1_{\{H\ge t\}}].                              \tag{14}
\]

The (omega,X) marginal is the same for every anchor, so summing over
e really gives this one S; there is no factor m here. The dyadic
geometric sum is bounded pathwise by
sum_{j>=1} 2^(-j) 1_{H>=2^(-j)} <= 2H.
Consequently all bins contribute at most 2 c_R E[SH]. Use (3)
and (12).

Finally the lower prefixes are disjoint and have total mass exactly

\[
 \sum_{a_0}W(a_0)=\xi u^+_{k-M}.                            \tag{15}
\]

Substitute (15) into (9). The normalizer ratio is
u^+_{k-M}/(u^+_{N-M}p_-) <= 1/(p_+p_-), proving (1).
Taking the endpoint ball gives (2). Every comparison involved
deterministic separated sets after fixing a word, or a quenched
stopping time after fixing the environment. No conditional-density
bound, regeneration-duration moment, finite-volume replacement,
unjustified infinite-time limit, or iid simplification was used.

## 3. Sharpness of the abstract product mechanism

**Theorem 2 (reset-posterior family).** For integers J>=2 and n>=1,
put m=2^n and delta=2^(-J). There is an explicit finite-horizon
m-coordinate simplex posterior martingale and H in [0,1] satisfying
the weak-L1 tail in Theorem 1, with the following bounds:

* If J <= 2^L and 2L <= n for an integer L, then
  E[SH] >= n delta J^2/64.
* If J >= 2m, then E[SH] >= m delta J/16.

For the first regime, log(m+1) <= 2n and log(e/delta) <= 2J.
Thus the first lower bound is at least
log(m+1) delta log^2(e/delta)/512. The exponent two cannot be
decreased uniformly in m using only the two hypotheses of Theorem 1.
For the saturated regime the second lower bound is at least
m delta log(e/delta)/32, matching the second upper bound.
The first assertion does not say that the squared logarithm is sharp
as delta tends to zero with m fixed; the second assertion explains
that distinction.

**Construction.** Let E be a uniform hidden label in {0,...,m-1}.
For each round b, independently sample F_b uniform in {0,1} and U_b
uniform among the m labels, independently of E. Set Z_b=E if F_b=1
and Z_b=U_b if F_b=0. Reveal the n bits of Z_b successively and only
then reveal F_b. After a successful round F_b=1 the posterior is
frozen at the point mass at E. Stop after at most J rounds.
Before a successful round, all earlier flags were zero and the
posterior is again uniform.

After ell bits of a round, with observed prefix z, the posterior is

\[
 w(e)=\frac1{2m}+\frac{2^{\ell-1}}m
           1_{\{e\text{ shares prefix }z\}}.                \tag{16}
\]

At ell=0 this is uniform. There are m/2^ell compatible labels,
so its sum is one. Averaging the two equally likely next bits
recovers the parent vector. At ell=n, averaging the uniform posterior
on F=0 and the point mass on F=1 also gives (16).
These direct conditional-probability calculations prove the common
filtration martingale property on the actual finite probability
space, not merely on a numerically specified sequence of vectors.

Let T be the number of failed rounds before the first success, capped
at J, and put H=delta 2^T. For s<J,
P(T=s)=2^(-(s+1)), while P(T=J)=2^(-J)=delta. At every atom h_s,
P(H>=h_s)=delta/h_s. Between successive atoms the survival probability
is constant, giving P(H>=t) <= min(1,delta/t) for all t>0.

For s failed rounds, fix a label e and let L_e be the largest number
of initial bits it shares with any of the s independent uniform U
labels; set L_e=0 when s=0. Its largest posterior so far is
(1+2^L_e)/(2m), and
P(L_e>=j)=1-(1-2^(-j))^s. Summing the increments of 2^L_e
and then summing over the m labels gives the exact expected reset
maximum

\[
 \operatorname{peak}(n,s)
 =1+\sum_{j=1}^n2^{j-2}[1-(1-2^{-j})^s].                  \tag{17}
\]

A later successful round only increases coordinate maxima. Therefore

\[
 E[SH]\ge
 \frac\delta2\sum_{s=0}^{J-1}\operatorname{peak}(n,s)
       +\delta\operatorname{peak}(n,J).                   \tag{18}
\]

**First lower bound.** For 0<=p<=1 and sp<=1, two-term
inclusion-exclusion, or induction using (1-p)^s>=1-sp, gives

\[
 1-(1-p)^s\ge sp-\frac{s(s-1)}2p^2\ge sp/2.                \tag{19}
\]

For s<=J<=2^L and j=L+1,...,n, each summand in (17) is at least
s/8. There are n-L>=n/2 such summands, so
peak(n,s)>=sn/16. Substitution in (18), including the terminal
all-failures term, gives

\[
 E[SH]\ge\delta n\,J(J+3)/64
               \ge\delta n J^2/64.                       \tag{20}
\]

The universal inequalities (19), the bound on peak, and the last
finite-sum lower bound are the content of `Main.lean`.

**Saturated lower bound.** Put m=2^n. By (19),
1-(1-1/m)^m>=1/2. For every s>=m and every j<=n,
1-(1-2^(-j))^s>=1/2, hence
peak(n,s)>=1+(m-1)/4>=m/4.
If J>=2m, at least J/2 of the indices s=0,...,J-1 have s>=m.
Their contribution alone in (18) is at least delta m J/16.
This second regime is proved here in prose; it is not part of the
Lean claim.

## 4. Exact local non-iid check and what it does not prove

The code uses a genuine stationary finite-range field on the infinite
lattice, whose finite cylinders can be enumerated exactly. In d=3,
take independent fair bits eta_x and put

\[
 \omega(x,+e_1)=(4+\eta_x+\eta_{x+e_1})/24,\quad
 \omega(x,-e_1)=(4-\eta_x-\eta_{x+e_1})/24,
\]

with each of the other four transitions equal to 1/6.
All rows sum to one and have minimum at least 1/12. Each row uses only
the two indicated bits, so row fields at distance greater than one
are independent. It is stationary; translation-invariant events pull
back to translation-invariant events of the iid bit field, so it is
ergodic. Adjacent rows are correlated.

With lambda=1/48, condition on a residual-mark +e_1 departure at zero.
The likelihood is (3+eta_0+eta_{e_1})/24. Then

\[
 E[\omega(e_1,+e_1)]=5/24,\qquad
 E[\omega(e_1,+e_1)\mid\hbox{that departure}]=27/128,
\]

whose difference is 1/384. Thus "disjoint implies fresh" would fail
in this model, exactly as the manuscript recognizes. With a subsequent
five-step constant-weight script ending at height 6, all active
continuation rows above height 6 are independent of the sole active
prefix row at zero. The terminal arrival at height 5 in a stopped
continuation still uses no height-5 row. This is the actual separation
principle, not iid behavior.

Jacobian operation `probability.conditional_expectation.finite.compute`
computes the displayed adjacent-row conditional expectation on the
eight likelihood-tilted bit atoms. Its inspected contract allows at
most 64 atoms and only finite conditional expectation; it cannot
certify infinite path survival, an RWRE theorem, or arbitrary
stopped-law equality. `jacobian_discovery.json`,
`jacobian_contract.json`, `jacobian_payload.json`,
`jacobian_result.json`, and `jacobian_execution.json` retain the
server/protocol, operation, exact payload, typed result, and exit
status. This is a deliberately bounded local check, not a surrogate
postcondition for the proposition.

The code also checks (16) on every observation-prefix state for small
n, directly enumerates the maximum in small reset models, and replays
the exact rational expressions (17)--(20) on recorded instances.
The universal claims rest on the proofs above, with the indicated
algebraic part checked by Lean, not on extrapolation from those tests.

## 5. Remaining review boundaries

The strongest prior result in the mission was an untested first-contact
proposition and an iid comparator. The improvement is a complete
finite-range proof with an explicit constant, a finite-anchor
generalization with a second saturation bound, and an explicit
two-regime sharpness construction for the abstract product mechanism.

No manuscript `F_<LABEL>` claim is warranted by the checks above:
the adjacent-row dependence is an example of a shortcut the manuscript
does not take. It must not be recorded as its refutation.
The main zero-one theorem still depends on the radius, entropy,
coordinate-reduction, and lower-count arguments not certified here.
The ballisticity theorem is likewise not certified.

The bounded literature lookup supports neither a priority claim nor
`novelty_status=verified_new`. An independent Reviewer must check the
full proof, the translation between the probability construction and
the formal lower-moment theorem, and the significance/novelty of this
structural extension before the campaign can claim publishable
completion.

## 6. Reproduction

The exact finite-model replay needs Python's standard library only:

```sh
python3 research/finite_range_first_contact/verify.py
```

The recorded official compiler run used Lean 4.31.0, returned exit code
zero and `proof_holes=[]`, and attached mechanical evidence to
`C_POSTERIOR_SHARP_CORE`. Its answer is in `lean_verification.json`,
with the immutable certificate under this directory's `certificates/`.
The separate fidelity reading is still an independent-review obligation.
The formal replay command is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/finite_range_first_contact/Main.lean --statement-fidelity research/finite_range_first_contact/statement_fidelity.md --claim C_POSTERIOR_SHARP_CORE --project-root campaigns/9000220
```

The campaign-local structural checker results are recorded in
`roles/engineer/progress.json`. Their zero exit codes are schema and
freshness checks, not independent mathematical or novelty verdicts.
