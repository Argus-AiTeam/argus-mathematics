# 固定源码与声明对应

本目录给两份导读提供作者源码、声明对应与重查记录；数学解释和验收结论以各自导读为准。
**本次完成的是完整本地源码闭包与声明核对，没有获得 Lean 内核编译或实测公理集。**

## 来源与边界

- 仓库：`https://github.com/openai/math`。
- 固定提交：`4eaee87548250b2682affda7d05d947c05554bae`；所有 `upstream/` 文件保持原字节。
- `upstream/lean/ComparatorChallenges/SKFullSupport.json` 指向
  `OAI.Probability.SKSupport.Main`，选择 `OAI.ZeroTemperatureSK.full_support`。
- `upstream/lean/ComparatorChallenges/SKValue.json` 指向
  `OAI.Probability.SKValue.Main`，选择 `OAI.SKValue.value_consequences`。
- 两个 Comparator 中的 `sorry` 是挑战占位。真实入口分别调用下述实质证明。
  `check_snapshot.py` 检查真实 `Model.lean` 的全部定义与 Comparator 前缀逐字一致、
  真实主定理与挑战定理的完整声明除空白外一致。
- 原版本要求 `leanprover/lean4:v4.34.1`，Mathlib 固定于
  `d13f23b723b8a846827a245b89c10fc7d3f11612`；该 Mathlib 的 `lean-toolchain`
  也写明 v4.34.1。配置与许可证都已保留。

入口及核心定义的 Git blob：

| 相对 `upstream/lean/` 路径 | Git blob SHA-1 |
|---|---|
| `OAI/Probability/SKSupport/Main.lean` | `754afb2758e552895c41a93c867007cf04a35cbd` |
| `OAI/Probability/SKSupport/Model.lean` | `4ad79e01ced7bd414ead755185c49a2ce22911ce` |
| `OAI/Probability/SKValue/Main.lean` | `0fcd7ca01b0f99b90f579f69a7bed99074bcdd99` |
| `OAI/Probability/SKValue/Model.lean` | `f0cc58f200a7e23fa7f43110dcd6e0794591dfce` |

`source-manifest.json` 给出全部模块的来源 URL、Git blob、导入边及依赖顺序。
源码闭包为 SKSupport 135 个模块与 SKValue 212 个模块，合计 347 个、2,477,974 字节；
各本地导入均已闭合，**未遍历的外部库边界只有 `Mathlib`**。
两个目录的递归子树均返回 `truncated: false`，没有使用仓库根的截断递归树。
`source-check.json` 是重新请求固定目录/子树后核对 355 个 Git blob 的结果
（347 个 OAI 源文件，另加四个 Comparator/JSON 与四个项目配置/许可证）。
它同时列出 20 个 `instance` 声明和一个实例属性，供人工查阅；
这些主要构造概率测度、有限类型及紧区间实例，不是在入口增加自洽假设。

全闭包排除注释和字符串后的关键字检查，没有命中 `axiom`、`opaque`、`sorry`、
`admit`、`unsafe`、`partial`、`native_decide`、`implemented_by`、`extern`、
`elab`、`macro`、`initialize`、`run_tac`、`run_elab` 或 `debug.skipKernelTC`。

## Full support：完整实际入口与定义

命名空间是 `OAI.ZeroTemperatureSK`；声明前唯一环境变量是
`{Ω : Type*} [MeasurableSpace Ω]`：

```lean
theorem full_support (W : BrownianSystem Ω) (γ : OrderParameter)
    (hmin : IsMinimizer W γ) : FullSupportConclusion W γ
```

完整原声明及证明见 `upstream/lean/OAI/Probability/SKSupport/Main.lean`。
下表行号均指该目录的 `Model.lean`：

