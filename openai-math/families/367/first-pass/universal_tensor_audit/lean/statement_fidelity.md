# Statement fidelity: the universal cubic contraction core

The claim is `C_CUBIC_CORE`, not `C_UNIVERSAL`. The principal declaration
is `UniversalTensorAudit.universal_stf_quartic` in `Main.lean`.
This document describes that declaration and the three auxiliary theorems
`shape_symmetric`, `shape_trace_zero`, and `stfNumerator_trace_zero`.

The scalar field is the real numbers. Coordinate indices run over `Fin 5`.
The universally quantified function `a : Fin 14 -> R` supplies fourteen
arbitrary real numbers, and `v : Fin 5 -> R` supplies five arbitrary real
numbers. There are no sign, nonvanishing, eigenvalue, or norm hypotheses.

`shape a` is a five-by-five symmetric matrix. Its upper-triangular entries,
in row order, are `a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13`,
followed by the final diagonal entry `-(a0+a5+a9+a12)`. The lower-triangular
entries are their symmetric counterparts. Thus every real symmetric
trace-free five-by-five matrix has exactly one such representation.
`shape_symmetric` and `shape_trace_zero` verify these two structural
properties. The parameterization's coverage follows directly by choosing
the fourteen indicated entries of a given symmetric trace-free matrix;
the file does not separately formalize this coverage statement.

`matVec a v` is ordinary matrix-vector multiplication by `shape a`.
Writing `A=shape a`, `B_ijk=v_i A_jk+v_j A_ik+v_k A_ij`, and
`(J u)_ijk=delta_ij u_k+delta_ik u_j+delta_jk u_i`,
`stfNumerator a v` is exactly `T=7B-2J(Av)`, with no averaging of `B`.
`stfNumerator_trace_zero` proves the trace over its first two slots
vanishes for every remaining index.

`vectorNormSq`, `shapeNormSq`, and `cubicNormSq` are sums of squares over
all ordered component indices. Off-diagonal matrix entries and repeated
symmetric tensor components carry their full multiplicities. The principal
theorem states exactly

    |7B-2J(Av)|^2 = 147 |A|^2 |v|^2 + 210 |Av|^2.

Equivalently, the symmetric trace-free projection of `B/3` has squared
norm `|A|^2 |v|^2/3 + 10 |Av|^2/21`. This is the algebraic identity used
in the proof of the `5/7` bound for contraction of an arbitrary symmetric
trace-free cubic tensor with a unit symmetric trace-free matrix.

The Lean file does not prove the `5/7` inequality by itself: the operator
norm estimate for a unit trace-free matrix and tensor Cauchy--Schwarz are
the separate arguments in `../report.md`. It does not encode the printed
Table I or Table II, their remainder identities, the full universal
interior or boundary proposition, or any geometric realizability or
minimizing-cone theorem. Those distinctions are essential: the formal
quartic identity is one load-bearing part of the complete exact
verification in `../verify.py`, not a formalization of the entire result.
