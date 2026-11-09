# Global verification of the entropy counterexample

## Result and scope

The frozen released theorem has the conventional mathematical conclusion:
there is a noninvertible `C^1` self-map of the nonempty compact smooth
boundaryless manifold

    S^1 x (S^2)^4, of dimension 9,

with ordinary topological entropy zero and eigenvalue `2` on genuine
second real singular homology. Its conventional total homology spectral
radius is in fact **exactly 2**. The released raw map is a permissible
three-register specialization of the staged construction, not an
unrelated witness with merely the same theorem name.

This report supplies the definition bridges and an independent global
argument using the already reviewed arbitrary-duration passage theorem.
It does not assert a new existential counterexample, a new full Lean
formalization, or a new arbitrary-finite-regularity extension. Global
statement fidelity and publication-level acceptance still require the
Host's independent Reviewer. No false staged manuscript assertion was
identified; consequently there is no invented `F_` refutation claim.

## Frozen primary evidence and prior work

The released source used here is **OpenAI
`fd4aeeb2ee4fc729c18d98444fed42fd0529eeeb`**, not mutable `main`.
`upstream/Counterexample.lean.txt` proves
`OAI.Problem340.exists_C1_entropy_counterexample` by
`CounterexampleAssembly804.exists_counterexample` in `Assembly.lean`.
The latter discharges the sphere homology and bounded-spectrum inputs
of `MapFinalReduction.exists_counterexample_of_sphere_and_base_homology`;
they are not hypotheses left on the final existential theorem.

The publisher's immutable revision
`nealmcb/openai-math-lean-tooling@a64864be75cc48d1e21d6d02198b3fa231c888e4`
contains `MANIFEST.txt` and `results/cmp-all/all.jsonl`. Line 296 of the
log accepts this solution, one theorem, under Lean **4.34.1**, with
`build_exit=0`, `build_skipped=true`, and `nanoda=false`. The manifest
identifies that OpenAI commit and Mathlib
`d13f23b723b8a846827a245b89c10fc7d3f11612`. The challenge has no definition
holes and permits only `propext`, `Quot.sound`, and `Classical.choice`.
This is reused historical checking, not an independently repeated build
or an additional nanoda verification. Exact URLs, bytes, source blob
identities, and the complete accepted record are retained in
`primary_sources/`.

Gogolev's primary expository note, internally dated October 11, 2026,
already states in its abstract the counterexample for every finite
regularity `r >= 1` on `S^1 x S^2 x S^2 x S^2`. Section 4, equation
(4.1), chooses `R > ||DG||^r` and develops the signal series. The note
also explicitly observes homotopy to `(t,z^2,0,0)` and `rho(f_*)=2`.
Neither finite regularity, the seven-dimensional model, nor exact
spectral radius 2 is claimed as new here. The PDF URL is mutable: the
retrieved, internally dated bytes are pinned separately. We use its
abstract and Section 4 as prior-work evidence, not as the proof of the
staged map.

These findings are recorded as `C_RELEASE_PRIMARY`, `C_GOG_PRIOR`, and
the explicit historical-check assumption of `C_GLOBAL_STANDARD`.
The strongest prior result is already the full released formal theorem
and Gogolev's stronger regularity exposition. The improvement over the
previous campaign milestone is closure of its **global interpretation
and proof obligations**, not an improvement over those existence results.

## 1. The manifold and the meaning of C1

`Definitions.lean` defines the clock as the unit sphere in real
two-dimensional Euclidean space, each two-sphere as the unit sphere in
real three-dimensional Euclidean space, and the manifold as their
finite product. These are the actual embedded spheres with their usual
subspace topologies, not abstract types equipped with chosen properties.
Closedness and boundedness in finite-dimensional Euclidean space imply
compactness; unit coordinate vectors give nonemptiness.

Near any point of a unit sphere, choose a nonzero coordinate. Projection
off that coordinate has smooth inverse with missing coordinate
`+sqrt(1-||u||^2)` or `-sqrt(1-||u||^2)`, on an open ball. These charts
give the usual smooth structure without boundary. Product charts have
dimension `1+2(q+1)=2q+3`; the released witness has `q=3`. The standard
clock parametrization is `t -> (cos(2*pi*t/100),sin(2*pi*t/100))`,
identifying it smoothly with `R/100Z`.

