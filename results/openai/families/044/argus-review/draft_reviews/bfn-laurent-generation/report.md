# ENGINEER source-fidelity assessment: bfn-laurent-generation

Assessment: known minuscule generation is supported by theorem-level primary
source reading. The manuscript's unlocalized Laurent identification has a
substantive, conditionally supported proof; it is not supplied by an abstract
generation certificate.

## Claims, hypotheses, and historical disposition

The assigned versions are C_MINUSCULE@1, C_MINUSCULE@2, C_COEFF_SURJ@1,
and C_LAURENT@1. Their exact historical assertions are, respectively:

1. Coefficient-preserving BFN abelianization and generation by dressed positive
   and negative subset coweights for arbitrary quivers. Version 2 has the same
   statement but adds the external input GEN_WEEKES.
2. The coefficient ring \(P^{\mathcal W}\) surjects onto \(B_0\), because every
   nontrivial subset-minuscule generator has nonzero topological charge.
3. After deleting one chosen loop at each positive-rank vertex, the no-flavor
   Coulomb algebra identifies coefficientwise and chargewise with
   \[
   L^{\mathcal W},\qquad
   L=\bigoplus_{\lambda\in\mathbb Z^\Omega}P r_\lambda,\quad
   r_\lambda=e^\lambda
      \prod_{\beta\in\mathcal B'}\beta^{(-\langle\beta,\lambda\rangle)_+}.
   \]
   No polynomial weight is inverted in this equality.

Here \(Q\) is finite, \(G=\prod_i GL(V_i)\), the matter representation is
the arrow representation plus \(\bigoplus_i\operatorname{Hom}(V_i,W_i)\),
and coefficients are complex. A positive subset coweight has entries in
\(\{0,1\}\) at all vertices simultaneously; a negative one has entries in
\(\{0,-1\}\). It need not be a single-slot coweight. Its charge is
\([\lambda]_i=\sum_a\lambda_{ia}\). For the Laurent assertion, flavor is
trivial and a loop must be available at every vertex with \(v_i>0\);
\(\mathcal B'\) uses the quiver after deleting exactly those chosen loops.
Remaining loops and multiple arrows are retained. The grading needed in the
cut application is BFN degree on charge zero, equal to twice polynomial
degree of the Laurent coefficient.

The old graph left these claims open. The old ledger's version-matched
judgment on C_LAURENT was explicitly `inconclusive`. C_MINUSCULE@2 records
known generation, not an accepted proof of the larger interface.
C_CUT_SYMBOL@4 still retains INPUT_LAURENT. The parent's abstract
coefficient-generation argument does not turn that geometric input into a
formal BFN identification.

## Manuscript attribution and measured provenance

The manuscript is OpenAI, *The equivariant cohomological Hikita conjecture
for arbitrary quivers*, September 24, 2026, revision
`4eaee87548250b2682affda7d05d947c05554bae`. Its reference manifest is
`campaigns/9100044/MANUSCRIPTS.json`.
Its source root is
`openai-math/preprints/The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026`.

The decisive locators, relative to that root, are:

- `build/sections/preliminaries.tex`: `prop:minuscule`, `eq:minuscule`,
  and the following coefficient-surjectivity paragraph;
- `build/sections/laurent.tex`: `prop:laurent-model`, `eq:laurent-model`,
  and `eq:laurent-product`.

Read-only SHA-256 comparison found **10/10** matching manuscript TeX entries,
147142 bytes total. The manuscript manifest contains ten entries, not nine:

| Relative source path | Matching SHA-256 |
| --- | --- |
| `build/figures/proof-route.tex` | `5bef49ba06634c22ff56f82b12f4677223174acabbfbe5132e4f51cd629b97ad` |
| `build/main.tex` | `24ae5fccfeb81e97c804647ab5aa4494bd8e3c3d786d3153d53d1260075279bc` |
| `build/sections/cocharacters.tex` | `ce58a31d9dae7a3f30fae450a816d82042b57362f37e0ef253b886eb87822f3a` |
| `build/sections/correspondences.tex` | `c70667136a5c29ce2f6eac366e1679173cae34b36f3edd9d122b6315c467e4e8` |
| `build/sections/counting.tex` | `10859f6ab290811c40bef1992379cda73aff7e7618b0d711dc8e5dfe50bdc8a9` |
| `build/sections/deformations.tex` | `8aa324440a174355a94e3cee448b338223befef3c32d10ca3e4cb500161db4bb` |
| `build/sections/introduction.tex` | `e33c1de4f8e5388ddffa044b094467ceb9c46d49be7937d834fe76f883cbb7ca` |
| `build/sections/laurent.tex` | `eb6558781166a8468bc18af307bba5f04e3ff4e3d53cfa077356af627f45fb34` |
| `build/sections/preliminaries.tex` | `df4c190cc73d4b4c371adf57681f1c7236b780d751711f8f2930fcdc88761949` |
| `build/sections/stable-pairs.tex` | `0311b4a4ee05fe673682aeb1bf83abef5228fd4f711a2183034c8186ef203f2e` |

The old reference
`families/044/first-pass/openai_manuscript/The-equivariant-cohomological-Hikita-conjecture-for-arbitrary-quivers-September-24-2026`
is a symlink to this source root. All ten paths agree byte-for-byte through
that link. This is not a second, independently frozen historical source copy.
The commit designation is manifest metadata; no Git history was queried.

Separately, all **nine** existing `9000044/` digest entries in the supplied
2026-11-06T10:20Z snapshot manifest match the old workspace, 125357 bytes
total. These are the nine snapshot values, not the ten source values:

| Path below `9000044/research/` | Matching SHA-256 |
| --- | --- |
| `MATH_STATE.json` | `02470a594987587e7b28e15d979092595f93021e0ffc00d0d0bd79255eafb3c1` |
| `PROOF_GRAPH.json` | `62aa4af800d56e88a489a54d86fb601ecb5c520777d6d90d61f0f9d110e8c3af` |
| `cut_symbol/exact_certificate.json` | `0466cefc55e4caa72cc97348e07d32cd42eef1f098150470dbb9d6e08cdd61ea` |
| `cut_symbol/lean/Main.lean` | `3cda99b8ffbd8fb8b5708dbf5f7fa9def0d0a75c4f2f7bfab0735cc968f9a82d` |
| `cut_symbol/lean/certificates/C_CUT_CORE-62172a94b4f90e85.json` | `a859b409b53ab5fdd8e9399903b5e01a550a6388ee9ff27308509973d621369a` |
| `cut_symbol/lean/lean_check.json` | `ada7a033f27c2c7d623266dac881fcdd60adb938627bdfa1c847dd0244340518` |
| `cut_symbol/lean/statement_fidelity.md` | `53d053bb6639227c6cb7ba22002877b2dbaf6783b02d149da4240616b7407ed7` |
| `cut_symbol/proof.md` | `81ad09bb298cf1a887bd3461086cb298f3ba4715b1770d6b310c3f7dd71641dd` |
| `cut_symbol/verify.py` | `9eacd09fbb3c10b76542b73e9a5293c09cbe7f50e79d8840b038e15d3004d5cc` |

This comparison neither rebuilds the snapshot nor gives the other nine
inventory entries nonexistent snapshot digests. No old file, source,
snapshot, ledger, or lock was modified.

## Primary-source scope actually read

Alex Weekes, *Generators for Coulomb branches of quiver gauge theories*,
**arXiv:1903.07734v2**, was retrieved at
<https://arxiv.org/html/1903.07734v2>, beyond its abstract.

- Proposition 3.1 says the spherical algebra is generated by coefficients
  and dressed minuscule monopoles. Its proof refines the gauge-weight
  arrangement by all coordinate differences and coordinate-zero
  hyperplanes. Integral points in an ordered chamber are generated by
  positive initial subsets and negative terminal subsets. This supports
  multi-vertex subsets, not a single-slot-only claim.
- Remark 3.3 calls these "honest algebra generators": no division by
  \(\hbar\) or Poisson brackets is used, so generation persists at
  \(\hbar=0\).
- Remark 3.4 extends the argument to product-GL representations whose
  weights are multiples of coordinate differences or coordinates, explicitly
  including quivers with loops and multiple edges.
- Section 1.6.1 uses framing flavor by default and says the full flavor
  symmetry can be included with minor changes. It is not, on its own, a
  worked proof of every coefficient-preserving arbitrary-flavor interface
  asserted in the manuscript.
- Lemma 2.10 identifies a dressed minuscule class under the spherical
  corner isomorphism as
  \[
  M_{\lambda,f}\longmapsto
       \partial_{w_0w_\lambda}f r_\lambda\,\mathsf e.
  \]
  Its proof is a partial-flag pushforward/localization computation. It is
  a nilHecke identity, **not** the unlocalized equality \(A_0=L^{\mathcal W}\).

Thus the active abstract-only known-status note was not used as
theorem-level attribution.

## Decisive argument in the manuscript

First, subadditivity of \(u\mapsto u_+\) makes every excess exponent in
\[
r_\alpha r_\gamma=r_{\alpha+\gamma}
 \prod_\beta\beta^{E_\beta(\alpha)+E_\beta(\gamma)-E_\beta(\alpha+\gamma)}
\]
nonnegative. This proves polynomial closure of \(L\).

Second, for each subset coweight the chosen deleted loop contributes
exactly the crossing roots of the Grassmannian tangent denominator, up to
a constant sign. BFN's minuscule localization formula therefore identifies
the geometric subset generators with the corresponding polynomial orbit
sums. This is the geometric bridge: abstract generation alone does not
give it.

Third, the reverse inclusion is proved by induction on \(\|\lambda\|^2\).
In the positive case take
\(\alpha_d=1_{\lambda_d>0}\), \(\gamma_d=\lambda_d-\alpha_d\);
otherwise use \(\alpha_d=-1_{\lambda_d<0}\),
\(\gamma_d=\lambda_d-\alpha_d\).
Both functions are nondecreasing and sign-compatible, so every matter
excess for this matching is zero. Rearrangement at each color makes all
other resulting orbits lower norm unless they are the orbit of \(\lambda\).
At a fixed representative, a different selected subset would create a
strict inversion; hence the leading decomposition is unique. The
partitions into \(\alpha\)- and \(\gamma\)-level blocks together separate
all \(\lambda\)-level blocks. Prefix power sums and their differences
therefore generate \(P^{\mathcal W_\lambda}\) from the two dressing
subrings. Products realize arbitrary leading dressings, and lower terms
are removed by induction. No inversion of a root or framing weight enters
this argument.

Finally, every nonzero positive or negative subset has nonzero colorwise
charge. Killing those generators leaves only the image of
\(P^{\mathcal W}\); since all coefficients have charge zero, the ideal they
generate is precisely the ideal of all nonzero charge spaces. This proves
C_COEFF_SURJ conditionally on geometric generation, for the full ideal,
not its radical. The manuscript's degree calculation for minuscule
classes, \(2c_\lambda-2a_\lambda+\deg p\), supplies the charge-zero grading
interface needed by the later filtration.

## Supported scope and remaining obligations

The polynomial induction and the coefficient-quotient implication are
coherent and complete algebraic arguments over the stated complex
coefficients. The source provides an actual Laurent proof, not merely a
citation to Lemma 2.10. Its application remains conditional on the
coefficient-preserving, injective BFN localization/minuscule formula with
the specified grading conventions. Those geometric BFN inputs
(`BFN18`, Proposition 6.6 and Sections 3/5; `BFN19`, Appendix A,
Proposition A.2) were read here as manuscript inputs, not independently
proved by the old certificates. Arbitrary-flavor generation additionally
requires the parameter-retaining version of the chamber argument and the
trivial-summand reduction; Weekes's default flavor convention must not
silently be enlarged.

There is no contradiction found in these assigned claims. There is also
no new unconditional geometric certificate: the historical
INPUT_LAURENT boundary cannot be retired by the parent's abstract algebra
proof alone.

Classification: known reconstruction for Weekes generation; source-only
proposed/reconstructed argument for the geometric Laurent interface;
originality unverified. This is an ENGINEER assessment, not native
independent review. Native Host-invoked independent review remains
required and pending; there is no engineer self-acceptance.
