# Statement fidelity: universal graph-count arithmetic

The source `Main.lean` uses Lean 4.31.0 and Mathlib. Its namespace is
`ProfiniteRigidity`. There are no added axioms, `sorry`, `admit`, or
unchecked external computations. This document describes the formal
statements, not an assertion that the compiler checked the topology.

## Objects and indices

`p`, `n`, `b`, `h`, `r`, `j`, `k`, and `B` are natural numbers.
All coefficients and divisibility relations in the principal theorems
are in the integers. `n` is **one less** than the rank:
\(d=n+1\geq1\). This indexing includes rank one at `n=0`.
For the intended group-theoretic interpretation `p` is prime;
the formal arithmetic needs only \(p\geq2\) in its nondivisibility
theorems. Divisibility results without that hypothesis are stronger
ring identities.

`lattice p 0 j = 1`, and
`lattice p (n+1) j` is the sum, for \(0\leq k\leq j\), of
\(p^{(n+1)k}\,\texttt{lattice p n (j-k)}\).
Thus `lattice p n j` is the coefficient of \(t^j\) in
\(\prod_{u=0}^{n}(1-p^u t)^{-1}\), not a count supplied as a
hypothesis. Its identification with actual open sublattices is the
elementary lifting bijection in Section 3 of `report.md`.

`denominator p n` is \(\prod_{u=1}^{n}(1-p^u)=D_d\).
Its possibly negative sign is intentional. `denominatorInverse p n k`
is a product of length-`k` finite geometric sums. It supplies an
explicit inverse of the denominator modulo \(p^k\).

For any function \(s:\mathbb N\to\mathbb Z\),
`graphCount p n b h s` is
\(\sum_{i=0}^b s_i\,\texttt{lattice p n (h-i)}\).
Subtraction of natural-number indices is truncated; every theorem
using stabilization assumes \(b\leq h\), directly or as a consequence
of its displayed large-index hypothesis, so truncation does not
change the intended indices.

## Principal declarations

1. `lattice_stabilization`: for all \(p,n,j\),
   \(p^{j+1}\mid D_d a_j(d)-1\). The coefficients are defined by the
   recurrence above and this congruence is proved, not assumed.

2. `denominator_inverse` and `cancel_denominator`: for all \(p,n,k\),
   \(p^k\mid D_d I-1\) for the explicit geometric-sum inverse \(I\);
   consequently \(p^k\mid D_dc\) implies \(p^k\mid c\).
   No unproved coprimality assumption is hidden in the cancellation.

3. `weighted_stabilization`: for every integer-valued `s` and \(b\leq h\),
   \(p^{h-b+1}\mid D_d c_h-\sum_{i=0}^b s_i\).
   It does not assume positivity of the weights.

4. `effective_power_bounds`: for all \(p\geq2,n,b,h,s\), if
   \(h\geq b(n+2)=b(d+1)\) and
   \(\sum_{i=0}^b s_i=p^{b(n+1)}=p^{bd}\), then
   \[
      p^{bd}\mid c_h,\qquad p^{bd+1}\nmid c_h.
   \]
   For prime \(p\) this states exactly \(v_p(c_h)=bd\), including
   nonzeroness. It is not a finite list of numerical instances.

5. `effective_obstruction`: for all \(p\geq2,n,b,r,s\) with \(r\leq b\)
   and the same total-weight identity, at \(h=b(n+2)\),
   \(p^{h+1}\nmid p^r c_h\).
   The auxiliary `scaled_obstruction` proves the more general
   cancellation-free nondivisibility implication from
   \(p^{B+1}\mid Dc-p^B\).

6. `fiber_total`: for every finite type `α`, finite label type `ι`,
   \(d\in\mathbb N\), and arbitrary labeling of the functions
   `Fin d → α`, the sum of the cardinalities of all label fibers is
   \(|\alpha|^d\). This certifies the elementary partition-of-tuples
   counting principle, not the finite-abelian duality bijection.

`power_dvd`, `geometric`, and `no_next_power` are elementary auxiliary
lemmas proved in the same source. Standard Mathlib and Lean logical
axioms are used; no project axiom is introduced.

## What is, and is not, encoded

In the application \(s_i\) is the sum of surjection counts to the
actual quotients of \(A=K^{ab}\) of order \(p^i\). Section 1 of the
report proves the graph-subgroup bijection, and Section 2 proves
that these weights sum to \(p^{bd}\) using finite-abelian duality.
These group-theoretic identifications are **not** Lean hypotheses
silently treated as established: they are explicit prose proof
obligations outside this formalization. The formal theorems take an
arbitrary weight function and the precise scalar total identity.
`fiber_total` does not replace the required duality argument.

Similarly, `r` is an arbitrary natural number bounded by `b`; Lean
does not construct \(K/\Phi(K)\), prove its detector property, or
construct a Burnside idempotent. Section 4 supplies those proofs and
shows that the obstruction is exactly the manuscript congruence sum
for the inflated integral virtual set \(|F|e_F\).

The formal source does not encode profinite topology, the transfer
of finite-set tests under shrinking actions, construction of the
closed subnormal series, any character ring or spectrum, or
`thm:main`. Sections 5--6 give an independent prose verification of
the full profinite theorem. Its acceptance and this translation's
fidelity require independent Reviewer reading. A successful compiler
run certifies precisely the universal arithmetic declarations above.
