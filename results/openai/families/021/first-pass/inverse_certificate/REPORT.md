# Partial modular incidences and a fixed rational list

## Scope and source limitations

The object under audit is Proposition `prop:inverse`, not the main
Jacobsthal bound in isolation. The proposition permits arbitrary prescribed
classes. Its exceptional set has normalized harmonic measure at most
`sigma` in the **whole** independent candidate box. The order of choices is
fixed parameters and list constants, then a sufficiently small fixed
`xi > 0`, then sufficiently large `z` depending on `xi`.

The staged source is
`research/openai_manuscript/A-quadratic-bound-for-Jacobsthals-function-September-25-2026/build/`.
The inverse argument has been read in full, including its polynomial
construction, degree-dependent nonlinear estimate, rational-line
extraction, and partial-incidence larger-sieve calculation. The
corresponding regular-box hypotheses have also been read. No conclusion
about the separate signed-reference calculation is made here.

The supplied scope finding is correct as a statement of what needs proof:
ordinary inverse-sieve theorems do not directly turn point-dependent
partial incidences into a rational list fixed before the failure set.
Walsh, *The algebraicity of ill-distributed sets*, Theorems 1.2 and 1.3,
assumes a bound on the residue classes occupied by the entire set, and
concludes polynomial concentration, not a bounded rational-intercept
list. The primary-source HTML at
<https://arxiv.org/html/1307.0259> was obtained and read, including the
start of Section 3. This is a comparison, not an external theorem invoked
as a proof of the proposition.

The inherited Wiki index and a targeted search supplied no prior
Jacobsthal/partial-modular-line theorem applicable to this implication.
The comparator formalization has not been used as evidence of a gap.
No false manuscript assertion has been established at this stage.

## Dependency frontier

The manuscript's main dependency chain is the quantitative survivor
theorem, followed by its large-prime removal argument. The survivor
theorem depends on the reference margin, prime-path occupation bounds,
regular independent boxes, the inverse proposition, structured variance,
and stopping. These are not being marked proved merely by recording
this decomposition.

Within the selected inverse route the obligations are:

1. Freeze the small-prime interval and sample distinct edge primes,
   retaining partial incidences of positive density and a small total
   slope budget. This uses the upper sieve, additive large sieve, CRT,
   and genuine independent full boxes.
2. Use congruence lattices and prime-product divisibility to obtain an
   integer polynomial vanishing at every rich point.
3. Bound nonlinear components uniformly in degree and extract a
   sufficiently populated rational line.
4. Prove a finite partial-incidence collision bound on that line;
   recover its reduced intercept and its squarefree exceptional product.
5. Place the intercept in the list defined on the whole candidate box
   and contradict nonstructuredness, with explicit quantitative
   inequalities and the original order of constants.

## Exact finite theorem

The following is a verification theorem, not a counterexample. In
particular, the point-specific sets of incident primes need not agree.

Let `P` be `n` distinct primes, all at least an integer `R >= 2`, with
arbitrary classes `a_p`. Let `Q` be any fixed finite universe of
squarefree positive integers coprime to every member of `P`, carrying
consistent prescribed classes at their prime divisors. Write `b_q` for
the representative in `[1,q]`. Fix integer height caps `H_D,H_A` and a
positive integer threshold `t`. **Before** choosing a set of points or
incidences, define `A_box` to consist of all reduced rationals `A/D`
with

```
0 < D <= H_D,  |A| <= H_A,
#{p in P : D*a_p = A (mod p)} >= t.
```

Let `X` be a set of points `(q,b_q)`, with distinct `q` in `Q`,
`q <= S`, and let `I` be an arbitrary partial incidence relation on
`P x X`. For every `p` there is a slope set `T_p` such that

```
(p,(q,b_q)) in I  =>  b_q + s*q = a_p (mod p)
                      for some s in T_p.
```

