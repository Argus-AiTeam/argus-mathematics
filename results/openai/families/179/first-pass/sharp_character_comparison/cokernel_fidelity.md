# Statement fidelity: exact companion-coordinate lattice

The declarations are `SharpCharacterComparison.companion_image_iff`
(`companion_image_iff`) and
`SharpCharacterComparison.scalar_class_annihilator`
(`scalar_class_annihilator`). The definition `CompanionImage` gives the
literal image equations used by both.

The type `A` is any commutative ring; `p : A`, the exponent `t : Nat`,
and the tail dimension `n : Nat` are arbitrary. A unit `c0 : Aˣ` and a
vector `c : Fin n -> A` are universally quantified. There is no
bounded-dimension hypothesis or numerical computation. Allowing `t=0`
and `n=0` is stronger than the application's `t>=1`, `n=p-2>=1`.

In the report's free quotient `T=A[Z]/h`, write the monic relation as

`Z^(n+1) = -p*c0 - p*sum_i c_i*Z^(i+1)`.

The basis of `T` is `1,Z,...,Z^n`, with constant coordinate `x` and
tail coordinate `v : Fin n -> A`. Multiplication by `p^t*Z`, with
input coordinates reordered as the last coordinate `q` followed by
the first `n` coordinates `w`, has output

`x = -p^(t+1)*c0*q`,

`v_i = p^t*w_i - p^(t+1)*q*c_i`.

These are exactly the equations in `CompanionImage`, not an assumption
of the desired divisibility. `companion_image_iff` proves that this
image consists exactly of vectors whose constant coordinate is
divisible by `p^(t+1)` and whose every tail coordinate is divisible
by `p^t`. Both inclusions are formalized. The reverse inclusion
constructs the preimage using the inverse of `c0`.

Consequently, when `A` is the coefficient DVR, the cokernel of this
explicit companion-coordinate map is the coordinate quotient
`A/(p^(t+1)) direct_sum (A/(p^t))^n`.
`scalar_class_annihilator` proves the exact membership criterion for
`(x,0,...,0)`, namely `p^(t+1) divides x`. Thus the annihilator of
the scalar class is precisely this principal ideal, not just an upper
bound. The function-type equations are formalized; the conventional
module-quotient isomorphism phrasing is their mathematical interpretation.

In the application `n=p-2`, `c0=1-a^(-1)`, and
`c_i=binom(p,i+2)/p`. The proof that the original cyclic-ring cokernel
reduces to this companion image, including the unit recurrence
`Y^(p^t)-1=p^t*a^(-1)*Z*V_t`, remains the all-parameter proof in
`report.md`. This file neither presumes nor certifies that reduction.
It certifies its decisive coordinate-lattice calculation and the exact
scalar-class annihilator for all parameters, separately from
`Main.lean`'s complete comparison theorem.

Both printed transitive axiom closures must be contained in
`{propext, Classical.choice, Quot.sound}`. No `sorryAx`, additional
arithmetic axiom, or assumption of the classification is acceptable.
Mechanical evidence attaches only to `C_SHARP_LATTICE_CORE`, not to
the full cyclic-ring classification or a novelty claim.
