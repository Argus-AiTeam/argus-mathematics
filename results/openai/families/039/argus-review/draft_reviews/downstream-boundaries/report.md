# Downstream boundaries: eight individual dispositions

**Unit:** `downstream-boundaries`. **Assessment:** supported boundary inventory;
the eight historical umbrella/downstream nodes are not discharged by this
source trace. **Reviewer acceptance:** `pending_native_independent_review`.

This is an Engineer assessment, not native independent Reviewer acceptance.
The existing reshaping proof, its proposed strengthening and formal/finite
evidence are assessed in other units. No downstream maximality or Nagata
proof is attempted here.

## Inputs, versions and attribution

The eight claims below are **version 1** in the read-only files
`families/039/first-pass/MATH_STATE.json`
and `research/PROOF_GRAPH.json` in that workspace. Every corresponding
historical graph node is `open`, `reviewer_confirmed=false`. Their
statements and individual obligations are preserved in `verdict.json`.
`C_RS_TRACE` is the separate ninth historical ID covered by
`../companion-trace/`; it is not silently counted as an eighth downstream node.

Historical `9000039/OBJECTIVE.md` was read only as data explaining the old
umbrella goal. It does not supply current instructions. The old report,
`9000039/research/reshaping_audit/report.md:273–311,312–364`, explicitly
separates the construction trace from the main theorems and limits its
formal/finite evidence. Its strongest existing claim, lines 35–52, is
already **`dw<1/3` with mixed-order maximum-rank transfer**. This unit
does not relabel that as a new contribution or weaken the comparison
baseline to `dw<1/16`.

Source correspondence uses the unchanged existing manifest
`campaigns/9100039/MANUSCRIPTS.json`,
revision **`4eaee87548250b2682affda7d05d947c05554bae`**.
The exact staged root is
`families/039/first-pass/openai_manuscript/`;
the used files resolve under
`openai-math/preprints/`
with identical manuscript-relative paths. Abbreviations:

* **PC** = `Maximal-multipoint-Seshadri-constants-in-positive-characteristic-October-5-2026/build/build/sections/`
* **HD** = `Maximal-Multipoint-Seshadri-Constants-in-Higher-Dimensions-October-5-2026/build/sections/`
* **S** = `Maximal-Seshadri-Constants-on-Arbitrary-Polarized-Surfaces-September-23-2026/build/sections/`
* **N** = `Nagatas-Conjecture-for-Plane-Curves-September-23-2026/build/sections/`

| Used source | Actual SHA-256 = existing manifest SHA-256 |
|---|---|
| PC `01-introduction.tex` | `45910663c5b97ba5ae498d807915cf2664fe44a5d325de917076e5993d7a9b95` |
| PC `05-interpolation.tex` | `4fbe829a92c50a297cd05858c3d16000d2e384fa72231bc66294a4276a673677` |
| PC `06-positivity.tex` | `c91f487eb701173bee56c51b4ea6b7710e91c87d14c1ad949a1acb3b320e165b` |
| HD `introduction.tex` | `33a8ab73ea5ea4ac1d5f319fc43a21c2b85bee0b6fbbb9e037694a447cadff0f` |
| HD `flag.tex` | `f24d8726311615f15ab9bd1f1e07dcc6bf7c127266b75980ec7311034341dd0d` |
| HD `saturation.tex` | `0778de3d9717143924314a48fa85a8a0312e8d0e7db7619febe45ca0fdebf0b8` |
| HD `conclusion.tex` | `9fb04a8fa53d48be6f9e2d71a667efd1ce257fc827cb9c49031c436c8c40bf70` |
| S `introduction.tex` | `f662215615f5268a884ee335a8f439571cc84e425acc6a597fef04307d7ca375` |
| S `lattice.tex` | `f7e9fa5f09bf11ab5facdc12639455bd22c1c6c885a947d967202794ec088f43` |
| S `nef.tex` | `05bddfef05a61b6fd7acb382c319688fd73f301642060aff88faa19b7bfbea0f` |
| N `introduction.tex` | `822c7178919fb632b1ba0f59f07f00f17a41c8148a0ecc2916b97cbc331bab3e` |

