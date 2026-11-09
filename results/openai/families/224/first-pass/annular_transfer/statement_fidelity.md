# Statement fidelity: signed averaging and dyadic summation

This source formalizes the finite algebra used in equations
`tr:flip-integral` and `tr:signed-sum`, and the absorption of the polynomial
factor in `tr:unused`. It does not formalize Proposition `tr:block`.

All declarations are in namespace `AnnularTransfer`.

`colour_flip_identity` quantifies over every finite type of histories, every
permutation `flip`, and arbitrary real-valued functions `a` and `k`.
Its hypothesis is exactly `a (flip i) = -a i`. It proves that the weighted
kernel sum equals one half of the weighted signed kernel difference.
Probabilities invariant under the permutation may be absorbed into `a`.
No positivity of `a`, kernel bound, independence, or asymptotic estimate
is assumed or concluded. An involution is a permitted special case.

`invariant_reindex` quantifies over an arbitrary permutation under which `a`
is invariant. It proves equality of the original weighted sum and the
sum with the kernel reindexed.

`colour_rotation_identity` combines these facts for every natural number
`m` and every family of `m` permutations preserving `a`. Its left side
is the sum, over these permutations, of the signed kernel differences.
Its right side is `m` times twice the original weighted sum.
It is a finite averaging identity, not an assertion that four rotations
equal Haar averaging over all physical rotations. In the manuscript the
corresponding identity uses a measure-preserving circle action; that
measure-theoretic extension is proved in `signed_transfer.md`, not in Lean.

`geometric_identity` proves the finite geometric-sum identity for every
real `q` and every natural cutoff `n`.

`geometric_bound` and `double_geometric_bound` quantify over every real
`q` with `0 <= q < 1` and every natural cutoff `n`. They bound the one-
and two-index geometric sums by `1/(1-q)` and its square. These are
uniform-in-cutoff theorems, not tests of a bounded list of scales.
For the transfer application `q = 2^{-(a-b)}` with `a > b`.

`polynomial_absorption` quantifies over the same `q` and every natural
`n`, and bounds `(n+1)^2 q^{2n}` by `1/(1-q)^2`.
For the unused-pair remainder one takes
`q = 2^{-(a-b)/2}`. This controls the polynomial loss without changing
the order of the manuscript's scale quantifiers.

Not verified by these statements: the Poisson seam construction,
admissibility of random frontiers, the SLE modulus equation, analytic
smoothing or spectral gaps, the separated-end kernel estimate, first-
reduction tail probabilities, the output-seam essential supremum, or
the existence of any counterexample. In particular a successful compiler
run is not a proof of Cardy's formula, the amplitude theorem, or the
separately normalized near-critical theorem. The unverified hypotheses
of the conditional analytic reduction remain explicit in
`signed_transfer.md` and the mathematical ledger.
