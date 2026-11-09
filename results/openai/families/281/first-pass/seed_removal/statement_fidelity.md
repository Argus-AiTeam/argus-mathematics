# Statement fidelity: algebraic core of reusable-seed removal

`Main.lean` formalizes the real-linear isometric core of the packet
argument, without assuming packet separation, selective accuracy,
Gaussian independence or the disputed seed-removal theorem.
A complex Hilbert space and its unitaries satisfy the real normed-space
hypotheses by restricting scalars. No orthogonality of the exact
ordinary/special decomposition is assumed.

The quantified space `E` is any real normed vector space.
`U,V,Z,F` are arbitrary surjective real-linear isometries.
`U.symm` and `V.symm` represent inverse circuit prefixes and hence
adjoints in the Hilbert-space application. `Z` represents the root
Pauli isometry; `F` represents the target special flip. The hypothesis
`anti : forall x, Z(F x)=-F(Z x)` is exactly anticommutation, not
selective accuracy.

`pullback_sub_norm` and `pullback_add_norm` move an inverse isometry
outside a norm. `identity_defect` bounds a conjugated insertion error
by the two *forward* errors on `x` and `Z x`. `flip_defect` is the
anticommuting analogue, with comparison to `F`.
`split_insertion_defect` applies both inequalities to arbitrary vectors
`o,s`; it bounds the insertion change plus `2 Z s` by the four forward
errors on `o, Z o, s, Z s`. These vectors are not required to be
orthogonal. In the application their forward errors are obtained
analytically, not postulated to vanish in Lean.

`transported_identity_defect` and `transported_flip_defect` pull
these bounds back by an arbitrary prefix `U`. They do not require
that a bulk mixer commute with `Z`; the first applies when the
*compensated* mixer has small forward errors on the special vectors.
`finite_transport_accumulation` bounds a finite sum of arbitrary
transport-error vectors by the sum of their individual bounds.

`rescale_defect` assumes only `r>0` and `norm(d)<=K r^2` and concludes
`norm((t/r)d)<=abs(t) K r`. `singular_echo_bound` applies this to
`d=vp-v+2r w`, keeping the actual `v,vp` distinct until after their
difference is controlled. This is a finite-r inequality, not a limit
assertion or a replacement of an uncontrolled O(r) error by o(r).

`reuse_energy_gap` is the exact scalar identity
`q(1+z^2)/4-qz/2=q(1-z)^2/4`.
`gaussian_gap_positive` proves positivity at `q=exp(-1/2)`,
`z=exp(-1)`. The analytic identification of these scalars with the
two root-shift energies is proved in `report.md` and replayed by
`verify.py`, not formalized by these two declarations.

Thus a successful compiler run certifies these norm/transport,
rescaling and scalar-algebra theorems only. The Fock estimates,
Gaussian integration, full quantitative compiler, citation fidelity,
novelty and final SK theorem are outside this formalization.
