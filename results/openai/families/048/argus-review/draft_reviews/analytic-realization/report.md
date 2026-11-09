# Analytic realization and the full analytic derivation sheaf

## Assessment and scope

**Engineer assessment: supported as an implication from the stated curve and finite-jet inputs. Current independent review is required and pending.** This is not family acceptance, a kernel proof, an algebraization result, or a novelty assessment.

The decisive analytic argument survives close reading. It uses a finite jet through row index seven, not convergence of infinitely many changes of neighborhood. The proof checks separation before contraction, uniform cofinality before formal functions, and saturation of the **entire** analytic derivation module after descending the fields. No additional mathematical gap in that implication was found.

Path conventions:

- `O` = `campaigns/9000048` (read-only).
- `S` = `O/research/openai_manuscript/A-singular-normal-affine-surface-with-free-tangent-sheaf-September-23-2026`.
- The manuscript version is September-23-2026; the active coverage index identifies reference commit `4eaee87548250b2682affda7d05d947c05554bae`.
- The principal proof assessed is `O/research/analytic_audit/report.md`, §§1–8, together with `S/build/05-analytic.tex`, labels `analytic:realization`, `analytic:graded-vanishing`, `analytic:actual-lifting`, and `prop:analytic-counterexample`.

The active index's established identity check of all 14 preserved core artifacts is reused, not repeated. The other 97 of the 111 manifested supporting inputs are **not** thereby snapshot-verified. Reading those inputs does not strengthen their provenance. Old ledgers, graph, sources, checkers, and receipts were not modified.

## 1. Exact assertion and imported hypotheses

Work over \(\mathbb C\), with analytic structure sheaves and analytic Kähler differentials. The imported interface is:

1. A smooth connected projective complex curve \(C\), \(g(C)=21\), a line bundle \(L\) of degree 10, and a specified isomorphism \(L^4\simeq K_C\).
2. Six disjoint disk-to-outside overlaps on the split normal bundle \(L^{-1}\). Their changes are **finite** compositions of local holomorphic flows of
   \[
   D=t^k\bigl(b(z)t\partial_t+h(z)\partial_z\bigr),\qquad k\geq1,
   \]
   with \(b,h\) holomorphic on the punctured-disk overlaps. They fix \(C\) and its conormal.
3. Holomorphic local rows \(A_{ki},B_{ki}\), \(0\leq k\leq7\), defining
   \[
   v_i^{[8]}=t(A_iE_t+B_i\partial_z),\quad E_t=t\partial_t,
   \quad A_i=\sum_{k=0}^7 A_{ki}t^k,\quad B_i=\sum_{k=0}^7 B_{ki}t^k,
   \]
   compatible through coefficient degree eight in the logarithmic basis, with
   \[
   A_1B_2-A_2B_1=t^2(1+O(t))
   \]
   along **every** point of \(C\), including the common zeros of the initial row. “Coefficient one” refers to the normalized charts attached to \(L^4\simeq K_C\); the intrinsic requirement is a nowhere-zero leading coefficient.

This is the \(N=7\) instance of `J_all_orders` v3 and exactly the interface of the manuscript's `prop:jets` (`S/build/04-jets.tex`, final proposition). `CT_joint_inputs` v5 supplies a nonempty family of admissible inputs. The curve/trace and coupled-jet units assess those upstream existence claims separately. Their historical approvals are not substitutes for their current assessments. In particular, arbitrary unrelated local rows would not substitute for the global residue data used upstream.

**Quantified local implication.** For any finite data satisfying this interface, there is a smooth Hausdorff complex surface neighborhood \(Y\) of \(C\), with
\[
I=\mathcal O_Y(-C),\quad I/I^2\simeq L,\quad C^2=-10,\quad
F=\mathcal T_Y(-\log C),
\]
on which the rows define \(\bar v_i\in H^0(Y,IF/I^9F)\). After shrinking about the whole curve, there is a proper contraction
\[
\pi:Y\longrightarrow X,\quad \pi^{-1}(x)_{\mathrm{red}}=C,\quad
\pi_*\mathcal O_Y=\mathcal O_X,\quad
Y\setminus C\simeq X\setminus\{x\},
\]
with \(X\) normal. Both prescribed quotient sections lift on the **same** \(Y\) to holomorphic \(v_i\in H^0(Y,F)\). Their descendants generate
\[
\mathcal T_X=\mathcal Hom_{\mathcal O_X}
(\Omega^1_{X,\mathrm{an}},\mathcal O_X)\simeq\mathcal O_X^{\oplus2}.
\]
The point \(x\) is singular, and the complement is smooth. Thus nonemptiness of the imported data gives the manuscript's existential analytic proposition. This is not a statement about arbitrary algebraic derivations of a convergent-power-series ring, an explicit affine equation, or a global algebraic surface.

