# Individual S-prime collisions

The goal remains an additional S-unit squareclass, not a global unit
basis or an Erdős multiplicity theorem. No rank-seven witness has yet
been obtained or independently reviewed.

## Proper five-primary relations

The field, maximal order, `S={2,3,58411,6179021}` and reviewed
six-dimensional subgroup U1 are unchanged. The excluded 388-generator pool
is not enlarged or recombined. The new construction uses `c=z^3-6` and
`A=(7,z-1)(7,z-2)`, not the complete principal ideal `(c)A`.

In the maximal order O define

```text
B5 = product_(P above 5) P^(v_P(c)),     D = (c)/B5.
```

These are coprime integral ideals. For a nonzero `beta` in `B5*A`,
write `(beta)=B5*A*E`, with E integral. If all five-adic valuations of
beta equal those of c and `(beta)+D=O`, then

```text
(beta/c) = A*E/D,     (A*E)+D=O.
```

Thus D is the exact reduced ideal denominator. It is not added to S.
Unlike the complete-principal construction, membership in `B5*A`
does not assert `beta=c*u` with `u` integral in A.

Cancellation must include every outside-S prime of D with its negative
exponent and every numerator prime. Shared denominator support alone
neither supplies an S-unit nor proves squareclass independence. Any
final unit requires complete signed prime-ideal recomposition, an entire
integer kernel certified by unimodular transformations, and genuine
rank-seven completion characters for that same unit together with U1.

The native implementation is `sprime_relations_primary_ideals.jl`, with the full
existing prefix. It uses unrestricted `prime_decomposition(O,5)` and the
reviewed actual maximal order. Polynomial factorization modulo five
cannot replace that call: five divides the equation-order index.

There is also a direct exact construction
`B5=(c)+(5^20)`. Indeed five is unramified in the reviewed maximal
order, and `v5(Norm(c))=20` bounds every individual `v_P(c)` by 20.
Taking the ideal sum therefore retains exactly those valuations and
none away from five. This does not assume principality of B5.
The separate `_direct_split.toml` is compared with the prime-by-prime
construction, not substituted for the required complete prime table.

The native unramified specialization uses the inspected Hecke contract
`_decomposition(O,(5),(5),O,5)`: the radical of `(5)` is `(5)` because
five does not divide the maximal-order discriminant. All returned
prime ideals, weighted degrees, anchor valuations and full ideal
recompositions must still be checked. It is not factorization in the
nonmaximal equation order.

### Exact proper-primary checkpoint

The direct native computation passes in the official unmodified pinned
runtime. It gives

```text
Norm(c) = 2^264 * 3^76 * 5^20 * R,
Norm(B5) = 95367431640625,
Norm(B5*A) = 4673004150390625,
Norm(D) = 2^264 * 3^76 * R.
```

R is the exact positive 581-bit integer in
`sprime_relations_primary_anchor.json`, with the full existing prefix;
no primality assertion is made about R. Norm(D) has 965 bits.
`_direct_split.toml` contains the complete integral HNFs of B5, D, A
and B5*A. Native exact identities verify `(c)=B5*D`,
`B5+D=A+D=O`, and `D+(5)=O`. B5 is proper and has not been assumed
principal.

The complete numerical prime table above five remains undelivered.
The unrestricted native call and the separate unramified-algebra call
each end at their 900-second bound without returning a table. These
are non-conclusions. The canonical integral correction
`w=(z^6+3z-4)/5` is primitive of degree 120, but the gcd of its reduced
minimal polynomial with its derivative has degree 60 modulo five.
Its exact native exit 2 and separate FLINT gcd check reject only this
five-etale-generator entrance. They do not exclude other generators
or the complete maximal-order decomposition.

### The executed proper-primary pool cannot yield a unit

Exactly 192 new native iterator calls in B5*A yield 192 retained
distinct candidates beta. Three additional primitive normalizations
are rejected because they leave B5*A. The input is the full proper
ideal, not `(c)A`; the excluded old 388-generator pool is not read or
recombined. A whole unimodular 120-dimensional Gram transformation
is checked. The configured Jacobian `lattice.basis.reduce` call
certifies its actual eight-row projected preconditioner only.
Its operation, exact JSON payload, typed answer and adapter status
are `_primary_block_lll_{payload,output,status}.json`; the server is
0.14.0, protocol 2025-11-25, adapter exit 0, with no error or timeout.
This is not a completion-character rank computation.

The exact necessary-condition screen rejects 159 candidates because
one of the three saved norm-two prime ideals contains both beta and
D. The ideal containment is checked in the actual order coordinates,
so `(beta)+D` cannot be O. One further candidate has
`v5(Norm(beta))=120`, not 20. The remaining 32 have exact norm
five-valuation 20.

For these 32, their individual five-adic profiles equal that of c
even without enumerating the five-prime table: membership in B5*A
gives `v_P(beta)>=v_P(c)` at every P above five, while equality of
the norm valuations makes the sum of these nonnegative differences,
weighted by the positive residue degrees, zero. This argument does
not supply the missing numerical prime table.

For each remaining index i, `_primary_pool_obstruction.json` supplies
an integer `d_i>1` such that

```text
d_i | abs(Norm(beta_i)),
gcd(d_i, Norm(c)) = 1,
gcd(d_i, product_(p in S union {5,7}) p) = 1,
gcd(d_i, Norm(beta_j)) = 1             for every j != i.
```

All divisibilities and gcds are checked exactly. The divisors need
not be prime. Choose any prime p_i dividing d_i, and put
`q_i=beta_i/c`. Then `v_(p_i)(Norm(q_i))>0`, while the corresponding
valuation of every other q_j and every element of U1 is zero.
Consequently, if `v*product q_i^(e_i)` is an S-unit with `v in U1`,
the rational norm valuation at p_i forces `e_i=0`. This holds for
every i. Thus

```text
<U1,q_1,...,q_32> intersect O_(L,S)^* = U1.
```

In particular, no subset satisfying the still-unchecked full
coprimality conditions can yield another S-unit. The complete integer
outside-S valuation kernel on these 32 generators is zero; its
coefficient-lattice transformation is the 32-by-32 identity, with
determinant one and empty kernel basis. This is a private-norm
kernel proof, not an enumerated individual-prime valuation matrix or
signed quotient-factorization table. Four candidates have the stronger
norm-gcd certificate for coprimality with D; no costly processing of
the other candidates is needed for this negative result.

The 160 rejected quotients are not included in this subgroup
statement. In particular, failure of the prescribed coprimality gate
at two, which belongs to S, is not by itself an S-unit obstruction.
Products deliberately mixing rejected quotients under a different
construction have not been excluded.

This is a finite supporting checkpoint, pending independent Reviewer
replay. It excludes a genuinely different proper-primary pool than
the previously reviewed matched-cofactor pool. It does not improve
the six constructed squareclasses, the deficit 115, either K=8
system, unit completeness, S-class coverage, Selmer equality, or the
publishable campaign goal. Other elements and bases of B5*A remain
unresolved. No seventh unit or full positive certificate is claimed.

### Campaign-root replay of this finite checkpoint

Run the following from the campaign root:

```bash
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  -m argus_skill.tools.subagent submit \
  --task-id k56-sprime-primary-review-replay --mode direct --timeout 900 \
  --command 'set -eu; bash research/k8_56_theta_true_descent_global_saturation_sprime_relations_primary_run.sh verify > research/k8_56_theta_true_descent_global_saturation_sprime_relations_primary_review_replay.out 2> research/k8_56_theta_true_descent_global_saturation_sprime_relations_primary_review_replay.err'
```

Retain the receipt and use its `check_with` command after completion;
require terminal `state=done, exit_code=0`, not merely submission.
The wrapper probes actual source imports. If the installed runtime
is unusable, it preserves that tree and bootstraps the official
checksum-verified Julia 1.10.10 archive in a fresh owned runtime
directory, without editing redacted sources. Hecke 0.40.1 is enforced.

The replay recomputes the direct ideal split, checks the entire saved
Gram and deterministic row identities without new iterator calls,
checks the cached exact typed Jacobian transformation, recomputes
every screened resultant and rejection, and verifies all 32 private
divisors. It does not recollect, retry the two timed-out decompositions,
or pretend to certify a positive unit or a rank-seven matrix.

The Engineer's actual final replay receipt is
`_primary_final_replay_result.json`: terminal `state=done`,
`exit_code=0`, elapsed 453.9 seconds. Its output verifies all the
stated ideal, collection, screening and 32-private-divisor assertions,
with zero additional iterator calls. Independent review is not yet
recorded.

Let O be the reviewed maximal order, and let the unchanged finite S be
`{2,3,58411,6179021}`. Start with `I_0=O`, `gamma_0=1`, `A_0=O`.
For an individual S-prime P, take a nonzero element `b` of the actual
inverse of `P I_j`, and put

    I_next = b P I_j, gamma_next = b gamma_j, A_next = P A_j.

The exact equality `I_j=(gamma_j)A_j` follows by induction. An equality
of the entire fractional lattices `I_a=I_b`, including their normalized
denominators, therefore gives

    u=gamma_a/gamma_b, (u)=A_b/A_a.

Since both A factors are S-supported, every individual outside-S
valuation of u is zero. This holds when the common ideal is
nonprincipal. Neither equality of norms nor equality of just the
numerator HNF is sufficient.

For the two collision generators, form the integer matrix V whose
rows are their valuations at every individual outside-S prime. A
unimodular integer matrix T with `H=T V`, together with independent
nonzero rows of H, certifies the entire integer valuation kernel:
the rows of T corresponding to zero rows of H are a basis. Indeed,
`x V=0` implies `(x T^-1)H=0`, so all coefficients of nonzero rows
vanish. The quotient uses `(1,-1)` in this kernel. When V has no
columns, both rows of the identity matrix are needed.

For a delivered unit, both it and its inverse must have reviewed
order coordinates with denominators supported only on S; their exact
product must be 1. At each character prime, primality, a simple root
of the defining polynomial and a nonzero derivative give a genuine
Q_p embedding by Hensel's lemma. The saved nonzero residues give
quadratic characters on squareclasses. Rank seven for the joint
matrix of `-1,2,3,58411,6179021,y,u` proves independence; a smaller
rank within the bounded completion search does not establish dependence.

For a nonprincipal tracked ideal, the basis of its inverse is **not**
the order basis divided by the recorded gamma. The implementation uses
the actual native inverse ideal. The inspected primary contracts are
Hecke 0.40.1's `Ideal/Ideal.jl:889-956`, `FracIdeal.jl:418-429`,
and `LLL.jl:748-823`, under
`.tools/k8_38_hecke/depot/packages/Hecke/5KBsZ/src/NumFieldOrd/NfOrd`.
Both integral and fractional native reduction overloads return the
convention `J=bI`, not its reciprocal. The existing direct-ball helper
uses the same actual inverse and verifies the resulting ideal's
integral denominator. Its metric is only a discovery heuristic.

