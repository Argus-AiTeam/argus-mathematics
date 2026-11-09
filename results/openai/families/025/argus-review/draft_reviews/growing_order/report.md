# Growing-order divisor moments: assessment of the existing draft

**Verdict:** the explicit series estimate and simultaneous upper theorem are
supported by the unchanged, historically reviewed Lean certificate and by the
statement/argument reading below. The infinite primorial obstruction is supported
by its elementary mathematical argument, not by Lean or finite sampling. Their
conjunction determines a growth scale up to constants. Novelty and publishable
significance remain unestablished. This is an Engineer assessment for the native
independent Reviewer, not acceptance of this unit or the family.

## Sources, versions, and attribution

All relative historical paths in this report are beneath
`campaigns/9000025`.
The source is `research/growing_divisor_moments/`, especially `proof.md`,
`growing.lean.txt`, `Main.lean`, and `statement_fidelity.md`.
`research/DRAFT_REVIEW_INDEX.json` in the current project binds every listed
input, all historical claim versions, and all 22 evidence records to exact
read-only input fingerprints.

The old ledger has `C_GROWING_DIVISOR_UPPER` v1 (source-free) and v2
(formal source attached). The mathematical natural statement is unchanged.
`C_MOMENT_SERIES_EXPLICIT`, `C_GROWING_DIVISOR_OBSTRUCTION`,
`C_GROWING_DIVISOR_THRESHOLD`, and `C_GROWING_DIVISOR_NOVELTY` each have v1.
`C_GROWING_DIVISOR_COMPARISON` v1, v2, and v3 have the same statement hash;
the later versions attach one, then both, literature assumptions. These are
dependency amendments, not three different comparison results.

The arithmetic infrastructure is upstream OpenAI work at revision
`4eaee87548250b2682affda7d05d947c05554bae`, reproduced and ported in the
fixed-order unit. The growing-order argument, series bound, and elementary
obstruction are Argus draft contributions; calling them contributions to this
draft does not assert mathematical priority. The nine incorporated upstream
modules and the two bridge helpers are shared dependencies, not additional
results to count again.

## Exact statements and fidelity

Write
`d_X(n) = #{a in Nat : 1 <= a <= X and a divides n}` for positive `n`.
Fix a real `D >= 1`. The upper theorem asserts **there exists one real
`S0(D) > exp(1)`**, followed by universal quantification over real `S >= S0`,
all real

    1 <= r <= log(S) / (200000 log(log(S))),

real `X,Y`, and natural `N`, subject to

    X > 0,
    S/(2 log(S)) <= log(X) <= D*S,
    sqrt(X) <= Y <= X,
    N <= exp(D*S).

Its conclusion is

    sum_{1 <= h <= Y, h natural} d_X(N+h)^r <= Y exp(S^(1/4)).

Thus `S0` is chosen before `r`, and the shift is not reduced to `N <= Y`.
`Main.lean:1652-1718` encodes precisely this order of quantifiers. Its
`Icc 1 floor_nat(Y)` is the indicated set of natural shifts; it retains the
real `Y`, rather than its floor, on the right. Every `N+h` is positive.
The eventual lower bound on `log(X)` gives `X >= 1`, so the divisor `1`
justifies increasing a real exponent to its natural ceiling. `X > 0` is
the intended real-logarithm domain, not an attempt to use Lean's totalized
logarithm on negative inputs.

The series statement is, for **every natural `k`, including zero**,

    A_k := sum_{j >= 0} (j+2)^k (3/4)^j <= 16 (4k)^k.

Natural powers give `0^0 = 1`, so at `k=0` the actual series is `4 <= 16`.
The Lean theorem is `GrowingDivisorMoments.momentSeriesConst_explicit`
(`Main.lean:1484-1537`), about a convergent infinite sum.

## Decisive upper-bound argument

The proof uses `divisor_moment_numeric` (`Main.lean:1255-1274`), a finite
inequality with explicit order-dependent premises. It does **not** substitute
an `S`-dependent order into `uniform_divisor_moment`.

