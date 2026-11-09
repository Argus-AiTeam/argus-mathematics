# C55_CORE: algebra, formal versions, and statement fidelity

**Engineer assessment: `supported_algebra_only`.** The current, version-3
source compiles and its declared algebraic scope is accurately described by
the current fidelity document. The version-1 refinement lemma is false as
stated; its repair must not be erased by treating all three receipts as copies
of one successful proof. Nothing here kernel-verifies a category.

## Claim, hypotheses, version, and attribution

The read-only source is
`families/055/first-pass/gepner-aisle-audit/Main.lean`.
The historical ledger has C55_CORE versions 1, 2, and 3. Certificate
`C55_CORE-16b808fb34f65fe6.json` embeds version 3 and the current
`statement_fidelity.md`; the compiler-working copies are byte-identical.
The numerical reference is the supplied Gepner manuscript's
`build/sections/numerical.tex`, at revision
`4eaee87548250b2682affda7d05d947c05554bae`. All 16 files in the two-manuscript
reference manifest match their supplied version entries; this is version
binding, not a review of the large-volume manuscript.

`GepnerAisle.V` is an arbitrary element of `R^4`. Its fields have no
object-realizability predicate. Put `cut(u,v)=d+c/2+u*r` and
`uG=(5-sqrt(5))/10`. The 19 declarations cover:

| Declarations | Exact supported content and restrictions |
|---|---|
| `phi_inverse`, `inverse_phi`, `phi_period_five` | The displayed rational matrices are mutual inverses and `M^5=I` on every real quadruple. |
| `gepner_polynomial`, `gepner_bounds` | `5*uG^2-5*uG+1=0` and `27/100 <= uG < 138197/500000`. |
| `slope_criterion_threshold`, `slope_criterion_attained` | `20u+13s<=13`, `2u<=s` imply `u<=13/46`; equality is attained at `(13/46,13/23)`. |
| `parameter_margins`, `concrete_margins` | The four displayed margins are positive for `0<u<13/46`, `0<delta<=min(u/4,(13/46-u)/10)`; the concrete version uses `27/100<=u<=138197/500000`, `delta=1/2000`. |
| `comparison_separation` | For `s>0,u>=0,C>0,sR<=C,D<=0,err>=-3*delta*C` and `s/2-u-3*delta*s>0`, one has `C/2-uR-D+err>0`. |
| `four_corner_control`, `four_cut_circuit` | Four inequalities `N +/- epsilon*r +/- epsilon*c >=0` imply `epsilon*(abs(r)+abs(c))<=N`; the four-cut circuit holds under `5u^2-5u+1=0`. Positivity of its weight is a separate application. |
| `endpoint_r0`, `endpoint_r3`, `endpoint_c3`, `numerical_kernel_separation` | The three scaled coordinate identities are universal; `r=c=cut(u,w)=cut(u,M^-1*w)=0` implies `d=e=0` when `u!=0`. |
| `explicit_refinement_separation` | The exact combined-endpoint statement below, not the version-1 statement. |
| `explicit_support_arithmetic`, `explicit_support_transport` | The displayed scalar premises bound a pulled-back norm by `1000000*Q`, then its transported norm by `30000000*Q`. They do not prove those premises for objects. |

These are a reconstruction of the reference matrix and charge, plus algebra
supporting the old draft's proposed quantitative strengthenings. Neither the
old receipt nor this assessment establishes research priority or novelty.

The four margin conclusions are positivity of
`u-delta`, `3/10-u-(3/2)*delta`,
`13/46-u-(36/23)*delta`, and `1/2-(23/13)*u-3*delta`.
The support-arithmetic premises are exactly
`Q>=0`, `N<=2Q/5`, `X<=1000000N`, `D<=N+X/2`,
and `E<=Q/5+X/2+D/2`, with conclusion `X+D+E<=1000000Q`.
The transport premises are `Q>=0`, `W<=1000000Q`,
`P<=(82/3)W`. No additional signs on the other scalar variables
are required by these formal statements.

## Decisive historical distinction

The current refinement declaration assumes real numbers satisfying

```text
a >= 7/20; n1,n2,X >= 0; X/8000 <= n1;
T <= 16X + 24(n1+n2);
n0+n3 >= -T/500000;
n0+a*n1+a*n2+n3 = 0.
```

