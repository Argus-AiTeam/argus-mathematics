# Cross-campaign reviewed facts

Facts, not instructions. Entries appear in Manager review order.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `The universal D/G/H partition, carry-preserving symmetries, and reviewed V112/V113 counts yield the stated group-ring identity and exact H count.`
- `Independent rational endpoint calculations verify the strict bracket 0.10795<sigma_*<0.10796.`
- `The reviewed prime-reciprocal Mertens theorem and Bertrand interval argument imply Lambda_X tends to infinity.`
- `For fixed r, bounding repeated indices gives e_r=Lambda_X^r/r!+O_r(Lambda_X^(r-2)); hence every fixed odd ideal truncation is eventually negative.`
- `OBJECTIVE.md and the exact residue equivalence confirm that V114 is a route obstruction, not a counterexample to the original problem.`

Fact: For the universal disjoint D/G/H partition, the exact count is |H_q|=(q-1)(q^2-10q+23+2χ_q(-1)). The associated strict threshold σ*=8−e^{ρ_7}/2 satisfies 0.10795<σ*<0.10796. Since Λ_X diverges and, for fixed r, e_r=Λ_X^r/r!+O_r(Λ_X^(r−2)), every fixed odd ideal truncation is eventually negative. This obstructs the specific fixed-order, full-prime-range propagation strategy but is not a counterexample to the original conjecture and does not rule out other fixed-order arguments.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `直接核对原题后，证明对 n=(P_Y t)^2-1，q<=Y 自动安全，Y<q<P_Y t 的危险条件精确等价于 t mod q^2 属于 Omega_q(P_Y)，而 q>=P_Y t 超出 sqrt(n) 的范围。`
- `lambda_q<=-1 由单事件逐点约束直接推出；Dusart 区间素数与 Y=2 through 6 的精确见证共同证明两个 singleton 最坏损失对所有 Y>=2 都超过 N。`

Fact: 对于 n=(P_Y t)^2-1，危险素数条件可精确转化为模 q^2 的剩余类事件；然而，所有满足规范化逐点下界的权重与逐项 CRT/区间余项盒结合时都会统一失败。该结论仅排除了这一逐项控制策略，尚未控制实际有符号聚合余项，也未产生反例或无穷例外族。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V116 的严格移动端点 telescope、V115.27 逐系数分块和偶数奇偶校正均由有限 Euler 乘积直接推出。`
- `Reviewer-owned 重放覆盖 1 至 7 个事件的奇偶情形，并检查 Y=3 时 2,582 个尾素数的整数 first-hit 与精确乘积降量；固定 Argus Python 的再次执行成功。`
- `已归档的 Heath-Brown Mertens 乘积和 Dusart theta 命题与本次使用的假设、范围和渐近推论一致。`
- `项目内维护页面摘录明确记录 Erdős Problem 676 仍为开放问题。`

Fact: 在该有界分析中，严格移动端点 telescope、逐系数分块及偶数奇偶校正均成立；即使先完整聚合再进行整数 first-hit 量化，完整最大素数块的逐块绝对值总量仍被迫达到渐近规模 (1/8+o(1))Y^8，因而压倒约为 Y^7 log Y 的边界项。这排除了依赖完整最大素数块形成后逐块取绝对值的证明路线，但未控制跨 q 的有符号总和，也未解决仍开放的 Erdős Problem 676。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `Steuding-Technau equation (8) explicitly contains an approximant-independent X^(3/4) term; Banks-Shparlinski fixes the finite-type slope and slope-dependent range; Maier-Rassias treats fixed-sequence prime-gap avoidance.`
- `The inspected exact rational LP returned matching primal and dual optimum 3/4.`

Fact: For the explicitly defined marginal Vaughan closure, the approximant-independent X^(3/4) term forces the optimal exponent to 3/4 and degenerates the closure to N=Y^8, exceeding the target scale by a factor of Y/log Y even when all blocks and signs are aggregated freely. This is a strategy-level obstruction only: it rules out that marginal single-slope closure but does not bound the actual mixed signed kernel or resolve the desired lower bound or original counterexample problem.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V118.5b identifies every unrestricted same-core summand with the product of two actual-hit indicators and the adjacency factor, so V117.33 makes it identically zero before Fourier approximation.`
- `The fixed distinct-core restriction is retained in the complete Fourier index and the weighted Gram entry.`
- `For every Y>=2, the pair (Y^2-2,Y^2-1) lies in the critical range, consists of nonsquares with different squarefree cores, and supplies the claimed nonexact harmonic cluster.`

