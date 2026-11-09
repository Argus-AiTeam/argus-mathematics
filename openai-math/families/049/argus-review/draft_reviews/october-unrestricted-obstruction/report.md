# October unrestricted obstruction — engineering assessment

**Status:** the assigned filtration, coordinate-transfer, lifting, and invariant-exclusion arguments are supported. This is an engineering assessment, **not** independent review or acceptance of the campaign. No mathematical counterexample to these arguments was found. The composite claim's literal-presentation and stabilization fidelity belongs to the parent's companion assessment.

## 1. Inputs, version, attribution, and scope

The read-only draft is `9000049/research/stable_core_certificate/`, particularly `report.md` §§1–4, `statement_fidelity.md`, `Main.lean`, all 92 staged Lean sources and their matching-name `.olean` files, the compiler certificates, and runner records. Here and below `9000049/` abbreviates `campaigns/9000049/`.

The manuscript reference is **only** the October entry of `9100049/MANUSCRIPTS.json`: OpenAI, *A stable coordinate that is not a coordinate in four variables*, October 5, 2026, revision `4eaee87548250b2682affda7d05d947c05554bae`. Its six recorded TeX hashes all match the referenced files. The decisive manuscript arguments are `03-filtration.tex`, `04-bundle.tex`, and `05-rigidity.tex`. Their hashes are, respectively:

```
89d6dac1deb5cb3c118e38a7e7d2da96725f7a65676e4bc92408e6c31711cf89
332df2ac44774e20ab0c4b4d988c1274c7579b9ae0f4d1112199b4f50b217414
a27d1e5381626ace7c75640598312beb6a44b8f8f5bc183f5b7f2f114c444819
```

This unit reconstructs the manuscript's obstruction, not a new manuscript-error search. The manuscript attributes filtration methods to Kaliman–Makar-Limanov, the construction to its `Cancellation2026` reference, and the normalization method to Brion; these are source attributions, not a new prior-art determination. The staged formal sources are reused implementation proofs with local Lean-4.31 compatibility changes, not independent inventions of the old draft. The universal principalization and arbitrary-lower-perturbation strengthenings have separate review units; only their October specializations and interfaces are assessed here. The uniform surface-family theorem, September work, literal polynomial presentation, stabilization, and global novelty/provenance are not re-reviewed.

**Result kind:** known-result reconstruction relative to the supplied manuscript. **Novelty:** not asserted.

## 2. Exact statements and hypotheses

Let \(k\) be a characteristic-zero field, with the manuscript specialization \(k=\mathbb C\). Write
\[
\begin{aligned}
 B&=k[x,y,z,u]/(xy-z(z+1)),\\
 s&=y-x(x+u^2),\qquad I=(x-s^2+u^2,\ z-sx),\\
 C&=k[a,d,b,c,u]/(ac-bd-1),\\
 \iota(x,y,z,u)&=(ab,dc,db,u),\\
 v&=a^3b+a^2u^2-d^2.
\end{aligned}
\]
All these are literal quotient-ring definitions, not placeholders for properties of some other rings (`ObstructionDefinitions.lean:21–68`). Local nilpotence means \(\forall r\,\exists n\geq0:D^n(r)=0\), not one uniform bound. Coordinate systems are unrestricted algebra equivalences; the complex `IsCoordinate` predicate quantifies over all polynomial algebra automorphisms (`Definitions.lean:37–48`).

The assigned claims, each version 1 unless indicated otherwise, are:

