# Historical comparator and statement fidelity

**Assessment: supported as a source-status claim at the named revision,
not as a prior proof or a novelty result.** The claim is
`S_ER_COMPARATOR@1`: at repository revision
`301488868beec11bfd897168433b0a64f5258559`,
`lean/ComparatorChallenges/FourierLLogL.lean` ends the `paperMain` proof
with `sorry`. This comparator is not present in the staged local reference
tree; its primary pinned sources were obtained directly:

- https://raw.githubusercontent.com/openai/math/301488868beec11bfd897168433b0a64f5258559/lean/ComparatorChallenges/FourierLLogL.lean
- https://raw.githubusercontent.com/openai/math/301488868beec11bfd897168433b0a64f5258559/lean/docs/075.md

The exact decisive source fragment is the closing proof `:= by` followed
by `sorry`. The declaration is `OAI.FourierLLogL.paperMain`; it quantifies
a complex function on `AddCircle (2*pi)`, assumes a.e. strong measurability
and integrability of `norm(f)*log(2+norm(f))` with respect to the circle's
Haar measure, and concludes a measurable Haar-null set outside which
the symmetric sum over the integer interval `[-N,N]` tends to `f(x)`
as natural `N` tends to infinity.

Thus it states the intended **full-sequence**, complex-valued endpoint
claim, rather than a subsequence or summability-method substitute.
The use of a `2*pi` circle versus normalized unit-circle coordinates
requires the ordinary change of variables, not a different convergence
problem. No proof of this analytic theorem is supplied by the hole.

At that same revision the scope page says the formalization proves the
theorem. That prose description conflicts with the actual proof body.
For proof completeness the body is decisive: allowing a placeholder to
elaborate is not a hole-free certificate. The review does not compile or
commit that hole-bearing file as an active proof. It also makes no claim
about later or other repository revisions.

The old supporting judgement
`judgement-S_ER_COMPARATOR-a4b92dd6789b` was by the engineer, not the
independent Reviewer. Its report artifact is preserved unchanged.
The current primary-source inspection corroborates the literal old status
claim; it is not a new independent acceptance of this review.

This comparator is a supporting reference unit, counted once even though
the old report and ledger both discuss it. Its incompleteness does not
prove that the manuscript is false, that no other formal proof exists,
or that the old Argus finite-search formalization is novel. The latter is
a different theorem, with a much narrower scope.
