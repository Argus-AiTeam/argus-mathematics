# Statement fidelity: finite labeled matching core

`Main.lean`, namespace `ArbitraryCenterTail`, proves finite algebraic
inequalities used in the verification of `prop:pattern-tail`. It does not
formalize spheres, cap estimates, the terminal merger, probability measures,
the Poisson limiting argument, target selection, or the final asymptotics.

The index type `I` is any finite type with decidable equality, including the
empty type. Labels are never quotiented by equality of the sets they will
represent. Thus repeated slot sets retain distinct labels.

`noDiagonal f` forbids `f i = some i`, and `rightUnique f` requires distinct
occupied rows to have distinct occupied columns. `offChoices` contains every
such partial row assignment. `edges f` is its directed off-diagonal edge set.
`incident` is the union of the source and target labels. No acyclicity,
symmetry, distinct-slot-set, or geometric separation assumption is made:
directed paths, two-cycles, longer cycles, and full permutations all occur.

For arbitrary real `a i >= 1` and nonnegative real edge weights `w`,
`matchingPolynomial a w` sums over all off-diagonal partial matchings and
over every subset of their nonincident vertices. A selected vertex has
diagonal-loop weight `a i * a i - 1`; an off-diagonal edge `(i,j)` has
weight `w (i,j) * a i * a j`. Every directed partial matching between
two labeled copies is encoded uniquely by its off-diagonal row assignment
and its set of diagonal loops. This correspondence is a reading of the
definitions, not a separately formalized equivalence with a Poisson model.

The principal declaration `self_diagram_product_bound` states

    matchingPolynomial a w
      <= (product_i a_i^2) product_i (1 + sum_{j != i} w_ij).

`diagonal_loop_sum` proves the exact sum over compatible diagonal choices.
`endpoint_product_le` and `normalized_matching_term` prove the endpoint
normalization for every directed partial matching: coordinate injectivity
allows each vertex to occur at most once as a source and once as a target.
`row_choice_budget` proves the all-row product bound, not a bounded
enumeration.

To apply this to the manuscript, take
`a_i = sqrt(1 + 1/lambda_i)` and
`w_ij = mu(E_i intersect E_j) /
sqrt(lambda_i (1+lambda_i) lambda_j (1+lambda_j))`.
Then a diagonal loop has weight `1/lambda_i`, and an off-diagonal edge
has weight `mu(E_i intersect E_j)/(lambda_i lambda_j)`.
The elementary real-square-root substitution and identification with the
Poisson covariance are established in the accompanying mathematical report,
not encoded in this Lean file.

`cross_diagram_product_bound` states that summing nonnegative edge products
over any subfamily of a finite edge powerset is bounded by the unrestricted
product `product (1+h_e)`. It does not itself take the exponential of the sum
or take the exponential of the sum. `nonempty_cross_diagram_bound` removes
the empty term exactly, under the explicit hypothesis that it is absent
from the family. The subsequent exponential bound is justified in prose.

`thinning_exponent` is the real-algebra step for the indexed Janson bound:
for `0 < m <= d`, thinning with `q=m/d` gives exponent at most
`-m^2/(2d)`. It assumes neither independence nor a probabilistic inequality.

There are no user axioms, admitted statements, unchecked computation
declarations, or proof holes in the intended formal source. Successful
compilation certifies the declarations above only; it is not a kernel
certificate for the full manuscript proposition or a novelty assessment.
