# Cross-campaign reviewed facts

Facts, not instructions. Entries appear in Manager review order.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2669

Evidence refs:
- `research/quantum_invariants/nongst_bp_rlink_construction/result.md 的欧拉次数论证和限定全字吸收恒等式，与 arXiv:2105.02789v2 的 BP 公理、Kirby 表示及求值算法相符。`
- `原始 copairing 图经两个积分帽闭合为零框架 Hopf 链；Jacobian matrix.rank.compute 对矩阵 [[0,1],[1,0]] 返回秩2，因此该手术 b1=0，而非目标的2。`
- `相较既有42维十算子证书，本轮新增的是同根跨支路扩展的拓扑排除，不是反例构造。`

Fact: 在所研究的 BP 构造中，旧根的欧拉特征 χ=1，而目标二组件 trace 的 χ=3；欧拉次数论证排除了当前同根跨支路扩展策略中的全字构造。限定算子族还满足两积分吸收恒等式，但该结论不覆盖内部 ribbon 插入、任意中间三腿操作或改变输入及闭合结构。原始 copairing 图经两个积分帽闭合得到零框架 Hopf 链，其链接矩阵秩为2，手术后的第一 Betti 数为0，而非目标的2。这些结果否定了当前旧根见证策略，但不证明整体路线不可能，也未构成反例。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2669

Evidence refs:
- `surgery_first/fixed_auxiliary_descent.md：填充子午盘与实际 framed band 给出任意有限固定辅助电影的普通滑移归约。`
- `surgery_first/signed_controls.json：正负辅助框架的实际 full twists 均消去平行线扭转，终端为零框架 unlink；其合法 BP 词满足 Nλ−NΛ=2。`
- `arXiv:2105.02789v2，Theorem 1.1、Sections 4.1–4.2、6.3、7.2：支持普通滑移不变性及 transmutation 合同，不支持将 Kirby-I 当作标量不变操作。`
- `arXiv:2503.19532v2，Section 4 semidirect-SF2 命题：积分支持与 ribbon 公式给出 λ(1)=λ(v)=λ(v^{-1})=0，故完整 unlink 标量为 λ(1)^2=0。`

Fact: 在所研究的 surgery-first 构造子类中，任意有限且固定辅助子链的电影可通过填充子午盘与实际 framed band 归约为普通滑移。正、负辅助框架的符号对照均终止于零框架 unlink；在 semidirect-SF2 情形，λ(1)=λ(v)=λ(v^{-1})=0，完整 unlink 标量为 λ(1)^2=0。因此，该固定辅助子链构造子类不能产生所需的同链非零反例。此排除不覆盖辅助组件滑过保留组件或改变辅助子链的一般构造，不能否定整个 surgery-first 方向。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2669

Evidence refs:
- `braided_fusion.md 指定的两个 Seifert-band 滑移确实改变辅助组件；所得手术图仍有三个组件，框架为(0,0,+1)。`
- `独立执行 prime_field.matrix.nullspace.compute，并逐项核对 braid 到完整33×33交叉及闭合方程的对应：F3上零空间维数为3，全部27个解中24个非恒定。闭包置换为三循环，排除了多组件独立着色的解释。`
- `Przytycki arXiv:math/0608172v1 第2—4页的 Theorem 0.2、Lemma 1.2及 unknot 染色数3支持该非平凡结论；独立来源归属与两个局部判词已记录，判词引用 active_auxiliary/braided_fusion.md。`

Fact: The auxiliary closure produced by the two Seifert-band slides specified in braided_fusion.md is a single nontrivial knot: its Fox three-coloring space over F3 has dimension 3, giving 27 colorings, of which 24 are nonconstant. Thus this auxiliary knot cannot immediately be blown down as an unknot. This is a local obstruction only; it does not exclude subsequent handle slides or other auxiliary constructions, establish a global handle-slide obstruction, or yield a generalized Property R counterexample.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2669

Evidence refs:
- `八个交叉关系与三个填充关系支持所述群化简；整数上三角表示给出无限阶中心元，排除结论不依赖有限枚举。`
- `disk_terminal_result.json 记录全部 6^8 个赋值的计算范围及两个符号下均为18的同态数；原生 Jacobian 对记录载荷返回 S₃ 的三个共轭类，与该计数论证一致。`
- `disk_first/disk_first.md 给出嵌入盘、两个异号穿点、实际负 full twist、零框架终端及完整外围群表示。`

Fact: The fixed zero-framed terminal obtained in the disk-first construction with two oppositely signed disk intersections and a negative full twist is locally excluded as a candidate for zero surgery yielding #²(S¹×S²). Its surgery group contains an infinite-order central element and has 18 homomorphisms to S₃ for either sign, whereas the required free group F₂ has 36. Thus this terminal cannot be connected to the prescribed starting point by boundary-preserving Kirby moves, even with legal intermediate auxiliary components. This exclusion does not extend to other disk constructions or general auxiliary-component routes.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2669

Evidence refs:
- `component_exchange/component_exchange.md：E=D_P∪B∪D_O 的唯一保留链穿盘点为 A 上的 (1,0,0)，符号为 +1；吹降删除原始 O，保留出生 A，其框架从 +1 变为 0，终端为两个分离的零框架平面圆。`
- `同文完整 BP 词为 (lambda⊗lambda)∘(eta⊗eta)，值为 lambda(1)^2=0；BDR arXiv:2105.02789v2 的范畴与 transmutation 定义，以及 Faes–Manko arXiv:2503.19532v2 的积分支撑公式支持该结论，未跨 Kirby-I 传递标量。`

Fact: The examined component-exchange construction genuinely deletes the original component O and retains the newly born component A, whose framing changes from +1 to 0, but ends at two separated zero-framed unknots. Its complete BP scalar is lambda(1)^2=0. Thus this construction realizes component exchange without providing a nonzero-scalar witness; it does not rule out component exchange in general.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2669

Evidence refs:
- `coupled_roots/coupled_roots.md 第1节：x²−y²=±1 的整系数论证排除规定出生条件下的异号单位组件单穿点耦合。`
- `同文第2节：指定 K1 有25个模5染色，K−1有9个模3染色，均含非恒定染色，故不能立即进行第二次 unknot 吹降。`

Fact: 在该研究规定的出生条件下，x²−y²=±1 的整数约束排除了异号单位组件的单穿点耦合。另一条指定构造中，K1 有25个模5染色，K−1有9个模3染色，均存在非恒定染色，因此这些结不是 unknot，不能立即进行所设想的第二次 unknot 吹降。这些结论仅排除上述限定子路线，不构成完整反例或全局 handle-slide 障碍，也不排除引入额外辅助、其他平衡穿盘模型或中间 slides 的构造。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/2669

Evidence refs:
- `staged_framing/staged_framing.md 第2至5节：实际 C 盘恰被 A、D 各正穿一次；填充经线帽构成首次吹降后的 D 盘，恰被 B 正穿一次；终端是明确编码的零框架 U2，完整标量为 lambda(1)^2=0。`
- `staged_framing/staged_framing.md 第6节：固定物理分区及规定三类 slide 下，部分填充输运把终端归入普通 handle-slide unlink 轨道。`

Fact: 在所验证的 staged-framing 局部构造中，终端是零框架二分量平凡链环 U2，完整标量为 lambda(1)^2=0；在固定物理分区及规定三类 slide 的限定条件下，部分填充输运使终端落入普通 handle-slide unlink 轨道。因此该构造未提供非零全局不变量的反例见证。这一结论仅适用于已验证的局部构造及输运限制，不排除一般同号耦合路线。
