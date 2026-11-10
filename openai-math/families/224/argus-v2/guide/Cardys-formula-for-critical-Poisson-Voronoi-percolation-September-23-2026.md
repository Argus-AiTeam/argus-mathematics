**独立终审结论：接受本文对几何及颜色平均（annealed）的 Cardy 主定理之手工证明核验，决定性证明链未见未闭合步骤。** 有限正交恒等式另经精确枚举核对，非退化结论还能从原证明提取显式数值界。

**精确命题。** 对每个**固定**有界 Jordan 域 \(D\) 及其边界上按逆时针排列的四个不同标记 \(a,b,c,d\)，在全平面取强度 \(\varepsilon^{-2}\) 的齐次 Poisson 点过程，条件于点集独立、公平地染黑白两色。令 \(\mathcal B_\varepsilon\) 为所有**闭**黑 Voronoi 胞的并；事件 \(\mathcal C_\varepsilon\) 是 \(\mathcal B_\varepsilon\cap\overline D\) 含有同时接触闭弧 \(ab,cd\) 的连通子集。没有额外边界布线，也不把域外黑连通当作域内横穿。将 \(a,c,d\) 共形映到 \(0,1,\infty\)，记 \(b\) 的像为 \(x\in(0,1)\)，则
\[
 \lim_{\varepsilon\downarrow0}\mathbb P(\mathcal C_\varepsilon)
 =F(x)=
 \frac{\int_0^x[u(1-u)]^{-2/3}\,du}
      {\int_0^1[u(1-u)]^{-2/3}\,du}.
\]
这里 \(\mathbb P\) 同时对几何和颜色平均；固定几何后的颜色概率称为条件概率（quenched）。上述命题是原文 Theorem 1.1，定位 `00-introduction.tex:14–64`，尤其第 38–51 行；最后的 Proposition 9.6 位于 `08-observable.tex:587–770`，负责把证明中的离散事件转回这一**精确**事件。

本报告针对 OpenAI，2026-09-23，指定提交 `4eaee87548250b2682affda7d05d947c05554bae`。下文源码文件均相对于 `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/`；九个节文件的 Git blob 均与该提交公开目录元数据逐一相符，证据为 `evidence/cardy/pinned-sections.json`。本文没有随附官方 Lean。

## 问题、路线与核心机制

临界参数等于 \(1/2\)、RSW 和臂事件估计，都不能单独决定横穿概率的极限函数。三角格上的 Smirnov 方法有精确的颜色交换关系和等边几何；Poisson–Delaunay 三角形虽然仍可交换颜色，却不再等边。本文要消去的正是这个**嵌入几何缺陷**，而不是重新证明 RSW。

核心是两层结构。第一层纯组合：异色原图边所对应的对偶边构成颜色分界回路；删掉其中一条回路后，每个剩余组件各给一个坐标，得到不同三角形之间的精确正交关系。含对偶顶点的组件具有简单单色边界，本文称其为单色边界回路（rim），记为 \(P\)。第二层用平稳性将完整大边界回路的缺陷场做小，再通过固定端点状态的闭合实验，把它开成随机弧上的
\[
                         Q_P(f)\simeq aV_P(f).
\]
这不是说每条边的几何缺陷都小，也不是将一个小的闭回路积分直接限制到子弧。把端点项、随机选弧的条件和有符号和的误差一起保留下来，才得到后面的解析关系。

| 首读顺序 | 做什么 | 关键输出 |
|---|---|---|
| §2 正交场 | 有限球面恒等式、边界回路的拓扑极值性、平稳闭和 | 禁止同色右绕行、完整大边界回路的 \(Q\) 尾和趋零 |
| §3 概率输入 | 外部估计、混色四臂、双近返回、双接点门回路（gate） | 粗幂界中的正指数余量 |
| §§4–5 端点装置与仿射分解 | 用端点装置（plug）保留局部状态；比较闭合实验、插入中间端点 | 状态余链（cochain）、仿射位移、两个端点势和 \(O(h(1+k))\) 偏差 |
| §§6–7 定位点与真实弧 | 在相关边界回路上布足定位点（pin）；保留选弧条件；细化有符号场 | 对所有宏观边界回路同时成立的内部区域传输（bulk transport） |
| §8 非退化 | 将切向场换成轮廓积分，以面积差排除退化 | \(1-2\operatorname{Re}a>0\) |
| §9 可观测量 | 闭合星形构造、相关随机权测度、边界唯一性、固定缓冲夹逼 | Cardy 极限及任意 Jordan 域闭胞事件 |

第一次可略读 §5 标准螺旋的逐段距离计算，但不能跳过它所保证的**统一短模板常数**；否则容易误以为任意贴合弧线的细长连接带，其条件成功概率也有统一下界。

### 简短符号表

| 符号 | 含义 |
|---|---|
| \(\eta=X_\varepsilon\)、\(\mathbb P^\eta\) | Poisson 几何；固定几何后的公平颜色概率 |
| \(\omega=e^{2\pi i/3}\) | 三阶单位根，不是一个渗流配置 |
| \(L,C,\lambda=(L,C)\) | 颜色分界的对偶回路；删去其所有点后的一整个组件；完整坐标标签 |
| \(P\) | 含对偶顶点的组件之单色边界回路，定向使组件在左 |
| \(p_t,q_t\) | 顺时针边向量 \(d_{tj}=p_t\omega^j+q_t\bar\omega^j\) 的两种 Fourier 系数 |
| \(U,Q,V=U+Q\) | 复线性场、反线性缺陷场、加权切向位移 |
| \(h,r_h=h^{1-\kappa}\) | 先固定的端点装置比较尺度；沿边界回路的分块尺度 |
| \(\sigma,\mu,G\) | 保留的端点状态；其在可用状态事件 \(G\) 下的条件分布 |
| \(a_h,a\) | 仿射缺陷系数及其子列极限；不是上面的边界标记 \(a\) |
| \(F_m^\eta,F\) | 固定几何的闭合星形可观测量；其对几何平均后的连续极限 |

## 决定性步骤怎样核验

### 1. 全组件标签为何必需：正交不是“回路两侧”的恒等式

