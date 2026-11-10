# 从 Cardy 公式到 Voronoi pivotal 正振幅：中文导读与核验

**独立终审结论：接受 Theorem 1.2 在原有标量 Cardy 假设下的手工证明核验，未发现尚未闭合的关键接口或论文错误。** 已核对伴随近临界论文提供的停止域、边界臂估计与归一化引理，以及环域拼接所需的 Schramm–Smirnov 可测恢复定理；这些是已核对的证明依赖，不是主定理新增假设。证明的关键是带符号环域传递的超二维衰减和近秩一收缩，使 Poisson 强度导数的对数余项可求和，而非仅凭四臂指数 \(5/4\) 推出正振幅。下文还给出原谱估计的两层定量加强。

**精确主定理与版本。** 审阅 OpenAI，2026-10-05，指定提交 `4eaee87548250b2682affda7d05d947c05554bae` 中的 *A Pivotal Amplitude for Voronoi Percolation from Cardy's Formula*。本地保留的 11 个源码文件均与该提交的 Git blob 相符。成文 Assumption 1.1 要求**每个固定有界 Jordan 四边形**的临界单次交叉概率趋于 Cardy 值；不含收敛速率，也不直接假设联合交叉或探索过程的极限。成文 **Theorem 1.2** 原文为：

> “Under Assumption 1.1, there exists a constant \(c_V\in(0,\infty)\) such that
> \[
> \lim_{\varepsilon\downarrow0}\varepsilon^{3/4}\mathbb E N_\varepsilon=c_V.
> \]
> Consequently, the inverse expected pivotal count is asymptotic to
> \(c_V^{-1}\varepsilon^{3/4}\).”

模型是全平面强度 \(\varepsilon^{-2}\) 的 Poisson–Voronoi、公平独立黑白染色、闭单位正方形内从左到右的黑色交叉，无边界重采样或接线。\(N_\varepsilon\) 计**翻转胞颜色即可改变交叉事件的核**（color-pivotal nuclei），包括位于方形外但胞与其相交者；期望同时平均几何和颜色。此 \(c_V\) 随所指定的模型、单位、事件和计数规范而定，不是任意四臂事件共享的数值常数。

本文按实际 `\section` 编号引用：`00-introduction` 是 §1，`01-inputs` 是 §2，`02-annuli` 是 §3，`03-spectrum` 是 §4，`04-shape` 是 §5，`05-transfer` 是 §6，`06-amplitude` 是 §7。所有源码在 `paper/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026/build/`；下文文件名均相对此目录。

## 导读

### 问题：幂指数为何还不够

