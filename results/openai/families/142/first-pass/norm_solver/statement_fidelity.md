# Formal statement fidelity

`Main.lean` formalizes the finite-precision bridge and two algebraic parts
of the fiber lift, not the complete norm solver or any analytic theorem.

## Finite-precision sections

The coefficient field `k` is arbitrary. `I` is any finite index type.
`c i` and `w i` are integral formal power series over `k`. They represent,
respectively, a standard rational coordinate multiplied by T^m and
a basis matrix entry multiplied by T^m, at one specified entry of one
local model. `scaledEntry c w` is their sum of products, so the actual
matrix entry is T^(-2m) times this series. The formal theorem does not
assume or prove that a particular geometric local model has these
representatives: that identification is proved in report Sections 2--3.

`coefficient_from_truncations` says, for every natural n<r, that the
nth coefficient of this sum of products equals the coefficient computed
from both inputs truncated at precision r. `finite_precision_integrality`
says that X^(2m) divides the scaled entry if and only if every coefficient
below 2m of the truncated computation is zero. This is precisely local
integrality of the unscaled entry. `finite_precision_fiber` identifies
the coefficient at 2m using precision 2m+1. `divided_constant_term`
identifies that coefficient with the constant term after exact division
by X^(2m). `finite_precision_section` combines these into an integrality
equivalence and the correct residue whenever the division is possible.
All m, fields, finite index sets, and input series are universally
quantified, including m=0. No convergence or bounded experiment is used.

## Power and fiber algebra

`stabilized_powers` and `stabilized_idempotent` hold in every monoid.
The hypothesis b^(r+1)=b^r is explicit. They prove stabilization and
idempotence of b^(r+1). For the manuscript use r=q-1, Cayley--Hamilton
supplies this hypothesis from the characteristic polynomial
T^(q-1)(T-1). The formal source does not prove Cayley--Hamilton's
application, that characteristic polynomial, or the rank of the
resulting generic idempotent.

For arbitrary n and a field k, `outer v w` has entries v_i w_j.
`outer_idempotent` proves its idempotence assuming sum_j w_j v_j=1.
`outer_column_formula` gives every column-action value as a scalar
multiple of v; `normalized_column_nonzero` proves v is nonzero under
the same normalization. Together with the column formula evaluated at
v, these are the elementary rank-one calculation, but no declaration
asserts a Mathlib matrix-rank theorem. `outer_in_block_upper` proves
membership in a block-upper matrix pattern when v is supported on the
block numbered zero and block numbers are natural numbers in increasing
order. It does not find the trace-pairing kernel or prove the geometric
block-upper description.

The source contains no axioms, placeholders, or `sorry`. Its use of
Mathlib's power-series and finite-sum results is checked by the real
Lean compiler. The certificate is evidence only for these declarations.
The uniform local bounds, residue-root algorithm, bundle argument,
complexity analysis, and extraction of h remain mathematical proofs
to be read independently; a successful compile is not attributed to
those unencoded assertions.
