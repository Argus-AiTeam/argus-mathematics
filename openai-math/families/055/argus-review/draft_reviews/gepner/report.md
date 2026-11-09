# C55_GEPNER_VERIFY: assembly, scope, and attribution

**Engineer assessment: `conditionally_supported_written_proof`.** Read as
one dependent construction with its explicit geometric assumptions, the
current written argument supports the claimed normalized Gepner stability
condition. The compiler receipt supports only its algebraic component.
This is not native acceptance, a novelty finding, a manuscript refutation,
or completion of the historical two-manuscript family audit.

## Exact claim and versions

For every smooth complex quintic `X`, with
`Phi=T_OX o (- tensor OX(1))`, the old report claims a numerical
Bridgeland stability condition `(Z,P)` on `D^b Coh(X)` such that

```text
Z(Phi E)=exp(2*pi*i/5)*Z(E),  Z(O_x)=-1,
Phi P(phi)=P(phi+2/5),       P(phi+1)=P(phi)[1],
norm([E])_2 <= 30000000*abs(Z(E)) on nonzero semistables.
```

The claim includes finite HN filtrations, support on the full numerical
group, both endpoint conventions, and local finiteness. The proposed
quantitative additions are comparison radius `1/4000`, refinement radius
`1/500000`, and the displayed support constant. The separate sufficient
range `0<u<13/46` concerns aisles only.

Historical C55_GEPNER_VERIFY versions 1--4 have the same natural statement.
Version 2 records `XU_1_3`; version 3 also records `PHI_PERIOD`; version 4
also records `STANDARD_GEOMETRY`. These are corrections to the visible
dependency accounting, not four proofs or four increasingly unconditional
theorems. The current review records those dependencies before assessment.

The source is the read-only old `research/gepner-aisle-audit/report.md`,
sections 1--10. Its supplied reference manuscript, at revision
`4eaee87548250b2682affda7d05d947c05554bae`, already states the normalized
Gepner theorem and supplies the double-tilt/grid proof. The old report is
a reconstruction with proposed quantitative improvements relative to
that version. No broader priority search was done, and its own bounded
unsuccessful search for an abstract perturbed-aisle theorem proves no novelty.

## What the assembly actually uses

The source's normalized eigencharge is equivalently

```text
Z(r,c,d,e)/5 =
  -uG*r/2-(uG+1/12)*c-d/2-e + i*t0*(d+c/2+uG*r),
t0>0,  t0^2=3/4-uG.
```

The exact checker confirms its eigenvalue identities; the point class
`(0,0,0,1/5)` gives `Z(O_x)=-1`. Uniqueness is read with the
source's normalization of the eigenform. This numerical calculation does
not construct a slicing.

The actual logical order is:

1. **Aisles:** noetherian first hearts and explicit high/low torsion pairs,
   strict slope separation, and the twist triangle give independently
   varying actual aisles.
2. **Refinement:** simultaneous middle-heart tests, the combined endpoint
   estimate, zero-class exclusion, and categorical periodicity give the
   explicit fifth-step grid.
3. **Blocks:** perturbed preceding hearts give full numerical support;
   bounded truncations, saturated refinements, and positive projections
   give finite HN, endpoint cuts, and locally finite interval categories.

The [aisles](../aisles/report.md), [refinement](../refinement/report.md),
and [blocks](../blocks/report.md) assessments check these implications
in prose. They are conditional links in this chain, not independent
establishments of the final theorem. The [core](../core/report.md)
assessment checks exact algebra and the historical formal repair.
Its exact counterexample to the false version-1 scalar lemma does not
refute the repaired endpoint argument.

## External assumptions and old procedural metadata

The primary-source reader separately retrieved the precise cited versions:
Xu **arXiv:2511.21288v2, Theorem 1.3**, with all the sheaf hypotheses
and normalizations; and Toda **arXiv:1305.0345v3, section 3.3 after
(13)**, for the ordered categorical functor relation. Both passages
support the stated propositions. Their proofs remain external.
The coherent-sheaf/derived/Serre/Weak-Lefschetz/HRR package is explicitly
source-only background, not a newly checked collection of literature
theorems. See [the source readings](../sources/sources.json).

All **15** inherited ledger evidence records are accounted for in the
coverage index: three mechanical compiler records, five Engineer
judgements, two literature records labelled `reviewer:copilot-cli`,
and five judgements bearing that same reviewer label. The report still
says citation/fidelity review is pending, while the old graph leaves
every node open with `reviewer_confirmed=false`. These procedural
representations cannot be silently equated. The label is recorded as
historical attribution, not authenticated as the native Host acceptance
required now. No historical Host acceptance receipt is among the 26
listed artifacts.

The current source readings are not registered using `citation_check
attribute`: that command writes to `research/literature/`, outside this
mission's owned paths. The current ledger therefore does not pretend
its citation queue was cleared by an unofficial replacement. Source
passages and a separate reader's report are available for the native
Reviewer; this is a scope-stage handoff, not final mathematical delivery.

## Supported result and remaining boundary

Relative to the explicit external premises, no unresolved internal
mathematical step was identified in the current written chain. The
comparison, refinement, and support bounds check with their exact
quantifiers and coordinate norm. The current source's statement fidelity
is algebraic, not categorical. No formal proof of the full construction
is supplied or implied.

The historical family wrapper C9000055 also named **Prescribed large-volume
charges on threefolds with trivial canonical bundle**. The report
expressly makes no assertion about that manuscript; its linked directory
is a reference input, not an omitted second Argus proof draft. Version
binding of those nine reference files is not a substantive review.
This assessment neither verifies nor refutes that manuscript.

The strongest retained prior result remains the version-3 algebra plus
the conditional written Gepner construction and its proposed constants.
The present review adds version-specific diagnosis and independent
replay, not an improved mathematical bound or an independently accepted
new theorem. The numerical-only certification route remains retired.
The required native Host Reviewer must judge both coverage and substance.
Separately, the mandatory campaign graph check currently cannot pass:
the graph is absent and its path is outside Engineer ownership.
