# A uniform integral test for alternating odd paths

## Scope and prior results

The object being audited is the *specified generator*, not its ambient
representation. The companion's `path:contraction`, `path:segment`,
`prop:two-band`, and `path:generator-sign`, and the universal paper's
`band:path-support`, specify the conventions used below. Both manuscripts
are the staged September 24, 2026 versions.

Brown, van Willigenburg, and Zabrocki, *Expressions for Catalan Kronecker
products*, Pacific J. Math. 248 (2010), 31-48,
doi:10.2140/pjm.2010.248.31, Corollary 4.1, is cited by both manuscripts
for ambient four-row support of the two-row square. Ambient support alone
does not identify the cyclic span of the prescribed tensor. It is not an
assumption of the integer contraction theorem proved here. The primary
source was opened at Corollary 4.1: its second identity is
`sum_{lambda |- 2d-1, length(lambda)<=4} s_lambda =
s_(d,d-1) * s_(d,d-1)` for positive integers d.
The short passage and exact source URL are in `BWZ_excerpt.txt`.

The interpretation of a nonzero contraction as a constituent uses the
ordinary complex Specht construction and self-duality (James, *The
Representation Theory of the Symmetric Groups*, 1978, Definitions 4.1,
4.3 and Theorems 4.12, 6.7), and complete reducibility over characteristic
zero (Fulton-Harris, *Representation Theory*, 1991, Proposition 1.5 and
Corollary 1.6). These representation-theoretic inputs are separate from
the algebraic certification, which will not formalize them.

The manuscripts already prove existential nonvanishing by choosing a
conjugator depending on the column list, and simultaneous nonvanishing
for any finite collection by a genericity argument. The proposed
improvement is one explicit integral basis for every ordered list and
every positive odd length, with its exact contraction value. This is not
a claim to prove either manuscript's main theorem.

Using the unconjugated basis is a known failed route to a fixed-endpoint
nonvanishing statement: the companion explicitly gives column lengths
(3,2), product 12T, and zero (1,1) entry. This does not refute its
existential assertion.

## Mathematical conventions

Indices below are zero-based in code: the manuscript's letter 1 is 0.
Let I, Z, T, J be respectively the identity,
diag(1,-1), [[0,1],[1,0]], and [[0,1],[-1,0]].
The row-layer pairs are (2,3),(4,5),... in one-based path positions;
the column-layer pairs are (1,2),(3,4),... . Both endpoint singleton
letters are the manuscript's 1. Every alternating pair has coefficient
J[a,b] in increasing path order. Evaluation is bilinear, not Hermitian.

The fixed basis is N_i = Q M_i Q^{-1},
Q = [[1,1],[1,2]], (M_1,M_2,M_3,M_4) = (I,Z,T,J).
No endpoint letter or generator is changed by this test-basis change.

## The uniform theorem

**Theorem (integer contraction, arbitrary length).** Let k=2t+1 with
t>=0. Let r_1,...,r_c be any ordered list in {1,2,3,4} whose sum is k.
Let u be the actual two-layer path generator just specified, and let
t_N be the product, on those consecutive segments, of the signed
alternations of the first r_j matrices in the *single fixed basis*

```
N_1 = [[1,0],[0,1]],    N_2 = [[3,-2],[4,-3]],
N_3 = [[1,0],[3,-1]],   N_4 = [[-3,2],[-5,3]].
```

Then

```
<u,t_N> = epsilon * product_j (r_j!),
epsilon in {-3,-1,1,3}.
```

In particular the pairing is nonzero. This one basis works
simultaneously for all such paths and all such lists, not just for
each fixed finite collection. The theorem does not require that the
column lengths be in decreasing order. Its restriction to the columns
of a partition is the desired dual-polytabloid statement.

### 1. The actual tensor coefficient sum

For arbitrary matrices X_1,...,X_k, the physical coefficient expansion
in the manuscript's one-based indexing is

```
sum_{a_1,...,a_k,b_1,...,b_k in {1,2}; a_1=b_k=1}
  product_{l=1}^t J[b_(2l-1),b_(2l)] J[a_(2l),a_(2l+1)]
  product_{i=1}^k X_i[a_i,b_i].                         (1)
```

Each alternating pair uses each of its two letters exactly once; its
coefficient is J on those letters. The two singleton blocks give
exactly the endpoint constraints in (1). Thus (1) is an expansion of
the specified generator, not a surrogate definition by a matrix
product.

