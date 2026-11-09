# Collision-only objection: Engineer assessment

**Disposition:** the historical objection is correctly retired. Its failure
does not establish the entire manuscript, and it is not evidence that an
original manuscript assertion was refuted.

## Proposed attack and provenance

The old ledger's `R_COLLISION_ONLY` targets `C_BETTI_CHL` v1 and has no
obligation claims. The old proof graph also marks this route ruled out.
Its mathematical content is preserved in section 1 of
`families/043/first-pass/determinant_cover_transfer/report.md`
and `literature/known_inputs.md`.

The proposed inference was: Mellit's distinct-last-eigenvalue hypothesis
fails at the scalar collision parameter, therefore the manuscript's
relative product-stratification input or its full Betti conclusion is false.
The intended application has generic ordered determinant-one eigenvalues,
with no proper nonempty subproduct equal to one, and scalar point
\(q=(\zeta,\ldots,\zeta)\) for primitive \(\zeta\). Such a point can be
generic in the subproduct sense without having distinct entries.

## Decisive distinction

In the published *Toric stratifications of character varieties*,
`doi:10.1007/s10240-025-00158-0`, Theorem 7.5 concerns generic,
nicely ordered diagonal puncture data with distinct last eigenvalues.
That is the regular-semisimple Lefschetz input.
Proposition 8.7 is about the **flag-enhanced relative family over the
entire generic ordered base**, not just that locus. At collisions it
permits nonsemisimple last monodromy. Its proof uses an auxiliary affine
bundle and vector-bundle refinements over torus-affine products with
the base, mapped by projection.

Thus absence of distinct eigenvalues prevents applying Theorem 7.5
directly at the collision fiber; it does not negate Proposition 8.7.
The old positive route applies Lefschetz first on the distinct locus
and then uses relative constancy and weight-compatible transport.
The failure of a direct specialized invocation is not a counterexample
to that different route.

The published proposition was read in this review's primary-source task;
see `../full-betti-lefschetz/primary_sources.md`, printed p. 233 and the
setup on pp. 227-228. The old notes identify the corresponding locator
as Proposition 8.4.1 in `arxiv:1905.10685v1`. That older numbering is
historical attribution, not an additional fresh reading of that version.
No inference here depends on the numbering match: the published
statement itself resolves the objection.

## Supported conclusion and residual boundary

The collision-only inference is invalid; retaining its explicit retirement
reason prevents reopening the same argument. This neither proves every
claimed property of the flagged family nor proves full fixed-determinant
P=W. In particular, Proposition 8.7 is not by itself a smooth-morphism
theorem or a theorem about every finite cover. Those checks are supplied
by the positive prose arguments assessed in the transfer and Betti units.

This is a failed Argus attack, not a new construction, theorem, experiment,
or finding against OpenAI's manuscript. No new error search was undertaken.
There is no computation or Lean statement whose replay would decide the
logical mismatch. The current ledger records the retired route with the
reason, while preserving the original historical attribution. Final
independent acceptance of this assessment remains with the native Reviewer.