`IsC1SelfMap q f` consists of continuity plus, at every source point, an
open ambient neighborhood and an ambient `ContDiffOn R 1` map `F`
agreeing with `standardEmbedding (f y)` on the embedded manifold.
This **implies conventional C1**: use the displayed source charts and
project to the target chart coordinates, after shrinking into a target
hemisphere using continuity. Both are restrictions of smooth ambient
maps; their composition with `F` is C1.

Conversely a conventional C1 map has this local extension property.
On the ambient open set where every sphere block is nonzero, normalize
each block by its norm. This is a smooth retraction onto the product
of spheres. Locally compose this retraction with the embedded C1 map.
Extend the resulting ambient function arbitrarily outside its open
domain; the definition requires C1 only *on* that domain. Thus the
released regularity definition is not a weakening.

One must not infer differentiability from `modelHomeomorph` alone.
`MapC1Complete.exists_threshold_isC1SelfMap_realizedMap` instead proves
the actual local ambient extension property for every sufficiently
large gain, and `exists_isC1SelfMap_realizedMap` chooses `L=B+3`.
No construction-regularity premise remains open.

## 2. Ordinary entropy, not a substitute

In the pinned Mathlib `CoverEntropy.lean`, `coverMincard` is the minimum
cardinality of a dynamical cover, `coverEntropyEntourage` is its
limsup exponential growth, and `coverEntropy` is the supremum over
uniform entourages. On a compact metric space the entourages
`d(x,y)<epsilon` are cofinal. Its dynamical cover is precisely a cover
by the orbit metric

    d_n(x,y) = max_{0 <= j < n} d(f^j x,f^j y).

Let `r(n,epsilon)` be the least number of open orbit balls of radius
`epsilon` covering the whole space, and let `s(n,epsilon)` be the
largest cardinality of a set with distinct orbit distances
`>epsilon`. Compactness and continuity make these cardinalities finite.
A maximal separated set covers by closed epsilon-balls, hence by open
`2*epsilon`-balls; an open `epsilon/2`-ball contains at most one member
of an epsilon-separated set. Therefore

    r(n,2*epsilon) <= s(n,epsilon) <= r(n,epsilon/2).

Taking logarithmic limsups divided by `n`, and then the supremum as
epsilon tends to zero, identifies the two definitions exactly. The
`EReal` codomain handles infinite entropy and the empty set; our space
is nonempty and the asserted value is the ordinary real number zero.
Its compact-space uniformity is the metric one. No alternative entropy
or discarded initial transient is involved.

`MapEntropyComplete.coverEntropy_realizedMap_eq_zero` is unconditional
for every `L>2`: it supplies the proved orbit alternatives to the entropy
reduction. Its transported raw map is topologically conjugate, so entropy
is unchanged.

## 3. Genuine singular homology and its spectral radius

`RealSingularHomology n X` is literally the value of Mathlib's
`AlgebraicTopology.singularHomologyFunctor (ModuleCat R) n` with
coefficient module `R`. The pinned implementation constructs the
singular chain complex from `TopCat.toSSet` and the alternating-face
chain complex, then applies the degree-n homology functor. In modules
this is the usual free real chain module on singular simplices, the
alternating boundary, and `ker boundary / im boundary`.
`realHomologyMap` is the functor's actual map of the given continuous
function. It is not a user-provided action or a surrogate vector space.

There is a real issue to check in the custom spectral-radius definition:
it takes the supremum, over *all* degrees, of numbers `sqrt(a^2+b^2)`
with a nonzero real pair satisfying

    Au = a*u - b*v,     Av = b*u + a*v.                 (1)

For any real matrix these equations are exactly

    A_C (u+i*v) = (a+i*b)(u+i*v).

The vector on the right is nonzero exactly when at least one of `u,v`
is nonzero, and `|a+i*b|=sqrt(a^2+b^2)`. No real-linear independence
of `u,v` is needed: taking `v=0,b=0` includes real eigenvalues.
The converse follows by real and imaginary parts. The plus sign is
important. These equivalences are independently kernel-checked for
every finite real matrix in the new Lean 4.31.0 claim `C_PAIR_BRIDGE`.

