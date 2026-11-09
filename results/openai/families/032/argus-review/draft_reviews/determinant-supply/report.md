# Determinant-supply old-draft assessment

## Assessment, prior result and attribution

**Engineer assessment: the all-degree full-cohomology CM-supply reduction is
supported for the two precisely stated families, conditional on its explicit
structural and geometric inputs. This is not unconditional Hodge algebraicity.
Independent acceptance of this assessment is pending the Host's Reviewer.**

The assessed work is Campaign 9000032's Engineer submission, *All-degree CM
supply for quadratic actions: a constructive verification of the determinant
reduction*, dated November 5, 2026. Its strongest historical reviewer record is
`judgement-DS-UNIVERSAL-2f3fe694c61c`, produced by
`reviewer:gpt-6-astra:determinant-supply`, supporting statement hash
`8d5fa051b64271a1bf70ba8cf51fa3fd62f2ce887902ef44534ab6442797b39e`.
The earlier `judgement-DS-UNIVERSAL-cb378bc31dca` is Engineer evidence.
Neither constitutes acceptance by this review's independent Reviewer.

The prior strongest AG result,
`judgement-AG-UNIVERSAL-e61885343dda`, supplies the **actual independent
derived images**, condition (c), for dimension at most six. It does not
supply determinants. The old DS argument adds the correspondence operations,
all-degree invariant spanning, fixed-list simultaneous balance, polarized
padding and integral determinant cancellation needed for condition (d).
This assessment rechecks those old arguments and computations; it does not
present their combination, revisions or replay as a new theorem or new
priority claim.

`OLD` below means the strictly read-only
`campaigns/9000032`.
The entire `OLD/research/determinant_supply_audit/report.tex`, `verify.py`
and `exact_certificate.json` were read, including every certificate section,
58 templates and 88 configurations. All twelve DS ledger versions, the
relevant evidence/assumptions and five routes were checked. The complete AG
report/checker/certificate and its relevant ledger records were also assessed
in `../actual-group/report.md`. Neither source-inventory JSON was assessed.

## Source/version and evidence bindings

The staged source is *Weil classes and Hodge classes on abelian powers*,
October 6, 2026, `build/paper.tex`, revision
`4eaee87548250b2682affda7d05d947c05554bae`, SHA-256
`1ff56b1b900b70df2a8817ae90725f45ae74b267bb1568025bc4bcaa598c1c23`.
This actual digest matches the selected Campaign 9100032 manuscript manifest.
The source passages checked are:

* lines 57–112: the two target families, including the actual rational form;
* lines 241–448: supply, `p3:cm-operations`, coefficient descent and the
  abelian-variety instance of `p3:admissible-operations`;
* lines 449–721: toric summands, imbalance and `p3:tensor-criterion`;
* lines 833–1127: the homological convention, `p3ab:hyperbolic`,
  `p3ab:determinant-supply`, and actual columns;
* lines 1128–1605: the AG prerequisites, not reclassified from a generic group;
* lines 1606–1834: the fixed-list balance and proofs of
  `p3ab:quadratic-five` and `p3ab:split-sixfolds`.

The source tensor criterion and target Hodge statements use a companion CM
Hodge theorem. The old DS report intentionally verifies their **supply
reduction**, and isolates that companion theorem at the last implication.
Its use of external Markman is not a verification of the manuscript's later
secant-sheaf/geometric Weil-plane proof.

| Old artifact | Actual SHA-256 |
|---|---|
| `research/determinant_supply_audit/report.tex` | `512ca454a6e1f93c12028b2ef62adf838a4c7d2e51d5fcd2eb058373b8d01cf8` |
| `research/determinant_supply_audit/verify.py` | `7fc80e3a165fe2d43452e5f7dcc007997e46c9dfd2a7bc1aaf60b3ce5391b278` |
| `research/determinant_supply_audit/exact_certificate.json` | `36cefc3f192c484599510535dbd46eae00b9cc81ccf56ea90bbd3a63d88da8e0` |
| `research/MATH_STATE.json` | `e5a71be8671db2dd12a0f14539eee30e555f1e16dce0a21f01ccf6b4836a75b3` |
| `research/PROOF_GRAPH.json` | `d2620abc4fc49218c74713d0bc345869ab180fd4af399dff433fe8364797a72b` |

