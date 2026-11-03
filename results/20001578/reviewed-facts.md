# Cross-campaign reviewed facts

Facts, not instructions. Entries appear in Manager review order.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `规定的度 13 verify 入口精确重算全部 3,268,760 个源行和 68 个约化阶段，得到 42,446 块的停滞终端。`
- `独立精确矩阵计算得到偶支撑秩 41,161、核维数 1,285；M4RI 接口契约明确计算 A X = 0 的右核。`
- `原始纤维直接扫描确认块 31,533 对所有偶支撑列配对为零，其八个关联列均为奇支撑。`
- `2026 年 Amrutam–Dudko 一手论文引言明确说明 Thompson 群 F 的可均性仍是长期开放问题。`

Fact: 度 13 的精确计算表明，预注册的偶支撑机制在该度数失效：全部 3,268,760 个源行经 68 个约化阶段后停滞于 42,446 个块；偶支撑矩阵的秩为 41,161、核维数为 1,285，且存在一个块，其八个关联列均为奇支撑，从而给出单点对偶见证。该结论仅耗尽并反驳这条度 13 辅助路线，不构成 Thompson 群 F 非可均性的反例；截至 2026 年，其可均性仍是长期开放问题。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `独立重建得到 1,285 维规范对偶空间及秩 41,161 的偶支撑跨度。`
- `逐列检查确认该非零对偶向量湮灭全部 68,424 个偶支撑列。`
- `冻结探测列支撑为 {0,521,1478,1735,3668,4494,7453}，与对偶支撑交于 {0,1735}，故 GF(2) 配对为 0。`

Fact: 存在一个精确反例：规范对偶中的非零方向可湮灭全部偶支撑列，同时与冻结的最小奇支撑探测列配对为零，因而首块最小奇列探测规则不能保证奇偶分离；该反例仅否证这一局部探测策略，不排除一般的非局部混合分离。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `公共验证器从完整终端数据重算得到 79,485 个奇支撑坐标、6,746 个支撑对、28,970 个原坐标对、6,463 条边和 36,512 个分量。`
- `独立实现逐一检查两类穷尽候选对不跨存储分区，并从边集重建出相同分区、33,260 个孤立点和最大分量大小 36。`

Fact: 在已审查的可达 degree-13 终端上，冻结的距离二交换图并不连通：79,485 个奇支撑坐标仅形成 6,463 条边和 36,512 个分量，其中 33,260 个是孤立点，最大分量大小为 36；两类候选对的穷尽独立枚举重建了相同分区且未发现跨分量对。这是对该连通机制的精确反例，但不证明奇列秩亏或更强的群论结论。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `精确重放得到偶支撑秩 41161、商维数 1285、奇 syndrome 秩 1285，以及所选终端子式秩 42446、行列式 1。`
- `独立 GF(2) 消元确认存储的 79485×1285 syndrome 矩阵秩为 1285，且选出的 1285 个原坐标与证书列表一致。`
- `对 sigma=(0,0) 的 2 个行面和 120 个坐标面逐项复核得到左边界权重 0、右边界权重 22，精确否定位置删除自然性。`

Fact: 有限度数结果成立：79,485 个奇支撑列在 1,285 维商空间中满秩；与 41,161 个偶枢轴合并后得到秩 42,446、行列式为 1 的终端子式。然而，位置删除自然性在 σ=(0,0) 处失效：左边界权重为 0，完整 Schur 归一化后的右边界权重为 22，因此该自然性恒等式不能支撑任意次数正合性或行列式递推。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `独立从完整原始行支持重建 29×29 子式，双向验证逆矩阵，并重算得到 H_4D_4^rel=I_29。`
- `重新执行 m=4→5 公开重放入口，得到 29 个主元和零个零余项。`
- `使用已检查的 Jacobian 契约对精确 29×29 载荷重跑，返回 GF(2) 上秩 29，返回源矩阵与载荷完全一致。`
- `数学状态结构检查通过；有限左逆命题已获独立支持，而全度命题仍无支持并被记录为未决。`

Fact: 在 m=4→5 的有限情形中，从原始 986 列选出的 29 个主元构成可逆的 29×29 子式，显式左逆满足 H_4D_4^rel=I_29，且对应 Jacobian 在 GF(2) 上秩为 29；这一有限左逆结论已获独立支持，但任意次数的全度命题仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `Independent reconstruction from Schur formulas (3)-(9) produced the canonical degree-seven collisions and predecessors exactly.`
- `The predecessor overlaps are disjoint sets of sizes 4 and 7 whose union is the full 11-coordinate starting support; the final support has 17 coordinates and empty intersection with it.`
- `Both consecutive collisions have grade (0,1,0,1), and the exact 3-by-11 overlap matrix has rank 2 over GF(2).`

