# Complete-intersection sewing: completed family-scope disposition

## Result and remit

**Unit:** `complete-intersection-sewing`. **Research target:** exploratory.
**Review-result novelty:** not applicable. **Acceptance:**
`pending_native_independent_review`.

There is **no separate sewing claim, mathematical draft, proof, certificate,
or judgement in the 26-artifact old Argus inventory**. The old localization
report explicitly excludes complete-intersection sewing. This unit is an
explicit, completed disposition of that family scope, not an additional
discovered Argus result. Its reference manuscript contains a conditional
**Tested transport** theorem, a separate **Detection** theorem, and a
complete-intersection main theorem. Those objects must not be conflated.

The disposition establishes the old evidence boundary, not a mathematical
gap in or refutation of those manuscript results. Their validity and final
theorem novelty remain **unassessed**. The obligations below are what a
certification of them would need, not a new proof project required to finish
this old-draft disposition. This Engineer has not independently accepted
the report or theorems.

## Exact sources, version, and attribution

The actual read-only manuscript root read was

`families/065/first-pass/openai_manuscript/Virasoro-Constraints-for-Projective-Complete-Intersections-September-24-2026/`.

The current `PRIOR_DRAFTS.json` selects
`campaigns/9100065/MANUSCRIPTS.json`.
Its expected `source_revision` is
`4eaee87548250b2682affda7d05d947c05554bae`. The paths below are the
actual old reference files read. Global content/version comparison is the
parent's responsibility; this assessment did not rebuild manifests, use
Git, or substitute another manuscript version.

| File relative to the manuscript root | Lines read | Relevant exact statement labels read |
|---|---:|---|
| `build/sections/introduction.tex` | 1–65 | `thm:main` |
| `build/sections/conventions.tex` | 1–101 | `conv:positive-rule`; definition `conv:coherent` |
| `build/sections/sewing.tex` | 1–572 | notation `sew:configurations`; `sew:geometry`, theorem `sew:transport`, `sew:preparation`, `sew:busy-bound`, `sew:idle-equality` |
| `build/sections/firstpage.tex` | 1–180, 468–566 | `fp:pairing`, `fp:first-index`, `fp:local-algebra` |
| `build/sections/evaluation.tex` | 1–125, 282–358, 445–550 | `ev:configuration`, `ev:restriction`, `ev:groups`; scope remark `ev:refinement-not-numerical` |
| `build/sections/caps.tex` | 1–155, 213–234, 283–306, 350–414, 428–571 | `cap:linearization`, `cap:span`, `cap:bounded-rows`, `cap:Q`, `cap:P`, `cap:identity`, `cap:uniform` |
| `build/sections/detection.tex` | 1–80 | definition `det:setup`; `det:operations`, `det:norm`, theorem `det:detection` |
| `build/sections/induction.tex` | 1–278, 280–355, 380–522 | `ind:toric`, `ind:blowup-data`, `ind:degrees`, `ind:deformation`; main proof at `ind:complete` |

This is bounded source reading to identify the statements, their
hypotheses, and immediate logical dependencies. In particular, reading
partial proof passages is not a claim to have audited all their arguments
or the cited external theorems.

The old Argus evidence inspected was
`families/065/first-pass/MATH_STATE.json`,
`families/065/first-pass/PROOF_GRAPH.json`,
the scope conclusion of
`families/065/first-pass/family_orbit_localization/report.md`
(lines 648–656), and
`families/065/first-pass/family_orbit_localization/statement_fidelity.md`.
The inventory and current initial coverage index were read without
modification. `C9000065` is the old umbrella audit objective, not a separate
sewing theorem or current task instruction.

## 1. The manuscript's main theorem and operator normalization

`introduction.tex`, Theorem `thm:main`, asserts:
if \(X\subset\mathbb P^N_{\mathbb C}\) is a smooth complete intersection,
its **ordinary, unreduced total descendant potential** satisfies the
Virasoro constraints in every genus and curve class, with arbitrary
insertions from \(H^*(X;\mathbb C)\). Primitive and odd insertions are
included; there is no semisimplicity hypothesis. The final induction also
treats zero-dimensional complete intersections as disjoint unions of
points. The statement is not restricted to the ambient theory or very
general smooth members.

