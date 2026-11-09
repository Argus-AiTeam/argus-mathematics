# Statement fidelity: C_ODD_PATH_UNIFORM

`OddPath.uniform_contraction` and `OddPath.uniform_nonzero` quantify over
every finite ordered list of `Column = Fin 4`. A value `r` represents the
positive column length `r.val + 1`, not `r.val`. The only hypothesis is
that the sum of those lengths is odd. This also excludes the empty list
and gives every positive odd path length, including one. No bound on the
number of columns or path length is imposed; no ordering by column
height is imposed.

The coefficient ring is the integers. `test` is the four explicitly
displayed integral matrices `Q M_i Q^{-1}`, where
`Q = [[1,1],[1,2]]`, `M = (I,Z,T,J)`, and
`J = [[0,1],[-1,0]]`. `conjugator_inverse`,
`test_is_conjugate`, and `test_basis_determinant` certify the change of
basis and the coordinate determinant 4. Thus over the complex numbers
these covectors are an ordered basis. The determinant is not a claim
that they are a basis of the integral lattice Mat_2(Z).

## What is contracted

`raw` is a sum over letter indices, not a definition by the desired
matrix recurrence. At an odd global slot its left index is the row
letter and its right index is the column letter; at an even slot these
are interchanged by `oriented`. Its coefficient includes `J` on every
edge and sums both the exiting letter and next entering letter. These
are exactly the alternating column-layer pairs at odd edges and
row-layer pairs at even edges. Each pair is in increasing path order.
The first index is fixed to 0 (the manuscript's letter 1).

`terminal` selects the dummy outgoing index 1. This is not a changed
physical endpoint: `terminal_edge` proves `J[b,1] = delta(b,0)`,
so the final column-layer letter is fixed to 0, the manuscript's
letter 1. `single_position_endpoint` explicitly checks the no-pair
case.

`words` lists all permutations of the initial `r.val+1` basis indices;
`sign` is (-1) to the inversion count. `column_words_length` and
`column_words_count` check that each word has the required length
and that factorially many terms occur. `column_words_membership`
identifies the list with all permutations of the initial basis entries;
`column_words_nodup` excludes repetitions. `altTensor` independently
sums their signed raw index contractions. `tensor` nests these
column sums in the given consecutive order and carries the correct
global parity to the next column. `contraction` is this full expansion
with the two physical endpoint letters fixed as above. Expanding these
definitions gives the actual two-layer generator paired bilinearly
with the dual column-alternating tensor.

`raw_eq_matrix`, `altTensor_eq_matrix`, and `tensor_eq_matrix` prove
the index-to-matrix and distributive bridges for arbitrary words and
lists. The raw transfer is `oriented(p,N_i) * J`, not a stipulated
normalized segment matrix. `actual_contraction_bridge` extracts its
endpoint entry. `adjugate_bridge` checks the manuscript's minus sign
`J X^T J = -adj(X)` for an arbitrary integer matrix.

## Why the conclusion is unbounded

`column_matrix_table` proves the eight signed permutation sums directly,
using the raw definitions. `normalized_state_closed` checks the finite
local closure relation on the eight signed conjugated Pauli matrices
and the two boundary parities. The finite calculation alone is not the
theorem: `all_length_state` proves its invariant by induction on an
arbitrary list. `finish_eq` relates boundary parity to the sum of column
lengths. `odd_state_endpoint` proves that every possible odd endpoint
is -3, -1, 1, or 3. `weight_positive` proves that the product of column
factorials is positive.

The final exact equality is
`contraction rs = epsilon * weight rs`, for an integer epsilon in
{-3,-1,1,3}; hence the contraction is nonzero.

## Limits

No tensor-product or Specht-module library is assumed. The formalized
object is the explicit finite coefficient expansion of the tensor
pairing, as described above; identifying the covectors as a dual
polytabloid and deducing a complex representation constituent use the
separately recorded representation-theoretic inputs. The formalization
does not prove Saxl's conjecture, the universal tensor-square theorem,
the strip/coordinate-sector arguments, attachments, capacity bounds,
finite-degree computations, or novelty/significance.

For the companion's differently ordered band generator,
`u = (-1)^(m-1) u_(m,2)` is a separate orientation comparison.
The theorem here is for `u` in increasing path order, exactly as in
`path:contraction` and `band:path-support`. The overall scalar sign
does not affect the derived nonvanishing.
