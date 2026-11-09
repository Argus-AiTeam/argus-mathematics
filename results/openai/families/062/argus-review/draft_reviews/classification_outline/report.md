# Retrospective assessment: classification_outline

## Status and evidence boundary

This is the Engineer's retrospective assessment, not native independent
Reviewer acceptance. It covers **25 assigned claim IDs, each only at version
1**: the historical objective C9000062 and the 24 classification-programme
assertions indexed in `research/DRAFT_REVIEW_INDEX.json`. The review itself
has `novelty_status=not_applicable`. Unresolved below means unresolved in the
old Argus dossier, not a finding that a manuscript assertion is false or a
claim about its current status in the literature.

The actual old `research/MATH_STATE.json` was compared with the coverage
index: all 25 statements and content hashes agree; every assigned claim has
an empty formal statement, no recorded external assumptions, and no
claim-specific evidence record. The old `research/PROOF_GRAPH.json` supplies
open nodes and dependency arrows, not proofs. The old descent report's
scope paragraph itself excludes verification of the remaining chain.
An existing manuscript proof is reference material, not an additional
standalone Argus proof. The arithmetic certificate, finite cubic check and
local descent dossier cannot be promoted to classification certificates.

Only old/reference sources were read. No old artifact, preserved snapshot,
current ledger or graph was modified; no checker, Lean build or external
literature search was undertaken for this unit. In particular, the
geometric argument in old `contact_value_descent/report.md` sections 2--7 is
not reassessed here. The other units own the descent proof and its two
free-line inputs. This assessment gives their exact source interface below.

## Exact manuscript reference and measurements

Authority:
`campaigns/9100062/MANUSCRIPTS.json`,
source revision **`4eaee87548250b2682affda7d05d947c05554bae`**.
The old manuscript symlink resolves successfully to the source directory
specified there:

`openai-math/preprints/Contact-Fano-manifolds-and-the-LeBrun-Salamon-conjecture-September-23-2026`.

All twelve actual TeX files were read and SHA-256 compared with that manifest
in **one pass, without version-control access or retries: 12/12 matches,
146,579 bytes total**. This establishes the designated reference bytes,
not the identity of a guessed live branch. The recorded inventory is twelve
TeX files plus `README.md`, **13 files total**. It contains no local
script/checker/PDF; absence of such a file is not evidence against a theorem.

| Relative source path | Bytes | Measured SHA-256; all equal manifest |
|---|---:|---|
| `build/figures/unmarked-boundary.tex` | 1600 | `4f7104fd843a03451d9a7a0885ff1d26dc37966f6ba6cb76ddfdf5ac81ff7908` |
| `build/main.tex` | 2772 | `679bb875701eaef57e834f8fc8dc02333608ec2625c2a369bec45296f10dd409` |
| `build/references.tex` | 8939 | `37dcecfb0a1941bdde57212323bb7ffa8feb126c37543ef15b3cc9ebaf643c9e` |
| `build/sections/descent.tex` | 15402 | `c4987021887c53fab11f0d75a02d82445e415c326255a5a12251b6babbfd1471` |
| `build/sections/extension.tex` | 29779 | `1fbfaf3bcb36e3c163545bf1839ba6fc1d57e46387e0a8ec5e58aeb7674610fe` |
| `build/sections/homogeneous.tex` | 13142 | `b49d09958ce38b47c5ac154c77b19023ce2283a61fe1541fa8a578eb4651dfee` |
| `build/sections/introduction.tex` | 16932 | `8d14a34032e06ca2a289c1327dc8d17a69fa6b6fe00c517d6df9ab559fbe0af4` |
| `build/sections/jets.tex` | 14792 | `645c2638497df470fd320f4640fe883cfb98919531fc5b94bcdc5920d8332974` |
| `build/sections/lines.tex` | 15053 | `035fd2335387bf6e20d490692ce1c1928a5e9e1535811990b5bd9d9ca8ddcd7e` |
| `build/sections/reduction.tex` | 7773 | `5856bd6d26487e03c3abab7cc8c3fb4cdede4effe53885e3979135538edb9d5d` |
| `build/sections/smoothing.tex` | 14560 | `50fbf2a4ac07774f99d332eff57ca8ddc4cd0c61eabaeb12eba6c56a8ab8abdd` |
| `build/sections/twistor.tex` | 5835 | `3f4e583389fe958ebe0c09e5af1c971f3216663b9f2dfa8e27ab382410dfc139` |

