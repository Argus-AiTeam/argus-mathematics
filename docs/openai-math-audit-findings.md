# Verifying the OpenAI Mathematics Collection with Argus

## Summary

- **What Argus did.** Argus ran one exploratory campaign for each of the 373 active families. Every result was then checked against OpenAI's source text, item by item. For 54 families, Argus itself carried out a second-pass review first. Every Argus draft, with caches and third-party material removed, is in [`results/openai/families/`](../results/openai/families/).
- **Improvements over OpenAI's stated results.** **134 of 373 families** contain at least one improvement that held up under verification: sharper constants or exponents, weaker hypotheses, generalizations, or optimality examples. In **55 families** the key step was checked independently, by hand, symbolically, by randomized testing or with Lean. The rest are plausible on reading. A further 72 claimed improvements turned out to be already implied by the manuscript or immaterial, and 3 did not hold.
- **Issues in OpenAI's manuscripts.** No mathematical error was found. Three minor issues stand: a wrong lemma number (`320`), a dead DOI (`318`) and a reading-dependent wording gap (`247`) (§2).
- **Lean.** There are 384 Lean 4.31.0 certificates in 314 families, about 120,000 distinct Argus-authored lines (§4).

## Headline results

| Family | Result | Status |
| :--- | :--- | :--- |
| [`318`](../results/openai/families/318/) Chromatic splitting | OpenAI leaves open whether the canonical unit in weak chromatic splitting has a retraction at height 3 ("remains a separate question", `A-rational-obstruction…/01-introduction.tex:97–98`). Combining OpenAI's two theorems (τ nonzero on π₋₃; the height-three filtration) shows that **the unit `L₂S → L₂L_{K(3)}S` has no retraction**, so weak chromatic splitting fails at height 3, p = 5. | Derivation re-checked by hand. Needs a homotopy theorist's review and a literature check. |
| [`127`](../results/openai/families/127/) Average sensitivity of PTFs | OpenAI's main theorem `I(f) ≤ 8d√n` improves to **`I(f) ≤ 4d√n`**. The coupling lemma `E(U−V)² ≤ 8aσ` becomes `≤ 4a·E|U−c|`, and the constant 4 is optimal. | Key inequality proved in a few lines and tested on 700k random cases. The general transport structure is known (Nutz–Wang 2022). |
| [`332`](../results/openai/families/332/) Metric Markov cotype of ℓ₁ | OpenAI's main theorem `N₂(ℓ₁) ≤ 12√21` improves to **`N₂(ℓ₁) ≤ 6√14`**. The flatness constant drops from 108 to 18, and 18 is optimal among dimension-free constants. | Key identity checked symbolically; 200k random cases; a sharpness family reaches 17.96. |
| [`175`](../results/openai/families/175/) Rounding | OpenAI's main constant `q_f ≤ 25·512⁴·q` improves to **`25·96⁴·q`**, about 809 times smaller. | The selector proof was checked by hand. |

## 1. Scope and cost

| | |
| :--- | :--- |
| Upstream corpus | 373 active families / 721 manuscripts at `4eaee875`; 3 withdrawn manuscripts are out of scope |
| First pass (exploratory) | 373 campaigns, about 3.21 B tokens, provider-metered **$1,861.55** |
| All OpenAI-collection work to date | about 6.27 B tokens, **$3,477.03** (as of 2026-11-09 07:21 UTC) |
| Review | Argus second-pass review of 54 families, then an item-by-item verification of all 373 families by Claude (Anthropic) |

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


## 3. Improvements over OpenAI's stated results

### 3.1 Confirmed: key step independently checked (55 items)

