# Bounded assessment: characteristic-p line recovery

## Assessment and bindings

**Mathematical verdict: supported for the stated local theorem.** The function-field specialization is also supported by its explicit algebraic argument, but that specialization is not a Lean theorem in this draft. No concrete mathematical gap in the bounded line-recovery argument was identified. This is an Engineer-assisting assessment, not native independent review, acceptance, or certification of the whole reconstruction theorem. Independent review remains `pending_native_host_reviewer`.

The current contract is `OBJECTIVE.md`, with this unit and its dependency identified in `research/DRAFT_REVIEW_INDEX.json`. Historical instructions are not inherited. All historical inputs were read only; no Lean compilation, verifier execution, ledger modification, or Git operation was performed.

Source-anchor conventions below:

- **D** = `families/009/first-pass/char-p-line-recovery/`.
- **M** = `openai-math/preprints/Reconstruction-from-Milnor-K-theory-modulo-the-characteristic-October-5-2026/build/build/sections/`.
- `Main.lean`, historical `report.md`, `statement-fidelity.md`, and `verify.py` refer to D; numbered `.tex` references refer to M.

Exact bindings supplied and verified by the parent, reused here rather than re-hashed:

| Item | Binding |
| --- | --- |
| Historical claim assessed | `V_CHARP_LINE_RECOVERY@2`, content hash `2dec3ca27a700e683844670f57f98b34c7f1b7d0483439ce103208e86f7706e1` |
| Formal source | `Main.lean`, SHA-256 `a19edb08473fb202bebc6f10c102936cc95485b37a3a110a596ecf41feb4341f` |
| Statement reading | `statement-fidelity.md`, SHA-256 `5c28798bc4cb29adffe70428b09254ff77d44faae4afeb5f4da6c62742d679a2`; the underscore-spelled copy has the same hash and is not another result |
| Historical certificate | `research/char-p-line-recovery/certificates/V_CHARP_LINE_RECOVERY-9e689e2d9b3aa174.json`, SHA-256 `4ac05dc3dc3ecd114f35aa8b71d445d693f8d1ac823d9fb6e0ccd0195923f927` |
| Applicable historical support | `judgement-V_CHARP_LINE_RECOVERY-b3db4b875762`, by `reviewer:copilot`, supports exactly that claim hash and certificate |
| Manuscript | Revision `4eaee87548250b2682affda7d05d947c05554bae`; `04-lines.tex` SHA-256 `6b821a89c702010b7f7a1d089a29c1330ed341386419c1c3711b24c5f1a0d04c` |
| Reused intersection theorem | `V_CHARP_INTERSECTION@3`, content hash `bc454725f6e3913984e01e96fb83ae34f15ce44a47d81fa073dac264680d9bcb`; unchanged imported source SHA-256 `96ef99bfd773341718ab4e220167f05778a27ab97db1ebb52d6a095faff078b1` |
| Intersection support | `research/char-p-intersection/certificates/V_CHARP_INTERSECTION-8ee0aa52ccd7bea2.json`, SHA-256 `4a8a534637ab71d6167ee5771b450b5a2fe5827ed34cc0d543be32bda00a7417`; supporting judgement `judgement-V_CHARP_INTERSECTION-d2a910e000f2`, by `reviewer:copilot` |

`V_CHARP_LINE_RECOVERY@1` (hash `b62c040122f29a0777bf8bfd031d1bb823d94210dcdbcc00c9943db3b1dbe0ff`) is the earlier prose-only version. It is not interchangeable with version 2. Stale graph labels or `pending_host_reviewer` progress text do not cancel the applicable source-bound historical support. That historical support does not constitute acceptance of this current assessment.

The intersection proof is assessed separately. Its imported source was not re-read here. Only its already-supported interface is used: a common exponent with nonzero affine coefficients, and uniqueness from **either single, unqualified affine-power inclusion**.

## Exact theorem and actual objects

Let \(p\) be prime and \(K,L\) be arbitrary fields of characteristic \(p\). Put \(H=K^p\), \(C=L^p\). The root assumes

\[
[K:H]<\infty,\quad [L:C]<\infty,\qquad
[K:H]\geq p^2,\quad [L:C]\geq p^2.
\]

There are no finitely-generated, algebraically-closed-base, separability, line-preservation, subfield-preservation, or symbol-detection hypotheses in this root. With the ambient `Field`, `Fact p.Prime`, and `CharP` instances, its literal source statement is (`Main.lean:1285–1294`):

