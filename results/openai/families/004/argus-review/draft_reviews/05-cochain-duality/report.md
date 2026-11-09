# Transfers, boundary witnesses, and complex-level duality

## Claims and source versions

This unit separates two different assertions formerly grouped under
`CITS-DIAGRAMS`: an additive comparison identity, and applicability of
integral arithmetic duality and transfer constructions. CITS-DIAGRAMS
v2 adds an explicit Nekovar assumption to v1 without changing the
underlying applicability assertion. Its historical inconclusive status
is consistent with an unresolved realization problem, not a proof of
either truth or falsehood.

The reference manuscript is the October 7, 2026 companion, revision
`4eaee87548250b2682affda7d05d947c05554bae`,
`rl:finite-model`, `rl:finite-limits`, `rl:global-duality` and the
target-side construction used by `rd:derivative`. The finite-model
statement has Artin-local, flatness, boundedness and finite-dimensional
residual-cohomology hypotheses. The finite-limit statement requires
bounded amplitudes/ranks for the retained finite diagram, including
homotopies and inverses. Neither statement manufactures missing
arithmetic maps from desired cohomology groups.

## The exact boundary identity

Lean's `transferred_boundary` quantifies over additive groups and maps
d:D0->D1, d':E0->E1, f0:D0->E0, f1:D1->E1, and i,p,h.
It assumes, for every x, `f1(d x)=d'(f0 x)` and, for the specified z,
`z-i(p z)=d(h z)`. Its conclusion is

    f1(z)-f1(i(p z)) = d'(f0(h z)).

Apply f1 to the assumed witness and use the commuting square: that is
the whole proof. In a strong contraction, a cycle satisfies the
assumed witness because `id-ip=dh+hd`. Composing with an actual
target projection p' gives the report's retained witness p'*f*h*z.
The theorem does not prove that the contraction, target projection,
or comparison map exists. Its general additive statement faithfully
captures the algebraic step, not the global arithmetic construction.

Coefficient transfer by Shapiro and a coset sum is integral; it is
not averaging by the class-group order. In the application the
character evaluation must use the chosen action convention consistently.
Transporting the place and tame orientation before weighting makes the
lower and upper weights comparable. Naturality from unit 02 then
commutes with actual additive transfers. Merely declaring a map on
isomorphic cohomology groups would omit its boundary and duality data.

## Primary-source passages actually examined

All four inventoried Nekovar excerpts have been read for their relevant
statements. The document is *Selmer complexes*, Asterisque 310 (2006),
Numdam `AST_2006__310__R1_0`; this is the version, not a theorem number
detached from a document. The extracts are OCR text, so garbled formula
indices are not treated as exact transcriptions.

In `nekovar-duality.txt`, 6.2.5 gives alternatives (A) and (B) concerning
bounded coefficient complexes, the dualizing object and finite/cofinite
cohomology. Lemma-Definition 6.2.6 (printed p.139) defines perfect
duality by an adjoint quasi-isomorphism. Lemma-Definition 6.2.7
requires those alternatives, a perfect pairing and the specified
orthogonality data; the induced local maps must be quasi-isomorphisms
for the conditions to be **orthogonal complements**. Null-homotopic
orthogonality alone is weaker.

Theorem 6.3.4 (printed p.143) begins:

> Assume that one of the conditions (A) or (B) in 6.2.5 is satisfied
> and [the pairing] is a perfect duality.

It gives the duality triangle with local error complex under the
specified orthogonality data, and says the duality morphism is an
isomorphism exactly when the conditions are orthogonal complements.
This does not say that agreement after tensoring with a fraction
field suffices. Sections 6.4.1-6.4.4 (printed pp.144-145) expressly
list comparison maps, homotopies, and a second-order homotopy before
deducing compatibility up to homotopy; zero choices are justified
only in the special strictly compatible case of 6.4.4.

In `nekovar-shapiro.txt`, 8.1.4-8.1.6 (printed pp.191-193) define
continuous-cochain corestriction via coset representatives and compare
it, up to homotopy, with the trace `a -> sum a(g)`. There is no division
by the index in this trace. The later ind-admissible statements in
8.2 are not all established by the readable portions of this extract;
no unsupported extension of their exact hypotheses is asserted here.

In `nekovar-local-shapiro.txt`, 8.6.1-8.6.2 (printed pp.221-226)
require local Shapiro quasi-isomorphisms, conjugation compatibility,
restriction/corestriction maps, and a 2-homotopy trivializing the
boundary of a cube. The partial 8.7.5-8.7.6 material does not supply
a fully readable independent verification of every unramified
comparison used in the arithmetic application.

In `nekovar-change-support.txt`, Proposition 7.8.8 (printed pp.186-187)
concerns a specified ind-admissible module and a finite enlargement
S' of S. It supplies the stated inflation/restriction triangle and,
with the specified full conditions at new primes, a canonical
comparison. It is not a theorem about arbitrary new local conditions.
The beginning of 7.8.11 is present but its complete conclusion is
not; no separate Euler-characteristic claim is inferred from it.

The complete ambient Chapter 6 setup, including the no-real-place
qualification at p=2 recorded by the old primary-source reader, is
not reproduced by excerpts beginning in 6.2. Arithmetic application
must retain that setup, a complete Noetherian local coefficient ring
with the appropriate residue characteristic and finiteness conditions,
and the actual perfect pairing. This review does not certify the
whole chapter from four excerpts.

Howard, arXiv:1202.6340v1, Proposition 1.7.4, appears in the historical
`primary_sources.md` as an odd-prime local comparison with a normalizing
automorphism, not an unnormalized prime-2 global theorem. This review
records that historical attribution and its limitation; it does not
pretend that this summary is a newly read full-text proof. No positive
prime-2 assertion here relies on Howard.

## Applicability assessment

Finite matrix identities and their specified witnesses persist under
a common coefficientwise limit when the same bounded finite diagram
and compatible data are actually retained. A slower common precision
can accommodate finitely many identities. This conditional algebraic
observation does not establish uniform rank bounds for an unbounded
collection of diagrams or construct an absent arithmetic homotopy.
Bounds may depend on the fixed number of derivative slots, while the
initial scalar in unit 03 is a different uniformity question.

**Recommendation: support the boundary identity and the conditional
integral transfer/duality reasoning; leave CITS-DIAGRAMS unresolved
arithmetically.** The concrete obligation is to exhibit, in the actual
finite-stage arithmetic construction, the local comparison maps,
complementarity quasi-isomorphisms, cup-product null-homotopies and
higher compatibility data, with the required bounded models, and to
retain them through the same limits. The explicit family of unit 07
shows such data are possible algebraically; it does not realize them
for the manuscript's elliptic curves.
