# Natural simultaneous descent and sharpness

## Exact theorem and version

Part (A) of the old integral-two-switch report asserts: for every homomorphism
r:A->B of abelian groups and positive integer h annihilating both ker(r)
and B/im(r), there is a canonical additive map D_h:B->A, natural for
commuting squares of such diagrams, with `r D_h(b)=h^2*b`.
The multiplier is for the entire restriction map, not one multiplier
per generator or prime.

The associated proposed strengthening is the graph-only
`F004_LINEAR_DESCENT_CLEARING_FACTOR`: replace this universal natural
factor by h when h>=2. It is not a theorem claimed in the retrieved
source manuscript. Source passages claim bounded common clearing,
not this h-versus-h-squared optimum. Its refutation must therefore be
attributed to an Argus strengthening, not to the companion.

Lean's descent declarations occur in all five CITS-ALG versions.
`optimal_natural_clearing` occurs in full v2-v5, but not the successful
reduced v1. The final successful certificate is
`CITS-ALG-16211f6d28984c94.json`; earlier full-source elaboration failures
are not counterexamples. The historical prose theorem's novelty has
not been established by a literature search.

## Proof of existence and naturality

For each b choose x with r(x)=h*b; the cokernel hypothesis is exactly
what makes this possible. Define D_h(b)=h*x. If x' is another choice,
x-x' belongs to ker(r), so h*x=h*x'. This proves canonicity.
For b,c, x_b+x_c is a valid lift of h*(b+c); independence proves
additivity, including preservation of zero. Restriction gives h^2*b.

For a commuting square with maps alpha:A->A' and beta:B->B',
alpha(x) is a lift of h*beta(b); independence of lifts in the target
gives `alpha D_h(b)=D'_h beta(b)`. This is naturality in the whole
category in question. No step divides by a group order or mentions
the number of cyclic factors.

The Lean definition is noncomputable because it uses choice of lifts,
not because the result depends on the choice. `cleared_lifts_agree`,
`clearedDescent_eq`, and `clearedDescent_add` remove that dependence;
`clearedDescent_restrict` uses the lift hypothesis and proves h^2
restriction; `clearedDescent_natural` uses the commuting square and
the target kernel hypothesis. The Lean parameter is a natural number
and also allows h=0; the prose positive-h theorem is a valid restriction.
The formalization does not assert these hypotheses for a Galois restriction.

## Sharpness: the decisive obstruction

Fix h>=2. Let A=B=Z/(h^3), r multiplication by h, beta identity,
and alpha multiplication by 1+h^2. The kernel and cokernel are killed
by h. Since gcd(1+h^2,h)=1, alpha is an automorphism, and
r alpha=r because the discrepancy is h^3.

If a universally natural q-cleared descent sends 1 to x, its restriction
condition and naturality for this one automorphism require

    h^3 divides h*x-q;     h^3 divides h^2*x.

The second implies h divides x. Both h*x and h^3 are then divisible
by h^2, so the first implies h^2 divides q. In particular q=h is
impossible for h>=2. The existence proof achieves q=h^2, so this is
sharp for that universal naturality requirement.

`optimal_natural_clearing` proves the integer divisibility implication
for every nonzero integer h. It does not formalize the category,
the quotient-group automorphism, or the translation from naturality
to the two divisibilities; those elementary steps have been checked
explicitly above. A single diagram can admit smaller clearing:
indeed r=h on Z/(h^3) has the identity as an h-cleared additive map,
but that choice fails the required automorphism naturality. Confusing
these quantifiers would turn a valid obstruction into a false claim.

## Assessment and remaining boundary

**Recommendation: support the abstract theorem and reject the universal
linear-clearing strengthening.** This is a proof, not an exhaustion
experiment. The shared symbolic replay checks a divisibility algebra
identity, but it does not replace the quotient-group argument.
The fresh full-source compilation and statement-fidelity mapping are
shared with unit 07.

This does not show h^2 is necessary in every special arithmetic problem,
does not prove a uniform arithmetic torsion bound, and does not provide
an elliptic-curve counterexample. Unit 03 must still verify that the
whole restriction map has uniformly bounded kernel and cokernel.
No independent acceptance or novelty conclusion is inherited from
the old graph's refuted/reviewer-confirmed flags.
