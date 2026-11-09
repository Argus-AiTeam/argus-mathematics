# Exploratory negative report: exact counterexamples and asymptotic route exclusions

**Disposition:** ready for a Host-invoked independent project-level Reviewer
certification. This report is a campaign checkpoint, not a terminal solution
of `C1285`. Its strongest result is the independently reviewed asymptotic
counterfamily for
`LINEAR-EQUALITY-JACOBI-FEEDBACK-CRT-LOCAL-DAG`; the fixed-tuple SQUFOF result
below is an additional exact finite counterexample. Neither is a timeout,
numerical near-solution, general factoring lower bound, or proof that integer
factoring is impossible.

**Strongest reviewed outcome:** for every fixed polynomial resource tuple and
length-indexed advice sequence in the frozen mixed equality-and-Jacobi class
with `K(n)=floor(n/2400)` observations after its unique gcd gate, a canonical
infinite actual-length family has success probability at most `5/8+o(1)`,
hence eventually at most `31/48<2/3`. This is ledger claim
`C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-OBSTRUCTION` v1,
independently supported by
`judgement-C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-OBSTRUCTION-7ce619ba241a`.

**Additional exact outcome:** the fixed polynomial-time candidate
`AP-MULTIPLIER-SQUFOF(2,2,2,2)` does not factor every composite input. On the
preregistered balanced 127-bit semiprime

```text
N = 137647006619248520045310768944821494913
  = 9223372036854777119 * 14923718361271583327,
```

the complete frozen race receives only `N`, executes every prescribed
preprocessing, multiplier, and forward step, starts no reverse path because no
eligible square event exists, and returns `FAIL`.

**Campaign-wide boundary:** `C1285` remains open. This report does not construct
a general classical polynomial-time factoring algorithm, rule out the
existence of one, refute another exponent tuple, or exhaust multiplier-SQUFOF.
Project-level certification of this report therefore cannot close the original
factoring objective.

## Strongest reviewed theorem: mixed equality and Jacobi feedback

For an integer `N>=2`, put

```text
E_N = (N-1)!,
U_N = E_N / 2^v_2(E_N).
```

An eligible input is an odd composite non-perfect-power `N` and a unit `a`
modulo `N`. The controller receives only `n=bitlength(N)`, length-indexed
advice, and a fair random tape; it receives no residue representative, order,
or factor data. It executes the reviewed `SPARSE-RATIONAL-RING` prelude and an
arbitrary polynomial-size tagless CRT-local DAG with operations

```text
COPY, ADD, SUB, MUL, POW with 0<=e<2^B(n), and certified-unit INV,
```

where `B(n)` is polynomial.

It makes exactly one gate `gcd(G,N)`. `PROPER` returns the factor and
terminates. On `WHOLE` or `ONE`, it makes at most

```text
K(n) = floor(n/2400)
```

adaptive observations. Each observation is either the Jacobi symbol of a
currently certified unit or equality modulo `N` between two current DAG
values. Arbitrary polynomial-size tagless CRT-local work may occur before,
between, and after observations, and every later operation and the unique
terminal residue output may depend on the complete mixed transcript. Equality
does not create a unit certificate: neither `TRUE` nor `FALSE` authorizes
inversion of the difference. There is no second gcd, factor return after a
nonproper gate, nonunit Jacobi query, representative or modulus inspection,
order or factor access, cross-branch read, non-CRT-local value operation, or
second terminal output. This exact class is
`LINEAR-EQUALITY-JACOBI-FEEDBACK-CRT-LOCAL-DAG`.

**Theorem.** For every fixed polynomial resource tuple and every
length-indexed advice sequence in this class, there is a canonically determined
infinite sequence of actual eligible squarefree order-eight CRT inputs
`(N_h,a_h)`, effectively constructible relative to the finite advice at their
actual lengths, such that

```text
Pr[proper factor or exact odd-factorial target on (N_h,a_h)]
  <= 5/8 + o(1).
```

Consequently the probability is eventually at most `31/48`, strictly below
`2/3`, and no controller in the frozen class is universal.

### Exact transcript mass

Fix a nonproper gate branch and a mixed transcript prefix for `N=pq`. CRT
locality makes every next operand and terminal output a pair of independent
site functions. A certified-unit Jacobi observation has local signs
`ell(p),ell(q)` and branch indicator

```text
(1 + tau*ell(p)*ell(q))/2,
```

whose bounded rank-one tensor `L1` cost is one. For a global equality, let
`e(r)` indicate equality of its two operands in `F_r`. CRT injectivity gives
the exact identities

```text
TRUE  = e(p)e(q),
FALSE = 1-e(p)e(q).
```

Thus `TRUE` has tensor cost one and `FALSE` has cost at most two, including
both mixed zero-divisor patterns rather than treating them as units. A leaf
with `f` false-equality outcomes has cost at most `2^f`. If `T_d` is the
largest total leaf mass below a node with at most `d` observations remaining,
then

```text
T_0 = 1,
T_d <= 2*T_(d-1)                 at a Jacobi node,
T_d <= (1+2)*T_(d-1)             at an equality node.
```

Early leaves only reduce the sum, so every fully adaptive mixed tree satisfies

```text
sum_(terminal leaves) tensor_mass <= 3^K.
```

This is the full adaptive-tree bound, not a fixed-order or Jacobi-only
calculation.

### Type-II absorption and the `5/8` bound

The proof reuses the independently reviewed dense order-eight pool

```text
P_h = {p : 3*2^(h-2)<p<2^h, p=1 mod 8},
M_h = |P_h| = Theta(2^h/h),
```

the four-color odd-factorial law, cyclotomic prelude coupling, and the
arbitrary-weight Type-II estimate with error

```text
Delta_h =
  C*h^(3/4)*2^(2h-(floor(h/15)-5/2)/20).
```

Across both nonproper gate regions and all three nonprincipal characters, the
mixed adaptive tree contributes at most `6*3^K*Delta_h`. Every product of two
distinct pool primes has actual length `2h`, so
`K(2h)=floor(h/1200)`. The reviewed pool and discrepancy estimates give

```text
3^K*Delta_h/M_h^2
 <= O(h^(11/4)*2^(-h/600+O(1)))
 = o(1).
```

For one random tape, delete the uniformly polynomial number of ordinary
prelude bad sites and partition the remaining `g` sites into `Z`, where the
unique gate value vanishes, and `V`, where it does not; write
`z=|Z|`, `v=|V|`. The squarefree gate table makes exactly the `2zv` crossing
pairs proper. In each same-gate region, the principal term contributes at most
one quarter because one transcript leaf is consistent and the two local
terminal values share at most one target color. Hence good ordered successes
are at most

```text
2zv + (z^2+v^2)/4 + 6*3^K*Delta_h
  <= 5g^2/8 + 6*3^K*Delta_h.
```

After charging every pair meeting an ordinary bad site as successful,
dividing by `M_h(M_h-1)`, and averaging over tapes, the success probability is
`5/8+o(1)`. Choosing the least-success pair and breaking ties
lexicographically gives the canonical infinite actual-length counterfamily.
The finite random-tape space at each length makes this selection effective
relative to that length's advice.

The reused reviewed dependencies are exactly
`C1285-ODD-FACTORIAL-ONE-GATED-RECIPROCAL-MOD8-LAW`,
`C1285-ODD-FACTORIAL-ONE-GATED-RECIPROCAL-FOURIER`,
`C1285-ODD-FACTORIAL-ONE-GATED-RECIPROCAL-DENSE-POOL`,
`C1285-ODD-FACTORIAL-ONE-GATED-RECIPROCAL-CYCLOTOMIC-COUPLING`,
`C1285-ODD-FACTORIAL-ONE-FEEDBACK-CRT-LOCAL-DAG-LOCALITY`, and
`C1285-ODD-FACTORIAL-LINEAR-JACOBI-FEEDBACK-JACOBI-FACTORIZATION`.
This route adds no external assumption or citation.

### Exact claim and replay map

| Item | Exact role and evidence |
|---|---|
| Frozen universal candidate | `C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-CANDIDATE` v1 is refuted by independent record `judgement-C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-CANDIDATE-82a55d9294af`. |
| Asymptotic obstruction | `C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-OBSTRUCTION` v1 is supported by independent record `judgement-C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-OBSTRUCTION-7ce619ba241a`; the full proof and exact boundary are in `research/routes/input-specific-exponent/odd-factorial-linear-equality-jacobi-feedback/analysis.md`. |
| Rerunnable certificate | `research/routes/input-specific-exponent/odd-factorial-linear-equality-jacobi-feedback/certificate.json` freezes the typed grammar and mixed program. Its relative fixture reference is checked rather than copied. |
| Producer-independent replay | `research/routes/input-specific-exponent/odd-factorial-linear-equality-jacobi-feedback/verify.py` produces `verification.json`, whose summary has `ok=true`; the finite-replay claim is independently supported by `judgement-C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-FINITE-REPLAY-2caacaf0928d`. |

The exact replay checks eight certified 2400-bit sites and all 28 resulting
4800-bit pairs, including six `WHOLE`, sixteen `PROPER`, and six `ONE` pairs.
It checks both mixed observation orders, all four leaves on each nonproper
branch, 12 exact equality factorizations, 12 Jacobi factorizations, 144 tensor
terms, the concrete branch mass six and complete-tree bound nine, 20 illegal
programs, and 10 mutations. This certifies the finite semantics and evidence
binding; it is not substituted for the asymptotic pool and Type-II proof.

The theorem does **not** cover a second factor-producing gcd, a unit
certificate inferred from equality, a Jacobi zero branch on an uncertified
value, validity or representative-sensitive observations, uncontrolled-tensor
observations, a larger observation rate, `WIDTH2`, unrestricted rational
controllers, the broad odd-factorial evaluator, or general classical integer
factoring.

## Reviewed low-L1 asymptotic theorem

Fix any rational `alpha` with `0<alpha<1/86`. In the frozen
`LOW-L1-PRODUCT-DIFFERENCE-GCD(alpha)` class, each temporary adaptive call
obeys

```text
product_j ||P_j||_1^e_j + product_l ||Q_l||_1^f_l
  <= 2^floor(alpha*n),
```

where the factors are visible sparse numerators, multiplicities have
polynomial binary length, and neither product nor its difference is retained.
For every fixed polynomial resource tuple and every length-indexed advice
sequence in this class, there are an effective threshold and a canonical
infinite sequence of actual eligible order-`4ell` CRT inputs `(N_j,a_j)`.
For every sufficiently large `j`, define `G_j` to be the tapes that are
conductor-nonexceptional for the selected `ell_j` and whose every nonzero
generic-inventory norm avoids both selected CRT primes `p_j,q_j`. On `G_j`,
all reached denominators are units, all reached adaptive ordinary and
product-difference tags follow the generic transcript, and both
odd-factorial target residuals are avoided. With the exact bad-tape masses
from equations (22) and (26) of the proof,

```text
Success_j subseteq G_j^c,
Pr(G_j^c) <= delta_(ell_j)+w_(p_j)+w_(q_j).
```

No independence of the three bad events is assumed. Equation (30) therefore
gives, for every sufficiently large `j`,

```text
Pr[proper factor or odd-factorial target on (N_j,a_j)]
  <= 2^(-(1/86-alpha)*bitlength(N_j)).
```

