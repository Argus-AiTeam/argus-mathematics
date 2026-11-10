本次手工核验支持本文关于任意 Coxeter 系统的等参数组合不变性：组合—比较主链及关键外部接口未发现错误；公开 Lean 的完整声明与固定源码闭包已核对，但本机未能编译，另得到真实层的非自由部分核，说明“终段”条件不能任意删除。

# 《Combinatorial invariance of Kazhdan–Lusztig polynomials》中文导读与核验

## 1. 精确命题、版本与约定

**原文 Theorem 1.1。** 对任意两个 Coxeter 系统 \((W,S),(W',S')\)，任意 \(u\le b\)、\(u'\le b'\)，以及任意抽象偏序同构
\[
\iota:[u,b]\overset{\sim}{\longrightarrow}[u',b'],
\]
都有等参数 Kazhdan–Lusztig 多项式恒等式
\[
P^W_{u,b}(q)=P^{W'}_{u',b'}(q).
\]
两群可以不同，可以无限，可以非晶体；底点不必是单位元。同构不附带简单生成元、反射或根标号。原文还对每个子区间得到相应 \(P\)、\(R\) 的相等。**不涉及不等参数或模特征的 \(p\)-KL 多项式。**

取 \(d(x,y)=\ell(y)-\ell(x)\)，\(P_{x,x}=R_{x,x}=1\)，不可比时两者为零；\(x<y\) 时 \(\deg P_{x,y}<d(x,y)/2\)。确定符号的互反式为
\[
q^{d(x,y)}P_{x,y}(q^{-1})
=\sum_{x\le z\le y}R_{x,z}(q)P_{z,y}(q).
\]
所有图边均为**左反射边** \(x\to tx>x\)，不只是覆盖边。系数环 \(A=\operatorname{Sym}_{\mathbb R}(V)\) 中根标号的次数为一；基向量次数 \(j\) 对分次秩贡献 \(q^j\)，不是 \(q^{-j}\)。

核验对象固定为 OpenAI 2026-09-24 稿，仓库提交 `4eaee87548250b2682affda7d05d947c05554bae`。原文在 `paper/Combinatorial-Invariance-of-Kazhdan-Lusztig-Polynomials-September-24-2026/build/`。七个顶层 TeX 文件均与该提交 GitHub 目录元数据的 Git blob 一致，证据为 `evidence/168/combinatorics/paper-directory.json` 与 `evidence/168/combinatorics/check_main_chain.log`。下文按原稿实际编号引用；`05-comparison.tex` 同时包含第 5、6 节。

## 2. 问题为什么难，本文改变了什么

KL 多项式原本借助 Hecke 代数的简单生成元定义；在 Weyl 群中，它还记录 Schubert 奇点的局部交叉上同调。抽象区间偏序却丢掉了生成元与根标号。问题是：这些看似不可缺少的数据，究竟是否只是在计算同一个偏序不变量时使用的坐标？

本文不试图恢复根标号，也不构造两个标号图之间的层同构。它在两个不同多项式环中分别保留原来的层，只从第二个区间借来一份“处理边的先后次序”。局部计算给出单向不等式；互反式和反向比较再迫使它处处取等。**比较的是 Hilbert 级数，不是两个根空间。**

与可核对的已有数值范围比较：

| 已有结果 | 精确范围 | 本次读到的版本 |
|---|---|---|
| Barkley–Gaetz–Lam | 任意 Coxeter 系统的 \(q\) 系数不变；区间长度至多 6 时整个 \(P,R,\widetilde R\) 不变 | arXiv:2601.07793v2，Corollaries 1.3–1.4，正文第 2 页 |
| Esposito–Marietti–Stella | 有限 Weyl 群长度至多 10；有限 A 型长度至多 12 | arXiv:2509.16433v2，Corollary 1.3(ii)，正文第 3 页 |
| 本文的主张 | 无长度上界、任意两个 Coxeter 系统、任意底点 | Theorem 1.1 |

前两项保存于 `evidence/168/history/`，这里核对的是结论及适用范围，不声称重做其全部计算。我们的 \(S_4\) 小例不超出这些已有范围；作用是抓方向、次数和实现错误，而不是以枚举证明一般不变性。

## 3. 路线图与符号

第 2 节准备反射忠实实表示、Braden–MacPherson（BMP）层及两端分次秩；第 3 节由偏序恢复完整 Bruhat 图，再运输二面体相对区间并计算晚边数；第 4 节在根平面素理想处把层拆成二面体结构层；第 5 节得到边像包含；第 6 节用非负矩阵、互反性和同时归纳把包含逼成相等，最后补上自由性。初读可先读第 6 节与下面的 \(S_3\) 例子，再回看第 3、4 节为何足够。

| 记号 | 含义与易混处 |
|---|---|
| \(D_\Pi\) | 根平面 \(\Pi\) 中全部反射生成的最大二面体子群 |
| \(\ell_D,\le_D\) | 陪集上的相对长度和相对 Bruhat 序；不是直接限制环境长度和所有环境可比关系 |
| \(B=B(b)\) | 顶点为 \(b\)、顶端归一化 \(B^b=A\) 的 BMP 层 |
| \(B^x,B^e\) | 顶点模、边模；\(e:x\to y\) 时 \(B^e=B^y/\alpha_eB^y\) |
| \(U_x\) | 图中从 \(x\) 向上的全部边，含非覆盖边 |
| \(L_x(F)\) | \(B^x\) 中在边集 \(F\subseteq U_x\) 上限制为零的核 |
| transported schedule | 按像边在第二个系统中的真实几何反射序排序；不必是第一个系统的反射序 |
| terminal portion | 某顶点的边序中的终段，包括空集和全集；不是任意边子集 |
| \(k_\Pi(e)\) | \((\ell_{D_\Pi}(y)-\ell_{D_\Pi}(x)-1)/2\)，非负整数 |
| \(I_e,J_e\) | 两端“严格晚于 \(e\)”的核在同一个 \(B^e\) 中的像 |
| \(p_x(q)\) | \(q^{-d(x,b)/2}P_{x,b}(q)\) |
| \(T\) | 对 \(0<q<1\)，\(q^{-1/2}-q^{1/2}>0\) |

同标号边两两不相交，因为同一反射只能把 \(w\) 与 \(tw\) 配对。因此全局相同标号可任意打破平局，不影响某顶点的终段，也不影响矩阵乘积。

## 4. 一个可手算的核心例子

在 \(S_3=I_2(3)\) 中取简单反射 \(s,t\) 与 \(w_0=sts\)。区间 \([1,w_0]\) 的四层是
\[
\{1\}\mid\{s,t\}\mid\{st,ts\}\mid\{w_0\}.
\]
层间的八条边都是覆盖边，此外还有长边 \(1\to w_0\)。这就是六点八边闭包规则的最小例子：偏序看得见八条短边，规则补出长边，但并不补出它的根标号。

取反射序 \(s\prec sts\prec t\)，考察 \(e:1\to w_0\)。它的环境长度差为 3，相对长度差也为 3，所以 \(k_\Pi(e)=1\)。在底点比 \(e\) 晚的边只有 \(1\to t\)，在顶点没有，差恰为 1。

这个区间的结构层在每个顶点为 \(A\)。写 \(\alpha_e=\alpha_s+\alpha_t\)、\(C=A/(\alpha_e)\)，则
\[
L_1(\{1\to t\})=\alpha_tA,\quad
I_e=\overline{\alpha_t}C,\quad J_e=C.
\]
故实际边像相等为 \(I_e=f_eJ_e\)，其中 \(f_e=\overline{\alpha_t}\) 次数为一。这个因子补偿的正是长边的 \((3-1)/2\)，不能遗漏。

路径公式在这里给
\[
\widetilde R_{1,w_0}(T)=T^3+T,\qquad
R_{1,w_0}(q)=(q-1)^3+q(q-1).
\]
一个递减三边路径和那条单独长边分别贡献 \(T^3,T\)。若只处理 Hasse 图，便漏掉 \(T\)。另一方面，在 \(S_4\) 的第一个奇异例 \(b=3412\) 中，递推得到
\[
P_{1,b}=1+q,\quad
\operatorname{grk}B^1=1+q,\quad
\operatorname{grk}L_1(U_1)=q^4+q^3.
\]
这说明两端秩不是彼此相同，而是以长度差为中心反转次数。后者由一般特征公式给出，并非只由这个例子推定。

## 5. 承重证明链：逐步解释与核验

### 5.1 从偏序重构全图：Theorem 3.4

从所有覆盖边出发，只要六个不同顶点排列为 \(1,2,2,1\) 四层，且相邻层的八条有向边已存在，就添首尾边。

**为何不会添错？** 两条同端点二边路径的标号根必在同一个平面：若 \(\alpha,\beta\) 独立，环境双线性型非退化时
\[
\operatorname{im}(r_\alpha r_\beta-1)=\operatorname{span}(\alpha,\beta).
\]
因此这八条边逐层被同一平面锁住。三个相对边差都是正奇数，总和仍是奇数；二面体群中正奇数相对差恰好对应反射边。

**为何不会漏边？** 对非覆盖反射边 \(a\to c=ta\)，用 \(c\) 的简单左下降 \(v\) 细化为同平面的三边路径。若 \(va>a\)，直接取
\[
a\to va\to vc\to c;
\]
中边环境差为 \(d(a,c)-2\ge1\)。若 \(va<a\)，先对 \(va\to vc\) 在更短的顶点长度上归纳，再左乘 \(v\)。唯一可能反向的是标号本身为 \(v\) 的边；原文分别绕过路径第一或第二条这样的边，末边不可能为 \(v\)。得到三边后，在两个内部相对秩各取两个顶点，八条新边的环境差都严格小于 \(d(a,c)\)，再对这个差归纳。

这里有两个不同的归纳参数：**细化用上端环境长度；闭包完备性用首尾环境差。** 中间下降计算可以离开 \([a,c]\)，但最终三边有向路径一定留在其中，故任意子区间都能应用。

### 5.2 运输的不是环境诱导序：Proposition 3.5

最大根平面陪集有最短代表 \(a_0\)，\(w\mapsto wa_0\) 保留相对反射边的方向和标号。只需要 \(x\le_Dy\Rightarrow x\le y\)，不要求逆命题。

相对区间 \([x,c]_D\) 内部每秩有两个顶点。图同构把它们送入目标中的一个根平面陪集，但最初还不能断言相对秩不变。关键是：原相对差为 2 的端点恰有**两条环境二边路径**。任意另一条环境二边路径也由乘积像空间被迫回到同一平面。目标中若相对差为正偶数 \(r\)，二面体形状给出恰好 \(r\) 条二边路径；所以 \(r=2\)。逐段应用，所有相对覆盖都被保留，像才是整个目标相对区间，而不是其中的稀疏子图。

这解释了为何不能仅凭“图中有一个二面体形状”就运输长度：**二路径的精确条数排除了拉长。** 一个可检验的非保标号运输是 \(\iota(w)=w^{-1}\)：原边 \(x\to tx\) 的像标号变成 \(x^{-1}tx\)，随 \(x\) 变化。本次对 \(S_4\) 中 98 个相对秩至少为二的二面体相对区间核对了此运输的满像与相对秩，并在这些实际运输 schedule 中核对了 212 次晚边差。

### 5.3 晚边差与平面贡献：Lemmas 3.7–3.8

二面体整数模型把单位元记为 0，两支交替词记为 \(\pm r\)，长度为绝对值；有限 \(I_2(m)\) 中用 \(-m<i\le m\)，避免把最长元算两次。左反射形如 \(i\mapsto a-i\)，所以边 \(i\to j\) 的反射参数是 \(i+j\)。

真实反射序是奇数参数的两种角序之一。有限型为 \(1,3,\ldots,2m-1\)；无限型为
\[
1,3,5,\ldots,\ \ldots,-5,-3,-1,
\]
或其逆序。无限型正负两支之间不需要存在一个根。该次序由根递推
\[
p_0=0,\quad p_1=1,\quad p_{n+1}=2\kappa p_n-p_{n-1},\quad
p_{n+1}^2-p_np_{n+2}=1
\]
控制，有限型 \(\kappa=\cos(\pi/m)\)，无限型 \(\kappa\ge1\)。后一范围包含诱导的非标准无限二面体表示。

运输完相对区间后，设 \(\ell_D(x)=L,\ell_D(y)=M,\ell_D(c)=C\)，\(M-L=2k+1\)。原文的中点比较表给出：

* 若 \(y\) 在负支，只有底点到负支的 \(L+1,L+3,\ldots,M-2\) 共 \(k\) 条边较晚，上端没有晚边。
* 若 \(y\) 在正支，这 \(k\) 条仍在；当 \(C>M\) 时还有到 \(-y\) 的一条，但更高内部秩交替贡献 \(-2,+2,\ldots\)，单重顶点贡献 \((-1)^{C-M}\)。总补偿为
\[
1+2\sum_{t=1}^{C-M-1}(-1)^t+(-1)^{C-M}=0.
\]

逆角序也成立：两端总出边数之差是 \(M-L=2k+1\)；扣去边 \(e\) 自身的 1 及已算出的晚边差 \(k\)，早边差仍为 \(k\)。因此任意受支持顶点 \(c\) 都有
\[
h_x-h_y=k_\Pi(e).
\]

再令 \(\alpha\) 为 \(e\) 的正根，比较两个有限逆序集的指示函数差 \(\varepsilon(\gamma)\)。总和为 \(d(x,y)\)，\(\varepsilon(\alpha)=1\)。把其余正根按 \(\operatorname{span}(\alpha,\gamma)\) 分组，每组贡献
\[
\bigl(\ell_{D_\Pi}(y)-\ell_{D_\Pi}(x)\bigr)-1=2k_\Pi(e).
\]
所以
\[
\sum_\Pi k_\Pi(e)=\frac{d(x,y)-1}{2}.
\]
不是把无限多个平面各自的“1”相加：共同根 \(\alpha\) 先剔除，各组才不相交。有限支撑保证只有有限多个非零项。

### 5.4 局部层怎样变成边像估计：Proposition 5.2

令 \(F,G\) 为两端严格晚于 \(e:x\to y\) 的出边，\(C=A/(\alpha_e)\)，并设上端 \(L=L_y(G)\) 已自由。不同出边标号不成比例，故 \(\alpha_e\) 在各 \(B^g\) 上为非零因子，给出
\[
L\cap\alpha_e B^y=\alpha_e L,\qquad J_e\simeq L/\alpha_e L.
\]
于是 \(J_e\) 是自由 \(C\)-模。又有
\[
\overline{\prod_{g\in G}\alpha_g}\,B^e\subseteq J_e\subseteq B^e,
\]
左边乘子非零，所以 \(J_e\) 有满分式域秩。

每个含 \(\alpha_e\) 的平面选一个独立根 \(\beta_\Pi\)，令
\[
f_e=\prod_{k_\Pi(e)>0}\overline{\beta_\Pi}^{\,k_\Pi(e)}.
\]
上一小节保证其次数是 \((d(x,y)-1)/2\)。不同平面的约化线性式不成比例。

只需在 \(C\) 的高度一素理想检查 \(I_e\subseteq f_eJ_e\)。没有根标号的素理想处各乘子皆为单位；其余素理想为 \((\bar\beta)\)，在 \(A\) 中的逆像为 \((\alpha_e,\beta)\)。第 4 节将局部层按**实际全部限制映射**拆成结构层；同一个边分量的线性同构同时运输 \(I_e,J_e\)。在每份结构层中，部分核是受支持晚边标号的乘积，其模 \(\alpha_e\) 的离散赋值分别为 \(h_x,h_y\)。差为 \(k_\Pi(e)\)，故这里甚至有局部相等 \(I_{e,\mathfrak q}=f_eJ_{e,\mathfrak q}\)。

全局结论此时只有包含，理由不是 \(I_e\) 自反，而是**目标 \(f_eJ_e\) 已自由**。取它的一组基，向量的坐标若属于所有高度一局部环，则属于 \(C\)：既约分母的任何非常数不可约因子都会在相应高度一素理想暴露。因此
\[
I_e\subseteq f_eJ_e.
\]
例如 \((X,Y)\subsetneq\mathbb R[X,Y]\) 在每个高度一局部化后相等，商却是非零有限长模。

### 5.5 为什么矩阵是非负的，为什么路径递减：第 6.1 小节

固定 \(0<q<1\)，按 schedule 从早到晚删去出边条件，令当前剩余条件为 \(H_x\)，保持状态
\[
D_x=q^{-d(x,b)/2}(1-q)^N\operatorname{Hilb}(L_x(H_x);q).
\]
不预设这些核自由；有限生成、次数有下界已足以使 Hilbert 级数在这个 \(q\) 收敛。第 2 节给端点
\[
D_{\rm initial}=p(q^{-1}),\qquad D_{\rm final}=p(q).
\]
删去 \(e\) 时增量是 \(I_e\) 的 Hilbert 级数；边像包含给
\[
\begin{aligned}
\Delta D_x
&\le q^{-d(x,b)/2}(1-q)^{N+1}
q^{(d(x,y)-1)/2}\operatorname{Hilb}(L_y(G);q)\\
&=(q^{-1/2}-q^{1/2})D_y=TD_y.
\end{aligned}
\]
指数抵消用的是 \(d(x,b)=d(x,y)+d(y,b)\)。若少了长边因子 \(f_e\)，就不会得到与边长无关的同一个 \(T\)。

记 \(M_e=I+TE_{xy}\)，总乘积为 \(M_r\cdots M_1\)。一个两边路径 \(x\to y\to z\) 对应
\[
E_{xy}E_{yz}=E_{xz};
\]
故必须先处理上边 \(y\to z\)，再处理下边 \(x\to y\)。沿着图向上走，标号遂是**递减**，并非按处理时间递增。Dyer 路径公式及逆反射序给
\[
p(q)\le\widetilde R'(T)p(q^{-1}).
\]

注意路径公式在通常变量 \(q\) 下使用 \(q^{1/2}-q^{-1/2}=-T\)。这里的正号来自**把第二系统的互反式在 \(q^{-1}\) 处代入**：
\[
p'(q)=\widetilde R'(T)p'(q^{-1}).
\]
直接在 \(q\) 处套用而不倒数会破坏非负比较。

### 5.6 同时归纳无循环：第 6.2–6.4 小节

归纳命题同时量化任意两系统、任意区间同构、任意运输 schedule，证明多项式相等及底点每个终段核自由。阶为 \(d(u,b)\)。在同一比较中始终使用同一个 \(B(b)\)；到 \([y,b]\) 只更换底点，不更换层。

**先得多项式相等。** 对 \(y>u\)，两个结论均由较短上区间给出，尤其第 5 节只需的上端自由性已可用。不假设底点部分核自由。减去精确互反式后，行 \(u\) 只剩
\[
\Delta(q)\le\Delta(q^{-1}),\qquad \Delta=p_u-p'_u.
\]
交换两系统，另选第一系统的真实几何反射序，得到反向不等式。这不要求原运输 schedule 的逆运输仍为几何反射序，因为归纳已对所有 schedule 量化。故 \(\Delta(q)=\Delta(q^{-1})\)。严格次数界使 \(\Delta\) 仅含严格负的半整数幂，倒数只含严格正幂；在 \((0,1)\) 上相等只能两边为零。

**再得所有边像相等。** 现在各端点分量都已相等。令实际第 \(k\) 步的非负亏损为 \(\delta_k=M_kD_{k-1}-D_k\)。精确望远镜式为
\[
0=M_r\cdots M_1D_0-D_r
=\sum_k M_r\cdots M_{k+1}\delta_k.
\]
所有矩阵非负，且保留每个坐标的系数至少为一，不能把一个正亏损抵消掉。于是每个亏损均为零。相应坐标是商 \((f_eJ_e)/I_e\) 的 Hilbert 级数乘正数；任何非零分次有限生成模在 \(0<q<1\) 的 Hilbert 级数都严格正，即使它只支撑在高余维或只有有限长。故真正得到全局
\[
I_e=f_eJ_e.
\]

**最后恢复自由性。** 从空终段 \(L_u(\varnothing)=B^u\) 反向添回条件，每次有
\[
0\to K\to F\to I_e\to0,
\]
其中 \(F\) 已自由，\(I_e\) 在 \(A/(\alpha_e)\) 上自由，因而有一阶分次自由 \(A\)-分解。Schanuel 给 \(K\) 稳定自由，从而分次投射。提升 \(K/A_{>0}K\) 的齐次基构造自由满射，投射性使其分裂，补核模 \(A_{>0}\) 后为零，分次 Nakayama 使补核为零。所以 \(K\) 分次自由。

依赖顺序是
\[
\text{较短区间的自由性}
\Rightarrow\text{边像包含}
\Rightarrow P=P'
\Rightarrow\text{每步取等}
\Rightarrow\text{本区间底点自由性}.
\]
没有用待证的底点自由性制造比较。原文 Remark 6.2 还比较了对应终段核的分次秩：两个环变量数可以不同，各自乘 \((1-q)^N\) 后照样相等。这个额外结论已经在原文中，不是本次新增定理。

## 6. 外部依赖与公开 Lean 的边界

**标准 Coxeter 输入。** 子词判据、提升性质和反射长度—根符号判据分别按 BB05 Theorem 2.2.2、Proposition 2.2.7、Proposition 4.4.6 使用；Deodhar–Dyer 的反射子群定理给规范 Coxeter 生成元及其正根。这些支撑有限支撑约化、三边细化和根平面二面体识别；第 3 节已经说明各步如何使用它们。本次未重证整套标准 Coxeter 理论，文献逐页核查集中在下面容易发生范围、方向或次数失配的接口。

**组合文献接口。** Dyer 1991 原刊 Proposition 3.3（第 189–190 页）在其有限 Coxeter 系统设定中重构全图；§3.4（第 190 页）讨论四环闭包的二面体陪集交。本文第 3 节另给了适用于任意 Coxeter 系统的证明，不能只凭那个旧引文抹去范围差异。

Dyer 1993 Corollary 3.4（第 108 页）实际写的是右标号递减路径及 \(\bar\alpha^r\)，其中 §3.1（第 105 页）的 \(\alpha=q^{1/2}-q^{-1/2}\)，而他的逆 Hecke 元展开系数 \(R^{\rm Dy}\) 与本文的关系是
\[
R^{\rm Dy}(x,z)=(-1)^{d(x,z)}q^{-d(x,z)/2}R_{x,z}(q).
\]
每条反射路径长度 \(r\equiv d(x,z)\pmod2\)，所以共同符号消去后正是本文的 \(\widetilde R(\alpha)\)。再以 \(w\mapsto w^{-1}\) 改为左标号，逆反射序给递增版本。此处已核对原扫描公式，见 `evidence/168/combinatorics/Dyer1993-p105.png` 与 `evidence/168/combinatorics/Dyer1993-p108.png`；纯文本抽取会漏掉关键上横线。

**有限秩与实表示。** 简单生成元集合可以无限，但 \(b\) 的有限支撑 \(J\) 包含整个 \([1,b]\)。反射也正确限制：\(T\cap W_J=T_J\)，可用已读 Davis 第一版 Lemma 4.2.3（印刷第 47 页）替代原引用 BB05 的这个接口。令 \(V_0\) 为几何根空间，\(K\) 为 Tits 形式的根基，取补空间 \(V_1\) 并添 \(K\) 的对偶 \(K'\)，使 \(K,K'\) 非退化配对、\(K'\) 各向同性且与 \(V_1\) 正交。这样得到 \(V_1\oplus K\oplus K'\) 的非退化实现，维数为 \(\#J+c\)，其中 \(c=\dim K\) 是 Tits Gram 矩阵的秩亏。任意独立根、余根实现中的根评价映射满射，而余根跨度内已经有 \(c\) 维核，故这个维数确实满足 EW 的最小性要求。

反射忠实性不只来自原表示忠实：秩一的 \(g-1\) 经正交性成为阶二正交反射；Davis Theorem 12.3.4(i)（印刷第 236 页，证明也已读）把它生成的有限子群共轭进有限标准抛物子群，在正定根跨度上识别为 Coxeter 反射。实域中避开可数多个真子空间，又给出 Fiebig 所需的 regular 与 simple-subregular 轨道。

**两端特征公式及次数。** 已核对 Elias–Williamson arXiv:1212.0791v2 的 Theorem 1.1（第 5 页）、Remark 3.2（第 15 页）、§3.5（第 18–20 页），以及 Fiebig arXiv:math/0512176v3 的 Theorem 6.3、Corollary 6.5（第 17–18 页）、Proposition 7.1(4)（第 19 页）和 §8.2（第 22–23 页）。

最容易错的是把下支撑层的 character 系数当成 stalk rank。令 \(n=\ell(b),m=\ell(x)\)，临时将根次数改成二，记变量 \(z\)、层为 \(\widehat B\)，取 \(M=\Gamma(\widehat B)(n)\)。Fiebig 用图 \((x^{-1}v,v)\)，EW 用 \((xv,v)\)，故需反下标及 Hecke 反自同构 \(H_x\mapsto H_{x^{-1}}\)。原文正确得到
\[
z^m\operatorname{grk}_z M^{[x]}=z^{n-m}P_{x,b}(z^{-2}),\qquad
M^{[x]}=\widehat L_x(U_x)(n).
\]
于是 \(\operatorname{grk}\widehat L_x(U_x)=z^{2(n-m)}P(z^{-2})\)。Fiebig 的实际模对偶式
\[
M^x=\bigoplus_i A(k_i)\quad\Rightarrow\quad
M^{[x]}=\bigoplus_i A(2m-k_i)
\]
再给 \(\operatorname{grk}\widehat B^x=P(z^2)\)。置 \(q=z^2\)，才是本文的 \(q^dP(q^{-1})\) 与 \(P(q)\)。秩一例 \([1,s]\) 的 stalk \(A\)、全核 \(\alpha_sA\) 的秩为 1、\(q\)，也立刻检出反向 shift。

**非标准无限二面体模型。** Fiebig v3 Definition 2.1（第 2 页）只要求有限维反射忠实表示；§5（第 12 页）加入上述轨道选择；Theorem 9.3（第 23–24 页）在这些条件下给 universal Coxeter 群的 character theorem。它不要求简单根的配对等于标准无限二面体几何模型的配对。限制环境表示到 \(D_\Pi\) 后，秩一的 \(d-1\) 仍为环境反射且像空间在 \(\Pi\)，所以由最大平面子群的定义是 \(D_\Pi\) 的反射；所需反射忠实性与轨道均成立。无限二面体正是秩二 universal 系统，故原文应用成立。有限二面体则拆成正定根平面与固定方向，使用 EW 及平坦多项式扩张。

由二面体 \(P=1\) 得到所有 stalk 在次数零秩一后，用**同一条延伸顶端生成元的齐次全局截面**统一全部顶点和边的基；沿下降路径，该截面的值不可能变成零。因此两端限制映射同时成为商映射，没有逐边任选基留下的回路相容问题。

**第 4 节局部分解不额外引用黑箱。** 局部化后，非平面边模全为零。相对上集未必为环境上集，但它对所有存活边向上闭；逐个加入环境最大缺失点，在其真正环境上集用 flabbiness 选值，就能延伸截面，已给定的低邻点不会造成存活边冲突。

下降到顶点 \(a\)，设上方截面的边界像为 \(N_a\)。生成性与相对 flabbiness 给出 stalk 到 \(N_a\) 的满射。已有每份结构层贡献 \(R/(p_{a,c})\)，其中非空标号乘积 \(p_{a,c}\) 属于极大理想。故已有模型的自由 stalk 之和 \(P_a\to N_a\) 模极大理想是同构。将原 stalk 的满射提升为 \(g:B_R^a\to P_a\)，Nakayama 使 \(g\) 满射，分裂后补核自由，成为顶为 \(a\) 的新模型。上端 stalk 同构先唯一诱导边商同构，再对下端配合，最终所有限制方块相容。它既不假设局部化保持不可分解，也不把不同边各自的模分解拼成层分解。

文献、版本、页码及原 PDF/TeX 均保存于 `evidence/168/sources/source-index.json`；上述输入是**已核对适用条件的外部定理依赖**，不是尚未解决的假设。Dyer 的 *Rank two detection* 原手稿也允许一般 Coxeter 群；其反序约定、不同范畴及略述不能直接替代本文的完整层分解，本文此处已有直接证明。

**公开 Lean 的实际范围。** `paper/lean/168.md` 所指 comparator 末尾的 `sorry` 是题面。相邻 JSON 指向实际入口 `OAI.RepresentationTheory.KazhdanLusztig.Invariance`，导出定理 `OAI.KLInvariance.combinatorial_invariance`，原源码第 545–560 行。其四个独立 universe 允许不同生成元类型和群类型；输入只有真实 Coxeter 系统、可比端点及无标签区间序同构，无有限秩、晶体、层特征或终段自由性附加假设。

Bruhat 序由反射乘法及严格长度增加的闭包给出；长度来自 Coxeter 呈示群的最短字。`CanonicalKL.lean` 第 260–287 行构造并证明正规化 KL 家族唯一存在，再用 `epsilon_spec` 将 `Classical.epsilon` 选出的家族与之识别。

正式解的主路线与正文有一个重要区别：它先对真实层特征建立 \(R\)-互反，**同时归纳 \(R\) 不变性与终段自由性**，再由普通 KL 互反及半次数界识别 \(P\)。旁支的 `StalkCharacterObligation` 不是最终定理的输入。`Invariance.lean` 第 137–208 行的行区间、上区间都严格更小；当前 \(R\) 等式先得出，再用于当前终段自由性。最后通过有限支撑约化消除有限秩限制。这里核对的是关键构造、入口和依赖顺序，不是人工重证全部 34 模块。

固定闭包包括 34 个解模块和一个题面，共 1,835,113 字节；目录 Git blob 与源码哈希可复核，唯一显式外部导入边界为 Mathlib。上游使用 Lean 4.34.1，Mathlib 固定于 `d13f23b723b8a846827a245b89c10fc7d3f11612`。初次尝试遇到 Mathlib/elan 坏链接；终审重放时共享环境已可调用 Lean 4.31.0，但两个入口均因缺少 `OAI` 模块而退出 2，尚未检验定理正文，不是已确认的 API 不兼容或定理被拒绝。故**没有本机通过编译的主定理，也没有实测最终公理集**；源码扫描无新增公理、无解中 `sorry` 不能代替这些输出。完整边界及复核方式见 `evidence/168/lean/statement_fidelity.md`；初次日志为 `evidence/168/lean/logs/main-axioms-verify.log`，终审日志为 `evidence/168/review/lean-replay.log`。

## 7. 核验结论

### 7.1 改进

**一个完整的小边界：终段不能换成任意子集。** 原文只断言运输终段核自由；我们考察更强的“任意 \(F\subseteq U_x\) 都自由”，得到一个真实 BMP 层的反例及全部子集分类。这不是原文错误，也不声称该反例的文献优先权。

取 A 型 \(S_4\)，\(w=3412,x=1324\)，\(A=\mathbb R[a,b,c]\)，\(a,b,c\) 为三个简单根，次数一。四条出边及实际下端映射如下；每个边模都是相应根的商环：

| 边编号 | 上端 | 根 | 对 \((u,v)\in Ae_0\oplus Ae_1\) 的限制 |
|---|---|---|---|
| 1 | \(1342\) | \(b+c\) | \(u\bmod(b+c)\) |
| 2 | \(1423\) | \(c\) | \(u+bv\bmod c\) |
| 3 | \(2314\) | \(a\) | \(u+bv\bmod a\) |
| 4 | \(3124\) | \(a+b\) | \(u\bmod(a+b)\) |

这里 \(\deg e_0=0,\deg e_1=1\)。该 BMP stalk 由如下最小自由覆盖得到：严格上方九个顶点的 stalk 均为 \(A\)，全部边映射可同时取商映射；从顶向下的秩一或菱形边界最小覆盖均为 \(A\)。到底点时，边界由常数截面 1，以及在 \(1423,2314,2413\) 取 \(b\)、其余上点取零的截面生成。

为使“确实生成全部边界”也可直接核对，设 \(s=a+b,t=b+c,d=a+b+c\)。任意上部截面减去顶值后，其四个余原子 \(1432,2413,3142,3214\) 的值为 \(s h_1,bh_2,dh_3,th_4\)。两边同余条件给四原子值
\[
\begin{aligned}
z_1&=s h_1+c h_3+cs l_1,&z_2&=a h_1+b h_2+ab l_2,\\
z_3&=b h_2+c h_4+bc l_3,&z_4&=a h_3+t h_4+at l_4.
\end{aligned}
\]
取
\[
\begin{aligned}
u&=s h_1-bh_3+th_4+cs l_1+at l_4,\\
v&=-h_1+h_2+h_3-h_4+a(l_2-l_4)+c(l_3-l_1).
\end{aligned}
\]
则 \(u,u+bv,u+bv,u\) 分别模 \(t,c,a,s\) 等于上述 \(z_i\)。加回顶值即得到全部边界。第二列不能由一次线性式乘第一列生成：这样的式须同时被 \(s,t\) 整除，因次数只能为零式，而 \(b\bmod c\ne0\)。这给次数 \(0,1\) 的真正最小自由覆盖，识别为 BMP stalk。完整十顶点、十六边的见证在 `evidence/168/extension/3412_witness.json`。

对对角对 \(F=\{1,3\}\)，部分核为
\[
L=\{(u,v):u\in(t),\ u+bv\in(a)\}.
\]
写 \(u=th\)，第二条件模 \((a,b)\) 迫使 \(h\in(a,b)\)。由此直接得到三个生成元
\[
g_1=(0,a),\quad g_2=(bt,-t),\quad g_3=(at,-a).
\]
若 \(\sum z_i g_i=0\)，首坐标给 \(bz_2+az_3=0\)，于是 \(z_2=ah,z_3=-bh\)；次坐标再给 \(z_1=ch\)。所以完整关系模恰为 \(A(c,a,-b)\)，并有极小分次分解
\[
0\longrightarrow A(-3)
\overset{(c,a,-b)}{\longrightarrow}A(-2)^3
\longrightarrow L\longrightarrow0.
\]
因此 Hilbert 分子为 \(3q^2-q^3\)，泛秩为 2，在原点却需要 3 个最小生成元，故不自由。交换 \(a,c\) 给另一对角对 \(\{2,4\}\)。关系向量在每个非原点素理想处至少有一个单位，故非自由障碍**恰在余维三**；这与原文全部根平面处的局部直和结论完全兼容。

不仅这两例，四原子按 \(1,2,3,4\) 的环序给出完整分类。下表的分子指 \((1-q)^3\operatorname{Hilb}(L_x(F);q)\)，自由时才等于分次秩：

| \(F\) 类型 | 数目 | 是否自由 | Hilbert 分子 |
|---|---|---|---|
| 空集 | 1 | 是 | \(1+q\) |
| 单边 | 4 | 是 | \(2q\) |
| 相邻二边 | 4 | 是 | \(q+q^2\) |
| 对角二边 | 2 | 否 | \(3q^2-q^3\) |
| 三边 | 4 | 是 | \(2q^2\) |
| 全集 | 1 | 是 | \(q^2+q^3\) |

`evidence/168/extension/classification.json` 保存所有精确生成矩阵，检查器双向约化验证其与实际核相等，并检查完整关系核。例如相邻对 \(12,23,34,14\) 的自由基分别为
\[
\{(t,-1),(0,c)\},\quad
\{(-b,1),(ac,0)\},\quad
\{(s,-1),(0,a)\},\quad
\{(st,0),(0,1)\}.
\]

**为何两个对角对不是任何运输 schedule 的终段，而不只是某个原生序不行？** 开区间的原子—余原子关联是一个八环。Dyer 1993 Proposition 4.3 与 Remark 4.4（印刷第 114 页）给反射序的 EL 标号及字典序 shelling；反序与取逆处理上下方向和左、右标号。在任何目标系统中，将饱和链按标号字典序排列后，它们按第一条底边分为四组，每组对应一个原子及其两条相邻环边。若末二原子是对角对，则首二原子也是对角对；第二组第一条环边与第一组完全不相交，违反一维 shelling 的非空纯零维附着要求。此论证只用偏序关联，因此适用于任何目标区间的运输。

反过来，14 个非对角子集全部能由本 A 型系统的几何反射序实现为终段：固定 \(h(a)=h(b)=h(c)=1\)，四条归一化根 \(t/2,c,a,s/2\) 是凸四边形的顶点，恰好非对角子集能严格线性分离；轻微扰动避免其余根的平局即可。分类证据还给每种情形一个整系数 \(f\)，并核对全部六个正根的 \(f/h\) 互异。**在这个小区间中，部分核自由恰好等价于子集可实现为运输终段；不把此等价推广到所有区间。**

小性的边界也完整：Coxeter 秩至多二时，二面体 stalk 秩一，任意部分核都是标号乘积主理想；区间长度至多二时，KL 次数界也使整个上区间的 stalk 秩一，结论相同。任意系统中的单边下端限制必满射，因为上端任意值可延伸为全局截面；Schanuel 因此使单边核自由。所以本例的 Coxeter 秩 3、区间长度 3、选边数 2 各自都达到最小可能边界。前面这些低秩、单边事实是标准输入的直接推论，不单独宣称创新。

发表基线同样吻合：Woo arXiv:0809.2374v1 的 Theorem 2.1 给 \(\operatorname{sing}X_{3412}=X_{1324}\)、\(\operatorname{sing}X_{4231}=X_{2143}\)；Theorem 1.1、Corollary 1.2 给相关奇异 stalk 的 \(P=1+q\)。因此表中空集的 \(1+q\) 与全核的 \(q^2+q^3\) 是文献及原文归一化的确认，不是新增数值。第二个真实例保存在 `evidence/168/extension/4231_witness.json`，底为 \(2143\)，亦有同一非自由分解。

本次实际重放 `python3 evidence/168/extension/verify_witness.py --self-test`，通过两个真实 BMP 构造、全部 16 类核的生成/完整关系核核对，以及从真实 CLI 入口拒绝的 16 项负对照（错根、错映射、错但仍合法的 \(F\)、齐次伪生成元/关系、浮点等）。构造脚本 `evidence/168/extension/bmp_a3.py` 从完整 \([1,w]\) 的边界最小覆盖递归出发，不输入 KL 数值；有理系数计算经忠实平坦扩张给本文的实系数层。

**原文方法的另一个范围澄清。** Proposition 4.4 使用二维正则局部 UFD，但其自由覆盖分裂本身只需交换局部环：已有结构层须生成且 flabby，每个真下端边界为 \(R/I_{a,c}\)，其中 \(I_{a,c}\) 为真理想并在极大理想中，则同一个提升、Nakayama、分裂归纳给出全部边映射相容的直和分解。UFD 只在进一步把 \(I_{a,c}\) 写成标号乘积时需要。完整引理在 `evidence/168/sources/local-cover-proof.tex`。这是原文方法的直接提炼，不主张新文献定理；不能顺带删去结构层 flabbiness 这个实质输入。

### 7.2 错误与不足

第 2–6 节未发现确定错误；已检查两层归纳、相对与环境序的区分、有限最长元的单重计数、非标准无限二面体表示、character 的逆元与 shift、全部边映射的局部分解相容性、双向比较及高余维商的消除。第 6 节逐项列出的困难外部接口均已取得所列版本并核对适用条件，没有因此留下未决数学接口。

公开 Lean 的本机重放限制见第 6 节。

### 7.3 已核验

手算核对了第 5 节列出的完整组合—比较链。运行 `python3 evidence/168/combinatorics/check_main_chain.py` 还精确核验：\(S_4\) 全部 189 个非平凡区间的图闭包，72 条反射边的平面求和，98 个相对区间的逆元运输及相应 212 次晚边差；对 213 对可比端点，逐系数比较 \(\mathbb Z[T]\) 中的矩阵乘积与双向反射序路径多项式，以 \(q=z^2\) 在 \(\mathbb Z[z,z^{-1}]\) 中检验 \(R\) 归一化及 \(q\) 倒数符号，并在 \(\mathbb Z[q]\) 中检验 KL 互反式。另对 \(I_2(m)\)、\(2\le m\le8\)，及无限二面体绝对长度至多 8 的相关相对区间，两种角序共核对 2566 个晚边计数。七个负对照拒绝错图、错反射参数、错平面指数，以及在原先点值测试 \(T=3/2\) 下与真值相同的伪多项式。日志在 `evidence/168/combinatorics/check_main_chain.log`。这些有限核验不替代任意群的手算论证。

| Claim | Source | Basis | Evidence |
|---|---|---|---|
| 对任意向上边子集，BMP 部分核都自由（所探索的加强，原文未声称） | ours, 对原文终段命题的试探加强 | refuted | `evidence/168/extension/3412_witness.json`; `evidence/168/extension/verify_witness.py`; `evidence/168/extension/check_results.json` |
| 十点区间的真实 BMP 映射、全部 16 种部分核与第二奇异实例，含 16 项入口负对照 | ours, 精确构造与分类 | checked by computation | `evidence/168/extension/bmp_a3.py`; `evidence/168/extension/verify_witness.py`; `evidence/168/extension/3412_witness.json`; `evidence/168/extension/4231_witness.json`; `evidence/168/extension/classification.json`; `evidence/168/extension/check_results.json` |
| 非自由对角核有极小分解三生成一关系；在该例中自由当且仅当可实现运输终段，低秩、短区间及单边的边界最优 | ours, 显式小边界；低秩半边为标准特征公式的直接推论 | checked by hand | `guide/Combinatorial-Invariance-of-Kazhdan-Lusztig-Polynomials-September-24-2026.md`; `evidence/168/extension/3412_witness.json`; `evidence/168/extension/classification.json`; `evidence/168/combinatorics/Dyer1993.pdf` |
| 这些奇异 stalk 的已有数值为 1+q，不是本次新发现 | literature, Woo arXiv:0809.2374v1 Theorems 1.1、2.1 与 Corollary 1.2 | checked by hand | `evidence/168/extension/sources/woo2008v1.pdf`; `evidence/168/extension/literature.json` |
| 局部覆盖分裂仅需交换局部环及模型 flabbiness/真边界理想，不需维数二、正则或 UFD | ours, 原文 Proposition 4.4 方法的直接提炼 | checked by hand | `evidence/168/sources/local-cover-proof.tex` |
| 本次所读七个顶层 TeX 与固定提交一致 | ours, 来源核对 | checked by computation | `evidence/168/combinatorics/paper-directory.json`; `evidence/168/combinatorics/check_main_chain.py`; `evidence/168/combinatorics/check_main_chain.log` |
| 任意 Coxeter 区间的全图可由六点八边闭包恢复，Theorem 3.4 | paper, 第 3 节 | checked by hand | `paper/Combinatorial-Invariance-of-Kazhdan-Lusztig-Polynomials-September-24-2026/build/03-dihedral.tex` |
| 相对区间运输、两种角序晚边差与平面贡献和，Proposition 3.5、Lemmas 3.7–3.8 | paper, 第 3 节 | checked by hand | `paper/Combinatorial-Invariance-of-Kazhdan-Lusztig-Polynomials-September-24-2026/build/03-dihedral.tex` |
| 上述有限范围内的图与平面计数通过；矩阵、路径及 R 归一化和 KL 互反均逐系数通过，含七项负对照 | ours, 有限一致性核验 | checked by computation | `evidence/168/combinatorics/check_main_chain.py`; `evidence/168/combinatorics/check_main_chain.log` |
| 目标自由格的高度一成员判别；它只给全局边像包含 | paper, Lemma 5.1、Proposition 5.2 | checked by hand | `paper/Combinatorial-Invariance-of-Kazhdan-Lusztig-Polynomials-September-24-2026/build/05-comparison.tex` |
| 正号、递减路径、双向负次数比较、亏损消失和反向自由性不形成循环 | paper, 第 6 节 | checked by hand | `paper/Combinatorial-Invariance-of-Kazhdan-Lusztig-Polynomials-September-24-2026/build/05-comparison.tex` |
| 实表示满足反射忠实性、独立根余根及最小维数；两端特征公式与原文归一化相符 | paper, Lemma 2.1、Proposition 2.4 | checked by hand | `paper/Combinatorial-Invariance-of-Kazhdan-Lusztig-Polynomials-September-24-2026/build/02-background.tex`; `evidence/168/sources/source-index.json` |
| Fiebig 的 universal-group theorem 适用于实际诱导无限二面体表示，不需标准几何配对 | literature, Fiebig v3 Definition 2.1、§5、Theorem 9.3 | checked by hand | `evidence/168/sources/fiebig08/arxiv-math_0512176v3.pdf`; `evidence/168/sources/source-index.json` |
| 相对 flabbiness 及逐顶点局部分解保留每条边的两端限制 | paper, Lemma 4.3、Proposition 4.4 | checked by hand | `paper/Combinatorial-Invariance-of-Kazhdan-Lusztig-Polynomials-September-24-2026/build/04-localization.tex`; `evidence/168/sources/local-cover-proof.tex` |
| Theorem 1.1 及所有子区间、终段核秩的结论 | paper, Theorem 1.1、Corollary 6.1、Remark 6.2 | conditional on a cited result: EW v2 Theorem 1.1；Fiebig v3 Theorems 6.3、9.3 与 Proposition 7.1(4)，均已核对适用条件 | `evidence/168/sources/ew14/arxiv-1212.0791v2.pdf`; `evidence/168/sources/fiebig08/arxiv-math_0512176v3.pdf`; `evidence/168/sources/source-index.json` |
| 反射序路径公式的原刊接口及有限设定图重构的原始范围 | literature, Dyer 1993 Corollary 3.4 与 Dyer 1991 Proposition 3.3 | checked by hand | `evidence/168/combinatorics/Dyer1993.pdf`; `evidence/168/combinatorics/Dyer1991.pdf`; `evidence/168/combinatorics/sources.json` |
| 已有完整不变性界为一般系统长度 6、有限 Weyl 长度 10、有限 A 型长度 12 | literature, BGL v2 Corollary 1.4；EMS v2 Corollary 1.3(ii) | checked by hand | `evidence/168/history/BGL/arxiv-2601.07793v2.pdf`; `evidence/168/history/EMS/arxiv-2509.16433v2.pdf` |
| 公开 Lean 的实际定理陈述匹配主定理，真实对象与关键构造非额外假设；固定本地导入闭包已保留 | paper, 公开 Lean 解及范围声明 | checked by hand | `evidence/168/lean/statement_fidelity.md`; `evidence/168/lean/closure.json`; `evidence/168/lean/provenance.json`; `evidence/168/lean/source/OAI/RepresentationTheory/KazhdanLusztig/Invariance.lean` |
| 实际 Lean 入口的本机内核重放及最终传递公理集 | paper, 公开 Lean 主定理 | open | `evidence/168/review/lean-replay.log`; `evidence/168/review/current-environment.log`; `evidence/168/lean/logs/main-axioms-verify.log`; `evidence/168/lean/MainAxioms.lean` |
