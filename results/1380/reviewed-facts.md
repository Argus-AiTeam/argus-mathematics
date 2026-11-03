# Cross-campaign reviewed facts

Facts, not instructions. Entries appear in Manager review order.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `六边聚合覆盖 2382266 个叶子，并重建行列式余循环、路径符号传播和凸性矛盾；这些步骤在全部 21 个有向 component 约束至少为 2/27 时成立。`
- `精确有理骨架的边界最小行列式为 17/180，而符号胞腔闭包内两点产生 edge-(4,6) 宽度 24157/146970>4/27，直接否定当前较强声明。`

Fact: 六边证书在全部21个有向component约束至少为2/27的内缩区域中成立，但不能推广到整个符号胞腔闭包；存在精确有理反例，其边界最小行列式为17/180，而闭包内指定符号的两点在edge-(4,6)上的宽度为24157/146970，大于4/27。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `For skeleton [(1/6,0),(3/4,0),(1,1/4),(1,5/6),(0,1),(17/30,1),(0,13/30)], exact arithmetic gives boundary minimum 17/180 at triples (0,4,6) and (3,4,5).`
- `For q=(281/426,35/71) and r=(17/46,35/69), all signed component determinants are nonnegative, each point has three values below 2/27, and the edge-(4,6) width is exactly 24157/146970=4/27+7151/440910.`
- `The pinned aggregate replay reports an exact complete threshold-inset exclusion over six path edges, 2,382,266 leaves, and zero frontier, with the determinant identities and convexity implication replayed.`
- `The corrected math-state and proof graph restrict q and r to all 21 signed inequalities at least 2/27; independent reviewer verdicts support the width and aggregate claims and refute the component-2 joint-pair existence claim.`

Fact: An exact rational witness shows that the stronger full-orientation-cell-closure claim is false: the stated skeleton has boundary minimum 17/180, while the specified points q and r satisfy all signed component inequalities nonnegatively but each has three values below 2/27; their edge-(4,6) width exceeds 4/27. This identifies a quantifier-domain error rather than a failure of the six-edge threshold-inset exclusion, and it does not contradict the corrected theorem requiring all 21 signed inequalities to be at least 2/27.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `独立复算两个 p8/p9 运输、全部165个原始行列式索引、192个闭 p3 符号胞腔、250个精确 stress 闭包和52个归一化正有理 stress；最小余量严格为正且 uncovered_frontier=0。`
- `固定解释器公开回放返回 complete=true、exact=true 和零前沿；证书绑定的 Reviewer refutation 已记录。`

Fact: 对两个 p8/p9 运输的独立精确有理复算表明，ordinal 19 的所有闭符号胞腔均被严格正余量的 stress 覆盖，因而该 ordinal 被有界精确排除；这一结论不构成全局 Heilbronn 目标的解答。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `从权威可读源树重建177个未决叶和175项排序manifest，确认唯一序号20的state、path、factor depths与精确面积乘积。`
- `独立复算两种p8/p9 transport、全部165个三元组、192个闭p3符号胞腔及244个有理stress闭合；48个归一化正权stress均有正裕量，uncovered_frontier为0。`
- `固定CLI复放通过；Jacobian精确区间包含0，正确地仅作为非结论交叉检查；math-state、proof-graph结构检查通过，gap仍仅为全局W1。`

Fact: 对冻结源树中唯一序号20的独立有限验证表明，两种p8/p9 transport均完整闭合：全部165个三元组约束、192个闭p3符号胞腔和244个有理stress终端通过，48个归一化正权stress均具有正裕量，未覆盖前沿为0。因此序号20被排除，剩余未决范围缩小为序号21至34，但全局C1仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `独立生成 canonical 与 p8/p9-swapped 两种运输，并确认每种运输保持全部 165 个三元组约束。`
- `独立重建 160 个闭 p3 符号胞腔，精确复算 150 个投影应力闭包、60 个 p7 扩展闭包和全部 210 个终端应力；47 个归一化正有理应力均被使用且余量严格为正。`

Fact: 独立精确重算验证了该有限证书分支：两种运输均保持全部165个约束，全部210个终端应力闭包成立，47个归一化正有理应力的余量均严格为正。因此该清单的ordinal 21可被排除，但这既不是十一点问题的反例或普遍证明，也不排除其余结构族。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `独立有理数实现重新生成 canonical 与 p8/p9-swapped transport、全部 165 个三元组、160 个闭 p3 符号胞和 210 个终端应力上界；48 个正归一化应力定义全部使用，最小精确余量为 11626000774519/46655999999953344。`
- `证书复放得到 uncovered_frontier=0；Reviewer 的证书绑定 refutes 判定已记录，数学状态及证明图结构检查无缺陷。`

