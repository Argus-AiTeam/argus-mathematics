# Conditional long-route likelihood products

## Question and scope

The target is Lemma `long:product` in
`research/openai_manuscript/Quantum-Depletion-and-Momentum-Distribution-in-the-Dilute-Hard-Sphere-Bose-Gas-October-5-2026/build/sections/long-palm.tex`.
Both disjoint and shared changed sets must be addressed. The manuscript fixes
admissible exposed data and the outside of the union of the changed sets.
Its constants must not grow with route length. The thermodynamic limit precedes
the dilute limit, and the ground-state quantifiers are not weakened here.

The audit follows the actual conditional likelihood, the removal of cross
checks, retained midpoint sources, reference normalizers, and selected output
marginals. A finite probability model is not, without an embedding argument, a
counterexample to a conditioned Brownian construction. An order-one bound does
not verify the claimed near-unit disjoint estimate.

## Scoped prior facts

Peres and Sly, *Rigidity and tolerance for perturbed lattices*,
arXiv:1409.4490v1, Proposition 2.1 and its equations (2.3)--(2.4), prove a
route-averaged likelihood second-moment estimate for independent perturbed
lattice coordinates. Their factorization explicitly uses product measures.
That statement does not establish factorization for interacting conditioned
bridges, retained midpoint sources, or the near-unit error required here.
The primary text was obtained at <https://arxiv.org/html/1409.4490v1>.

The supplied project Wiki index has no matching Palm, likelihood, Peres--Sly,
Brownian, or depletion entry. No prior result in the current campaign ledger
settles this scoped lemma. Independence before conditioning and a finite model
without a faithful source map are insufficient routes, not accepted
refutations.

## Result and its boundary

The conditional likelihood argument in `long:product` admits a source-retaining
verification. Below is a proof of an abstract comparison theorem, its
application to **both** manuscript cases, and a sharp multi-output extension.
The delicate separation is valid only after the right pins have been
integrated out. No independence between a pin and its own latent source is
asserted or needed.

This is a **conditional verification theorem**: the local Brownian insertion
and collision estimates listed below are explicit inputs, not conclusions of
the finite replay or Lean compilation. It is not a refutation, not an
unconditional certification of the full gas theorem, and not a claim that a
finite model embeds into the Brownian law. Independent review, novelty, and
publishable significance remain to be adjudicated by the Host's Reviewer.
No false literal manuscript assertion has been established in this audit, so
no artificial `F_` refutation claim is introduced.

## 1. Analytic inputs and exact reference law

Work on one good exposed-data fiber and fix an admissible outside of
`U = S union T`. The following inputs are used.

1. `lp:conditional-law`: the reference on `U` has law
   `A_U B_U / Z_U`, with product free bridges `B_U` and `Z_U > 0`.
2. `lp:insertion`, first assertion, including its check-deletion quantifier:
   insertion of one original against any indicated subset of allowed
   opponents has probability at least `c0 = 3/4`.
3. `lp:collision`: an individual removed check has free failure probability
   at most a fixed multiple of its endpoint cost `beta`; a pinned trial
   has the additional cost `b_D/(s vee distance(y,X_k(0)))` on the support
   of its separated pin. A uniform-midpoint proposal has the corresponding
   integrated endpoint-cost bound.
4. `lp:insertion`, third assertion: every middle-pair acceptance probability
   is at least `1/2`, uniformly in preceding allowed history. Pin divisors
   are capped below by `1/2`, irrespective of whether a prescribed pin
   succeeds.
5. Free midpoint densities are Gaussian with covariance `t I`.
   Middle primary density domination is `C D^(Cx) B_l`. For neighboring
   labels on the retained range,
   `g_source/g_output <= C D^(C sqrt(x))`.
6. Route simplicity, confinement, and the specified neighboring-site
   enlargement bound the number of affected checks by `C J_*` and their
   degrees by an absolute constant, independent of route length.

Items 2--4 are local analytic estimates, not consequences of independence.
Their proofs in `local-paths.tex` were read; this work does not replace them
by finite tests. In particular, the full-path event is **not** added to the
conditional latent law. It is used by `long:mass`, not as an extra hypothesis
on the originals in the product proof.

For fixed outside `o`, the unnormalized output is

```
M_S(o; dz) = integral A_S(x;o) h_j(x) K_S(x,o;dz) B_S(dx).
```

