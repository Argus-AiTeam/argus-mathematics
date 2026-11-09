# 用 Argus 核验 OpenAI 数学论文集

## 摘要

- **Argus 做了什么。** 第一轮是探索性工作，每个家族各跑一个 Argus campaign，共 373 个。这一轮**不是逐篇审查**：只要某个家族积累了足够的证据记录，调度器就判它"完成"。之后开始对第一轮成果做系统复核，目前**373 个家族里有 54 个**已经审完并通过验收。
- **OpenAI 论文的错误。** 逐条对照原文核对后，**没有确认 OpenAI 任何一篇论文有数学错误**。找到的只有 3 处小问题：一个引理编号写错、一个 DOI 失效、一处措辞在某种读法下缺了前提（见 §2）。
- **有价值的部分。** 在已审的 54 个家族里，**38 个至少有一项对 OpenAI 原文结论的改进得到审查支持**，包括更好的常数或指数、更弱的假设、推广，以及与之匹配的锐性例子。另外 16 个家族独立确认了 OpenAI 的结果。这 38 个里大约三分之一分量不大；最强的几项列在 §3。
- **Lean。** Argus 在 314 个家族中写了 384 份 Lean 4.31.0 证书，都有编译通过的记录，没有 `sorry`，也没有标准公理以外的公理。其中 Argus 原创、去重后的代码**约 12 万行**（见 §4）。
- **前提。** 目前所有验收都由 Argus 自己的 AI Reviewer 完成，没有经过人类专家审核；也没有任何一项查过文献、核实是否为新结果。

## 1. 范围与成本

| | |
| :--- | :--- |
| 上游论文集 | `4eaee875` 版本：373 个家族、721 篇在架论文；3 篇撤稿不在范围内 |
| 第一轮（探索性） | 373 个 campaign，约 32.1 亿 tokens，按供应商计量 **$1,861.55** |
| OpenAI 论文集相关工作累计 | 约 62.7 亿 tokens，**$3,477.03**（截至 2026-11-09 07:21 UTC） |
| 系统复核 | 54/373 个家族通过 Argus AI Reviewer 验收（进行中） |

成本是按供应商 token 计量折算的美元等值，属于已知下界：有 14 次报错的调用没有 token 明细。

## 2. 在 OpenAI 论文中发现的问题

| 家族 | 位置（`preprints/…`） | 问题 | 严重程度 |
| :--- | :--- | :--- | :--- |
| `320` | `Nonhomeomorphic-closed-aspherical-four-manifolds-with-the-same-homotopy-type-October-4-2026/build/sections/formal.tex:785` | 引用 `[MT, Lemma 3.9]`，MT 中对应的结果实际是 Lemma 6.7（"Correction over the full parameter algebra"）。该机制在第 786–793 行有完整复述 | 引用编号笔误，没有数学漏洞 |
| `318` | `Filtered-chromatic-splitting-at-generic-primes-…/build/references.bib:430–438` | Zink《The display of a formal p-divisible group》的 DOI `10.24033/ast.534` 无法解析（HTTP 404） | 参考文献笔误 |
| `247` | `An-infinite-finitely-presented-periodic-group-September-23-2026/build/sections/finite-rules.tex:575–581` | "A boundary-cursor region can always be released inside its acquired interval"：如果把单字母截断词尾区域（位于 `C(2),B`）也算进去，这句话不成立。实际用到它的地方（第 962–1001 行）从 `C(1)` 开始，不受影响 | 某种读法下措辞缺少前提；不影响主定理 |

**OpenAI 自己撤回的论文。** OpenAI 于 2026-10-07 宣布撤回以下三篇：
- "Algebraicity of Weil classes on split abelian eightfolds"
- "Algebraicity of Kuga–Satake Correspondences for K3 Surfaces"
- "The rational Hodge conjecture for products of K3 surfaces"

撤回原因是第一篇里有一个符号错误（`I_new = I(f_1) − m = −2m ≠ 0`），导致一个稳定化迹抵消论证失效，另外两篇用到了这个论证。OpenAI 说明撤回的是证明，并不是说结论为假。这个错误不是 Argus 发现的。

**Li–Zhang 锥等式（`342`）。** Li–Zhang《Comparing tamed and compatible symplectic cones…》（Comm. Anal. Geom. 17 (2009)）的 Corollary 1.1（arXiv:0708.2520v4 中为 Corollary 1.4）断言：在存在相容辛形式的四维近复流形上，`K^t = K^c + H^-`。Theorem 1.1 和 Proposition 3.1（v4 中为 Theorem 1.3、Proposition 3.9）也有同样的说法。
- **OpenAI 9 月 23 日版**《Taming implies compatibility on four-manifolds》引用这条推论，得出 `K^t = K^c + H^-`。
- **10 月 6 日修订版**改用自己证明的锥描述：只在 `h^- = b_2^+ − 1` 时等式成立，并指出即使 `H^- = 0`，包含关系也可以是严格的，还给出了 `T^4` 上的显式例子（`ex:strict-cones`）。OpenAI 的 `history.md` 记为"更正了锥等式的说法，补充了一个严格包含的例子"。OpenAI 没有明确说 Li–Zhang 的命题是错的。
- **Argus 补充的工作：**
  - 核验了 OpenAI 的这个例子（精确符号计算，核心部分有 Lean 证明）。
  - 直接验证该例子满足 Li–Zhang 的全部前提（`C^∞`-full，相容锥非空），因此它确实是 Li–Zhang 这三个已发表命题的反例。
  - 把 arXiv 版和正式发表版的编号一一对上。
  - 找到了出错的具体一步：Theorem 3.4（v4 中为 Theorem 3.7）证明里的"不相交"论断，并用闭流的一个显式正投影否定了它。
- **没有被推翻的：** `b^+ = 1` 的特例。
- **归属与现状：** 反例是 OpenAI 构造的。文献里是否早有人指出这个问题，还没有查；这个家族也还没有进入系统复核。

## 3. 审查支持的成果：对 OpenAI 原文结论的改进

下表各项都在所注条件下通过了 Argus AI Reviewer 验收，但都没有经过人类专家审核，也没有查过文献、核实是否为新结果。部分证明只有文字论证。审查报告尚未在本仓库发布。

