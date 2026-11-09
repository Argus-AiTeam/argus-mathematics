# Formal statement fidelity: C318SUPALG

`Main.lean` has namespace `SupportNaturality`.

The declarations in `FiniteTrace` quantify over arbitrary finite types I,
J, K, an arbitrary commutative ring R, maps p:I->J and q:J->K, and ALL
functions on those finite sets. No fiber degree is assumed invertible.
`trace` is the actual sum over a fiber, not a normalized average.
`pullback` is composition and `pairing` is the sum of products.

`pullback_trace_adjoint` and `trace_pullback_adjoint` prove BOTH directions
of adjunction. `trace_projection`, `trace_comp`, `trace_ringHom`,
`pullback_one`, and `trace_one` prove respectively the projection formula,
composition, naturality under every ring homomorphism, preservation of
the pullback unit, and the fiber-cardinality formula for trace of the
unit. The last permits trace(1)=0 in characteristic five.
`fixed_volume_character` assumes explicitly that the ring homomorphism
fixes the chosen scalar character; it does not apply Frobenius to an
orientation line.

The declarations in `Signs` quantify over every degree parity in ZMod 2
and every commutative ring. They prove the coefficient cancellations for
the dual differential, composition of graded-transpose actions, and
the exact shift/transposition sign in Section 2 of
`support-comparison.md`. Encoding degree parity represents negative
as well as positive integral degrees. The formal proof does not
assume the unshifted transpose is a differential graded left action.

These are universal finite algebra and parity theorems. They do NOT
formalize a group-cohomology resolution, Poincare duality, the existence
of invariant volume, residue change of variables, analytic/principal-part
comparison, etale descent, a classifying torsor, or the ordinary
connected comparison. No claim is made that a compiling finite-fiber
theorem proves C318ORD_SUPPORT by itself. The application to split
finite etale fibers, its faithfully flat descent, and the actual
geometric and cochain comparison are the separate mathematical proof.

In particular the formal statements contain neither the Honda
coefficient ring nor xi_i; no replacement exterior generators or
new coefficient unit are formalized.
