# Statement fidelity: validity and support lifting

Claim `C_SIM_SUPPORT_KERNEL` has the principal declarations
`SimulationAudit.Overlap.validity_iff`,
`SimulationAudit.Overlap.reflect_rel`,
`SimulationAudit.Overlap.merger_letter_factor`,
`SimulationAudit.Probe.letterMap_injective`, and
`SimulationAudit.Probe.letter_factor`. The first two prove all of
`C_SIM_VALIDITY`. This includes the full two-way finite-overlap-validity
assertion in `lem:mono-simulation`, not the whole simulation lemma.

`B,M` are arbitrary monoids, `f:B ->* M` is a monoid homomorphism,
and `Conservative f` has exactly injectivity, preservation of old
right factors, preservation of conditional right joins and preservation
of disjoint principal right cones. `RDiv x y` means `exists z,x*z=y`.
`ConditionalJoins B` requires a root for every nonempty intersection.
The only cancellation hypothesis used in validity transfer is left
cancellation in `M`. Conicality and conditional joins in `M` are
unnecessary for this conclusion; the manuscript has them.

`E i j` is either no overlap or a pair of start coordinates in `B`.
`Rel f E` is equality or exactly one of those pair identifications
with a right parameter in `M`. It is not a generated equivalence
relation. `Valid` requires this relation itself to be an equivalence
relation and forbids identification of distinct points of one copy.
The formalization allows arbitrary index sets and does not assume
symmetry of the supplied table: symmetry must follow from `Valid`.
The manuscript's finite symmetric table, with no diagonal overlaps,
is a special case. Thus the generality does not add a hypothesis
to the manuscript assertion.

`Overlap.merger_letter_factor` proves that if right multiplication
of a smaller merger letter by an arbitrary larger old element
equals another smaller letter under the direct relation, that
right factor and the relation already come from `B`. Applying
this to the actual quotient is justified by `validity_iff`,
which says the direct relation is already an equivalence relation.

`Probe.Letters d` is the actual set direct limit of right
multiplications by products of the `d(i)`. `Probe.letterMap`
is induced by `f`, not an assumed embedding. The compiler proves
its injectivity, compatibility with old left actions, and the
stronger `Probe.letter_factor`: for every larger letter `t`,
`f(a)*t=letterMap(s)` implies that the entire direct-limit class
`t` is an image of a smaller letter. It does not claim that every
representative of that class is smaller. `letter_divisibility_iff`
gives preservation and reflection of the old letter-divisibility
test. No transition map is assumed injective. No right cancellation,
finite monoid assumption, or assumed quotient-section property occurs.

These are universal formal facts for the actual parameter relations.
They supplement the complete prose proof of both presented monoid
simulation theorems in `report.md`. This Lean file does not encode
the probe gate recursion, arbitrary probe-word intersections, or
the merger-word monoid. Those parts of the new theorem require
independent mathematical review of that proof. The accepted
`C_PROBE_CORE` source and certificate are not imported, regenerated,
or modified.
