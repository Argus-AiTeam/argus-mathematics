# Saito: primary-source scope

Source-reading note only; no campaign geometric proof or independent manuscript review.
Accessed 2026-11-05. Quotations below normalize line breaks and mathematical typography.

## Identity and accessed version

- Canonical source ID: `doi:10.2977/PRIMS/1195173930`.
- Morihiko Saito, *Modules de Hodge Polarisables*, Publ. RIMS **24**
  (1988), no. 6, 849–995.
- DOI: https://doi.org/10.2977/PRIMS/1195173930
- Publisher record: https://ems.press/journals/prims/articles/3445
- Actual downloaded journal scan:
  https://ems.press/content/serial-article-files/42460?nt=1
- Saved PDF: `saito_1988_modules_de_hodge_polarisables.pdf`.
- Search-aid extraction: `saito_1988_modules_de_hodge_polarisables.txt`.
  The scan, not its imperfect OCR, controls the transcriptions.
- Theorem 5.3.1: printed p. 977, PDF p. 129:
  https://ems.press/content/serial-article-files/42460?nt=1#page=129

## Theorem 5.3.1 and minimal definitions

**Brief exact excerpt, hypothesis:** “Soit \(f:X\to Y\) un morphisme
projectif de variétés complexes lisses”.

**Faithful paraphrase of the remainder of the statement, p. 977:** Choose
\(l\), the first Chern class of an \(f\)-relatively ample invertible sheaf.
The input is \((M,F,K)\in MH_Z(X,k,n)\), with a polarization \(S\).
The filtered direct image is strict; its cohomology objects belong to
\(MH(Y,k,n+i)\). The theorem also gives relative hard Lefschetz
\(l^i:\mathcal H^{-i}f_*(M,F,K)\simeq
\mathcal H^if_*(M,F,K)(i)\), for \(i\geq0\), and polarizations on the
primitive parts. The index inequality was checked against the scan.

**Faithful paraphrases of the relevant conventions:**

- (2.0.1), printed pp. 875–876, PDF pp. 27–28: the smooth complex
  varieties throughout are paracompact and of pure dimension.
- 5.1.1, p. 952, PDF p. 104: \(k\) is a subfield of \(\mathbb R\);
  \(k=\mathbb Q\) is permitted, and \(K\) is the underlying \(k\)-perverse
  sheaf.
- 5.1.3, p. 953, PDF p. 105, defines strict support and the locally finite
  strict-support decomposition. Formula (5.1.3.2) identifies the rational
  direct-image cohomology with **perverse**, not ordinary, cohomology.
- 5.1.5–5.1.6, pp. 955–956, PDF pp. 107–108: the decomposition is indexed
  by irreducible closed analytic supports. Lemma 5.1.10, pp. 957–958,
  PDF pp. 109–110, identifies the underlying sheaf on each strict support
  with an intersection complex \(IC_Z(L)\).
- 5.4.1 and Theorem 5.4.3, pp. 988–989, PDF pp. 140–141: a polarized
  variation of weight \(n-\dim X\) produces a polarized Hodge module of
  weight \(n\), with rational complex \(L[\dim X]\). In particular the
  constant weight-zero rational variation gives the constant Hodge module
  with underlying complex \(\mathbb Q_X[\dim X]\).
- Remark 5.3.12, p. 988, PDF p. 140, extends the formulation to singular
  spaces by local smooth embeddings. This extension is unnecessary when
  the target has already been replaced by a smooth ambient chart.

## Decomposition, locality, and the full-support qualification

**Statement actually present in the source:** Introduction, Corollary 3,
p. 857, PDF p. 9, formulas (0.11)–(0.12), explicitly gives the derived
direct-sum decomposition and the decomposition of its perverse cohomology
into intersection complexes for projective morphisms of irreducible
analytic varieties and geometric variations extendable relative to the
source. The constant variation on a smooth source is within this case.
This is not merely a secondary interpretation of 5.3.1.

**Application bookkeeping / deduction, not additional wording of 5.3.1:**
For a projective map from a smooth pure-dimensional analytic manifold to
a smooth ambient chart, the preceding results apply to
\(Rf_*\mathbb Q_X[\dim X]\). No algebraic structure on the spaces and no
global compactness or global Kähler hypothesis on \(X\) occurs in the
stated hypotheses. Projectivity of the actual map remains essential to
this citation; it must not be silently weakened to arbitrary properness.

“Full support” means the desired irreducible image \(Z\), not automatically
the whole smooth ambient chart. The literal theorem supplies \(IC_Z(L)\)
terms; identification of a particular \(L\) with \(\mathbb Q\) uses the
generic behavior of the map. In particular, if the application has a
projective resolution that is an isomorphism over a dense smooth open
of \(Z\), the decomposition identifies \(IC_Z(\mathbb Q)\) as the
full-support summand of perverse degree zero in
\(Rf_*\mathbb Q_X[\dim X]\). This last identification is a deduction from
(0.11)–(0.12), not a separately stated clause of Theorem 5.3.1. For a map
of positive relative dimension the local system and perverse degree need
separate identification.

**Further scope warning:** Immediately after (0.12), Saito explicitly
mentions semisimplicity of the local systems **in the algebraic case**.
Do not attribute unrestricted semisimplicity of all the analytic local
systems to this passage.

## Saved visual checks

- `saito_1988_modules_de_hodge_polarisables_p129.png` — 5.3.1, p. 977.
- `saito_1988_modules_de_hodge_polarisables_p140.png` — 5.3.12 and 5.4.1.
- `saito_1988_modules_de_hodge_polarisables_p141.png` — 5.4.3, p. 989.

No source-access limitation: the original journal scan was obtained and read.
