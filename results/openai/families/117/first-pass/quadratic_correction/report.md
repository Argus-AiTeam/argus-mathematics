# Quadratic correction on the manuscript's matrix walk

## Scope and source record

The target is `lem:quadratic-correction`, lines 442--557 of
`research/openai_manuscript/Constant-factor-hardness-of-uniform-sparsest-cut-September-24-2026/build/source/sections/02-bit-tests.tex`.
The line law at lines 391--393 reads every value `P(A+t h)`, for all
`t` in the field, and tests whether that entire function has degree at
most two. It is not a four-query test or a test of a randomly chosen
four-tuple. Bases are uniform in the full matrix space.

The actual direction is

    h = (c tensor u_j)(e tensor u_j)^T,

with independent uniform `c,e` in `F^101` and uniform pencil index `j`.
In particular, zero directions are allowed. Multiplication by any
nonzero field element preserves its law. The matrix space has uniform
measure, contains all the needed translates, and has arbitrary finite
dimension. The matrix-walk lemma supplies, for every nonempty set `E`,

    Pr[x+h in E | x uniform in E] <= mu(E) + lambda_1.

The spectral estimate and the pencil construction are explicit
dependencies, not consequences of the correction theorem.
For clarity, the stated mean-zero norm estimate implies the required
edge estimate directly: for `f=1_E-mu(E)`, uniform convolution preserves
constants and
`<1_E,T1_E>/mu(E) = mu(E)+<f,Tf>/mu(E)
 <= mu(E)+lambda_1(1-mu(E)) <= mu(E)+lambda_1`.
Here `||f||_2^2=mu(E)(1-mu(E))`; the pencil-dependent norm estimate
itself is still the separate premise.

The manuscript's literal assertion is:

> Put $\gamma=10^{-3}$. Suppose the line law of a function $P:G\to\F$
> fails with probability at most $\delta^2$, where $\delta>0$ satisfies
> $2\delta+\lambda_1<\gamma/2$,
> $1-4\gamma-4\delta-2/(q-1)>\delta+\lambda_1$, and
> $27\gamma+5\delta<1$.
> There is a scalar-invariant set $H$ of directions of
> $\mathsf D$-mass at least $1-\delta$, and a function $P'$ differing
> from $P$ on at most $2\delta$ of $G$, such that
> $t\mapsto P'(A+th)$ has degree at most two for every $A$ and $h\in H$.

No false assertion has been established. A counterexample at a small
field outside these inequalities, or a failed repair heuristic, would
not refute this existence statement.

## Prior result and dependencies

The official `openai/math` document `lean/docs/117.md`, retrieved through
the GitHub API, states that its formalization concerns the
Goemans--Linial integrality gap along an existential sequence of sizes,
with lower bound
`c sqrt(log n)/(log log n)^3`, positive relaxation optimum, and unit
demands on distinct pairs. It expressly does **not** assert
computational hardness or a result for every size. The exact retrieved
scope is in `literature/family117_scope.md`.

The supplied scope also reports an archived accepted comparator run.
That receipt has not been supplied or replayed in this mission; this
report does not promote that report into independent compiler evidence.
Neither it nor the existing integrality-gap formalization is needed
for the correction argument.

Both manuscripts' load-bearing source dependencies are recorded in
`research/PROOF_GRAPH.json`. The hardness chain beyond correction
(support gaps, bank affinity, Boolean decoding, events, rare events,
scores, paths, rational compilation, and all-cuts soundness) remains
outside this bounded result. The gap manuscript's metric, repair,
contraction, uniform-copy, duality, and asymptotic chain is recorded
separately. No arrow from correction to the full hardness theorem is
asserted.

The correction proof below is elementary conditional on the displayed
internal-edge estimate. The cited self-testing papers are historical
precedents, not imported restricted-direction correction theorems.
There was no relevant sparsest-cut or restricted-line correction page
in the inherited Wiki index. No novelty conclusion follows from that
absence.

## Parameterized verification theorem

Let `F` be any finite field of order `q`, `V` any finite-dimensional
`F`-vector space (including dimension zero), and `D` a probability law
on `V` invariant under every nonzero scalar. Write `mu` for uniform
measure on `V`. Assume the internal-edge estimate above with
`lambda >= 0`. Fix an integer `d >= 0` with `d < q-1` and real numbers
`epsilon >= 0`, `alpha,beta,gamma > 0`. Put

    rho = epsilon/beta,    r = d+1,    C = 2 r^2 + 3 r.