First, `(j+2)^k` is at most the ascending product of `k` factors starting
at `j+2`, namely `k! choose(j+k+1,k)`. Multiplying by the nonnegative
geometric terms and shifting the summation gives
`(3/4) A_k <= k! 4^(k+1)`. Convergence is supplied before comparison of
infinite sums. The elementary bound `k! <= k^k`, also valid at zero,
gives `A_k <= (16/3)(4k)^k <= 16(4k)^k`.
This verifies the coefficient, indexing, and zero-order case in
`proof.md:37-70`; it is not extrapolation from finitely many orders.

Put `L=log(S)` and `l=log(L)`. For `L >= 4000`, `l >= 1`, and
`1 <= k <= L/(100000 l)`, one has `k <= L`, `4k <= L^2`, and

    log(16) + k log(4k) <= L/200 + 2L/100000 < L/100.

Consequently `A_k <= S^(1/100)`. The proof then dominates the five
order-dependent premises by

    1600(1+L)^3 <= S^(1/2),
    51200 <= S^(1/25),
    1+log(2(D+1)L) <= 2l,
    8D(1+L)^2 <= S^(1/8),
    128(1+L) <= S^(6/25).

For the logarithmic premise, `3200k*2l <= (6400/100000)L <= L`.
The exponent identities `1/25+1/100=1/20` and
`6/25+1/100=1/4` handle the series factors. All other premises of the
finite inequality depend only on `D,S` and the fixed convergent smooth
constant. Their eventual bounds are included explicitly in the
`filter_upwards` intersection **before** `intro k`
(`Main.lean:1578-1650`). This is the essential uniformity step.

Finally `k=ceil_nat(r)` satisfies `k <= r+1 <= 2r`, yielding the real
constant `1/200000`. Increasing the exponent is valid because each
divisor count is at least one; the helper `shifted_sum` implements the
exact shift/floor bijection. No desired moment estimate or series
estimate is postulated as an axiom.

## Infinite obstruction: a mathematical proof, not a finite certificate

The precise statement (`proof.md:118-218`) fixes **any** real `C>1/2`,
and for all sufficiently large natural `m` sets

    t=2^m, P(t)=product_{p<=t} p, S=2t,
    v=t/log(2t), X=exp(v), Y=exp(v/2), N=P(t)-1, D=1,
    r=C log(S)/log(log(S)).

The threshold here may depend on `C`. There are infinitely many such
members, and the `h=1` term alone eventually exceeds the proposed
right-hand side. Every required hypothesis can be checked:

1. A prime in `(n,2n]` divides `choose(2n,n)`. The dyadic bands,
   including `(1,2]`, give
   `log P(t) <= (t-1)log(4) < 2t=S`. Hence `N < exp(S)`.
   The logarithmic lower endpoint is an equality, `v <= S` eventually,
   and `Y=sqrt(X) <= X`; also `Y>=1`, so `h=1` is actually present.
2. The largest of the `t+1` binomial coefficients is central, so
   `choose(t,t/2) >= 2^t/(t+1)`. Legendre's factorial valuation formula
   shows each prime contributes at most `t`: every valuation summand is
   zero or one and vanishes above `p^a>t`. Unique factorization therefore
   gives `choose(t,t/2) <= t^pi(t)`, and eventually
   `M:=pi(t) >= a t/log(t)` with `a=log(2)/2>0`.
   No prime number theorem or unproved prime-distribution input is used.
3. Set `k=floor(v/log(t))`. Eventually `1<=k<=M`. Distinct `k`-subsets
   of the primes produce distinct divisors of `P(t)` not exceeding
   `t^k <= exp(v)=X`. The factorwise product comparison for binomial
   coefficients gives `d_X(P(t)) >= choose(M,k) >= (M/k)^k`.
4. With `u=log(t)`, the floor error gives `ku/v -> 1`, while
   `M/k >= a log(2t)` and `log(S)/u -> 1`. Consequently

       liminf log(d_X(P(t))) / (v log(log(S))/log(S)) >= 1.

   This is exactly the product of those two convergent positive factors
   and `log(M/k)/log(log(S))`, whose lower limit is at least one.
   Multiplication by `r` gives a lower limit at least `C` after division
   by `v`. The logarithm of the right-hand side divided by `v` tends
   to `1/2`, since `S^(1/4)/v -> 0`. The strict margin `C-1/2`
   proves eventual strict failure.

