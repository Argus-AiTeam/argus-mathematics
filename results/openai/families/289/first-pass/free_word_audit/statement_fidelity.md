# Statement fidelity: C_MATCH289

The source is `research/free_word_audit/Main.lean`, namespace `FreeWordAudit`,
using Lean 4.31.0 and the host's built Mathlib. There are no additional
project axioms or mathematical hypotheses imported as unchecked assumptions.
Ordinary Mathlib foundations are the trusted library boundary.

## Missing-label matching

`missing_left_unique`, `missing_right_unique`, and `missing_label_unique`
quantify over any type of labels, any finite multisets `A`, `B`, `W`, and
any labels `a`, `b`. A singleton is a multiset of multiplicity one, and
`+` adds multiplicities. The hypothesis is exactly `A + B + {a} = W`.
The declarations show that fixing two of the three entries determines
the third. Repeated labels are allowed; no disjointness or distinct-label
hypothesis is present.

`missing_energy_le` quantifies over any decidable label type, a multiset
`W`, a finite set `s` of triples `(A,(B,a))` satisfying that same equation,
a finite set `I` of pairs `(B,a)` containing the pair from each edge,
and an arbitrary nonnegative real weight `w` on `I`. Its conclusion is
that summing `w(B,a)` over edges does not exceed its sum over `I`.
There is no bound on the alphabet size, multiset size, or edge-set size.
The proof uses the injectivity of the edge-to-`(B,a)` map, not a row-degree
bound. `missing_right_unique` provides the symmetric uniqueness needed
for orthogonality within a row in the analytic application.

In report.md (10)--(11), `A` is the output submultiset, `B` the input
submultiset, `a` the missing label, and `w(B,a)` represents
`||L_(e_a) xi_B||^2`. The Lean statement establishes the combinatorial
non-overcounting of these energies. It does not construct those
projections or prove their Hilbert-space orthogonality.

## Order replication

`all_ones_energy_bound` quantifies over every pair of natural numbers
`m,n` and every real vector `x : Fin n -> Real`. It bounds the squared
output energy of the real `m`-by-`n` all-ones matrix by `m*n` times the
input energy. Zero sizes are included.

`all_ones_constant_attains` proves equality in that energy bound on every
constant vector. For `n>0` and a nonzero constant this vector is nonzero.
Together the two declarations are the real squared-norm calculation
behind the factor `sqrt(m*n)`. The definitions of tuple-order fibers,
their factorial cardinalities, their normalized isometric embeddings,
and the complex/Hilbert-space norm interpretation are provided in
report.md Section 2, not encoded as Lean definitions here.

## Scalar inequalities

`middle_tail_algebra` states `(m-3)^2 <= (m-1)*(m-4)` for every real
`m>=5`. `weighted_cauchy_identity` is the exact identity
`3*(u^2+v^2/2)-(u+v)^2=(2*u-v)^2/2` for arbitrary real `u,v`.
`scalar_tail_lt_two` shows `u+v<2` whenever `u^2+v^2/2<=1`;
it does not require either variable to be nonnegative.
These are the scalar steps used after the binomial coefficient
comparison in report.md (14). The binomial comparison and the
small-length cases themselves are not formalized.

`product_step` states `(1+x)*(1-s-x)<=1-s` for nonnegative reals
`s,x`. `product_defect_bound` quantifies over an arbitrary finite
index set and any nonnegative real sequence on it, and proves
`product(1+x_i)*(1-sum x_i)<=1`. There is no assumption that the sum
is below one; that extra hypothesis is needed only for division in
the analytic application. `through_twenty_six` proves `25*P<=26`
for nonnegative real `P` satisfying `P*(1-s)<=1` and `s<=1/26`.
These statements are the universal finite-product step, not a
numerical check up to a chosen word length.

## Boundary of the formal result

The declaration suite supports C_MATCH289, not a full kernel proof
of C_FW289, C_TL289 or C_MULTI289. In particular it does not define
free von Neumann algebras, the GNS representation, arbitrary Fock-space
tails, the domain-restricted operator cuts, operator-valued tuple matrices,
the scalar restoration expansion, or stars-and-bars counting. The
all-parameter analytic argument is report.md Sections 1--4 and needs
independent human mathematical review. A successful compiler run must
not be described as having formally verified those additional statements
or the universal Kadison--Kastler theorem.