All source paths and one-based line numbers below refer to these matched
files; section filenames abbreviate `build/sections/`.

## Exact descent comparator for the geometric unit

Compare `descent.tex:11--33`, Proposition `des:descent` and
`des:common-value`, with old `contact_value_descent/report.md:63--86`
(section 1), and `statement_fidelity.md:3--21`.
The matching source SHA-256 is
`c4987021887c53fab11f0d75a02d82445e415c326255a5a12251b6babbfd1471`.

| Object | Exact source requirement and comparison |
|---|---|
| Ground field and contact data | Over complex numbers; the given contact sequence `0 -> F -> T_X --theta--> L -> 0`, not a replacement distribution or polarization. The global setup is dimension `2n+1`, `n>=1` (`introduction.tex:3--18`, `reduction.tex:4--18`). The old statement agrees. |
| X | Smooth, simply connected, complex projective contact Fano; `Pic(X)=Z[L]` (`descent.tex:18--20`). The old report retains both hypotheses; fidelity explicitly interprets simple connectedness analytically. Neither Picard rank one with a different generator nor Fano alone is substituted. |
| Lines | A family of **free contact lines covering a dense open subset** of X. A contact line is a map `f:P1 -> X` with `f*L=O(1)` (`lines.tex:4--13`); free means `f*T_X` globally generated (`lines.tex:64--69`). The report's “covering” is expressly dense covering in fidelity row 16. Coverage of every point, a special splitting, embeddedness, or irreducibility of the tangent-direction variety is not added. |
| Z and M | Exactly `Z=X x X`, `M=L boxtimes L` (`descent.tex:11--14`; old report:71). |
| Y and p | **Every** proper integral algebraic space Y over C and **every** dominant morphism `p:Y -> Z` (`descent.tex:20--21`; old report:73--74). Y need not be a scheme, normal, projective, generically finite over Z, of the same dimension, or have special fibers. Neither p nor a curve pullback is assumed flat; there is no connected-fiber assumption. |
| Both lifts | Everywhere regular `W12 in H0(Y,p*(T_X boxtimes L))` **and** `W21 in H0(Y,p*(L boxtimes T_X))` (`descent.tex:22--30`). They have the same section `xi=(theta boxtimes 1)W12=(1 boxtimes theta)W21` of `p*M`. One lift, rational lifts, or equality only generically is not the stated hypothesis. Old report:74--81 and fidelity row 20 agree. |
| Conclusion | Existence **and uniqueness** of a globally regular `B in H0(Z,M)` with `p*B=xi` (`descent.tex:32`; old report:83). Not merely rational descent, a finite cover, or a scalar contact value at general points. |
| What is not assumed | No moving-pair construction, involution, full Hom-family identity, jet symbol, or classification is needed in this proposition. These are separate upstream/downstream assertions. |

**Comparator conclusion:** there is no detected hypothesis strengthening,
weakening or quantifier change in old section 1 or the fidelity table.
The manuscript explicitly formulates descent independently of the
stable-map construction (`descent.tex:10--11`). Its proof chooses smooth
irreducible H with smooth dominant evaluation (`descent.tex:72--79`);
this is an auxiliary consequence of the assumed free covering family,
not an extra hypothesis on Y or an assumption of classification.

The subsidiary source interfaces, without reassessing their proofs, are:

* **C_POSITIVE:** Lemma `lines:positive`, `lines.tex:97--132`
  (statement 97--106), supplies the intrinsic positive subbundle, trivial
  quotient and `theta(P_f)=0` for every free contact line; it additionally
  states isotropy and rank at most n. The particular descent use is
  `des:line-quotient`, `descent.tex:80--85`.
