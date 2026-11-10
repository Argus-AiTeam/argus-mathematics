# 《Symmetry of semialgebraic bounded domains with compact quotient》中文导读

**复仿射代数集中的非空连通有界半代数相对开集，若有适当的离散双全纯群作用和紧商，就必然光滑且双全纯于有界对称域；未发现实质错误。**

## 1. 精确陈述、出处与意义

**主定理 1.1（译述）。** 设 \(X\subset\mathbb C^N\) 是约化复仿射代数集，\(U\subset X\) 是非空、连通、有界、半代数的相对开集。设双全纯变换群 \(\Gamma\) 在赋予离散拓扑后适当地作用于复空间 \(U\)，且 \(U/\Gamma\) 紧。这里适当性指 \((\gamma,q)\mapsto(\gamma q,q)\) 的紧集原像紧。则 \(U\) 光滑，并双全纯于一个有界对称域。

这里“有界”相对于固定的闭代数嵌入，“半代数”指实、虚坐标中的有限布尔多项式条件；不是说 \(\Gamma\) 的变换代数。作用可以有有限稳定子，商不必光滑，更没有预设商射影。环境 \(X\) 可以可约、奇异或非正规。若 \(\dim U=0\)，连通性使 \(U\) 为一点，按零维有界对称域处理；其余证明均假定正维。

**固定版本。** OpenAI，2026-09-24，`openai/math` 提交 `4eaee87548250b2682affda7d05d947c05554bae`。原文为 `paper/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026/build/` 中 `paper.tex` 的 Theorem 1.1 及五个输入文件。版本、来源核对及外部原文清单见 `guide/evidence/symmetry/sources.json`。

问题的张力是：紧商只保证每一点都能移进同一个紧集，远弱于自同构群传递；半代数性只限制一份坐标中的边界，既不给光滑边界，也不给凸性。论文把这两种弱统一性合起来，推出很强的全局对称性。这回答 Kollár–Pardon 的有界域问题，而不是把第一篇的射影分类反过来套用。已直接核对其 arXiv:1104.2309v2，§3、印刷 p.13 的 Question 25：原问题没有额外要求作用自由；不能把紧邻上一段讨论自由作用的假设移进问题。共享原文在 `evidence/universal-covers/sources/arxiv-1104.2309v2.pdf`。

与已发表结果的量级和假设作比较：Frankel，Acta Math. 163 (1989)，Theorem 1 的基线是假定凸的双曲域有紧商；本文不要求凸。Zimmer 的 arXiv:1910.05288v2，Theorem 1.1 假定有界域覆盖紧复流形且边界 \(C^{1,1}\)，结论更强，是球；本文换用半代数性，允许角点，所以只能期待一般有界对称域，例如多圆盘。Zimmer 的原文已核对；Frankel 在这里仅作历史定位，不作为下述证明的输入。

## 2. 阅读路线与符号

| 原文章节 | 做什么 | 首读建议 |
|---|---|---|
| §1 | 主定理、前史与证明依赖图 | 先读主定理及边界构造段 |
| §2 | 加权峰值去奇点；Kobayashi 距离的闭球紧性；解析圆盘连续性原理 | 不要跳过：后面所有极限留在域内都靠它 |
| §3 | 半代数边界分层；带参数分歧消去；在同一点选独立支持 | 先读三个结论，再读 Fubini 和参数证明 |
| §4 | 正则化 Bishop 圆盘推出尺度为 \(t\) 的实心球 | 技术最多；先读非塌缩命题，再回读圆盘引理 |
| §5 | \(t^{-1/2},t^{-1}\) 缩放；正反极限给全局二次模型 | 全文枢纽，尤其不能省略排除点逼近这一半 |
| §6 | 明确有界实现，逐项调用 Vey | 很短，应该读完 |

| 记号 | 含义 |
|---|---|
| \(K\Subset U,\ \Gamma K=U\) | 紧覆盖集，不是基本域，也不要求无稳定子 |
| \(n,m,k\) | \(n=\dim_{\mathbb C}U=m+k\)；\(k\) 为选中边界层的实余维，\(1\le k\le n\) |
| \(S,p\) | 满足复秩条件的边界 Nash 胞腔，以及同时具备参数极限和独立支持的点 |
| \(s=(z_0,\operatorname{Re}w_0)\), \(A_s\) | 旧边界图的实参数、沿虚法向进入 \(U\) 的偏移集合 |
| \(d(s,t;v),d_*,F\) | 截断的“到缩放补集的距离”、其联合极限、零集；\(F\) 是被排除的闭锥 |
| \(h_a,\ell_a\) | 全局整函数峰值支持，以及其对数微分中的独立实法向行 |
| \(\Phi:G\to\Omega\) | 新坐标的逆坐标图，\(G\subset\mathbb C^{m+k}\)、\(\Omega\subset V_{\mathrm{reg}}\)，\(\Phi(0)=p\) |
| \(\delta_t(Z,W)=(\sqrt t Z,tW)\), \(D_t\) | 非等权缩小映射、放大域 \(D_t=\delta_t^{-1}(\Phi^{-1}(U\cap\Omega))\) |
| \(C,H,D\) | 开连通法向锥、向量值 Hermitian 形式、全局二次模型 |

## 3. 两个想法与最小模型

