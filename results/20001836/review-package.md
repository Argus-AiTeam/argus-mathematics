# Result 20001836 — curvature-operator blow-up in a collapsing circle quotient

## Statement

On the unit round sphere S4 in C2 plus R, let the circle act with weights
one and two. For the quotient by an auxiliary circle with metric
epsilon squared times d theta squared, put t=epsilon^(-2).

At either fixed pole, the curvature operator on two-forms has the exact unit
eigenvector

    omega = (e13-e24)/sqrt(2)

with eigenvalue

    1-2t = 1-2/epsilon^2.

The eigenvalue tends to minus infinity as epsilon tends to zero. Therefore no
lower bound independent of epsilon exists.

## Key calculation

In normal coordinates at a fixed pole, the infinitesimal action is
A=diag(J,2J). The quadratic metric perturbation is

    q_ij = -t (Ax)_i (Ax)_j.

The resulting curvature operator is

    R_t = I + 3t alpha tensor alpha - 2t HodgeStar,

where alpha=e12+2e34. The Hodge-star correction is required by the first
Bianchi identity. It vanishes on sectional-curvature evaluations but creates
negative directions on nondecomposable two-forms.

## Review status

Separate independent reviews reconstructed the complete operator and verified
the atomic audit integration. Correctness and statement alignment are
verified. A systematic literature-priority search has not yet been completed,
so no originality or worldwide-priority claim is made.
