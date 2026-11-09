# Catalog-row maximal and depth estimates

## Scope and source findings

This work addresses only `lem:row-maximal` and `lem:row-depth` in
`research/openai_manuscript/Pointwise-convergence-of-triple-ergodic-averages-for-mixing-transformations-October-4-2026/build/paper/sections/rows.tex`.
It does not establish any of the four ergodic convergence theorems.
The research target remains publishable and the objective mode exploratory.
Independent Reviewer certification is outstanding.

The source distinguishes support partitions `pi_n` from observation
partitions `sigma_n`. Its exact order is
`sigma_n` refines `pi_n`, and `pi_(n+1)` refines `sigma_n`.
A row has its entire input support in one `pi_n` cell. Its adjoint,
for every test in its Hilbert output space, is a constant-coefficient
catalog combination on each `sigma_n` cell. Coefficients have no
uniform bound. The original, unmasked rows have a joint Bessel bound
on arbitrary inputs. Multiple rows on one support, empty rounds,
arbitrary finite schedules, and arbitrarily many catalog labels are allowed.

The catalog has private coordinates with nonzero constant weights.
Its path count, column norms, and inverse private weights are bounded
by `D >= 2`. The elementary pointwise bounds are
`D^(-1) ||a||_2 <= ||sum a_v Phi_v|| <= D^(3/2) ||a||_2`.
Labels persist on descendants even if omitted from a mask.
The total catalog size is not a bound on a spatial path.

The proposed weak maximal constant is
`C_D^2/4 = 16(9 + L_D^2)/9`,
where `L_D = 1 + ceil(5 log_2 D)`.
The depth theorem assumes a nondecreasing read schedule and a
pointwise supremum-plus-total-variation bound `W^(-1/2)` on each
of `W` deterministic consecutive blocks.
These hypotheses are not to be weakened or replaced by finite examples.

The source proof uses test-dependent buckets, but a bucket must contain
whole row indices, not restrictions of rows to hit sets. This is the
principal verification obligation. A failure to find a counterexample
in a finite search would not settle it.

The only named external comparison inside the maximal argument is
Krause--Lacey, *Sparse bounds for maximally truncated oscillatory
singular integrals*, Lemma 2.7
(`doi:10.2422/2036-2145.201706_023`; arXiv:1701.05249).
The argument below will prove the needed binary-prefix estimate
directly rather than assume that citation. The catalog construction
is attributed to OpenAI's companion *An L3 bound for the trilinear
Hilbert transform*, Section 3, but the stated catalog inequalities
are elementary and will also be proved directly. Neither companion's
main analytic theorem is an assumption of this row-core verification.

The shared Wiki index was searched for ergodic, Bessel, catalog,
martingale, and Rademacher--Menshov facts; no relevant entry was found.
The initial source-mapping helper reported unavailable sources; direct
inspection established that the staged manuscript roots are symlinks,
and their build layouts differ. Its absence report is not evidence
about the manuscripts.

## Result (mathematical proof; independent review pending)

Both original catalog-row estimates hold. The proof below covers every
finite schedule and arbitrary Hilbert dimensions under exactly the
manuscript's hypotheses. It also gives a strictly smaller constant:

    C'_D = sqrt(81 + (324/49) L_D^2),   L_D = 1 + ceil(5 log_2 D).

In the original weak estimate replace `C_D^2/4` by `(C'_D)^2/4`,
and in both original L1 and depth estimates replace `C_D` by `C'_D`.
For every `D >= 2`, `L_D >= 6` and `C'_D < C_D`. At `D = 2` the
squared constants are respectively `15633/49` and `320`.
This is a proved improvement of the stated bound, not a claim that
the bound is optimal or that the mathematical argument is novel.

The universal finite-combinatorial core is separately formalized.
That formalization does not encode the complete measure-theoretic
theorems. Exact finite examples below are regression evidence only,
not the proof of the universal statements. Neither these results nor
the constant improvement establish any full ergodic convergence claim.
Publication-level novelty and independent certification remain open.

## Four-theorem dependency boundary

