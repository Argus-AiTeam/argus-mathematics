# Shifted-potential bounds for one-sided equal-marginal couplings

## Scope and source dependencies

The target is the September 25, 2026 OpenAI manuscript *Average sensitivity
of polynomial threshold functions*, staged in `research/openai_manuscript/`.
The immutable public source used for citations is revision
`adc7f1241b42e322a6451854ab7e4b4c146bf78a` of `openai/math`, under
`preprints/Average-Sensitivity-of-Polynomial-Threshold-Functions-September-25-2026/build/`.
This revision was obtained from the GitHub commits API and its Section 4
source locator was checked against the GitHub contents API.

The following are source findings, not claims that the upstream operator
argument has been independently formalized:

1. Section 2, Lemma `lem:coupling`, assumes equal marginal laws, finite
   variance, and only `V-U <= a`. It proves `E(U-V)^2 <= 8 a sigma`.
   Equation `eq:g-increments` supplies a lower bound on increments of
   `g(t) = (t-m)|t-m|/2`. Independence and exchangeability are not assumed.
2. Section 3, equations `eq:total-energy` and `eq:tridiagonal`, gives
   grade dimensions `binom(n,k)`, total centered energy `n 2^n/4`,
   and coordinate locality for every strictly positive weight.
3. Section 4, Lemma `lem:edges`, bounds the number of ordered equal-sign
   edges by twice the squared Hilbert--Schmidt norm of the
   anticommutator, again for arbitrary strictly positive weights.
4. Section 5, equations `eq:vanishing`, `eq:block-coupling`, and
   `eq:sensitivity-count`, reduces sensitivity to an equal-marginal
   binomial coupling with `V-U <= d`, and gives
   `I(f) <= 2 E(U-V)^2`. The positive perturbation there preserves
   `sign(0)=1`.
5. Section 1 states `I(f) <= 8 d sqrt(n)`. The work below changes its
   probability ingredient, not the definitions, edge normalization,
   weight class, or sign convention.

The scoped ledger records these results as cited assumptions. Their use in
the downstream sensitivity statement remains explicit. The new finite
coupling argument will be proved independently. No upstream Lean build is
assumed, and an intentionally incomplete comparator would not refute the
manuscript.

An initial literature lookup for an equal-marginal, one-sided quadratic
transport bound in mean absolute deviation, and for its exact binomial
specialization, identified no verified primary-source match. The search
service's suggested nearby references were not relied on: they were not
verified to contain the proposed statements. A failed search is not a
novelty certificate. Originality and publishable significance remain for
independent review.

### Prior transport results found in the focused comparison

A subsequent terminology-focused lookup did locate a relevant primary
source: Marcel Nutz and Ruodu Wang, *The Directional Optimal Transport*,
**arXiv:2002.08717v2** (June 19, 2021), later *Annals of Applied
Probability* **32** (2022), 1400--1420,
doi:10.1214/21-AAP1712. The versioned arXiv HTML was read directly:
<https://arxiv.org/html/2002.08717v2>.

Theorem 2.2 characterizes the directional optimizer for all integrable
submodular rewards, and Proposition 2.6 states that it leaves the
common marginal part on the diagonal. Example 4.5 explicitly gives
an identity-plus-antitone decomposition for single-crossing **densities**.
The search service's suggested locators "Theorem 3.1" and "Example 3.3"
were wrong and are not used; the primary source has the locators above.
The density-only example is **not** invoked as a theorem about discrete
binomial marginals.

Our change of variables `X=V, Y=U+a` turns the support condition into
`X<=Y`, with marginal laws `law(U)` and `law(U+a)`.
The reward is `(Y-X-a)^2`, a strictly submodular reward. Thus the
general optimizer principle is already in this literature. Under the
same change of variables, the common-part diagonal is exactly our upward
shift, and reflection gives the residual antitone transport. **The
common-plus-antitone optimizer structure is not claimed to be new.**
Theorem 2 below is a self-contained lattice specialization and explicit
evaluation, not a purported discovery of that general structure.

