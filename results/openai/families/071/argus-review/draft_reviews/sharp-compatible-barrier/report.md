# Sharp compatible barrier and analytic inputs

## Claims, sources and provenance

The reviewed Argus argument is `9000071/research/tagged_jump_audit/proof.md`,
Sections 4-5, preserved digest
`13bd5180e0de0dda9999506bb95f3aa5e2503003926553b4298a3309b23254ca`.
The reference is OpenAI's September 23, 2026 Koebe manuscript at revision
`4eaee87548250b2682affda7d05d947c05554bae`: `01-topology.tex`,
`def:coordinates`, `def:compatibility`, `lem:level-continua`,
`lem:trace-null`; and `03-barriers.tex`, `def:endpoint`,
`def:path-system`, `thm:barrier` (193-215).
All 22 reference-manifest TeX files across both manuscripts match that
revision's recorded digests; this is source fidelity, not proof validation.

**C_SHARP_BARRIER, versions 1-2.** Fix the full compatible countable prior
list, allowed tagged path system, atomless measure, earlier laws, finite
deletions, null tuple exclusions and endpoint/gate data. Dust is compact
and totally disconnected in the quotient sphere; physical collars are
smooth. Let nonnegative Borel `g` belong to `L2(G)` and satisfy `g>=c0>0`,
and let nonnegative `m` belong to counting `ell2(B)`. Every allowed gated
path from `E` first arriving at `b` at its final time must have cost at
least 1 with only its final toll omitted.

For **every `kappa>1`, `eta>0`**, the claim produces a smooth barrier with
finite total energy, `0<=u<=1`, `u=0` on `E_*`, `u=1` on some prescribed
collar, budget `a_u=kappa*m`, and full compatibility (P), adding only
`supp(m)` to the flags. Its controlled size is

    ||du||_{2,G\O} + ||a_u||_ell2
        <= kappa*(||g||_2+||m||_ell2)+eta.

`O` is empty without gates; with gates its closure misses `E` and its
`f0`-image misses `W1`. Energy inside `O` remains finite.

The infimum-coefficient-1 consequence allows arbitrary positive additive
error and `a_u=(1+o(1))*m`. It does **not** assert attainment at `kappa=1`
or prescribe exactly `a_u=m`. **C_BARRIER v1**, the original coefficient-8
claim with `a_u=4m`, follows by choosing `kappa=4`; the resulting
coefficient-4 bound is already stronger than the required 8.

**C_POTENTIAL_ACL v1** is the direct analytic lemma: a bounded, initially
not assumed measurable real function satisfying every contained segment
bound by a nonnegative Borel locally `L2` density is completed-Lebesgue
measurable, lies in local `W12`, and has weak gradient norm bounded by
that density. **C_LEVEL_GEOMETRY v1-3** states generic finite physical
level length, a finite disjoint-continuum bound at every positive quotient
diameter, countably many nondegenerate components, locally connected
subcontinua with the stated arc property, and the weighted coarea/band
incidence bound. These are supporting arguments, not additional
independently discovered barrier theorems.

## Assessment of the decisive implications

**Measurability and sharp gradient.** In a compact rectangle, choose a
countable dense collection of vertical lines on which the density is
integrable. The segment inequality makes the actual function absolutely
continuous on each chosen line. Its piecewise-column samples are Borel.
On almost every horizontal row, the same inequality gives continuity
and convergence of those samples to the actual function. Exceptional
rows form a planar null set, yielding completed measurability even for
arbitrary values there. One-dimensional integration by parts and Fubini
give the weak partial derivatives. Repeating in a countable dense set
of directions and using uniqueness of weak derivatives gives one common
null set and `|gradient v|<=h`, not only `sqrt(2)*h`. This actually avoids
the unresolved path-coding assertion; it does not prove it.

**Finite collar and gates.** Failure of a `1-delta` lower bound on every
finite collar would yield first-hit truncated paths approaching `b`.
The one-ended splicing construction, with collars between prescribed
hit curves, would give an allowed gated first-arrival path costing less
than 1. The contradiction is strict because the splicing error is less
than `delta`. For gates, the finite bad-hit set
`F=union_{j<=k}(C_j \\ f0^{-1}(W2))` is compact in `G` and lies away
from the permitted `W1` image. A relatively compact penalty neighborhood
and density `1_O/dist(F,sphere\\O)` charge at least one unit to a path
reaching `F`; dust cannot bypass this compact physical-domain crossing.
Thus `g1=g+h` gives the needed unrestricted finite-collar lower bound
and still equals `g` outside `O`.

**Jump distance and pointwise bands.** With
`delta=(kappa-1)/(4*kappa)`, the losses `delta/2^(j+1)` total
`delta/2`. Every finite chain uses only finitely many levels, so the
lower bound remains above `1-2*delta`. The exact margin
`kappa*(1-2*delta)-1=(kappa-1)/2>0` gives value 1 inside the target collar
for `v=min(1,kappa*D)`. A jump disk misses the separating collar and
cannot cross its two sides. True-path concatenation and reversal give
the cost bound for `v`, including extended-distance cases.

