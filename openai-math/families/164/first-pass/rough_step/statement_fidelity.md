# Exact algebra for rough-step removal

This document describes claim `RS_EXACT_ALGEBRA` and the declarations in
`Main.lean`, all in namespace `RoughStep`. All integer, rational, polynomial, and group variables below are
universally quantified. No finite computation is promoted to a universal
statement.

* `rational_gap`: if the nonzero integer `N` clears a rational `r`,
  so that `N*r` is the integer `k`, and `|N*r|<1`, then `r=0`.
  This is the exactness implication applied to interpolation jets and to
  interpolated values after their denominators have been bounded.
* `integral_of_coprime_multiples`: for integers `d,t,n,k` and
  rational `r`, if `d*r=n`, `t*r=k`, and `d,t` are coprime in the Bezout
  sense, then `r` is an integer. In the proof, `d` is a smooth denominator
  clearing multiplier and `t` is a power of a rough step. Establishing
  coprimality from their prime factors is ordinary integer arithmetic in
  the mathematical report, not a hidden hypothesis of this declaration.
* `linear_power_dvd_of_hasse_jets`: for a rational polynomial `R`,
  rational `a`, and any natural `e`, vanishing Hasse derivatives of orders
  `0,...,e-1` at `a` imply divisibility by `(X-a)^e`. Hasse derivatives are
  divided derivatives, equivalently Taylor coefficients; over the rationals
  their vanishing is equivalent to ordinary derivative vanishing.
* `exact_linear_division`: for arbitrary rational `t0,m`, with
  `m!=0`, the same jets at `-t0/m` imply a rational polynomial factorization
  `R=(t0+m*X)^e*M`. There is no assumption bounding the coefficients,
  interpolation length, or rational denominators.
* `residue_class_exists` and
  `residue_reparametrization`: for arbitrary integers `K,t,u,b`
  with Bezout coprimality, the class `u+K*y=b (mod t)` has a representative
  `a`, and is equivalent to `y=a (mod t)`. These declarations do not
  incorrectly require the retained modulus and removed step to coincide.
* `descent_exponent_invariant`: for all natural `n,s,D`,
  `2*(s*D)*s^n+2=2*D*s^(n+1)+2`. This is the exponent bookkeeping for the
  finite-power strengthening, not a formalization of the Lie degree bound.
* `kernel_membership`: for arbitrary groups `G,A`, homomorphisms
  `chi:G->A` and `v:A->G` with `chi(v(u))=u` for every `u`, and
  `chi(p)=a*m`, the element `v(a^-1)*p*v(m^-1)` belongs to the kernel.
  Specialize `A` to the multiplicative encoding of the additive reals and
  `v(t)=exp(t*V)` to obtain the exact manuscript kernel formula.
* `kernel_factorization`: in arbitrary groups, with no
  commutativity assumption on `G`, the ordered product
  `v(a)*(v(a^-1)*p*v(m^-1))*v(m)` equals `p`. In particular the left and
  right correction factors have not been interchanged.
* `periodic_right_factor`: for any subgroup `Gamma` of any group,
  `g^K in Gamma` implies `g^(j+K*k)=g^j*gamma` for some `gamma in Gamma`,
  for all integers `j,k,K`. This proves the right-coset periodicity used
  after splitting the integer spatial polynomial modulo the fixed `K`.

The compiler checks these algebraic statements, not the whole analytic
rough-step theorem. It does not check the Lagrange coefficient estimates,
the denominator bounds preceding exactness, finite Szemeredi's theorem,
the corrected quantitative equidistribution theorem, nilpotent Lie theory,
compactness/Lipschitz estimates, counting error bounds, or the final
asymptotic dimension induction. Those parts are proved or explicitly cited
in `report.md`. The formal source has no additional analytic assumptions
and does not encode the desired conclusion as a hypothesis.
