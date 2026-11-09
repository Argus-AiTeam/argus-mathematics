# Fixed-radius correction with complete product request laws

## Scope and source fidelity

The target is Proposition `ib:average-correction` in the staged manuscript,
`build/sections/08-inner-binary.tex`, label at line 949. Its quantifier order is
one positive radius for a fixed template, then arbitrary fixed request-density
bound and error target, then a bounded query schedule. The reference need only
be structurally canonical, not a valid computational label. A point or line Y
request is dominated on its complete edge/column index; a Z request is dominated
on the complete pair of edge/point indices. Specified forms and multipliers
are not required to be uniform. Neither conditioning on a rare executed branch
nor replacing joint domination by separate marginal domination is permitted.

The load-bearing source assertions are:

| Assertion | Source locator | Mathematical use |
|---|---|---|
| Row code and covariance | `ib:row-extension`, `ib:covariance` | Local distance, public interpolation, value-preserving shifts |
| One-axis support contraction | `ib:one-axis-support`, label at line 677 | Value-independent error envelopes |
| Two-axis support contraction | `ib:two-axis-support`, label at line 759 | Complete edge-pair envelopes and cone-specific values |
| Inner-table prediction | `ib:inner-table-prediction`, label at line 805 | Flags and arbitrary specified inner bits |
| Consistent simulation | `ib:bit-simulation`, label at line 858 | One assignment for repeated inputs within each cone |
| Average correction | `ib:average-correction` | Radius fixed before density, rounds, and amplification |
| Unconditioned smoothness | `ib:all-branch-density` | Potential slots, including wrong-answer branches |

These are source locators, not an assertion that the entire manuscript has
been verified. In particular, constructing the expanding affine groups and
the canonical algebraic families is separate from verifying this correction
interface.

## Prior results and what they do not supply

A bounded primary-source lookup obtained these papers:

* G. Zemor, *On Expander Codes*, IEEE Transactions on Information Theory
  47(2), 835--837 (2001), Section III-A, Lemma 5 and Theorem 6;
  <https://courses.grainger.illinois.edu/cs598sgt/sp2015/zemor.pdf>.
  These concern alternating decoding of a binary expander code. The
  distance-based proof supplies support envelopes, but the stated theorem
  does not include bilinear alphabets, repeated edges, or the present
  complete-product request interface.
* M. Blum, M. Luby, R. Rubinfeld, *Self-Testing/Correcting with Applications
  to Numerical Problems*, JCSS 47(3), 549--595 (1993),
  DOI `10.1016/0022-0000(93)90044-W`; author manuscript Section 3.8,
  Theorem 1, and Section 4.2, Lemmas 9--10;
  <https://people.csail.mit.edu/ronitt/papers/selftestcorrect.pdf>.
  Random self-reduction and high-agreement homomorphism replacement supply
  ingredients, not identification of an unspecified intended symbol without
  a proximity promise.
* B. Hemenway, R. Ostrovsky, M. Wootters, *Local Correctability of Expander
  Codes*, `arxiv:1304.8129v2`, Definition 3 and Theorem 5;
  <https://arxiv.org/pdf/1304.8129v2>.
  This assumes a constituent code with smooth reconstruction and gives
  expander-code local correction, not the flagged product-table composition
  studied here.

These are contextual prior art, not unproved inputs to the direct proof below.
The bounded lookup does not establish novelty. Independent significance and
novelty assessment remain necessary.

A pointwise decoding failure does not refute an average guarantee. One finite
size does not refute an assertion allowing a size cutoff. Those two routes
cannot settle the literal proposition and will not be substituted for it.

## Correction theorem

### Objects and hypotheses

Fix positive integers `a, B, T`, a degree `d >= 8`, and a finite field J of
characteristic two. The integer a bounds the number of row axes, not the
number of input ports. All these counts are fixed with the template.

Let G be a finite group and let the labelled bipartite graph have left and
right vertices G and edges `(i,g)`, `1 <= i <= d`, from g to `u_i g`.
Repeated generators and edges retain their distinct labels. Assume the
cross-part normalized second singular norm is at most `1/64`. On each side
use a `c`-by-`d` parity-check matrix over J, where `c = floor(d/4)`, whose
every c-column minor is nonzero.

