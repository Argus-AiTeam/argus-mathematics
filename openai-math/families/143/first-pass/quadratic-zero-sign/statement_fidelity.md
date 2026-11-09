# Statement fidelity: quadratic endpoint zero-sign obstruction

The declarations described here are
`QuadraticZeroSign.endpoint_zero_sign` and
`QuadraticZeroSign.endpoint_gamma_positive` in `Main.lean`. They are universal
real-algebraic implications, not formalizations of ODE existence or of a
limit-cycle theorem. There are no added axioms or desired-sign hypotheses.

## Objects and exact translation

For an actual fixed-profile arc with endpoints `-m,n`, put `N=n>0` **as a
constant at the point**, and scale `y=N*ytilde`, `u=N^2*utilde`.
The variables in Lean denote the scaled data:

| Lean variable | Meaning |
|---|---|
| `z` | `m/N`, positive |
| `l` | endpoint derivative `ell=dn/dm`, positive |
| `d` | original slope times `N` |
| `b` | original positive quadratic coefficient times `N^3` |
| `v` | `K(z)` times the scaled logarithmic derivative `N*w` |
| `a` | original `m_r/N^2`, positive; used only in the second theorem |

`K=z^2(z+1)>0`, `W=2[l*z^3(z-2)+2z-1]`, so the scaled manuscript threshold
is `wstar=W/K`, whereas the scaled `w` is `v/K`.
`schwarzian(z,l,d,b)` is **`z^2` times** the scaled endpoint Schwarzian,
not the Schwarzian itself. Its definition is the manuscript's
`model:Schwarzian-formula` multiplied by `z^2` with scaled `n=1`.
`S0=(3/2)(l^2*z^2-1)` is the similarly cleared baseline.

`F(z,l,s,v)=v^2+2z[z-2+l*z(2z-1)]v+2z^2(z^2-1)s`.
The exact identity checked in `verify.py` is
`F=2*z^4*(z+1)*Dstar` when `s=z^2*S` and `v=K*w`.
Thus `hzero` is precisely the endpoint determinant's zero condition after
multiplication by a strictly positive factor; it does not assert a sign.

## Quantifiers and hypotheses

Both theorems quantify over every real `z,l,d,b,v` (and over every positive
real `a` for the second). The hypotheses are:

* `z>0`, `l>0`, `b>0`.
* `d*z*(1+l)<l-z`. Dividing by positive `z*(1+l)` gives exactly
  `d<(l/z-1)/(1+l)`, the endpoint identity `X=d+kappa*P` with `P>0`.
* If `z<=1`, then `l>1` and `v>0`.
* If `z>1`, then `d<0`.
* If `z>1` and `l>=1`, then `v>=0`.
* If `d<0` and `4*b*z<=d^2`, there exists a real `r>=0` with
  `r^2=d^2-4*b*z` and
  `v<=z(z+1)+(d*l-l-r)*K`.
  This is the manuscript's Riccati upper bound multiplied by `K>0`,
  with `r=2*nu`. It includes `r=0`; neither `r` nor `nu` is divided by.
* `F(z,l,schwarzian(z,l,d,b),v)=0`.

The three conditional branch constraints and the Riccati bound are
**analytic inputs**, not conclusions of Lean and not arbitrary endpoint-jet
properties. The mathematical report derives them for actual quadratic arcs
and identifies the upstream arc/reference facts it uses. Positivity of `P`
and `R` and smooth ODE dependence are not silently formalized by these
declarations. The lemma remains conditional on that analytic bridge.

## Conclusions and substantive content

`endpoint_zero_sign` proves `z!=1` and `(W-v)/(z-1)>0`.
Because `K>0`, this is equivalent to the full normalized endpoint sign
`(wstar-w)/(z-1)>0`. The diagonal is excluded before this quotient is used.
The proof covers `l=1`, `T=0` and `d^2=4*b*z`; none is removed by a genericity
assumption or a limiting argument.

The load-bearing `obstruction` declaration proves that when `z>1`,
`0<l<1` and `v>=W`, the determinant polynomial is strictly positive.
It handles both signs of `T` and both signs of the discriminant using the
Riccati input, the endpoint slope constraint, affine positivity
decompositions, and exact polynomial remainder identities. It does not
assume monotonicity of `F`, positivity of the Schwarzian, the comparison
`v<W`, or the desired gamma sign; it proves the needed versions.

`endpoint_gamma_positive` multiplies the proved quotient by the explicitly
positive factor
`a^2*l*(z+1)^2/[(1+l)*z^2*K]`.
The independently checked determinant and gamma reductions identify this
quantity with the original fixed-model
`gamma_rr-(R_r/R)*gamma_r` when `a=m_r/N^2`.
Those rational identities and the differential meaning of the variables
are checked symbolically and justified in prose, not encoded as ODE
definitions in Lean.

## What this does not verify

The source's actual-arc existence, global quadratic fitting, positive
parameter variations, characteristic comparison and integral estimates are
not machine-checked here. No theorem about the number of cycles, no
absolute-zero theorem from the other manuscript, and no literature novelty
claim follows from the compiler verdict alone. Independent Reviewer must
read the bridge, replay the symbolic certificate and assess the scope.