Both the conditional input and admissible conditional reference output
divide by the same `Z_S(o)`. Hence the output likelihood on reference support
is `dM_S/dB_S`, not `dM_S/(Z_S dB_S)`. The later conditional product integral
has exactly **one** divisor `Z_U`. This proves the claimed cancellation
without treating input normalizers as route-independent constants.
The common retained first tag is outside both changed sets, so its
stripped first-tag factor is fixed in this conditioning. The original
second-tag indicators remain in their own latent integrals.

## 2. Which dependencies are actually removed

For one left-observed transport the changed set is
`S = {i_k : k >= a0}`. Keep the entire original construction until its right
prefix pins, then integrate these kernels. They have mass at most one.
They follow the middle steps, and the left suffix pins do not use them.
Consequently their removal enlarges the left output measure.

Now remove every old opponent with label in `T minus S` from the `S`
protocol and its reference checks. Its endpoints remain fixed exposed
data when that label also names a generated right path. The following
table is a read-dependency map, not an assumption of coordinate independence.

| Object in the enlarged separate `S` protocol | Remaining random inputs |
|---|---|
| Latent reference indicator and original tag | Original paths with labels in `S`; fixed outside of `U` |
| Middle unit cell and bridge endpoints | Exposed endpoints only |
| Middle primary and auxiliary proposal | Its fresh shared midpoint, its independent legs, earlier generated history in this protocol |
| Checks of a generated path | This protocol's retained originals and earlier generated paths; fixed outside of `U` |
| First right middle path at the prefix seam | Its fixed endpoints, not its deleted old trajectory |
| Left suffix pin with output `i_k`, `k >= a1+2` | Midpoint of latent original `i_(k-1)` |
| Right prefix pins | Absent from the enlarged kernel |

The retained originals that source left pins have indices
`a1+1,...,m-1`, all in `S`. Distinct left pins have distinct source labels.
The generated middle primary with a source's *label* is not that latent
original: input and output variables are different copies. Deleting an old
obstacle never deletes a source from this retained suffix.

Thus, for disjoint `S,T`, the two separate extended measures factor
conditional on the fixed outside of `U`. For intersecting sets their
latent copies are still separate; only the common **output** coordinates
are identified when multiplying likelihoods. One must not identify their
latent variables merely because their label names agree.

## 3. Reference normalizers

Here and below absorb the fixed constant in the collision bound into `beta`.
Let `B` be the sum of removed cross-check costs, and assume each
`beta/c0 <= 1/2`, as holds for large `D`.

For disjoint sets the reference after deletion has normalizer
`Zminus = Z_S^- Z_T^-`. Add the cross checks one at a time. Conditional on
every path but one endpoint label, that label's law is at most
`c0^-1` times its free bridge, even after arbitrary earlier check removals.
The check's conditional failure probability is therefore at most
`beta/c0`. Consequently

```
1 <= r := Zminus/Z_U
  <= product_edges (1-beta/c0)^(-1)
  <= exp(2 B/c0).
```

Positivity follows by successive one-path insertion; no joint normalizer
is bounded below by a constant independent of the number of paths.

For any `0 <= H <= 1`, including the product of the original tag indicators,

```
0 <= integral H(Aminus-A_U) dB_U / Z_U <= r-1
   <= (2 B/c0) exp(2 B/c0).                         (1)
```

The sharper first inequality is pure algebra and is proved in Lean as
`deleted_check_tag_error`.

For overlap `A = S intersection T`, `q = |A|`, delete the `q` labels from
both separate reference integrals. Each resulting integral increases.
The two remaining changed sets are disjoint. Restoring the shared labels
to the joint reference costs at most `c0^-q`, because each one has
insertion probability at least `c0`. Therefore

```
Z_S^- Z_T^- / Z_U <= c0^(-q) exp(2 B/c0).          (2)
```

Only the selected shared labels, not the route length, are charged.

## 4. Sequential kernels and retained-source marginals

**Selected-output theorem.** Let a latent law be followed by any finite list
of subprobability kernels with auxiliaries. At each selected stage suppose
its primary marginal is bounded by `a_r nu_r(x;dz_r)`, uniformly in preceding
history, where `nu_r` depends on the latent input but not that history.
Then the joint selected-output law is bounded by