There are B equally weighted blocks. A block has j row axes, `1 <= j <= a`.
Its complete outer index consists of j edges and j column arguments in
finite transitive G-sets. There are also a fixed number of mask axes, each
an additive vector group of characteristic two. Its reference bit is
multilinear in those masks. Independently splitting them expands a requested
bit into at most T terms; include zero terms if necessary so that a type's
term count does not depend on the requested masks.

For each fixed column argument and mask tuple, the reference symbols obey
the row constraints in each edge slice. The symbol alphabet is either J,
with its Hadamard representation, or the additive group of binary j-linear
functions on `J^j`. In the latter case the scalar action for row axis v is
precomposition by multiplication in multiplier coordinate v. These actions
commute. The reference satisfies covariance independently in each row axis:

```
(i,g,I) -> (i,g h,h^(-1) I)
```

preserves the symbol, before applying its requested inner form or
multiplier tuple. The legal inner tables are the corresponding additive
or j-linear functions, including uniform repetition copies.

These are explicit hypotheses, not conclusions about arbitrary arrays.
They are exactly the correction-relevant properties of the source Y blocks
(j=1, including ordered-line columns) and Z blocks (j=2). For an efficiency
conclusion, assume their public index sets, group operations, matrix
operations, and sampling supports are polynomial-time enumerable, as in
the manuscript.

### Theorem (common-exceptional-set correction)

Put

```
s_j = 2^(2-10j),
K_1 = 12,       K_j = (1 + 36*2^(j-1))*K_(j-1),
L_a = (a+1)*(1 + 3*a*K_a),
nu_2 = 2^(-a-6),
gamma = nu_2/L_a,
nu_1 = nu_2/(24*L_a),
rho = nu_1*s_a/(64*B*T).
```

For every received balanced word at distance at most rho from a reference
satisfying the hypotheses, and every `delta > 0`, there is a bounded-bit
randomized trial and, for each block, a set E of complete outer indices
such that

1. The uniform measure of E is at most `8*T*delta`.
2. E depends on the received word, reference, block, and round schedule,
   but not on the requested masks, inner forms, multiplier tuples, or
   request law.
3. At every complete outer index outside E, for **every** specified
   collection of masks and inner requests, the trial's error probability
   is at most `5/32`.
4. For any law dominated by C times uniform on the **complete** outer
   index, every unconditioned potential raw slot on a frozen hypothetical
   answer branch has density at most `B*C*d^a` relative to the balanced
   word. A complete answer tree of depth at most Q has summed density at
   most `B*C*d^a*Q*2^Q`.

Consequently, for every `C >= 1` and `0 < eta <= 1`, choose
`delta = eta/(16*T*C)` and amplify the complete independent trials.
Average error is at most eta, simultaneously for every such request law
and arbitrary request-dependent masks, forms, and multipliers.
The same rho works before C, eta, row rounds, and amplification counts
are specified. The theorem holds for every finite size satisfying its
hypotheses; it needs no new size cutoff depending on accuracy.
For a subdistribution, use `max(1,C)` in the parameter choice and retain
its missing mass rather than renormalizing it. The same exceptional-set
bound applies directly to its unnormalized mass. Finite lists of types
or branches can be charged by summing their error and density budgets.

The simultaneous exceptional-set assertion and the extension to every
fixed number of row axes are stronger than the source's stated averaged
one-/two-axis interface. This is a structural theorem with a direct proof,
not a claim that publication novelty has been established.

### 1. Value-independent one-axis envelopes

Write `t = floor(c/2)+1 = floor(d/8)+1` and `theta = t/d`.
For `d=8m+r`, `0 <= r <= 7`, the identity `8t-d=8-r > 0`
proves `theta >= 1/8` for every degree, not just tested degrees.
Local distance at least `c+1 > 2(t-1)` holds also for vector symbols:
projecting a nonzero vector word to a nonzero coordinate reduces any
purported smaller support to a scalar dependence among at most c columns.

Enumerate the information sets of size `d-c`, interpolate using the
invertible complementary minor, and accept the unique candidate at
distance at most `t-1`; use zero if none exists. Every candidate and
comparison is a public linear expression in the input symbols, followed
by symbol equalities and bounded Boolean processing.

