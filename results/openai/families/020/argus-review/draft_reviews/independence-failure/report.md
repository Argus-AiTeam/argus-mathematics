# The failed full-minor independence route

## Exact claim, source and assessment

**Engineer assessment: the old obstruction is valid, but it refutes only
an alternative proof.** It is not a counterexample to the manuscript,
to the finite deletion theorem, or to the final scheduled-block argument.

Exact old claim **C_ADAPTIVE_NO_INDEPENDENCE@1**:

> There are actual full evaluation-kernel paths on unions of rational
> lines for which a singleton sampled prime always divides a full-path
> minor but never a deleted-path minor; the record changes on every such
> edge. Treating the removed prime as independent of the full-path minor
> is not a valid alternative proof.

The source is the Argus draft
`9000020/research/adaptive_prime_audit/report.md:268-319`, with its
actual-kernel finite regression and exact certificate. The comparison
uses the full-path conventions assessed in `../actual-kernels/report.md`,
from OpenAI's September 24, 2026 manuscript, reference revision
`4eaee87548250b2682affda7d05d947c05554bae`. The old source matches the
preserved `2026-11-06T10:20Z` snapshot. Attribution is to the existing Argus
stress construction; neither novelty nor independent acceptance is claimed.

## Verify the actual construction, not invented adaptive integers

Fix any positive degree allowances \(D_1,D_2\). Choose an integer
\(L>\max(D_1,D_2)\), and a set \(P\) of more than \(L\) distinct primes,
all larger than \(L+1\). Take
\[
Z=\mathbb A^2,\quad r=2,\quad z=(0,0),\qquad
S=\{(0,0)\}\cup\{(pk,p^2k):p\in P,\ 1\le k\le L+1\}.
\]
Keep the second block empty and vary the first.

**Empty first block.** A polynomial of degree at most either allowance
that vanishes on \(S\) restricts to a univariate polynomial on every
line \(y=px\), with more roots than its degree. It therefore vanishes
on every such line. The distinct linear factors \(y-px\) all divide it;
there are more than \(L\) of them, so the polynomial is zero.
Both full evaluation kernels are zero, both parents stay the plane,
and choose the empty-equation plane patch with minor 1.

