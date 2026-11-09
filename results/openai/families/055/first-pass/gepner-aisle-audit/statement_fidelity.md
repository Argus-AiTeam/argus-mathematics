# Statement fidelity: C55_CORE

`Main.lean` proves universal real algebra, not a theorem about a derived
category. `GepnerAisle.V` is an arbitrary quadruple of real numbers; its fields
have no built-in interpretation as Chern characters of actual objects.

`phi` is exactly the manuscript's matrix M in normalized coordinates (r,c,d,e).
`phiInv` is its rational inverse. `phi_inverse`, `inverse_phi`, and
`phi_period_five` prove their identities on every real quadruple. The last
identity is numerical periodicity, not the functor isomorphism Phi^5 = [2].

`uG` is (5 - sqrt(5))/10. `gepner_polynomial` and `gepner_bounds` certify its
quadratic equation and the stated rational enclosure. The exact identification
of these real constants with the manuscript's trigonometric charge is explained
in the mathematical report, not formalized here.

`slope_criterion_threshold` proves the upper bound u <= 13/46 from the two
displayed affine inequalities, and `slope_criterion_attained` proves attainment
at (u,s) = (13/46,13/23). This is optimality of a sufficient numerical criterion,
not a counterexample to aisle inclusion at or above that endpoint.
`parameter_margins` and `concrete_margins` prove the explicit strict margins.

`comparison_separation` quantifies over all real s,u,delta,C,R,D,err. It assumes
s > 0, u >= 0, C > 0, s R <= C, D <= 0, err >= -3 delta C, and
s/2 - u - 3 delta s > 0. It proves C/2 - u R - D + err > 0.
The report separately derives those hypotheses from actual subobjects,
quotients, slope factors, and perturbation tests. The Lean theorem does not
assume an aisle inclusion as a premise and does not prove that categorical
derivation.

`four_corner_control` proves epsilon (|r|+|c|) <= N from the four affine corner
inequalities. No object-existence or positivity-on-a-heart assertion is encoded.
`four_cut_circuit` proves the positive circuit for cut u = d+c/2+ur and the
inverse matrix, under 5u^2-5u+1 = 0. `endpoint_r0`, `endpoint_r3`, and
`endpoint_c3` prove the exact scaled endpoint-coordinate identities.
`numerical_kernel_separation` proves that rank = c = cut(w) = cut(phiInv w) = 0
forces d = e = 0 when u is nonzero.

`explicit_refinement_separation` proves that the displayed real inequalities
force n1=n2=X=0. Here a is the circuit weight, X bounds the middle rank and
first character, and T bounds the endpoint ranks and first characters.
The hypotheses include X/8000 <= n1, T <= 16X+24(n1+n2), the combined endpoint
bound n0+n3 >= -T/500000, nonnegativity of n1,n2,X, and the circuit equation.
Here T bounds the sum of the two endpoint errors; it is not separately charged
to each endpoint.
The bound on T is established independently by exact interval arithmetic in
`verify.py` and in the report. It is not silently claimed as a Lean theorem.

`explicit_support_arithmetic` and `explicit_support_transport` prove the stated
scalar inequalities yielding the constants 1000000 and 30000000. Their
application to absolute coordinate norms and to the charge requires the
separately proved categorical membership and matrix-norm estimates.

The compiler does not verify Xu's inequality, coherent-sheaf geometry, the
torsion-pair construction, functor periodicity, truncation arguments, finite
Harder--Narasimhan filtrations, phase cuts, or local finiteness. Those are the
explicitly delimited written-proof and independent-review obligations in the
report. No full categorical theorem is being relabelled as kernel-verified.