All eleven files match. Together with the companion unit this is eighteen
unique relevant files, not a rebuilt/extended manifest or a whole-tree
revision audit. No git operation or hashing of unrelated files was used.
The theorem statements were read to identify hypotheses and obligations,
not to assess their proofs.

## 1. `C9000039` — old umbrella goal

**Supported limited statement.** The historical goal was a disjunction:
certify a particular flaw, or independently verify/repair/generalize a
core theorem with a standalone machine-checkable certificate and independent
Reviewer certification. Its historical graph chose the
`C9000039 -> C_RS_STRONG` route. The old report supplies a proposed
generalization and expressly reports no manuscript assertion found false
in that construction. It does not supply a family-wide maximality proof.

**Concrete outstanding obligation.** On the chosen route, the exact
strongest universal claim—arbitrary real intercepts, every positive degree,
algebraically closed fields and mixed-order multipoint maximum ranks—must
be assessed against the actual scope of the prose, formal declarations,
and bounded experiments, followed by native independent acceptance.
A local arithmetic certificate cannot simply be renamed a certificate
of the whole universal theorem. This unit supplies neither a certified
counterexample for the alternative route nor that full certification.
The parent units assess the construction; no adverse mathematical
conclusion is inferred here. Even an accepted core result would not
silently prove the separate manuscript main theorems.

**Attribution/disposition.** Historical Argus umbrella objective and proposed
core generalization; not a new manuscript theorem. Still outside this
unit's supported proof scope. Completing the *current old-draft review*
does not require solving all these downstream theorems; it requires
honestly accounting for their unresolved status.

## 2. `C_PC_MAIN` — positive-characteristic eventual maximality

**Supported limited statement.** PC `01-introduction.tex:11–36`,
**`thm:main`**, concerns a smooth integral projective `X` over an
algebraically closed field of characteristic `p>0`, `n>=3`, ample `L`,
and the **ordinary curve-defined** constant at the geometric generic
tuple over `K_r=overline{k(U_r)}`. It asserts
`epsilon_r=(L^n/r)^(1/n)` for **every integer** `r>=r_0(X,L)`.
PC `06-positivity.tex:141–147`, **`rem:surfaces`**, asserts the same
for `n=2`. This is not restricted to uncountable fields, square point
counts, or an asymptotic limit as `r` increases.

**Concrete outstanding obligation.** Establish the non-reshaping chain
in `C_PC_OTHER`, transfer the resulting finite-degree separation tests
to the geometric generic tuple with the stated field-extension
conventions, and justify the curve inequality for every relevant
integral curve, including singular marked points, plus the matching
volume upper bound. These are separate statements in PC
`06-positivity.tex:12–22`, **`lem:jet-curve-bound`**, and 57–67,
**`lem:volume-bound`**; the final assembly is at 121–139. The dimension-two
remark needs that entire chain with its dimension-two hypotheses,
not merely one successful planar reshape.

**Attribution/disposition.** This is the manuscript's asserted theorem,
not a premise or consequence certified by the old Argus trace.
Unresolved beyond the supported target description.

## 3. `C_PC_OTHER` — PC flag, filling, interpolation and generic transfer

**Supported limited statement.** The immediate cited downstream use is
PC `05-interpolation.tex:116–129`, **`prop:generic-jets`**:
for `n>=2`, ample `L`, sufficiently large `r`, every real
`0<theta<(L^n/r)^(1/n)`, and every sufficiently large `N`,
sections of `NL` separate jets through order `floor(N theta)` at
some distinct `k`-tuple, possibly depending on `N`, and at the
geometric generic tuple after base change. Its next paragraph
(131–163) explicitly iterates `prop:reshape` before filling/interpolation.

**Concrete outstanding obligations.**

* The complete-intersection flag must actually supply the stated
  support bound, graded multiplication, cardinality `h^0(NL)` and
  full leading coefficient `L^n/n!`; PC introduction 131–142 and
  `05-interpolation.tex:131–138` identify this input, not a proof here.
* Full asymptotic density must imply **exact** filling of every fixed
  compact interior region for all sufficiently large degrees, not
  merely the right cardinality: **`lem:interior-filling`**, 13–27.
* The explicit elongated-simplex support must give all required jets
  in the field's characteristic: **`lem:elongated-jets`**, 67–80;
  that support must genuinely lie in the filled region for each
  chosen `theta`. The original `dw<1/16` iteration and a threshold
  independent of `N` belong to this assembly.
