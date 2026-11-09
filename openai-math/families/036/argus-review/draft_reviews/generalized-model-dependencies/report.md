# Generalized-model dependencies: assessment of the old catalogue

**Verdict:** `unproved_dependency_claims`. Catalogue assessment complete; neither manuscript refutation nor native independent acceptance.

**Source G:** OpenAI manuscript `Minimal-models-and-Mori-fibre-spaces-for-generalized-log-canonical-Q-pairs-September-24-2026`, pinned by authoritative `../9100036/MANUSCRIPTS.json` to revision `4eaee87548250b2682affda7d05d947c05554bae`. Reads used its listed directory; filenames below are relative to `build/sections/`.

## Exact target and version fidelity

`01-introduction.tex:16-50`, `thm:main`, concerns a projective generalized **lc Q-pair** over an **algebraically closed characteristic-zero field**. \(X\) is normal integral, \(B\ge0\) rational, and \(K_X+B+M_X\) is Q-Cartier. The nef datum is a **fixed rational Cartier b-divisor**, determined by a nef divisor on a higher projective birational model; a trace on a later model need not be nef.

The conclusion is normal integral projective \(Y\) and non-extracting \(\phi:X\dashrightarrow Y\), retaining \(B_Y=\phi_*B\) and the **same** nef b-divisor:
\[
A_{X,B+M}(E)\le A_{Y,B_Y+M_Y}(E)
\]
for **every prime over the common function field**, strictly for original contracted primes. Pseudo-effective adjoint gives a nef endpoint; otherwise a connected-fiber projective contraction to a smaller-dimensional normal projective base has \(\rho(Y/T)=1\) and relatively antiample adjoint. There is no dimension ceiling, factoriality, semiampleness, nonvanishing or arbitrary-MMP termination (`01-introduction:44-90`).

| Old claim, all v1 | Main direct dependency | Supported old scope |
|---|---|---|
| `C9000036-GMM` | `thm:main`; `02-global:555-826` | Faithful fixed-data existence/discrepancy catalogue, not a reproduced existence theorem. |
| `C9000036-PHASE` | `02-global:19-46`, `thm:phase`; `07-rounding:254-482` | Correct cyclic-character local input and its chain of estimates, not constructed bounded-discrepancy valuations. |
| `C9000036-GLOBAL-TRANSFER` | `02-global`, `prop:smooth-termination`, `prop:relative-wzd`, `prop:field-descent` | Correct smooth-to-relative-to-generalized transfer route, not verified termination or transfer hypotheses. |

Old `REPORT.md:43-60,61-113` establishes attribution. All assigned ledger versions are 1 without formal statements; graph flags are open. Later historical finite-data/algebraic support proves none of these claims; the wrapper judgement was inconclusive. Stale flags and old opinions are not current acceptance.

## Concrete local and global obligations

**1. PHASE is an actual valuation theorem, with demanding quantifiers.** For a sequence of pointed algebraic **Gorenstein klt** germs of fixed dimension \(n\ge2\), closed fixed points, finite cyclic actions on affine representatives, and semi-invariant nowhere-vanishing canonical generators \(\theta_i\), `02-global:19-46` permits arbitrary chosen \(\gamma_i\in G_i\). After a subsequence it requires **one** integer \(\ell>0\), independent of \(i\), and centered divisorial-scaled valuations \(w'_i\) with a uniform bound \(A_{\theta_i}(w'_i)\le C\), such that
\[
w'_i(h)\equiv\ell\,\operatorname{angle}(\chi_h(\gamma_i))\pmod{\mathbb Z}
\]
for **every nonzero rational semi-invariant** \(h\). The restrictions to invariant fields are integral-valued, not necessarily primitive (`00-conventions:31-42`).

The claim bundles equivariant cone/Gorenstein Rees and degree-product estimates, valuation optimization, logarithmic Cartier selection, rounding, integral jump, lifting/mixing and bounded-fiber inputs (`01-introduction:193-229`). Character weights must lift to actual centered Gauss valuations with bounded discrepancy at dependent rational endpoints; Frobenius algebra does not supply them.

