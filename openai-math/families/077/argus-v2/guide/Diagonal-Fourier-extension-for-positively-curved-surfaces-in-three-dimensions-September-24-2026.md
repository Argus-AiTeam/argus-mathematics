在 Ren–Wang、Bourgain–Demeter 与 Bourgain 球面 factorization 的文献输入下，一般紧光滑正曲率曲面的所有有限 \(p>3\) 对角延拓界已通过手算及独立复核；覆盖步骤还可把显式端点因子从 \((p-3)^{-7/p}\) 改为 \((p-3)^{-6/p}\)。

# 正曲率曲面的对角 Fourier 延拓：中文导读与核验

## 精确命题、版本和结论的边界

原文 Theorem 1.1：设 \(\Sigma\subset\mathbb R^3\) 为紧的光滑二维曲面，允许光滑边界；第二基本形式处处定号，每个图表选法向后正定。定义
\[
E_\Sigma f(x)=\int_\Sigma f(\xi)e^{2\pi i x\cdot\xi}\,d\sigma(\xi).
\]
则对每个**固定的有限** \(p>3\)，存在 \(C_{\Sigma,p}<\infty\)，使所有复值 \(f\in L^p(\Sigma,d\sigma)\) 满足
\[
\|E_\Sigma f\|_{L^p(\mathbb R^3,dx)}
\le C_{\Sigma,p}\|f\|_{L^p(\Sigma,d\sigma)}.
\]
量词是先固定曲面、图表与指数，再统一控制所有数据；不是对曲面族统一，也没有断言 \(p=3\)。更强的中间结论是每个固定紧支撑图表上的 \(L^3_\xi\to L^p_x\)，最后才用有限测度上的 \(L^p\subset L^3\)。

核验版本为 OpenAI 署名、2026-09-24 的《Diagonal Fourier extension for positively curved surfaces in three dimensions》，来自 `openai/math` 提交 `4eaee87548250b2682affda7d05d947c05554bae`。原件在 `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/`；下文节号均指该版。该论文及本族材料没有随附作者 Lean，本文也没有用 Lean 证明解析结论。

**依赖状态。** 振荡输入是同日《Elliptic capacity propagation and Fourier restriction to the sphere》的 Theorem 6.4；其完整几何与数组论证、定义及本篇对接均已手算复核，文献依赖是 Ren–Wang arXiv:2308.08819v2 Theorem 4.1 与 Bourgain–Demeter arXiv:1403.5335v3 Theorem 1.1，见[伴随导读](Elliptic-capacity-propagation-and-Fourier-restriction-to-the-sphere-September-24-2026.md) §3.4、§9。原文的正权重输入引用独立 Kakeya 新稿 Theorem 1.1；**本导读改用伴随球面 Corollary 1.3 取得同一最大算子界**，另保留 Bourgain 球面 factorization，准确开源接口为 Buschenhenke arXiv:2106.02587v2 §1.1。球面证明不调用本篇或独立 Kakeya 定理，替代无循环。这是本导读的替代路线，不是原文的引用路线。

## 问题为什么重要，现有数字怎样比较

延拓问题问：把频率数据放在弯曲的二维面上，振荡能在三维空间产生多少可积性？非零光滑数据在一族法向方向上具有约 \(r^{-1}\) 的衰减，三维径向积分临界于 \(\int r^{2-p}\,dr\)，因而 \(p>3\) 是自然的严格范围。单小帽的 Knapp 检验还约束一般输入、输出指数。

作为实际比较，Guth 的已发表于 JAMS 29 (2016), 371–413 的多项式分割结果，其 arXiv:1407.1916v3 Theorem 0.1 给 \(L^\infty(\Sigma)\to L^p(\mathbb R^3)\)、\(p>13/4=3.25\)；这不是对角 \(L^p\) 输入的同一句命题。更接近本文的是 Wang–Wu 的 arXiv:2411.08871v3（2024-12-19）Theorem 0.2，明确给出同类、允许边界的紧 \(C^2\) 正曲率曲面的对角估计 \(p>22/7=3.142857\ldots\)。两者原文使用 \(e^{ix\cdot\xi}\)，换成本文 \(e^{2\pi ix\cdot\xi}\) 只改变固定空间缩放因子，不改指数。本文声称把后一个门槛推至全部 \(p>3\)，不是从一个已知 \(p>3\) 结论重新包装。Wang–Wu 是这里直接读过的比较版本；不把预印本版本标作已核验的期刊发表版本。

## 一条主线和各节的用途

核心是把“有抵消的复系数”与“没有抵消的正管密度”分开处理，再以容量分组连接两者：
\[
\text{packet 的三次样本估计}
\quad+\quad
\text{正管的 }L^{3/2}\text{ 估计}
\ \Longrightarrow\
\text{一个共同 }L^3\text{ 范数控制多个远球}
\ \Longrightarrow\
\text{全局 }L^p,\ p>3.
\]
普通局部 \(R^\varepsilon\) 估计不能直接对无限多个球求和；稀疏球部分的任务正是保证右端不随球数线性增长。

| 原文部分 | 做什么；阅读顺序 |
|---|---|
| §1 | 主定理、两个输入、推论与 \(p\downarrow3\) 的常数说明。 |
| §2 | 把曲面化为固定全局相位的紧支撑图积分；边界数据只作零延拓。 |
| §3 | 插入允许的 continuation；建立精确帧、容量、原子范数；把伴随 Theorem 6.4 专门化到 \(m=N\)。 |
| §4 | Kakeya 对偶给正管估计；按**剩余数组的容量**分组，得到任意复数组的离散三次估计。 |
| §5 | 剔除小共振频率集，证明远球间联合初始系数估计；控制空间截断尾，再把格点样本填成球上积分。 |
| §6 | 基础 \(L^4\) 确保水平集只占有限个单位方块；慢增长选尺度、染色、layer cake 去掉小幂损失；证明端点常数下界。 |
| §7 | 保留两个 Jacobian 返回曲面；给 Schrödinger 局部光滑化及一类 Bourgain 相位的推论。 |

初读宜先看 §4、§5 和 §6 的分布函数积分，再回头检查 §3 的相位类别。§7 两个应用可以最后看；它们不是主定理的前提。

## 记号速查

