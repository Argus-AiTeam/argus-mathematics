# 无理级别的全局量子几何 Langlands：中文导读与核验

**审查结论：在第7节列明的外部定理前提下，手工复核支持主定理的完整复无理参数与全局形式范围，未发现可确认的实质数学错误。**

审查对象为 openai/math 提交 `4eaee87548250b2682affda7d05d947c05554bae` 中《Global quantum geometric Langlands at irrational level》（2026-10-04）。下面的“§”均指原文章节；原文定位以 TeX 命题标签为准。

## 1. 精确命题与问题

原文 §1 主定理（标签 thm:main）声称：对**每条**光滑射影连通复曲线 \(X\)、**每个**连通单复代数群 \(G\) 及**每个** \(c\in\mathbb C\setminus\mathbb Q\)，存在保持余极限的复线性 DG 范畴等价
\[
 D_c(\operatorname{Bun}_G(X))
 \simeq D_{-1/(rc)}(\operatorname{Bun}_{G^\vee}(X)).
\]
这里
\[
 L_G|_E=\det R\Gamma(X,\mathfrak g_E)
       =\det H^0(X,\mathfrak g_E)\otimes\det H^1(X,\mathfrak g_E)^{-1},
 \qquad
 D_c=D\!\left(L_G^{(c-h^\vee)/(2h^\vee)}\right).
\]
\(D(L^s)\) 是该扭曲微分算子层的**全部**导出 D 模范畴，不限于紧对象、正则 holonomic 或温和（tempered）对象；复数次幂定义扭曲，不要求实际开方。\(r\in\{1,2,3\}\) 为长短根平方长度比。\(G^\vee\) 对偶的是完整根数据，所以实际全局形式及所有 \(\operatorname{Bun}\) 连通分支都在命题内。固定对偶钉扎和 theta 特征 \(\vartheta^2\simeq\Omega_X\)。非实数 \(c\) 没有被排除。

问题不是普通几何 Langlands 的另一种表述：这里两边都是丛模叠上的扭曲 D 模，而且参数作负倒数变换。普通理论供应零级别的温和部分比较和上同调界；本文用变形把零级别信息传到每个无理级别，再以局部对偶装配两边的全局范畴。

## 2. 十五分钟路线

先读 §1、§2 的四范畴与有界性、§13 的装配，再回到两个真正承重的比较。§§5–6 建立全局 Whittaker 系数的左逆 \(J_sR_s\simeq\mathrm{Id}\)；§§7–9 把点上的局部对偶升级为包括碰撞的族比较；§§10–12 用含附加点的 Ran 积分把局部配对变成全局周期配对恒等式。§3 的伪恒等函子（pseudo-identity）与 §4 的 Whittaker 对偶保证这些转置都在全部范畴中有意义。

只读本导读第1–3、5–6、8节即可抓住主线；一小时核验优先检查第4.1节的“同一过渡”、第4.3节的边界映射与两槽比较、第5.1节的行列式线与平移。第4.2节是额外结果，首读可略。

| 章节 | 在主线中的职责 | 首读策略 |
|---|---|---|
| §§1–2 | 固定扭曲、惯性消失、准紧约化与范畴对偶 | 不可跳过级别与支撑命题 |
| §§3–4 | ! 对角的等价；相反 Whittaker 字符的对偶 | 先读命题，技术证明第二遍读 |
| §§5–6 | Kummer 参数变形、权重与余极限；全局 Plancherel | 核验第一承重点 |
| §§7–9 | 环群范畴、共同 \(W\) 模目标、碰撞及插入 | 核验第二承重点 |
| §§10–12 | 有限层级周期、任意 Grassmannian 测试、Ran 积分 | 不可用固定点公式替代 |
| §13 | 局部化商、左右逆、中心扭子与分支 | 先看公式 (G1)–(G7) |

### 短符号表