固定球面三角剖分及其颜色配置，记对偶图为 \(\Gamma\)。对每个完整标签 \(\lambda=(L,C)\) 和对偶边内部点 \(m\)，定义组件指示量
\[
 H_\lambda(m)=\mathbf1_{\{m\in C\}},\qquad
 H(m)=(H_\lambda(m))_\lambda.
\]
在对偶顶点 \(t\) 的三个支边上，各取一点 \(m_j(t)\)，指标 \(j=0,1,2\) 按正向循环序排列，所取小星形邻域两两不交。定义
\[
 Z_t=\sum_{j=0}^2\omega^jH(m_j(t)),\qquad
 \langle A,B\rangle=\mathbb E_{\rm sp}\sum_\lambda A_\lambda\overline{B_\lambda},
\]
其中 \(\mathbb E_{\rm sp}\) 只平均固定图上的公平颜色。`01-fields.tex:96–244` 的双缺陷双射（two-defect bijection）将
\[
 K(m,n)=\mathbb E_{\rm sp}\sum_\lambda H_\lambda(m)H_\lambda(n)
\]
变成双缺陷随机子图中的期望回路数。切开两个小星后，一端只有一个占用端口时贡献不依赖那端指标；各有三个占用端口时，一条贯通路径的贡献仍是两个单指标项，三条贯通路径的匹配则反转正向循环序：
\[
 \pi(j)=\ell-j,\qquad
 \sum_j\omega^{j-\pi(j)}
 =\omega^{-\ell}\sum_j\omega^{2j}=0.
\]
这给出一般有限球面上 \(t\ne u\) 时的 \(\langle Z_t,Z_u\rangle=0\)。对角项是该三角形不全同色的概率，等于 \(3/4\)。两步都是手工核对的组合论证，不靠后面的连续极限。

删回路必须连顶点一起删；一条未用对偶边即使两端都在回路上，其开内部仍是组件。最小示例就是四面体：本报告枚举其 16 种染色，若删掉这些孤立开边坐标，对角从 \(3/4\) 变为 \(3/8\)；若只把一个星的循环序反转，则出现 \(3\omega/8\) 的非零非对角项。**原文明确保留这些坐标，因此这两个反例是约定的必要性检验，不是论文错误。**

另外四个显式球面三角剖分的全部染色也逐一通过；总共 496 种染色，用 \(\mathbb Q(\omega)\) 的整数系数运算，没有浮点阈值。检验器还拒绝重复面和不一致面定向：
`python3 evidence/cardy/check_fields.py evidence/cardy/finite_spheres.json`。
这些有限例子补充而不取代上述一般证明。

在平面图中，\(z_t\) 是三角形 \(t\) 的重心，\(d_{tj}\) 是第 \(j\) 条支边所跨原图边的顺时针向量。分解
\(d_{tj}=p_t\omega^j+q_t\bar\omega^j\)。
若 \(L\) 经过 \(t\)，且未占用的第 \(j\) 条支边进入 \(C\)，称 \(t\) 为标签 \(\lambda\) 的标记三角形。两场具体是
\[
 U_\lambda(g)=\sum_{t\text{ 以 }j\text{ 标记 }\lambda}g(z_t)p_t\omega^j,
 \qquad
 Q_\lambda(g)=\sum_{t\text{ 以 }j\text{ 标记 }\lambda}g(z_t)q_t\bar\omega^j.
\]
对应组件有边界回路 \(P\) 时也写成 \(U_P,Q_P\)；\(V=U+Q\)。边向量分解和正交性给出
\[
 |p_t|^2-|q_t|^2=4\,\operatorname{Area}(t)/\sqrt3,\qquad
 \mathbb E_{\rm sp}\sum_\lambda |Q_\lambda(g)|^2
 =\tfrac34\sum_t|g(z_t)q_t|^2,
\]
\(U\) 同理。权 \(g\) 可依赖几何，**不可依赖颜色**。对孤立组件仅有 \(V_\lambda(1)=0\)，不能顺便断言 \(U,Q\) 各自为零。

`01-fields.tex:248–363` 的边界回路及禁止右绕行引理另需拓扑：同一原图顶点周围的组件扇区若有两个分离区间，便与连通的分界回路形成交错接点的两个不交连接，这是平面圆盘中不可能的。故边界回路简单；其右侧各三角形的第三顶点同属一个反色簇，排除同色右绕行。比较不同配置时，后面的门回路一致性引理只在各自原图使用这个性质，不要求修改后的整条原边界仍是这样的边界回路。

### 2. 从闭和到端点势：哪里用平稳性，哪里不能省端点

`01-fields.tex:402–452` 的平稳随机测度
\[
 \mu=\sum_P|Q_P(1)|^2\delta_{b(P)}
\]
有有限强度，其中 \(b(P)\) 是边界回路各顶点的平均位置。先只留标记三角形的重心离 \(b(P)\) 不超过固定 \(s\) 的边界回路，用确定性扩大窗口和能量界，令大窗口面积比趋一，再令 \(s\) 增大。每条边界回路有限，故其大直径尾强度 \(\theta(M)\to0\)。缩放后闭和上界为
\(\operatorname{Area}(B)\theta(a/\varepsilon)\)。
这一步只适用于**完整**边界回路；文章随后用 §§4–7 处理开弧。

固定的双颜色连接带，其成功概率有正下界，但这个数可依赖其全部几何。`03-plugs.tex:214–290` 先固定几何，用分离黑白层中的同一乘积偏序做 FKG，再积分并减去坏几何概率，得到 \(q_e(\beta^2-\delta_\varepsilon)\)；没有把对几何平均后的黑侧条件成功概率，当作固定几何后的下界。

记 \(\nu\) 为普通全平面模型的联合分布，\(G_s\) 为端点 \(s\) 的可用状态事件，\(\mu_s=\nu(\sigma_s\in\cdot\mid G_s)\)；\(S_e\) 是有向连接带 \(e:s\to t\) 上双颜色通路成功的事件。闭合实验先独立抽取各端点状态，再独立抽取以 \(S_e\) 为条件的各连接带外部数据，其相对于 \(\nu\) 的密度是
\[
 \prod_s\frac{\mathbf1_{G_s}}{\nu(G_s)}
 \prod_{e:s\to t}
   \frac{\mathbf1_{S_e}}{\nu(S_e\mid\sigma_s,\sigma_t)}.
\]
对固定几何布置它有界，故闭和小量可以传过去。两个共享状态的实验，由双门回路、固定邻域和禁止右绕行，识别出**完整的被比较路径及其所有邻接三角形**；只共享事先选的见证路径会不够。

