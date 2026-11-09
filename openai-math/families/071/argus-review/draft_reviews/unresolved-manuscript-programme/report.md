# Unresolved manuscript programme and the old overall audit

## Source and meaning of this unit

This is the ledger-only remainder, not an additional hidden proof draft.
It contains ten claim IDs / eleven claim versions from the old
`9000071/research/MATH_STATE.json`; their exact statements, hashes,
assumptions and graph dependencies appear in `DRAFT_REVIEW_INDEX.json`.
Its source statements are the two OpenAI manuscripts dated September 23,
2026, revision `4eaee87548250b2682affda7d05d947c05554bae`, under the
read-only `9000071/research/openai_manuscript/` tree.
All tracked TeX files match the reference manifest's recorded digests.
`K` below means the Koebe manuscript's `build/sections/` directory;
`R` means the rigidity companion's corresponding directory.

The old Argus `proof.md` supplies the path mechanisms, sharp compatible
barrier, radial optimality example and classical comparison assessed
elsewhere. It expressly does not prove the conclusions below.
The gap descriptions concern implications **unsupported by that old
bundle**, not new alleged defects in the original manuscripts.

## Individual mathematical dispositions

| Old claim/version and original locator | Exact scope and concrete remaining bridge |
|---|---|
| **C_PATH_CODING v1-2**, `K/03-barriers.tex`, `lem:path-coding`, 293-395 | For fixed path-system data, allowed tagged codes are standard Borel; domain length, occupation, fixed-weight full/endpoint-omitted costs and specified endpoint/first-arrival/collar restrictions are Borel. The old bundle constructs neither these code spaces nor the required Borel maps. Segment-based measurability of one potential does not establish those assertions. v2 adds `A_ARSENIN_KUNUGUI`; its stated sigma-compact-section projection input has no old independent reading. No theorem about arbitrary Borel projections may be substituted. |
| **C_POSITIVE_LAW v1**, `K/04-laws.tex`, `thm:positive-law`, 56-81 | Failure of barriers below a fixed size, allowing the stated flags/penalties, should produce one probability law with `L2` domain occupation, counting-`ell2` expected visits on the prescribed countable set, `ell2` hit probabilities on all dust, and absolutely continuous tuple laws for every slot/type, with the specified uniform bounds. No measure-family duality/extraction/fusion in the old bundle produces all these simultaneously. The sharp barrier alone gives no such law. |
| **C_SELECTION v1**, `K/05-selection.tex`, `thm:countable-exceptions`, 183-201 | For any compatible countable prior list and positive size threshold, at most countably many dust endpoints fail arbitrarily small compatible barriers in the specified ungated annulus endpoint setting. This requires diffuse-intersection removal and the four-path crossing/countability construction, neither proved by the old local lower-bound-to-barrier argument. |
| **C_STREAMS v1**, `K/06-streams.tex`, `lem:compact-arcs`, 24-106, and `lem:stream`, 112-145 and its continuation | The positive-law input must yield compactly supported simple-arc laws with occupation, hit and generic prior-level controls, then a period-one index-average coordinate with controlled energy, boundary measures and bands, plus compatible band-preserving smoothing. The old real separating barrier constructs none of the arc-law reduction, additive period, index average or boundary distribution. |
| **C_COMPONENT_COLLAPSE v1**, `K/05-selection.tex`, `thm:unmarked-collapse`, 429 onward, and `K/06-streams.tex`, `thm:retained-tests`, 674-824 | Selected tests/marks and conformal finite-transfer limits must collapse unmarked complementary components and identify distinguished marked disks with full limiting components. The old bundle gives no conformal-limit/selection construction or period-test protrusion exclusion establishing this. A real barrier with small norm is not a circle-domain uniformization. |
| **C_RETAINED_TESTS v1**, `K/06-streams.tex`, `thm:retained-tests`, 674-824, and `cor:scalar-retained-tests`, 856 onward | An arbitrary compatible well-ordered countable seed list and mandatory singularity-containing mark set must admit a compatible countable extension and diagonal finite transfers with exact core retention, vanishing tail energy/excess oscillation, component correspondence and persistence under later compatible extensions. The scalar corollary assumes continuous real tests on the quotient sphere that are **smooth on `G`**, have finite Dirichlet energy there, and satisfy the pair-null trace condition. This is the smooth input to, not the full regularity scope of, the companion's scalar-model proposition. None of that diagonal transfer/retention construction appears in the old bundle. |
| **C_SCALAR_MODELS v1**, `R/models.tex`, `def:model` and pair-null condition, 1-36; `prop:models`, 37-40; smooth-to-general reduction, 224-274 | Let `B subset C` be compact and totally disconnected and `G=sphere minus B`. Every finite list `u_i in C(sphere,R)` of bounded real tests with `u_i restricted to G in W^{1,2}(G)` and `area((u_i,u_j)(B))=0` for every `i!=j` should have a normalized conformal model `h(z)=z+b(h)/z+O(z^-2)`, with circle-domain image available. **Smoothness on `G` is not a hypothesis of this proposition.** A model has a finite or countable null family of nonpoint complementary closed Jordan disks, and the prescribed continuous functions `U_i=u_i compose pi_h` belong to global `W^{1,2}(sphere)` with zero gradient almost everywhere on `F=sphere minus h(G)`. The source first treats smooth tests and then uses exact-trace smoothing and zero-trace extension for the full class. Those steps and the smooth model construction are assessed below; they are not established by the old Argus bundle. No countability or conformal-removability hypothesis on `B` is added. |
| **C_KOEBE v1**, `K/00-introduction.tex`, `thm:main`, 9-11 | Every nonempty connected open subset of the sphere is conformally equivalent to a circle domain. The local barrier argument does not assemble countable selection, marked-component identification, retained transfer and conformal limits into such a map. This complete source theorem remains unverified by the old work, not refuted. |
| **C_RIGIDITY v1**, `R/introduction.tex`, `thm:main`, 22-26 | For circle domains `Omega,Omega'`, if `boundary(Omega)` is conformally removable, every conformal equivalence onto `Omega'` is the restriction of a Mobius map. The old bundle supplies neither the required scalar models nor the companion's continuation/conductivity, trace/flux and length-area argument. It does not verify or refute this theorem. |