```
(product_selected a_r) integral mu(dx)
                             product_selected nu_r(x;dz_r).           (3)
```

Proof: test against a nonnegative function of selected primaries. Integrate
stages backwards. An unselected stage costs its mass bound one. At a selected
stage integrate its auxiliaries and use its primary marginal bound. The
replacement is independent of the erased history. Induction proves (3);
nonnegative integration handles arbitrary measurable tests. The finite
operator version, for arbitrary list length and state spaces that retain
all history, is `selected_route_bound` in Lean.

For a selected middle primary use `nu_r = B_l` and its middle density cost.
For a selected left pin retain the **conditional bridge kernel**

```
nu_r(x;dz_l) = 1_range(y) B_l(dz_l | z_l(0)=y),
y = midpoint of latent source a(l).
```

There is no full two-copy domination by independent bridges: the proposal
has equal midpoints. Its auxiliary is integrated only at the appropriate
backwards step.

For `p` selected pins the `p` sources are distinct. Their joint latent
marginal is at most `c0^-p` times the product of their free bridges:
iterate the history-uniform one-path conditional density bound. Integrate
each source except its midpoint, then use

```
integral 1_range(y) g_a(l)(y)
          B_l(dz_l | z_l(0)=y) dy
    <= C D^(C sqrt(x)) B_l(dz_l).
```

Together with (3), this proves the selected `q`-output bound

```
M_S^- / Z_S^-  projected to Q  <= G_D^q B_Q,
G_D = C D^(C sqrt(x)).                            (4)
```

It holds with tags included or discarded and with arbitrarily many
unselected outputs. It does not assert independence within one protocol.
`source_mixture_bound` certifies the finite source-integration implication.

Source injectivity matters: one fair latent bit copied into two outputs
has uniform single-output marginals but density two on the diagonal
relative to two independent fair bits. Thus a bound with `G=1` fails
for their joint output. The replay includes this example solely as a
boundary of the abstract theorem, **not** as a manuscript counterexample:
the manuscript's retained suffix sources are injective.

## 5. Transition comparison and the near-unit disjoint theorem

At the same latent input and generated history, deleting old opponents
preserves the unconditioned proposal. If `p <= pminus` are middle
acceptance probabilities, then `p >= 1/2` and
`pminus/p <= 1+2(pminus-p)`. A pin uses
`w=max(1/2,p)`, and its ratio is bounded the same way because the maximum
function is increasing and 1-Lipschitz. Deleted preliminary separation
indicators can only enlarge the separate kernel.

The difference `pminus-p` is estimated before conditioning the proposal.
The union bound uses endpoint costs for a middle proposal, and endpoint
plus midpoint costs for a separated prescribed pin. Each removed check
is paid a bounded number of times. Hence the product of transition
ratios is bounded by

```
R <= exp(C(B+M)),
R <= 1 + C exp(C gamma J)(B+M),
gamma = D^(-19/100),  B+M <= C gamma J.             (5)
```

Unaffected stages have ratio one, even if the route has arbitrarily
many stages.

Here is the remaining integration step in explicit form. Let `P_S,P_T`
be the two normalized, tagged, separate extended measures; each has mass
at most one. For a midpoint-cost edge, `y` is a latent source of `P_S`
and `X_k` is an output of `P_T`, or vice versa. By Section 2 these two
measures factor in the disjoint case. For any fixed `z`,

```
integral g_l(y)/(s vee distance(y,z)) dy
 <= ||g_l||_infinity integral_|u|<=1 |u|^(-1) du + 1
 <= C(1+t^(-3/2)).                                (6)
```

The integral near zero is finite in dimension three (`2 pi` in Euclidean
coordinates); outside the unit ball the reciprocal is at most one.
Confinement restricts to a bounded local region; sufficiently large tori
use its Euclidean lift. The latent source marginal adds only `c0^-1`.
Integrating all of that protocol's generated transitions costs one.
The opposing output measure then needs only its total mass bound, **not**
a midpoint density bound. This is the finite implication
`cross_source_bound` in Lean.

**Source-retaining disjoint comparison theorem.** If the normalizer
comparison (1), the protocol separation of Section 2, the transition
increment (5), and the source-cost bound (6) hold, then, with `n` midpoint
edges,

