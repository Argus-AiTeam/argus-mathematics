# Statement fidelity: conditional algebraic cores only

The formal source is `Main.lean`, namespace `CoheightTwo`, claim
`C318CO2ALG`. It does **not** encode `C318CO2`, the ordinary coefficient
theorem, or construct an isomorphism with actual Morava-stabilizer
cohomology.

`Vec R` is a four-coordinate free module. Its coordinates are assigned
degrees 0,1,3,4 in the mathematical interpretation; the grading itself
is not a Lean object. `cup1` and `cup3` are the explicit coordinate
operators for left multiplication by the two exterior generators.
`cup1_sq`, `cup3_sq`, and `cup_anticommute` prove their square-zero
and anticommutation identities over every commutative ring.

`scalarUnit a` is the vector (a,0,0,0). `cupMap a` sends a coordinate
vector to the ordered linear combination of this element, its two
specified generator images, and its ordered product image.
`cupMap_eq_smul` proves that this is precisely coordinatewise
multiplication by a. `unit_cupMap_bijective` and
`isUnit_cupMap_bijective` quantify over all commutative rings and
require an invertible scalar. `nonzero_cupMap_bijective` quantifies
over all fields and replaces invertibility by nonzeroness. None
replaces invertibility by nonzeroness over a general ring. In the
ordinary coefficient argument, the missing comparison must carry the
actual degree-zero unit basis to such an invertible multiple.

`exact_of_scalar_homotopy` quantifies over a field, three vector
spaces W,V,U, four linear maps with the displayed domains, a scalar
a with a-1 nonzero, and the explicit identity

    dprev(h(v)) + hnext(d(v)) = (a-1) v.

It proves that every v with d(v)=0 is in the image of dprev.
It does not assume or prove a group-cohomology comparison, nor does
it formalize the construction of the homogeneous-bar prism. The
all-degree prism construction and its continuity are proved in
`proof.md`. The formal theorem certifies the scalar division step
once that homotopy is given.

`proper_central_scalars` checks, over ZMod 5 and for exactly r=0,1,
that 2^(2-r)-1 is nonzero. Its interpretation as the actual proper
support weights requires the single prescribed volume line and
orientation convention in `proof.md`.

The connection to the live question is conditional: the literal
finite-frame/common-pole-bound dual comparison and the transport
of the specified xi_i are separate open assertions
`C318CO2ORDINARY` and `C318CO2ACTION`. A successful compiler run
closes only this algebraic core. It neither proves nor refutes the
ordinary coefficient statement, and it does not certify publication
novelty or an independent mathematical review.
