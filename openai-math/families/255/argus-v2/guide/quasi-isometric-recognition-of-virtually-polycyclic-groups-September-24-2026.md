# 虚多循环群的拟等距识别：中文导读与核验

在所列已核文献的输入下，本次手工核验未发现主证明的数学错误，并可把有界高度路径的装填次数明确为典范高度核的齐次维数；作者 Lean 的完整主定理尚未在本机编译核验。

审读对象为 `openai/math` 固定提交 `4eaee87548250b2682affda7d05d947c05554bae` 中第 255 族 *Quasi-isometric recognition of virtually polycyclic groups*，日期为 2026 年 9 月 24 日。正文的本地路径为 `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/`；上游路径以 `preprints/` 开头。以下先解释论文，再说明核验依据。

## 一、先读准结论

**定理 1.1（识别）。** 设 \(P,H\) 都是有限生成群，\(P\) 虚多循环。如果 \(H\) 与 \(P\) 拟等距，则 \(H\) 也虚多循环。对 \(H\) **没有预先的可解性或初等顺从性假设**。虚多循环是指有有限指数多循环子群；多循环群有有限的次正规列，商群都是循环群。

**格点推论。** 如果有限生成群 \(H\) 拟等距于某个连通、单连通可解 Lie 群中的格点群，则 \(H\) 的某个有限指数子群可实现为**某个**连通、单连通可解 Lie 群中的余紧格点。结论不指定原来的环境 Lie 群；不能读成同一 Lie 群中的格点刚性。

**定理 1.4（一致有界高度）。** 固定连通、单连通、实三角化、幺模 Lie 群 \(G\)、其左不变 Riemann 度量及高度空间 \(W\) 上的范数。存在只依赖 \(G\) 的有限群 \(\mathcal A_G\leq\mathrm{GL}(W)\)，使得
\[
 \forall K\geq1\ \forall C\geq0\ \exists B=B(G,K,C)\
 \forall F\in\mathrm{QI}_{K,C}(G)\ \exists A_F\in\mathcal A_G\
 \forall g\in G,\quad
 \|\pi F(g)-\pi F(1)-A_F\pi(g)\|\leq B.
\]
这里的 \(B\) 对固定拟等距常数的**全部** \(F\) 一致，不是每个 \(F\) 各取一个界。高度是伴随表示的全部实对角特征 \(\chi_j\) 的公共核所给的商：
\(\mathfrak k=\bigcap_j\ker\chi_j\)，\(W=\mathfrak g/\mathfrak k\)，\(\pi:G\to W\) 为积分所得同态。它不是整个 Abel 化。\(W=0\) 当且仅当 \(G\) 幂零，此时高度结论为空，识别另用多项式增长定理。

## 二、为什么这个问题值得做

拟等距丢弃有界尺度和固定倍数的长度误差，通常看不见一个群的具体表示。本文要识别的不是某个群的同构型，而是一个完整的代数类别。难点在于比较群 \(H\) 开始时甚至未必可解：不能先用可解群的分类再证明它可解。论文的策略是先从几何构造 \(H\) 的有限指数子群到向量群的同态，再用核的增长证明初等顺从性，最后才调用群上同调的结构定理。

必须区分两个模型。余紧格点 \(\Gamma\leq S\) 给有限的 \(K(\Gamma,1)\) 和 Poincaré 对偶；实三角化的 \(G\simeq_{\mathrm{QI}}S\) 给实权空间和高度几何。论文不要求 \(G\) 自身含有格点。

## 三、第一次阅读的路线

1. `introduction.tex` 和 `recognition.tex`：先看要构造什么、统一误差最后用在哪里。识别末段必须按 \(\mathrm{FP}_\infty\)、有限指数的有限分类空间、有限上同调维数、对偶、再到多循环的顺序读。
2. `models.tex` 和 `boxes.tex`：建立 \(G=ND\) 的非唯一坐标；把受高度约束的路径换成指数端点体积 \(e^{rP(E)+o(r)}\)。
3. `polynomial.tex`、`stationary.tex`：前者使参数限制后仍保留指数体积，后者先对平稳概率模型产生候选斜率及逆斜率。
4. `profiles.tex`、`labels.tex`、`offsets.tex`、`uniformity.tex`：从平均对象回到任意拟等距，排除折叠、邻片斜率分歧及平移分歧，得到全局一致次线性误差。
5. `boundary.tex`：以收缩边界及像集 Haar 体积把次线性误差升级为有界误差。此处不能省读；识别中的多项式增长需要有界高度，而不只是次线性高度。

第一遍可以暂略幂零坐标的 BCH 展开、实多项式像体积引理的技术证明和 `lipschitz-appendix.tex` 的平滑细节；但应保留它们的输入、输出与一致性要求。

## 四、核心思想与一个手算例

在 \(\mathrm{Sol}=\mathbb R^2\rtimes\mathbb R\) 中，
\[
 (x,y,t)(x',y',t')=(x+e^tx',\,y+e^{-t}y',\,t+t'),
 \qquad ds^2=e^{-2t}dx^2+e^{2t}dy^2+dt^2.
\]
在高度 \(t\) 做长度一的水平移动，\(x\) 可改变约 \(e^t\)，\(y\) 可改变约 \(e^{-t}\)。让长度 \(O(r)\) 的路径访问 \(rb\) 和 \(ra\)，在高处移动 \(x\)，低处移动 \(y\)，再回到共同高度，可以填出边长约 \(e^{rb}\)、\(e^{-ra}\) 的矩形。因此允许高度集 \(r[a,b]\) 给指数面积率
\[
 P([a,b])=b-a.
\]
坐标宽度中的多项式因子只给对数体积增加 \(O(\log r)\)，不改这个指数率。若线性高度斜率是 \(t\mapsto at\)，正反两次体积比较给 \(1\leq |a|\) 和 \(|a|\leq1\)，故只剩 \(a=\pm1\)。这解释了有限斜率群在最小非幂零模型中的含义；它本身不证明一般拟等距有斜率。

一般 \(N\) 非交换，不能只乘生成方向的宽度：长括号还会产生新的方向。本文把所有非零括号词放进 \(P(E)\)。指数体积比较限制斜率；图册、平稳化及相邻片比较负责证明这些斜率能拼成同一个全局对象。

## 五、短符号表

| 符号 | 含义 |
|---|---|
| \(N,D\) | 非零 Cartan 权空间生成的幂零正规群，以及幂零 Cartan 子群 |
| \(q:N\rtimes D\to G\) | 乘法满射；通常不单射 |
| \(W,\pi\) | 伴随实特征定义的典范高度商及高度同态 |
| \(\alpha_i\) | \(\mathfrak n/[\mathfrak n,\mathfrak n]\) 的非零生成权 |
| \(S_w\) | 在权 \(\gamma\) 空间上乘 \(e^{\gamma(w)}\) 的精确自同构 |
| \(D_\infty,\Delta_r\) | Cartan 幂零群的分次极限及加权坐标放大 |
| \(P(E)\) | 允许凸高度集 \(E\) 的括号生成端点体积指数 |
| \(\mathcal A_G\) | 保持全部相应体积率的有限线性对称群 |
| \(\mathrm{FP}_\infty,F\) | 有限生成投射分解的逐维有限性；有限 CW 分类空间，二者不可混同 |

## 六、几个承重步骤