The generalized verification theorem has hypotheses

    2 epsilon/alpha + lambda < gamma/2,
    1 - (d+2)(alpha+gamma) - d/(q-1) > beta+lambda,
    C gamma + 3 rho < 1.

If the all-points degree-`d` line test fails with probability at most
`epsilon`, the conclusion is a single scalar-invariant `H` with
`D(H) >= 1-rho` and a single `P':V -> F` with
`mu(P' != P) <= 2 epsilon/alpha`, whose restrictions on every
`H`-direction line have degree at most `d`.

This includes the exact manuscript statement by setting
`d=2`, `epsilon=delta^2`, and `alpha=beta=delta`.
The last hypothesis is weaker: `27 gamma+3 delta<1`
instead of `27 gamma+5 delta<1`. It comes from charging membership
of a transverse direction in `H` only once, not once per old center.
This is a stronger verification statement, not an error in the original
conservative bound. The following proof does not assume the existence
of a correction.

## Proof

Write `B(x,h)` for failure of the complete degree-`d` line test at
base `x` and direction `h`. Its probability, for independent uniform
`x` and `h` of law `D`, is at most `epsilon`. Every probability below
is a finite sum; direction weights need not be rational. A nonzero
scalar permutes the field parameters, so `B(x,a h)=B(x,h)`.

### 1. One fixed set of good directions and one cleaned missing set

Define

    H = {h in supp(D) : Pr_x[B(x,h)] <= beta},
    D0 = {x : Pr_h[B(x,h)] > alpha}.

Markov's inequality gives `D(H) >= 1-rho` and
`mu(D0) <= epsilon/alpha`. The set `H` is scalar-invariant, because
both its defining failure fraction and `supp(D)` are. It is fixed
from now on, not changed during completion.

Start with `D0` and repeatedly adjoin any outside point `x` for which
`Pr_h[x+h in D] >= gamma`, stopping when none remains. This terminates
because `V` is finite. If `D0` is empty there is no addition. Otherwise
put `k=|D0|`. If a first set of size `2k` is reached, each of its `k`
added source points contributes at least `gamma` to its outgoing
weight into that final set. Its total internal directed weight,
divided by its cardinality, is therefore at least `gamma/2`.
But its density is at most `2 epsilon/alpha`, so the internal-edge
hypothesis makes that same average strictly less than `gamma/2`.
This is a contradiction. Consequently the final set `D` has density
at most `2 epsilon/alpha`; every point outside `D` enters `D` with
probability strictly less than `gamma`. These are the initially
assigned, or clean, points. No symmetry of directed edges is used.

### 2. Every clean interpolation relation is exact

For `d+2` distinct field elements `t_0,...,t_{d+1}`, put

    c_i = 1 / product_{j != i}(t_i-t_j).

All `c_i` are nonzero. The relation

    sum_i c_i f(t_i) = 0                                      (R)

holds for every polynomial `f` of degree at most `d`: in Lagrange
interpolation on these `d+2` nodes it is the coefficient of degree
`d+1`. Conversely, if all these relations hold for a function on the
field, interpolation on any `d+1` nodes gives its values at every
remaining node, hence represents it by a polynomial of degree at most
`d`. Here `d<q-1` supplies at least `d+2` distinct nodes.

Fix `h in H` and one such tuple. Let `J` be the set of bases `x`
whose `d+2` positions `z_i=x+t_i h` are clean but violate (R).
Then `mu(J) <= beta`, since every such base has a failing `h`-line.
If `J` is nonempty, fix `x in J` and independently sample `k~D`
and uniform `a in F*`.

Since `z_i` is outside `D0`, all `d+2` functions
`s -> P(z_i+s k)` are degree at most `d` except on an event of
probability at most `(d+2) alpha`. On that event's complement,
their discrepancy polynomial is nonzero at zero and of degree at
most `d`. It therefore vanishes at at most `d` nonzero values of
`a`. This root count follows by successive division by `s-a`;
it is valid in arbitrary characteristic. Separately, each
`z_i+a k` lies in `D` with probability less than `gamma`, because
`a k` has exactly law `D`.

These are unconditional union bounds; no cleanliness probability
is conditioned on line goodness. Thus

    Pr_{k,a}[x+a k in J]
      >= 1 - (d+2)(alpha+gamma) - d/(q-1)
       > beta+lambda.

