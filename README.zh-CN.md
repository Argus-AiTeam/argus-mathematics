<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/brand/argus-logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/brand/argus-logo-light.svg">
    <img src="assets/brand/argus-logo-dark.svg" width="420" alt="Argus">
  </picture>
</p>

<h1 align="center">Argus Mathematics</h1>

<p align="center">
  <strong>Argus 自治数学研究工程：原创数学定理、精确反例与机器可复核证书总库</strong><br>
  <a href="README.md">English</a> ·
  <a href="results/">全部 84 个成果包目录 (<code>results/</code>)</a> ·
  <a href="data/results.json">结构化索引 (<code>data/results.json</code>)</a> ·
  <a href="runtime/">Argus 运行时与 <code>math</code> Vertical</a> ·
  <a href="https://github.com/Argus-AiTeam/argus-counterexample-runtime">独立引擎源码仓库</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/正式归档成果包-84-174A7E?style=flat-square" alt="84 个成果包">
  <img src="https://img.shields.io/badge/独立_AMS_LaTeX_论文-84_篇_PDF-2E7D32?style=flat-square" alt="84 篇论文">
  <img src="https://img.shields.io/badge/SHA--256_校验产物-730-6A1B9A?style=flat-square" alt="728 个产物">
  <img src="https://img.shields.io/badge/验证体系-Jacobian_%7C_Lean_4_%7C_PARI%2FGP-C62828?style=flat-square" alt="验证体系">
  <img src="https://img.shields.io/badge/总实际算力扣费-%24352.84_(均_%244.20%2F包)-E65100?style=flat-square" alt="实际扣费">
</p>

---

## 仓库总览

本仓库集中归档 **Argus** 自治数学研究项目已形成完整证据链的数学定理、显式反例与形式化/符号复算证书。本仓库不堆砌未验证的模型对话，[`results/<ID>/`](results/) 下的每一个成果包均围绕**严格的数学命题、可独立重跑的精确证书（Farkas 对偶、SMT/ILP、$\mathbb{F}_2$-Magnus 代数、PARI/GP 数域下降、Lean 4 内核）以及明确的适用边界**构建，并配有独立编译的 AMS LaTeX 学术论文（`ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf` 与 `.tex` 源码）。

截至 **2026 年 11 月 5 日**，仓库共收录 **84 个独立开放问题正式成果包**（**748 个带 SHA-256 校验值的公开产物**），以及对 **OpenAI `openai/math` 文库的大规模自主红队审计、`refutes` 证伪账本、Lean 4.31.0 形式化认证与定理强化专章**（详见 [`docs/openai-math-audit-findings.md`](docs/openai-math-audit-findings.md)）：

| 类别 | 数量 | 说明 |
|---|---:|---|
| **一、公开猜想的旗舰反例与可发表新定理** | **22** | 组合图论、有限域代数、代数几何、群论与数论中公开猜想的直接反例及无条件正面定理 |
| **二、千禧年难题前沿子模型与结构阻碍定理** | **12** | 整系数霍奇猜想普适迷向性定理、Navier–Stokes 自相似排除、Euler 弯管共形闭合、Hilbert–Pólya 本质谱阻碍、$\mathrm{GL}_4$ 非温和密度界与电路复杂性对偶 |
| **三、独立核验反例与文献勘误（Batch 001 与全量审计）** | **31** | 对 757 道历史公开问题逐项审计产出的显式反例、Lean 4 形式化反驳与定义域修正 |
| **四、符号计算、代数归约与多面体边界证书** | **19** | 计算机辅助家族排除证书、Farkas 不可行性对偶证明与高精度区间牛顿认证 |
| **合计正式归档成果包** | **84** | 每个成果包均含 `ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf`、`.tex`、`README.md` 与 `verification-summary.json` |

---

## 对 OpenAI `openai/math` 全量 723 篇手稿（376 家族）的五级可信度审计、42 项漏洞证伪、381 份 Lean 4.31.0 机器证明与 276 族证明修补/定理超越（101 族修补 + 243 族强化）

依托 Argus 的**拉卡托斯式「证明与反驳（Proofs and Refutations）」双盲审计架构**与 24 路并发 `gpt-6.1-sol` 守护进程，我们对 OpenAI 发布的 `github.com/openai/math` 全集（**376 个问题家族、723 篇手稿** = 3 个官方已撤稿家族 + 373 个现存活跃家族 / 720 篇现存手稿）完成了全覆盖逐引理拆解（**9,597 条形式化断言、8,368 条审计证据**，总计仅调用 2,147 次、实付 **`$85.88`**，平均每个家族 **`$0.23`**）。

- **📄 完整中文审计与超越报告**：**[`docs/openai-math-audit-findings.zh-CN.md`](docs/openai-math-audit-findings.zh-CN.md)**
- **📄 English Full Audit Report**：**[`docs/openai-math-audit-findings.md`](docs/openai-math-audit-findings.md)**
- **📊 机器可读 376 家族全量审计账本**：**[`data/openai-math-373-audit.json`](data/openai-math-373-audit.json)**

### 0. OpenAI `openai/math` 论文中直接暴露的八大类问题，以及我们的证伪、修复与同题推进

| 问题类别 | OpenAI `openai/math` 论文里直接出错或存在硬伤的地方 | 我们的具体证伪、修复与同题推进 |
| :--- | :--- | :--- |
| **一、主定理结论直接算错** | **`#318`（色分裂猜想系列论文）把核心反例的阶数算错了**：<br>• 主定理声称局部化谱 $X = L_2 L_{K(3)} S_5^\wedge$ 的三角生成水平为 **$\mathrm{level}_G(X)=3$**，且存在两步复合非零的 G-ghost 映射；<br>• 声称典型有理映射 $L_0 X \to L_0 L_{K(2)} X$ 在 $\pi_{-3}$ 上等于 $0$；<br>• 声称高度 5 扩张稳定子群在离散模上有有限 5-上同调维数。 | **全部直接推翻并算出正确值**：<br>• 证明在度数 $-5$ 处比较映射 $L_0 Y \to L_0 L_{K(1)} Y$ 恒等于 $0$，余纤维三角形直接分裂为直和 $Y \simeq B_2 \vee V$，因此**真实的生成水平是 $\mathrm{level}_G(X)=2$，原文的 $\mathrm{level}_G(X)=3$ 是错的**；<br>• 证明 $p=5$ 时 $\pi_{-3}$ 上的有理映射**非零**；扩张稳定子群含 5 阶中心挠元，上同调维数为 **$\infty$**；<br>• 在其伴随特征标论文中抓出漏掉复单位根特征标（$q=7$ 时 $\operatorname{Re}M(1,\chi)=-7/2<0$），并将模数下界从 $q>163$ 推进至 **$q>39$**。 |
| **二、引文无中生有或跨论文张冠李戴** | 遇到证不出来的关键步骤时，把别人的“公开问题”当成“已证定理”引用，或引用根本不存在的引理编号，或把外部论文的同名符号乱套到自己头上： | **抓出假引文/错引文，并把缺的定理真正证出来**：<br>• **`#001`（Milne 有理性猜想，全库第 1 号论文）**：原文引用 Milne `SVp.pdf` §5.21 作为提升存在性定理；但 **§5.21 只是 Milne 提出的一道未解决公开问题，根本没有证明**。我们改用 **Gabber 仿射平展光滑性定理** 与完美化 RZ 空间局部常值传播引理（配 Lean 4 证明），真正证出了这一步。<br>• **`#341`（Donaldson 超辛形变，10月7日修订稿）**：`07-pencil.tex` 引用 Oh–Zhu 式 (2.18) 证余核消没，但 Oh–Zhu 的 $E_0,E_1$ 是**无穷维 Sobolev 截面空间**，而 OpenAI 文中的 $E_i$ 是**有限维求值亏格丛**，纯因字母同名而张冠李戴。我们直接从一阶椭圆 Cauchy–Riemann 算子重证了该定理。<br>• **`#320`（四维闭非球面流形）**：`formal.tex:785` 引用了 `[MT, Lemma 3.9]`，但所引 MT 论文第 3 节**根本不存在 Lemma 3.9**（实为第 6 节 Lemma 6.7）。 |
| **三、中间引理直接为假（17 个家族被构造出显式反例）** | 原文证明链依赖的中间引理在挠商环、特征 2 切片、高秩投影或边界条件下**直接不成立**： | **构造出可独立重跑的显式反例推翻原引理，并给出正确定理**：<br>• **`#209`（整系数 Gersten 猜想反例）**：原文把奇素数 $y=0$ 切片直接代入特征 2 二进 $(0,2)$ 分圆模型，导致常数项与范数**恒等于 $0$**，Eisenstein 判据失效。我们在 $B=(\mathbb{Z}_2[x,y]/(2-2x+x^2+xy-y^2))_{(2,x,y)}$ 上独立证出了**有限剩余域 $\mathbb{F}_2$ 上的 3 次整系数 Gersten 核非零定理 `D2_MAIN`**。<br>• **`#004`（$\mathbb{Q}$ 上希尔伯特第十问题）**：构造 $A=\mathbb{Z}/9\mathbb{Z}, B=A[t]/(3t,t^2)$ 反例证明一次清除因子 $h$ 失效，并证明必须用二次因子 $h^2$（已过 Lean 4）。<br>• **`#180`（Barnette 猜想）**：在四棱双锥 `bipyramid_4` 上找出两个森林配对态使首项系数 `[0,1]` 与 `[0,-1]` 直接抵消。<br>• **`#376`（受迫 Navier–Stokes 计算）**：指出 $[0,\infty)$ 上速降函数必属 $L^1$（累积时间不可能发散至 $+\infty$），并证出快速混合导数界成立的充要条件为 $K_{n+1}/K_n \to +\infty$。 |
| **四、正文推导中的符号写反、方向颠倒与偏一硬伤（70+ 个家族）** | 原文正文的公式推导中存在大量**正负号写反、向量方向颠倒、步数偏一（off-by-one）或阶乘/常数算错**： | **逐式核算并在 101 个家族中完成公式纠偏与缺口补全**：<br>• **`#003`（拟黎曼假设）**：第 335 行把最近点位移向量写成 `n-u` 而非 `u-n`（方向颠倒，导致与外法向内积符号相反）；<br>• **`#053`（Pixton 反例）**：公式 (21) 算丢了 $-2\vartheta$ 的负号；<br>• **`#067`（六维 Campana–Peternell）**：特征类展开中的正负号、阶乘因子与秩 3 常数项算错；<br>• **`#130`（精确傅里叶变换）**：网络总步数存在 **off-by-one（偏一）** 错误，且递归阈值未证；<br>• **`#052`（切分裂）** 弄反 $dr\wedge dz$ 定向，**`#149`** 与 **`#242`** 分别跳步使用未证的含时紧性与严格模数假设。 |
| **五、未证跳步与断头桥（高达 206 个家族、554 处断言被判 `inconclusive`）** | **只证了局部代数/组合小引理，主定理整条链根本没合龙**：373 个活跃家族中全链路无条件闭合的仅 **36 族（10.1%）**；过半家族（**206 族，55.2%**）从局部引理迈向大定理时存在未证散文跳步、极限交换或奇异边界外推。 | **严格区分“已证实的局部核”与“未闭合的主定理”**：<br>• 独立 Reviewer 对全部 **554 处** 未经严格证明的上游桥接与主定理外推明确打出 `verdict = inconclusive`；<br>• 为每份形式化证书绑定 `statement_fidelity.md`，如实披露哪些步骤已由机器证实、哪些顶层几何/分析步骤仍未闭合。 |
| **六、核心硬骨头甩锅给外部文献黑盒（305 族依赖外部假设，31 族引文核查存疑，甚至所引外部定理本身为假）** | 高达 **305 个家族（81.8%）** 遇到核心硬骨头时不给自包含证明，直接甩锅给外部文献；其中多处引文条件不匹配，甚至所引外部定理本身就是错的： | **对全部外部引文做原文溯源核查（`citation_check`）与反例检验**：<br>• **所引外部定理本身为假（`#342`）**：用四维环面 $T^4$ 自对偶 2-形式直接证伪了所引外部论文 Li–Zhang (*arXiv:0708.2520v4*) 的 **4 条印刷定理**；<br>• **把“一般成员”当“全体成员”引用（`#067`）**：Kanemitsu (2016) 命题 1.6 仅适用于一般纤维，不能用于含特殊退化纤维的全局求和；<br>• **31 个家族引文核查存疑（`literature = inconclusive`）**：如 `#059` 连续 5 条极曲线引文 ICIS 条件不齐、`#048` 在奇异解析芽上直接套用代数簇 Serre 对偶与 GAGA、`#025` 固定参数界量词顺序不符。 |
| **七、官方 Lean 形式化严重缩水与未经审阅（75.6% 未映射、144 族命题缩水、残留 `axiom`/`sorry`）** | 核查 `openai/math/lean/` 源码暴露出四大硬伤：<br>1. `formalization.yaml` 官方标注 **`review: {status: unchecked}`**；<br>2. **75.6% 的论文（544/720 篇）不在主定理映射列表内**，128 族无任何 Lean；<br>3. **144 个家族（58.8%）存在严重「命题缩水」**：`lean/docs/` 自认仅形式化了砍掉几何/分析背景后的有限维矩阵或玩具子模型；<br>4. 原库 `OAI/` 下仍残留 **5 个含自定义 `axiom` 和 5 个含 `sorry` 的 `.lean` 文件**。 | **建立零 `sorry`、零自定义公理的 Lean 4.31.0 硬门禁**：<br>• 用 `lean_axiom_audit.lean` 强制拦截任何 `sorry`、`admit` 或自定义 `axiom`；<br>• 在 **314 个家族** 中跑通 **381 份零漏洞 Lean 4.31.0 证书（520,095 行、41,751 条定理）**，为原库无 Lean 的 **90 个家族（22,405 行）** 从零补齐了机器形式化。 |
| **八、参数粗糙与冗余强假设（243 个家族存在可实质收紧的次优界）** | 大量定理强加了本不需要的超多项式尺度、Fano、紧 Kähler、指数平方矩等强假设，或算出了极粗糙的常数与指数： | **在 243 个家族上同题证出更紧界或彻底扒掉多余假设**：<br>• **`#130`（精确傅里叶变换）**：取 **$h=25$ 时幂次节省间隙 $1-\theta$ 比原文 $h=100$ 构造大 $1,500$ 倍以上**；<br>• **`#113`（完美匹配计数）**：将原像上界从 $(10N)^{30}$ 压至 **$2^{17}N^8$**；<br>• **`#176`（第二 Kahn–Kalai 猜想）**：在 Lean 4 中将容量分离常数从 $16$ 压至 **$3$**；<br>• **`#164, #063, #056, #093, #291, #150`**：分别将超多项式尺度降为多项式尺度，并去掉 Fano、紧 Kähler、指数平方矩、可分性等强假设（全集审完 373 族仅耗资 **`$85.88` / 均价 `$0.23`**）。 |

