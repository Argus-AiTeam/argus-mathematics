# Verifying the OpenAI Mathematics Collection with Argus

## Summary

- **What Argus did.** An exploratory first pass ran one Argus campaign per active family (373 campaigns). It was *not* a per-manuscript review: the scheduler marked a family done once it had accumulated evidence records. A systematic second-pass review of that work is in progress; **54 of 373 families** have been reviewed and accepted so far.
- **Errors in OpenAI's manuscripts.** Checked against the source text, **no mathematical error in any OpenAI manuscript has been established.** Three minor issues were found: one wrong lemma number, one dead DOI, and one reading-dependent wording gap (§2).
- **What has value.** In the 54 reviewed families, **38 contain at least one improvement over the stated OpenAI result** that the review supports: sharper constants or exponents, weaker hypotheses, generalizations, or matching sharpness examples. The other 16 independently confirm OpenAI's result. About a third of the 38 are modest; the strongest are listed in §3.
- **Lean.** Argus produced 384 Lean 4.31.0 certificates in 314 families, all recorded as compiling with no `sorry` and no non-standard axioms. They contain roughly **120,000 distinct Argus-authored lines** (§4).
- **Caveats.** All acceptance so far is by Argus's own AI Reviewer, not by human experts, and no item's novelty has been checked against the literature.

## 1. Scope and cost

| | |
| :--- | :--- |
| Upstream corpus | 373 active families / 721 manuscripts at `4eaee875`; 3 withdrawn manuscripts are out of scope |
| First pass (exploratory) | 373 campaigns, about 3.21 B tokens, provider-metered **$1,861.55** |
| All OpenAI-collection work to date | about 6.27 B tokens, **$3,477.03** (as of 2026-11-09 07:21 UTC) |
| Systematic review | 54 / 373 families accepted by the Argus AI Reviewer (in progress) |

Costs are provider token-meter dollar equivalents and a known lower bound; 14 errored calls carry no token detail.

## 2. Issues found in OpenAI's manuscripts

| Family | Location (`preprints/…`) | Issue | Severity |
| :--- | :--- | :--- | :--- |
| `320` | `Nonhomeomorphic-closed-aspherical-four-manifolds-with-the-same-homotopy-type-October-4-2026/build/sections/formal.tex:785` | Cites `[MT, Lemma 3.9]`; the intended result in MT is Lemma 6.7, "Correction over the full parameter algebra". The mechanism is restated inline (lines 786–793). | citation typo; no mathematical gap |
| `318` | `Filtered-chromatic-splitting-at-generic-primes-…/build/references.bib:430–438` | The DOI `10.24033/ast.534` given for Zink, *The display of a formal p-divisible group*, does not resolve (HTTP 404). | bibliography typo |
| `247` | `An-infinite-finitely-presented-periodic-group-September-23-2026/build/sections/finite-rules.tex:575–581` | "A boundary-cursor region can always be released inside its acquired interval" fails for a one-letter truncated word-end region at `C(2),B` if such regions are included. The actual application (lines 962–1001) starts at `C(1)` and is unaffected. | wording / missing hypothesis under one reading; main theorems unaffected |

**OpenAI's own withdrawals.** On 2026-10-07 OpenAI announced that it had withdrawn three manuscripts:
- "Algebraicity of Weil classes on split abelian eightfolds"
- "Algebraicity of Kuga–Satake Correspondences for K3 Surfaces"
- "The rational Hodge conjecture for products of K3 surfaces"

The reason given is a sign error (`I_new = I(f_1) − m = −2m ≠ 0`) in the first manuscript, which invalidates a stabilization-trace cancellation argument used by the other two. OpenAI states that the withdrawal concerns the proofs, not the truth of the statements. Argus did not find this error.

**Li–Zhang cone equality (`342`).** Li–Zhang, *Comparing tamed and compatible symplectic cones…*, Comm. Anal. Geom. 17 (2009), state in Corollary 1.1 (arXiv:0708.2520v4, Corollary 1.4) that on an almost complex 4-manifold with a compatible symplectic form, `K^t = K^c + H^-`. The same claim appears in Theorem 1.1 and Proposition 3.1 (v4: Theorem 1.3, Proposition 3.9).
- **OpenAI's September 23 version** of *Taming implies compatibility on four-manifolds* used this corollary to state `K^t = K^c + H^-`.
- **The October 6 revision** proves its own cone description instead. It states the equality only when `h^- = b_2^+ − 1`, notes that the inclusion can be strict even when `H^- = 0`, and gives an explicit `T^4` example (`ex:strict-cones`). OpenAI's `history.md` records this as "corrected the cone-equality claim … added a strict-inclusion example". OpenAI does not say explicitly that the Li–Zhang statements are false.
- **What Argus added:**
  - It verified OpenAI's example (exact symbolic checks plus a Lean core).
  - It checked directly that the example satisfies Li–Zhang's hypotheses (`C^∞`-full, compatible cone nonempty). The example is therefore a counterexample to the three printed Li–Zhang statements.
  - It matched the arXiv and journal numbering.
  - It located the failing step: the disjointness claim in the proof of Theorem 3.4 (v4: Theorem 3.7). It refuted that claim with an explicit positive projection of a closed current.
- **Not refuted:** the `b^+ = 1` special case.
- **Credit and status:** the counterexample is OpenAI's. Whether the literature already records the problem has not been checked, and this family is not yet in the systematic review.

## 3. What the review supports: improvements over stated OpenAI results

All items below were accepted by the Argus AI Reviewer within the stated conditions. None has been checked by a human expert, and none has had its novelty checked against the literature. Some proofs are prose only. The review reports are not yet published in this repository.

| Family | Topic | Improvement over the manuscript's statement |
| :--- | :--- | :--- |
| `071` | Koebe circle domains | Barrier coefficient 8 (budget `4m`) improved to every `κ>1` (budget `κm`); an explicit annular construction shows no coefficient below 1 works, so the constant is optimal. |
| `028` | Walks on Gaussian primes | Rectangle lemma `C·e^{-c d³ r}` improved to `3·e^{-d² r/32}`, removing a factor `d` from the exponent. |
| `026` | Large prime gaps | Error term `O(L^{-t-1/2}(log L)^A)` improved to `O(L^{-t-1}(log L)^A)`. |
| `025` | Short Egyptian fractions | A single threshold for every order `r ≤ log S /(200000 log log S)` (manuscript: fixed `r`), with the upper bound formalized in Lean. A primorial family shows failure at `C log S/log log S` for every `C>1/2`, so the growth order is determined up to constants. |
| `055` | Gepner stability on quintic threefolds | Comparison radius `1/200000` widened to `1/4000`; existential constants made explicit; the range `0<u<13/46` is optimal for the displayed criterion. Categorical steps are conditional prose. |
| `039` | Seshadri constants | Reshaping condition `dw<1/16` relaxed to `dw<1/3`; conclusion strengthened from equal-order jet surjectivity to transfer of all mixed-order jet ranks. |
| `015` | Torus packets | Sharper local shell bound at odd primes, with an explicit family showing the odd local exponent is sharp; two profile inequalities improved from `G_0^{24}` to `G^3`. |
| `046` | Shafarevich counterexample | The manuscript's construction for `n=4` extended to every dyadic `n=2^r`, `r≥2`. |
| `049` | Stable coordinates | The ideal identity holds in every commutative ring for arbitrary `t` (manuscript: one `t` over a field); the rigidity statement is generalized beyond the manuscript's single `W`. |
| `068` | Anticanonical systems | The toroidal hypothesis is replaced by "locally klt type"; the correction chamber is shown to be exact, with a sharpness family. |
| `072` | Brennan-type integral means | The affine-transport chain extended from `p=1,2` to general `p`; the rigidity barrier extended from `k=3/4` to all `k`. Conditional prose. |
| `048` | Free tangent sheaf surface | An upper bound added to `p_g ≥ 33`, giving `33 ≤ p_g ≤ 39`, with an exact rank formula. |
| `009` | Milnor K-theory reconstruction | One proposition proved without the finite p-rank hypothesis, and line recovery for every char-`p` field of finite p-degree, including `p=2`. Both are formalized in Lean. |
| `021` | Jacobsthal function | Bound `O(d³(1+S^{2/3}))` instead of the stated `O(d⁴(…))`. The review notes the manuscript's own proof already implies this. |
| `022` | Duffin–Schaeffer | Oriented mixed error `O(W)` improved to `O(W²)`, under the manuscript's stipulated hypotheses. |