| 定义 / 行号 | 实际数学含义及假设边界 |
|---|---|
| `Time` / 12，`extend` / 14 | `Time = Set.Ico (0 : ℝ) 1`；区间外零延拓。支撑是此半开区间的相对支撑。 |
| `OrderParameter` / 17 | `Time → ℝ` 非负、单调、右连续，零延拓在实线上 Lebesgue 可积。没有支撑、自洽、光滑或存在最小元的字段。 |
| `BrownianSystem` / 24 | 给定可测概率空间上的实 Brownian 过程；概率性、可测性及 `IsBrownianReal` 是环境输入，不是假定 Parisi 结论。 |
| `Control`, `controlPayoff`, `value` / 38–52 | 增量自然滤过下渐进可测、绝对值不超过 1 的控制；收益为终端绝对值减二次控制成本的期望，`value` 为其上确界。 |
| `gradient`, `curvature`, `parisi` / 53–61 | 分别是真实控制值的一、二阶空间导数与 `value 0 0 - (1/2)∫₀¹ tγ(t)dt`，不是任意给定满足目标恒等式的函数。 |
| `IsMinimizer` / 62 | `∀ η : OrderParameter, parisi W γ ≤ parisi W η`。这是条件最优性，不含 full support 或 moment identities。 |
| `IsStieltjesMeasure` / 65 | 对每个 `t : Time`，`μ (Iic t) = ENNReal.ofReal (γ.val t)`；包括可能的零点原子，不预先要求总质量为 1。 |
| `IsDiffusion` / 68 | 渐进可测、几乎处处连续、`X 0 = 0`，且在 `[0,1]` 上满足 `X_t = B_t + ∫₀ᵗ γ(s) gradient(s,X_s)ds`。 |
| `FullSupportConclusion` / 81 | 构造 Stieltjes 测度与扩散；每个这样测度均有全相对支撑；`γ(a)<γ(b)` 对所有 `a<b<1`；每个扩散解对所有 `t<1` 均满足 `E u(t,X_t)²=t`、`E a(t,X_t)²=1`。 |

没有把扩散存在性当作 `full_support` 的输入：
`Diffusion/CompactDrift.lean` 构造截断条带的 Picard 解、拼接并延拓到时刻一，
给出 `diffusion_isDiffusion W γ`；`Diffusion/Uniqueness.lean` 的唯一性将恒等式
从所构造解转移到任意满足 `IsDiffusion` 的解。

承重调用可按以下顺序读：

1. `Support/VariationIntegrals.lean`、`Support/ContactPotential.lean`：
   从真实最优不等式推出变分接触条件 `minimizer_contact`。
2. `Support/NoTerminalPlateau.lean`：由终端边界层排除终端常数区间，
   而非把该排除作为主定理前提。
3. `Support/GapCurvature.lean`：正平台上曲率二阶矩的二阶时间导数严格为正；
   零平台上一阶导数严格为正。它们调用 `Moments/Curvature.lean`
   的实际扩散矩及有理 coercivity，而非假定严格曲率。
4. `Support/Closure.lean` 中
   `SupportDeterministic.Variation.full_support_of_contact_and_gap_curvature`
   是确定性拼装引理，**其接触、曲率等前提由 Main 显式提供**；
   不应将此中间引理单独误读成入口仍待证明的假设。
5. `Main.lean` 的 `minimizer_full_support_actual` 与 `full_support`
   组装支撑、严格递增、自洽及任意解版本。

该选择声明覆盖论文 Theorem 1.1 的 full support 与两条 moment identities，
并给出所用扩散。它不单独证明存在最小元；也没有在该选择声明中断言
最小元唯一性、平滑密度、`γ'(t)>0`、算法复杂度或普遍的混合自旋/非零场推广。
`Support/NoTerminalPlateau.lean` 后部还定义了终端值和 Gaussian 结论，
**仅有这些定义不算所选 `full_support` 已证明这些结论**。

## SKValue：完整实际入口与定义

命名空间是 `OAI.SKValue`，无未列出的 section 参数：