Put `K = sum_p |T_p|`. Suppose each point has at least `r` incidences.
Suppose a nonzero polynomial of degree at most `d` vanishes on `X`,
and at most `E` points of `X` lie on its nonlinear complex-irreducible
components. Choose integers `m >= 2`, `e >= 0`, `C >= 0` such that

```
|X| > E + d*(m-1),
H = floor(S/(m-1)) <= H_D,  2*S*H <= H_A,
R^(e+1) > H,               R^(C+1) > S,
r >= e+t,
K*(C*m^2 + n*m) < ((r-e-t)*m)^2.                 (F)
```

Then **not every incidence of `I` can be nonstructured** relative to
the pre-fixed list `A_box`, where structured means that its `p`
aligns with a member of the list and `D*q_E(A/D) <= H_D`.
This is a finite implication with strict, checkable inequalities.
It assumes neither the existence of an aligning intercept nor a
whole-set bound on residues modulo any prime.

### Proof: the partial-incidence core

There are at most `d` line components. If each contained at most
`m-1` selected points, the first inequality in (F) would fail.
Thus one contains `N >= m` selected points. A vertical line has at
most one, because `q` determines `b_q`. A nonreal line has at most
one real point. Two distinct lattice points on any remaining line
give the equation

```
d' * b_q = a' * q + b',  d' > 0, gcd(a',d') = 1.
```

In the increasing order of their distinct `q` coordinates, consecutive
differences are positive multiples of `d'`. The corresponding
`b_q` differences are multiples of `a'`, with constant sign.
Consequently

```
d', |a'| <= S/(N-1) <= H,   |b'| <= 2*S*H.
```

For `g = gcd(b',d') > 0`, write `d'=gD`, `b'=gA`.
Then `A/D` is reduced. Reduction modulo `g`, and `gcd(a',g)=1`,
show that `g | q` at every selected point. If a prime `ell | q`
does not divide `g`, the line equation gives
`D*b_q = A (mod ell)`. By CRT this is alignment with the same
intercept. Thus every nonaligned prime divisor of `q` divides `g`.
Distinctness of the prime factors, not squarefreeness of `D` or `d'`,
now gives

```
q_E(A/D) | g,    D*q_E(A/D) <= D*g = d' <= H_D.  (1)
```

This includes common prime factors of `D` and `g`.

Let `E_P = {p in P : p | d'}`, so `|E_P| <= e`.
For an unaligned `p` outside `E_P`, put `c = d'*a_p-b' != 0`
in the field `F_p`. The incidence of slope `s` implies

```
(a' + d'*s)*q = c (mod p).
```

The coefficient cannot be zero for an incident point. Hence each
slope admits at most one residue class of `q`. These are **only the
points incident for this prime**; no condition has been imposed on the
other points.

Make a cell for each pair `(p,s)` with `s in T_p`, allowing empty cells
for aligned or exceptional primes. In an unaligned nonexceptional
cell place the selected line points satisfying that slope test.
Write `H_I` for the total cell population. Each point lies in at most
one cell for a given prime, so `H_I <= n*N`.
Two distinct selected points can lie together in at most `C` cells:
every such cell supplies a distinct prime dividing their nonzero
`q` difference, whose absolute value is at most `S`.
The condition `R^(C+1)>S` gives this bound.

Double-counting ordered pairs in cells and separating the diagonal
therefore proves

```
sum_cells population^2 <= C*N*(N-1) + H_I,
H_I^2 <= K*(C*N*(N-1) + H_I)
      <= K*(C*N^2 + n*N).                         (2)
```

This is the crucial partial-incidence larger-sieve statement.
It does not replace point-specific incident primes by a common set.
All these inequalities, including their diagonal term, are proved
for arbitrary finite sets in `Main.lean`.

Write `a` for the number of primes aligning with the intercept.
Richness and the classification of primes give

```
r*N <= (a+e)*N + H_I.                            (3)
```

For `N >= m`, the strict inequality in (F) implies

```
K*(C + n/N) < (r-e-t)^2.
```

