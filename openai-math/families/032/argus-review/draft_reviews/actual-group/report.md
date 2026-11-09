# Actual-group old-draft assessment

## Assessment and attribution

**Engineer assessment: the stated derived-image theorem is supported by its
prose argument and the matching exact certificate, with the explicit imported
structural results below. Independent acceptance of this assessment is pending
the Host's Reviewer.** This is not a new result, an error campaign, a formal
kernel proof, or a novelty determination.

The object assessed is Campaign 9000032's Engineer submission, *Actual derived
Hodge images in dimension at most six: a universal reduction and an exact
certificate*, dated November 5, 2026. Its strongest existing reviewer record is
`judgement-AG-UNIVERSAL-e61885343dda`, produced by
`reviewer:gpt-6-astra:d1b0cb0f595b`, supporting claim hash
`8c08180896ed825c639dad3a704b9e921802a7e2053e73958a406556aff3a284`.
The earlier `judgement-AG-UNIVERSAL-9948099b4455` is Engineer evidence, not
another independent review. This assessment rechecks the argument, source
fidelity, dependencies and arithmetic; it does not upgrade the old review into
current acceptance.

In this report, `OLD` means the strictly read-only directory
`campaigns/9000032`.
The complete old `research/actual_group_audit/report.tex`, `verify.py` and
`exact_certificate.json` were read, as were all eleven relevant ledger versions,
their evidence, assumptions and six routes. Every certificate section was
inspected, including all 68 templates and 111 partition-case records.
The source inventories `other_manuscript_claims.json` and
`weil_tail_claims.json` were not assessed.

## Source identity, historical versions and the graph/ledger distinction

The staged manuscript is *Weil classes and Hodge classes on abelian powers*,
October 6, 2026, `build/paper.tex`, source revision
`4eaee87548250b2682affda7d05d947c05554bae`. Its actual SHA-256 is
`1ff56b1b900b70df2a8817ae90725f45ae74b267bb1568025bc4bcaa598c1c23`,
matching the selected entry of Campaign 9100032's `MANUSCRIPTS.json`.
The relevant actual-column and independence source is lines 1094–1605,
especially labels `p3ab:albert-columns`, `p3ab:minuscule`,
`p3ab:small-projections`, `p3ab:small-columns`, and `p3ab:independence`.
The definitions and condition (c) were checked at lines 333–448 and 449–721.
The applications at lines 1606–1834 retain the separate determinant obligation.

Current old-file digests are:

| Artifact under `OLD` | SHA-256 |
|---|---|
| `research/actual_group_audit/report.tex` | `ea419cfaa70155115327d71bd02c749584939dcf8d6de34d7f8ffddecc1d209d` |
| `research/actual_group_audit/verify.py` | `d9c739dc616639b46c72c010d98a536ccf38f77493365b72c5628508089b229f` |
| `research/actual_group_audit/exact_certificate.json` | `7742cd942c2408859aa7ba91fe7a5f47e3a04e5b6799f657ccba9efa95ac7b47` |
| `research/MATH_STATE.json` | `e5a71be8671db2dd12a0f14539eee30e555f1e16dce0a21f01ccf6b4836a75b3` |
| `research/PROOF_GRAPH.json` | `d2620abc4fc49218c74713d0bc345869ab180fd4af399dff433fe8364797a72b` |

The last four match the selected Campaign 9000032 entries of the preserved
2026-11-06T10:20Z snapshot manifest. **The prose report is not listed in that
manifest.** The judgement records bind a claim hash and an artifact path, not a
hash of the TeX file. Thus the current prose was checked directly; byte identity
of that prose at the historical review instant is not independently established
by the ledger. This provenance limitation is not concealed by a status label.

All current AG contexts resolve to `AG-CONTEXT` v1, hash
`5d82a0d77a7a19f222eb617501a96976aa1c2c5f4caecbda7ed61005f6a4ebde`.
All six route goals/prerequisites resolve to the current recorded claim hashes.
Each of the seven claims has a matching reviewer-produced supporting judgement,
not merely the Engineer's judgement. In contrast, the old graph's seven AG
nodes still say `open`, with `reviewer_confirmed=false`. Those are lagging graph
flags, not a refutation of the later hash-bound ledger evidence. Conversely,
the later ledger support is historical evidence, not current self-acceptance.