For each fixed dust point `s`, the set
`{r:m(r)>=m(s)+zeta}` is finite. Since both mesh and neighborhood radius
tend to zero, these competing atoms eventually miss the disk near `s`.
Its toll has limiting upper bound `m(s)`. Disk oscillation control
therefore bounds the actual band at **every** `s` by `kappa*m(s)`.
This is stronger than an almost-everywhere trace assertion, and is what
justifies adding only the countable positive support to the flags.

**Smoothing.** Local positive convolution and a positive partition of
unity preserve `[0,1]`. Summable local value and derivative errors give
global derivative error below `eta`. Sampling neighborhoods small
relative to their distance from dust shrink to each approached dust
point, so the smoothed bands lie in the actual original bands. Patches
meeting `E_*` or a sufficiently deep collar sample only constant
regions; the required 0 and 1 values are exact. These are essential
checks: a generic Sobolev approximation alone would not guarantee
bands, free traces or endpoint constants.

**Compatibility, not just energy.** Weighted smooth coarea and band
incidence give a finite measure on a generic prior finite level union,

    nu = 1_{H intersect G}*g1*H1_sph
           + sum_{s in H intersect B} m(s)*delta_s.

The integrated bound is finite by Cauchy-Schwarz. A compact core and
boundary bumping force every continuum of quotient diameter at least
`eps` to spend a uniform positive physical length in `G`. Disjoint
continua therefore have finite cardinality at each scale. Infinitely
many components of a small closed-ball intersection approaching its
center would violate the same bound, proving local connectedness.
Countability of nondegenerate components follows by scales.

Simple arcs in these components are allowed with the fixed permitted
tuple and have finite domain length; injectivity makes their
per-visit cost at most `nu` of their image. Approaching new free dust
endpoints along domain points yields the trace oscillation bound
`kappa*nu(arc)`. The free dust set has `nu`-outer measure zero.
Cover it by relatively open sets of arbitrarily small measure;
their countably many arcwise-connected components give a null
real trace image, hence a null circle image. The compact-continuum
witness relation is Borel before projection and analytic afterwards;
universal measurability and completed Fubini convert the null sections
to the product-Haar nullity required by (P). Countably many finite
types, including repeated prior labels, suffice. Merely producing
an energy-controlled separating function would not establish this step.

## External assumptions and version reconciliation

The natural statements and claim/context digests are unchanged across
the analytic versions; the old ledger adds explicit dependencies:

| Claim versions | Dependency bookkeeping |
|---|---|
| `C_LEVEL_GEOMETRY` v1 | No external assumption was yet recorded; not evidence of an assumption-free proof. |
| v2 | Adds `A_SMOOTH_COAREA`. |
| v3 | Retains coarea and adds `A_LC_ARCS`. |
| `C_SHARP_BARRIER` v1 | No explicit analytic-measurability assumption yet recorded. |
| v2 | Adds `A_ANALYTIC_MEAS`; the theorem digest remains the same. |

The old independent Reviewer read substitute primary passages, archived in
`reviewer_source_excerpts.txt`: Simon's 2014 Tsinghua lectures, Chapter 2
Section 6 equations 6.3/6.6, for weighted smooth coarea; Daniel-McNicholl,
`arxiv:1106.3318v3`, Theorem 2.5, for arcs in connected open subsets of
Peano continua; and Tserunyan's lecture notes at the URL recorded in the
old excerpt, Definition 10.5 / Corollary 15.10 (printed pp. 37/62), for
analytic universal measurability. No release/date or canonical version
identifier was recorded for that mutable-URL PDF: the archived quoted
passage, not a fully version-verified document, is the evidence.
The quoted propositions have the hypotheses used here. In
particular, circle-valued coarea is applied through local real lifts,
and the new free trace set is null for the finite Borel measure above.
The excerpt does not supply or replace the geometric null-section argument.

Old assumption judgments
`judgement-A_SMOOTH_COAREA-c26c05336803`,
`judgement-A_LC_ARCS-e52436abf062`, and
`judgement-A_ANALYTIC_MEAS-256c4e2a56fd` support those imported facts.
This is historical source reading, not a claim that the original
Federer, Whyburn or Kechris book passages were opened. Their original
book locators remain unverified; the old 404s do not refute those books
or the mathematical propositions. `A_ARSENIN_KUNUGUI` remains an
unchecked input to path coding, which this route does not use.

The relevant old Reviewer supports are
`judgement-C_POTENTIAL_ACL-e9195d09c25b`,
`judgement-C_LEVEL_GEOMETRY-1afe85ac5c5b`,
`judgement-C_SHARP_BARRIER-4bc64c5d6c9c`, and
`judgement-C_BARRIER-3de25f4f547b`.
They bind the exact shared statement/context hashes, and the separate
assumption records expose the versions' additional dependencies.
Stale `open`/pending labels should not be read as absence of this support.
Conversely, support is not a kernel proof, a fresh source-book attribution,
an independent acceptance of this review, or verification of `C9000071`.

**Assessment:** the present reading supports the narrow analytic theorem
under its stated setup and explicit external inputs, consistently with the
strongest old Reviewer result. Its mathematical improvement over the source
is the coefficient-1 infimum rather than coefficient 8, not a new full
uniformization result. The old `new_theorem` classification is a proposed
strengthening with **unverified novelty**, not verified-new mathematics.
The scalar replay confirms the constants, not the analytic construction;
neither old nor current Lean evidence formalizes this unit.