The checker, certificate and ledgers match their Campaign 9000032 entries of
the preserved 2026-11-06T10:20Z snapshot manifest. The TeX report is **not**
listed there. The historical judgements bind a claim hash and report path,
not the report's bytes. Consequently historical byte identity of the prose
at review time is not proven; the current full prose, its actual digest
and its statement fidelity were checked directly.

Every DS context resolves to `DS-CONTEXT` v1, hash
`fb95af5853382d5ae49a77882b03c97ec2312894fbf99f0f055b6d53bdeddad2`.
All five route goals and prerequisites match current recorded claim hashes,
including the AG dependency. All six DS claims have matching
reviewer-produced supporting judgements. The old proof graph still marks
all six `open` and `reviewer_confirmed=false`; those flags lag the stronger
hash-bound ledger records. Neither flag nor old support is inherited as a
current verdict.

| Unique claim | Versions assessed | What changed |
|---|---|---|
| DS-OPERATIONS | 1 | Abelian-variety operations and Hodge lifts. |
| DS-SPANNING | 1, 2, 3, 4 | Same statement/context hash; v2 adds FFT-SP, v3 FFT-SO, v4 FFT-SL. |
| DS-PADDING | 1, 2, 3, 4 | Same statement/context hash; v2 adds MARKMAN-WEIL, v3 MEYER, v4 HERMITIAN-CONVENTION. |
| DS-BALANCE | 1 | Fixed CM decomposition and arbitrary integral net exponents. |
| DS-ALGEBRA | 1 | Exact finite/symbolic checks supporting the prose. |
| DS-UNIVERSAL | 1 | Supply and Hodge lifts on every self-power; final algebraicity conditional. |

These are six claims and twelve historical versions, not twelve results.
Empty early assumption arrays are attribution omissions, not absence of
imports. The statement hashes did not change when citations were added, so
their actual lists were checked separately. The five routes are
`DS-CONSTRUCTIVE`, `DS-OPERATIONAL`, `DS-INVARIANT-GENERATORS`,
`DS-POLARIZED-PADDING`, and `DS-INTEGER-BALANCE`. A route is not a proof.
For example DS-SPANNING mathematically assumes the AG product and the FFTs
although its short operational route lists only DS-OPERATIONS.

## Exact supported conclusion and hypotheses

Fix \(k=\overline{\mathbb Q}\subset\mathbb C\), with scalar conjugation
acting only on coefficients of the fixed variety. For smooth projective
\(X\), put
\[
\mathcal C^d(X)=\sum_{B,j,\Gamma}
\operatorname{im}\bigl(H^{d-2j}(B,\mathbb Q)(-j)
\xrightarrow{\Gamma_*}H^d(X,\mathbb Q)\bigr),\quad
\Gamma\in\mathrm{CH}^{\dim B+j}(B\times X)_{\mathbb Q},
\]
where \(B\) is a CM abelian variety (a point is allowed), and only existing
degrees/cycle groups are used. **The source is full cohomology**, not just
CM Hodge classes. The twist convention is \(V(r)^{p,q}=V^{p+r,q+r}\).

Let \(A/\mathbb C\) have a unital imaginary-quadratic action. The theorem
applies in either of these distinct families:

1. \(\dim A\le5\), with no separate signature/discriminant hypothesis; or
2. \(\dim A=6\), with an **actual compatible polarization** whose rational
   homological \(E\)-Hermitian form is hyperbolic, of signature \((3,3)\).

In the second family, having complex signature \((3,3)\) alone is
insufficient: rational hyperbolicity, equivalently its determinant class
\([-1]\), is required. The action may be noncentral on repeated factors,
and no simplicity or general-period hypothesis is imposed.

The supported statement, for every \(m\ge1,p\ge0\), is
\[
H^{2p}(A^m,\mathbb Q)\cap H^{p,p}(A^m)
\subset \mathcal C^{2p}(A^m),
\]
with a rational Hodge lift through finitely many defining maps. Only **if**
all rational Hodge classes on every CM abelian variety are algebraic does
this imply their algebraicity on \(A^m\). That CM theorem is an external,
separate obligation, not established here or by AG.

## Canonical external inputs

The six direct DS assumptions, all their archived excerpts, and the
reviewer-produced citation artifacts were read:

