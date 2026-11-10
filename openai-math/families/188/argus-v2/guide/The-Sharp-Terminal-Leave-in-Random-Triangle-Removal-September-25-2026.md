# 随机三角形删除的尖锐终端余边：导读与核验

正文主定理手查通过：终端余边的归一化 \(F_n/n^{3/2}\) 在 \(L^2\) 中趋于 \(1/(2\sqrt2)\)，外部输入为已核对的 Joos–Kühn 前缀定理。

## 1. 主定理究竟断言什么

固定上游 `openai/math` 提交 `4eaee87548250b2682affda7d05d947c05554bae`。本文审读 OpenAI 于 2026 年 9 月 25 日的 *The sharp terminal leave in random triangle removal*；正文入口为 `paper/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026/build/paper.tex`。以下章节号按该入口的引入次序，而非各文件独立编号。

**原文主定理 1.1**（`paper/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026/build/introduction.tex`，标签 `thm:main`）：

> For the uniform triangle-removal process starting from \(K_n\),
> \[
> \mathbb E\left[\left(\frac{F_n}{n^{3/2}}-
>                    \frac1{2\sqrt2}\right)^2\right]\longrightarrow0.
> \]
> In particular,
> \[
> \frac{F_n}{n^{3/2}}\xrightarrow{\mathbb P}\frac1{2\sqrt2},
> \qquad
> \frac{\mathbb E F_n}{n^{3/2}}\longrightarrow\frac1{2\sqrt2}.
> \]

这里对每个整数 \(n\)，从简单完全图 \(K_n\) 开始，每步在**当前仍完整存在的三角形中均匀选一个**，删除它的三条边，直到图中没有三角形；\(F_n\) 是停止时的剩余边数，期望对整个随机过程取。极限为 \(n\to\infty\)，没有同余类限制。\(L^2\) 收敛的含义就是显示的平方误差期望趋零，不要求把不同 \(n\) 的过程实现于同一概率空间。

这个问题问的是随机贪心三角形打包究竟漏掉多少顶点对。此前的指数 \(n^{3/2+o(1)}\) 不能确定首项系数；本文要确定 \(1/(2\sqrt2)\approx0.35355339\)，而且控制二阶矩。该常数只针对从 \(K_n\) 开始的过程，不是任意初始图的普适结论。

## 2. 阅读路线与符号

### 2.1 七节组成的证明骨架

| 正文章节 | 文件 | 在主线中的职责 |
|---|---|---|
| §1 引言 | `introduction.tex` | 精确定理、已有结果与整条续程路线。 |
| §2 一致的早期前缀 | `prefix.tex` | 引用 Joos–Kühn 的停止估计，得到度、共邻点、link 圈计数及两种小模板上界。 |
| §3 精确查询与独立展开 | `queries.tex` | 把实际存活改写成递归布尔测试；给每个出现位置独立随机数，获得精确乘积方程。 |
| §4 展开概率的稳定性 | `stability.tex` | 用 link 的偶次 trace 控制边空间线性化，证明 \(q_e,q_{e,T}\) 相对于标量律的一致 \(1+o(1)\) 估计。 |
| §5 实际测试与独立测试的耦合 | `coupling.tex` | 只在三角形类型重复曝光时可能分歧；把重复归约到至多两条祖先调用路径上的额外边。 |
| §6 碰撞见证的计数与访问 | `witnesses.tex` | 模板稀有性乘上有序访问概率，得到绝对误差 \(O(D^{-35}+n^{-1})=o(D^{-1})\)。 |
| §7 终端矩与尖锐常数 | `moments.tex` | 随机根读取普通一、二阶矩；去掉前缀条件，得到 \(L^2\) 极限。 |

初读建议按 §1 → §7 → §3 → §4 → §§5–6 的次序，把 §2 暂视为精确输入。想确认整条证明是否闭合，则必须回到 §2 的外部结果适用范围。§4 解决“各类型会不会随时间漂开”，§6 解决“独立展开与真实过程能不能在二阶矩所需尺度上相近”，两者缺一不可。

### 2.2 符号表

| 符号 | 含义与尺度 |
|---|---|
| \(\epsilon=1/2000\) | 固定常数；先固定它，再令 \(n\to\infty\)。 |
| \(i_0\) | \(\left\lfloor n^2(1-1/n-n^{-1/2+\epsilon})/6\right\rfloor\)，确定的前缀长度。 |
| \(p\) | \(1-1/n-6i_0/n^2=n^{-1/2+\epsilon}+O(n^{-2})\)，前缀边密度。 |
| \(G,\mathcal G_n\) | 前缀图 \(G_{i_0}\) 与“到达该步且满足 §2 所有条件”的事件；后者只由前缀决定。 |
| \(\mathcal E,\mathcal T,m\) | 前缀图的边集、三角形类型集及边数 \(m=n^2p/2\)。 |
| \(D=np^2\) | 每条边的三角形数的比较值，\(D\sim n^{1/1000}\to\infty\)。 |
| \(t,q(t)\) | 续程三角形优先级的阈值 \(0\le t\le1\)；\(q(t)=(1+2Dt)^{-1/2}\)。 |
| \(q_e,q_{e,T}\) | 独立展开中单边根存活概率；后者只从根候选表中略去 \(T\)，不从所有后代中删除 \(T\)。 |
| \(I_{e,T}(t)\) | 候选 \(T=\{e,f,g\}\) 在阈值前出现且其子查询成功的概率，即 \(\int_0^t q_{f,T}(v)q_{g,T}(v)\,dv\)。 |
| \(s,S,z_e\) | \(s=\frac12\log(1+2Dt)\)，终点 \(S=\frac12\log(1+2D)\)；\(z_e=\log(q_e/q)\)。 |
| \(A,P,R\) | 边空间三角形邻接矩阵、星平均之和、误差 \(R=A/D-P\)。 |
| \(\Gamma,J,J^+\) | 已访问调用的形式图；至多两条祖先路径的形式图；再加标记端点间额外边的图。 |
| \(\Delta_n\) | 实际与独立根回答事件的绝对概率误差 \(O(D^{-35}+n^{-1})\)。 |

所有未注明常数均不得依赖于所选好前缀图。模板的根集在**模板中**独立，不要求其指定像在 \(G\) 中互不相邻；嵌入是保边的单射，不要求保非边。圈计数是固定标号圈的嵌入数，不除以自同构数。

## 3. 两个核心思想和一个小例子

### 3.1 为什么常数会是 \(1/(2\sqrt2)\)

每条前缀边约有 \(D\) 个能删除它的三角形。若其他两条边近似独立地以概率 \(q(t)\) 存活，则单边的删除率约为 \(Dq(t)^3\)。于是比较方程为
\[
q'=-Dq^3,\quad q(0)=1,\qquad q(t)=(1+2Dt)^{-1/2}.
\]
终端边数应接近
\[
mq(1)=\frac{n^2p}{2\sqrt{1+2np^2}}
      \sim\frac{n^{3/2}}{2\sqrt2}.
\]
这只解释常数，不构成证明：需要证明误差对所有边类型及整段 \(0\le t\le1\) 一致，并且真实两根联合概率的误差比 \(D^{-1}\) 更小。