第一，把一个边界点附近的几何借助紧商“搬运到全域”。峰值迫使搬运后的每个紧集都集中到同一点；独立支持再分别控制每个复法向坐标。第二，用半代数性取得**参数和尺度一起变化时**仍稳定的法向极限，再用解析圆盘保证该极限不塌缩。最终得到
\[
D=\{(z,w)\in\mathbb C^m\times\mathbb C^k:
          \operatorname{Im}w-H(z,z)\in C\}.
\]
这里 \(H:\mathbb C^m\times\mathbb C^m\to\mathbb C^k\) 是向量值 Hermitian 形式，第一参数复线性，故 \(H(z,z)\in\mathbb R^k\)。这个模型有实法向平移、切向标量旋转和加权伸缩三个显式对称群，但传递性并不显然，正是 Vey 接手的地方。

最小例子是 \(m=0,k=1,C=(0,\infty)\)：上半平面经 \(w\mapsto(w-i)/(w+i)\) 变成圆盘。第一个有切向的例子是
\[
D=\{\operatorname{Im}w>\|z\|^2\}.
\]
映射 \((z,w)\mapsto(2z/(w+i),(w-i)/(w+i))\) 满足
\[
1-\left\|\frac{2z}{w+i}\right\|^2
 -\left|\frac{w-i}{w+i}\right|^2
=\frac{4(\operatorname{Im}w-\|z\|^2)}{|w+i|^2}>0,
\]
所以给出球。这也直接说明为什么切向要放大 \(t^{-1/2}\)，法向要放大 \(t^{-1}\)：二次高度与法向高度才会同时留下来。若改为多个独立上半平面，则出现角点和多圆盘；不能把本定理的结论擅自加强为球。具体地，\(\mathbb D^2\subset\mathbb C^2\) 有界、连通、开且半代数；两个紧双曲曲面的圆盘覆盖群之积自由、适当、余紧地作用其上，满足全部原假设，但多圆盘不是球。

## 4. 难点展开：逐步重做原有推导

以下按原文展开关键论证。独立复核详细重做了 §§4.7–4.8 的双侧集合收敛与全局互逆，其余承重步骤逐项对照原证明核查假设、推导和输出；外部定理的接口见 §5。

### 4.1 未知正规性时，怎样先去掉奇点？（§2，Lemma 2.1、Proposition 2.2）

不能先在 \(U\) 上直接套用流形版 Montel。原文先取一个正维分支 \(V_0\)，选多项式 \(P\) 在其他分支和 \(V_0\) 的奇点上为零、但不恒为零。最大化
\[
\log|P(q)|+\|q\|^2,\qquad q\in\overline U.
\]
最大点 \(p\) 有 \(P(p)\ne0\)，因此是环境的光滑、不与其他分支相交的点；严格多重次调和性排除内部最大值。整函数
\[
h(q)=\frac{P(q)}{P(p)}
       \exp\bigl(2\overline p\cdot(q-p)\bigr)
\]
满足 \(|h(q)|\le e^{-\|q-p\|^2}\)，\(h(p)=1\)。这是全局支持，不要求光滑边界。

在奇异、非正规点 \(q\) 附近，**逐个处理经过 \(q\) 的正维不可约代数分支 \(V_i\)**。Noether 正规化先给 \(\pi_i:V_i\to\mathbb C^{d_i}\)，\(d_i=\dim_{\mathbb C}V_i\)。缩小中心多圆盘 \(B_i\)，并只保留 \(q\) 附近的部分 \(\Omega_i\)，就有有限适当映射 \(\pi_i:\Omega_i\to B_i\)，且 \(\pi_i^{-1}(0)\cap\Omega_i=\{q\}\)。下面在一个固定分支上省略下标。对任何 \(|h|\le1\) 的全纯函数，分支值的对称多项式
\[
P_h(z,T)=\prod_{\pi(x)=z}(T-h(x))
\]
的系数在判别式外全纯且一致有界，故延拓到 \(B\)。若片数为 \(r\)，中心多项式是 \((T-h(q))^r\)；Cauchy 估计给
\[
|h(x)-h(q)|^r\le C\|\pi(x)\|.
\]
所以在该分支上有统一局部等度连续性。经过 \(q\) 的不可约分支有限，逐支估计便给出它们并集上的等度连续性；零维分支是孤立点，无须估计。逐支考虑分支平均也同样可延拓；极限若在 \(q\) 取值 \(1\)，平均的最大值原理迫使每张片上的极限均为 \(1\)，于是它在 \(q\) 的整个邻域为 \(1\)。这避免了把非正规空间上的弱全纯极限误认成全纯函数。

取 \(q_j=\gamma_jk_j\to p\)，\(k_j\in K\)，抽出 \(k_j\to k\)。上述等度连续性处理移动的 \(k_j\)，得 \(h\circ\gamma_j\to1\)；峰值不等式遂使 \(\gamma_j\to p\) 在 \(U\) 的紧集上一致。每个 \(q\in U\) 最终被送到光滑邻域，双全纯性便使 \(q\) 光滑。连通性再选定包含 \(U\) 的唯一不可约环境分支 \(V\)，以下在 \(V_{\mathrm{reg}}\) 中工作。此步不使用半代数性，也不使用作用自由。

### 4.2 为什么链距离不仅是真距离，而且闭球紧？（§2，Proposition 2.3、Lemma 2.4）

链距离 \(d_U\) 是有限解析圆盘链的 Poincaré 长度下确界。局部坐标圆盘给上界；有界环境坐标经 Schwarz 引理给
\[
d_U(x,y)\ge c\|x-y\|.
\]
二者说明它是诱导原拓扑的真距离。先取 \(K\) 在 \(U\) 中的相对紧开邻域 \(W\)；\(K\) 到 \(V\setminus W\) 的正欧氏间隔给出统一 \(r>0\)，使中心在 \(K\) 的闭 \(r\)-球包含于 \(\overline W\)，因而紧。这里的补集在 \(V\) 中取，不是在 \(\mathbb C^N\) 中取；平移后所有中心都成立。