In `sec:conventions`, with \(n=\dim_{\mathbb C}X\),
\[
 Z_X=\exp\!\left(\sum_{g\geq0}\hbar^{g-1}F_g^X(t)\right),\quad
 \mu_X|_{H^{p,q}}=(p-n/2)\mathrm{id},\quad
 \mathcal R_X=c_1(TX)\cup,
\]
\[
 \ell_0=z\partial_z+\tfrac12+\mu_X+\mathcal R_X/z,\qquad
 \ell_k=\ell_0(z\ell_0)^k\quad(k>0).
\]
The pairing is Poincaré, the inverse pairing is categorical with Koszul
signs and no second parity involution, and normal ordering is followed by
\(q=t-z1_X\). Ordinary marked-map cotangent lines, not ancestor lines,
are used, also in the relative theories. Positive modes have no central
scalar. The nonpositive modes use the ordinary string operator and
\[
 C_X=\chi(X)/16-\operatorname{str}(\mu_X^2)/4.
\]
The manuscript invokes the string equation and
\([L_1,L_{-1}]=2L_0\) to supply the nonpositive equations after positive
ones are known. `ind:central-normalization` records the same first-Hodge
constant in Chern-number form.

All claims are coefficientwise at fixed genus powers, finite insertion
orders and bounded degrees. Multiple replicas have independent genus and
curve variables. The intermediate transport conclusion is selected by
**coherent numerical divisor degrees**; the passage to each curve class
is an additional assertion of `ind:degrees`, not part of sewing alone.

**Attribution:** this is the reference manuscript's main theorem, not an
Argus result in the inventory. No independent certification or novelty
conclusion for it follows from this disposition.

## 2. The exact sewing theorem: Tested transport

### Geometric hypotheses and short targets

Theorem `sew:transport` is named **Tested transport** in the section
**Transport by capped chains**. It uses either configuration of
`sew:configurations`. All chain targets have complex dimension \(n\).
The seam \(D\) is smooth projective, possibly disconnected, and \(N\) is a
line bundle. In the lines convention put
\[
 C=\mathbb P_D(\mathcal O_D\oplus N),\qquad
 D_l=\mathbb P_D(N),\quad D_r=\mathbb P_D(\mathcal O_D),
\]
with respective normal bundles \(N^{-1}\), \(N\). The chain is
\(U\mid C_1\mid\cdots\mid C_m\mid V\). A surgery separates an internal
junction and attaches a right cap \(Q\) on the left and a left cap
\(P=(C,D_r)\) on the right.

* **Ordinary configuration.** \(X\) is a smooth fiber of a given
  projective degeneration with smooth total space and central fiber
  \(U\cup_D V\); the smooth ends have dual seam normals.
  \(N=N_{D/U}\), \(Q=(C,D_l)\). The three short smooth target types are
  **\(U,C,V\)**.
* **Blowup configuration.** \(S\subset M\) is a smooth center of
  codimension at least two,
  \(U=\operatorname{Bl}_S M\),
  \(D=\mathbb P_S(N_{S/M})\), \(N=\mathcal O_D(-1)\), and \(V=C\).
  The main smooth target is \(\operatorname{Bl}_S M\). The right cap is
  \((Q,D)\) with absolute space
  \(Q=\mathbb P_S(N_{S/M}\oplus\mathcal O_S)\). The three short target
  types are **\(M,Q,C\)**. Empty centers can be omitted.

The smooth projective setting is as in the manuscript's conventions.
Lemma `sew:geometry` asserts semistable realizations with smooth total
spaces for long chains and all capped subchains, bipartite colorings
without triple intersections, and compatible local component/stratum
and boundary normal data away from surgeries.

### Coherent tests and degree hypotheses

The singles in a test must be coherent in `conv:coherent`'s sense:
restrictions agree on common component and stratum diagrams, including
Hodge shifts. They are extending algebraic classes (and complex linear
combinations), or fixed homogeneous cohomology inputs from smooth
projective sources via algebraic correspondences extending over the total
families and inducing flat Hodge maps on smooth loci. Source slots remain
exposed until specialization. A merely topologically extending class, or
an arbitrary flat Hodge correspondence without the specified algebraic
extension, is not asserted to suffice. End-supported classes have zero
restriction on segments not containing that end.

The coherent Chern-class operation is
\(-c_1(\omega_{\mathcal Y/\Delta})\), restricting to
\(c_1(TY)-[\partial Y]\) on a component. It is not silently replaced by
ordinary \(c_1(TY)\) on each component.

