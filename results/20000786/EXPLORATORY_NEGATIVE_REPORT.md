# Exploratory negative report: supersingular-reduction counterexample campaign

## Scope and outcome

The target `C_TARGET` asks for an explicitly specified number field \(K\), a
positive-dimensional explicitly specified abelian variety \(A/K\), and an
explicit finite set \(S\) such that every good reduction outside \(S\) is not
supersingular. This report collects only route boundaries that were
independently accepted in the campaign's Reviewer entries in
`activity.jsonl`. It does not promote engineering observations, bounded
searches, or manager summaries into mathematical conclusions.

No such \((K,A,S)\) witness was produced. The global claim `C_TARGET` remains open.
The explicit factorized candidate

\[
C:\ y^2=(x-1)(x^5+2),\qquad A=\operatorname{Jac}(C)/\mathbf Q,
\]

also remains open: the model is smooth outside
\(S_0=\{2,3,5\}\), but no proof shows that its Hasse--Witt trace and
determinant are never simultaneously zero at every prime \(p\geq7\).
Accordingly, both `C_FACTORIZED_HW_JOINT_NONVANISHING` and
`C_FACTORIZED_HW_OBLIGATION` remain open.

This is a negative report about the enumerated mechanisms, not a
counterexample and not a global impossibility theorem. It proves neither
universal infinitude of supersingular reductions nor impossibility of a
counterexample. It also makes no claim about the weaker nonordinary clause of
AimPL Problem 1.3.

## Independently reviewed route boundaries

