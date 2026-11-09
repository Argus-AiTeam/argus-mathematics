# Projective dependencies: assessment of the old catalogue

**Verdict:** `unproved_dependency_claims`. Catalogue assessment complete; manuscript proof and native independent acceptance are not established.

**Source P:** OpenAI manuscript `Numerical-Semiampleness-of-Nef-Adjoint-Divisors-October-3-2026`. Authoritative `../9100036/MANUSCRIPTS.json` pins revision `4eaee87548250b2682affda7d05d947c05554bae`; reads used its listed `source_directory`. Filenames below mean `build/sections/<filename>.tex`.

## Exact claim and evidence boundary

P's `introduction:18-46`, `thm:main`, concerns a projective klt **rational** pair over an **algebraically closed characteristic-zero** field, with effective boundary, pseudo-effective \(T=K_X+B\), and nef rational Cartier \(M\) **on \(X\)**. If \(D=T+M\) is nef, there exists semiample rational Cartier \(L\) **on the same \(X\)** with \(D\equiv L\): equal degrees on every integral curve. There is no dimension ceiling, original-\(D\) semiampleness, or arbitrary higher-model nef-data conclusion. The introduction's elliptic example motivates numerical replacement.

The old `REPORT.md:43-60` correctly calls these manuscript assertions, not accepted external theorems; `61-113` preserves attribution and proof boundaries. All four assigned ledger claims remain version 1, have no formal statement, and their graph nodes are open. Historical `reviewer:41e8b874f58e` support for finite-data/algebraic units is real, notwithstanding stale graph flags and pending-review prose. It does **not** support these four claims; the historical family-wrapper judgement is inconclusive. Current independent review remains pending.

## Claim/dependency support table

| Old claim, all v1 | Decisive source and dependency | What the old evidence supports |
|---|---|---|
| `C9000036-PROJECTIVE` | `introduction`, `thm:main`; `positive:7-24`, `prop:positive-part` | Faithful target and dependency map, not the simultaneous induction or descent. |
| `C9000036-CY-BIG` | `geometry:13-24`, `thm:terminal-big`; `completion:30-39`, `eq:completion-cy-claim` | Correctly isolated full-nef-dimension bigness obligation, not arbitrary nef-bigness. |
| `C9000036-JET-GEOMETRY` | `geometry`, `j:scalar-order`, `j:large-seshadri`; `jet-tools`, `j:bounded-curve-obstruction` | Names the geometric inputs; supplies no reproduction establishing them on every hypothetical counterexample. |
| `C9000036-COMPANION-LA` | `preliminaries:65-71`, `input:abundance`; `build/references.tex:174-179` | Verified citation and stated ordinary lc abundance input, not verification of the companion theorem. |

## Concrete obligations still owed by the catalogue

**1. The birational induction is substantive.** `reduction:12-65` states simultaneous \((P_n)\), bigness of \(T+cM\) for every rational \(c>0\) under `eq:full-condition`, and \((Z_n)\), rational numerical semiampleness of the birational positive part without that condition. `lemma:two-nef-model` (`150-281`) first makes the ordinary adjoint semiample using MMP and abundance, then runs a second, ordinary-adjoint-trivial generalized program. Equation `eq:two-comparisons` retains two effective exceptional errors; the transformed \(M\) is initially only pseudo-effective. Existence of generalized models does not automatically prove preservation of the ordinary generated line in this second program.

`positive:84-157` similarly needs an \(L\)-trivial program, justified by the Cartier-integral ray bound. The other branch requires nef reduction, numerical descent `eq:nef-descent` (`209`), a relative good model `eq:relative-iitaka` (`295`), and an **ordinary effective klt** base adjoint `eq:base-adjoint` (`313`). Finally, `positive:374-416` descends a semiample representative through rational singularities and \(\operatorname{Pic}^0\), and `425-491` transfers it between algebraically closed fields. No Frobenius coefficient calculation constructs these models, boundaries, or descended lines.

