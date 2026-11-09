# Quantitative audit of linear alignment

## Scope and source propositions

This audit concerns `lem:linear-alignment` in the staged September 23, 2026
manuscript, `build/sections/dynamics.tex`, lines 199--447. It does not assert
the geometric realizability of arbitrary rate data, or settle uniformization.
The existing campaign ledger contained no mathematical result on this lemma.

The inputs taken from the manuscript, rather than independently proved here,
are its diagonal derivative formula `eq:dyn:diagonal-rates`, its quadratic-form
order `eq:dyn:loewner-jump`, the regular rate bounds
`eq:dyn:regular-rates`, and the regular grid spacing. In particular, at a jump
from an old step to a new step,

    U diag(alpha) U* <= diag(beta),

where U sends old tangent components to new tangent components. Row vectors
therefore transform by right multiplication by U, exactly as in the source.
Changing this convention would change the question.

The weights to be audited are the actual finite-graph propagated weights
defined in lines 298--347, not freely chosen weights. Same-step edges are
included, and cycles are permitted. Across adjacent regular macros the
multiplier is `lambda[j+1]/lambda[j] = 1 + K0/j^2`.

The intended verification must cover both the graph-extension formula
`eq:dyn:graph-extension` and a backward induction with constants independent
of the number of steps. A finite sample cannot establish that conclusion.
No false manuscript assertion or admissible counterexample has been
established at scope.

## Literature boundary

The source itself states the fixed-contraction hypothesis
`A |z| <= |f_j(z)| <= B |z|`, with fixed `0 < A < B < 1`, when citing
Bera--Verma, Theorem 1.1. The variable-rate input displayed in
`eq:dyn:rate-input` does not supply these constants. Applying that basin
theorem directly is a retired shortcut, not a manuscript refutation.
The verification route below does not use this external theorem.

The assigned Wiki index was searched for this campaign, Yau, Kahler, and
propagated weights; it contained no matching project knowledge. No external
literature theorem is being used to discharge the finite-dimensional
alignment question. Novelty and publication-level significance require
independent review, separately from correctness.

## Jacobian scope

The installed adapter was queried before custom feasibility code. Its
returned candidates included exact rational PSD comparison and exact matrix
inversion. Neither inspected contract proves a nested-flag existence theorem
or a bound uniform in an arbitrary horizon. This mismatch is recorded once in
`jacobian/discovery.json`. A bounded PSD operation is used only for an exact
noncommuting example, not as evidence for a universal theorem.

## Result: a robust quantitative alignment theorem

The linear-alignment conclusion follows from the displayed inputs. In fact
the end adjustments can be bounded by `O(j)`, their inverses by
`O(j^(n-1))`, and the conjugated start adjustments by `O(j)` times the
stated exponential. These are bounds for arbitrary horizons, not an
extrapolation from the examples.

Here is an abstract version that also allows arbitrary near-identity incoming
adjustments; the incoming perturbation need not be triangular or unipotent.
All norms are Euclidean operator norms. At every step k let

    D_k = diag(exp(-alpha[k,i] T_k/2)),  T_k > 0,