For this product of spheres, real singular homology is finite
dimensional and zero above `2q+3`; the calculation in Section 6 below
also proves this directly. The union in the released definition is
therefore a finite nonempty set of eigenvalue moduli of the complexified
graded action, exactly those of its total direct sum. Its real supremum
is the conventional spectral radius. In particular it is bounded:
there is no misuse of a conditionally complete `sSup` on an unbounded
set. Below we compute this very set as `{0,1,2}` for `q>=1`.

## 4. The released witness and the staged update

`Map.lean` has raw space
`AddCircle 100 x (OnePoint C x (Fin 3 -> OnePoint C))`. Its `rawMap`
uses the old state in **every** component. `MapData.concreteData`
instantiates the gate, preparation cutoff, saturation, gain, and gain
parameter. `RealizedConstruction.realizedMap` transports precisely this
map by `modelHomeomorph` onto the embedded product, and
`MapRealizedHomology.exists_counterexample_of_concrete_obligations`
selects `q=3`.

The series is not truncated. Set `m=n+1` in `Map.inputTerm`:
`(L^(-1))^n=L^(1-m)`, `predictedClock (n+1)=T_m`, and
`2^(n+2)=2^(m+1)`. `baseInput` has the prefactor `alpha/10`.
The prediction uses the unperturbed square and the **nonperiodic**
readout coefficient; only the outer input is lifted periodically.
The main readout is `20 sum beta_l(t) S(v_l)`. Thus compensation,
phase exponent, clock prediction, periodicization, and simultaneous
timing all match the staged update.

The concrete data satisfy the staged choices:

| Released source | Staged condition |
|---|---|
| `Clock.barrier`, `barrier_stops`, `barrier_plateau`, `barrier_eq_zero_iff` | smooth periodic barrier, speed one away from 50, zero exactly at 50, and no small-radius crossing of 50 |
| `ReadoutCover.preparationCoeff` | support `(8,12)`, plateau `[9,11]` |
| `readoutCenter i=76+i/2`, bump inner radius `1/4`, outer radius `2/5` | three width-`4/5` readouts in `(74,80)`, plateaus covering `[76,77]` |
| `SphereCutoffsAffine` | gate zero through radius `1/2` and one from `3/4`; preparation cutoff one on `[1/2,1]`, zero near both poles |
| `Saturation`, parameter `3L` | identity on the closed unit disk, norm at most `2<=3`, nondecreasing radial profile on `[0,3L]`, zero at sufficiently large radii |
| `GainProfile` | gain zero on `[2,5]`, equal to `L` on `[7,90]` |

Closed supports cause no endpoint exception: `ReadoutCover` additionally
bounds the closed support by radius `9/20`, still of width less than one.
The trigonometric clock barrier differs from the manuscript's illustrative
local-cutoff formula, but satisfies its stated **choice conditions**;
the manuscript did not fix that illustrative formula as its only map.

Thus the release is not byte-for-byte the particular displayed example
of every cutoff, but it is a member of the same allowed staged family.
Even without this identification, Sections 1-3 would establish the same
existential conclusion by an alternative witness. Sections 4-6 and the
reviewed passage mechanism are what justify the stronger assertion here:
verification of the staged update itself, for all its admitted choices.

## 5. Closing the global analytic and dynamical obligations

**Regularity.** On `R x Sigma`, the unperturbed prediction map is smooth
and periodic modulo 100, so its derivative has a uniform bound `B>=1`
by compactness of one period times the sphere. The chain rule gives
`||DT_m||<=B^m`. On the fixed compact annulus supporting `chi`,
`Phi_k=chi(z)(z/|z|)^k` has derivative bounded by `C(1+k)`.
The product rule, crucially a **sum**, not a product of the two growth
costs, gives for the m-th input summand

    ||F_m|| + ||DF_m|| <= C L^(1-m)(1+B^m+2^(m+1)).

All three geometric series converge when `L>max(B,2)`. Uniform
derivative convergence on finitely many relatively compact source
charts gives a C1 limit: integrate the derivatives of the partial sums
along line segments in smaller coordinate balls and pass to their
uniform limits. The input is identically zero near the periodic seam
and near both poles, so these chartwise limits glue with no hitting-time
regularity assumption. The input norm is at most `L/(10(L-1))`.

Registers therefore always land in the finite disk of radius
`3L+L/(10(L-1))`. All components other than the main pole are manifestly
C1. For `C(t,v)=20 sum beta_l(t)S(v_l)`, `|C|<=60q`. At the main
infinite pole, `w=1/z` gives the jointly smooth expression

    w' = w^2/(1+C(t,v)w^2).

