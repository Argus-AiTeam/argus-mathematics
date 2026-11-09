# Statement fidelity: interval geometry used by the pressure theorem

Claim `L_MIDPOINT_SIGN` is the geometric sign and finite weighted-reduction
core, not the entire Riesz pressure theorem or the main PDE theorem.
`Main.lean` uses Lean 4.31.0 and Mathlib; its declarations live in namespace
`PressureCertificate`.

`overlapProfile L M r` is
`max 0 (min L (min M ((L+M)/2-r)))`. For positive interval lengths L,M and
nonnegative r this is their overlap length when their centers are separated
by r. `overlapProfile_antitone` proves that this formula is nonincreasing
on all real r, for all real L,M. It does not formalize the geometric
identification of that formula with overlap; that identification is proved
in the mathematical report.

`paired_midpoint_sign` quantifies over every real-valued antitone function
F on the reals, every real separation d, and every h>=0. Its conclusion is
`0 <= d * (F(abs(h-d)) - F(abs(h+d)))`. Neither d>=0 nor d=0 is assumed.
There is no assumption that the odd kernel is monotone. Substitution of
`overlapProfile L M` supplies exactly the paired-overlap sign used after
the midpoint integration-by-parts identity.

`midpoint_integral_sign` quantifies over every measure on the real line,
real separation d, antitone F, and real function k which is nonnegative
for h>=0. The measure must give full measure to h>=0. The paired function
`k(h)*(F(abs(h-d))-F(abs(h+d)))` is assumed integrable. The conclusion is
that d times its integral is nonnegative. This explicitly includes an
integrability hypothesis; it does not interpret a divergent integral as
a finite endpoint defect. In the report, use Lebesgue measure restricted
to the nonnegative half-line, the compactly supported overlap profile,
and `k(h)=h*K(h)/(lambda^2+h^2)` with lambda>0. The conversion from the
double interval integral to this paired integral is an analytic step
proved in prose, not an additional claim about what Lean compiled.

`weighted_endpoint_reduction` quantifies over six real scalars A, BI, BJ,
T, cI, cJ. It assumes cI,cJ,BI,BJ>=0 and `2*A-BI-BJ<=T`, and concludes
`(cI+cJ)*A <= cI*BI+cJ*BJ+min(cI,cJ)*T+abs(cI-cJ)*A`.
For two bounded positive-weight intervals these stand for the finite
kernel integral, its two integrated endpoint averages, the directional
term, and the two component weights. No nonnegativity of A or T is
needed for the algebraic implication. Extended infinite integrals and
the zero-weight unbounded-interval case are not encoded as real scalars:
the report treats those using a pointwise nonnegative inequality.

The compiler checks these universal statements and their proofs. It
does not check the report's cap differentiation, source-mass cone
estimate, measurable layer integration, endpoint continuity, Riesz
potential hypotheses, or dependence of analytic constants. Those
remain explicit obligations for independent mathematical review.