The key compiler has three exact cases. An active zero factor short-circuits
its complete side. Otherwise every norm-one factor is a signed Laurent
monomial, so all of its polynomial-bit multiplicities aggregate into one
polynomial-bit exponent edge. Every remaining factor has norm at least two,
so the total non-unit multiplicity is at most `floor(alpha*n)`. The resulting
temporary difference is a polynomial-size Laurent ABP with at most
`2^floor(alpha*n)` paths and with the required exponent and height bounds.
The reviewed one-anchor argument then contributes
`poly(n)*2^(-(1/43-2alpha)n)`, while split-prime norm selection contributes
`poly(n)*2^(-2n/43)`; both polynomial factors are eventually absorbed into
the displayed exponent.

The exact evidence map is:

| Evidence | Role in the result |
|---|---|
| Independent review | The unchanged compiler and finite replay remain supported by `judgement-C1285-ODD-FACTORIAL-LOW-L1-PRODUCT-DIFFERENCE-GCD-COMPILER-840fa65b6f55` and `judgement-C1285-ODD-FACTORIAL-LOW-L1-PRODUCT-DIFFERENCE-GCD-FINITE-REPLAY-90ddbbb73d87`. The corrected good-event anchored transfer v3 and obstruction v2 are independently supported by `judgement-C1285-ODD-FACTORIAL-LOW-L1-PRODUCT-DIFFERENCE-GCD-ANCHORED-TRANSFER-2ab92e68bdee` and `judgement-C1285-ODD-FACTORIAL-LOW-L1-PRODUCT-DIFFERENCE-GCD-OBSTRUCTION-9fe93b2349ce`; the earlier v1 records remain historical only. |
| `research/routes/input-specific-exponent/odd-factorial-product-difference-gcd/low-l1-entropy/analysis.md` | Self-contained quantified theorem, exact compiler, adaptive transcript, conductor inventory, norm-selected CRT construction, target argument, exponential bound, and actual-length closure. This is the asymptotic evidence. |
| `research/routes/input-specific-exponent/odd-factorial-product-difference-gcd/low-l1-entropy/verification.json` | Producer-independent replay of the three compiler boundaries, two adaptive tags, denominator validity, target exclusion, exact factor reconstruction, and fourteen mutation rejections. This checks finite semantics; it is not substituted for the infinite-family proof. |

This is asymptotic rather than a finite search conclusion: the proof selects a
conductor and CRT pair from exact growing pools at each actual advice length,
then uses the tail `h_j=64^j` to obtain strictly increasing moduli. The replay
uses only `alpha=1/100`, nominal `n=600`, and the finite fixture `N=86701`;
its success cannot establish the theorem by itself. The endpoint `alpha=1/86`
is excluded, where the conductor decay vanishes. High-L1 compressed products,
retained products or differences, general sum-of-products circuits, the broad
odd-factorial evaluator, and general classical integer factoring remain open.

## Additional exact SQUFOF candidate refutation

The exact universal claim is ledger claim
`C1285-MULTIPLIER-SQUFOF-2222-CANDIDATE` v1:

> For every composite binary input, `AP-MULTIPLIER-SQUFOF(2,2,2,2)` returns a
> verified proper factor after its exact preprocessing, exhaustive odd
> square-free multiplier registry, and quadratic forward and reverse budgets.

The displayed `N` is composite, satisfies every input condition, and produces
`FAIL`. Therefore the universal claim is false by one exact counterexample.
This conclusion needs no infinite family. Conversely, one finite input says
nothing about any different exponent tuple or unrestricted integer factoring.

## Fidelity to `OBJECTIVE.md`

`OBJECTIVE.md` asks for a classical polynomial-time factoring algorithm or a
verifiable new structural algorithmic mechanism. That general objective remains
open. Under the independent counterexample-only campaign contract, the
effective exploratory target is instead to refute a precisely frozen candidate
class by an exact witness or asymptotic counterfamily with rerunnable evidence.
The mixed equality-and-Jacobi theorem meets that narrower target: it refutes the
universal `2/3` candidate for exactly
`LINEAR-EQUALITY-JACOBI-FEEDBACK-CRT-LOCAL-DAG`, and its producer-independent
4800-bit certificate checks the frozen semantics without standing in for the
asymptotic proof.

The fixed SQUFOF tuple is another concrete polynomial-time candidate: for
`n=bit_length(M)`, all four resource bounds are `n^2`, the multiplier registry
has polynomial size, every complete-quotient state has polynomial bit length,
and the frozen wrapper verifies every recursive factor tree. Its polynomial-bit
argument is stated in
`research/routes/structured-relations/multiplier-squfof/analysis.md` as
`C1285-MULTIPLIER-SQUFOF-POLYNOMIAL-CLASS` v1.

These two exclusions remove only their frozen candidates from the objective's
solution space; neither meets the broader objective itself. The general target
`C1285`, stronger feedback controllers, other SQUFOF exponent tuples, the
parent reduced-cycle-incidence problem, and other factoring mechanisms remain
open.

## Frozen source semantics

The source comparison is direct rather than inferred from the transcript:

| Semantic point | Frozen meaning | Primary or campaign evidence |
|---|---|---|
| Multiplier domain | A multiplier is an odd square-free product of small primes; the campaign exhausts every such `k<=n^2`. | Gower--Wagstaff Sections 5.2 and 5.4, archived in `research/literature/f57320806df849c7c6676efdcea59010.json` and quoted in `research/routes/structured-relations/multiplier-squfof/gower-wagstaff-multiplier-excerpt.txt`. |
| Discriminant normalization | Form `kN` first; use `D=2kN` when `kN=1 mod 4`, and `D=kN` otherwise. | Same source excerpt; frozen recurrence in `research/routes/structured-relations/multiplier-squfof/analysis.md`. |
| Reverse output | At source symmetry, normalize the reverse denominator as `Q/gcd(Q,2k)` before checking a factor of `N`. | Same source excerpt and frozen analysis. |
| Racing | Each multiplier starts from a fresh continued fraction; success is the first verified proper extraction. | Gower--Wagstaff Section 5.4 and the frozen analysis. |
| Campaign strengthenings | Deterministic primality handling, complete perfect-power detection, trial division, the exhaustive polynomial registry, processing every eligible event, exact forward and reverse budgets, recursive prime-leaf verification, and the absence of a fallback factorer are explicit campaign additions. | `research/routes/structured-relations/multiplier-squfof/analysis.md`; none is attributed to the historical paper. |

Thus the counterexample is to the explicitly defined strengthened algorithm,
not to an imprecise recollection of historical SQUFOF.

## Preregistered balanced witness

`research/routes/structured-relations/multiplier-squfof/balanced-full-race/preregistration.json`
fixed the candidate before either prime was materialized and before any SQUFOF
execution:

```text
p = least prime congruent to 3 mod 4 strictly above 2^63 + 1285,
q = least prime congruent to 3 mod 4 strictly above floor(987*p/610) + 1285.
```

The adjacent `candidate.json` materializes that rule. Its recursive
Lucas--Pratt tree proves both terminal values prime and records exact
compositeness witnesses for the six preceding `p` candidates and eleven
preceding `q` candidates. The standalone verifier checks all 31 Pratt nodes and
the progression minimality. It also checks

```text
p*q = N,                  bit_length(N) = 127,
bit_length(p) = 64,       bit_length(q) = 64,
p < q < 2*p,              610*q - 987*p = 813017.
```

Consequently `N` is an odd square-free composite, is not a perfect power, and
has two balanced prime factors. Both factors exceed the actual trial and
multiplier bound `127^2=16129`.

The algorithm-facing
`research/routes/structured-relations/multiplier-squfof/balanced-full-race/race-input.json`
is exactly

```json
{
  "N": 137647006619248520045310768944821494913,
  "algorithm": "AP-MULTIPLIER-SQUFOF(2,2,2,2)",
  "schema_version": 1
}
```

It contains neither factor nor candidate-construction metadata.

## Complete exact race

The immutable producer certificate and producer-independent replay establish
the following complete outcome:

| Quantity | Exact value |
|---|---:|
| Trial, multiplier, forward, and reverse bounds | `16129` each |
| Registry | all odd square-free `k<=16129` |
| Registered and executed multipliers | `6535` |
| Last registered multiplier | `16127` |
| `D=kN` normalizations | `3268` |
| `D=2kN` normalizations | `3267` |
| Forward transitions per multiplier | `16129` |
| Total completed forward transitions | `105403015` |
| Preprocessing splits | `0` |
| Nonunit multiplier gcds | `0` |
| Repeated states or repeated-state shortcuts | `0` |
| Eligible even-index square denominators | `0` |
| Reverse paths and reverse transitions | `0` |
| Global, mixed, or source-symmetry events | `0` |
| Unit, full, or proper extractions | `0` |
| Reverse-budget-incomplete paths | `0` |
| Algorithm result | `FAIL` |

The registry is reconstructed from its mathematical definition, not trusted
from a supplied list. Every one of the `6535` rows completed the full forward
budget. Therefore `FAIL` is the specified terminal algorithm result and is
independent of wall-clock timeout, a finite prefix, a stopped reverse path, or
a repeated-state shortcut. Since there was no eligible square event, no
reverse path existed to leave incomplete.

The certificate's transcript commitments detect disagreement, but they are not
the proof. `verify_certificate.py` imports no producer code: it independently
reconstructs the prime progressions, Pratt tree, registry, recurrence, event
tests, and all `105403015` transitions, then compares every row and commitment.
Its preserved output reports `independent_exact_replay=true`,
`race_result=FAIL`, zero event and budget-incomplete counts, and rejection of
mutations to the result, one commitment, one event count, and the multiplier
registry.

The additional exact scan of `29908` oriented factor-pair cases across the
`3268` theorem-applicable multipliers finds no balanced index-two hit. This is
a consistency check against the reviewed first-event theorem; the stronger
counterexample fact is the complete zero-event race at every index within the
frozen budget.

## Terminal claim-to-evidence map

| Ledger claim | Exact assertion used here | Rerunnable evidence |
|---|---|---|
| `C1285-MULTIPLIER-SQUFOF-SOURCE-SEMANTICS` v2 | Odd square-free multipliers, the `kN`/`2kN` branch, reverse normalization, and multiplier racing match the cited source. | `research/routes/structured-relations/multiplier-squfof/gower-wagstaff-multiplier-excerpt.txt`; `research/literature/f57320806df849c7c6676efdcea59010.json`; `research/routes/structured-relations/multiplier-squfof/analysis.md`. |
| `C1285-MULTIPLIER-SQUFOF-POLYNOMIAL-CLASS` v1 | Every fixed positive exponent tuple defines the exact polynomial-bit wrapper; at `(2,2,2,2)` all four bounds are `n^2`. | Definition and bit-cost proof in `research/routes/structured-relations/multiplier-squfof/analysis.md`. |
| `C1285-MULTIPLIER-SQUFOF-2222-BALANCED-COUNTEREXAMPLE` v1 | The displayed balanced semiprime survives preprocessing, exhausts the complete race with zero eligible events, and returns `FAIL`. | The immutable `preregistration.json`, `candidate.json`, `race-input.json`, `certificate.json`, `analysis.md`, and `evidence/verification.json` under `research/routes/structured-relations/multiplier-squfof/balanced-full-race/`; exact durable commands and zero exits are preserved beside them in `evidence/durable-run-status-v2.json` and `evidence/verification-run-status.json`. |
| `C1285-MULTIPLIER-SQUFOF-2222-CANDIDATE` v1 | The universal all-composite success claim is refuted by the preceding witness. | The same immutable witness and replay; refuting judgements and the retired route are recorded in `research/MATH_STATE.json`, while `research/PROOF_GRAPH.json` marks only `R-MULTIPLIER-SQUFOF-BALANCED-FULL-RACE-2222` ruled out. |

