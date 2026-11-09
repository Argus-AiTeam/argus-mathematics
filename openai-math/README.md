# Verifying the OpenAI Mathematics Collection with Argus

## Summary

Argus ran one campaign for each of the 373 active families of OpenAI's [`openai/math`](https://github.com/openai/math) collection (721 manuscripts). Every result was then checked against OpenAI's source text, item by item. The outcomes fall into three categories:

| Category | Families | What it means |
| :--- | ---: | :--- |
| **1. Improvements** (§2) | **134** | A sharper constant or exponent, a weaker hypothesis, a generalization, or an optimality example, compared with OpenAI's stated result. In 55 families the key step was independently checked (55 items); in 79 families the improvement is plausible on reading. |
| **2. Errors found** (§3) | **2** (+1 DOI) | No mathematical error was found. The issues are a wrong lemma number (`320`), a scope-wording gap (`247`) and a dead DOI (`318`). |
| **3. Verification of OpenAI's results** (§4) | **229** | OpenAI's result, or its core lemmas, independently re-proved, recomputed or formalized in Lean, with no improvement claimed. Of the claimed improvements, 72 turned out to be already implicit in the manuscripts; these are counted here. |
| No substantive output | 8 | |

All Argus drafts are in [`families/`](families/), and every verification record is in [`verification.json`](verification.json). Lean: 384 certificates in 314 families, about 120,000 distinct Argus-authored lines (§5).

## Headline results

| Family | Result | Status |
| :--- | :--- | :--- |
| [`318`](families/318/) Chromatic splitting | OpenAI leaves open whether the canonical unit in weak chromatic splitting has a retraction at height 3 ("remains a separate question", `A-rational-obstruction…/01-introduction.tex:97–98`). Combining OpenAI's two theorems (τ nonzero on π₋₃; the height-three filtration) shows that **the unit `L₂S → L₂L_{K(3)}S` has no retraction**, so weak chromatic splitting fails at height 3, p = 5. | Derivation re-checked by hand. Needs a homotopy theorist's review and a literature check. |
| [`127`](families/127/) Average sensitivity of PTFs | OpenAI's main theorem `I(f) ≤ 8d√n` improves to **`I(f) ≤ 4d√n`**. The coupling lemma `E(U−V)² ≤ 8aσ` becomes `≤ 4a·E|U−c|`, and the constant 4 is optimal. | Key inequality proved in a few lines and tested on 700k random cases. The general transport structure is known (Nutz–Wang 2022). |
| [`332`](families/332/) Metric Markov cotype of ℓ₁ | OpenAI's main theorem `N₂(ℓ₁) ≤ 12√21` improves to **`N₂(ℓ₁) ≤ 6√14`**. The flatness constant drops from 108 to 18, and 18 is optimal among dimension-free constants. | Key identity checked symbolically; 200k random cases; a sharpness family reaches 17.96. |
| [`175`](families/175/) Rounding | OpenAI's main constant `q_f ≤ 25·512⁴·q` improves to **`25·96⁴·q`**, about 809 times smaller. | The selector proof was checked by hand. |

## 1. Scope and cost

| | |
| :--- | :--- |
| Upstream corpus | 373 active families / 721 manuscripts at `4eaee875`; 3 withdrawn manuscripts are out of scope |
| First pass (exploratory) | 373 campaigns, about 3.21 B tokens, provider-metered **$1,861.55** |
| All OpenAI-collection work to date | about 6.27 B tokens, **$3,477.03** (as of 2026-11-09 07:21 UTC) |
| Review | Argus second-pass review of 54 families, then an item-by-item verification of all 373 families by Claude (Anthropic) |

Costs are provider token-meter dollar equivalents and a known lower bound; 14 errored calls carry no token detail.

## 2. Improvements over OpenAI's stated results

### 2.1 Confirmed: key step independently checked (55 items)

