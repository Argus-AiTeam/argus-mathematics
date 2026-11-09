# Statement fidelity: spectral algebra, not the analytic theorem

The declarations in namespace `SpectralRigidity` formalize the algebraic
claim `L_SR_ALGEBRA`. They do not formalize Proposition `C_SR`, a
measurable flow, a cone surface, an infinite Fourier series, a weak limit,
or an integration-by-parts domain.

`finite_difference_telescopes` quantifies over every real-valued sequence
on the integers, every integer initial index, and every natural tail
length, including zero. `spectral_telescope` uses the same unrestricted
indices for arbitrary real sequences D and C. It sums the consecutive,
not parity-restricted, spectral summands

    D_j - D_(j+2) - C_j + C_(j+1).

Its right side has exactly the two D endpoints and one C correction at
each end. Substituting the manuscript's integrated spectral recurrence
gives its finite energy telescoping formula; existence and decay of the
analytic quantities being substituted are not formalized.

`innerFirst z w = z * star w` is the complex scalar inner product linear
in the first entry. This intentionally matches the manuscript rather
than Mathlib's first-conjugate-linear inner-product convention.
`endpoint_pairing_formula` quantifies over all complex scalars b,a,u,v
and every real l, with no division by l. It verifies the exact signed
pairing for boundary modes (b,-a) against
(-l*v-2*i*b,l*u+2*i*a). `complex_two_vector_cauchy` proves the associated
two-dimensional complex Cauchy inequality.

`endpoint_scalar_bound` quantifies over arbitrary real energy, mass, l,
re and im. Its hypotheses are nonnegative energy and mass, the scalar
Cauchy inequality re^2+im^2 <= energy*mass, and
2*energy = l*im. Its conclusion is

    energy <= l^2*mass/4.

This includes energy zero and l zero. This declaration is the
Hilbert-space algebraic reduction: using integrated coefficient norms
for energy and mass requires proving the integrated pairing and applying
Hilbert-space Cauchy--Schwarz separately in the report.

`two_boundary_energy` instantiates these facts for arbitrary complex
scalars with the displayed zero-pairing hypothesis. It is not, by
itself, a formalization of the infinite-dimensional coefficient-space
application. `sharp_energy_forces_transverse_zero` proves the real
nonnegative-energy implication used after Parseval; Parseval and
identification of those energies with weak derivatives remain analytic
proof obligations.

There are no explicit axioms, admitted statements, proof holes, or
finite numerical tests in this source. Mathematical interpretation and
the analytic application require independent human review even when the
Lean compiler accepts every declaration.