| Unique claim | Historical versions assessed | Revision significance |
|---|---|---|
| AG-FOUNDATIONS | 1, 2, 3 | Same statement/context hash throughout; v2 records ALBERT, v3 adds HODGE-GROUP. |
| AG-WEIGHTS | 1 | No revised statement. |
| AG-COLUMNS | 1 | Necessary covering list, not realization. |
| AG-DESCENT | 1 | All-conjugate hypothesis is essential. |
| AG-LINKS | 1 | Product statement concerns derived images. |
| AG-ALGEBRA | 1, 2, 3 | Same statement/context hash; v2 records DYNKIN, v3 adds MINUSCULE-DIMENSION. |
| AG-UNIVERSAL | 1 | Combines the obligations, not an eighth result. |

That is seven claims and eleven versions. Adding references did not change the
stored statement hashes; therefore assumption lists were checked separately,
not inferred from hash equality. Earlier empty lists are incomplete attribution,
not proofs without those inputs. The later records repair that bookkeeping.
The routes are `AG-STRUCTURAL`, `AG-WEIGHTS-PROOF`, `AG-COLUMNS-PROOF`,
`AG-DESCENT-PROOF`, `AG-LINKS-PROOF`, and the retired
`AG-GENERIC-SUBSTITUTION`. They describe the argument's prerequisites; they are
not additional mathematical evidence.

## Exact theorem and hypotheses

Let \(A/\mathbb C\) be an abelian variety of dimension at most six and let
\(E\hookrightarrow\operatorname{End}^0(A)\) be a **unital** imaginary-quadratic
action. The action need not be central; \(A\) need not be simple or generic.
No hyperbolic-polarization hypothesis is needed here. Fix
\(k=\overline{\mathbb Q}\subset\mathbb C\), and let \(J\) be the smallest
rational algebraic group containing the actual Hodge circle of
\(H=H^1(A,\mathbb Q)\); put \(R=J^{\rm der}\). Scalar conjugation changes
algebraic coefficients of this fixed variety, not its period.

Write \(A\sim\prod B^{r_B}\) with pairwise nonisogenous simple \(B\).
Columns are primitive matrix columns of the **full actual**
\(D_B=\operatorname{End}_{\rm Hdg}(H^1(B,\mathbb Q))
=\operatorname{End}^0(B)^{\rm op}\). Identify matrix copies by its matrix
units, and identify opposite Type IV embeddings by their perfect dual pairing.
Discard only rational CM isogeny factors, not individual pure columns of a
non-CM factor. The asserted matrix image is the independent product of the
full standard symplectic, orthogonal and special-linear groups listed below,
acting trivially on the CM summand. It is not a statement that central
characters of \(J\) are independent.

## External assumptions and their precise use

The four canonical old assumption records, their locator-specific excerpts,
and the independent citation records were read:

| Assumption | Canonical source and locator | Use and historical citation evidence |
|---|---|---|
| ALBERT | `isbn:9780821844762`, Chai–Oort, §§10.12–10.14, pp. 527–528 | Positive Rosati division algebras and Types I–IV; `citation-ALBERT-da8d994005f7`, artifact `OLD/research/literature/f53ce95defc72dedb4859230af509bf7.json`. |
| HODGE-GROUP | `arxiv:math/9901113v2`, Moonen–Zarhin §§(1.2)–(1.3) | Actual connected reductive Hodge group, full commutant, torus iff CM; homology/cohomology opposite convention; `citation-HODGE-GROUP-25f446501ef5`, artifact `OLD/research/literature/92295bb9977b912896f7915d63a7da6f.json`. |
| DYNKIN | `arxiv:2201.09397v4`, Etingof Example 23.5, Theorem 23.7, Remark 23.18 | Exhaustive root systems and \(B_2=C_2,\ D_3=A_3,\ D_2=A_1+A_1\); `citation-DYNKIN-f749787e538b`, artifact `OLD/research/literature/c04636f4702df407ceb49d6986d88aaf.json`. |
| MINUSCULE-DIMENSION | `arxiv:2201.09397v4`, Proposition 26.8; Definition 30.1, Lemma 30.2, Corollary 30.5; §§27.2, 30.4 | Weyl dimension/orbits and identification of standard, exterior and spin modules; `citation-MINUSCULE-DIMENSION-338c369fccf4`, artifact `OLD/research/literature/4324ce92e192a2ce07d17c747f5bc713.json`. |

