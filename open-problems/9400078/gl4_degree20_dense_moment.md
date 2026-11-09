# Dense square-character second moments

## Outcome

The required dense nonreal residue estimate is **not proved**.
This attempt tests a genuine averaged second-moment route, rather than
reusing the inherited local estimate or a termwise convexity bound.
It identifies a sufficient moment estimate and proves exactly why
absolute convergence plus character orthogonality cannot supply it alone.

The obstruction below is a statement about those restricted inputs.
It is **not** a counterexample among automorphic representations, not a
refutation of the degree-20 strategy, and not a publishable resolution.
No new local exponent bound is obtained in this continuation.

## 1. The averaged moment that would suffice

Keep the notation and the q-depletion convention from
`gl4_degree20_residues.md`. Write

    C_q = {chi modulo q : chi^4 != 1},
    w_q = 1/(q-1),
    W_C(Q) = sum_q w_q |C_q|
           = N(Q) - sum_q gcd(4,q-1)/(q-1).

For large Q, `W_C(Q)` is asymptotic to `Q/log Q`. Let

    c_n = a(n) g(n/X),
    D_(q,chi) = sum_n c_n chi(n)^2,
    M_C(X,Q) = sum_q w_q sum_(chi in C_q) |D_(q,chi)|^2.

This is a nonnegative finite character second moment. The right boundary
of the dense-sector contour sum is

    A_C(X,Q) = sum_q w_q sum_(chi in C_q)
                conjugate(chi(X)^2) D_(q,chi).

Weighted Cauchy-Schwarz, with the phases retained, gives

    |A_C(X,Q)|^2 <= W_C(Q) M_C(X,Q).                       (1.1)

The reviewed full transformed boundary and the reviewed real-sector
boundary imply that the dense transformed boundary satisfies
`B_C=O(X^(1+epsilon))` at `Q=X^(2/21)`.
Thus a sufficient new input would be

    M_C(X,Q) <<_epsilon X^(2+epsilon)/W_C(Q),
    Q=X^(2/21).                                          (M2)

It would imply the requested dense residue estimate by
`R_C=A_C-B_C`. Up to logarithms, the exponent demanded in (M2) is

    2 - 2/21 = 40/21.

No bound of this strength for these actual coefficients is established
here. It is only sufficient: a small phase-weighted first moment need
not have a small second moment, so (M2) must not be called equivalent
to the target.

## 2. Exact Gram kernel and its coherent direction

Character orthogonality gives a complete, exact description of M_C:

    M_C = sum_(m,n) c_m conjugate(c_n) G_C(m,n),

where

    G_C(m,n)
      = sum_(q not dividing mn)
          [1_(m^2=n^2 mod q) - K_real,q(m/n)].             (2.1)

The real-sector kernel K_real,q is the one proved in the sparse-twist
note. Formula (2.1) follows by expanding the squared absolute value.
The kernel is positive semidefinite because it is a character Gram
matrix; its individual off-diagonal entries need not be nonnegative.

For `m=n=X=p^ell`, none of the eligible q divides X, and

    G_C(X,X) = W_C(Q).                                    (2.2)

The vector supported at n=X therefore has exactly the phase pattern
used by the amplifier. For any complex A, take

    c_X=A,    c_n=0 for n!=X.

Then for every character in the dense family,

    D_(q,chi)=A chi(X)^2,
    A_C=A W_C,
    M_C=|A|^2 W_C.                                       (2.3)

Equation (1.1) is an equality for this vector. The complex characters
do not cancel in this direction: the amplifier deliberately conjugates
their phases at X. Any coefficient-independent moment inequality
must respect (2.3).

This does not prove that the actual automorphic coefficient vector is
concentrated at X. It shows where additional information about that
vector must enter a second-moment proof. Orthogonality cannot be
invoked a second time to erase the diagonal it was chosen to retain.

## 3. A fixed absolutely convergent model, not an automorphic example

The preceding direction persists for all ell in a single fixed
Dirichlet series, not just for a sequence chosen after X.
Fix p>=5 and set alpha=29/32. Define

    F_model(s) = (1-p^(alpha-s))^-1,
    a_model(p^k)=p^(alpha*k),   k>=0,
    a_model(n)=0 otherwise.

For every real u>1,

    sum_n |a_model(n)| n^-u
      = (1-p^(alpha-u))^-1 < infinity.                    (3.1)

Because g is supported in [1/2,2], g(1)=1, and p>=5, its smoothed
coefficient vector at X=p^ell has only one nonzero entry:

    c_X=X^alpha.

It follows exactly, for every sufficiently large ell, that

    A_C,model = X^alpha W_C,
    M_C,model = X^(2*alpha) W_C.                          (3.2)

At Q=X^(2/21), prime counting gives

    A_C,model is asymptotic to a positive constant times
       X^(673/672)/log X,

    M_C,model has power X^(641/336), up to a logarithm.    (3.3)

Indeed

    29/32 + 2/21 = 673/672 > 1,
    2*(29/32) + 2/21 = 641/336,
    40/21 = 640/336.

Thus (3.2) violates the requested first-moment budget for any fixed
`0<epsilon<1/672`, and violates (M2) for
`0<epsilon<1/336`, once X is sufficiently large.
The factors of log X do not absorb these positive powers.
This is an exact infinite-family counterexample to the **coefficient-only
inference**, not a finite numerical miss.

The model has no asserted global automorphy, degree-20 functional equation,
exterior-square transfer, or Rankin-Selberg origin. In particular it is
not a counterexample to the mission. Its role is limited to distinguishing
an actually proved character-moment estimate from an unjustified
coefficient-independent cancellation heuristic.

Absolute convergence alone gives only

    M_C <= W_C (sum_n |c_n|)^2
        << W_C X^(2+epsilon),

which is a factor of order `W_C^2` larger than (M2).
A large-sieve inequality with an additional coefficient norm on its
right-hand side is not by itself a bound for that norm. No stronger
coefficient moment or cancellation theorem for R20 is imported here.
The standard analytic functional equations could conceivably provide
such information; this argument neither supplies nor excludes it.

## 4. Search and route disposition

A new targeted search asked specifically for holomorphy or pole cancellation
of

    L(s,Pi,Sym^2 tensor omega_pi^-1 eta) / L(s,eta)

for nonreal eta, equivalently the degree-20 Schur S_(2,2) quotient.
It returned no relevant result. No primary proposition was obtained,
and no claim of nonexistence or novelty follows from that bounded search.
Holomorphy of the numerator, if known for a twist, would still not
establish cancellation of the denominator's zeros.

The coefficient-only route to (M2) is retired because of the exact model
(3.1)-(3.3). The actual automorphic second-moment route remains unresolved,
as does a direct phase-sensitive first-moment proof that does not go
through (M2). Neither should be represented as completed.

The established local bound remains 5/22. The sparse real-square result
from the previous round is unchanged. The genuinely new analytic input
needed for dense complex cancellation has not been found.

## Exact exponent replay

The rational identities used to assess the proposed moment method can
be rerun without numerical approximation:

    from fractions import Fraction as F
    alpha, theta = F(29,32), F(2,21)
    assert alpha + theta == F(673,672)
    assert 2*alpha + theta == F(641,336)
    assert 2-theta == F(40,21) == F(640,336)
    assert (2*alpha+theta)-(2-theta) == F(1,336)

These are arithmetic checks. The universal Gram identity is proved by
finite character orthogonality, and the fixed-series model is the exact
geometric series above; no finite computation certifies the missing
automorphic estimate.