Here is also the precise index bijection underlying the formal
definition `raw`. At an odd slot let its entering index be a_i and
its exiting index be b_i; at an even slot let its entering index be
b_i and its exiting index be a_i. An edge joins the exiting index
of slot i to the entering index of slot i+1. Its coefficient is
J[b_i,b_(i+1)] for odd i and J[a_i,a_(i+1)] for even i, exactly as
in (1). These exiting indices and the next entering indices are the
two indices independently summed by each recursive `raw` step.
Fix the first entering index to 0 in code. Add a final edge with
outgoing index 1 in code: `J[b,1] = delta(b,0)`. This adds neither
a degree of freedom nor a sign, and fixes the last physical letter
to 0. Removing that last delta edge is an inverse to the index
assignment just described. Therefore every term of (1), with its
coefficient and endpoint constraints, occurs exactly once in `raw`.

Successive summation gives the product

```
[X_1 J X_2^T J X_3 J ... J X_(k-1)^T J X_k]_(1,1).
```

For X=[[a,b],[c,d]], direct multiplication gives
`J X^T J = -[[d,-b],[-c,a]] = -adj(X)`. Thus (1) equals

```
(-1)^t [X_1 adj(X_2) X_3 ... adj(X_(k-1)) X_k]_(1,1). (2)
```

For k=1 this is simply X_1[1,1], with no pairs. No trace, cyclic
reordering, transpose-invariant pairing, or moving endpoint vector
has been used.

### 2. Dual columns and the segment identity

Let D_i(X)=X at odd positions and adj(X) at even positions. These
are linear maps on two-by-two matrices. Substituting the independent
dual column alternations into (2) and distributing the finite sums
gives

```
<u,t_M> = (-1)^t [ A_(r_1,s_1) ... A_(r_c,s_c) ]_(1,1), (3)
s_j = 1 + sum_{i<j} r_i,
A_(r,p) = sum_{pi in S_r} sign(pi)
            D_p(M_(pi(1))) ... D_(p+r-1)(M_(pi(r))).
```

This is the product in the original path order; no factors belonging
to different segments are interchanged.

I commutes with everything; Z,T,J anticommute in pairs, have zero
trace, and have squares I,I,-I. If I occupies local slot j in a
summand of A_(r,p), moving it from the first canonical slot accounts
for a permutation sign (-1)^(j-1), but no matrix-product sign.
The sign from reordering the other matrices cancels their permutation
sign. If e positions of the segment are even and delta records that
p is even, adjugation contributes (-1)^(e-epsilon_j), where
epsilon_j = delta+j-1 modulo 2. Hence every signed summand equals
`(-1)^(e-delta) M_1 ... M_r`. There are r! such summands.
The resulting table is

| r | odd start | even start |
|---|-----------|------------|
| 1 | I | I |
| 2 | -2Z | 2Z |
| 3 | -6J | -6J |
| 4 | -24I | 24I |

This proves `path:segment`, including both r=1 boundary cases.

### 3. One conjugator for every product

The eight matrices {I,Z,T,J,-I,-Z,-T,-J} are closed under
multiplication. For example ZT=J, TZ=-J, ZJ=T, JZ=-T,
TJ=-Z, JT=Z and J^2=-I. After factoring out the positive
integer `product_j r_j!`, every product in (3) is one of these
eight matrices, regardless of the number or order of the columns.
This is an induction on an arbitrary list, not a finite-length
extrapolation.

Adjugation commutes with conjugation: from
`adj(X)=tr(X)I-X`, or directly in coordinates,
`adj(QXQ^{-1})=Q adj(X) Q^{-1}`.
The conjugated normalized product is therefore one of
{+/-N_1,+/-N_2,+/-N_3,+/-N_4}. Their first diagonal entries
are respectively +/-1, +/-3, +/-1, -/+3. Including (-1)^t
gives exactly the four possible epsilon values stated above.
All eight endpoint entries are nonzero. Conjugation is invertible
and the four flattened covectors have coordinate determinant 4,
so this really is an ordered complex test basis. It is not asserted
to be a basis of the integral lattice Mat_2(Z).

This completes the proof for arbitrary positive odd length.

### 4. Orientation and representation-theoretic consequences

The companion's path numbering reverses the order in each of its
m-1 column pairs and preserves the row-pair orders. Thus
`u=(-1)^(m-1) u_(m,2)`. This changes only the total sign; both
singleton letters remain fixed. For k=2m-1, the theorem therefore
supplies the generator-specific nonzero pairing needed by
`prop:two-band`. For arbitrary k it supplies the contraction part of
`band:path-support`, and replaces that lemma's finite generic-basis
argument by a simultaneous witness even for the infinite family of
all ordered lists.