Fact: A canonical degree-seven counterexample has two consecutive same-grade collisions whose disjoint predecessor overlaps partition the entire 11-coordinate starting support into sets of sizes 4 and 7, eliminating all starting coordinates while leaving a nonzero 17-coordinate final support disjoint from the start. Thus, complete disappearance of the initial owner support does not imply a zero residual, refuting the frozen literal-owner strategy without resolving arbitrary-degree row rank.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `RESULT.md gives the parameterized Psi transport derivation through coefficient covariance, alpha and lambda recurrences, relative projection, complete critical fibers, canonical ownership, and both XOR steps.`
- `The exact certificate replays all 715 degree-seven E parameters and 495 B parameters and reports exactly two collisions with a 17-coordinate residual.`
- `Targeted exact reverse-fiber comparisons through degrees 7, 8, 9, 10, 12, 19, 30, and 50 retained the same branch topology; these checks corroborate, but do not replace, the affine-ramp proof.`

Fact: A parameterized affine-ramp proof establishes a single infinite-row theorem for every degree d>=7 within the reviewed Psi-equivariant relative-row stratum. Complete reverse-fiber analysis preserves the same branch topology, yields exactly two collisions whose canonical XOR leaves a 17-coordinate nonzero residual, and excludes additional rows, reachable B replacements, and third collisions. Complementary rows, full all-degree relative rank, and C_TARGET remain unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `从已审 equations (3)-(9) 独立重算得到 T_2(0)=(0,2)，但次数四与次数五的 raw-E 支持、relative 支持及规范主元均不协变，且两行均无 collision XOR。`
- `次数七至八的独立规范消元重放确认四个 collision 坐标运输，而索引 2、3 的 owner 分别被不同 primitive core 的行替换，最终余项支持随之改变。`
- `已确认的现状来源仍明确记载 Thompson 群 F 的可均性为开放问题。`

Fact: 冻结的两层 orbit-core 递推在最低次数跃迁 4→5 时已经失效：在任何 collision 投影或消元异或之前，raw-E 支持、relative 支持和规范主元均不协变。次数 7→8 的独立见证进一步表明，即使 collision 坐标能够运输，owner 仍可能被来自不同 primitive core 的行替换并改变最终余项支持；这仅否证该特定递推，不解决更强递推或 Thompson 群 F 的可均性。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `Independent GF(2) elimination over all 5,824 attachment-profile-compatible subsets finds exactly two rank-90 bases differing by one same-color coordinate exchange.`
- `Independent forced-span reconstruction contracts 102 independent columns to dimension 16; both division-free Berkowitz computation and a separate row/column subset determinant dynamic program return target coefficient zero.`
- `The determinant-one refined minor proves that the cancellation is not a matrix-rank defect.`

Fact: An exact 28-to-118 counterexample refutes the frozen distinguished marked-color coefficient recurrence: despite a determinant-one full-rank minor, exactly two compatible bases related by a same-color coordinate exchange cancel, yielding a zero target coefficient in the 16-dimensional quotient. Independent Berkowitz and determinant-subset dynamic-program computations confirm that the cancellation is genuine rather than a rank defect or implementation artifact.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `独立重构了 4,592 顶点的 degree-six DAG，并核对全部 473,430 个相对传递矩阵项。`
- `129 条冻结路径两两顶点不交，但对应子式秩为 128；前 38 阶满秩，39 阶秩为 38，三行 XOR 关系精确成立。`
- `完整相对矩阵独立重算秩为 129，证明该见证仅针对冻结选列策略。`

Fact: 在独立重构的 degree-six DAG 中，129 条冻结路径虽两两顶点不交，其对应子式却仅有秩 128，首个奇异前缀为 39 阶且秩为 38；但完整相对矩阵的秩仍为 129。因此反例否证的是冻结选列策略，而非相对矩阵本身的满行秩或其他 sink 集合上的奇 linkage。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `Independent exact rational elimination returned determinants 2 and -36 for the frozen 39-by-39 and 129-by-129 minors; the latter also certifies row rank 129 for the 129-by-3670 relative block.`
- `The frozen and alternate prefix-33 identity linkages share endpoints, are both vertex-disjoint, and have total terms +1 and -1.`