| 符号 | 本文含义 |
|---|---|
| \(Y_H,L_H\) | \(\operatorname{Bun}_H(X)\) 与伴随行列式线；在 Levi 中保留原表示的限制 |
| \(a,d,k_a,k_d\) | \(a=-c,\ d=1/(ra),\ k_a=a-h^\vee,\ k_d=d-\check h^\vee\) |
| \(s,s'\) | \(-k_a/(2h^\vee),\ -k_d/(2\check h^\vee)\) |
| \(A,A',B,B'\) | \(D(L_G^s),D(L_G^{-s}),D(L_{G^\vee}^{-s'}),D(L_{G^\vee}^{s'})\) |
| \(R,S\) | 源、靶的全局 Whittaker 系数；撇号同时反转扭曲和字符 |
| \(e_H\) | \(\Delta_!k_{Y_H}[2\dim Y_H+2\delta_N(H)]\) 的核变换，不是普通评价对偶本身 |
| \(l_N,\delta_N\) | \(\det R\Gamma(X,\mathfrak n_0),-\chi(X,\mathfrak n_0)\) |
| Ran | 非空有限点集的预叠；对角映射包括点的合并 |

## 3. 先把符号算对

### 3.1 平移后的级别不是仿射级别

原文 §2（foundations:levels、foundations:four-categories）实际先在 \(A\) 上工作。手算给出
\[
 s=\frac{c+h^\vee}{2h^\vee}
   =\frac{c-h^\vee}{2h^\vee}+1,\qquad
 -s'=\frac{-1/(rc)-\check h^\vee}{2\check h^\vee}.
\]
所以最后须先张量实际的 \(L_G\)，把题设源范畴送到 \(A\)；靶 \(B\) 不再平移。这是整数次幂运输，不需要行列式线的平方根。在 \(G=SL_2\) 中 \(h^\vee=2,r=1\)：题设源指数是 \((c-2)/4\)，工作指数是 \((c+2)/4\)，靶指数是 \((-1/c-2)/4\)。漏掉这个 \(+1\) 会得到不同的局部化比较。

Kummer 约定是 \(d-s\,d\log t\)，单值化为 \(q=e^{2\pi i s}\)。准确地说，\(q\) 为单位根当且仅当 \(s\in\mathbb Q\)：若 \(q^n=1\)，则 \(ns\in\mathbb Z\)，这也迫使虚部为零。因此无理复参数与非有限阶单值化的对应确实包括非实数。

原文用 \(\langle Y\rangle\) 表示左 D 模先平移 \([\dim Y]\) 后的层归一化；其中 \(\mathcal O_Y^{\langle Y\rangle}=\omega_Y\)。不可把左模块的裸 \(\mathcal O\)、常对象 \(k\) 和 \(\omega\) 混用。普通对偶的余评价核是 \(\Delta_*\omega_Y\)，伪恒等函子才使用 \(\Delta_!k_Y\)。

再区分未平移的 \(F_H\) 与装配中的 \(e_H\)：§3 证明前者为等价，§13 则使用
\[
 e_H=F_H[2\dim Y_H+2\delta_N(H)].
\]
这里的 \(2\delta_N\) 来自相反字符 Whittaker 对偶的校正；只写 \(2\dim Y_H\) 会把 Plancherel 和最终逆函子错移。

### 3.2 最小手算：无理扭曲为什么截断不稳定方向

原文 §2 的惯性引理在 \(\mathbb G_m\) 上就是
\[
 \mathbb C[t,t^{-1}]\xrightarrow{\,t\partial_t-sm\,}
 \mathbb C[t,t^{-1}],\qquad t^n\longmapsto(n-sm)t^n.
\]
若 \(m\ne0\) 且 \(s\notin\mathbb Q\)，每个特征值都非零，复形无上同调。另一方面，平凡字符的 de Rham 上同调含 \(\mathbb C\) 直和项，因此与其张量在任意无界复形上仍检测零。这不是只对有限长度对象的论证。

例取 \(G=SL_2\)，分裂丛 \(E=L\oplus L^{-1}\)，\(\deg L=n>0\)。伴随丛为 \(L^2\oplus\mathcal O\oplus L^{-2}\)。对角余特征标的三项权重为 \(2,0,-2\)，故其在行列式线上的权重为
\[
 2\chi(L^2)-2\chi(L^{-2})=8n.
\]
当 \(2n>2g-2\) 时 \(H^1(L^2)=0\)，该 HN 层的扩张可由分裂层光滑覆盖，惯性消失遂杀掉整层。一般证明把这一步换成最大抛物的根高度过滤、半稳定性和 Serre 对偶：只要某个简单根满足
\(\alpha_i(\nu)>\max(0,2g-2)\)，相应层就消失。

余下 HN 类型的简单根值都落在有界区间，且分母有界；度数的挠类只有有限多个，故能放在一个准紧开集 \(U\) 内。对任意对象的过渡不能靠“逐层为零”一句话：先在每个有界 HN 开集使用**有限**分层的局部化三角，再取检测对象的开覆盖。这正是原文截断命题的论证。结论是 \(j^!\) 的范畴等价，**不是**底层复形集合论支撑的断言；附加参数范畴及 \(-s\) 同样适用。

这个严格阈值在秩一已经最佳。令 \(g\ge2\)，取 \(L=\vartheta\)，并取非零扩张
\[
 0\longrightarrow L\longrightarrow E\longrightarrow L^{-1}\longrightarrow0.
\]
因为 \(\operatorname{Ext}^1(L^{-1},L)=H^1(\Omega_X)=\mathbb C\)，这样的扩张存在，且 \(\det E=\mathcal O_X\)。\(L\) 是唯一最大斜率线丛，故 HN 简单根值为 \(2g-2\)。自同构保留 \(L\)，其对角部分为 \((a,a^{-1})\)；非零扩张类迫使 \(a^2=1\)，非对角部分为 \(H^0(\Omega_X)\)。所以
\(\operatorname{Aut}_{SL_2}(E)=\mu_2\times\mathbb G_a^{g}\)。

HN 层到 \(\operatorname{Pic}^{g-1}(X)\) 的映射记录唯一最大斜率子线丛的同构类；在闭点 \([L]\) 上，其纤维是扩张商叠
\[
 [\,H^1(L^2)/(H^0(L^2)\rtimes\mathbb G_m)\,].
\]
向量群在扩张类上平凡，\(a\in\mathbb G_m\) 以 \(a^2\) 作用。非零扩张构成这个闭纤维中的一个开轨道，商正是
\(B(\mu_2\times\mathbb G_a^g)\)，故其到 HN 层、再到丛模叠的映射为局部闭浸入。

中心在伴随表示上平凡，幺幂群没有非平凡代数字符到 \(\mathbb G_m\)，故其在 \(L_G|_E\) 上的字符平凡。分类叠上的线由自同构群的字符决定，因此残余 gerbe 上的扭曲平凡，存在非零 D 模。闭推送和开星推送均全忠实，沿上述局部闭浸入推送便得到边界 HN 层上的非零对象。最小正不稳定例为 \(g=2\)，所以不能把截断的 \(>2g-2\) 改成 \(\ge2g-2\)。

## 4. 核心机制、困难段落与补充结果

### 4.1 全局系数的变形

令 \(D_s=D(L_H^s)\)。全局 Whittaker 系数
\(R_s:D_s\to\mathcal W_s^+\) 保留移动极点；相反扭曲与字符的系数是
\(R'_s:D_{-s}\to\mathcal W_{-s}^-\)。
§4 的配对给出 \((\mathcal W_{-s}^-)^\vee\simeq\mathcal W_s^+\)，因此
\[
 J_s=F_H\circ(R'_s)^\vee[2\dim Y_H+2\delta_N]:
       \mathcal W_s^+\longrightarrow D_s
\]
有明确类型：先将 Whittaker 对象转置回丛模叠，再用平移后的伪恒等函子。§§5–6 的目标是 \(J_sR_s\simeq\mathrm{Id}_{D_s}\)。

零级别的普通理论给出一个反温和余项；作者用固定的有限 Whittaker 测试杀掉它，再把测试后的核锥写成有限极点界与有限参数图的有向系统。辅助仿射线上的 Fourier 变换把几何对象变成指数字符。

有限阶段的秩在非单位根处恒定，只控制每个有限矩阵。要推出余极限为零，还须证明**每个生成元被某个有限过渡杀掉**。原文 §5 的对数变分、权重上界和 \(q=1\) 的完备化负责这一步。

秩恒定的准确前提是：以一个乘法坐标记录 Kummer 因子后，对象具有混合 Hodge 几何来源，故在 \(0,\infty\) 准幺幂；非单位根参数使两端的 ! 与 * 延拓相同，即干净延拓。仿射曲线上的 Artin 消失使该 Mellin 积分对反常层正合，因而也控制过渡映射的秩。删去准幺幂会失败：单值化为 \(2\) 的局部系统给 \([A\xrightarrow{2q-1}A]\)，在 \(q=1\) 无上同调，在非单位根 \(q=1/2\) 却非零。它不满足原文假设。Fourier 比较先保留整个参数，再由伸缩作用取 \(t=1\) 的 !-纤维，保留了非固有映射所需的运算顺序。

具体地，令 \(h=\log q\)，\(M_i=H^d(K_i\otimes\mathbb C[[h]])\)。系数复形是有限完美复形，故这是有限生成的完成模。注意
\[
 0\to M_i/h^nM_i\to H^d(K_i\bmod h^n)
   \to H^{d+1}(K_i\otimes\mathbb C[[h]])[h^n]\to0;
\]
最后的 Tor 项不可丢掉。若 \(h^e\) 杀掉 \(H^{d+1}\) 的挠子模，则长度 \(m\to n\) 在 Tor 项上是乘 \(h^{m-n}\)；故 \(m\ge n+e\) 时像恰为 \(M_i/h^nM_i\)，后者具有相容混合 Hodge 结构。其长度商映射满射，Deligne 的函子性大分次在每个分量上仍满射；把长度一的齐次基逐层同分量提升，Nakayama 引理便给出有限个相容于所有截断的齐次生成元。若其权重为 \(w\)，而所有阶段长度一的权重至多 \(C\)，取整数 \(a\) 满足 \(C-2a<w\)。先在长度 \(a\) 杀掉该生成元；它在每个更长长度的像都落在权重至多 \(C-2a\) 的子对象中，却仍齐次于 \(w\)，故**同一过渡**杀掉所有长度。对有限个生成元取共同后继，再用这个有限过渡在非单位根处的秩恒定，才传到每个无理参数。这是原文 deform:colimit 的证明展开。

§6 的权重来自实际混合几何：Satake 核与归一化相对对偶的权重 \(d_\lambda\)、\(-d_\lambda\) 抵消，固定测试对象的运算只增加固定成本。普通 Langlands 则通过下式给出上同调次数界：
\[
 \operatorname{Hom}(\Xi(V),C)
 =\Gamma(\operatorname{LS}_{\check G},V^\vee\otimes\Psi(C)).
\]
固定凝聚对象 \(C\) 的 \(\Psi(C)\) 有界，\(V\) 是向量丛，QCA 的有限上同调维数给出统一次数上界 \(E\)。

碰撞的代价可以算得更明确。法向辫子超平面配置的秩为碰撞余维 \(c\)，其 \(H^k\) 为 \(\mathbb Q(-k)\)-型且 \(k\le c\)。在维数 \(n\) 的开配置层，对偶化归一化给局部项 \(H^k[2n-k](n)\)：复形权重为 \(k\le c\)，次数至多 \(c-2n\)。推到维数 \(n'=n-c\) 的碰撞层，连同真空的次数上界，得到原文的 \(E'-c\)；再加单纯形次数的平移 \([l]\)，上界为 \(E'-c-l\)。固定上同调次数 \(j\) 仅可能有有限个 \((c,l)\) 满足 \(c+l\le E'-j\)。忽略任意多个不参与碰撞的单点块后，非平凡碰撞块的总大小至多 \(2c\)，故其类型也只有有限种。更精确地，若固定成本后的复形权重是 \(W\)，各项的第 \(j\) 上同调权重至多
\[
 W+c+l+j\le W+E'.
\]
这是原文 weight-estimate 证明的显式化：给定其统一次数界 \(E'\) 和混合几何比较，在固定图表与测试成本下，这里的权重上界可取为独立于 \(j\)。

有限测试本身还可放宽参数。其非对角 Bruhat 项只要求
\(s(w\nu-\nu)\notin X^*(T)\)，其中
\(\nu=\sum_{\alpha>0}2\operatorname{ht}(\alpha)\alpha\)、\(w\ne1\)。
若 \(d_w\) 为 \(w\nu-\nu\) 与实际余特征标格配对的最大公因数，条件就是 \(d_ws\notin\mathbb Z\)。在 \(SL_2\) 与 \(PGL_2\) 中分别为 \(d_w=8,4\)，故 \(s=1/3\) 也满足有限测试的保守性条件。这只放宽 planch:finite-test 的充分条件；全局定理仍需要 §5 的非单位根秩论证。

### 4.2 本次补充：有限截断刚性与临界反例

以下是**我们的抽象有限模推论**，不声称文献新颖性。令 \(R=\mathbb Q[[h]]\)，\(M_i\) 为有向系统中的有限生成 \(R\)-模，\(V_{i,n}=M_i/h^nM_i\) 带相容的有理混合 Hodge 结构。要求商映射、过渡映射及
\[
 h^a:V_{i,n-a}(a)\longrightarrow V_{i,n}
\]
都是混合 Hodge 结构的态射；\(\mathbb Q(a)\) 的权重为 \(-2a\)。允许挠模，不假设此箭头单射。设 \(V_{i,1}\) 的权重上界为 \(C_i\)，非零源的最低权重为 \(w_i\)。

**有限截断刚性。** 若 \(f_{ij}\bmod h^a=0\) 且 \(C_j-2a<w_i\)，则 \(f_{ij}=0\)。证明：\(h\)-进过滤第 \(r\) 层是 \(V_{j,1}(r)\) 的混合 Hodge 商，故 \(V_{j,n}\) 权重至多 \(C_j\)。用 Deligne 函子性分裂将 \(V_{i,1}\) 的齐次基逐层同分量提升；Nakayama 引理给出完成扩标量到复数后的有限个齐次生成元，权重都至少 \(w_i\)。其像落在 \(h^aM_j\)，在每个有限长度的权重至多 \(C_j-2a\)，又保持原齐次权重，因而为零。完成模的分离性与扩标量的忠实性给出结论。对两个相容态射的差应用此论证，还得到“安全长度上一致，则全长一致”。

若仅知 \(\varinjlim V_{i,1}=0\)，令 \(N=\varinjlim M_i\)，则 \(N=hN\)，从而 \(N/h^aN=0\)。有限维性保证每个源、每个长度都在某个后继消失。因此只需对每个源找一个消去长度 \(a\) 的目标 \(j\)，满足 \(C_j-2a<w_i\)，整个系统就逐源最终为零。选取消去长度 \(a\) 的目标为消元阶段函数 \(\tau_i(a)\)，则一个允许阶段权重无全局上界的充分条件是：沿无界长度序列有
\[
 C_{\tau_i(a)}\le(2-\epsilon_i)a+D_i,\qquad \epsilon_i>0.
\]
这是充分条件，不是任意预选消元阶段函数的必要条件。原文统一上界 \(C\) 的情形给出安全正长度
\[
 a_{\mathrm{safe}}=\max\!\left(1,\left\lfloor
                 \frac{C-w_i}{2}\right\rfloor+1\right).
\]
这只是原证明的定量化，不算额外发现。

有挠元时，“整模过渡最终为零”不是泛点消失的必要条件：\(R/(h^{i+1})\) 经乘 \(h\) 的各阶段泛点都为零，所有有限过渡却非零，整模余极限为 \(\mathbb Q((h))/R\)。

**临界等号确会失败。** 取
\[
 M_i=Re_i,\qquad e_i\longmapsto he_{i+1},\qquad
 V_{i,n}=\bigoplus_{r=0}^{n-1}\mathbb Q(r-i).
\]
\(h^re_i\) 的权重为 \(2i-2r\)；过渡把它送到 \(h^{r+1}e_{i+1}\)，恰保混合 Hodge 结构。每阶段的所有长度都权重有界，但 \(C_i=w_i=2i\) 无统一上界。长度 \(a\) 在 \(a\) 步后为零，任意固定 \(k\) 步在长度 \(k+1\) 仍非零。由 \(e_i\mapsto h^{-i}\) 得
\[
 \varinjlim M_i=\bigcup_i h^{-i}R=\mathbb Q((h))\ne0,
 \qquad C_{i+a}-2a=w_i .
\]
所以不能把严格分离改成临界等号，也不能把统一上界换成“每阶段分别有界”。这只是抽象模模型，不是原文有限几何操作的反例。若把各阶段生成元都标为权重零，权重虽一致有界，乘 \(h\) 的过渡却不再保持混合 Hodge 结构；映射的相容性也不可删除。

与脚本中的 Mellin 坐标比较时，\(q-1=\exp(h)-1=h\,u(h)\)，其中 \(u(h)\) 是常数项为 \(1\) 的单位。对原来乘 \(q-1\) 的系统，换基 \(e'_i=u(h)^i e_i\) 后过渡才是乘 \(h\)；上述 Tate 结构赋在这个基上，而非直接赋给原坐标的各单项。

**长度不是运行阶段。** 即使 \(C=w_i=0\)，也可以前 \(L\) 步全为恒等、第 \(L\) 步才为零，\(L\) 任意。因此没有只依赖权重的消失阶段下标界；本文 §6 也未给消元阶段函数的有效估计。

### 4.3 点对偶不自动给出碰撞对偶

Feigin–Frenkel 对偶识别逆平移级别的主 \(W\)-代数；Arakawa–Frenkel 的 Weyl 模约化交换表示与修正标签。后者对全部复无理参数成立；其简单根字符非零的模态为 \(-1-\langle\lambda,\alpha\rangle\)，同时规定谱流后的 \(W\) 作用。表示与修正的标签分别属于实际群的权格、余权格，交换后正是对偶完整根数据的两个格。

先说明 §§7–9 的三个范畴。给定光滑标记参数概形 \(S\)，令 \(H\) 为标记处的正环群、\(\mathcal M_S\) 为该级别的重整化仿射 Lie 模范畴。球形输入为 \(C_S=\mathcal M_S^H\)，即带强正环群等变结构的模；测试输入
\[
 d_S=\bigl(D_{\mathcal L^{-s}}(LG/H)\bigr)_{LN,\chi}
       \simeq\mathcal W_{-s}^-(S)
\]
是 Grassmannian 范畴的带字符余不变量，按 §4 的对偶实现为相反扭曲、相反字符的 Whittaker 范畴。原文的小写 \(d_S\) 是范畴，不是数值级别 \(d\)。约化输出为 \(Q_S=(\mathcal M_S)_{LN,\chi}\)。两边的 \(Q_S\) 经 \(W\)-代数对偶识别成同一个范畴，连同其底层复形函子。

局部配对是 \(F_S:C_S\otimes_{D(S)}d_S\to Q_S\)。固定一槽为真空对象，分别得到
\[
 C_S\xrightarrow{F_0}Q_S\xleftarrow{F_1}\check d_S,\qquad
 \alpha_S:C_S\simeq\check d_S,\quad F_1\alpha_S\simeq F_0 .
\]
这里 \(F_0(M)=F_S(M,\mathrm{vac})\)，
\(F_1(N)=\check F_S(\mathrm{vac},N)\)；
\(\check d_S\) 是对偶群一侧的测试范畴。
记 \(R_1:Q_S\to\check d_S\) 为 \(F_1\) 的连续右伴随，区别于全局 Whittaker 系数 \(R\)。下面从 \(H^0(R_1F_0)\) 构造 \(\alpha_S\)。

\(Q_S\) 由广义真空生成，取的是重整化范畴而非所有无界光滑 \(W\) 模的朴素导出范畴。\(F_0,F_1\) 本身也不是全忠实：在 \(SL_2\) 的同一标签上，自配对为
\(\mathbb C\oplus\mathbb C[-3]\)。
全忠实的是在球形范畴上平衡后的配对。相对版本先证紧对象映射复形的 Ext 与滤过余极限相容，再作有限 Tor 维基变换，最后用所有素点的剩余域检测映射锥。Skryabin 提供的点上等价在这一步用于检测纤维。改变标记的幂零增厚则用 \(P-Q\in I,I^r=0\) 时
\(Q^{n+r-1}\in(P^n)\) 的共尾性，选择共同更深的同余子群比较；固定有限阶射流本身不必水平不变。

**第一难点：心怎样恢复边界。** 记碰撞除子的嵌入为 \(i\)，开补为 \(j\)。对心对象 \(M\)，有 \(B=j^!M\) 在心中、\(E=i^!M\) 幅度 \([0,1]\)。半单群 \(H^1_{\mathrm{dR}}(G)=H^2_{\mathrm{dR}}(G)=0\) 使伴随单位的锥集中在次数至少 \(3\)，所以共同目标在心的 Hom 上全忠实。局部化三角的心长正合列给实际满射
\[
 b:j_*B\twoheadrightarrow i_*H^1E.
\]
运输到另一侧的边界映射若有非零余核，就把它经闭层的心等价逆运；共同目标的 Hom 比较将商映射与 \(b\) 的复合认成零，和 \(b\) 的满射性矛盾。故新边界映射仍满，\(H^1(R_1F_0M)=H^2(R_1F_0M)=0\)，心等价才是 \(H^0(R_1F_0)\)，不是整个 \(R_1F_0\)。

只比较开、闭限制确实不够：在 \(\mathbb A^1\) 上，
\(\mathcal O\oplus i_*\mathbb C\) 与 \(j_!\mathcal O_{\mathbb G_m}\)
非同构，却有相同 \(j^!\) 限制和 \(i^!\) 限制
\(\mathbb C\oplus\mathbb C[-1]\)。
前者有支撑于闭点的非零商，后者由 \(j_!\) 的伴随性没有；非分裂序列
\(0\to\mathcal O\to\mathcal O(*0)\to i_*\mathbb C\to0\)
的对偶给出后者。这仅反驳“分层一样就能粘合”的简化；原文 local:one-slot 恰好保留了 \(b\)。

原文 local:heart 还另证**无界导出实现**。Harish–Chandra 诱导与连接诱导的两个单子给出 \(t\)-正合比较
\(u_C:C_S\to D(\mathcal H_S)\)，在下有界对象上是等价；点上的 Weyl 分解、各重合型层的坐标平移及有限局部化三角另证它在全部对象上保守。这一步不能从下有界比较自动推出。对上有界复形用 Dold–Kan、有限全复形的余极限实现，对任意复形再取典范上截断的余极限。滤过余极限相容性使实现保留上同调，分离性使无上同调复形映到零。实现与 \(u_C\) 的一个复合由普通导出范畴中的同一公式为恒等；另一个复合先在有界对象上为恒等，再由连接诱导的**有界紧生成元**和连续性推到全部对象，故并未把重整化范畴直接认成朴素无界范畴。

**第二难点：两槽比较不能只确定到自等价。** local:two-slot 对两个颜色的输入配对先给 \(G_1\beta\simeq G_0\)。随后整体平移一个颜色，产生自由 \(D(\mathbb A^1_y)\) 因子，跨色碰撞多项式 \(f(y)\) 首一。常系数输入若有支撑于 \(f=0\) 的商，其中 \(\partial_y e=0\)、\(f^ne=0\)；微分 \(n\deg f\) 次即得 \((n\deg f)!\,e=0\)，故商为零。没有这种子对象和商，使开集上的恒等唯一延拓，得到 \(\beta=\mathrm{Id}\)。最高 Weyl 向量与 Fock 真空的闭链，以及横截离散赋值环上的平坦性，再固定中性点合并时的真空标量。辅助参数的图推送、伴随转置与导出实现保留排列、插入、合并的高阶相容性，供 §12 的 Ran 下降使用。

真空特化所用的平坦性有一个关键前提：在横截 DVR 的 BRST 复形 \(K\) 中，最高向量闭链及其 \(W\) 模式提升了闭纤维的全部 \(H^0\)。对 \(K\xrightarrow{\pi}K\to K/\pi\) 取长正合列，纤维的次数集中给出各 \(H^q(K)\) 上乘 \(\pi\) 单射；在 \(q=1\) 恰需上述提升满射。泛纤维集中又使 \(q\ne0\) 的群为挠模，故它们全零，而 \(H^0(K)\) 无挠、因而平坦。两侧延拓的生成闭链及无挠性才把泛纤维上的实际比较固定到闭纤维；只知道点上的 FLE 或两侧分别平坦均不够。

一个可手算的碰撞检验：\(P=z(z-t)\)，总留数在基 \((1,z)\) 上的 Gram 为
\[
 \begin{pmatrix}0&1\\1&t\end{pmatrix},\qquad\det=-1 .
\]
所以 \(t=0\) 重根时配对仍完美。一般首一 \(n\) 次多项式的配对是 \(fg\bmod P\) 的 \(z^{n-1}\) 系数；Gram 矩阵的反对角线为 \(1\)、之前为 \(0\)，行列式为 \((-1)^{n(n-1)/2}\)，在任意系数环都成立。这直接检验总留数在碰撞中的非退化性。

### 4.4 伪恒等函子怎样由抛物归纳得到等价

先设 \(H\) 半单，固定抛物 \(P\)、Levi 商 \(M\) 及度数的挠类 \(u\)。写
\[
 Y_M^u\xleftarrow qY_P^u\xrightarrow pY_H,\qquad
 C_P=q_*p^!,\quad E_P=p_*q^!,\quad
 e=\dim q=(g-1)\dim N_P .
\]
\(C_P\) 是常数项函子，\(E_P\) 是 Eisenstein 函子。原文保留 Levi 数据的细紧化
\(j:Y_P^u\hookrightarrow\widetilde Y_P^u\)
带有核 \(J=j_!\omega\)，扭曲为
\((\bar p^*L_H\otimes\bar q^*L_M^{-1})^s\)。

**先下降，再用惯性。** 缺陷为 \(\theta\) 的边界层投到 Levi Hecke 基底 \(f_\theta:S_\theta\to B_\theta\)。固定该基底后，纤维是逐次向量栈，参数只描述幺幂扩张。在缺陷外选一点，幺幂 Laurent 主部给出的粘合变形张成这些纤维的切方向；局部流保持开集及边界，使 \(i_\theta^!J\) 沿纤维为常对象。向量群的 de Rham 无上同调性于是给
\[
 i_\theta^!J\simeq f_\theta^!K_\theta .
\]
现在才在 \(B_\theta\) 上检测惯性：行列式比值的中心权重为
\(Q(z,u_{\rm sat}-u)\)，其中 \(Q\) 为原文所用自对偶表示的迹型。非零缺陷使度数差在有理数上非零，正定性给出积分中心余特征标 \(z\)，使该整数权重非零。第3.2节杀掉 \(K_\theta\)，故所有非零缺陷限制为零，\(J\) 是干净延拓。Levi Laurent 方向同样说明 \(J\) 的特征簇没有来自 Levi 基底的非零水平余向量。

**这如何给全部对象上的伴随？** 对凝聚 Levi 系数 \(E\)，核
\(J\otimes^!\bar q^!E\) 满足非特征条件。由第7节列明的非特征逆像与对偶定理，它及其对偶仍无边界；因此 ! 延拓对任意目标具有真正的部分左伴随性质。经固有的 \(\bar p\) 推送，再由紧生成与连续性扩到全部系数，得到
\[
 L_P:=E_P[-2e]\dashv C_P,\qquad
 p_!q^*=L_P .
\]
相反抛物的第二伴随为 \(C_{P^-}\dashv E_P\)。其单位来自一般纤维为对角、特殊纤维为 \(P^-\times_M P\) 的图插值：行列式比值在零点的阶是 \(Q(\lambda,u)=0\)，故开纤维的平凡化延拓。余单位取处处横截的约化；两个三角恒等式都归结为常族 \(\mathbb A^1\times Y_P^u\) 上的恒等。

撇号表示相反扭曲。将这些伴随施于 ! 对角核，原文 (M4) 给出实际函子恒等式
\[
 C_{P^-}F_H\simeq F_M(L'_P)^\vee,\qquad
 F_HE_{P^-}\simeq L_PF_M .
\]
另一方面，Vinberg 对角紧化也先沿幺幂向量栈下降；其两端独立的中心惯性只留下度数为挠类、缺陷为零的层。因此
\[
 \operatorname{Cone}\bigl(F_H\to\mathrm{Id}[-2\dim Y_H]\bigr)
\]
有有限过滤，每个商形如 \(E_P\,T_K\,C_{P^-}\)，其中 \(P\) 真抛物、\(T_K\) 是 Levi 上的核函子。

**归纳怎样闭合？** 对 Levi 紧生成元 \(w\)，取 \(x=E_Pw\)。由上述伴随和较低半单秩的 \(F_M\) 等价，
\[
 \operatorname{Hom}(F_Hx,F_Hy)
 \simeq\operatorname{Hom}(F_Mw,C_{P^-}F_Hy)
 \simeq\operatorname{Hom}(w,(L'_P)^\vee y)
 \simeq\operatorname{Hom}(x,y).
\]
原文还用凝聚图表上的分裂满射自同态必可逆，核对这个自然同构对应于 \(F_H\) 实际诱导的 Hom 映射。对所有常数项为零的尖点部分，锥过滤立即给
\(F_Hm\simeq m[-2\dim Y_H]\)；第二伴随又给它对 Eisenstein 像的左正交性，因而同样控制从 \(m\) 出发的 Hom。Eisenstein 生成元与其尖点右正交部分共同生成全范畴，故全忠实；(M4) 和尖点上的平移则使本质像包含这些生成元，得本质满射。

Levi 中心带来的约化群情形用 \(H_{\rm der}\times Z^0\to H\) 的中心同源映射下降，保留全部可提升分支；环面部分是 Picard 因子与 \(BZ^0\)，后者由普通奇迹对偶给归纳基例。实际全局形式下的紧化与分层另外在原文构造，准确引用范围见第7节。

## 5. 周期配对为何必须积分附加点

§§10–12 实际要证明的是原文 (T1)。设非空标记组 \(T\) 在光滑概形 \(S\) 上变化，\(M\in C_T\) 是球形仿射模，\(W'\in d_T\) 是第4.3节的相反 Whittaker 测试。归一化局部化
\[
 \Lambda_T=\operatorname{Loc}_T\otimes l_N^{-1}[\delta_N]
 :C_T\longrightarrow D(L_G^s\boxtimes\mathcal O_S)
\]
保留参数，\(R_T\) 对其取全局 Whittaker 系数。结论是在 \(D(S)\) 中
\[
 \boxed{\quad
 \left\langle R_T\Lambda_T(M),W'\right\rangle_S
 \simeq
 \int_{V\supseteq T}\operatorname{oblv}_W
 F_V\bigl(\operatorname{ins}_{T,V}M,
          \operatorname{ins}_{T,V}W'\bigr).\quad} \tag{T1}
\]
左边是在丛模叠上先局部化、再取系数和测试配对；右边先在局部两槽插入额外真空点，再取共同 \(W\) 目标的底层复形 \(\operatorname{oblv}_W:Q_S\to D(S)\)。积分遍历所有包含 \(T\) 的有限点集及其重合图，使用对偶化归一化、! 拉回及积分迹。新点不加层级条件；它们的作用是把局部主部信息补成全局上同调。

### 5.1 有限层级的行列式线与平移

对有限 Grassmannian 界选择足够深的同余子群，核、中央扩张与字符都降到有限阶射流。非零层级除子固定覆盖原标记 \(T\)，新点取零层级。写 \(h_E^0\) 为完整弧 Lie 格、\(h\) 为层级子格，\(B_E^{\mathrm{lv}}\)、\(B_E^0\) 为分别用这两个格计算的半无限 BRST 复形。设
\[
 m=\operatorname{rank}(h_E^0/h),\quad
 l^{\mathrm{lv}}=l_N\det(h_E^0/h)^{-1},\quad
 \delta=\delta_N+m,\quad
 B_E^{\mathrm{lv}}=B_E^0\det(h_E^0/h)[m].
\]
半无限复形到指数周期积分 \(\operatorname{Per}^{\mathrm{lv}}\) 的映射，其源为 \(l^{\mathrm{lv}}[\delta]\otimes B_E^{\mathrm{lv}}\)。
先平移 \([-2\delta]\)，逐项抵消后成为
\[
 l_N[-\delta_N]\otimes B_E^0.
\]
所以局部化的归一化 \(l_N^{-1}[\delta_N]\) 恰好取消它。

有限维核对还给出更直接的检验。若
\[
 B_N^{\mathrm{lv}}=[K_l\backslash L_l/H],\quad
 e_l=\dim(A_l/h),\quad f_l=\dim K_l,
\]
则 \(\delta=e_l-f_l\)、\(l^{\mathrm{lv}}=\det k_l\det(A_l/h)^{-1}\)。在有限商 \(\bar Z=K_l\backslash\bar L_l\) 上，设 \(a=\dim\bar A_l,z=a-f_l\)。由链转上链的行列式线为
\(\det(\bar A_l/k_l)^{-1}\det\bar A_l=\det k_l\)，总平移为
\(2\delta-z+a=\delta+e_l\)，与原文 (T14) 一致。

### 5.2 真正的 Ran 步骤

**主部与忘支撑。** §12 的线性原型是
\[
 \int_{V\supseteq U}\bigotimes_j{}^!\operatorname{PP}(J_j,V)
 \simeq\bigotimes_j R\Gamma(X,J_j)[1].
\]
每个主部因子可写成一个曲线变量 \(z_j\) 支撑于 \(z_j\in V\) 的关联条件：对诱导 D 模的局部化三角取相对 de Rham 上同调，带支撑项就是主部商，忘支撑映射就是
\(\operatorname{PP}(J_j,V)\to R\Gamma(X,J_j)[1]\)。
固定所有 \(z_j\) 后，剩下的 Ran 方向只要求有限点集包含旧点和这些 \(z_j\)，由通用同调可缩性收缩（相对接口见第7节）；这识别的是实际忘支撑映射。向量群情形的连续上链经留数对偶写成
\(\operatorname{Sym}(\operatorname{PP}(J^\vee\otimes\Omega_X,V)[-1])\)，
因此逐对称次数适用。对 \(N\)，将括号变为 \(t[-,-]\)，零纤维为向量群；正根高度与第二缩放权重使第一权重 \(n\) 的锥在第二权重上有下界 \(-n\)，而 \(t\) 的第二权重为 \(1\)。零纤维消失使乘 \(t\) 可逆，非零类便可不断向更低权重求原像，与下界矛盾。故整个锥为零，得到幺幂情形。

**约化群需要一个四角方图。** 记
\(I_U=\operatorname{Res}\operatorname{ins}_{G,T,U}M\)，
\(c_N=l_N[-\delta_N]\)；\(\operatorname{Res}\) 为向 \(N\) 的限制。用 \(\operatorname{Per}_{N,U}^{\mathrm{lv}}\)、\(\operatorname{Per}_{G,T}^{\mathrm{lv}}\) 表示局部化后在幺幂丛模叠上的指数积分，设
\[
\begin{aligned}
 \mathsf B_2&=c_N\otimes\int_{T\subseteq U\subseteq V}
          B_V^0(\operatorname{ins}_{N,U,V}I_U),&
 \mathsf P_N&=\int_{U\supseteq T}
          \operatorname{Per}_{N,U}^{\mathrm{lv}}(I_U)[-2\delta],\\
 \mathsf B_1&=c_N\otimes\int_{V\supseteq T}B_V^0(I_V),&
 \mathsf P_G&=\operatorname{Per}_{G,T}^{\mathrm{lv}}(M)[-2\delta].
\end{aligned}
\]
层级仍只在 \(T\)，故 \(c_N,\delta\) 对新增点恒定。自然性、插入传播与迹的复合给交换方图
\[
\begin{array}{ccc}
 \mathsf B_2&\xrightarrow{\ \text{幺幂情形}\ }&\mathsf P_N\\
 \Big\downarrow{\scriptstyle(\mathrm{T23})}&&
       \Big\downarrow{\scriptstyle\operatorname{Per}(\mathrm{T21})}\\
 \mathsf B_1&\xrightarrow{\ \text{待证约化群情形}\ }&\mathsf P_G .
\end{array}
\]
上边已是同构。右边来自外部流代数，即曲线去掉标记后正则的 Lie 截面之间的比较
\[
 \int_{U\supseteq T}\operatorname{Loc}_{N,U}^{\mathrm{lv}}(I_U)
 \longrightarrow p^!\operatorname{Loc}_{G,T}^{\mathrm{lv}}(M),
                                                        \tag{T21}
\]
其中 \(p:B_N^{\mathrm{lv}}\to B_G^{\mathrm{lv}}\)。
左边来自 \(\operatorname{ins}_{N,U,V}I_U\to I_V\) 及忘掉 \(U\) 的积分余单位，正是两次插入比较 (T23)。

为什么这两边也是同构？对 (T21)，拉到丛的图表，只为检测同构而遗忘丛参数的微分算子，保留新增点的连接，再在诱导生成元上作 PBW 过滤。令
\(J_P=\mathfrak g_P^{\mathrm{lv}}/\mathfrak n_P^{\mathrm{lv}}\)，
则源、靶的生成复形有共同子项
\(K_P=R\Gamma(X,\mathfrak n_P^{\mathrm{lv}})[1]\)，商映射为
\[
 P_U(J_P)\longrightarrow R\Gamma(X,J_P)[1],
 \qquad P_U(J_P)=\operatorname{PP}(J_P,U).
\]
这是主部忘支撑映射：把源的
\(\operatorname{Cone}(\mathfrak n_{P,\mathrm{out},U}^{\mathrm{lv}}
 \to P_U(\mathfrak g_P^{\mathrm{lv}}))\)
中的外部流换成 \(\mathfrak g_{P,\mathrm{out},U}^{\mathrm{lv}}\)，其余由亚纯分解的正合三角给出。每个对称次数 \(r\) 的扩张过滤只有 \(r+1\) 步，分次商是 \(K_P\) 的对称幂与上述主部商的对称幂之张量；对后者应用关联空间收缩，再穷尽 PBW 次数，得到 (T21)。

对 (T23)，先固定外部 PBW 次数 \(i\)。\(\mathfrak g/\mathfrak n\) 的根高度在有限区间，\(N\) 作用严格提高高度，故系数有有限过滤，分次上作用平凡。再固定正高度 \(n\)，连续上链的次数至多 \(n\)，其过滤也有限。由此每个分次项只是有限个在 \(U\)、\(V\) 取值的主部张量。左边的关联条件是：\(U\) 包含 \(T\) 及第一组曲线变量，\(V\) 包含 \(U\) 及其余变量；右边只要求 \(V\) 包含它们全部。先收缩 \(V\) 再收缩 \(U\)，和一次收缩 \(V\) 的迹相同。逐有限过滤归纳，再取高度直和与 PBW 余极限，得到 (T23)。方图三边为同构，底边遂为同构。

### 5.3 从移动的 Grassmannian 核下降到全部测试

先取 \(W'=\mathbf d(K)\)，其中 \(K\) 位于有限闭 Grassmannian 界 \(Z\)。选择深层级使该同余子群在 \(Z\) 上作用平凡，便能将局部卷积 \(K\star M\) 的局部化与全局丛修正配对比较。光滑图表上的换框由 Laurent 元 \(g\) 及其行列式中央扩张提升 \(\widetilde g\) 给出；对参数导子 \(v\) 和环 Lie 元 \(x\)，公式为
\[
 (v,x)\longmapsto
 \bigl(v,\operatorname{Ad}_{g^{-1}}x+
                 \widetilde g^{-1}v(\widetilde g)\bigr)
\]
同时核对 Lie 作用和行列式修正。参数移动时，两次幂零提升的位移给有限 Taylor 分布；它在包络代数转移模与扭曲微分算子转移模上诱导同一个映射，复合律给相容性。PBW 过滤检查取外部流商的导出张量，改变外部平凡化的歧义则在此商上为恒等。故这是参数 D 模核的比较，可以与任意 \(K\) 配对积分。对每个有限族的极点界、射流和核界选共同更深层级，保证这些比较在加深层级及插点时相同；不需要对所有界一次选定有限深度。

应用前两小节后，左边化为
\[
 \int_{V\supseteq T}
       B_V^0\bigl(\operatorname{ins}_{T,V}(K\star M)\bigr),
\]
行列式线与平移已抵消。相对 Harish–Chandra 紧对象上的 BRST 计算识别它与 (T1) 右边；连续性再扩到全部 \(M\)。

最后，\(\mathbf d:D_{\mathcal L^{-s}}(\operatorname{Gr}_T)\to d_T\) 的转置是正字符 Whittaker 范畴的全嵌入。因此连续泛函及其间映射在预合成 \(\mathbf d\) 后全忠实；将双线性配对柯里化，刚才的同构和其逆都唯一下降到全部 \(W'\in d_T\)。对 \(D(S)\)-值配对，再与参数范畴的对偶配对，归约到同一泛函论证。第4.3节的两槽与对角相容性保证下降后的 (T1) 保留移动点的连接、排列、重复和合并，最后才能对独立标记组作 Ran 积分。

## 6. 装配：条件给定后没有额外的逆函子猜测

先把四类输入的类型列出。全局系数为
\[
 R:A\to\mathcal D,\quad R':A'\to\mathcal D',\qquad
 S:B\to\mathcal C,\quad S':B'\to\mathcal C'.
\]
这里 \(\mathcal D,\mathcal D'\) 分别是 \(G\) 的扭曲 \(s,-s\)、字符 \(+,-\) 的 Ran Whittaker 范畴；\(\mathcal C,\mathcal C'\) 分别是 \(G^\vee\) 的扭曲 \(-s',s'\)、字符 \(-,+\) 的对应范畴。相反字符配对给出指定的范畴对偶
\[
 \mathcal C'\simeq\mathcal C^\vee,\qquad
 \mathcal D'\simeq\mathcal D^\vee .
\]
局部族等价将它们认作相应级别的 Ran 球形模范畴，从而有四个归一化局部化
\[
 L:\mathcal C\to A,\quad L':\mathcal C'\to A',\qquad
 M:\mathcal D\to B,\quad M':\mathcal D'\to B'.
\]
第5节的周期恒等式给出
\[
 RL\simeq(M')^\vee(S')^\vee,\qquad R'L'\simeq M^\vee S^\vee.
\]
准紧截断与外部局部化定理使这四个函子都是商（接口见第7节）。商的转置全忠实，故可唯一分解
\[
 R=(M')^\vee f,\quad(S')^\vee=fL,\qquad
 R'=M^\vee f',\quad S^\vee=f'L'.
\]
其中 \(f:A\to(B')^\vee\)、\(f':A'\to B^\vee\)。这一步只用商的本质满射性与转置的全忠实性；因转置和 \(R\) 均保持余极限，\(f\) 也连续，无须假设局部化右伴随连续。

丛模叠的对偶为 \((A')^\vee\simeq A\)、\((B')^\vee\simeq B\)。使用第3.1节的平移后伪恒等等价
\[
 e_A:(A')^\vee\xrightarrow{\sim}A,\qquad
 e_B:(B')^\vee\xrightarrow{\sim}B .
\]
两边 Plancherel 为
\[
 e_A(R')^\vee R=\mathrm{Id}_A,\qquad e_B(S')^\vee S=\mathrm{Id}_B.
\]
设 \(\Phi=e_Bf\)。原文的两个候选逆确实类型相容：
\[
 \Psi_l=e_A(f')^\vee M(M')^\vee e_B^{-1}:B\to A,\qquad
 \Psi_r=L(L')^\vee(f')^\vee:B\to A.
\]
代入上式分别得到 \(\Psi_l\Phi=\mathrm{Id}_A\) 和
\(\Phi\Psi_r=\mathrm{Id}_B\)，于是
\(\Psi_l\simeq\Psi_l\Phi\Psi_r\simeq\Psi_r\)。
所以两条核心比较与伪恒等等价给出 §13 的全局等价；这里没有使用 \(L^RL=\mathrm{Id}\) 这样的错误商恒等式。

### 全局形式、分支与中心的最小符号测试

原文 §13 声称按“中心字符、丛模叠分支”的顺序
\[
 (\eta,p)\longmapsto(p,-\eta).
\]
负号来自 Whittaker 层的 Cartan 丛 \(T_0(-\sum\lambda_i x_i)\)，而不是普通范畴对偶的形式习惯。对 \(SL_2\leftrightarrow PGL_2\)，源分支只有一个，源的 \(\mu_2\) 字符决定靶的两个分支；此例中 \(-1=1\bmod2\)，故不能用于区分正负号。要测试负号应取 \(SL_3\leftrightarrow PGL_3\)：字符 \(1\bmod3\) 应去分支 \(2\bmod3\)。

中心扭子 \(Q\) 的转移类
\[
 [u_Q]=\int_X\langle[Q]\cup\operatorname{obs}\rangle
\]
有次数 \(1+2-2=1\)。按原文给定的相对障碍积分约定，局部 \(t^\lambda\) 的度是 \(-\lambda\)，所以第一条兼容为
\(\Phi\tau_Q^!\simeq u_Q^{-1}\otimes\Phi\)，第二条为
\(\tau_{Q'}^!\Phi\simeq\Phi(u'_{Q'}\otimes-)\)。
在平凡扭子的自动同构 \(z\) 上，前式两侧都作用为 \(\eta(z)\)；后式两侧都为 \(p(z')\)。这核对了群胚自动同构的符号。碰撞族的局部比较供给这些等式对扭子态射、张量积与插入的完整自然性。

## 7. 外部结果：准确接口与阅读状态

Bogdanova 的 arXiv:2606.29585v1，§1.1.5、Conjecture 1 已读：给出本篇所证明的 de Rham 猜想，使用 \((c-h^\vee)/(2h^\vee)\) 的行列式指数与 \(-1/(rc)\) 的对偶参数。

GLC II 的 arXiv:2405.03648v3 中，Theorem 13.4.2 已读：对准紧开集 \(j:U\hookrightarrow\operatorname{Bun}_H\)，\(j^*\operatorname{Loc}_{H,\kappa}\) 是局部化商，级别 \(\kappa\) 任意。原文 §13 先用 §2 的无理截断将全部范畴约到准紧开集，再应用此定理。§10 的一般级别构造先于 §14 的临界级别专门化。Proposition 10.1.11 的局部相对行列式与全局行列式比值给
\(-\operatorname{Kil}=2\operatorname{crit}\mapsto d\log L_H\)；
其刚性化点与本文 \(P_0\) 的区别仅为常数线，不改扭曲微分算子层。

同版 Theorems 12.5.18、12.8.8 已读，提供插入真空、Ran 积分后的带字符周期比较，作为第5节的外部周期接口。

Ran 收缩另依赖 Gaitsgory《Contractibility of the space of rational maps》，arXiv:1108.1741v3。已读 Theorem 1.6.5（正文第18页）、§2.5.12 与 Corollary 2.5.13（第33页）；原件与抽取文本为 `guide/evidence/family-069/sources/arxiv-1108.1741v3.pdf`、`guide/evidence/family-069/sources/arxiv-1108.1741v3.txt`。前者对连通分离概形 \(X\) 给出迹同构 \(H_\bullet(\operatorname{Ran}X)\simeq\mathbb C\)。后者允许任意基概形 \(S\)、移动标记 \(x^A:S\to X^A\) 和 \(F\in D(S)\)：取 \(Z(I)=S\times X^I\)，记普通 Ran 的投影为 \(q\)，包含这些标记的 Ran 投影为 \(p_A\)，则
\[
 (p_A)_!p_A^!F\xrightarrow{\sim}q_!q^!F
 \simeq F\otimes H_\bullet(\operatorname{Ran}X)
 \xrightarrow{\sim}F .
\]
该文的概形均为有限型；对其中任意基变换 \(S'\to S\) 可重用同一相对陈述，无须映射平滑或标记互异。本篇 \(X\) 射影，元组与关联空间的伪固有表示使上述迹与 ! 基变换相容。

原文 §10 的适用性说明可以直接检查：与规定标记取并集给 \(u:S\times\operatorname{Ran}X\to\operatorname{Ran}_{\supseteq A}X\)，忘掉包含条件给 \(i\)，且 \(u i=\mathrm{Id}\)。所以包含标记的增广迹是普通增广迹的收缩项；构造在任意上述基变换后不变。这也解释了相对推论的用途：第5.2节取基概形为旧参数与 \(X^r\) 的积，把旧标记和所有曲线变量 \(z_j\) 合为规定标记；嵌套情形在每个有限元组图表上先收缩较大的 \(V\)，再收缩 \(U\)，积分迹的复合正好是一次收缩的迹。

Drinfeld–Gaitsgory arXiv:1112.2402v8 的 Proposition 7.3.5、Theorem 7.4.3、Corollary 7.4.5、Proposition 10.1.3 及 Lemma 10.3.2 已读：给出准紧 HN 开集、特征零的典范约化分层与 \(2g-2\) 消失阈值，适用于实际约化群。Gaitsgory arXiv:1404.6780v3 的 Theorem 0.1.6 已读，其普通奇迹对偶在 §3 承担度零环面的基例。

对于 §3，Drinfeld–Gaitsgory arXiv:1311.2071v4 的 Theorems 1.2.3/1.2.5、§2.4、Proposition 2.5.2、Appendices C–D 已读：普通第二伴随面向全部 D 模，插值群与光滑稳定子使用任意约化群的实际权格；第4.4节在此几何上检查扭曲平凡化和伴随映射。

实际全局形式有一个重要引用边界。Braverman–Gaitsgory arXiv:math/9912097v2 的 §0.4.1 假设导出群单连通，Theorem 5.1.5 的通用局部无环性输入也在 holonomic 范围；Schieder arXiv:1607.00586v2 的 §2.1.1 同样作导出群单连通的简化。两处原文已读。本文 `paper/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026/build/sections/03-pseudoidentity.tex` 第539–566行区分了 Schieder Proposition 3.2.2 的该范围，再用实际最高权的正倍数、零因子平坦分层与 Levi 块重做所需分层；第490–531行以 Cartan 代数为整环核对赋值可加性，完成实际形式下的固有性。

其余承重引用如下；“已读”指已读到所列声明及相关证明接口。

| 外部输入 | 实读版本与定位 | 在本篇中的准确用途 |
|---|---|---|
| 零级温和／反温和部分与 Hecke 线性 | GLC I，arXiv:2405.03599v3，§1.4.2、Corollary 1.6.5、§5.1 (5.1)；GLC II v3，§18.1.1、Proposition 18.1.6 (18.4)；GLC V，arXiv:2409.09856v3，主定理、Corollary 2.3.11；均已读 | 第4.1节的零纤维消去及统一次数界 |
| QCA 的次数界 | Drinfeld–Gaitsgory，arXiv:1108.5351v3，Theorem 1.4.2(ii)，已读 | \(\operatorname{LS}_{\check G}\) 上固定的 QCoh 上同调上振幅，不依赖表示标签或点数 |
| 混合 Hodge 结构的函子性与权重操作 | Deligne, Hodge II (1971)，1.2.10.1、Lemma 1.2.11、Theorem 2.3.5(iii)、2.3.8；Saito, Mixed Hodge Modules (1990)，Theorems 0.1/0.2、§4.5；Tubach arXiv:2407.02256v3，Theorem 3.1、Remark 3.3、Propositions 3.16、3.21–3.23；均已读 | 稳定像的混合结构、齐次相容提升与六运算。一般 Artin 叠的无界 * 像不自动有界；本文所用 gerbe 分层将计算约到有限概形图表 |
| 有限 Whittaker 测试 | Faergeman–Raskin arXiv:2207.02955v1，Lemmas 4.2.0.1、4.3.0.1、Remark 4.4.0.1；Bogdanova arXiv:2508.19058v1，Lemma 3.1.4 的证明 (3.2)；均已读 | 前者支持任意实际群及附加参数；后者假设群为伴随型。所需有限剩余平均化比较由下述直接证明覆盖任意实际形式 |
| 全局 Whittaker 对偶与 Ran | Lin arXiv:2211.05282v1，Propositions 2.2.4/2.2.5、§2.2.6、§§8.1.3–8.1.4、Theorem 9.0.2，已读；Gaitsgory arXiv:1811.02468v6，Theorems 5.5.2、7.2.3–7.2.4、7.3.3，已读 | Lin 给普通级别、相反字符与 \(-2\delta_N\) 校正；Gaitsgory 给含碰撞的多点比较，本文 §4 为其提升行列式扭曲 |
| 局部 \(W\) 模与相对模型的点输入 | Raskin 作者版，更新于2023-07-01，Theorems 4.2.1、4.5.1、4.6.1、5.1.1、6.1.1、Lemma 7.3.3；arXiv:2002.01395v1，§§9.11–9.13、Theorem 10.8.1；Kac–Wakimoto arXiv:math-ph/0304011v2，Theorem 4.1、Remark 4.1；均已读 | 重整化 Skryabin、广义真空与 BRST 闭的顶点场代表。Raskin Warning 7.3.1 的文献保留针对所有级别，所需无理级别在已证明范围内 |
| 点标签与实际全局形式 | Arakawa–Frenkel arXiv:1807.01536v3，Theorems 2.1–2.3、(2.6)/(2.8)；Campbell–Dhillon–Raskin，Compositio 157 (2021)，Theorem 3.7.3、Remark 3.7.5、§4.2、Proposition 4.2.2、§4.3；均已读 | 复无理参数的次数集中、简单性、双标签交换与实际群形式约化。CDR 的负级别范围含非实参数，提供忘却因子化结构后的 DG 点等价 |
| 非特征性与凝聚对偶 | Schapira《An introduction to D-modules》，作者公开稿 v7 (2020-03)，Theorems 2.1.1、2.3.7、2.3.10，Corollary 2.3.9、Proposition 1.6.3；arXiv:1206.1435v1，Theorem 1.3.4；均已读 | 覆盖 §3 第159–168、289–301行的准确接口：微支撑与特征簇、任意凝聚 D 模的非特征逆像及对偶。原文所引 HTT 2.4.6/2.7.1(ii)、KS 11.3.3 的原书页仍未读；此处已有核过的替代接口，剩余是书目编号限制 |

替代接口在本篇如何适用，可分两步核查。首先在光滑环境中的正则 holonomic 核 \(J\) 上，把非零流向量场局部整直为 \(\partial_t\)。流保持开集及边界，所以该对局部为圆盘与横截对的乘积，局部系统及其零延拓也沿圆盘拉回；向量场为零处结论自动成立。由微支撑的半空间定义，沿这个乘积方向非零的余向量不在微支撑中。Schapira 2012 Theorem 1.3.4 给出 \(\operatorname{SS}(\operatorname{Sol}M)=\operatorname{Char}(M)\)，2020 Proposition 1.6.3 给出对偶不改特征簇；结合正则 Riemann–Hilbert 对应，得到原文所需的“特征余向量湮灭流方向”。原文构造的 Levi 流在基底上张成切空间，故 \(J\) 的闭直像特征簇与非零水平余向量不相交。

其次取紧化的概形图表 \(Z\)、局部选取的闭嵌入 \(\iota:Z\hookrightarrow V\) 和光滑映射 \(r:V\to S\)，使 \(\bar q=r\iota\)。投影公式把待检对象的闭直像写成
\[
 \iota_*(J\otimes^!\bar q^!E)
 \simeq \iota_*J\otimes^!r^!E .
\]
任意凝聚 Levi 系数 \(E\) 的 \(r^!E\) 只有水平特征余向量；因此
\(\operatorname{Char}(\iota_*J)\cap
[-\operatorname{Char}(r^!E)]\)
仅含零余向量。Theorem 2.1.1 将外积特征簇识别为直积，故这恰是对角的非特征条件；Theorems 2.3.7、2.3.10 给出凝聚性及与对偶的相容性，按本文 \(!\)-归一化保留维数平移。这些声明不要求 \(E\) holonomic。讲义在解析范畴陈述，但代数转移模与对偶的自然比较可解析化；解析局部环在代数局部环上忠实平坦，配合好过滤逐点检测有界凝聚性和比较锥为零，故回到原文的代数 D 模。线扭曲在框架挠子上作此计算，再下降。新来源为 `guide/evidence/family-069/sources/schapira-dmod.pdf`、`guide/evidence/family-069/sources/schapira-dmod.txt`、`guide/evidence/family-069/sources/arxiv-1206.1435v1.pdf`、`guide/evidence/family-069/sources/arxiv-1206.1435v1.txt`；前者取自作者网址 https://webusers.imj-prg.fr/~pierre.schapira/LectNotes/Dmod.pdf 。

有限剩余平均化的直接证明如下。在 \(H/B^-\) 上，开 \(N\)-轨道的非退化字符层的 \(j_!\)、\(j_*\) 都强 \((N,\chi)\)-等变。每个非开轨道取一个左下降简单根 \(\alpha_i\)，其稳定子包含 \(N_{\alpha_i}\)，而 \(\chi\) 在该群上非零。故该轨道的强等变范畴为零，边界锥为零，得到干净延拓。幺幂稳定子在旗簇扭曲线上作用平凡，证明适用于任意实际中心形式；卷积该通用有限核给所需平均化比较。

版本对照：本文所用 CDR 出版 Remark 3.7.5、Proposition 4.2.2，在 arXiv:1907.03204v2 中分别是 Remark 3.7.7、Proposition A.2.2；出版 §4.2/§4.3 对应 v2 的 Appendix A.2/A.3。

全局来源原件、文本与校验和在 `guide/evidence/family-069/sources/`、`guide/evidence/family-069/sources/source-sha256.txt`。变形来源及校验和在 `guide/evidence/family-069/deformation-sources/`、`guide/evidence/family-069/deformation-sha256.txt`；局部七篇来源的版本、URL、SHA256、编号对照在 `guide/evidence/family-069/local-sources/citations.json`。补充有限模结果的 Deligne 原版定位在 `guide/evidence/family-069/colimit-source.json`。十三节及 main、references 的本地 Git 对象已与指定上游提交逐一核对相同；原始 API 清单保留于 `guide/evidence/family-069/sources/upstream-sections.json`、`guide/evidence/family-069/sources/upstream-build.json`。上游目录叫 preprints，本地镜像目录叫 paper。

本文没有配套 Lean。两个有限代数模型脚本的复算命令为：
```bash
python3 guide/evidence/family-069/deformation-check.py
python3 guide/evidence/family-069/colimit-check.py guide/evidence/family-069/colimit-witness.json --self-test
```
最终独立复算（2026-11-10）重现了36个 Tor 稳定化案例、6个碰撞模型、长度1–8的精确截断与45个挠模阶段对，并拒绝差一位的界、不保混合结构的过渡、临界等号和错维矩阵等负控制；输出与留存 JSON 相同。配置脚本检查已知 Poincaré 多项式的次数及权重算术，不独立计算几何上同调。无限系统、混合结构存在性及几何接口由上文手算与所列来源承担，不归有限实验认证。另实跑 math-claims 的 --list、--check-paths、--check，复核来源哈希及15个上游 Git 对象；math-cite 的5项、math-claims 的6项工具回归均通过。

## 8. 核验结论

### 改进

第4.2节将原文统一权重上界放宽为逐源有限截断分离判据，并给出保持混合结构的秩一临界模型。原证明的安全长度得到显式公式，但没有阶段下标的有效界。这是标准混合 Hodge 理论与 Nakayama 引理的推论，不声称文献新颖性。

另有四项手算确认：\(SL_2\) 的 theta 扩张表明严格 HN 阈值不可放宽；法向超平面配置的复形权重至多余维，给固定图表上与次数无关的茎权重上界；有限 Whittaker 测试只需有限非共振条件；总留数 Gram 行列式为单位，直接说明碰撞不退化。与原文相比，保留了 \(2g-2\)、权重下降 \(2a\)、单位锥下界 \(3\) 和除子幅度 \([0,1]\)。

### 错误与不足

**未发现可确认的原论文实质数学错误或反例。** 核查范围包括全部证明链、级别与符号、实际全局形式以及第7节列明的引用接口。

有效性仍有限：`paper/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026/build/sections/05-deformation.tex` 的 deform:colimit 与 §6 的极点系统未给可计算的消失阶段。第4.2节末的任意延迟模型说明，仅凭权重不能补出此界。这限制有效计算，不影响定性消失结论。

### 已核验

手算与逐步审读覆盖：§2 对无界对象的准紧约化；§3 扭曲伪恒等的抛物归纳；§4 Whittaker 对偶归一化；§§5–6 的稳定像、统一权重与余极限；§§7–9 的相对目标、边界满射、无界实现及两槽相容性；§§10–12 的有限层级周期方图与移动核下降；§13 的商分解、左右逆及中心符号。实际全局形式和全部分支在这些步骤中均保留。下表区分手算、所需外部条件和有限计算。

| Claim | Source | Basis | Evidence |
|---|---|---|---|
| 主定理：全部实际全局形式、全部分支、全部无理复级别的等价 | paper，§1 thm:main；§§2–13 | conditional on a cited result (第7节列明的 GLC、局部基本等价、Feigin–Frenkel/Skryabin、Gaitsgory Ran 可缩性、混合 Hodge 与非特征性定理) | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第3–8节 |
| 四范畴与题设级别相差源上的一次行列式线运输 | paper，§2 foundations:four-categories；§13 (G4) | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第3.1节 |
| 非零整数惯性权重乘无理指数杀掉全部扭曲 D 模，包括无界对象 | paper，§2 foundations:inertia | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第3.2节 |
| 准紧 HN 约化适用于全部对象而非只对紧或 holonomic 对象 | paper，§2 foundations:cutoff | conditional on a cited result (Drinfeld–Gaitsgory, arXiv:1112.2402v8, §7.3–7.4 and Proposition 10.1.3) | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第3.2、7节；`guide/evidence/family-069/sources/arxiv-1112.2402v8.txt` |
| SL2 theta 非零扩张使严格 HN 阈值达到边界 | ours，原文截断阈值的边界确认 | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第3.2节，自同构群与残余 gerbe 的计算 |
| ! 对角的扭曲伪恒等等价及实际形式分层 | paper，§3 pseudo:equivalence | conditional on a cited result (Drinfeld–Gaitsgory 常数项/Vinberg，Gaitsgory 普通奇迹对偶，Schapira 2020 Theorems 2.3.7/2.3.10 与 arXiv:1206.1435v1 Theorem 1.3.4 的非特征性接口) | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.4、7节；`guide/evidence/family-069/sources/schapira-dmod.txt`；`guide/evidence/family-069/sources/arxiv-1206.1435v1.txt` |
| 单一线性输入、保持混合结构的过渡与统一权重下的对数余极限推导 | paper，§5 deform:rank、deform:colimit | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.1节，Tor 稳定像与同一过渡杀全部长度 |
| 全局 Whittaker 系数的左逆 | paper，§6，全局 Plancherel | conditional on a cited result (GLC I/II/V，Faergeman–Raskin，Lin，Saito/Tubach 六运算) | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.1、7节；`guide/evidence/family-069/deformation-sha256.txt` |
| 法向辫子超平面配置的复形权重至多余维，结合次数界得到共同上权重 | ours，显式化 paper §6 weight-estimate 的计算 | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.1节，前提为原文统一次数界 |
| 有限测试的非共振充分条件及 SL2/PGL2 的 8、4 | ours，显式化 paper §6 planch:finite-test 的参数使用 | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.1节 |
| 有限截断刚性、逐源分离判据与次临界消元阶段函数 | ours，标准混合 Hodge/Nakayama 与 paper 权重证明的推论 | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.2节；`guide/evidence/family-069/colimit-source.json` |
| 各阶段分别有上权重界即可替代统一界、或临界等号即可保证消失 | ours，被检验并否定的简化，不是 paper 的断言 | refuted | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.2节，保持混合结构的秩一系统与非零泛点余极限 |
| 安全对数长度不提供仅依权重的消失阶段下标界 | ours，任意多恒等映射后接零映射的延迟模型 | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.2节末 |
| 相对重整化 W 目标、Ext 连续性与配对伴随 | paper，§§7–8 | conditional on a cited result (Raskin 的 Skryabin/自由场定理与同调方法，Kac–Wakimoto Theorem 4.1/Remark 4.1) | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.3、7节；`guide/evidence/family-069/local-sources/citations.json` |
| 复无理参数下点标签的集中、简单性与完整根数据交换 | paper，§9 的点输入；literature，AF、CDR | conditional on a cited result (Arakawa–Frenkel v3, Theorems 2.1–2.3; CDR published Theorem 3.7.3 and §4) | `guide/evidence/family-069/local-sources/arakawa-frenkel-v3.txt`；`guide/evidence/family-069/local-sources/cdr-published-2021.txt`；导读第4.3、7节 |
| 给定相对伴随与点上单位锥下界后，边界满射、无界实现及两槽比较的推导 | paper，§9 local:heart、local:one-slot、local:two-slot | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.3节，边界满射及真空特化 |
| 总留数 Gram 在重根碰撞仍为单位行列式；分层限制不足以确定粘合 | ours，原文机制的手算确认及反捷径例 | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第4.3节，两点矩阵及 A1 非分裂扩张 |
| 准紧开集上的任意级别局部化是商 | literature，GLC II，arXiv:2405.03648v3，Theorem 13.4.2 | conditional on a cited result (GLC II, Theorem 13.4.2) | `guide/evidence/family-069/sources/arxiv-2405.03648v3.tex`，标签 t:Loc is loc |
| 有限层级周期归一化抵消为完整弧格的公式 | paper，§11 (T9)、(T14) | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第5.1节 |
| Ran 周期比较中的有限层级方图、移动核及全部测试下降 | paper，§§10–12 loc:kernel、loc:period-comparison | conditional on a cited result (GLC II v3, Theorems 12.5.18/12.8.8；Gaitsgory, arXiv:1108.1741v3, Theorem 1.6.5、§2.5.12、Corollary 2.5.13) | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第5、7节；`guide/evidence/family-069/sources/arxiv-2405.03648v3.tex`；`guide/evidence/family-069/sources/arxiv-1108.1741v3.txt` |
| 周期配对、Plancherel、伪恒等与局部化商给出两边逆 | paper，§13 (G1)–(G4) | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第6节，条件性装配 |
| 所声明的中心扭子公式与分支交换在自动同构上的符号相容 | paper，§13 (G6)–(G8) | checked by hand | `guide/Global-quantum-geometric-Langlands-at-irrational-level-October-4-2026.md`，第6节 |
| Tor 稳定化、Kummer 反面模型和6个有限碰撞多项式的精确检查 | ours，有限代数模型 | checked by computation | `guide/evidence/family-069/deformation-check.py`；`guide/evidence/family-069/deformation-check.json` |
| 截断长度1–8、换基、45个挠模阶段对与4项拒绝控制 | ours，有限矩阵实验 | checked by computation | `guide/evidence/family-069/colimit-check.py`；`guide/evidence/family-069/colimit-witness.json`；`guide/evidence/family-069/colimit-results.json` |
