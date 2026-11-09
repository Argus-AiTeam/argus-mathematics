# Numerical-dimension-one dependencies: assessment of the old catalogue

**Verdict:** `unproved_dependency_claims`. Catalogue assessment complete; neither theorem proof nor native independent acceptance.

**Source N:** OpenAI manuscript `Minimal-models-in-numerical-dimension-one-September-24-2026`, pinned by authoritative `../9100036/MANUSCRIPTS.json` to revision `4eaee87548250b2682affda7d05d947c05554bae`. Four complete relevant sections were read from its listed directory; filenames below are relative to `build/sections/`.

## Exact theorem, invariant, and old evidence

`introduction.tex:24-69`, `main:sigma` and `main:theorem`, assumes **smooth connected complex projective** \(X\), dimension \(n\ge3\), pseudo-effective \(K_X\), and **section-growth** \(\kappa_\sigma(K_X)=1\). An ample Cartier twist \(A\) is fixed **before** the limsup of \(h^0(X,mK_X+A)/m^k\); existence determines the maximum \(k\). Positive quadratic limsup is excluded for **every fixed ample twist**, even along fixed integer multiples. This gives no \(O(m)\) upper bound, pre-model nef intersection convention, or un-twisted nonvanishing.

The conclusion is a finite sequence of **K-negative divisorial contractions and flips** to a normal projective **Q-factorial terminal** \(Y\) with nef \(K_Y\); the inverse extracts no prime divisors. On a common smooth projective resolution with compatible canonical divisors,
\[
p^*K_X=q^*K_Y+E,
\]
where \(E\ge0\) is Q-divisorial, **q-exceptional**, and contains the strict transform of **every original contracted prime** in its support. The good-model corollary (`introduction:84-97`) separately uses companion log abundance Theorem 1.1. It is not included in the main existence theorem without that dependency.

| Old claim, both v1 | Direct source support | Old evidence actually available |
|---|---|---|
| `C9000036-ND1` | `main:theorem`, `main:comparison`; `mmp:approximation`; `conclusion.tex:1-62` | Faithful existence, singularity, non-extraction and exceptional-comparison catalogue; no theorem-level reproduction. |
| `C9000036-ND1-SURFACES` | `mmp:stabilization`; `num:growth`, `num:jets`, `num:fixed-square`, `num:nef` | Correct identification of stabilization, fixed-twist extension, growth exclusion and negative-curve obligations; no independent proof of them. |

Old `REPORT.md:43-60,61-113` preserves the caveats and attribution. Both ledger versions are 1 without formal statements; graph flags are open. Later historical finite-data/algebraic support does not prove these claims, and the wrapper judgement was inconclusive. Stale flags and old opinions are not current acceptance.

## Concrete mathematical obligations

**1. Codimension-two stabilization does not terminate an infinite concatenation.** `mmp.tex:115-230`, `mmp:stabilization`, begins with K-negative programs from a smooth variety. Finitely many divisorial contractions follow from Picard-number drops. For a codimension-two **flipped** component, blowing up its generic smooth point gives log discrepancy two; strict negativity gives
\[
a(F,X)\le a(F,U_i)<2=a(F,U_{i+1})
\]
(`mmp:witness`, `157`). Integrality on the smooth original \(X\) forces this witness to be an original contracted prime, of which only finitely many can be used.

For \(d=n-2\), finite-dimensional \(\mathcal A_d(U)\subset H_{2n-4}(U,\mathbb R)\), Borel–Moore localization, identical common-open images and target complement of dimension at most \(d-1\) yield `mmp:rank` (`216`). A codimension-two **flipping** component has nonzero ample-tested class and forces strict decrease. The catalogue owes strict discrepancy support (`mmp:strict`, `48-113`) and this homological decrease, not an imported four-dimensional termination theorem.

`mmp:approximation` (`8-40`, proof `231-365`) needs finite positive-boundary stages with **big**, not necessarily ample, transforms and genuine K-steps on both flip sides. It chooses a **finite prefix**, not a limit variety, then transports sections across common opens. Bad sets \(Z_j\) have codimension at least three; Cartier multiples may depend on \(j\). The effective exceptional comparison with strict support requires finite-chain discrepancies, not numerical equivalence. Old Frobenius evidence establishes neither prefix construction nor concatenation termination.