Fact: Same-core summands vanish exactly before Fourier approximation, while the distinct-core restriction persists through the full Fourier index and weighted Gram formulation. Nevertheless, for every Y>=2, the distinct-squarefree-core pair (Y^2-2,Y^2-1) produces a nonexact harmonic cluster, showing that the obstruction for the global unweighted-cluster closure is not a finite-index artifact; this does not establish an obstruction for coefficient-weighted or support-sensitive mixed-kernel estimates.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `Parseval gives E_A,H(t)<1/(2A), so every selected arc has product squared mass below 1/(4AB) uniformly in t and H`

Fact: Parseval yields a uniform local mass bound: every selected arc has product squared mass below 1/(4AB), uniformly in the coefficient time parameter and truncation scale; however, this local ℓ² control alone does not establish the complete masked Gram bound.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `Irrational moving widths and positivity of the central Vaaler multiplier imply exactly 4H^2 nonzero harmonic rows for every active endpoint pair.`
- `The exact trace identity and coefficient-energy bound give tau>Z_Y/(16384*N*Y^4); rank(R)<=s_Y and tr(R)=4H^2*a_Y give kappa_S>=4H^2*a_Y/s_Y.`
- `Combining Z_Y>=s_Y proves kappa_S*tau>H^2/(4096*N*Y^4), whose ratio to Y^-2*log(Y)^2 diverges at every V118-admissible cutoff.`

Fact: For every active endpoint pair, the retained-mask Gram has exactly 4H^2 nonzero harmonic rows and satisfies kappa_S*tau>H^2/(4096*N*Y^4); relative to the required Y^-2*log(Y)^2 scale, this diverges at every admissible cutoff. Thus the coordinatewise normalized retained-mask Schur closure is uniformly ruled out, while the broader target remains unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `The V121 argument expands every zero, marginal, and joint Fourier term inside the original literal pair mask and combines singleton and pair contributions before applying a norm.`
- `The reviewed V117 consecutive-pair identity gives the physical critical last-hit expression, and the displayed algebra yields |D_crit-Delta_Y,H| bounded by the inherited endpoint error.`
- `The normalized endpoint error is o(Y^7 log Y) at every V118-admissible cutoff, with the harmful positive sign of D_crit stated correctly.`

Fact: 在原始字面配对掩码内，全部零模、边缘模和联合模可在取范数前重组；由连续配对恒等式得到的临界末次命中量满足 |D_crit-Delta_Y,H| ≤ E_Y,H，且对每个 V118-admissible cutoff 都有 E_Y,H=o(Y^7 log Y)。该结果仅精确识别了有害正号对应的未知量，尚未给出 D_crit 的全 Y 单边估计，也未建立该有符号重组机制的全 Y 障碍。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `独立核算得到五项相对指数下界依次为 1/4、1/4、1/10、1/10、1/4，满箱总指数为 31/10。`
- `精确 LP 重放返回 u=v=2、目标值 -7/10，加入常数 4/5 后得到 1/10。`
- `对 Y<q<2Y 的并集界严格小于 N，保证规定 closure 的环境支撑对每个 Y 非空。`

Fact: 对于明确定义的 coefficient-blind rank-one Wright support-norm closure，即使免费假设秩一分离并删除四个正项，最有利项仍产生相对字面支撑的 Q^(1/10-o(1)) 损失；五项相对指数下界为 1/4、1/4、1/10、1/10、1/4，满尺度箱总指数为 31/10。因此该 closure 只能退回 N=Y^8，不能达到目标量级 I_Y~Y^7 log Y。此结论仅排除该特定 closure，不构成原问题的反例，也不约束真实非可分张量可能具有的额外范数节省。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V122 的真实单位频率张量确为 q^(-3)C_(q,h)D_q(inverse(4P^2)m)，并保留移动端点及 survivor 权重。`
- `Ramanujan 正交给出精确常数 sum_m^*|D_q|^2=q(q-1)^2。`
- `Parseval 给出精确恒等式 sum_(q does not divide h)|C_(q,h)|^2=q^2 sum_a|S_a|^2-q sum_b|T_b|^2，即 q^2 倍条件 lift variance。`
- `未来 survivor 振幅、剩余类占用界及素数尺度推出全频谱能量 O(N^2 log(Y)/Y^4)，实际 dyadic box 仅由非负子集关系得到同阶上界。`
- `直接 Cauchy 的充分阈值是 o(N^2 log(Y)^3/Y^7)，故平方能量仍差三个 Y 次幂。`

Fact: 单位频率张量的归一化以及 Ramanujan 正交、Parseval 恒等式均得到独立核实；由现有振幅和占用界得到的全频谱能量为 O(N^2 log(Y)/Y^4)，实际 dyadic box 仅继承同阶单向上界，而直接 Cauchy 所需阈值为 o(N^2 log(Y)^3/Y^7)，尚差三个 Y 次幂。因此这些恒等式和能量估计不能推出目标不等式，也未建立冻结机制的全-Y 下界障碍，失败属于策略层而非恒等式层。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V123.76-V123.78 与已核查的能量和式推出总界 N Y^(-1/2)，并精确留下 Y^(1/2)/log(Y) 的目标差距。`
- `V123.79-V123.83 对任意固定正比例盒证明平方行和单位列均有数量级 q^2；Frobenius 范数除以秩给出算子范数下界 c_delta q，与 Fourier 上界 q 匹配。`

