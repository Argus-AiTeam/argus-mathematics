# Statement fidelity: terminal suffix and ordered two-path coefficients

`Main.lean` formalizes two universal finite combinatorial statements, not the
entire stochastic collision proposition. Its declarations are in namespace
`CollisionCertificate`.

## `terminal_suffix_bound`

The type `V` is an arbitrary type with decidable equality. `Z` is any finite
set of free vertices, `U` is a proper subset of `Z`, and `M` is the set of free
endpoints of the additional edge. The functions `left` and `right` give the
two older endpoints of each birth's backward edges. An endpoint outside `Z`
is a fixed boundary vertex, and thus is retained regardless of `U`.
`backwardCount` counts the two backward-edge slots retained for a vertex
of `U`. The final indicator counts the additional edge exactly when all
its free endpoints lie in `U`.

`parent_slot` says that the vertex born at the preceding non-root call is
one of the two attachment endpoints. `Upward Z parent m v` is a finite
sequence of parent steps starting at `m` and ending at `v`, with each
newly reached parent in `Z`. `cover` says every free vertex is reached
this way from a free mark. It does NOT assume that `U` is closed, nor
does it assume the edge-count conclusion.

The conclusion is that the number of retained backward-edge slots plus
the additional edge is at most twice the cardinality of `U`.
`marked_closure` is the intermediate propagation theorem: a subset
containing the marks and closed under parents contains all free vertices.

For the manuscript's terminal suffix, every suffix birth lies on a path
ending at a marked suffix birth; parent-first ordering keeps that path
inside the suffix. A non-root call's two focus edges both contain its
new vertex, proving `parent_slot`. If a suffix birth's preceding call is
a root or lies before the suffix, choose either attachment endpoint for
`parent` outside `Z`; the cover never needs a step past the first suffix
birth. Different backward slots correspond to different graph edges
because each birth has two distinct older endpoints and a distinct new
vertex. The extra edge is not a backward edge. These graph-to-slot facts
are proved in the accompanying report, not by the Lean declaration.
No connectedness of `Z`, or assumption that both marks are in `Z`, is made.

## `forkMultiplicity_closed`

For every natural number `n`, `forkMultiplicity n` is
`sum_{s=0}^n sum_{a=0}^s binom(s,a)`, and the theorem says this number plus
one equals `2^(n+1)`. With `n` non-root calls, `s` calls on the two arms
and `n-s` on the common trunk, `binom(s,a)` is the number of interleavings
of arms of lengths `a` and `s-a`. Thus the universal coefficient identity
is `2^(n+1)-1`; its exponential generating function is
`2 exp(2x)-exp(x)`.

The coefficient-to-integral correspondence and the infinite-series
identity are ordinary mathematical arguments in the report. The compiler
checks the finite coefficient theorem for every `n`, not just tested `n`.

## Limits

This source does not formalize probability spaces, conditional independence,
the good-prefix existence theorem, the analytic unfolding stability proof,
or an infinite series. Those are not claimed as kernel-verified. There are
no added axioms, `sorry`, `admit`, or non-kernel evaluators.
