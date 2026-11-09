# Lower-perturbation rigidity — engineering assessment

**Claim:** `C_PERTURBATION_RIGIDITY`, version 1, ledger content hash
`c1ed0369088aeb6c3a68a6ad60e91bdfb0606929379b7f21bf5866f06d5dae48`.
**Engineering verdict:** supported with the stated field, characteristic,
grading, and local-nilpotence hypotheses. **Independent review required:** yes;
this is not independent acceptance.

## Sources, version, and attribution

The current `OBJECTIVE.md` and `research/DRAFT_REVIEW_INDEX.json` govern this
assessment. The unit is old `report.md` Theorem 2 and its actual kernel
statement, not every geometric conclusion that later uses it.

- `SC = families/049/first-pass/stable_core_certificate`
- `FS = SC/formal_sources/OAI/AlgebraicGeometry/StableCoordinate`

The preserved draft `SC/report.md` has SHA-256
`68b969f393762d6b834c6b0e03ce5a1eb82a2e8944c97af14313184acecbd875`.
Its statement is implemented by
`IndependentStableCore.lower_perturbation_rigidity` in `SC/Main.lean`.
The helper proofs are reused OAI implementation material, including local
Lean 4.31 compatibility work; they are not separately counted as new drafts.
The old ledger and graph state the unrestricted lower-perturbation claim,
but their support labels were not used as proof.

The comparison source is OpenAI, *A stable coordinate that is not a coordinate
in four variables*, October 5, 2026, `sections/05-rigidity.tex`,
`prop:rigidity`, revision `4eaee87548250b2682affda7d05d947c05554bae`.
Its SHA-256
`a27d1e5381626ace7c75640598312beb6a44b8f8f5bc183f5b7f2f114c444819`
matches the existing campaign 9100049 manuscript manifest. That proposition
fixes \(a^3b+a^2u^2-d^2\). The arbitrary-\(W\) version is the old engineering
draft's proposed extension of that argument, not the manuscript's printed
proposition and not a source-verified globally novel theorem.

## Exact theorem and actual objects

Let \(k\) be a **field of characteristic zero**, and let
\[
 C=k[a,d,b,c,u]/(ac-bd-1).
\]
There are two integer gradings on this quotient:

| Generator | \(a\) | \(d\) | \(b\) | \(c\) | \(u\) |
|---|---:|---:|---:|---:|---:|
| Fiber weight | 1 | 1 | -1 | -1 | 0 |
| Auxiliary degree | 0 | 1 | -1 | 0 | 1 |

Let \(W\in C\) satisfy
\[
 \operatorname{proj}^{\rm aux}_j(W)=0\quad\text{for every }j>1.
\]
Let \(D:C\to C\) be a \(k\)-derivation such that every element is killed by
some iterate of \(D\), and such that \(D\) maps every fiber-weight space
into itself. Then
\[
 D(W+a^2u^2-d^2)=0\quad\Longrightarrow\quad D=0.
\]
Neither auxiliary homogeneity nor fiber homogeneity of \(W\) is assumed.
For example \(W=d+u\) is allowed, despite its different fiber weights.
The bound is on the **actual quotient grading**, not ordinary polynomial
degree or a preferred representative. Every \(W\) has finite support because
it is an element of a graded algebra, not a formal infinite sum.

`Main.lean` has precisely `[Field k] [CharZero k]`, arbitrary `W : C k`,
`LeadingComponent.DegreeLE (auxiliaryPiece k) 1 W`, unrestricted
`IsLocallyNilpotent D`, and preservation of each `fiberPiece`. It does not
assume a shift bound, coefficient polynomiality, or a separately supplied
domain instance. Those are proved ingredients.

## Checked decisive argument

### 1. Domain and compatible quotient gradings

In \(k[a,d,b,u][c]\), the equation \(ac-(bd+1)\) is a primitive linear
polynomial: \(a\) is prime and does not divide \(bd+1\). Gauss's lemma and
the UFD property of the ambient polynomial ring make it prime. Thus \(C\)
is a domain. This is derived from \(k\) being a field; it is not an
additional hypothesis smuggled into the theorem.

For either row of weights the three terms \(ac,bd,1\) have degree zero.
Consequently the principal defining ideal is homogeneous. Weighted
projections descend to the quotient with a direct-sum decomposition.
The two projections commute: upstairs each is a coefficientwise monomial
selection, these selections commute, and both descend through the homogeneous
ideal. Thus taking an auxiliary component does preserve any fiber-weight
space preserved by \(D\). Merely assigning two weights without these
quotient facts would not have sufficed.

