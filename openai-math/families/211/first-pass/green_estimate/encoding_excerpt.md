# Encoding input

Source: Olivier Bernardi, *Bijective counting of tree-rooted maps and
shuffles of parenthesis systems*, arXiv:math/0601684v1, Section 2,
pp. 2--4, https://arxiv.org/html/math/0601684v1#S2 .

Passages read, retaining the relevant conventions:

> Loops and multiple edges are allowed.

> A tree-rooted map is a rooted map together with a distinguished spanning tree.

> The size of a map, a tree, a tree-rooted map, is the number of edges.

> Consider walks made of steps North, South, East, West, confined in the
> quadrant x >= 0, y >= 0.

> This encoding due to Walsh and Lehman [6] establishes a one-to-one
> correspondence between tree-rooted maps of size n and parenthesis-shuffles
> of size n.

The intervening encoding and inverse paragraphs specify each tree traversal
and each non-tree half-edge separately. A uniform shuffle conditional on its
coordinate schedule therefore has independent uniform Dyck coordinate strings.
That last probabilistic conclusion is derived in `theorem.md`, not attributed
as a quotation.

This is the known discrete encoding, not a continuum convergence assumption
or a claimed new result. Section 1 of `theorem.md` rederives it with explicit
forward and inverse permutations, discharging its initial use as an external
assumption. The Host Reviewer should check that proof as well as this attribution.
