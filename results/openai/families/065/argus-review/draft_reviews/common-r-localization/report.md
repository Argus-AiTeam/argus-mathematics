# Common-R localization and uniqueness

## Assessment

The old report gives a coherent **prose proof, relative to its stated
geometric and GW-theoretic inputs**, of the simultaneous localization
identities in the manuscript-normalized setting. Its filtered uniqueness
argument also supports the additional uniqueness assertion. The decisive
steps are normalization with a compatible obstruction theory, retention
of joint endpoint tensors, the two-point determination of the translation
and bridge from the same \(R\), and stable-graph assembly. They are assessed
below, rather than inferred from the finite checker or an old support label.

No concrete counterexample or fatal mathematical gap in those steps was
established by this review. This is not a kernel proof, a certification of
either whole manuscript, a novelty finding, or final acceptance.
**Target:** exploratory. **Review-result novelty:** not applicable.
**Acceptance:** pending the Host-invoked independent Reviewer.

## Exact assertion, hypotheses, and versions

Let \(B\) be smooth, connected and projective over \(\mathbb C\), and let
\(E\) have rank \(r\geq2\). For this unit \(E\) is the
**already normalized bundle with \(E^\vee\) globally generated**. Set
\(X=\mathbb P_B(E)\), \(W=\mathbb P_B(E\oplus\mathcal O)\), parametrizing
lines. The torus weights are zero on \(E\), one on \(\mathcal O\);
\(\lambda\) is inverted. Use full complex cohomology with its parity and
categorical pairings, not only algebraic or even insertions. The fixed
pairing is
\[
 \eta^{\rm fix}=\eta_B^t\oplus\eta_X^t,\qquad
 \eta_F^t(b,c)=\int_F bc/e_T(N_F).
\]
The twists are the inverse Euler classes of \(R\rho_*f^*N_F\).
Curve coefficients retain actual integral \(H_2\) labels, including
torsion, completed in a positive integral ample degree.

The assertion is the existence of even primary backgrounds \(u_B,u_X\)
and
\[
 R(z)\in\operatorname{End}(H_B\oplus H_X)[[z]],\quad
 R-I,\ u_B,\ u_X\text{ of positive total Novikov filtration},\quad
 R(-z)^*R(z)=I,
\]
such that, with \(S_{\rm bl}=\bigoplus_F S_{F,\rm tw}(u_F,z)\),
\[
 S_W=R S_{\rm bl},\qquad
 \mathcal A_W(0)=c\,U_R
       \bigl(\mathcal A_{B,\rm tw}(u_B)\mathcal A_{X,\rm tw}(u_X)\bigr).
\]
Here \(c\) is invertible and independent of ancestor variables. The
ancestor convention omits curve-unstable distinguished data, including
genus one with no distinguished marks. \(S\) has a primary output and a
descendant input as defined in `geo:S-definition`. \(S_W\) is initially
expanded at infinity; each coefficient is rational in \(z\), and the
factorization uses its expansion at **zero**, with a finite lower bound
at each curve coefficient. \(R\) and its inverse have coefficientwise
defined quantized actions. The report additionally asserts uniqueness of
\((u_B,u_X,R)\) under these filtration and upper-power-series conditions;
the proposition itself only states existence.

The old draft is
`9000065/research/family_orbit_localization/report.md`, verification
theorem and Sections 1--6. Its actual manuscript is
`Virasoro-Constraints-under-Projectivization-October-5-2026`,
`build/sections/03-master-space.tex` and `04-localization.tex`,
especially `loc:factorization`, `loc:leg-geometry`,
`loc:tangent-gluing`, `loc:dummy-derivatives`, `loc:S-tail`,
`loc:translation`, `loc:bridge-kernel`, `loc:vertex-conversion`, and
`loc:Wick-substitution`. The actual old-path manuscript files match the
supplied manifest's revision
`4eaee87548250b2682affda7d05d947c05554bae`; all 21 listed TeX inputs
across both manuscripts were compared without changing the manifest.

