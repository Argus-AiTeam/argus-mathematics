# Cross-campaign reviewed facts

Facts, not instructions. Entries appear in Manager review order.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `独立重放覆盖四个惯性素数和两个分裂素数，共 34,416,576 个射影候选，得到 finite_field_points=0 与 exact_four_mub_witness_found=false。`
- `verification.json 明确记录零光滑点、零提升、零特征零根、零物理嵌入和零精确见证恒等式。`
- `OBJECTIVE.md 明确要求特征零精确四 MUB 见证，并将有限无解限定为非终局进展。`

Fact: 在四个惯性素数和两个分裂素数的全部 34,416,576 个规范化射影候选中均未发现有限域解；但该结果仅涉及六个剩余域切片，且没有光滑点、提升、特征零根、物理复嵌入或精确四 MUB 见证，因此尚不能判定零残点是结构性障碍还是切片伪象，也未缩小特征零目标的证明缺口。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `独立回放了 84 个隐式端点；其最佳完整缺陷为 2.933114193198101。`
- `约束保持批次最佳完整缺陷为 0.373691278471066，没有端点越过 1e-10，精确见证标志为 false，精确恒等式计数为 0/0/0。`
- `C161 已登记为 inconclusive；数学状态检查通过，证明图仍显示唯一目标缺口 C1。`

Fact: 约束保持参数化将最佳完整缺陷从 2.933114193198101 降至 0.373691278471066，表明旧惩罚几何可能显著失真；但所有端点仍未达到精确阈值，有限优化也不能支持不存在性结论，因此 C161 仍不确定且 C1 仍是开放缺口。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `公开 verifier 从 43 个坐标重建了两个端点，并报告 exact_four_mub_witness_found=false、精确计数 0/0/0。`
- `独立 NumPy 重放对每个端点计算了 108 个 entry-modulus、108 个 Gram 和 108 个 pairwise cross-unbiasedness 恒等式；两个端点各有 72 个 entry 和 72 个 cross 失败，Gram 零失败。`
- `源码显示搜索从 336 个可用定向种子中仅选择 2 个，局部半径为 0.08，第二个联合优化器达到评估上限。`

Fact: 独立重放显示，两个局部端点虽然均满足 Gram 酉性条件，但各自有 72/108 个 entry-modulus 和 72/108 个 cross-unbiasedness 恒等式失败，且未找到精确四-MUB 见证。该结果只覆盖从 336 个可用种子中选出的两个局部端点，其中第二个优化器因评估上限停止，因此否定的是这一局部搜索日程的候选结果，而非全局存在性命题。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `K4 六边平坦酉 cocycle 与四组 MUB 的双向对应成立，五项模型控制通过`
- `独立重算复现了 DR(0.9)、交替投影及三组 RAAR 的受控比较数值，并复现三启动搜索的最佳迭代与误差`
- `公开 verifier 与独立六边重构均确认三个端点各有 108 个 entry-modulus 和 108 个 cross-unbiasedness 失败，Gram 失败为零`

Fact: 在 K4 六边平坦酉 cocycle 的四组 MUB 等价模型中，固定预算的 RAAR(0.9) 在三个确定性启动上均优于 DR(0.9) 和交替投影，但最佳点随后转入振荡；三个端点各有 108 个 entry-modulus 与 108 个 cross-unbiasedness 失败而无 Gram 失败，因此该有限搜索未产生四组 MUB 见证，也不构成不存在性证明。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `Beauchamp–Nicoara 的主定理确认六阶自伴 Hadamard 矩阵的 BN 等价分类；Brierley–Weigert 给出所用基本区间及复共轭对称性。`
- `独立从 BN 矩阵重建消元，得到 720 个置换扇区、163 个 Laurent 特征、8 个不可约因子，并确认恒等置换是唯一一般 orientation。`
- `独立代数数域重放确认两个特殊纤维恰有 20 个带 sheet 的非恒等记录，160 项物理性和共同共轭检查零失败。`

Fact: 六阶自伴 Hadamard 矩阵的 BN 分类中，恒等置换是唯一的一般 orientation；两个特殊纤维仅产生 20 个带 sheet 的非恒等记录，且精确物理性与共同共轭检查全部通过。因此，存在遗漏 BN orientation 的路线前提已被否定，但这不构成四个互 unbiased bases 全局不存在性的结论。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `独立重算 A1、B1 共轭 resultant 及四个单位圆分支，全部精确匹配，均强迫 p+p^-1=±4。`
- `因子审计得到 compatibility 的 p^2·X·G 与 ramification 的 p^2·X·A^4·S；p 非零、A 属于声明排除图表，X=0 时 F0=-D^2(p^2-4p+1)/4 且物理 D 非零，因此没有遗漏物理分支。`
- `RESULT.md 与 verification.json 明确记录无候选、无代数 witness、精确恒等式计数 0/0/0，并保留 fixed-odd、nonfixed、A=0、L=0、v=±1 分支。`