The generated cross-reference numbers 7.5 and 7.6 for the retained-test
theorem/scalar corollary are not different results: their stable source
labels are `thm:retained-tests` and `cor:scalar-retained-tests` in
`06-streams.tex`. The companion uses `prop:models`.

## Full scalar-model scope and the source's reductions

The source at the revision above separates three logical steps; restricting
the proposition itself to smooth tests would miss the third.

**Smooth retained-test subcase.** The scalar corollary's source domain
contains infinity and a fixed exterior disk. Its tests are continuous on
the quotient sphere, smooth on `G`, of finite energy there, and pair-null
on the dust. In the companion's point-complement setting that quotient
is the source sphere. `R/models.tex` (48-109) imports one shared sequence
of finite circle-domain transfers with exact core agreement, vanishing
tail energy and squared cluster-oscillation sums, contour-side
correspondence, and a normalized circle-domain limit. These simultaneous
retention properties, not just circle-domain existence, are the missing
`C_RETAINED_TESTS` input to the old Argus work.

Even given that input, the source separately passes to models in
`R/models.tex` (111-222). Filling each finite hole by a cluster-interval
constant gives a distributional jump error bounded by
`4*||phi||_infinity*sum_T r(T)*A(T)`. The common radius bound and the
oscillation estimate make that error tend to zero. Weak limits give
a global Sobolev function; energy saturation forces its gradient to
vanish on `F`. This alone does **not** identify prescribed values on
positive-area point dust. The source additionally uses retained
contours, localized excess functions and finer dust covers to identify
the limit with the continuous representative `u compose pi_h`.
The old barrier proof supplies neither this transfer sequence nor
this hole-filling/value-identification argument.

**Exact traces under smoothing.** For a general continuous test with a
`W^{1,2}(G)` restriction, `R/models.tex` (242-259) uses compactly
supported, locally finite partition functions `rho_k` on `G` and local
mollifications `a_k`. The uniform and local gradient errors are bounded
by `eta_k`, chosen with

    eta_k -> 0,
    sum_k eta_k*(1+||gradient rho_k||_2) < infinity.