This comparison is recorded separately as `K_DIRECTIONAL127` with its
cited background assumption. The proofs below do not depend on the
external directional-transport theorem. The candidate contributions to
assess are the elementary shifted dual/MAD estimate with optimal MAD
coefficient, the explicit binomial value, its formal finite certification,
and its sensitivity-constant consequence. The primary-source comparison
narrows, rather than certifies, their novelty.

## Research classification

The intended deliverables are parameter-uniform proofs, a formally checked
finite coupling inequality, and exact rational primal/dual fixtures.
Finite computations alone do not prove the parameter-uniform theorem.
Any sensitivity improvement will be distinguished from an optimal
polynomial-threshold sensitivity bound and from a refutation of the
manuscript.

## 1. The shifted-potential theorem

Write `r_+ = max(r,0)` and define, for `a >= 0`,
\[
 g(t)=\frac12t|t|,\qquad
 H_a(z)=4\left[z^2-(|z|-a/2)_+^2\right].
\]

**Theorem 1 (one-sided equal-marginal transport).** Let `U,V` be real
random variables with the same distribution and finite second moment.
Suppose `V-U <= a` almost surely, where `a >= 0`. For **every** real
center `c`,
\[
 \boxed{\quad
 \mathbb E(U-V)^2
 \le \mathbb E H_a(U-c)
 \le 4a\,\mathbb E|U-c|.\quad}                 \tag{1}
\]
In particular, at the common mean `m`, with common standard deviation
`sigma`,
\[
 \mathbb E(U-V)^2\le4a\,\mathbb E|U-m|\le4a\sigma.       \tag{2}
\]
The coefficient 4 in the mean-absolute-deviation inequality is optimal.
This does not assert optimality of the coefficient in the weaker
standard-deviation inequality.

**Proof.** For `s <= t`,
\[
 (t-s)^2\le4(g(t)-g(s)).                              \tag{3}
\]
If `0 <= s <= t`, the difference of the right and left sides is
`(t-s)^2+4s(t-s) >= 0`. If `s <= t <= 0`, it is
`(t-s)^2-4t(t-s) >= 0`. If `s <= 0 <= t`, it is
`(s+t)^2 >= 0`. This is a direct proof of the required lower
increment bound, rather than a new external assumption.

The shift is essential: apply (3) to
`s=v-c-a/2` and `t=u-c+a/2`. The support condition gives `s <= t`.
Define
\[
 \Phi_{a,c}(u)=4g(u-c-a/2)-2a(u-c).
\]
Expanding `(u-v+a)^2` and using
\[
 H_a(z)=4\bigl[g(z+a/2)-g(z-a/2)\bigr]-a^2             \tag{4}
\]
gives the pointwise dual inequality
\[
 (u-v)^2
 \le H_a(u-c)+\Phi_{a,c}(u)-\Phi_{a,c}(v)
 \qquad(v-u\le a).                                   \tag{5}
\]
Identity (4) follows by considering `z <= -a/2`,
`-a/2 <= z <= a/2`, and `z >= a/2`; explicitly,
\[
 H_a(z)=
 \begin{cases}
  4z^2,& |z|\le a/2,\\
  4a|z|-a^2,& |z|\ge a/2.
 \end{cases}                                        \tag{6}
\]
These formulas agree at the boundaries and cover `a=0`.

The second-moment hypothesis makes both potential terms integrable.
Equal marginal laws imply
`E Phi(U) = E Phi(V)`, so expectation in (5) proves the first
inequality of (1). Formula (6) gives `H_a(z) <= 4a|z|`:
on the inner interval, `z^2 <= a|z|`; outside it, subtracting `a^2`
can only help. This proves the second inequality. Finally,
Cauchy--Schwarz gives `E|U-m| <= sigma`.
All terms are integrable since `(U-V)^2 <=
2(U-c)^2+2(V-c)^2`. No independence, joint-law symmetry,
exchangeability, or bound on downward displacement was used. When `a=0`,
the envelope is zero, so (1) also proves `U=V` almost surely. QED.