Equations (2)-(3) force `a > t`. The height estimates already proved
therefore put this intercept in `A_box`. By (1), every selected
incidence at an aligning prime is structured. If all selected
incidences had been nonstructured, their total would instead be at
most `e*N + H_I`; (2) and (F) contradict richness again. This proves
the theorem. `no_rich_nonstructured_line` formalizes exactly this
two-stage list-triggered contradiction, not an assumed alignment
conclusion.

### The list was fixed before the failure set

For completeness, suppose `B >= 0` satisfies

```
R^(B+1) > 2*H_A*H_D,    t^2 >= 2*B*n.           (4)
```

Distinct reduced rationals in the fixed height rectangle have
nonzero determinant of absolute value at most `2*H_A*H_D`.
Every common aligning prime divides this determinant, so at most
`B` primes can align with both. If `M = |A_box|`, the same
finite-family collision theorem, with primes as cells and rationals
as points, proves

```
M*t^2 <= 2*n^2.                                 (5)
```

No sample, failure set, refined-cell center, or bin width occurs in
this packing theorem. Its determinant identity and combinatorial
inequality are also formalized. Finiteness of the height rectangle
justifies applying the finite theorem even before this bound is known.

## Obtaining the polynomial: no assumed concentration

Here is an exact sufficient condition for the polynomial hypothesis
above. Let

```
v = (d+1)*(d+2)/2,
J_index = product_{p in P} p^((d+1)*|T_p|).
```

Choose any integer coefficient cap `h >= 1` such that

```
(h+1)^v > J_index,    v*h*S^d < R^r.             (6)
```

For every slope, substitution of `Y=a_p-sX` into a polynomial of
total degree at most `d` imposes at most `d+1` homogeneous linear
congruences on its `v` integer coefficients. Their simultaneous
kernel has index at most `J_index`, with no independence assumption
on the congruences. The `(h+1)^v` coefficient vectors in `[0,h]^v`
give two in the same coset. Their nonzero difference yields an
integer polynomial with coefficient absolute values at most `h`,
vanishing identically on every permitted line modulo its prime.

At a rich point at least `r` distinct primes divide its integer
value. Its absolute value is at most `v*h*S^d`, so the second
inequality in (6) forces that value to be zero. The universal
coprime-product zero criterion is proved as
`prime_product_forces_zero`. Polynomial interpolation and the
coefficient-box argument themselves are proved here in prose,
not claimed as Lean-checked declarations.

## An explicit degree-uniform nonlinear bound

The staged proof actually yields the stronger bound

```
E(d,S) = 512*d^3*(1 + ceil_cuberoot(S^2))         (7)
```

for `S >= 1`; this replaces its deliberately looser `O(d^4)` bound.
Here `ceil_cuberoot` is the least nonnegative integer whose cube is
at least its argument.

For clarity, constants can be justified without a coefficient-height
assumption. For a real complex-irreducible nonlinear factor of degree
`j >= 2`, the two partial derivatives have at most `2*j*(j-1)`
intersections with the factor. The square boundary contributes at
most `4*j`. Unless the inflection polynomial is divisible by the
factor, it contributes at most `j*(3*j-4)` intersections.
The elementary resultant argument in
`lem:elementary-bezout` gives these intersection bounds; its proof
was read, including the coordinate-change and Sylvester-degree
arguments. This is the ordinary affine Bezout bound, not an
unproved inverse-sieve assertion.

Thus there are at most `8*j^2` marked abscissae, including `0,S`.
Between them there are at most `8*j^3` monotone strictly convex
or concave graph arcs. An arc's consecutive lattice difference
vectors are distinct, have first coordinate positive, and have
total taxicab length at most `2*S`. For at least 16 such vectors,
at most half have length at most `floor(sqrt(number)/2)`;
this follows by counting positive-first-coordinate integer vectors
in a taxicab ball. The total length is consequently at least
`number^(3/2)/8`. Including shorter sequences, an arc has at most
`32*(1+S^(2/3))` lattice points. The marked fibers contribute at
most `8*j^3` further points. These bounds are below
`512*j^3*(1+S^(2/3))`.