* Openness and field extension must yield geometric generic
  separation. The positivity/volume implications above must then be
  supplied. A common intersection of infinitely many opens containing
  a `k`-rational tuple is **not** being assumed over countable `k`.

**Attribution/disposition.** These are the manuscript's identified
non-reshaping dependencies. Their statements, not their proofs, are
supported here; no one of them is discharged by preserving support size.

## 4. `C_COMPLEX_MAIN` — complex higher-dimensional maximality

**Supported limited statement.** HD `introduction.tex:29–39`,
**`thm:main`**, has smooth integral **complex** projective `X`,
`n>=3`, ample `L`. For every integer `r>=r_0(X,L)` it asserts equality
`epsilon=(L^n/r)^(1/n)` outside a countable union of proper closed
subsets of the ordered distinct-point configuration space, with
nonempty complement. It is the ordinary curve-defined constant
(introduction 3–27), not a higher-cycle analogue.

**Concrete outstanding obligation.** Supply the entire chain in
`C_COMPLEX_OTHER`, a common very-general locus for the required finite
tests, the limiting lower bound against all integral curves and the
volume upper bound. A trace of its complex analytic two-coordinate
mechanism, or a separately accepted PC reshape, is not that chain.
In particular, eventual exact equality at each fixed `r` is stronger
than a lower bound merely approaching maximality as `r` grows.

**Attribution/disposition.** Manuscript main assertion; not established
or refuted by the old construction comparison.

## 5. `C_COMPLEX_OTHER` — complex flag, saturation, interpolation, positivity

**Supported limited statement.** HD `flag.tex:24–41`,
**`prop:flag-simplex`**, states the initial simplex, section counts,
gradedness and transfer. HD `saturation.tex:17–32`,
**`lem:interior-saturation`**, 70–83,
**`lem:simplex-interpolation`**, and 120–137,
**`prop:asymptotic-jets`**, state the subsequent full-density and
elongated-simplex assertions. HD `conclusion.tex:75–115` constructs
the common very-general locus, and 117–130,
**`lem:jets-curves`**, states the curve-intersection implication.

**Concrete outstanding obligations.** Verify that the actual flag
has all the claimed dimensions, simplex bounds and cross-degree
multiplication; that repeated real-intercept reshaping has a single
sufficiently-large-point threshold before the degree/jet choices;
that full density yields the needed **specific** interpolation
monomials in every large degree; and that finite surjections hold
on the countable collection of nonempty open loci used to conclude
all-curve positivity and the upper bound. Neither finite sampled
support computations nor the resemblance to the surface method
supplies those universal geometric and interpolation steps.

**Attribution/disposition.** Source-identified dependencies only;
unresolved mathematics outside this source trace.

## 6. `C_SURFACE_MAIN` — eventual maximality for polarized surfaces

**Supported limited statement.** S `introduction.tex:31–44`,
**`thm:main`**, asserts for every smooth integral complex projective
surface and ample `L` a threshold `r_0(S,L)` such that, for every
integer `r>=r_0`, the square-zero class
`pi^*L-sqrt(L^2/r) sum E_i` is nef at very general distinct tuples,
and the Seshadri constant equals `sqrt(L^2/r)`. This is not an
assertion of a universal threshold `r=10` or a strict plane inequality.

**Concrete outstanding obligation.** Supply `C_SURFACE_OTHER`,
including uniform injective tests for **all** positive `k,m` with
`m>k sqrt(H/r)` after `r_0` has been fixed, the common very-general
locus, and the implication to nefness against curves with unequal
multiplicities, plus the square upper bound. S `nef.tex:206–228`
is exactly the old report's downstream assembly, not evidence that
the old trace already checked it.

**Attribution/disposition.** Manuscript main theorem; source statement
supported, maximality unresolved in this review unit.

## 7. `C_SURFACE_OTHER` — actual section geometry, subgroup tests and nefness

**Supported limited statement.** The companion trace confirms the
global nodal-divisor/section-quadrilateral architecture and the
backward **injective** transfer for **full polygon monomial spaces**.
The convention is `O/m^m`, not PC/HD surjectivity onto `O/m^{m+1}`.
The subsequent S `lattice.tex` statements are:

* 22–30, **`lem:triangle-multiplicity`**: a complex Laurent polynomial
  in a real triangle of area `rho^2/2` and vertical range `rho` has
  identity multiplicity at most `rho`;
* 101–113, **`prop:subgroup-test`**: primitive determinant range
  `sqrt(rH)` gives a subgroup of exactly `r` distinct points and
  injectivity for every `k,m` above the slope;
* 204–209, **`lem:direction`**, and 255–264, **`cor:torus-test`**:
  sufficiently large `r` allows the tuned direction and a **single**
  `t,G` chosen before all `k,m`.

S `nef.tex:9–20`, **`lem:jet-open`**, states the common very-general
locus. Lines 107–120, **`prop:homogeneous-nef`**, state that the full
collection of homogeneous nonvanishing tests implies nefness.
Lines 171–177 give **`lem:sesha-upper`**.

**Concrete outstanding obligations.** Independently verify the
integral nodal ample divisor and the global section/intersection
bound (including extracted divisor factors); the triangle
multiplicity estimate, subgroup character decomposition and
index-`r` lattice geometry; the tuning threshold's independence
from unbounded `k,m`; and the very-general/Riemann–Roch argument
turning equal-order tests into inequalities for **all** curves
with possibly unequal multiplicities. Reading those statements
does not prove them. The historical phrase “surface degeneration”
does not make the separate plane elliptic degeneration an input.

**Attribution/disposition.** Identified surface-specific dependencies;
not consequences certified by the sparse-support reshape assessment.

## 8. `C_NAGATA_MAIN` — separate strict plane Nagata assertion

**Supported limited statement.** N `introduction.tex:11–40`,
**`thm:main`** at 31–40, concerns the complex plane and, for **every
integer `r>=10`**, one very-general distinct tuple locus simultaneously
for all degrees and multiplicity vectors. Every nonzero effective
plane curve of degree `d>=1`, including repeated components, with
prescribed nonnegative integers `m_i` bounded by its multiplicities
is asserted to satisfy the **strict** inequality
`d sqrt(r)>sum m_i`.

**Concrete outstanding obligations.** The separate proof strategy
in that introduction, 101–143, requires closed-incidence and
symmetrization reductions for arbitrary multiplicities, the
normal-bundle specialization with nonzero limits, the square-case
strict endpoint, the cubic/elliptic coefficient and collision
constructions for nonsquare `r`, controlled theta-basis limits,
and full column rank of the resulting exponent-diagram matrices
with the integer-endpoint/power argument. None is supplied by the
two-intercept reshaping draft. No proof in the Nagata downstream
sections was attempted. Eventual Seshadri maximality would not by
itself give this sharp `r>=10` threshold and strict endpoint.

**Attribution/disposition.** Separate manuscript theorem and proof
route, neither a premise nor an audited consequence here.
Unresolved, not refuted.

## Evidence and validation boundary

`main-target-excerpts.tex` preserves five exact primary-source blocks
covering the four main statements, geometric generic convention and
PC surface remark. They match their declared source lines exactly.
The companion unit preserves 26 further exact blocks and records the
four source-text assumptions read by `reader:source-trace-engineer`;
all four official attributions returned `supports`, with no source-ID
or assumption corrections needed. Those are readings of text, not
mathematical endorsements.

After those ledger attributions, official checks were run with
`$WORKSPACE/argus-latest/.venv/bin/python` at explicit root
`campaigns/9200039`:

* `-m argus_skill.verticals.math.math_state check --project-root <root>`:
  **exit 0**, `{"ok":true,"issues":[]}`.
* `-m argus_skill.verticals.math.proof_graph_check check --project-root <root>`:
  **exit 0**, `proof graph valid: 12 node(s)`.

These validate active review bookkeeping, not the eight historical
theorems/obligations. No historical input, graph node or status was
changed, and no new active claim was created. Literature archives
were generated only by the requested official citation tool.

The contribution is explicit attribution and a concrete gap inventory,
not novelty, a blanket correctness declaration, a new flaw search,
or a refutation of an original manuscript. Native independent
Reviewer acceptance of the entire old-draft review remains pending.
