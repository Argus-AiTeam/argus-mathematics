# Statement fidelity: universal fixed-three height selection

The claim `C_RS_HEIGHT` concerns the universal arithmetic step of the
two-intercept reshaping theorem, not the whole theorem. The Lean file
`Main.lean` imports the host's Lean 4.31.0 Mathlib and declares no new axioms.

All four declarations below are in the namespace `ReshapingAudit`.

`primitive_three_in_interval` quantifies over all real endpoints
`L,U` with `2 < U-L`. It produces integers `i,p,q` strictly between the
endpoints in the first component and satisfying `i*q - 3*p = 1`. The last
equation explicitly certifies that `(i,3)` extends to the oriented integral
basis `((i,3),(p,q))` with determinant one. There is no rationality or
positivity assumption on the endpoints.

`fixed_three_height` quantifies over all real `H,d,w`, assumes
each is strictly positive, assumes `6 <= d^2*H`, and assumes the strict
bound `d*w < 1/3`. Its local definitions are `W=d*H`, `R=H/w`,
`T=d*W=d^2*H`, and `a0=W*T/(1+T)`. It produces integers `i,p,q`
and reals `a,b,t` with determinant one; `a0<a<W`; `b=W-a>0`;
`t=a/b>T`; the exact identities `a=W*t/(1+t)` and `b=W/(1+t)`;
the strictly ordered heights `-3*a < 3*b < i/d`; and the exact range
`i/d+3*a=R`. These are precisely the conclusions in ledger claim
`C_RS_HEIGHT`. They are the heights of `(-b,0),(a,0),(0,1/d)` under
`z -> det((i,3),z)`.

The theorem takes `d^2*H>=6` as an explicit hypothesis. The mathematical
report separately proves that the original intercept definitions
`H=A*B`, `d=max(3/A,2/B)` imply this hypothesis; that implication is not
silently formalized here.

`tent_slice_length` is a universal real algebraic identity
for the difference of the upper and lower affine edges at abscissa `h`.
It does not itself construct a convex hull or a slice.
`compressed_tent_inside_simplex` assumes positive `R,w`,
`0<=h<=w`, and `0<=z<=R*(1-h/w)`, and concludes the nonnegative-coordinate
and normalized simplex inequality. These auxiliary statements formalize
the final slice calculation, not any lattice-point operation.

The compiler does not check the nodal formal-series bound, all-degree
gradedness, row compression, formal specialization of jet matrices,
the polygon slice descriptions, the restoration of labels, or the
full reshaping theorem. Those are proved in `report.md` and require
independent mathematical review. No compiler result is represented as
verifying them, the manuscript's main maximality theorems, or novelty.