| Assumption | Canonical source and locator | Exact imported scope and citation record |
|---|---|---|
| MARKMAN-WEIL | `arxiv:2502.03415v2`, August 24, 2026, Theorem 1.5.1 and §1.1 | Entire rational Weil plane on every polarized Weil **sixfold** with actual discriminant \([-1]\); no simplicity/genericity restriction and no all-powers assertion. `citation-MARKMAN-WEIL-fad56165c978`, `OLD/research/literature/ffb396379150c3ba0ae928429a18c6c7.json`. |
| MEYER | `url:https://cpeters1.win.tue.nl/Books/QuadraticForms/QuadForms.pdf`, Peters–Sterk, Version JUNE 2024, dated September 16, 2024, Corollary 3.3.4, printed p.77 | Nondegenerate indefinite rational quadratic forms of rank at least five are isotropic; used in ranks 12 and 8, not 4. `citation-MEYER-c7f0c9d7507e`, `OLD/research/literature/91d6c782fb1a94b999f534cde4bc258a.json`. |
| HERMITIAN-CONVENTION | `doi:10.1007/978-3-540-49046-3_5`, van Geemen, author-version Lemma 5.2(2)–(5), pp.6–7 | Homological formula, second-variable linearity, determinant modulo norms, balanced signature. The old report proves the unbalanced extension itself. `citation-HERMITIAN-CONVENTION-74de1926e5a6`, `OLD/research/literature/257091f2086b3a2e40b3eed38f4a7015.json`. |
| FFT-SP | `doi:10.4171/JEMS/558`, Lehrer–Zhang (2015), Theorem 4.1 and Corollary 4.2, p.2325 | Characteristic-zero symplectic and ordinary orthogonal pair spanning in every degree; no stable-range bound on spanning. `citation-FFT-SP-db49a23f3627`, `OLD/research/literature/bba6144d768707e732a2ad698a9f45b5.json`. |
| FFT-SO | `doi:10.4171/LEM/63-1/2-6`, Lehrer–Zhang (2017), Theorem 2.1, Remark 2.2, Example 4.1, Corollary 4.2, pp.184–185,190 | Determinant-isotypic component generated by harmonic nonzero-norm top volume and pairs; **combined** with ordinary orthogonal FFT for SO. `citation-FFT-SO-5fbb90ddfe46`, `OLD/research/literature/45c87ac59fce0611a7da26f27f40c60d.json`. |
| FFT-SL | `doi:10.1016/j.jalgebra.2007.10.039`, Schrijver, 19-page author PDF §5 p.10, definitions pp.1,3–4 | All mixed-bidegree **linear spanning** by mutations/products of identity coevaluation, determinant and dual determinant, not merely contraction-closed generation. `citation-FFT-SL-70fe5a221950`, `OLD/research/literature/7ac0c97f6ccc2d6971020756e2d55759.json`. |

The inherited AG inputs must also be retained: ALBERT,
`isbn:9780821844762` §§10.12–10.14 pp.527–528; HODGE-GROUP,
`arxiv:math/9901113v2` §§(1.2)–(1.3); DYNKIN,
`arxiv:2201.09397v4` Example 23.5/Theorem 23.7/Remark 23.18; and
MINUSCULE-DIMENSION, that version's Proposition 26.8, Definition 30.1,
Lemma 30.2, Corollary 30.5, §§27.2,30.4. Their hashes, uses and citation
evidence are in the adjacent AG assessment. DS does not assume independent
central characters.

Other background is the degree-one Hodge realization by lattice-cleared
homomorphisms of abelian varieties, algebraicity of such homomorphisms,
cycle-correspondence calculus and polarizability. These have no additional
canonical assumption record in the old ledger; the report gives the needed
lattice and orthogonal-complement constructions. The assessment of
admissible operations is restricted to the abelian-variety instance, not
an additional proof of every curve statement in the manuscript.

Markman's “complex multiplication by \(K\)” in this statement means its
quadratic Weil action, **not** that the full Hodge group is toric.
The earlier failed Grenoble download for Meyer has no mathematical
significance; the exact author-hosted version and locator were obtained
and independently attributed. No new literature or error campaign was
undertaken here.

## Claim-by-claim mathematical assessment

### DS-OPERATIONS — version 1

