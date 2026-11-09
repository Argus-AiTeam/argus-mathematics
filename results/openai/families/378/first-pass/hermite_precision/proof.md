# Universal tapered Hermite recovery

## Statement and scope

The target is `lem:tapered-hermite` in the staged
`build/quantitative-contraction.tex`, lines 250--339. This note proves that
lemma, not the entire counting algorithm. It also gives an exact, smaller
sufficient precision. The proof uses no external interpolation theorem:
the interpolation identity and the required valuation counts are proved below.
The inherited Wiki index supplied no relevant Hermite result.

Let `1 <= u <= a`, `M >= u`, `L = 2^a`, `alpha = 2^(a+1)`,
`S = {-L,...,L-1}`, and `h = ceil(3M/u)`. For nonzero `t` let
`i = v_2(t)` and `m_t = h max(u-i,0)`. Only nodes with `i < u`
are retained. Put `n = a-i`, `k = u-i`, and

    B(n,k) = sum_{j=1}^n j min(j,k) 2^(n-j)
           = 6*2^n - (2*k+6)*2^(n-k) - k*(n+2),  1 <= k <= n.

For each retained node define

    loss_t = h B(a-i,u-i),
    P_t = p + loss_t + (m_t-1)(a+1-i).

**Theorem.** Under exactly the polynomial and integrality hypotheses of the
target lemma, the first `m_t` coefficients of `F(t+alpha*z)`, known
coefficientwise modulo `2^P_t`, determine `F(0)` modulo `2^p`.
In particular the manuscript's

    p_t = p + 8*h*(L/2^i) + 8*M*(a+1)

is sufficient at every retained node. Recovery is polynomial in the stated
parameters and precisions. This is a universal theorem, not an inference
from the finite checks in `verify.py`.

The strongest prior result in the supplied mission was the manuscript's
unreviewed estimate `v_2(E_t(0)) >= -6hD_t`. Here the exact loss and
a smaller sufficient precision are derived independently; the standalone
checks and Lean core are additional certification, with their respective
scopes distinguished in `statement_fidelity.md`.

## Exact valuation counts, including the boundary

The grid has `2^(a+1)` consecutive integers, one complete residue system
modulo `2^(a+1)`. For each `0 <= r <= a`, exactly `2^(a-r)`
of its elements have valuation `r`; its only zero is separate.
Indeed, exactly `2^(a+1-r)` residues are divisible by `2^r`
and exactly `2^(a-r)` are divisible by `2^(r+1)`.
Subtract the counts. At `r=a` the one nonzero point is `-L`;
it must not be discarded.

For fixed `t` of valuation `i`, translation permutes that residue system.
For `j >= 1` with `i+j <= a`, exactly `2^(a-i-j)` points `q`
satisfy `v_2(t-q)=i+j`. None is zero or `t`, and each has valuation
`i`: the unequal-valuation identity applied to
`q=t-(t-q)` gives this. Ordinary integer differences have absolute
value below `2^(a+1)`, so no nonzero difference has larger valuation.
There are also exactly `2^(a-i-j)` points with `v_2(q)=i+j`;
each has `v_2(t-q)=i`.
Points of valuation below `i`, or of valuation `i` whose difference
has valuation `i`, contribute zero to the following sum.

Define rational scalar polynomials

    E_t(T) = product_{q in S, q != 0,t} ((T-q)/(t-q))^m_q.

Every factor at zero is nonzero. Additivity of the rational valuation
and the counts just proved yield, with no asymptotic approximation,

    v_2(E_t(0))
      = sum_{q != 0,t} m_q (v_2(q)-v_2(t-q))
      = sum_{j=1}^{a-i} j 2^(a-i-j) (m_(i+j)-m_i)
      = -h B(a-i,u-i).

Here `m_r = h max(u-r,0)` and
`max(k-j,0)-k = -min(j,k)`. This includes the upper endpoint `j=a-i`,
even when its multiplicity is zero.

## Finite closed form; no infinite-series assumption