| Source main claim | Exact scope | Still-unverified load-bearing inputs |
|---|---|---|
| Triple `introduction.tex`, `thm:main` | Fixed bounded complex triple, times n,2n,3n, arbitrary invertible bimeasurable mixing probability system, all positive lengths | Depth-local analytic assembly, smooth rows, transference/oscillation and norm-limit identification |
| Distinct-slopes `build/sections/introduction.tex`, `thm:main` | Fixed pairwise distinct nonzero integer slopes of either sign; same system and all-length conclusion | Coefficient-sensitive analytic extension of H and V, arbitrary-slope transference and norm identification |
| Fourfold `build/sections/01-introduction.tex`, `thm:main` | Fixed bounded four-tuple at n,2n,3n,4n; arbitrary mixing probability system, no mixing rate | Companion higher-order mixing, lower-length pointwise input on arbitrary systems, relative structure, selected laws, packing and channel activation |
| General `build/sections/introduction.tex`, `thm:main` | Every fixed integer n >= 2 and bounded n-tuple at consecutive powers; arbitrary mixing probability system | Companion higher-order mixing, triple pointwise input without mixing, relative structure, minimal-correlation and square-array arguments |

These are source assertions, not established results of this audit.
`build/sections/inputs.tex` of the general manuscript explicitly imports
the assertion that ordinary mixing implies every finite order of mixing.
That assertion is not a consequence of the row theorem and is not
silently treated as a known fact here. Its source-only assumptions are
recorded on the appropriate main claims. Likewise the substantial
fixed-input H estimates are recorded on the depth-local analytic claim,
not on the row-core claims.

No prior campaign mathematical result was present: the initial ledger
contained only the campaign objective. Thus the relevant comparison is
with the manuscript's stated row constants and hypotheses, not with a
previously certified result.

## A uniform persistent-column verification theorem

The following more general theorem isolates the actual geometric input.
It is a mathematical theorem proved here, rather than a conclusion
extrapolated from a finite computation.

Let `(X, mu)` be a finite measure space. Replace the dyadic partitions
by any finite measurable partitions `pi_n, sigma_n` with the original
two refinement relations. Retain the original row locality and
constant-coefficient representations, in one finite global label space,
and persistence of available columns on descendants. Suppose that,
outside one common null set, every available coefficient vector obeys

    m ||a||_2 <= ||sum_v a_v Phi_v(y)|| <= M ||a||_2,
    0 < m <= M,   kappa = M/m.

All columns are strongly measurable. They need not be simple functions.
There is no bound on the number of labels or rows, nor on any Hilbert
dimension. The joint Bessel hypothesis is exactly the original one.
Null support cells carry zero operators and may first be discarded;
null observation cells can likewise be ignored.
For every nonnegative integer `k`, put `T = 2^k`. For every real
`0 < alpha < 1` define

    K(k, alpha) = kappa^2/(T alpha^2) + (k+1)^2/(1-alpha)^2.

For arbitrary tests on any contiguous range of rounds, with total
squared test norm `E`, the prefix maximum satisfies

    mu{M_prefix > lambda}
      <= min(mu(X), K(k,alpha) B^2 E / lambda^2)   (lambda > 0),
    ||M_prefix||_1 <= 2 sqrt(K(k,alpha)) B sqrt(mu(X) E).

All constants are independent of schedule lengths and dimensions.
In particular one may take `k = ceil(log_2(kappa^2))`.
The original setting has `m = D^(-1)`, `M = D^(3/2)`,
`kappa^2 = D^5`, and `k = ceil(5 log_2 D)`.

### 1. The catalog inequalities really are pointwise

For any available coefficient vector, the squared norm of its private
component is

    sum_v |gamma_v|^2 |a_v|^2 >= D^(-2) sum_v |a_v|^2.

The triangle inequality and Cauchy--Schwarz give

    ||sum_v a_v Phi_v(y)||
      <= (sum_(v available at y) ||Phi_v(y)||^2)^(1/2) ||a||_2
      <= D^(3/2) ||a||_2.

Only the path count is used, not the total number of labels.
The same common null set works for all coefficient vectors: there are
finitely many labels, and these two inequalities follow directly from
their pointwise bounds. The lower bound gives uniqueness. A restriction
to a descendant changes neither coefficient vector nor column values.
For a dyadic subroot, two intersecting birth cells are nested, so
rebasing the ancestor births keeps exactly the old columns and cannot
increase any budget. This proves `lem:row-catalog`, with no input from H.

### 2. Bessel control is used on whole row indices