The quadratic control is in `Q(sqrt(10))`, whose maximal order is
`Z[sqrt(10)]`. The prime `P=(2,sqrt(10))` has norm two and `P^2=(2)`;
it is nonprincipal, since a generator would have norm `+/-2`, while
`a^2-10b^2=+/-2` is impossible modulo five. Thus `P^-1=P/2`, not O.
The control also compares two generators of the same nonprincipal
fractional ideal with denominator three, differing by the unit
`3+sqrt(10)`, and retains their individual prime-13 valuations.
This exercises the certificate interfaces; it is not evidence of a
seventh direction in the degree-120 field.

The restored native control exits zero in 130.8 seconds. Its separate
exact Python replay passes. The actual configured Jacobian Smith
operation on the control's individual valuation matrix gives rank one
and full unimodular left/right transformations, with integer kernel
`[-1,1]`. The replay checks the exact source matrix and transformations.
The server is 0.14.0, protocol 2025-11-25; adapter exit is zero with no
timeout or structured error. These results are controls, not a
degree-120 claim or an independent Reviewer verdict.

The configured Jacobian number-field catalog contains only a bounded
discriminant operation, not an ideal-inversion or ideal-reduction
contract. The exact Smith and prime-field-rank operations have been
inspected separately. Any actual call retains its exact payload,
typed result, server version, protocol and error/timeout status in
dedicated JSON files. Their admitted envelopes are not enlarged.

The actual direct-ball helper also passes a separate nonprincipal
control: two individual P insertions from O return to O, with cumulative
multiplier `+/-1/2` and principal identity `(u)=P^-2=(1/2)`. Its
fractional-input test starts at `P/3`. Native execution exits zero in
130.4 seconds, and separate Python replay checks every complete lattice
identity and the inverse product. This tests the actual search helper,
not just the native reduction convention.

The degree-120 native decomposition at 2 completes in 455.2 seconds
with exit zero. The three individual primes all have norm 2; their
`(e,f)` pairs are `(12,1),(12,1),(96,1)`. The saved complete ideal
records include normalized denominators, and the native calculation
checks `P_1^12 P_2^12 P_3^96=(2)`, after sorting by the recorded
selection indices. These are new individual-prime records in the
unchanged reviewed order, not a unit or an independent review.

The first degree-120 walk requests eight insertions per individual
prime, a 384-bit grid, and a durable 2400-second execution bound.
Each completed edge is saved before collision-character discovery.
An interrupted walk is not a completed finite exclusion. The search
refuses to overwrite an existing path; it does not claim to resume.

The walk reaches its configured 2400-second hard timeout with twelve
saved exact edges: eight for selection index 1, four for index 2, and
none for index 3. Every edge multiplier and every cumulative gamma
is exactly `+/-1`. All thirteen complete normalized endpoints,
including O, are distinct; there are no saved collisions. Thus all
products of the obtained generators are already in reviewed U1.
This is the actual arithmetic obstruction in the executed prefix:
individual S-prime insertion changes the ideals but the chosen
zero-weight first-row reduction supplies no non-sign generator.
It is not an exclusion of longer paths or of the global S-prime
method.

The interrupted operation is the fifth step of the second prime
path. Its termination stack is inside FLINT's
`_fmpz_lll_check_babai`/`_fmpz_lll_d`, called by the actual direct-ball
Gram-LLL helper; the last stage records its 384-bit grid. This is
observed runtime evidence, not a claim that another precision or
reduction strategy would succeed.

Fresh native replay of all twelve recorded degree-120 edges completes
in 167.4 seconds. It verifies each full general-ideal edge, the
initial identity node, cumulative gamma and S-prime exponent vectors.
Its deliberate exit 2 means no seventh-unit witness, not a failed
identity check; the durable runner labels that nonzero exit `error`.
The saved `_paths_replay_2.toml` contains every component verdict.
Separate exact Python `sign-walk 2` replay exits zero, checking the
signed products, normalized full endpoint HNFs and lattice indices,
and retaining `bounded_walk_complete=false`.

Compared with the strongest reviewed unit result, the dimension is
still six and all 115 missing directions remain missing. No unit
completeness, class-group coverage, c, complete L(2,S), Selmer
equality, novelty, publishability, or independent acceptance is
claimed. The bounded mission requires independent checkpoint review
and materially different Planner work capable of producing a
non-sign generator; it has not met its rank-seven acceptance criterion.

From the campaign root, the separate exact control replays are:

```bash
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_true_descent_global_saturation_sprime_verify.py control
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_true_descent_global_saturation_sprime_verify.py direct
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_true_descent_global_saturation_sprime_verify.py sign-walk 2
```

The exact native commands, depot settings, run identifiers, deadlines,
and exit statuses are retained in the dedicated `_submission.json`
and `_status.json`/`_wait.json` records for `restored_contract`,
`direct_contract`, `primes_two`, `walk_two`, and `paths_replay_two`.
The fresh native prefix replay command is the one ending in
`sprime.jl replay 2`, not `search 2 8 384`; replay does not repeat
Gram-LLL or overwrite the tracked path. The control Smith payload and
typed output are separate `_jacobian_control_smith_*.json` files.
Replaying controls does not advance the degree-120 unit claim.

## Same-ideal inverse-geometry continuation

This continuation reuses independently reviewed handoff `0b787891f54e`
and does not overwrite its twelve edges or stored replay evidence.
The old source-mode Julia command currently fails before Hecke loads:
the saved Distributed source has a redacted type annotation. A default
cached-import probe was not a source-import test. Neither failed import
has mathematical significance. An unmodified official Julia 1.10.10
distribution is now installed only in the new owned
`sprime_weighted_runtime` directory; its version and explicit
source-mode Distributed import pass. Restoration exits zero in 5.1
seconds and removes the download archive.

The component-only `weighted-replay 2` interface checks the stored full
fractional ideals, cumulative multipliers and individual S-prime
exponents, prints its verdict, and writes no evidence file. A zero exit
means those component identities passed, not that a seventh unit exists.
The older `replay 2` interface retains its original no-witness exit
convention.

The single controlled comparison uses saved edge 9, the eighth
insertion of the first selected prime above 2. Its input is exactly the
same general ideal as the recorded sign reduction, not an approximation
by a principal ideal. The metric is selected from the actual inverse
lattice. For each nonconstant inverse basis row, midpoint logarithms of
its real absolute values and complex absolute values are projected off
the scalar direction and centered `log|z|`. The latter is the same
direction as centered `log|y|`, since `y^2=-6z`. The complex places have
multiplicity two. Rounding minus four times the residual logarithms and
balancing one real-place weight gives paired integral weights of sum
zero. Among nonconstant metrics of maximum absolute weight at most
512, the eligible row with least midpoint Minkowski length selects
the metric. Out-of-envelope rows are recorded as discovery rejections,
not treated as a failed ideal identity. This is solely a discovery
heuristic, not a shortness,
unit-independence, or global-generation theorem.

The weighted step still chooses a nonzero element b of the actual
inverse ideal, verifies `J=(b)I` as complete normalized fractional
lattices, reconstructs b from the saved inverse row, and checks
`J=(b gamma_parent)A` with the unchanged individual-prime exponents.
The separate replay checks its exact inverse product and order
coordinates and independently computes `Norm(b)` by a rational
polynomial resultant. Both b and its inverse must be S-integral before
it is called an S-unit. In particular, a new non-sign multiplier or
even seven independent squareclasses in `L^*/L^{*2}` is insufficient
when that multiplier has outside-S support.

The restored native command completes all twelve saved edge identities
and the complete prefix check in 50.25 seconds after package loading,
without changing their stored inputs. It then stops at a new
candidate-envelope guard after 193.0 seconds total: the initial
implementation incorrectly stopped at any oversized row before
selecting the eligible minimum. The guard now filters and records
ineligible row metrics. This is a discovery implementation correction,
not a mathematical exclusion. The already completed native prefix is
retained in `sprime_weighted_saved_replay_2.toml` and is explicitly
reused by `weighted-only 2 9 384`; unchanged replay is not repeated.

For any recorded character prime p, a simple root r of P modulo p
lifts uniquely: from a root modulo `p^h`, adding `c p^h` solves the
next root congruence because `P'(r)` is invertible modulo p. The
compatible lifts converge in `Z_p` to a root of P. Irreducibility of
the reviewed defining polynomial makes evaluation at this root an
embedding `L -> Q_p`. At a place where every displayed generator has
nonzero residue, their multiplicative subgroup maps to `Z_p^*`;
quadratic residue signs therefore give homomorphisms on its
squareclasses. An exact rank-seven matrix proves seven independent
field squareclasses. S-unit membership is a separate assertion.

There is also a precise single-generator obstruction. If the
S-stripped numerator of `Norm(b)` is greater than one, some rational
prime q outside S has nonzero norm valuation. Every element w of
reviewed U1 has zero norm valuation at q. Hence an S-unit of the form
`w b^e` must have `e v_q(Norm(b))=0`, forcing e=0. This excludes a
seventh direction from this one multiplier together with U1 and the
stored signs, not from other inverse-ideal vectors, other weights,
arbitrary outside-S rational rescaling, or the global S-prime method.

Exact recovery and native read-back now pass in 237.5 seconds, without
repeating Gram-LLL. The surviving inverse uniquely reconstructs the
primitive integer inverse-lattice row and

```text
b = -z^2/4 + z^5/24 = z^2(z^3-6)/24.
```

The saved complete ideals, tracked exponents, inverse product, and
order coordinates are rechecked. Separate exact Python replay exits
zero and independently verifies the resultant norm. Both checks say
that b is not an S-unit, and its endpoint matches none of the thirteen
saved endpoints. Its norm has valuation 20 at the outside-S prime 5.
Thus `U1<b>` has S-unit intersection exactly U1. The factor `z^2/24`
already belongs to U1 by `y^2=-6z`; the non-S factor is `z^3-6`.
This is a finite generated-subgroup obstruction, not a seventh unit
or a publishable global result. The full Gram transformation was
checked during discovery but did not survive the interrupted export;
recovery does not claim to have archived it.

The bounded partner comparison uses saved node 13, the fourth
insertion of the second norm-two prime, whose input is `P2^4`.
It reuses exactly the node-9 metric and 384-bit precision, but computes
its own actual inverse ideal. It does not select another weight or
extend either sign walk. The native run exits zero in 434.8 seconds,
including persisted-data checks. Its multiplier is exactly c=b.
The complete input ideals and complete weighted endpoints are distinct;
equal multipliers have not produced an ideal collision. Separate
Python replay verifies its inverse-lattice row, inverse, coordinates,
and resultant norm, and verifies that b/c is exactly 1.

