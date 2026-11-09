# Result 20001602

## Commensurated subgroups of branch groups: the missing just-infinite hypothesis and Hanoi group counterexample

**Status:** independently verified counterexample to the literal unrestricted statement<br>
**Field:** group theory and branch groups

The literal problem statement asks to prove that every commensurated subgroup $H \le G$ of a finitely generated branch group $G$ is either finite or of finite index, omitting the *just-infinite* hypothesis present in Wesolek (`arXiv:1602.00213v2`, Theorem 1.1).

Take $G = H^{(3)}$ to be the 3-peg Hanoi towers group acting on the ternary rooted tree (Bartholdi--Siegenthaler--Zalesskii, `arXiv:0902.3220v1`), and take $H = G''$ to be its second derived subgroup:

- $G$ is a finitely generated, faithful, level-transitive branch group;
- $H = G''$ is normal in $G$, so $g^{-1}Hg \cap H = H$ has index $1$ in $H$ for every $g \in G$ (hence $H$ is commensurated);
- $H = G''$ is infinite (certified by disjoint rigid stabilizer embeddings);
- $[G : G''] = \infty$ because $G'/G'' \cong \mathbb Z^3 \times C_3$ (certified by an exact integer Smith normal form transformation with diagonal $(1,3,0,0,0)$).

## Boundary

This refutes the literal statement without the just-infinite hypothesis. It does not contradict Wesolek's theorem for finitely generated *just-infinite* branch groups.

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_20001602_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_20001602_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `counterexample.md` | Complete proof for $(G, G'')$, rigid-copy infinitude, and quotient infinite index |
| `reviewer-exact-replay.json` | Independent Reviewer exact tree-permutation and relation-lattice replay |
| `reviewer-smith-result.json` | Unimodular Smith normal form certificate (`D = U R V` with diagonal `(1,3,0,0,0)`) |
| `verification-summary.json` | Structured verification summary |