* **C_FREE_EVALUATION:** Corollary `lines:free-cover`,
  `lines.tex:134--149`, supplies smooth irreducible parametrized H and
  smooth dominant evaluation. Its manuscript existence input is the
  primitive-case covering component discussed at `lines.tex:19--35`;
  it also uses `lines:fixed-degree` (64--95) and the Hom deformation
  discussion (54--62). The old claim about **upgrading an already assumed
  free covering family** is only this conditional deformation step.
  It does not by itself prove existence of contact lines in the primitive
  case. Source hashes: lines
  `035fd2335387bf6e20d490692ce1c1928a5e9e1535811990b5bd9d9ca8ddcd7e`,
  descent as above.

## Source-reference dependency groups

Attributions in this section and below mean “the manuscript cites/describes
this input,” not that this review has independently checked the original
external theorem or its historical priority.

* **Reduction/background:** `reduction.tex:20--67` invokes prescribed
  positive Ricci form, Bonnet--Myers, Kodaira, GAGA, vanishing and
  Riemann--Roch. `red:alternatives` invokes KPSW Theorem 1.1, Mori's
  ample-tangent theorem and Kobayashi--Ochiai's index theorem, in addition
  to its contact-form calculations. The determinant and simple-Picard
  nodes alone are not a proof of these alternatives.
* **Contact-line background:** `lines.tex:19--62` attributes existence,
  smoothness, standard splitting and spanning to Kebekus (Section 2.3,
  Proposition 3.3, Corollary 3.4, Lemma 3.5, Theorem 4.4); for n>=2 it
  attributes smooth Legendrian directions to corrected Buczynski
  Theorem 3.1, arXiv v2, not irreducibility. Hom deformation results are
  attributed to Araujo--Kollar Theorem 5. The n=1 replacement is separate.
* **Smoothing/moduli/extension:** `sm:relative-hom` cites Araujo--Kollar
  Theorem 15 with a nodal flat source, not just the smooth-source theorem.
  `extension.tex:72--100` cites Behrend--Manin Theorem 3.14 and
  Corollaries 4.8/4.6 for the proper unmarked stable-map stack. Normality,
  DVR base change and extension cite the stated Stacks results; coarse
  functions/descent cites Conrad's coarse-space theorem. These are
  additional inputs absent from the bare graph arrows.
* **Jets/homogeneity:** `jet:criterion` has its own local cubic/Levi
  calculation and contact-Hamiltonian construction; the latter is also
  attributed to LeBrun Proposition 2.1. `hom:adjoint` invokes Borel fixed
  points, connected parabolics and highest-weight theory (Milne), and
  nilpotent-orbit/symplectic-cone material (Beauville and
  Jacobson--Morozov). Contact transitivity is an input, not a consequence
  of these citations alone.
* **Quaternionic application:** `twistor.tex` attributes positive
  twistor geometry to Salamon and LeBrun Theorem 2.1; symmetric-model
  correspondence to Wolf and Landsberg--Manivel Section 3.9; normalized
  metric uniqueness to LeBrun Corollary 3.4. No claim is made here to have
  checked those external statements.

## Claim-by-claim assessment

Each entry refers to the exact version-1 statement in the coverage index,
checked against the old ledger. “Old evidence” for every entry is the
common empty evidence record described above plus the indicated graph
dependencies; source proof sketches are assessed as reference arguments.
The machine-readable verdict records every assigned ID exactly once.

### A. Historical objective and reduction

1. **C9000062 — historical objective, not a theorem.**
   Its exact old statement is `MATH_STATE.json#/claims/0`: adversarial
   audit with either a certified explicit flaw or independent
   verification/repair/generalization of the core theorem with a
   standalone machine-checkable certificate and independent Reviewer.
   The graph's verification route points to C_MAIN and C_QK. Neither
   route was fulfilled by the local descent certificate; no manuscript
   refutation was established. This historical requirement is not
   reactivated. Attribution/novelty: old campaign objective,
   not applicable. Open status: historically unfulfilled at this scope.