```lean
theorem value_consequences :
    (∀ (W : BrownianSpace) (γ : OrderParameter) (X : ℝ → W.Ω → ℝ),
      IsMinimizer W γ → IsDiffusion W γ X → ScalarValueConclusion W γ X) ∧
    (∀ (W : BrownianSpace) (γ : OrderParameter) (X : ℝ → W.Ω → ℝ) (T : ℝ),
      0 < T → T < 1 → IsMinimizer W γ → IsDiffusion W γ X →
      FiniteGaussianConclusion W γ X T) ∧
    (∀ (W : BrownianSpace) (γ : OrderParameter),
      IsMinimizer W γ → groundStateValue = parisi W γ)
```

完整证明见 `upstream/lean/OAI/Probability/SKValue/Main.lean`。
下表行号均指该目录的 `Model.lean`：

| 定义 / 行号 | 实际数学含义及结论边界 |
|---|---|
| `OrderParameter`, `BrownianSpace` / 33–49 | 实轴系数在 `[0,1)` 非负、单调、右连续，在 `(0,1]` 可积；给定概率 Brownian 空间。端点取值不改变积分。 |
| `Admissible`, `controlPayoff`, `phi` / 59–70 | 同一控制定义的 Parisi 值，时间积分用平移区间 `0..(1-t)`。 |
| `gradient`, `curvature`, `parisi`, `IsMinimizer`, `IsDiffusion` / 71–88 | 导数、泛函、全局最优不等式和扩散积分方程；都没有 moment contact、finite-n limit 或 QAOA 能量字段。 |
| `hamiltonian`, `groundStateSequence` / 92–99 | `H_n = n^(-1/2) Σ_{i<j} J_ij σ_i σ_j`，`J_ij` 独立标准正态；序列为 `n^(-1) E max H_n`，非逐样本随机量。 |
| `groundStateValue` / 100 | `limUnder atTop groundStateSequence`。实数的总定义本身不蕴含收敛；收敛是下一项中的实质结论。 |
| `ScalarValueConclusion` / 106–118 | `Tendsto groundStateSequence ... groundStateValue`；存在终端 `U` 使停止梯度为鞅，几乎处处 `U²=1`、`abs U≤1` 且梯度收敛，平方差期望趋零；`P_*=E abs X₁-∫tγ`、`P_*=E[UB₁]`、`P_*=∫₀¹ E a`，最后被积函数区间可积。 |
| `euler`, `rawCoefficient`, `normalizer` / 27、124–131 | Euler 离散；曲率系数；曲率平方均值平方根的倒数。归一化因子的正性在有限 Gaussian 结论中最终得到。 |
| `roundedSign`, `coefficientA`, `coefficientB`, `shiftedCoefficientSum` / 136–154 | 均按论文的独立终端均匀扰动符号舍入及移位乘积和实际定义，并非抽象占位序列。 |
| `FiniteGaussianConclusion` / 155–164 | 固定 `0<T<1`，所有 `j<N` 的归一化因子最终同时为正，`N→∞` 时 `Σ_{j=0}^N A_j B_{j+1}→∫₀ᵀ E a`，随后 `S↑1` 的积分趋于 `P_*`。无网格速率或联合极限。 |

索引核对：Lean 的 `coordinate N 0` 是论文的 `Z₁`；
`euler ... N` 只用索引 `0,...,N-1`，舍入使用独立的索引 `N`；
`coefficientA 0=0`，`coefficientA j` 使用 `gaussianIncrement (j-1)`，
`coefficientB i` 使用 `coordinate (i-1)`。因此最终和确实为论文 §3
`Σ_{j=0}^N A_j B_{j+1}`，不是未移位的 `Σ A_j B_j`。
自然数减法、模坐标与 `N=0` 的总定义不影响 atTop 的正网格极限。

实质调用链：

1. `Control/Regularity.lean` 的 `sourceStripRegularity W γ`
   从控制值的平滑逼近证明条带正则性，不将 `SourceStripRegularity` 作为入口假设。