Fact: 在 Q 与 Y 同阶、u=v=2 的单位频率固定正比例盒机制中，Fourier 子矩阵方法给出总上界 N Y^(-1/2)；该盒上的算子范数下界与 Fourier 上界同为 q 的数量级，说明此支撑与 ℓ² 范数闭包已达最优，但所得界仍比目标 N log(Y)/Y 大 Y^(1/2)/log(Y)。这一结论不构成实际有符号张量下界、完整偏差估计或反例。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `Exact second-order survivor inclusion-exclusion, complete-period CRT mean zero and l1 control, monotone Abel summation, and third/fourth factorial-moment counting yield N/(Y*log(Y)^3)+Y^5/log(Y)^2=o(N*log(Y)/Y) for the complete unit-frequency Y<q<2Y block.`

Fact: For the complete unit-frequency block with Y<q<2Y, exact physical inversion, second-order survivor inclusion-exclusion, complete-period CRT cancellation, monotone Abel summation, and factorial-moment bounds give a total contribution N/(Y log(Y)^3)+Y^5/log(Y)^2=o(N log(Y)/Y). This conclusion does not cover nonunit or zero modes, other Q-ranges, complements, or establish the original conjecture's failure.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V125 gives the arbitrary-q pointwise decomposition, complete Fourier support calculation, and literal-weight physical inversion.`
- `The corrected CRT interval bound has an additive boundary term and yields the stated third-factorial-moment estimate.`
- `The independently replayed certificate returned the exact zero modes, coefficient -1 on every tested nonzero q-divisible mode, zero CRT period sums, and the stated target ratios.`

Fact: For the complete frequency block Y<q<2Y, the imprimitive-complement contribution is asymptotically negligible relative to I_Y. The missing-frequency kernel has zero mode vanishing and Fourier coefficient -1 on every nonzero q-divisible mode, while physical inversion preserves the literal A_{<q}(t)V_{>q}(t) weight. With the corrected additive CRT boundary term, second-order inclusion–exclusion, Abel summation, and the third factorial moment give N/(Y log^3 Y)+Y^3/log^2 Y=o(I_Y). This closes only that frequency block; the original counterexample objective and other ranges remain unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V126.30-V126.37 prove that the precisely frozen Boolean-support closure has sharp one-sided envelope I_+ for every Y>=2, hence asymptotic size I_Y rather than o(I_Y).`
- `V126.43-V126.46 isolate the unresolved actual arithmetic correlation as sum_j U_j*(pi_j-pbar_j).`

Fact: For every Y>=2, the frozen Boolean-support closure has sharp one-sided envelope I_+, asymptotically of size I_Y rather than o(I_Y); thus support-only information cannot yield the desired discrepancy bound, while the actual arithmetic correlation sum_j U_j*(pi_j-pbar_j) remains unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `Independent complete recomputation matched every active pair, danger hit, selector condition, signed block contribution, and finite correlation for Y=2,3.`
- `The four-point kernel has the stated exact CRT l1 norm, and its separately summed frozen-interface budget reaches I_Y at Q=Y*sqrt(log Y).`

Fact: For Y=2,3, complete independent recomputation verified all enumerated pairs, danger hits, selector conditions, signed block contributions, and finite correlations, while an exact four-point-kernel calculation showed that the frozen second-order CRT-l1-Abel interface has a budget of order I_Y at Q=Y*sqrt(log Y). This is a reusable obstruction to that proof interface, not evidence for the actual correlation’s asymptotic sign or magnitude.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `The q-local product-position map has multiplicity at most 2q; combining this with the exact unit-frequency energy after triple aggregation gives the claimed Q^(15/2) bound.`
- `The resulting terms have ratios O(Y^(-1/4)) and O(Y^(-1/2)*(log Y)^(9/4)) to I_Y.`

Fact: For the same-band diagonal-free four-point aggregate, the q-local product-position map has multiplicity at most 2q. Combined with exact unit-frequency energy after triple aggregation, this gives a Q^(15/2) bound and error terms whose ratios to I_Y are O(Y^(-1/4)) and O(Y^(-1/2)*(log Y)^(9/4)); hence this four-point contribution is o(I_Y). Mixed-band four-point and higher-order contributions remain unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `The mixed-box ledger explicitly permits 1<=H<q, but the combined nonzero-mode sparsity calculation only establishes H<r~Y.`
- `The certificate checks per-frequency identities and exponent balances but contains no calculation for the omitted large-H joint frequency regime.`

Fact: An unresolved truncation mismatch remains in the mixed-box energy argument: the ledger permits frequencies up to H<q, but the joint nonzero-mode sparsity calculation covers only H<r~Y, leaving the large-frequency regime Y<=H<q without a weighted joint energy bound.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `整数碰撞论证覆盖每个 1<=H<q，并精确分类所有非单点纤维及三个 r-adic 情形。`
- `三段 H 界直接除以 I_Y 后得到 O(1)、O(sqrt(Y/H))、O(Y^(-1/2))，中心短块仍为 O(I_Y)。`
- `原始目标要求任意大的严格反例族；V129 明确未声称反例或 Delta_le 的符号。`

Fact: 对每个 1≤H<q，整数碰撞可精确分类全部非单点纤维；归一化后的三段非零 Fejér 项分别为 O(1)、O(√(Y/H)) 和 O(Y^(-1/2))，但中心 unit-unit 短块目前仅有 O(I_Y) 上包络，尚不能推出 o(I_Y)、匹配下界、Delta_le 的符号或无界反例族。这确立了可复用的局部消障结论及其决定性方法边界。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V130.23-V130.32 correctly classify root collisions and the inverse-variable diagonal/off-diagonal completion.`
- `The archived external theorems concern fixed moduli, complete kernels, point counts, or conditional short sums and do not estimate the literal two-varying-prime form.`
- `The available bound is O(D^2 Q^2/(Y log D))=O(Y^7 log Y)=O(I_Y), so its ratio is only O(1).`