**Supported in the stated cohomological, abelian-variety scope.**
Trace-dual coefficient descent expresses an all-conjugate Hodge map as a
\(k\)-linear combination of rational Hodge maps. Dualize to homology,
clear lattice denominators and use the resulting complex-linear
homomorphism of abelian varieties to algebraize degree-one maps.
Admissible projectors thus give algebraic cohomological operations;
Chow-idempotence is not asserted. Isogenies have inverses on cohomology
by degree-normalized pushforward.

Polarization/Poincaré pairs and admissible maps realize all needed
all-conjugate pair tensors. The inverse contraction is polarization
pairing composed with an admissible map, realized by an ample power,
cup product and integration. Perfectness between \(W\) and its
coefficient-conjugate \(\bar W\) follows first from the positive
Hermitian polarization form; its nonzero determinant stays nonzero
under conjugation. This proves
\(\epsilon_\gamma(\bar W)=-\epsilon_\gamma(W)\) without assuming
\(\gamma\bar W=\overline{\gamma W}\).

For the unnormalized alternating tensor \(\delta_r\), projecting a direct
sum determinant onto consecutive block slots has coefficient 1;
alternating back has coefficient \(\prod r_i!\). For a perfect pairing
\(b\), slotwise contraction of two determinant tensors is
\(r!\det(b(v_i,w_j))\ne0\). Conversely, alternation of a power of its
inverse pair supplies the opposite determinant pair. Symplectic top
volume is supplied by the nonzero Pfaffian. Ordinary permutations are
algebraic after their rational Koszul signs. Thus none of these
extraction or cancellation maps is merely a potentially zero image.

Products of CM varieties remain CM since their joint Hodge group is a
subgroup of a product of tori. Products, compositions, permutations and
diagonal pullback preserve supply. Membership in the rational subspace
\(\mathcal C^d\) descends from \(k\). For a target rational Hodge class,
choose finitely many maps whose image contains it. Their source is a
polarizable pure rational Hodge structure of the target weight. The
polarization restricted to the Hodge-stable kernel is nondegenerate by
Weil-operator positivity, so its rational orthogonal complement gives a
Hodge splitting onto the image. This supplies a **rational Hodge lift**,
not an algebraic splitting. No CM Hodge conjecture is used at this step.

### DS-SPANNING — versions 1–4

**Supported in all degrees, given the AG product and the exact FFT
statements.** Apply symplectic pair spanning, ordinary-plus-determinant
orthogonal spanning, and mixed special-linear spanning to each block of
each fixed finite tensor degree. SO top volume is harmonic with nonzero
norm; Theorem 2.1 by itself is not a statement about its ordinary
orthogonal component. Keep the Hodge identification
\(\bar W\simeq W^*(-1)\); the opposite column is not an untwisted dual.
Classical invariant kernels commute with extension \(k\to\mathbb C\).
Slot decomposition therefore gives finitely many generator lines over
\(k\) in each degree. Each is pure after every scalar conjugation.

Choose the CM isogeny-factor embedding-line decomposition **before**
testing determinant lists. For any one generator the occurrences of its
CM lines remain fixed under every conjugation. For a finite, possibly
dependent spanning list \(L_i\), group the original lines by the type of
\(\gamma L_i\). Applying \(\gamma\) shows those grouped spans are a direct
sum, so the projection \(q_\gamma\) to its balanced group is well defined.
Every \(L_i\) is a common zero/one eigenline; hence the projections
commute even if the original lines are dependent. Only finitely many
projections occur because a projection is determined by the subset it
retains. Their product fixes a rational balanced vector and leaves only
the lines balanced in every conjugate.

A rational balanced tensor is \(J\)-invariant by minimality, and hence is
invariant under the AG product. Removing pair factors from the selected
line's bidegree count gives exactly the simultaneous determinant balance
equation with that generator's **one actual CM list**. There is no
stable-range bound on spanning, no claim of independence/unique expression,
and no tensor-degree cutoff. The later three versions repair precise
FFT attributions; they are not additional results.

### DS-PADDING — versions 1–4