具体地，令 \(X=Q\) 或 \(V\)，\(B_s=\overline B(z_s,m_sh)\) 为端点截止球，\(\mathcal B_e\) 为连接带区域，包括两端装置内的对应部分。实验中选出的受限边界回路 \(P\) 在两处的场质量定义为
\[
 \widehat m_s=X_P(\mathbf1_{B_s}),\qquad
 \widehat j_e=X_P\!\left(\mathbf1_{\mathcal B_e\setminus(B_s\cup B_t)}\right).
\]
指示函数都作用于标记三角形的重心：前者取完整起点截止球，后者取从起点第一门回路出口到终点第一门回路入口之间、两截止球以外的部分。在固定短参考闭合中，令
\(m_s^\varepsilon(\sigma_s)=\mathbb E[\widehat m_s\mid\sigma_s]\)；
在固定双装置闭合中，以 \(\xi_e\) 表示保留的连接带外部数据，令
\[
 j_e^\varepsilon=\mathbb E[\widehat j_e\mid\sigma_s,\sigma_t,\xi_e],
 \qquad
 i_e^\varepsilon=m_s^\varepsilon+
          \mathbb E[j_e^\varepsilon\mid\sigma_s,\sigma_t].
\]
这给出状态余链的具体条件均值定义。共享路径的比较保证这些定义适用于其他闭合；条件于状态独立重采样一条连接带的外部数据，再将两个小的完整闭合和相减，得
\[
 \widehat m_s+\widehat j_e=i_e^\varepsilon(\sigma_s,\sigma_t)+o_{L^1}(1),
 \qquad \sum_e i_e^\varepsilon=o_{L^1}(1).
\]
这就是 `03-plugs.tex:502–572` 的闭和到状态余链的传递。

`04-affine.tex:35–180,385–465` 的后续拆分也经核对。相同参考端点装置的直线均值由插点变成加性函数，短区间统一有界消除病态 Cauchy 解；刚体协变给复标量乘位移。切向场以确定性切割掩码校准为 \(a_h^V=1\)。长连接带插入辅助状态后将它们全部平均，只有固定首、尾短插入留下均值为零的端点势：
\[
 i_e^\varepsilon
 =a_h^X(z_t-z_s)+\phi_s^{X,+}(\sigma_s)
  +\phi_t^{X,-}(\sigma_t)+b_e^\varepsilon+\rho_e^\varepsilon,
\quad
 \|\phi^\pm\|_2=O(h),\quad |b_e^\varepsilon|\lesssim h(1+k).
\]
这里 \(k\) 是两端整数绕转次数绝对值之和。螺旋的总长度可能是 \(h(1+k)^2\)，但只有 \(O(1+k)\) 个短角模板付偏差；所有长直线段已由其**准确极限均值**吸收到仿射项。

### 3. 稠密定位点和随机弧的选择条件

`05-pins.tex:61–274` 先用混色四臂界，使足够多分离圆环中至少三个无三条同色横穿；Menger 和 Hex 造出仅有两个路径同色接点的门回路。双近返回估计
\[
 \mathbb P(\text{在 }s\text{ 尺度内两次访问，且两条互补弧都到达 }S\text{ 尺度})
 \lesssim(s/S)^{2+c}
\]
给出局部的直径逆控制：足够接近的两次访问之间必须有一段小直径弧。其网格并合代价为
\(O(L^2\delta_j^c\eta_j^{-2-c})\)，可求和。它控制的是带顺序的 Fréchet 轮廓，而不只是 Hausdorff 轨迹；没有长度界仍可抽得简单极限弧。§6 的精确匹配再用 Radó 和两半矩形的边界对应，把接近的简单弧**恰好**拉成预设中线；仅有“贴近某条曲线”不够保留门回路的通过顺序。

这里用到的 \(c>0\) 是有余量的粗幂界，不是待证的 \(5/4\) 四臂指数。混色四臂的颜色重排与近返回的文章内推导是 §3 的独立局部论证：最后近返回给 \(A_5\square A_1\)，先在固定几何下用 Reimer，再
\[
 \mathbb E[p_5^\eta p_1^\eta]
 \le\sqrt{\mathbb E(p_5^\eta)^2\,\mathbb E(p_1^\eta)^2}
 \lesssim\alpha_5\alpha_1
 \lesssim(s/S)^{2+c_1}.
\]
它没有假设一个通常不成立的、对几何平均后的 BK 乘积上界。固定物理尺度和微观截断尺度的区分也保留到了每次网格并合。

局部预处理只在隔离的反色层将现有点改染白色，不移动点，也不动实际黑轨迹；其核由有限偏序耦合得到。是否启动仅看几何，不以“已经匹配到某条边界回路”为条件，所以输出在未选弧前有统一密度上界。截断根组件的排序名次、排除条件成功概率过小和未获准使用的类型，再把罕见的失败标记升为有限依赖范围的坏块链，给出所有相关宏观边界回路的稠密定位点。次序须为：先固定归一化的有限模板集和阈值，后取 \(\varepsilon\to0\)，最后 \(h\to0\)。

最关键的是 `06-actual-arcs.tex:254–529` 的真实弧比较。令 \(A_e\) 表示原配置至少有一条匹配弧，\(E_0\) 为共同的覆盖、绕转及几何好事件；作者保留原始输入分布的限制测度
\(\mathsf P|_{A_e\cap E_0}\)，**不归一化**。两端已指定的预处理后，其配置边缘分布 \(\lambda\le C\nu\)。条件于完整几何和两端状态，白色强制操作涉及的全部未保留潜在点，构成一个在看颜色前由几何确定的有限点组；两侧条件成功概率和续接通道给
\(\nu(W\mid Z)\ge q_0>0\)。
对固定状态的强制核和非负测试函数 \(g\)，有
\[
 \lambda K\le(C/q_0)\nu,\qquad
 \int\lambda K g
 \le C\int_H\frac{\nu(\mathbf1_Wg\mid Z)}{\nu(W\mid Z)}\,d\nu^Z
 \le(C/q_0)\nu(g).
\]
这里 \(Z\) 是保留的完整几何及两端状态，\(H\) 是上述下界成立的 \(Z\) 值集合，\(W\) 是白色连接成功事件；\(K\) 保留 \(Z\)，在普通条件分布下将其余颜色送到以 \(W\) 为条件的分布。这项测度计算不要求经选择的输入仍有独立条件颜色。保留端点状态和整个已使用的连接带区域后补齐另一条连接带，再以同一输出边界回路比较**所有**匹配的输入弧；门回路一致性在一个共同好事件上给出逐条路径相等。因此最后只对固定 \(h\) 的有限几何布置并合，不对随机弧数目并合，也不除以随机匹配概率。

### 4. 有符号场为什么不能用系数一致接近直接替换