For `|w|<[2(60q+1)]^(-1/2)` the denominator has modulus greater than
`1/2`, uniformly in all other variables. This closes `C_REGULARITY`,
including source poles and every seam.

**Attraction.** A nondecreasing bounded lifted clock converges to `t_*`.
Its increments tend to zero; since they dominate `b(t_n)`, continuity
and the exact zero set force `t_*=50 mod 100`. Eventually there are no
readouts. Also eventually `|z_n|<3/4`, since a larger radius, including
infinity, would give clock increment one. Thereafter exact squaring
gives `|z_(N+r)|=|z_N|^(2^r)->0`. The unrestricted registers are already
included in `Z_0`.

For an unbounded lift and finite main coordinate, take any complete
passage. The independently reviewed `C_PASSAGE_CORE` gives a time with
radius greater than one and the square lower bound through that
passage. Between that passage's readouts and the next preparation there
are no readouts, hence exact squaring, regardless of old registers.
The next reset precedes the next preparation. Apply the same reviewed
theorem afresh in each later complete passage. These intervals cover
**all** subsequent times, so

    |z_(N+r)| >= |z_N|^(2^r) -> infinity.

No vanishing of `chi` immediately beyond radius one is assumed. Once
escape actually reaches its zero neighborhood, all later inputs vanish;
a later reset makes every register permanently zero. If the main
coordinate starts at infinity it stays there, the clock has speed one,
and a reset erases the registers directly. Thus every orbit approaches
the exact compact forward-invariant set

    Z_0 = {clock=50, z=0, arbitrary registers},
    Z_infinity = {arbitrary clock, z=infinity, zero registers}.

This closes bounded clocks, successive passages, and `C_ATTRACTION`.
The sealed passage source, fidelity document, and certificate are not
modified or recompiled. Their already recorded independent judgement,
not the older summary certificate's stale pending-review flag, is used.

**Entropy.** On `Z_0` the registers are independent copies of `v -> L S(v)`.
Their first image is in the disk `D_(3L)` and the radius map there is
continuous and nondecreasing. Partition radii into `H` ordered small
intervals and angles into `K` small arcs. Length-N radius itineraries,
ordered by the initial radius, form a coordinatewise chain in
`{1,...,H}^N`. The sum of coordinates increases by at least one at every
change; there are at most `1+N(H-1)` itineraries. The angle is constant.
A finite cover at time zero includes all sphere preimages, so for a
constant `C_epsilon` the q-register separated cardinality is bounded by

    C_epsilon { K [1+(n-1)(H-1)] }^q.

Its exponential rate is zero. On `Z_infinity` the clock rotation has
period 100, also giving zero entropy. Splitting separated sets between
the two components gives zero entropy on their union.

For completeness, pointwise attraction suffices; no uniform last
entrance time is substituted. Fix block length m and a neighborhood V
of Z made of P orbit balls shadowing Z; use Q orbit balls for X.
For each point choose a finite block of samples under `f^m` with fewer
than a tau fraction outside V. Openness preserves the good visits on a
neighborhood. A finite subcover bounds these chosen block lengths by J.
Concatenating the chosen blocks along any orbit, with a final remainder
of length `<J`, bounds exceptional samples among r samples by
`tau*r+J`. Descriptions then number at most

    2^r P(m)^r Q(m)^(tau*r+J).

Equal descriptions keep orbit distance below epsilon for all mr times.
For arbitrary n take `r=ceil(n/m)`. The fixed-scale entropy rate is at
most `[log 2+log P(m)+tau log Q(m)]/m`. First let tau decrease to zero
with m fixed, then let m tend to infinity. Zero entropy on Z gives
`log P(m)/m -> 0`. This proves ordinary entropy zero and closes
`C_ENTROPY_LOCALIZATION`, `C_REGISTER_ENTROPY`, and `C_ZERO_ENTROPY`.

## 6. Homology, orientation, full spectrum, and noninvertibility

Here is a simultaneous homotopy stronger than the projection-only
argument needed in the manuscript. Write the affine register outputs
as `V_l(t,z,v)`. For `0<=s<=1` set

    f_s(t,z,v) =
      (t+(1-s)h(t,z), z^2+(1-s)C(t,v), ((1-s)V_l(t,z,v))_l).

