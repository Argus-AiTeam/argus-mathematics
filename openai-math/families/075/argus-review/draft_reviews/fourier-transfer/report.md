# Kernel transfer and the nonnegative good-set estimate

**Assessment: unresolved in the old Argus work.** This unit covers
`L_ER_FOURIER_TRANSFER@1` and `C_ER_GOOD_SET@1`. Their ledger entries
name manuscript claims but carry no supporting judgements, computational
certificates or formal analytic source.

## Exact claim and attribution

The reference is Section 11, `thm:good-set` / `eq:source-18`, at the staged
bytes matching revision `4eaee87548250b2682affda7d05d947c05554bae`.
For absolute `C,d_*`, every `d>=d_*` and nonnegative periodic
`rho` with mass one and `rho<=exp(d)` a.e. should satisfy

```
h=log log d,
G_rho={M rho <= exp(4h)},
|G_rho^c| <= C*exp(-4h)=C/(log d)^4,
integral_{G_rho} sup_{N>=0} |S_N rho(x)| dx <= C*d.
```

Here `M` is the manuscript's periodic maximal operator and `S_N` the
ordinary symmetric Fourier projection. The maximal weak estimate supplies
the exceptional measure; the good-set integral is a separate, much
stronger assertion. This statement is not for arbitrary signed or
complex inputs. Its attribution is to the manuscript; Argus proposed to
check it, not to originate it. Novelty is unverified.

## Decisive source argument and missing bridge

Section 11 first realizes a modulated shift as the delayed-Haar object
of `prop:dyadic`, uses top intervals with average at most 2, and uses
inactivity of stopping on `G_rho`. It averages over translations and
scales. The calculation `eq:fourier-averaged-kernel` must produce a
nonzero odd kernel, with the source coefficient `-1/8`, in the precise
`da/s`, `ds/s` normalizations. Comparison to the periodically truncated
Hilbert kernel, with small inner window bounded by `M rho`, then leads
to the Fourier projection identity.

The old finite-search identity and certificate concern a polynomial
recurrence in a preordered abstract model. They contain none of these
operators, kernel integrals or limiting arguments. In particular a local
exact factorization does not certify the sign/normalization of the
averaged kernel.

Concrete remaining obligations are:

1. Establish the admissible delayed-Haar representation and the application
   of its finite-depth estimate on the actual good set.
2. Verify the averaged kernel formula, nonzero coefficient, periodic
   comparison and its uniform error/inner-window bounds.
3. Justify the stated multiplier limit in `L^2`, its passage to the
   relevant finite sets of modulations, and only then the increasing
   countable supremum.
4. Check that the Hilbert-transform identities recover the ordinary
   **symmetric** `S_N`, not a different truncation or summation procedure.

These are analytic proof obligations visible in the manuscript argument,
not merely lack of access. The relevant source was obtained and read.
Neither a saved old success label nor a bounded numerical experiment
could discharge them.

## Dependency and scope verdict

Even a correct `prop:dyadic` would supply only the first input to this
transfer, not the kernel/limit proof automatically. Conversely the old
route `R_ER_GOOD_SET_CHAIN` lists the dyadic claim alone; the graph
correctly also names `L_ER_FOURIER_TRANSFER`. We retain that missing
conjunct explicitly instead of treating the shorter route as complete.

Conditionally on the good-set theorem, normalizing a nonnegative layer
`q=m*rho` gives a good-set integral cost `O(m*d)`. That conditional
scaling is valid but neither sums exceptional sets nor proves convergence.
Those tasks belong to the endpoint unit. The present unresolved verdict
does not assert that the manuscript's kernel calculation is wrong, and
it is not a new manuscript-error search.