内部区域传输固定 \(\operatorname{supp}f\subset B(x,R)\)，考虑离开 \(B(x,4R)\) 的边界回路在 \(B(x,2R)\) 内到达 \(B(x,3R/2)\) 的极大游程。
对一条原始边界回路 \(P\) 上的有序定位点 \(s,t\)，令 \(p_s,p_t\) 是其标记顶点，\(D_s,D_t\) 是对应截止球。记 \(X_P(\ell)\) 为有向边 \(\ell\) 的右侧标记三角形所给的单边场贡献，定义
\[
 I_X(P;s,t)=X_P(\mathbf1_{D_s})+
 \sum_{\substack{\ell\text{ 位于正向弧 }p_s\to p_t\\
                  \text{右侧标记三角形重心}\notin D_s\cup D_t}}
                    X_P(\ell),\qquad X=Q,V.
\]
第一项取**完整**起点截止球，而不仅取标记顶点之后的部分；终点截止球则全不取。`06-actual-arcs.tex:531–645` 用这一约定得到
\[
 \sum_{i<j}I_X(P;s_i,s_{i+1})=I_X(P;s_0,s_j)
\]
严格成立。在上述游程上选有序定位点 \(s_0,\ldots,s_l\)，首尾仍在 \(f\) 支持外。取分块系数 \(F_i=f(z_{s_i})\)，分部求和后 \(F_0=F_l=0\) 消掉起点势，\(Q-a_h^QV\) 消掉位移；终端势的平方期望在原始局部预处理分布下为 \(O(h^2)\)，不再带长连接带的密度常数。

不能把 \(O(r_h)\) 的系数误差乘上边界回路总边长。`06-actual-arcs.tex:651–878` 另造**确定性**二进方格分割，第 \(j\) 层边长为 \(s_j=2^{-j}h\)，并先按所有候选截止球的归属进一步分成原子。同一回路在一个原子中的标记三角形若被赋予不同的数值系数，就称该原子对这条回路是混合的。

混合原子中的不同系数不能来自同一个已选截止球。取其中一个非零系数的标记三角形，它位于前后两个定位点的截止球之外；沿回路两个方向分别经过这两个定位点，故两段都至少离开固定倍数 \(h\) 的邻域。这里只需距离下界，定位点实际可远至 \(O(r_h)\)。因此可应用从 \(s_j\) 到 \(h\) 的近返回估计。

为写清计数，令 \(\mathcal G\) 为定位点、覆盖和真实弧比较同时成立的好事件，\(\mathcal H_\varepsilon\) 为只依赖几何的内部区域一致事件，且 \(\mathcal G\subset\mathcal H_\varepsilon\)。在 \(\mathcal G\) 上，\(j\ge1\) 时 \(N_j\) 数的是：**对至少一条相关边界回路而言，其父原子混合的第 \(j\) 层几何子原子**。每个原子只计一次，不论多少条回路经过；\(N_0\) 则计当前使用的非空原子。设 \(\widehat N_j=\mathbf1_{\mathcal G}N_j\)，在坏事件上取零。近返回的 \(2+c\) 幂与分离外环的一臂概率相乘，给出
\[
 \limsup_{\varepsilon\to0}\mathbb E\widehat N_j
 \lesssim h^{-2+c}2^{-cj}.
\]
对第 \(j\) 层原子 \(D\)，令 \(f_D\) 为 \(f\) 在其所属方格中心的值，定义
\[
 B_j=\sum_{D,\lambda}\left[
   \left|X_\lambda(\mathbf1_D)\right|^2+
   s_j^{-2}\left|X_\lambda\!\left(\mathbf1_D(f-f_D)\right)\right|^2
                    \right].
\]
这里对**全部确定性原子及全部完整标签**求和，不按自适应系数筛选。令
\(\widehat B_j=\mathbf1_{\mathcal H_\varepsilon}B_j\)；全平面时该几何指示量恒为一。Bessel 界和 \(\lvert f-f_D\rvert\lesssim s_j\) 给
\(\limsup_{\varepsilon\to0}\mathbb E\widehat B_j=O(1)\)。
一条回路在第 \(j\) 层的停止原子上，系数误差不超过 \(Cr_h\)，故其该层误差由
\(Cr_h\sqrt{\widehat N_j\widehat B_j}\) 控制；这也同时控制所有回路的最大值。再在概率空间用 Cauchy–Schwarz，得
\[
 \mathbb E(\text{第 }j\text{ 层最大误差})
 \lesssim r_hh^{-1+c/2}2^{-cj/2}.
\]
这是可求和的；所有标签的平方和已在 \(B_j\) 中，不再乘回路数。
固定 \(h\) 先取**有限** \(J(h)\)，使残存混合原子概率至多
\(Ch^{-2+c}2^{-cJ(h)}\)，然后取微观极限 \(\varepsilon\to0\)，最后 \(h\to0\)。选 \(0<\kappa<c/2\)，两种主误差分别为
\(h^{c-\kappa}(1+\log^2h)\)、\(h^{c/2-\kappa}\)，均消失。

### 5. 非退化：从逐回路小量到全标签期望需要另一段证明

`07-nondegeneracy.tex:46–259` 先补足从依概率收敛到期望收敛所需的控制。它设
\(Y_P=\oint_Pf\,dz\)，孤立组件取零；由每个标记三角形上的 \(O_f(\operatorname{diam}(t)^2)\) 误差预算，证明
\[
 \mathbb E\sum_\lambda|Y_\lambda-V_\lambda(f)|^2\to0.
\]
其中最大单标签预算趋零来自“一条宏观边界回路在固定小盒中出现必有一臂”，总预算有高阶矩；小边界回路则装进 \(O(b)\) 盒。

Stokes 控制轮廓积分；对每条分界回路，其对应的各边界回路中至多两个的有界内部覆盖同一普通点。这里用的是**面积重数**，不是对应的边界回路总数。固定尺度的不同分界回路数，由固定几何下的环路概率界、BK 和高概率几何，得到任意固定高阶矩；坏几何以任意多项式小概率对冲邻接三角形数的多项式矩。于是
\[
 \lim_{b\downarrow0}\limsup_\varepsilon
   \mathbb E\sum_{\operatorname{diam}P<b}|Y_P|^2=0,
\]
且大边界回路的平方和有高于一阶的矩。若 \(R=Q-aV\)，这才足以推出
\(\mathbb E\langle R,V\rangle\to0\)。

最后交叉项在实部**精确**抵消：
\[
 (1-2\operatorname{Re}a)\,\mathbb E\|V(f)\|^2+o(1)
 =\mathbb E(\|U(f)\|^2-\|Q(f)\|^2)
 \longrightarrow\sqrt3\int|f|^2>0.
\]
能量给 \(\mathbb E\|V(f)\|^2\) 有界，故系数严格为正。这里一致可积性、小边界回路的控制及孤立开边的处理共同保证了全标签期望的合法性。

### 6. 可观测量、全纯极限及任意 Jordan 闭胞事件

