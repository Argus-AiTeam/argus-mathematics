# Unconditional counterfamilies for adaptive signed-chain ECM

**Abstract.** We prove an unconditional worst-case lower bound for
actual-arithmetic elliptic-curve factoring programs using fresh uniform
model-point triples, whose signed scalar chains lie in a sample- and
input-independent polynomial-cardinality shell bank at each length and cutoff.
Control, word selection, interleaving, comparisons, and restarts may
depend on the input, sampled coordinates, and all previous outcomes.
For every such uniform program and every sufficiently large binary input
length `n`, we effectively select a balanced squarefree semiprime `N_n`
of exactly that length, before all randomness, on which success by
`2^floor(sqrt(n*ceil(log_2 n))/1024)` bit operations is at most
`2^(-floor(sqrt(n*ceil(log_2 n)))/4)`. Consequently bounded-error
worst-case time and zero-error expected time are
`exp(Omega(sqrt(n log n)))` in this class. The proof accounts for
intermediate denominator failures, signed coincidences, cross-word
continuations, normalized arithmetic, batching, and the actual
curve-point sampling weights. Its analytic ingredients are classical;
the contribution is their uniform arithmetic-to-program
application and one common effective hard input across all random tapes.

**Scope and review status.** The authorized result is an unconditional
counterfamily theorem for the explicit class below, not a lower bound
for unrestricted factoring or every ECM implementation. Sections 1-6
retain the theorem and proof independently accepted in reviewed handoff
`36a7419624f7/round-0001.json`; correctness and statement fidelity are
not being reopened. The contribution, representation scope, and primary comparison argument
were independently accepted as original and publishable in reviewed handoff
`1245a1519b6b/round-0001.json`, including resolution of the Brown/Riesel
comparison. The unchanged theorem is now submitted for the distinct
Host-recognized project-level final certification. Prior scientific
acceptance does not by itself establish that final receipt.
The finite arithmetic checks do not prove the asymptotic theorem.

## 1. The semantic class and quantifiers

Fix one uniform classical program, with constants `C,A,u >= 1`, where `C,A`
are integers. Its only factor sources are exact trial division through a fixed
polynomial bound, exact primality/perfect-power preprocessing, and the ECM
operations specified here. Preprocessing cannot call a different factorer.
All arithmetic, control, randomness, schedule generation, normalization,
batching, and output verification are charged in ordinary bit operations.

The ECM sampler is the reviewed one: fresh independent uniform triples
`(a,x,y)` modulo the current input, with
`b=y^2-x^3-a*x` and the initial finite point `P=(x,y)`. Capped bit rejection
is permitted; an exhausted cap returns FAIL. The discriminant gcd is
`gcd(6*(4*a^3+27*b^2),N)`. A proper gcd is returned; gcd `N` discards that
trial. Neither coordinates nor curve orders are sampled conditionally on
being units or smooth.

Each sampled curve has its own one-generator register system. Its group
registers are integer multiples of its own `P`, together with infinity.
Independently sampled points cannot be combined in a group gate. The model
does not allow coordinate transformations, scalar gcds, alternate factor
sources, or changes to the sampled curve disguised as chain instructions.

Here is the **sample-independent shell-bank property**. For every input
length `n`, positive integer bit-time cutoff `t`, and independent selector
coin prefix `sigma` of length `t`, a total effective bank generator supplies
at most

```text
Q_n = C*n^A
```

signed-chain prefixes, each having at most `t` group gates. The same bank
covers every `n`-bit input and every sampler tape. Its inputs are only
`(n,t,sigma)`, not `N`, its factors, or any sampled coordinates.
Finite deterministic banks are the special case that ignores `sigma`.
The generator is an effective description of the bank, not a free
subroutine available to the factoring program.
The polynomial bound concerns bank cardinality; long word prefixes may
be generated lazily. In particular, polynomial-total-description-size
banks with this property are included. Allowing the larger cardinality
envelope does not give the program free chain evaluation or free storage.

