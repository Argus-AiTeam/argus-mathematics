# Reading of the formal word-independence theorem

The principal declaration is
`WordIndependence.word_series_linearIndependent` in `Main.lean`.
Its parameter F has only the typeclass assumption `Field F`. The natural
number n is arbitrary with the printed hypothesis `1 <= n`. There is no
characteristic assumption, finite-field specialization, bound on word length,
or bound on degrees of rational coefficients.

The coefficient field is K = `RatFunc F`, with t = `RatFunc.X`, named
`parameter`. Rational functions in z are `RatFunc (RatFunc F)`.
The ambient Laurent-series field is `LaurentSeries (RatFunc F)`, equivalently
Hahn series with integer exponents and well-ordered support.
`expansion` is Mathlib's canonical algebra map from K(z) to this field;
`seriesExpansion` is its standard embedding of K[[z]]. The proved
`expansion_poly` and `expansion_constant` identify these embeddings on
polynomials and constants. In particular, scalar multiplication in the final
`LinearIndependent` assertion is multiplication by the Laurent expansion of
the actual rational coefficient, not coefficientwise multiplication.

Letters are `Fin n`. A formal letter i corresponds to the printed index
`i.val + 1`, so every printed index 1,...,n occurs exactly once.
Words are all finite lists of these letters, including `[]`. `wordSeries []`
is 1 and `wordSeries (i :: w)` is `integrate i.val (wordSeries w)`;
this is prefixing, not appending.

`letterRat i` is exactly z/(1-(1+t)^(i+1)*z) in K(z).
`letterSeries i` is X times the power-series inverse of
1-C((1+t)^(i+1))*X. The denominator has constant coefficient 1.
`letterSeries_denominator` proves its denominator-cleared identity, and
`letterSeries_expansion` proves that its image equals the rational kernel's
Laurent expansion. Thus the rational kernel and the series used by the
recursion are not unrelated input objects.

For coefficient degree r, `integrate` assigns zero when r=0 and otherwise
assigns coeff_r(letterSeries i * g)/(t^r-1). The theorem
`parameter_nat_pow_ne_one` proves every nonzero denominator in every field F.
`integrate_equation` proves rescale(t,integrate(i,g))-integrate(i,g)
=letterSeries(i)*g; `integrate_unique` proves uniqueness among series with
zero constant coefficient. `integrate_add`, `integrate_smul`, and
`integrate_raises` prove linearity and the coefficient-vanishing form of
order raising. No differential or characteristic-zero result is assumed.

`polyScale t` is substitution X -> C(t)*X, extended to the rational field
by `rationalScale`. `laurentScale` multiplies the coefficient of z^j by
t^j for every integer j, including negative j. It is proved multiplicative;
`laurentScale_series` and `laurentScale_expansion` prove compatibility with
both standard embeddings. `laurentScale_inverse` and
`rationalScale_inverse`, also applied to t^(-1), establish invertibility.
The map is the printed sigma, not the Frobenius or a map on t.

`parameter_zpow_ne_one` treats every nonzero integer exponent.
`parameter_fixed_field` states, for every Laurent series f, that sigma(f)=f
if and only if f is the constant series with value coeff_0(f).
`rational_fixed` specializes this to rational functions using the injective
expansion map. The fixed-field property is proved, not an extra hypothesis
of the final theorem.

`alpha i` is ((1+t)^(i+1))^(-1) and `orbit i j` is t^j*alpha(i).
`parameter_power_separation` uses polynomial evaluation at t=0 and
polynomial degree, which are valid in all characteristics.
`orbit_meets_alpha` and `orbit_injective` certify the infinite, disjoint
orbits of these exact kernels.

`RegularAt r a` means that r has a polynomial fraction representation whose
denominator does not vanish at a. `regularAt_iff_denom` proves equivalence
with nonvanishing of Mathlib's reduced denominator, using coprimality.
Consequently the nonregular points are a finite set of roots of a nonzero
polynomial. `regularAt_scale_iff` proves the direction of pole movement.
`no_isolated_difference_pole` proves the two-endpoint contradiction using
the finite set of bad orbit indices, without assuming poles are simple.
`letterRat_regular` verifies the exact kernel poles, and
`word_pole_obstruction` proves that sum_i c_i*b_i=sigma(R)-R forces every
c_i=0. No abstract nonsummability assumption remains in the final theorem.

`difference_word_independent` is a separately proved abstract criterion,
with explicit hypotheses on field embeddings, commuting endomorphisms,
the rational fixed field, and the pole obstruction. Its proof uses induction
on the maximum word length and then strong induction on the number of
nonzero top-length coefficients. Normalizing a top coefficient to 1 removes
it in `wordDelta`. The proved transformation is

    wordDelta(R)(w) = sigma(R(w))-R(w)
                     + sum_a b_a*sigma(R(a::w)).

It does not incorrectly use a derivation rule.
`word_series_finite_relation` supplies every hypothesis for the explicit
series, pads an arbitrary finite support with zeros up to its maximum
length, and concludes that every rational coefficient is zero.
`word_series_linearIndependent` is exactly its standard linear-algebra
formulation. No finite jet test, derivative Wronskian, shift-order bound,
or formula-system theorem is used in this proof.

The official compiler and axiom audit must report exit_code=0 and an empty
proof_holes list for this source and this reading. Only the standard axioms
`propext`, `Classical.choice`, and `Quot.sound` are used. The compiler does not
verify that this document faithfully translates the manuscript; that is the
independent Reviewer's remaining responsibility. This certifies the bounded
word theorem, not the complete hitting theorem or mathematical novelty.
