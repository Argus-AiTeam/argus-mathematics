# QAOA 先热力学、后深度极限达到 SK 基态值：中文导读与核验

**结论：主证明的标量桥接、量子编译及最后迁移通过了下述逐段手算核验，保留所列 Parisi、满支撑及固定电路迁移定理的文献依赖。** 难点是先把近最优的经典随机计算编译成一个完整、有限的普通 QAOA 电路，再取系统规模极限。承重的辅助自旋收缩与种子移除另经独立逐式复核。

**固定来源。** OpenAI，2026-09-25，*QAOA attains the SK ground-state energy in the thermodynamic-first limit*；使用 `openai/math` 提交 `4eaee87548250b2682affda7d05d947c05554bae` 的本地正文 `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/main.tex`、`sections/01` 至 `08` 及 `references.tex`。下文的“§7”是正则图 MaxCut，文件名却是 `08-regular-maxcut.tex`；正温路线在附录 A，文件名是 `07-positive-temperature.tex`。引用版本和外部证据见第 10 节。

## 1. 精确主张：哪些极限，什么意义的最优？

引言 Theorem 1.1 使用独立标准实高斯 \(J_{ij}\)，正号、最大化约定
\[
H_{n,J}(\sigma)=n^{-1/2}\sum_{i<j}J_{ij}\sigma_i\sigma_j,\qquad
C_{n,J}=n^{-1/2}\sum_{i<j}J_{ij}Z_iZ_j,\qquad B_n=\sum_iX_i.
\]
\[
P_*=\lim_{n\to\infty}\frac1n\mathbb E\max_{\sigma\in\{-1,1\}^n}H_{n,J}(\sigma).
\]
“基态”在这里是这个正的最优值，不是同一正号哈密顿量的最小能量。文献常用负号最小化，数值比较时必须换号。

从 \(|+\rangle^{\otimes n}\) 出发，按右边先作用的顺序定义
\[
\psi_{n,p,J}=e^{-i\beta_pB_n}e^{-i\gamma_pC_{n,J}}
\cdots e^{-i\beta_1B_n}e^{-i\gamma_1C_{n,J}}|+\rangle^{\otimes n},
\]
\[
v_p(\gamma,\beta)=\lim_{n\to\infty}n^{-1}\mathbb E_J
\langle\psi_{n,p,J},C_{n,J}\psi_{n,p,J}\rangle,\qquad
Q_p=\sup_{\gamma,\beta\in\mathbb R^p}v_p(\gamma,\beta).
\]
其中 \(e^{-i\gamma C}\) 称为代价门（cost），\(e^{-i\beta B}\) 称为混合门（mixer）。
每个 \(v_p\) 的极限中，\(p,\gamma,\beta\) 均已固定，角度不依赖 \(n,J\)。主张是
\[
\boxed{\lim_{p\to\infty}Q_p=P_*},
\quad\text{即}\quad
\forall\varepsilon>0\ \exists p<\infty,\gamma,\beta\
:\ v_p(\gamma,\beta)\ge P_*-\varepsilon.
\]
上界来自测量所得分布的平均不超过最大值；补一个零角度层说明 \(Q_{p+1}\ge Q_p\)。因此只需构造上述下界。这里取 supremum，不要求最优角度实际取到。

这**不**包含深度 \(p(\varepsilon)\) 的上界、角度求解的有效算法、有限 \(n\) 误差率、角度大小或精度的资源界，也不允许把 \(p,n\) 一起趋于无穷。最终门序列允许负角度、零角度和很大但已固定的角度。固定实例上的绝热/QAOA 完备性不够：其中的深度可以依赖实例和规模，量词不同。

归一化也不可省略。令 \(R=n^{-1}\sum_i\sigma_i\tau_i\)，则
\[
\mathbb E H_n(\sigma)H_n(\tau)=\frac n2R^2-\frac12.
\]
加上所有构型共用、方差 \(1/2\) 的独立零均值高斯，就得到 \(n\xi(R)\)、\(\xi(t)=t^2/2\)，且不改变期望最大值。这正是标量 Parisi 公式的约定。

## 2. 十五分钟主线：先找经典目标，再编译，最后迁移

核心是把一个近最优的**有限经典计算**编译成量子门序列（word）。只含代价门和混合门的称为**普通门序列**；中途允许额外高斯纵场的称为**带种子门序列**。种子是每个顶点的独立标准高斯标签，同一组标签在整个电路中复用，最后必须移除这种额外控制。三个空间承担不同工作：标量扩散负责选目标；无限度有根/Fock 空间负责比较目标和电路；有限 \(n\) SK 只在最后通过固定电路迁移定理进入。

两个操作术语贯穿证明。**切边分析**是删开一条边，把父端的影响改写为子树根的有限个边界输入；**既定前后电路**是待替换操作之前和之后已经选定的有限门序列。近似必须在这整个电路中有效，而不只是对新初始化的真空态有效。

| 正文位置 | 输入 → 输出 | 真正承担的工作 |
|---|---|---|
| §2 | 固定门序列、排除反馈的计算 → 有根插入向量 \(v\) | 加权收敛、边相关公式 \(\mathcal E(v)=\operatorname{Re}\langle v,\mathsf Lv\rangle\) |
| §3 | 伴篇标量扩散 → 有限高斯函数 \(F_N\) → 有界、带类型排除的角度公式 | 正交递推实现独立高斯，精确匹配一粒子能量；截断、三角逼近、颜色排除 |
| §4 | 有界经典公式 → 有限带种子门序列 | 辅助自旋的折返路径收缩；在既定前后电路中控制替换 |
| §5 | 已固定的带种子门序列 → 有限普通门序列 | 小振幅/大位移、选择性旋转、回波消去，复用同一个外部高斯种子 |
| §6 | 逐项误差已固定 → 主定理 | 此时才从树迁移到 SK；不交换任何构造极限 |
| §7 | 同一个普通门序列 → 正则图 MaxCut | 局部依赖邻域（光锥）、度缩放、随机正则最优值 |
| 附录 A | 正温 Parisi 测度 → 另一个近最优经典公式 | 不用零温伴篇，但仍要使用 §2、§3 的逼近及 §§4–5 的量子编译 |

第一遍可跳过 §2 的算子域证明、§4 的逐切边估计和附录 A，先读 §3 的能量恒等式与 §6。第二遍检查下面第 4–8 节：输出分布如何决定能量、门替换如何作用于前后电路，以及为什么内积矩阵（Gram 矩阵）收敛还须补一粒子能量计算。

## 3. 符号与最小手算例

| 符号 | 含义 |
|---|---|
| \(n,D+1,p\) | SK 自旋数、树的度、普通 QAOA 轮数 |
| \(\gamma(t)\) / \(\gamma_j\) | 标量 Parisi 系数 / 代价角度；不是同一对象 |
| \(\beta_0\) / \(\beta_j\) | 逆温度 / 混合角度 |
| \(\Omega,\omega=\lvert+\rangle\otimes1\) | Fock 真空、局部指定真空向量 |
| \(\mathcal H^\circ\) | 与真空正交的中心化（centered）空间 |
| \(q(f)=a^*(f)+a(f)\) | 方差为 \(\|f\|^2\) 的高斯位置算子；不是方差 \(2\|f\|^2\) |
| \(\mathsf L f=\omega\otimes a^*(f)\Omega\) | 把一个中心化有根向量作为新根的一粒子孩子 |
| \(\mathcal E(f)\) | \(\operatorname{Re}\langle f,\mathsf Lf\rangle\)；是能量，不是 \(\|f\|^2\) |
| \(W_h\) / \(N_{\rm top}\) | 控制各层种子矩和激发数（occupation）的递归权 / §5 仅最上层的粒子数 |
| \(A_{RS},p_H\) | 从类型 \(S\) 向 \(R\) 的 \(D^{-1/2}\) 聚合 / 辅助类型总概率 |

### 手算一：为什么必须关心一粒子分量？

取根种子 \(S\sim N(0,1)\)，\(\|S\|=1\)。新根上的 \(Z_1=q(S)\) 独立于新根种子 \(S\)。若只取 \(f=Z_1\)，则 \(\mathsf L^*f=S\)，但
\[
\mathcal E(f)=\langle S,Z_1\rangle=0.
\]
方差为一的随机输出并不自动有正能量。反之取 \(f=(S+Z_1)/\sqrt2\)，则 \(\|f\|=1\)、\(\mathsf L^*f=S/\sqrt2\)，所以 \(\mathcal E(f)=1/2\)。这个不有界的玩具例只解释根移位算子，不是可行的 \(\pm1\) 算法。

### 手算二：\(p=1\) 的全部因子和文献数值

