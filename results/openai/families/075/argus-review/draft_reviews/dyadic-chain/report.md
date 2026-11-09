# Thermal, capture and path chain to the dyadic estimate

**Assessment: unresolved as an old Argus verification.** This unit contains
four ledger-only analytic goals, not four hidden formal proofs:
`L_ER_SPECTRAL_BUDGETS@1`, `L_ER_CAPTURE@1`, `L_ER_PATHS@1` and
`C_ER_DYADIC@1`. None has supporting evidence in the old ledger.
The referenced manuscript gives actual arguments, whose scope and
remaining proof obligations are identified below; this is not a finding
that those arguments are false.

## Exact target and reference binding

Source: manuscript Sections 05--09, at the staged bytes matching reference
revision `4eaee87548250b2682affda7d05d947c05554bae`. Attribution is to
that manuscript, with the old Argus ledger proposing an extension of its
finite-search audit. No originality or literature novelty is established.

`prop:dyadic` in Section 06 lines 10--44 asserts absolute `C,d_0` such
that, for `d>=d_0`, `h=log log d`, a half-open interval
`1/2<=|I|<=1`, nonnegative measurable `rho<=exp(d)` with top average
at most 2, every finite `J>=1,Q>=0`, and the **same**
`F_{j+1}`-measurable multipliers `|epsilon_j|<=1` for every modulation,

```
tau(x)=min({0<=j<J : average_{p_j(x)} rho > exp(4h)} union {J}),
H^u rho(x)=sum_{0<=j<tau(x)}
  average_{p_j(x)}[rho(Y)*chi_u(Y)*r_{j+1}(Y)]
  *epsilon_j(x)*r_{j+2}(x),
integral_I max_{u integer, |u|<=Q} |H^u rho(x)| dx/|I| <= C*d.
```

Bits through depth `J+1` are retained. The delay from coefficient sign
`r_{j+1}` to output sign `r_{j+2}` is part of the statement. Constants
are uniform in depth and cutoff; increasing `Q` gives all integer
modulations only after the finite-cutoff bound is established.

## Thermal and live-budget obligation

Section 05's `lemma:thermal-monotonicity` asserts positive even Fourier
coefficients, covariance positivity, form-order monotonicity and a
convolution envelope. `lemma:spectral-update` is conditional on the
addition count, the bound on `F(A)`, interval/mass/density restrictions,
and the separation/channel setup. `prop:thermal-evidence` supplies the
regular-evidence alternative. Section 06's `prop:live-budgets` requires
the update hypotheses **before every request**.

The missing bridge in the old Argus evidence is a verification of these
premises throughout the adaptive procedure, including the probabilistic
regular-test alternative, and a summation of its costs, successes,
failures and transfer rules into the stated live budgets. A pointwise
thermal positivity fact or the finite entropy search alone does not give
these adaptive probabilistic and global weighted bounds.

## Capture, edge-charge and snapshot obligation

Section 07's `prop:capture` (starting line 188), `lemma:07-edge-charges`
and `lemma:07-snapshots` combine frequency approximation on a plateau
with expected list-size, snapshot-birth and local/global edge-charge
statements. The scalar level is selected predictably per jump; the main
levels are summed. Section 09 uses charges weighted by
`U(p)*alpha_e`, not just a local count of frequencies.

The concrete obligation is to check append timing and the high/non-bad
approximation after the permitted post-state append, then derive both
the local pathwise and global weighted charges with the actual level
selection and snapshot rules. A signed-span approximation alone does not
establish those budgets or simultaneous representative costs.

## Scalar/vector path obligation

Section 08's `lemma:paths-sign` needs fair signs and predictable
coefficients, including predictable masks/stops. `prop:scalar-path`
conditions on a representative's predictable snapshot birth and controls
masked contiguous intervals. `prop:vector-path` controls **inner-valid**
intervals on a live plateau at a main level, using predictable
runs/checkpoints, energy increments, removals and Fisher bounds.
`lemma:paths-simultaneous` additionally pays for representative and origin
counts to obtain the stated expected parameters.

The missing old verification must establish predictability at the exact
emission times, verify the scalar concentration and vector energy bounds
with their different masks/validity quantifiers, and justify the
simultaneous counting step. A bound for one representative or one valid
interval does not supply a uniform bound over all later representatives,
levels and modulations. Scalar and vector propositions are not substitutes.

## Assembly obligation and verdict

Section 09 decomposes the exact transform into plateaus, representatives,
valid path intervals, miss blocks and exceptional jumps; combines live
Fisher/edge charges; and includes static roots and rare transfers. It
then uses monotone convergence in the finite cutoff.

To establish `C_ER_DYADIC` from this route, check the exact splitting
identity, normalization of post densities, applicability of every path
bound, global charge conversion, and the static/transfer terms with one
constant independent of `J,Q`. The stopping rule concerns the original
input, not an independently normalized replacement. These requirements
are absent from the finite-search source and its certificate.

`R_ER_DYADIC_CHAIN` records the necessary conjunction but confers no
evidence. The old graph also places compression upstream of the spectral
budgets, and capture upstream of later charging. Those dependency
directions must not be reversed or discharged by citing the final dyadic
proposition itself. The outcome is a precise unresolved verification
obligation, not a negative finite experiment and not a manuscript
refutation. Native review may judge this exploratory assessment complete
without requiring a new proof of the analytic theorem.
