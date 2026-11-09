# Ordinary Lie lattices, special identity, and saturated reduction

**Engineer assessment: the saturation/localization argument is supported;
the old package gives only partial independent support for the larger literal
lattice-and-special-identity route. This is not a finding of a false lemma.**

## Claims and version

The old ledger's `L_LIE_LATTICE`, `L_SPECIAL`, and `L_SATURATED_TRANSFER`
refer to the pinned September 23, 2026 manuscript, Section 2:
`lem:lie-lattice`, `lem:free-fiber`, `lem:special`, and
`prop:saturated-reduction`. The source revision and manifest binding are
those recorded in the coverage index.

The lattice claim concerns ordinary free Lie bracket spans over `Z_(2)`,
finite-free multihomogeneous pieces, their rationalization and reduction,
and torsion-free braid targets with a split free fiber. It is not the claim
that all primitive elements of a characteristic-two enveloping algebra are
ordinary Lie elements.

For `psi in W_n`, **n>2 over Q**, and `c=-a-b`, the paper's special identity
is exactly

    [a,psi(b,a)] + [c,psi(b,c)] = 0,
    partial_2 psi(a,-a) T = 0.

These are not extra hypotheses defining rational `W`. They must be derived
before reducing its lattice. The literal statement is
`02-algebra.tex:144-155`; the proof is at `163-245,256-354`.

## What can be checked directly

Let `M` be a finite-free integral degree piece and `U` a rational subspace
of `M tensor Q`. Put `K=U intersect M`. Clearing denominators shows that
`K` spans `U`. If `v in M` and `2v in K`, then `v in U`, hence `v in K`.
Consequently

    K intersect 2M = 2K,

so `K/2K -> M/2M` is injective. Since `K` is free of rank `dim_Q U`,
its mod-two dimension is exactly `dim_Q U`. Integral equations satisfied
in a torsion-free target descend to this embedded reduction.

The manuscript uses `Z_(2)`, whereas the upstream implementation and old
explanation also use `Z`. This is not a discrepancy in the reduced space:

    K tensor Z_(2) = U intersect (M tensor Z_(2)).

A common odd denominator proves the nontrivial inclusion. Reduction modulo
two of the localized lattice agrees with `K/2K`. This establishes the
compatibility asserted by the old report, provided the stated lattice
hypotheses hold. There is no lift of an *arbitrary* modular solution in this
argument.

The source's `prop:saturated-reduction` makes precisely this dimension and
embedded-reduction assertion (`02-algebra.tex:356-415`). Thus the decisive
saturation mechanism is sound; simply checking equations in characteristic
two would not have sufficed.

## What the larger route still depends on

The paper supplies real proofs rather than merely restating the desired
facts. The ordinary-Lie lattice argument uses integral word/basis control
and the split free-fiber normal form. The special-identity proof derives
a free-fiber commutator from the pentagon, uses a centralizer argument,
differentiates transversely, and compares mixed derivatives to force its
remaining scalar to zero. These are substantive mathematical steps.

The old report summarizes this chain, but has no separately bound proof
receipt for each literal assertion. Its accepted endpoint receipt does not
identify every prose lemma with a particular checked declaration. In
particular, the two checks performed by the old algebraic routines do not
establish the free-fiber normal form or the mixed-derivative/centralizer
step. This is an **evidence-specific limitation**, not an assertion that
the source omitted those proofs or that their conclusions are false.

To certify this detailed route independently, the concrete remaining
obligations are: identify the integral free-fiber normal form establishing
the torsion-free targets used by reduction; and verify the differentiated
pentagon/centralizer calculation giving both special identities for every
`n>2`, including the scalar-elimination step. Once these are available, the
explicit saturation argument above finishes transfer. No arbitrary-modular
lifting theorem should be substituted for them.

## Scope and disposition

`L_SATURATED_TRANSFER` is supported conditional on its displayed lattice
and rational-identity hypotheses. `L_LIE_LATTICE` and `L_SPECIAL` have
source proofs and a coherent use in the route, but were not separately
certified by the old Argus work. Their route-level assessment is partial
support, not a refutation. None of these limitations overturns the
separately supported rational endpoint in the first unit.

No original contribution, repaired theorem, or novel strengthening is
claimed here. The original source and historical ledger remain unchanged;
the native independent Reviewer decides acceptance of this assessment.