The step `a k` still has law `D`, including its atom at zero.
Averaging over uniform `x in J` contradicts the internal-edge
bound `mu(J)+lambda <= beta+lambda`. Therefore `J` is empty.
All `H`-direction interpolation relations on clean points are exact.

### 3. A modal filling lemma

At any stage let `M` be the remaining missing set and `S=V\M`
the old assigned set. Maintain:

1. every assigned point enters `M` with probability at most `gamma`;
2. every `H`-direction relation (R) on assigned points is exact.

The preceding steps initialize both invariants. If `M` is nonempty,
its average internal entry probability is at most

    mu(M)+lambda <= 2 epsilon/alpha+lambda < gamma/2.

Hence some `x in M` enters `M` with probability less than `gamma/2`,
and in particular at most `gamma`. All entry estimates in this step
refer to the **old** missing set, before assigning `x`.

Fix once `r=d+1` distinct nonzero parameters `a_1,...,a_r`, and let
`l_i` be the Lagrange coefficients for evaluation at zero on them:

    l_i = product_{j != i} (-a_j)/(a_i-a_j).

For each direction `k`, predict
`p_x(k)=sum_i l_i P'(x+a_i k)` if all `r` positions belong to `S`;
otherwise give a fixed default, say zero. The full distribution,
including defaults and directions outside `H`, is denoted `pi_x`.
Only already assigned values occur in this definition.

For independent directions `h,k`, require their `2r` axis points
`x+a_i h`, `x+a_j k`, and their `r^2` grid points
`x+a_i h+a_j k` to be old assigned. The axes fail with probability
at most `2r gamma`. For each grid point, first expose `h`. On the
event its first-axis center is assigned, that center has entry
probability at most `gamma` into `M` along `a_j k`, independently
of `h`. Thus

    Pr[first-axis center assigned, grid point missing] <= gamma.

Combining these events with the axis failures costs at most
`r^2 gamma`; an unconditional bound on a grid point with a missing
first-axis center is neither asserted nor needed. Requiring both
directions to belong to `H` costs at most `2rho`.

On the resulting event, each assigned row center is its `k`-direction
interpolation from the grid; each assigned column center is its
`h`-direction interpolation. This follows from invariant 2 on
the `r+1=d+2` parameters `0,a_1,...,a_r`. Therefore both predictions
equal the same double sum

    sum_i sum_j l_i l_j P'(x+a_i h+a_j k).

Put `A=r^2+2r`. The collision probability of the full distribution
`pi_x` is at least `1-A gamma-2rho`. For any finite probability
vector `pi`, its collision probability `sum_v pi(v)^2` is at most
its largest atom, since `sum_v pi(v)=1`. Choose one modal value
`m_x`, with ties resolved in any fixed order. It satisfies

    Pr_k[p_x(k) != m_x] <= A gamma+2rho.                       (M)

This selection is independent of every individual relation to be
checked next. In particular it is not a separate choice for each
direction or relation.

### 4. Simultaneous consistency of the one selected value

Assign `m_x` to `x`. Take any newly enabled relation (R).
If its direction is zero it is the automatic constant-line
identity. Otherwise scalar multiplication in a vector space makes
its positions distinct, so exactly one position is `x`; call its
`r+1` centers `z_0=x,z_1,...,z_r`.

Choose a fresh `k~D`, requiring only the following three events:

* `k in H`, costing at most `rho`;
* all `r(r+1)` points `z_i+a_j k` are old assigned, costing at most
  `r(r+1) gamma` by the entry bounds at these centers;
* the full prediction `p_x(k)` equals the already selected `m_x`,
  costing at most `A gamma+2rho` by (M).

Their intersection has probability at least

    1 - (2r^2+3r) gamma - 3rho > 0.

Thus such a direction exists. At every old center, its translated
values interpolate to its old value by invariant 2 and `k in H`.
At `x`, those values interpolate to `m_x` by the last two events.
For each fixed `a_j`, the translated copy of the proposed relation
lies entirely in `S` and has the original `H`-direction, so is zero.
Consequently

    sum_i c_i value(z_i)
      = sum_j l_j [sum_i c_i old_value(z_i+a_j k)] = 0.

This identity is just distributivity and interchange of two finite
sums. Grid coincidences denote the same old value and do not require
independence. A grid point equal to the formerly missing `x` has
already been excluded by the old-assignment event.

