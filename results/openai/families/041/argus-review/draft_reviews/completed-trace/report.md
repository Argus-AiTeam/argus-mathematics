# Completed rational field-trace route

**Unit:** `completed-trace`; `C_COMPLETION@1` through `C_COMPLETION@4`.  
**Assessment:** `supported_scope` for the retained conditional clearing implication. This is an **alternative proof of the same clearing consequence**, not another theorem. Exploratory Engineer assessment only; native independent review remains `required_pending`. No novelty is asserted.

## Claim, complete hypotheses, and provenance

The conclusion is
\[
 \psi_h(gR_b)\not\subset\mathfrak m_{R_b},
\]
equivalently that some \(t\in R_b\), regular near the closed point \(b\), has \(\psi_h(gt)(b)\ne0\).

The retained hypotheses are: \(k\) is algebraically closed of characteristic \(p>0\); \(R\) is a normal integral finite-type \(k\)-algebra finite over \(k[u_1,\ldots,u_n]\); a nonzero \(\Delta_\mu\) gives a finite étale free locus of rank \(e_\mu<p\); \(b\) is a closed, hence \(k\)-rational, chart point; \(g\ne0\) and \(t_j\) are regular at \(b\); \(s\in K_0=\operatorname{Frac}R\) satisfies
\[
 s=\sum_jD_j(gt_js),\quad
 D_j=\sum_\alpha c_{j,\alpha}(u)\partial_u^\alpha,
\]
with \(c_{j,\alpha}\in k[u]_{\mu(b)}\) and retained finite ordinary order \(o_g<p\); and a regular Frobenius-linear map \(\psi_h:F_*R_b\to R_b\) has rational extension \(\psi_h(r)=C_u(sr)\) and \(\psi_h(1)=\delta\in k^\times\). The generic geometric and duality construction of these last identities is assessed in the two upstream units. **No hypothesis \(s\in R_b\) or \(s\in\widehat{R_b}\) is made.**

The old evidence is **only** `9000041/research/cartier-clearing/proof.md:208–273`. The manuscript is `build/source/sections/05-base-change.tex:817–920`, with the necessary input statements at `458–495`, `709–815`. Its reference root is `openai-math/preprints/Projective-Space-Bases-of-Lagrangian-Fibrations-September-23-2026`, assigned revision `4eaee87548250b2682affda7d05d947c05554bae` by campaign `9100041/MANUSCRIPTS.json`; the parent already checked the thirteen TeX hashes. The old staged root is a symlink to this source, **not an immutable historical manuscript snapshot**.

## 1. Completed domain and branch degree