### 3.2 为什么先独立展开，再检查重复类型

给前缀图的每个三角形赋独立均匀优先级，按序扫描且仅接受三边仍在的三角形，就得到相同的续程定律：已拒绝的三角形永远不能恢复；给定已扫描部分，剩余排列仍均匀，下一次接受的便是当前完整三角形中均匀的一个。

在这个真实过程的优先级表示中，每个三角形**类型**只有一个数。同一类型在不同递归位置出现时，必须重复使用这个数，不能独立化。论文先给每个出现位置不同的独立数；乘积方程在这个辅助模型中才是精确的。随后通过耦合收回真实过程，代价是重复类型被曝光的概率。

候选表须先全部曝光，再按优先级联合扫描；“曝光”不等于“访问子查询”。即使某候选在阈值以上，或已经因更早成功而不再访问，它也计入重复类型事件。只统计已遍历的三角形会低估耦合失败。

### 3.3 四顶点的最小非平凡演示

取两三角形 \(abc,abd\) 共享边 \(ab\) 的菱形图。若 \(U_{abc}<U_{abd}\)，则接受 \(abc\)，终端恰剩 \(ad,bd\)。查询 \(ad\) 时，它的候选 \(abd\) 要先问 \(ab,bd\) 在 \(U_{abd}\) 前是否都还在；在这个对子查询中，较早的 \(abc\) 成功，所以对子回答假，\(abd\) 不能删除 \(ad\)，根回答真。递归测试本身不删除任何边，它只重建优先级扫描的逻辑。

切勿把辅助模型的乘积分解当成有限图的事实。在 \(K_4\) 中四个三角形等概率成为第一个且唯一接受的三角形，终端总有三条边。对不相交边 \(ab,cd\)，各自终端存活概率均为 \(1/2\)，但联合存活概率为零：每个三角形都包含这两边中的一条。独立性是需要量化误差的近似，不是均匀选择规则直接带来的性质。

## 4. 稳定性：从 link 圈到全时段相对误差

本节按正文 §4 的 trace 分类、\(P=UV\) 与有限扰动展开，解释各估计如何衔接。

### 4.1 精确方程中三个分母不能漏

设 \(T=\{e,f,g\}\)。从 §3 的有限乘积及 \(C^1\) 正则性，
\[
q_e=\prod_{T\ni e}(1-I_{e,T}),\qquad
q_{f,T}=\frac{q_f}{1-I_{f,T}},\qquad
\frac{dt}{ds}=\frac1{Dq(t)^2}.
\]
故只要因子为正，
\[
z'_e
=1-\frac1D\sum_{T=\{e,f,g\}}
  \frac{\exp(z_f+z_g)}
  {(1-I_{e,T})(1-I_{f,T})(1-I_{g,T})}.
\]
其中 \(e\) 的分母来自对根乘积取对数导数，另两个来自略去父三角形的概率；三者来源不同。

固定 \(0<a<\min(c,2\epsilon)\)，令 \(\delta_n=n^{-a}\)。暂假设 \(\|z\|_\infty\le\delta_n\) 且所有 \(I\le1/2\)，则
\[
q_{e,T}\le2e^{\delta_n}q,\qquad
I_{e,T}(t)\le
4e^{2\delta_n}\int_0^t\frac{dv}{1+2Dv}
=\frac{2e^{2\delta_n}}D\log(1+2Dt).
\]
展开分母与指数，用每行 \(2d_e\) 个线性项且 \(d_e/D=1+O(n^{-c})\)，得
\[
z'+(A/D)z=h,\qquad
\|h\|_\infty\le C\bigl(n^{-2a}+n^{-c}+\log n/D\bigr). \tag{4.1}
\]
若直接估计矩阵指数为 \(e^{s\|A/D\|_\infty}\)，在终点损失约 \(D\)，未必压得住指数很小的前缀误差 \(n^{-c}\)。所以接下来必须利用矩阵结构。

### 4.2 固定偶次 trace 为什么足够

对每个顶点 \(u\)，令 \(M_u\) 是 link \(G[N_G(u)]\) 的邻接矩阵，矩阵阶数 \(N_u\sim np\)，最大度至多 \(2D\)。取固定偶数 \(r=8000\)。闭走步有三类：

* 所有位置互异：正是固定标号 \(C_r\) 的嵌入，数为 \((1+O(n^{-c}))D^r\)。
* 非单射而支撑为树：每条树边至少走两次，支撑边数至多 \(r/2\)；选首点后逐边延伸，至多 \(O(np)(2D)^{r/2}\)。
* 非单射而支撑含圈：若支撑有 \(j<r\) 个顶点，先用 link 圈计数选一个长度 \(b\) 的圈，再沿附着森林选其余点，至多 \(O(D^b)(2D)^{j-b}=O(D^{r-1})\)。

模式总数只依赖固定的 \(r\)。于是
\[
\operatorname{tr}(M_u/D)^r
=1+O(n^{-c}+D^{-1}+npD^{-4000})
=1+O(n^{-c_*}),
\quad c_*=\min(c,1/1000).
\]
数值尺度为 \(npD^{-4000}\sim n^{-6999/2000}\)，确实衰减。

令 \(B_u=M_u/D\)。行和与全一向量的 Rayleigh 商把最大特征值夹在 \(1\pm n^{-c}\) 内。因 \(r\) 偶，余下每个特征值的 \(r\) 次幂均非负，故绝对值为 \(O(n^{-\gamma})\)，\(\gamma=c_*/r>0\)。这里不能用奇次 trace 代替，负特征值会抵消。

归一化全一向量 \(\mathbf j\) 满足 \(\|(B_u-\mathrm{Id})\mathbf j\|_2\le n^{-c}\)。除首特征向量外，\(B_u-\mathrm{Id}\) 的谱距零至少 \(1/2\)，故 \(\mathbf j\) 在其余方向的投影范数至多 \(2n^{-c}\)。这给出
\[
\left\|M_u/D-\mathbf1\mathbf1^{\mathsf T}/N_u\right\|_2
=O(n^{-\gamma}). \tag{4.2}
\]
不是只知道非首特征值小就自动得到正确的秩一平均；行和还用来识别首特征方向。

### 4.3 为什么所有星相加不损失 \(n\)