No claim in this terminal map depends on the first failed producer invocation,
run time, transcript hashes alone, or a bounded near-solution.

## Required fresh independent certification

The route-level reviews and producer-independent replays are evidence, not
substitutes for this mission's final project-level verdict. The Host-invoked
Reviewer must:

1. Compare the report's mixed-observation class and quantifiers with the
   frozen analysis and certificate, including the unique gate, certified-unit
   discipline, equality semantics, observation rate, adaptive dependence, and
   terminal-output restrictions.
2. Check the exact identities `TRUE=e(p)e(q)` and
   `FALSE=1-e(p)e(q)`, the branch tensor costs `1,1,2`, and the adaptive
   recurrence giving total mass at most `3^K`.
3. Check that the reused four-color Type-II theorem absorbs
   `6*3^K*Delta_h` at `K(2h)=floor(h/1200)`, and that the unique-gate
   partition gives `2zv+(z^2+v^2)/4<=5g^2/8`.
4. Rerun or independently replay the exact mixed certificate and confirm that
   `verification.json` has `ok=true`, while treating the 28 finite pairs as a
   semantics check rather than proof of the asymptotic theorem.
5. Confirm the objective mapping and outcome honesty: the theorem refutes only
   the frozen universal candidate and leaves stronger observations, larger
   rates, unrestricted controllers, the broad evaluator, and general factoring
   open.
6. Evaluate the complete report for goal achievement, statement fidelity,
   argument correctness, and outcome honesty, then return a fresh project-level
   `done` verdict or identify the exact failed claim or replay step.

## Prior reviewed route context

The additional SQUFOF tuple conclusion above does not depend on this historical
appendix. It is retained only to preserve the exact limits of earlier
independently reviewed route results.

The 2026-08-27 report was a checkpoint over four earlier route exclusions.
The preceding revision added five independently reviewed bodies of mathematics;
this revision preserves them and adds the later evidence bodies in the same
table:

| Area | New reviewed result | Exact limit |
|---|---|---|
| Critical-depth odd-factorial evaluator | Exact `Phi_4` stripping reduces exceptional conductors to a local multiplicity budget; a parameter-preserving depth-four reduction shows that Koiran--Skomra Conjecture 1.4 would supply the missing bound. | The unconditional jet bound and the critical-depth controller obstruction remain open. |
| Gaussian SIQS rough mirror | The frozen Gaussian composition has `v_2(N)=1` for every legal parameter choice, so mandatory even-input preprocessing returns factor `2`. | This excludes only the registered Gaussian composition, not the positive-sign rough mirror, general SIQS, or factoring. |
| Modulus-coefficient HECM samplers | Replacing a modulus leaf by zero preserves the complete modular transcript, including registered gcds and unit inverses; under the frozen polynomial inventory and Cosset-surface conditions, the reviewed low-degree obstruction transfers exactly. | Representative-sensitive integer operations, superpolynomial expanded inventories, later HECM, and general HECM are outside scope. |
| Representative-controlled HECM samplers | A finite exact witness proves that carry and borrow expose information lost by modular reduction. Record-by-record unrolling nevertheless puts every accepted output and registered factor path in the reviewed polynomial unions when there are polynomially many globally low-degree records. | Representative-derived integer data, exponentially many records, later HECM, general HECM, and factoring remain open. |
| Global collision energy and frozen two-mulhi postprocessors | For distinct comparable odd primes `r,s`, the exact global four-coordinate energy satisfies `G_(r,s)=O_rho(r^2*s^2*log(2s))`. Hence every nonzero total-degree `e<r` polynomial in `(X,Y,H1,H2)` has zero probability `O_rho(sqrt(e*log(2r)/r))`; the reviewed inventory, denominator/gcd trichotomies, and K3 dichotomy then exclude the frozen two-mulhi postprocessor class. | The stronger pointwise all-residue estimate remains open but is unnecessary. Factor-dependent coefficients, superpolynomial degree or inventory, unregistered factor paths, repeated-squaring circuits outside the globally low-degree class, unrestricted HECM, and factoring remain outside scope. |
| Multiplier-free arbitrary-precision SQUFOF | For every fixed positive rational `c,f,r`, an exact odd-Bonferroni construction gives infinitely many preprocessing-evasive composites `N=m^2+2`. The normalized complete quotients alternate forever between denominators `1` and `2`; every eligible event reverses in one step and normalizes to `1`, so failure is absolute rather than a budget timeout. | This excludes only multiplier-free `AP-SQUFOF(c,f,r)`. Multiplier racing, adaptive multipliers, fallback factorers, and general factoring remain open. |
| Factored sparse gcd batches | The local zero set of an unexpanded product is exactly the union of the active factor zero sets, independently of repeated factors or polynomial-bit multiplicities. The reviewed order-`4ell` construction therefore gives a canonical infinite actual-length family with total success at most `2^(-bitlength(N)/100)`. | Only oracle gcds on pure unexpanded products are excluded. Additive combinations of compressed products and retention of compressed products remain open. |
| Dyadic power-difference gcds | Refined primes `p=1+4ell mod 8ell` have `v_2(p-1)=2`, so every equality `P^(2^t)=Q^(2^t)` is the union of at most four sparse residual zero sets, including every zero branch. The common-length pools satisfy `2h+4<n_h<=44h`, and the canonical infinite family has total success at most `2^(-n_h/100)`. | This excludes only oracle powers whose full exponent `2^t` has a polynomial-length canonical encoding. Arbitrary product differences, retained succinct values, explicit width-two chains, and unrestricted rational circuits remain open. |
| Multiplier-SQUFOF subroutes | A registered multiplier-balanced first event is necessarily mixed and returns a prime after one reverse step. Separately, Reviewer refuted the proposed unbalanced mixed-class criterion by the exact `M=319` witness and left the uniform least-representative exclusion inconclusive. | The all-multiplier reduced-cycle obstruction and universal multiplier-SQUFOF candidate remain open. No finite scan or class-membership label settles later-cycle incidence. |
| Product-difference gcd frontier | Reviewer supported the exact local trichotomy, online bit cost, finite characteristic-split anchor, direct-norm limitation, and Kummer detector. Reviewer left the candidate, short-prime obligation, signature-entropy obligation, and canonical infinite obstruction inconclusive. | The exact finite split is diagnostic only. The parent product-difference route remains open; only direct norm counting, the present Kummer short-prime route, and raw signature pigeonhole are retired. |
| Low-L1 visible product differences | For every fixed rational `0<alpha<1/86`, every fixed polynomial resource tuple and advice sequence satisfying the frozen pathwise L1 promise has a canonical infinite actual-length order-`4ell` family. On the explicit event `G` that the tape is conductor-nonexceptional and avoids both selected-prime norm inventories, all reached denominators and tags synchronize and both targets are excluded; `Success subseteq G^c` and the union bound gives eventual success at most `2^(-(1/86-alpha)n)`. | The endpoint `alpha=1/86`, high-L1 compressed products, retained products or differences, broader compressed circuits, and general factoring remain open. |
| Depth-three direct quotient/remainder gcds | For either CRT factor `r`, exact floor-fiber counting gives `Pr(r divides H3 and H3>0)<8/r`, while `gcd(R3,N)=gcd(X*H2,N)`. The six-operand trial is below `16(1/p+1/q)`, hence below `24*2^{-(n-3)/2}` on the canonical exact-length balanced family, and every fixed polynomial adaptive schedule remains exponentially unlikely. | This covers only direct registered gcd tests on `H3,R3` with terminal formulas still confined to `(X,Y,H1,H2)`. Further nested quotients, representative formulas, nonuniform source laws, unrestricted HECM, and factoring remain open. |

The first five bodies contain the theorem, refutation, and
conditional-reduction claims described in the previous revision. They do not
merely rerun the certificates from the old report: the modulus-leaf theorem
extends the low-degree obstruction to a new adaptive syntax, and the
representative-control theorem crosses a genuine transcript-separation boundary
before recovering an obstruction by a different record-union argument. The
global-energy result is an unconditional asymptotic theorem obtained by an
exact collision count; its finite replay checks the identities and rejection
gates but is not used as asymptotic evidence.

The later bodies preserve the same distinction. The SQUFOF, factored,
dyadic, and depth-three exclusions rest on symbolic infinite-family arguments;
their finite replays are diagnostics. The balanced multiplier-SQUFOF theorem
retires one proposed hard-family ansatz but is not a general factoring
algorithm. The original unrestricted product-difference replay demonstrates a
real characteristic split but does not prove an infinite obstruction. The
later low-L1 theorem does prove one for exactly the displayed L1-bounded
subclass; the unrestricted parent route remains inconclusive.

## Exact post-checkpoint claim-to-evidence map

Every row below names the current claim, its independent Reviewer record when
one applies to the current version, and the exact artifact bound to that record
in `research/MATH_STATE.json`. The corrected low-L1 claim versions cite their
current independent judgements rather than inheriting the historical v1
records.

