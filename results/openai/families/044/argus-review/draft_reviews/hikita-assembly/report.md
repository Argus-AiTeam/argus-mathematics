# ENGINEER source-fidelity assessment: hikita-assembly

Assessment: the final theorem follows formally and coefficientwise from
the two distinct source comparisons, if their upstream inputs hold.
This is not an independent Argus verification of the full theorem or
the entire manuscript.

## Exact historical and manuscript statement

C_HIKITA@1 asserts: for arbitrary finite quiver gauge data, every commuting
flavor torus, and every regular stability, the two coefficient maps are
surjective with equal kernel, yielding the coefficient-compatible
equivariant cohomological Hikita isomorphism.

Precisely, let
\[
G=\prod_iGL(V_i),\quad
N=\bigoplus_{a:i\to j}\operatorname{Hom}(V_i,V_j)
 \oplus\bigoplus_i\operatorname{Hom}(V_i,W_i),
\quad
R=H^*_{G\times F}(\mathrm{pt};\mathbb C).
\]
The finite quiver may have loops and multiple arrows; \(F\) is an
arbitrary linear algebraic torus commuting with \(G\). A regular
character \(\nu\) means that the semistable locus in
\(\mu^{-1}(0)\) equals the stable locus and has free \(G\)-action.
Put \(X=\mu^{-1}(0)^{\nu\text{-stable}}/G\), and use the commutative,
unrotated flavored BFN Coulomb algebra \(A_F\). The character defines
a topological-torus cocharacter, with scheme quotient
\[
\mathbb C[Y_{\mathfrak f}^{\nu}]
 =A_F/J_\nu,\qquad J_\nu=\langle(A_F)_m:m\ne0\rangle.
\]
The maps in question are the ordinary equivariant Kirwan map
\(\phi_H:R\to H_F^*(X)\) and the BFN coefficient map followed by
quotient, \(\phi_C:R\to A_F/J_\nu\). The theorem asserts
surjectivity of both, \(\ker\phi_H=\ker\phi_C\), and a canonical graded
\(R\)-algebra isomorphism
\[
H_F^*(X;\mathbb C)\simeq\mathbb C[Y_{\mathfrak f}^{\nu}].
\]
The gradings are ordinary cohomological degree and BFN homological
degree. Quotients retain nilpotents. The empty case is the zero ring;
all zero gauge ranks give \(H_F^*(\mathrm{pt})\).
No assertion for arbitrary reductive gauge groups, quantized Hikita,
or a \(K\)-theoretic version is part of this statement.

## Original source and provenance