| Route | Exact proved boundary | Evidence reference | Limitation |
|---|---|---|---|
| `R_PRODUCT` | A product is supersingular exactly when all factors are supersingular. CM factors have common supersingular places forced by central complex conjugation, while simultaneous complex conjugation prevents any fixed torsion level from making the elliptic trace-zero conditions incompatible. | `research/SCOPE.md`; independent review at `2026-08-27T18:02:43.093Z` | The plausible construction from several non-CM factors remains heuristic: no theorem proves finite simultaneous supersingular primes for an explicit tuple. This does not rule out all products. |
| `R_CM` | Blake's CM slope formula and Chebotarev imply that every positive-dimensional CM abelian variety has infinitely many good supersingular places arising from central-complex-conjugation Frobenius. | `research/SCOPE.md`; independent review at `2026-08-27T18:02:43.093Z` | This retires the CM/Newton-slope mechanism only. It gives no impossibility result for non-CM endomorphism-rich varieties. |
| `R_QM_SPECIALIZATION` | For every indefinite quaternion order \(\mathcal O\) and every prime \(p\), \(\mathcal O\) embeds into \(\operatorname{End}(E^2)\) for a supersingular elliptic curve \(E/\overline{\mathbf F}_p\), including at discriminant primes. Thus abstract unpolarized order nonembedding cannot obstruct supersingular reduction. | `research/QUATERNION_OBSTRUCTION.md`; independent review at `2026-08-27T19:11:40.166Z` | Existence of an embedding into some superspecial surface says nothing about whether the fixed characteristic-zero QM surface has supersingular reduction. Polarization and other PEL structures are outside this boundary. |
| `R_SPARSE_UNIQUE_MONOMIAL` | Among all 45 squarefree-capable degree-five or degree-six supports with at most four terms, none has an eventual coefficient-uniform single-monomial Hasse--Witt trace or determinant certificate. Four binomial supports instead have infinite good-prime progressions with zero Hasse--Witt matrix; every larger support has multiple formal trace and determinant monomials on infinitely many primes. | `research/SPARSE_HASSE_WITT_BOUNDARY.md`; independent review at `2026-08-27T20:06:34.360Z` | The exhaustion is only of the support-uniform single-monomial template. It does not exclude fixed-coefficient cancellation identities, joint trace--determinant arguments, or other arithmetic mechanisms. |
| `R_FACTORIZED_HASSE_WITT` **(open)** | For \(C:y^2=(x-1)(x^5+2)\), the discriminant is \(2^4 3^2 5^5\); exact five-section formulas cover every prime class modulo \(10\), reciprocity reduces the matrix to two terminating sums, and no class is structurally triangular. Simultaneous trace--determinant vanishing is exactly square-zero of the Cartier--Manin matrix and hence \(p\)-rank zero. | `research/FACTORIZED_HASSE_WITT_BOUNDARY.md`; independent reviews at `2026-08-28T02:26:52.568Z`, `2026-08-28T03:45:04.823Z`, and `2026-08-28T05:41:48.743Z` | No unbounded identity proves joint nonvanishing for all \(p\geq7\), and no infinite family of joint zeros was proved. The recorded finite prime and gcd searches are diagnostic only. The candidate is neither certified nor refuted. |
| `R_FACTORIZED_FINITE_MONODROMY` | The reduced fourth-order equation has noninterlacing \(\Phi_5/\Phi_{10}\) parameters, so its characteristic-zero monodromy is infinite; moreover \(t=2\) maps to an ordinary point where the trace and Wronskian conditions are locally consistent first-jet constraints. | `research/FACTORIZED_HASSE_WITT_BOUNDARY.md`; independent review at `2026-08-28T02:26:52.568Z` | This rules out only an algebraic finite-monodromy connection shortcut. It does not rule out a different identity special to \(t=2\). |
| `R_FACTORIZED_GENERIC_FROBENIUS_PROPAGATION` | The universal identity \(G(G^{(p-1)/2})^2=G(x^p)\) is compatible with a nonzero square-zero Cartier--Manin matrix: \(y^2=x^6+x\) over \(\mathbf F_7\) has matrix \(\left(\begin{smallmatrix}0&0\\3&0\end{smallmatrix}\right)\). | `research/FACTORIZED_HASSE_WITT_BOUNDARY.md`; independent review at `2026-08-28T03:45:04.823Z` | Only propagation from the universal identity alone is retired. A candidate-specific identity for \((1+x)(1-2x^5)\) remains possible. |
| `R_FACTORIZED_PARAMETER_UNIFORM_BEZOUT` | At \(n=5\), the primitive parameter polynomials are \((t-1)(t^2-t+1)\) and \(t^2+10t+1\), and modulo \(11>5\) they share \(t^2-t+1\). Hence no parameter-uniform Bezout identity can have the proposed \(n\)-smooth nonzero right-hand side. | `research/T_UNIFORM_BEZOUT_OBSTRUCTION.md` and the incorporated calculation in `research/FACTORIZED_HASSE_WITT_BOUNDARY.md`; independent review at `2026-08-28T05:41:48.743Z` | At \(t=2\) the two primitive values are \(3\) and \(25\), so this obstruction disappears. The pointwise \(t=2\) claim remains open. |
| `R_FACTORIZED_RESIDUAL_JACOBIAN_REALIZABILITY` | Every residual isogeny class allowed by equation (13), namely those with Weil polynomial \((X^2-p)^2\), \((X^2+p)^2\), or \(X^4+p^2\), contains a genus-two Jacobian for \(p>3\). | `research/RESIDUAL_WEIL_ROUTE_BOUNDARY.md`; independent review at `2026-08-28T06:19:33.565Z` | Abstract principal-polarization or Jacobian realizability cannot eliminate these shapes. This does not show that the fixed candidate realizes any shape. |
| `R_FACTORIZED_HYPERGEOMETRIC_SYMMETRIC_CUBE` | The exact \(\Phi_5/\Phi_{10}\) local monodromy is a nonidentity rank-one unipotent with minimal polynomial \((X-1)^2\), whereas a nontrivial two-dimensional unipotent has symmetric-cube minimal polynomial \((X-1)^4\). | `research/RESIDUAL_WEIL_ROUTE_BOUNDARY.md`; independent review at `2026-08-28T06:19:33.565Z` | This excludes the proposed second-order symmetric-cube reduction only, not every hypergeometric or candidate-specific identity. |
| `R_FACTORIZED_AUTOMATIC_FOUR_TORSION` | At \(p=37\), the candidate has two rational branch points, but \(v_2(\#J(\mathbf F_{37^2}))=2\) and the rational 2-torsion already has order \(4\); consequently \(J(\mathbf F_{37^2})\) has no point of order \(4\). | `research/RESIDUAL_WEIL_ROUTE_BOUNDARY.md`; independent review at `2026-08-28T06:19:33.565Z` | This exact example refutes the automatic implication from a rational branch pair to four-torsion. It does not itself decide any residual shape at all primes. |
| `R_FACTORIZED_DIRECT_T2_GOSPER_BEZOUT` | Exact integer syzygies and modular rank certificates in all four prime classes show that the declared \(t=2\) bivariate Gosper--Bezout ansatz has no nonzero trace or determinant multiplier when the summation-index degree is at most \(4\), the class-parameter degree is at most \(8\), and the reduced certificate total degree is at most \(8\). | `research/FACTORIZED_HASSE_WITT_BOUNDARY.md`; independent review at `2026-08-28T07:09:54.108Z` | Higher-degree certificates, cross-direction rational poles, and non-Gosper identities remain open. Failure in this search box is not an all-primes nonvanishing theorem. |
| `R_TRIANGULAR_HW` | The reviewed 45-support census has exactly 36 structurally dense supports and nine triangular or anti-triangular survivors. Four survivors are the binomial zero-progression cases; every one of the other five has explicit complementary elliptic quotients, so its Jacobian is geometrically an elliptic product. | `research/TRIANGULAR_HASSE_WITT_BOUNDARY.md`; independent review at `2026-08-28T07:55:01.438Z` | This exhausts only the reviewed sparse structural class. It does not settle fixed-coefficient cancellation outside that class or exclude nonsparse constructions. |
| `R_POLARIZED_PEL` | For the explicit discriminant-\(6\) \(\mathcal O_6\) datum, a principally polarized superspecial surface with the same Rosati involution and determinant condition exists in every characteristic. At every \(p\nmid6N\), every good full-level-\(N\) component contains such a point. | `research/POLARIZED_PEL_OBSTRUCTION.md`; independent review at `2026-08-28T08:42:53.723Z` | The matching superspecial object is another point of the moduli component, not the reduction of the fixed Hashimoto--Murabayashi Jacobian. Local PEL realizability supplies no converse specialization statement. |
| `R_CHEN_QM_APPLICATION` | For the Hashimoto--Murabayashi Example 1.6 point, \(j_6=-2025/1024\), its field of moduli is \(\mathbf Q\), and \(v_2(j_6)=-10\), \(v_3(j_6)=4\). These valuations exclude Chen Theorem 1.1, and every complete alternative in Theorem 1.2 has an exact failed hypothesis. | `research/CHEN_QM_CANDIDATE_AUDIT.md`; independent review at `2026-08-28T09:33:15.936Z` | Nonapplicability of Chen's sufficient criteria gives no conclusion about this Jacobian's superspecial primes. `C_HM_QM_SUPERSPECIAL_INFINITY` remains open. |

## Exact remaining frontier

The accumulated evidence exhausts only the mechanisms in the table. In
particular:

1. `C_TARGET` is open, and no counterexample witness or global certificate
   exists in the campaign artifacts.
2. The factorized candidate remains open at the exact all-primes statement
   that its Hasse--Witt trace and determinant are not both zero for every
   \(p\geq7\).
3. The Hashimoto--Murabayashi candidate remains unresolved after the Chen
   applicability failure; the audit proves neither finiteness nor infinitude
   of its superspecial reductions.
4. A bounded search failure, a necessary-condition filter, and the
   nonapplicability of a sufficient theorem are not negative witnesses for
   `C_TARGET`.

The justified conclusion is therefore an exploratory exhausted boundary for
the enumerated routes, with the global counterexample problem still open.
