# Statement fidelity: CyclePairing

`Main.lean` uses Lean 4.31.0 and Mathlib. It proves the universal real-linear
algebraic reduction and local sign algebra used in REPORT.md. It does NOT import
the upstream Lean 4.34.1 solution, and does NOT formalize polygonal topology or
claim that a bare matrix is a geometric drawing.

## Objects and quantifiers

`incidence_pairing_zero` quantifies over arbitrary finite types V and E, arbitrary
real B(v,e), arbitrary real potentials R(e,v), arbitrary real T(v,w), and
arbitrary real chains z,y. Its only hypotheses are
sum_e z(e) B(v,e)=sum_e y(e) B(v,e)=0 at every v. It concludes that the explicitly
defined `incidenceForm B R T` pairs z and y to zero. This statement even allows
non-graph incidence matrices. For an oriented graph use
B(v,e)=1[dst(e)=v]-1[src(e)=v]. No rationality, simplicity of cycles, edge
disjointness, or bound on crossing multiplicity is imposed.

`cycle_pairing` has the same objects and cycle hypotheses, plus real matrices
I,L and the explicit hypothesis `geometric_bridge`:
I(e,f)+L(e,f)=incidenceForm B R T e f for every e,f.
Its conclusion is pairing(I+L,z,y)=0. The drawing-specific proof of this
hypothesis is the independent universal sweep-coordinate argument in REPORT.md;
it is NOT a Lean axiom, NOT a proved Lean geometric theorem, and NOT silently
assumed to follow just from matrix skew symmetry. The source therefore gives
kernel certification of the algebraic implication, not kernel certification
of the entire geometric manuscript lemma. The full geometric identity needs
independent human review of the report's local calculation and reduction.

## Local orientation and shared edges

`sign_eq_two_above_sub_one`, `above_neg`, `flux_eq_above_sub`,
`overlap_interleaved`, `overlap_contained`, `overlap_containing`, and
`overlap_reverse_interleaved` quantify over arbitrary real nonzero endpoint
height differences. `sign` is +1, -1, or 0 according to the real sign; `above`
is the strict-positive indicator. They prove the exact formulas in the four
overlapping horizontal-interval cases, with the two disjoint cases equal to
zero directly.

`common_start` and `common_end` prove the shared-endpoint half-sign formulas for
arbitrary real nonzero height differences. `affine_zero_iff_opposite` proves that
the affine interpolation of two nonzero real values has an interior zero
exactly when their product is negative. `affine_zero_unique` proves uniqueness
when the endpoint values differ. Interpreting its parameter as normalized
horizontal position gives the straight-segment crossing criterion used in the
report; the determinant-to-height interpretation is proved in prose there.

`shared_spoke_average` quantifies over arbitrary real endpoint coefficients
a,b and arbitrary real diagonal displacement values d. With T(e,e)=0, replacing
the diagonal by d and -d and averaging the two full pairings returns T exactly.
Thus opposite traversals and arbitrary real weights are included; no
disjoint-support hypothesis is present. The geometric existence of the two
displacements is not asserted by this algebraic declaration.

`cut_change` says that adding 2(u(f)-u(e)) to an order-comparison matrix has zero
effect when both endpoint-coefficient sums are zero. The real vector u is
arbitrary, so characteristic functions of any moved group of spokes are
included. The report proves that changing an actual circular cut has precisely
this form.

## Trust boundary and scope

The kernel checks every theorem just listed, with no `sorry`, `admit`, or
user-supplied axioms. The Python certificate independently checks exact
determinants, circular chord order types, shared-spoke displacements, generic
segment examples, and normalized graph examples with repeated crossings.
Those finite checks are not substituted for the report's universal proof.
The planar geometric bridge is explicitly recorded as a non-kernel assumption
of C_CYCLE_PAIRING until independently reviewed; neither the compiler nor this
document establishes its truth. This work does not certify either full
crossing-number formula or establish publication novelty.