Let `A` be the original joint bounded operator from the input Hilbert
space to the finite Hilbert direct sum of row output spaces. Its norm
is at most `B`. For every test vector `d`,

    A* d = sum_nu A_nu* d_nu,
    ||A* d||_2 <= B (sum_nu ||d_nu||^2)^(1/2).

For completeness, pair the sum with a unit input `z` and apply
Cauchy--Schwarz to
`sum_nu <A_nu z,d_nu>`; the original joint inequality bounds the
result by the displayed right side. Taking the supremum over unit
`z` proves the assertion, including complex Hilbert spaces with the
source's inner-product convention.

Thus, for any subset `I` of original rows and the fixed original tests,

    ||sum_(nu in I) A_nu* c_nu||_2^2
      <= B^2 sum_(nu in I) ||c_nu||^2.                 (1)

This statement permits zeroing test coordinates. It does NOT permit
multiplying an adjoint by an arbitrary spatial hit-set indicator.
The proof never does the latter.

### 3. Support-local state and unique global owners

Fix the tests and `lambda > 0`, and set `tau = alpha lambda/M`.
Remove the finitely many exceptional sets in their cellwise adjoint
representations, together with the catalog null set. On an observation
cell `K` in round `n`, the tested adjoint sum has one unique constant
coefficient vector `a_n(K)` in the global label space.
Since `A_nu = A_nu 1_(Q_nu)`, taking adjoints gives
`A_nu* = 1_(Q_nu) A_nu*`. Only rows whose support contains `K`
contribute there.

Use buckets numbered `0,...,T-1` and inactive sentinel `T`. Initially
the bucket is zero and the accumulator zero. At the start of round
`n`, both are constant on each support cell `Q` in `pi_n`.
Every row on `Q` is assigned to that ONE bucket. Sentinel rows are
omitted. On each observation cell `K` inside `Q`, add `a_n(K)` to
the accumulator if active. If its coefficient norm is strictly
greater than `tau`, record a hit, advance the bucket by one, and
reset the accumulator to zero. Otherwise retain it. At the sentinel
make no further additions.

Here is the complete induction justifying the stated locality.
At round zero the state is constant. Suppose it is constant on
`pi_n`. Since `sigma_n` refines `pi_n`, its previous state and its
new increment are constant on each `sigma_n` cell. The update,
including the norm comparison, is therefore constant on that cell.
Since `pi_(n+1)` refines `sigma_n`, the next starting state is
constant on every next support cell. Coefficients already in the
accumulator refer to persistent available columns, so their meanings
do not change under these restrictions. This proves the induction.

Consequently, a fixed row has a globally well-defined bucket owner.
It is never split after a hit on only part of its support. Owners
depend on the tests, which is harmless for (1): after they have
been chosen they still select literal original row indices.
This induction is the content of `state_support_local`,
`bucketState_support_local` and `whole_row_bucket` in the formal source.

### 4. Completed buckets have no future contamination

Let `v_i` be the sum of tested adjoints of rows assigned to bucket `i`.
Fix a spatial point outside the removed null set. Its bucket number
is nondecreasing. A row nonzero at that point has its owner equal
to the point's bucket just before that row's round, by support
locality. Hence a row in a bucket strictly below the current bucket
cannot occur in a later round. In particular a completed `v_i(y)`
is exactly the sum collected at that point up to its hit, not a
sum containing unobserved future rows.

More precisely, at every cutoff the earlier rows split into those
in buckets strictly below the current bucket and those in the
current bucket. No future row is in a strictly lower bucket.
This proves the exact completed-prefix identity, not merely a norm
inequality. It is the identity proved in
`completed_prefix_identity` and `completed_bucket_no_future`.

The current-bucket part equals the evolving accumulator until the
sentinel: prove this by induction on cutoffs. With no hit the
bucket is unchanged and the current increment is added to both
expressions. At a hit the bucket advances; no earlier round has
that new bucket number, so its earlier-row sum and its reset
accumulator are both zero. This also handles the cutoff immediately
after a hit.

For every subset of buckets, (1) applies to their disjoint union of
whole rows. In particular

    sum_(i<T) ||v_i||_2^2 <= B^2 E.                  (2)

The universal disjoint-mask step is formalized in
`disjoint_mask_energy`. No orthogonality of the `v_i` is assumed.

### 5. Many hits and the unfinished remainder