### 1. OpenAI `openai/math` 全集（723 篇手稿 / 376 家族）五级可信度全景矩阵

| 可信度等级 | 家族数（占比） | 手稿篇数（占比） | 严格数学定性与审计依据 |
| :--- | :---: | :---: | :--- |
| **🟢 第一级：100% 自包含无条件可信** | **36 族** (`9.6%`) | **73 篇** (`10.1%`) | 0 外部文献假设、0 `inconclusive` 桥接、0 `refutes`；全链路通过 Lean 4.31.0 机器证明与独立复核 |
| **🔵 第二级 A：代数/组合核心 100% 过 Lean 4，顶层大定理属条件性成立** | **264 族** (`70.2%`) | **490 篇** (`67.8%`) | 承重代数/组合核通过 Lean 4.31.0 零 `sorry` 编译（含 Argus 为原库无 Lean 家族全新补齐的 **90 族**），顶层几何/解析外推依赖外部高阶文献假设（每份均附 `statement_fidelity.md` 边界披露） |
| **🟡 第二级 B：局部计算核通过，缺机器形式化且含未闭合散文/引文缺口** | **47 族** (`12.5%`) | **103 篇** (`14.2%`) | 局部精确脚本检验通过，但缺机器形式化，且包含 **31 个家族的外部引文无法独立坐实（`citation_check = inconclusive`）** |
| **🟠 第三级：所引外部已发表定理被证伪 / 候选捷径被证伪** | **5 族** (`1.3%`) | **12 篇** (`1.7%`) | 如 **`#342`**：手稿在 $T^4$ 上的自对偶 2-形式构造正确，却顺带构成了所引用的外部论文 Li–Zhang (*arXiv:0708.2520v4*) 中 **4 个印刷定理的显式反例** |
| **🔴 第四级：OpenAI 现存手稿存在实锤致命错误 / 假引理 / 假引文** | **21 族** (`5.6%`) | **42 篇** (`5.8%`) | 在未撤稿的现存论文中抓出 **28 项手稿级实锤 `refutes`**（假引文、符号撞车、上同调/生成水平算错、中间引理显式反例）；**其中 14 个家族已由 Argus 完成数学修补** |
| **⚫ 第五级：OpenAI 官方已撤稿（2026-10-07）** | **3 族** (`0.8%`) | **3 篇** (`0.4%`) | `#045, #061, #070`：因 $I(f_1)-m=-2m\neq 0$ 符号算反级联传染被官方撤下 |
| **全集总计** | **376 族** (`100%`) | **723 篇** (`100%`) | **381 份零 `sorry` Lean 4.31.0 证书（520,095 行代码、41,751 条定理/引理），67 条 `refutes` 判决（42 项独立被证伪命题）** |

### 2. 抓出的代表性实锤漏洞与 Argus 的修补 & 定理超越（详见[完整报告](docs/openai-math-audit-findings.zh-CN.md)）
- **28 项现存手稿级实锤漏洞（覆盖 21 个家族、42 篇论文）**：
  1. **引用根本不存在的外部定理（`#001` & `#320`）**：`#001` 将 Milne `SVp.pdf` §5.21 的公开设想当作已证提升定理引用（Argus 改用 **Gabber 仿射平展光滑性定理** 重构完整证明）；`#320` 在 `formal.tex:785` 引用了根本不存在的 `[MT, Lemma 3.9]`（实为 Lemma 6.7）。
  2. **上同调维数与谱生成水平全面算错（`#318`，8 项 `refutes`）**：证伪高度 5 扩张稳定子群有限 5-上同调维数（`C318EXTCD`）；证明 $p=5$ 下 $L_0 X \to L_0 L_{K(2)} X$ 在 $\pi_{-3}$ 上**非零**（`C318TAUZERO`）；并在度数 $-5$ 处证明直和分裂 $Y \simeq B_2 \vee V$，从而确立真实生成水平 **$\mathrm{level}_G(X) = 2 \neq 3$**（推翻 `C318LEVEL3` 等 4 项断言），同时将复特征标非消没模数下界从 $q>163$ 压缩 4 倍至 **$q>39$**。
  3. **跨论文同名符号撞车与 Sobolev 阶数越界（`#341`）**：抓出 `07-pencil.tex` 将 Oh–Zhu 公式 (2.18) 中的无穷维 Sobolev 截面空间 $E_0,E_1$ 与手稿的有限维求值亏格丛 $E_i$ 混为一谈；Argus 直接从一阶椭圆 Cauchy–Riemann 算子 $(w-\zeta_r)\partial\xi=0$ 重构了自包含证明。
  4. **显式代数、组合与分析反例（`#004, #046, #053, #067, #180, #201, #209, #247, #274, #316, #321, #340, #376`）**：包括 `#004` $\mathbb{Z}/9\mathbb{Z}[t]$ 挠商环反例（证明一次清除因子 $h$ 失效，必须用平方因子 $h^2$）、`#180` 四棱双锥森林配对首项相消反例、`#209` 奇素数 $y=0$ 切片在二进分圆模型中范数恒零反例、`#376` 非负速降时钟速率在 $[0,\infty)$ 上必可积从而累积时间不可能趋于 $+\infty$ 的实分析反例等。
