# Primary passages used in the limit proof

## Demailly, June 21, 2012 edition

Source:
<https://people.math.harvard.edu/~demarco/Math274/Demailly_ComplexAnalyticDiffGeom.pdf>.
The title page of `demailly-2012.pdf` says "Version of Thursday
June 21, 2012". The corresponding local text is
`demailly-2012.txt`. Mathematical typography below is normalized
to ASCII/LaTeX, without changing hypotheses.

**Chapter I, Proposition 4.21, pp.36-37** (`A_SUBHARM_COMPACT`):

> The convex cone Sh(Omega) intersect L^1_loc(Omega) is closed in
> L^1_loc(Omega), and it has the property that every bounded subset
> is relatively compact.

Its proof explicitly specifies the boundedness used:

> Now, suppose that ||u_j||_{L^1(K)} is uniformly bounded for every
> compact subset K of Omega.

Our scalar functions are nonnegative and locally uniformly bounded,
so they satisfy this precise local `L^1` hypothesis.

**Chapter I, Theorem 4.18(a), p.35** (`A_RADIAL`):

> Let u in Sh(Omega) be such that u is not identically -infinity on
> each connected component of Omega. Then
> a) r -> mu_S(u;a,r), r -> mu_B(u;a,r) are non decreasing functions
> in the interval ]0,d(a, complement Omega)[, and
> mu_B(u;a,r) <= mu_S(u;a,r).

Formula (4.11), p.32, expresses convolution by a radial kernel as

`u*rho_epsilon(a) =
 sigma_(m-1) integral_0^1 mu_S(u;a,epsilon t) rho_tilde(t)t^(m-1)dt`.

The proof of Theorem 4.18 explicitly notes that monotonicity of the
convolution scale uses radial symmetry. Our kernel is both radial
and nonnegative; its radial profile need not itself be monotone.

**Chapter I, Theorem 5.4, p.39** (`A_PSH_DECREASE`):

> For any decreasing sequence of plurisubharmonic functions u_k in
> Psh(Omega), the limit u = lim u_k is plurisubharmonic on Omega.

The limit used here is between zero and a finite local bound.

**Chapter I, Theorem 5.24, p.45** (`A_REMOVABLE`):

> Let A be a closed pluripolar set in a complex analytic manifold X.
> Then every function v in Psh(X minus A) that is locally bounded
> above near A extends uniquely into a function v_tilde in Psh(X).

Here the excluded set is the branch locus pulled back to a
total-space chart. It is a union of coordinate hyperplanes.
Continuity of the trace supplies local upper boundedness and
identifies the extension with the multiplicity-counted trace.

**Chapter I, Theorem 4.12(c), p.33, and (5.3), p.39**
(`A_SUBMEAN`):

Theorem 4.12 starts with an upper semicontinuous
`u:Omega -> [-infinity,+infinity[` and gives equivalent
mean-value inequalities, including

> c) u(a) <= mu_B(u;a,r), for every B(a,r) contained in Omega.

Equation (5.3) is `Psh(Omega) subset Sh(Omega)`.
Shrinking-ball recovery of a finite value is derived in the proof
from this inequality and upper semicontinuity, not assumed as
an additional external theorem.

## Raufi: known regularization, not a novelty claim

Source: <https://arxiv.org/abs/1211.2948v3>, version dated
February 10, 2014. Local primary PDF: `raufi-v3.pdf`;
text: `raufi-v3.txt`. This version's **Definition 2**, p.2,
defines negative Griffiths curvature by psh squared norms of
holomorphic sections. Its **Proposition 1.1(i)**, p.2, says:

> Let h be a singular hermitian metric on a holomorphic vector
> bundle E, and assume that h is negatively curved in the sense
> of Griffiths as in Definition 2.
> (i) ([BP], Proposition 3.1) If E is a trivial vector bundle over
> a polydisc, there exists a sequence of smooth hermitian metrics
> {h_nu} with negative Griffiths curvature, decreasing to h
> pointwise on any smaller polydisc.

This is prior art, not an additional dependency of our independently
given convolution proof. No discrepancy is inferred between these
preprint labels and the journal labels in the staged manuscript.

## Attribution status

These are passages actually read by the Engineer, not an independent
citation verdict. The five Demailly propositions are recorded
individually on the helper claims in the shared ledger. Both goal
claims also display the same combined `A_ANALYTIC_FOUNDATIONS`
dependency, with its source and exact locators. Their independent
attribution and applicability review are still outstanding.