```lean
theorem prop_lines_source
    [FiniteDimensional (PthPowers K p) K] [FiniteDimensional (PthPowers L p) L]
    (hdK : p ^ 2 ≤ Module.finrank (PthPowers K p) K)
    (hdL : p ^ 2 ≤ Module.finrank (PthPowers L p) L)
    (e : V K p ≃ₗ[ZMod p] V L p) (he : Compatible e) :
    ∃! n : (ZMod p)ˣ, SendsLinesOnto K p (scale K p e n) := by
```

The fully qualified root is `CharPLineRecovery.prop_lines_source`. Its objects are not abstract substitutes:

- `powers F p` is the range of multiplication by \(p\) on `Additive Fˣ`; `V F p` is its additive quotient, with the constructed `ZMod p` module structure (`Main.lean:14–23`). Thus it is literally \(F^\times/(F^\times)^p\). `point_mul`, `point_pow`, `point_surjective`, and `point_eq_iff` prove its multiplicative interpretation and equality criterion (`25–49`).
- `PthPowers F p` is `(frobenius F p).fieldRange` (`436`). `point_eq_zero_iff` and `point_eq_iff_ratio_mem` prove \([f]=0\iff f\in F^p\) and \([f]=[g]\iff f/g\in F^p\) for units (`438–485`). The latter ratio is automatically nonzero. Consequently these classes are precisely the one-dimensional \(F^p\)-subspaces of \(F\); the group zero is the projective point \([1]\), not a zero vector in that projective space.
- `steinbergSet` consists of the actual tensors \([f]\otimes[1-f]\), with \(f\ne0,1\); `relations` is their `ZMod p` span; `W` is the tensor square modulo this span (`85–99`). `Compatible e` is **equality** of the image relation subspace and the target relation subspace under the tensor square of `e` (`130–133`), not just preservation of selected zero symbols.
- These are the specified quotient and compatibility objects recorded in historical `report.md:5–12` and `statement-fidelity.md:18–32`, not stronger replacements. Their projective interpretation and the descent through the Steinberg relations are exactly those used in `02-symbols.tex:4–15,110–117`. Naming `W` as \(K_2^{\mathrm M}(F)/p\) uses the standard tensor presentation; Main does not build an isomorphism to a separately defined Milnor-K object. The theorem on the actual specified quotient does not depend on importing that nomenclatural identification.
- `ZeroInc` is membership in the \(F^p\)-span of \(1,s\), formulated through unit representatives. `zeroInc_iff` proves independence of their choice (`952–973`). `line a b` is its multiplicative translate, encoded additively by differences (`983–984`). Crucially,
  \[
  [u]\in\operatorname{line}([s],[t])
  \iff \exists A,B\in F^p,\quad u=As+Bt
  \]
  is proved for arbitrary fixed unit representatives (`line_iff_coefficients`, `986–1001`; `line_iff_span`, `1215–1223`). This establishes actual projective lines, not merely a supplied incidence relation.
- `scale e n` is the linear equivalence \(v\mapsto n\,e(v)\) (`1009–1015`). `LineOnto` means exact image equality with the line through the images of the endpoints (`1006–1007`). `SendsLinesOnto` instead permits **some** distinct target endpoints for each distinct source pair (`1266–1268`). The root quantifies uniquely over all units satisfying this latter property.

The endpoint distinction is resolved, not assumed away. `span_pair_finrank` proves the actual representative span has dimension two for distinct quotient points (`1225–1242`); `line_eq_of_two_mem` proves uniqueness of the line through two distinct points by inclusion and equality of those spans (`1244–1264`). Therefore `lineOnto_iff_sendsLinesOnto` (`1270–1283`) gives the full source conclusion and uniqueness quantifier. There is no requirement that a competing scalar already come with endpoint normalization.

## Decisive argument, compared with the manuscript

### 1. Zero-symbol detection is derived from the Steinberg quotient

The manuscript proves only the implication needed here:
\[
s\notin F^p,\quad \{s,t\}=0\quad\Longrightarrow\quad t\in F^p(s)
\]
(`02-symbols.tex:93–118`). It does not invoke injectivity of the logarithmic differential symbol or the Bloch–Gabber–Kato theorem.

