# Weighted pinning: universal arrow comparison

## Exact target and scope

The target is `lem:assignment`, quadratic manuscript,
`build/source/sections/polynomials.tex`, lines 502-681:

> For a finite zero-diagonal Hermitian contraction, arbitrary positive
> weights, any integer r >= 1, any t > 0, and any partial coloring with
> unassigned v, some color satisfies d_v^i - d_v <= 24 m_v, with beta = 80.

Here the polynomials, rooted spectral measure, and costs are exactly those
defined in that section. The all-unassigned largest-root condition
`t > 3/sqrt(r)` is NOT a hypothesis of this lemma.

The existing proof already establishes 21m when m >= a and 7m when m < a.
Neither constant is an original improvement by this audit.
No statement about either infinite-dimensional main theorem follows merely
from certifying this finite estimate.

## Universal verification and a smaller buffer

`Main.lean` proves the following universal theorem, with a direct
Lean 4.31.0 compiler run returning zero. `verify.py` performs the official
claim-bound compiler replay and records its result in `exact_certificate.json`.
Let

    H = [ -a  g* ]
        [  g   D ],     a > 0, D = diag(lambda_j).

Let the color couplings have nonnegative squared coordinates b_ij, with
probability-weighted mean b_j = |g_j|^2. Keep D fixed. Put m = (H_+)00.
For every beta >= 12,

    min_{i:p_i>0} [Tr(H_i)_+ - Tr(H)_+] <= 23 m,

where H_i has first diagonal -beta a. The probabilities need not be uniform; zero-probability options are allowed.
Repeated poles, zero poles, and zero residues are allowed. There is no
dimension bound. This is a proof, not an inference from passing examples.

Here is the proof, avoiding the manuscript's case split. Write
H = P - N for its positive and negative parts, and set

    e+ = Tr N_{lambda>0},   e- = Tr P_{lambda<=0},
    D0 = 8m + 4a,          B0 = 12m + 8a.

The standard positive-block coupling inequality gives

    g+ g+* <= 2m Lambda+ + (4m+2a) N++,
    g- g-* <= 2(m+a)|Lambda-| + (4m+2a) P--.

Fix epsilon > 0 and put L = e- + epsilon. Consequently,

    sum_{lambda>0} b_j/(D0+lambda_j) <= 2m + e+/2,
    sum_{lambda<=0} b_j/(L+|lambda_j|) <= 6m+4a.

For completeness, the first inequality follows by testing the displayed
positive-block quadratic-form inequality on
z_j = g_j/(D0+lambda_j), and using
z* N++ z <= e+ ||z||^2. The weighted energy
sum_j (D0+lambda_j)|z_j|^2 is the residue sum itself, and
D0 = 2(4m+2a). For the second inequality use the negative-block version:
the trace error is multiplied by e-/L <= 1, giving
2(m+a)+(4m+2a) = 6m+4a. Every denominator is strictly positive.

Two nonnegative averaged tests admit a common choice at twice their
respective upper mean bounds: normalize the tests by those bounds and
choose an option whose sum is at most its average, which is at most 2.
A zero upper bound forces its statistic to vanish at every
positive-probability option.

For this option the positive-block side arrow, with diagonal -D0, has
positive-trace increment at most 4m+e+. Indeed, its unique possible
negative eigenvalue has magnitude q satisfying
q = D0 + sum_j b_ij/(q+lambda_j), hence q-D0 is bounded by the test at D0.
The nonpositive-block side arrow with diagonal -B0 has positive trace
at most L: it has at most one positive eigenvalue, and an eigenvalue
s > L would require residue sum s+B0 > B0, contradicting the second test.
The Lean proof derives codimension-one eigenvalue uniqueness and these
secular comparisons directly from the actual spectral theorem; it does
not assume interlacing or a side-cost comparison.

Subadditivity bounds the full arrow at first diagonal -(20m+12a).
Changing that entry to -beta*a increases positive trace by at most
max(20m+(12-beta)a,0) <= 20m. Finally,

    Tr(H)_+ - Tr(Lambda)_+ = m+e++e-

shows that this option has cost increase at most 23m+epsilon.
Choose an option minimizing the cost on the finite nonempty
positive-probability support. Its cost satisfies that bound for every
epsilon>0, hence is at most 23m. This finite argument treats e-=0 and
zero poles without any continuity assumption on a choice function.

The declarations `weighted_pinning_split` and
`manuscript_arrow_assignment` prove the dimension-free statement and its
beta=80, 24m uniform-color corollary. `positiveTrace_eq_sum` and
`posPart_diag_eq` identify both costs with their actual spectral meanings.
There are no conclusion-shaped assumptions.

The improvement over the strongest relevant prior bound is a smaller
permanent penalty, 12a instead of 80a, at cost 23m rather than the
manuscript's already-established 21m. This is a quantitative tradeoff,
not an improvement of its 21m constant. Independent novelty/significance
assessment remains for the Host-invoked Reviewer; no literature search
establishes novelty by itself.

## Why this settles the finite manuscript estimate

Here is the reduction, separate from the compiler's spectral theorem.
The multivariate polynomial is the stated normalized derivative of a
product of Hermitian characteristic determinants. Each determinant is
nonzero when all variables are in the upper half-plane. The derivative
operations preserve this property: after fixing other upper-half-plane
variables, Gauss--Lucas applies, and the leading coefficient is the
corresponding processed deletion expression, nonzero by simultaneous
induction over the operations and principal sets. Thus no specialization
silently makes a required derivative the zero polynomial.

