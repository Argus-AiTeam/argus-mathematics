# Quantitative refinements: substantive old-draft assessment

## Status, attribution and exact conditional scope

- Unit: `quantitative_refinements`; assessment completed at `research_target_level=exploratory`.
- `final_acceptance=native_independent_reviewer_pending`; this is not the native independent Reviewer.
- The review result has `novelty_status=not_applicable`. Novelty of the old proposed refinements is **not claimed or established**.
- Old source root: `families/057/first-pass/spectral_weighted_inverse`.

The relevant old ledger assertion is `L_SWI_QUADRATIC@1`, content hash `c2c337bc5984e981b557b67b34a342cd0f2e24c6d93903a289ead3fc6561917e`: every nonzero lower spectral band satisfies `μ(μ+mC_0t)≥δ²e^{-b}`, yielding the inverse bound in the manuscript. The positive-root/coarse-minimum formula, direct all-closed-form argument and abstract sharpness family are additional substantive subclaims in `proof.md` Sections 4--5 and 7, not separately ledgered theorems.

I read the staged compact manuscript's `build/sections/spectral.tex`, including its standing hypotheses and `sp:weighted-inverse` at lines 414--501. The manuscript already contains the minimal-lift argument, `sp:spectral-quadratic` at lines 481--483, and the displayed `C(e^{b/4}+\sqrt t\,e^{b/2})` inverse bound. Those conclusions belong to the manuscript; obtaining them again is verification, not a new Argus result.

The reference manifest `campaigns/9100057/MANUSCRIPTS.json` names revision `4eaee87548250b2682affda7d05d947c05554bae`. The read-only staged `spectral.tex` bytes match its listed SHA-256, `fa7d0ce79918e504451f2f9cfdd1e72428cda1c78dd22a180ee9c1e41bd2069c`. No Git operation or reference-source modification was used.

The geometric interpretation remains conditional on all of the following:

- `M` is the fixed compact Kähler orbifold, `U→M` the specified complete normal covering, and `D=(U×U)/P` the diagonal covering with `Ω_S=ω_x+Sω_y`, `S≥1`.
- The common positive scalar gaps on `U` supply the required unweighted bundle-complex gap and the `x`-direction estimate. Their simultaneous existence is **assumed**, not proved here.
- `L=E^*=p_y^*K_M^*` has its fixed unscaled coefficient metric; `h` is smooth, `1≤h≤e^b`, with the stated curvature lower bound.
- `δ>0`, `b,t≥0`, `m=2n`, and a fixed nonnegative curvature constant `C_0` give `B=e^b≥1` and `a=mC_0t≥0`. Replacing a curvature-bound constant by `max(C_0,0)` only weakens its hypothesis.
- The domain, exactness, primitive and Bochner inputs assigned to the other units hold with these constants. Weighted/unweighted differential domains are identified where justified; their adjoint domains are **not** identified merely by norm equivalence.

Within those inputs, I find no reversed quadratic or invalid quantitative deduction. The sharper formula and optimality statement are supported in the exact scopes below, not unconditionally or as geometric sharpness.

## 1. Direct comparison for every closed form

The sufficient abstract analytic inputs for degree `q≥1` are:

1. For `η∈ker d_q`, an unweighted minimal primitive `u=T_0η∈Dom d_{q-1}` exists with `du=η` and `δ‖u‖_0²≤‖η‖_0²`.
2. In each relevant degree, `‖v‖_0²≤‖v‖_h²≤B‖v‖_0²`, with the differential domains compatible as stated.
3. For closed `η∈Dom d_{q-1,h}^*`, the Bochner estimate is
   `δ‖η‖_0²≤‖d_h^*η‖_h²+a‖η‖_h²`.

Take such a nonzero `η` and set

\[
H=\|\eta\|_h^2>0,\quad N=\|\eta\|_0^2,\quad
E=\|d_h^*\eta\|_h^2,\quad L=\|u\|_h^2.
\]

The primitive is in the weighted **differential** domain. The adjoint definition therefore permits

