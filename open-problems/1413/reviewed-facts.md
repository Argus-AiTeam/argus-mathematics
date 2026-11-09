# Cross-campaign reviewed facts

Facts, not instructions. Entries appear in Manager review order.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `The recorded full degree-57 run returned UNKNOWN because of timeout and supplied neither an assignment nor a refutation.`
- `The exact rank-three calculations satisfy the parameter, spectrum, multiplicity, absolute-bound, and Krein feasibility conditions.`

Fact: The degree-57 Moore graph case remains unresolved: the full quantified model timed out without a satisfying witness or refutation, while exact rank-three calculations satisfy the known parameter, spectral, multiplicity, absolute-bound, and Krein feasibility conditions. This is a computational-method boundary, not evidence of existence or nonexistence.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `重新生成并求解度 7 完整 CNF 后，模型经解码并由 certificate.py 验证为 50 顶点、175 条边且通过全部 1,225 对检查。`
- `重新生成无额外对称破缺的度 4 完整 CNF 后，CaDiCaL 返回 UNSAT，drat-trim 重放成功；保存的检查输出明确报告 VERIFIED。`
- `度 57 两个 CNF 的头部分别声明 56,314,775 和 119,571,815 个子句，而实现给出的完整直接展开规模为 10,841,260,497,815 个子句。`
- `两个度 57 CaDiCaL 输出均为 UNKNOWN；目录中没有候选或见证文件，也没有度 57 证明检查成功记录。`

Fact: 度 57 的现有 CNF 仅是完整约束的部分展开，求解结果均为 UNKNOWN，既无候选模型也无经独立验证的 UNSAT 证明；完整直接展开规模超过十万亿子句，表明该路线在当前资源下不可物化，但不能据此改变对 Moore 图存在性的科学判断。度 7 的模型验证与度 4 的可重放 UNSAT 结果仅确认了编码及验证流程在较小实例上的有效性。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `The direct image and all two-hop images collide exactly on triangles or four-cycles; conversely every such cycle creates one of these collisions, so 56 distinct target labels give the stated global equivalence.`
- `Two fresh degree-57 generations were byte-identical to each other and to the reviewed instance; structural audit found exactly 178,752 ordered endpoint-label constraints, each of arity 56.`
- `The degree-4 DRAT certificate independently replayed as verified, and the degree-7 solver model decoded through both the two-hop checker and the public 50-vertex graph checker over all 1,225 vertex pairs.`
- `The proof-enabled degree-57 run ended out of memory without a solver status; the model-only run returned UNKNOWN due to timeout and exposed no candidate values.`
- `The pinned math-state check passed, and the proof-graph gap check confirmed that the degree-57 unsatisfiability obligation remains open.`

Fact: The 56-label encoding is globally equivalent to excluding triangles and four-cycles: direct and two-hop image collisions occur exactly for those cycles. The deterministic degree-57 instance contains all 178,752 ordered endpoint-label constraints of arity 56. Independent controls verified degree-4 unsatisfiability and a degree-7 satisfying graph, but degree-57 remains unresolved because the proof run exhausted memory and the model-only run timed out with UNKNOWN, producing neither a model nor a complete unsatisfiability certificate.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `degree-4 独立枚举全部 216 个归一化赋值，其中 24 个满足规范基约束，累计 16 个切后零个赋值存活。`
- `degree-7 的三个求解器后继均完整解码，最终候选通过公开检查器对 50 个顶点和 1,225 个无序顶点对的检查。`
- `degree-57 重算全部 178,752 个键并确认 172,480 个违规；首批 64 个切的 SMT 内容逐行重生成一致，但求解输出为 UNKNOWN(timeout)，没有模型值或 UNSAT 证明。`

Fact: 在该规范下，degree-4 的全部 216 个归一化赋值中仅 24 个满足基约束，加入累计 16 个切后无赋值存活；degree-7 的三个求解器后继均产生了通过公开检查器完整检查的合法 50 顶点图。degree-57 的受限求解仅返回超时 UNKNOWN，不能据此判定可满足性或不可满足性。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `Fresh isolated regeneration reproduced the degree-4, degree-7, and degree-57 CNF byte content.`
- `The freshly generated degree-4 instance replayed to VERIFIED with drat-trim.`
- `A fresh degree-7 CryptoMiniSat solve decoded with zero separator violations and passed the public 50-vertex checker over all 1,225 unordered pairs.`
- `The degree-57 instance contains 64 cuts, 2,079,648 variables, and 14,975,831 clauses; the recorded CryptoMiniSat run returned INDETERMINATE after 600.09 solver seconds and emitted neither a model nor a proof.`