**Finite, unnormalized form.** For a finite real coordinate family `x_i`
and nonnegative masses `w_ij` satisfying
`sum_j w_ij = sum_j w_ji` and `x_j-x_i <= a` whenever `w_ij > 0`,
multiplying (5) by `w_ij` and summing gives
\[
 \sum_{i,j}w_{ij}(x_i-x_j)^2
 \le\sum_i\left(\sum_jw_{ij}\right)H_a(x_i-c)
 \le4a\sum_i\left(\sum_jw_{ij}\right)|x_i-c|.           \tag{7}
\]
The cancellation is exactly equality of row and column sums. There is
no total-mass-one hypothesis. This is the machine-formalized core,
including (3)--(5); the arbitrary-probability-space integrability argument
above is a separate analytic proof.

## 2. Optimality of the MAD coefficient

Fix `a>0` and an even integer `k>=2`. Let `U` be uniform on
`{0,a,...,(k-1)a}` and set `V=U+a`, except that `V=0` when
`U=(k-1)a`. This is a cyclic permutation of the support, hence the
marginals agree and `V-U <= a`. At the mean
`c=(k-1)a/2`, direct finite sums give
\[
 \mathbb E(U-V)^2=(k-1)a^2,\qquad
 \mathbb E|U-c|=\frac{ka}{4}.
\]
Consequently
\[
 \frac{\mathbb E(U-V)^2}{a\,\mathbb E|U-c|}
 =4\left(1-\frac1k\right)\longrightarrow4.             \tag{8}
\]
Thus any universal coefficient below 4 fails for a sufficiently large
finite even `k`. For `k>2`, these cyclic couplings are not exchangeable.
The finite fixtures illustrate (8); the parameter-uniform formula and
limit prove sharpness. No claim is made that a nondegenerate finite
fixture attains the limiting MAD coefficient itself.

## 3. Exact optimizer for symmetric unimodal lattice laws

**Theorem 2 (shift-and-reflect optimizer).** Let `n>=0` be an integer
and let `p_0,...,p_n` be a probability mass function satisfying
\[
 p_i=p_{n-i},\qquad
 p_0\le p_1\le\cdots\le p_{\lfloor n/2\rfloor}.
\]
Zeros and plateaus are allowed. For every integer `0<=d<=n`, the
maximum of `E(U-V)^2` over couplings of this law with itself satisfying
`V-U<=d` is
\[
 B_p(d)=\sum_{i=0}^n p_i H_d(i-n/2).                  \tag{9}
\]
An explicit optimizer uses only the pairs `j=i+d` and `j=n-i`.

**Construction and proof.** Extend `p_i` by zero outside `[0,n]` and
put
\[
 t_i=\min(p_i,p_{i+d}),\qquad
 \pi_{ij}=t_i\,\mathbf1_{\{j=i+d\}}
       +(p_i-t_i)\,\mathbf1_{\{j=n-i\}},
 \quad 0\le i,j\le n.                               \tag{10}
\]
The two contributions are added if the indicated columns coincide.
Every term is nonnegative, and each row sums to `p_i`.
Using the zero extension and symmetry,
\[
 t_{j-d}=\min(p_{j-d},p_j)
        =\min(p_{n-j+d},p_{n-j})=t_{n-j}.
\]
Thus column `j` sums to
`t_{j-d}+p_{n-j}-t_{n-j}=p_j`. This proves exact marginal
feasibility, including boundary indices.

The upward-shift pairs have displacement exactly `d`. If `2i<n-d`,
then `i+d` is at least as close to `n/2` as `i` is: the difference
of their squared distances is `d(2i+d-n)<=0`.
Symmetry and unimodality imply `p_i<=p_{i+d}`, so `p_i-t_i=0`.
The same conclusion holds when `2i=n-d`, by symmetry.
Therefore every positive reflection mass has `2i>=n-d`, and its
displacement `n-2i` is at most `d`. The coupling is feasible.

For completeness, the distance comparison used here is an elementary
consequence of the hypotheses: for any two lattice indices, the smaller
distance to `n/2` has the larger mass, by reflecting either index
into `{0,...,floor(n/2)}` and using the stated monotonicity.

