<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/brand/argus-logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/brand/argus-logo-light.svg">
    <img src="assets/brand/argus-logo-dark.svg" width="420" alt="Argus">
  </picture>
</p>

# Argus Mathematics

这里集中归档 [Argus AI Team](https://github.com/Argus-AiTeam) 已形成公开证据包的数学成果、验证程序与研究记录。

[English](README.md) ·
[论文分级评估](docs/publication-triage.md) ·
[Batch 001 报告](docs/batch-001.md) ·
[状态与范围词汇](docs/status-and-scope.md)

## 权利与署名声明

> **版权所有 © 2026 Argus AI Team，保留全部权利。**
>
> 我们的部分成果包和优先权声明仍在进行内部验证及外部专家复核。我们发现，某些人将
> 我们已经公开的成果材料再次发布，并声称为其本人完成。对此我们非常震惊和疑惑。
> 因此，自 **2026 年 9 月 2 日**起，本仓库明确改用专有的“保留全部权利”许可。

公开展示不等于放弃版权，也不转移作者身份。未经 Argus AI Team 事先书面许可，不得
复制、修改、翻译、再发布、商业利用、制作衍生作品，或将本仓库原创材料纳入数据集及
模型训练语料。我们仍欢迎准确链接和规范引用；法律规定的合理引用、评论、学术研究、
合理使用或公平处理权利不受影响。

本政策保护 Argus AI Team 原创的报告、代码、证书、分析、表达方式与档案编排，但
**不主张独占数学事实、思想或第三方已经发表的成果**。文献重建成果仍归功于原作者。
完整条款见 [LICENSE](LICENSE)，引用具体成果时请保留其 Result ID。

## 仓库定位

这个仓库优先整理**已经得到明确结论并具备可审查材料的成果**，而不是简单收集 Agent
对话或把所有研究中猜想都称为成果。

截至 **2026 年 9 月 10 日**，公开数学研究体系包括：

- **72 个正式归档的结果包**（全部 72 个结果均配有独立编译的 AMS LaTeX 论文 `.pdf` 与 `.tex` 源码）（含完整反例、范围勘误、源文献反驳与阶段性定理）；
- **23 个可独立运行的计算/符号验证程序**；
- **2 个带明确覆盖边界的 Lean 4 逻辑/拓扑组合检查**（`2884` 与 `1465`）；
- **496 个带 SHA-256 校验值的公开产物**；
- **41 个反例或证明研究战役**；
- **757 条逐项核对来源和状态的历史问题记录**（已审 617 条，独立复核 593 条，确认仍开放 102 条）。

本仓库每个 `results/<ID>/` 目录均包含独立编译的 AMS LaTeX 数学论文（`ARGUS_RESULT_<ID>_TECHNICAL_REPORT.pdf` 与 `.tex` 源码）、边界说明 `README.md` 与验证记录。

## 已公开成果

| 编号 | 成果 | 领域 | 当前状态 |
|---|---|---|---|
| [20001760](results/20001760/) ([PDF](results/20001760/ARGUS_RESULT_20001760_TECHNICAL_REPORT.pdf)) | 秩一格反驳字面的“所有壳层不可能均为 12-design”命题 | 格与球面设计 | 已独立审查的字面范围反例；高维版本仍开放 |
| [1350](results/1350/) ([PDF](results/1350/ARGUS_RESULT_1350_TECHNICAL_REPORT.pdf)) | 相对一致性下 GCH 不蕴含存在 $\aleph_2$-Suslin 树 | 集合论 | 已独立审查的已发表相对一致性反模型 |
| [1200029](results/1200029/) ([PDF](results/1200029/ARGUS_RESULT_1200029_TECHNICAL_REPORT.pdf)) | 无限 Cayley 图的死端可具有正球密度 | 几何群论 | 在闭球约定下已独立审查的已发表反例 |
| [1100501](results/1100501/) ([PDF](results/1100501/ARGUS_RESULT_1100501_TECHNICAL_REPORT.pdf)) | 完整轴集相同不蕴含可公度 | Kleinian 群与双曲几何 | 已知初等反例的独立审查重建 |
| [1100101](results/1100101/) ([PDF](results/1100101/ARGUS_RESULT_1100101_TECHNICAL_REPORT.pdf)) | 无 Baumslag--Solitar 子群的有限 $K(G,1)$ 群可以非双曲 | 几何群论 | 已独立审查的已发表反例；三维及以下版本仍开放 |
| [4600048](results/4600048/) ([PDF](results/4600048/ARGUS_RESULT_4600048_TECHNICAL_REPORT.pdf)) | Salem \(\beta\)-变换的无理不动点 | 动力系统与代数数论 | 已独立验证的目录表述修正；Schmidt 原问题仍开放 |
| [2307015](results/2307015/) ([PDF](results/2307015/ARGUS_RESULT_2307015_TECHNICAL_REPORT.pdf)) | 具有正调和测度的平移尖点边界集 | 复分析、势论与调和测度 | 已独立验证的解释范围受限结果；新颖性未审计 |
| [2813](results/2813/) ([PDF](results/2813/ARGUS_RESULT_2813_TECHNICAL_REPORT.pdf)) | 双曲映射环面上的显式紧叶状结构 Euler 类障碍 | 低维拓扑、叶状结构与动力系统 | 已独立验证的项目原创显式障碍；不声明全球首创优先权 |
| [20001836](results/20001836/) ([PDF](results/20001836/ARGUS_RESULT_20001836_TECHNICAL_REPORT.pdf)) | 坍缩圆周商中无统一下界的负曲率算子 | 黎曼几何 | 已独立验证；文献新颖性待审计 |
| [20001862](results/20001862/) ([PDF](results/20001862/ARGUS_RESULT_20001862_TECHNICAL_REPORT.pdf)) | 标准伪三角剖分路线的半周旋转对称障碍 | 计算几何 | 显式重建；负面答案在 2015 年已经记录 |
| [20001382](results/20001382/) ([PDF](results/20001382/ARGUS_RESULT_20001382_TECHNICAL_REPORT.pdf)) | 逆树状 Galois 问题字面表述中的非闭子群障碍 | 算术动力系统 | 已独立验证的范围修正 |
| [20000916](results/20000916/) ([PDF](results/20000916/ARGUS_RESULT_20000916_TECHNICAL_REPORT.pdf)) | 任意范数 Steinitz $O(\sqrt d)$ 表述的 $\ell_1^d$ 障碍 | 凸几何 | 已独立审查的文献重建 |
| [20000320](results/20000320/) ([PDF](results/20000320/ARGUS_RESULT_20000320_TECHNICAL_REPORT.pdf)) | 弱 Q-Gorenstein 条件不能保证多重典范层基变换 | 代数几何 | 已独立审查的来源重建 |
| [3206](results/3206/) ([PDF](results/3206/ARGUS_RESULT_3206_TECHNICAL_REPORT.pdf)) | 图核为 $C_5$ 的 $\mathbb Z_{15}$ Cayley 图 | 代数图论 | 已知 2008 年反例的独立验证重建 |
| [20001068](results/20001068/) ([PDF](results/20001068/ARGUS_RESULT_20001068_TECHNICAL_REPORT.pdf)) | AIM Conjecture 6.23 字面弱不等式版本的 26 顶点反例 | 加权有向图 | 已独立验证 |
| [11000263](results/11000263/) ([PDF](results/11000263/ARGUS_RESULT_11000263_TECHNICAL_REPORT.pdf)) | Bigelow zipper algebra 的 twist Burau 商（$X_3\neq0, X_4=0$）与全 $n\ge4$ 普适商有限维定理 | 辫群与代数 | 已独立验证；$(2n-1)!!+1\le\dim Q_n\le(2n-1)!!+(n!/3)^2$；不声明全球首创优先权 |
| [2884](results/2884/) ([PDF](results/2884/ARGUS_RESULT_2884_TECHNICAL_REPORT.pdf)) | K3 Problem 4.8 任意 *X* 稳定化反例与固定未稳定化 $E(2)_{6_3}\to E(2)_{19nh_{78}}$ 七步 PL/光滑构造 | 光滑四维流形与纽结手术 | 稳定化范围反例（含 Lean 检查）与固定 $E(2)$ PL/Hirsch--Milnor 构造均已独立复核 |
| [20001036](results/20001036/) ([PDF](results/20001036/ARGUS_RESULT_20001036_TECHNICAL_REPORT.pdf)) | Seymour--Sullivan 猜想 6.1（彩虹可达性）的 5,454 顶点、11,792,572 弧多标签显式反例 | 有向图与组合优化 | 在正长度可达、无序单射标签与多标签弧口径下已独立验证（`VERIFIED_COUNTEREXAMPLE`） |
| [1465](results/1465/) ([PDF](results/1465/ARGUS_RESULT_1465_TECHNICAL_REPORT.pdf)) | Fu 2026 定理 2.8 正则性局部有限前提漏洞 | 模型论与 o-极小结构 | 已独立验证的证明前提修正（含 Lean 4 核心检查） |
| [2338](results/2338/) ([PDF](results/2338/ARGUS_RESULT_2338_TECHNICAL_REPORT.pdf)) | 杨辉三角二项式系数重数 5 的全局必要条件（$K(a)\ge8$，$\omega(a)\ge7$，$\{5,6,7,8\}$ 分支 $\omega(a)\ge14$） | 数论与丢番图方程 | 已独立验证的全局必要条件定理包（Erdős 问题 #849，Tier-A 论文候选） |
| [20000278](results/20000278/) ([PDF](results/20000278/ARGUS_RESULT_20000278_TECHNICAL_REPORT.pdf)) | 特征 13 非 $\mathbb Q$-Gorenstein 局部整环的无理数 $F$-跳跃数 $\lambda=(53609-\sqrt{17})/48$ | 交换代数与正特征奇点 | 已独立验证的精确数学证书（AIM Problem 1.3） |
| [20000816](results/20000816/) ([PDF](results/20000816/ARGUS_RESULT_20000816_TECHNICAL_REPORT.pdf)) | $\mathrm{Hilb}^{4803}(\mathbb A^{20}_{\mathbb C})$ 不同不可约分支在稠密开集上共享完整无标签 Gröbner 扇 | 代数几何与计算交换代数 | 在无标签 FJT 扇约定下已独立验证（AIM Problem 15 / 1.35） |
| [20001274](results/20001274/) ([PDF](results/20001274/ARGUS_RESULT_20001274_TECHNICAL_REPORT.pdf)) | 全体平面投影合同不决定凸体（$\varepsilon=1/1000$ 双球冠显式验证） | 凸几何与离散几何 | 已知反例的精确解析与有理算术复算 |
| [20001352](results/20001352/) ([PDF](results/20001352/ARGUS_RESULT_20001352_TECHNICAL_REPORT.pdf)) | Thompson 群 $F$ 的换位子宽度与对合分解字面范围反例 | 几何群论 | 已独立验证的字面定义域修正（AIMPL Problem 3.1） |
| [20001516](results/20001516/) ([PDF](results/20001516/ARGUS_RESULT_20001516_TECHNICAL_REPORT.pdf)) | $\mathrm{CAT}(0)$ 自由-by-循环群 $F_2\rtimes_\phi\mathbb Z$ 不满足普通 RFRS | 几何群论与低维拓扑 | 已知文献反例的显式证书复算（AIM Problem 5.3） |
| [20001602](results/20001602/) ([PDF](results/20001602/ARGUS_RESULT_20001602_TECHNICAL_REPORT.pdf)) | 分支群交换有限子群定理缺失 just-infinite 假设及 Hanoi 群 $(G,G'')$ 反例 | 群论与分支群 | 已独立验证的字面范围反例 |
| [20001849](results/20001849/) ([PDF](results/20001849/ARGUS_RESULT_20001849_TECHNICAL_REPORT.pdf)) | Flying wings ($n=3,\alpha=1/2$) 反驳塌缩三维稳态孤立子唯一性 | 微分几何与 Ricci 流 | 在 Lai 全尺度空间塌缩定义下已独立验证（AIMPL Problem 6.7） |
| [20000715](results/20000715/) ([PDF](results/20000715/ARGUS_RESULT_20000715_TECHNICAL_REPORT.pdf)) | $\eta^{24}$ 的显式三阶非线性微分方程与全阶齐次 $\mathbb C(q)$-线性 ODE 障碍 | 模形式与微分代数 | 已独立复核的状态澄清与线性障碍证明（AIM Problem 1.2） |
| [2457](results/2457/) ([PDF](results/2457/ARGUS_RESULT_2457_TECHNICAL_REPORT.pdf)) | Arvidsson 热迹有界核蕴含命题的对角反模型 $H_N=\mathrm{diag}(0_K,(3/10)I_{N-K})$ | 谱理论与解析数论 | 已独立验证的文献证明前提反模型（Erdős 问题 #1055） |
| [20000443](results/20000443/) ([PDF](results/20000443/ARGUS_RESULT_20000443_TECHNICAL_REPORT.pdf)) | $\mathrm{cd}(K)\le1$ 域上无非平凡零点的 $\mathbb P^9_K$ 光滑五次有理连通超曲面 | 算术与代数几何 | 结合 Ax 五次形式与 Jacobian 结式计算的独立验证反例（Batch 001） |
| [20000255](results/20000255/) ([PDF](results/20000255/ARGUS_RESULT_20000255_TECHNICAL_REPORT.pdf)) | 正特征终端三维奇点不必是 Cohen--Macaulay | 双有理与代数几何 | 原始文献反驳核验（Batch 001；Totaro 2019） |
| [20000256](results/20000256/) ([PDF](results/20000256/ARGUS_RESULT_20000256_TECHNICAL_REPORT.pdf)) | 特征 2 三维 $\mathbb Q$-factorial plt 对的非正规素除子中心 | 正特征双有理几何 | 原始文献反驳核验（Batch 001；Cascini--Tanaka） |
| [20000332](results/20000332/) ([PDF](results/20000332/ARGUS_RESULT_20000332_TECHNICAL_REPORT.pdf)) | Chow 半稳定多典范极限的不稳定性 | 代数几何与模空间稳定性 | 原始文献反驳核验（Batch 001；Wang--Xu 2014） |
| [20000472](results/20000472/) ([PDF](results/20000472/ARGUS_RESULT_20000472_TECHNICAL_REPORT.pdf)) | Fock 空间有界 Toeplitz 算子在 $t=1/4$ 处热变换无界 | 算子理论与调和分析 | 原始文献反驳核验（Batch 001；Looi 2022） |
| [20000496](results/20000496/) ([PDF](results/20000496/ARGUS_RESULT_20000496_TECHNICAL_REPORT.pdf)) | 高维光滑中心对称凸域的内部热斑 | 谱几何与偏微分方程 | 原始文献反驳核验（Batch 001；de Dios Pont 2024） |
| [20000731](results/20000731/) ([PDF](results/20000731/ARGUS_RESULT_20000731_TECHNICAL_REPORT.pdf)) | Nahm 猜想 4.1 的 $q$-超几何模函数反例 | 模形式与代数 $K$-理论 | 原始文献反驳核验（Batch 001；Vlasenko--Zwegers 2011） |
| [20000778](results/20000778/) ([PDF](results/20000778/ARGUS_RESULT_20000778_TECHNICAL_REPORT.pdf)) | $\mathbb P^2_{\mathbb C}$ 吹起 10 个一般点上的普适幻影范畴 | 代数几何与导出范畴 | 原始文献反驳核验（Batch 001；Krah 2024） |
| [1243](results/1243/) ([PDF](results/1243/ARGUS_RESULT_1243_TECHNICAL_REPORT.pdf)) | 三阶平方数幻方亏格 2 覆盖上的显式非退化 Cassels--Tate 配对 $\langle 936,1304\rangle_{\mathrm{CT}}=1/2$ | 算术几何与显式下降 | 已独立重放的阶段性算术定理（Tier-B） |
| [6800022](results/6800022/) ([PDF](results/6800022/ARGUS_RESULT_6800022_TECHNICAL_REPORT.pdf)) | 亏格 1 四端极小曲面族的四条精确嵌入障碍 | 微分几何与极小曲面 | 已独立复核的受限族障碍定理（Tier-B） |
| [2800203](results/2800203/) ([PDF](results/2800203/ARGUS_RESULT_2800203_TECHNICAL_REPORT.pdf)) | 深度 3 标量植入团 AMP 调度的阈值差障碍 $O(1/\log n+n^{-1/2})$ | 高维概率与统计推断 | 已独立验证的受限不可能定理（Tier-B） |
| [1285](results/1285/) ([PDF](results/1285/ARGUS_RESULT_1285_TECHNICAL_REPORT.pdf)) | 受限 CRT 局部控制器与 ECM 双链分解路线的渐近成功率上界 | 计算数论 | 已独立验证的受限模型下界定理（Tier-B） |
| [1187](results/1187/) ([PDF](results/1187/ARGUS_RESULT_1187_TECHNICAL_REPORT.pdf)) | $G_{4,3}$ 上 Nielsen 挠商坍缩 $\mathcal D_{\mathrm{AC3}}=\mathcal R_U$ 与 $F/K^{(3)}$ 严格 AC 证书 | 组合与几何群论 | 已独立验证的受限商群定理（Tier-B） |
| [20000582](results/20000582/) ([PDF](results/20000582/ARGUS_RESULT_20000582_TECHNICAL_REPORT.pdf)) | 具有 $\Omega(\sqrt{k})$ 齐次规范扭曲的移动窗口 Engel Hilbert 上闭链 | 度量几何与双 Lipschitz 嵌入 | 已独立复核的有限球构造定理（Tier-B） |
| [9400114](results/9400114/) ([PDF](results/9400114/ARGUS_RESULT_9400114_TECHNICAL_REPORT.pdf)) | Agrawal 猜想的素数幂（$p^e, e\ge2$）与 12,286 个共享阶余因子子集排除证书 | 计算数论与素性检测 | 已独立验证的受限族排除证书 |
| [20000282](results/20000282/) ([PDF](results/20000282/ARGUS_RESULT_20000282_TECHNICAL_REPORT.pdf)) | 约化非等维环 $k[a,b,c,d]/(ab,acd)$ 上 Hilbert--Kunz 重数上半连续性反例 | 交换代数与正特征奇点 | 已独立验证的字面范围反例（$e_{\mathrm{HK}}(R_{\mathfrak p})=2>1=e_{\mathrm{HK}}(R_{\mathfrak m})$） |
| [20001224](results/20001224/) ([PDF](results/20001224/ARGUS_RESULT_20001224_TECHNICAL_REPORT.pdf)) | AIM 问题 47（代数统计设计理想）的四点有理显式反例 | 代数统计与计算交换代数 | 已独立验证的显式反例与行列式证书 |
| [20001159](results/20001159/) ([PDF](results/20001159/ARGUS_RESULT_20001159_TECHNICAL_REPORT.pdf)) | 平衡循环图 $G_B(k,m)$ 猜想的连通反例 $K_{3,3}$ 与完整修正分类 | 代数图论与完美图 | 已独立验证的反例及 32 阶以内 196,573 个循环图全量核验 |
| [3110](results/3110/) ([PDF](results/3110/ARGUS_RESULT_3110_TECHNICAL_REPORT.pdf)) | Bene\v{s} 猜想图论形式的 5-正则二阶段显式反例 $L_5$ | 组合数学与互连网络 | 已独立验证的显式反例与最小割证书（$16<25$） |
| [1442](results/1442/) ([PDF](results/1442/ARGUS_RESULT_1442_TECHNICAL_REPORT.pdf)) | Teschner 束缚数猜想的 18 顶点三次二部图反例（$b(G)=5>9/2$） | 图论与控制集 | 已独立穷举验证的计算证书 |
| [3117](results/3117/) ([PDF](results/3117/ARGUS_RESULT_3117_TECHNICAL_REPORT.pdf)) | 图分数幂着色猜想反例 $(C_3\mathbin{\square} K_2)^{3/5}$（$\chi=6>5=\omega$） | 图着色与分数图论 | 已独立穷举验证的计算证书 |
| [7000029](results/7000029/) ([PDF](results/7000029/ARGUS_RESULT_7000029_TECHNICAL_REPORT.pdf)) | $C^\infty$ 光滑曲面 Loewner 与 Carath\'eodory 脐点指标猜想反例（指标 $3/2>1$） | 微分几何与叶状结构 | 已独立验证的 Lean 4 形式化成果 |
| [1900](results/1900/) ([PDF](results/1900/ARGUS_RESULT_1900_TECHNICAL_REPORT.pdf)) | Erd\H{o}s 问题 #43（不相交差集 Sidon 集）两分支的同时反驳 | 加性组合 | Lean 4.27 独立重放与等规模构造核验 |
| [2141](results/2141/) ([PDF](results/2141/ARGUS_RESULT_2141_TECHNICAL_REPORT.pdf)) | 一般同余筛剩余集不存在对数密度的反例（Erd\H{o}s 问题 #486） | 解析与组合数论 | 已验证的 Lean 4 形式化成果（$\liminf\le 177/200<49/50\le\limsup$） |
| [2215](results/2215/) ([PDF](results/2215/ARGUS_RESULT_2215_TECHNICAL_REPORT.pdf)) | 无三角形图直径 4 补边线性节省猜想的反驳（Erd\H{o}s 问题 #619） | 极值图论 | 已验证的 Lean 4 形式化成果（$h_4(G)\ge(1-\eta)n$） |
| [1380](results/1380/) ([PDF](results/1380/ARGUS_RESULT_1380_TECHNICAL_REPORT.pdf)) | 八点 Heilbronn 三角形问题平衡 $(2,2,2,2)$ 构型空间的 175 叶精确有理排除 | 离散几何 | 已独立验证的有理符号胞腔排除证书 |
| [1413](results/1413/) ([PDF](results/1413/ARGUS_RESULT_1413_TECHNICAL_REPORT.pdf)) | 57 度 Moore 图搜索中的 3,192 顶点、7,448 边围长 5 匹配前缀证书 | 代数图论 | 已独立验证的无三/四环前缀证书 |
| [1417](results/1417/) ([PDF](results/1417/ARGUS_RESULT_1417_TECHNICAL_REPORT.pdf)) | Erd\H{o}s--Gy\'arf\'as 猜想在 $43{,}046{,}721$ 个跨块电压图上的精确排除 | 图论 | 由 9 个 $C_8/C_{16}/C_{32}$ 圈见证全量覆盖排除 |
| [1518](results/1518/) ([PDF](results/1518/ARGUS_RESULT_1518_TECHNICAL_REPORT.pdf)) | 第二 Hardy--Littlewood 猜想的 320 素数层与 11,005 区间筛排除 | 解析数论 | 已独立验证的素数窗口筛排除 |
| [1900020](results/1900020/) ([PDF](results/1900020/ARGUS_RESULT_1900020_TECHNICAL_REPORT.pdf)) | $D=229$ 三次 Jacobi--Perron 轨道截面返回对正定对角二次型的严格收缩障碍 | 数论与动力系统 | 已独立验证的单调二次能量方法障碍 |
| [1921](results/1921/) ([PDF](results/1921/ARGUS_RESULT_1921_TECHNICAL_REPORT.pdf)) | Erd\H{o}s 问题 #87 中有界偏移签名着色文法的一致最大度上界排除 | Ramsey 理论 | 已独立复核的构造文法排除 |
| [1994](results/1994/) ([PDF](results/1994/ARGUS_RESULT_1994_TECHNICAL_REPORT.pdf)) | Erd\H{o}s--Ulam 平面有理距离问题秩 4 抛物 $\lambda=27$ 分支的二次归约与标量张成障碍 | 离散与算术几何 | 已独立验证的代数归约与秩障碍 |
| [20000786](results/20000786/) ([PDF](results/20000786/ARGUS_RESULT_20000786_TECHNICAL_REPORT.pdf)) | 四次曲线族 $k=3$ 分支上的 Hasse--Witt 矩阵消没与三次标量相消引理 | 算术几何 | 已独立复核的算术引理 |
| [20001578](results/20001578/) ([PDF](results/20001578/ARGUS_RESULT_20001578_TECHNICAL_REPORT.pdf)) | Thompson 群 $F$ 中 18 元等式候选的右商重数上界（$8<15$）精确排除 | 几何群论 | 已独立验证的家族排除定理 |
| [20001904](results/20001904/) ([PDF](results/20001904/ARGUS_RESULT_20001904_TECHNICAL_REPORT.pdf)) | 无共轭点流形四次 Hermite 曲率修补的六点正有理权重 Farkas 障碍 | 黎曼几何 | 已独立验证的修补族排除定理 |
| [2248](results/2248/) ([PDF](results/2248/ARGUS_RESULT_2248_TECHNICAL_REPORT.pdf)) | 二次素数表示 $n=ap^2+b$（Erd\H{o}s #676）的 Baier--Zhao 色散尺度屏障 | 解析数论 | 已独立复核的解析尺度障碍 |
| [2305027](results/2305027/) ([PDF](results/2305027/ARGUS_RESULT_2305027_TECHNICAL_REPORT.pdf)) | 平面域 Corona 问题导数耦合修正族的有符号 Cauchy--Green 通量恒等式与 $\ge N/400{,}000$ 下界 | 复分析与调和分析 | 已独立验证的解析残差下界定理 |
| [2662](results/2662/) ([PDF](results/2662/ARGUS_RESULT_2662_TECHNICAL_REPORT.pdf)) | Kirby 问题 1.3 双变交叉局部 plat 突变族的 Reidemeister-II 坍缩排除 | 纽结理论 | 已独立验证的局部突变族排除定理 |
| [2669](results/2669/) ([PDF](results/2669/ARGUS_RESULT_2669_TECHNICAL_REPORT.pdf)) | 广义 Property R 猜想分阶段标架二分量链环的 handle-slide 平凡链环轨道归约 | 低维拓扑 | 已独立验证的拓扑轨道归约 |
| [2775](results/2775/) ([PDF](results/2775/ARGUS_RESULT_2775_TECHNICAL_REPORT.pdf)) | 辫群到直角 Artin 群投影中 $(A_{12},1,A_{12})$ 纤维的完整解分类 $u\alpha(v)=vu$ | 辫群与几何群论 | 已独立验证的完整纤维分类定理 |
| [2862](results/2862/) ([PDF](results/2862/ARGUS_RESULT_2862_TECHNICAL_REPORT.pdf)) | 单角球面 bar 闭链的共正规化子正交联接归约与 Chern--Simons 体积有理性 | 低维拓扑与代数 $K$-理论 | 已独立验证的有理性归约定理 |
| [8](results/8/) ([PDF](results/8/ARGUS_RESULT_8_TECHNICAL_REPORT.pdf)) | 奇完全数 minimal-101 root-4 分支经 $6{,}756{,}355$ 个前缀归约到单一因子 $\Phi_{31}(269)$ | 初等与计算数论 | 已独立重放的因子链归约 |
| [8200002](results/8200002/) ([PDF](results/8200002/ARGUS_RESULT_8200002_TECHNICAL_REPORT.pdf)) | 六维互无偏基系统第三 Fourier 纤维的 39 维 Arb Krawczyk 区间牛顿认证 | 量子信息与代数几何 | 已独立验证的区间包含证书 |

### 20001760：秩一格的全壳层球面设计

AIM Problem 1.44 的正式表述没有限制维数，因此秩一格 \(L=\mathbb Z\) 合法。每个非空
壳层都是完整的零维球面 \(\{-k,k\}\)，其离散平均和球面平均对任意多项式都相同。
所以每个壳层都是任意阶的球面设计，特别是 12-design。

该结论只反驳不限制维数的字面命题，不解决增加 \(n\geq2\) 条件后的版本，也不声称
Leech 格的最小壳层是 12-design。文献新颖性与全球优先权尚未确认。

### 1350：GCH 与 \(\aleph_2\)-Suslin 树的相对一致性

在假设存在弱紧致基数的相对一致性意义下，Asperó 和 Golshani 构造了同时满足 GCH
和 \(\aleph_2\) 特殊 Aronszajn 树性质的强迫扩张。该模型不存在
\(\aleph_2\)-Suslin 树，因此给出所述蕴含的相对一致性反模型。

这不是裸 ZFC 中的无条件构造，也不是 ZFC 一致性的证明。归档核对的是修复早期缺口的
第 7 版已发表来源，并非 Argus 首次构造。

### 1200029：无限 Cayley 图中的正死端球密度

对双曲 \((2,3,7)\) 三角群和生成集 \(\{a,b,b^{-1}\}\)，Calegari 和 Fujiwara 证明
死端在闭词球中的渐近密度为正，下界至少为 \(1/64\)。这在闭球归一化下反驳了普遍
零密度命题。

原始单行问题没有定义密度约定。该结果不处理词球面的密度，也不声称 \(1/64\) 是精确
极限值；它是已发表文献结果的独立审查记录。

### 1100501：相同完整轴集不蕴含可公度

分别由 \(\mathrm{diag}(2,1/2)\) 和 \(\mathrm{diag}(3,1/3)\) 生成的两个循环
Kleinian 群具有相同的完整轴集，但 \(4^m=9^n\) 只允许 \(m=n=0\)，所以二者交集平凡，
在环境群中不可公度。

两个群都是初等群，联合生成的群不离散；作为无限循环群，它们在抽象意义下仍可公度。
该例子不决定非初等或联合离散的加强版本。

### 1100101：有限 \(K(G,1)\) 与非双曲性

Italiano、Martelli 和 Migliorini 构造了一个非双曲群 \(H\)：它嵌入某个双曲群，
具有有限 \(K(H,1)\)，并且不含任何 Baumslag--Solitar 子群。因此同一个群反驳
Bestvina Question 1.1 中两个不限制维数的蕴含。

该有限分类空间是四维的；要求维数不超过三的加强问题仍然开放。这一反例已见于 2021
年的文献来源，不是 Argus 首次发现。

### 4600048：Salem \(\beta\)-变换的无理不动点

取四次多项式

$$
t^4-3t^3+3t^2-3t+1
$$

的大于 2 的 Salem 根 \(\beta\)。点 \(x=1/(\beta-1)\) 位于 \((0,1)\)，是无理数，
并满足 \(T_\beta(x)=x\)。因此目录中的字面等式
\(\mathrm{Per}(\beta)=\mathbb Q\cap[0,1)\) 不成立。

原始文献询问的是右侧为 \(\mathbb Q(\beta)\) 的不同问题，而该见证本身属于
\(\mathbb Q(\beta)\)。因此 Schmidt 的 Salem-base 问题仍然开放；本成果是经过独立验证
的勘误和范围修正，不是对原问题的新解答。

### 2307015：平移尖点边界集的正调和测度

在 \(\alpha=2/3\) 时，两个显式尖点叶瓣和一个矩形桥组成有界 Jordan 域。其四段选定
边界弧对任意内部极点都有正调和测度。该构造覆盖对 Problem 7.15 进行“保持单次出现、
保持同一参数且不增加新原子谓词”解释后得到的全部 471 个规范形式。

原文没有明确指定平移尖点的接触点；如果额外加入原文未写出的真子轨迹条件，答案可能
改变。因此它是解释范围受限的精确结果，不作为无条件解决。新颖性尚未审计，也不计为
原创发现。

### 2813：双曲映射环面上的紧叶状结构 Euler 类障碍

在 genus-3 Eierlegende Wollmilchsau origami 上，取由作用顺序词
`SSTSST` 和左平移 `-i` 得到的仿射 pseudo-Anosov 映射。其映射环面是闭双曲
三维流形，并满足

$$
H_1(M_f;\mathbb Z)\cong\mathbb Z^3\oplus\mathbb Z/2\oplus\mathbb Z/6.
$$

自由部分坐标为 $(-2,-2,2)$ 的偶整数类位于对偶 Thurston 单位球内，但不能成为
任何光滑、共定向 taut foliation 的 Euler 类。精确证书完整枚举了十二条一周期轨道，
并逐项验证障碍定理的假设；三轮独立审查均已通过，公开证明图包含 95 个有效节点，
目标依赖链上没有未证明命题。

这是利用已有数学工具组合得到的项目原创显式应用。定向语料审计未找到等价显式构造，
但这不构成绝对新颖性证明，也不声明全球首创优先权。该结果只决定 Kirby Problem 3.15(a)
中一个明确的不可实现类，不构成 taut-foliation 分支的完整分类，也不处理其余五个
Euler 类实现分支。

### 20001836：坍缩圆周商中的负曲率算子

在单位圆球面 $S^4$ 上取权重为 $(1,2)$ 的有效等距圆周作用。对辅助圆周尺度为
$\varepsilon$ 的坍缩商构造，Argus 重建了固定点处完整的曲率算子，并得到精确特征值

$$
\lambda_{\min}=1-\frac{2}{\varepsilon^2}.
$$

当 $\varepsilon\to0$ 时，该特征值趋于负无穷，因此不存在与
$\varepsilon$ 无关的曲率算子统一下界。独立 Reviewer 重新计算了全部 36 个矩阵元、
Bianchi 恒等式和负特征向量。这是项目内形成的原创精确紧致构造，但尚未完成文献新颖性审计，也不声明全球首创优先权。

### 20001862：伪三角剖分路线的半周旋转障碍

构造一个具有有理坐标、在带标号半周旋转下不变的八顶点简单非凸多边形。每个
pointed pseudo-triangulation 补全都包含四条非原多边形凸包边，它们组成两个对称轨道。
标准 Streinu 路线删除其中一条边后，其半周旋转伙伴仍是刚性杆；如果保持原有对称性，
被删除边的距离也会被重新锁定，从而无法产生非平凡的第一段运动。

该成果补出了显式坐标和可重放的精确证书。它不否定不同的
Connelly--Demaine--Rote 构造，也不否定一次删除整个对称轨道的方法。AIM 在 2015
年已经记录答案为否，因此这是一项显式重建，而不是首次给出负面答案。

### 20001382：逆树状 Galois 问题的闭性障碍

AIM 问题的字面表述询问无限根二叉树自同构群的任意子群能否成为 Galois 像。连续
Galois 像是紧的，因而必然是闭子群；但有限支撑树自同构群稠密、真包含且非闭，所以
不可能作为这样的像。

这项成果指出原表述缺少必要的闭性条件。它没有证明任何特定闭子群不可实现，也没有
解决针对指定闭子群的自然逆问题。

### 20000916：任意范数 Steinitz 表述的 $\ell_1^d$ 障碍

AIM Problem 1.4 的字面公式允许任意范数，同时声称一致的 $O(\sqrt d)$ Steinitz
上界。在 $\ell_1^d$ 中，一个显式零和向量族迫使任意排列都出现满足

$$
S(B_1^d)\geq\frac{d+1}{2}
$$

的部分和。线性下界排除了任意范数版本，但不反驳欧氏范数猜想
$S(B_2^d)=O(\sqrt d)$。该向量族来自 Grinberg 和 Sevastyanov 的已有工作；Argus
完成的是来源核对、证明重建与命题范围审计，而不是首次发现该构造。

### 20000320：弱 Q-Gorenstein 条件与基变换

对 Lee--Nakayama 曲面族在正特征下的第一阶 Artin 加厚

$$
B=\mathrm{Spec}\left(k[t]/(t^2)\right),
$$

弱或 naive Q-Gorenstein 条件成立，但第二反身多重典范幂不满足相对 $S_2$，并在闭点
基变换下失败。因此，AIM Problem 1.1 字面表述中的无限制等价关系不成立。

该例子使用正特征和非约化基，不与 Hacking 的特征零 DVR 定理冲突，也不处理仅限典范
极化曲面或稳定曲面的版本。这是一项基于原始文献的结果重建。

### 3206：图核为 $C_5$ 的 $\mathbb Z_{15}$ Cayley 图

在 $\mathbb Z_{15}$ 上取连接集

$$
\{1,4,6,9,11,14\},
$$

得到的 Cayley 图以 $C_5$ 为图核。由于 $5$ 不是 $15$ 的任意非负整数次幂，它反驳了
Open Problem Garden Problem 125 的任意阿贝尔群字面版本。重放程序检查图结构、到
$C_5$ 的收缩、$C_5$ 的全部 $5^5$ 个映射以及基数障碍。

问题作者后来澄清主要关注的是 $\mathbb Z_p$。该构造不处理素循环群、初等阿贝尔群或
cubelike graph 版本。反例在 2008 年已经公开，因此本成果是独立验证重建，不是首次发现。

### 20001068：加权有向图精确反例

构造一个包含 26 个顶点和 74 条弧的有限无环边、无重边加权有向图。每个顶点的总入权和总出权都至少为 1，但全部 40 个简单有向圈的权重都等于 $19/20$。

因此，它反驳的是 AIM Conjecture 6.23 的**字面弱不等式版本**。它不反驳强连通版本，也不反驳要求每个顶点入权和出权都严格等于 1 的版本。

### 11000263：Bigelow Question 6 的修正版结论

原文最后一条关系在 $RB_n$ 中使用了并不存在的生成元 $\sigma_n$，因此字面展示的商并非良定义。对两个自然的良定义修复版本，非约化 Burau 表示给出

$$
\rho(X_3)=(q-u)(q^2-u)E_2\neq0.
$$

结论只针对仓库中明确写出的两个修复版本。后续计算进一步在表示层回答了 Stephen Bigelow
提出的 twist 问题：

$$
\rho(\sigma_1X_2)=-u\rho(X_2),\qquad
\rho((\sigma_1\sigma_2)^3X_3)=u^3\rho(X_3).
$$

取 $u=q^3$ 后，同一表示满足 $X_4=0$，而 $X_3$ 仍为非零秩一矩阵。将该表示与特化的
BMW 商表示取联合像，可得到一个有限维辫群代数；它满射到 BMW，且由 $X_3$ 检测到非零核。
阶数 4 至 8 的精确符号检查和独立有限域复算均已通过。

这完成了邮件中要求的表示层有限维构造，但不证明加入三条新关系后的普适商本身有限维。
目前仍等待 Bigelow 确认约定、专业同行复核和出版级新颖性检索，因此不声明全球首创优先权。

### 2884：K3 Problem 4.8 的表述范围修正

取固定环境对

$$
(X,F)=\left(E(2)\mathbin{\sharp}(S^2\times S^2),\ \text{正则椭圆纤维}\right).
$$

其中 $\sharp$ 表示连通和。

两个素纽结 $T(2,3)$ 与 $T(2,5)$ 既不相同，也不互为镜像；结合已发表的稳定化定理，可以得到相应纽结手术流形之间的微分同胚。

这否定的是 Problem 4.8 对任意 *X* 的字面表述，**不解决**固定 *X* = E(2) 时真正的 Fintushel--Stern K3 猜想。

## 证据与措辞原则

每个成果目录都会分别说明：

1. 已经支持的精确命题；
2. 尚未覆盖的相邻版本；
3. 技术报告或数学说明；
4. 机器可读证书和重放程序；
5. 当前审查层级；
6. 新颖性和优先权边界。

“已验证”“已审查”“已形式化”等词只按
[`docs/status-and-scope.md`](docs/status-and-scope.md) 中的定义使用。

## 重放验证

建议使用 Python 3.10 或更新版本：

```bash
python -m pip install -r requirements.txt
python scripts/verify_artifacts.py
python results/3206/replay.py certificate > /tmp/result-3206.json
python results/11000263/verify_burau.py
python results/20001068/verify_counterexample.py > /tmp/result-20001068.json
python results/20001836/verify.py > /tmp/result-20001836.json
python results/20001862/replay.py verify results/20001862/certificate.json
python results/2813/replay.py > /tmp/result-2813.json
python results/4600048/verify.py > /tmp/result-4600048.json
```

2884 的原始验证程序还依赖研究过程中保存的来源摘录和 Jacobian 重放文件；这些输入目前并未全部包含在公开下载包中。因此仓库保留该程序用于来源追踪，但不会把它描述为可独立完成全部复核的脚本。Lean 文件检查的具体范围见
[`statement_fidelity.md`](results/2884/statement_fidelity.md)。

## 如何审查

欢迎数学同行复核。提交意见时，请注明成果编号、所质疑的精确命题或边界，并尽量提供可重放计算、具体反例或准确的文献定理位置。
