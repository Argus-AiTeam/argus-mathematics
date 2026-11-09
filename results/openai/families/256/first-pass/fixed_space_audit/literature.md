# Primary prerequisites and bounded prior-art comparison

## Prerequisites actually used

J. P. May, *A Primer on Spectral Sequences*, author-hosted, undated
manuscript, Theorem 5.2 (pp. 10--11), with Proposition 4.1 and
Corollary 4.2 (p. 7), supplies the multiplicative cohomological Serre
spectral sequence, derivation rule, convergence, and both edge maps.
The connected-base setup is on p. 8. The relevant passage was read
in the primary PDF and is preserved in `literature/May_Serre_excerpt.txt`.
URL: https://www.math.uchicago.edu/~may/MISC/SpecSeqPrimer.pdf .
This unpublished note has no verified stable edition identifier here;
its exact theorem and URL are given rather than an invented DOI.

Allen Hatcher, *Algebraic Topology*, Cambridge, 2002, corrected 2015
reprinting, ISBN 9780521795401, supplies:

* Theorem 3.15, p. 216: the cohomological cross-product is a ring
  isomorphism for CW complexes when the second factor has finitely
  generated free cohomology over the coefficient ring. Our factors
  are compact smooth manifolds of finite CW type and coefficients
  are rational. This applies also to the bidegree injectivity argument.
* Theorem 3.30, p. 241: Poincare duality for a closed oriented manifold.
* Theorem 3.35, p. 245: compact-support duality for an oriented manifold,
  not necessarily compact. The cap-product naturality immediately
  before Theorem 3.30 and in the construction on p. 245 gives
  compatibility with open inclusion and extension by zero.
  Lemma 3.36, p. 246, records the corresponding Mayer--Vietoris
  naturality; no assertion about an embedded incidence image is used.

The three Hatcher excerpt files retain the actual hypotheses.
Primary PDF: https://pi.math.cornell.edu/~hatcher/AT/AT.pdf .
The online source's preface explicitly documents the 2015
renumbering: the original Theorem 3.16 became Theorem 3.15.
The locators above use the corrected reprinting, not the original
numbering. Theorems 3.30 and 3.35 are unaffected by that table.

These are external topological assumptions, not facts earned by the
Lean compiler. The incidence local-degree calculation and the
compact-support disjointness argument are supplied in the report,
rather than attributed to a theorem with different hypotheses.

The independent source-research worker also read the relevant May
and Hatcher statements. The Engineer independently checked the
primary passages used in the proof. Neither reading is being
represented as the mission's required independent Reviewer verdict.
Formal citation attribution remains for that review: the standard
`citation_check attribute` command archives into `research/literature/`,
outside this Engineer mission's explicit writable paths. No files
were written there and the canonical Hatcher citations must not be
called ledger-cleared before the authorized review records them.

## What the bounded comparison established

The source-research worker checked these primary statements:

Gerstenhaber and Rothaus, *The solution of sets of equations in groups*,
PNAS 48 (1962), 1531--1533,
doi:10.1073/pnas.48.9.1531, Theorem 1 on p. 1532:
for a compact connected Lie group \(H\) of rank \(m\), a square word
map \(H^r\to H^r\) with exponent determinant \(d\) has degree \(d^m\).
This is a common-group word-map theorem, not the unequal-size
fixed-subspace bound. Its primitive-cohomology method is prior art.
The finite-group result is Theorem 2; reestablishing it is not this mission.
Primary record: https://pmc.ncbi.nlm.nih.gov/articles/PMC220992/ .

Nicolaescu, *Schubert calculus on the Grassmannian of hermitian
lagrangian spaces*, Advances in Mathematics 224 (2010), 2361--2434,
doi:10.1016/j.aim.2010.02.003, published version:
Theorem 37 (p. 2399) identifies the basic classes by transgression;
Theorem 47 (p. 2410) gives their exterior-product Schubert formula.
The proof of Proposition 49 (p. 2415) identifies
\(\{g:\dim\ker(1-g)\geq k\}\) with the Schubert closure
\(X_{1,2,\ldots,k}\).
Thus the multiplicity loci and exterior-product classes are known.
Remark 40 (p. 2406) explicitly gives the fixed-line incidence
resolution; it does not explicitly identify the present
Grassmannian resolution for every \(l\).
Theorem 47 alone is not being cited for multiplication-primitivity.
Primary published PDF: https://academicweb.nd.edu/~lnicolae/scalc.pdf .

The staged September comparator, `build/sections/degree.tex`,
Lemma `lem:fixed`, lines 12--20, concerns ONE unitary variable of
size \(k\), ONE list, and signed exponent sum exactly \(+1\) or
\(-1\). It does not state the multiple-variable unequal-size theorem.

The search did NOT establish an earlier statement of the entire
October fixed-space theorem. That limited absence is not a proof
of novelty. The incidence ingredients are explicitly known results,
and the formalized determinant facts are classical linear algebra.
The layerwise intersection criterion in the report is proved here,
but no `verified_new` assessment is claimed without independent
significance and novelty review.

The manuscript's Borel 1953 and McCleary 2001 locator choices were
not independently certified in this bounded task. In particular,
the source worker could retrieve a McCleary scan but could not
reliably render the cited theorem. This is an unverified locator,
not a demonstrated false citation. The present proof uses the
verified May statement instead. No `F_` refutation claim is warranted
by an unavailable or unreadable source alone.