2. **C_DETERMINANT — supported elementary background consequence.**
   For a rank-2n contact subbundle F on a smooth (2n+1)-fold,
   the nondegenerate L-valued alternating Levi form has nowhere-zero top
   power, so `det F=L^n`. The exact contact sequence then gives
   `det T_X=L^(n+1)`; if X is Fano, L is ample because a positive tensor
   power is ample. This is the decisive argument for
   `red:determinant`, `reduction.tex:4--18`; it needs neither Picard rank
   one nor simple connectedness. Graph dependencies: none.
   No further mathematical obligation at this elementary scope;
   no novelty claim or classification consequence is asserted.

3. **C_SIMPLE_PIC — source-attributed background, not old-verified.**
   On every smooth complex projective Fano manifold the source asserts
   analytic simple connectedness and free finite-rank
   `Pic(X)=H^2(X,Z)` (`red:simply-connected`, `reduction.tex:20--67`).
   The source's decisive chain is finite universal cover from positive
   Ricci curvature, algebraization, vanishing plus Riemann--Roch forcing
   its degree to be one, then exponential sequence and universal
   coefficients. Graph: no dependencies. The old dossier checks neither
   the cited analytic inputs nor the algebraization/degree argument.
   Conditional exponential/UCT consequences do not replace that chain.
   Background attribution only; old verification remains open.

4. **C_PICARD — reduction not supplied by its graph predecessors.**
   Under the contact-Fano setup with n>=1, `red:alternatives`
   (`reduction.tex:69--176`) asserts either `Pic(X)=Z[L]`, or the standard
   incidence manifold with `L=O(1,1)`, or standard projective contact
   space with `L=O(2)`, preserving the **given** F and with connected
   contact-transitive groups. Graph: C_DETERMINANT, C_SIMPLE_PIC.
   Missing old steps are KPSW/Mori in higher Picard rank, the index
   bound in nonprimitive rank one, and uniqueness/identification of the
   given contact form on both exceptional models. Background reduction
   plus manuscript calculations; no independently checked priority.
   Not established by the old dossier.

### B. Lines, cone geometry and smoothing

5. **C_LINES_COVER.**
   In the remaining primitive contact-Fano case,
   `lines:free-cover` (`lines.tex:134--149`, setup 4--62) asserts existence
   of smooth irreducible H of parametrized free L-degree-one maps with
   smooth dominant evaluation. Graph: C_PICARD, C_FREE_EVALUATION.
   The latter only upgrades an **existing free covering family**.
   The missing existence input is the cited covering component and
   degree-one/projective-space alternative, followed by
   `lines:fixed-degree`, openness and the Hom obstruction criterion.
   Thus the graph is not a proof of existence. This is source-attributed
   background/deformation, not a new Argus result; old verification open.

6. **C_LINE_DIRECTIONS.**
   At a general x in the primitive case, directions of the specified
   covering contact-line family span `P(F_x)` and form a smooth,
   possibly disconnected Legendrian variety; n=1 is a finite reduced
   spanning set (`lines.tex:19--51,151--177`). Graph: C_LINES_COVER.
   Old missing checks are the precise family to which the cited
   Kebekus/Buczynski statements apply, the corrected v2 smoothness
   hypothesis for n>=2, realization by actual tangents, and the separate
   finite-direction argument for n=1. A free covering family alone
   proves neither spanning nor Legendrian smoothness. Source-attributed
   background, no verified novelty; old verification open.

7. **C_CONE_ADDITION.**
   `lines:cone-addition` (`lines.tex:187--268`) concerns a smooth
   projective, possibly disconnected Legendrian `Z in P(V)`,
   `dim V=2n`, and two affine cone components containing a pair with
   nonzero symplectic pairing. It asserts dominance of their addition.
   Graph: none. The source's decisive mechanism is a curve in a
   positive-dimensional addition fiber with constant nonzero pairing;
   a pole gives rescalings with common nonzero limit, forcing the same
   component by smoothness/disjointness. Lagrangianity gives order at
   least 3k, against exact order 2k. The old dossier supplies no proof
   of these curve/completion and diagonal-order steps. Conditional order
   incompatibility is clear, not a finite cubic certificate of this
   lemma. Manuscript pairwise lemma with cited precedents; priority
   unassessed and old proof obligation open.

