# Statement fidelity: truncated boundary-cursor isolation

The Lean namespace is `FiniteRuleBoundary`. The declarations described here
are `no_unary`, `no_step`, `trace_fixed`, `no_contains_zero`, `cursor_nonzero`,
`cursor_not_releasable`, `parameter_uniform_counterexample`, and
`chosen_position`.

## Objects and quantifiers

`Structural.core p` denotes the manuscript's `C(p)`; `palette n` denotes a
palette cell of color `n`; `stop` denotes `S`. `Marker.boundary` is the
transaction cursor `B`, not the verifier phase `B_j^{gate}`. `Cell` retains
these fields, a unary-format-validity flag, and a checker-idleness flag.
The omitted metadata and payload of the concrete witness are explicitly
specified and checked in `exact_certificate.json` and `verify.py`.

`cursor p` is the format-valid core cell with marker `B` and idle/absent
checker fields. `parameter_uniform_counterexample` quantifies over all
natural numbers `q,p`, assuming `3 <= q` and `1 < p < q`. It proves that
`p` is in the core range, the singleton cursor is nonzero in the encoded
replacement/zero system, and it cannot be released. `chosen_position`
specializes to `p=2` for every `q>=3`. Applying it to `q=2^h` requires the
manuscript's large-parameter layout premises, not a numerical claim about
the unspecified `h_0`.

## Deliberate overapproximation, not a hidden completeness hypothesis

`Unary` includes both directions of cursor creation at `C(1)`, both
directions of boundary/full conversion at `S`, and **every** full-to-full
unary control change. The latter includes a strict superset of all allowed
tour, gate, interclause, and success phase changes. Payload and register
guards are dropped; no additional boundary-cursor source is dropped.

`Rule.wider` permits **every** length-preserving replacement with source
length at least two. `Step` places these rules in arbitrary word contexts,
and `Trace` permits arbitrary finite sequences. Thus the absence of a step
from the singleton is not a search bound or an assumption of one-way
computation.

`UnaryZero` deliberately enlarges the semantic zeros: all right markers,
all left markers, and all full heads are allowed to be zero. It also
includes invalid formats and nonidle checker palette cells. `DeclaredZero`
permits every factor of length at least two to be zero. These enlargements
still do not zero the chosen format-valid boundary cursor. `Nonzero`
means no replacement-equivalent word contains one of these zero factors.
`Released` means every cell has an idle transaction marker.

## Source translation and limitations

The finite source-exhaustiveness check is human-readable: palette operations
are all binary; acquisition/release is either unary creation at `C(1)` or
binary cursor transport; the only unary boundary/full conversion is at `S`;
all other unary verifier rules have a full head on both sides. Every
manuscript unary zero falls within the enlarged zero cases above. The
manuscript states that these are the complete lists. `verify.py` pins and
checks the relevant source passages. Independent review must still confirm
that this reading exhausts the actual rules and that truncated `L*B`
regions fall within the unqualified rollback sentence.

Lean verifies the stated projected system and its uniform theorem. It does
not parse the LaTeX, prove the validity of the bit-field transcription,
formalize the dual-number matrix representation, or verify the fixed-point
program. The direct matrix argument in `proof.md` independently certifies
nonzero status over any field once the unary-source reading is confirmed.

No declaration claims that complete regions fail to roll back, that a
consecutive-cut interval lacks normalization, or that clean encoding fails.
Neither target lemma nor either main theorem is formally refuted or verified
by this file. This is a scope-qualified intermediate-assertion counterexample,
not a publishable certification of the full construction.