| Old claim | Versions and changes | Disposition |
|---|---|---|
| `C_LOC` | 1--6, identical natural statement; v2 adds GP, v3 virtual pullback, v4 genus-zero identities, v5 mixed ancestors, v6 upper quantization | One geometric claim, not six results. |
| `C_LOC_SCOPE` | 1--5, identical natural statement; progressively records CGT, Fan, Iritani--Koto, and CGT Remark 3.7 | Scope comparison; the literal Fan assumption needs the same-rank correction below. |
| `L_LOC_LEG`, `L_LOC_GLUE`, `L_LOC_MOMENT`, `L_LOC_GENUS0`, `L_LOC_VERTEX`, `L_LOC_WICK` | Each v1 | Dependent steps of this proof, not independent accepted discoveries. |
| Uniqueness | Report theorem and last paragraph of Section 6; no separate old ledger ID | Additional assertion assessed here, not silently omitted. |

`L_LOC_LABELS` is assessed in `../ample-completion/report.md`;
`C_LOC_JET` in `../finite-moments/report.md`; the explicit Euler formula
in `../moving-euler/report.md` is supporting geometry, not an extra
prerequisite for the two-point recognition argument. The old graph's
`C_LOC` abbreviation says “arbitrary E,” while its ledger context and
manuscript master space use normalized \(E\). The genuinely untwisted
arbitrary-\(E\) assertion is separately `C_LOC_ARBITRARY`, not obtained by
silently overriding that context.

## What the sources establish, before their application

The inherited inputs were registered in the current ledger before this
assessment relied on them. Primary-source reading is recorded in
`research/literature/source_assessment.md` and the adjacent proposition
transcriptions/native archives.

* Graber--Pandharipande, `arxiv:alg-geom/9708001v2`, Introduction (1)
  and stable-map application, supplies virtual localization for the
  equivariant stable-map POT and the required ambient embedding.
* Manolache, `arxiv:0805.2065v2`, Definition 4.5, Theorem 4.8 and
  Corollary 4.9, supplies virtual-pullback functoriality **for compatible
  triangles**, DM-type morphisms, quotient stratifications and the
  stated pure-dimensional-base hypothesis.
* CGT, `doi:10.1017/fmp.2024.2`, Section 3.4 (8)--(11) and Proposition
  3.1 proof, supplies the normalized twisted genus-zero identities;
  Section 3.5, Proposition 3.6 supplies mixed-potential translation;
  equation (19) supplies upper quantization and its signs.

Those citations do not establish the report's particular fixed-locus
identification or its application to non-descending endpoint classes.
The source's mixed-potential equality has no scalar; the report must
justify its stable-curve convention and completed inputs itself.

The scope comparison is sound with exact qualifications. CGT's toric
bundle has fixed sections and individual orbit-direction families
isomorphic to \(B\). Remark 3.7 anticipates the general-action formula
but explicitly leaves leg moduli and virtual cycles as foundational
work. Fan's `arxiv:1705.07421v2`, Theorem A/1.1 uses numerical \(N_1\)
labels and **same-rank**, equal-Chern-class bundles. The old ledger
assumption `A_FAN_SCOPE` omits same rank: this is an incomplete citation
summary, not a manuscript error or a refutation of localization.
The current ledger retires it with that reason and uses
`A_FAN_SCOPE_RANKED`. The current `A_CGT_SPLIT_LOCATED` likewise corrects
the proposition's location to Section 3.4. Iritani--Koto,
`arxiv:2307.03696v4`, Theorem 1.7/Corollary 1.8 concerns a genus-zero
decomposition at a fractional inverse-fiber localization, not this
all-genus Novikov-origin statement.

The five old `sources/*.txt` files and `reviewer_source_excerpts.txt`
were inspected as historical transcriptions. Their content is broadly
consistent with these scope limits, subject to the Fan hypothesis and
CGT locator corrections. The historical review explicitly did not clear
its native literature-attribution gate. Its support labels are not
current acceptance. All nine active current source propositions now
have the separate source worker's returned reading archived and filed;
that confirms the cited propositions, not all applications below.

## Decisive argument assessment

### 1. Legs and compatible diagonal gluing

A moving component projects to a point of \(B\); its orbit closure is
the line from \(b\) to \(x\in X_b\), and its degree-\(m\) map is totally
ramified at its two endpoints. A self-node would identify different
target endpoints, so it cannot occur. Its family is the root gerbe
\(\mathfrak L_m=\sqrt[m]{\mathcal O_X(-1)/X}\), with universal cover
\(\mathbb P(M\oplus\mathcal O)\) and \(M^m=q_m^*\mathcal O_X(-1)\).
This description retains the deck group and both evaluations, not just
the set of orbit lines. Rationally \(q_{m*}1=1/m\).

