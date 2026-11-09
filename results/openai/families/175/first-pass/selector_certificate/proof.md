# A common-witness selector theorem with factorial profile summation

## Scope and primary-source baseline

The target is `thm:multiscale-selector` in the staged September 23, 2026
expectation-threshold manuscript, `build/source/sections/selector.tex`.
Its family need not be increasing. Its masses are arbitrary nonnegative real
probability masses supported on the respective members. The existential
quantifier on the member precedes the universal quantifier on the scales.

The relevant baseline, read directly from the primary sources, is:

* Pham, arXiv:2412.03540v1, Theorem 1.3, gives, for a **single** positive
  integer scale `s`, probability at least `1/3` of some member with captured
  mass at least `1-2^(-s)` in a sample of density `16 s p`.
  Section 2.1 explicitly explains why directly iterating a single-scale
  selector estimate loses control of the new family. Section 2.2, especially
  Definition 2.4 and Lemma 2.6, uses minimum towers and reconstruction.
  Primary source: <https://arxiv.org/html/2412.03540v1>.
* Bednorz--Martynek--Meller, arXiv:2212.14636v3, Lemma 3.6 and its proof,
  use the largest truncated-weight cutoff and a right-hand perturbation.
  Definition 3.8 minimizes witnesses. These are one-level antecedents, not a
  theorem giving the simultaneous common member sought here.
  Primary source: <https://arxiv.org/html/2212.14636v3>.
* Park--Pham, arXiv:2204.10309v2, is the original selector-process result;
  its abstract confirms that scope. Its theorem statements are not needed
  as inputs to the proof below.
  Primary source: <https://arxiv.org/abs/2204.10309v2>.

These are contextual antecedents, not assumptions in the proof below.
In particular, no result from either companion OpenAI manuscript is assumed.
The scope lookup establishes neither exhaustive literature coverage nor
independently verified novelty. The genuinely additional mathematical step
below is factorial summation over the full profile, rather than the
manuscript's rowwise entropy bound.

## Universal theorem

Let `X` be finite and let `F` be a nonempty family of nonempty subsets of `X`.
For every `H in F`, let `lambda_H : X -> [0,1]` have total mass one and
vanish outside `H`. Let `0 < p <= 1`, and suppose every integral cover of
`F` has cost greater than `1/2` at `p`.

Fix an integer `s >= 0`, numbers `0 < d_i < 1` for `1 <= i <= s`, and
positive palette probabilities `pi_1,...,pi_(s+1)` summing to one.
Independently color the elements of `X` using this palette, and put
`A_i(a) = {x : a(x) <= i}`. Define

    q_i = sum_(h>i) pi_h,
    R = sum_(i=1)^s p q_i / (d_i pi_i).

Write `B` for the event

    for every H in F, some i in {1,...,s} has
    lambda_H(A_i(a)) < 1-d_i.

For `s=0`, this event is empty. In all cases, with `N=|X|`,

    (1/2) Pr(B) <= sum_(t=1)^N (t^t/t!) R^t.                 (1)

In particular, if `3R < 1`, then

    Pr(B) <= 2R/(1-3R).                                    (2)

This is a universal theorem over arbitrary finite ground sets, arbitrary
families as above, and arbitrary real supported masses; the finite
experiments accompanying it are not its proof.

## Proof

For a fixed coloring `a`, a move is a coloring `z <= a`. Define

    U(a,z) = {x : z(x) < a(x)},
    m_i(a,z) = |{x : z(x) <= i < a(x)}|,
    L(a,z) = sum_x (a(x)-z(x)).

A move is feasible if there exist a **single** `H in F` and cutoffs
`epsilon_i in [0,1]` such that, for every `i`,

    {x : lambda_H(x) > epsilon_i} subset A_i(z),
    sum_x min(lambda_H(x),epsilon_i)
          (1_(A_i(z))(x) - (1-d_i)) >= m_i(a,z) epsilon_i.   (3)

For each `H0 in F`, minimize `L(a,z)` over feasible moves with
`U(a,z) subset H0`, breaking ties in a fixed order of colorings. A feasible
candidate exists: move all of `H0` to color 1 and use witness `H0` and
zero cutoffs. The positive support is then contained in every `A_i(z)`.
The set of colorings is finite, so the minimum exists. Importantly, the
witness in this minimization is not required to equal `H0`.