If the inflection polynomial is divisible by the factor, a
nonspecial smooth arc would be linear, contradicting irreducibility;
only the already counted special points remain. A nonreal factor
has at most `j^2` real zeros, by intersecting with its distinct
conjugate. Finally `sum j^3 <= (sum j)^3 <= d^3` over the distinct
nonlinear factors proves (7). No argument about line components
is included in this nonlinear estimate.

This geometric proof is a mathematical proof, not a Lean
formalization. The exact replay checks its displayed arithmetic
constants and exponent bookkeeping, not real-algebraic geometry.

## Application to the manuscript, with the original quantifiers

Write `Z = exp(L/log L)`, and retain the manuscript's pre-chosen
`c5 > 0` and `cp = c5/4`. Sampling gives

```
|X| >= S/Z^4,   each point has >= c5*n incidences,
K <= n*R/L^6,  n comparable to xi*R/log R,
S = z^(2-alpha+o(1)),   R = z^alpha.
```

These are precisely partial incidences. Independence is used to
obtain them, not asserted for their selected subset.
Take

```
d = floor(R/L^2),  m = ceil(S/(R*Z^6)),
r = ceil(c5*n),    t = ceil(cp*n),
H_D = floor(R*Z^10), H_A = floor(S*R*Z^10).
```

All comparisons below are uniform over the allowed boxes, for each
fixed positive `xi`.

First, `S/(R*Z^6)` tends to infinity, and
`H = floor(S/(m-1)) <= 2*R*Z^6` eventually. Thus `H <= H_D` and
`2*S*H <= H_A`, with room for all integer roundings.
An integer `e` with `alpha_min*(e+1) > alpha_max` bounds the prime
divisors of these denominators for sufficiently large `z`.
An integer `C` with `alpha_min*(C+1)>2` bounds the prime divisors
of any nonzero `q` difference. These constants precede `xi`.

The nonlinear ratio from (7) is

```
d^3*S^(2/3) / (S/Z^4)
    <= z^((10*alpha-2)/3 + o(1)).
```

For the manuscript's `alpha <= 1/100` its power is at most `-19/30`;
the term without `S^(2/3)` is smaller. Also
`d*(m-1) <= S/(L^2*Z^6) = o(S/Z^4)`.
So the line-extraction inequality in (F) holds.

For (6), the coefficient box can be chosen with

```
log(2*h) <= log 4 + 2*K*log(2*R)/(d+2)
          = O(R/L^4).
```

Consequently
`log(v*h*S^d) = O(R/L) = o(R)`,
whereas `r*log R` is bounded below by a positive constant
times `c5*xi*R`. The latter constant is permitted to depend on
the fixed positive `xi`. This proves (6) eventually, without
choosing `cp`, `c5` or the list after `xi`.

For the collision margin, divide its left side by `n^2*m^2`:

```
K*(C+n/m)/n^2
 <= C*R/(n*L^6) + R/(m*L^6)
  = O_xi(L^-5) + z^(3*alpha-2+o(1))
  -> 0.
```

Meanwhile `(r-e-t)/n -> c5-cp = 3*c5/4 > 0`.
This proves the strict inequality (F) with integer roundings,
and hence the nonstructured-rich-point contradiction.

Finally choose an integer `B` with
`alpha_min*(B+1)>2+alpha_max`. The determinant height for the
**original whole-box** caps is at most
`2*S*R^2*Z^20 = z^(2+alpha+o(1))`. Thus (4) holds once
`n >= 2*B/cp^2`, and (5) gives `M <= 2/cp^2`.
This is the manuscript's bin-width-independent list bound.