| Family | Paper | Improvement | How it was checked |
| :--- | :--- | :--- | :--- |
| [`010`](families/010/) | Unrestricted pro-modularity at the prime two. | Full primary decomposition, nilradical, nilpotence index u+1, generic multiplicity 2^r of the completed tame special fiber | Groebner bases over GF(2) (sympy, (check script)): I=(a^2+bc,bt,ct,bf+ce) equals (a^2,b,c) cap (t,F,G); at notin I, (at)^2 in I; for two places a1t1*a2t2 notin I_2 (so nilpotence index >=3=u+1). |
| [`014`](families/014/) | Restricted geometric Langlands, global Arthur enhancements, and generic Ramanujan. | Local step of lem:compact-conjugator without regular-nilpotent hypothesis and without coefficient extension (canonical F-rational cocharacter grading the whole r-eigenspace) | Checked by hand the decisive identity (a-r lambda)^m N = r^m N (a-lambda)^m from aN=rNa, the path/height construction (infinite order of r excludes cycles), traceless-lift scalar argument and Galois … |
| [`015`](families/015/) | Torus-packet equidistribution in prime, quartic, and sextic degrees. | Theorem C: explicit family with K_h value (1-1/p)^2 p^{-c}, showing odd support exponent c sharp | Recomputed the final integral int_{a,b in Z_p^x} F_c(a-b) psi(-(a-b)/p^c) by exact finite sums mod p^c for p in {2,3,5,7}, c in {2,3}: matches (1-1/p)^2 p^{-c} exactly ((check script)). |
| [`025`](families/025/) | Short Egyptian fractions. | Divisor moment bound with one threshold S0(D) uniform over 1<=r<=log S/(200000 loglog S) (manuscript: fixed r, S0(D,r)); primorial obstruction at r=C log S/loglog S, C>1/2 | Baseline confirmed; read quantifier order in report (S0 chosen before r, Main.lean:1652-1718); lean_check.json status success, grep finds 0 sorry/axiom in Main.lean; checked A_k<=16(4k)^k derivation … |
| [`028`](families/028/) | Uniformly bounded components of Gaussian-prime graphs. | Rectangle lemma Pr <= min{1, 3 e^{-d^2 r/32}} for all r (manuscript C e^{-c d^3 r} when d^3 r>=C_0) | Hand-checked each step: Hoeffding tail with t=d log P/2, L=log 2T<=2 log T gives e^{-d^2 r/8}; det(w,w') divisible by N(c*)>=P/(2T)^h and \|det\|<=2RW forces collinearity for h<=dr/4; Doob-martingale … |
| [`034`](families/034/) | Log abundance for compact Kähler spaces under logarithmic Iitaka subadditivity. | Constant (e+1)^b in nv:mixed-bound is optimal (P_{P^b}(O(1)+O^e), beta=xi+tH, t->0) | Rederived xi^{e+1}=H xi^e, w=1, B=(t+1/(e+1))H, int beta^{e+b}=sum_{i<=b} C(e+b,i)t^i; python exact check (e,b<=4) that ratio -> (e+1)^b and the inequality holds for t in a grid |
| [`035`](families/035/) | Log-canonical threefold abundance in numerical dimension one. | Exact affine-alternating width tail (offset stabilizes; d_{E+n+1}+d_{E+n}+c=M_E p^{n+1}; alternating K) instead of only lim d_e/M_e=p/(p+1); rank saturation for k<p lists; p=k=2 sharpness | Read manuscript proof; checked that the second swapped congruence follows from eq:residue-swap, that subtraction gives M_{e+1} \| (eps_{e+1}-eps_e) hence eventual constancy, and verified K_{n+1}=-K_n … |
| [`039`](families/039/) | Nagata’s conjecture and maximal Seshadri constants. | Reshaping proposition under dw<1/3 (vs dw<1/16) with backward transfer of mixed-order max jet ranks | Checked the load-bearing fixed-three lemma: with u=(i,3), need R-3W>0 (iff dw<1/3) and an integer i not divisible by 3 in an open interval of length 3T/(1+T)>=18/7>2; area/height-range argument … |
| [`048`](families/048/) | A characteristic-zero counterexample to Lipman–Zariski. | Upper bound p_g<=39 added to manuscript's p_g>=33, p_g=39-rank d2-rank d3-rank d4, stabilization at 5C | Recomputed: g=21, deg L=10, L^4=K_C: h^1(O_C)=21, h^1(L)=12, h^1(L^2)=3 (h^0=3, chi=0), h^1(L^3)=h^0(L)=2, h^1(L^4)=1, h^1(L^n)=0 for n>=5 (deg>40); sum 39; sequences give stabilization from 5C |
| [`049`](families/049/) | A stable-coordinate counterexample in four variables. | Ideal identity (t-s^2, bd-sab)=(a^2t-d^2), s=dc-abt, whenever ac-bd=1, any commutative ring, any t | Groebner-basis membership check both directions modulo ac-bd-1 over Q[a,b,c,d,t] (script (check script)); lean_check.json success, no holes |
| [`055`](families/055/) | Gepner symmetry and large-volume stability on threefolds. | Comparison radius 1/200000 -> 1/4000; explicit refinement radius 1/500000, support constant 3e7, sufficient range u<13/46 | Recomputed all four margins exactly at delta=1/2000, s=13/23, u<138197/500000 (539/2000, 2857/125000, 62469/11500000, 61719/6500000 >0); checked max over [1/2,13/23] of Xu's g(x)-x/2 = -13/46; … |
| [`066`](families/066/) | Bounded klt complements for Fano contractions. | Monomial sharpness family on smooth surface: loss m*q necessary; uniform o(e) fails (ratio->2) | Rechecked by hand: v_q weights (1,1+q) in (x,y-x): A=2+q, v(xy)=2, e=q, vol=1/(1+q), excess m*q, normalized ratio (2+q)->2 |
| [`068`](families/068/) | Anticanonical nonvanishing in every dimension. | Exact integrability chamber b_Q<min(lambda_Q,1) with endpoint sharpness family | Verified lambda_Q-a_Q=min(lambda_Q,1) and coeff_E<1 <=> a_Q+b_Q<(1+a_E)/e_E |
| [`071`](families/071/) | Koebe’s circle-domain conjecture. | No coefficient below 1 possible (annulus example) | Recomputed \|\|g0\|\|^2=2pi/log2 for g0=1/(Lambda r log2) and the annulus capacity 2pi/log(2+1/n) |
| [`084`](families/084/) | The geometric case of the Erdős similarity conjecture. | lem:conditional-scales miss probability [1+k(1+2c/q^{2r})](1-p/2)^k | Checked the monotone lifted-floor argument (distinct floor vectors <= 1+s(2)-s(1)) and that (1-p/2)^k is the manuscript's own exact test-failure value (04-routing.tex:161-165) |
| [`087`](families/087/) | The Mahler conjectures, functional inequalities and polar-product symplectic width. | Re F'>=2/pi on the disk, explicit eps_k in \|J_k\|/k<=(pi/4)\|g\|^{2k}+eps_k, pi/4 optimal | Monte Carlo 2e6 points + boundary sweep: min Re F'(z)=0.63662 -> 2/pi approached at \|z\|=1 |
| [`088`](families/088/) | Sharp projection-body inequalities and a counterexample to simplex maximization. | 2W(z)-L(z) >= (41/360)(z-1)^2/max(1,z)^{2n} replacing qualitative strictness | Implemented manuscript definitions (k,c,beta,w,d*,I,G,D) and evaluated with 60-digit precision for n=4..39,50,100,200,1000 on ~750 z values incl. near 1 and up to 2^39: min ratio 0.289 > 41/360=0.114 |
| [`097`](families/097/) | The Euclidean Steinitz–Bergström bound. | Gain bound (a 2^a E)^{1/a} -> (aE)^{1/a}, all 1<a<=2, no small-budget restriction; coefficient a optimal | Random test 400 contraction/gain sequences, d<=3, a in (1,2): max trH^a/(aB_a)=0.92<=1; checked psi_a(h/(1-h))=int_0^h t^{a-1}/(1-t)dt>=h^a/a and B_a<=E (same p_1) |
| [`099`](families/099/) | The sharp exponential scale of edit-distance distortion. | prop:family separation 24^{-s} -> 9^{-s}; recurrence Q_s -> B_s=(2P)^{2h-2}/L+B_{s-1}/h; coprime/real-l1 generalization | Re-derived a_s=mu a/(2C+mu a) from marked-payload bound 2Tdq/(d+q) with T=L,p=Cm,q=Cm; checked mu=b/2 is valid (fewer than b/2 primes divide delta => >=b/2 shifted slots, manuscript conservatively … |
| [`105`](families/105/) | Perfect completeness for 2-to-1 games. | prop:upper agreement gamma_j: remove factor 2^{-ell} | Read the manuscript proof (lines 455-610): the 2^{-ell} comes from picking one good sigma out of 2^ell characters. Checked Argus Theorem B: \|c_sigma\| <= 1_bad + 1_{good,\|c\|>=t} + t gives fraction … |
| [`112`](families/112/) | Beyond the square-root exponent for depth-three circuits. | Restriction lemma E W <= 1/(1-theta) -> E W <= 1 for theta<=1 | Hand-checked the clause-insertion mass identity: averaging over S gives q^{\|S\|}(sum_{D subset S,\|D\|>b}(p/q)^{\|D\|}-1) m_F(r_a) with p/q=2p/(1-p), so the sum is <= theta. Lean Main.lean exit 0, … |
| [`126`](families/126/) | Exponential semidefinite complexity of perfect matching. | Orthogonal splitting C_L=2^{L-1} -> L/4; potential 2^t -> (9/8)^t, Fourier mass 2^{t/2} -> (9/8)^{t/2} | Implemented the recursive balanced splitting in numpy and tested (S2) on 6000 random PSD families (L=2,4,8, dimension <=6, low-rank/correlated): max ratios 0.495/0.487/0.424 against bounds 0.5/1/2. … |
| [`127`](families/127/) | Average sensitivity of polynomial threshold functions. | Coupling lemma 8a sigma -> 4a E\|U-c\|; I(sign p) <= 4d sqrt n instead of 8d sqrt n | Random test of E(U-V)^2 <= 4a E\|U-c\| (c=median and mean) over 2e5 equal-marginal permutation couplings: max ratio 0.833. Checked the main-theorem propagation: I<=2E(U-V)^2<=2*4*d*(sqrt n/2)=4d sqrt … |
| [`132`](families/132/) | A superquadratic separation of sensitivity and block sensitivity. | Explicit bs(F_m,0) >= s(F_m)^{161/80} (exponent 2.0125) | Iterated the manuscript's recurrences (prop:recurrences) exactly with d=20, M=16*3^20, r=4*3^10, t=16, L=22: max(M S_{20,0},S_{20,1}) = 34.37 M^21 <= 36 M^21. Exact integer check B^80 >= A^161, … |
| [`148`](families/148/) | The entropy-rate dimension formula for self-similar measures. | Finite-law pair bound constant C_k=60000k^4 -> 1000k^4 | Read the Lean statement pair_bound_1000 (Main.lean:1076): k(H(nu)-H^0_rho(nu)) <= log2\|kF\| + 1000k^4 * sum_{2^-l<=2rho} c_l(nu), over arbitrary finite laws, k>=1, rho>0. Compile log: exit 0, axioms … |
| [`153`](families/153/) | Arithmetic classification and non-Pisot singularity for Bernoulli convolutions. | Singularity for quartic Salem beta extended from unbiased to arbitrary independent nonstationary biased signs | Checked the two load-bearing new steps by hand. (i) E exp(i pi u eps) = cos(pi u) + i(2p-1)sin(pi u), whose modulus^2 is >= cos^2(pi u), so the Fourier lower bound (18) is bias-uniform. (ii) Centered … |
| [`172`](families/172/) | Classification of finite Euclidean Ramsey configurations. | Supported-fraction inclusion strengthened from N^(s-2) to gamma_{s-1}(N), giving derived depth ceil(log2(s-1)) instead of s-2; index s-1 sharp | Checked the key step by hand. x in M with x_i=b, x_j=1 exists because the pair projection M_ij is a group containing N x N. x z^-1 x^-1 is a pair-supported actual fraction, and z(x z^-1 … |
| [`174`](families/174/) | Deterministic construction of strong thin spanning trees. | thm:extraction resistance threshold 4r^{-1/2} -> r^{-1/2}/(1-40r^{-3/16}) = (1+o(1))r^{-1/2} | Checked the key step by hand. The manuscript uses a 1/2-weight Markov split, giving 2r^{-1/2}, and then s<4r^{-1/2}. Argus uses the threshold theta=1-delta/u with delta=40r^{-1/4}, u=r^{-1/16}. Then … |
| [`175`](families/175/) | Talagrand’s expectation thresholds, discrete convexity, and graph decompositions. | Main theorem constant q_f <= 25*512^4 q improved to q_f <= 25*96^4 q (selector D=256 -> 48) | Checked the full selector proof by hand. Steps: the truncation-maximality bound d\|T\|<=m; the one-level delay contradiction giving (8); the injective encoding count; the exact likelihood identity … |
| [`179`](families/179/) | The circulant Hadamard and Barker-sequence conjectures. | lem:comparison extended to order-p^r characters with FK=p^s b, s<=e-r+1; sharp via F=p-aPhi_{p^r} | Ran a Smith normal form of multiplication by F=p-aPhi_{p^r} on Z[C_{p^e}] for (p,r,e) = (3,1,1),(3,1,2),(3,2,2),(3,2,3),(5,2,2),(3,1,3). The p-adic valuations exactly match the predicted … |
| [`195`](families/195/) | A counterexample to the small Cohen–Macaulay module conjecture. | thm:obstruction sharpened to K^2-2c_2 < 6H^2 (so <= 6h-1), and <= 3h for rank-one modules | Checked the load-bearing step: running the manuscript's elementary modification whenever width >= 1 (not only > 1). The max-slope bound mu_max(G(H)) = mu_min+1 <= mu_max(P) still holds at equality, … |
| [`205`](families/205/) | Saxl’s conjecture and universal tensor squares. | Single explicit integral conjugator Q=[[1,1],[1,2]] gives nonzero odd-path contraction epsilon*prod r_j! (epsilon in {±1,±3}) for every ordered column list | Exact integer computation of the pairing [X1 J X2^T J X3 ...]_{11} summed over signed segment alternations of N_i = Q M_i Q^{-1}, for all 284 ordered lists with parts in {1..4} and odd sum k <= 9. … |
| [`210`](families/210/) | Foulkes' conjecture for sixth powers and quadratic stabilization. | Canonical Foulkes-Howe map surjective for b >= (a-1)^2 instead of b >= a(a-1) | Checked the load-bearing step. In Step 4, whole powers (x.d_{v_i})^r are applied, and sl2 injectivity D^L on weight w >= L (proved in Main.lean, exit 0, no sorry) needs only b-(i-1)r >= r, i.e. b >= … |
| [`226`](families/226/) | The double-dimer loop ensemble converges to CLE<sub>4</sub>. | Cap weights B^{-b(A)}, B>M-1; with B=M detection constant 1/(2M^{2M}) vs (2M)^{-2(M-1)}/16 (ratio 2^{2M+1}/M^2); decay (M-1)/B | Checked the key step. Inner arches number at most M-1 because the outer loop uses at least one of the at most M eligible arches, giving decay r=(M-1)/B. An alternating sum with ratio <= r is >= (1-r) … |
| [`259`](families/259/) | A group without fixed price. | Planar word lemma: m(r)>=7 weakened to m(r)>=4, intervals m(r)-3 improved to m(r)-2 (optimal), injectivity H->D proved automatic; threshold 3 fails | Re-derived the (4,4)-map curvature count: face weight <=2l-4 cases, sum_inner(4-C(v))>=4, and the gap-cost classification giving t>=m(v)-2; checked Euler contradiction for automatic injectivity … |
| [`260`](families/260/) | Spacetime Penrose inequalities: enclosing area, charge, rotation, and anti-de Sitter … | prop:scalar:coercivity with explicit C_k=32+4k^2; (1+N)^2 shown necessary (k=2,v=1/4 ratio p^2/44+4p/11+21/11); stationary constants 1/16, 3 | Random test ((check script)): 200 parameter draws x 2e5 vectors of the exact quadratic form eq:scalar:quadratic (:162-167), k=2..7, p up to 1e3: form never negative, max LHS/((32+4k^2)(1+p)^2 T) = … |
| [`262`](families/262/) | Sharp finite-matrix Lieb–Thirring inequalities and all equality cases. | thm:trace deficit extended to gapless PSD symbols and without N>=0; N converges iff sigma>(m-1)/(2m), sharp via nilpotent Jordan blocks; exact asymptotic constant | Numerics ((check script), jordan2.py): for Jordan blocks n=2,3, t^{1-1/(2n)}R(t)_{11} -> 0.7071, 0.6667 = (1/n)csc(pi/(2n)) as claimed; for gapless n=2 example (V=diag(-1/4,3/4), sigma=1/2) computed … |
| [`269`](families/269/) | Uniform Laughlin gap and stability under bounded scalar disorder. | prop:retained-blocks: retain all pair deficits except l=4,10,12,14 (vs only l>=23), for every c<0.04785933319001 | Replayed Argus exact-rational verifier in an isolated copy ((check script), upstream rows.txt linked read-only): recomputed certificate matches stored one; all exact PSD checks for the manuscript and … |
| [`285`](families/285/) | Counterexamples to Baum–Connes and Kadison–Kaplansky. | Diagram constants: b<=4m-6 (vs b<=6m), fillings with 8n (vs 12n) relations, avoidance (4L-2)lambda sigma(P) (vs 12(L+1)lambda sigma(P)), overlap radius 16D0+30 (vs 48D0+108) | Re-derived the Euler step by hand: v-b+F=1 and 2b>=3(v-M)+M give b<=3F+2M-3; F/lambda<=2b with lambda<=1/12 gives b>=6F; hence b<=b/2+2m-3, i.e. b<=4m-6; identity 4m-b-6 = 2(2m+3F-b-3)+(b-6F) checked … |
| [`298`](families/298/) | Two notions of free entropy differ even when both are finite. | Fisher deficit g(u) <= (4/3)K^8 p u^-5 (vs 2K^6 p^{3/2} u^-4), entropy deficit K^8 p/(6a^4); exact asymptotics | Checked the load-bearing steps. (i) Odd cumulants vanish because Y is symmetric (the manuscript's uniform p-point Y on [-1,1]). (ii) Cumulants with fewer than two Y letters vanish, giving support <= … |
| [`300`](families/300/) | Approximation and quadratic strong-operator paving. | lem:assignment pinning holds with any beta>=12 (cost 23m) instead of beta=80; non-uniform probabilities, dimension-free | Re-derived Argus's chain: tests sum b/(D0+lambda)<=2m+e+/2 with D0=8m+4a and sum b/(L+\|lambda\|)<=6m+4a; pick a color at twice the mean; side-arrow increments <=4m+e+ and <=e-+eps; diagonal shift … |
| [`314`](families/314/) | Cyclic length and chromatic fixed-point loss. | Effective congruence D_d c_h == p^{bd} mod p^{h-b+1}, v_p(c_h)=bd for h>=b(d+1), replacing qualitative nonzero-limit contradiction | Python check ((check script)): D_d a_j(d) == 1 mod p^{j+1} for p=2,3, d=1..3, j<6. Congruence (4) and v_p(c_h)=bd for h>=b(d+1) hold for cyclic abelianization b=1,2, with s_i from Sur(Z_p^d,C_{p^i}) … |
| [`318`](families/318/) | Chromatic splitting: filtrations and counterexamples. | At p=5 the unit L_2 S -> L_2 L_K(3) S has no retraction (weak chromatic splitting fails at (n,p)=(3,5)) because tau is nonzero on pi_-3 | Re-derived by hand. OpenAI's filtration (The-height-three-chromatic-overlap...Sept-27, thm:main, p>=5) K(2)-localizes to a cofiber sequence R -> L_K(2)X -> Sigma^-1 R with the unit first. pi_-3 L_0 … |
| [`323`](families/323/) | Independence of the separable quotient problem. | Prescribed-weight estimate (2112/7)L/m_J improved to (1794/7)L/m_J via 2 partial blocks (6 marks instead of 8) | Verified the crop lemma: blocks successive in every order, and an intersection of convex intervals that meets S_a and S_c contains S_b, so at most 2 partial blocks. Recomputed … |
| [`326`](families/326/) | The cotype–cotype conjecture under the approximation property. | Compactness constant c_* in lem:coefficient replaced by explicit \|Psi_hat(P)\| >= 2^{m^2+1}(640d+504)/(3^{m^2}-1) > (2/3)^{m^2} | Checked the mechanism. The rank<=1 part Q satisfies the same projections; \|E R(S)\| <= eps*W_N with W_N=((3/2)^N-(1/2)^N)/2; the manuscript chain then gives AB/2 <= 4D(A+B)+5KDL with K<=8+eps W_N. … |
| [`329`](families/329/) | A counterexample to metric-entropy duality. | Optimal dilation loss over profiles on {0..H-1} is exactly 1/k (3^{k-1}<=H<3^k); k-level compression improves the leading entropy-ratio coefficient by factor k/H | LP check ((check script)): the minimax value equals 1/k for every H=1..39. Checked the band partition j<a_{l+1}<=3j+2 <=> a_l<=j<a_{l+1}, disjointness of (3^l-1,3^{l+1}-1], and log Q ~ k s D_{H-1} … |
| [`331`](families/331/) | Reflexive midpoint convexity and diamond distortion. | Squared lens constant cannot be below 2 (exact 3-node example); manuscript proves 4 | Numerically computed dual norms on the 3-vertex tree ((check script)): \|\|x\|\|^2=16, \|\|y\|\|^2=18, \|\|x+-y\|\|^2=25, so the ratio is 18/(25-16)=2. |
| [`332`](families/332/) | Metric Markov cotype of <i>ℓ</i><sub>1</sub> and Hilbert-space Lipschitz extension. | N_2(l1)^2 <= 504 (vs 3024), flatness constant 18 (vs 108), 18 optimal | Sympy-verified identity 2R-DS=(B-A)^2+4(A-C)^2. Random test of the weighted flatness inequality on 2e5 cases (max ratio 15.8 < 18). Sharpness family at m=1000 gives ratio 17.96. Checked … |
| [`335`](families/335/) | Gromov’s integral scalar-curvature bound for simplicial volume. | Explicit cardinality-free constants (7m^2, 14m^3) in eq:entropy-BC-expansion/sharp-T plus nonperturbative reserve T >= Phi_n(m)=2[m-n(1-e^{-m/n})], sharp over rank-one ordered updates | Random test (2e4 cases, n<=5, up to 11 rank-one updates, scales 0.01-3): exact loss identity sum s_iB_i = m - m_f holds to 1e-6 and baseline 2d+2sum s_i(L_i-1) - Phi_n(m) >= -2e-16; hand-checked the … |
| [`337`](families/337/) | Sharp Cartan–Hadamard isoperimetry and rigidity. | thm:extrinsic-sobolev extended from hypersurfaces to C^{1,1} immersions of arbitrary codimension with \|H\|^2 (mean curvature vector) | Hand-verified the load-bearing square (sec.4, eq.9-10): traced Hess u bound with tangent/normal split beta=(grad u)^perp gives m(\|H\|^2-b^2) >= mf^2+m\|H+beta\|^2+(m-2)\|grad_Sigma u\|^2+2 Delta u … |
| [`348`](families/348/) | Nonnegative-curvature Einstein classification and an <i>L</i><sup>2</sup> topological gap. | Sharp spin-5/2 bound <B_F(T)Z,Z> <= (4x/5)\|Z\|^2 on G gives bracket >= (1/3+19y/12)e (manuscript: >= (7/12)(4+y-2x)e >= 0) | Built G (rank 8 Bianchi constraint, dim 12) from quaternion triples and computed max eigenvalue of the compression of B_F(T) over 2e4 random trace-free T: max ratio 0.791 < 0.8 (vs 0.989 on all of … |
| [`351`](families/351/) | Scalar curvature and finite-time Ricci-flow singularities. | Reaction estimate c <= [2(q-1)+C_sharp]/r^2 with numerical C_sharp=8+4E (manuscript: 2(q-1)+C sqrt q) | Hand-checked the Schur/Young step: separated diagonal <= q+3, block <= D_low, coupling \|v\|^2 <= Eq; 2\|x\|\|v\|\|y\| <= 2E x^2+(q/2)\|y\|^2 is exact AM-GM, so lambda_max <= q+3+2E once q/2 >= … |
| [`363`](families/363/) | Nonuniqueness with local conservation for the hard-sphere Boltzmann equation. | Rank-seven a.e. of ordered gain history map already with three gains (OpenAI uses five); two gains have rank <=6 everywhere; extends to all m>=3 | Python: implemented recursion (nc:rank-map) with random analytic axial profiles a_i(t,z)=c0+sin(c1 t+c2 z), finite-difference Jacobians at 200 random ordered histories: rank 6 for m=2, 7 for m=3, 7 … |
| [`374`](families/374/) | Sharp one-third stability of Brenier maps. | Stationary-site moment estimate constant C_0=162 improved to optimal 1 (finite two-intercept form), potential constant 2R instead of (1+sqrt162)R | Sympy: identity (4) \|ax-bz\|^2/h+2aPhi(x)+2bPhi(z)-(4ab/h)Phi((x+z)/2) = (a-b)^2R^2/h verified symbolically in R^3. Monte-Carlo 1D Laguerre cells (3000 random configs, N<=5): max ratio LHS/RHS of … |
| [`378`](families/378/) | Disproof of the Exponential Time Hypothesis. | Tapered Hermite recovery with exact smaller precision P_t=p+hB(a-i,u-i)+(m_t-1)(a+1-i) instead of p+8hL/2^i+8M(a+1) | Exhaustive exact check over a<=6, all u, h in {1,2,3}, all retained t (3132 cases): v_2(E_t(0)) = -hB(a-i,u-i) and the closed form of B(n,k) both hold. Since B<=6*2^n and m_t-1<4M, P_t <= p_t follows |

### 2.2 Plausible: baseline checked, argument read, key step not independently checked (92 items)

`107` would have large consequences if correct: it extends the matrix-multiplication exponent 9/4 from ℂ to every field. Its positive-characteristic steps need expert review.

| Family | Paper | Improvement |
| :--- | :--- | :--- |
| [`007`](families/007/) | Ordinary two-point correlations and the corrected Elliott conjecture. | Explicit constant C=2048 in forest-coding bound exp(Ck), general bound 2^(10n+3)(2n)^((6r-4)B+I) |
| [`013`](families/013/) | Ostmann’s inverse Goldbach conjecture. | Explicit C_l=16^r in tree estimate \|E W1 conj W2\| <= 16^r(eps+q^{-1/4}); cycle criterion |
| [`015`](families/015/) | Torus-packet equidistribution in prime, quartic, and sextic degrees. | Theorem B: sup norm vol(R) at odd primes, support p^{-c} h d^{-1} (vs p^{-4(g+1)} h d^{-1}), dyadic 2^{-max(c+3,4)} |
| [`015`](families/015/) | Torus-packet equidistribution in prime, quartic, and sextic degrees. | Two profile inequalities improved from G_0^24 to G_exp^3, constant 13,824,000 |
| [`017`](families/017/) | The irrationality exponent of <i>π</i> is 2. | Interpolation with center-independent weights under occupancy bounds n_T theta^{\|T\|}<1 (collisions, several Y-fibers allowed) plus matching overcrowding obstruction |
| [`018`](families/018/) | The Margulis–Platonov conjecture over global fields. | Block-supported shears for arbitrary finite disjoint parameter tuples over separable quadratic global extensions (no conjugacy/division-algebra/odd-count/degree-6 restrictions) |
| [`022`](families/022/) | The weak inhomogeneous Duffin–Schaeffer conjecture. | Oriented mixed roundoff O(W) -> O(W^2); remaining first joins O_{k0}(W^{201/200}) |
| [`026`](families/026/) | Positive lower density of large prime gaps. | Mixed-moment remainder O(L^{-t-1}(log L)^A) instead of O(L^{-t-1/2}(log L)^A), B>=1 |
| [`033`](families/033/) | Iitaka subadditivity, variation, and logarithmic additivity. | nu(sum c_j L_j + tH)=nu(sum c_j L_j)=nu(L_0+L_1) for rational c0,c1>0, c_j>=0, t>=0 (manuscript: P=sum L_j, t=1) |
| [`033`](families/033/) | Iitaka subadditivity, variation, and logarithmic additivity. | Local: ker(Theta_L0+Theta_L1)=intersection of all ker Theta_Lj on constant-rank locus |
| [`034`](families/034/) | Log abundance for compact Kähler spaces under logarithmic Iitaka subadditivity. | Volume inequality extended from Kahler beta=f^*G+c1(Lambda) (rational Lambda) to every nef real (1,1)-class |
| [`037`](families/037/) | The ordinary-double-point volume gap. | Adjoint lifting (Taylor-initial lifting) for arbitrary M with M-K_B-tL nef, rational t>0, without -K_B=rL |
| [`042`](families/042/) | Oka classification for minimal compact complex surfaces: Kodaira dimension zero and class … | Explicit sewing constants (b=r/4, N=8(A+2), K=1024N^6, e*=d^7/(1024K)) and holomorphic dependence on passive parameters T for sew:chain |
| [`046`](families/046/) | Shafarevich counterexamples in dimension two and with large fundamental group. | Infinite-quotient construction extended from multiplication by 4 to every dyadic n=2^r, r>=2 |
| [`046`](families/046/) | Shafarevich counterexamples in dimension two and with large fundamental group. | Non-holomorphically-convex surface for every dyadic n>=4, exact dual-graph incidence formula, profinite local detection |
| [`047`](families/047/) | Zariski cancellation and affine fibrations over the complex numbers. | prop:rigidity (m=3, e<=0, k=C) generalized to odd m>=3, any char-0 k, lower-auxiliary perturbations P, shift e<2; threshold 2 sharp |
| [`049`](families/049/) | A stable-coordinate counterexample in four variables. | LND rigidity for W+a^2u^2-d^2 for any W with auxiliary degrees <=1 (manuscript: W=a^3b) |
| [`049`](families/049/) | A stable-coordinate counterexample in four variables. | Uniform Danielewski-type family W_psi=a^2 psi(ab): no nonzero LND preserves J_psi, every psi |
| [`050`](families/050/) | A counterexample to Griffiths’ positivity conjecture. | prop:limit: strong L^p_loc coefficient convergence + preserved normalized max; semipositive metrics; (P^1)^d, sublinear twists |
| [`056`](families/056/) | Termination of projective and Kähler fourfold minimal model programs. | Curve bound b<=N_T and all-place bijection for compact complex (non-Kahler) terminal fourfolds with globally projective resolution |
| [`060`](families/060/) | The Global Spherical Shell conjecture. | cylinder:estimate CM(1+E) -> CME on full cylinder, explicit graph-filling threshold, Stokes replaces compactness citation |
| [`063`](families/063/) | The generalized Mukai conjecture. | <tau_{d-2}(pt)>_beta >= b^{-(d-1)} for any very ample H and non-Fano X with -K.C>=2 on rational curves |
| [`066`](families/066/) | Bounded klt complements for Fano contractions. | Common rational threshold for compact family of rational eta (uniform exact realization) |
| [`068`](families/068/) | Anticanonical nonvanishing in every dimension. | Toroidal volume/positivity result for sources of locally klt type |
| [`071`](families/071/) | Koebe’s circle-domain conjecture. | Barrier coefficient 8 / budget 4m -> any kappa>1 with budget kappa*m, size <= kappa(\|\|g\|\|+\|\|m\|\|)+eta |
| [`072`](families/072/) | Brennan's conjecture and the integral-means spectrum. | Affine transport/law/escape/pairing chain for general p |
| [`072`](families/072/) | Brennan's conjecture and the integral-means spectrum. | Zero-Jacobian rigidity for all k>0; k=1 classified as affine/quadratic F_t |
| [`072`](families/072/) | Brennan's conjecture and the integral-means spectrum. | Explicit critical Cauchy-quadratic law and uniqueness on the rigid locus |
| [`074`](families/074/) | Kakeya in three and four dimensions. | Two-color matching: sharp pure-type bound d>=(m+1)/2 for order-m matching, attained with N=L^m |
| [`076`](families/076/) | Real ultraflat Littlewood polynomials and unbounded binary merit factors. | All-order conditional moments \|E[Z^u\|V]-p^k\|<=k tau_q+2C(k,2)(2R+1)/q |
| [`078`](families/078/) | The three-dimensional Bochner–Riesz conjecture. | Unequal-rate directional bootstrap targets min{s_B,(s_A+s_B)/2}, min{s_A,(s_A+s_B)/2} |
| [`079`](families/079/) | Local smoothing for the Euclidean wave equation. | prop:energy-flux extended with explicit moving-wall term and iff cancellation criterion |
| [`081`](families/081/) | Riesz transforms and rectifiability in higher codimension. | prop:height-equation with oscillation hypothesis D delta_j^2(Lip xi+1) instead of C(Lip xi+1)delta_j^3 |
| [`085`](families/085/) | Endpoint Sobolev regularity of centered disk averages. | prop:label-packing for arbitrary finite 2-component vector measures; explicit constant 2e9 |
| [`093`](families/093/) | Dimension-free logarithmic Sobolev inequality for subgaussian log-concave measures. | lem:entropy-loss without exponential-square moment on p; robust to sublinear-rank adaptive projections |
| [`107`](families/107/) | Matrix multiplication with exponent at most 9/4. | omega_F <= 9/4 for every field F (incl. positive characteristic) |
| [`108`](families/108/) | A cubic permanent–determinant lower bound. | Gradient codimension k^2+k-binom(q+2,2) -> k^2+k-(q+1)^2 (and (a+1)(b+1) any char) |
| [`113`](families/113/) | Approximate counting and entropy of perfect matchings. | Pair-energy constant (10^4 N D)^100 -> 44040192 N^12 (1000D)^6 |
| [`122`](families/122/) | Quantitative trace-reconstruction bounds with a uniform decoder. | prop:multiscale loss 7.98 -> 7.84 and 4k<=D -> 2k<=D |
| [`141`](families/141/) | Existential–universal real sentences in the counting hierarchy. | prop:char-coeff level F_{a+8} -> F_{max(a+2,5)}; mult-determinant F_{max(a+3,5)} |
| [`146`](families/146/) | Positive metric entropy for the standard map. | can:local-scarcity extended from c=99/100, tolerance 3/5 to all 2/3<c<1, 2alpha<3c-1 |
| [`149`](families/149/) | Classwise permanence for weakly reversible mass-action systems. | Classwise permanence for weakly reversible networks extended from fixed rates to measurable time-varying rates in [l_e,u_e], with one schedule-independent compact convex invariant K |
| [`152`](families/152/) | Zero entropy does not guarantee a smooth positive-volume model. | thm:switching measure inequality extended from smooth to C^{1,alpha} maps with continuous positive density, with factor K_k->1 instead of 2 |
| [`164`](families/164/) | Hindman’s finite sums and products conjecture. | prop:rough-step superpolynomial scale Z/S^a->inf weakened to Z>=kappa S^{A*}, A*=2Ds^{n-1}+2 |
| [`166`](families/166/) | The higher-dimensional Erdős distinct-distances conjecture. | Unspecified C_e in conc:degree made explicit: C_e=2 (1 in codim>=2), exceptional case = Pfaffian cylinders |
| [`184`](families/184/) | Correspondence coloring with a fixed forbidden subgraph. | thm:weighted-triangles generalized from profile s(x+log(1/s)) to s(x+log+(1/s))^p for all p>=1, with strict hierarchy |
| [`190`](families/190/) | Polynomial removal fails for ordered binary matrices. | Exact distance min edits = m^2 = 4^h and exact copy count N_H(A_h)=2m^130 (manuscript: >= m^2 and <= m n^130) |
| [`197`](families/197/) | A torsion-free group algebra that is not directly finite. | thm:bounded-patterns with explicit error budget and admissible epsilon < tau/(A-tau) vs manuscript min(1/4, delta/(16(1+a0))) |
| [`202`](families/202/) | The blockwise Alperin weight conjecture. | thm:inseparable-genus generalized to rank-profile inequality over any perfect field; sharper threshold N > p^a U_p(a,h) vs p^{s-h} > m(h+log_p m); strictness N>dE needed |
| [`204`](families/204/) | Tensor saturation for even spin groups. | Initial-state continuation-or-rank-drop theorem: prop:continuation without the local-link forgetting condition |
| [`209`](families/209/) | Integral counterexamples to Gersten’s conjecture. | Integral degree-three Gersten counterexample for every odd prime p and unramified degree d prime to p; plus dyadic example B=Z_2[x,y]/(2-2x+x^2+xy-y^2) |
| [`211`](families/211/) | The geometric phase diagram, diffusion, and spectra of random planar maps. | gr:green-bound for all rho<2/3 with p-th moments (p<3, rho<1-1/p) plus critical m^{2/3} log^beta bound |
| [`215`](families/215/) | Canonical $`O(3)`$ continuum limit and exact $`O(4)`$ mass asymptotics. | prop:annulus generalized to signed strengths, rotation-invariant unit-ball measures, n>=3, arbitrary boundary textures with explicit constant |
| [`217`](families/217/) | The low-temperature Sherrington–Kirkpatrick fluctuation law. | Exact PSD decrement identity (Hessian kernels Loewner-decreasing; matrix supermartingale) upgrading entrywise weighted bound |
| [`219`](families/219/) | GOE bulk universality for regular graphs with weak Anderson disorder. | prop:gaussian-marks equality case under parity-preserving ergodicity and log inverse-covariance moment; two-phase example shows ordinary ergodicity insufficient |
| [`221`](families/221/) | The Mézard–Parisi formula for diluted spin glasses. | Exact normalized extension mass sum\|c_E\|/J = 2s^2 + 1/L replacing unspecified C_{k,eta}; removes interior-depth (eta) dependence |
| [`225`](families/225/) | Gaussian free field limits throughout the balanced six-vertex regime. | lem:overlap-asymptotic I_L/B -> 1/(2 lambda(pi-lambda)) for all pi/2<lambda<pi (manuscript range 2pi/3<lambda<pi) |
| [`227`](families/227/) | Critical SK autocorrelation processes and dynamics across the temperature transition. | Critical SK autocorrelation functional limit extended to centered variance-one zero-third-moment disorder with two-sided exponential moment |
| [`228`](families/228/) | Continuum phase transitions for radial pair potentials. | k:range error improved from C sqrt(R0/R) to C min{a, sqrt(a R0/R)} |
| [`230`](families/230/) | Exact Hausdorff gauges for SLE. | Mesh tail extended to all bounded simply connected locally-connected-boundary domains with arbitrary marked prime ends; simultaneous-in-mesh envelope for 4<kappa<8 |
| [`231`](families/231/) | The free uniform spanning forest is a factor of IID. | Every strongly Rayleigh law on {0,1}^I (countable I) is a Borel FIID equivariant under its full permutation stabilizer; NA/uniform-response criterion |
| [`232`](families/232/) | Gaussian fields and interfaces for triangular-lattice Lipschitz heights. | Spectral rigidity robust to finite signed errors in each periodized-Cauchy mixture, coefficient c=-2(L+B_0)/pi; D6 six-atom example shows B_0 needed |
| [`236`](families/236/) | The exact factor-of-IID threshold for free Ising spins on trees. | Critical comparison principle: V=0 under any positive local flatness and exceptional tail exp(-c log^q(1/t)), q>1; q=1 abstract nonuniqueness example |
| [`238`](families/238/) | Optimal logarithmic mixing of the Thorp shuffle. | eq:h-2 one-sweep energy identity extended to conditional last-occurrence energy for any deterministic coordinate word; joint independence upgrade of eq:h-3 |
| [`239`](families/239/) | Sharp singularity rates for symmetric random sign matrices. | Low-height cover for log H(W) <= N(log N)^{1/9}, radius N(log N)^{-2/3}, log2 size <= 1e5 N^2 (log N)^{-1/9} (vs H <= exp(N l^D), l=loglogN) |
| [`251`](families/251/) | Amenability, unitarizability, and strong Ulam stability. | prop:comparison with explicit constants 40h+16N eta+30N h eta (h<=1/128, eta<=1/4), plus nested-configuration version |
| [`257`](families/257/) | A hyperbolic group without a geometric CAT(0) action. | diagram:fragment: kappa=min{beta-7alpha,alpha/5,delta}, A<=B/kappa improved to kappa4=min{beta-7alpha,alpha/4,delta}, A<=3B/(4 kappa4) |
| [`261`](families/261/) | Localization and delocalization in the Anderson model. | lem:leverage-drift extended from scalar ridge tau to PD Hermitian ridge Lambda with S_B^* conj(Lambda) S_B <= Lambda, via dimension-free stochastic row-deletion theorem |
| [`264`](families/264/) | Strong cosmic censorship near two-ended Kerr data. | prop:averaged-holonomy extended from L^2 to every finite p>=1 connection with exponent criterion; conditional category transfer for p>4/3 |
| [`265`](families/265/) | Area laws and tensor networks for two-dimensional gapped systems. | lem:symbol range extended from 0<t<1/4 to 0<t<1/2 with rate (log k)^{-beta(t)}; fails at t=1/2, unbounded for t>1/2 |
| [`274`](families/274/) | Parity is not in QAC<sup>0</sup>. | thm:localization generalized from (C^2)^N with rank-one counts to arbitrary local dimensions and arbitrary-rank local projections, uniformly |
| [`275`](families/275/) | QMA-hardness of continuum Coulomb energy. | prop:nuclear-replacement first bound improved lambda^{-2/3} -> lambda^{-1} for all H^1 u; complement loss lambda^{-4/3} -> lambda^{-9/5} (conditional) |
| [`289`](families/289/) | Strong Kadison–Kastler stability and its spatial boundaries. | lem:free-words: bound 5*sqrt((r-1)!)d^{-(r-1)/2} for all multisets W (manuscript: 7 for distinct labels, unspecified C_r otherwise), scalar-free partitions without matrix units, explicit threshold D_r |
| [`304`](families/304/) | The Hilbert–Smith conjecture in every dimension. | thm:bounded-comparison exponent e_j=3(9^j-1)/4 improved to j via natural two-sided 2^j-transfer |
| [`307`](families/307/) | Failure of rational injectivity for maximal coarse assembly. | Explicit thresholds J(r,n) replacing "sufficiently large j" in top:chern-divisibility/k-divisibility/component-detection |
| [`313`](families/313/) | Finite generation for the $`K(n)`$-local sphere. | d successive p-power restrictions kill the degree-d forgetting kernel: a common subgroup over any char-p field |
| [`315`](families/315/) | The four-dimensional Singer conjecture. | pret:invariant-class generalized to an iff criterion (D_P(B) point <=> invariant finite-interval class) under weaker group hypotheses |
| [`319`](families/319/) | Counterexamples to finite generation at chromatic height two. | obs:growth constant made explicit: v(n)^3 <= D^3 p^6 (3n+4L), c_0=Dp^2(3+4L)^{1/3} |
| [`321`](families/321/) | A counterexample to Wall's finite D(2) problem. | Exact relation gap one for explicit balanced presentations G5,G6 (d_F(R)=n, d_ZG(R_ab)=n-1, Def=0) |
| [`321`](families/321/) | A counterexample to Wall's finite D(2) problem. | Tower theorem extended from rank-one characters to finite-rank local systems; second D(2) example invisible to rank-one characters |
| [`330`](families/330/) | A uniformly discrete counterexample to bounded approximation in Lipschitz-free spaces. | Explicit forest-coupling error c_r^2/(N-c_r) and adaptive transfer bound replacing qualitative lem:local-limit / lem:rare-walks |
| [`333`](families/333/) | Smooth isometric immersions of surfaces into ℝ<sup>4</sup>. | prop:exact-correction generalized to D>=4, polynomially degenerating second form, polynomial jet growth, varying metrics h_z, with R=440 |
| [`347`](families/347/) | Counterexamples to stable-Morse and strong Arnold fixed-point bounds. | Cyclic-integral-sharp fixed-point counterexamples in real dimension 22: #Fix=beta_cyc=80+5312m, SM=80+5344m (deficit 32m) |
| [`350`](families/350/) | Yau’s nodal bounds: surfaces and higher dimensions. | lem:corrugation strengthened: pointwise amplification inf_R\|grad v\|>=rho sup_P\|grad h\| giving all r-moment and convex-energy gains |
| [`352`](families/352/) | A finite-time singularity of Calabi flow. | Profile shooting parameter unique in explicit box radius 5e-10 with 0.37-Lipschitz contraction (manuscript: Brouwer existence) |
| [`358`](families/358/) | A three-manifold without conjugate points or nonpositive curvature. | Attained necessary-and-sufficient endpoint reduction for returning passages, quantitative normal-energy gap, explicit delta_* interval |
| [`359`](families/359/) | Negative Kähler curvature without bounded holomorphic coordinates. | Explicit pinching threshold Lambda=max(1,C,1+2e+41C^2+16e^2/c,8B0^2(B0+C)/c^3) and extension to all horizontal dimensions (manuscript: existence of lambda_0 by contradiction) |
| [`364`](families/364/) | Kinetic limits and fluctuations over the Boltzmann lifespan. | Proof of exp:exposure plus power-complexity extension: p,J up to eps^{-eta} with bound A_p eps^{dp} (manuscript p<=P^a polylog) |
| [`370`](families/370/) | The Lane–Emden and Hénon–Lane–Emden conjectures. | prop:pressure extended to Riesz kernels 0<sigma<n, n>=2, annular log-Lipschitz weights, explicit constants |
| [`373`](families/373/) | Nonattainment of the three-marginal Coulomb Monge problem. | Explicit parameters K=16, r=1e-6, delta=1e-8, beta=1e-10 for lem:local/prop:certificate; Lean selector obstruction generalized to finite families of disjoint embeddings |
| [`376`](families/376/) | Universal computation in forced Navier–Stokes flows. | Scale schedule criterion: all-order rapid decay iff K_{n+1}/K_n -> infinity (manuscript uses K_n=(p_0+10)2^{n(n+1)}) |
| [`377`](families/377/) | Interior $`C^{1,\alpha}`$ regularity for infinity-harmonic functions. | Quantitative three-point flatness D(U) <= min{L, 4096 L^{6/7} eps^{1/7}} (manuscript: qualitative -> 0) |

## 3. Errors found in OpenAI's manuscripts

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


## 4. Verification of OpenAI's results (229 families)

In these families Argus independently re-proved, recomputed or formalized OpenAI's result or its core lemmas. It found no error and no improvement.

| Family | Paper | What was independently verified |
| :--- | :--- | :--- |
| [`001`](families/001/) | Milne’s rationality conjecture and algebraic specialization. | Argus's explicit fixed-marking argument for the realization lemma (one universal b preserves tensors and gives the prescribed period) is supported.; Lean proof of abstract Frobenius identities / central-preimage / simultaneous propagation core (PF-CORE v2). |
| [`002`](families/002/) | The full BSD formula from low Selmer corank. | Reconstruction of alternation-imaginary:alternation: compact conjugate Bockstein pairing has zero diagonal for regular scalars incl. 2, via integral central-extension defect (no division by 2), plus DVR parity consequence; conditional on Milne ADT inputs |
| [`003`](families/003/) | The quasi-Riemann hypothesis. | Kernel-checked proof of the literal interpolation lemma (surjective A:C^4->C^3, product condition >(4N-3)^4) and bounded greedy construction for all tie orders; removes the earlier assumed nonzero-determinant hypothesis of Argus's own prior core, not of the manuscript |
| [`004`](families/004/) | Hilbert’s tenth problem over ℚ. | Canonical natural h^2-clearing for restriction diagrams killed by h, and h^2 is optimal for clearing factors natural on all such diagrams (Z/h^3 with 1+h^2).; Algebraic coherent-family package (integral homotopies, normal forms, adjugates giving u_F=-p^-2, u_S=p^-2, strict torsion (O/p)^2) supported and freshly Lean-compiled. |
| [`005`](families/005/) | Irrationality of Catalan’s constant. | Odd-prime valuation bounds eq:odd-lower-pair-range / eq:odd-two-layer-bound for arbitrary p-integral rows with stated supports, arbitrary gamma, singular matrices (claimed as an improvement, but already implicit in the manuscript) |
| [`006`](families/006/) | Goldfeld’s conjecture: densities and mean analytic rank. | Abstract theorem: from char-2 trace identities, build an exponent-2 unit-valued character agreeing with the trace on roots (Lean-formalized).; Conditional proof of weighted CM comparison a_M(D)=c0 2^{omega(N)} zeta_M(D) lambda_M(red(LP_D)) mod 2^M. |
| [`008`](families/008/) | The Deligne–Drinfeld conjecture. | Rational all-weight upper bound (C_UB_ALL): Lean theorem for every n>2 plus separate weight 0,1,2 arguments (reproduction of manuscript bound).; Weights 0,1,2 exhaustive rational Lie arguments with exact replay. |
| [`009`](families/009/) | Function-field reconstruction from Milnor K-theory and Galois data. | Alternate Lean proof of the manuscript's local intersection proposition. |
| [`011`](families/011/) | Prime-factor statistics of $`p-1`$. | Local factorial-operator and rank/fresh-birth combinatorics verified (Stirling-coefficient identity, <=2r edges), with a delimited formal core |
| [`012`](families/012/) | Independent largest prime factors of consecutive integers. | Deterministic finite cut-norm response/deletion inequalities, freshly Lean-compiled.; Additive finite expectation/probability bound supported by universal prose proof. |
| [`016`](families/016/) | Zilber–Pink in abelian varieties and the Siegel threefold. | Shared interpolation/zero-estimate layer and descent reproduced; application units are conditional reproductions |
| [`019`](families/019/) | The local <i>p</i>-adic section conjecture and global consequences. | Verification of manuscript lem:etale-collars: one connected finite etale cover giving prime-to-p coordinate roots on concentric subcollars (genus >= 2).; Small Lean core (compact rational-value exclusion, integer arithmetic). |
| [`020`](families/020/) | Squarefree quartics and power-free polynomial values. | Finite adaptive deletion bound E(bad fraction) <= (B0-1)/T + D/(n-l-T+2) proved; generic core Lean-compiled.; Actual-kernel insertion/deletion comparison supported. |
| [`021`](families/021/) | A quadratic bound for Jacobsthal’s function. | Finite rigidity/CRT arguments; Lean kernel compiles.; Polynomial vanishing at rich points proved. |
| [`023`](families/023/) | Patterson's first moment for cubic Gauss sums. | Abstract exponent theorem (r=2/3 forcing, Gram-gap contradiction) Lean-compiled.; Finite-degree construction a >= 1/(20M), degree <= 28M. |
| [`024`](families/024/) | An asymptotic formula for the number of totients. | Exact root brackets 27/50<rho<109/200, 3/5<log(1/rho)<2/3, with full tail bound.; Finite tuple recovery/endpoint monotonicity freshly Lean-compiled (v2). |
| [`027`](families/027/) | Potential integral density on curve character varieties. | Punctured-disk reconstruction and complementary-swap gadget (no division by 2) reproduced as universal local algebra |
| [`029`](families/029/) | Primitive roots for every admissible integer base. | Local shell induction / masked Fourier / quadratic exponent algebra supported (supplied-data scope).; All-dyadic reflection implication supported as a conditional analytic implication. |
| [`030`](families/030/) | Modularity of elliptic curves over imaginary quadratic fields. | Geometric-prime-switch bridge (integral homology generation, simultaneous monodromy shears, character evaluation) supported under exact hypotheses; 11 abstract algebra theorems in Lean. |
| [`031`](families/031/) | Uchida’s conjecture for open homomorphisms of Galois groups. | Conditional Kummer completion lemma.; Exact formula dim(U_S (x) Q_l)^theta = sum_{v in S/Delta}[theta\|D_v=1] - [theta=1]. |
| [`032`](families/032/) | The rational Hodge conjecture for CM abelian varieties. | Actual independent derived classical images for dimension <= 6 with imaginary-quadratic action.; All-degree CM supply with rational Hodge lifts for dim <= 5 or rational hyperbolic Hermitian (3,3) sixfolds. |
| [`036`](families/036/) | Numerical semiampleness and generalized minimal models. | 25 Lean theorems (universal algebra, scalar interfaces) freshly compiled.; Reconstruction of finite-data theorem (Langer, Stacks, Nitsure inputs). |
| [`038`](families/038/) | Fujita’s freeness conjecture. | Uniform restriction-image bound for every integral moving center and large degree, reproducing the known argument.; Pure Taylor initials, bounded cube, weighted old-slice growth and exact d/2 moment error verified (prose). |
| [`040`](families/040/) | Bloch’s conjecture for complex surfaces. | Arbitrary-length retained-output induction (decreasing n1+n2) reproduced; the manuscript already contains the recursion.; EGL nested geometry and signed all-degree formula c_k(-I^vee)=(-1)^k c_k(-I) verified. |
| [`041`](families/041/) | Hyperkähler SYZ and projective-space bases. | Conditional Cartier-adjoint field/subring theorem freshly compiled in Lean (p-basis/Cartier data as hypotheses).; Hodge-module/Spencer argument for ordinary differential generation on char-0 charts supported. |
| [`043`](families/043/) | <i>P</i> = <i>W</i> for fixed-determinant SL<sub><i>n</i></sub> moduli spaces. | General finite-etale transfer theorem (rational Hodge-Tate/curious Lefschetz, integral local constancy, natural base change) reconstructed in prose.; Reconstructs the manuscript's betti:lefschetz: for g>=2, composite n>=4, gcd(n,d)=1, full rational Betti cohomology is Hodge-Tate and e^i: Gr^W_{2R-2i}H^m -> Gr^W_{2R+2i}H^{m+2i} is an isomorphism, … |
| [`044`](families/044/) | The equivariant cohomological Hikita conjecture. | Weekes dressed-subset generation and the source's Laurent proof read and supported conditionally.; Manuscript kernel inclusion argument checked (conditional on BFN/Hom/vanishing-cycle interfaces). |
| [`051`](families/051/) | Kobayashi’s canonical-ampleness conjecture. | Literal bridge (initial frame, boundary-unitary frame for 2<rho<4p/(p+2), differentiation, determinant, Hessian identities) supported; already present in manuscript.; Weak boundary flux identity for continuous positive W^{1,2} matrices supported. |
| [`052`](families/052/) | Tangent splittings and product decompositions. | lem:rational with explicit m=2d+1 for coordinate-pair relations (claimed as an improvement, but already implicit in the manuscript) |
| [`053`](families/053/) | A counterexample to Pixton completeness in Chow. | All-arity bare-moment formula E_m=U exp(C_m p^m/m!) and transfer reproducing the manuscript's first hyperplane coefficient; Quot localization relation conditionally supported |
| [`054`](families/054/) | Irrational cubic fourfolds with Hodge-theoretic and categorical K3 associations. | Theorem gw:blowup splitting T_Y=T_M + T_Z(-1), G_Y=G_M x Q id reproduced with integral reconstruction core |
| [`057`](families/057/) | Fundamental groups of special complex varieties and root orbifolds. | Conditional weighted-inverse lemma (exactness, closed ranges, uniform inverse bound) supported given the scalar gaps.; Local Chern-adjoint Bochner estimate re-derived (retiring an unverified Demailly dependency). |
| [`059`](families/059/) | Counterexamples to Zariski’s multiplicity conjecture. | M45 integral Seifert congruence, tube identification, local Milnor-number formula mu=24ab+6a+6b+51 and topology implication reproduced with exact jet computations |
| [`062`](families/062/) | Projective contact classification and the LeBrun–Salamon conjecture. | Local geometric proof of the manuscript's des:descent (all-sheet splitting, ramification germs, purity, degree-one descent) supported with no added hypotheses.; Positive quotient/annihilation and dominant evaluation given a free covering family. |
| [`064`](families/064/) | Topological triviality of <i>μ</i>-constant surface singularities. | Empty-simplex/basis argument for every coefficient set in vertical dimension <=3 (reconstruction of manuscript prop:marked-monomial-reduction).; Projective normalized-blowup marked globalization. |
| [`065`](families/065/) | Virasoro constraints for complete intersections and projective-bundle towers. | Normalized simultaneous factorization S_W = R S_bl reconstructed under explicit inputs.; All-m,r moving Euler class m! a^m prod_{k<m} P_E(-lambda+ka) computed. |
| [`067`](families/067/) | The Campana–Peternell conjecture in dimension six. | Exact rational implication: all normalized kernel products satisfy 32-20eta1+3eta1^2=0 (modular rank bounds (516,65,60,69), cubic nullity <=6); manuscript's finite-ratio lemma reconstructed and replayed.; Actual minimal-family quadratic via splitting, descent, Hodge, GRR. |
| [`073`](families/073/) | The Falconer distance conjecture. | Manuscript block-policy recursion formally encoded: C_ENGINE@3 compiled (Lean 4.31.0, standard axioms) -> conditional_kernel.; Exact finite replay (20 instances, 29,624 row checks). |
| [`075`](families/075/) | The $`L\log L`$ Fourier-convergence conjecture. | Argus Lean formalization of the manuscript's finite adaptive search + logarithmic specialization (v2) freshly replayed (exit 0, no holes).; Context bounds, gluing and partial offers supported in stated scope. |
| [`080`](families/080/) | The exact Sobolev endpoint for Schrödinger convergence. | Quartic growth eq:src22 via two-curvature-derivative argument, no fixed temporal support (claimed as an improvement, but already implicit in the manuscript) |
| [`082`](families/082/) | Annular variation and dyadic absolute bounds for the triangular Hilbert transform. | Kernel-checked proof of lem:mixed-trace \|tr(D0W0D1W1D2W2)\| <= (5/3)D* sum b(U_v) for arbitrary complex maps/singular Grams, covering all three manuscripts' versions; no improvement of constant claimed |
| [`083`](families/083/) | Hilbert transforms along Lipschitz directions. | boundary-loss bound 2eps(1-G^-k)/(1-1/G) log(n/h_T) (claimed as an improvement, but already implicit in the manuscript) |
| [`086`](families/086/) | An <i>L</i><sup>3</sup> bound for the trilinear Hilbert transform. | lem:finite-sparse-count exponent delta^{1/2080} -> delta^{1/810} (claimed as an improvement, but already implicit in the manuscript) |
| [`089`](families/089/) | Bounded-distortion <i>L</i><sub>1</sub> embeddings of planar and bounded-treewidth graphs. | Restricted packing constant 1600000002 -> 800160050 (claimed as an improvement, but already implicit in the manuscript) |
| [`090`](families/090/) | Triangular-lattice optimality, long-range Riesz and Coulomb energies, and spherical … | Independent exact (rational/interval) reconstruction verifying prop:exact-interpolation and prop:global-signs for all alpha>=1 and all radii; continuous extension of the coefficient family to z=0 |
| [`091`](families/091/) | Logarithmic and <i>L</i><sub><i>p</i></sub> Brunn–Minkowski inequalities and the … |  |
| [`092`](families/092/) | The optimal order of convex-body covering density. | prop:pattern-tail for arbitrary indexed real centers with log-loss (2k0+5/2)log n (claimed as an improvement, but already implicit in the manuscript) |
| [`094`](families/094/) | Subpolynomial dimension reduction in <i>L</i><sub><i>p</i></sub>. | Ramp estimates for every real p>2 with explicit constants, general tapers, order-sharp in ell (claimed as an improvement, but already implicit in the manuscript) |
| [`095`](families/095/) | Hyperbolicity cones without semidefinite lifts. | Exact verification of seed theorem: real PSD Hankel form of rank 20 with dim K=16, injectivity of Sym^2 K -> quartics, dim(J H0)=321; explicitly verifies, does not strengthen |
| [`096`](families/096/) | The Gaussian propeller conjecture in every dimension. | Kernel-certified finite algebraic obstruction (m>=5 cells) with slightly relaxed constant 23/25>(3/pi)^2, implying the manuscript's obstruction; analytic reduction uses two external theorem inputs |
| [`098`](families/098/) | Compact counterexamples to bi-Lipschitz dimension reduction. | Independent analytic proof of the energy-to-crossing implication of main.tex Sections 3-5 (compact lexicographic control, E_H/E_V energy bounds, separated crossing offsets), allowing rectangles/sheets/width to vary; doubling constant 76800 and Banach/L_p transfers not audited |
| [`100`](families/100/) | Cylinder coverings below the half-area bound. | Exact rational certificate that the manuscript's 16,000,000 triangular-base cylinders cover the closed tetrahedron and have S/sqrt2 < 1/2 - 1/(2*10^9), independent of the paper's Taylor/quadrature estimates; explicitly not a new construction |
| [`101`](families/101/) | The sharp simplex conjecture for isotropic constants. | Lemma mat:commutator (constant 42/37) proved for arbitrary dimension, any number of matrices, nonsymmetric w_r, via square completion; Lean-checked |
| [`102`](families/102/) | The Unique Games Conjecture and optimal approximation thresholds. | Verification of lem:latent-generic and the latent separation chain; adds an explicit genericity rate (nongeneric fraction <= 2A/q) where the manuscript only says probability -> 1 (an effective rate, not a better bound), plus a characteristic-two polynomial obstruction in Lean |
| [`103`](families/103/) | Exact derandomization of logarithmic space: $`\mathsf L=\mathsf{RL}=\mathsf{BPL}`$. | Conditional verification of the adaptive escape/collision accounting step behind prop:fp-coupling, under explicitly stated child-norm, raw-difference and compression hypotheses; the main fp-coupling claim and thm:main remain unverified |
| [`104`](families/104/) | Quasipolynomial algorithms for mean-payoff, stochastic and parity games. | Two-pass Label procedure core verified (termination plus Max/Min witness claims) over the finite-box interface; game reduction, bit bound, randomized/stochastic/parity extensions all deferred |
| [`106`](families/106/) | Hardness of coloring three-colorable graphs. | Finite-pattern, minimax and rationalization steps of the alignment proof checked |
| [`109`](families/109/) | Integer multiplication below $`n\log n`$. | Exact verification of lem:scalar-motifs, lem:motif-residuals, prop:bit/complex-motif-interface at h=100 with all roles and scratch, and a parametric extension to all h>=40. No improved multiplication exponent is claimed |
| [`110`](families/110/) | Optimal-order randomized <i>k</i>-server on arbitrary metrics. | prop:anchor-travel verified with an explicit constant (T_anchor <= 1400 C0(V+lP+lQ)+...) where the manuscript has an absolute C, plus an affine-offset/multi-mover extension whose novelty is unresolved |
| [`111`](families/111/) | One-sample matroid prophet inequalities against an almighty adversary. | Source-fidelity/interface audit of the upstream full-seed Lean development (seed law, nonanticipation, one-sample glue, scan correspondence); keeps the stated 2^-293 constant, no improvement |
| [`114`](families/114/) | Approximate counting of common integer polymatroid bases. | Balanced summation preserves the one-positive-direction removal signature, and root-direction pair counts are log-concave with interval support. Both are Lean-checked verifications of manuscript ingredients |
| [`115`](families/115/) | Sampling and counting contingency tables with arbitrary margins. | Laminar log-concave two-removal signature core verified (at most one positive direction under balanced pair sums); application is conditional on the manuscript's interval/forest inputs |
| [`116`](families/116/) | Uniform black-box noncommutative identity testing across characteristics. | thm:order (ord_z(uHv) <= nu*binom(m,2)) independently proved over every field, without minor-valuation invariance (drops the unused deg Q hypothesis), and Lean-checked; word-series independence over F(t) proved |
| [`117`](families/117/) | Uniform sparsest cut: hardness and semidefinite gaps. | lem:quadratic-correction to degree d<q-1 with 27gamma+3delta<1 (claimed as an improvement, but already implicit in the manuscript) |
| [`118`](families/118/) | Bin packing and unbounded configuration-LP gaps. | Reproduction of the structural gap theorem: for every c, an instance with 5B items in (1/6,1), both configuration LPs = B, OPT > B+c, by porting the 44-file upstream Lean proof to Lean 4.31.0 |
| [`119`](families/119/) | The Courtade–Kumar and Hellinger conjectures. | Lemma scalar assertion (1) (pair inequality) verified over all 21 normalized parameter boxes with exact algebra; main Hellinger theorem and induction not audited |
| [`120`](families/120/) | Almost-linear-time exact matching and prescribed-degree factors in general graphs. | Raw-length transfer 14ZA max{L,O} -> 5ZA max{L,O} (claimed as an improvement, but already implicit in the manuscript) |
| [`121`](families/121/) | Almost-linear approximation of edit distance. | thm:refinement (d_S >= c/a, E[(d_S-c)+\|U] <= c/l) verified for every fixed good seed |
| [`124`](families/124/) | Polynomial-time scheduling on three identical machines. | Zero-hole Lean formalization of the hierarchy-existence theorem (every feasible schedule has a bounded hierarchy whose node/split descriptions have <500 leaves), plus a finite 48-job certificate |
| [`125`](families/125/) | The metric <i>k</i>-median approximation threshold and recovery. | Literal thm:finite-inequality and lem:scalar-bounds verified on full domains |
| [`128`](families/128/) | A factor-two approximation for shortest common superstring. | Constructive verification of lem:host (host and requesters rooted within q plus reserved budgets), with kernel-checked components; the rest of the approximation proof is not audited |
| [`129`](families/129/) | Exponential state costs for two-way automata. | Nesting absorption, containment and chain-count lemmas (sum of losses <= 2\|J_0\|) verified for all m, with an exact merger example; main deterministic/complementation theorems not audited |
| [`130`](families/130/) | Exact Fourier transforms below $`n\log n`$. | h=100 network assertions net:edge, net:residuals, net:finite-interface verified with exact W, s, Delta |
| [`131`](families/131/) | Rapid mixing of graph switches for every degree sequence. | Ordered disjoint sum D is PSD for every graphical degree vector; full graph-specific Lean proof |
| [`133`](families/133/) | The computational complexity of Weisfeiler–Leman refinement. | comp:reduction (compressed consistency reduction to the (r+1)-pair bijective game on diameter-2 graphs of order O(m^6)) and exact projection EP verified for arbitrary dimensions/padding |
| [`134`](families/134/) | Generalized star height at most three. | Height-three decoder soundness/completeness verified under recorded inputs |
| [`135`](families/135/) | Homogeneous depth-five lower bounds for iterated matrix multiplication. | Four-path second-trace expansion, occupation moments, path counts and factorization behind eq:moment-reduction verified; a boundary example shows the nonadjacent-layer hypothesis is needed (outside manuscript hypotheses) |
| [`136`](families/136/) | A quasilinear PCP theorem for PPAD. | Fixed-radius correction under complete-product request laws (support contraction, tables, cones, smoothness) proved with explicit budgets; it extends to any fixed number of row axes, a modest strengthening of the interface |
| [`137`](families/137/) | One-tape time simulation in two-fifths-power space. | Weighted-evaluation Add schedule, storage and epoch path bounds, plus realization/replay semantics verified |
| [`138`](families/138/) | Subset Sum in $`O(2^{0.49n})`$ time. | thm:checksum verified with rigorous continuous and all-finite-P moment enclosures (< 2^0.5168/0.5169), coverage, match kernel, error and cost bounds; it also shows that the plain uniform-frequency second-moment route cannot suffice |
| [`139`](families/139/) | Subpolynomial query complexity for log-concave sampling. | Independent proof of thm:tensor-divergence and cor:path-derivatives; cumulant split bound N^(3N)beta^(N/2) |
| [`140`](families/140/) | Memory–sample lower bounds for noiseless Gaussian regression. | Exact Gaussian collision identity h:proj:gaussian (det(D^TD+delta^2(I+11^T))^(-m/2)) verified for all tuples incl. repeated points and k-1>d; smoothing-moment bound with full-mass factor |
| [`142`](families/142/) | Deterministic polynomial factorization over prime fields. | norm:solve verified deterministic poly-time; diagnostic q=3 over F_19 recovers h=X-Y |
| [`143`](families/143/) | Hilbert's sixteenth problem: uniform bounds for limit cycles. | Universally quantified real-algebraic proof of the endpoint sign obstruction implying model:zero-sign (two-limit-cycles.../model.tex:566), incl. boundary cases, formalized in Lean |
| [`144`](families/144/) | Banach’s simple Lebesgue-spectrum problem. | Full lem:signal, lem:fast-average, lem:law-approx verified; Ramanujan-sum sieve kernel in Lean |
| [`145`](families/145/) | Rokhlin’s multiple-mixing problem. | Square-locality implies commuting active projections and compact abelian group factor; verifies lem:contraction-completeness and prop:common-exact-lines |
| [`147`](families/147/) | The near-boundary Birkhoff conjecture. | thm:lens-lines and thm:lens-points (04-continuation.tex) verified via finite algebraic core isolation, all k>=2 |
| [`150`](families/150/) | Weak mixing of triangular billiards with an irrational angle. | Bounded-eigenfunction rigidity proposition reproved without square-summable gradient assumption |
| [`151`](families/151/) | A <i>C</i><sup>1</sup> counterexample to the entropy conjecture. | Global verification of the C1 zero-entropy map with eigenvalue 2 on H2; arbitrary-duration passage theorem in Lean; homology spectral radius exactly 2 |
| [`154`](families/154/) | Pointwise multiple ergodic averages for mixing transformations. | lem:row-maximal and lem:row-depth verified for every schedule, arbitrary Hilbert dimension |
| [`155`](families/155/) | A counterexample to periodic tiling in dimension three. | Shared-seed activation/inverse lemmas verified in Lean for all labelled partitions |
| [`156`](families/156/) | Borsuk's conjecture fails in dimension nine. | Full chain checked: projector set X_4 cannot be covered by 10 sets of diameter <sqrt2, via continuum bridge and Lean/RUP-certified ten-label combinatorial obstruction |
| [`157`](families/157/) | Graph coloring, clique minors, and Colin de Verdière invariants. | Annihilator and protected-reduction linear-algebra lemmas in Lean |
| [`158`](families/158/) | The Euclidean plane cannot be colored with five colors. | OpenAI released Lean proof ported to Lean 4.31 and compiled; unrestricted no_unrestricted_five_coloring with standard axioms |
| [`159`](families/159/) | Erdős’s reciprocal-sum conjecture and quasipolynomial Szemerédi bounds. | Common-derivative to graded factorization reduction verified; algebraic core in Lean |
| [`160`](families/160/) | Superexponential van der Waerden numbers. | count:local and longer-period branch of dichotomy:main verified with explicit word count (801Dh)^(6D) and threshold k>=2^20 |
| [`161`](families/161/) | Counterexamples to Sidorenko’s conjecture and the forcing conjecture. | Singular-tail contribution O_D(q^(-1/6)) proved conditional on local-gain and orbit-count premises |
| [`162`](families/162/) | Counterexamples to Ryser’s covering conjecture. | Native Lean 4.34.1 replay of OpenAI balanced theorem (668 modules) plus independent Lean 4.31 core |
| [`165`](families/165/) | The Harary–Hill and Zarankiewicz crossing-number formulas. | lem:cycles / lem:cycle-pairing (corrected pairing vanishes on all real cycle pairs) independently proved, Lean core |
| [`167`](families/167/) | Planar distinct distances and unit-distance bounds. | alg:private-valuations and unused-sign-change obstruction verified over K_0(V_1) |
| [`169`](families/169/) | Shareshian–Wachs elementary positivity. | alg:coproduct (03-reordering.tex:505) verified; polynomial-image descent in Lean |
| [`170`](families/170/) | Sharp logarithmic exponents for off-diagonal Ramsey numbers. | learn:high-moment E[(T*)^p\|O]<=B^p exp(-pP/10) proved conditionally; finite linear-incidence version |
| [`171`](families/171/) | The hypercube Ramsey conjecture. | Section 18 late-prefix bridge verified conditional on six premises |
| [`173`](families/173/) | Seymour’s second-neighborhood conjecture. | Arbitrary-relation pruning lemma verified; kernel core in Lean |
| [`176`](families/176/) | The second Kahn–Kalai conjecture with an edge-count bound. | Original lem:reduction (16) formally verified in Lean |
| [`177`](families/177/) | Bounded-degree coboundary expanders. | lem:stabilization and lem:trivial-action verified for all odd characteristic, conditional on two external theorems |
| [`178`](families/178/) | Deterministic nonbipartite Ramanujan graphs in every fixed degree. | lem:early-high-moments (original-33) implication proved with explicit C*=64+8192H |
| [`180`](families/180/) | Barnette’s Hamiltonian-cycle conjecture. | Independent proof of prop:forest-state (a pair with Q_s a forest exists whenever a pair exists) via sign-reversing involution and nonzero pair polynomial; algebraic coefficient lemma Lean-checked |
| [`181`](families/181/) | The Erdős–Gallai cycle-decomposition conjecture. | Proof of the expander routing lemma (balls grow to >r/2, team-routing with edge-disjoint short paths when h>=64(l^2(k+b)+z)), Lean-checked root-routing core |
| [`182`](families/182/) | Power savings for intersective polynomial differences and prime arguments. | Literal tuple assertions verified uniformly in the auxiliary index for all large p |
| [`183`](families/183/) | Power savings for planar halving lines and <i>k</i>-sets. | Noncollapse/zoom-radial step for rank homeomorphisms proved (signed identity limit of normalized rank zooms) |
| [`185`](families/185/) | Counterexamples to infinite matroid intersection and packing/covering. | Full ZFC thm:main (two self-dual matroids with no covering / packing-covering partition) checked in Lean 4.31.0 with standard axioms only; this re-checks OpenAI's existing unconditional formalization plus explicit witness statements |
| [`186`](families/186/) | Uniform influence and sharp thresholds for graph and hypergraph properties. | Hypergraph block-capture lemma (with real cutoff bridge) Lean-certified; variance/influence lemmas reproved |
| [`187`](families/187/) | Snaky in 21 Maker moves. | Certificate replay of the 728-card composition |
| [`189`](families/189/) | Cycle–clique Ramsey numbers. | OpenAI's Lean solution recompiled under Lean 4.31.0 with compatibility shims and statement-fidelity bridge; zero holes |
| [`191`](families/191/) | A power improvement in the Heilbronn triangle lower bound. | Weighted zero-determinant count for box matrices (<=10^33 log(2N) N^6/I^2) reproved, Lean-checked core |
| [`192`](families/192/) | Boolean functions violate the square-root degree bound by arbitrary factors. | All-C Boolean violation reproved with explicit width m=2^1024+1, explicit gain eta0=2^{-11143m-1} and universal cancellation core in Lean; quantitative explicitization of an already-qualitative manuscript result |
| [`193`](families/193/) | Serre’s intersection-multiplicity conjecture. | as:base-equality chi_ord = rank*chi_A = chi_C verified with filtered spectral-sequence inversion; nonflat test example satisfies hypotheses |
| [`194`](families/194/) | Lech’s multiplicity conjecture. | Explicit A_h=max{h,3(h-1)h^{h-1}/(2(h-1)!)} in thm:complex; leading coefficient 1 sharp (non-Noetherian Koszul family) (claimed as an improvement, but already implicit in the manuscript) |
| [`196`](families/196/) | A counterexample to Kaplansky’s zero-divisor conjecture. | Topology step (arrangement exclusion => asphericity, torsion-free pi_1) and entropy counting mechanism verified; cone-chain exactness in Lean |
| [`198`](families/198/) | A counterexample to finitistic-dimension finiteness. | lem:rectification verified with all hypotheses (square-zero differential, right-projectivity, homotopy inverses), large Lean development |
| [`199`](families/199/) | Counterexamples to Auslander–Reiten, Tachikawa and related homological conjectures. | AR algebra, cocycle data and lift:main verified literally over F_2(q,H1,H2) incl. all 104976 cocycle equations; trace-ring core in Lean |
| [`200`](families/200/) | Eisenbud–Green–Harris and lex-plus-powers. | thm:division index computation verified incl. p-adic truncation lemma |
| [`201`](families/201/) | A counterexample to Kurosh’s division-ring problem. | Hub-nullspace identified exactly without rank bound; rank defect after arbitrarily many columns; projector argument with nonzero orthogonal idempotents (claimed as an improvement, but already implicit in the manuscript) |
| [`203`](families/203/) | Donovan's conjecture over fields and complete mixed-characteristic DVRs. | prop:single-cycle transport A=epsilon B verified incl. nonuniform characters; descent algebra checked |
| [`206`](families/206/) | Finite lattice representation and undecidability. | pkt:field-shifts verified: admissible normalizer forces h \| s-a |
| [`207`](families/207/) | The ℓ¹-Bass conjecture for all discrete groups. | pf:terminal-singular proved with explicit constants 4,36,11 for sign/order kernels and Pfaffian bound |
| [`208`](families/208/) | Finite symmetric tensor categories and the Verlinde tower. | Comparison lemma generalized to Ext-rigidity criterion Ext^1_G(T,Sym^j V*⊗T)=0 (claimed as an improvement, but already implicit in the manuscript) |
| [`212`](families/212/) | Planar first-passage geometry and the absence of bigeodesics. | lem:cut-transfer proved under manuscript hypotheses; deterministic barrier core in Lean |
| [`213`](families/213/) | Critical percolation on every quasi-transitive graph. | Entropy/overlap lemma for adaptive algorithms proved for all sizes with explicit constant; upstream Lean comparator proofs noted to contain sorry (by design) |
| [`214`](families/214/) | The Benjamini–Schramm nonuniqueness conjecture. | Joint-undo switching injectivity/Bernoulli comparison verified; Lean core |
| [`216`](families/216/) | Critical and near-critical XY scaling and BKT universality. | lem:profile-pins transfer proved completely with explicit moment-to-reach modulus; cubic modulus shown optimal for the abstract deficit data |
| [`218`](families/218/) | Conformal universality for weakly interacting and random-bond Ising models. | Balanced Vandermonde second-moment identity rad:identity proved in Lean for all even cardinalities; charge cancellation recovered (report explicitly claims no new math) |
| [`220`](families/220/) | Directional zero–one laws beyond iid environments and iid ballisticity. | Independent verification of prop:first-contact (stopped-posterior argument does not silently use iid rows) |
| [`222`](families/222/) | Perceptron free energies and microscopic jamming exponents. | Independent rigorous verification of the manuscript's endpoint inequalities lambda(a_-)>a_-, lambda(a_+)<a_+, including stationary profile existence/uniqueness, tails and ground-state identification |
| [`223`](families/223/) | Random-cluster interfaces: critical, disordered, thermal, and natural-time scaling. | Universal proof of thm:pressure (nonnegative coefficients of -log F_H incl. repeated labels, connected support, convergence beyond unit polydisk) and the incident-edge Rayleigh negative-correlation lemma, via hard-core polymer reduction |
| [`229`](families/229/) | Exact three- and four-state reconstruction thresholds and four-state tree capacity. | Replayable universal sign certificate for the four-state A-product and H-product polynomial inequalities (all 24 permutations, boundary extension) underlying threshold Prop 3.1-3.2 |
| [`233`](families/233/) | The joint critical Ashkin–Teller current limit. | Universal verification of the full-spin witness / monochromatic-loop localization step, with partition-rank iteration needing at most n-1 localizations (proof-technique refinement) |
| [`234`](families/234/) | All-temperature pressure of orthogonally invariant Ising spin glasses. | Independent proof of Lemma cav:quadratic (build/50-cavity.tex:453-510) and cav:evaluated / spin-test identities for every finite depth and dimension, with abstract matrix-ladder extension |
| [`235`](families/235/) | Limiting random SAT thresholds, sharp variance and computability. | Universal verification of ct:old-records and ct:new-record |
| [`237`](families/237/) | The three-quarter exponent for honeycomb self-avoiding walk. | All-width verification of the strip arch/Pfaffian formula m(X) (transfer, reflection, gluing, degree bound, interpolation, convergence) |
| [`240`](families/240/) | Shelah's eventual categoricity and the prescribed-threshold obstruction. | Verification of the reversal/elimination argument for eventual categoricity foundations (directed colimits, order templates, orbit bound, persistence, elimination) |
| [`241`](families/241/) | Rigidity of the Turing degrees. | Machine-checked recovery core: stage-bit reduction and strict-cut decoder recovering irrational t from F-values under countable-fiber Borel F with F(x+y)<=_T F(x) join F(y) |
| [`242`](families/242/) | Single-fold Diophantine representations and undecidability under an at-most-one-solution … | Kernel-checked single-foldness of the representative/bracket/square-window growth construction and paired-Pell composition for abstract height sequences |
| [`243`](families/243/) | Separating choiceless counting from polynomial time and witnessed choice. | Model-fidelity bridge: manuscript counting CPT embeds in pinned upstream FullCPT formalization, conditional on GSW Theorem 18; finite checks |
| [`244`](families/244/) | The Partition Principle does not imply Choice. | Universal verification of probe-extension normal forms (left cancellative, conical, least-old-multiple gate, conditional joins) and conservative simulation lemma mono-simulation |
| [`245`](families/245/) | Weak normalization implies strong normalization in pure type systems. | Kernel-checked conditional guarded-diagonal (Hurkens-style) chain and typed probe bridge macros |
| [`246`](families/246/) | Cannon's conjecture. | Separated-capacity lemma quantified: capacity >= c min{a^{d-gamma D}, a^{tau D-(Q-2)d}/M(D-d)} >= c' a^{gamma D} (claimed as an improvement, but already implicit in the manuscript) |
| [`248`](families/248/) | Thompson's group <i>F</i> is nonamenable. | Verification of the realized-boundary construction (dyadic partitions, pair transport, covariance, variance bound E\|\|z_i-m\|\|^2<=4/D+4(1-1/D)eta) and hole-free replay of upstream finite-boundary Lean under Lean 4.31 |
| [`249`](families/249/) | A finitely generated Eilenberg–Ganea counterexample. | Kernel-checked relator alignment / P,Q,P shear stabilization and finite word shear lemmas |
| [`250`](families/250/) | Boone–Higman embeddings with higher finiteness. | Kernel-checked compiler validator, simulation, component and exit-bridge lemmas for lem:compiler |
| [`252`](families/252/) | A torsion-free hyperbolic group that is neither residually finite nor linear over any … | Independent derivation of the finite-quotient obstruction (trace bounds, half-rank lemma over F_q, Lagrange tensor identity), with slight strengthening rank>r^2D/(2(2r-1)) and non-strict budget variant |
| [`253`](families/253/) | An infinite finitely presented simple amenable group. | Uniform deterministic verification of partition transport for convex translation-chart systems, generalized to any finite nonparallel direction system without the large-a condition |
| [`254`](families/254/) | Classifying spaces and geometric obstructions for Artin groups. | Statement-faithful proof of N_OBSTRUCTION |
| [`256`](families/256/) | Nonsingular systems of equations over arbitrary groups. | Universal verification of thm:fixed-space (simultaneous fixed-space dimension via U(k) cohomology incidence pairing), incl. unequal sizes and repeated occurrences |
| [`258`](families/258/) | Gersten’s conjecture and virtual compact specialness of one-relator groups. | Verification of row:restriction including all U-orbit summands |
| [`263`](families/263/) | The ionization and generalized ionization conjectures. | Analytic verification of the four screening lemmas (positive-field, patch, count, density) for correlated finite-sector states |
| [`266`](families/266/) | Exactly three mutually unbiased bases in dimension six. | Universal exact verification of prop:pair-certificate and the order-six Hadamard alpha-character dichotomy |
| [`267`](families/267/) | Positive-temperature Bose–Einstein condensation and exact quantum depletion. | Source-retaining two-protocol comparison proving long:product relative to explicit local inputs; hypergraph marginal product bound |
| [`268`](families/268/) | The spin-one Haldane gap. | Verification of prop:transfer (periodic twisted partition functions) and boundary pairing via chronological history operator |
| [`270`](families/270/) | Threshold and positive-energy bound states of the BFSS matrix model. | Verification of prop:test-lifts with general graph-norm/moment-free multiplier stability and exact Clifford algebra |
| [`271`](families/271/) | Bloch's law, its lattice correction, and the spherical magnetization law. | Verification of lem:trace-zero-free and its Section 7 application |
| [`272`](families/272/) | Entanglement without distillable secret key. | Exact verification of the dimension-ten PPT pair: composite Choi matrix nonzero, range has no product vector, rank exactly 80, twenty rank-loss directions |
| [`273`](families/273/) | The entropy photon-number inequality. | Proof of int:stieltjes with the entire representing measure identified explicitly (nu({0})=1/2, density w(r), c=0) |
| [`276`](families/276/) | Classical capacity of generalized amplitude damping. | Verification of thm:thermal entropy lifting for rectangular blocks, relying on Tang triangular inequality |
| [`277`](families/277/) | Threshold repetition for entangled games. | Verification of prop:song-conditioning bridge to threshold repetition, extending the rate to every length |
| [`278`](families/278/) | Failure of Kohn–Sham ensemble representation. | Verification of the cutoff/slow/plane/crossover estimates; prior nodal-rate observation located (arXiv:1109.2204) |
| [`279`](families/279/) | Exact quantum factoring over a fixed finite gate set. | Verification of prop:order-trial and lem:majorant with stronger envelope bounds \|I(u)\|>=1/(2d), S>=1/(8d) and sharp interval constant 1/2 (minor) |
| [`280`](families/280/) | Unitary vertex operator algebras and conformal nets. | Verification of thm:energy optimal order d-1 and cor:locality |
| [`282`](families/282/) | From scale symmetry to local conformal symmetry in four-dimensional QFT. | Verification of D:subtractions/D:two-horizon via null-rotation covariance and Hilbert-valued regularization |
| [`283`](families/283/) | Polynomial-time unitary synthesis from a Boolean oracle. | Exact verification of fields:unitary/gram/sparsity/error bound; minor variant over (Z/p)^(L+1) |
| [`284`](families/284/) | The optimal quartic separation between randomized and quantum queries. | Verification of tournament selection and lem:amplification with explicit query cap |
| [`286`](families/286/) | Rigidity and arithmetic of lattice von Neumann algebras. | Conditional verification of lem:transfer-disjointness frame/parallel steps |
| [`287`](families/287/) | Isomorphism of the free group factors. | Verification that the polynomial unitary flow preserves all trace moments |
| [`288`](families/288/) | Kadison's similarity conjecture. | Verification of lem:invariant-intertwiners via cycle-trace forms and support elimination |
| [`290`](families/290/) | Relative bicentralizers and modular spectral recovery. | Conditional implication uniform_energy => U=D with capture/amplification estimates |
| [`291`](families/291/) | Cuntz comparison, nuclear dimension, and equivariant Jiang–Su stability. | Verification of the unital uniform Gamma implication |
| [`292`](families/292/) | Kirchberg's $`\mathcal O_2`$ norm-ultrapower embedding problem. | Verification of lem:square-root-trace, spectral gap and lem:nuclear-finiteness (escape bound kappa^2/(4\|S\|)) |
| [`293`](families/293/) | Invariant projections, hyperinvariant subspaces, and transitive algebras. | Verification of lem:domar quadratic support separation and tail classification; notes Domar 1981 Thm 5 already covers literal assertion |
| [`294`](families/294/) | Kaplansky's quasitrace conjecture and failure of tensor-product stable finiteness. | Certification of separable unital A with 2-quasitrace defect >= 1/144 (matches manuscript constant) |
| [`295`](families/295/) | The Kadison–Ringrose cohomology conjecture. | Verification of rigidity chain (length, blocks, polar, unitary lemmas) |
| [`296`](families/296/) | The generator problem for finite factors. | Verification of prop:perturbation with exact constants; collision-controlled combinatorial core |
| [`297`](families/297/) | A ZFC counterexample to Naimark's problem. | Verification of eq:bridge-word-decay, unique pure extensions and selectivity of na:bridge |
| [`299`](families/299/) | The Kirchberg–Rørdam character criterion and infinite tensor-power Jiang–Su stability. | Verification of the I(2,3)->P^{tensor m} cone-drop step |
| [`301`](families/301/) | Trace cones and Razak–Jacelon stabilization. | Independent proof of Proposition tc:finite-convexity under its stated hypotheses (every extended trace, genuine quotients) |
| [`302`](families/302/) | Radius of comparison equals half the mean dimension. | Proof of prop:compatible-adams-lift (02-filtered-products.tex) as a coherent null cone. It also shows that objectwise nullity is insufficient: holim(0->Sigma HZ<-0) closes a shortcut, which does not refute OpenAI. |
| [`303`](families/303/) | Weak pure infiniteness and Cuntz-algebra absorption. | Independent verification of prop:four-avoidance and lem:actual-range, with a range-sharpness example showing that closed range cannot be assumed. Thresholds are generalized to any 0<=a0<a<beta<s; this is cosmetic. |
| [`305`](families/305/) | Four-dimensional disk embedding and Wall's conjecture. | Reconstruction of ct:upper-replacement (control.tex:447-527) from Freedman-Quinn 2.10.1/2.10.2, relative to the preparation and directions hypotheses, with an explicit 49*3^(q-1)*delta patch bound |
| [`306`](families/306/) | The purely cosmetic surgery conjecture. | Character-complete local index computation for the O(-4) cap, I(a)=q(1-r-2q), and the spinor index table. This is a local check, not the global theorem. |
| [`308`](families/308/) | Finite Smith–Toda complexes at every height. | conn:stable-elements and conn:symmetric verified uniformly in p>C and k<=Cp. Exact first nonzero degree of the multiplication cofiber computed (sharpness of the bound). conn:estimate is only conditional on universal:whole-module. |
| [`309`](families/309/) | The Kervaire invariant problem at the prime three. | Independent exact computation that B(y)^3=0 in D_{6,81}: an explicit 2639-term primitive in a digit resolution built from integral BP operations (the manuscript reports 2642 terms). It does not rely on the manuscript's ranks. |
| [`310`](families/310/) | Quillen's conjecture in rational homology. | Conditional eq:frame-log-bound verified |
| [`311`](families/311/) | The Hovey–Strickland and Chai conjectures. | Finite-level proof that D(theta)_x=M with det M != 0 (def:coordinates), without infinite compatible lifts |
| [`312`](families/312/) | The Grothendieck homotopy hypothesis. | Full descending-induction proof of prop:partial-path and the elementary-expansion equivalences |
| [`316`](families/316/) | Curtis’s conjecture. | lem:tor-injection (build/algebra.tex:388-513) proven. Also a floor-support statement for all positive Tor degrees, which is a minor strengthening. |
| [`317`](families/317/) | Thomason model structures in all strict higher dimensions. | Prose argument supports thm:couniversal with unrestricted quantifiers |
| [`322`](families/322/) | Tingley’s sphere-isometry problem. | Finite proof of the Section 5 aligned-chord obstruction. An explicit inward vector replaces the compact-dual-ball subsequence argument. This is an alternative proof, not a stronger statement. |
| [`324`](families/324/) | Lipschitz equivalent Banach spaces need not be linearly isomorphic. | prop:compatible-detectors and prop:no-c0 (07-no-c0.tex) verified for the Sept 26 completed molecule space |
| [`325`](families/325/) | The complete Crouzeix conjecture. | Dimension-free implication from ordered coefficient tests plus a positive Fourier block to gamma<=2, with the weighted dual and block estimate derived rather than assumed (main.tex:348-453) |
| [`327`](families/327/) | Markov type characterizes superreflexivity. | Lean kernel closure of CWalk, COrdered, CEdgeTransfer and CMain (forward implication, 154 custom modules, standard axioms only). Reviewer fidelity of the new wrappers is still pending. |
| [`328`](families/328/) | Nonexpansive fixed points in reflexive Banach spaces. | Lean: normalized minimal invariant data -> tree construction -> False, via the switching bridge. The arbitrary-domain reduction (Lemma reduction) is still open. |
| [`334`](families/334/) | A smooth surface metric with no local isometric immersion in ℝ<sup>3</sup>. | Full analytic proof of Proposition cap under its hypotheses |
| [`336`](families/336/) | Spectral scalar curvature, Urysohn width, and macroscopic dimension. | shield:global form coefficient theta_* = .88 improved to .28 (any theta > 29/108) (claimed as an improvement, but already implicit in the manuscript) |
| [`338`](families/338/) | Yau's uniformization conjecture. | Quantitative audit of lem:linear-alignment (dynamics.tex:199-447): uniform backward induction with horizon-independent constants |
| [`339`](families/339/) | Katok's entropy rigidity conjecture. | real:actualization verified |
| [`340`](families/340/) | A counterexample to the nearby Lagrangian conjecture. | Conditional re-verification of zero-band, one-critical, tube-realization and transport steps (h-cobordism stability ranges, J_8 injectivity, (Z/2)^3->H homomorphism enumeration) |
| [`341`](families/341/) | Donaldson's hypersymplectic deformation conjecture. | Conditional verification of lem:pencil-jets (restricted first-jet transversality, two period obstructions removed by coefficient-sphere augmentation) and of the auxiliary volume/contraction argument under retained hypotheses |
| [`342`](families/342/) | Donaldson's tamed-to-compatible conjecture. | Verified OpenAI ex:strict-cones (Taming-implies-compatibility.../08-cones.tex:375): explicit T^4 example with H_J^-=0 and taming classes lacking compatible representatives |
| [`343`](families/343/) | Symplectic ball packing in higher dimensions. | Verified handle-packing construction steps 2-5 (normalization, gluing, Moser, layers) for every m |
| [`344`](families/344/) | The metric Blaschke conjecture. | Independent proof of the no-splitting determinant comparison (double-integral determinant inequality, equality case, lag-entropy) under section 01-02 hypotheses |
| [`345`](families/345/) | Infinitely many closed geodesics on Riemannian spheres and closed three-manifolds. | Finite-cut defect potential bound sum_j Phi_j<=C proved conditional on staged local-control/localization hypotheses; exact-comparison algebra over any field |
| [`346`](families/346/) | Sharp singular-set bounds for stationary integral varifolds. | Verification of concentration bridge (lt:config, pk:flux-moments, pk:reverse, pk:bad-flux) plus L^2-only obstruction example showing two L^2 bounds don't give flux gain |
| [`349`](families/349/) | The Solomon–Yau least-volume conjecture. | Verified Lorentz-boost family lemmas (lem:family-all-levels, cone contact, support) with finite-perimeter/GMT steps |
| [`353`](families/353/) | Affine Bernstein rigidity through dimension nine and a smooth dimension-ten … | Independent verification of affine Bernstein chain (one-direction, cap identity, tube energy, finite box) for 3<=n<=9; sharpens coercivity interface constant |
| [`354`](families/354/) | The isoperimetric profile of the cubic three-torus. | Nesting obstruction: nested-slice families with .64<=h<=2.25 have area >=1+9e-5 |
| [`355`](families/355/) | Unique tangent flows at the first surface singularity. | Stokes/Gevrey core extended to radial weights 1<=m<=2 with c_m nonzero; claimed 'sharper' factorial lower bound n b_n >= 2^{n-1}(n-1)! (claimed as an improvement, but already implicit in the manuscript) |
| [`356`](families/356/) | Gigli’s characterization of Alexandrov curvature. | Verified weighted Bochner/graph-closure chain to RCD/CD(K-lambda G) and every-geodesic Hessian bound |
| [`357`](families/357/) | Bi-Lipschitz coordinates at every regular RCD point. | Conditional full proof of uniform alpha<=C s affine-projection bound (sharp projection) given imported normalization inputs |
| [`360`](families/360/) | Weak MTW curvature gives convexity and regular optimal transport. | Proof of literal geo:local-injectivity (Global-Support-and-Convex-Injectivity.../geometry.tex:323) via active hull, radial divided action and transverse slack |
| [`361`](families/361/) | Failure of integer-degree harmonic dimension comparison. | Crossing-matching/growth extended from (rho,q,beta)=(3/4,3/4,1/8) to open exponent region, odd finite-order crossings (claimed as an improvement, but already implicit in the manuscript) |
| [`362`](families/362/) | Global smoothness for relativistic Vlasov–Maxwell. | Verified sel:selection exponent arithmetic and explicit uniform threshold (selection.tex:78) via exact linear certificate |
| [`365`](families/365/) | Joint metric and connection recovery from one boundary patch. | All-degree scalar angular coercivity and rank-two absorption; error-form bound extended to complex coefficients iff base normality |
| [`366`](families/366/) | The planar Mumford–Shah regularity conjecture and local weak-<i>L</i><sup>4</sup> … | Verified compact-piece exclusion (projection, translation comparison, flux removal) with technical replacement of a local argument |
| [`367`](families/367/) | The critical dimension for the one-phase Bernoulli problem. | Verified cert:universal (certificate.tex:33): interior polynomial >= (438907/12e6)(z^2+\|l\|^2), boundary >= 6984137359/3.125e10, 1714-coefficient expansion |
| [`368`](families/368/) | The three-dimensional Ball–Evans approximation problem. | Verified cubical cutoff/lift/fill-collapse chain with W^{1,p} seams |
| [`369`](families/369/) | The hot spots conjecture for simply connected planar domains. | Verified reciprocal Green-kernel conditional negative definiteness chain (Sections 4-5) |
| [`371`](families/371/) | Stable blowup for the defocusing Schrödinger equation. | Independent proof of outgoing-to-shell bridge with rough matrix coupling |
| [`372`](families/372/) | Global uniqueness in smooth isotropic elasticity. | Verified prop:physical-amplitudes (physical-amplitudes.tex:204) with transport recursion and O(tau^(1-N)) correction |
| [`375`](families/375/) | De Giorgi's conjecture in dimension eight. | Verified chamber lemmas (artificial solution, midpoint, barrier, exact transfer, Modica) |

## 5. Lean certificates

| Quantity | Value |
| :--- | :--- |
| Certificates / families | 384 / 314 |
| Recorded total lines | 520,223 (raw sum over all certificates) |
| of which `156` | 346,954 lines: a machine-generated, kernel-checked replay of an UNSAT proof for the finite 10-label obstruction (`TenLabel.no_model`); best counted as **one** certified finite obstruction |
| of which ported from OpenAI's own Lean | about 52,000 lines (e.g. families `118`, `131`, `149` are ≥95% upstream code, as their fidelity notes state) |
| Distinct Argus-authored lines outside `156` | **about 120,000** |
| Checks | every certificate records `exit_code 0`, no `sorry`/`admit`, and no axioms beyond `propext`, `Classical.choice`, `Quot.sound` |
| Recompiled on 2026-11-09 | 12 certificates: 10 passed; the other 2 import OpenAI's `OAI` library and need it on the path |
| Published in this repository | Lean sources for all families are under [`families/`](families/); `156` included |

Each certificate checks a delimited core lemma, stated in its `statement_fidelity.md`. None formalizes a manuscript end to end. The raw count of 41,764 theorem declarations is dominated by 32,135 propagation-step lemmas in `156`, so it is not a useful measure.

Substantial examples (Argus-authored lines):
- `321` Fox-calculus torsion, Wall D(2): 2,029 lines
- `003` determinant / integral-norm chain: 2,796 lines
- `124` scheduling protocol extraction: 8,016 lines
- `176` Kahn–Kalai pathwise reduction: 1,814 lines
- `242` Pell and power completeness: 1,674 lines

## 6. Limitations

- **Review method.** Verification read the drafts and checked the key steps; it did not re-derive every proof. "Plausible" means no gap was found on reading.
- **Not yet done.** No human expert has reviewed these results, and novelty against the literature has not been checked.
- **Lean scope.** Lean certificates cover delimited core lemmas only.
- **Changes to the drafts.** Server paths, e-mail addresses and session identifiers were removed. As a result, some hashes recorded inside drafts refer to the original files.

## Appendix: category of every family (373 active families)

Lean figures exclude lines identical to OpenAI's upstream Lean.

| Family | Title | Manuscripts | Argus Lean (certs / authored lines) | Category |
| :--- | :--- | :---: | :---: | :--- |
| [`001`](families/001/) | Milne’s rationality conjecture and algebraic specialization. | 1 | 1 / 41 | verification |
| [`002`](families/002/) | The full BSD formula from low Selmer corank. | 3 | 1 / 193 | verification |
| [`003`](families/003/) | The quasi-Riemann hypothesis. | 3 | 2 / 2,672 | verification |
| [`004`](families/004/) | Hilbert’s tenth problem over ℚ. | 2 | 2 / 245 | verification |
| [`005`](families/005/) | Irrationality of Catalan’s constant. | 1 | 1 / 104 | verification |
| [`006`](families/006/) | Goldfeld’s conjecture: densities and mean analytic rank. | 2 | 1 / 539 | verification |
| [`007`](families/007/) | Ordinary two-point correlations and the corrected Elliott conjecture. | 1 | 1 / 156 | improvement |
| [`008`](families/008/) | The Deligne–Drinfeld conjecture. | 1 | 1 / 38 | verification |
| [`009`](families/009/) | Function-field reconstruction from Milnor K-theory and Galois data. | 3 | 2 / 2,270 | verification |
| [`010`](families/010/) | Unrestricted pro-modularity at the prime two. | 3 | 1 / 67 | improvement |
| [`011`](families/011/) | Prime-factor statistics of $`p-1`$. | 3 | 2 / 173 | verification |
| [`012`](families/012/) | Independent largest prime factors of consecutive integers. | 1 | 1 / 211 | verification |
| [`013`](families/013/) | Ostmann’s inverse Goldbach conjecture. | 1 | 1 / 114 | improvement |
| [`014`](families/014/) | Restricted geometric Langlands, global Arthur enhancements, and generic Ramanujan. | 8 | — | improvement |
| [`015`](families/015/) | Torus-packet equidistribution in prime, quartic, and sextic degrees. | 3 | — | improvement |
| [`016`](families/016/) | Zilber–Pink in abelian varieties and the Siegel threefold. | 4 | 1 / 84 | verification |
| [`017`](families/017/) | The irrationality exponent of <i>π</i> is 2. | 1 | 1 / 157 | improvement |
| [`018`](families/018/) | The Margulis–Platonov conjecture over global fields. | 2 | 1 / 299 | improvement |
| [`019`](families/019/) | The local <i>p</i>-adic section conjecture and global consequences. | 2 | 1 / 59 | verification |
| [`020`](families/020/) | Squarefree quartics and power-free polynomial values. | 1 | 1 / 160 | verification |
| [`021`](families/021/) | A quadratic bound for Jacobsthal’s function. | 1 | 1 / 320 | verification |
| [`022`](families/022/) | The weak inhomogeneous Duffin–Schaeffer conjecture. | 1 | 1 / 460 | improvement |
| [`023`](families/023/) | Patterson's first moment for cubic Gauss sums. | 1 | 1 / 284 | verification |
| [`024`](families/024/) | An asymptotic formula for the number of totients. | 1 | 1 / 137 | verification |
| [`025`](families/025/) | Short Egyptian fractions. | 1 | 2 / 413 | improvement |
| [`026`](families/026/) | Positive lower density of large prime gaps. | 1 | 1 / 72 | improvement |
| [`027`](families/027/) | Potential integral density on curve character varieties. | 1 | 1 / 112 | verification |
| [`028`](families/028/) | Uniformly bounded components of Gaussian-prime graphs. | 1 | — | improvement |
| [`029`](families/029/) | Primitive roots for every admissible integer base. | 2 | — | verification |
| [`030`](families/030/) | Modularity of elliptic curves over imaginary quadratic fields. | 1 | 1 / 154 | verification |
| [`031`](families/031/) | Uchida’s conjecture for open homomorphisms of Galois groups. | 1 | — | verification |
| [`032`](families/032/) | The rational Hodge conjecture for CM abelian varieties. | 5 | — | verification |
| [`033`](families/033/) | Iitaka subadditivity, variation, and logarithmic additivity. | 5 | — | improvement |
| [`034`](families/034/) | Log abundance for compact Kähler spaces under logarithmic Iitaka subadditivity. | 14 | — | improvement |
| [`035`](families/035/) | Log-canonical threefold abundance in numerical dimension one. | 2 | 1 / 242 | improvement |
| [`036`](families/036/) | Numerical semiampleness and generalized minimal models. | 4 | 1 / 295 | verification |
| [`037`](families/037/) | The ordinary-double-point volume gap. | 2 | 1 / 54 | improvement |
| [`038`](families/038/) | Fujita’s freeness conjecture. | 1 | 1 / 245 | verification |
| [`039`](families/039/) | Nagata’s conjecture and maximal Seshadri constants. | 4 | 1 / 120 | improvement |
| [`040`](families/040/) | Bloch’s conjecture for complex surfaces. | 1 | — | verification |
| [`041`](families/041/) | Hyperkähler SYZ and projective-space bases. | 2 | 1 / 203 | verification |
| [`042`](families/042/) | Oka classification for minimal compact complex surfaces: Kodaira dimension zero and class VII. | 1 | — | improvement |
| [`043`](families/043/) | <i>P</i> = <i>W</i> for fixed-determinant SL<sub><i>n</i></sub> moduli spaces. | 1 | — | verification |
| [`044`](families/044/) | The equivariant cohomological Hikita conjecture. | 1 | 1 / 77 | verification |
| [`046`](families/046/) | Shafarevich counterexamples in dimension two and with large fundamental group. | 2 | 1 / 60 | improvement |
| [`047`](families/047/) | Zariski cancellation and affine fibrations over the complex numbers. | 1 | 1 / 155 | improvement |
| [`048`](families/048/) | A characteristic-zero counterexample to Lipman–Zariski. | 1 | — | improvement |
| [`049`](families/049/) | A stable-coordinate counterexample in four variables. | 2 | 1 / 136 | improvement |
| [`050`](families/050/) | A counterexample to Griffiths’ positivity conjecture. | 1 | — | improvement |
| [`051`](families/051/) | Kobayashi’s canonical-ampleness conjecture. | 1 | — | verification |
| [`052`](families/052/) | Tangent splittings and product decompositions. | 2 | 1 / 198 | verification |
| [`053`](families/053/) | A counterexample to Pixton completeness in Chow. | 1 | 2 / 131 | verification |
| [`054`](families/054/) | Irrational cubic fourfolds with Hodge-theoretic and categorical K3 associations. | 1 | 1 / 138 | verification |
| [`055`](families/055/) | Gepner symmetry and large-volume stability on threefolds. | 2 | 1 / 198 | improvement |
| [`056`](families/056/) | Termination of projective and Kähler fourfold minimal model programs. | 5 | — | improvement |
| [`057`](families/057/) | Fundamental groups of special complex varieties and root orbifolds. | 3 | 1 / 76 | verification |
| [`058`](families/058/) | Semialgebraic universal covers and bounded domains. | 2 | — | no substantive output |
| [`059`](families/059/) | Counterexamples to Zariski’s multiplicity conjecture. | 2 | — | verification |
| [`060`](families/060/) | The Global Spherical Shell conjecture. | 1 | — | improvement |
| [`062`](families/062/) | Projective contact classification and the LeBrun–Salamon conjecture. | 1 | 1 / 41 | verification |
| [`063`](families/063/) | The generalized Mukai conjecture. | 1 | — | improvement |
| [`064`](families/064/) | Topological triviality of <i>μ</i>-constant surface singularities. | 1 | — | verification |
| [`065`](families/065/) | Virasoro constraints for complete intersections and projective-bundle towers. | 2 | 1 / 77 | verification |
| [`066`](families/066/) | Bounded klt complements for Fano contractions. | 2 | 1 / 67 | improvement |
| [`067`](families/067/) | The Campana–Peternell conjecture in dimension six. | 1 | — | verification |
| [`068`](families/068/) | Anticanonical nonvanishing in every dimension. | 7 | 1 / 111 | improvement |
| [`069`](families/069/) | Global quantum geometric Langlands at irrational level. | 1 | — | no substantive output |
| [`071`](families/071/) | Koebe’s circle-domain conjecture. | 2 | 1 / 44 | improvement |
| [`072`](families/072/) | Brennan's conjecture and the integral-means spectrum. | 2 | 1 / 115 | improvement |
| [`073`](families/073/) | The Falconer distance conjecture. | 1 | 1 / 1,113 | verification |
| [`074`](families/074/) | Kakeya in three and four dimensions. | 2 | 1 / 97 | improvement |
| [`075`](families/075/) | The $`L\log L`$ Fourier-convergence conjecture. | 1 | 1 / 670 | verification |
| [`076`](families/076/) | Real ultraflat Littlewood polynomials and unbounded binary merit factors. | 3 | 1 / 120 | improvement |
| [`077`](families/077/) | Fourier restriction for positively curved surfaces. | 2 | — | no substantive output |
| [`078`](families/078/) | The three-dimensional Bochner–Riesz conjecture. | 1 | 1 / 122 | improvement |
| [`079`](families/079/) | Local smoothing for the Euclidean wave equation. | 2 | 1 / 97 | improvement |
| [`080`](families/080/) | The exact Sobolev endpoint for Schrödinger convergence. | 2 | 1 / 88 | verification |
| [`081`](families/081/) | Riesz transforms and rectifiability in higher codimension. | 1 | 1 / 66 | improvement |
| [`082`](families/082/) | Annular variation and dyadic absolute bounds for the triangular Hilbert transform. | 3 | 1 / 95 | verification |
| [`083`](families/083/) | Hilbert transforms along Lipschitz directions. | 1 | 1 / 181 | verification |
| [`084`](families/084/) | The geometric case of the Erdős similarity conjecture. | 2 | 1 / 774 | improvement |
| [`085`](families/085/) | Endpoint Sobolev regularity of centered disk averages. | 1 | 1 / 305 | improvement |
| [`086`](families/086/) | An <i>L</i><sup>3</sup> bound for the trilinear Hilbert transform. | 1 | 2 / 158 | verification |
| [`087`](families/087/) | The Mahler conjectures, functional inequalities and polar-product symplectic width. | 3 | 1 / 55 | improvement |
| [`088`](families/088/) | Sharp projection-body inequalities and a counterexample to simplex maximization. | 2 | 1 / 532 | improvement |
| [`089`](families/089/) | Bounded-distortion <i>L</i><sub>1</sub> embeddings of planar and bounded-treewidth graphs. | 2 | 1 / 957 | verification |
| [`090`](families/090/) | Triangular-lattice optimality, long-range Riesz and Coulomb energies, and spherical logarithmic energy. | 4 | — | verification |
| [`091`](families/091/) | Logarithmic and <i>L</i><sub><i>p</i></sub> Brunn–Minkowski inequalities and the B-conjecture. | 1 | 1 / 204 | verification |
| [`092`](families/092/) | The optimal order of convex-body covering density. | 2 | 1 / 218 | verification |
| [`093`](families/093/) | Dimension-free logarithmic Sobolev inequality for subgaussian log-concave measures. | 1 | — | improvement |
| [`094`](families/094/) | Subpolynomial dimension reduction in <i>L</i><sub><i>p</i></sub>. | 1 | 1 / 336 | verification |
| [`095`](families/095/) | Hyperbolicity cones without semidefinite lifts. | 3 | — | verification |
| [`096`](families/096/) | The Gaussian propeller conjecture in every dimension. | 1 | 1 / 490 | verification |
| [`097`](families/097/) | The Euclidean Steinitz–Bergström bound. | 1 | 1 / 76 | improvement |
| [`098`](families/098/) | Compact counterexamples to bi-Lipschitz dimension reduction. | 1 | 1 / 302 | verification |
| [`099`](families/099/) | The sharp exponential scale of edit-distance distortion. | 3 | 1 / 176 | improvement |
| [`100`](families/100/) | Cylinder coverings below the half-area bound. | 4 | 1 / 253 | verification |
| [`101`](families/101/) | The sharp simplex conjecture for isotropic constants. | 1 | 1 / 385 | verification |
| [`102`](families/102/) | The Unique Games Conjecture and optimal approximation thresholds. | 5 | 4 / 1,172 | verification |
| [`103`](families/103/) | Exact derandomization of logarithmic space: $`\mathsf L=\mathsf{RL}=\mathsf{BPL}`$. | 1 | 1 / 443 | verification |
| [`104`](families/104/) | Quasipolynomial algorithms for mean-payoff, stochastic and parity games. | 4 | 1 / 1,229 | verification |
| [`105`](families/105/) | Perfect completeness for 2-to-1 games. | 1 | 1 / 130 | improvement |
| [`106`](families/106/) | Hardness of coloring three-colorable graphs. | 1 | 4 / 594 | verification |
| [`107`](families/107/) | Matrix multiplication with exponent at most 9/4. | 3 | 1 / 96 | improvement |
| [`108`](families/108/) | A cubic permanent–determinant lower bound. | 1 | 1 / 209 | improvement |
| [`109`](families/109/) | Integer multiplication below $`n\log n`$. | 1 | 1 / 141 | verification |
| [`110`](families/110/) | Optimal-order randomized <i>k</i>-server on arbitrary metrics. | 2 | 1 / 145 | verification |
| [`111`](families/111/) | One-sample matroid prophet inequalities against an almighty adversary. | 1 | 1 / 98 | verification |
| [`112`](families/112/) | Beyond the square-root exponent for depth-three circuits. | 1 | 1 / 823 | improvement |
| [`113`](families/113/) | Approximate counting and entropy of perfect matchings. | 2 | 1 / 127 | improvement |
| [`114`](families/114/) | Approximate counting of common integer polymatroid bases. | 2 | 3 / 3,219 | verification |
| [`115`](families/115/) | Sampling and counting contingency tables with arbitrary margins. | 2 | 1 / 1,383 | verification |
| [`116`](families/116/) | Uniform black-box noncommutative identity testing across characteristics. | 3 | 2 / 1,483 | verification |
| [`117`](families/117/) | Uniform sparsest cut: hardness and semidefinite gaps. | 2 | 1 / 120 | verification |
| [`118`](families/118/) | Bin packing and unbounded configuration-LP gaps. | 1 | 1 / 712 | verification |
| [`119`](families/119/) | The Courtade–Kumar and Hellinger conjectures. | 2 | 1 / 59 | verification |
| [`120`](families/120/) | Almost-linear-time exact matching and prescribed-degree factors in general graphs. | 1 | 1 / 251 | verification |
| [`121`](families/121/) | Almost-linear approximation of edit distance. | 1 | 1 / 406 | verification |
| [`122`](families/122/) | Quantitative trace-reconstruction bounds with a uniform decoder. | 3 | 1 / 91 | improvement |
| [`124`](families/124/) | Polynomial-time scheduling on three identical machines. | 1 | 6 / 21,357 | verification |
| [`125`](families/125/) | The metric <i>k</i>-median approximation threshold and recovery. | 2 | 1 / 215 | verification |
| [`126`](families/126/) | Exponential semidefinite complexity of perfect matching. | 1 | 1 / 142 | improvement |
| [`127`](families/127/) | Average sensitivity of polynomial threshold functions. | 1 | 1 / 141 | improvement |
| [`128`](families/128/) | A factor-two approximation for shortest common superstring. | 1 | 1 / 706 | verification |
| [`129`](families/129/) | Exponential state costs for two-way automata. | 2 | 1 / 884 | verification |
| [`130`](families/130/) | Exact Fourier transforms below $`n\log n`$. | 2 | — | verification |
| [`131`](families/131/) | Rapid mixing of graph switches for every degree sequence. | 1 | 1 / 566 | verification |
| [`132`](families/132/) | A superquadratic separation of sensitivity and block sensitivity. | 1 | 1 / 756 | improvement |
| [`133`](families/133/) | The computational complexity of Weisfeiler–Leman refinement. | 4 | 2 / 2,421 | verification |
| [`134`](families/134/) | Generalized star height at most three. | 3 | 1 / 1,268 | verification |
| [`135`](families/135/) | Homogeneous depth-five lower bounds for iterated matrix multiplication. | 1 | 1 / 493 | verification |
| [`136`](families/136/) | A quasilinear PCP theorem for PPAD. | 1 | 1 / 117 | verification |
| [`137`](families/137/) | One-tape time simulation in two-fifths-power space. | 1 | 2 / 3,807 | verification |
| [`138`](families/138/) | Subset Sum in $`O(2^{0.49n})`$ time. | 2 | 1 / 46 | verification |
| [`139`](families/139/) | Subpolynomial query complexity for log-concave sampling. | 1 | 1 / 256 | verification |
| [`140`](families/140/) | Memory–sample lower bounds for noiseless Gaussian regression. | 6 | 1 / 862 | verification |
| [`141`](families/141/) | Existential–universal real sentences in the counting hierarchy. | 1 | 1 / 511 | improvement |
| [`142`](families/142/) | Deterministic polynomial factorization over prime fields. | 1 | 1 / 122 | verification |
| [`143`](families/143/) | Hilbert's sixteenth problem: uniform bounds for limit cycles. | 2 | 1 / 331 | verification |
| [`144`](families/144/) | Banach’s simple Lebesgue-spectrum problem. | 1 | 1 / 132 | verification |
| [`145`](families/145/) | Rokhlin’s multiple-mixing problem. | 1 | 1 / 112 | verification |
| [`146`](families/146/) | Positive metric entropy for the standard map. | 1 | 1 / 92 | improvement |
| [`147`](families/147/) | The near-boundary Birkhoff conjecture. | 2 | — | verification |
| [`148`](families/148/) | The entropy-rate dimension formula for self-similar measures. | 1 | 3 / 858 | improvement |
| [`149`](families/149/) | Classwise permanence for weakly reversible mass-action systems. | 2 | 2 / 320 | improvement |
| [`150`](families/150/) | Weak mixing of triangular billiards with an irrational angle. | 2 | 1 / 112 | verification |
| [`151`](families/151/) | A <i>C</i><sup>1</sup> counterexample to the entropy conjecture. | 1 | 2 / 892 | verification |
| [`152`](families/152/) | Zero entropy does not guarantee a smooth positive-volume model. | 1 | — | improvement |
| [`153`](families/153/) | Arithmetic classification and non-Pisot singularity for Bernoulli convolutions. | 1 | 1 / 167 | improvement |
| [`154`](families/154/) | Pointwise multiple ergodic averages for mixing transformations. | 4 | 1 / 202 | verification |
| [`155`](families/155/) | A counterexample to periodic tiling in dimension three. | 1 | 1 / 604 | verification |
| [`156`](families/156/) | Borsuk's conjecture fails in dimension nine. | 1 | 1 / 346,954 | verification |
| [`157`](families/157/) | Graph coloring, clique minors, and Colin de Verdière invariants. | 3 | 3 / 3,007 | verification |
| [`158`](families/158/) | The Euclidean plane cannot be colored with five colors. | 1 | 1 / 10 | verification |
| [`159`](families/159/) | Erdős’s reciprocal-sum conjecture and quasipolynomial Szemerédi bounds. | 1 | 1 / 81 | verification |
| [`160`](families/160/) | Superexponential van der Waerden numbers. | 1 | 1 / 215 | verification |
| [`161`](families/161/) | Counterexamples to Sidorenko’s conjecture and the forcing conjecture. | 1 | — | verification |
| [`162`](families/162/) | Counterexamples to Ryser’s covering conjecture. | 2 | 2 / 249 | verification |
| [`164`](families/164/) | Hindman’s finite sums and products conjecture. | 1 | 1 / 107 | improvement |
| [`165`](families/165/) | The Harary–Hill and Zarankiewicz crossing-number formulas. | 2 | 1 / 236 | verification |
| [`166`](families/166/) | The higher-dimensional Erdős distinct-distances conjecture. | 1 | 1 / 42 | improvement |
| [`167`](families/167/) | Planar distinct distances and unit-distance bounds. | 2 | 1 / 221 | verification |
| [`168`](families/168/) | Combinatorial invariance of Kazhdan–Lusztig polynomials. | 1 | 1 / 85 | no substantive output |
| [`169`](families/169/) | Shareshian–Wachs elementary positivity. | 1 | 1 / 53 | verification |
| [`170`](families/170/) | Sharp logarithmic exponents for off-diagonal Ramsey numbers. | 2 | 1 / 89 | verification |
| [`171`](families/171/) | The hypercube Ramsey conjecture. | 1 | 1 / 83 | verification |
| [`172`](families/172/) | Classification of finite Euclidean Ramsey configurations. | 1 | 2 / 1,347 | improvement |
| [`173`](families/173/) | Seymour’s second-neighborhood conjecture. | 1 | 1 / 245 | verification |
| [`174`](families/174/) | Deterministic construction of strong thin spanning trees. | 2 | 2 / 451 | improvement |
| [`175`](families/175/) | Talagrand’s expectation thresholds, discrete convexity, and graph decompositions. | 3 | 1 / 519 | improvement |
| [`176`](families/176/) | The second Kahn–Kalai conjecture with an edge-count bound. | 1 | 1 / 1,723 | verification |
| [`177`](families/177/) | Bounded-degree coboundary expanders. | 1 | 1 / 141 | verification |
| [`178`](families/178/) | Deterministic nonbipartite Ramanujan graphs in every fixed degree. | 1 | 1 / 45 | verification |
| [`179`](families/179/) | The circulant Hadamard and Barker-sequence conjectures. | 1 | 3 / 294 | improvement |
| [`180`](families/180/) | Barnette’s Hamiltonian-cycle conjecture. | 1 | 1 / 170 | verification |
| [`181`](families/181/) | The Erdős–Gallai cycle-decomposition conjecture. | 1 | 1 / 530 | verification |
| [`182`](families/182/) | Power savings for intersective polynomial differences and prime arguments. | 3 | 1 / 206 | verification |
| [`183`](families/183/) | Power savings for planar halving lines and <i>k</i>-sets. | 1 | 1 / 1,582 | verification |
| [`184`](families/184/) | Correspondence coloring with a fixed forbidden subgraph. | 2 | 1 / 123 | improvement |
| [`185`](families/185/) | Counterexamples to infinite matroid intersection and packing/covering. | 1 | 2 / 547 | verification |
| [`186`](families/186/) | Uniform influence and sharp thresholds for graph and hypergraph properties. | 2 | 2 / 384 | verification |
| [`187`](families/187/) | Snaky in 21 Maker moves. | 1 | 1 / 1,341 | verification |
| [`188`](families/188/) | The sharp terminal leave in random triangle removal. | 1 | 1 / 102 | no substantive output |
| [`189`](families/189/) | Cycle–clique Ramsey numbers. | 1 | 2 / 265 | verification |
| [`190`](families/190/) | Polynomial removal fails for ordered binary matrices. | 1 | 1 / 162 | improvement |
| [`191`](families/191/) | A power improvement in the Heilbronn triangle lower bound. | 1 | 1 / 387 | verification |
| [`192`](families/192/) | Boolean functions violate the square-root degree bound by arbitrary factors. | 1 | 1 / 120 | verification |
| [`193`](families/193/) | Serre’s intersection-multiplicity conjecture. | 1 | 1 / 68 | verification |
| [`194`](families/194/) | Lech’s multiplicity conjecture. | 1 | 1 / 93 | verification |
| [`195`](families/195/) | A counterexample to the small Cohen–Macaulay module conjecture. | 1 | 2 / 201 | improvement |
| [`196`](families/196/) | A counterexample to Kaplansky’s zero-divisor conjecture. | 1 | 2 / 459 | verification |
| [`197`](families/197/) | A torsion-free group algebra that is not directly finite. | 4 | 1 / 101 | improvement |
| [`198`](families/198/) | A counterexample to finitistic-dimension finiteness. | 1 | 1 / 1,543 | verification |
| [`199`](families/199/) | Counterexamples to Auslander–Reiten, Tachikawa and related homological conjectures. | 2 | 1 / 142 | verification |
| [`200`](families/200/) | Eisenbud–Green–Harris and lex-plus-powers. | 2 | 1 / 62 | verification |
| [`201`](families/201/) | A counterexample to Kurosh’s division-ring problem. | 1 | 3 / 360 | verification |
| [`202`](families/202/) | The blockwise Alperin weight conjecture. | 1 | 1 / 102 | improvement |
| [`203`](families/203/) | Donovan's conjecture over fields and complete mixed-characteristic DVRs. | 2 | — | verification |
| [`204`](families/204/) | Tensor saturation for even spin groups. | 1 | 1 / 162 | improvement |
| [`205`](families/205/) | Saxl’s conjecture and universal tensor squares. | 2 | 1 / 305 | improvement |
| [`206`](families/206/) | Finite lattice representation and undecidability. | 2 | 1 / 152 | verification |
| [`207`](families/207/) | The ℓ¹-Bass conjecture for all discrete groups. | 2 | 1 / 141 | verification |
| [`208`](families/208/) | Finite symmetric tensor categories and the Verlinde tower. | 1 | 1 / 221 | verification |
| [`209`](families/209/) | Integral counterexamples to Gersten’s conjecture. | 2 | — | improvement |
| [`210`](families/210/) | Foulkes' conjecture for sixth powers and quadratic stabilization. | 2 | 1 / 118 | improvement |
| [`211`](families/211/) | The geometric phase diagram, diffusion, and spectra of random planar maps. | 7 | 1 / 62 | improvement |
| [`212`](families/212/) | Planar first-passage geometry and the absence of bigeodesics. | 2 | 1 / 502 | verification |
| [`213`](families/213/) | Critical percolation on every quasi-transitive graph. | 2 | 1 / 83 | verification |
| [`214`](families/214/) | The Benjamini–Schramm nonuniqueness conjecture. | 1 | 1 / 913 | verification |
| [`215`](families/215/) | Canonical $`O(3)`$ continuum limit and exact $`O(4)`$ mass asymptotics. | 5 | 1 / 106 | improvement |
| [`216`](families/216/) | Critical and near-critical XY scaling and BKT universality. | 6 | 1 / 118 | verification |
| [`217`](families/217/) | The low-temperature Sherrington–Kirkpatrick fluctuation law. | 2 | 1 / 98 | improvement |
| [`218`](families/218/) | Conformal universality for weakly interacting and random-bond Ising models. | 6 | 1 / 753 | verification |
| [`219`](families/219/) | GOE bulk universality for regular graphs with weak Anderson disorder. | 2 | 2 / 202 | improvement |
| [`220`](families/220/) | Directional zero–one laws beyond iid environments and iid ballisticity. | 3 | 1 / 167 | verification |
| [`221`](families/221/) | The Mézard–Parisi formula for diluted spin glasses. | 1 | 1 / 392 | improvement |
| [`222`](families/222/) | Perceptron free energies and microscopic jamming exponents. | 4 | — | verification |
| [`223`](families/223/) | Random-cluster interfaces: critical, disordered, thermal, and natural-time scaling. | 6 | 1 / 425 | verification |
| [`224`](families/224/) | Critical and quenched near-critical universality for Poisson–Voronoi percolation. | 3 | 1 / 102 | no substantive output |
| [`225`](families/225/) | Gaussian free field limits throughout the balanced six-vertex regime. | 1 | 1 / 33 | improvement |
| [`226`](families/226/) | The double-dimer loop ensemble converges to CLE<sub>4</sub>. | 1 | 1 / 198 | improvement |
| [`227`](families/227/) | Critical SK autocorrelation processes and dynamics across the temperature transition. | 8 | 1 / 106 | improvement |
| [`228`](families/228/) | Continuum phase transitions for radial pair potentials. | 2 | 1 / 158 | improvement |
| [`229`](families/229/) | Exact three- and four-state reconstruction thresholds and four-state tree capacity. | 3 | 1 / 108 | verification |
| [`230`](families/230/) | Exact Hausdorff gauges for SLE. | 2 | 1 / 106 | improvement |
| [`231`](families/231/) | The free uniform spanning forest is a factor of IID. | 1 | 1 / 177 | improvement |
| [`232`](families/232/) | Gaussian fields and interfaces for triangular-lattice Lipschitz heights. | 3 | — | improvement |
| [`233`](families/233/) | The joint critical Ashkin–Teller current limit. | 1 | — | verification |
| [`234`](families/234/) | All-temperature pressure of orthogonally invariant Ising spin glasses. | 1 | 1 / 93 | verification |
| [`235`](families/235/) | Limiting random SAT thresholds, sharp variance and computability. | 4 | 1 / 97 | verification |
| [`236`](families/236/) | The exact factor-of-IID threshold for free Ising spins on trees. | 1 | 1 / 90 | improvement |
| [`237`](families/237/) | The three-quarter exponent for honeycomb self-avoiding walk. | 13 | 1 / 79 | verification |
| [`238`](families/238/) | Optimal logarithmic mixing of the Thorp shuffle. | 12 | 1 / 78 | improvement |
| [`239`](families/239/) | Sharp singularity rates for symmetric random sign matrices. | 2 | 1 / 100 | improvement |
| [`240`](families/240/) | Shelah's eventual categoricity and the prescribed-threshold obstruction. | 2 | 1 / 177 | verification |
| [`241`](families/241/) | Rigidity of the Turing degrees. | 1 | 1 / 1,189 | verification |
| [`242`](families/242/) | Single-fold Diophantine representations and undecidability under an at-most-one-solution promise. | 1 | 1 / 1,635 | verification |
| [`243`](families/243/) | Separating choiceless counting from polynomial time and witnessed choice. | 2 | — | verification |
| [`244`](families/244/) | The Partition Principle does not imply Choice. | 1 | 2 / 1,482 | verification |
| [`245`](families/245/) | Weak normalization implies strong normalization in pure type systems. | 1 | 2 / 1,096 | verification |
| [`246`](families/246/) | Cannon's conjecture. | 1 | 1 / 224 | verification |
| [`247`](families/247/) | An infinite finitely presented residually finite 2-group and a finitely presented nil algebra. | 2 | 1 / 172 | error found |
| [`248`](families/248/) | Thompson's group <i>F</i> is nonamenable. | 1 | 1 / 85 | verification |
| [`249`](families/249/) | A finitely generated Eilenberg–Ganea counterexample. | 1 | 1 / 495 | verification |
| [`250`](families/250/) | Boone–Higman embeddings with higher finiteness. | 3 | 4 / 1,477 | verification |
| [`251`](families/251/) | Amenability, unitarizability, and strong Ulam stability. | 2 | 1 / 120 | improvement |
| [`252`](families/252/) | A torsion-free hyperbolic group that is neither residually finite nor linear over any field. | 1 | 1 / 320 | verification |
| [`253`](families/253/) | An infinite finitely presented simple amenable group. | 1 | 1 / 91 | verification |
| [`254`](families/254/) | Classifying spaces and geometric obstructions for Artin groups. | 3 | 1 / 234 | verification |
| [`255`](families/255/) | Quasi-isometric recognition of virtually polycyclic groups. | 1 | — | no substantive output |
| [`256`](families/256/) | Nonsingular systems of equations over arbitrary groups. | 2 | 1 / 162 | verification |
| [`257`](families/257/) | A hyperbolic group without a geometric CAT(0) action. | 1 | 1 / 827 | improvement |
| [`258`](families/258/) | Gersten’s conjecture and virtual compact specialness of one-relator groups. | 2 | 1 / 117 | verification |
| [`259`](families/259/) | A group without fixed price. | 1 | 2 / 355 | improvement |
| [`260`](families/260/) | Spacetime Penrose inequalities: enclosing area, charge, rotation, and anti-de Sitter extensions. | 13 | 1 / 360 | improvement |
| [`261`](families/261/) | Localization and delocalization in the Anderson model. | 2 | 1 / 63 | improvement |
| [`262`](families/262/) | Sharp finite-matrix Lieb–Thirring inequalities and all equality cases. | 3 | 1 / 145 | improvement |
| [`263`](families/263/) | The ionization and generalized ionization conjectures. | 3 | — | verification |
| [`264`](families/264/) | Strong cosmic censorship near two-ended Kerr data. | 3 | 1 / 109 | improvement |
| [`265`](families/265/) | Area laws and tensor networks for two-dimensional gapped systems. | 2 | 1 / 52 | improvement |
| [`266`](families/266/) | Exactly three mutually unbiased bases in dimension six. | 2 | 1 / 85 | verification |
| [`267`](families/267/) | Positive-temperature Bose–Einstein condensation and exact quantum depletion. | 5 | 1 / 168 | verification |
| [`268`](families/268/) | The spin-one Haldane gap. | 2 | 1 / 74 | verification |
| [`269`](families/269/) | Uniform Laughlin gap and stability under bounded scalar disorder. | 2 | 1 / 54 | improvement |
| [`270`](families/270/) | Threshold and positive-energy bound states of the BFSS matrix model. | 2 | — | verification |
| [`271`](families/271/) | Bloch's law, its lattice correction, and the spherical magnetization law. | 4 | 1 / 317 | verification |
| [`272`](families/272/) | Entanglement without distillable secret key. | 1 | 1 / 117 | verification |
| [`273`](families/273/) | The entropy photon-number inequality. | 1 | 1 / 102 | verification |
| [`274`](families/274/) | Parity is not in QAC<sup>0</sup>. | 2 | 1 / 82 | improvement |
| [`275`](families/275/) | QMA-hardness of continuum Coulomb energy. | 2 | 1 / 79 | improvement |
| [`276`](families/276/) | Classical capacity of generalized amplitude damping. | 1 | 1 / 591 | verification |
| [`277`](families/277/) | Threshold repetition for entangled games. | 1 | 1 / 759 | verification |
| [`278`](families/278/) | Failure of Kohn–Sham ensemble representation. | 1 | — | verification |
| [`279`](families/279/) | Exact quantum factoring over a fixed finite gate set. | 1 | 1 / 98 | verification |
| [`280`](families/280/) | Unitary vertex operator algebras and conformal nets. | 1 | 1 / 198 | verification |
| [`281`](families/281/) | QAOA attains the SK optimum in the thermodynamic-first limit. | 2 | 1 / 112 | no substantive output |
| [`282`](families/282/) | From scale symmetry to local conformal symmetry in four-dimensional QFT. | 1 | — | verification |
| [`283`](families/283/) | Polynomial-time unitary synthesis from a Boolean oracle. | 1 | 1 / 521 | verification |
| [`284`](families/284/) | The optimal quartic separation between randomized and quantum queries. | 1 | 1 / 300 | verification |
| [`285`](families/285/) | Counterexamples to Baum–Connes and Kadison–Kaplansky. | 3 | — | improvement |
| [`286`](families/286/) | Rigidity and arithmetic of lattice von Neumann algebras. | 2 | 1 / 74 | verification |
| [`287`](families/287/) | Isomorphism of the free group factors. | 1 | 1 / 81 | verification |
| [`288`](families/288/) | Kadison's similarity conjecture. | 1 | 1 / 205 | verification |
| [`289`](families/289/) | Strong Kadison–Kastler stability and its spatial boundaries. | 3 | 1 / 115 | improvement |
| [`290`](families/290/) | Relative bicentralizers and modular spectral recovery. | 2 | 1 / 162 | verification |
| [`291`](families/291/) | Cuntz comparison, nuclear dimension, and equivariant Jiang–Su stability. | 4 | 1 / 139 | verification |
| [`292`](families/292/) | Kirchberg's $`\mathcal O_2`$ norm-ultrapower embedding problem. | 1 | — | verification |
| [`293`](families/293/) | Invariant projections, hyperinvariant subspaces, and transitive algebras. | 2 | 1 / 532 | verification |
| [`294`](families/294/) | Kaplansky's quasitrace conjecture and failure of tensor-product stable finiteness. | 1 | 1 / 9 | verification |
| [`295`](families/295/) | The Kadison–Ringrose cohomology conjecture. | 1 | 1 / 262 | verification |
| [`296`](families/296/) | The generator problem for finite factors. | 1 | 1 / 232 | verification |
| [`297`](families/297/) | A ZFC counterexample to Naimark's problem. | 1 | 1 / 104 | verification |
| [`298`](families/298/) | Two notions of free entropy differ even when both are finite. | 1 | 1 / 65 | improvement |
| [`299`](families/299/) | The Kirchberg–Rørdam character criterion and infinite tensor-power Jiang–Su stability. | 1 | 1 / 340 | verification |
| [`300`](families/300/) | Approximation and quadratic strong-operator paving. | 2 | 1 / 897 | improvement |
| [`301`](families/301/) | Trace cones and Razak–Jacelon stabilization. | 1 | 1 / 61 | verification |
| [`302`](families/302/) | Radius of comparison equals half the mean dimension. | 2 | 1 / 113 | verification |
| [`303`](families/303/) | Weak pure infiniteness and Cuntz-algebra absorption. | 1 | 1 / 150 | verification |
| [`304`](families/304/) | The Hilbert–Smith conjecture in every dimension. | 1 | 1 / 83 | improvement |
| [`305`](families/305/) | Four-dimensional disk embedding and Wall's conjecture. | 3 | — | verification |
| [`306`](families/306/) | The purely cosmetic surgery conjecture. | 1 | 2 / 240 | verification |
| [`307`](families/307/) | Failure of rational injectivity for maximal coarse assembly. | 2 | 1 / 163 | improvement |
| [`308`](families/308/) | Finite Smith–Toda complexes at every height. | 2 | 1 / 802 | verification |
| [`309`](families/309/) | The Kervaire invariant problem at the prime three. | 1 | — | verification |
| [`310`](families/310/) | Quillen's conjecture in rational homology. | 1 | 1 / 111 | verification |
| [`311`](families/311/) | The Hovey–Strickland and Chai conjectures. | 1 | 1 / 112 | verification |
| [`312`](families/312/) | The Grothendieck homotopy hypothesis. | 1 | 1 / 231 | verification |
| [`313`](families/313/) | Finite generation for the $`K(n)`$-local sphere. | 1 | — | improvement |
| [`314`](families/314/) | Cyclic length and chromatic fixed-point loss. | 1 | 1 / 193 | improvement |
| [`315`](families/315/) | The four-dimensional Singer conjecture. | 1 | 1 / 180 | improvement |
| [`316`](families/316/) | Curtis’s conjecture. | 1 | 1 / 104 | verification |
| [`317`](families/317/) | Thomason model structures in all strict higher dimensions. | 1 | 1 / 134 | verification |
| [`318`](families/318/) | Chromatic splitting: filtrations and counterexamples. | 5 | 10 / 988 | improvement |
| [`319`](families/319/) | Counterexamples to finite generation at chromatic height two. | 1 | — | improvement |
| [`320`](families/320/) | Nonhomeomorphic closed aspherical four-manifolds. | 1 | 1 / 123 | error found |
| [`321`](families/321/) | A counterexample to Wall's finite D(2) problem. | 1 | 3 / 2,491 | improvement |
| [`322`](families/322/) | Tingley’s sphere-isometry problem. | 1 | 1 / 593 | verification |
| [`323`](families/323/) | Independence of the separable quotient problem. | 1 | 2 / 243 | improvement |
| [`324`](families/324/) | Lipschitz equivalent Banach spaces need not be linearly isomorphic. | 2 | 1 / 55 | verification |
| [`325`](families/325/) | The complete Crouzeix conjecture. | 2 | 1 / 292 | verification |
| [`326`](families/326/) | The cotype–cotype conjecture under the approximation property. | 1 | 1 / 258 | improvement |
| [`327`](families/327/) | Markov type characterizes superreflexivity. | 1 | 4 / 102 | verification |
| [`328`](families/328/) | Nonexpansive fixed points in reflexive Banach spaces. | 1 | 3 / 1,549 | verification |
| [`329`](families/329/) | A counterexample to metric-entropy duality. | 1 | 1 / 798 | improvement |
| [`330`](families/330/) | A uniformly discrete counterexample to bounded approximation in Lipschitz-free spaces. | 1 | 2 / 845 | improvement |
| [`331`](families/331/) | Reflexive midpoint convexity and diamond distortion. | 7 | 1 / 108 | improvement |
| [`332`](families/332/) | Metric Markov cotype of <i>ℓ</i><sub>1</sub> and Hilbert-space Lipschitz extension. | 1 | 1 / 156 | improvement |
| [`333`](families/333/) | Smooth isometric immersions of surfaces into ℝ<sup>4</sup>. | 1 | 1 / 81 | improvement |
| [`334`](families/334/) | A smooth surface metric with no local isometric immersion in ℝ<sup>3</sup>. | 1 | 1 / 70 | verification |
| [`335`](families/335/) | Gromov’s integral scalar-curvature bound for simplicial volume. | 2 | 1 / 139 | improvement |
| [`336`](families/336/) | Spectral scalar curvature, Urysohn width, and macroscopic dimension. | 3 | 1 / 187 | verification |
| [`337`](families/337/) | Sharp Cartan–Hadamard isoperimetry and rigidity. | 2 | 1 / 60 | improvement |
| [`338`](families/338/) | Yau's uniformization conjecture. | 1 | 1 / 73 | verification |
| [`339`](families/339/) | Katok's entropy rigidity conjecture. | 1 | 1 / 172 | verification |
| [`340`](families/340/) | A counterexample to the nearby Lagrangian conjecture. | 1 | — | verification |
| [`341`](families/341/) | Donaldson's hypersymplectic deformation conjecture. | 1 | 1 / 148 | verification |
| [`342`](families/342/) | Donaldson's tamed-to-compatible conjecture. | 1 | 1 / 112 | verification |
| [`343`](families/343/) | Symplectic ball packing in higher dimensions. | 1 | 1 / 34 | verification |
| [`344`](families/344/) | The metric Blaschke conjecture. | 1 | 1 / 25 | verification |
| [`345`](families/345/) | Infinitely many closed geodesics on Riemannian spheres and closed three-manifolds. | 1 | 1 / 617 | verification |
| [`346`](families/346/) | Sharp singular-set bounds for stationary integral varifolds. | 2 | 1 / 61 | verification |
| [`347`](families/347/) | Counterexamples to stable-Morse and strong Arnold fixed-point bounds. | 5 | 1 / 202 | improvement |
| [`348`](families/348/) | Nonnegative-curvature Einstein classification and an <i>L</i><sup>2</sup> topological gap. | 3 | — | improvement |
| [`349`](families/349/) | The Solomon–Yau least-volume conjecture. | 1 | 1 / 405 | verification |
| [`350`](families/350/) | Yau’s nodal bounds: surfaces and higher dimensions. | 3 | — | improvement |
| [`351`](families/351/) | Scalar curvature and finite-time Ricci-flow singularities. | 3 | — | improvement |
| [`352`](families/352/) | A finite-time singularity of Calabi flow. | 1 | — | improvement |
| [`353`](families/353/) | Affine Bernstein rigidity through dimension nine and a smooth dimension-ten counterexample. | 2 | 1 / 166 | verification |
| [`354`](families/354/) | The isoperimetric profile of the cubic three-torus. | 1 | 1 / 124 | verification |
| [`355`](families/355/) | Unique tangent flows at the first surface singularity. | 1 | 1 / 190 | verification |
| [`356`](families/356/) | Gigli’s characterization of Alexandrov curvature. | 2 | 1 / 60 | verification |
| [`357`](families/357/) | Bi-Lipschitz coordinates at every regular RCD point. | 1 | — | verification |
| [`358`](families/358/) | A three-manifold without conjugate points or nonpositive curvature. | 1 | — | improvement |
| [`359`](families/359/) | Negative Kähler curvature without bounded holomorphic coordinates. | 2 | 1 / 171 | improvement |
| [`360`](families/360/) | Weak MTW curvature gives convexity and regular optimal transport. | 2 | 2 / 229 | verification |
| [`361`](families/361/) | Failure of integer-degree harmonic dimension comparison. | 2 | 1 / 86 | verification |
| [`362`](families/362/) | Global smoothness for relativistic Vlasov–Maxwell. | 1 | 1 / 110 | verification |
| [`363`](families/363/) | Nonuniqueness with local conservation for the hard-sphere Boltzmann equation. | 2 | 1 / 89 | improvement |
| [`364`](families/364/) | Kinetic limits and fluctuations over the Boltzmann lifespan. | 2 | 2 / 192 | improvement |
| [`365`](families/365/) | Joint metric and connection recovery from one boundary patch. | 3 | — | verification |
| [`366`](families/366/) | The planar Mumford–Shah regularity conjecture and local weak-<i>L</i><sup>4</sup> gradient bounds. | 1 | — | verification |
| [`367`](families/367/) | The critical dimension for the one-phase Bernoulli problem. | 1 | 1 / 58 | verification |
| [`368`](families/368/) | The three-dimensional Ball–Evans approximation problem. | 2 | 1 / 78 | verification |
| [`369`](families/369/) | The hot spots conjecture for simply connected planar domains. | 1 | 1 / 112 | verification |
| [`370`](families/370/) | The Lane–Emden and Hénon–Lane–Emden conjectures. | 1 | 1 / 59 | improvement |
| [`371`](families/371/) | Stable blowup for the defocusing Schrödinger equation. | 1 | — | verification |
| [`372`](families/372/) | Global uniqueness in smooth isotropic elasticity. | 1 | 1 / 147 | verification |
| [`373`](families/373/) | Nonattainment of the three-marginal Coulomb Monge problem. | 1 | 1 / 112 | improvement |
| [`374`](families/374/) | Sharp one-third stability of Brenier maps. | 1 | 2 / 294 | improvement |
| [`375`](families/375/) | De Giorgi's conjecture in dimension eight. | 1 | — | verification |
| [`376`](families/376/) | Universal computation in forced Navier–Stokes flows. | 9 | 1 / 312 | improvement |
| [`377`](families/377/) | Interior $`C^{1,\alpha}`$ regularity for infinity-harmonic functions. | 1 | — | improvement |
| [`378`](families/378/) | Disproof of the Exponential Time Hypothesis. | 1 | 1 / 205 | improvement |