8. **C_SUITABLE_PAIR.**
   In the primitive case, there exist free lines through one x with
   `d alpha(a,b)!=0` and `P_f1|0 + P_f2|0=F_x`, hence complementary
   Lagrangians (`lines:suitable-pair`, `lines.tex:270--323`).
   Graph: C_LINE_DIRECTIONS, C_CONE_ADDITION, C_POSITIVE.
   Missing old bridges are realizing cone vectors in finite-type
   fixed-value Hom strata, choosing a generic-smooth derivative-sum
   pair, and identifying derivative variations inside the positive
   fibers. The final dimension/isotropy implication is elementary
   conditional on these steps, not their proof. Manuscript
   construction; novelty unverified; old assertion open.

9. **C_FIXED_ENDS.**
   For the specified suitable pair, with the exact source `uv=s` and
   outer sections p,q, `sm:vertical-cokernel` identifies the vertical
   two-value cokernel with `H1(E(-p-q))=T_xX/F_x=L_x`;
   `sm:fixed-ends` forbids a tangent with `ds=1`, `dEv=0`
   (`smoothing.tex:4--43,105--244`).
   Graph: C_SUITABLE_PAIR, C_POSITIVE; the source also needs
   `sm:relative-hom` (45--79). The old dossier does not verify the nodal
   relative-Hom criterion, normalization cohomology, the shared constant
   in the two Laurent expansions over `uv=epsilon`, or the auxiliary
   degree-one horizontality calculation producing the Levi
   contradiction. This is not a claim that no smoothing exists.
   Manuscript argument; novelty unverified; old assertion open.

10. **C_VERY_FREE.**
    This is existence of a particular degree-two immersion g, not a
    splitting theorem for every degree-two map:
    `g*T_X=O(2)+O(1)^(2n)`, full Hom smoothness, submersive two-point
    evaluation and an open positive neighborhood
    (`sm:very-free`, `smoothing.tex:248--326`). Graph:
    C_FIXED_ENDS, C_DETERMINANT. The elementary endpoint is valid:
    surjective two-value evaluation forces all splitting degrees >=1;
    their sum is `2(n+1)=dim X+1`, forcing the displayed splitting,
    whose nonzero O(2) differential is nowhere zero. The old missing
    existence bridge is smoothing the nodal pair and showing the
    smoothing parameter contributes no artificial evaluation direction
    after the explicit product trivialization. These inputs remain
    open in the dossier; no novelty verified.

11. **C_FULL_GERM.**
    Given the above g and `Pic(X)=Z[L]`, `sm:full-germ`
    (`smoothing.tex:331--365`) says the unmarked class-beta stable-map
    stack is smooth with a unique component at [g]; its normalized
    reduced component agrees nearby, and a **full open** of
    `Hom_2(P1,X)` pulls back the original universal family. Graph:
    C_VERY_FREE. Missing old checks are the smooth-source quotient by
    PGL2, identification of class beta with degree two, normalization on
    the smooth locus, and the universal-family pullback. A convenient
    subfamily of conics would not suffice for later jets. Manuscript
    moduli bridge; no verified novelty; old assertion open.

### C. Boundary extension and the moving pair

12. **C_EXT_NORMAL.**
    For normal integral locally Noetherian B and finitely presented
    flat nodal-curve families C_i/B, with each **entire generic fiber**
    smooth geometrically integral, the finite product is integral and
    normal. Height-one points lie over the generic base point or at
    component generic points above a base divisor, with all selected
    curve points relatively smooth (`ext:normal-products`,
    `extension.tex:179--251`). Graph: none.
    The source argues generic-fiber injection/open images, S2 flat
    ascent, the local dimension formula and R1. The old dossier does
    not check those commutative-algebra inputs or their application on
    normal integral stack charts. Merely generic smoothness on an open
    in each fiber is insufficient. Background-style source lemma;
    novelty unassessed; old verification open.

