# Kähler dependencies: assessment of the old catalogue

**Verdict:** `unproved_dependency_claims`. Catalogue assessment complete; manuscript proof and native independent acceptance remain unestablished.

**Source K:** OpenAI manuscript `Numerical-semiampleness-of-nef-adjoint-classes-on-compact-Kahler-manifolds-October-6-2026`, pinned by authoritative `../9100036/MANUSCRIPTS.json` to revision `4eaee87548250b2682affda7d05d947c05554bae`. Reads used its listed directory; filenames below are relative to `build/sections/`.

## Statement fidelity and support

`01-introduction.tex:19-37`, `thm:main`, assumes a **smooth connected compact Kähler** manifold \(X\), an effective **rational SNC** boundary \(B\) with coefficients strictly below one, and \(M\in\operatorname{Pic}(X)\otimes\mathbb Q\), nef on the **original manifold**. Pseudo-effectivity of \(K_X+B\) and nefness of \(K_X+B+M\) imply a semiample rational holomorphic line \(L\) with
\[
c_1(L)=c_1(K_X+B+M)\quad\text{in }H^{1,1}_{BC}(X,\mathbb R).
\]
There is no dimension bound. Nonprojective Bott–Chern equality is not merely curve-degree equivalence. Flat replacement is allowed; original-line semiampleness fails in the introduction's nontorsion elliptic example. The ledger's abbreviated “smooth compact” must retain connectedness.

| Old claim, both v1 | Direct dependency locators | Supported catalogue scope |
|---|---|---|
| `C9000036-KAHLER` | `01-introduction`, `thm:main`; `07-completion:288-305` | Correct real Bott–Chern representative conclusion, not original-line semiampleness or an Argus proof. |
| `C9000036-ANALYTIC` | `02-preliminaries`, `pre:ordinary`; `03-descent`, `desc:nef`; `05-zero`, `zero:line-nonvanishing`; `06-cycles`, `cycle:nef-summand`; `04-adjoint`, `adj:base` | Faithful identification of analytic construction obligations, not independent verification of them. |

The old `REPORT.md:43-60,61-113`, graph and v1 ledger supply attribution, not formal statements or supporting judgements for these claims. Later historical algebraic/finite-data support does not propagate here; the wrapper judgement was inconclusive. Stale flags are not the full history or current acceptance.

## Remaining obligations, with decisive source interfaces

**1. Two different substantial inputs must survive.** `02-preliminaries.tex:233-275`, `pre:projective`, attributes rational numerical semiampleness of the birational positive part to **Proposition 8.1** of the projective manuscript. That manuscript's `build/sections/positive.tex:7-24`, `prop:positive-part`, has precisely that positive-part scope. K's stronger presentation
\[
u^*(K_S+\Delta+M)\sim_{\mathbb Q}v^*H_m+E,\qquad E=N(u^*(K_S+\Delta+M))
\]
additionally uses a terminating fixed-nef-data generalized program; Proposition 8.1 alone does not produce this actual rational-line identity.

`pre:ordinary` (`02-preliminaries:165-196`) is another input: **actual** \(\mu^*(K_X+B)\sim_{\mathbb Q}P+R\), with \(P\) semiample and \(R\) rational, in every finite dimension, even allowing ordinary SNC coefficients one. It is attributed to companion Kähler log abundance Theorem 2.13 under the logarithmic Iitaka hypothesis supplied by the period/log-Iitaka companion Corollary 6.2. Constructing that decomposition, its detected-ray contractions, or that Iitaka inequality is not accomplished by the old Frobenius certificate. No unlisted companion was opened or accepted.

**2. Algebraic dimension zero requires the analytic two-diagonal construction.** `05-zero.tex:12-20` requires \(a(T)=0\Rightarrow c_1(M)=0\), not just numerical nonvanishing. Ordinary decomposition and Calabi–Yau-type splitting reduce to a simple generically symplectic manifold (`78-160`). `zero:no-correspondences` (`167-236`) must exclude sweeping finite correspondences by producing a nonzero holomorphic one-form on a **fixed** finite cover; zero irregularity must hold for all such covers.

