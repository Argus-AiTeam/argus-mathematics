# Formal statement fidelity

This document describes `Main.lean` in namespace `AdaptivePrimeDeletion`.
It does not describe a Lean formalization of algebraic varieties or the
quartic density theorem.

`bad q m` is the rational indicator of integer divisibility `q | m`.
The theorem `adaptive_edge_bound` quantifies over arbitrary natural
integer records `before, after` and arbitrary integers `old, new, q`.
It assumes `after <= before` and that equality of those records implies
`old = new`. It proves

    bad q new <= before - after + bad q old

with subtraction in the rationals. Neither `new` nor `old` is assumed
independent of the label `q`. In applications they are the products of
the adaptive full-path and deleted-path minors. Nonzero minors and prime
labels are needed to obtain a divisor budget, not for this inequality.

`regular_deletion_step` quantifies over arbitrary finite lower and upper
vertex types `U,V`, an arbitrary decidable incidence relation, arbitrary
natural rank functions on the two vertex types, arbitrary integer minor
functions on both types, and an arbitrary integer label on each pair.
Every lower vertex has `c` incident edges and every upper vertex has `d`
incident edges. Ranks decrease on incident edges, and equal ranks on an
edge imply equal minors. At each lower vertex at most `D` incident edges
have a label dividing that vertex's minor. The conclusion bounds the
sum of the full-minor divisor indicators over **all** incident edges by

    c * sum(lowerRank) - d * sum(upperRank) + card(U) * D.

All sums and the conclusion are rational; `c,d,D` and ranks are natural.
The statement does not assume the divisor events are independent, and
the minor at an upper vertex can depend arbitrarily on that vertex.
For uniform subset deletion, the lower vertices are the `(t-1)`-subsets,
the upper vertices the `t`-subsets, and the label is the unique added
prime. Then `c=n-t+1` and `d=t`. The regularity, equality of total edge
counts, and identification with the sampling experiment are proved
in Theorem 1 of `report.md`, not encoded as subset combinatorics in Lean.

`telescope` is the exact sum identity for any rational sequence.
`averaged_deletion_bound` takes arbitrary rational sequences `F,A` and
positive denominators, positive natural `T`, a rational span bound `B`,
nonnegative rational divisor budget `D`, and a positive common lower
bound `c` for the denominators. Its one-step hypothesis is the result
obtained by dividing the incidence inequality by the number of edges.
It proves the consecutive-level average bound `sum(A)/T <= B/T + D/c`.

`finite_pool_average_bound` specializes the denominators to
`n+1-ell-k`, for `0 <= k < T`, using natural truncated subtraction.
It quantifies over all natural `n,ell,T`, assumes `ell,T>0` and
`ell+T<=n+1`, and proves the precise final denominator
`n+2-ell-T`. Its rational `F` and `A` are the mean records and full
divisor probabilities at the successive levels; it assumes their
one-step inequalities, which the regular-incidence theorem establishes
after normalization. The span `B` is instantiated as `B0-1`.

The report separately proves that the manuscript's actual evaluation
kernels, deterministic patches, mixed-radix records and uniformly
bounded nonzero minors satisfy these hypotheses. Those algebraic and
geometric identifications, the prime-height divisor estimate, and
constant selection are human-readable mathematics, not Lean-checked
conclusions. Thus the compiler certifies the dependence-sensitive
finite combinatorial/averaging core, **not** the entire application
or the full density theorem. Independent review must check those
identifications and this document's reading of the declarations.