\[
H=\langle du,\eta\rangle_h=\langle u,d_h^*\eta\rangle_h.
\]

This requires no adjoint-domain membership for `u`. Consequently

\[
H^2\le EL,\qquad \delta L\le BN,\qquad \delta N\le E+aH.
\]

Multiplication by nonnegative factors gives

\[
\delta^2H^2\le BE(E+aH).
\]

Thus every such closed form, not just a band vector, satisfies

\[
x(x+a)\ge\delta^2/B,\qquad
x=\frac{\|d_h^*\eta\|_h^2}{\|\eta\|_h^2}\ge0. \tag{1}
\]

Since the right side is positive, `x>0`. This is a valid direct proof under the stated inputs. There is no step equating two adjoint domains and no reliance on eigenvectors.

**Attribution and verdict.** The direct all-form presentation is supplied by the old Argus draft. It is a useful alternative route to the manuscript conclusion, not an established novelty result. Once the spectral theorem is available, a lower bound for all lower spectral bands also gives the corresponding form coercivity; the different presentation does not by itself establish a strictly stronger final operator bound.

## 2. The original manuscript spectral quadratic

Let `A=dd_h^*` on the closed range `B_q=ker d_q=im d_{q-1}`. For a nonzero vector in a bounded lower band `(0,μ]`, bounded spectral support puts it in `Dom A` and gives

\[
0<x\le\mu.
\]

Because `a≥0`, `y↦y(y+a)` is increasing for `y≥0`; (1) yields

\[
\mu(\mu+a)\ge\delta^2/B
=\delta^2e^{-b}. \tag{2}
\]

This is exactly the manuscript inequality with `C_1=mC_0`. It concerns **nonzero** lower bands. It does not assert (2) for arbitrary `μ>0` when the associated band is zero.

The manuscript's original minimal-lift derivation has the same direction. If `V` is the weighted minimal inverse, then on this band

\[
\|V\eta\|_h^2
=\langle A^{-1}\eta,\eta\rangle_h
\ge\mu^{-1}H.
\]

The admissible unweighted primitive gives `‖Vη‖_h²≤(B/δ)N`, hence

\[
N\ge\frac{\delta}{B\mu}H.
\]

Substituting into `δN≤E+aH≤(μ+a)H` proves (2). The coarse closed-range inverse is established before using `A^{-1}`, so this reasoning is not circular. It works for nonzero spectral bands, including continuous spectrum, without claiming an eigenvector exists.

**Attribution and verdict.** `L_SWI_QUADRATIC@1` reproduces the manuscript's `sp:spectral-quadratic` and inverse estimate. It is conditionally supported; neither a refutation nor a new theorem is identified. The old Engineer/Reviewer support judgements on `proof.md` are historical records, not current final acceptance.

## 3. Positive root, coercivity and the combined minimum

Put `s=δ/√B>0`. The proposed root is

\[
r=\frac{\sqrt{a^2+4s^2}-a}{2}.
\]

Since `a≥0` and `s>0`, the square root is strictly greater than `a`, so `r>0`. Direct squaring gives

\[
r(r+a)=s^2.
\]

If `0≤x<r`, then

\[
r(r+a)-x(x+a)=(r-x)(r+x+a)>0,
\]

contradicting (1). Therefore `x≥r` for every closed form in the adjoint form domain.

The passage to an inverse-norm bound is also valid, not merely a formal reciprocal substitution. Let `V:B_q→K^\perp` be the already bounded weighted minimal inverse, where `K=ker d_{q-1}` in the source space. For `u∈K^\perp` and `z∈Dom d`,

\[
\langle V^*u,dz\rangle_h
=\langle u,Vdz\rangle_h
=\langle u,z\rangle_h.
\]

Here `Vdz` is the orthogonal projection of `z` onto `K^\perp`. Thus `V^*u∈Dom d_h^*`, `d_h^*V^*u=u`, and coercivity gives

\[
\|V^*u\|_h^2\le r^{-1}\|u\|_h^2.
\]

Hence `‖V‖=‖V^*‖≤r^{-1/2}`. Independently, minimality and the unweighted primitive imply

