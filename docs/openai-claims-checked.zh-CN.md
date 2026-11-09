# 对照 OpenAI 原文核查过的候选问题

Argus 对 OpenAI 数学论文集（[`openai/math`](https://github.com/openai/math) @ `4eaee875`）跑第一轮时，产生了一批候选问题和汇总统计。我们把每一条都拿去和论文原文对照核查过，本页逐条记录结果。总报告见 [openai-math-audit-findings.zh-CN.md](openai-math-audit-findings.zh-CN.md)。

## 为什么大多数候选问题不成立

各家族的底稿大多写得谨慎，很多明确写着"没有发现原文的错误断言"。候选问题主要是在汇总阶段产生的，原因有四类：

- **Argus 自己**提出的捷径、推广和测试命题被反驳后，这些 `refutes` 判定被当成了对论文本身的判断。
- 确认 OpenAI 原文正确的句子被误读。例如 003 的底稿写的是 OpenAI 的符号 `u−n` 是对的。
- 把工作流程中的统计当成了论文的属性：Argus 自己的 Lean 编译失败、没有读过内容的引用、没做完的检查。
- 少数条目找不到任何出处。

## A. 汇总性说法

| 第一轮汇总里的说法 | 核查结果 |
| :--- | :--- |
| "审完全部 376 族 / 723 篇"、"373/373 100% 完成" | 上游共有 373 个在架家族、721 篇论文；另有 3 篇撤稿，OpenAI 没有给它们编号。第一轮碰过每个家族，但不是逐篇审查。系统复核正在进行，目前 54/373 个家族通过验收 |
| OpenAI 论文存在"8 类直接数学错误和系统缺陷" | 没有确认任何数学错误。成立的只有 3 处小问题：一个引理编号（320）、一个失效的 DOI（318）、一处在某种读法下缺前提的措辞（247） |
| "10 个结构性死刑家族（25 篇）"、"21 个被证伪的 OpenAI 家族"、"28 条论文级证伪"、"42 条被推翻的命题 / 67 个 refutes 判定" | 见 B 部分。除上面 3 处小问题外，没有一条是 OpenAI 论文的错误 |
| "45 / 236 / 516 / 650 篇有问题"，以及 5 级"可信度矩阵" | 这些数字由下面几行的统计拼成，没有一个衡量的是 OpenAI 论文的缺陷 |
| "554 条 Reviewer 判定为未决的论证桥接"、"206 个家族（55.2%）依赖未证明的文字桥接" | 这 554 条记录中，189 条是 Argus 自己的 Lean 编译失败，91 条是引用解析器的备注，274 条是 Argus 没做完的检查。相关报告原文就写着"没有断言原文有缺陷" |
| "31 个家族引用核查失败" | 这些情况都是解析器找到了 DOI 或 arXiv 编号，但没有去读被引的命题。这不能算核查失败 |
| "305 个家族（81.8%）把最难的步骤当黑箱甩给外部文献" | 这些外部假设挂在 **Argus 自己**的子命题上，多数是 Fubini、Brouwer、Stacks Project、谱定理这类标准结果。引用它们是正常的数学写法 |
| "只有 36 族 / 73 篇是自洽的" | 统计的是 Argus 论证图里没有外部假设的家族，反映的是 Argus 自己的工作，不是论文本身 |
| OpenAI 的 Lean"有 5 个文件含自定义 `axiom`、5 个文件含 `sorry`" | 不成立。命中的全是注释里的英文单词。`lean/ComparatorChallenges/*.lean` 按设计就以 `sorry` 结尾，对应的证明在 `lean/OAI/` 中，那里没有 `sorry` |
| "245 个带 Lean 标签的家族中有 144 个承认只是玩具子模型" | 这个数字找不到来源。抽查 `lean/docs/*.md`，它们都形式化了主定理，只是列出没有涵盖的次要结果 |
| 把"75.6% 的论文不在 formalization.yaml 中"当作缺陷 | `formalization.yaml` 只收录已形式化的主结果，论文不在其中不代表没有 Lean。`review: status: unchecked` 只是一个 schema 字段，不是承认有错 |
| 撤稿论文标题写作 "The Hodge Conjecture for Odd-Dimensional K3-Type Varieties"、"Rationality of K3-Type Varieties and Mukai Lattices"、"Algebraicity of Weil Classes on Four-Dimensional Hyperkähler Manifolds"，编号 #045/#061/#070 | 这些标题是编造的。真实标题是 "Algebraicity of Weil classes on split abelian eightfolds"、"Algebraicity of Kuga–Satake Correspondences for K3 Surfaces"、"The rational Hodge conjecture for products of K3 surfaces"，没有家族编号。OpenAI 说明撤回的是证明，不是说结论为假 |
| "317 个家族共 384 份零 sorry 证书、520,223 行、41,764 个定理" | 证书是真的，也有编译通过的记录，但只覆盖 314 个家族。其中 346,954 行是 156 的机器生成 SAT 证明重放，约 52,000 行移植自 OpenAI 自己的 Lean，Argus 原创的去重代码约 120,000 行 |
| "93 个原本没有形式化的家族被新形式化"（暗示是完整形式化） | 实际是一些小的核心引理证书，合计约 22,500 行，中位数 131 行 |
| "审计总成本 $85.88 / 每族 $0.23" | 按 token 实测：第一轮 $1,861.55（32.1 亿 tokens）；截至 2026-11-09，整个论文集相关工作累计 $3,477.03（62.7 亿 tokens） |
| "101 个修复证明的家族"、"243/279 个被加强的家族"、"166 份推广报告" | 这些是没有经过审查的关键词标签。其中一个标签的触发原因，是 OpenAI 自己的 README 里写了"This version repairs…"。只有经过审查的条目才算数，见报告 §3 |
| 把 342"推翻 Li–Zhang 的 4 个已发表定理"作为头条成果 | 这只是一个候选冲突，不是已确立的反驳。OpenAI 在 2026-10-07 的修订中已经自己更正了锥等式的说法，并补充了严格包含的例子。该论文的正式发表版本、相关几何和优先权都还需要专家核查 |
| 075："OpenAI 为 L log L 那篇写的 Lean 定理以 `sorry` 结尾"（来自 Argus 的一次审查） | 被引用的文件是 comparator 挑战题陈述。真正的证明 `OAI.FourierLLogL.paperMain` 在 `lean/OAI/Analysis/FourierLLogL/PaperMain.lean` 中，没有 `sorry` |

## B. 各家族的候选问题

路径都在 `4eaee875` 版本的 `preprints/` 下。

| 家族 | 候选问题 | 结论 | 原文实际情况 |
| :--- | :--- | :--- | :--- |
| 318 | "OpenAI 声称 `level_G(X)=3`" | 不成立 | OpenAI 没有任何一篇论文断言过生成层数（`The-height-three-chromatic-overlap…/01-introduction.tex:65–84`）。层数为 3 是 Argus 自己的候选命题。Argus 得到的层数 2 是对 OpenAI 滤链的细化，与之并不矛盾 |
| 318 | "OpenAI 声称 π₋₃ 上的映射为零" | 不成立（误读） | OpenAI 的主定理说的是该映射**非零**（`A-rational-obstruction…/01-introduction.tex:36–43`）。Argus 反驳的是这个定理的否定，恰好确认了 OpenAI 的结论 |
| 318 | "OpenAI 声称扩展稳定子群的 5-上同调维数有限" | 不成立 | OpenAI 在 `a=p` 的情形明确回避了这个说法（`Counterexamples-to-weak-chromatic-splitting…/04-adic.tex:149–153`） |
| 318 | 第零列双复形消失 | 不成立 | 这是 Argus 内部的一条论证路线，OpenAI 原文没有这样说 |
| 318 | "配套的特征和论文：`q=7` 时 `Re M(1,χ)=−7/2`；界从 `q>163` 降到 `q>39`" | 找不到出处 | OpenAI 没有这样的论文或命题，Argus 的任何底稿里也没有 |
| 318 | Zink 的引用 | **成立**（参考文献） | DOI `10.24033/ast.534` 无法解析，但引用的内容是对的 |
| 001 | "把 Milne §5.21 当作已证的提升定理引用" | 不成立 | OpenAI 称 Milne 的论述为"条件判据"，引用的是 Question 2.17 / Theorem 2.18，没有引用 §5.21（`Milnes-rationality…-October-7-2026/00_intro.tex:153–156`） |
| 001 | "只用了 Kisin 的 Prop. 1.4.15" | 不成立 | 证明用的是 Kisin–Zhou 2025（`02_transport.tex:330` 起）。这条捷径是 Argus 自己的 |
| 341 | "Oh–Zhu (2.18) 符号混用；Sobolev 对偶阶错误" | 不成立 | OpenAI 只是拿 Oh–Zhu 来对照（"compare"），余核那一步是自己证明的（`Deforming-hypersymplectic…/07-pencil.tex:190–193, 298–314`） |
| 320 | `[MT, Lemma 3.9]` 应为 Lemma 6.7 | **成立**（引用笔误） | `formal.tex:785`。该机制在原文中有完整复述，所以没有数学漏洞 |
| 321 | "把 Howie 的常系数引理直接用到局部系统上" | 不成立 | 带挠的那一步 OpenAI 自己证明了（`A-Counterexample-to-Walls-D2-Problem…/02-tower.tex:60–100`） |
| 316 | "只检验单个 Milnor 本原元；`F_9` 上 `x³` 的反例" | 不成立 | OpenAI 的 `lem:tor-injection` 处理了混合本原元的情形，Argus 也核验通过。所谓 `F_9` 反例本身就是错的：`x³` 在 `F_9` 上是 Frobenius 映射，因而是置换 |
| 046 | "分别检测每个子午线" | 不成立 | OpenAI 原文写道，两个循环子群单独都检测不到这些关系，所以选了一个能检测整个局部群的商（`06-surface.tex:25–27`） |
| 004 | "线性清除因子 `h` 在 `Z/9` 上失效，必须用 `h²`" | 不成立 | OpenAI 用的本来就是 `2^{2e}`（`A-pointwise-2-converse…-September-24-2026/ring-determinants.tex:254–256`）。线性版本是 Argus 自己提的，`Z/9` 的例子在 Argus 的任何文件里都找不到 |
| 209 | "二进模型中的奇素数 `y=0` 切片破坏了 Eisenstein 步骤" | 不成立 | OpenAI 没有二进模型，`p=2` 的尝试是 Argus 自己做的（`model.tex:31–40`） |
| 209 | "只用了 Voevodsky 6.17" | 不成立 | OpenAI 同时引用了定理 6.16–6.17 和 Weibel（`field.tex:46–55`） |
| 053 | "从 EGL 数值等价直接推到带标记的 Chow 群" | 不成立 | OpenAI 显式证明了属于该线性张成，并明确说没有用数值普遍性来代替带标记的 Chow 恒等式（`05-quot.tex:919–924`、`06-coefficient.tex:199–235`） |
| 053 | "投影在 `λ=−1` 时失效" | 找不到出处 | OpenAI 原文和 Argus 底稿里都找不到 |
| 053 | "式 (21) 漏了负号" | 不成立 | "(21)" 是 Argus 自己报告里的编号，不是 OpenAI 原文的。OpenAI 的公式里有负号（`06-coefficient.tex:362–379`） |
| 067 | "把 Kanemitsu 关于一般成员的结果用到了每个成员上" | 不成立 | 对每个成员的分裂 OpenAI 自己做了证明；引用 Kanemitsu **2017** 只是为了纤维化结构（`02-minimal-curves.tex:48–108`） |
| 067 | "符号、阶乘、秩 3 常数项算错" | 不成立 | Argus 原文说的是它**独立核验了**这些项，得到的系数和 OpenAI 一致 |
| 201 | "用逐点的秩去控制整体张成的维数" | 不成立 | OpenAI 明确指出单独的秩界不够，用的是单一图的论证（`global-defect.tex:6–9, 196–234`） |
| 247 | 不保留左端点就释放边界游标区域 | **成立**（措辞问题，取决于读法） | `An-infinite-finitely-presented-periodic-group-September-23-2026/finite-rules.tex:575–581`。出处是 9 月那篇周期群论文，不是剩余有限 2-群那篇。实际应用不受影响 |
| 340 | "默认多重 jet 横截性会保持端点 collar 不变" | 不成立 | OpenAI 明确把扰动乘上了一个支撑在端点 collar 之外的截断函数（`obstruction.tex:294–317`） |
| 180 | "`bipyramid_4` 上的抵消破坏了阶的保持" | 不成立 | 被反驳的是 Argus 自己的命题，它漏掉了 OpenAI"至少存在一对"的假设（`paper.tex:413–416`）。`bipyramid_4` 与 OpenAI 的定理一致 |
| 274 | "高秩投影推翻了独立性" | 不成立 | OpenAI 只对秩一的量子比特投影断言独立性，这种情形下结论成立（`localization.tex:25–26`）。高秩情形是 Argus 自己的推广 |
| 376 | "积分发散的快速衰减时钟不存在" | 不成立 | 这个障碍 OpenAI 原文自己就讲了（`main.tex:97–103`） |
| 003 | "第 335 行把 `u−n` 写成了 `n−u`" | 不成立（误读） | Argus 底稿写的是位移**就是** `u−n`，原文是对的。该段落在 Landau–Siegel 那篇，不是 quasi-Riemann 那篇 |
| 130 | "总步数差一；递归阈值未证明" | 不成立 | 这是 Argus 往自己的验证器里故意注入的错误样本，用于测试验证器 |
| 130 | "`h=25` 比 `h=100` 的间隙大 1500 多倍" | 属于改进，不是问题 | 这是 Argus 做的参数改进，不是 OpenAI 的错误；OpenAI 从未声称 `h=100` 是最优的 |
| 052 | "`dr∧dz` 定向反了" | 不成立 | 按 OpenAI 的取序，符号是对的；而且结论是 `=0`，符号本来就不影响（`boxes.tex:431–441`） |
| 149 | "依赖未经论证的时间依赖紧性" | 不成立 | OpenAI 处理的是固定速率；随时间变化的速率是 Argus 自己的推广 |
| 242 | "依赖严格模跳跃" | 不成立 | OpenAI 的剩余类论证是对的（`power.tex:178–187`） |

第一轮的 Lean"证伪集"形式化的是上表中那些反驳；被反驳的命题都是 Argus 自己的，不是 OpenAI 的。

## C. 仓库其他待办

OpenAI 相关工作之外的 84 个结果包，也需要做同样的核查：
- 状态标签与结果包自己的 `audit-evidence.md` 相矛盾；
- 部分结果最初出自他人之手，但没有注明出处；
- 部分"新颖性"标签没有得到结果包自身报告的支持。
