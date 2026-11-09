# Statement fidelity

`BoundedPathCore.occurrence_multiplicity_bound` quantifies over every finite
occurrence type `O`, every block type `B`, every assignment `block : O -> B`,
and every involutive map `mate : O -> O`. Fixed points of `mate` are unmatched
occurrences. Its hypothesis `hnoself` excludes a matched pair on the same
underlying block. For every block, the conclusion is twice its number of
occurrences at most all occurrences plus all unmatched occurrences. Applied to
one link component, this is precisely the no-self-link multiplicity inequality.
Applied to incidences at a vertex and their actual path-turn pairing, with
half-edges as blocks, it is the local inequality used in the stage incidence
proof. These applications and their translation from graph paths are explained
in `theorem.md`; Lean does not encode paths or perform that translation.

`BoundedPathCore.stage_coarea` quantifies over every finite edge type, every
natural multiplicity function, and every natural upper bound on it. It equates
the sum of stage sizes (stage `j` in the formal statement means manuscript
stage `j+1`) with total multiplicity. Zero multiplicities and an empty edge type
are allowed. This is an identity, not an independence or probability assertion.
The same theorem applies to vertices with their maximum incident multiplicity.

`BoundedPathCore.component_budget_bound` is a universal real inequality.
Its hypotheses are exactly the nonnegative scale, upper weight bound, bin
error, and unmatched count, together with `2*z <= S+b` and the lower/upper bin
bounds. Its conclusion is the component estimate with finite bin error
`c*(S+b)`. No integer, maximum, or counting hypotheses are silently encoded:
those are supplied by the preceding mathematical construction.

`BoundedPathCore.weight_contraction` checks the three rational class-row
estimates for the actual `q=128` squared-turn transfer, against
`weightLambda = 71589573988/72026254783`. The identification of the three
classes with the manuscript alphabet, and the induction from a positive-vector
bound to word-mass decay, are proved in prose and replayed arithmetically by
`verify.py`, not formalized here.

The Lean source does **not** formalize the random-matching model, conditioning,
grid construction, word-extension counts, probability bounds, or the whole
bounded-path theorem. A successful compiler run certifies the four stated
finite/universal cores only; it is not kernel certification of
`C_BP_QUANT`, the main group-algebra theorem, or novelty.