\[
\|V\eta\|_h^2\le (B/\delta)\|\eta\|_0^2
\le (B/\delta)\|\eta\|_h^2.
\]

The claimed combined bound is consequently

\[
\boxed{\ \|V\|\le\min\{\sqrt{B/\delta},\,r^{-1/2}\}\ }. \tag{3}
\]

Let `g=δ/B`. The equivalent coercivity constant is `max(g,r)`. Its switch is exactly

\[
a_*=\delta(1-1/B):
\qquad
g(g+a)\le s^2\ \Longleftrightarrow\ a\le a_*.
\]

Monotonicity then gives `r≥g` below the switch and `r≤g` above it. At `a=0`, `r=s` and the root inverse bound is `B^{1/4}/√δ`. At `B=1`, the coarse term in (3) is `1/√δ` for all `a≥0`, preventing artificial deterioration when the weight has no oscillation.

**Attribution and verdict.** The explicit root unpacks the manuscript's instruction to solve the quadratic; the minimum combines it with the elementary norm-equivalence bound. The old draft makes the constants more explicit, but establishes no prior-art or novelty claim for this refinement. Formula (3) is supported under the analytic inputs above.

## 4. The displayed exponential bound

For `x>0`, `a≥0` and `s²≤x(x+a)`, two cases give

\[
s^2\le x(s+a).
\]

If `x≤s`, use `x²≤xs` in the hypothesis; if `x≥s`, use `s²≤xs` and `xa≥0`. Dividing by `xs²` proves

\[
\frac1x\le\frac1s+\frac a{s^2}.
\]

In particular this holds at `x=r`, so

\[
\|V\|^2
\le r^{-1}
\le \frac{\sqrt B}{\delta}+\frac{aB}{\delta^2}
=\frac{e^{b/2}}{\delta}
+\frac{mC_0t\,e^b}{\delta^2}.
\]

Taking square roots and using `√(u+v)≤√u+√v` for `u,v≥0` yields

\[
\|V\|
\le \delta^{-1/2}e^{b/4}
+\sqrt{mC_0}\,\delta^{-1}\sqrt t\,e^{b/2}. \tag{4}
\]

Thus the manuscript's single constant `C` can, for example, be chosen as `max(δ^{-1/2},√(mC_0)/δ)`. It depends on the fixed dimension, gap and curvature constant, not `S,b,t` or derivatives of `h`. This is a conditional constant calculation: the uniform analytic inputs are assessed elsewhere.

The endpoint `t=0` is included, as are `b=0` and `C_0=0`. The reciprocal estimate is generally looser than (3), and its separated sum of square roots need not be sharp. Transfer to the reversed `E` complex additionally requires the complete-domain Serre-duality statement; scalar arithmetic does not supply that transfer.

**Attribution and verdict.** The exponential exponents and the big-constant bound are already in the manuscript. The explicit coefficients and root/coarse comparison are old-draft quantitative unpacking, not a proved novelty contribution. The deduction is valid.

## 5. Abstract optimality: exact proof and exact restriction

The relevant comparison class permits different equivalent norms in different degrees of an exact Hilbert complex, with the same constants `1,B`, unweighted gap `δ`, and the Bochner-type inequality above. It does **not** require those norms to come from a common scalar bundle multiplier on a manifold.

For any `δ>0`, `B≥1`, `a≥0`, use the two-term complex

\[
\mathbb C\xrightarrow{\sqrt\delta}\mathbb C.
\]

Both unweighted squared norms are ordinary absolute square. Give the source squared norm `B|u|²` and target squared norm `w|z|²`, `1≤w≤B`. The weighted adjoint is multiplication by `√δ\,w/B`; for a target vector,

\[
H=w|z|^2,\quad N=|z|^2,\quad
x=\delta w/B,\quad E=xH,\quad
L=(B/\delta)|z|^2.
\]

Thus `H²=EL` and `δL=BN` are equalities. The remaining hypothesis is exactly

\[
E+aH\ge\delta N
\quad\Longleftrightarrow\quad
w(x+a)\ge\delta. \tag{5}
\]