The configured Jacobian bridge, server 0.14.0 and protocol 2025-11-25,
returns an exact transformation certificate for the rational norm-5
filter:

```text
A = [20 20], U = [1], V = [[1,-1],[0,1]], D = [20 0] = U A V.
det(U) = det(V) = 1, ker_Z(A) = Z(-1,1).
```

The verifier checks all matrix entries, both determinants, the full
identity and the primitive kernel, not merely the Smith rank.
The inspected contract, exact payload, typed output, and adapter
status are retained in dedicated weighted JSON files; adapter exit is
zero, with no timeout or structured error. This is the complete
integer kernel of this rational norm filter, **not** the complete
individual field valuation kernel required of a seventh-unit witness.

For w in U1, a putative S-unit `w b^e c^f` has norm-5 valuation
`20(e+f)`, so e+f=0. Since c=b, it is then exactly w. Consequently

```text
U1<b,c> intersect O_(L,S)^* = U1.
```

All integer recombinations of these two executed multipliers and the
stored signs therefore add no unit squareclass. This extends the
reviewed twelve-edge sign checkpoint only to the two newly computed
weighted multipliers; it leaves the constructed lower bound at six
squareclasses and the 121-dimensional construction deficit at 115.
No rank-seven completion matrix is claimed or substituted by a
non-S field-squareclass computation.

The narrow edge-9 extraction and same-metric edge-13 partner routes
are exhausted for their stated generated subgroups. Other inverse
vectors, metrics, ideals, and the global S-prime route remain open.
This is an Engineer-supported finite checkpoint awaiting independent
Reviewer replay, not a publishable theorem or campaign completion.

The campaign-root read-only native replay command is:

```bash
cd /home/argustest/zimo/counterexample-batch-1/campaigns/2338
export JULIA_DEPOT_PATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_weighted_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_multirow_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_joint_depot:$PWD/.tools/k8_38_hecke/depot"
export JULIA_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1
research/k8_56_theta_true_descent_global_saturation_sprime_weighted_runtime/julia-1.10.10/bin/julia \
  --compiled-modules=no --pkgimages=no --startup-file=no \
  --project=.tools/k8_38_hecke/env \
  research/k8_56_theta_true_descent_global_saturation_sprime.jl weighted-paired-full-check 2 || exit
for mode in weighted weighted-partner weighted-pair weighted-norm-kernel; do
  PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python \
    research/k8_56_theta_true_descent_global_saturation_sprime_verify.py "$mode" 2 || exit
done
```

This command prints all twelve component checks and rechecks the
recovered comparison, partner and exact norm-filter product without
rerunning Gram-LLL or replacing saved native arithmetic evidence.
The Python modes recheck their own coordinate/resultant records and
replay the stored typed Smith certificate; an existing successful
Jacobian execution is not repeated. Zero exits certify these
components only. Discovery commands refuse to overwrite saved
geometry or arithmetic.

The recorded claim is
`K-K8-56-THETA-SPRIME-WEIGHTED-PAIR-CHECKPOINT`, with Engineer
judgement only. Final official `math_state` and `proof_graph_check`
checks both exit zero against
`/home/argustest/zimo/counterexample-batch-1/campaigns/2338` after the
claim, judgement, narrow route retirements and proof-graph update.
These structural checks do not constitute independent mathematical
review or seventh-unit acceptance.

## Completion-character-separated affine ideals

This continuation keeps the reviewed field, order, S, U1, twelve edges,
and handoff `215327de7bfa` unchanged. A fresh public Julia 1.10.10 is
installed in the owned weighted-runtime `character` subdirectory.
Its explicit source-mode Distributed import passes. Nonwriting
`weighted-replay 2` checks all twelve edges and exits zero in 168.9
seconds; the component work takes 50.16 seconds after package loading.
The earlier runtime again fails source import at its redacted
Distributed annotation. No redacted source or sealed arithmetic is
edited.

### Exact character and CRT lemma

Let

    q1=(7,z-1)O, q2=(7,z-2)O.

Every coefficient denominator of the reviewed order basis is prime
to 7. Evaluation of that basis at 1 or 2 modulo 7 therefore defines
a ring map from O to F_7. The defining polynomial vanishes at both
points, with derivative values 2 and 1 respectively. The maps are
surjective because they contain the rational integers, so their
kernels are distinct prime ideals of norm 7. Hensel lifting gives
the two genuine embeddings `L -> Q_7`; irreducibility of the
reviewed defining polynomial is used here without re-proving it.

At these places the denominator O(-6z) in the reviewed definition
`y=-E(-6z)/O(-6z)` has residues 6 and 5. The U1 generator residues,
in order `(-1,2,3,58411,6179021,y)`, are

    q1: (6,2,3,3,2,1)
    q2: (6,2,3,3,2,4).

All are nonzero. Their quadratic character rows are both
`(1,0,1,1,0,0)`. Define chi as the sum of the two quadratic unit-part
characters on Q_7^*, pulled back to L^*. For a nonzero 7-adic number
its unit part is obtained by dividing by 7 to its valuation; this
defines a multiplicative squareclass character even away from units.
Thus chi annihilates every generator of U1.

The element `h=2z-1` has residues `(1,3)`. They are respectively a
square and a nonsquare modulo 7, so `chi(h)=1`. Consequently chi is
nontrivial on L^*, but this does **not** prove it is nontrivial on
the full S-unit group. In particular h is not declared an S-unit.

The simultaneous evaluation map `O -> F_7 x F_7` is surjective:
the first two reviewed basis rows are 1,z, whose evaluation matrix
has determinant 1 modulo 7. The saved lower-left integer HNF has
diagonal `(7,7,1,...,1)`, every row satisfies both homogeneous
congruences, and its determinant is 49. Inclusion and equality of
indices prove that it is the entire congruence kernel

    M=q1 intersect q2=q1*q2.

The equality of intersection and product follows from comaximality
of the distinct maximal ideals. Thus every element of `h+M` has
the exact nonzero residues `(1,3)` and character one. More generally,
for every `s in F_7^*`, the affine coset `s*h+M` has residues
`(s,3s)` and character one: the two occurrences of the rational
scalar's quadratic character cancel. The congruence level is 7,
the first admitted odd good prime in the bounded construction.

The mathematical data are `_character_data.json` and the separate
native `_character_input.toml`. The Python construction checks
primality, both simple roots, every order-basis denominator, both
y denominators, all nonzero residues, every U1 character, and the
entire HNF kernel. Its exact typed Jacobian request is the two-row,
six-column U1 character matrix over F_2. The inspected operation
`prime_field.matrix.rank.compute` returns rank one, with server
0.14.0, protocol 2025-11-25, adapter exit zero and no timeout or
structured error. This certifies the prescribed annihilator data;
it is **not** an augmented rank-seven unit matrix.

### Affine enumeration and the exact unit test

The new native source constructs both complete prime ideals and
checks them against their saved individual evaluation-kernel HNFs.
It checks the complete product M, not just its norm. The unchanged
saved unimodular order preconditioner is reused. Interpolation in
that basis constructs another full basis of M and a representative
of the same affine coset. Complete normalized ideal equality is
checked before any approximate discovery calculation.

One 384-bit Kannan embedding of this affine lattice has dimension
121. Its rounded embedding Gram matrix is regularized on the
diagonal solely as a search metric. Native Gram LLL returns an
integer unimodular transformation, whose full matrix identity is
checked. No shortest-vector or exhaustive unit-search theorem is
claimed. The inspected Jacobian lattice-reduction contract admits
at most 32 rows, so it is not forced onto this 121-row calculation;
the pinned Hecke/Nemo primitive supplies the discovery transform.

For a transformed row with last coefficient t not divisible by 7,
the reconstructed order element has residues `(t,3t)`. The single
chosen eligible anchor is also translated once in each sign by
every transformed row whose last coefficient is zero modulo 7.
Those translations remain in its exact affine coset. Integer
coordinate content is removed exactly; that content is prime to 7
because the two residues were nonzero. A common rational scalar
does not change chi. Duplicate primitive vectors are discarded.
This specifies one finite new affine family; it does not extend
the retired weighted reduction, omitted-row extraction or identical
multiplier pair.

Every candidate has **integer reviewed order coordinates**, so
it belongs to O. For nonzero a in O, the integral principal ideal
has norm `abs(Norm_L/Q(a))`. Its outside-S rational norm part is one
if and only if the complete principal ideal is S-supported: all
individual ideal valuations are nonnegative, so none can hide by
cancelling another. In that case the inverse is S-integral, also
seen from the adjugate of multiplication by a on O. For a delivered
unit the implementation additionally checks the individual used
S-prime decompositions, their full recomposition to `(a)`, the
inverse order coordinates and the exact inverse product one.

Such a unit gives the complete identity-ideal collision
`I_a=(a)*(a)^-1=O=I_b`, with `gamma_a=a`, `gamma_b=1`,
`A_a=(a)^-1` S-supported and `A_b=O`. Both generators have empty
outside-S support, so the full two-generator outside-S valuation
matrix has zero columns and its integer kernel is all Z^2, with
the two identity rows as basis. No individual S-prime is assumed
principal. The same unit must then pass a genuine augmented
completion-character matrix and a configured Jacobian rank-seven
operation. Until such a unit exists, the reviewed lower bound is
still six and the 121-direction deficit remains 115.

No external theorem is newly invoked by this route. The reviewed
maximal-order and U1 statements already in the ledger are reused;
Hensel lifting, the CRT kernel and the integral norm test are
justified above. An affine-family miss or timeout remains a
checkpoint, not a global S-unit obstruction or publishable theorem.

### Executed obstruction, including arbitrary integer recombinations

The one native affine embedding finishes in 761.4 seconds with 137
distinct primitive candidates. Every one has character one and a
nontrivial outside-S norm part; those parts have bit lengths from 302
to 10935. Its deliberate exit 2 means no witness, not an identity
failure or timeout. Separate Python-FLINT 0.8.0 replay exits zero in
376.9 seconds, reconstructing every candidate from its integral order
coordinates, the complete affine enumeration and whole integer Gram
transformation, and recomputing all 137 rational polynomial resultants.
The missing FLINT dependency was installed only in the owned
`sprime_character_python_depot`; the shared Argus environment was not
modified.

There is a stronger obstruction than the individual norm failures.
Write `n_i` for the S-stripped absolute norm of candidate `alpha_i`.
The reused exact gcd-component algorithm splits these integers into
167 pairwise-coprime integers `c_j>1`, each supported outside S, with

    n_i=product_j c_j^(A_ij).

