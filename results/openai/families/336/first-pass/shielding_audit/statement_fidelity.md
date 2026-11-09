# Statement fidelity: the exact shielding core, not the geometric theorem

This document describes the declarations in `Main.lean`, all in namespace
`ShieldingAudit`, for claim `C_SHIELD_CORE`. The geometric theorems
`C_SHIELD_GLOBAL` and `C_SHIELD_028` are **not** Lean declarations and are
**not** what a successful compilation certifies.

All coefficients and divisions in real-valued declarations are over the real
numbers. The constants `bulkCoefficient`, `cylinderCoefficient` and
`localCoefficient` are exactly (11) and (13) of the accompanying analytic
report. In particular the subtracted vertical square is included.

## Riccati/profile algebra

`riccati_square` is a polynomial identity for all real a, c and y.
`riccati_positive` assumes a>0 and a*c>1 and proves strict positivity of
`(a/2)y^2-y+c/2` for every real y. `radial_chain` is the all-real identity
converting the Riccati expression plus y to the radial forcing inequality.
`original_profile_gap` and `refined_profile_gap` calculate the strictly positive
discriminant gaps for the original and modified profiles.
`refined_profile_below_stage` assumes the actual stage lower bound a>=3/5.

These are not existence theorems for the ODE or smooth annular potentials.
Their analytic realizations and support properties are proved in the report.

## Linear-algebra reductions and arbitrary matching seam values

`rank_eight_trace` assumes only u<=1 and proves 7<=8-u. In the geometric
application u is the squared projection of a unit hypersurface normal to the
rank-eight normal space of an affine plane. Lean does not construct that
projection or a hypersurface.

`bulk_jet_bound` and `cylinder_jet_bound` quantify over all real errors, traces,
gradient ratios and vertical costs obeying their stated scalar upper/lower
bounds. They prove the coefficient lower bounds, not a differential-geometric
Laplacian formula. `bulk_uniform_margin` and `cylinder_uniform_margin` are valid
for every real e<=1/10000 (hence on the smaller geometric interval
0<=e<=1/10000). `cylinder_limit_margin` and `vertical_square_coefficient`
calculate the strict limiting slack and the compensating square.

`seam_flux` quantifies over all real a,z with |z|<=a. The variable z represents
either signed bulk normal component; the hypothesis bounds its absolute value.
`matching_seam_flux` further quantifies over arbitrary real values vb,vc and
assumes **vb=vc**, not vb=vc=0. Its conclusion is nonnegativity of the sum of
the bulk and cylinder boundary terms multiplied by these squares.
The integration-by-parts identity and trace existence are analytic inputs,
not encoded constructions.

`forcing_branch` and `cap_branch` prove the scalar active-branch inequalities
for every real branch value. The latter uses a_r>=3/5, floor<=Pi, and D>=0.
The almost-everywhere derivative rule for finite minima/maxima is not
formalized here.

## Number-independent algebra and count gaps

`maximum_cost` holds for all real theta,k and every t in [0,1]. It is the
convex-energy inequality at the end of the concentration argument. It does
not prove strong L2 compactness, vanishing of the shrinking form, or Hilbert
energy splitting.

`guard_count_gap` quantifies over natural dimensions m>=8 and uses natural
subtraction to show m-8<m-2. `face_guard_count` quantifies over all natural
m,d,k with m-2<=k and proves the weaker face threshold. It does not construct
cores or prove that compact sets are covered. `product_capacity_gap` is the
all-integer identity preserving the exponent gap five under product factors.

`sobolev_trace_exponent`, `sobolev_bulk_exponent`,
`sobolev_interpolation_exponent` and `sobolev_absorption_gap` quantify over
real m>2 and prove the exponent relations used in the compactness argument.
They do not prove a submanifold Sobolev inequality.

`dyadic_budget` proves the exact finite-prefix formula for every real allowance
d and every natural length n. The finite sum is over k=0,...,n-1 with terms
d/2^(k+1), so its indices correspond to the positive enumeration in the report.
`dyadic_budget_upper` assumes d>=0 and bounds every such prefix by d. Passage
to arbitrary finite subsets uses nonnegativity of the terms; the analytic
construction on countably many packets and its finite-per-packet property
are not encoded.

`original_local_bound`, `refined_local_bound` and `manuscript_local_bound`
are exact rational inequalities, respectively for the improved Hardy field
with the old shell, with the modified shell, and for the manuscript's printed
coefficient calculation. `original_total_budget` and `refined_total_budget`
calculate .88 and .28. `limiting_threshold` calculates 29/108 only; it does
not assert attainability of the critical endpoint.

## Unencoded objects and conclusions

No manifold, minimizing boundary, singular set, Sobolev completion, potential
function, profile extension, face category, or compactness theorem is encoded.
A successful zero-hole compilation gives independent kernel evidence for
`C_SHIELD_CORE` only. Reading the analytic proof and its geometric hypotheses,
and determining whether the full result is new or publishable, remain
independent human/Reviewer obligations.