在无三角形的 \((D+1)\)-正则树，正代价的一层边相关为
\[
r_1^+(D)=\sin(4\beta)\sin(2\gamma/\sqrt D)
              \cos(2\gamma/\sqrt D)^D.
\]
两个 \(ZY\) 交叉项给出 \(\sin4\beta\)；指定边给出一个正弦因子，其余每个端点的 \(D\) 条边给出余弦因子。\(YY\) 项在树上无可配对的共同邻点，期望为零。因此
\[
v_1=\lim_D\frac{\sqrt D}{2}r_1^+
  =\gamma\sin4\beta\,e^{-2\gamma^2}.
\]
取 \(\gamma=1/2,\beta=\pi/8\)，得到 \(Q_1=1/(2\sqrt e)=0.3032653299\ldots\)，与 BFMVZ v3 Table 1 的 \(0.3033\) 一致。其 Table 2 的 \(p=20\) 下界是 \(0.6879\)，而文献通常数值报告 \(P_*\simeq0.763166\)。本论文证明“最终逼近”，**没有**计算一个超过 \(0.6879\) 的新可用参数组，亦没有把这些小数变成严格的 Parisi 常数证书。

`python3 guide/evidence/qaoa/diagnostics.py` 直接在有限光锥上施加对角代价门与全部单自旋混合门，数值检查了 \(D=1,2,3,4\) 的 12 个角度组；翻转符号和漏/多一个因子 2 的 36 个负对照均拒绝。它只检验门约定和有限公式的浮点一致性，不证明无限度极限；显示结果保存在 `guide/evidence/qaoa/diagnostics.json`。

## 4. §2：边能量为何是一个连续二次型？

递归空间是
\[
\mathcal H_0=\mathbb C^2\otimes L^2(S),\qquad
\mathcal H_{h+1}=(\mathbb C^2\otimes L^2(S))
                       \otimes\Gamma_s(\mathcal H_h^\circ).
\]
这里 \(S\) 是局部种子的概率空间，\(\Gamma_s\) 表示对称 Fock 空间。有限树的 \(D\) 个对称孩子按“非真空孩子数”嵌入其 \(0,\ldots,D\) 粒子层。粒子不是物理自旋；一个粒子携带整个孩子的有根子树态。空后代嵌入使不同高度的同一公式可以在一个空间中比较。

对根可观测量 \(P\)，把全树电路写成 \(U=(\bigotimes_jU_j)u\)，其中 \(U_j\) 是各孩子完整子树上的电路，\(u\) 是分离它们之后的根映射。插入向量是 \(v_P=u^*Pu\Omega\)。在一条边两端放同一 \(Z\)-插入，二者的内积正是该边 \(\langle Z_iZ_j\rangle\)。根移位 \(\mathsf L\) 在中心化空间上等距，并以 \(\mathsf L\Omega=0\) 延拓至全空间。

命题“Energy as a root shift”的有限度分解是关键。其向量须与真空正交、具有有限半径，并在每个顶点交换完整孩子子树（包括种子坐标）时不变。令 \(M=D+1\)，\(N_M\) 计根的非真空孩子，\(R_M\) 删除一个指定真空孩子，\(J_M^*\) 抽取新根真空的一粒子分量，则
\[
R_M=\sqrt{1-N_M/M},\qquad
\|R_Mf-f\|^2\le M^{-1}\langle f,N_Mf\rangle,
\]
\[
\langle f_i,f_j\rangle
=\frac2{\sqrt M}\operatorname{Re}\langle J_M^*f,R_Mf\rangle
       +\varepsilon_D,\qquad
|\varepsilon_D|\le\frac{\langle f,N_Mf\rangle}{M}.
\]
两边都是真空的项因中心化消失；仅一侧跨边激发的两个项产生实部和因子 2；两侧均激发才是余项。因此，在同一固定有限高度的激发数嵌入下，**强收敛加统一激发数一阶矩界**给出
\[
\lim_D\frac{\sqrt D}{2}\langle f_i,f_j\rangle
=\mathcal E(f),\qquad
|\mathcal E(f)-\mathcal E(g)|\le(\|f\|+\|g\|)\|f-g\|.
\]
单独 \(L^2\) 强收敛不控制被 \(\sqrt D\) 放大的余项。论文明确列出了此假设，后续门演算负责验证。

### 为什么还需要那么长的加权门演算？

基本门（含临时纵场）的极限根映射更新很短：
\[
u\mapsto e^{-i\beta X}u,\qquad
u\mapsto e^{-itZq(v_Z)}u,\qquad
u\mapsto e^{-itZs}u.
\]
难点是后面要把不有界的聚合场代入门参数，并把近似门插入既定前后电路。论文的图范数 \(\|\xi\|_m=\|W_h^m\xi\|\) 同时控制粒子和种子矩：\(W_h\ge1\) 由局部种子权与孩子激发的递归权组成。对算子、伴随及参数导数均给统一界。高范数有界加低范数收敛，再通过谱截断提升到所需的中间图范数。常数可以依赖已经固定的公式、门序列长度和角度。

两个不能跳过的机制：

* **酉算子中心极限定理的二阶相位。** 对中心化自伴算子 \(T\)，\(D^{-1/2}\sum T^{(j)}\) 的极限是 \(q(T\Omega)\)。但设参数化酉算子 \(K(0)=1\)，记 \(\partial_\alpha K(0)=iT_\alpha\)、\(K_{\alpha\lambda}=\partial_\alpha\partial_\lambda K(0)\)，则 \(K(a/\sqrt D)^{\otimes D}\) 的指数中还保留
  \[
  \frac12\sum_{\alpha,\lambda}a_\alpha a_\lambda
  \left\langle K_{\alpha\lambda}
     +\tfrac12\{T_\alpha,T_\lambda\}\right\rangle_0.
  \]
  其中 \(\langle\cdot\rangle_0=\langle\Omega,(\cdot)\Omega\rangle\)。它为纯虚标量；控制变量代入后却可能是控制代数中的非平凡算子。只记一阶高斯场会漏项。对单一固定可观测量的指数，二阶校正才恰好为零。
* **共同交换代数，而非独立性。** 交换控制的光滑代入引理用联合谱演算和带衰减 Fourier 积分，不逆转协方差矩阵，因此允许退化、相关的场。切边时以 \(y\) 表示父端边界输入、\(m(y)\) 表示根向孩子发出的消息列表、\(V(y)\) 表示根上的门矩阵。向下保留 \(d\) 层受影响门的余因子为 \(E^{[d]}\)，相对零边界操作的比值为 \(K^{[d]}\)：
  \[
  E^{[d]}(y)=V(y)\prod_jK_j^{[d-1]}(D^{-1/2}m(y)),\quad
  K^{[d]}(y)=u^*E^{[d]}(0)^*E^{[d]}(y)u.
  \]
  \(m(0)\) 和 \(E(0)\) 一般非零；不能用“删掉父亲后没有东西”代替它们。

排除反馈的受控门要求：被旋转的目标类型不出现在自身跨边参数的依赖中；所有参数属于同一个交换控制代数。由此才能证明切边操作比值与待代入参数的谱投影交换，即使参数读取了同一孩子分支。正文“Smooth gate calculus”定理由有限影响层数的上述递推，得到根映射、伴随、插入和能量的连续性。对局部种子系数有界的列向量 \(c\)，还有条件估计 \(\|W^m1_Rc\|\le C_m\sqrt{\Pr(R)}\)，其中 \(R\) 是根种子事件；这是辅助类型细分真正需要的尺度。

一个可手算的二阶相位例子可帮助记住第一点：取单自旋真空 \(|+\rangle\)，\(K(x)=e^{ixY}e^{ixZ}\)。此时 \(T=Y+Z\)、\(K''(0)=-2I-2iX\)、\(T^2=2I\)，校正为 \(\frac12\langle K''+T^2\rangle=-i\)，所以张量幂极限有相位 \(e^{-ia^2}\)。

## 5. §3：伴篇标量事实怎样变成量子可实现的能量？

### 5.1 只输入哪些零温事实

令 \(\mathcal U\) 为 \([0,1)\) 上非负、非减、右连续且 \(\int_0^1\gamma(t)\,dt<\infty\) 的函数类。其 Stieltjes 测度约定为 \(\mu_\gamma([0,t])=\gamma(t)\)，不要求总质量为一。取 \(\gamma\in\mathcal U\) 为 Parisi 泛函 \(\Phi_\gamma(0,0)-\frac12\int_0^1t\gamma(t)\,dt\) 的最小化子，解
\[
\Phi_t=-\tfrac12(\Phi_{xx}+\gamma\Phi_x^2),\quad\Phi(1,x)=|x|,
\quad dX_t=\gamma(t)u(t,X_t)\,dt+dB_t,
\quad u=\Phi_x,\ a=\Phi_{xx}.
\]
伴篇提供 \([0,1)\) 上的满相对 Stieltjes 支撑、\(u\) 奇、\(a\ge0\) 偶、\(|u|\le1\)、每个 \(T<1\) 上的空间正则性，以及
\[
\mathbb E u(t,X_t)^2=t,\quad \mathbb E a(t,X_t)^2=1,\quad
P_*=\int_0^1\mathbb E a(t,X_t)\,dt.
\]
所以停止在 \(T\) 的损失至多 \(1-T\)。主路线只用每个固定时间条带的正则性，不需要零温测度的光滑密度或 \(T\uparrow1\) 时的一致导数界。