Let `B(0,k)=0`. Splitting off the last summand gives

    B(n+1,k) = 2 B(n,k) + (n+1) min(n+1,k).

When `k >= n`, `B(n,k)=B(n,n)`. Induction gives

    B(n,n) + n^2 + 4n + 6 = 6*2^n.

Starting at `n=k` and using the recurrence for `n>=k` gives

    B(n,k) + (2k+6)2^(n-k) + k(n+2) = 6*2^n.

All omitted terms on the left are nonnegative, so
`0 <= B(n,k) <= 6*2^n`. These are finite integer identities;
neither floating point nor an unproved summation formula is involved.

## Algebraic recovery over the actual coefficient module

Write `N = sum_t m_t`. There are `L` odd points, each with multiplicity
`hu`. Hence `N >= Lhu >= 3ML > M(2L-1)`. In particular `deg F < N`.
Also `hu <= 3M+u <= 4M`.

At a retained node,

    E_t(t+alpha*z)
      = product_{q != 0,t} (1 + alpha*z/(t-q))^m_q.

Every `v_2(t-q) <= a`, so `alpha/(t-q)` lies in `2 Z_(2)`.
The displayed polynomial has constant term one and coefficients in
`Z_(2)`. Its inverse power series is integral: if its coefficients
are `e_0=1,e_1,...`, the inverse has `b_0=1` and
`b_d=-sum_{r=1}^d e_r b_(d-r)`. Induction proves integrality and
the inverse identity coefficient by coefficient.
Thus multiplying the local jet by this inverse loses no precision.

Let

    Q_t(z) = [ F(t+alpha*z) / E_t(t+alpha*z) ]_<m_t,
    H_t(T) = E_t(T) Q_t((T-t)/alpha).

At node `t`, the difference `F-H_t` is divisible by `(T-t)^m_t`,
because substitution by `alpha*z` is invertible over the rational
coefficient module. At another retained node `q`, `H_t` is divisible
by `(T-q)^m_q`. Each `H_t` has degree below `N`.

Consequently `G=F-sum_t H_t` has degree below `N` and is divisible by
each `(T-t)^m_t`. To justify passing to their product without a field
assumption on the coefficient algebra, expand in any rational basis of
the coefficient module. Each scalar coordinate is a polynomial over
`Q`, where distinct linear factors are coprime. A scalar polynomial
divisible by their product of degree `N`, yet of degree below `N`,
is zero. Every coordinate of `G` is zero. Evaluating at zero proves

    F(0) = sum_t E_t(0) Q_t(-t/alpha).

The argument also works for an arbitrary rational vector space: each
polynomial uses only finitely many vectors, and one works in their
finite-dimensional span.

For the original ring, monicity of `f` and of `V^ell` gives the basis
`U^b V^c`, `0 <= b < e`, `0 <= c < ell`, over `Z_(2)`, and the same
basis over `Q` after scalar extension. Polynomial division by the monic
relations proves existence and uniqueness of normal forms. The natural
map into `Q[U,V]/(f,V^ell)` is injective by those normal forms.
Hence integral coordinates mean exactly membership in `A`, and errors
whose coordinates lie in `2^p Z_(2)` mean exactly membership in
`2^p A`. All the Hermite multipliers are rational scalars, so they
act separately on these coordinates. Nilpotents and other zero divisors
do not affect this proof. In fact irreducibility of `f` is unnecessary
for this recovery lemma: any monic `f` gives the same conclusion.

For clarity, the rational norm criterion used in the Lean core is
exactly this coordinate divisibility criterion. For nonzero `x`, write
`x=2^r m/d` with `m,d` odd and `r` an integer. Then
`|x|_2=2^(-r)`, so `|x|_2<=2^(-p)` is equivalent to `r>=p`,
or to `x in 2^p Z_(2)`. Zero satisfies both criteria. Thus the
formal norm statement is not a change of coefficient ring or topology.

## Precision theorem

