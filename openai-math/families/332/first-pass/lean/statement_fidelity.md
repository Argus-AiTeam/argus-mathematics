# Statement fidelity: dimension-free cubic flatness

Claim: `C_FLAT18`. Main declaration: `CubicFlatness.flat18`.

The quantified index type `ι` is arbitrary and `s : Finset ι` is any
finite set, including the empty set. All coordinates and all weights
are real. For every index in `s`, `w >= 0`, `0 <= u,v <= 1`, and
`e = 0 or e = 1`. There is no bound on dimension, weights, or the
number of distinct coordinate values. In particular the theorem
includes the manuscript's positive-weight finite cube.

`phi x = 3*x^2 - 2*x^3` is applied coordinatewise.
`energy s w x = sum w*x^2` is the weighted Hilbert squared norm.
`pairing s w x y = sum w*x*y` is its real bilinear inner product.
The conclusion is exactly

    (sum w*|phi(v)-phi(u)|)^2
      <= 18 * (energy(v-e)^2 - energy(u-e)^2
               - 4*energy(u-e)*pairing(u-e,v-u)).

Thus the right side is the quartic potential remainder centered at
the binary vector e, based at u, with increment v-u. In particular
neither the base point nor the sign of the linear correction has
been reversed. Squaring `energy` gives the FOURTH power of the
weighted Hilbert norm; squaring the sum on the left gives the
SQUARED weighted ell_1 norm, not a sum of coordinate squares.

`scalar_zero` and `scalar_bit` prove the scalar cubic bound;
`weighted_cauchy` invokes Mathlib's exact finite Cauchy--Schwarz
theorem, allowing zero weights; `gap_sos` proves the universal
polynomial identity in three arbitrary real variables; and
`quadratic_flatness` combines these ingredients. No local axiom,
unproved helper, `sorry`, `admit`, or numerical approximation is
used.

This formal source does NOT encode a Markov chain, stationarity,
the matrix inverse, arbitrary countable ell_1 input, the sharpness
limit, the Cesaro comparison, or a Lipschitz extension theorem.
Those are separate assertions proved in `research/verification.md`.
Compilation certifies the encoded weighted core, not the entire
cotype theorem and not this document's interpretation. The latter
requires independent human/Reviewer scrutiny.
