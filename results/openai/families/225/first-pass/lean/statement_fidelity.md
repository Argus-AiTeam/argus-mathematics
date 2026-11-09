# Statement fidelity: algebraic core only

`Main.lean` formalizes exact algebra used in the staggered-fidelity calculation.
It does not formalize root existence, the Slavnov theorem, Hilbert duality,
Fourier transforms, alias estimates, trace localization, or any limit.

The declaration names are `corrected_symbol`, `relative_symbol`,
`pair_accelerations_cancel`, and `density_coefficient`, all in namespace
`StaggeredFidelity`.

`StaggeredFidelity.corrected_symbol` quantifies over arbitrary complex
numbers `a,b,E`, with `1-a*b` nonzero. It equates the continuous coth-transform
expression plus the sampled-pole correction `(1+E)/2` to the factored symbol.
In the application `a=exp(-lambda*p)`, `b=exp(-(pi-lambda)*p)`,
`E=exp(2*pi*i*z)`, and `p` is nonzero. Both positive and negative frequencies
satisfy the nonzero-denominator hypothesis.

`StaggeredFidelity.relative_symbol` has the same complex variables and also
requires `1-b` and `1+a` nonzero. It divides the factored symbol by its value at
zero twist. These additional hypotheses hold for real nonzero frequencies
and `0<lambda<pi`.

`StaggeredFidelity.pair_accelerations_cancel` quantifies over six arbitrary
real numbers. They represent two velocities, two accelerations, and the first
two derivatives of a pair potential. Its conclusion is the quadratic
coefficient of the cross-pair product divided by its two within-set products.
The same polynomial identity also holds for a complex potential derivative;
this declaration proves its real version, which suffices after pairing
opposite root differences in the application.

`StaggeredFidelity.density_coefficient` quantifies over real `p,lam` with
`lam` and `p-lam` nonzero. Here `p` represents the constant pi, not a Fourier
frequency. It proves that the pair coefficient plus the determinant
coefficient is `-1/(2*lam*(p-lam))`. The minus sign is the logarithmic overlap
coefficient; its negative is the fidelity cost.

These are only the algebraic identities in claim `C_ALG_KERNEL`.
The hypotheses and the analytical argument relating them to `C_FIDELITY`
are human-readable mathematics in `research/AUDIT_REPORT.md`; a compiler
verdict on this source cannot close that separate claim.
