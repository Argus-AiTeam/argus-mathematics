# Result 3206 — a Cayley graph on Z_15 whose core is C_5

## Historical status

The unrestricted arbitrary-abelian formulation was already identified as
false by Gordon Royle in 2008, and Robert Samal subsequently confirmed the
issue while clarifying that the intended focus was the prime case. This
package reconstructs and verifies the counterexample; it is not presented as
an original breakthrough.

## Explicit graph

Let pi be reduction from Z_15 to Z_5 and set

    S = pi^(-1)({1,-1}) = {1,4,6,9,11,14}.

Then X=Cay(Z_15,S) is a connected simple 6-regular graph with fifteen
vertices and forty-five edges.

## Retraction and core

Reduction modulo five is a homomorphism from X to C_5. The section
sigma(i)=6i embeds the induced cycle

    0-6-12-3-9-0.

The composite sigma composed with pi fixes this cycle pointwise and is a
retraction. Every endomorphism of C_5 is a rotation or a reflection, so C_5
is a core. Therefore the core of X is C_5.

## Cardinality obstruction

A Cayley graph on (Z_15)^m has 15^m vertices. This number is one when m=0
and is divisible by three when m is positive. It is never five.

## Scope

The construction refutes only the literal formulation quantifying over an
arbitrary abelian group. It does not refute variants restricted to prime or
elementary-abelian groups, nor the cubelike case.