2. `Variation/MinimizerContact.lean` 的
   `IsMinimizer.gradient_moment_contact hmin hX` 从最优性、变分和间隙曲率得到
   `E u²=t`；中间需要该恒等式的定理由此被实例化，并无入口循环假设。
3. `GroundState/BlockCoeff.lean` 的 `SKValueG.groundStateSequence_tendsto`
   从 Gaussian 比较、期望最大值的超可加性及线性上界证明真实有限尺寸期望序列收敛。
4. `GroundState/WeakGuerra.lean` 证明 `groundStateValue_le_parisi`；
   `GroundState/LiteralLower.lean` 与 `Variation/ContactAssembly.lean`
   用实际 Gaussian 系数和给出反向界，得到等式与各值表示。
5. `Processes/FiniteGaussianFixedStrip.lean` 从条带正则性和已证明的二阶矩条件
   得到实际 Euler 系数极限；`GroundState/MainConclusions.lean`
   与 `Main.lean` 最后组装三项结论。
6. 第三项不再要求给定 `X`：`Processes/DiffusionExistence.lean`
   的 `diffusionProcess_isDiffusion W γ` 已在内部构造这样的解。

这对应 QAOA 论文 §3 的**标量输入**及 companion 的标量值/有限 Gaussian 后果。
不覆盖 rooted Fock 实现、光滑有界近似、量子门合成、helper contraction、
seed removal、固定 word 的热力学转移，故不等于 QAOA 主定理。
它也没有逐 disorder 的依概率/几乎处处极限、非 Gaussian universality、
数值 Parisi 常数、或算法资源上界的选择结论。

## 实际重放状态与独立重查

`environment.json` 记录 2026-11-10 的实测环境：声明的 pack 0.7.2 Mathlib、
elan 路径是失效符号链接，备用 `MATH_PACK_MATHLIB_FROM` 路径也不存在，
`lean`、`lake`、`elan` 均不在 PATH。因此不能报告“本地安装确认为 Lean 4.31”：
4.31 只是 pack 所说明的目标版本，没有得到本地可执行版本输出。

实际执行：

```sh
sh guide/evidence/lean-family-281/replay.sh
```

完整输出在 `original-entry-verifier.log`：
`math-lean-verify` 在检查 Mathlib workspace 时返回 **2**，未到 elaboration 或内核。
没有实测传递公理集；JSON 的 permitted axioms 是政策，不是 `#print axioms` 输出。
此环境失败不说明作者证明或 4.34.1→4.31 API 兼容性有问题。
没有制作兼容 port，没有添加根 lakefile，
没有下载或重建多 GB 的 Mathlib/OAI。所有保留源码的兼容变更清单为**空**。

独立来源/声明重查（不需 Lean）：

```sh
python3 guide/evidence/lean-family-281/check_snapshot.py --fresh
```

去掉 `--fresh` 可离线复核保留元数据、全部字节、导入闭包与定义/声明对应。
如需从头取新副本，使用已保留的通用工具：

```sh
python3 guide/evidence/lean-family-281/math-source-closure \
  --repo openai/math --commit 4eaee87548250b2682affda7d05d947c05554bae \
  --source-root lean \
  --entry OAI.Probability.SKSupport.Main --entry OAI.Probability.SKValue.Main \
  --index-dir OAI.Probability.SKSupport --index-dir OAI.Probability.SKValue \
  --output /tmp/lean-family-281-fresh
```

上面的 `math-source-closure` 是此次实际获取源码所用脚本的固定归档。
团队维护的同用途命令是 `math-lean-source-closure`，其用法见 `--help`。
该工具的 import-header 定向回归及全部 347 模块的导入列表对照见 `import-parser-tests.log`。

恢复可用环境后，`replay.sh` 仍只是原入口的最小尝试；
完整原栈检查还必须在**匹配上述 Lean/Mathlib pin**且这些 OAI 模块已依赖顺序编译的
独立目录运行两入口，并对上述全限定名执行 `#print axioms`。