## 2. Per-claim coverage and verdicts

All verdicts below concern the latest version, with the historical changes examined in §4.

| Indexed claim | Latest version | Exact scope | Engineer verdict |
|---|---:|---|---|
| `M_realization` | 1 | Finite germs realize a smooth Hausdorff \(Y\), conormal \(L\), \(C^2=-10\), sections modulo \(I^9F\), logarithmic/ordinary wedge orders 4/5. | **supported**, conditional on the finite-jet interface |
| `M_graded_vanishing` | 2 | For **every** \(n\geq9\), \(H^1(C,F|_C\otimes L^n)=0\); for \(E=I^9F\) and **every** \(r\geq1\), \(H^1(Y,E/I^rE)=0\). | **supported**; the report's additional \(h^1\) at \(n=8\) is exactly 1 |
| `M_actual_lifting` | 9 | After shrinking, both quotient sections lift to holomorphic sections of \(F\), framing \(\mathcal T_{Y\setminus C}\). | **supported**; formal functions is applied only after proper contraction and uniform cofinality |
| `AN_finite_colength_extension` | 1 | For a Noetherian local domain of depth at least two, an injection \(R^r\hookrightarrow M\) into a finite torsion-free module with finite-length cokernel is an isomorphism. | **supported** by the direct regular-sequence proof |
| `M_analytic_counterexample` | 4 | An isolated genuinely singular normal complex surface germ with full free analytic tangent sheaf of rank two and exceptional curve of genus 21 and square \(-10\). | **supported** from the imported nonempty inputs and the local implication |
| `AN_analytic_endpoint` | 1 | Packages the preceding implication **and** trivial dualizing sheaf, discrepancy \(-5\), \(33\leq p_g\leq39\). | **supported in the combined stated scope**; the invariant components are assessed in `../analytic-invariants/report.md`, not counted again |
| `A_analytic_literature` | 1 | Historical inventory of initially unexamined Grauert, Demailly, and Cartan citations. | **partially_supported as an attribution inventory**, not an active mathematical premise: the Grauert/Cartan applications are supported by the read passages; the Demailly locators are not certified and have been replaced |

`AN_independent_review` is an additional graph bookkeeping node, not another mathematical result. Its historical receipt is real and scoped to the analytic implication (§6); this does not discharge current native review.

## 3. Decisive argument checks

### 3.1 Finite flows and a separated realization

On slightly enlarged compact annular bands, finitely many \(b,h\) and the derivatives needed for local flow existence are bounded. For \(|t|<2\epsilon\), the normal displacement over a unit time interval is bounded by a constant times \(\epsilon^2\), and the base displacement by a constant times \(\epsilon\). Choose these smaller than the transverse and annular buffers. Holomorphic ODE existence, continuation within the buffered domain, and uniqueness then give the time-one maps and their time-minus-one inverses on a common smaller neighborhood. Finite successive shrinkings handle the finite compositions. This is a genuine local ODE argument, not use of a formal exponential as an analytic map.