### 6.1 不能把 Cartan 坐标当半直积分解

正文明确保留
\[
 \ker q=\{(a^{-1},a):a\in N\cap D\}.
\]
\(N\cap D\) 可以非平凡。固定 \(d\) 的切片 \(n\mapsto nd\) 才是单射；若同时改变 \(n,d\)，体积计数必须控制同一点的多重提升，不能直接把 \(N\rtimes D\) 的体积当成 \(G\) 的体积。

典范高度杀掉 \(N\)，也杀掉 \([\mathfrak d,\mathfrak d]\) 和 \(\mathfrak n\cap\mathfrak d\)。对 \(d=\exp v\)，权空间上的作用为
\[
 \operatorname{Ad}_d=e^{\gamma(\pi d)}
 \sum_{j=0}^{b_\gamma-1}\frac{T_\gamma(v)^j}{j!},
 \qquad T_\gamma(v)^{b_\gamma}=0.
\]
幂零群内在球半径 \(r\) 的第 \(j\) 层对数坐标为 \(O((1+r)^j)\)，故上式的幺幂部分及其逆只有多项式损失。这是正文已有证明的展开，不是补加“半单”假设。

最小的重叠例子就在正文：令 \([X,Y]=Z\)，\([T,X]=X\)，\([T,Y]=-Y\)，\([T,Z]=0\)。则 \(\mathfrak n=\langle X,Y,Z\rangle\)，\(\mathfrak d=\langle T,Z\rangle\)，交为 \(\mathbb RZ\)。它同时说明为什么不能丢零权括号：在高度区间 \([a,b]\) 上，\(X,Y,Z\) 的支持指数依次为 \(b,-a,b-a\)，故
\[
 P([a,b])=2(b-a),
\]
而不是只数 \(X,Y\) 所得的 \(b-a\)。\(Z\) 的实际权为零不妨碍交换子在两个不同支持高度产生指数宽度。

### 6.2 全括号计数为什么不丢方向，也不重复计数

令 \(\mathcal Z\) 包含生成元中长度不超过幂零阶的**全部非零括号词**，括号放置和字母出现次数都保留。定义
\[
 s_i(E)=\max_E\alpha_i,\quad
 h_Z(E)=\sum_{\text{词 }Z\text{ 中的字母}}\!s_i(E),\quad
 P(E)=\max_{\mathcal B\subset\mathcal Z\text{ 为基}}
                      \sum_{Z\in\mathcal B}h_Z(E).
\]
这里通常 \(h_Z(E)>\max_E\gamma_Z\)：各字母可以在不同高度使用。\(P\) 取基的最大值，而不是把所有重复或成比例的词都加起来。

正文“盒运算”引理的关键不是 BCH 公式本身，而是**最大基的交换论证**：若
\(Y=\sum_{Z\in\mathcal B}c_{Y,Z}Z\) 且 \(c_{Y,Z}\neq0\)，以 \(Y\) 换掉 \(Z\) 仍为基，故 \(h_Y\leq h_Z\)。于是缩放后的坐标系中所有词的系数一致有界，括号结构常数也一致有界；有限 BCH 才能给多项式损失。即使最大基随 \(E,r\) 改变，也只有有限个未缩放基需要比较。

每个词基都必须包含所有 \(X_i\)，因为长词在 \(\mathfrak n/[\mathfrak n,\mathfrak n]\) 中为零。又因幺模性使 \(\mathfrak n\) 上总权为零，各基给出正整数关系 \(\sum_i c_i\alpha_i=0\)。因此 \(P\) 平移不变，且
\(p(w)=P([0,w])\) 是多面体范数。其单位球的顶点有限且张成 \(W\)，故线性等距群有限。进一步，削去一个在原生成权方向都不可见的小球冠，可以证明保持全部 \(P(E)\) 的线性映射必须置换**有向**生成权射线；只保持线段范数还不应直接替代这个结论。

上下装填分开进行。下界在固定 \(D\) 位置 \(Nd\) 上用 \(N\)-Haar 体积，参数化单射，且 \(\operatorname{Ad}_d\) 的行列式为一，投影小球能吞掉的 \(N\)-体积一致有界。上界则给每个端点任取一个提升；\(q\) 全局 Lipschitz，所以 \(G\) 中分离的点，其任意提升仍分离。小球厚化后的提升落在
\[
 B_r(E,\operatorname{poly}(r))\times B_D(O(r)),
\]
乘积 Haar 体积为 \(\operatorname{poly}(r)e^{rP(E)}\)。这里**不需要** \(q\) 单射。

若 \(D\) 位置本身变化，还需正文“变提升多重性”引理。两个投影在同一固定小球中的提升满足
\[
 u_0^{-1}u=\operatorname{Ad}_{d_0}(v)a,\qquad
 a=d_0ed^{-1}\in N\cap D.
\]
若 \(\|d\|_D\leq T\)、\(\|\pi d\|\leq H\)，两个因子的对数坐标都受
\(\operatorname{poly}(1+T)e^{cH}\) 控制；交叠元素的 \(D\)-对数与 \(N\)-对数是同一个向量。因此一个投影小球隐藏的 \(N\)-体积最多同样量级。取 \(T=O(r),H=o(r)\)，只损失 \(e^{o(r)}\)，不假定交叠中心化、离散或平凡。

### 6.3 从平均斜率到任意拟等距：不能跳过的四步

**第一步：先只对一个固定不变测度求斜率。** 把拟等距及其粗逆一起放进连续映射对的空间 \(\Omega\)，归一化 \(F(1)=1\) 得紧截面 \(X\)，归一化粗逆则得另一个截面 \(Y\)。定义重心移动
\[
 T_xF(z)=F(x)^{-1}F(xz),\qquad b(x)(F)=\pi F(x).
\]
对 \(X\) 上固定遍历不变概率 \(\mu\)，这是强连续酉 \(L^2\)-表示上的余循环。Cornulier–Tessera 的约化一阶上同调消失定理使去掉常函数部分后的余循环被余边界逼近，常函数部分是同态 \(l:G\to W\)。把长路径分成有界小步，在一个固定逼近函数上先令 \(r\to\infty\)，再令逼近误差趋零，得到
\[
 r^{-1}\sup_{\|x\|_G\leq Rr}
        \|\pi F(x)-l(x)\|_{L^2(\mu)}\longrightarrow0.
\]
这是 **\(L^2\) 范数的上确界**，不是上确界的 \(L^2\) 范数，更不是逐点统一收敛。令 \(V=\mathfrak d/[\mathfrak d,\mathfrak d]\) 为 Cartan Lie 代数的 Abel 化，\(E_V\subset V\) 为任意非空紧凸集；这里 \(\pi,l\) 也表示它们在 \(V\) 上诱导的线性映射。有限路径网格及 Chebyshev 已足够支持前向体积比较，给
\(P(\pi E_V)\leq P(lE_V)\)。线段测试再推出 \(l=A\pi\)，其中 \(A\) 可逆。

反向比较必须使用**同一个 \(A\) 的逆**。随便为粗逆另选遍历概率可能得到无关斜率。正文利用 \(\Omega\) 的两种乘积坐标
\(G\times X\) 与 \(Y\times G\)，将 Haar 乘 \(\mu\) 的双不变测度分解为 \(\nu\times\) Haar。不能把它直接限制到可能为零测的截面；正文先对整球平均，构造粗逆的 \(L^2\) 转移函数，并以一个固定大紧集支配移动中的积分域。所得粗逆斜率正是 \(A^{-1}\)，故正反比较合为 \(P(AE)=P(E)\)，即 \(A\in\mathcal A_G\)。这一阶段仍没有对所有不变概率的一致速率。

