# The forward Markov-type implication: mathematical audit

## Certified result

The official Lean 4.31.0 verifier returned `exit_code = 0`,
`proof_holes = []`, and axiom-audit exit code zero for `CMain`,
`COrdered`, and `CEdgeTransfer`. All six printed transitive axiom
closures contain exactly `propext`, `Classical.choice`, and `Quot.sound`.
The ledger derives `closed_kernel` for all three claims with no
undischarged assumptions. In particular the required James--Enflo
structural construction is proved, not retained as an assumption.

The archived compiler records are
`certificates/CMain-d1aeef5781bc334d.json`,
`certificates/COrdered-12d1511a7bbea53e.json`, and
`certificates/CEdgeTransfer-ba09c59325d39ccb.json`.
The new theorem wrappers and all 154 additional custom modules compiled;
zero reviewed finite-walk modules were recompiled. The accepted `CWalk`
claim, its dependency records, and its independent review remained unchanged.
No exact counterexample to a remaining manuscript assertion was found.
Independent Reviewer confirmation of the new statements' fidelity and
replay is still pending; kernel closure is not that approval.

## Scope and comparison with the prior result

The target is the staged theorem: every real Banach space with ordinary
Markov type `p > 1` admits an equivalent uniformly convex norm.
The strongest prior result in this campaign is the independently accepted,
universal finite-walk proposition `CWalk`, not a bounded experiment.
Its certificate is
`research/finite_walk_certificate/certificates/CWalk-d0a6fb48b124f143.json`.
That result alone did not supply the ordered norm, preserve Markov type on
its finite-dimensional representations, or justify applying the inequality
to labels which are not differences of a function on the original states.
The present work addresses exactly these remaining reductions and their
composition. No converse characterization or mathematical novelty is claimed.

The formal outcomes and their actual compiler certificates are recorded in
`exact_certificate.json`; statement translation is fixed separately in
`statement_fidelity.md`. Independent Host-invoked Reviewer acceptance of this
new work is required and is not supplied by the Engineer.

## Ordered-norm construction

The manuscript invokes the James--Enflo structural implication to obtain a
nonreflexive Banach space `Y` finitely representable in a space without an
equivalent uniformly convex norm. It is not legitimate to leave that input
implicit. The pinned source includes a proof: failure of the finite
triangular obstruction supplies triangular systems, whose completed limit
space is both nonreflexive and finitely representable. Conversely the
obstruction gives finite lower L2 estimates, dyadic cotype, and a convex
potential which produces the equivalent uniformly convex norm. The relevant
bridge is
`exists_nonreflexive_finitelyRepresentable_of_not_hasEquivalentUCNorm`
in `JamesEnflo.lean`. Its transitive axiom report is checked separately;
the older `JAMES_ENFLO` ledger assumption is discharged by this proof, not
re-labelled as a checked bibliographic citation.

From `Y`, the finite triangular arrays and Ramsey selection give a spreading
seminorm `N0` and a number `d > 0` with, for every real coefficient array,

    d * max_j |a_1 + ... + a_j| <= N0(a) <= sum_i |a_i|.

Two successive prefix sums differ by one coefficient. Hence
`N0(a) >= (d/2) max_i |a_i|`; in particular it is a genuine norm.
The same common L1 Lipschitz bound which extends the rational-coefficient
limit to real coefficients gives uniform convergence on each fixed
finite-dimensional coefficient cube. The positive coordinate lower bound
converts uniform additive approximation into arbitrarily small relative
distortion, including injectivity. This step is essential: pointwise
convergence alone would not prove finite representability.

If `F_J` replaces a coefficient by `J` equal pieces, spreading invariance
and convex averaging over subsets show that subdivision is monotone as
the multiplicities increase. The decreasing limit
`N(a) = lim_J N0(F_J a)` retains the same prefix lower bound, L1 upper bound,
and spreading invariance. The original prefix cuts still occur at block
endpoints, so positive definiteness survives; it is not obtained by assuming
that a limit of norms is a norm.

For any fixed varying positive multiplicities, sandwiching their composite
subdivisions between uniform subdivisions proves invariance of `N`.
Subdivision with rational same-sign ratios, followed by continuity, proves
same-sign merging equality. For fixed nonzero `s`, convexity of
`t -> N(left,t,s-t,right)` and its constancy on the interval between zero
and `s` give a global lower bound by the merged norm. The zero-sum case
follows by perturbation and the same Lipschitz bound. Thus merging is
contractive for arbitrary signs, including exact cancellation.