The separation argument in both sources is sufficient. Choose
\[
0<a_j<a'_j<b'_j<b_j
\]
inside the six disjoint disks. Retain \(V_j\) over \(|z_j|<b'_j\) and \(V_0\) over the complement of the closed \(a'_j\)-disks. Make the maps defined across the closed \([a_j,b_j]\)-bands, keep their images in the corresponding disjoint disks, and require
\[
|z_j(\Phi_j(p))-z_j(p)|<(a'_j-a_j)/2.
\]
Glue only on the open sets
\[
A_j=\{p\in V_j:a_j<|z_j(p)|<b_j,\ \Phi_j(p)\in V_0\}.
\]
Injectivity of each flow and disjointness of different images make every equivalence class have at most two elements. Consequently no unverified triple-overlap or longer-chain relation is hidden here.

For a convergent pair \(p_\nu\to p\in V_j\), \(\Phi_j(p_\nu)\to q\in V_0\), continuity across the band gives \(q=\Phi_j(p)\). A limiting source radius \(a_j\) would force \(|z_j(q)|<a'_j\), impossible in \(V_0\); the upper radius is already \(<b'_j<b_j\). Transverse boundary points cannot cause a missed pair because both limits are assumed inside the retained open pieces. Each graph is relatively closed. The finite relation, including its inverse graphs and diagonals, is closed, and the quotient map is open. Product neighborhoods avoiding the relation therefore give disjoint open quotient neighborhoods of unrelated points. The quotient is Hausdorff; each piece embeds openly, so it is a smooth complex surface. Second countability follows from the finite open quotient of second-countable pieces.

In the split identification \(T=t+O(t^2)\), \(Z=z+O(t)\). The possible first-order base displacement does not change \(I/I^2\). Thus the conormal is indeed \(L\), with self-intersection \(-10\). Row index \(k\) contributes logarithmic coefficient degree \(k+1\); indices \(0,\ldots,7\) therefore give actual compatible sections modulo \(I^9F\), lying in \(IF/I^9F\). Multiplying \(A\wedge B\) by the two outside factors of \(t\), and then by \(t\) from \(E_t=t\partial_t\), gives wedge orders 4 and 5. There is no off-by-one change of ideal convention.

### 3.2 The precise cohomological threshold

For any such realized neighborhood,
\[
0\longrightarrow\mathcal O_C\longrightarrow F|_C
\longrightarrow\mathcal T_C\longrightarrow0
\]
is intrinsic. In a coordinate change \(T=t\,u(t,z)\), \(Z=\psi(z)+O(t)\), the logarithmic Jacobian is
\[
\begin{pmatrix}tT_t/T&T_z/T\\tZ_t&Z_z\end{pmatrix};
\]
its first column on \(C\) is \((1,0)^{\mathsf t}\). The quotient transition is that of \(\mathcal T_C\). No splitting is used.

Twisting by \(L^n\) and using \(\mathcal T_C=L^{-4}\) gives
\[
0\longrightarrow L^n\longrightarrow F|_C\otimes L^n
\longrightarrow L^{n-4}\longrightarrow0.
\]
By curve duality the two outer \(H^1\)'s are dual to \(H^0(L^{4-n})\) and \(H^0(L^{8-n})\). For \(n=9+k\), \(k\geq0\), their degrees are \(-50-10k\) and \(-10-10k\). Negative degree rules out sections, proving the universal vanishing. At \(n=8\), \(H^1(L^8)=0\), \(H^2(L^8)=0\), and \(H^1(L^4)=H^1(K_C)\simeq\mathbb C\); hence
\[
h^1(C,F|_C\otimes L^8)=1.
\]
Thus nine is the sharp **uniform graded vanishing** threshold. This does not say that the particular prescribed fields cannot lift at some lower precision.

Because \(C\) is Cartier and \(F\) locally free,
\[
I^nF/I^{n+1}F\simeq F|_C\otimes L^n.
\]
The finite filtration of \(E/I^rE\), \(E=I^9F\), has indices \(9\leq n<9+r\), all in the vanishing range. Exact sequences prove \(H^1(Y,E/I^rE)=0\) for every \(r\geq1\). These sheaves are pushed forward from compact infinitesimal neighborhoods of \(C\); this assertion is not yet a statement about \(H^1(Y,E)\).

### 3.3 Proper contraction, normality, and uniform cofinality

Grauert's criterion is invoked on the already Hausdorff **smooth** surface, with compact nowhere-discrete analytic subset \(C\) and negative-definite matrix \([-10]\). The read contraction/reduction statements supply properness, function descent, a biholomorphism on complements, and normality of the target from normality of the source. The connected \(C\) maps to one point of the discrete exceptional image. Restrict to a small Stein target \(X\) and its **full inverse image** \(Y\). The source is not called Stein.

Set \(J=\mathfrak m_x\mathcal O_Y\). The set-theoretic fiber being \(C\) implies \(\sqrt J=I\) and \(J\subseteq I\); it does not imply equality of the scheme fiber with \(C\). In the complex subspace with sheaf \(\mathcal O_Y/J\), the nilradical is \(I/J\). The compact-uniform nilpotence theorem applies to this possibly nonreduced space, and yields **one** \(a\geq1\) along the whole compact curve:
\[
I^a\subseteq J\subseteq I,\qquad
I^{ar}\subseteq J^r\subseteq I^r\quad\text{for every }r\geq1.
\]
Coherence and a finite cover also give the same conclusion from the local analytic Nullstellensatz. This is not an unsupported passage from pointwise exponents to a single exponent.

All needed neighborhood restrictions can be achieved on the target: if \(U\) contains the compact fiber, properness makes \(\pi(Y\setminus U)\) closed and disjoint from \(x\). A smaller target avoids that set. Thus these shrinkings preserve properness and simultaneous validity of the constructions.

### 3.4 Pro-zero obstruction maps, not a fictitious termwise comparison

Proper direct-image coherence makes \(M=(R^1\pi_*E)_x\) finite over the Noetherian analytic local ring. The corrected formal-functions theorem gives
\[
\widehat M\simeq\varprojlim_r H^1(Y,E/J^rE).
\]
The replacement of higher-direct-image stalks by these cohomology groups is justified: the quotient sheaves are supported on the compact infinitesimal fiber, so restriction to a neighborhood of that support leaves their cohomology unchanged.

For **each** \(r\), the transition from index \(ar\) to \(r\) factors as
\[
H^1(Y,E/J^{ar}E)\longrightarrow
\underbrace{H^1(Y,E/I^{ar}E)}_{0}\longrightarrow
H^1(Y,E/J^rE),
\]
because \(J^{ar}E\subseteq I^{ar}E\subseteq J^rE\). This proves pro-zero and hence a zero inverse limit: every component of a compatible sequence is the image of its \(ar\)-component. It neither asserts vanishing at every \(J\)-index nor assumes a termwise base-change isomorphism. No separate Mittag–Leffler assertion is needed.

Since \(\widehat M=0\), the canonical compatible residue sequence of every \(m\in M\) is zero, in particular modulo \(\mathfrak m_xM\). Thus \(M=\mathfrak m_xM\), and Nakayama gives \(M=0\). Finiteness is essential. Off \(x\), \(\pi\) is an isomorphism, so \(R^1\pi_*E=0\). Coherence of \(\pi_*E\), Cartan B on the **singular Stein target**, and low-degree Leray now give the actual analytic group
\[
H^1(Y,E)=0.
\]
The quotient exact sequence lifts both \(\bar v_i\) to holomorphic sections on this same \(Y\). This is finite congruence lifting; it does not realize a prescribed infinite formal section.

### 3.5 The lifted frame persists on one neighborhood

The local errors lie in \(I^9F\), while the polynomial representatives lie in \(IF\). Their wedge changes by \(I^{10}\det F\). Explicitly,
\[
\det\begin{pmatrix}ta+t^9p&tc+t^9r\\tb+t^9q&td+t^9s\end{pmatrix}
-t^2(ad-bc)
=t^{10}(as+pd-br-cq)+t^{18}(ps-qr).
\]
Therefore the order-four logarithmic wedge is preserved; the ordinary wedge is
\[
v_1\wedge v_2=t^5u(t,z)\,\partial_t\wedge\partial_z,\qquad u|_C=1
\]
in the normalized charts. The ordinary error starts at order 11, and the logarithmic relative error starts at order 6. This argument never divides by the initial row, so its common zeros introduce no exceptional cases.

The local unit neighborhoods have a common neighborhood of compact \(C\); proper shrinking places a full inverse-image representative inside it. The fields consequently frame \(\mathcal T_{Y\setminus C}\) everywhere there, not just generically.

### 3.6 Full analytic derivations, not just a rank-two submodule

For \(f\in\mathcal O_X(U)\), \(v_i(\pi^*f)\) is holomorphic on all of \(\pi^{-1}U\) and descends uniquely through \(\pi_*\mathcal O_Y=\mathcal O_X\). It defines a derivation \(w_i\). In an analytic embedding, the tuples \(w_i(x_\alpha)\) are holomorphic and annihilate every defining relation by the chain rule on the puncture and density on the reduced target. They therefore define sections of \(\mathcal Hom(\Omega^1_{X,\mathrm{an}},\mathcal O_X)\). This explicitly addresses analytic, rather than merely abstract algebraic, derivations.

For completeness, the report's finite-colength lemma is valid. Tensor an injection \(R^r\hookrightarrow M\) as in its statement with \(K=\operatorname{Frac}R\), identifying \(M\subseteq K^r\). Some \(\mathfrak m^N\) kills the cokernel. Choose a regular sequence \(f,g\in\mathfrak m\). For a coordinate \(h\) of an element of \(M\), both \(f^Nh,g^Nh\) lie in \(R\).

Multiplication by \(g\) is injective modulo \(f^N\): from \(gx\in f^NR\), reduction modulo \(f\) gives \(x=fx_1\); cancellation and induction give \(x\in f^NR\). Hence \(g^N\) is injective on the same quotient. Applying this to \(x=f^Nh\) and
\[
g^N(f^Nh)=f^N(g^Nh)\in f^NR
\]
gives \(f^Nh\in f^NR\), whence \(h\in R\). Thus \(M=R^r\). The proof needs the domain, depth, finiteness, torsion-free, and finite-colength hypotheses actually stated; it is not true merely because two vectors are generically independent.

Apply this with \(R=\mathcal O_{X,x}\) and \(M=\mathcal T_{X,x}\). Normality, dimension two, and analytic Noetherianity give depth at least two. The analytic Jacobian presentation makes \(M\) finite and torsion free, as a kernel in \(R^e\). The map \(R^2\to M\) given by the \(w_i\) is injective and is an isomorphism off \(x\); its coherent cokernel has point support, hence finite length. (Equivalently, a power of \(\mathfrak m_x\) kills that finite cokernel.) The lemma proves surjectivity at \(x\), and hence full sheaf generation on a representative. Cramer's rule with a nonzero minor identifies these rational coefficients with the unique punctured-frame coefficients, so the lemma extends the actual coefficients, not unrelated choices.

### 3.7 The contracted point is genuinely singular

If \(x\) were smooth, a local nonvanishing two-form \(\eta\) would pull back to a holomorphic form nonvanishing off \(C\), with effective divisor \(bC\), \(b\geq0\). It would imply
\[
K_Y\cdot C=bC^2\leq0.
\]
Adjunction instead gives
\[
K_Y\cdot C=2g(C)-2-C^2=40+10=50.
\]
This contradiction proves singularity; smoothness of the complement follows from the biholomorphism with \(Y\setminus C\). Neither freeness nor the existence of an exceptional curve alone was used as a singularity test.

## 4. Historical claim versions and route changes

The statement text and its content hash stay fixed through the following version sequences; changes primarily make external dependencies explicit. An old support record attached to that hash must not be mistaken for a new check of every later assumption annotation.

| Claim/version | Historical change and present assessment |
|---|---|
| `M_actual_lifting` v1 | Manuscript assertion, no external-assumption annotations. The supported reading still requires the hypotheses in §§1 and 3. |
| v2 | Adds the broad, explicitly unverified `Analytic_standard_inputs` bundle (Grauert, Demailly, Cartan). This was not then an audited source application. |
| v3 | Retires that bundle in favor of the read Grauert route; an empty active list here is not a proof without external theorems. |
| v4 | Adds `AN_contraction`, including properness, descent, connectedness, and normal target. |
| v5 | Adds `AN_analytic_local_algebra`, including compact-uniform nilpotence and coherence on nonreduced spaces. |
| v6 | Adds `AN_direct_image_coherence`. |
| v7 | Adds `AN_formal_functions`, with ordinary ideal powers and the inverse-limit conclusion. |
| v8 | Adds `AN_correction_scope`, distinguishing the 1963 repairs from withdrawn fiberwise closedness. |
| v9 | Adds `AN_Stein_B`, explicitly the complex-space version on the target. All six final external propositions are used with matching hypotheses. |
| `M_analytic_counterexample` v1 | Original existential proposition, no annotated Hartogs dependency. |
| v2 | Makes the unverified Demailly Hartogs application explicit. |
| v3 | Retires it: descend the actual fields and prove saturation by `AN_finite_colength_extension`. This is a replacement proof, not a counterexample to Hartogs or to the manuscript. |
| v4 | Adds the exact `AN_normal_depth` proposition needed in that replacement. The empty retired list in this record does not reinstate Hartogs; v3 preserves the replacement history. |
| `M_graded_vanishing` v1–v2 | Same \(n\geq9\), all-\(r\) assertion; v2 records curve duality. The \(n=8\) calculation is an additional prose sharpening, checked above. |
| `AN_analytic_endpoint` v1 | Packages realization, lifting, full tangent sheaf, and invariants; not an independent extra construction. |
| `AN_finite_colength_extension` v1 | Alternative local-algebra proof, checked directly above; no novelty claim. |
| `A_analytic_literature` v1 | Remains an old “unexamined” inventory. Do not turn that stale description into either approval of Demailly or disproof of the active analytic route. |

Graph dependencies match this division. `M_realization` imports `M_jets`; graded vanishing also imports duality; lifting uses both; the full tangent claim additionally uses the finite-colength lemma. `R_M_actual_lifting` and `R_M_analytic_counterexample` are retired literature-bundle/Hartogs routes. Their replacements are `R_AN_actual_lifting` and `R_AN_frame_extension`. The initial endpoint route omitted the additional upper-genus obligation and was replaced by `R_AN_analytic_endpoint_with_genus`, explicitly including `AN_genus_window`. That invariant obligation is not silently discarded here.

## 5. External applications: exact propositions and available passages

These are external mathematical inputs, not results proved by the symbolic certificate. Relative passage paths in this table are under `O/research/literature/`.

| Proposition for attribution | Exact statement used, source/version and locator | Passage actually read and application assessment |
|---|---|---|
| `AN_contraction` | Grauert, *Über Modifikationen und exzeptionelle analytische Mengen* (1962), DOI `10.1007/BF01441136`, §4.8(e), pp.366–367: a compact nowhere-discrete analytic subset in a smooth complex surface is exceptional iff its component intersection matrix is negative definite. §2.4, Definition 3, pp.339–340 supplies a proper contraction, biholomorphism on complements, and function descent; §2.1, p.337 gives connected fibers and normal target for normal source. | `reviewer_grauert_contraction_excerpt.txt` and `grauert_analytic_sources.md`; the user-permitted archived reader transcription of the primary pages was read. The constructed smooth Hausdorff surface and \([-10]\) meet the hypotheses. Source/target letters are translated, not confused. |
| `AN_analytic_local_algebra` | Grauert (1960), DOI `10.1007/BF02684746`, §1.6 Satz 4 and proof, p.15: the nilradical has a uniform nilpotence exponent on a relatively compact subset. §2.1 Definition 3 and (a)–(c), p.16: structure-sheaf coherence and closure of coherent sheaves under kernels, cokernels, images, tensor products and Hom, also on nonreduced complex spaces. | `grauert_1960_local_algebra_pages.txt`, original-page text read. Applied to \((C,\mathcal O_Y/J)\) and its nilradical \(I/J\), not to a presumed reduced fiber. The usual analytic Noetherianity/Weierstrass basis theorem is also used; p.15 explicitly invokes Cartan–Rückert, and the old report gives its elementary Weierstrass outline rather than a new foundational proof. |
| `AN_direct_image_coherence` | Grauert (1960), introduction (I), p.7, and §6.5 Hauptsatz I, p.59: if \(\pi:Y\to X\) is proper holomorphic and \(E\) coherent **on the source**, all \(R^q\pi_*E\) are coherent. No flatness assumption. | `grauert_1960_intro_page.txt`, `grauert_1960_formal_functions_page.txt`, and the raster `reviewer_grauert_1960_formal_functions.png` read. The p.59 source/target printing error is visible in the raster; p.7 is unambiguous. Used for finite stalks and coherent \(\pi_*E\), with actual properness already established. |
| `AN_formal_functions` | Same source, ideals preceding Hauptsatz II and Hauptsatz IIa, p.59, with the 1963 correction: for proper \(\pi\) and coherent \(E\), \(\widehat{(R^q\pi_*E)_x}\simeq\varprojlim_r(R^q\pi_*(E/J^rE))_x\), \(J=\mathfrak m_x\mathcal O_Y\), ordinary powers. | Primary p.59 text and raster plus `reviewer_grauert_formal_functions_excerpt.txt` read. The raster confirms the inverse-limit formula and ordinary-power definitions. This supports precisely the completed-stalk application, not termwise base change or convergence of infinite sections. |
| `AN_correction_scope` | Grauert, *Berichtigung* (1963), DOI `10.1007/BF02684291`, items 1–2, pp.35–36: repair the polyradius estimates and associated inductions; withdraw the asserted closedness of the failure locus for the §7 Satz 2 fiberwise map. | Entire `grauert_1963.txt` read. The correction does not withdraw Hauptsätze I/IIa or add flatness. The repaired proof is an external theorem input; the withdrawn closedness assertion is not used. |
| `AN_Stein_B` | Grauert (1960), §2.3 Satz 3, p.17: positive coherent cohomology vanishes on a holomorphically complete complex **space**, including a singular/nonreduced one. | `grauert_1960_stein_page.txt`, original-page text read. Applies to \(\pi_*E\) on the Stein target \(X\), not to the resolution containing compact \(C\). |
| `AN_curve_duality` | Serre, *Un théorème de dualité* (1955), DOI `10.1007/BF02564268`, §3 no.13 Theorem 4, p.22, and §4 no.16 Theorem 5/corollary, p.24: for a line bundle \(B\) on a compact smooth complex curve, \(H^1(B)^*\simeq H^0(K_CB^{-1})\). | `reviewer_serre_duality_excerpt.txt` read; the unchanged upstream primary-source reading is reused, not represented as a new inspection of the whole PDF. Applied only to line bundles on the supplied compact smooth curve. |
| `AN_normal_depth` | Stacks Project, Tag `031S`, Lemma 10.157.4, archived access 2026-11-05: a Noetherian normal ring is \(R_1\) and \(S_2\); a normal local domain of dimension two has depth at least two. | `analytic_normality_excerpt.txt` read. The algebraic local-ring criterion applies to the analytic local ring because it is Noetherian and normal. It is not being cited as an analytic Hartogs theorem. Tag `0AVB`, also mentioned there, is unnecessary for the direct proof. |

The separate invariant report checks `AN_surface_dualizing` against **arXiv:math/0109221v1**, §2.4, Definition 2.18 and following paragraph, not the more restrictive good-\(\mathbb C^*\)-action theorem. That attribution is needed for the invariant component of `AN_analytic_endpoint`.

The historical Demailly imports were not certified from the then-unavailable text. Their roles in this replacement analytic proof are supplied by the read nilpotence/coherence statements and the proved depth-two extension argument. The parent later obtained the author's June-21-2012 book at its current institutional hostname and checked II.4.22 specifically for the algebraization unit's local zero-set step. That does not retroactively certify all other Demailly locators or make the retired bundle an active premise. Missing historical access is neither a mathematical objection nor the basis for the supported verdict.

## 6. Reused evidence, history, and limits

The following old files were read, without execution or mutation: `analytic_audit/verify.py`, `exact_certificate.json`, `verification_output.json`, `negative_control_cli_output.json`, and all four `jacobian_{contract,payload,output,run}.json` files.

- The historical positive output reports **67** non-integrity checks: 26 symbolic identities, 31 arithmetic checks, and 10 order equalities, plus 117 input-integrity checks. It reports 16 rejecting mutation controls. The separate CLI control changes the middle ideal exponent from \(ar\) to \(r\) and exits 1 with the expected discrepancy.
- The checker uses Python and SymPy. The archived command is `python3 .../verify.py --negative-controls`; exact historical Python/SymPy versions are not recorded and are not invented here. The old Jacobian adapter command names the old `argus-live-update/.venv/bin/python`. This assessment only used the required `argus-latest/.venv/bin/python -B` for read-only JSON extraction; no Argus mathematical module or Jacobian adapter was imported or run.
- The typed historical request is the \(2\times2\) matrix \(\bigl(\begin{smallmatrix}a+p&c+r\\b+q&d+s\end{smallmatrix}\bigr)\) over eight ordered independent variables over \(\mathbb Q\), with denominator one. The response is
  \[
  ad+as-bc-br-cq+dp+ps-qr.
  \]
  The archived request matches the payload; the response declares operation `matrix.symbolic.determinant.compute`, server `0.14.0`, protocol `2025-11-25`, method `SYMPY_BAREISS`, and runtime 31 ms, with a completed zero-exit adapter run. These are historical record checks, not a fresh remote execution or certification of the server. Both checker and server use SymPy, so they are not independent implementation diversity.
- The checker then substitutes weights \(1\) and \(9\), checks determinant/coordinate/Cramer identities and numerical orders, and checks arithmetic consistent with the prose cohomology calculations. It does **not** construct the sheaves, compute their actual cohomology by machine, prove Grauert's theorems, establish separation, or prove the regular-sequence argument. In particular a symbolic commutation identity in \(f,g,h\) is not a machine proof of depth or saturation.
- Some mutation controls reject a different certificate rather than a false mathematical theorem: \(p_g\geq32\) and \(p_g\leq40\) are weaker than the proved window, not false conclusions. Likewise the “premature stabilization” control fixes the sufficient filtration bound 5; it does not prove that earlier stabilization is impossible in a particular neighborhood.
- No replay was warranted: no changed checker dependency or conflicting finite identity was found. The task specifically requires reuse of unchanged reviewed checkers in this situation. No snapshot, old cache, adapter output, or old certificate was rebuilt. No Lean exists in this evidence, and no compilation or kernel claim is made.

The historical receipt
`$WORKSPACE/.argus-campaign-9000048/projects/46e84e6fea35/handoffs/8ba02f2780af/round-0001.json`
was read directly. It has `review.status=done`, and its reason explicitly accepts the bounded analytic implication, simultaneous actual lifting, full derivation-sheaf generation, and the Grauert source applications. This resolves the apparent conflict between `AN_analytic_endpoint`/`M_analytic_counterexample` being marked proved and supporting nodes (`M_realization`, graded vanishing, lifting, the finite-colength lemma, and the genus node) still being open in `PROOF_GRAPH.json`. The ledger also contains old reviewer support records for those supporting arguments. Conversely, submission/pending wording left in prose is not proof that the receipt never happened.

These historical judgments are provenance, not today's proof. The decisive arguments were checked above, and all current unit conclusions remain Engineer submissions to the native Reviewer.

## 7. Failed shortcuts, attribution, and outstanding scope

The manuscript states the analytic result. The old Argus report reproduces and expands its proof, with a source-audited replacement for the bundled literature/Hartogs route. The finite-colength lemma is an alternative standard local-algebra argument, not a demonstrated new theorem. The endpoint repackages the same construction. The sharp \(n=8\) boundary and the genus upper bound/stabilization are additional consequences, not independently established novelty.

The following shortcuts were correctly rejected or avoided:

1. Infinitely many compatible formal jets need not converge; only one finite transition system is realized.
2. Graded vanishing alone is not actual \(H^1(Y,E)\)-vanishing; proper coherence, uniform cofinality, pro-zero maps, formal functions, and Stein-target Leray supply the bridge.
3. Set-theoretic fiber equality does not give \(J=I\), and cofinality does not give termwise cohomology equality.
4. A neighborhood containing compact \(C\) is not Stein; no such hypothesis is used.
5. A punctured frame is not automatically a basis of a specified full module without extension/saturation. The descent and depth-two lemma establish exactly this.
6. The coordinate volume \(t^{-5}dt\wedge dz\) need not be invariant under every allowed change. The illustrative flow \(T=t/(1-t),\,Z=z\) multiplies it by \((1-t)^3\). The correct volume is dual to the **actual global wedge**, \(t^{-5}u^{-1}dt\wedge dz\). This example refutes an overstrong shortcut, not the actual manuscript construction.
7. Failure to retrieve Demailly does not refute the proposition; the replacement proof addresses the required mathematical roles.

**Concrete outstanding obligations:** no further local mathematical obligation was found for the precisely stated conditional implication. Current validation of the nonempty curve/residue input and finite-jet theorem belongs to their indexed units, and current native independent review remains required. The retired Demailly attributions remain uncertified but are not consumed by this proof. Exact \(p_g\), convergence of prescribed infinite jets, algebraization, explicit equations, and novelty are not established by this unit. The invariant unit records precisely which later connecting maps would need to be evaluated for an exact genus; no such strengthening is assumed here.

For the parent's proposition-level external ledger, preserve `AN_contraction`, `AN_analytic_local_algebra`, `AN_direct_image_coherence`, `AN_formal_functions`, `AN_correction_scope`, `AN_Stein_B`, `AN_curve_duality`, and `AN_normal_depth` with the exact source versions and passages in §5, and `AN_surface_dualizing` from the separate invariant assessment. Do not revive the unexamined omnibus bundle as if it were the active proof.

## 8. Parent's bounded current adapter operation

The contributor's historical-evidence inspection above did not run an
adapter. The parent subsequently discovered a small candidate set, inspected
`matrix.symbolic.determinant.compute`'s exact typed contract, and executed
one dimension-two operation through the required isolated Argus adapter.
The exact payload, complete typed response and measured status are
`jacobian_payload.json`, `jacobian_output.json` and `jacobian_run.json`
beside this report. Server `0.14.0`, protocol `2025-11-25`, adapter exit 0,
complete output, no timeout or structured error, runtime 34 ms.

Over \(\mathbb Q(t,A_1,A_2,B_1,B_2)\), the returned sparse polynomial is
\[
\det\begin{pmatrix}t^2A_1&t^2A_2\\tB_1&tB_2\end{pmatrix}
=t^3(A_1B_2-A_2B_1).
\]
Together with the supplied determinant \(A\wedge B=t^2G\), this confirms
the ordinary order-five wedge convention. It does not construct \(G\),
prove it is a unit, lift any field, or certify surrounding geometry. This
is a new, bounded coordinate-interpretation check, not an automatic replay
of the historically reviewed checker.
