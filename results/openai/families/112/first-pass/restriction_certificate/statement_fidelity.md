# Statement fidelity: independent CNF restriction theorem

## Target

Claim `C_RESTRICTION_INDEPENDENT` concerns the clause-count-independent
restriction lemma in the staged OpenAI manuscript, Lemma `lem:restriction`
in `sections/02_restriction.tex`. The primary formal declarations are
`RestrictionCertificate.independent_restriction` and
`RestrictionCertificate.manuscript_corollary` in `Main.lean`.

The former proves the stronger expected expansion-mass bound one under
theta <= 1. The latter preserves the manuscript's strict theta < 1 and
its expectation bound 1/(1-theta), with the original simultaneous
quantifier over all real-valued test functions. It does not certify the
manuscript's particular path-defined cost or the full circuit lower bound.

## Objects and quantifiers

`V` is an arbitrary finite coordinate type with decidable equality. There
is no fixed dimension and no positive-dimension assumption. In particular,
`V` may be empty. It represents the manuscript's finite set `[d]`.

`Assignment V` is `V -> Bool`. A `Clause V` consists of a finite `scope`
and an arbitrary Boolean `pattern` on V. The clause is false exactly when
all coordinates in its scope equal the pattern. Thus it is precisely a
normalized non-tautological OR clause, with distinct scope variables.
An empty scope is a constant-false clause. True and tautological clauses
are removed before this representation; removal changes neither the
Boolean function nor its width bound.

`CNF V` is a `List (Clause V)`, with no bound on its finite length. Repeated
clauses and arbitrary overlapping scopes are retained. `cnfValue` is the
product of the 0/1 clause values. Its empty-list value is one. The predicate
`width k H` bounds every individual clause's scope cardinality by k.
It imposes no clause-count or disjointness condition.

`Restriction V` is `V -> Option Bool`. `none` is live; `some a` is frozen to
a. `fill r x` overrides the frozen coordinates of x with r. For
q=(1-p)/2, `weight p q r` is the product over coordinates of p for `none`
and q for either frozen bit. `sum_weight` proves that these nonnegative
weights sum to one when p+2q=1. This is exactly the law obtained by first
choosing T by independent p-retention and then choosing uniform rho outside T.
The final theorems assume precisely 0 < p < 1.

The natural numbers k and b are unrestricted except for 1 <= b in the
expansion-width and correlation conclusions. In particular, k=0 and k<=b
are allowed. `theta k b alpha` is the finite binomial tail with terms
`choose(k,j) * alpha^j` for b<j<=k. `theta_eq_Icc` proves equality to
that inclusive interval sum, and `theta_zero_of_le` proves that the tail
is zero for k<=b. The final theorems set alpha=2p/(1-p).

## The actual finite construction

`expand b H r` is a recursively constructed finite list of pairs
(real coefficient, CNF). It is not an assumed expansion oracle.
The recursion removes satisfied clauses, returns the zero expansion for
a falsified clause, attaches a reduced narrow clause, or subtracts a
unit-guarded cofactor expansion when the reduced clause is wide.
`close c r` freezes the clause scope to its falsifying pattern.

`denote E x` is the sum of coefficient times CNF value.
`mass E` is the sum of absolute coefficients before cancellation.
`expand_correct` proves pointwise equality on every full assignment:

    denote (expand b H r) x = cnfValue H (fill r x).

`expand_width` proves that every CNF in this actual expansion has width
at most b whenever 1<=b. The requirement b>=1 is used for the unit guards,
not silently omitted.

The correctness proof includes the full cofactor identity
`insertion_identity`; it does not assume the manuscript's reverse-path
recurrence or import an upstream CNF theorem. Empty formulas, false
clauses and empty live sets go through the same recursion.

## Product-law expectation, including all dependencies

`event_switch`, `weight_switch`, and `fiber_reweight` give a concrete
change of variables on the entire finite restriction space. A coordinate
permutation swaps `none` and the falsifying frozen bit on D. It bijects
the event with compatible live clause scope D to the event that the
clause is fully falsified.

`hard_reweight` sums over all D contained in the clause scope with |D|>b.
It holds for an arbitrary real function f on restrictions, so dependence
of a prefix's mass on the frozen assignment is retained.

`expected_mass_step` proves the exact identity

    E mass(new expansion)
      = E mass(prefix expansion)
        + (subsetTail(scope,b,alpha)-1)
            * E[1(clause fully falsified) mass(prefix expansion)].

Here E is the explicit finite weighted sum and p=alpha*q. No factor is
declared independent. `expected_mass_le_one` inducts on the arbitrary
finite clause list. `subsetTail_eq_binomial` and `subsetTail_le_theta`
prove the combinatorial conversion to the width-k binomial hypothesis.
`expected_mass_uniform` concludes E mass<=1 under the final product law.

## Exact live tests and arbitrary real-valued functions

`supported r J` requires every variable in every clause of J to be live.
The lemmas `restrictCNF_value`, `restrictCNF_width`, and
`restrictCNF_supported` explicitly construct restriction of a CNF,
preserve its width bound, and remove all frozen-coordinate scopes.
`supported_value` proves that applying fill to a supported CNF changes
none of its values.

`tests b r` is the finite set of Boolean truth tables represented by
supported width-b CNFs. This is the manuscript's class C_b(T), using the
original coordinate labels instead of a separately renamed subtype.
Both constant tests are allowed, and `tests_nonempty` explicitly supplies
the constant-true test. `corr b r G` is the actual finite maximum over
these truth tables of the absolute uniform correlation.

`average` uses the full uniform cube, with fill applied inside the
correlation. This duplicates every live assignment the same number of
times. `average_live` proves the equality between the full-cube average
of any function of live coordinates and the normalized average over the
live-coordinate subtype, including when the live set is empty.

`G` ranges over every real-valued function on the full cube, evaluated
only at `fill r x`. This covers every real-valued function on the live
cube by extension off that slice, with no boundedness, Boolean-valuedness,
sign, nonnegativity or independence assumption on G.

`expansion_correlation` proves the finite triangle-inequality estimate.
`restriction_correlation` applies it to the actual expansion and the
actual finite maximum. The existential W in `manuscript_corollary` is
explicitly `fun r => mass (expand b H r)`, chosen before the `forall r G`
quantifiers. Thus there is one W for all G, not a G-dependent cost.

## What the compiler does not establish

The source imports Mathlib, not the OpenAI manuscript or comparator code.
Its only foundational axioms are the ordinary classical Mathlib/Lean
foundations reported by `#print axioms`; no theorem in this file is left
as an axiom, a hole, or an external assumption.

This is an independent formal certification of a known mathematical
clause-insertion argument. Li-Zhong, arXiv:2610.27127v1, Lemma 3.1,
present that argument and attribute it to Chukhin. No novelty of the
mathematical expected-mass bound is claimed. The compiler does not check
the accuracy of this interpretation document, the historical attribution,
publishability, or any of the manuscript's other main-theorem ingredients.
Those are separate independent Reviewer questions.