Fact: For the literal two-varying-prime form, the inverse-variable off-diagonal contribution remains at the same order as the diagonal under the available estimates. The resulting bound is only O(I_Y), so neither a lower-order saving nor the desired asymptotic conclusion follows; existing fixed-modulus, complete-kernel, point-count, and conditional short-sum theorems do not resolve this form.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `For every relevant sufficiently large Y, h<r makes h*P^(-1) a unit modulo r^2.`
- `Actual q-prime occupancy in each residue class modulo r^2 is at most Q/r^2+1, and the inverse-square map on units is exactly two-to-one.`
- `The reviewed V106.10 identity applies to the identical literal danger-root transform and yields an actual-q sample second moment O(Qr).`
- `Cauchy with the unchanged E_q, endpoint coefficient, and q-transform gives O(N^2*(log Q)^2/(Y^2*Q*r^4)) for the complementary squared factor and O(N*log Q/(Y*r^(3/2))) per r,h.`
- `Summing the actual h and r ranges gives O(Q^2*Y^(1/2)*log Q), whose ratio to I_Y is O((log Y)^2/Y^(1/2)) and tends to zero.`
- `The current certificate delta replayed successfully, and the prior exact Abel reduction carries every endpoint and partial sum with additional o(I_Y) error.`

Fact: For the complete one-prior-prime central V130.20 contribution, residue-class occupancy together with the two-to-one inverse-square map converts the V106.10 energy estimate into an actual-prime-sample second moment of O(Qr). Combined with the complementary Cauchy bound and the exact Abel endpoint reduction, summation over the actual h and r ranges is O(Q^2 Y^(1/2) log Q), with ratio O((log Y)^2/Y^(1/2)) to I_Y; hence this contribution is o(I_Y). This does not establish the full survivor estimate, a signed main term, or a counterexample family.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `The same-band box satisfies p<q, q^2<N<(pq)^2 and K~(log Y)^2<p<q; both dispersion minima select cardinality and give Q^4/(Y log Q)~I_Y.`
- `The joint incidence calculation gives the available O(Q(log Q)^3) bound against the required o(Q(log Q)^2) threshold.`

Fact: In the admissible same-band prime box with p and q of order Y^2 sqrt(log Y), both dispersion directions simultaneously lose all gain: their minima reduce to cardinality bounds, leaving the central term and nonzero Fejér upper envelope at order I_Y, while zero-mode and Abel endpoint terms are negligible. The independent diagonal-energy mixing route therefore has a precise unresolved logarithmic gap: the available joint-incidence bound is O(Q(log Q)^3), whereas closure requires o(Q(log Q)^2). This identifies a route-level limitation, not an estimate of the actual contribution or an arithmetic obstruction.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V133 的 m=0 分支只产生 p=p'、h=h' 的精确对角项。`
- `非零 m 分支化为有界二次型范数方程，每个固定参数片只有 divisor-many ideals 和 logarithmically many bounded generators。`
- `总 incidence 为 H*n_minus*n_plus+O_delta(Q*(log Q)^8)=O_delta(Q^2)=o(Q^2*log Q)。`
- `字面中心及非零 Fejer fiber Gram 传播得到 O_delta(Q^4/(Y*(log Q)^(3/2)))=o(I_Y)。`

Fact: 在分离的 one-prior-prime same-band box 中，零分支仅给出精确对角项，非零分支可归约为有界二次型范数方程并获得幂次节省；由此总 incidence 为主对角项加可忽略误差，且对应 fiber Gram 贡献相对于 I_Y 可忽略。该结论不涵盖全阶传播或无限反例族。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V134.6 与 V134.12 的零参数对角和二次范数方程计数支持完整可比三角 incidence；在目标同尺度处非对角为低阶。`
- `V132.24–V132.40、V133 的字面 fiber Gram 与 V134.30–V134.39 相互一致，过渡盒最终包络为 Y^7 log Y+Y^6(log Y)^(7/2)=O(I_Y)。`

