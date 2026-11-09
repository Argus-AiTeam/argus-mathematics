# Statement fidelity: the conditional Hilbert-space core

Claim: `C_SUPPORT_CORE`. Source: `Main.lean`, namespace `RecordTransfer`.

The manuscript target is `transition.tex`, `ct:support`, and its use in
`ct:old-records` and `ct:new-record`. The formal source proves the
measure/topological Hilbert-space step, not the whole SAT theorem.

**Objects and quantifiers.** `H` is an arbitrary real inner product space
with its norm topology and Borel measurable structure. It is not restricted
to finite dimension or to a finite support. `mu` is any measure on `H`.
The hypotheses use iterated almost-everywhere quantification with the same
measure in the two coordinates. For the probability laws used in the
manuscript, these are exactly the two-independent-copy hypotheses, by
Fubini. For a conditional law one applies the same theorem separately for
almost every ancestor global history; conditional independence is not
silently replaced by unconditional independence.

**Declarations.**

* `pair_interval_on_support` extends a closed interval bound on the inner
  products of two independent copies to every pair of support points.
  Its proof closes each section in turn, including diagonal support pairs.
* `old_record_on_support` uses the interval
  `[-delta^2, delta^2]` to prove `norm v ^ 2 <= delta ^ 2`
  on the entire support. It permits any real `delta`; the application has
  `delta > 0`.
* `band_diameter_on_support` proves
  `norm (v - w) ^ 2 <= 2 * epsilon` for all support points when all
  independent-pair inner products lie in `[a, a + epsilon]`.
* `band_center_on_support` proves the same squared-radius bound around
  every `m` in the closed convex hull of the support, with
  `epsilon >= 0`. Its conclusion does not assume a finite convex
  combination. The barycenter of a bounded probability law is such an
  `m`; the identification of the manuscript's continuation-law type with
  that barycenter is proved in `record_transfer.md`, not encoded here.
* `old_record_ae` and `band_center_ae` give the corresponding
  almost-everywhere conclusions using conullness of the support. These
  declarations require `SecondCountableTopology H`, satisfied by the
  separable Hilbert spaces of the application.
* `advertised_tolerance` proves, for arbitrary real numbers,
  `errorSq <= 2 * J * gamma` and
  `gamma <= delta^2 / (2 * J)`, with `J > 0`, imply
  `errorSq <= delta^2`.

**Instantiation and boundary of formal coverage.** For an old block,
`H = L2(du_0:b)` and `v` is its error function. For a new block, take the
weighted Hilbert direct sum of the finitely many `L2(du_0:b)` spaces, with
weights `1/J`; `v` is the vector of continuation test means and `m` its
conditional-global barycenter. The result gives the stronger joint
inequality `sum_j error_j^2 <= 2 * J * gamma`, hence every advertised
record. Construction of these Hilbert-valued random variables, their
conditional laws, weak convergence of decorated arrays, site strong laws,
partition-selected reindexing, the probability-valued type, and exponent
bookkeeping are mathematical arguments in `record_transfer.md`. They are
not claimed to be compiler-checked. No assumption of the manuscript's
record conclusion appears as a formal hypothesis.

The compiler establishes the declarations as written. Independent review
must still assess this interpretation and the nonformal mathematical
arguments, as well as novelty and significance.