固定 \(0<T<1\)、整数 \(N\ge1\)，令 \(\Delta=T/N,\ t_j=j\Delta,\ Y_0=0\)。在独立标准高斯 \(Z_1,\ldots,Z_{N+1}\) 上，对 \(1\le j\le N\) 递推
\[
Y_j=Y_{j-1}+\sqrt\Delta Z_j+
 \Delta\gamma(t_{j-1})u(t_{j-1},Y_{j-1}),\quad
g_j=c_ja(t_{j-1},Y_{j-1})Z_j,\quad
c_j=(\mathbb Ea(t_{j-1},Y_{j-1})^2)^{-1/2}.
\]
记标准正态分布函数为 \(\Phi_{\rm G}\)，定义舍入前的变量 \(H_N\) 及其符号
\[
H_N=u(T,Y_N)+2\Phi_{\rm G}(Z_{N+1})-1,\qquad
F_N=\operatorname{sgn}(H_N),
\quad A_j=\mathbb EF_Ng_j,\quad B_i=\mathbb EF_NZ_i,\quad A_0=0.
\]
其中 \(1\le i\le N+1\)；归一化因子 \(c_j\) 在充分大 \(N\) 时同时为有限正数。
因为 \(2\Phi_{\rm G}(Z)-1\) 在 \((-1,1)\) 均匀，
\(\mathbb E[F_N\mid Z_1,\ldots,Z_N]=u(T,Y_N)\)；阈值为零的事件概率零。伴篇 Proposition 7.2 的具体接口是
\[
\lim_{N\to\infty}\sum_{j=0}^NA_jB_{j+1}
 =\int_0^T\mathbb Ea(t,X_t)\,dt.
\]
这是带**移位索引**的系数式，不能换成 \(\sum A_jB_j\)。伴篇结果的证明与核验见其唯一导读。

### 5.2 正交归纳：独立性到底在哪里成立？

在每一高度保留相容的空后代嵌入。以根种子 \(g_0=S\) 开始，递归定义
\[
Z_{j+1}=\mathsf G(g_j)=q(g_j).
\]
假定 \(g_0,\ldots,g_{j-1}\) 中心化且正交归一，则 \(Z_1,\ldots,Z_j\) 是联合高斯、协方差为单位阵，故独立。\(c_ja(t_{j-1},Y_{j-1})\) 只依赖 \(Z_{<j}\)，对最新 \(Z_j\) 取条件期望就得 \(g_j\) 中心化且与 \(g_1,\ldots,g_{j-1}\) 正交；\(c_j\) 保证范数一。根种子 \(S\) 在独立张量因子中，补足与 \(g_0\) 的正交性。

这个论证使用的是**构造出的正交孩子方向所产生的高斯场**，不是同一后代子树中任意两种计算的独立性。高度至多 \(N+1\)，每次取内积前在同一高度比较。

### 5.3 从同分布到能量，还差一个投影

\(F_N\) 不依赖接收根的种子，只依赖上述有限高斯模式。取一粒子分量就有
\[
\mathsf L^*F_N=\sum_{j=0}^NB_{j+1}g_j,\qquad
\langle F_N,g_0\rangle=0,\qquad
\boxed{\mathcal E(F_N)=\sum_{j=0}^NA_jB_{j+1}}.
\]
这一步把标量值和有根能量真正接上。接下来用 \(\tanh(kH_N)\) 代替符号函数，在固定 \(T,N\) 后才令 \(k\) 大；\(L^2\) 收敛和第 4 节的连续性控制能量损失。原始不连续 \(F_N\) 无需先证明有限度边能量收敛。

### 5.4 为什么输出有界还不够？

\(F_N\in\{-1,1\}\)，但传给父亲的列 \(g_j\) 仍然无界。正文“Bounded trigonometric approximation”引理逐层截断种子和传输列，并对有界目标 \(m\) 使用
\[
\theta_\kappa=\tfrac12\arcsin((1-\kappa)m),\qquad
\sin(2\theta_\kappa)=(1-\kappa)m
\]
避开反正弦在端点的导数奇性，再做光滑截断、Fourier 三角逼近及奇对称化。选择顺序是**外层先固定为有界 Lipschitz 映射，再精确逼近它的输入**；否则 Lipschitz 常数增长可能吞掉误差。

随后给根独立颜色，单色概率至多 \(\alpha\)，辅助类型总概率 \(p_H\)。原始单一高斯种子的绝对值分布函数可拆分二进制位，同时编码独立的颜色和新高斯；符号保留给后者。这是可测重编码，不要求颜色对原始种子光滑。由此诱导的拉回保内积、真空和 \(\mathsf L\)，故保能量。

**掩码（mask）**是局部种子符号反转时不变的事件，颜色类型就是这样的掩码。对互不相交的类型 \(R,S\)，有限树上的聚合为
\[
(A_{RS}f)_i=1_R(s_i)D^{-1/2}
\sum_{j\sim i}1_S(s_j)f_j.
\]
其极限是相应中心化孩子列的高斯提升。**类型排除**要求发给 \(R\) 的子公式在任何后代层都不读取 \(R\)；同一递归分支还须保留全部祖先类型的排除。

递归调用据此从每个聚合中删除当前色、所有祖先色及辅助类型。它把后代公式变成无需指定父方向、可对全部邻居求和的规则：回到父顶点的项因颜色直接为零。对固定公式，
\[
\|f^{\rm col}-f\|^2\le C(\alpha+p_H),
\]
其中 \(C\) 不依赖颜色数。理由是先对互斥掩码的平方范数求和，再对**原始有限个合并场**使用 Lipschitz 界；若将所有来源色摊成独立坐标，欧氏导数界可以随颜色数增长。两个表达式分支仍可读取同一子树，颜色只阻止反馈，**不会制造独立性**。

最终“Classical near-optimality in synthesis form”命题给出有限、有界、奇对称的角度公式，
\[
m=\sum_{c\ {\text{非辅助类型}}}1_c\sin(2\theta_c),\quad
|m|\le1,\quad m=0\text{（辅助类型上）},\quad
\mathcal E(m)\ge P_*-\varepsilon.
\]

## 6. §4：辅助自旋收缩如何真的编译出聚合？

临时允许高斯纵场 \(\exp(-it\sum_i s_iZ_i)\)。这些带种子控制首先生成有界奇系数的 \(Y,Z\) 旋转和偶系数的 \(X\) 旋转。对有限类型划分 \(R_1,\ldots,R_M\)，按符号向量 \(\epsilon\) 翻转各类型的自旋，将代价变为 \(C_\epsilon\)，符号平均就隔离出两种不同类型之间的相互作用：
\[
C_{R_aR_b}=2^{-M}\sum_{\epsilon\in\{\pm1\}^M}\epsilon_a\epsilon_bC_\epsilon.
\]
这是有限树上的精确恒等式；对任意可测掩码的逼近使用高斯测度下的有界收敛，不要求种子方向的导数。

