# A shell-uniform obstruction to dual-chain ECM

## Statement and unchanged algorithm

Fix positive rational constants `c,d,e,u`. The algorithm is exactly the
conditional-gcd class in `../ecm-polynomial-budget/analysis.md`, strengthened
by attempting **both** its increasing-factor chain and a left-to-right
binary chain for the whole scalar, from the same sampled point. Neither
chain is replaced by the other. In particular, put

```text
n = bit_length(N), B = ceil(n^u), W = ceil(n^c),
S = ceil(n^e), T = ceil(n^d),
V = ceil(sqrt(N)), H = V + floor(2*sqrt(V)) + 1,
K(H) = product_(2 <= r <= W) r^floor(log_r(H)).
```

Preprocessing, the uniform `(a,x,y)` sampler with
`b=y^2-x^3-a*x`, the discriminant gcd, affine pseudo-addition, normalized
projective records, and global infinity are unchanged. A `y`-sum is tested
only after the **individual** `x`-difference gcd is `N`. Nonunit batches
are split before that decision. Stage two computes every `[s]Q`, `s<=S`,
and the registered pairwise comparisons with this same conditioning.
It may be run after each chain: duplicating it does not affect the
containment below. Both chains may continue through global infinity using
the ordinary identity rules. Recursion occurs only after a proper factor.
The proof does not delete any of these branches or count only `[K]P=O`.

**Counterfamily theorem.** Define

```text
D = max(3*c+2, e+1), delta = 1/(2*D),
epsilon = delta/16, beta = delta/4, eta = delta/128.
```

There is an effective canonical infinite family of distinct balanced
semiprimes on which the probability of any proper factor in the complete
frozen run is at most `2^(-eta*n)` for all sufficiently large members.
In particular `eta=1/(256*D)>0`. This is a proposed prose proof for
independent review, not a formal proof or a claim that general factoring
is impossible.

The improvement over the reviewed factorwise result is specific: a
polynomial-bit **common support for all scalar schedules in a shell**
replaces the small-prime support. Its primes need not be small. The
Rankin argument below uses their number, not a bound on their sizes.

## Facts reused, and known failed implications

The archived, previously reviewed source excerpts in
`../ecm-polynomial-budget/` are the only analytic inputs.

* Lenstra, *Factoring Integers with Elliptic Curves* (1987),
  DOI `10.2307/1971363`, section 1.5 and Proposition 1.9(a):
  Hasse's interval, the automorphism-weighted fixed-trace identity, and
  the effective bound
  `sum_(m in A) H((p+1-m)^2-4p)
  <= C |A| sqrt(p) log(p) (log log(p))^2`.
* The same paper, Proposition 1.16 and its proof, and the text before
  Corollary 2.8: a nonsingular order `m=p+1-t` contributes exactly
  `(p-1)(m-1)H(t^2-4p)` triples. Given a model, the sampled point is
  uniform on its `m-1` affine points.
* The same paper, sections 2.2-2.5: the conditional pseudo-addition
  semantics and factorwise chain. Section 2.13 only suggests a
  continuation; the frozen exhaustive stage two is a campaign extension.
* Johnston--Yang, `arxiv:2204.01980v2`, Corollary 1.2, equation (1.5),
  Table 1, row `X=log 2`: for `z>=2`,
  `|theta(z)-z| <= 9.40 z (log z)^1.515
  exp(-0.8274 sqrt(log z))`. Consequently each fixed positive-proportion
  interval has an effective eventual prime lower bound `C X/log X`.

The earlier final-scalar-only implication fails: on `N=77`, the reviewed
order-13 example finds a factor during multiplication by 60 through the
relation `14-1=13`, not through a divisor of 60. An unconditional `y`-sum
implication also fails: on `y^2=x^3+x+32` over `F_101`, the order-101
point `(4,10)` has `3Q=(43,87)` and `27Q=(30,14)`, with zero `y`-sum
but unequal `x` coordinates and `30Q != O`. Neither failed implication
is used here. No uniform curve-order sampling hypothesis is used.