Fact: Isolated regeneration deterministically reproduced the degree-4, degree-7, and degree-57 CNFs. The degree-4 proof replayed successfully, and the degree-7 solution satisfied both separator constraints and the public checker. The degree-57 instance remains unresolved: CryptoMiniSat returned INDETERMINATE after 600.09 solver seconds without a model or proof, so this run has no mathematical consequence for the open claims.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `固定 64-cut CNF 与重新生成内容逐字节一致，包含 2,079,648 个变量和 14,975,831 个子句。`
- `CaDiCaL 3.0.1 在配置的 600 秒限制内于 223.64 秒返回 SATISFIABLE。`
- `独立 DIMACS 检查确认全部变量均有赋值且所有 CNF 子句满足。`
- `独立语义解码核对 701,568 个主变量、162 个触及的置换、1,378 个投影补全和 3,456 个组合行；64 个固定 cut 全部满足。`
- `独立枚举全部 178,752 个 canonical 约束，确认 178,631 个违规，并与保存的分离内容一致。`

Fact: 固定 64-cut 松弛是可满足的：完整赋值满足全部 14,975,831 个 CNF 子句及 64 个固定 cut；但语义解码后仍违反 178,752 个 canonical 约束中的 178,631 个，因此这是 lazy 分离链中的可达松弛端点，而非完整约束系统的见证。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `从累计 128 个 cut 独立导出全部 C(56,2)=1,540 个非平凡匹配；实际 CNF 扫描确认 1,540 个矩阵块，头部、变量数和子句行数与重新推导的计数一致。`
- `从 cuts 内容重新生成完整 CNF，并通过直接逐字节内容比较确认相等。`
- `CaDiCaL 输出仅为 UNKNOWN，既无模型也无 UNSAT 状态；部分证明流不能构成终端证书。`
- `固定版本 math-state 检查无问题，proof graph 结构有效，当前缺口仍包含 C7 与 C8。`

Fact: 累计 128 个 cut 可独立导出全部 1,540 个非平凡匹配并逐字节再生对应 CNF，但 CaDiCaL 端点仅返回 UNKNOWN，既无完整模型也无可重放的 UNSAT 证明，因此该有限松弛尚未决定相关猜想，C7 与 C8 仍存在证据缺口。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `冻结输入包含128个互异 cuts、全部1,540个非平凡匹配矩阵、15,463,232个变量和52,423,287个子句；文件时间与命令表明预处理读取了该既有冻结输入。`
- `主简化式有51,585,374个子句；独立扫描复现13,308个主变量和4,062,236个辅助变量被消除。主求解结果为 UNKNOWN，无模型，部分 DRAT 不含空子句。`

Fact: 在主实例中，预处理消除了4,062,236个辅助变量，但子句数仅从52,423,287降至51,585,374，约减少1.6%；简化后的求解仍为UNKNOWN，表明大规模辅助变量消除并未显著缩小该实例或解决其可判定性。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `逐素数复核了约化谱消去多项式的单零根、模秩以及 Smith 指数饱和论证。`
- `用独立动态分类重放了全部 level-8 Brown 相位和奇素数行列式字符，得到恰好两个 Milgram 相容族。`
- `在分圆整数环中精确检查了 C8 Gauss 和、奇素数 Gauss 和的字符关系与平方恒等式，并验证显式形式的归一化积为 i。`

Fact: 对于假设存在的57度Moore图，邻接格判别群被确定为 (Z/8)^1520 ⊕ (Z/7)^1729 ⊕ Z/3 ⊕ Z/19；其有限二次型中恰有两个Milgram相容族，且存在归一化Gauss积为 i、与签名模8相容的显式非退化形式。因此，邻接格判别形式与Milgram公式所给的算术障碍无法排除该图的存在，但这既不构成图的构造，也不构成不存在性证明。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `从三族边缘方程和文献附加约束独立进行完整整数枚举，八个规范块分别产生 1,1,3,2,2,9,122,2 个解，总计 142 个，且逐向量吻合`
- `逐坐标核对 122 个非负整数赋值、752 条方程和 915 个标号展开项；31 个不可容许轨道均由零支撑根方程强制为零`
- `2026 年 Smith–Montemanni 的循环错排研究和 Ishida 的自同构研究仍明确把 57 度情形列为开放问题`

Fact: 针对57度 Moore 图的聚合四点距离计数约束存在非负整数可行解，因此该层级的四点聚合不一致路线不能证明其不存在；这一结果既不构造该图，也不解决其存在性问题，57度情形仍然开放。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1413

Evidence refs:
- `确定性轨迹重建得到 77 个匹配的前缀；全量扫描 3,192 个顶点、7,448 条边和 141,680 个邻居楔，未发现三环或四环。`
- `固定预算确为四次重启、每次 256 个节点，总计 1,024 个节点；未产生 degree-57 candidate.json。`

Fact: 独立复验表明，该搜索路线在固定的 1,024 节点预算内未产生 degree-57 候选；这只是有限采样分支的策略性失败，不构成 degree-57 不可满足证明，相关存在性问题仍然开放。与此同时，轨迹重建的 77 匹配前缀在 3,192 个顶点和 7,448 条边的全量扫描中未发现三环或四环。