The saved certificate checks every product and pairwise gcd. No
primality or factorization of a c_j is assumed. For each j choose
any prime q dividing c_j. Since the c_j are pairwise coprime, the
rational norm valuation at q of a product of candidates is a
nonzero positive scalar times `sum_i e_i A_ij`. Hence the complete
integer outside-S **rational norm** kernel is exactly the left
integer kernel of A.

Here A has 137 rows and 167 columns. The pinned FLINT HNF supplies
`H=T A`, with `det(T)=+/-1`; every one of the 137 H rows is nonzero
and their leading columns are distinct. The certificate checks the
full transformation and independence, not just a reported rank.
Thus `ker_Z(A)=0`. This is not a fabricated list of individual
field-prime valuations, and a norm relation is never accepted as a
unit. In this zero-kernel case it is nevertheless enough for an
unconditional negative conclusion.

Let `G=<U1,alpha_1,...,alpha_137>`, allowing arbitrary integer
exponents. If `w product_i alpha_i^(e_i)` is an S-unit, its rational
norm has zero valuation at every outside-S prime. The complete norm
kernel forces every e_i to be zero. Therefore

    G intersect O_(L,S)^* = U1.

The reviewed full two-saturation of U1 also gives

    Sat_2(G) intersect O_(L,S)^* = U1.

For `u in Sat_2(G)` that is an S-unit, some power `u^(2^r)` lies in
G and is an S-unit, hence lies in U1. The reviewed two-saturation
of U1 then contains u. This does
**not** include adjoining arbitrary outside-S rational scalars,
other affine-coset elements, other principal relations, or a complete
global unit basis. It excludes the executed 137-generator seed,
including recombination and repeated square-root extraction, not
the full character-separated affine ideal method.

Compared with the prior weighted pair, which supplies two identical
non-S multipliers of norm-filter rank one, this is a genuinely new
CRT-separated seed with 137 independent outside-S norm directions
and zero integer norm kernel. The constructed S-unit lower bound
does not improve: it is still six, with all 115 missing directions
missing. No rank-seven genuine unit matrix, new Selmer class,
S-class coverage, global multiplicity theorem, originality verdict,
publishability or independent Reviewer acceptance follows.

The finite-family evidence is `_character_coset_lattice.toml`,
`_character_coset_enumeration.toml`, the 137
`_character_candidate_i.toml` files, `_character_coset_result.toml`,
the exact resultant `_character_coset_replay.json`, and
`_character_norm_kernel.json`. The bounded search receipt and
terminal status retain the exact command, run id, deadline and
no-witness exit. The same arithmetic needs independent checkpoint
review and a materially different Planner route, not a larger
enumeration bound.

The new complete nonwriting native read-back also exits zero in
1064.9 seconds. It reconstructs both complete congruence primes,
the full ideal product, preconditioned coset and every saved
affine vector, and rechecks the complete integer Gram identity and
all 137 norms and residues without rerunning LLL or replacing
arithmetic evidence. The integer norm-kernel certificate and
stored Jacobian payload, result, protocol, server and successful
adapter status have separate passing replays.

### Exact campaign-root independent rerun

The following is a durable direct computation for the independent
Reviewer to run, not an independent verdict already obtained.
It replays the old twelve edges, the new persisted arithmetic,
all independent resultants, the full integer norm kernel and the
stored typed adapter evidence. It neither repeats discovery nor
reissues the unchanged successful Jacobian RPC.

```bash
cd /home/argustest/zimo/counterexample-batch-1/campaigns/2338 &&
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.subagent submit \
  --task-id k56-sprime-character-independent-replay --mode direct --timeout 2400 --cwd "$PWD" \
  --command '
export JULIA_DEPOT_PATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_weighted_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_multirow_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_joint_depot:$PWD/.tools/k8_38_hecke/depot"
export JULIA_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 PYTHONDONTWRITEBYTECODE=1
J="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_weighted_runtime/character/julia-1.10.10/bin/julia"
"$J" --compiled-modules=no --pkgimages=no --startup-file=no --project=.tools/k8_38_hecke/env research/k8_56_theta_true_descent_global_saturation_sprime.jl weighted-replay 2 &&
"$J" --compiled-modules=no --pkgimages=no --startup-file=no --project=.tools/k8_38_hecke/env research/k8_56_theta_true_descent_global_saturation_sprime_character_coset.jl replay &&
env PYTHONPATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_character_python_depot" /home/argustest/zimo/argus-live-update/.venv/bin/python research/k8_56_theta_true_descent_global_saturation_sprime_character_verify.py &&
env PYTHONPATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_character_python_depot" /home/argustest/zimo/argus-live-update/.venv/bin/python research/k8_56_theta_true_descent_global_saturation_sprime_character_norm_kernel.py verify &&
/home/argustest/zimo/argus-live-update/.venv/bin/python research/k8_56_theta_true_descent_global_saturation_sprime_character_search.py replay-jacobian &&
{
PROJECT_ROOT="$(pwd -P)"
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root "$PROJECT_ROOT"
MATH_EXIT=$?
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root "$PROJECT_ROOT"
GRAPH_EXIT=$?
printf "PROJECT_ROOT=%s|math_state_exit=%s|proof_graph_exit=%s\n" "$PROJECT_ROOT" "$MATH_EXIT" "$GRAPH_EXIT"
test "$MATH_EXIT" -eq 0 && test "$GRAPH_EXIT" -eq 0
}'
```

`K-K8-56-THETA-SPRIME-CHARACTER-CRT` and
`K-K8-56-THETA-SPRIME-CHARACTER-AFFINE-CHECKPOINT` carry Engineer
judgements only. The seventh-unit obligation remains open and
has an inconclusive Engineer judgement. Only the executed seed's
route `R-K8-56-THETA-SPRIME-CHARACTER-AFFINE` is retired with the
zero-kernel obstruction above; the global individual-S-prime
route is not retired. Independent
Reviewer replay and reading, followed by materially different
Planner work, are required before any further claim of progress
toward publishable completion.

## Fixed-support principal relations

This continuation reuses the independently read CRT and finite-seed
boundary in Reviewer handoff `c11c41b52eb3`. It does not extend the
137-element affine seed, change the reviewed field or maximal order,
or add an auxiliary prime to S. The constructed lower bound remains
six until an actual same-unit rank-seven certificate is obtained.

The auxiliary base is selected **before** collection in
`sprime_relations_base.toml`: the two norm-seven ideals `(7,z-1)` and
`(7,z-2)`, together with all seven degree-one ideals in the reviewed
complete decompositions at 127, 137 and 139. Their roots are respectively
`61`, `132,89`, and `98,39,23,15`. The selection checks simple roots
and every reviewed order-basis denominator. The actual reviewed
nontrivial outside-S norm sizes range from 277 to 11421 bits on 762
records. These sizes warn that smoothness is a substantive admission
condition; small prime-ideal norms neither prove coverage nor predict
success. No rejected candidate's private support is appended to the base.

The old character runtime currently fails source-mode Distributed
import at its redacted annotation. A separate official Julia 1.10.10
distribution is installed under
`sprime_weighted_runtime/relations`, leaving redacted sources untouched.
The downloaded release archive passes the official release checksum.
Explicit source-mode Distributed and Hecke imports, and exact installed
method-contract readback, finish with exit zero in 123.5 seconds.
The first new relation control subsequently fails at a Julia loop
parse error, not at a mathematical identity. The loop is parenthesized,
and the complete new source passes the real Julia parser before
mathematical resubmission.

The next control reaches the actual supplied-base iterator but rejects
the initial report's return-type interpretation. Pinned runtime
readback shows `Vector{ZZMatrix}` basis rows and a `1 x n` integer
matrix return, not a number-field element. Its `bd` field is the
random coefficient bound, not an element denominator. The lowered
implementation returns basis rows and their integer combinations.
The converter now multiplies each order-coordinate row by the reviewed
power-basis matrix B. Every mapped iterator basis row and returned raw
element is checked in the original ideal. Primitive normalization
remains a separately recorded integral operation. These contract
corrections are not a degree-120 arithmetic result.

The installed start method, `Rel_LLL.jl:79` in Hecke 0.40.1, forms
`S = Tr*basis_matrix(A)` and selects rows of this order-coordinate
matrix. It need not retain a complete ideal basis. The native checked
order constructor is positional: `O(a, coordinates, true)`, not
`O(a; check=true)`. It independently checks both integrality and the
claimed order coordinates before ideal membership is tested.

Hecke 0.40.1 exposes the supplied-ideal constructor
`NfFactorBase(O, primes)` and
`class_group_init(FB; add_rels=false, use_aut=false)`.
The bounded small-LLL relation iterator is initialized from an explicit
ideal. Its context is used for discovery only. No class-group proof,
principalization, unit completeness or automatic factor-base enlargement
is invoked. The two new input ideals are the unshifted products
`(7,z-1)(7,z-2)` and `(7,z-1)(127,z-61)`, of norms 49 and 889.
They are not the retired affine cosets. Originals and integral primitive
normalizations are retained as distinct candidate elements; each
normalization records its exact integer content. Equal norm, divisor,
or valuation rows do not identify their generators.

### Completed control and unfinished field collection

The corrected signed control now passes in `Q(a)`, `a^2=10`, with
`alpha=(7+a)/3`, `beta=(3+a)alpha` and their two inverses. Complete
fractional principal factorizations include negative valuations above 3
and both individual primes above 13. The outside-S valuation map has
rank one and complete integer kernel dimension three. Its quotient
`alpha/beta=a-3` has inverse `a+3`, with exact product one. The supplied
iterator's order-coordinate conversion, checked order constructor and
original-ideal membership also pass. This is quadratic control evidence,
not a degree-120 unit direction.

The independent Python arithmetic replay and the inspected configured
Jacobian operation `matrix.normal_form.smith.certified.compute` pass.
The dedicated `sprime_relations_control_smith_{payload,output,status}.json`
files retain the exact 4-by-2 matrix and full transformations. The server
is 0.14.0, protocol 2025-11-25; adapter exit is zero, with no timeout or
structured error. The transformations are independently checked for
unimodularity and the exact Smith identity. Replaying this evidence does
not issue another RPC.

The subsequent source-mode field run replays all twelve saved edges
without rewriting them. It then reaches
`relations_short_context_begin|input=1|ideal_norm=49|precision=1024`
and terminates at the durable 2400-second bound. The terminal receipt is
`sprime_relations_native_collection_final_wait.json`; the earlier
`_wait.json` is only a client-wait timeout. The saved stdout proves
control and edge success but contains no context-ready marker. That
marker follows both native context construction and checked support
conversion, so the precise expensive operation is not localized.