## 1. Support is chosen before the primes

For an integer `h>=6`, define

```text
X = 2^h, n_h = 2h+1,
W_h = ceil(n_h^c), S_h = ceil(n_h^e),
Y_h = 2*max(W_h,S_h), L_h = 1+W_h*(h+1).
```

Use the same separated prime intervals as the reviewed proof:

```text
I_1 = [X, floor(21X/20)],
I_2 = [ceil(6X/5), floor(5X/4)].
```

Any product of one prime from each interval has bit length `n_h`.
Its `V` is at most `3X/2`, while
`2*sqrt(3X/2)+1 <= X/2` for `X>=64`; hence its actual integer `H`
lies in `[X,2X]`. This bound is established without choosing either prime.

Form the breakpoint set

```text
B_h = {X} union {r^j : 2<=r<=W_h, j>=1, X<r^j<=2X}.
```

For each `r` there is at most one power in `(X,2X]`. Thus
`|B_h|<=W_h+1`. The exponent vector, and therefore `K(H)`, is constant
between consecutive breakpoints. The list

```text
K_h = {K(b) : b in B_h}
```

contains **every** whole-scalar schedule possible for any input in this
shell, including the endpoints. No factorization data enter this list.
For each such scalar,

```text
log_2 K(b) <= (W_h-1)*(h+1), bit_length(K(b)) <= L_h.   (1)
```

For an integer `k>=1`, define its relation list `A(k)` directly from its
binary expansion. Start with prefix `a=1`. For each subsequent bit:

```text
record 2*a;                         // the doubling
if the bit is 1, record 2*a-1 and 2*a+1;
replace a by 2*a + bit.
```

All recorded integers are positive and at most `k`. Their number is at
most `3*(bit_length(k)-1)`. Every noninitial output prefix occurs in the
list: it is `2a` or `2a+1`. For `k=1` the empty list is sufficient.

Define the integer and its prime support

```text
M_h = Y_h! * product_(k in K_h) product_(v in A(k)) v,
P_h = {prime ell : ell divides M_h}.
```

Repeated factors are harmless; no squarefree decomposition is required.
This construction precedes eligibility and the choice of the primes.
It covers all schedules, not just the schedule of a retrospectively
selected input. By (1),

```text
log_2 M_h <= Y_h*log_2(Y_h) + 3*(W_h+1)*L_h^2
           = O_(c,e)(h^D),             |P_h| <= log_2 M_h.   (2)
```

Here `Y_h*log(Y_h)=O(h^(max(c,e)+1))`, and
`3c+2>c+1`, giving exactly the displayed `D`.
Breakpoints, scalars, relation lists, and `M_h` can themselves be computed
with polynomially many bit operations for fixed `c,e`.
Equation (2) does **not** assert `ell=poly(h)` for `ell in P_h`.

## 2. Rankin bound for arbitrary prime support

This elementary lemma is uniform in the support and in the sizes of its
primes. If a finite set `P` has `k` primes, list them increasingly as
`ell_1,...,ell_k`. Then `ell_j>=j+1`. For
`sigma=1-delta>=1/2`, therefore,

```text
sum_(ell in P) ell^(-sigma)
 <= sum_(j=1)^k (j+1)^(-sigma)
 <= ((k+1)^delta-1)/delta.                              (3)
```

For `0<=z<=2^(-1/2)`, `-log(1-z)<=4z`. Applying the usual finite
Euler product to the positive integers supported on `P_h` gives

```text
Psi_P(3X)
 <= (3X)^(1-delta) product_(ell in P_h)(1-ell^(-sigma))^(-1)
 <= (3X)^(1-delta) exp(4*((|P_h|+1)^delta-1)/delta)
 <= (3X)^(1-delta/2)                                    (4)
```

