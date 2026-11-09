# Source scope and antecedents

The bounded claim is the algebraic bridge in the zero-plane manuscript,
`build/sections/02-preliminaries.tex` and `05-hessian.tex`, specifically
`lem:real-vector-projections` and `prop:hessian-projection-cost`, equation
(14). Sources and supplied verification programs are not modified or used as
an oracle. The other manuscripts' dependency statements were read separately
to populate the campaign graph. None of their global conclusions is assumed
in the proof of this bridge.

The conventions taken from Section 2 are the Euclidean metric on real
four-vectors; commuting quaternion triples with positive cyclic product;
the Hilbert--Schmidt metric on symmetric trace-free three-by-three matrices;
and the Bianchi equations `sum_s I_s Z_sr = 0`. In particular, off-diagonal
matrix entries count twice. The objects named `G`, `P_+`, `P_-`, and the
curvature actions are reconstructed from these data, not assumed to have
the desired identities. For the cost theorem, `T,U` are arbitrary real
symmetric trace-free matrices, `x=-lambda_min(T)`, `y=-lambda_min(U)`,
and `x+y<=2`. There is no assumption of distinct eigenvalues, nonzero
blocks, or realization by a global Einstein metric.

## Known external results, not campaign discoveries

Primary source opened: M. J. Gursky and C. LeBrun, *On Einstein Manifolds
of Positive Sectional Curvature*, arXiv:math/9807055v1, Section 3:
<https://arxiv.org/html/math/9807055v1>.

Lemma 4's proof, equation (10), gives the divergence-free half-Weyl
constraint. Equation (11) gives
`|nabla W+| >= sqrt(5/3) |nabla |W+||`.
Equation (12) is the Weitzenbock formula, with the **positive** Laplacian;
the staged manuscript instead uses the trace Laplacian. This is a convention
change, not a contradiction.

Theorem 1 states, for a compact oriented Einstein four-manifold with
positive scalar curvature and nonzero `W+`,
`integral |W+|^2 >= integral s^2/24`, with equality exactly when
`nabla W+ = 0`. Corollary 1 gives the exchanged orientation. At
`Ric=3g`, with the manuscript's matrix norm and normalized volume, this is
`E v^2 >= 1`. These statements are recorded as antecedents of the global
manuscript claims, not premises needed by the independent matrix proof.

The primary text was obtained. An AI search summary misidentified Theorem 1
and equations (10)--(12); that summary is not evidence and is not used.
The independent Reviewer still owns confirmation of these citation readings.
The citation tool's archive would write under `research/literature/`, outside
this mission's writable paths; no such write has been made.

## Approaches not used

A successful supplied checker run, finite numerical sampling, or the absence
of a small counterexample cannot prove the universal projection identities
or the closed-cone operator inequality. Those are not routes to the present
goal. The certificate instead compares all coefficients in rational
coordinates and proves positivity by exact orthogonal-projector
decompositions.

The Jacobian catalog offered bounded rational linear solving, not a
universal tensor-inequality prover. Its one operation solves only for the two
coefficients of the Bianchi Casimir projector after the two eigenvalues
have been independently established. Its result is not used to certify
anything beyond that finite linear system.