A chain begins with labels `0` and `1`, representing `O` and `P`.
Each gate negates an earlier label, or adds/subtracts two earlier labels.
Its parents and signs are fixed in that word. Execution may select and
interleave prefixes, reuse any previously evaluated registers, and compare
any two registers on the same sampled curve, including registers from
different words. It cannot substitute new parents into a word. Every
executed group gate before time `t` must occur in an evaluated prefix of
the supplied bank. A fixed signed addition chain is unrestricted subject
to these rules; it need not be binary, increasing, smooth, or minimal.

Control may depend on `N`, sampled coordinates, all previous gcd outcomes,
WHOLE outcomes, and other computed data. Schedule selection, trial counts,
comparisons, and restarts may be adaptive. Selector coins are independent
of the sampler coins. Any randomized bank actually used before cutoff
must be determined by the first `t` selector bits: reading more bits costs
more than `t`. Sample-dependent selection *within* the bank is allowed;
sample-dependent construction of an unlisted word is not.

Arithmetic is exactly the reviewed conditional affine pseudo-addition.
Finite operands first test their individual `x`-difference. Only gcd `N`
allows the subsequent `y`-sum test and tangent/inverse branch. Unit
denominators are inverted before reuse; normalized projective records
have the reviewed secant/tangent denominator as their intermediate `Z`.
Cleared cross-products multiply the corresponding conditioned operands
by units. Nonunit `x`-batches are split to individual outcomes before
conditional `y`-sums are queued. Products and recursively split subbatches
may be used. Infinity follows the ordinary group identity rules.
Crucially, a nonzero integer label is **not** changed to zero merely
because its represented point becomes global infinity.

Stage two can use any of the bank's signed-chain gates and any of its
same-curve comparisons. In particular it includes the reviewed exhaustive
`[s]Q` stage two and all its pairwise comparisons. Recursion uses these same
rules and starts only after a verified proper factor.

This is a restricted but actual-arithmetic ECM program class, not a
generic-group oracle model. The shell-bank condition is substantive.
The theorem below does not cover sample-dependent unbounded schedule
families, arbitrary coordinate-gcd factorers, or unrestricted factoring.

## 2. The theorem

For `n >= 2`, define entirely by integer operations

```text
ell_n = ceil(log_2 n) = bit_length(n-1),
J_n   = floor(sqrt(n*ell_n)),
tau_n = 2^floor(J_n/1024).
```

**Theorem.** Every admitted program has an effective sequence `N_n`, defined
for all sufficiently large input lengths, of distinct balanced squarefree
semiprimes of exactly `n` bits such that

```text
Pr[verified proper factor by bit time tau_n] <= 2^(-J_n/4).
```

The input `N_n` is fixed before either selector or sampler randomness.
Its two primes have ratio in `[8/7,5/4]`. Thus success probability `2/3`
on every input requires worst-case bit time
`exp(Omega(sqrt(n log n)))` in this class. The eventual threshold depends
effectively on the program and its bank/preprocessing bounds. The family
enumerator is not claimed to have efficient delay.

An always-correct Las Vegas program in this class also has expected time
at least `tau_n*(1-2^(-J_n/4))` on these inputs, since this much probability
mass has not returned a factor by `tau_n`.

### Inclusion of every reviewed dual-chain tuple

Fix any positive rational `c,d,e,u` from
`../ecm-dual-chain/analysis.md`, not just the finite fixture tuple.
For length `n`, put `h=floor((n-1)/2)` and `X=2^h`.
For all sufficiently large `n`, every `n`-bit input has its actual
integer height `H` in `[X,4X]`. Indeed `ceil(sqrt(N)) <= 2X`, and the
additional `2*sqrt(ceil(sqrt(N)))+1` is at most `2X` eventually.

With `W=ceil(n^c)`, the bank of heights consists of `X` and all powers
`r^j` in `(X,4X]`, for `2 <= r <= W`. There are at most two such powers
per `r`, hence at most `2W+1` breakpoints. Between them the complete
exponent vector, and thus `K(H)`, is constant, including the endpoints.
For each distinct scalar the bank supplies both the increasing-factor
word and the whole-scalar binary word, with their complete exhaustive
stage two attached. Their group gates are ordinary addition-chain gates.
Every stage-two multiplication can be expressed in the same word by
retaining the parents of `Q=[K]P`. The pure comparisons need no new group
labels. The bank therefore has at most `2*(2W+1)` words.

