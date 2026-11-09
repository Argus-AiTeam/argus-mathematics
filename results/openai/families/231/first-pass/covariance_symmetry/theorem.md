# Covariance-local IID sampling with all coordinate symmetries

## Result and its exact scope

**Theorem 1 (full-symmetry strongly Rayleigh sampling).** Let I be a
countable set, finite or infinite, and let nu be a strongly Rayleigh
probability law on `{0,1}^I`: every finite-coordinate marginal has a real
stable generating polynomial. There is a Borel map

    Phi_nu : [0,1]^I -> {0,1}^I

whose pushforward of product Lebesgue measure is nu and such that

    Phi_nu(sigma u) = sigma Phi_nu(u)

for **every** u and **every** coordinate permutation sigma preserving nu.
Here `(sigma u)_j = u_(sigma^{-1}j)`. No transitivity, regular action,
amenability, finite generation, full support, or bounded input field is
assumed. This is an ordinary Borel factor, not a finitary factor, and no
Borel dependence of the choice of Phi_nu on the parameter nu is asserted.
Output membership in the support of nu is an almost-sure requirement,
not a requirement at every exceptional label input.

The proof below establishes the stronger structural statement:

**Theorem 2 (negative-association/uniform-response criterion).** The same
conclusion holds for a countable negatively associated binary law for
which there is a finite L such that, for every i, every finite S, every
t >= 0, and all finite fields y,y',

    |b_(i,S)(t,y) - b_(i,S)(t,y')|
        <= L max_(j in S) |y_j-y'_j|,                         (2.1)

where the empty maximum is zero and

    b_(i,S)(t,y) =
      E[X_i exp(sum_(j in S) (y_j-t/2) X_j)]
      / E[exp(sum_(j in S) (y_j-t/2) X_j)].                  (2.2)

Negative association here means that increasing real functions of
disjoint finite coordinate blocks have nonpositive covariance. For the
strongly Rayleigh case L = 1/2.

**Evidence classification.** Theorems 1 and 2 have mathematical proofs
below, with external strongly Rayleigh inputs identified in Section 9.
`Main.lean` formally proves the finite block-independence core, not the
entire analytic construction. The exact verifier checks quantified
algebraic identities, the formal certificate's binding, and explicitly
bounded regression examples. It does not substitute examples for the
countable proof. Independent mathematical, citation, and novelty review
is outstanding; no `verified_new` or campaign-acceptance verdict is
claimed by the Engineer.

## 1. Zero cross covariance under negative association

**Lemma 3 (finite covariance locality).** Suppose A and B are disjoint
finite coordinate sets in a negatively associated binary vector. If
`Cov(X_i,X_j) = 0` for every i in A and j in B, then the entire A and B
blocks are independent.

More generally, it suffices that
`Cov(R_A,R_B) = 0`, where `R_A = sum_(i in A) X_i` and similarly for B.

**Proof.** For any [0,1]-valued function f on the A cube, both `R_A+f`
and `R_A-f` are increasing. Indeed, comparable distinct binary
configurations have ranks differing by at least one, whereas f changes
by at most one. Equal configurations cause no difficulty. For any
[0,1]-valued g on B the analogous two envelopes are increasing.
Put

    r = Cov(R_A,R_B),  a = Cov(R_A,g),
    b = Cov(f,R_B),    c = Cov(f,g).

Negative association gives all four inequalities

    r+a+b+c <= 0,    r-a+b-c <= 0,
    r+a-b-c <= 0,    r-a-b+c <= 0.                          (3.1)

When r = 0, the first plus fourth imply c <= 0 and the second plus
third imply c >= 0. Hence `Cov(f,g) = 0`. Take f and g to be indicators
of individual block configurations. This gives

    P(X_A=x, X_B=y) = P(X_A=x) P(X_B=y)

for every x,y, proving full block independence. Finally,
`Cov(R_A,R_B) = sum_(i in A,j in B) Cov(X_i,X_j)`, so the pair-covariance
hypothesis implies r = 0. Empty blocks are included. QED.

This is the special zero-covariance case of the known inequality in
ABZ, Proposition 2.2. It is not a new independence principle.
`CovarianceLocality.factorization_of_zero_rank_covariance` and
`CovarianceLocality.covariance_locality` prove precisely this lemma in
Lean, with actual nonnegative normalized joint masses, arbitrary finite
Boolean blocks, cross-block negative association, and full mass
factorization. Pairwise independence WITHOUT negative association is
insufficient; the verifier includes the three-bit even-parity example
as a diagnostic, not as a manuscript counterexample.

**Lemma 4 (countable component independence).** In a countable
negatively associated binary law, let C(i) be the component of i in the
graph with edges `{i,j}` when i != j and `Cov(X_i,X_j) != 0`. The
coordinate sigma-fields of the different components are mutually
independent.

**Proof.** Negative association makes every distinct-coordinate
covariance nonpositive, so nonzero means strictly negative. Between
different components all pair covariances vanish. Lemma 3 proves
independence between any two finite blocks lying in disjoint unions of
components. For a finite list of distinct components, apply the lemma
between a finite block of the first component and the union of the
finite blocks of all the others; induction gives their joint product
law. Finite-coordinate cylinder events generate each component
sigma-field. A pi-lambda argument in each of the finitely many factors
extends the product identity to arbitrary events. This is mutual
independence of the countable family: every finite subfamily is
independent. In particular any one component is independent of the
sigma-field generated by all the others, again by cylinder extension.
QED.

## 2. Intrinsic finite neighborhoods

**Lemma 5.** Suppose the law is negatively associated and
`sum_j |Cov(X_i,X_j)| < infinity` for every i. For n >= 1 let G_n have
an edge between distinct i,j exactly when

    -Cov(X_i,X_j) >= 2^(-n).

Let S_n(i) be its closed radius-n ball about i. Then S_n(i) is finite,
`S_n(i) subset S_(n+1)(i)`, and

    union_n S_n(i) = C(i).                                 (5.1)

Every nu-preserving permutation sigma satisfies
`S_n(sigma i) = sigma S_n(i)`.

**Proof.** An infinite threshold neighbor set would make the
nonnegative covariance row sum infinite. Thus G_n is locally finite.
Every finite-radius ball in a locally finite graph is finite, by
induction on radius; no uniform degree bound is needed. The thresholds
decrease, so G_n is a subgraph of G_(n+1), giving the asserted nesting.
Every edge of G_n is a nonzero-covariance edge, giving one inclusion in
(5.1). Conversely take any finite path from i to j consisting of
strictly negative covariance edges. Its finitely many positive edge
weights have a positive minimum. Choose n at least the path length
and with `2^(-n)` no larger than that minimum. The path lies in G_n
and j lies in S_n(i). Covariances, edge thresholds, and graph distances
are exactly transported by every law-preserving permutation. QED.

For a strongly Rayleigh law the sharper row bound is

    sum_(j != i) -Cov(X_i,X_j) <= Var(X_i) <= 1/4.           (5.2)

Thus every finite subset of G_n-neighbors has size at most `2^(n-2)`,
which also proves the neighbor set finite. In a product law the S_n(i)
are singletons. They need NOT exhaust I. Equation (5.1), not exhaustion
of I, is the conclusion used here.

Under (2.1), row summability follows even without (5.2). At t = 0 and
y = 0, differentiating the finite ratio gives gradient
`(Cov(X_i,X_j))_(j in S)`. Apply the Lipschitz bound in its gradient's
sign direction to obtain `sum_(j in S) |Cov(X_i,X_j)| <= L`. Since this
holds for all finite S, the countable row is summable. This uses
finite differentiation only, with no infinite external field.

## 3. Strongly Rayleigh finite-tilt response

**Lemma 6.** A strongly Rayleigh law satisfies (2.1) with L = 1/2,
including degenerate coordinates, empty observed sets, singular
determinantal examples, and arbitrarily large finite fields.

**Proof.** Fix finite J containing i and S. Its tilted law eta has
generating polynomial

    g_eta(z) = g_(nu_J)((exp(h_j) z_j)_j) / g_(nu_J)((exp(h_j))_j),

where `h_j = y_j-t/2` on S and zero otherwise. The denominator is
strictly positive and positive coordinate scaling preserves real
stability. Finite differentiation of the partition sum gives

    partial_(y_j) b_(i,S) = Cov_eta(X_i,X_j).                (6.1)

Use the symmetric homogenization from BBL, Definition 2.12 and
Theorem 4.2: extend eta on J to a strongly Rayleigh law on J plus
|J| dummy coordinates, with exactly |J| occupied coordinates and
unchanged J marginal. By BBL, Theorem 4.9, its distinct-coordinate
covariances C_ij are nonpositive. Constant total size gives

    0 = C_ii + sum_(j in J, j != i) C_ij
             + sum_(j dummy) C_ij.

Consequently

    -sum_(j in J, j != i) C_ij <= C_ii,
    sum_(j in J) |C_ij| <= 2 C_ii
                           = 2 p_i(1-p_i) <= 1/2.         (6.2)

Restrict this absolute sum to j in S, and integrate (6.1) along the
straight segment between the two finite fields. This proves (2.1).
For S empty the mean is constant. Every denominator is positive even
when the original law has zero atoms; no full-support assumption is
used. Applying the same argument to larger finite marginals at zero
field gives (5.2). These estimates are known (ABZ, Lemma 2.5 and
equation (1); earlier GLP, arXiv-v1 Lemma 3.2). QED.

The verifier checks the generic two-coordinate partition derivative
with all other fields held fixed and the exact polynomial identity
`1/2 - 2 p(1-p) = 2(p-1/2)^2`. These checks certify the algebra and
orientation, not the external real-stability theorems.

## 4. A posterior local to a covariance component

On a reference space let X have law nu, and independently let
`(B_i)_(i in I)` be IID standard Brownian paths. Set

    Y_i(t) = t X_i + B_i(t),
    H_t = sigma(Y_j(s): j in I, 0 <= s <= t).

For D a coordinate subset write H_t^D for the history restricted to D.
Use raw sigma-fields; no usual-filtration augmentation is assumed.

**Lemma 7 (full-filtration posterior locality).** For fixed i and
t >= 0,

    E[X_i | H_t] = E[X_i | H_t^C(i)] almost surely,          (7.1)
    lim_n b_(i,S_n(i))(t,Y(t)) = E[X_i | H_t] a.s.          (7.2)

**Proof.** Lemma 4 and the independent noises make
`sigma(X_C, B_j(s): j in C, s >= 0)` independent of the analogous
sigma-field on the complement, where C = C(i). If
`m = E[X_i | H_t^C]`, then for A in H_t^C and D in H_t^(I\\C),

    E[X_i 1_A 1_D] = E[X_i 1_A] P(D)
                  = E[m 1_A] P(D) = E[m 1_A 1_D].

The rectangles form a generating pi-system for H_t; monotone-class
extension proves (7.1). This proves locality for the FULL observation
history, not just for endpoints or for pairwise observation events.

For a finite S and t > 0, the conditional endpoint likelihood relative
to independent N(0,t) endpoints is

    exp(sum_(j in S) (y_j-t/2) X_j).

The binary identity `X_j^2 = X_j` accounts for the `-t/2`. The paths
`B_j(s)-(s/t)B_j(t)` are jointly independent of X and the endpoint
observations: at finitely many times this follows from zero Gaussian
cross covariances and independence from X, and rational-time
evaluations and continuity give path independence. Thus Bayes' formula
identifies (2.2) with `E[X_i | H_t^S]`, even if i is not observed.
At t = 0 both equal E[X_i].

By Lemma 5 the finite sets S_n(i) increase to C. Their history
sigma-fields therefore generate H_t^C. Bounded martingale convergence
gives almost-sure convergence of these conditional means to the local
posterior, and (7.1) gives (7.2). This is a fixed-time statement, not
an assertion of one exceptional set for all real times. QED.

Define on ALL real fields, using the product Borel structure,

    b_i(t,y) = limsup_n b_(i,S_n(i))(t,y).                  (7.3)

Finite ratios are continuous in their finitely many fields and in t,
so (7.3) is jointly Borel with values in [0,1]. From (2.1), for any
y,y' whose difference is bounded,

    sup_i |b_i(t,y)-b_i(t,y')|
          <= L sup_j |y_j-y'_j|.                          (7.4)

Indeed apply the finite bound in each direction and pass to limsups.
Neither field itself is assumed bounded.

If sigma preserves nu, changing variables in the finite ratio gives

    b_(sigma i, sigma S)(t, sigma y) = b_(i,S)(t,y).

Together with Lemma 5 this gives
`b_(sigma i)(t,sigma y) = b_i(t,y)` for every i,t,y,sigma.
There is no almost-sure qualification and no countable restriction on
the symmetry group.

## 5. Joint innovations

Define ordinary scalar time integrals

    W_i(t) = Y_i(t) - integral_0^t b_i(s,Y(s)) ds.          (8.1)

They exist on every continuous observation realization because the
integrands are Borel and bounded. W has continuous coordinates and is
adapted to H.

**Lemma 8.** The entire countable family W has product Wiener law.
For each finite coordinate subfamily its future increments after u
are independent of H_u.

**Proof.** For bounded H_u-measurable K and fixed s >= u, Lemma 7
gives `E[K b_i(s,Y(s))] = E[K X_i]`. Bounded Fubini integrates these
numerical identities over s, without choosing an all-time posterior
event. Brownian increments after u are independent of X and the
Brownian past, hence of H_u. It follows that

    E[W_i(v)-W_i(u) | H_u] = 0.                            (8.2)

For a finitely supported real vector theta, let
`l = sum_i |theta_i|`, `q^2 = sum_i theta_i^2`, h = v-u, and

    D = sum_i theta_i (W_i(v)-W_i(u)) = Q + R.

Conditioned on H_u, Q is centered Gaussian with variance `h q^2`,
and `|R| <= h l`. The two terms need not be independent. Conditional
Cauchy-Schwarz and `(a+b)^3 <= 4(a^3+b^3)` for a,b >= 0 yield

    |E[D^2 | H_u] - h q^2| <= 2 l q h^(3/2) + l^2 h^2,
    E[|D|^3 | H_u] <= 4(c_3 q^3 h^(3/2) + l^3 h^3),

where `c_3 = E|N(0,1)|^3`. Taylor's remainder for exp(ix), (8.2),
and the elementary exponential remainder imply, for 0 < h <= 1,

    |E[exp(iD) | H_u] - exp(-h q^2/2)| <= C_theta h^(3/2). (8.3)

The constant is deterministic. Subdivide [s,t] into N equal
intervals. Successive conditioning on their left endpoints, retaining
any initial event A in H_s, accumulates at most
`N C_theta ((t-s)/N)^(3/2)`, which tends to zero. Therefore

    E[1_A exp(i sum_i theta_i(W_i(t)-W_i(s)))]
        = P(A) exp(-(t-s) q^2/2).

Uniqueness of finite-dimensional characteristic functions proves the
independent Gaussian increment law for every finite coordinate set
and independence from H_s. Iterate in time. W(0) = 0; continuity and
rational evaluations determine its law in the countable product
continuous-path space. Thus its coordinates are independent standard
Brownian paths. QED.

This is the countable joint innovation proof, not an inference from
separate one-dimensional Brownian marginals.

## 6. Deterministic inversion on the unbounded product path space

Write `C_I = product_(i in I) C([0,infinity),R)` with the product of
compact-open topologies.

**Lemma 9.** If b is the bounded Borel drift (7.3) satisfying (7.4),
then for every w in C_I the integral equation

    Z_i(w)(t) = w_i(t) + integral_0^t b_i(s,Z(w)(s)) ds     (9.1)

has a unique continuous coordinate solution. The map Z is Borel,
causal, and commutes with every symmetry of b, on every input.

**Proof.** Set `Z^0 = w` and recursively replace Z in the integrand
by Z^k to define Z^(k+1). The bounded Borel integrand has continuous
indefinite scalar integrals. Induction using (7.4) gives

    sup_i |Z_i^(k+1)(t)-Z_i^k(t)|
        <= L^k t^(k+1)/(k+1)!,       k >= 0.               (9.2)

The first bound is t; when L = 0 interpret L^0 = 1. On each finite
time interval these bounds have finite sum, so the iterates converge
uniformly in coordinates and time in their DIFFERENCES from w.
The limit has continuous coordinates. The same Lipschitz bound gives
uniform convergence of the integrands and hence (9.1).

Any other solution z has `sup_i |z_i(t)-w_i(t)| <= t`. Repeating
the induction gives
`sup_i |z_i(t)-Z_i^k(t)| <= L^k t^(k+1)/(k+1)!`, tending to zero.
This proves uniqueness without treating a countable Brownian field
as an l-infinity-valued random variable or requiring a common
coordinate modulus of continuity.

The evaluation `(s,z) -> z(s)` is continuous into the countable
product real space. Parameter integration of bounded jointly Borel
functions shows inductively that all rational-time evaluations of
Z^k are Borel in w. They generate the Borel structure of C_I.
Passing to their limits proves Z Borel. The iteration uses only
earlier times, proving causality. Exact equivariance holds at every
iteration and hence at its limit. QED.

## 7. Sampling and every-input symmetry

Set

    Psi_i(w) = 1{limsup_(m -> infinity) Z_i(w)(m)/m > 1/2}.

This defines a Borel predicate even on inputs whose slopes fail to
converge. It is equivariant for every law-preserving permutation on
every input, since both Z and the coordinate readout are.

In the reference model, (8.1) makes Y solve (9.1) with input W on
every realization, simultaneously in time and coordinates. Lemma 9
therefore gives `Y = Z(W)`. Lemma 8 says W has product Wiener law,
so Z sends that law to the full joint observation law, not merely
the separate coordinate marginals.

For every positive rational delta,

    P(|B_i(m)| > delta m) <= 2 exp(-delta^2 m/2).

These probabilities are summable. Borel-Cantelli and the countable
intersection over i and delta give `B_i(m)/m -> 0` simultaneously
at all sites. Thus `Psi(W) = X` almost surely, identifying the whole
output law.

Finally there is an everywhere-defined scalar Borel map
`T : [0,1] -> C([0,infinity),R)` with Wiener pushforward. For
completeness, split binary digits into countably many infinite
subsequences with a fixed dyadic convention, apply Gaussian quantiles
with finite values at exceptional endpoints, construct independent
integer increments, and recursively insert dyadic midpoints

    midpoint = (left+right)/2 + sqrt(h)/2 * fresh_normal.

Gaussian covariances show independent increments on every dyadic
grid. On [0,K], the chance that the `K 2^p` refinement normals
include one of absolute value > p is at most
`2 K 2^p exp(-p^2/2)`, a summable sequence. Interpolations consequently
converge uniformly on compacts almost surely, since
`sum_p p 2^(-p/2) < infinity`. The convergence set is Borel by its
countable uniform Cauchy conditions. Take the continuous limit there
and the zero path elsewhere. The dyadic Gaussian laws and continuity
identify the Wiener pushforward.

Apply the SAME T separately at each coordinate and put

    Phi_nu(u) = Psi((T(u_i))_(i in I)).

This coordinatewise map commutes with all coordinate permutations on
all inputs, including exceptional scalar inputs. Combined with the
pointwise drift equivariance already proved, it gives the requested
identity simultaneously for the entire, possibly uncountable,
symmetry group. No union of group-indexed null sets was taken.
This proves Theorem 2 and, by Lemma 6, Theorem 1. The empty index set
has its unique empty input and output and is immediate. QED.

## 8. Comparison with the manuscript and adversarial audit

The strongest relevant staged result is the strongly Rayleigh theorem
for the regular left action of a countable group. Its proof chooses
`S_n(h) = h F_n`. The improvement here is not a better Lipschitz
constant or a new innovation theorem: it removes the regular-action
restriction, permits any countable coordinate set, and obtains one
map equivariant under the FULL permutation stabilizer of nu on EVERY
input. Component independence and intrinsic finite neighborhoods are
the additional mechanism. The proof does not claim simultaneous
Borel parametrization over all nu or arbitrary graph laws.

The staged manuscript was read in its entirety across the six section
files. Its load-bearing statements are recorded as M231_* claims and
decomposed in `research/PROOF_GRAPH.json`: weighted-tree response,
cycle-space free limit, finite tilts, canonical drift, posterior,
joint innovations, deterministic inverse, Brownian sampler, edge
noise, graph factor, strongly Rayleigh response, group theorem, and
determinantal corollary.

The sign checks retain the negative off-diagonal covariance sign,
the positive Bernoulli diagonal, the `-t/2` observation likelihood,
and the dummy-covariance inequality in its correct direction.
Regression cases include deterministic coordinates, singleton and
independent components, perfect negative two-site dependence,
weighted one-hot laws with arbitrarily chosen positive rational
fields, and a covariance-connected chain with a zero covariance
between some sites. The latter makes clear why a neighborhood must
use graph paths rather than only direct nonzero covariance.

No false literal manuscript assertion has been established here;
therefore no F_* refutation is manufactured. The failed shortcut
"these intrinsic balls exhaust I" belongs to the proposed extension,
not to the manuscript; its route is retired in the claim ledger
with the product-law obstruction. The repaired proof uses (7.1).
The even-parity counterexample only refutes the unassumed shortcut
from pairwise independence to block independence.

## 9. External inputs, originality, and certification boundary

The substantive external inputs for the strongly Rayleigh
specialization are exactly:

1. BBL `arxiv:0707.2340v2`, Theorem 4.9 and Definition 2.7:
   strongly Rayleigh implies CNA+, hence the negative association
   needed above after positive fields and projections.
2. The same version, Definition 2.12 and Theorem 4.2: stable symmetric
   homogenization with fixed total size and unchanged original
   marginal.

The known row estimate (ABZ `arxiv:2203.03935v2`, Lemma 2.5 and
equation (1)) and known stronger block-covariance inequality
(Proposition 2.2) are recorded in the ledger for correct attribution.
The proof above rederives the needed row estimate from BBL and gives
an independent formal proof of the zero-covariance independence
case. GLP `arxiv:1607.03036v1`, Lemma 3.2, is earlier row-sum prior
art; no unbounded-integer version of its bounded-polynomial
statement is invoked.

The primary-source reader inspected these version-specific passages;
`literature/primary_excerpts.md` records their statements and URLs.
The Engineer filed the assumptions, so the host Reviewer must supply
independent citation attribution. Registry resolution alone and this
file's existence are not such attribution.

Five targeted primary-source searches located no exact-strength
predecessor. That is a bounded unsuccessful search, NOT verification
of novelty. The covariance inequalities and block independence are
known, and the Brownian sampler closely follows the staged manuscript.
Only the full-symmetry extension/criterion is offered for a new-result
assessment. Publication significance and exact-strength originality
remain independent Reviewer decisions.

Outside Lean are: stability/negative-association and homogenization
inputs; the countable cylinder extension; row summability and
threshold-ball exhaustion; Gaussian bridge Bayes calculation;
full-history posterior locality; bounded martingale convergence;
joint innovation identification by characteristic functions; Borel
parameter integration; the uniform-difference Picard argument;
Gaussian tails and integer-time recovery; and scalar Wiener coding.
Sections 1-7 prove the latter steps in prose, not by formal
certification. Ordinary finite-sum algebra and finite locality alone
are machine-checked.

## 10. Reproduction

The official recorded run used Lean 4.31.0 and returned compiler
`exit_code = 0`, axiom-audit `exit_code = 0`, and `proof_holes = []`.
Its current-claim archive is
`certificates/C231_COVARIANCE_LOCALITY-798e7de33bc91c03.json`.
The generated exact certificate checks 37 symbolic identities and eight
finite regression models in addition to that quantified formal core.
An unused-section-variable warning is informational; there are no proof
holes or nonstandard axioms.

From the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/covariance_symmetry/verify.py

The verifier is deterministic. Its certificate separates exact
identities and the quantified Lean theorem from bounded examples and
unformalized analytic proof obligations. To obtain a fresh actual
compiler certificate (do not edit Main.lean or statement_fidelity.md
during it), use the installed command's POSITIONAL source contract:

    $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/covariance_symmetry/Main.lean --project-root . --claim C231_COVARIANCE_LOCALITY --statement-fidelity research/covariance_symmetry/statement_fidelity.md

The installed tool has no `--source` option. Certificates and compile
artifacts stay beside the source in the owned subtree. The required
campaign-root ledger and proof-graph checks must follow a recording
that changes either ledger. Independent Reviewer replay is still
required after Engineer handoff.
