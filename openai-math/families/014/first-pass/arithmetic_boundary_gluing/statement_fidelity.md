# Statement fidelity

This document describes C_ABG in theorem.md, Sections 1-6, and the
subordinate claims L_ABG_GRADING, L_ABG_COMPACT, L_ABG_COVER,
L_ABG_LIFT, L_ABG_GLUE, and L_ABG_DENSITY. This is not a Lean
statement-fidelity or compiler certificate.

The input is a continuous arithmetic PGL_n(L) representation on a
smooth projective finite-field curve minus a finite reduced divisor,
with dense geometric image, trivial wild inertia, and unipotent tame
boundary. The coefficient field is a finite extension of Q_l and
l differs from the finite-field characteristic. The main construction
uses a nonempty divisor; an empty divisor is handled by adding an
unramified marked closed point with logarithm zero. No regularity,
nonzero logarithm, split-point, or semisimple-Frobenius assumption
is inserted.

Arithmetic acts on the base, not on coefficients. In boundary frames,
transport B_i from i to pi(i) obeys Ad(B_i)N_i=q N_pi(i).
On an orbit of length d its ordered return product scales N_i by
q^d. The gluing maps therefore obey P_pi(i) B_i=B_i P_i; only at a
fixed point does this reduce to commutation with a single A_i.
The canonical local cocharacter is over L, not necessarily diagonal
in the original basis. Its proof uses generalized eigenspaces and
Galois descent, not a tacit diagonalizability hypothesis.

There is one auxiliary cover w^e=t, one integer e prime to l,
and one compact open J containing the original arithmetic image
and every P_i=c_i(-1/e). J is constructed in a closed faithful
linear representation; H_0 need not lift to a compact subgroup
of GL_n(L). All nodes are smoothed simultaneously and every
boundary has its own fiber identification. The common node
generator is positive on the first branch and negative on the
second. The second boundary in that generator is exp(-e a N_i),
and P_i conjugates it to exp(a N_i), not the reverse sign.

The output is a geometric unramified parameter on the smooth
proper generic curve, carrying a specified semilinear isomorphism
of its finite-torsor tower. Its first-component specialization
is the entire input arithmetic tower. Its compact geometric
image contains the first-component geometric image in compatible
frames. A parameter on a smoothing is not a parameter on the
original finite-field curve; recovery is by the specified lisse
finite-reduction specialization data. No canonical choice or
uniqueness of the smoothing is asserted.

The theorem does not assert a Weil eigensheaf, an equivariant
normalization of geometric Langlands, a representation of a
profinite Frobenius completion not supplied by the input, or
novelty of the local algebra. It uses standard geometric
theorems listed as assumptions in MATH_STATE and restated with
their hypotheses in primary_sources.txt.

The executable checks finitely many exact rational and polynomial
instances, together with the identity between primary projectors
and a symbolic cocharacter for each such instance. It replays
one archived typed Jacobian result. It cannot certify
geometric density, all local fields, deformation algebraization,
all finite quotients, or originality by enumeration. These
conclusions rest on the universal written proof and primary
inputs, and require independent Reviewer scrutiny. No finite
experiment is represented as a formal universal verification.