eventually: (2) and `D*delta=1/2` make the extra logarithm `O(sqrt(h))`,
whereas `log X=h log 2`. All constants are effective for a fixed tuple.
This proves the needed estimate even when individual support primes
are exponentially large or larger.

For positive `m`, let `m_P` be its maximal divisor supported on `P_h`,
and let `r_P(m)=m/m_P`. Call `m` bad if `r_P(m)<=X^epsilon`.
The unique decomposition `m=m_P*r_P(m)` and (4) yield

```text
#{bad m <= 3X}
 <= floor(X^epsilon) Psi_P(3X)
 <= X^(1-beta)                                         (5)
```

eventually. The slack is explicit:
`delta/2-epsilon=7delta/16 > beta=delta/4`.
No smooth-number asymptotic or assumption on prime sizes is hidden here.

The predicates are effective without factoring `M_h`: repeatedly divide
`m` by `gcd(m,M_h)` until the gcd is one. The final quotient is exactly
`r_P(m)`, in at most `log_2 m` iterations. Comparisons with rational
powers are made by clearing their denominators.

## 3. Canonical prime selection and preprocessing

For a prime `p` in either interval define

```text
D_h(p) = #{bad m : (m-(p+1))^2 < 4p}.
```

Call it eligible if `D_h(p)<=X^(1/2-beta/2)`.
For large `h`, all these Hasse integers lie in `[1,3X]`.
A fixed `m` can belong to these windows for at most `8 sqrt(X)` integer
centers `p`: `p<=5X/4` implies
`|p-(m-1)|<sqrt(5X)`, and the integer count has this bound.
Consequently, even summing over primes,

```text
sum_(p in I_j) D_h(p) <= 8 X^(3/2-beta), j=1,2.
```

At most `8 X^(1-beta/2)` primes in each interval are ineligible.
The cited effective prime lower bound is `C_j X/log X`, so each interval
contains eligible primes for every sufficiently large `h`.

Let `p_h` and `q_h` be the least eligible primes in `I_1` and `I_2`,
respectively, whenever they exist. Enumerate `h>=6` in increasing order,
skipping a shell with an empty eligible interval or with
`p_h<=ceil(n_h^u)`, and output `N_h=p_h*q_h`.
Each shell is a finite exact computation. The eventual existence result
and `2^h>ceil(n_h^u)` show that only finitely many shells are skipped.
This defines a canonical effective infinite family; polynomial delay for
generating it is neither used nor asserted.

For every output,

```text
(6/5)X^2 <= N_h <= (21/16)X^2 < 2X^2,
bit_length(N_h)=2h+1,           8/7 <= q_h/p_h <= 5/4.     (6)
```

Thus the factors are distinct, balanced, and odd. Distinct shells have
distinct bit lengths. The trial bound is below both primes, primality
testing reports composite, and the squarefree semiprime is not a perfect
power. The sampler is not conditioned on coordinates being units.
The factor separation also makes any fixed polynomial prefix of Fermat
trials fail eventually, although such a prefix is not required here.

## 4. Every arithmetic path in both chains

Work modulo one prime factor `r>3`, with nonsingular local reduction.
Before the first factor-producing event, every normalized finite global
point reduces to its stated integer multiple of `P`; a global infinity
reduces to infinity at both factors. Induction includes identity operations:
if a prefix is globally infinity, its formal integer prefix is unchanged
by that representation, and doubling or adding `P` still has the correct
new integer coefficient. It is not legitimate to silently restart its
integer coefficient at zero or one.

For two finite local points on a nonsingular short Weierstrass curve,
equal `x` coordinates mean equal or opposite points.

**Whole-scalar binary chain.** At a doubling of `[a]P`, the tautological
zero `x`-difference has gcd `N`, not a proper gcd. The subsequent `y`-sum
or tangent denominator can vanish locally only if `[2a]P=O`.
At an addition of `[2a]P` to `P`, a vanishing `x`-difference implies
`[2a-1]P=O` or `[2a+1]P=O`. Both coefficients are nonzero.
A conditionally reached vanishing `y`-sum implies the latter relation.
All of these coefficients lie in `A(K(H))`, hence have support in `P_h`.
If a noninitial prefix itself is infinity locally, its coefficient is
also in that list. Simultaneous global infinity adds no factor event.