The short excerpt files' statements that independent attribution was “pending”
are older than these reviewer-produced citation records. The cited Albert
input is necessary classification, not an existence theorem. Its Type III
text says **definite**; the known extraction error in an invariant formula is
not used. Moonen–Zarhin's non-compact-type/representation-uniqueness hypotheses
in Lemmas (3.3)–(3.4) are not silently assumed for partially pure columns.

Further standard background used in the prose is Poincaré isogeny
decomposition, complete reducibility and Schur's lemma, the tensor-product
description of irreducible semisimple modules, and
\(J=Z(J)^0J^{\rm der}\) for connected reductive groups. The old ledger gives
these no separate canonical source/locator record. The report proves the
specific descent, pairing, minimality and subdirect arguments rather than
attributing them to the rational-arithmetic checker. No CM Hodge theorem,
Markman Weil-plane theorem or audited-manuscript assertion is an input to AG.

## Claim-by-claim mathematical assessment

### AG-FOUNDATIONS — versions 1–3

**Supported for actual polarized weight-one structures.** On a simple factor,
the actual commutant and complete reducibility give
\[
D_{B,k}=\prod_{\tau:Z(D_B)\to k}M_s(k),\qquad
H^1(B,k)=\bigoplus_\tau W_\tau\otimes U_\tau,\quad \dim U_\tau=s.
\]
The \(W_\tau\) are irreducible \(J_B\)-modules, and remain irreducible for
\(R_B\): the connected center acts scalarly, so an \(R_B\)-submodule would
also be a \(J_B\)-submodule. All matrix projectors/units and their conjugates
are Hodge maps. Linear commutant equations justify scalar extension.

The dimensional and pairing conclusions are:

| Albert type | Necessary divisibility | Column dimension | Ordinary tensor pair |
|---|---|---|---|
| I, \([F:\mathbb Q]=f\) | \(f\mid g\) | \(2g/f\) | alternating |
| II | \(2f\mid g\) | \(g/f\) | alternating |
| III | \(2f\mid g\) | \(g/f\) | symmetric |
| IV, \([K:\mathbb Q]=2f,[D:K]=b^2\) | \(fb^2\mid g\) | \(g/(fb)\) | perfect opposite-column pair |

These are not signs guessed from group names. Factoring the polarization on
\(W\otimes U\) gives \(\beta_W\otimes b_U\). The Rosati adjoint on \(U\)
is symmetric in Types I/II and alternating in III, hence the opposite
symmetry on \(W\). Positivity excludes a symplectic adjoint on \(M_2(\mathbb
R)\) by a rank-one idempotent and excludes the alternative involution on
Hamilton quaternions by a fixed pure quaternion of negative reduced square.
In III, restricting twice to one multiplicity line would be zero:
the proof correctly uses two lines with nonzero multiplicity pairing and
then a matrix unit. Nonzero determinants stay nonzero under scalar conjugacy.
In IV, Rosati exchanges precisely the paired center embeddings.

For a noncentral quadratic action, a compatible actual rational Riemann form
exists: if \(u^2=-d\), use
\(e=e_0+d^{-1}e_0(u\,\cdot,u\,\cdot)\). Each term is Riemann-positive,
and \(e(ux,y)=-e(x,uy)\). This does **not** make its Hermitian form
hyperbolic. Nothing here proves that every numerical Albert tuple exists.

### AG-WEIGHTS — version 1

**Supported, including a column currently pure.** A Galois orbit of simple
derived ideals descends to a rational adjoint factor. If the circle
differential vanished throughout it, the rational adjoint kernel would be a
proper rational subgroup containing the circle, contradicting minimality.
Transport an acting ideal and column together to a conjugate with a nonzero
projection \(x\).

Fixing eigenvectors in all other tensor factors shows that \(x\), on its
irreducible factor, has at most two eigenvalues. It has at least two because
it is nonzero, semisimple, traceless and acts faithfully. A nonminuscule
highest weight would have a positive root string
\(\lambda,\lambda-\alpha,\lambda-2\alpha\). A Weyl conjugate of \(x\) has
\(\alpha(x)\ne0\), since a root's Weyl orbit spans the Cartan dual; the
three weights would give three distinct eigenvalues. This contradiction
proves minuscule and transports back. The proof does not assume activity at
the original pure embedding.