No degree-120 candidate file, norm table, admitted principal-relation
certificate, extracted product or augmented rank-seven matrix was
produced. The timeout is unfinished computation, not a mathematical
exclusion or an exhausted finite search. Field collection, certification
and replay remain untested end-to-end.

### Restricted derivative-family obstruction

The raw `P'(z)` route was already retired as
`R-K8-56-THETA-JOINT-RAW-DERIVATIVE`; it is not a new route here.
Even dividing its reviewed integral order coordinates by their exact
content leaves a primitive element with a 31407-bit norm and a
27534-bit factor outside the fixed rational support. The saved
`sprime_relations_derivative_probe.json` is a rejected element, not an
admitted principal relation.

There is a stronger, but still narrowly scoped, rejection for a different
fixed derivative. Let the reviewed monic polynomial be
`H(T)=E(T^2)+T O(T^2)`, of degree 120, and put
`e(z)=E(-6z)`, `o(z)=O(-6z)`. Exact polynomial arithmetic checks

```
e(z)^2 + 6z o(z)^2 = 6^120 P(z).
```

Here `o` is nonzero of degree less than 120, so it is nonzero in the
reviewed field `L=Q(z)`. Define `y0=-e(z)/o(z)`. The identity gives
`y0^2=-6z` and `H(y0)=0`; conversely `z=-y0^2/6`, so
`Q(y0)=L` and H is its minimal polynomial. Thus
`N=Norm(H'(y0))=Res(H,H')` is computed exactly, without assuming
monogenicity of the maximal order.

Let `R={2,3,7,127,137,139,58411,6179021}`, and remove from `abs(N)`
all powers of primes in R. The resulting integer `N_R` has 16143 bits.
It is the same integer obtained by removing only the four finite
S-primes. The saved `sprime_relations_y_derivative_rescaling.json`
contains an integer r whose exact certificate is

```
r^120 < N_R < (r+1)^120.
```

For any `q in Q^*`, `Norm(q H'(y0))=q^120 N`. If its principal ideal
were supported above R, every `p not in R` would satisfy
`v_p(N)+120 v_p(q)=0`. All prime exponents of `N_R` would therefore
be divisible by 120, contradicting the strict gap. Consequently
**no rational multiple of this fixed `H'(y0)` is admissible**, even
allowing every prime ideal above R rather than only the nine selected
auxiliary ideals. This proof requires no factorization of the large
outside-R integer and makes no positive individual-factorization claim.

The new `derivative-obstructions` verifier recomputes both derivatives,
the reviewed order-coordinate normalization, both exact resultants, the
even/odd polynomial identity, selected norm valuations and the strict
integer gap. It rejects `--require-seventh`: a negative family
certificate cannot substitute for the positive unit gate. The argument
does not exclude powers of the derivative, products with other
generators, their saturations, or the global fixed-support method.
It supplies no new unit direction and no publishable completion.
The checkpoint is
`K-K8-56-THETA-SPRIME-RELATIONS-Y-DERIVATIVE-OBSTRUCTION`,
with Engineer support only and independent review pending. Only
`R-K8-56-THETA-SPRIME-RELATIONS-NATIVE-192` and
`R-K8-56-THETA-SPRIME-RELATIONS-Y-DERIVATIVE` are retired with their
respective computational and arithmetic reasons. The global
`R-K8-56-THETA-SPRIME-FIXED-SUPPORT-RELATIONS` remains open.

### Exact extraction criterion

Let the admitted principal generators be `alpha_1,...,alpha_r`. For
each one, including inverses when distinct, the native calculation
factors the **entire fractional principal ideal**, verifies every
individual factor is prime, and recomposes its normalized full lattice.
Negative exponents retain denominator support. Rational norm smoothness
is only an initial filter: a prime above an allowed rational prime
but outside the nine selected individual ideals is still rejected.
Used S-prime factors are separately recorded; they are not auxiliary
additions to S.

Let V be the r-by-9 matrix of all individual outside-S valuations.
Suppose `H=T V`, T is an integer unimodular r-by-r matrix, and the
nonzero rows of H are independent. The rows of T corresponding to zero
rows of H are then a basis of the **entire integer** left kernel:
for `x V=0`, write `y=x T^-1`; independence forces every coefficient
of a nonzero H row to vanish. This proves completeness over Z, not
merely the existence of a rational or nonprimitive exponent relation.
Unused auxiliary columns stay in V as zero columns.

For every such kernel vector e, form `u=product alpha_i^e_i`.
The complete signed principal factorizations give the S-supported
principal ideal of u exactly. The certificate also reconstructs u and
its inverse in the reviewed order basis, checks that their coordinate
denominators are supported on S, and verifies their exact product is 1.
Only this actual S-unit can enter the augmented completion matrix.
Simple roots, nonzero derivative and residue values give the genuine
completion characters, as proved above. A configured-Jacobian exact
rank of seven proves independence from U1.

A nonzero exponent kernel is not enough. When a basis product satisfies
an exact identity `u^2 z^s = r z^j` with nonzero rational S-unit r,
then `u^2` belongs to U1 because `z=-y^2/6` does. The reviewed
two-saturation of U1 consequently proves `u in U1`. If **every**
kernel-basis product has this certificate, all S-units in
`G=<U1,alpha_1,...,alpha_r>` lie in U1: an S-supported product has
its exponent vector in the complete integer kernel. The same argument
followed by reviewed two-saturation applies to `Sat_2(G)`.
This is a finite generated-subgroup statement, without arbitrary
outside-S rational scalars, not an exclusion of other generators or
of the global fixed-support method. A failed membership test is
inconclusive, not evidence of independence.

### Currently available nonwriting component replay

The following exact campaign-root command replays the twelve saved
native edges, the signed quadratic control and cached Jacobian Smith
certificate, and the restricted derivative obstruction. It does not
recollect candidates, overwrite arithmetic evidence, rerun the successful
RPC, or claim a seventh direction. Submission returns a durable handle;
the Reviewer must obtain its terminal result, not confuse a client-wait
timeout with completion.

```bash
cd /home/argustest/zimo/counterexample-batch-1/campaigns/2338 &&
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.subagent submit \
  --task-id k56-sprime-relations-component-review --mode direct --timeout 1800 --cwd "$PWD" \
  --command '
export JULIA_DEPOT_PATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_weighted_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_multirow_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_joint_depot:$PWD/.tools/k8_38_hecke/depot"
export JULIA_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 PYTHONDONTWRITEBYTECODE=1
export PYTHONPATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_character_python_depot"
J="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_weighted_runtime/relations/julia-1.10.10/bin/julia"
"$J" --compiled-modules=no --pkgimages=no --startup-file=no --project=.tools/k8_38_hecke/env research/k8_56_theta_true_descent_global_saturation_sprime.jl weighted-replay 2 &&
/home/argustest/zimo/argus-live-update/.venv/bin/python research/k8_56_theta_true_descent_global_saturation_sprime_relations_verify.py control &&
/home/argustest/zimo/argus-live-update/.venv/bin/python research/k8_56_theta_true_descent_global_saturation_sprime_relations_verify.py derivative-obstructions &&
{
PROJECT_ROOT="$(pwd -P)"
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root "$PROJECT_ROOT"
MATH_EXIT=$?
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root "$PROJECT_ROOT"
GRAPH_EXIT=$?
printf "PROJECT_ROOT=%s|math_state_exit=%s|proof_graph_exit=%s\n" "$PROJECT_ROOT" "$MATH_EXIT" "$GRAPH_EXIT"
test "$MATH_EXIT" -eq 0 && test "$GRAPH_EXIT" -eq 0
}'
```

Relative to the strongest reviewed result, the constructed lower bound
is still six and the deficit still 115. The completed work restores
execution and excludes one precisely specified rational-rescaling
family; it does not discharge either positive construction obligation.
Independent checkpoint review and materially different replanning are
required, not acceptance of an absent field kernel or rank-seven matrix.

### Future full replay and positive seventh-unit gate

The following command applies when the new candidate, norm, principal
factorization and adapter artifacts have been produced. Those artifacts
do not currently exist, so this is not the available component command.
It is a
Reviewer rerun command, **not** an independent verdict already obtained.
It preserves all twelve old edges and every saved arithmetic artifact.
The adapter evidence is replayed rather than recomputed.

```bash
cd /home/argustest/zimo/counterexample-batch-1/campaigns/2338 &&
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.subagent submit \
  --task-id k56-sprime-relations-independent-replay --mode direct --timeout 2400 --cwd "$PWD" \
  --command '
export JULIA_DEPOT_PATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_weighted_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_multirow_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_joint_depot:$PWD/.tools/k8_38_hecke/depot"
export JULIA_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 PYTHONDONTWRITEBYTECODE=1
export PYTHONPATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_character_python_depot"
J="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_weighted_runtime/relations/julia-1.10.10/bin/julia"
"$J" --compiled-modules=no --pkgimages=no --startup-file=no --project=.tools/k8_38_hecke/env research/k8_56_theta_true_descent_global_saturation_sprime.jl weighted-replay 2 &&
"$J" --compiled-modules=no --pkgimages=no --startup-file=no --project=.tools/k8_38_hecke/env research/k8_56_theta_true_descent_global_saturation_sprime_relations.jl replay &&
/home/argustest/zimo/argus-live-update/.venv/bin/python research/k8_56_theta_true_descent_global_saturation_sprime_relations_verify.py replay-norms &&
/home/argustest/zimo/argus-live-update/.venv/bin/python research/k8_56_theta_true_descent_global_saturation_sprime_relations_verify.py verify --require-seventh &&
{
PROJECT_ROOT="$(pwd -P)"
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root "$PROJECT_ROOT"
MATH_EXIT=$?
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root "$PROJECT_ROOT"
GRAPH_EXIT=$?
printf "PROJECT_ROOT=%s|math_state_exit=%s|proof_graph_exit=%s\n" "$PROJECT_ROOT" "$MATH_EXIT" "$GRAPH_EXIT"
test "$MATH_EXIT" -eq 0 && test "$GRAPH_EXIT" -eq 0
}'
```

The positive unit, complete factorization/kernel and same-unit rank
requirements remain the new version-1
`L-K8-56-THETA-SPRIME-RELATIONS-*` obligations. No construction
result, independent acceptance or publishable completion is inferred
from source imports, a control, a kernel dimension or a structural check.

## Separated norm-49 homogeneous continuation

This continuation reuses reviewed handoff `efdc9ed5b93c`, including the
quadratic signed control and unchanged certificates. It keeps the same
field, reviewed maximal order, S, U1 and nine auxiliary prime ideals.
Only the existing homogeneous ideal

```
A=(7,z-1)(7,z-2)
```