This proves every new relation for the **same** value `m_x`;
the witnessing transverse direction may differ from relation to
relation. There is no union bound over the number of relations,
directions, points, or filling steps. After removing `x` from `M`,
all old entry probabilities only decrease, and the bound at `x`
continues to hold. Both induction invariants are preserved.

### 5. Termination and the manuscript specialization

The finite induction fills every missing point. Invariant 2 and
the interpolation equivalence in step 2 show that every resulting
`H`-line has degree at most `d`. Only points of the original set
`D` were ever changed. This proves the claimed disagreement bound
and completes the generalized theorem in every finite dimension.

For the manuscript use `d=2`, `r=3`, `epsilon=delta^2`,
`alpha=beta=delta`, and `lambda=lambda_1`. Then
`rho=delta`, `A=15`, `C=27`, the cleanup and propagation
hypotheses are exactly the displayed manuscript inequalities, and
`27 gamma+5delta<1` implies `27 gamma+3delta<1`.
The original constants, a single global correction, the single
scalar-invariant direction set, and the zero-direction case are all
covered. No additional dimension-dependent hypothesis is introduced.

## A nonvacuous all-degree corollary

The generalized conditions have simultaneous solutions for every
degree, not only for the manuscript's degree two. For `r=d+1 >= 1`
and `C=2r^2+3r`, take

    gamma = 1/(8C),
    0 <= lambda <= gamma/4,
    0 < delta <= gamma/16,
    alpha=beta=delta,    epsilon=delta^2,
    d/(q-1) <= 1/4,      d<q-1.

The cleanup margin is at least `gamma/8>0`. The propagation margin
is at least

    (192r^2+271r-22)/(128C) > 0,

and the completion margin is at least

    (224r^2+336r-3)/(128C) > 0.

Writing `s=r-1>=0`, their numerators become respectively
`192s^2+655s+441` and `224s^2+784s+557`, which have positive
constant terms and nonnegative other terms. This supplies explicit
dimension-free thresholds and error of order at most `d^{-4}` in
the degree parameter, without asserting a total-degree conclusion
outside the retained direction set.

## Certification scope and comparison with prior work

The result here is a **parameterized mathematical proof**, not a
bounded exhaustion or a counterexample. Relative to the strongest
previous project result, the manuscript's correction claim, it
allows every degree below `q-1`, arbitrary finite fields and
scalar-invariant expanding direction laws, asymmetric Markov
thresholds, and the smaller direction-loss term `3rho` in the
completion condition. It does not improve the already formalized
integrality-gap asymptotic or certify the full hardness pipeline.

`verify.py` and `exact_certificate.json` replay the exact symbolic
budget identities and explicit parameter margins. The proof of
the quantified theorem is the finite argument above; a successful
Python run alone is not represented as a kernel proof of that
argument.

The algebraic core `Q_KERNEL` has now compiled with the prescribed
Lean **4.31.0** verifier: compiler exit code `0`, axiom-audit exit code
`0`, and `proof_holes=[]`. Its archived certificate is
`certificates/Q_KERNEL-9dabfbe65d434cae.json`. Only this separate
claim has earned `closed_kernel`. `statement_fidelity.md` describes
its exact declarations and expressly excludes the full correction
theorem. The replay script checks the archived compiler result,
current source and fidelity hashes, and the actual ledger binding;
it cannot manufacture a compiler verdict.

From the campaign root, rerun the standalone exact replay with:

    $WORKSPACE/argus-live-update/.venv/bin/python research/quadratic_correction/verify.py

The Host-invoked Reviewer must still read the complete proof,
assess statement fidelity, and decide novelty and significance.
No independent acceptance is pre-recorded.

Novelty and publishability require independent assessment. A
literature search suggested ECCC TR26-054 and TR26-057 as
restricted-direction correction references; opening both primary
pages showed instead *Optimal Single-Pass Streaming Lower Bounds
for Approximating CSPs* and *Explicit Constant-Alphabet Subspace
Design Codes*. Those suggestions are not evidence and no theorem
from them is assumed. No verified prior-literature equivalence or
`verified_new` classification is claimed here.

The Jacobian adapter was used only for the bounded exact enclosure
of the manuscript cleanup margin on
`0<=delta<=1/16000`, `0<=lambda<=1/1000000`.
Its lower endpoint is `187/500000>0`. The exact input and typed
output are preserved in `jacobian_request.json` and
`jacobian_result.json`; `jacobian_status.json` records its status.
This algebraic move does not replace any step of the theorem.
