# Statement fidelity: the uniform algebraic core

`Main.lean` uses Lean 4.31.0 and Mathlib. Its declarations are in namespace
`PairedState`. It does NOT encode a triangulated sphere, the geometric meaning
of a face, an actual matching, or the predicate that an opposite-edge graph
is a forest. Those parts of the complete uniform theorem are proved in
`report.md` and require independent mathematical review.

`disk_sign` quantifies over five arbitrary integers B,W,I,h,l and proves
2*l-h=-3 from exactly the three disk equations: the unsigned triangle count,
the signed edge-side count, and B=I+l. It does not assert that a particular
embedding or matching satisfies those equations.

`involution_sum_zero` quantifies over every finite type P, an involution
flip:P->P, and complex weights w satisfying w(flip p)=-w(p). It proves their
finite sum is zero. No fixed-point-free or permutation hypothesis is silently
added: involutivity supplies bijectivity, and the sign relation is explicit.
The construction of this involution on actual partners is Section 2 of
`report.md`, not a theorem about graphs in this Lean file.

`normFactor(q,d)` is the polynomial in the shifted variable y,
(1+y)^q * sum_(j<d) (1+y)^j, for arbitrary natural q,d.
`difference_factor` proves the exact polynomial identity
(1+y)^(q+d)-(1+y)^q = y*normFactor(q,d).
`normFactor_zero` proves its constant coefficient is d.
Neither declaration needs positivity; d=0 is permitted.
`shifted_pow_zero` is the supporting uniform identity that the constant
coefficient of (1+y)^n is 1 for every natural n.

`amplitude(c,q,d)` is the product of those normalized factors over Fin c.
`amplitude_zero` proves its constant coefficient is the natural product
of the d-values, embedded in the complex numbers.
`oriented_group_factor` proves the full product factorization, with phase
(-i)^c and y^c. These declarations quantify over every natural c and
every pair of functions q,d:Fin c->Nat, including the empty product.
For an actual group one sets q=Lminus and d=Lplus-Lminus; their nonnegativity
and strict positivity respectively are established geometrically in the
report, not assumed as a formal graph theorem.

`grouped(S,c,B)` is the polynomial sum over an arbitrary finite set S of
C((-i)^(c(g))) * y^(c(g)) * B(g). It does not identify this sum with the
actual pair sum; that equality is proved in report Sections 2 and 5.
`minMass(S,c,b,m)` is the natural sum of b(g) over exactly those g in S
whose c-value is m.

`coefficient_at_min` assumes m<=c(g) for g in S and that B(g)'s constant
coefficient is the natural number b(g). It proves the coefficient of y^m
is (-i)^m times minMass. `coefficients_below_min` proves the coefficients
of every degree k<m vanish. Both results are uniform in the size of S,
the natural exponents, the amplitudes, and the minimum m.

`minMass_pos` explicitly assumes all b(g)>0 on S and that some g in S
has c(g)=m, and proves minMass>0. `grouped_nonzero` combines those
hypotheses with the coefficient theorem to prove the grouped polynomial
is nonzero. A finite nonempty family has such a minimum; the geometric
proof constructs b(g)=product_C Delta_C>0, rather than obtaining this
positivity from the compiler.

`cycleSum(S,c,q,d)` is the complete sum of the oriented cycle products
themselves, not an unspecified family of normalized amplitudes.
`cycleSum_nonzero` proves it is nonzero for every nonempty finite S and
every natural family c, q, d with all d-values strictly positive. It
obtains a minimizing group from finiteness, derives the normalized
constant coefficients using `amplitude_zero`, and derives their
positivity from the d-values. Its hypotheses do not assume the desired
nonzero coefficient, a minimum witness, or a forest. It still requires
the geometric identification q=Lminus and d=Delta_C supplied in the report.

Thus the formal source discharges the universal disk-equation elimination,
sign-reversing involution summation, group factorization, and minimum-order
noncancellation mechanism. It is genuine uniform algebraic verification,
not bounded enumeration, but it is NOT a complete Lean formalization of
Proposition prop:forest-state or of Barnette's conjecture. The claim ledger
attaches its compiler evidence only to C180_ALGEBRA.