Fact: An exact counterexample rules out the universal sign-coherence strategy: finite minors have nonzero determinants 2 and -36, while two vertex-disjoint prefix-33 linkages with the same endpoints contribute opposite terms +1 and -1. This does not resolve amenability of Thompson group F or canonical Q[F] injectivity.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `A primitive 63-row integer relation has zero residual on all 550 selected columns; rank 549 over GF(101) proves the selected rational rank is exactly 549 and its determinant is zero.`
- `The complete 550-by-13782 relative matrix has rank 550 over GF(101), hence full row rank over Q; the witness is selector-specific rather than a complete-matrix rank defect.`
- `Weighted LGV and the sign-reversing matching identify the unmatched signed total with the zero selected determinant.`

Fact: The preregistered selected 550-column minor is singular: it has a primitive 63-row integer dependence and rational rank exactly 549, so its determinant and corresponding unmatched signed LGV total are zero. In contrast, the complete 550-by-13782 relative matrix has full row rank 550 over Q, showing that the cancellation witness is selector-specific rather than a defect of the complete matrix.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `精确验证器构造 550×550 所选整数矩阵，给出原始 63 行整数依赖并在全部所选列上得到零余量；模 101 秩 549 与该依赖共同证明有理秩恰为 549、行列式为零。`
- `完整 550×13782 相对矩阵模 101 的行秩为 550，因此在 Q 上满行秩；负证书只反驳预注册的所选子式非零-survivor 机制。`

Fact: 预注册选取的 550×550 整数子式在有理数域上的秩恰为 549、行列式为零，但完整的 550×13782 相对矩阵在模 101 上满行秩 550，因而在有理数域上也满行秩；该反例将失败定位于所选子式的非零-survivor 机制，而非完整相对矩阵本身。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `首个 inherited 分量具有精确 epsilon=1/2 分解，最小余项系数为 1/2，系数残差为零。`
- `首个 primitive 分量的张量矩阵秩为 31、单位增广矩阵秩为 32；三项泛函在全部 63 个列平方上为零而在单位阵上为 1。`

Fact: 首个 inherited 分量存在精确的 ε=1/2 分解，最小余项系数为 1/2 且系数残差为零。首个 primitive 分量的列平方张量不能张成单位阵：其张量矩阵秩为 31，加入单位阵后秩增至 32，并存在一个三项泛函湮灭全部 63 个列平方而在单位阵上取值 1。这否定了该分量上的同列平方能量机制，但不构成完整相对矩阵的秩缺陷，也不解决全次数单射性或反例问题。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `完整的 3,268,760 行度 13 pure-E Schur 轨迹到达 68 层，其中前 67 层严格下降`
- `终态含 42,446 个非零块、最小纤维 3，且无权一列、权二列或零支撑块`
- `63,056 个终态源原子及 1,057,455 个关联被精确重算，支撑差异为零`
- `终态算子精确返回原状态并产生零新增秩信用`
- `森林秩契约、目标测试、math-state 与 proof-graph 检查均通过`

Fact: 度 13 pure-E Schur 的完整轨迹构成一个精确反例：轨迹前 67 层严格下降，但在第 68 层停滞于 42,446 个非零块；终态最小纤维为 3，不含权一列、权二列或零支撑块，且算子精确返回原状态、无新增秩信用。这精确否证了冻结的 B-first 叶/权二森林递归策略，但不否证完整兼容矩阵满秩或其他原始列 minor 构造。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `All six degree-five theta suffix trials passed and all three theta overlap declarations reduced correctly.`
- `For the degree-six q-free circuit, HV remained covariant while VH produced three distinct residual circuits with zero total edge incidence; direct overlap reconstruction places the residual in the reviewed relation image.`
- `The inspected and rerun Jacobian homology contract returned degree-one cycle rank 1, boundary rank 1, and Betti number 0 over GF(2).`

Fact: An exact counterexample refutes the preregistered full-label Kruskal/RREF translation-stable contraction: although all degree-five theta suffix trials passed, a degree-six q-free circuit remained covariant under HV while VH produced three distinct residual circuits whose total edge incidence is zero and whose residual lies in the reviewed relation image. The residual is relation-valued rather than a nonzero homology class, consistent with independently computed cycle rank 1, boundary rank 1, and Betti number 0 over GF(2).

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `独立正词乘法重建确认五边集合增广边界为零，源切割为 4,3,4,5,6，且完整非零像的切割为 5,5,2,2,1。`
- `重新执行 Jacobian 的精确 GF(2) 零空间操作得到一维零空间及全一生成元，与五边回路一致。`
- `原始 Latin-tail 消去归约说明全部分次映射若单射则可推出 U_tilde、primitive blocks 及 Latin-tail 矩阵单射；当前反例只阻断此前件。`
- `已记录的主要来源核查确认 Thompson F 的可均性仍是开放问题。`