“局部紧”本身不够。原文利用链定义：沿几乎最短圆盘链的 Poincaré 测地线，在累计长度 \(R\) 处截断。若闭 \(R\)-球紧，用有限个 \(r/4\)-球覆盖它，就把闭 \(R+r/4\)-球装进有限个紧闭 \(r\)-球；迭代得所有闭球紧。这一步用到了圆盘链，不能对任意距离空间仅由局部紧性推出。

由此得到连续性原理：连续变形的闭解析圆盘，若边界始终在 \(U\)，初始圆盘也在 \(U\)，则所有圆盘均在 \(U\)。在待闭合的参数处，圆盘边界附近有固定环带，邻近参数下其像均包含于同一紧集 \(L\Subset U\)。任选环带内一点，任一固定内部点到它的 Poincaré 距离有限，于是内部点的像被拘束在紧的 \(d_U\)-闭球内，极限不能落到 \(\partial U\)。只需对每个内部点分别使用这个界，不需要一个控制整张开圆盘的统一界。

### 4.3 边界层为什么只有两类？（§3，Lemma 3.1）

对实解析半代数参数化 \(q(s)\)，坐标的复化属于 \(\mathbb C(s)\) 的有限代数扩张。在特征零下，其微分张成维数等于坐标函数域的超越次数，也就是复 Zariski 闭包的维数。因此：

- 若一般复秩为 \(n\)，则除本层的零测集外 \(T_pS+iT_pS=T_pV\)；
- 若复秩小于 \(n\)，整个连通层落在 \(V\) 的真复代数子集中。

第二类可用一个多项式因子一起排除。第一类的实维数是 \(2n-k\)，局部写作
\[
\operatorname{Im}w_0=\phi(z_0,\operatorname{Re}w_0),\qquad 1\le k\le n.
\]
这并不声称边界存在光滑超曲面；\(k>1\) 正是多法向角点需要保留的情况。

### 4.4 为什么必须是联合极限？（§3，Lemma 3.2、Proposition 3.3）

令 \(A_s\) 为旧图坐标下的内部法向偏移，定义
\[
E(s,t)=\mathbb R^k\setminus t^{-1}A_s,\quad
d(s,t;v)=\min(1,\operatorname{dist}(v,E(s,t))).
\]
固定 \(s\) 的极限不足以处理后来的 \(s=s(\sqrt t Z,tW)\)。原文的带参数分歧引理说：有界半代数 \(b(s,t)\) 在几乎每个 \(s_*\) 附近，经 \(t=u^l\) 后对 \((s,u)\) 联合实解析。

核验这个较强结论的关键：柱状代数分解（cylindrical algebraic decomposition，CAD）先固定紧贴 \(t=0\) 的代数解析分支；在 \(s_*\) 避开首项系数与判别式的首个非零 \(t\)-系数的零集后，两者是 \(t\) 的幂乘非消失单位。复参数多圆盘乘穿孔圆盘中的根形成有限覆盖；只有绕 \(t=0\) 的有限单值化障碍，幂代换消去它。多项式根界给至多有限阶极点，而实参数、正 \(u\) 上有界使所有负 Laurent 系数恒为零。故确有联合解析延拓，而非仅逐点 Puiseux 展开。

对有理 \(v\in\mathbb Q^k\) 的 \(d(s,t;v)\) 分别应用，再用共同的 1-Lipschitz 性和有限有理网，得到
\[
d(s,t;\cdot)\longrightarrow d_*(\cdot)
\quad((s,t)\to(s_*,0^+))
\]
在每个紧集上一致。可数测试共用的是满测度好点集，**不是**同一个分歧指数或邻域。令 \(F=\{d_*=0\}\)；从 \(E(s,ct)=c^{-1}E(s,t)\) 得 \(F\) 为闭锥。若 \(v\notin F\)，缩放内部最终包含 \(v\) 的固定球；若 \(v\in F\)，附近总有缩放补集点。

同一引理还对半代数选取的 \(v(s,t)\in A_s,\ |v(s,t)|<t\) 给出联合解析的逼近内部图 \(\psi(s,u)\)，且 \(\psi(s,0)=0\)。这正是下一节圆盘构造所需的输入。

### 4.5 “一般好点”与“有足够支持的点”怎样保证是同一点？（§3，Proposition 3.4）

不能分别说两类点都存在就取交。原文改变加权峰值的线性项：
\[
\Phi_a(q)=\log|P(q)|+\|q\|^2+\operatorname{Re}(a\cdot q).
\]
对保留边界层 \(S\)（实维 \(d\)），临界对空间
\[
\mathcal E_S=\{(p,a):d(\Phi_a|_S)_p=0\}
\]
是纤维维数 \(2N-d\)、总维数 \(2N\) 的光滑仿射丛。实际最大值对构成 Borel 子集。投影到 \(a\in\mathbb C^N\) 在可数个紧坐标块上 Lipschitz，所以零测集像仍零测；有限个层的最大值投影覆盖全部参数，故某层的最大值对集合有正测度。

Fubini 先丢掉位于非好点上的零测子丛，再找到一个**好点 \(p\)**，其临界纤维里的最大值参数集有正测度。该纤维到 \(k\) 维余法空间的仿射映射
\[
a\mapsto d\log|h_a|_p\big|_{T_pV}
\]
是满射。任何真线性子空间的逆像均零测，因此依次选出 \(k\) 个独立支持。所得 \(h_a\) 全部在同一 \(p\) 峰值，且
\[
h_a(p)=1,\quad |h_a(q)|\le e^{-\|q-p\|^2},\quad
d\log h_a(p)=i\ell_a(dw).
\]
这里的正测度是临界纤维内的测度，不是要求一个固定点对应正 \(2N\) 维环境参数测度。