is used in the new collection. No affine offset or extension of the
137-element seed is used. The iterator bound is at most 192, and the
durable collection bound is still 2400 seconds.

### Runtime and measured native phase

The old relations runtime now fails explicit source-mode Distributed
loading before Hecke is imported. A fresh official Julia 1.10.10
distribution is installed under `sprime_relations_norm49_runtime`,
using the published release checksum, without editing any redacted
source. Source-mode Distributed/Hecke imports and nonwriting replay of
all twelve saved edges pass in 172.8 seconds, exit 0. The exact command
and receipt are `_norm49_runtime_submission.json` and
`_norm49_runtime_wait.json`; component stdout is `_norm49_edges.out`.
These names have the full `sprime_relations` prefix.

The new native diagnostic times only
`class_group_small_lll_elements_relation_start(...; prec=1024)` before
checked support conversion. Its diagnostic factor base consists of the
two already selected norm-seven ideals; the installed start method does
not use the factor base in its reduction. Returned coordinate rows,
if any, are saved before conversion. The same complete ideal A is
identified by the two surjective evaluation maps at 1 and 2 modulo 7:
the first two order-basis columns have invertible evaluation matrix,
every ideal row lies in both kernels, and its determinant is 49.

The diagnostic reaches its separate 120-second native-context budget
without returning a context or entering checked support conversion.
Over the preserved 120.012-second resource interval, the Julia process
uses 120.000 CPU seconds, with final resident memory 1838412 kB and
`wchan=0`. The information signal samples GMP integer arithmetic;
it supplies no Julia-level subphase attribution. The process is then
terminated deliberately. `_norm49_native_diagnostic.json` records
`status=inconclusive`, exit -15, the phase budget, command, process
identity and raw resource samples; `_norm49_native.err` preserves the
information/termination stacks. This localizes work before support
conversion, not to a particular internal LLL or embedding operation.
It is not a mathematical exclusion and does not repeat the old
2400-second call with a longer deadline.

### Same-lattice preconditioning and exact conversion

The saved homogeneous part of the reviewed CRT lattice supplies
`C=H U`, where the row permutation of the saved order preconditioner U
is explicit. The new calculation checks `det(U)=+/-1` and that the
complete lower-left HNF of C equals the original ideal basis. Thus
preconditioning changes neither A nor its index. The old affine offset
is never used.

The catalogued `lattice.basis.reduce` operation admits at most 32 rows,
so no degree-120 full reduction is submitted to it. An initial
24-by-120 payload is rejected by the adapter's file-size limit before
reaching the server; its exact payload and error are preserved. The
old wrapper failed to save that adapter exit code, which is recorded
as unavailable rather than invented. The wrapper now saves structured
top-level adapter failures as well as ordinary typed results.

The actual bounded operation reduces eight independent rows of the
saved integer embedding grid, projected onto eight exact pivot columns.
It returns an 8-by-8 unimodular matrix V, checked against the exact
projected input and output. Extending V by the identity on the other
112 rows preserves the complete ideal lattice. This is a discovery
preconditioner only, not a rank-seven unit result or a full ideal LLL
certificate. `_norm49_projected_block_lll_{payload,output,status}.json`
retain the exact request, typed result, adapter exit 0, server 0.14.0,
protocol 2025-11-25 and absence of timeout or structured error.

Let D be the unchanged homogeneous 120-by-120 grid and
`G=D D^t+120 I`. The pinned Nemo Gram reduction operates on
`V_full G V_full^t`. Its total transformation T must satisfy

```
L=T G T^t,  det(T)=+/-1,  returned_order_rows=T C.
```

The complete returned coordinate matrix is saved before checking or
converting it. Every subsequent native iterator row is saved before
batch conversion; distinct elements are not identified by their norms
or principal divisors. Integral primitive normalization is recorded
separately. The first exact candidate is saved separately before any
norm or factorization work.

If B is the reviewed order's power-basis matrix and H_A is the complete
integer basis of A, the batched exact checks are

```
power_rows=order_rows B,
power_rows B^-1=order_rows,
ideal_rows=order_rows H_A^-1 in Mat(Z),
ideal_rows H_A=order_rows.
```

These are full reconstruction and ideal-membership identities, not a
norm or residue proxy for the checked constructor. Coordinate and
support conversion have separate timings. Primitive candidates remain
integral in the reviewed order, even when removing their integer
content leaves A. Complete individual signed factorizations, full
integer outside-S kernel, exact S-unit/inverse and same-unit rank-seven
checks remain mandatory, exactly as above. Collection timings and
resulting arithmetic are not substitutes for those obligations.

The changed context returns 120 rows: the measured Gram call takes
18.278 seconds and the full coordinate matrix is persisted before
the ready marker at 70.505 seconds after package loading. Batched
120-row coordinate reconstruction takes 9.345 seconds and complete
ideal-membership conversion 0.137 seconds. For the 192 iterator
rows those times are 11.994 and 0.210 seconds. These measurements
distinguish the expensive native-context phase from checked support
conversion. They do not isolate the effect of caching from that of
the bounded-block preconditioner.

The first exact candidate is the element 7, saved before norm work;
its integral primitive normalization is 1. Neither is a seventh
direction. The collection yields 195 distinct generators from exactly
192 native iterator calls. Separate Python-FLINT nonwriting geometry
replay exits 0: it checks the entire index-49 ideal, the full integer
Gram transformation, batched reconstruction and membership, every
immediately persisted iterator row, actual native enumeration order,
both recorded integral normalizations and the retained first candidate.
The first native post-basis iterator call returns twice the first
basis row, as the installed implementation does; the replay checks
that behavior rather than replacing it with the source comment's
informal description.

Fresh source-mode native nonwriting geometry replay also exits 0 in
150.4 seconds, including package loading. It checks the complete
homogeneous ideal, total Gram transformation, persisted context rows
and exact batched order/ideal-coordinate identities without rerunning
LLL or replacing arithmetic. Its durable terminal receipt is
`_norm49_native_geometry_terminal.json`. This is Engineer replay,
not independent Reviewer acceptance.

Thus the former no-candidate bottleneck is bypassed on the same exact
lattice without increasing a bound. Norm screening, individual-prime
admission, complete integer kernel and same-unit rank-seven acceptance
are separate later obligations; the existence of these 195 candidates
alone discharges none of them.

### Exact obstruction for the executed homogeneous seed

The completed exact norm table has five, and only five, survivors of
the rational-support filter:

```
candidate       1   2    3   4   123
element         7   1   7z   z    14
```

The other 190 integral generators have a nontrivial norm factor
outside `{2,3,7,127,137,139,58411,6179021}`. Hence none can be
individually admitted on the fixed auxiliary support. This conclusion
uses integrality and nonnegative principal-ideal valuations; it makes
no assertion about products of those 190 rejected generators.

The exact norm is

```
Norm(z)=2^104 3^36 58411^2 6179021^2.
```

The reviewed identity `y^2=-6z` gives `z=-y^2/6 in U1` directly,
without using two-saturation. The new verifier rechecks the exact
polynomial identity for the reviewed expression `y=-E(-6z)/O(-6z)`;
the denominator is a nonzero polynomial of degree less than 120,
so is nonzero in the reviewed field.

Even ignoring individual auxiliary-prime restrictions and allowing
all five rational-support survivors, their generated subgroup is

```
G=<U1,7,1,7z,z,14>=<U1,7>.
```

Write an element of G as `w 7^e`, with `w in U1`. Its rational norm
has seven-adic valuation `120e`, because w is an S-unit and `7 notin S`.
If it is an S-unit, this valuation is zero, so e=0. Consequently

```
G intersect O_(L,S)^* = U1.
```

This covers arbitrary integer exponents and distinct equal-divisor
generators in these five survivors. In their displayed order, the
prime-seven exponent column is `(1,0,1,0,1)^t`. The exact integer
unimodular transformation

```
T = [ 1 0 0 0 0
      0 1 0 0 0
     -1 0 1 0 0
      0 0 0 1 0
     -1 0 0 0 1 ]
```

sends that column to `(1,0,0,0,0)^t`. Its four zero rows are therefore
the complete integer exponent kernel, with products `1,z,z,2`.
All are in U1. Every individual outside-S valuation of the five
generators is the displayed column multiplied by the corresponding
valuation of 7; at least one such valuation is positive, so this is
also the complete integer outside-S kernel for this five-generator
group. This argument does **not** fabricate or supply an enumerated
complete prime-ideal factorization table.

`seed-obstruction --norm49` exits 0 after checking the exact five
monomial identities and closed-form norms, all cached norm-support
strippings, the reviewed y identity, the unimodular transformation
and all four kernel products. Complete replay first recomputes all
195 resultants with `replay-norms --norm49`, as in the command below.
The exact support proof is a finite generated-subgroup obstruction,
not a seventh-unit certificate or a global S-unit obstruction.

Full individual principal factorization was deliberately stopped
after this obstruction passed: continuing cannot produce the requested
seventh direction from this frozen seed. The durable run records
1245.9 seconds and exit 143 (SIGTERM), not a 2400-second timeout or a
failed arithmetic identity. `_norm49_collection_stop.json` records
the reason and the exact owned PID. The dependent full-unit replay
does not run, because no complete field certificate was produced.
No field Smith/rank RPC or augmented rank-seven matrix exists.
`norm49-certify` can resume the saved norm/factorization stage without
recollecting or overwriting candidates, but it cannot defeat the
proved subgroup obstruction.

Relative to the strongest reviewed result, the constructed rank is
still six and the deficit still 115. The improvement over the previous
no-candidate run is a completed exact homogeneous collection, separated
timings and a precise reason this particular collection cannot work.
Only that executed seed is retired; the global fixed-support method,
other elements of A, and the publishable campaign remain open.
Independent Reviewer replay and materially different Planner work are
required. No unit completeness, S-class coverage, Selmer equality,
multiplicity exclusion, verified novelty or publishable completion is
claimed.

### Campaign-root nonwriting replay

The following command creates a new, checksum-checked public runtime
before any source import. It never edits an existing redacted runtime
and refuses to overwrite an existing replay installation. All arithmetic
operations are read-back operations; the adapter check replays its stored
typed evidence. This is the available checkpoint command: it verifies
the homogeneous lattice and the actual seed obstruction, not an absent
complete principal-factorization certificate. A component-replay exit 0
is not the positive seventh-unit gate.