and give its start and end the same real coordinate weights `w[k,i]`.
Successive steps have macro indices j and j', where `j'` is j or j+1.
For each old macro j suppose there are positive numbers `R_j,delta_j`,
with `delta_j <= R_j`, such that:

1. At every jump `U diag(alpha) U* <= diag(beta)`, U is unitary,
   and all old and new rates belong to `[0,R_j]`.
2. `w[new,i] < w[old,l]` implies
   `alpha[l] > beta[i] + delta_j`.
3. Within a step, `w[k,i] < w[k,l]` implies
   `alpha[k,l] > alpha[k,i] + delta_j`.
4. For fixed `A >= 1`, `h > 0`, `c0 > 0`,

       R_j/delta_j <= A j^2,
       delta_j T_k/2 >= c0 exp(hj/2)/j^2.

The weights are fixed in advance: truncating a backward horizon does not
reconstruct or change them. No bound on the number of steps in a macro is
assumed in this theorem.

Define

    P_j = 4 n^2 A j,       d0 = c0 h^4 / 1536,
    J >= max{1, 256 n^3 A^2/d0^2}.

On every finite consecutive run whose macro indices are at least J, there
are `L_k^+ = I + N_k` supported strictly from smaller to larger weight,
with terminal `L_last^+=I`, such that, for
`L_k^- = D_k^(-1) L_k^+ D_k`,

    J_k = L_(k+1)^- U_k (L_k^+)^(-1)

has exact zeros in every forbidden entry (allowed entries may also vanish).
Uniformly in the terminal step,

    ||L_k^+||       <= 2 n^2 A j,
    ||N_k||        <= P_j,
    ||(L_k^+)^-1|| <= n P_j^(n-1),
    ||L_k^- - I||  <= 4 n^3 A j exp(-c0 exp(hj/2)/j^2).

The same bounds hold for an infinite consecutive run. At its jumps one also
has

    ||J_k|| <= 2 n P_j^(n-1),    ||J_k^-1|| <= 4 n^2 A j.

The threshold is deliberately conservative but explicit. Its size, unlike
the number of steps in the horizon, may depend on all fixed grid parameters.

## Proof

### A. The literal propagated weights give the required separation

First, Loewner order implies that the sorted rate of each fixed index is
nondecreasing. To see this without a commuting-matrix assumption, intersect
the old spectral subspace for indices i through n, transported by U, with
the new spectral subspace for indices 1 through i. Their dimensions sum
to n+1, so the intersection contains a nonzero vector. Its old Rayleigh
quotient is at least the old i-th rate, and its new quotient at most the
new i-th rate. The quadratic-form order gives the claimed comparison.

Fix one macro and put `delta=epsilon_0 theta`. Along a permitted path,
times never decrease and a single edge lowers the rate by at most delta.
A new strict lower record cannot revisit a sorted index: its rate on a
later visit is at least its rate on the first visit. There are at most
n-1 new strict records after the initial vertex. Each drops the previous
record by at most delta, since its predecessor is not below that record.
Consequently, for any source reaching a vertex of rate mu,

    source_rate <= mu + (n-1) delta.

Taking the maximum raw weight over all such sources gives

    lambda(mu-theta) <= w
      <= lambda(mu-theta+(n-1)epsilon_0 theta)
      <= lambda(mu-0.9 theta).

This includes same-step cycles and is independent of the path length.
Reachability also gives weight nondecrease along every edge. Thus, inside
one macro, the absence of the required weight passage implies the strict
rate separation by delta, both within a step and across a jump. Conversely
the strict forbidden-entry conditions above do not impose freely chosen
weights: they have just been deduced for the manuscript's actual weights.

At an adjacent regular macro take `K0=2/b`, where `0<b<=1` is the regular
rate constant (decreasing b to at most one is harmless). Suppose
`j^2 >= K0` and `mu' >= mu-epsilon_0 theta_j`. The new raw weight minus
the old propagated weight is bounded below by the manuscript's expression

    lambda_j [
      (K0/j^2) mu'
      -(1+K0/j^2) Q_(j+1)/(j+1)^2
      +(0.9-epsilon_0) Q_j/j^2 ].

Since `mu' >= b Q_(j+1)` and `1+K0/j^2 <= 2`, its first two terms are at
least

    2 Q_(j+1) [1/j^2 - 1/(j+1)^2] >= 0.

The remaining term is positive. Thus the same passage rule holds at
the macro junction. Its contrapositive is precisely condition 2 with
the *old* macro's delta. The bounded product defining lambda and its
free overall scale also allow weights at least one, as in the source;
this scale does not affect the linear-alignment argument.

### B. A quantitative perturbed projection lemma

Consider one jump, write `A0=diag(alpha)`, `B0=diag(beta)`, and let
`B=(I+E)U`, with

    e=||E|| <= delta/(16R),       0<delta<=R.

For a threshold x let A_x be the span of the selected rows of B with
new weight at most x, and E_x the old coordinate space with weights at
most x. If A_x is nonzero, let r be the largest new rate among its
selected rows. A unit row `a` in A_x has a unique expression `a=cB`,
with c supported on those rows and `||c|| <= (1-e)^(-1)`.
Loewner order and expansion of `(I+E)B0(I+E)*` give

    a A0 a* <= [r + R(2e+e^2)]/(1-e)^2 <= r+8Re <= r+delta/2.

The middle inequality is justified by the exact identity

    (r+8Re)(1-e)^2 - r - R(2e+e^2)
      = e(2-e)(R-r) + 4Re(1-4e+2e^2) >= 0.

Here `0<=r<=R` and `e<=1/16<1/4`. This identity is checked symbolically
and its inequality is formalized in Lean.

