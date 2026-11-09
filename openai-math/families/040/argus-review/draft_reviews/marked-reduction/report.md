# marked-reduction

**Assessment: supported as an arbitrary-length prose proof, conditional on
the stated geometric inputs.** Finite replay is a supplement, not its proof.

## Exact claim and hypotheses

`C40_REDUCTION`, versions 1-3:

> Lemma rel:marked-reduction holds for arbitrary nonnegative point lengths
> with both output factors retained, including derived duals and
> nontransverse graph terms.

OpenAI's September 24, 2026 `relation.tex`, `rel:marked-reduction`, is the
source, at manifest revision `4eaee87548250b2682affda7d05d947c05554bae`.
Old `REPORT.md`, Sections 3-6, supplies the assessed Argus derivation.

Let \(X\) be a smooth connected projective complex surface,
\(n_1,n_2\geq0\), and \(\ell\geq2\). The input is a **finite** polynomial in
Chern characters of universal point ideals and their derived duals, line
and tangent classes from surface slots, and equality diagonals on
\(X^{[n_1]}\times X^{[n_2]}\times X^\ell\). Two specified factors are kept
as outputs. Coefficients are rational. Neither \(\chi(\mathcal O_X)=1\),
\(q=0\), nor effectivity of the lines is needed for this lemma.

## Why the induction actually closes

For the first positive length \(r\) in a fixed order, projection formula
and \(\psi_*[N_r]=r[X^{[r]}]\) replace the pushforward by \(1/r\) times its
pullback to the consecutive nested scheme. Both outputs remain untouched.

Replace each pulled ideal by the universal ideal sequence in perfect
K-theory. Its extra term is the graph of a new residual surface coordinate,
with the quotient-line twist. The graph is regular of codimension two,
with normal bundle \(\rho^*T_X\). Its two equations remain a regular
sequence in the diagonal pullback square, even when \(\rho\) is not flat.
Thus the graph class is the pullback of the relevant equality diagonal;
there is no assumption that an incidence collision is transverse.

GRR expresses its Chern character as the equality diagonal times
\(e^\zeta\rho^*\operatorname{td}(T_X)^{-1}\). Derived duals change the
degree-\(k\) character by \((-1)^k\), without adding a new type of class.
For this finite input the result is a finite polynomial in \(\zeta\),
with coefficients pulled back from the smaller Hilbert product and its
new residual slot.

The signed all-degree pushdown in `nested-pushdown` replaces every
\(\zeta^k\) by \(c_k(-\mathcal I_{r-1}^\vee)\), a rational polynomial in
the smaller ideal's Chern characters. This is exactly the same allowed
input class with one smaller Hilbert length. The integer measure
\(n_1+n_2\) decreases by one, and rational Chow permits division by \(r\).
After precisely \(n_1+n_2\) steps the ideals are structure sheaves and
only decorated equality diagonals on surface powers remain.

All equalities hold on the whole smooth spaces. The proof does not show
an identity only on a distinct-point open set and extend it across an
uncontrolled boundary. Only the generic-degree calculation uses that
open set, to determine the fundamental-class pushforward.

The old report also states the variant with any fixed finite number of
outputs. The same induction never touches any designated output, so this
is a supported consequence of this argument, not an additional original
result or a separately tested theorem.

## Version and evidence reconciliation

Version 2 recorded generic `A_CHOW_CALCULUS`; version 3 retired that
assumption **by relocating it to `C40_CALCULUS`**, explicitly not by
removing it from the proof. `R40_REDUCTION_INPUTS` records the nested and
calculus dependencies. The old Engineer/Reviewer supports judgements bind
the unchanged statement hash across versions; they are not three reviews
of three different theorems.

The verifier's `pull_atom` and `lower_length` implement these rules in
specialized finite inputs and assert strict length decrease. The complete
nine-case replay succeeded. No Lean statement exists in the listed draft,
and no kernel compiler has checked this Chow induction. Its assessment
rests on the mathematical induction and the disclosed geometric inputs,
not extrapolation from lengths at most four.