```
E[L_S L_T | U^c]
 <= E[h_j h_j' | U^c] + (r-1)
    + C r exp(C gamma J) (B+n b_D(1+t^(-3/2))).
```

Proof: express the original product with one `Z_U` divisor and two
separate latent copies. Bound it by the deleted-check integrand times
(5) and drop union output admissibility. The term one integrates to the
separate original tag integral, bounded by the original reference tag
expectation plus (1). The constant `B` term costs only the two separate
masses. For each midpoint term use (6) on its latent-source side,
without decoupling that source from its own generated paths. Multiply
by `r` to undo separate normalization.

For this disjoint calculation the extended dominating measure is the
product of the two separate latent/proposal measures. Deterministic
pin/source equalities remain inside their respective factors. No density
of a pin conditional on its source relative to a free bridge is required.

Here `n <= C J_*`, `r <= exp(CB)`, and `B <= C gamma J`.
Absorbing these exponents gives exactly `long:disjoint-product`.
In particular, when there are no affected cross checks, the error is
zero, not an order-one replacement.

## 6. Shared changed sets and a sharp multi-output extension

For shared sets, first apply the uniform exponential comparison in (5)
to **each mixed output measure**, at fixed opposing unshared outputs,
before multiplying likelihood densities. Fubini gives these density
inequalities almost everywhere for the union free reference. This avoids
ever multiplying two conditional delta kernels on a shared output.
Write the separate output measures as
`Z_S^- f_S B_S` and `Z_T^- f_T B_T`. Free output integration gives the
**identity**

```
integral f_S(z_S) f_T(z_T) dB_U
  = integral f_S,A(z_A) f_T,A(z_A) dB_A,           (7)
A = S intersection T.
```

No product structure of either `f_S` or `f_T` is assumed. The density
bound (4) makes one marginal at most `G_D^q`, and the other has integral
at most one. Thus the right side is at most `G_D^q`. Equation (7) and
its inequality are `marginal_product_identity` and `shared_output_bound`
in Lean. Multiplying by the normalizer ratio (2), and absorbing
`c0^-q` in the fixed constant of `G_D^q`, proves
`long:shared-product`. Independent latent copies remain independent
through this calculation; only their output coordinates are glued.

There is a useful exact higher-order extension of (7). Let `S_1,...,S_m`
be finite coordinate subsets of a product probability space. Let
`f_i >= 0` have mass at most one and every selected marginal on
`A subset S_i` be bounded by `G^|A|`, with `G >= 1`. Then

```
integral product_i f_i(z_S_i) dB_union
  <= G^(sum_i |S_i| - |union_i S_i|).              (8)
```

Proof by induction on the number of factors: integrate the coordinates
private to the last factor. Its resulting marginal, on
`A=S_m intersection union_(i<m) S_i`, is bounded by `G^|A|`.
Remove it and apply induction. The exponents add because
`|union_(i<=m) S_i| = |union_(i<m) S_i| + |S_m minus union_(i<m) S_i|`.
For one factor use its mass bound. All operations are nonnegative
integrations, so no additional integrability premise is hidden.

The exponent is sharp: in each coordinate choose an event of probability
`1/G` and take `f_i = G^|S_i|` on the product of these events, zero
elsewhere. Every marginal saturates its bound, and the left side of (8)
is exactly the displayed power. For rational/integer `G` the replay
checks this equality for disjoint, cyclic, nested, and multiple-shared
patterns. Those evaluations illustrate the proof, not replace it.
This extension is an output-density theorem, **not** a higher-moment
Brownian theorem: multi-protocol reference and transition comparisons
would still have to be proved.

## 7. Dependency map and what has improved

| Manuscript assertion | Work done here | What remains an input |
|---|---|---|
| `long:exact-likelihood` | Same-normalizer cancellation, with one union divisor in products | Correct conditional bridge representation |
| Separate protocols, prefix seam | Explicit read-dependency and retained-source map | The stated construction and deterministic order |
| `long:normalizers` | Sequential check restoration, exact tag-error bound, shared-label deletion | Uniform one-path insertion and collision estimates |
| `long:transitions` | Probability/capped-divisor comparison, only affected factors paid | The local collision costs and contact graph |
| `long:kernel` | Backwards proof; arbitrary-length finite operator theorem in Lean | History-uniform primary marginal bounds |
| `long:shared-density` | Source-preserving mixture argument; injectivity justified | Middle free-bridge density and neighboring Gaussian ratio |
| `long:product`, disjoint | Source-versus-opposing-output integration and near-unit error | Inputs in Section 1 |
| `long:product`, shared | Exact overlap identity and marginal bound | Same inputs |
| `long:comparison` and `asm:infrared` | Dependency only; no new unconditional certification | Mass estimate, route averaging, count estimates, and all later arguments |