**Singleton first block \(\{p\}\).** If \(p'\ne p\), a nonzero sample
point on the \(p'\)-line has first coordinate \(p'k\) not divisible by
\(p\): \(p\nmid p'\) and \(1\le k<p\). Thus the entire residue class
of \(z\) modulo \(p\) consists exactly of the samples on the \(p\)-line,
including the origin. Restriction to those samples has kernel precisely
the degree-truncated ideal of \(y=px\). Since the degree allowances are
positive, its zero set is the line, not merely a selected point.
The second, empty block preserves this parent and residue class.

Use the primitive equation \(g=px-y\), with the first nonzero Jacobian
column, so the chosen minor is \(\partial g/\partial x=p\). This is a
permitted fixed, bounded-height rule on these input lines; the patch is
smooth and covers every sample point, including \(z\). The relevant
full-path minor is \(p\); if the same line patch is used at both stages,
the product of all minors is \(p^2\), which has the same bad-prime event.
Deleting \(p\) gives only plane minors 1.

The example asserts the existence of this permitted deterministic
choice, not that every possible patch convention must have a bad minor.
Choosing the other Jacobian column would give a unit, but cannot rescue
a purported independence argument that must work for all allowed paths.

If at least two distinct pool primes are inserted, the class contains
only the origin by the same divisibility argument. The full anchored
path still exists, including such zero-dimensional parents.

For the singleton insertion, the first evaluation rank changes from
\(\binom{D_1+2}{2}\) to \(D_1+1\), a strict decrease. The mixed-radix
record therefore changes. The rank-drop term in the correct deletion
inequality absorbs the bad event; there is no contradiction.

Choosing a uniform singleton and then deleting its unique prime gives
\[
\mathbb P(q\mid\Delta_{\rm full}(z))=1,\qquad
\mathbb P(q\mid m_{\rm deleted}(z))=0.
\]
Conditional on the empty deleted set, \(q\) is uniform but the full
minor is still the function \(q\). A distinct-divisor bound for each
fixed integer cannot be applied as if that random integer were fixed.
The manuscript instead uses the deleted-path integer and explicitly
does not condition on stability.

## Box and Hilbert hypotheses are genuinely compatible

This is not repaired by increasing the fixed cut degrees. Set the two
weights and both \(\delta_h\) to 1, with box constant 1. Every irreducible
curve in the plane has a nonconstant coordinate, whose powers are
linearly independent, giving
\(H_A(T)\ge\lfloor T\rfloor+1\ge T\).
For the plane,
\(H(T)=\binom{\lfloor T\rfloor+2}{2}\ge T^2/2\).
These meet the uniform Hilbert alternatives for all relevant
positive-dimensional subvarieties, without an exceptional alternative.

Choose fixed \(0<\zeta<1/2\), and pool primes at most \(32X^\zeta\).
The pool-growth argument in the cumulative-products unit supplies
arbitrarily many such primes for large \(X\). Once \(L\) is fixed,
\[
p^2k\le1024(L+1)X^{2\zeta}\le X
\]
for sufficiently large \(X\); the first coordinates are smaller.
Thus the set fits the fixed box with no circular selection of its
constant after the degree allowances.

The empty second block and singleton first block are admissible for the
full-path comparison. They are **not** a replay of the final
large-\(\ell_i\), all-blocks-positive schedule. Their purpose is to
disprove an unconditional alternative independence principle, not to
invalidate that schedule.

## Existing finite replay and one fresh typed adapter operation

The single read-only verifier replay recorded in
`../finite-deletion/verify_replay.json` exited 0. Its complete matched
output is in `../finite-deletion/regression_results.json`. It checks
the actual rational kernels in degrees 1, 2 and 3:

| Degree | Pool size | Sample points | Subset states | Deletion edges | Singleton full/deleted bad fraction |
|---|---:|---:|---:|---:|---|
| 1 | 3 | 7 | 8 | 12 | 1 / 0 |
| 2 | 4 | 13 | 16 | 32 | 1 / 0 |
| 3 | 5 | 21 | 32 | 80 | 1 / 0 |

These are finite regressions, not the proof for arbitrary degree
allowances given above. They were not rerun by this unit.

The old degree-two evaluation example uses the four points
\((0,0),(7,49),(14,98),(21,147)\) and monomials
\(1,x,y,x^2,xy,y^2\). On the rational line \(y=7x\), these span the
three independent functions \(1,x,x^2\); the rational rank is 3.
Modulo 7 every point is the origin, giving four identical rows
\((1,0,0,0,0,0)\), so the finite-field rank is 1.

After inspecting its exact typed contract, one bounded operation was
replayed through the isolated Argus adapter:

```text
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation prime_field.matrix.rank.compute --payload-file research/draft_reviews/independence-failure/jacobian_payload.json
```

The exact payload and unmodified complete typed response are
`jacobian_payload.json` and `jacobian_result.json` in this directory.
The operation returned field 7, rank 1, and its source matrix, server
**0.14.0**, protocol **2025-11-25**. The process exited **0**,
completed with no timeout and no structured adapter error, and the
output agrees with the preserved response apart from runtime. This
is a characteristic-dependent local rank check, not a verification
of geometry, height uniformity, or the whole paper.

## Disposition

The old route `R_FULL_MINOR_INDEPENDENCE` is correctly retired for the
explicit reason that the full-path minor can target the removed prime.
Do not silently reopen that route or broaden the obstruction into a
manuscript refutation. No unresolved mathematical step was found in the
scoped stress argument; independent review and any originality claim
remain separate. All old inputs were kept read-only.