Take `a=d,c=n/2` in (5). For an upward pair `v=u+d`, its shifted
endpoints in (3) coincide; equality holds. For a reflection pair
`v=n-u`, the endpoints are negatives of one another:
\[
 v-n/2-d/2=-(u-n/2+d/2).
\]
Feasibility orders these endpoints, and (3) is an equality on such
a symmetric interval. Hence every positive entry in (10) saturates
(5). With the explicit dual values
\[
 \alpha_i=H_d(i-n/2)+\Phi_{d,n/2}(i),\qquad
 \beta_j=-\Phi_{d,n/2}(j),                            \tag{11}
\]
we have
`alpha_i+beta_j >= (i-j)^2` on **every** allowed pair `j-i<=d`,
and equality on every positive primal entry. Multiplying any feasible
coupling by this inequality bounds its objective by
`sum_i p_i(alpha_i+beta_i)=B_p(d)`. Coupling (10)
attains that value. This proves optimality directly, without invoking
an external transport or linear-programming duality theorem. QED.

Translation and scaling give the same result on `b+h{0,...,n}` for
`h>0`, with increment bound `dh` and objective multiplied by `h^2`.
For a real increment bound `a>=0` on the unit lattice, replace `d`
by `min(n,floor(a))`: displacements are integers. The unrounded
envelope at `a` need not be tight. For example, with `n=1` and
`0<a<1`, the true optimum is zero. This integrality limitation concerns
the strengthening, not an error in the manuscript.

## 4. Sharp binomial specialization

For `K~Bin(n,1/2)`, `p_i=binom(n,i)/2^n` is symmetric and unimodal:
the adjacent ratio is `(n-i)/(i+1)`, at least one up to the middle.
Theorem 2 therefore applies for every `n>=0` and integer `0<=d<=n`.
Since `E(K-n/2)^2=n/4`, the exact maximum is
\[
 \boxed{
 B(n,d)=n-4\,\mathbb E\bigl(|K-n/2|-d/2\bigr)_+^2
       =n-\frac1{2^n}\sum_{i=0}^n
          \binom ni\bigl(|2i-n|-d\bigr)_+^2 .}         \tag{12}
\]
In particular, `B(n,0)=0`, `B(n,n)=n`; both follow directly
from (12) and the binomial variance identity.
Construction (10) and dual (11) are rational and explicit for every
parameter, not just for the tested fixtures.

The binomial mean absolute deviation also has an exact expression:
for `n>=1`,
\[
 \mu_n=\mathbb E|K-n/2|
     =\frac{n}{2^n}
        \binom{n-1}{\lfloor(n-1)/2\rfloor}.            \tag{13}
\]
To see this, symmetry reduces the absolute first moment to its upper
half and the identity
`(2i-n) binom(n,i) =
n[binom(n-1,i-1)-binom(n-1,i)]`
telescopes that sum to
`n binom(n-1,floor(n/2))/2^n`. Binomial symmetry makes this
the displayed coefficient also when `n` is even.
The variance and adjacent-ratio identities follow equally from the
Bernoulli-sum representation, or from the elementary identities
`i binom(n,i)=n binom(n-1,i-1)` and
`i(i-1) binom(n,i)=n(n-1) binom(n-2,i-2)`.
Thus these finite binomial facts require no unverified literature
theorem.

Equations (1) and (13) give
\[
 B(n,d)\le4d\mu_n\le2d\sqrt n.                        \tag{14}
\]
The optimum is for the equal-marginal/support relaxation. Not every
feasible coupling need come from the manuscript's weighted grading.

## 5. Conditional improvement to threshold sensitivity

Retain the manuscript's entire operator reduction as the source
assumptions listed above. In particular, keep arbitrary positive
grading weights, ordered-edge normalization, and `sign(0)=1`.
For a degree-at-most-`d` polynomial threshold function on the uniform
`n`-cube, `1<=d<=n`, Section 5 produces the feasible binomial
coupling and gives `I(f)<=2 E(U-V)^2`. Substitution of (12)--(14)
yields the parameter-uniform consequence
\[
 \boxed{\quad
 I(f)\le\min\{n,\,2B(n,d)\}
       \le\min\{n,\,8d\mu_n\}
       \le\min\{n,\,4d\sqrt n\}.\quad}                \tag{15}
\]
Equivalently the explicit binomial-coefficient upper bound is
`8 d n binom(n-1,floor((n-1)/2))/2^n`, capped by `n`.
Constant polynomials have zero sensitivity, covering degree zero
separately. The polynomial may vanish: the source's positive perturbation
preserves its signs exactly under the retained convention.

