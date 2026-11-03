# Result 2338

## Necessary conditions for multiplicity five in Pascal's triangle (Erdős Problem #849)

**Status:** independently verified theorem package (Tier-A paper candidate)<br>
**Field:** number theory and Diophantine equations

For $a > 1$, write

$$
P(a) = \left\{(n,k) : 1 \le k \le n/2,\ \binom{n}{k} = a\right\},\qquad m(a) = |P(a)|,
$$

and let $K(a) = \max\{k : (n,k) \in P(a)\}$ denote the largest lower index among the nontrivial representations in the left half of Pascal's triangle. Combining complete classical Diophantine curve classifications (Mordell, Avanesov, Bugeaud--Mignotte--Siksek--Stoll--Tengely) with exact numerator-window and prime-support reductions, Argus proved four global implications:

1. **Lower-index threshold:** $m(a) = 5 \implies K(a) \ge 8$ (complete exclusion of $K(a) \le 7$).
2. **Prime-support threshold:** $m(a) = 5 \implies \omega(a) \ge 7$, where $\omega(a)$ is the number of distinct prime divisors of $a$ (verified across all $4,060$ exact factorizations).
3. **Surviving $K(a)=8$ systems:** at $K(a)=8$, overlap reductions leave only the two lower-index systems $\{3,5,7,8\}$ and $\{5,6,7,8\}$.
4. **Fourteen-prime bound on $\{5,6,7,8\}$:** every solution on the surviving $\{5,6,7,8\}$ branch has a coherent primary-cell allocation with at least 14 occupied cells, forcing $\omega(a) \ge 14$.

## Boundary

These are unconditional global necessary conditions on any hypothetical integer with $m(a)=5$; they do not settle whether $m(a)=5$ has a solution for $K(a)\ge8$.

## Files

| File | Purpose |
|---|---|
| `k7_total_exclusion_synthesis.md` | Complete proof that $m(a)=5 \implies K(a)\ge8$ |
| `k7_total_exclusion_synthesis_certificate.py` | Rerunnable verifier for the $K\le7$ exclusion |
| `lower_index_six.md` | Complete exclusion at lower index $K=6$ |
| `support_capacity_seven.md` | Proof that $m(a)=5 \implies \omega(a)\ge7$ |
| `support_capacity_seven_certificate.py` | Rerunnable verifier for all 4,060 factorizations ($\omega(a)\ge7$) |
| `k8_lower_index_overlap_reduction.md` | Reduction of $K(a)=8$ to $\{3,5,7,8\}$ and $\{5,6,7,8\}$ |
| `k8_5678_full_system_classification.md` | Proof that $\omega(a)\ge14$ on the $\{5,6,7,8\}$ branch |
| `k8_5678_full_system_certificate.py` | Rerunnable verifier for the $\{5,6,7,8\}$ primary-cell classification |
