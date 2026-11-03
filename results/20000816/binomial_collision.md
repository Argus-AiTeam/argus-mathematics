# An exact pointwise collision of geometric Groebner fans

**Status:** exact arithmetic certificate completed; not independently reviewed. This is a
pointwise construction, not a generic-separation result or a novelty claim.
The original question's unspecified conventions remain a source limitation.

## Statement and polynomial data

Let \(k=\mathbb C\), \(R=k[a,b,c,d]\), and consider the following points of
\(\operatorname{Hilb}^{8}(\mathbb A^4_k)\):

\[
 I=(a^2,ab,b^2,c^2,cd,d^2,ad+bc),
\]
\[
 J=(ab,ac,b^2,bd,c^2,cd,d^2,ad+bc,a^4).
\]

Both ideals are homogeneous for the standard grading and supported at the
origin. Coordinates are fixed and identical for both ideals.

For this candidate, \(F_{\rm geom}(H)\) means the **full geometric Groebner
fan**: the closures of the equivalence classes of weights \(w\in\mathbb R^4\)
with the same initial ideal \(\operatorname{in}_w(H)\), using terms of
maximal weight. Initial-ideal labels are not part of the equality being
asserted. No generic coordinate change is made.

This convention agrees with Fukuda, Jensen, and Thomas, *Computing
Groebner fans*, **arXiv:math/0509544v1**, Section 2, equivalence relation
(1) and Definition 2.8. Their fan is a collection of polyhedral cones,
not a list of initial-ideal labels. Their definition keeps classes
meeting the positive orthant and their faces. All three classes below
meet that orthant (witnesses \((2,1,1,2),(1,2,2,1),(1,1,1,1)\)), so it
gives exactly the full fan computed here. The original AIM question does
not explicitly cite this convention; the agreement establishes a
standard interpretation, not the question author's unexpressed intent.

The candidate assertion is
\[
 F_{\rm geom}(I)=F_{\rm geom}(J),\qquad
 \text{no irreducible component of }\operatorname{Hilb}^8(\mathbb A^4)
 \text{ contains both }[I]\text{ and }[J].
\]

## A finite algebraic certificate covering every real weight

Write \(u=ad\), \(v=bc\), \(f=u+v\), and set
\[
 M_I=(a^2,ab,b^2,c^2,cd,d^2),
\]
\[
 M_J=(ab,ac,b^2,bd,c^2,cd,d^2,a^4,a^2d).
\]
Then \(I=M_I+(f)\) and \(J=M_J+(f)\). The only extra generator in the
second equality satisfies \(a^2d=a f-c(ab)\).

For either monomial ideal \(M\):

1. Neither \(u\) nor \(v\) belongs to \(M\).
2. Every product \(xu\) and \(xv\), for \(x\in\{a,b,c,d\}\), belongs to
   \(M\), by monomial divisibility.

Consequently the image of the ideal \((f)\) in \(R/M\) is exactly the
one-dimensional vector space \(k(u+v)\). Every element of \(M+(f)\) is a
sum of an element of \(M\) and a scalar multiple of \(f\). This proves,
for **every** \(w\in\mathbb R^4\), including negative coordinates and ties,
\[
 \operatorname{in}_w(M+(f))=
 \begin{cases}
 M+(ad),&w_a+w_d>w_b+w_c,\\
 M+(bc),&w_a+w_d<w_b+w_c,\\
 M+(ad+bc),&w_a+w_d=w_b+w_c.
 \end{cases}
\]
Indeed, initial terms contributed by the monomial part lie in \(M\);
outside \(M\), the only possible terms are those of the scalar multiple of
\(f\). The reverse containment follows from the generators. The three
initial ideals are distinct since \(u,v\notin M\) and their sole relation
modulo \(M\) is \(u+v=0\).

Thus both full geometric fans consist of the two closed halfspaces and
their common lineality hyperplane
\[
 w_a+w_d-w_b-w_c=0.
\]
This is exhaustive algebraic coverage, not sampled term orders. Equality
also holds after restriction to the positive or nonnegative orthant, with
the same convention for adding coordinate faces. Reversing the max/min
weight convention swaps the two cones and does not change the equality.

## Exact lengths and local Hilbert functions

The monomials outside \(M_I\) are
\[
 1,a,b,c,d,ac,ad,bc,bd.
\]
The monomials outside \(M_J\) are
\[
 1,a,b,c,d,a^2,ad,bc,a^3.
\]
These lists are exhaustive: \(M_I\) contains the square of every variable;
\(M_J\) contains \(a^4,b^2,c^2,d^2\). Checking divisibility inside the
resulting finite exponent boxes proves that nothing else survives.
In each case the single independent relation is \(ad+bc=0\). Hence
both quotient dimensions are exactly eight, with bases
\[
 B_I=(1,a,b,c,d,ac,bc,bd),\quad
 B_J=(1,a,b,c,d,a^2,bc,a^3).
\]
Their local Hilbert functions are respectively \((1,4,3)\) and
\((1,4,2,1)\). In particular the maximal ideal of \(R/I\) has cube zero,
whereas \(a^3\ne0\) in \(R/J\).