Let `Omega_T` be the measurable set of points with `T` hits.
All states and hit sets are constant on cells in finite partitions,
so measurability is immediate and needs no stopping-time theorem.
On this set every bucket has completed, and each completed
coefficient vector has norm greater than `tau`. Persistence and
the lower frame bound give `||v_i(y)|| > m tau`. Therefore (2) yields

    mu(Omega_T) <= B^2 E/(T m^2 tau^2)
                = kappa^2 B^2 E/(T alpha^2 lambda^2).       (3)

Outside `Omega_T`, the sentinel is never reached. At any cutoff the
original partial sum is a prefix of COMPLETED full bucket sums plus
the current unfinished accumulator, by the preceding identity.
Its coefficient norm is at most `tau`; after a hit it is zero.
The upper frame bound gives Hilbert norm at most `M tau`.
Writing

    M_T(y) = max_(0<=j<=T) ||sum_(0<=i<j) v_i(y)||,

we obtain, simultaneously at all cutoffs,

    M_prefix(y) <= M_T(y) + alpha lambda   (y outside Omega_T).  (4)

Including prefixes of buckets not yet completed can only enlarge
`M_T`, so it causes no problem in (4). On `Omega_T` no remainder
claim is made about omitted later original rows.

### 6. Binary prefixes, with no imported theorem

For each `h=0,...,k`, partition the `T=2^k` bucket indices into
consecutive dyadic intervals `J` of length `2^h`. Every prefix is
a disjoint union of at most one such interval at each level.
The full prefix of length `T` uses the top interval; the empty
prefix uses none. Define `v_J = sum_(i in J) v_i`. The triangle
inequality implies pointwise

    M_T <= sum_(h=0)^k (sum_(J at level h) ||v_J||^2)^(1/2).

At a fixed level the corresponding original row masks are pairwise
disjoint. Applying (1) to each and summing gives

    sum_(J at level h) ||v_J||_2^2 <= B^2 E.

Minkowski in scalar L2, over the finite level set, now proves

    ||M_T||_2 <= (k+1) B sqrt(E).                    (5)

This is the classical binary-prefix/Rademacher--Menshov argument.
It is proved here in the precise subset-Bessel form required,
so correctness does not depend on the wording of a literature lemma.
There is no assertion of novelty for this step.

### 7. Weak estimate, L1 estimate and exact constants

By (3)--(5) and Chebyshev,

    mu{M_prefix > lambda}
      <= mu(Omega_T) + mu{M_T > (1-alpha)lambda}
      <= K(k,alpha) B^2 E/lambda^2.

The additional bound by `mu(X)` is automatic. Put
`H = sqrt(K(k,alpha)) B sqrt(E)`. If `H=0`, the weak estimate
at positive rational thresholds gives `M_prefix=0` almost everywhere.
Otherwise the layer-cake identity and the exact elementary integral

    integral_(0,infinity) min(mu(X), H^2/lambda^2) d lambda
       = 2 H sqrt(mu(X))

give the claimed L1 estimate. If `mu(X)=0` the statement is trivial;
otherwise split the integral at `H/sqrt(mu(X))`.
Every maximal function used is the maximum of finitely many strongly
measurable norms; all integrals are therefore well defined.

For the original catalog take `k=ceil(5 log_2 D)` and `L_D=k+1`.
Then `D^5/T <= 1`. Taking `alpha=1/4` recovers exactly

    K <= 16 + (16/9)L_D^2 = C_D^2/4.

