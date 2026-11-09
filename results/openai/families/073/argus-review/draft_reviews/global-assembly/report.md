# Global assembly: engineering assessment

## Claims, sources and scope

C_ASSEMBLY@1 concerns Section 10's entry, mass restoration and monotone
shell reconstruction, conditional on the required analytic estimates.
C9000073@1 is the old omnibus audit mission: either certify a manuscript
flaw or independently verify/repair/generalize the core theorem. It is
not an additional proved theorem or a current instruction to search.
The old draft establishes neither alternative at that global scope.

The manuscript is OpenAI, *The Falconer distance conjecture in all
dimensions*, 2026-09-23, at revision
`4eaee87548250b2682affda7d05d947c05554bae`, pinned by campaign 9100073
and matched to both reference and staged TeX.
T00, T04 and T10 below refer to TeX files under
`openai-math/preprints/The-Falconer-distance-conjecture-in-all-dimensions-September-23-2026/build/sections/`.
Old source references are under read-only campaign 9000073.
This is an engineering assessment, not Reviewer acceptance.

T00:11–24 states the compact-set theorem: integer `d>=2`,
`dim_H(E)>d/2`, conclusion `Lebesgue_measure(Delta(E))>0`.
There is no endpoint assertion, no packing/Ahlfors/Fourier-decay
hypothesis and no threshold pinned-distance conclusion (T00:93–94).
The proof starts with a Frostman probability of exponent strictly above
`d/2` (T10:597–612); write that exponent as `S+chi`, `S=d/2`,
`chi>0`. Borel requirements apply to class pieces, filters and measures.
The stated global theorem is compact, not an unrestricted claim for all
Borel or nonmeasurable sets; the abstract engine supplies no
Borel-to-compact reduction.

## Decisive assembly steps and their conditions

**Starting data and entry.** T04:733–768 requires compact separated
original supports, `(S+chi)`-Frostman probabilities, cross directions
in a prepared patch, decreasing Borel filters Gamma_N with positive
limiting product mass, at most `C*R^(2*d*omega)` spatial products, and
power-small deletions giving cap exponent S in both original marginal
fibers. Auxiliary projections prepare directions, not distances.
In odd dimension the charged affine-plane alternative uses the separate
classical threshold (T04:318–322,770–778).

After one similarity and a common boundary-null dyadic grid, the
regularized normalized classes have root model mass one; original class
weights are retained and discarded mass is `R^(-sigma+o(1))`
(T10:14–39). Entry uses `0<beta<min(chi/10,1/10)`,
sufficiently small sigma, then sufficiently small kappa. From the
Lipschitz and lower profile bounds, its last crossing c satisfies

```text
floor(beta*N/(2*d)) <= c < N/4,
A_j,n >= beta-d/N for n>=c,
min_j k_j(0,c) <= beta+C_d*sigma,
V_j([c,N]) >= 2*beta-2*d/N.
```

These are T10:62–111, and `[c,N]` is nonterminal. The proof's maximality
argument checks the entry algebra: both profiles exceed beta after c,
while one is at most beta at c. No actual Fourier bound follows from
these scalar inequalities alone.

**Restoring original mass.** T10:129–164 inserts the extra `[0,c]` test
and scheduled masks into a positive Theta_N between zero and one.
The measures are scalar distance pushforwards of
`W*1_Gamma_N*(mu_1 tensor mu_2)` and its Theta_N restriction, with
`W=|x-y|^(-(d-1)/2)` bounded above and below on separated supports.
T10:168–251 proves exponential total-variation approximation using
original, unnormalized directional fibers. It does not divide the
exceptional mass by an arbitrarily small class mass. The cap-controlled
subset is used only for estimating deletion, not inserted as a new
multiplier. Decreasing Gamma_N and positive limiting product mass are
essential to the nonzero monotone limit alpha_infinity.

**Shell estimate.** Root conversion and the two-profile graph estimate
must first produce the factor
`R^(-A_1,c-A_2,c+min_j k_j(0,c)+O_d(sigma)+o(1))`
(T10:269–315). Only then does Cauchy–Schwarz duplicate each endpoint
into a one-profile state, including identical cells (T10:325–348).
Combining conditional engine bounds cancels the entry profiles:

```text
min_j k_j(0,c) - (V_1+V_2)/2 <= -beta+C_d*sigma+2*d/N.
```

See T10:349–375. Restoring class weights costs no class-count factor;
the spatial partition costs `R^(4*d*omega)` after squaring
(T10:415–436). Parameters must be chosen in the order
beta, kappa, sigma, omega, with fixed error/derivative orders before
N grows (T10:381–413). The result needed is an exponentially decaying
shell norm, not merely a formal negative profile exponent.

**Monotone reconstruction.** T10:454–471 requires positive finite
decreasing alpha_N, summable TV differences from tau_N, and summable
square roots of tau_N shell energies. The proof explicitly sets positive
increments `zeta_n=alpha_n-alpha_(n+1)` with summable masses, then
uses the finite identity at T10:521–545 and reconstruction at
551–573. These estimates support absolute continuity under the stated
hypotheses without a rate of convergence to alpha_infinity or a
comparison between the deletion and Fourier exponents. The conclusion
is an integrable density, not an asserted global L2 bound for the limit.
Positive mass carried by the compact original distance image then yields
positive Lebesgue measure (T10:578–594).

## Verdict, provenance and novelty

The inspected entry cancellation, original-mass bookkeeping and scalar
reconstruction are coherent conditional subarguments. C_ASSEMBLY@1
nevertheless remains unestablished by the old Argus draft: `Main.lean`
contains none of the construction of laws, filters, shell estimates or
limiting distance measure. Its arbitrary-state conditional closure cannot
supply their hypotheses. Actual analytic reductions remain open, not
shown false.

The old no-witness work does not refute the manuscript, and abstract
profile experiments do not establish realization by Frostman measures;
the old report explicitly recognizes this
(`research/AUDIT_REPORT.md:123–143,179–184`). Consequently C9000073@1
has a substantive conditional milestone, not a certified manuscript
refutation or global proof. Attribution of the assembly is to OpenAI.
Argus's contribution is the limited combinatorial formalization and
scope record; no new assembly theorem or verified global novelty is
claimed. All required passages were accessible. No compilation or new
mechanical evidence for this unit was produced. Historical engine certificate
bindings were verified in `../scheduled-recursion/binding_replay.json`;
that compiler evidence does not cover Section 10. Independent native Host
Reviewer assessment remains pending.