Truncating these words after `t` group gates covers any execution through
bit time `t`. All fixed positive rational resource tuples fit
`C*n^A` for suitable integer `C,A`; the finitely many small lengths can
be covered by increasing `C`. The original `T=ceil(n^d)` trial count,
trial division, actual sampler, both chains, every stage-two attempt,
conditional gcd, normalized arithmetic, batches, infinity, and recursion
are unchanged. This proves inclusion on **all inputs**, not just on the
hard prime pools.

The new class also admits arbitrary signed words, sample-dependent
selection/interleaving within a polynomial bank, cross-word comparisons,
and nonpolynomial chain/trial prefixes. None of those is present in the
fixed-tuple theorem. Inclusion is not obtained by removing a reviewed
branch or by replacing its two chains with just the final scalar.

## 3. Complete support inventory for one selector tape

Fix `n,t,sigma`. Let `D_sigma` contain `0,1` and every integer label in
the first `t` gates of every bank word. Then

```text
|D_sigma| <= Q_n*(t+2),       |alpha| <= 2^t.
```

The second assertion is induction on gates; one signed sum at most doubles
the preceding maximum, and negation does not increase it.
Form the positive nonzero relation set

```text
R_sigma = {|alpha|, 2*|alpha| : alpha in D_sigma, alpha != 0}
          union {|alpha-beta|, |alpha+beta| :
                 alpha,beta in D_sigma, the displayed value != 0}.
```

Let `M_sigma` be the product of these integers and `P_sigma` its prime
support. Relations equal to one contribute no primes. Every relation
is at most `2^(t+1)`, so

```text
|P_sigma| <= 4*Q_n^2*(t+2)^3 =: k_n(t).                 (1)
```

This deliberately includes *all* cross-word comparisons. It does not
assume that the executed trace, comparison list, or word selection is
independent of samples. It unions neither sampler tapes nor selector
tapes. The support can contain arbitrarily large primes.

### Arithmetic containment, including signed coincidences

Work modulo a factor `r>3` with nonsingular curve. Before the first proper
factor, normalized finite/global-infinity registers have their stated
multiples at both factors. Negation and infinity identities preserve this
invariant even when a nonzero label is represented by global infinity.

For finite `[alpha]P,[beta]P`, equality of local `x` coordinates means
equal or opposite local points. If both `alpha-beta` and `alpha+beta`
are nonzero, a local zero therefore annihilates `P` by one of these
relations. If `alpha=beta != 0`, the `x`-difference is identically zero,
never a proper gcd; a proper conditional `y`-sum/tangent denominator
implies `[2*alpha]P=O` locally. If `alpha=-beta != 0`, both the
`x`-difference and the conditional `y`-sum are identically zero globally:
this inverse case creates no proper factor. It must not be counted using
the zero scalar. A torsion-induced coincidence with another branch is
already covered by `2*|alpha|`. The `alpha=beta=0` case is an infinity
identity, not an affine denominator.

For a secant the recorded intermediate denominator is `x1-x2`;
for a tangent it is `2*y1`. Unit normalization and cleared products
do not alter local zero sets. A local zero of a batch product occurs in
an individual operand. Splitting before conditional `y` evaluation
preserves exactly the same cases. A mixed local infinity cannot be
reused as a normalized finite/global-infinity point: the registered
denominator gcd first exposes the disagreement. A global infinity can
be reused, but retains its original integer label.

These observations induct over every executed gate/comparison, including
adaptive ones. Consequently, a nonsingular arithmetic proper-factor event
modulo `r` implies

```text
[v]P=O for some positive v with support contained in P_sigma. (2)
```

Equivalently its sampled point has `P_sigma`-supported order. The
discriminant/singular events are bounded separately below.
This is full arithmetic-event containment, not a final-scalar-only
criterion or a generic-transcript assumption.

## 4. A budget-uniform smooth-number estimate

The constant exponent `delta` from the accepted fixed-tuple Rankin proof
cannot be held fixed here. The following argument keeps the prime density.