* **C_OCT_GRADED.** On \(P=\mathbb C[p,s,u,F,J]\), set \(x=s^2-u^2+pF\), \(H_*=x^2F-(1+2sx)J-pJ^2\), \(A=P/(H_*-u)\). The quotient filtration from weights \((-1,0,0,1,1)\) is exhaustive and separated. Its associated graded algebra is the domain \(G=P/(H_*)=B[\tau,I/\tau]\), with \(\deg\tau=-1\); the five generator degrees are attained. For every integer \(\ell>0\), \(G_\ell=\tau^{-\ell}I^\ell\).
* **C_OCT_COORDINATE_LINK.** If \(A=k[p,q_1,q_2,q_3]\) is a polynomial coordinate system containing \(p\), there exist \(0\ne E\in\operatorname{LND}_k(B)\) and \(0\ne h\in I\) with \(E(h)=0\). The source-ring formal theorem actually works over any field under this coordinate-equivalence hypothesis; it does not posit nonnegative filtration indices or degree shifts.
* **C_OCT_PRINCIPAL.** The displayed \(\iota\) is injective, its punctured-line-bundle description retains both \(D(z+1)\) and \(D(z)\), and \(IC=(v)\), including over \(a=0\). The algebraic injection and principalization proofs require only a commutative coefficient ring.
* **C_OCT_ACTION_LIFT.** Every algebraic additive action on \(\operatorname{Spec}B\) has a fiber-scaling-equivariant lift to this determinant bundle. In characteristic zero every LND \(E\) has a weight-preserving LND lift \(D\) with \(D\iota=\iota E\). If \(E\ne0\) and \(I\cap\ker E\ne0\), then \(D\ne0\) and \(D(v)=0\). The lift does not assume \(E(u)=0\), triangularity, or a chosen frame.
* **C_OCT_RIGIDITY.** If \(D\in\operatorname{LND}_k(C)\) preserves every actual fiber-weight piece for weights \((1,1,-1,-1,0)\), and \(D(v)=0\), then \(D=0\). This is not a claim that \(C\) has no LNDs without those two restrictions.
* **C_OCT_EXCLUSION.** For every nonzero \(E\in\operatorname{LND}_k(B)\), every \(h\in I\) with \(E(h)=0\) is zero. In particular \(I\cap\ker E=\{0\}\) over \(\mathbb C\). No bounded ansatz is involved. The condition \(E\ne0\) is essential.
* **C_STABLE_CORE_VERIFY versions 1, 2, 3.** All three have the same natural statement: exclusion, the literal-coordinate-to-invariant implication, literal noncoordinateness, and one-variable stability. They are versions of one composite, not three mathematical results. The first two conjuncts and their obstruction dependencies are the substantive scope here; the final literal/stability fidelity is reserved to the parent.

## 3. Decisive argument checks

### 3.1 Integer filtration, separation, domain, and positive pieces

Exhaustiveness follows from finite-support polynomial representatives, as proved by `Filtration.exists_mem_piece` and `exists_mem_imagePiece`. For \(r\geq0\), a monomial of weight at most \(-r\) has \(p\)-exponent at least \(r\). Thus \(\mathcal F_{-r}A\subseteq p^rA\); negative pieces have not been truncated away. `FiltrationSeparation.lean:205–237` proves this and then uses the proper-ideal Krull-intersection theorem in a noetherian domain. Its hypotheses are real and necessary, not silently true for arbitrary quotients.

For the actual complex \(A\), the imported `sourcePresentation` supplies its polynomial-domain/noetherian structure. Its distinguished element maps to the literal polynomial, whose value at the origin is zero and at \((1,0,0,0)\) is one; hence it is a nonzero nonunit. This discharges separation for the manuscript statement. The coordinate-transfer proof takes an even narrower route: its hypothetical coordinate equivalence itself supplies the domain, noetherian, and nonunit facts (`CoordinateLeadingDerivation.lean:170–203`), so it does not assume the desired obstruction in proving separation.

The highest component of \(H\) is the nonzero \(H_*\) of integer weight 1. In a polynomial domain the leading component of \(qH\) is \(\operatorname{in}(q)H_*\), including when the weights are negative. `WeightedInitialKernel` proves the lower-representative criterion in both directions. `GradedPresentationKernel.kernel_eq_top_principal` and `AssociatedGradedPresentation.associatedGradedEquiv` identify the **actual** Rees special fiber with \(P/(H_*)\); a merely named degeneration is not substituted for the associated graded.

