# Statement fidelity: CapGrowthAudit

`Main.lean` formalizes three specific load-bearing interfaces in the
cap-growth proof. It does **not** formalize the geometry of convex bodies,
affine-area stationarity, integration by parts, Holder's inequality, or the
whole Bernstein theorem. Its natural-language ledger claim is
`C_FORMAL_CORE`, not `C_ONE_DIRECTION`.

## Positive-determinant interpolation

`CapGrowthAudit.delta` and `CapGrowthAudit.theta` are respectively
`1/(n+2)` and `(n+2)/(2(n+1))`, with real-valued `n`.
`interpolation_exponents` quantifies over every real `n>0` and proves
`0<theta<1`, `theta*(1-delta)=1/2`, and
`delta*theta+1-theta=1/2`.

`weighted_interpolation` quantifies over every real `n>0` and **all**
strictly positive reals `D,R,t`. Real powers are Mathlib's real `rpow`.
It proves exactly

    sqrt(D*R)*t = (D^delta * R^(1-delta) * t)^theta
                   * (D*t)^(1-theta).

In the analytic application, `D=det B`, `R=det R_angular`, and
`t=tr(B^-1)`. Positive-definiteness supplies all three strict positivity
hypotheses. `R_angular` may be an empty angular block: its determinant
is then `1`, which is allowed. No bound on a smallest eigenvalue is
assumed. This is the exact identity used before applying Holder, not a
numerical test of it.

## Dimension-uniform coercivity and the cap-testing frame

`quadratic_nonnegative` is the completed-square argument for a two-by-two
quadratic form: `a>0` and `a*b-c^2>=0` imply
`a*p^2+2*c*p*d+b*d^2>=0` for all real `p,d`.

`scalar_coercivity` holds for every real `3<=n<=9` and all real `p,d`.
It lower-bounds the paired quadratic form at `lambda=15/16` by
`(p^2+d^2)/256`. This is a uniform coercivity bound, not only a
calculation of the determinant's sign.

`finite_coercivity` quantifies independently over every natural `k>=2`,
every natural `r`, every real `3<=n<=9`, and arbitrary real vectors
`p,d` indexed by `Fin k` and `z` indexed by `Fin r`. It proves

    k - 15/8 + sum_i[(n-7/8)*p_i^2 + (n+2)/2*p_i*d_i
                                      + 15/16*d_i^2]
      + 15/16*sum_a z_a^2
    >= (1 + sum_i p_i^2 + sum_i d_i^2 + sum_a z_a^2)/256.

The analytic application chooses orthonormal frames for the inverse-second-
form inner products and sets `r=n-k`. The formal statement is stronger in
allowing unrelated `k,r`; it does not assert such a tube exists.

`frame_gram` quantifies over every natural `k` and `i,j : Fin k`. It proves
the entrywise identity for the `k` vectors `1+e_r`:

    sum_r (1+indicator(r=i))*(1+indicator(r=j))
      = indicator(i=j) + k + 2.

This is the matrix identity `sum_r a_r*a_r^T = I+(k+2)*11^T`.
The analytic proof separately uses positive-definiteness to contract it
against `B^-1` and bound its trace. That last contraction is not encoded.

## One finite box, one approximant

`recurrence_lower` concerns an arbitrary function `mass : Nat -> Real`,
real `q,c`, and natural `N`. With `q>=0`, `mass(0)>=c`, and the
**finite** family of hypotheses `mass(l+1)>=q*mass(l)` for `l<N`,
it proves `mass(N)>=c*q^N`.

`finite_box_contradiction` adds a real `upper`,
`mass(N)<=upper`, and `upper<c*q^N`, and concludes `False`.
It does not assume recurrence on an infinite sequence or swap the
approximant limit and box-size limit. In the application,
`mass(t)=sigma_j(Q_(l0+t))` for a **single fixed** `j`, and
`upper=C_box*(l0+N+1)^k`. The analytic proof supplies existence of a
finite `N` satisfying the strict choice inequality and chooses `j`
only afterwards. Those geometric and existence steps remain prose.

All declarations have ordinary proved bodies. No custom axiom, `sorry`,
`admit`, or unproved analytic comparator is part of this source.