`08-observable.tex:55–228` 在离散圆盘外加入三个独立公平染色的扇形顶点，闭成球面。对域内对偶探测点 \(m\)，在闭合星形的三个支边上取探测点 \(n_i\)，按反向循环序编号，定义可观测量
\[
 F_m^\eta=4\sum_i\omega^iK(m,n_i).
\]
双缺陷随机子图中，以该星度数为三为条件时，与 \(m\) 相连的支边编号给出这一表示，解释了因子 \(4\) 和凸性：度数为三的概率恰为 \(1/4\)。在扇形探测点处拆出第四个域外顶点，固定四个域外顶点交替染色；奇偶双射留下原圆盘中所有点的独立公平颜色。两个非交叉配对之一等价于原圆盘中**无布线**的黑色横穿，因此相应边上的特定系数正是横穿概率。外加扇形是证明工具，没有改变主定理的边界条件。

探测点处的紧性由同一个臂事件同时控制附近所有按几何选取的边；不对“选哪条边”并合。闭合星形的正交关系先消去 \(U\) 场，内部区域传输和 \(a\ne1\) 再给出切向项的消去。

真正需要填清的是相关性，详见 `08-observable.tex:350–463`。固定几何下的可观测量 \(F_e^\eta\) 与几何权都依赖点集 \(\eta\)，不可分离期望。对相邻三角形 \(t,t'\) 的公共边 \(e\)，令 \(d_{t,e}\) 为它相对于 \(t\) 的顺时针向量，\(m_e\) 为中点；合并两侧贡献后设
\[
 \mu_\varepsilon
 =\sum_{e=t\cap t'}d_{t,e}\{f(z_t)-f(z_{t'})\}\delta_{m_e}.
\]
光滑测试的中点替代误差总量为 \(o_{L^1}(1)\)；确定性方块的边界带再用局部全变差界去掉，遂有
\(\mu_\varepsilon(B)\to\int_Bdf\wedge dz\) 于 \(L^1\)。
在边长为 \(s\) 的固定方格分割中，每格选一个代表值 \(F_B^\eta\)。其模不超过一，允许把这个**确定性极限**从相关乘积中取出；同盒各边的可观测量差另用臂事件和 Cauchy–Schwarz 控制，使每盒误差为 \(O(s^{2+c/2})\)。按 \(\varepsilon\to0\)、\(s\to0\) 的次序才得
\[
                         \int F\,df\wedge dz=0,
\]
即分布意义 \(\bar\partial F=0\)，从而极限 \(F\) 全纯。

Lemma 9.5 的边界唯一性也不预先假设三个标记处连续。Schwarz 反射与 Hopf 引理给每条开边界弧上的辐角严格递增，因此有单侧极限；若标记两侧极限 \(L_\pm\) 不同，Cauchy 核给
\[
 G(r)=\frac{L_+-L_-}{2\pi i}\log\frac1{1-r}
       +o\!\left(\log\frac1{1-r}\right),
\]
与 \(G\) 有界矛盾，这里 \(G\) 是将目标三角形再共形映到圆盘后的函数。连续的圆周迹再以 Poisson 公式给所有内部趋近的连续性；辐角原理的度数一最终给出共形双射，确定边值问题的唯一解。

最后的 Proposition 9.6 值得单独读。先在 Schoenflies 坐标把原域化成正方形，固定 \(\delta>0\)，用更宽且更矮、较窄且较高的两个四边形域夹住横穿事件。固定这些缓冲和其多边形近似，再令 \(\varepsilon\to0\)；坐标图只需紧集上一致连续，不需 Lipschitz。

反向比较中，原事件只有一个连通集，不应擅自假定有一条域内连续路径。原文先取闭包 \(K\)，以局部有限性留下有限个黑胞 \(C_j\)；非空闭覆盖 \(K\cap C_j\) 的相交图必连通，否则分成两个不交闭集会分离 \(K\)。因此得到相接黑胞链。Poisson 一般位置下三胞相会的各核两两相邻，连仅在 Voronoi 顶点接触的情形也成为 Delaunay 顶点链。网格直径小时，该链靠近 \(K\)，可在同一平面图中截出较易横穿的缓冲圆盘域内的顶点横穿。这正好覆盖主定理的闭胞、连通集约定。最后令 \(\delta\to0\)，Radó 的有序 Jordan 收敛使共形参数也收敛。

## 外部依赖与已读版本

本篇用外部文献提供的是下列明确接口；已读原命题不等于在本报告重证其整篇证明。

| 来源、版本与位置 | 实际接口及应用检查 |
|---|---|
| Vanneuville，*Quantitative quenched Voronoi percolation*，AIF 75(4), 2025，Theorems 1.2–1.4、Proposition 3.14、(3.1)、Proposition 3.4(iii)、Proposition 6.2 | 原文 §3 需要固定宽高比的 RSW、固定几何后与对几何平均后的臂概率二阶矩比较、一／五／四臂粗幂界、固定网格族任意多项式坏几何尾。共用正式刊本为 `evidence/shared-arm-literature/aif3710-published.pdf`；Theorem 1.4 的奇数臂额外黑臂约定也与本文一致。Proposition 3.14 在 p.1666 明列 \(\operatorname{diam}(D)\ge\delta^{-2}/100\)，对固定相对网格的良好条件横穿事件给 \(1-C\operatorname{diam}(D)^{-\gamma}\)；Remark 3.15 再有限拼接。本报告的应用只取固定有限的缓冲模板，先放大到超过该最低尺度，不在任意条件点过程下套用。矩形推论另用 Theorem 1.3 的几何方差；所有缩放都先将物理尺度除以 \(\varepsilon\)。 |
| Reimer 2000 的不交发生（disjoint occurrence）界；可读替代：Borgs–Chayes–Randall，*The Van den Berg–Kesten–Reimer Inequality: A Review*，作者网站的 18 页版本，Theorem 2.1 / (2.3)，p.3 | 替代原文对任意有限乘积概率、任意事件给 \(\mu(A\square B)\le\mu(A)\mu(B)\)，无单调性假设。原出版全文未取到，不把其编号写作已核。作者 PDF 来自 `https://randall.math.gatech.edu/r-bcr-f.pdf`，2026-11-10 留存为 `evidence/cardy/citations/borgschayesrandall-reimer-review.pdf`，核对过的原定理页为 `evidence/cardy/citations/borgschayesrandall-reimer-p3.png`；其可抽取文字乱码，故以页图为准，快照哈希见 `evidence/cardy/citations/SHA256SUMS`。Dan Crytser 的 2010-04-13 讲义 Theorem 6.1，p.4，也直接给本文所需公平二值颜色形式，见 `evidence/cardy/citations/crytser-reimer-2010.pdf`。固定几何中用到的点集有限且颜色公平；对几何平均后仍须另用臂概率二阶矩，不可直接乘概率。 |
| Smirnov，arXiv:0909.4499v1，§2，Lemma 2.1 / Remark 5、Corollary 3，pp.5–6 | 任意三角剖分上的组合颜色交换恒等式；Carleson 等边三角形中的线性横穿公式。原文的 Poisson 几何传输并非由此直接推出。全文 `evidence/cardy/citations/arxiv-0909.4499v1.pdf`。 |
| Beffara，arXiv:1312.7159v2，§§3.2–3.3，(13)–(14)，pp.13–14 | (13) 是同样的组合交换；(14) 仍带嵌入边向量的几何缺陷。其周期性介观细分和尺度假设不适用于本文 Poisson 模型，本文只引它说明障碍，未把其主定理当黑箱。全文 `evidence/cardy/citations/arxiv-1312.7159v2.pdf`。 |
| Antoine 1921，第一部分 I，§16，p.21；§17，pp.21–22，证明在 §20 到 p.27 完成 | 指定 Jordan 曲线／简单弧的对应可延拓到整个平面；这里确为二维、不带光滑性假设。可替代未取得的 Moise 原书相应编号，支持固定端点邻域的连接带构造及精确匹配。全文 `evidence/cardy/citations/antoine-1921.pdf`。 |
| Radó 1923，§1 p.182 的定理，§2 p.183；原页图已检查 | Jordan 边界 Fréchet 收敛，当 Riemann 映射在共同内点归一化且导数正时，闭圆盘上统一收敛。精确匹配中的半矩形有共同内点；最终缓冲域有序收敛，故均满足假设。开篇还明确所用 Jordan 坐标图的闭边界同胚性质。原文 `evidence/cardy/citations/rado-1923.pdf`，定理页 `evidence/cardy/citations/rado-1923-p182.png`。 |
| Hatcher，arXiv:1312.3518v3，Theorem B 及其后的相对边界版本，p.2 | 光滑曲面间的同胚若在边界邻域已光滑，可相对该邻域平滑。§5 两端绕转分类先保留光滑带及端帽的邻域，再仅平滑补集，符合此相对假设。全文 `evidence/cardy/citations/arxiv-1312.3518v3.pdf`。 |
| Cardy，hep-th/9111026v1，(8)，p.7；期刊 1992，L201–L206 | 原始横穿函数的归一化为 \(3\Gamma(2/3)\eta^{1/3}{}_2F_1(1/3,2/3;4/3;\eta)/\Gamma(1/3)^2\)。在 \(0,x,1,\infty\) 下 \(\eta=x\)，与本文完全一致。全文 `evidence/cardy/citations/arxiv-hep-th_9111026v1.pdf`。 |