Given a set U of initially uncertain edges, declare a star bad if it meets
at least t edges of U. After decoding that side, all possible errors lie
on the edges incident to bad stars. A nonbad star sees at most `t-1`
uncertain inputs and therefore decodes to the reference for **every**
assignment on U. This assertion inducts through half-rounds.

The first bad-star fraction is at most `8*zeta`, where zeta is the
initial edge density. If consecutive bad-star fractions are x and y,
counting edges between them and spectral mixing give, with multiplicity,

```
theta*y <= x*y + lambda*sqrt(x*y),     lambda <= 1/64.
```

If `x <= theta/2`, then either y is zero or the positive quantity
`theta-x` permits division and squaring, giving

```
y <= lambda^2*x/(theta-x)^2
  <= (2*lambda/theta)^2*x
  <= x/16.
```

For `zeta <= s_1=1/256`, the first fraction is at most `1/32`,
which is at most `theta/2`. Thus after h half-rounds the edge envelope
has density at most `(1/32)*16^(-(h-1))`, for every `h >= 1`.
Choose the first h for which this is at most the desired positive target.
All these envelopes use sets only, never the erroneous values.

### 2. Arbitrarily many row axes and cone-specific assignments

Induct on j. The initial density threshold is
`s_j = s_1*s_(j-1)/4`. Slices in the first `j-1` axes whose
initial density exceeds `s_(j-1)` occupy at most `s_1/4` of the
last-axis positions. Keep their entire stripes uncertain. In the other
slices apply the inductive schedule with target
`delta_1 = s_1*delta/4`. Residual density outside the bad stripes,
averaged over the whole product, is at most delta_1.

All but a fraction `2*delta_1/s_1` of last-axis slices have additional
uncertainty at most `s_1/2`. Their total uncertainty is at most
`3*s_1/4 < s_1`, so the one-axis schedule reduces them to
`delta_2 = delta/2`. Leave other slices wholly uncertain. Final density
is at most

```
2*delta_1/s_1 + delta_2 = delta.
```

The decoder does not have to identify the bad slices: it runs the same
fixed phase schedule on all slices. Bad stripes are an analysis envelope.
Intermediate arrays need not obey previously decoded axis constraints,
because each phase compares to the same fixed reference.

A fixed schedule and fixed degree give a finite dependency cone.
Deduplicate repeated initial positions within that cone. Every assignment
on its uncertain inputs that gives one value to each repeated position
extends to a global assignment equal to the reference off U. The global
envelope therefore controls that cone's output. Different cones need not
use a common assignment. This proves the source's cone-consistency
requirement, and its j-axis extension.

### 3. Quantitative inner-table flags, without a literature assumption

For an exponent-two group map f, let e be its addition-test failure and
`D_x(y)=f(x+y)+f(y)`. The two addition identities at
`(x+y,y+z)` and `(y,y+z)` show that
`Pr[D_x(y)=D_x(z)] >= 1-2e`, for every fixed x. Consequently a
most frequent value L(x) has mass at least `1-2e`.
For `e <= 1/12`, the identity

```
D_(x+y)(z) = D_x(y+z) + D_y(z)
```

and `6e < 1` make L additive. Also
`dist(f,L) <= e/(1-2e) <= 2e`. For `e > 1/12`, zero is an
additive replacement at distance at most `1 <= 12e`. Thus in every
case an additive replacement costs at most `K_1*e`, with `K_1=12`,
independently of either group dimension.

A nonzero j-linear map is nonzero on at least `2^(-j)` of its
arguments: induct on j, viewing a first-coordinate contraction as a
nonzero linear map into the space of remaining multilinear maps.
Its kernel has relative size at most one half.

Now let `e_v` be the addition-test failures in j axes. Replace
the first `j-1` axes slice by slice, at cost
`d_0 <= K_(j-1)*sum_(v<j)e_v`. The last-axis value-test error
becomes at most `e_j+3d_0`. A false equality of `(j-1)`-linear
maps is detected on at least `2^(-(j-1))` of their arguments.
The one-axis result, with this map-space alphabet, gives a j-linear
replacement at total cost at most

```
(1+36*2^(j-1))*d_0 + 12*2^(j-1)*e_j
<= K_j*sum_v e_v.
```

