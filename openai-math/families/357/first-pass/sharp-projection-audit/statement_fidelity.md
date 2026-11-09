# Statement fidelity and certification boundary

## Mathematical statement being verified in prose

`C_SP` is the conditional implication expressed by the literal
`pi:sharp-projection`, not the main chart theorem. Fix n >= 2 and
L,C_sep > 1, set R = 16(L+C_sep+2), S = 32R, and take every
admissible x,z,y and dyadic i on every sufficiently late rescaling.
Use the rescaled length and Hausdorff measure, integral (not averaged)
L2 norms,

    v = f_i^z/r_i^2 - f_i^x/r_i^2,
    U = R_i(y)^(-1/2)(u-u(z))/r_i,
    s = sqrt(E_i(x)+E_i(z)).

Assume the imported all-center/all-scale Euclidean normalization,
local RCD calculus and estimates, equal-source Poisson/Hessian/gradient
bounds, and quantitative radial invariance, exactly as separated in
the report and the seven ledger assumptions on C_SP. Then there are
a common C and late threshold such that there exists b in R^n with

    |b| <= C,
    ||grad(v-b.U)||_{L2(B_(2L+4)(y))} <= C s.

The existential b may depend on the configuration. The constant and
late threshold may not depend on x,z,y or i. The constant can depend
on the fixed imported bounds and n,L,C_sep; the late threshold uses
the common geometric/coordinate convergence regime. No effective
formula for either is claimed.

The report proves the stronger intermediate alpha <= C s, where
alpha is the L2(B_R(z)) norm after orthogonal projection onto
span{1,U_1,...,U_n}. Constants in the affine projection do not affect
the target gradient. The coefficient from the two-center commutator
is not assumed, and b is not asserted here to equal U(x)-U(z).

## Analytic proof and its full-dimensional rigidity step

The transport proof uses the fixed L-infinity bound of the original
residual before any normalization. The normalized contradiction then
uses the bounded outer L2 norm, interior harmonic estimates,
Ambrosio--Honda's local theorems, and convergence on a neighborhood
of the projection ball. The Euclidean limit is smooth and satisfies
an Euler equation with affine forcing.

Rigidity is proved for every C2 function on a Euclidean ball by
differentiating at zero and integrating the quotient along every
ray. There is no bounded-degree truncation, finite-mode experiment,
or assumption that harmonic functions are polynomials.

The proof also permits s = 0: a bad sequence satisfies alpha > j s,
which itself guarantees alpha > 0. This strengthening does not
change the literal manuscript assertion, whose positive floor is
among its stated inputs.

## What verify.py actually verifies

The script uses SymPy 1.14.0 and exact rational coefficients; it
requires no network or live Jacobian server for replay.

It binds the two complete lemma statements in `exact_certificate.json`
to the staged LaTeX source. It checks the cutoff-sign polynomial for
arbitrary nonnegative parameter slacks with R-1 > 0, symbolically
differentiates both exponential cutoff pieces, checks their joining
values, replays the exact Young sum-of-squares identity, and checks
the two domain margins and the normalization/quotient algebra.
These are universal identities and nonnegative-coefficient
certificates, not tests of selected dimensions or sampled parameters.

The retained Jacobian answer is bound to the exact payload and
inspected operation contract. Its polynomial coefficients and square
identity are independently recomputed rather than trusted from
`is_valid` alone. Its result concerns only the Young identity.

The executable does **not** prove the analytic compactness theorem,
the validity of imported manuscript hypotheses, the analytic
passage to a limit, or the complete C_SP implication. Those are the
complete written proof's explicit mathematical dependencies and
review obligations. A passing replay is not a kernel proof of C_SP.
There is no Lean source, compiler verdict, or formalized proxy.

## Status and nonclaims

No hypothesis-complete counterexample or false literal manuscript
assertion has been established. No F_ claim is being suppressed:
none was identified in this bounded audit.

Independent Reviewer replay and citation attribution are pending.
Novelty and publishability are not asserted; the publishable
exploratory campaign remains open. Verification of this conditional
lemma must not be reported as verification of its upstream inputs,
directional pinching, the value-space iteration, or the main theorem.