| Claim | Independently reviewed disposition | Exact mathematical scope | Bound proof and replay evidence |
|---|---|---|---|
| `C1285-ODD-FACTORIAL-SUCCINCT-CRITICAL-PHI4-REDUCTION` v1 | supported by `judgement-C1285-ODD-FACTORIAL-SUCCINCT-CRITICAL-PHI4-REDUCTION-ce42178816b0` | If `F=(Y^2+1)^sG` with maximal `s` and `Phi_(4ell)` divides `F`, then `ell^2` divides `Norm(G(i))`; conductors `ell>2^h` exceptional for `F` number at most `log_2(abs(Norm(G(i))))/(2h)`. | `research/routes/input-specific-exponent/odd-factorial-critical-depth-resultant/analysis.md`; `research/routes/input-specific-exponent/odd-factorial-critical-depth-resultant/evidence/certificate.json`; `research/routes/input-specific-exponent/odd-factorial-critical-depth-resultant/evidence/jacobian-payload.json`; `research/routes/input-specific-exponent/odd-factorial-critical-depth-resultant/evidence/jacobian-run.json` |
| `C1285-ODD-FACTORIAL-SUCCINCT-CRITICAL-SPS-EMBEDDING` v3 | supported by `judgement-C1285-ODD-FACTORIAL-SUCCINCT-CRITICAL-SPS-EMBEDDING-f828643d5dbf` | `f(X)` maps to `F(Y)=f(Y^4)` with `ord_i(F)=ord_1(f)` and critical-depth size preservation at the full binary-description scale; it does not preserve the degree-independent `kmt` parameter. | `research/routes/input-specific-exponent/odd-factorial-critical-depth-resultant/analysis.md`; the exact finite embedding is in `research/routes/input-specific-exponent/odd-factorial-critical-depth-resultant/evidence/certificate.json` |
| `C1285-ODD-FACTORIAL-SUCCINCT-CRITICAL-DEPTH4-REDUCTION` v3 | conditionally supported by `judgement-C1285-ODD-FACTORIAL-SUCCINCT-CRITICAL-DEPTH4-REDUCTION-49a9d21239c1` | Tavenas depth reduction gives an SPS expression with `k,m,t=2^o(n)`; Koiran--Skomra Conjecture 1.4 would then give `ord_i(F)=2^o(n)` and the missing stripped-jet bound. This is an implication from an unproved conjecture, not an unconditional obstruction. | `research/routes/input-specific-exponent/odd-factorial-critical-depth-resultant/analysis.md`; source records `research/literature/6cf6fb04277e170ba4a873a775ad0057.json` and `research/literature/6d15fd994b527bc992e94d53caa18252.json` |
| `C1285-ODD-FACTORIAL-SUCCINCT-CRITICAL-JET-BOUND` v1 | inconclusive in `judgement-C1285-ODD-FACTORIAL-SUCCINCT-CRITICAL-JET-BOUND-0a3186321753` | The required uniform `log_2(abs(Norm(G(i))))=2^o(n)` assertion is still open. | `research/routes/input-specific-exponent/odd-factorial-critical-depth-resultant/analysis.md` |
| `C1285-ODD-FACTORIAL-SUCCINCT-CRITICAL-OBSTRUCTION` v1 | inconclusive in `judgement-C1285-ODD-FACTORIAL-SUCCINCT-CRITICAL-OBSTRUCTION-9aa8fec6fb97` | No unconditional all-controller critical-depth obstruction or counterexample has been obtained. | `research/routes/input-specific-exponent/odd-factorial-critical-depth-resultant/analysis.md` |
| `C1285-SIQS-GAUSSIAN-NORM-PARITY` v1 | supported by `judgement-C1285-SIQS-GAUSSIAN-NORM-PARITY-e666601b5015` | For odd `A_1,A_2,t`, the exact Gaussian norm factorization has `v_2(N)=1` for every integer `z`. | `research/routes/structured-relations/siqs-large-prime/gaussian-rough-mirror/analysis.md`; `research/routes/structured-relations/siqs-large-prime/gaussian-rough-mirror/evidence/finite-algebraic-certificate.json` |
| `C1285-SIQS-GAUSSIAN-ROUGH-MIRROR-NO-GO` v1 | supported by `judgement-C1285-SIQS-GAUSSIAN-ROUGH-MIRROR-NO-GO-99fbacf0c1c2` | Every member of the frozen `(c,d,u,v)=(1,2,1/2,1/10)` Gaussian template is caught by mandatory even-input preprocessing, independently of later selector, Gray-placement, endpoint, gcd, or rank conditions. | `research/routes/structured-relations/siqs-large-prime/gaussian-rough-mirror/analysis.md`; `research/routes/structured-relations/siqs-large-prime/gaussian-rough-mirror/evidence/jacobian-inspect-multivariate-gcd.json`; `research/routes/structured-relations/siqs-large-prime/gaussian-rough-mirror/evidence/jacobian-multivariate-gcd-payload.json`; `research/routes/structured-relations/siqs-large-prime/gaussian-rough-mirror/evidence/jacobian-multivariate-gcd-output.json` |
| `C1285-SIQS-GAUSSIAN-ROUGH-MIRROR-FAMILY` v1 | refuted by `judgement-C1285-SIQS-GAUSSIAN-ROUGH-MIRROR-FAMILY-43fd6ca38a21` | The proposed frozen family cannot contain odd preprocessing-evasive hard inputs. | `research/routes/structured-relations/siqs-large-prime/gaussian-rough-mirror/analysis.md` |
| `C1285-HECM-MODULUS-COEFFICIENT-TRANSCRIPT-COLLAPSE` v1 | supported by `judgement-C1285-HECM-MODULUS-COEFFICIENT-TRANSCRIPT-COLLAPSE-8db578c3ebb4` | For every `N>=2` and seed pair in the frozen syntax, `N->0` preserves each arithmetic wire, equality and gcd tag, unit inverse, branch address, proper-factor return, and terminal output exactly. | `research/routes/input-specific-exponent/hecm-decomposable/modulus-coefficient-collapse/analysis.md`; `research/routes/input-specific-exponent/hecm-decomposable/modulus-coefficient-collapse/evidence/jacobian-normal-form-payload.json`; `research/routes/input-specific-exponent/hecm-decomposable/modulus-coefficient-collapse/evidence/jacobian-normal-form-output.json`; `research/routes/input-specific-exponent/hecm-decomposable/modulus-coefficient-collapse/evidence/jacobian-normal-form-verification.json` |
| `C1285-HECM-MODULUS-COEFFICIENT-OBSTRUCTION` v2 | supported by `judgement-C1285-HECM-MODULUS-COEFFICIENT-OBSTRUCTION-e802e0836fce` | For fully registered two-seed modulus-algebraic samplers whose accepted outputs lie on the cleared Cosset surface and whose specialized records and inventory have polynomial count, seed degree, and coefficient height, the reviewed canonical infinite hard-family, gcd, support, and comparison bounds transfer without loss. | `research/routes/input-specific-exponent/hecm-decomposable/modulus-coefficient-collapse/analysis.md`; the same three exact normal-form evidence files bound above |
| `C1285-HECM-REPRESENTATIVE-CONTROL-TRANSCRIPT-WITNESS` v1 | supported by `judgement-C1285-HECM-REPRESENTATIVE-CONTROL-TRANSCRIPT-WITNESS-bcb52f62970f` | At `N=5,X=4,Y=3`, pre-reduction carry/borrow gives `(1,1)` while reduce-then-inspect gives `(0,0)`, with the same modular wires `(2,4)`. This witnesses new control information, not a factor. | `research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/representative-control-certificate.json`; `research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/representative-control-verification.json` |
| `C1285-HECM-REPRESENTATIVE-CONTROL-RECORD-UNION` v1 | supported by `judgement-C1285-HECM-REPRESENTATIVE-CONTROL-RECORD-UNION-a3dfb0aa1fb5` | Branch-only carry, borrow, threshold, and Boolean control selects subsets of polynomially many fixed rational images and registered gcd zero sets; no polynomial or CRT-separable description of a selector locus is assumed. | `research/routes/input-specific-exponent/hecm-decomposable/representative-control/analysis.md` |
| `C1285-HECM-REPRESENTATIVE-CONTROL-OBSTRUCTION` v1 | supported by `judgement-C1285-HECM-REPRESENTATIVE-CONTROL-OBSTRUCTION-0f1c5c6ac2d8` | Under the complete-record, fixed-inventory, global low-degree, registration, and Cosset-surface conditions, there is a canonical infinite exact-length balanced semiprime family with exponentially small registered factor probability and the inherited support/comparison dichotomy. | `research/routes/input-specific-exponent/hecm-decomposable/representative-control/analysis.md`; `research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/jacobian-floor-sum-contract.json`; `research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/jacobian-floor-sum-payload.json`; `research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/jacobian-floor-sum-output.json`; `research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/representative-control-verification.json` |
| `C1285-HECM-TWO-MULHI-GLOBAL-COLLISION-ENERGY` v1 | supported by Engineer record `judgement-C1285-HECM-TWO-MULHI-GLOBAL-COLLISION-ENERGY-6340e92ed500` and independent Reviewer record `judgement-C1285-HECM-TWO-MULHI-GLOBAL-COLLISION-ENERGY-d12016c32f0d` | For distinct comparable odd primes `r,s`, `G_(r,s)=sum_(a,b,c,d) K_(a,b)(c,d)^2=O_rho(r^2*s^2*log(2s))`. The proof includes all nonzero lift differences, both coordinate axes, and the diagonal. | `research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/analysis.md`; diagnostic-only exact replay `research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/verification.json`; rejection transcript `research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/rejection.txt` |
| `C1285-HECM-TWO-MULHI-DIRECT-FOUR-VARIABLE-INCIDENCE` v1 | supported by Engineer record `judgement-C1285-HECM-TWO-MULHI-DIRECT-FOUR-VARIABLE-INCIDENCE-1b2cf5efe2d1` and independent Reviewer record `judgement-C1285-HECM-TWO-MULHI-DIRECT-FOUR-VARIABLE-INCIDENCE-ca0f6acbc9d2` | For every nonzero `F in F_r[A,B,C,D]` of total degree `e<r`, Schwartz--Zippel and Cauchy--Schwarz applied to the global energy give `Pr(F=0)=O_rho(sqrt(e*log(2r)/r))`. For `F=C^2-BD-A`, this also supplies the required fixed-power moving-inverse discrepancy saving. | `research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/analysis.md`; the finite zero-set and Cauchy checks are in `research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/verification.json` |
| `C1285-HECM-TWO-MULHI-DIRECT-INCIDENCE-PROPAGATION` v1 | supported by Engineer record `judgement-C1285-HECM-TWO-MULHI-DIRECT-INCIDENCE-PROPAGATION-b49478e944a3` and independent Reviewer record `judgement-C1285-HECM-TWO-MULHI-DIRECT-INCIDENCE-PROPAGATION-278baeab8f46` | The four-variable zero-set bound propagates through the reviewed canonical content-avoiding exact-length prime family, complete registered inventory, denominator and gcd trichotomies, and K3 identity/proper-residual dichotomy. | `research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/analysis.md` |
| `C1285-HECM-TWO-MULHI-POSTPROCESSOR-OBSTRUCTION` v1 | supported by Engineer record `judgement-C1285-HECM-TWO-MULHI-POSTPROCESSOR-OBSTRUCTION-0333a9b6bd12` and independent Reviewer record `judgement-C1285-HECM-TWO-MULHI-POSTPROCESSOR-OBSTRUCTION-7ca4ad27efff` | Every frozen two-corrected-mulhi sampler sequence with polynomially many factor-blind globally low-degree rational records in `(X,Y,H1,H2)`, a complete registered gcd and denominator inventory, and accepted outputs on the cleared Cosset surface has a canonical infinite exact-length separated balanced-semiprime family with exponentially small registered proper-gcd probability and no inverse-polynomial admissible full-surface mass. | `research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/analysis.md`; independent public review event `hecm_two_mulhi_global_energy_review` in `activity.jsonl` |

### Evidence added after the preceding report revision

Each row below gives the current claim versions, the exact independent
judgments bound to them, the mathematical conclusion that survives review, and
the preserved evidence. A finite replay is never substituted for the stated
infinite-family proof. A path abbreviated as `evidence/...`, `jacobian/...`,
`certificate.json`, or `anchors.json` is relative to the full proof directory
named earlier in the same table cell.