The chosen recurrence for K_j dominates both coefficients, including
cases where the bound exceeds one. No dimension or alphabet factor has
entered.

For repetition copies, let `e_0` be random-copy disagreement. Replacing
each original bit by its copy majority costs at most e_0, since
`min(p,1-p) <= 2p(1-p)`. Each addition test changes by at most
`3e_0`. The tester that mixes copy comparison and the j addition tests
uniformly therefore satisfies

```
distance to a legal repeated inner table <= L_j * rejection,
L_j = (j+1)*(1+3*j*K_j) <= L_a.
```

All its individual raw reads have uniform inner-index and copy
marginals. Near any legal table at distance at most nu_1 its rejection
is at most `3*nu_1=gamma/8`; at distance greater than nu_2
from every legal table its rejection is greater than gamma.
Estimate rejection using N independent tests and threshold `gamma/2`.
Variance at most `1/(4N)` and a gap at least `gamma/4` give
flag-error probability at most `4/(N*gamma^2)`.

Distinct legal j-linear tables have distance at least `2^(-j)`.
The inequality `2*nu_2 < 2^(-a) <= 2^(-j)` gives uniqueness
inside nu_2. For a requested inner argument, split its j coordinates
independently and XOR all `2^j` values. Each queried tuple is uniform,
and each copy is fresh uniform, so one prediction trial errs with
probability at most `2^j*nu_2 <= 1/64`. A Hadamard request uses
the same argument with one split of its specified additive form.
Independent majority amplification gives any desired reliability.
The request may be arbitrary given all data preceding these fresh splits.

### 4. Consistent simulation and explicit bounded counts

For a cone, flag each distinct initial table once. Assign zero to a
flagged table. If unflagged and within nu_2 of a legal table, assign
that unique symbol. Except for the union of flag failures, this assigns
one value per repeated position and agrees with the reference at every
table within nu_1 of its reference. In the annulus, any assigned value
is permitted by the envelope theorem.

Process the finite symbol decoder bottom up. On a fixed symbolic branch
all candidates are public linear expressions in assigned initial symbols.
A false symbol equality is detected by a random Hadamard form with
probability `1/2`, or a random multiplier tuple with probability at
least `2^(-a)`. Scalar actions pull back to multiplier coordinates;
compositions and sums give bounded lists of specified initial bits.
Predict them using the preceding inner routine, with fresh splits
*after* all scalar pullbacks. No full hidden symbol is read or processed.

Here are explicit conservative counts used by `verify.py`. If the total
number of half-rounds in the longest schedule is H, put

```
M = d^H,
D = ((d^H-1)/(d-1))*binom(d,c)*d,
sigma = 1/(64*T).
```

There are at most M distinct initial positions and D symbol comparisons.
An interpolation uses `d-c` inputs; comparison with one received
coordinate therefore uses at most `d-c+1 <= d` expressions from the
preceding level. Its fully expanded expression has at most M terms.

Give each flag failure budget `sigma/(3M)`. Choose r equality trials
so that `(1-2^(-a))^r <= sigma/(3D)`. There are at most
`P=(D*r+1)*M` initial-bit predictions, including the final output.
Give each prediction error budget `sigma/(3P)`. The three union
bounds sum to at most sigma. This order fixes the symbol-level
comparisons before choosing inner-bit amplification; there is no
circular union bound over the later amplified raw tree.

For any independent prediction trials with error at most p, an odd
majority of `2m+1` trials has error at most

```
((1+p)/2) * (((1+p)^2/2)^m).
```

Indeed apply Markov's inequality to `2^(number of failures)`.
For `p=1/64`, as well as `p=5/32`, this rational ratio is
strictly below one, giving an explicit terminating count without
floating-point logarithms. For inner tables, every trial is independent
conditional on the specified bit and preceding data.

### 5. The common exceptional set and quantifier order

Call a row position initially uncertain when its received inner-table
distance from its reference exceeds nu_1. Each block has error at most
`B*rho`. Thus mean uncertain-row density over its uniform columns
is at most `B*rho/nu_1`. A column is bad if that density exceeds
s_a; the fraction of bad columns is at most
`B*rho/(nu_1*s_a)`.