**第二步：从采样图册的极限排除折叠。** 固定 Euclidean 范数，取高度多面体
\(\mathcal C=\{w:\alpha_i(w)\leq\|\alpha_i\|\ \forall i\}\)，其中右边是对偶范数。选足够大的固定 \(c>1\) 和充分小的 \(\delta>0\)，使开放图册域
\[
 \mathcal U_\delta
 =\{z\in D_\infty:\pi z\in(1-c\delta)\operatorname{int}\mathcal C\}
\]
留有高度余量。从第 6.2 节按模板 \(\mathcal C\) 缩放的 \(N\)-盒 \(B_r(\mathcal C)\) 中，以归一化 Haar 测度抽取 \(a\)，再令 \(n=ak_0\)。这里的“后缀”是右乘的 \(N\)-元素 \(k_0\)，允许它来自略大的盒 \(B_r((1+\delta)\mathcal C,e^{o(r)})\)，第二参数控制额外的坐标半径。放大图册的高度函数为
\[
 f_{r,x,n}(z)=
       \frac{\pi F(xn\Delta_rz)-\pi F(x)}r,\qquad z\in\mathcal U_\delta.
\]
“占据概率”平均的是在随机点 \(xak_0\Delta_rz\) 重新归一化所得的映射对：除上述 \(a\) 外，独立按图册域内的紧支连续概率密度抽取 \(z\)。其弱极限不变。水平段是
\(J=\{z\exp_\infty(tv):0\leq t\leq T\}\Subset\mathcal U_\delta\)，其中 \(v\in V\) 视为分次群的第一层向量，\(T>0\)，\(\Subset\) 表示紧包含。不变占据概率及平稳增量给每条这样的段的平均增量约束
\[
 \frac{f(z\exp_\infty(Tv))-f(z)}T
                \in\operatorname{conv}(\mathcal A_G\pi v).
\]
参数限制后的端点体积则给独立的整段约束
\[
 P(f(J))\geq T p(\pi v).
\]
从占据概率的几乎处处结论到每个支持中的极限图，正文先固定一个弱极限及微步长，再以非负连续误差的积分为零提升到测度支持；不是直接抹去例外集。

这两个不等式缺一不可。仅知导数几乎处处属于有限标签集不能保证仿射：实线上的 \(f(t)=|t|\) 就是反例。在 Sol 中它把 \([-1,1]\) 的 \(P=2\) 折为 \(P=1\)，违反第二个不等式。

具体排折叠机制如下。先由短段极限及严格凸的、有限等距群不变的 Euclidean 范数，得水平微分 \(B(z)\pi\)，\(B(z)\in\mathcal A_G\) 几乎处处。沿一般方向令 \(h(t)=f(z\exp_\infty(tv))\)，取实现 \(P(f(J))\) 的词基，以 \(m_i\geq1\) 表示其中各字母的出现次数，则
\[
 P(f(J))
 \leq\sum_i m_i\int_0^T(\alpha_i h'(t))_+\,dt
 \leq\int_0^T p(h'(t))\,dt=T p(\pi v).
\]
整段下界迫使每一步取等。每个必现字母的“最大值小于正变差”的亏损为零，所以沿线负导数不能先于正导数出现；各射线正号指标非增。标签置换有向权射线，使正号指标总数恒定，于是各指标都恒定。通过保 Haar 的流作局部依测度极限，把这个结论传到权超平面划分的锥之极端射线；所有相邻闭锥的交正是该射线，标签又保持同一 Euclidean 长度，故相应方向的导数沿线恒定。取张成第一层的这些方向 \(Y_j\)，便有分布意义的 \(Y_j^2f=0\)。第一层括号生成整个分次 Lie 代数，Hörmander 定理使 \(f\) 光滑，有限值连续微分标签在连通域只能常值。至此才有 \(f=A\pi+b\)。

多项式像引理在这里保住了**受限制参数集**的指数体积。它要求固定维数和次数，且一个满阶 Jacobian 子式的某个系数有非指数级下界；只说“每个尺度某处满秩”不够。固定深度的后向再现会有限次平方成功参数的质量，但 \(e^{-o(r)}\) 仍为 \(e^{-o(r)}\)。最后对这个可能相关、没有内点的可测参数集直接应用多项式像估计，不把可测选择误当独立采样。

**第三步：不同片的斜率和平移必须分别比较。** 邻片指右乘一个生成步 \(k=\exp(tX_i)\) 前后的两张图册。邻片若有不同斜率，令图册放大量趋零后，两仿射极限在一个支撑面上相同；相对线性映射便是该面的反射。向内小段 \(E\) 在两片上成为相反的目标段，合起来有 \(2P(E)\) 的指数，而源路径仍只需 \(P(E)\)。“开关”是在选定支持高度 \(d\) 处，连接 \(nd\) 与 \(n\exp(tX_i)d\) 的短路径；完整路径先沿 \(D\) 到该高度，切换后沿新片返回。正文交替使用固定有限组开关，先保留**端点元组的联合体积**，再用固定满秩的乘积映射把它变成目标终点体积；并非把几个终点数无根据地相乘。变提升多重性只吃掉 \(e^{o(r)}\)，故得到矛盾。

斜率相同仍不保证平移相同。`offsets.tex` 在权射线商及两权生成的尖锥商上比较 Haar 乘子。为说明计数，固定这样的源权锥 \(S\)，令 \(\mathfrak i_S\) 为含锥外字母的混合括号词张成的理想，\(I_S=\exp_N(\mathfrak i_S)\)，\(L_S=N/I_S\)。取
\[
 T_*=\{w:\|w\|\leq1,\ \beta(w)\leq0\ \forall\beta\in S\},
 \qquad T_j=\epsilon_jT_*,\quad
 0<\epsilon_2<\epsilon_1,\qquad P_j=P(T_j).
\]
这些模板取充分小，使平移后仍在图册域内；\(B^{I_S}_r(T_j)\) 是按混合词宽度缩放的理想盒，\(P_1,P_2\) 分别是大、小盒的体积指数。若两片的共同斜率为 \(A\)，目标权锥为 \(S'=(A^*)^{-1}S\)，其中 \(A^*\beta=\beta\circ A\)；\(\ell_{S'}\) 是商 Lie 代数 \(\mathfrak n/\mathfrak i_{S'}\) 各权按维数计重的和，所以 \(g\) 在商上的 Haar 乘子为 \(e^{\ell_{S'}(\pi g)}\)。

“探针”在基准高度归一化后，独立抽取大理想盒 \(B^{I_S}_r(T_1)\) 内的 Haar 随机点 \(i_1\)，以及商 Lie 代数内固定单位立方体中的 Lebesgue 随机点 \(s\)，再以固定线性截面 \(\sigma\) 组成 \(i_1\exp_N\sigma(s)\)；它们也独立于原图册中心 \(a\)。其条件抽样有两个要点：先固定误差容限，使起始好事件有正质量，再让无条件坏探针概率小于该质量的四分之一；Fubini 由此选择**同一个**中心保留至少一半探针体积，最后才缓慢缩小容限。探针在限制之前独立，不声称限制之后独立。