| Evidence body | Current claims and independent Reviewer verdicts | Exact reviewed conclusion | Proof, replay, and unresolved boundary |
|---|---|---|---|
| Linear equality and Jacobi feedback | `C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-OBSTRUCTION` v1 is supported by `judgement-C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-OBSTRUCTION-7ce619ba241a`; the universal candidate v1 is refuted by `judgement-C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-CANDIDATE-82a55d9294af`; the finite replay v1 is supported by `judgement-C1285-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK-FINITE-REPLAY-2caacaf0928d`. | For every fixed resource tuple and advice sequence in the exact one-gate class with at most `K(n)=floor(n/2400)` adaptive certified-unit Jacobi or global residue-equality observations, a canonical infinite actual-length order-eight CRT family has total success at most `5/8+o(1)`, eventually at most `31/48<2/3`. | Proof: `research/routes/input-specific-exponent/odd-factorial-linear-equality-jacobi-feedback/analysis.md`; frozen grammar and mixed program: `certificate.json`; producer-independent exact summary with `ok=true`: `verification.json` in that directory. The 28-pair replay certifies semantics only. A second factor-producing gate, equality-derived unit certificates, uncontrolled-tensor observations, larger rates, unrestricted controllers, and general factoring remain open. |
| Multiplier-free SQUFOF | `C1285-SQUFOF-SOURCE-SEMANTICS` v2 supported by `judgement-C1285-SQUFOF-SOURCE-SEMANTICS-65dc957c0e5d`; `C1285-SQUFOF-POLYNOMIAL-CLASS` v2 by `judgement-C1285-SQUFOF-POLYNOMIAL-CLASS-db422d1880c2`; `C1285-SQUFOF-ROUGH-FAMILY` v1 by `judgement-C1285-SQUFOF-ROUGH-FAMILY-c0621f0c7c3d`; `C1285-SQUFOF-PERIOD-TWO-OBSTRUCTION` v1 by `judgement-C1285-SQUFOF-PERIOD-TWO-OBSTRUCTION-1fdae5f7afee`; `C1285-SQUFOF-ANCHOR` v1 by `judgement-C1285-SQUFOF-ANCHOR-9b87d037672a`; `C1285-SQUFOF-UNIVERSAL-CANDIDATE` v1 refuted by `judgement-C1285-SQUFOF-UNIVERSAL-CANDIDATE-56e116c031d7`. | For every fixed `c,f,r`, infinitely many composite, non-perfect-power `N=m^2+2` have no prime divisor through `ceil(bitlength(N)^c)`. Their exact normalized forward cycle alternates `(2,m,1)` and `(1,m,2)` forever, and every eligible `Q=1` event normalizes the reverse output to `1`. This is deterministic absolute failure for the frozen class, not a finite-budget non-witness. | Proof: `research/routes/structured-relations/squfof/analysis.md`. Raw anchor and replay: `research/routes/structured-relations/squfof/certificate.json` and `research/routes/structured-relations/squfof/evidence/verification.json`. Typed bounded continued-fraction record: `research/routes/structured-relations/squfof/evidence/jacobian-find.json`, `jacobian-inspect.json`, `jacobian-payload.json`, and `jacobian-output.json`. The source proposition is independently attributed by `citation-A-GOWER-WAGSTAFF-SQUFOF-ALGORITHM-2e96cab6628f`. Multipliers and fallback factorers are outside the claim. |
| Factored sparse gcd | `C1285-ODD-FACTORIAL-FACTORED-SPARSE-GCD-ZERO-SET` v1 supported by `judgement-C1285-ODD-FACTORIAL-FACTORED-SPARSE-GCD-ZERO-SET-025133eb7188`; bit cost v1 by `judgement-C1285-ODD-FACTORIAL-FACTORED-SPARSE-GCD-BIT-COST-c37bb5f2be88`; obstruction v1 by `judgement-C1285-ODD-FACTORIAL-FACTORED-SPARSE-GCD-OBSTRUCTION-0427b1baeead`; candidate v1 refuted by `judgement-C1285-ODD-FACTORIAL-FACTORED-SPARSE-GCD-CANDIDATE-f06510285d4a`. | Reusing `C1285-ODD-FACTORIAL-SPARSE-RATIONAL-OBSTRUCTION` and its independent record `judgement-C1285-ODD-FACTORIAL-SPARSE-RATIONAL-OBSTRUCTION-8fbc4917e790`, every fixed controller admits canonical pools with `ell in (2^h,2^(h+1)]`, `card(S_h)=Omega(2^h/h^2)`, `card(P_ell)=Omega(ell^3/h)`, and `2h+4<n_h<=43h`. Individual-factor norm avoidance gives success at most `2^(-n_h/100)` after an effective threshold, regardless of polynomially many occurrences, repeated factors, adaptive splitting, or polynomial-bit multiplicities. | Proof: `research/routes/input-specific-exponent/odd-factorial-factored-sparse-gcd/analysis.md`. Raw anchor and independent replay: `evidence/certificate.json` and `evidence/verification.json` under that directory. The typed resultant files are `evidence/jacobian-discovery.json`, `jacobian-contract.json`, `jacobian-payload.json`, and `jacobian-run.json`; `jacobian-run-invalid.json` preserves the structured rejected payload. Additive compressed operands and retained products are not covered. |
| Dyadic power-difference gcd | `C1285-ODD-FACTORIAL-DYADIC-POWER-DIFFERENCE-GCD-REFINED-POOL` v3 supported by `judgement-C1285-ODD-FACTORIAL-DYADIC-POWER-DIFFERENCE-GCD-REFINED-POOL-fbfe1c1bc42f`; four-root coupling v1 by `judgement-C1285-ODD-FACTORIAL-DYADIC-POWER-DIFFERENCE-GCD-FOUR-ROOT-COUPLING-00e2cf27c0fb`; bit cost v1 by `judgement-C1285-ODD-FACTORIAL-DYADIC-POWER-DIFFERENCE-GCD-BIT-COST-84fa2802e3a8`; obstruction v1 by `judgement-C1285-ODD-FACTORIAL-DYADIC-POWER-DIFFERENCE-GCD-OBSTRUCTION-b881d885828f`; anchor v1 by `judgement-C1285-ODD-FACTORIAL-DYADIC-POWER-DIFFERENCE-GCD-ANCHOR-f82f34226449`; candidate v1 refuted by `judgement-C1285-ODD-FACTORIAL-DYADIC-POWER-DIFFERENCE-GCD-CANDIDATE-32d750ac06af`. | The refined pools have `card(S_h)=Omega(2^h/h^2)`, `card(P_ell)=Omega(ell^3/h)`, `2h+4<n_h<=44h`, and exact local 2-primary order four. For `t=0,1,>=2`, every local equality is covered by one, two, or four sparse residuals. Tape-weighted norm avoidance gives a canonical infinite actual-length family with total success at most `2^(-n_h/100)`. | Proof: `research/routes/input-specific-exponent/odd-factorial-dyadic-power-difference-gcd/analysis.md`; anchor and replay: `evidence/certificate.json` and `evidence/verification.json`. Typed finite-field table: `evidence/jacobian-discovery.json`, `jacobian-contract.json`, `jacobian-payload.json`, and `jacobian-output.json`. The two reused source statements are independently attributed by `citation-A-DYADIC-PNT-EXPLICIT-bac88f69bcfd` and `citation-A-DYADIC-XYLOURIS-EFFECTIVE-LINNIK-9f8d88768a31`, archived at `research/literature/85766a7f06b782535907da7c45fc2437.json` and `research/literature/7aec3825efd984558a78a481804087bd.json`. Arbitrary product differences and retained compressed values are outside the claim. |
| Multiplier-balanced first event | `C1285-MULTIPLIER-SQUFOF-BALANCED-FIRST-EVENT` v1 supported by `judgement-C1285-MULTIPLIER-SQUFOF-BALANCED-FIRST-EVENT-f8f917a9c919`; its `k=1` corollary `C1285-MULTIPLIER-SQUFOF-NEAR-SQUARE-MIXED-EVENT` v1 supported by `judgement-C1285-MULTIPLIER-SQUFOF-NEAR-SQUARE-MIXED-EVENT-4548dc226967`. | If a registered `k=xy` pairs the scaled prime factors as `U<V`, with `A=(U+V)/2`, `s=(V-U)/2`, and `s^2<A`, then the actual normalized principal cycle has the mixed square `Q_2=s^2`. Its reverse cycle reaches symmetry in one step, and `Q/gcd(Q,2k)` is the prime attached to `U`. This disproves the proposed all-global balanced first-event ansatz; it does not factor arbitrary inputs. | Proof: `research/routes/structured-relations/multiplier-squfof/reduced-cycle-incidence/analysis.md`; exact `M=481,k=3` anchor and replay: `certificate.json` and `evidence/verification.json` in that directory; typed continued-fraction record: `evidence/jacobian-find.json`, `jacobian-inspect.json`, `jacobian-payload.json`, and `jacobian-output.json`. Unbalanced and later-cycle incidence remains open. |
| Unbalanced multiplier-SQUFOF attempt | `C1285-MULTIPLIER-SQUFOF-UNBALANCED-MIXED-ORBIT-CRITERION` v1 refuted by `judgement-C1285-MULTIPLIER-SQUFOF-UNBALANCED-MIXED-ORBIT-CRITERION-844eebc40974`; `C1285-MULTIPLIER-SQUFOF-UNIFORM-LEAST-REPRESENTATIVE-EXCLUSION` v1 inconclusive in `judgement-C1285-MULTIPLIER-SQUFOF-UNIFORM-LEAST-REPRESENTATIVE-EXCLUSION-772c85292143`. | The exact Reviewer witness is `M=319=11*29`, `k=1`, `D=319`, with the mixed class `h=11` containing `j=(3,11+sqrt(319))` and `3^4<319`. Its square corresponds to the principal-cycle event `[9,22,-22]` with `15628^2-319*875^2=9`, but the two extraction gcds are `1` and `319` and the normalized reverse output is `1`. Thus small norm plus mixed class membership does not determine mixed event orientation. | The proposed argument is in `research/routes/structured-relations/multiplier-squfof/unbalanced-reduction/analysis.md`; the refuting independent verdict is preserved by public event `unbalanced_orientation_criterion_refuted` in `activity.jsonl` and the reviewed handoff `/home/argustest/zimo/.argus-campaign-1285-run9/projects/3bd9cfd8d78d/handoffs/ac2a4e32f633/round-0001.json`. The 8,015-input scan and the typed Pell call are finite diagnostics only. The parent reduced-cycle obstruction and universal candidate have no independent supporting verdict and remain open. |
| Product-difference gcd | Local semantics v1 supported by `judgement-C1285-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-LOCAL-SEMANTICS-5ef0e1fa1136`; bit cost v1 by `judgement-C1285-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-BIT-COST-bb28e361bad5`; semantic anchor v1 by `judgement-C1285-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-SEMANTIC-ANCHOR-6980e7c14c3c`; direct-norm limitation v1 by `judgement-C1285-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-DIRECT-NORM-LIMIT-377531fcdaeb`; Kummer detector v1 by `judgement-C1285-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-KUMMER-DETECTOR-6698236360f4`. Candidate v1 is inconclusive in `judgement-C1285-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-CANDIDATE-019877214c51`; short-prime obligation v1 in `judgement-C1285-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-SHORT-PRIME-OBLIGATION-6b99f95a427d`; signature-entropy obligation v1 in `judgement-C1285-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-SIGNATURE-ENTROPY-OBLIGATION-7e490d45a8c5`; obstruction v1 in `judgement-C1285-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-OBSTRUCTION-1bd01333dbb4`. | Over each CRT field, both products vanish together, exactly one vanishes, or all active factors reduce equality to one compact multiplicative relation. The exact anchor `N=96673=277*349` has `ord_277(2)=92` and `ord_349(2)=348`, so `2^92-1` and `2^348-1` expose opposite factors despite nonzero individual factors. This refutes the mechanical extension of individual-factor norm avoidance, but it is only a finite semantic witness. No canonical infinite actual-length family, all-controller bound, or escaping controller is proved. | Proof and explicit blocker: `research/routes/input-specific-exponent/odd-factorial-product-difference-gcd/analysis.md`; anchor and replay: `evidence/certificate.json` and `evidence/verification.json`; typed multiplicative-order record: `evidence/jacobian-discovery.json`, `jacobian-contract.json`, `jacobian-payload.json`, and `jacobian-output.json`. Direct norm counting, the present Kummer short-prime argument, and raw transcript pigeonhole are retired; the parent route remains open. |
| Low-L1 visible product-difference gcd | Compiler v1 remains supported by independent Reviewer record `judgement-C1285-ODD-FACTORIAL-LOW-L1-PRODUCT-DIFFERENCE-GCD-COMPILER-840fa65b6f55`, and finite replay v1 by `judgement-C1285-ODD-FACTORIAL-LOW-L1-PRODUCT-DIFFERENCE-GCD-FINITE-REPLAY-90ddbbb73d87`. The corrected good-event anchored transfer v3 and obstruction v2 are independently supported by `judgement-C1285-ODD-FACTORIAL-LOW-L1-PRODUCT-DIFFERENCE-GCD-ANCHORED-TRANSFER-2ab92e68bdee` and `judgement-C1285-ODD-FACTORIAL-LOW-L1-PRODUCT-DIFFERENCE-GCD-OBSTRUCTION-9fe93b2349ce`; their v1 records remain historical. | For every fixed rational `0<alpha<1/86`, every fixed polynomial resource tuple, and every advice sequence satisfying the pathwise bound, there is a canonical infinite actual-length eligible order-`4ell` family. On `G`, defined by conductor nonexceptionality and avoidance of every selected-prime inventory norm, every reached denominator and adaptive tag is controlled and both targets are avoided. Thus `Success subseteq G^c`, while `Pr(G^c)<=delta_ell+w_p+w_q` yields total success eventually at most `2^(-(1/86-alpha)*bitlength(N))`. | Proof: `research/routes/input-specific-exponent/odd-factorial-product-difference-gcd/low-l1-entropy/analysis.md`. Producer-independent finite replay: `research/routes/input-specific-exponent/odd-factorial-product-difference-gcd/low-l1-entropy/verification.json`. The replay checks compiler semantics only; the infinite theorem is the proof. The endpoint, high-L1 or retained compressed products, broader circuits, and general factoring remain open. |
| Depth-three direct gcd | `C1285-HECM-THREE-MULHI-H3-LOCAL-COUNT` v1 supported by `judgement-C1285-HECM-THREE-MULHI-H3-LOCAL-COUNT-0255a07b1c3c`; `C1285-HECM-THREE-MULHI-R3-COLLAPSE` v1 by `judgement-C1285-HECM-THREE-MULHI-R3-COLLAPSE-3a292ff564c5`; `C1285-HECM-THREE-MULHI-DIRECT-GCD-OBSTRUCTION` v1 by `judgement-C1285-HECM-THREE-MULHI-DIRECT-GCD-OBSTRUCTION-f6847ea9d18d`; bounded candidate v1 refuted by `judgement-C1285-HECM-THREE-MULHI-DIRECT-GCD-CANDIDATE-13568055e6c9`. | For fixed `X=x`, every threefold floor fiber has size below `(2N/x)^3`, while `H3<x^3/N^2`; hence `Pr(r divides H3 and H3>0)<8/r`. The remainder identity adds no new first factor after inherited tests. On the canonical odd lengths `n=2m+3`, with `p_n in [(3/4)2^m,(7/8)2^m]`, `q_n in [6*2^m,7*2^m]`, and `48/7<q_n/p_n<28/3`, the direct trial is below `24*2^{-(n-3)/2}` and every fixed polynomial adaptive schedule has success `2^{-Omega(n)}`. | Proof: `research/routes/input-specific-exponent/hecm-decomposable/three-mulhi-direct-gcd/analysis.md`; source-free anchors and replay: `anchors.json` and `verification.json`; typed floor-sum record: `jacobian/discovery.json`, `contract.json`, `payload.json`, and `output.json`. The replay's 27,603 pairs are diagnostic; the asymptotic theorem is the exact floor-fiber proof. `H3,R3` in terminal formulas, deeper quotients, nonuniform source laws, and unrestricted HECM remain outside scope. |

