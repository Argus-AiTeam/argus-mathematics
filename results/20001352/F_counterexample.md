# An exact negative witness for the literal F branch

This is a concrete candidate with elementary universal obstruction proofs and
an exact rational replay, not a claim of independent acceptance or a formal
compiler certificate. Both routes below use the same witness but neither
obstruction depends on the other.

## Source and scope

The already identified primary source is
[AimPL, Groups of dynamical origin, Problem 3.1](http://aimpl.org/groupdynamorigin/3/),
read on 2026-09-05. Its group list explicitly includes F. The short passage
actually read is in `evidence/aimpl_problem_3_1_excerpt.txt`. No new source
discovery was needed.

The read-only row for ID 20001352 in
`../../audits/status/agent-priority-01.csv` has status `partially_resolved` and
review flag `independently_verified`. It reports the torsion obstruction for F
and the abelianization F/[F,F] isomorphic to Z^2. That is the strongest prior
result used for orientation. This submission adds an explicit element, full
affine interval data, and a self-contained proof of the needed character
obstruction; it does not improve or newly discover either general fact.
The cited paper behind the audit is not a dependency of the arguments below.

Let F mean the group, under composition, of increasing piecewise-linear
homeomorphisms of [0,1] with finitely many dyadic breakpoints and slopes in
{2^n : n is an integer}. All factors in this submission belong to F.
Interpret the involution question charitably as an upper bound of three
factors, not an equality for every individual element. Even allowing the
identity among maps satisfying h^2 = id does not rescue that bound.

For commutators use [a,b] = a b a^(-1) b^(-1).
Unrestricted commutator length is the minimum number of these factors, with
value infinity if no finite factorization exists. If the original convention
defines length only on [F,F], the correction is to restrict its domain, not a
counterexample to a width bound on that restricted domain.

## Exact witness

Define f by

    f(x) = x/2       for 0 <= x <= 1/2,
           x - 1/4   for 1/2 <= x <= 3/4,
           2x - 1    for 3/4 <= x <= 1.

Its complete knot list is

    (0,0), (1/2,1/4), (3/4,1/2), (1,1).

The formulas agree at the two shared endpoints. Their slopes are positive
powers of two, so f is continuous and strictly increasing on the whole
interval. It fixes 0 and 1, hence is a homeomorphism onto [0,1]. Its only
breakpoints are dyadic. Thus f belongs to F. Moreover f(1/2) = 1/4 != 1/2.
The inverse has the complete pieces

    f^(-1)(y) = 2y        for 0 <= y <= 1/4,
                y + 1/4  for 1/4 <= y <= 1/2,
                y/2+1/2  for 1/2 <= y <= 1.

Membership and the inverse identities concern entire affine intervals, not a
sampled grid. The machine-readable object is `evidence/f_witness.json`.

## Route R-involutions: order preservation

Let h be any increasing homeomorphism of [0,1] satisfying h(h(x)) = x for
every x. If h(x) > x at any point, strict increase gives

    x = h(h(x)) > h(x) > x,

a contradiction. If h(x) < x, strict increase instead gives

    x = h(h(x)) < h(x) < x,

also a contradiction. Consequently h(x) = x for all x.
In particular every element of F whose square is the identity is itself the
identity. If "involution" requires order exactly two, F has none.

Every finite product of maps in F satisfying h^2 = id is therefore the
identity, including the empty product. Our explicit nonidentity f is not such
a product for any number of factors, and in particular not for at most three.
This excludes all factorizations, not just those on a bounded subdivision.

## Route R-character: endpoint slopes

For g in F, define

    chi(g) = (log_2 g'(0+), log_2 g'(1-)) in Z^2.

Both one-sided derivatives exist and are positive powers of two because the
piecewise-linear subdivision is finite. Every increasing homeomorphism of
[0,1] fixes both endpoints. To check the homomorphism law without a
differentiability assumption away from the endpoints, write

    h(t) = 2^b t,       g(s) = 2^a s

on sufficiently small right neighborhoods of 0. For sufficiently small t,
h(t) lies in that neighborhood for g, so (g o h)(t) = 2^(a+b)t.
Near 1 the corresponding formulas are

    h(1-t) = 1 - 2^d t,   g(1-s) = 1 - 2^c s,

and their composition has slope 2^(c+d). Thus

    chi(g h) = chi(g) + chi(h),   chi(id) = (0,0),
    chi(g^(-1)) = -chi(g).

For arbitrary a,b in F this gives

    chi([a,b]) = chi(a) + chi(b) - chi(a) - chi(b) = (0,0).

By repeated use of the homomorphism law, every finite product of
commutators in F has character (0,0). Our witness has

    chi(f) = (-1,1) != (0,0).

It follows that f is outside [F,F] and cannot be a finite product of
commutators in F. This uses only [F,F] contained in ker(chi); it does not
assume, or need to prove, that the kernel is exactly [F,F] or that chi is
onto. It establishes the literal unrestricted-domain correction, not a
lower bound of two on internal commutator width.

## Exact replay and its limits

From this campaign directory run:

    /home/argustest/zimo/argus-latest/.venv/bin/python scripts/verify_f_witness.py --route involutions
    /home/argustest/zimo/argus-latest/.venv/bin/python scripts/verify_f_witness.py --route commutators

The verifier uses only the Python standard library and exact fractions. It
checks every affine piece, complete domain coverage, continuity, dyadic data,
slopes, endpoint images, nonidentity, inverse formulas on complete intervals,
and the endpoint character. Each route is run separately. It also checks that
the saved Jacobian request and result really encode this witness's affine
endpoint equations; its correctness does not require trusting the solver.

Jacobian discovery found no direct Thompson, piecewise-linear, involution, or
commutator operation. The inspected operation
`matrix.rational_linear_system.solve` was used only for the matching
six-variable rational interpolation calculation. Its exact contract, request,
result, and execution metadata are under `evidence/jacobian/`.
That result alone does not certify F membership or either universal argument.

The code certifies the finite exact inputs to the two elementary proofs.
The universal order and homomorphism arguments above require mathematical
reading, and the source interpretation requires independent reading.
No finite enumeration, numerical approximation, or solver outcome is being
promoted to a universal group-theoretic theorem.

## What is not concluded

Nothing here resolves the T, V, topological-full-group branches, commutator
length restricted to [F,F] with factors in F, internal commutator width of
[F,F] with factors in [F,F], or the finitely-presented-simple-group question.
No novelty is claimed. Earlier cancelled missions remain operational
interruptions; neither of these mathematical routes has been retired.
Independent Reviewer replay and acceptance are still required.