If \(t\notin F^p(s)\), the pair is \(p\)-independent. Euler derivations \(D,E\), linear over \(F^p\), can be chosen with \(D(s)=s,D(t)=0,E(s)=0,E(t)=t\). The logarithmic determinant
\[
\beta([f],[g])=\frac{Df}{f}\frac{Eg}{g}-\frac{Ef}{f}\frac{Dg}{g}
\]
is well defined and \(\mathbf F_p\)-bilinear on the **actual** multiplicative quotient. Logarithmic derivatives kill \(p\)th powers. Since \(D(1-f)=-Df\) and \(E(1-f)=-Ef\), it kills every actual Steinberg generator, hence their span. Its induced map on `W` takes \(\{s,t\}\) to \(1\), contradicting vanishing.

Main implements exactly this descent in `logHom`, `logLinear`, `beta_kills_relations`, `differentialSymbol`, and `symbol_nonzero_of_euler` (`53–128`). The necessary derivations are constructed, not hypotheses: `InseparableDerivations.minpoly_pth` (`166–180`) identifies the strict-adjunction minimal polynomial \(X^p-a\); `extend_powerBasis` (`205–231`) descends a polynomial derivation because it kills that polynomial; `extend_finite` (`240–297`) inducts on finite extension degree; and `euler_pair` (`299–360`) obtains the required four values and extends to \(F\). This differs from the manuscript's simultaneous monomial-basis construction (`02-symbols.tex:46–84`), but proves the same needed existence without assuming a separable extension or a pre-existing global derivation.

`CharPLineRecovery.zero_symbol` (`460–476`) specializes those constructions to the literal \(F^p\), whose exponent-one condition is proved by `powers_exist` (`487–489`). It needs finite degree but not the lower bound \(p^2\). `compatible_symbol_zero_iff` (`135–154`) gives both directions of zero-symbol preservation from the exact relation-space equality, using injectivity of the tensor equivalence.

### 2. Affine witness and the complete dependency interface

For \(c,d\in(F^p)^\times\), the actual Steinberg generator for \(q=-dt/c\) proves \(\{t,c+dt\}=0\), whenever both representatives are nonzero. The omitted factors belong to \((F^p)^\times\), and \(q\ne1\) follows from \(c+dt\ne0\). This is `affine_symbol` (`596–634`), matching `02-symbols.tex:123–135`.

An edge means \(C(X)\ne C(Y)\) for image representatives of nonzero source quotient points. Since each simple nonconstant adjunction has degree \(p\), this gives \([C(X,Y):C]=p^2\). Main proves `simple_degree`, `adjoin_eq_iff_mem`, `independent_degree`, and `intersection_constants` (`498–574`). No subfield-preservation property of `e` is assumed.

For arbitrary \(a,b\in H^\times\), set
\[
u=x+a,\qquad v=y+b,\qquad z=bx-ay=bu-av.
\]
The manuscript first proves \(1,x,y\) are \(H\)-independent (`04-lines.tex:59–79`). Main takes a shorter sufficient route: `shift` makes \(u,v\) units using \(x,y\notin H\), while `local_exponent` proves \(z\ne0\) directly (`691–703`). Indeed \(z=0\) would give \(x/y=a/b\in H^\times\), hence \([x]=[y]\), equal image points, and equal image subfields, contradicting the edge. Thus no unproved source-plane independence is inserted into the formal argument.

Here are all the load-bearing conditions checked before applying the unchanged intersection theorem (`Main.lean:673–765`, compare `04-lines.tex:111–138`):

1. \(X,Y,U,V,Z\) are field units; \(X,Y\notin C\); and the generated two-variable target field has degree \(p^2\). `Z` is a unit representative of \(e([z])\) (`703–705`). Nonzero as a field element must not be confused with nonzero in the quotient.
2. The first two affine symbols vanish. Compatibility and zero-symbol detection give \(U\in C(X)\) and \(V\in C(Y)\) (`706–711`).
3. Neither \(u=x+a\) nor \(v=y+b\) has quotient class in the \(\mathbf F_p\)-span of the corresponding original point. `affine_nonmonomial` (`374–397`) uses a polynomial of degree less than \(p\) and the minimal polynomial degree \(p\); `shift_not_power` (`582–594`) translates this into quotient classes. Injectivity and linearity of `e`, via `transfer_nonmonomial` (`653–671`), yield exactly the dependency's conditions \(U\ne cX^i\), \(V\ne dY^i\) for every \(0\le i<p\) and \(c,d\in C\) (`712–713`). In particular \(U,V\notin C\).
4. \(Y/X\notin C\), since otherwise their quotient points and simple subfields coincide (`714–718`). Also \(V/U\notin C\): otherwise \(U\) belongs to both \(C(X)\) and \(C(Y)\), whose intersection is \(C\), contradicting the first nonmonomial condition (`719–733`).
5. The remaining zero symbols are
   \[
   \{y/x,z/x\}=0,\qquad \{v/u,z/u\}=0,
   \]
   using \(z/x=b-a(y/x)\) and \(z/u=b-a(v/u)\). Both affine coefficients \(b,-a\) are nonzero (`734–750`). The minus sign is retained in both applications.