典型内部核成为颜色关键核需要四条交替色臂；四臂指数 \(5/4\) 预测
\[
\mathbb E N_\varepsilon
\approx \varepsilon^{-2}\varepsilon^{5/4}
=\varepsilon^{-3/4}.
\]
但 \(\varepsilon^{-3/4+o(1)}\) 仍允许对数修正和振荡。一个最小提醒是
\[
f(R)=R^{-5/4}\exp(\sin\log\log R),\qquad R>1:
\]
它有正确指数，甚至 \(Rf'(R)/f(R)\to-5/4\)，而 \(R^{5/4}f(R)\) 没有极限。本文真正需要的是该对数导数误差在 \(dR/R\) 下**绝对可积**，不是仅仅趋零。

### 路线图与依赖

| 成文位置 | 本节输出 | 下一步如何用 |
|---|---|---|
| §2，Propositions 2.1–2.3、Lemma 2.4 | 臂事件与局部化估计、可同时作交叉测试的确定性图序列、停止域极限；两个定标极限；\(f(R)=R^{-5/4+o(1)}\) | 提供初步上下界和最终换算，不提供振幅 |
| §3，Lemmas 3.1、3.3–3.5，Proposition 3.6 | 内边界的两种封口状态之差等于四界面穿越指标；环域交叉概率的连续、共形不变极限 | 为 Loewner 方程提供概率状态变量 |
| §4，Proposition 4.1、Lemmas 4.2–4.3、Proposition 4.4 | 模量演化方程、基态、Doob 变换后的平滑与对称谱隙、近秩一及带符号衰减 | 分别负责方向收缩和插入可积性 |
| §5，Lemma 5.1、Proposition 5.2 | 整个环域的参数可分离成两端各自的容量／共形半径与角度 | 首项才能在两端独立的实验中因子分解 |
| §6，Proposition 6.1、Corollaries 6.6–6.7 | 任意带符号连接状态分布的统一传递算子界、公平染色插点的衰减、二阶外积收缩 | 离散模型可迭代，且不要求外侧数据有极限 |
| §7，Lemmas 7.1–7.3、Proposition 7.4 | 强度导数、归一化远尾、两尺寸行列式、可求和误差 | 正振幅及定标换算回主定理 |

首次阅读可先读 §1、§2 的陈述、§7 最后两小节；随后按“环域交叉概率 → 演化方程 → 谱 → 形状比较 → 离散算子”的顺序补读。

### 符号表

| 符号 | 本文含义 |
|---|---|
| \(Q_0=[-1,1]\times[-1/2,1/2]\) | 用于中心插点和定标的辅助矩形，不是最终单位正方形 |
| \(f(R)=S_{1/R}\) | 强度一时在 \(RQ_0\) 中插入原点成为颜色关键核的概率 |
| \(m_\varepsilon=\varepsilon^{-2}\), \(q_\varepsilon=(\mathbb E N_\varepsilon(Q_0))^{-1}\) | 核强度与辅助近临界尺度 |
| \(A(r,s)\), \(\lambda=5/4\) | 方环上的四交替臂概率与目标指数 |
| \(p=\log(R/r)\), \(x,y\) | 圆环模量与外、内四个有标签的变色点（switch）角度 |
| \(T^\pm\) | 两种内边界交替染色规定下的四界面穿越概率；不指定每根墙的编号配对 |
| \(J(w)=\prod_{i<j}\sin((w_j-w_i)/2)\), \(h=J(x)^{1/3}J(y)^{1/3}\) | 有序角度室内的正函数与基态 |
| \(W_\pm\), \(\Pi\) | \(e^{\lambda p}(T^+\pm T^-)/h\) 与一端旋转平均 |
| \(l_i,l_o\) | 内部紧连通集的对数容量与外域在原点的共形半径 |
| \(M_{r,s}\), \(\mathcal B_r\) | 在切割圆周的局部随机数据（seam）之间，传递零总质量的带符号连接状态分布（message）；\(\mathcal B_r\) 是这些分布的 Banach 空间 |
| \(K_R(y)\) | 公平染色插点 \(y\) 对中心**颜色关键概率**的带符号影响；不是几何插点改变事件的概率 |

### 核心机制一：先把所有边界复杂性压到一个连接位

一个圆周若有四段极大的同色边界弧（runs），颜色依次交替，内部无交叉的墙配对只有两种封口状态（cap states）：黑两段相连或白两段相连。固定环域染色，墙既不交叉也不分支。若只传递零或两根墙，外侧配对不记得内封口；若四根全部传递，黑连通位恰好相差一。因此 Lemma 3.1 给出逐配置恒等式
\[
H_{\mathsf b}-H_{\mathsf w}=\mathbf1_{\mathcal T}.
\]
绕数保留在环域墙系中；证明不要求四根墙径向笔直。六个变色点则已有五个无交叉配对，不能原地宣称任意连接状态差都只有一维：§6 先付出六臂事件的概率代价，探索到首次只剩四个墙端的前沿（first four-tip frontier），才作二态降维。

这解释两个独立估计。一般零质量差穿过长环域后几乎同向，故其二阶外积更快衰减；公平染色插点的状态差还在整体反色和旋转下不变（even、isotropic），四界面首项消去，获得严格大于二维的衰减。前者比较不同外尺寸，后者使对整个平面的插点积分可积，不能互相替代。

### 难点一：环域极限、停止后的形状，与演化方程闭合

**环域不是标量 Cardy 的直接适用域。** §3 先在严格包含于环域内部的 Jordan 圆盘小域中识别普通四边形交叉的联合分布，再跨越一条打开环域的光滑割线拼接。决定性来源是 Schramm–Smirnov `1101.5820v2` 的 Theorem 1.19（重印本 pp.19–20）：割线 \(\alpha\) 是有限条有限长路径、只有有限个二重点（自交或交会点）时，交叉事件的 \(\sigma\)-域满足
\[
\mathcal F_D=\mathcal F_{D\setminus\alpha}\quad\text{模零集}.
\]
其 Proposition 4.1（p.28）给出可用于传递联合分布的有限版本：对每个 \(\epsilon>0\)，存在有限个避开 \(\alpha\) 的分段光滑四边形，使它们的交叉指标所决定的一个布尔事件，以极限误差小于 \(\epsilon\) 预测给定跨割线交叉。依次令 \(\epsilon\) 可求和地趋零，便得到可测恢复规则；再用交叉连续性，可将测试选自一族可数稠密的常规四边形。

此处的应用对象是**已经识别的三角格临界圆盘极限**，不是条件于任意 Poisson 几何后的分布。原文 Assumptions 1.1（p.10）要求两色单臂概率趋零，以及
\[
P^4_\eta(z,r,R)\le (r/R)\Delta_4(r,R),\qquad
\Delta_4(r,R)\to0\quad(r\downarrow0,\ R\text{ 固定}).
\]
三角格独立染色及其六边形铺砌满足模型条件，单臂指数 \(5/48>0\)、四臂指数 \(5/4>1\) 满足上述界；局部光滑割线有限长，并可取为简单弧。因为物理域与共形参数域中的整个圆盘分布相同，它们使用同一模零恢复规则；任意有限个跨割线测试的误差可求和，故联合分布也相同。这里只沿光滑割线应用拼接，不沿粗糙岸线套定理。

随后还要从普通交叉恢复接上封口后的连通事件：把黑色目标弧向有利方向稍移并留出正间隙，用实现连接的自由路径周围的细管交叉作测试，最后由边界运动连续性撤去扰动。沿普通岸段的小改动须产生三条**自由臂**，即只用未规定颜色的公平内部顶点的臂；\(O(s^{-1})\) 个小域与指数 \(1+\eta\) 给 \(O(s^\eta)\) 的总误差。有限变色点／岸段接头的例外邻域另用单臂处理，不能把规定颜色的边界段或封口接线算作自由臂。

**粗糙岸线的不同访问不能合并。** 岸（bank）是带有域内访问方向的单条边界弧；不同岸的物理影像可以接触，但仍代表不同素端访问。Definition 3.2 要求环域映射在闭参数环上一致收敛、每条岸分别简单、标记在参数次序中不同。Lemma 3.3 将域分解成未动的环状主体（back）及沿开区间接在其上的有限个 Jordan 侧域（lobes），先得核收敛和非退化模量，再用各非恒定边界子弧的正调和测度排除角参数压缩，得到闭包一致收敛。有限性只涉及这些侧域，不涉及所有被 SLE 吞掉的分支。

**逐点激活的演化方程需要以上几何。** Proposition 4.1 在当前探索的变色点（active switch）附近选很小的横截线，在查询横截线顶点颜色之前停止。伴随论文 Lemmas 3.6–3.7 给出圆盘中的目标残域：未动后部加两侧 Jordan 子域，沿开区间接合。本文另用环状主体加侧域的论证，确认剩余域仍双连通；这些伴随引理本身不是环域定理。其余标记未被吞，未读颜色仍独立。因此剩余成功概率仍为同一个 \(T^\pm(p_{\rm new},x_{\rm new},y_{\rm new})\)，不需另添已探索区域或连接状态变量，这才使有限维方程闭合。

在周期为 \(2\pi\) 的圆柱坐标中，以模量减少量计时，激活 \(x_i\) 给出
\[
0=-\partial_pT+3\partial_{x_ix_i}T+
\sum_{j\ne i}H_p(x_j-x_i)\partial_{x_j}T+
\sum_j\Re H_p(y_j-x_i+ip)\partial_{y_j}T.
\]
这里 \(H_p(u)=\sum_{k\in\mathbb Z}\cot((u-2ikp)/2)\) 使用对称求和。Zhan 的原文 §1.2、Theorem 1.1(i)、Lemmas 2.2–2.3 确认该归一化下驱动过程是方差参数为 \(6\) 的 Brownian 运动，时钟变为 \(F'(U)^2dt\)，正则项为 \(-3F''(U)\)，正好抵消 \(\kappa F''/2\)。不能换成固定某远端点的核函数后仍说驱动过程无漂移。

八个逐点激活方程平均得到 \(L+B_p\cdot\nabla\)，其中
\[
L=\frac18\sum_{w=x,y}\left(3\sum_i\partial_{w_iw_i}+
\sum_i s_i\partial_{w_i}\right),\quad
s_i=\sum_{j\ne i}\cot\frac{w_i-w_j}{2},
\quad \|B_p\|_{C^k}=O(e^{-p}).
\]
同侧核函数误差为 \(O(e^{-2p})\)，跨侧为 \(O(e^{-p})\)。作者先建立均值恒等式，得到黏性意义下的方程，再用平均算子的内部一致抛物型正则性得到光滑性；不是预先对尚未识别的交叉概率求导。

### 难点二：基态与两种对称谱隙

以下是**原文计算的展开**。记 \(C=\sum_{i\ne j}\csc^2((w_i-w_j)/2)\)。三角 cot 恒等式给
\[
\sum_i s_i^2=C-20,\qquad
\partial_i\log J^{1/3}=s_i/6.
\]
对一般 \(J^a\)，单组四角变量的 \(J^{-a}L_wJ^a\) 为
\[
\frac1{32}\big[-3aC+(3a^2+2a)(C-20)\big].
\]
取 \(a=1/3\) 时 \(C\) 的系数消去，每端为 \(-5/8\)，两端即 \(Lh=-5h/4\)。证据脚本用三个角的有理函数恒等式拼成四角恒等式，并拒绝错误常数、错误指数和错误特征值。

Doob 变换后的生成元为
\[
D=h^{-1}(L+\lambda)h
=\frac38\left(\Delta+\nabla\log m\cdot\nabla\right),\qquad
m=J(x)^{4/3}J(y)^{4/3}.
\]
其不变概率测度为 \(\mu\propto m\,dx\,dy\)；这不是原吸收过程 \(L\) 的不变分布或准平稳密度。Lemma 4.2 排除碰撞所用的 Lyapunov 函数满足
\[
D(-\log J^{4/3})=\frac{10}{3}-\frac1{24}C,
\]
故变换后的扩散不会在碰撞边界被吸收。\(h^{-1}\in L^4(\mu)\)，因为 \(h^{-4}m=1\)；这使最初有界的 \(T\) 虽对应无界的 \(W=T/h\)，仍能先经半群平滑，再得到一致的上确界范数与 Lipschitz 界。

对单组四角，减去共同中心角后，相对坐标位于一个有界凸室（alcove）。在该室内，
\[
\nabla^2(-\log J^{4/3})[v,v]\ge\frac43\|v\|^2
\quad(\textstyle\sum_i v_i=0).
\]
KM Theorem 1.2(1) 的欧氏空间、\(N=\infty\) 情形给 Poincaré 常数 \(3/4\)，结合狄利克雷型中的因子 \(3/8\)，得谱隙至少 \(1/2\)。凸内逼近及零密度边界的极限不可省略。

对有序实角提升，写 \(\bar w=\frac14\sum_iw_i\)、\(\theta_w=\bar w\pmod{2\pi}\)、\(r_w=w-\bar w\mathbf1\)，后两者分别表示中心角与相对角。两端同时旋转不变，使中心角的 Fourier 频率只能是 \((n,-n)\)，能量为 \(3n^2/16\)。每端循环换标一次就变号的条件，使相对角均值除非 \(n\equiv2\pmod4\) 否则为零。前一类至少付出两份相对谱隙，共 \(1\)；后一类有 \(\lvert n\rvert\ge2\)，付出 \(3/4\)。所以该变号子空间的谱隙至少 \(3/4\)，一端旋转平均后的谱隙至少 \(1\)。这已足够支撑原证明；更精确的谱隙见“改进”。

### 难点三：怎样统一比较两端的形状

Lemma 5.1 假设内侧紧连通集位于半径 \(a\) 的圆盘内、直径与 \(a\) 同阶，外侧 Jordan 域包含半径 \(b\) 的圆盘且其边界某点距原点 \(O(b)\)。因此 \(l_i\asymp a,l_o\asymp b\)。若 \(p'=\log(l_o/l_i)\)，它证明
\[
\lvert p-p'\rvert\le C a/b,\qquad
\|x-x^0\|+\|y-y^0\|\le C(1+\log(b/a))a/b.
\]
关键不是在任意粗糙物理边界上作反射，而是在各端**自身圆坐标中的环形邻域**上作 Schwarz 反射。由实部的小误差先控制该邻域内的导数，再沿中间的 \(O(1+\log(b/a))\) 个圆盘匹配两端虚部的加法常数。

由于 \(h\) 只有一致的 \(1/3\)-Hölder 界，换参数仍会损失幂。秩一首项遂成为
\[
K\,l_i^\lambda J(y^0)^{1/3}\,
l_o^{-\lambda}J(x^0)^{1/3}.
\]
带符号差的旋转平均界是 \(C(a/b)^{2+\sigma_2}\)，原文任何 \(0<\sigma_2<1/4\) 可用。圆环估计的指数不能由此无损传到任意形状。

### 难点四：任意带符号边界数据的一致量词

在切割圆周上，记录局部 Poisson 几何、颜色及选取圆周的辅助随机性，统称切口数据（seam）。给定这些数据，内部墙的无交叉配对形成有限连接状态集；两种内部随机填充的状态分布之差就是零总质量的带符号分布（message）。允许任意此类分布，而不要求它来自某个典型填充。

Proposition 6.1 的结论是：存在与 \(L,r\) 无关的 \(C,\delta>0\)，每个充分大的固定二进比例 \(L=2^n\) 都有自己的 \(r_0(L)\)，使所有 \(r\ge r_0(L)\) 有
\[
\|M_{r,Lr}\|\le CL^{-\lambda},\quad
M_{r,Lr}=M_1+E,\quad \operatorname{rank}M_1\le1,\quad
\|E\|\le CL^{-\lambda-\delta},
\]
在整体反色和旋转下不变的子空间上，还有 \(\|M\|\le CL^{-2-\delta}\)。范数先取状态分布的全变差，再对所有成功局部化的输出切口数据**及其颜色**取本质上确界，不是只对典型输出求平均。

支撑这个强量词的是 Lemma 6.2。作者将用于取极限的探索放在一个与两端切口均有缓冲间隔的独立中间区域（independent core），两端任意数据只进入逐配置全变差有界的权重。替换中间交叉测试时，误差 \(F\) 因而可先逐配置取绝对值得到
\[
\|\text{error}\|\le C\|v\|\,\mathbb E_{\rm core}F+o(1)\|v\|.
\]
所以在未加符号权重的探索分布下作平均 \(L^1\) 收敛就足够，不须除以某个罕见探索史的概率，也不要求对所有已探索域作统一的条件收敛。

设 \(j,k\) 是从内、外两侧首次只剩四个墙端的尺度。此前仍有至少六条臂，其概率代价为 \(2^{-(2+\tau)(j+k)}\)。只使用两侧探索支撑仍充分分离的尺度对（used pairs）；这些对的首项 \(U_jV_k\) 可分离。将其补成所有 \(j,k\) 的乘积，才得到一个秩一算子；新增的形式尺度对（artificial pairs）由同一六臂尾界控制。固定 \(L\) 后，有限个 \(o_r(1)\) 误差吸收到该比例的目标幂界，再选一个足够大的 \(L\) 迭代。

### 难点五：从强度导数到正振幅

令 \(X_R(\eta)\) 为带色配置 \(\eta\) 在 \(RQ_0\) 内黑色左右交叉的指标，\(0^{\rm b},0^{\rm w}\) 分别表示在原点插入的黑、白核。定义
\[
H_R(\eta)=X_R(\eta\cup\{0^{\rm b}\})
          -X_R(\eta\cup\{0^{\rm w}\}).
\]
这是中心插点的颜色关键指标，故强度一时 \(\mathbb EH_R=f(R)\)。若 \(y^{\rm f}\) 表示在 \(y\) 插入独立公平染色的核，则
\[
K_R(y)=\mathbb E[H_R(\eta\cup\{y^{\rm f}\})-H_R(\eta)].
\]
将 Poisson 强度改为 \(t\)、仍公平染色，记过程为 \(\eta_t\)。欧氏缩放给
\[
G_R(t)=\mathbb EH_R(\eta_t)=f(\sqrt t\,R),\qquad
\frac R2 f'(R)=\int_{\mathbb R^2}K_R(y)\,dy.
\]
Lemma 7.1 先在有界区域 \(D\) 中对 Poisson 级数求导，再用失败概率指数小的局部化事件及强度得分 \(N_t(D)/t-\lvert D\rvert\) 的二阶矩控制导数尾，其中 \(N_t(D)\) 是区域内核的个数；不是直接对无限过程形式求导。

远尾的难处是保留小因子 \(f(R)\)。对 \(s=\lvert y\rvert\ll R\)，以 \(y\) 为中心的插点切口给出 \(s^{-2-\nu}\) 的传递界；再用中心四臂，以及包住两处改动的外围四臂测试，得到
\[
\lvert K_R(y)\rvert
\le Cs^{-2-\nu}A(b_*,s)A(s,R)
\le Cf(R)s^{-2-\nu}.
\]
靠边／角还分别要三条半平面臂和一条从角点邻域向外延伸的臂。设 \(\mathcal C_R\) 是矩形的四个角点，固定一个大常数 \(d_*\) 和一个小常数 \(\rho>0\)，令
\[
d(y)=\min\{\rho R,\max\{d_*,\operatorname{dist}(y,\partial(RQ_0))\}\},
\qquad
u(y)=\min\{\rho R,\max\{d_*,\operatorname{dist}(y,\mathcal C_R)\}\}.
\]
对充分大的 \(R\)，它们分别是到边界、到最近角点的距离，均在下方截到 \(d_*\)、上方截到 \(\rho R\)，故 \(d_*\le d\le u\le\rho R\)。按二进尺度将 \(d,u\) 分层，每一层面积为 \(O(ud)\)，对应权重
\[
d^{-2-\nu}(d/u)^2(u/R)^\beta
\]
总和为 \(O(R^{-\xi_0})\)，任意 \(0<\xi_0<\min(\beta,\nu)\)；这里明确用到 \(\nu<1\)。局部化失败若已接近中心四臂测试的支撑，就不能仍乘该测试的概率：作者单独处理大的失败半径，丢弃中心测试，再用包住全部改动的外围臂事件、指数小的失败概率及多项式下界吸收误差。由此得到 Lemma 7.2 的归一化尾界，而非只有对固定 \(R\) 的可积性。

对 \(\lvert y\rvert\le m\)，两种外部尺寸使用完全相同的内部状态差 \(a,b_y\)。秩一首项的二阶外积为零，所以 Corollary 6.7 控制行列式
\[
\lvert K_R(y)f(R')-K_{R'}(y)f(R)\rvert
\le C(m/R)^{2\lambda+\nu'}+Ce^{-cm^2}.
\]
该估计不要求 \(y\) 与原点分离，解决了近处插点的潜在短距离奇异。取
\[
m=R^\zeta,\quad
\zeta=\frac{\nu'}{4(2+2\lambda+\nu')},\quad \eta=\nu'/8
\]
并用初步 \(f(R)\ge R^{-\lambda-\eta}\)，归一化再积分的幂恰为 \(-\nu'/2\)。加上远尾界，得 \(g(R)=Rf'(R)/f(R)\) 在每个 \([R,2R]\) 上振荡 \(O(R^{-\alpha})\)。沿二进尺度的误差可求和，故 \(g\) 收敛；原四臂指数只在此处把极限辨认为 \(-5/4\)。故
\[
\left|g(R)+\frac54\right|\le CR^{-\alpha},\qquad
\log(R^{5/4}f(R))=\log a+O(R^{-\alpha}),
\quad a\in(0,\infty).
\]
正性来自**对数的有限实极限**，不需要先证明谱常数 \(K>0\)。最后仅用
\[
m_\varepsilon q_\varepsilon S_\varepsilon\to c>0,\quad
q_\varepsilon\mathbb EN_\varepsilon\to B>0,\quad
S_\varepsilon\sim a\varepsilon^{5/4}
\]
得到 \(q_\varepsilon\sim(c/a)\varepsilon^{3/4}\) 与 \(c_V=Ba/c\)。定标引理仅给定性极限，所以局部概率 \(f\) 的幂次余项不自动成为 \(\mathbb EN_\varepsilon\) 的相同收敛速率。

### 外部输入、出处与公开数值基线

**伴随近临界论文。** §2.3 引用的确为成文 Lemma 7.1 “Common calibration” 与 Lemma 7.2 “The prescribed normalization”：前者令 \(c_e=m_eq_eS_e\to c\in(0,\infty)\)，后者令 \(q_e\mathbb EN_e(Q_*)\to B\in(0,\infty)\)。Poisson 单时刻、符号权重 \(\delta_1-\delta_0\) 正是这里的特例；\(S_e\) 不是公平染色插点造成的几何差。两引理通过方块替换、插点位置的一致可积性及交叉导数等于一来定标，不使用本篇正振幅，因而**没有两文主定理循环**。

其余接口也已对照原文的证明与适用条件：Proposition 4.5 给固定尺度的联合交叉测试；Lemmas 3.6–3.7 给查询横截线顶点之前停止的目标域及有限次迭代，两岸分别简单、可互触但保留不同素端访问；Lemma 2.11 给指数 \(4/3\) 的自由边界三臂界。后者要求闭包映射一致收敛、无常值边界弧，且所用岸区间的物理投影单射，只计公平独立内部顶点。本文借圆盘小域使用该界，并自行证明环域的主体加侧域结构。共同臂事件文献、图序列的量词及这些证明的详细导读见 `guide/From-critical-crossings-to-quenched-near-critical-universality-in-Voronoi-percolation-October-5-2026.md`，§§3–5。

**Schramm–Smirnov 拼接。** 已保存并核读 `1101.5820v2`（2011-12-28，Annals 39 (2011), 1768–1814 的重印版；以下用重印本页码）。Theorem 1.19（pp.19–20）、Proposition 4.1（p.28）给“避开有限长割线的交叉决定跨割线交叉”的模零可测恢复及有限测试近似；Assumptions 1.1（p.10）列单臂衰减与严格强于一次幂的四臂界，§5 的 Lemma 5.1、Corollary 5.2（pp.36–37）处理交叉事件的连续性和有限布尔组合的极限。本篇 Lemma 3.5 仅在已识别的三角格 Jordan 圆盘分布中使用这些结论；具体假设与联合恢复的论证见“难点一”。

**环域 SLE。** 已取得 Zhan 的 `math/0310350v3`（2004-09-05）；§1.2、Theorem 1.1(i)、Lemmas 2.2–2.3 是实际检查的位置。它给环域／径向 SLE\(_6\) 的局部性与时钟变换；本文 §3、Proposition 4.1 将它用于四界面穿越概率。

**Calogero–Sutherland。** 已取得 Cardy 的 `hep-th/0310291v2`（2004-01-31，页面标注为勘误后的发表版本），核对了公式 (7)–(8)、(12)–(13) 与其后的解释。这是谱结构的前驱来源。一般 \(\kappa\) 的共形协变因子不能遗漏；在 \(\kappa=6\)，\(h_{2,1}=(6-\kappa)/(2\kappa)=0\)，与这里没有额外边界权重势项相容。

**Brascamp–Lieb。** 原 1976 论文全文未在本次取得，故不声称核对其原编号。已检查直接可用的替代来源 Kolesnikov–Milman，`1310.2526v7`（2017-11-23，拆分后的 JGA 论文），Theorem 1.2(1) 的欧氏空间、\(N=\infty\) 情形；凸角度室、严格正定的 Hessian 及内部穷竭逼近均符合应用条件。

**公开精确臂概率渐近基线。** Du–Gao–Li–Zhuang，`2205.15901v1`（2022-05-31，后来发表于 CMP 405 (2024), Article 182），Theorem 1.3 给出三角格交替 \(j=2,3,4,5\) 臂事件的
\[
a_j(1,n)=C_a(j)n^{-(j^2-1)/12}(1+o(1)),\quad C_a(j)>0.
\]
四臂为 \(5/4\)，六条混合色臂的指数基线为 \(35/12>2\)，半平面三臂为 \(2\)。同文 Theorem 1.2 对带指定落点／连接关系的 \(X_j,Y_j\) 才给幂次误差；不要把它直接说成 Theorem 1.3 的误差。本文的 Voronoi 颜色关键数振幅没有给出可对照的十进制数值，且不与 \(C_a(4)\) 使用相同观测量或单位；可比较的是指数、正振幅是否存在及误差强度，不是宣称两常数相等。

本族没有官方 Lean。本次精确符号计算只核对局部代数；其余结论的依据是下列手工推导与已核对的文献，不是全篇形式证明。

## 改进

**移除圆环旋转平均界中多余的 \(1+p\)，无需新的谱隙。** 原文 Proposition 4.4 是
\[
\|\Pi W_-(p)\|_\infty\le C(1+p)e^{-p}.
\]
但该命题最后已给变号解的 Lipschitz 估计
\(\|W_-(p)\|_\infty+\operatorname{Lip}W_-(p)\le Ce^{-3p/4}\)。
因此同一变换方程的非齐次项实际满足
\[
\|B_p\cdot\nabla W_-(p)+V_pW_-(p)\|_\infty
\le Ce^{-7p/4}.
\]
用旋转投影后的谱隙至少 \(1\)，以及单位时间的 \(L^2\to L^\infty\) 平滑，对半群演化时间至少一的部分，Duhamel 卷积给
\[
e^{-p}\int_{p_1}^{p-1}e^{-3s/4}\,ds=O(e^{-p});
\]
最后不足一单位时间的项直接用上确界范数收缩，亦为 \(O(e^{-7p/4})\)。所以可加强为
\[
\boxed{\|\Pi W_-(p)\|_\infty\le Ce^{-p}.}
\]
这里不需要 \(B_p\) 与独立旋转交换，只对非齐次项作 \(\Pi\) 即可。这是无需新谱来源的第一层加强。

**标准完整谱可再加强，但整个变号子空间的谱隙 \(3/4\) 不能提升。** 独立谱探索给出的计算已重跑，所用 Rösler–Voit `2108.03228v2` 的 §2、印刷 pp.3–4、(2.4)–(2.7) 后的完整谱段亦已核读。该文发表于 *Contemporary Mathematics* 780 (2022), 243–262，DOI `10.1090/conm/780/15692`；这里核对的是指定预印本全文，不是书版全文。

取 \(H=\{\sum r_i=0\}\)、根格 \(Q=\mathbb Z^4\cap H\)、权格
\(P=\{u\in H:u_i-u_j\in\mathbb Z\}\)。本文的相对角度室是
\(W_{\rm aff}=S_4\ltimes2\pi Q\) 的基本域；每个 \(L^2\) 函数可反射延为
\(H/(2\pi Q)\) 上的 Weyl 不变函数。因此 Fourier 格是完整的 \(P\)，不是只取 \(Q\)，也不能额外将循环换标视作同一个状态。根系的重数参数 \(k=2/3\) 使密度指数 \(2k=4/3\)，且 \(D_r=(3/8)\widehat L_k\)。文献的正交完备三角多项式基给出全部能量
\[
E(a,b,c)=\frac38\left[
\frac34(a^2+c^2)+b^2+ab+bc+\frac12ac+2(a+c)+\frac83b\right],
\quad a,b,c\in\mathbb Z_{\ge0},
\]
对应 \(\ell=a\omega_1+b\omega_2+c\omega_3\)。

**域匹配。** 文献在边界采用自然反射／入口实现，不可改成 Dirichlet 吸收。此处密度以到室壁距离的 \(4/3\) 次幂消失，宽 \(\epsilon\) 的截断函数能量为 \(O(\epsilon^{1/3})\to0\)，所以常数与有界光滑的 Weyl 特征函数均在本文的型域中。原文的不碰撞论证，或局部 Bessel 维数 \(1+2k=7/3>2\)，又使从内点出发的扩散不触及边界，与文献的自然实现一致。

**全局最小化，而非有限搜索。** \(E\) 的各交叉系数均非负，随每个 Dynkin 标号单调。非零最低由 \(\omega_1,\omega_3\) 达到，为 \(33/32\)，改进原文的下界 \(1/2\)。相对坐标上的循环换标映射
\[
(r_1,r_2,r_3,r_4)\mapsto
(r_2-\pi/2,r_3-\pi/2,r_4-\pi/2,r_1+3\pi/2)
\]
在该基上的字符为 \(e^{-i\pi d/2}\)，\(d=a+2b+3c\)。原因是轨道和有此字符，而基函数的三角展开只加入相差根格的权，故字符不变。循环换标时变号恰为 \(d\equiv2\pmod4\)：若 \(b\ge1\)，\(E\ge E(0,1,0)=11/8\)；若 \(b=0\)，则 \(a+c\ge2\)，最小也至少 \(9/4\)。故这一相对角子空间的锐谱隙是 \(11/8\)，由实函数 \(e_2(e^{ir_1},\ldots,e^{ir_4})\) 达到，其中 \(e_2\) 是二阶初等对称多项式。双端中心频率均为零的子空间遂有锐谱隙 **\(11/4\)**，改进原文下界 \(1\)。

然而在完整的同时旋转不变、每端循环换标变号的子空间中，
\(\cos(2(\theta_x-\theta_y))\) 能量恰为 \(3/4\)。这是抽象 \(D\) 的真实极值，否决“把整个子空间的谱隙提高”的路线，但不证明实际 \(W_-\) 含有非零的这个模态。

结合非齐次项的界 \(O(e^{-7p/4})\)，把新的旋转投影谱隙 \(11/4\) 代入同一个 Duhamel 论证：
\[
\int_{p_1}^p e^{-(11/4)(p-s)}e^{-7s/4}\,ds=O(e^{-7p/4}).
\]
因此第二层加强是
\[
\boxed{\|\Pi W_-(p)\|_\infty\le Ce^{-7p/4},\qquad
\left|\operatorname{avg}_{\phi}(T^+-T^-)(p,x,y+\phi\mathbf1)\right|
\le Ce^{-3p}.}
\]
精确算子对 \(e_1,\ldots,e_4\) 的作用及次数 \(0,\ldots,4\) 对称多项式矩阵谱由脚本独立核算；完备性与全局下界依赖上述文献和手算，不由这些有限矩阵证明。

**形状比较与离散收益的边界。** 第一层删去 \(1+p\) 后，§5 可取旧的端点 \(\sigma_2=1/4\)，因为形状误差是 \(o(\rho^{9/4})\)。第二层的圆环误差虽降为 \(O(\rho^3)\)，原形状误差仍含
\[
O\!\left(\rho^{5/2}+(1+\log(1/\rho))^{1/3}\rho^{7/3}
+(1+\log(1/\rho))\rho^3\right),\quad \rho=a/b.
\]
故只可进一步保证任意 \(0<\sigma_2<1/3\)，不能由此宣称粗糙物理端均为 \(O(\rho^3)\) 或取得端点 \(1/3\)。§6 的求和还要求 \(\sigma_2<\tau\)，最终统一 \(\delta\) 另受近秩一误差及未使用尺度对的尾界限制。这两层都是已知谱在本归一化的具体化及原证明的定量简化，不声称新研究成果。

## 错误与不足

未发现论文错误或尚待补足的关键证明步骤。已检查全部七节，包括环域拼接、停止后的两岸与侧域、任意带符号边界数据的一致算子界，以及失败局部化事件的处理。Schramm–Smirnov 的可测恢复结论及应用条件与 Lemma 3.5 相符。原文旋转平均估计的 \(1+p\) 损失可去除，但它是非最优估计，不是错误，改进见上节。

## 已核验

从两种封口状态的恒等式，经环域交叉与演化方程的识别、离散传递／外积／插点估计，到归一化强度导数与 \(c_V=Ba/c>0\) 的证明链，手工复核支持其在标量 Cardy 假设下闭合。特别核验了：先选固定大比例 \(L\)、后选尺度阈值 \(r_0(L)\)；独立中间区域外任意符号权重的逐配置全变差支配；大尺度局部化失败时不可误乘中心臂概率；近插点不需与原点分离；以及对数导数实际有可求和的幂次余项。伴随论文的停止域与定标引理、Schramm–Smirnov 的拼接定理均是已核对的引用依赖。

复跑命令：

```sh
python3 evidence/pivotal-amplitude/check_algebra.py \
  --source-tree evidence/pivotal-amplitude/upstream-paper-tree.json
math-claims --check \
  guide/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026.md
python3 evidence/pivotal-spectrum/check_spectrum.py
```

`check_algebra.py` 拒绝错误的 cot 常数、基态幂及特征值。源码来源沿 commit → `preprints` tree → paper tree → 各 blob 核验；大仓库的递归根树被截断，未将其当完整清单。公开引文原文 PDF 与文本保存在 `evidence/pivotal-amplitude/sources/`。下表的手工核验依据是本导读的推导及所列原文；“conditional on a cited result” 标记所用外部定理，不表示该引用仍未核对。

**独立终审范围（2026-11-10）。** 合稿终审在逐篇独立审查之外，直接将本篇 §2 的输入逐项对照伴随论文 Lemmas 2.11、3.6–3.7、7.1–7.2：圆盘停止域不能直接换成环域，必须再用本篇 Lemma 3.3 的有限侧域、开接合区间和持久后部；正规岸的自由三臂不能换成规定色连接；\(c,B\) 的校准也没有用到待证振幅。另直接核对 Lemma 6.2 的逐配置全变差支配，所以未加权平均误差确能控制任意符号输入及输出数据本质上确界，而非假设罕见探索史下的一致条件极限。代数、11 个源码 blob 及谱见证采用另一位独立审查者实际执行的 `evidence/independent-replay/pivotal.log`，输入哈希已与当前文件核同。完整谱加强沿用已经独立手核的权格完备性、域匹配与全局极小化，不以低阶枚举替代。家族依赖仍为 Cardy → 近临界接口 → 本篇；单篇的标量 Cardy 条件保留，外部文献的整篇证明未在此重证。

| Claim | Source | Basis | Evidence |
|---|---|---|---|
| 11 个保留源码与指定提交相符 | 指定上游提交及本地 paper | checked by computation | `evidence/pivotal-amplitude/check_algebra.py`; `evidence/pivotal-amplitude/check_algebra.txt`; `evidence/pivotal-amplitude/upstream-paper-tree.json`; `evidence/independent-replay/pivotal.log` |
| 两种封口状态之差逐配置等于四界面穿越指标，包括有绕数的情形 | paper, Lemma 3.1 | checked by hand | `paper/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026/build/sections/02-annuli.tex`; 本导读“核心机制一” |
| 环域／停止目标域识别所需的联合测试、自由臂与两岸 | paper, Propositions 2.2, 3.6, 4.1 | conditional on a cited result (reviewed companion Propositions 3.1, 4.5, Lemmas 3.4–3.7, 2.11; Schramm–Smirnov Theorem 1.19 and Proposition 4.1) | 本导读“难点一”与“外部输入”；`evidence/pivotal-amplitude/sources/schramm-smirnov/arxiv-1101.5820v2.pdf` |
| 避开光滑割线的可数交叉测试模零决定跨割线交叉；本处三角格圆盘分布满足假设 | literature, Schramm–Smirnov 1101.5820v2, Assumptions 1.1, Theorem 1.19, Proposition 4.1 and §5 | checked by hand | `evidence/pivotal-amplitude/sources/schramm-smirnov/arxiv-1101.5820v2.pdf`; `evidence/pivotal-amplitude/sources/schramm-smirnov/arxiv-1101.5820v2.txt`; 本导读“难点一” |
| 对称环域核函数的无漂移局部性时钟及 -3F'' 抵消 | literature, Zhan math/0310350v3, Theorem 1.1(i), Lemmas 2.2–2.3 | checked by hand | `evidence/pivotal-amplitude/sources/zhan/math-0310350v3.pdf`; `evidence/pivotal-amplitude/sources/zhan/math-0310350v3.txt` |
| \(Lh=-5h/4\)、Doob 漂移系数 1/4、Lyapunov 公式和行列式指数 | paper, §4 and Proposition 7.4 | checked by computation | `evidence/pivotal-amplitude/check_algebra.py`; `evidence/pivotal-amplitude/check_algebra.txt`; `evidence/independent-replay/pivotal.log` |
| 相对角凸室的谱隙至少 1/2，变号／旋转投影子空间谱隙至少 3/4／1 | paper, Lemma 4.3 | conditional on a cited result (KM 1310.2526v7, Theorem 1.2(1), N=infinity) | `evidence/pivotal-amplitude/sources/km/arxiv-1310.2526v7.pdf`; 本导读“难点二” |
| \(\|\Pi W_-\|_\infty\le Ce^{-p}\) 可由原文变号解的 Lipschitz 界加强得到 | ours, consequence of Proposition 4.4 | checked by hand | 本导读“改进”；`paper/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026/build/sections/03-spectrum.tex` |
| \(e_k\) 算子恒等式、低阶对称矩阵谱、中心极值模态与坏见证拒绝 | ours, independent spectrum exploration | checked by computation | `evidence/pivotal-spectrum/check_spectrum.py`; `evidence/pivotal-spectrum/witness.json`; `evidence/pivotal-amplitude/spectrum-independent-replay.txt`; `evidence/independent-replay/pivotal.log` |
| 相对角谱隙锐值 33/32，双端零中心循环变号谱隙锐值 11/4；完整变号谱隙 3/4 锐 | ours, specialization of standard Heckman–Opdam spectrum | conditional on a cited result (Rösler–Voit 2108.03228v2, §2 complete compact spectrum) | `evidence/pivotal-spectrum/sources/arxiv-2108.03228v2.pdf`; 本导读“改进”的域匹配与全局极小化 |
| 新投影谱隙与原变号解正则性给 \(\Pi W_-=O(e^{-7p/4})\)，形状误差的幂次增益可取任意小于 1/3 | ours, consequence of the spectral specialization and paper regularity | conditional on a cited result (Rösler–Voit complete spectrum and paper Propositions 4.1, 4.4) | `evidence/pivotal-spectrum/check_spectrum.py`; 本导读“改进” |
| 任意形状的两端映射误差及秩一／带符号传递的幂次损失 | paper, Lemma 5.1 and Proposition 5.2 | checked by hand | `paper/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026/build/sections/04-shape.tex`; 本导读“难点三” |
| 独立中间区域的平均 L1 误差可提升至任意符号输入、输出切口数据本质上确界的算子界 | paper, Lemma 6.2 and Proposition 6.1 | conditional on a cited result (annular transmission identification and companion free-arm inputs) | `paper/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026/build/sections/05-transfer.tex`; 本导读“难点四” |
| 全平面强度导数及系数 R/2 | paper, Lemma 7.1 | checked by hand | `paper/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026/build/sections/06-amplitude.tex`; 本导读“难点五” |
| 归一化远处插点尾界与近处插点行列式界 | paper, Lemmas 7.2–7.3 | conditional on a cited result (Corollaries 6.6–6.7 and critical arm inputs) | `paper/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026/build/sections/06-amplitude.tex`; 本导读“难点五” |
| 两个定标引理的编号、Poisson 单时刻特例与非循环依赖方向 | paper, Proposition 2.3; companion Lemmas 7.1–7.2 | checked by hand | `paper/From-critical-crossings-to-quenched-near-critical-universality-in-Voronoi-percolation-October-5-2026/build/sections/07-identification.tex`; 本导读“外部输入” |
| 可求和的对数导数余项推出正有限 a，再由 c,B 推出 cV=Ba/c | paper, Proposition 7.4 and Theorem 1.2 | conditional on a cited result (block estimates, arm inputs and companion calibration) | `paper/A-Pivotal-Amplitude-for-Voronoi-Percolation-from-Cardys-Formula-October-5-2026/build/sections/06-amplitude.tex`; 本导读“难点五” |
| 三角格交替四臂正振幅是已有结果，不能当作此处 Voronoi 数值常数 | literature, DGLZ 2205.15901v1, Theorem 1.3 | checked by hand | `evidence/pivotal-amplitude/sources/dglz/arxiv-2205.15901v1.pdf`; 本导读“公开精确臂概率渐近基线” |
