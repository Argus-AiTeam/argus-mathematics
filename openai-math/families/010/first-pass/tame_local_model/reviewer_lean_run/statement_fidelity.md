# Statement fidelity: the certified tame algebraic core

The source is `Main.lean`, namespace `TameLocalModel`, and the ledger
claim is `L_TAME_LEAN`. There are exactly three theorem declarations.

## `normal_monomial_exponents_injective`

The ten inputs are natural numbers
`eps,j,k,l,m,eps',j',k',l',m'`.
Both epsilons are at most one. At each input at least one of j and m
is zero. The three equalities compare

    eps+2(k+m),  j-k-2m,  l+m.

The middle coordinate is an **integer**, so negative Laurent exponents
are allowed; the other two are natural numbers. The conclusion is
equality of all five input exponents.

This is the injectivity assertion for the monomials
`a^eps b^j c^k e^l f^m` after substituting
`c=a^2/b`, `f=a^2 e/b^2`. It excludes collisions among the standard
monomials for leading terms `a^2,bf`. It is not a substitution into
arbitrary formal series. It does not itself construct the polynomial
quotient, prove the Groebner-basis assertion, or state primality;
those bridges are proved in report.md.

## `saturated_principal_intersection`

The coefficient ring R is an arbitrary commutative ring, including
rings with zero divisors. J and C are ideals, with J contained in C.
The element t satisfies the explicit saturation hypothesis
`for all r, t*r in C implies r in C`.
The conclusion is the equality of ideals

    C intersect (J+(t)) = J+(t)*C.

Here infimum is intersection, supremum is ideal sum, and `*` is
ideal product. This proves the abstract ideal-intersection step used
for an independent polynomial variable t. It does **not** silently
claim that every element t has the saturation property. The
polynomial coefficient proof of that property and its completed
extension are in report.md.

## `tame_nilpotent_relations`

R is any commutative ring, not just a characteristic-two field.
There are four arbitrary elements a,b,c,t, with exactly the
three hypotheses `a^2+bc=0`, `bt=0`, and `ct=0`.
The four conclusions are

    (at)^2=0,  a(at)=0,  b(at)=0,  c(at)=0.

These are universal quotient-ring identities. Nonvanishing of at,
the reverse inclusion in its annihilator, and the arbitrary-u
nilpotence index are not conclusions of this declaration.

## Certification boundary

The compiler checks these three statements only. The larger local
theorem, its arbitrary finite tensor products, primary decomposition,
exact nonvanishing, formal completion, and proper-incidence
specialization are not claimed to be fully formalized. Independent
review must assess the prose bridges and this reading of the source.
There are no project axioms, placeholder proofs, or assumed
declarations in this source.