把星上的平均延拓到整个边空间，令
\[
P=\sum_u \mathbf1_{\mathcal E_u}\mathbf1_{\mathcal E_u}^{\mathsf T}/N_u,
\qquad R=A/D-P.
\]
每对同三角形边只有一个公共端点，故 \(A=\sum_u M_u\)。对称性及 (4.2) 给出
\[
\left|x^{\mathsf T}Rx\right|
\le Cn^{-\gamma}\sum_u\|x|_{\mathcal E_u}\|_2^2
=2Cn^{-\gamma}\|x\|_2^2.
\]
最后等号是每条边恰属两个星，不是 \(n\) 个。因此 \(\|R\|_2=O(n^{-\gamma})\)，同时由非负矩阵的行和得到 \(\|R\|_\infty=O(1)\)。\(P\) 是正半定矩阵，但 \(A/D\) 不必正半定；后者最小特征值只保证不小于 \(-\|R\|_2\)。

### 4.4 \(P=UV\) 是最大范数控制的关键

定义
\[
(Uy)_{uv}=y_u+y_v,\qquad
(Vx)_u=N_u^{-1}\sum_{e\ni u}x_e.
\]
则 \(P=UV\)、\(\|U\|_\infty=2,\|V\|_\infty=1\)。顶点简单随机游走矩阵 \(W\) 满足 \(VU=\mathrm{Id}+W\)，且 \(\|W\|_\infty=1\)。由矩阵指数的幂级数，
\[
E_0(s):=e^{-sP}
=\mathrm{Id}-U\int_0^s e^{-v(\mathrm{Id}+W)}\,dv\,V.
\]
因为 \(\|e^{-v(\mathrm{Id}+W)}\|_\infty\le e^{-v}e^v=1\)，
\[
\|E_0(s)\|_\infty\le1+2s,\qquad
\|E_0(s)\|_2\le1.
\]
即使 \(W\) 有负特征值，这个估计仍成立；没有假设 \(-P\) 的指数为非负 Markov 核。

### 4.5 混合两种范数的有限 Duhamel 展开

取固定整数 \(K\) 使 \(K\gamma>2\)，把
\[
E(s)=E_0(s)-\int_0^s E_0(s-v)R E(v)\,dv,\qquad
E(s)=e^{-sA/D}
\]
迭代至 \(K\) 阶。前 \(K\) 项用最大范数，第 \(j\) 项至多
\[
(1+2s)^{j+1}\|R\|_\infty^j\,s^j/j!,
\qquad 0\le j<K.
\]
余项不用该范数，而用 \(\|E_0\|_2\le1\)、\(\|E(s)\|_2\le e^{s\|R\|_2}\)：
\[
\|\mathcal R_K(s)\|_2
\le \|R\|_2^K e^{s\|R\|_2}s^K/K!.
\]
最后才换范数，\(\|H\|_\infty\le\sqrt m\|H\|_2\le n\|H\|_2\)。对 \(s\le\log n\)，
\[
\|\mathcal R_K(s)\|_\infty
\le n(Cn^{-\gamma})^K
 e^{Cn^{-\gamma}\log n}(\log n)^K/K!
=o(1).
\]
于是 \(\sup_{s\le\log n}\|E(s)\|_\infty\le C(1+\log n)^J\)，其中 \(J,K\) 可很大但与 \(n,G\) 无关。不能把固定阶展开改成最大范数中的无限几何级数：\(\|R\|_\infty\) 并不小。

### 4.6 闭合与端点的量词

把上述半群估计代入 (4.1) 的变常数公式，
\[
\|z(s)\|_\infty
\le C(1+\log n)^{J+1}
   (n^{-2a}+n^{-c}+\log n/D)
=o(n^{-a}).
\]
成立原因分别是 \(a>0,\ c-a>0,\ 2\epsilon-a>0\)，固定对数幂不会破坏它们。因此假设严格改善为 \(\|z\|_\infty\le\delta_n/2\) 与 \(I\le1/4\)。首次退出时各乘积因子仍至少 \(3/4\)，有限多个连续函数的对数可延续；故不能退出。再由连续性覆盖 \(t=1\)，得到
\[
q_e(t)=(1+o(1))q(t),\quad
q_{e,T}(t)=(1+o(1))q(t),\quad
I_{e,T}(t)=O(\log n/D).
\]
一致性同时涵盖所有好图、所有边和略去父类型，以及整个时间区间。先固定前缀参数 \(c>0\)，再取 \(a,\gamma,K\)；不允许让这些数随 \(G\) 或 \(n\) 改变。

## 5. 查询到碰撞：为何误差小于两根成功概率

### 5.1 精确测试和独立乘积是两层不同的断言

正文 §3 在每次对子调用中使用两条焦点边的**一张联合有序候选表**。独立展开内，略去父三角形后两边的候选类型不交，出现位置的后代变量也不交，故对子成功概率分解为 \(q_{f,T}q_{g,T}\)；在实际有限过程内不作这项独立性断言。

有限测试的正确性按阈值下三角形优先级数归纳：若焦点边已经删除，删它的接受三角形对应一个成功子查询；反过来，若某候选子查询成功且所有焦点边都未删除，该候选的三条边当时均存在，扫描必接受它，矛盾。父三角形优先级恰等于阈值，因此只在本层略去是合法的。

独立展开虽然有无限多潜在出现位置，但从每个位置出发、长度 \(j\) 的递减优先级路径概率总和至多 \(M^j/j!\to0\)，其中 \(M\le4D\) 对固定 \(n,G\) 是有限数。有限分枝意味着依赖树几乎必然有限；对可数多个潜在位置取交，可同时覆盖所有阈值。这先构造了概率函数，再推出乘积方程，不是先假定某个递归不动点存在。

### 5.2 重复类型如何变成一条额外边

§5 的耦合逐类型分配随机数：首次曝光用实际优先级，重复曝光用新数。在首次重复之前，所有候选列表、阈值、排序及停止决策都一致。因此根回答的总变差受重复曝光概率控制。为计数它，形式图把每次已访问的子调用记成沿一条旧边粘一个新顶点。若类型重复，就会在至多两条祖先路径的并中找到形式上不存在而其像在 \(G\) 中存在的额外边；两根初始顶点重合另收 \(O(n^{-1})\)。

为什么未访问的重复候选也能被捕捉？若形式顶点标签全部不同，同一三角形在两张列表曝光时，负责它的两条焦点边不同，已覆盖它的三个顶点。若第三条边也在形式图中，该三角形只能是某次粘接产生的三角形：两条新边所在的出生调用把它作为父三角形略去，旧附着边只在一个调用中聚焦，所以不可能曝光两次。于是必有额外边。若标签不单射，选最早重复出生的顶点，其两个旧邻接若均已正式存在，也只能得到被略去的父三角形或同一列表同类型孩子重复，皆不可能。因此可在重复以前、标签仍单射的两条祖先路径中取到额外边。

### 5.3 任意长路径只需一个固定大小的末块

§6 的机制是“图论稀有性 × 动态访问稀有性”。若路径并有 \(\ell\) 个非根调用、使用 \(r\) 个根，额外边的嵌入数至多
\[
(2m)^r(2D)^\ell D^{-50}.
\]
短路径用无根模板估计；长路径只截取最后 \(L=100\) 次出生，用所有补全尺度至多一的模板估计。这样常数和阈值不随总路径长度变化。

