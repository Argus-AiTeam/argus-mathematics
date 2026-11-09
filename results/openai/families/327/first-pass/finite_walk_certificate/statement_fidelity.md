# Statement fidelity: Proposition `prop:walks`

`Campaign9000327.prop_walks` is universally quantified over `N : OrderedNorm`,
`n : Nat`, and a proof `0 < n`. It proves existence, not an algorithm enumerating
the chain. There is no upper bound on `n`, and in particular `n = 1` is included.

The target is the staged September 23, 2026 manuscript, `build/main.tex`,
Proposition `prop:walks`, with the definitions immediately preceding it.
`C00` is `Nat ->₀ Real`. Its zero-based coordinates correspond to the manuscript
coordinates by adding one. `OrderedNorm` consists of a real seminorm, positive
definiteness, invariance under every strictly increasing finite placement, and
contractivity of `mergeAt i`, which adds coordinates `i` and `i+1` and shifts
later coordinates down. These are precisely a genuine norm, spreading
invariance, and contractive adjacent merging. There is no assumption of
unconditionality, completeness, basis normalization, or finite representability.

The existential witness has finite types `State` and `Edge`, with their
`Fintype` instances supplied as fields. Its `FiniteMarkedChain` contains a
nonnegative probability distribution `pi` with sum one, source and target maps,
an involutive reversal exchanging endpoints, nonnegative source-normalized edge
probabilities `q`, and edgewise detailed balance. Thus marks and parallel edges
are retained; labels are not required to be differences of a state potential.
`AllConditions` additionally displays the stationary distribution equation for
the induced transition matrix `markedTransition`.

The label has values in real `c00`. A single natural `coordinateBound` bounds
the supports of every label, so all labels lie in one finite coordinate span.
Oddness and norm one hold on **every** marked edge, not merely almost surely or
only on the good-transport event.

`MarkedPath State Edge n` stores an initial state and exactly `n` marked edges.
`markedPathWeight` is zero on invalid paths, and otherwise is the initial
stationary mass times the product of the `n` transition probabilities.
`AllConditions` includes the theorem that these weights sum to one.
`markedProb` sums these weights over the specified event; `edgeSum` sums exactly
those `n` labels. The final conclusion is the lower bound `3/20` for the event
`n/24 <= N(edgeSum ...)`, including equality at the threshold. No independence
of good transitions is assumed.

The proof uses the public `OAI.MarkovSuperreflexivity.finiteWalk` construction at
revision `4eaee87548250b2682affda7d05d947c05554bae`, its complete custom import
cone, and the normalization and stationarity lemmas of that same cone.
The source snapshot, any explicitly recorded compatibility edits, and the
compiler's transitive axiom report determine what has actually been checked.
Ordinary Lean foundational axioms `propext`, `Classical.choice`, and
`Quot.sound` are not additional Banach-space hypotheses.

This statement does **not** certify `lem:ordered-norm`, its finite
representability assertion, `lem:edge-labels`, or `thm:main`. It does not assert
irreducibility, aperiodicity, a bound on chain size, or a complex-scalar version.
The mathematical proposition and its original Lean proof are prior OpenAI
results; this campaign's deliverable is an independent, source-faithful
verification, not a claim that the mathematical theorem is newly discovered.
