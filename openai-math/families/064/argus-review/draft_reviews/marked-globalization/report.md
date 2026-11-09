# Global marked monomial reduction

**Assessment:** the compatible projective construction supports the literal
marked-reduction proposition, using the universal lattice argument. This
preserves the two existing independent supporting judgements; it does not
deduce the result from the isolated `(2,2,3)` computation.

## Claims and exact scope

This unit covers `C_TOROIDAL_GLOBAL_064` version 1 and
`C_MARKED_MONOMIAL_064` version 1. Its source is
`model_derivation.md:91-163`, read with the preceding lattice proof.
The reference is `prop:marked-monomial-reduction` and its proof in
`build/sections/15-local-numerical.tex`, revision
`4eaee87548250b2682affda7d05d947c05554bae`. Source bytes match the existing
snapshot and manuscript manifests.

The proposition starts with a smooth quasi-projective complex threefold
\(Z\to C\), a smooth curve with marked point \(0\), central divisor
\(\sum a_iZ_i\), and a reduced **horizontal** marking \(H\).
The union of the central support and \(H\) is SNC; off \(0\), the map is
smooth and \(H\) relatively SNC. After the allowed shrinking, **any positive
common multiple** \(b\) of the \(a_i\) is used in \(s^b=\tau\).
Componentwise after normalization if necessary, the asserted modification is
projective birational, smooth, has reduced SNC central fiber together with
the marking, and is unchanged on each originally smooth relatively SNC
open. There is no mu-constant hypothesis and no freedom to replace this
quantifier by an unspecified sufficiently divisible exponent.

## Decisive construction checked

At an SNC point, write \(\tau=u\prod z_i^{a_i}\), with at most three
vertical coordinates; horizontal marking coordinates are separate product
coordinates. An etale root removes the unit. On each connected normalized
sheet, the vertical valuation lattice is exactly
\(N_I=\{d:b\mid\sum_{i\in I}a_id_i\}\). Dividing a reducible binomial's
exponents by their common gcd gives the same congruence condition, not a
different lattice. Normalization therefore does not justify computing in
the larger ambient lattice.

Compatibility is supplied by the single auxiliary orthant labeled by the
**global** central components. Order its finitely many height-one points,
perform star subdivisions, and restrict to the faces that occur in the
threefold. A center outside such a face does not subdivide that face.
The auxiliary orthant may have dimension greater than three, but regularity
is asserted only for the actual faces of dimension at most three.

The proof also specifies algebraic modifications, rather than assuming that
arbitrary analytic triangulations descend. For each existing ray vector
\(v\), sum the vertical prime divisors with that original-component order
vector to obtain \(G_v\). Simplicial local toric charts make these sums
Q-Cartier. For a new ray \(v=\sum\lambda_jv_j\) in its smallest cone,
choose positive integers \(c_j\) clearing the Cartier indices and satisfying
\(c_j\lambda_j=\text{constant}\). Normalize the blowup of
\(\sum_j\mathcal O(-c_jG_{v_j})\).

In ray coordinates, the generator orders are \(c_jd_j\). The region where
the \(i\)-th is minimal has precisely the rays \(v\) and the old rays other
than \(v_i\), including the other unchanged generators of a larger cone.
Thus this ideal realizes the stated star subdivision. Where a required
divisor is absent, its summand is a unit, so there is no spurious
modification. Global coherent ideals give actual projective blowups;
normalization is finite for these finite-type complex varieties.

The lattice unit then supplies regularity. All vertical rays retain height
one, so the divisor of \(s\) is reduced. The horizontal coordinates have not
been modified, giving the required SNC union. Global component labels and
order vectors preclude two local rays with the same vector on a normalized
sheet; separate local sheets are disjoint. This addresses *simple*
crossings, rather than merely asserting etale normal crossings while
ignoring possible self-intersection of a global component.

Away from \(0\) there is no center. At an originally smooth point over \(0\)
there is one vertical coordinate of multiplicity one, whose cone needs no
subdivision after base change. These are the exact reasons the stipulated
opens remain unchanged and no horizontal exceptional prime is introduced.

## Inheritance, attribution and limits

The matching old independent judgements are
`judgement-C_TOROIDAL_GLOBAL_064-1ea869a736bf` and
`judgement-C_MARKED_MONOMIAL_064-631a7ca31ff5`.
The graph's open labels do not negate those claim-specific opinions.
The arguments and their dependencies agree with the reference source; no
conflict requiring recertification was found.

This is a reconstruction of the manuscript's construction, with elementary
and standard toric/algebraic background, not a new theorem or a certified
attribution to Kollár--Mori Theorems 7.17/7.19. Those unread numbered
propositions are not used in place of the displayed construction. No
historical novelty is claimed or established.

Tools were source comparison, read-only manifest matching and mathematical
inspection of the blowup orders. There is no separate universal replay or
Lean formalization. The local computation is supplementary only. This unit
does not supply supported resolution, relative MMP existence, numerical
comparison, ambient lifting, or the manuscript's main theorem.