This improves the manuscript's stated constant 8 to 4, with the
further exact dimension/degree-dependent bound `2B(n,d)`. It does
not prove that either sensitivity bound is optimal. The improvement
is a conditional analytic consequence of the cited operator construction;
neither the fixture program nor the Lean file formalizes that construction.

## 6. Exact evidence and adversarial checks

Run from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/shifted-coupling/verify.py
```

The verifier uses only the Python standard library and exact rational
arithmetic. `exact_certificate.json` contains explicit marginal arrays,
sparse primal arrays, full dual arrays, and matching rational objective
values. The replay verifies normalization, nonnegativity, both marginals,
the **one-sided** support bound, every allowed-pair dual inequality,
complementary slackness, primal/dual equality, the envelope identity,
the MAD comparison, and the binomial second-moment formula.
It additionally sweeps every `0<=d<=n<=16`, tests rational pointwise
boundary configurations, and rejects deliberately corrupted mass,
support, objective, and dual data. Cases include zero shifts, maximal
shifts, odd/even dimensions, plateaus, zero endpoints, and point masses.
These are exact finite experiments supporting and debugging the stated
proofs, not a proof by exhaustion of all parameters.

The final exact replay passed with 36 stored fixtures, 153 additional
binomial fixtures, 30,094 allowed-pair dual inequalities, 1,368
pointwise checks, and five rejected corruptions. The sharpness fixture
at `k=1000` has ratio `999/250`. The result is retained in
`verification_result.json`.

One bounded Jacobian operation was discovered and its exact typed
contract inspected before execution:
`matrix.rational_linear_system.solve`. The dedicated
`jacobian_request.json`, `jacobian_result.json`, and
`jacobian_status.json` preserve its payload, server/protocol identification,
typed result, and adapter exit status. The system solves for the masses
on `(0,1),(1,2),(1,1),(2,0)` in the `n=2,d=1` fixture.
Its unique solution is four masses of `1/4`. The local verifier replays
the exact equations. This is an atomic finite feasibility computation,
not the source of the universal construction or its optimality proof.

## 7. Formal and independent-review scope

`Main.lean` formalizes the finite unnormalized inequalities (7), their
pointwise dual, the primitive increment inequality, and the exact envelope
identity. The companion `statement_fidelity.md` specifies all quantifiers
and the boundary between formal and prose results. A real Lean 4.31.0
compiler run succeeded with exit code 0 and `proof_holes=[]`;
the final certificate is
`certificates/C_FINITE127-e58c76de63da3fef.json`.
Its axiom reports contain only `propext`, `Classical.choice`, and
`Quot.sound`, the usual Lean/Mathlib foundations, with no added axiom.
The ledger derives `closed_kernel` for `C_FINITE127` from this actual
run. The first compile's noncomputable-definition diagnostics were fixed;
that earlier inconclusive certificate is not supporting evidence.

The new claims, the proof graph, and all source assumptions are in
`research/MATH_STATE.json` and `research/PROOF_GRAPH.json`. Source
proposition attribution, statement fidelity, parameter-uniform prose
proofs, novelty, significance, and acceptance remain for the Host-invoked
independent Reviewer. No false literal manuscript assertion has been
identified in this route, so there is no manuscript refutation claim.
The coefficient improvement and exact symmetric-unimodal relaxation
theorem are the mathematical additions over the strongest inspected
source result, not a claim that the earlier theorem was false.

All five staged source sections used in the assumptions were byte-compared
with their immutable GitHub revision and matched. The official citation
resolver does not support URL identifiers, so its existence results are
inconclusive rather than confirmations or failures to obtain the source.
Independent proposition attribution remains open for the Reviewer; changing
the citations to uncited assumptions merely to clear that queue would be
incorrect. The same applies to the newly located directional-transport
background.
