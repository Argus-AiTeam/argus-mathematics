本文的满相对支撑结论及标量推论通过了逐步手算与精确有理证书复算，证书常数还可加强约 8.59 倍。

# 零温 SK 满支撑论文中文导读

## 1. 准确主张与阅读入口

**对象必须这样理解。** 本文为 OpenAI，2026-09-27，*Full support of the zero-temperature Sherrington–Kirkpatrick order parameter*。上游固定为 `openai/math` 提交 `4eaee87548250b2682affda7d05d947c05554bae`；正文为本地 `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/` 内的 TeX，不把 README 的滚动 `main` 链接当版本锁。目录元数据保留在 `guide/evidence/full-support/pinned-build-directory.json`，用 `python3 guide/evidence/full-support/check_paper_sources.py` 可逐文件核对本地字节的 Git blob 与该固定来源。

对自旋配置 \(\sigma\in\{-1,1\}^n\) 和独立标准正态耦合 \(J_{ij}\)，零外场纯 SK 哈密顿量为
\[
H_n(\sigma)=\frac1{\sqrt n}\sum_{i<j}J_{ij}\sigma_i\sigma_j.
\]
基态问题研究其最大值除以 \(n\) 后的极限；本文关心描述该极限的变分极小元是否在每个重叠尺度上都有质量。

原文 §1，Theorem 1.1 的量词是：

\[
\mathcal U=\{\gamma:[0,1)\to[0,\infty):
 \gamma\text{ 非减、右连续},\ \int_0^1\gamma(t)\,dt<\infty\}.
\]

令局部有限 Stieltjes 测度满足
\[
\mu_\gamma([0,t])=\gamma(t),\qquad \mu_\gamma(\{0\})=\gamma(0).
\]
它**不要求是概率测度，且容许总质量无穷**。支撑一律指半开空间 \([0,1)\) 的相对支撑；\(1\) 不属于本定理，另加 \(c\delta_1\) 不改变本泛函，不能由它识别端点质量。零外场纯 SK 归一化固定为 \(\xi(t)=t^2/2\)，故 \(\xi''=1\)。定义
\[
\Phi_t=-\tfrac12(\Phi_{xx}+\gamma\Phi_x^2),\quad
\Phi(1,x)=|x|,\qquad
\mathcal P(\gamma)=\Phi_\gamma(0,0)-\tfrac12\int_0^1t\gamma(t)\,dt,
\]
其中解由原文的有界控制表示或单调阶梯逼近定义。零温 Parisi 公式及其极小值取得定理给出
\[
P_*:=\lim_{n\to\infty}\frac1n\mathbb E\max_{\sigma\in\{-1,1\}^n}H_n(\sigma)
=\min_{\gamma\in\mathcal U}\mathcal P(\gamma);
\]
所用外部定理见 §6。对**每一个达到 \(\inf_{\mathcal U}\mathcal P\) 的 \(\gamma\)**，令 \(B\) 为标准布朗运动，并定义
\[
dX_t=\gamma(t)\Phi_x(t,X_t)\,dt+dB_t,\quad X_0=0,\quad
q(t)=\mathbb E\Phi_x(t,X_t)^2.
\]
则
\[
\operatorname{supp}_{[0,1)}\mu_\gamma=[0,1),\qquad
q(t)=t,\quad \mathbb E\Phi_{xx}(t,X_t)^2=1\quad(0\le t<1).
\]
因此 \(\gamma(b)>\gamma(a)\) 对所有 \(0\le a<b<1\) 成立。上述支撑定理以极小性为前提，不涉及唯一性，也不扩张到非零外场或混合协方差。

