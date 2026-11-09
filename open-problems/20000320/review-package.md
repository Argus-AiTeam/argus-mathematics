# Result 20000320 — weak Q-Gorensteinness versus pluricanonical base change

## Claim decided

The unrestricted equivalence in AIM Problem 1.1 is false. Weak or naive
Q-Gorensteinness does not imply that every reflexive pluricanonical power
commutes with arbitrary base change.

The counterexample is a positive-characteristic, flat projective surface
family over the nonreduced Artin base

    B = Spec k[t]/(t^2).

It is naively Q-Gorenstein, but omega^[2] fails relative S2, and the
comparison map to the reduced closed fiber is not an isomorphism.

## Source chain

1. Lee-Nakayama Example 7.4 constructs a flat projective family over A1 with
   special fiber P(1,1,4) of Q-Gorenstein index two and general fiber P1 x P1.
2. In positive characteristic, localize at zero and take the first Artin
   thickening B=Spec k[t]/(t^2).
3. Remark 7.28 makes that thickening naively Q-Gorenstein.
4. Lemma 7.5 states that omega^[2] is not relatively S2 on the same
   thickening.
5. Remark 7.6 converts this failure into failure of the closed-fiber
   base-change map.

One failed power and one failed base change disprove the universal
weak-to-Kollar implication.

## Scope boundary

The example uses positive characteristic, a nonreduced Artin base, and Fano
or Del Pezzo type fibers. It does not contradict Hacking's
characteristic-zero DVR theorem. It also does not decide a modified problem
restricted to canonically polarized or stable surfaces over reduced
characteristic-zero bases.

## Review status

An independent mathematical review checked that Example 7.4, Lemma 7.5, and
Remarks 7.6 and 7.28 concern the same family and the same first thickening. A
separate review checked the atomic audit integration.

## Primary references

- M. A. van Opstall, Open Problems in Compact Moduli Spaces and Birational
  Geometry, AIM Problem 1.1.
- Y. Lee and N. Nakayama, Grothendieck Duality and Q-Gorenstein Morphisms,
  PRIMS 54 (2018), 517–648; arXiv:1612.01690.
- P. Hacking, A Compactification of the Space of Plane Curves,
  arXiv:math/0104193, Proposition 10.14.
