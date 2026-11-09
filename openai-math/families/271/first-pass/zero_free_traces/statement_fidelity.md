# Statement fidelity: ZeroFreeTraces

The intended source assertion is the spherical manuscript's
`lem:trace-zero-free` in `02-exchange.tex`, with its ordered real-pulse
and symmetric-slot projection application in `07-pressure.tex`.
`report.md` proves the complete mathematical statement; this source
formalizes its load-bearing general contraction and linear algebra, not
all the surrounding analytic literature or the thermodynamic theorem.

## Complete contraction, not a bounded example

`PairPoly n` is the full coefficient array of a complex multiaffine
polynomial in n input/output pairs. At a positive index the four branches
are the coefficients of 1, x, y, xy; at index zero the array is a complex
scalar. There is no factorization, positivity, symmetry, or degree
restriction beyond multiaffinity. `peval` is ordinary polynomial evaluation.
`contract` retains the 1 and xy branches and discards the other two.
`close` applies this operation to every pair.

`DiskStable p R` states that `peval p x y != 0` for every complex
coordinate vector with `norm(x_i)<R` and `norm(y_i)<1`.
`bivariate_coefficient_bound` proves `norm(D)*r*s <= norm(A)` from
zero-freeness of A+Bx+Cy+Dxy on the open disks of arbitrary positive
real radii r,s. The proof factors a complex quadratic, obtains both root
norm bounds, and takes the norm of their product. It assumes no root
bound or contraction-preservation oracle.

`contract_stable` proves stability after one contraction as a polynomial
in all remaining variables. `complete_cyclic_contraction_nonzero`
quantifies over **every natural number n**, every coefficient array,
and every real R>1 and proves `close p != 0`.
`complete_cyclic_contraction_lower_bound`, under the same hypotheses,
proves

    (1-1/R)^n * norm(peval p 0 0) <= norm(close p).

Thus the formalization includes the entire arbitrary-count iteration,
not merely the elementary bivariate lemma or finite tests.
The report's n is mN for m layers and N slots. Permuting the coefficient
axes orders them by the actual cyclic pairings. The construction of this
array from an arbitrary number of independent layer symbols and equation
(6)'s finite-sum index identification are proved in prose, not encoded as
a theorem about random permutation laws.

## Matrix trace is the actual trace

`State n` is the qubit basis with n Boolean coordinates, recursively
`Unit` and `Bool x State n`. `matrixSymbol` encodes an **arbitrary**
complex matrix on this basis, with the first Boolean branch denoting
the input bit and the second the output bit.
`close_matrixSymbol` proves `close(matrixSymbol M)=Matrix.trace M`
for every n and every such matrix M. The associated
`disk_stable_matrix_trace_nonzero` and
`disk_stable_matrix_trace_lower_bound` are genuine trace statements.
Their hypothesis is zero-freeness of that matrix's entire symbol;
they do not assert that a product's symbol is stable without a proof.

## Actual slot-map algebra and projection algebra

`real_sl2_norm_identity` uses arbitrary real entries a,b,c,d, with
alpha=(a+d+i(b-c))/2 and beta=(a-d-i(b+c))/2. It proves
`normSq(alpha)-normSq(beta)=ad-bc`.
`su11_disk_identity` is the complex polynomial identity (8) of the report.
`su11_open_disk` assumes that this norm-square difference is 1 and
`normSq(x)<1`, and proves a nonzero denominator and a strictly
disk-valued projective quotient.
`field_then_real_pulses_strict` proves the same facts after replacing x
by r*x, for arbitrary complex r,x with `normSq(r)<1`,
`normSq(x)<=1`. Here `normSq` is the square of the complex norm, so
these are exactly the relevant disk inequalities, not componentwise
real interval tests.
The fact that the source's ordered pulse exponentials produce real
determinant-one matrices, and the field ratio is exp(-tz/k), is justified
in the report rather than by a formal theorem about matrix exponentials.

`projected_trace_eq_slot_trace` quantifies over an arbitrary finite
matrix index type, arbitrary complex E and P, an arbitrary first pulse U
and arbitrary finite list of subsequent pulses. Its only algebraic
hypotheses are `P*P=P` and `P*E=E*P`. It proves equality of the trace
with all intermediate projections and the trace of the ordered word
`(EP)U_0 ... (EP)U_(k-1)`. It requires k>=1 through the explicit first
pulse and does **not** assume any pulse commutes with P or with another
pulse. The identification of Ran(P) with the physical spin space is
finite-dimensional representation theory supplied in the report.

## What this compilation does not establish

It does not formalize BBL partial symmetrization, admissible-law
coefficientwise limits, Cayley-domain translation, the assembly of the
general layered tensor network, the physical symmetric-spin
representation, or thermodynamic limits. The manuscript's exact
quantifiers and those bridges remain explicitly proved/read in the
report and source. Claim C_ZERO_FREE_CYCLIC_TRACES records that
non-kernel bridge and the BBL input as assumptions so a successful
compilation of this core cannot silently become an unconditional
kernel proof of the complete manuscript statement.

No axiom, sorry, admitted theorem, finite bound on counts, rational-only
restriction, invertibility assumption on generic slot matrices, or
commutation assumption on pulses is introduced. The compiler result
must be read together with this document and an independent review
of the source-to-formal bridge.