更重要的是，理想坐标的限制和商坐标的限制必须作用于**同一终点**。正文安排两锚点消去共同理想参数；第一条路径给该终点的商限制，同块内第二条路径加短桥给其理想限制。若平移差为 \(\Delta b=b_2-b_1\)，每块目标计数至多
\[
 e^{r(P_2-\ell_{S'}(\Delta b))+o(r)};
\]
块数为 \(e^{r(P_1-P_2)+o(r)}\)，源计数至少 \(e^{rP_1-o(r)}\)，于是 \(\ell_{S'}(\Delta b)\leq0\)。交换起始后缀与逆开关得反向不等式。先以射线迹形式杀掉该方向分量，再用两权锥的正迹组合杀掉其他独立分量，故 \(\Delta b=0\)。固定小放大量带来的桥误差是 \(O(\delta r)\)，不是 \(o(r)\)；原文用严格理想宽度间隙吸收它，没有偷换误差。

**第四步：把随机中心、尺度、基点都消掉。** 略大盒上的独立右后缀使 \(ak\) 的条件分布支配普通中心分布的一致正倍数，故两独立普通图册之差在概率中趋零，任意图册律极限是单点。允许 \(F,x\) 随 \(r\) 变化作紧性反证，才得到真正的全族统一误差。

固定紧单位邻域 \(Z\subset\mathcal U_\delta\)，则 \(\pi Z\) 含 \(W\) 中的零邻域。暂略 \(F,x\) 下标，把确定仿射近似写成 \(A_r\pi z+s_r/r\)，其中
\(s_r=r\,\mathbb E_a f_{r,x,a}(1)\) 是未除以尺度的平均平移。相邻尺度 \(r\leq r'\leq(1+\delta/2)r\) 的两个近似满足
\[
 \sup_{z\in Z}\|s_r-s_{r'}+
                     r(A_r-A_{r'})\pi z\|=o(r).
\]
先减去 \(z=1\) 消平移，再用有限标签在一组张成高度上的正分离，使标签在统一阈值以后精确稳定；几何级数望远镜求和给 \(s_r/r\to0\)。比较基点时，正文将新中心分布支配于较小盒中心加独立后缀的分布，再用严格放大间隙吸收共轭的指数小量及多项式损失。由此得到所有基点共用的单一 \(A_F\) 与模数 \(\varepsilon(R)\)，而不是从某个固定遍历测度的收敛率中冒出来。

### 6.4 从统一次线性误差到边界同胚

本节的输入是 `uniformity.tex` 的**所有基点都统一**的估计
\[
 \|\pi F(xg)-\pi F(x)-A_F\pi g\|\leq\varepsilon(R)R
 \quad(\|g\|_G\leq R),\qquad \varepsilon(R)\to0,
\]
以及 \(A_{\bar F}=A_F^{-1}\)。对固定基点才成立的次线性估计不足以直接给本节统一的影子常数。

给生成权射线 \(\alpha\)，把至少含一个射线外字母的词生成的理想记为 \(I_\alpha\)，设 \(L_\alpha=N/I_\alpha\)。`offsets.tex` 的锥商引理已证明该理想对 \(\mathfrak d\) 稳定并包含 \(N\cap D\)，所以 \(G\) 在商上的作用定义良好；其稳定子为 \(I_\alpha D\)。商中的全部权都是正倍数 \(c_j\alpha\)，故 Haar 乘子为
\[
 e^{\ell_\alpha(\pi g)},\qquad
 \ell_\alpha=c_\alpha\alpha,\quad c_\alpha>0.
\]

令目标射线为 \(\beta\)，源射线取 \(\alpha=\beta\circ A_F\)。选择 \(\alpha(\pi v)<0\) 的 \(v\in\mathfrak d\)。沿 \(x_t=x\exp(tv)\)，目标相对高度最终小于 \(-ct\)，其提升的 \(D\)-长度为 \(O(t)\)。于是目标商上每个单位时间增量至多
\[
 C(1+t)^M e^{-c't},
\]
可求和，得到极限 \(b(x)=\lim_{t\to\infty}p_\beta F(x_t)\)，并有统一紧影子
\(b(x)\in F(x)\cdot Q_\beta\)。指数收缩压过了 Jordan 幺幂部分的多项式增长。

真正费力的是极限只依赖 \(p_\alpha x\)，而非所选代表。右乘固定 \(d\in D\) 时，可在强负高度处用一条长度多项式的 \(D\)-路径连接两条射线。右乘 \(u\in I_\alpha\) 时则不能假定它被单条射线收缩：正文在半空间 \(\alpha<0\) 中选一个凸高度模板，让所有射线外字母的支持足够大，使全部混合词指数为正，再用支持点路径实现 \(u\)。整条路径仍有负线性 \(\alpha\)-高度，像的商位移趋零。两种不变性合起来才允许定义 \(f_\beta:L_\alpha\to L_\beta\)。

对粗逆重复构造。用影子性质把某个边界点提升到距 \(F(x_t)\) 一致有界的位置；粗逆后落在 \(x_t\cdot Q'\)，这组紧集收缩到 \(p_\alpha x\)，故两边界映射互逆。连续性也不是“有极限所以连续”：固定 \(t\) 时，\(x_t\) 的小邻域投影含一个源商邻域；其边界像落在 \(F(x_t)\cdot Q''\)，后者直径随 \(t\) 趋零。由此得到同胚。以上步骤正文均有论证，这里是解释而非标成“原文省略”。

### 6.5 像体积、不变平移与有界误差

先用正逆两个影子夹住像集：存在固定紧球 \(U\subset L_\alpha\) 以及固定目标紧集 \(V_-,V_+\)，其中 \(V_-\) 有正体积，使
\[
 F(x)\cdot V_-\subset f_\beta(x\cdot U)
          \subset F(x)\cdot V_+.
\]
因此
\[
 \operatorname{vol}_{L_\beta}f_\beta(x\cdot U)
            \asymp e^{\ell_\beta(\pi F(x))}.
\]
没有把任意同胚认成保持 Haar 测度的映射；这里只比较特定球及其作用像。

对字母 \(X_i\)，\(\exp(tX_i)\) 在除了自身射线外的每个源商上作用平凡。所以相应源集完全相同，像体积比较即控制所有其他目标射线的高度变化。利用各射线的严格正关系 \(\sum_\rho c_\rho\rho=0\)，再控制剩下一个射线；射线张成 \(W^*\) 后得到对任意 \(t\) 一致的字母位移界。正文的统一有限乘积生成引理把它扩展到
\[
 \|\pi F(xn)-\pi F(x)\|\leq B_N
                  \quad(x\in G,n\in N).
\]
这一步的乘积**因子数一致有界**很重要；若只能随 \(n\) 变化，就不能得到纤维上的统一界。

最后在源商上定义 Radon 测度
\(\rho(E)=\operatorname{vol}_{L_\beta}(f_\beta(E))\)，不假设绝对连续。令
\(U_d=d\cdot U\)、\(a_d=e^{\ell_\beta(\pi F(d))}\)；纤维界说明
\(\rho(zU_d)\asymp a_d\)，同时对所有 \(z,d\) 使用一个常数。

这里应把 `boundary.tex` 的平均引理读成一个独立的测度论事实。设一般紧集 \(E\subset B(R_E)\)，Tonelli 与幺模性给
\[
 \int_{B(T)}\rho(zE)\,d\mu(z)
 =\int \mu(B(T)\cap yE^{-1})\,d\rho(y),
\]
\[
 \mu(E)\rho(B(T-R_E))
 \leq\int_{B(T)}\rho(zE)\,d\mu(z)
 \leq\mu(E)\rho(B(T+R_E)).
\]
先对参考集 \(E_0\) 得到
\(\rho(B(T))\asymp [a_0/\mu(E_0)]\mu(B(T))\)，再对 \(E=U_d\) 应用同式。每次可令 \(T\) 大于该集合的直径；幂零球的倍增常数不依赖 \(d\)，所以最后常数也不依赖集合形状和直径。奇异 Radon 测度同样适用。

取对数后便有
\[
 \ell_\beta(\pi F(d)-\pi F(1))=\ell_\alpha(\pi d)+O(1).
\]
这里还不能直接把 \(\ell_\alpha\) 换成 \(\ell_\beta\circ A_F\)：两条射线对应的商维数、权重倍数可能不同。正文沿 \(d_t=\exp(tH)\) 再用次线性估计并除以 \(t\)，确立该**精确等式**；随后用目标迹形式张成 \(W^*\)，得到 \(D\) 上的有界高度。与 \(N\)-纤维界合并，才完成任意 \(g=nd\) 的结论。最后 Lipschitz 代表的有界扰动只增加一个统一常数。

### 6.6 有界高度怎样变成一个真正的群同态

把 \(H\) 左平移搬到 \(G\)，得到统一拟作用 \(F_h\)。定理 1.4 给唯一线性部件，比较 \(F_hF_k\) 与 \(F_{hk}\) 并令 \(\pi g\) 无界，强制 \(A_{hk}=A_hA_k\)。取其核 \(H_0\) 后，高度平移 \(s(h)=\pi f(h)\) 有统一有界缺陷。顺从群上的不变均值修正为真正同态
\[
 \tau(h)=m_x(s(hx)-s(x)),\qquad \|\tau(h)-s(h)\|\leq D.
\]
被平均的函数因有界缺陷而有界；把
\(s(hkx)-s(x)\) 拆成经由 \(kx\) 的两项，左不变性即给可加性。

核不必有限生成，像也不必在 \(W\) 中离散。对核的每个有限生成子群，生成元路径映到 \(G\) 后，全部中间点高度有界，端点的固定尺度装填数是多项式；下拟等距不等式再控制每个小球的原像数。这给子群**内在**字球的多项式增长，不要求子群在 \(H\) 中无畸变。Gromov 使每个这样的子群虚幂零，核作为它们的有向并为初等顺从；再扩张一个 Abel 群和有限群，才得整个 \(H\) 初等顺从。

### 6.7 识别末段：哪些有限性先得到

连续可解群顺从并不自动有度量 Følner 性，也不能据此略去幺模性。例如实仿射群本身顺从，却带有与双曲平面拟等距的左不变度量。正文从离散顺从群 \(P\) 的右 Følner 集出发，用拟等距像的固定半径厚化构造 \(G\) 的**度量** Følner 集。左不变度量中右乘 \(g\) 使每点移动固定距离，若模块函数非平凡，选择放大 Haar 体积的右平移便与度量 Følner 性矛盾。因此实际所用模型 \(G\) 确实幺模。对离散 \(H\)，相同构造直接给顺从性。

有界高度之后的逻辑顺序为
\[
 \begin{gathered}
 \text{局部虚幂零核}\ \Longrightarrow\
 H\text{ 初等顺从},\\
 \Gamma\text{ 有限分类空间}
 \ \xRightarrow[\text{拟等距}]{\text{Li 4.47}}\
 H\in\mathrm{FP}_\infty(\mathbb Z),\\
 \xRightarrow{\text{KMN 1.1、§2}}\
 H_1\leq_{\mathrm{f.i.}}H
 \text{ 可解且有有限分类空间},\\
 \operatorname{cd}_{\mathbb Z}H_1<\infty
 \ \xRightarrow[\Gamma\text{ 为对偶群}]{\text{Li 4.48}}\
 H_1\text{ 为整系数 Poincaré 对偶群}
 \ \xRightarrow{\text{Bieri 9.23}}\
 H_1\text{ 多循环}.
 \end{gathered}
\]
有限分类空间和可解性可先由两个不同有限指数子群得到，再取交；有限覆盖保留有限分类空间。有限整上同调维数还排除挠元。不能仅凭 \(\mathrm{FP}_\infty\) 就断言有限上同调维数，也不能先用 Li 的对偶转移来补它自己的假设。原文没有这样循环。

### 6.8 文献接口：实际读到的版本和用途

以下均已获取开放原文并读到所列位置；不是以 DOI、摘要或搜索结果代替定理。下载文件保存在 `guide/evidence/family-255/literature/`。扫描本的 OCR 仅辅助定位，关键陈述另对照页面图像。

| 文献与实际版本 | 精确位置 | 本文需要的结论及假设核对 |
|---|---|---|
| Dixmier，1957，法国数学会公报 85，113–121 | 定理 3，印刷页 120 | 单连通实可解群的指数映射成为解析微分同胚的根条件；本模型所有根为实，满足该条件。用于闭单连通子群、重叠及全局指数坐标。 |
| Dekimpe，2000，Compositio 121(2)，183–204，Cambridge 扫描全文 | 定理 4.1，印刷页 199，PDF 第 17 页 | 每个多循环按有限扩张群有有限指数正规子群，是某个连通单连通可解群的余紧格点。虚多循环与该输入等价，可先取多循环子群的正规核；不要求原群无挠。 |
| Cornulier–Tessera，2017，IHÉS 125，79–219，期刊全文 | 定义 1.1；引理 3.A.1，印刷页 108 | 任意连通 Lie 群与一个实三角化群拟等距，实际由余紧真同态链得到。定义中三角化群单连通；**不**附赠幺模性，后者由度量 Følner 论证补上。 |
| Cornulier–Tessera，2020，AIF 70(5)，1951–2003，期刊全文 | 定义 1.1，页 1954；推论 1.9，页 1957 | 实三角化群有 \(\mathcal{WAP}_{\mathrm t}\)；本处强连续酉表示为弱概周期表示，去掉不变向量后的约化一阶上同调消失。 |
| Greschonig–Schmidt，2000，开放作者稿（21 页） | 定理 5.2，PDF 第 19–20 页 | 局部紧第二可数群在标准 Borel 空间上的指定 Radon–Nikodym 余循环之遍历分解；取零余循环，并反演把右作用改为左作用。 |
| Hörmander，1967，Acta 119，147–171，期刊扫描本 | 定理 1.1，印刷页 149 | 光滑实向量场的平方和在括号生成条件下亚椭圆正则；此处无漂移和零阶项，右边为零，分次幂零群第一层括号生成，故分布解光滑。 |
| Gromov，1981，IHÉS 53，53–78，期刊全文 | 主定理，印刷页 54 | 每个有限生成多项式增长群有有限指数幂零子群。应用对象是离散核的每个有限生成子群，不是直接把可能无限生成的整个核送入该定理。 |
| Li，2018，AGT 18(6)，3477–3535，期刊全文 | 推论 4.47，印刷页 3530 | 可数离散粗等价群的 \(\mathrm{FP}_n(R)\) 等价，\(R\) 为有幺交换环。取 \(R=\mathbb Z\)，逐个 \(n\) 应用；有限生成群的拟等距给粗等价。 |
| Li，同上 | 推论 4.48，印刷页 3531 | 在**双方**整上同调维数有限时，整系数（Poincaré）对偶性粗不变。此处用其第一句，不需使用含 \(\mathbb Q\subset R\) 的第二句；允许非定向对偶群。 |
| Kropholler–Martínez-Pérez–Nucinkis，2009，Crelle 637，49–62，期刊全文 | 定理 1.1，印刷页 50–51，(viii)⇒(v)；§2 首段，页 52 | 输入是初等顺从且 \(\mathrm{FP}_\infty\)；输出有限指数 type \(F\)。§2 还明确给出幂零按 Abel 按有限的结构，足以取可解有限指数子群；没有把“一般顺从”误当“初等顺从”。 |
| Bieri，1981，第二版 *Homological Dimension of Discrete Groups*，204 页扫描本 | 定理 9.23 及证明，印刷页 176–177，PDF 第 182–183 页；对偶惯例见页 156 | 每个可解整系数 Poincaré 对偶群多循环；不要求预先定向，证明先取指数至多二的定向子群。与本文整系数、容许定向模的惯例一致。 |
| Farb–Weinberger，2008，Annals 168(3)，915–940 | 命题 3.4，印刷页 932 | 连通可解 Lie 群的格点多循环。格点推论的输入满足连通、可解；单连通反而更强。 |
| Geng，2015，NYJM 21，321–331 | 定理 2.9(i)，印刷页 325 | 连通可解 Lie 群的每个格点余紧。与上一项共同保证格点输入有限生成且适用 Milnor–Švarc；输出环境 Lie 群仍可改变。 |

识别末段依赖这些具体文献，是“条件于已核文献的手工推导”，不是本文另写出的自包含证明。多项式增长到虚幂零还使用 Gromov 1981 的主定理；幂零球增长次数的经典基准见后面的改进。

识别文献的下载来源与页码保存在 `guide/evidence/family-255/literature/sources.json`；三个分析接口的原 PDF、文本及摘要定位保存在 `guide/evidence/family-255/geometric-chain/sources.json`。

## 七、作者 Lean 与正文的关系

上游范围说明 `lean/docs/255.md` 对应的实际解答入口是
`OAI.GroupTheory.PolycyclicRecognition.Recognition`。比较配置指定三个最终定理：
`group_recognition`、`main_uniform_bounded_height`、`lattice_recognition`，
分别对应群识别、一致有界高度及格点推论。主要对象的对应如下。

| 正文对象 | 实际源码中的内容与构造 |
|---|---|
| 多循环、虚多循环 | `Algebra/Polycyclic.lean` 用从平凡子群到全群的有限 `CyclicSeries`；每步正规，商循环；虚多循环是有限指数的这种子群。 |
| 有限生成群的字度量与拟等距 | `Analysis/FiniteWordMetric.lean` 从有限生成元的最短词构造离散、真、左不变字度量及前缀链；`GroupCoarseEquivalence.metric` 将粗等价转成度量拟等价。 |
| 可解 Lie 模型及格点 | `SimplyConnectedSolvableLieModel` 带有限维实模型空间、实际 Mathlib Lie 群、单连通性和群可解性；`IsUniformLattice` 是离散子群加紧基本覆盖，有限余体积版本用商上的不变概率。 |
| 典范高度 | 由伴随表示的 `TriangularAdjoint.character` 定义公共核和商；高度同态通过群指数与该线性投影相容。 |

几何主定理的声明先选有限线性子群，再量化 \(K,C\)，然后给统一 \(B\)，最后量化拟等距 \(F\)。`ConditionalBoundedHeight.lean` 构造 Cartan 模型及支持数据，从模板多面体的对称得到有限群；`CartanNormalizedBoundedHeight.lean` 由正逆归一化恒等式推出逆斜率，再对有限标签纤维汇总误差。

识别入口使用字度量桥接和有界高度链装填。`Analysis/BoundedPathGrowth.lean` 的生成步长、字前缀及固定球原像数控制，与第 6.6 节的**内在子群增长**论证对应，不要求子群在环境群无畸变。最终源码通过 `RecognitionWithoutKMN.lean`、`CorrectedHeightRecognition.lean`，以有理上同调维数、有限子群阶界及对偶收尾；它与正文的 KMN type \(F\) 路线不同。

上游固定 Lean 4.34.1、Mathlib 提交 `d13f23b723b8a846827a245b89c10fc7d3f11612`，并对固定版本的外部 Gromov 包应用作者补丁。源码闭包、外部导入边界及补丁产物的校验记录均已保留。

**机器核验范围。** 本机为 Lean 4.31.0；原始最终入口因缺少已编译的 `OAI` 模块而退出，退出码为 2，故尚未完成三个主定理的全闭包编译及传递公理审计。局部兼容重放 `InterfaceReplay.lean` 则成功：保留作者的粗等价／自拟等距接口，以及循环列定义和基础构造，实例包括无限循环群 \(\mathrm{Multiplicative}\,\mathbb Z\) 的一步循环列、恒等粗等价与实线自拟等距的逆误差界。其 51 个定理／引理无 `sorry`，所测公理只有 `propext`、`Classical.choice`、`Quot.sound`。该结果仅覆盖这些局部声明，不覆盖完整字度量构造和三个主定理；原入口的导入错误也不构成定理失败。

精确抽取范围、固定源码清单及各项日志统一见
`guide/evidence/family-255/lean/statement_fidelity.md`。

## 八、核验结论

### 改进

**把未命名的多项式次数换成精确次数，并缩短识别中的增长证明。** 正文 `boxes.tex` 的“有界高度多项式装填”引理只给
\(\mathcal P_a(E_t)\leq C(1+t)^b\)。记
\[
 K=\ker\pi,\quad \mathfrak k^1=\mathfrak k,\quad
 \mathfrak k^{j+1}=[\mathfrak k,\mathfrak k^j],\qquad
 Q(K)=\sum_{j\geq1}j\dim(\mathfrak k^j/\mathfrak k^{j+1}).
\]
这里的 \(K\) 不是 \(N\)，也不是识别中可能不有限生成的离散核 \(\ker\tau\)。

设 \(G\) 连通、单连通、实三角化，固定左不变 Riemann 度量；这一局部结论甚至不要求幺模。给定 \(M\geq0,C_0>0,a>0\)，令 \(E_t(x;M,C_0)\) 是从 \(x\) 出发、长度至多 \(C_0t\)、**每一点**相对高度范数至多 \(M\) 的可求长路径端点集。以环境度量 \(d_G\) 定义最大 \(a\)-分离装填数 \(\mathcal P_a\)。则存在只依赖上述固定数据的 \(0<c\leq C<\infty\)，使
\[
 \boxed{\quad c\,t^{Q(K)}
 \leq\mathcal P_a(E_t(x;M,C_0))
 \leq C\,t^{Q(K)}
 \quad(x\in G,\ t\geq1).\quad}
\]
所以次数 \(Q(K)\) 对固定模型是尖锐的；\(Q=0\) 按常数阶解释。它处理**已知**高度有界的路径，不能替代本文困难的一致有界高度定理。

以下是独立重算的证明，也是相对于原引理的简化。

**核的结构与全局坐标。** 同一三角基下，每个 \(X\in\mathfrak k\) 的 \(\operatorname{ad}X\) 严格上三角，其在 \(\mathfrak k\) 上的限制全部幂零；Engel 定理给 \(\mathfrak k\) 幂零。反之，若 \(\mathfrak i\) 为幂零理想，对每个 \(X\in\mathfrak i\)，\(\operatorname{ad}X\) 先把 \(\mathfrak g\) 送入 \(\mathfrak i\)，随后在其中幂零，所以 \(\mathfrak i\subset\mathfrak k\)。因此 \(\mathfrak k\) 正是幂零根基。

取线性右逆 \(\lambda:W\to\mathfrak g\)，令 \(s(w)=\exp_G(\lambda w)\)。指数映射与同态的自然性已经给 \(\pi s(w)=w\)，无需先引用全局指数微分同胚。闭 Lie 子群 \(K=\pi^{-1}(0)\) 满足
\[
 \Phi:K\times W\longrightarrow G,\quad (k,w)\mapsto ks(w),
 \qquad
 \Phi^{-1}(g)=(g\,s(\pi g)^{-1},\,\pi g).
\]
这是全局微分同胚。由 \(G\) 连通、单连通及 \(W\) 可缩，\(K\) 连通、单连通；结合 Lie 代数幂零，得到可使用经典球增长的单连通幂零群。

**有界高度条带中的真实速度估计。** 左移令 \(x=1\)。写路径为 \(\gamma(u)=k(u)s(w(u))\)，记其左对数速度为 \(v\)，并令
\(A(w)\xi=s(w)^{-1}ds_w(\xi)\)。逐项求导得
\[
 w'=\pi_*v,\qquad
 k^{-1}k'=\operatorname{Ad}_{s(w)}
                  \bigl(v-A(w)\pi_*v\bigr).
\]
括号内确在 \(\mathfrak k\) 中，因为 \(\pi_*A(w)=\mathrm{id}\)。当 \(\|w\|\leq M\) 时，右边算子范数一致有界，故
\(\operatorname{len}_K(k)\leq C_M\operatorname{len}_G(\gamma)\)；
弧长参数化使同式适用于一般可求长路径。于是端点坐标落在
\(B_K(C_MC_0t)\times B_W(M)\)。这里控制的是**留在条带中的路径长度**，不是声称该投影对不受限的环境距离全局 Lipschitz。

**上界。** \(\Phi\) 的左平移微分为
\(\operatorname{Ad}_{s(w)^{-1}}u+A(w)\xi\)，在有界 \(w\) 上一致有界，与 \(k\) 无关。先沿 \(K\) 中的测地线、再沿凸的 \(W\)-球中的线段，故环境分离的端点给积空间中固定尺度分离的坐标。围绕这些坐标放互不相交的小球，全部落在
\[
 B_K(C_MC_0t+O(1))\times B_W(M+O(1)).
\]
经典幂零球体积 \(\operatorname{vol}_K B_K(R)\asymp R^{Q(K)}\) 给所需上界。无须分解 \(G\) 的 Haar 测度，也不要求 \(s\) 为同态。

**下界。** 可达集包含 \(K\) 的内在球 \(B_K(C_0t)\)，因为这些路径高度恒零。该球的最大环境 \(a\)-分离子集以环境半径 \(a\) 球覆盖它，每片的 \(K\)-Haar 体积至多
\(\operatorname{vol}_K(K\cap B_G(1,a))<\infty\)。这是 \(K\) 闭、环境度量真以及左平移保 Haar 的结果，不要求 \(K\) 无畸变。对覆盖求和，经典球体积即给匹配下界。

因此 `recognition.tex` 的增长引理可明确为：任意有限生成 \(J\leq\ker\tau\)，任意有限对称生成集 \(T\)，都有
\[
 |B_T(t)|\leq C_T(1+t)^{Q(K)}.
\]
次数只依赖 Lie 模型，常数仍可依赖 \(T\)。更短的证明是将正文拼接的路径投影进 \(K\)；其长度 \(O_T(t)\)，而 \(f(j)\) 与其 \(K\)-坐标距离一致有界。用 \(K\) 内单位球覆盖，再由下拟等距不等式控制每球原像个数，即得到同式。它不推出整个离散核有限生成，也不改动后续 Gromov、有限性和对偶步骤。

**与已发表数字比较。** Guivarc'h 1973 的定理 II.1（页 342–344）与 II.4（页 345）已给相应幂零增长次数；Breuillard 2014，GGD 8，669–732，定理 2.7、推论 2.9 和公式 (17)（页 687–688）明确写为上述加权下中心列维数。正文自身的幂零坐标引理也证明了所需球体积。这里是经典次数在原文未优化装填界中的**尖锐显式化与证明简化**，不声称新的幂零增长理论或文献首创。

| 模型 | \(K\) 的下中心分层维数 | 齐次次数与装填阶 |
|---|---|---|
| Sol | \(2\) | \(Q=2\)，\(t^2\) |
| 上述 Heisenberg 按实线扩张模型 | \(2,1\) | \(Q=2+2=4\)，\(t^4\)，不是拓扑维数 \(3\) |

Heisenberg 中 \([\exp(uX),\exp(vY)]=\exp(uvZ)\)，在 \(X,Y\) 长为一的左不变度量下，长度 \(4\sqrt{|c|}\) 的交换子可达 \(\exp(cZ)\)，这直接解释中心坐标可达 \(t^2\) 宽、总体积为 \(t^4\)。两个有限模型的 Jacobi、共同三角化、幺模性、典范核、下中心列、Cartan 及非平凡交叠已用有理数精确重算；运行
`python3 guide/evidence/family-255/packing/check_models.py --self-test`。
六个真正送入同一检查函数的错误输入均被拒绝：错误次数、误把高度方向放入核、破坏 Jacobi、漏掉括号方向、漏掉 Cartan 零权方向、误设交叠为空。这个脚本只认证有限 Lie 代数数据，一般几何结论的依据是上面的手工推导。

假设边界也可手算：在 Sol 中
\[
 \exp(HT)\exp(uX)\exp(-HT)=\exp(e^H uX),\qquad0\leq u\leq1,
\]
路径长至多 \(2H+1\)，终点高度全为零，却产生至少 \(c_a e^H\) 个固定尺度分离端点。因此不能把“全程高度有界”弱化为“只有终点高度有界”。这反驳的是该额外弱化，不是论文的陈述。

### 错误与不足

未发现正文的数学错误或尚未补上的承重证明缺口。实际重点查过：非平凡 \(N\cap D\)、零权括号、非半单伴随作用、参数筛选后的体积、同一逆斜率、排折叠与邻片平移、Radon 测度平均，以及识别末段的有限上同调维数假设。

形式化的现场核验范围见第七节。

### 已核验

已手工核对主定理及两个几何结论的量词，并沿正文完整依赖链检查模型、装填、多项式像、平稳斜率、图册仿射、邻片标签和平移、全族次线性、边界有界提升及群论识别。六个中间几何模块另经分项独立复核。指定识别引用均已读到原文的准确编号和应用条件。

独立终审重新执行了模型及六项负控、25 行 claims 检查和局部 Lean 重放，并逐一核对固定源码及修复后的补丁产物散列。输出保存在 `guide/evidence/family-255/independent-final-check.log`、`guide/evidence/family-255/lean/verify-interface-independent.log` 和 `guide/evidence/family-255/independent-integrity-check.log`。

| 主张 | 来源 | 依据 | 证据 |
|---|---|---|---|
| 定理 1.1 不预设比较群可解；格点推论允许环境群改变；定理 1.4 的 \(B\) 对固定 \(K,C\) 的所有 \(F\) 一致 | 论文，引言三个主陈述 | 手算核验（陈述及量词） | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/introduction.tex` |
| 本地 15 个正文、图形与书目文件属于指定上游提交 | 论文，固定版本 | 计算核验（Git blob 逐一匹配） | `guide/evidence/family-255/paper-directory.json` |
| Cartan 乘法有可能非平凡的核；典范高度及幺幂多项式界不要求半单性 | 论文，模型部分 | 手算核验 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/models.tex`；本导读第 6.1 节 |
| 全括号最大基给一致盒运算，\(P\) 的全部模板对称形成有限群并置换有向生成权射线 | 论文，盒运算与支持对称引理 | 手算核验 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/boxes.tex`；本导读第 6.2 节 |
| 受限路径的指数计数及变提升多重性保留 \(N\cap D\) | 论文，路径与多重性引理 | 手算核验 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/boxes.tex`；本导读第 6.2 节 |
| 固定次数多项式像与固定深度再现保留受筛选参数的 \(e^{-o(r)}\) 质量 | 论文，多项式部分 | 手算核验 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/polynomial.tex`；本导读第 6.3 节 |
| 平稳斜率与粗逆属于同一对 \(A,A^{-1}\)，而非分别选取不相关斜率 | 论文，平稳部分 | 条件于 Cornulier–Tessera 2020 推论 1.9 与 Greschonig–Schmidt 定理 5.2，接口手工核对 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/stationary.tex`；`guide/evidence/family-255/geometric-chain/sources.json` |
| 整段体积下界排折叠，经射线符号、极端方向及正则性得支持图仿射 | 论文，图形极限部分 | 条件于 Hörmander 1967 定理 1.1，几何推导手工核对 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/profiles.tex`；`guide/evidence/family-255/geometric-chain/Hormander1967.pdf`；本导读第 6.3 节 |
| 邻片不同标签将使目标端点指数翻倍，与源装填矛盾 | 论文，标签部分 | 手算核验 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/labels.tex`；本导读第 6.3 节 |
| 独立探针、同一终点双坐标约束与商 Haar 乘子迫使邻片平移相同 | 论文，平移部分 | 手算核验 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/offsets.tex`；本导读第 6.3 节 |
| 跨后缀、尺度及基点给全族共用的次线性模数，不需要遍历概率的统一收敛速率 | 论文，一致性部分 | 手算核验 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/uniformity.tex`；本导读第 6.3 节 |
| 统一次线性高度给具有统一紧影子的正逆边界同胚 | 论文，边界同胚引理 | 手算核验 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/boundary.tex`；本导读第 6.4 节 |
| 像体积先给 \(N\)-纤维有界误差；任意 Radon 测度的平移平均再给 \(D\) 上有界误差 | 论文，边界体积与平均引理 | 手算核验 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/boundary.tex`；本导读第 6.5 节 |
| 度量 Følner 性给模型幺模性；均值修正与有界高度导出局部虚幂零核及初等顺从性 | 论文，模型归约与识别命题 | 条件于 Gromov 1981 主定理，其余推导手工核对 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/recognition.tex`；`guide/evidence/family-255/literature/gromov-1981.pdf` |
| \(\mathrm{FP}_\infty\) 先给有限指数 type \(F\)，再取得有限整上同调维数、对偶及多循环性 | 论文，识别末段 | 条件于 Li 2018 推论 4.47/4.48、KMN 2009 定理 1.1 与 §2、Bieri 1981 定理 9.23，均已核原文与假设 | `guide/evidence/family-255/literature/li-2018.pdf`；`guide/evidence/family-255/literature/kmn-2009.pdf`；`guide/evidence/family-255/literature/bieri-1981.pdf`；本导读第 6.7–6.8 节 |
| 有限指数格点模型及格点推论满足正确的环境群量词 | 论文，模型归约与格点推论 | 条件于 Dekimpe 2000 定理 4.1、Cornulier–Tessera 2017 引理 3.A.1、Farb–Weinberger 命题 3.4、Geng 定理 2.9(i) | `guide/evidence/family-255/literature/sources.json` |
| 有界扰动可统一替换为 Lipschitz 拟等距对，保留粗逆误差 | 论文，附录 | 手算核验 | `paper/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026/build/lipschitz-appendix.tex` |
| 作者实际解答采用循环列、字度量与 Lie 模型，包含对应三个主结论的最终定理 | 论文，实际形式化与相邻比较配置 | 手算核验（源码层面） | `guide/evidence/family-255/lean/upstream/lean/ComparatorChallenges/PolycyclicRecognition.json`；`guide/evidence/family-255/lean/upstream/lean/OAI/GroupTheory/PolycyclicRecognition/Recognition.lean`；本导读第七节 |
| 固定的自有源码闭包及三个 Gromov 补丁边界产物与所录 Git blob 对应 | 论文源码及本文的证据重建 | 计算核验（不含全闭包编译） | `guide/evidence/family-255/lean/closure.json`；`guide/evidence/family-255/lean/gromov/patch-check.log` |
| 循环列、粗等价与自拟等距接口的有限范围兼容重放及无限循环群／实线实例 | 本文，对作者接口的兼容重放，非新证明 | Lean 已证明（仅本行局部声明） | `guide/evidence/family-255/lean/InterfaceReplay.lean`；`guide/evidence/family-255/lean/statement_fidelity.md`；`guide/evidence/family-255/lean/verify-interface-integrated.log`；`guide/evidence/family-255/lean/interface-axioms.log` |
| 作者三个最终主定理的完整固定闭包在本机通过编译，且其传递公理集仅含标准三项 | 论文最终定理的现场机器验证目标 | 未定（原入口退出码 2，未完成该核验） | `guide/evidence/family-255/lean/verify-original.log` |
| Sol 的高度区间体积指数为长度，Heisenberg 扩张例为其两倍 | 论文例子与本文第四、6.1 节展开 | 手算核验 | `guide/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026.md` |
| 有界高度端点装填为 \(\Theta(t^{Q(K)})\)，识别中各有限生成子群的增长上界可统一取次数 \(Q(K)\) | 本文，对原装填引理的尖锐显式化 | 手算核验；幂零球增长采用经典齐次次数 | `guide/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026.md`，第八节；`guide/evidence/family-255/literature/guivarch-1973.pdf`；`guide/evidence/family-255/literature/breuillard-2014.pdf` |
| 两个有限 Lie 代数模型的核次数为 2 和 4，且后一模型确有非平凡 Cartan 重叠 | 本文，有限模型复算 | 计算核验（精确有理数；六个负控均被同一检查器拒绝） | `guide/evidence/family-255/packing/check_models.py`；`guide/evidence/family-255/packing/models.json` |
| 把全程有界高度弱化为仅终点高度有界，仍有多项式装填 | 本文检验的额外弱化，并非论文主张 | 反驳（Sol 的指数长水平区间） | `guide/quasi-isometric-recognition-of-virtually-polycyclic-groups-September-24-2026.md`，第八节末 |