具体地，短路径形式图加额外边的每个子图均有边数至多顶点数的两倍，所以子模板尺度至少一，无根模板上界相对自然计数只多 \(\kappa_n p\)，\(\kappa_n=(1+\log n)^{C_0}\)。而 \(pD^{50}=n^{-899/2000+o(1)}\to0\)，足以换成 \(D^{-50}\)。

长路径按父先子后的次序截取末 \(100\) 个出生顶点 \(Z\)。保留每个顶点的两条向后边及额外边 \(ab\)，其余需要的旧端点作为独立根集 \(I\)。每条保留边都触及 \(Z\)，总数为 \(201\)，总顶点数至多 \(301\)，故
\[
S(H,I)=n^{100}p^{201}=D^{100}p
=n^{-799/2000+o(1)}<1.
\]
仅有这个尺度小还不够：须对每个扩大根集检查补全尺度。对真子集 \(U\subsetneq Z\)，有
\[
e(H[I\cup U])\le2\,\#U.
\]
否则必须同时保留额外边及 \(U\) 每个顶点的两条向后边，因而纳入所有自由标记及其末块内祖先，迫使 \(U=Z\)，矛盾。于是这些真子集尺度至少一，任意补全尺度是总尺度与该尺度之比，均至多一；全体 \(U=Z\) 时为一。第二模板上界给出至多 \(\kappa_n\) 种末块补全，再用 \(\kappa_n\le(2D)^{100}D^{-50}\)。这个论证已经包含在原文，并不是只凭“额外一条边很稀有”的直觉。

### 5.4 访问概率：先固定模式，不对实际访问作条件化

另令
\[
\mu=\int_0^1q(t)^2\,dt=\frac{\log(1+2D)}{2D}.
\]
固定图模式及其嵌入后，只对选中子调用的优先级坐标条件化，不能再条件于“已经访问到这里”。不同所需调用的模式外候选子树彼此不交；因此“所有更早模式外子查询失败”的预先定义事件独立。由 §4 的相对概率估计，删去至多两个选中因子后，每个这样的事件概率至多 \(2q(t)^2\)。

在非根分叉处，把 \(q(\max(u,v))^2\) 分给两个孩子的权重，至多损失 \(1+2D\)；根处略去的权重至多再损失两次同一因子。因此总损失可统一记成 \((1+2D)^3\)。零长主干、空臂、标记位于根，以及两根分属不同树均被这个同一上界覆盖。

公共主干长 \(h\)、两臂长 \(\ell_1,\ell_2\) 的固定嵌入，其访问概率至多
\[
(1+2D)^3\frac{(2\mu)^\ell}{h!\,\ell_1!\,\ell_2!},
\qquad \ell=h+\ell_1+\ell_2.
\]
阶乘来自保留每个路径段内的优先级顺序，不是不同访问事件的独立性。乘上至多 \(C2^\ell\) 种模式及根取样概率后，对长度求和为
\[
O\!\left(D^{-50}(1+2D)^3 e^{24D\mu}\right)
=O(D^{-35}).
\]
关键比较是 \(D^{-35}+n^{-1}=o(D^{-1})\)，而非仅仅趋零。精确查询、全列表重复归约、末块模板及访问积分均已逐步手查通过。

有限核对另用 `verification/triangle-removal/check_queries.py`，输入 `verification/triangle-removal/query_fixtures.json`，输出 `verification/triangle-removal/query_results.json`。运行 `python3 verification/triangle-removal/check_queries.py --output verification/triangle-removal/query_results.json` 可重现：枚举 \(n=1,\ldots,5\) 的所有简单图，仅因默认三角形数上限为 7 排除 \(K_5\)，共 1098 图、56552 种优先级排列、4358405 个根回答与 1131321 个对子回答，均与直接扫描删除结果一致。长度至多 7 的 120 个 Y 形长度三元组也精确吻合线性扩张计数。

固定 \(K_4\) 例验证同一类型可以两次曝光而均未访问；重复根的 \(K_3\) 例验证必须另收根重合误差。七种故意错误均被相应检查函数拒绝：翻转回答、用单边 OR 替代对子 AND、相同见证端点、正式边冒充额外边、标签不邻接、祖先标签不单射及偏序系数错一位。有限枚举只检查这些有限逻辑与计数，不证明渐近模板界或稳定性。

## 6. 终端矩：为什么有放回取根及截断都重要

本节手查正文 §7；其输入是 §4 的相对估计与 §§5–6 的绝对误差。

### 6.1 有放回恰好读取普通二阶矩

给定完整好前缀后，从 \(2m\) 条有向边中独立、有放回地抽取 \(k=1,2\) 个根，与后续优先级独立。方向只命名端点。给定终端图后，每个根成功概率为 \(F_n/m\)，独立取样给出
\[
\mathbb P(\text{全部实际根成功}\mid\text{前缀})
=\mathbb E[(F_n/m)^k\mid\text{前缀}].
\]
即使两根抽到同一条边，这个恒等式仍正确。若改从 \(m\) 条无向边中不放回抽取两个根（\(m\ge2\)），给定终端图的成功概率则为 \(F_n(F_n-1)/(m(m-1))\)，读取的是阶乘矩。

在独立展开中，就算两根类型相同，出现树也独立。因此全部独立根成功的概率为
\[
\left(\frac1m\sum_e q_e(1)\right)^k=(1+o(1))q(1)^k.
\]
与实际过程相差至多 \(\Delta_n\)。由于
\[
\frac{\Delta_n}{q(1)^2}
=O(D^{-34}+D/n)=o(1),
\]
一、二阶矩都获得相对误差；\(\Delta_n/q(1)\le\Delta_n/q(1)^2\)，无须再找更强的单根耦合。

令 \(Y_n=F_n/(mq(1))\)。一致地在所有好前缀上，
\[
\mathbb E[Y_n\mid\text{前缀}]=1+o(1),\qquad
\mathbb E[Y_n^2\mid\text{前缀}]=1+o(1),
\]
相减即得 \(\mathbb E[(Y_n-1)^2\mid\text{前缀}]=o(1)\)。不要求两个 \(o(1)\) 有同号，只需各自绝对值一致趋零。

### 6.2 好前缀必须只依赖过去