Moise 10.2–10.4、Pommerenke §2.1 原书的精确页码未独立核到；所需的平面延拓和闭 Jordan 坐标图接口已由上列 Antoine、Radó 原文及本文写出的延拓论证补齐，因此这是**原书编号的书目限制，不是仍待证明的额外假设**。Edwards 的保序耦合引文也不必当黑箱：本文给出的有限最大流割条件已足够。Hatcher 的相对边界版本则确实在所引 v3 中，不能只引不带相对性的抽象平滑定理。

### 替代拓扑来源怎样保留指定对应和端点邻域

这里展开的是原文 `05-pins.tex:293–403`、`04-affine.tex:210–225` 已有的延拓论证，不是新增修补。Antoine §16 的原句明确以“给定两曲线间的双射连续对应”为前提，再将**这一个对应**延拓到全平面；§17 对简单弧先补成 Jordan 曲线，并保留原弧的全部对应。故它不只是说两曲线可以互相拉到。原文精确匹配先把有序简单弧用两条外向射线补成真嵌入直线，再在单点紧化中指定无穷远对应无穷远。球面版本可由平面版本得到：在各曲线外选投影极点，套用 §16，再紧化。无穷远是给定曲线对应中的点，因而被固定；所得延拓限制为保序的平面同胚。

**相对端帽的粘合。** 先在光滑带和端帽邻域给定所需的光滑映射，选其中嵌套的光滑圆盘 \(D_0\Subset D_1\)，使需保留的带轴、端帽及其小邻域都在 \(D_0\) 内。保留 \(D_1\) 上的映射，只将其在 \(\partial D_1\) 的指定对应延拓到外部，再沿共同边界粘合。所得全局同胚在 \(\partial D_0\) 的整个邻域已光滑。现在对 \(D_0\) 外的曲面使用 Hatcher Theorem B 后明确给出的相对版本，平滑时不改该边界邻域；与 \(D_0\) 内原映射粘回，端帽及其邻域便原样保留。相对性来自“先保留邻域、再平滑补集”，不是 Antoine 单独给出光滑延拓。

**精确匹配还需要小位移，而非任意延拓。** 将矩形沿旧中线与新横截弧分别切成两个 Jordan 半域；Fréchet 有序收敛给出边界对应 \(h_n\to\mathrm{id}\)，并可匹配各个标记。每半域选同一个固定内点、正导数归一化的圆盘映射 \(F,F_n\)。Radó p.182 给的是包括圆周的 \(F_n\to F\)，因此
\[
 \chi_n=F_n^{-1}h_nF\big|_{\partial\mathbb D},\qquad
 \|F\circ\chi_n-F\|_\infty
 \le\|F_n-F\|_\infty+\|h_n-\mathrm{id}\|_\infty\longrightarrow0.
\]
固定 \(F^{-1}\) 的一致连续性给 \(\chi_n\to\mathrm{id}\)。作径向延拓
\(R_{\chi_n}(r\zeta)=r\chi_n(\zeta)\)，则
\(g_n=F_nR_{\chi_n}F^{-1}\to\mathrm{id}\)，且在边界**恰等于** \(h_n\)。
两个半域的 \(g_n\) 在共同切口相同，故可粘合。竖边的小高度变换在外侧窄带中与恒等映射作凸插值，仍是严格递增的区间同胚；横边固定，遂能向外延为恒等。最后共轭回原坐标，紧集上一致连续性保留小位移，原有正间距保证其支撑及端点余量。此处从未用 Hausdorff 接近代替有序收敛，也未假设 Jordan 坐标图为 Lipschitz。

### 与已发表公式的数值对照

把 beta 积分、Cardy (8) 的超几何表达式分别计算；正方形的 \(x=1/2\) 由对称性**精确**给 \(F=1/2\)，且 \(F(x)+F(1-x)=1\)。以下仅是同一已发表函数的十进制读数，**不是 Poisson 模拟、收敛速率或新实验数据**。矩形宽高比为 \(\rho\)，横向横穿用
\(x=(\vartheta_2(0,e^{-\pi\rho})/\vartheta_3(0,e^{-\pi\rho}))^4\)。

| \(\rho\) | \(x\) | 本文积分与 Cardy (8) 同值 |
|---|---|---|
| 1 | 0.5 | 0.5 |
| 2 | 0.0294372515228594 | 0.175646893800655 |
| 3 | 0.00129035906222736 | 0.0616380967048880 |