The generalization to arbitrary abstract pure modules without rational
Hodge-circle minimality is unsupported; that is an essential hypothesis,
not an omitted numerical test.

### AG-ALGEBRA — versions 1–3

**The exact algebraic component is supported and was recomputed.** Once
column dimensions are at most six, a faithful simple Cartan lies in the
traceless diagonal matrices, giving rank at most five *before* enumeration.
All 17 irreducible root systems of those ranks are constructed. Positive
coroot coefficients test minuscule weights; the Weyl dimension product is
computed rationally and checked against orbit cardinality. The result is 13
entries including the duplicate \(B_2/C_2\) alias, or 12 module types.
Nontrivial tensor dimension products are only \(2\cdot2\) and \(2\cdot3\).

The rational systems \(X^tB+BX=0\) and \(XT-TX=0\) check form symmetry,
nondegeneracy and commutants, not merely dimensions. The
\(\mathbb Q^2\otimes\mathbb Q^2\) model has symmetric form, scalar
commutant and Lie dimension six; \(\Lambda^2\mathbb Q^4\) has symmetric
form, scalar commutant and Lie dimension fifteen. All exterior-square
bracket identities are checked. Together with the minuscule list this
identifies the orthogonal exceptions.

The 68 necessary templates (I:7, II:7, III:2, IV:52) generate 111 multisets
of dimension cost at most six, with arbitrary CM remainder. All 306
partitions of their at most three absolute targets are considered. Only
the 111 discrete partitions survive; the other 195 first obstructions are
14 unequal simple types, 5 failures of the already full SO4 projection,
74 failures of Galois invariance, 46 pure/mixed differential conflicts,
and 56 all-conjugate intertwiner commutant conflicts. These counts describe
a proven overapproximation, not 111 actual abelian varieties.

No finite calculation proves the analytic minimality bridge, realization of
the templates, or any result in unbounded dimension. Versions 2–3 add the
root/representation attributions necessary to justify why this finite list
is sufficient; they are not extra results.

### AG-COLUMNS — version 1

**Supported as the necessary list.** Each isotypic factor inherits a unital
field action. For Type I, \(F\otimes E\) is a quadratic field over the
totally real \(F\), so \(r_B\) is even and \(g\le3\). Types I/II therefore
give alternating ranks 2, 4, 6, whose minuscule irreducible images are the
full symplectic groups. Type III's rank two is impossible: a connected
subgroup of SO2 is toric and reducible over \(k\). Ranks 4 and 6 force
\(f=r_B=1\), \(g=4\) or 6. The two \(E\)-idempotents in \(M_2(k)\)
have rank one, so its eigenspaces are matrix copies of the column, each
with signature \((g/2,g/2)\).

For Type IV, a rank-one column is pure and makes the group toric.
If all columns are pure the circle lies in the rational center-scalar
torus, again CM. A rank-two column cannot be mixed in **every**
conjugate: its alternating determinant would then be an all-conjugate
\((1,1)\) pair; composing its inverse with the opposite polarization pair
would yield an admissible map between distinct central embeddings.
Coefficient descent contradicts the full commutant. Hence non-CM rank two
requires both pure and mixed pairs.

The only possible noncommutative IV tuple with \(b>1\) is
\((g,f,b,\dim W)=(4,1,2,2)\); its sole opposite pair cannot meet that
requirement. Thus \(D_B=K\) is a field. If \(E\) does not embed in \(K\),
\(K\otimes E\) is a quadratic field over \(K\), forcing even multiplicity;
the surviving case is \(f=1,g=3,r_B=2,a=3\). If it splits, its idempotent
ranks \(r_+,r_-\) may be zero and sum to \(r_B\): this includes noncentral
\(\operatorname{diag}(a,\bar a)\) actions. The complete possibilities are
\[
f=1,\quad 3\le a=g\le6;\qquad
(f,a,g)=(2,2,4),(2,3,6),(3,2,6).
\]
For higher center the ranks 2 or 3 force SL2 or SL3. For quadratic full
center, both columns are mixed; derived self-duality would give an
all-conjugate zero-shift intertwiner to the opposite, contradicting the
commutant. The only other nonselfdual composite candidate, \(2\otimes3\),
has distinct simple types A1 and A2. All acting ideals would have to be one
Galois orbit: each orbit has an active projection, but two active tensor
factors give at least three weights. Thus that candidate is excluded and
the remaining image is the full standard SL\(a\).