### 4.6 为什么法向极限一定有内部？（§4，Lemma 4.1、Proposition 4.2）

仅有上一节，仍可能 \(F=\mathbb R^k\)。在固定复法向切片内，把全实解析边界图双全纯拉直成 \(\mathbb R^k\)，则逼近内部图变成 \(X+if(X,u)\)，\(f(X,0)=0\) 对全部邻近 \(X\) 成立。

这里 \(H^2(S^1,\mathbb R^k)\) 是二阶实 Sobolev 空间，即函数及其前两阶弱导数均平方可积。令 \(T\) 为从全纯边界值的虚部恢复均值为零的实部的有界共轭算子，并设
\[
\mathcal T Y=TY-(TY)(0).
\]
这里的 \(0\) 是边界角度 \(\theta=0\)，对应圆周点 \(1\)。

取圆周上在 \(1\) 附近为零的非负光滑函数 \(\lambda=\alpha\lambda_0\)，以及支撑紧含于 \(\{\lambda_0>0\}\) 的非负光滑凸起函数 \(\eta\not\equiv0\)。对 \(b,e\in\mathbb R^k,\ \delta\ge0\)，所求解析圆盘 \(A_{b,e,\delta}:\overline{\mathbb D}\to\mathbb C^k\) 的边界值定义为 \(X+iY\)，其中
\[
X(0)=b,\qquad
Y(\theta)=f(X(\theta),\lambda(\theta)+\delta)+\eta(\theta)e.
\]
它等价于求解 Bishop 方程
\[
X=b+\mathcal T\bigl(f(X,\lambda+\delta)+\eta e\bigr).
\]
在上述 Sobolev 空间中，\(f(X,u)=u\widetilde f(X,u)\) 使非线性算子及其 \(X\)-导数为 \(O(\alpha+|\delta|)\)，故为压缩，得到唯一的边界值及其全纯延拓 \(A_{b,e,\delta}\)；\(H^2\hookrightarrow C^1\) 保证边界值及参数依赖足够好。令 \(\delta=0\)，端点 \(A_{b,e,0}(1)=b\)，Schwarz 核在远离端点的支撑上展开给
\[
A_{b,e,0}(1-t)=b+itD(b,e)+O(t^2),\qquad
\partial_eD=c_\eta I+O(\alpha),\quad c_\eta>0.
\]
其中 \(iD(b,e)\) 是端点处的向内径向导数。先固定足够小的 \(\alpha>0\)，再限制 \(e\)；不需要当 \(\alpha\to0\) 时 \(e\) 的范围有一致正下界。

真正入域的圆盘取 \(\delta>0\)。先从常值内点圆盘把 \(\lambda\) 增大，再把 \(e\) 增大；凸起函数支撑上的图像在域内有紧余量，连续性原理遂保持整盘在域内。此时只使用 \(\delta>0\) 的圆盘入域。

