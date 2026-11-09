# Statement fidelity: claim C_CAP_ALGEBRA

`Main.lean` imports the host's built Mathlib and defines the namespace
`CapAudit`. This is a formalization of exact algebra/coercivity used in
the complete analytic cap proof in `report.md`, not a formalization of
Proposition cap or of its PDE estimate.

Every variable in the first eight declarations below is universally
quantified over the real numbers; no coefficient is implicitly positive.

| Declaration | Exact reading and hypotheses |
|---|---|
| `directed_T` | The two displayed normalized expressions for the multiplier's tangential coefficient agree, for arbitrary real `H Is eps t B`. |
| `directed_S` | Substituting `C=mu*As+A*r` and the first derivatives of the weight gives exactly the normalized transverse expression; `A As At H Is eps t B mu r` are arbitrary reals. |
| `directed_J` | The two normalized cross-coefficient expressions agree, for arbitrary real `A As H Is eps t mu r`. |
| `square_completion` | For arbitrary real `T S J x y`, assuming `T != 0`, the quadratic form equals the displayed split plus `(T*x+J*y)^2/(2*T)`. |
| `quadratic_lower` | Assuming `T>0`, dropping that nonnegative square gives the stated lower bound. No sign hypothesis on `S` or `J` is omitted. |
| `uniform_coercivity` | Assuming `H>0`, `T>=H/4`, and `S-J^2/(2*T)>=gamma`, the quadratic form bounds `(H/8)*x^2+gamma*y^2`. `gamma` is arbitrary: the analytic proof separately supplies a uniformly positive choice. |
| `scaled_young` | Assuming `v>0`, the signed product `u*e*x` is at most `(v/4)*x^2+(e^2/v)*u^2`. Applying it also to `-e` gives the absolute-value version. |
| `transverse_drift_decomposition` | The exact polynomial identity in equation (22), before division by the uniformly positive `G*v^2`, holds for arbitrary real `K Ky G Gy v vy r l`. `Ky`, `Gy`, `vy` are scalar slots, not Lean derivatives; identifying them with derivatives belongs to the analytic proof. |

`high_factor_count` quantifies over a natural number `l>=8` and proves
`l < 2*(l-3)` with natural truncated subtraction.
`no_two_high_factors` quantifies over natural `l a b` and proves that
`l>=8`, `a>=l-3`, `b>=l-3`, and `a+b<=l` cannot all hold.
Identifying these counts with terms in the differentiated equation is
the chain-rule argument in the report, not a fact encoded in Lean.

In the application, `x,y` in the quadratic declarations stand for
`u_t,u_s`; they are not the physical coordinate variables.
`T,S,J` stand for the multiplier coefficients, or for their normalized
versions with a consistent common positive factor. `H=lambda+p/d`
is positive in the analytic application. `Is` means the scalar `I_s`,
not a set or an independent estimate.

The file contains no PDE functions, integration domain, trace operator,
Sobolev space, flow map, curvature tensor, compactness argument, or
metric-height family. In particular it does not prove existence of the
positive uniform margin near the curvature zero set, bounds on elliptic
cutoff errors, vanishing of artificial-edge fluxes, or the all-orders
nonlinear bootstrap. Those are proved in prose in the report and remain
subject to independent mathematical review. A successful compiler run
certifies only the universally quantified statements listed here.