Uniform relative approximation first embeds a fixed `N` coordinate span
in a larger `N0` span, then in `Y`, then in `X`. The source's
`exists_uniform_nearIsometry`, `CoordinatesRepresentable.of_factorization`,
and `CoordinatesRepresentable.transfer` implement these steps. Each
positive distortion budget can be made arbitrarily small; for example
`delta = min(eta/7,1)` gives `(1+delta)^3 <= 1+eta`. Strict distortion
less than `1+eta` follows by using a smaller budget. There is no
unconditionality, sign restriction, fixed coordinate dimension, or
completeness requirement on the coefficient space.

## Odd-label lattice lift

Choose one representative of each two-element edge-reversal orbit and
give the two edges opposite integer unit displacements. A fixed edge
has label zero, since `g(e) = -g(e)` over the real scalars, and receives
zero displacement. This also handles the no-two-element-orbits case.

On `S times {-R,...,R}^r`, propose the original marked edge. Accept if
the lattice displacement stays in the cube; otherwise stay at the same
**full state**, including its base-state coordinate. An accepted edge
reverses with the reversed mark and opposite displacement. Its two fluxes
are equal by the original detailed balance and equal cube masses.
A rejected mark becomes its own reverse and adds a self-loop only.
Rows still sum to one. The stationary law is exactly
`pi times uniform cube law`, even for zero-mass base states, parallel
edges, and nonfixed self-loops.

The potential `Phi(s,a) = sum_j a_j g(e_j)` has increment `g(e)` on an
accepted proposal and zero on a rejection. Consequently its stationary
one-step p-cost is no greater than the original one-step label p-cost.
Positivity of `p`, already part of Markov type, is used at zero.

For fixed `n` and `R >= n`, an initial lattice point in the smaller cube
`{-R+n,...,R-n}^r` accepts every possible sequence of `n` proposals.
Every prefix displacement in each coordinate is between `-n` and `n`;
there is no probabilistic assumption in this assertion.
The original path and the initial cube coordinate have product law.
The formal proof makes this explicit by an injective map from their
product into lifted marked paths. Its exact weight is the original
marked-path weight divided by the large cube's cardinality. Telescoping
the potential gives the full sum of original labels, so

    alpha_R * E ||sum_{i=1}^n g(E_i)||^p
       <= E ||Phi(lifted Z_n) - Phi(lifted Z_0)||^p,
    alpha_R = ((2(R-n)+1)/(2R+1))^r.

Apply ordinary Markov type on this finite lifted state chain and use the
one-step upper bound. Letting `R` tend to infinity gives the claimed odd
edge-label inequality with exactly the original constant `K`, since
`alpha_R -> 1` at fixed finite `r` and fixed `n`. The cube may grow;
the span of the potential values does not.

Finite representability preserves Markov type with the same exponent
and constant. For a finite state map, embed just the span of its values
with norm bounds `1` and `1+eta`; the resulting extra factor is
`(1+eta)^p`, which tends to one. For the last assertion of
`lem:edge-labels`, `odd_edge_transfer_span` restricts the labels to
their actual finite linear span before applying this argument. It does
not assume that the full ambient space embeds or has Markov type.

## Main implication

Suppose `X` has Markov type `p > 1` with fixed constant `K` but no
equivalent uniformly convex norm. The ordered norm above has finite
coordinate spans arbitrarily well represented in `X`.
For every positive integer `n`, reuse the reviewed `CWalk` witness.
All labels have norm one in one finite coordinate span, and the sum
has norm at least `n/24` with probability at least `3/20`.
The odd-label transfer therefore gives

    (3/20) * (n/24)^p
       <= E N(sum_{i=1}^n g(E_i))^p
       <= K^p * n.

After division by `n`, the left side is a fixed positive multiple
of `n^(p-1)`, unbounded for every real `p > 1`. The contradiction is
uniform over all positive times; neither finite time testing nor an
integer-exponent restriction supplies it.

The conclusion uses the exact unit-ball midpoint definition of uniform
convexity from the manuscript. A positive comparison lower bound makes
the constructed seminorm a norm. `main_explicit` displays the comparison
constants and every modulus quantifier. The zero space is included,
with no nontriviality assumption; `zero_space_case` records it directly.

## Exact adversarial experiments

These are checks of the new reductions, not a reconstruction or expansion
of the accepted finite-walk enumeration.