\(m,D\) 都是确定数，不是在好事件上才定义的随机归一化。精确地
\[
a_n:=\frac{mq(1)}{n^{3/2}}
=\frac{\sqrt D}{2\sqrt{1+2D}}
=\frac1{2\sqrt{2+1/D}}\longrightarrow a=\frac1{2\sqrt2}.
\]
即使过程提前终止、未达到 \(i_0\)，\(Y_n\) 仍然有定义。\(a_n\) 最终有固定正下界，且总有 \(F_n\le n^2/2\)，故 \((Y_n-1)^2\le Cn\)。于是
\[
\mathbb E[(Y_n-1)^2\mathbf1_{\mathcal G_n^c}]
\le Cn\,e^{-(\log n)^{4/3}}=o(1).
\]
在好事件上先对完整前缀条件化，再用一致界。仅有高概率而无尾概率速率通常不够做这个 \(L^2\) 截断。也不能条件于未来继续满足公开停止控制：那会改变续程定律。原文已特意把 \(\mathcal G_n\) 定义成前缀可测事件。

最后由
\[
\mathbb E[(F_n/n^{3/2}-a)^2]
\le2a_n^2\mathbb E[(Y_n-1)^2]+2(a_n-a)^2
\]
得到主定理的 \(L^2\) 结论，再用 Markov 与 Cauchy–Schwarz 分别推出概率与期望极限。这些极限步骤无额外交换极限与条件期望的要求。

## 7. 外部输入、已有数字与实际 Lean

### 7.1 论文只把前缀作为外部证明输入

已对照 Joos–Kühn *The hypergraph removal process*，arXiv:2412.15039v2（2025-08-03）的 PDF 与 TeX 核查。版本原文保留在 `verification/triangle-removal/external/joos-kuhn-v2/removal.tex` 及同目录 PDF。本文所需内容是 §§5–7 的轨迹和停止控制、引理 7.15（PDF 第 16–17 页）的两种一般根模板上界，以及引理 10.1（第 50 页）的失败概率，不是把其一般去除定理直接套到终点。

**初态与时间窗。** 把外部小参数记为 \(\eta\)，先固定足够小的 \(\eta<\epsilon/2\) 且 \(\eta^{-4}\ge8001\)，再取足够小的 \(0<\delta\ll\eta\)，最后令 \(n\) 充分大。三角形的 2-密度为 \((3-1)/(3-2)=2\)，且严格 2-平衡。初始密度 \(\theta=1-1/n\)，外部停止密度 \(n^{-1/2+\eta}\) 低于本文的前缀密度，所以其控制覆盖 \(i_0\)。

根有 \(r\) 个、自由点有 \(a\) 个的固定模板在 \(K_n\) 中恰有 \((n-r)_a\) 个扩张；根内边按外部约定忽略。其计数与尺度之比为 \(1+O_\eta(n^{-1})\)，满足外部初态伪随机条件 P1、P2。P2/P3 的真实分界含 \(\zeta_{\rm init}^{-\delta^{2/3}}\)；对 \(a\ge1\)，尺度约为 \(n^a\)，分界小于 \(n^{1/2}\)，因此小尺度条件不触发；对 \(a=0\)，计数和尺度均为一，直接检查 P3、P4。

**跟踪对象与停止阈值。** 记 \(x_i=np_i^2\)，外部误差为 \(\zeta_i=n^{\eta^2}x_i^{-1/2}\)。本文用的平衡模板根密度至多二，自由点数为 \(a\ge1\)，故尺度至少 \(x_i^a\)。当 \(i\le i_0\)，
\[
\frac{x_i^a}{\zeta_i^{-\sqrt\delta}}
=n^{\eta^2\sqrt\delta}x_i^{a-\sqrt\delta/2}\longrightarrow\infty.
\]
所以不在途中越过跟踪阈值。度用有根边，共邻点用端点作根的二步路；link 中 \(C_j\) 用中心作根的轮图，任取 \(s\) 个自由点至多含 \(s\) 条辐条与 \(s\) 条圈边，所以平衡，尺度为 \(D^j\)，最大规模 \(8001\)。在 \(i_0\)，\(\zeta_{i_0}\le n^{-(\epsilon-\eta^2)}\)，故可固定 \(0<c<\delta(\epsilon-\eta^2)\)，得到本文的相对误差 \(n^{-c}\)。