Suppose the input coefficients at node `t` are changed by arbitrary
elements of `2^P_t A`. The integral reciprocal just constructed changes
each coefficient of `Q_t` by an element of `2^P_t A`.
For `0 <= d < m_t`,

    v_2(E_t(0)(-t/alpha)^d)
        = -loss_t - d(a+1-i)
        >= -loss_t - (m_t-1)(a+1-i).

Thus every changed summand belongs to `2^p A`, as does their sum.
The reconstructed answer is integral because it differs from the
integral `F(0)` by an element of `2^p A`. This argument applies to
arbitrary lifts of every input residue, not only to perturbations
arising from a second globally admissible polynomial.

Finally `loss_t <= 6hD_t`, `m_t <= hu <= 4M`, and
`a+1-i <= a+1`, so

    P_t <= p + 6hD_t + 4M(a+1)
        <= p + 8hD_t + 8M(a+1).

This proves the exact requested estimate, including at the last
retained level `i=u-1`. Integral local series at unused nodes and at
zero are not needed for recovery; the stated hypotheses are stronger
than needed.

## Bit complexity

There are at most `2L-1` nodes, each `m_t <= 4M`, and
`N=O(ML)`. Differences and nodes have `O(a+1)` bits.
Coefficients of the scalar products and of their truncated inverses
can be computed by polynomially many rational operations. Expanding
products of `O(ML)` linear factors, and truncating inverse series at
`4M`, gives numerator and denominator bit lengths polynomial in
`M,L,a`: denominators divide products of polynomially many integer
differences and powers of `alpha`, while the number of expanded terms
has logarithm polynomial in those parameters.
Each supplied coefficient has a representative of its stated precision.
Use rational coordinate arithmetic for the final sum, cancel powers of
two in its denominator, and invert the remaining odd denominator modulo
`2^p`. Both the number of operations and their operand bit lengths are
polynomial in `M,L,e,ell` and the input precisions.

## Precise consequence for the sharper bounds

This result validates the local recovery and precision step at lines
351--380 of `quantitative-contraction.tex`. Under the appendix's separate
recursion-parameter assertions, `h=O(M/u)`,
`D_t >= 2^(a_previous+u)`, and the inherited precision and
`M(a+1)` terms are absorbed. Therefore the required child precision is
`O(MD_t/u)`, not merely `O(MD_t)`. Combined with the separate bound of
`6M/D_t` modes per weight, the appendix's partition estimate gives
`exp(O(sqrt(M p_t/D_t))) = exp(O(M/sqrt(u)))`.
This is the promised `1/u` saving in the precision and `1/sqrt(u)`
saving in the per-call exponent.

It removes this particular obstruction to the sharper contraction
bound `2^O(s/sqrt(log s))` and, conditionally on the other parts of the
appendix, to the fixed-density `#k`-SAT exponent
`O(n/sqrt(log n))` and the general-density exponent
`O(n log log n/sqrt(log n))`. It does **not** independently verify
packing, modes, child tensor descriptions, recursive complexity, or the
reductions. It neither proves nor refutes the separate weaker algorithm
with exponent `O(n(log log n)^2/sqrt(log n))`, nor the ETH conclusion
on its own.

The full theorem here is a written proof. The exact finite verifier
is a replay and adversarial regression suite, not a universal proof.
The Lean certificate's scope is stated separately and must not be
silently enlarged to the whole counting theorem. Independent Host
Reviewer acceptance and a novelty determination remain outstanding.

## Reproduction

Run from the campaign root:

    python3 research/hermite_precision/verify.py research/hermite_precision/exact_certificate.json

This also checks that the archived successful Lean core certificate
contains exactly the current source and statement-fidelity text.
To obtain a new real compiler verdict and attach it to the core claim:

    $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/hermite_precision/Main.lean --project-root . --claim C9000378-HERMITE --statement-fidelity research/hermite_precision/statement_fidelity.md

The installed interface takes the source positionally, not with
`--source`. Its source-adjacent certificate directory is within this
mission's owned paths. No Lake project or upstream library changes
are required.
