# Assessment: characteristic-p intersection

## Verdict and assessment boundary

**Supported:** the local intersection proposition, including a common exponent, nonzero affine coefficients, and uniqueness from either single inclusion. The preserved Lean statement is faithful to this proposition. Removal of ambient finiteness is supported both by the generalized Lean declaration and by the localization argument below. The still weaker assumption that only the two coordinate p-th powers belong to the coefficient field is mathematically sufficient, but is not the literal signature of that generalized declaration.

This is mathematical assistance to the Engineer, not the native independent Reviewer’s decision. No novelty, mission acceptance, manuscript-wide certification, or manuscript refutation is claimed. Global line recovery, exponent propagation between pairs, and reconstruction are outside this assessment; their omission is not an unresolved obligation in the local theorem.

I read the old `Main.lean`, `report.md`, `statement-fidelity.md`, `verify.py`, and `requirements.txt`; the pinned manuscript’s entire `03-intersection.tex`; and only the quotient notation and p-basis setup needed from `02-symbols.tex`. The old ledger was inspected only to compare the two intersection formal strings. No historical checker or compiler was executed. The parent’s separate current diagnostic below does not replay the old operator.

## Source and version bindings

Historical paths below are relative to `campaigns/9000009/`.

| Item | Exact binding |
|---|---|
| Manuscript | `Reconstruction-from-Milnor-K-theory-modulo-the-characteristic-October-5-2026`, revision `4eaee87548250b2682affda7d05d947c05554bae` |
| Target | `build/build/sections/03-intersection.tex:17–37`, `prop:intersection`; proof at lines 43–138 |
| Section 03 SHA256 | `e97a074e701ad33c335018882b71eed89ef5e0f3e6fb9b4789488af72181c83b` |
| Formal source | `research/char-p-intersection/Main.lean`, SHA256 `96ef99bfd773341718ab4e220167f05778a27ab97db1ebb52d6a095faff078b1` |
| Fidelity documents | Both `statement-fidelity.md` and `statement_fidelity.md`, SHA256 `4cb12a6c193626fdd9aee018fc7514b6ab439a6444d0ed5d5f29bcadf53dcfce`; one reading, not two results |
| Reviewed latest claim | `V_CHARP_INTERSECTION@3`, content hash `bc454725f6e3913984e01e96fb83ae34f15ce44a47d81fa073dac264680d9bcb` |
| Supporting archive | `research/char-p-intersection/certificates/V_CHARP_INTERSECTION-8ee0aa52ccd7bea2.json`, SHA256 `4a8a534637ab71d6167ee5771b450b5a2fe5827ed34cc0d543be32bda00a7417` |
| Historical judgement | `judgement-V_CHARP_INTERSECTION-d2a910e000f2`, `reviewer:copilot`, supports this exact v3 claim hash and certificate |

These integrity and compiler facts are **reused parent-verified evidence**, not freshly established by this assessment: all 35 inventoried files exist and match inventory sizes; all 20 files covered by the preserved snapshot manifest match its SHA256 values; and all seven characteristic-p manuscript `.tex` files match `MANUSCRIPTS.json` at the revision above. The parent also verified the displayed source, fidelity, certificate, and claim bindings. This does not imply that all 35 inventory entries were covered by the 20-entry snapshot manifest.

The original mathematical proposition belongs to the manuscript, whose lines 12–15 attribute the differential method and positive-characteristic power correction to Cadoret–Pirutka, Sections 3.4–3.5. The Argus draft is an alternate local proof/formal reconstruction and a proposed strengthening, not an original counterexample or a demonstrated new theorem of independent priority. That citation’s priority is not checked here and is not needed as a proof premise.

## Exact statement and scalar meanings

Let \(p\) be prime and \(F\) a field of characteristic \(p\). In the source proposition,
\[
C=F^p,\qquad [F:C]<\infty.
\]
Let \(X,Y\in F^\times\) satisfy
\[
[C(X,Y):C]=p^2.
\]
This is precisely p-independence as defined in `02-symbols.tex:41–44`, not algebraic independence over an original constant field. Let
\[
U\in C(X)^\times,\qquad V\in C(Y)^\times,
\]
and require that neither is a \(C^\times\)-multiple of a power of its corresponding coordinate. Equivalently,
\[
\forall\,0\leq i<p,\ c\in C,\quad U\ne cX^i,
\qquad
\forall\,0\leq j<p,\ d\in C,\quad V\ne dY^j.
\]
Allowing zero scalar coefficients here is harmless because \(U,V\ne0\); integer powers reduce to these residues because \(X^p,Y^p\in C^\times\).

