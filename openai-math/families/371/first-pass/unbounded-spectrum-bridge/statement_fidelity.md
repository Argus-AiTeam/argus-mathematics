# Statement fidelity for C371_BRIDGE

There is no Lean source in this deliverable. This reading applies to the
analytic theorem and rough-coupling extension in `theorem.md`, and to the
strictly smaller exact-algebra replay in `verify.py`.

The objects are the two independent complex circular components of the
manuscript spectral equation in dimension twelve. They are not restricted
by a conjugacy condition. Parameters may vary with the sequence:
`0<a<=1`, real bounded `b`, `-1/32<=sigma<=4`, nonnegative `omega`,
and nonnegative integer angular degree `ell`.
The original real profiles enter only through the explicit, uniformly
bounded exterior Euler symbols of `P/a` and `exp(2i phi)`. The theorem is
conditional on these hypotheses and does not establish profile existence.

Outgoing means that **every fixed Euler derivative** of each `v_h` is
`O(r^(-2(a+sigma)))` at infinity. Constants in this definition may depend
on the solution, derivative order, and parameters. Neither boundedness of
just `v_h` nor a finite-order radiation condition is substituted for it.

Both escaping regimes are quantified: `ell/sqrt(1+omega)->infinity`,
or `omega->infinity` with `ell/sqrt(omega)` bounded. The shell
`[B0,B0+1]` is fixed with respect to the sequence. In the second regime
it may depend on the bound for the angular ratio; the theorem does not
assert a single shell for every unbounded angular-ratio constant.
The gauge, `n`, `S`, `E`, centrifugal correction, and signs of `B_h`
are exactly those in `spec:high-definitions` and `spec:scalar-slope`.

The conclusion is a **uniform matrix operator statement**: evaluation of
the entire two-dimensional outgoing space at each point of the shell is
an isomorphism to `C^2`, and its derivative map differs from the stated
diagonal Robin map by `o(n)` in operator norm, uniformly over the shell.
It is not a claim about a selected solution, a scalar channel in
isolation, a bounded parameter sample, or only one escaping regime.
The analytic argument also removes the need to select a subsequence.

The rough extension is a finite-interval theorem. Its scalar principal
potentials are unchanged, but its matrix perturbation may be arbitrary
measurable coupling of vanishing weighted integral norm. Its right Robin
matrix has norm `o(E)`. It does **not** derive outgoing conditions at
infinity for arbitrary rough exterior coefficients. The manuscript
application separately obtains the right matrix of norm `O(E^-1)` from
the original, ungauged exterior symbols.

Machine replay establishes both gauge identities, the full exact
two-shape rescaling defect, universal rational shape inequalities,
WKB residuals, Green orientations and derivative jumps, and the remote
leading characteristic polynomial. These checks do not prove
existence/uniqueness, the infinite-endpoint normal form, the limiting
Airy-data compactness argument, its growing-branch lower bound, or
the final operator contraction theorem. Those assertions are justified
analytically in `theorem.md` and are pending Host-invoked independent
Reviewer scrutiny.

`exact_certificate.json` therefore marks independent review, novelty,
and significance as pending or unestablished. It is not a `closed_kernel`
certificate and does not certify the full PDE blowup claim. The conditional
profile input is explicitly recorded in `research/MATH_STATE.json`.
