# Statement fidelity: the universal arithmetic and character-counting core

`Main.lean` uses Lean 4.31.0 and Mathlib. All scalar quantities below are
arbitrary real numbers, and all indexing sets are arbitrary finite sets.
There are no assumptions about a bounded source alphabet, a bounded column
dimension, or a particular numerical instance.

The unqualified declaration names are `two_response_fiber`, `slice_mass`,
`positive_difference`, `heavy_list_bound`, `excess_domination`,
`productive_characters`, `averaged_decoder_bound`, and
`bias_from_bit_balance`, all in the namespace `UpperDecoder`.

`UpperDecoder.productive_characters` is the main new formal statement.
`s` is the full finite set of output characters; `bad` is the predicate
"annihilates W"; `corr` is the signed conditional Fourier correlation on
a fixed compatible slice. Its hypotheses are exactly:

- `s` has positive cardinality;
- `0 <= p <= 1` is the slice probability;
- the nonnegative threshold bounds what counts as a productive correlation;
- every correlation has absolute value at most one;
- `q * |s| <= sum |corr|`, which follows from Fourier expansion of equality;
- `|bad| + threshold * |s| <= rho * |s|`.

The conclusion is

`p * (q-rho) <= |{sigma : not bad sigma and threshold <= |corr sigma|}| / |s|`.

In the manuscript specialization `threshold = rho/2` and
`|bad|/|s| <= 2^(-(ell-r)) < rho/8`, so its last hypothesis holds.
The theorem does not assume that `q >= rho`; negative contributions are
handled explicitly. This is why the full positive excess survives averaging
without selecting a single character or a favorable exposure first.

`UpperDecoder.averaged_decoder_bound` quantifies over arbitrary finite
exposure sets and arbitrary nonnegative weights. It takes the preceding
pointwise domination, a per-exposure decoder hit bound, a nonnegative hit
factor, and the positive-excess inequality as hypotheses. It concludes the
weighted decoder success is at least `b * hit`. In this application,
`hit = tau^2/2 * 2^(-r)`. Probability normalization of the weights is not
needed for the algebraic implication. This declaration does not assume or
derive any conditional independence.

`UpperDecoder.heavy_list_bound` proves `m <= 2/tau^2` from positive `m,tau`,
`lambda <= tau^2/2`, and the Gram inequality
`m^2*tau^2 <= m + m^2*lambda`. The Gram inequality is a hypothesis here;
its proof from unconditional character biases is given in `theorem.md`.

`UpperDecoder.positive_difference` verifies the manuscript's exact error
budget with `rho=k*alpha/4`, `b=k*alpha*q/4`,
`h>=q>=0`, `0<=alpha<=1`, `k>=0`, and `v<=alpha*q/16`.
`UpperDecoder.slice_mass` proves the lower bound on slice mass from the
three displayed scalar bounds. `UpperDecoder.two_response_fiber` verifies
the exact two-value collision inequality. `UpperDecoder.excess_domination`
handles multiplying a possibly negative excess by a probability.
`UpperDecoder.bias_from_bit_balance` checks the conversion of a bit
probability in `[1/16,15/16]` to character bias at most `7/8`.

This file deliberately does NOT claim a formalization of the entire
Proposition prop:upper. The finite-group Fourier identities, tensor/coset
identifications, joint partition legality, common-observation maps,
fresh-tape conditional independence, and the external Grassmann theorem
are proved or cited in `theorem.md`, and require independent mathematical
review. The compiler checks the universal implications above, not that
the manuscript's data satisfy their hypotheses.
