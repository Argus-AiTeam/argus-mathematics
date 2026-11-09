# Statement fidelity: exact quartic and all-depth summation core

This file describes only claim `C_Q_SERIES_CORE` and the elementary
quartic identities used alongside it. It does not encode or certify
the analytic claims `C_Q_KERNEL`, `C_Q_MASK`, `C_Q_ERROR_2`,
`C_Q_TELESCOPE`, or `C_Q_GROWTH`.

All real variables range over the ordinary real field. All depths,
row lengths, and indices range over arbitrary natural numbers,
including zero; they are not bounded test parameters.

All declarations below are in namespace `QuarticCore`.

`quartet_factor` states the spatial resonance identity after
the alternating spatial sum has eliminated the third frequency:
xi1=a, xi2=b, xi3=b+d-a, xi4=d. Thus u=a-b, v=a-d and the alternating
sum of squares is 2uv. It does not assert a free evolution equation.

`gaussian_completion` states the completion of squares for
frequencies x, x-u, x-u-v, x-v and integration center a. The midpoint
is x-(u+v)/2. This is the polynomial prerequisite for integrating the
Gaussian center, not a formalization of Gaussian integration.

`potential_expansion` is the scalar product expansion for
arbitrary real values of the two new and two old Gaussian multipliers.
It supplies the signs of the error term, but does not formalize a
quartic Fourier integral or its symmetry.

`geometric_identity` and `geometric_bound`
state the exact finite geometric identity and its uniform upper
bound for every real r with 0<=r<1. The application uses r=K^-2.

`dyadic_exact` and `dyadic_bound` state, for
every natural N, that the sum over k<N of (2k+1)/2^k equals
6-(4N+6)/2^N and is at most 6.

`rectangle_exact` and `rectangle_bound` state,
for every natural N, that the sum over k<N of (k+3)/2^k equals
8-(2N+8)/2^N and is at most 8. This majorizes the normalized
off-diagonal cap-offset costs after the analytic bounds in the report.
The theorem does not prove those kernel or offset-count bounds.

`weighted_geometric_budget` has arbitrary nonnegative real
D and nonnegative loss sequence, an arbitrary natural-valued row-height
function, arbitrary finite row count M, and arbitrary base depth N.
For 0<=r<1 it bounds D times the base geometric sum plus each loss times
its own row's geometric sum by (D+sum losses)/(1-r).
The triangular scale sum in the report is one choice of row heights.
It does not assert the energy contraction or identify the loss
sequence with the actual smooth masks.

The source contains no added axioms, proof holes, or declarations of
analytic inequalities. A successful compiler run verifies precisely
these algebraic and finite-sum statements. The mathematical report
and its application to the manuscript still require independent review.