Restriction of the actual \(J_A\) onto \(J_B\) is surjective by minimality
in both directions, and hence is surjective on derived groups. This is
why these are actual projections, not generic-period predictions.

### AG-DESCENT — version 1

**Supported with its all-conjugate mixedness and module-identification
hypotheses.** For a derived intertwiner of the relevant irreducible standard
modules, use the opposite column in a dual case. Schur's lemma gives a
one-dimensional Hom space; normality of \(R\) makes it a \(J\)-character
line. A nonzero intertwiner is invertible. A circle character shift \(m\)
must translate the entire spectrum \(\{-1,1\}\) to itself, so \(m=0\).
This argument is made independently for every scalar conjugate.

If \(t\) has coefficients in a finite Galois field \(L\), a trace-dual
basis gives rational coefficients
\[
t_i=\operatorname{Tr}_{L/\mathbb Q}(b_i^*t)
   =\sum_\sigma\sigma(b_i^*)\,\sigma(t).
\]
Every term belongs to the complex-linear space of Hodge endomorphisms,
so every \(t_i\) is rational Hodge. Extend by the admissible source
projector to get an element of the full rational commutant tensored with
\(k\). That algebra can mix only matrix copies within the same center
embedding and simple isogeny factor, excluding the proposed ordinary link.
No commutation of arbitrary scalar automorphisms with complex conjugation
is used. One-embedding mixedness is insufficient; partial-purity cases
are handled next, not by weakening this lemma.

### AG-LINKS — version 1

**Supported after the stated exceptional cases are retained.** A semisimple
subdirect Lie algebra in simple targets is a product of graph-diagonal
simple ideals: one source ideal surjects to each target, and two commuting
source ideals cannot both do so. Splitting SO4 first is essential.