最后取 \(\delta=t^2,\ b=tB\)，有
\[
t^{-1}A_{tB,e,t^2}(1-t)\longrightarrow B+iD(0,e)
\]
在参数上 \(C^1\) 收敛，极限的实 Jacobian 可逆。定量逆函数论于是给出
\[
B(a_t,ct)\subset U\text{ 的法向切片},\qquad |a_t-p|=O(t).
\]
正则化的误差是 \(O(\delta/t)=O(t)\)，所以不会吃掉这个球。返回旧坐标并取实法向截面后，得到 \(B(v_t,c't)\subset A_{s_t}\)、\(s_t\to s_*\)、\(v_t=O(t)\)。抽取 \(v_t/t\to v\) 就有 \(d_*(v)>0\)，排除全部塌缩。这一步确实使用联合参数极限，而非只检查 \(s=s_*\)。

### 4.7 双侧集合收敛怎样留下二次模型？（§5，Proposition 5.1）

以 \(p\) 为中心选新全纯坐标 \((z,w)\in\mathbb C^m\times\mathbb C^k\)，使 \(T_pS=\{\operatorname{Im}w=0\}\)。记其逆坐标图为 \(\Phi:G\to\Omega\subset V_{\mathrm{reg}}\)，其中 \(G\subset\mathbb C^{m+k}\) 是含 \(0\) 的开集，\(\Phi(0)=p\)。对 \(t>0\) 定义
\[
\delta_t(Z,W)=(\sqrt t Z,tW),\qquad
D_t=\delta_t^{-1}\bigl(\Phi^{-1}(U\cap\Omega)\bigr).
\]
每个 \(\mathbb C^{m+k}\) 中的固定紧集在充分小的 \(t\) 下都进入 \(\Phi\circ\delta_t\) 的定义域；属于 \(D_t\) 就表示其像属于 \(U\)。旧法向偏移 \(v\) 作为新坐标的函数满足
\[
t^{-1}v\bigl(\Phi(\sqrt t Z,tW)\bigr)
\longrightarrow R(Z,W)=L(\operatorname{Im}W)-Q(Z),
\]
其中 \(L\) 可逆，\(Q\) 是实二次向量；混合项除以 \(t\) 后趋零。联合偏移极限给出两件不同的事：

1. \(\mathcal O=\{R\notin F\}\) 的每个紧子集最终包含于 \(D_t\)；
2. 对 \(R(\xi)\in F\) 和任意 \(t_j\downarrow0\)，存在 \(\xi_j\notin D_{t_j}\) 且 \(\xi_j\to\xi\)。

第二件的具体构造是：固定旧实参数 \(s_j\)，只把虚法向偏移改为 \(t_ju_j\)，其中 \(u_j\) 在缩放补集中且与原偏移除以 \(t_j\) 相差 \(o(1)\)。旧坐标改变 \(o(t_j)\)，经固定光滑坐标变换后仍为 \(o(t_j)\)；放大后切向为 \(o(\sqrt{t_j})\)、法向为 \(o(1)\)，所以确有邻近排除点。

取 \(L^{-1}(\mathbb R^k\setminus F)\) 的一个连通分支 \(C\)。正伸缩轨道保持在该分支，故 \(C\) 本身是锥。令
\[
D_0=\{\operatorname{Im}W-P_2(Z)\in C\},\qquad P_2=L^{-1}Q.
\]
实坐标变换把它识别为 \(\mathbb C^m\times\mathbb R^k\times C\)，所以它确为 \(\mathcal O\) 的一个连通分支；此时没有假设 \(C\) 凸。

### 4.8 为什么极限是全局满射，不只是嵌入？（§5，Theorem 5.2）

选 \(b_0=(0,ia_0)\in D_0\)，把 \(p_j=\Phi(0,it_ja_0)\) 写作 \(\gamma_jk_j\)。对任意 \(E\Subset U\)，Schwarz 收缩给
\[
h_a(\gamma_jq)=1+O_E(t_j).
\]
峰值先给 \((z,w)=O_E(\sqrt{t_j})\)；再对所有独立支持取对数，Taylor 展开
\[
\log h_a=i\ell_a(w)+O(|z|^2+|w|^2)
\]
把它加强为 \(w=O_E(t_j)\)。所以
\[
f_j=\delta_{t_j}^{-1}\Phi^{-1}\gamma_j\longrightarrow f
\]
局部一致，不能只靠一个支持来控制 \(k>1\) 的法向。

反向映射 \(g_j=\gamma_j^{-1}\Phi\delta_{t_j}\) 定义在 \(D_{t_j}\)，且 \(g_j(b_0)=k_j\)。为核实其紧包含，给 \(E\Subset D_0\) 选有限个球 \(B(x_\nu,r_\nu)\)，使 \(\overline B(x_\nu,2r_\nu)\subset D_0\)。固定从 \(b_0\) 到每个 \(x_\nu\) 的有限圆盘链；对球内的 \(x\)，再接上圆盘
\[
\zeta\longmapsto x_\nu+2\zeta(x-x_\nu),
\]
用参数 \(0,1/2\) 连接中心与 \(x\)。这些圆盘的闭像全在一个固定紧集内，故最终全部位于 \(D_{t_j}\)，链长也有统一上界 \(M_E\)。Schwarz 收缩给
\[
d_U(g_j(x),k_j)\le M_E.
\]
再固定 \(x_*\in U\)，令 \(M_K=\max_{k\in K}d_U(x_*,k)<\infty\)，便有
\[
g_j(E)\subset\overline B_{d_U}(x_*,M_K+M_E)\Subset U.
\]
因此 Montel 的对角子列给出 \(g:D_0\to U\)，而非只到 \(\overline U\)。对 \(L\Subset D_0\)，\(g_j(L)\) 位于同一个 \(U\) 内紧集，\(f_j\) 在该集附近一致趋于 \(f\)；所以可在 \(f_j(g_j(x))=x\) 中取极限，得到 \(f\circ g=\mathrm{id}_{D_0}\)。

这尚未证明 \(f(U)\subset D_0\)。在每个坐标球内，\(f_j\) 的非零 Jacobian 行列式局部一致收敛；由一变量 Hurwitz 定理沿复直线应用，极限要么处处非零，要么在该球恒零。因此 \(f\) 的满秩点集及其补集都是开集。\(f\circ g=\mathrm{id}\) 使满秩点集非空，连通性遂给出 \(df\) 处处可逆。

下一步需要的是**与 \(j\) 无关的像球**，而不只是每个 \(f_j\) 各自有局部逆。固定 \(q\)，在源坐标中令 \(q=0\)，记 \(A=df_0\)。取闭球 \(\overline B(0,r)\Subset U\)，使
\[
\sup_{\overline B(0,r)}\|I-A^{-1}df\|<\tfrac14.
\]
全纯局部一致收敛蕴含较小闭球上的导数一致收敛，故对大 \(j\)，
\[
\sup_{\overline B(0,r)}\|I-A^{-1}df_j\|\le\tfrac12,\qquad
\|A^{-1}(f_j(0)-f(0))\|\le r/4.
\]
对任意满足 \(\|A^{-1}(y-f(0))\|\le r/4\) 的 \(y\)，映射
\[
T_{j,y}(x)=x+A^{-1}(y-f_j(x))
\]
的 Lipschitz 常数至多 \(1/2\)，且 \(\|T_{j,y}(0)\|\le r/2\)，所以把该闭球压缩到自身。不动点满足 \(f_j(x)=y\)。取 \(\varepsilon=r/(4\|A^{-1}\|)\)，就得固定的
\[
B(f(q),\varepsilon)\subset f_j(V_q)\subset D_{t_j}
\]
对充分大的 \(j\) 成立，其中 \(V_q\Subset U\) 是所取源坐标球。

若 \(R(f(q))\in F\)，上一节会给出 \(\xi_j\notin D_{t_j}\)、\(\xi_j\to f(q)\)，与这个固定像球矛盾。因此 \(f(U)\subset\mathcal O\)；它连通且由 \(f\circ g=\mathrm{id}\) 包含整个 \(D_0\)，只能恰为这个连通分支。现在才知道每个 \(f_j(q)\) 最终位于 \(D_0\) 内的一个固定紧邻域，可在 \(g_j(f_j(q))=q\) 中取极限，得到 \(g\circ f=\mathrm{id}_U\)。两侧集合收敛、反向紧性、非退化三个环节缺一不可；这里没有从单侧包含直接跳到满射或单射。

分解
\[
P_2(z)=H(z,z)+\operatorname{Re}B(z),\qquad w=W-iB(Z)
\]
去掉纯全纯二次项，得到前述 \(D\)。峰值除以 \(t\) 后的极限含有纯二次项；在 \(z\mapsto e^{i\theta}z\) 上平均，它们消失而 \(\|d_z\Phi_0(z)\|^2\) 保留。因此存在独立 \(\ell_a\) 和共同 \(c>0\) 满足
\[
\ell_a(\operatorname{Im}w)\ge c\|z\|^2,\qquad
\ell_a(y)>0\ (y\in C),\qquad
\ell_a(H(z,z))\ge c\|z\|^2.
\]
第二式由开锥上非负线性函数不能在内部为零；第三式把 \(w=i(H(z,z)+ry)\) 代入并令 \(r\downarrow0\)。

## 5. 外部文献接口，尤其是 Vey 的真实条件

**Noether 正规化。** Stacks，Lemma 10.115.4，Tag `00OY`：有限生成非零代数包含一个多项式子代数，并在其上有限。它在 §2 只供应奇点附近的有限投影；局部等度连续与最大值传播由本文自己证明。网页定理已核对，不需要假定 \(U\) 正规。

**半代数几何。** Coste，*Real algebraic sets*，2005-03-23 讲义，§1.1 的 Theorem 1.1 给出投影保持半代数性及距离函数的半代数性；§1.2 的 Theorem 1.3 给相容 Nash 胞腔分解及 CAD 描述（印刷 pp.6–7）。半代数选取可由这些柱状胞腔的纤维逐段选择得到。它们不直接提供本文的带参数分歧结论；那个较强结论必须保留 §3 的证明。原文保存在 `guide/evidence/symmetry/coste2005.pdf`。

**解析圆盘。** Hill–Taiani，1978，§2，Equation (2.1)、Proposition 2.1，印刷 pp.330–331，解释边界共轭方程与解析圆盘的对应。\(H^2\) 估计、凸起函数参数、\(\delta=t^2\) 的正则化及定量满秩论证则由本文 §4 给出。已读取所引原页，保存在 `guide/evidence/symmetry/hill-taiani1978.pdf`；原扫描中公式的文本提取不完整，核对时应看 PDF 原页。

**Vey。** *Sur la division des domaines de Siegel*，Ann. Sci. ENS (4) 3 (1970)，479–506；原文为 `guide/evidence/symmetry/vey1970.pdf`。已核对的印刷 pp.479–481（PDF pp.2–4）另存为 [p.479 原页图](evidence/symmetry/vey1970-p479.png)、[p.480 原页图](evidence/symmetry/vey1970-p480.png)、[p.481 原页图](evidence/symmetry/vey1970-p481.png)。Theorem 1 在 p.479 断言可整除的 S-域同质，紧接下一段明确给出对称性的推论（援用 Hano、Koszul、Borel）；本文使用的是这两句合在一起的文献结果。

| Vey 的定义/条件 | 本文如何满足 |
|---|---|
| 域双全纯于同维有界域 | 不能仅援引 \(U\subset\mathbb C^N\) 有界。令 \(u_a=\ell_a(w)\)，用 \(( (u_a-i)/(u_a+i))_{a=1}^k,\ z/(u_1+i)\) 实现在 \(\mathbb C^{m+k}\) 中有界且可全纯反解 |
| 含法向任意、切向为零的一点 | \(a_0\in C\) 给 \((0,ia_0)\in D\) |
| 所有实法向平移 | 不改变 \(\operatorname{Im}w-H(z,z)\) |
| 所有标量切向单位旋转 | Hermitian 性使 \(H(e^{i\theta}z,e^{i\theta}z)=H(z,z)\) |
| 指数 \(1/2\) 的伸缩 | \((z,w)\mapsto(\sqrt r\,z,rw)\)，残差变为原来的 \(r\) 倍 |
| 可整除性（divisible） | 共轭原作用；p.479 的定义就是离散拓扑下的适当作用，加上 \(\Gamma K=D\)，没有自由性要求 |
| 零切向块 | 本文 \(m=0\) 对应 Vey 的第二块维数 \(m=0\)；p.480 例 2、p.481 Remark 2 明确纳入，指数约定 \(1/2\) |
| 凸性 | 不在 p.479 的 S-domain 定义中；p.480 的凸锥是例子，不能误读成输入假设 |

注意 Vey 的变量顺序与本文相反：Vey 的第一块是本文 \(w\)，维数为 \(k\)；第二块是本文 \(z\)，维数为 \(m\)。其伸缩参数 \(e^t\) 对应这里的 \(r\)。

有界实现的估计也可直接复算。若 \(y=\operatorname{Im}u_1>c\|z\|^2\)，则
\[
\left\|\frac z{u_1+i}\right\|
\le\frac{\sqrt{y/c}}{1+y}
\le\frac1{2\sqrt c}.
\]
各 Cayley 坐标恢复 \(u_a\)，独立性恢复 \(w\)，最后恢复 \(z\)，所以不是只有有界全纯映射而缺少嵌入。\(m=0\) 时删去最后一块即可。半正定情形的边界见下面的核验结论。

## 6. 作者 Lean 的范围

作者的 `lean/docs/058.md` 将形式化关联到本篇主定理。固定提交的 `ComparatorChallenges/SymmetricDomains.json` 指向 `OAI.Analysis.SymmetricDomains.Main` 中的 `OAI.Release061.main`；实际 `Main.lean:55–86` 有证明体，Comparator 的 `sorry` 是挑战占位，不是实际解答缺失。

实际 `Basic.lean` 的定义、`Main.lean` 的签名与 Comparator 一致；这些定义如何对应正文，是判断形式化范围的关键：

| 正文含义 | 实际形式语句 |
|---|---|
| 可奇异、可约的复仿射代数集及半代数性 | 实际复多项式共同零集；实、虚坐标上的有限布尔多项式条件，不是未解释的任意谓词 |
| 非空连通、有界、相对开 | `IsConnected` 在固定 Mathlib 中已含非空；`Bornology.IsBounded`；逆像在环境子类型中开，不是要求在整个 \(\mathbb C^N\) 开 |
| 离散适当作用、紧商 | `DiscreteTopology Γ`、`ProperSMul Γ U`、实际轨道商的 `CompactSpace`；没有自由性假设 |
| 全纯和双全纯 | 局部环境空间中的复解析延拓；`Biholomorph` 有真正的同胚及全纯正逆映射 |
| 光滑及有界对称域 | 实际局部复坐标；有界开连通域在每点有全纯对合，且该点是孤立不动点 |

证明结构也不只是把所需模型放进额外假设：`SupportedHermitianModel.lean:41–213` 从原条件构造模型，`NoncollapsedSupportedBoundary.lean:59–108` 构造非坍缩边界。抽象 `WeightedLieModel` 的字段由 `Geometry3.lean:69–128` 从实际一参数自同构群生成元构造；`ModelAxisNegativeIsotropy.lean:116–178` 构造导数为 \(-\mathrm{id}\) 的稳定子元素，再由 `PointSymmetryNegId.lean:61–114` 得真正的点对称性。源码没有把 Vey 定理作为自定义公理导入；这与正文调用 Vey 是两种不同的证据路线。

**核验边界。** 已核对固定来源、实际定义和核心证明体，源码陈述覆盖完整主定理。上游为 Lean `4.34.1`、Mathlib `d13f23b723b8a846827a245b89c10fc7d3f11612`；实际执行 `math-lean-verify evidence/lean-058/original/OAI/Analysis/SymmetricDomains/Main.lean --timeout 120` 返回 2，原因是预配置 Mathlib 工作区缺失。因此本次只有源码级证据，没有本机编译证书或实测传递公理集；源码扫描和 JSON 的允许公理清单不能替代内核验证，也不能据此扩张到另一篇普遍覆盖分类。

具体对照见 `evidence/lean-058/statement_fidelity.md`，闭包及版本见 `evidence/lean-058/source-closure.json`、`evidence/lean-058/auxiliary-sources.json`，执行结果见 `evidence/lean-058/verify-original.log` 与 `evidence/lean-058/source-check.log`。

## 7. 核验结论

### 改进

**支持条件的等价改写。** 原文 Theorem 5.2 及 §6 使用 \(k\) 个独立实线性形式 \(\ell_a:\mathbb R^k\to\mathbb R\)，满足在 \(C\) 上严格为正，且每个 \(A_a=\ell_a\circ H\) 正定。若对给定这族形式只知道
\[
A_a\ge0,\qquad \bigcap_{a=1}^k\ker A_a=\{0\},
\]
则 \(A_\Sigma=\sum_a A_a\) 正定，有 \(A_\Sigma(z,z)\ge c_\Sigma\|z\|^2\)。定义 \(u_\Sigma=\sum_a\ell_a(w)\)，把原文最后的分母换成 \(u_\Sigma+i\)，仍有
\[
\operatorname{Im}u_\Sigma>A_\Sigma(z,z),\qquad
\left\|\frac z{u_\Sigma+i}\right\|\le\frac1{2\sqrt{c_\Sigma}}.
\]
保留原来的 \(k\) 个 Cayley 坐标即可反解。

对这个**局部有界实现判据**，\(C\) 其实只需非空、开、连通，并让上述支持严格为正；不用凸、锥或半代数。不能据此删除主证明中锥的作用：§6 调用 Vey 仍需要正伸缩不变性。

任取 \(\varepsilon>0\)，令
\[
\ell'_a=\ell_a+\varepsilon\sum_b\ell_b.
\]
每个 \(\ell'_a\circ H\) 正定，每个 \(\ell'_a\) 在 \(C\) 上正，且变换矩阵 \(I+\varepsilon\mathbf1\mathbf1^T\) 的行列式为 \(1+k\varepsilon\ne0\)，故它们仍独立。因此两种支持族的存在性条件等价：这只是原证明的直接推论和判据澄清，使输入表示更灵活，并未扩大模型类，不是新定理或主定理的修复。上述改写已独立手工核验。

精确例子取 \(C=(0,\infty)^2\)，\(H(z,z)=(|z_1|^2,|z_2|^2)\)，\(\ell_1,\ell_2\) 为坐标投影。两个标量形式分别退化，但共同核零，模型是两个球的上半空间实现之积。换成 \(\ell'_1=2\ell_1+\ell_2,\ \ell'_2=\ell_1+2\ell_2\) 后已满足原判据。

共同核条件的边界：在半正定前提下，若共同核有非零 \(v\)，则半正定形式的 Cauchy–Schwarz 不等式给
\[
|A_a(v,z)|^2\le A_a(v,v)A_a(z,z)=0.
\]
由恰好 \(k\) 个 \(\ell_a\) 在 \(\mathbb R^k\) 上独立，其复线性延拓也构成对偶基，故 \(H(v,z)=0\)。Hermitian 性再给 \(H(z,v)=0\)，从而
\[
H(z+\lambda v,z+\lambda v)=H(z,z)\qquad(\lambda\in\mathbb C).
\]
对任意 \((z,w)\in D\)，整条复直线 \((z+\lambda v,w)\) 都保持在 \(D\)。若有到有界域的双全纯映射，其每个坐标限制在该直线上都由 Liouville 定理为常数，与单射矛盾。如 \(H\equiv0\) 给 \(\mathbb C^m\times T_C\)，其中 \(T_C=\{w:\operatorname{Im}w\in C\}\)。这个边界论证仍须保留半正定性。

有限例子的精确复算命令为 `python3 evidence/model-criterion/verify.py evidence/model-criterion/witness.json --self-test`。独立重跑通过了四个有理输入（含非对角秩一形式和 \(m=0\)），并确认七种故意坏输入被拒绝；脚本也检查了原单项分母在退化支持下无界的例子。一般判据及共同核结论依据的是上述手工论证，不是有限样例外推。

**常数的确认而非改进。** 原文有界实现中的 \(1/(2\sqrt c)\) 已是这个支持下界能给出的最优通用常数：在 \(\operatorname{Im}w>c\|z\|^2\) 中取 \(w=i\)、\(\|z\|\uparrow1/\sqrt c\)，则 \(\|z/(w+i)\|\uparrow1/(2\sqrt c)\)。不等式的等号只在边界极限达到，不与域内严格支持冲突。

### 错误与不足

**未发现影响主定理的错误或待补的论证缺口。** 主要可读性难处是三种紧性挨得很近：奇点上的等度连续、链距离的闭球紧性、缩放逆映射的紧包含；本导读在 §4 分开解释其用途。

### 已核验

独立详细重做了双侧缩放集合收敛和全局正反互逆；逐项手核了加权峰值去奇点、Kobayashi 闭球紧性、联合分歧极限、同点支持的测度选择、正则化圆盘非塌缩及支持换基。另直接读取 Vey pp.479–481 原页核对应用条件，核查作者实际 Lean 的主定理陈述与关键语义接口。逐项来源与证据如下。

| Claim | Source | Basis | Evidence |
|---|---|---|---|
| 约化、可奇异非正规环境中的 \(U\) 在紧商条件下光滑 | 原文 §2，Lemma 2.1、Proposition 2.2 | checked by hand | `paper/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026/build/01_geometry.tex`；本导读 §4.1 |
| Kobayashi 圆盘链距离的闭球紧性，及所用连续性原理 | 原文 §2，Proposition 2.3、Lemma 2.4 | checked by hand | `paper/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026/build/01_geometry.tex`；本导读 §4.2 |
| 边界胞腔的复秩二分与带参数分歧结论 | 原文 §3，Lemmas 3.1–3.2 | checked by hand | `paper/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026/build/02_preparation.tex`；本导读 §§4.3–4.4 |
| 联合法向极限和独立支持可在同一边界点选取 | 原文 §3，Propositions 3.3–3.4 | checked by hand | `paper/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026/build/02_preparation.tex`；本导读 §§4.4–4.5 |
| 正则化解析圆盘产生半径与位移同阶的实心球，\(F\ne\mathbb R^k\) | 原文 §4，Lemma 4.1、Proposition 4.2 | checked by hand | `paper/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026/build/03_noncollapse.tex`；本导读 §4.6 |
| 双侧缩放集合收敛及正反映射的全局互逆 | 原文 §5，Proposition 5.1、Theorem 5.2 | checked by hand | `paper/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026/build/04_scaling.tex`；本导读 §§4.7–4.8 |
| 相位平均给独立正定支持；有界实现位于内在维数 | 原文 Theorem 5.2、§6 | checked by hand | `paper/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026/build/04_scaling.tex`；`paper/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026/build/05_symmetry.tex`；本导读 §§4.8、5 |
| Vey 所用定义无自由作用、先验凸性要求，并容许零切向块 | 文献：Vey 1970，pp.479–481 | checked by hand | `guide/evidence/symmetry/vey1970.pdf`；`guide/evidence/symmetry/vey1970-p479.png`；`guide/evidence/symmetry/vey1970-p480.png`；`guide/evidence/symmetry/vey1970-p481.png`，定义、Theorem 1 后一段、Remark 2；本导读 §5 |
| 主定理 1.1：\(U\) 光滑且为有界对称域 | 原文 §1、§§2–6 | conditional on a cited result (Vey 1970, Theorem 1 and following symmetry consequence) | 本导读 §§4–5；`guide/evidence/symmetry/vey1970.pdf` |
| 作者实际 Lean 的主定理陈述与正文及关键几何接口一致 | 作者固定源码及本次来源、语义核查 | checked by hand | `evidence/lean-058/statement_fidelity.md`；`evidence/lean-058/source-check.log` |
| 固定支持族的半正定共同核零条件可用于有界实现，并等价转换为原正定支持族 | 原文 §6 的直接推论；本导读的显式改写 | checked by hand | `guide/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026.md`，§7“改进”，分母求和与 \(\ell'_a\) 公式 |
| 四个精确支持样例通过有界估计与反解，七种坏输入被拒绝 | 本导读的有限例子检查，不代替一般证明 | checked by computation | `evidence/model-criterion/verify.py`；`evidence/model-criterion/witness.json`；使用 --self-test |
| 在半正定前提下，共同核非零产生整条复直线；这是所提推广的边界 | 本导读的边界检查 | checked by hand | `guide/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026.md`，§7“改进”，Liouville 论证 |
| 原文有界实现估计 \(1/(2\sqrt c)\) 对给定支持下界是最优通用常数 | 原文 §6 的常数；本导读的极限例子 | checked by hand | `guide/Symmetry-of-semialgebraic-bounded-domains-with-compact-quotient-September-24-2026.md`，§7“常数的确认而非改进” |