13. **C_EXT_TREES — supported elementary combinatorial consequence.**
    For an **unmarked stable**, connected genus-zero map of total degree
    two for an ample L, the geometric source is one smooth P1 of
    degree two, or two degree-one P1's meeting once, with no contracted
    component (`ext:trees`, `extension.tex:253--272`). The dual graph is
    a tree. Positive components have positive integral degrees, so
    there are at most two. Every leaf must be noncontracted, since an
    unmarked contracted vertex needs valence at least three. A
    nontrivial tree therefore has exactly two leaves and is a path;
    its interior contracted vertices would have valence two, forbidden
    by stability. This proves the assertion. Graph: none.
    No obligation remains at this unmarked ample-degree scope; it does
    not apply unchanged after adding stability markings. No novelty.

14. **C_EXT_CONTACT_ORDER.**
    In the specified proper flat boundary trait over a completed
    strictly henselian DVR, with smooth geometrically integral generic
    source, special degree-one components A,J and node
    `uv=tau^r`, `r>=1`, the contact differential has order >=r at
    **each component generic point** (`ext:contact-order`,
    `extension.tex:274--394`). Graph: C_EXT_TREES, C_EXT_NORMAL.
    The source needs a global generator of
    `e*L tensor omega_C/R` from multidegree (0,0) and cohomology/base
    change; it then writes `eta=h_R m` and uses
    `(u,v) intersect R=(tau^r)`. The last ideal identity follows
    immediately from `Q/(u,v)=R/(tau^r)`, but the global scalar
    reduction and its transfer to component valuations are missing
    from old Argus. It is not a statement of a locally free tangent
    sheaf at the node. Manuscript extension step; no verified novelty;
    old assertion open.

15. **C_EXT_POLES.**
    For the same trait and a contraction phi preserving A and
    contracting J, the differential-to-dualizing section has component
    orders 0,r, and the invariant bivector has orders at least
    `(0,-r,-r,0)` on `A*A,A*J,J*A,J*J`
    (`ext:differential-order`, `ext:pole-table`,
    `extension.tex:396--559`). Graph: C_EXT_TREES, C_EXT_NORMAL.
    Missing old checks are construction of phi by a multidegree-(1,0)
    line bundle; the normalized generic restriction and Weil-divisor
    calculation in `uv=tau^r` giving exactly b_J=r; and order
    preservation on the product DVRs. The J*J estimate requires the
    opposite contraction, not inversion of two vanishing
    differentials in the same model. The displayed cancellation is
    conditional, not an old certificate. Manuscript tensor step;
    novelty unverified; old assertion open.

16. **C_MOVING_PAIR.**
    Under primitive Picard contact Fano setup and the very-free g,
    `ext:moving-pair` (`extension.tex:19--59`, construction 72--642)
    asserts proper integral algebraic Y dominating `X*X`, **both**
    regular lifts and their common contact value, a swap involution,
    and a map from the full nearby `Hom_2*P1*P1` with
    `j*xi=(z-w)^2 theta(h'(z)) tensor theta(h'(w))`.
    Graph: C_FULL_GERM, C_EXT_NORMAL, C_EXT_TREES,
    C_EXT_CONTACT_ORDER, C_EXT_POLES.
    The old dossier proves none of the proper-stack construction,
    normal extension at every divisor, gluing, or coarse descent.
    In particular one must check the coarse functions identity and
    projection formula for bundles **pulled back from Y**, not descent
    of arbitrary stack bundles. Dominance and retention of the full
    family must also be proved. This is a manuscript-proposed
    construction, not an input furnished by local descent; old
    assertion open and novelty unverified.

### D. From descent to contact transitivity

17. **C_DES_FAMILY — supported as a conditional corollary only.**
    `des:family` (`descent.tex:293--331`) needs C_MOVING_PAIR and
    C_DES_DESCENT, with C_FULL_GERM for the full-neighborhood meaning.
    It gives symmetric B and the displayed identity for every nearby
    parametrized degree-two map and **all** source pairs, diagonal
    included. Conditional decisive argument: the swap pullback of B
    and B have identical pullback xi along dominant p, hence are equal;
    pull back `p*B=xi` along j. Regularity of the invariant tensor
    includes the diagonal and infinity. No extra geometric descent
    proof is required for this implication. The actual construction
    and descent inputs are separate unresolved/other-unit obligations.
    The old contact-value context alone, with an arbitrary Y, does not
    supply g or j. Manuscript corollary; no verified novelty.