Thus the ORIGINAL stated bound is verified, not merely a weakened
replacement. Taking `alpha=2/9` instead gives

    K <= 81/4 + (81/49)L_D^2 = (C'_D)^2/4.

Finally

    C_D^2 - (C'_D)^2 = (220 L_D^2 - 7497)/441 > 0

because `L_D >= 6`. This inequality is formally certified by
`improved_constant`, and its exact coefficients are independently
replayed by `verify.py`.

To check the manuscript's displayed logarithmic upper bound, write
`x=log_2 D >= 1`. Since `L_D <= 5x+2` and
`25(x+1)^2 - (9+(5x+2)^2) = 30x+12 >= 0`,
`C_D <= (40/3)log_2(2D)`. The improved constant obeys that bound too.

## The depth consequence, with arbitrary block radii

Under the same row hypotheses, let the deterministic consecutive
input blocks have pointwise supremum-plus-internal-variation bounds
`beta_b >= 0`, rather than necessarily `W^(-1/2)`.
Let the reads be any nondecreasing finite sequence, with repetitions
allowed. For any admissible maximal constant `C = 2 sqrt(K(k,alpha))`,

    (sum_(n,nu) ||A_nu F_(s_n)||^2)^(1/2)
      <= C B sqrt(mu(X)) (sum_b beta_b^2)^(1/2).     (6)

Proof: test against arbitrary `c` in the finite Hilbert direct sum.
The rounds reading a fixed input block are consecutive or absent.
On a nonempty range `p,...,q`, put
`g_n=sum_(nu in round n) A_nu* c_nu` and
`S_n=sum_(r=p)^n g_r`. The exact pointwise identity is

    sum_(n=p)^q <F_(s_n),g_n>
      = <F_(s_q),S_q>
        + sum_(n=p)^(q-1) <F_(s_n)-F_(s_(n+1)),S_n>.

It follows simply by substituting `g_n=S_n-S_(n-1)` and
telescoping; hence it is valid with the source's complex inner
product linear in its first argument. Because the reads are
nondecreasing inside this block, the triangle inequality charges
each original input edge at most once. Repeated reads charge zero.
The absolute value of this pairing is consequently at most
`beta_b M_b` at each point. The size assumptions make each input
L2 on the finite-measure root, so all these finitely many pairings
are integrable.

The maximal L1 theorem on this contiguous range bounds the block's
integrated pairing by

    C B sqrt(mu(X)) beta_b sqrt(E_b),

where `E_b` is that block's squared test norm, zero for an absent
block. Sum over blocks and use Cauchy--Schwarz:

    sum_b beta_b sqrt(E_b)
      <= sqrt(sum_b beta_b^2) sqrt(sum_b E_b).

Duality in the finite Hilbert direct sum proves (6).
For the manuscript `beta_b=W^(-1/2)`, so the first factor is exactly
one, even if some blocks have no reads. This proves the ORIGINAL
`lem:row-depth`, including its exact constant and all quantifiers,
and the improved `C'_D` version as well. The read indices never
needed to equal the spatial depths of support cells.

## Bridge to the manuscript's measure-theoretic setting

Take `X=R` with ordinary, unnormalized Lebesgue measure. Its positive
finite length is exactly `mu(X)` in the theorem. The original
catalog supplies the pointwise frame bounds from Step 1, with
the original availability and persistence rules. The two dyadic
refinements supply the two label-equality implications used by the
formal locality theorem. All row representations are needed only
for one fixed, arbitrary test vector at a time; the union of their
exceptional sets is finite, regardless of the dimensions of the
output Hilbert spaces.

One can take `X` in the formal locality theorem to be the actual
spatial points outside that common null set, not just discretized
atoms. Alternatively the final observation partition refines
every earlier partition, and gives a finite set of cell histories
for the state induction. Either realization permits arbitrary
measurable physical column functions inside a final cell. No
approximation by simple physical columns, regularity, compactness,
separability of the whole Hilbert spaces, or finite-dimensional
reduction is used. Strong measurability of the stipulated functions
and their finite linear combinations suffices.

The formal state theorems use natural-number indexing without an
upper bound. Every given finite chain extends to such data: after
the last round use its final observation partition as both partitions,
and set all subsequent increments to zero. This preserves the
finite prefixes and both refinement relations, so the formal
quantification imposes no extra infinite-schedule hypothesis.
Positive-measure support cells contain representative points outside
the common exceptional null set.

Empty rounds cause zero increments. Multiple rows on one support
are assigned together, with no uniform bound on their coefficients.
Arbitrarily many labels on disjoint branches are permitted because
the catalog bound uses only path counts. A zero Bessel bound or
zero tests gives zero adjoints and zero output. Subroot restrictions
preserve the original catalog constants. Rows selected using the
input schedule are allowed, provided, exactly as the manuscript
requires, their realized original Bessel inequality holds on all
arbitrary test inputs before the argument begins.

## Certification boundary

`Main.lean` and `statement_fidelity.md` encode the universal
support-local induction, bucket chronology and remainder norm,
whole-row ownership, exact completed-prefix identity, disjoint-mask
energy inequality, and strict constant comparison. The compiler
certificate belongs only to `C_ROW_CORE`. The remaining analysis
is the complete proof above and requires independent mathematical
review. No false literal manuscript assertion has been established,
so there is no justified `F_...` refutation claim at this stage.

The exact finite replay must check the actual catalog budgets,
birth counts including omitted labels, support and observation
partitions, both refinements, an all-input Bessel certificate,
whole-row owners and completed-prefix identities. It must not
silently replace these with fixed-test energy or a weakened
refinement. The independent Reviewer, invoked by the Host, must
read the fidelity statement and universal proof, not promote the
finite replay to a theorem.

### Actual compiler run

The durable task `row-core-lean-1` finished successfully in 16.2 seconds.
The real compiler was Lean 4.31.0 through the prebuilt Mathlib workspace.
`lean_evidence verify` returned `exit_code=0`, `proof_holes=[]`,
`audit_exit_code=0`, and no environment failure. It archived the
claim-bound result at
`certificates/C_ROW_CORE-cd4b038c55dd6d35.json`. The source and fidelity
document have not been edited since that run. The ledger derives
`closed_kernel` for C_ROW_CORE only; statement fidelity remains subject
to the independent reader's judgement.

### Exact rerunnable certificate

From the campaign root run:

```bash
python3 research/row_maximal/verify.py
```

The program uses only the Python standard library. It checks the
archived real compiler result against the current source and fidelity
bytes; it does not manufacture a compiler verdict or silently accept
an unavailable toolchain. The ordinary replay does not recompile an
unchanged Lean source. For a fresh independent compile use:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/row_maximal/Main.lean --statement-fidelity research/row_maximal/statement_fidelity.md --claim C_ROW_CORE --project-root .
```

The rational finite fixture is a genuine piecewise-constant model on
`R=[0,1)`, with eight equal-measure atoms, six rounds, 29 scalar rows
and three catalog labels. Every path has two birth labels, so its
`D=2` budget holds even though the total label count exceeds `D`.
The physical columns coincide where available and alternate sign
inside some observation cells; only their private directions differ.
Their weights are exactly `1/2`. The partitions include unequal cell
depths, empty rounds and repeated support cells with multiple rows.
Masks omitting columns do not remove their births from the count.

The all-input Bessel certificate is not a fixed-test energy check.
Compute the exact Gram matrix `G` of the row kernels in unnormalized
L2 and take `B^2=max_i sum_j |G_ij|=43/16`.
For `H=B^2 I-G`, put
`d_i=H_ii-sum_(j!=i)|H_ij| >= 0`. The program reconstructs exactly

    H = sum_i d_i e_i e_i^T
        + sum_(i<j) |H_ij| (e_i+sign(H_ij)e_j)
                              (e_i+sign(H_ij)e_j)^T.

This proves positive semidefiniteness for every real or complex test
vector, not just those enumerated. The adjoint-duality argument in
Step 2 gives the ordinary Bessel inequality for every L2 input on
the continuum root as well: the kernels are simple functions but
the domain is not restricted to simple inputs.

The exact replay passed 90 full-hypothesis stopping configurations
across five test vectors, six bucket counts and three rational
thresholds, observing both stopped and unfinished paths. It checks
global whole-row ownership, exact completed-prefix identities,
the lower-frame hit bound, every dyadic bucket mask, binary-prefix
energy, weak bounds at the selected exact thresholds and rational
upper certificates for L1. Three normalized input schedules use
one, two and three deterministic blocks with repeated reads; their
exact output energies are respectively `69/1024`, `15/1024` and
`51/4096`, and all blockwise Abel identities are replayed.

A separate bounded combinatorial enumeration checks all 6,561
two-point four-round increment arrays with entries in `{-1,0,1}`.
Its 39,366 stopping replays include 34,344 stopped paths and 8,748
configurations with differing first-round branch states. These
counts certify only the stated finite regression coverage. They
are NOT a finite exhaustion of the original lemma's hypotheses
and are NOT the reason the universal theorem holds.

The isolated Jacobian adapter exited zero and returned `VALID`
for the exact Gram eigenvalues `9/4` and `1/4` of the two coincident
physical columns with distinct private directions. Its exact payload
and typed response, including server 0.14.0, protocol 2025-11-25 and
operation id, are preserved in dedicated JSON files. The replay
independently checks the two rational eigenvectors. No timeout,
transport failure or unknown result is counted as mathematical evidence.
