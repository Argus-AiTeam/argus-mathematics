# Formal statement fidelity: C_TOLL_CORE

`Main.lean` formalizes the following algebraic/combinatorial core, not
the entire analytic compatible-barrier theorem.

The bare declaration names are `per_visit_glue`, `junction_paid`,
`normalization_identity`, `normalization_positive`, `sharpness_deficit`,
and `sharpness_error_bound`; all are in namespace `TaggedJumpAudit`.

`TaggedJumpAudit.per_visit_glue` quantifies over arbitrary types A,I,J,
any toll w:A -> nonnegative extended reals, arbitrary left and right
visit maps I -> A and J -> A, and a dust image p:A. It sums over the
disjoint visit index type I + (Unit + J). The middle Unit is one shared
junction **time**. It proves equality to both internal toll sums plus
one w(p). There is no injectivity assumption: different indices may
have the same image, including p, so internal revisits and repeated
image points remain charged. Index types may be infinite, and sums
may be infinite. It does not assert that a topological construction
actually has this visit decomposition; proof.md Sections 1--3 prove
that separate fact for the constructed paths.

`TaggedJumpAudit.junction_paid` has the same objects and additionally
an arbitrary nonnegative extended budget with w(p)<=budget. It proves
that the same full per-visit toll is bounded by the two internal sums
plus that budget. It does not identify separate nonconsecutive visits.

`TaggedJumpAudit.normalization_identity` and
`TaggedJumpAudit.normalization_positive` quantify over every real k>1.
They prove the exact formula and positivity of
k(1-2((k-1)/(4k)))-1=(k-1)/2. These are the scale margin in proof.md
equation (5.1); no finite-parameter sampling is substituted for them.

`TaggedJumpAudit.sharpness_deficit` and
`TaggedJumpAudit.sharpness_error_bound` quantify over every real n>0.
They prove
1-(n/(n+1))^2=(2n+1)/(n+1)^2<2/(n+1), the rational tail bound used
in equation (6.3). The analytic radial-energy lower bound, logarithm
estimates, and passage from this bound to optimality are prose
mathematics in proof.md Section 6, not Lean declarations.

The file does not formalize path continuity, tags, atomless nullity,
incidence constraints, collar existence, jump-cover compactness,
Sobolev regularity, smoothing, coarea, compatibility, the main Koebe
theorem, or the rigidity theorem. The mathematical bridge from this
core to those analytic constructions requires independent human
review and is not certified by a successful compiler run.