The remaining reviewed families with improvements are `012, 013, 014, 017, 018, 023, 024, 031, 033, 036, 037, 038, 042, 044, 051, 056, 063, 065, 066, 067, 073, 076, 078`. Several of these are modest: an explicit constant, a refinement of an intermediate step, or a result conditional on unestablished inputs.

**First-pass candidates not yet re-reviewed.** Earlier spot-reading found further candidates:
- `176`: separation constant 16 reduced to 3, in compiling Lean; [package](../results/openai-audit-theorems/9000176/).
- `113`: encoding preimage bound `(10N)^{30}` reduced to `2^{17}N^8`; [package](../results/openai-audit-theorems/9000113/).
- `074`: a two-colour matching lower bound with sharpness; [package](../results/openai-audit-theorems/9000074/).
- `164`: polynomial-scale rough steps; [package](../results/openai-audit-theorems/9000164/).
- `130`: choosing `h=25` instead of `h=100` widens the power-saving gap by a factor of about 1,650.

These stay candidates until the systematic review reaches them.

## 4. Lean certificates

| Quantity | Value |
| :--- | :--- |
| Certificates / families | 384 / 314 |
| Recorded total lines | 520,223 (raw sum over all certificates) |
| of which `156` | 346,954 lines: a machine-generated, kernel-checked replay of an UNSAT proof for the finite 10-label obstruction (`TenLabel.no_model`); best counted as **one** certified finite obstruction |
| of which ported from OpenAI's own Lean | about 52,000 lines (e.g. families `118`, `131`, `149` are ≥95% upstream code, as their fidelity notes state) |
| Distinct Argus-authored lines outside `156` | **about 120,000** |
| Checks | every certificate records `exit_code 0`, no `sorry`/`admit`, and no axioms beyond `propext`, `Classical.choice`, `Quot.sound` |
| Recompiled on 2026-11-09 | 12 certificates: 10 passed; the other 2 import OpenAI's `OAI` library and need it on the path |
| Published in this repository | 23 families under [`results/openai-audit-theorems/`](../results/openai-audit-theorems/) |

Each certificate checks a delimited core lemma, stated in its `statement_fidelity.md`. None formalizes a manuscript end to end. The raw count of 41,764 theorem declarations is dominated by 32,135 propagation-step lemmas in `156`, so it is not a useful measure.

Substantial examples (Argus-authored lines):
- `321` Fox-calculus torsion, Wall D(2): 2,029 lines
- `003` determinant / integral-norm chain: 2,796 lines
- `124` scheduling protocol extraction: 8,016 lines
- `176` Kahn–Kalai pathwise reduction: 1,814 lines
- `242` Pell and power completeness: 1,674 lines

## 5. Limitations

- **Reviewer.** Acceptance is by Argus's AI Reviewer, which can be wrong; human expert review is still needed.
- **Novelty.** No improvement has been checked for novelty against the literature.
- **Coverage.** 319 families are not yet reviewed. Their first-pass self-assessments are not findings.
- **Availability.** Review reports and most Lean sources are not yet published in this repository.

## Appendix: per-family status (373 active families)

Lean figures are as of 2026-11-09. "Authored lines" excludes lines identical to OpenAI's upstream Lean and counts each source file once.