6. Compatibility and detection, now legitimately using the two nonconstant first arguments, give
   \[
   Z/X\in C(Y/X),\qquad Z/U\in C(V/U)
   \]
   (`751–758`). Both ratios are nonzero, and their products with \(X,U\) equal the **same** nonzero \(Z\). These final multiplicative witness conditions are supplied explicitly (`759–765`).

Thus `CharPIntersection.prop_intersection` is applied to an actual nonzero intersection witness, not a witness postulated from abstract incidence. Its supported conclusion supplies \(1\le n<p\), nonzero \(A,B,D,E\in C\) with
\[
U^n=A+BX^n,\qquad V^n=D+EY^n,
\]
and uniqueness of \(n\) from either affine-power inclusion even without restrictions on a competing inclusion's coefficients. This last strength is essential to propagation and is part of the reused interface, not re-proved in this assessment.

### 3. One global scalar, not pairwise unrelated choices

The source partitions nonzero quotient points by the image fields \(C(X)\). There are at least two parts because \([L:C]\ge p^2\), and surjectivity of `e` supplies source preimages. The complete multipartite graph is connected with paths of length at most two (`04-lines.tex:44–56`). Fixing one affine pair while varying its partner, then using either single-inclusion uniqueness, synchronizes the local exponents (`141–153`).

Main formalizes the same mechanism, rather than assuming coherence. `two_parts` constructs distinct target simple fields from the actual degree bound (`767–796`). In `global_affine` (`900–944`), the index type is **all source unit representatives outside \(H\)**; its partition is the simple target field generated by a chosen representative of `e([x])`. The local predicate is the actual `CharPIntersection.AffinePower` relation for the images of \(x\) and \(x+a\). Two target parts are pulled back using `e.symm` (`918–926`).

`local_exponent` supplies a common exponent and uniqueness from either local predicate. `LineGlue.global_parameter_local_unique` (`826–846`) derives uniqueness for each vertex/parameter from a neighbor and a fixed nonzero parameter \(a_0=1\); `global_parameter` (`804–824`) propagates it from two fixed distinct parts to every vertex and every parameter. `global_affine` instantiates these facts on the actual quotient (`927–944`). Abstract glue here is only a proved intermediate combinatorial lemma, not an abstract replacement for the fields or relations.

To pass from \(x+a\) to a whole line through \([1]\), Main treats \(u=c+dx\) in all cases (`containment`, `1077–1132`). If \(d=0\), its quotient point is zero; if \(c=0\), it is \([x]\). Otherwise divide by \(d\) and use the nonzero parameter \(a=c/d\). This yields `PreservesZero` for the corrected map. Multiplicative translates, encoded by `line a b = {c | ZeroInc (b-a) (c-a)}`, then cover arbitrary distinct endpoints. This agrees with `04-lines.tex:155–163`; no onto-ness has been inferred merely from global bijectivity.

### 4. Scalar rigidity, inverse, onto-ness, and uniqueness

Scalar rigidity rests on the minimal polynomial degree \(p\), not finite tests. For \(x\notin F^p\), a nonzero scalar represented by \(1\le r<p\) that preserves lines forces
\[
(x+1)^r=A+Bx^r,\qquad A,B\in F^p.
\]
If \(r>1\), a polynomial of degree less than \(p\) would vanish at \(x\), but its intermediate coefficient \(r\) is nonzero modulo \(p\). The manuscript uses the coefficient of \(x^{r-1}\) (`04-lines.tex:14–30`); `InseparableDerivations.scalar_affine_rigidity` uses the coefficient of \(X\) (`399–426`). These are equivalent contradictions. The wrapper `scalar_rigidity` (`1134–1170`) obtains \(x\) from the degree bound and translates actual incidence into that equation. This wrapper is scoped to finite p-degree at least \(p^2\), which suffices for the root; it does not purport to state the manuscript's standalone lemma for every imperfect field in that full generality.