The integral counting degree is nonnegative on effective contributions.
Ordinarily it comes from a relative polarization ample on the original
ends and pulled back from \(D\) on necks/caps. In the blowup case it is
pulled back from an ample class on \(M\), then from \(S\) on bundle
pieces, and need not itself be ample on a bundle piece. Extra coherent
divisor degrees may be retained with invertible fugacities. In the
blowup case the degree at the final nonjoining \(D_r\subset V\) is
retained componentwise as necessary and is not charged to inserted caps.
The nonjoining \(D_l\)-degree conditions at inserted \(P\) caps are
separate. The contact flux is
\(k_r-k_l=\int_\alpha c_1(N)\), not a positivity assertion about every
nonjoining section degree.

### Exact conclusion

Assume **all three short target types** satisfy the full absolute
Virasoro constraints in every genus, curve class and cohomology
insertion. For every \(k>0\), every finite number \(s\geq1\) of
independent replicas, and every admissible finite homogeneous tensor test
\(\mathsf T\), Theorem `sew:transport` asserts that every coefficient of
\[
 \mathsf T\!\left(
   (L_{k,X}^{(1)}Z_X^{(1)})
      \otimes\bigotimes_{r=2}^{s}Z_X^{(r)}
 \right)
\]
vanishes, selected by the coherent degree data, including the final
exceptional degrees. Admissible tests use coherent singles, functions of
first Hodge degree, cups, classical integrations, categorical
coevaluations between arbitrary slots, and ordinary GW amplitudes in
the other replicas; their exposed arities and descendant orders are
fixed and Hodge types balanced.

Only replica 1 is acted on, **before** the test or auxiliary descendant
extraction. The operator also acts on auxiliary cap labels in that
replica, but not on external inverse-cap coefficients or on another
replica. The relative theories in the construction are ordinary
relative GW theories; **relative Virasoro constraints are not an
input**. The theorem initially proves tested positive errors, not an
unconditional identity for each primitive tensor or each individual
curve class. It expressly does not identify individual homology lifts
across different smoothings.

**Attribution:** the manuscript's conditional tested-transport theorem.
There is no corresponding old Argus claim ID or certificate.

## 3. Immediate logical dependencies, not certified old results

1. **Finite positive coefficient rule.** `conv:positive-rule` expresses
   an operator coefficient by finitely many unit, single-slot, paired
   new-slot, and classical two-removed-slot operations. At most two
   existing labels are modified nonordinarily. This is what bounds
   exposed positions independently of the number of ordinary cap
   markings.

2. **First-page cohomological locality.** `fp:pairing` supplies a perfect
   chain pairing with closed categorical inverse supported at vertices
   and edges; `fp:first-index` says the Tate-adjusted first Hodge index
   commutes with the differential. Proposition `fp:local-algebra`
   requires the extending, assignment-sensitive evaluation rule and
   coherent tests, and claims an expansion in bounded incidence
   neighborhoods unchanged by distant surgeries. It is a
   cohomological-locality statement, not virtual factorization of groups
   of maps. Its proof invokes graded scalar limits and multiplicative
   comparison/trace; those cited inputs are not independently certified
   by this reading.

3. **Evaluation correspondences, before integration.** In the two-sided
   projective semistable setting, `ev:configuration` constructs the
   aligned configuration spaces. Proposition `ev:restriction` asserts
   an actual extending correspondence \(\Gamma_I\) and its restriction
   to an individual recorded side/component assignment. It retains
   joint relative evaluations and refined diagonal pullbacks, with
   labelled-root factor \(\prod c_j/r!\).
   `ev:refinement-not-numerical` explicitly distinguishes this from a
   numerical degeneration formula. Proposition `ev:groups`, for
   ordinary relative pairs rather than rubber theory, asserts virtual
   product under separation of labelled source-component groups while
   preserving the **joint** evaluation of retained groups and ordinary
   cotangent lines. Unrecorded groups may then be preintegrated.
   Numerical reconstruction alone, or replacing joint evaluations by
   products of marginal ones, does not supply these statements.