| Experiment | Exact scope |
|---|---|
| Definiteness and coordinate lower bounds | 1,562 checks in the prefix-sum and L1 norms |
| Zero insertion and spreading | 1,562 checks |
| Varying subdivisions | 22,222 checks |
| Arbitrary-sign adjacent merging | 4,300 checks, including 860 exact zero-sum pairs |
| Three-stage distortion budgeting | Eight rational budgets, down to `1/1000000` |
| Reversible finite lattice lifts | Nine chain/time/radius instances, up to 2,187 full states |
| Accepted/rejected potential increments and reversal | 9,906 accepted and 936 rejected marks |
| Wholly accepted central paths and telescoping | 5,226 paths |
| Central-cost lower and one-step-cost upper comparisons | 72 rational comparisons |

The examples include unequal stationary masses, a zero-mass state,
parallel marked edges, nonzero labels on nonfixed self-loops, fixed
zero-label edges, no two-element reversal orbits, both positive times
one and larger times, and a genuinely conditional (not unconditional)
prefix-sum norm. No counterexample to the tested manuscript assertions
was found. These finite checks are not a proof of any universal assertion.

One bounded Jacobian operation,
`probability.markov_chain.stationary_distribution.compute`, was executed
through the prescribed Argus sidecar, after discovery and typed-contract
inspection. Its five-state reflecting lift includes boundary rejection:
interior transitions have probabilities `3/8,1/4,3/8`, while boundary
rejection increases the holding probability to `5/8`.
The exact output gives the unique uniform stationary law. Python
independently checks its normalization, stationarity, and detailed
balance. The exact payload, typed response, server version, protocol,
operation id, and adapter exit status are preserved in dedicated
`jacobian_*.json` files. This is only an auxiliary example.

## Reproducibility and boundaries

The sources are pinned to OpenAI revision
`4eaee87548250b2682affda7d05d947c05554bae`.
`source_inventory.json` records the additional forward dependency cone:
154 new custom modules and the 41 reused reviewed finite-walk modules.
`public_sources/` preserves the new originals, under the same public
Apache-2.0 license already preserved with the finite-walk snapshot.
`build_forward.py` generates the explicit 4.31 compatibility port in
`lean431/`; its per-module compiler results and input/output identities
are in `build_result.json`. The original toolchain is 4.34.1, not 4.31.0.
No new Lake workspace, Mathlib fetch, public monolithic build hook, Git
command, or converse theorem entrypoint is used.

The reviewed objects are linked read-only into the new import root
because Lean resolves the common module prefix there; a second
`LEAN_PATH` root alone does not merge a split custom namespace.
Their original sources and object identities are checked, and none
is recompiled. API compatibility edits are recorded explicitly, and
must preserve every mathematical hypothesis and conclusion.
Compiler failure is not a mathematical refutation.

Besides import-path and conditional-lemma API renames, the port has three
local proof replacements. The cube-cardinality proof exposes its function
type explicitly before applying `Fintype.card_fun`. The conditional-average
proof proves its indicator equality pointwise instead of a one-shot `simpa`.
The dyadic energy telescope rewrites scalar sequences before expanding
dependent word expectations, avoiding mismatched `Fintype` instances under
`Fin.castSucc` rewriting on 4.31. These replacements preserve the original
theorem statements and are all checked by the real compiler.

From the campaign root, the standalone replay is:

```sh
$WORKSPACE/argus-live-update/.venv/bin/python research/main_theorem_certificate/verify.py
```

`--exact-only` is explicitly just the bounded experiments.
`--formal-only` reuses their source-bound results and obtains real compiler
evidence. The default replays the preserved Jacobian output rather than
re-querying the sidecar; `--run-jacobian` explicitly executes a new bounded
call. Long compiler runs on this host must be submitted with the durable
Argus runner. Submission receipts are kept here, and all later build
receipts are scoped to this certificate directory; `--cwd` remains the
campaign root, so claim evidence goes to the shared campaign ledger.

The official verifier is invoked for `COrdered`, `CEdgeTransfer`, and
`CMain`, each binding the actual Lean source and the same declaration
fidelity document to that claim. Transitive axiom reports cover the
ordered-norm theorem, both odd-label formulations, both main formulations,
and the structural James--Enflo implication. Only `propext`,
`Classical.choice`, and `Quot.sound` are permitted.
Both official structural checks must pass against the campaign root
`campaigns/9000327`,
after each ledger change and before handoff.
At Engineer handoff both checks returned exit status zero against that
exact root. The citation checker reports no outstanding or blocking
assumptions. Engineer support judgements are explicitly labelled as
Engineer opinions and do not stand in for the pending independent review.

The new proof is a universal formal verification of existing mathematics.
Its translation and replay still need the independent Reviewer; no
Engineer-authored file asserts that approval. The existing accepted
`CWalk` claim and its review are preserved unchanged.
