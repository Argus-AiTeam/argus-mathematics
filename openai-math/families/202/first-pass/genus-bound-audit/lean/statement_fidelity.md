# Statement fidelity: the certified algebraic core

`GenusAudit.determinant_frobenius` quantifies over every commutative ring
of prime characteristic p and every square matrix indexed by an arbitrary
finite decidable type, including the empty type. It proves that taking
entrywise pth powers raises the determinant to the positive pth power.
It does not itself construct the kernel/cokernel bundles, check coordinate
versus frame conventions, or prove that their local presentations glue.

`GenusAudit.genus_recurrence_numerator` quantifies over six rational
numbers. From the height-one genus identity and the image-degree identity
it derives p*v=q*next+(p-1)*image. It has no positivity hypotheses and
does not identify the input numbers with geometric degrees.
`GenusAudit.prefix_weights` proves the finite geometric-sum identity for
every rational discount t and every natural length; t=1 is included.

`GenusAudit.length_le_sum` and `GenusAudit.profile_error_bound` quantify
over every finite list of positive natural stage ranks. The latter uses
an arbitrary rational h and a nonnegative rational discount t, and proves
that the recursively discounted error is at most
(h+1)*(1-t^length)+(1-t)*(sum-length).
For the geometric application t=1/p, h is the rank-loss allowance and
sum=log_p(d). The proof is valid even without the additional t<=1
hypothesis; that hypothesis is needed later when interpreting the
weights and maximizing over lengths in the prose theorem.
The maximizing length and its geometric realizability are not claimed
as Lean theorems.

`GenusAudit.degree_lattice_rounding` concerns all integers N,A with N>0,
N dividing A, and A>-N. `GenusAudit.exact_degree_bound` applies it to all
integer genus and branch degrees with a rational loss satisfying the
stated strict threshold. Neither declaration asserts that a geometric
divisor exists, that its degree is divisible by N, or that a cover has
the required profile.

Thus this file certifies the universal algebraic and arithmetic steps
used by the full geometric proof in report.md. It does NOT formalize
thm:inseparable-genus, normalization, cohomology, the elliptic twist,
the marked-point degree estimate, or the blockwise Alperin weight
conjecture. Those distinctions are part of the mathematical claim.
