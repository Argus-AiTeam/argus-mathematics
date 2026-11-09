# Weighted-bounded support separation

## Exact scope and source map

The target is the assertion between `eq:p3-correlations` and
`eq:p3-support-separation` in
`research/openai_manuscript/Backward-intertwiners-and-a-transitive-commutant-September-27-2026/build/sections/domar-proof.tex`.
Its hypotheses are those of `lem:domar` in `sections/criterion.tex`.
The coefficients are complex, indexed by all integers, and only satisfy
`sup |b_j|/w_j < infinity` and `sup |c_j| w_j < infinity`.
The identities concern **every** positive integer shift, not a finite window.
The negative-index root is `w_{-n}^{-1/n}`, not `w_{-n}^{1/n}`.

The assertion is stronger than its Hilbert-space application. The latter uses
square summability only to obtain these two boundedness conditions and a
continuous annihilator. The zero-shift identity is used only in the final
coordinate-tail deduction; it is not a hypothesis of support separation.

The separate irrational-rotation theorem (`thm:main` in that manuscript's
`build/00-introduction.tex`) is not a consequence of this assertion alone.
Neither it nor the backward-intertwiner construction is certified by checking
this analytic bottleneck.

## Result and prior-result comparison

**The literal assertion is true.** Below is a complete independent proof,
including the resulting invariant-subspace classification. No false assertion
in these two source sections has been established, so there is no justified
`F_<LABEL>` refutation to record.

This is **known mathematics, not a new counterexample or a newly discovered
support theorem**. A separate primary-source research task read Domar's complete
Section 3 and the relevant part of Grabiner's paper. It reported:

