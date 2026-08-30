# Primary-source locations

## Exact problem

Baykur--Kirby--Ruberman, *K3: A New Problem List in
Low-Dimensional Topology*, DOI `10.1090/surv/295`, Problem 4.8 and
Remarks, printed p. 197.  The locally archived preliminary author PDF is
`sources/k3-problem-list.pdf`, with extracted text in
`sources/k3-problem-list.txt`.

The hypotheses read:

> Let X be a closed, simply connected, smooth 4-manifold, and T a
> smoothly embedded torus in X with pi_1(X-T)=1 and [T]^2=0. Let X_K be
> the result of Fintushel--Stern knot surgery on X along a knot K.

It then asks whether, for prime K1 and K2, a diffeomorphism
`X_K1 -> X_K2` forces K1 to be K2 or its mirror.  There is no
irreducibility, minimality, or indecomposability hypothesis on X.
`OBJECTIVE.md` asks for the existential negation with the same pair
`(X,T)` and the same non-mirror prime-knot condition.  Thus the
stabilized ambient manifold is within the literal source and campaign
scope.  The construction below answers the general wording only; it
does not answer the separate K3-surface special case in Remark (2).

The reviewed source-audit rows are
`../../outputs/open_problems_2026-08-27.csv:8` and
`../../audit-shards/01/result.csv:122`.  They correctly reject
invariant-only and composite-knot substitutes, but their recorded
`open_confirmed` conclusion must now be adjudicated against this exact
stabilization construction.  Those read-only audit files are unchanged.

## One-stabilization theorem

R. Inanc Baykur, *Dissolving knot surgered 4-manifolds by classical
cobordism arguments*, arXiv:`1704.04491v3`, Theorem 1, p. 1.  Local
files: `sources/baykur-1704.04491.pdf` and
`sources/baykur-1704.04491.txt`.

The theorem assumes a compact simply connected smooth 4-manifold and a
square-zero torus with simply connected complement.  For every knot K,
it concludes

```text
X_K # (S^2 x S^2)  diffeomorphic to  X # (S^2 x S^2).
```

The non-spin qualification in the next clause applies only to the
alternative `CP^2 # overline(CP^2)` stabilization, not to the displayed
`S^2 x S^2` conclusion.  The same page identifies the torus in E(n) as
a regular elliptic fiber and records the boundary gluing convention.
Remark 2, pp. 2--3, gives the equivalent original zero-surgery
presentation and says the same proof yields the theorem.

## The elliptic pair

1. Fintushel--Stern, *Six Lectures on Four 4-Manifolds*,
   arXiv:`math/0610700v2`.  Local files:
   `sources/fintushel-stern-six-lectures.pdf` and `.txt`.
   Lecture 2, section 7 states that the generic elliptic fiber is a
   self-intersection-zero torus and constructs E(n) by fiber sum.
   Lecture 1, section 5 states that E(n) has a section.  The concluding
   section identifies E(2) as the simply connected K3 surface.
2. Choi--Park--Yun, *On dissolving knot surgery 4-manifolds under a
   CP2-connected sum*, arXiv:`1704.02181v3`, proof of Corollary 1.3,
   p. 8.  Local files: `sources/choi-park-yun-1704.02181v3.pdf` and
   `.txt`.  It gives the monodromy factorization
   `(alpha beta)^(6n)`, with alpha and beta the twists about curves
   parallel to the standard fiber generators a and b.

## The two prime knots

1. Jennifer Schultens, *Bridge numbers of torus knots*,
   DOI `10.1017/S0305004107000448`, Theorem 1, journal p. 624.
   Local files: `sources/schultens-torus-bridge.pdf` and `.txt`.
   It proves `b(T(p,q))=min(p,q)`.
2. Jennifer Schultens, *Additivity of bridge numbers of knots*,
   arXiv:`math/0111032v1`, introduction and Theorem 1, pp. 1 and 5.
   Local files: `sources/schultens-bridge-additivity.pdf` and `.txt`.
   It proves `b(J#L)=b(J)+b(L)-1` and records that only the unknot has
   bridge number one.

## Knot-surgery definition

Fintushel--Stern, *Knots, Links, and 4-Manifolds*,
arXiv:`dg-ga/9612014v2`, pp. 3--4.  Local files:
`sources/fintushel-stern-dg-ga-9612014v2.pdf` and `.txt`.  These pages
define knot surgery as the fiber sum with `M_K x S^1`, where `M_K` is
zero surgery on K, and equivalently as replacement of the torus
neighborhood by the knot exterior crossed with `S^1`.