The explicit Laurent equivalence is
\[
G[\tau^{-1}]\simeq B[\tau,\tau^{-1}],\quad
(p,s,u,F,J)\mapsto
(\tau,s_B,u,f_0/\tau,g_0/\tau).
\]
`LaurentPresentation` proves inverse algebra maps. Regularity of \(\tau\) is established before using a domain property of \(G\): \(p\nmid H_*\), witnessed by evaluation at \((0,0,0,0,1)\), and relative primeness in the polynomial UFD gives localization injectivity (`GradedRelationSanity.lean:70–99`). Since the actual \(B\) is a domain by its primitive-linear defining relation, its Laurent ring is a domain; injectivity then proves the domain assertion for \(G\). There is no circular assumption that the associated graded is already a domain. Nonzero classes of all five generators are separately witnessed by points on \(H_*=0\), giving the asserted exact degrees.

The image is exactly the modification, not only contained in it (`ModificationEmbedding.image_eq_modification`). `ModificationPieces.modification_eq_extendedRees` characterizes all Laurent coefficients by
\[
[\tau^n]g\in I^{(-n)^+}.
\]
This proves both inclusions in \(G_\ell=\tau^{-\ell}I^\ell\). It also proves nonzero numerator extraction, and \(I^\ell\subseteq I\) only when \(\ell>0\). The sign convention is explicit: filtration degree \(\ell\) corresponds to Laurent exponent \(-\ell\).

**Finding:** supported. The source closure supplies proof components rather than one declaration literally named `C_OCT_GRADED`; the unconditional complex separation and domain statements are assembled as above.

### 3.2 Coordinate transfer, arbitrary-sign leading derivation, and nonzero descent

The degree-at-most-zero part of the filtration is a subalgebra and is proper because the symbol of \(F\) is nonzero in degree 1. Hence some coordinate \(q_1\) lies outside it. A different coordinate can be differentiated while both \(p\) and \(q_1\) are fixed (`CoordinateDerivation.exists_lnd_invariant_outside`). Its derivation is nonzero because its value on the differentiated coordinate is 1, and its local nilpotence is proved for every polynomial.

The maximum
\[
m=\max_{D(t)\ne0}\{\deg D(t)-\operatorname{wt}(t)\}
\]
exists over the five generators and is attained. The product rule and bounded representatives extend it to **all** filtration pieces (`FiltrationDerivationShift.exists_attained_derivation_imagePiece_shift`). An attained derivative is not in the preceding layer, so the resulting graded derivation is nonzero; nonzero is not inferred just from the original derivation being nonzero.

`FilteredReesDerivation` constructs the derivation as the coefficientwise derivation multiplied by a Laurent monomial, descends it through the parameter ideal, and proves its iterate formula. On homogeneous symbols it is
\[
D_0^n([r]_d)=[D^n(r)]_{d+nm}.
\]
This proves local nilpotence for arbitrary integers \(d,m\), not just \(m\geq0\). Finite homogeneous decompositions handle arbitrary elements. The positive initial form of \(q_1\) is nonzero by separation, and both it and \(\tau\) remain invariant.

Only the invariant \(\tau\) is inverted. `LocalizationLND` differentiates numerators over unchanged invariant denominators, with an explicit iterate formula; it does not claim that arbitrary localization preserves local nilpotence. Concrete injection \(G\hookrightarrow B[\tau,\tau^{-1}]\) preserves nonzero derivations and the nonzero invariant.

Homogeneity gives \(D_0(b)=\tau^{-m}E(b)\) for \(b\in B\). `LaurentDescent.descend_ne_zero` checks the sometimes-missed base restriction: if \(E=0\), then the Laurent derivation kills all coefficients and \(\tau\), hence the entire Laurent algebra, contradicting nonzero. Its iterate formula proves local nilpotence of \(E\) for any sign of \(m\). Finally \(\eta=\tau^{-\ell}h\ne0\) has \(h\in I^\ell\setminus\{0\}\); invariance gives \(E(h)=0\).

`CoordinateToQuadric.source_coordinate_produces_quadric_lnd` assembles these constructions without an extra separation, domain, homogeneity, or lift-existence premise. The literal-coordinate wrapper additionally uses the parent's source-presentation interface.

