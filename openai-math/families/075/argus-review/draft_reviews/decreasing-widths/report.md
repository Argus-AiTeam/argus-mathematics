# The retired decreasing-width shortcut

**Assessment: invalid implication, correctly retired; not a manuscript
refutation.** This unit has no separate historical claim id. It is the
argument represented by `R_ER_DECREASING_WIDTHS` in the old ledger and by
the matching ruled-out route in the old graph.

The attempted shortcut would infer that interval widths decrease under
refinement because their upper and lower endpoints each decrease. The
exact rational example already given in the old report is

```
(upper,lower) : (3/4,1/2) -> (2/3,1/4).
width        :     1/4  ->     5/12.
```

Both endpoints strictly decrease and remain in `[0,1]`, with lower at most
upper, but width increases by `1/6`. A single-coordinate model suffices
to refute that implication; it supplies no entropy realization, no failed
instance of the full offer contract, and no counterexample to the search
theorem. The exact calculation is freshly reproduced by
`finite-search/replay_math.py` and recorded in its JSON output.

Section 04 explicitly says the difference of the two decreasing endpoints
need not decrease, and instead telescopes upper endpoints at entry against
lower endpoints at exit. The old report and the formal `ordered_sweep`
use that same distinction. Thus this failed audit approach was already
avoided by the manuscript, not a newly found flaw in it.

The route is carried into the active ledger and retired with that exact
mathematical reason. It is not reopened, replaced by a larger numerical
search, or counted as a second result because it also appears in the
graph and report. This is an elementary known algebraic obstruction to
one proposed attack; no originality or publishability claim is made.
Native independent review of the assessment remains pending.