Fact: 在 fixed-even、C2=0 且 v≠±1 的内部区域，独立符号重算与因子审计排除了所有物理分支：两个共轭 resultant 和四个单位圆分支均强迫 p+p^-1=±4，约化因子未遗漏物理分支。该结论仅是局部排除；fixed-odd、nonfixed、A=0、L=0、v=±1 等分支仍未解决，也尚无四-MUB 代数 witness。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `独立重建得到85个规范固定变量以及90个基内方程和108个交叉方程；在物理单位环面上它们忠实对应原始Gram与互无偏条件。`
- `独立模消元确认三套星相容随机化的行秩均为85。`

Fact: 独立重建确认该多项式模型含85个规范固定变量、90个基内方程和108个交叉方程，并在物理单位环面上忠实表示原始Gram与互无偏条件；三套星相容随机化的模消元行秩均为85。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `Fresh symbolic reconstruction verified both division-free degeneracy charts, their A/B monomial equivalence, and all 16 square-root sheets.`
- `Independent K2-K5 recomputations verified eight phase determinants with no roots on the closed source arc and four identical nonzero biquadratic obstruction norms; the degree-64 Sturm calculation found no roots on the covering interval.`
- `Karlsson Section 5 and Appendix 1 directly support the singly-degenerate free-phase equivalence. The Reviewer refutation of C168 was recorded, while the proof-gap check still reports C1 open.`

Fact: On the singly-degenerate surface, both division-free degeneracy charts are monomially equivalent across all 16 square-root sheets, and the K2–K5 branches are excluded on the tested arcs by root-free phase determinants and identical nonzero biquadratic obstruction norms. This rules out only continuations meeting those four branches; the broader existence question remains open.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `隔离复跑匹配全部六个 C152 行列式零射线族并重建 36 个完整锚无偏方程及其精确因子乘积。`
- `精确检查通过 180 个入模恒等式、180 个 Gram 恒等式、48 个端点恒等式、8 个方向重叠公式和 180 个 Fourier 映射恒等式。`
- `JMMSW Theorem 1.4 对所有 Fourier 参数排除包含标准基与 Fourier 基的 MUB 四元组。`
- `proof-graph gap 检查仍报告 C1 为唯一未证明目标，且见证验收计数为 0/0/0。`

Fact: 六个 C152 行列式零射线族均可精确归约为 Fourier 基或其转置；已有定理排除了包含标准基与任意 Fourier 参数基的 MUB 四元组，因此这六族不能产生 C1 见证。该排除不覆盖行列式非零的 C152 图或其他 C25/C1 路线，C1 仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `A fresh no-write replay recomputed six strict local Krawczyk inclusions, determinant separation, and omitted-equation exclusions.`
- `The replay checked 1,544 node roots, 1,440 subsystem-(2,3,4) center roots, 1,590 subsystem-(0,1,2) center roots, and 23 deeper roots, finding no complete eight-equation candidate.`
- `The math-state remains consistent and the proof-graph gap check reports C1 open with one unproved goal.`

Fact: A finite atlas search found no complete eight-equation candidate among 1,544 node roots, 1,440 subsystem-(2,3,4) center roots, 1,590 subsystem-(0,1,2) center roots, and 23 deeper roots. Six local solution pipelines were rigorously excluded, but root completeness, branch collisions, and rank-drop cases remain unresolved, so this is a finite-search null result rather than a nonexistence proof.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `C172 的迹与重数论证给出 (3,3) 平方谱和两个 1+2 四次单位根分裂；投影公式的 432 个精确结构恒等式零失败。`
- `C174 独立完整复跑 240 个规范化非平衡 H_x monomial 扇区，得到 240 个单位理想、零非单位理想、零超时和零失败。`
- `C175 独立完整复跑两个 BN theta=2/5 radical sheets 上的 240 个扇区，得到 240 个单位理想、零非单位理想、零超时和零失败；Hermitian/Hadamard 模型约化零残差失败。`
- `当前证明图仍有 C1 一个未证目标；C171 验证明确记录完整射影覆盖和完整物理 BN 覆盖均未完成。`

Fact: C172 获得精确支持：其平方谱为 (3,3)，存在两个 1+2 四次单位根分裂，且 432 个投影结构恒等式全部成立。对 C174 的 240 个规范化非平衡扇区及 C175 在两个固定 BN radical sheets 上的 240 个扇区，完整复跑均只得到单位理想，从而精确排除这两个固定锚点；该结论不能推广到完整 BN 家族。C171 仍未解决，因为完整射影覆盖和完整物理 BN 覆盖尚未完成。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `隔离复跑确认 81 个 rooted-phase Laurent 方程与全部 108 个原始切向模方程零差异对应。`
- `start17 和 start57 均精确满足 108 个切向恒等式；各自 Jacobian rank 为 25、nullity 为 2，二阶弧增广 rank 为 26，separator 对右端值为 12。`
- `两个完整固定切向计算均得到二阶 rank 84、nullity 24，并得到三阶兼容 ideal 〈1〉。`

