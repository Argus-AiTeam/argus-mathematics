# Statement fidelity

The target is FPRAS `build/main.tex`, Definition `def:tree-bags`
(396-412), Dirichlet normalization (420-425), literal pair proposals
(1599-1628), and `thm:pair-energy` (1630-1637). Functions are arbitrary
real functions on **colored** perfect matchings. A common clamp is
applied to individual edge activities before forming matching weights.
It is not a clamp of matching weights or an independent clamp per bag.

## All-size mathematical claim

`proof.md` proves a structural extension and its tree-bag specialization:
with the manuscript's exact proposal probabilities and Metropolis rule,
for every permitted tree-bag graph on N >= 2 vertices, every D >= 1,
every common positive interval clamp, and all real f1,f2,

    Var_pi(f1) <= 44040192 N^12 (1000D)^6 E_P(f1(A)+f2(B)).

In particular this implies the requested `(10^4 N D)^100` bound.
The stronger constant uses a new compressed inverse tag; the source
itself gives `10^51 N^34 D^6`. This is an all-size proof, not an
inference from finite tests. Its combinatorial/source bridge is a
human-readable proof, not a fully Lean-formalized graph theorem.
Novelty and publishable significance remain questions for independent
review; no literature-completeness or Reviewer verdict is asserted.

## What Main.lean actually proves

All declarations are in `PairEnergyAudit`. Only Mathlib is imported.
No upstream OpenAI implementation or comparator is imported.

* `CompactTag`, `compact_tag_card`: the finite tag space is
  `Fin 384 x (Fin 8 -> Fin N) x (Fin 8 -> Fin 2)`. Its cardinality is
  at most `2^17 N^8`, including N = 0. The flags and graph-derived
  construction of this tag are explained in `proof.md`, not encoded
  as graph objects in Lean.
* `tagged_fibre_bound`: for **arbitrary finite demand sets**, arbitrary
  output types and arbitrary encoding/tag maps, injectivity of the
  combined map implies the stated bound on every encoding fibre.
  Injectivity is an explicit hypothesis, not a Lean theorem about
  manuscript matchings. The proof in Section 3 of `proof.md`
  establishes it for the actual encodings.
* `weighted_center_identity`, `conditional_center_bound`: finite real
  weighted sums with total mass p, nonnegative weights in the
  inequality, and zero weighted centered first moment. The conclusion
  retains p on the left. No lower bound on p and no replacement by
  an unconditional guide law occur. In the graph application,
  weights are the **unconditioned** pi(B) on guides containing C_X,
  p = p_X > 0, and mu is their conditional mean.
* `two_context_bound`, `swap_difference`: the exact real scalar
  inequalities/identity used to move from two contexts to a swap.
* `nonzero_opposite_long_context`: the four scalar values (1,0,0,0)
  have squared context commutator 1. Its realization by legal
  colored eight-cycle matchings is checked by `verify.py`, not
  by this scalar Lean declaration.
* `demand_energy_composition`: n,a,t >= 1, e >= 0 and four explicit
  bounds on real variables `color`, `switches`, `errors`, and
  `variance` imply `variance <= 336 n^4 a^6 t e`. In application
  these variables are precisely the weighted sums defined in the
  proof. Their identification and individual energy bounds are
  proved in prose, not smuggled into a formal kernel definition.
* `compact_energy_coefficient`: substituting t = `2^17 n^8`
  gives `44040192 n^12 a^6 e`.
* `one_le_power`, `headline_constant`: for real n,d >= 1 the
  improved coefficient is at most `(10000 n d)^100`.

The ledger claim `C_PAIR_CORE` is restricted to these formal
finite-cardinality, weighted-centering, and real-algebra statements.
Compiler acceptance of that claim must **not** be reported as kernel
certification of `C_PAIR` or `C_PAIR_IMPROVED`.

## Finite evidence and its limits

`verify.py` implements the literal index-1-or-2 proposals, with absent
indices producing holds; enumerates colored matchings and discrepancy
components with multiplicities; and checks exact rational stochasticity,
proposal symmetry and Metropolis detailed balance in its named small
instances. It constructs the eight-cycle with two opposite long arcs
and replays its matching identities, guide encodings, compressed-tag
inverse, retained conditional mass, and individual arc-swap identities.
These are deterministic finite checks, not all-size proofs.

The preserved Jacobian call `quadratic_form.evaluate.compute` evaluates
the context commutator square for the four scalar values above. Its
exact value 1 agrees with the independent replay. It supports the
need to retain context errors, **not** a refutation of the source:
the source explicitly retains and bounds those errors.

## Source scope, not dependencies

The staged entropy manuscript asserts the boundary-inclusive inequality
`F-(2-2/m)B <= H <= F`, supported by the minimal-face codimension,
covariance-trace, and boundary-reduction steps recorded separately in
the proof graph. This mission does not certify those steps or the
headline counting theorem.

At upstream commit `4eaee87548250b2682affda7d05d947c05554bae`,
`lean/docs/113.md` documents FPRAS/entropy formalizations and comparator
links. The document and the start of
`lean/ComparatorChallenges/MatchingFPRAS.lean` were retrieved. No
upstream dependency closure was executed or used as an assumption in
this proof. A source declaration or a comparator placeholder would
not discharge the source-to-kernel obligations addressed here.

All-size claims still require independent review of the prose bridge,
tag decoding, and statement fidelity. No false staged assertion has
been established by this work.
