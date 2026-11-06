# OpenAI `openai/math` 全量 376 个问题家族（723 篇手稿）独立复核、局部形式化与改进候选报告

> **审计对象**：[`github.com/openai/math`](https://github.com/openai/math)（`main` 分支，涵盖全部 **376 个问题家族、723 篇 LaTeX 手稿** = OpenAI 官方于 2026-10-07 撤稿的 **3 个家族 / 3 篇手稿** + 现存活跃的 **373 个家族 / 720 篇手稿**）  
> **执行系统**：Argus 自主数学研究集群（24 路 `gpt-6.1-sol` 守护进程，累计 2,147 次模型调用，93.8% 提示词缓存命中率，总 API 账单成本 **$85.88**）  
> **独立范围与方法论声明（Scope & Epistemic Boundary）**：
> 1. **局部形式化与全文证明的严格区分**：本项目中 Argus 生成的 **384 份零 `sorry` Lean 4.31.0 证书（覆盖 317 个活跃家族）** 均严格附带 `statement_fidelity.md` 范围说明。这些 Lean 证书验证的是所选命题中**明确划定的代数、有限组合、矩阵或算子核心引理**，**不代表已将整篇连续统分析、微分拓扑、代数几何或计算复杂度主定理（如 `#378` 的 ETH 主定理或 `#156` 的连续统 Borsuk 映射定理）做端到端全链形式化闭合**。
> 2. **外部文献引用的正常性**：数学手稿引用外部已发表定理或预印本属于标准学术惯例。“某家族包含未在本次局部脚本中重证的外部文献假设或书面约化桥接”仅表示**本次自动化审计的覆盖边界**，**绝不等于原论文存在漏洞或错误**。
> 3. **账本中 `verdict = refutes` 的来源区分**：在 Argus 的内部研究账本（`MATH_STATE.json`）中，エンジニア与 Reviewer 会对“反证法所设的否定靶子”（如 `#318` 为证明映射非零而设立的零化假设 `C318TAUZERO`）、“自设的候选强化猜想”（如 `#318` 的 `C318LEVEL3`）以及“原文已指出的不可行简化路线”（如 `#376` 第 97–106 行已排除的速降标量时钟 `A_RAPID_ONTO_SLOWDOWN`）记录 `refutes`。本报告已将此类内部研究记录与**真正的原文引文/条件范围勘误（`#320`, `#247`）**及**对外部文献定理的反例（`#342`）**严格分离，并彻底清除了早期批处理脚本误标的 11 条合成标签。

---

## 一、 全集 376 个家族（723 篇手稿）审计覆盖与形式化范围总览

按本次审计实际完成的机器验证类型与范围边界（互斥分类，100% 与账本证书数一致），全集 376 个家族分布如下：

| 审计与验证范围分类（Audit & Formalization Scope） | 家族数 | 家族占比 | 手稿篇数 | 手稿占比 | 机器验证与范围边界说明 |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Category I：局部代数/组合核通过 Lean 4.31.0 检验（所选子问题图内无额外未决节点）** | **30** | `8.0%` | **59** | `8.2%` | `100%` 含至少 1 份零 `sorry` Lean 4.31.0 证书；所选局部子问题的有限/代数核心已闭合（具体形式化边界见各家族 `statement_fidelity.md`） |
| **Category II：局部代数/组合核通过 Lean 4.31.0 检验（顶层定理相对外部文献与书面约化成立）** | **287** | `76.3%` | **538** | `74.4%` | `100%` 含至少 1 份零 `sorry` Lean 4.31.0 证书 + `verify.py` 精确复算；连续统/几何/复杂度主定理依赖原文书面约化与所引外部文献 |
| **Category III：符号/数值复算脚本（`verify.py`）与证明依赖核查（无 Argus Lean 证书）** | **56** | `14.9%` | **123** | `17.0%` | Argus Lean 证书数为 `0`（含 `#028, #090, #095, #130, #152, #350` 等）；完成确定性 Python/SymPy/Jacobian 局部检验与证明图分解 |
| **Category IV：OpenAI 官方已撤稿（2026-10-07）** | **3** | `0.8%` | **3** | `0.4%` | `#045, #061, #070`：因 $I(f_1)-m=-2m\neq 0$ 符号错误在审计前已由官方撤下 |
| **总计** | **376** | **`100.0%`** | **723** | **`100.0%`** | **317 个活跃家族含 Lean 4.31.0 证书（共 384 份证书、520,223 行代码、41,764 条定理/引理；其中 `#156` 占 346,954 行 LRAT 展开，其余 316 族共 173,269 行）** |

---

## 二、 经原文核对的勘误、外部文献反例与内部排除路线说明

### 2.1 值得定向送审的外部文献反例候选：`#342`（基于 OpenAI 的 $T^4$ 构造检验 Li–Zhang *arXiv:0708.2520v4*）

在审计 **`#342`（Donaldson 驯服到相容辛形式猜想，[`results/openai-audit-theorems/9000342/`](../results/openai-audit-theorems/9000342/)）** 时，我们对 OpenAI 手稿中的四维平坦环面例子 `ex:strict-cones`（$T^4 = \mathbb{R}^4/\mathbb{Z}^4$ 上由 $f=\frac{1}{4}\sin(2\pi x_1), k=\frac{1}{4}\sin(2\pi x_2)$ 定义的近复结构 $J = K/\sqrt{1+f^2+k^2}$）做了独立符号微分、积分与 **Lean 4.31.0 代数核验（[`Main.lean`](../results/openai-audit-theorems/9000342/cone_conflict/Main.lean)）**：
* **对 OpenAI 手稿本身的结论**：`ex:strict-cones` 的关键矩阵、微分与正配对计算全部正确，**未发现 OpenAI 手稿存在错误**（该构造本身的贡献完全归属 OpenAI 原手稿）。
* **对外部预印本 Li–Zhang (*arXiv:0708.2520v4*) 的影响**：由于 $(T^4, J)$ 满足完备性（fullness）且具有显式相容辛形式，将该例子代入 Li–Zhang (*arXiv:0708.2520v4*) 可见其与该文印刷的 **定理 1.3、推论 1.4 第一断言、命题 3.9 第一断言**中的锥等式 $\mathcal{K}_J^t = \mathcal{K}_J^c + H_J^{(2,0),(0,2)}(M)_{\mathbb{R}}$ 产生冲突，并定位了该文定理 3.7 证明中闭流正投影不交性推断的缺口。该分析（见 [`cone_conflict/proof.md`](../results/openai-audit-theorems/9000342/cone_conflict/proof.md)）可作为针对外部文献锥等式条件范围的独立评议候选。

### 2.2 小而确定的原文勘误与条件范围说明（`#320`, `#247`）

1. **`#320`（非同胚闭非球面四维流形，[`results/openai-audit-theorems/9000320/`](../results/openai-audit-theorems/9000320/)）—— 引文编号勘误**：
   * **定位**：`formal.tex` 第 785 行写有 *"Apply the nilpotent correction of [MT, Lemma 3.9]"*。
   * **核对结果**：在所引用的 `[MT]` 原文中不存在 `Lemma 3.9`；对应幂零修正定理在 `[MT]` 中的实际编号为第 6 节的 **`Lemma 6.7`**（OpenAI 手稿随后展开的数学机制与 `Lemma 6.7` 一致，因此属于明确的引文编号笔误勘误，不影响手稿的数学有效性）。
2. **`#247`（无穷有限表现残余有限 2-群，[`results/openai-audit-theorems/9000247/`](../results/openai-audit-theorems/9000247/)）—— 局部引理字面条件范围说明**：
   * **定位**：9 月手稿 `build/sections/finite-rules.tex` 引理 `fr:rollback`（第 580–581 行）写有概括句：*"A boundary-cursor region can always be released inside its acquired interval."*
   * **核对结果**：若将该句字面应用于词尾语法所允许的“缺失左端点 `C(1)` 的单字母截断边界游标字 `[cursor p]`（位于 `C(2), B`）”，则在重写系统中没有任何合法重写步可用（已在 [`9000247/finite_rule_core/Main.lean`](../results/openai-audit-theorems/9000247/finite_rule_core/Main.lean) 中完成零 `sorry` 形式化证明 `no_step` / `trace_fixed`）。正如底稿 [`proof.md`](../results/openai-audit-theorems/9000247/finite_rule_core/proof.md) 所写，这仅是针对该概括句需要显式保留左端点前提（如同前文对完整区间的要求）的范围勘误，**不推翻 `fr:faithful` 或两项主群存在性定理**。

### 2.3 账本中其余 12 个家族的 `refutes` 记录说明（内部反证法靶子、自设强化猜想与原文已指出的障碍复核 —— 非原文错误）

为避免任何误读，下表逐一说明账本中其余 12 个带有 `verdict = refutes` 记录的家族——**这些记录全部是 Argus 在内部证明或探索扩展时排除的辅助假设，底稿均明确声明未发现 OpenAI 原文错误**：

| 家族 | 账本中的 `refutes` 节点 | 真实性质与原文对照说明 |
| :--- | :--- | :--- |
| **`#318` 色分裂猜想** | `C318TAUZERO`, `C318LEVEL3`, `C318LEVELGE3`, `C318GHOST2`, `C318QGHOST`, `C318EXTCD`, `C318FORGETACTION` | **反证法靶子 + 自设强化猜想排除（原文无误）**：OpenAI 原文摘要明确指出映射在 $\pi_{-3}$ 上 **nonzero**；Engineer 在账本中设立 `C318TAUZERO`（假设为零）并予以 `refutes`，正是为了用反证法复核原文的 **nonzero** 结论。同时，原文仅证 $2 \le \mathrm{level}_G(X) \le 3$；Engineer 先自设候选强化猜想 `C318LEVEL3`（水平恰为 3），随后在 [`degree-five/Main.lean`](../results/openai-audit-theorems/9000318/degree-five/Main.lean) 中算出度数 $-5$ 比较标量 $c=0$，推翻了自己的候选猜想从而证出 $\mathrm{level}_G(X)=2$。 |
| **`#376` 受迫 Navier–Stokes 普适计算** | `A_RAPID_ONTO_SLOWDOWN` | **复核原文已指出的障碍（原文无误）**：OpenAI 原文第 97–106 行已经明确解释了非负速降标量时钟无法产生无穷累积时间，并因此采用脉冲覆写晶格构造；`A_RAPID_ONTO_SLOWDOWN` 仅是对该初等障碍的账本复核。 |
| **`#274` $\mathrm{Parity} \notin \mathrm{QAC}^0$** | `C_SCALAR_INDEP` | **高秩扩展路线筛选（原文无误）**：OpenAI 原文针对秩 1 量子比特投影，其标量伯努利独立性完全正确；`C_SCALAR_INDEP` 仅说明在将定理推广到局部秩 $\ge 2$ 时不能沿用标量独立性，需改用非交换 Loewner 算子不等式。 |
| **`#180` Barnette 哈密顿圈猜想** | `C180_INTEGRAL` | **Engineer 初版自设强化草稿修正（原文无误）**：OpenAI 原文的森林状态提取命题正确；Reviewer 在四棱双锥 `bipyramid_4` 上排除了 Engineer 初版强化尝试 `C180_INTEGRAL`（漏计圈配对态），随后 Engineer 修复了整权多项式强化表述。 |
| **`#058, #125, #145, #206, #253, #282, #331, #351`** | `C_LOC_NECK_ADMISSIBLE`, `C_REUSE_SHORT`, `C_OP_SOFT_ADMISSIBLE`, `C_BC_IDENTICAL_DIGITS`, `C_RANK_SHORTCUT`, `C_PREMISE_OBSTRUCTION`, `C_BAD_SCALAR`, `C_HD_OMISSION` | **内部候选扩展或简化测试排除（原文无误）**：各节点在 `MATH_STATE.json` 的描述中均已写明 *"Candidate shortcut / attempted extension assertion, not an assertion of the staged manuscript"*。 |

---

## 三、 证明依赖展开、连接步骤补强与局部改进候选

在全量复核中，Argus 在 **279 个活跃家族**中产出了局部引理形式化、长证明依赖展开或局部界改进候选（其中 **166 个家族**整理了局部扩展/界收紧报告，**101 个家族**整理了连接步骤与文献条件核对报告）。代表性工作如下：

### 3.1 长证明关键连接步骤与文献条件的显式展开（代表性实例）

1. **`#001`（Milne 有理性猜想，[`results/openai-audit-theorems/9000001/`](../results/openai-audit-theorems/9000001/)）**：针对 `02_transport.tex` 中的 `lem:admissible-realization`，将 Kisin–Zhou (*arXiv:2505.02165v1*)、Pappas–Rapoport (*arXiv:2106.08270v6*) 与 Gleason–Lim–Xu (*arXiv:2208.07195v3*, Corollary 3.13 & 6.3) 的连接条件显式展开（包含特征 $p=2$ 情形），并在 [`Main.lean`](../results/openai-audit-theorems/9000001/Main.lean) 中形式化了固定标架拟同源在连通分支上的局部常值张量传播引理（`propagate_tensor_equalities`）。
2. **`#321`（Wall 有限 $D(2)$ 问题反例，[`results/openai-audit-theorems/9000321/`](../results/openai-audit-theorems/9000321/)）**：为原文的循环覆盖塔与挠消灭推论（`cor:torsion`）编写了 **2,029 行、109 条定理的零 `sorry` Lean 4.31.0 形式化证明（[`Main.lean`](../results/openai-audit-theorems/9000321/Main.lean)）**，在整群环上显式构造了字级 Fox 自由微分边界与有理电压提升（注：如 `statement_fidelity.md` 所列，Lean 证书覆盖离散代数与群环核，不覆盖连续统 CW 复形拓扑）。
3. **`#341`（Donaldson 超辛形变猜想，[`results/openai-audit-theorems/9000341/`](../results/openai-audit-theorems/9000341/)）**：针对 `07-pencil.tex` 中受限正合对变分的一阶射流横截性，显式给出了未增广导数零化子的二维积分拉回刻画与最高阶递降消去论证（代数核见 [`Main.lean`](../results/openai-audit-theorems/9000341/Main.lean)）。

### 3.2 代表性局部界改进与结构推广候选（归档包见 [`results/openai-audit-theorems/`](../results/openai-audit-theorems/)）

> **边界提示**：以下各项均为针对手稿中特定引理、子命题或代数模型的**局部改进或推广候选**，其形式化范围以各自目录下的 `statement_fidelity.md` 为准，不应直接等同于对整篇论文顶层主定理的无条件突破。

1. **`#318`（色分裂猜想——高度 3 重叠谱的生成水平收紧，[`results/openai-audit-theorems/9000318/`](../results/openai-audit-theorems/9000318/)）**：在原文 3 层滤过（$\mathrm{level}_G(X)\le 3$）与无 1 层收缩（$\mathrm{level}_G(X)\ge 2$）基础上，通过计算度数 $-5$ 处比较映射 $L_0 Y \to L_0 L_{K(1)}Y$ 为零（抛物交错形式消没核已在 [`degree-five/Main.lean`](../results/openai-audit-theorems/9000318/degree-five/Main.lean) 中形式化），给出余纤维分裂 $Y \simeq B_2 \vee V$，将相对于 $G = L_2 S \vee L_1 S \vee H\mathbb{Q}_5$ 的三角生成水平收紧至 **$\mathrm{level}_G(X) = 2$**；同时在 `prime-five-kernel` 中将 $\beta_1^m$ 的核指数验证范围扩展至 $13 \le m \le 16$。
2. **`#113`（完美匹配计数——局部编码原像与能量界改进，[`results/openai-audit-theorems/9000113/`](../results/openai-audit-theorems/9000113/)）**：针对 `lem:apex-encoding` 与 `lem:single-switch` 的局部组合核，通过直接记录差集 $(M\triangle M')\setminus C$ 将单顶编码映射的原像界从原文的 $(10N)^{30}$ 改进为 $2^{17}N^8$，并在 [`Main.lean`](../results/openai-audit-theorems/9000113/Main.lean) 中完成了有限组合核形式化。
3. **`#209`（整系数 Gersten 猜想——二进正则局部环模型 `D2_MAIN`，[`results/openai-audit-theorems/9000209/`](../results/openai-audit-theorems/9000209/)）**：在原文奇素数（$p=5$）构造基础上，在二进局部环 $B = (\mathbb{Z}_2[x,y]/(2-2x+x^2+xy-y^2))_{(2,x,y)}$（剩余域 $\mathbb{F}_2$）上构造了度 3 整 Gersten 核元素候选，并以 [`verify.py`](../results/openai-audit-theorems/9000209/dyadic_audit/verify.py) 与 [`Main.lean`](../results/openai-audit-theorems/9000209/dyadic_audit/Main.lean) 验证了其 2-Eisenstein 除子、伴随矩阵与 Sylvester 结式范数恒等式（外部 K-理论输入仍作为显式前提列出）。
4. **`#274`（$\mathrm{Parity} \notin \mathrm{QAC}^0$——任意局部维数与高秩投影局部化，[`9000274/research/dimension_uniform_localization.md`](#-五附录openai-math-全部-373-个活跃家族逐一审计总表)）**：用非交换 Loewner 算子不等式 $P - PQ(2I-P)QP = (P-PQP)^2 \ge 0$ 替代秩 1 标量伯努利论证，将局部化算子范数界推广至任意局部维数与任意秩正交投影（算子代数核已过 Lean 4.31.0）。
5. **`#125`（度量 $k$-中位数近似阈值——有限有向比较不等式系数收紧）**：在 `inequality.tex` 的 `thm:finite-inequality` 中，通过调整行惩罚参数将有限概率空间上的比较常数从 $2$ 小幅收紧至 $199/100$（见 `9000125/research/finite_comparison/report.md` 及 Lean 4 证书）。
6. **`#063`（广义 Mukai 与 Gromov–Witten 后代不变量，[`results/openai-audit-theorems/9000063/`](../results/openai-audit-theorems/9000063/)）、`#074`（Kakeya 纯类型导数匹配指数 $d \ge (m+1)/2$，[`results/openai-audit-theorems/9000074/`](../results/openai-audit-theorems/9000074/)）、`#164`（Hindman 有限和积猜想的多项式粗步尺度，[`results/openai-audit-theorems/9000164/`](../results/openai-audit-theorems/9000164/)）、`#378`（2-进 Hermite 赋值精确闭式公式，[`results/openai-audit-theorems/9000378/`](../results/openai-audit-theorems/9000378/)）**：各自对所选局部子命题给出了定量精细化或条件放宽，并附带 `Main.lean` 与 `statement_fidelity.md`。

<details>
<summary><b>📋 点击展开：全部 166 个含局部改进/扩展报告的家族索引表（均位于 279 个扩展家族集合内）</b></summary>

| 家族 | 论文标题 | 局部扩展报告路径 | 机器验证状态 | 局部改进 / 扩展摘要（详见各目录 `statement_fidelity.md`） |
| :--- | :--- | :--- | :--- | :--- |
| `#001` | Milne’s rationality conjecture and algebraic specialization. | `research/prescribed-filtration-audit/realization_proof.md` | ✅ (1份, 45行) | The improvement over that prior discussion is the explicit realization argument below, especially the fixed-marking argument in Step 4. It does not settle the balanced-Weil dichotomy identified by Milne as central. |
| `#002` | The full BSD formula from low Selmer corank. | `research/conjugate_bockstein/argument.md` | ✅ (1份, 197行) | No relevant prior BSD/Bockstein topic was located in the shared Wiki index. The stronger prior result relevant here is the manuscript's integral diagonal-vanishing claim, not the odd-primary matrix argument. The verification below independently reconstructs it |
| `#003` | The quasi-Riemann hypothesis. | `research/ls-uniform-determinant-core/proof.md` | ✅ (2份, 3041行) | * The nearest-point displacement in line 335 is `u-n`, not `n-u`. Its positive scalar product with the outward normal gives the stated strict decrease. * The rational hyperplane containing the face need not be the supporting hyperplane itself. Integer vertices |
| `#006` | Goldfeld’s conjecture: densities and mean analytic rank. | `research/trace-character/report.md` | ✅ (1份, 564行) | No finiteness assumption on `G` is needed. The image of `pi` is necessarily the rotation subgroup or all of `D_3`. This extends the finite-quotient form of the source assertion, without strengthening its ring hypotheses. It is a general proof, not an inference |
| `#009` | Function-field reconstruction from Milnor K-theory and Galois data. | `research/char-p-intersection/statement-fidelity.md` | ✅ (2份, 2314行) | `intersection_exponent` proves a slightly more general theorem: the coefficient field may be any embedded field containing every p-th power of the ambient field, and the ambient extension need not be finite. `prop_intersection` specializes it to the actual p-t |
| `#011` | Prime-factor statistics of $`p-1`$. | `research/memory_stability/restoration.md` | ✅ (2份, 362行) | The scoped baseline had no verified restoration result in this campaign. WDG already proves the elementary partition/cycle identity and already warns that a single collision estimate is insufficient. Neither is claimed as new. The improvement here is an explic |
| `#012` | Independent largest prime factors of consecutive integers. | `research/adaptive-cut-transfer/report.md` | ✅ (1份, 220行) | Here \(\rho_B\ge0\) majorizes the uniform remainder in (44). In particular (45) follows, even without its additional fixed \(\epsilon_2\). The power saving concerns the sampling error, not the unspecified arithmetic remainder \(\rho_B\). The improvement over t |
| `#014` | Restricted geometric Langlands, global Arthur enhancements, and generic Ramanujan. | `research/arithmetic_boundary_gluing/theorem.md` | 🐍 `verify.py` | The divisor need not be split over \(k_0\): Frobenius may permute its geometric points. For an empty divisor one can first mark any closed point at which \(\rho\) is unramified, with logarithm zero, and apply the statement. Forgetting this auxiliary marking re |
| `#015` | Torus-packet equidistribution in prime, quartic, and sextic degrees. | `research/quartic_shell/theorem.md` | 🐍 `verify.py` | In particular `0 <= c <= g`, and `c=0` if and only if `g=0`. The integer `c` is the exponent, not the logarithm of the cardinality, of the finite additive group `h/(h intersect C)`. Define |
| `#017` | The irrationality exponent of π is 2. | `research/interpolation-audit/REPORT.md` | ✅ (1份, 164行) | This is an independent written verification of the implication `geom:multiplicity -> geom:curve-inequality -> geom:interpolation` in `../openai_manuscript/The-irrationality-exponent-of-pi-is-2-September-24-2026/build/sections/interpolation.tex`. It also proves |
| `#018` | The Margulis–Platonov conjecture over global fields. | `research/exact_transitivity/report.md` | ✅ (1份, 305行) | The proof below supplies exact words and finite exceptional sets in place of the manuscript's algebraic-subgroup/density argument. Its congruence units are powers of a phase, not applications of the number-field unit theorem or the function-field divisor-class |
| `#019` | The local p-adic section conjecture and global consequences. | `research/collar_root_audit/report.md` | ✅ (1份, 61行) | The supplied ledger contained only the open campaign objective, with no proved collar claim or retired route. The inherited Wiki index had no matching collar or section-conjecture entry. The strongest relevant prior result is therefore the manuscript's own pro |
| `#022` | The weak inhomogeneous Duffin–Schaeffer conjecture. | `research/remaining-first-joins/report.md` | ✅ (1份, 475行) | Here the broad distance constant is fixed. The implicit constant is independent of the block, its position in the tail, the matching history, and \(N_0\). In particular, the stated broad \(O(1)\) and narrow \(O(W)+O_{k_0}(W^{1+c})\) bounds hold, with \(c=1/200 |
| `#025` | Short Egyptian fractions. | `research/growing_divisor_moments/proof.md` | ✅ (2份, 3265行) | Put \(d_X(n)=\#\{a\in\mathbb N:1\le a\le X,\ a\mid n\}\). All logarithms below are natural. The fixed-order manuscript lemma and its approved certificate are not new results. The following strengthens its quantifier order, not its range of shifts. |
| `#027` | Potential integral density on curve character varieties. | `research/diagram-reconstruction/report.md` | ✅ (1份, 112行) | Consider its fully refined first flag, with labeled free pieces `V_ij` in row-first order. Split that flag, respecting the specified graded identifications. During the sorting, an adjacent interchange of labels `a,b` replaces the lift of the `b` summand, in th |
| `#028` | Uniformly bounded components of Gaussian-prime graphs. | `research/signed_rectangle/STATEMENT_FIDELITY.md` | 🐍 `verify.py` | The original condition \(d^3r\geq C_0\) is not dropped from the manuscript by reinterpretation: the stronger theorem proves a bound for all \(r\), which implies the original with \((C,c,C_0)=(3,1/32,1)\). The substantive improvement over the staged source is a |
| `#031` | Uchida’s conjecture for open homomorphisms of Galois groups. | `research/uniform_kummer_bridge.md` | 🐍 `verify.py` | Under precisely the surjectivity and logarithmic-compatibility hypotheses of `thm:normalized-map`, Proposition `prop:uniform-missed-primes` is valid. In fact, its proof gives the more precise bound (1) below. This is a general proof, not an exhaustion of examp |
| `#033` | Iitaka subadditivity, variation, and logarithmic additivity. | `research/higgs-tail-audit/report.md` | 🐍 `verify.py` | This note gives a classical proof of a strengthening of Proposition `prop:tail-rank` in the staged reverse-logarithmic manuscript. The strengthening uses only the first two tails: they determine the common null distribution of every positively weighted full ta |
| `#034` | Log abundance for compact Kähler spaces under logarithmic Iitaka subadditivity. | `research/direct-image-volume/proof.md` | 🐍 `verify.py` | The important improvement over the initial, unsupported proof-graph state is a universal proof of the analytic bridge and a comparison of **currents**. There is no assumption that resolution preserves equidimensionality, that the base is projective, or that a  |
| `#038` | Fujita’s freeness conjecture. | `research/fujita_point_center/report.md` | ✅ (1份, 256行) | The earlier project ledger contained only the overall audit objective; it contained no proved point-center result. This work supplies a full derivation of the center mechanism, including uniform restriction images, weighted growth, first variation, and the pre |
| `#039` | Nagata’s conjecture and maximal Seshadri constants. | `research/reshaping_audit/report.md` | ✅ (1份, 125行) | The object audited is `prop:reshape` in `research/openai_manuscript/Maximal-multipoint-Seshadri-constants-in-positive-characteristic-October-5-2026/build/build/sections/04-reshape.tex`. Here a graded family means finite sets \(S_N\subset\mathbb Z^n\), \(N\geq1 |
| `#040` | Bloch’s conjecture for complex surfaces. | `research/marked-chow-audit/REPORT.md` | 🐍 `verify.py` | Let \(X\) be a smooth connected projective complex surface and let \(\chi(\mathcal O_X)=1\). Use precisely the notation, Euler convention, ordered weights \(w_1=1/2,w_2=-1/2\), and coefficient extraction of `relation.tex`. In particular, \(T,H,L_1,L_2\) are li |
| `#041` | Hyperkähler SYZ and projective-space bases. | `research/cartier-clearing/proof.md` | ✅ (1份, 214行) | This is a proof and structural strengthening of the specified implication, not a counterexample, a verification of the full ordinary-base-change proposition, or a proof of either manuscript's main theorem. Independent review and the novelty/significance determ |
| `#043` | P = W for fixed-determinant SLn moduli spaces. | `research/determinant_cover_transfer/report.md` | 🐍 `verify.py` | The strongest prior result used for comparison is arbitrary-rank GL_n P=W, together with the prime-rank SL_n reduction. Those results alone leave composite-rank variant cohomology untouched. The improvement here is a proof on the *cover itself*, before any inv |
| `#044` | The equivariant cohomological Hikita conjecture. | `research/cut_symbol/proof.md` | ✅ (1份, 81行) | The proof below also proves coefficient generation for this abstract algebra. Consequently it does not need a separate generation assumption once the Laurent identification is supplied. |
| `#047` | Zariski cancellation and affine fibrations over the complex numbers. | `research/rigidity/report.md` | ✅ (1份, 161行) | There is a useful structural strengthening. |
| `#048` | A characteristic-zero counterexample to Lipman–Zariski. | `research/jet_audit/report.md` | 🐍 `verify.py` | **Conditional theorem, with an exact identity certificate; independent review pending.** The curve and residue hypotheses stated in `prop:curve-data` and `prop:residue-data` suffice for `prop:jets`. More precisely, the coupled construction works through every  |
| `#050` | A counterexample to Griffiths’ positivity conjecture. | `research/limit_certificate/proof.md` | 🐍 `verify.py` | The local smoothing mechanism is already known: Raufi, `arxiv:1211.2948v3`, Definition 2 and Proposition 1.1(i), explicitly describe negative singular Hermitian metrics and decreasing local regularization. That is the **preprint's** numbering, not an allegatio |
| `#052` | Tangent splittings and product decompositions. | `research/tangent_box_certificate/argument.md` | ✅ (1份, 217行) | The ranks are unrestricted. Neither distribution is assumed integrable. The map g may be constant, ramified, or have vanishing derivative, and F need not be immersive. The exceptional-component argument below permits every positive pair of normal vanishing ord |
| `#053` | A counterexample to Pixton completeness in Chow. | `research/localization_audit/REPORT.md` | ✅ (2份, 272行) | Assume b >= 5 and dim(S) < chi-1. The Quot target is K + O, with torus weights 0 and 1. Its rank-zero quotient has determinant D in the relative Picard scheme and ch_2 integral nu + K.D - D^2/2. Embedded points and nonreduced divisor support are allowed. The s |
| `#055` | Gepner symmetry and large-volume stability on threefolds. | `research/gepner-aisle-audit/report.md` | ✅ (1份, 205行) | The following quantitative strengthening is also proved: |
| `#056` | Termination of projective and Kähler fourfold minimal model programs. | `research/curve_places/report.md` | 🐍 `verify.py` | There are two additional conclusions. Restriction to a loop-preserving curve core gives a **bijection of all discrepancy-two places**, not just an injection of the places constructed in the proof. Also, the curve estimate itself does not require the ambient co |
| `#057` | Fundamental groups of special complex varieties and root orbifolds. | `research/spectral_weighted_inverse/proof.md` | ✅ (1份, 76行) | For rigor on the diagonal quotient, choose a measurable fundamental region for the action on the `y` factor and integrate the invariant lift first over all `x` in `U`. Tonelli's theorem applies to these nonnegative energies. The bundle in the `y` variable is c |
| `#060` | The Global Spherical Shell conjecture. | `research/cylinder_compactness/report.md` | 🐍 `verify.py` | The earlier result available at scope was the manuscript's non-effective small-energy argument. The mathematical improvement here is an explicit graph-filling threshold and a complete proper-domain proof that does not rely on the inaccessible compactness citat |
| `#062` | Projective contact classification and the LeBrun–Salamon conjecture. | `research/contact_value_descent/report.md` | ✅ (1份, 41行) | \\| Source \\| Statement read and applicable hypotheses \\| Scope finding \\| \\|---\\|---\\|---\\| \\| [Stacks 035B](https://stacks.math.columbia.edu/tag/035B), Lemma 29.18.2(1) \\| Schemes locally of finite type over a field are Nagata. \\| Applies to the reduced finit |
| `#063` | The generalized Mukai conjecture. | `research/descendant_bound/proof.md` | 🐍 `verify.py` | More precisely, if the right side of (1) is an integer \(\delta\geq2\), a boundary stratum with \(u\) branches attached to the marked component has image dimension at most \[ h-(\delta-1)u . \tag{3} \] This strengthening is a consequence of the same proof, not |
| `#065` | Virasoro constraints for complete intersections and projective-bundle towers. | `research/family_orbit_localization/report.md` | ✅ (1份, 81行) | **Theorem.** With the manuscript's conventions, Proposition `loc:factorization` holds. Its \(u_B,u_X,R\) are unique among solutions with positive Novikov filtration. More generally, the same statement holds for an arbitrary algebraic \(E\), without first twist |
| `#066` | Bounded klt complements for Fano contractions. | `research/lc-slice-audit/reviewer_primary_excerpts.md` | ✅ (1份, 69行) | > For any log-smooth pair (Y,D) over X and any valuation v in Val_X > we have A(r_(Y,D)(v))<=A(v) with equality if and only if > v in QM(Y,D). |
| `#072` | Brennan's conjecture and the integral-means spectrum. | `research/affine_transport/report.md` | ✅ (1份, 121行) | **Strongest relevant prior result.** Binder, Ivrii, Prause, and Smirnov, *Brennan's Conjecture and the Universal Integral Means Spectrum*, [arXiv:2610.23853v1](https://arxiv.org/html/2610.23853v1), Section 1.4, already state the strict quadratic bound for the  |
| `#073` | The Falconer distance conjecture. | `research/AUDIT_REPORT.md` | ✅ (1份, 1136行) | The actual policy uses a fixed minimum in each block of `q = ceil(kappa*N)` indices. Each nonterminal interval chooses a minimum among representatives of whole blocks inside its inner interval. Its descriptor list is the union over all nonterminal subintervals |
| `#075` | The $`L\log L`$ Fourier-convergence conjecture. | `research/entropy_refinement/report.md` | ✅ (1份, 691行) | The predicate `good` need not be monotone. No hypothesis says that interval widths decrease, or that target decreases are attained exactly. |
| `#076` | Real ultraflat Littlewood polynomials and unbounded binary merit factors. | `research/packing-audit/report.md` | ✅ (1份, 120行) | The displayed target holds, in fact, for every positive integer `u`. The coefficients in its error term are explicit and depend only on `u,r,L,R,K,q`, not on the rank of the whole collection or on the chosen center. No claim of literature novelty is needed or  |
| `#078` | The three-dimensional Bochner–Riesz conjecture. | `research/directional_bootstrap/report.md` | ✅ (1份, 126行) | Here is a slightly more general statement. Give the `A` comparison population child rate `s_A` and the `B` comparison population child rate `s_B`, where `0<s_A,s_B<=1`. Keep all the other hypotheses of the proposition, including the same-law, simultaneous orig |
| `#081` | Riesz transforms and rectifiability in higher codimension. | `research/normalized_height_bridge/bridge.md` | ✅ (1份, 69行) | There is a strengthening: throughout the energy-to-equation argument, the cubic oscillation bound can be replaced by \[ \\|\mathcal R_{\mu_j}(\xi)\\| \le D\delta_j^2(\operatorname{Lip}\xi+1) \tag{Q} \] for a fixed finite \(D\), for the same compact, current-meas |
| `#082` | Annular variation and dyadic absolute bounds for the triangular Hilbert transform. | `research/certificates/shared_trace/proof.md` | ✅ (1份, 99行) | This implies \(\mathcal L_{\sqrt P}\le\mathcal L_{\sqrt Q}\) as quadratic forms. The variational identity proves \(b_P(K)\ge b_Q(K)\) for \(K\) supported on \(P\); support inclusion follows from \(\ker Q\subseteq\ker P\). The more general manuscript comparison |
| `#084` | The geometric case of the Erdős similarity conjecture. | `research/geometric-bridge/proof.md` | ✅ (1份, 819行) | This is a parameter-uniform mathematical statement, not an inference from the finite diagnostics in `exact_certificate.json`. The mathematical improvement over the manuscript is a representative count `1 + sum ceil(N_{b_i^*}*q^n)` in place of its boundary-plus |
| `#085` | Endpoint Sobolev regularity of centered disk averages. | `research/label_packing/REPORT.md` | ✅ (1份, 322行) | The result proved below is a universal verification, not a finite counterexample search and not a certification of the endpoint Sobolev theorem. The strengthening replaces `grad(g) dx` by any compactly supported finite real two-component vector measure. All sp |
| `#087` | The Mahler conjectures, functional inequalities and polar-product symplectic width. | `research/uniform_slice/REPORT.md` | ✅ (1份, 57行) | The improvement over the strongest staged result is the cutoff-independent bound `Re F' >= 2/pi`, giving `C_* <= pi^2/2`, and hence the explicit varying-cutoff majorant (1), the elementary rate (2), and the sharpness corollary. Repeating fixed-height convergen |
| `#088` | Sharp projection-body inequalities and a counterexample to simplex maximization. | `research/scalar_defect/report.md` | ✅ (1份, 548行) | Compared with the strongest result asserted at this location in the staged source, (1) and (2) replace qualitative strictness by an explicit defect. They are a mathematical strengthening relative to that version, not a claim of priority over all literature. In |
| `#089` | Bounded-distortion L1 embeddings of planar and bounded-treewidth graphs. | `research/packing_audit/localization.md` | ✅ (1份, 964行) | The proof route isolates the more general metric/combinatorial implication: a connected low column set, short center paths avoiding that set, descending witness paths ending in that set, and no sufficiently low separating switch force localization near two ext |
| `#090` | Triangular-lattice optimality, long-range Riesz and Coulomb energies, and spherical logarithmic energy. | `research/atomic-gaussian-audit/theorem.md` | 🐍 `verify.py` | The staged checker was first run without modification and passed. The new checker neither imports nor executes it. Its independent features include integer cyclotomic reconstruction of the columns, direct sine-product evaluation of local node data and midpoint |
| `#091` | Logarithmic and Lp Brunn–Minkowski inequalities and the B-conjecture. | `research/analytic_closure/report.md` | ✅ (1份, 215行) | This report proves `M_MOMENT`, `M_DENSITY`, and then `M_VARIANCE`, with the literal hypotheses of `moment.tex`, `density.tex`, and `reduction.tex`, Proposition `prop:variance`. It uses the already independently reviewed `C_TENSOR`; it neither rebuilds its cert |
| `#093` | Dimension-free logarithmic Sobolev inequality for subgaussian log-concave measures. | `research/entropy-loss-audit/report.md` | 🐍 `verify.py` | This is the anisotropic Bakry--Emery criterion, obtained from its isotropic form by a linear change of variables. The staged manuscript also proves it as `lem:curvature` in `02-calculus.tex`. Entropy chain rules, Gaussian square completion, conditional Jensen, |
| `#095` | Hyperbolicity cones without semidefinite lifts. | `research/hankel_seed/report.md` | 🐍 `verify.py` | Compared with the manuscript's displayed modular certificate, this deliverable makes the characteristic-zero tangent explicit and checks all ten weights at the same specialization, instead of relying on weight reversal to establish the other four nonempty rank |
| `#097` | The Euclidean Steinitz–Bergström bound. | `research/certificates/filter_increment/report.md` | ✅ (1份, 76行) | The main independent result below is a stronger, global relative-gain inequality. It allows arbitrary-rank positive semidefinite gains, singular contractions, and every exponent `1<a<=2`. At `a=3/2` it replaces the manuscript's small-energy bootstrap and halve |
| `#104` | Quasipolynomial algorithms for mean-payoff, stochastic and parity games. | `research/label_core/REPORT.md` | ✅ (1份, 1238行) | The deterministic main theorem additionally needs the wide-box game reduction and the bit-complexity analysis. The randomized theorem has its own randomized potential-recovery argument. The stochastic paper adapts simultaneous labeling to discounted operators  |
| `#105` | Perfect completeness for 2-to-1 games. | `research/upper-decoder-certification/theorem.md` | ✅ (1份, 134行) | No manuscript assertion is established false here. The result verifies and strengthens this *upper interface*, not the whole hardness theorem. Novelty beyond comparison with the staged manuscript, publishability, and independent acceptance remain questions for |
| `#107` | Matrix multiplication with exponent at most 9/4. | `research/all_fields_nine_fourths/spectral_excerpt.md` | ✅ (1份, 105行) | > For any semiring X contained in T there are a compact space Delta and > a homomorphism phi : X -> C+(Delta) of semirings ... such that > a is asymptotically restricted by b if and only if phi(a) <= phi(b) > pointwise on Delta. |
| `#108` | A cubic permanent–determinant lower bound. | `research/spectral_bridge/proof.md` | ✅ (1份, 211行) | In characteristic two, permanent and determinant coincide. Taking \(a=b=q=\lfloor(k-1)/3\rfloor\) proves the live manuscript proposition and strengthens its bound from \[ k^2+k-\binom{q+2}{2}\quad\hbox{to}\quad k^2+k-(q+1)^2. \tag{2} \] The improvement is \(q( |
| `#113` | Approximate counting and entropy of perfect matchings. | `research/pair_energy_audit/proof.md` | ✅ (1份, 140行) | The independent strengthening over the source proof is the compressed preimage bound in Section 3: T = 2^17 N^8 instead of (10N)^30. The proof also isolates precisely which graph properties suffice. This strengthens the pair comparison, not the entire FPRAS or |
| `#114` | Approximate counting of common integer polymatroid bases. | `research/balanced-summation/report.md` | ✅ (3份, 3292行) | The manuscript already states this general closure and supplies the cumulative-sum proof below. Its attribution to an earlier induction is not used as a premise or independently certified here: the closure is proved directly. No claim of a new mathematical clo |
| `#115` | Sampling and counting contingency tables with arbitrary margins. | `research/signature_core/report.md` | ✅ (1份, 1438行) | Paths in this list are relative to `research/openai_manuscript/`. No external Lorentzian closure theorem is used. Branden--Huh is background, not an unverified dependency of this proof. The mathematical assertion was already present in these sources; the impro |
| `#116` | Uniform black-box noncommutative identity testing across characteristics. | `research/word_independence/REPORT.md` | ✅ (2份, 1539行) | The coefficient construction is valid because t is transcendental: t^r-1 is nonzero for every positive integer r, including when the characteristic divides r. The kernel b_i has zero constant coefficient. Consequently the displayed coefficient formula construc |
| `#118` | Bin packing and unbounded configuration-LP gaps. | `research/structural_gap_certification/STATEMENT_FIDELITY.md` | ✅ (1份, 16195行) | The only input is an arbitrary natural number `c`, including zero. There are no hypotheses on this parameter and no finite-parameter testing restriction. Both existential witnesses depend on `c`. `Instance` contains a finite number `n : ℕ` of indexed physical  |
| `#124` | Polynomial-time scheduling on three identical machines. | `research/two_frame_compression/README.md` | ✅ (3份, 7305行) | `separators.tex`, Definition `def:separator` and Lemma `lem:shared`, specify the shared-cutoff walk on an exactly lexicographically least full schedule. Normalization is over feasible full schedules, not greedy list schedules. Intermediate walk positions need  |
| `#125` | The metric k-median approximation threshold and recovery. | `research/finite_comparison/report.md` | ✅ (1份, 222行) | The manuscript already proves the stronger-than-stated bound Phi<=2z. The mathematical improvement here is the replacement of 2 by 199/100 in that bound, not the removal of its denominator y. It is obtained by reducing its row penalty 1.6 to 1.59 while retaini |
| `#126` | Exponential semidefinite complexity of perfect matching. | `research/fourier-transfer/theorem.md` | ✅ (1份, 149行) | The assertions `eq:new-frequency-overlap`, `eq:smoothing-squares`, `eq:smoothing-potential`, and `eq:smoothing-coefficients` in `sections/fourier-smoothing.tex` are valid. The proof below also proves their noncommutative splitting dependency, without assuming  |
| `#128` | A factor-two approximation for shortest common superstring. | `research/host-request-audit/proof.md` | ✅ (1份, 719行) | This is a universal mathematical verification of that local construction, with kernel-checked component theorems and a separate exact word-level replay. It is not a refutation, a proof of the complete approximation theorem, a claim about maximum-overlap Greedy |
| `#131` | Rapid mixing of graph switches for every degree sequence. | `research/disjoint_core/report.md` | ✅ (1份, 16191行) | The report also proves that the coefficient \(1\) in the manuscript's local error bound cannot be decreased uniformly, by an explicit unbounded graphical family. No manuscript refutation or verified novelty is claimed. |
| `#132` | A superquadratic separation of sensitivity and block sensitivity. | `research/quantitative_profile/REPORT.md` | ✅ (1份, 4132行) | The live target is a uniform finite-depth theorem for even \(d\ge2\), \(M=16\,3^d\), \(r=4\,3^{d/2}\), followed by an actual Boolean-function family with \(\operatorname{bs}(F_m,0)\ge s(F_m)^{161/80}\). The proposed finite seed is \(d=20\), with sensitivity bo |
| `#133` | The computational complexity of Weisfeiler–Leman refinement. | `research/compressed_reduction/report.md` | ✅ (2份, 8090行) | For every permitted instance J, add one unused dimension-one real type, subdivide each schema with n = 4(r+1) private scalar types, and perform the manuscript's valuation-block, private-mark, hub, and padding construction. For every natural q, the two resultin |
| `#135` | Homogeneous depth-five lower bounds for iterated matrix multiplication. | `research/four_path_audit/report.md` | ✅ (1份, 511行) | The universal verification target above holds. More generally, the coincidence generating function factors with a different arbitrary rational coefficient `c_t` in each selected N layer, provided the selected layers are pairwise nonadjacent. Positivity is need |
| `#138` | Subset Sum in $`O(2^{0.49n})`$ time. | `research/checksum_core/report.md` | ✅ (1份, 48行) | The object under audit is Theorem `thm:checksum` in the October 4, 2026 staged manuscript, `build/sections/checksum.tex:20-44`. For every fixed constant d > 0, all sufficiently large n, every integer P satisfying \\|log_2 P - 0.51772 n\\| <= 2, arbitrary residue |
| `#149` | Classwise permanence for weakly reversible mass-action systems. | `research/affine-audit/report.md` | ✅ (2份, 2950行) | 1. Fixed-minimum construction by induction on the coordinate dimension. 2. Closedness of limiting activity, compactness of the bad-limit set, and extension to an open interval of minimum exponents. 3. Finite interval selection with closed cut cells and offset  |
| `#150` | Weak mixing of triangular billiards with an irrational angle. | `research/spectral_rigidity/report.md` | ✅ (1份, 114行) | The proof below establishes the proposition, including its endpoint identity, without assuming square-summable coefficient gradients, transverse regularity, or any extension of an operator across a cone tip. It also gives the L2 strengthening in Section 10. Th |
| `#151` | A C1 counterexample to the entropy conjecture. | `research/passage_core/report.md` | ✅ (2份, 931行) | More precisely, translate the clock so its initial reading is in `[0,1)`, write `N` for the first index with reading at least `100`, and set |
| `#152` | Zero entropy does not guarantee a smooth positive-volume model. | `research/switching_audit/controlled_volume.md` | 🐍 `verify.py` | The common starting basis has separately orthonormal slow and fast columns, but need not be orthogonal as a whole. Its inverse may grow as \(e^{Cbn}\). The threshold \(\gamma_Q\), dimensions, reference spaces, and endpoint projections are fixed by finitely man |
| `#156` | Borsuk's conjecture fails in dimension nine. | `research/continuum_bridge/report.md` | ✅ (1份, 346954行) | The proof below supplies the continuum implication, including both dimensions three and four, without assuming that any support complex triangulates projective space. Combining it with the retained theorem `C9000156_COMB`, version 5, rules out the cover and pr |
| `#158` | The Euclidean plane cannot be colored with five colors. | `research/five-color-audit/REPORT.md` | ✅ (1份, 13行) | The staged `sections/introduction.tex`, `thm:main` (lines 60-68), asserts that the Euclidean plane has no proper five-coloring with arbitrary color classes. A proper coloring has different labels at every pair at distance exactly one. It need not be measurable |
| `#159` | Erdős’s reciprocal-sum conjecture and quasipolynomial Szemerédi bounds. | `research/step_drop_audit/proof.md` | ✅ (1份, 81行) | The reduction from `prelim:common-derivative` through `prelim:lattice` to the final graded factorization is valid under its stated hypotheses. In particular, an unbounded adjoint shear does not require bounded coefficient numerators. The explicit estimate in T |
| `#160` | Superexponential van der Waerden numbers. | `research/verification/report.md` | ✅ (1份, 219行) | The applicability proof works more generally for arbitrary linked torus progressions `y = lambda*x` and meshes satisfying (W), under the explicit parameter conditions |
| `#162` | Counterexamples to Ryser’s covering conjecture. | `research/balanced_certification/native/mathlib/scripts/README.md` | ✅ (2份, 272行) | **Tools for manual maintenance** - `fix_unused.py` Bulk processing of unused variable warnings, replacing them with `_`. - `fix_deprecations.py` Automatically fixes deprecation warnings by replacing deprecated identifiers with their suggested replacements. Run |
| `#164` | Hindman’s finite sums and products conjecture. | `research/rough_step/report.md` | ✅ (1份, 110行) | This is an independent proof of Proposition `prop:rough-step`, conditional only on the external results listed below. It also proves a stronger spatial scale statement. It is not a proof of the manuscript's main finite sums-and-products theorem: Prediction, Al |
| `#166` | The higher-dimensional Erdős distinct-distances conjecture. | `research/concentration_degree/report.md` | ✅ (1份, 50行) | We prove a slightly more general statement. Let an irreducible family of evaluation flats, with projective parameter closure \(Y\subset\mathcal Q\), sweep an irreducible \(V\subset S\) of dimension \(k=s_0+h\), where \(1\le h\le e-2\). Suppose the full point i |
| `#172` | Classification of finite Euclidean Ramsey configurations. | `research/endpoint_bridge/STATEMENT_FIDELITY.md` | ✅ (2份, 1383行) | * `I` is an arbitrary finite coordinate type, with `2 <= Fintype.card I`. Thus `s` is not fixed or bounded. No commutativity instance is imposed on the ambient group. * In the principal declaration, `K = FreeGroup E`, for an arbitrary label type `E`. `exponent |
| `#173` | Seymour’s second-neighborhood conjecture. | `research/pruning-core/pruning_theorem.md` | ✅ (1份, 259行) | The constructive strengthening of the manuscript's coefficient choice is particularly simple: enumerate the arrows by `e = 0,...,m-1`, and take |
| `#175` | Talagrand’s expectation thresholds, discrete convexity, and graph decompositions. | `research/selector_certificate/proof.md` | ✅ (1份, 552行) | The target is `thm:multiscale-selector` in the staged September 23, 2026 expectation-threshold manuscript, `build/source/sections/selector.tex`. Its family need not be increasing. Its masses are arbitrary nonnegative real probability masses supported on the re |
| `#176` | The second Kahn–Kalai conjecture with an edge-count bound. | `research/tree-reduction/report.md` | ✅ (1份, 1814行) | The independently authored formal source proves the original reduction as `TreeReduction.pathwise_reduction`. It also proves `TreeReduction.pathwise_three_reduction`: **the capacity separation can be 3 instead of 16**, without changing the sampling density, su |
| `#178` | Deterministic nonbipartite Ramanujan graphs in every fixed degree. | `research/high_moment_audit/proof.md` | ✅ (1份, 47行) | More generally, the same conclusion holds for any two output spaces of sizes at least \(l/d\) satisfying the kernel, second-moment, conditional mean, and linearized-update properties stated in the proof. Positivity of a graph precision is not used again once t |
| `#179` | The circulant Hadamard and Barker-sequence conjectures. | `research/sharp_character_comparison/report.md` | ✅ (3份, 340行) | **Theorem 2 (exact optimality mechanism).** Put \(t=e-r+1\) and \(m=p^{r-1}\). For every integer \(a\) with \(p\nmid a(a-1)\), multiplication by \[ F=p-a\Phi_{p^r}(X) \] on \(R=\mathbb Z_{(p)}[C_{p^e}]\) has Smith factors \[ \begin{array}{c\\|c} \text{factor}&\ |
| `#181` | The Erdős–Gallai cycle-decomposition conjecture. | `research/routing_core/STATEMENT_FIDELITY.md` | ✅ (1份, 551行) | Labelling the r vertices by `Fin r` does not restrict a finite graph: any r-vertex graph has such a labelling. F may include nonedges or diagonal unordered pairs, which only strengthens the formal result; an actual deleted-edge subset is included in the quanti |
| `#183` | Power savings for planar halving lines and k-sets. | `research/noncollapse/proof.md` | ✅ (1份, 1661行) | The independently proved compactness theorem here allows continuous maps that need not be injective, need not have expanding images, and need not preserve lines exactly at finite indices. A common linewise bounded-turning constant and the full moving-point lim |
| `#184` | Correspondence coloring with a fixed forbidden subgraph. | `research/triangle_audit/proof.md` | ✅ (1份, 127行) | More precisely, the adjustment conclusion is \(t_i+\sum_j a_jg_i^{(j)}\le Bd_i\), with \(\sum_{j:i\in J_j}a_j\le\Lambda^4\). The second bound concerns listed operation supports, not every coordinate whose vector entry a drop operation might affect. The local c |
| `#185` | Counterexamples to infinite matroid intersection and packing/covering. | `research/report.md` | ✅ (2份, 565行) | The target is Proposition `prop:local-intervals` in the staged `04-local-bases.tex`, with its original quantifiers. The prototype `T` and its complement must both be positive for the doubled-block density-zero ideal. For either basis rule, every `I subset Y` w |
| `#186` | Uniform influence and sharp thresholds for graph and hypergraph properties. | `research/certificates/hypergraph_capture/report.md` | ✅ (2份, 405行) | Both manuscripts' load-bearing chains were read directly. The graph chain is biased Fourier identities and low-degree mass, exact restriction averaging, surviving block orbits, graph capture, variance/tail estimates, and monotone log-odds integration. The hype |
| `#188` | The sharp terminal leave in random triangle removal. | `research/collision_certificate/report.md` | ✅ (1份, 104行) | Consequently one may replace \(\kappa_n D^{-96}\) by \(D^{-96+\zeta}\) for any fixed \(\zeta>0\). The coarse bound (1) uses only the manuscript's stated factor-two envelope and is the primary specialization. The improvement over the manuscript's exponent \(-35 |
| `#190` | Polynomial removal fails for ordered binary matrices. | `research/STATEMENT_FIDELITY.md` | ✅ (1份, 164行) | `unitSignature j` is the Boolean unit word on `Fin 64` with its unique one at `j`. Formal indices are zero-based, so `0` and `1` denote the manuscript's first and second anchor groups. `unit_deletion_no_new_role` says that a word obtained by deleting ones from |
| `#192` | Boolean functions violate the square-root degree bound by arbitrary factors. | `research/verification/refined_report/report.md` | ✅ (1份, 125行) | The staged manuscript already proves the qualitative all-\(C\) result. The improvement here is an explicit finite width, explicit rigorous error budget and rational gain, together with a separately compiled universal cancellation core. This is not a claim that |
| `#197` | A torsion-free group algebra that is not directly finite. | `research/bounded-path-core/theorem.md` | ✅ (1份, 111行) | The earlier result being compared is `thm:bounded-patterns` itself: it gives an unspecified uniform error and the conservative choice `min(1/4, delta/(16(1+a_0)))`. The improvement here is an explicit path-derived finite error bound, valid for general typed gr |
| `#201` | A counterexample to Kurosh’s division-ring problem. | `research/global_relations/report.md` | ✅ (3份, 391行) | The proof below is universal, not an extrapolation of the executable experiments. It does not use cyclic compatibility, correction, lifting, realization, generation, or the main division-ring theorem. Compared with the strongest prior reviewed result, the cond |
| `#211` | The geometric phase diagram, diffusion, and spectra of random planar maps. | `research/green_estimate/theorem.md` | ✅ (1份, 68行) | These are universal arguments, not conclusions from bounded enumeration. The improvement over the staged manuscript is the full range `p<3`, the resulting source exponent `rho<2/3`, and Theorem 2. A bounded primary-source search found no matching finite-map st |
| `#216` | Critical and near-critical XY scaling and BKT universality. | `research/pinned_transfer/report.md` | ✅ (1份, 121行) | The fixed-temperature theorem is not a premise of this proof. All probabilistic limit inputs are the sequence-level hypotheses of the target lemma. The prior strongest recorded result was the open target; the improvement here is a proof of the complete transfe |
| `#218` | Conformal universality for weakly interacting and random-bond Ising models. | `research/audit_report.md` | ✅ (1份, 776行) | It is stated for arbitrary cardinality 2m, including m=0. Distinctness is unnecessary for this polynomial identity, but is necessary for the negative powers in w_X. |
| `#219` | GOE bulk universality for regular graphs with weak Anderson disorder. | `research/rigidity_certificate/report.md` | ✅ (2份, 408行) | The theorem below strengthens the equality case: nonzero endpoint correlation and an atomless potential distribution are unnecessary. Parity-preserving ergodicity suffices, and only a logarithmic inverse-covariance moment is needed in the heat-flow argument. T |
| `#225` | Gaussian free field limits throughout the balanced six-vertex regime. | `research/AUDIT_REPORT.md` | ✅ (1份, 36行) | The Engineer read the actual Proposition 3.1 and (3.8)-(3.9) in [KMST, arXiv:hep-th/0406190v1](https://arxiv.org/html/hep-th/0406190v1). The passage and convention translation are in `certificate_sources/KMST2005-excerpt.md`. No completeness theorem is used. A |
| `#228` | Continuum phase transitions for radial pair potentials. | `research/range_audit/report.md` | ✅ (1份, 164行) | **The quantitative assertion of algebraic-decay Theorem `k:range` is valid.** The proof below works for every reference allowed there, including countably many preceding ranges, reference coexistence parameters, and arbitrarily small positive added mass. It al |
| `#230` | Exact Hausdorff gauges for SLE. | `research/mesh-tail-audit/report.md` | ✅ (1份, 110行) | * Rezaei--Zhan, arXiv:1412.3700v2, Theorems 1.1--1.2: arbitrary approach radii and moments of every fixed order are allowed. The constant depends on the order; the observation set is not an arbitrary initial domain. These statements do not supply a uniform \(n |
| `#231` | The free uniform spanning forest is a factor of IID. | `research/covariance_symmetry/theorem.md` | ✅ (1份, 194行) | More generally, it suffices that `Cov(R_A,R_B) = 0`, where `R_A = sum_(i in A) X_i` and similarly for B. |
| `#233` | The joint critical Ashkin–Teller current limit. | `research/full_spin_witness/report.md` | 🐍 `verify.py` | The proof below verifies buffered terminal separation and strengthens its iteration: **at most `k-1` successful localization layers suffice**, rather than one layer per opposite pair. More generally the proof applies to a square-lattice colored cut model with  |
| `#234` | All-temperature pressure of orthogonally invariant Ising spin glasses. | `research/quadratic_cavity/report.md` | ✅ (1份, 98行) | Before this mission the campaign ledger contained the campaign objective alone. The manuscript already states the spectral-resolvent transport formula. The improvement here is an independent proof for every finite depth and dimension, an abstract matrix-ladder |
| `#235` | Limiting random SAT thresholds, sharp variance and computability. | `research/pathwise-record-transfer/record_transfer.md` | ✅ (1份, 101行) | Only the scalar averaged overlap is needed for this estimate. Componentwise ordering of the vector overlaps (`ct:ordering`) is unnecessary for record creation. All depths here are arbitrary finite integers, all limiting arrays are countably infinite, and the f |
| `#236` | The exact factor-of-IID threshold for free Ising spins on trees. | `research/critical_endpoint/PROOF.md` | ✅ (1份, 96行) | **Generalization.** The same critical comparison closes whenever the log-factor derivative has any positive local flatness exponent and the marginal exceptional-field probability decays as \(\exp[-c\log^q(1/t)]\) for any \(q>1\). More generally, moment bounds  |
| `#245` | Weak normalization implies strong normalization in pure type systems. | `research/typed_probe_bridge/STATEMENT_FIDELITY.md` | ✅ (2份, 1096行) | ``` Access(Bundle(m,y), q) iff q(m, Round(y)). ``` |
| `#246` | Cannon's conjecture. | `research/separated_capacity/report.md` | ✅ (1份, 230行) | The precise strengthening is the following. All constants, the scalar function, the modulus sequence, and the maximum permitted parent scale are fixed first. Write \(r=a^{-D}R\), \(s=a^{-d}R\), and \[ {\cal C}_{D}(x,R,J)= \max_{\substack{Y'\subset Y\\d(y,y')>H |
| `#251` | Amenability, unitarizability, and strong Ulam stability. | `research/circuit-comparison/comparison.md` | ✅ (1份, 122行) | Here is a slightly more general statement, useful for distinguishing the two sources of error. |
| `#252` | A torsion-free hyperbolic group that is neither residually finite nor linear over any field. | `research/quotient_uniform/proof.md` | ✅ (1份, 347行) | The strongest prior result in the project ledger was the unverified campaign objective, not a proof of this obstruction. The improvement here is a complete independent derivation with explicit interfaces, exact adversarial fixtures, and a compiler-checked alge |
| `#259` | A group without fixed price. | `research/planar-audit/theorem.md` | ✅ (2份, 697行) | The injectivity hypothesis of the manuscript's lemma is thus unnecessary under these relator hypotheses. The proof also permits arbitrary `H` and arbitrary exterior alphabets, since each filling uses finite support. |
| `#262` | Sharp finite-matrix Lieb–Thirring inequalities and all equality cases. | `research/trace_deficit_audit/report.md` | ✅ (1份, 160行) | The existing ledger initially contained only the campaign objective, with no certified trace result. The strongest mathematical prior result relevant here is nevertheless the *staged exact deficit itself*, including the stronger quantitative use in the equalit |
| `#269` | Uniform Laughlin gap and stability under bounded scalar disorder. | `research/retained_blocks/theorem.md` | ✅ (1份, 58行) | This is a proposed **structural strengthening**, with a complete mathematical proof and a finite exact arithmetic certificate. Independent Reviewer acceptance and publication-level novelty assessment remain outstanding. It is not a many-particle finite-size ex |
| `#271` | Bloch's law, its lattice correction, and the spherical magnetization law. | `research/zero_free_traces/report.md` | ✅ (1份, 328行) | The proof below also gives a quantitative strengthening. If there are N slots and m permutation layers, and each intervening slot matrix maps `\\|x\\| < R` into the open unit disk with a nonzero first coordinate, for a common R > 1, then |
| `#275` | QMA-hardness of continuum Coulomb energy. | `research/unit_charge_replacement/proof.md` | ✅ (1份, 81行) | The improvement over the manuscript is the bounded vector primitive of the Coulomb kernel, not a smaller constant in its absolute-potential argument. A bounded search for an existing theorem giving this particular transported, area-uniform pair of estimates fo |
| `#279` | Exact quantum factoring over a fixed finite gate set. | `research/order_trial/report.md` | ✅ (1份, 108行) | The constant `1/2` in the corresponding interval-average inequality is sharp. This is an independent verification theorem and an algebraic strengthening, not a counterexample. Novelty and publishable significance remain for independent review; they are not est |
| `#280` | Unitary vertex operator algebras and conformal nets. | `research/energy-bootstrap/report.md` | ✅ (1份, 202行) | The zero-mode transfer and both contractions also admit the proofs below, without assuming the energy estimate they are intended to establish. For the vacuum, these arguments only require C2-cofiniteness, simplicity, unitarity, and CFT type: rationality is unn |
| `#286` | Rigidity and arithmetic of lattice von Neumann algebras. | `research/boundary_sharpness/theorem.md` | ✅ (1份, 76行) | The frame-functional and parallel-sum steps in `lem:transfer-disjointness` admit the proof below without assuming that any candidate is sharp, that two candidates commute, or that angular multiples of the embedded input have regular group support. The finite n |
| `#288` | Kadison's similarity conjecture. | `research/invariant-intertwiners/proof.md` | ✅ (1份, 208行) | The union \(\mathcal A=\bigcup_jD_j\) is \(L^2\)-dense in \(E\). Indeed, if \(\eta\in E\) is perpendicular to \(\mathcal A\), the functional \(d\mapsto\langle d,\eta\rangle\) on \(D\) is normal. To see the normality without assuming a bounded representative fo |
| `#289` | Strong Kadison–Kastler stability and its spatial boundaries. | `research/free_word_audit/report.md` | ✅ (1份, 126行) | **Theorem (all-multiset strengthening).** Let \(r\geq1\), in a von Neumann algebra with a faithful normal tracial state. Suppose \(r\) scalar-free unital components contain orthogonal projection partitions \((e_a^{(j)})_{a=1}^d\), with sum 1 and trace \(1/d\). |
| `#293` | Invariant projections, hyperinvariant subspaces, and transitive algebras. | `research/quadratic-support-separation/report.md` | ✅ (1份, 540行) | The improvement over this campaign's initial state is a complete source-faithful proof plus an independently authored, kernel-checked analytic core, not a mathematically stronger classification than the literature. The symmetric kernel estimate in Section 3 be |
| `#294` | Kaplansky's quasitrace conjecture and failure of tensor-product stable finiteness. | `research/certification/report.md` | ✅ (1份, 12行) | The archived claim certificate is `certificates/C294_MAIN-9f656e417523899a.json`. The separate `exact_certificate.json` binds all original and ported source hashes, the wrapper, its statement-fidelity document, the verifier, and the native compiler record. Thi |
| `#295` | The Kadison–Ringrose cohomology conjecture. | `research/rigidity/report.md` | ✅ (1份, 276行) | In fact fewer sign patterns suffice. Call a signed word **good** when it is nonempty, begins and ends positively, and has no two consecutive negative signs. It suffices to prescribe `R(w)=aw` on distinct-index good words and `R(w*)=bw*` on their adjoints. This |
| `#297` | A ZFC counterexample to Naimark's problem. | `research/selective_bridge/report.md` | ✅ (1份, 106行) | The bridge's operator-norm assertion holds under its actual hypotheses. The proof below works for every fixed finite word length, over the product of the two excision index sets, including arbitrary old pure states outside the designated classes. It also prove |
| `#300` | Approximation and quadratic strong-operator paving. | `research/pinning/report.md` | ✅ (1份, 921行) | where H_i has first diagonal -beta a. The probabilities need not be uniform; zero-probability options are allowed. Repeated poles, zero poles, and zero residues are allowed. There is no dimension bound. This is a proof, not an inference from passing examples. |
| `#310` | Quillen's conjecture in rational homology. | `research/frame_kernel/REPORT.md` | ✅ (1份, 115行) | This is a mathematical verification theorem, with a kernel-checked all-dimensions combinatorial core and finite exact checks of actual presentations. It is not a counterexample, a formalization of the entire Lie-superalgebra construction, a novelty certificati |
| `#314` | Cyclic length and chromatic fixed-point loss. | `research/profinite_rigidity/report.md` | ✅ (1份, 204行) | The graph count in the manuscript is correct. The result proved below replaces its qualitative nonzero-limit contradiction by a uniform finite index and an exact valuation. It verifies the purely profinite theorem; it does not verify `thm:pro-characters`, `lem |
| `#315` | The four-dimensional Singer conjecture. | `research/all-parabolic-reduction/report.md` | ✅ (1份, 183行) | The criterion separates the actual reduction from the hypotheses used to produce D(B). Once D(B) is known to be a point, finite presentation and the no-splitting conditions are unnecessary for this reduction. Torsion-freeness can be weakened to absence of infi |
| `#316` | Curtis’s conjecture. | `research/tor_injection/report.md` | ✅ (1份, 109行) | The argument below is a uniform proof, not an inference from finite experiments. It also proves a stronger exponent-support statement for all positive Tor degrees over the first \(k\) primitives. The formal source certifies the exponent-truncation step, not th |
| `#318` | Chromatic splitting: filtrations and counterexamples. | `research/prime-five-kernel/proof.md` | ✅ (10份, 1029行) | The strongest selected manuscript statement names m=16. The improvement here is the range 13 through 16: the sphere coefficients satisfy the sharper upper line already implicit in Devinatz--Hopkins, so the possible extra adic degree in the manuscript is unnece |
| `#319` | Counterexamples to finite generation at chromatic height two. | `research/joint_kernel/report.md` | 🐍 `verify.py` | ``` ord_x(z_h-z_h') >= l iff h H_l = h' H_l, b_i H_l = b_j H_l iff i = j modulo N_l, N_l -> infinity, r_m = sum_(l>=1) floor(m/N_l) <= kappa m, kappa = sum_(l>=1) 1/N_l <= p/(p-1) <= 2. ``` |
| `#321` | A counterexample to Wall's finite D(2) problem. | `research/wall_d2_audit/report.md` | ✅ (3份, 2959行) | The following sections prove this assertion without assuming a finite |
| `#322` | Tingley’s sphere-isometry problem. | `research/chord_obstruction/STATEMENT_FIDELITY.md` | ✅ (1份, 604行) | To pass from a manuscript support at `v+theta*y` to `heq`, use `theta=h*s/p`, so `a*theta=h` and `a>0`. Scaling a supported vector by `a` gives a support at `a*v+h*y`. Linearity gives `a*lv+h*ly=P.n a h`. Domination on the ambient finite span gives `hdom`. Con |
| `#325` | The complete Crouzeix conjecture. | `research/crouzeix_core/REPORT.md` | ✅ (1份, 316行) | Then `\\|\\|F[A]\\|\\|<=2`, uniformly in both dimensions and degree. More generally, replacing the upper nonconstant weight two by any `beta>0` gives `\\|\\|F[A]\\|\\|^2<=max(4,2 beta)`. No symmetry of the exterior kernel is required. |
| `#326` | The cotype–cotype conjecture under the approximation property. | `research/coefficient_certificate/report.md` | ✅ (1份, 270行) | This is a universal quantitative strengthening of the manuscript's existential, compactness-based \(c_*(m,a,b)>0\). The rightmost explicit bound depends on \(m\) alone; the first bound in (1) retains the dependence on \(a,b\). We do not pick a small, infeasibl |
| `#328` | Nonexpansive fixed points in reflexive Banach spaces. | `research/tree_construction/STATEMENT_FIDELITY.md` | ✅ (3份, 2071行) | The license, upstream source, revision, modification notices, dependency inspection and port diff are retained under `producer/`. This is not an independently invented proof of the anchor or adaptive construction. In particular, the upstream Lean 4.34.1 toolch |
| `#330` | A uniformly discrete counterexample to bounded approximation in Lipschitz-free spaces. | `research/adaptive_support/report.md` | ✅ (2份, 863行) | This component addresses `blocks.tex`, Lemma `lem:local-limit`, and `walks.tex`, Lemma `lem:rare-walks`, in the staged September 26, 2026 manuscript. The manuscript's argument is sound at these two steps; no false assertion has been identified here. The improv |
| `#334` | A smooth surface metric with no local isometric immersion in ℝ3. | `research/cap_audit/report.md` | ✅ (1份, 74行) | The proof also establishes a structural extension. Replace the prescribed curvature outside the perturbation square by \[ K=\kappa(x^{2m}-h(y)),\qquad m\in\mathbb N,\quad m\ge1. \] The same cap proposition holds, with constants allowed to depend on \(m\). The  |
| `#336` | Spectral scalar curvature, Urysohn width, and macroscopic dimension. | `research/shielding_audit/README.md` | ✅ (1份, 192行) | **Theorem T.** Under the finite-label packet and true-cut hypotheses specified below, Proposition `shield:global` holds with its stated coefficient `22/25 = .88`, on the wall and on **both** joined sides, without imposing a zero seam trace. In fact its existen |
| `#337` | Sharp Cartan–Hadamard isoperimetry and rigidity. | `research/sobolev_verification.md` | ✅ (1份, 66行) | For a hypersurface, \({\bf H}=hN\) when \(mh=\operatorname{div}_\Sigma N\). Thus the theorem includes **exactly** the manuscript's statement. The normal-vector formulation also proves an arbitrary-codimension extension. This extension and the centering potenti |
| `#338` | Yau's uniformization conjecture. | `research/linear_alignment/REPORT.md` | ✅ (1份, 75行) | Here is an abstract version that also allows arbitrary near-identity incoming adjustments; the incoming perturbation need not be triangular or unipotent. All norms are Euclidean operator norms. At every step k let |
| `#341` | Donaldson's hypersymplectic deformation conjecture. | `research/restricted-jet-audit/argument.md` | ✅ (1份, 148行) | The pre-existing ledger contained the campaign objective but no mathematical proof or reviewed result. The improvement here is an explicit description of the entire restricted cokernel, a proof of its elimination at every distributional order, and a support-re |
| `#342` | Donaldson's tamed-to-compatible conjecture. | `research/cone_conflict/proof.md` | ✅ (1份, 112行) | Set \[ \eta=U+2f e^{13}+2k e^{23}. \] Its added terms are closed because \(df\) is a multiple of \(dx_1\) and \(dk\) is a multiple of \(dx_2\). More precisely, \[ \eta-U=d\left[-\frac{\cos(2\pi x_1)+\cos(2\pi x_2)} {4\pi}\,dx_3\right]. \] Thus \([\eta]=[U]\),  |
| `#344` | The metric Blaschke conjecture. | `research/no_splitting_audit/proof.md` | ✅ (1份, 25行) | The proof actually establishes the following stronger, lag-resolved statement. Set \(T=\pi\), \(D=T/2\), and \[ w(z)=\sin^m z\,\\|\sin(2z)/2\\|^k. \] Extend the symmetric endpoint determinant \(f\) separately periodically with period \(T\). Then \[ \boxed{\quad  |
| `#346` | Sharp singular-set bounds for stationary integral varifolds. | `research/signed_excess_audit/simon_area_excerpt.md` | ✅ (1份, 65行) | > We note also that if \(h\) is any non-negative > \(\mathcal H^n\)-measurable function on \(M\), then, by approximation > of \(h\) by simple functions, 2.4 implies the more general formula |
| `#349` | The Solomon–Yau least-volume conjecture. | `research/lorentz_contact/report.md` | ✅ (1份, 415行) | The previous project state had no supporting evidence for its campaign claim. The improvement here is a universal formal algebraic certificate and a complete local geometric argument, rather than a finite search or an assertion that a cited index theorem is ne |
| `#352` | A finite-time singularity of Calabi flow. | `research/profile-audit/report.md` | 🐍 `verify.py` | This note proves a quantitative strengthening of the profile construction in `build/sections/profile.tex` of the staged September 24, 2026 manuscript. All decimals below are rationals. The numerical part is reproducible with standard-library Python and asserti |
| `#358` | A three-manifold without conjugate points or nonpositive curvature. | `research/returning_passage/REPORT.md` | 🐍 `verify.py` | The manuscript already proves nonnegativity using a Hilbert-space relaxation and a strict timing margin. The improvement here is an *attained*, necessary and sufficient endpoint reduction, a quantitative normal-energy gap, a complete nullspace description, and |
| `#359` | Negative Kähler curvature without bounded holomorphic coordinates. | `research/certificates/hartogs_real_planes/proof.md` | ✅ (1份, 175行) | This strengthens the staged core by giving a coercive mixed-block inequality, an explicit threshold, and explicit two-sided curvature bounds. It is not a refutation of `pinch:positivity`, which is consistent with the result. |
| `#360` | Weak MTW curvature gives convexity and regular optimal transport. | `research/local_injectivity_certificate/report.md` | ✅ (2份, 1129行) | The improvement over the strongest relevant prior formal result is a **direct geometric bridge for arbitrary continuous representing data** and the above pointwise hypothesis reduction. It is not a claim that moving parameter Taylor calculus or vanishing-weigh |
| `#361` | Failure of integer-degree harmonic dimension comparison. | `research/crossing_matching/theorem.md` | ✅ (1份, 86行) | **H1 (smooth fixed-area angular family).** A smooth finite-dimensional family \(h(w)\) of sphere metrics has area form \(4\pi\mu\). The reference \(w(s)\), \(s\geq0\), is smooth and periodic, with compact image in the parameter domain, and is constant on a nei |
| `#365` | Joint metric and connection recovery from one boundary patch. | `research/angular_coercivity/theorem.md` | 🐍 `verify.py` | The perturbation error-form estimate in the two staged manuscripts is valid under its stated scalar coefficient contract. In particular, arbitrarily high angular degree and arbitrarily high base frequency do not defeat that estimate. The proof below is uniform |
| `#366` | The planar Mumford–Shah regularity conjecture and local weak-L4 gradient bounds. | `research/compact_piece_audit/proof.md` | 🐍 `verify.py` | There is also a useful structural strengthening. A compact-support interaction is harmonic on every allowed translation chamber under **local** square integrability alone. An exact cutoff cancellation gives the variational inequality for this interaction witho |
| `#367` | The critical dimension for the one-phase Bernoulli problem. | `research/universal_tensor_audit/report.md` | ✅ (1份, 61行) | The boundary domain is `g=0`, `\\|p\\|=1`, `Ap=lambda p`, `lambda<0`, with the same conditions on `A`. In particular `lambda=0` is excluded as a counterexample. Orthogonal invariance allows a diagonal `A` and `p=e_5`; the tangential eigenvalues need not be disti |
| `#371` | Stable blowup for the defocusing Schrödinger equation. | `research/unbounded-spectrum-bridge/theorem.md` | 🐍 `verify.py` | Let \(0<a_j\le1\), \(\\|b_j\\|\le B\), \(-1/32\le\sigma_j\le4\), \(\omega_j\ge0\), and \(\ell_j\in\mathbb N_0\). The coefficients \(P_j,\phi_j\) are real on \([r_b,\infty)\), and, for every fixed \(s\), \[ \\|D^s(P_j/a_j)\\|\le C_s r^{-2},\qquad \\|D^s e^{2i\phi_j} |
| `#372` | Global uniqueness in smooth isotropic elasticity. | `research/physical_frame/verification.md` | ✅ (1份, 147行) | **Theorem 2 (complete smooth profile realization).** More generally, let (a0,b0) be any smooth constrained transport solution on a planar cylinder D_R^2 times I, R>5r, smoothly extended by zero outside a fixed compact set K contained in I in the transverse coo |
| `#373` | Nonattainment of the three-marginal Coulomb Monge problem. | `research/coulomb-contact-certificate/report.md` | ✅ (1份, 116行) | The supplied primary sources were opened before custom computation by the `primary-baselines` research subagent; short excerpts are in `literature/`. Colombo--Di Marino, April 11, 2013 author version, Theorem 1.1, proves equality of Coulomb Kantorovich and cyc |
| `#374` | Sharp one-third stability of Brenier maps. | `research/cell_moment_audit/sharp_moment_theorem.md` | ✅ (2份, 606行) | A targeted literature lookup located and opened Delalande--Merigot, arXiv:2103.05934v2 (8 March 2023), including its Introduction, "Contributions," and Theorem 2.1: https://arxiv.org/html/2103.05934v2 . The stated potential estimate in that introduction has mo |
| `#376` | Universal computation in forced Navier–Stokes flows. | `research/rapid_lattice/report.md` | ✅ (1份, 320行) | 1. For every finite deterministic machine table, totalized on the entire address domain exactly as in the manuscript, all residue, periodicity, writing-selector, and all-time halting-detection conclusions hold. They do not require addresses to be reachable or  |
| `#377` | Interior $`C^{1,\alpha}`$ regularity for infinity-harmonic functions. | `research/three_point_flatness/report.md` | 🐍 `verify.py` | An explicit quantitative strengthening is also obtained. In every finite dimension, let `U` be infinity-harmonic on `B_1`, let its Lipschitz constant be at most `L >= 0`, and let `ell` be affine with `epsilon = \\|\\|U-ell\\|\\|_infinity < infinity`. Define |

</details>

---

## 四、 384 份零 `sorry` Lean 4.31.0 局部核心形式化证书（构成与行数拆解）

在全部 373 个活跃家族中，Argus 为 **317 个家族（`85.0%`）** 编写并通过了 **384 份零 `sorry`、零自定义公理的 Lean 4.31.0 局部形式化证书**（其中包括 OpenAI 原库未标注 Lean 证明的 **93 个家族**）：
* **总代码行数拆解（避免将自动展开的 SAT 归结与手写结构证明混为一谈）**：
  - **全部 384 份证书总计**：**`520,223` 行 Lean 4 代码、`41,764` 条 `theorem`/`lemma`**；
  - **其中 `#156`（九维 Borsuk 猜想反例的十标签有限组合阻碍 `C9000156_COMB`）单独占 `346,954` 行（`32,135` 条定理）**：由于审计工具 `lean_axiom_audit.lean` 禁用 `native_decide` 与 `bv_decide`，Engineer 将 19,189 条输入子句与 4,695 步 LRAT 不可满足归结（113,449 次单位传播）自动编译为纯 Lean 4 内核的基础析取消去定理，证明了抽象十标签系统的不可满足性 `no_ten_label_family`（连续统流形与容许映射部分不在 Lean 范围内）；
  - **其余 316 个家族（383 份证书）共计 `173,269` 行（`9,629` 条定理）**：为常规的代数、组合、矩阵、群环与算子不等式结构证明（如 `#118` 装箱配置 LP 间隙 16,195 行、`#131` 图交换混合 16,191 行、`#133` Weisfeiler–Leman 8,090 行、`#124` 三机调度 7,305 行、`#321` Wall $D(2)$ 整群环 Fox 微分 2,029 行）。

---

## 五、 附录：OpenAI `openai/math` 全部 373 个活跃家族逐一审计总表

<details>
<summary><b>📊 点击展开：全部 373 个活跃家族（720 篇手稿）审计范围、Lean 证书与账本记录总表</b></summary>

| 家族 (`Campaign`) | 家族标题 | 篇数 | 原库 Lean 标签 | Argus Lean 4.31.0 局部核证书 (`行数 / 定理数`) | 审计与形式化范围分类 | 账本 `refutes` 记录及真实属性 |
| :--- | :--- | :---: | :---: | :---: | :--- | :--- |
| `#001` (`9000001`) | Milne’s rationality conjecture and algebraic specialization. | 1 | No | ✅ 1 (45L / 4T) | Category II | 0 |
| `#002` (`9000002`) | The full BSD formula from low Selmer corank. | 3 | No | ✅ 1 (197L / 17T) | Category II | 0 |
| `#003` (`9000003`) | The quasi-Riemann hypothesis. | 3 | Yes | ✅ 2 (3041L / 155T) | Category II | 0 |
| `#004` (`9000004`) | Hilbert’s tenth problem over ℚ. | 2 | No | ✅ 2 (419L / 28T) | Category II | 0 |
| `#005` (`9000005`) | Irrationality of Catalan’s constant. | 1 | Yes | ✅ 1 (112L / 11T) | Category II | 0 |
| `#006` (`9000006`) | Goldfeld’s conjecture: densities and mean analytic rank. | 2 | No | ✅ 1 (564L / 30T) | Category II | 0 |
| `#007` (`9000007`) | Ordinary two-point correlations and the corrected Elliott conjecture. | 1 | Yes | ✅ 1 (158L / 12T) | Category II | 0 |
| `#008` (`9000008`) | The Deligne–Drinfeld conjecture. | 1 | Yes | ✅ 1 (47L / 3T) | Category II | 0 |
| `#009` (`9000009`) | Function-field reconstruction from Milnor K-theory and Galois data. | 3 | Yes | ✅ 2 (2314L / 101T) | Category II | 0 |
| `#010` (`9000010`) | Unrestricted pro-modularity at the prime two. | 3 | No | ✅ 1 (67L / 3T) | Category II | 0 |
| `#011` (`9000011`) | Prime-factor statistics of $`p-1`$. | 3 | No | ✅ 2 (362L / 23T) | Category II | 0 |
| `#012` (`9000012`) | Independent largest prime factors of consecutive integers. | 1 | Yes | ✅ 1 (220L / 9T) | Category II | 0 |
| `#013` (`9000013`) | Ostmann’s inverse Goldbach conjecture. | 1 | Yes | ✅ 1 (118L / 11T) | Category I | 0 |
| `#014` (`9000014`) | Restricted geometric Langlands, global Arthur enhancements, and generic Ramanujan. | 8 | No | — | Category III | 0 |
| `#015` (`9000015`) | Torus-packet equidistribution in prime, quartic, and sextic degrees. | 3 | Yes | — | Category III | 0 |
| `#016` (`9000016`) | Zilber–Pink in abelian varieties and the Siegel threefold. | 4 | No | ✅ 1 (91L / 4T) | Category II | 0 |
| `#017` (`9000017`) | The irrationality exponent of π is 2. | 1 | Yes | ✅ 1 (164L / 9T) | Category II | 0 |
| `#018` (`9000018`) | The Margulis–Platonov conjecture over global fields. | 2 | No | ✅ 1 (305L / 15T) | Category II | 0 |
| `#019` (`9000019`) | The local p-adic section conjecture and global consequences. | 2 | No | ✅ 1 (61L / 5T) | Category II | 0 |
| `#020` (`9000020`) | Squarefree quartics and power-free polynomial values. | 1 | Yes | ✅ 1 (164L / 6T) | Category II | 0 |
| `#021` (`9000021`) | A quadratic bound for Jacobsthal’s function. | 1 | Yes | ✅ 1 (329L / 20T) | Category II | 0 |
| `#022` (`9000022`) | The weak inhomogeneous Duffin–Schaeffer conjecture. | 1 | No | ✅ 1 (475L / 28T) | Category II | 0 |
| `#023` (`9000023`) | Patterson's first moment for cubic Gauss sums. | 1 | Yes | ✅ 1 (308L / 20T) | Category II | 0 |
| `#024` (`9000024`) | An asymptotic formula for the number of totients. | 1 | Yes | ✅ 1 (141L / 9T) | Category II | 0 |
| `#025` (`9000025`) | Short Egyptian fractions. | 1 | Yes | ✅ 2 (3265L / 103T) | Category II | 0 |
| `#026` (`9000026`) | Positive lower density of large prime gaps. | 1 | Yes | ✅ 1 (74L / 7T) | Category II | 0 |
| `#027` (`9000027`) | Potential integral density on curve character varieties. | 1 | Yes | ✅ 1 (112L / 11T) | Category II | 0 |
| `#028` (`9000028`) | Uniformly bounded components of Gaussian-prime graphs. | 1 | Yes | — | Category III | 0 |
| `#029` (`9000029`) | Primitive roots for every admissible integer base. | 2 | No | — | Category III | 0 |
| `#030` (`9000030`) | Modularity of elliptic curves over imaginary quadratic fields. | 1 | No | ✅ 1 (159L / 11T) | Category II | 0 |
| `#031` (`9000031`) | Uchida’s conjecture for open homomorphisms of Galois groups. | 1 | No | — | Category III | 0 |
| `#032` (`9000032`) | The rational Hodge conjecture for CM abelian varieties. | 5 | Yes | — | Category III | 0 |
| `#033` (`9000033`) | Iitaka subadditivity, variation, and logarithmic additivity. | 5 | Yes | — | Category III | 0 |
| `#034` (`9000034`) | Log abundance for compact Kähler spaces under logarithmic Iitaka subadditivity. | 14 | No | — | Category III | 0 |
| `#035` (`9000035`) | Log-canonical threefold abundance in numerical dimension one. | 2 | No | ✅ 1 (251L / 18T) | Category II | 0 |
| `#036` (`9000036`) | Numerical semiampleness and generalized minimal models. | 4 | No | ✅ 1 (326L / 25T) | Category II | 0 |
| `#037` (`9000037`) | The ordinary-double-point volume gap. | 2 | No | ✅ 1 (54L / 2T) | Category II | 0 |
| `#038` (`9000038`) | Fujita’s freeness conjecture. | 1 | No | ✅ 1 (256L / 13T) | Category II | 0 |
| `#039` (`9000039`) | Nagata’s conjecture and maximal Seshadri constants. | 4 | Yes | ✅ 1 (125L / 4T) | Category I | 0 |
| `#040` (`9000040`) | Bloch’s conjecture for complex surfaces. | 1 | No | — | Category III | 0 |
| `#041` (`9000041`) | Hyperkähler SYZ and projective-space bases. | 2 | No | ✅ 1 (214L / 11T) | Category II | 0 |
| `#042` (`9000042`) | Oka classification for minimal compact complex surfaces: Kodaira dimension zero and class VII. | 1 | No | — | Category III | 0 |
| `#043` (`9000043`) | P = W for fixed-determinant SLn moduli spaces. | 1 | No | — | Category III | 0 |
| `#044` (`9000044`) | The equivariant cohomological Hikita conjecture. | 1 | No | ✅ 1 (81L / 8T) | Category II | 0 |
| `#046` (`9000046`) | Shafarevich counterexamples in dimension two and with large fundamental group. | 2 | No | ✅ 1 (65L / 4T) | Category II | 0 |
| `#047` (`9000047`) | Zariski cancellation and affine fibrations over the complex numbers. | 1 | Yes | ✅ 1 (161L / 7T) | Category II | 0 |
| `#048` (`9000048`) | A characteristic-zero counterexample to Lipman–Zariski. | 1 | No | — | Category III | 0 |
| `#049` (`9000049`) | A stable-coordinate counterexample in four variables. | 2 | Yes | ✅ 1 (176L / 10T) | Category II | 0 |
| `#050` (`9000050`) | A counterexample to Griffiths’ positivity conjecture. | 1 | Yes | — | Category III | 0 |
| `#051` (`9000051`) | Kobayashi’s canonical-ampleness conjecture. | 1 | No | — | Category III | 0 |
| `#052` (`9000052`) | Tangent splittings and product decompositions. | 2 | Yes | ✅ 1 (217L / 18T) | Category II | 0 |
| `#053` (`9000053`) | A counterexample to Pixton completeness in Chow. | 1 | No | ✅ 2 (272L / 26T) | Category II | 0 |
| `#054` (`9000054`) | Irrational cubic fourfolds with Hodge-theoretic and categorical K3 associations. | 1 | No | ✅ 1 (144L / 13T) | Category II | 0 |
| `#055` (`9000055`) | Gepner symmetry and large-volume stability on threefolds. | 2 | No | ✅ 1 (205L / 19T) | Category II | 0 |
| `#056` (`9000056`) | Termination of projective and Kähler fourfold minimal model programs. | 5 | No | — | Category III | 0 |
| `#057` (`9000057`) | Fundamental groups of special complex varieties and root orbifolds. | 3 | No | ✅ 1 (76L / 6T) | Category II | 0 |
| `#058` (`9000058`) | Semialgebraic universal covers and bounded domains. | 2 | Yes | — | Category III | 2 (C_LOC_NECK_ADMISSIBLE) — internal_candidate_or_shortcut_exclusion |
| `#059` (`9000059`) | Counterexamples to Zariski’s multiplicity conjecture. | 2 | No | — | Category III | 0 |
| `#060` (`9000060`) | The Global Spherical Shell conjecture. | 1 | No | — | Category III | 0 |
| `#062` (`9000062`) | Projective contact classification and the LeBrun–Salamon conjecture. | 1 | No | ✅ 1 (41L / 2T) | Category II | 0 |
| `#063` (`9000063`) | The generalized Mukai conjecture. | 1 | No | — | Category III | 0 |
| `#064` (`9000064`) | Topological triviality of μ-constant surface singularities. | 1 | No | — | Category III | 0 |
| `#065` (`9000065`) | Virasoro constraints for complete intersections and projective-bundle towers. | 2 | No | ✅ 1 (81L / 6T) | Category II | 0 |
| `#066` (`9000066`) | Bounded klt complements for Fano contractions. | 2 | Yes | ✅ 1 (69L / 3T) | Category II | 0 |
| `#067` (`9000067`) | The Campana–Peternell conjecture in dimension six. | 1 | No | ✅ 1 (33L / 3T) | Category II | 0 |
| `#068` (`9000068`) | Anticanonical nonvanishing in every dimension. | 7 | No | ✅ 1 (122L / 12T) | Category II | 0 |
| `#069` (`9000069`) | Global quantum geometric Langlands at irrational level. | 1 | No | — | Category III | 0 |
| `#071` (`9000071`) | Koebe’s circle-domain conjecture. | 2 | Yes | ✅ 1 (52L / 6T) | Category II | 0 |
| `#072` (`9000072`) | Brennan's conjecture and the integral-means spectrum. | 2 | Yes | ✅ 1 (121L / 9T) | Category II | 0 |
| `#073` (`9000073`) | The Falconer distance conjecture. | 1 | Yes | ✅ 1 (1136L / 51T) | Category II | 0 |
| `#074` (`9000074`) | Kakeya in three and four dimensions. | 2 | No | ✅ 1 (101L / 5T) | Category II | 0 |
| `#075` (`9000075`) | The $`L\log L`$ Fourier-convergence conjecture. | 1 | Yes | ✅ 1 (691L / 21T) | Category II | 0 |
| `#076` (`9000076`) | Real ultraflat Littlewood polynomials and unbounded binary merit factors. | 3 | Yes | ✅ 1 (120L / 6T) | Category II | 0 |
| `#077` (`9000077`) | Fourier restriction for positively curved surfaces. | 2 | No | — | Category III | 0 |
| `#078` (`9000078`) | The three-dimensional Bochner–Riesz conjecture. | 1 | No | ✅ 1 (126L / 4T) | Category II | 0 |
| `#079` (`9000079`) | Local smoothing for the Euclidean wave equation. | 2 | Yes | ✅ 1 (108L / 8T) | Category II | 0 |
| `#080` (`9000080`) | The exact Sobolev endpoint for Schrödinger convergence. | 2 | No | ✅ 1 (93L / 10T) | Category II | 0 |
| `#081` (`9000081`) | Riesz transforms and rectifiability in higher codimension. | 1 | Yes | ✅ 1 (69L / 5T) | Category I | 0 |
| `#082` (`9000082`) | Annular variation and dyadic absolute bounds for the triangular Hilbert transform. | 3 | Yes | ✅ 1 (99L / 5T) | Category II | 0 |
| `#083` (`9000083`) | Hilbert transforms along Lipschitz directions. | 1 | Yes | ✅ 1 (181L / 16T) | Category II | 0 |
| `#084` (`9000084`) | The geometric case of the Erdős similarity conjecture. | 2 | Yes | ✅ 1 (819L / 36T) | Category II | 0 |
| `#085` (`9000085`) | Endpoint Sobolev regularity of centered disk averages. | 1 | Yes | ✅ 1 (322L / 21T) | Category I | 0 |
| `#086` (`9000086`) | An L3 bound for the trilinear Hilbert transform. | 1 | No | ✅ 2 (322L / 24T) | Category II | 0 |
| `#087` (`9000087`) | The Mahler conjectures, functional inequalities and polar-product symplectic width. | 3 | Yes | ✅ 1 (57L / 6T) | Category II | 0 |
| `#088` (`9000088`) | Sharp projection-body inequalities and a counterexample to simplex maximization. | 2 | Yes | ✅ 1 (548L / 30T) | Category II | 0 |
| `#089` (`9000089`) | Bounded-distortion L1 embeddings of planar and bounded-treewidth graphs. | 2 | Yes | ✅ 1 (964L / 34T) | Category II | 0 |
| `#090` (`9000090`) | Triangular-lattice optimality, long-range Riesz and Coulomb energies, and spherical logarithmic energy. | 4 | Yes | — | Category III | 0 |
| `#091` (`9000091`) | Logarithmic and Lp Brunn–Minkowski inequalities and the B-conjecture. | 1 | Yes | ✅ 1 (215L / 20T) | Category II | 0 |
| `#092` (`9000092`) | The optimal order of convex-body covering density. | 2 | Yes | ✅ 1 (227L / 11T) | Category II | 0 |
| `#093` (`9000093`) | Dimension-free logarithmic Sobolev inequality for subgaussian log-concave measures. | 1 | No | — | Category III | 0 |
| `#094` (`9000094`) | Subpolynomial dimension reduction in Lp. | 1 | Yes | ✅ 1 (362L / 20T) | Category II | 0 |
| `#095` (`9000095`) | Hyperbolicity cones without semidefinite lifts. | 3 | Yes | — | Category III | 0 |
| `#096` (`9000096`) | The Gaussian propeller conjecture in every dimension. | 1 | Yes | ✅ 1 (503L / 31T) | Category II | 0 |
| `#097` (`9000097`) | The Euclidean Steinitz–Bergström bound. | 1 | Yes | ✅ 1 (76L / 8T) | Category II | 0 |
| `#098` (`9000098`) | Compact counterexamples to bi-Lipschitz dimension reduction. | 1 | Yes | ✅ 1 (327L / 13T) | Category II | 0 |
| `#099` (`9000099`) | The sharp exponential scale of edit-distance distortion. | 3 | Yes | ✅ 1 (180L / 15T) | Category II | 0 |
| `#100` (`9000100`) | Cylinder coverings below the half-area bound. | 4 | Yes | ✅ 1 (273L / 15T) | Category II | 0 |
| `#101` (`9000101`) | The sharp simplex conjecture for isotropic constants. | 1 | No | ✅ 1 (397L / 23T) | Category I | 0 |
| `#102` (`9000102`) | The Unique Games Conjecture and optimal approximation thresholds. | 5 | Yes | ✅ 4 (1228L / 68T) | Category II | 0 |
| `#103` (`9000103`) | Exact derandomization of logarithmic space: $`\mathsf L=\mathsf{RL}=\mathsf{BPL}`$. | 1 | Yes | ✅ 1 (458L / 20T) | Category II | 0 |
| `#104` (`9000104`) | Quasipolynomial algorithms for mean-payoff, stochastic and parity games. | 4 | Yes | ✅ 1 (1238L / 75T) | Category II | 0 |
| `#105` (`9000105`) | Perfect completeness for 2-to-1 games. | 1 | Yes | ✅ 1 (134L / 8T) | Category II | 0 |
| `#106` (`9000106`) | Hardness of coloring three-colorable graphs. | 1 | Yes | ✅ 4 (628L / 23T) | Category II | 0 |
| `#107` (`9000107`) | Matrix multiplication with exponent at most 9/4. | 3 | Yes | ✅ 1 (105L / 7T) | Category II | 0 |
| `#108` (`9000108`) | A cubic permanent–determinant lower bound. | 1 | Yes | ✅ 1 (211L / 19T) | Category II | 0 |
| `#109` (`9000109`) | Integer multiplication below $`n\log n`$. | 1 | No | ✅ 1 (160L / 12T) | Category II | 0 |
| `#110` (`9000110`) | Optimal-order randomized k-server on arbitrary metrics. | 2 | Yes | ✅ 1 (151L / 7T) | Category II | 0 |
| `#111` (`9000111`) | One-sample matroid prophet inequalities against an almighty adversary. | 1 | Yes | ✅ 1 (155L / 10T) | Category II | 0 |
| `#112` (`9000112`) | Beyond the square-root exponent for depth-three circuits. | 1 | Yes | ✅ 1 (865L / 53T) | Category II | 0 |
| `#113` (`9000113`) | Approximate counting and entropy of perfect matchings. | 2 | Yes | ✅ 1 (140L / 11T) | Category II | 0 |
| `#114` (`9000114`) | Approximate counting of common integer polymatroid bases. | 2 | Yes | ✅ 3 (3292L / 172T) | Category II | 0 |
| `#115` (`9000115`) | Sampling and counting contingency tables with arbitrary margins. | 2 | Yes | ✅ 1 (1438L / 67T) | Category II | 0 |
| `#116` (`9000116`) | Uniform black-box noncommutative identity testing across characteristics. | 3 | Yes | ✅ 2 (1539L / 58T) | Category II | 0 |
| `#117` (`9000117`) | Uniform sparsest cut: hardness and semidefinite gaps. | 2 | Yes | ✅ 1 (120L / 12T) | Category II | 0 |
| `#118` (`9000118`) | Bin packing and unbounded configuration-LP gaps. | 1 | Yes | ✅ 1 (16195L / 993T) | Category I | 0 |
| `#119` (`9000119`) | The Courtade–Kumar and Hellinger conjectures. | 2 | Yes | ✅ 1 (59L / 4T) | Category II | 0 |
| `#120` (`9000120`) | Almost-linear-time exact matching and prescribed-degree factors in general graphs. | 1 | No | ✅ 1 (260L / 20T) | Category II | 0 |
| `#121` (`9000121`) | Almost-linear approximation of edit distance. | 1 | Yes | ✅ 1 (419L / 29T) | Category I | 0 |
| `#122` (`9000122`) | Quantitative trace-reconstruction bounds with a uniform decoder. | 3 | Yes | ✅ 1 (91L / 13T) | Category II | 0 |
| `#124` (`9000124`) | Polynomial-time scheduling on three identical machines. | 1 | Yes | ✅ 3 (7305L / 384T) | Category II | 0 |
| `#125` (`9000125`) | The metric k-median approximation threshold and recovery. | 2 | Yes | ✅ 1 (222L / 10T) | Category II | 2 (C_REUSE_SHORT) — internal_candidate_or_shortcut_exclusion |
| `#126` (`9000126`) | Exponential semidefinite complexity of perfect matching. | 1 | Yes | ✅ 1 (149L / 11T) | Category II | 0 |
| `#127` (`9000127`) | Average sensitivity of polynomial threshold functions. | 1 | Yes | ✅ 1 (145L / 6T) | Category II | 0 |
| `#128` (`9000128`) | A factor-two approximation for shortest common superstring. | 1 | Yes | ✅ 1 (719L / 48T) | Category I | 0 |
| `#129` (`9000129`) | Exponential state costs for two-way automata. | 2 | Yes | ✅ 1 (902L / 70T) | Category I | 0 |
| `#130` (`9000130`) | Exact Fourier transforms below $`n\log n`$. | 2 | Yes | — | Category III | 0 |
| `#131` (`9000131`) | Rapid mixing of graph switches for every degree sequence. | 1 | Yes | ✅ 1 (16191L / 859T) | Category II | 0 |
| `#132` (`9000132`) | A superquadratic separation of sensitivity and block sensitivity. | 1 | Yes | ✅ 1 (4132L / 231T) | Category II | 0 |
| `#133` (`9000133`) | The computational complexity of Weisfeiler–Leman refinement. | 4 | Yes | ✅ 2 (8090L / 427T) | Category II | 0 |
| `#134` (`9000134`) | Generalized star height at most three. | 3 | Yes | ✅ 1 (1298L / 54T) | Category II | 0 |
| `#135` (`9000135`) | Homogeneous depth-five lower bounds for iterated matrix multiplication. | 1 | Yes | ✅ 1 (511L / 27T) | Category II | 0 |
| `#136` (`9000136`) | A quasilinear PCP theorem for PPAD. | 1 | No | ✅ 1 (121L / 5T) | Category II | 0 |
| `#137` (`9000137`) | One-tape time simulation in two-fifths-power space. | 1 | Yes | ✅ 2 (3848L / 206T) | Category II | 0 |
| `#138` (`9000138`) | Subset Sum in $`O(2^{0.49n})`$ time. | 2 | No | ✅ 1 (48L / 4T) | Category II | 0 |
| `#139` (`9000139`) | Subpolynomial query complexity for log-concave sampling. | 1 | Yes | ✅ 1 (258L / 22T) | Category II | 0 |
| `#140` (`9000140`) | Memory–sample lower bounds for noiseless Gaussian regression. | 6 | Yes | ✅ 1 (934L / 72T) | Category II | 0 |
| `#141` (`9000141`) | Existential–universal real sentences in the counting hierarchy. | 1 | No | ✅ 1 (535L / 42T) | Category II | 0 |
| `#142` (`9000142`) | Deterministic polynomial factorization over prime fields. | 1 | No | ✅ 1 (131L / 11T) | Category II | 0 |
| `#143` (`9000143`) | Hilbert's sixteenth problem: uniform bounds for limit cycles. | 2 | Yes | ✅ 1 (341L / 16T) | Category II | 0 |
| `#144` (`9000144`) | Banach’s simple Lebesgue-spectrum problem. | 1 | Yes | ✅ 1 (136L / 11T) | Category II | 0 |
| `#145` (`9000145`) | Rokhlin’s multiple-mixing problem. | 1 | Yes | ✅ 1 (123L / 5T) | Category II | 2 (C_OP_SOFT_ADMISSIBLE) — internal_candidate_or_shortcut_exclusion |
| `#146` (`9000146`) | Positive metric entropy for the standard map. | 1 | Yes | ✅ 1 (92L / 4T) | Category II | 0 |
| `#147` (`9000147`) | The near-boundary Birkhoff conjecture. | 2 | No | — | Category III | 0 |
| `#148` (`9000148`) | The entropy-rate dimension formula for self-similar measures. | 1 | Yes | ✅ 3 (2300L / 96T) | Category II | 0 |
| `#149` (`9000149`) | Classwise permanence for weakly reversible mass-action systems. | 2 | Yes | ✅ 2 (2950L / 125T) | Category II | 0 |
| `#150` (`9000150`) | Weak mixing of triangular billiards with an irrational angle. | 2 | Yes | ✅ 1 (114L / 7T) | Category II | 0 |
| `#151` (`9000151`) | A C1 counterexample to the entropy conjecture. | 1 | Yes | ✅ 2 (931L / 66T) | Category II | 0 |
| `#152` (`9000152`) | Zero entropy does not guarantee a smooth positive-volume model. | 1 | Yes | — | Category III | 0 |
| `#153` (`9000153`) | Arithmetic classification and non-Pisot singularity for Bernoulli convolutions. | 1 | No | ✅ 1 (167L / 14T) | Category II | 0 |
| `#154` (`9000154`) | Pointwise multiple ergodic averages for mixing transformations. | 4 | No | ✅ 1 (207L / 13T) | Category II | 0 |
| `#155` (`9000155`) | A counterexample to periodic tiling in dimension three. | 1 | Yes | ✅ 1 (606L / 19T) | Category II | 0 |
| `#156` (`9000156`) | Borsuk's conjecture fails in dimension nine. | 1 | Yes | ✅ 1 (346954L / 32135T) | Category II | 0 |
| `#157` (`9000157`) | Graph coloring, clique minors, and Colin de Verdière invariants. | 3 | Yes | ✅ 3 (3072L / 111T) | Category II | 0 |
| `#158` (`9000158`) | The Euclidean plane cannot be colored with five colors. | 1 | Yes | ✅ 1 (13L / 1T) | Category II | 0 |
| `#159` (`9000159`) | Erdős’s reciprocal-sum conjecture and quasipolynomial Szemerédi bounds. | 1 | Yes | ✅ 1 (81L / 6T) | Category II | 0 |
| `#160` (`9000160`) | Superexponential van der Waerden numbers. | 1 | Yes | ✅ 1 (219L / 17T) | Category II | 0 |
| `#161` (`9000161`) | Counterexamples to Sidorenko’s conjecture and the forcing conjecture. | 1 | Yes | — | Category III | 0 |
| `#162` (`9000162`) | Counterexamples to Ryser’s covering conjecture. | 2 | Yes | ✅ 2 (272L / 16T) | Category II | 0 |
| `#164` (`9000164`) | Hindman’s finite sums and products conjecture. | 1 | No | ✅ 1 (110L / 10T) | Category II | 0 |
| `#165` (`9000165`) | The Harary–Hill and Zarankiewicz crossing-number formulas. | 2 | Yes | ✅ 1 (251L / 21T) | Category II | 0 |
| `#166` (`9000166`) | The higher-dimensional Erdős distinct-distances conjecture. | 1 | No | ✅ 1 (50L / 2T) | Category II | 0 |
| `#167` (`9000167`) | Planar distinct distances and unit-distance bounds. | 2 | Yes | ✅ 1 (230L / 9T) | Category II | 0 |
| `#168` (`9000168`) | Combinatorial invariance of Kazhdan–Lusztig polynomials. | 1 | Yes | ✅ 1 (88L / 2T) | Category II | 0 |
| `#169` (`9000169`) | Shareshian–Wachs elementary positivity. | 1 | Yes | ✅ 1 (58L / 4T) | Category I | 0 |
| `#170` (`9000170`) | Sharp logarithmic exponents for off-diagonal Ramsey numbers. | 2 | Yes | ✅ 1 (92L / 9T) | Category II | 0 |
| `#171` (`9000171`) | The hypercube Ramsey conjecture. | 1 | No | ✅ 1 (89L / 5T) | Category II | 0 |
| `#172` (`9000172`) | Classification of finite Euclidean Ramsey configurations. | 1 | Yes | ✅ 2 (1383L / 68T) | Category II | 0 |
| `#173` (`9000173`) | Seymour’s second-neighborhood conjecture. | 1 | Yes | ✅ 1 (259L / 7T) | Category I | 0 |
| `#174` (`9000174`) | Deterministic construction of strong thin spanning trees. | 2 | Yes | ✅ 2 (777L / 41T) | Category II | 0 |
| `#175` (`9000175`) | Talagrand’s expectation thresholds, discrete convexity, and graph decompositions. | 3 | Yes | ✅ 1 (552L / 24T) | Category I | 0 |
| `#176` (`9000176`) | The second Kahn–Kalai conjecture with an edge-count bound. | 1 | Yes | ✅ 1 (1814L / 103T) | Category II | 0 |
| `#177` (`9000177`) | Bounded-degree coboundary expanders. | 1 | Yes | ✅ 1 (141L / 7T) | Category II | 0 |
| `#178` (`9000178`) | Deterministic nonbipartite Ramanujan graphs in every fixed degree. | 1 | No | ✅ 1 (47L / 1T) | Category II | 0 |
| `#179` (`9000179`) | The circulant Hadamard and Barker-sequence conjectures. | 1 | Yes | ✅ 3 (340L / 10T) | Category I | 0 |
| `#180` (`9000180`) | Barnette’s Hamiltonian-cycle conjecture. | 1 | Yes | ✅ 1 (176L / 12T) | Category II | 1 (C180_INTEGRAL) — internal_candidate_or_shortcut_exclusion |
| `#181` (`9000181`) | The Erdős–Gallai cycle-decomposition conjecture. | 1 | Yes | ✅ 1 (551L / 22T) | Category II | 0 |
| `#182` (`9000182`) | Power savings for intersective polynomial differences and prime arguments. | 3 | Yes | ✅ 1 (222L / 20T) | Category II | 0 |
| `#183` (`9000183`) | Power savings for planar halving lines and k-sets. | 1 | Yes | ✅ 1 (1661L / 78T) | Category II | 0 |
| `#184` (`9000184`) | Correspondence coloring with a fixed forbidden subgraph. | 2 | Yes | ✅ 1 (127L / 8T) | Category I | 0 |
| `#185` (`9000185`) | Counterexamples to infinite matroid intersection and packing/covering. | 1 | Yes | ✅ 2 (565L / 46T) | Category II | 0 |
| `#186` (`9000186`) | Uniform influence and sharp thresholds for graph and hypergraph properties. | 2 | Yes | ✅ 2 (405L / 16T) | Category I | 0 |
| `#187` (`9000187`) | Snaky in 21 Maker moves. | 1 | Yes | ✅ 1 (1405L / 32T) | Category II | 0 |
| `#188` (`9000188`) | The sharp terminal leave in random triangle removal. | 1 | Yes | ✅ 1 (104L / 6T) | Category II | 0 |
| `#189` (`9000189`) | Cycle–clique Ramsey numbers. | 1 | Yes | ✅ 2 (292L / 21T) | Category II | 0 |
| `#190` (`9000190`) | Polynomial removal fails for ordered binary matrices. | 1 | Yes | ✅ 1 (164L / 18T) | Category II | 0 |
| `#191` (`9000191`) | A power improvement in the Heilbronn triangle lower bound. | 1 | Yes | ✅ 1 (518L / 17T) | Category II | 0 |
| `#192` (`9000192`) | Boolean functions violate the square-root degree bound by arbitrary factors. | 1 | Yes | ✅ 1 (125L / 9T) | Category II | 0 |
| `#193` (`9000193`) | Serre’s intersection-multiplicity conjecture. | 1 | No | ✅ 1 (75L / 6T) | Category II | 0 |
| `#194` (`9000194`) | Lech’s multiplicity conjecture. | 1 | Yes | ✅ 1 (98L / 5T) | Category II | 0 |
| `#195` (`9000195`) | A counterexample to the small Cohen–Macaulay module conjecture. | 1 | Yes | ✅ 2 (361L / 28T) | Category II | 0 |
| `#196` (`9000196`) | A counterexample to Kaplansky’s zero-divisor conjecture. | 1 | Yes | ✅ 2 (476L / 26T) | Category II | 0 |
| `#197` (`9000197`) | A torsion-free group algebra that is not directly finite. | 4 | Yes | ✅ 1 (111L / 4T) | Category II | 0 |
| `#198` (`9000198`) | A counterexample to finitistic-dimension finiteness. | 1 | Yes | ✅ 1 (1578L / 108T) | Category II | 0 |
| `#199` (`9000199`) | Counterexamples to Auslander–Reiten, Tachikawa and related homological conjectures. | 2 | Yes | ✅ 1 (154L / 5T) | Category I | 0 |
| `#200` (`9000200`) | Eisenbud–Green–Harris and lex-plus-powers. | 2 | No | ✅ 1 (75L / 4T) | Category II | 0 |
| `#201` (`9000201`) | A counterexample to Kurosh’s division-ring problem. | 1 | No | ✅ 3 (391L / 17T) | Category II | 0 |
| `#202` (`9000202`) | The blockwise Alperin weight conjecture. | 1 | No | ✅ 1 (105L / 7T) | Category II | 0 |
| `#203` (`9000203`) | Donovan's conjecture over fields and complete mixed-characteristic DVRs. | 2 | No | — | Category III | 0 |
| `#204` (`9000204`) | Tensor saturation for even spin groups. | 1 | No | ✅ 1 (167L / 11T) | Category II | 0 |
| `#205` (`9000205`) | Saxl’s conjecture and universal tensor squares. | 2 | Yes | ✅ 1 (310L / 30T) | Category II | 0 |
| `#206` (`9000206`) | Finite lattice representation and undecidability. | 2 | Yes | ✅ 1 (158L / 12T) | Category II | 2 (C_BC_IDENTICAL_DIGITS) — internal_candidate_or_shortcut_exclusion |
| `#207` (`9000207`) | The ℓ¹-Bass conjecture for all discrete groups. | 2 | Yes | ✅ 1 (150L / 14T) | Category II | 0 |
| `#208` (`9000208`) | Finite symmetric tensor categories and the Verlinde tower. | 1 | No | ✅ 1 (225L / 11T) | Category II | 0 |
| `#209` (`9000209`) | Integral counterexamples to Gersten’s conjecture. | 2 | No | ✅ 1 (66L / 8T) | Category II | 0 |
| `#210` (`9000210`) | Foulkes' conjecture for sixth powers and quadratic stabilization. | 2 | Yes | ✅ 1 (128L / 5T) | Category II | 0 |
| `#211` (`9000211`) | The geometric phase diagram, diffusion, and spectra of random planar maps. | 7 | Yes | ✅ 1 (68L / 3T) | Category II | 0 |
| `#212` (`9000212`) | Planar first-passage geometry and the absence of bigeodesics. | 2 | Yes | ✅ 1 (512L / 25T) | Category II | 0 |
| `#213` (`9000213`) | Critical percolation on every quasi-transitive graph. | 2 | Yes | ✅ 1 (85L / 4T) | Category I | 0 |
| `#214` (`9000214`) | The Benjamini–Schramm nonuniqueness conjecture. | 1 | Yes | ✅ 1 (920L / 56T) | Category II | 0 |
| `#215` (`9000215`) | Canonical $`O(3)`$ continuum limit and exact $`O(4)`$ mass asymptotics. | 5 | Yes | ✅ 1 (108L / 11T) | Category II | 0 |
| `#216` (`9000216`) | Critical and near-critical XY scaling and BKT universality. | 6 | No | ✅ 1 (121L / 7T) | Category II | 0 |
| `#217` (`9000217`) | The low-temperature Sherrington–Kirkpatrick fluctuation law. | 2 | No | ✅ 1 (98L / 8T) | Category II | 0 |
| `#218` (`9000218`) | Conformal universality for weakly interacting and random-bond Ising models. | 6 | Yes | ✅ 1 (776L / 55T) | Category II | 0 |
| `#219` (`9000219`) | GOE bulk universality for regular graphs with weak Anderson disorder. | 2 | No | ✅ 2 (408L / 40T) | Category II | 0 |
| `#220` (`9000220`) | Directional zero–one laws beyond iid environments and iid ballisticity. | 3 | Yes | ✅ 1 (174L / 12T) | Category II | 0 |
| `#221` (`9000221`) | The Mézard–Parisi formula for diluted spin glasses. | 1 | Yes | ✅ 1 (408L / 26T) | Category I | 0 |
| `#222` (`9000222`) | Perceptron free energies and microscopic jamming exponents. | 4 | Yes | — | Category III | 0 |
| `#223` (`9000223`) | Random-cluster interfaces: critical, disordered, thermal, and natural-time scaling. | 6 | No | ✅ 1 (441L / 28T) | Category I | 0 |
| `#224` (`9000224`) | Critical and quenched near-critical universality for Poisson–Voronoi percolation. | 3 | No | ✅ 1 (106L / 7T) | Category II | 0 |
| `#225` (`9000225`) | Gaussian free field limits throughout the balanced six-vertex regime. | 1 | No | ✅ 1 (36L / 4T) | Category II | 0 |
| `#226` (`9000226`) | The double-dimer loop ensemble converges to CLE4. | 1 | No | ✅ 1 (201L / 16T) | Category II | 0 |
| `#227` (`9000227`) | Critical SK autocorrelation processes and dynamics across the temperature transition. | 8 | Yes | ✅ 1 (111L / 13T) | Category II | 0 |
| `#228` (`9000228`) | Continuum phase transitions for radial pair potentials. | 2 | Yes | ✅ 1 (164L / 7T) | Category I | 0 |
| `#229` (`9000229`) | Exact three- and four-state reconstruction thresholds and four-state tree capacity. | 3 | Yes | ✅ 1 (111L / 11T) | Category II | 0 |
| `#230` (`9000230`) | Exact Hausdorff gauges for SLE. | 2 | Yes | ✅ 1 (110L / 5T) | Category II | 0 |
| `#231` (`9000231`) | The free uniform spanning forest is a factor of IID. | 1 | Yes | ✅ 1 (194L / 15T) | Category II | 0 |
| `#232` (`9000232`) | Gaussian fields and interfaces for triangular-lattice Lipschitz heights. | 3 | No | — | Category III | 0 |
| `#233` (`9000233`) | The joint critical Ashkin–Teller current limit. | 1 | No | — | Category III | 0 |
| `#234` (`9000234`) | All-temperature pressure of orthogonally invariant Ising spin glasses. | 1 | Yes | ✅ 1 (98L / 8T) | Category II | 0 |
| `#235` (`9000235`) | Limiting random SAT thresholds, sharp variance and computability. | 4 | Yes | ✅ 1 (101L / 7T) | Category II | 0 |
| `#236` (`9000236`) | The exact factor-of-IID threshold for free Ising spins on trees. | 1 | Yes | ✅ 1 (96L / 7T) | Category II | 0 |
| `#237` (`9000237`) | The three-quarter exponent for honeycomb self-avoiding walk. | 13 | Yes | ✅ 1 (79L / 4T) | Category II | 0 |
| `#238` (`9000238`) | Optimal logarithmic mixing of the Thorp shuffle. | 12 | Yes | ✅ 1 (89L / 6T) | Category II | 0 |
| `#239` (`9000239`) | Sharp singularity rates for symmetric random sign matrices. | 2 | No | ✅ 1 (121L / 9T) | Category II | 0 |
| `#240` (`9000240`) | Shelah's eventual categoricity and the prescribed-threshold obstruction. | 2 | Yes | ✅ 1 (177L / 12T) | Category II | 0 |
| `#241` (`9000241`) | Rigidity of the Turing degrees. | 1 | Yes | ✅ 1 (1215L / 51T) | Category II | 0 |
| `#242` (`9000242`) | Single-fold Diophantine representations and undecidability under an at-most-one-solution promise. | 1 | Yes | ✅ 1 (1674L / 52T) | Category II | 0 |
| `#243` (`9000243`) | Separating choiceless counting from polynomial time and witnessed choice. | 2 | Yes | — | Category III | 0 |
| `#244` (`9000244`) | The Partition Principle does not imply Choice. | 1 | Yes | ✅ 2 (1502L / 97T) | Category I | 0 |
| `#245` (`9000245`) | Weak normalization implies strong normalization in pure type systems. | 1 | Yes | ✅ 2 (1096L / 65T) | Category II | 0 |
| `#246` (`9000246`) | Cannon's conjecture. | 1 | Yes | ✅ 1 (230L / 4T) | Category II | 0 |
| `#247` (`9000247`) | An infinite finitely presented residually finite 2-group and a finitely presented nil algebra. | 2 | Yes | ✅ 1 (175L / 9T) | Category II | 2 (F_BOUNDARY_CURSOR_ROLLBACK_WITHOUT_LEFT_ENDPOINT) — manuscript_scope_erratum |
| `#248` (`9000248`) | Thompson's group F is nonamenable. | 1 | Yes | ✅ 1 (124L / 4T) | Category II | 0 |
| `#249` (`9000249`) | A finitely generated Eilenberg–Ganea counterexample. | 1 | Yes | ✅ 1 (505L / 25T) | Category II | 0 |
| `#250` (`9000250`) | Boone–Higman embeddings with higher finiteness. | 3 | Yes | ✅ 4 (1709L / 93T) | Category II | 0 |
| `#251` (`9000251`) | Amenability, unitarizability, and strong Ulam stability. | 2 | Yes | ✅ 1 (122L / 9T) | Category II | 0 |
| `#252` (`9000252`) | A torsion-free hyperbolic group that is neither residually finite nor linear over any field. | 1 | Yes | ✅ 1 (347L / 25T) | Category I | 0 |
| `#253` (`9000253`) | An infinite finitely presented simple amenable group. | 1 | Yes | ✅ 1 (97L / 6T) | Category II | 2 (C_RANK_SHORTCUT) — internal_candidate_or_shortcut_exclusion |
| `#254` (`9000254`) | Classifying spaces and geometric obstructions for Artin groups. | 3 | Yes | ✅ 1 (237L / 9T) | Category II | 0 |
| `#255` (`9000255`) | Quasi-isometric recognition of virtually polycyclic groups. | 1 | Yes | — | Category III | 0 |
| `#256` (`9000256`) | Nonsingular systems of equations over arbitrary groups. | 2 | Yes | ✅ 1 (169L / 12T) | Category II | 0 |
| `#257` (`9000257`) | A hyperbolic group without a geometric CAT(0) action. | 1 | Yes | ✅ 1 (858L / 39T) | Category II | 0 |
| `#258` (`9000258`) | Gersten’s conjecture and virtual compact specialness of one-relator groups. | 2 | No | ✅ 1 (119L / 6T) | Category II | 0 |
| `#259` (`9000259`) | A group without fixed price. | 1 | No | ✅ 2 (697L / 33T) | Category II | 0 |
| `#260` (`9000260`) | Spacetime Penrose inequalities: enclosing area, charge, rotation, and anti-de Sitter extensions. | 13 | Yes | ✅ 1 (371L / 11T) | Category I | 0 |
| `#261` (`9000261`) | Localization and delocalization in the Anderson model. | 2 | Yes | ✅ 1 (63L / 5T) | Category I | 0 |
| `#262` (`9000262`) | Sharp finite-matrix Lieb–Thirring inequalities and all equality cases. | 3 | Yes | ✅ 1 (160L / 9T) | Category II | 0 |
| `#263` (`9000263`) | The ionization and generalized ionization conjectures. | 3 | Yes | — | Category III | 0 |
| `#264` (`9000264`) | Strong cosmic censorship near two-ended Kerr data. | 3 | No | ✅ 1 (109L / 6T) | Category II | 0 |
| `#265` (`9000265`) | Area laws and tensor networks for two-dimensional gapped systems. | 2 | No | ✅ 1 (58L / 5T) | Category II | 0 |
| `#266` (`9000266`) | Exactly three mutually unbiased bases in dimension six. | 2 | Yes | ✅ 1 (87L / 6T) | Category II | 0 |
| `#267` (`9000267`) | Positive-temperature Bose–Einstein condensation and exact quantum depletion. | 5 | Yes | ✅ 1 (178L / 6T) | Category II | 0 |
| `#268` (`9000268`) | The spin-one Haldane gap. | 2 | No | ✅ 1 (84L / 7T) | Category II | 0 |
| `#269` (`9000269`) | Uniform Laughlin gap and stability under bounded scalar disorder. | 2 | Yes | ✅ 1 (58L / 4T) | Category II | 0 |
| `#270` (`9000270`) | Threshold and positive-energy bound states of the BFSS matrix model. | 2 | No | — | Category III | 0 |
| `#271` (`9000271`) | Bloch's law, its lattice correction, and the spherical magnetization law. | 4 | Yes | ✅ 1 (328L / 21T) | Category II | 0 |
| `#272` (`9000272`) | Entanglement without distillable secret key. | 1 | Yes | ✅ 1 (121L / 5T) | Category II | 0 |
| `#273` (`9000273`) | The entropy photon-number inequality. | 1 | Yes | ✅ 1 (107L / 7T) | Category II | 0 |
| `#274` (`9000274`) | Parity is not in QAC0. | 2 | Yes | ✅ 1 (88L / 8T) | Category II | 2 (C_SCALAR_INDEP) — internal_candidate_or_shortcut_exclusion |
| `#275` (`9000275`) | QMA-hardness of continuum Coulomb energy. | 2 | Yes | ✅ 1 (81L / 7T) | Category II | 0 |
| `#276` (`9000276`) | Classical capacity of generalized amplitude damping. | 1 | Yes | ✅ 1 (602L / 32T) | Category II | 0 |
| `#277` (`9000277`) | Threshold repetition for entangled games. | 1 | Yes | ✅ 1 (805L / 36T) | Category II | 0 |
| `#278` (`9000278`) | Failure of Kohn–Sham ensemble representation. | 1 | No | — | Category III | 0 |
| `#279` (`9000279`) | Exact quantum factoring over a fixed finite gate set. | 1 | Yes | ✅ 1 (108L / 9T) | Category II | 0 |
| `#280` (`9000280`) | Unitary vertex operator algebras and conformal nets. | 1 | Yes | ✅ 1 (202L / 8T) | Category II | 0 |
| `#281` (`9000281`) | QAOA attains the SK optimum in the thermodynamic-first limit. | 2 | Yes | ✅ 1 (114L / 12T) | Category II | 0 |
| `#282` (`9000282`) | From scale symmetry to local conformal symmetry in four-dimensional QFT. | 1 | No | — | Category III | 2 (C_PREMISE_OBSTRUCTION) — internal_candidate_or_shortcut_exclusion |
| `#283` (`9000283`) | Polynomial-time unitary synthesis from a Boolean oracle. | 1 | No | ✅ 1 (550L / 26T) | Category II | 0 |
| `#284` (`9000284`) | The optimal quartic separation between randomized and quantum queries. | 1 | No | ✅ 1 (319L / 12T) | Category II | 0 |
| `#285` (`9000285`) | Counterexamples to Baum–Connes and Kadison–Kaplansky. | 3 | No | — | Category III | 0 |
| `#286` (`9000286`) | Rigidity and arithmetic of lattice von Neumann algebras. | 2 | No | ✅ 1 (76L / 5T) | Category II | 0 |
| `#287` (`9000287`) | Isomorphism of the free group factors. | 1 | Yes | ✅ 1 (84L / 6T) | Category II | 0 |
| `#288` (`9000288`) | Kadison's similarity conjecture. | 1 | Yes | ✅ 1 (208L / 15T) | Category II | 0 |
| `#289` (`9000289`) | Strong Kadison–Kastler stability and its spatial boundaries. | 3 | Yes | ✅ 1 (126L / 12T) | Category II | 0 |
| `#290` (`9000290`) | Relative bicentralizers and modular spectral recovery. | 2 | Yes | ✅ 1 (177L / 12T) | Category II | 0 |
| `#291` (`9000291`) | Cuntz comparison, nuclear dimension, and equivariant Jiang–Su stability. | 4 | Yes | ✅ 1 (143L / 7T) | Category II | 0 |
| `#292` (`9000292`) | Kirchberg's $`\mathcal O_2`$ norm-ultrapower embedding problem. | 1 | Yes | — | Category III | 0 |
| `#293` (`9000293`) | Invariant projections, hyperinvariant subspaces, and transitive algebras. | 2 | Yes | ✅ 1 (540L / 34T) | Category II | 0 |
| `#294` (`9000294`) | Kaplansky's quasitrace conjecture and failure of tensor-product stable finiteness. | 1 | Yes | ✅ 1 (12L / 1T) | Category II | 0 |
| `#295` (`9000295`) | The Kadison–Ringrose cohomology conjecture. | 1 | Yes | ✅ 1 (276L / 20T) | Category II | 0 |
| `#296` (`9000296`) | The generator problem for finite factors. | 1 | Yes | ✅ 1 (245L / 12T) | Category II | 0 |
| `#297` (`9000297`) | A ZFC counterexample to Naimark's problem. | 1 | Yes | ✅ 1 (106L / 7T) | Category II | 0 |
| `#298` (`9000298`) | Two notions of free entropy differ even when both are finite. | 1 | Yes | ✅ 1 (70L / 3T) | Category II | 0 |
| `#299` (`9000299`) | The Kirchberg–Rørdam character criterion and infinite tensor-power Jiang–Su stability. | 1 | Yes | ✅ 1 (371L / 35T) | Category II | 0 |
| `#300` (`9000300`) | Approximation and quadratic strong-operator paving. | 2 | No | ✅ 1 (921L / 45T) | Category II | 0 |
| `#301` (`9000301`) | Trace cones and Razak–Jacelon stabilization. | 1 | Yes | ✅ 1 (64L / 5T) | Category II | 0 |
| `#302` (`9000302`) | Radius of comparison equals half the mean dimension. | 2 | No | ✅ 1 (117L / 9T) | Category II | 0 |
| `#303` (`9000303`) | Weak pure infiniteness and Cuntz-algebra absorption. | 1 | Yes | ✅ 1 (157L / 10T) | Category II | 0 |
| `#304` (`9000304`) | The Hilbert–Smith conjecture in every dimension. | 1 | No | ✅ 1 (83L / 2T) | Category II | 0 |
| `#305` (`9000305`) | Four-dimensional disk embedding and Wall's conjecture. | 3 | No | — | Category III | 0 |
| `#306` (`9000306`) | The purely cosmetic surgery conjecture. | 1 | No | ✅ 2 (443L / 49T) | Category II | 0 |
| `#307` (`9000307`) | Failure of rational injectivity for maximal coarse assembly. | 2 | Yes | ✅ 1 (165L / 13T) | Category II | 0 |
| `#308` (`9000308`) | Finite Smith–Toda complexes at every height. | 2 | No | ✅ 1 (816L / 38T) | Category II | 0 |
| `#309` (`9000309`) | The Kervaire invariant problem at the prime three. | 1 | No | — | Category III | 0 |
| `#310` (`9000310`) | Quillen's conjecture in rational homology. | 1 | No | ✅ 1 (115L / 6T) | Category II | 0 |
| `#311` (`9000311`) | The Hovey–Strickland and Chai conjectures. | 1 | No | ✅ 1 (116L / 5T) | Category II | 0 |
| `#312` (`9000312`) | The Grothendieck homotopy hypothesis. | 1 | Yes | ✅ 1 (236L / 12T) | Category II | 0 |
| `#313` (`9000313`) | Finite generation for the $`K(n)`$-local sphere. | 1 | No | — | Category III | 0 |
| `#314` (`9000314`) | Cyclic length and chromatic fixed-point loss. | 1 | No | ✅ 1 (204L / 11T) | Category I | 0 |
| `#315` (`9000315`) | The four-dimensional Singer conjecture. | 1 | No | ✅ 1 (183L / 8T) | Category II | 0 |
| `#316` (`9000316`) | Curtis’s conjecture. | 1 | No | ✅ 1 (109L / 7T) | Category II | 0 |
| `#317` (`9000317`) | Thomason model structures in all strict higher dimensions. | 1 | Yes | ✅ 1 (140L / 7T) | Category II | 0 |
| `#318` (`9000318`) | Chromatic splitting: filtrations and counterexamples. | 5 | No | ✅ 10 (1029L / 76T) | Category II | 15 (C318EXTCD, C318FORGETACTION, C318GHOST2, C318LEVEL3, C318LEVELGE3, C318QGHOST, C318TAUZERO, FIN-DISPLAYS) — internal_candidate_and_proof_by_contradiction_targets |
| `#319` (`9000319`) | Counterexamples to finite generation at chromatic height two. | 1 | No | — | Category III | 0 |
| `#320` (`9000320`) | Nonhomeomorphic closed aspherical four-manifolds. | 1 | No | ✅ 1 (128L / 9T) | Category II | 2 (F_MT_NILPOTENT_LOCATOR) — manuscript_citation_locator_erratum |
| `#321` (`9000321`) | A counterexample to Wall's finite D(2) problem. | 1 | No | ✅ 3 (2959L / 200T) | Category II | 0 |
| `#322` (`9000322`) | Tingley’s sphere-isometry problem. | 1 | Yes | ✅ 1 (604L / 36T) | Category I | 0 |
| `#323` (`9000323`) | Independence of the separable quotient problem. | 1 | Yes | ✅ 2 (488L / 33T) | Category II | 0 |
| `#324` (`9000324`) | Lipschitz equivalent Banach spaces need not be linearly isomorphic. | 2 | Yes | ✅ 1 (71L / 4T) | Category II | 0 |
| `#325` (`9000325`) | The complete Crouzeix conjecture. | 2 | Yes | ✅ 1 (316L / 17T) | Category II | 0 |
| `#326` (`9000326`) | The cotype–cotype conjecture under the approximation property. | 1 | Yes | ✅ 1 (270L / 20T) | Category II | 0 |
| `#327` (`9000327`) | Markov type characterizes superreflexivity. | 1 | Yes | ✅ 4 (292L / 22T) | Category II | 0 |
| `#328` (`9000328`) | Nonexpansive fixed points in reflexive Banach spaces. | 1 | Yes | ✅ 3 (2071L / 79T) | Category II | 0 |
| `#329` (`9000329`) | A counterexample to metric-entropy duality. | 1 | Yes | ✅ 1 (1415L / 86T) | Category II | 0 |
| `#330` (`9000330`) | A uniformly discrete counterexample to bounded approximation in Lipschitz-free spaces. | 1 | Yes | ✅ 2 (863L / 40T) | Category II | 0 |
| `#331` (`9000331`) | Reflexive midpoint convexity and diamond distortion. | 7 | Yes | ✅ 1 (108L / 16T) | Category II | 4 (C_BAD_LATTICE, C_BAD_SCALAR) — internal_candidate_or_shortcut_exclusion |
| `#332` (`9000332`) | Metric Markov cotype of ℓ1 and Hilbert-space Lipschitz extension. | 1 | No | ✅ 1 (166L / 9T) | Category II | 0 |
| `#333` (`9000333`) | Smooth isometric immersions of surfaces into ℝ4. | 1 | Yes | ✅ 1 (87L / 7T) | Category II | 0 |
| `#334` (`9000334`) | A smooth surface metric with no local isometric immersion in ℝ3. | 1 | Yes | ✅ 1 (74L / 10T) | Category I | 0 |
| `#335` (`9000335`) | Gromov’s integral scalar-curvature bound for simplicial volume. | 2 | No | ✅ 1 (146L / 5T) | Category II | 0 |
| `#336` (`9000336`) | Spectral scalar curvature, Urysohn width, and macroscopic dimension. | 3 | No | ✅ 1 (192L / 33T) | Category II | 0 |
| `#337` (`9000337`) | Sharp Cartan–Hadamard isoperimetry and rigidity. | 1 | Yes | ✅ 1 (66L / 5T) | Category II | 0 |
| `#338` (`9000338`) | Yau's uniformization conjecture. | 1 | No | ✅ 1 (75L / 6T) | Category II | 0 |
| `#339` (`9000339`) | Katok's entropy rigidity conjecture. | 1 | No | ✅ 1 (187L / 9T) | Category II | 0 |
| `#340` (`9000340`) | A counterexample to the nearby Lagrangian conjecture. | 1 | No | ✅ 1 (29L / 2T) | Category II | 0 |
| `#341` (`9000341`) | Donaldson's hypersymplectic deformation conjecture. | 1 | No | ✅ 1 (148L / 15T) | Category II | 0 |
| `#342` (`9000342`) | Donaldson's tamed-to-compatible conjecture. | 1 | Yes | ✅ 1 (112L / 13T) | Category II | 10 (F_EXTERNAL_COR14, F_EXTERNAL_PROP39, F_EXTERNAL_THM13, F_EXTERNAL_THM37, F_EXTERNAL_THM37_DISJOINTNESS) — external_literature_counterexample |
| `#343` (`9000343`) | Symplectic ball packing in higher dimensions. | 1 | Yes | ✅ 1 (34L / 2T) | Category II | 0 |
| `#344` (`9000344`) | The metric Blaschke conjecture. | 1 | No | ✅ 1 (25L / 2T) | Category II | 0 |
| `#345` (`9000345`) | Infinitely many closed geodesics on Riemannian spheres and closed three-manifolds. | 1 | No | ✅ 1 (631L / 37T) | Category II | 0 |
| `#346` (`9000346`) | Sharp singular-set bounds for stationary integral varifolds. | 2 | No | ✅ 1 (65L / 3T) | Category II | 0 |
| `#347` (`9000347`) | Counterexamples to stable-Morse and strong Arnold fixed-point bounds. | 5 | Yes | ✅ 1 (202L / 22T) | Category II | 0 |
| `#348` (`9000348`) | Nonnegative-curvature Einstein classification and an L2 topological gap. | 3 | Yes | — | Category III | 0 |
| `#349` (`9000349`) | The Solomon–Yau least-volume conjecture. | 1 | No | ✅ 1 (415L / 36T) | Category II | 0 |
| `#350` (`9000350`) | Yau’s nodal bounds: surfaces and higher dimensions. | 3 | Yes | — | Category III | 0 |
| `#351` (`9000351`) | Scalar curvature and finite-time Ricci-flow singularities. | 3 | No | — | Category III | 2 (C_HD_OMISSION) — internal_candidate_or_shortcut_exclusion |
| `#352` (`9000352`) | A finite-time singularity of Calabi flow. | 1 | No | — | Category III | 0 |
| `#353` (`9000353`) | Affine Bernstein rigidity through dimension nine and a smooth dimension-ten counterexample. | 2 | Yes | ✅ 1 (179L / 8T) | Category II | 0 |
| `#354` (`9000354`) | The isoperimetric profile of the cubic three-torus. | 1 | Yes | ✅ 1 (124L / 4T) | Category II | 0 |
| `#355` (`9000355`) | Unique tangent flows at the first surface singularity. | 1 | No | ✅ 1 (206L / 13T) | Category II | 0 |
| `#356` (`9000356`) | Gigli’s characterization of Alexandrov curvature. | 2 | Yes | ✅ 1 (66L / 6T) | Category II | 0 |
| `#357` (`9000357`) | Bi-Lipschitz coordinates at every regular RCD point. | 1 | No | — | Category III | 0 |
| `#358` (`9000358`) | A three-manifold without conjugate points or nonpositive curvature. | 1 | Yes | — | Category III | 0 |
| `#359` (`9000359`) | Negative Kähler curvature without bounded holomorphic coordinates. | 2 | Yes | ✅ 1 (175L / 11T) | Category II | 0 |
| `#360` (`9000360`) | Weak MTW curvature gives convexity and regular optimal transport. | 2 | Yes | ✅ 2 (1129L / 45T) | Category II | 0 |
| `#361` (`9000361`) | Failure of integer-degree harmonic dimension comparison. | 2 | Yes | ✅ 1 (86L / 3T) | Category II | 0 |
| `#362` (`9000362`) | Global smoothness for relativistic Vlasov–Maxwell. | 1 | Yes | ✅ 1 (115L / 3T) | Category II | 0 |
| `#363` (`9000363`) | Nonuniqueness with local conservation for the hard-sphere Boltzmann equation. | 2 | Yes | ✅ 1 (92L / 8T) | Category II | 0 |
| `#364` (`9000364`) | Kinetic limits and fluctuations over the Boltzmann lifespan. | 2 | No | ✅ 2 (363L / 29T) | Category II | 0 |
| `#365` (`9000365`) | Joint metric and connection recovery from one boundary patch. | 3 | Yes | — | Category III | 0 |
| `#366` (`9000366`) | The planar Mumford–Shah regularity conjecture and local weak-L4 gradient bounds. | 1 | No | — | Category III | 0 |
| `#367` (`9000367`) | The critical dimension for the one-phase Bernoulli problem. | 1 | Yes | ✅ 1 (61L / 4T) | Category II | 0 |
| `#368` (`9000368`) | The three-dimensional Ball–Evans approximation problem. | 2 | No | ✅ 1 (84L / 5T) | Category II | 0 |
| `#369` (`9000369`) | The hot spots conjecture for simply connected planar domains. | 1 | Yes | ✅ 1 (127L / 7T) | Category I | 0 |
| `#370` (`9000370`) | The Lane–Emden and Hénon–Lane–Emden conjectures. | 1 | Yes | ✅ 1 (65L / 4T) | Category II | 0 |
| `#371` (`9000371`) | Stable blowup for the defocusing Schrödinger equation. | 1 | Yes | — | Category III | 0 |
| `#372` (`9000372`) | Global uniqueness in smooth isotropic elasticity. | 1 | Yes | ✅ 1 (147L / 8T) | Category II | 0 |
| `#373` (`9000373`) | Nonattainment of the three-marginal Coulomb Monge problem. | 1 | Yes | ✅ 1 (116L / 4T) | Category II | 0 |
| `#374` (`9000374`) | Sharp one-third stability of Brenier maps. | 1 | Yes | ✅ 2 (606L / 36T) | Category I | 0 |
| `#375` (`9000375`) | De Giorgi's conjecture in dimension eight. | 1 | No | — | Category III | 0 |
| `#376` (`9000376`) | Universal computation in forced Navier–Stokes flows. | 9 | Yes | ✅ 1 (320L / 33T) | Category II | 2 (A_RAPID_ONTO_SLOWDOWN) — internal_candidate_or_shortcut_exclusion |
| `#377` (`9000377`) | Interior $`C^{1,\alpha}`$ regularity for infinity-harmonic functions. | 1 | No | — | Category III | 0 |
| `#378` (`9000378`) | Disproof of the Exponential Time Hypothesis. | 1 | Yes | ✅ 1 (212L / 17T) | Category I | 0 |

</details>
