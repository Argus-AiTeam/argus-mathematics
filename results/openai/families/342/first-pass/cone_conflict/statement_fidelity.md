# Statement fidelity for `ConeConflict`

Claim: `C_CONE_ALGEBRA`. The source uses real scalars and the ordered
vector coordinates \((x_1,x_2,x_3,x_4)\) and two-form coordinates
\((12,13,14,23,24,34)\). Multiplication by `scale (-1)` is vector
negation. `K` is exactly the matrix \(-M_{U+fV+kW}\) in proof.md,
with the convention \(F(u,v)=g(Ju,v)\). `J` is \(K/r\).

The declarations and their quantifiers are:

* `K_scale`, `scale_scale`: homogeneity and scalar composition for
  every real parameter and vector.
* `K_squared`: for all real \(f,k\) and vectors \(v\),
  \(K(Kv)=-(1+f^2+k^2)v\).
* `K_norm`: for the same quantifiers,
  \(|Kv|^2=(1+f^2+k^2)|v|^2\), using the explicit Euclidean dot
  product `dot`.
* `J_squared`: for every real \(f,k,r\), assuming \(r\ne0\) and
  \(r^2=1+f^2+k^2\), the explicit map \(J\) squares to \(-I\).
  Positive \(r\) is needed in the geometric application, but not
  for this algebraic identity.
* `wedge`: the coefficient of the product of two two-forms in the
  standard orientation. This is an explicit six-coordinate
  polynomial, not a formal differential-form or cohomology API.
* `numerator_square`, `eta_square`, `tamers_square`,
  `tamers_zero_intersection`, `eta_tamer_pairings`: the universal
  wedge identities for the exact forms named in the torus
  construction, with arbitrary real \(f,k\) where applicable.
* `eigenvalue_positive`: for real \(r,s\), hypotheses
  \(r>0,s\ge0,r^2=1+s^2\) imply \(r-s>0\).
* `taming_coefficients_positive`: for real \(f,r\), hypotheses
  \(r>0,-1<f<1\) imply positivity of both \((1+f)/r\) and
  \((1-f)/r\).
* `positive_trace_pairing`: two positive real scalars have positive
  product divided by two. Identifying those scalars with the
  invariant projection coefficient and compatible trace is a
  separate geometric argument in proof.md.

These are the algebraic core of Sections 1, 2 and 5, not a formal
proof that the torus exists, that the displayed forms are globally
closed, that anti-invariant cohomology vanishes, that all cohomology
classes have invariant representatives, or that a cohomology class
has no compatible representative. In particular no smooth forms,
Stokes theorem, harmonic-form argument, currents, source statements
or literature conclusions occur in this Lean source.
Those analytic and interpretive obligations are proved separately
in proof.md, with exact primitives and further algebra replayed by
verify.py. Successful compilation must not be reported as a
kernel-level proof of `C_CONE_RESOLUTION`.