Every old coordinate outside E_x has rate greater than `r+delta`.
All other old rates are nonnegative. Put `p=||P_E_x a||^2`. Then

    (r+delta)(1-p) <= a A0 a* <= r+delta/2.

It follows that

    p >= delta/[2(r+delta)] >= delta/(4R).

In particular, projection is injective on A_x and its inverse on its
image has norm at most

    K = 2 sqrt(R/delta).

If E_x is empty, the inequalities force A_x to be zero. If E_x is full,
the projection is the identity. Empty A_x causes no constraint. This
handles all boundary dimensions without choosing a nonexistent inverse.

### C. The nested graph extension really is compatible

List the distinct coordinate spaces E_x in increasing order and retain
the largest A_x for each repeated E_x. The retained row spaces are
nested. Start with the full graph `V_+=C^n`, whose inverse projection
`T_+` is the identity, and descend.

Suppose `A subset V_+`, where `P_E_+|V_+` is an isomorphism, and
`E subset E_+`. Set `Y=P_E A`; let `R_A:Y->A` invert `P_E|A`.
For e in E define exactly as in the manuscript

    T_E(e) = R_A(P_Y e) + T_+((I-P_Y)e).

Both terms lie in V_+. The often-delicate second projection is valid
because `(I-P_Y)e` belongs to E and hence E_+: therefore

    P_E T_+((I-P_Y)e) = (I-P_Y)e.

Together with `P_E R_A(P_Ye)=P_Ye`, this proves `P_E T_E=id_E`.
For e in Y the second term vanishes, so the range of T_E contains A.
It is a graph over E, contained in the preceding graph, with

    ||T_E|| <= ||R_A|| + ||T_+|| <= K + ||T_+||.

There are at most n-1 proper nonzero coordinate spaces. Hence all
resulting graph lifts have norm at most `1+(n-1)K <= nK`.
The Lean graph identities encode this construction with
`R=R_A P_Y` and `S=T_+|E`, not with an incorrectly assumed identity
map on the ambient space.

For every old coordinate i choose its lift at its own weight threshold
as row i of L. Its projection there is exactly its coordinate row.
Thus `L=I+N` has off-diagonal entries only at strictly larger column
weights. At any larger threshold the previously chosen rows remain in
that threshold's graph; their projections form a triangular basis
with identity diagonal blocks. They therefore span that graph.
Consequently `A_x L^(-1) subset E_x` for every required threshold,
which is exactly the claimed forbidden-entry zero pattern.

Strict weight triangularity gives `N^n=0` and
`L^(-1)=sum_{r=0}^{n-1}(-N)^r`. Since `K<=2 sqrt(A) j`,

    ||L|| <= sqrt(n) n K <= 2 n^2 A j,
    ||N|| <= 4 n^2 A j = P_j,
    ||L^(-1)|| <= n P_j^(n-1).

These are local estimates depending on the incoming smallness budget,
not on the previous graph chosen at a different time.

### D. The backward induction has an explicit invariant

Conjugating an allowed off-diagonal lift entry gives the exact formula

    (D^(-1) N D)_(i,l)
      = N_(i,l) exp[-(alpha_l-alpha_i)T/2].

The exponent has the negative sign and its rate difference exceeds
delta. Bounding each entry by `||N||` and then using Frobenius norm
therefore gives

    ||D^(-1) N D|| <= n P_j exp(-delta_j T/2)
      <= 4 n^3 A j exp(-c0 exp(hj/2)/j^2).

There is no claim that conjugation contracts all matrices; it contracts
this strict weight-supported N. Moreover
`L^+ D (L^-)^(-1)=D`, so the step derivative is unchanged.

For the next step j' is j or j+1. Its displayed start bound is at most

    4 n^3 A (j+1) exp[-c0 exp(hj/2)/(j+1)^2].

For every real `j>=1`, the nonnegative Taylor terms of the exponential
give

    exp(hj/2) >= (hj/2)^4/24,
    c0 exp(hj/2)/(j+1)^2 >= d0 j^2,
    exp(d0 j^2) >= d0^2 j^4/2.

Thus the next perturbation norm is at most

    8 n^3 A (j+1)/(d0^2 j^4)
      <= 16 n^3 A/(d0^2 j^3)
      <= 1/(16 A j^2)
      <= delta_j/(16 R_j).

The penultimate inequality is exactly the threshold
`d0^2 j >= 256 n^3 A^2`, and its cross-multiplied form is also
formalized in Lean. This is the invariant used in part B.

