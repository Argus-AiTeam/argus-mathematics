# Statement fidelity: C_BC

The source is `research/backward-charge/Main.lean`, namespace `BackwardCharge`.
The intended mathematical claim is the universal backward-charge mechanism of
`joins.tex`, labels `join:backward-decomposition`, `join:later-omissions`, and
`join:capacity`, for histories obeying the structural operations in
`tables.tex`. It is not the quantitative first-join bound or the manuscript's
main Diophantine theorem. `report.md` proves the manuscript instantiation.

## Universally quantified finite-sum core

`invariant_fiber_average` quantifies over arbitrary finite tuple and color
types, an additive group on the color type, an arbitrary real weight, and a
family of weight-preserving bijections that add the requested color. It proves
that the zero-color sum equals the unrestricted sum divided by the color
cardinality. No success independence, freeness, or group law on the chosen
bijections is assumed.

`lift_individual_digits` constructs these bijections from individual coordinate
lifts on any finite product of additive commutative groups. `digit_average`
proves the resulting exact average. `residue_space_card` identifies the number
of colors for products of `ZMod q`, for every nonzero natural modulus `q`, as
the product of those moduli. `unit_digit_lift` proves the elementary unit
inversion needed to select a translation power. In the manuscript the digits
are the **original minus ancestor numerators**, modulo the distinct later
omission primes, not the image numerators.

`raw_minus_update` is the exact complementary matched/unpaired retention rule.
`linked_success_mean` derives the mean total deletion from the individual
indicator means and their actual raw link masses. `correlated_covariance` and
`correlated_step_bound` quantify over all finite orbit types and all real
prefixes, deletion totals, and success parameter. Their hypotheses are only
the two stated first-moment equalities, plus nonnegativity of the total link
masses for the inequality. The covariance is not replaced by zero.
`raw_minus_nonnegative` uses row capacity and upper bounds on indicators and
the success probability to prove nonnegative retention.
`matched_currency` and `residual_mask_transition` keep the residual plus factor
and before-/after-mask coefficients distinct.

`preserved_currency` states termwise equality for **any** function of future
mask tags, assuming that a nonzero link preserves its tag. `broadKernel`
uses two probability factors. `clippingKernel` uses equality of outer tags
and exactly **one** probability factor. These are separate definitions.

`projected_transport` quantifies over arbitrary finite origin types `X,Y`,
image types `A,B`, a finite additive color group, nonnegative real link
matrices, nonnegative capacities, and a nonnegative image kernel. Tuples are
`(A x B) x (X x Y)`. It requires color-shifting, weight-preserving bijections
of the **expanded tuples**, not invariance of a future survival predicate.
Its first conclusion is exact equality for the projection-only fiber.
Its second is an upper bound for any additional predicate `allowed`, by the
image-capacity sum divided by the number of colors. Column bounds are
hypotheses about the actual matching matrices, not conclusions about final
pair counts. The projection factor is proved, not assumed.

`projection_no_multiplicity` quantifies over any injective current-to-ancestor
map and nonnegative ancestor masses. It bounds a current-label sum by the
single ancestor sum. This does not claim that geometrically coincident
**distinct labels** are identified.

`Chronology` is any sequence of reflexive, symmetric, transitive relations
growing under the natural-number time order. `First` requires connection at
the specified epoch and disconnection at every earlier epoch.
`first_epoch_preserved` assumes that each replacement is connected to its
origin at one earlier time; it proves the same first-sharing epoch for the
replacement pair. `first_epoch_unique` proves uniqueness. No survival of a
replacement at the final join is required.

`ChargeData` packages the actual nonnegative matrices, capacities, image
kernel, arbitrary restriction, and structural color-bijection data.
`ChargeData.loss_le_charge` derives its charge from `projected_transport`.
It does not contain a field postulating that a loss is already charged.
`BackwardTrace` records the scalar one-step inequalities
`current <= factor * earlier_prefix + projected_loss`, with nonnegative
factors. Those are instantiated using the proved raw update and covariance
lemmas and the grid correspondence, not an assumed global charge inequality.
`complete_backward_charge` proves the carried terminal product plus the
separately stopped capacity charges for traces of **arbitrary finite length**.
`chargedTerms_sum`, `chargedTerms_length`, and `chargedTerms_nonnegative`
give its sum representation, one term per stage, and nonnegativity.

## Manuscript correspondence and limits of kernel checking

For a later omitted prime `l`, `tables.tex` supplies the full pre-`p` core
power `l^nu`, and passing the earlier bad-omission test supplies an unomitted
partner with the same exponent. Translation by `1/l^nu` preserves actual
pre-`p` prefixes and links; its increment on the designated ancestor numerator
is a unit modulo `l`. It preserves `p`-success and all other omission digits.
The disjoint omission supports provide the individual digit lifts.
An actual full orbit can have order `l^nu`; the formal statement does not
incorrectly require the quotient-color lifts to be a group action.

A fixed after-`p` mask determines the later omission portion and current outer
mask. Same-location, assigned-row labels make the ancestor map injective.
The matching columns are bounded by residual-scaled plus weights, which are
exactly the plus arrivals on success. A static side uses an identity matrix.
The image kernel contains the widened distance, success indicators, carried
ordinary factors, and the appropriate unchanged outer-mask kernel.
Earlier component membership instantiates `Chronology`.

These facts about the LaTeX grids and histories are proved in `report.md`;
Lean checks the universal finite mathematical implication once they are
supplied. It does not check the LaTeX, the construction/existence of those
histories, the mask-selection estimates, the bounded mismatch-restoration
constant, the subsequent sum over stopping primes, the analytic roundoff,
the partition/sparse inputs, novelty, or publication significance.
The finite Python fixtures and the bounded Jacobian calculation cannot fill
any such gap and are not represented as doing so.

There are no new axioms or proof holes in the source. The declarations use
the ordinary foundational axioms of Lean/Mathlib (propositional
extensionality, classical choice, and quotient soundness). An independent
Reviewer must decide whether the proved instantiation and scope justify the
natural-language claim; the compiler cannot decide statement fidelity.
