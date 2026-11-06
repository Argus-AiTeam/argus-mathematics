# Statement fidelity: the unrestricted retraction obstruction

The declarations in namespace `RationalUnitObstruction` use only Lean's
core theory of types, functions, products and equality.

`unitFirstDetection` quantifies over all types B,T, chosen points b0,t0,
all functions r:B x T -> B with r(b,t0)=b for every b, and every x
whose second coordinate is t0. If r(x)=b0, it concludes x=(b0,t0).
It places no restriction on r away from the first summand.

`excludesEveryRetraction` adds x!=(b0,t0) and concludes that no such
r with r(x)=b0 exists. In the application, B is the degree-minus-three
rational homotopy of the K(2)-local sphere, T is that of its minus-one
shift (the zero vector space), and x is the image of a proposed
detected class. The points are zero. Naturality and the vanishing
degree-minus-three group of L_0 A give r(x)=0. The accepted unit-first
basis supplies r(b,0)=b. No module-linearity or chosen attachment is
encoded or needed for this implication.

`cancelDetector` states cancellation only under an explicit injectivity
hypothesis. It does not assert that a vanishing composite has vanishing
first factor in the absence of that hypothesis.

The compiler does not verify the rational homotopy calculations,
localization or completion identities, the existence of the stated
basis, a map of spectra, solid descent, a primitive transport
calculation, or nonvanishing of the actual canonical map. Those
application hypotheses are not hidden axioms of the Lean source.
In particular this certificate cannot close the live detector premise.