主要难点是聚合 \(H=\sum_{i\in I}P_i(A_{IJ}f)_i\)，其中目标自旋轴 \(P\in\{Y,Z\}\)。取尚未使用、概率 \(p_K>0\) 的辅助类型 \(K\)；有界奇函数 \(f\) 只依赖种子，其跨边依赖排除 \(I,J,K\)。把发送类型 \(J\) 分成小块 \(J_l\)，记 \(p_l=\Pr(J_l)\)、\(p_J=\sum_lp_l\)。两次以相邻自旋为支点的对易子给出
\[
\widetilde H_{\cal P}=\frac1{p_K}
\sum_{l,\ i\in I,\ j,j'\in J_l,\ k\in K}
P_iA_{ij}X_jA_{jk}X_kA_{kj'}X_{j'}f_{j'},
\quad A_{ij}=D^{-1/2}1_{i\sim j}.
\]
折返路径 \(i-j-k-j\) 中 \(j=j'\) 的两次 \(X_j\) 抵消，固定在 \(|+\rangle\) 的辅助自旋给 \(X_k=1\)，剩余
\[
\sum_{i,j}A_{ij}P_if_j\,
\frac{\#\{k\sim j:k\in K\}}{Dp_K}\longrightarrow H.
\]
发送类型细分保留所有折返路径，而使不同发送点的简单路径贡献消失。为读懂下表，先约定
\[
b_j=\sum_{i\in I}A_{ji}P_i.
\]
在以辅助点为根的切边计算中，\(d_l,e_l\) 分别是孩子上 \(1_{J_l}Xb\)、\(1_{J_l}Xf\) 经已有孩子电路的海森堡共轭后作用于真空所得的中心化列。它们的场共同交换，且各阶加权范数均为 \(O(\sqrt{p_l})\)。

下表中的 \(T=O_{\rm sm}(\epsilon)\) 指：对每个输出权次 \(a\) 及所需的有限参数导数，都存在输入权次 \(b\)，使 \(\|W^aTW^{-b}\|\le C\epsilon\)；伴随也满足同样的界。这里 \(W\) 是第 4 节在当前高度的权重，常数不随发送类型细分改变；注明“条件于 \(J_l\)”时，界对该掩码内根种子一致。四类切边根都要控制：

| 切边根的类型 | 去掉辅助根标量相位后的误差 |
|---|---|
| \(I\) | 合并孩子列的 \(O_{\rm sm}(\rho)\) |
| \(J_l\) | 条件于该块的 \(O_{\rm sm}(\sqrt{p_l})\) |
| \(K\) | \(p_K^{-1}\sum_l(q(d_l)q(e_l)-\langle d_l,e_l\rangle)\)，为 \(O_{\rm sm}(\rho)\) |
| \(f\) 内部的下层类型 | 原来固定消息列表的响应为 \(O_{\rm sm}(\delta_{\cal P})\) |

\[
\rho^2=\sum_lp_l^2\le p_J\max_lp_l,\qquad
\delta_{\cal P}=\max_l\sqrt{p_l}.
\]
在辅助根 \(K\)，\(\langle d_l,e_l\rangle\) 是**同一个邻居**的协方差，不能按独立场丢弃。互斥掩码的列正交，使扣除协方差后的二次式在正规排序下的 Hilbert–Schmidt 核为 \(O(\rho)\)。其指数的一致图范数界还要通过与权重的对易子和 Gronwall 不等式建立；仅有生成元小不够。

下层公式的响应尤其重要。切边后的有限边界向量为 \(y\)，\(m_\alpha(y)\) 是当前根向孩子发出的第 \(\alpha\) 个消息；\(\alpha\) 遍历原公式固定的消息列表。令 \(\widehat\Delta(y)\) 为孩子分支中，边界输入改变加权终端公式所引起的哈密顿量差，已共轭到此前电路的坐标中。记其在零输入处的前两阶导数为 \(D_\alpha,D_{\alpha\beta}\)，并令
\[
r_\alpha=D_\alpha\Omega,\qquad
c_{\alpha\beta}=\langle\Omega,D_{\alpha\beta}\Omega\rangle.
\]
一阶响应因奇对称而中心化。对完整相对门族求导后，下层递推保留
\[
\sum_\alpha(m_\alpha(y)-m_\alpha(0))q(r_\alpha)
+\tfrac12\sum_{\alpha,\beta}
[m_\alpha(y)m_\beta(y)-m_\alpha(0)m_\beta(0)]c_{\alpha\beta}.
\]
上述贡献还须由此前根映射 \(u\) 作 \(u^*(\cdot)u\) 共轭。在实际无父输入的非终端下层根，要用**不减 \(m(0)\)** 的对应式，而不是把差分在 \(y=0\) 取值为零。混合二阶响应仍在，故不需要不同下层消息独立。细分只缩小调用 \(f\) 的发送点掩码，即“调用掩码”，不扩张 \(f\) 自身的消息列表或依赖。

固定辅助自旋是指递归压缩空间中**所有辅助自旋**保持 \(X=1\)，不只是把根插入乘 \(1_{K^c}\)。精确收缩保持该空间，有限对易子近似则未必。因此按公式的**聚合阶数（rank）**从外向内编译：局部种子函数阶数为零，逐点组合取各输入阶数的最大值，聚合 \(A_{RS}f\) 则在 \(f\) 的阶数上加一。先固定最高阶的发送类型细分，再选有限对易子乘积；处理下一阶时，使用另一个尚未接触的辅助类型。这样每次使用固定 \(X=1\) 条件时，它都仍精确成立。

理想的仅依赖种子的 \(Y\) 旋转有插入
\[
v_{\rm cl}=m|+\rangle+\cos(2\theta)|-\rangle,\qquad
\mathcal E(v_{\rm cl})=\mathcal E(m).
\]
第二项的根自旋或移位后的孩子自旋与经典子空间正交。最后得到完整的有限带种子电路，其非辅助类型上的插入误差小于 \(\eta\)，且
\[
|\mathcal E(v)-\mathcal E(m)|\le2\eta+2\sqrt{p_H}.
\]
这就在既定前后电路中完成了经典公式的替换。

独立有限复算见 `guide/evidence/qaoa-quantum/check.py` 和 `guide/evidence/qaoa-quantum/witness.json`：8 个三/四自旋辅助收缩恒等式、3 个种子 Pauli 恒等式、35 个激发数组合式均以有理复数精确重算；另检二阶相位 \(-i\) 及二次式 \(Q=\sum_lp_l(q_l^2-1)\) 的真空范数 \(\|Q\Omega\|^2=2\sum_lp_l^2\)，其中 \(q_l\) 为独立单位高斯位置。翻错两种路径符号、辅助密度归一化、漏协方差、漏相位的五个负测试均拒绝。这些是局部有限恒等式证据；收缩及回波极限由分析估计支撑。重放命令为 `python3 guide/evidence/qaoa-quantum/check.py`，输出在 `guide/evidence/qaoa-quantum/check-output.json`。

## 7. §5：怎样移除种子，而不把 \(O(r)\) 误差放大成常数？

本节要模拟的是**已经选好的完整带种子门序列**。记 Weyl 位移和自旋控制位移为
\[
W(f)=e^{iq(f)},\qquad W_Z(f)=e^{iZq(f)}.
\]
先选择小而固定的 \(b>0\)，后令 \(r\downarrow0\)。设 \(e=Z\Omega\)、\(\gamma_r=b/r\)、\(R_\star=e^{-i\pi X/4}\)，初始化依次施加代价门 \(\gamma_r\)、混合门 \(\arcsin r\)、代价门 \(-\gamma_r\) 及 \(R_\star\)。定义其高位移方向
\[
\ell_r=Y e^{-2i\gamma_rZq(e)}\Omega,\qquad
d_{0,r}=-2br\,e+2b\sqrt{1-r^2}\,\ell_r.
\]
初始化有精确分解
\[
u_r=a_{0,r}U_{O,r}+a_{1,r}U_{S,r},\qquad |a_{1,r}|=r.
\]
这里 \(U_{O,r}=R_\star W_Z(d_{0,r})\)、\(U_{S,r}=R_\star XW_Z(-2\gamma_re-d_{0,r})\) 都是酉算子。令 \(\vartheta_r=\gamma_r\operatorname{Im}\langle d_{0,r},e\rangle\)，则 \(a_{0,r}=\sqrt{1-r^2}e^{i\vartheta_r}\)、\(a_{1,r}=-ir e^{-i\vartheta_r}\)。普通分量具有有界位移；特殊分量振幅 \(r\)、位移 \(O(r^{-1})\)，两者无需精确正交。令 \(\psi_{S,r}=a_{1,r}U_{S,r}\Omega\) 为特殊分量，以后逐门作用于这两个分量来保留精确分解。初始化的特殊插入方向
\[
w_r=u_r^*Z\psi_{S,r}/r
\]
范数恰为一；它和 \(\ell_r\) 在任意固定粒子层上的投影均趋零，彼此趋于正交，最终成为独立于已有孩子方向的外部高斯模式。

### 7.1 选择性短探测脉冲与零时钟

把 \(W(d/r)\eta\) 称为以 \(d/r\) 为中心的**波包**；\(\eta\) 是移去大位移后的**尾向量**。估计对每个固定中心列表、各阶 \(\|(1+N_{\rm top})^k\eta\|\) 一致有界的尾向量族成立，而不是对全部单位向量给算子范数估计。以 \(P\) 表示所选 \(ZY\) 平面的自旋轴、\(v\) 表示该步实际插入方向、\(\tau\) 表示脉冲系数，短代价探测满足精确式
\[
W(d/r)^*e^{-ir\tau Pq(v)}W(d/r)
=e^{-i\tau aP}e^{-ir\tau Pq(v)},\qquad
a=-2\operatorname{Im}\langle v,d\rangle.
\]
因此大位移波包感到有限自旋旋转，而普通分量只感到小作用。有限集合的同步控制引理同时控制有限个非零投影对；通过 Lie 括号和多项式插值，在两个垂直 \(ZY\)-轴上选有限脉冲列表，且每个轴分别满足 \(\sum\tau_k=0\)。这两个“零时钟”条件使普通分量的一阶 \(r\) 项抵消。

这里需要有限维 Lie 群中的精确可达性。正文用有限个共轭生成元的乘积映射在单位元的满秩微分，证明可达子群含所需连通解析子群的邻域，再以有限分段得到目标旋转。随后探测脉冲使用每次实际更新的插入方向，并控制整个有限列表中的方向变化为 \(O(r)\)。

普通误差必须是 \(o(r)\)，特殊归一化波包上的误差是 \(o(1)\)，乘振幅后也是 \(o(r)\)。巨大代价门之后，普通波包中对角项为实数，不同中心的交叉项超多项式小，从而其虚投影仍为 \(o(r)\)；证明不预先假设探测作用很小。另行保留的范数小余项只交给后续精确酉门搬运，不对它们施加不有界场算子。

### 7.2 回波必须先用实际方向消去奇异项

一个模拟纵场的回波（echo）依次施加
\[
\text{代价门 }t/r,\quad\text{选择性旋转 }(-iX),\quad
\text{代价门 }-t/r,\quad\text{选择性旋转 }(iX).
\]
特殊插入在普通步骤间保持为初始化的 \(w_r+o(1)\)，在一次特殊翻转后变号，撤销翻转后恢复。由此，第一巨大代价门前、第一次选择性翻转后的**实际** \(Z\)-插入 \(v_r,v'_r\) 满足
\[
v'_r-v_r=-2r w_r+o(r).
\]
先精确用 Weyl 乘法律合并两个巨大代价门：
\[
e^{itZq(v'_r)/r}e^{-itZq(v_r)/r}
=\xi_r W_Z\!\left(\frac t r(v'_r-v_r)\right),\quad
\frac t r(v'_r-v_r)=-2tw_r+o(1).
\]
标量相位 \(\xi_r\) 可不收敛，但在插入中抵消。若提前把 \(v_r\) 换成只有 \(O(r)\) 精度的低位移近似，再除以 \(r\)，就会丢失所需误差尺度。

极限中的方向 \(w\) 产生 \(e^{-2itZq(w)}\)，故模拟纵场角度 \(\sigma\) 时取 \(t=\sigma/2\)。两次翻转恢复特殊插入，保证以后每个回波使用**同一个** \(w\)。

### 7.3 同分布与普通 Gram 收敛为什么仍不够？

有限门序列的低位移分量可写成有限 Weyl 和，其中 \(s_j\in\mathbb C^2\) 是根自旋向量：
\[
h=\sum_js_j\otimes W(f_j)\Omega.
\]
普通内积由
\(\langle W(f)\Omega,W(g)\Omega\rangle
=e^{-\|g-f\|^2/2+i\operatorname{Im}\langle f,g\rangle}\)
决定。但能量涉及另一个算子 \(\mathsf L\)，须另算
\[
\langle h,\mathsf Lh\rangle
=-i\sum_j\langle s_j,+\rangle
e^{-\|f_j\|^2/2}\langle f_j,h\rangle.
\]
在理想的带种子空间中，外部模式位于根种子因子，根移位只把整个 \(h\) 放入中心化孩子因子，因此外部方向与它配对为零。高位移方向的分离使实际极限也满足同一规则。这项一粒子计算把 Gram 收敛补成所需的能量收敛。

最后须确保探测脉冲能区分特殊波包，即其投影对不为零。固定 \(b\)，在理想低位移电路的有限角度空间中，这些投影是实解析函数；将待模拟电路的角度全取零，同一个计算给出 \(4bz e^{-8b^2}\ne0\)，其中 \(z=\pm1\) 标记波包的自旋。因此有限个零集的补集稠密。先轻微扰动目标角度，再按时间顺序构造有限探测列表，最后才选 \(r\)，避免用尚未实现的探测来定义其自身极限。

## 8. §6：误差预算与不容倒置的选择顺序

给定 \(\varepsilon\)，正文先取经典误差 \(\varepsilon/4\)、辅助类型概率 \(p_H<(\varepsilon/8)^2\)，再取合成误差 \(\eta=\varepsilon/8\)。于是带种子电路的能量大于
\[
P_*-\varepsilon/4-2(\varepsilon/8)-2\sqrt{p_H}
>P_*-3\varepsilon/4.
\]
移除种子再损失少于 \(\varepsilon/4\)。

主路线依次选择：精度；零温最小化子与 \(T<1\)；固定 \(T\) 的网格；符号函数的平滑；有界列及三角逼近；颜色与辅助类型；发送类型细分和有限对易子乘积；有限带种子门编译；小 \(b\)；使探测投影非零的角度扰动；有限探测脉冲；小正 \(r\)；**固定完整普通门序列**；最后热力学极限。

外部接口此时才是 BFMVZ v3 Theorem 1：
\[
v_W=\lim_{D\to\infty}\frac{\sqrt D}{2}
\langle Z_iZ_j\rangle_{W,C_D^+},\qquad
C_D^+=D^{-1/2}\sum_{\{i,j\}}Z_iZ_j.
\]
BFMVZ (2.3) 用负树代价。在树光锥的一个二分部上共轭 \(X\)，代价和边可观测量同时变号，混合门与初态不变，所以得到上式正号。其 SK (6.1) 已与本文正号约定相同。合并相邻同类门、插入零角度的门，就将任意有限代价–混合门序列写成标准交替格式。此时临时种子控制已全部移除，恰好满足迁移定理的适用范围。

## 9. 附录 A 与正则图 MaxCut：独立到什么程度？

### 9.1 正温是独立的经典入口，不是独立的量子证明

Lopatto **arXiv:2607.11756v3** Theorem 1.1 对每个 \(\beta_0>1\) 给
\[
\operatorname{supp}\mu_{\beta_0}=[0,q],\quad
\mu_{\beta_0}(dt)=\rho(t)\,dt+c\delta_q,\quad
\rho\in C^\infty([0,q)),\quad 0<q,c<1.
\]
其 Lemma 2.2、Proposition 2.4、Lemma 2.5 分别给支撑上的自洽、空间正则和梯度鞅。原文按有序对求和的哈密顿量系数是 \(\beta_0/\sqrt{2n}\)：配对独立 \(g_{ij},g_{ji}\) 得到本文无序对系数，对角项是均值零常数平移。坐标替换
\(\phi(t,x)=\beta_0^{-1}(u(t,\beta_0x)+\log2)\)
得到本文扩散系数为一的 PDE，终值为 \(\beta_0^{-1}\log(2\cosh\beta_0x)\)，Parisi 系数为 \(\gamma=\beta_0\mu([0,t])\)。这是另一篇较新的外部定理；此处核对其命题及应用假设，不重审整篇证明。

固定 \(\beta_0>1,\ 0<T<q\)，记 \(m=\phi_x,\ a=\phi_{xx},\ b=\gamma m\)。扩散 \(dX_t=b(t,X_t)dt+dW_t,\ X_0=0\) 的系数有足够的空间、时间 Lipschitz 界，且
\(\mathbb E\phi_x(t,X_t)^2=t\)、\(\mathbb Ea(t,X_t)^2=1\)。
在 \([q,1]\) 系数恒为 \(\beta_0\)，Cole–Hopf 给
\[
\phi(q,x)=\beta_0^{-1}\log(2\cosh\beta_0x)
                  +\beta_0(1-q)/2,\quad
a(q,x)=\beta_0\operatorname{sech}^2(\beta_0x).
\]
故 \(1-q=\mathbb E\operatorname{sech}^2(\beta_0X_q)\le1/\beta_0\)。对 \(X_tm(t,X_t)\)、\(\phi(t,X_t)\) 用 Itô 公式导出正文的界
\[
\int_0^T\mathbb Ea(t,X_t)\,dt
\ge P_*-\frac{1/4+\log2}{\beta_0}-(q-T).
\]
正温 Parisi 自由能只需与最大值比较
\(F_{\beta_0}-\log2/\beta_0\le P_*\le F_{\beta_0}\)；
甚至可先由这组夹逼证明 \(P_*\) 极限存在，不必调用零温公式。

这里的正温公式与 Talagrand 原刊 Theorem 1.1（pp. 222–223）的假设直接相容：对 \(\beta_0H_n\) 用 \(\xi_{\beta_0}(t)=\beta_0^2t^2/2\)，协方差的统一偏差是 \(\beta_0^2/(2n)\to0\)，\(\xi\) 偶、三次连续可微且 \(\xi''>0\)，外场为零。原定理的配分函数对全部构型作未归一化求和，所以必须保留 \(\log2/\beta_0\)；哈密顿量的整体负号可由高斯分布的符号对称性消去。

有限树步骤调用 EAMS **arXiv:2111.06813v2** 的一般消息中心极限定理和精确边能量计算，而**不**直接调用该文假设零温序参量严格增加的近最优主定理。为读懂精确接口，固定步长 \(\delta>0\)、整数 \(L\ge1\) 且 \(L\delta\le T\)，令 \(t_r=r\delta\)。树上以独立 \(g_i\sim N(0,1)\) 初始化
\[
u^0_{i\to j}=u_i^0=g_i,\quad A^{-1}_{i\to j}=1,\quad
x^0_{i\to j}=x_i^0=\sqrt\delta\,g_i.
\]
对 \(0\le r<L\)，先用前一步系数更新消息，再更新 Euler 轨道：
\[
\begin{aligned}
u^{r+1}_{i\to j}
 &=D^{-1/2}\sum_{v\in\partial i\setminus\{j\}}
 A^{r-1}_{v\to i}u^r_{v\to i},&
u^{r+1}_i
 &=(D+1)^{-1/2}\sum_{v\in\partial i}
 A^{r-1}_{v\to i}u^r_{v\to i},\\
x^{r+1}_{i\to j}
 &=x^r_{i\to j}+\delta b(t_r,x^r_{i\to j})
 +\sqrt\delta\,u^{r+1}_{i\to j},&
x^{r+1}_i
 &=x^r_i+\delta b(t_r,x^r_i)+\sqrt\delta\,u^{r+1}_i.
\end{aligned}
\]
每次已构造 \(x^r\) 后，取同一个确定性归一化因子
\[
c_{D,r}=[\mathbb E a(t_r,x^r_{i\to j})^2]^{-1/2},\quad
A^r_{i\to j}=c_{D,r}a(t_r,x^r_{i\to j}),\quad
B^r_i=c_{D,r}a(t_r,x^r_i),\quad
z_i^L=\sqrt\delta\sum_{r=1}^LB_i^{r-1}u_i^r.
\]
有向边的规律用于归一化，节点不能另选一套因子。令 \(U_0,\ldots,U_L\) 独立标准高斯，极限递推为
\[
\begin{aligned}
X^\delta_0&=\sqrt\delta\,U_0,&
X^\delta_{r+1}
 &=X^\delta_r+\delta b(t_r,X^\delta_r)+\sqrt\delta\,U_{r+1},\\
c_{\delta,r}&=[\mathbb E a(t_r,X^\delta_r)^2]^{-1/2},&
Z^\delta_L
 &=\sqrt\delta\sum_{r=1}^L
 c_{\delta,r-1}a(t_{r-1},X^\delta_{r-1})U_r.
\end{aligned}
\]
严格正的 \(a\) 保证归一化因子有定义。\(A^{r-1}u^r\) 中的一步滞后保证最新消息条件中心化，有限度的各步消息不是独立高斯；固定步数下 \(c_{D,r}\to c_{\delta,r}>0\)，允许按原定理证明对随度变化的系数作归纳。精确边能量接口为
\[
\lim_{D\to\infty}\frac{D+1}{2\sqrt D}\mathbb Ez_o^Lz_v^L
=\delta\sum_{r=1}^{L-1}c_{\delta,r}\mathbb Ea(t_r,X_r^\delta),
\quad
\mathbb E(Z_L^\delta)^2=L\delta.
\]
先固定 \(\delta,L\)，取 \(D\to\infty\)；随后取 \(L=\lfloor T/\delta\rfloor,\delta\downarrow0\)，恢复到 \(T\) 的扩散积分。附录已经指出并修正 EAMS 印刷式的端点移位和 Lemma 2.8 缺失 \(1/k\)；它使用 Proposition 2.1 的正确边恒等式。比如后者的缺因子可用其记号 \(t=1,Y_i^0=g_i,Y_j^0=g_j,A^{-1}=1\) 检查：邻边左侧期望为 \(1/k\)，漏因子的右侧为 1。这是**被引用文献的印刷问题，且本文已有处理**。

固定温度后，Euler 轨道的均方误差为 \(O(\delta)\)，归一化因子和能量误差各为 \(O(\sqrt\delta)\)。附录进一步在对称张量幂的激发数嵌入中证明**范数收敛**；其一阶激发数界来自逐个独立替换孩子子树的条件方差。这样有限树能量才收敛到 \(\mathcal E(z^\delta)\)。最后截断至 \([-1,1]\) 的 \(L^2\) 损失也为 \(O(\sqrt\delta)\)，再接同样的有界逼近、类型排除和量子编译。

AMS v1 Assumption 1/Theorem 2 的有界性、空间 Lipschitz、时间连续/强全变差及鞅方差条件，在固定 \(T<q\) 的这些正则系数上成立；Montanari v2 Assumption 1 的正温区间支撑由 Lopatto 提供。不过这两个全 SK 算法定理不是本文有限有根公式的替代品。正温路线独立于零温伴篇，但仍复用同一量子编译。

### 9.2 正则图 MaxCut 的度因子和概率

对 \((D+1)\)-正则简单图，标准 MaxCut 代价为
\[
H_{\rm MC}=\tfrac12\sum_{\{i,j\}}(I-Z_iZ_j),\qquad
C_D^-=\frac2{\sqrt D}H_{\rm MC}-\frac{|E|}{\sqrt D}I.
\]
因此标准代价角度是 \(2\gamma/\sqrt D\)，不是 \(\gamma/\sqrt D\)，混合角度不变。围长 \(>2p+1\) 保证一个边可观测量的**相关光锥**是树；只在这个光锥作二分变号，不要求整图二分。于是
\[
q_{p,G}(2\gamma/\sqrt D,\beta)
=\tfrac12+\nu_p(D,\gamma,\beta)/\sqrt D.
\]
先固定近最优门序列，再取充分大的 \(D\)，得到引言 Corollary 1.2 对**所有**满足该围长条件的图的下界。但与最优割的比较只针对随机正则图。

随机图内层极限固定 \(D,p\)。MWW 原刊 Theorem 1 对 \(d\ge3\)、\((d-1)^{2g-1}=o(n)\) 给有限短圈联合 Poisson 渐近；固定 \(d=D+1,g=2p+3\) 满足条件。短圈数依概率有界，所以非树光锥的边比例 \(b(G)\to0\)（概率及均值），每条边贡献在 \([0,1]\) 给出 \(|q-q_{\rm tree}|\le b(G)\)。DMS **arXiv:1503.03923v2** Theorem 1.6(b) 则给
\[
\frac{\operatorname{MaxCut}(G_{n,d})}{n}
=\frac d4+\frac{P_*\sqrt d}{2}+o_d(\sqrt d)
\]
的先规模后度数的高概率渐近；其简单图约定在引言模型定义中已固定。除以边数 \(nd/2\)，再用 \(\sqrt{D/(D+1)}\to1\)，对给定 \(\eta>0\) 选误差小于 \(\eta/2\) 的门序列，得
\[
\lim_{D\to\infty}\limsup_{n\to\infty}
\Pr_G\{\sqrt D[\operatorname{OPT}(G)-q_{p,G}]>\eta\}=0.
\]
这里的概率只含图的随机性，\(q\) 已平均量子测量；结论采用先规模后度数的顺序。

## 10. 文献用途与作者 Lean 的边界

**固定正文的来源。** 用固定 ref 的目录元数据定位 build tree，再以未截断子树核对全部 10 份 TeX 的 Git blob；记录为 `sources/qaoa/manuscript-upstream-directory.json`、`sources/qaoa/manuscript-upstream-tree.json`、`sources/qaoa/manuscript-source-check.json`。这是来源及字节对应检查。

外部原文保存在 `sources/qaoa/`，`.txt` 是原 PDF 的 `pdftotext -layout` 阅读副本，PDF 才是原始版本。下表命题均已直接阅读。

| 来源及固定版本 | 本文真正使用的接口 | 本次核验范围与证据 |
|---|---|---|
| FGGZ, arXiv:1910.08187v4，§4 Theorem，(13)–(16) | 任意固定实角度的热力学值及二阶矩/集中 | 已读命题和集中推导；`sources/qaoa/arxiv-1910.08187v4.pdf` |
| BFMVZ, arXiv:2110.14206v3，Theorem 1、(2.3)、(2.6)、(3.11)、(6.1)–(6.3) | 固定电路从树到 SK 的迁移；负树/正 SK 的对应 | 已核符号、\(1/2\)、\(\sqrt D\)、门顺序和全部实角度范围；`sources/qaoa/arxiv-2110.14206v3.pdf` |
| Talagrand, Annals of Mathematics 163 (2006), pp. 221–263，Theorem 1.1 | 正温 Parisi 自由能公式 | 已读协方差近似与光滑/凸性假设，核未归一化配分和；`sources/qaoa/talagrand-2006.pdf` |
| Lopatto, arXiv:2607.11756v3，Theorem 1.1、Lemma 2.2、Proposition 2.4、Lemma 2.5 | 正温满支撑、光滑度、自洽与扩散 | 已读精确陈述并换坐标/协方差；未独立复审其满支撑证明；`sources/qaoa/arxiv-2607.11756v3.pdf` |
| EAMS, arXiv:2111.06813v2，Assumptions 2–3、Proposition 2.1、Theorem 3.1、Lemmas 3.2–3.4、4.2–4.3 | 固定步数中心极限定理、条件消息方差、边恒等式 | 已核系数滞后、归一化、有界性、节点/切边比较、固定步数和端点；`sources/qaoa/arxiv-2111.06813v2.pdf` |
| AMS, arXiv:2001.00904v1，Assumption 1、Theorem 2、Proposition 5.3；Montanari, arXiv:1812.10897v2，Assumption 1、§3.1 | 扩散/归一化 Euler 的先例和带假设的经典优化 | 已核实际假设；有根空间的桥接由本文另证；`sources/qaoa/arxiv-2001.00904v1.pdf`、`sources/qaoa/arxiv-1812.10897v2.pdf` |
| DMS, arXiv:1503.03923v2，Theorem 1.6(b)；MWW, EJC 11 (2004), R66，Theorem 1 | 随机简单正则图的最优割、局部树比例 | 已读命题、模型及顺序极限定义；`sources/qaoa/arxiv-1503.03923v2.pdf`、`sources/qaoa/mww-2004.pdf` |

零温 Parisi 公式及极小元存在、满支撑分析和有限系数恒等式的细读，归入伴篇唯一导读 `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md`。本篇承接这些标量结论。Boulebnane 等的自旋–玻色子工作、Li–Khaneja 同步控制、Jones–Knill 重聚焦是方法先例；本论文对所需的加权门演算、有限集合同步控制及零时钟、符号平均自行证明，故不作为额外黑箱。Sels–Morone 的截断 Wigner 数值也不是证明输入。

**Lean 范围。** `paper/lean/281.md` 的真实入口为 `OAI.Probability.SKValue.Main` 的 `OAI.SKValue.value_consequences` 与 `OAI.Probability.SKSupport.Main` 的 `OAI.ZeroTemperatureSK.full_support`；不是 Comparator 文件中的占位 `sorry`。源码里的 `IsMinimizer` 是显式控制表示 Parisi 泛函的全局极小性，并未把满支撑或自洽放进假设。`full_support` 从最小化条件构造扩散并给满相对支撑和两项自洽；`value_consequences` 给有限系统**期望**基态值的收敛、终端鞅/曲率表示和移位高斯系数极限。其中“最终为正”只约束全部网格归一化因子，不约束高斯增量或 \(A_j,B_i\) 的符号。它不单独给极小元存在，也不包含有根/Fock 实现、Pauli 电路、辅助收缩、种子回波、从树到 SK 的迁移或 QAOA 主定理。

这次完成的是固定提交的源码/定义审计，**没有内核重放成功**：原始入口的 `math-lean-verify` 返回 exit 2，预装 Lean workspace / elan 链接失效且无可用 `lean` / `lake`，因此未取得实测传递公理集。本导读量子部分的核验依据是手算及局部精确计算。

证据集中在 `guide/evidence/lean-family-281/` 下的 statement_fidelity.md、source-manifest.json、source-check.json、environment.json 和 original-entry-verifier.log。保留的 347 个实际 OAI 模块组成完整显式导入闭包，唯一未遍历外部库是 Mathlib；所选声明及 Model 定义均与 Comparator 核对。`python3 guide/evidence/lean-family-281/check_snapshot.py` 可离线重查原字节和声明，添加 `--fresh` 则重新请求少量 pinned metadata。本次独立 `--fresh` 重跑核对了 355 个 Git blob，并亲读两个实际 Model / Main。源码检查不运行 Lean；上游要求 Lean 4.34.1 与 Mathlib `d13f23b723b8a846827a245b89c10fc7d3f11612`，须在匹配工具链下另行编译。

## 核验结论

### 改进

**1. 正温误差可以显式收紧。** 附录 A “A positive-temperature value bound”给 \((1/4+\log2)/\beta_0\)。保留其证明中被最大熵上界丢弃的信息，可改成
\[
\boxed{\quad
\int_0^T\mathbb Ea(t,X_t)\,dt
\ge P_*-\frac1{4\beta_0}
-\frac{h(\sqrt{1-\beta_0^{-1}})}{\beta_0}-(q-T),\quad}
\]
其中 \(h(m)=-\frac{1+m}{2}\log\frac{1+m}{2}
-\frac{1-m}{2}\log\frac{1-m}{2}\) 是二元熵。对每个 \(\beta_0>1\) 都严格优于原项，且为
\(1/(4\beta_0)+O(\log\beta_0/\beta_0^2)\)。这是**原证明的显式加强，不主张新颖性**。

推导如下，亦是可直接检查的证据。令 \(s=1-q\)、\(M=\tanh(\beta_0X_q)\)，则附录同样的 Itô 计算在不作熵估计时给出精确式
\[
I_q:=\int_0^q\mathbb Ea(t,X_t)\,dt
=F_{\beta_0}-\frac{\beta_0s^2}{4}
-\frac{\mathbb Eh(M)}{\beta_0}.
\]
有 \(\mathbb E(1-M^2)=s\le\beta_0^{-1}\)。设 \(e(r)=h(\sqrt{1-r})\)，\(0\le r\le1\)。对 \(m=\sqrt{1-r}\in(0,1)\)，
\[
e'(r)=\frac{\operatorname{atanh}m}{2m}>0,\qquad
e''(r)=-\frac{m/(1-m^2)-\operatorname{atanh}m}{4m^3}\le0,
\]
因为 \(\operatorname{atanh}m=\int_0^m(1-t^2)^{-1}dt
\le m/(1-m^2)\)。端点由连续延伸处理。Jensen 给
\(\mathbb Eh(M)=\mathbb Ee(1-M^2)\le e(s)\le e(\beta_0^{-1})\)；
再用 \(F_{\beta_0}\ge P_*\)、\(\beta_0s^2/4\le1/(4\beta_0)\)，删除 \([T,q]\) 至多损失 \(q-T\)，即得结论。

独立复核重做了精确 \(I_q\) 式中的二次尾项、熵恒等式及 Jensen 方向；实际使用范围为 \(\beta_0>1,\ 0<T<q\)。\(\beta_0=1\) 只是新旧熵上界相等的代数端点，不提供该构造所需的正长度区间。

数值只作量级比较，不作为证明：\(\beta_0=2,10,100\) 时，原温度损失上界分别约 \(0.471574,0.0943147,0.00943147\)，新上界分别约 \(0.333248,0.0369310,0.00267513\)。这不是对真实损失或所需深度的数值预测。

**2. 期望结论自动提升为固定门序列的典型测量结论。** 这是 FGGZ v4 的直接推论，而非新的集中定理。先以 \(\varepsilon/2\) 选一个门序列，使 \(v_W\ge P_*-\varepsilon/2\)。FGGZ (13)–(14) 给
\[
\mathbb E_{J,\sigma\sim W_J}(H_n(\sigma)/n-v_W)^2\to0,
\]
这里 (14) 是 \(\mathbb E_J\langle(C/n)^2\rangle\) 的极限，不只是电路期望 \(\langle C/n\rangle\) 的无序方差；展开平方并用 (13) 才得到上述**联合实例及测量**的均方收敛。故 \(\Pr_{J,\sigma}\{H_n(\sigma)/n<P_*-\varepsilon\}\to0\)。令 \(r_n(J)\) 为给定实例的测量失败概率，则对每个 \(\eta>0\)，\(\Pr_J\{r_n(J)>\eta\}\le\mathbb E_Jr_n(J)/\eta\to0\)。这是依概率的典型实例结论，不是逐样本几乎处处收敛。所用 (13)–(14) 已独立对照原文。

**3. 边能量引理可弱化激发数假设。** 正文“Energy as a root shift”假设 \(\nu_D=\langle f_D,N_{D+1}f_D\rangle\) 一致有界；其已有分解实际只需 \(\nu_D=o(\sqrt D)\)，**原命题其余假设不变**。明确地，\(f_D\) 须具有有限半径、中心化即 \(\langle\Omega,f_D\rangle=0\)，且在每个顶点交换完整孩子子树（包括全部种子坐标）时不变；在同一固定有限高度的激发数嵌入下强收敛至 \(f\)。若另有 \(\|f_D\|\le1\)，记 \(M=D+1\)，则对两端插入 \(f_{D,i},f_{D,j}\) 有
\[
\left|\frac{\sqrt D}{2}\langle f_{D,i},f_{D,j}\rangle
 -\mathcal E(f_D)\right|
\le 1-\sqrt{D/M}+\sqrt{\nu_D/M}
                    +\frac{\sqrt D\,\nu_D}{2M}.
\]
这里的 \(\mathcal E(f_D)\) 在激发数嵌入后的共同空间中计算。第一项来自 \(\sqrt{D/M}\) 的系数差，第二项来自 \(R_Mf_D-f_D\)，第三项是双侧激发余项；再由能量连续性得到极限 \(\mathcal E(f)\)。中心化不能删：\(f_D=\Omega\) 时激发数为零，但两端内积为一，缩放后为 \(\sqrt D/2\)。这说明该假设的作用，不是论文的反例，也不主张 \(o(\sqrt D)\) 为必要条件。

### 错误与不足

**目前未定位到推翻主定理的正文错误。** 原文摘要和引言明确说 “We give no quantitative bound on the required depth or efficient angle-selection procedure.” 第 1 节已集中说明这一资源界缺失；因此本定理尚不能与 \(p=20\) 的具体数值作可执行优化性能比较。EAMS 的两个印刷问题已在本文附录脚注中处理，不能重复记为本文错误。

### 已核验

已按第 4–9 节展开的连接逐式核验：根移位与加权连续性；有限高斯公式与一粒子能量；有界/类型排除逼近；四类辅助收缩响应及编译顺序；回波的 \(o(r)\) 尺度和外部模式能量；固定电路迁移、正温路线及 MaxCut。文献表所列版本的相应定理/公式均已实际读取，仍作为注明的外部结果使用。三项改进的依据与计算证据范围分别列于上文和下表。

| Claim | Source | Basis | Evidence |
|---|---|---|---|
| 正号无序对 SK 的协方差为 \(nR^2/2-1/2\)，对应 \(\xi(t)=t^2/2\) | paper, §1、§3 | checked by hand | `guide/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026.md`，第 1 节 |
| 每个固定实角度门序列的热力学值存在，且具有二阶矩集中 | literature, FGGZ arXiv:1910.08187v4, §4 | conditional on a cited result (FGGZ v4 Theorem) | `sources/qaoa/arxiv-1910.08187v4.pdf` |
| 正树代价的 \(\sqrt D/2\) 边相关极限等于正 SK 值 | paper, §2 Fixed-word transfer；literature, BFMVZ v3 Theorem 1 | conditional on a cited result (BFMVZ v3 Theorem 1) | `sources/qaoa/arxiv-2110.14206v3.pdf`；`guide/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026.md`，第 8 节 |
| 在第 4 节的中心化、完整子树对称及固定高度等假设下，强收敛加激发数界给根移位能量及 \(L^2\) 连续性 | paper, §2 Energy as a root shift | checked by hand | `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/sections/02-foundations.tex`；本导读第 4 节 |
| 共同交换控制的代入不需非退化协方差，切边递推保留二阶相位和零输入基线 | paper, §2 Smooth gate calculus | checked by hand | `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/sections/02-foundations.tex`；本导读第 4 节 |
| 零温标量满支撑、自洽、值与有限系数极限为主路线输入 | paper, §3；companion Theorem 1.1、Corollary 7.1、Proposition 7.2 | conditional on a cited result (zero-temperature companion) | `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/sections/03-classical-optimization.tex` |
| 递归高斯坐标的联合分布精确且 \(\mathcal E(F_N)=\sum_{j=0}^NA_jB_{j+1}\) | paper, §3 A finite Gaussian formula and its rooted energy | checked by hand | `guide/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026.md`，第 5.2–5.3 节 |
| 有界列、三角逼近及类型排除给固定有限合成公式 | paper, §3 bounded approximation、type exclusion | checked by hand | `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/sections/03-classical-optimization.tex`；本导读第 5.4 节 |
| 辅助收缩须同时控制顶层切边和下层响应，固定辅助自旋先于有限对易子近似 | paper, §4 Simultaneous helper contraction | checked by hand | `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/sections/04-classical-synthesis.tex`；本导读第 6 节 |
| 局部辅助/种子 Pauli 恒等式、激发数系数、二阶相位及二次式真空范数，含五种拒绝测试 | paper, §§2、4、5；independent exact replay | checked by computation | `guide/evidence/qaoa-quantum/check.py`；`guide/evidence/qaoa-quantum/witness.json`；`guide/evidence/qaoa-quantum/check-output.json` |
| 带种子合成的能量损失为 \(2\eta+2\sqrt{p_H}\) | paper, §4 Classical synthesis | checked by hand | `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/sections/04-classical-synthesis.tex` |
| 种子回波用实际插入差和 \(o(r)\) 误差，外部模式另经一粒子式保能量 | paper, §5 One echo、Finite Gram induction | checked by hand | `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/sections/05-seed-simulation.tex`；本导读第 7 节 |
| 所有精度参数先固定、最后选单个普通门序列再取热力学极限 | paper, §6 | checked by hand | `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/sections/06-assembly.tex`；本导读第 8 节 |
| \(\lim_pQ_p=P_*\)，保留伴篇及固定电路迁移的文献依赖 | paper, Theorem 1.1 | conditional on a cited result (zero-temperature companion; FGGZ/BFMVZ) | `guide/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026.md`，第 4–8 节 |
| 正温区间支撑、正则性和自洽适用本文坐标 | literature, Lopatto arXiv:2607.11756v3 | conditional on a cited result (Lopatto v3 Theorem 1.1 and §2) | `sources/qaoa/arxiv-2607.11756v3.pdf`；本导读第 9.1 节 |
| 正温 Parisi 公式的协方差、光滑性、零外场及配分和约定满足 | literature, Talagrand 2006 Theorem 1.1 | conditional on a cited result (Talagrand Theorem 1.1) | `sources/qaoa/talagrand-2006.pdf`；本导读第 9.1 节 |
| 正温固定步数中心极限定理与边恒等式使用 EAMS 一般命题，不需其零温近最优假设 | paper, Appendix A Finite-step limit | conditional on a cited result (EAMS v2 Proposition 2.1 and Theorem 3.1) | `sources/qaoa/arxiv-2111.06813v2.pdf`；本导读第 9.1 节 |
| 正温连续极限、对称幂嵌入下的强收敛和截断补足经典路线 | paper, Appendix A | checked by hand | `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/sections/07-positive-temperature.tex` |
| 正温温度损失可收紧为 \(1/(4\beta_0)+h(\sqrt{1-\beta_0^{-1}})/\beta_0\) | ours, consequence of Appendix A proof | checked by hand | `guide/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026.md`，改进 1 |
| 保留中心化、有限半径、含种子的完整子树对称及固定有限高度嵌入强收敛，激发数条件可弱化为 \(\nu_D=o(\sqrt D)\)；另有 \(\lVert f_D\rVert\le1\) 时有改进 3 的有限度误差式 | ours, explicit consequence of §2 proof | checked by hand | `guide/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026.md`，改进 3 |
| 主定理结合固定电路集中给典型实例/测量的近最优性 | ours, direct corollary of FGGZ | conditional on a cited result (FGGZ v4 Theorem) | `sources/qaoa/arxiv-1910.08187v4.pdf`；本导读改进 2 |
| 大围长 MaxCut 用 \(2\gamma/\sqrt D\)，围长 \(>2p+1\) 的局部光锥足够 | paper, Corollary 1.2 first part | conditional on a cited result (main theorem; BFMVZ v3) | `paper/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026/build/sections/08-regular-maxcut.tex`；本导读第 9.2 节 |
| 随机正则图的顺序极限最优性还需短圈数依概率有界与最优割渐近 | paper, Corollary 1.2 second part | conditional on a cited result (DMS v2 Theorem 1.6(b); MWW Theorem 1) | `sources/qaoa/arxiv-1503.03923v2.pdf`；`sources/qaoa/mww-2004.pdf` |
| \(p=1\) 值为 \(\gamma\sin4\beta\,e^{-2\gamma^2}\)，最优 \(1/(2\sqrt e)\) | ours, hand example matching BFMVZ v3 Table 1 | checked by hand | `guide/QAOA-attains-the-SK-ground-state-energy-in-the-thermodynamic-first-limit-September-25-2026.md`，第 3 节 |
| 12 个有限树光锥的 \(p=1\) 门约定与公式浮点一致，36 个符号/因子负对照拒绝；非极限定理证据 | ours, numerical diagnostic | checked by computation | `guide/evidence/qaoa/diagnostics.py`；`guide/evidence/qaoa/diagnostics.json` |
| 作者 SKValue/FullSupport 的真实声明不含量子电路收敛，且未在本环境编译成功 | authors' actual definitions and selected theorems | checked by hand | `paper/lean/281.md`；`guide/evidence/lean-family-281/statement_fidelity.md`；`guide/evidence/lean-family-281/original-entry-verifier.log`；本导读第 10 节 |
| 固定作者源码的 347 模块导入闭包、355 blobs 与 Comparator 声明对应；非内核认证 | authors' sources; independent source check | checked by computation | `guide/evidence/lean-family-281/check_snapshot.py`；`guide/evidence/lean-family-281/source-manifest.json`；`guide/evidence/lean-family-281/source-check.json` |
