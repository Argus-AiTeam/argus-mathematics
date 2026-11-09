# Statement fidelity: fixed-complement core of word transfer

Claim: `WT-FIXED-COMPLEMENT9000201`. Source: `Main.lean`.

The four declarations in namespace `WordTransfer` quantify over every field
`K` and arbitrary `K`-modules `E`, `F` and `U`. There is no dimension bound,
inner product, choice of orthogonal projection, or simplicity-of-roots
assumption. The application uses finite-dimensional modules.

`block A B C D` is the operator on `E x F` with block matrix
`[[A,B],[C,D]]`. The fixed complement is `F`. `D` is a linear equivalence,
so both sides of its inverse identities are available. The hypothesis
`hS : A = B.comp (D.symm.toLinearMap.comp C)` says exactly that the Schur
complement on `E` is zero, with the order `B D^{-1} C` and a minus sign
in the Schur expression.

`kernel_iff` and `kernel_graph_unique` identify the entire kernel as
`(u,-D^{-1} C u)`, with a unique `u` for every kernel vector.
`fixed_complement_solution` states that for every `b` in the range of this
block operator, `(0,D^{-1} b_F)` is a solution of `M x=b`.

`fixed_complement_sandwich` quantifies over any linear map `L` annihilating
the entire kernel, any linear map `J`, and every `b` in the range of `M`.
Its additional hypothesis is `M(J b)=b`. Its conclusion is
`L(J b)=L(0,D^{-1} b_F)`. Thus, when `J` is the group inverse and the
two spectral coupling conditions have been established, it proves the
fixed-complement sandwich identity used in the report. It also works
for any other choice of a particular solution, a slightly stronger
algebraic statement than the group-inverse instance.

The compiler does not prove that the manuscript's internal chain has
zero Schur complement, that its target eigenvalue is semisimple, that
the endpoint couplings vanish, or that its regularized inverse has a
simple pole. It does not formalize convergence, division evaluations,
spectral degree bounds, active-space specialization, arbitrary free
word extraction, or the main division-ring theorem. These have
separate universal mathematical proofs in `report.md`; the exact
script supplies explicitly bounded diagnostics, not a substitute for
those proofs. No assumption about an arbitrary old-coefficient-factor
input arrow is present or needed.