**Supported with the actual-polarization and signature bounds.** If
\(u^2=-d\), the actual compatible homological form is
\[
h(x,y)=e(x,uy)+u e(x,y),\qquad
e(x,y)=\operatorname{Tr}_{E/\mathbb Q}((2u)^{-1}h(x,y)).
\]
Compatibility and alternation prove Hermitian conjugate-linearity first
and linearity second. Riemann positivity identifies its signature with
the two cohomological Hodge multiplicities; averaging constructs a
compatible positive form when needed, but does not force hyperbolicity.

For balanced rank \(2b\), hyperbolicity is equivalent to
\([\det h]=[(-1)^b]\). One direction splits isotropic vectors into
hyperbolic planes. Conversely the diagonal underlying rational form
\(\sum a_i(x_i^2+d y_i^2)\) is nondegenerate of dimension \(4b\) and
signature \((2b,2b)\). Meyer splits planes in the required dimensions
12 and 8. At rank two, the norm condition \(-ab'=\mathrm{Nm}(t)\)
gives the explicit isotropic vector \((t/a,1)\); Meyer is **not**
invoked in rational dimension four. Subtracting
\(h(w,w)v/2\) after arranging \(h(v,w)=1\) gives the displayed
hyperbolic Gram plane. In rank six, positive integral scaling changes
the determinant by \(N^6=\mathrm{Nm}(N^3)\); basis changes likewise
multiply it by a norm.

For \(1\le n=p+q<6\), with **both** \(p,q\le3\), add \(3-p\)
positive and \(3-q\) negative \(E\)-CM elliptic lines. Their prescribed
signs are realized by the chosen/conjugate \(E\)-actions; any positive
rational magnitude is obtained by positive scaling of their actual
elliptic polarizations. The total signature is \((3,3)\) and determinant
\(D_0<0\). Scale one added coefficient by \(-1/D_0>0\). This leaves
the original factor's restricted form unchanged, makes determinant
exactly \(-1\), and gives an actual hyperbolic polarized product after
clearing denominators. No arbitrary Hermitian replacement or generic
period is used.

Markman then supplies its entire rational Weil plane. Addition on six
copies, followed by
\(\pi_1=\prod_{r\ne1}([2]^*-2^r)/(2-2^r)\), puts a determinant on
separate degree-one slots as nonzero \(\delta_6\). Algebraic block
projection extracts \(D(H^1(B)_\sigma)\otimes\prod L_\nu\).
The opposite elliptic lines are supplied by the **full** cohomology of
the CM product. Their perfect contractions remove \(\prod L_\nu\)
nontrivially. If \(C\) is that CM product, the exact source map is
\[
H^{6-n}(C)(3-n)\longrightarrow H^n(B^n).
\]
Before twisting the source line has type \((3-q,3-p)\), and after
twisting it has type \((p,q)\); its correspondence has shift \(j=n-3\)
and codimension \((6-n)+j=3\). Negative shifts are valid. Thus this
is genuine supply even when the desired determinant is unbalanced.
It is not a claim that the smaller determinant is itself algebraic.
The opposite embedding follows by scalar conjugation.

For \(n=6\), no adjustable added line exists. The actual hyperbolic
\((3,3)\) hypothesis is therefore retained; Markman supplies the
determinants algebraically over \(k\). The argument does not supply
arbitrary signature \((1,4)\), \((4,1)\), or nonsplit sixfold
determinants. Versions 2–4 correctly expose the three external inputs
needed for this proof.

### DS-BALANCE — version 1

**Supported for both families and arbitrary repetitions.** The AG
classification concerns the actual full endomorphism algebra. Work up
to isogeny, transporting the given \(E\)-action and rational Hermitian
form, not choosing a new one. Distinct simple isotypic summands are
orthogonal for any compatible polarization, so their signatures add;
a proper summand of a hyperbolic form need not itself be hyperbolic.

Let \(P_i,Q_i\ge0\) count opposite determinant orientations and
\(n_i=P_i-Q_i\in\mathbb Z\). Cancel \(\min(P_i,Q_i)\) algebraic
opposite pairs. Balance is
\(\sum n_i\epsilon_\gamma(W_i)+c_\gamma=0\) for every \(\gamma\),
with \(c_\gamma\) from the fixed actual CM list. The complete
determinant-bearing cases are:

1. **Types I/II and III.** Symplectic columns need only pairs.
   The Type III rank-four volume transfers from an \(E\)-eigenspace
   of signature \((2,2)\), padded with its arbitrary restricted form.
   Rank six exhausts \(A\) and uses the stipulated actual hyperbolic
   form. Matrix-copy identifications are admissible.
2. **Quadratic full center \(K=E\).** Mixed ranks three/four have
   entries at most three and are individually supplied. In the
   dimension-at-most-five family, a rank-five factor exhausts \(A\);
   its imbalance \(2p-5\ne0\), with no CM remainder, forces \(n=0\).
   This covers even signatures \((1,4),(4,1)\) without padding them.
   In the sixfold family, any multiplicity-one proper factor has both
   signature entries at most three by orthogonal addition. Rank six
   exhausts \(A\) and uses the actual form. The only repeated
   non-CM Type IV case is a threefold \(B^2\): pad the central
   \(K=E\) determinant on \(B\), whose signature is \((1,2)\) or
   \((2,1)\). A possibly noncentral action on \(B^2\) only reallocates
   the two opposite column types among admissible copies; this does
   not substitute a product polarization for the given sixfold form.
3. **\(E\) not embedded in \(K\).** AG forces a quadratic-center
   threefold repeated twice, exhausting dimension six. Its rank-three
   \(K\)-column has nonzero imbalance; without a CM remainder, balance
   forces zero net exponent. No padding with the wrong quadratic
   action is attempted.
4. **Quartic-center fourfold \((f,a,g)=(2,2,4)\).** Its two
   representatives over one \(E\)-embedding have imbalances
   \(d=(0,\pm2)\), up to order. The smaller-family remainder is
   zero or an \(E\)-CM elliptic curve. In the sixfold family the
   remainder has signature \((2,0)\) or \((0,2)\). The complex
   structure is the same \(E\)-scalar on its whole rational
   \(E\)-space; each \(E\)-basis line is a rational elliptic CM
   Hodge substructure. Degree-one realization makes it isogenous to
   a square of an \(E\)-CM elliptic curve. Thus one may geometrically
   choose the CM decomposition into \(E\)-lines **before** balance.
   Every automorphism fixing \(E\) fixes each such line, so its
   contribution \(c\) is fixed. The two equations are
   \(d_1n_1+d_2n_2+c=0\) and \(d_2n_1+d_1n_2+c=0\).
   Subtraction forces \(n_1=n_2=t\).
   The integral kernel in \((n_1,n_2,c)\) is
   \(\mathbb Z(1,1,-d_1-d_2)\). Its first coordinate proves
   integrality, not just a rational proportionality assertion.
   The full product \(D(W_1)D(W_2)\) is the nonzero algebraic
   direct-sum image of the \(E\)-determinant of \(B\), signature
   \((1,3)\) or \((3,1)\), hence supplied by padding.
5. **Higher-center sixfold \((f,a)=(2,3)\).** There is no CM
   remainder. Holomorphic multiplicities sum to three; excluding
   all-pure CM leaves \((1,2)\) or its reversal. Imbalances
   \((-1,1)\) give integral kernel \(\mathbb Z(1,1)\).
6. **Higher-center sixfold \((f,a)=(3,2)\).** The multiplicities
   sum to three; the all-mixed \((1,1,1)\) is excluded by the AG
   actual-commutant argument. The remaining permutations of
   \((0,1,2)\) have imbalance permutations of \((-2,0,2)\).
   Transitivity of the three embeddings over \(E\) implies a
   three-cycle even in the non-Galois case. Necessary cyclic rows
   give
   \[
   M=\begin{pmatrix}-2&0&2\\2&-2&0\\0&2&-2\end{pmatrix},
   \quad \ker_{\mathbb Q}M=\mathbb Q(1,1,1),\quad
   \ker_{\mathbb Z}M=\mathbb Z(1,1,1).
   \]
   In both higher-center sixfold cases, the product over all
   representatives is the full \(E\)-determinant of the actual
   hyperbolic sixfold and is supplied. Individual column
   determinants need not be supplied.

If the common net exponent is \(t\), the uncancelled product is the
\(t\)-th power of the full determinant for \(t\ge0\), or the
\((-t)\)-th power of its opposite for \(t<0\). The cancelled pair
counts and \(|t|\) are arbitrary nonnegative integers; no fractional
root, exponent division or bound is used. Further conjugate equations
can only shrink the necessary kernels whose entire contents were
supplied. All remaining blocks are individually supplied or pair-only.
These exhaust the necessary AG list, not a sampled set of periods.

### DS-ALGEBRA — version 1

**Supported as exact algebra supporting, not replacing, the preceding
prose.** The inspected unchanged verifier uses standard-library exact
rationals and SymPy. It recomputes:

* generic averaging/Hermitian/trace identities for ranks 1–6, the
  explicit binary norm/isotropic basis and determinant scaling;
* all 14 smaller bounded signatures and the precise source degrees,
  twists, codimension and positive determinant correction;
* all 63 compositions in ranks 1–6, with projection coefficient 1
  and inverse coefficient \(\prod r_i!\), generic contraction
  coefficients \(r!\), and Pfaffian identities in ranks 2,4,6;
* degree-one interpolation projectors in dimensions 1–6;
* 12 oriented/permuted primitive exceptional balance lattices
  (four quartic fixed-CM, two double rank-three, six triple rank-two),
  the odd single-column zero kernels, and symbolic monoid
  reconstruction for arbitrary counts and both signs;
* 58 necessary determinant-bearing templates and 88 allowed
  dimension/signature configurations, including the two-threefold
  configuration. Pair-only/CM residual dimensions deliberately
  overapproximate realizability.

Their nine supply-route occurrence counts are: actual split volume 2,
central threefold padding 2, fixed-E-CM quartic 16, padded orthogonal 4,
padded quadratic singleton 30, triple-column actual volume 6,
double-column actual volume 2, zero-net nonembedded 2, and zero-net
odd fivefold 4. They are bookkeeping of the case proof, not distinct
geometric examples.

The exact negative controls matter. Identity-only balance on the cyclic
matrix admits \((0,1,0)\), whose full residual is \((0,-2,2)\).
Letting the quartic CM contribution vary independently by conjugate
admits the artificial vector \((n_1,n_2,c_0,c_1)=(1,0,0,2)\).
Neither is a hypothesis-valid abelian-variety counterexample: the
fixed-list and geometric CM arguments exclude the weakened systems.
The computation does not certify geometric realization, all-degree FFT,
Markman/Meyer, or arbitrary CM algebraicity.

### DS-UNIVERSAL — version 1

**Supported as the supply-and-Hodge-lift conclusion, not unconditional
algebraicity.** At the actual period apply AG, FFT spanning and
simultaneous-balance projection. DS-BALANCE supplies determinants;
actual CM isogeny factors supply the CM lines; pairs and all operations
are algebraic. Rational membership descends. For \(A^m\),
\(H^1(A^m)=H^{\oplus m}\); labelled slots only repeat those blocks
and CM lines, and the preceding proof permits arbitrary repetitions.
Normalized antisymmetrization lifts a rational class from
\(\Lambda^{2p}H^1(A^m)\) to the ordinary tensor power as a rational
Hodge tensor. Supply on separate slots and diagonal pullback/cup
product return the exterior class. Degree zero comes from a point,
and nonexistent degrees are zero. Polarization gives its rational
Hodge lift through finitely many CM maps as above.

Only the separate CM Hodge theorem algebraizes the untwisted
\((p-j_\nu,p-j_\nu)\) components of this lift; the given
correspondences then algebraize the target. Consequently neither AG
alone nor AG+DS alone proves the unconditional Hodge conjecture.
The result is also not full-cohomology supply for \(A\), nor saturation
after adjoining an arbitrary CM companion. In particular rank-five
cancellation used the absence of a CM remainder.

## Bounded replay and the one shared Jacobian operation

Inspection showed that `--write-certificate` writes beside the verifier.
It was not used. All actually required original inputs were copied into
the current writable `replay/`; the verifier, payload, old contract,
old typed reply/status and certificate remained byte-identical.
No writing script or import ran against `OLD`. Python ran with `-B`
and `PYTHONDONTWRITEBYTECODE=1`.

The initial command used
`$WORKSPACE/argus-latest/.venv/bin/python -B` on the local
unchanged verifier. It exited **1 before mathematics**, because that
environment has no SymPy. Its exact traceback and real exit code remain
in `replay/stderr.txt` and `replay/status.json`; they are not described
as a mathematical failure or erased.

An existing interpreter was then found to already have SymPy; nothing
was installed or rebuilt. This changed-environment recovery command was:

```text
$WORKSPACE/miniconda3/bin/python -B families/032/argus-review/draft_reviews/determinant-supply/replay/verify.py
```

From `research/draft_reviews/determinant-supply/replay`, it exited
**0**, no timeout, in approximately 2.11 seconds, Python 3.13.5 and
SymPy 1.14.0. It compared every recomputed certificate value to the
retained original, without issuing a replacement certificate.
`stdout-existing-python.txt`, `stderr-existing-python.txt` and
`status-existing-python.json` preserve exact output, command, input
digests and status. Its output reports 14 smaller signatures, 63
compositions, 12 exceptional kernels, 58 templates, 88 configurations,
Jacobian rank 2/nullity 1, and no exponent or tensor-degree bound.
No successful unchanged validation was rerun.

The current review used **one** relevant shared Jacobian operation, for
the exact matrix \(M\) above from the old verifier's `jacobian_evidence`,
not for a nearby or invented problem:

1. Through `$WORKSPACE/argus-live-update/.venv/bin/python -B -m
   argus_skill.tools.jacobian find`, discover three candidates with the
   precise existing rational-nullspace query; `jacobian/find.json`
   and `find.status.json` preserve the response and command, exit 0.
2. Inspect `matrix.nullspace.compute` before execution, saving the exact
   typed input/output contract as `jacobian/contract.json`; exit 0.
   Its input is a rectangular QQ matrix of canonical `{num,den}`
   rationals; the output is an RREF fundamental right-kernel basis.
   This 3-by-3 request is well inside the runtime's 32-dimensional bound.
3. Copy the exact existing dedicated payload to `jacobian/payload.json`
   and run once with `--timeout 45`. The exact typed output is in
   `jacobian/output.json`, with command/status in `run.status.json`
   and exact stderr separately. Server **0.14.0**, protocol
   **2025-11-25**, `mcp-stdio`, operation
   **matrix.nullspace.compute**, exit **0**, no error/timeout,
   returned rank **2**, nullity **1**, free column **2**, basis
   **(1,1,1)**.

`jacobian/check_result.py` checks the saved typed output independently
without another service call: the top-left 2-by-2 minor is 4, the
three rows sum to zero, and \((1,1,1)\) lies in the kernel.
This proves rank exactly two; its first coordinate proves the
integral kernel is exactly \(\mathbb Z(1,1,1)\).
The calculation is retained as `jacobian/checked_result.json`.
UNKNOWN, a timeout or incomplete typed output would be a
non-conclusion; none occurred in this run. The old AG oversized
request's structured rejection remains preserved in the adjacent
unit, not repurposed as success. No second Jacobian run was made.

## Concrete frontier and parent-ledger dependencies

No concrete gap was found in the **restricted supply theorem** after
its input hypotheses and the current proof-source provenance limitation
are exposed. Its unproved extensions are concrete:

* To conclude unconditional algebraicity, independently establish the
  separate all-CM rational Hodge theorem with its precise version and
  hypotheses. Full-cohomology supply and rational Hodge lifting alone
  do not do this.
* To cover all sixfolds of complex signature \((3,3)\), one would need
  a determinant-supply argument without the actual rational
  hyperbolicity/discriminant hypothesis. This proof retains it.
* To add arbitrary CM companions in nonsaturated cases, one would need
  singleton determinant supply or a new balance argument; the
  rank-five no-remainder cancellation cannot simply be reused.
* To count a numerical template as an example requires geometric
  realization with the asserted full algebra, period and form.
  Arithmetic case coverage is not such a construction.
* The prose bridge and imported-source applicability require the
  Host's independent review. There is no formal kernel theorem;
  the historical ledger has no TeX-byte binding.

For the current parent ledger, retain the hash-bound AG dependency and
all ten canonical source/locator assumptions listed here and in the AG
report. Keep the additional CM Hodge theorem as a separate conditional
dependency, not an accepted assumption audited by these units.
Preserve the retired generic-PEL route and its mathematical reason:
special-period actual commutants and partially pure rank-two columns
cannot be replaced by a generic PEL group or by abstract SL2
self-duality. That route was not retried. No novelty or family-completion
claim is made, and no ledger was modified by this assessment.