```bash
cd /home/argustest/zimo/counterexample-batch-1/campaigns/2338 &&
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.subagent submit \
  --task-id k56-sprime-norm49-independent-replay --mode direct --timeout 2400 --cwd "$PWD" \
  --command '
set -eu
D=research/k8_56_theta_true_descent_global_saturation_sprime_relations_norm49_runtime/reviewer
mkdir -p "$D"
test ! -e "$D/julia-1.10.10"
curl --fail --silent --show-error --location --max-time 120 \
  https://julialang-s3.julialang.org/bin/linux/x64/1.10/julia-1.10.10-linux-x86_64.tar.gz \
  -o "$D/julia-1.10.10-linux-x86_64.tar.gz"
curl --fail --silent --show-error --location --max-time 30 \
  https://julialang-s3.julialang.org/bin/checksums/julia-1.10.10.sha256 \
  -o "$D/official.sha256"
(cd "$D" &&
 grep "julia-1.10.10-linux-x86_64.tar.gz$" official.sha256 > selected.sha256 &&
 sha256sum --check selected.sha256 &&
 tar -xzf julia-1.10.10-linux-x86_64.tar.gz &&
 rm julia-1.10.10-linux-x86_64.tar.gz selected.sha256)
export JULIA_DEPOT_PATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_weighted_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_multirow_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_joint_depot:$PWD/.tools/k8_38_hecke/depot"
export JULIA_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 PYTHONDONTWRITEBYTECODE=1
export PYTHONPATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_character_python_depot"
J="$D/julia-1.10.10/bin/julia"
"$J" --compiled-modules=no --pkgimages=no --startup-file=no --project=.tools/k8_38_hecke/env \
  -e '\''VERSION == v"1.10.10" || error("wrong Julia"); using Distributed;
  include("research/k8_56_theta_true_descent_global_saturation_sprime_relations.jl");
  pkgversion(Hecke) == v"0.40.1" || error("wrong Hecke");
  sprime_replay(2; component_only=true, output_label=nothing) == 0 || error("edge replay");
  exit(relations_norm49_replay())'\'' &&
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_true_descent_global_saturation_sprime_relations_verify.py \
  replay-geometry --norm49 &&
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_true_descent_global_saturation_sprime_relations_verify.py \
  replay-norms --norm49 &&
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_true_descent_global_saturation_sprime_relations_verify.py \
  block-preconditioner --norm49 &&
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_true_descent_global_saturation_sprime_relations_verify.py seed-obstruction --norm49 &&
{
set +e
PROJECT_ROOT="$(pwd -P)"
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root "$PROJECT_ROOT"
MATH_EXIT=$?
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root "$PROJECT_ROOT"
GRAPH_EXIT=$?
printf "PROJECT_ROOT=%s|math_state_exit=%s|proof_graph_exit=%s\n" "$PROJECT_ROOT" "$MATH_EXIT" "$GRAPH_EXIT"
set -e
test "$MATH_EXIT" -eq 0 && test "$GRAPH_EXIT" -eq 0
}'
```

Only the complete positive operation may be used for seventh-unit
acceptance, after a complete individual-prime certificate and its
same-unit field adapter evidence exist. They do not exist for this
checkpoint; a missing file is not a negative mathematical verdict:

```bash
PYTHONDONTWRITEBYTECODE=1 \
PYTHONPATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_character_python_depot" \
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_true_descent_global_saturation_sprime_relations_verify.py \
  verify --norm49 --require-seventh
```

## Deliberately matched complete cofactor

This continuation reuses reviewed handoff `b2a394a93a11`, the complete
norm-49 lattice and its frozen norm records, without extending the old
192-call seed. The new official Julia 1.10.10 installation is
`sprime_relations_cofactor_runtime`. Its published-checksum bootstrap,
explicit source-mode Distributed/Hecke 0.40.1 imports, nonwriting
homogeneous-geometry replay and all twelve unchanged edge replays
complete in 186.0 seconds, exit 0. The exact command and terminal
receipt are `_cofactor_runtime_submission.json` and
`_cofactor_runtime_terminal.json`, with the full `sprime_relations`
prefix. An existing retained runtime was first probed and failed
source-mode Distributed parsing; no redacted source was edited.

The target is rejected candidate 125, `a=z+1`. Its entire absolute
295-bit norm is outside
`R={2,3,7,127,137,139,58411,6179021}`. Consequently its complete
principal ideal `Q=(a)` is outside this rational support; Q is not
asserted prime. Equal rational norms are not used to identify Q.
The targeted input is the complete ideal `Q A`, where
`A=(7,z-1)(7,z-2)` is the reviewed norm-49 ideal. Neither Q nor any of
its factors is added to S or to the fixed nine-prime auxiliary base.

Let B be the reviewed order matrix, F the saved full reduced basis
of A, C the saved homogeneous basis, and D its saved integer grid.
Let Z be multiplication by `1+X` modulo the monic defining polynomial.
The exact matrices are

```
M=B Z B^-1 in Mat_120(Z), det(M)=Norm(a),
E=F M,                         rowlattice(E)=Q A,
W=E C^-1 in Mat_120(Z),
G=W (D D^t+120 I) W^t.
```

The grid remains a discovery metric only. A complete unimodular
reduction T must satisfy `L=T G T^t`, with generator rows `T E`
and exact quotient rows `T F`. Thus every native iterator row b has
the deliberately imposed identity `b=a u`, not just a matching norm.
Integral-content removal divides b and u by the same integer. All
distinct elements, including equal-divisor elements, are retained.
The total new iterator bound is 192.

The first execution was stopped deliberately after 398.2 seconds,
not exhausted mathematically. A nonterminating Julia information
signal and the saved live resource sample locate its work in FLINT
`fmpz_mat_hnf_pernet_stein`, called by the redundant raw-basis HNF
comparison in `cofactor_input`. The already constructed native ideal
HNFs were available. The replacement checks full integral inclusion
in those same HNFs and equality of the exact lattice indices:
`|det(M)|=Norm(Q)` and `|det(E)|=49 Norm(Q)=Norm(Q A)`. These prove
the identical complete lattice equalities, without weakening them.
In the changed execution this complete inclusion/index check returns
successfully in 8.715 seconds; the complete target ideal is identified
before the new Gram call begins.
The changed execution receives only the remaining 2001 seconds of
the original 2400-second collection budget. The stop receipt,
resource sample and original information stack are preserved; an
interruption is not an arithmetic exclusion.

The changed full Gram operation was also stopped deliberately, after
595.5 seconds, before returning a context or making any iterator call.
Its last stage is the actual targeted Gram call; the nonterminating
sample shows GMP arithmetic but no finer attributable subphase.
Only 1405 seconds remain from the original collection allocation.
An inspected bounded `lattice.basis.reduce` move on eight projected
rows of this same target grid is used instead. Extending its exact
8-by-8 transformation by the identity preserves the entire target
ideal. This is explicitly a projected-block basis change, not a
completed 120-dimensional ideal LLL. A no-result or interruption is
not used as mathematical support.

The configured projected-block operation completes in 23.3 seconds,
with server 0.14.0, protocol 2025-11-25 and adapter exit 0. Its exact
payload, typed answer and status are separate
`_cofactor_projected_block_lll_*.json` files. The full extension
`diag(T_8,I_112)` has determinant plus or minus one; all 120-dimensional
basis and Gram identities are checked without claiming full LLL
quality. Native collection then completes exactly 192 calls and
persists 193 distinct generator/quotient pairs.

The following Python read-back is deliberately interrupted, with the
interrupt requested after 528.3 seconds and terminal elapsed time
571.1 seconds, with all candidates preserved.
Its actual KeyboardInterrupt frame is the redundant `E.det()` call
in `geometry`; no norm or unit verdict has yet been obtained.
The replacement uses the already checked equality of the entire
E-lattice with its lower-triangular native HNF: their change matrix
is integral with determinant plus or minus one. The HNF index is the
product of its diagonal entries, which is checked to equal
`49*abs(Norm(a))`. This proves the identical complete index assertion
without computing the determinant of the raw basis
again. The complete inclusion and index assertions are retained.

`finish-saved` performs only the remaining norm and exact membership
arithmetic on those stored 193 pairs. It neither creates another
iterator nor repeats collection. Its first execution has a
442-second bound and exits 1 after 315.6 seconds: a trusted reduced
Gram entry has 5881 decimal digits, exceeding Python's default
4300-digit conversion limit. The replay now uses the same
`sys.set_int_max_str_digits(0)` policy as the existing mathematical
verifiers. This changes parsing, not the arithmetic or the claim.
The interruption,
owned-process sample and exact traceback are preserved in
`_cofactor_screen_interrupt.json`, `_cofactor_screen_phase_sample.json`
and `_cofactor_block_collection.err`; the integer-limit failure is in
`_cofactor_finish.err`. Neither failure supports an exclusion or a
seventh unit.

The final exact lattice check also avoids a redundant determinant of
M or of a rational change matrix. The explicitly constructed Z is
`I+C_P`, where `C_P` is the companion matrix of the checked monic
degree-120 polynomial P. Thus `det(Z)=P(-1)=Norm(a)`, and
`M=B Z B^-1` has that same determinant. Independently checked
`F=T_old C`, `det(T_old)=+/-1`, and `abs(det(C))=49` give
`abs(det(E))=49*abs(Norm(a))`. For each native lower-triangular HNF,
integral inclusion and its full diagonal-product index therefore
prove equality of the entire lattice. These indices are derived
independently of the HNF, not assumed from matching norms.
The original 192-call/2400-second bound is unchanged; the final
saved-only execution is charged the conservative sum of all earlier
terminal elapsed times, with that calculation retained in its
submission receipt.

### A stronger exact obstruction for the frozen input pool

The cofactor selection also gives a new, independently rerunnable
finite generated-subgroup result. It strengthens the previous
five-survivor obstruction; it does not turn that checkpoint into
a global unit theorem.

Let `g_1,...,g_195` be the original frozen generators, and let c_i
be the absolute norm with every R-prime power removed. There are
exactly 189 distinct c_i greater than one. For each distinct c,
the archived certificate supplies an integer d satisfying

```
d>1, d|c, gcd(d, product of all other distinct nontrivial cores)=1.
```

No primality assertion about d is necessary: choose any prime divisor
of d. Its norm valuation in an S-unit product forces the sum of
exponents in that c-group to vanish. The only nonsingleton group is
`{124,125}`. Thus all 188 singleton exponents vanish, and
`x_124+x_125=0`. This is a necessary condition on arbitrary integer
products, not merely on individually admitted generators.

The seven remaining generators, in order, are exactly

```
index       1   2    3   4   123       124       125
element     7   1   7z   z    14     7(z+1)     z+1
```

Their complete outside-S principal ideals are products of Q and
the rational ideal (7), with exponent matrix

```
        Q  (7)
        0   1
        0   0
        0   1
        0   0
        0   1
        1   1
        1   0
```

