# Degrees on every normalized surface-family sheet

**Assessment: supported conditional on the constructed model and bundle
agreement.** This reviews CP_DEGREE version 1 and A07 Section 3, not merely
the rank of the example matrix.

## Statement and hypotheses

Use the ordinary-terminal compact complex fourfold and specified globally
projective principalizing SNC resolution from the
[index](../../DRAFT_REVIEW_INDEX.json). Suppose the full-compact construction
has produced a small projective crepant ell:Y'->U, terminal Y', and fixed
line bundles N_1,...,N_b near the full compact inverse image. On Ureg these
agree with L_i^n for one n>0, where the original fiber classes sigma_i have
independent images under the canonical W->V. The curve domains used below
lie where that agreement and those classes are defined.

After finite puncturing of a loop-preserving core B, let S_1,...,S_s be
the irreducible surface components dominating B, counted after restriction.
Normalize them and take Stein factorizations through connected finite etale
curves C_alpha->B. The claim is that the degree matrix
d_{alpha i}=deg(N_i on a fiber over C_alpha) defines an injection
Q^b->Q^s. Its consequence is b<=s, including b=0.

## Checking the geometric reductions

Smallness in dimension four bounds the exceptional locus by dimension two,
so general fibers over B have dimension at most one. Work first over a
larger B1 around the compact closure of a smaller B0. Properness and local
finiteness leave finitely many relevant components there. Fiber-dimension
jumps, vertical components, branching, critical values and fibers wholly
inside normalization or intersection failures form discrete analytic
sets on B1. Their intersection with the relevant compact is finite.
Removing those values from B0 leaves a connected domain B whose fundamental
group still surjects onto that of T0.

This larger-domain/compact-closure step matters: an arbitrary relatively
noncompact open could have infinitely many bad values accumulating at its
boundary. The draft uses the larger domain before deleting finitely many.

After deletion, the normalization families are smooth proper connected-curve
families over C_alpha. Their fibers map birationally to distinct irreducible
curves in ell^{-1}(t), and they exhaust all of its one-dimensional
components. Removing only branching without checking normalization failures
and intersections would not justify that exhaustion. The degree of each
fixed N_i is constant on connected C_alpha, so every sheet of this one
family has the same vector d_alpha. One must not count just one sheet and
ignore the others.

## Kernel argument

If rational u_i satisfy sum_i u_i d_{alpha i}=0 for every alpha, the class
gamma=sum_i u_i c_1(N_i) has degree zero on every irreducible curve of
F'_t=ell^{-1}(t). A compact complex curve's H_2 over Q has the fundamental
classes of its reduced irreducible components as a basis; zero-dimensional
components contribute nothing. Nilpotents do not change the underlying
topological space. Rational universal coefficients therefore give
gamma|F'_t=0 in H^2(F'_t,Q).

The canonical map Rell_*Q->Rj_*Q exists because ell is an isomorphism
over Ureg; smoothness of Y' is not needed for this restriction map.
The image of gamma|F'_t is n sum_i u_i q(sigma_i(t)), by the actual
regular-locus line-bundle agreement. The q(sigma_i(t)) are independent
and n is nonzero, so every u_i vanishes. This proves the claimed injection.
The proof uses all fiber curves, not a numerically guessed matrix.

## Scope and evidence

The decisive evidence is A07 Section 3, together with the reviewed
[quotient](../link-map/report.md) and
[full-compact construction](../full-compact-model/report.md).
The parameter-family normalizations, base change, and compact-curve
homology facts are standard analytic/topological inputs, not checked by
Python. No concrete defect was found in the conditional kernel argument.
It is a step in the reproduction of the October 7 curve bound, not a
separately novel theorem.

A04/A29 verify rank([1])=1 for the sharp example. That neither constructs
the general S_alpha nor proves their matrix has rank b. The general
injectivity is established only by the prose argument just assessed.
Native independent review remains pending.
