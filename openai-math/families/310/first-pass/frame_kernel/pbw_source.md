# Primary-source dependency

John W. Milnor and John C. Moore, *On the Structure of Hopf Algebras*,
Annals of Mathematics 81(2) (1965), 211-264, DOI: 10.2307/1970615.
Original scan:
https://www.sas.rochester.edu/mth/sites/doug-ravenel/otherpapers/Milnor-Moore.pdf

The separate source-reading agent `pbw-source-reader` obtained the original
scan during this mission. It located Theorem 5.16 on printed page 243
(PDF page 34), immediately following Theorem 5.15
(Poincare-Birkhoff-Witt). Its prose reads:

> If K is a field of characteristic zero, and L is a Lie algebra over K,
> then the natural morphism ... is an isomorphism.

The displayed morphism omitted from that short prose quotation is, in
modern notation, Lambda(L) -> gr_F U(L). Section 5.14 defines Lambda(L)
by the graded-commutativity relations. Definition 5.12 uses filtration
by the number of Lie factors. The paper's conventions are nonnegative
integer gradings with the sign (-1)^(pq), so positive word-length
grading and parity equal to length modulo two are covered here.
Sections 5.1-5.2 (printed pages 235-236) explain the skew-symmetry/Jacobi
description in characteristic different from 2 and 3. Section 5.4
(printed page 237) also states injectivity of the canonical map.

Consequences used here, rather than a verbatim quotation of Theorem 5.16:
the factor associated graded is the symmetric algebra on the even part
tensor the exterior algebra on the odd part; lifting its ordered
monomial basis gives PBW normal forms in U. No finite-dimensionality
of the entire Lie algebra is needed.

Preservation of an additional supporting-subspace grading is NOT an
explicit assertion of Theorem 5.16. It must be checked here: the
enveloping relations and the PBW comparison map are homogeneous for
that grading. This check is included in the mathematical report.

No separate Scheunert or Golod-Shafarevich theorem is needed for the
local argument. The latter is a historical antecedent, not a premise.
The Wiki's balanced Hopf-scalar PBW argument concerns different
objects and is not used. No prior local certificate was present in
the initial ledger.

This note preserves the retrieved dependency and its scope. It is not
the independent Reviewer's citation attribution or mission approval.