Take the terminal adjustment to be the identity. Its start perturbation
is zero. Parts B and C construct the preceding end adjustment, and the
last estimate supplies the invariant at the next backward step.
Induction covers every finite horizon with the same constants and the
same J. No factor is multiplied once per step: part C reconstructs a
new graph with an absolute bound at each step. This distinction is why
arbitrarily many steps in one macro cause no loss.

Since the incoming norm is at most `1/16`, multiplication by
`(I+E)U` and its inverse also yields the stated bounds for J and J^(-1).

### E. Infinite regular runs

Fix the weights, rates, grid and unitaries of an infinite run and let
the finite terminal step tend to infinity. For each fixed k the
coefficients of `L_k^+` lie in a bounded subset of a fixed
finite-dimensional complex space. Extract a convergent subsequence
for k=0, then for k=1, and so on, and take the diagonal subsequence.
Its limits retain diagonal entries one and the same strict support.
The inverse is the fixed finite polynomial `sum(-N)^r`, so inverse,
conjugation and jump matrices converge as well. The exact zero
conditions and all norm inequalities are closed. The limiting
matrices have all the asserted properties on the infinite run.

### F. Substitution of the manuscript's constants

For a regular old macro j and its regular successor, take

    delta_j = epsilon_0 Q_j/j^2,
    R_j = b^(-1) exp(M) Q_j,
    A = exp(M)/(b epsilon_0).

The old regular flag test implies `Q_(j+1) <= exp(M) Q_j`.
These R_j bound the rates in both steps, including at a macro junction.
If regular step lengths are at least `d sqrt(S_j)`, then

    T_k = Delta_s_k / sum_i alpha[k,i],
    delta_j T_k/2
      >= [epsilon_0 b d/(2n)] sqrt(S_j)/j^2.

Thus choose `c0=epsilon_0 b d/(2n)` and `S_j=exp(hj)`.
Increase the start index to meet the manuscript's regular-rate
threshold, `j^2>=2/b`, and J above. All constants depend only on
fixed `n,h,M,b,d,epsilon_0` (and hence may depend on the fixed grid
parameters); none depends on the horizon, number of regular steps,
absolute size of Q_j, or the particular unitary matrices.
This proves `lem:linear-alignment` under its stated upstream inputs.

## Exact and formal evidence

Run from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/linear_alignment/verify.py

The certificate checks three universal polynomial identities and the
arithmetic producing 1536 and 256. Its finite examples independently
construct the manuscript's propagated weights, check exact Loewner order,
execute the graph-extension formula, and check nilpotence, the inverse,
the negative conjugation exponent, and every forbidden zero. They include
a genuinely noncommuting backward run, a partial extension inside an
already proper graph, equal-rate blocks, and a same-step cycle attaining
the sharper `(n-1)delta` record-loss bound. These examples illustrate and
stress the algebra; the universal quantifiers are discharged by the proof
above, not by their enumeration.

`lean/Main.lean` formalizes six declarations: the three scalar implications
and the projection, containment and nesting identities for the graph
extension. `lean/statement_fidelity.md` specifies all their hypotheses and
explicitly excludes a formalization of the full analytic theorem.
Lean 4.31.0 compiled this source with `exit_code=0`, `proof_holes=[]`,
and a successful axiom audit. The current kernel certificate is
`lean/certificates/C_LA_CORE-9d5d22c99e2d6bbb.json`. The official compiler
result, not the Python replay, supplies this core's kernel evidence.
The finite examples are algebraic data, not chart-realized counterexamples
or a verification of geometric hypotheses for their sample parameters.

## Downstream consequence and remaining boundary

Exact aligned jumps preserve the componentwise ordinary-degree bounds
used by `lem:degree-control`, and the polynomial J/J^(-1) bounds supply
the linear-change estimates used in `eq:dyn:backward-operator`.
This verifies this one load-bearing passage in `prop:polynomial-models`.
It does not verify the nonlinear homological estimates, the bad-component
degree accounting, the geometric Loewner-order input, or the
surjectivity argument. In particular it neither proves nor refutes
`thm:uniformization`.

Compared with the prior state (an untested alignment assertion), this
provides a full conditional proof, a perturbation-stable abstract
generalization, sharper explicit polynomial exponents, and a computable
horizon-independent threshold. No false literal manuscript assertion
has been identified, so no `F_<LABEL>` refutation is manufactured.
Independent Reviewer replay and assessment of novelty/significance remain
required; Engineer does not claim that review has occurred.
