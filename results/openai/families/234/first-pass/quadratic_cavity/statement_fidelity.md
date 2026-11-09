# Fidelity of the formal algebraic core

The source `Main.lean` formalizes claim `QC_ALGEBRA`. It does not formalize
the whole quadratic-cascade lemma or the pressure theorem. All declarations
are in namespace `QuadraticCavity`.

The four declarations `ordered_factor`, `ordered_intertwining`,
`left_right_resolvent`, and `ordered_resolvent_difference` quantify over
every type with a ring structure, with no commutativity assumption.
`B,C,K,JB,JC,LC,T` are arbitrary ring elements. A displayed inverse
identity is an explicit hypothesis, not a conclusion about when an
inverse exists. The letter `C` here denotes the second resolvent
argument, not the cavity block named `C` in the manuscript.

`ordered_factor` proves
`1-(B-C)(KJ)=(1-BK)J` assuming `(1-CK)J=1`.
It is `cav:q-factor` with `B=H_{i-1}`, `C=H_i`, `J=J_i`.
`ordered_intertwining` additionally takes a left inverse `JB` for
`1-BK` and a right inverse `T` for `1-(B-C)(KJC)`, and proves
`JC*T=JB`, the rescaling identity used in `cav:q-kernels`.
`left_right_resolvent` proves `JC*C=C*LC` from the indicated left
and right inverse identities. `ordered_resolvent_difference` proves
`JB*B-JC*C=JB*(B-C)*LC`; it preserves the multiplication order.

The remaining declarations quantify over every finite index type with
decidable equality and over real square matrices of that index type.
This includes the empty index type (dimension zero).
`transpose_right_inverse` assumes that `C` and `K` are symmetric and
that `J*(1-CK)=1`, and proves `(1-KC)J.transpose=1`.
`matrix_resolvent_difference` specializes the ring identity to obtain
`JB*B-JC*C=JB*(B-C)*JC.transpose`. It requires the stated symmetry
and left inverse hypotheses; no commutation hypothesis is present.

`innovation_covariance` is the purely algebraic equality
`JC*(T*S)*JC.transpose=JB*S*JC.transpose` under `JC*T=JB`.
It identifies the covariance after rescaling a Gaussian transition,
once the transition covariance `T*S` has been established analytically.
`scaled_covariance_difference` also assumes `B-C=a*S`, for an
arbitrary real `a`, and proves
`JB*B-JC*C=a*(JB*S*JC.transpose)`.
In the cascade application `a=zeta_i>0`; the formal statement does
not divide by `a` and therefore does not need its positivity.

The actual Gaussian precision positivity, existence of these matrix
inverses under spectral bounds, Gaussian integration, Poisson mapping,
quenched-root convention, independent per-visit residuals, determinant
logarithms, and all-depth probabilistic induction are proved in
`report.md`, not encoded here. A successful Lean compilation establishes
only the quantified ordered algebra just described. It must not be used
to label those analytic or probabilistic assertions `closed_kernel`.
