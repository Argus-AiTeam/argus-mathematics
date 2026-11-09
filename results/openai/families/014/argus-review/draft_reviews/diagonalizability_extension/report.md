# Failed diagonalizability extension

**Assessment: the proposed nonregular extension is false; the manuscript's
regular-case assertion is not refuted.** This unit is the retired route
`R_ABG_REUSE_DIAGONALIZABILITY`, not another version of `C_ABG`.
The explicit witness already appears in old `theorem.md` Section 7,
the verifier fixtures, and the archived Jacobian decomposition.

## Exact implication under examination

The attempted route would reuse diagonalizability of a Frobenius matrix
from the regular-nilpotent setting when only
\(\operatorname{Ad}(A)N=qN\) and nilpotence of \(N\) are assumed.
Here \(q>1\) is a characteristic-zero scalar (in the application a
finite-field cardinality), and \(N\) is allowed to be nonregular.
The conclusion that \(A\) must then be semisimple is false.

The reference source, at the manifest revision,
`Frobenius-Structures.../build/sections/parameters.tex:249-299`,
`lem:compact-conjugator`, explicitly assumes **regular nilpotence**.
Its proof uses the successive one-dimensional regular Jordan quotients
and their distinct eigenvalues. Removing that hypothesis changes the
assertion being tested.

## Exact counterexample and its scope

Let
\[
 U=\begin{pmatrix}1&1\\0&1\end{pmatrix},\qquad
 A=\operatorname{diag}(U,qU),\qquad
 N=\begin{pmatrix}0&0\\I_2&0\end{pmatrix}.
\]
Block multiplication gives \(AN=qNA\). Also \(N^2=0\) and
\(\operatorname{rank}N=2\), so its Jordan type is \((2,2)\), not the
regular type \((4)\). The minimal polynomial of \(A\) is
\((t-1)^2(t-q)^2\); its repeated factors show nonsemisimplicity.
Multiplying a matrix lift by a scalar does not remove its nontrivial
Jordan blocks. Thus the same obstruction is present projectively.

For the archived rational fixture \(q=11\), \(\ell=5\), the matrix
lies in \(\mathrm{GL}_4(\mathbb Z_5)\); its powers have compact closure.
Compactness therefore does not rescue the proposed diagonalizability
implication. This is a local algebraic counterexample to that implication,
not a constructed dense global arithmetic parameter violating the gluing
theorem.

The cocharacter \(\operatorname{diag}(I_2,zI_2)\) nevertheless commutes
with this \(A\) and scales \(N\) by \(z\). Hence the witness does **not**
disprove the desired conjugator or the primary-space grading. The
generalized-primary-space route in the old draft avoids precisely the
unnecessary diagonalization.

## Replay and route disposition

The [non-writing replay](../computation/replay.json) passed. It independently
recomputed the archived `matrix.primary_decomposition.compute` result:
primary polynomials \((t-11)^2,(t-1)^2\), and minimal polynomial
\[
 t^4-24t^3+166t^2-264t+121 .
\]
The exact archived payload, typed output, server/protocol metadata,
adapter success, null error, and non-timeout status remain in their
dedicated read-only JSON inputs, linked from the replay receipt.
No live Jacobian result was substituted.

The retired route and its complete reason are inherited in the current
ledger. Its death is a mathematical obstruction to the proposed
strengthening route, not merely an unfinished computation. It must not be
reopened as an attack on the regular source assertion. There is no
originality claim or Lean proof here. Native independent review of this
assessment remains pending.
