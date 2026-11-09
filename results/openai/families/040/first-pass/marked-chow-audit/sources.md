# Geometric inputs and source boundaries

These are mathematical inputs, not conclusions of the exact-arithmetic replay.
All uses below are for a smooth connected projective complex surface and
rational Chow groups. The manuscript itself is the staged September 24, 2026
version of *Bloch's conjecture for surfaces with p_g=0*.

## Consecutive nesting, not numerical universality

Ellingsrud--Goettsche--Lehn, arXiv:math/9904095v1, Section 1, the universal
sequence and Lemma 1.1:
https://arxiv.org/html/math/9904095v1#S1

The inspected source uses quotient projectivization and states

> \(\sigma_*(\ell^i)=(-1)^i c_i(\mathcal O_n)=(-1)^i c_i(-I_n)\).

Its universal ideal sequence is
\(0\to\psi_S^*I_{n+1}\to\phi_S^*I_n\to j_*\mathcal L\to0\).
Section 1 supplies the length-one locally free resolution, regular
zero-locus presentation, irreducibility, and records smoothness of the
consecutive nested scheme with attribution to earlier work. Smoothness is
an accepted geometric theorem here, not something established by Python.
The generic degree of \(\psi\) is \(n+1\), by forgetting a distinguished
point on the distinct-point locus.

Section 3, Proposition 3.1, and Section 4, Theorems 4.1--4.2, concern
numerical integrals. They are NOT assumed to imply an identity with
unintegrated outputs. The proof in REPORT.md instead uses the Section 1
sequence with its minus sign and proves the retained-output induction.
The inherited Wiki's numerical-universality-only shortcut remains excluded.

## Intersection theory

The following standard theorems are used with their usual rational Chow
interpretation:

* Projective bundle formula, Stacks Project Tag 02TX, Lemma 42.36.2,
  and Tag 02U6, Lemma 42.38.2 (the quotient-line Chern relation).
  Both primary passages were opened:
  https://stacks.math.columbia.edu/tag/02TX and
  https://stacks.math.columbia.edu/tag/02U6.
* Grothendieck--Riemann--Roch for a proper morphism between smooth
  varieties, including regular embeddings and perfect complexes.
  Stacks Tag 02UO was opened, but its displayed statement has additional
  local-freeness hypotheses and does NOT by itself supply this full
  input. The full smooth-variety statement and its proof were then
  inspected in Ravi Vakil, Math 245 notes, Class 19, November 24, 2004,
  Section 2, printed page 3:
  https://math.stanford.edu/~vakil/245/245class19.pdf.

  > Suppose \(f:X\to Y\) is a proper morphism of smooth varieties.
  > Then for any \(\alpha\in K(X)\),
  > \(\operatorname{ch}(f_*\alpha)\operatorname{td}(TY)
  > =f_*(\operatorname{ch}(\alpha)\operatorname{td}(TX))\).

  `vakil19.pdf` and `vakil19.txt` retain the inspected passage.
  Smooth projective schemes have finite locally free resolutions,
  so additivity gives the perfect-complex form used here.
* Rational Chow projection formula, flat base change, and the regular
  embedding self-intersection formula. The excess and self-intersection
  statement with its hypotheses was inspected in Vakil, Class 17,
  November 17, 2004, Section 1.2, printed page 4:
  https://math.stanford.edu/~vakil/245/245class17.pdf.
  For a regular embedding \(i\) of codimension \(d\) with normal
  bundle \(N\), the displayed specialization is
  \(i^*i_*\alpha=c_d(N)\cap\alpha\).
  `vakil17.pdf` and `vakil17.txt` retain this source. These notes
  supply actual statements rather than the inaccurate web-search
  summary that pointed to the unrelated Stacks Tag 0E5E.

The cited versioned identifiers will be entered only for the precise
propositions actually inspected. A source attribution is not an
independent Reviewer judgement.
The dated lecture notes have no canonical registry identifier entered
here: their source URLs, dates, and locators are given in the prose
source fields, rather than inventing a DOI. EGL's versioned arXiv
attribution still needs an independent reader in the official citation
ledger. The Engineer cannot support its own citation.

The official `citation_check attribute` command archives excerpts under
`research/literature/`, which is outside this mission's writable paths.
It has not been run with an alternative root or a fabricated identity.
No citation-clearance or independent-acceptance status is claimed.

## Explicit non-inputs

No Chow--Kunneth decomposition, independence of diagonal classes,
vanishing of odd cohomology, effectivity of T or H, or reconstruction of
Chow classes from numerical integrals is assumed. The derived determinant
obstruction theory, the auxiliary cosection multiplicities, and the
positivity arguments are outside this mission's verification.

## Prior result comparison and novelty

The campaign began with an untested objective claim and an otherwise
empty proof graph. An inherited Wiki report from campaign 9000053
describes a similar retained-output recursion for a different manuscript
and a scalar-transfer problem; its Host review is not evidence for the
present manuscript. It is useful prior art, not a result re-certified
here. No verified-new or publishable-novelty claim is made by reproducing
EGL's numerical universality.