Write `Psi(z,y)` for the number of positive integers at most `z` supported
on primes at most `y`. If an arbitrary prime set has at most `k` elements,
replace its increasing primes by the first `k` primes. This injectively
decreases the represented integers. By the effective PNT already used in
the accepted proof, those first `k` primes are at most `(k+1)^2` for all
sufficiently large `k`. Thus, with

```text
t = tau_n, k = k_n(t), y = (k+1)^2,
z = 3X, L = log(z), w = log(y), v = L/w,
delta = log(v)/(2w), sigma = 1-delta,
```

every tape's supported count is bounded by `Psi(z,y)`. This comparison is
uniform in the magnitudes and identities of the support primes.

For completeness an elementary estimate is enough for the Euler product.
Central binomial coefficients give
`theta(m)-theta(ceil(m/2)) <= m*log(2)`. Induction gives
`theta(x) <= 4x` for `x>=2`; splitting primes at `sqrt(x)` then gives

```text
pi(x) <= sqrt(x) + 8x/log(x) <= 10x/log(x), x>=2.
```

For `0<delta<=1/4`, partial summation and the higher Euler-product powers
give

```text
log product_(p<=y) (1-p^(-sigma))^(-1)
 <= 12 + 10*y^delta/log(y)
       + 10*integral_(log 2)^w exp(delta*s)/s ds.        (3)
```

For example the higher powers are at most
`3*sum_(m>=2) m^(-3/2) < 12`. When `delta*w >= 1`,
split the integral at `1/delta`. Its lower part is at most
`e*log(w/log 2)`, and its upper part at most
`exp(delta*w)*log(delta*w)`. With the chosen `delta`, the right side
of (3) is therefore at most

```text
12 + 10*sqrt(v)/w
   + 10*e*log(w/log 2)
   + 10*sqrt(v)*log((log v)/2).                          (4)
```

In the regime below it is `o(v*log v)`. Rankin's elementary inequality
now yields, uniformly for every selector tape,

```text
Psi_P_sigma(3X) <= 3X*exp(-(1/4)*v*log v)               (5)
```

eventually. No unproved smoothness-in-Hasse-windows assertion is used.
The arbitrary-support comparison and Rankin technique themselves are
classical; the new claimed contribution is their program-level use.

Here are the constants and the regime, rather than an extrapolation.
For the prime pools in Section 5, `n` is `2h+1` or `2h+2`.
For each fixed program, eventually

```text
w <= 8*log(tau_n) <= (log 2)*J_n/128,
L >= (n/3)*log 2,
v >= 128*n/(3*J_n),
log(v) >= (log 2)*ell_n/3.
```

Hence `delta -> 0`, `v -> infinity`, `delta*w -> infinity`, and
`log(w)=o(v*log v)`, proving the stated uniform use of (4).
Moreover

```text
(1/4)*v*log v
 >= (32*log 2/9)*(n*ell_n/J_n)
 >= (32*log 2/9)*J_n
 > 2*(log 2)*J_n.
```

Equation (5) therefore implies the convenient bound

```text
Psi_P_sigma(3X) <= 3X*2^(-2J_n).                        (6)
```

For any positive integer `m`, let `m_P` be its maximal divisor supported
on `P_sigma`, and put `r_P(m)=m/m_P`. Declare `m` bad on this tape when
`r_P(m) <= R_n := 2^J_n`. Its unique decomposition implies

```text
#{bad m <= 3X} <= R_n*Psi_P_sigma(3X)
                <= 3X*2^(-J_n).                        (7)
```

All constants and eventual conditions above are effective. Although the
support product can be very long, repeated division by `gcd(m,M_sigma)`
computes `r_P(m)` exactly, without a prime-factorization oracle.

## 5. One common input, selected before randomness

For each large `n`, put `h=floor((n-1)/2)`, `X=2^h`, and let `rho=1`
for odd `n`, `rho=3/2` for even `n`. Use integer-endpoint prime pools

```text
I_1 = [ceil(rho*X), floor((21/20)*rho*X)],
I_2 = [ceil((6/5)*rho*X), floor((5/4)*rho*X)].
```

The products lie respectively in

```text
[ (6/5)X^2, (21/16)X^2 ]       when n=2h+1,
[ (27/10)X^2, (189/64)X^2 ]    when n=2h+2.
```

