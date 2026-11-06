# Grothendieck, Bourbaki 221: primary-source scope

Source-reading note only; no campaign geometric proof or independent manuscript review.
Accessed 2026-11-05. Quotations normalize line breaks and mathematical typography.

## Identity and accessed version

- Canonical source ID: `numdam:SB_1960-1961__6__249_0`.
- Alexander Grothendieck, *Techniques de construction et théorèmes
  d'existence en géométrie algébrique IV : les schémas de Hilbert*,
  Séminaire Bourbaki, 13e année, 1960/61, Exposé 221, May 1961.
  The NUMDAM scan has printed collection pagination **249–276**.
- Record: https://www.numdam.org/item/SB_1960-1961__6__249_0/
- Actual PDF: https://www.numdam.org/item/SB_1960-1961__6__249_0.pdf
- Saved PDF/text: `grothendieck_bourbaki_221.pdf`,
  `grothendieck_bourbaki_221.txt`. PDF p. 1 is the NUMDAM wrapper;
  printed p. 249 starts on PDF p. 2.
- Theorem 3.1: printed **p. 259**, PDF **p. 12**:
  https://www.numdam.org/item/SB_1960-1961__6__249_0.pdf#page=12
- Theorem 3.2: printed **p. 260**, PDF **p. 13**:
  https://www.numdam.org/item/SB_1960-1961__6__249_0.pdf#page=13

## Hypotheses, functor, and the two different finiteness statements

**Faithful paraphrase of the setup, §3, pp. 258–259, PDF pp. 11–12:**
The base \(S\) is **noetherian**, \(X\) is **projective over \(S\)**, and
\(F\) is coherent on \(X\). The exposition restricts its test objects,
for simplicity, to locally noetherian \(S\)-preschemes \(T\). The Quot
functor parametrizes quotients of \(F_T\) on \(X_T\) that are flat over
\(T\); its fixed-polynomial subfunctor uses coherent flat quotients with
the same specified Hilbert polynomial on every fiber. A relative very
ample \(\mathcal O_X(1)\) is chosen.

**Theorem 3.1, brief exact excerpt:** the representing prescheme is a
“somme d'une suite de \(S\)-schémas projectifs”.

**Faithful paraphrase of 3.1:** The full Quot functor is represented by
the disjoint union of a sequence of projective \(S\)-schemes. The source
explicitly concludes **locally of finite type over \(S\)**, not finite
type for the full union.

**Theorem 3.2, brief exact excerpt:** the fixed-polynomial functor is
“représentable par un \(S\)-préschéma projectif”.

**Faithful paraphrase of 3.2:** For each fixed rational-coefficient
polynomial \(P\), \(\operatorname{Quot}^{P}_{F/X/S}\) is projective over
\(S\), hence finite type over \(S\). Its disjoint union as \(P\) varies
represents the functor of 3.1.

There is **no flatness assumption on \(X/S\) or on \(F/S\)** in these
statements. Flatness is required of the **quotient over the parameter
scheme**. A projective flat finite-presentation family over a noetherian
base is consequently within their scope, but flatness of the original
family is a stronger hypothesis than these theorems demand. No
reducedness assumption on the fibers appears. For an absolute
finite-type-over-\(\mathbb C\) conclusion, the base must itself be
finite type over \(\mathbb C\), as a projective algebraic curve is.

## Presentations of line bundles and countability

**Statement actually present:** At the beginning of printed p. **254**,
PDF p. **7**, immediately before Theorem 2.1, Grothendieck recalls that
a coherent sheaf on projective \(X\) is a quotient of
\(\mathcal O_X(-n)^N\) for sufficiently large \(n,N\). The preceding
page, §2, printed p. 253, PDF p. 6, specifies the relative very ample
line bundle and the Hilbert polynomial.

**Deductions, not extra assertions of Theorems 3.1–3.2:**

1. Apply that presentation statement to the projective scheme fiber
   \(X_s\) and its coherent line bundle \(L\). There exist integers
   \(n\geq0,\ r\geq1\) and a quotient
   \[
   \mathcal O_{X_s}(-n)^{\oplus r}\twoheadrightarrow L .
   \]
   This statement uses the whole projective scheme fiber, even when it
   is nonreduced.
2. With \(F_{n,r}=\mathcal O_X(-n)^{\oplus r}\) and \(P=P_L\), this quotient
   is represented by a point of
   \(\operatorname{Quot}^{P}_{F_{n,r}/X/S}\).
3. There are countably many triples
   \((n,r,P)\in\mathbb N\times\mathbb N_{>0}\times\mathbb Q[t]\).
   Thus countably many projective, finite-type-over-\(S\) Quot schemes
   contain points representing all such line bundles. There is no
   asserted uniform choice of \(n,r,P\).

**Parameter-space qualification:** These schemes parametrize quotient
presentations, not line bundles without presentations; they can also
contain noninvertible coherent quotients. The named theorems do not
themselves describe the invertible-quotient locus. If the parent needs
universal line bundles over the entire chosen parameter spaces, a
separate local-freeness/openness argument is needed to restrict those
Quot spaces. No finite-type assertion for the full Picard functor or for
the unrestricted Quot is being attributed to 3.1–3.2.

## Linked primary erratum checked

The NUMDAM record links Grothendieck's *Erratum à l'exposé n°221*,
Séminaire Bourbaki 7 (1962), printed **p. 302**, PDF p. 2:

- Canonical source ID: `numdam:SB_1961-1962__7__302_1`.
- Record: https://www.numdam.org/item/SB_1961-1962__7__302_1/
- PDF: https://www.numdam.org/item/SB_1961-1962__7__302_1.pdf
- Saved: `grothendieck_bourbaki_221_erratum.pdf`,
  `grothendieck_bourbaki_221_erratum.txt`.

**Faithful paraphrase:** Its §6 corrects the statement of 2.1 from a
necessary condition to a necessary-and-sufficient condition, and
corrects notation/inequalities in the later proof, among other items.
It does **not** replace or change the hypotheses or conclusions of
3.1–3.2. The preceding presentation statement and the two quoted
existence statements were checked in the scan, not inferred from OCR.

Saved visual checks: `grothendieck_bourbaki_221_p6.png`,
`grothendieck_bourbaki_221_p7.png`,
`grothendieck_bourbaki_221_p12.png`,
`grothendieck_bourbaki_221_p13.png`, and
`grothendieck_bourbaki_221_erratum_p2.png`.

No source-access limitation: the requested NUMDAM scan and its linked
primary erratum were obtained and read.