### 2. Attained leading shift, including negative shifts

For each of the five homogeneous generators \(g_i\), list the finite
degrees \(j\) occurring in \(D(g_i)\), and form the finite set of shifts
\(j-\deg_{\rm aux}(g_i)\). If \(D\ne0\), some generator image is nonzero,
so this finite set is nonempty and has a largest member \(m\in\mathbb Z\).

Define \(D_m\) on a homogeneous \(r\) of degree \(e\) by
\[
 D_m(r)=\operatorname{proj}^{\rm aux}_{e+m}(D(r)),
\]
and extend linearly. The product rule proves that every such component is
a derivation. Components with shift above \(m\) vanish on all generators,
and therefore on the algebra they generate. This supplies a global shift
bound on every homogeneous element, not merely a bound on five test values.
The attained generator component makes \(D_m\ne0\).

For homogeneous \(r\) of degree \(e\),
\[
 \operatorname{proj}^{\rm aux}_{e+nm}\bigl(D^n(r)\bigr)=D_m^n(r).
\]
Indeed every composition containing one shift strictly smaller than \(m\)
has sum strictly smaller than \(nm\); every other shift is at most \(m\).
This argument works unchanged when \(m<0\), as well as when \(m=0\) or
\(m>0\). Local nilpotence of \(D\) therefore gives local nilpotence of
\(D_m\) on homogeneous elements. Finite decompositions, using a common
sufficiently large exponent, give it on all elements. There is no
positivity assumption on the grading or the leading shift.

### 3. Arbitrary lower terms really disappear

The global shift bound gives auxiliary degree at most \(m+1\) for \(D(W)\),
even when \(W\) has many components and mixed fiber weights. The high term
\(H=a^2u^2-d^2\) is homogeneous of auxiliary degree 2. Projection of the
hypothesis to degree \(m+2\) yields \(D_m(H)=0\).

This is the crucial generalization. It is not justified merely by a lemma
about two homogeneous summands: `Main.lean` instead explicitly uses
`LeadingComponent.degreeLE_map` with the arbitrary `W` hypothesis.

### 4. Factorial closure with genuinely nonzero factors

For a locally nilpotent derivation \(\delta\) on a characteristic-zero
domain, the kernel is factorially closed among nonzero products.
For example the finite exponential satisfies
\(\exp(T\delta)(rs)=\exp(T\delta)(r)\exp(T\delta)(s)\);
degrees of nonzero polynomials over a domain add. If \(rs\ne0\) is fixed,
both exponential factors have degree zero, giving \(\delta r=\delta s=0\).
The formal helper proves the same fact by the highest nonzero iterates and
the nonvanishing binomial coefficient in the iterated Leibniz rule.
No UFD property of \(C\) is needed here.

At the actual determinant point \((a,d,b,c,u)=(1,0,0,1,1)\), both
\(au-d\) and \(au+d\) evaluate to 1, as do \(a,u\). Hence these four
elements are nonzero in \(C\). Applying factorial closure to
\[
 H=(au-d)(au+d)
\]
shows that \(D_m(au-d)=D_m(au+d)=0\). Characteristic zero and the domain
property allow cancellation of 2, yielding \(D_m(d)=D_m(au)=0\).
Factorial closure applied to \(au\), with \(a,u\ne0\), then gives
\[
 D_m(a)=D_m(d)=D_m(u)=0.
\]
The proof never applies factorial closure to a zero factor.

### 5. The coefficient is regular; it is not assumed to be a polynomial

Write \(\delta=D_m\) and define the actual quotient element
\[
 q=c\,\delta(b)-b\,\delta(c)\in C.
\]
Differentiating \(ac-bd=1\) gives \(a\delta(c)=d\delta(b)\). Therefore
\[
 a q=(ac-bd)\delta(b)=\delta(b),\qquad
 d q=(ac-bd)\delta(c)=\delta(c).
\]
If \(q=0\), all five generators are killed, contradicting \(\delta\ne0\).

