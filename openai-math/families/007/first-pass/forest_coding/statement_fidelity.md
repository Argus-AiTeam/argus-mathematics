# Statement fidelity: ForestCoding

`Main.lean` uses Lean 4.31.0 and Mathlib. It proves universal core lemmas,
not numerical examples. The full structural theorem and its manuscript
specialization are proved in `report.md`; this file does not describe that
entire proof as kernel-checked.

## Linear algebra declarations

`dependent_pair_saturates` quantifies over every field `K`, every `K`-module
`V` with an additive commutative group, and vectors `e,w`. If `e` is nonzero
and the two-vector family is dependent, `w` is a scalar multiple of `e`.

`maximal_pair_saturates` quantifies over an arbitrary independent family
`old`, and arbitrary `e,w`. Its quotient is exactly by the span of `old`.
It assumes that the quotient image of `e` is nonzero and that adjoining
both `e,w` as separately indexed vectors is not independent. It concludes
that the quotient image of `w` is a multiple of that of `e`. Thus it checks
the maximal-pair extension argument, not an independence assertion modulo
numerical primes. Application to all lit-occurrence pairs is in the report.

`regular_run_nonzero` has arbitrary independent directions, label, and
nonzero scalar increment; it proves that the vector increment is nonzero.
`independent_balance` and `independent_polygon_impossible` rule out a closed
finite vector polygon with distinct independent directions and nonzero
coefficients. The latter explicitly assumes closure as a sum of
differences. The translation from a graph cycle to this polygon is in the
report, not hidden in the Lean theorem.

## Segment decoding declarations

`endpointDecoder` is one decoder depending only on an abstract graph and
its two endpoints. It returns `none` on disconnected endpoints and
otherwise the vertex support of a chosen simple path.

`endpointDecoder_correct` proves, for every acyclic simple graph and every
walk whose consecutive undirected edges differ, that the decoder recovers
that walk's whole vertex sequence. `nonbacktracking_walk_unique` proves
equality of any two such walks with the same endpoints.
`endpointDecoder_labels` also recovers the sequence after filtering by an
arbitrary line-vertex type predicate. These are all-length statements;
acyclicity is a hypothesis, established for the incidence graph in prose.
The nonzero-run and distinct-adjacent-label hypotheses are what give
nonbacktracking in that application.

## Code and coefficient-union declarations

`Code n r B I` is the product of `4n` bits, a forest integer less than
`2^(6n+3)`, and `E=(6r-4)B+I` entries of `Fin (2n)`. All public parameters
are natural numbers. `record_budget` assumes `r>=1`, `d<=2r-2`,
`S<=(d+1)B`, `O<=dB`, and `actualI<=I`, and proves the precise used-slot
bound. `code_card` proves the exact cardinality of this fixed code type.
The typed-forest framing and mask/representative decoder construction
are justified in the report and implemented over rational witnesses by
`verify.py`; their full implementation is not formalized in Lean.

`coefficient_uniform_injection` and `coefficient_uniform_card` quantify over
an arbitrary, not necessarily finite, type `Witness`. The predicate
`valid w p` can express arbitrary numerical coefficients, fields, padding,
or other witness data. The theorem requires a witness encoder into the
**same** `Code n r B I` and a **single** decoder satisfying the displayed
decode/encode identity for every witness. It constructs an injection of
the existential union `{p | exists w, valid w p}` into that code space,
and proves its cardinal bound. It does not merely bound each fixed
witness fibre. It does not infer a shared decoder from separate fibre
cardinality bounds. Constructing the encoder and proving its identity
for the forest witnesses is the substantive prose argument in the report.

`Pattern n` is a function `Fin n -> Fin n`, sufficient to carry the
canonical restricted-growth word of every equality partition. The
formal cardinal theorem is stronger in allowing any such functions.
No theorem in this file asserts either main correlation theorem or
global novelty. No theorem assumes translated residues independent.
There are no project axioms or proof holes; standard Lean/Mathlib logical
axioms are those of the imported library.