The notation \(\mathbb F_p[X]\) in the source hypothesis means the \(\mathbb F_p\)-span of the multiplicative class \([X]\), not a polynomial ring. The two scalar structures must not be conflated: \(C^\times\) rescales actual field representatives, whereas multiplication by \(r\in\mathbb F_p\) sends \([U]\) to \([U^r]\) in \(F^\times/C^\times\). See `02-symbols.tex:9–13`. Rescaling representatives by \(C^\times\) preserves the proposition (`03-intersection.tex:140–143`).

The actual witness hypothesis is a nonzero \(Z\), with nonzero \(s,t\), such that
\[
s\in C(Y/X),\quad t\in C(V/U),\quad Z=Xs=Ut.
\]
It is the full intersection hypothesis, not merely an assumed differential identity or the sufficient condition that two linear spans meet.

The conclusion supplies **one common** natural integer \(n\), \(0<n<p\), and \(a,b,c,d\in C^\times\) with
\[
U^n=a+bX^n,\qquad V^n=c+dY^n.
\]
Moreover, for every \(0<r<p\), **either** membership \(U^r\in C+CX^r\) **or** membership \(V^r\in C+CY^r\) forces \(r=n\), even when that tested membership initially permits zero coefficients.

## Exact Lean scope

All declaration names in this section are in `CharPIntersection`.

* `Nonmonomial` (`Main.lean:486–487`) quantifies over every `m : Fin p` and every coefficient in the embedded field. `AffinePower` (489–490) permits zero coefficients; `AffinePowerNonzero` (492–494) requires both to be nonzero.
* `ExponentConclusion` (820–825) is existential in one `n : ℕ`, with `0 < n`, `n < p`, the two nonzero-coefficient conclusions, and a universal quantifier over `r : ℕ`. Its uniqueness premise is an **or**, not an and.
* `PthPowers` (984–986) is `(frobenius F p).fieldRange`, the actual subfield \(F^p\).
* `prop_intersection` (988–1010) ranges over arbitrary `F : Type*` with `[Field F]`, arbitrary `p : ℕ` with `[Fact p.Prime]` and `[CharP F p]`, and `[FiniteDimensional (PthPowers F p) F]`. It takes the degree equality, the four nonzero inputs, actual simple-adjoin memberships, both nonmonomial hypotheses, and the explicit nonzero witness and factors. The extra explicit nonzero-factor hypotheses are redundant, not stronger than a genuine witness.
* `intersection_exponent` (868–982) instead permits arbitrary fields `k,F`, `[Algebra k F]`, characteristic \(p\) on both, and
  `∀ z : F, ∃ c : k, z ^ p = algebraMap k F c`.
  It assumes the same local degree \(p^2\), memberships, nonmonomial conditions, and witness. There is **no** ambient finite-dimensional hypothesis and no requirement that `k` be exactly \(F^p\). Its conclusion is relative to `k`.

An algebra map between these fields is injective, so “embedded coefficient field” is appropriate. Neither declaration assumes a chosen p-monomial basis, common weight, integration exponent, or desired affine-power identity. The auxiliary `chart_intersection` (827–857) does take a `Chart` containing a basis; the final declarations construct that chart rather than inheriting it as an unproved hypothesis. The explicit witness parameters are universally quantified: their hypotheses imply the conclusion for any witness, equivalently for a nonempty intersection. No odd-characteristic restriction occurs.

## Decisive argument checked against both sources

### 1. Coordinate field, basis, and Euler calculus

Put \(E=k(X,Y)\). Powers reduce modulo \(p\) because \(X^p,Y^p\in k\). The source proves multiplication closure of the p-monomial span, and under its `hpowers` hypothesis proves inverse closure by
\[
u^{-1}=(u^p)^{-1}u^{p-1}\quad(u\ne0).
\]
See `power_reduce`, `monomial_product`, `inv_mem_span`, `coordinateField`, and `coordinateField_eq_adjoin` (`Main.lean:17–141`). The span is therefore the actual field adjoin. In `intersection_exponent:882–917`, the \(p^2\) spanning vectors and the supplied degree equality give a basis and a `Chart`; independence is not assumed separately.

