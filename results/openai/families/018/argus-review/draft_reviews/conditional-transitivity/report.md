# Conditional exact transitivity

**Assessment:** The abstract implication is supported, including for
noncommutative division rings. Its application is conditional on actual,
uniform slice increments and exact abstract additive generation. The old
claim is not a density statement or a theorem about arbitrary split algebras.
Independent native acceptance remains pending.

## Exact statements and versions

The old source is `research/exact_transitivity/report.md`, Section 6,
with `C_ET_ACTION` versions 1 and 2, and composite `C_ET_EXACT` version 1.
Version 2 makes explicit that at each fixed c!=0 there is one y!=0
whose translation works for **every** a, with the analogous lower condition.
This resolves a quantifier ambiguity in version 1; it is not an additional
transitivity result. A merely point-dependent change would not supply the
translation subgroup used in the proof.

Let D be a division ring, V a subgroup of its units, and suppose the least
abstract additive subgroup containing V is D. Let a genuine group of
invertible transformations of D^2 preserve the origin, contain independent
left V-multiplications, and contain a nonzero upper translation on each
entire c!=0 slice and a nonzero lower translation on each entire a!=0
slice. Then it is transitive on D^2 minus the origin. Equivalently, its
invariant functions on this set are constant.

The hypothesis does not assert that a single shear translates all slices
by the same y. The chosen shear and y may depend on the fixed other
coordinate; uniformity in the coordinate being changed is what matters.

## Decisive proof, with multiplication order retained

Fix c!=0 and a transformation a -> a+y, y!=0, valid for every a.
Conjugating by a -> va gives a -> a+vy for every v in V.
Products and inverses give every increment in (Z V)y. Given delta in D,
write delta y^-1 as a finite integer combination of elements of V.
That combination gives increment delta exactly. This uses right
multiplication by y and its right inverse; it never commutes y past v.

Thus a can be changed arbitrarily at each c!=0. Symmetrically c can
be changed arbitrarily at each a!=0. If c!=0, first set a=1 and then
c=1. If c=0, then a!=0, so first set c=1 and then a=1. All intermediate
pairs are nonzero. Each operation is an actual finite product in the
acting group, not a limit or an element of a closure.

For invariant functions the same argument says that the additive group
of periods of a slice contains every vy, hence is D. The origin may
carry an arbitrary separate value. Conversely apply constancy to orbit
classes of a genuine action to infer that all nonzero pairs have the
same orbit. This last orbit-map argument supplies the bridge from a
function theorem to a group-action assertion.

## Application to the old composite claim

The supported-shear unit gives an E-linear block map T with
S(a,c)=(a+T(c),c). For a nonzero c, choose a nonzero block coordinate
c_i and the supported upper root at i. Its T(c)=y is nonzero and is
independent of a. Independent left U(k)-multiplications conjugate S
to a -> a+vy at that slice. The division-algebra hypothesis ensures
y is invertible. The additive-generation unit assesses the substantive
external input Z U(k)=D, rather than replacing it by local density.

This proves `C_ET_EXACT` in the original hypotheses when its constituent
theorems are taken with their stated arithmetic dependencies. The
function-field restriction d bar(d) not in k is retained when obtaining
the shears, including in characteristic two. It is not dropped because
the final abstract amplification argument itself is characteristic-free.

The source manuscripts are already making this exact amplification
argument; the old draft reconstructs it and supplies its alternative
supported-shear preparation. There is no new mathematical improvement
over the strongest old composite claim in this review, and no novelty
determination.

## Formal and computational evidence

The formal-core unit freshly compiled the unchanged
`exact_additive_amplification` and `pair_invariant_constant` declarations
under Lean 4.31.0. Their `AddSubgroup.closure` is algebraic subgroup
generation, not topological closure: there is no topology hypothesis.
The encoded premises include exact additive span, unit invariance, and
a nonzero period valid for every point of the chosen slice.

The compiler establishes an invariant-function conclusion, not an
existential group element or a separately encoded transitive action.
The orbit-class argument above is handwritten. The manuscript F_d is
only defined on nonzero pairs; it can be extended by 0 at the origin
because its target is an abelian group. The unit multiplications fix
the origin, and the nonzero-slice hypotheses never evaluate it. This
explains the domain difference rather than silently identifying the
two theorem statements.

The unchanged symbolic checker passed 26 checks in the supported-shear
replay. It verifies supporting algebra and its formal-record binding;
it does not compute Z U(k)=D or verify manuscript pair invariance.
No additional identical compiler/checker run was necessary for this unit.

## Dispositions and limits

`C_ET_ACTION` v2 is supported as the precise conditional theorem; v1 is
read in that clarified sense, not as a weaker point-dependent assertion.
`C_ET_EXACT` v1 is supported by the combination of the shear proof,
conditional additive-generation assessment, and the finite action argument.

No invalid argument was found in that combination. Actual availability
of generators, the definition/invariance/evaluation of F_d, and the
source manuscripts' later conclusions are not compiler consequences.
Their claim-by-claim dispositions appear in the two application units.
Novelty, full-manuscript correctness, and native independent acceptance
are not inferred from an unsuccessful attack.