| 记号 | 含义和规范 |
|---|---|
| \(E_\phi g(y',t)\) | \(\int g(\xi)e(y'\cdot\xi+t\phi(\xi))\,d\xi\)，\(e(t)=\exp(2\pi it)\)。 |
| \(F\) | \(E_\phi(h\chi_1^{\nu_*})\)，\(h\) 支撑于固定紧集 \(Q_0\)。 |
| \(N,\delta\) | 二进尺度 \(N\ge2\)，\(\delta=N^{-1}\)；物理球半径约 \(N^2\)。 |
| \(\chi_\theta^\nu,D_{\rm f}\) | 固定光滑频率窗，支撑在边长 \(D_{\rm f}\theta\) 的方形内，满足平方和分割恒等式。 |
| \(\theta,r,w\) | 尺度因子 \(m\) 时为 \(m\delta,m^{-2},\delta/m\)，恒有 \(N^2w\theta=1\)。 |
| \(\nu,z,I\) | 频率窗中心、缩放后的空间标签、时间区间；\(\sum_\nu(\chi_\theta^\nu)^2=1\)。 |
| \(U_\nu\) | \(-\nabla\phi(\nu)\)；固定频率域上双 Lipschitz。 |
| \(W_\kappa(E)\) | 椭圆半轴 \(L\ge a\) 的偏置面积 \(L^{1+\kappa}a^{1-\kappa}\)，不是椭圆的实际面积 \(\pi La\)。 |
| \(\mathcal K_\kappa(d)\) | \(\sup\delta^2W_\kappa(E)^{-1}\sum_{U_\nu\in u+E,\ z\in v+E}\lvert d_{\nu,z}\rvert^2\)，\(a\ge\delta\)，两个平移独立。 |
| \(m(d),b_\nu\) | \(\delta^2\sum\lvert d\rvert^2,\ \sum_z\lvert d_{\nu,z}\rvert^2\)。 |
| \(H_d\) | \(\sum\lvert d_{\nu,z}\rvert^2{\bf1}_{\{\lvert X-z-tU_\nu\rvert\le\delta,\ 0\le t\le1\}}\)；\(\int H_d=\pi m(d)\)。 |
| \(P(\kappa,\eta),M(s)\) | 固定相位/标签设置下的 packet 常数及 Kakeya 常数；均只知每个正参数处有限。 |

## 关键推导一：输入的范围不能被偷偷扩大

### 椭圆图表为何能使用“球面的”packet 定理

伴随 §6.1 的输入不是一句“任意严格凸相位”：它先固定小球面图的全局 continuation，随后明确允许数组标签落在固定有界域的任何位置，包括 cutoff 过渡区。这个后半句至关重要。

本篇 Lemma 3.1 的做法是
\[
q_s(\xi)=-\sqrt{1-|\xi|^2},\quad Q_s=-1+\tfrac12|\xi|^2,
\quad q=Q_s+\zeta_0(q_s-Q_s).
\]
在 \(\rho<|\xi_1|<2\rho\) 的小邻域让 \(\zeta_0=1/2\)。用固定仿射变换把目标图 \(\psi\) 的值、梯度、Hessian 全部匹配到 \(q\) 在 \(\xi_1\) 的二阶 jet，再以尺度 \(\epsilon\) 的 bump 插入 \(\psi-q\)。由二阶相合，
\[
\|D^j[\vartheta((\xi-\xi_1)/\epsilon)(\psi-q)]\|_\infty
\le C\epsilon^{3-j},\qquad j=0,1,2.
\]
故凸性保留。过渡环上 \(D=q_s-Q_s>0\)，新 cutoff 为
\(\widetilde\zeta=\zeta_0+R_\epsilon/D\)；缩小固定 \(\epsilon\) 可令其值仍在 \([0,1]\)。因此新相位仍属于该类，而不是仅仅拥有正 Hessian。

这里没有随 \(N\)、\(p\) 或小损失参数改变相位；高阶导数虽可能很大，却是固定常数。伴随定义还确实允许任意有限复输入数组、保留完整矩阵及坐标筛选。若把定理误读成只作用于原球面核心或只作用于分析算子像中的数组，后面的密度分解便不能合法调用它。

### 精确帧的尺度核对

空间标签为 \(z\in D_{\rm f}^{-1}w\mathbb Z^2\)，其 Fourier 频率
\(N^2z\in(D_{\rm f}\theta)^{-1}\mathbb Z^2\)。因此在边长 \(D_{\rm f}\theta\) 的方形上 Parseval 恰给
\[
\|\mathsf P_{m,I}f\|_{\ell^2}^2
=(D_{\rm f}\theta)^2\|f\|_2^2,\qquad
\mathsf S_{m,I}\mathsf P_{m,I}f=f.
\]
这已在原文证明，并非原文省略。令 \(m=N\)，输出 \((\theta,r,w)=(1,N^{-2},N^{-2})\)，所以三次样本测度的权重恰为 \(rw^2=N^{-6}\)。伴随原子范数下界给
\[
N^{-6}\sum|c|^3
\le P(\kappa,\eta)N^{10\kappa+\eta}
m(d)\mathcal K_\kappa(d)^{1/2}.
\]
初末标签都在固定有界域，故符合 \(m\le N\le m^B\)、位置大小至多 \(m^B\) 的同一固定复杂度类。后面球心可以任意远，是因为球心被放进数据的模调，而没有扩大这些标签。

### Kakeya 输入的准确版本

原文所引独立 Kakeya 固定版本的 Theorem 1.1 使用长度一、半径 \(\rho\)、体积 \(\pi\rho^2\) 的实心圆柱，以全部平移取上确界：
\[
K_\rho g(\omega)=\sup_a(\pi\rho^2)^{-1}
\int_{\mathcal T_\rho(a,\omega)}|g|,\qquad
\|K_\rho g\|_{L^3(S^2,d\sigma)}
\le M(s)\rho^{-s}\|g\|_3
\quad(\forall s>0,\ 0<\rho<1).
\]
与本篇 §4 的转述逐项一致，尤其不是仅有集合维数结论，亦不是仅对一个位置选取或高密度 shading 有效的估计。

该稿 §10 的 Proposition “Maximal reduction” 及一般函数归约已查，但其几何核心没有在本报告中完整核验。为闭合当前证明，本导读改用伴随球面 Corollary 1.3：球面有界输入估计经 Bourgain factorization 得全部 \(q>3\) 的球面对角估计，再由随机符号、加权管对偶与连续方向转换得到
\[
\|K_\rho g\|_3\lesssim_q
\rho^{-4(q-3)/(3(q-2))}\|g\|_3,\qquad 3<q<4.
\]
该链已逐式复核，包含所有管位置和球面面积测度，与上式完全同一接口。对这里使用的 \(0<s\le1\)，取 \(q=3+3s/8\)，损失为
\[
\frac{s}{2(1+3s/8)}<s/2<s.
\]
因此可选有限 \(M(s)\) 供以下所有步骤使用；其余 \(s>1\) 用 \(s=1\) 的界即可。球面 §§2–8 不调用本篇或独立 Kakeya 主定理，故替代没有循环。独立 Kakeya 几何核心不再是本导读结论的必要未决依赖；两条路线的最优常数及增长率不作比较。

