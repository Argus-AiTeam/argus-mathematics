# Statement fidelity: all-degree support-elimination core

The declarations below are in namespace `InvariantIntertwiners` in `Main.lean`.
They quantify over arbitrary types, finite cardinalities, natural degrees,
and unbounded sequences as specified; they are not bounded computations.

`matrix_unit_product` proves the exact product rule for complex matrix units
on any finite index type. `normalized_matrix_unit_trace` proves their trace
divided by the matrix size, with value `1/m` exactly on diagonal units.
`probe_successor_unique` takes arbitrary permutations `p,q` of an arbitrary
slot type, an injective embedding of slots into finite matrix indices, and
nonzero products of consecutive probe units at every slot. It concludes
`p=q`. The nonzero adjacent products are the support condition supplied
in prose by a nonzero product of cycle traces. This declaration does not
formalize the entire cycle-trace polynomial or Schur--Weyl duality.

`cycle_lengths_forced` takes any root cycle length `r>=1`, any list indexed
by `Fin t` of other cycle lengths at least two, total slot count `n+1`,
and `n+2<=2(t+1)`. It proves `r=1` and every other length equals two.
The correspondence of these lengths with actual permutation cycles and
the disappearance of singleton centered tail traces are proved in prose,
not encoded as hypotheses about a von Neumann algebra in Lean.

`partner` exchanges the Boolean coordinates in `P x Bool`.
`partner_involutive` and `partner_ne` establish the matching axioms.
`pool_label_forces_partner` takes any injective tag map on the arbitrary
pair-block type `P`, and any fixed-point-free function on its two-slot
blocks which preserves tags. It proves that function equals `partner`.
`pool_assignment_injective` proves that assigning label `(p,a(p))`
keeps different pair blocks disjoint for any assignment `a`.
`pairing_support_product` proves that the product of all slotwise
Kronecker support indicators is exactly one for `partner` and zero for
every competing fixed-point-free function. For an orthonormal-pool
pairing evaluation, checking both ends of a pair duplicates only a
zero-or-one factor and hence has the same value as checking it once.
The declaration is a support identity, not a Hilbert-space norm theorem.

`independent_pool_count` counts the pairs of independent source and test
assignments: `card ((Fin s -> Fin M) x (Fin t -> Fin M))=M^(s+t)`,
including zero degrees and `M=0`. `nat_pow_ge` gives the elementary growth
bound for `N>=1` and positive exponent. `unbounded_power_zero` takes any
nonnegative real `a`, real bound `C`, positive natural exponent `r`, and
any natural-valued sequence with `forall B, exists j, B<=sizes(j)`.
If `a*sizes(j)^r<=C` for every `j`, it proves `a=0`.
`complex_coefficient_zero` applies this to the squared norm of an arbitrary
complex coefficient. `same_side_coefficient_zero` specializes it to
`r=s+t>0` and a bound for every integer `M>=1`. Its inequality is the
squared, divided form of the operator bound in the accompanying proof.
The passage from tensor sums and bounded operators to this inequality is
proved in prose and replayed on finite exact examples by `verify.py`.

`crossSideEquiv` explicitly constructs the equivalence between the two
Boolean side fibers for any involution which reverses side.
`cross_pairing_cardinality` proves their cardinalities agree on every
finite slot type. Taking source and test slots of cardinalities `k,l`
therefore forces `k=l`. This includes empty side fibers.

No declaration asserts the existence or classification of a bounded
operator on `L2(D)`, the density of matrix stages, the finite-dimensional
invariant-theory step, or the reduced-word decomposition. Those analytic
and translation steps are supplied in `proof.md` and require human review.
The formal claim `C_CORE` is only the conjunction of the algebraic,
combinatorial, and scalar-inequality results described here.
In particular, this is not a Lean proof of `C_INV`, `C_WORD`, the
free-product corner estimate, or Kadison's similarity conjecture.