4. **Full bounded cap identity.** `cap:linearization` and `cap:span`
   use a nonzero fiber scalar attributed to HLR and disconnected
   spanning, including empty profiles and odd labels.
   `cap:Q` realizes all functionals on the bounded incoming contact
   space; `cap:P` prepares prescribed states on the whole outgoing
   space with unwanted profiles canceled. Proposition `cap:identity`
   equates the capped kernel with original contact gluing on
   \(\mathcal F_{\leq H}(D)\) against every outgoing state modulo
   \(q^{d+1}\), also after tensoring an external graded space and
   separately per replica. On ordered roots of orders
   \(e_1,\ldots,e_\ell\), gluing includes
   \((\prod e_i)\hbar^\ell\), categorical coevaluation and the prescribed
   finite permutation quotients, not a squared gluing weight.
   `cap:bounded-rows`, `cap:uniform`, and `sew:preparation` assert
   effective-degree, outgoing-contact, fugacity and Laurent-genus
   finiteness. Zero-counting-degree exceptional corrections decrease
   contact and are not discarded. The bounds survive the operator's
   allowed auxiliary-label modifications.

5. **Grouped switch cancellation.** `sew:busy-bound` bounds busy
   switches uniformly in chain length, contact bounds and auxiliary
   row arities. Lemma `sew:idle-equality` equates cut/capped and uncut
   **summed correspondences** at an idle switch using the evaluation
   group product and cap identity, with retained aligned evaluations
   and cotangent lines. Toggling the first idle switch cancels
   \(\sum_A(-1)^{|A|}\mathcal E_A\). Every nonempty subset smooths to
   \(U\amalg C^{\amalg(|A|-1)}\amalg V\) ordinarily, or
   \(M\amalg Q^{\amalg(|A|-1)}\amalg C\) in the blowup case, whose
   full constraints are hypotheses. The cancellation is not a
   bijection of individual maps or individual inverse-cap rows.

6. **Detection is a separate theorem.** A detection subspace
   (`det:setup`) is a real rational Hodge substructure \(B_0\), spanned
   by homogeneous coherent admissible \((j,j)\)-singles, nondegenerate
   for integration, containing all nonmiddle and nonprimitive middle
   cohomology. Then \(J=B_0^\perp\) is primitive middle cohomology.
   `det:operations` supplies primitive coevaluation and second-index
   operations; `det:norm` realizes an error tensor's positive
   Hodge–Riemann Hermitian squared norm as admissible scalar tests.
   The conjugate coefficient rule is expanded as ordinary GW
   amplitudes in a second replica, not assumed to be another
   annihilated constraint. Theorem **Detection**, `det:detection`,
   concludes \(L_k^XZ_X=0\), \(k>0\), for all cohomology inputs and
   the curve classes distinguished by the degree tests, if every
   admissible tested positive coefficient vanishes. There is no
   bound on the number of primitive insertions.

7. **Main-theorem assembly is additional.** `ind:blowup-data`
   supplies the detection subspace for the codimension-two blowups
   in this application; `ind:degrees` asserts sufficient coherent
   degree separation, with exceptional-surface and exceptional-divisor
   qualifications. `ind:deformation` asserts passage from very general
   to all smooth members for locally transported classes. The
   dimension/degree induction in `ind:complete`, together with the
   base cases, bundle input, and ordinary nonpositive equations, is
   the asserted bridge to `thm:main`. Tested sewing alone is not that
   complete bridge.

## 4. Which projectivization transfer is actually imported?

The relevant actual source does **not** make the arbitrary-bundle
October projectivization theorem the supplied proof of sewing.
The introduction and `induction.tex`'s subsection **The toric bundle
input with the first Hodge grading**, Proposition **Toric bundle
transfer**, label `ind:toric`, invoke **Coates–Givental–Tseng (CGT)**.
Its bundles are smooth projective toric quotients of sums of line
bundles over a smooth projective base, including projectivizations of
sums of line bundles and their towers.

The manuscript's `ind:toric` argument explains the first-Hodge
adjustment from half-total degree using Hodge difference, at auxiliary
base parameter \(\tau_B=0\) and Hodge-neutral toric divisor parameters,
with the super quantization cocycle and `ind:central-normalization`.
It does not simply identify the total-space zero-mode constant with
the number of fiber fixed points times the base constant. These are
source claims and an external input, not checks supplied by the old
localization cluster.

The actual application is explicit in `ind:complete`:

* Splitting one defining degree \(d_r=a+b\) gives the resolved
  degeneration \(U\cup_D\widetilde M\), with
  \(\widetilde M=\operatorname{Bl}_S M\), and
  \[
    N_{S/M}=\mathcal O_S(a)\oplus\mathcal O_S(d_r)
    \quad\text{(`ind:split-normal`).}
  \]
* The blowup step needs short targets
  \(M,Q_S=\mathbb P_S(N_{S/M}\oplus\mathcal O_S)\), and
  \(C_E=\mathbb P_E(\mathcal O_E\oplus\mathcal O_E(-1))\),
  where \(E=\mathbb P_S(N_{S/M})\).
  Their bundle constraints come from the already treated \(S\) and
  `ind:toric`, because this normal bundle splits into line bundles.
* The ordinary step needs \(U,\widetilde M\), and
  \(C_D=\mathbb P_D(\mathcal O_D\oplus N_{D/U})\).
  The ruled neck is again supplied by `ind:toric` over \(D\).

General `sew:transport` allows a nonsplit normal bundle in its blowup
configuration but **assumes**, rather than derives, the full constraints
of its short targets. In this complete-intersection induction the
needed bundles are split. No invocation of the October arbitrary-bundle
`thm:main` occurs in the relevant transfer/induction passages read.
Consequently the current index's `depends_on_units:
["projectivization-transfer"]` is a family-scope association, not
evidence that this version logically requires certification of that
stronger theorem. The index is left unchanged as instructed.

## 5. Decisive old evidence and concrete certification obligations

The 26 artifacts are the localization report, ledger/graph, finite
symbolic/Lean material, source summaries and supporting/duplicate files.
The inventory has no separate sewing result; the old ledger has no
sewing claim or version and therefore no bound assumptions,
certificates or judgements for it. The graph has no sewing theorem
node. The five `C_PROJ_*@1` nodes are all open and
`reviewer_confirmed=false`, with no bound evidence; they cannot be
promoted into a sewing proof. `C9000065`'s umbrella wording does not
fill that absence.

The old report's final sentence excludes “the final Virasoro-transfer
theorem and complete-intersection sewing.” Its simultaneous
fundamental-solution/ancestor common-\(R\) localization result concerns
the particular projective completion \(W\), not the capped-chain tested
transport theorem. The finite-moment fidelity note formalizes even
nilpotent-resolvent and linear/multilinear moment algebra, not
semistable Hodge complexes, extending evaluation correspondences,
relative caps, switch cancellation, primitive positivity, or the
complete-intersection induction. All-genus localization is **not**
therefore an all-genus sewing proof.

To certify the manuscript claims, rather than merely dispose of their
old evidentiary status, the following bridges would need assessment:

1. Establish the exact extending, assignment-sensitive evaluation and
   retained-group virtual product statements, with source labels,
   contact factors, ordinary cotangent classes, and disconnected/empty
   cases. A numerical degeneration identity alone is insufficient.
2. Establish the Hodge-graded first-page locality and trace comparison
   for the allowed coherent tests, including their compatibility across
   surgeries. Finite even-algebra naturality alone is insufficient.
3. Certify the full incoming/outgoing cap preparation, empty-profile
   normalization, external coefficients, and simultaneous degree,
   contact and Laurent-genus bounds for every subset and permitted
   operator action.
4. Establish the uniform busy-switch bound and equality of grouped
   correspondences at idle switches, then their signed cancellation
   under the stated short-target hypotheses.
5. Verify the detection hypotheses and admissibility of the positive
   Hermitian-square tests, including parity, conjugation, and arbitrary
   primitive arity.
6. For the main complete-intersection theorem, establish the exact CGT
   split-bundle/first-Hodge input, detection subspaces, strict induction,
   degree separation and deformation statements, and normalized
   nonpositive equations. Certifying only an arbitrary-bundle
   localization identity would not discharge these obligations.

These are **unassessed certification obligations**, not newly found
failures in their manuscript proofs. There is no associated sewing
checker or Lean theorem in the old inventory to replay. Replaying a
localization checker could not validate the different objects above.
No new mathematical search, repair, proof, or novelty claim has been
undertaken, and no old independent sewing review is invented.
There was **no access blocker**.

The final disposition is complete: **no old Argus certification of
sewing or the complete-intersection main theorem; exact manuscript
claims and their separate logical bridges identified; theorem novelty
unassessed; native independent review still pending**.
