# Statement fidelity for C359_ALGEBRA

All declarations in `Main.lean` are in namespace `Hartogs` and quantify over
the real numbers. There are no additional axioms or external assumptions.

`mixedP` is
`d + 4*(b1+b2)^2 + 4*r^2 + e1*(c1+4*b1*r) + e2*(c2+4*b2*r)`.
In the geometric application, after making h the identity and diagonalizing
E, `b1,b2,r` are the imaginary Hermitian pairings of the two horizontal
coordinates and the vertical coordinate. `d` is the squared modulus of the
horizontal complex minor, and `c1,c2` are squared moduli of the two mixed
entries of Xi. The identity `d+4*b1*b2=|Xi12|^2` is checked separately by
`verify.py`; Lean does not encode complex vectors or prove this bridge.

`corner11`, `corner12`, `corner21`, `corner22` are exact polynomial identities
without hypotheses. `four_corner_interpolation` is their exact convex-weight
interpolation formula, again without hypotheses.

`mixed_coercivity` assumes `d>=0`, `c1>=0`, `c2>=0`,
`d+4*b1*b2>=0`, and `1<=e1,e2<=2`. Its conclusion is
`mixedP>=c1+c2`. No independence or nonzero-projection hypothesis is imposed.
It is a universal scalar implication, not a sampled-plane test.

`young_absorption` assumes nothing and proves
`k*a*m <= m^2/4 + (k*a)^2`.

`gap_absorption` assumes `a>=0`, `s>=a`, `0<=delta<=1` and proves
`(s-2*t)^2/4 + delta*a*t >= delta*a^2/4`, for every real t.
In the proof, a is sqrt(a_h), s is sqrt(a_h+3*b_h^2), and
t is sqrt(a_V); the encoded lemma is stronger in allowing arbitrary real t.

`area_control` assumes only `s^2<=4*a^2` and proves both
`t^2<=2*a^2+(s-2*t)^2/2` and
`a*t<=2*a^2+(s-2*t)^2/4`. `imaginary_pairing_bound` assumes a,b,s
nonnegative and `s^2=a^2+3*b^2`, and concludes `(a+3*b)/2<=s`.

`threshold` assumes `alpha>0`, `B>=1`, `C>=0`, `x>=1` and
`lambda>=B^2*(B+C)/alpha`, and concludes
`lambda+alpha*x^3/(lambda+C*x)>=B*x`. The denominator's positivity
is derived, not assumed. This theorem covers every unbounded x and lambda,
including their competing scale lambda proportional to x^(3/2).

The compiled claim is the collection of these scalar identities and
implications. It does NOT formalize the Hartogs potential, the tensor norm
estimates, spectral diagonalization, sectional normalization, either complete
manuscript, or novelty. Those bridges and the complete quantified pinching
theorem are proved in `proof.md` and checked symbolically where specified.
Independent review of this document and those bridges remains necessary even
when the compiler reports success.
