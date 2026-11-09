# Statement fidelity: uniform perturbation core

The claim is `C_UP_CORE`. The namespace is `UniformPerturbation`.
This is a universal algebraic verification, not a Lean formalization of
von Neumann algebras, Popa's theorem, or the whole generator problem.

## Prefix objects, indices, and orientation

`gPrefix k` is the product of the first `k` distinct positive generators
of `FreeGroup Nat`, in increasing left-to-right order, starting with
generator `0`. It corresponds to the manuscript's `g_k` after renaming
`FreeGroup.of i` as `s_(i+1)`. `label k j` is the actual group product
`gPrefix k * (gPrefix j)^(-1)`, not a formal ordered pair.

`prefix_factorization` quantifies over every group, every initial element
`a`, every perturbation `q`, and every finite list `xs`. It proves

    a * product(map (q * .) xs)
      = product(conjugates a q xs) * (a * product xs).

The successive conjugating elements are `a`, `a*x_1`, and so on, and
the conjugates are multiplied in that order. In the manuscript use
`a=t_0`, `x_k=u*t_k`, and `q=exp(i*h)`. Thus this theorem gives exactly
the left-perturbation orientation, for arbitrary length; no exponential
identity or norm estimate is assumed.

## Exact collision classification

`prefix_moments` computes the genuine group homomorphism `moments`,
which sends generator `i` to `(1,2*i+1)` in the multiplicative tag of
the additive group `Int * Int`. Its value on `gPrefix k` is `(k,k^2)`.
`label_moments` consequently gives `(k-j,k^2-j^2)`.

`label_eq_iff` proves, for **all** natural `k,j,a,b`,

    label k j = label a b
      iff ((k=j and a=b) or (k=a and j=b)).

It does not assume that reduced words are distinct. Equality is mapped
to the integer moment equations; their nonzero oriented chords determine
both endpoints. The reverse implication uses the group laws.
`label_eq_one_iff` and `finite_label_eq_iff` give the identity criterion
and its exact finite-indexed version with `k.val+1`, matching indices
`1,...,ell` rather than `0,...,ell-1`.

`collision_energy` proves, for every natural `n` (including `0`),
that the fourfold count of ordered pairs of equal labels is
`2*n^2-n`. This count is the sum of squared label multiplicities by
double counting pairs in each fiber; that elementary interpretation is
explained in the report. The theorem does not posit a collision bound.

## Genuine noncommutative coefficients, all degrees

`word atom q` multiplies a finite sequence in the **actual group** `G`,
using `List.prod`; free cancellation occurs in `FreeGroup` itself when
that is the group. `positiveTotal atom a` is a `MonoidAlgebra Real G`
element, with Mathlib's convolution multiplication, not commutative
polynomial multiplication.

`group_ring_expansion` proves for every finite token type, every group,
every real weight family, and every natural degree `d` that the `d`th
power of `positiveTotal` is the sum over all length-`d` token sequences,
using their ordered group products and products of scalar weights.
It is a noncommutative distributive expansion, proved by induction on
`d`; coincident resulting group words are added by the group algebra.

`coefficient_majorization` is more general than the manuscript: it
permits any finite token type, group, subset of sequences, and positive
integer denominator for each sequence. Its hypotheses are only
`0 <= a_i`, `abs(b_i) <= a_i`, and `1 <= D(q)`. It proves that the
absolute value of the filtered, downweighted signed coefficient at
**any** group element is bounded by the coefficient of
`positiveTotal atom a ^ d`. It proves this inequality; it does not
assume an ordered-product, power, or coefficient majorization.

The specialization `all_degree_majorization` has no such auxiliary
majorization hypotheses. It quantifies over all natural `n,d`, all
nonnegative real `c`, and every element `w` of
`FreeGroup (FreeGroup Nat)`. A token is `(row,column,sign)`, with row
and column in `Fin n`. Its outer-group letter is the generator indexed
by `label (row+1) (column+1)`, or its inverse. Each signed coefficient
is `c` or `-c`, and each positive coefficient is `c`.

`orderedCoefficient` sums precisely the nondecreasing-row token
sequences. Its denominator `rowFactorial q` is the product of the
factorials of the row occurrence counts. `rowFactorial_pos` proves the
needed positivity, and the proof discharges the signed-weight bound.
The conclusion is

    abs(orderedCoefficient n d c w) <= (majorant n c ^ d) w.

`majorant` is the actual sum of all positive tokens in the group
algebra. The identification of the nondecreasing-row formula with
the manuscript's sum over exponent tuples is an explicit bijective
expansion in the report, not a formalized theorem about analytic
exponentials. All finite lengths and degrees are covered, not a
bounded enumeration.

The outer group has a generator for every element of the inner free
group, including its identity. This embeds the manuscript's finitely
generated `F_S` without adding relations. The declaration
`identity_label_is_a_generator` explicitly proves that the generator
indexed by inner identity is **not** the outer identity.

## What remains outside the compiler

The report proves the trace orthogonality and first-order correlation
from Haar freeness, the elementary length-one convolution bound,
the coefficient `L2` isometry, convergence and the geometric tail,
and lifting from the tracial ultrapower. Popa's independence theorem
is an external cited assumption with a source passage supplied for
independent attribution. These analytic/literature inputs, the reading
of the source manuscript, the finite-token regrouping just described,
and this document's mathematical fidelity require human review.
No claim of a fully kernel-checked perturbation proposition or of
independent-review acceptance is made.