| 家族 | 主题 | 相对原文结论的改进 |
| :--- | :--- | :--- |
| `071` | Koebe 圆域 | 障碍系数从 8（预算 `4m`）改进到任意 `κ>1`（预算 `κm`）。另有显式环形构造说明系数小于 1 一定不行，所以这个常数是最优的 |
| `028` | 高斯素数上的游走 | 矩形引理从 `C·e^{-c d³ r}` 改进到 `3·e^{-d² r/32}`，指数中去掉了一个 `d` 因子 |
| `026` | 大素数间隙 | 误差项从 `O(L^{-t-1/2}(log L)^A)` 改进到 `O(L^{-t-1}(log L)^A)` |
| `025` | 短埃及分数 | 原文只处理固定阶 `r`；这里对所有 `r ≤ log S/(200000 log log S)` 给出统一阈值，上界部分有 Lean 证明。另构造一族素数阶乘例子，说明当 `r` 达到 `C log S/log log S`（任意 `C>1/2`）时结论失效，从而把增长阶确定到只差常数 |
| `055` | 五次三维簇上的 Gepner 稳定性 | 比较半径从 `1/200000` 扩大到 `1/4000`；原文只说"存在某个常数"的地方全部给出了显式常数；参数范围 `0<u<13/46` 对所给判据是最优的。范畴论部分是带条件的文字论证 |
| `039` | Seshadri 常数 | 重塑条件从 `dw<1/16` 放宽到 `dw<1/3`；结论从同阶 jet 满射加强到所有混合阶 jet 秩都能传递 |
| `015` | 环面包 | 在奇素数处给出更紧的局部壳界，并构造显式例子说明奇局部指数是锐的；两个 profile 不等式从 `G_0^{24}` 改进到 `G^3` |
| `046` | Shafarevich 反例 | 原文只构造了 `n=4` 的情形，这里推广到所有 `n=2^r`（`r≥2`） |
| `049` | 稳定坐标 | 理想恒等式在任意交换环上、对任意 `t` 都成立（原文只在域上处理了一个特定的 `t`）；刚性命题也推广到原文那个特定 `W` 之外 |
| `068` | 反典范线性系 | 用"局部 klt 型"取代原文的环面假设；证明修正区域是精确的，并给出锐性例子族 |
| `072` | Brennan 型积分均值 | 仿射输运链从 `p=1,2` 推广到一般 `p`；刚性障碍从 `k=3/4` 推广到所有 `k`。均为带条件的文字论证 |
| `048` | 切层自由的曲面 | 在原文 `p_g ≥ 33` 的基础上补出上界，得到 `33 ≤ p_g ≤ 39`，并给出精确的秩公式 |
| `009` | Milnor K 理论重构 | 一个命题去掉了有限 p-秩假设；直线恢复推广到所有有限 p-次数的特征 `p` 域，包括 `p=2`。两者都有 Lean 证明 |
| `021` | Jacobsthal 函数 | 界从原文写的 `O(d⁴(…))` 改进到 `O(d³(1+S^{2/3}))`。审查指出，原文自己的证明其实已经蕴含这个结果 |
| `022` | Duffin–Schaeffer | 在原文约定的假设下，有向混合误差从 `O(W)` 改进到 `O(W²)` |

其余有改进的已审家族：`012, 013, 014, 017, 018, 023, 024, 031, 033, 036, 037, 038, 042, 044, 051, 056, 063, 065, 066, 067, 073, 076, 078`。其中不少分量不大：有的只是把常数写明确，有的只改进了中间步骤，有的依赖尚未确立的前提。

**第一轮中尚未复核的候选。** 早先抽读时还发现了下面几项：
- `176`：分离常数从 16 降到 3，Lean 可以编译通过；见 [结果包](../results/openai-audit-theorems/9000176/)。
- `113`：编码原像界从 `(10N)^{30}` 降到 `2^{17}N^8`；见 [结果包](../results/openai-audit-theorems/9000113/)。
- `074`：双色匹配下界，并给出锐性；见 [结果包](../results/openai-audit-theorems/9000074/)。
- `164`：粗糙步长降到多项式尺度；见 [结果包](../results/openai-audit-theorems/9000164/)。
- `130`：把 `h=100` 换成 `h=25`，幂次节省间隙扩大约 1,650 倍。

在系统复核审到这些家族之前，它们只算候选。

## 4. Lean 证书

| 项目 | 数值 |
| :--- | :--- |
| 证书数 / 家族数 | 384 / 314 |
| 记录的总行数 | 520,223（所有证书行数的原始加总） |
| 其中 `156` | 346,954 行：机器生成、经 Lean 内核检查的 UNSAT 证明重放，证明的是有限的 10 标签障碍（`TenLabel.no_model`）。应计为**一项**有限障碍证明 |
| 其中从 OpenAI 自己的 Lean 移植的 | 约 52,000 行。例如 `118`、`131`、`149` 都有 95% 以上与上游代码相同，它们各自的说明文件也写明了这一点 |
| `156` 以外 Argus 原创的去重代码 | **约 120,000 行** |
| 检查记录 | 每份证书都记录了 `exit_code 0`，没有 `sorry`/`admit`，公理只用到 `propext`、`Classical.choice`、`Quot.sound` |
| 2026-11-09 重新编译 | 抽了 12 份：10 份通过；另外 2 份引用了 OpenAI 的 `OAI` 库，需要先把该库加入路径 |
| 本仓库已发布 | 23 个家族，见 [`results/openai-audit-theorems/`](../results/openai-audit-theorems/) |

每份证书只验证论证中划定好的一个核心引理，范围写在各自的 `statement_fidelity.md` 里，没有一份是对整篇论文的端到端形式化。按原始声明计数共 41,764 个定理，其中 32,135 个是 `156` 的推导步骤引理，因此这个数字没有参考意义。

有分量的例子（Argus 原创行数）：
- `321` Wall D(2) 问题的 Fox 微积分挠率：2,029 行
- `003` 行列式与整范数链：2,796 行
- `124` 调度协议提取：8,016 行
- `176` Kahn–Kalai 路径归约：1,814 行
- `242` Pell 方程与幂的完备性：1,674 行

## 5. 局限

- **审查者。** 验收方是 Argus 自己的 AI Reviewer，它也会出错，仍需要人类专家审核。
- **新颖性。** 没有任何一项改进查过文献、核实是否为新结果。
- **覆盖面。** 还有 319 个家族没有复核；它们在第一轮里的自我评估不能算作发现。
- **公开程度。** 审查报告和大部分 Lean 源码尚未在本仓库发布。

## 附录：各家族状态（373 个在架家族）

Lean 数据截至 2026-11-09。"原创行数"不计与 OpenAI 上游 Lean 相同的行，同一个源文件只计一次。