`eulerLinear_leibniz` (222–247) checks basis products using exponent reduction: removing a multiple of \(p\) changes the coefficient but not its characteristic-p weight. `leibniz_of_basis` (189–202) extends this to all inputs. `euler` (249–252) packages derivations; `euler_commute` and `euler_generators` (258–279) establish commutation and their values on \(X,Y\).

`cast_fin_injective`, `joint_eigenvector`, and `constant_of_diagonal_zero` (285–344) use distinct residues \(0,\ldots,p-1\). Together with `Chart.kill_X`, `kill_Y`, `preserve_X`, `preserve_Y`, `eigen_X`, and `eigen_Y` (442–483), they establish the one-variable eigenvector description and kernel, and that an element in both one-variable subfields is scalar. This reproduces the needed content of `02-symbols.tex:46–84` without requiring a p-basis of all of the ambient field.

### 2. Nonconstant corrections and the actual witness

Write \(D=D_X\), \(E'=D_Y\), and
\[
A=U/DU-1,\qquad B=V/E'V-1.
\]
`Chart.dx_nonzero`, `dy_nonzero`, and the two correction lemmas (`Main.lean:561–590`) prove that the denominators are nonzero and that \(A,B\) are not scalar. A zero derivative would make the input scalar. A scalar correction would make the input an Euler eigenvector, hence a scalar monomial, contradicting the hypotheses. In particular \(A,B\ne0\).

`Chart.common_weight:593–650` constructs
\[
\delta=D+E',\qquad \delta'=(U/DU)D+(V/E'V)E'.
\]
The quotient rule and `deriv_kills_adjoin` show that they kill \(Y/X\) and \(V/U\), respectively. The two actual expressions for the witness give
\[
DZ+E'Z=Z,\qquad (A+1)DZ+(B+1)E'Z=Z.
\]
This is the manuscript’s translation at `03-intersection.tex:53–84`; the formal proof derives it rather than taking it as a new hypothesis.

### 3. Elimination forces the common nonzero weight

`common_logarithmic_weight` (`Main.lean:503–532`) subtracts those equations to obtain \(A\,DZ+B\,E'Z=0\). Since \(B,Z\ne0\), \(DZ=0\) would force \(E'Z=0\) and then \(Z=0\). Differentiating the relation by \(D+E'\), and using commutation and the witness equation, gives
\[
(DA)DZ+(E'B)E'Z=0.
\]
Elimination yields
\[
(B\,DA-A\,E'B)DZ=0,\qquad DA/A=E'B/B.
\]
Every cancellation used here has a proved nonzero factor. This is a valid denominator-free replacement for the manuscript’s \(q_X,q_Y\) argument (`03-intersection.tex:86–98`), not an assumed logarithmic-derivative equality.

The common value belongs to both \(k(X)\) and \(k(Y)\), hence to \(k\). `Chart.common_weight:651–668` applies the two eigenspace classifications and injectivity of residue casts to obtain
\[
A=c_X X^m,\qquad B=c_Y Y^m,\qquad c_X,c_Y\in k^\times,\quad 0<m<p.
\]
The same scalar eigenvalue forces the **same residue** \(m\); nonconstancy excludes zero. This matches manuscript lines 99–109.

### 4. Integration and nonzero coefficients

`integrate_correction` (`Main.lean:705–755`) puts \(n=p-m\) and
\[
S=X^n+c_XX^p=X^n(U/DU)\ne0.
\]
It proves \(DS=nX^n\) and equality of the logarithmic derivatives of \(U^n\) and \(S\). Their quotient lies in \(k(X)\) and has derivative zero, so it equals \(t_X\in k^\times\). Thus
\[
U^n=(t_Xc_XX^p)+t_XX^n,
\]
with both coefficients in \(k^\times\); the proof explicitly checks \(X^p\ne0\). The identical construction for \(Y,V\) uses the already shared \(m\), hence the same \(n\). This checks the denominator and kernel obligations in manuscript lines 111–123. For \(p=2\), \(m=n=1\); no division by 2 is hidden.

### 5. Uniqueness from either unqualified inclusion

For \(U^r=a+bX^r\), `affine_forces_weight` (`Main.lean:757–798`) uses \(0<r<p\), \(DU\ne0\), and \(U\ne0\) to prove \(b\ne0\) and
\[
A=\frac{a}{bX^r},\qquad DA=-rA.
\]
These statements do not presuppose both coefficients are nonzero. In conjunction with \(A\ne0\), the displayed formula also excludes \(a=0\). The known weight \(DA=mA\) then forces \(m+r=0\) in characteristic \(p\). `unique_exponent` (800–817) compares residues to conclude \(r=p-m=n\). `chart_intersection:854–857` applies this separately to either disjunct.

The manuscript’s alternative zero-coefficient argument (125–137) is also valid: nonzero \(r\in\mathbb F_p\) acts invertibly on \(F^\times/C^\times\), so a monomial class for \(U^r\) would contradict the hypothesis for \(U\). There is no missing uniqueness assumption.

## Ambient finiteness: rigorous scope of the strengthening

The manuscript uses \([F:F^p]<\infty\) to extend \(X,Y\) to an ambient p-basis. That extension is unnecessary here. In the formal generalized theorem, `Main.lean:919–964` explicitly places
\[
U,V,s,t,Z\in k(X,Y)
\]
and lifts their simple-adjoin memberships into that field using `lift_adjoin_membership` (859–866). All calculus then takes place in its degree-\(p^2\) chart. Consequently, with \(k=F^p\), the theorem remains true even when the ambient p-rank is infinite. This removal is supported, not merely suggested by successful small-prime cases.

The old prose proposes still less: an arbitrary embedded \(k\subset F\) with only \(X^p,Y^p\in k\), local degree \(p^2\), and the corresponding input/witness hypotheses. This is also sufficient. To see the point not automatic from the exact Lean signature, let
\[
W=\sum_{0\le i,j<p} kX^iY^j.
\]
It contains \(1,X,Y,k\) and is closed under multiplication by exponent reduction. For every \(w=\sum c_{ij}X^iY^j\in W\), the characteristic-p Frobenius identity gives
\[
w^p=\sum c_{ij}^{\,p}(X^p)^i(Y^p)^j\in k.
\]
For nonzero \(w\), this scalar is nonzero and \(w^{-1}=w^{p-1}/w^p\in W\). Hence \(W\) is a field and equals \(k(X,Y)\). The degree hypothesis makes its p-monomials a basis. All inputs and the witness lie in this field, whose p-th powers have just been proved to lie in \(k\). The already checked local argument applies unchanged.

Thus no global assumption on p-th powers outside the coordinate field is mathematically needed. However, the existing `intersection_exponent` takes `hpowers` on **all ambient `F`**: the weaker local-only formulation is a justified prose consequence/localization, not a separately compiled Lean declaration. This distinction is a formalization boundary, not a counterexample or a gap in the original proposition.

## Historical formal evidence, scanner issue, and experiments

The supporting v3 archive records Lean **4.31.0**, commit `68218e876d2a38b1985b8590fff244a83c321783`, with Mathlib workspace `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`, compiler exit 0, axiom-audit exit 0, no proof holes, and only `Classical.choice`, `Quot.sound`, and `propext` for the final theorem. `Main.lean:1012` requests its axiom report. This is historical kernel/compiler evidence reused under unchanged bindings; the statement-fidelity judgement and mathematical inspection above are the present work. No new compilation is claimed.

The earlier `V_CHARP_INTERSECTION@2` has hash `72f6234871ac133422667ae120703d2286e2a12b4bb44ada9a328c5281b3fd2d` and certificate `...-c094f6f68594aaca.json`. Its mechanical result was inconclusive/`proof_hole`, with no compiler executed, an empty command, and null exit. I compared the actual v2/v3 formal strings: the complete difference is the helper rename `Chart.constant` → `Chart.scalar_of_zero` and its five calls, at lines **438, 565, 572, 656, 851, 853**. No hypothesis, conclusion, formula, or proof step was changed. The scanner’s lexical complaint about `constant` was therefore not a failed mathematical proof or a repaired mathematical counterexample. Version 1 was prose-only and is superseded.

The exact v3 reviewer support is stronger evidence than stale open labels in the old graph/report or `pending_host_reviewer` text generated by `verify.py:278`. That historical support does not replace the current native independent review, which remains pending.

`verify.py` is supplementary evidence plus a compiler-replay wrapper, not a stand-alone universal mathematical argument:

* `ExponentOneField` (22–124) implements coordinates over \(\mathbb F_p(a,b)\) with algebraically independent \(a,b\), and relations \(x^p=a,y^p=b\). This is a genuine degree-\(p^2\) exponent-one field, not a perfect finite field where the independence hypothesis would be impossible.
* `exact_field_checks` (127–203) ranges only over \(p=2,3,5,7\). The preserved results are 6,246 basis-product-rule checks and 13 explicitly constructed witness/exponent cases. These test arithmetic and examples; they do not prove all characteristics or all inputs.
* Its \(p=3\) negative control \(U=1+x+x^2,\ V=1+y\) has rank 6 for the six witness-space columns, hence zero intersection. This one pair is a consistency check on necessity, not a refutation of the conditional proposition.
* `jacobian_check` (206–227) reads a preserved `prime_field.matrix.nullspace.compute` result. The complete \(p=2\), \(4\times4\) Euler-sum matrix nullspace is \(\langle1,xy\rangle\). It is not the joint kernel of the two Euler derivations and is not a proposition certificate.
* `lean_check` (230–267) would check bindings and recompile; `main` (270–299) can write the old exact certificate. Neither was run here. `requirements.txt` pins SymPy 1.14.0 for those Python checks, not as a premise of the Lean proof.

## Foundations, limitations, and ledger handoff

No unproved external mathematical lemma, Bloch–Gabber–Kato input, geometric reconstruction theorem, or historical citation is assumed in the checked local argument. The explicit field/prime/degree/membership/nonmonomial/witness hypotheses remain essential. The formal evidence depends on Lean’s kernel/toolchain, Mathlib’s definitions and proved library results, the three listed standard logical axioms, and the parent-established integrity bindings.

No concrete mathematical gap was found in the local theorem or its removal of ambient finiteness. The weaker local-only coefficient-field statement is supported by the displayed field-closure argument, with the formalization boundary stated explicitly. Nothing here proves line recovery across an isomorphism, projective lifting, perfect-core recovery, the reconstruction theorem, or the correctness of an entire manuscript/family.

No decision-relevant isolated replay is needed for this assessment: no changed source, disputed arithmetic result, or unresolved compiler-dependent question was identified. A future replay would need a specific new question; it should not be justified by the obsolete v2 scanner label.

### Parent-added diagnostic-scope comparison

The historical \(D_X+D_Y\) nullspace must not be confused with the joint Euler kernel. One bounded current adapter operation computes a **different** operator: the stacked \(8\times4\) matrix of \((D_X,D_Y)\) over \(\mathbb F_2\), on ordered formal coordinates \((1,x,y,xy)\). The retained output has nullity 1 and basis row \((1,0,0,0)\), whereas the historical sum-operator output has nullity 2 and basis \((1,xy)\). This finite linear-algebra diagnostic clarifies the scope of the old evidence, not the truth of the universal theorem. It does not construct an independent coordinate pair in a perfect finite field.

The operation is `prime_field.matrix.nullspace.compute`, inspected before execution through the live Argus adapter. The exact input and output are `jacobian-joint-euler-input.json` and `jacobian-joint-euler-output.json` in this review directory; discovery and the typed contract are in the parent `draft_reviews` directory. The output retains the exact source payload, with server version `0.14.0`, protocol `2025-11-25`, adapter exit 0, complete typed result, no timeout and no structured error. It is not a fresh compilation, a new manuscript-error search, or an additional theorem. The parent also verified exact equality of archived source/fidelity text with the ledger and live files, and of each live compiler record with its archived counterpart.

The parent owns all ledger bindings. The source-translation premise to record, if not already present, is the exact target at pinned `03-intersection.tex:17–37`, with p-independence from `02-symbols.tex:41–44` and the multiplicative-class interpretation from lines 9–13. This records what the manuscript states, not an assumption that it is true. Bind the reused support to **v3 and its exact hash**, distinguish the global-`hpowers` formal generalization from the local-only prose consequence, and leave native independent review pending. No additional external mathematical premise is required for the local result. The current ledger was not inspected or modified here.