Fact: 对 root118 source ordinal 22 的有限存在命题已被精确反驳：独立有理数复放在 canonical 与交换 p8/p9 的 transport 下重新枚举全部 165 个约束，均获得严格正余量并实现前沿完全覆盖。该结论仅排除此 ordinal；十一点反例及全局 C1/W1 命题仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `canonical transport 的独立精确收缩终端区间为 [1125871803521/74367395212032,2449675025/39208116096]，严格正负方向均不可能。`
- `p8,p9-swapped transport 的独立精确收缩终端区间为 [-55706035/809800416,-12111185243/260441116992]，严格正负方向均不可能。`
- `两种 transport 各自的 210 个固定误差界、记录的全部收缩和联合零前沿均被独立复放；ordinal 22 的 Reviewer 接受投影及任务前 23–34 残差也已核对。`

Fact: Source ordinal 23 is exactly excluded: both canonical and p8,p9-swapped transports make strict positive and negative signs impossible, yielding a jointly empty remaining frontier. This rules out that leaf but does not resolve the global eleven-point witness anomaly.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `Independent standard-library rational reconstruction recovered the 177 source-tree boundary leaves and the exact 175-entry ranked open manifest.`
- `Source ordinal 24 matches the required state, path, factor depths, partition depth, and exact area product.`
- `Both p8/p9 transports were independently replayed across all 165 determinant indices; 96 closed sign cells and all 104 terminal stress uses closed with positive exact slack and zero uncovered frontier.`

Fact: Independent exact-rational replay verifies the bounded exclusion of source ordinal 24: both transports close every resulting sign cell and terminal stress instance with positive slack, leaving no uncovered frontier. This finite result does not settle C1; source ordinals 25–34 remain unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `独立生成 C(11,3)=165 个原始约束，并确认 identity 与 p8/p9 swap 都是该完整约束集合上的双射。`
- `未导入 campaign 模块的精确有理数 contractor 重放得到 canonical 九次收缩后关闭 D(6,8,10)，swapped 十次收缩后关闭 D(6,9,10)；两者精确最大值均严格低于 2/27。`
- `两个完整 transport 均在 p3 分支前关闭，p3 sign-cell、stress definition 和 uncovered frontier 均为零；固定重放、math-state、proof-graph structural 与 proof-gap 检查一致。`

Fact: 对 root118 source ordinal 25 的独立精确有理数验证表明，canonical 与 p8/p9-swapped transport 的相关行列式最大值均严格小于 2/27，并且两者都在 p3 分支前关闭；因此该叶的存在性命题被排除，但 C1、W1 及 source ordinals 26–34 仍未决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `两个 p8/p9 transport 保持全部 165 个原始三角形约束。`
- `独立精确复算 64 个闭 p3 胞腔、完整 p7 分支和 14 个 p10 stress 叶，得到严格正的最小闭合余量与零前沿。`

Fact: 对 root118 source ordinal 26 的独立有限验证表明：两个 p8/p9 transport 均保持全部 165 个原始三角形约束；尽管 source contractor 对二者都不闭合，完整下游分支仍以严格正的最小闭合余量和零未覆盖前沿精确闭合，因此该 ordinal 不含严格 witness。该结论仅排除 ordinal 26；ordinals 27–34、全局 C1 与 exact-witness 命题 W1 仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `独立重建权威源树的 177 个未决叶和 175 项精确排序，ordinal 27 的状态、路径、因子深度、分割深度及面积积均与声明一致。`
- `两种 p8/p9 标签运输均保持全部 165 个原始三元约束；64 个闭 p3 单元由 80 个精确有理压力闭合，25 个正归一化定义全部使用，最小精确松弛为 129260473422456347/510230015999489769984，未覆盖前沿为 0。`

Fact: 独立精确重建与压力复算排除了源树 ordinal 27：两种标签运输保持全部 165 个三元约束，64 个闭单元由 80 个精确有理压力闭合，全部 25 个正归一化压力定义均被使用，最小松弛严格为正且未覆盖前沿为零。该结论不构成十一点反例，也不解决 C1；源 ordinals 28–34 与全局见证命题 W1 仍开放。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `独立dual重放覆盖两种transport和64个闭p3 cells；70个精确stress上界全部不超过2/27，最小slack严格为正且零前沿未覆盖数为0。`
- `公共ordinal-28 checker、固定math-state检查、86节点proof-graph结构检查及proof-gap检查均通过；Jacobian辅助支持值也由本机重放和直接有理点积一致确认。`