Put \(v_i=u_i-u_i(\mu(b))\), \(A=k[[v_1,\ldots,v_n]]\), \(K=\operatorname{Frac}A\), and \(L=\widehat{R_b}\). Archived Stacks **0BNH**, Lemma 10.97.8, decomposes \(R\otimes_{k[u]}A\) into the completed local rings over \(\mu(b)\). **07QS**, Proposition 15.53.3 and Lemmas 15.53.2, 15.53.6, make \(R_b\) excellent and its completion normal. A normal local ring is a domain, so \(L\) is a complete normal local domain. Completion is flat, and the finite torsion-free base module remains torsion-free; its nonzero factors embed the base \(A\). Faithful local completion also embeds \(K_0\) in \(K'=\operatorname{Frac}L\).

After tensoring with \(K\), the nonzero polynomial \(\Delta_\mu\) is invertible. The entire completed algebra is therefore finite étale of dimension \(e_\mu\); each domain factor becomes a finite separable field. Thus
\[
 0<d=[K':K]\le e_\mu<p.
\]
This does **not** assume freeness of \(L\) at \(b\), or that completion at a ramified point is étale.

## 2. Extending the regular map and the failed containment

Frobenius on a finite-type algebra over perfect \(k\) is finite. **0BNH**, Lemma 10.97.1(3), applies to this finite twisted module. Its module-adic filtration corresponds, on the input ring, to powers of the Frobenius-power ideal; these and ordinary maximal-ideal powers are cofinal because the maximal ideal is finitely generated and has the same radical as its Frobenius-power ideal. Consequently
\[
 F_*R_b\otimes_{R_b}L\xrightarrow{\sim}F_*L,\qquad
 (F_*r)\otimes x\longmapsto F_*(rx^p).
\]
The factor \(x^p\), rather than \(x\), is essential for twisted linearity. Exact finite completion extends the map to \(L\), and a failed containment extends to \(\psi_h(gL)\subset\mathfrak m_L\). Localization then gives a \(K'\)-linear map on the **twisted** module \(F_*K'\). The constant value at one remains \(\delta\).

## 3. The common \(p\)-basis really survives

Every series in \(A\) decomposes uniquely as \(\sum_\alpha v^\alpha a_\alpha^p\), \(0\le\alpha_i<p\), using perfection of its coefficients. For a fraction \(f/q\), decompose \(fq^{p-1}\) and divide its coefficients by \(q\). This gives the same unique basis over \(K^p\) in \(K\), not merely a polynomial calculation.

For any finite separable extension \(E/F\), the extension \(E/FE^p\) is both separable and purely inseparable, hence trivial. Frobenius gives \([E^p:F^p]=[E:F]\), so the degree tower gives \([E:E^p]=[F:F^p]\). A \(p\)-basis monomial basis of \(F\) therefore spans, and by this dimension equality is independent, over \(E^p\). Apply this separately to \(K'/K\) and to \(K_0/k(u)\). The possibly nonalgebraic extension \(K_0\to K'\) is **not** being called a finite separable extension.

Translation by constants of perfect \(k\) preserves \(du=dv\) and Cartier: expanding \(v^\alpha=(u-a)^\alpha\), the top residue \((p-1)\mathbf1\) appears exactly when \(\alpha\) is that residue, with coefficient one. Thus the \(u\)- and \(v\)-formulas agree on \(K_0\). The completed map and \(x\mapsto C_{K'}(sx)\) are \(K'\)-linear on \(F_*K'\) and agree on its basis \(F_*v^\alpha\subset F_*K_0\), hence agree everywhere. This transports the rational formula without making \(s\) regular. Coordinate derivations on \(K\) extend uniquely through \(K'/K\), and restrict to the original derivations on \(K_0\), by its separability over \(k(u)\).

## 4. Maximal-ideal trace, including ramification

Let \(T=\operatorname{Tr}_{K'/K}\). Integrality gives \(T(L)\subset A\), since \(A\) is normal. More importantly,
\[
 T(\mathfrak m_L)\subset\mathfrak m_A.
\]
Take a finite Galois normal closure of \(K'/K\), and its integral closure \(N\) over \(A\). Excellence/Nagata (**07QS**, Lemma 15.53.5) makes \(N\) finite. It is a domain, and complete \(A\) is henselian (**04GE**, Lemma 10.153.9); the finite-product criterion in Lemma 10.153.3(10) therefore makes \(N\) local. Every embedding of \(L\) into \(N\) has maximal-ideal contraction \(\mathfrak m_L\). All conjugates of \(x\in\mathfrak m_L\) belong to the unique maximal ideal of \(N\), so their sum belongs there; its intersection with \(A\) is \(\mathfrak m_A\). Ramification does not invalidate this reasoning. Neither tameness nor \(d<p\) was used here.

## 5. Rational Cartier/trace compatibility and coefficient detection

In the common basis write \(x=\sum_\alpha v^\alpha c_\alpha^p\). Summing separable embeddings gives \(T(c^p)=T(c)^p\), and hence
\[
 T(x)=\sum_\alpha v^\alpha T(c_\alpha)^p,\qquad
 T(C_{K'}x)=C_K(Tx).
\]
These equalities hold for **rational** coefficients. Derivations commute with \(T\): their unique extensions to the normal closure commute with each embedding. Regular coefficients lie in the base \(A\subset K\), so they also pass through \(T\).

Assume the failed containment. For every base monomial \(a=v^\beta\) and every \(j\), regularity of \(gat_j\) gives \(T(\psi_h(gat_j))\in\mathfrak m_A\). Set \(z_j=T(gt_js)\in K\). The transported formula now implies \(C_K(az_j)\in\mathfrak m_A\). Write \(z_j=\sum_\alpha v^\alpha c_{j,\alpha}^p\). Multiplication by \(v^{(p-1)\mathbf1-\alpha}\) followed by Cartier extracts exactly \(c_{j,\alpha}\): each exponent lies between \(0\) and \(2p-2\), and no other exponent has the top residue. Thus every coefficient is in \(\mathfrak m_A\), proving
\[
 z_j\in\mathfrak m_A^{[p]}=(v_1^p,\ldots,v_n^p)A.
\]
Regularity of these **traced products** is a conclusion, not an assumption about \(s\).

## 6. Contradiction and exact role of the bounds

The base coefficient functions embed in \(A\) because their denominators are units at \(\mu(b)\). Ordinary coordinate derivatives preserve \(A\), annihilate \(v_i^p\), and therefore preserve \(\mathfrak m_A^{[p]}\). Multiplication by the regular coefficients preserves the ideal too. Applying \(T\) to the scalar identity forces \(T(s)=\sum_jD_jz_j\in\mathfrak m_A^{[p]}\). Cartier preserves \(A\), and \(C_K(v_i^pa)=v_iC_K(a)\); thus \(C_K(Ts)\in\mathfrak m_A\).

But Cartier/trace compatibility and the normalization give
\[
 C_K(Ts)=T(C_{K'}s)=T(\delta)=d\delta,
\]
a unit since \(0<d<p\). This contradiction proves the clearing consequence.

The degree bound is used **at this final unit step**, not for \(p\)-basis persistence, maximal-ideal trace, or regularity. This route actually only needs \(p\nmid d\). The order bound ensures the retained low-order ordinary-operator setting; ideal preservation itself works for ordinary derivative words of any length. A \(p\)-th Hasse derivative is not interchangeable with an ordinary word.

## Attribution and remaining scope

The Stacks statements and their noetherian, finite, normal-formal-fiber, and henselian hypotheses were checked in the full archived texts and excerpts, retrieved **2026-11-05**; no fixed Stacks repository revision is recorded. The inherited records `448f3d995ff7d6ec8076a304c7572534.json`, `649c94d92973c4481922d63091cb9d53.json`, and `867bece5d95a24e1d0c07582f53d964f.json` remain unchanged. They support known completion/henselian propositions, not the whole geometric application. The common-basis, rational-trace, and extraction calculations above verify the Argus instantiation separately.

There is no internal gap under these hypotheses. Independent chart construction, a common model retaining the scalar identity and regular coefficient data, and sufficiently large good reductions with \(\delta\ne0\) remain input-certification obligations of the broader application. No regularity of \(s\), smoothness of \(L\), extra theorem, global manuscript consequence, formal-algebra replay, or independent acceptance is claimed.