18. **C_JET_SYMBOL — conditional local inference, not construction of B.**
    Given the full-family identity and the very-free splitting,
    `jet:value-velocity` and `jet:diagonal`
    (`jets.tex:4--112`) give an open set of joint values/velocities,
    `B in I_Delta^2 tensor M` and second symbol `theta^2` globally.
    Graph: C_DES_FAMILY, C_VERY_FREE.
    The source's decisive inference is explicit:
    `H1(g*T_X(-2*0))=0` gives joint jet surjectivity; Taylor expansion
    along an open set of velocities first kills the constant and
    linear symbols, then identifies the quadratic symbol. Only after
    the linear symbol vanishes can acceleration be discarded.
    Connectedness extends the intrinsic symbols. This conditional
    inference is supported at reading level; the old dossier did not
    furnish its full-family and existence inputs. It does not justify
    using only one conic or restricted deformations. No novelty verified.

19. **C_JET_CRITERION.**
    On any **connected compact complex contact manifold**, a symmetric
    global B vanishing twice on the diagonal with second symbol
    `theta^2` generates **ordinary full first jets** of L at every
    point, spans tangent spaces by contact fields and gives
    holomorphic identity-component transitivity
    (`jet:criterion`, `jets.tex:123--348`). No projective/Fano/Picard or
    nondegeneracy-as-a-bilinear-tensor hypothesis is present.
    Graph: none. The missing old standalone argument is the
    symmetry-forced cubic and fixed-second derivative, immersion of
    `beta:X -> P(H0(L))` using Levi nondegeneracy, dualization to actual
    section jets, Hamiltonian gluing and compact-flow transitivity.
    These are the concrete stages of the source proof, not a
    consequence of the descent certificate. Manuscript criterion;
    novelty unassessed; old verification open.

20. **C_CONTACT_TRANSITIVE.**
    For all contact Fano manifolds in the main theorem, the effective
    identity component `Aut(X,F)^0` is connected linear algebraic and
    transitive (`jet:transitive`, `jets.tex:352--375`).
    Graph: C_JET_SYMBOL, C_JET_CRITERION, C_PICARD.
    Conditional transitivity follows from the criterion in the
    primitive case and the standard groups otherwise. Missing old
    checks are those inputs and the anticanonical embedding argument
    making contact preservation closed and placing the holomorphic
    contact flows in the algebraic identity component. Holomorphic
    transitivity alone is not the asserted algebraic-action
    verification. Manuscript conclusion; novelty unverified; old open.

### E. Adjoint classification and the metric application

21. **C_ADJOINT.**
    For smooth connected complex projective contact (X,F) with ample L
    and an **effective transitive connected algebraic** contact action
    of G, `hom:adjoint` (`homogeneous.tex:8--169`) asserts that
    `Lie(G)` is simple and the contact-value map is a contact isomorphism
    to its minimal adjoint variety, preserving L as the hyperplane
    bundle. Graph: none. The source route is radical elimination by
    Borel fixed points, finite polarized moment map, highest-weight
    reduction to one simple coadjoint summand, connected-parabolic
    stabilizer equality, and identification of the original contact
    hyperplane with the symplectic-cone kernel. The old dossier checks
    neither the cited group-theoretic inputs nor these bridges. An
    isomorphism of varieties without the contact/polarization check
    would be weaker. Source homogeneous argument with background
    inputs; priority unassessed and old verification open.

22. **C_MAIN.**
    `thm:main` (`introduction.tex:30--43`; completion
    `homogeneous.tex:171--179`) asserts, for every smooth connected
    complex projective contact Fano of dimension 2n+1, n>=1, an
    algebraic contact isomorphism to a simple adjoint variety,
    identifying the **given** quotient L with its adjoint hyperplane
    bundle. Graph: C_CONTACT_TRANSITIVE, C_ADJOINT.
    The final implication is conditional and straightforward, but the
    primitive-case transitivity and preceding construction were not
    established by old Argus. Standard exceptional Picard models do
    not settle the primitive case. This is the manuscript's proposed
    unrestricted classification, not an independently verified Argus
    result; novelty/priority unverified and old goal open.