Thus they have exactly `n` bits, their factors are distinct, and their
ratio is in `[8/7,5/4]`. The largest prime in either pool is below `2X`.
All local Hasse integers are in `[1,3X]` eventually.

For a prime `p`, define `D_sigma(p)` as the count of bad integers in its
strict Hasse window `(m-(p+1))^2 < 4p`. A fixed integer `m` belongs to
at most `8*sqrt(X)` such integer-center windows for these pools,
eventually. Equation (7) gives, for each pool and each tape,

```text
sum_(p prime in I_j) D_sigma(p)
 <= 24*X^(3/2)*2^(-J_n).                                (8)
```

Now average tapes **before selecting a prime**:

```text
A_n(p) = 2^(-tau_n)*sum_(sigma in {0,1}^tau_n) D_sigma(p).
```

The first `tau_n` selector bits are uniform independently of the sampler.
All shorter stopping prefixes have exactly their usual cylinder weights
in this full-prefix average. Unused bits do not change the distribution.
Equation (8) holds for `A_n` as well.

Call a prime eligible if

```text
A_n(p) <= sqrt(X)*2^(-J_n/2).                            (9)
```

There are at most `24X*2^(-J_n/2)` ineligible primes per pool.
The cited effective PNT supplies at least `c_j*X/log X` primes per pool,
so each pool eventually has eligible primes.
Choose the **least** eligible `p_n` in the first and `q_n` in the second,
and output `N_n=p_n*q_n`. This same pair is used on every random tape.
No individual tape needs to regard either prime as eligible.

This selection is effective. A finite enumeration of all selector prefixes,
bank labels, Hasse integers, and candidate primes computes it exactly.
Writing `Z=sum_sigma D_sigma(p)`, eligibility can be tested with the
integer inequality

```text
Z^2 * 2^J_n <= X * 2^(2*tau_n).
```

The finite exceptional lengths can be skipped. Eventually the pools have
eligible primes and both exceed the fixed polynomial trial bound.
Distinct input lengths give distinct squarefree semiprimes. Exact
primality and perfect-power preprocessing cannot factor these inputs.
The enormous enumerator cost is separate from the factoring lower bound.

## 6. Actual triple weights and all adaptive trials

The only external analytic facts are the already independently attributed
Lenstra and Johnston--Yang propositions used by the accepted dual-chain
proof; their exact statements and references are retained in the ledger.

For `p>3`, a nonsingular model of order `m` has `m-1` affine points.
Its `P_sigma`-supported points form the Hall subgroup of size `m_P`;
the excluded point at infinity accounts for the subtraction of one.
For a good order,

```text
Pr[P has supported order | model]
 = (m_P-1)/(m-1) <= 2/r_P(m) < 2/R_n.                   (10)
```

No cyclic-group hypothesis or exclusion of the characteristic prime is
required. For bad orders, the actual number of triples of trace `s` is

```text
(p-1)*(m-1)*H(s^2-4p),      m=p+1-s.
```

Lenstra's automorphism-weighted trace estimate therefore bounds their
unconditional sampler mass by

```text
c*D_sigma(p)*log X*(log log X)^2/sqrt(X).                (11)
```

This is not a uniform probability measure on Hasse integers. For singular
triples, the discriminant polynomial in `y` has degree four and nonzero
leading coefficient for `p>3`, so the mass is at most `4/p <= 4/X`.

Average (10)-(11) over selector prefixes, using (9). For either selected
prime, one potential fresh trial's exceptional mass is at most

```text
4/X + c*log X*(log log X)^2*2^(-J_n/2) + 2^(1-J_n).     (12)
```

Conditioned on the selector tape, every fresh uncapped triple is still
uniform and independent. Adaptively deciding to use fewer trials,
different words, or different comparisons only restricts the counted
event. There are at most `tau_n` potential trials before `tau_n` bit
operations: obtaining even one fresh triple requires a charged operation.
Union bound over their independent fresh-sample coupling and both prime
factors gives

```text
Pr[proper factor by tau_n]
 <= 2*tau_n*(4/X
       + c*log X*(log log X)^2*2^(-J_n/2)
       + 2^(1-J_n))
 <= 2^(-J_n/4)                                         (13)
```