生成命令 `python3 evidence/cardy/check_constants.py`，输出 `evidence/cardy/check-constants.txt`。

## 改进

**将严格非退化显式化。** 原文 Proposition 8.1 只写 \(1-2\operatorname{Re}a>0\)。由同一个配对极限可进一步得到
\[
 |a+r|^2\le r(1+r),\qquad
 r=\frac{5\sqrt3}{4\pi}-\frac12,
\]
因此
\[
 \operatorname{Re}a\le\sqrt{r(1+r)}-r<0.285121,
 \qquad 1-2\operatorname{Re}a>0.429758.
\]
它不识别 \(a\) 的实际值；也不声称圆盘边界一定由 Poisson 模型达到。

这里给出完整新增计算，便于单独核查。在强度为一的 Poisson 模型中，记 \(m_p,m_q\) 为**单位面积的三角形权强度**：对任意面积有限且为正的确定性集合 \(A\)，
\[
 m_p=\frac{\mathbb E\sum_{z_t\in A}|p_t|^2}{\operatorname{Area}(A)},
 \qquad
 m_q=\frac{\mathbb E\sum_{z_t\in A}|q_t|^2}{\operatorname{Area}(A)}.
\]
它们与 \(A\) 无关，不是单个典型三角形的权均值。按重心计，Delaunay 三角形的强度为 2。可直接从三点 Mecke 积分验证：写
\(x_j=z+R(\cos\theta_j,\sin\theta_j)\)，空圆盘概率为 \(e^{-\pi R^2}\)，Jacobian 为
\(2R^3\operatorname{Area}(u_1,u_2,u_3)\)，其中 \(u_j=(\cos\theta_j,\sin\theta_j)\)。将每个坐标对分为径向、切向行，后三列给 \(R^3\)，前三列的行列式是两倍单位圆内三角形面积，便得该 Jacobian。
给定 \(R,\theta_1,\theta_2,\theta_3\) 后，将圆心 \(z\) 改为重心只是一个平移，Jacobian 为一，所以所得单位面积形状分布也正是本处需要的重心分布。按循环序把三个相邻圆周角间隔的一半记为 \(A,B,C\)，\(A+B+C=\pi\)，则面积为 \(2\sin A\sin B\sin C\)。半径密度正比于 \(R^3e^{-\pi R^2}\)，与形状独立，故 \(\mathbb E R^2=2/\pi\)。角积分为
\[
 \int_0^\pi\!\int_0^{\pi-A}\sin A\sin B\sin(A+B)\,dB\,dA
       =3\pi/8,
\quad
 \int_0^\pi\!\int_0^{\pi-A}\sin^3 A\sin B\sin(A+B)\,dB\,dA
       =15\pi/64.
\]
这同时给 \(\mathbb E\sin^2A=5/8\)。计入两种循环次序、\(\theta_1\in[0,2\pi)\)、gap 变换的因子 4 和无序三点的 \(1/6\)，总强度为
\((24\pi^2/6)\int_0^\infty R^3e^{-\pi R^2}\,dR=2\)。
于是典型三角形的平方边长和均值为
\(4(2/\pi)\cdot3(5/8)=15/\pi\)；由
\(\sum_j|d_{tj}|^2=3(|p_t|^2+|q_t|^2)\) 和面积密度一，
\[
 m_p+m_q=10/\pi,\quad m_p-m_q=4/\sqrt3,
 \quad m_q=5/\pi-2/\sqrt3.
\]
令 \(I=\int|f|^2>0\)、\(d=1-2\operatorname{Re}a>0\)。原文配对极限和正面积恒等式给
\(\mathbb E\|V(f)\|^2\to\sqrt3 I/d\)，而精确能量给
\(\mathbb E\|Q(f)\|^2=(3/4)m_qI\)。
对 \(\mathbb E\langle Q,V\rangle=a\,\mathbb E\|V\|^2+o(1)\) 用 Cauchy–Schwarz，得
\(|a|^2\le rd\)，配方就是上述圆盘界。

两个角积分经符号积分重算；十进制不等号另用 Machin 反正切交错级数和整数平方根形成的**有理区间**核验，不依赖浮点精度。检验器还明确拒绝同一圆盘所不能保证的 \(0.28\) 上界。理论依据是上面的手算及原文已核的配对极限；脚本认证有限积分与数值换算。

## 错误与不足

**未发现可以坐实的错误引理、反例或决定性证明缺口。** 重点检查了完整组件坐标、任意随机选弧、端点势与短模板常数、有符号场的分层细化、非退化所需的一致可积性、相关几何权，以及任意 Jordan 域的闭胞事件。

**结论的边界须保持。** 主定理不含全接口/CLE 收敛，不给横穿概率的定量收敛速率，也不含任意 Jordan 域的条件概率极限。Corollary 1.2 是**固定非退化矩形**的条件横穿概率 \(L^2\) 后果：胞与矩形截交后仍凸，故有限接链将连通横穿化为文献中的连续路径横穿。令 \(Q_\varepsilon(\eta)=\mathbb P(\mathcal C_\varepsilon\mid\eta)\)，缩放到单位强度，再用 Theorem 1.3 的几何方差界和
\[
 \mathbb E_{\rm geom}|Q_\varepsilon-F(x_D)|^2
 =\operatorname{Var}_{\rm geom}(Q_\varepsilon)
  +|\mathbb P(\mathcal C_\varepsilon)-F(x_D)|^2.
\]
无需不同网格尺度的共同几何耦合；这是平均主定理的推论，不是其前提。

证明的主要可读性成本，是依赖几何布置的消失误差与短模板的一致常数并行出现。建议把文首已有的极限顺序和这些常数的来源放在首次端点公式旁，并把有限闭合实验的独立重采样与真实弧的未归一化限制明确对照。原文已给足数学区分；这是呈现改进。原书页码核验的限制已在依赖段说明。

## 已核验

已逐步手核从有限正交场到固定缓冲 Jordan 夹逼的决定性链。一般正交性依靠双缺陷双射的逐类 Fourier 抵消；完整传输依靠保留状态的有限实验、次概率测度的支配关系和确定性掩码能量。有限枚举、错误约定拒绝和数值区间认证都有可重跑文件。外部概率论和拓扑输入按上列版本及适用假设使用。

**独立终审范围（2026-11-10）。** 在逐篇独立审查之外，合稿终审直接比对了本篇 Theorem 1.1 与后两篇的标量 Cardy 假设：固定 Jordan 域、全平面强度 \(\varepsilon^{-2}\)、公平颜色、闭胞域内连接、无边界布线及几何平均均一致；本篇不直接提供联合或停止域极限。另核读 Antoine §§16–20、Radó p.182 原页和 Hatcher v3 的相对版本，核对了上面的指定对应、端帽粘合及小位移公式。有限计算采用另一位独立审查者实际执行的 `evidence/independent-replay/cardy.log`，并已将其输入哈希与当前文件核同；496 种染色、错误约定拒绝、角积分和有理区间均通过。