23. **C_TWISTOR.**
    For closed connected positive quaternionic-Kahler (M,g) of real
    dimension 4m, m>=2, the positive twistor construction gives a
    compact connected projective contact Fano X of dimension 2m+1;
    `pi1(M)=pi1(X)=0` follows from its S2-bundle and C_SIMPLE_PIC
    (`twistor.tex:9--94`). Graph: C_SIMPLE_PIC.
    The old dossier has no check of the cited integrability/contact/KE
    theorem, Kodaira/GAGA transition, or its applicability to the
    stated holonomy and positivity hypotheses. Once those inputs and
    simple connectedness of X hold, the homotopy-sequence deduction
    is decisive and elementary. These twistor fibers have L-degree
    **two**, not degree one, so they cannot silently supply
    C_LINES_COVER. Source-attributed background; no novelty claim;
    old verification open.

24. **C_METRIC_RECOVERY.**
    Given the preceding positive twistor space and C_MAIN, the complex
    twistor isomorphism is asserted to yield a normalized base isometry
    to a simply connected Wolf model (`twistor.tex:98--122`), with
    scalar normalization `s/[16m(m+2)]` at 17--22.
    Graph: C_MAIN, C_TWISTOR.
    The concrete missing old source checks are the Wolf-model
    correspondence for the resulting adjoint type and LeBrun
    Corollary 3.4 with its standing normalization, including the
    assertion that a complex isomorphism class suffices. One must not
    replace this by an unproved assertion that the chosen
    biholomorphism preserves a prescribed real structure or fibration;
    nor should one add that as a supposed manuscript hypothesis.
    This is a source-attributed theorem application, not old metric
    verification or verified novelty; old open.

25. **C_QK.**
    `thm:quaternionic` (`introduction.tex:98--115`,
    `twistor.tex:98--134`) concerns every closed connected smooth
    Riemannian 4m-manifold, m>=2, of holonomy contained in
    Sp(m)Sp(1) with positive scalar curvature. It asserts homothety of
    the **original manifold** to a compact symmetric Wolf space and
    `nabla Rm=0`. Graph: C_MAIN, C_TWISTOR, C_METRIC_RECOVERY.
    Conditional endpoint: a normalized base isometry yields homothety
    after undoing the two constant scalings; constant scaling preserves
    the Levi-Civita connection and the equation of parallel curvature.
    This does not provide classification or metric recovery, and a
    result only on a universal cover would be insufficient without
    the preceding topology. Manuscript-proposed unrestricted
    corollary; no independently established novelty or old proof.

## Disposition and concrete scope issues

The unit is fully covered as an Engineer retrospective assessment, with
native independent Reviewer acceptance pending. The determinant and
unmarked-tree assertions have short decisive elementary arguments;
several downstream implications have the conditional support explicitly
identified above. This does **not** close the old classification programme.

No contradiction between the exact descent statement and the old
statement/fidelity table was found. No mathematical counterexample or
contradiction to the manuscript is asserted. The concrete issues requiring
resolution before treating the **old programme** as a proof are missing
dependencies/evidence, especially:

* Picard reduction needs the named classification inputs, not merely
  determinant and simple-Picard facts.
* The free-evaluation upgrade cannot supply existence of the initial
  covering contact lines.
* Descent for arbitrary Y does not construct the moving-pair Y, g or the
  full-family map j.
* A local arithmetic or finite polynomial certificate supplies none of
  the boundary-extension, jet, homogeneous or metric-recovery bridges.
* The historical objective's standalone certification/independent
  acceptance condition was never met at main-theorem scope.

These are precise boundaries on the old evidence, not reasons to label
the original manuscript false. They are not instructions to begin a new
manuscript-error search or solve the outstanding classification problem.