**Finding:** supported.

### 3.3 Both base charts, injectivity, and principalization over \(a=0\)

For \(U_0=D(z+1)\), the inverse formulas are
\[
b=x/a,\quad c=(z+1)/a,\quad d=ay/(z+1).
\]
For \(U_1=D(z)\), they are
\[
b=z/d,\quad c=y/d,\quad a=xd/z.
\]
The two opens cover because \((z+1)-z=1\). Their transition is \(d=a\,y/(z+1)\), with inverse transition \(x/z\). Thus they describe the complement of the zero section in a line bundle, not just a generic torus fiber.

`BundleCharts` formally constructs sections \(a=1\) and \(d=1\), proves that each splits the localized base map, and proves that vanishing on both charts forces zero using relatively prime powers of \(z,z+1\). It consequently proves \(\iota\) injective over any commutative coefficient ring; no domain or chart-injectivity hypothesis is supplied to the final base map.

`ObstructionPrincipalization.map_I_eq_span_v` instantiates `Bundle.principalization` on the exact \(f_0,g_0,v\). This is a global polynomial Bezout proof, stronger than a radical or point-set equality. The independent universal-ring strengthening is assessed elsewhere.

The manuscript's missing-chart check is also correct on its own: at a prime containing \(a\), \(bd=-1\), \(x=0\), \(z=-1\), so \(g_0=-1\) and \(v=-d^2\) are units in the local ring. This locus is retained by \(U_1\), not discarded when \(a\) was inverted. Conversely \(z=0\) is retained by \(U_0\). The two base charts here must not be confused with the later \(a,d\)-localizations used to prove coefficient polynomiality.

**Finding:** supported, including the boundary.

### 3.4 Every additive action: homotopy units, normalization, cocycle, and weights

The prose homotopy argument has the needed hypotheses. The two base chart rings are
\[
B[(z+1)^{-1}]=k[x,t,u,(xt+1)^{-1}],\quad
B[z^{-1}]=k[x,t,u,(xt-1)^{-1}],
\]
with a separate \(t\) on each chart. Both and their polynomial extensions are noetherian UFDs, so invertible rank-one modules are free. The draft's gcd/locally-principal-ideal explanation of this fact is valid: after dividing out a gcd, a proper invertible ideal would yield a prime common divisor at a containing maximal ideal. Denominators outside that maximal ideal cannot contain that prime. This contradicts gcd one.

Transitions therefore lie in the units of the overlap ring with an affine parameter adjoined. That overlap is a domain, so its polynomial units are constant in the parameter. Restriction at zero retains the same transition. This proves the claimed homotopy property for line bundles on this \(Y\).

For the general prose lifting lemma, the homotopy hypothesis gives \(\pi^*\mathcal L\simeq\alpha^*\mathcal L\). Its zero-parameter discrepancy is a global unit and can be removed. Comparing the iterated lift with the lift at \(S+T\) then yields an automorphism of the same invertible sheaf over \(Y\times\mathbb A^2\), hence a unit in \(B[S,T]\). It is constant in both parameters and equals 1 at \((0,0)\). This proves the cocycle/group law; normalization alone without this units argument would not have sufficed. No homotopy theorem for two affine parameters is being silently assumed.

The **formal proof takes an alternative, fully algebraic route** for the actual determinant bundle:

1. `DeterminantPrimeA` identifies \(C/(a)\) with \(k[d,b,c,u]/(bd+1)\) and proves it is a domain, so \(a\) is prime. `DeterminantCharts.chartEquivA` identifies \(C[a^{-1}]\) with \(k[a,a^{-1},d,u][b]\). The proved Nagata criterion supplies the actual UFD structure of \(C\), hence of \(C[T]\). Neither UFD property is an external assumption on the final lift.
2. `QuadricFactorization.exists_frame` factors every triple \(xy=z(z+1)\) over a GCD domain into \(ab=x,dc=y,db=z,ac-bd=1\). It uses gcd-relative primeness, **not** a false Bezout-domain assumption. It separately covers \(x=0,z=0\) and \(x=0,z=-1\).
3. Pulling any base coaction to \(C[T]\) supplies a frame. `NormalizedDeterminantLift` rescales it by a constant comparison unit so its parameter-zero specialization is the original frame. The independent \(u\)-coordinate is lifted by the original base action; it is not assumed invariant.
4. `FrameLiftUniqueness` proves explicitly that two frames over the same base differ by a unit. Over a reduced coefficient ring, polynomial units are constant. `FrameCoassociativity` and `FrameLiftCoassoc` compare the iterated and summed-parameter frames as bivariate polynomial identities. They prove the full coaction law, not just equality at \(k\)-points.
5. A second normalized-frame comparison, over the Laurent coefficient ring for fiber scaling, proves all five coefficient weights (`DeterminantLiftWeights`). `DeterminantActionWeights` promotes generator laws to every actual homogeneous piece. Fiber-linearity/weight compatibility is a proved output, not a premise.
6. The characteristic-zero exponential and coefficient-one differentiation are mutually inverse (`LNDAction`). `CoactionLND.iterate_derivation` proves \(D^n(r)=n![T^n]\alpha(r)\), so a polynomial coaction differentiates to an LND. Naturality proves \(D\iota=\iota E\).

`LiftObstruction.exists_weight_preserving_lnd_lift` therefore quantifies over **every** LND on the actual \(B\). Injectivity of \(\iota\) proves its lift nonzero when \(E\ne0\). For \(0\ne h\in I\cap\ker E\), write \(\iota(h)=vq\). The product is nonzero, so both factors are nonzero. `lnd_factorial_closure` proves \(D(v)=0\), with no division by \(v\) and no assumed polynomial factor \(q\).

**Finding:** supported. The abstract Picard-homotopy lemma and the generic geometric line-bundle lemma are checked prose, not Lean declarations. The algebraic lift needed for the exact \(C\) is nevertheless unconditional in the formal proof.

### 3.5 October rigidity specialization and unrestricted exclusion

The two quotient gradings are actually constructed. Their projections commute because coefficientwise weighted projections commute upstairs and descend through the homogeneous determinant ideal (`DeterminantGradings.lean:163–195`).

For October, \(v=v_{\rm low}+v_{\rm high}\) with auxiliary degrees \(-1\) and \(2\). Thus the arbitrary-perturbation theorem's hypothesis \(\deg_{\rm aux}W\leq1\) holds for \(W=a^3b\). `Main.lean:110–118` uses precisely that specialization. Taking a nonzero highest-shift auxiliary component keeps local nilpotence even for negative shift and keeps fiber weights; no auxiliary nonnegativity or global boundedness is assumed without proof.

Its fixed difference of squares is \((au-d)(au+d)\). The factors, as well as \(a,u\), are genuinely nonzero, witnessed by the determinant-one point \((a,d,b,c,u)=(1,0,0,1,1)\). Factorial closure first fixes the two factors, then fixes \(a,u\); characteristic zero allows the sum/difference step fixing \(d\).

With \(a,d,u\) fixed, \(q=cD(b)-bD(c)\) is an element of \(C\), and determinant differentiation gives \(D(b)=aq,\ D(c)=dq\). If \(q=0\), the derivation is zero on all five generators.

The polynomiality assertion is not assumed. The two actual coefficient charts are
\[
C[a^{-1}]=k[a,a^{-1},d,u][b],\quad
C[d^{-1}]=k[a,d,d^{-1},u][c].
\]
All denominators inverted in the LND argument are fixed. The prose fraction-field argument is valid; the formal proof is more direct, upgrading scalar linearity on each invariant chart and applying `UnivariateLND` over its characteristic-zero coefficient **domain**. A positive-degree value on the chart variable would keep every iterate positive-degree, contradicting nilpotence. Hence \(q\) is constant in each chart variable.