* Y. Domar, *Translation invariant subspaces of weighted l^p and L^p spaces*,
  Math. Scand. 49 (1981), 133--144, DOI
  [10.7146/math.scand.a-11926](https://doi.org/10.7146/math.scand.a-11926).
  Theorem 2, pp. 134--135, conditions (4)--(6), permits **either** signed
  one-sided quadratic limsup to exceed `log 3`; it does not require matching
  limits. Section 3, Theorem 5, p. 140, equation (13), assumes bounded `cw`
  and `b/w` and all positive-shift identities. Its conclusion is:
  > Then there is a p in Z such that b_n = 0, n > p, and c_n = 0, n < p.
  The quoted formula is transcribed in plain text. The ambient sequences are
  complex; the following remark gives absolute convergence. The official
  [primary PDF](https://journals.msp.org/mscand/article/view/1747/1746)
  supplies the definitions and proof.
* S. Grabiner, *Unicellular shifts on Banach spaces*, J. Operator Theory
  8(1) (1982), 157--165:
  [official PDF](https://jot.theta.ro/jot/archive/1982-008-001/1982-008-001-007.pdf).
  Section 2, especially conditions (i)--(ii), p. 161, and the note added in
  proof, p. 165, state a still broader operator criterion for a bounded
  splitting basis. In the orthonormal-basis specialization, summable weights
  with the two half-line monotonicities suffice, without a quadratic
  threshold. This operator result is not used below. The further Domar result
  cited by that note was not independently obtained in this scope.
* The Atzmon--Sodin 1999 primary full text could not be obtained by that
  researcher: its DOI resolved, but publisher body/PDF access returned 403
  and the text endpoint returned 400. No proposition from it is used.

Thus the tempting one-sided-limsup "extension" is already Domar's theorem;
that novelty route is retired in the ledger. Absence of a search hit would
not establish novelty of the quantitative formulation below either.

The improvement over this campaign's initial state is a complete source-faithful
proof plus an independently authored, kernel-checked analytic core, not a
mathematically stronger classification than the literature. The symmetric
kernel estimate in Section 3 below also yields an explicit residual inequality
along the matched contacts. Its novelty is **not claimed**.

These source facts are recorded only on `C_QSS_SCOPE`; they are not assumptions
of `C_QSS_SUPPORT` or of the Lean core. Official citation attribution remains
pending: `citation_check attribute` necessarily writes `research/literature/`,
outside this mission's authoritative writable paths. No such write, nor an
invented independent attribution, has been made.

## 1. Statement, normalization, and absolute convergence

Let `w_j > 0` decrease on the integers, with `w_0 = 1`, and let

    P_n = log w_{-n},        Q_n = -log w_n,       n >= 0.

Assume `P,Q` are convex, vanish at zero, satisfy the signed-root sum in
`eq:root-sum`, and `P_n/n^2, Q_n/n^2 -> a > log 3`.
Let nonzero complex sequences `b,c` have bounded `b/w` and `cw`.
Independent multiplication by positive constants reduces to

    |b_j| <= w_j,             |c_j| <= 1/w_j.                 (1)

This does not change supports or any vanishing identity. Normalizing the
weight by `w_0` also preserves these hypotheses after rescaling the bounds.
Write

    beta_j = w_{j+1}/w_j.

Convexity and the zero anchors imply, for `n >= 1`,

    P_n-P_{n-1} >= P_n/n,       Q_n-Q_{n-1} >= Q_n/n.

Consequently

    beta_{-n} <= w_{-n}^{-1/n},
    beta_{n-1} <= w_n^{1/n},
    0 < beta_j <= 1,           sum_j beta_j < infinity.       (2)

The exponent on the negative side has not been replaced by its absolute
value. For every integer `r >= 1`,

    sum_j |b_j c_{j-r}|
      <= sum_j w_j/w_{j-r}
      =  sum_j product_{i=j-r}^{j-1} beta_i
      <= sum_j beta_{j-r} < infinity.                        (3)

All subsequent reindexings and partitions of the correlation are therefore
legitimate absolutely convergent complex series. We prove that

    sum_j b_j c_{j-r} = 0  for EVERY integer r >= 1           (4)

forces finite endpoints `t=max supp b`, `h=min supp c`, with `t <= h`.
No zero-shift identity is assumed in this statement.

Source map: `eq:p3-ratio-sum`, `eq:p3-correlations`, and
`eq:p3-support-separation`.

## 2. Convex-envelope lemma, including the artificial anchor

Let `S` be a cofinal subset of the positive integers. At `n in S` let
`f_n >= 0` be finite; outside `S` impose no obstacle. Suppose a finite
convex sequence `G`, with `G_0=0`, is below these obstacles.
There is a finite greatest convex minorant `F`, anchored at zero, and
`F >= G`.

Here is an independent boundedness argument for its construction. If `H`
is any admissible minorant, `H^+_n=max(H_n,0)` is convex, anchored at zero,
and nonnegative. Its first difference at zero is nonnegative, so convexity
makes `H^+` increasing. For any obstacle index `k >= n`,

    H_n <= H^+_n <= H^+_k <= f_k.

Thus the set of minorant values at each `n` is nonempty and bounded above.
Its supremum is finite. For every admissible `H`,

    2 H_{n+1} <= H_n+H_{n+2} <= F_n+F_{n+2},

so taking the supremum proves convexity of `F`. Anchoring and all obstacle
bounds pass to the supremum. This proves existence and greatestness.

If `p >= 1` has strictly positive curvature

    F_{p-1}+F_{p+1}-2F_p > 0,

then `p in S` and `F_p=f_p`. Otherwise increase only `F_p` by a sufficiently
small positive epsilon. At `p` use less than half the displayed slack; if
there is an obstacle, also use less than its slack. The neighboring
convexity inequalities are strengthened, all other inequalities are
unchanged, and the anchor is unchanged. This contradicts greatestness.
This proves actual contact, including exclusion of a zero coefficient.

If `G_n >= delta*n^2` eventually, `delta>0`, then the slopes of `F` tend
to infinity: their monotonicity and `F_0=0` give

    F_n-F_{n-1} >= F_n/n >= delta*n

for large `n`. In particular there are arbitrarily large strict-curvature
contacts.

The anchor is not an assumption that `|b_0|=|c_0|=1`. Only their upper
bounds by 1 will be used. Zero coefficients are represented by absence
from `S`, not by taking a logarithm of zero as a finite number.

Source map: the paragraph preceding `eq:p3-contact` and `eq:p3-contact`.
Lean: `greatest_minorant_exists`, `envelope_contact`,
`slopes_monotone`, and `slopes_cofinal`.

## 3. An infinite normalized-tail theorem

**Kernel theorem.** Let `v_n > 0`, `n >= 0`, and suppose the ratios
`rho_n=v_{n+1}/v_n` are nonincreasing and summable. Normalization `v_0=1`
is not necessary for this theorem. Define, for `q,k >= 0`,

    K(q,k) = v_{q+k}/(v_q v_k).

For `q,k >= 1`,

    0 < K(q,k) <= min(rho_q,rho_k)/v_1.                     (5)

In particular, for every `q >= 1` the entire series is summable, and

    T_v(q) = sum_{k>=1} K(q,k)  -> 0  as q -> infinity.     (6)

Proof: the antitone-ratio inequality gives

    K(q+1,k)/K(q,k) = rho_{q+k}/rho_q <= 1.

Hence `K` decreases in its first argument. It is symmetric, so it also
decreases in its second argument. Comparing each argument with 1 gives

    K(q,k) <= K(1,k) = rho_k/v_1,
    K(q,k) <= K(q,1) = rho_q/v_1.

This proves (5). Summability implies `rho_q -> 0`, so the second bound
gives pointwise convergence to zero, while the first is a single summable
majorant independent of `q>=1`. Dominated convergence for series proves
(6). Explicitly, one can first choose `N` so
`sum_{k>N} rho_k/v_1 < epsilon/2`, and then `q` so
`N*rho_q/v_1 < epsilon/2`; this proves the infinite assertion without
any finite-exhaustion inference.

For two independent sequences `v,z` with these properties,
`T_v(q)+T_z(q) -> 0`, also along every sequence of indices tending to
infinity. Nothing in this theorem assumes a convolution identity or a
support-separation conclusion.

Lean proves summability, the pointwise domination, and the actual
topological infinite-sum limit:
`kernel_step_le`, `kernel_le_ratio_right`, `kernel_le_ratio_left`,
`normalized_tail_summable`, `normalized_tail_tendsto_zero`, and
`both_normalized_tails`. These are not bounded computations.

## 4. When one support endpoint already exists

Suppose `h=min supp c` exists. If `supp b` were unbounded above, apply
Section 2 to the obstacle `-log|b_n|` at its nonzero positive
coefficients. The sequence `Q` is an admissible minorant. Let the greatest
minorant be `B`, and set `v_n=exp(-B_n)` for `n>=0`. Then

    |b_n| <= v_n <= w_n,

and at arbitrarily large contact indices `p`, `|b_p|=v_p>0`.
For `p>h`, (4) at `r=p-h` and the minimality of `h` imply

    |c_h| <= sum_{k>=1} (v_{p+k}/v_p) |c_{h+k}|.            (7)

Choose a fixed integer `p0 >= max(1,h+1)`. For `p>=p0`, convexity gives

    (v_{p+k}/v_p)|c_{h+k}|
      <= v_{p0+k}/(v_{p0} w_{h+k})
      <= beta_{h+k}/v_{p0}.                               (8)

For the last inequality, `p0-h>=1` and the remaining weight ratio is a
product of that many step ratios, each at most 1. The right side of
(8) is summable over `k>=1`. For fixed `k`, the left side tends to zero
because the slopes of `B` tend to infinity. Dominated convergence makes
the right side of (7) tend to zero along the contacts, contradicting
`c_h != 0`. Therefore `t=max supp b` exists.

If `t>h`, the correlation at `r=t-h` has exactly one possibly nonzero
term, `b_t c_h`, which is nonzero. Thus `t<=h`.

If instead `t=max supp b` is initially known to exist, use

    w~_j = 1/w_{-j},       b~_j = c_{-j},       c~_j = b_{-j}.

All weight assumptions are preserved, with `P,Q` exchanged. The two
boundedness conditions exchange correctly, and the positive correlations
are exactly (4) after the absolutely convergent reindexing `k=-j+r`.
Now `min supp c~=-t` exists, so the case already proved gives the other
endpoint and the same ordering. This reflection is complex-linear;
there is no unwarranted positivity or conjugation assumption.

Source map: `eq:p3-bounded-side` and the following reflection.

## 5. Excluding two unbounded supports

Assume now that `supp c` is unbounded below and `supp b` unbounded above.
Construct the envelopes

    A_m <= -log|c_{-m}|,      B_p <= -log|b_p|,       m,p>=1,

at their respective nonzero coefficients, with artificial zero anchors.
They satisfy `A>=P`, `B>=Q`, and have nonnegative, nondecreasing slopes.
Define

    u_{-m}=exp(A_m),          u_p=exp(-B_p),          u_0=1.

Both definitions agree at zero. From the obstacle inequalities on their
own halves and (1) on the opposite halves,

    |b_j| <= u_j,             |c_j| <= 1/u_j,       all j.  (9)

Indeed, `u_j>=w_j` on the negative half-line and `u_j<=w_j` on the
positive half-line. The actual coefficients at zero still only have
modulus at most 1.

Convexity, anchoring, and the signed-root sum also give

    sum_j u_{j+1}/u_j < infinity.                          (10)

For the negative step at `j=-n`, its ratio is
`exp(-(A_n-A_{n-1})) <= exp(-P_n/n) = w_{-n}^{-1/n}`.
For the positive step at `j=n-1`, the corresponding bound is
`exp(-Q_n/n)=w_n^{1/n}`. This checks both halves of (10), including
their central indices.

Choose `log 3 < lambda < a`. There are arbitrarily large `m` with

    A_{m+1}-2A_m+A_{m-1} > 2 lambda.                      (11)

Otherwise double summation would give
`A_m <= lambda*m^2+C*m+D` eventually, contradicting
`A_m>=P_m` and `P_m/m^2 -> a>lambda`. Lean's
`curvature_or_quadratic_bound` verifies the exact double-summation
alternative, including arbitrary finite prefixes.

Write `alpha_m=A_m-A_{m-1}`, `gamma_p=B_p-B_{p-1}`.
Both are nondecreasing and tend to infinity. At sufficiently large
indices in (11), the last `p>=1` below the threshold is well-defined:

    gamma_p <= alpha_m+lambda < gamma_{p+1}.              (12)

As `m` tends to infinity along (11), `p` also tends to infinity: for
each fixed `K`, eventually `alpha_m+lambda >= gamma_K`, forcing `p>=K`.
The strict slope jump at `m` gives contact there. Equation (12) gives
`gamma_{p+1}>gamma_p`, giving contact at `p`. Thus

    M=|b_p c_{-m}|=exp(-B_p-A_m)>0.                       (13)

There are two distinct directional slope inequalities:

    gamma_{p+1}-alpha_m > lambda,
    alpha_{m+1}-gamma_p > lambda.                         (14)

The second uses (11) and the **lower**, not the upper, inequality in
(12). This fixes the orientation of the matching argument.

For `-p<=n<=m` define

    F(n)=-B_{p+n}-A_{m-n}.

Its increments are nonincreasing. The first step in either direction
away from zero is less than `-lambda`, by (14). Therefore

    exp(F(n)) <= M exp(-lambda*|n|),   -p<=n<=m.           (15)

Lean's `matched_contacts` verifies both actual contacts, and
`matched_middle_bounds` proves both directions of (15), not just an
unoriented slope comparison.

Set `q=m+p`. Partition the absolutely convergent correlation at shift
`q`, writing `j=p+n`. Its center is the nonzero term in (13). The
remaining middle has modulus at most `M*C_lambda`, where

    C_lambda = 2 sum_{n>=1} exp(-lambda*n)
             = 2/(exp(lambda)-1) < 1.                    (16)

Here the infinite geometric series only majorizes a finite middle.

**Positive tail, with its normalization.** For `n=m+k`, `k>=1`,
the bound in (9) is `u_{q+k}/u_k`. At the endpoint `n=m`,
(15) gives `u_q<=M`. Hence

    (positive tail bound)/M
       <= sum_{k>=1} u_{q+k}/(u_k u_q) = T_{v+}(q),       (17)

where `v+_k=u_k`. On the positive half-line, `log u=-B` is concave;
the ratios of `v+` are antitone and summable by (10).
Section 3 proves that the entire right side of (17) tends to zero.

**Negative tail, with its separate normalization.** Put
`v-_k=1/u_{-k}=exp(-A_k)`. For `n=-p-k`, `k>=1`, the bound in (9)
is `u_{-k}/u_{-(q+k)}=v-_{q+k}/v-_k`. At `n=-p`, (15) gives
`v-_q<=M`. Thus

    (negative tail bound)/M
       <= sum_{k>=1} v-_{q+k}/(v-_k v-_q) = T_{v-}(q).    (18)

Now `log v-=-A` is concave, and its own step ratios are summable
by the negative half of (10). Section 3 applies independently.
Using `u_q` in (18), or omitting the factor `v-_q`, would not prove
the required normalized estimate; neither error is made here.

Let `R(q)=sum_j b_j c_{j-q}`. The reverse triangle inequality applied
to the center, remaining middle, and the two tails gives the exact
quantitative inequality

    |R(q)|/M >= 1-C_lambda-T_{v+}(q)-T_{v-}(q).           (19)

Since `q=m+p -> infinity`, the right side tends to
`1-C_lambda>0` along these matched contacts. In particular `R(q)` is
nonzero at every sufficiently large selected contact shift,
contradicting (4). This excludes the only case not handled in Section 4.
Support separation is proved in its full stated generality.

Equation (19) also proves `C_QSS_QUANTITATIVE`: its lower limit along
the selected contacts is at least `1-C_lambda`.
Lean's `central_margin`, `eventual_relative_margin`, and
`eventual_nonzero` prove the complex analytic obstruction, including
arbitrary cofinal subsequences of contact shifts.

Source map: `eq:p3-envelope-bounds`, `eq:p3-envelope-ratios`,
`eq:p3-large-curvature`, `eq:p3-slope-choice`,
`eq:p3-contact-product`, `eq:p3-geometric-middle`, and the two
normalized-tail paragraphs after it.

## 6. The complete coordinate-tail deduction

Let `H=ell^2(w)` with norm squared `sum_j |w_j c_j|^2`.
By (2), right translation is a bounded contraction. Every continuous
complex-linear functional on `H` has the **bilinear** coordinate form

    ell_b(c)=sum_j b_j c_j,       (b_j/w_j)_j in ell^2.

For completeness, put `b_j=ell(e_j)`. On any finite set use the test
vector `c_j=conj(b_j)/w_j^2`. If
`A=sum |b_j/w_j|^2` on that set, boundedness gives
`A <= ||ell|| sqrt(A)`, so `A<=||ell||^2`. Taking increasing finite
sets proves square summability. The displayed representation then
follows from density of finite-support vectors and Cauchy--Schwarz.
Conversely this formula defines a bounded functional. This argument
does not erroneously conjugate one of the source's correlations.

A nonzero proper closed subspace `L` has a nonzero continuous annihilator.
No specialized operator theorem is needed for this fact. The Hilbert
projection argument suffices: for `x notin L`, a distance-minimizing
sequence in `L` is Cauchy by the parallelogram identity, since

    ||m_n-m_k||^2
      <= 2||x-m_n||^2+2||x-m_k||^2-4 dist(x,L)^2 -> 0.

Closedness gives a minimizer `m`; varying `m` in real and imaginary
directions in `L` makes `x-m` orthogonal to `L`. Pairing with this
nonzero residual is a continuous annihilator not vanishing at `x`.
The same argument shows that `L` is the intersection of its continuous
annihilators.

Assume `L` is also `R`-invariant. For `c in L` and an annihilator `b`,

    sum_j b_j c_{j-r} = ell_b(R^r c)=0,       r>=0.         (20)

Their two weighted sequences are bounded because they are square
summable. Choose a nonzero annihilator `b*`. Support separation supplies
`t=max supp b*`. For every nonzero `c in L`, it gives
`min supp c>=t`. The zero-shift identity in (20) then has only the
possible term `b*_t c_t`, so `c_t=0`. Thus `L` is supported at indices
at least `t+1`.

The union of the supports of elements of `L` is now a nonempty
integer set bounded below. Let `h` be its minimum, and choose
`c* in L` with `c*_h != 0`. Every element of `L` vanishes below `h`.
For every nonzero annihilator `b`, support separation with `c*`
gives `max supp b<=h`; the zero-shift identity forces `b_h=0`.
Thus **all** annihilators vanish at every index `j>=h`.
They vanish on the entire coordinate tail at `h`, not only its
finite-support vectors, by continuity. The intersection-of-annihilators
property gives containment of that tail in `L`. The reverse containment
was already proved, so `L` is precisely that tail.

The zero and whole subspaces are the two infinite tails. Conversely,
each coordinate tail is closed and invariant under right translation.
Finally

    U(c)_j=w_j c_j,          U R U^{-1} e_j
                              =(w_{j+1}/w_j)e_{j+1}

is the asserted unitary identification; positivity of `w_j` preserves
every coordinate-vanishing condition.

Lean's `endpoint_strict_of_zero_pairing` verifies the precise
zero-shift endpoint exclusion for arbitrary complex bilateral
sequences. The Hilbert-space representation and classification in
this section are proved above in prose, not mislabelled as kernel
formalizations.

Source map: the final two paragraphs of `domar-proof.tex` and all of
`lem:domar` in `criterion.tex`.

## 7. Exact replay, formal scope, and remaining review

Run from the campaign root:

    $WORKSPACE/argus-live-update/.venv/bin/python research/quadratic-support-separation/verify.py

The verifier independently replays the exact polynomial identity in the
stored Jacobian result, invokes the real Lean 4.31.0 compiler through the
authorized `lean_evidence` module, records that run on `C_QSS_CORE`, and
runs both official checks against this **campaign** root. It does not
replay a bounded test and call that a proof of (4).

The Jacobian adapter evidence is in separate discovery, contract, payload,
and output JSON files. The executed operation was
`polynomial.ideal.normal_form.compute`, server 0.14.0, MCP protocol
2025-11-25. It returned `COMPUTED`, `in_ideal=true`, and zero remainder
for the denominator-cleared identity

    (1-2y)(x-1)-(x-3) = -2 ((x-1)y-1).

With `x=exp(lambda)>3` and `y=1/(x-1)`, this checks the margin algebra
in (16)--(19). It is only an algebraic subproblem; it is not evidence
by itself for an infinite-sequence theorem.

`Main.lean` proves the universal envelope/contact, curvature alternative,
slope-matching, two-direction middle, full infinite-tail, complex-margin,
cofinal-subsequence, and zero-shift endpoint lemmas. Its precise
quantifiers and remaining application boundary are documented once in
`statement_fidelity.md`. In particular, **the entire manuscript
support theorem and Hilbert-space classification are not claimed to
have been encoded as single Lean declarations**. Their complete
mathematical proof is Sections 1--6, which an independent Reviewer
must read and confirm.

The initial ledger had no mathematical evidence beyond the campaign
objective. The new core certificate is real mechanical evidence;
the support and classification judgements are Engineer judgements
pending independent review. No Reviewer acceptance, `verified_new`
novelty, or publishable mathematical novelty has been fabricated.
As a known-result verification checkpoint, this node alone is not
terminal completion of the independent publishable campaign. The
two global construction theorems remain open in the proof graph.
