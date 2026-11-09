# Statement fidelity: the real-ratio conditional-scales bridge

## Declarations and claim

This document describes `GeometricBridge.LocalWindows.conditional_scales`
for ledger claim `C_GEOMETRIC_CONDITIONAL_SCALES`, and the stronger companion
`GeometricBridge.LocalWindows.conditional_scales_sharp`.

The compiler proves a **parameter-uniform window-interface theorem using
the actual finite selector tables, actual recursive routing, and actual
selector-dependent terminal addresses**. It does not merely take fresh
addresses or outcome-independent representatives as hypotheses.

There is an explicit, separate boundary: the Lean file does not implement
the manuscript's entire preorder window-assignment algorithm. Its
deterministic integer endpoint invariants are the fields of `LocalWindows`
and `Predecessors`. Their realization by the original algorithm is proved
in `proof.md`, Sections 1--2 and the field identification below. That
realization is recorded as `A_WINDOW_REALIZATION` in the claim ledger,
rather than hidden behind an unconditional kernel-closure claim. It needs
independent mathematical review; the compiler alone does not certify that
reading of the manuscript.

## Objects and parameter correspondence

* `q : Real` has the original hypotheses `0<q<1`; it is not rational,
  algebraic, dyadic, or restricted to a finite test set.
* Upstream `m` is the number of **nondefault** children. The manuscript's
  total branching is `M=m+1`, so `m=M-1`. The child type is `Fin(m+1)`;
  its final element is the default.
* `U : FiniteTableModel.Node m d` is the first-default node. It is an
  actual finite child path of length less than `d`. The remaining local
  routing length is `d-U.length-1`, not an independent arbitrary depth.
* `r` is the common length of the nondefault outgoing windows at `U`.
  For the manuscript this is exactly `r_h`, with `h=d-U.length`.
  The theorem also permits degenerate empty trial types; this does not
  remove any of the manuscript's positive-integer cases.
* `Trial = Fin m * Fin r`, with index `start(i)+j`, has cardinality
  `m*r=(M-1)*r`. The full manuscript index set is a finite set `indices`
  containing every trial index; it may contain all the other windows too.
* A selector address is a dependent pair of **table tag** `(node,child)`
  and finite periodic key. A terminal address is a dependent pair of
  **leaf tag** and its finite periodic key. Different tags are different
  random coordinates, even if numerical key values agree.

`gridFactor q=4/(1-q)`, `target q b=gridFactor q/q^b`, and
`exponent q b=Nat.ceil(logb 2 (target q b))`.
`exponent_as_integer_ceiling` proves equality to the original integer
ceiling on `0<q<1`, using `target>4`. `resolution=2^exponent`.
The upstream finite grid key has exponent `level+2`, so
`level=exponent-2` and `level_add_two` prove this is **exactly** the
manuscript's resolution, not a rescaled replacement.

The underlying periodic key is `floor(N*Int.fract(x))`, exactly the
half-open convention of the manuscript. Arbitrary negative real centers,
integer wraparound, boundary points, and equal adjacent resolutions are
allowed. Refinement uses nonstrict exponent inequalities.

## Deterministic field identification for the original construction

For the fixed first-default node, set:

| Formal field | Original deterministic value or property |
|---|---|
| `start i` | `a_{(U,i)}` |
| `selectorEnd P i` | `b_{(P,i)}` |
| `terminalEnd L` | Endpoint of the edge incoming to leaf `L` |
| `blockEnd i` | Actual largest endpoint `b^*_{(U,i)}` in the edge/child-subtree block |
| `window_length` | Inclusive interval length: `a_i+r=b_i+1` |
| `small_shift` | `2*q^a_i<=1/4`, because `a_i>=n0` |
| `edge_le_block` | The block includes its incoming edge |
| `block_span` | `b_i^*+1<=a_i+2*r`, by the original span lemma |
| `subtree_selector` | Every selector edge below child `i` has endpoint at most `b_i^*` |
| `subtree_terminal` | Every leaf below child `i` has incoming endpoint between `b_i` and `b_i^*` |
| `previous i` | Endpoint of the immediately preceding window, when one exists |
| `noninitial i` | The outgoing window is not the first window |
| `sibling` | For `j<i`, edge `(U,j)` precedes `(U,i)`, hence its endpoint is at most `previous i` |
| `ancestor` | If `P++[c]` is a prefix of `U` and `j<=c`, edge `(P,j)` precedes every edge out of `U` |

