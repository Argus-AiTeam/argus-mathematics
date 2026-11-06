# Statement fidelity: instantiated integral plus-construction algebra

The principal declaration is
`IntegralPlus.instantiated_integral_plus` in `Main.lean`. Supporting
declarations include `IntegralPlus.dB_F1`, `IntegralPlus.dB_F2`,
`IntegralPlus.D3_injective`, `IntegralPlus.retract_D3`,
`IntegralPlus.homotopy_degree_three`, `IntegralPlus.split_D3`,
`IntegralPlus.split_boundary`, and `IntegralPlus.cochain_extension`.
This document describes those actual declarations, not the manuscript's
entire topological theorem.

## Objects and hypotheses

`Free` is the free group on `Fin 5`. Its generators `X,A,Y,B,S` mean
`x1,a1,x2,a2,s`, in that order. The definitions `r1,r2,r3,r4,t1,t2`
are precisely

```
x1*a1*x1^-1*a1^-4
x2*a2*x2^-1*a2^-3
x1*a2^-13
s*x2*s^-1*a1^-5
x1^2
x2^3
```

In Lean, a negative power here is written as the inverse of the
corresponding positive power. `rels` contains exactly these six words.
`G = PresentedGroup rels` is their presented group, and
`R = MonoidAlgebra Int G` is its integral group ring. This group is
canonically the quotient `P/K` of the manuscript's original construction;
the formal source uses the equivalent six-relator presentation directly.
There is no finiteness assumption on `G`, no coefficient-field
specialization, and no commutative-ring assumption.

`C n` means all functions `Fin n -> R`, hence the free left module
with its specified ordered basis. `C2 = C 4 x C 2` records the four
old and two added two-cells. The degree-three module is `C 2`,
the degree-one module is `C 5`, and the degree-zero module is `R`.
Every chain variable is universally quantified over the entire indicated
module, not a sampled collection of chains.

`quotient` is the actual presented-group quotient map. `mon` maps a
free word to its monomial in `R`. All relator equations are proved
from this quotient, rather than supplied as additional hypotheses.
In particular `A_order` and `B_order` derive `mon A ^ 15 = 1`
and `mon B ^ 26 = 1`; these are not assumptions.

## Cellular boundary and source-derived fillings

`fox` is the additive chain component of the free-group
homomorphism into the semidirect product of the additive edge module
with `G`. More precisely, it is the `left` component of `PathGroup`;
the `right` component is proved to be `quotient` by `path_right`.
The action is left multiplication by the group monomial.
`fox_of`, `fox_mul`, and `fox_inv` prove exactly
`d(g)=e_g`, `d(uv)=d(u)+mon(u)*d(v)`, and
`d(u^-1)=-mon(u^-1)*d(u)`.
Thus this definition is the lifted-edge Fox sum, not a chosen map
whose boundary properties are assumed.

`rowMap` sends coefficients `v` to the sum of `v i` times row `i`,
on the **left**. `dB` uses the Fox rows of the four explicit original
relators; `b1,b2` are the Fox rows of `t1,t2`.
`D2(v,w)=dB(v)+addedBoundary(w)` is the resulting six-cell boundary.
`d1` sends edge `g` to `mon(g)-1`.
`fox_fundamental` and `d1_D2` prove the corresponding first chain
identity, without evaluating the coefficients at a representation.

The concrete lists `wU1,wU2,wP1,wP2,wE1,wE2` encode the six retained
free-group relator-conjugate witnesses. `word_U1` through `word_E2`
prove their free-group target identities. `dB_witness` derives
their boundary identities using the Fox rules, and `chain_E1`,
`chain_E2` identify the last two witness chains with `P1-U2`,
`P2-U1`. These lists use the same generator order, conjugators,
factor order, and signs as the executable certificate; freely equal
products such as `(s*x2*s^-1)^2` are expressed as group products.

`norm_annihilator` and `norm_square` use powers of a single ring
element only. The definitions `F26,F15_2,F15_1,F1,F2` are the explicit
formulas in `proof.md`, with natural-number scalar multiplication
interpreted as repeated addition in the integral module.
`dB_F1` and `dB_F2` prove the instantiated equalities
`dB(F1)=b1` and `dB(F2)=b2`. In particular `fill` is explicitly
`w0*F1+w1*F2`; it is not an existential parameter or an assumed
solution of a boundary equation. The factors
`(1-mon B)`, `mon S^-1`, and `N15` retain their written order.

## Conclusions and quantifiers

The source defines actual left-linear maps

```
D3(w)       = (-fill(w), w)
q(v,w)      = w
includeOld(v) = (v,0)
retract(v,w) = v+fill(w).
```

`instantiated_integral_plus` proves, for every chain of the appropriate
degree, `d1(D2(z))=0`, `D2(D3(w))=0`, `q(D3(w))=w`,
`retract(includeOld(v))=v`, `dB(retract(z))=D2(z)`, and
`z-includeOld(retract(z))=D3(q(z))`.
`retract_D3` gives the remaining degree-three chain-map identity.
`homotopy_degree_three` gives `q D3 = id`. With identities in
degrees zero and one, zero retraction in degree three, and
`h2=q` with all other homotopies zero, these are precisely
the degreewise chain retraction and `id-ir=dh+hd`.
The source proves the equations directly rather than packaging
them into Mathlib's `ChainComplex` structure.

`splitCoordinates` is the explicit invertible left-linear map
`(v,w) -> (v+fill(w),w)` with inverse `(v,w) -> (v-fill(w),w)`.
Its two compatibility theorems give the old complex plus the
identity two-term complex in degrees three and two.

`cochain_extension` quantifies over **every** type `M` with
`AddCommGroup M` and `Module R M`, and over every left-linear
`f : C 2 -> M`. It proves `(f.comp q).comp D3 = f`.
There is no finite-generation, flatness, or torsion-freeness
hypothesis on `M`.

## What is not kernel-verified here

The compiler does not verify this document's identification of the
formal objects with the source manuscript, the Python implementation,
or the equivalence of its free-ring ideal presentation with `R`.
Those are independent fidelity and replay questions for the Host
Reviewer. The Python certificate is an additional exact derivation,
not an axiom used by Lean.

Topological realization of the two cycles by sphere maps uses the
previously reviewed covering-space, cellular-homology, and degree-two
Hurewicz assumptions in `C-FOUNDATIONS`. The universal cover is
simply connected and two-dimensional, so a represented homology
class specifies exactly its cellular two-cycle. Attaching the
corresponding two three-cells realizes this `D3`.
No geometric attaching map or topological Hurewicz theorem is
formalized in `Main.lean`.

For arbitrary **right** `R`-modules, preservation of the displayed
chain homotopy under the balanced tensor product is explained in
`proof.md` and the reviewed report, Section 6. The Lean source
does not implement a noncommutative tensor-product construction.
Its explicit left-linear identities suffice for that ordinary
functorial argument; no tensor exactness or flatness is being
silently assumed.

The cyclic-cover and tower obstructions, the homotopical
nonrealizability conclusion, novelty, publication-level significance,
and campaign completion are outside this formal certificate.
`noncomputable` permits standard classical constructions of the
group ring and quotient; it does not introduce a mathematical
hypothesis or a proof hole.