Fact: 在目标尺度下，完整可比三角 incidence 已得到覆盖且非对角项为低阶，但字面 fiber Gram 的过渡盒包络仍为 O(I_Y)，表明当前瓶颈来自加权对角项，而非无权逐盒 incidence、完整 Delta_le 估计或已知反例。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V135.12--V135.15 gives the exact literal diagonal/collision Gram expansion, and V134.36 makes the weighted forward collision lower order.`
- `V135.17--V135.22 correctly bounds the reverse joint-frequency incidence by reducing nonzero collisions to the reviewed quadratic norm-equation count.`
- `V106 unit Parseval plus the trivial transform maximum yields the fourth-moment majorant used in V135.23--V135.26 and the claimed one-log Gram saving.`
- `V135.28--V135.30 correctly transfers the weighted Gram bounds to the unsquared central and nonzero Fejer transition sums.`

Fact: Exact collision-Gram analysis shows that the central and all nonzero Fejer-weighted Gram terms are O(Y^6/(log Y)^2), including strictly lower-order off-diagonal reverse collisions. Consequently, the unsquared transition sum is O(Y^7 sqrt(log Y)) and negligible relative to I_Y. This resolves the first transition obstruction but does not control the full positive part of Delta_le or establish a counterexample.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `The global graph is formed before dyadic estimation, so cross-box repeated vertices are included in the bad-edge set.`
- `On Y^(101/50)<p<q<=Y^(203/100), the global bad central contribution is O(Y^(551/100+o(1))*log Y)=o(I_Y).`
- `One global weighted Cauchy estimate bounds the complete central globally good matching family by O(Y^7*log Y)=O(I_Y), repairing the previous O(Y^7*(log Y)^2) summation defect without obtaining little-oh.`
- `A common Fejer degree H=Y^(3/25) gives O(Y^7) for all nonzero Fejer terms and O(Y^7/log Y) for the zero mode; the Abel replacement is also o(I_Y).`
- `The exact frontier calculation places the infimum of the V132 no-saving region at (a,b)=(2,2), so the former isolated V136 scale is not first.`

Fact: A global graph formed before dyadic estimation captures cross-box collisions and makes the bad central, nonzero Fejer, zero-mode, and Abel-replacement terms negligible relative to I_Y. However, global weighted matching only improves the remaining central good family to O(I_Y), not o(I_Y), leaving a genuine strategy-level gap whose no-saving region begins at the frontier (a,b)=(2,2), rather than at an isolated V136 scale.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `逐式核对确认 V106.7 与两素数 CRT 给出 V137.14–V137.16 的取绝对值前展开`
- `分圆多项式论证、终端正弦零点排除及 Fejer 因子正性共同证明每个保留目标边非零`
- `独立计算确认 c₀≈0.0235580031>3/391，并验证顶角连续轮廓为零`

Fact: 两素数 CRT 展开已独立核实，且每个保留目标边均非零；固定底部相邻壳的系数极限 c₀≈0.0235580031>3/391，顶角连续轮廓为零。但逐边非零不能排除不同项间的有符号抵消，局部壳正性也不能决定整个楔的符号，因此尚未得到 little-oh 或 signed Omega 结论。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `精确分部求和给出充分条件 Q(Y)=o(1)，而粗几何界仅给出 Q(Y)=O(Y^(3/25)/(log Y)^2)；显式驻定支撑证明所保留的粗性质本身不能强制消去。`
- `两条 CRT 互反恒等式成立；Baier Corollary 1 的主来源明确要求 L^2*M>=r^(1+8*epsilon)，实际最有利代入仍有 L^2*M/r<=Y^(-89/50)。`
- `与 V136 的已审结果直接比较后，完整聚合的最强结论仍为 O(I_Y)。`

Fact: 精确分部求和将 Route A 的目标归约为 Q(Y)=o(1)，但现有粗几何性质只能给出更弱且随 Y 增长的界，不能强制消去；Route B 所依赖的现有相关定理也因固定幂级的适用范围缺口而不可用。因此这两项具体策略被排除，而完整聚合目前仍仅有 O(I_Y)，所需的 little-oh、渐近符号证据或反例仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `canonical lift 恒等式给出不可删除的非恒定平方数字 Fermat-quotient 扭曲；原始 Shkredov Theorem 2 只陈述无权 Heilbronn 和估计。`
- `完整四移位直方图满足 D(-s)=-D(s) 且 D(0)=0，因此对称性产生的常相位主项严格消失。`

Fact: 真实 canonical Hensel 变换会保留不可删除的非恒定平方数字 Fermat-quotient 扭曲，因而不能直接套用仅针对无权 Heilbronn 和的 Shkredov 定理；同时，完整四移位张量的奇对称性使唯一常相位主项严格为零。这两重阻碍说明，即使反事实的无权估计足够强，也无法由该路线推出所需的渐近消失或非零有符号主项。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `Independent brute-force checks verified the local collision formula, actual CRT scalar identity, Ramanujan trace identity, and one submitted certified canonical interval.`
- `The pinned Jacobian operation was independently inspected and replayed with the recorded payload; its output is only a bounded nonorthogonality finding.`

Fact: Independent checks confirm the local collision, CRT scalar, and Ramanujan trace identities, but the replayed Jacobian result establishes only bounded nonorthogonality and does not resolve the required asymptotic incidence condition.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `评审判断写入前，公开证书入口退出码为零并输出 Galois 二阶矩、O(K^2/(p*q)) 坏乘子密度及缺失的确定性 incidence 条件。`
- `独立枚举检查了 232 个局部碰撞情形、三个精确 Ramanujan trace 情形及第二个 CRT 标量情形，全部一致。`
- `原始目标要求无限反例族；V140 声明和结果明确保留 Q(Y)=o(1)、精确候选及反例为未证明。`

Fact: 独立检查验证了 V140 范围内的局部碰撞公式、Ramanujan 二阶矩以及坏乘子密度界 O(K^2/(p*q))；但确定性 incidence 条件仍缺失，因而不能推出 Q(Y)=o(1)、精确候选或无限反例族。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V141.23–V141.28 正确区分等频碰撞与大值成员关系，并只恢复现有 O(1) 归一化界。`
- `V141.29–V141.38 的精确比较族满足所列边际约束，同时绝对质量趋于 1/2、坏对关联发散。`