For a fixed original request, split each mask axis independently.
In each expanded term, apply independent uniform covariance shifts to
its j outer coordinates. Transitivity makes its column arguments uniform;
its masks are independently uniform too. Thus its entire column is
uniform for **every fixed request**, including zero masks and zero
specified multipliers. The shifted row need not be independent of that
column. The chance that any of the at most T terms has a bad column is
at most

```
T*B*rho/(nu_1*s_a) = 1/64.
```

On good columns the phase schedule leaves row envelope density at most
delta. For a complete outer index x, let R(x) be the sum over terms
of the probabilities of hitting these good-column residual envelopes.
Crucially, the marginal law of each term's freshly split masks is
uniform conditional on x and its shift. It does not depend on the
specified masks. The inner forms and multipliers do not enter the
envelopes at all. Hence R is a function of x alone, valid simultaneously
for every requested form and mask.

Every fixed covariance shift is a permutation of the complete outer
index, including the full product index. Under the uniform law on x,
therefore, `E[R(x)] <= T*delta`. Define

```
E = {x : R(x) > 1/8}.
```

Markov gives `uniform(E) <= 8*T*delta`. For every x outside E and
every specified form and mask, the complete trial's error is at most

```
bad columns + residual envelopes + bit simulation
<= 1/64 + 1/8 + 1/64 = 5/32.
```

Cone-specific assignments cause no additional error: each envelope covers
every consistent assignment within its own cone.

For *any* law dominated by C times uniform, the same E has mass at most
`8*C*T*delta`. Set `delta=eta/(16*T*C)`. Independently amplify
the full trials at a fixed request to error at most `eta/2` outside E.
The exceptional mass is at most `eta/2`, proving the theorem.
The chosen rho contains neither C nor eta, nor any round or repetition
count. It is also independent of the actual requested forms. This proves
the original quantifier order, rather than a radius selected anew after
the accuracy is known.

### 6. Every hypothetical branch, not conditional smoothness

Freeze a hypothetical sequence of hidden answers, not the event that
these answers actually occurred. For a fixed shift the entire outer map
is a permutation. A fixed local row-star path then changes each label
among d choices and multiplies its group coordinate on the left by a
fixed group element. For each output and each possible input label there
is at most one preimage. This increases density by at most d per row
axis, hence by at most `d^j <= d^a` on the complete product.
This reasoning counts labelled edges even if generators coincide.

Enumerate path slots before deduplication. Retaining a representative,
skipping a candidate, selecting a flag outcome, or omitting a zero term
only restricts a slot's unconditioned distribution. A restricted
subdistribution is dominated pointwise by the original distribution.
Do not normalize it. The argument makes no assertion about density after
conditioning on a rare executed branch.

On each frozen branch all interpolation coefficients and expression
choices are public. The inner tests and prediction batches have uniform
raw inner marginals, and copies are uniform. A fresh batch is sampled
after its specified pullback; its individual queries may be correlated
with one another, which is harmless. One must not condition on preceding
answers from that batch. If a later specified form depends on earlier
data, its new independent batch has the same guarantee. This proves the
bound for arbitrary wrong-answer branches as well as correct ones.

The initial split masks were uniform conditional on the complete outer
index; inner simulation changes no column-mask address. Multiplying by
the block-weight factor B proves the slot bound `B*C*d^a`.
After all counts are fixed, unfolding a depth-Q raw bit routine yields
at most `Q*2^Q` potential occurrences. Summing gives the stated
finite size-independent density bound. Public zeros require no
placeholder query.

## What the executable certificate proves

