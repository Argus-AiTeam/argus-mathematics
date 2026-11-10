# Lean 附属语句对照

固定来源为 `openai/math` 提交
`4eaee87548250b2682affda7d05d947c05554bae`。
`original/docs/058.md` 仅关联《Symmetry of semialgebraic bounded domains
with compact quotient》；没有在此 scope 内声称《Semialgebraic universal
covers of normal projective varieties》的直接形式化。

邻接 JSON 指向 `OAI.Analysis.SymmetricDomains.Main` 中的
`OAI.Release061.main`。实际定理签名与 Comparator 逐字一致；实际
`Basic.lean` 的下列定义与 Comparator 逐字一致。Comparator 的 `sorry`
是挑战占位，不能用于判断实际证明是否缺失。

## 正文主定理与形式语句

| 正文对象或条件 | 实际 Lean 定义、假设或结论 |
|---|---|
| 有限维复仿射空间 | `Affine n := Fin n → ℂ`，标准拓扑和范数结构；有限维范数选择不改变有界性 |
| 复仿射代数集，允许奇点及可约 | `IsAffineAlgebraic V` 是一族实际复系数多项式的共同零集；没有先验光滑或不可约条件 |
| 半代数子集 | `IsSemialgebraic` 由实部、虚部上的实多项式零集、严格正集、补、二元并归纳生成，即有限布尔组合；不是任意抽象谓词 |
| 相对开 | `U ⊆ V` 且 `IsOpen ((Subtype.val : V → Affine n) ⁻¹' U)`，不是要求 `U` 在整个仿射空间开 |
| 非空连通 | `IsConnected U`；固定 Mathlib 的定义是 `U.Nonempty ∧ IsPreconnected U`，不缺非空假设 |
| 有界 | `Bornology.IsBounded U`，使用标准有限维复向量空间结构 |
| 离散群、proper 作用 | `[Group Γ] [TopologicalSpace Γ] [DiscreteTopology Γ] [MulAction Γ U] [ProperSMul Γ U]`；固定 Mathlib 中最后一项是 `(γ,x) ↦ (γ • x,x)` 为 proper map，并导出连续作用 |
| 商紧 | `[CompactSpace (Quotient (MulAction.orbitRel Γ U))]`，实际轨道商的拓扑紧性，不是假定存在任意“商对象” |
| 全纯作用 | 每个群元素在子集上的映射局部来自 ambient 的复解析映射；逆元的同一假设给出全纯逆映射 |
| 双全纯 | `Biholomorph` 包含真正的同胚及正、逆映射的局部 ambient 解析延拓 |
| 光滑 | 每一点有相对开邻域，与某个 `ℂ^m` 中开集双全纯；没有把光滑性作为输入 |
| 有界对称域 | 真正开、连通、有界；每点有全纯自同构，其平方为恒等且该点为孤立不动点 |

没有作用自由、商光滑或商射影假设。零维域允许，和正文的点情形一致。
非空条件并不矛盾：`n = 0`、`U = V = univ`、平凡群的平凡作用
在数学上满足所有输入条件；`ContinuityPrinciple.lean:16–34` 还给出了点情形
的实际证明体。这里的输入实例是手工语义核对，未声称在本机编译。

## 关键接口是否只是额外假设

`Main.lean:68–87` 分点情形与非点情形。后者调用
`original_divisible_hermitian_model`，再调用
`hermitian_model_bounded_symmetric`，最后由实际双全纯映射给出光滑坐标。
`SupportedHermitianModel.lean:41–213` 从原主定理条件构造二次模型；
不是把“存在所需模型”添加为主定理的假设。

半代数有限 Nash 覆盖在 `SemialgebraicFiniteAnalyticNash.lean:36–108`
及 `SemialgebraicBoundaryFiniteNash.lean:152–174` 有证明体。
`NoncollapsedSupportedBoundary.lean:59–108` 的非坍缩边界也从原条件推出。
抽象 `WeightedLieModel` 有解析性、jet 单射、括号、幂零性等字段，
但 `Geometry3.lean:69–128` 从实际自同构的一参数群生成元构造这些字段；
`FiniteDimensionalCompleteGenerator.lean:69–71` 将完整生成元定义为
实际连续一参数双全纯自同构群的无穷小生成元。
对称性通过 `ModelAxisNegativeIsotropy.lean:116–178` 构造导数为 `-id`
的稳定子元素，再由 `PointSymmetryNegId.lean:61–114` 得到真正的
对合及孤立不动点。没有将 Vey 定理作为自定义公理导入。

`DiscRelationCompactLocal.lean:122–185` 的光滑性中间定理甚至不要求
半代数性、离散性或 properness，只要求这里列出的其余几何条件及紧轨道商。
这是原有证明的接口范围，不是本任务的新数学定理。

## 证据边界

保留了从入口闭合的 335 个 OAI 模块（2,114,940 字节），唯一外部
import 边界是 `Mathlib`。`source-closure.json` 逐文件记录依赖、
固定提交的 Git blob 和 SHA-256；`auxiliary-sources.json` 固定比较声明、
scope、版本文件及所读 Mathlib 接口。

独立复核重新取得固定提交的目录元数据，抽检 `Basic`、`Main`、
`GlobalTwoSided`、`SupportedHermitianModel`、`Geometry3`、
`ModelAxisNegativeIsotropy`、`PointSymmetryNegId` 七个模块及
Comparator JSON 的 Git blob，均与保留文件吻合，并直接阅读其定义和证明体。

上游 Lean 为 `4.34.1`，Mathlib 固定于
`d13f23b723b8a846827a245b89c10fc7d3f11612`。
JSON 的 `permitted_axioms` 仅列 `propext`、`Quot.sound`、
`Classical.choice`，不是实际传递公理集的测量。
`source-scan.log` 是 OAI 源码级扫描；并未编译闭包或测得入口的传递公理。
`verify-original.log` 记录实际执行 `math-lean-verify` 返回 2：
预配置的 Mathlib 工作区缺失。这既不是编译通过，也不是数学反例。
未进行兼容重放或修改任何原始 Lean 源码。