For a partition, independently alternating the first r_j basis
entries in its tableau columns is a dual polytabloid, including
when the columns are placed in a different order along the path.
Its irreducible orbit and the invariant evaluation pairing give a
nonzero equivariant map from the cyclic generator span to the
self-dual Specht module. Complete reducibility then gives the
constituent. These are precisely the separate complex
representation-theoretic assumptions recorded in the ledger,
not part of the integer kernel theorem.

As an elementary consequence of the integer equality, the same
tensor contraction remains nonzero over every field of
characteristic other than 2 or 3: its factors are 1!,2!,3!,4!
and +/-1,+/-3. No modular Specht irreducibility, semisimplicity,
or modular constituent assertion is inferred.

## Exact and formal evidence

`verify.py` uses only the Python standard library. In its default mode
it recomputes and compares `exact_certificate.json`; the explicit
`--write-certificate` option regenerates that certificate.
It recomputes all eight matrix/adjugate segment sums, all eight raw
index-transfer segment sums, the basis determinant, all 64
normalized state transitions, and every possible odd endpoint.
Its independent physical tensor evaluator enumerates the two layers'
alternating assignments and evaluates each dual column by its
determinant, without using the matrix recurrence.

The semantic checks cover all 284 ordered lists of odd total length
at most 9, and all 1,092 matrix-unit words of lengths 1,3,5.
These are finite regression checks, not the proof of the theorem.
Examples in the fixed basis include `(1) -> 1`, `(3) -> -18`,
`(2,1) -> 6`, `(3,2) -> 12`, `(4,3,2) -> -288`.
The original unmodified basis gives zero on `(3,2)`, exactly as
the manuscript says; this is not a refutation.

`Main.lean` formalizes the raw coefficient network, all signed
permutation sums, both distributive bridges, the finite local
transition identities, and the arbitrary-list induction. The
standalone reading of its statements is `statement-fidelity.md`.
The all-length endpoint theorem is not assumed as an axiom.

The official `lean_evidence verify` run succeeded on Lean 4.31.0 with
`exit_code=0`, `proof_holes=[]`, no compiler diagnostics, and only the
standard axioms `propext`, `Classical.choice`, and `Quot.sound`.
The source-bound, claim-bound certificate is
`certificates/C_ODD_PATH_UNIFORM-55d427d9f82520a1.json`; the raw official
result is `lean_recording.json`. The ledger reports `closed_kernel`
with no external assumptions for `C_ODD_PATH_UNIFORM`, not an
independently approved translation or research result. The subsequent
official Lean evidence check found no stale source/fidelity evidence.

Both mandated final checks passed with exit status zero against the
exact campaign root
`campaigns/9000205`:
`math_state check` and `proof_graph_check check`.
Two route goal references made stale by attaching the formal statement
were rebound to the current version of the same mathematical claim;
their decompositions and the retired route's obstruction were preserved.
The exact verifier also replayed the stored certificate successfully.
None of these are independent Reviewer judgments.

Jacobian discovery found no matching universal tensor operation.
The inspected univariate matrix-polynomial operation cannot express
the claim. It was used only for the relevant bounded identity
`J^2+I=0`, with the exact typed request, output, protocol, server
version and adapter status preserved in the dedicated JSON files.
The all-length argument does not depend on Jacobian availability.

## Relation to the full manuscripts and novelty limits

The proof graph now records both main theorems and their unresolved
load-bearing dependencies. This result settles their shared
odd-path noncancellation core; it does not settle triangular
coordinate quotients, the dominance/strip induction, attachment
separation, balance components, capacity arguments, or character
computations. In particular no degree-64 computation was rerun.

Relative to the strongest relevant prior statement in the staged
manuscripts, the improvement is explicit and mathematical: a single
integral basis, simultaneous for all lists and lengths, with an
exact factorial value up to one of four fixed nonzero scalars,
rather than a list-dependent eigenvector or a finite genericity
argument. A targeted literature search found no primary source for
this precise fixed-basis strengthening. That bounded retrieval is
not a proof of novelty or publishability; independent evaluation of
those questions remains required.

No false literal manuscript assertion was found in the audited path
steps. Accordingly no refutation claim is manufactured from the
known zero in the unmodified test basis. Independent Reviewer replay,
statement-fidelity approval, and significance/novelty assessment
remain pending; the Engineer does not claim independent acceptance.