eventually, since `log_2 tau_n <= J_n/1024` and any fixed polynomial in
`n` is absorbed by the remaining exponent margin.
Cap failures or time truncation only decrease success in this coupling;
conditioning on finishing a cap is not used to claim a uniform sample.
On a squarefree semiprime recursion cannot start without the top-level
proper-factor event. Thus (13) proves the theorem for the complete
recursive program, not just a single chain or final group element.

## 7. Bit model, evidence, and review scope

The proof bounds success after a number of actual group gates and trials
that is at most the bit-time budget. It assigns no unit-cost shortcut to
large scalars, bank generation, batch products, gcds, or sample rejection.
Registers are reduced and normalized exactly as in the reviewed model.
Consequently polynomial changes between conventional charged bit models
only change the positive constant in the subexponential lower bound.
It is not invariant under arbitrary changes to the mathematical operations
or under unit-cost arithmetic on unbounded integers.

More explicitly, let an implementation of these same semantic operations
be simulated in the reviewed bit model with total cost at most
`a*(n+T)^d`, for fixed `a,d`, when its own charged time is `T`.
Choose a positive constant `c` small enough that
`a*(n+exp(c*sqrt(n log n)))^d <= tau_n` eventually.
A success before that implementation cutoff would then be a success
before `tau_n` in the simulated program, with exactly the same input
and random-tape distribution. Section 2 excludes it with the stated
vanishing probability. Thus polynomial-overhead, semantics-preserving
simulations retain the `exp(Omega(sqrt(n log n)))` scale, though not
the particular constant `1/1024` in every implementation.
Lossless reduced-integer encodings, memory layouts, and conventional
charged arithmetic implementations fall under this statement whenever
they preserve the specified operations and have such simulations.
The exact-length assertion always refers to the binary length of `N`.

This is the extent of the representation-invariance claim. Arbitrary
coordinate changes can change the available factor-producing expressions;
they are not merely lossless encodings of this arithmetic grammar.
Unbounded unit-cost registers, free evaluation of huge scalar expressions,
different samplers, or new gcd sources do not qualify as simulations here.
For the operator's two alternatives, the submission is assessed under
the **unconditional-counterfamily** branch. It does not assert that
all mathematically different ECM coordinate systems are equivalent.

Compared with the strongest prior result, the advance is a single
budget-uniform subexponential lower bound for a full adaptive bank class,
including every fixed dual-chain tuple. The support inventory grows with
the budget, its density estimate varies with that growth, and the least
eligible primes are selected by tape-weighted counts. The input is not
selected separately for different tapes. Both input-length parities are
covered.

The primary-source comparison is in `literature.md`. Classical smooth
counts, Rankin's inequality, Montgomery's coefficient sums/differences,
and Lenstra's chain dependence are not claimed as new results.
No inspected primary result establishes this combined program theorem,
but bounded retrieval is not a proof of originality.

`signed-fixture.json` and `verify.py` exercise new signed words, zero labels,
cross-word comparisons, global infinity without label reset, normalized
conditional arithmetic, exact affine Hall-subgroup counts, both prime-pool
parities, and exact sampler/CRT decisions. They are finite
checks of delicate algebraic statements, not evidence of infinitude or
publishability. The inspected Jacobian operation is an exact rational
torsion example only; it does not certify the analytic bound.

The complete replay on `N=55` checks all `166375` raw triples,
`1479640` independent field-register reductions, `111440` nonzero
annihilating relations at factor events, and `29440` nonzero-label
global-infinity returns. The Hall check covers `520` model/support
pairs, including `402` proper Hall subgroups. Four material word
mutations are rejected. The finite weighted selection uses the same
pair on all eight selector prefixes at both 17 and 18 bits. Those
fixtures do not assert asymptotic eligibility or the theorem's
probability bound at their small sizes.

The complete finite replay is rerunnable from the campaign root with

```sh
PYTHONDONTWRITEBYTECODE=1 /home/argustest/zimo/argus-live-update/.venv/bin/python \
  research/routes/input-specific-exponent/ecm-adaptive-schedule-lower-bound/verify.py \
  --output research/routes/input-specific-exponent/ecm-adaptive-schedule-lower-bound/verification.json
```

