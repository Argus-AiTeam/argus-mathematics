# Statement fidelity: actual Steinberg-compatible line recovery

The root declaration is `CharPLineRecovery.prop_lines_source` in
`Main.lean`. It quantifies over every natural prime p, every pair of
fields K,L of characteristic p, finite-dimensionality over their
literal p-th-power subfields, the two inequalities
p^2 <= [K:K^p] and p^2 <= [L:L^p], and every compatible linear
equivalence e between the quotients below. Its conclusion is

    exists exactly one n : (ZMod p).Units,
      SendsLinesOnto (scale e n).

There are no hypotheses asserting symbol detection, existence of
derivations, exponent coherence, subfield preservation, or line
preservation. Nor is the intersection proposition an axiom argument:
its unchanged proved declaration is imported and applied.

## Quotient and compatibility

`V F p` is the additive group of F.Units modulo the range of
multiplication by p. This is exactly F^*/(F^*)^p, not a free vector
space on field elements. Its ZMod p module structure is constructed.
`point_eq_iff` and `point_eq_iff_ratio_mem` prove that two points
coincide exactly when their representatives have ratio in (F^p)^*.
`PthPowers F p` is `(frobenius F p).fieldRange`.

`steinbergSet` contains precisely the tensors [f] tensor [1-f],
for f != 0,1. `relations` is their ZMod p span in the actual tensor
square of V. `W` is that tensor square modulo this span.
`Compatible e` says its image under the tensor square of e is
exactly the target relation subspace. This matches the manuscript's
definition, with no stronger dependence-preservation assumption.

## Actual projective lines and quantifiers

`ZeroInc x y` means representatives of y belong to the
F^p-linear span of 1 and a representative of x. `zeroInc_iff`
proves this for every fixed choice of the two representatives.
`line a b` is the translate by a of `ZeroInc (b-a)`.
`line_iff_coefficients` proves, for arbitrary units s,t,u,

    [u] in line [s] [t] iff u = A*s + B*t for some A,B in F^p.

Thus these are the actual projective lines in the vector space F
over F^p. Nonzero representatives are automatic because points are
classes of units. Both endpoints are required distinct when a line
is used in the theorem.

`LineOnto e` asserts equality of sets
e '' line a b = line (e a) (e b) for every distinct a,b; it is not
mere containment or surjectivity on the whole projective space.
The intermediate theorem `prop_lines` proves existence and uniqueness
for this endpoint-normalized property.

The final theorem does NOT restrict a competing scalar to this
normalization. `SendsLinesOnto e` says, for every distinct a,b,
there exist distinct c,d with e '' line a b = line c d.
`lineOnto_iff_sendsLinesOnto` proves equivalence to `LineOnto`,
using `line_eq_of_two_mem`. That declaration proves uniqueness of a
projective line through two points by inclusion of their actual
two-dimensional F^p-spans and equality of dimensions.
Consequently `prop_lines_source` has exactly the manuscript's
"onto a projective line" conclusion and its full uniqueness
quantifier over ALL competing nonzero scalars.

`scale e n` is the linear equivalence x |-> n * e(x).
Its inverse exists because n is a unit. The unit group of ZMod p is
precisely Fp^*, including the single-element case p=2.

## Load-bearing deductions, not extra assumptions

`InseparableDerivations.extend_powerBasis`, `extend_finite`, and
`euler_pair` construct the required derivations in finite exponent-one
purely inseparable extensions. Minimal polynomials, extension across
simple degree-p adjunctions, and the finite-degree induction are proved
in the source. `logLinear`, `beta_kills_relations`, and
`differentialSymbol` descend the logarithmic determinant through the
actual quotient W. `zero_symbol` derives the needed implication
{s,t}=0 and s outside F^p imply t in F^p(s).

`affine_symbol` proves vanishing using actual Steinberg generators.
`local_exponent` constructs z=bx-ay=b(x+a)-a(y+b) and verifies every
hypothesis of `CharPIntersection.prop_intersection`, including the
two nonconstant ratios and both nonmonomial conditions.
`LineGlue.global_parameter_local_unique` derives propagation from
the single-inclusion uniqueness furnished by that theorem.
`global_affine` instantiates this propagation for the actual field
quotients; `containment` covers all affine coefficients, including
the two zero-coefficient endpoint cases.

`scalar_rigidity` uses a polynomial of degree less than p and its
coefficient of degree one; it proves the same rigidity as the
manuscript, including p=2. `prop_lines` constructs corrections
independently for e and the ORIGINAL e.symm, whose compatibility
is proved in `compatible_symm`. Their composite is a scalar,
rigidity makes that scalar one, and their endpoint-normalized
containments then give exact line equality. Onto-ness is not assumed
while constructing the inverse correction.

## Reviewed dependency and manuscript specialization

`ReviewedIntersection.lean` is byte-for-byte identical to
`research/char-p-intersection/Main.lean`, certified for claim
V_CHARP_INTERSECTION version 3 by
`research/char-p-intersection/certificates/V_CHARP_INTERSECTION-8ee0aa52ccd7bea2.json`
and independently supported by reviewer:copilot. The replay script
binds these source bytes and this unchanged certificate and checks
the current supporting judgement. Compiling a local importable object
does not revise that claim or regenerate its reviewed certificate.

The finite-p-rank theorem is stronger than the function-field
statement. Section 5 of report.md proves [F:F^p]=p^d for every
finitely generated extension of a perfect field of transcendence
degree d, by rational-function monomials, Frobenius, and cancellation
in the finite tower degree formulas. In particular it verifies all
formal hypotheses for the manuscript's algebraically closed bases
and d>=2, without a separability hypothesis. This specialization
is a prose algebraic proof, not a separate Lean theorem about
transcendence degree.

Only the line-recovery milestone is certified here. Projective
lifting, field reconstruction, publication-level novelty, and
independent acceptance of this new statement-fidelity reading
are not consequences of compilation. The printed axiom reports
should contain only propext, Classical.choice, and Quot.sound;
no sorryAx or custom axiom is permitted.