Run, from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/inner-average-correction/verify.py
```

The verifier uses only Python's standard library and exact rational
arithmetic. It checks the source anchors, universal coefficient identities
used above, the degree threshold by all eight residues, explicit schedules
and all error budgets for supplied rational parameters, and the unchanged
radius when only C and eta change. Additional positive rational parameters
can be supplied with `--density C --accuracy eta`.

It also independently replays the typed Jacobian result for
`polynomial.box.enclosure.compute`. The exact polynomial
`(1+p)^2/2` on `0 <= p <= 5/32` is enclosed in
`[1/2,1369/2048]`, strictly below one at its upper endpoint.
The server version, protocol, inspected contract, payload, output, and
adapter exit/timeout status are preserved in dedicated JSON files.
That operation certifies this one amplification inequality, not the
probabilistic or combinatorial theorem.

The delicate universal analytical core is additionally formalized in
`lean/Main.lean`. A real Lean 4.31.0 compiler and axiom audit both returned
exit code zero, with `proof_holes=[]`, and Argus recorded mechanical
support for `IAC_FORMAL_CORE`. Its five declarations prove the mixing
contraction without unsafe squaring, product-support accounting, the
finite complete-index weighted exceptional-set inequality, the one set
that works for every form, and the radius-before-density/accuracy
numerical quantifier order. They do not construct the score R, the row
code, or the bit algorithm. The separate `lean/statement_fidelity.md`
states the exact objects and stronger or weaker hypotheses of each
declaration and still requires independent human assessment.

The compiler evidence can be regenerated with:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/inner-average-correction/lean/Main.lean --statement-fidelity research/inner-average-correction/lean/statement_fidelity.md --claim IAC_FORMAL_CORE --project-root .
```

No new Lake workspace was created. Certificates, source, fidelity note,
and compiler logs are under the owned correction directory. The exact
verifier checks that the current source and fidelity text match the
actual compiled and archived bytes; editing either invalidates its replay.

Separately labelled finite diagnostics exhaust all 65,536 bit tables on
`F_2^2 x F_2^2`, all 16 legal bilinear tables, the two distinct GF(4)
scalar actions, zero and nonzero multiplier pulls, and four-term arbitrary
request prediction. A cyclic-group model checks complete-index
permutations, row/column correlation, joint requests, and unconditioned
restriction. These finite computations are not an exhaustion proof of an
asymptotic statement; the universal argument is Sections 1--6.

In that diagnostic, a diagonal request law has uniform separate complete
outer marginals but joint density `d*N^2`. Independent covariance
shifts reduce it only to `d*N`, still unbounded as the group order N
grows. The invariants `(label,g+I)` agree in the two coordinates.
This is a counterexample to a **weakened marginal-only hypothesis**, not
to the manuscript, which expressly assumes the complete joint bound.
Likewise, normalizing a one-atom restriction of a uniform law increases
density by the whole domain size; merely restricting its unconditioned
mass does not. No flawed literal source assertion has been established
by these diagnostics, so there is no F-claim or refutation verdict.

The full correction theorem is a direct mathematical proof with exact
arithmetic evidence and a kernel-checked analytical core, not a complete
formalization of the code or simulator. The remaining support, algorithmic,
and probability arguments require independent mathematical review.

## Manuscript consequences and remaining frontier

For Y use one row axis, the requested additive form as its inner request,
and split the original slot masks and the two line-coefficient masks
where applicable. For Z use two row axes, include Q among the split
column masks, and keep the two specified multipliers as the inner
request. The source's two J-actions are exactly the multiplier
precompositions in the hypotheses. Uniform repetition copies and equal
block weights are already included. Thus, **conditional on the stated
construction properties**, the theorem verifies the complete
`ib:average-correction` interface and `ib:all-branch-density` for its
corrector. It does not verify the separate tester or every later
composition merely by analogy.

The proof is independent of valid computational labels; only the row
constraints, covariance, and inner multilinearity of a structurally
canonical reference are used. It also permits non-product j-linear
reference tables whenever they satisfy those same row constraints.
The one-port radius therefore need not change when later applications
ask for greater density, precision, or more correction rounds.
Its fixed B and T are those of the one-port template; the number of
blocks in a later actual template may change its own radius, as the
source explicitly allows.

This settles a necessary correction interface for `thm:port-gadget`,
not its tester, dummy encoding, geometric, physical occurrence, or
failed-gate robust-decision claims. The outer representation, geometry,
and decoding obligations of `thm:main` remain open. No refutation or
unconditional certification of either theorem is asserted.

Relative to the starting ledger, which contained only the campaign
objective and no mathematical evidence, the improvement is a direct
parameter-uniform proof with an explicit positive radius, explicit
query/error budgets, a form-independent exceptional set, an
arbitrary-fixed-axis extension, and five universally quantified
Lean-certified analytical declarations. Independent replay, statement
fidelity, and novelty/significance assessment are pending with the Host
Reviewer.
