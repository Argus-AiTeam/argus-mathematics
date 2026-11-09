# graph-coefficient

**Assessment: supported for the fixed formal coefficient, not uniqueness
of a decomposition on an individual surface.**

## Exact claim and source

`C40_GRAPH`, versions 1-3:

> Equality-diagonal excess intersection and output-component selection give
> a fixed formal diagonal coefficient depending only on the listed surface
> intersection numbers.

This is old `REPORT.md`, Section 8, and OpenAI's September 24, 2026
`relation.tex`, `rel:graph-intersection` and the coefficient-selection
part of `prop:universal`, at manifest revision
`4eaee87548250b2682affda7d05d947c05554bae`.

Work in rational Chow on powers of a smooth connected projective complex
surface. A multigraph records equality diagonals between distinct surface
slots, including repeated edges, with line/tangent decorations. Two
vertices are designated outputs. A fixed expansion and edge order is
chosen before evaluating classes on the surface.

## Excess formula and the three output cases

In each connected component impose a spanning tree first. Its \(v-1\)
equalities are a regular small diagonal. Each remaining edge pulls back
an already satisfied diagonal, whose normal bundle is \(T_X\).
Refined self-intersection therefore gives
\[
\prod_{uv\ {\rm edge}}[\Delta_{uv}]
=\iota_*\prod_C\operatorname{pr}_C^*
 c_2(T_X)^{e_C-v_C+1}.
\]
This includes cycles and repeated edges. It is not a transverse
intersection rule for all edges; the additional factors are precisely
the nontransverse excess. Isolated vertices have exponent zero.
Decorations restrict to the common coordinate of their component.

A component without an output is integrated and survives only in
codimension two. Its decoration is a rational combination of \(c_2(T_X)\)
and products of the listed line classes, since \(c_1(T_X)=-K\).
A component with one output leaves its decoration on that output, giving
external products when the outputs are separated. A component with both
outputs gives \(\Delta_{X*}\eta\); in total output codimension two,
\(\eta\in CH^0(X)_{\mathbb Q}=\mathbb Q[X]\), so this contribution is scalar.

The fixed formal procedure assigns the connected-output terms to \(c_*\)
**before** evaluating integrated decorations or using Chow relations.
Only \(\int c_2(T_X)\) and \(\int UV\), for
\(U,V\in\{K,L_1,L_2,T,H\}\), enter the evaluated scalar. Relations between
the diagonal and external products cannot change this selection rule.
They can, however, make other decompositions of the same realized class
possible. On \(\mathbb P^2\), the diagonal is itself decomposable, so a
toric realization does not recover this selected coefficient.

The report's cohomological pairing consequence is also correctly
conditional: once this Chow decomposition is established, an
\(\alpha\in H^2(X,\mathbb R)\) orthogonal to the five line classes satisfies
\(\int C_*(\alpha\boxtimes\alpha)=c_*\int\alpha^2\). External bidegrees
\((0,2),(2,0)\) vanish by degree and \((1,1)\) by orthogonality. No
Chow--Kunneth decomposition, absence of odd cohomology, or \(q=0\) is used.

## Evidence and versions

Version 2 records the initially unsourced self-intersection input;
version 3 relocates it to the inspected `C40_CALCULUS` prerequisite.
This is a disclosure correction, not elimination of excess intersection.
Legacy Engineer and Reviewer judgements support the unchanged claim.

`normalize_graphs` implements the component/excess rule, and the replay
checks triangular and repeated-edge examples. The nonzero shifted case
also retains a diagonal coefficient before realization. These finite
checks exercise implementation fidelity, not a general proof that arbitrary
cycles obey the excess identity. The latter comes from the regular
spanning-tree and self-intersection argument above.
