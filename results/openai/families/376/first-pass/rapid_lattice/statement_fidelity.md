# Statement fidelity: universal periodic-lattice arithmetic

The formal namespace is `RapidLattice`. All number-theoretic and transition
variables are universally quantified; there is no bound on the base, width,
address, slot, history length, record values, or derivative order.

`Move`, `Instruction`, `stackUpdate`, `pack`, `period`, and `step` encode the three
displayed stack formulas in lattice.tex. `pack` is
`L + b^d (R + b^d s)`, exactly the manuscript code. `period_eq` identifies its
period with `b^(2d+1)`. A table is an arbitrary function on state/scanned digit
to an optional instruction whose written digit and next state belong to
`Fin b`. Returning `none` is the manuscript's invalid/halting-address
totalization. Thus any finite manuscript table is an instance. Remote stack
digits are not validated or restricted to reachable configurations.

`push_mod`, `push_div`, `stack_sub`, and `manuscript_stack_identities` prove
the positional write/pop identities, including the two shifts on a left
move; they do not assume transition correctness. `stacks_bounds` assumes
only `b>=2`, `d>=1`, `L,R<b^d`, and the written digit `<b`. `pack_decode`
proves that the fields of a valid packed code are recovered.
`step_range` and `address_range` prove the next-code bound for every address.
`address_of_true_code` recovers the prescribed instruction on any packed
configuration and every congruent integer address. This is the discrete
transition statement, not a formal definition or simulation of a complete
Turing machine with its origin-bit preprocessing.

`address` reduces an arbitrary integer by Euclidean remainder before
decoding. `residue_shift`, `address_periodic`, and `halt_periodic` prove
periodicity, including negative addresses. The halting predicate is arbitrary
and Boolean: it can be exactly the predicate on the manuscript's valid
halting state indices.

`history_residue` proves the residue identity for arbitrary integer records
`c` and arbitrary integer lift `m`, for every natural history length `n`,
assuming only the displayed exponent inequalities. It proves these terms
are divisible; it does not assume the desired residue equality.
`scale_lower`, `scale_monotone`, `scale_gap`, `plateau_margin`,
`derivative_margin`, and `scheduled_history` discharge those inequalities
for every natural sequence `K` with `K 0 >= p0+10` and
`K(n+1)>=2*K n`. Here `p0` is any natural number, a mild generalization of
the manuscript's odd positive `p0`. The kth derivative margin additionally
assumes `(k+2)*K n <= K(n+1)`, a numerical schedule hypothesis, not a
regularity conclusion. The lower margin is six base-b exponent units.

`publishedK`, `published_recurrence`, `linear_le_two_power`,
`published_doubling`, and `published_all_orders` instantiate the explicit
published scale for all orders `k` and every `n>=k`.

`plateau_persistence` bounds the complete writing segment for every real
pulse value in `[0,1]`, not just its endpoints. `nonhalting_all_times` proves
strict non-entry for the entire nonhalting segment.
`halting_endpoint` proves the halting endpoint identity, also usable at the
first slot with beta_0=1/4. These statements quantify abstract real distances;
the smooth ODE identification and their instantiation by the exponential
scales are proved in report.md, not encoded as Lean analysis.

`lift_divergence` and `pressure_sign` prove universal algebraic jet identities.
The differentiation producing those jets is separately replayed symbolically
by verify.py.

This is not a Lean formalization of Navier--Stokes, smooth cutoff existence,
ODE uniqueness, Fourier projection, analytic decay, the necessity half of
the scale-ratio theorem, or its novelty. Those conclusions and remaining
analytic hypotheses are stated separately in report.md. The proof uses
Mathlib's standard trusted foundation, not added axioms or proof placeholders.