- **全集 276 个家族（`74.0%`，涵盖 `552` 篇手稿）实现证明修补（`101` 族）或严格更强的新定理超越（`243` 族，其中 `166` 族立为报告首节头条强化定理）**：包括 **`#113`（完美匹配计数）** 将原像上界从 $(10N)^{30}$ 指数级压缩至 $2^{17}N^8$；**`#176`（第二 Kahn–Kalai 猜想）** 在 Lean 4 中证明容量分离常数可从 $16$ 降至 $3$；**`#164`（Hindman 猜想）** 将超多项式空间尺度 $Z/S^a\to\infty$ 削弱为显式有限幂次 $Z\ge \kappa S^{2Ds^{n-1}+2}$；**`#056`（四维簇翻转终止）** 去掉环境紧 Kähler 假设并升级为 discrepancy-2 赋值处双射；**`#093`（无维数对数 Sobolev 不等式）** 彻底删去指数平方矩假设 $\mathbb{E}_p[\exp(c|Y|^2)]<\infty$；**`#291`（一致性质 $\Gamma$）** 从单一可分 $C^*$ 代数推广至非可分坐标的混合超积；以及 **`#321`（Wall $D(2)$ 问题）** 构造出对一切域上一维标量特征标不可见、唯独被 24 阶二维酉局部系统捕获的新 $(1,6,7,2)$ 复形。

---

## 算力效率与全部 84 个成果包实际扣费全表（`usage.jsonl` 精确账单）

Argus 所有数学战役均以**单守护进程分级工作流**（`Planner -> Engineer -> Independent Reviewer`，`mission_width=1`）运行，结合 `Proof Ledger`（`MATH_STATE.json` 内容哈希账本）与确定性侧车（`Jacobian`、`PARI/GP`、`Lean 4`）。经对全部 **150 份 `usage.jsonl` 原始账单**逐条汇总（完整报告见 [`docs/usage-and-cost-audit.md`](docs/usage-and-cost-audit.md) 与 [`data/usage-audit.json`](data/usage-audit.json)），产出**全部 84 个正式成果包**累计仅调用 **8,877 次**（**8,821.0** 个计费请求，**76.13 亿 tokens**），**全项目历史总实际扣费仅 `$352.84`（平均每个成果包仅 `$4.20`！）**：

- **53 个独立专项攻关战役（8月–11月全部单题战役）**：共调用 `8,096` 次（`8,005.0` 个请求，`63.70 亿` tokens），合计实际扣费 **`$320.20`（平均每题 `$6.04`）**；其中 **11月 20 个新定理攻关战役合计仅花费 `$71.68`（平均每证出一道新定理仅 `$3.58`）**。
- **31 个批量审计与反例筛查成果包（Batch 001 与 757 题全量审计分片）**：共调用 `781` 次（`816.0` 个请求，`12.43 亿` tokens），合计实际扣费 **`$32.64`（分摊到 31 个成果包平均每个仅 `$1.05`）**。

<details open>
<summary><strong>展开查看全部 53 个专项战役 + 31 个批量审计包（共 84 个成果包）实际扣费明细全表</strong></summary>