Fact: 五边回路 Y 的增广边界为零，源切割次数为 4,3,4,5,6，而其五个非零像的切割次数为 5,5,2,2,1；因此 Y 精确否证 gr_(6,6)(U_tilde) 的单射性。但 Y 不是 U_tilde_6 的原始核，该反例不决定 Latin-tail 单射性、C_TARGET 或 Thompson F 的非可均性。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `A separate standard-library-only reduced-tree-pair implementation reconstructed B_2, all 161 quotients, all quotient products, and the common counter vector (1,1,0,81).`
- `All 161 counter updates were exactly zero, all 36,015 guards were covered disjointly, and every one of the 289 ordered output pairs produced a replayed cross-copy collision.`
- `A fresh pinned Jacobian run returned UNSAT for the exact 34-variable, 563-clause bounded projection with no exhausted budget.`

Fact: The corrected P_0 cell plus four exterior-run counters and copy-dependent rule family is exhausted: all 161 quotient-induced counter updates vanish at the shared state, and every one of the 289 possible ordered outputs yields a replayed cross-copy collision. This rules out a global injection within that restricted state model, while richer interior-tail or tree-state rules and the broader target remain unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `RESULT_V2.md 给出深度二种子、共同右因子恒等式、树形归纳及完整碰撞论证`
- `公开 verifier 在深度 5 精确重建全部 161 个商像并确认状态相等及 289 个碰撞恒等式`

Fact: 对于固定的 canonical maximal-run V_d selector，共同右因子可在保持商恒等式的同时推进所有根视图，深度二的 161 个商元种子因此可归纳扩展到任意深度；深度五重放确认全部 161 个商像状态相等及 289 个碰撞恒等式。这排除了该固定 selector 策略，但未排除无界或非局部规则，C_TARGET 仍开放。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `The relevant source layers changed from [2,1] to [2,3] after common right multiplication by x_0, and each relevant output had exactly the stated two factorizations.`
- `The public verifier replayed the two-step contextual cycle, all four targeted tests passed, and the pinned math-state check reported no issues.`
- `The result and state records explicitly leave the zero-kernel claim, nonzero common-multiple branch, and campaign target open.`

Fact: For the frozen full-ambient synchronous peeling order, a common right multiplication reverses the relevant source-layer ordering from [2,1] to [2,3], producing a verified two-step contextual cycle. Thus this peeling strategy cannot terminate, while the broader zero-kernel and nonzero common-multiple questions remain unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `Exact reconstruction recovered a=x_0^2+x_1^2+x_2^2 and b=x_0x_1+x_1x_2+x_2x_3.`
- `The generator-insertion formula and four exhaustive first-difference cases prove preservation under arbitrary positive right contexts.`
- `Independent critical-pair replay for r=1 through 6 reduced the critical pair of a with Q_r exactly to Q_(r+1); the displayed all-r cancellation establishes the parameterized recurrence.`
- `The forest-leading-set and specialization arguments exclude reduction of the Q_r family by P_r or finitely many concrete exceptions.`

Fact: For a=x_0^2+x_1^2+x_2^2 and b=x_0x_1+x_1x_2+x_2x_3, the degree-lex-tag order is preserved under every positive common right context. Critical pairs generate a second infinite family Q_r via the recurrence Q_r→Q_(r+1), and forest-leading-set plus specialization arguments show that this family cannot be reduced by the P_r family together with finitely many exceptional relations.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `直接比较原始目标与任务结论，结果只否证冻结双族 grammar，并明确保留非可均性目标和 Ore 对为开放。`
- `检查了 a、b、A/B/C/E、P_r、Q_r 的定义、全部符号森林最小公右倍数分支、商和匹配临界对的精确祖先。`
- `符号递推中的锚点消去和四类互不相交支撑证明 T_r 对所有 r>=1 非零、支撑大小为 2r+12，并具有所声明首项。`

