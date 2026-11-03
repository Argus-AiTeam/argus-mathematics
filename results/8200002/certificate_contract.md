# Exact certificate contract

## Witness

A successful certificate contains three unnormalized matrices
\(H_1,H_2,H_3\in K^{6\times 6}\) in one explicit algebraic number field
\(K\subset\mathbb C\), together with a specified complex embedding.  Each field
generator must have a defining polynomial over \(\mathbb Q\) and rational
isolating data that selects the embedding.  An equivalent exact representation
(for example, compatible minimal-polynomial representations for every entry)
is acceptable only when the checker can perform the same exact zero tests.

The four bases are
\[
  I_6,\qquad H_1/\sqrt 6,\qquad H_2/\sqrt 6,\qquad H_3/\sqrt 6.
\]

## Exact acceptance identities

The rerunnable checker must prove, using exact arithmetic:

1. \(h\overline h=1\) for every entry of every \(H_i\).
2. \(H_i^*H_i=6I_6\) for \(i=1,2,3\).
3. For every \(1\leq i<j\leq3\) and every \(1\leq a,b\leq6\),
   \[
     (H_i^*H_j)_{ab}\overline{(H_i^*H_j)_{ab}}=6.
   \]

The checker must exit nonzero on a failed identity or malformed certificate and
must report the field/embedding, all checked identity counts, and the first
failed identity.  Floating-point residuals, interval overlap with zero,
timeouts, and finite search exhaustion are not certificates.

## Gauge and normalization

The shared ambient unitary and independent phase/permutation choices of vectors
allow the first basis to be fixed as \(I_6\).  After that:

- a single left monomial action is common to all three \(H_i\);
- right monomial actions may be chosen independently for each \(H_i\);
- therefore \(H_1\) may be fully dephased;
- an independently classified dephased representative \(A_i\) for \(i=2,3\)
  must be restored as \(H_i=D_iP_iA_i\), with its relative row phases \(D_i\)
  and relative row permutation \(P_i\) retained as search variables;
- independent right monomial factors can be omitted because they only
  phase/permute the vectors inside one basis.

In particular, independently dephasing the first columns of \(H_2\) and
\(H_3\), or independently fixing their row permutations, is forbidden unless
the removed \(D_i,P_i\) data is explicitly restored before cross-unbiasedness
is tested.

## Candidate boundary

A numerical point is only a reconstruction seed.  Promotion requires an exact
common-field representation, embedding isolation data, and a successful fresh
run of the exact checker over all 108 entry-modulus identities, 108 Gram-matrix
entries, and 108 cross-modulus identities (counting one exact equality per
matrix entry).