`DeterminantIntersection.exists_base_of_constant_charts` clears both power denominators and uses relative primeness of the independent \(a,d\) in \(k[a,d,u]\), proving \(q\in k[a,d,u]\). Relative primeness is common-divisor primeness, not the incorrect assertion \((a,d)=(1)\) in that polynomial ring. Both charts and injectivity are indispensable here. The coefficient has fiber weight \(-2\), whereas the base subring has only nonnegative fiber weights. Thus \(q=0\), contradicting the nonzero leading component.

Finally `Main.unrestricted_invariant_exclusion` obtains the actual nonzero lift from `lift_invariant` and applies October rigidity. It imposes no extra restriction on the base derivation \(E\).

**Finding:** the October specialization and exclusion are supported. The separate arbitrary-\(W\) strengthening is not scored here.

## 4. Formal fidelity and dependency map

All unqualified file names in this table are under the old staged `formal_sources/OAI/AlgebraicGeometry/StableCoordinate/`. Full import edges, source/object hashes, declaration headers, and variable-context locations for **all 92 files** are in `dependency_audit.json`; `declaration_dependency_map.json` maps the claims and groups every staged module.

| Claim | Decisive declarations / dependency path | Formal fidelity boundary |
|---|---|---|
| C_OCT_GRADED | `FiltrationSeparation` → `WeightedInitialKernel`, `PrincipalInitialRelation` → `AssociatedGradedPresentation.associatedGradedEquiv`; `GradedRelationSanity.G_away_injective`; `LaurentPresentation.equiv`; `ModificationEmbedding.image_eq_modification`; `ModificationPieces.positive_piece` | Genuine integer filtration and quotient rings. Complex separation/domain are assembled from proved components; no one wrapper theorem states the entire proposition. |
| C_OCT_COORDINATE_LINK | `CoordinateDerivation` → `CoordinateLeadingDerivation` → `ReesToDegeneration.coordinate_produces_degeneration_lnd` → `SourceInvariant.exists_quadric_lnd_invariant` → `CoordinateToQuadric.source_coordinate_produces_quadric_lnd` | Only coordinate equivalence is the final source-theorem hypothesis. Literal transport is the parent's interface. |
| C_OCT_PRINCIPAL | `BundleCharts.baseMap_injective`; `Bundle.principalization`; `Obstruction.map_I_eq_span_v` | Actual ideals, not radicals. Bundle gluing is geometric prose; both algebraic chart sections are formal. |
| C_OCT_ACTION_LIFT | `DeterminantUFD` → `QuadricFactorization` → `NormalizedDeterminantLift.liftHom`; `FrameLiftCoassoc.actionOfNormalizedExtension`; `DeterminantLiftWeights` → `LiftObstruction.exists_weight_preserving_lnd_lift`, `lift_invariant` | Algebraic coaction/LND lift is complete. Abstract Picard homotopy and arbitrary-\(X\) line-bundle language are not formalized. |
| C_OCT_RIGIDITY | `Main.october_rigidity` → `Main.lower_perturbation_rigidity`; `LeadingLocallyNilpotent`; `VerticalLND.coefficient_mem_baseRange`; `DeterminantRing.derivation_eq_zero_of_fixed_base_and_coefficient_mem` | October specialization has exactly Field, CharZero, LND, actual fiber-piece preservation, and \(D(v)=0\). No rational-coefficient regularity premise remains. |
| C_OCT_EXCLUSION | `IndependentStableCore.unrestricted_invariant_exclusion` → `lift_invariant` + `october_rigidity` | Quantifies over all nonzero LNDs and all ideal elements; also proved over every characteristic-zero field. |
| C_STABLE_CORE_VERIFY v1 | Natural statement only; empty `formal_statement` | Later v3 supports the same obstruction content; v1 has no independently certified formal statement. |
| C_STABLE_CORE_VERIFY v2 | Recorded wrapper with `apply lower_perturbation_rigidity ...` | **Not a successful formal proof.** Certificate is inconclusive, compiler exit 1, with error-induced `sorryAx`. The natural statement is not thereby refuted. |
| C_STABLE_CORE_VERIFY v3 | Current `Main.stable_core_verify`, including the two obstruction clauses and imported literal/stability clauses | Fresh wrapper compilation succeeds. Assigned obstruction fidelity is checked here; presentation/stabilization assessment remains with the parent. |