Multiaffineness and the exact deletion identity make P/P_-v affine
of slope one in its own diagonal variable. Its zero is outside the upper
half-plane, so, at common z, Im(P/P_-v) >= Im(z). Real coefficients and
the rational Pick property imply

    P/P_-v = z+a - sum_lambda b_lambda/(z-lambda),  b_lambda >= 0.

The nonremovable poles are real and simple with nonpositive residues;
higher order poles would violate the half-plane sign along some approach
angle. The constant term a follows from the fixed diagonal -a.
The deletion polynomial has real roots, including multiplicity.
Its Schur-complement realization is precisely the arrow used above,
with sqrt(b_lambda) in one fixed copy of each deletion root and zero
in the other copies. This construction also realizes removable poles.

Conditioning v on its color keeps the same deletion polynomial.
The exact outcome average gives (1/r)sum_i P_i^0 = P, so uniqueness of
partial fractions gives (1/r)sum_i b_i,lambda = b_lambda.
Increasing only its diagonal shift adds (beta-1)a to the quotient.
These are exactly the kernel theorem's hypotheses with p_i=1/r and
a=tW_v>0. All other weights, shifts and matrix entries have disappeared
from the comparison, so no weight cutoff, lower weight bound,
initial-cost condition, or strict-pole hypothesis is missing.

The first resolvent entry is P_-v/P, so its spectral probability
measure is exactly rho_v, and (H_+)00=m_v.
The arrow characteristic polynomial is P. The same holds for each
permanent color option. Since the deletion polynomial is shared,

    d_v^i-d_v = s(P_i)-s(P) = Tr(H_i)_+-Tr(H)_+.

The kernel theorem therefore gives the requested <=24m_v conclusion
for every finite datum in `lem:assignment`. The stable-polynomial
reduction in this subsection is a mathematical proof checked in prose,
not an additional Lean formalization. No false manuscript assertion was
identified, so no refutation claim or `refutes` judgement is appropriate.

## Sources and prior knowledge

The two manuscripts explicitly say their main proofs are independent.
Their headline claims and separate load-bearing dependencies are recorded
in the existing campaign ledger and proof graph without replacing its
context.

The quadratic finite endpoint estimates cite Ravichandran--Srivastava,
arXiv:1706.03737v2, Theorem 25, and Proposition 16 together with Theorem 15.
The approximation initial-root argument cites Marcus--Spielman--Srivastava,
arXiv:1306.3969v4, Theorems 4.1 and 5.1.
These are dependencies of the respective endpoint arguments, not assumptions
of the pinning theorem. The exact-version primary passages were obtained
and read: the RS statements match, including the zero-diagonal hypotheses
needed for Proposition 16; the MSS statements match independence/finite
support and PSD/identity-sum/trace hypotheses, respectively. Their source
files and passages are in this directory. Independent citation attribution
in the ledger remains pending for the Reviewer, not self-certified.

A targeted public search found the two staged manuscripts and no
verified earlier theorem with this precise cost comparison. Its generated
summary incorrectly conflated the two main results' rates, so that summary
is NOT used as a mathematical or novelty premise. The primary LaTeX
sources, not the search summary, fix the two headline statements.

The inherited wiki index contains no pinning, assignment, or paving entry.
No prior campaign result beyond the initial open objective was present.

## Jacobian capability boundary

Discovery used the Argus adapter with the assigned live-update interpreter.
The server reported version 0.14.0, protocol 2025-11-25, MCP stdio.
Returned polynomial and inertia contracts are bounded finite-data operations,
not universal positive-trace comparison theorems. In particular,
`matrix.inertia.compute` accepts rational symmetric matrices of dimension
at most 50; it cannot establish this dimension-free theorem.
A bounded zero-deletion-pole diagnostic is preserved separately in JSON.
The first payload, which redundantly listed both matrix triangles, was
rejected with `INVALID_REQUEST` and exit 2; its payload, structured error,
and status remain preserved and have no mathematical verdict.
The corrected one-triangle payload returned exit 0 and inertia
(2 positive, 1 negative, 0 zero). `verify.py` independently replays that
inertia using exact characteristic-root isolation.

`diagnose.py` separately tested 720 floating-point arrow families up to
deletion dimension 8, including empty blocks, zero probabilities, repeated
and zero poles, and zero residues. This is diagnostic evidence only and
is not used in the universal proof.

## Reproduction and remaining scope

Run, from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/pinning/verify.py

The script checks exact determinant/conditioning identities for admissible
finite coloring fixtures, replays the typed Jacobian diagnostic, compiles
the universal theorem through the official `lean_evidence verify --claim`
path, and runs both campaign-local structural checks. The archived
certificate binds the source and statement-fidelity document to the real
compiler outcome. `exact_certificate.json` records that artifact path and
the measured exit statuses; it is not a self-issued replacement for a
compiler result.

Host-invoked independent Reviewer reproduction and statement-fidelity,
novelty, and significance judgements are still required. The unrestricted
quadratic and approximation paving theorems remain unverified: their
separate measured, modular, atomless-kernel, and corner-assembly obligations
remain open in the proof graph.