Let `Z(a)` be the distinct selected colorings. Their changed sets cover
`F`. Even when two distinct selected colorings have the same changed set,
removing repetitions can only lower the cover cost. Consequently

    sum_(z in Z(a)) p^|U(a,z)| > 1/2.                       (4)

If `z=a` were feasible, untruncating (3) would only add terms with
nonnegative coefficient `d_i`, since all excess weights belong to
`A_i(a)`. Normalization would give the simultaneous capture conclusion
for that same `H`. Thus every move selected from a bad coloring has
`|U(a,z)| > 0`. Multiplying (4) by the product coloring probability
`P(a)` and summing over bad colorings gives the starting cover-cost bound.

### Maximal truncation, including ties and endpoints

For a fixed probability mass `lambda`, set `A`, charge `m >= 0` and
`0<d<1`, the admissible cutoffs are precisely the `u in [0,1]` with

    lambda(x) <= u whenever x is outside A,
    f(u) := sum_x min(lambda(x),u)(1_A(x)-(1-d)) - m u >= 0.

This set is closed in a compact interval. If nonempty, it has a largest
element `epsilon`. Put `T={x:lambda(x)>epsilon}`. If `epsilon=1`,
`T` is empty. Otherwise choose `v>epsilon`, `v<=1`, with no weight
strictly between `epsilon` and `v`; such a `v` exists because `X`
is finite. The inclusion condition persists as the cutoff increases.
All weights equal to `epsilon` are already saturated. Therefore

    f(v)-f(epsilon) = (v-epsilon)(d |T|-m).

If `d |T|>m`, `v` is admissible, contradicting maximality. Hence

    d |T| <= m.                                           (5)

This argument includes `epsilon=0`, zero weights, repeated weights, and
zero charge. It never divides by a weight or assumes distinct weights.

### One witness for the whole fiber

Group the pairs `(a,z)` by `z` and the entire crossing profile

    n_(ih) = |{x : z(x)=i, a(x)=h}|,   1<=i<h<=s+1.

Set `t_i=sum_(h>i)n_(ih)` and `t=sum_i t_i`. The identity

    m_i(a,z) = sum_(j<=i<h) n_(jh)                          (6)

shows that every occurrence of `a` in (3) is determined by this profile.
Choose the first feasible witness `H` for the fixed fiber. Independently
at every scale, choose the largest admissible cutoff. All these choices
depend only on `z` and the profile. They witness (3) for **every** `a`
in the fiber. There is no exchange of `forall a, exists H` with
`exists H, forall a`: the admissible witness predicate itself is identical
for all `a` in the fiber.

For each `i`, let `T_i={x:lambda_H(x)>epsilon_i}`. By (5) and
`m_i<=t`,

    |T_i| <= m_i/d_i <= t/d_i.                             (7)

If a selected move changes `x` from `h>i` to `i` but `x` is not in
`T_i`, delay its final color by **one** level, from `i` to `i+1`.
It stays at most `h`, its changed set remains a subset of `H0`, and its
length decreases by exactly one. Only the cumulative set at scale `i`
changes. Its truncated sum falls by `min(lambda_H(x),epsilon_i)`,
whereas its charge falls by exactly `epsilon_i`. Its new slack is
therefore

    old slack + epsilon_i - min(lambda_H(x),epsilon_i)
    >= old slack.

The inclusion condition survives because `x` is not in `T_i`; every
other scale is unchanged. The **same** witness and cutoffs prove
feasibility of the shorter move, a contradiction. Thus, for every
original coloring in the fiber,

    {x : z(x)=i<a(x)} subset T_i.                          (8)

This is the reconstruction core. In particular it works when `h=i+1`,
when delaying removes `x` from the changed set entirely.

### Counting, exact likelihood, and factorial summation

Given `z` and the full profile, encode `a` by choosing, in each row `i`,
the `t_i` changed vertices from `T_i` and labeling them with their
original colors, with multiplicities `n_(ih)`. This encoding is injective.
The `T_i` may overlap and contain vertices of the wrong final color:
allowing such choices only enlarges the encoding space. Consequently the
number of original colorings in that fiber is at most

    product_i binom(|T_i|,t_i) t_i! / product_(h>i) n_(ih)!.