The register outputs are globally bounded. At infinity the main inverse
coordinate is `w^2/[1+(1-s)Cw^2]`, with the same uniform nonzero
denominator as above. Thus this is a jointly continuous homotopy,
including all source register poles, from f to

    F_0(t,z,v) = (t,z^2,0,...,0).                     (2)

Use the natural real-coefficient Kunneth cross product and homotopy
invariance (Hatcher, Theorem 2.10, Corollary 3B.7 and the preceding
naturality statement; exact short excerpts are retained). The sphere
square has degree 2: the regular value 1 has preimages +1 and -1, and
the real Jacobian determinants of complex multiplication by 2z are
both `4>0`. Each local degree is +1; their sum is the degree
(Hatcher, Proposition 2.30, whose finite-preimage hypothesis holds).
By the degree action on sphere
homology (Hatcher, Lemma 2.49), its H2 action is multiplication by 2,
with no orientation-sign ambiguity.

A basis of total homology is indexed by a circle choice `e in {0,1}`
and a subset J of the `q+1` sphere factors, in degree `e+2|J|`.
By (2) its eigenvalue is 1 if J is empty, 2 if J consists just of the
main sphere, and 0 if J contains any register. Therefore

    dim H_(2k) = dim H_(2k+1) = binomial(q+1,k),
    chi_H2(lambda) = lambda^q (lambda-2),
    chi_Htotal(lambda) =
      lambda^(2^(q+2)-4) (lambda-1)^2 (lambda-2)^2.

All homology above dimension `2q+3` vanishes. For the released `q=3`,
the Betti vector is `(1,1,4,4,6,6,4,4,1,1)`, and total characteristic
polynomial is `lambda^28 (lambda-1)^2 (lambda-2)^2`.

There is also a direct check on the custom radius supremum. In a
nonzero coordinate pair (1) with diagonal coefficient d, the equations
force `[(d-a)^2+b^2](u^2+v^2)=0`. Over the reals this implies `a=d,b=0`.
Conversely each actual diagonal coefficient is obtained with `v=0`.
For `q>=1` the radius set is exactly `{0,1,2}`. This both computes the
ordinary radius and verifies that the released `sSup` has its intended
meaning. The H2 rational matrix `diag(2,0,0,0)` has been replayed through
Jacobian's inspected exact characteristic-polynomial contract; it gives
`lambda^4-2*lambda^3`. This calculation does not by itself prove the
topological homotopy or Kunneth identification.

Finally every register output is finite, whereas the ambient product
contains points with a register at infinity. Thus f is not surjective
and not bijective. More strongly, varying a source register in the
neighborhood where S vanishes leaves all outputs unchanged, giving
noninjectivity as in the staged proof. Hence it is genuinely
noninvertible, not just of unspecified inverse regularity.

This proves `C_HOMOLOGY`, the full conventional conclusion `C_MAIN`,
the definition bridge `C_GLOBAL_BRIDGES`, and `C_GLOBAL_STANDARD`.
It yields `0 = h_top(f) < log 2 = log rho(f_*)`.

## Replay and remaining review boundary

Run from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/global_verification/verify.py

The script checks frozen GitHub blob identities, immutable published
acceptance provenance, primary-note identity, exact rational and
polynomial identities, the new real compiler certificate and its
source/fidelity binding, reuse of the already reviewed passage evidence,
and the two official campaign-local structural checks. It writes
`exact_certificate.json`. It neither rebuilds the upstream dependency
closure nor recompiles unchanged passage evidence. The new bridge was
actually compiled with Lean 4.31.0, exit 0, proof holes empty, and axiom
audit exit 0; its only axioms are the three ordinary permitted ones.

The script is **not** a kernel check of this whole prose report.
The manifold/C1 and entropy-definition bridges, source application,
global analytic proof, and homotopy/Kunneth argument are explicit
mathematical proofs for independent reading. The ledger keeps the
historical-check and standard-homology assumptions visible. Before
acceptance the Reviewer must check their primary passages, judge the
global claims and the new bridge's statement fidelity, and explicitly
assess significance and novelty at the publishable target. No such
approval or `verified_new` classification is manufactured by this
certificate, and the campaign is not declared finished by this report.
