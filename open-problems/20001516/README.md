# Result 20001516

## A CAT(0) free-by-cyclic group that is not ordinary RFRS (AIM Problem 5.3)

**Status:** independently verified literature counterexample certificate<br>
**Field:** geometric group theory and low-dimensional topology

For the automorphism $\phi \in \mathrm{Aut}(F(a,b))$ defined by $\phi(a)=ab$ and $\phi(b)=ab^2$ (with explicit two-sided inverse $\phi^{-1}(a)=a^{-1}b^2a^{-1}b^{-1}a$, $\phi^{-1}(b)=b^{-1}ab$), the mapping torus

$$
G = F(a,b) \rtimes_\phi \mathbb Z
$$

acts properly and cocompactly on a $\mathrm{CAT}(0)$ square complex by Button--Kropholler Theorem 2.1, yet is not ordinary RFRS (Wu--Ye Example 7.2): the induced abelianization matrix $M = \begin{pmatrix}1 & 1\\ 1 & 2\end{pmatrix}$ satisfies $\det(M^n - I) = 2 - \mathrm{tr}(M^n) < 0$ for every $n \ge 1$, which forces every admissible RFRS filtration starting at $G$ to retain the entire nonabelian free kernel $F(a,b)$.

## Boundary

This refutes only the implication $\mathrm{CAT}(0) \implies \text{ordinary RFRS}$ without passing to a finite-index subgroup. It does **not** refute $\mathrm{CAT}(0) \implies \text{virtually RFRS}$ ($G$ is virtually RFRS).

## Files

| File | Purpose |
|---|---|
| `ARGUS_RESULT_20001516_TECHNICAL_REPORT.pdf` | Standalone technical report PDF |
| `ARGUS_RESULT_20001516_TECHNICAL_REPORT.tex` | LaTeX source for the technical report |
| `certificate.md` | Complete proof of the automorphism inverse, CAT(0) instantiation, and universal RFRS filtration obstruction |
| `certificate.py` | Standalone exact verifier |
| `certificate-output.json` | Recorded verification output |
| `jacobian-payload.json` | Jacobian characteristic-polynomial payload |
| `jacobian-result.json` | Jacobian typed output (`[1, -3, 1]`) |
| `verification-summary.json` | Structured verification summary |