Then `X<=8000*n1` gives `T<=128024*(n1+n2)`, whereas the circuit gives
`(7/20)*(n1+n2)<=T/500000`. The strict gap is
`7/20-128024/500000=1468/15625>0`. Thus `n1=n2=X=0`.
No sign hypothesis on `n0,n3,T` is being silently added.

Version 1 instead imposed the two *separate* bounds
`n0>=-T/500000` and `n3>=-T/500000`. It admits the exact assignment

```text
a=7/20, n1=1, n2=0, X=8000, T=128024, n0=n3=-7/40.
```

Every displayed version-1 premise holds, including the circuit, but `n1=0`
is false. The combined version-3 premise fails at that assignment:
`-7/20 < -128024/500000`. This is a counterexample to a historical scalar
statement, not to an actual-object lemma, the current source, or a manuscript.
For actual endpoints the report derives separate errors `h*R0,h*R3` and
sets `T=R0+R3`; adding them gives the **combined** bound. It does not charge
the entire sum twice.

The archived diagnostics agree with this distinction. Version 1 fails both
noncomputability checks and the attempted refinement proof; its diagnostic
`sorryAx` dependency is from that failed elaboration, not a successful
certificate. Version 2 has the correct combined premise and no such failed
proof, but still fails the real-division noncomputability declarations.
Version 3 adds `noncomputable section` and the matching `end`; its mathematical
statement agrees with version 2. See [historical_versions.json](historical_versions.json)
for exact source differences, receipts, and the checked rational assignment.

## Computation and compiler replay

The preserved `verify.py` was inspected before execution. Its default mode
recomputes exact identities and compares the stored certificate; its only
certificate-writing branch requires `--write-certificate`, which was not used.
The first invocation failed because the required Argus interpreter lacks
SymPy. The successful standalone-checker invocation used the already assigned
isolated Jacobian Python environment, with **SymPy 1.14.0**, without importing
Jacobian into Argus or installing packages. Both outcomes are retained in
[exact_replay.json](exact_replay.json). The comparison returns exit 0.

This checks the matrix and Euler form, the eigencharge, the piecewise-affine
Xu/envelope comparisons, all four strongest constants, source anchors, and
the historical successful receipt's exact source/fidelity/claim binding.
It does not parse a categorical proof. Its inherited `new_theorem` and
`publishable` metadata are not conclusions of this review.

The fresh read-only compiler replay used **Lean 4.31.0**, **Lake
5.0.0-src+68218e8**, and the existing
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0` workspace.
Compiler exit is **0** and the actual Argus axiom-audit exit is **0**; no
proof holes or newly declared axioms were reported. The printed dependencies
are the ordinary `propext`, `Classical.choice`, and `Quot.sound`, not an
axiom-free foundation. Source and fidelity stayed unchanged and match the
successful old certificate. See [lean_replay.json](lean_replay.json).
The durable submission receipt is [lean_submit.json](lean_submit.json).
No old certificate was overwritten, no new `.lean` source was authored, and
no fresh mechanical status was manufactured in the current ledger.

One inspected bounded Jacobian operation,
`optimization.linear.rational_general_optimum.compute`, independently
returned `OPTIMAL`, point `(13/46,13/23)`, and dual multipliers
`(1/46,13/46)` for the two criterion inequalities. Their weighted sum is
exactly `u<=13/46`. The payload omits redundant finite bounds from the
historical failed request; the returned point also satisfies those old
bounds, so the optimum agrees. This is not a categorical threshold theorem.
The old admission error remains a non-conclusion. Exact current contract,
payload, typed output, server **0.14.0**, protocol **2025-11-25**, adapter exit
**0**, and non-timeout status are in the four `jacobian_*.json` files here.

## Supported scope and remaining boundary

The current fidelity reading is correct: endpoint coefficient estimates,
geometric common-heart membership, numerical lattice identification,
functor periodicity, and the entire slicing construction are not Lean
declarations. The threshold is optimal only for the two stated sufficient
inequalities, not a failure of aisle inclusion at `u=13/46`.
No further defect was found in the current algebraic statements.
Their application to actual objects is assessed in the dependent units;
it cannot be inherited from compiler success. This is an Engineer judgement,
not the required native Host Reviewer acceptance.
