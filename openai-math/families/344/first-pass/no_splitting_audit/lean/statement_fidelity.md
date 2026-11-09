# Statement fidelity: rectangular Schur algebra only

In namespace `NoSplittingAudit`, `schur_completion` quantifies over all natural numbers
`k,m` and real matrices `V : k x k`, `H : m x m`, and `U,R : k x m`.
It proves exactly the displayed rectangular polynomial identity.
No commutation of matrices is asserted. For the analytic application in
equation (6) of `../proof.md`, set `H=H'(a)` and
`U=C'(a) H'(a)^{-1}`. Symmetry and invertibility of the positive
matrix `H'(a)` imply `U H=C'(a)` and
`H U.transpose=C'(a).transpose`. With those substitutions the
identity is the completion of the square in the endpoint derivative
of the Schur complement. Those substitutions, differentiation, and
positive semidefiniteness are justified in prose, not in this Lean theorem.

In the same namespace, `schur_reversal` quantifies over all natural numbers
`k,m`, a real `k x k` matrix `V`, a `k x m` matrix `C`, and an
`m x m` matrix named `Hinv`. The name is a variable name, not a
formal inverse assumption. The declaration proves the algebraic sign
identity when `V,C,Hinv` are all negated. In the endpoint application,
reversing endpoints negates all three differences and replaces the
inverse of the invertible regular block by its negative, giving
`Q(y,x)=-Q(x,y)`. The real-matrix inverse sign rule is not encoded here.

Both statements also allow zero ranks; their application uses positive
`k,m`. Neither declaration proves the determinant-root inequality,
the scalar integral identity, the pole expansions, positivity of the
derivative remainder, the folded integral comparison, equality
propagation, or a theorem about Riemannian manifolds. A successful
compiler run certifies these two algebraic declarations only.
