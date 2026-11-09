# Statement fidelity: `HighMomentAudit.weighted_drift`

The declaration `weighted_drift` in namespace `HighMomentAudit` (fully
qualified name `HighMomentAudit.weighted_drift`) formalizes exactly the
scalar two-channel absorption claim `C_HM_WEIGHT`, equation (20) and its
application to (17) in `proof.md`.

All eight variables `A T F D v l Fnext Dnext` range over the real numbers.
The hypotheses are `A >= 0`, `T >= 0`, `F >= 0`, `D >= 0`, `v >= 0`,
`l > 0`, and the two upper bounds

    Fnext <= (1 + A/l)*F + T*D/l^2 + v*(1 + F + D)
    Dnext <= (1 + A/l)*D + T*F/l + v*(1 + F + D).

There is no sign hypothesis on `Fnext` or `Dnext`. This strengthens,
rather than weakens, the application to expected nonnegative moments.
There is no integrality hypothesis on `l`; the theorem holds for every
positive real `l`.

The conclusion uses the fixed weight `k = 1/(1 + T)` and the budget
`u = T/(k*l^2) + (1+k)*v/k` and states

    1 + Fnext + k*Dnext <=
        (1 + (A+1)/l + u)*(1 + F + k*D).

In the analytic application, `Fnext` and `Dnext` are the two expected
next-state moments, `A` is the order-independent self-drift bound, and
`T` is a fixed order-dependent transfer bound. The formal theorem has
no expectations or probability spaces; it is the deterministic
inequality applied after the analytic bounds have been obtained.

The proof uses only ordered-field algebra and positivity, with Mathlib
tactics. It introduces no additional axioms or unproved hypotheses.
Compilation does **not** prove the upstream kernel bounds, interpolation,
the classification of all analytic update terms, summability of the
budgets, `C_HM_UNIFORM`, or the graph-construction theorem. It does not
certify that this document faithfully connects those analytic objects
to the real variables; that reading remains an independent review task.
