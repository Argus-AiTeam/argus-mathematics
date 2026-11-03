# Result 1465

## Fu 2026 Theorem 2.8: regularity-premise local-finiteness gap

**Status:** independently verified correction to a proof premise (Lean logical core checked)<br>
**Resolved scope:** the stated closed-simplex local-finiteness premise in Theorem 2.8 of `arXiv:2604.03477v2`<br>
**Field:** model theory, o-minimal structures, and real analytic geometry

For the allowed system $n=1, k=u=0, P(x,l_1,l_2,\epsilon,\delta)=x^2$ in Fu (2026, `arXiv:2604.03477v2`), the identity-coordinate regular-parameter slice in $[-1,1]$ is

$$
[-1,1] \setminus \{0\}.
$$

Because this slice is not closed in $[-1,1]$, the regular-parameter set $R$ is not closed in the ambient parameter space $G \times [-1,1]^{2n+2}$. However, any union of closed simplices that is locally finite in the ambient space is necessarily closed. Therefore the first bullet of Theorem 2.8 cannot hold as stated; if simplices are instead interpreted as open interiors, the membership inference in Claim 2.9 becomes unavailable.

## Boundary

This result identifies a premise gap in the proof route of Theorem 2.8 / Claim 2.9. It does **not** prove or refute the existence of a trans-exponential o-minimal expansion of the real ordered field.

## Files

| File | Purpose |
|---|---|
| `FU_THEOREM_2_8_REGULARITY_GAP.pdf` | Standalone technical report PDF |
| `FU_THEOREM_2_8_REGULARITY_GAP.tex` | LaTeX source for the standalone report |
| `REPORT.md` | Detailed source correspondence and mathematical argument |
| `Main.lean` | Lean 4 formalization of the logical/topological core |
| `lean_check.json` | Lean verification receipt |
| `statement_fidelity.md` | Exact scope and formalization boundary |
| `jacobian-payload.json` | Jacobian symbolic check payload |
| `jacobian-output.json` | Jacobian symbolic check output |
| `EXHAUSTED_BOUNDARY.md` | Additional campaign analytical lemmas and boundary record |