The harmonic-to-counting and sampling steps have not been replaced by
this finite theorem. To apply it to the proposition, use exactly the
manuscript's initial cells, distinct sampled edge primes, and refined
cells. The discarded initial cells have normalized harmonic mass
`Z^(-1+o(1))`; the retained cell has bad count density at least
`sigma/16` because reciprocal weights vary by at most
`(1+xi)^3 <= 8`. The later discarded refinements cost
`W^2/Z^2=o(1)` **relative to that initial cell**. These operations
retain a nonstructured rich set if the original bad harmonic
fraction exceeds `sigma`. The finite contradiction rules this out.
It therefore bounds the exceptional mass relative to the whole
box, not relative to the bad-edge subset.

For interval freezing, `J/U >= constant*w^(3*a_star/4)`.
For fixed `xi > 0`, both the discrepancy intervals of lengths
comparable to `xi*J` and `xi*J/U` eventually exceed
`w^(a_star/2)`. The upper-sieve constants are independent of fixed
`xi`; the point at which the inequalities hold may depend on it.
The distinct-prime CRT factors `M0,u_1,...,u_h` are coprime and
`p,q` are units modulo them. The slope-count rounding term is
`M0*W`, not a relative-density assertion. The exact replay includes
these local CRT and rounding calculations.

Here are the analytic sampling details that connect this application
back to the bad-edge event. The independent prime-bin choices give
`#Q >= S*exp(-O_xi((log L)^2)) = S/Z^o(1)`:
each multiplicity-`m_j` bin contributes at least
`(n_j/2)^m_j/m_j!`, and the total multiplicity is `O(log L)`.
The fixed small-prime residues create only `M0^2=Z^o(1)`
initial cells; the value intervals add another `Z^o(1)` factor.
Their discarded count and reciprocal-weight distortion therefore
give the harmonic loss already stated, rather than a loss
conditional on badness.

On the frozen interval, write `m_s` for the survivor count and
`E_{p,u}(v)` for exceptional classes. The additive large-sieve
identity and bound give

```
sum_u u*sum_e (m_{e,u}-m_s/u)^2 <= constant*(J+U^2)*m_s,
m_s <= constant*J*V0,
average_u |E_{p,u}(v)|/u
    <= constant_xi*(log w)^2*(1/U + U/J)
    <= w^(-a_star/2).
```

The last step uses the actual `a_star=1/100`, `U>=w`,
and `J/U` at least a constant times `w^(3*a_star/4)`.
The constants are uniform in `p,v` and the cell; fixed `xi`
only changes the eventual threshold.

Take the manuscript's `h1` with `a_star*h1/2>12`.
If `f(p,q)` is the bad fraction of edge primes, density at least
`beta` gives at least a `beta/2` proportion of pairs with
`f>=beta/2`. Sampling `h1` distinct primes gives expected
incidence density at least
`gamma_inc=(beta/2)*(beta/4)^h1`. For the same sample the CRT
slope bound is

```
K_p = (p/M0)*sum_v product_i (|E_{p,u_i}(v)|/u_i) + M0*W.
```

Averaging products over distinct samples costs at most
`n_u^h1/(n_u)_{h1}`, which tends to one, and yields
`E[K_p/p] <= 2*w^(-a_star*h1/2)+z^(-c')`.
Thus the probability that `sum_p K_p > n*R/L^6` tends to zero.
Discarding those samples removes only `o(1)` from the
incidence expectation; since `gamma_inc` is fixed and positive,
a good sample retains density at least `gamma_inc/2`.
After the refined-cell loss, a cell has incidence density at
least `gamma_inc/4`. At least a `gamma_inc/8=c5` fraction of
its points has at least `c5*n` incidences. Its size is at least
`c5*S/Z^3 >= S/Z^4` eventually. Every retained incidence
remains nonstructured. This supplies all the hypotheses used
above without a common-prime-set assumption.

**Consequence.** The selected partial-incidence to fixed-list
implication is valid, conditional on the specified regular-box and
analytic sampling inputs. No refutation of `prop:inverse` was
found. This does not certify the other propositions used for the
uniform Jacobsthal theorem.