Generic conditional interfaces have not been confused with unconditional conclusions. For example, separated filtrations, invariant denominators, reduced coefficient rings, chart equivalences, commuting projections, and coefficient-subring membership are hypotheses of appropriate helper lemmas. Their concrete callers supply them by proved constructions. The final exclusion theorem has no assumption asserting action-lift existence, principalization, coefficient polynomiality, or the desired rigidity theorem.

The staged closure does not import `Principal`, `NonCoordinate`, or a final theorem called `Rigidity`. The module `DeterminantRigidity` is an elementary generator/coefficient calculation, not an assumed version of the obstruction. The wrapper does reuse substantial implementation proofs; it is not an independent reinvention of all 92 modules.

## 5. Compiler evidence, exact versions, and fresh bounded replay

### Historical records: what they actually establish

* The upstream toolchain string is `leanprover/lean4:v4.34.1`; the preserved local port and actual compiler are **Lean 4.31.0**, not 4.34.1.
* The latest `formal_build_result.json` reports 92 modules, no failures or blocked modules, but **all 92 statuses are `unchanged`**, elapsed 0.007 seconds. This is an incremental-cache record, not a fresh 92-module rebuild.
* Earlier port records contain real failures: port3 reports 91 modules, 19 failed/33 blocked; port4 reports 92, 9 failed/15 blocked; port5 fails `HomogeneousQuotientWeight`; port6 fails `DeterminantWeights` on the unavailable `AddMonoidAlgebra.single_sub`; the first official-certification attempt fails `DeterminantLiftWeights`. Current sources include proved compatibility adapters, `Finsupp.single_sub`, and corrected Laurent coefficient identities. Submitted/running job receipts alone are not successes.
* `C_STABLE_CORE_VERIFY-6e32222f1205e47e.json` is the **v2 inconclusive certificate**, subject hash `75aadfe112ce8bcb364f81d5f7b709e887cc0d7047c6cbd31b0ad2578e6b58c7`, source SHA-256 `5007971259d2571fb5c6fae4eac52fdab5399103c3d41b09c966a25717168119`. It records exit 1, `status=type_error`, and no completed axiom audit. Although its lexical `proof_holes=[]`, elaboration errors introduce `sorryAx` into exclusion, noncoordinate, and composite output. Those lines are not valid proof certificates.
* V3 changes only the October-specialization tactic from `apply ...` to `refine ... ?_`, so the degree-bound and annihilation goals are handled in their intended order. It does not weaken the theorem or add a premise. The exact diff is preserved in `historical_compiler_audit.json`.
* `C_STABLE_CORE_VERIFY-1f2393b585c126fe.json` binds **v3**, subject hash `fe4f0d30f541cfe1ab82015c2f8ea5263352ff575bf5b924e18af1f9c50a5717`, source SHA-256 `fea7d30d06349b4e15bc63852970443a958b8e4f99e38ac09a8897f7a27bb916`. It records exit 0, `proof_holes=[]`, axiom-audit exit 0, and only foundational axioms. `formal_certification3_wait.json` records success. The verifier explicitly says its statement-fidelity document is **not independently verified** (`verified_by=null`).
* `formal_gate_result.json` records a passed eight-declaration axiom gate and exit-zero structural checks. Those ledger/graph gates are not mathematical or independent fidelity review. The old 81-check algebra certificate is not an enumeration proof of unrestricted exclusion.

The initial v1 natural statement is unchanged in v2/v3 and has empty formal text. The versions are not counted as separate results, and v3 success is not retroactively called a successful compilation of v2.

### Fresh run performed for this assessment

`replay_formal.py` was read **before** execution decisions. It can write old `.olean` outputs, build/gate records and old campaign ledgers; it was **not run**.

Instead, `inspect_and_replay.py` read the unchanged current `Main.lean` and sent it to:

```
$WORKSPACE/.elan/toolchains/leanprover--lean4---v4.31.0/bin/lean --stdin
```