Independent correctness and statement-fidelity acceptance is preserved,
as is the subsequent independent publication and priority assessment in
`1245a1519b6b/round-0001.json`. The remaining delivery obligation is the
Host-owned final-submission review and recognition of its receipt.
No formal source or kernel-verification claim is made.

## 8. The mathematical contribution

### Necessary arithmetic events, not a final-scalar heuristic

Smoothness of a curve order is a familiar sufficient condition for a
standard ECM stage to succeed. A lower bound needs the opposite logical
direction: every permitted success must lie in a small exceptional set.
It is not enough to show that the final scalar rarely kills the point.
An intermediate secant, tangent, or continuation comparison can reveal
a factor even when that final scalar does not annihilate the point.
The reviewed dual-chain work already exhibited precisely this escape
from a final-small-prime-support argument.

Section 3 bounds all those opportunities together. The positive relation
inventory includes intermediate labels, doubles, and every cross-word
sum or difference, with identically zero signed relations treated
separately. It permits large and unsmooth coefficients and does not
require a minimal or increasing chain. The inventory's prime support
has size at most `4*(C*n^A)^2*(t+2)^3`, regardless of which permitted
trace is actually followed. Sample-dependent branching, WHOLE outcomes,
restarts, and cross-word comparisons therefore cannot escape the counted
set merely by invalidating a fixed successful-trace argument.
This is a necessary-event theorem about explicit modular arithmetic,
not a random-encoding generic-group lower bound.

### A growing resource bound, not another fixed-tuple exclusion

The strongest prior campaign theorem fixes rational polynomial resource
exponents `(c,d,e,u)` and obtains exponentially small success
`2^(-eta*n)` at those polynomial budgets. It does not by itself bound
success after a subexponential number of trials or signed-chain gates:
substituting a growing exponent for one of its fixed constants changes
the theorem's quantifiers and invalidates its fixed Rankin estimate.

The present theorem instead controls the inventory at a moving cutoff.
At `t=tau_n`, the logarithm of its prime-support cardinality is
`O(sqrt(n log n))`, while Hasse-window orders have logarithm `Theta(n)`.
The varying-exponent estimate in Section 4 retains the corresponding
smooth-density scarcity, rather than extrapolating a fixed power saving.
The resulting success tail is weaker than the prior `2^(-eta*n)` tail
at polynomial time, but holds at the much larger time cutoff and for
the broader signed-chain bank class. That change of budget and class,
not a better classical smooth-number estimate, is the improvement.

### One input against the entire randomized program

Choosing a bad input separately for each selector tape would not prove
a randomized worst-case lower bound. Unioning the prime support over
all selector tapes would also lose the useful resource bound.
Section 5 instead averages the bad-order Hasse-window counts before
choosing either prime. The least eligible prime from each prescribed
pool is then fixed for the entire experiment. Section 6 converts the
averaged counts using the actual model-point weights, not a fictitious
uniform distribution on Hasse orders, and covers every possible charged
fresh trial. This proves the required quantifier order
`for every program, there is one N_n, then probability over all tapes`.
Effectivity and both binary-length parities are retained; efficient
enumeration of the hard family is neither needed nor claimed.

## 9. Why the restricted class is a substantive target

The bank condition restricts available scalar programs, not the power
of the controller to inspect the input or coordinates. For a fixed
bank, the number of potential selections, interleavings, comparison
lists, and sampler-dependent executions need not be polynomial.
The theorem covers them without counting possible transcripts. It also
allows nonpolynomial word lengths and trial budgets, arbitrary signed
addition chains, and all cross-word comparisons on a sampled curve.
It is therefore not a restatement about one prescribed smooth scalar.

There is a concrete inclusion theorem, rather than a similarity claim:
Section 2 places **every** reviewed dual-chain rational resource tuple
inside the class on **every** input. The input-dependent height in that
algorithm changes its exponent vector at only polynomially many shell
breakpoints. Both complete scalar words and their exhaustive stage-two
comparisons are included, without deleting an arithmetic branch.
Increasing those fixed polynomial resource exponents or adding
sample-dependent selection among polynomially many admissible chains
cannot give a polynomial-time universal factorer.