**两种一般模板界。** 引理 7.15(i) 要求同根各子模板尺度至少一；(ii) 要求固定整张模板、把根从 \(I\) 扩至任意 \(J\) 后的所有补全尺度至多一。后一尺度确为
\[
n^{v(H)-\#J}p^{e(H)-e(H[J])},
\]
因为扩大根集后其内部边不再计入。两者共同的对数幂为 \(2^{v(H)-\#I+1}-2\)，在本文可统一上取 \(C_0=2^{8002}-2\)。这个常数极大但固定，不影响任何渐近吸收。

**概率与可测性。** 引理 10.1 的证明由五项控制得到失败至多 \(5e^{-(\log n)^{3/2}}\)，因而蕴含本文所取的 \(e^{-(\log n)^{4/3}}\)。正的三角形计数轨迹保证到达 \(i_0\)。公开成功事件可以延伸到未来，但本文只把它当作“到达 \(i_0\) 且当时所有所列性质成立”的前缀事件的子集，用来下界概率，不对未来事件作条件化。这一外部输入及其应用已手查通过；整篇正文仍是**依赖该引用结果**的证明，不是无需外部定理的自足证明。

Spencer 的分枝模型给出标量律的先例；Chung–Graham 的稀疏 trace 方法及 Engel–Nagel 的半群扰动是方法背景。§4 已给出本文实际需要的有限矩阵证明，故它们不是另待引用才能填上的主链黑箱。

### 7.2 与公开结果的准确比较

已直接核对 Bohman–Frieze–Lubetzky 的 arXiv:1203.4223v3（2012-06-08，后发表于 2015）定理 1：结论确为 \(F_n=n^{3/2+o(1)}\) 高概率成立，不能从中推出首项常数或期望极限。保留 PDF 为 `verification/triangle-removal/external/bfl-v3/arxiv-1203.4223v3.pdf`。Joos–Kühn v2 猜想 16.2（第 65 页）的系数为
\[
\frac1{k!}
\left(\frac{\operatorname{aut}(F)}
{e(F)(e(F)-1)k!}\right)^{1/(e(F)-1)}.
\]
三角形取 \(k=2,\operatorname{aut}(F)=6,e(F)=3\)，正得 \(1/(2\sqrt2)\)。本文所称加强是确定首项常数并获得 \(L^2\)，不是首次确定指数。

Spencer 1995 作者稿 §3 式 (9) 确为 \(f(c)=(1+Qc)^{-1/Q}\)；令 \(Q=2,c=Dt\) 即本文 \(q(t)\)。但其 §4 明确保持 \(c>0\) 固定，所以不能用它替代本文延伸至 \(c=D\to\infty\) 的一致性及 \(o(D^{-1})\) 两根误差。作者稿和文字提取分别保留为 `verification/triangle-removal/external/spencer-asympacking.pdf`、`verification/triangle-removal/external/spencer-asympacking.txt`。引言其余历史条目未逐篇独立通读，本报告不据此声称核查了完整历史。

### 7.3 实际 Lean 解答：完整陈述、忠实过程与编译边界

本地正文十个 build 文件、README 和 `paper/lean/188.md` 均与指定提交的对应上游文件 Git blob 一致，记录见 `verification/triangle-removal/upstream/blob-checks.json`。上游正文实际在 `preprints/`，scope 实际在 `lean/docs/188.md`；本地前缀改变不表示来源缺失。

`paper/lean/188.md` 链接 comparator；其相邻 JSON 真正指定的解答是 `OAI.Combinatorics.TriangleRemoval.Main`，目标名为 `OAI.SharpTerminalLeave.sharp_terminal_leave`。Comparator 中的占位符不是这份解答缺证。保留的真实入口为 `verification/triangle-removal/lean/source/OAI/Combinatorics/TriangleRemoval/Main.lean`，第 36–89 行给出无附加前提的 \(L^2\) 定理、对所有实 \(\varepsilon>0\) 的偏差概率极限、归一化期望极限及三者合取；实际源文件不只是陈述后两项。

**没有换过程或归一化。** 同目录 `Model.lean` 第 13–44 行的定义与 comparator 对应部分逐字相同：`Graph n` 类型本身允许任意顶点子集的有限集，但初态只含二元边；三角形是三点集中所有二点子集都为现有边的集合；`step` 在当前非空三角形集上用 `PMF.uniformOfFinset` 均匀选择并删除三边，无三角形则吸收。`terminalLaw` 迭代 \(\binom n2\) 步；`Process/TerminalLaw.lean` 第 91–110 行说明这时已无三角形且支持中的图仍只含二元边，所以较宽的类型没有改变实际随机过程。归一化是实数幂 \(n^{3/2}\)，常数是 \(1/(2\sqrt2)\)。例如 \(n=3\) 一步到空图，\(n=2\) 吸收于 \(K_2\)，模型并非靠不可实现的前提为空真。\(n=0\) 的总除法只在有限初段，不改变 `atTop` 极限。

**命名为 obligation 的接口有实际构造。** `Tracking/PrefixEpsilon.lean` 的 `UniformPrefixObligation` 在 `Tracking/NormalizedTrackingAbsolute.lean` 第 84 行起被构造，参数为 \(c=1/80000,C=24005\)，不是主定理调用者需要另给的假设。实际前缀计数、噪声控制及概率界由历史分布推导，再经 `Process/EvolveBindFinish.lean`、`Probability/PmfMeanAffineSq.lean`、`Queries/ContinuationCollisionRemainderTendsto.lean` 接到终端二阶矩。该源码路线也没有把 Joos–Kühn 结果另声明为公理。我们追查了入口、定义及这些关键构造，不声称已逐行手查全部 Lean 证明。

**源码闭包不是 kernel 结果。** 用团队 `math-lean-source-closure` 取得全部 287 个显式 OAI 模块，逐个核对固定提交 Git blob，外部导入边界仅 Mathlib；清单和原始 GitHub 元数据位于 `verification/triangle-removal/lean/closure.json`、同目录 `github-metadata/`。静态扫描记录 `verification/triangle-removal/lean/source-audit.json` 未命中 `sorry`、`sorryAx`、`admit`、自定义公理、`unsafe`、`partial`、`native_decide` 等受检项目，但它不测量传递公理集。上游 JSON 的许可公理列表是策略，也不是本机实测结果。

实际执行 `math-lean-verify verification/triangle-removal/lean/source/OAI/Combinatorics/TriangleRemoval/Main.lean --timeout 120` 后，工具退出 2，报 `unknown module prefix 'OAI'`；原始结果保留在 `verification/triangle-removal/logs/lean-verify.txt`。本机 Lean 4.31.0 可执行，但仅下载了 OAI 源码，没有相应编译对象；上游要求 Lean 4.34.1、Mathlib 提交 `d13f23b723b8a846827a245b89c10fc7d3f11612`。这次没有成功 elaboration，没有测到定理的传递 axioms，也没有证据说版本差本身导致上游不兼容。结论是**实际解答的陈述与关键构造可追，定义忠实；本环境未编译核验**，因此本报告无 `proved in Lean` 项。

## 8. 核验结论

### 8.1 增进

#### 对实际前缀，星平均半群有渐近尖锐的常数包络

**原文基线：** 对星平均和 \(P=UV\)，\(\|e^{-sP}\|_\infty\le1+2s\)。**我们的局部加强：** 使用本文已经拥有的所有不同顶点对共邻点控制，无需另用 link 圈，
\[
\sup_{s\ge0}\left|\|e^{-sP}\|_\infty-F(s)\right|=o(1),
\quad
F(s)=6-4(s+1)e^{-s}-e^{-2s}.
\tag{8.1}
\]
特别地，\(\sup_{s\ge0}\|e^{-sP}\|_\infty\le6+o(1)\)，且常数 6 渐近不可降低。这加强的是**平均算子 \(P\)**，不是 \(A/D\)；后者仍用有限 Duhamel 展开。对 §4.5 的同一固定 \(K\)，前 \(K\) 项的最大对数次数由 \(2K-1\) 降至 \(K-1\)，余项估计不变。不据此给出 \(F_n\) 的收敛速率，也不主张文献优先权。

下面给出手查推导。令 \(\pi(v)=\deg(v)/(2m)\)，\(\Pi=\mathbf1\pi^{\mathsf T}\)，
\[
\eta=\|W^2-\Pi\|_\infty.
\]
对 \(u\ne v\)，
\[
(W^2)_{uv}
=\sum_{w\in N(u)\cap N(v)}
  \frac1{\deg(u)\deg(w)}
=\frac{1+O(n^{-c})}{n},
\]
而 \(\pi(v)=(1+O(n^{-c}))/n\)；对角项为 \(O((np)^{-1})\)。按行求和得
\(\eta=O(n^{-c}+(np)^{-1})=o(1)\)。若只控制相邻点的共度，这一步不能照搬。

置 \(T=W^2-\Pi\)。因为 \(W\Pi=\Pi W=\Pi\)，对 \(j\ge1\)，
\[
W^{2j}=\Pi+T^j,\qquad
W^{2j+1}=\Pi+WT^j.
\]
在 \(e^{-sP}=\mathrm{Id}-U\int_0^s e^{-v(\mathrm{Id}+W)}\,dv\,V\) 中按奇偶次幂分组。定义
\[
a(s)=1-e^{-s},\quad
b(s)=1-(1+s)e^{-s},\quad
\gamma(s)=1-e^{-2s}-2se^{-s}.
\]
三者均介于零和一；\(\gamma(s)=2e^{-s}(\sinh s-s)\ge0\)。令 \(J_m\) 为全边均匀平均矩阵，则 \(U\Pi V=2J_m\)，从而
\[
e^{-sP}
=\mathrm{Id}-a(s)P+b(s)UWV-\gamma(s)J_m+E_s,
\qquad
\|E_s\|_\infty\le\frac{4\eta}{1-\eta}. \tag{8.2}
\]
余项估计是因为每个偶次、奇次积分系数的绝对值不超过
\(\int_0^\infty e^{-v}v^j/j!\,dv=1\)，且 \(\|U\|_\infty\|V\|_\infty=2\)，故其和至多 \(4\sum_{j\ge1}\eta^j\)。\(P,UWV,J_m\) 非负、行和依次为 \(2,2,1\)，因此 (8.2) 给出上界
\[
\|e^{-sP}\|_\infty
\le1+2a+2b+\gamma+\frac{4\eta}{1-\eta}
=F(s)+\frac{4\eta}{1-\eta}.
\]

锐性不是只看这个三角不等式：还需控制正负支撑的重叠。记最小、最大度为 \(d_{\min},d_{\max}\)。对任意行 \(e=uv\)，令 \(S_e\) 为与 \(u,v\) 关联的边集，\(T_e\) 为至少一端落在 \(N(u)\cup N(v)\) 的边集。\(P\) 只支持在 \(S_e\)，且对角至多 \(2/d_{\min}\)。对任意顶点 \(x,w\)，
\[
\sum_{f\ni w}(WV)_{xf}
=\frac{\mathbf1_{\{x\sim w\}}}{\deg(x)}
 +\sum_{z\in N(x)\cap N(w)}
      \frac1{\deg(x)\deg(z)}
\le\frac2{d_{\min}}.
\]
对 \(x=u,v\) 和 \(w=u,v\) 求和，得到 \(UWV\) 在 \(S_e\) 上的总质量至多 \(8/d_{\min}\)。正项 \(\mathrm{Id}+bUWV\) 全部支持在 \(T_e\)，其大小至多 \(2d_{\max}^2\)。先把均匀负项 \(\gamma J_m\) 在整个 \(T_e\)（**含 \(e\)**）的质量计入，再计 \(aP\) 在 \(e\) 处及 \(S_e\setminus\{e\}\) 的重叠，得重叠总质量至多 \(10/d_{\min}+2d_{\max}^2/m\)。所以正负相消对绝对行和的损失至多
\[
\frac{20}{d_{\min}}+\frac{4d_{\max}^2}{m}.
\]
每行的绝对行和均至少
\[
F(s)-\frac{4\eta}{1-\eta}
     -\frac{20}{d_{\min}}-\frac{4d_{\max}^2}{m}.
\]
这些有限图上下界对任意非空、无孤立点且满足 \(\eta<1\) 的简单图均成立。本文前缀中 \(d_{\min}\sim np\to\infty\)，\(d_{\max}^2/m=O(p)\to0\)，所以与上界一起得到对所有 \(s\ge0\) 一致的 (8.1)。\(F\) 从 1 单调增至 6，给出渐近尖锐常数。

**不依赖前缀存在性的显式锐性族。** 对素数 \(q\)，以 \(\mathbb F_q^4\) 的一维子空间为顶点，用非退化交替形式下的正交关系连接不同顶点。取每条射影线首个非零坐标为一的代表，便可直接重建有限简单图。其
\[
n=(q+1)(q^2+1),\qquad d=q(q+1),
\]
因为一个点的正交超平面有 \(q^2+q+1\) 个射影点，去掉自己即为邻点。两个不同点的共同正交空间有 \(q+1\) 个射影点；邻接时其中包含这两个端点，共邻数为 \(q-1\)，不邻接时为 \(q+1\)。因此
\[
\eta=2\left(\frac{q}{q^2+1}
       -\frac{q-1}{q(q+1)}\right)=O(q^{-2}),
\quad d\to\infty,\quad d^2/m=2d/n\to0.
\]
有限图上下界就直接给出这一显式图族的轮廓收敛与常数 6 的锐性，不借用 Joos–Kühn。它们只作为新局部命题的锐性例，不声称满足论文全部 link 圈条件。

**可重跑的计算证据。** `verification/triangle-removal/semigroup_checks.py` 读取 `verification/triangle-removal/semigroup_cases.json`；执行 `python3 verification/triangle-removal/semigroup_checks.py`，结果与 `verification/triangle-removal/semigroup_results.json` 一致。先有浮点探索（另存 `semigroup_exploration.json`，不作证明），再用纯标准库精确有理 Taylor 区间重核：阶数 100，因 \(\|sP\|_\infty=2s\)，余项至多
\[
\frac{(2s)^{101}}{101!}\frac1{1-2s/102},
\]
所有显示区间均向外取整。\(K_4,C_4\)、星和小 theta 图检查全部行，报告全算子最大范数；射影例 \(q=2,3,5\) 的有限时间只检查指定行，不冒称全行最大值。射影例 \(q=2,3,5,7\) 的长时指定行投影范数分别为 \(20/7,325/84,793/170,8705/1736\)；所有点的度和全部点对共邻数均逐项检查。这里 \(B\) 为无向点边关联矩阵，\(P=B^{\mathsf T}\operatorname{diag}(\deg)^{-1}B\)；投影由 \(By=0\)、\(\delta_e-y=B^{\mathsf T}\phi\) 两项精确证书核对，\(\delta_e\) 为该边的单位向量。

十项故意错误均被相应检查函数拒绝：自环、重复边、孤立点、错误 theta 奇偶性、翻转投影项、错误势、负时间、不足 Taylor 阶数、假范数证书及把 \(C_4\) 错当作 \(\eta<1\) 的混合例。条件不能全部去掉：中心边加 \(k\) 条内部不交的奇数长 \(L\ge3\) 路径，其长时中心行范数为 \(k(L+1)/(k+L)\)，可任意大。具体投影在中心边的坐标为 \(k/(k+L)\)，每条路径上交替为 \(-1/(k+L),1/(k+L),\ldots\)；沿每条路径第 \(j\) 点取势 \((-1)^j(L-j)/(k+L)\)，即可直接核对上述两项证书。脚本给出 \(k=14,L=9\) 的精确值 \(140/23>6\)，但它的 \(\eta=248/127>1\)，不是本命题或原论文的反例。

#### 整理两处松估计，碰撞界可细化为 \(O(D^{-40}+n^{-1})\)

**原文基线：** 抛弃主干与两臂之间的次序，只保留各段内部顺序，得到三阶乘及 \(O(D^{-35}+n^{-1})\)。**补充细化：** 嵌入界与模式计数保持不变，同时收紧时间偏序和根／分叉权重损耗。对长度 \(\ell=h+\ell_1+\ell_2\)，保留主干高于两臂的真实偏序后，对称乘积权重的精确积分为
\[
\mu^\ell\,
\frac{\binom{\ell_1+\ell_2}{\ell_1}}{\ell!},
\]
因为主干必须最先出现，随后两臂共有 \(\binom{\ell_1+\ell_2}{\ell_1}\) 种交错。空段及两树情形 \(h=0\) 也适用。

令 \(z=8D\mu=4\log(1+2D)\)，则
\[
\sum_{h,\ell_1,\ell_2\ge0}
\frac{z^\ell\binom{\ell_1+\ell_2}{\ell_1}}{\ell!}
=\sum_{\ell\ge0}\frac{z^\ell}{\ell!}
  \sum_{j=0}^{\ell}2^j
=2e^{2z}-e^z.
\]
还可以少付一次 \(C_D=1+2D\)：设 \(r_{\rm out}\) 为选中路径从根出发的步数，\(f_{\rm fork}\) 为非根分叉数，则
\[
r_{\rm out}+f_{\rm fork}\le2.
\]
同树非根分叉只能有一个根出发步，分别为 \(1+1\)；根处分叉为 \(2+0\)；双树至多 \(2+0\)；单链、零长段或祖先标记只会减少计数。因此原访问界分别取最坏所付的 \(C_D^3\)，可统一换成 \(C_D^2\)。

结合完整偏序，原总因子从 \(C_D^{15}\) 降为 \(C_D^{10}\)，得到
\[
\mathbb P(\mathcal C_k)
=O\!\left(D^{-50}C_D^2(2C_D^8-C_D^4)+n^{-1}\right)
=O(D^{-40}+n^{-1}).
\]
这是原证法两处松估计的整理；拓扑分类经独立手查，有限偏序计算包含在 §5 的脚本中。

### 8.2 错误与不足

未发现正文主证明中的错误：检查包括稳定性、精确查询、重复类型几何归约、所有补全尺度、访问积分、终端矩，以及外部前缀的适用范围。

### 8.3 已核验

正文七节的主证明已逐步手查，尤其是 §4 的混合范数稳定性、§§5–6 的全曝光碰撞与长模板末块，以及 §7 的有放回矩和坏前缀截断。外部前缀引用的版本、初态、阈值及模板约定已逐项对照，历史比较限于 §7.2 明列的三份来源。实际 Lean 的定义、陈述与关键构造核查见 §7.3。

2026-11-10 最终独立重跑两份精确检查器，输出均与交付 JSON 逐字一致，七项查询负控及十项半群负控均被拒绝；执行记录为 `verification/triangle-removal/logs/final-query-replay.txt`、`verification/triangle-removal/logs/final-semigroup-replay.txt`。

| Claim | Source | Basis | Evidence |
|---|---|---|---|
| 好前缀上的精确乘积方程具有 §4 所需的一致稳定性，含 \(t=1\) | 论文，§4 命题 4.1、4.2；以 §2 好图条件及 §3 乘积式为输入 | checked by hand | `guide/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026.md`，§4；`paper/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026/build/stability.tex` |
| 若给定一致前缀界及 \(o(D^{-1})\) 耦合误差，则终端 \(L^2\) 与常数推导成立 | 论文，§7 | checked by hand | `guide/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026.md`，§6；`paper/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026/build/moments.tex` |
| 好前缀概率及所有模板条件满足指定外部定理的适用范围 | 论文，§2 命题 2.2 | conditional on a cited result (Joos–Kühn v2, Lemmas 7.15 and 10.1) | `guide/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026.md`，§7.1；`verification/triangle-removal/external/joos-kuhn-v2/removal.tex` |
| 重复类型耦合、几何见证及 \(O(D^{-35}+n^{-1})\) 碰撞误差 | 论文，§§3、5–6 | checked by hand | `guide/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026.md`，§5；`paper/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026/build/queries.tex`；`paper/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026/build/coupling.tex`；`paper/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026/build/witnesses.tex` |
| 有限精确查询、未访问重复候选、根重合例外及 Y 偏序计数，含七种负控 | 我们，有限交叉核对 | checked by computation | `verification/triangle-removal/check_queries.py`；`verification/triangle-removal/query_fixtures.json`；`verification/triangle-removal/query_results.json`；`verification/triangle-removal/logs/final-query-replay.txt` |
| 好前缀上平均半群的 \(F(s)\) 轮廓与渐近尖锐常数 6 | 我们，对论文平均算子的局部加强 | checked by hand | `guide/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026.md`，§8.1，式 (8.1)–(8.2) 及重叠估计 |
| 平均半群有限时间有理区间、射影例及 theta 投影证书，含十项负控 | 我们，有限精确交叉核对 | checked by computation | `verification/triangle-removal/semigroup_checks.py`；`verification/triangle-removal/semigroup_cases.json`；`verification/triangle-removal/semigroup_results.json`；`verification/triangle-removal/logs/final-semigroup-replay.txt` |
| 原证明的碰撞误差可收紧为 \(O(D^{-40}+n^{-1})\) | 我们，整理原证法两处松估计 | checked by hand | `guide/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026.md`，§8.1；`verification/triangle-removal/check_queries.py`，偏序有限交叉核对 |
| 实际 Lean 入口陈述三种极限，过程和归一化忠实，关键 obligation 已构造 | 论文，Lean 实际解答 | checked by hand | `guide/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026.md`，§7.3；`verification/triangle-removal/lean/source/OAI/Combinatorics/TriangleRemoval/Main.lean`；`verification/triangle-removal/lean/source/OAI/Combinatorics/TriangleRemoval/Model.lean`；`verification/triangle-removal/lean/source/OAI/Combinatorics/TriangleRemoval/Tracking/NormalizedTrackingAbsolute.lean` |
| 指定提交正文一致性及 287 模块显式 OAI 源码闭包的 blob 对照 | 我们，固定提交来源核查 | checked by computation | `verification/triangle-removal/upstream/blob-checks.json`；`verification/triangle-removal/lean/closure.json`；`verification/triangle-removal/lean/source-audit.json`；`verification/triangle-removal/logs/source-closure.log` |
| 本地编译确认主定理且仅依赖标准 axioms | 论文，实际 Lean 解答的待验证范围 | open | `verification/triangle-removal/logs/lean-verify.txt`；本报告 §7.3，缺 OAI 编译对象，未验证 |
| 先前指数结果、猜想常数及固定时间分枝律的准确范围 | 文献，Bohman–Frieze–Lubetzky v3 定理 1；Joos–Kühn v2 猜想 16.2；Spencer §3 式 (9)、§4 | checked by hand | `verification/triangle-removal/external/bfl-v3/arxiv-1203.4223v3.pdf`；`verification/triangle-removal/external/joos-kuhn-v2/removal.tex`；`verification/triangle-removal/external/spencer-asympacking.txt`；本报告 §7.2 |
| 主定理 1.1 的正文证明成立，外部输入为已核对的前缀定理 | 论文，§1 | conditional on a cited result (Joos–Kühn v2, Lemmas 7.15 and 10.1) | `guide/The-Sharp-Terminal-Leave-in-Random-Triangle-Removal-September-25-2026.md`，§§4–7；`verification/triangle-removal/external/joos-kuhn-v2/removal.tex` |