原文后续 Corollary 6.4 还给出 \(\gamma(0)=0\)、\(\gamma\in C^\infty([0,1))\)、\(\mu_\gamma=\gamma'(t)\,dt\) 及 \(\gamma'(t)>0\) 对 \(0<t<1\)。在零点，原文只声明 \(\gamma'(0)\ge0\)，不是严格正。§7 的有限高斯系数是一个标量逼近结论，不等于有限自旋算法或量子电路已经实现。

### 十五分钟路线

问题的意义：Parisi 公式给出基态值，但并不自动告诉人层级重叠尺度之间有没有空洞。可数无限支撑仍可能处处留空；满支撑则使变分接触条件在每一时刻饱和，提供消息传递及另一篇 QAOA 论文所需的精确二阶矩归一化。本文不是首次宣称同一满支撑结论：Chen 的 2026 年预印本 Theorem 1.3 已给出满支撑与光滑绝对连续性；本文改变的是证明机制，并证明密度在每个正时刻严格正。

| 位置 | 做什么 | 首读建议 |
|---|---|---|
| §1，`main.tex` | 精确定义、主定理和文献定位 | 必读模型及证明结构 |
| §2，`regularity.tex` | 从终端尖点构造解，证明紧时条上全空间导数稳定和扩散稳定 | 记住逼近可保留平台，第二遍核估计 |
| §3，`signs.tex` | 后向漂移与前向得分的形状、比值符号和尾界 | 最难部分；见本导读 §4 |
| §4，`certificate.tex` | 精确有理恒等式及积分强制性估计 | 首读看“零期望散度 + 非负余项”，可略过 22 项表 |
| §5，`curvature.tex` | 把有限阶梯证书传给任意可积系数的平台 | 不必传递得分本身，是重要简化 |
| §6，`variation.tex` 及 `order-parameter-regularity.tex` | 接触势、端点、无隙、一致性、光滑正密度 | 支撑定理的逻辑骨架 |
| §7，`consequences.tex` 及 `algorithm-application.tex` | 标量价值、有限高斯系数、调用既有算法定理 | 与 QAOA 对接时必读 |

### 短符号表

| 符号 | 含义 |
|---|---|
| \(u=\Phi_x,\ a=\Phi_{xx}\) | 一阶和二阶空间导数；\(u(t,X_t)\) 是有界鞅 |
| \(q,\ G(s)=\int_s^1(q(t)-t)\,dt\) | 梯度二阶矩与变分接触势 |
| 平台 \(c>0\) 上 \(l=c\Phi,\ r=c\Phi_x,\ v=r_x,\ w=r_{xx},\ z=r_{xxx}\) | 曲率计算的缩放变量；尤其 \(v=ca\)，不能遗漏 \(c^{-2}\) |
| \(f=e^l g,\ s=-\partial_x\log g\) | 扩散密度、前向热因子及其得分；这里 \(s\) 不再是时间 |
| \(H=r_\tau/r,\ \tau\) | 后向时间的相对变化率，不是哈密顿量 |
| \(R=r^2,\ K=rs,\ b=-w/r,\ j=s_x-(s/r)v\) | 证书变量；这里 \(b\) 不是间隙右端点 |
| \(B=b-2v,\ S=z+bv-2Rb,\ L=-rs_{xx}\) | 三个非负证书变量；这里 \(B\) 不是布朗运动 |

## 2. 核心直觉和最小例子

**变分负责端点，曲率负责区间内部。** 极小元允许在任意时刻添加 Stieltjes 质量，也允许移除紧集上的既有质量，因此 \(G\ge0\) 且在支撑上 \(G=0\)。若两接触点 \(a<b\) 之间没有质量，则 \(\gamma=c\) 不变。端点给 \(q(a)=a,\ q(b)=b,\ q'(a),q'(b)\le1\)。若 \(q'\) 在正平台上严格凸，它在内部严格低于端点弦，故低于 \(1\)；积分便与 \(q(b)-q(a)=b-a\) 矛盾。

难点完全在“严格凸”：直接 Itô 得到
\[
q'''=c^{-2}\mathbb E(z^2-12vw^2+6v^4),
\]
其负项不能凭 \(\Phi\) 凸性逐点控制。本文借前向密度加入一个期望为零的空间散度，把期望改写成平方与非负单项式的和。

**最小可算例：\(\gamma\equiv0\)，它不是极小元。** 记 \(F_{\rm G}\) 为标准正态分布函数。此时
\[
X_t=B_t,\quad u(t,x)=2F_{\rm G}(x/\sqrt{1-t})-1,\quad
a(t,x)=\sqrt{\frac2{\pi(1-t)}}e^{-x^2/(2(1-t))}.
\]
两个独立终端噪声共享 \(B_t\)，对应相关系数 \(t\) 的两个标准正态；其同号区域的高斯角度计算给
\[
q_0(t)=\frac2\pi\arcsin t,\qquad
q'_0(t)=\frac2{\pi\sqrt{1-t^2}}=\mathbb E a(t,B_t)^2.
\]
例如 \(q_0(1/2)=1/3<1/2\)。在 \(0<t<1\)，严格凸的 \(\arcsin\) 曲线在连接两端的弦下，故 \(G_0(s)<0\) 对 \(s<1\) 成立，添加质量确实能降值。这里还可直接看出
\[
1-q_0(t)\sim\frac{2\sqrt2}{\pi}\sqrt{1-t},
\]
解释了为何终端尖点产生平方根边界层，而不是一个可忽略的小线性误差。

**数值只作归一化校验。** 零系数给 \(\mathcal P(0)=\sqrt{2/\pi}=0.797884560803\)。常系数 \(c>0\) 的 Cole–Hopf 公式精确给
\[
\mathcal P(c)=\frac c4+\frac{\log(2F_{\rm G}(c))}{c}.
\]
取明确可行的 \(c=4/5\)，得到 \(0.768841848671\) 的试探上界显示值。Montanari，arXiv:1812.10897v2，§1.1（印刷第 4 页）报告同一 GOE/纯 SK 归一化下的数值基准 \(P_*\approx0.763166\)；这与上述上界方向一致。`python3 guide/evidence/full-support/scalar_diagnostic.py` 可重放显示值，但不是对 \(P_*\) 的新计算或误差认证，不能用常系数试探代替真正极小元。

## 3. 承重链前半：正则化、鞅与接触

以下展开原文的正则化、鞅与接触条件推导。

### 3.1 尖点和无界系数：只在 \(T<1\) 上估计

Lemma 2.1 先用终端
\(\psi_M=M^{-1}\log(2\cosh Mx)\)，满足
\(0\le\psi_M-|x|\le(\log2)/M\)，与非负非减有限阶梯 \(\gamma_n\)。记 \(P_h\) 为方差 \(h\) 的热半群：
\[
P_hF(x)=\mathbb EF(x+\sqrt h\,Z),\quad Z\sim N(0,1),\qquad
p_h(x)=\frac{e^{-x^2/(2h)}}{\sqrt{2\pi h}}\quad(h>0)
\]
其中 \(p_h\) 为卷积核。常系数区间的演化是
\[
\Phi(t)=c^{-1}\log P_{b-t}e^{c\Phi(b)}\ (c>0),\qquad
\Phi(t)=P_{b-t}\Phi(b)\ (c=0).
\]
保持偶性、凸性和一 Lipschitz。控制表示比较同一控制可得
\[
\|\Phi_{\gamma,\psi}-\Phi_{\widetilde\gamma,\widetilde\psi}\|_\infty
\le\|\psi-\widetilde\psi\|_\infty+\tfrac32\|\gamma-\widetilde\gamma\|_1.
\]
虽然单个函数线性增长，差的上确界仍有限。终端误差有全空间界
\[
0\le\Phi_\gamma(t,x)-|x|
\le\sqrt{2(1-t)/\pi}+\tfrac12\int_t^1\gamma.
\]
不在 \(t=1\) 声称空间高阶光滑。

单调性给任意 \(b<1\) 上
\(\gamma(t)\le\|\gamma\|_1/(1-b)\)。对 Burgers 方程的热半群积分形式求梯度，并用
\(\|\partial_xP_hF\|_\infty\le C h^{-1/2}\|F\|_\infty\)，得到
\[
\|u_x(t)\|_\infty\le C(b-t)^{-1/2}
+C\Gamma\int_t^b(s-t)^{-1/2}\|u_x(s)\|_\infty\,ds.
\]
卷积两次的核为常数 \(\pi\)，故归结为普通 Gronwall；在逐次缩小的时条上归纳可控任意空间阶数。再对差函数用
\[
\|F'\|_\infty\le2\|F\|_\infty/h+(h/2)\|F''\|_\infty
\]
逐阶插值，得**全空间一致**导数收敛，不只是紧空间集收敛。所有常数只依赖固定时条和共同 \(L^1\) 界，不依赖阶梯网格或后面人工平台的宽度。

Lemma 2.2 的扩散在紧时条上有共同空间 Lipschitz 漂移，耦合同一布朗运动用 Gronwall 得路径一致收敛；\(\int_0^1\gamma<\infty\) 又让路径延伸到 \(1\)。Itô 漂移相消给
\[
u(t,X_t)=\int_0^t a(s,X_s)\,dB_s,\qquad q'(t)=\mathbb E a(t,X_t)^2.
\]
偶性与 \(X_0=0\) 保证初值为零；有外场时不能照搬。

Lemma 2.3 的平台保持不可省：在真实平台内部先固定一个闭子区间，左右分别截断、阶梯化，给趋零的正下截断，同时原样保留 \(c>0\)，再取 \(M_n\ge\|\gamma_n\|_\infty\)。于是可应用下一节的正阶梯证书，又不破坏所考察时刻的系数值。

### 3.2 任意可行方向的一阶变分

Lemma 6.1 适用于任意可行可积方向。若 \(\eta\in L^1\)，且 \(\beta=\gamma+\epsilon\eta\in\mathcal U\)，相减偏微分方程并令辅助扩散漂移为 \(\frac12\beta(\widetilde u+u)\)，得到精确差分
\[
\frac{\Phi_\beta(0,0)-\Phi_\gamma(0,0)}{\epsilon}
=\frac12\int_0^1\eta(t)\mathbb E u(t,Y_t^\epsilon)^2\,dt.
\]
先在 \(T<1\) 用已证稳定性做 Itô，再用
\(\|(\Phi_\beta-\Phi_\gamma)(T)\|_\infty
\le\frac32\int_T^1|\beta-\gamma|\)
消掉终端项。令 \(\epsilon\downarrow0\)，以 \(|\eta|\) 支配，故
\[
D\mathcal P(\gamma)[\eta]=\tfrac12\int_0^1\eta(t)(q(t)-t)\,dt.
\]
没有把尖点处的终端导数当作经典导数使用。

### 3.3 无穷 Stieltjes 质量不妨碍接触势

添加一个 \(s\) 处原子对应 \(\eta=\mathbf1_{[s,1)}\)，故极小性给 \(G(s)\ge0\)。移除既有质量时，原文只取紧集 \(K\subset[0,1)\)，令 \(\nu=\mu_\gamma|_K\)、\(\eta_K(t)=-\nu([0,t])\)。这是有界可行方向，且
\[
0\le D\mathcal P[\eta_K]=-\tfrac12\int_KG(s)\,\mu_\gamma(ds)\le0.
\]
Fubini 由 \(\nu(K)<\infty\) 与 \(|q-t|\le1\) 保证；**不曾假设 \(\mu_\gamma([0,1))<\infty\)**。连续性随后给 \(G=0\) 于相对支撑。由于 \(G'=t-q\)、\(G''=1-q'\)，内部接触点给 \(q=t,\ q'\le1\)。

在 \(0\in\operatorname{supp}\mu\) 时，单侧最小值本身不足以直接令二阶导数非负；这里还用 \(q(0)=0\)，展开
\[
G(h)=\tfrac12(1-q'(0))h^2+o(h^2)\ge0,
\]
才得到端点条件 \(q'(0)\le1\)。

## 4. 承重链核心：形状符号为何足以给曲率

### 4.1 后向形状、前向得分及跳跃

这一节先只对**固定的正、有界、非减有限阶梯**和 \(M\ge\|\gamma\|_\infty\) 的光滑终端论证。不能把结论未经极限就套给任意可积系数。

后向时间下 \(r_\tau=\frac12r_{xx}+rr_x\)。原文 Lemma 3.2 证明 \(r\) 奇、\(v>0\)，并在 \(x>0\) 得
\[
w\le0,\qquad H=\frac{w}{2r}+v\le0,\qquad H_x\ge0.
\]
终端 \(r=c\tanh Mx\) 使
\(H=(cM-M^2)\operatorname{sech}^2(Mx)\le0\)，这说明 \(M\ge c\) 的条件确实在用。\(w\) 满足线性抛物方程
\(w_\tau=\frac12w_{xx}+rw_x+3vw\)，故其符号由比较原则保持。对 \(H\) 和 \(H_x\)，关键方程为
\[
H_\tau=\tfrac12H_{xx}+(v/r+r)H_x+vH,
\]
\[
(H_x)_\tau=\tfrac12(H_x)_{xx}+(v/r+r)(H_x)_x+
((v/r)_x+2v)H_x+wH.
\]
源项 \(wH\ge0\)，且 \((v/r)_x=w/r-v^2/r^2<0\)。反向跨跳跃 \(r_{\rm new}=\alpha r_{\rm old}\)，\(0<\alpha\le1\)，则
\(H_{\rm new}=H_{\rm old}-(1-\alpha)v_{\rm old}\)，
\((H_x)_{\rm new}=(H_x)_{\rm old}-(1-\alpha)w_{\rm old}\)，恰好保持两种符号。

正向上 \(f=e^{c\Phi}g\) 使 \(g_t=\frac12g_{xx}\)，初步 \(g=p_t/e^{c\Phi(0,0)}\)，所以 \(s=x/t\)。在系数增加 \(\delta\) 的跳点，
\[
g_+=g_-e^{-\delta\Phi},\quad
s_+=s_-+\delta\Phi_x,\quad
(s_x)_+=(s_x)_-+\delta\Phi_{xx}.
\]
Lemma 3.3 对 \(s_t=\frac12s_{xx}-ss_x\) 使用比较原则，得
\[
s_x\ge1/t,\qquad s_{xx}\le0\quad(x>0).
\]
真正新增的配合符号是 \(j=r\partial_x(s/r)\ge0\)，单有两个函数各自的凹性不足以推出它。设
\(\rho=s_x/s-r_x/r\)，则 \(j=s\rho\)，而
\[
\rho_t=\tfrac12\rho_{xx}+(s_x/s)\rho_x+
(r_x/r)_x\rho+2H_x-w-s_{xx}.
\]
源项非负、零阶系数严格负；初步由凹性 \(r(x)\ge xv(x)\) 给
\(\rho=1/x-v/r\ge0\)。跨正跳时直接相消给 \(j_+=j_-\)，于是比较可逐步传递。

### 4.2 零点和无穷远：不能略去的分析假设

**在零点不是除以一个非零的 \(r(0)\)。** \(r,s,w\) 都是奇函数，固定闭时间步上 \(r(x)=v(0)x+O(x^3)\)、\(v(0)>0\)，且 \(s(x)=s_x(0)x+O(x^3)\)、\(s_x(0)\ge1/t\)。故 \(w/r,\ s/r\) 光滑偶延拓，\(\rho=O(x)\)、\(j(0)=0\)。对含 \(v/r\sim1/x\) 的 \(H\) 方程，原文通过三维径向提升把 \(\frac12H_{xx}+x^{-1}H_x\) 变为 \(\frac12\Delta\)，再在球上比较。对 \(H_x,\rho\) 则在 \([\varepsilon,A]\) 比较，其零阶上界与 \(\varepsilon,A\) 无关，最后两端耗尽。因而没有把奇点悄悄抹掉，也没有要求一阶漂移在耗尽区间上一致有界。

**尾界在形状比较之前独立建立。** Lemma 3.1 从高斯卷积、指数倾斜和有限次跳跃归纳出带任意固定有限阶导数的尾展开：
\[
c\Phi=cx+C+O(e^{-\kappa x}),\quad
g=e^{-x^2/(2t)+\beta x+C_0}(1+O(e^{-\kappa x})).
\]
它们只需对固定阶梯数据成立，不需随逼近统一。于是
\(s=x/t+O(1)\)、\(K=O(1+|x|)\)，而 \(v,w,z,b\) 指数衰减，\(j=1/t+O((1+x)e^{-\kappa x})\)。特别
\[
f\le C e^{-x^2/(2t)+C|x|}.
\]
证书多项式 \(F_2\) 及其微分表达式最多多项式增长，故所有项绝对可积，\(rfF_2\to0\) 于正负无穷。这个先后顺序排除了“用尚未证出的形状符号来证明消边界”的循环。

### 4.3 从有理恒等式到正平台严格曲率

定义 \(\mathcal D=r\partial_x\)、\(\mathcal W(F)=\mathcal DF+(v+R-K)F\)。因为 \(f_x/f=r-s\)，
\[
f\mathcal W(F)=\partial_x(rfF),\qquad \mathbb E_f\mathcal W(F_2)=0.
\]
原文全部符号 \(R,K,v,B,j,L,S\) 非负，且 \(b=B+2v\)、\(Rb^2=w^2\)。`certificate.tex` 的 Lemma 4.1 是有理多项式**恒等式**，不是数值拟合：
\[
z^2-12Rvb^2+6v^4
=(z+Q)^2+ST+\sum_{i=0}^4p_iP_i+\mathcal W(F_2)
+L(x_0v^2+hbv)+P_{\rm rem}.
\]
\(T=v(g_0R+hj)\ge0\)；五个平方的前因子分别为 \(Rj,RB,Kv,vB,1\)，余式 22 项的系数全正。可积和消边界已由 §4.2 核验，积分后才可以丢掉 \(\mathcal W(F_2)\)。原文 Proposition 4.2 实际已经给出
\[
\mathbb E(z^2-12vw^2+6v^4)
\ge\kappa_0\mathbb Ev^4,\qquad
\kappa_0=\frac{1661507}{1521000000}>10^{-3}.
\]
因此仅恢复 \(\kappa_0\) 不算超出原文的改进。

已执行 `python3 guide/evidence/full-support-certificate/audit.py`，从空间导数变量的定义重建微分规则、展开 \(\mathcal W(F_2)\)、检查 \(L\) 修正、代入 \(b=B+2v\)，逐项恢复原文全部 22 个有理系数；未列项确为零。改系数、漏项、重项、翻转 \(F_2\) 参数、翻转 \(\mathcal Dj\) 的 \(L\) 号、翻转 \(S\) 的号、错代 \(B\)、夸大强制性估计常数等九类损坏均被拒绝。

在任意真实正平台上，使用 §3.1 的平台保持逼近，将两边**只含 \(\Phi\) 前四阶空间导数的期望**传到极限；不需要密度得分、比值或尾常数一致收敛。正性另由平台内 Cole–Hopf 公式的
\[
\Phi_{xx}(t,x)=\mathbb E_{\rm tilt}\Phi_{xx}(b,Y)
+c\operatorname{Var}_{\rm tilt}(\Phi_x(b,Y))>0
\]
给出：倾斜高斯密度处处正，而凸函数 \(\Phi(b,\cdot)\) 与 \(|x|\) 相差有界，导数不可能常值。沿扩散，
\[
dr=v\,dB,\quad dv=-v^2dt+w\,dB,\quad dw=-3vw\,dt+z\,dB.
\]
对 \(v^2\)、再对 \(w^2-2v^3\) 用 Itô，分别产生系数 \(-2\) 和 \(-12,6\)，所以
\[
q'''=c^{-2}\mathbb E(z^2-12vw^2+6v^4)
\ge10^{-3}c^{-2}\mathbb Ev^4>0.
\]
零平台必须单做：热方程给 \(q''=\mathbb E\Phi_{xxx}^2>0\)。扩散在该区间经过正时间的无漂移高斯转移后有处处正密度；若 \(\Phi_{xxx}\equiv0\)，\(\Phi\) 将是偶二次多项式，与一 Lipschitz 及 \(\Phi-|x|\) 有界矛盾。

## 5. 全部间隙、正密度与标量输出

### 5.1 终端、初始与内部三种间隙

末端平台不能仅从内部凸性处理，因为 \(1\) 不是支撑空间中的接触端点。Lemma 6.3 假定 \(\gamma=c<\infty\) 于 \((a,1)\)，取固定 \(s>a\)。当 \(c>0\)，令
\(h(t,y)=\mathbb E e^{c|y+\sqrt{1-t}Z|}\)，转移核为
\[
k_{s,t}(x,y)=p_{t-s}(y-x)\frac{h(t,y)}{h(s,x)}.
\]
这是有界漂移 \(h_x/h\) 的 Doob 热变换；\(c=0\) 时令 \(h=1\)。只需 \(X_s\) 在某有限区间有正概率，不假设它已有密度，就能在靠近 \(1\) 时对 \(|y|\le1\) 得到 \(f_t(y)\ge m>0\)。在 \(|y|\le\sqrt{1-t}\) 的边界层内，正、负终端符号在指数倾斜下各有统一正概率，故 \(1-u(t,y)^2\ge\kappa>0\)。积分给
\[
1-q(t)\ge C\sqrt{1-t},\qquad
q(t)-t\le(1-t)-C\sqrt{1-t}<0.
\]
于是靠近终点 \(G<0\)，矛盾。这同时排除空支撑和零末端平台。

剩下的内部间隙端点属于支撑，§2 的弦线积分矛盾直接适用；若常数为零，用 \(q'\) 严格递增代替严格凸。若 \(0\) 不在支撑，初始间隙为 \([0,b)\)，它没有零点原子，所以 \(\gamma=0\)，结合 \(q(0)=0,\ q(b)=b,\ q'(b)\le1\) 同样矛盾。如果 \(0\) 在支撑但右边有间隙，已证的单侧 \(q'(0)\le1\) 刚好补齐端点条件。这样才排尽相对闭集补集的全部分支。

满支撑使接触条件成为处处 \(q=t\)，由紧时条 \(C^1\) 正则性得处处 \(\mathbb Ea^2=1\)，包括零点右导数。

### 5.2 光滑性不是从严格递增猜出来的

令此处 \(a=\Phi_{xx},\ b=\Phi_{xxx},\ d=\Phi_{xxxx}\)。沿扩散
\(da=-\gamma a^2dt+b\,dB\)，故一致性给几乎处处
\[
\mathbb Eb^2=2\gamma\mathbb Ea^3,\qquad
\gamma(t)=\frac{\mathbb Eb(t,X_t)^2}{2\mathbb Ea(t,X_t)^3}.
\]
因 \(a\ge0,\ \mathbb Ea^2=1\)，分母至少为 \(2\)。空间导数矩先已连续，商连续，结合 \(\gamma\) 右连续才把几乎处处相等提升为处处相等；在零点 \(b(0,0)=0\)，所以 \(\gamma(0)=0\)。

对所有有限空间导数的多项式矩同时用 Itô，导数仍是若干同类矩与 \(\gamma\) 的线性组合：连续性先给所有矩 \(C^1\)，商式给 \(\gamma\in C^1\)，同步归纳得到 \(C^\infty\)。这不是先假设 \(\gamma\) 可微再倒推它光滑。

又有
\[
2\gamma'\mathbb Ea^3
=\mathbb Ed^2-12\gamma\mathbb E(ab^2)+6\gamma^2\mathbb Ea^4.
\]
固定 \(t>0\)，将 \(\gamma\) 在缩小邻域内替换为 \(c=\gamma(t)>0\)，左右分别阶梯化；单调性保持，且改动趋零于 \(L^1\)。前四阶导数的一致稳定不依赖平台宽度，因此平台证书可在这个**固定时刻**传极限，给
\[
2\gamma'(t)\mathbb Ea^3\ge10^{-3}\gamma(t)^2\mathbb Ea^4>0.
\]
这是点态正密度，不是仅由满支撑或严格递增就能推出的结论。

### 5.3 标量价值和有限高斯系数

Corollary 7.1：有界鞅 \(u(t,X_t)\) 收敛到 \(U_1\)，\(\mathbb EU_1^2=\lim q(t)=1\) 与 \(|U_1|\le1\) 给 \(U_1^2=1\)。不必假设 \(X_1\ne0\)：凸函数差商与全空间终端收敛给 \(U_1X_1=|X_1|\)，在 \(X_1=0\) 也成立。先由 Itô 价值恒等式得到第一式；再将 \(X_1=B_1+\int_0^1\gamma u\) 两边乘 \(U_1\) 取期望，利用鞅条件期望得到第二式；最后由随机积分的协方差恒等式得到第三式。
\[
P_*=\mathbb E|X_1|-\int_0^1t\gamma(t)\,dt
=\mathbb E[U_1B_1]=\int_0^1\mathbb Ea(t,X_t)\,dt.
\]
尾积分绝对可控，因为 \(0\le\mathbb Ea\le(\mathbb Ea^2)^{1/2}=1\)。

**从原证明提取的定量接口。** 以下标量约束和网格误差界是原文公式与估计的直接推论。取二阶导数半鞅的期望，由 \(a(0,0)=1\) 和 \(\mathbb Ea^2=1\)，对 \(t<1\) 有
\[
m(t):=\mathbb Ea(t,X_t)=1-\int_0^t\gamma(s)\,ds.
\]
因此 \(\|\gamma\|_1\le1\)，并由 Tonelli 得
\[
P_*=1-\int_0^1(1-s)\gamma(s)\,ds.
\]
这提供了另一个检查数值极小元的标量约束，但不推出 \(\|\gamma\|_1=1\)。\(m\) 非负非增，故明确的价值截断误差是
\[
0\le P_*-\int_0^Tm(t)\,dt\le(1-T)m(T)\le1-T,\qquad
\mathbb E[U_1-u(T,X_T)]^2=1-T.
\]
这些界可用于选择截断时间与检查数值极小元。

Proposition 7.2 必须**先固定 \(T<1\)、令网格数 \(N\to\infty\)，然后 \(T\uparrow1\)**。取独立标准正态变量 \(Z_1,\ldots,Z_{N+1}\)，令 \(\Delta=T/N,\ t_j=j\Delta\)，初值 \(Y_0=0\)，Euler 状态为
\[
Y_j=Y_{j-1}+\sqrt\Delta Z_j+
\Delta\gamma(t_{j-1})u(t_{j-1},Y_{j-1}),
\]
并取 \(c_j=(\mathbb Ea(t_{j-1},Y_{j-1})^2)^{-1/2}\)、
\(g_j=c_ja(t_{j-1},Y_{j-1})Z_j\)。扩散强收敛给 \(c_j\to1\) 一致；\(g_j\) 在 \(L^2\) 正交归一，**一般不独立，也不是标准正态变量**。用额外独立的 \(Z_{N+1}\) 令
\[
F_N=\operatorname{sgn}\{u(T,Y_N)+2F_{\rm G}(Z_{N+1})-1\}.
\]
若 \(U\) 均匀分布于 \((0,1)\)，\(\mathbb E\operatorname{sgn}(v+2U-1)=v\)，所以该舍入精确保留对前 \(N\) 个坐标的所有相关。

写 \(A_j=\mathbb EF_Ng_j,\ B_i=\mathbb EF_NZ_i,\ A_0=0\)。离散鞅
\(M_N=\sum\sqrt\Delta\,a(t_{j-1},Y_{j-1})Z_j\)
与 \(u(T,Y_N)\) 在 \(L^2\) 相差 \(o(1)\)。对两套正交归一系用 Bessel，而不是把逐坐标 \(o(1)\) 直接相加，得
\[
(A_j)=(\sqrt\Delta/c_j)+o_{\ell^2}(1),\qquad
(B_i)_{i\le N}=(\sqrt\Delta\,\mathbb Ea(t_{i-1},Y_{i-1}))+o_{\ell^2}(1).
\]
故移位乘积的误差由 Cauchy–Schwarz 控制；最后一个额外舍入坐标满足
\(|A_NB_{N+1}|\le|A_N|=o(1)\)。于是
\[
\sum_{j=0}^N A_jB_{j+1}\longrightarrow\int_0^T\mathbb Ea(t,X_t)\,dt
\longrightarrow P_*.
\]
这正是 QAOA 论文所需的标量输入；辅助量子位收缩与去除随机种子仍须由该文的量子实现证明。

**固定时条的网格误差也可定量。** 对固定 \(T<1\)，取原文空间和时间 Lipschitz 界，用相同的漂移相减/Gronwall 估计可得
\(\|\max_j|Y_j-X_{t_j}|\|_2\le C_T\sqrt\Delta\)：局部状态变动的 \(L^2\) 量为 \(O(\sqrt\Delta)\)，而单调系数左端点求积的累计误差不超过
\(\Delta(\gamma(T)-\gamma(0))\)。于是
\[
\max_j|c_j-1|\le C_T\sqrt\Delta,\qquad
\|u(T,Y_N)-M_N\|_2\le C_T\sqrt\Delta.
\]
第二式是 Itô 等距加上 \(a\) 的 Lipschitz 界。上面的两套 Bessel 余差随之都是 \(O_T(\sqrt\Delta)\)，末项也有 \(|A_N|\le C_T\sqrt\Delta\)；主 Riemann 和的误差由 \(m'=-\gamma\)、状态强误差与归一化误差控制。因此存在依赖固定时条与导数界、但不依赖 \(N\) 的 \(C_T,N_T\)，使 \(N\ge N_T\) 时
\[
\left|\sum_{j=0}^N A_jB_{j+1}-P_*\right|
\le (1-T)m(T)+C_T\sqrt{T/N}.
\]
这里没有给出 \(T\uparrow1\) 时 \(C_T\) 的统一增长率，不能反推关于最终精度的多项式复杂度。

## 6. 外部结果：哪些是依赖，哪些只是前史

**主支撑证明的分析工具、变分、端点及曲率均在本地正文重证。** 真正外接的是把泛函极小值解释为 SK 基态值的 Parisi 定理，以及 §7.3 的有限无序算法定理。后者并非由标量系数命题单独推出。

| 来源、固定版本与编号 | 假设、本文用途及本次读取范围 |
|---|---|
| Auffinger–Chen，arXiv:1606.05335v2，Theorem 1、Lemma 3 的证明 | 已读原文。其 \(\mathcal U\) 与这里相同，末端是 \(|x|\)；Theorem 1 写的是下确界，Lemma 3 构造 \(\gamma_0\in\mathcal U\) 并证明 \(GSE\ge\mathcal P(\gamma_0)\)，结合上界才证明极小值取得。取零场、\(\xi=t^2/2\)。期望最大值的收敛用高斯 Lipschitz 浓缩补齐。源件在 `guide/evidence/full-support/sources/AC2017/`。 |
| Chen–Handschy–Lerman，arXiv:1609.04368v4，Proposition 2、Theorem 5、Lemma 3、Propositions 3–4 | 已读这些命题的原文及其附近证明。空间正则、控制、梯度鞅、二阶导数半鞅和方向导数的零温接口与本文吻合；取 \(\xi''=1,h=0\)。原文部分逼近细节略写，本论文 §2、§6 已自行展开。其 Theorem 4 还给唯一性，但不是本论文满支撑定理的前提或本文新结论。源件在 `guide/evidence/full-support/sources/CHL2018/`。 |
| Auffinger–Chen–Zeng，arXiv:1703.06872v2，Theorem 1、Remark 7 | 已读原文。Theorem 1 对混合模型给无限支撑，Remark 7 明说不能在 \(1\) 附近平坦且省略连续前段的细节。本文 Lemma 6.3 独立完成端点边界层，不从无限支撑错误推出内部无隙。源件在 `guide/evidence/full-support/sources/ACZ2017/`。 |
| Hong-Bin Chen，arXiv:2607.18032v1，Theorem 1.3、Proposition 4.6、Lemma 3.14 与 Appendix B.6；Proposition 4.2 | 已读对应原文。归一化和零点原子约定相同；Theorem 1.3 已有满支撑、无原子/奇异连续部分及光滑非负密度。Proposition 4.6 与 B.6 用饱和一致性和矩商逐阶提升正则性。Proposition 4.2 仅给“\(\Gamma''=0\Rightarrow\Gamma'''>0\)”的过零曲率条件，弱于本文在全部正平台上的无条件强制性估计。未重审该文其余全部证明。源件在 `guide/evidence/full-support/sources/Chen2026/`。 |
| El Alaoui–Montanari–Sellke，arXiv:2001.00904v1，Assumption 2、Theorem 3、Corollary 2.2、Remark 2.1；§6.3 | 已读这些原文段落。实质外部算法依赖是存在严格递增的零温极小元，输入为其高斯混合模型；\(\xi=t^2/2\) 满足其解析协方差假设。Corollary 2.2 的严格递增假设由本文验证，§6.3 用饱和一致性把该极小元提升为扩大的非单调类 \(\mathcal L\) 上的极小元，再调用 Theorem 3；因此不需另设 \(\mathcal L\) 的极小值取得假设。操作数为 \(C(\epsilon)(\chi+n)+n\chi_1\)，实数加乘单位成本；不包含本文未分析的预处理与位复杂度。该版本正文有若干残留交叉引用“Theorem 3.2”，陈述标题实际编号为 Theorem 3。原件 `sources/qaoa/arxiv-2001.00904v1.pdf` 为共享固定来源。 |
| Montanari，arXiv:1812.10897v2，§§1.1、2–3、Remark 1.2 | 已读前述数值基准和计算模型段落；这里只作方法前史和 \(P_*\approx0.763166\) 的归一化对照。其正温区间支撑 Assumption 1 不能用零温满支撑直接替换，标量函数查询的成本另按其计算模型约定。源件在 `guide/evidence/full-support/sources/Montanari2019/`。 |

原文其余文献的作用是定位，不承担本次证明中未展开的接口：Boué–Dupuis (1998)、Bovier–Klimovsky arXiv:0802.3467v2 §6.2，Auffinger–Chen arXiv:1402.5132v3，Jagannath–Tobasco arXiv:1502.04398v4 是控制/凸性前史；Jagannath–Tobasco arXiv:1504.02731v2 Proposition 1.1、Lemma 3.2、Corollaries 3.6、3.10 是正温接触条件的先例；Auffinger–Chen arXiv:1303.3573v1 Lemma 2、Theorem 2(ii) 是多项式矩方法的先例。这些原件此次未逐篇取得并重核，所需公式已经在 §3–5 直接核算。

Sherrington–Kirkpatrick (1975)、Parisi (1979, 1983)、Guerra (2003)、Talagrand (2006) 属历史来源；Zhou (2026) Theorem 1、Lopatto arXiv:2607.11756v3 Theorem 1.1 及 Proposition 9.1 属正温比较，本文不依赖“正温满支撑经弱极限自动保留”。未独立核其全部原文与优先权，不将本文书目自身当作优先权证据。例如 \(\nu_n=n^{-1}\operatorname{Unif}[0,1]+(1-n^{-1})\delta_1\) 各自满支撑而弱收敛到 \(\delta_1\)，满区间支撑一般不通过弱极限保留。

§7.3 的归一化也已手核：补独立对角元 \(A_{ii}=\sqrt{2/n}G_i\)，非对角元 \(A_{ij}=J_{ij}/\sqrt n\)，则
\[
\widehat H_n(\sigma)=\tfrac12\sigma^\mathsf TA\sigma
=H_n(\sigma)+(2n)^{-1/2}\sum_iG_i,
\]
对两配置 \(\sigma,\tau\)，记重叠 \(R_{12}=n^{-1}\sum_i\sigma_i\tau_i\)，其协方差恰为 \(nR_{12}^2/2\)。所加项对 \(\sigma\) 恒定，故优化差完全相同。全梯度成本 \(\chi=O(n^2)\)，去重指标哈密顿量的一个梯度坐标成本 \(\chi_1=O(n)\)，才得到原文 Corollary 7.3 的 \(C(\epsilon)n^2\) 实数操作界及概率趋一的加性 \(\epsilon n\) 保证。

## 7. 作者 Lean 与固定来源

作者的真实定义、证明源码与声明对应已核对，完整来源说明及重查办法见 `guide/evidence/lean-family-281/statement_fidelity.md`。

`lean/ComparatorChallenges/SKFullSupport.json` 指向 `OAI.Probability.SKSupport.Main` 的 `OAI.ZeroTemperatureSK.full_support`。真实入口原声明为：

```lean
theorem full_support (W : BrownianSystem Ω) (γ : OrderParameter)
    (hmin : IsMinimizer W γ) : FullSupportConclusion W γ
```

这里实际 `Model.lean` 定义的 `Time` 是实数半开区间 \([0,1)\)；`OrderParameter` 包含非负、单调、右连续及 Lebesgue 可积，但没有支撑、自洽或平滑性字段。`value` 是增量自然滤过下实际控制收益的上确界，`gradient`、`curvature` 是它的真实空间导数；`IsMinimizer` 是对全部可行系数的泛函最优不等式。`IsStieltjesMeasure` 给 \(\mu(Iic\,t)=\operatorname{ofReal}\gamma(t)\)，包括零点原子。

源码入口先内部构造扩散，再由最优性推接触势、由边界层排末端平台、由实际矩和证书排内部间隙，最后给出支撑、严格递增及任意满足扩散积分方程之解的两条自洽恒等式。`Main.lean` 以这些结论满足中间确定性拼装引理的接触和曲率前提。相应源码为 `Support/ContactPotential.lean`、`Support/NoTerminalPlateau.lean`、`Support/GapCurvature.lean`、`Support/Closure.lean`，以及 `Diffusion/CompactDrift.lean`、`Diffusion/Uniqueness.lean`。

这个选择声明对应 Theorem 1.1，**不单独断言极小元存在/唯一、Corollary 6.4 的光滑正密度、算法复杂度或混合/非零场推广**。另一个真实入口 `OAI.Probability.SKValue.Main` 的 `OAI.SKValue.value_consequences` 针对标量价值与固定时条的实际 Euler/高斯系数极限；其定义还包括有限尺寸期望最大值序列收敛及它等于极小泛函值的结论。它不覆盖 QAOA 量子电路、辅助量子位收缩、去除随机种子或量子主定理；有限系数结论也没有网格速率，故本导读 §5.3 的定量整理不在该选择声明之内。

专门核验保留了原字节的 SKSupport 135 个模块与 SKValue 212 个模块，共 347 个 OAI 模块、约 2.48 MB；唯一未遍历的外部库边界是 Mathlib。重新请求固定小目录/子树元数据，核对了 355 个 Git blobs，两份真实 `Model.lean` 的全部定义与挑战声明前缀逐字一致、完整目标声明除空白外一致。闭包去除注释字符串后的关键字检查没有 `sorry`、自添 `axiom`、`unsafe`、`native_decide` 等命中；Comparator 中的 `sorry` 是挑战占位。源码重查命令为

```sh
python3 guide/evidence/lean-family-281/check_snapshot.py
```

加 `--fresh` 可重新核对上游元数据；未参与源码整理者已独立运行此模式，355 个 Git blob 全部匹配，并对照两个实际 `Model.lean` / `Main.lean` 的定义与结论。

**重放状态。** 上游要求 Lean `4.34.1`，Mathlib 固定于 `d13f23b723b8a846827a245b89c10fc7d3f11612`。本机数学工具包配置的 Mathlib/elan 路径失效，备用目录不存在，PATH 没有 `lean/lake/elan`。已执行的 `sh guide/evidence/lean-family-281/replay.sh` 以退出码 **2** 停在 Mathlib 工作目录检查，未进入声明展开、类型检查或内核验证，因此未完成编译，也未测得传递公理集；JSON 中的许可公理列表不代替这一测量。环境和原始输出分别在 `guide/evidence/lean-family-281/environment.json`、`guide/evidence/lean-family-281/original-entry-verifier.log`。恢复匹配环境后，需按依赖顺序编译，并对两个全限定目标执行 `#print axioms`。

## 8. 核验结论

### 改进

**实际加强的证书。** 保持原文平方方向和同一散度修正形式，只重新选择有理参数，可将其最强已列系数
\[
\text{原文 }\kappa_0=\frac{1661507}{1521000000}\approx0.001092378
\quad\longrightarrow\quad
\text{本次 }\kappa_*=\frac{9385454319}{10^{12}}=0.009385454319>\frac9{1000}.
\]
新值约为原文最强已列常数的 8.59 倍。全部新参数和 22 项正余式在 `guide/evidence/full-support-certificate/nonlinear.json`；最小余式系数为 \(3/500000\)，证书复算见 §4.3。新 \(F_2\) 仍为同变量的多项式，所有所需乘子仍非负，故 §4 的零点、尾界、积分分部与极限证明逐字适用，不增加偏微分方程假设。于是可把 Proposition 5.1 与 Corollary 6.4 中的 \(1/1000\) 同时替换为 \(\kappa_*\)：
\[
q'''\ge\kappa_*c^{-2}\mathbb Ev^4,\qquad
2\gamma'\mathbb Ea^3\ge\kappa_*\gamma^2\mathbb Ea^4.
\]
这是一个更强的**充分积分证书**，尚未确定偏微分方程的最优常数。

要手工代入原文恒等式，新参数按
\((A,C,k,T_0,g_0,h,x_0,y,m,n_0,p_0,p_1,p_2,p_3,p_4)\)
顺序为
\[
10^{-6}(77433,2204343,1194919,1539096,243388,34992,
932537,692722,-2662390,-2186233,34981,53395,42430,2389009,65246).
\]
五个 \(P_i\) 的平方方向完全不改，按这些参数重建 \(Q,T,F_2\) 即可。

独立复核脚本 `guide/evidence/full-support-certificate/review_jets.py` 直接把 \(F_2\) 写成 \(F_2(r^2,rs,v,-w/r,s_x-sv/r)\)，沿 \(r_x=v,\ v_x=w,\ w_x=z\) 与得分的空间导数求普通全导数，再构成 \(r\partial_xF_2+(v+r^2-rs)F_2\)。这一展开不调用 `verify.py` 的 \(\mathcal D\) 规则实现；所得原证书、固定切片、新证书的全部余项分别为 22、13、22 项，与保存表精确相同，翻转得分项系数也被拒绝。原始输出为 `guide/evidence/full-support-certificate/review-jets.json`。此计算核验恒等式；零点延拓、尾界消散度和平台极限由 §3–5 的分析承担。

固定前六个参数、只优化余下九个参数的较小线性切片，另有原始问题与对偶问题精确相等的最优值 \(116143777877/57728642400000\)，见 `improved.json`。它只证明该切片的最优值；允许改变前六个参数后，以上新证书可以越过此界。浮点搜索用于发现参数，最终核验依据是有理恒等式。

**原弦线证明的定量无隙后果。** Jensen 给正平台内
\(y''=q'''\ge\kappa_*c^2y^2\)，其中 \(y=q'\ge0\)。令 \(h=b-a\)、\(\lambda=\kappa_*c^2\)，若平台两端 \(y(a),y(b)\le M\)，\(M>0\)，则凸性给 \(y\le M\)。设
\(D_M=Mh-(q(b)-q(a))\)。两次分部积分给
\[
D_M=h\left(M-\frac{y(a)+y(b)}2\right)
+\frac12\int_a^b(s-a)(b-s)y''(s)\,ds.
\]
用 \(y^2\ge M^2-2M(M-y)\)、\(0\le(s-a)(b-s)\le h^2/4\)，得
\[
D_M\ge\frac{\lambda M^2h^3}{12}
-\frac{\lambda Mh^2}{4}D_M,\qquad
\boxed{D_M\ge\frac{\lambda M^2h^3}{12+3\lambda Mh^2}}.
\]
特别端点斜率至多 \(1\) 时，原文只需的严格面积亏损现在有显式下界
\[
h-(q(b)-q(a))\ge\frac{\kappa_*c^2h^3}{12+3\kappa_*c^2h^2}>0.
\]
若 \(\varepsilon,\delta\ge0\)，端点斜率至多 \(1+\varepsilon\)，且两个端点各满足
\(\lvert q(a)-a\rvert,\lvert q(b)-b\rvert\le\delta\)，则
\[
\varepsilon h+2\delta\ge
\frac{\kappa_*c^2(1+\varepsilon)^2h^3}
{12+3\kappa_*c^2(1+\varepsilon)h^2}.
\]
这是对**仍有精确平台的系数**、近似接触端点的稳定性限制；要得到任意近似极小元的平台长度界，还需要把能量误差定量转为接触误差。此推导已由未参与推导者重做分部积分和移项核验。

**下游精度接口。** §5.3 提取的标量约束和固定时条误差界，已独立复核二阶导数期望、Euler 强误差、Bessel 向量估计及最后移位项。

### 错误与不足

目前未发现主分析链中的数学错误。实际检查了：终端 \(|x|\) 的逼近、全空间导数稳定、真实平台保持、无穷总质量下的 Fubini、零点一侧接触条件、得分比值的零点延拓、无穷远消边界、终端正平台和零平台、三类间隙的穷尽、密度固定时刻极限，以及有限高斯系数的移位末项。

**逐点正性的边界。** 即使所有证书变量具有规定符号，原始曲率多项式也可在抽象代数点上取 \(-54\)，见 `guide/evidence/full-support-certificate/boundary.json`。此时散度项不为零；该点没有给出符合全部空间导数、密度与积分关系的函数及概率密度，因而不是论文的反例，而是说明积分正性不能改写成逐点正性。

### 已核验

手算加精确证书核验支持 Theorem 1.1 的完整分析链、Corollary 6.4 的光滑性和点态正密度推导、Corollary 7.1 与 Proposition 7.2 的标量推论。基态意义依赖已读的 Auffinger–Chen 定理；Corollary 7.3 的有限无序优化依赖已读的 EAMS。未参与主稿撰写者另行复核了接触排隙、空间导数证书、新常数与上述定量后果，未发现承重连接错误。以下表格区分精确运算、文献接口与手算。

| Claim | Source | Basis | Evidence |
|---|---|---|---|
| \(L^1\) 系数逼近给紧时条全空间空间导数和耦合扩散稳定，且可保留给定正平台 | 原文 §2，Lemmas 2.1–2.3；本导读 §3.1 展开 | checked by hand | `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/regularity.tex`; `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md` |
| 接触势非负且在相对支撑为零，不需总 Stieltjes 质量有限；零点有单侧二阶约束 | 原文 §6，Lemmas 6.1–6.2 | checked by hand | `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/variation.tex`; `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md` |
| 后向形状、前向得分比值、零点延拓及高斯尾保证证书积分分部合法 | 原文 §3，Lemmas 3.1–3.4 | checked by hand | `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/signs.tex`; `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md` |
| 证书恒等式的分析假设成立后，积分强制性估计给正平台 \(q'''>0\)；零平台给 \(q''>0\) | 原文 §4 Proposition 4.2、§5 Proposition 5.1 | checked by hand | `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/certificate.tex`; `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/curvature.tex` |
| 平方根终端边界层及凸性积分矛盾排尽三类间隙，推出满支撑与 \(q=t,\ \mathbb Ea^2=1\) | 原文 Theorem 1.1、Lemma 6.3 | checked by hand | `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/variation.tex`; `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md` |
| 极小元光滑、\(\gamma(0)=0\)，固定时刻平台逼近给 \(\gamma'(t)>0\) 对 \(0<t<1\) | 原文 Corollary 6.4 | checked by hand | `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/order-parameter-regularity.tex`; `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md` |
| \(P_*=\mathbb E U_1B_1=\int_0^1\mathbb Ea\) 的泛函推导与有限高斯移位相关逼近 | 原文 Corollary 7.1、Proposition 7.2 | checked by hand | `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/consequences.tex`; `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md` |
| 泛函达到极小值且该值为上述 SK 归一化的基态能量 | Auffinger–Chen arXiv:1606.05335v2，Theorem 1、Lemma 3 证明 | conditional on a cited result (Auffinger–Chen, Theorem 1 and proof of Lemma 3) | `guide/evidence/full-support/sources/AC2017/arxiv-1606.05335v2.pdf`; `guide/evidence/full-support/sources/AC2017/source.tex` |
| 满支撑验证严格递增假设，给 Corollary 7.3 的加性 \(\epsilon n\) 优化与 \(C(\epsilon)n^2\) 实数操作界 | 原文 Corollary 7.3；EAMS arXiv:2001.00904v1，Assumption 2、Theorem 3、Corollary 2.2 | conditional on a cited result (El Alaoui–Montanari–Sellke, Corollary 2.2 and Theorem 3) | `sources/qaoa/arxiv-2001.00904v1.pdf`; `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/algorithm-application.tex`; `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md` |
| 同一满支撑与光滑绝对连续性此前已在 Chen 固定版本中陈述 | Chen arXiv:2607.18032v1，Theorem 1.3、Proposition 4.6 | checked by hand | `guide/evidence/full-support/sources/Chen2026/arxiv-2607.18032v1.pdf`; `guide/evidence/full-support/sources/Chen2026/main.tex` |
| 零系数的显式 \(q_0=(2/\pi)\arcsin t\) 与常系数试探值；显示数值仅为诊断 | ours, 直接计算，本导读 §2 | checked by hand | `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md`; `guide/evidence/full-support/scalar_diagnostic.py`; `guide/evidence/full-support/sources/Montanari2019/arxiv-1812.10897v2.pdf` |
| \(m(t)=1-\int_0^t\gamma\)、\(\|\gamma\|_1\le1\) 及标量系数和的误差至多 \((1-T)m(T)+C_T\sqrt{T/N}\)，\(N\ge N_T\) | ours, 从原文二阶导数半鞅与 Euler/Bessel 估计提取，本导读 §5.3 | checked by hand | `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md`; `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/order-parameter-regularity.tex`; `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/consequences.tex` |
| 原证书恰恢复全部 22 个系数与未列零项，九类破坏均拒绝；独立普通全导数展开吻合 | 原文 Lemma 4.1、Table 1；本次精确复算 | checked by computation | `guide/evidence/full-support-certificate/audit.py`; `guide/evidence/full-support-certificate/verify.py`; `guide/evidence/full-support-certificate/baseline.json`; `guide/evidence/full-support-certificate/verification.json`; `guide/evidence/full-support-certificate/review_jets.py`; `guide/evidence/full-support-certificate/review-jets.json` |
| 同一分析假设下的新有理证书给 \(\kappa_*=9385454319/10^{12}>9/1000\) | ours, 加强 Proposition 4.2 | checked by computation | `guide/evidence/full-support-certificate/audit.py`; `guide/evidence/full-support-certificate/verify.py`; `guide/evidence/full-support-certificate/nonlinear.json`; `guide/evidence/full-support-certificate/review_jets.py`; `guide/evidence/full-support-certificate/review-jets.json` |
| 新证书经相同积分分部及紧时条极限，给正平台曲率与正密度不等式的同系数加强 | ours, 沿原文 §5、§6 的分析转移，本导读 §8 | checked by hand | `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md`; `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/curvature.tex`; `paper/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026/build/order-parameter-regularity.tex` |
| 精确正平台、端点斜率至多 \(M\) 时的面积亏损至少 \(\kappa_*c^2M^2h^3/(12+3\kappa_*c^2Mh^2)\) | ours, 从原文弦线论证提取，本导读 §8 | checked by hand | `guide/Full-support-of-the-zero-temperature-Sherrington-Kirkpatrick-order-parameter-September-27-2026.md`; `guide/evidence/full-support-certificate/nonlinear.json` |
| 较小九参数线性切片的精确对偶界，仅为该切片最优 | ours, 固定切片的界，不涉及更大证书形式的最优性 | checked by computation | `guide/evidence/full-support-certificate/audit.py`; `guide/evidence/full-support-certificate/verify.py`; `guide/evidence/full-support-certificate/improved.json` |
| 固定作者源码闭包与真实定义、目标声明对应 | ours, 固定作者源码核对 | checked by computation | `guide/evidence/lean-family-281/check_snapshot.py`; `guide/evidence/lean-family-281/source-manifest.json`; `guide/evidence/lean-family-281/source-check.json`; `guide/evidence/lean-family-281/statement_fidelity.md` |
| 本地全文 build 字节对应所指定上游提交的目录 Git blobs | ours, 固定论文源码核对 | checked by computation | `guide/evidence/full-support/check_paper_sources.py`; `guide/evidence/full-support/pinned-build-directory.json` |
