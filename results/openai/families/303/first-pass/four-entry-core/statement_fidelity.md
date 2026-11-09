# Statement fidelity: FourEntryCore

The source is an independent formalization of the noncommutative core of
`prop:four-avoidance`, not a formalization of all C*-algebra analysis in
that proposition. Every declaration quantifies over an arbitrary unital
complex C*-algebra `A`. This is the operator algebra on the nondegenerate
Hilbert space used in the manuscript's final irreducible representation;
it is not a unitality assumption on the original algebra `C`.

The star operation is the adjoint, and multiplication is not commutative.
`H`, `b`, `K`, `r₁`, `r₂`, `B₃`, and `B₄` are arbitrary elements of `A`.
The manuscript instantiates `b=(1-H²)^(1/2)` and
`r_i=h^(-1/2) B_i* H`. Their analytic origins are not extra Lean
axioms: the source takes only the explicitly displayed algebraic
relations as hypotheses and the report proves that they follow.

`complement_annihilates` uses `b*=b`, `b²=1-H²`, and `Hr=r`
to prove `br=0` through the C*-identity `z*z=0 -> z=0`.
It does not assume this annihilation. `scaling_isometry` additionally
uses `r*r=H²` to prove `(r+b)*(r+b)=1`, with the first star
on the entire first factor. `scaling_orthogonal` proves
`(r₁+b)*r₂=0` from `Hr₂=r₂` and `r₁*r₂=0`.

`defect r b` means `1-(r+b)(r+b)*`.
`defect_selfadjoint` proves that this is selfadjoint without extra
hypotheses. `defect_idempotent` uses the just-proved isometry relation.
`defect_nonzero` assumes `H*=H`, `H!=0`, `b*=b`,
`b²=1-H²`, `Hr₂=r₂`, `r₂*r₂=H²`, and `r₁*r₂=0`.
It proves that the defect is nonzero, rather than assuming a nonzero
projection. The separate isometry/idempotence theorems establish that
the manuscript's defect is a projection; nonzeroness needs fewer
hypotheses than that fact.

`cutoff_compression` proves `KPK=P` for this explicit defect `P`,
not for an arbitrary postulated projection. Its assumptions are
`K*=K`, `b*=b`, `b²=1-H²`, `KH=H`, `Hr=r`, `rK=r`,
and `Kb=bK`. In the manuscript the scalar ramps give `KH=H`,
the first support relation gives `Hr=r`, the definition of `r` gives
`rK=r`, and `K,b` are commuting functions of `X`. The report separately
uses continuous functional calculus to identify the clipped fixed
element `P₀=chi(KPK)` with the projection `P`.

`two_column_obstruction` quantifies over *arbitrary* `P,B₃,B₄`
and an arbitrary nonzero complex scalar `h`. It assumes exactly
`(B₃B₃*)P=h P`, `PB₄=B₄`, `B₃*B₄=0`, and
`B₃*B₃=B₄*B₄`, and proves `P=0`. There is no assumption
that `P` is positive or a projection; this is a genuine strengthening
of the algebraic final step. `four_entry_impossible` combines it
with `defect_nonzero` and concludes `False`. It does not import an
assumption equivalent to four-entry avoidance or to pure infiniteness.
In the manuscript `h=1/2`, viewed as a complex scalar.

`graph_recovery` proves the noncommutative recovery identity
`t S X t inverse = S` from `tS=S`, `Xt=X`, and
`S(X inverse)=S`. Here `inverse=h_inv(X)`. The report supplies
these relations from represented supports and identifies the measured
formula with its left side. This declaration alone does not construct
the slots or prove the zero-defect or norm-signal analysis.

Not formalized here: property (P), Cuntz comparison and cutoff
transport; actual operator ranges and Borel calculus; the directed
ultrafilter and norm ultraproduct; irreducible-representation existence;
the scalar spectral cutoffs; the graph-slot construction and its
represented norm signals. These have explicit proofs or cited
foundations in `report.md` and require the Host Reviewer's mathematical
assessment. In particular a kernel success for this file must never
be presented as a kernel proof of the complete avoidance proposition.

The source prints its transitive axioms for the main declarations.
Only Lean's standard foundational axioms may occur; no user axiom,
proof placeholder, or assumed obstruction is permitted.