**Factorwise chain.** During multiplication of `[A_0]P` by `r_0<=W_h`,
the relative binary prefixes are at most `r_0`. Secant, inverse, and
tangent cases imply annihilation by a nonzero integer of the form
`A_0*|i-j|`, `A_0*(i+j)`, or `2*A_0*i`.
At a true doubling the zero difference is not used as a relation;
use the positive tangent coefficient instead.
The accumulated `A_0` is `W_h`-supported and every other factor is at
most `2W_h`. These integers are all `P_h`-supported because of `Y_h!`.
This is the reviewed containment, not a claim about the final scalar alone.

**Stage two.** For either completed chain the base is `Q=[K(H)]P`.
Multiplying it by each `s<=S_h` has the same relative-prefix argument.
Comparing `[s]Q` and `[t]Q` gives the nonzero difference or sum
`K(H)*|s-t|` or `K(H)*(s+t)`; for coincident integer indices use the
positive doubling relation. All prime factors lie at most `Y_h`.
The `y`-sum is reached only when the individual `x`-difference has gcd
`N`; locally equal `x` together with zero `y`-sum really does mean
opposite points. The unequal-`x` order-101 witness does not enter this
branch. Identity inputs follow the global-infinity rule, without
inventing an affine denominator.

**Projective records and batches.** For finite inputs the normalized
secant record has

```text
d=x1-x2, z=lambda_numerator=y1-y2,
X3=z^2-(x1+x2)d^2,
Y3=z*(x1*d^2-X3)-y1*d^3, Z3=d.
```

The tangent uses `d=2y1` and `z=3x1^2+a`. Thus a nonunit intermediate
`Z3` is precisely an already counted denominator; unit `Z3` is inverted
before reuse. Cleared cross-products multiply the conditioned operands
by units and have the same local zero sets. A prime dividing a batch
product divides an individual operand. Splitting every nonunit
`x`-batch before queuing `y`-sums preserves the same decision tree.
No unrelated projective formula or unconditional `y`-sum is substituted.

If a local infinity would disagree with the other local reduction,
Lenstra's represented-point invariant forces a preceding registered
nonunit gcd; it cannot be carried forward as a normalized finite point.
This also covers the final coordinate and inversion paths.
Together these cases prove the complete containment

```text
a nonsingular registered factor event modulo r
  implies [v]P=O for a positive P_h-supported integer v.  (7)
```

It covers every possible actual `H` by Section 1, not a schedule chosen
after seeing `p_h,q_h`. The common support makes a union over the
individual binary prefixes unnecessary.

## 5. Actual sampler and complete-run probability

On a nonsingular curve of order `m`, the points whose orders are supported
on `P_h` form the product of the corresponding Sylow subgroups, of
cardinality `m_P`. This statement needs neither cyclicity nor absence of
the characteristic prime from the support. Given the model, the exact
triple sampler is uniform on its affine points, so for good `m`,

```text
Pr[P has P_h-supported order | model]
 = (m_P-1)/(m-1) <= 2/r_P(m) < 2X^(-epsilon).            (8)
```

For `r=p_h` or `q_h`, eligibility and the cited fixed-trace bound give

```text
Pr[nonsingular, bad curve order]
 = (r-1)/r^3 sum_(bad m in Hasse(r)) (m-1)H((r+1-m)^2-4r)
 <= C D_h(r) (log X)(log log X)^2 / sqrt(X)
 <= X^(-beta/3)                                        (9)
```

eventually. This is the actual model-point weight, not a uniform measure
on the Hasse integers. For each fixed `a,x`, the discriminant polynomial
`4a^3+27(y^2-x^3-a*x)^2` has degree four with nonzero leading coefficient
when `r>3`. At most `4r^2` triples are singular. Their probability is at
most `4/r<=4/X`, covering all local singular behavior and discriminant gcds.