The manuscript applies containment to the compatible corrected inverse \(\Psi^{-1}\), uses rigidity to remove its new correction, and deduces equality of lines (`04-lines.tex:166–182`). Main instead applies containment independently to the **original** `e` and `e.symm`; `compatible_symm` proves the latter's compatibility from relation-space equality (`1062–1075`). If
\[
\Psi=n e,\qquad \Phi=m e^{-1},
\]
their composite is scalar \(mn\) on \(V_K\). It preserves normalized incidence by `preservesZero_comp`, so rigidity gives \(mn=1\), hence \(\Phi=\Psi^{-1}\) (`prop_lines`, `1178–1193`). This is an equivalent alternate proof; it needs no separate formal lemma asserting compatibility of scalar multiples, and it does not invoke the onto conclusion while constructing the inverse.

`lineOnto_of_both` (`1017–1032`) now proves exact set-image equality by forward containment and inverse containment. A target point on the endpoint line has preimage on the original line, so this is actual onto-ness on each line. For another scalar \(k\), the composite \((ke)\circ\Psi^{-1}\) is scalar \(kn^{-1}\) on \(V_L\). It preserves incidence; target-side rigidity forces \(k=n\) (`1195–1205`), matching `04-lines.tex:184–187`. The span-based normalization equivalence then proves the stated root for **every** competing scalar sending lines onto some target lines.

There is no exclusion of \(p=2\). The sole admissible positive exponent below \(p\) is then \(1\). The determinant and Steinberg cancellation work in characteristic two; \(-a\) remains nonzero, and neither the witness construction nor the uniqueness argument divides by \(2\). In the rigidity proof, the nontrivial binomial case has \(r>1\), so no vanishing/intermediate-coefficient claim is needed at \(r=1\). Onto-ness is still proved by inverse containment, not by the fact that \(\mathbf F_2^\times\) has one element.

## Generality and the function-field bridge

The claimed extension beyond the manuscript's function-field statement is mathematically supported: every substantive step above uses only the actual pth-power subfields, finite degree over them, the two lower bounds, and Steinberg compatibility. There is no hidden algebraically closed constant field in these constructions.

The following distinctions matter:

| Issue | What is encoded, and what is not |
| --- | --- |
| Arbitrary finite p-degree fields | Explicitly quantified in `prop_lines_source`; finite-dimensionality and the two `Module.finrank` bounds are formal hypotheses. |
| Simple/pair degree facts | Minimal polynomial degree \(p\), simple degree \(p\), and pair degree \(p^2\) are proved in Main (`491–563`); derivations are constructed there. |
| “Finite p-rank at least two” terminology | The usual equivalence with finite \([F:F^p]=p^e\), \(e\ge2\), follows from the standard successive-adjunction/p-basis fact. Main does not package a separate theorem computing a global integer \(e\). No such unformalized computation is required by the root **as actually written**, which uses degrees directly. |
| Quotient/projective interpretation | Constructed quotient, surjectivity, ratio equality, and actual line/span criteria are proved. A separately named equivalence to a library projectivization object is not constructed, but the needed representative-level correspondence is not an assumption. |
| Milnor-K terminology | The identification with \(K_2^{\mathrm M}/p\) is the standard tensor presentation, not a separate formal Milnor-K comparison theorem. |
| Function-field hypotheses and p-degree formula | Neither finite generation, algebraic closure of a named base, transcendence degree, nor \([F:F^p]=p^d\) for function fields occurs in the root. The specialization uses the reviewed prose argument below. |

For the manuscript, \(K/k,L/l\) are finitely generated over algebraically closed fields of characteristic \(p\), with both transcendence degrees at least two (`04-lines.tex:32–38`; `01-introduction.tex:41–54`). Algebraic closure implies the perfectness needed for the degree calculation, not an additional separability assumption.

