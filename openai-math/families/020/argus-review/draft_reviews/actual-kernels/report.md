# Actual evaluation kernels and rank records

## Status, claim and provenance

**Engineer assessment:** the argument works for the source's comparison of a block with that block after inserting one new prime. It does not assert that equal ranks on arbitrary, incomparable block choices determine the same kernels. This is a substantive mathematical assessment, not independent acceptance.

Exact old claim **C_ADAPTIVE_KERNELS@1**:

> The manuscript-defined full evaluation kernels and deterministic patches yield a lexicographically nonincreasing rank vector under prime insertion; equal complete mixed-radix records imply identical kernels, patches and evaluated minors at every stage.

Read-only sources:

- **R:** campaign `9000020/research/adaptive_prime_audit/report.md`, lines 101–158. This is the old Argus argument/reconstruction.
- **M:** September 24, 2026 manuscript, `build/sections/03-affine-counting.tex`, lines 75–159 and 236–297. In particular, the patch convention is at 147–158, the actual path is at 259–279, and the rank argument is at 281–296.
- Supplied manuscript reference revision: `4eaee87548250b2682affda7d05d947c05554bae`; supplied preserved family snapshot: `2026-11-06T10:20Z`. These provenance facts were not rechecked here.

The current scope assumptions in campaign `9200020/research/MATH_STATE.json` are respected. Historical supportive labels do not establish current acceptance. No old ledger, graph, draft or manuscript was modified.

## Actual hypotheses and objects

Fix a finite integer point set \(S\), a point \(z\in S\) covered by the initial patch list of \(Z\), a path length \(r\), and the same ordinary degree limits \(D_i\) for both paths. Put
\[
V_i=\mathbb Q[x_1,\ldots,x_N]_{\le D_i},\qquad
M_i=\dim V_i=\binom{N+D_i}{N}.
\]
Fix all blocks except one, and compare a block \(B\) with \(B\cup\{q\}\), where the prime \(q\) is new and the disjoint-block condition remains satisfied.

For each path, M:267–273 defines the **entire rational evaluation kernel**
\[
\mathcal K_i=\ker\!\left(V_i\longrightarrow
\mathbb Q^{T_i}\right),\qquad
T_i=\{s\in S\cap A_{i-1}:s\equiv z\pmod{Q_i}\}.
\]
The recorded quantity is its **codimension**
\(\rho_i=M_i-\dim\mathcal K_i\), equivalently the evaluation rank, not its dimension.

The next input is the algebraic set \(A_{i-1}\cap V(\mathcal K_i)\), not a variety obtained by selecting just one element of the kernel. A basis of the kernel suffices to define its zero set, but the object is independent of that basis. Patches and their integer equations, chosen minor and order are fixed functions of the input algebraic set, the common degree allowance and the same \(S\) (M:147–158). Existence of those covering lists is the patch-lemma dependency; its geometry and height are assessed in `../patch-height/report.md`.

## Decisive insertion argument

1. **The initial patches agree.** The input \(Z\), \(S\), degree allowance and point \(z\) have not changed. The deterministic list and its first member covering \(z\) therefore agree.

2. **The comparison stays inside one parent until the first rank change.** Suppose the previous patches agree. Before the affected block, the cumulative modulus is unchanged. At and after that block, it has gained the factor \(q\). Thus the new residue condition implies the old one, so
   \[
   T_i^+\subseteq T_i,\qquad
   \mathcal K_i\subseteq\mathcal K_i^+\subseteq V_i.
   \]
   This is actual point-set containment inside the same parent; it is not an abstract assertion about ranks on unrelated varieties.

3. **Equality of codimensions is enough at this step.** If \(\rho_i^+=\rho_i\), the nested finite-dimensional subspaces have the same dimension, hence are identical. Their entire intersection sets are identical. Applying the same patch rule and taking the first patch covering the same \(z\) gives the same \(A_i,G_i,\Delta_i\), including the integer normalization of \(G_i\) and \(\Delta_i\).

4. **The first changed digit decreases.** Still on the common parent, kernel inclusion gives \(\rho_i^+\le\rho_i\). If it is the first strict change, it is a decrease. Subsequent parents may differ and subsequent ranks need not be separately monotone. This proves precisely lexicographic nonincrease.

5. **No changed digit means full path equality.** If all \(r\) ranks agree, step 3 applies at every stage. All kernels, patches, chosen polynomial minors and their evaluations at \(z\) agree, including the initial minor. In particular the products \(\prod_{j=0}^r\Delta_j(z)\) agree. This checks R:121–141 and M:281–288 without replacing the manuscript path by a fixed variety or by independently sampled integers.