`07-rounding:254-407` fixes all prospective enlargement, ratio, derivative, and cutoff bounds by a finite recursion **before** choosing one common \(S\). `round:segment` must preserve feasibility and the Gauss property through branch endpoints. At `409-482`, `round:all-character-box` counts \(h^jf^\alpha\); same-character cancellation must involve two distinct \(h\)-exponents, yielding `round:torsion`. Only then does
\[
\ell=\operatorname{lcm}(1,\ldots,D_{\rm fin}),\qquad w'=\ell S w
\]
(`round:phase-valuation`, `455`) extend the congruence to all eigenfunctions, then rational functions via an invariant product denominator. The catalogue owes the cone/product/selection input, uniform constants, endpoint feasibility and all-functions passage. Checking a finite tuple is insufficient. Integral jump remains deferred (`477-482`); its machinery is not audited for new flaws.

**2. Smooth termination requires a uniform ideal/countability argument.** `02-global:50-64`, `prop:smooth-termination`, concerns a smooth projective complex starting variety with pseudo-effective \(K_X\) and the specified ample-boundary scaling program. Equations `glob:uniform-squeeze` and `glob:small-increment` (`200-209`) require stabilized, uniformly generated asymptotic multiplier ideals, with a late index independent of the divisorial test.

The countable set of finite limiting discrepancy changes (`211-274`, `glob:unique-limit`) must be established for integral-valued divisorial tests of bounded **original** discrepancy, including the divisoriality-or-triviality of their limiting valuation over a countable field. On cyclic index-one covers, `glob:phase-change` (`326`) then turns arbitrary limiting character angles into these changes. Countability is fixed before the angles are selected; the possible subsequence-dependent positive integer \(\ell\) is handled by a countable union. This is the concrete bridge to `glob:common-index` (`279`), not a consequence of finite-field arithmetic.

Late-flip vanishing requires the pushforward identity and strict `glob:rounding-strict` (`384`). Effective base point freeness fixes dimension-dependent \(N\) before choosing late steps for \(m=R+jNR\); `glob:regularity-vanishing` (`412`) must produce a generated line negative on a contracted curve. No old evidence proves these ideal/vanishing assertions.

**3. Relative weak Zariski decomposition is not automatic.** `prop:relative-wzd` (`02-global:452-554`) treats smooth quasi-projective \(X\), projective over normal quasi-projective \(Z\), with relatively pseudo-effective \(K_X\). A branched double cover with big canonical base and non-uniruled fibers makes the total canonical divisor pseudo-effective (`glob:double-cover`, `496`). The catalogue owes equivariant resolution, averaging (`522`), finite-norm rational Cartier descent and nef/effective descent. The added base divisor disappears only **numerically over \(Z\)**; absolute termination alone supplies none of this.

**4. Generalized and field transfer retain all hypotheses and output conditions.** `02-global:555-681` credits Tsakanikas–Xie: Theorem D/5.2 uses lower-dimensional relative smooth existence with an NQC weak decomposition; induction then enables Theorem B/5.4, and Theorem A/4.2 supplies a terminating scaling choice on the original possibly nonfactorial \(X\). Rational fixed nef data are NQC, but this observation supplies none of the preceding existence hypotheses.

The effective comparison `glob:step-difference` (`607`) and cancellation of the **same** nef divisor on a common resolution give all discrepancy inequalities and strictness for contracted original primes (`625`). The Mori rank-one argument (`640-677`) separately invokes the relative good-model result for an added effective ample boundary; rank one is not inferred from factoriality. `prop:field-descent` (`684-826`) must descend the actual finite diagram, including contractions, Cartier divisorial sheaves and the finitely generated adjoint algebra `glob:adjoint-algebra` (`736`), preserving connectedness, relative rank, signs, and every prime-divisor comparison over the stated field. The old catalogue contains no verification of these transfer constructions.

## Classification and read coverage

These are manuscript-attributed statements and author-credited transfer, not Argus novelty, a reproduced MMP, failed attack or factoriality/universal-termination strengthening. Ordinary endpoint semiampleness separately cites unverified companion log abundance (`01-introduction:75-90`), not generalized abundance.

SHA-256 matched every read source to existing manifest hashes: complete introduction/global deduction, conventions `1-119`, rounding `254-482`. `verdict.json` records coverage. Deeper cone-through-incidence proofs, unlisted companions, excluded old geometry and projective `frobenius.tex` were not inspected. Non-reproduction does not refute the paper.
