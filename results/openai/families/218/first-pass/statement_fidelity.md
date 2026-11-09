# Statement fidelity: radial Vandermonde and charge cancellation

## Principal kernel theorem

`Radial.vandermonde_identity_all` quantifies over every finite, decidable,
linearly ordered index type `I`, every function `z : I -> Complex`, and
every natural number `m`, with the sole hypothesis `card I = 2*m`.
There is no bound on `m`, no geometric symmetry assumption, and no
injectivity assumption in this final theorem. Thus it includes the empty
list and even colliding points. The charge-weight application below
requires distinct points because its negative distance powers otherwise
are undefined.

The theorem states

    sum_(S subset I, |S|=m)
      Dsq(S) Dsq(I\S) normSq(2 sum_S z_i - sum_I z_i)
      = 2 sum_(T subset I, |T|=m+1) Dsq(T) Dsq(I\T).

Here `Radial.vandermondeSq z S` is `Dsq(S)`: the product of
`Complex.normSq (z_i-z_j)` over exactly those pairs in S with i<j.
`Complex.normSq` is the real number re(z)^2+im(z)^2, not the norm
and not a fourth power. Consequently Dsq(S)=|D(S)|^2 for the
Vandermonde determinant on the induced order. The sign of that determinant
does not matter.

Associate S with the positive-sign sites of a sign assignment.
Then total charge is 2|S|-2m, and `Radial.moment z S` is exactly
sum_i mu_i z_i. Each balanced assignment occurs once, as does each
charge-two assignment. This is the manuscript's
`eq:rad-vandermonde`, with its printed coefficient 2, not a rescaled
or fixed-cardinality surrogate.

## How the kernel proof obtains the identity

`Radial.balanced` is the subset amplitude
1/product_(i in S,j outside S)(z_i-z_j) on subsets of size m, and
zero elsewhere. Its denominators occur only in the intermediate theorem
`Radial.vandermonde_identity`, whose hypothesis `Injective z` makes
them nonzero.

The proof uses Mathlib's kernel-proved Lagrange interpolation theorem
to prove `balanced_raising_zero` and `balanced_raising`; complementation
then proves `balanced_lowering_zero`. No quadratic charge identity
is a premise of any of these results.

`Radial.singlet_energy` proves the second-moment identity from explicit
finite up/down operators and their adjoint relation. Its hypotheses
that a vector is killed by the two unweighted operators are discharged
by the preceding interpolation lemmas for the actual amplitude.
`vandermonde_partition` clears the denominators and matches the actual
products of Vandermonde norms. Finally, a kernel-proved continuity
argument using injective perturbations gives
`vandermonde_identity_all` without the injectivity hypothesis.

The printed axiom reports for the principal declarations contain only
`propext`, `Classical.choice`, and `Quot.sound`, the usual Lean/Mathlib
foundations. There are no added axioms, admitted statements, or proof holes.

## Original charge weights and the modular bridge

The staged source is the bulk-Ising September 23, 2026 manuscript,
`build/sections/radial.tex`, definitions beginning at line 147,
Lemma `rad:identity` at line 163, and polynomial equation at line 185.
For distinct points let d_ij=|z_i-z_j|>0.

`Radial.original_pair_exponent` proves, for every positive real d and
every pair of Boolean signs, that `pairWeight d` equals
d^(mu_i mu_j/2), with `chargeSign true=1` and
`chargeSign false=-1`. Taking the edges to be all ordered pairs i<j
makes `Radial.edgeWeight` precisely the manuscript's w_X(mu).
This preserves the original half exponents; no replacement weights
are being silently assumed.

`edgeWeight_product` proves, for every finite edge set and every
pair of sign assignments, that the factors crossing the
agreement/disagreement partition cancel. The remaining factors are
the inverse distance product times the squared-distance products on
equal-sign pairs. On the complete edge set these are exactly
q(A)q(B) times the two Vandermonde-norm products.

`sum_agreement` proves the bijection reindexing *all* pairs of sign
assignments by the agreement assignment and the first sign assignment.
There is no division by two. `agreement_zero_zero`,
`agreement_two_two`, and `agreement_two_minus_two` prove the three
charge restrictions used in the regrouping. `zero_charge_first_moment`
and `chargePartition_reversal` prove the sign-reversal cancellations
and W_-2=W_2 for any reversal-invariant weight; `edgeWeight_reverse`
discharges that invariance for the original weights.

`charge_normalization_from_grouping` checks the final real algebra:
from N_0 W_0=2(U+V), U=W_2^2, V=W_2 W_-2, W_-2=W_2, and
W_0 nonzero, it concludes N_0/W_0=4(W_2/W_0)^2.
The three regrouped-sum identifications are explicit hypotheses of
this modular declaration, not a disguised assumption of the target
charge identity. Their all-cardinality derivation from the proved
bijection, weight factorization, subgroup Vandermonde identity, and
vanishing first moments is written in `audit_report.md`.

The complete normalized charge identity is therefore given as an
ordinary mathematical proof with these kernel-checked components.
There is no single Lean declaration here asserting the whole normalized
W_s sum identity. The kernel certificate is attached to `C_RAD_VD`;
the ledger must not silently report `C_RAD_CHARGE` as kernel-closed.
The executable checks replay the actual grouped sums exactly on
the listed examples, but those finite tests are not the universal proof.

## Angular cancellation and its precise boundary

`Radial.angularSquare u` is the average of Re(u)^2 over the four
values u, i*u, -u, -i*u: their real parts are re(u), -im(u),
-re(u), im(u). `quarter_turn_complex` proves this is normSq(u)/2.
`weighted_quarter_turn` proves for arbitrary finite types of assignments
and arbitrary real weights p,q that the independently weighted angular
average of Re(A_X conjugate(A_Y))^2, including the exponential factor
1/8, is

    (sum p normSq(A_X)) (sum q normSq(A_Y)) / 16.

The weights can thus be exactly w_X/W_0(X) and w_Y/W_0(Y).
No uniform measure or spatial symmetry of X or Y is assumed.
`quadratic_from_moments` substitutes the charge identities
moment_X=4a_X^2 and moment_Y=4a_Y^2 and proves the square-root
quadratic coefficient is zero. `square_root_quadratic` checks the
same final scalar polynomial directly.

The report separately derives the logarithmic Taylor coefficients of
the printed squared-correlation formula, the vanishing angular
frequencies one and two, and the positive-square-root Taylor formula.
It explains why averaging the root is legitimate here: its linear
coefficient is already independent of rotation. These analytic
identifications and the O(t^3) Taylor remainder are ordinary
mathematical arguments, not additional Lean declarations.

Neither the continuum spin formula, reflection positivity,
Hilbert-space spectral argument, uniform operator estimate, nor the
full universality theorem has been formalized or independently
certified by this artifact. Independent review of the prose bridge,
statement translation, significance, and novelty is still required.
