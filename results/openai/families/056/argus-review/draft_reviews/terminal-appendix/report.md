# Appendix A: terminal surfaces, slicing, and discrepancies

**Assessment: partial support for the appendix as a self-contained
reconstruction; its local discrepancy arithmetic and terminal-surface
argument are supported.** The standard terminal-codimension-two theorem is
not refuted. The remaining bridge is a precise transverse-slicing argument,
not a failed computation. This non-node unit is A07 Appendix A.

## Statements and exact assumptions

The fourfold assertion concerns a normal complex analytic fourfold with
Q-Cartier canonical sheaf and ordinary terminal singularities, in the local
sense that exceptional places have **log** discrepancy greater than one.
It says the fourfold is smooth in codimension two. The proof reduces a
hypothetical general two-dimensional singular stratum to a terminal normal
surface. Two other statements are that a blowup of a smooth codimension-c
center has log discrepancy c, and that relative canonical comparisons
compose with a plus sign.

The October 6 canonical manuscript, at the revision recorded by the reference
manifest, states the fourfold fact as Lemma 2.3:
`build/build/sections/02-foundations.tex:128-139`. Reader
`analytic-source-reader` inspected that statement. It is a standard local
input, not a termination theorem. That secondary statement does not
independently prove the appendix's reconstruction.

## What the surface argument does establish

On a minimal resolution f:S->X of a terminal normal surface, write
K_S=f^*K_X+A with all exceptional coefficients of A positive. If an
exceptional curve remains, negative definiteness gives A^2<0; since the
coefficients of A are positive, some component E has A.E<0.
The pullback of K_X has intersection zero with contracted curves, so
K_S.E<0. Both K_S.E and E^2 are negative integers. Adjunction gives

    2 p_a(E) - 2 = K_S.E + E^2.

The left side is at least -2 and the right side at most -2. Consequently
p_a(E)=0, E^2=-1, and K_S.E=-1. Arithmetic genus zero makes E a smooth
rational curve; the analytic (-1)-curve contraction contradicts minimality.
Thus no exceptional curve remains. The Q-Cartier hypothesis is needed to
take the pullback and its intersection; positivity means relative canonical
coefficients a-1>0, not merely a>0.

This reasoning is sound using existence of a minimal surface resolution,
negative definiteness, adjunction, and contraction. The old draft names
Grauert's classical analytic surface theory but did not retrieve its
original source. No such source is among the 29 artifacts. This is a
source-only dependency, not an invented checked citation.

## The concrete gap in the fourfold reduction

The opening appendix paragraph invokes a general transverse surface and
adjunction in a few sentences. Cohen--Macaulayness and two parameters forming
a regular sequence alone do not prove that the slice is normal or that the
restricted relative canonical coefficients are still positive.

For that reduction one must choose a general point of the codimension-two
singular stratum and local transverse cuts so that:

1. The slice is regular away from isolated points; together with its
   Cohen--Macaulay S2 property and generic reducedness this gives normality.
2. Its inverse image on a chosen resolution is smooth and meets all
   exceptional strata transversely.
3. The two cuts introduce no exceptional components in their total
   transforms along that fiber. Otherwise adjunction subtracts their
   multiplicities and positivity does not simply restrict.

These are the relevant generic-smoothness/Bertini and stratified-slicing
conditions. An adapted resolution over a generic stratum and avoidance of
lower-dimensional exceptional images is the standard way to obtain them,
but the appendix does not prove that simultaneous choice or cite its exact
analytic statement. Once it is supplied, adjunction restricts the positive
relative equation, the surface is terminal and hence smooth, and the
embedding-dimension drop by two contradicts a singular fourfold point.
This identifies the missing justification; it does not assert the
well-known codimension-two conclusion is false, nor initiate a new
singularity-classification project.

Accordingly the curve-bound review treats terminal smoothness in codimension
two as an explicit standard external input, rather than advertising this
paragraph as a complete sourced proof of it.

## Smooth discrepancy and composition

In coordinates, blowing up a smooth codimension-c center has Jacobian
factor of order c-1 along the exceptional prime. Its relative canonical
coefficient is c-1 and its log discrepancy is c. More generally an
exceptional divisorial place above a smooth space has log discrepancy at
least two, a standard smooth-discrepancy fact.

For K_X/Y=sum kappa_E E and a valuation v above X, the composition is

    a(v;Y,0) = a(v;X,0) + sum kappa_E ord_v(E).

Here kappa_E=a(E;Y,0)-1. Under terminality it is strictly positive.
With a(v;X,0)>=2 and at least one positive order, the result is strictly
greater than two. The sign and the distinction between coefficient and log
discrepancy are correct in the old draft. The 624 finite rational tests
confirm selected instances, not the general smooth-discrepancy fact,
adjunction, or analytic surface theory.