| Family | Title | Manuscripts | Argus Lean (certs / authored lines) | Review status |
| :--- | :--- | :---: | :---: | :--- |
| `001` | Milne’s rationality conjecture and algebraic specialization. | 1 | 1 / 41 | reviewed: confirmation |
| `002` | The full BSD formula from low Selmer corank. | 3 | 1 / 193 | not yet reviewed |
| `003` | The quasi-Riemann hypothesis. | 3 | 2 / 2,672 | not yet reviewed |
| `004` | Hilbert’s tenth problem over ℚ. | 2 | 2 / 245 | reviewed: confirmation |
| `005` | Irrationality of Catalan’s constant. | 1 | 1 / 104 | not yet reviewed |
| `006` | Goldfeld’s conjecture: densities and mean analytic rank. | 2 | 1 / 539 | reviewed: confirmation |
| `007` | Ordinary two-point correlations and the corrected Elliott conjecture. | 1 | 1 / 156 | not yet reviewed |
| `008` | The Deligne–Drinfeld conjecture. | 1 | 1 / 38 | reviewed: confirmation |
| `009` | Function-field reconstruction from Milnor K-theory and Galois data. | 3 | 2 / 2,270 | reviewed: improvement |
| `010` | Unrestricted pro-modularity at the prime two. | 3 | 1 / 67 | not yet reviewed |
| `011` | Prime-factor statistics of $`p-1`$. | 3 | 2 / 173 | not yet reviewed |
| `012` | Independent largest prime factors of consecutive integers. | 1 | 1 / 211 | reviewed: improvement |
| `013` | Ostmann’s inverse Goldbach conjecture. | 1 | 1 / 114 | reviewed: improvement |
| `014` | Restricted geometric Langlands, global Arthur enhancements, and generic Ramanujan. | 8 | — | reviewed: improvement |
| `015` | Torus-packet equidistribution in prime, quartic, and sextic degrees. | 3 | — | reviewed: improvement |
| `016` | Zilber–Pink in abelian varieties and the Siegel threefold. | 4 | 1 / 84 | not yet reviewed |
| `017` | The irrationality exponent of <i>π</i> is 2. | 1 | 1 / 157 | reviewed: improvement |
| `018` | The Margulis–Platonov conjecture over global fields. | 2 | 1 / 299 | reviewed: improvement |
| `019` | The local <i>p</i>-adic section conjecture and global consequences. | 2 | 1 / 59 | reviewed: confirmation |
| `020` | Squarefree quartics and power-free polynomial values. | 1 | 1 / 160 | reviewed: confirmation |
| `021` | A quadratic bound for Jacobsthal’s function. | 1 | 1 / 320 | reviewed: improvement |
| `022` | The weak inhomogeneous Duffin–Schaeffer conjecture. | 1 | 1 / 460 | reviewed: improvement |
| `023` | Patterson's first moment for cubic Gauss sums. | 1 | 1 / 284 | reviewed: improvement |
| `024` | An asymptotic formula for the number of totients. | 1 | 1 / 137 | reviewed: improvement |
| `025` | Short Egyptian fractions. | 1 | 2 / 413 | reviewed: improvement |
| `026` | Positive lower density of large prime gaps. | 1 | 1 / 72 | reviewed: improvement |
| `027` | Potential integral density on curve character varieties. | 1 | 1 / 112 | not yet reviewed |
| `028` | Uniformly bounded components of Gaussian-prime graphs. | 1 | — | reviewed: improvement |
| `029` | Primitive roots for every admissible integer base. | 2 | — | reviewed: confirmation |
| `030` | Modularity of elliptic curves over imaginary quadratic fields. | 1 | 1 / 154 | reviewed: confirmation |
| `031` | Uchida’s conjecture for open homomorphisms of Galois groups. | 1 | — | reviewed: improvement |
| `032` | The rational Hodge conjecture for CM abelian varieties. | 5 | — | reviewed: confirmation |
| `033` | Iitaka subadditivity, variation, and logarithmic additivity. | 5 | — | reviewed: improvement |
| `034` | Log abundance for compact Kähler spaces under logarithmic Iitaka subadditivity. | 14 | — | not yet reviewed |
| `035` | Log-canonical threefold abundance in numerical dimension one. | 2 | 1 / 242 | not yet reviewed |
| `036` | Numerical semiampleness and generalized minimal models. | 4 | 1 / 295 | reviewed: improvement |
| `037` | The ordinary-double-point volume gap. | 2 | 1 / 54 | reviewed: improvement |
| `038` | Fujita’s freeness conjecture. | 1 | 1 / 245 | reviewed: improvement |
| `039` | Nagata’s conjecture and maximal Seshadri constants. | 4 | 1 / 120 | reviewed: improvement |
| `040` | Bloch’s conjecture for complex surfaces. | 1 | — | reviewed: confirmation |
| `041` | Hyperkähler SYZ and projective-space bases. | 2 | 1 / 203 | reviewed: confirmation |
| `042` | Oka classification for minimal compact complex surfaces: Kodaira dimension zero and class VII. | 1 | — | reviewed: improvement |
| `043` | <i>P</i> = <i>W</i> for fixed-determinant SL<sub><i>n</i></sub> moduli spaces. | 1 | — | reviewed: confirmation |
| `044` | The equivariant cohomological Hikita conjecture. | 1 | 1 / 77 | reviewed: improvement |
| `046` | Shafarevich counterexamples in dimension two and with large fundamental group. | 2 | 1 / 60 | reviewed: improvement |
| `047` | Zariski cancellation and affine fibrations over the complex numbers. | 1 | 1 / 155 | not yet reviewed |
| `048` | A characteristic-zero counterexample to Lipman–Zariski. | 1 | — | reviewed: improvement |
| `049` | A stable-coordinate counterexample in four variables. | 2 | 1 / 136 | reviewed: improvement |
| `050` | A counterexample to Griffiths’ positivity conjecture. | 1 | — | not yet reviewed |
| `051` | Kobayashi’s canonical-ampleness conjecture. | 1 | — | reviewed: improvement |
| `052` | Tangent splittings and product decompositions. | 2 | 1 / 198 | not yet reviewed |
| `053` | A counterexample to Pixton completeness in Chow. | 1 | 2 / 131 | not yet reviewed |
| `054` | Irrational cubic fourfolds with Hodge-theoretic and categorical K3 associations. | 1 | 1 / 138 | not yet reviewed |
| `055` | Gepner symmetry and large-volume stability on threefolds. | 2 | 1 / 198 | reviewed: improvement |
| `056` | Termination of projective and Kähler fourfold minimal model programs. | 5 | — | reviewed: improvement |
| `057` | Fundamental groups of special complex varieties and root orbifolds. | 3 | 1 / 76 | reviewed: confirmation |
| `058` | Semialgebraic universal covers and bounded domains. | 2 | — | not yet reviewed |
| `059` | Counterexamples to Zariski’s multiplicity conjecture. | 2 | — | not yet reviewed |
| `060` | The Global Spherical Shell conjecture. | 1 | — | not yet reviewed |
| `062` | Projective contact classification and the LeBrun–Salamon conjecture. | 1 | 1 / 41 | reviewed: confirmation |
| `063` | The generalized Mukai conjecture. | 1 | — | reviewed: improvement |
| `064` | Topological triviality of <i>μ</i>-constant surface singularities. | 1 | — | reviewed: confirmation |
| `065` | Virasoro constraints for complete intersections and projective-bundle towers. | 2 | 1 / 77 | reviewed: improvement |
| `066` | Bounded klt complements for Fano contractions. | 2 | 1 / 67 | reviewed: improvement |
| `067` | The Campana–Peternell conjecture in dimension six. | 1 | — | reviewed: improvement |
| `068` | Anticanonical nonvanishing in every dimension. | 7 | 1 / 111 | reviewed: improvement |
| `069` | Global quantum geometric Langlands at irrational level. | 1 | — | not yet reviewed |
| `071` | Koebe’s circle-domain conjecture. | 2 | 1 / 44 | reviewed: improvement |
| `072` | Brennan's conjecture and the integral-means spectrum. | 2 | 1 / 115 | reviewed: improvement |
| `073` | The Falconer distance conjecture. | 1 | 1 / 1,113 | reviewed: improvement |
| `074` | Kakeya in three and four dimensions. | 2 | 1 / 97 | not yet reviewed |
| `075` | The $`L\log L`$ Fourier-convergence conjecture. | 1 | 1 / 670 | reviewed: confirmation |
| `076` | Real ultraflat Littlewood polynomials and unbounded binary merit factors. | 3 | 1 / 120 | reviewed: improvement |
| `077` | Fourier restriction for positively curved surfaces. | 2 | — | not yet reviewed |
| `078` | The three-dimensional Bochner–Riesz conjecture. | 1 | 1 / 122 | reviewed: improvement |
| `079` | Local smoothing for the Euclidean wave equation. | 2 | 1 / 97 | not yet reviewed |
| `080` | The exact Sobolev endpoint for Schrödinger convergence. | 2 | 1 / 88 | not yet reviewed |
| `081` | Riesz transforms and rectifiability in higher codimension. | 1 | 1 / 66 | not yet reviewed |
| `082` | Annular variation and dyadic absolute bounds for the triangular Hilbert transform. | 3 | 1 / 95 | not yet reviewed |
| `083` | Hilbert transforms along Lipschitz directions. | 1 | 1 / 181 | not yet reviewed |
| `084` | The geometric case of the Erdős similarity conjecture. | 2 | 1 / 774 | not yet reviewed |
| `085` | Endpoint Sobolev regularity of centered disk averages. | 1 | 1 / 305 | not yet reviewed |
| `086` | An <i>L</i><sup>3</sup> bound for the trilinear Hilbert transform. | 1 | 2 / 158 | not yet reviewed |
| `087` | The Mahler conjectures, functional inequalities and polar-product symplectic width. | 3 | 1 / 55 | not yet reviewed |
| `088` | Sharp projection-body inequalities and a counterexample to simplex maximization. | 2 | 1 / 532 | not yet reviewed |
| `089` | Bounded-distortion <i>L</i><sub>1</sub> embeddings of planar and bounded-treewidth graphs. | 2 | 1 / 957 | not yet reviewed |
| `090` | Triangular-lattice optimality, long-range Riesz and Coulomb energies, and spherical logarithmic energy. | 4 | — | not yet reviewed |
| `091` | Logarithmic and <i>L</i><sub><i>p</i></sub> Brunn–Minkowski inequalities and the B-conjecture. | 1 | 1 / 204 | not yet reviewed |
| `092` | The optimal order of convex-body covering density. | 2 | 1 / 218 | not yet reviewed |
| `093` | Dimension-free logarithmic Sobolev inequality for subgaussian log-concave measures. | 1 | — | not yet reviewed |
| `094` | Subpolynomial dimension reduction in <i>L</i><sub><i>p</i></sub>. | 1 | 1 / 336 | not yet reviewed |
| `095` | Hyperbolicity cones without semidefinite lifts. | 3 | — | not yet reviewed |
| `096` | The Gaussian propeller conjecture in every dimension. | 1 | 1 / 490 | not yet reviewed |
| `097` | The Euclidean Steinitz–Bergström bound. | 1 | 1 / 76 | not yet reviewed |
| `098` | Compact counterexamples to bi-Lipschitz dimension reduction. | 1 | 1 / 302 | not yet reviewed |
| `099` | The sharp exponential scale of edit-distance distortion. | 3 | 1 / 176 | not yet reviewed |
| `100` | Cylinder coverings below the half-area bound. | 4 | 1 / 253 | not yet reviewed |
| `101` | The sharp simplex conjecture for isotropic constants. | 1 | 1 / 385 | not yet reviewed |
| `102` | The Unique Games Conjecture and optimal approximation thresholds. | 5 | 4 / 1,172 | not yet reviewed |
| `103` | Exact derandomization of logarithmic space: $`\mathsf L=\mathsf{RL}=\mathsf{BPL}`$. | 1 | 1 / 443 | not yet reviewed |
| `104` | Quasipolynomial algorithms for mean-payoff, stochastic and parity games. | 4 | 1 / 1,229 | not yet reviewed |
| `105` | Perfect completeness for 2-to-1 games. | 1 | 1 / 130 | not yet reviewed |
| `106` | Hardness of coloring three-colorable graphs. | 1 | 4 / 594 | not yet reviewed |
| `107` | Matrix multiplication with exponent at most 9/4. | 3 | 1 / 96 | not yet reviewed |
| `108` | A cubic permanent–determinant lower bound. | 1 | 1 / 209 | not yet reviewed |
| `109` | Integer multiplication below $`n\log n`$. | 1 | 1 / 141 | not yet reviewed |
| `110` | Optimal-order randomized <i>k</i>-server on arbitrary metrics. | 2 | 1 / 145 | not yet reviewed |
| `111` | One-sample matroid prophet inequalities against an almighty adversary. | 1 | 1 / 98 | not yet reviewed |
| `112` | Beyond the square-root exponent for depth-three circuits. | 1 | 1 / 823 | not yet reviewed |
| `113` | Approximate counting and entropy of perfect matchings. | 2 | 1 / 127 | not yet reviewed |
| `114` | Approximate counting of common integer polymatroid bases. | 2 | 3 / 3,219 | not yet reviewed |
| `115` | Sampling and counting contingency tables with arbitrary margins. | 2 | 1 / 1,383 | not yet reviewed |
| `116` | Uniform black-box noncommutative identity testing across characteristics. | 3 | 2 / 1,483 | not yet reviewed |
| `117` | Uniform sparsest cut: hardness and semidefinite gaps. | 2 | 1 / 120 | not yet reviewed |
| `118` | Bin packing and unbounded configuration-LP gaps. | 1 | 1 / 712 | not yet reviewed |
| `119` | The Courtade–Kumar and Hellinger conjectures. | 2 | 1 / 59 | not yet reviewed |
| `120` | Almost-linear-time exact matching and prescribed-degree factors in general graphs. | 1 | 1 / 251 | not yet reviewed |
| `121` | Almost-linear approximation of edit distance. | 1 | 1 / 406 | not yet reviewed |
| `122` | Quantitative trace-reconstruction bounds with a uniform decoder. | 3 | 1 / 91 | not yet reviewed |
| `124` | Polynomial-time scheduling on three identical machines. | 1 | 6 / 21,357 | not yet reviewed |
| `125` | The metric <i>k</i>-median approximation threshold and recovery. | 2 | 1 / 215 | not yet reviewed |
| `126` | Exponential semidefinite complexity of perfect matching. | 1 | 1 / 142 | not yet reviewed |
| `127` | Average sensitivity of polynomial threshold functions. | 1 | 1 / 141 | not yet reviewed |
| `128` | A factor-two approximation for shortest common superstring. | 1 | 1 / 706 | not yet reviewed |
| `129` | Exponential state costs for two-way automata. | 2 | 1 / 884 | not yet reviewed |
| `130` | Exact Fourier transforms below $`n\log n`$. | 2 | — | not yet reviewed |
| `131` | Rapid mixing of graph switches for every degree sequence. | 1 | 1 / 566 | not yet reviewed |
| `132` | A superquadratic separation of sensitivity and block sensitivity. | 1 | 1 / 756 | not yet reviewed |
| `133` | The computational complexity of Weisfeiler–Leman refinement. | 4 | 2 / 2,421 | not yet reviewed |
| `134` | Generalized star height at most three. | 3 | 1 / 1,268 | not yet reviewed |
| `135` | Homogeneous depth-five lower bounds for iterated matrix multiplication. | 1 | 1 / 493 | not yet reviewed |
| `136` | A quasilinear PCP theorem for PPAD. | 1 | 1 / 117 | not yet reviewed |
| `137` | One-tape time simulation in two-fifths-power space. | 1 | 2 / 3,807 | not yet reviewed |
| `138` | Subset Sum in $`O(2^{0.49n})`$ time. | 2 | 1 / 46 | not yet reviewed |
| `139` | Subpolynomial query complexity for log-concave sampling. | 1 | 1 / 256 | not yet reviewed |
| `140` | Memory–sample lower bounds for noiseless Gaussian regression. | 6 | 1 / 862 | not yet reviewed |
| `141` | Existential–universal real sentences in the counting hierarchy. | 1 | 1 / 511 | not yet reviewed |
| `142` | Deterministic polynomial factorization over prime fields. | 1 | 1 / 122 | not yet reviewed |
| `143` | Hilbert's sixteenth problem: uniform bounds for limit cycles. | 2 | 1 / 331 | not yet reviewed |
| `144` | Banach’s simple Lebesgue-spectrum problem. | 1 | 1 / 132 | not yet reviewed |
| `145` | Rokhlin’s multiple-mixing problem. | 1 | 1 / 112 | not yet reviewed |
| `146` | Positive metric entropy for the standard map. | 1 | 1 / 92 | not yet reviewed |
| `147` | The near-boundary Birkhoff conjecture. | 2 | — | not yet reviewed |
| `148` | The entropy-rate dimension formula for self-similar measures. | 1 | 3 / 858 | not yet reviewed |
| `149` | Classwise permanence for weakly reversible mass-action systems. | 2 | 2 / 320 | not yet reviewed |
| `150` | Weak mixing of triangular billiards with an irrational angle. | 2 | 1 / 112 | not yet reviewed |
| `151` | A <i>C</i><sup>1</sup> counterexample to the entropy conjecture. | 1 | 2 / 892 | not yet reviewed |
| `152` | Zero entropy does not guarantee a smooth positive-volume model. | 1 | — | not yet reviewed |
| `153` | Arithmetic classification and non-Pisot singularity for Bernoulli convolutions. | 1 | 1 / 167 | not yet reviewed |
| `154` | Pointwise multiple ergodic averages for mixing transformations. | 4 | 1 / 202 | not yet reviewed |
| `155` | A counterexample to periodic tiling in dimension three. | 1 | 1 / 604 | not yet reviewed |
| `156` | Borsuk's conjecture fails in dimension nine. | 1 | 1 / 346,954 (generated SAT replay) | not yet reviewed |
| `157` | Graph coloring, clique minors, and Colin de Verdière invariants. | 3 | 3 / 3,007 | not yet reviewed |
| `158` | The Euclidean plane cannot be colored with five colors. | 1 | 1 / 10 | not yet reviewed |
| `159` | Erdős’s reciprocal-sum conjecture and quasipolynomial Szemerédi bounds. | 1 | 1 / 81 | not yet reviewed |
| `160` | Superexponential van der Waerden numbers. | 1 | 1 / 215 | not yet reviewed |
| `161` | Counterexamples to Sidorenko’s conjecture and the forcing conjecture. | 1 | — | not yet reviewed |
| `162` | Counterexamples to Ryser’s covering conjecture. | 2 | 2 / 249 | not yet reviewed |
| `164` | Hindman’s finite sums and products conjecture. | 1 | 1 / 107 | not yet reviewed |
| `165` | The Harary–Hill and Zarankiewicz crossing-number formulas. | 2 | 1 / 236 | not yet reviewed |
| `166` | The higher-dimensional Erdős distinct-distances conjecture. | 1 | 1 / 42 | not yet reviewed |
| `167` | Planar distinct distances and unit-distance bounds. | 2 | 1 / 221 | not yet reviewed |
| `168` | Combinatorial invariance of Kazhdan–Lusztig polynomials. | 1 | 1 / 85 | not yet reviewed |
| `169` | Shareshian–Wachs elementary positivity. | 1 | 1 / 53 | not yet reviewed |
| `170` | Sharp logarithmic exponents for off-diagonal Ramsey numbers. | 2 | 1 / 89 | not yet reviewed |
| `171` | The hypercube Ramsey conjecture. | 1 | 1 / 83 | not yet reviewed |
| `172` | Classification of finite Euclidean Ramsey configurations. | 1 | 2 / 1,347 | not yet reviewed |
| `173` | Seymour’s second-neighborhood conjecture. | 1 | 1 / 245 | not yet reviewed |
| `174` | Deterministic construction of strong thin spanning trees. | 2 | 2 / 451 | not yet reviewed |
| `175` | Talagrand’s expectation thresholds, discrete convexity, and graph decompositions. | 3 | 1 / 519 | not yet reviewed |
| `176` | The second Kahn–Kalai conjecture with an edge-count bound. | 1 | 1 / 1,723 | not yet reviewed |
| `177` | Bounded-degree coboundary expanders. | 1 | 1 / 141 | not yet reviewed |
| `178` | Deterministic nonbipartite Ramanujan graphs in every fixed degree. | 1 | 1 / 45 | not yet reviewed |
| `179` | The circulant Hadamard and Barker-sequence conjectures. | 1 | 3 / 294 | not yet reviewed |
| `180` | Barnette’s Hamiltonian-cycle conjecture. | 1 | 1 / 170 | not yet reviewed |
| `181` | The Erdős–Gallai cycle-decomposition conjecture. | 1 | 1 / 530 | not yet reviewed |
| `182` | Power savings for intersective polynomial differences and prime arguments. | 3 | 1 / 206 | not yet reviewed |
| `183` | Power savings for planar halving lines and <i>k</i>-sets. | 1 | 1 / 1,582 | not yet reviewed |
| `184` | Correspondence coloring with a fixed forbidden subgraph. | 2 | 1 / 123 | not yet reviewed |
| `185` | Counterexamples to infinite matroid intersection and packing/covering. | 1 | 2 / 547 | not yet reviewed |
| `186` | Uniform influence and sharp thresholds for graph and hypergraph properties. | 2 | 2 / 384 | not yet reviewed |
| `187` | Snaky in 21 Maker moves. | 1 | 1 / 1,341 | not yet reviewed |
| `188` | The sharp terminal leave in random triangle removal. | 1 | 1 / 102 | not yet reviewed |
| `189` | Cycle–clique Ramsey numbers. | 1 | 2 / 265 | not yet reviewed |
| `190` | Polynomial removal fails for ordered binary matrices. | 1 | 1 / 162 | not yet reviewed |
| `191` | A power improvement in the Heilbronn triangle lower bound. | 1 | 1 / 387 | not yet reviewed |
| `192` | Boolean functions violate the square-root degree bound by arbitrary factors. | 1 | 1 / 120 | not yet reviewed |
| `193` | Serre’s intersection-multiplicity conjecture. | 1 | 1 / 68 | not yet reviewed |
| `194` | Lech’s multiplicity conjecture. | 1 | 1 / 93 | not yet reviewed |
| `195` | A counterexample to the small Cohen–Macaulay module conjecture. | 1 | 2 / 201 | not yet reviewed |
| `196` | A counterexample to Kaplansky’s zero-divisor conjecture. | 1 | 2 / 459 | not yet reviewed |
| `197` | A torsion-free group algebra that is not directly finite. | 4 | 1 / 101 | not yet reviewed |
| `198` | A counterexample to finitistic-dimension finiteness. | 1 | 1 / 1,543 | not yet reviewed |
| `199` | Counterexamples to Auslander–Reiten, Tachikawa and related homological conjectures. | 2 | 1 / 142 | not yet reviewed |
| `200` | Eisenbud–Green–Harris and lex-plus-powers. | 2 | 1 / 62 | not yet reviewed |
| `201` | A counterexample to Kurosh’s division-ring problem. | 1 | 3 / 360 | not yet reviewed |
| `202` | The blockwise Alperin weight conjecture. | 1 | 1 / 102 | not yet reviewed |
| `203` | Donovan's conjecture over fields and complete mixed-characteristic DVRs. | 2 | — | not yet reviewed |
| `204` | Tensor saturation for even spin groups. | 1 | 1 / 162 | not yet reviewed |
| `205` | Saxl’s conjecture and universal tensor squares. | 2 | 1 / 305 | not yet reviewed |
| `206` | Finite lattice representation and undecidability. | 2 | 1 / 152 | not yet reviewed |
| `207` | The ℓ¹-Bass conjecture for all discrete groups. | 2 | 1 / 141 | not yet reviewed |
| `208` | Finite symmetric tensor categories and the Verlinde tower. | 1 | 1 / 221 | not yet reviewed |
| `209` | Integral counterexamples to Gersten’s conjecture. | 2 | — | not yet reviewed |
| `210` | Foulkes' conjecture for sixth powers and quadratic stabilization. | 2 | 1 / 118 | not yet reviewed |
| `211` | The geometric phase diagram, diffusion, and spectra of random planar maps. | 7 | 1 / 62 | not yet reviewed |
| `212` | Planar first-passage geometry and the absence of bigeodesics. | 2 | 1 / 502 | not yet reviewed |
| `213` | Critical percolation on every quasi-transitive graph. | 2 | 1 / 83 | not yet reviewed |
| `214` | The Benjamini–Schramm nonuniqueness conjecture. | 1 | 1 / 913 | not yet reviewed |
| `215` | Canonical $`O(3)`$ continuum limit and exact $`O(4)`$ mass asymptotics. | 5 | 1 / 106 | not yet reviewed |
| `216` | Critical and near-critical XY scaling and BKT universality. | 6 | 1 / 118 | not yet reviewed |
| `217` | The low-temperature Sherrington–Kirkpatrick fluctuation law. | 2 | 1 / 98 | not yet reviewed |
| `218` | Conformal universality for weakly interacting and random-bond Ising models. | 6 | 1 / 753 | not yet reviewed |
| `219` | GOE bulk universality for regular graphs with weak Anderson disorder. | 2 | 2 / 202 | not yet reviewed |
| `220` | Directional zero–one laws beyond iid environments and iid ballisticity. | 3 | 1 / 167 | not yet reviewed |
| `221` | The Mézard–Parisi formula for diluted spin glasses. | 1 | 1 / 392 | not yet reviewed |
| `222` | Perceptron free energies and microscopic jamming exponents. | 4 | — | not yet reviewed |
| `223` | Random-cluster interfaces: critical, disordered, thermal, and natural-time scaling. | 6 | 1 / 425 | not yet reviewed |
| `224` | Critical and quenched near-critical universality for Poisson–Voronoi percolation. | 3 | 1 / 102 | not yet reviewed |
| `225` | Gaussian free field limits throughout the balanced six-vertex regime. | 1 | 1 / 33 | not yet reviewed |
| `226` | The double-dimer loop ensemble converges to CLE<sub>4</sub>. | 1 | 1 / 198 | not yet reviewed |
| `227` | Critical SK autocorrelation processes and dynamics across the temperature transition. | 8 | 1 / 106 | not yet reviewed |
| `228` | Continuum phase transitions for radial pair potentials. | 2 | 1 / 158 | not yet reviewed |
| `229` | Exact three- and four-state reconstruction thresholds and four-state tree capacity. | 3 | 1 / 108 | not yet reviewed |
| `230` | Exact Hausdorff gauges for SLE. | 2 | 1 / 106 | not yet reviewed |
| `231` | The free uniform spanning forest is a factor of IID. | 1 | 1 / 177 | not yet reviewed |
| `232` | Gaussian fields and interfaces for triangular-lattice Lipschitz heights. | 3 | — | not yet reviewed |
| `233` | The joint critical Ashkin–Teller current limit. | 1 | — | not yet reviewed |
| `234` | All-temperature pressure of orthogonally invariant Ising spin glasses. | 1 | 1 / 93 | not yet reviewed |
| `235` | Limiting random SAT thresholds, sharp variance and computability. | 4 | 1 / 97 | not yet reviewed |
| `236` | The exact factor-of-IID threshold for free Ising spins on trees. | 1 | 1 / 90 | not yet reviewed |
| `237` | The three-quarter exponent for honeycomb self-avoiding walk. | 13 | 1 / 79 | not yet reviewed |
| `238` | Optimal logarithmic mixing of the Thorp shuffle. | 12 | 1 / 78 | not yet reviewed |
| `239` | Sharp singularity rates for symmetric random sign matrices. | 2 | 1 / 100 | not yet reviewed |
| `240` | Shelah's eventual categoricity and the prescribed-threshold obstruction. | 2 | 1 / 177 | not yet reviewed |
| `241` | Rigidity of the Turing degrees. | 1 | 1 / 1,189 | not yet reviewed |
| `242` | Single-fold Diophantine representations and undecidability under an at-most-one-solution promise. | 1 | 1 / 1,635 | not yet reviewed |
| `243` | Separating choiceless counting from polynomial time and witnessed choice. | 2 | — | not yet reviewed |
| `244` | The Partition Principle does not imply Choice. | 1 | 2 / 1,482 | not yet reviewed |
| `245` | Weak normalization implies strong normalization in pure type systems. | 1 | 2 / 1,096 | not yet reviewed |
| `246` | Cannon's conjecture. | 1 | 1 / 224 | not yet reviewed |
| `247` | An infinite finitely presented residually finite 2-group and a finitely presented nil algebra. | 2 | 1 / 172 | not yet reviewed |
| `248` | Thompson's group <i>F</i> is nonamenable. | 1 | 1 / 85 | not yet reviewed |
| `249` | A finitely generated Eilenberg–Ganea counterexample. | 1 | 1 / 495 | not yet reviewed |
| `250` | Boone–Higman embeddings with higher finiteness. | 3 | 4 / 1,477 | not yet reviewed |
| `251` | Amenability, unitarizability, and strong Ulam stability. | 2 | 1 / 120 | not yet reviewed |
| `252` | A torsion-free hyperbolic group that is neither residually finite nor linear over any field. | 1 | 1 / 320 | not yet reviewed |
| `253` | An infinite finitely presented simple amenable group. | 1 | 1 / 91 | not yet reviewed |
| `254` | Classifying spaces and geometric obstructions for Artin groups. | 3 | 1 / 234 | not yet reviewed |
| `255` | Quasi-isometric recognition of virtually polycyclic groups. | 1 | — | not yet reviewed |
| `256` | Nonsingular systems of equations over arbitrary groups. | 2 | 1 / 162 | not yet reviewed |
| `257` | A hyperbolic group without a geometric CAT(0) action. | 1 | 1 / 827 | not yet reviewed |
| `258` | Gersten’s conjecture and virtual compact specialness of one-relator groups. | 2 | 1 / 117 | not yet reviewed |
| `259` | A group without fixed price. | 1 | 2 / 355 | not yet reviewed |
| `260` | Spacetime Penrose inequalities: enclosing area, charge, rotation, and anti-de Sitter extensions. | 13 | 1 / 360 | not yet reviewed |
| `261` | Localization and delocalization in the Anderson model. | 2 | 1 / 63 | not yet reviewed |
| `262` | Sharp finite-matrix Lieb–Thirring inequalities and all equality cases. | 3 | 1 / 145 | not yet reviewed |
| `263` | The ionization and generalized ionization conjectures. | 3 | — | not yet reviewed |
| `264` | Strong cosmic censorship near two-ended Kerr data. | 3 | 1 / 109 | not yet reviewed |
| `265` | Area laws and tensor networks for two-dimensional gapped systems. | 2 | 1 / 52 | not yet reviewed |
| `266` | Exactly three mutually unbiased bases in dimension six. | 2 | 1 / 85 | not yet reviewed |
| `267` | Positive-temperature Bose–Einstein condensation and exact quantum depletion. | 5 | 1 / 168 | not yet reviewed |
| `268` | The spin-one Haldane gap. | 2 | 1 / 74 | not yet reviewed |
| `269` | Uniform Laughlin gap and stability under bounded scalar disorder. | 2 | 1 / 54 | not yet reviewed |
| `270` | Threshold and positive-energy bound states of the BFSS matrix model. | 2 | — | not yet reviewed |
| `271` | Bloch's law, its lattice correction, and the spherical magnetization law. | 4 | 1 / 317 | not yet reviewed |
| `272` | Entanglement without distillable secret key. | 1 | 1 / 117 | not yet reviewed |
| `273` | The entropy photon-number inequality. | 1 | 1 / 102 | not yet reviewed |
| `274` | Parity is not in QAC<sup>0</sup>. | 2 | 1 / 82 | not yet reviewed |
| `275` | QMA-hardness of continuum Coulomb energy. | 2 | 1 / 79 | not yet reviewed |
| `276` | Classical capacity of generalized amplitude damping. | 1 | 1 / 591 | not yet reviewed |
| `277` | Threshold repetition for entangled games. | 1 | 1 / 759 | not yet reviewed |
| `278` | Failure of Kohn–Sham ensemble representation. | 1 | — | not yet reviewed |
| `279` | Exact quantum factoring over a fixed finite gate set. | 1 | 1 / 98 | not yet reviewed |
| `280` | Unitary vertex operator algebras and conformal nets. | 1 | 1 / 198 | not yet reviewed |
| `281` | QAOA attains the SK optimum in the thermodynamic-first limit. | 2 | 1 / 112 | not yet reviewed |
| `282` | From scale symmetry to local conformal symmetry in four-dimensional QFT. | 1 | — | not yet reviewed |
| `283` | Polynomial-time unitary synthesis from a Boolean oracle. | 1 | 1 / 521 | not yet reviewed |
| `284` | The optimal quartic separation between randomized and quantum queries. | 1 | 1 / 300 | not yet reviewed |
| `285` | Counterexamples to Baum–Connes and Kadison–Kaplansky. | 3 | — | not yet reviewed |
| `286` | Rigidity and arithmetic of lattice von Neumann algebras. | 2 | 1 / 74 | not yet reviewed |
| `287` | Isomorphism of the free group factors. | 1 | 1 / 81 | not yet reviewed |
| `288` | Kadison's similarity conjecture. | 1 | 1 / 205 | not yet reviewed |
| `289` | Strong Kadison–Kastler stability and its spatial boundaries. | 3 | 1 / 115 | not yet reviewed |
| `290` | Relative bicentralizers and modular spectral recovery. | 2 | 1 / 162 | not yet reviewed |
| `291` | Cuntz comparison, nuclear dimension, and equivariant Jiang–Su stability. | 4 | 1 / 139 | not yet reviewed |
| `292` | Kirchberg's $`\mathcal O_2`$ norm-ultrapower embedding problem. | 1 | — | not yet reviewed |
| `293` | Invariant projections, hyperinvariant subspaces, and transitive algebras. | 2 | 1 / 532 | not yet reviewed |
| `294` | Kaplansky's quasitrace conjecture and failure of tensor-product stable finiteness. | 1 | 1 / 9 | not yet reviewed |
| `295` | The Kadison–Ringrose cohomology conjecture. | 1 | 1 / 262 | not yet reviewed |
| `296` | The generator problem for finite factors. | 1 | 1 / 232 | not yet reviewed |
| `297` | A ZFC counterexample to Naimark's problem. | 1 | 1 / 104 | not yet reviewed |
| `298` | Two notions of free entropy differ even when both are finite. | 1 | 1 / 65 | not yet reviewed |
| `299` | The Kirchberg–Rørdam character criterion and infinite tensor-power Jiang–Su stability. | 1 | 1 / 340 | not yet reviewed |
| `300` | Approximation and quadratic strong-operator paving. | 2 | 1 / 897 | not yet reviewed |
| `301` | Trace cones and Razak–Jacelon stabilization. | 1 | 1 / 61 | not yet reviewed |
| `302` | Radius of comparison equals half the mean dimension. | 2 | 1 / 113 | not yet reviewed |
| `303` | Weak pure infiniteness and Cuntz-algebra absorption. | 1 | 1 / 150 | not yet reviewed |
| `304` | The Hilbert–Smith conjecture in every dimension. | 1 | 1 / 83 | not yet reviewed |
| `305` | Four-dimensional disk embedding and Wall's conjecture. | 3 | — | not yet reviewed |
| `306` | The purely cosmetic surgery conjecture. | 1 | 2 / 240 | not yet reviewed |
| `307` | Failure of rational injectivity for maximal coarse assembly. | 2 | 1 / 163 | not yet reviewed |
| `308` | Finite Smith–Toda complexes at every height. | 2 | 1 / 802 | not yet reviewed |
| `309` | The Kervaire invariant problem at the prime three. | 1 | — | not yet reviewed |
| `310` | Quillen's conjecture in rational homology. | 1 | 1 / 111 | not yet reviewed |
| `311` | The Hovey–Strickland and Chai conjectures. | 1 | 1 / 112 | not yet reviewed |
| `312` | The Grothendieck homotopy hypothesis. | 1 | 1 / 231 | not yet reviewed |
| `313` | Finite generation for the $`K(n)`$-local sphere. | 1 | — | not yet reviewed |
| `314` | Cyclic length and chromatic fixed-point loss. | 1 | 1 / 193 | not yet reviewed |
| `315` | The four-dimensional Singer conjecture. | 1 | 1 / 180 | not yet reviewed |
| `316` | Curtis’s conjecture. | 1 | 1 / 104 | not yet reviewed |
| `317` | Thomason model structures in all strict higher dimensions. | 1 | 1 / 134 | not yet reviewed |
| `318` | Chromatic splitting: filtrations and counterexamples. | 5 | 10 / 988 | not yet reviewed |
| `319` | Counterexamples to finite generation at chromatic height two. | 1 | — | not yet reviewed |
| `320` | Nonhomeomorphic closed aspherical four-manifolds. | 1 | 1 / 123 | not yet reviewed |
| `321` | A counterexample to Wall's finite D(2) problem. | 1 | 3 / 2,491 | not yet reviewed |
| `322` | Tingley’s sphere-isometry problem. | 1 | 1 / 593 | not yet reviewed |
| `323` | Independence of the separable quotient problem. | 1 | 2 / 243 | not yet reviewed |
| `324` | Lipschitz equivalent Banach spaces need not be linearly isomorphic. | 2 | 1 / 55 | not yet reviewed |
| `325` | The complete Crouzeix conjecture. | 2 | 1 / 292 | not yet reviewed |
| `326` | The cotype–cotype conjecture under the approximation property. | 1 | 1 / 258 | not yet reviewed |
| `327` | Markov type characterizes superreflexivity. | 1 | 4 / 102 | not yet reviewed |
| `328` | Nonexpansive fixed points in reflexive Banach spaces. | 1 | 3 / 1,549 | not yet reviewed |
| `329` | A counterexample to metric-entropy duality. | 1 | 1 / 798 | not yet reviewed |
| `330` | A uniformly discrete counterexample to bounded approximation in Lipschitz-free spaces. | 1 | 2 / 845 | not yet reviewed |
| `331` | Reflexive midpoint convexity and diamond distortion. | 7 | 1 / 108 | not yet reviewed |
| `332` | Metric Markov cotype of <i>ℓ</i><sub>1</sub> and Hilbert-space Lipschitz extension. | 1 | 1 / 156 | not yet reviewed |
| `333` | Smooth isometric immersions of surfaces into ℝ<sup>4</sup>. | 1 | 1 / 81 | not yet reviewed |
| `334` | A smooth surface metric with no local isometric immersion in ℝ<sup>3</sup>. | 1 | 1 / 70 | not yet reviewed |
| `335` | Gromov’s integral scalar-curvature bound for simplicial volume. | 2 | 1 / 139 | not yet reviewed |
| `336` | Spectral scalar curvature, Urysohn width, and macroscopic dimension. | 3 | 1 / 187 | not yet reviewed |
| `337` | Sharp Cartan–Hadamard isoperimetry and rigidity. | 2 | 1 / 60 | not yet reviewed |
| `338` | Yau's uniformization conjecture. | 1 | 1 / 73 | not yet reviewed |
| `339` | Katok's entropy rigidity conjecture. | 1 | 1 / 172 | not yet reviewed |
| `340` | A counterexample to the nearby Lagrangian conjecture. | 1 | — | not yet reviewed |
| `341` | Donaldson's hypersymplectic deformation conjecture. | 1 | 1 / 148 | not yet reviewed |
| `342` | Donaldson's tamed-to-compatible conjecture. | 1 | 1 / 112 | not yet reviewed |
| `343` | Symplectic ball packing in higher dimensions. | 1 | 1 / 34 | not yet reviewed |
| `344` | The metric Blaschke conjecture. | 1 | 1 / 25 | not yet reviewed |
| `345` | Infinitely many closed geodesics on Riemannian spheres and closed three-manifolds. | 1 | 1 / 617 | not yet reviewed |
| `346` | Sharp singular-set bounds for stationary integral varifolds. | 2 | 1 / 61 | not yet reviewed |
| `347` | Counterexamples to stable-Morse and strong Arnold fixed-point bounds. | 5 | 1 / 202 | not yet reviewed |
| `348` | Nonnegative-curvature Einstein classification and an <i>L</i><sup>2</sup> topological gap. | 3 | — | not yet reviewed |
| `349` | The Solomon–Yau least-volume conjecture. | 1 | 1 / 405 | not yet reviewed |
| `350` | Yau’s nodal bounds: surfaces and higher dimensions. | 3 | — | not yet reviewed |
| `351` | Scalar curvature and finite-time Ricci-flow singularities. | 3 | — | not yet reviewed |
| `352` | A finite-time singularity of Calabi flow. | 1 | — | not yet reviewed |
| `353` | Affine Bernstein rigidity through dimension nine and a smooth dimension-ten counterexample. | 2 | 1 / 166 | not yet reviewed |
| `354` | The isoperimetric profile of the cubic three-torus. | 1 | 1 / 124 | not yet reviewed |
| `355` | Unique tangent flows at the first surface singularity. | 1 | 1 / 190 | not yet reviewed |
| `356` | Gigli’s characterization of Alexandrov curvature. | 2 | 1 / 60 | not yet reviewed |
| `357` | Bi-Lipschitz coordinates at every regular RCD point. | 1 | — | not yet reviewed |
| `358` | A three-manifold without conjugate points or nonpositive curvature. | 1 | — | not yet reviewed |
| `359` | Negative Kähler curvature without bounded holomorphic coordinates. | 2 | 1 / 171 | not yet reviewed |
| `360` | Weak MTW curvature gives convexity and regular optimal transport. | 2 | 2 / 229 | not yet reviewed |
| `361` | Failure of integer-degree harmonic dimension comparison. | 2 | 1 / 86 | not yet reviewed |
| `362` | Global smoothness for relativistic Vlasov–Maxwell. | 1 | 1 / 110 | not yet reviewed |
| `363` | Nonuniqueness with local conservation for the hard-sphere Boltzmann equation. | 2 | 1 / 89 | not yet reviewed |
| `364` | Kinetic limits and fluctuations over the Boltzmann lifespan. | 2 | 2 / 192 | not yet reviewed |
| `365` | Joint metric and connection recovery from one boundary patch. | 3 | — | not yet reviewed |
| `366` | The planar Mumford–Shah regularity conjecture and local weak-<i>L</i><sup>4</sup> gradient bounds. | 1 | — | not yet reviewed |
| `367` | The critical dimension for the one-phase Bernoulli problem. | 1 | 1 / 58 | not yet reviewed |
| `368` | The three-dimensional Ball–Evans approximation problem. | 2 | 1 / 78 | not yet reviewed |
| `369` | The hot spots conjecture for simply connected planar domains. | 1 | 1 / 112 | not yet reviewed |
| `370` | The Lane–Emden and Hénon–Lane–Emden conjectures. | 1 | 1 / 59 | not yet reviewed |
| `371` | Stable blowup for the defocusing Schrödinger equation. | 1 | — | not yet reviewed |
| `372` | Global uniqueness in smooth isotropic elasticity. | 1 | 1 / 147 | not yet reviewed |
| `373` | Nonattainment of the three-marginal Coulomb Monge problem. | 1 | 1 / 112 | not yet reviewed |
| `374` | Sharp one-third stability of Brenier maps. | 1 | 2 / 294 | not yet reviewed |
| `375` | De Giorgi's conjecture in dimension eight. | 1 | — | not yet reviewed |
| `376` | Universal computation in forced Navier–Stokes flows. | 9 | 1 / 312 | not yet reviewed |
| `377` | Interior $`C^{1,\alpha}`$ regularity for infinity-harmonic functions. | 1 | — | not yet reviewed |
| `378` | Disproof of the Exponential Time Hypothesis. | 1 | 1 / 205 | not yet reviewed |
