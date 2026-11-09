# Statement fidelity

`Audit9000179.odd_square_obstruction` quantifies over every natural number
`u`, assuming exactly `1 < u` and `Odd u`. Natural numbers with these
hypotheses are exactly the odd integers greater than one in the live
objective. The `NeZero u` instance in the proposition is constructed from
`hu`; it is not an extra hypothesis or a bounded range.
Its unqualified declaration name is `odd_square_obstruction`.

`CyclicRing.Elem Z n` is `AddMonoidAlgebra Z (ZMod n)`, the ordinary
integer group ring of the additive cyclic group of order `n`.
`h.coeff a` is its literal coefficient at the residue class `a`.
The universally quantified sign condition is `h.coeff a = 1` or
`h.coeff a = -1` for every residue class. `ringStar` reverses the residue
class and applies coefficient star. On integers coefficient star is the
identity, so this is precisely the involution of the objective.
`scalar n r` is the group-ring element supported at zero with coefficient
`r`. Thus the norm equality is the full equality `h h*=4u^2`, including
all nonidentity coefficients, not only its augmentation or its diagonal.
The conclusion excludes the existence of every such `h`.

The proof uses the primary released
`OAI.CirculantHadamard.binary_sign_norm_impossible`; its hypotheses are
the same sign condition and full norm identity. Its proof constructs
the actual three normalized evaluations and proves their odd torsion.
It does not assume the character comparison, alternating-product
conclusion, or nonexistence theorem as an unproved axiom. Source provenance
and the required Lean 4.31.0 compatibility changes are described in
`report.md` and `formal_dependencies.json`. This is a replay of released
mathematics, not a claim of a new mathematical proof.

The four `#print axioms` commands request the complete transitive axiom
sets of the objective, local character comparison, alternating odd
torsion, and the binary contradiction. A successful import alone is not
the required outcome. The accepted axiom set is limited to the standard
logical foundations `propext`, `Classical.choice`, and `Quot.sound`.
In particular `sorryAx`, additional arithmetic axioms, and a hypothesis
asserting the disputed conclusion would invalidate this certification.

Lean checks the encoded statement and its proof terms. It does not check
this reading of the definitions, novelty, publishability, or independent
Reviewer acceptance.