The explicit, invertible chart constructions give
\[
 \begin{aligned}
 C[a^{-1}]&=k[a,a^{-1},d,u][b],
       &c&=(1+bd)/a,\\
 C[d^{-1}]&=k[a,d,d^{-1},u][c],
       &b&=(ac-1)/d.
 \end{aligned}
\]
These are coefficient charts on \(C\), distinct from the bundle's base
charts \(D(z+1)\) and \(D(z)\). In particular \(a,d,u\) are algebraically
independent. Put \(R=k[a,d,u]\) and \(K=\operatorname{Frac}R\).
All elements of \(R\) are invariant under \(\delta\). Localization at
nonzero elements of \(R\) therefore retains local nilpotence: iterates on
\(r/s\) are \(\delta^n(r)/s\). The localized ring is \(K[b]\).
A \(K\)-linear derivation there is \(P(b)\partial_b\). If
\(\deg_b P=r\ge1\), every successive nonconstant iterate on \(b\)
remains nonconstant, of degree \(1+n(r-1)\) at the \(n\)-th iterate;
its leading coefficient cannot vanish in characteristic zero.
Thus local nilpotence forces \(\delta(b)\in K\), and \(\delta(b)=aq\)
gives \(q\in K\).

Now \(q\in C\cap K\). In the \(a\)-chart it can have no positive \(b\)
coefficients after embedding in \(K[b]\), so \(q\in R[a^{-1}]\).
The independent \(d\)-chart similarly gives \(q\in R[d^{-1}]\).
Clear denominators:
\[
 q a^r=p,\qquad q d^s=t\qquad(p,t\in R).
\]
Then \(p d^s=t a^r\). Since the independent variables \(a,d\) are
relatively prime in the UFD \(R\), \(a^r\mid p\); cancellation in the
domain gives \(q\in R\).
This uses relatively prime **divisors**, not the false assertion that
\((a,d)\) is the unit ideal of \(R\).

The formal proof avoids even a chosen common fraction field:
`ChartLNDConstant` localizes only at each invariant chart denominator,
upgrades scalars to the localized coefficient ring, and applies
`UnivariateLND`. `VerticalLND.coefficient_chartA_eq_C` and
`coefficient_chartD_eq_C` establish constancy in both charts;
`DeterminantIntersection.exists_base_of_constant_charts` clears their
relatively prime power denominators. No polynomial representative for
\(q\) is a premise.

### 6. Negative fiber weight eliminates the coefficient

Since \(\delta\) preserves the actual fiber grading, both summands in
\(q=c\delta(b)-b\delta(c)\) have weight \(-2\). But the image of
\(k[a,d,u]\) has only nonnegative fiber weights, as its generators have
weights \(1,1,0\). Directness of the quotient grading, or equivalently
coefficient comparison in its Laurent weight coaction, forces \(q=0\).
This contradicts \(\delta\ne0\), completing the proof.

## Dependency and declaration map

All files in this table are under `FS` unless stated otherwise.

| Obligation | Inspected declarations |
|---|---|
| Literal quotient, variable order, weights | `ObstructionDefinitions.lean`: `C`, `cX`, `fiberWeight`, `auxiliaryWeight` |
| Domain, not a premise | `DeterminantDomain.lean`: `determinantRelation_irreducible`, `determinantIdeal_isPrime`, `determinantRing_isDomain`; adapters in `ObstructionDomains.lean` |
| Actual direct-sum quotient gradings | `HomogeneousQuotient.lean`: `decomposition`, `gradedAlgebra`; `DeterminantGradings.lean`: `idealC_homogeneous`, `auxiliaryGrading`, `fiberGrading` |
| Compatibility of projections | `DeterminantGradings.lean`: `auxiliary_fiber_proj_commute` |
| Finite attained global shift bound | `DerivationTopShift.lean`: `exists_maximal_generator_shift`, `exists_top_component_and_global_bound` |
| Arbitrary signs and local nilpotence | `LeadingComponent.lean`: `top_projection_iterate`, `locallyNilpotent_component`, `component_preserves_compatible_grading`; `LeadingLocallyNilpotent.lean`: `exists_nonzero_locallyNilpotent_component` |
| Arbitrary \(W\), rather than two homogeneous terms | `Main.lean`: `IndependentStableCore.lower_perturbation_rigidity`; `LeadingComponent.lean`: `DegreeLE`, `degreeLE_map` |
| Nonzero factors | `DeterminantNonzero.lean`: `au_sub_d_ne_zero`, `au_add_d_ne_zero`, `cX_a_ne_zero`, `cX_u_ne_zero` |
| Factorial closure and splitting | `FactorialClosure.lean`: `IsLocallyNilpotent`, `lnd_factorial_closure`, `lnd_fixed_of_difference_of_squares` |
| Actual coefficient charts and independence | `DeterminantCharts.lean`: `chartEquivA`, `chartEquivD`, `baseMap_injective`, `chartMapA_injective`, `chartMapD_injective` |
| Invariant-denominator localization and one-variable LND | `LocalizationLND.lean`; `ChartLNDConstant.lean`: `chart_coefficient_eq_C`; `UnivariateLND.lean`: `apply_X_eq_C_of_locallyNilpotent` |
| Polynomiality of \(q\) | `VerticalLND.lean`: `coefficient_equations`, `coefficient_chartA_eq_C`, `coefficient_chartD_eq_C`, `coefficient_mem_baseRange`; `DeterminantIntersection.lean`: `exists_base_of_constant_charts`; `ChartIntersection.lean` and `LocalizationIntersection.lean` denominator-clearing proofs |
| Actual negative-weight contradiction | `DeterminantWeights.lean`: `eq_zero_of_mem_baseRange_of_negative_weight`; `DeterminantGradedObstruction.lean`; `DeterminantFinalStep.lean`: `derivation_eq_zero_of_fixed_base_and_coefficient_mem` |
| Original specialization, not a second result | `Main.lean`: `october_rigidity`, using \(W=a^3b\) of auxiliary degree \(-1\) |