Fact: An independent exact-rational dual replay excludes ordinal 28 of the root-118 finite search: all 70 stress bounds close with strictly positive slack and no uncovered frontier. This is a local exclusion only; ordinals 29–34 and the eleven-point counterexample objective remain open.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `An independent standard-library Fraction implementation reconstructed the 177-leaf source tree and the 175-leaf ranking, recovering the exact ordinal-29 state, path, depths, and area product.`
- `Both p8/p9 transports preserve the complete inventory of 165 original determinant triples.`
- `All 64 closed p3 sign cells were covered by 60 projected and 8 complete-p7 exact stress evaluations using all 15 normalized positive rational definitions; every exact slack was positive and uncovered_frontier was zero.`

Fact: An independent exact-arithmetic implementation exhaustively excluded root118 source ordinal 29: all 64 closed p3 sign cells were covered, every exact stress slack was strictly positive, and no frontier remained uncovered. This narrows the unresolved source ordinals to 30–34 but does not resolve the global eleven-point counterexample claim.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `The accepted prior Reviewer judgements imply the exact pre-task residual 30 through 34.`
- `Both p8/p9 transports preserve all 165 original determinant constraints.`
- `Exact replay regenerated 64 closed p3 cells and verified 68 positive-slack stress maxima from 15 normalized positive rational definitions, with uncovered_frontier equal to zero.`

Fact: Exact rational verification excluded source ordinal 30: both transports preserved all 165 determinant constraints, and 68 positive-slack stress bounds from 15 normalized positive rational definitions covered all 64 regenerated closed cells with zero uncovered frontier. The unresolved residual consequently narrows from ordinals 30–34 to 31–34, while the global claim remains open.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `Independent standard-library rational replay regenerated the authoritative ordinal-31 source binding, both transports, all 165 constraints, 64 closed sign cells, and all 68 exact stress maxima.`
- `All 15 normalized positive stress definitions were used; the minimum exact slack was 608254027106953463/242359257600000000000 and the uncovered frontier was zero.`
- `The certificate-bound independent Reviewer refutation was recorded, reducing the accepted residual to ordinals 32 through 34.`

Fact: An independent exact rational replay excludes source ordinal 31: both transports satisfy all 165 constraints across 64 closed sign cells and 68 exact stress maxima with strictly positive minimum slack and zero uncovered frontier. The remaining accepted residual is ordinals 32 through 34; the global C1/W1 objective remains unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `独立重建权威 177 个未决源叶和 175 叶开放排序，确认任务前残余为序数 32–34，并匹配指定序数 32 源域。`
- `独立生成两种 p8/p9 运输、全部 165 个三元约束、64 个闭符号胞腔以及 68 个精确应力最大值；15 个正归一化应力全部被使用，最小余量严格为正，未覆盖前沿为 0。`

Fact: 独立精确重算确认源域序数 32 的两种运输保全全部 165 个三元约束；64 个闭符号胞腔及 68 个应力最大值均具有严格正余量且未覆盖前沿为 0，因此该有限源域被排除，未决残余由序数 32–34 缩至 33–34。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `Both p8/p9 transports, all 165 original determinant constraints, and the 56-constraint projected contractor domain were regenerated independently of Engineer modules.`
- `The canonical and swapped final exact determinant ranges both lie within [-2/27,2/27], closing both products before p3 branching with zero sign cells, zero stress maxima, and zero uncovered frontier.`

Fact: An independent exact rational replay refutes source ordinal 33: for both canonical and swapped transports, the final determinant ranges lie entirely within [-2/27,2/27], so the strict area condition is impossible before p3 branching. This leaves only ordinal 34 unresolved in the prior [33,34] residual; the global eleven-point configuration claim remains open.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1380

Evidence refs:
- `Reviewer-owned Fraction replay reconstructed the 177-leaf source tree and authoritative 175-leaf manifest without importing Engineer campaign modules.`
- `Both p8/p9 transports, all 165 original determinant indices, 64 closed sign cells, 64 exact stress maxima, 11 normalized positive rational stress definitions, and zero frontier were regenerated.`
- `All 175 manifest ordinals were covered exactly once by 174 previously accepted leaf reviews plus the independently replayed ordinal-34 certificate.`

Fact: An independent exact rational replay exhaustively excluded the finite root118 source frontier: all 175 manifest leaves were covered exactly once, with the sole residual leaf independently certified, all sign cells closed, and no uncovered frontier remaining. This does not resolve TCS8, C1, or the eleven-point witness W1.