This closes a mathematically meaningful strategy question: can these
scalar-menu modifications make the uniform model-point ECM program
polynomial on all balanced semiprimes? The theorem answers no
unconditionally, with a quantitative time obstruction and a common
effective hard family. The usual conjectural ECM performance expression
does not answer that question. The constants are deliberately nonsharp;
no optimal `L`-constant or matching lower bound for the fastest practical
ECM implementation is claimed.

The exclusions are material. A scalar word constructed from the sampled
point outside the bank makes the support itself sample-dependent, and
the unconditional Hall-subgroup count used here no longer applies in
that form. Input-dependent scalar families with more than polynomial
shell variation are also outside the theorem. Rational-torsion curve
selection changes the sampling law, and independent group generators or
additional coordinate-gcd sources change the annihilation inventory.
Fast polynomial continuations and alternative coordinates in the
published ECM literature are not all covered. These boundaries limit
the result's application; they are not concealed behind a claim about
"all ECM." Extending any of them requires a new argument.

## 10. Prior implication and publication assessment

The detailed, proposition-level comparison is in `literature.md`.
Lenstra's chain-dependence warning, Montgomery's coefficient
sums/differences and batching, Brent's birthday continuation, and
classical Rankin/smooth-density estimates are credited there as prior
ingredients. Lenstra-Pomerance's rigorous class-group obstruction is
also credited: hard inputs contradicting a random-group-invariant
heuristic are not a new general strategy.

The accessible statements inspected do not establish the conjunction
needed here: necessary containment of actual affine factor events for
the signed bank; a growing-budget probability upper bound under actual
model-point weights; and one effective exact-length balanced squarefree
semiprime chosen before all selector randomness. Generic discrete-log
encoding bounds have different hypotheses. Conjectured expected ECM
runtimes are not success upper bounds, and nonsmooth quadratic
class-number inputs are not the required elliptic counterfamily.
These are precise non-implications, not an assertion that combining
familiar ingredients is automatically publishable.

The closest straight-line lower-bound comparison was resolved by the
independent publication Reviewer, not by extrapolating the primary abstract.
Brown's complete original paper, dated May 31, 2010, uses a fixed
input-independent ring program beginning with `1` and ending in a gcd
(Definitions 1-4, p. 3). Its ECM variant removes division and fixes its
curves, points, and scalar parameters. Section 5.1, p. 7, gives an
abstract integer straight-line-length minimization; Sections 5.2-5.3,
p. 8, discuss only an approximate linear-in-prime-bitlength bound.
Section 6, p. 9, describes a quadratic bit-operation consequence.
These are not the growing-budget success bound, adaptive affine
grammar, actual sampler weights, or common effective exact-length
counterfamily proved here.

Brown's Section 1.2, p. 2, identifies the relevant Riesel predecessor
precisely: the second edition (1994), pp. 223-224, of *Prime Numbers
and Computer Methods for Factorization*. The reproduced passage and
matching public original-book snippets discuss a hypothetical ideal
prime generator and its polynomial bit performance. They do not supply
the submitted ECM obstruction. The independently inspected 1985
*Modern factorization methods* article is a separate comparison, not a
substitute for that located passage. `literature.md` gives the readable
primary sources and exact comparison scope.

The unconditional quantitative separation for this fully specified
adaptive arithmetic class, with the inclusion and representation limits
above, was accepted as `verified_new` and `publishable` by the independent
Reviewer in `1245a1519b6b/round-0001.json`. That assessment credits the
classical ingredients rather than claiming a new smooth-number theorem.
Together with `36a7419624f7/round-0001.json`, it supplies the existing
independent correctness, statement-fidelity, originality, and significance
verdicts for this same theorem.

The final submission is the Section 2 theorem under the operator's
authorized **unconditional-counterfamily** branch. It is not a new
polynomial-time factoring reduction or an unrestricted factoring lower
bound. Campaign closure still requires the Host to persist a final
independent Reviewer verdict tied to this submission and recognize it
at the project research-target gate. This manuscript does not issue
that verdict or assert that the final receipt already exists.