## Mechanical evidence and its limits

The source-bound archived record `SC/lean_verification_result.json` and
`SC/certificates/C_STABLE_CORE_VERIFY-1f2393b585c126fe.json` record Lean
4.31.0, commit `68218e876d2a38b1985b8590fff244a83c321783`, Lake
`5.0.0-src+68218e8`, Mathlib v4.31.0 workspace, compiler and audit exit 0,
and `proof_holes=[]`. The printed axiom list for this theorem is exactly
`propext`, `Classical.choice`, `Quot.sound`.

The current files were read-only hash-checked:
`Main.lean` is
`fea7d30d06349b4e15bc63852970443a958b8e4f99e38ac09a8897f7a27bb916`;
`statement_fidelity.md` is
`683a28a67564cb14f2809d0e8844ff0ce781a563c205df47eb2ec7e0d84df0ed`.
Both match the archived record, and both embedded texts in the archived
certificate match. The prose fidelity description of arbitrary \(W\)
matches the actual statement and its proof's `degreeLE_map` step.

The 81-check `exact_certificate.json` is not a proof over all LNDs or all
\(W\). This engineering proof assessment did not rerun that driver or a
full Main compilation; the coordinator and a separate agent have those
assignments. Compilation records are historical evidence, not independent
statement-fidelity or novelty approval.

## Component verdicts and remaining boundaries

| Component | Verdict | Explanation |
|---|---|---|
| Arbitrary, possibly mixed-fiber-weight \(W\) with auxiliary bound 1 | supported | The global shift bound removes all of \(D(W)\) at degree \(m+2\). |
| Leading component for \(m<0\) | supported | The exact iterate-projection identity has no sign restriction. |
| Factorial closure with nonzero factors | supported | Domain and characteristic zero are derived/explicit, and evaluations prove nonvanishing. |
| Coefficient regularity and negative-weight elimination | supported | Both charts and invariant denominators are essential and are proved, not assumed. |
| Literal kernel encoding of Theorem 2 | supported | The actual declaration has the full stated quantifiers. |
| Deduction of arbitrary geometric or coordinate families solely from Theorem 2 | partial | The theorem concerns weight-preserving LNDs on \(C\); action lifting, ideals, and embeddings are extra obligations. |
| Global novelty | unresolved | **Novelty: `not_asserted`.** Source-verified scope expansion relative to October is not a global novelty claim. |

No mathematical gap was found in the stated theorem. Its fiber-preservation
hypothesis is substantive: for \(W=0\), the nonzero LND
\(\delta(b)=a,\ \delta(c)=d,\ \delta(a)=\delta(d)=\delta(u)=0\)
fixes \(a^2u^2-d^2\), but changes fiber weight by 2 and is therefore excluded.
Thus neither rigidity of the ungraded ring nor exclusion of all LNDs is being
silently claimed.

External mathematical assumptions of the theorem are exactly its field,
characteristic-zero, local-nilpotence, fiber-preservation, degree-bound,
and annihilation hypotheses. The domain, independence, coefficient
regularity, and global shift bound are consequences, not added assumptions.
Formal evidence also trusts the Lean kernel and imported proofs.
No line-bundle theorem or literature citation is installed as an axiom in
this algebraic argument. Independent acceptance remains pending.