The ledger also retires
`R-MULTIPLIER-SQUFOF-PERIOD-TWO-LIFT` and
`R-MULTIPLIER-SQUFOF-GENUS-ONLY-ORIENTATION`, but their supporting claim
records currently carry only Engineer judgments. They are preserved as route
metadata and are not promoted here to independently reviewed mathematical
conclusions. The independently reportable multiplier-SQUFOF conclusions are
exactly the balanced theorem, its near-square corollary, the Reviewer
counterexample to the unbalanced criterion, and the inconclusive uniform
exclusion stated above.

The critical-depth conditional row stands on the independently attributed
primary-source records
`citation-A-TAVENAS-DEPTH4-14db2c465332` and
`citation-A-KOIRAN-SKOMRA-TAU-MULTIPLICITIES-033a5c56fb5b`.
The conjecture remains an undischarged mathematical premise.

The modulus-coefficient, representative-control, and frozen two-mulhi
obstruction rows reuse, without revision, the independently reviewed
low-degree premises
`judgement-C1285-HECM-SURFACE-K3-18f42937e88e`,
`judgement-C1285-HECM-FULL-SURFACE-SIZE-f992830f5515`,
`judgement-C1285-HECM-LOW-DEGREE-SEPARABILITY-ce44d3b0d3e0`,
`judgement-C1285-HECM-LOW-DEGREE-PRIME-FAMILY-06a5ad5e1401`,
`judgement-C1285-HECM-LOW-DEGREE-SUPPORT-76b3acbec032`,
`judgement-C1285-HECM-LOW-DEGREE-GCD-53facb7ca90e`, and
`judgement-C1285-HECM-LOW-DEGREE-PORTFOLIO-OBSTRUCTION-8c4dacf0acaf`.
Their bound artifacts are
`research/routes/input-specific-exponent/hecm-decomposable/evidence/surface-birational-certificate.json`,
`research/routes/input-specific-exponent/hecm-decomposable/full_surface.md`,
`research/routes/input-specific-exponent/hecm-decomposable/birational_obstruction.md`,
and
`research/routes/input-specific-exponent/hecm-decomposable/low-degree-portfolio/low_degree_portfolio.md`.

The first four bodies in the preceding-revision subset used the bounded
Jacobian operations
`polynomial.compute.resultant`,
`polynomial.multivariate.gcd.compute`,
`polynomial.ideal.normal_form.compute`, and
`integer.counting.floor_sum.compute`. Their preserved typed outputs report
Jacobian `0.14.0`, protocol `2025-11-25`, and no adapter error or timeout.
For the global-energy body, the nearest typed candidate,
`finite_field.polynomial_map.table.compute`, rejected the exact degree-one
field payload with structured code `INVALID_REQUEST`; its discovery, contract,
payload, and typed error are preserved under
`research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/jacobian/`.
That rejected call supplies no mathematical evidence.

## Earlier checkpoint claim-to-evidence map