Fact: 精确比较族表明，仅凭等频碰撞计数与边际 Parseval 约束不能推出归一化绝对质量为 o(1)：这些约束可同时成立，而绝对质量仍趋于 1/2，坏对关联甚至发散。该结论仅针对比较模型，并非实际素数或 canonical Hensel transform 构造的反例。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `An isolated V142 certificate run and an independent direct paired-cosine computation reproduced all canonical transforms, degree-one masks, complete-permutation means, partial-sum maxima, three suppression signs, one excess sign, and the excess literal anchor.`
- `The exact permutation mean, centering, and variance identities are valid, but they yield no estimate beyond the existing O(1) envelope for the magnitude target.`
- `The operative preregistration revision followed the first discriminator command; the overwritten initial record and first result are not preserved byte-faithfully, so preregistered route exhaustion cannot be independently established.`

Fact: Independent recomputation confirmed the finite canonical transform, permutation-mean, partial-sum, sign-pattern, centering, and variance results, but the exact identities do not improve the existing O(1) magnitude bound. Because the operative preregistration postdated the first discriminator run and the initial record was not preserved verbatim, this is only post hoc finite evidence and does not establish preregistered route exhaustion or resolve the asymptotic question.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `独立分支算术确认诊断 D^2 下界约为 4.55e-23，而 4V 上界约为 2.63e-22；anchor D^2 下界约为 2.50e-35，而 V 上界约为 5.27e-35。`
- `写保护完整重放与首结果的非 opaque 内容一致，共覆盖 30,240 个诊断排列和 8 个 anchor 排列。`
- `OBJECTIVE.md 要求任意大的不可表示整数；V143 明确未声称候选、无限族或反例。`

Fact: 独立有限验证表明，诊断与锚点的信号下界均未超过相应方差门槛，因此没有触发分支选择，canonical placement 仍开放；该结果不证明或否定原始渐近反例命题。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `验证了 log(P_Y R t)=Y+o(Y)、至多十个被省略大素因子的 1+O(1/Y) 影响以及 I_(Y,R)~Y^7 log(Y) 的统一性。`
- `核对了完整块指数 -183/50、不完整块指数 -279/50、全局坏边指数 -139/100，以及由非负平均选取共同最小化乘子 R_Y 的推导。`
- `核对了单位缩放保持碰撞、受保护素数删边不产生坏边，并确认 V138 终端系数及 suffix/Abel 误差对 R 的转移保持统一。`