These steps supply the infinite quantifier and all admissibility conditions.
They use ordinary finite prime factorization and elementary real limits,
with the needed prime estimates proved in the note. This informal argument
is mathematically supported, but no Lean declaration in this unit formalizes
it. Its conclusion does not refute an eventually valid **fixed-order** lemma.

## What the formal and finite evidence actually establish

The archived certificate
`certificates/C_GROWING_DIVISOR_UPPER-7711f0443152c62e.json` is bound to
upper claim v2 hash
`117ebbf2788379053ecf13a1fbd9a7712ef25706900865ab2db6395384547def`.
Its embedded source and fidelity text match the current old inputs exactly:

    Main.lean SHA256:
    c84ea0c16c280ed3a1f98d40e0a319da22e835bb3e665b0aa435b43f1aa1db5f
    statement_fidelity.md SHA256:
    8f7b37cd98b0d1d1d26225c9c6e966e22d2355dcad948952dab34f791da83a7a

The recorded real execution used Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Lake
`5.0.0-src+68218e8`, and the host workspace
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`.
The archived compile and proof-hole audit both exited zero, with no holes.
Both printed declarations depend only on
`propext`, `Classical.choice`, and `Quot.sound`.
This is reuse of exact archived compilation, **not a fresh compiler run**.
No new `.lean` file was authored in this review.

The old independent support is explicitly recorded under
`judgement-C_GROWING_DIVISOR_UPPER-137312975485`,
`judgement-C_MOMENT_SERIES_EXPLICIT-3799cd338c4c`,
`judgement-C_GROWING_DIVISOR_OBSTRUCTION-44e000f5c26e`, and
`judgement-C_GROWING_DIVISOR_THRESHOLD-a95d06bd5a61`.
The first two cite the source-bearing certificate; the prose judgments
only name their artifact paths. The index's current artifact fingerprints
must not be misrepresented as hashes originally recorded by those prose
reviewers. The fresh argument reading above supplies the present assessment.

Both Python scripts were inspected before use. `prepare.py` would overwrite
old `Main.lean` if run as a script; the full `verify.py` would compile,
modify the old ledger/certificates, and append to old activity. Neither
write-producing entry point was run. Evaluating `source_text()` without
the script entry point reconstructed the growing source exactly.
Only the inspected `verify.py --finite-only` branch was executed, using
`python -B` to prevent bytecode writes. Its output, saved as
`finite_replay.json`, exactly equals the archived finite checks:

| Existing check | Replayed scope/result |
|---|---|
| Series recurrence | Exact rational values at orders `0..64`, all below the bound; not a universal proof |
| `S=32,X=128,Y=16,N=30029` | Full interval eighth-moment `378054191044 > 512 > Y exp(S^(1/4))`, and the specified real order exceeds 8 |
| `S=512,X=2^60,Y=2^30,N=P(256)-1` | `choose(54,7)=177100560` distinct small divisors; their eighth powers exceed `2^38`, an upper bound on the right-hand side |
| Old Jacobian receipt | Only `tau(2310)=32`, with its exact historical payload/contract |

The finite examples round `X,Y` to powers of two. They are admissible
witnesses at `C=4`, not literal members of the exponential family above,
and say nothing about every `C>1/2` by themselves.

One fresh, bounded Jacobian replay was made after inspecting its current
typed contract: operation `integer.compute.divisors`, exact payload
`{"value":"30030"}`. Server `0.14.0`, protocol `2025-11-25`, returned
`COMPLETE`, all 64 positive divisors, 28 at most 128. Direct enumeration
agrees. The raw contract, payload, and typed result remain separate JSON
files; `review_replay.json` records exit zero, no adapter error, and no
timeout. This checks only the first term of the old small witness.

## Paired conclusion, failed substitution, and metadata

The supported positive constant is **`1/200000`**. The obstruction holds
for **each fixed `C>1/2`**. Together these establish the order
`log(S)/log(log(S))` up to absolute constants, not a sharp constant,
not the endpoint `C=1/2`, and not a result resolving the interval between
the constants.

The retired `R_GROW_FIXED_SUBSTITUTION` is genuinely invalid reasoning:
`forall fixed r exists S0(D,r)` does not imply
`exists S0(D) forall r in the growing range`. For a logical countermodel,
the predicate `r <= log(log(S))` holds eventually for each fixed `r`,
but not uniformly up to a positive constant times `log(S)/log(log(S))`.
This refutes that proposed inference, not the manuscript's lemma.

Other retirements are bookkeeping, not failed mathematics.
`R_GROW_PAIRED` still cites upper v1, whereas its replacement cites v2.
`R_GROW_FINITE_CONSTANTS`' stored goal already has the v2 hash despite
retirement wording calling it source-free. The index preserves both the
actual references and the reasons without rewriting old history.
Likewise the old proof graph's open labels and the exact certificate's
pre-review status text do not cancel the later ledger support or prove
family completion.

## Literature comparison and the concrete unresolved obligation

The bounded comparison is supported in its stated, narrow sense:

| Primary source and locator | Actual scope versus the draft |
|---|---|
| Nair--Tenenbaum, DOI `10.1007/BF02392880`, Theorem 1 / (18), author-copy p. 6; class definition p. 1 | Constants depend on growth-class and fixed interval/coefficient parameters; `x^(4g^2 epsilon) <= y <= x` |
| Henriot, `arxiv:1102.1643v1`, Theorems 1 and 3 / (1.1)-(1.3), pp. 1-3 | Discriminant uniformity retains dependence on `g,alpha,delta,A,B`; Theorem 3 additionally requires multiplicativity |
| Luca--Toth, `arxiv:1703.08785v2`, Theorem 1, p. 2 | Multiplicative `f`, fixed integer `f(p)=k`, prime-power growth uniform in the prime; a full initial-interval asymptotic, with `k=2^r` for `tau^r` |
| de la Breteche--Tenenbaum, `arxiv:2512.05652v1`, p. 1 after (1.2), Theorem 1.1 and Remark (ii), p. 2; Corollaries 1.2 and 1.5, p. 2 | Fixed Delta-moment parameters; locally uniform on admissible compact sets; short intervals still require `x^epsilon <= y`; Corollary 1.5's `N` indexes divisor windows, not the target additive shift |

For the first two, the exact hypotheses are preserved in the independently
attributed reviewer excerpts and their archived JSON passages. Their
supporting receipts are
`citation-HENRIOT_FIXED_PARAMETERS-5a2df697885e` and
`citation-NAIR_TENENBAUM_FIXED_PARAMETERS-c62069fbfe48`; the earlier
registry-resolution receipts are only inconclusive. The two supplementary
versioned PDFs were directly obtained and their indicated statements read
in this review; copies and fingerprints are recorded in `review_replay.json`.
No theorem from these papers is an analytic assumption of the upper proof
or elementary obstruction.

The obstruction to a **direct displayed-theorem application** is specific:
`d_X(ab)^r <= tau(a)^r d_X(b)^r` for coprime positive `a,b` demands
a growth parameter at least `2^r`. At the most distant allowed shifts,
`log(Y)/log(N)` can tend to zero like `1/(4D log(S))`.
Thus an interval exponent, or a coefficient exponent after translating
the shift into a polynomial, must shrink while the class parameter grows.
The quoted theorems do not provide the needed quantitative control of their
constants in that simultaneous limit. Also truncated divisor counts are
not multiplicative; for example `d_3(2)d_3(3)=4` but `d_3(6)=3`.
This is not a proof that refinements of those methods cannot imply the
draft theorem.

The old note also mentions a later, unversioned author PDF stamped
9 October 2026. It was not among the preserved literature artifacts and
was not identified with arXiv v1; no theorem or priority conclusion from
that different version is imported here.

The unresolved novelty obligation is to compare the **paired, precisely
quantified theorem** against relevant prior quantitative results, including
possible consequences obtained by tracking parameter-dependent constants.
The limited four-source comparison neither proves absence of such a result
nor establishes priority or publishable significance. This is a concrete
missing literature/mathematical implication, not a failed computation or
an access-only objection. Optimal constants and Lean formalization of the
obstruction were not promised by the supported claim.

Relative to the strongest old reviewed result, this assessment adds no
new theorem and no better constant. It establishes exact coverage,
source-bound evidence reuse, and the distinction between its formal upper
half, informal lower half, and unresolved novelty. Native independent
acceptance remains pending.
