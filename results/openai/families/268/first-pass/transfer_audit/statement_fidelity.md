# Statement fidelity: arbitrary chronological tensor words

The claim is `C_TRANSFER_CORE`, not either physical spectral-gap theorem.
All declarations are in namespace `TransferAudit` in `Main.lean`.

`Site` is any finite site type, `Local` any finite local basis type, and
`R` any commutative semiring. Both finite types have decidable equality.
Empty site and local types are allowed. There is no bound on their
cardinalities. In the application they are the physical sites,
`{x,y,z}`, and the complex numbers, respectively.

`tensorMatrix A` has row and column indices that are functions
`Site -> Local`. Its `(x,y)` entry is the product over sites `i` of
`A i (x i) (y i)`. Thus it is the ordinary sitewise tensor/Kronecker
matrix in the product basis, not an entrywise product of local matrices.
The finite product is of scalars; local matrix multiplication remains
noncommutative.

`tensorMatrix_mul`, `tensorMatrix_one`, and `trace_tensorMatrix` establish
the multiplication, identity, and trace laws for this actual matrix.
`tensorMatrix_word` applies them to any `List Event`, including the empty
list, for any event type and any assignment of a local square matrix to
each event and site. `List.prod` multiplies from the head on the left.
No commutation or reversal of local event matrices is assumed.

`trace_tensorMatrix_word` proves that the global ordered word trace is
the product of the local ordered word traces, for every word length.
`prod_filter_identity` removes identity insertions while retaining list
order. `trace_supported_word` combines these results: at each site only
the events selected by the arbitrary Boolean incidence function remain,
in their original order. In the manuscript application a bond event is
incident on two sites and a field event on one; the theorem does not
need this restriction. Scalar event coefficients are multiplied outside
the trace by ordinary multilinearity.

In the application a list is the globally time-sorted event list, and
filtering on site incidence gives the merged histories at that site.
The formalization does not sort real timestamps, construct the history
measure, prove convergence of any exponential expansion, formalize
infinite-dimensional operator theory, prove rotation covariance of the
specific spin matrices, or state a Hamiltonian/partition-function
identity. Those steps are separate arguments in `report.md`; the finite
spin and orientation calculations are replayed by `verify.py`.

Consequently a successful compiler run certifies the unrestricted
algebraic factorization used in both transfer proofs, not a complete Lean
proof of `C_TRANSFER`, either uniform gap, or novelty/publication status.
