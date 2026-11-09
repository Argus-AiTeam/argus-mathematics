# Primary-space grading

**Assessment: supported written proof, not a kernel-checked theorem.** This is
`L_ABG_GRADING@1` in the old ledger, proved in old
`research/arithmetic_boundary_gluing/theorem.md`, Section 1. The source matches
the existing preserved-snapshot manifest. The argument is attributed to the old
Argus draft; literature originality is not established.

## Exact statement and hypotheses

Let \(F\) have characteristic zero, \(r\in F^\times\) have infinite
multiplicative order, and \(A\in\mathrm{PGL}_n(F)\). There is an
\(F\)-defined cocharacter \(c_{A,r}\), with a matrix lift having integral
weights between 0 and \(n-1\), which commutes with \(A\) and satisfies
\(\operatorname{Ad}(c_{A,r}(z))N=zN\) **for every**
\(N\in\mathfrak{pgl}_n(F)\) satisfying \(\operatorname{Ad}(A)N=rN\).
The construction is invariant under scalar changes of a matrix lift and
natural under conjugation; hence it commutes with the projective centralizer.
No semisimplicity, regularity, or nonzero condition on \(N\) is assumed.
The ledger specializes this statement to the local field \(L\); the prose
proof states and proves the more general characteristic-zero version.

## Decisive argument

The traceless representative of \(N\) is legitimate in characteristic zero.
For a matrix lift \(a\), a scalar error in \(aNa^{-1}=rN\) has trace zero,
so is zero. The identity
\[
 (a-r\lambda)^mN=r^mN(a-\lambda)^m
\]
sends the entire generalized eigenspace \(V_\lambda\) into
\(V_{r\lambda}\), without diagonalizing \(a\). Multiplication by \(r\)
makes the finite set of nonzero eigenvalues a disjoint union of directed
paths: infinite order excludes cycles. Giving each generalized eigenspace
its distance from the initial vertex gives the cocharacter. Every arrow
raises the weight by one; absent arrows force the corresponding map to zero.
The bound on weights follows from the number of vertices, at most \(n\).

Galois permutations preserve these paths and their initial vertices because
\(r\in F\), so the sums of equal-height spaces descend to \(F\).
Scaling \(a\) scales every vertex but not any underlying space or height.
These observations also justify the projective-centralizer assertion, even
when a centralizer lift conjugates \(a\) only to a scalar multiple of \(a\).
This is a universal prose argument; it is not an extrapolation from fixtures.
Its hypotheses are essential: the no-cycle argument is not available for a
root-of-unity multiplier.

## Evidence, dependencies, and limits

The exact replay passed: 58 partition/basis cases, four additional primary
cases including nonsplit and repeated factors, and further shared compact
fixtures. The identities in the free scalar variables are symbolic for each
fixed matrix fixture. The archived Jacobian decomposition is independently
recomputed by the verifier. See [replay.json](../computation/replay.json) and
[stdout](../computation/verifier_stdout.json). Neither verifies every \(F,n,A\).
No Lean source, compiler result, or mechanical ledger evidence exists.

The inherited independent opinion
`judgement-L_ABG_GRADING-9cebbe9d574e` supports precisely this written source;
the earlier `...-d3351a1cfd32` is the author's opinion. Both are retained with
their original producers. The open graph label does not negate either
opinion, and neither opinion makes the node kernel-proved.

Relative to the reference manuscript's `lem:compact-conjugator`, this removes
the regular-nilpotent assumption and its coefficient-extension construction
at the local algebraic step. It does not settle the arithmetic-tower lift or
prove that this grading is new. No substantive gap is identified in this
lemma under its own hypotheses. Native independent review of this assessment
is pending.