Fact: 对固定 V136 楔形中的实际相邻壳族，全部合法 R≤Y^10 均满足统一基准 I_(Y,R)~Y^7 log(Y)；完整块、不完整块和全局坏边分别具有负指数 -183/50、-279/50 和 -139/100，因此存在同一个确定性乘子 R_Y 使 Q_(R_Y)(Y)=o(1)，从而实际相邻壳贡献为 o(I_(Y,R_Y))。该结论不涵盖非相邻壳、其他楔形、高阶低周期项或 selector tail。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V140 的逐对碰撞公式和 trace 只使用 K_(q,p)^2<min(p,q)；H^2<A 在完整 wedge 上统一满足该条件。`
- `独立精确重放非相邻素数对 p=11、q=29、T=3，直接 trace 与碰撞公式一致。`
- `公共乘子平均的完整块、不完整块、好对及原全局坏对指数分别核得 -61/50、-157/50、-61/50、-139/100。`
- `V136 全局坏边计数、V138 离散分部求和以及 V144 的合法乘子、suffix、保护素数和图不变量足以转移到完整固定 wedge。`

Fact: V140 的逐对碰撞 trace 不要求素数相邻，只需满足 K_(q,p)^2<min(p,q)；由于 H^2<A，该条件可统一覆盖完整固定 wedge。结合公共乘子平均与既有坏边界估计，V136 的该固定 one-prior wedge 可推进到相对于目标尺度可忽略的贡献，但其他素数范围、高阶低周期项、selector tail 及正 survivor 总数仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `Inspected the original objective and the complete V146 argument against the inherited V129, V132, V140, V144, and V145 interfaces.`
- `Checked the exact ramified trace identity, all valuation cases, cutoff union, common-multiplier averaging, Abel variation, Vaaler errors, zero mode, and little-oh exponents.`
- `Reran the substantive exact certificate checks and the pinned read-only Ramanujan operation, which returned c_(11^2)(11)=-11.`

Fact: For every fixed 0<η<1/7, exact local-factor control across unit-unit, mixed, and ramified-ramified frequencies, together with common-multiplier averaging, absorbs the quadratic T-loss and makes the complete one-prior subcritical strip negligible relative to the main scale. This conclusion does not resolve the critical product boundary or produce a counterexample.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `精确证明 N_q(h,h')=O(1+q/m^2+m^2/q) 以及总碰撞占用 O(qT+T^2+T^4/q)`
- `完整保留 p-进赋值情形后得到 O(p^3q^3(T+T^4/q^2)) 的矩估计`

Fact: 按本原比值汇总碰撞可得点态格点界 N_q(h,h')=O(1+q/m^2+m^2/q) 和总占用界 O(qT+T^2+T^4/q)，从而在保留全部 p-进赋值情形时推出改进矩估计 O(p^3q^3(T+T^4/q^2))；该解析结论扩大了已闭合的 one-prior 区域，但尚未构成原命题的反例。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `Binary prefix decomposition and same-level disjointness give the claimed J_(p,q)^2 maximal second-moment loss for arbitrary complex frequency sums.`
- `The reviewed collision and ramified-trace bounds imply the stated bad-scalar estimate for every legal frequency range used by V148.`
- `The complete-block budgets Y^(-1)*(log Y)^(5/8) and (log Y)^(-2*eta), and the incomplete-block budgets Y^(-1)*(log Y)^(3/8-2*eta) and (log Y)^(-1/4-4*eta), all tend to zero after the literal coefficient variation.`
- `The inherited moving-Abel, nonzero-Fejer, zero-mode, complete-period, common-scaling, and protected-prime interfaces were inspected and match the V148 claim.`
- `Exact subchecks and an independent (p,q,H)=(7,19,18) noninitial-interval trial reproduced the factored trace, all ramified valuation cases, same-level disjointness, and the maximal envelope.`

Fact: For the scoped one-prior-prime regime, binary prefix decomposition and disjoint frequency pairs at each dyadic level reduce the maximal second-moment collision loss to a single squared level cost rather than a union loss over cutoffs. Combined with the reviewed collision and ramified-trace bounds, all four complete- and incomplete-block multiplier budgets vanish, yielding one common legal multiplier throughout the range pq ≤ Y^5(log Y)^(-1/8-eta). This is an analytic partial result only; larger products, higher prior-prime orders, selector tails, remaining parameter ranges, and a positive survivor estimate remain unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `一般性论证在 q<=2p、T<p 下证明共享 primitive ratio 的双素碰撞占据界。`
- `独立精确枚举覆盖 32 个可比素数对、15,588 个逐点碰撞检查和 642 个完整截断，未违反逐点界或求和界。`
- `双局部非初始区间迹、dyadic prefix 恒等式、四个指数预算及固定 typed Jacobian 有理系统均独立重放成功。`

Fact: 在 q≤2p 且 T<p 的可比素数区域，共享同一 primitive ratio 的两个局部因子满足统一的双素碰撞占据界 O(pqT+T^6/(pq))；该机制经 32 个素数对、15,588 个逐点检查和 642 个完整截断的精确枚举验证，并支持双局部迹、dyadic prefix 与四个趋零端点预算的联合分析。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `共同 primitive ratio 的三局部占用计算给出 O(p*r*q*T+T^8/(p*r*q))，任意区间 Ramanujan trace 和 dyadic 前缀不等式给出声明的 J^2 极大矩及 bad-scalar 界。`
- `完整块与尾块的四项联合平均预算分别具有声明的 Y 与 log Y 衰减；非负性保证一个最小联合乘子同时控制 V149 和 V150 incidence。`
- `完整精确证书已独立重放；三个新的近 q=2p 三元组覆盖 1064 个频率对和全部 56 个截断，未违反点态或求和占用界。`

Fact: 在指定的可比三素数区域中，三个局部因子共享同一 primitive ratio，由此得到三局部占用界 O(p*r*q*T+T^8/(p*r*q))；结合精确 Ramanujan trace 与 dyadic 前缀不等式，可推出所需的 J^2 极大矩和 bad-scalar 界。四项联合平均预算均按所声明的 Y 与 log Y 速率衰减，并存在同一个最小联合乘子同时控制 V149 和 V150 incidence；该结论是局部解析部分结果，尚未解决原始无限反例问题。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `Recomputed 1<H_q<q, the maximal moment, the bad-scalar bound, and all four complete and incomplete incidence exponents.`
- `Replayed the substantive exact certificate operations and independently checked q=19, 23, and 29 over 1,592 frequency pairs, 68 cutoffs, and 830 arbitrary intervals.`

Fact: For the zero-prior range Y^4 < q <= Y^(26/5)(log Y)^(-1/5-eta), the positive sparse-tail term is o(I_{Y,R_{Y,eta}}) under a legal multiplier preserving the reviewed regions. In particular, the critical incomplete-linear contribution is O((log Y)^(-2eta)), rather than constant. This is a scoped partial result; sparse prior-prime terms, larger q, remaining low-period boxes, other A-ranges, and the infinite-exception objective remain unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `V153.14-V153.16 and the complete V154 derivation were inspected term by term, including moving endpoints, suffix jumps, protected-prime deletion, prime-dependent windows, and complete ideal blocks.`
- `The exact certificate replayed 4,535 A-blocks; an independent bounded implementation checked 218 cases, 690 active-prime instances, 24,541 A-blocks, and 42 protected-deletion cases.`
- `The V116 comparison was inspected directly: V116 takes absolute values over completed prime blocks, whereas V154 cancels every internal A-boundary before one global separation.`
- `The independent V154 judgement was recorded, and both math-state checks plus proof-graph check and gap completed successfully.`

Fact: In the V154 decomposition, cancelling all internal A-boundaries before global separation yields the exact identity T^(0)_{Q_eta,R}=H_R-D_R. The separated term D_R remains asymptotic to Y^8 after protected-prime deletion, so any argument that bounds H_R and D_R separately incurs a budget at least of that scale, far exceeding the Y/log Y target. This rules out the separate-bounds interface but does not rule out a joint signed estimate for |H_R-D_R| or resolve the original counterexample objective.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `完整展开保留移动素数端点、两侧 suffix、受保护素数删除、素数依赖窗口和完整理想质量。`
- `对不同 q,r>X 的逐项绝对值预算逐切片至少为 d_{R,t}^{>X}d_{R,u}^{>X}-1/(X-1)=1-o(1)，总预算因而至少为 (1-o(1)Y^16。`

Fact: 完整协方差展开表明，对不同高素数采用逐项绝对值的 complete-period 预算时，每个切片的下界为 1-o(1)，总预算至少达到 (1-o(1)Y^16；因此该冻结接口无法产生所需的小量估计。此结论不适用于保留符号的真实二阶矩，原反例目标仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2248

Evidence refs:
- `精确重放对222589个(t,q)项及其10938167706个有序异素数项完成计数，两种聚合形式逐R一致，并严格判定kappa小于1/2。`
- `Baier–Zhao 定理1公式(1.7)的原始文本确认其 Q^3+N+min(N sqrt(Q),sqrt(N) Q^2)界及适用条件；代入冻结尺度得到 Y^(34+o(1))*log(Y)。`

Fact: Baier–Zhao 定理在冻结尺度下仅给出 Y^(34+o(1))*log(Y) 的上界，不能提供实际 V155.21 有符号协方差所需的充分尺度估计；有限判别虽严格得到 kappa<1/2，但只排除了一个证明接口，原目标命题仍未解决。