The working directory was this review directory. `ELAN_TOOLCHAIN=leanprover/lean4:v4.31.0`; `LEAN_PATH` contained only the preserved old `formal_build` and the installed host Mathlib/package build paths, all listed exactly in `main_replay.json`. No `lake` build, old driver, Argus certification/ledger operation, or git operation was invoked. No new `.lean`, `.olean`, or `.ilean` artifact was requested or produced.

**Result:** exit **0**, elapsed **7.223 seconds**, empty stderr, within a 104-second subprocess bound. Exact compiler version:

```
Lean (version 4.31.0, x86_64-unknown-linux-gnu, commit 68218e876d2a38b1985b8590fff244a83c321783, Release)
```

The exact stdout, command, input digest, environment paths and exit status are persisted in `main_replay.json`. The two algebraic identities print only `[propext, Quot.sound]`; the other six printed declarations, including exclusion and the composite, print only `[propext, Classical.choice, Quot.sound]`.

The source audit covers **92/92 reachable staged modules, 13,162 source lines**, with no missing OAI dependency and no unreferenced staged module. Every matching `.olean` exists and postdates its source. A comment/string-masked scan of every staged source plus `Main.lean` found no `sorry`, `admit`, `axiom`, `unsafe`, `partial`, `implemented_by`, `extern`, `native_decide`, or `run_tac` code token, nor a debug/kernel option. Occurrences of “partial”/“admit” in mathematical prose comments are not holes.

## 6. Supported scope, external assumptions, and concrete limitations

1. **Mathematical finding.** No unresolved mathematical gap was found in the assigned chain from the integer filtration and hypothetical source coordinate through the universal lift and October rigidity to unrestricted invariant exclusion. No bounded computation or selected family is substituted for the universal LND quantifiers.
2. **Foundations versus geometry.** The printed `propext`, `Classical.choice`, and `Quot.sound` are Lean foundational axioms, not assumptions that a line bundle trivializes or an action lifts. No extra mathematical axiom appears in the printed roots. The algebraic exclusion requires the stated characteristic-zero field hypothesis; the determinant UFD/domain and chart properties are proved. The standard affine coordinate-ring/action dictionary, bundle gluing interpretation, and general Picard-homotopy prose are not literally scheme/line-bundle objects in this Lean development; their relevant arguments were checked above. This is a representation boundary, not an undisclosed assumption in `lift_invariant`.
3. **Formal trust boundary.** The fresh run re-elaborates the wrapper against precompiled imports. It does **not** independently kernel-recheck or rebuild every imported `.olean` from its staged source. Hashes and timestamps pin the preserved inputs but do not by themselves prove source/object correspondence. The historical source-bound wrapper certificate plus current source reading and imported-axiom output are the available evidence; a full dependency rebuild is deliberately not claimed.
4. **Composite and other-unit boundaries.** All three composite versions are accounted for. V2's formal artifact is invalid as a completed proof; its mathematical claim is not falsified. V3 establishes the exact four-conjunct formal statement, but this report does not independently assess the parent-owned literal-presentation and stabilization arguments or turn that compiled conjunction into a review of every manuscript assertion. The universal-ring and arbitrary-\(W\) strengthenings, all-fiber consequences, September construction, and strongest surface-family corollary are not new findings here.
5. **No novelty or acceptance.** No independent significance/novelty determination is made, no original manuscript is refuted, and no Engineer self-acceptance is recorded. The native Host-invoked independent Reviewer remains required.

### Evidence written in this unit

* `report.md` — this substantive engineering assessment.
* `verdict.json` — claim/version-specific findings and boundaries.
* `declaration_dependency_map.json` — declaration-level mapping and complete 92-module grouping for the parent index.
* `dependency_audit.json` — complete source/object hashes, import closure, declaration/variable locations and hole scan.
* `historical_compiler_audit.json` — read-only selected claim/version records, exact v2→v3 diff, preserved compiler/runner records and both certificates.
* `main_replay.json` — exact fresh bounded stdin compilation receipt.
* `inspect_and_replay.py` — the read-only-input inspection and one-run replay harness.
