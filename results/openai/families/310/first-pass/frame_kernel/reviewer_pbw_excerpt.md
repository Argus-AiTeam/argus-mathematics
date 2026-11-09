# Independent primary-source reading

Reader: reviewer:copilot-9878cb5565dd

Source: John W. Milnor and John C. Moore, *On the Structure of Hopf
Algebras*, Annals of Mathematics 81(2) (1965), 211-264.
DOI: 10.2307/1970615.
Original scan independently retrieved during review:
https://www.sas.rochester.edu/mth/sites/doug-ravenel/otherpapers/Milnor-Moore.pdf

Printed page 243, Theorem 5.16, states:

> If K is a field of characteristic zero, and L is a Lie algebra over K,
> then the natural morphism
>
>     Lambda(L) -> total(E^0 U(L))
>
> is an isomorphism.

The displayed map above is transcribed in modern ASCII notation:
`total` collapses the associated bigrading as explained immediately before
Theorem 5.16. It is the factor-associated-graded PBW comparison, not a
claim that the filtered algebra itself is supercommutative.

I also read Definitions 5.1 and 5.3, the discussion following Proposition
5.2, and Section 5.4 on printed pages 235-237, and Definition 5.12 and
Section 5.14 on printed page 242. The paper's Lie bracket has the sign
`(-1)^(pq)` for degrees p and q. Over a field of characteristic different
from two and three, its discussion identifies the abstract graded
skew-symmetry and Jacobi conditions with its Lie-algebra convention.
Section 5.4 constructs the enveloping quotient and records injectivity.
Definition 5.12 filters by the number of Lie factors. Section 5.14
defines Lambda by the relations `xy - (-1)^(pq) yx`.

Consequently Theorem 5.16 supplies the graded PBW theorem used by
assumption A_MM_PBW: over Q, Lambda is the symmetric algebra on the
even part tensor the exterior algebra on the odd part. The manuscript's
positive word-length grading and parity satisfy these hypotheses.
No finite-dimensionality assumption on the entire Lie algebra is being
silently added.

The extra supporting-subspace grading is not an explicit clause of the
cited theorem. I checked its applicability separately: the enveloping
relations, factor filtration, and PBW comparison are homogeneous for
that grading. Bad supports are absorbing, so they cannot contribute
terms to a good component. This is the bridge proved in REPORT.md,
not an additional proposition attributed to Milnor and Moore.