The product-rule estimate controls the `L2` gradient error of
`hat_u=sum rho_k*a_k`. Each fixed finite set of supports stays away
from `B`; therefore only the small-error tail can contribute near
`B`. This is the source's reason that `hat_u-u` tends to zero there,
so defining `hat_u=u` on `B` gives a bounded continuous test smooth
on `G`, with finite energy and **exactly the same trace at every
point of `B`**. The chart at infinity is included. Thus the
pairwise dust-image condition is unchanged, and the smooth subcase
can be applied to all `hat_u_i` on one model.

This is a coherent conditional reduction under the stated continuity
and Sobolev hypotheses, not a need to assume the original tests
smooth. The old Argus Section 5 uses a related partition/mollification
device for its own chain potential, preserving bands and new
free-point traces. That narrower result is not recorded verification
of this arbitrary prescribed-test reduction or its final extension.

**Zero-trace correction on the target.** The precise additional source
lemma, `lem:zero-trace-extension`, `R/models.tex` (227-240), takes any
closed `F subset sphere` and a continuous real `w` on the sphere
which vanishes on `F`, is locally Sobolev off `F`, and has finite
Dirichlet energy off `F`. It concludes `w in W^{1,2}(sphere)` with
gradient zero almost everywhere on `F`. The supplied proof uses
signed truncations `sign(w)*(|w|-delta)_+`: continuity and zero
trace keep their supports away from `F`; localization, the uniform
gradient bound and uniform convergence allow the weak-limit
argument. No boundary smoothness, countability, or area-zero
assumption on `F` is used. Zero gradient alone would not replace
the zero-value hypothesis.

The final application (260-274) sets
`w_i=(u_i-hat_u_i) compose pi_h`. The source has continuity and
vanishing on all of `F` from exact trace equality and the continuous
collapse map. Local Sobolev regularity and finite energy on `h(G)`
come from the input restrictions and conformal invariance. Applying
the lemma and adding `w_i` to the smooth model's continuation gives
the required continuation for the **original** test. If `B` is
empty the identity is already a model.

**Disposition:** these source smoothing and extension arguments have
been read in their full stated scope; no unsupported implication was
identified in this conditional smooth-to-general reduction. This is
not a new proof or a claim that the old Argus bundle verified either
reduction. Its local barrier results and algebraic certificates do
not supply the smooth retained-test/model input, the
hole-filling/value-identification passage, or independent support
for this general-model conclusion. Accordingly `C_SCALAR_MODELS`
remains unresolved in the old work for the full continuous/Sobolev
class, rather than being silently narrowed to its smooth subcase.

The old graph records the dependency chain
`path coding + barrier -> positive law -> selection/streams ->
component collapse -> retained tests -> Koebe/scalar models ->
rigidity` (with the additional barrier edges retained in the index).
The barrier route bypasses path coding only for its own potential
construction; that does not erase the positive-law route's coding
dependency. These are concrete missing mathematical constructions,
not gaps inferred merely from stale status words or inaccessible sources.

## C9000071 v1: preserve the actual overall judgment

`C9000071` is the old audit mission assertion, not a standalone theorem:
find a certified explicit flaw or independently verify/repair/generalize
the manuscript core with the requested independent certificate.
Old Engineer judgment `judgement-C9000071-c1eba5039ae4` and old Reviewer
judgment `judgement-C9000071-c99785d824ea` are both **inconclusive**.

The later supported sharp barrier and optimality results are stronger
than an account saying nothing was reviewed. They are nevertheless
narrow local arguments with only an algebraic formal core.
`R_AUDIT_SHARP_VERIFICATION`, listing the two local claims as
obligations for the audit, is a recorded plan, not an additional
implication or a Reviewer verdict. Completing its listed local
obligations does not license replacing the explicit inconclusive
overall judgment by full manuscript acceptance.

The old graph marks every node open/reviewer-unconfirmed. For the
local claims, that label is stale relative to the version-matched
supports catalogued in the other reports. For the claims in this
unit, there is no corresponding later support to discharge their
listed constructions. Preserve their unresolved status. There is
no certified false literal source assertion and no justified
`refutes` verdict to manufacture.

**Assessment:** these full statements and the overall audit remain
unresolved in the old work, for the explicit missing bridges above.
This is a completed scoped assessment of an incomplete programme,
not a blanket assertion that the manuscripts are correct or incorrect.
Their novelty is unverified here; no new literature/novelty or
manuscript-error campaign was opened. Current independent review
will decide whether this complete old-draft assessment meets its
contract, not silently prove these outstanding theorems.
