# Result 20001862 — half-turn obstruction to the standard pseudo-triangulation road map

## Historical status

AIM Problem 13 asks whether the pseudo-triangulation algorithm for the
carpenter's-rule problem can produce an unfolding preserving the symmetries
of the initial linkage. AIM's official workshop summary recorded the answer
as false by September 18, 2015, but supplied neither an explicit witness nor
a proof. This package reconstructs and verifies a witness; it is not
presented as an original resolution of the negative answer.

## Explicit octagon

In cyclic order, take

    (2,1), (0,1/2), (-2,1), (-1,0),
    (-2,-1), (0,-1/2), (2,-1), (1,0).

The half-turn maps vertex i to vertex i+4. Exact rational checks show that
the polygon is simple and nonconvex, its hull vertices are 0,2,4,6, and none
of the four hull edges is a polygon bar. The hull-edge orbits are

    02 <-> 46,    24 <-> 06.

## Obstruction

Every pointed-pseudo-triangulation completion contains the eight polygon
bars and all four hull edges. It has thirteen edges in total. The standard
road map deletes exactly one eligible hull edge. Its distinct half-turn
partner therefore remains a rigid bar.

If the resulting motion preserved the labelled half-turn, the deleted edge
and its retained partner would have equal lengths at every time. The deleted
distance would thus remain fixed. Every edge of the full infinitesimally
rigid completion would then keep its length, allowing only rigid-body motion
and contradicting the required nontrivial first road-map segment.

## Scope

The result concerns only the standard road map that deletes one hull edge at
a time. It does not obstruct the distinct canonical symmetry-preserving
motion of Connelly, Demaine, and Rote, a modified method deleting an entire
symmetry orbit, or the existence of symmetric pointed pseudo-triangulations.
