# Explicit constants and characteristic threshold

**Assessment: supported in the stated scope, as a quantitative refinement
for good reductions.** The constants are uniform in the filtration degree,
selected determinant columns, and varying good characteristic. This is
neither an algorithm computing every bad prime nor a new abundance theorem.
Native independent acceptance and novelty remain unestablished.

## Exact assertion, attribution, and dependencies

The old `REPORT.md:138-184` proposes this refinement of the projective
manuscript's `thm:finite-data`. The source is pinned to revision
`4eaee87548250b2682affda7d05d947c05554bae`. This full effective assertion has
no separate old claim identifier: the index distinguishes it from both
`C9000036-FROB` v4 and `C9000036-FINITE-DATA` v7 instead of treating shared
files as additional proofs.

All hypotheses are exactly those restated and assessed in
`../geometric-reconstruction/report.md`: smooth connected complex projective
`W`, dimension `n>=2`; rational Cartier `D,H`, ample `H`; integral Cartier
`S`; positive integer `q`, real `r>1,epsilon>0`; all five numerical bounds;
the fixed smooth integral complete-intersection flag and nonnegative
minimum cotangent slope; the fixed off-axis high-jet system with integer
`k_0`; and the independently fixed blowup point and movable
complete-intersection witness with both endpoint inequalities. No extra
nefness or pseudo-effectivity hypothesis is inserted.

The required data and auxiliary filler system must all be fixed before
varying the characteristic. Write

    h=H^n>0, Lambda=product_i l_i,
    d_i=l_i Lambda h>0, a=7 Lambda h,
    g=genus(C), c=(n-1)max(4g-2,0).

Here there are `n-1` flag integers `l_i`. Choose the single filler line
`T_0` so that, for each `0<=v<k_0`, its remainder filler of class `T_0-vD`
is nonvanishing at the fixed jet point. There are only `k_0` such choices.
The proposed constants are

    C_0=max({0} union
       {2(T_0-vD).C-K_W.C+nc : 0<=v<k_0}),
    C_gamma=max({0} union
       {pi^*(T_0-vD-K_W/2).gamma/j_gamma : 0<=v<k_0}),
    P(X)=(aX+C_0+1) product_i(1+(aX+C_0)/d_i),
    A=7^n h, E=P(1)-A,
    delta_rank=1/4-A, delta_order=3/4-80 epsilon,
    P_*=max(2,k_0,(2n+2)(k_0-1),
             floor(E/delta_rank)+1,
             floor(2 C_gamma/delta_order)+1).

For **every good residual characteristic** `p>=P_*`, the proposed data would
give the same nonzero determinant `sigma`, of size `R=p^(2n)`, with

    ord(sigma)/R >= 1-rank_diagonal/R > 3/4,
    ord(sigma)/R <= 80 epsilon+2 C_gamma/p < 3/4.

Good characteristics are unbounded by the separate spreading argument.
This proves incompatibility of the purported data in ordinary mathematics,
conditional on the foundations and geometric arguments identified below.

## Decisive calculations

**Uniformity is finite-data uniformity.** `T_0`, the flag, `gamma`, its
positive normalization `j_gamma`, and the finite remainder list precede
`p`. Consequently `C_0,C_gamma` are fixed nonnegative rational numbers.
Every selected source-column weight average lies in `[0,q]`; the
movable-curve hypothesis already quantifies that whole interval. The error
maximum therefore need not range over unbounded choices of determinants.
The cotangent estimate contributes the fixed `nc`, not a characteristic-
dependent hidden constant. The geometric unit explicitly checked the
tensor-quotient and determinant arguments establishing these facts.

**The leading coefficient is exactly correct.** All coefficients of `P`
are nonnegative. Moreover

    product_i d_i = Lambda^n h^(n-1),
    leading(P) = a^n / product_i d_i = 7^n h = A.

The first identity uses the *same* `n-1` flag integers in `Lambda`;
changing that indexing would spoil the cancellation. If
`P(X)=A X^n+sum_{j<n} c_j X^j`, then `c_j>=0`,
`E=sum_{j<n} c_j>=0`, and for every real `p>=1`,

    P(p)/p^n = A+sum_{j<n} c_j/p^(n-j) <= A+E/p.

The geometric per-piece section bound is `e_j P(p)` and the total
truncated rank is `sum e_j=p^n`. Thus, for the diagonal rank `t`,
`t/R<=P(p)/p^n`. There is no additional factor for the number of pieces.