| 题号 | 成果包名称 | 使用模型 | 调用次数 | 计费请求数 | 累计 Tokens | 11月冲刺扣费 | 累计总实际扣费 (`$0.04`/次) |
|---|---|---|---:|---:|---:|---:|---:|
| [`11000263`](results/11000263/) | Twist-compatible Burau quotient and universal finite-dimensionality for Bigelow's zipper algebra | `gpt-5.6-sol` | 6 | 6.0 | 6.48M | — | **`$0.24`** |
| [`2813`](results/2813/) | An explicit taut-foliation Euler-class obstruction on a hyperbolic mapping torus | `gpt-5.6-sol` | 10 | 10.0 | 1.77M | — | **`$0.40`** |
| [`1275`](results/1275/) | Essential-Spectrum Obstruction for Finite-Shift Dilation Restrictions in Hilbert-Polya Realizations | `gpt-6-astra` | 16 | 16.0 | 7.93M | $0.64 | **`$0.64`** |
| [`2457`](results/2457/) | Countermodel to the Arvidsson heat-trace bounded-kernel implication (Erdos Problem #1055) | `gpt-5.6-sol` | 20 | 23.0 | 0.00M | — | **`$0.92`** |
| [`2662`](results/2662/) | Reidemeister-II collapse of two-change local plat families for unknotting and Conway mutation (Kirby 1.3) | `gpt-5.6-sol, gpt-6-astra` | 23 | 23.0 | 9.62M | — | **`$0.92`** |
| [`2775`](results/2775/) | Complete solution classification of the (A_12, 1, A_12) projection fiber for braid and right-angled Artin groups | `gpt-5.6-sol, gpt-6-astra` | 25 | 25.0 | 44.79M | — | **`$1.00`** |
| [`2307015`](results/2307015/) | A translated-cusp boundary set of positive harmonic measure | `gpt-5.6-sol` | 26 | 26.0 | 22.34M | — | **`$1.04`** |
| [`1921`](results/1921/) | Uniform degree bounds excluding bounded offset-signature colorings for Erdos Problem #87 | `gpt-5.6-sol` | 27 | 27.0 | 0.67M | — | **`$1.08`** |
| [`40`](results/40/) | Conformal Transfer and Curvature-Response Closure for Axisymmetric Euler Flows in Periodic Variable-Radius Pipes | `gpt-6-astra` | 34 | 34.0 | 40.98M | $1.36 | **`$1.36`** |
| [`3102`](results/3102/) | The Support-At-Most-Five Pebbling Number of the Lemke Square Is 64 | `gpt-6.1-sol` | 36 | 36.0 | 22.80M | $1.44 | **`$1.44`** |
| [`7200051`](results/7200051/) | Quantitative Distortion Bounds and Formal Equilateral Exclusion for Eleven Points in Five-Dimensional l_1 | `gpt-6.1-sol` | 44 | 44.0 | 24.19M | $1.76 | **`$1.76`** |
| [`2800203`](results/2800203/) | Threshold discrepancy barriers for depth-three scalar planted-clique AMP schedules | `gpt-5.6-sol, gpt-6-astra` | 49 | 49.0 | 79.04M | — | **`$1.96`** |
| [`1994`](results/1994/) | Bottom-row quadratic reduction and scalar-span obstruction on rank-four parabolic Erdos-Ulam configurations | `gpt-5.6-sol, gpt-6-astra` | 49 | 50.0 | 12.14M | — | **`$2.00`** |
| [`3167`](results/3167/) | Sheehan's Conjecture for Four-Regular Simple Graphs of Bounded Treewidth | `gpt-6.1-sol` | 54 | 54.0 | 42.76M | $2.16 | **`$2.16`** |
| [`20001352`](results/20001352/) | Literal-scope counterexample for commutator width and involution factorization in Thompson's group F (AIMPL Problem 3.1) | `gpt-5.6-sol, gpt-6-astra` | 60 | 57.0 | 4.31M | — | **`$2.28`** |
| [`2884`](results/2884/) | K3 Problem 4.8: arbitrary-X stabilization counterexample and fixed-E(2) PL/smooth seven-arrow construction | `gpt-5.6-sol` | 60 | 60.0 | 100.90M | — | **`$2.40`** |
| [`20000278`](results/20000278/) | An irrational non-Q-Gorenstein F-jumping number in characteristic 13 (AIM Problem 1.3) | `gpt-6-astra` | 62 | 61.0 | 22.53M | — | **`$2.44`** |
| [`20001602`](results/20001602/) | Commensurated subgroups of branch groups: missing just-infinite hypothesis and Hanoi group counterexample | `gpt-6-astra` | 62 | 62.0 | 14.58M | — | **`$2.48`** |
| [`20001849`](results/20001849/) | Flying wings refute uniqueness of the collapsed product steady Ricci soliton (AIMPL Problem 6.7) | `gpt-5.6-sol, gpt-6-astra` | 65 | 63.0 | 11.20M | — | **`$2.52`** |
| [`20001516`](results/20001516/) | A CAT(0) free-by-cyclic group that is not ordinary RFRS (AIM Problem 5.3) | `gpt-6-astra` | 67 | 66.0 | 14.84M | — | **`$2.64`** |
| [`2669`](results/2669/) | Handle-slide unlink orbit reduction on staged-framing two-component link presentations (Property R) | `gpt-5.6-sol, gpt-6-astra` | 69 | 66.0 | 24.52M | — | **`$2.64`** |
| [`1900020`](results/1900020/) | Diagonal quadratic energy contraction on section returns of the cubic Jacobi-Perron algorithm | `gpt-5.6-sol, gpt-6-astra` | 71 | 71.0 | 85.89M | — | **`$2.84`** |
| [`3256`](results/3256/) | Weighted Dijoin Packing in One-Edge Deletions of Chordal Digraphs | `gpt-6.1-sol` | 72 | 72.0 | 52.53M | $2.88 | **`$2.88`** |
| [`1417`](results/1417/) | A Uniform Square-Root Edge-Deficit Bound for Strongly Critical Graphs Avoiding Four- and Eight-Cycles | `gpt-6-astra, gpt-6.1-sol` | 76 | 73.0 | 30.62M | $1.36 | **`$2.92`** |
| [`2862`](results/2862/) | Co-normalizer orthogonal join reduction and rational Chern-Simons volume on one-angle spherical bar cycles | `gpt-5.6-sol, gpt-6-astra` | 73 | 73.0 | 12.43M | — | **`$2.92`** |
| [`1413`](results/1413/) | Girth-five 77-matching prefix certificate in the search for a degree-57 Moore graph | `gpt-5.6-sol` | 82 | 81.0 | 100.77M | — | **`$3.24`** |
| [`20001904`](results/20001904/) | A six-point positive-weight obstruction to degree-four Hermite curvature repairs on manifolds without conjugate points | `gpt-5.6-sol, gpt-6-astra` | 82 | 82.0 | 75.04M | — | **`$3.28`** |
| [`6800022`](results/6800022/) | Complete Global Embeddedness Obstruction for the Reciprocal-Reflection Kato-Muroya Genus-One Four-Catenoidal-End Locus | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 88 | 88.0 | 102.65M | $1.16 | **`$3.52`** |
| [`20000786`](results/20000786/) | Hasse-Witt matrix vanishing and cubic scalar cancellation on the k=3 quartic reduction branch | `gpt-5.6-sol, gpt-6-astra` | 89 | 89.0 | 111.66M | — | **`$3.56`** |
| [`20001675`](results/20001675/) | Arbitrary-Depth Exponential HOMFLY-PT Fibers over Quiver Point-Counting Polynomials of Plabic Links and Knots | `gpt-6.1-sol` | 93 | 93.0 | 69.23M | $3.72 | **`$3.72`** |
| [`8`](results/8/) | Reduction of the minimal-101 root-4 odd perfect number branch to the single factor Phi_31(269) | `gpt-5.6-sol, gpt-6-astra` | 96 | 96.0 | 15.01M | — | **`$3.84`** |
| [`1138`](results/1138/) | Bielliptic Half-Fiber and Dyadic Picard-Torsion Obstructions on Enriques Surfaces | `gpt-6-astra` | 97 | 97.0 | 97.44M | $3.88 | **`$3.88`** |
| [`20001274`](results/20001274/) | Congruent plane projections do not determine a convex body up to translation or reflection | `gpt-6-astra` | 103 | 102.0 | 14.76M | — | **`$4.08`** |
| [`3059`](results/3059/) | The Alon-Jaeger-Tarsi Conjecture in Dimensions Eight and Nine over F_5 | `gpt-6.1-sol` | 111 | 111.0 | 106.72M | $4.44 | **`$4.44`** |
| [`3395`](results/3395/) | Centered Nuclear Duality and Relative-Mass Obstructions in Monotone Boolean Circuit Lower Bounds | `gpt-6-astra` | 122 | 119.0 | 129.04M | $4.76 | **`$4.76`** |
| [`9400078`](results/9400078/) | Unconditional Exceptional-Parameter Density Bounds for Ramified GL_4 Automorphic Representations | `gpt-6-astra` | 144 | 143.0 | 56.57M | $5.72 | **`$5.72`** |
| [`1380`](results/1380/) | Exact rational sign-cell exclusion on the balanced (2,2,2,2) Heilbronn configuration space | `gpt-5.6-sol, gpt-6-astra` | 145 | 144.0 | 121.94M | — | **`$5.76`** |
| [`20002392`](results/20002392/) | Velocity-Only Exclusion of Backward Self-Similar Navier-Stokes Profiles in a Half-Space | `gpt-6-astra` | 150 | 145.0 | 39.00M | $5.80 | **`$5.80`** |
| [`20000582`](results/20000582/) | Moving-window Engel Hilbert cocycles with Omega(sqrt(k)) homogeneous gauge distortion | `gpt-5.6-sol, gpt-6-astra` | 152 | 152.0 | 437.17M | — | **`$6.08`** |
| [`1285`](results/1285/) | An Unconditional Exponential Worst-Case Lower Bound for Adaptive Signed-Chain Elliptic Curve Factorization Programs | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 157 | 155.0 | 93.52M | $1.24 | **`$6.20`** |
| [`2305027`](results/2305027/) | A signed Cauchy-Green flux identity and linear residual lower bound on planar corona corrections | `gpt-5.6-sol, gpt-6-astra` | 161 | 165.0 | 84.57M | — | **`$6.60`** |
| [`20001578`](results/20001578/) | Exact quotient-multiplicity exclusion of 18-element equality candidates in Thompson's group F | `gpt-5.6-sol, gpt-6-astra` | 182 | 182.0 | 272.80M | — | **`$7.28`** |
| [`2338`](results/2338/) | Diophantine Obstructions, Degree-120 S-Unit Descent, and Affine Orthogonal Runge Theorems for Multiplicity Five in Pascal's Triangle | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 188 | 188.0 | 194.53M | $5.76 | **`$7.52`** |
| [`1243`](results/1243/) | Unconditional Global Squareclasses, Genus-161 Rational-Point Classification, and Map Rigidity on Bremner's Octic K3 Surface | `gpt-5.6-sol, gpt-6.1-sol` | 204 | 192.0 | 71.54M | $6.92 | **`$7.68`** |
| [`8200002`](results/8200002/) | A 39-dimensional Arb Krawczyk interval certificate for the third Fourier fibre in dimension six | `gpt-5.6-sol, gpt-6-astra` | 239 | 239.0 | 417.23M | — | **`$9.56`** |
| [`1187`](results/1187/) | Global Nonexistence of Twisted Bridges in F_2-Magnus Quotients and Six-Conjugate Primitive Exclusion for Andrews-Curtis Candidates | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 249 | 246.0 | 113.91M | $7.72 | **`$9.84`** |
| [`1518`](results/1518/) | An Unconditional Sixth-Energy Saving for Riemann Zeta Zeros and a Local Prime-Window Exceptional-Pair Bound | `gpt-5.6-sol, gpt-6-astra, gpt-6.1-sol` | 269 | 266.0 | 104.23M | $5.04 | **`$10.64`** |
| [`9400114`](results/9400114/) | Target-Free Prime-Power Reduction, Short-Arc Cubic Obstructions, and Inverse-Frobenius Classifications for Agrawal's Conjecture | `gpt-6-astra, gpt-6.1-sol, mai-code-1.1-flash` | 303 | 298.0 | 202.21M | $3.92 | **`$11.92`** |
| [`2248`](results/2248/) | Baier-Zhao dispersion scale barriers for quadratic-prime representations n = a p^2 + b (Erdos #676) | `gpt-5.6-sol, gpt-6-astra` | 309 | 311.0 | 500.20M | — | **`$12.44`** |
| [`20000715`](results/20000715/) | Differential equations and linear-ODE obstructions for eta-products (AIM Problem 1.2) | `gpt-5.6-luna, gpt-5.6-sol, gpt-6-astra` | 426 | 426.0 | 33.14M | — | **`$17.04`** |
| [`1465`](results/1465/) | Fu 2026 Theorem 2.8: regularity-premise local-finiteness gap | `gpt-5.6-sol, gpt-6-astra` | 777 | 778.0 | 1431.73M | — | **`$31.12`** |
| [`20001036`](results/20001036/) | A 5,454-vertex multi-label counterexample to Seymour-Sullivan Conjecture 6.1 and prototype optimality | `gpt-5.6-sol, gpt-6-astra` | 891 | 883.0 | 606.40M | — | **`$35.32`** |
| [`20000816`](results/20000816/) | Distinct Hilbert-scheme components sharing a complete unlabelled Grobner fan (AIM Problem 15 / 1.35) | `gpt-5.6-sol, gpt-6-astra` | 995 | 987.0 | 77.31M | — | **`$39.48`** |
| **31 个批量/分片成果包** | 共享审计分片（`shard-01`、`shard-02`、`batch-001`、`open-audit`）产出其余 31 个成果包（均摊 `$1.05`/包） | `gpt-5.6-sol, gpt-6-astra` | 781 | 816.0 | 1,243.08M | — | **`$32.64`** |
| **全部 84 个成果包总计** | **53 个专项战役 + 31 个批量分片成果包（150 份 `usage.jsonl` 账单）** | **综合** | **8,877** | **8,821.0** | **7,613.25M (`76.13亿`)** | **`$71.68`（均 `$3.58`/题）** | **`$352.84`（均 `$4.20`/包）** |

</details>
---

## 核心代表作（Featured Flagship Breakthroughs）

### 1. [`#20001036`](results/20001036/) — 推翻 Paul Seymour 与 Blair Sullivan 的彩虹可达性猜想（Conjecture 6.1）及 5,454 顶点零间隙最优性证明（[论文 PDF](results/20001036/ARGUS_RESULT_20001036_TECHNICAL_REPORT.pdf)）
* **问题背景**：Sullivan 综述（*arXiv:math/0605646* 第 6 页 **Conjecture 6.1 (Seymour, Sullivan)**）提出了同时蕴含「Seymour 第二邻域猜想」与「Caccetta–Häggkvist 猜想」的彩色母猜想：设简单有向图 $G=(V,E)$ 带边子集 $E_1,\ldots,E_k\subseteq E(G)$，是否必有彩虹有向圈，或存在顶点 $v$ 使彩虹有向路可达顶点数 $|R(v)| \ge \sum_{i=1}^k d^+_{G_i}(v)$？该猜想自 2006 年提出以来 20 年未决。
* **Argus 成果**：先用 C++ 穷举 $n\le 4, k\le 3$ 的全部 $34{,}012{,}224$ 种构型并用 $1{,}854$ 个整数 Farkas 对偶证书证明 $n\le 4$ 独立集吹胀绝无反例；随后在 $k=6$ 色、$16$ 顶点无双向边（digon-free）原型上求得整数吹胀向量 $m=(1096,8,23,69,244,755,1,1059,1,1,1131,1,1,1,1,1062)$，构造出 **5,454 个顶点、11,792,572 条有向弧的严格定向简单图（无自环、无重边、无双向边）**，图中**不存在任何彩虹有向圈**，且**每一个顶点 $v$ 均严格违反可达性下界**（$\sum_{i=1}^6 d^+_{G_i}(v) - |R(v)| \ge 1$；取 $2m$ 即 $10{,}908$ 顶点时连包含 0 步平凡路也严格违反）。同时通过整数对偶乘子与 SMT（`optimality-certificate.json`）证明了 5,454 是该 16 点原型上的理论绝对最小值（整性间隙为 $0$）。

### 2. [`#11000263`](results/11000263/) — Bigelow 拉链代数问题：$X_3 \neq 0$ 反例与对一切 $n \ge 4$ 普适商有限维定理（[论文 PDF](results/11000263/ARGUS_RESULT_11000263_TECHNICAL_REPORT.pdf)）
* **成果**：(1) 在 $u=q^3$ 的非约化 twist 相容 Burau 表示下算出 $\rho(X_3)=(q-u)(q^2-u)E_2 \neq 0$ 且 $X_4=0$，否定 $n=3$ 消没猜想并给出满射到 BMW 代数且核非零的有限维商；(2) 无条件证明**对一切 $n \ge 4$**，Bigelow 拉链代数的普适商 $Q_n$ 均是**有限维代数**，维数满足 $(2n-1)!! + 1 \le \dim Q_n \le (2n-1)!! + (n!/3)^2$。

### 3. [`#3059`](results/3059/) — 完整证明 $\mathbb{F}_5$ 上 $8$ 维与 $9$ 维的 Alon–Jaeger–Tarsi 无零坐标猜想（[论文 PDF](results/3059/ARGUS_RESULT_3059_TECHNICAL_REPORT.pdf)）
* **成果**：针对素数域 $5\le p\le 61$ 上长期开放的 Alon–Jaeger–Tarsi 猜想，无条件证明了 **$\forall A \in \mathrm{GL}_n(\mathbb{F}_5)$（$n \in \{8,9\}$），必存在无零分量向量 $x \in (\mathbb{F}_5^\times)^n$ 使得 $Ax \in (\mathbb{F}_5^\times)^n$**。证明结合了三拷贝水平永久式秩放大定理（解决 $\operatorname{perrank}\ge 6$）与极小永久式秩 $5$ 下的 Schur 补零剖面分类（证明 $A$ 或 $A^{-1}$ 必有一列至多含 3 个非零元，从而归约到 8 维）。

### 4. [`#3102`](results/3102/) — Ronald Graham 笛卡尔积 Pebbling 猜想：证明 Lemke 平方图 $L \mathbin{\square} L$ 支撑集 $\le 5$ 的精确阈值为 $64$（[论文 PDF](results/3102/ARGUS_RESULT_3102_TECHNICAL_REPORT.pdf)）
* **成果**：将 2024 年文献仅证到支撑集 $\le 4$ 的结果推进一阶——通过分叉臂纤维保持引理与多阶段整数放电覆盖，完整验证全部 $181$ 个有根顶点对轨道、$701$ 个支撑模板与 $723$ 个远距重堆整数分配，严格证明 64 顶点 Lemke 平方图 $L \mathbin{\square} L$ 上**任意支撑集大小 $\le 5$ 的 64-pebble 配置均可到达任意目标根顶点**（$\pi_{\le 5}(L\mathbin{\square} L)=64$）。

### 5. [`#1243`](results/1243/) — 3×3 平方数幻方：Bremner 八次 K3 曲面亏格 161 覆盖的有理点无条件完全分类与映射刚性定理（[论文 PDF](results/1243/ARGUS_RESULT_1243_TECHNICAL_REPORT.pdf)）
* **成果**：在不依赖 GRH 与 $\amalg$ 有限性的前提下，证明 18 次二等分域 $K/\mathbb{Q}$ 类数为奇数、12 个 Simon 生成元张成完整的范数平方类核，并结合 Cassels–Tate 配对证明 6 次椭圆覆盖满足 $\dim_{\mathbb{F}_2}\mathrm{Sel}_2(E/k)=3$、$\operatorname{rank} E(k)=1$ 及 $\amalg(E/k)[2^\infty]\cong(\mathbb{Z}/2\mathbb{Z})^2$。结合 $p=23$ Chabauty–Coleman 闭合，证明亏格 161 三平方覆盖曲线 $X(\mathbb{Q})$ 仅有 $x=-1$ 上方的 8 个碰撞有理点，几何 gonality 为 8，$\mathrm{Aut}_{\mathbb{Q}}(X)\cong(\mathbb{Z}/2\mathbb{Z})^3$，且不存在到 Bremner 亏格 57 曲线的非常数有理态射。

### 6. [`#1138`](results/1138/) — 整系数霍奇猜想：二进 Enriques 乘积普适全迷向定理（$\dim_{\mathbb{F}_2} D_C \ge g$）与算术消失圈最大缺陷定理（$\operatorname{Hdg}^4/\operatorname{cl}(\mathrm{CH}^2) \simeq (\mathbb{Z}/2\mathbb{Z})^4$）（[论文 PDF](results/1138/ARGUS_RESULT_1138_TECHNICAL_REPORT.pdf) · [`universal_isotropy.md`](results/1138/universal_isotropy.md) · [`arithmetic_defect.md`](results/1138/arithmetic_defect.md)）
* **成果**：
  1. **普适全迷向定理（彻底去掉 Benoist–Ottem 2020 的 very general 假设）**：Benoist–Ottem (2020, *Comment. Math. Helv.*) 的主定理仅能对“非常一般（very general）”曲线证明整系数霍奇猜想在 $C\times S$ 上失效。我们在 $\mathbb{Q}(\sqrt{2})$ 上显式构造出具有二进光滑射影模型与有限平坦 Picard 挠群 $G_{\pi,\pi}$（$\pi^2=2$）的 Enriques 曲面 $S_{\text{new}}$，结合 Knudsen–Mumford 完美复形上同调行列式、Raynaud 半稳定曲线 Picard 专门化与 SGA~7~I Poincaré 双扩张，无条件证明：对**任意亏格 $g\ge 1$ 的光滑射影连通复曲线 $C$（无需任何“非常一般”或数域定义假设）**，代数对应拉回子空间 $A_C = \{Z^*\alpha : Z \in \mathrm{CH}_1(C\times S_{\text{new}})\} \subset H^1(C,\mathbb{F}_2)$ 关于杯积**恒为全迷向子空间（totally isotropic）**，从而
     $$\dim_{\mathbb{F}_2} A_C \le g \implies \dim_{\mathbb{F}_2} D_C = 2g - \dim_{\mathbb{F}_2} A_C \ge g,$$
     即整系数霍奇猜想在 $C \times S_{\text{new}}$ 上对**每一条**正亏格光滑复曲线 $C$ 均不成立，且缺陷维数至少随亏格 $g$ 线性增长！
  2. **算术消失圈界与满维最大缺陷 $(\mathbb{Z}/2\mathbb{Z})^4$ 无穷曲线族（[`arithmetic_defect.md`](results/1138/arithmetic_defect.md)）**：进一步证明算术消失圈正交界 $A \subseteq W^\perp$（$\dim_{\mathbb{F}_2} D_C \ge \dim_{\mathbb{F}_2} W$），并在对角 Enriques 商曲面 $S = T/\langle\iota\rangle \subset \mathbb{P}^5_{\mathbb{Q}}$ 与显式亏格 2 曲线无穷族 $C_t: y^2 = x^5 - x - 1 + 1083t$（$t\in\mathbb{Z}$，含无穷多个几何不同构类）上证明全体复代数闭链拉回 $A_{C_t}=\{0\}$ 彻底归零，使四次整系数霍奇缺陷群达到**理论绝对上限 $(\mathbb{Z}/2\mathbb{Z})^{2g} = (\mathbb{Z}/2\mathbb{Z})^4$**！

### 7. 其它新近完成的可发表级定理精选（[`#20001675`](results/20001675/)、[`#1187`](results/1187/)、[`#1285`](results/1285/)、[`#1518`](results/1518/)、[`#1417`](results/1417/)、[`#3167`](results/3167/)、[`#3256`](results/3256/)、[`#7200051`](results/7200051/)、[`#9400114`](results/9400114/)）
* **[`#20001675`](results/20001675/) ([PDF](results/20001675/ARGUS_RESULT_20001675_TECHNICAL_REPORT.pdf))**：针对 Galashin–Lam 丛代数 Plabic 图问题，对任意射流深度 $r\ge 1$ 与字长 $m\ge 1$ 构造出 $2^m$ 个连通简单 plabic 单分支纽结（knots），它们共享完全相同的 $\mathbb{F}_q$ 箭图点计数多项式 $R(q)$、相同的 Alexander 多项式及 $a=1$ 处 $<r$ 阶全部导数，却产生 **$2^m$ 个两两不同的双变量 HOMFLY-PT 多项式**（$\log_2|\text{fiber}|\ge (N-8)/(74r^2)$），并通过两变量交错多项式（interlace polynomial）完整刻画其森林不变量。
* **[`#1187`](results/1187/) ([PDF](results/1187/ARGUS_RESULT_1187_TECHNICAL_REPORT.pdf))**：Andrews–Curtis 猜想：在 121 维与 3,906 维截断 $\mathbb{F}_2$-Magnus 代数中证明标准候选表示 $P_2, P_0$ 的扭曲桥方程对任意字长无解，并证明秩 2 候选子群的原元共轭宽度满足 **$w_{\mathrm{prim}}(H)\ge 7$**。
* **[`#1285`](results/1285/) ([PDF](results/1285/ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf))**：无条件证明任何自适应带符号链椭圆曲线分解（ECM）壳库程序在平衡无平方因子 $n$ 比特半素数 $N_n=p_nq_n$ 上的最坏情况指数级比特操作下界。
* **[`#1518`](results/1518/) ([PDF](results/1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf))**：用短磨光零点检测器证明黎曼 $\zeta(s)$ 零点在 $|\sigma-7/8|\le 10^{-3}$ 邻域的**六阶加性能量无条件幂次节省 $\delta=1/200$**，并导出第二 Hardy–Littlewood 猜想在 $\log_N H \approx 5/12$ 处的异常对上界 $V(N,H)\ll_\varepsilon N^{19/15 - 1/10000 + \varepsilon}$。
* **[`#1417`](results/1417/) ([PDF](results/1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf))**：强最小度 3 临界无 $C_4,C_8$ 图的参数统一平方根边亏损定理 $n \le \max\{8d, 4d^2-8d\} \le 4d^2$（将 Erdős–Gyárfás 极小反例边数上界压至 $m \le 2n - \max\{7, \lceil 1+\sqrt{n+4}/2\rceil\}$）。
* **[`#3167`](results/3167/) ([PDF](results/3167/ARGUS_RESULT_3167_TECHNICAL_REPORT.pdf))**：无条件证明所有**树宽 $\operatorname{tw}(G)\le 5$** 的有限简单 4-正则哈密顿图必有至少两个不同的无向哈密顿圈（遍历 6 顶点边界袋的全部 $152{,}441$ 个带标状态、$88{,}107{,}797$ 个正路由条目与 $25{,}209{,}843{,}635$ 个相对边界序，未覆盖目标数为 $0$）。
* **[`#3256`](results/3256/) ([PDF](results/3256/ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf))**：完整解决 Schrijver (1980) 以来悬置 46 年的加权 Dijoin 打包可达性缺陷阈值问题——无条件证明对任意非负整数容量 $w$ 与任意 $q\ge 1$，当强连通缩合图的不可达源汇对数满足 **$\operatorname{def}(D)\le 2$** 时恒有 $\nu(D,w)=\tau(D,w)$（而 $\operatorname{def}(D)\ge 3$ 被 Schrijver 反例证伪，故阈值 $d=2$ 绝对紧），并推广至全体单边缺失弦图。
* **[`#7200051`](results/7200051/) ([PDF](results/7200051/ARGUS_RESULT_7200051_TECHNICAL_REPORT.pdf))**：证明 $\ell_1^5$ 空间 11 点最小失真比满足 $\frac{3089}{3084} < \Delta_5(11) \le \frac{115}{106}$，并完成 $e(\ell_1^5)=10$ 的 Lean 4.33.1 内核形式化核验。
* **[`#9400114`](results/9400114/) ([PDF](results/9400114/ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf))**：Agrawal 素性猜想的无目标素数幂根基约化、短弧有理交比显式三次方下界 $p \ge \max\{r^2+2, 1+N(\lfloor(r-1)/4\rfloor)\} \sim r^3/768$ 及逆 Frobenius 分圆范数完整分类。

---

## 全部 84 个成果包完整分类目录

### 一、公开猜想的旗舰反例与可发表新定理（22 项）

| 编号 | 论文 | 成果名称与核心结论 | 领域 | 状态 |
|---|---|---|---|---|
| [`20001036`](results/20001036/) | [PDF](results/20001036/ARGUS_RESULT_20001036_TECHNICAL_REPORT.pdf) | Seymour–Sullivan 猜想 6.1（彩虹可达性）的 5,454 顶点严格定向图反例与 16 点原型零间隙最优性证明 | 有向图与组合优化 | 已独立验证反例与最优性定理 |
| [`11000263`](results/11000263/) | [PDF](results/11000263/ARGUS_RESULT_11000263_TECHNICAL_REPORT.pdf) | Bigelow 拉链代数的 twist Burau 商（$X_3\neq 0, X_4=0$）与全 $n\ge 4$ 普适商有限维定理 | 辫群与代数表示论 | 已独立验证反例与全 $n$ 定理 |
| [`3059`](results/3059/) | [PDF](results/3059/ARGUS_RESULT_3059_TECHNICAL_REPORT.pdf) | 证明 $\mathbb{F}_5$ 上 8 维与 9 维 Alon–Jaeger–Tarsi 无零坐标猜想（`C3059N9`, `H8C3059`） | 组合代数与有限域 | 已独立验证可发表定理 |
| [`3102`](results/3102/) | [PDF](results/3102/ARGUS_RESULT_3102_TECHNICAL_REPORT.pdf) | 证明 Lemke 平方图 $L\mathbin{\square} L$ 在支撑集 $\le 5$ 下的精确 Pebbling 数为 64 | 图论与组合优化 | 已独立验证可发表定理 |
| [`3167`](results/3167/) | [PDF](results/3167/ARGUS_RESULT_3167_TECHNICAL_REPORT.pdf) | 证明树宽 $\mathrm{tw}\le 5$ 的有限简单 4-正则哈密顿图必有至少两个哈密顿圈（Sheehan 猜想） | 结构图论 | 已独立验证可发表定理 |
| [`3256`](results/3256/) | [PDF](results/3256/ARGUS_RESULT_3256_TECHNICAL_REPORT.pdf) | 加权 Woodall Dijoin 打包的源汇不可达缺陷紧阈值定理（$\operatorname{def}(D)\le 2$ 对任意整容量 $q\ge 1$ 成立，$d\ge 3$ 失效）与单边缺失弦图定理 | 组合优化与有向图 | 已独立验证可发表定理 |
| [`7200051`](results/7200051/) | [PDF](results/7200051/ARGUS_RESULT_7200051_TECHNICAL_REPORT.pdf) | $\ell_1^5$ 空间 11 点失真比上下界 $3089/3084 < \Delta_5(11) \le 115/106$ 与 $e(\ell_1^5)=10$ 的 Lean 4.33.1 核验 | 离散与度量几何 | 已独立验证上下界与 Lean 4 核验 |
| [`1417`](results/1417/) | [PDF](results/1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf) | 强最小度 3 临界无 $C_4,C_8$ 图的平方根边亏损定理 $n\le\max\{8d,4d^2-8d\}\le 4d^2$（Erdős–Gyárfás） | 极值与结构图论 | 已独立验证改进上界定理 |
| [`1518`](results/1518/) | [PDF](results/1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf) | 黎曼 $\zeta$ 零点在 $\sigma\approx 7/8$ 处的六阶加性能量无条件节省（$\delta=1/200$）与素数窗口异常对上界 | 解析数论 | 已独立验证可发表定理 |
| [`1243`](results/1243/) | [PDF](results/1243/ARGUS_RESULT_1243_TECHNICAL_REPORT.pdf) | 3×3 平方数幻方 Bremner K3 曲面 18 次域平方类完备性、$\operatorname{rank} E(k)=1$、亏格 161 有理点完全分类与刚性 | 算术几何与丢番图方程 | 已独立验证可发表定理 |
| [`1187`](results/1187/) | [PDF](results/1187/ARGUS_RESULT_1187_TECHNICAL_REPORT.pdf) | Andrews–Curtis 候选表示在 4/5 阶 $\mathbb{F}_2$-Magnus 商群中的扭曲桥不存在定理、全 $\mathrm{Aut}(F_2)$ 排除与 $w_{\mathrm{prim}}(H)\ge 7$ | 组合与几何群论 | 已独立验证可发表定理 |
| [`9400114`](results/9400114/) | [PDF](results/9400114/ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf) | Agrawal 猜想的无目标素数幂根基约化、短弧交比显式三次方下界 $p\gg r^3$ 与逆 Frobenius 分类 | 计算与代数数论 | 已独立验证可发表定理 |
| [`2338`](results/2338/) | [PDF](results/2338/ARGUS_RESULT_2338_TECHNICAL_REPORT.pdf) | 杨辉三角重数 5 素因子下界（$K(a)\ge 8, \omega(a)\ge 7, 14$）、一致渐近上界 $m(a)\le\omega(a)$、仿射正交群 Runge 定理与 512 次（亏格 1537）超特殊 2-群 $2_+^{1+8}$ 覆盖阻碍（Erdős #849） | 丢番图方程与代数数论 | 已独立验证可发表定理 |
| [`6800022`](results/6800022/) | [PDF](results/6800022/ARGUS_RESULT_6800022_TECHNICAL_REPORT.pdf) | 互反反射对称 Kato–Muroya 亏格 1 四悬链端极小曲面轨迹全部 9 种穿孔分布的全局嵌入不存在定理 | 微分几何与极小曲面 | 已独立验证可发表定理 |
| [`1285`](results/1285/) | [PDF](results/1285/ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf) | 一致自适应符号链 ECM 壳库整数分解程序在 $n$ 比特无平方因子半素数上的最坏情况无条件指数下界 | 计算数论与算术复杂性 | 已独立验证可发表定理 |
| [`20001675`](results/20001675/) | [PDF](results/20001675/ARGUS_RESULT_20001675_TECHNICAL_REPORT.pdf) | 任意喷流深度 $r\ge 1$ 下简单非约化 Plabic 纽结的指数级 HOMFLY-PT 纤维定理（$\log_2|\text{fiber}|\ge(N-8)/(74r^2)$） | 丛代数与纽结多项式 | 已独立验证可发表定理 |
| [`20000816`](results/20000816/) | [PDF](results/20000816/ARGUS_RESULT_20000816_TECHNICAL_REPORT.pdf) | $\mathrm{Hilb}^{4803}(\mathbb{A}^{20}_{\mathbb{C}})$ 不同不可约分支在稠密开集上共享完整无标签 Gröbner 扇 | 代数几何与计算交换代数 | 已独立验证反例（AIM Problem 1.35） |
| [`20000278`](results/20000278/) | [PDF](results/20000278/ARGUS_RESULT_20000278_TECHNICAL_REPORT.pdf) | 特征 13 非 $\mathbb{Q}$-Gorenstein 局部整环的无理 $F$-跳跃数 $\lambda=(53609-\sqrt{17})/48$ | 交换代数与正特征奇点 | 已独立验证反例（AIM Problem 1.3） |
| [`2884`](results/2884/) | [PDF](results/2884/ARGUS_RESULT_2884_TECHNICAL_REPORT.pdf) | K3 Problem 4.8 任意 $X$ 稳定化反例与固定 $E(2)_{6_3}\to E(2)_{19nh_{78}}$ 七步 PL/光滑构造 | 光滑四维流形与纽结手术 | 已独立验证反例与构造定理 |
| [`1465`](results/1465/) | [PDF](results/1465/ARGUS_RESULT_1465_TECHNICAL_REPORT.pdf) | Fu 2026 定理 2.8 正则性局部有限前提漏洞及 Lean 4 逻辑核心验证 | 模型论与 o-极小结构 | 已独立验证前提反例 |
| [`20001849`](results/20001849/) | [PDF](results/20001849/ARGUS_RESULT_20001849_TECHNICAL_REPORT.pdf) | Flying wings ($n=3,\alpha=1/2$) 反驳全尺度空间塌缩下三维稳态 Ricci 孤立子唯一性 | 微分几何与 Ricci 流 | 已独立验证反例（AIMPL 6.7） |
| [`20000715`](results/20000715/) | [PDF](results/20000715/ARGUS_RESULT_20000715_TECHNICAL_REPORT.pdf) | $\eta^{24}$ 的显式三阶非线性微分方程与全阶齐次 $\mathbb{C}(q)$-线性 ODE 阻碍定理 | 模形式与微分代数 | 已独立验证阻碍定理（AIM 1.2） |

---

### 二、千禧年难题前沿子模型与结构阻碍定理（12 项）

| 编号 | 论文 | 成果名称与核心结论 | 领域 | 状态 |
|---|---|---|---|---|
| [`1138`](results/1138/) | [PDF](results/1138/ARGUS_RESULT_1138_TECHNICAL_REPORT.pdf) | 二进 Enriques 乘积 $C\times S_{\text{new}}$ 对一切正亏格复曲线 $C$ 的普适全迷向定理（$\dim_{\mathbb{F}_2} A_C\le g$）与亏格成正比整系数霍奇缺陷（$\dim_{\mathbb{F}_2} D_C\ge g$） | 代数几何与霍奇理论 | 已独立验证可发表定理 |
| [`20002392`](results/20002392/) | [PDF](results/20002392/ARGUS_RESULT_20002392_TECHNICAL_REPORT.pdf) | 半空间 $\mathbb{R}^3_+$ 无滑移边界下仅假设速度衰减 $|U(y)|\le C/(1+|y|)$ 的后向自相似 Navier–Stokes 对齐剖面完整排除定理 | 偏微分方程与流体力学 | 已独立验证可发表定理 |
| [`40`](results/40/) | [PDF](results/40/ARGUS_RESULT_40_TECHNICAL_REPORT.pdf) | 变半径周期余弦管壁（$0<|\kappa|\le 1/10$）轴对称 Euler 流笛卡尔逆对数发散反例与共形曲率响应闭合定理 | 偏微分方程与流体力学 | 已独立验证可发表定理 |
| [`1275`](results/1275/) | [PDF](results/1275/ARGUS_RESULT_1275_TECHNICAL_REPORT.pdf) | Hilbert–Pólya 有限移位膨胀算子限制 $D|_{P(S)C_c^\infty(0,\infty)}$ 的全实轴本质谱阻碍定理 $\sigma_{\mathrm{ess}}(\widetilde{D})=\mathbb{R}$ | 谱理论与解析数论 | 已独立验证可发表定理 |
| [`9400078`](results/9400078/) | [PDF](results/9400078/ARGUS_RESULT_9400078_TECHNICAL_REPORT.pdf) | $\mathrm{GL}_4$ 分歧型尖点自守表示违背温和性的无条件密度上界 $\ll_\varepsilon q^{3-4\tau+\varepsilon}$（$0<\tau\le 1/8$） | 自守形式与广义 Ramanujan 猜想 | 已独立验证可发表定理 |
| [`3395`](results/3395/) | [PDF](results/3395/ARGUS_RESULT_3395_TECHNICAL_REPORT.pdf) | 单调布尔电路下界中的中心化核误差荷对偶等价性、非中心化相对质量捷径的 $O(M_n+N^2)$ 门反例与局部矩阵粘合阻碍 | 计算复杂性理论与电路下界 | 已独立验证等价性与障碍定理 |
| [`2813`](results/2813/) | [PDF](results/2813/ARGUS_RESULT_2813_TECHNICAL_REPORT.pdf) | 双曲映射环面上的显式紧叶状结构 Euler 类 $(-2,-2,2)$ 障碍 | 低维拓扑与叶状结构 | 已独立验证显式障碍（Kirby 3.15） |
| [`20001836`](results/20001836/) | [PDF](results/20001836/ARGUS_RESULT_20001836_TECHNICAL_REPORT.pdf) | 坍缩圆周商 $S^4$ 中无统一下界的负曲率算子 $\lambda_{\min}=1-2/\varepsilon^2$ | 黎曼几何 | 已独立验证紧致构造 |
| [`2800203`](results/2800203/) | [PDF](results/2800203/ARGUS_RESULT_2800203_TECHNICAL_REPORT.pdf) | 深度 3 标量植入团 AMP 调度的阈值差障碍 $O(1/\log n+n^{-1/2})$ | 高维概率与统计推断 | 已独立验证不可能定理 |
| [`20000582`](results/20000582/) | [PDF](results/20000582/ARGUS_RESULT_20000582_TECHNICAL_REPORT.pdf) | 具有 $\Omega(\sqrt{k})$ 齐次规范扭曲的移动窗口 Engel Hilbert 上闭链 | 度量几何与双 Lipschitz 嵌入 | 已独立验证构造定理 |
| [`2457`](results/2457/) | [PDF](results/2457/ARGUS_RESULT_2457_TECHNICAL_REPORT.pdf) | Arvidsson 热迹有界核蕴含命题的对角反模型 $H_N=\mathrm{diag}(0_K,(3/10)I_{N-K})$ | 谱理论与解析数论 | 已独立验证前提反模型（Erdős #1055） |
| [`2307015`](results/2307015/) | [PDF](results/2307015/ARGUS_RESULT_2307015_TECHNICAL_REPORT.pdf) | 具有正调和测度的平移尖点 Jordan 边界集（覆盖 471 个规范形式） | 复分析与势论 | 已独立验证精确构造 |

---

### 三、独立核验反例与文献勘误 — Batch 001 与全量审计（31 项）

| 编号 | 论文 | 成果名称与核心结论 | 领域 | 状态 |
|---|---|---|---|---|
| [`20000443`](results/20000443/) | [PDF](results/20000443/ARGUS_RESULT_20000443_TECHNICAL_REPORT.pdf) | $\mathrm{cd}(K)\le 1$ 域上无 $K$-有理点的 $\mathbb{P}^9_K$ 光滑五次有理连通超曲面 | 算术与代数几何 | 已独立验证反例（Jacobian 结式证书） |
| [`20001224`](results/20001224/) | [PDF](results/20001224/ARGUS_RESULT_20001224_TECHNICAL_REPORT.pdf) | AIM 问题 47（代数统计设计理想）的四点有理显式反例 | 代数统计与计算交换代数 | 已独立验证显式反例 |
| [`20001159`](results/20001159/) | [PDF](results/20001159/ARGUS_RESULT_20001159_TECHNICAL_REPORT.pdf) | 平衡循环图 $G_B(k,m)$ 猜想的连通反例 $K_{3,3}$ 及 32 阶内 196,573 个循环图全量核验 | 代数图论与完美图 | 已独立验证反例 |
| [`3110`](results/3110/) | [PDF](results/3110/ARGUS_RESULT_3110_TECHNICAL_REPORT.pdf) | Beneš 猜想图论形式的 5-正则二阶段显式反例 $L_5$（最小割证书 $16<25$） | 组合数学与互连网络 | 已独立验证反例 |
| [`1442`](results/1442/) | [PDF](results/1442/ARGUS_RESULT_1442_TECHNICAL_REPORT.pdf) | Teschner 束缚数猜想的 18 顶点三次二部图反例（$b(G)=5>9/2$） | 图论与控制集 | 已独立验证反例 |
| [`3117`](results/3117/) | [PDF](results/3117/ARGUS_RESULT_3117_TECHNICAL_REPORT.pdf) | 图分数幂着色猜想反例 $(C_3\mathbin{\square} K_2)^{3/5}$（$\chi=6>5=\omega$） | 图着色与分数图论 | 已独立验证反例 |
| [`7000029`](results/7000029/) | [PDF](results/7000029/ARGUS_RESULT_7000029_TECHNICAL_REPORT.pdf) | $C^\infty$ 光滑曲面 Loewner 与 Carathéodory 脐点指标猜想反例（指标 $3/2>1$） | 微分几何与叶状结构 | 已独立验证 Lean 4 形式化成果 |
| [`1900`](results/1900/) | [PDF](results/1900/ARGUS_RESULT_1900_TECHNICAL_REPORT.pdf) | Erdős 问题 #43（不相交差集 Sidon 集）两分支的同时反驳 | 加性组合 | 已独立验证 Lean 4.27 形式化成果 |
| [`2141`](results/2141/) | [PDF](results/2141/ARGUS_RESULT_2141_TECHNICAL_REPORT.pdf) | 一般同余筛剩余集不存在对数密度的反例（$\liminf\le 177/200<49/50\le\limsup$，Erdős #486） | 解析与组合数论 | 已独立验证 Lean 4 形式化成果 |
| [`2215`](results/2215/) | [PDF](results/2215/ARGUS_RESULT_2215_TECHNICAL_REPORT.pdf) | 无三角形图直径 4 补边线性节省猜想的反驳（$h_4(G)\ge(1-\eta)n$，Erdős #619） | 极值图论 | 已独立验证 Lean 4 形式化成果 |
| [`20001068`](results/20001068/) | [PDF](results/20001068/ARGUS_RESULT_20001068_TECHNICAL_REPORT.pdf) | AIM Conjecture 6.23 字面弱不等式版本的 26 顶点、74 弧有向图反例 | 加权有向图 | 已独立验证反例 |
| [`20000282`](results/20000282/) | [PDF](results/20000282/ARGUS_RESULT_20000282_TECHNICAL_REPORT.pdf) | 约化非等维环 $k[a,b,c,d]/(ab,acd)$ 上 Hilbert–Kunz 重数上半连续性反例 | 交换代数 | 已独立验证反例（AIM 1.5） |
| [`20001352`](results/20001352/) | [PDF](results/20001352/ARGUS_RESULT_20001352_TECHNICAL_REPORT.pdf) | Thompson 群 $F$ 的换位子宽度与对合分解字面范围反例 | 几何群论 | 已独立验证范围修正（AIMPL 3.1） |
| [`20001602`](results/20001602/) | [PDF](results/20001602/ARGUS_RESULT_20001602_TECHNICAL_REPORT.pdf) | 分支群可公度子群定理缺失 just-infinite 假设及 Hanoi 群 $(G,G'')$ 反例 | 群论与分支群 | 已独立验证字面范围反例 |
| [`20001760`](results/20001760/) | [PDF](results/20001760/ARGUS_RESULT_20001760_TECHNICAL_REPORT.pdf) | 秩一格 $L=\mathbb{Z}$ 反驳不限维数的“所有壳层不可能均为 12-design”字面命题 | 格与球面设计 | 已独立验证字面范围反例 |
| [`4600048`](results/4600048/) | [PDF](results/4600048/ARGUS_RESULT_4600048_TECHNICAL_REPORT.pdf) | 四次 Salem $\beta$-变换的无理不动点 $x=1/(\beta-1)$ | 动力系统与代数数论 | 已独立验证目录表述修正 |
| [`20001382`](results/20001382/) | [PDF](results/20001382/ARGUS_RESULT_20001382_TECHNICAL_REPORT.pdf) | 逆树状 Galois 问题字面表述中的非闭子群拓扑障碍 | 算术动力系统 | 已独立验证范围修正 |
| [`20001274`](results/20001274/) | [PDF](results/20001274/ARGUS_RESULT_20001274_TECHNICAL_REPORT.pdf) | 全体平面投影合同不决定凸体（$\varepsilon=1/1000$ 双球冠显式有理复算） | 凸几何与离散几何 | 已独立验证精确复算 |
| [`20001516`](results/20001516/) | [PDF](results/20001516/ARGUS_RESULT_20001516_TECHNICAL_REPORT.pdf) | $\mathrm{CAT}(0)$ 自由-by-循环群 $F_2\rtimes_\phi\mathbb{Z}$ 不满足普通 RFRS | 几何群论与低维拓扑 | 已独立验证文献重建（AIM 5.3） |
| [`20001862`](results/20001862/) | [PDF](results/20001862/ARGUS_RESULT_20001862_TECHNICAL_REPORT.pdf) | 标准伪三角剖分路线的 8 顶点半周旋转对称障碍 | 计算几何与刚性理论 | 已独立验证显式重建 |
| [`3206`](results/3206/) | [PDF](results/3206/ARGUS_RESULT_3206_TECHNICAL_REPORT.pdf) | 图核为 $C_5$ 的 $\mathbb{Z}_{15}$ Cayley 图 | 代数图论 | 已独立验证文献重建 |
| [`1100501`](results/1100501/) | [PDF](results/1100501/ARGUS_RESULT_1100501_TECHNICAL_REPORT.pdf) | 完整轴集相同不蕴含环境群可公度 | Kleinian 群与双曲几何 | 已独立验证文献重建 |
| [`20000916`](results/20000916/) | [PDF](results/20000916/ARGUS_RESULT_20000916_TECHNICAL_REPORT.pdf) | 任意范数 Steinitz $O(\sqrt{d})$ 表述的 $\ell_1^d$ 线性下界 $(d+1)/2$ 障碍 | 凸几何与向量平衡 | 已独立验证文献重建 |
| [`20000320`](results/20000320/) | [PDF](results/20000320/ARGUS_RESULT_20000320_TECHNICAL_REPORT.pdf) | 弱 $\mathbb{Q}$-Gorenstein 条件在 $\mathrm{Spec}(k[t]/(t^2))$ 上不能保证多重典范层基变换 | 代数几何 | 已独立验证来源重建 |
| [`1350`](results/1350/) | [PDF](results/1350/ARGUS_RESULT_1350_TECHNICAL_REPORT.pdf) | 相对一致性下 GCH 不蕴含存在 $\aleph_2$-Suslin 树 | 集合论 | 已独立验证相对一致性反模型 |
| [`1200029`](results/1200029/) | [PDF](results/1200029/ARGUS_RESULT_1200029_TECHNICAL_REPORT.pdf) | 无限 Cayley 图的死端在闭球约定下可具有正渐近密度（$\ge 1/64$） | 几何群论 | 已独立验证文献反例 |
| [`1100101`](results/1100101/) | [PDF](results/1100101/ARGUS_RESULT_1100101_TECHNICAL_REPORT.pdf) | 无 Baumslag–Solitar 子群的有限四维 $K(G,1)$ 群可以非双曲 | 几何群论 | 已独立验证文献反例 |
| [`20000255`](results/20000255/) | [PDF](results/20000255/ARGUS_RESULT_20000255_TECHNICAL_REPORT.pdf) | 正特征终端三维奇点不必是 Cohen–Macaulay | 双有理与代数几何 | 原始文献反驳核验（Totaro 2019） |
| [`20000256`](results/20000256/) | [PDF](results/20000256/ARGUS_RESULT_20000256_TECHNICAL_REPORT.pdf) | 特征 2 三维 $\mathbb{Q}$-factorial plt 对的非正规素除子中心 | 正特征双有理几何 | 原始文献反驳核验（Cascini–Tanaka） |
| [`20000332`](results/20000332/) | [PDF](results/20000332/ARGUS_RESULT_20000332_TECHNICAL_REPORT.pdf) | Chow 半稳定多典范极限的不稳定性 | 代数几何与模空间 | 原始文献反驳核验（Wang–Xu 2014） |
| [`20000472`](results/20000472/) | [PDF](results/20000472/ARGUS_RESULT_20000472_TECHNICAL_REPORT.pdf) | Fock 空间有界 Toeplitz 算子在 $t=1/4$ 处热变换无界 | 算子理论与调和分析 | 原始文献反驳核验（Looi 2022） |

---

### 四、符号计算、代数归约与多面体边界证书（19 项）

| 编号 | 论文 | 成果名称与核心结论 | 领域 | 状态 |
|---|---|---|---|---|
| [`20000496`](results/20000496/) | [PDF](results/20000496/ARGUS_RESULT_20000496_TECHNICAL_REPORT.pdf) | 高维光滑中心对称凸域的内部热斑 | 谱几何与偏微分方程 | 原始文献反驳核验（de Dios Pont 2024） |
| [`20000731`](results/20000731/) | [PDF](results/20000731/ARGUS_RESULT_20000731_TECHNICAL_REPORT.pdf) | Nahm 猜想 4.1 的 $q$-超几何模函数反例 | 模形式与代数 $K$-理论 | 原始文献反驳核验（Vlasenko–Zwegers） |
| [`20000778`](results/20000778/) | [PDF](results/20000778/ARGUS_RESULT_20000778_TECHNICAL_REPORT.pdf) | $\mathbb{P}^2_{\mathbb{C}}$ 吹起 10 个一般点上的普适幻影范畴 | 代数几何与导出范畴 | 原始文献反驳核验（Krah 2024） |
| [`1380`](results/1380/) | [PDF](results/1380/ARGUS_RESULT_1380_TECHNICAL_REPORT.pdf) | 八点 Heilbronn 三角形问题平衡 $(2,2,2,2)$ 构型空间的 175 叶精确有理符号胞腔排除 | 离散几何 | 已独立验证有理胞腔排除证书 |
| [`1413`](results/1413/) | [PDF](results/1413/ARGUS_RESULT_1413_TECHNICAL_REPORT.pdf) | 57 度 Moore 图搜索中的 3,192 顶点、7,448 边围长 5 匹配前缀证书 | 代数图论 | 已独立验证前缀证书 |
| [`1900020`](results/1900020/) | [PDF](results/1900020/ARGUS_RESULT_1900020_TECHNICAL_REPORT.pdf) | $D=229$ 三次 Jacobi–Perron 轨道截面返回对正定对角二次型的严格收缩障碍 | 数论与动力系统 | 已独立验证单调能量障碍 |
| [`1921`](results/1921/) | [PDF](results/1921/ARGUS_RESULT_1921_TECHNICAL_REPORT.pdf) | Erdős 问题 #87 中有界偏移签名着色文法的一致最大度上界排除 | Ramsey 理论 | 已独立验证构造文法排除 |
| [`1994`](results/1994/) | [PDF](results/1994/ARGUS_RESULT_1994_TECHNICAL_REPORT.pdf) | Erdős–Ulam 平面有理距离问题秩 4 抛物 $\lambda=27$ 分支的二次归约与标量张成障碍 | 离散与算术几何 | 已独立验证代数归约 |
| [`20000786`](results/20000786/) | [PDF](results/20000786/ARGUS_RESULT_20000786_TECHNICAL_REPORT.pdf) | 四次曲线族 $k=3$ 分支上的 Hasse–Witt 矩阵消没与三次标量相消引理 | 算术几何 | 已独立验证算术引理 |
| [`20001578`](results/20001578/) | [PDF](results/20001578/ARGUS_RESULT_20001578_TECHNICAL_REPORT.pdf) | Thompson 群 $F$ 中 18 元等式候选的右商重数上界（$8<15$）精确排除 | 几何群论 | 已独立验证家族排除 |
| [`20001904`](results/20001904/) | [PDF](results/20001904/ARGUS_RESULT_20001904_TECHNICAL_REPORT.pdf) | 无共轭点流形四次 Hermite 曲率修补的六点正有理权重 Farkas 障碍 | 黎曼几何 | 已独立验证 Farkas 障碍 |
| [`2248`](results/2248/) | [PDF](results/2248/ARGUS_RESULT_2248_TECHNICAL_REPORT.pdf) | 二次素数表示 $n=ap^2+b$（Erdős #676）的 Baier–Zhao 色散尺度屏障 | 解析数论 | 已独立验证解析尺度障碍 |
| [`2305027`](results/2305027/) | [PDF](results/2305027/ARGUS_RESULT_2305027_TECHNICAL_REPORT.pdf) | 平面域 Corona 问题导数耦合修正族的有符号 Cauchy–Green 通量恒等式与 $\ge N/400{,}000$ 下界 | 复分析与调和分析 | 已独立验证解析残差下界 |
| [`2662`](results/2662/) | [PDF](results/2662/ARGUS_RESULT_2662_TECHNICAL_REPORT.pdf) | Kirby 问题 1.3 双变交叉局部 plat 突变族的 Reidemeister-II 坍缩排除 | 纽结理论 | 已独立验证局部突变族排除 |
| [`2669`](results/2669/) | [PDF](results/2669/ARGUS_RESULT_2669_TECHNICAL_REPORT.pdf) | 广义 Property R 猜想分阶段标架二分量链环的 handle-slide 平凡链环轨道归约 | 低维拓扑 | 已独立验证拓扑轨道归约 |
| [`2775`](results/2775/) | [PDF](results/2775/ARGUS_RESULT_2775_TECHNICAL_REPORT.pdf) | 辫群到直角 Artin 群投影中 $(A_{12},1,A_{12})$ 纤维的完整解分类 $u\alpha(v)=vu$ | 辫群与几何群论 | 已独立验证完整纤维分类 |
| [`2862`](results/2862/) | [PDF](results/2862/ARGUS_RESULT_2862_TECHNICAL_REPORT.pdf) | 单角球面 bar 闭链的共正规化子正交联接归约与 Chern–Simons 体积有理性（Kirby 3.64） | 低维拓扑与代数 $K$-理论 | 已独立验证有理性归约 |
| [`8`](results/8/) | [PDF](results/8/ARGUS_RESULT_8_TECHNICAL_REPORT.pdf) | 奇完全数 minimal-101 root-4 分支经 $6{,}756{,}355$ 个前缀归约到单一因子 $\Phi_{31}(269)=\sigma(269^{30})$ | 初等与计算数论 | 已独立验证因子链归约 |
| [`8200002`](results/8200002/) | [PDF](results/8200002/ARGUS_RESULT_8200002_TECHNICAL_REPORT.pdf) | 六维互无偏基系统第三 Fourier 纤维的 39 维 Arb Krawczyk 区间牛顿认证 | 量子信息与代数几何 | 已独立验证区间包含证书 |

---

## 一键重放与独立验证（Reproducibility）

建议使用 Python 3.10 或更高版本：

```bash
python -m pip install -r requirements.txt
python scripts/verify_artifacts.py

# 核心代表作独立复算脚本示例：
python results/20001036/verify_optimality.py
python results/11000263/verify_burau.py
python results/3059/test_permanent_amplification.py
python results/3102/test_discharge_cover.py
python results/7200051/check_robust_clipping_gap.py
python results/3167/verify_marked_closure.py
python results/20001675/knot_jet_fibers.py
python results/1275/check_finite_shift_certificate.py
python results/9400114/verify_short_arc.py
python results/2338/affine_orthogonal_runge_verify.py
```

---

## 版权与署名声明

> **版权所有 © 2026 Argus AI Team，保留全部权利。**
>
> 公开展示不等于放弃版权或转移作者身份。欢迎准确链接与学术规范引用；详细条款见 [LICENSE](LICENSE) 与 [CITATION.cff](CITATION.cff)。