The inverse has squared norm `1/x`.

- **Below the switch:** if `0≤a≤a_*`, choose `x=r` and `w=Br/δ`. Since `g≤r≤s`, `1≤w≤√B≤B`. The root equation gives `w(r+a)=δ`, so (5), Cauchy--Schwarz, the lift comparison and the final root bound are all equalities.
- **At or above the switch:** choose `w=1`, so `x=g`. Then (5) is `g+a≥δ`, exactly the condition `a≥a_*`. The coarse inverse bound is an equality.

If one additionally requests the analogous Bochner-type inequality at the source degree of this two-term model, its energy is `δw|u|²` and its weighted norm is `B|u|²`; `δw+aB≥δ` verifies it too.

These witnesses exist throughout the parameter ranges, not just at six sample points. Together with the universal lower bounds they establish optimal coercivity **`max(δ/B,r)` in this abstract comparison class**, equivalently the inverse bound (3). At the switch both mechanisms agree. They do not show that the looser separated expression (4) is attained for all parameters.

**Attribution and verdict.** This explicit comparison-class witness family is the old Argus draft's abstract sharpness proposal. The argument is correct in the stated class; novelty is not claimed or checked.

**No geometric sharpness follows.** The model chooses the source multiplier `B` and target multiplier `w` independently. On a one-point model, a single scalar metric multiplier shared by the two degrees would not allow `B≠w`. No construction here realizes these two norms by one smooth multiplier on the manuscript's complete diagonal covering, respects its actual Chern curvature, or realizes its common scalar-gap hypotheses. Nonconstant geometric weights might lead to effective comparisons, but that is not a realization proved by this draft. Geometric optimality is neither established nor needed for its claimed abstract statement. Treating these examples as counterexamples to the manuscript, or as proof that its geometric exponent cannot improve, would be invalid.

## 6. All six retained rational examples

I independently recomputed the following exact values from `exact_certificate.json`, using `Fraction`, without rerunning the old checker. Here `β=E+aw-δ` at `z=1`, `κ=x(x+a)-δ²/B`, and `Q=√B/δ+aB/δ²`. The examples have rational `√B`.

| Old example | `δ,B,a,w` | `x` | `‖V‖²=1/x` | `β` | `κ` | `Q` | What it witnesses |
|---|---|---:|---:|---:|---:|---:|---|
| `zero_curvature_exponent` | `1,16,0,4` | `1/4` | `4` | `0` | `0` | `4` | Root equality; inverse norm `2=B^{1/4}` |
| `interior_root_equality` | `1,16,3/8,2` | `1/8` | `8` | `0` | `0` | `10` | Interior root equality, but not equality in the looser reciprocal bound |
| `coarse_bound_switch` | `1,16,15/16,1` | `1/16` | `16` | `0` | `0` | `19` | Root and coarse bounds meet |
| `large_curvature_coarse_bound` | `1,16,1,1` | `1/16` | `16` | `1/16` | `1/256` | `20` | Coarse equality with strict Bochner/quadratic slack |
| `nonunit_unweighted_gap` | `4,9,10/9,2` | `8/9` | `9/8` | `0` | `0` | `11/8` | Root equality with nonunit gap |
| `no_weight_oscillation` | `1,1,2,1` | `1` | `1` | `2` | `2` | `3` | Coarse equality when `B=1`; root-only bound is weaker |

All cases satisfy the norm-comparison and positivity requirements, `H²=EL`, `δL=BN`, and nonnegative `β,κ`. `exact_checks.json` retains the rational recomputation and the switch/branch checks. These are exact finite witnesses for the named instances; the continuum optimality argument is the proof in Section 5, not a conclusion inferred from sampling.

## 7. Mechanical evidence and its limits

The shared read-only old `verify.py` was inspected and executed **once** for these two units, not once per unit. It used `$WORKSPACE/argus-latest/.venv/bin/python`; the generated output was redirected to `../scalar_certificate/verify_stdout.json`, with exit **0** in `verify_execution.json`. Its output checks all six old rational examples, the polynomial identity, the local exterior-algebra sign and old compiler/archive/ledger consistency. The old `verification_result.json` is a historical copy, not a second current run. None of these checks reads and verifies the analytic proof.