The argument also extends to comparable blocks connected by successive insertions: if the endpoint records agree, monotonicity forces every intermediate record to agree. It does **not** extend merely from equality of ranks for two incomparable blocks. Without point-set/kernel inclusion, equal dimensions alone do not identify their subspaces. The exact old claim must be read with its preceding “under prime insertion” comparison; an unrestricted interpretation of its second clause would be an unsupported strengthening.

## Mixed-radix size and orientation

Let \(w_i=\prod_{j>i}(M_j+1)\), with empty product \(1\), and let
\(\mathcal R=\sum_i\rho_iw_i\). For digits \(0\le\rho_i\le M_i\),
\[
\sum_{j>k}M_jw_j=w_k-1,\qquad
\sum_{i=1}^r M_iw_i=\prod_{i=1}^r(M_i+1)-1=B_0-1.
\]
If \(k\) is the first changed digit, its decrease contributes at most \(-w_k\), while any opposing suffix change contributes at most \(w_k-1\). Consequently \(\mathcal R^+\le\mathcal R-1\). The same suffix bound proves injectivity: two vectors with a first different digit cannot have equal encodings. Thus \(0\le\mathcal R<B_0\), its orientation is nonincreasing under insertion, and equal encodings in that comparison force equal complete vectors and hence equal evaluated minors.

The digit bound includes zero and maximal digits; leading or trailing zero digits do not cause ambiguity because the length and radices are fixed. No reversal from “kernel dimension” to “codimension” is hidden in this calculation.

## Failed drops, zero-dimensional parents and normalization

- **Every actual stage exists.** The anchor \(z\) belongs to its own residue class. Every \(F\in\mathcal K_i\) vanishes at \(z\), so the entire intersection contains \(z\). The covering-patch lemma supplies the next patch. Neither a failed expected dimension drop nor an exceptional alternative stops the construction (M:240–257, 275–279).
- **There is no early-stop zero padding in the manuscript definition.** One records all \(r\) actual evaluation ranks. In fact, for nonnegative \(D_i\), the nonempty anchored evaluation set makes \(\rho_i\ge1\), because the constant polynomial evaluates to \(1\). On a zero-dimensional rational parent containing \(z\), that parent is the singleton \(z\), and the evaluation rank is \(1\), not an artificial padded zero. The broader digit range \([0,M_i]\) is harmless but must not be confused with a truncated process.
- **A normalized basis is not an extra assumption about the kernel.** Equality here is equality of rational polynomial spaces and their common zero sets. RREF in a fixed monomial order can give a canonical rational basis, if wanted. Integer equations used for patches must then follow the fixed bounded-height construction and fixed normalization. Selecting a prime-dependent basis vector or independently rescaling a minor would not be the source's rule.
- **Determinism is existential, not an implemented algorithm.** M:151–158 permits fixed choices among the lists supplied by its lemma. It does not provide effective component decomposition or an executable patch constructor, and none is needed for this set-theoretic equality argument. Equal inputs must nevertheless use exactly the same choices, not just some possibly different valid lists.

## Supported scope and remaining obligations

The full-kernel nesting, equality induction and mixed-radix encoding are complete elementary arguments for the actual manuscript definitions, conditional only on the stated deterministic covering-patch convention. There is no need for a dimension-drop hypothesis, a coefficient bound on initial equations, or independence of the full minor from inserted primes.

Concrete boundaries:

1. Covering-patch existence and uniform height are a separate geometric dependency, assessed in the companion unit; this linear-algebra argument alone does not establish them.
2. Every downstream “same record implies same path” use must concern an insertion/deletion or a comparable inclusion comparison with the other inputs fixed. Unrelated equal-rank paths are not covered.
3. Parent integration checked M:20-24,37-68: degree is the sum over all geometric irreducible components, \(S\) is integral in a fixed weighted box, and the initial degree and dimension are bounded. These match the path hypotheses. The cumulative-products unit checks that common degree allowances precede prime choices, conditional on the separate residue-cut input. No extra initial coefficient bound has been introduced.
4. Native Host-invoked independent review remains required. No finite sample, compiler result or historical acceptance label supplies that review.

This is an assessment of an existing manuscript argument and the old Argus reconstruction, not a novelty result. The old exact certificate provides finite sample support only and was not replayed by this contributor. No external citation was newly checked or imported; novelty is **not established**.