Equations (7)-(9) therefore bound one trial's local factor event by

```text
4/X + X^(-beta/3) + 2X^(-epsilon) <= 7X^(-delta/16).
```

Uniform triples modulo `N_h` have uniform marginals modulo both primes.
For both chains, all arithmetic, both factors, and all `T<=2n_h^d` trials,
the **same** support containment gives

```text
Pr[any top-level proper factor]
 <= 28 n_h^d X^(-delta/16)
 <= X^(-delta/32)
 <= 2^(-delta*n_h/128) = 2^(-eta*n_h)                    (10)
```

eventually. A semiprime's recursive factorization cannot begin without
this top-level event, so (10) is also a complete-run bound.
Global infinity, batching, duplicate stage-two attempts, and stopping on
the first factor cannot enlarge the event beyond the counted union.

## 6. Exact resource accounting

The scalar has `O(W*n)` bits. Computing its exponents, its product, and
its binary expansion is polynomial time. Its whole binary chain has
`O(W*n)` additions. The existing factorwise chain uses at most
`O(W*n)` small multiplications, each with `O(log W)` additions.
Stage two uses `O(S log S)` additions and `O(S^2)` comparisons per base.
Doubling the chain/stage-two work changes only a constant factor.
All coordinate arithmetic and gcds are on polynomial-bit integers;
normalized coordinates themselves are reduced modulo `N`.
Polynomially many batch products and their splitting also have
polynomial bit cost.

The frozen capped sampler gives each coordinate
`R=n+ceil(log2(3T))+3` attempts of `n` random bits. An accepted coordinate
is exactly uniform below `N`; a cap failure returns `FAIL`.
The probability of any cap failure is below
`3T*2^(-R)<2^(-n-3)`. Coupling to uncapped exact samples shows that
failure only decreases success; it is not added as a fictitious factoring
event in (10). Trial division, exact primality and perfect-power tests,
verification, and at most `n` prime leaves in recursion preserve the
polynomial bound. Exact rational ceilings use integer root comparisons.

The effective family selector is a separate enumerator and is not
claimed to have polynomial delay. Its existence proof is Sections 1-5,
not a finite computation. The finite certificate accompanying this proof
is for exact schedule coverage, arithmetic, selection predicates, and
independent replay, not for replacing the asymptotic argument.

## 7. Exact certificate and independent reconstruction

`construct.py` produces `certificate.json`. Its finite family fixture has
`h=16`, `c=d=e=u=1/4`, and

```text
X=65536, n=33, B=W=S=T=3, Y=6,
p=65537, q=78649, N=5154419513,
V=71795, H=72331, K(H)=3869835264.
```

The entire shell has two scalar schedules, `3869835264` and `7739670528`,
with breakpoints `65536` and `131072`. Their combined support product has
1343 bits. The exact bad-order counts are 43 and 46, and the eligibility
comparison is `count^44 <= X^21`. Both selected primes are the first primes
in their respective intervals. Here the theorem's `eta` is `1/704`.
The fixture does not assert that the eventual probability estimate (10)
already holds at this small shell.

`replay.py` was implemented separately without reading or importing the
producer or its shared factorwise helpers. It enumerates **every** integer
height in `[X,2X]` (65537 heights), independently detects all schedule
transitions, reconstructs the complete product, and computes the bad-order
predicates by sieving and factoring the small Hasse integers. This differs
from the producer's breakpoint construction and saturated-gcd predicate.
It also reconstructs the least-prime conditions, exact rational ceilings,
actual scalar, bit bounds, preprocessing, and all positive relation counts.

For arithmetic, the producer runs the normalized modulo-`N` operations.
The independent replay instead carries two field points, reconstructing
the conditional gcd decisions and their operands by CRT. For
`N=35`, tuple `(1/2,1/2,1/2,1/2)`, and `K=72`, both implementations
enumerate all `35^3=42875` raw triples. The first-factor phase counts are