Compared with the scoped Peres--Sly independent-coordinate factorization,
the improvement is explicit control of **conditioned** normalizers, a
source-retaining sequential construction with singular coupled
midpoints, and a zero-cost treatment of unselected stages. The near-unit
disjoint error and overlap power are derived separately rather than
replaced by one global density bound.

The primary-source novelty lookup did not establish novelty. In particular,
Livshyts--Paouris--Pivovarov, arXiv:1507.07949v2, Theorem 1.1 concerns
orthogonal projections of product densities. Its obtained statement does
not supply (8) or the conditional-kernel argument. A search-generated
attribution of the precise overlap exponent to that paper is not used.
Neither (8) nor the elementary kernel arguments are represented as newly
discovered literature results. The candidate contribution is the
source-faithful, formally supported verification of this manuscript
choke point; publication-level novelty remains open.

## 8. Exact replay and independent-review boundary

Run `python3 research/long_palm_product/verify.py`. The replay uses
`fractions.Fraction` throughout its mathematical calculations. It checks
normalizer cancellation, deletion errors, history-dependent middle
acceptances, deterministic retained-source pins, pointwise protocol
comparison, disjoint near-unit inequalities, one- and two-shared-output
products, source-cost integration, and the sharpness examples for (8).
Its finite construction keeps the two latent copies separate.

For clarity, the finite fixtures have independent Bernoulli free
coordinates of rare mass `epsilon`, for
`epsilon = 1/16, 1/32, 1/64`. Compatibility forbids a pair of ones.
The disjoint reference on `(a,j,b,k)` has edges
`aj,bk,ab,jk`; the one-shared-label reference is the triangle on
`(a,j,k)`; the completely shared reference has one internal edge.
Every subset of reference checks and every fixed outside assignment is
tested for the one-coordinate insertion lower bound `3/4`.

A protocol's middle proposal has rare mass `2 epsilon`; its primary and
auxiliary midpoints are equal. It is rejected if it conflicts with its
retained latent source or the indicated opposing old path, and divided
by its exact success probability. Its next primary output is pinned
deterministically to the first latent coordinate. A failing opposing
midpoint test gives zero pin mass. Tags are the indicators that the
second latent coordinate is zero. Deleting the opposing checks defines
the separate protocol, without changing its source or proposal.
The source cost tested is `1/(1/4+|source-opposing_midpoint|)`.
All selected marginals are checked with the rational bound `G=3`.
The no-cross-check disjoint fixture has **exactly zero** error. At
`epsilon=1/16`, the own pin/source joint event of both being one has
probability `1/17`, whereas the product of those marginals is `1/289`:
the model genuinely retains the problematic within-protocol dependence.
These objects satisfy the explicit *finite theorem* hypotheses; they
are not claimed to satisfy Brownian path hypotheses.

The Jacobian adapter's bounded conditional-expectation operation is
preserved in `jacobian_payload.json`, `jacobian_output.json`, and
`jacobian_status.json`, including its operation id, exact rational
payload, server/protocol versions, typed output, and measured adapter
status. It computes a three-atom example showing that conditioning can
destroy independence; it supplies no evidence against the Brownian
manuscript.

`Main.lean` proves the universal finite algebraic implications described
in `statement_fidelity.md`; it is not merely a proof about the chosen
rational examples. Its compiler certificate must be fresh for both files
and have zero proof holes. The Engineer's evidence and opinions do not
constitute independent review. The Reviewer must read the source map
and analytic-input boundary, replay the evidence, and decide whether
this conditional verification meets the mission's significance bar.

The Peres--Sly background citation was filed by the Engineer and still
requires independent source attribution on `C_LPP_IID_SCOPE/A_PERES_SLY`.
The obtained proposition and product-factorization sentence are retained
in `peres_sly_excerpt.txt`. Neither this background citation nor the
unresolved novelty lookup is a premise of the comparison proof.