OpenAI, *The equivariant cohomological Hikita conjecture for arbitrary
quivers*, September 24, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`.
Source root:
`openai-math/preprints/The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026`.
Exact locators:

- `build/sections/introduction.tex`: `thm:main`,
  `eq:gauge-data`, `eq:higgs-definition`, `eq:nu-quotient`,
  `eq:coefficient-ring`, `eq:intro-two-ideals`;
- `build/main.tex`: subsection "Completion of the proof",
  proof of `thm:main`;
- `build/sections/deformations.tex`: `thm:full-torus`;
- `build/sections/cocharacters.tex`: `prop:cocharacter-fixed`.

The manuscript reference manifest is
`campaigns/9100044/MANUSCRIPTS.json`.
Read-only comparison matched all **ten** listed TeX SHA-256 values
(147142 bytes). In particular main and introduction match
`24ae5fccfeb81e97c804647ab5aa4494bd8e3c3d786d3153d53d1260075279bc`
and
`e33c1de4f8e5388ddffa044b094467ceb9c46d49be7937d834fe76f883cbb7ca`.
The **nine** existing `9000044/` digest entries in the supplied preserved
snapshot manifest also match (125357 bytes); the other inventory entries
have no digest in that manifest. The old source subtree is a symlink to
the versioned source and gives ten byte-equal accesses, not an
independently frozen source copy. No Git or snapshot rebuild was used.
The full digest table is in bfn-laurent-generation/report.md.

## Old version disposition and actual dependency boundary

The old ledger has one C_HIKITA version, no formal statement, and no
independent proof certificate. The old graph leaves it open, depending
on C_FULL_TORUS and C_COCHAR. The strongest historical cut application
still retains INPUT_LAURENT. The finite checker and Lean arithmetic
core cover a local part of the cut argument, not every node in this
assembly.

The source separates two logically different ideal comparisons:

1. In \(R\), equality of the coefficient kernels for
   \(B_F=A_F/J_{\mathrm{top}}\) and \(H_F^*(X)\).
2. In \(A_F\), equality
   \(J_\nu=J_{\mathrm{top}}\), where
   \(J_{\mathrm{top}}=\langle A_F^{(d)}:d\ne0\rangle\).

The second does not follow merely from matching dimensions of the
first coefficient quotient. It is independently supplied by the
root/complementary-monopole argument, including characters on dimension
hyperplanes. In particular, coefficient surjectivity onto the
cocharacter quotient is not assumed in order to prove that argument.

## Decisive final argument

The natural map
\[
\beta:A_F/J_\nu\longrightarrow A_F/J_{\mathrm{top}}=B_F
\]
exists since a nonzero \(\nu\)-weight has nonzero full charge.
The cocharacter comparison says this map is an isomorphism of actual
quotients, preserving the original coefficient map and gradings.
The full-torus theorem supplies the specified coefficient-compatible
isomorphism
\[
\alpha:B_F\longrightarrow H_F^*(X).
\]
The completed source proof explicitly has
\[
(\alpha\circ\beta)\circ\phi_C=\phi_H.
\]
Since \(\alpha\circ\beta\) is an isomorphism,
\(\ker\phi_C=\ker\phi_H\). Surjectivity of the coefficient map to
\(B_F\), together with invertibility of \(\beta\), gives surjectivity
of \(\phi_C\); Kirwan gives surjectivity of \(\phi_H\).
The inverse of \(\alpha\circ\beta\) is therefore the desired canonical
\(R\)-algebra isomorphism. Its uniqueness follows from surjectivity
of \(\phi_H\).

This formal assembly is correct if both input comparisons hold under
the same coefficient and grading conventions. It neither passes to
radicals nor chooses an unspecified abstract ring isomorphism. Empty
quotients and nilpotents are preserved automatically by these full
ideal statements.

## Supported scope and concrete unresolved inputs

The final algebraic implication is supported. It is conditional on all
the following, not just the parent's abstract symbol calculation:

- BFN/minuscule and unlocalized Laurent interfaces:
  coefficient preservation, full charges, Euler conventions, and the
  charge-zero grading needed to apply the cut bound.
- Kernel inclusion: finite correspondence factorization and the
  \(R\)-linear stable-pair vanishing-cycle test, plus Kirwan
  surjectivity.
- Cut and counting comparison: the symbol map for the geometric
  algebra, invariant cut recurrence, and determinant moment-level
  identification with the ordinary Hausel polynomial.
- Deformation: parameter-preserving flavor base change, prequotient
  subgroup localization, regular-stability Betti comparison, and
  homogeneous descent for full coefficient ideals.
- Cocharacter comparison: polynomial Hall-to-Coulomb specialization,
  root-supported finite identities, moment blocks, and the
  ineffective-scalar/complement argument under regular freeness.

The eight companion source-facing assessments explain these interfaces
substantively and retain their conditional boundaries. In particular
the polynomial degeneration for arbitrary repeated-slot strings, the
BFN conventions, and the finite equivariant geometry are not certified
by the old Lean proof.

The theorem-level external passages obtained during this bounded work
were Weekes arXiv:1903.07734v2, Proposition 3.1, Remarks 3.3-3.4,
Lemma 2.10 and Section 1.6.1; RRT arXiv:2207.11861v2, Lemma 4.2,
Corollary 4.3 and Section 4.4; Hausel arXiv:math/0511163v2,
Theorem 5, Equation (9); Jindal--Negut arXiv:2607.23544v1,
the polynomial generation/BPS package at the locators in the Hall/root
reports; and Tsymbaliuk arXiv:2207.02804v2, Theorem 5.7,
(93)/(96). None of the specifically requested Weekes/RRT passages
was missing. The BFN, Brion, McGerty--Nevins, and foundational
equivariant sheaf/GIT theorems were not separately audited against
their full primary texts. Their uses are recorded as conditional
inputs, not as findings from inaccessible-source failures.

Classification: source-only conditional main-theorem assembly, not an
original independently certified Argus proof. Originality of the
manuscript's particular comparison arguments is unverified.
No contradiction in C_HIKITA@1 is established here, and conditional
support is not acceptance of the entire manuscript or completion of
the old-draft family review.

Native Host-invoked independent review of the coverage index and all
substantive unit assessments remains required and pending. There is
no engineer self-acceptance.