| Outcome | Raw triples |
|---|---:|
| Discriminant factor | 12250 |
| Factorwise stage one | 22896 |
| Factorwise stage two | 1776 |
| Whole-scalar stage one | 1464 |
| Whole-scalar stage two | 0 |
| No factor | 3264 |
| Singular discard | 1225 |

The exact raw one-trial success probability is `38386/42875`.
This small input is **not** presented as a low-success counterexample.
It tests the complete strengthened arithmetic rather than only the
already reviewed factorwise paths.

The first lexicographic escape with both local orders outside the old
`Y`-smooth support is

```text
N=35, a=2, b=6, P=(1,3), ord_5(P)=7, ord_7(P)=11.
```

The factorwise attempt, including stage two, does not factor. The whole
chain compares `8P=(26,13)` with `P=(1,3)`, finding
`gcd(26-1,35)=5`. Its new local relation is `8-1=7`, which does not
divide 72 and is larger than `Y=6`. The new support contains it.

The independent replay checks 225168 local normalized-projective records,
26136 nonsingular supported factor events, 12250 singular factor events,
and the local model-point sampler weights. It also reproduces the reviewed
order-13 and unequal-`x` order-101 controls. Exact rational arithmetic on
`y^2=x^3-2x+1`, `P=(0,1)` gives the binary-prefix trace

```text
P, 2P=(1,0), 4P=O, 8P=O, 9P=P, 18P=(1,0), 36P=O, 72P=O,
```

so passing through infinity and subsequently returning to `P` is actually
exercised, not treated as a dead trial. Nineteen material certificate
mutations are rejected against the independently reconstructed data,
including deletion of the nonactual shell schedule, deletion of the new
relation-7 support, and replacement of the least eligible prime by a
different eligible prime. There are no checksum-based acceptance shortcuts.

The exact independent reconstruction is rerunnable from the campaign root:

```bash
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/ecm-dual-chain/replay.py \
  --certificate research/routes/input-specific-exponent/ecm-dual-chain/certificate.json \
  --output research/routes/input-specific-exponent/ecm-dual-chain/replay-result.json
```

The saved run exited zero in 1.265008 seconds. It explicitly states that
finite reconstruction neither proves the infinite theorem nor constitutes
the host's independent Reviewer acceptance. Sections 1-6 supply the full
asymptotic argument; the replay checks the concrete mathematical operations
and exact predicates used there.

### Bounded Jacobian result

The pinned CLI's installed operation
`number_theory.elliptic_curve.short_weierstrass.scalar_multiply.compute`
was discovered and inspected before custom certificate code. It operates
over `QQ`, not finite fields; it is not substituted for the probability
argument. The local source distribution reports version `0.14.0`.
No MCP server or protocol session was used, so no server version is asserted.

The first request, for `72P` on the rational curve above, returned
`INVALID_ARGUMENT`, exit 1, without timing out. The request validator has
an additional conservative coordinate-height guard not expressed by the
scalar's JSON-schema bound alone. This rejected request supplies no
mathematical evidence and is preserved in `jacobian-attempt-1.json`.
The smaller `4P` request passed: the exact typed output is the point at
infinity on the retained curve, with runtime `0 ms`, exit 0, and no
error or timeout. `jacobian-result.json` identifies the exact payload,
contract, output, version provenance, and transport status. This only
confirms the bounded order-four calculation; the full `72P` infinity-return
trace is independently reconstructed above.

## Scope of the conclusion

The proposed result excludes only the frozen dual-chain polynomial-budget
class for each fixed resource tuple. It does not exclude
subexponential-budget ECM, different samplers, different stage-two
operations, unrestricted scalar schedules varying across an exponentially
large input-dependent bank, unrelated projective formulas, or general
classical factoring. Independent Reviewer acceptance remains required.