### Structural extension and comparison with the prior result

The same structural proof works for every fixed
`0 < alpha_min <= alpha <= alpha_max < 1/5`, provided the same
rich-configuration outputs are supplied. The limiting exponent
is `(10*alpha-2)/3`; all other displayed power exponents remain
negative on this larger range. The prior manuscript states only
`alpha_max=1/100` and uses a looser nonlinear degree bound.
This extension concerns the inverse structural implication,
**not** an extension of the regular-box construction or a stronger
Jacobsthal bound.

The finite quantitative formulation and this exponent extension
are candidates for an independent verification/generalization
result. Novelty and publishable significance remain questions
for independent Reviewer; they are not established by a search
miss. A targeted web search returned no verified matching
partial-line theorem and an inaccurate secondary summary of
Walsh's venue and hypotheses. That summary is not used as evidence.

## Exact replay and formal scope

`verify.py` uses only Python's standard library and exact integers or
`Fraction`. `exact_certificate.json` records its actual finite
fixture and expected numerical outputs. It checks a full Cartesian
prime-box construction, squarefreeness, a common prescribed CRT
system, partial point-dependent incidences, the line's primitive
equation, its reduced intercept, all exceptional products, the
collision and packing margins, separate CRT slope rounding tests,
and the preserved typed Jacobian result.

The main fixture has intercept `3/49`, primitive line
`3773*b=q+231`, and `g=77`. Thus a prime dividing the nonsquarefree
denominator also divides `g`, while each `q` remains squarefree.
This is an exact test of the manuscript's delicate arithmetic
case, not an asymptotic counterexample.

The script does **not** claim that a finite example proves the
universal theorem, that it enumerates every rational in the height
rectangle, or that its small box meets the manuscript's asymptotic
size conditions. The universal finite combinatorial and arithmetic
theorems are kernel-checked in `Main.lean`; geometric extraction,
the coefficient-lattice argument and the asymptotic bridge are
the proofs above. `statement_fidelity.md` names that boundary
explicitly. Independent review is pending.

## Reproduction and certification boundary

From the campaign root:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/inverse_certificate/verify.py
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/inverse_certificate/Main.lean --project-root . --claim C_INVERSE_FINITE --statement-fidelity research/inverse_certificate/statement_fidelity.md
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root .
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root .
```

The installed `lean_evidence verify` takes its source positionally;
it has no `--source` option. No project lakefile is introduced.
The host's prebuilt Mathlib workspace is used.

The Engineer exact replay reports 12,945,042 Cartesian box triples,
unaligned cell mass and energy both 4, a fixed-list bound of 32
for its finite height rectangle, and 5,058 finite-family regression
cases including empty and singleton degeneracies. The separate
CRT test produces slope counts 39 and 38 against the same
center-independent exact bound `14742363/2210`, including its
rounding term 6630. These measurements do not impose an
asymptotic lower threshold.

The scope ledger and graph checks both returned zero at the exact
campaign root
`campaigns/9000021`.
Final compiler and post-recording check results are persisted
beside this report. Host-invoked independent review, including
statement fidelity, the unformalized arguments, novelty and
publishable significance, is still required. There is no
Reviewer approval in this deliverable.

The official final run recorded compiler exit `0`, axiom-audit exit
`0`, and `proof_holes=[]` with Lean `4.31.0` in
`certificates/C_INVERSE_FINITE-6adf988d4cd052fa.json`.
Neither the source nor the fidelity document was subsequently
changed. `validation_result.json` records both campaign-local
checker exit statuses as `0` after that ledger write.

The upstream regular-box, upper-sieve, and PNT/Mertens inputs are
explicit source-only assumptions in the ledger. Their staged
statements were read; `citation_check status` reports them as
`uncited`, with no canonical-identifier lookup pending. This is
not independent literature certification of those inputs and
must not be read as verification of their global construction.
