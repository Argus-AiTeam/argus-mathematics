# Relative Euler comparison: an exact failed-route obstruction

**Assessment.** `O026_RELATIVE_EULER_OBSTRUCTION` v1 is correct as a local obstruction to division by a zero factor. It is not a counterexample to either manuscript proposition.

## Exact assertion and attribution

Context: `CTX026_MOMENTS` v1. Take two unmarked distinct integer shifts \(0,1\), with one divisor coordinate at each. At \(p=2\) they occupy different residues, so the allowed nonempty subsets are the two singletons. For complex \(z_1,z_2\), using the ordinary positive-real base for the powers, the exact Euler factor is
\[
 P_2(z_1,z_2)=1-\tfrac12(2^{-z_1}+2^{-z_2}).
\]
Consequently \(P_2(0,0)=0\), whereas \(P_2(1,1)=1/2\). A comparison formed by division by \(P_2(0,0)\) is undefined.

The inherited Argus sources are `families/026/first-pass/audit026/moments/verification.md`, section 4, and `verify.py` function `zero_obstruction`, summarized in `exact_certificate.json`. The comparison manuscript is the manifest-matched OpenAI revision `4eaee87548250b2682affda7d05d947c05554bae`, `build/sections/03-moments.tex`, especially `eq:zero-safe-comparison`.

## Decisive check and correct disposition

Both evaluations are rational: \(1-(1+1)/2=0\) and \(1-(1/2+1/2)/2=1/2\). The choice \(z_1=z_2=1\) need not lie on a large-\(X\) Fourier core to show that division by the zero base value cannot define the proposed route. Indeed positive real \(z_1=z_2=1/L\) also gives a nonzero factor. No finite search for a global prime-gap witness is involved.

Fresh `../euler_core/finite_replay.json` reproduces these exact fractions and matches the archived obstruction section. Inherited reviewer judgement `judgement-O026_RELATIVE_EULER_OBSTRUCTION-66c508ff5610` supports the present claim identity and `exact_certificate.json`. This is reused independent human evidence, not a newly issued native review.

The old checker's prose says "additive comparison is necessary." The calculation supports the narrower reading: a method that does not divide by this zero value is needed; additive comparison is one such method, not the only logically possible method. It does not invalidate additive telescoping, and the identified manuscript explicitly uses additive telescoping without dividing by \(P_p(0)\), \(H_p(0)\), or the singular series. Thus the attack is a failed route, not a certified false manuscript assertion.

No analytic conclusion follows from this example alone. The ability to handle all zero factors uniformly is supplied by the Fourier proof, not by extrapolating one prime-2 computation. No novelty or publication classification was checked.

**Remaining obligations.** None for the displayed local algebra. Native independent review must preserve its limited route-obstruction classification and must not promote it to a manuscript refutation or family acceptance.