The fresh scalar replay in `../scalar_certificate/replay/` compiled the byte-identical six-declaration source with Lean **4.31.0**, Lake **5.0.0-src+68218e8**, actual Mathlib workspace `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`. Compiler and axiom-audit exits were **0**, with `proof_holes=[]`, and the unchanged source/fidelity hashes match. The legacy `argus-latest` interpreter worked; no fallback or install was needed. The required durable direct runner's receipt and reclaimed exit-0 result are retained.

That formal source proves scalar multiplication, monotonicity, reciprocal and finite-sum implications. It does **not** define `r` by a square root, prove norm/domain hypotheses, reason about `dd_h^*`, take an operator inverse, formalize the continuous abstract family, or realize it geometrically. The official audit finds no newly introduced axioms; it is not a claim that all imported foundations are axiom-free.

The required fresh Jacobian call used the exact current inspected contract for `polynomial.sos.decomposition.check`. It returned `is_valid=true`, exact coefficient identity, server **0.14.0**, protocol **2025-11-25**, adapter exit **0**, no timeout/error. Its payload is only `4μ²+4μa+a²=(2μ+a)²`. That is relevant algebra, not a certificate of any analytic or geometric conclusion. Dedicated discovery/contract/payload/output JSON lives in the scalar unit.

## 8. Unresolved obligations and final assessment

There is no specific unresolved arithmetic gap in the old root/minimum or abstract-optimality derivations identified here. Their supported status remains **conditional** on the explicitly stated analytic estimates. Concrete obligations that the scalar evidence cannot discharge are:

1. justify that the actual geometric complex has the stated common unweighted gap, exactness and admissible primitives;
2. establish the complete weighted form-domain Bochner inequality with uniform `δ` and `a=mC_0t`, including curvature sign and the relevant closed domains;
3. justify the complete-domain spectral and Serre-duality transfers when applying the bound to the `E` complex.

These obligations belong to the other indexed units; they are not replaced by the toy complex or exact arithmetic. Existence of all assumed gaps, downstream zero-spectrum/localization/abelianity claims, a common-multiplier geometric extremizer, and novelty of a proposed presentation are not settled by this assessment. No new manuscript problem was investigated.

After the dedicated scalar replay's ledger mutations, both official checks ran against the **current campaign root** `campaigns/9200057`:

```text
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.math_state check --project-root campaigns/9200057
exit 0; {"ok": true, "issues": []}

$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.proof_graph_check check --project-root campaigns/9200057
exit 0; proof graph valid: 8 node(s)
```

The real outputs and exit/root records are retained in `../scalar_certificate/math_state_check*` and `proof_graph_check*`. No proof graph, summary, index or old input was edited; no review node was accepted. Only a separate mathematical replay claim received mechanical evidence. The two substantive assessments and the broader review still await native independent Reviewer acceptance.

## Sources

- Old `proof.md`, result/scope and Sections 4--5, 7--8; Sections 1--3 and 6 only for the stated dependency boundary.
- Old `research/MATH_STATE.json`: `L_SWI_QUADRATIC@1`, its context and historical judgements; `C_SWI_ALG` versions for the distinct scalar proof scope.
- Old `exact_certificate.json`, `verify.py`, `verification_result.json`, `source_status.json`, `Main.lean`, `statement_fidelity.md`, and the retained compiler/Jacobian records.
- Read-only staged compact manuscript: `research/openai_manuscript/The-abelianity-conjecture-for-special-compact-Kahler-manifolds-September-23-2026/build/sections/spectral.tex`, standing gaps and `sp:weighted-inverse`, file hash checked against the existing campaign-9100057 reference manifest.
- Current `exact_checks.json` and the scalar unit's exact replay, typed Jacobian, immutable Lean and ledger-check artifacts. They are supporting evidence for the stated scopes, not final acceptance certificates.