## 关键推导二：独立重做密度分解

### 从最大算子到正管密度

因 \(\phi''\ge cI\)，速度 \(U_\nu\) 及单位方向 \((U_\nu,1)/\sqrt{1+|U_\nu|^2}\) 都有固定倍数的 \(\delta\) 分离。取互不交的小方向帽 \(\Omega_\nu\)，面积约 \(\delta^2\)。每根水平截面半径 \(\delta\)、时间长度一的斜管，可由固定数目的、半径 \(C\delta\) 的单位圆柱覆盖；这对 \(\Omega_\nu\) 内每个方向均成立。因此
\[
\int H_d|g|
\lesssim\sum_\nu b_\nu\int_{\Omega_\nu}K_{C\delta}g.
\]
在球面上 Hölder，再用上述 Kakeya 输入及 \(L^{3/2}\)-\(L^3\) 对偶，得到
\[
\int H_d^{3/2}
\lesssim M(s)^{3/2}\delta^{-3s/2}
\delta^2\sum_\nu b_\nu^{3/2}.
\]
位置求和不另收费，因为 \(K\) 已经对所有位置取上确界。取 \(N\) 大到 \(C\delta<1\) 后，\((C\delta)^{-s}\le\delta^{-s}\)，几何常数与 \(0<s\le1\) 无关。

### 一个椭圆测试怎样支付振荡成本

若坐标子数组 \(q\) 被 \(U_\nu\in u+E,\ z\in v+E\) 选中，\(0\le t\le1\) 时其管截面支撑在
\[
v+tu+E+tE+B(0,\delta)\subset v+tu+3E.
\]
所以时空支撑体积至多 \(9\pi La\)。由 \(\int H_q=\pi m(q)\) 以及 Hölder，
\[
\int H_q^{3/2}
\ge\frac{\pi}{3}\frac{m(q)^{3/2}}{\sqrt{La}}
\ge\frac{\pi}{3}m(q)\sqrt{\frac{m(q)}{W_\kappa(E)}}. \tag{1}
\]
末步方向正确，因为 \(W_\kappa(E)\ge La\)。这个核对同时覆盖极细长椭圆及两个独立平移，没有预设圆形、同心或有界偏心率。

### 为什么必须按“剩余容量”分组