| 家族 | 标题 | 论文数 | Argus Lean（证书数 / 原创行数） | 审查状态 |
| :--- | :--- | :---: | :---: | :--- |
| `001` | Milne’s rationality conjecture and algebraic specialization. | 1 | 1 / 41 | 已审：独立确认 |
| `002` | The full BSD formula from low Selmer corank. | 3 | 1 / 193 | 未审 |
| `003` | The quasi-Riemann hypothesis. | 3 | 2 / 2,672 | 未审 |
| `004` | Hilbert’s tenth problem over ℚ. | 2 | 2 / 245 | 已审：独立确认 |
| `005` | Irrationality of Catalan’s constant. | 1 | 1 / 104 | 未审 |
| `006` | Goldfeld’s conjecture: densities and mean analytic rank. | 2 | 1 / 539 | 已审：独立确认 |
| `007` | Ordinary two-point correlations and the corrected Elliott conjecture. | 1 | 1 / 156 | 未审 |
| `008` | The Deligne–Drinfeld conjecture. | 1 | 1 / 38 | 已审：独立确认 |
| `009` | Function-field reconstruction from Milnor K-theory and Galois data. | 3 | 2 / 2,270 | 已审：有改进 |
| `010` | Unrestricted pro-modularity at the prime two. | 3 | 1 / 67 | 未审 |
| `011` | Prime-factor statistics of $`p-1`$. | 3 | 2 / 173 | 未审 |
| `012` | Independent largest prime factors of consecutive integers. | 1 | 1 / 211 | 已审：有改进 |
| `013` | Ostmann’s inverse Goldbach conjecture. | 1 | 1 / 114 | 已审：有改进 |
| `014` | Restricted geometric Langlands, global Arthur enhancements, and generic Ramanujan. | 8 | — | 已审：有改进 |
| `015` | Torus-packet equidistribution in prime, quartic, and sextic degrees. | 3 | — | 已审：有改进 |
| `016` | Zilber–Pink in abelian varieties and the Siegel threefold. | 4 | 1 / 84 | 未审 |
| `017` | The irrationality exponent of <i>π</i> is 2. | 1 | 1 / 157 | 已审：有改进 |
| `018` | The Margulis–Platonov conjecture over global fields. | 2 | 1 / 299 | 已审：有改进 |
| `019` | The local <i>p</i>-adic section conjecture and global consequences. | 2 | 1 / 59 | 已审：独立确认 |
| `020` | Squarefree quartics and power-free polynomial values. | 1 | 1 / 160 | 已审：独立确认 |
| `021` | A quadratic bound for Jacobsthal’s function. | 1 | 1 / 320 | 已审：有改进 |
| `022` | The weak inhomogeneous Duffin–Schaeffer conjecture. | 1 | 1 / 460 | 已审：有改进 |
| `023` | Patterson's first moment for cubic Gauss sums. | 1 | 1 / 284 | 已审：有改进 |
| `024` | An asymptotic formula for the number of totients. | 1 | 1 / 137 | 已审：有改进 |
| `025` | Short Egyptian fractions. | 1 | 2 / 413 | 已审：有改进 |
| `026` | Positive lower density of large prime gaps. | 1 | 1 / 72 | 已审：有改进 |
| `027` | Potential integral density on curve character varieties. | 1 | 1 / 112 | 未审 |
| `028` | Uniformly bounded components of Gaussian-prime graphs. | 1 | — | 已审：有改进 |
| `029` | Primitive roots for every admissible integer base. | 2 | — | 已审：独立确认 |
| `030` | Modularity of elliptic curves over imaginary quadratic fields. | 1 | 1 / 154 | 已审：独立确认 |
| `031` | Uchida’s conjecture for open homomorphisms of Galois groups. | 1 | — | 已审：有改进 |
| `032` | The rational Hodge conjecture for CM abelian varieties. | 5 | — | 已审：独立确认 |
| `033` | Iitaka subadditivity, variation, and logarithmic additivity. | 5 | — | 已审：有改进 |
| `034` | Log abundance for compact Kähler spaces under logarithmic Iitaka subadditivity. | 14 | — | 未审 |
| `035` | Log-canonical threefold abundance in numerical dimension one. | 2 | 1 / 242 | 未审 |
| `036` | Numerical semiampleness and generalized minimal models. | 4 | 1 / 295 | 已审：有改进 |
| `037` | The ordinary-double-point volume gap. | 2 | 1 / 54 | 已审：有改进 |
| `038` | Fujita’s freeness conjecture. | 1 | 1 / 245 | 已审：有改进 |
| `039` | Nagata’s conjecture and maximal Seshadri constants. | 4 | 1 / 120 | 已审：有改进 |
| `040` | Bloch’s conjecture for complex surfaces. | 1 | — | 已审：独立确认 |
| `041` | Hyperkähler SYZ and projective-space bases. | 2 | 1 / 203 | 已审：独立确认 |
| `042` | Oka classification for minimal compact complex surfaces: Kodaira dimension zero and class VII. | 1 | — | 已审：有改进 |
| `043` | <i>P</i> = <i>W</i> for fixed-determinant SL<sub><i>n</i></sub> moduli spaces. | 1 | — | 已审：独立确认 |
| `044` | The equivariant cohomological Hikita conjecture. | 1 | 1 / 77 | 已审：有改进 |
| `046` | Shafarevich counterexamples in dimension two and with large fundamental group. | 2 | 1 / 60 | 已审：有改进 |
| `047` | Zariski cancellation and affine fibrations over the complex numbers. | 1 | 1 / 155 | 未审 |
| `048` | A characteristic-zero counterexample to Lipman–Zariski. | 1 | — | 已审：有改进 |
| `049` | A stable-coordinate counterexample in four variables. | 2 | 1 / 136 | 已审：有改进 |
| `050` | A counterexample to Griffiths’ positivity conjecture. | 1 | — | 未审 |
| `051` | Kobayashi’s canonical-ampleness conjecture. | 1 | — | 已审：有改进 |
| `052` | Tangent splittings and product decompositions. | 2 | 1 / 198 | 未审 |
| `053` | A counterexample to Pixton completeness in Chow. | 1 | 2 / 131 | 未审 |
| `054` | Irrational cubic fourfolds with Hodge-theoretic and categorical K3 associations. | 1 | 1 / 138 | 未审 |
| `055` | Gepner symmetry and large-volume stability on threefolds. | 2 | 1 / 198 | 已审：有改进 |
| `056` | Termination of projective and Kähler fourfold minimal model programs. | 5 | — | 已审：有改进 |
| `057` | Fundamental groups of special complex varieties and root orbifolds. | 3 | 1 / 76 | 已审：独立确认 |
| `058` | Semialgebraic universal covers and bounded domains. | 2 | — | 未审 |
| `059` | Counterexamples to Zariski’s multiplicity conjecture. | 2 | — | 未审 |
| `060` | The Global Spherical Shell conjecture. | 1 | — | 未审 |
| `062` | Projective contact classification and the LeBrun–Salamon conjecture. | 1 | 1 / 41 | 已审：独立确认 |
| `063` | The generalized Mukai conjecture. | 1 | — | 已审：有改进 |
| `064` | Topological triviality of <i>μ</i>-constant surface singularities. | 1 | — | 已审：独立确认 |
| `065` | Virasoro constraints for complete intersections and projective-bundle towers. | 2 | 1 / 77 | 已审：有改进 |
| `066` | Bounded klt complements for Fano contractions. | 2 | 1 / 67 | 已审：有改进 |
| `067` | The Campana–Peternell conjecture in dimension six. | 1 | — | 已审：有改进 |
| `068` | Anticanonical nonvanishing in every dimension. | 7 | 1 / 111 | 已审：有改进 |
| `069` | Global quantum geometric Langlands at irrational level. | 1 | — | 未审 |
| `071` | Koebe’s circle-domain conjecture. | 2 | 1 / 44 | 已审：有改进 |
| `072` | Brennan's conjecture and the integral-means spectrum. | 2 | 1 / 115 | 已审：有改进 |
| `073` | The Falconer distance conjecture. | 1 | 1 / 1,113 | 已审：有改进 |
| `074` | Kakeya in three and four dimensions. | 2 | 1 / 97 | 未审 |
| `075` | The $`L\log L`$ Fourier-convergence conjecture. | 1 | 1 / 670 | 已审：独立确认 |
| `076` | Real ultraflat Littlewood polynomials and unbounded binary merit factors. | 3 | 1 / 120 | 已审：有改进 |
| `077` | Fourier restriction for positively curved surfaces. | 2 | — | 未审 |
| `078` | The three-dimensional Bochner–Riesz conjecture. | 1 | 1 / 122 | 已审：有改进 |
| `079` | Local smoothing for the Euclidean wave equation. | 2 | 1 / 97 | 未审 |
| `080` | The exact Sobolev endpoint for Schrödinger convergence. | 2 | 1 / 88 | 未审 |
| `081` | Riesz transforms and rectifiability in higher codimension. | 1 | 1 / 66 | 未审 |
| `082` | Annular variation and dyadic absolute bounds for the triangular Hilbert transform. | 3 | 1 / 95 | 未审 |
| `083` | Hilbert transforms along Lipschitz directions. | 1 | 1 / 181 | 未审 |
| `084` | The geometric case of the Erdős similarity conjecture. | 2 | 1 / 774 | 未审 |
| `085` | Endpoint Sobolev regularity of centered disk averages. | 1 | 1 / 305 | 未审 |
| `086` | An <i>L</i><sup>3</sup> bound for the trilinear Hilbert transform. | 1 | 2 / 158 | 未审 |
| `087` | The Mahler conjectures, functional inequalities and polar-product symplectic width. | 3 | 1 / 55 | 未审 |
| `088` | Sharp projection-body inequalities and a counterexample to simplex maximization. | 2 | 1 / 532 | 未审 |
| `089` | Bounded-distortion <i>L</i><sub>1</sub> embeddings of planar and bounded-treewidth graphs. | 2 | 1 / 957 | 未审 |
| `090` | Triangular-lattice optimality, long-range Riesz and Coulomb energies, and spherical logarithmic energy. | 4 | — | 未审 |
| `091` | Logarithmic and <i>L</i><sub><i>p</i></sub> Brunn–Minkowski inequalities and the B-conjecture. | 1 | 1 / 204 | 未审 |
| `092` | The optimal order of convex-body covering density. | 2 | 1 / 218 | 未审 |
| `093` | Dimension-free logarithmic Sobolev inequality for subgaussian log-concave measures. | 1 | — | 未审 |
| `094` | Subpolynomial dimension reduction in <i>L</i><sub><i>p</i></sub>. | 1 | 1 / 336 | 未审 |
| `095` | Hyperbolicity cones without semidefinite lifts. | 3 | — | 未审 |
| `096` | The Gaussian propeller conjecture in every dimension. | 1 | 1 / 490 | 未审 |
| `097` | The Euclidean Steinitz–Bergström bound. | 1 | 1 / 76 | 未审 |
| `098` | Compact counterexamples to bi-Lipschitz dimension reduction. | 1 | 1 / 302 | 未审 |
| `099` | The sharp exponential scale of edit-distance distortion. | 3 | 1 / 176 | 未审 |
| `100` | Cylinder coverings below the half-area bound. | 4 | 1 / 253 | 未审 |
| `101` | The sharp simplex conjecture for isotropic constants. | 1 | 1 / 385 | 未审 |
| `102` | The Unique Games Conjecture and optimal approximation thresholds. | 5 | 4 / 1,172 | 未审 |
| `103` | Exact derandomization of logarithmic space: $`\mathsf L=\mathsf{RL}=\mathsf{BPL}`$. | 1 | 1 / 443 | 未审 |
| `104` | Quasipolynomial algorithms for mean-payoff, stochastic and parity games. | 4 | 1 / 1,229 | 未审 |
| `105` | Perfect completeness for 2-to-1 games. | 1 | 1 / 130 | 未审 |
| `106` | Hardness of coloring three-colorable graphs. | 1 | 4 / 594 | 未审 |
| `107` | Matrix multiplication with exponent at most 9/4. | 3 | 1 / 96 | 未审 |
| `108` | A cubic permanent–determinant lower bound. | 1 | 1 / 209 | 未审 |
| `109` | Integer multiplication below $`n\log n`$. | 1 | 1 / 141 | 未审 |
| `110` | Optimal-order randomized <i>k</i>-server on arbitrary metrics. | 2 | 1 / 145 | 未审 |
| `111` | One-sample matroid prophet inequalities against an almighty adversary. | 1 | 1 / 98 | 未审 |
| `112` | Beyond the square-root exponent for depth-three circuits. | 1 | 1 / 823 | 未审 |
| `113` | Approximate counting and entropy of perfect matchings. | 2 | 1 / 127 | 未审 |
| `114` | Approximate counting of common integer polymatroid bases. | 2 | 3 / 3,219 | 未审 |
| `115` | Sampling and counting contingency tables with arbitrary margins. | 2 | 1 / 1,383 | 未审 |
| `116` | Uniform black-box noncommutative identity testing across characteristics. | 3 | 2 / 1,483 | 未审 |
| `117` | Uniform sparsest cut: hardness and semidefinite gaps. | 2 | 1 / 120 | 未审 |
| `118` | Bin packing and unbounded configuration-LP gaps. | 1 | 1 / 712 | 未审 |
| `119` | The Courtade–Kumar and Hellinger conjectures. | 2 | 1 / 59 | 未审 |
| `120` | Almost-linear-time exact matching and prescribed-degree factors in general graphs. | 1 | 1 / 251 | 未审 |
| `121` | Almost-linear approximation of edit distance. | 1 | 1 / 406 | 未审 |
| `122` | Quantitative trace-reconstruction bounds with a uniform decoder. | 3 | 1 / 91 | 未审 |
| `124` | Polynomial-time scheduling on three identical machines. | 1 | 6 / 21,357 | 未审 |
| `125` | The metric <i>k</i>-median approximation threshold and recovery. | 2 | 1 / 215 | 未审 |
| `126` | Exponential semidefinite complexity of perfect matching. | 1 | 1 / 142 | 未审 |
| `127` | Average sensitivity of polynomial threshold functions. | 1 | 1 / 141 | 未审 |
| `128` | A factor-two approximation for shortest common superstring. | 1 | 1 / 706 | 未审 |
| `129` | Exponential state costs for two-way automata. | 2 | 1 / 884 | 未审 |
| `130` | Exact Fourier transforms below $`n\log n`$. | 2 | — | 未审 |
| `131` | Rapid mixing of graph switches for every degree sequence. | 1 | 1 / 566 | 未审 |
| `132` | A superquadratic separation of sensitivity and block sensitivity. | 1 | 1 / 756 | 未审 |
| `133` | The computational complexity of Weisfeiler–Leman refinement. | 4 | 2 / 2,421 | 未审 |
| `134` | Generalized star height at most three. | 3 | 1 / 1,268 | 未审 |
| `135` | Homogeneous depth-five lower bounds for iterated matrix multiplication. | 1 | 1 / 493 | 未审 |
| `136` | A quasilinear PCP theorem for PPAD. | 1 | 1 / 117 | 未审 |
| `137` | One-tape time simulation in two-fifths-power space. | 1 | 2 / 3,807 | 未审 |
| `138` | Subset Sum in $`O(2^{0.49n})`$ time. | 2 | 1 / 46 | 未审 |
| `139` | Subpolynomial query complexity for log-concave sampling. | 1 | 1 / 256 | 未审 |
| `140` | Memory–sample lower bounds for noiseless Gaussian regression. | 6 | 1 / 862 | 未审 |
| `141` | Existential–universal real sentences in the counting hierarchy. | 1 | 1 / 511 | 未审 |
| `142` | Deterministic polynomial factorization over prime fields. | 1 | 1 / 122 | 未审 |
| `143` | Hilbert's sixteenth problem: uniform bounds for limit cycles. | 2 | 1 / 331 | 未审 |
| `144` | Banach’s simple Lebesgue-spectrum problem. | 1 | 1 / 132 | 未审 |
| `145` | Rokhlin’s multiple-mixing problem. | 1 | 1 / 112 | 未审 |
| `146` | Positive metric entropy for the standard map. | 1 | 1 / 92 | 未审 |
| `147` | The near-boundary Birkhoff conjecture. | 2 | — | 未审 |
| `148` | The entropy-rate dimension formula for self-similar measures. | 1 | 3 / 858 | 未审 |
| `149` | Classwise permanence for weakly reversible mass-action systems. | 2 | 2 / 320 | 未审 |
| `150` | Weak mixing of triangular billiards with an irrational angle. | 2 | 1 / 112 | 未审 |
| `151` | A <i>C</i><sup>1</sup> counterexample to the entropy conjecture. | 1 | 2 / 892 | 未审 |
| `152` | Zero entropy does not guarantee a smooth positive-volume model. | 1 | — | 未审 |
| `153` | Arithmetic classification and non-Pisot singularity for Bernoulli convolutions. | 1 | 1 / 167 | 未审 |
| `154` | Pointwise multiple ergodic averages for mixing transformations. | 4 | 1 / 202 | 未审 |
| `155` | A counterexample to periodic tiling in dimension three. | 1 | 1 / 604 | 未审 |
| `156` | Borsuk's conjecture fails in dimension nine. | 1 | 1 / 346,954（机器生成的 SAT 证明重放） | 未审 |
| `157` | Graph coloring, clique minors, and Colin de Verdière invariants. | 3 | 3 / 3,007 | 未审 |
| `158` | The Euclidean plane cannot be colored with five colors. | 1 | 1 / 10 | 未审 |
| `159` | Erdős’s reciprocal-sum conjecture and quasipolynomial Szemerédi bounds. | 1 | 1 / 81 | 未审 |
| `160` | Superexponential van der Waerden numbers. | 1 | 1 / 215 | 未审 |
| `161` | Counterexamples to Sidorenko’s conjecture and the forcing conjecture. | 1 | — | 未审 |
| `162` | Counterexamples to Ryser’s covering conjecture. | 2 | 2 / 249 | 未审 |
| `164` | Hindman’s finite sums and products conjecture. | 1 | 1 / 107 | 未审 |
| `165` | The Harary–Hill and Zarankiewicz crossing-number formulas. | 2 | 1 / 236 | 未审 |
| `166` | The higher-dimensional Erdős distinct-distances conjecture. | 1 | 1 / 42 | 未审 |
| `167` | Planar distinct distances and unit-distance bounds. | 2 | 1 / 221 | 未审 |
| `168` | Combinatorial invariance of Kazhdan–Lusztig polynomials. | 1 | 1 / 85 | 未审 |
| `169` | Shareshian–Wachs elementary positivity. | 1 | 1 / 53 | 未审 |
| `170` | Sharp logarithmic exponents for off-diagonal Ramsey numbers. | 2 | 1 / 89 | 未审 |
| `171` | The hypercube Ramsey conjecture. | 1 | 1 / 83 | 未审 |
| `172` | Classification of finite Euclidean Ramsey configurations. | 1 | 2 / 1,347 | 未审 |
| `173` | Seymour’s second-neighborhood conjecture. | 1 | 1 / 245 | 未审 |
| `174` | Deterministic construction of strong thin spanning trees. | 2 | 2 / 451 | 未审 |
| `175` | Talagrand’s expectation thresholds, discrete convexity, and graph decompositions. | 3 | 1 / 519 | 未审 |
| `176` | The second Kahn–Kalai conjecture with an edge-count bound. | 1 | 1 / 1,723 | 未审 |
| `177` | Bounded-degree coboundary expanders. | 1 | 1 / 141 | 未审 |
| `178` | Deterministic nonbipartite Ramanujan graphs in every fixed degree. | 1 | 1 / 45 | 未审 |
| `179` | The circulant Hadamard and Barker-sequence conjectures. | 1 | 3 / 294 | 未审 |
| `180` | Barnette’s Hamiltonian-cycle conjecture. | 1 | 1 / 170 | 未审 |
| `181` | The Erdős–Gallai cycle-decomposition conjecture. | 1 | 1 / 530 | 未审 |
| `182` | Power savings for intersective polynomial differences and prime arguments. | 3 | 1 / 206 | 未审 |
| `183` | Power savings for planar halving lines and <i>k</i>-sets. | 1 | 1 / 1,582 | 未审 |
| `184` | Correspondence coloring with a fixed forbidden subgraph. | 2 | 1 / 123 | 未审 |
| `185` | Counterexamples to infinite matroid intersection and packing/covering. | 1 | 2 / 547 | 未审 |
| `186` | Uniform influence and sharp thresholds for graph and hypergraph properties. | 2 | 2 / 384 | 未审 |
| `187` | Snaky in 21 Maker moves. | 1 | 1 / 1,341 | 未审 |
| `188` | The sharp terminal leave in random triangle removal. | 1 | 1 / 102 | 未审 |
| `189` | Cycle–clique Ramsey numbers. | 1 | 2 / 265 | 未审 |
| `190` | Polynomial removal fails for ordered binary matrices. | 1 | 1 / 162 | 未审 |
| `191` | A power improvement in the Heilbronn triangle lower bound. | 1 | 1 / 387 | 未审 |
| `192` | Boolean functions violate the square-root degree bound by arbitrary factors. | 1 | 1 / 120 | 未审 |
| `193` | Serre’s intersection-multiplicity conjecture. | 1 | 1 / 68 | 未审 |
| `194` | Lech’s multiplicity conjecture. | 1 | 1 / 93 | 未审 |
| `195` | A counterexample to the small Cohen–Macaulay module conjecture. | 1 | 2 / 201 | 未审 |
| `196` | A counterexample to Kaplansky’s zero-divisor conjecture. | 1 | 2 / 459 | 未审 |
| `197` | A torsion-free group algebra that is not directly finite. | 4 | 1 / 101 | 未审 |
| `198` | A counterexample to finitistic-dimension finiteness. | 1 | 1 / 1,543 | 未审 |
| `199` | Counterexamples to Auslander–Reiten, Tachikawa and related homological conjectures. | 2 | 1 / 142 | 未审 |
| `200` | Eisenbud–Green–Harris and lex-plus-powers. | 2 | 1 / 62 | 未审 |
| `201` | A counterexample to Kurosh’s division-ring problem. | 1 | 3 / 360 | 未审 |
| `202` | The blockwise Alperin weight conjecture. | 1 | 1 / 102 | 未审 |
| `203` | Donovan's conjecture over fields and complete mixed-characteristic DVRs. | 2 | — | 未审 |
| `204` | Tensor saturation for even spin groups. | 1 | 1 / 162 | 未审 |
| `205` | Saxl’s conjecture and universal tensor squares. | 2 | 1 / 305 | 未审 |
| `206` | Finite lattice representation and undecidability. | 2 | 1 / 152 | 未审 |
| `207` | The ℓ¹-Bass conjecture for all discrete groups. | 2 | 1 / 141 | 未审 |
| `208` | Finite symmetric tensor categories and the Verlinde tower. | 1 | 1 / 221 | 未审 |
| `209` | Integral counterexamples to Gersten’s conjecture. | 2 | — | 未审 |
| `210` | Foulkes' conjecture for sixth powers and quadratic stabilization. | 2 | 1 / 118 | 未审 |
| `211` | The geometric phase diagram, diffusion, and spectra of random planar maps. | 7 | 1 / 62 | 未审 |
| `212` | Planar first-passage geometry and the absence of bigeodesics. | 2 | 1 / 502 | 未审 |
| `213` | Critical percolation on every quasi-transitive graph. | 2 | 1 / 83 | 未审 |
| `214` | The Benjamini–Schramm nonuniqueness conjecture. | 1 | 1 / 913 | 未审 |
| `215` | Canonical $`O(3)`$ continuum limit and exact $`O(4)`$ mass asymptotics. | 5 | 1 / 106 | 未审 |
| `216` | Critical and near-critical XY scaling and BKT universality. | 6 | 1 / 118 | 未审 |
| `217` | The low-temperature Sherrington–Kirkpatrick fluctuation law. | 2 | 1 / 98 | 未审 |
| `218` | Conformal universality for weakly interacting and random-bond Ising models. | 6 | 1 / 753 | 未审 |
| `219` | GOE bulk universality for regular graphs with weak Anderson disorder. | 2 | 2 / 202 | 未审 |
| `220` | Directional zero–one laws beyond iid environments and iid ballisticity. | 3 | 1 / 167 | 未审 |
| `221` | The Mézard–Parisi formula for diluted spin glasses. | 1 | 1 / 392 | 未审 |
| `222` | Perceptron free energies and microscopic jamming exponents. | 4 | — | 未审 |
| `223` | Random-cluster interfaces: critical, disordered, thermal, and natural-time scaling. | 6 | 1 / 425 | 未审 |
| `224` | Critical and quenched near-critical universality for Poisson–Voronoi percolation. | 3 | 1 / 102 | 未审 |
| `225` | Gaussian free field limits throughout the balanced six-vertex regime. | 1 | 1 / 33 | 未审 |
| `226` | The double-dimer loop ensemble converges to CLE<sub>4</sub>. | 1 | 1 / 198 | 未审 |
| `227` | Critical SK autocorrelation processes and dynamics across the temperature transition. | 8 | 1 / 106 | 未审 |
| `228` | Continuum phase transitions for radial pair potentials. | 2 | 1 / 158 | 未审 |
| `229` | Exact three- and four-state reconstruction thresholds and four-state tree capacity. | 3 | 1 / 108 | 未审 |
| `230` | Exact Hausdorff gauges for SLE. | 2 | 1 / 106 | 未审 |
| `231` | The free uniform spanning forest is a factor of IID. | 1 | 1 / 177 | 未审 |
| `232` | Gaussian fields and interfaces for triangular-lattice Lipschitz heights. | 3 | — | 未审 |
| `233` | The joint critical Ashkin–Teller current limit. | 1 | — | 未审 |
| `234` | All-temperature pressure of orthogonally invariant Ising spin glasses. | 1 | 1 / 93 | 未审 |
| `235` | Limiting random SAT thresholds, sharp variance and computability. | 4 | 1 / 97 | 未审 |
| `236` | The exact factor-of-IID threshold for free Ising spins on trees. | 1 | 1 / 90 | 未审 |
| `237` | The three-quarter exponent for honeycomb self-avoiding walk. | 13 | 1 / 79 | 未审 |
| `238` | Optimal logarithmic mixing of the Thorp shuffle. | 12 | 1 / 78 | 未审 |
| `239` | Sharp singularity rates for symmetric random sign matrices. | 2 | 1 / 100 | 未审 |
| `240` | Shelah's eventual categoricity and the prescribed-threshold obstruction. | 2 | 1 / 177 | 未审 |
| `241` | Rigidity of the Turing degrees. | 1 | 1 / 1,189 | 未审 |
| `242` | Single-fold Diophantine representations and undecidability under an at-most-one-solution promise. | 1 | 1 / 1,635 | 未审 |
| `243` | Separating choiceless counting from polynomial time and witnessed choice. | 2 | — | 未审 |
| `244` | The Partition Principle does not imply Choice. | 1 | 2 / 1,482 | 未审 |
| `245` | Weak normalization implies strong normalization in pure type systems. | 1 | 2 / 1,096 | 未审 |
| `246` | Cannon's conjecture. | 1 | 1 / 224 | 未审 |
| `247` | An infinite finitely presented residually finite 2-group and a finitely presented nil algebra. | 2 | 1 / 172 | 未审 |
| `248` | Thompson's group <i>F</i> is nonamenable. | 1 | 1 / 85 | 未审 |
| `249` | A finitely generated Eilenberg–Ganea counterexample. | 1 | 1 / 495 | 未审 |
| `250` | Boone–Higman embeddings with higher finiteness. | 3 | 4 / 1,477 | 未审 |
| `251` | Amenability, unitarizability, and strong Ulam stability. | 2 | 1 / 120 | 未审 |
| `252` | A torsion-free hyperbolic group that is neither residually finite nor linear over any field. | 1 | 1 / 320 | 未审 |
| `253` | An infinite finitely presented simple amenable group. | 1 | 1 / 91 | 未审 |
| `254` | Classifying spaces and geometric obstructions for Artin groups. | 3 | 1 / 234 | 未审 |
| `255` | Quasi-isometric recognition of virtually polycyclic groups. | 1 | — | 未审 |
| `256` | Nonsingular systems of equations over arbitrary groups. | 2 | 1 / 162 | 未审 |
| `257` | A hyperbolic group without a geometric CAT(0) action. | 1 | 1 / 827 | 未审 |
| `258` | Gersten’s conjecture and virtual compact specialness of one-relator groups. | 2 | 1 / 117 | 未审 |
| `259` | A group without fixed price. | 1 | 2 / 355 | 未审 |
| `260` | Spacetime Penrose inequalities: enclosing area, charge, rotation, and anti-de Sitter extensions. | 13 | 1 / 360 | 未审 |
| `261` | Localization and delocalization in the Anderson model. | 2 | 1 / 63 | 未审 |
| `262` | Sharp finite-matrix Lieb–Thirring inequalities and all equality cases. | 3 | 1 / 145 | 未审 |
| `263` | The ionization and generalized ionization conjectures. | 3 | — | 未审 |
| `264` | Strong cosmic censorship near two-ended Kerr data. | 3 | 1 / 109 | 未审 |
| `265` | Area laws and tensor networks for two-dimensional gapped systems. | 2 | 1 / 52 | 未审 |
| `266` | Exactly three mutually unbiased bases in dimension six. | 2 | 1 / 85 | 未审 |
| `267` | Positive-temperature Bose–Einstein condensation and exact quantum depletion. | 5 | 1 / 168 | 未审 |
| `268` | The spin-one Haldane gap. | 2 | 1 / 74 | 未审 |
| `269` | Uniform Laughlin gap and stability under bounded scalar disorder. | 2 | 1 / 54 | 未审 |
| `270` | Threshold and positive-energy bound states of the BFSS matrix model. | 2 | — | 未审 |
| `271` | Bloch's law, its lattice correction, and the spherical magnetization law. | 4 | 1 / 317 | 未审 |
| `272` | Entanglement without distillable secret key. | 1 | 1 / 117 | 未审 |
| `273` | The entropy photon-number inequality. | 1 | 1 / 102 | 未审 |
| `274` | Parity is not in QAC<sup>0</sup>. | 2 | 1 / 82 | 未审 |
| `275` | QMA-hardness of continuum Coulomb energy. | 2 | 1 / 79 | 未审 |
| `276` | Classical capacity of generalized amplitude damping. | 1 | 1 / 591 | 未审 |
| `277` | Threshold repetition for entangled games. | 1 | 1 / 759 | 未审 |
| `278` | Failure of Kohn–Sham ensemble representation. | 1 | — | 未审 |
| `279` | Exact quantum factoring over a fixed finite gate set. | 1 | 1 / 98 | 未审 |
| `280` | Unitary vertex operator algebras and conformal nets. | 1 | 1 / 198 | 未审 |
| `281` | QAOA attains the SK optimum in the thermodynamic-first limit. | 2 | 1 / 112 | 未审 |
| `282` | From scale symmetry to local conformal symmetry in four-dimensional QFT. | 1 | — | 未审 |
| `283` | Polynomial-time unitary synthesis from a Boolean oracle. | 1 | 1 / 521 | 未审 |
| `284` | The optimal quartic separation between randomized and quantum queries. | 1 | 1 / 300 | 未审 |
| `285` | Counterexamples to Baum–Connes and Kadison–Kaplansky. | 3 | — | 未审 |
| `286` | Rigidity and arithmetic of lattice von Neumann algebras. | 2 | 1 / 74 | 未审 |
| `287` | Isomorphism of the free group factors. | 1 | 1 / 81 | 未审 |
| `288` | Kadison's similarity conjecture. | 1 | 1 / 205 | 未审 |
| `289` | Strong Kadison–Kastler stability and its spatial boundaries. | 3 | 1 / 115 | 未审 |
| `290` | Relative bicentralizers and modular spectral recovery. | 2 | 1 / 162 | 未审 |
| `291` | Cuntz comparison, nuclear dimension, and equivariant Jiang–Su stability. | 4 | 1 / 139 | 未审 |
| `292` | Kirchberg's $`\mathcal O_2`$ norm-ultrapower embedding problem. | 1 | — | 未审 |
| `293` | Invariant projections, hyperinvariant subspaces, and transitive algebras. | 2 | 1 / 532 | 未审 |
| `294` | Kaplansky's quasitrace conjecture and failure of tensor-product stable finiteness. | 1 | 1 / 9 | 未审 |
| `295` | The Kadison–Ringrose cohomology conjecture. | 1 | 1 / 262 | 未审 |
| `296` | The generator problem for finite factors. | 1 | 1 / 232 | 未审 |
| `297` | A ZFC counterexample to Naimark's problem. | 1 | 1 / 104 | 未审 |
| `298` | Two notions of free entropy differ even when both are finite. | 1 | 1 / 65 | 未审 |
| `299` | The Kirchberg–Rørdam character criterion and infinite tensor-power Jiang–Su stability. | 1 | 1 / 340 | 未审 |
| `300` | Approximation and quadratic strong-operator paving. | 2 | 1 / 897 | 未审 |
| `301` | Trace cones and Razak–Jacelon stabilization. | 1 | 1 / 61 | 未审 |
| `302` | Radius of comparison equals half the mean dimension. | 2 | 1 / 113 | 未审 |
| `303` | Weak pure infiniteness and Cuntz-algebra absorption. | 1 | 1 / 150 | 未审 |
| `304` | The Hilbert–Smith conjecture in every dimension. | 1 | 1 / 83 | 未审 |
| `305` | Four-dimensional disk embedding and Wall's conjecture. | 3 | — | 未审 |
| `306` | The purely cosmetic surgery conjecture. | 1 | 2 / 240 | 未审 |
| `307` | Failure of rational injectivity for maximal coarse assembly. | 2 | 1 / 163 | 未审 |
| `308` | Finite Smith–Toda complexes at every height. | 2 | 1 / 802 | 未审 |
| `309` | The Kervaire invariant problem at the prime three. | 1 | — | 未审 |
| `310` | Quillen's conjecture in rational homology. | 1 | 1 / 111 | 未审 |
| `311` | The Hovey–Strickland and Chai conjectures. | 1 | 1 / 112 | 未审 |
| `312` | The Grothendieck homotopy hypothesis. | 1 | 1 / 231 | 未审 |
| `313` | Finite generation for the $`K(n)`$-local sphere. | 1 | — | 未审 |
| `314` | Cyclic length and chromatic fixed-point loss. | 1 | 1 / 193 | 未审 |
| `315` | The four-dimensional Singer conjecture. | 1 | 1 / 180 | 未审 |
| `316` | Curtis’s conjecture. | 1 | 1 / 104 | 未审 |
| `317` | Thomason model structures in all strict higher dimensions. | 1 | 1 / 134 | 未审 |
| `318` | Chromatic splitting: filtrations and counterexamples. | 5 | 10 / 988 | 未审 |
| `319` | Counterexamples to finite generation at chromatic height two. | 1 | — | 未审 |
| `320` | Nonhomeomorphic closed aspherical four-manifolds. | 1 | 1 / 123 | 未审 |
| `321` | A counterexample to Wall's finite D(2) problem. | 1 | 3 / 2,491 | 未审 |
| `322` | Tingley’s sphere-isometry problem. | 1 | 1 / 593 | 未审 |
| `323` | Independence of the separable quotient problem. | 1 | 2 / 243 | 未审 |
| `324` | Lipschitz equivalent Banach spaces need not be linearly isomorphic. | 2 | 1 / 55 | 未审 |
| `325` | The complete Crouzeix conjecture. | 2 | 1 / 292 | 未审 |
| `326` | The cotype–cotype conjecture under the approximation property. | 1 | 1 / 258 | 未审 |
| `327` | Markov type characterizes superreflexivity. | 1 | 4 / 102 | 未审 |
| `328` | Nonexpansive fixed points in reflexive Banach spaces. | 1 | 3 / 1,549 | 未审 |
| `329` | A counterexample to metric-entropy duality. | 1 | 1 / 798 | 未审 |
| `330` | A uniformly discrete counterexample to bounded approximation in Lipschitz-free spaces. | 1 | 2 / 845 | 未审 |
| `331` | Reflexive midpoint convexity and diamond distortion. | 7 | 1 / 108 | 未审 |
| `332` | Metric Markov cotype of <i>ℓ</i><sub>1</sub> and Hilbert-space Lipschitz extension. | 1 | 1 / 156 | 未审 |
| `333` | Smooth isometric immersions of surfaces into ℝ<sup>4</sup>. | 1 | 1 / 81 | 未审 |
| `334` | A smooth surface metric with no local isometric immersion in ℝ<sup>3</sup>. | 1 | 1 / 70 | 未审 |
| `335` | Gromov’s integral scalar-curvature bound for simplicial volume. | 2 | 1 / 139 | 未审 |
| `336` | Spectral scalar curvature, Urysohn width, and macroscopic dimension. | 3 | 1 / 187 | 未审 |
| `337` | Sharp Cartan–Hadamard isoperimetry and rigidity. | 2 | 1 / 60 | 未审 |
| `338` | Yau's uniformization conjecture. | 1 | 1 / 73 | 未审 |
| `339` | Katok's entropy rigidity conjecture. | 1 | 1 / 172 | 未审 |
| `340` | A counterexample to the nearby Lagrangian conjecture. | 1 | — | 未审 |
| `341` | Donaldson's hypersymplectic deformation conjecture. | 1 | 1 / 148 | 未审 |
| `342` | Donaldson's tamed-to-compatible conjecture. | 1 | 1 / 112 | 未审 |
| `343` | Symplectic ball packing in higher dimensions. | 1 | 1 / 34 | 未审 |
| `344` | The metric Blaschke conjecture. | 1 | 1 / 25 | 未审 |
| `345` | Infinitely many closed geodesics on Riemannian spheres and closed three-manifolds. | 1 | 1 / 617 | 未审 |
| `346` | Sharp singular-set bounds for stationary integral varifolds. | 2 | 1 / 61 | 未审 |
| `347` | Counterexamples to stable-Morse and strong Arnold fixed-point bounds. | 5 | 1 / 202 | 未审 |
| `348` | Nonnegative-curvature Einstein classification and an <i>L</i><sup>2</sup> topological gap. | 3 | — | 未审 |
| `349` | The Solomon–Yau least-volume conjecture. | 1 | 1 / 405 | 未审 |
| `350` | Yau’s nodal bounds: surfaces and higher dimensions. | 3 | — | 未审 |
| `351` | Scalar curvature and finite-time Ricci-flow singularities. | 3 | — | 未审 |
| `352` | A finite-time singularity of Calabi flow. | 1 | — | 未审 |
| `353` | Affine Bernstein rigidity through dimension nine and a smooth dimension-ten counterexample. | 2 | 1 / 166 | 未审 |
| `354` | The isoperimetric profile of the cubic three-torus. | 1 | 1 / 124 | 未审 |
| `355` | Unique tangent flows at the first surface singularity. | 1 | 1 / 190 | 未审 |
| `356` | Gigli’s characterization of Alexandrov curvature. | 2 | 1 / 60 | 未审 |
| `357` | Bi-Lipschitz coordinates at every regular RCD point. | 1 | — | 未审 |
| `358` | A three-manifold without conjugate points or nonpositive curvature. | 1 | — | 未审 |
| `359` | Negative Kähler curvature without bounded holomorphic coordinates. | 2 | 1 / 171 | 未审 |
| `360` | Weak MTW curvature gives convexity and regular optimal transport. | 2 | 2 / 229 | 未审 |
| `361` | Failure of integer-degree harmonic dimension comparison. | 2 | 1 / 86 | 未审 |
| `362` | Global smoothness for relativistic Vlasov–Maxwell. | 1 | 1 / 110 | 未审 |
| `363` | Nonuniqueness with local conservation for the hard-sphere Boltzmann equation. | 2 | 1 / 89 | 未审 |
| `364` | Kinetic limits and fluctuations over the Boltzmann lifespan. | 2 | 2 / 192 | 未审 |
| `365` | Joint metric and connection recovery from one boundary patch. | 3 | — | 未审 |
| `366` | The planar Mumford–Shah regularity conjecture and local weak-<i>L</i><sup>4</sup> gradient bounds. | 1 | — | 未审 |
| `367` | The critical dimension for the one-phase Bernoulli problem. | 1 | 1 / 58 | 未审 |
| `368` | The three-dimensional Ball–Evans approximation problem. | 2 | 1 / 78 | 未审 |
| `369` | The hot spots conjecture for simply connected planar domains. | 1 | 1 / 112 | 未审 |
| `370` | The Lane–Emden and Hénon–Lane–Emden conjectures. | 1 | 1 / 59 | 未审 |
| `371` | Stable blowup for the defocusing Schrödinger equation. | 1 | — | 未审 |
| `372` | Global uniqueness in smooth isotropic elasticity. | 1 | 1 / 147 | 未审 |
| `373` | Nonattainment of the three-marginal Coulomb Monge problem. | 1 | 1 / 112 | 未审 |
| `374` | Sharp one-third stability of Brenier maps. | 1 | 2 / 294 | 未审 |
| `375` | De Giorgi's conjecture in dimension eight. | 1 | — | 未审 |
| `376` | Universal computation in forced Navier–Stokes flows. | 9 | 1 / 312 | 未审 |
| `377` | Interior $`C^{1,\alpha}`$ regularity for infinity-harmonic functions. | 1 | — | 未审 |
| `378` | Disproof of the Exponential Time Hypothesis. | 1 | 1 / 205 | 未审 |