Fact: 冻结的双族完备化假设被否证：全部匹配临界对共享一个不可被既有 exceptional、P 或 Q 族覆盖的第三族递推。该第三族对所有 r>=1 非零，支撑大小为 2r+12，并具有所声明首项；这一结论仅排除该完备化策略，Thompson 群 F 的可均性及相关 Ore 对问题仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `Exact reconstruction of all six Thompson-monoid products and the complete factorization table of (1,1,3).`
- `Exact forest reconstruction shows depth zero for the selected output and no canonical residual output.`
- `Independent parity replay and the typed Jacobian operation both give four degree-one outputs and one degree-two output.`

Fact: An exact Thompson-monoid counterexample invalidates the proposed universal paired-propagation mechanism: the six products have the unique common output (1,1,3), whose complete factorization consists only of A₁:(3) and B₁:(1); its depth is zero, all residual outputs are noncanonical, and its odd residual incidence means it is not a kernel. This refutes only the local propagation claim and does not resolve the zero-kernel, common-right-multiple, or nonamenability questions.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `The four-source homogeneous chain satisfies every frozen full-ancestry hypothesis and has A:(4,4) as its unique locally even source.`
- `Exact parity and the pinned Jacobian operation both give six degree-one outputs and three degree-two outputs.`
- `Exact group-ring replay gives six odd boundary outputs, so both multipliers are nonzero but aU is not bV.`

Fact: A four-source homogeneous chain satisfying all frozen full-ancestry hypotheses has a unique locally even source at A:(4,4), yet exact parity and group-ring reconstruction produce six odd boundary outputs; consequently both multipliers are nonzero while aU differs from bV. This is a verified negative boundary result, not a kernel or common-right-multiple witness.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `独立重建度四的330个原始词、660个类型源、2055个柱面和2112540个允许原子；首个失败源索引为56，36684个原子含目标而可接受原子为0。`
- `诊断单柱面的拉回恰为A:(3,5,6,6)与较晚的B:(0,0,3,6)；对应两源链有四个奇输出，因此不满足aU=bV。`

Fact: 度四的穷举重建给出一个精确反例：在至多两个前缀柱面并采用固定四击时序的冻结递归中，首个失败源的36,684个含目标原子均不可接受；因此该递归策略被否证，但更多柱面、不同次序以及原始零核与Ore问题仍未决定。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `Y={1,x0} 的最小公共域树为 (.(..))，唯一判别地址为 1；恒等元在配对中序位置的值域 caret 暴露，而 x0 的对应值域根子树 ((..).) 不暴露。`
- `正规形与独立树对乘法在全部 34 个乘积上相符；两个 17 元邻域有 8 个交叠、26 个并集元素，每个交叠均满足 x0^-1=t_1*t_0^-1。`
- `Reviewer 已将 domain-only surgery claim 判为 refuted，并将普遍 Hall inequality 判为 inconclusive；项目的既有范围与引用状态无未决项。`

Fact: 在 Thompson 群 F 的有限构型 Y={1,x0} 中，两个 17 元邻域的 8 个交叠虽都产生同一正确商，但 x0 对应的值域子树并未暴露，因此仅凭公共域树信息无法定义所需的配对约去；这一反构型否定了 domain-only surgery 局部推论，但不解决普遍 Hall 不等式。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `最小性给出 p_y<=2-delta；双序最大乘积必为 private，从而 delta=1、|Y|>=18 且每个源至多一个 private B_2 邻点。`
- `首个冻结失败集合有 6 个源、82 个邻点，private 数为 1、9、12、12、16、16；q123 收缩为 x1 后新增 6 个邻点。`

Fact: 任意全源最小的 Hall 亏损集都必须满足亏损为 1、源集大小至少为 18，且每个源至多有一个 private 邻点。但冻结收缩策略并不普遍成立：一个六源非亏损实例在收缩后新增 6 个邻点，超过该策略所需的上限 1；该实例不满足全源最小性，因此否定的是证明策略，而非目标 Hall 不等式。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001578

Evidence refs:
- `The ordered-grid rank argument forces adjacent rows to share at least 15 products, while the complete exact quotient table has maximum negative-quotient multiplicity 8.`
- `An independent exact dyadic piecewise-linear reconstruction exhausted all 8,388,608 subsets of the 23 witness masks and reproduced 62 irredundant mask cores, 94,856 exact quotient cores, and minimum neighborhood 78.`

Fact: All 18-element equality candidates are excluded: the ordered-grid argument requires adjacent rows to share at least 15 products, but the complete exact quotient table has maximum negative-quotient multiplicity 8. An independent exhaustive reconstruction also found minimum neighborhood 78 across all witness-mask subsets. The universal radius-two Hall inequality and amenability classification remain unresolved.