Ordinary all-conjugate mixed targets use AG-DESCENT. A partially pure
higher-center factor has \(r_B=1\), and its columns over one embedding
of \(E\) form a transitive set of prime size \(f=2\) or 3. An invariant
link-equivalence relation is discrete or universal. The derived circle
projection is \(h'-(2p-a)I/a\), zero exactly at a pure column and
nonzero at a mixed one. A graph isomorphism preserves zero versus nonzero,
so a universal relation is impossible. The only such factor with an
external non-CM remainder is the quartic-center fourfold. The remainder
has at most one absolute Galois-stable A1 target (a repeated non-CM
elliptic curve or a Type II surface). A link to one of the interchanged
internal targets would, by conjugation and transitivity, link both,
contradicting their independence.

For SO4, its \(2\otimes2\) module has spectra \(\{\pm a\pm b\}\);
two nonzero factor projections would give at least three values. Its
self-pair ensures mixedness, so exactly one projection is nonzero.
The connected center acts trivially on this self-paired column. If its
two absolute ideals were separately rational, the zero projection would
violate circle minimality; thus Galois interchanges them. The same
single-external-target argument excludes external links. Internal
independence is already the full SO4 projection, not an assumed
commutant consequence. The SO6/SL4 isomorphism has unequal 6-dimensional
exterior-square and 4-dimensional standard modules; its Type III
sixfold uses the entire budget, so there is no partner.

For a transitive degree-three action the cyclic permutation used in the
checker is necessary even for S3, not an assumption that \(K/E\) is
Galois or cyclic. All graph twists are covered by standard/dual
identification or by isomorphism-invariant zero/Galois obstructions.

### AG-UNIVERSAL — version 1

**Supported in exactly the stated scope.** AG-COLUMNS gives every actual
projection; AG-LINKS excludes every proper subdirect image. The image of
connected \(R_k\) is a connected closed subgroup of the product of the
connected classical matrix groups with the same Lie algebra. Equal
dimension therefore gives equality, not just an abstract isogeny.
The derived action on CM factors is trivial; matrix units and opposite
pairings specify its action on repeated and dual copies. This supplies
condition (c) of `p3:tensor-criterion` at the actual period.

It does not supply condition (d), independence of central characters,
algebraic determinant classes, or any unconditional Hodge conclusion.
The dimension-at-most-five and hyperbolic dimension-six consequences
belong to the separate determinant-supply reduction, not this theorem.

## The failed generic-PEL route remains failed

`AG-GENERIC-SUBSTITUTION` is retained as a failed route, not retried.
A generic PEL group does not determine the actual group at every special
period, where the full endomorphism algebra may enlarge. In particular
the alternating SL2 determinant on a pure rank-two column has circle
weight \(+2\) or \(-2\), not zero; abstract derived self-duality is not
an admissible all-conjugate self-pair. The checker verifies both pure
orientations and the mixed weight zero. Its diagonal A1 control in
\(2\otimes2\) has a two-dimensional commutant; diagonal versus independent
actions on two standard copies have commutants of dimensions four versus
two. These are excluded representation diagrams or actual matrix-copy
phenomena, not hypothesis-valid counterexamples to the manuscript.

## Replay and Jacobian boundary

The verifier was inspected before execution. Its optional
`--prepare-jacobian` and `--write-certificate` modes write beside the
script and were **not** used. Only its actual required inputs, plus the
old inspected contract, were copied into this unit's writable `replay/`.
No verifier or import was run against `OLD`. Copies are byte-identical
and remained unchanged; `PYTHONDONTWRITEBYTECODE=1` and `-B` were used.

Executed once, from `research/draft_reviews/actual-group/replay`:

```text
$WORKSPACE/argus-latest/.venv/bin/python -B families/032/argus-review/draft_reviews/actual-group/replay/verify.py
```

Exit **0**, no timeout, approximately 0.30 seconds; Python 3.13.5,
standard library only. Exact stdout is in `replay/stdout.txt`, stderr
in `replay/stderr.txt`, and command, environment, input digests and real
status in `replay/status.json`. The locally retained
`replay/exact_certificate.json` is the complete mathematical certificate,
not a replacement for the prose report. The output reports PASS, 17 root
systems, 13 aliased small entries, 68 templates, 111 multisets and zero
proper surviving partitions. No unchanged validation rerun was performed.

The old AG Jacobian evidence is faithfully preserved by that replay:
the 48-by-16 form system was rejected with `matrix.budget_exceeded`
(adapter exit 2, non-conclusion), then its proven row-equivalent
15-by-16 system returned rank 15 and nullity 1 (exit 0).
The unchanged verifier recomputes full-system and reduced kernels and
checks the exact returned basis. Neither response classifies Hodge groups.

The **one shared current Jacobian operation** for these two units is
documented in `../determinant-supply/jacobian/`: after discovery of three
candidates and inspection of `matrix.nullspace.compute`, the exact DS
3-by-3 balance kernel was computed once. It returned rank 2 and
\(\mathbb Q(1,1,1)\), server 0.14.0, protocol 2025-11-25, exit 0.
There was no additional AG service run and no repetition of the failed
generic-group route.

## Remaining obligations and justified restrictions

No concrete mathematical gap was found in the restricted derived-image
argument after the listed inputs are made explicit. Its unproved
extensions are specific: realizing every template would need actual
abelian varieties with the stated full algebras/signatures; extending
beyond dimension six would need larger minuscule modules and Galois
link analysis; recovering the full reductive group would require its
central-character relations. A finite zero-survivor count supplies none
of those extensions.

The prose-to-geometry bridge and citation applicability still require
the Host's independent Reviewer; there is no Lean compilation or kernel
certificate. The report-time provenance limitation above also remains:
the old ledger lacks a byte digest of the historically reviewed prose.
Moonen–Zarhin already determine low-dimensional Hodge groups in
Theorems (0.1)–(0.2) and discuss graph links in §(3.1). This assessment
does not establish priority for the old dimension-six formulation.

For the parent ledger, preserve the four canonical source/locator
dependencies and the AG claim/dependency hashes in `verdict.json`.
Do not record the imported assumptions or the old reviewer record as a
new acceptance, and do not infer Hodge algebraicity from condition (c).