| Claim | Source | Basis | Evidence |
|---|---|---|---|
| 任意有限球面三角剖分的全组件 Fourier Gram 矩阵为对角 \(3/4\) | 原文 §2，Proposition 2.2 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/01-fields.tex`，96–244 行；本报告“全组件标签” |
| 五个显式球面、496 种染色的正交恒等式，且错误约定被拒绝 | 本报告的有限复算 | checked by computation | `evidence/cardy/check_fields.py`；`evidence/cardy/finite_spheres.json`；`evidence/cardy/check-fields.txt`；`evidence/independent-replay/cardy.log` |
| 边界回路简单性、禁止右绕行及共享门回路的两图路径一致 | 原文 §§2、4，Lemmas 2.3–2.5、4.9–4.10 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/01-fields.tex`；`paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/03-plugs.tex` |
| Poisson 固定有限网格族的条件 RSW、臂二阶矩与粗幂界 | 文献 Vanneuville 2025；原文 Proposition 3.1 | conditional on a cited result (Vanneuville 2025, Theorems 1.2–1.4, Proposition 3.14, (3.1), Propositions 3.4(iii), 6.2) | `evidence/shared-arm-literature/aif3710-published.pdf`；本报告依赖段 |
| 固定几何下混色事件可用不交发生乘积界 | 文献 Reimer；可读替代 Borgs–Chayes–Randall 作者版综述 | conditional on a cited result (Borgs–Chayes–Randall, Theorem 2.1, p.3) | `evidence/cardy/citations/borgschayesrandall-reimer-review.pdf`；`evidence/cardy/citations/borgschayesrandall-reimer-p3.png` |
| 混色四臂 \(1+c\) 和近返回 \(2+c\) 从所列粗输入推出 | 原文 §3，Lemmas 3.6–3.7 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/02-probability.tex`，286–495 行；本报告“稠密定位点” |
| 平稳完整闭和的小量可经固定闭合实验密度与共享状态传为余链 | 原文 Proposition 2.6、Proposition 4.11 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/01-fields.tex`；`paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/03-plugs.tex` |
| 仿射传输、\(a_h^V=1\)、两端均值为零的势及偏差 \(O(h(1+k))\) | 原文 §§5，Propositions 5.1、5.5，Lemmas 5.2–5.4 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/04-affine.tex`；本报告“从闭和到端点势” |
| 简单弧／曲线的指定平面延拓足够支持本文拓扑接口 | 文献 Antoine 1921，§§16–20；原文 §§4–6 | conditional on a cited result (Antoine 1921, §§16–20) | `evidence/cardy/citations/antoine-1921.pdf`，pp.21–27 |
| 精确匹配与最后夹逼所需的闭 Jordan 域共形收敛 | 文献 Radó 1923，§1 定理；原文 §§6、9 | conditional on a cited result (Radó 1923, theorem on p.182) | `evidence/cardy/citations/rado-1923.pdf`；`evidence/cardy/citations/rado-1923-p182.png`；本报告“替代拓扑来源”的小位移公式 |
| 端点绕转分类中相对端点邻域的平滑接口成立 | 文献 Hatcher 1312.3518v3，Theorem B 及相对版本 | conditional on a cited result (Hatcher 1312.3518v3, Theorem B and refinement, p.2) | `evidence/cardy/citations/arxiv-1312.3518v3.pdf`；本报告“替代拓扑来源”的端帽粘合 |
| 有限模板集与稠密定位点在指定极限顺序下成立 | 原文 §6，Lemmas 6.2–6.3、Proposition 6.4 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/05-pins.tex`；本报告“稠密定位点” |
| 随机真实弧比较保留选择条件，未对随机匹配概率归一化 | 原文 §7，Lemma 7.1、Proposition 7.4 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/06-actual-arcs.tex`，40–82、254–529 行 |
| 混合原子的有符号细化与端点分部求和闭合内部区域传输 | 原文 Lemma 7.5 及 Theorem 4.1 的完成 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/06-actual-arcs.tex`，531–911 行 |
| 一致可积性、小边界回路控制和正面积差给 \(1-2\operatorname{Re}a>0\) | 原文 Proposition 8.1 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/07-nondegeneracy.tex`；本报告“非退化” |
| 圆盘界 \(\lvert a+r\rvert^2\le r(1+r)\) 由原配对极限及 Mecke 计算推出 | 本报告对原 Proposition 8.1 的定量提取 | checked by hand | `guide/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026.md`，“改进”中的完整计算 |
| 两个角积分及数值上界 0.285121、下界 0.429758 的有理区间换算 | 本报告有限符号/区间计算 | checked by computation | `evidence/cardy/check_constants.py`；`evidence/cardy/check-constants.txt`；`evidence/independent-replay/cardy.log` |
| 闭合星形可观测量的凸性及无布线横穿系数 | 原文 Proposition 9.2 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/08-observable.tex`，55–228 行 |
| 相关几何权在方块上的 \(L^1\) 测度极限给全纯性；三边条件唯一识别共形图 | 原文 Propositions 9.4、Lemma 9.5 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/08-observable.tex`，316–583 行；本报告“可观测量” |
| 任意固定 Jordan 域精确闭胞连通横穿由双缓冲夹逼转移 | 原文 Proposition 9.6 | checked by hand | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/08-observable.tex`，587–770 行 |
| 主定理沿上述已核内部步骤与明确外部概率/拓扑输入成立 | 原文 Theorem 1.1 | conditional on a cited result (Vanneuville 2025; Reimer via Borgs–Chayes–Randall; Antoine 1921; Radó 1923; Hatcher 1312.3518v3) | `guide/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026.md`；上列原文与版本化引用 |
| 固定矩形的条件横穿概率 \(L^2\) 结论是主定理加几何方差的推论 | 原文 Corollary 1.2 | conditional on a cited result (Theorem 1.1 above and Vanneuville 2025, Theorem 1.3) | `paper/Cardys-formula-for-critical-Poisson-Voronoi-percolation-September-23-2026/build/sections/00-introduction.tex`，200–252 行 |
| Cardy 1991 v1 (8) 与本文 beta 积分的归一化一致 | 文献 Cardy (8)；原文 Theorem 1.1、§9 的 beta 积分 | checked by hand | `evidence/cardy/citations/arxiv-hep-th_9111026v1.pdf`，p.7；本报告“与已发表公式的数值对照” |