On the covered line the tangent sequence has
\(H^1(\mathcal O(2m)\oplus\mathcal O(m)^{r-1})=0\) and a constant
base tangent. Thus the fixed leg theory is the tangent theory of the
smooth gerbe; no splitting of \(E\) on \(B\) is assumed.
The endpoint tangents are
\[
 a_X=(\lambda+q_m^*p_X)/m,\qquad a_B=-a_X.
\]
Both branches at a leg--leg node approach the same fixed component,
so their scalar smoothing character is
\(\pm\lambda(1/m+1/m')\), never zero; a leg--vertex node has
\(\pm\lambda/m\). These checks justify cutting precisely those nodes.

For labelled branches, the report constructs the evaluation fiber
product with the fixed diagonals. The normalization exact sequence on
the universal nodal curves yields the **map of deformation complexes**
\[
 R\rho_*f^*T_W\longrightarrow
 \bigoplus_\alpha R\rho_{\alpha*}f_\alpha^*T_W
 \longrightarrow\bigoplus_q\operatorname{ev}_q^*T_W.
\]
The last map is evaluation difference, the differential of the
diagonal constraint. Adding pointed-domain complexes and smoothing
lines, and then taking fixed parts, identifies the induced POT with
the diagonal-matching theory. This is the necessary compatibility
argument; a mere virtual-rank calculation would not suffice.
The relative construction and base change apply over the whole
fixed-map factors, including their internal boundaries.

The diagonals are regular in smooth fixed targets, so excess
intersection is allowed. Stable-map quotient presentations, the
root-gerbe quotient, their products and finite graph quotients provide
the required quotient stratifications; relative prestable-domain
bases are smooth/pure dimensional. This is where the hypotheses of
Manolache are used. The result is a refined diagonal pullback, not a
transversality assumption. The moving terms give the flag factor
\(e_T(N_F)/(a-\psi)\), making contraction use the inverse twisted
pairing. The no-smoothing external endpoint and cotangent \(-a\)
fix the unstable convention. These data support `L_LOC_LEG` and
`L_LOC_GLUE` as geometric prose, not as compiled statements.

### 2. Joint data, not marginal products

For a cut correspondence the report retains
\[
 h_{j_1,\ldots,j_k}=
 e_*\!\left(C\prod_i\nu_i^{j_i}\right).
\]
Each \(\nu_i^{D+1}=0\) is the pullback of a class on its proper
dimension-\(D\) leg gerbe. The finite expansion is made **before**
pushforward; projection formula, the compatible diagonal pullback,
and subsequent linear/multilinear contractions then preserve the
complete joint tensor. Dummy derivatives act on the scalar kernels
alone, not on \(C\), \(u_F\), or their \(\lambda\)-dependence.
This supplies the geometric application needed in `L_LOC_MOMENT`.

The fresh Lean replay certifies only the finite inverse and finite-sum
linearity/distributivity after the geometric maps have been identified.
It does not prove a projection formula or construct those maps.
The exact \(18\) versus \(6\) example refutes a marginal replacement;
the actual manuscript explicitly uses joint moments and independent
dummy scalars. The failed attack is therefore not attributed to it.
The current ledger records that route as retired with this reason.

### 3. The same R, rather than separate genus-zero and ancestor choices

Unmarked trees give a positive-filtration descendant background
\(\epsilon_F\). The equation
\([S_f(\epsilon_F-u_F)]_+\in zH_F[[z]]\) has constant-term
linearization \(-I\), so ample-degree induction determines \(u_F\).
The scalar two-point identity can then be applied to a tangent class
by the finite joint convention. Localization of a two-point invariant
gives the tail formula
\[
 (R(z)^*b)_F=b|_F+
       \sum_{\rm tails}\frac{S_f(a)h_b}{a+z}.
\]
Its denominators are invertible at zero; every nonidentity term has
a positive-degree moving leg. Nondegeneracy of the pairing identifies
this formula with \(S_W=R S_{\rm bl}\), with the manuscript's
primary-output/descendant-input convention.

Symplecticity is an identity of the underlying rational functions,
not an identification of their expansions at zero and infinity.
The string equation and the regular part of \(J_W(-z)\) give
\(x=z(1-R^{-1}1)\). Cutting the path between the two marks in the
two-point function gives
\[
 D(-w,-z)=\frac{R(w)^*R(z)-I}{w+z}.
\]
Symplecticity removes the apparent divisor \(w+z=0\).
Thus translation and bridge are consequences of this very \(R\);
they are not an independently postulated transformation.
This supports `L_LOC_GENUS0`. The degree-one checker corroborates
these signs and conventions in one coefficient, not in all degrees.

### 4. Vertex conversion and all-genus assembly

The \(\psi-\bar\psi\) splitting divisor cuts off the appropriate
genus-zero twig, giving the dressed flag
\(S_f(a)h/(a-\bar\psi)\), including its unstable metric term.
All evaluation factors at that slot must be in \(h\) before dressing;
other distinguished ancestors pull back from the stabilized curve.
Finite joint expansion extends the scalar identity to all flags.

For the mixed-background conversion, each translated insertion
\(x(\bar\psi)\) has positive ancestor degree. A boundary tail with
one old mark and \(k\) forgotten new marks has
\(\dim\overline M_{0,k+2}=k-1\); its \(k\) positive ancestor
powers vanish. Newly stable genus-zero distinguished data vanish
by the same count. Genus one without an original mark changes only
a variable-independent scalar. Positive Novikov filtration bounds
the number of new marks, so completed inputs reduce coefficientwise
to these finite arguments. This is the report's own justification
of the convention/scalar adaptation, not a stronger claim about
CGT Proposition 3.6. It supports `L_LOC_VERTEX`.

Stabilization removes rational moving legs, unmarked rational trees
and two-flag chains, retaining whole surviving fixed-map factors.
Their global ancestors are the pullbacks under the corresponding
composition of stabilization and gluing. The remaining substitutions
and bridge contractions are exactly those already determined above.
Flag labelling gives the exponential factorials; division by labels
gives graph automorphisms; an edge contributes \(\hbar\), with total
connected exponent \(\sum_v(g_v-1)+e=g-1\). Self-contractions use
the same rule. In super vector spaces the diagonal is categorical
coevaluation and permutations carry their Koszul signs. Even tangent
moments do not introduce a second parity convention.
These observations support `L_LOC_WICK`, including full cohomology;
Lean does not encode this categorical/geometric part.

### 5. Uniqueness and the completion boundary

Compare two permitted factorizations at the first ample degree where
their parameters differ. Their fixed fundamental solutions differ by
\((\delta u_F\cup)/z\): an additional positive curve or background
factor belongs to higher filtration, and the degree-zero linear
variation is the classical product. A difference of upper factors
cannot cancel a \(z^{-1}\) term. Applying cup multiplication to the
unit gives \(\delta u_F=0\), then \(\delta R=0\); induction proves
uniqueness. This is a genuine all-orders filtered argument, not an
inference from one numerical coefficient or semisimplicity.
It relies on positive **total ample** filtration, as specified.

Integral splitting, bounded effective-label decompositions, stability,
and nilpotence give the coefficientwise finiteness needed here and
for inverse/logarithm/quantization. Those details and the extension
to a different arbitrary-\(E\) master space are separately assessed
in `../ample-completion/report.md`.

## Evidence limits, attribution, and remaining obligations

The restricted algebra is reproduced by a fresh Lean 4.31.0
compiler/audit run with no holes. The symbolic checks reproduce one
joint-moment example and one admissible degree-one coefficient,
using explicit geometric premises; neither proves this theorem.
The old certificates and old engineer/reviewer judgements are
reading material, not mechanical evidence or current acceptance
of `C_REVIEW`.

The strongest prior result was already this all-orders geometric
claim with uniqueness and the arbitrary-\(E\) strengthening. This
review proves no stronger theorem: it supplies exhaustive version
coverage, an argument-by-argument assessment, fresh restricted
replay, and corrected citation scope. The abstract general-action
formula was anticipated by CGT Remark 3.7. Originality of the
particular family-leg justification and of the strengthening was
not established; they remain attributed to the old Argus report.

No additional mathematical repair is prescribed for a gap this
assessment did not find. The remaining **acceptance obligation** is
the native Reviewer's independent examination of the compatibility,
two-point path decomposition, vertex/stabilization and super-pairing
arguments in their actual versions. The five cited external results
remain external inputs, even after their propositions are confirmed.
No formal proof of the surrounding geometry is supplied or required
by the exploratory review contract. Downstream Virasoro transfer
and complete-intersection sewing retain the separate dispositions
in their units; they do not follow from acceptance of this unit.