For every actual pair, cancellation of independent palette factors gives
the exact identity

    p^t P(a) = P(z) product_(i<h) (p pi_h / pi_i)^n_(ih).   (9)

Using `binom(M,k) <= M^k/k!` and (7), the fiber contribution is at most

    P(z) t^t product_(i<h)
              (p pi_h/(d_i pi_i))^n_(ih) / n_(ih)!.       (10)

The convention for an empty row is `0!=1` and an empty product is one;
`t>0` throughout (10). A row with `t_i>|T_i|` contains no actual pair.
For fixed total `t`, sum (10) over all nonnegative profiles, including
nonoccurring ones. By the finite multinomial theorem the result is
exactly

    P(z) (t^t/t!) (sum_(i<h) p pi_h/(d_i pi_i))^t
    = P(z) (t^t/t!) R^t.

No cutoff or witness has been fixed across different profiles. Their
dependence has disappeared from the numerical bound before summation.
Now sum over `z`, using `sum_z P(z)=1`, and over `1<=t<=N`.
This proves (1).

For completeness, put `a_t=t^t/t!` for `t>=1`. Then `a_1=1` and

    a_(t+1)/a_t = (1+1/t)^t < 3.

An elementary proof of the last bound expands the binomial and uses
`binom(t,j)/t^j <= 1/j!` and `j! >= 2^(j-1)` for `j>=1`;
the resulting finite geometric sum is strictly below 3.
Induction gives `a_t <= 3^(t-1)`. Summing the resulting geometric
majorant in (1) proves (2).

## Consequences at the manuscript's quantifiers

Take `d_i=2^(-i)` and `pi_i=D^i p` for `i<=s`, with
`pi_(s+1)=1-p sum_(i=1)^s D^i >= 1/2`. All palette probabilities are
positive. For `s>=1` and `D>2`,

    R <= sum_(i=1)^s (2/D)^i < 2/(D-2).

For `D>8`, (2) gives

    Pr(B) < 4/(D-8).

Thus `D=48` already gives the manuscript's success probability `9/10`,
with one common member at all scales. At the manuscript's `D=256`
the stronger success probability `61/62` follows. If `s=0`, a member
exists by nonemptiness, every color is 1, and the conclusion is certain.
In every case, on simultaneous capture,

    sum_x a(x) lambda_H(x)
      = 1 + sum_(i=1)^s (1-lambda_H(A_i(a))) <= 2.

The same selector-to-rounding calculation in the staged `rounding.tex`
therefore works with `D=48`, `B=96`, and `C=25*96^4`.
Indeed, for `p=r/C`, the largest permitted `s` has
`B^(-(s+1)) < 4p`, so `E[B^(4-a(x))] <= 5B^4 p=r/5`.
On selector success the fractional-cover variable is at least `1/4`,
giving expectation at least `9/40`; independence and the fractional
budget give expectation at most `1/10`. The argument includes
`g(empty)<=1/2`, normalizes only the positive nonempty mass, and treats
`r=0` separately with the cover by the members themselves. Hence

    q_f(F) <= 25*96^4 q(F).

This last consequence is a proved numerical strengthening of the
staged theorem, not a claim that the full threshold conjecture was
previously unknown to this audit.

## Evidence boundary

The universal proof is the argument above. `Main.lean` and its separate
statement-fidelity document specify exactly which reconstruction facts
are kernel checked; compiler success is not a formalization of this
entire note. `verify.py` supplies independent exact-arithmetic replay
of boundary cases and of the algebra used in factorial summation.
No finite search is advertised as a universal proof, and no
independent Reviewer approval is asserted by the Engineer.

Replay from the campaign root with:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/selector_certificate/verify.py
```

The script uses only the Python standard library for exact rational
computations, invokes the approved Lean 4.31.0 evidence verifier with the
claim and statement-fidelity mapping, and runs both campaign-local official
checks. A compiler failure is a failing replay, not an accepted fallback.
The preserved Jacobian request was rejected at its simplex-admission
bound; that typed error is a non-conclusion and supplies no support for
the theorem.