On that branch, `zero:line-nonvanishing` (`311-347`) asserts a **meromorphic**, not necessarily holomorphic, section of some power of the chosen line. It needs simultaneous cotangent-line bounds on \(X\) and its very general point blowups. The actual quantitative bottlenecks are a volume-preserving, ideal-order-retaining current approximation with a fixed positive rank fraction (`zero:selected-rank-fraction`, `1158`), the incidence pole \(b_V\ge s-C_n\) (`1207-1289`), and maximal-minor vanishing
\[
h_j\ge c_n jR_j^+s
\]
(`zero:determinant-order-equation`, `1370`). The restricted incidence ideal is jointly \((u,y_1,\ldots,y_{n+1})\), not merely a fiber ideal (`1419`). Cancellation gives `zero:contradiction` (`1645`), with \(s\asymp q^{1/(2n+1)}\) and \(r\ge q^2\). None of the old algebraic evidence constructs these currents, preserves these orders through modifications, or proves the required determinant rank fraction. Meromorphic nonvanishing still needs the signed-divisor and ordinary-decomposition step (`1672-1745`) to force the nef class to vanish.

**3. Rational nef descent is more than a real pushforward.** `03-descent.tex:11-190` defines \(S=c^{-1}g_*(T\wedge\omega^d)\) (`desc:base-current`, `74`). It must eliminate the vertical divisor in \(T-g^*S=[D]\) using the connected weighted intersection matrix (`106`), whole pullbacks over divisorial base loci, and negativity over the flattened main component. Only then does `desc:real-pullback` (`162`) give \(\alpha=g^*\beta'\). Injective **rational** cohomological pullback recovers a rational line; projectivity of the base is used to prove it nef. The catalogue owes this singular-fiber/rationality argument.

`desc:representative` (`193-213`) chooses one global twist; `desc:flat` (`216-261`) requires actual fiberwise rational triviality and kills finite meridian holonomy. Numerical triviality alone is insufficient.

**4. Fiberwise twists cannot simply be extended.** `06-cycles.tex:165-244`, `cycle:detection`, constructs countably many global maps whose fibers detect the inductive semiample fibrations. `cycle:nef-summand` (`322-470`) fixes a representative \(M_i^*\) for each eligible map **before choosing** the very general algebraic-reduction fiber. The actual identity needed to derive `cycle:positive-kappa` (`427`) uses flat descent and a big base line. Coherent base change (`46`) then lifts two sections of one fixed global line to a nonconstant meromorphic function, contradicting algebraic reduction. The old evidence contains neither this countable detection construction nor the quantifier-compatible global twists.

**5. A period-based ordinary adjoint is indispensable.** `04-adjoint.tex:10-25`, `adj:base`, must turn \(K_Y+D\sim_{\mathbb Q}f^*H\), for a possibly nonprojective Kähler total space, into \(H\sim_{\mathbb Q}K_Z+D_Z\) with \(D_Z\ge0\) klt. It requires the cyclic root construction from a meromorphic **base** frame, discriminant thresholds \(\min(1-u_i)/a_i\), and the Hodge norm exponent identifying the parabolic moduli line (`adj:norm-power`, `248`). `adj:period-descent` (`63`) is an actual line identity, not permission to discard an arbitrary flat twist.

`adj:rank` (`296-382`) must identify extreme-line and full period ranks through boundary-preserving lifted flows; the root order \(e-1-p\le e-2\) (`189`) uses the original effective klt boundary. This yields a big quotient line and an effective small klt moduli representative (`383-459`), retaining the full integral cohomology lattice despite a real, possibly irrational polarization. No old certificate proves these extension or period-rank assertions.

**6. Completion retains a further analytic comparison.** `07-completion:83-178` uses the separate \(b>2n\) integral ray estimate to keep the ordinary program over the fixed projective base. `finish:exceptional` (`12-80`) identifies the entire negative part for divisors whose images have codimension at least two, even with positive-dimensional fibers; birational exceptional translation alone is insufficient. Finally, `288-305` descends \(L=D+F\) using \(\operatorname{Pic}^0\) invariance. These are still catalogue obligations, although the source gives conditional proof passages.

## Classification and integrity

These are manuscript-attributed results, not Argus novelty, a reproduced theorem, failed attack, or original-line strengthening. All seven read K files and the projective positive-part source matched existing manifest SHA-256 hashes. `verdict.json` records the complete main statement and bounded dependency coverage, not an audit of all machinery. Excluded geometric sections and `frobenius.tex` were not read; neither paper is declared false or certified.
