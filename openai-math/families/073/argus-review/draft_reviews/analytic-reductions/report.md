# Analytic reductions: engineering assessment

## Claim, sources and attribution

C_ANALYTIC@1 asserts the analytic preparation, shell conversion, graph
estimates and numerical reductions of Sections 03–08 with their support
and uniformity contracts; its own statement says these were not established
by the combinatorial audit. A_ANALYTIC_REDUCTIONS is the explicit
undischarged hypothesis covering numerical transitions, polynomial
branching, subpower coefficient sums, arbitrary-power errors and stopping.
It is a ledger assumption, not a proved Lean declaration.

The source is OpenAI, *The Falconer distance conjecture in all dimensions*,
2026-09-23, at revision `4eaee87548250b2682affda7d05d947c05554bae`,
pinned by campaign 9100073 and matched to both reference and staged TeX.
Below, T03–T09 denote files in
`openai-math/preprints/The-Falconer-distance-conjecture-in-all-dimensions-September-23-2026/build/sections/`.
Old `Main.lean`, F=`research/statement_fidelity.md`, and
A=`research/AUDIT_REPORT.md` are under the read-only campaign 9000073.
This assessment checks the actual interfaces and identifies mathematical
obligations; it neither proves nor refutes the remaining analytic claims.

## Numerical contract and missing bridge

The analytic values are not arbitrary scalars. T08:18–46 defines the
positive collision count with normalization `2^(t-a)*M(a)^(-4)`.
T06:119–153 defines the independent angular energy with prefactor
`2^(d*(v-a))`, model-mass-normalized endpoint transforms, a common radial
variable and two independent angular integrals. Symbols may vary only
with fixed derivative budgets and common numerical bounds
(T06:48–80; T08:49–83). The exact normalization identity is

```text
2^(d*(b-a))*(M(b)/M(a))^2 = R^(-2*(A_b-A_a)),
```

using `S=d/2` (T08:104–110).

T08:194–260 states that nonterminal states below J0 are bounded by
polynomially many children, with additive `O(R^(-T))` for every prescribed
fixed T. Each non-low factor is
`R^(-2*(A_new-A_old)+cost+C_d*sigma+o(1))`.
A low child has zero cost and **entire** factor `R^o(1)`, not
`R^(C_d*sigma+o(1))`. A low-frequency stop costs
`R^(C_d*sigma+o(1))`; terminal states cost
`R^(C_d*(kappa+sigma)+o(1))`.

The corresponding Lean premise is only

```text
value(x)<=B  OR  exists legal child y:
value(x)<=2*A(start_x)-2*A(start_y)+cost
          +(eta if low else epsilon)+value(y).
```

See `Main.lean:1048–1052,1118–1123`. Applying it requires a finite uniform
base-R exponent envelope, including zero energies and unrealized abstract
shapes. Polynomially many *numerical child terms*, rather than a count of
admissible symbols, must be aggregated; symbol suprema need uniform bounds,
not an assumed maximizing symbol (T08:251–255; T09:215–220).
One then needs nonnegative overhead envelopes
`epsilon=C_d*sigma+o(1)`, `eta=o(1)` and
`B=C_d*(kappa+sigma)+o(1)`. F:193–205 correctly leaves this interpretation
and additive-error absorption conditional.

## Concrete outstanding obligations

* **Section 03:** T03:21–45's linear projection gain assumes
  `k>=2`, `k-1<=q<=k-1/2<t<k`, ball bounds with loss
  `delta^(-epsilon)`, and an additional hyperplane-plate bound when
  `q=k-1`. Tube-covered incidence fibers must have mass at most
  `delta^c`. Its measurable bad-direction consequence is
  T03:872–892. The old formal proof verifies neither this gain nor the
  endpoint slicing/incidence input required by preparation.
* **Section 04:** T04:733–768 requires separated original
  `(d/2+chi)`-Frostman laws, decreasing Borel filters of positive limiting
  mass, at most `C*R^(2*d*omega)` spatial products, and simultaneous
  original-fiber cap bounds `R^e*u^(d/2)` after power-small deletion.
  The odd-dimensional upgrade at T04:278–284 has its own Frostman and
  plate hypotheses. Maintaining both orientations, measurability and
  the product-filter contract is not established by schedule geometry.
* **Section 06:** Under separated geometry, polynomial endpoint lists,
  fixed symbol bounds, `v-a>=20*sigma*N` and
  `L<=(v-a)/2+sigma*N`, the weighted shell conversion is
  `2^(-a)*integral_shell |nu_hat|^2 <= R^o(1)*sup H_F+O(R^(-T))`
  (T06:182–220). The weight, model-mass normalization, support-preserving
  differentiated masks and N-independent budgets are essential, not
  consequences of the abstract recurrence.
* **Section 07:** The graph inequality has exponent
  `-sum_j(A_j,p-A_j,a)+min_j k_j(a,p)+O_d(sigma)+o(1)`
  (T07:17–69). It needs its depth ranges and supported parallel tests,
  both row and column degree bounds (T07:251–323), and retains the
  old symbols without requiring cell separation. Origin existence alone
  proves none of the oscillatory localization or degree estimate.
* **Section 08:** Suffix transfer uses full conditional class laws
  (T08:267–331). High/direct reductions must preserve the correct lists;
  near factors may be removed only after forming positive independent
  energies, whereas far stationary coefficients must retain them
  (T08:373–466,521–588). Low steps must incur no fixed sigma loss
  (T08:355–371). These are concrete support/normalization requirements,
  not discharged by payment or termination.

T09:262–299 specifies error absorption: bound ancestor factors, choose
`T>C_d*(1/kappa+1/sigma)+10*d+10`, fix the inverse-expansion-derived
persistent budget, then choose direct/nonstationary orders before N
grows. The formal finite-depth bound helps this program but does not
prove the required analytic estimates.

## Verdict, novelty and limits

The boundary asserted by A:18–23 and F:199–210 is substantively justified:
C_ANALYTIC@1 remains **not established by the old draft**, and
A_ANALYTIC_REDUCTIONS remains a hypothesis. This is not a finding of
falsehood. All needed passages were readable; the limitation is missing
analytic verification, not missing access. No new computation or
compilation was performed. The source-bound historical compiler success
was verified in `../scheduled-recursion/binding_replay.json`; it cannot
discharge these hypotheses. The old reviewer's judgement on
A_ANALYTIC_REDUCTIONS is inconclusive, not supporting. Manuscript
arguments are OpenAI's; Argus contributed the explicit boundary and
conditional formal interface, not a new analytic theorem. Global novelty
is unverified/not claimed. Independent native Host Reviewer assessment
remains pending.