**2. The bigness assertion has essential restrictions.** `thm:terminal-big` requires a complex projective **Q-factorial terminal** \(n\)-fold, \(n\ge2\), \(K_X\sim0\), a nef **Cartier** \(L\) of **full nef dimension**, and lower-dimensional \((P_j)\). Full nef dimension is not mere nefness, nor an assumption of positive top self-intersection. `completion:45-82` uses ordinary abundance, an index-one cover, and crepant terminalization to reach this case. With boundary, `completion:87-176` constructs \(G\sim_{\mathbb Q}\alpha B+M\) and the effective klt perturbation \(\Delta_u=(1-u\alpha)B+uG\), whose ordinary adjoint is \(uM\). These transfers and applications of abundance are not supplied by the finite-data obstruction.

**3. Scalar jets require geometric exclusions.** Under the contrary assumption, `eq:scaling` (`geometry:38-48`) gives \(P=r(L+tA)\), \(r\to\infty\), and a bounded positive volume window. `j:scalar-order` (`90-141`) bounds **every** nonzero section of every Cartier \(kP\) at a very general point by \(4k(P^n)^{1/n}\). Producing the requisite moving full-kernel components with ordinary-power ideal containments is an obligation of `jet-tools:211-307`, not a consequence of an algebraic determinant.

The exclusion needs the dimension-uniform estimate
\[
r\le (m_fC_1)^{f-1}C_0
\]
in `jet-tools:12-103`, obtained from polarized effective birationality, integral \(L\)-degree, and actual covering curves. The projective-bundle exclusions also require general-incidence slice restrictions, the branch estimate `j:branch-canonical` (`geometry:488-515`), and `j:abelian-big` (`573-603`). Bounded cover degree alone is insufficient: `jet-tools:316-355` additionally requires a fixed branch complement after excluding sweeping branch divisors. These are concrete additional constructions, including cited companion Lemmas 7.1–7.5, not independently established old inputs.

**4. Large bundle jets must be assembled with all finite-data inputs.** The bundle is
\[
Z=\mathbb P(\mathcal O(L)_1\oplus\mathcal O(L)_2),\qquad R=P_1+P_2+q\xi
\]
(`geometry:150-159`). `j:large-seshadri` (`209-264`) requires a fixed \(q\), then sufficiently small \(t\), and a smooth torus point over any prescribed resolution-isomorphism opens, with \(\varepsilon(R;z)>2n+2\). Volume counting alone does not establish that estimate.

The decisive interface is `geometry:629-633`: **one** sufficiently small \(t\) must be fixed before entering the finite-data comparison. The catalogue still owes compatible smooth-model divisor/intersection data, flag and high-jet conditions, preservation of the universally quantified scalar bound, and an actual movable-curve construction with the required intersection normalization and cotangent/slope control. These must hold jointly, not for unrelated choices or as limiting assertions. The current index assigns `C9000036-FINITE-DATA` v7 elsewhere and retains its intersection, flag, jet, movable-curve, and quantifier hypotheses. Even conditional acceptance of that incompatibility theorem supplies none of this geometric tuple. Its excluded proof is not re-reviewed here.

## Attribution, classification, and integrity

The ordinary input actually cited in pinned P is *Log abundance in characteristic zero*, **Theorem 1.1**. The old report's `61-113` separately associates Theorem 9.1 with the target; that bibliographic shorthand cannot replace the precise ordinary lc statement in `input:abundance`. The unlisted companion was not opened or treated as accepted. `input:models` (`preliminaries:78-97`) asks for a terminating **choice** with fixed nef b-data, not arbitrary-MMP termination.

These are manuscript-attributed original statements and adaptations, not original Argus contributions. The old draft catalogues them; its finite-data reproduction is a different unit. Actual semiampleness, unrestricted nef-bigness, or automatic generalized abundance would be strengthenings not adopted here. Novelty is **not claimed by the old draft**; no failed attack or counterexample is asserted.

SHA-256 matched every read source against its existing manifest hash: complete introduction, preliminaries, reduction, jet-tools, geometry, completion and positive sections, plus targeted LA/MM bibliography. `verdict.json` records coverage and hashes. Old report lines 186–543 and `frobenius.tex` were not read or replayed. Unproved old dependencies do not mean the paper is false or blanket-certified correct.