Fact: In the two tested rooted-phase cyclotomic charts, the Laurent formulation was exactly equivalent to the original tangent-modulus system, while both additional tangent directions failed higher-order compatibility: their second-order arc systems were inconsistent and their third-order compatibility ideals were the unit ideal. This is a local obstruction result for those charts, not a global exclusion of the full Laurent incidence.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `完整 100 方程系统在所选点的基础覆盖与全系统秩均为 69，源切空间维数为 3，30 个正交 pullback 均为零。`
- `独立重放 C36 section 证书，并在 Q(√3) 中符号验证二次关系、配对范数、归一化及非单位模结论。`
- `目标缺口检查仍报告 C1 开放，四-MUB 精确恒等式计数为 0/0/0。`

Fact: 一个秩为 69 的 étale 覆盖将所选局部 germ 的 ray 0 唯一确定为已知的 C36 section；该 section 在 Q(√3) 的两个实嵌入下均不满足单位模条件，因此这个 residual germ 被精确排除。这表明非 row-scaled 基仍可能包含已知非物理 section ray，但该结论仅排除 12 个 residual germ 中的一个，四-MUB 目标仍开放且精确恒等式计数保持为 0/0/0。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `独立重算确认所选85行系统满秩且其模素数minor非零。`
- `两套日程报告96个起点、46个子系统根和0个完整候选；32个保留端点全部完成独立重放且指标无不一致。`
- `16个保留子系统根均数值奇异；最佳者完整残差为10.821129749950252，只满足96/108 Gram及35/108交叉无偏等式。`

Fact: 在该有限数值搜索中，满秩的85行子系统产生了46个子系统根，却没有产生完整候选；独立重放的16个保留子系统根均数值奇异，且最佳根仍有10.821129749950252的完整残差，仅满足96/108个Gram等式和35/108个交叉无偏等式。这表明子系统可解性与完整系统可解性在该参数化和搜索范围内明显分离，但不能排除其他子系统或其他射影根。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `target-5 与 target-7 排除程序各重放 40,320 个标号 ray-permutation 组合，最小正 Arb 裕量分别为 5.628626306395413 和 5.0913477919084755`
- `扇区 406、512、47 各有 44/44 个精确零残差、Jacobian 秩 9、零空间维数 2、二阶增广秩 12，因此不存在经过这些 germ 的非常值形式或解析分支`
- `C181、C182、C186 已记录独立 refutes 判断；证明图仍明确保留 C1 为开放命题`

Fact: 两个锚点分别精确排除了 40,320 个标号射线置换组合；在三个已检验扇区中，所有 44 个残差均精确为零，Jacobian 秩为 9、零空间维数为 2、二阶增广秩为 12，从而局部排除了经过这些 germ 的非常值形式或解析分支。该结论仅限于这些锚点和 germ，不能解决仍开放的全局命题。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `Freshly generated equations produced 100 exact midpoint representative ideals; Singular returned 100 unit ideals and no malformed or nonunit result.`
- `Direct exact checks covered the midpoint number field, BN anchor, nonzero chart pivots, complete partial-isometry and flatness equation inventory, and the free symmetry cover of all 800 sectors.`

Fact: Exact computation found that all 100 representative ideals for the physical BN midpoint fiber are unit ideals, with symmetry checks covering all 800 sectors; this excludes solutions on that specific midpoint fiber but does not exclude generic or nearby interior components.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `The inspected primary-source excerpt states that no pair {I,F(a,b)} extends to a MUB quartet; the C189 citation was independently attributed.`

Fact: A primary-source exclusion theorem states that no pair consisting of the identity basis and a Fourier-family basis F(a,b) can be extended to a quartet of mutually unbiased bases.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/8200002

Evidence refs:
- `512-bit Arb 重算得到 39/39 坐标严格包含、source 与 Fourier 根同盒且所有非零 2*pi 别名排除。`
- `精确 Laurent 约化确认全部 82 条原始方程、40 条相位公式、36 条 Fourier 映射、36 条单位模及 36 条 Gram 恒等式。`
- `Reviewer 已为 C190 记录 supports、为 C189 记录 refutes；campaign 与共享 math-state 检查以及目标 proof-gap 检查均成功。`

Fact: 固定 fiber_index=3 source 的认证邻域已获严格验证：39维 Arb Krawczyk 算子逐坐标严格包含，source 与 Fourier 根位于同一无相位绕回歧义的盒内，并满足全部82条原始方程及相应精确恒等式。这否定了 C189 的固定-source 表述并支持 C190，但不推广到全局 C160、C25 或 C1，且未产生四-MUB见证。
