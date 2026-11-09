# Statement fidelity: support-only odd-prime denominator filtration

The declarations in namespace `OddPrimeBound` certify the algebraic core of
the universal theorem in `report.md`, not Catalan's irrationality and not the
arithmetic digit congruences by themselves.

`weighted_det` quantifies over every commutative ring, every finite decidable
square index type, every ring element p, every natural column-weight function,
and every square matrix. It proves exactly that scaling column j by p^(w j)
scales the determinant by p raised to the sum of the weights. Mathlib's
`det_mul_row` has precisely this column-indexed formula despite its name.
`det_mem`, `scaled_det_mem`, and `bounded_denominator` quantify additionally
over an arbitrary subring S. The last theorem requires p in S, the entrywise
weighted-integrality hypotheses, and the sum of weights at most D; it concludes
p^D det(M) in S. Taking S to be the subring of p-integral rationals translates
this conclusion to v_p(det(M)) >= -D, including a zero determinant.

`loss_cap` quantifies over natural n,R,S,r,s with r+s <= n, r <= R,
s <= S. Its conclusion is the simultaneous bound 2r+s <= 2n,n+R,2R+S.
`pair_loss` quantifies over natural n,d,q,k and proves the lower-range loss
bound when k >= d-q, with natural subtraction. `retained_count` quantifies
over arbitrary integer endpoints A,b,J,K, assuming 0 <= b <= A and K <= J.
It proves the positive-part identity equating the retained-column count to
the manuscript R, including K <= 0 and J <= b. Positive parts are max(x,0).

`central_residue` works over every commutative ring, with arbitrary finite
sets s,t and coefficient functions V,Y,a,sign. Its hypotheses state that the
central residue is minus the sum of the represented and exceptional parts,
that Y_l = sign_l V_l on s, and that sign_l squared is one there. It proves
that adding sum(sign_l a_l Y_l) cancels exactly the represented part.
The application partitions the residue indices into s,t and sets
a_l = 1/(j-l); the prime and range conditions making these inverses legal,
and the formulas for V and Y, are proved separately in `report.md`.
No disjointness of s,t is required for the purely algebraic identity.

`scaled_shear` quantifies over every commutative ring and proves the exact
entrywise equation p(x+p sum(a_l Y_l)) = px+sum(a_l p^2 Y_l).
`secondary_terms` and `paired_terms` quantify over every field and all
displayed coefficients, with p nonzero. They prove the exact rational
decomposition and pair cancellation formulas; the arbitrary y1 coefficient
is retained and becomes integral, not discarded.

What the compiler does not verify: the binomial and carry arguments, the
digit and central congruences, the existence of the integral column
operations used in the theorem, the specialization to the manuscript rows,
the equivalence of local subring membership and rational valuation, or the
analytic identity of the algebraic raw entries with the original integrals.
The first five arithmetic/linear-algebra matters have explicit proofs in
`report.md`; the analytic identification remains outside this mission.
The full universal arithmetic theorem therefore has a prose proof and a
kernel-checked decisive algebraic core, not a fully formalized proof.