The bridge in `02-symbols.tex:17–38` and historical `report.md:219–234` is valid. For \(F/\kappa\), let \(d=\operatorname{trdeg}(F/\kappa)\), choose a transcendence basis, and put \(F_0=\kappa(t_1,\ldots,t_d)\). Perfectness gives \(F_0^p=\kappa(t_1^p,\ldots,t_d^p)\). Grouping monomial exponents modulo \(p\), with \(a/b=ab^{p-1}/b^p\) for rational functions, gives \([F_0:F_0^p]=p^d\). Write \(q=[F:F_0]\), which is finite and positive. Frobenius identifies \(F/F_0\) with \(F^p/F_0^p\), so \([F^p:F_0^p]=q\). In particular \(F/F_0^p\) is finite, making the intermediate degree \([F:F^p]\) finite as well. The two towers give
\[
q p^d=[F:F^p]q.
\]
Cancellation gives \([F:F^p]=p^d\), including inseparable \(F/F_0\). For \(d\ge2\), both root degree bounds follow. This is a sufficient and explicit unformalized specialization argument, not a concrete gap in the local theorem or an unsupported extra line-preservation hypothesis.

## Evidence classification, attribution, and remaining boundary

The parent-verified historical certificate records compiler exit 0, axiom-audit exit 0, no proof holes, Lean **4.31.0**, commit `68218e876d2a38b1985b8590fff244a83c321783`, and Mathlib workspace `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`. The reported axiom closure is `propext`, `Classical.choice`, `Quot.sound`. These facts are reused historical evidence for the bound source, **not a fresh run or a fresh kernel certificate by this assessment**. Statement fidelity was assessed above independently of treating compilation as sufficient.

The parent subsequently verified that the certificate's embedded source equals both the ledger formal string and the preserved file, its embedded fidelity equals the preserved reading, and the live `lean_check.json` equals the archived record. The imported intersection source and dependency certificate match their recorded bindings. The `.olean` cache is not among the 20 snapshot-manifest files and is not offered as a separately source-bound certificate or loaded for a present replay.

`verify.py:96–133` contains local diagnostics; `136–215` also recompiles an import, writes logs/replay artifacts, and in record mode writes a certificate. It was inspected, not run. The parent's verified historical counts are 16, 81, 625, and 2401 affine-identity assignments at primes 2, 3, 5, and 7, and 61 nonzero binomial-coefficient checks. The typed Jacobian result checks the formal coefficientwise identity \(B(X+A)-A(Y+B)=BX-AY\) at modulus 2. These are bounded algebra/sign diagnostics, not proofs of universal field incidence, global coherence, or onto-ness. The universal support is the source-bound Lean theorem plus the mathematical fidelity analysis, not an extrapolation from those checks.

The manuscript owns the source propositions and arguments being reproduced: the zero/affine-symbol lemmas, scalar rigidity, and `prop:lines`. Section 04 itself cites Cadoret–Pirutka as methodological precedent (`04-lines.tex:3–8`). The Argus work is a reconstruction/formalization with alternate derivation-extension, direct nonzero-witness, abstract-glue, and inverse-normalization implementations, and a supported broader finite-p-degree statement. The imported intersection source is a reused dependency, not a new contribution. Historical `report.md:236–242` describes progress relative to prior campaign coverage; it is not evidence of publication-level originality. No novelty is claimed or assessed, and no new manuscript-error search was undertaken.

The local result is not the whole reconstruction theorem. The separate projective lifting statement (`05-fields.tex:13–23`), semilinear-to-multiplicative normalization, recovery of the original constant field through the perfect core (`05-fields.tex:91–97`), and the main reconstruction map's bijectivity (`01-introduction.tex:41–54`) are outside this certificate and this proof read. These remain separate historical obligations (`L_CHARP_PROJECTIVE_LIFT`, `L_CHARP_PERFECT_CORE`, `C_CHARP_RECONSTRUCTION_UNVERIFIED`), not reasons to label the supported local line theorem unresolved. No assessment of their proofs or new alleged manuscript gap is made here.

**Premise to record in the current ledger:** the valid but non-Lean function-field p-degree formula \([F:F^p]=p^{\operatorname{trdeg}(F/\kappa)}\) for finitely generated extensions of a perfect characteristic-p base is the specialization bridge. If a ledger claim names \(W\) as \(K_2^{\mathrm M}(F)/p\), also distinguish the standard tensor-presentation identification from the formally constructed quotient. Literal quotient and line interpretations are proved internally, not new external assumptions. Retain the exact version-3 intersection dependency binding rather than creating another intersection result.

**Bounded replay question:** none is necessary for this mathematical assessment. The source, exact statement, accepted dependency interface, and reusable successful historical evidence leave no decision-relevant computation unresolved. Native independent review and any official current-project checks remain the parent's responsibility.