| Family | Paper | Improvement | How it was checked |
| :--- | :--- | :--- | :--- |
| [`010`](../results/openai/families/010/) | Unrestricted pro-modularity at the prime two. | Full primary decomposition, nilradical, nilpotence index u+1, generic multiplicity 2^r of the completed tame special fiber | Groebner bases over GF(2) (sympy, (check script)): I=(a^2+bc,bt,ct,bf+ce) equals (a^2,b,c) cap (t,F,G); at notin I, (at)^2 in I; for two places a1t1*a2t2 notin I_2 (so nilpotence index >=3=u+1). |
| [`014`](../results/openai/families/014/) | Restricted geometric Langlands, global Arthur enhancements, and generic Ramanujan. | Local step of lem:compact-conjugator without regular-nilpotent hypothesis and without coefficient extension (canonical F-rational cocharacter grading the whole r-eigenspace) | Checked by hand the decisive identity (a-r lambda)^m N = r^m N (a-lambda)^m from aN=rNa, the path/height construction (infinite order of r excludes cycles), traceless-lift scalar argument and Galois descent of height-graded sums. |
| [`015`](../results/openai/families/015/) | Torus-packet equidistribution in prime, quartic, and sextic degrees. | Theorem C: explicit family with K_h value (1-1/p)^2 p^{-c}, showing odd support exponent c sharp | Recomputed the final integral int_{a,b in Z_p^x} F_c(a-b) psi(-(a-b)/p^c) by exact finite sums mod p^c for p in {2,3,5,7}, c in {2,3}: matches (1-1/p)^2 p^{-c} exactly ((check script)). |
| [`025`](../results/openai/families/025/) | Short Egyptian fractions. | Divisor moment bound with one threshold S0(D) uniform over 1<=r<=log S/(200000 loglog S) (manuscript: fixed r, S0(D,r)); primorial obstruction at r=C log S/loglog S, C>1/2 | Baseline confirmed; read quantifier order in report (S0 chosen before r, Main.lean:1652-1718); lean_check.json status success, grep finds 0 sorry/axiom in Main.lean; checked A_k<=16(4k)^k derivation and k log(4k)<L/100 arithmetic |
| [`028`](../results/openai/families/028/) | Uniformly bounded components of Gaussian-prime graphs. | Rectangle lemma Pr <= min{1, 3 e^{-d^2 r/32}} for all r (manuscript C e^{-c d^3 r} when d^3 r>=C_0) | Hand-checked each step: Hoeffding tail with t=d log P/2, L=log 2T<=2 log T gives e^{-d^2 r/8}; det(w,w') divisible by N(c*)>=P/(2T)^h and \|det\|<=2RW forces collinearity for h<=dr/4; Doob-martingale two-set concentration mu(A)mu(B)<=e^{-s^2/r}; separated-classes aggregation b<=3max(m,e^{-s^2/2r}) with s=dr/4 gives 3e^{-d^2 r/32} |
| [`034`](../results/openai/families/034/) | Log abundance for compact Kähler spaces under logarithmic Iitaka subadditivity. | Constant (e+1)^b in nv:mixed-bound is optimal (P_{P^b}(O(1)+O^e), beta=xi+tH, t->0) | Rederived xi^{e+1}=H xi^e, w=1, B=(t+1/(e+1))H, int beta^{e+b}=sum_{i<=b} C(e+b,i)t^i; python exact check (e,b<=4) that ratio -> (e+1)^b and the inequality holds for t in a grid |
| [`035`](../results/openai/families/035/) | Log-canonical threefold abundance in numerical dimension one. | Exact affine-alternating width tail (offset stabilizes; d_{E+n+1}+d_{E+n}+c=M_E p^{n+1}; alternating K) instead of only lim d_e/M_e=p/(p+1); rank saturation for k<p lists; p=k=2 sharpness | Read manuscript proof; checked that the second swapped congruence follows from eq:residue-swap, that subtraction gives M_{e+1} \| (eps_{e+1}-eps_e) hence eventual constancy, and verified K_{n+1}=-K_n algebraically; Lean Main.lean exit 0, no sorry |
| [`039`](../results/openai/families/039/) | Nagata’s conjecture and maximal Seshadri constants. | Reshaping proposition under dw<1/3 (vs dw<1/16) with backward transfer of mixed-order max jet ranks | Checked the load-bearing fixed-three lemma: with u=(i,3), need R-3W>0 (iff dw<1/3) and an integer i not divisible by 3 in an open interval of length 3T/(1+T)>=18/7>2; area/height-range argument (l.264-275) is independent of j. Random test 2e5 (A,B,w) with dw<1/3: 0 failures. Lean fixed-three exit 0, no sorry. |
| [`048`](../results/openai/families/048/) | A characteristic-zero counterexample to Lipman–Zariski. | Upper bound p_g<=39 added to manuscript's p_g>=33, p_g=39-rank d2-rank d3-rank d4, stabilization at 5C | Recomputed: g=21, deg L=10, L^4=K_C: h^1(O_C)=21, h^1(L)=12, h^1(L^2)=3 (h^0=3, chi=0), h^1(L^3)=h^0(L)=2, h^1(L^4)=1, h^1(L^n)=0 for n>=5 (deg>40); sum 39; sequences give stabilization from 5C |
| [`049`](../results/openai/families/049/) | A stable-coordinate counterexample in four variables. | Ideal identity (t-s^2, bd-sab)=(a^2t-d^2), s=dc-abt, whenever ac-bd=1, any commutative ring, any t | Groebner-basis membership check both directions modulo ac-bd-1 over Q[a,b,c,d,t] (script (check script)); lean_check.json success, no holes |
| [`055`](../results/openai/families/055/) | Gepner symmetry and large-volume stability on threefolds. | Comparison radius 1/200000 -> 1/4000; explicit refinement radius 1/500000, support constant 3e7, sufficient range u<13/46 | Recomputed all four margins exactly at delta=1/2000, s=13/23, u<138197/500000 (539/2000, 2857/125000, 62469/11500000, 61719/6500000 >0); checked max over [1/2,13/23] of Xu's g(x)-x/2 = -13/46; checked Argus's boundary margin 3/10-u uses Xu's exact g(1/2)=-1/20 which the manuscript itself quotes (aisles.tex:45-50) before loosening to f; Lean core exit 0 no holes |
| [`066`](../results/openai/families/066/) | Bounded klt complements for Fano contractions. | Monomial sharpness family on smooth surface: loss m*q necessary; uniform o(e) fails (ratio->2) | Rechecked by hand: v_q weights (1,1+q) in (x,y-x): A=2+q, v(xy)=2, e=q, vol=1/(1+q), excess m*q, normalized ratio (2+q)->2 |
| [`068`](../results/openai/families/068/) | Anticanonical nonvanishing in every dimension. | Exact integrability chamber b_Q<min(lambda_Q,1) with endpoint sharpness family | Verified lambda_Q-a_Q=min(lambda_Q,1) and coeff_E<1 <=> a_Q+b_Q<(1+a_E)/e_E |
| [`071`](../results/openai/families/071/) | Koebe’s circle-domain conjecture. | No coefficient below 1 possible (annulus example) | Recomputed \|\|g0\|\|^2=2pi/log2 for g0=1/(Lambda r log2) and the annulus capacity 2pi/log(2+1/n) |
| [`084`](../results/openai/families/084/) | The geometric case of the Erdős similarity conjecture. | lem:conditional-scales miss probability [1+k(1+2c/q^{2r})](1-p/2)^k | Checked the monotone lifted-floor argument (distinct floor vectors <= 1+s(2)-s(1)) and that (1-p/2)^k is the manuscript's own exact test-failure value (04-routing.tex:161-165) |
| [`087`](../results/openai/families/087/) | The Mahler conjectures, functional inequalities and polar-product symplectic width. | Re F'>=2/pi on the disk, explicit eps_k in \|J_k\|/k<=(pi/4)\|g\|^{2k}+eps_k, pi/4 optimal | Monte Carlo 2e6 points + boundary sweep: min Re F'(z)=0.63662 -> 2/pi approached at \|z\|=1 |
| [`088`](../results/openai/families/088/) | Sharp projection-body inequalities and a counterexample to simplex maximization. | 2W(z)-L(z) >= (41/360)(z-1)^2/max(1,z)^{2n} replacing qualitative strictness | Implemented manuscript definitions (k,c,beta,w,d*,I,G,D) and evaluated with 60-digit precision for n=4..39,50,100,200,1000 on ~750 z values incl. near 1 and up to 2^39: min ratio 0.289 > 41/360=0.114 |
| [`097`](../results/openai/families/097/) | The Euclidean Steinitz–Bergström bound. | Gain bound (a 2^a E)^{1/a} -> (aE)^{1/a}, all 1<a<=2, no small-budget restriction; coefficient a optimal | Random test 400 contraction/gain sequences, d<=3, a in (1,2): max trH^a/(aB_a)=0.92<=1; checked psi_a(h/(1-h))=int_0^h t^{a-1}/(1-t)dt>=h^a/a and B_a<=E (same p_1) |
| [`099`](../results/openai/families/099/) | The sharp exponential scale of edit-distance distortion. | prop:family separation 24^{-s} -> 9^{-s}; recurrence Q_s -> B_s=(2P)^{2h-2}/L+B_{s-1}/h; coprime/real-l1 generalization | Re-derived a_s=mu a/(2C+mu a) from marked-payload bound 2Tdq/(d+q) with T=L,p=Cm,q=Cm; checked mu=b/2 is valid (fewer than b/2 primes divide delta => >=b/2 shifted slots, manuscript conservatively used b/3) and 1+2C/mu=9-4/b<9. |
| [`105`](../results/openai/families/105/) | Perfect completeness for 2-to-1 games. | prop:upper agreement gamma_j: remove factor 2^{-ell} | Read the manuscript proof (lines 455-610): the 2^{-ell} comes from picking one good sigma out of 2^ell characters. Checked Argus Theorem B: \|c_sigma\| <= 1_bad + 1_{good,\|c\|>=t} + t gives fraction T >= q-rho, and E[p(q-rho)]>=b then gives E T>=b; list membership for good sigma holds on all good data since slice mass >= h0/2 there. |
| [`112`](../results/openai/families/112/) | Beyond the square-root exponent for depth-three circuits. | Restriction lemma E W <= 1/(1-theta) -> E W <= 1 for theta<=1 | Hand-checked the clause-insertion mass identity: averaging over S gives q^{\|S\|}(sum_{D subset S,\|D\|>b}(p/q)^{\|D\|}-1) m_F(r_a) with p/q=2p/(1-p), so the sum is <= theta. Lean Main.lean exit 0, no holes, formalizes the actual construction. |
| [`126`](../results/openai/families/126/) | Exponential semidefinite complexity of perfect matching. | Orthogonal splitting C_L=2^{L-1} -> L/4; potential 2^t -> (9/8)^t, Fourier mass 2^{t/2} -> (9/8)^{t/2} | Implemented the recursive balanced splitting in numpy and tested (S2) on 6000 random PSD families (L=2,4,8, dimension <=6, low-rank/correlated): max ratios 0.495/0.487/0.424 against bounds 0.5/1/2. The binary constant 1/2 is attained, and the (S4) induction algebra was checked. Also checked g<=1+(L-1)/2^{L+1}<=9/8. |
| [`127`](../results/openai/families/127/) | Average sensitivity of polynomial threshold functions. | Coupling lemma 8a sigma -> 4a E\|U-c\|; I(sign p) <= 4d sqrt n instead of 8d sqrt n | Random test of E(U-V)^2 <= 4a E\|U-c\| (c=median and mean) over 2e5 equal-marginal permutation couplings: max ratio 0.833. Checked the main-theorem propagation: I<=2E(U-V)^2<=2*4*d*(sqrt n/2)=4d sqrt n. |
| [`132`](../results/openai/families/132/) | A superquadratic separation of sensitivity and block sensitivity. | Explicit bs(F_m,0) >= s(F_m)^{161/80} (exponent 2.0125) | Iterated the manuscript's recurrences (prop:recurrences) exactly with d=20, M=16*3^20, r=4*3^10, t=16, L=22: max(M S_{20,0},S_{20,1}) = 34.37 M^21 <= 36 M^21. Exact integer check B^80 >= A^161, alpha=2.01280. Manuscript d=9 alpha=2.000252. Construction itself only needs M>=3 (01-construction.tex:9). |
| [`148`](../results/openai/families/148/) | The entropy-rate dimension formula for self-similar measures. | Finite-law pair bound constant C_k=60000k^4 -> 1000k^4 | Read the Lean statement pair_bound_1000 (Main.lean:1076): k(H(nu)-H^0_rho(nu)) <= log2\|kF\| + 1000k^4 * sum_{2^-l<=2rho} c_l(nu), over arbitrary finite laws, k>=1, rho>0. Compile log: exit 0, axioms only propext/Classical.choice/Quot.sound. No sorry in the vendored OAI imports. Definitions (capacity, bands) come from OpenAI's own Lean library. |
| [`153`](../results/openai/families/153/) | Arithmetic classification and non-Pisot singularity for Bernoulli convolutions. | Singularity for quartic Salem beta extended from unbiased to arbitrary independent nonstationary biased signs | Checked the two load-bearing new steps by hand. (i) E exp(i pi u eps) = cos(pi u) + i(2p-1)sin(pi u), whose modulus^2 is >= cos^2(pi u), so the Fourier lower bound (18) is bias-uniform. (ii) Centered windows: W/B = exp(i pi sum d_l(eps_l-mu_l)) with variance 4p(1-p)<=1, so the L2 error is unchanged. The Lebesgue side is unaffected by bias. Lean (exit 0) covers the product inequality and the variance bound. |
| [`172`](../results/openai/families/172/) | Classification of finite Euclidean Ramsey configurations. | Supported-fraction inclusion strengthened from N^(s-2) to gamma_{s-1}(N), giving derived depth ceil(log2(s-1)) instead of s-2; index s-1 sharp | Checked the key step by hand. x in M with x_i=b, x_j=1 exists because the pair projection M_ij is a group containing N x N. x z^-1 x^-1 is a pair-supported actual fraction, and z(x z^-1 x^-1)=e_i([a,b]). Checked N^(r)<=gamma_{2^r}. Lean: lower_inclusion, derived_le_lower_pow and endpoint_bridge_depth compile with standard axioms only. |
| [`174`](../results/openai/families/174/) | Deterministic construction of strong thin spanning trees. | thm:extraction resistance threshold 4r^{-1/2} -> r^{-1/2}/(1-40r^{-3/16}) = (1+o(1))r^{-1/2} | Checked the key step by hand. The manuscript uses a 1/2-weight Markov split, giving 2r^{-1/2}, and then s<4r^{-1/2}. Argus uses the threshold theta=1-delta/u with delta=40r^{-1/4}, u=r^{-1/16}. Then bad edges <= delta M/(1-theta) = uM, good edges >= (1-u)M >= q(d-1), which contradicts packing-parts (iii), and R <= r^{-1/2}/theta = r^{-1/2}/(1-40r^{-3/16}). |
| [`175`](../results/openai/families/175/) | Talagrand’s expectation thresholds, discrete convexity, and graph decompositions. | Main theorem constant q_f <= 25*512^4 q improved to q_f <= 25*96^4 q (selector D=256 -> 48) | Checked the full selector proof by hand. Steps: the truncation-maximality bound d\|T\|<=m; the one-level delay contradiction giving (8); the injective encoding count; the exact likelihood identity (9); the multinomial sum giving (t^t/t!)R^t; and t^t/t! <= 3^{t-1} (numerically for t<60). Recomputed R<2/(D-2) and 2R/(1-3R)=1/10 at D=48. The rounding step only needs B=2D and P(success)>=9/10 (rounding.tex:60-120). Lean (exit 0) covers the reconstruction core. |
| [`179`](../results/openai/families/179/) | The circulant Hadamard and Barker-sequence conjectures. | lem:comparison extended to order-p^r characters with FK=p^s b, s<=e-r+1; sharp via F=p-aPhi_{p^r} | Ran a Smith normal form of multiplication by F=p-aPhi_{p^r} on Z[C_{p^e}] for (p,r,e) = (3,1,1),(3,1,2),(3,2,2),(3,2,3),(5,2,2),(3,1,3). The p-adic valuations exactly match the predicted multiplicities (1: p^e-(p-1)m, p^t: (p-2)m, p^{t+1}: m). F(zeta)/F(1)=1/(1-a) is a non-residue-1 unit. |
| [`195`](../results/openai/families/195/) | A counterexample to the small Cohen–Macaulay module conjecture. | thm:obstruction sharpened to K^2-2c_2 < 6H^2 (so <= 6h-1), and <= 3h for rank-one modules | Checked the load-bearing step: running the manuscript's elementary modification whenever width >= 1 (not only > 1). The max-slope bound mu_max(G(H)) = mu_min+1 <= mu_max(P) still holds at equality, and termination is via average slope. So width < 1, the weighted variance V <= delta^2/4 < 1/4, and the bound is K^2-2c_2 <= (3+3delta^2)h < 6h. For rank one, V=0 gives <= 3h. |
| [`205`](../results/openai/families/205/) | Saxl’s conjecture and universal tensor squares. | Single explicit integral conjugator Q=[[1,1],[1,2]] gives nonzero odd-path contraction epsilon*prod r_j! (epsilon in {±1,±3}) for every ordered column list | Exact integer computation of the pairing [X1 J X2^T J X3 ...]_{11} summed over signed segment alternations of N_i = Q M_i Q^{-1}, for all 284 ordered lists with parts in {1..4} and odd sum k <= 9. Every value is in {±1,±3} times prod r_j!, with none zero. |
| [`210`](../results/openai/families/210/) | Foulkes' conjecture for sixth powers and quadratic stabilization. | Canonical Foulkes-Howe map surjective for b >= (a-1)^2 instead of b >= a(a-1) | Checked the load-bearing step. In Step 4, whole powers (x.d_{v_i})^r are applied, and sl2 injectivity D^L on weight w >= L (proved in Main.lean, exit 0, no sorry) needs only b-(i-1)r >= r, i.e. b >= r^2. The manuscript's per-operator strict-degree argument needed m >= r^2. The induction range m = b-r >= r(r-1) >= (r-1)^2 holds. Exact rank mod 32003 at below-old-threshold cases (a,b,dimV)=(3,4,3) and (4,9,2) gives full rank 680/680 and 715/715 (surjective). |
| [`226`](../results/openai/families/226/) | The double-dimer loop ensemble converges to CLE<sub>4</sub>. | Cap weights B^{-b(A)}, B>M-1; with B=M detection constant 1/(2M^{2M}) vs (2M)^{-2(M-1)}/16 (ratio 2^{2M+1}/M^2); decay (M-1)/B | Checked the key step. Inner arches number at most M-1 because the outer loop uses at least one of the at most M eligible arches, giving decay r=(M-1)/B. An alternating sum with ratio <= r is >= (1-r) times its head, giving coefficient (1-r)^2 q^2/2. Recomputed: B=M gives 1/(2M^{2M}), the ratio to the manuscript is 2^{2M+1}/M^2, and B=2M gives (M+1)^2/(8M^2) q_M^2 >= q_M^2/16. |
| [`259`](../results/openai/families/259/) | A group without fixed price. | Planar word lemma: m(r)>=7 weakened to m(r)>=4, intervals m(r)-3 improved to m(r)-2 (optimal), injectivity H->D proved automatic; threshold 3 fails | Re-derived the (4,4)-map curvature count: face weight <=2l-4 cases, sum_inner(4-C(v))>=4, and the gap-cost classification giving t>=m(v)-2; checked Euler contradiction for automatic injectivity (4V<=2E, 4F<=2E). Python check ((check script)) of the sharpness family r0..r3, W=A0^-1A1A2^-1A3 for m=4..7: W freely reduces to 1 after substitution, relators share <=1 generator, sign-constant blocks of length exactly m-2. |
| [`260`](../results/openai/families/260/) | Spacetime Penrose inequalities: enclosing area, charge, rotation, and anti-de Sitter extensions. | prop:scalar:coercivity with explicit C_k=32+4k^2; (1+N)^2 shown necessary (k=2,v=1/4 ratio p^2/44+4p/11+21/11); stationary constants 1/16, 3 | Random test ((check script)): 200 parameter draws x 2e5 vectors of the exact quadratic form eq:scalar:quadratic (:162-167), k=2..7, p up to 1e3: form never negative, max LHS/((32+4k^2)(1+p)^2 T) = 0.041. Generalized eigenvalue computation for k=2,v=1/4 gives sup ratio 7.8187, 265.545, 23092.82 at p=10,100,1000, matching p^2/44+4p/11+21/11. |
| [`262`](../results/openai/families/262/) | Sharp finite-matrix Lieb–Thirring inequalities and all equality cases. | thm:trace deficit extended to gapless PSD symbols and without N>=0; N converges iff sigma>(m-1)/(2m), sharp via nilpotent Jordan blocks; exact asymptotic constant | Numerics ((check script), jordan2.py): for Jordan blocks n=2,3, t^{1-1/(2n)}R(t)_{11} -> 0.7071, 0.6667 = (1/n)csc(pi/(2n)) as claimed; for gapless n=2 example (V=diag(-1/4,3/4), sigma=1/2) computed N numerically: N indefinite (eigs +-0.785), tr(NV)=0.785 >= tr(N_+^3)=0.484, consistent with the extended inequality. |
| [`269`](../results/openai/families/269/) | Uniform Laughlin gap and stability under bounded scalar disorder. | prop:retained-blocks: retain all pair deficits except l=4,10,12,14 (vs only l>=23), for every c<0.04785933319001 | Replayed Argus exact-rational verifier in an isolated copy ((check script), upstream rows.txt linked read-only): recomputed certificate matches stored one; all exact PSD checks for the manuscript and selective allowances pass; consumed D={5,11,13,15} (l=4,10,12,14), gamma=4785933319001/1e14, gain 423/250000 over the companion 0.04616733319001. |
| [`285`](../results/openai/families/285/) | Counterexamples to Baum–Connes and Kadison–Kaplansky. | Diagram constants: b<=4m-6 (vs b<=6m), fillings with 8n (vs 12n) relations, avoidance (4L-2)lambda sigma(P) (vs 12(L+1)lambda sigma(P)), overlap radius 16D0+30 (vs 48D0+108) | Re-derived the Euler step by hand: v-b+F=1 and 2b>=3(v-M)+M give b<=3F+2M-3; F/lambda<=2b with lambda<=1/12 gives b>=6F; hence b<=b/2+2m-3, i.e. b<=4m-6; identity 4m-b-6 = 2(2m+3F-b-3)+(b-6F) checked algebraically. Then 2b<=8m<=8n follows exactly as in the manuscript. |
| [`298`](../results/openai/families/298/) | Two notions of free entropy differ even when both are finite. | Fisher deficit g(u) <= (4/3)K^8 p u^-5 (vs 2K^6 p^{3/2} u^-4), entropy deficit K^8 p/(6a^4); exact asymptotics | Checked the load-bearing steps. (i) Odd cumulants vanish because Y is symmetric (the manuscript's uniform p-point Y on [-1,1]). (ii) Cumulants with fewer than two Y letters vanish, giving support <= 5^m p^{(m-2)/2} and \|\|kappa_m\|\|^2 <= K^{2m}p^{(m-2)/2}. (iii) The series sum_{k>=2} u^{-2}K^{4k}p^{k-1}u^{-(2k-1)} = K^8 p u^-5/(1-K^4p/u^2) <= (4/3)K^8p u^-5 for u>2K^2 sqrt p. Recomputed by hand. Lean exit 0, no holes. |
| [`300`](../results/openai/families/300/) | Approximation and quadratic strong-operator paving. | lem:assignment pinning holds with any beta>=12 (cost 23m) instead of beta=80; non-uniform probabilities, dimension-free | Re-derived Argus's chain: tests sum b/(D0+lambda)<=2m+e+/2 with D0=8m+4a and sum b/(L+\|lambda\|)<=6m+4a; pick a color at twice the mean; side-arrow increments <=4m+e+ and <=e-+eps; diagonal shift from -(20m+12a) to -beta*a costs <=20m when beta>=12; total minus (m+e++e-) <=23m. Lean exit 0. |
| [`314`](../results/openai/families/314/) | Cyclic length and chromatic fixed-point loss. | Effective congruence D_d c_h == p^{bd} mod p^{h-b+1}, v_p(c_h)=bd for h>=b(d+1), replacing qualitative nonzero-limit contradiction | Python check ((check script)): D_d a_j(d) == 1 mod p^{j+1} for p=2,3, d=1..3, j<6. Congruence (4) and v_p(c_h)=bd for h>=b(d+1) hold for cyclic abelianization b=1,2, with s_i from Sur(Z_p^d,C_{p^i}) summing to p^{bd}. Goursat bijection (1) read and correct. Lean exit 0. |
| [`318`](../results/openai/families/318/) | Chromatic splitting: filtrations and counterexamples. | At p=5 the unit L_2 S -> L_2 L_K(3) S has no retraction (weak chromatic splitting fails at (n,p)=(3,5)) because tau is nonzero on pi_-3 | Re-derived by hand. OpenAI's filtration (The-height-three-chromatic-overlap...Sept-27, thm:main, p>=5) K(2)-localizes to a cofiber sequence R -> L_K(2)X -> Sigma^-1 R with the unit first. pi_-3 L_0 Sigma^-1 R = pi_-2 L_0 R = 0 (BSSW: degrees 0,-1,-3,-4), so tau_X(x) = L_0L_K(2)u(y) with y != 0. A retraction r gives y = L_0L_K(2)r(tau_X x) = tau_A(L_0 r x) in pi_-3 HQ_p = 0, a contradiction. |
| [`323`](../results/openai/families/323/) | Independence of the separable quotient problem. | Prescribed-weight estimate (2112/7)L/m_J improved to (1794/7)L/m_J via 2 partial blocks (6 marks instead of 8) | Verified the crop lemma: blocks successive in every order, and an intersection of convex intervals that meets S_a and S_c contains S_b, so at most 2 partial blocks. Recomputed 12+34/8+(1/8)(130/7)=130/7, 194/(7/8)+130/7=1682/7, and 1682/7+16=1794/7. |
| [`326`](../results/openai/families/326/) | The cotype–cotype conjecture under the approximation property. | Compactness constant c_* in lem:coefficient replaced by explicit \|Psi_hat(P)\| >= 2^{m^2+1}(640d+504)/(3^{m^2}-1) > (2/3)^{m^2} | Checked the mechanism. The rank<=1 part Q satisfies the same projections; \|E R(S)\| <= eps*W_N with W_N=((3/2)^N-(1/2)^N)/2; the manuscript chain then gives AB/2 <= 4D(A+B)+5KDL with K<=8+eps W_N. Recomputed: at A=B=80L the bound (AB/2-4D(A+B))/(5DL)-8 = 640d+504, increasing in A,B. 2(640d+504)/W_N = 2^{N+1}(640d+504)/(3^N-1). Lean exit 0 (parity core). |
| [`329`](../results/openai/families/329/) | A counterexample to metric-entropy duality. | Optimal dilation loss over profiles on {0..H-1} is exactly 1/k (3^{k-1}<=H<3^k); k-level compression improves the leading entropy-ratio coefficient by factor k/H | LP check ((check script)): the minimax value equals 1/k for every H=1..39. Checked the band partition j<a_{l+1}<=3j+2 <=> a_l<=j<a_{l+1}, disjointness of (3^l-1,3^{l+1}-1], and log Q ~ k s D_{H-1} log p => ratio 2Hks/(r+H-1). |
| [`331`](../results/openai/families/331/) | Reflexive midpoint convexity and diamond distortion. | Squared lens constant cannot be below 2 (exact 3-node example); manuscript proves 4 | Numerically computed dual norms on the 3-vertex tree ((check script)): \|\|x\|\|^2=16, \|\|y\|\|^2=18, \|\|x+-y\|\|^2=25, so the ratio is 18/(25-16)=2. |
| [`332`](../results/openai/families/332/) | Metric Markov cotype of <i>ℓ</i><sub>1</sub> and Hilbert-space Lipschitz extension. | N_2(l1)^2 <= 504 (vs 3024), flatness constant 18 (vs 108), 18 optimal | Sympy-verified identity 2R-DS=(B-A)^2+4(A-C)^2. Random test of the weighted flatness inequality on 2e5 cases (max ratio 15.8 < 18). Sharpness family at m=1000 gives ratio 17.96. Checked \|phi(y)-phi(x)\|<=3\|y^2-x^2\| and 18*28=504. Lean flat18 exit 0, no holes. |
| [`335`](../results/openai/families/335/) | Gromov’s integral scalar-curvature bound for simplicial volume. | Explicit cardinality-free constants (7m^2, 14m^3) in eq:entropy-BC-expansion/sharp-T plus nonperturbative reserve T >= Phi_n(m)=2[m-n(1-e^{-m/n})], sharp over rank-one ordered updates | Random test (2e4 cases, n<=5, up to 11 rank-one updates, scales 0.01-3): exact loss identity sum s_iB_i = m - m_f holds to 1e-6 and baseline 2d+2sum s_i(L_i-1) - Phi_n(m) >= -2e-16; hand-checked the AM-GM/f_n Lipschitz step |
| [`337`](../results/openai/families/337/) | Sharp Cartan–Hadamard isoperimetry and rigidity. | thm:extrinsic-sobolev extended from hypersurfaces to C^{1,1} immersions of arbitrary codimension with \|H\|^2 (mean curvature vector) | Hand-verified the load-bearing square (sec.4, eq.9-10): traced Hess u bound with tangent/normal split beta=(grad u)^perp gives m(\|H\|^2-b^2) >= mf^2+m\|H+beta\|^2+(m-2)\|grad_Sigma u\|^2+2 Delta u exactly. Checked that the balancing (sec.3) and Hersch-type argument (sec.6) use n+1 coordinates with no codimension-one input |
| [`348`](../results/openai/families/348/) | Nonnegative-curvature Einstein classification and an <i>L</i><sup>2</sup> topological gap. | Sharp spin-5/2 bound <B_F(T)Z,Z> <= (4x/5)\|Z\|^2 on G gives bracket >= (1/3+19y/12)e (manuscript: >= (7/12)(4+y-2x)e >= 0) | Built G (rank 8 Bianchi constraint, dim 12) from quaternion triples and computed max eigenvalue of the compression of B_F(T) over 2e4 random trace-free T: max ratio 0.791 < 0.8 (vs 0.989 on all of F). Algebra: (7/12)(4+y)-(5/4)(4x/5) with x<=2-y gives 1/3+19y/12 |
| [`351`](../results/openai/families/351/) | Scalar curvature and finite-time Ricci-flow singularities. | Reaction estimate c <= [2(q-1)+C_sharp]/r^2 with numerical C_sharp=8+4E (manuscript: 2(q-1)+C sqrt q) | Hand-checked the Schur/Young step: separated diagonal <= q+3, block <= D_low, coupling \|v\|^2 <= Eq; 2\|x\|\|v\|\|y\| <= 2E x^2+(q/2)\|y\|^2 is exact AM-GM, so lambda_max <= q+3+2E once q/2 >= D_low-3-2E |
| [`363`](../results/openai/families/363/) | Nonuniqueness with local conservation for the hard-sphere Boltzmann equation. | Rank-seven a.e. of ordered gain history map already with three gains (OpenAI uses five); two gains have rank <=6 everywhere; extends to all m>=3 | Python: implemented recursion (nc:rank-map) with random analytic axial profiles a_i(t,z)=c0+sin(c1 t+c2 z), finite-difference Jacobians at 200 random ordered histories: rank 6 for m=2, 7 for m=3, 7 for m=5 in every trial |
| [`374`](../results/openai/families/374/) | Sharp one-third stability of Brenier maps. | Stationary-site moment estimate constant C_0=162 improved to optimal 1 (finite two-intercept form), potential constant 2R instead of (1+sqrt162)R | Sympy: identity (4) \|ax-bz\|^2/h+2aPhi(x)+2bPhi(z)-(4ab/h)Phi((x+z)/2) = (a-b)^2R^2/h verified symbolically in R^3. Monte-Carlo 1D Laguerre cells (3000 random configs, N<=5): max ratio LHS/RHS of finite inequality (1) = 0.957 <= 1 |
| [`378`](../results/openai/families/378/) | Disproof of the Exponential Time Hypothesis. | Tapered Hermite recovery with exact smaller precision P_t=p+hB(a-i,u-i)+(m_t-1)(a+1-i) instead of p+8hL/2^i+8M(a+1) | Exhaustive exact check over a<=6, all u, h in {1,2,3}, all retained t (3132 cases): v_2(E_t(0)) = -hB(a-i,u-i) and the closed form of B(n,k) both hold. Since B<=6*2^n and m_t-1<4M, P_t <= p_t follows |

### 3.2 Plausible: baseline checked, argument read, key step not independently checked

79 further families have only plausible improvements: `007`, `013`, `017`, `018`, `022`, `026`, `033`, `037`, `042`, `046`, `047`, `050`, `056`, `060`, `063`, `072`, `074`, `076`, `078`, `079`, `081`, `085`, `093`, `107`, `108`, `113`, `122`, `141`, `146`, `149`, `152`, `164`, `166`, `184`, `190`, `197`, `202`, `204`, `209`, `211`, `215`, `217`, `219`, `221`, `225`, `227`, `228`, `230`, `231`, `232`, `236`, `238`, `239`, `251`, `257`, `261`, `264`, `265`, `274`, `275`, `289`, `304`, `307`, `313`, `315`, `319`, `321`, `330`, `333`, `347`, `350`, `352`, `358`, `359`, `364`, `370`, `373`, `376`, `377`. One with potentially large consequences is `107`, which extends the matrix-multiplication exponent 9/4 from ℂ to every field. Its positive-characteristic steps need expert review.

Every item, with its OpenAI baseline (file:line), what was checked and the verdict, is in [`data/openai-verification.json`](../data/openai-verification.json).

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
| Published in this repository | Lean sources for all families are under [`results/openai/families/`](../results/openai/families/); `156` included |

Each certificate checks a delimited core lemma, stated in its `statement_fidelity.md`. None formalizes a manuscript end to end. The raw count of 41,764 theorem declarations is dominated by 32,135 propagation-step lemmas in `156`, so it is not a useful measure.

Substantial examples (Argus-authored lines):
- `321` Fox-calculus torsion, Wall D(2): 2,029 lines
- `003` determinant / integral-norm chain: 2,796 lines
- `124` scheduling protocol extraction: 8,016 lines
- `176` Kahn–Kalai pathwise reduction: 1,814 lines
- `242` Pell and power completeness: 1,674 lines

## 5. Limitations

- **Review method.** Verification read the drafts and checked the key steps; it did not re-derive every proof. "Plausible" means no gap was found on reading.
- **Not yet done.** No human expert has reviewed these results, and novelty against the literature has not been checked.
- **Lean scope.** Lean certificates cover delimited core lemmas only.
- **Changes to the drafts.** Server paths, e-mail addresses and session identifiers were removed. As a result, some hashes recorded inside drafts refer to the original files.

## Appendix: per-family results (373 active families)

Lean figures exclude lines identical to OpenAI's upstream Lean.

| Family | Title | Manuscripts | Argus Lean (certs / authored lines) | Result | Confirmed / plausible improvements |
| :--- | :--- | :---: | :---: | :--- | :---: |
| [`001`](../results/openai/families/001/) | Milne’s rationality conjecture and algebraic specialization. | 1 | 1 / 41 | confirmation | 0 / 0 |
| [`002`](../results/openai/families/002/) | The full BSD formula from low Selmer corank. | 3 | 1 / 193 | confirmation | 0 / 0 |
| [`003`](../results/openai/families/003/) | The quasi-Riemann hypothesis. | 3 | 2 / 2,672 | confirmation | 0 / 0 |
| [`004`](../results/openai/families/004/) | Hilbert’s tenth problem over ℚ. | 2 | 2 / 245 | confirmation | 0 / 0 |
| [`005`](../results/openai/families/005/) | Irrationality of Catalan’s constant. | 1 | 1 / 104 | confirmation | 0 / 0 |
| [`006`](../results/openai/families/006/) | Goldfeld’s conjecture: densities and mean analytic rank. | 2 | 1 / 539 | confirmation | 0 / 0 |
| [`007`](../results/openai/families/007/) | Ordinary two-point correlations and the corrected Elliott conjecture. | 1 | 1 / 156 | improvement | 0 / 1 |
| [`008`](../results/openai/families/008/) | The Deligne–Drinfeld conjecture. | 1 | 1 / 38 | confirmation | 0 / 0 |
| [`009`](../results/openai/families/009/) | Function-field reconstruction from Milnor K-theory and Galois data. | 3 | 2 / 2,270 | confirmation | 0 / 0 |
| [`010`](../results/openai/families/010/) | Unrestricted pro-modularity at the prime two. | 3 | 1 / 67 | improvement | 1 / 0 |
| [`011`](../results/openai/families/011/) | Prime-factor statistics of $`p-1`$. | 3 | 2 / 173 | confirmation | 0 / 0 |
| [`012`](../results/openai/families/012/) | Independent largest prime factors of consecutive integers. | 1 | 1 / 211 | confirmation | 0 / 0 |
| [`013`](../results/openai/families/013/) | Ostmann’s inverse Goldbach conjecture. | 1 | 1 / 114 | improvement | 0 / 1 |
| [`014`](../results/openai/families/014/) | Restricted geometric Langlands, global Arthur enhancements, and generic Ramanujan. | 8 | — | improvement | 1 / 0 |
| [`015`](../results/openai/families/015/) | Torus-packet equidistribution in prime, quartic, and sextic degrees. | 3 | — | improvement | 1 / 2 |
| [`016`](../results/openai/families/016/) | Zilber–Pink in abelian varieties and the Siegel threefold. | 4 | 1 / 84 | confirmation | 0 / 0 |
| [`017`](../results/openai/families/017/) | The irrationality exponent of <i>π</i> is 2. | 1 | 1 / 157 | improvement | 0 / 1 |
| [`018`](../results/openai/families/018/) | The Margulis–Platonov conjecture over global fields. | 2 | 1 / 299 | improvement | 0 / 1 |
| [`019`](../results/openai/families/019/) | The local <i>p</i>-adic section conjecture and global consequences. | 2 | 1 / 59 | confirmation | 0 / 0 |
| [`020`](../results/openai/families/020/) | Squarefree quartics and power-free polynomial values. | 1 | 1 / 160 | confirmation | 0 / 0 |
| [`021`](../results/openai/families/021/) | A quadratic bound for Jacobsthal’s function. | 1 | 1 / 320 | confirmation | 0 / 0 |
| [`022`](../results/openai/families/022/) | The weak inhomogeneous Duffin–Schaeffer conjecture. | 1 | 1 / 460 | improvement | 0 / 1 |
| [`023`](../results/openai/families/023/) | Patterson's first moment for cubic Gauss sums. | 1 | 1 / 284 | confirmation | 0 / 0 |
| [`024`](../results/openai/families/024/) | An asymptotic formula for the number of totients. | 1 | 1 / 137 | confirmation | 0 / 0 |
| [`025`](../results/openai/families/025/) | Short Egyptian fractions. | 1 | 2 / 413 | improvement | 1 / 0 |
| [`026`](../results/openai/families/026/) | Positive lower density of large prime gaps. | 1 | 1 / 72 | improvement | 0 / 1 |
| [`027`](../results/openai/families/027/) | Potential integral density on curve character varieties. | 1 | 1 / 112 | confirmation | 0 / 0 |
| [`028`](../results/openai/families/028/) | Uniformly bounded components of Gaussian-prime graphs. | 1 | — | improvement | 1 / 0 |
| [`029`](../results/openai/families/029/) | Primitive roots for every admissible integer base. | 2 | — | confirmation | 0 / 0 |
| [`030`](../results/openai/families/030/) | Modularity of elliptic curves over imaginary quadratic fields. | 1 | 1 / 154 | confirmation | 0 / 0 |
| [`031`](../results/openai/families/031/) | Uchida’s conjecture for open homomorphisms of Galois groups. | 1 | — | confirmation | 0 / 0 |
| [`032`](../results/openai/families/032/) | The rational Hodge conjecture for CM abelian varieties. | 5 | — | confirmation | 0 / 0 |
| [`033`](../results/openai/families/033/) | Iitaka subadditivity, variation, and logarithmic additivity. | 5 | — | improvement | 0 / 2 |
| [`034`](../results/openai/families/034/) | Log abundance for compact Kähler spaces under logarithmic Iitaka subadditivity. | 14 | — | improvement | 1 / 1 |
| [`035`](../results/openai/families/035/) | Log-canonical threefold abundance in numerical dimension one. | 2 | 1 / 242 | improvement | 1 / 0 |
| [`036`](../results/openai/families/036/) | Numerical semiampleness and generalized minimal models. | 4 | 1 / 295 | confirmation | 0 / 0 |
| [`037`](../results/openai/families/037/) | The ordinary-double-point volume gap. | 2 | 1 / 54 | improvement | 0 / 1 |
| [`038`](../results/openai/families/038/) | Fujita’s freeness conjecture. | 1 | 1 / 245 | confirmation | 0 / 0 |
| [`039`](../results/openai/families/039/) | Nagata’s conjecture and maximal Seshadri constants. | 4 | 1 / 120 | improvement | 1 / 0 |
| [`040`](../results/openai/families/040/) | Bloch’s conjecture for complex surfaces. | 1 | — | confirmation | 0 / 0 |
| [`041`](../results/openai/families/041/) | Hyperkähler SYZ and projective-space bases. | 2 | 1 / 203 | confirmation | 0 / 0 |
| [`042`](../results/openai/families/042/) | Oka classification for minimal compact complex surfaces: Kodaira dimension zero and class VII. | 1 | — | improvement | 0 / 1 |
| [`043`](../results/openai/families/043/) | <i>P</i> = <i>W</i> for fixed-determinant SL<sub><i>n</i></sub> moduli spaces. | 1 | — | confirmation | 0 / 0 |
| [`044`](../results/openai/families/044/) | The equivariant cohomological Hikita conjecture. | 1 | 1 / 77 | confirmation | 0 / 0 |
| [`046`](../results/openai/families/046/) | Shafarevich counterexamples in dimension two and with large fundamental group. | 2 | 1 / 60 | improvement | 0 / 2 |
| [`047`](../results/openai/families/047/) | Zariski cancellation and affine fibrations over the complex numbers. | 1 | 1 / 155 | improvement | 0 / 1 |
| [`048`](../results/openai/families/048/) | A characteristic-zero counterexample to Lipman–Zariski. | 1 | — | improvement | 1 / 0 |
| [`049`](../results/openai/families/049/) | A stable-coordinate counterexample in four variables. | 2 | 1 / 136 | improvement | 1 / 2 |
| [`050`](../results/openai/families/050/) | A counterexample to Griffiths’ positivity conjecture. | 1 | — | improvement | 0 / 1 |
| [`051`](../results/openai/families/051/) | Kobayashi’s canonical-ampleness conjecture. | 1 | — | confirmation | 0 / 0 |
| [`052`](../results/openai/families/052/) | Tangent splittings and product decompositions. | 2 | 1 / 198 | confirmation | 0 / 0 |
| [`053`](../results/openai/families/053/) | A counterexample to Pixton completeness in Chow. | 1 | 2 / 131 | confirmation | 0 / 0 |
| [`054`](../results/openai/families/054/) | Irrational cubic fourfolds with Hodge-theoretic and categorical K3 associations. | 1 | 1 / 138 | confirmation | 0 / 0 |
| [`055`](../results/openai/families/055/) | Gepner symmetry and large-volume stability on threefolds. | 2 | 1 / 198 | improvement | 1 / 0 |
| [`056`](../results/openai/families/056/) | Termination of projective and Kähler fourfold minimal model programs. | 5 | — | improvement | 0 / 1 |
| [`057`](../results/openai/families/057/) | Fundamental groups of special complex varieties and root orbifolds. | 3 | 1 / 76 | confirmation | 0 / 0 |
| [`058`](../results/openai/families/058/) | Semialgebraic universal covers and bounded domains. | 2 | — | — | 0 / 0 |
| [`059`](../results/openai/families/059/) | Counterexamples to Zariski’s multiplicity conjecture. | 2 | — | confirmation | 0 / 0 |
| [`060`](../results/openai/families/060/) | The Global Spherical Shell conjecture. | 1 | — | improvement | 0 / 1 |
| [`062`](../results/openai/families/062/) | Projective contact classification and the LeBrun–Salamon conjecture. | 1 | 1 / 41 | confirmation | 0 / 0 |
| [`063`](../results/openai/families/063/) | The generalized Mukai conjecture. | 1 | — | improvement | 0 / 1 |
| [`064`](../results/openai/families/064/) | Topological triviality of <i>μ</i>-constant surface singularities. | 1 | — | confirmation | 0 / 0 |
| [`065`](../results/openai/families/065/) | Virasoro constraints for complete intersections and projective-bundle towers. | 2 | 1 / 77 | confirmation | 0 / 0 |
| [`066`](../results/openai/families/066/) | Bounded klt complements for Fano contractions. | 2 | 1 / 67 | improvement | 1 / 1 |
| [`067`](../results/openai/families/067/) | The Campana–Peternell conjecture in dimension six. | 1 | — | confirmation | 0 / 0 |
| [`068`](../results/openai/families/068/) | Anticanonical nonvanishing in every dimension. | 7 | 1 / 111 | improvement | 1 / 1 |
| [`069`](../results/openai/families/069/) | Global quantum geometric Langlands at irrational level. | 1 | — | — | 0 / 0 |
| [`071`](../results/openai/families/071/) | Koebe’s circle-domain conjecture. | 2 | 1 / 44 | improvement | 1 / 1 |
| [`072`](../results/openai/families/072/) | Brennan's conjecture and the integral-means spectrum. | 2 | 1 / 115 | improvement | 0 / 3 |
| [`073`](../results/openai/families/073/) | The Falconer distance conjecture. | 1 | 1 / 1,113 | confirmation | 0 / 0 |
| [`074`](../results/openai/families/074/) | Kakeya in three and four dimensions. | 2 | 1 / 97 | improvement | 0 / 1 |
| [`075`](../results/openai/families/075/) | The $`L\log L`$ Fourier-convergence conjecture. | 1 | 1 / 670 | confirmation | 0 / 0 |
| [`076`](../results/openai/families/076/) | Real ultraflat Littlewood polynomials and unbounded binary merit factors. | 3 | 1 / 120 | improvement | 0 / 1 |
| [`077`](../results/openai/families/077/) | Fourier restriction for positively curved surfaces. | 2 | — | — | 0 / 0 |
| [`078`](../results/openai/families/078/) | The three-dimensional Bochner–Riesz conjecture. | 1 | 1 / 122 | improvement | 0 / 1 |
| [`079`](../results/openai/families/079/) | Local smoothing for the Euclidean wave equation. | 2 | 1 / 97 | improvement | 0 / 1 |
| [`080`](../results/openai/families/080/) | The exact Sobolev endpoint for Schrödinger convergence. | 2 | 1 / 88 | confirmation | 0 / 0 |
| [`081`](../results/openai/families/081/) | Riesz transforms and rectifiability in higher codimension. | 1 | 1 / 66 | improvement | 0 / 1 |
| [`082`](../results/openai/families/082/) | Annular variation and dyadic absolute bounds for the triangular Hilbert transform. | 3 | 1 / 95 | confirmation | 0 / 0 |
| [`083`](../results/openai/families/083/) | Hilbert transforms along Lipschitz directions. | 1 | 1 / 181 | confirmation | 0 / 0 |
| [`084`](../results/openai/families/084/) | The geometric case of the Erdős similarity conjecture. | 2 | 1 / 774 | improvement | 1 / 0 |
| [`085`](../results/openai/families/085/) | Endpoint Sobolev regularity of centered disk averages. | 1 | 1 / 305 | improvement | 0 / 1 |
| [`086`](../results/openai/families/086/) | An <i>L</i><sup>3</sup> bound for the trilinear Hilbert transform. | 1 | 2 / 158 | confirmation | 0 / 0 |
| [`087`](../results/openai/families/087/) | The Mahler conjectures, functional inequalities and polar-product symplectic width. | 3 | 1 / 55 | improvement | 1 / 0 |
| [`088`](../results/openai/families/088/) | Sharp projection-body inequalities and a counterexample to simplex maximization. | 2 | 1 / 532 | improvement | 1 / 0 |
| [`089`](../results/openai/families/089/) | Bounded-distortion <i>L</i><sub>1</sub> embeddings of planar and bounded-treewidth graphs. | 2 | 1 / 957 | confirmation | 0 / 0 |
| [`090`](../results/openai/families/090/) | Triangular-lattice optimality, long-range Riesz and Coulomb energies, and spherical logarithmic energy. | 4 | — | confirmation | 0 / 0 |
| [`091`](../results/openai/families/091/) | Logarithmic and <i>L</i><sub><i>p</i></sub> Brunn–Minkowski inequalities and the B-conjecture. | 1 | 1 / 204 | confirmation | 0 / 0 |
| [`092`](../results/openai/families/092/) | The optimal order of convex-body covering density. | 2 | 1 / 218 | confirmation | 0 / 0 |
| [`093`](../results/openai/families/093/) | Dimension-free logarithmic Sobolev inequality for subgaussian log-concave measures. | 1 | — | improvement | 0 / 1 |
| [`094`](../results/openai/families/094/) | Subpolynomial dimension reduction in <i>L</i><sub><i>p</i></sub>. | 1 | 1 / 336 | confirmation | 0 / 0 |
| [`095`](../results/openai/families/095/) | Hyperbolicity cones without semidefinite lifts. | 3 | — | confirmation | 0 / 0 |
| [`096`](../results/openai/families/096/) | The Gaussian propeller conjecture in every dimension. | 1 | 1 / 490 | confirmation | 0 / 0 |
| [`097`](../results/openai/families/097/) | The Euclidean Steinitz–Bergström bound. | 1 | 1 / 76 | improvement | 1 / 0 |
| [`098`](../results/openai/families/098/) | Compact counterexamples to bi-Lipschitz dimension reduction. | 1 | 1 / 302 | confirmation | 0 / 0 |
| [`099`](../results/openai/families/099/) | The sharp exponential scale of edit-distance distortion. | 3 | 1 / 176 | improvement | 1 / 0 |
| [`100`](../results/openai/families/100/) | Cylinder coverings below the half-area bound. | 4 | 1 / 253 | confirmation | 0 / 0 |
| [`101`](../results/openai/families/101/) | The sharp simplex conjecture for isotropic constants. | 1 | 1 / 385 | confirmation | 0 / 0 |
| [`102`](../results/openai/families/102/) | The Unique Games Conjecture and optimal approximation thresholds. | 5 | 4 / 1,172 | confirmation | 0 / 0 |
| [`103`](../results/openai/families/103/) | Exact derandomization of logarithmic space: $`\mathsf L=\mathsf{RL}=\mathsf{BPL}`$. | 1 | 1 / 443 | confirmation | 0 / 0 |
| [`104`](../results/openai/families/104/) | Quasipolynomial algorithms for mean-payoff, stochastic and parity games. | 4 | 1 / 1,229 | confirmation | 0 / 0 |
| [`105`](../results/openai/families/105/) | Perfect completeness for 2-to-1 games. | 1 | 1 / 130 | improvement | 1 / 0 |
| [`106`](../results/openai/families/106/) | Hardness of coloring three-colorable graphs. | 1 | 4 / 594 | confirmation | 0 / 0 |
| [`107`](../results/openai/families/107/) | Matrix multiplication with exponent at most 9/4. | 3 | 1 / 96 | improvement | 0 / 1 |
| [`108`](../results/openai/families/108/) | A cubic permanent–determinant lower bound. | 1 | 1 / 209 | improvement | 0 / 1 |
| [`109`](../results/openai/families/109/) | Integer multiplication below $`n\log n`$. | 1 | 1 / 141 | confirmation | 0 / 0 |
| [`110`](../results/openai/families/110/) | Optimal-order randomized <i>k</i>-server on arbitrary metrics. | 2 | 1 / 145 | confirmation | 0 / 0 |
| [`111`](../results/openai/families/111/) | One-sample matroid prophet inequalities against an almighty adversary. | 1 | 1 / 98 | confirmation | 0 / 0 |
| [`112`](../results/openai/families/112/) | Beyond the square-root exponent for depth-three circuits. | 1 | 1 / 823 | improvement | 1 / 0 |
| [`113`](../results/openai/families/113/) | Approximate counting and entropy of perfect matchings. | 2 | 1 / 127 | improvement | 0 / 1 |
| [`114`](../results/openai/families/114/) | Approximate counting of common integer polymatroid bases. | 2 | 3 / 3,219 | confirmation | 0 / 0 |
| [`115`](../results/openai/families/115/) | Sampling and counting contingency tables with arbitrary margins. | 2 | 1 / 1,383 | confirmation | 0 / 0 |
| [`116`](../results/openai/families/116/) | Uniform black-box noncommutative identity testing across characteristics. | 3 | 2 / 1,483 | confirmation | 0 / 0 |
| [`117`](../results/openai/families/117/) | Uniform sparsest cut: hardness and semidefinite gaps. | 2 | 1 / 120 | confirmation | 0 / 0 |
| [`118`](../results/openai/families/118/) | Bin packing and unbounded configuration-LP gaps. | 1 | 1 / 712 | confirmation | 0 / 0 |
| [`119`](../results/openai/families/119/) | The Courtade–Kumar and Hellinger conjectures. | 2 | 1 / 59 | confirmation | 0 / 0 |
| [`120`](../results/openai/families/120/) | Almost-linear-time exact matching and prescribed-degree factors in general graphs. | 1 | 1 / 251 | confirmation | 0 / 0 |
| [`121`](../results/openai/families/121/) | Almost-linear approximation of edit distance. | 1 | 1 / 406 | confirmation | 0 / 0 |
| [`122`](../results/openai/families/122/) | Quantitative trace-reconstruction bounds with a uniform decoder. | 3 | 1 / 91 | improvement | 0 / 1 |
| [`124`](../results/openai/families/124/) | Polynomial-time scheduling on three identical machines. | 1 | 6 / 21,357 | confirmation | 0 / 0 |
| [`125`](../results/openai/families/125/) | The metric <i>k</i>-median approximation threshold and recovery. | 2 | 1 / 215 | confirmation | 0 / 0 |
| [`126`](../results/openai/families/126/) | Exponential semidefinite complexity of perfect matching. | 1 | 1 / 142 | improvement | 1 / 0 |
| [`127`](../results/openai/families/127/) | Average sensitivity of polynomial threshold functions. | 1 | 1 / 141 | improvement | 1 / 0 |
| [`128`](../results/openai/families/128/) | A factor-two approximation for shortest common superstring. | 1 | 1 / 706 | confirmation | 0 / 0 |
| [`129`](../results/openai/families/129/) | Exponential state costs for two-way automata. | 2 | 1 / 884 | confirmation | 0 / 0 |
| [`130`](../results/openai/families/130/) | Exact Fourier transforms below $`n\log n`$. | 2 | — | confirmation | 0 / 0 |
| [`131`](../results/openai/families/131/) | Rapid mixing of graph switches for every degree sequence. | 1 | 1 / 566 | confirmation | 0 / 0 |
| [`132`](../results/openai/families/132/) | A superquadratic separation of sensitivity and block sensitivity. | 1 | 1 / 756 | improvement | 1 / 0 |
| [`133`](../results/openai/families/133/) | The computational complexity of Weisfeiler–Leman refinement. | 4 | 2 / 2,421 | confirmation | 0 / 0 |
| [`134`](../results/openai/families/134/) | Generalized star height at most three. | 3 | 1 / 1,268 | confirmation | 0 / 0 |
| [`135`](../results/openai/families/135/) | Homogeneous depth-five lower bounds for iterated matrix multiplication. | 1 | 1 / 493 | confirmation | 0 / 0 |
| [`136`](../results/openai/families/136/) | A quasilinear PCP theorem for PPAD. | 1 | 1 / 117 | confirmation | 0 / 0 |
| [`137`](../results/openai/families/137/) | One-tape time simulation in two-fifths-power space. | 1 | 2 / 3,807 | confirmation | 0 / 0 |
| [`138`](../results/openai/families/138/) | Subset Sum in $`O(2^{0.49n})`$ time. | 2 | 1 / 46 | confirmation | 0 / 0 |
| [`139`](../results/openai/families/139/) | Subpolynomial query complexity for log-concave sampling. | 1 | 1 / 256 | confirmation | 0 / 0 |
| [`140`](../results/openai/families/140/) | Memory–sample lower bounds for noiseless Gaussian regression. | 6 | 1 / 862 | confirmation | 0 / 0 |
| [`141`](../results/openai/families/141/) | Existential–universal real sentences in the counting hierarchy. | 1 | 1 / 511 | improvement | 0 / 1 |
| [`142`](../results/openai/families/142/) | Deterministic polynomial factorization over prime fields. | 1 | 1 / 122 | confirmation | 0 / 0 |
| [`143`](../results/openai/families/143/) | Hilbert's sixteenth problem: uniform bounds for limit cycles. | 2 | 1 / 331 | confirmation | 0 / 0 |
| [`144`](../results/openai/families/144/) | Banach’s simple Lebesgue-spectrum problem. | 1 | 1 / 132 | confirmation | 0 / 0 |
| [`145`](../results/openai/families/145/) | Rokhlin’s multiple-mixing problem. | 1 | 1 / 112 | confirmation | 0 / 0 |
| [`146`](../results/openai/families/146/) | Positive metric entropy for the standard map. | 1 | 1 / 92 | improvement | 0 / 1 |
| [`147`](../results/openai/families/147/) | The near-boundary Birkhoff conjecture. | 2 | — | confirmation | 0 / 0 |
| [`148`](../results/openai/families/148/) | The entropy-rate dimension formula for self-similar measures. | 1 | 3 / 858 | improvement | 1 / 0 |
| [`149`](../results/openai/families/149/) | Classwise permanence for weakly reversible mass-action systems. | 2 | 2 / 320 | improvement | 0 / 1 |
| [`150`](../results/openai/families/150/) | Weak mixing of triangular billiards with an irrational angle. | 2 | 1 / 112 | confirmation | 0 / 0 |
| [`151`](../results/openai/families/151/) | A <i>C</i><sup>1</sup> counterexample to the entropy conjecture. | 1 | 2 / 892 | confirmation | 0 / 0 |
| [`152`](../results/openai/families/152/) | Zero entropy does not guarantee a smooth positive-volume model. | 1 | — | improvement | 0 / 1 |
| [`153`](../results/openai/families/153/) | Arithmetic classification and non-Pisot singularity for Bernoulli convolutions. | 1 | 1 / 167 | improvement | 1 / 0 |
| [`154`](../results/openai/families/154/) | Pointwise multiple ergodic averages for mixing transformations. | 4 | 1 / 202 | confirmation | 0 / 0 |
| [`155`](../results/openai/families/155/) | A counterexample to periodic tiling in dimension three. | 1 | 1 / 604 | confirmation | 0 / 0 |
| [`156`](../results/openai/families/156/) | Borsuk's conjecture fails in dimension nine. | 1 | 1 / 346,954 | confirmation | 0 / 0 |
| [`157`](../results/openai/families/157/) | Graph coloring, clique minors, and Colin de Verdière invariants. | 3 | 3 / 3,007 | confirmation | 0 / 0 |
| [`158`](../results/openai/families/158/) | The Euclidean plane cannot be colored with five colors. | 1 | 1 / 10 | confirmation | 0 / 0 |
| [`159`](../results/openai/families/159/) | Erdős’s reciprocal-sum conjecture and quasipolynomial Szemerédi bounds. | 1 | 1 / 81 | confirmation | 0 / 0 |
| [`160`](../results/openai/families/160/) | Superexponential van der Waerden numbers. | 1 | 1 / 215 | confirmation | 0 / 0 |
| [`161`](../results/openai/families/161/) | Counterexamples to Sidorenko’s conjecture and the forcing conjecture. | 1 | — | confirmation | 0 / 0 |
| [`162`](../results/openai/families/162/) | Counterexamples to Ryser’s covering conjecture. | 2 | 2 / 249 | confirmation | 0 / 0 |
| [`164`](../results/openai/families/164/) | Hindman’s finite sums and products conjecture. | 1 | 1 / 107 | improvement | 0 / 1 |
| [`165`](../results/openai/families/165/) | The Harary–Hill and Zarankiewicz crossing-number formulas. | 2 | 1 / 236 | confirmation | 0 / 0 |
| [`166`](../results/openai/families/166/) | The higher-dimensional Erdős distinct-distances conjecture. | 1 | 1 / 42 | improvement | 0 / 1 |
| [`167`](../results/openai/families/167/) | Planar distinct distances and unit-distance bounds. | 2 | 1 / 221 | confirmation | 0 / 0 |
| [`168`](../results/openai/families/168/) | Combinatorial invariance of Kazhdan–Lusztig polynomials. | 1 | 1 / 85 | — | 0 / 0 |
| [`169`](../results/openai/families/169/) | Shareshian–Wachs elementary positivity. | 1 | 1 / 53 | confirmation | 0 / 0 |
| [`170`](../results/openai/families/170/) | Sharp logarithmic exponents for off-diagonal Ramsey numbers. | 2 | 1 / 89 | confirmation | 0 / 0 |
| [`171`](../results/openai/families/171/) | The hypercube Ramsey conjecture. | 1 | 1 / 83 | confirmation | 0 / 0 |
| [`172`](../results/openai/families/172/) | Classification of finite Euclidean Ramsey configurations. | 1 | 2 / 1,347 | improvement | 1 / 0 |
| [`173`](../results/openai/families/173/) | Seymour’s second-neighborhood conjecture. | 1 | 1 / 245 | confirmation | 0 / 0 |
| [`174`](../results/openai/families/174/) | Deterministic construction of strong thin spanning trees. | 2 | 2 / 451 | improvement | 1 / 0 |
| [`175`](../results/openai/families/175/) | Talagrand’s expectation thresholds, discrete convexity, and graph decompositions. | 3 | 1 / 519 | improvement | 1 / 0 |
| [`176`](../results/openai/families/176/) | The second Kahn–Kalai conjecture with an edge-count bound. | 1 | 1 / 1,723 | confirmation | 0 / 0 |
| [`177`](../results/openai/families/177/) | Bounded-degree coboundary expanders. | 1 | 1 / 141 | confirmation | 0 / 0 |
| [`178`](../results/openai/families/178/) | Deterministic nonbipartite Ramanujan graphs in every fixed degree. | 1 | 1 / 45 | confirmation | 0 / 0 |
| [`179`](../results/openai/families/179/) | The circulant Hadamard and Barker-sequence conjectures. | 1 | 3 / 294 | improvement | 1 / 0 |
| [`180`](../results/openai/families/180/) | Barnette’s Hamiltonian-cycle conjecture. | 1 | 1 / 170 | confirmation | 0 / 0 |
| [`181`](../results/openai/families/181/) | The Erdős–Gallai cycle-decomposition conjecture. | 1 | 1 / 530 | confirmation | 0 / 0 |
| [`182`](../results/openai/families/182/) | Power savings for intersective polynomial differences and prime arguments. | 3 | 1 / 206 | confirmation | 0 / 0 |
| [`183`](../results/openai/families/183/) | Power savings for planar halving lines and <i>k</i>-sets. | 1 | 1 / 1,582 | confirmation | 0 / 0 |
| [`184`](../results/openai/families/184/) | Correspondence coloring with a fixed forbidden subgraph. | 2 | 1 / 123 | improvement | 0 / 1 |
| [`185`](../results/openai/families/185/) | Counterexamples to infinite matroid intersection and packing/covering. | 1 | 2 / 547 | confirmation | 0 / 0 |
| [`186`](../results/openai/families/186/) | Uniform influence and sharp thresholds for graph and hypergraph properties. | 2 | 2 / 384 | confirmation | 0 / 0 |
| [`187`](../results/openai/families/187/) | Snaky in 21 Maker moves. | 1 | 1 / 1,341 | confirmation | 0 / 0 |
| [`188`](../results/openai/families/188/) | The sharp terminal leave in random triangle removal. | 1 | 1 / 102 | — | 0 / 0 |
| [`189`](../results/openai/families/189/) | Cycle–clique Ramsey numbers. | 1 | 2 / 265 | confirmation | 0 / 0 |
| [`190`](../results/openai/families/190/) | Polynomial removal fails for ordered binary matrices. | 1 | 1 / 162 | improvement | 0 / 1 |
| [`191`](../results/openai/families/191/) | A power improvement in the Heilbronn triangle lower bound. | 1 | 1 / 387 | confirmation | 0 / 0 |
| [`192`](../results/openai/families/192/) | Boolean functions violate the square-root degree bound by arbitrary factors. | 1 | 1 / 120 | confirmation | 0 / 0 |
| [`193`](../results/openai/families/193/) | Serre’s intersection-multiplicity conjecture. | 1 | 1 / 68 | confirmation | 0 / 0 |
| [`194`](../results/openai/families/194/) | Lech’s multiplicity conjecture. | 1 | 1 / 93 | confirmation | 0 / 0 |
| [`195`](../results/openai/families/195/) | A counterexample to the small Cohen–Macaulay module conjecture. | 1 | 2 / 201 | improvement | 1 / 0 |
| [`196`](../results/openai/families/196/) | A counterexample to Kaplansky’s zero-divisor conjecture. | 1 | 2 / 459 | confirmation | 0 / 0 |
| [`197`](../results/openai/families/197/) | A torsion-free group algebra that is not directly finite. | 4 | 1 / 101 | improvement | 0 / 1 |
| [`198`](../results/openai/families/198/) | A counterexample to finitistic-dimension finiteness. | 1 | 1 / 1,543 | confirmation | 0 / 0 |
| [`199`](../results/openai/families/199/) | Counterexamples to Auslander–Reiten, Tachikawa and related homological conjectures. | 2 | 1 / 142 | confirmation | 0 / 0 |
| [`200`](../results/openai/families/200/) | Eisenbud–Green–Harris and lex-plus-powers. | 2 | 1 / 62 | confirmation | 0 / 0 |
| [`201`](../results/openai/families/201/) | A counterexample to Kurosh’s division-ring problem. | 1 | 3 / 360 | confirmation | 0 / 0 |
| [`202`](../results/openai/families/202/) | The blockwise Alperin weight conjecture. | 1 | 1 / 102 | improvement | 0 / 1 |
| [`203`](../results/openai/families/203/) | Donovan's conjecture over fields and complete mixed-characteristic DVRs. | 2 | — | confirmation | 0 / 0 |
| [`204`](../results/openai/families/204/) | Tensor saturation for even spin groups. | 1 | 1 / 162 | improvement | 0 / 1 |
| [`205`](../results/openai/families/205/) | Saxl’s conjecture and universal tensor squares. | 2 | 1 / 305 | improvement | 1 / 0 |
| [`206`](../results/openai/families/206/) | Finite lattice representation and undecidability. | 2 | 1 / 152 | confirmation | 0 / 0 |
| [`207`](../results/openai/families/207/) | The ℓ¹-Bass conjecture for all discrete groups. | 2 | 1 / 141 | confirmation | 0 / 0 |
| [`208`](../results/openai/families/208/) | Finite symmetric tensor categories and the Verlinde tower. | 1 | 1 / 221 | confirmation | 0 / 0 |
| [`209`](../results/openai/families/209/) | Integral counterexamples to Gersten’s conjecture. | 2 | — | improvement | 0 / 1 |
| [`210`](../results/openai/families/210/) | Foulkes' conjecture for sixth powers and quadratic stabilization. | 2 | 1 / 118 | improvement | 1 / 0 |
| [`211`](../results/openai/families/211/) | The geometric phase diagram, diffusion, and spectra of random planar maps. | 7 | 1 / 62 | improvement | 0 / 1 |
| [`212`](../results/openai/families/212/) | Planar first-passage geometry and the absence of bigeodesics. | 2 | 1 / 502 | confirmation | 0 / 0 |
| [`213`](../results/openai/families/213/) | Critical percolation on every quasi-transitive graph. | 2 | 1 / 83 | confirmation | 0 / 0 |
| [`214`](../results/openai/families/214/) | The Benjamini–Schramm nonuniqueness conjecture. | 1 | 1 / 913 | confirmation | 0 / 0 |
| [`215`](../results/openai/families/215/) | Canonical $`O(3)`$ continuum limit and exact $`O(4)`$ mass asymptotics. | 5 | 1 / 106 | improvement | 0 / 1 |
| [`216`](../results/openai/families/216/) | Critical and near-critical XY scaling and BKT universality. | 6 | 1 / 118 | confirmation | 0 / 0 |
| [`217`](../results/openai/families/217/) | The low-temperature Sherrington–Kirkpatrick fluctuation law. | 2 | 1 / 98 | improvement | 0 / 1 |
| [`218`](../results/openai/families/218/) | Conformal universality for weakly interacting and random-bond Ising models. | 6 | 1 / 753 | confirmation | 0 / 0 |
| [`219`](../results/openai/families/219/) | GOE bulk universality for regular graphs with weak Anderson disorder. | 2 | 2 / 202 | improvement | 0 / 1 |
| [`220`](../results/openai/families/220/) | Directional zero–one laws beyond iid environments and iid ballisticity. | 3 | 1 / 167 | confirmation | 0 / 0 |
| [`221`](../results/openai/families/221/) | The Mézard–Parisi formula for diluted spin glasses. | 1 | 1 / 392 | improvement | 0 / 1 |
| [`222`](../results/openai/families/222/) | Perceptron free energies and microscopic jamming exponents. | 4 | — | confirmation | 0 / 0 |
| [`223`](../results/openai/families/223/) | Random-cluster interfaces: critical, disordered, thermal, and natural-time scaling. | 6 | 1 / 425 | confirmation | 0 / 0 |
| [`224`](../results/openai/families/224/) | Critical and quenched near-critical universality for Poisson–Voronoi percolation. | 3 | 1 / 102 | — | 0 / 0 |
| [`225`](../results/openai/families/225/) | Gaussian free field limits throughout the balanced six-vertex regime. | 1 | 1 / 33 | improvement | 0 / 1 |
| [`226`](../results/openai/families/226/) | The double-dimer loop ensemble converges to CLE<sub>4</sub>. | 1 | 1 / 198 | improvement | 1 / 0 |
| [`227`](../results/openai/families/227/) | Critical SK autocorrelation processes and dynamics across the temperature transition. | 8 | 1 / 106 | improvement | 0 / 1 |
| [`228`](../results/openai/families/228/) | Continuum phase transitions for radial pair potentials. | 2 | 1 / 158 | improvement | 0 / 1 |
| [`229`](../results/openai/families/229/) | Exact three- and four-state reconstruction thresholds and four-state tree capacity. | 3 | 1 / 108 | confirmation | 0 / 0 |
| [`230`](../results/openai/families/230/) | Exact Hausdorff gauges for SLE. | 2 | 1 / 106 | improvement | 0 / 1 |
| [`231`](../results/openai/families/231/) | The free uniform spanning forest is a factor of IID. | 1 | 1 / 177 | improvement | 0 / 1 |
| [`232`](../results/openai/families/232/) | Gaussian fields and interfaces for triangular-lattice Lipschitz heights. | 3 | — | improvement | 0 / 1 |
| [`233`](../results/openai/families/233/) | The joint critical Ashkin–Teller current limit. | 1 | — | confirmation | 0 / 0 |
| [`234`](../results/openai/families/234/) | All-temperature pressure of orthogonally invariant Ising spin glasses. | 1 | 1 / 93 | confirmation | 0 / 0 |
| [`235`](../results/openai/families/235/) | Limiting random SAT thresholds, sharp variance and computability. | 4 | 1 / 97 | confirmation | 0 / 0 |
| [`236`](../results/openai/families/236/) | The exact factor-of-IID threshold for free Ising spins on trees. | 1 | 1 / 90 | improvement | 0 / 1 |
| [`237`](../results/openai/families/237/) | The three-quarter exponent for honeycomb self-avoiding walk. | 13 | 1 / 79 | confirmation | 0 / 0 |
| [`238`](../results/openai/families/238/) | Optimal logarithmic mixing of the Thorp shuffle. | 12 | 1 / 78 | improvement | 0 / 1 |
| [`239`](../results/openai/families/239/) | Sharp singularity rates for symmetric random sign matrices. | 2 | 1 / 100 | improvement | 0 / 1 |
| [`240`](../results/openai/families/240/) | Shelah's eventual categoricity and the prescribed-threshold obstruction. | 2 | 1 / 177 | confirmation | 0 / 0 |
| [`241`](../results/openai/families/241/) | Rigidity of the Turing degrees. | 1 | 1 / 1,189 | confirmation | 0 / 0 |
| [`242`](../results/openai/families/242/) | Single-fold Diophantine representations and undecidability under an at-most-one-solution promise. | 1 | 1 / 1,635 | confirmation | 0 / 0 |
| [`243`](../results/openai/families/243/) | Separating choiceless counting from polynomial time and witnessed choice. | 2 | — | confirmation | 0 / 0 |
| [`244`](../results/openai/families/244/) | The Partition Principle does not imply Choice. | 1 | 2 / 1,482 | confirmation | 0 / 0 |
| [`245`](../results/openai/families/245/) | Weak normalization implies strong normalization in pure type systems. | 1 | 2 / 1,096 | confirmation | 0 / 0 |
| [`246`](../results/openai/families/246/) | Cannon's conjecture. | 1 | 1 / 224 | confirmation | 0 / 0 |
| [`247`](../results/openai/families/247/) | An infinite finitely presented residually finite 2-group and a finitely presented nil algebra. | 2 | 1 / 172 | manuscript issue | 0 / 0 |
| [`248`](../results/openai/families/248/) | Thompson's group <i>F</i> is nonamenable. | 1 | 1 / 85 | confirmation | 0 / 0 |
| [`249`](../results/openai/families/249/) | A finitely generated Eilenberg–Ganea counterexample. | 1 | 1 / 495 | confirmation | 0 / 0 |
| [`250`](../results/openai/families/250/) | Boone–Higman embeddings with higher finiteness. | 3 | 4 / 1,477 | confirmation | 0 / 0 |
| [`251`](../results/openai/families/251/) | Amenability, unitarizability, and strong Ulam stability. | 2 | 1 / 120 | improvement | 0 / 1 |
| [`252`](../results/openai/families/252/) | A torsion-free hyperbolic group that is neither residually finite nor linear over any field. | 1 | 1 / 320 | confirmation | 0 / 0 |
| [`253`](../results/openai/families/253/) | An infinite finitely presented simple amenable group. | 1 | 1 / 91 | confirmation | 0 / 0 |
| [`254`](../results/openai/families/254/) | Classifying spaces and geometric obstructions for Artin groups. | 3 | 1 / 234 | confirmation | 0 / 0 |
| [`255`](../results/openai/families/255/) | Quasi-isometric recognition of virtually polycyclic groups. | 1 | — | — | 0 / 0 |
| [`256`](../results/openai/families/256/) | Nonsingular systems of equations over arbitrary groups. | 2 | 1 / 162 | confirmation | 0 / 0 |
| [`257`](../results/openai/families/257/) | A hyperbolic group without a geometric CAT(0) action. | 1 | 1 / 827 | improvement | 0 / 1 |
| [`258`](../results/openai/families/258/) | Gersten’s conjecture and virtual compact specialness of one-relator groups. | 2 | 1 / 117 | confirmation | 0 / 0 |
| [`259`](../results/openai/families/259/) | A group without fixed price. | 1 | 2 / 355 | improvement | 1 / 0 |
| [`260`](../results/openai/families/260/) | Spacetime Penrose inequalities: enclosing area, charge, rotation, and anti-de Sitter extensions. | 13 | 1 / 360 | improvement | 1 / 0 |
| [`261`](../results/openai/families/261/) | Localization and delocalization in the Anderson model. | 2 | 1 / 63 | improvement | 0 / 1 |
| [`262`](../results/openai/families/262/) | Sharp finite-matrix Lieb–Thirring inequalities and all equality cases. | 3 | 1 / 145 | improvement | 1 / 0 |
| [`263`](../results/openai/families/263/) | The ionization and generalized ionization conjectures. | 3 | — | confirmation | 0 / 0 |
| [`264`](../results/openai/families/264/) | Strong cosmic censorship near two-ended Kerr data. | 3 | 1 / 109 | improvement | 0 / 1 |
| [`265`](../results/openai/families/265/) | Area laws and tensor networks for two-dimensional gapped systems. | 2 | 1 / 52 | improvement | 0 / 1 |
| [`266`](../results/openai/families/266/) | Exactly three mutually unbiased bases in dimension six. | 2 | 1 / 85 | confirmation | 0 / 0 |
| [`267`](../results/openai/families/267/) | Positive-temperature Bose–Einstein condensation and exact quantum depletion. | 5 | 1 / 168 | confirmation | 0 / 0 |
| [`268`](../results/openai/families/268/) | The spin-one Haldane gap. | 2 | 1 / 74 | confirmation | 0 / 0 |
| [`269`](../results/openai/families/269/) | Uniform Laughlin gap and stability under bounded scalar disorder. | 2 | 1 / 54 | improvement | 1 / 0 |
| [`270`](../results/openai/families/270/) | Threshold and positive-energy bound states of the BFSS matrix model. | 2 | — | confirmation | 0 / 0 |
| [`271`](../results/openai/families/271/) | Bloch's law, its lattice correction, and the spherical magnetization law. | 4 | 1 / 317 | confirmation | 0 / 0 |
| [`272`](../results/openai/families/272/) | Entanglement without distillable secret key. | 1 | 1 / 117 | confirmation | 0 / 0 |
| [`273`](../results/openai/families/273/) | The entropy photon-number inequality. | 1 | 1 / 102 | confirmation | 0 / 0 |
| [`274`](../results/openai/families/274/) | Parity is not in QAC<sup>0</sup>. | 2 | 1 / 82 | improvement | 0 / 1 |
| [`275`](../results/openai/families/275/) | QMA-hardness of continuum Coulomb energy. | 2 | 1 / 79 | improvement | 0 / 1 |
| [`276`](../results/openai/families/276/) | Classical capacity of generalized amplitude damping. | 1 | 1 / 591 | confirmation | 0 / 0 |
| [`277`](../results/openai/families/277/) | Threshold repetition for entangled games. | 1 | 1 / 759 | confirmation | 0 / 0 |
| [`278`](../results/openai/families/278/) | Failure of Kohn–Sham ensemble representation. | 1 | — | confirmation | 0 / 0 |
| [`279`](../results/openai/families/279/) | Exact quantum factoring over a fixed finite gate set. | 1 | 1 / 98 | confirmation | 0 / 0 |
| [`280`](../results/openai/families/280/) | Unitary vertex operator algebras and conformal nets. | 1 | 1 / 198 | confirmation | 0 / 0 |
| [`281`](../results/openai/families/281/) | QAOA attains the SK optimum in the thermodynamic-first limit. | 2 | 1 / 112 | — | 0 / 0 |
| [`282`](../results/openai/families/282/) | From scale symmetry to local conformal symmetry in four-dimensional QFT. | 1 | — | confirmation | 0 / 0 |
| [`283`](../results/openai/families/283/) | Polynomial-time unitary synthesis from a Boolean oracle. | 1 | 1 / 521 | confirmation | 0 / 0 |
| [`284`](../results/openai/families/284/) | The optimal quartic separation between randomized and quantum queries. | 1 | 1 / 300 | confirmation | 0 / 0 |
| [`285`](../results/openai/families/285/) | Counterexamples to Baum–Connes and Kadison–Kaplansky. | 3 | — | improvement | 1 / 0 |
| [`286`](../results/openai/families/286/) | Rigidity and arithmetic of lattice von Neumann algebras. | 2 | 1 / 74 | confirmation | 0 / 0 |
| [`287`](../results/openai/families/287/) | Isomorphism of the free group factors. | 1 | 1 / 81 | confirmation | 0 / 0 |
| [`288`](../results/openai/families/288/) | Kadison's similarity conjecture. | 1 | 1 / 205 | confirmation | 0 / 0 |
| [`289`](../results/openai/families/289/) | Strong Kadison–Kastler stability and its spatial boundaries. | 3 | 1 / 115 | improvement | 0 / 1 |
| [`290`](../results/openai/families/290/) | Relative bicentralizers and modular spectral recovery. | 2 | 1 / 162 | confirmation | 0 / 0 |
| [`291`](../results/openai/families/291/) | Cuntz comparison, nuclear dimension, and equivariant Jiang–Su stability. | 4 | 1 / 139 | confirmation | 0 / 0 |
| [`292`](../results/openai/families/292/) | Kirchberg's $`\mathcal O_2`$ norm-ultrapower embedding problem. | 1 | — | confirmation | 0 / 0 |
| [`293`](../results/openai/families/293/) | Invariant projections, hyperinvariant subspaces, and transitive algebras. | 2 | 1 / 532 | confirmation | 0 / 0 |
| [`294`](../results/openai/families/294/) | Kaplansky's quasitrace conjecture and failure of tensor-product stable finiteness. | 1 | 1 / 9 | confirmation | 0 / 0 |
| [`295`](../results/openai/families/295/) | The Kadison–Ringrose cohomology conjecture. | 1 | 1 / 262 | confirmation | 0 / 0 |
| [`296`](../results/openai/families/296/) | The generator problem for finite factors. | 1 | 1 / 232 | confirmation | 0 / 0 |
| [`297`](../results/openai/families/297/) | A ZFC counterexample to Naimark's problem. | 1 | 1 / 104 | confirmation | 0 / 0 |
| [`298`](../results/openai/families/298/) | Two notions of free entropy differ even when both are finite. | 1 | 1 / 65 | improvement | 1 / 0 |
| [`299`](../results/openai/families/299/) | The Kirchberg–Rørdam character criterion and infinite tensor-power Jiang–Su stability. | 1 | 1 / 340 | confirmation | 0 / 0 |
| [`300`](../results/openai/families/300/) | Approximation and quadratic strong-operator paving. | 2 | 1 / 897 | improvement | 1 / 0 |
| [`301`](../results/openai/families/301/) | Trace cones and Razak–Jacelon stabilization. | 1 | 1 / 61 | confirmation | 0 / 0 |
| [`302`](../results/openai/families/302/) | Radius of comparison equals half the mean dimension. | 2 | 1 / 113 | confirmation | 0 / 0 |
| [`303`](../results/openai/families/303/) | Weak pure infiniteness and Cuntz-algebra absorption. | 1 | 1 / 150 | confirmation | 0 / 0 |
| [`304`](../results/openai/families/304/) | The Hilbert–Smith conjecture in every dimension. | 1 | 1 / 83 | improvement | 0 / 1 |
| [`305`](../results/openai/families/305/) | Four-dimensional disk embedding and Wall's conjecture. | 3 | — | confirmation | 0 / 0 |
| [`306`](../results/openai/families/306/) | The purely cosmetic surgery conjecture. | 1 | 2 / 240 | confirmation | 0 / 0 |
| [`307`](../results/openai/families/307/) | Failure of rational injectivity for maximal coarse assembly. | 2 | 1 / 163 | improvement | 0 / 1 |
| [`308`](../results/openai/families/308/) | Finite Smith–Toda complexes at every height. | 2 | 1 / 802 | confirmation | 0 / 0 |
| [`309`](../results/openai/families/309/) | The Kervaire invariant problem at the prime three. | 1 | — | confirmation | 0 / 0 |
| [`310`](../results/openai/families/310/) | Quillen's conjecture in rational homology. | 1 | 1 / 111 | confirmation | 0 / 0 |
| [`311`](../results/openai/families/311/) | The Hovey–Strickland and Chai conjectures. | 1 | 1 / 112 | confirmation | 0 / 0 |
| [`312`](../results/openai/families/312/) | The Grothendieck homotopy hypothesis. | 1 | 1 / 231 | confirmation | 0 / 0 |
| [`313`](../results/openai/families/313/) | Finite generation for the $`K(n)`$-local sphere. | 1 | — | improvement | 0 / 1 |
| [`314`](../results/openai/families/314/) | Cyclic length and chromatic fixed-point loss. | 1 | 1 / 193 | improvement | 1 / 0 |
| [`315`](../results/openai/families/315/) | The four-dimensional Singer conjecture. | 1 | 1 / 180 | improvement | 0 / 1 |
| [`316`](../results/openai/families/316/) | Curtis’s conjecture. | 1 | 1 / 104 | confirmation | 0 / 0 |
| [`317`](../results/openai/families/317/) | Thomason model structures in all strict higher dimensions. | 1 | 1 / 134 | confirmation | 0 / 0 |
| [`318`](../results/openai/families/318/) | Chromatic splitting: filtrations and counterexamples. | 5 | 10 / 988 | improvement | 1 / 0 |
| [`319`](../results/openai/families/319/) | Counterexamples to finite generation at chromatic height two. | 1 | — | improvement | 0 / 1 |
| [`320`](../results/openai/families/320/) | Nonhomeomorphic closed aspherical four-manifolds. | 1 | 1 / 123 | manuscript issue | 0 / 0 |
| [`321`](../results/openai/families/321/) | A counterexample to Wall's finite D(2) problem. | 1 | 3 / 2,491 | improvement | 0 / 2 |
| [`322`](../results/openai/families/322/) | Tingley’s sphere-isometry problem. | 1 | 1 / 593 | confirmation | 0 / 0 |
| [`323`](../results/openai/families/323/) | Independence of the separable quotient problem. | 1 | 2 / 243 | improvement | 1 / 0 |
| [`324`](../results/openai/families/324/) | Lipschitz equivalent Banach spaces need not be linearly isomorphic. | 2 | 1 / 55 | confirmation | 0 / 0 |
| [`325`](../results/openai/families/325/) | The complete Crouzeix conjecture. | 2 | 1 / 292 | confirmation | 0 / 0 |
| [`326`](../results/openai/families/326/) | The cotype–cotype conjecture under the approximation property. | 1 | 1 / 258 | improvement | 1 / 0 |
| [`327`](../results/openai/families/327/) | Markov type characterizes superreflexivity. | 1 | 4 / 102 | confirmation | 0 / 0 |
| [`328`](../results/openai/families/328/) | Nonexpansive fixed points in reflexive Banach spaces. | 1 | 3 / 1,549 | confirmation | 0 / 0 |
| [`329`](../results/openai/families/329/) | A counterexample to metric-entropy duality. | 1 | 1 / 798 | improvement | 1 / 0 |
| [`330`](../results/openai/families/330/) | A uniformly discrete counterexample to bounded approximation in Lipschitz-free spaces. | 1 | 2 / 845 | improvement | 0 / 1 |
| [`331`](../results/openai/families/331/) | Reflexive midpoint convexity and diamond distortion. | 7 | 1 / 108 | improvement | 1 / 0 |
| [`332`](../results/openai/families/332/) | Metric Markov cotype of <i>ℓ</i><sub>1</sub> and Hilbert-space Lipschitz extension. | 1 | 1 / 156 | improvement | 1 / 0 |
| [`333`](../results/openai/families/333/) | Smooth isometric immersions of surfaces into ℝ<sup>4</sup>. | 1 | 1 / 81 | improvement | 0 / 1 |
| [`334`](../results/openai/families/334/) | A smooth surface metric with no local isometric immersion in ℝ<sup>3</sup>. | 1 | 1 / 70 | confirmation | 0 / 0 |
| [`335`](../results/openai/families/335/) | Gromov’s integral scalar-curvature bound for simplicial volume. | 2 | 1 / 139 | improvement | 1 / 0 |
| [`336`](../results/openai/families/336/) | Spectral scalar curvature, Urysohn width, and macroscopic dimension. | 3 | 1 / 187 | confirmation | 0 / 0 |
| [`337`](../results/openai/families/337/) | Sharp Cartan–Hadamard isoperimetry and rigidity. | 2 | 1 / 60 | improvement | 1 / 0 |
| [`338`](../results/openai/families/338/) | Yau's uniformization conjecture. | 1 | 1 / 73 | confirmation | 0 / 0 |
| [`339`](../results/openai/families/339/) | Katok's entropy rigidity conjecture. | 1 | 1 / 172 | confirmation | 0 / 0 |
| [`340`](../results/openai/families/340/) | A counterexample to the nearby Lagrangian conjecture. | 1 | — | confirmation | 0 / 0 |
| [`341`](../results/openai/families/341/) | Donaldson's hypersymplectic deformation conjecture. | 1 | 1 / 148 | confirmation | 0 / 0 |
| [`342`](../results/openai/families/342/) | Donaldson's tamed-to-compatible conjecture. | 1 | 1 / 112 | confirmation | 0 / 0 |
| [`343`](../results/openai/families/343/) | Symplectic ball packing in higher dimensions. | 1 | 1 / 34 | confirmation | 0 / 0 |
| [`344`](../results/openai/families/344/) | The metric Blaschke conjecture. | 1 | 1 / 25 | confirmation | 0 / 0 |
| [`345`](../results/openai/families/345/) | Infinitely many closed geodesics on Riemannian spheres and closed three-manifolds. | 1 | 1 / 617 | confirmation | 0 / 0 |
| [`346`](../results/openai/families/346/) | Sharp singular-set bounds for stationary integral varifolds. | 2 | 1 / 61 | confirmation | 0 / 0 |
| [`347`](../results/openai/families/347/) | Counterexamples to stable-Morse and strong Arnold fixed-point bounds. | 5 | 1 / 202 | improvement | 0 / 1 |
| [`348`](../results/openai/families/348/) | Nonnegative-curvature Einstein classification and an <i>L</i><sup>2</sup> topological gap. | 3 | — | improvement | 1 / 0 |
| [`349`](../results/openai/families/349/) | The Solomon–Yau least-volume conjecture. | 1 | 1 / 405 | confirmation | 0 / 0 |
| [`350`](../results/openai/families/350/) | Yau’s nodal bounds: surfaces and higher dimensions. | 3 | — | improvement | 0 / 1 |
| [`351`](../results/openai/families/351/) | Scalar curvature and finite-time Ricci-flow singularities. | 3 | — | improvement | 1 / 0 |
| [`352`](../results/openai/families/352/) | A finite-time singularity of Calabi flow. | 1 | — | improvement | 0 / 1 |
| [`353`](../results/openai/families/353/) | Affine Bernstein rigidity through dimension nine and a smooth dimension-ten counterexample. | 2 | 1 / 166 | confirmation | 0 / 0 |
| [`354`](../results/openai/families/354/) | The isoperimetric profile of the cubic three-torus. | 1 | 1 / 124 | confirmation | 0 / 0 |
| [`355`](../results/openai/families/355/) | Unique tangent flows at the first surface singularity. | 1 | 1 / 190 | confirmation | 0 / 0 |
| [`356`](../results/openai/families/356/) | Gigli’s characterization of Alexandrov curvature. | 2 | 1 / 60 | confirmation | 0 / 0 |
| [`357`](../results/openai/families/357/) | Bi-Lipschitz coordinates at every regular RCD point. | 1 | — | confirmation | 0 / 0 |
| [`358`](../results/openai/families/358/) | A three-manifold without conjugate points or nonpositive curvature. | 1 | — | improvement | 0 / 1 |
| [`359`](../results/openai/families/359/) | Negative Kähler curvature without bounded holomorphic coordinates. | 2 | 1 / 171 | improvement | 0 / 1 |
| [`360`](../results/openai/families/360/) | Weak MTW curvature gives convexity and regular optimal transport. | 2 | 2 / 229 | confirmation | 0 / 0 |
| [`361`](../results/openai/families/361/) | Failure of integer-degree harmonic dimension comparison. | 2 | 1 / 86 | confirmation | 0 / 0 |
| [`362`](../results/openai/families/362/) | Global smoothness for relativistic Vlasov–Maxwell. | 1 | 1 / 110 | confirmation | 0 / 0 |
| [`363`](../results/openai/families/363/) | Nonuniqueness with local conservation for the hard-sphere Boltzmann equation. | 2 | 1 / 89 | improvement | 1 / 0 |
| [`364`](../results/openai/families/364/) | Kinetic limits and fluctuations over the Boltzmann lifespan. | 2 | 2 / 192 | improvement | 0 / 1 |
| [`365`](../results/openai/families/365/) | Joint metric and connection recovery from one boundary patch. | 3 | — | confirmation | 0 / 0 |
| [`366`](../results/openai/families/366/) | The planar Mumford–Shah regularity conjecture and local weak-<i>L</i><sup>4</sup> gradient bounds. | 1 | — | confirmation | 0 / 0 |
| [`367`](../results/openai/families/367/) | The critical dimension for the one-phase Bernoulli problem. | 1 | 1 / 58 | confirmation | 0 / 0 |
| [`368`](../results/openai/families/368/) | The three-dimensional Ball–Evans approximation problem. | 2 | 1 / 78 | confirmation | 0 / 0 |
| [`369`](../results/openai/families/369/) | The hot spots conjecture for simply connected planar domains. | 1 | 1 / 112 | confirmation | 0 / 0 |
| [`370`](../results/openai/families/370/) | The Lane–Emden and Hénon–Lane–Emden conjectures. | 1 | 1 / 59 | improvement | 0 / 1 |
| [`371`](../results/openai/families/371/) | Stable blowup for the defocusing Schrödinger equation. | 1 | — | confirmation | 0 / 0 |
| [`372`](../results/openai/families/372/) | Global uniqueness in smooth isotropic elasticity. | 1 | 1 / 147 | confirmation | 0 / 0 |
| [`373`](../results/openai/families/373/) | Nonattainment of the three-marginal Coulomb Monge problem. | 1 | 1 / 112 | improvement | 0 / 1 |
| [`374`](../results/openai/families/374/) | Sharp one-third stability of Brenier maps. | 1 | 2 / 294 | improvement | 1 / 0 |
| [`375`](../results/openai/families/375/) | De Giorgi's conjecture in dimension eight. | 1 | — | confirmation | 0 / 0 |
| [`376`](../results/openai/families/376/) | Universal computation in forced Navier–Stokes flows. | 9 | 1 / 312 | improvement | 0 / 1 |
| [`377`](../results/openai/families/377/) | Interior $`C^{1,\alpha}`$ regularity for infinity-harmonic functions. | 1 | — | improvement | 0 / 1 |
| [`378`](../results/openai/families/378/) | Disproof of the Exponential Time Hypothesis. | 1 | 1 / 205 | improvement | 1 / 0 |