**The floor counts and formal specialization agree.** The `n` rational
factor pairs in the Lean product are

    (a,C_0+1), (a/d_i,1+C_0/d_i).

Their second coordinates are at least one. They give exactly the curve
count `floor(pa+C_0)+1` and the flag bounds
`floor((pa+C_0)/d_i)+1`. `rank_from_evaluations` derives the scalar rank
bound from injections and these counts; `explicit_uniform_error` proves
the product error. Construction of the actual injections is still the
prose geometric obligation, assessed separately.

**Both strict gaps survive integer rounding.** The original hypotheses
give

    A=7^n h <= (14 epsilon)^n < 1/4,
    80 epsilon < 3/4.

For a real `x`, an integer `p>=floor(x)+1` satisfies `p>x`, including when
`x` is an integer. The two floor terms therefore give
`E/p<delta_rank` and `2 C_gamma/p<delta_order`.
When an error is zero the strict inequalities still follow from the
positive gap; no division by a zero gap occurs. The remaining threshold
terms ensure positive characteristic, a nonzero product count and the
ordinary-to-Frobenius jet containment. They need no extra primality
condition beyond `p` being a residual characteristic.

**The two errors concern one determinant.** Its factor orders are bounded
using `C_gamma` and the endpoint hypothesis, giving the factor-of-two
upper error. At the independently fixed diagonal point, residue-field
row operations and ideal-power membership give lower order `R-t`.
The external-product adapted-order argument bounds that *same* section
above. Using a different determinant or the original jet point would not
be a valid substitute; neither substitution is made.

## Evidence scope and external inputs

The seven-section geometric assessment supports spreading, jet realization,
global filtration, uniform slopes, flag evaluation, determinant normalization
and the shared order comparison. It read the actual hypotheses of Stacks
01ZM, Lemma 32.10.1 (1)-(3); Stacks 0559, Lemma 37.27.5; Nitsure
`arxiv:math/0504590v1`, Theorem 5.1; and Langer
`doi:10.4007/annals.2004.159.251`, Corollary 2.5. Their precise applications
and standard geometric foundations remain explicit in that report.
The old ledger already records these assumptions and later independent
attributions; no new assumption is silently discharged by a compile.

The formal unit's fresh Lean 4.31.0 compile and axiom audit both exited
zero, without holes. Its unchanged source proves the rational product,
count, dimension and conditional contradiction interfaces, not the
geometric constants' realizability. The exact Python replay, exit zero
under CPython 3.13.5, confirms both old scalar fixtures:

| Fixture | `A` | `E` | rank threshold | order threshold | jet threshold | `P_*` | tested prime |
|---|---:|---:|---:|---:|---:|---:|---:|
| `n=2,k_0=3` | `49/10000` | `1628/25` | 266 | 15 | 12 | 266 | 269 |
| `n=3,k_0=2` | `343/1000000` | `12247/10000` | 5 | 1 | 8 | 8 | 11 |

These are finite scalar experiments, not witnesses to the geometric
hypotheses. The universal coefficient argument above, not the number of
fixtures, establishes the general budget. A GF(3) matrix rank cannot
establish it.

## Strengthening versus effectiveness and novelty

The pinned original already contains the same geometric proof architecture,
finite Quot preservation, remainder-class uniformity and adapted-order
argument. The old draft makes the error budgets and threshold explicit;
it does not weaken the hypotheses or strengthen the geometric conclusion.
This is an explicit quantitative refinement of a reproduction, not a new
proof of numerical semiampleness.

There are two important limitations. First, `P_*` does **not** compute the
localization integer excluding bad primes, bound all such primes, or
algorithmically construct the spread, its ample fillers and geometric
witnesses. The statement says "every good prime at least `P_*`", not
"every prime at least `P_*`". Second, original `epsilon,r` may be irrational.
The real-scalar argument above proves the exact displayed threshold in
prose; applying the rational Lean theorem through a rational upper budget
may enlarge it. No rationality assumption on the original data is justified.

No concrete gap was identified in this scoped assertion. No search for
novelty is needed to certify a novelty claim the old draft expressly
declines to make. Its contribution is proposed explicit bookkeeping;
priority, originality and publishability are **not established**. Current
review adds assessment and reproducibility, not a stronger theorem.