令 \(D=\max|d_{\nu,z}|^2\)、\(n=\#\operatorname{supp}d\)。单点可用半径 \(\delta\) 的圆测试，且每个测试 \(W_\kappa\ge\delta^2\)，故
\[
D\le\mathcal K_\kappa(d)\le nD.
\]
原文取停止阈值 \(A=D/n^2\)。从剩余数组 \(r_j\) 选一个密度
\(\rho_j=m(q_j)/W_\kappa(E_j)\ge\mathcal K_\kappa(r_j)/2\) 的测试，删去它所选的所有非零坐标。此操作至多进行 \(n\) 次，不要求上确界达到。

把满足 \(\lambda\le\mathcal K_\kappa(r_j)<2\lambda\) 的删除束合成 \(d_\lambda\)。**原文已写出的关键补救**是：这个合并数组是该层第一次删除前的剩余数组的坐标限制，故
\[
\mathcal K_\kappa(d_\lambda)<2\lambda,\qquad \rho_j\ge\lambda/2.
\]
不是声称合并后容量等于各束容量之和。于是
\[
m(d_\lambda)\sqrt{\mathcal K_\kappa(d_\lambda)}
\le 2\sum_{j\text{ 在该层}}m(q_j)\sqrt{\rho_j}.
\]
利用 (1) 及非负数的 \(\sum H_{q_j}^{3/2}\le(\sum H_{q_j})^{3/2}\le H_d^{3/2}\)，主组成本之和有界。尾数组容量至多 \(A\)，成本至多
\(\delta^2nD\sqrt A=\delta^2D^{3/2}\)，由原来最大系数那根管支付。\(nD/A=n^3\) 给约 \(3\log_2n\) 个容量层。

这解释了为什么无需最小非零系数下界：即使一个坐标只有 \(10^{-100000}\)，它仍能留在一次付清的尾块中。由线性及 \(\ell^3\) 三角不等式，
\(\|\sum_{i=1}^Jc^{(i)}\|_3^3\le J^2\sum_i\|c^{(i)}\|_3^3\)；这正是后来 \(\log^2N\) 的来源。初始有 \(O(N^4)\) 个允许坐标，不会因为球心很远而增加。

综合得原文 Proposition 4.3：
\[
\sum|c|^3\lesssim N^6P(\kappa,\eta)M(s)^{3/2}
N^{10\kappa+\eta+3s/2}\log^2(2+N)\,
\delta^2\sum_\nu b_\nu^{3/2}. \tag{2}
\]

## 关键推导三：稀疏球必须共享同一个数据范数

原文 Proposition 5.1 假设 \(\|h\|_3\le1\)、\(0<\mu\le\mu_0\)，至多 \(\mu^{-8}\) 个半径 \(R\ge\mu^{-100}\) 的球，球心距至少 \(\mu^{-40}R\)。选二进 \(N\) 满足 \(4R\le N^2<16R\)。

### 小共振集合及粗糙数据

记球心为 \(x_B\)，置 \(a_B=x_B-(0,0,N^2/2)\)。两个平移之差 \(a_B-a_{\widetilde B}=(q,s_0)\)，长度为 \(H\)。其坏频率为
\[
\Omega_{B,\widetilde B}
=\{\xi\in Q_0:\ |q+s_0\nabla\phi(\xi)|\le H\mu^{20}\}.
\]
若非空，速度有界强迫 \(|s_0|\gtrsim H\)；速度映射的单调性继而给集合直径 \(O(\mu^{20})\)，面积 \(O(\mu^{40})\)。所有至多 \(\mu^{-16}\) 对球取并，得 \(\operatorname{area}\Omega\lesssim\mu^{24}\)。令 \(h_*=h{\bf1}_{Q_0\setminus\Omega}\)、\(F_*=E_\phi(h_*\chi_1^{\nu_*})\)，则
\[
\|F-F_*\|_\infty
\lesssim\|h\|_3(\operatorname{area}\Omega)^{2/3}
\lesssim\mu^{16}\le\mu/2. \tag{3}
\]
这里不能微分 \(h_*\)，因为它有尖锐截断。原文随后确实避免了这一陷阱。

### 联合 Gram 估计的三个尺度

令共同位移域为 \(\mathcal U=[0,D_{\rm f}^{-1})^2\times[0,1)\)，小频窗支撑为 \(\Gamma_\nu=\operatorname{supp}\chi_\delta^\nu\)。取固定紧邻域 \(Q_1\) 包含所有与 \(Q_0\) 相交的小频窗，并固定 \(Z>4(2+\sup_{Q_1}|\nabla\phi|)\)。对 \(u\in\mathcal U\)，定义
\[
\begin{aligned}
h_{B,u}(\xi)&=h_*(\xi)e\bigl((a_B+u)\cdot(\xi,\phi(\xi))\bigr),\\
d_{\nu,z}^{B,u}&=\int h_{B,u}(\xi)\chi_\delta^\nu(\xi)e(N^2z\cdot\xi)\,d\xi,
\quad z\in D_{\rm f}^{-1}\delta\mathbb Z^2,\\
b_\nu^{B,u}&=\sum_{|z|\le Z}|d_{\nu,z}^{B,u}|^2.
\end{aligned}
\]
即先将球平移和共同位移放进数据的模调，再在初始帧分析并截断空间标签。对每个小频窗，需证
\[
\sum_B b_\nu^{B,u}\lesssim
\delta^2\int_{\Gamma_\nu}|h_*|^2. \tag{4}
\]
只对满足 \(h_*\chi_\delta^\nu\ne0\) 的窗挑一个好点 \(\xi_g\)。**原文已写出的处理**是把分析算子定义在不受共振剔除限制的整个 \(L^2\) 上；其 \(TT^*\) 核的振幅遂为光滑的 \((\chi_\delta^\nu)^2\)，而不是带坏集合指示函数的振幅。

同球对角块由 Parseval 给算子范数 \(O(\delta^2)\)。异球核重标 \(\xi=\nu+\delta v\) 后，相位为
\[
\Psi(v)=(q+N^2(z-\widetilde z))\cdot(\nu+\delta v)
+s_0\phi(\nu+\delta v).
\]
令 \(v_0=(q+s_0\nabla\phi(\xi_g))/|q+s_0\nabla\phi(\xi_g)|\) 为好点处的单位梯度方向，则
\[
D_{v_0}\Psi\ge\tfrac12\Lambda,\quad
\Lambda=\delta H\mu^{20}\ge\tfrac1{16}N\mu^{-20},\qquad
|\partial^\alpha\Psi|\lesssim_\alpha H\delta^2\lesssim_\alpha\Lambda
\quad(|\alpha|\ge2).
\]
三项需同时检查：窗口变化相对损失 \(O(\delta\mu^{-20})=O(\mu^{30})\)；空间标签相对损失 \(O(N^2/(H\mu^{20}))=O(\mu^{20})\)；各高阶导数和下界都带同一个 \(H\)，所以常数不依赖最大球心距离。四次分部积分给每项 \(O(\delta^2N^{-4})\)。每行/列只有 \(O(\mu^{-8}N^2)\le O(N^3)\) 个异球项，Schur 估计即得 (4)。

再利用窗面积 \(O(\delta^2)\) 与有限重叠：
\[
\begin{aligned}
\delta^2\sum_{\nu,B}(b_\nu^{B,u})^{3/2}
&\le C\delta^5\sum_\nu
\left(\int_{\Gamma_\nu}|h_*|^2\right)^{3/2}\\
&\le C\delta^6\sum_\nu\int_{\Gamma_\nu}|h_*|^3
\lesssim\delta^6.
\end{aligned} \tag{5}
\]
这恰好抵消 (2) 的 \(N^6\)，而不是多付一个球数。

### 重构尾、连续积分及结论

全空间帧在 \(L^2\) 中精确重构，且全系数质量 \(O(\delta^2)\)。对被删去的 \(|z|>Z\)，输入到保留输出的矩阵元经分部积分有界于
\([N(1+|z|)]^{-k}\)。每个尾行的 \(\ell^2\) 范数至多 \(C_kN^{2-k}\)，乘全输入 \(\ell^2\) 范数 \(O(N^{-1})\)，取 \(k=4\) 得单个样本误差 \(O(N^{-3})\)。这个步骤只微分固定窗和相位，不微分数据或 (3) 的截断。

总样本数 \(O(\mu^{-8}N^6)\le O(N^7)\)，故误差立方总和为 \(O(N^{-2})\)。在同一个共同位移域 \(\mathcal U\) 积分，格点和精确变成半开小胞上的积分；这些胞覆盖对应球。结合 (3)、(5)、Chebyshev，得
\[
\operatorname{vol}\bigl(\{|F|>\mu\}\cap\bigcup B\bigr)
\lesssim \mu^{-3}P(\kappa,\eta)M(s)^{3/2}
N^{\gamma_0}\log^2(2+N),\qquad
\gamma_0=10\kappa+\eta+\tfrac32s. \tag{6}
\]
所有阈值都先按固定几何设置选定，之后才选小损失指数。粗糙 \(L^3\) 在这里没有靠未量化的光滑逼近，也没有先假设全局 \(L^p\) 有限。

## 关键推导四：去掉小幂损失，回到有边界曲面

基础估计由凸性与卷积推导给出
\[
\|E_\phi g\|_4\le(\pi/c)^{1/4}\|g\|_2,\qquad \phi''\ge cI.
\]
加上固定紧频率支撑，得到 \(\|F\|_4+\|F\|_\infty+\|\nabla F\|_\infty\lesssim\|h\|_3\)。原文由梯度界在每个高值点旁放半径 \(O(\mu)\) 的球，推出至多 \(C\mu^{-7}\) 个单位方块相交于 \(\{|F|>\mu\}\)。小 \(\mu\) 时其数至多 \(\mu^{-8}\)。

取每个被占方块的一个高值点组成有限集 \(X\)。令 \(\tau=p-3\in(0,1]\)、\(\beta=\tau/4\)、
\[
J=\lceil32/\tau\rceil+1,\qquad R_j=\mu^{-100(j+1)},\qquad
n_j(x)=\#(X\cap B(x,R_j)),
\]
其中 \(B(x,R_j)\) 均为开球。对每个点，总有一个 \(j<J\) 满足
\(n_{j+1}(x)\le\mu^{-\beta}n_j(x)\)：否则 \(J\) 次增长后点数超过 \(\mu^{-8}\)。按 \(j\) 和 \(n_j(x)\) 的二进大小分组，取互不交的 \(R_j\) 球，再以邻接图染色，得到至多
\[
3J(1+8\log_2(1/\mu))\mu^{-\tau/4}
\]
个满足 (6) 的球族；同色球半径 \(4R_j\)，间距至少 \(\mu^{-40}\) 倍半径。慢增长与计数作用于同一分组，因此邻居数确实受控。这个覆盖**没有水平集直径假设**。

对应尺度 \(N<8\mu^{-50J}\)。取
\(\kappa=\eta=s=\theta=10^{-6}\tau^2\)，则
\[
\gamma_0=\tfrac{25}{2}\theta,\qquad
50J\gamma_0\le\tfrac{17}{800}\tau<\tau/4.
\]
在上述覆盖上相加得到
\[
\operatorname{vol}\{|F|>\mu\}
\lesssim P(\theta,\theta)M(\theta)^{3/2}
J^3(1+\log(1/\mu))^3\mu^{-3-\tau/2}. \tag{7}
\]
一份 \(\mu^{-\tau/4}\) 来自染色，一份来自空间幂损失，不是直接把 \(N^\varepsilon\) 当成常数。

最后 layer cake 用 Tonelli，故即使尚不知左端有限也合法。小水平部分的积分为
\[
\int_0^1\mu^{-1+\tau/2}(1+\log(1/\mu))^3\,d\mu
=2/\tau+12/\tau^2+48/\tau^3+96/\tau^4
\le158\tau^{-4}.
\]
再乘 \(J^3\lesssim\tau^{-3}\)，得
\[
\|F\|_p\lesssim
\left[P(\theta,\theta)M(\theta)^{3/2}\tau^{-7}\right]^{1/p}\|h\|_3.
\]
固定小水平以上由 \(L^4\) 控制；\(p>4\) 直接用 \(L^4\) 与 \(L^\infty\)。由于输入定理没有给 \(P,M\) 在零处的增长率，不能把这个式子称为整体常数的多项式上界。

对曲面图 \(\Psi(\zeta)=v_0+L(\zeta,\phi(\zeta))\)，设 \(d\sigma=J_\Sigma(\zeta)d\zeta\)，实际放进图估计的是 \(g=f(\Psi)J_\Sigma\)，并在参数区域外置零。两个不能漏掉的因子为
\[
\|E_\Sigma f\|_p=|\det L|^{-1/p}\|E_\phi g\|_p,\qquad
\|g\|_3^3\le(\sup J_\Sigma)^2\int|f|^3\,d\sigma.
\]
边界图先在开邻域光滑延伸其几何，数据仍作可测零延拓；有界支撑保证 \(L^3\subset L^2\cap L^1\)。有限图表、有限频率窗以及
\(\|f\|_3\le\sigma(\Sigma)^{1/3-1/p}\|f\|_p\) 完成原定理。图表从未随 \(p\) 改选，故前述常数依赖仍一致。

原文 Proposition 6.5 的下界也可不靠 stationary phase 检查：对一个固定非零光滑图数据 \(g\)，横向 Plancherel 保持 \(\int|G(y',t)|^2dy'=\|g\|_2^2\)，二阶位置矩至多 \(C(1+t)^2\)。因此固定半径倍数的 \(O(1+t)\) 圆盘内保有至少一半 \(L^2\) 质量，Hölder 给
\(\int|G(y',t)|^pdy'\gtrsim(1+t)^{2-p}\)。对 \(t\ge0\) 积分得到
\[
C_{\Sigma,p}^{\rm best}\gtrsim_\Sigma(p-3)^{-1/p},
\qquad 3<p\le4.
\]
这同样说明 \(p=3\) 的强型版本不能从本文结论中补出；下界不依赖两个新稿输入。

## 两个推论的接口

**Schrödinger 局部光滑化。** 对紧抛物面除去表面积权重，得到 Lee–Rogers–Seeger 的 extension 规范
\(\mathcal Eg(\xi,\tau)=\int_{\|y\|\le1}g(y)e^{i(\tau\|y\|^2-\xi\cdot y)}dy\)。
已读 arXiv:1108.1518v2 的 Theorem 1.1：\(2\le p\le q<\infty\)、\(0<\nu\le2\) 时，\(R^*(p\to q)\) 等价于
\(U:B^p_{\alpha,\nu}\to L^q(\mathbb R^d\times I)\)，
\(\alpha=d(1-1/p-1/q)-2/q\)。
代入 \(d=2,q=p,\nu=2\)，恰为 \(\alpha=2-6/p\)；再由 \(s>\alpha\) 的几何级数嵌入得到 \(W^{s,p}\to L^p_{x,t}(\mathbb R^2\times[0,1])\)。原文没有误用端点 Sobolev 嵌入 \(W^{\alpha,p}\subset B^p_{\alpha,2}\)。同一来源的必要条件 Proposition 1.3(ii) 给 \(s\ge2-6/p\)；它不能把严格 \(s>\alpha\) 改成端点成立。

**平移不变 Bourgain 相位。** 原文 Corollary 7.1 要求
\(M=D_y^2\partial_t\psi\) 定号且 \(\partial_tM=c(t,y)M\)，\(\psi(0;y)=0\)。交换 Hessian 的三阶导数，再乘 \(M^{-1}\)，得到
\((\partial_kc)\delta_{i\ell}=(\partial_ic)\delta_{k\ell}\)。二维中对每个 \(k\) 选 \(i=\ell\ne k\)，故 \(c\) 与 \(y\) 无关。于是
\(\psi(t;y)=S(t)h(y)+B(t)\cdot y+D(t)\)，\(S'>0\)，输出变量变换即把相位拉直为固定椭圆图。这里的维数与 Hessian 可逆性都实际使用了。固定紧支撑振幅对输出变量作绝对可和 Fourier 展开，再应用全局延拓并缩放 \(z\mapsto Nz/(2\pi)\)，得到 \(N^{-3/p}\)，没有额外 \(N^\varepsilon\)。这段拉直在原文完整写出；无需把 Gao–Liu–Xi 的一般变换定理另当作未检前提。

## 核验结论

### 改进

**去掉覆盖的点数分层，显式端点因子 \(7/p\to6/p\)。** 原文 Lemma 6.3 先按尺度 \(j\)、再按局部点数 \(n_j(x)\) 的二进大小 \(k\) 分组，覆盖族数因而多出 \(1+8\log_2(1/\mu)\)。不必作第二次分组：

固定一个 \(j\)，在所有分配到该 \(j\) 的中心中，选出极大不交开球族 \(\{B(y,R_j):y\in Y_j\}\)。它仍以 \(B(y,4R_j)\) 覆盖这些中心对应的所有单位方块。邻接关系照旧取 \(\|x-y\|<R_{j+1}/2\)，但现在**按 \(n_j(y)\) 从大到小**排列顶点，依次贪心染色。

对当前顶点 \(x\)，每个已着色邻居 \(y\) 都满足 \(n_j(y)\ge n_j(x)\)。这些邻居的小球与 \(x\) 自己的小球两两不交；由 \(R_j<R_{j+1}/2\)，它们全部在 \(B(x,R_{j+1})\) 内。由慢增长，
\[
\bigl(1+\#\{\text{已着色邻居}\}\bigr)n_j(x)
\le n_{j+1}(x)\le\mu^{-\beta}n_j(x).
\]
故颜色数至多 \(\lfloor\mu^{-\beta}\rfloor\)；使用较宽松的 \(2\mu^{-\beta}\) 个颜色当然也足够。不同颜色可以重叠，但同一颜色仍具有原文要求的远距分离。全部 \(j\) 只需至多 \(2J\mu^{-\beta}\) 个稀疏球族，不需要按 \(k\) 分层。这里点数 \(n_j\) 仍统计同一个原集合 \(X\)，而非只统计分配到 \(j\) 的中心，保证上述计数方向正确。

保持原文 \(J,\theta,\gamma_0\) 及两个输入常数不变，(7) 的改进版是
\[
\operatorname{vol}\{|F|>\mu\}
\lesssim P(\theta,\theta)M(\theta)^{3/2}
J^3(1+\log(1/\mu))^2\mu^{-3-\tau/2}.
\]
这时积分变成
\[
\int_0^1\mu^{-1+\tau/2}(1+\log(1/\mu))^2\,d\mu
=2/\tau+8/\tau^2+16/\tau^3\le26\tau^{-3}.
\]
记 \(P_\Sigma(\kappa,\eta)\) 为有限图表及频率窗设置中 packet 常数的最大值，并增大到至少一。因此得到更强的、同一规范下的表面常数界
\[
C_{\Sigma,p}^{\rm best}
\le C(\Sigma)(p-3)^{-6/p}
P_\Sigma(\theta,\theta)^{1/p}M(\theta)^{3/(2p)},
\quad \theta=10^{-6}(p-3)^2,\quad3<p\le4. \tag{8}
\]
改的是原文明确展示的基本覆盖损失，不是未知 \(P,M\) 的增长率，也未改变限制猜想的指数范围。上述染色论证已获独立手算复核；精确脚本穷举 37,952 个正整权有限图，并拒绝中心权重二、三个叶权重一的星图上故意采用的升序顺序：这时中心有三个已染邻居，所需计数不变量失效。

**经典采样机制前移，初始方块数 \(C\mu^{-7}\to C\mu^{-4}\)。** 设 \(Q_k=k+[0,1)^3\)，\(F\) 的 Fourier 支集在固定紧集 \(K\)。取 Schwartz 核 \(\eta\)，使 \(\widehat\eta=1\) 于 \(K\) 的开邻域。本文的粗糙数据 \(g=h\chi_1^{\nu_*}\in L^1\) 定义有限图面测度 \(\lambda\)，故绝对 Fubini（界为 \(\|\eta\|_1\|\lambda\|_{\rm TV}\)）逐点给 \(F=\eta*F\)。加权 Hölder 给 \(|F(x)|^4\le\|\eta\|_1^3\int|\eta(x-y)||F(y)|^4dy\)；令 \(S_\eta=\sup_y\sum_k\sup_{x\in Q_k}|\eta(x-y)|<\infty\)，其有限性来自阶数大于三的 Schwartz 衰减。逐格取上确界再用 Tonelli，便有 \(\sum_k\sup_{Q_k}|F|^4\le\|\eta\|_1^3S_\eta\|F\|_4^4\)。原文基础 \(L^4\) 界于是给 \(\#\{Q_k:Q_k\cap\{|F|>\mu\}\ne\varnothing\}\le D\mu^{-4}\)，其中 \(D\) 只依固定频率集及基础常数；不要求半开格的上确界达到或选点分离。当 \(\mu\le D^{-1}\)，可用 \(\#X\le\mu^{-5}\)，从而取 \(J=\lceil20/\tau\rceil+1\le22/\tau\)，保留原 \(\beta,\theta\) 和稀疏球接口；它与递减点数染色独立且兼容，进一步缩短 \(J\)，但不再改变 \(\tau^{-6}\) 次数，也未证明 \(\mu^{-4}\) 最优。经典先例为 Heil（2003），*An Introduction to Weighted Wiener Amalgams*，Corollary 11.8.4，p.210 的 \(L^p*W(L^\infty,L^1)\subset W(L^\infty,L^p)\)，同页说明适用于阿贝尔群；原件为 `evidence/diagonal/sources/heil-amalgam-2003.pdf`。伴随篇 §8 已使用三次方再生核；这里将该机制前移到初始四次方计数，推导已获独立手算复核。

**容量分解的有效支撑数细化。** 原文 Lemma 4.2 用 \(A=D/n^2\)，得到至多 \(2+\lfloor3\log_2n\rfloor\) 个块。保持它的删除和分组算法不变，令
\[
S=\sum|d|^2,\qquad T=\sum|d|^3,\qquad
A=(T/S)^2,\qquad n_{\rm eff}=S^3/T^2.
\]
这里先处理非零数组；零数组取空分解、总成本为零，不定义 \(T/S\) 或 \(n_{\rm eff}\)。非零时 \(1\le n_{\rm eff}\le n\)（后一式是 Hölder）。当尾数组 \(r\) 的容量不超过 \(A\)，
\[
m(r)\sqrt{\mathcal K_\kappa(r)}
\le\delta^2S\sqrt A=\delta^2T
\le\pi^{-1}\int H_d^{3/2}.
\]
最后一步来自逐点 \(\sum(|d|^2{\bf1}_T)^{3/2}\le H_d^{3/2}\)，不需要一个最大系数独自支付尾块。又 \(\mathcal K_\kappa(d)\le S\)，所以容量层范围比至多 \(S/A=n_{\rm eff}\)，给出
\[
J\le2+\lfloor\log_2n_{\rm eff}\rfloor\le2+\lfloor\log_2n\rfloor,
\qquad
\sum_i m(d^{(i)})\sqrt{\mathcal K_\kappa(d^{(i)})}
\le\frac7\pi\int H_d^{3/2}. \tag{9}
\]
其中主组常数 \(6/\pi\) 来自 (1) 和分组因子二，尾块再加 \(1/\pi\)。这是对原证明的定量细化，不是去掉对数损失，也不宣称新的 restriction 指数。等模 \(n\) 个系数时 \(n_{\rm eff}=n\)；一个大系数加许多极小系数时它可接近一，明显优于原来只数非零项的界。

手工证明如上；`evidence/diagonal/verify_diagonal.py` 还以 `Fraction` 在 4,096 个六坐标有理数组及一个有限测试集合中重做删除、分组、尾块及有效支撑界，拒绝缺少覆盖坐标的单位权测试、非法测试权重及非法对数范围。连同上述错误染色顺序，共四个拒绝测试；计算范围是有限代数模型与尺度算术。

### 错误与不足

未确认本篇数学错误或满足全部原假设的反例。已检查上确界未取到、极小系数、共振集不光滑、任意远球心、覆盖边界、Tonelli 的使用及边界数据的可测零延拓；原文均有相应处理。采用上述球面推论替代路线后，主结论不再保留未审完的 Kakeya 几何接口；文献依赖仍如开头所列。

### 已核验内容

已逐段读本篇全部正文、图示及参考文献；手工重做相位插入、帧规范、正管对偶、容量删除分组、稀疏球联合 Gram 估计和尾重构、慢增长覆盖、指数预算、layer cake、曲面双 Jacobian、端点下界及两个推论的直接计算。伴随数组定理的完整论证及替代最大算子输入均已独立复核，故主 Theorem 1.1 在所列三项文献输入下接通。精确脚本确认 \(\mu^{24}\to\mu^{16}\)、\(N^6\delta^6=1\)、误差总量 \(N^{-2}\)、\(50J\gamma_0\) 预算、原文积分系数 \(2,12,48,96\) 和改进后的 \(2,8,16\)；这些是计算核对，不是形式化解析证明。

**Gaussian 确认抛物面常数最优，而非改进。** 对 \(\phi(\xi)=c|\xi|^2/2\)、\(g_a(\xi)=e^{-a|\xi|^2}\)，本文的 \(2\pi\) 规范与底坐标 Lebesgue 测度给 \(E_cg_a(x,t)=\pi(a-i\pi ct)^{-1}\exp[-\pi^2|x|^2/(a-i\pi ct)]\)，因而 \(\|g_a\|_2^2=\pi/(2a)\)、\(\|E_cg_a\|_4^4=\pi^3/(4ca^2)=(\pi/c)\|g_a\|_2^4\)。完整 Gaussian 不紧支撑：先由紧支撑数据的稠密性将原 \(L^2\to L^4\) 界延拓至全 \(L^2\)，对 \(L^1\cap L^2\) 数据再由截断的 \(L^1\) 收敛识别积分定义。若固定紧域 \(\Omega\) 含 \(B(\xi_0,r)\)，集中 Gaussian \(g_{a,\Omega}=e^{-a|\xi-\xi_0|^2}{\bf1}_\Omega\) 的相对 \(L^2\) 尾误差至多 \(e^{-ar^2}\)；平移的完整 Gaussian 只引入体积保持的时空剪切，故令 \(S=(\pi/c)^{1/4}\)，有 \(S(1-e^{-ar^2})\le\|E_cg_{a,\Omega}\|_4/\|g_{a,\Omega}\|_2\le S\)。这确认原 Lemma 6.1 在抛物面及仅依 \(c\) 的统一估计中的 sharpness，不是每个一般相位或固定窗 \(L^3\) 常数的最优性结论。精确积分已获独立手算复核，并与 Foschi，JEMS 9 (2007), 739–774，Theorem 1.1（p.740）的 \(e^{-is\Delta}:L^2\to L^4\) 最优常数 \(2^{-1/2}\) 一致：取本文规范下的 \(f=\check g\)，有 \(E_cg(x,t)=(e^{-is\Delta}f)(x)\)、\(s=ct/(4\pi)\)，所以 \((4\pi/c)^{1/4}2^{-1/2}=S\)。定理及 §2 的规范原页见 `evidence/diagonal/sources/foschi-2007.pdf`，DOI `10.4171/JEMS/95`。

来源复查入口是主篇 §4 的容量分解、§5 的联合稀疏球估计，以及伴随导读的完整几何证明和 §9 球面推论。原文所引 Kakeya 稿的固定提交、原路径和逐文件 Git blob 记录在 `evidence/diagonal/sources/kakeya/source-metadata.json`。

| Claim | Source | Basis | Evidence |
|---|---|---|---|
| 任意紧光滑正曲率曲面的全部有限 \(p>3\) 对角延拓界 | 原文 Theorem 1.1；本导读替换最大算子输入 | conditional on a cited result (Ren–Wang 2308.08819v2, Theorem 4.1; Bourgain–Demeter 1403.5335v3, Theorem 1.1; Bourgain sphere factorization, Buschenhenke 2106.02587v2 §1.1) | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/00-introduction.tex`; `guide/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026.md` |
| 一般椭圆图 germ 插入允许 continuation，且标签可用过渡区 | 原文 Lemma 3.1；伴随 §6.1 | checked by hand | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/02-packets.tex`; `paper/Elliptic-capacity-propagation-and-Fourier-restriction-to-the-sphere-September-24-2026/build/sections/05-packets.tex` |
| 精确帧、原子三次下界及 \(m=N\) 时 \(N^{-6}\) 规范 | 原文 Lemmas 3.2–3.3、Theorem 3.4 的专门化 | checked by hand | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/02-packets.tex` |
| 任意复数组与坐标筛选的完整 packet 传播估计 | 伴随 Theorem 6.4 | conditional on a cited result (Ren–Wang 2308.08819v2, Theorem 4.1; Bourgain–Demeter 1403.5335v3, Theorem 1.1) | `guide/Elliptic-capacity-propagation-and-Fourier-restriction-to-the-sphere-September-24-2026.md`; `paper/Elliptic-capacity-propagation-and-Fourier-restriction-to-the-sphere-September-24-2026/build/sections/06-extremal.tex` |
| Kakeya 原始 Theorem 1.1 的量词、测度、体积和本篇调用一致 | Kakeya 新稿，pinned 2026-09-23 版 | checked by hand | `evidence/diagonal/sources/kakeya/introduction.tex`; `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/03-density.tex` |
| 全部平移、连续方向的完整 L3 最大算子输入；替代路线无循环 | 伴随球面 Corollary 1.3；本导读替换原文输入来源 | conditional on a cited result (Ren–Wang 2308.08819v2, Theorem 4.1; Bourgain–Demeter 1403.5335v3, Theorem 1.1; Bourgain sphere factorization, Buschenhenke 2106.02587v2 §1.1) | `guide/Elliptic-capacity-propagation-and-Fourier-restriction-to-the-sphere-September-24-2026.md`，§9；`paper/Elliptic-capacity-propagation-and-Fourier-restriction-to-the-sphere-September-24-2026/build/sections/08-consequences.tex` |
| 正管 \(L^{3/2}\) 界从完整最大算子界推出 | 原文 Lemma 4.1；本导读改用球面推论输入 | conditional on a cited result (sphere Corollary 1.3 via Ren–Wang, Bourgain–Demeter and Bourgain sphere factorization) | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/03-density.tex`；本导读“关键推导一” |
| 容量分解适用于任意系数尺度，含尾块与未达到的上确界 | 原文 Lemma 4.2 | checked by hand | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/03-density.tex` |
| 按局部点数递减染色，无需二进点数分组，覆盖族数至多 \(2J\mu^{-\beta}\) | 本导读对 Lemma 6.3 的改进 | checked by hand | `guide/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026.md` |
| 固定 Fourier 支集的四次方局部上确界可求和，初始峰格数 \(C\mu^{-7}\to C\mu^{-4}\)，涵盖粗糙数据 | 本导读对 Lemma 6.2 的改进；经典再生核采样机制 | checked by hand | `guide/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026.md` |
| 峰数改进可使 \(J=\lceil20/\tau\rceil+1\le22/\tau\)，不改变染色后的 \(\tau^{-6}\) 次数 | 本导读“经典采样机制前移” | checked by hand | `guide/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026.md` |
| 同一 \(P,M,\theta\) 下，显式表面常数因子 \(7/p\to6/p\) | 本导读式 (8) | conditional on a cited result (packet Theorem 6.4; sphere Corollary 1.3 via Ren–Wang, Bourgain–Demeter and Bourgain sphere factorization) | `guide/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026.md` |
| 分组数细化为 \(2+\lfloor\log_2(S^3/T^2)\rfloor\)，成本常数可取 \(7/\pi\) | 本导读式 (9)，原证明的细化 | checked by hand | `guide/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026.md` |
| 4,096 个有理数组、37,952 个加权图、拒绝测试及尺度预算 | 本次有限核对 | checked by computation | `evidence/diagonal/verify_diagonal.py` |
| 离散估计的 \(\log^2N\)、\(N^6\) 及损失指数 | 原文 Proposition 4.3 | conditional on a cited result (packet Theorem 6.4; sphere Corollary 1.3 via Ren–Wang, Bourgain–Demeter and Bourgain sphere factorization) | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/03-density.tex` |
| 共振剔除、联合 Gram 界、尾样本 \(O(N^{-3})\)、共同位移填球 | 原文 Proposition 5.1 中的解析归约 | checked by hand | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/04-sparse.tex` |
| 粗糙 \(L^3\) 的稀疏球估计及图 \(L^3\to L^p\) | 原文 Proposition 5.1、Theorem 6.4 | conditional on a cited result (packet Theorem 6.4; sphere Corollary 1.3 via Ren–Wang, Bourgain–Demeter and Bourgain sphere factorization) | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/04-sparse.tex`; `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/05-global.tex` |
| \(L^4\) 基础界、有限占据、无直径假设覆盖、端点常数下界 | 原文 Lemmas 6.1–6.3、Proposition 6.5 | checked by hand | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/05-global.tex` |
| 抛物面 Gaussian 精确给出 \((\pi/c)^{1/4}\)，固定紧域中截断可逼近该 \(L^2\to L^4\) 常数 | 本导读的直接积分，确认 Lemma 6.1 常数最优 | checked by hand | `guide/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026.md` |
| 经典 Wiener-amalgam 卷积先例及 sharp Strichartz 常数换算，与上述手算一致 | Heil (2003), Corollary 11.8.4；Foschi (2007), Theorem 1.1 | checked by hand | `evidence/diagonal/sources/heil-amalgam-2003.pdf`; `evidence/diagonal/sources/foschi-2007.pdf`; `guide/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026.md` |
| 双 Jacobian、可测零延拓、有限图表以及 \(L^p\subset L^3\) 的传递 | 原文 §7.1 | checked by hand | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/06-surfaces.tex` |
| 对角 \(p>22/7\) 的准确既有比较范围，允许边界 | Wang–Wu, arXiv:2411.08871v3, Theorem 0.2 | checked by hand | `evidence/diagonal/sources/main.tex`; `evidence/diagonal/sources/arxiv-2411.08871v3.pdf` |
| 已发表的 \(p>13/4\) 比较是有界数据输入，非同一对角命题 | Guth, JAMS 2016；arXiv:1407.1916v3, Theorem 0.1 | checked by hand | `evidence/diagonal/sources/arxiv-1407.1916v3.pdf` |
| 局部光滑化 transfer 的参数及严格 Sobolev 嵌入适用 | Lee–Rogers–Seeger, arXiv:1108.1518v2, Theorem 1.1；原文 §7.2 | checked by hand | `evidence/diagonal/sources/lee_rogers_seeger_JMPA_rev_final.tex`; `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/06-surfaces.tex` |
| \(W^{s,p}\to L^p_{x,t}\)，\(s>2-6/p,\ p>3\) | 原文 Corollary 1.2 | conditional on a cited result (main extension bound; Lee–Rogers–Seeger Theorem 1.1) | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/06-surfaces.tex`; `evidence/diagonal/sources/lee_rogers_seeger_JMPA_rev_final.tex` |
| Bourgain 相位的 Hessian 兼容性、输出拉直及振幅展开 | 原文 Corollary 7.1 的直接归约 | checked by hand | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/06-surfaces.tex` |
| Bourgain 相位的全部 \(p>3\)、\(N^{-3/p}\) 估计 | 原文 Corollary 7.1 | conditional on a cited result (main extension bound) | `paper/Diagonal-Fourier-extension-for-positively-curved-surfaces-in-three-dimensions-September-24-2026/build/sections/06-surfaces.tex` |