## Component separation: explicit dependence on a primary theorem

The external input is Cartwright, Erman, Velasco, and Viray,
*Hilbert schemes of 8 points*, **arXiv:0803.0341v2**, 23 June 2008:

- Theorem 1.1, printed page 1: in characteristic other than 2 or 3,
  \(\operatorname{Hilb}^8(\mathbb A^4)\) has exactly two irreducible
  components, the smoothable component \(R_8^4\) and \(G_8^4\).
  Points of \(G_8^4\) are local algebras isomorphic to homogeneous
  algebras with Hilbert function \((1,4,3)\).
- Theorem 1.3(2), printed page 2: on \(G_8^4\), membership in the
  smoothable component is equivalent to vanishing of the specified
  12-by-12 skew matrix's Pfaffian.

The retained source is `../sources/hilbert_eight_points.pdf`, with searchable
text in `../sources/hilbert_eight_points.txt`. These are cited assumptions,
not the output of the finite computation. Independent source attribution
is still owed.

The three symmetric multiplication forms of \(R/I\), dual to
\((ac,bc,bd)\) in degree two, have entries
\[
 A_1{}_{ac}=A_1{}_{ca}=1,\quad
 A_2{}_{ad}=A_2{}_{da}=-1,\quad
 A_2{}_{bc}=A_2{}_{cb}=1,\quad
 A_3{}_{bd}=A_3{}_{db}=1,
\]
with all other entries zero. The rerunnable certificate computes the
determinant and Pfaffian of
\[
 T=\begin{pmatrix}0&A_1&-A_2\\-A_1&0&A_3\\A_2&-A_3&0\end{pmatrix}
\]
exactly. Nonzero determinant excludes \([I]\) from \(R_8^4\).
Thus \([I]\) belongs only to \(G_8^4\).

The completed exact run gives \(\det(T)=1\) and
\(\operatorname{Pf}(T)=1\), with the matrix and both independent
arithmetic calculations retained in the certificate output.

By contrast, \([J]\notin G_8^4\): its nonzero maximal-ideal cube is
incompatible with the isomorphism types in Theorem 1.1. Since there are
exactly two components, \([J]\) belongs only to \(R_8^4\). The points
therefore share no irreducible component, not merely different chosen
component labels at an intersection.

The ideal \(I\) itself is the known nonsmoothable example in the same
paper's Proposition 5.1 (printed pages 16-18). Its nonsmoothability is not
claimed as new. No originality claim is made for pairing it with \(J\).

## Relation to the original question and remaining limitation

The original AIM Problem 15 / AIMPL 1.35 asks whether the Groebner fan is a
discrete invariant distinguishing irreducible components. Under the
pointwise, fixed-coordinate, geometric-fan reading, this candidate negates
that separation property directly. It does not rely on constancy inside a
component and does not exploit points in component intersections.

The primary question does not explicitly specify that reading. This
construction **does not establish** coincidence on dense open subsets of
two components. It also does not assert equality of initial-ideal-labelled
fans: those labels differ here. If either generic separation or labelled
data is required, this is not a counterexample to that requirement.
Independent Reviewer must decide original-statement relevance without
silently erasing these limitations.

## Replay

From the campaign directory, run:

```bash
python3 research/certificates/check_binomial_collision.py
```

It uses rational arithmetic and monomial divisibility only, with no
external algebra package. The recorded result is
`../certificates/binomial_collision_exact.json`: lengths \(8,8\), Hilbert
functions \((1,4,3),(1,4,2,1)\), the eight monomial annihilation conditions
for each ideal, and determinant and Pfaffian both \(1\).

The complete fan certificate is the algebraic lemma above plus the
exhaustively checked finite hypotheses. It is not inferred from the
separate one-order Jacobian computation. That auxiliary computation
returned `COMPUTED`, with seven reduced lexicographic basis generators,
under a ten-second wall budget. Its exact contract, payload, typed output,
and direct-CLI execution metadata are retained separately under
`../certificates/jacobian_*`.

Compared with the strongest previous campaign state (an open goal after
structural repair, and an unaccepted family-jump lead), this is a concrete
pair with an all-weight equality argument and source-dependent proof that
the points share no component. The remaining gap is independent review
of the construction, the cited inputs, and original-statement relevance;
it is not a request to accept a finite no-witness search as completion.