These two ideal directions are independent: Q has nontrivial norm
coprime to R, while (7) is supported above 7. The actual configured
Jacobian `matrix.normal_form.smith.certified.compute` operation
certifies this entire 7-by-2 matrix, rank two, with both unimodular
transformations. Its payload, typed output and adapter status are
`_cofactor_frozen_active_smith_{payload,output,status}.json`.
The adapter exits 0, server 0.14.0, protocol 2025-11-25, with no
timeout or structured error. This is not a rank-seven character RPC.

Permute the 188 singleton rows first and apply
`diag(I_188,U_7)`, where U_7 is the archived Smith left transformation.
This is a full unimodular row transformation. The 188 singleton rows
remain independent by their private primes, the next two rows remain
independent by Q and (7), and the last five rows have zero outside-S
valuations. Thus the archived five 195-entry rows give the complete
integer outside-S kernel. Every kernel product is exactly
`2^e z^f`, with e and f archived explicitly. Since the reviewed
identity is `z=-y^2/6`, every such product belongs to U1. Therefore

```
<U1,g_1,...,g_195> intersect O_(L,S)^* = U1.
```

The verifier checks every private-part identity, the exact seven
polynomials, the full typed Smith transformations, and all embedded
kernel rows and product formulas. It exits 0. The source norm table
is the unchanged reviewed exact-resultant table; this certificate
does not relabel a partial factorization as a complete prime-ideal
table. No enumerated individual-prime factorization is claimed.
The new conclusion excludes all products of the 190 old rejected
generators as well as the five old survivors, but only in this fixed
195-generator pool. New targeted generators and the global method
are not excluded.

From the exact campaign root, nonwriting arithmetic and typed-evidence
replay of this stronger checkpoint is:

```bash
PYTHONDONTWRITEBYTECODE=1 \
PYTHONPATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_character_python_depot" \
/home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/k8_56_theta_true_descent_global_saturation_sprime_relations_cofactor_verify.py \
  frozen-pool
```

Independent Reviewer acceptance is still required. This finite-pool
obstruction is not a seventh direction, unit completeness, S-class
coverage, Selmer equality, an Erdős multiplicity exclusion or
publishable campaign completion. The reviewed dimension remains six,
with deficit 115.

### Exact joint-pool kernel criterion

The joint verifier uses the frozen-pool theorem above and checks it
before proceeding. Write each retained new generator as `b_i=a u_i`.
It verifies this identity in the field, including the saved rational
coefficients. Partition the quotients into exact matches
`u_i=g_{j(i)}` and unmatched quotients. Matching order coordinates is
also checked against equality of the complete field elements; equal
norms never establish a match.

For every unmatched quotient, the sufficient exclusion test supplies
a divisor `d_i>1` of its outside-R norm core, coprime to every old
nontrivial core and every other unmatched core. Choose a prime q
dividing d_i. It is outside R and divides neither Norm(a), any old
generator norm, nor another unmatched quotient norm. Consequently
the norm-q valuation of any S-unit product in the joint pool forces
the exponent of b_i to vanish. This remains true for arbitrary signed
integer exponents. If any unmatched quotient fails this test, the
verifier reports its unresolved obstruction and exits 3; it does not
infer exclusion from a shared norm.

When all these tests pass, substitute each exact match
`b_i=a g_{j(i)}`. Every remaining S-unit product is an S-unit product
of the old generators, hence belongs to U1 by the frozen theorem.
The reverse inclusion is immediate. The exact identities cancel the
entire ideal Q, not a selected prime factor or merely its norm.
In particular, for a matched index the full signed principal divisor
identity is `div(b_i)-div(a)-div(g_{j(i)})=0`, including every prime
and every denominator.

There is a full integer-kernel certificate, not just this subgroup
argument. For every new row subtract original old row 125; for every
matched quotient also subtract original old row j(i). These are
integer elementary row operations. Extend the old full unimodular
transformation by the identity on the new rows, then permute rows to
put old pivots and unmatched quotients first. The remaining rows are
the five old kernel rows and, for each match, exactly

```
e_(195+i) - e_125 - e_j(i).
```

Each new displayed row has field product exactly 1; each old kernel
product is the already verified `2^e z^f` in U1. The pivot rows have
independent outside-S valuations: the 190 old pivots are independent
by the frozen proof, and a private norm prime separates each unmatched
quotient from them and from all the others. Therefore the zero rows
are the complete integer outside-S valuation kernel. Unimodularity
is what proves completeness over Z, not merely over Q.

The verifier constructs this entire joint row transformation, checks
its determinant is plus or minus one and compares every last row
with the archived kernel. It stores all nonzero transformation entries
with explicit one-based indices. It does not claim an enumerated
individual-prime factorization table, a new unit, a complete global
unit basis or a rank-seven completion matrix.

### Executed joint-pool obstruction

The retained collection completes its saved-only arithmetic in 257.5
seconds. Charging the ceiling of every earlier terminal elapsed time,
including failed attempts and the projected-block operation, gives
2165 seconds within the unchanged 2400-second bound. Exactly 192 new
iterator calls produced the 193 retained generators; no saved-only
or replay command makes another call.

Nonwriting native replay passes all complete cofactor/input ideals,
the whole Gram identity and every generator/quotient identity. Its
component time after loading is 91.478 seconds. Separate exact Python
read-back passes geometry and all 193 norm records: 179 quotients are
exactly reviewed old elements and 14 need new resultant computations.
The three rational-support admissions are precisely 7,1,14. Only 1
belongs to U1; the other two are not S-units. The preliminary exit 3
is their recorded nonmembership queue, not an arithmetic exception or
evidence for a seventh direction.

All 14 unmatched quotients pass the private-divisor test. Thus the
criterion applies to the actual joint pool:

```
G=<U1,g_1,...,g_195,b_1,...,b_193>,
G intersect O_(L,S)^* = U1.
```

Its outside-S rank is 204 and its complete integer kernel has
dimension 184: the five old rows and 179 exact-match rows. The
explicit 388-by-388 unimodular transformation has determinant -1
and 764 nonzero entries. Every one of its last 184 rows equals the
archived kernel row. Their products are the five known `2^e z^f`
and 179 copies of 1, all in U1.

The arithmetic certificate is
`sprime_relations_cofactor_joint_pool_obstruction.json` with the full
`k8_56_theta_true_descent_global_saturation_` prefix. The corresponding
`_native_replay.out`, `_exact_verify.out`, `_joint_verify.out` and
`_bigint_replay_terminal.json` preserve the successful read-back;
the complete chained replay exits 0. No individual-prime table or
completion-character rank-seven operation is asserted.

This improves the strongest prior result from the frozen 195-generator
subgroup to this specific 388-generator joint subgroup, rather than
merely excluding the three individually admissible quotients. It
does not exclude other elements of Q A, other unimodular bases,
the global cofactor method or either surviving K=8 system. Only
this bounded matched-cofactor seed is exhausted. The constructed
dimension remains six and the deficit remains 115. Independent
Reviewer acceptance and materially different Planner work are still
required; this is a finite checkpoint, not publishable completion.

### Fresh-runtime component replay for this continuation

The following exact campaign-root command refuses to overwrite a replay
runtime. It downloads an unmodified official pinned release, rather
than repairing a redacted source. Its arithmetic commands are
nonwriting read-back operations and never recollect candidates or
rerun full Gram LLL. `joint-pool` itself checks the prior frozen-pool
component before using it. Neither is a positive seventh-unit gate.
The final wait returns the actual worker verdict, not merely a
successful submission receipt.

```bash
cd /home/argustest/zimo/counterexample-batch-1/campaigns/2338 &&
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.subagent submit \
  --task-id k56-sprime-cofactor-independent-replay --mode direct --timeout 2400 --cwd "$PWD" \
  --command '
set -eu
P=research/k8_56_theta_true_descent_global_saturation_sprime_relations
D="${P}_cofactor_runtime/reviewer"
mkdir -p "$D"
test ! -e "$D/julia-1.10.10"
curl --fail --silent --show-error --location --max-time 120 \
  https://julialang-s3.julialang.org/bin/linux/x64/1.10/julia-1.10.10-linux-x86_64.tar.gz \
  -o "$D/julia-1.10.10-linux-x86_64.tar.gz"
curl --fail --silent --show-error --location --max-time 30 \
  https://julialang-s3.julialang.org/bin/checksums/julia-1.10.10.sha256 \
  -o "$D/official.sha256"
(cd "$D" &&
 grep "julia-1.10.10-linux-x86_64.tar.gz$" official.sha256 > selected.sha256 &&
 sha256sum --check selected.sha256 &&
 tar -xzf julia-1.10.10-linux-x86_64.tar.gz &&
 rm julia-1.10.10-linux-x86_64.tar.gz selected.sha256)
export JULIA_DEPOT_PATH="$PWD/$D/depot:$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_weighted_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_multirow_depot:$PWD/research/k8_56_theta_true_descent_global_saturation_collision_joint_depot:$PWD/.tools/k8_38_hecke/depot"
export JULIA_NUM_THREADS=1 OPENBLAS_NUM_THREADS=1 PYTHONDONTWRITEBYTECODE=1
export PYTHONPATH="$PWD/research/k8_56_theta_true_descent_global_saturation_sprime_character_python_depot"
"$D/julia-1.10.10/bin/julia" --compiled-modules=no --pkgimages=no --startup-file=no \
  --project=.tools/k8_38_hecke/env \
  -e '\''using Distributed;
  include("research/k8_56_theta_true_descent_global_saturation_sprime_relations_cofactor_collect.jl");
  VERSION == v"1.10.10" && pkgversion(Hecke) == v"0.40.1" || error("wrong runtime");
  sprime_replay(2; component_only=true, output_label=nothing) == 0 || error("old edges");
  relations_norm49_replay() == 0 || error("old geometry");
  exit(cofactor_replay())'\'' &&
/home/argustest/zimo/argus-live-update/.venv/bin/python "${P}_cofactor_verify.py" verify &&
/home/argustest/zimo/argus-live-update/.venv/bin/python "${P}_cofactor_verify.py" joint-pool &&
{
set +e
PROJECT_ROOT="$(pwd -P)"
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root "$PROJECT_ROOT"
MATH_EXIT=$?
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root "$PROJECT_ROOT"
GRAPH_EXIT=$?
printf "PROJECT_ROOT=%s|math_state_exit=%s|proof_graph_exit=%s\n" "$PROJECT_ROOT" "$MATH_EXIT" "$GRAPH_EXIT"
test "$MATH_EXIT" -eq 0 && test "$GRAPH_EXIT" -eq 0
}' &&
/home/argustest/zimo/argus-live-update/.venv/bin/python -m argus_skill.tools.subagent wait \
  --task-id k56-sprime-cofactor-independent-replay --timeout 2400
```