**2. Surface extension keeps one fixed twist while perturbations vary.** `numerics.tex:34-160`, `num:growth`, chooses a single smooth complete-intersection surface \(S\) avoiding **all** countably many \(Z_j\) and the singular locus. Limits of semiample \(M_j|_S\) make \(L|_S\) nef. On a fixed resolution it chooses
\[
P=K_{\widehat Y}+(n-2)\pi^*H+A_0
\]
(`num:fixed-twist`, `78`) **before** \(m\) varies. This fixed Cartier \(P\) is the extension twist; the final ample twist on \(X\) is constructed later.

For each allowed \(m\), one must choose \(j(m)\) with \(mt_j<\eta\), then a generated multiple \(k>m\) and a general divisor defining a multiplier ideal trivial near \(S\). Nadel vanishing and the globally exact Koszul complex give the restriction surjection `num:restriction-surjective` (`48`). Surface Riemann–Roch yields
\[
h^0(\widehat Y,m\pi^*L+P)\ge \tfrac12m^2 L^2H^{n-2}+O(m)
\]
(`num:quadratic-growth`, `54`) along multiples of **one fixed** Cartier index. Its \(O(m)\) is a lower-estimate error, not a growth-hypothesis upper bound. Old evidence supplies no multiplier ideals, surjection or countable surface choice.

**3. Quadratic growth must reach the original invariant.** `conclusion.tex:14-54`, `main:quadratic`, uses the effective canonical comparison to inject sections into \(H^0(X,mK_X+P_X)\), with **fixed Cartier** \(P_X=u_*r^*P\) since \(X\) is smooth. It chooses **one ample** \(A_X\) with a section of \(A_X-P_X\). Positive square gives \(cm^2\) sections along fixed index multiples, contradicting `main:sigma`. The catalogue owes these injections and fixed-ample choice; a varying twist or invented linear upper bound is insufficient.

**4. The negative-curve surface must detect curves missed by \(S\), including singular ones.** `num:nef` (`numerics:311-455`) assumes \(L^2H^{n-2}=0\) and tests a hypothetical curve \(C_0\) with \(L\cdot C_0<0\). A second complete-intersection **cycle** through a carefully chosen point of \(C_0\) has integral, possibly nonnormal surface components. Their nonnegative \(M_j\)-squares sum with multiplicities to zero in the limit (`num:special-surface-limit`, `368`).

The construction fixes a resolution, a curve \(\Gamma\) above \(C_0\) through a chosen ambient point, its normalization, a resolved surface, and one exceptional blowup curve \(e\), **before** varying \(j\). `num:jets` (`172-239`) uses the **ambient cotangent bundle** and principal parts, valid even for singular \(\Gamma\); a fixed negative-degree margin gives `num:uniform-point-order` (`425`), \(\operatorname{ord}_z(s)\ge ck_j\). Restriction must retain this order at the fixed surface point, forcing coefficient at least \(ck_j\) along \(e\).

`num:fixed-square` (`243-301`) then requires the fixed part to be exceptional and orthogonal to the pulled-back divisor. Hodge index on the **fixed** smooth surface gives \(F_j^2\le-\epsilon k_j^2\) (`286`), while the residual moving square is nonnegative, forcing \(M_j^2[T]\ge\epsilon\). This contradicts the special-surface limit. The catalogue owes the ambient-to-surface order transfer and the uniform exceptional-curve estimate, not just the classical Hodge index theorem. No old algebraic certificate constructs these surfaces, curves, or fixed systems.

## Attribution, classification, and verification

These are manuscript-attributed results, not Argus novelty, a reproduction or failed attack. Removing the twist, good-model semiampleness without companion abundance, or universal concatenation termination are unsupported strengthenings. Companion abundance remains an unverified citation.

The four complete introduction, mmp, numerics and conclusion sections matched existing manifest SHA-256 hashes; `verdict.json` records locators and coverage. No unrelated Frobenius replay, excluded geometry or unlisted companion was inspected. This does not declare the paper false or blanket-correct.
