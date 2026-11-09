# Statement fidelity: completed primitive transport algebra

`Matrix2` and `Matrix3` contain all four and nine entries, respectively.
`mul2` and `mul3` are ordinary matrix multiplication; `sub2` and `sub3`
are entrywise subtraction; `trace2` and `trace3` sum the diagonal.
`form2` and `form3` compute trace of X times the commutator of Y and Z.
`upperBlock` inserts an arbitrary scalar and upper row over a lower
two-by-two block, with zero lower-left entries.

`CompletedPrimitiveTransport.parabolicTrace` states the exact equality

    tr_3(X[Y,Z]) = tr_2(X_2[Y_2,Z_2])

for every three upper block triangular matrices of block sizes 1 and 2,
including arbitrary entries in the unipotent upper rows. The coefficient
type is arbitrary. Its operations satisfy only the stated zero identities,
commutative multiplication, and x-x=0; hence every commutative ring is an
instance. The matrices, multiplication, subtraction, trace, and block maps
are explicitly defined. There is no assumed trace-restriction identity.

`CompletedPrimitiveTransport.completedTransport` proves the cancellation
part of the actual comparison diagram. `A` is geometric constant-coefficient
degree-three cohomology on Y_C, `T` is its projective pullback, `W` and `WC`
are Witt cohomology on Y and Y_C, and `D` is completed deformation-coefficient
cohomology. Projective pullback and Witt base change are separately
injective. The two coefficient-unit squares and scalar naturalities are
explicit hypotheses. A relation after projective pullback implies the
corresponding relation in D; if the second coefficient class is nonzero
and its scalar multiple remains nonzero, then the first class is nonzero.

The scalar maps represent multiplication by the same nonzero Q_5 scalar.
Lean does not construct those cohomology groups, their full
P_3 x P_2-actions, either injective map, or the geometric relation. Their
existence, equivariance, and applicability are proved in the accompanying
human proof. The formal theorem does not assume the desired deformation-
coefficient relation, and does not formalize spectra, descent convergence,
or canonical-localization nonvanishing. The unchanged earlier formal
source separately handles arbitrary retractions.
