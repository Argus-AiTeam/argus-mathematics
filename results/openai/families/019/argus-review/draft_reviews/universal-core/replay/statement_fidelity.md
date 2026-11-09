# Statement fidelity of the unchanged collar core replay

Current claim: `DR019-CORE`, context `CTX-DR019`.
Source: `research/draft_reviews/universal-core/replay/Main.lean`.
The source is an unchanged copy of the old `Main.lean` attached to
`C9000019-COLLAR-CORE` version 2. This document describes the following five
declarations in namespace `CollarRootAudit`, not the analytic collar lemma.

## `rational_collar_capture`

`X` is any compact topological space; Hausdorffness of `X` is not assumed.
`N` is any open subset of `X`, and `v : X -> Real` is continuous.
`lower`, `a`, and `upper` are real numbers with `lower < a < upper`.
`a` is irrational. For every point `x` outside `N`, the value `v x` equals
the real image of some rational number. The complement and its set of
values need not be finite.

The conclusion gives rational numbers `r` and `R` with
`lower < r < a < R < upper`, and says that every `x` satisfying
`r < v x < R` belongs to `N`. These quantifiers express containment of
the entire inverse image of the open interval, not containment of a
selected set of points or just a skeleton.

The proof uses compactness of the closed complement, continuity of `v`,
closedness of a compact subset of the real line, exclusion of the
irrational value, an open interval neighborhood, and density of the
rationals. Its geometric application still requires separate proofs of
compactness of the analytic window, openness of the chosen node tubes,
continuity of the pulled-back valuation, and rationality at every point
outside those tubes. No Berkovich space, model, valuation, finite cover,
or analytic root is a Lean object in this declaration.

## Arithmetic declarations

`circuit_genus_balance` quantifies over all integers `n` and `g` and proves
`2*(n*g)-2 = n*(2*g-2)+2*(n-1)`. It checks the numerical genus balance;
it does not assert existence of a residue cover.

`circuit_stability_balance` quantifies over all integers `n`, `g`, and
`val` and proves
`2*(n*g)-2 + (2+n*(val-2)) = n*(2*g-2+val)`.
There is no positivity or graph-realization hypothesis in this identity.

`unramified_stability_balance` quantifies over all integers `d`, `g`,
`gp`, `val`, and `valp`. Assuming
`2*gp-2 = d*(2*g-2)` and `valp = d*val`, it proves
`2*gp-2+valp = d*(2*g-2+val)`. The Riemann-Hurwitz and valence equalities
are hypotheses, not conclusions; degree positivity and stability are
supplied only in the geometric application.

`stable_tree_side_impossible` quantifies over natural numbers `N` and
`total`. The hypotheses `0 < N`, `total+1 = 2*N`, and `3*N <= total`
imply `False`. The source does not encode a graph or prove the
degree-sum formula for a tree side with one boundary half-edge. The
positive-size hypothesis is explicit in the signature. It is redundant
over the naturals, since the tree equality already rules out `N=0`.
The variable-name linter warning is not a proof hole.

## Certification boundary

The source has no custom axioms, `sorry`, or placeholders. Mathlib supplies
the standard topology, real and rational number foundations, and the
`ring` and `omega` tactics. Compilation and the real axiom audit certify
these five statements only. Statement fidelity is a human mathematical
assessment, not a compiler verdict.

Resolution of nonsingularities, model reduction, residue-cover existence,
tame lifting, annular factorization, binomial convergence, connected
finite-etale common covers, and the manuscript's full collar lemma remain
outside this formalization. They are assessed separately in
`research/draft_reviews/collar-root/report.md`. Neither compilation nor
the finite example certifies downstream patching or a section conjecture.