Reviewer handoffs in this table are the independent
`reviewer:copilot-cli-l2-1285` judgment or literature-evidence records in
`research/MATH_STATE.json`. A `show` check means the pinned command documented
under [Reproducibility](#reproducibility); it checks the exact claim version,
evidence binding, and review disposition, not the truth of the prose proof.

| Claim or route | Reviewed conclusion and exact theorem scope | Proof or source artifact | Independent review handoff | Rerunnable certificate or check |
|---|---|---|---|---|
| `C1285-BASELINE` | The 2026-08-27 audit reports that no general classical polynomial-time factoring algorithm is known, that the number field sieve is the listed fastest known general classical method with heuristic subexponential complexity, and that Shor's polynomial-time algorithm is quantum and excluded. This is only a dated state-of-knowledge claim. | `../../../status-evidence/1285/README.md`; archived records under `research/literature/` | `citation-A-COMPLEXITY-GARDEN-4468d8580366`, `citation-A-SCHULZ-TELHA-2024-9f9b2c3f145e`, `citation-A-BANSIMBA-BABINDAMANA-2025-8c70755251b8` | `show(C1285-BASELINE)` and inspection of the three cited literature records |
| `C1285-EXP-REDUCTION` in `R-INPUT-SPECIFIC-EXPONENT` | Given an `n`-bit `N` and a supplied positive even `b`-bit integer `E` with `lambda(N)` dividing `E`, the specified uniform classical randomized algorithm returns the complete prime-power factorization in expected `poly(n,b)` bit operations. Perfect-power recognition handles prime powers. The theorem does **not** construct `E` from `N`. | `research/routes/input-specific-exponent/analysis.md` | `judgement-C1285-EXP-REDUCTION-7dcc785736a2`; AKS citation review `citation-A-AKS-PRIMALITY-c3fc88338ae8`; construction remains inconclusive in `judgement-C1285-EXP-CONSTRUCTION-965718f7c68c` | `show(C1285-EXP-REDUCTION)` and `show(C1285-EXP-CONSTRUCTION)`; the artifact gives the algorithm, exact split probability, recursion, verification, and bit-cost proof |
| `R-LENGTH-UNIVERSAL-EXPONENT` | For every `n >= 5`, any explicit positive binary integer annihilating every unit modulo every `n`-bit modulus has at least `2^floor((n-1)/2)` bits. Hence no polynomial-bit exponent depending only on input length belongs to the registered family. This does not address an exponent depending on the particular `N` or a succinct representation. | `research/routes/length-universal-exponent/obstruction.md` | Candidate refuted by `judgement-C1285-LENGTH-EXP-CANDIDATE-ec1797bdd868`; obstruction supported by `judgement-C1285-LENGTH-EXP-OBSTRUCTION-f4cfa6502736` | `show(C1285-LENGTH-EXP-CANDIDATE)` and `show(C1285-LENGTH-EXP-OBSTRUCTION)`; the artifact is a self-contained exact lifting, Carmichael-exponent, lcm-divisibility, and lcm-size certificate |
| Generic-bound attempt within `R-AFFINE-SINGLE-CENTER-LATTICE` | For the stated standard affine Coppersmith/Howgrave-Graham basis, its exact determinant, the generic LLL norm bound, and integer lifting optimize to the sufficient radius `N^(beta^2-epsilon)`. With the center `floor(sqrt(N))` and `beta=1/2`, this certifies only a sharply near-square regime, not unrestricted constant-ratio balanced semiprimes. Failure of this sufficient inequality does not prove that the lattice has no exceptional useful vector. | `research/routes/affine-lattice/analysis.md`; bounded determinant cross-check in `research/routes/affine-lattice/jacobian_evidence.json` | Barrier supported by `judgement-C1285-LATTICE-AFFINE-BARRIER-0b03eb8edab9`; affine candidate and general lattice remain inconclusive in `judgement-C1285-LATTICE-AFFINE-CANDIDATE-3f3d77700ff8` and `judgement-C1285-LATTICE-GENERAL-7ff0c5cf3f5f` | `show(C1285-LATTICE-AFFINE-BARRIER)`, `show(C1285-LATTICE-AFFINE-CANDIDATE)`, and `show(C1285-LATTICE-GENERAL)`; the Jacobian record preserves operation `matrix.symbolic.determinant.compute`, its exact payload, typed `N*X` output, and status for the bounded `m=1,t=1` check only |
| `R-RANDOM-SMOOTH-RELATIONS` | For every fixed `c,d>0`, with `delta=min(1/2,1/(2c))`, every `B(n)<=n^c`, and every `m(n)<=n^d`, the frozen family of independent uniform square samples, initial nonunit gcds, exact smoothness filtering, parity dependencies, and congruence-of-squares gcds has success probability below `n^d(2^(2-n/2)+4*2^(-delta(n-1)/2))` on every sufficiently large member of the explicit consecutive-prime balanced-semiprime family. It therefore vanishes exponentially, and polynomial restart cannot repair the yield. Structured or nonuniform relation generation is outside scope. | `research/routes/random-smooth-relations/analysis.md` | Candidate refuted by `judgement-C1285-RANDOM-SMOOTH-CANDIDATE-7bb4ad65bca9`; obstruction supported by `judgement-C1285-RANDOM-SMOOTH-OBSTRUCTION-713d30f76e85`; family and Bertrand source supported by `judgement-C1285-BALANCED-SEMIPRIME-FAMILY-3250e59208c6` and `citation-A-ERDOS-BERTRAND-1932-7250b76f816c` | `show(C1285-RANDOM-SMOOTH-CANDIDATE)`, `show(C1285-RANDOM-SMOOTH-OBSTRUCTION)`, and `show(C1285-BALANCED-SEMIPRIME-FAMILY)`; the exact probability bounds and self-contained Rankin bound are in the artifact |
| `R-DIRECT-SQUARE-COLLISION` | For every fixed `d>0`, every `m(n)<=n^d`, and every `N=pq` with distinct odd primes `p<q<2p`, the frozen family has success probability at most `m(p+q-2)/N + m(m-1)phi(N)/N^2`; on the explicit balanced family this is below `n^d*2^(2-n/2)+n^(2d)*2^(1-n)`. Thus success vanishes exponentially and polynomial restart has superpolynomial expected cost. Adaptive, structured, or smoothness-assisted samples are outside scope. | `research/routes/direct-square-collision/analysis.md` | Candidate refuted by `judgement-C1285-DIRECT-COLLISION-CANDIDATE-3ae4c4cefd26`; obstruction supported by `judgement-C1285-DIRECT-COLLISION-OBSTRUCTION-b69f0f3fa216` | `show(C1285-DIRECT-COLLISION-CANDIDATE)` and `show(C1285-DIRECT-COLLISION-OBSTRUCTION)`; the artifact gives exact nonunit counts, exact useful-collision counts, the union bound, restart bound, and bit costs |
| `C1285-STRUCTURED-NOWRAP-BARRIER` | For unit samples congruent to `+/-a_i` with visible `B`-smooth integer squares `a_i^2<N`, every exponent-parity vector is already zero and every product relation has one global sign. The two gcds are therefore `1` and `N`. This rules out only visible no-wrap smooth squares, not arbitrary structured relations. | `research/routes/structured-relations/analysis.md` | `judgement-C1285-STRUCTURED-NOWRAP-BARRIER-2859abacda4a`; the broad candidate is inconclusive in `judgement-C1285-STRUCTURED-RELATION-CANDIDATE-60e05a0d0bf4` | `show(C1285-STRUCTURED-NOWRAP-BARRIER)` and `show(C1285-STRUCTURED-RELATION-CANDIDATE)`; the artifact contains the exact parity and global-sign calculation |
| `C1285-RELATION-TO-FACTOR` | For odd `N`, unit residues satisfying `X^2=Y^2 mod N` have a sign on each odd prime-power CRT component. If both signs occur, `gcd(X-Y,N)` and `gcd(X+Y,N)` are complementary proper products of prime-power components. This is an extraction lemma, not a construction of a mixed-sign relation. | `research/routes/structured-relations/analysis.md` | `judgement-C1285-RELATION-TO-FACTOR-3bad73e575f9` | `show(C1285-RELATION-TO-FACTOR)`; the proof is the prime-power sign decomposition in the artifact |
| `R-CENTERED-POLYNOMIAL-WRAPAROUND` | For every fixed positive `c,d,u`, infinitely many canonically specified balanced squarefree semiprimes have all multipliers `1<=k<=ceil(n^u)` coprime to `N`, no zero residual, and no `ceil(n^c)`-smooth residual anywhere in the complete box `x=ceil(sqrt(kN))+t`, `abs(t)<=ceil(n^d)`. In each sufficiently large dyadic prime shell, the family member is the least qualifying product in the selected maximal-cardinality bit-length bin. Therefore no adaptive sampler confined to this complete box produces a relation. Other centers, boxes, and mechanisms are outside scope. | `research/routes/structured-relations/centered_polynomial_wraparound.md`; exact finite verifier `research/routes/structured-relations/centered_sampler.py` | Candidate refuted by `judgement-C1285-CENTERED-POLYNOMIAL-WRAPAROUND-CANDIDATE-ceac899a12bf`; obstruction supported by `judgement-C1285-CENTERED-POLYNOMIAL-WRAPAROUND-OBSTRUCTION-84c30bb37ba2` | `show(C1285-CENTERED-POLYNOMIAL-WRAPAROUND-CANDIDATE)` and `show(C1285-CENTERED-POLYNOMIAL-WRAPAROUND-OBSTRUCTION)`; rerun the finite verifier on any proposed family member as shown below |

## Post-checkpoint route boundaries

| Route | Exact disposition |
|---|---|
| `R-ODD-FACTORIAL-SUCCINCT-CRITICAL-PHI4-JET` | Retired only as an unfinished conjecture-dependent proof route. The `Phi_4` reduction is supported, but the unconditional jet budget is open. |
| `R-ODD-FACTORIAL-SUCCINCT-CRITICAL-JET-DEPTH4-TAU` | Retired after an exact parameter-preserving reduction to Koiran--Skomra Conjecture 1.4. This parks the mechanism; it does not refute or exhaust `SUCCINCT-CRITICAL-RING(C)`. |
| `R-SIQS-GAUSSIAN-ROUGH-MIRROR` | Retired for the frozen Gaussian composition because every proposed input has `v_2(N)=1`. No conclusion is transferred to other rough-mirror compositions or general SIQS. |
| `R-HECM-MODULUS-COEFFICIENT-COLLAPSE` | The version-1 route wording was superseded solely to add the required accepted-output Cosset-surface condition. |
| `R-HECM-MODULUS-COEFFICIENT-COLLAPSE-V2` | Its exact obstruction claim is independently supported. Only the registered polynomial-inventory modulus-algebraic class is covered. |
| `R-HECM-REPRESENTATIVE-CONTROL` | Its transcript witness, record-union theorem, and bounded obstruction are independently supported. Only branch-only representative control inside the polynomial complete-record envelope is covered. |
| `R-HECM-TWO-MULHI-COLLISION-ENERGY` and `R-HECM-TWO-MULHI-POWER-SAVING-COLLISION` | Their stronger conditional and pointwise all-residue energy obligations remain open. They are not needed by the independently supported global-energy route and confer no broader HECM conclusion. |
| `R-HECM-TWO-MULHI-DIRECT-MOVING-INVERSE` | Retired because the global-energy theorem proves direct four-variable incidence without the unproved reduction from one moving-root polynomial. The unused general-reduction obligation remains unproved, not assumed. |
| `R-HECM-TWO-MULHI-DIRECT-GLOBAL-ENERGY` | Its global-energy obligation and direct four-variable incidence goal are independently supported by the exact asymptotic proof. |
| `R-HECM-TWO-MULHI-POSTPROCESSOR-DIRECT-GLOBAL-ENERGY` | Both direct-incidence and propagation obligations are independently supported, yielding exactly the frozen two-mulhi postprocessor obstruction and nothing about unrestricted HECM. |
| `R-SQUFOF-POLYNOMIAL-CYCLES` | Retired on the canonical infinite preprocessing-evasive `N=m^2+2` family. This is absolute failure only for multiplier-free `AP-SQUFOF(c,f,r)`. |
| `R-ODD-FACTORIAL-FACTORED-SPARSE-GCD-ORDER4` | Its obstruction is independently supported and the frozen candidate is independently refuted. The proof route itself has no `retired_because` entry, so this report does not invent one. |
| `R-ODD-FACTORIAL-DYADIC-POWER-DIFFERENCE-GCD` | Retired exactly for oracle-only dyadic powers with a polynomial-length encoding of the full exponent; every broader compressed-product frontier remains open. |
| `R-MULTIPLIER-SQUFOF-NEAR-SQUARE-INCIDENCE` and `R-MULTIPLIER-SQUFOF-BALANCED-FIRST-EVENT-ANSATZ` | Retired because the independently reviewed index-2 event is mixed and returns a prime. No conclusion transfers to unbalanced or later-cycle incidence. |
| `R-MULTIPLIER-SQUFOF-UNBALANCED-LEAST-REPRESENTATIVE` | Retired as a failed decomposition. Reviewer additionally refuted its claimed class-membership orientation criterion. `R-MULTIPLIER-SQUFOF-REDUCED-CYCLE-INCIDENCE` remains open. |
| `R-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-DIRECT-NORM`, `R-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-KUMMER-SHORT-PRIME`, and `R-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD-SIGNATURE-PIGEONHOLE` | Retired for their registered blockers only. The parent `R-ODD-FACTORIAL-PRODUCT-DIFFERENCE-GCD` and its obstruction claim remain inconclusive. |
| `R-ODD-FACTORIAL-LOW-L1-PRODUCT-DIFFERENCE-GCD-ANCHORED-TRANSFER` and `R-ODD-FACTORIAL-LOW-L1-PRODUCT-DIFFERENCE-GCD-GOOD-EVENT-CERTIFICATION` | The old route is retired because its wording was overbroad. The current good-event anchored-transfer v3 and obstruction v2 are independently supported with the explicit event, success containment, and union-bound step. This closes only the frozen low-L1 subclass; no conclusion transfers to the endpoint, high-L1 compressed products, or retained values. |
| `R-ODD-FACTORIAL-LINEAR-EQUALITY-JACOBI-FEEDBACK` and its certification route | The universal `2/3` candidate is independently refuted and the exact `5/8+o(1)` obstruction is independently supported. The ledger routes remain open records, so this report does not invent a retirement. The conclusion covers only `floor(n/2400)` mixed observations after one factor-producing gate. |
| `R-HECM-THREE-MULHI-DIRECT-GCD` | Retired because the exact local `8/r` count and remainder collapse give exponentially small success on the canonical balanced family. The separate obstruction proof route remains as support, and broader `H3` use is outside scope. |

## Earlier checkpoint route dispositions

The following route retirements are supported, and only at their registered
boundaries:

| Retired route | Exhausted boundary |
|---|---|
| `R-LENGTH-UNIVERSAL-EXPONENT` | One explicit positive binary exponent depending only on `n` and annihilating every unit for every `n`-bit modulus |
| `R-RANDOM-SMOOTH-RELATIONS` | Fixed-polynomial factor base and sample count with independent uniform squares and the registered smooth-relation processor |
| `R-DIRECT-SQUARE-COLLISION` | Fixed-polynomial independent uniform square samples using only nonunits and direct collisions |
| `R-CENTERED-POLYNOMIAL-WRAPAROUND` | The complete fixed-polynomial multiplier-shift box centered at `ceil(sqrt(kN))`, including adaptive query orders confined to that box |

The generic LLL-plus-integer-lifting calculation is an exhausted proof
attempt, not a retired general route. Both
`R-AFFINE-SINGLE-CENTER-LATTICE` and `R-GENERAL-LATTICE` remain
inconclusive in the ledger.

## Unresolved mechanisms

1. `C1285` remains open. No post-checkpoint claim constructs a factoring
   algorithm or proves a general impossibility theorem.
2. `C1285-ODD-FACTORIAL-EVALUATOR` remains the campaign-wide proof-graph gap.
   The critical-depth jet budget is conjecture-conditional, and the broad
   odd-factorial evaluator is not excluded.
3. Multiplier-free polynomial-cycle SQUFOF is excluded, but
   `C1285-MULTIPLIER-SQUFOF-UNIVERSAL-CANDIDATE` and
   `C1285-MULTIPLIER-SQUFOF-REDUCED-CYCLE-OBSTRUCTION` remain open. The
   balanced first-event ansatz is impossible as a hard family, while the
   unbalanced class-membership criterion is refuted and the required
   all-multiplier least-representative theorem is inconclusive.
4. The one-gate
   `LINEAR-EQUALITY-JACOBI-FEEDBACK-CRT-LOCAL-DAG` class is excluded at
   `K(n)=floor(n/2400)`. A second factor-producing gate, equality-derived unit
   certificates, nonunit or stronger observations, uncontrolled tensor cost,
   larger observation rates, unrestricted rational controllers, and general
   factoring remain open.
5. Pure factored sparse gcds, polynomially encoded dyadic power differences,
   and adaptive visible product differences satisfying the frozen low-L1
   promise for any fixed rational `0<alpha<1/86` are excluded on canonical
   infinite order-`4ell` families. General product-difference gcds remain open:
   the exact finite characteristic split does not supply an unrestricted
   obstruction, and the low-L1 proof does not cover the endpoint, high-L1
   compressed products, or retained products and differences.
6. The depth-three result excludes only direct registered gcd tests on
   `H3,R3` appended to the reviewed two-mulhi postprocessor. Terminal formulas
   using those values, additional nested quotient gates, nonuniform source
   laws, later HECM arithmetic, and unrestricted HECM remain open.
7. The positive-sign rough mirror outside the frozen Gaussian composition,
   general exact-label SIQS, and general structured-relation generation remain
   open.
8. `C1285-HECM-TWO-MULHI-ALL-RESIDUE-POWER-SAVING` remains proposed. The
   accepted global-average theorem bypasses it; no pointwise all-residue bound
   is claimed.
9. The frozen two-mulhi class is excluded only under its polynomial-record,
   factor-blind, globally low-degree, complete-registration, and cleared-Cosset
   conditions. Factor-dependent coefficients, superpolynomial degree or
   inventory, unregistered factor paths, and repeated-squaring circuits outside
   that class remain open.
10. The earlier direct-algorithm, input-specific-exponent construction, general
   lattice, structured-relation, and structural-reduction frontiers remain
   unresolved at the broader boundaries stated in the ledger.

The earlier `negative_report_late_evidence_campaign_checks` activity event is
a historical receipt for the preceding 379-node report. It is not the current
certification gate. The project-level submission is checked against the current
campaign-local ledger and proof graph, and its exact project root and exits are
recorded in the current Engineer progress and activity stream. A fresh
independent `done` verdict may certify this report as the final-submission
artifact for the present stage; it still cannot close `C1285`, stop the
continuous campaign, or broaden any scoped conclusion.

## Reproducibility

Run all commands from the campaign root
`/home/argustest/zimo/counterexample-batch-1/campaigns/1285`.

For the terminal counterexample, the exact producer and independent replay
commands, inputs, completed states, and zero exits are preserved in
`research/routes/structured-relations/multiplier-squfof/balanced-full-race/evidence/durable-run-status-v2.json`
and
`research/routes/structured-relations/multiplier-squfof/balanced-full-race/evidence/verification-run-status.json`.
The independent replay took more than two minutes, so a fresh run must use the
Argus durable runner rather than a session-owned background shell. Its source
and immutable inputs are the files listed in the terminal claim map above.

To display any exact claim version and its bound evidence, replace `CLAIM_ID`
below:

```sh
/home/argustest/zimo/argus-latest/.venv/bin/python \
  -m argus_skill.verticals.math.math_state show --claim CLAIM_ID
```

To check the authoritative ledger and proof-graph structure:

```sh
/home/argustest/zimo/argus-latest/.venv/bin/python \
  -m argus_skill.verticals.math.math_state check \
  --project-root /home/argustest/zimo/counterexample-batch-1/campaigns/1285

/home/argustest/zimo/argus-latest/.venv/bin/python \
  -m argus_skill.verticals.math.proof_graph_check check \
  --project-root /home/argustest/zimo/counterexample-batch-1/campaigns/1285

/home/argustest/zimo/argus-latest/.venv/bin/python \
  -m argus_skill.verticals.math.proof_graph_check gap \
  --project-root /home/argustest/zimo/counterexample-batch-1/campaigns/1285
```

Successful campaign-local integrity receipts for the post-checkpoint stages
are preserved as the English `activity.jsonl` events
`critical_depth_structural_checks`, `gaussian_campaign_local_checks`,
`hecm_modulus_final_campaign_local_checks`, and
`hecm_representative_campaign_local_checks`, together with
`hecm_two_mulhi_global_energy_validation`, `squfof_ledger_validation`,
`factored_sparse_gcd_review_handoff`, `dyadic_campaign_local_checks`,
`reduced_cycle_campaign_local_checks`,
`unbalanced_reduction_campaign_local_checks`,
`product_difference_campaign_local_checks`, and
`three_mulhi_campaign_local_checks`, followed by
`low_l1_product_difference_ledger_validation`. The final report handoff records
its fresh campaign-local receipt in the same activity stream.

The exact post-checkpoint replays, all run from the campaign root, are:

```sh
# Mixed equality-and-Jacobi one-gate semantics, tensors, and mutation replay
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/odd-factorial-linear-equality-jacobi-feedback/verify.py \
  --certificate research/routes/input-specific-exponent/odd-factorial-linear-equality-jacobi-feedback/certificate.json \
  --self-test

# Critical-depth finite Phi_4, cancellation, SPS, and typed-resultant replay
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/odd-factorial-critical-depth-resultant/verify_certificate.py

# Frozen Gaussian SIQS algebra and parity replay
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/structured-relations/siqs-large-prime/gaussian-rough-mirror/verify_gaussian_rough_mirror.py \
  15 19019 61 4469176

# Modulus-coefficient typed normal-form replay
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/hecm-decomposable/modulus-coefficient-collapse/verify_jacobian_normal_form.py \
  --payload research/routes/input-specific-exponent/hecm-decomposable/modulus-coefficient-collapse/evidence/jacobian-normal-form-payload.json \
  --output research/routes/input-specific-exponent/hecm-decomposable/modulus-coefficient-collapse/evidence/jacobian-normal-form-output.json

# Representative-control transcript and typed floor-sum replay
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/hecm-decomposable/representative-control/verify_representative_control.py \
  --certificate research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/representative-control-certificate.json \
  --jacobian-contract research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/jacobian-floor-sum-contract.json \
  --jacobian-payload research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/jacobian-floor-sum-payload.json \
  --jacobian-output research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/jacobian-floor-sum-output.json \
  --output research/routes/input-specific-exponent/hecm-decomposable/representative-control/evidence/representative-control-verification.json

# Global-energy diagnostic replay of every supplied source and collision
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/verify_global_energy.py \
  --anchors research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/anchors.json \
  --max-source-pairs 69290 \
  --output research/routes/input-specific-exponent/hecm-decomposable/two-mulhi-feedback/direct-curve-incidence/global-energy/verification.json

# Multiplier-free SQUFOF exact anchor
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/structured-relations/squfof/verify_certificate.py \
  research/routes/structured-relations/squfof/certificate.json --self-test

# Factored sparse-gcd semantic anchor
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/odd-factorial-factored-sparse-gcd/verify_certificate.py \
  research/routes/input-specific-exponent/odd-factorial-factored-sparse-gcd/evidence/certificate.json

# Dyadic power-difference semantic anchor and typed finite-field table
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/odd-factorial-dyadic-power-difference-gcd/verify_certificate.py \
  research/routes/input-specific-exponent/odd-factorial-dyadic-power-difference-gcd/evidence/certificate.json \
  --jacobian-output research/routes/input-specific-exponent/odd-factorial-dyadic-power-difference-gcd/evidence/jacobian-output.json

# Multiplier-balanced first-event anchor
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/structured-relations/multiplier-squfof/reduced-cycle-incidence/verify_certificate.py \
  research/routes/structured-relations/multiplier-squfof/reduced-cycle-incidence/certificate.json \
  --self-test

# Product-difference finite characteristic-split anchor
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/odd-factorial-product-difference-gcd/verify_certificate.py \
  research/routes/input-specific-exponent/odd-factorial-product-difference-gcd/evidence/certificate.json

# Low-L1 visible product-difference compiler and semantic replay
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/odd-factorial-product-difference-gcd/low-l1-entropy/verify.py \
  research/routes/input-specific-exponent/odd-factorial-product-difference-gcd/low-l1-entropy/certificate.json \
  --output research/routes/input-specific-exponent/odd-factorial-product-difference-gcd/low-l1-entropy/verification.json \
  --self-test

# Depth-three direct quotient/remainder anchor
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/input-specific-exponent/hecm-decomposable/three-mulhi-direct-gcd/verify_depth_three.py \
  --anchors research/routes/input-specific-exponent/hecm-decomposable/three-mulhi-direct-gcd/anchors.json \
  --max-source-pairs 27603 \
  --jacobian-discovery research/routes/input-specific-exponent/hecm-decomposable/three-mulhi-direct-gcd/jacobian/discovery.json \
  --jacobian-contract research/routes/input-specific-exponent/hecm-decomposable/three-mulhi-direct-gcd/jacobian/contract.json \
  --jacobian-payload research/routes/input-specific-exponent/hecm-decomposable/three-mulhi-direct-gcd/jacobian/payload.json \
  --jacobian-output research/routes/input-specific-exponent/hecm-decomposable/three-mulhi-direct-gcd/jacobian/output.json
```

These replay commands consume preserved exact evidence; they are not needed to
turn a finite diagnostic into an asymptotic theorem. The asymptotic arguments
remain the prose proofs identified in the claim map; both the corrected low-L1
claims and the mixed equality-and-Jacobi claims have current independent
judgements.

For one proposed member of the centered-box hard family, pass the exact
integer values `N,B,K,T`; `--expect-hard` makes any noncoprime multiplier,
zero residual, or smooth residual a failing exit:

```sh
/home/argustest/zimo/argus-latest/.venv/bin/python \
  research/routes/structured-relations/centered_sampler.py \
  N B K T --expect-hard
```

The sampler verifies one finite box. The asymptotic existence of the canonical
infinite family is supplied by the counting proof in
`centered_polynomial_wraparound.md`, not by a finite run.

The earlier checkpoint additionally preserves three Jacobian records with the
operation ids, exact payloads, typed outputs, adapter errors, and timeout
statuses used for its bounded cross-checks:
`research/routes/affine-lattice/jacobian_evidence.json`,
`research/routes/random-smooth-relations/jacobian-evidence.json`, and
`research/routes/structured-relations/jacobian-centered-evidence.json`. Their
finite results are explicitly not premises of the asymptotic theorems.

There is no Lean formalization or mechanical proof certificate for the prose
theorems in this report. The `math_state` and proof-graph commands validate
ledger integrity and evidence binding; mathematical support comes from
independent reviewer judgements over the cited self-contained proofs.

## Open-problem disclaimer

General classical polynomial-time integer factoring remains open under the
reviewed 2026-08-27 source audit. These negative results concern only the exact
registered families above. They do not imply that classical polynomial-time
factoring is impossible, do not exhaust direct or structural algorithms, and
do not convert the supplied-exponent reduction into an unconditional
algorithm. In particular, the corrected low-L1 theorem does not cover high-L1
compressed products or retained product/difference registers, and the mixed
equality-and-Jacobi theorem does not cover a second factor-producing gate,
stronger observations, larger rates, unrestricted controllers, or the broad
odd-factorial evaluator. Accordingly, `C1285` must remain open.