These are integer endpoint/order properties, **not** hypotheses asserting
address injectivity, independence of random variables, or existence of a
representative set. `proof.md` derives them by the actual preorder block
construction, including the bottom-length case `r1=r0`, arbitrary
`g>=1`, and arbitrary allowed `n0>=1`. No upstream `WindowData` object
with its different bottom-length/start hypotheses is substituted.

`Predecessors.Stable` uses the original interval
`(x,x+2*q^start(i)]`, with the left endpoint excluded and the right included,
on each relevant noninitial window's predecessor lattice. The original
stable-center hypothesis, which imposes this at every noninitial window,
implies this restriction. It is not strengthened to a two-sided boundary
avoidance hypothesis.

## Atom, probability, and event

The probability space is the product of all selector-address bits and all
terminal-address bits, with measure `LocalWindows.law`. The measures `νs`
and `νt` are probability measures on `Bool`. Their singleton hypotheses
give fair selectors and Bernoulli-p terminals; the theorem assumes the
original `0<p<1`. Every coordinate is independent by the product measure.

`LocalWindows.atom x xi` fixes the addressed center bit at **every**
selector table, not just at tables on the center route, and fixes no
terminal coordinates. `firstDefaultOnAtom` says that throughout this
atom the actual center route first defaults at `U`. This is the original
choice of `U` on the center-exposure atom, not an independence assumption.
The normalized probability is the ENNReal ratio

```
law(miss(indices,x) intersect atom(x,xi)) / law(atom(x,xi)).
```

The explicit positive-atom hypothesis is `law(atom)!=0`; finiteness follows
from the probability measure. This ratio is the finite-space conditional
probability in the original lemma. `miss` quantifies over **all real**
`t` in the closed interval `[1,2]` and every `n` in `indices`, and uses
membership in `RoutedSetDensity.routedSet` with the actual selectors,
actual first-success/default rule, and actual routed terminal bits.

## Derived obligations, not assumptions

`resolution_bounds`, `exponent_mono`, `key_eq_of_finer`,
`center_key_ne`, `window_keys_ne`, and `stable_key` prove the rounded-grid
geometry and the original one-sided stable-key transfer.

`combined_selector_injective` proves injectivity of the combined map
from **all exposed center coordinates plus all fresh trial coordinates**.
`terminal_injective` proves injectivity of the actual selector-dependent
terminal addresses for **every** selector completion. The leaf is selected
without consulting any terminal bits.

`uniform_representatives` proves the quantifier order

```
exists R, forall t in [1,2], exists s in R,
  forall complete selector and terminal outcomes, forall trials,
    test(outcome,s,trial)=test(outcome,t,trial).
```

It uses deterministic lifted affine floors and the upstream monotone-rank
representative theorem, then proves concrete routing locality using
`FiniteLocalPredicate.finite_local_predicate_factors`. It does not assume
factorization of the desired local predicates. Boundary scales and endpoints
are covered by equality of their attained floor vectors.

`local_hit` derives actual membership in the routed set from local success,
using the original stable-key condition, predecessor endpoint inequalities,
and the first-default property. `fixed_failure_mass` instantiates the
upstream probability theorem **after** deriving selector and terminal
injectivity. `local_all_scales_mass` uses the upstream finite exposure union
bound only after deriving completion-uniform representatives.

## Conclusions and their limits

With `k=m*r`, `conditional_geometric_power` gives the stronger exact-power
bound

```
[1+k*(1+2*c/q^(2*r))] * (1-p/2)^k.
```

`conditional_scales_sharp` gives this same improved prefactor times
`exp(-p*k/2)`. `conditional_scales` gives precisely the original prefactor

```
D = 4+2*k*(1+2*c/q^(2*r))
```

times `exp(-p*k/2)`. ENNReal coercions do not change these nonnegative
finite real bounds.

Both final declarations print their transitive axioms. The intended output
is only `propext`, `Classical.choice`, and `Quot.sound`, with no proof-hole
axiom. The generic upstream imports and their dependency closure have been
compiled on Lean 4.31.0; the necessary API-name ports, which do not alter
theorem statements, are listed in `upstream.json`.

This certificate does not formalize the manuscript's full avoiding-set
theorem, mean-density integration, no-default probability, parameter
selection, exceptional-center repair, or global signed-dilation deduction.
The proof graph leaves those edges open. The finite Python experiments
are diagnostics, not substitutes for this universal theorem. Neither the
compiler nor this document supplies independent Reviewer approval,
publication-level significance, or a verified novelty classification.
