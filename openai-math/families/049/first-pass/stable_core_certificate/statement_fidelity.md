# Statement fidelity

## Exact objects and quantifiers

`IndependentStableCore.stable_core_verify` states, over the actual field
`Complex` and actual quotient
`B = MvPolynomial (Fin 4) Complex / (x*y-z*(z+1))`, the conjunction of:

1. For **every** Complex-linear derivation `E` of `B`, if `E` is locally
   nilpotent and nonzero, every `h` in the literal ideal
   `I=(x-s^2+u^2,z-s*x)`, `s=y-x*(x+u^2)`, fixed by `E` is zero.
2. An unrestricted polynomial-coordinate hypothesis for `literalF` produces
   a nonzero locally nilpotent derivation of this same `B` with a nonzero
   invariant in this same `I`.
3. `literalF` is not a coordinate in the original four-variable polynomial
   algebra, and is a coordinate after adjoining one independent variable.

The invariant statement is encoded elementwise, equivalently
`I intersect ker(E) = {0}`; the derivations are not restricted by a degree
bound, ansatz, triangular form, fixed generators, or preselected family.
`IsLocallyNilpotent E` quantifies over every ring element, with a possibly
element-dependent nilpotence exponent.

`literalQ` and `literalF` are independently written using zero-based variables:
`Q=X1^2-X3^2+X0*X2`,
`f=X0-2*Q*(Q*(X1+X3)+X0*X3)`.
Thus `(X0,X1,X2,X3)` means the paper's `(x1,x2,x3,x4)`.
`literal_matches` is definitional equality with the implementation's polynomial.
`IsCoordinate` quantifies over **all** Complex-algebra automorphisms sending
the polynomial to `X0`. `IsOneStableCoordinate` quantifies over all such
automorphisms of the five-variable algebra, using `Fin.castSucc` to adjoin
the fifth variable; it does not demand preservation of the old subring.

## Independent strengthened statements

`lower_perturbation_rigidity` quantifies over every characteristic-zero
field `k`, the actual determinant quotient
`C=k[a,d,b,c,u]/(a*c-b*d-1)`, every `W` in that quotient whose auxiliary
components above degree 1 vanish, and every locally nilpotent `k`-derivation
`D` preserving each actual fiber-weight submodule. If
`D(W+a^2*u^2-d^2)=0`, then `D=0`.
The gradings are respectively `(0,1,-1,0,1)` and `(1,1,-1,-1,0)`.
`W` need not be homogeneous, and no global degree-shift, domain, coefficient
regularity, localization, or nonvanishing conclusion is an extra hypothesis.
Those facts are proved for the quotient and its derivations by the imported
helper proofs and the leading-component argument in this source.
`october_rigidity` specializes `W=a^3*b`; the exclusion theorem then uses
the proved unrestricted action lift, not a supplied existence assumption.

`universal_principalization` quantifies over every commutative ring with
identity, including the zero ring, rings with zero divisors, and positive
characteristic rings. For arbitrary `a,d,b,c,t` with `a*c-b*d=1`, it proves
equality of the **ideals**, not just their radicals or point sets:
`(t-(d*c-a*b*t)^2, b*d-(d*c-a*b*t)*a*b)=(a^2*t-d^2)`.
Its proof gives integer-polynomial cofactors and a reverse Bezout identity.
Putting `t=a*b+u^2` yields the manuscript's principalization globally, without
discarding the chart `a=0`. There is no domain or cancellation hypothesis.

`signed_quadric_identity` is a universal polynomial identity over every
commutative ring, with the printed source definitions of `x,y,z,H`.
It does not itself assert a quotient isomorphism or local nilpotence.

## Reused proofs, compiler boundary, and exclusions

The exact transitive OAI dependency closure has been staged in
`formal_sources/`, with its license, rather than importing a comparator
statement or an uncompiled principal theorem. The upstream snapshot requests
Lean 4.34.1; this campaign uses Lean 4.31.0 and explicit local compatibility
proofs. The formal build must succeed before this document is paired with an
official compiler certificate. The build and `#print axioms` output, not this
document, determine whether there are proof holes or mathematical axioms.
The source does not import `Principal`, `NonCoordinate`, or the final
`Rigidity` theorem as its obstruction proof.

The coordinate-to-invariant implication and one-variable stabilization reuse
the implementation proofs, including separation of the integer filtration,
the actual associated graded and Laurent algebras, preservation of nilpotence,
nonzero initial forms, and explicit signed polynomial coordinate changes.
The action lift reuses the normalized determinant-frame construction and its
proved group law and weight compatibility. No manuscript statement, literature
theorem, or finite symbolic test is installed as an axiom.

Logical axioms such as `propext`, `Classical.choice`, and `Quot.sound` are
distinguished from mathematical assumptions. The requested certificate must
show no `sorryAx`, no proof holes, and no additional mathematical axioms in
the declarations printed at the end of `Main.lean`.

The Python certificate separately verifies exact identities and the
`a=0`, `z=0`, `z=-1`, and `p=0` boundary formulas. It does **not** prove the
universal invariant exclusion by enumeration. The September manuscript's
lifting identities and critical point are checked symbolically, but its full
affine-space zero-fiber theorem is not a declaration of this Lean source.
No global novelty determination or independent Reviewer verdict is encoded
by successful compilation.
