# 形式陈述对应与重放边界

固定来源为 `openai/math@4eaee87548250b2682affda7d05d947c05554bae`。
本目录保存源码归属及入口核对证据，**没有本机成功编译或实测公理集**。
所有原始源码均未修改。

## 陈述对应

论文 `build/01-introduction.tex:22–34` 的主定理是：任意两个 Coxeter
系统的可比端点区间，若作为无标签偏序集同构，则其等参数 KL 多项式相等。
`upstream/KLInvariance.json:2–6` 指向实际解
`OAI.RepresentationTheory.KazhdanLusztig.Invariance`，而不是要求证明的
comparator 文件。以下完整源码路径相对于本目录 `source/`；
仅写文件名的本地源码定位均指 `source/OAI/RepresentationTheory/KazhdanLusztig/`。
外部 Coxeter 定义文件 `Matrix.lean`、`Basic.lean`、`Length.lean`、
`Inversion.lean` 则均相对于 `upstream/Mathlib/GroupTheory/Coxeter/`：

- `ComparatorChallenges/KLInvariance.lean:86–95` 是待证题面，最后的
  `sorry` 不属于实际解。
- `OAI/RepresentationTheory/KazhdanLusztig/Invariance.lean:545–560`
  是实际导出定理 `OAI.KLInvariance.combinatorial_invariance`。
  四个独立 universe 允许不同生成元类型与群类型；输入只有两个系统、
  两个可比性证明和 `Interval ... ≃o Interval ...`。没有有限群、有限秩、
  晶体型、标签保持、预给定 KL 不变性或自由性假设。
- `logs/source-integrity.log` 记录了自动比较：comparator 中定义区与
  实际 `Model.lean` 的公共部分逐字节相同；两个最终定理的陈述去掉空白
  后相同。

## 对象不是替换模型

`Model.lean:14–23` 用真实反射乘法及严格长度增加定义强 Bruhat 步，
取自反传递闭包，再取含上下端点的区间；不是弱序或任意抽象偏序。
`Model.lean:45–78` 中秩差为自然数减法，仅在可比端点使用；
`Bruhat.lean:26–36` 给出长度单调性，因而这里没有截断导致的范围变化。
`Bruhat.lean:76–108` 证明下理想及区间有限，故正规化中的 finsum
不是以不受支持的无限和约定将互反关系消掉。

`Model.lean:55–71` 的 R 递推、对角正规化、零支集、严格半次数界和
互反关系就是等参数正规化。`klFamilies` 虽用 `Classical.epsilon`，
但并未把存在性作为输入：`Hecke.lean:24–47,252–255,482–500`
构造真实群的标准基作用及 R-tilde；`OrdinaryR.lean:30–91`
构造整系数 R 并证明普通递推；`CanonicalKL.lean:70–84,165–229`
以真区间递归构造 P 并证明互反；同文件 `260–287` 证明正规化家族
唯一存在，应用 `epsilon_spec`，并将所选 P 与构造的 P 识别。

唯一外部显式导入边界为 `Mathlib`。另保存了该库固定提交
`d13f23b723b8a846827a245b89c10fc7d3f11612` 下四个 Coxeter 定义文件，
**仅作语义定位，不是 Mathlib 的导入闭包或重建**：
`upstream/Mathlib/GroupTheory/Coxeter/Matrix.lean:69–74` 是 Coxeter 矩阵；
`Basic.lean:104–113,157–166,190` 将群定义为 Coxeter 呈示群，将系统
定义为与它的群同构；`Length.lean:70–81` 是最短字长度；
`Inversion.lean:64–66` 的反射是简单反射的共轭。

非空性可直接手工实例化：单个生成元、对角矩阵项为 1，取其呈示群
及 `toCoxeterSystem`，即二阶循环群；区间 `[1,s]` 有两个元素，
自同构满足定理输入，正规化给出 `R(1,s)=q-1`、`P(1,s)=1`。
一般任何矩阵也有 `Basic.lean:166` 的规范系统及单点区间。
这些实例说明系统及区间的假设可以满足。

## 实际证明分支与接口

这里核对了关键定义、构造器及最终主链；没有逐行手工重证全部
42,948 行 OAI 源码。

`GradedSheaves.lean:1138–1146,1177–1242` 由有限图上最小自由覆盖的
归纳构造 BoundarySheaf；结构字段不含目标 KL 不变性或所有部分核自由性。
`SheafMorphisms.lean:139–181,202–226` 在真实根标签的实多项式环上选取它，
其顶点特征为自由分次基的真实特征多项式，非预先命名的 KL 多项式。
`StalkCharacterObligation` 在同文件 `219–220` 确实只是一个 Prop；
最终证明不用旁边以它为条件的 KL-character 分支。

实际路线为 R-first：

1. `CharacterReciprocity.lean:1497–1512,1740–1756` 从 word/BMP
   分解构造对偶；`DyerPaths.lean:62–102` 由双分解和更短顶点的消元
   得到真实 stalk 特征的 R-互反，未假定其等于 KL。
2. `EdgeLocalization.lean:23–42,129–136,219–227` 将无标签区间序同构
   经已证明的强 Bruhat 图重构映成边调度，再用路径公式识别目标 R-矩阵。
3. `TerminalKernels.lean:1045–1100,1126–1186` 从目标部分核自由性，
   通过平面局部化及素除子分母消除，推出真实边像包含和调度比较。
   这是本条主链最重的源接口；其调用的平面局部化构造和全部本地
   导入依赖均保留在本目录。
4. `Invariance.lean:137–208` 同时对区间秩作强归纳：先从严格较小的
   行区间得到 `hrow/hrow'`，从严格较高底点的上区间得到
   `hupper/hupper'`；由双向比较证明当前 R 相等，再用当前 R 相等
   推出当前所有终段核自由性。
   `SimultaneousInvariance.lean:296–309` 的 `hr` 因而是已经证明的当前
   R 等式，不是作为当前 R 不变性证明的输入。
5. `Invariance.lean:430–462` 用正规 KL 半次数界和 R-互反识别 P；
   `469–526,545–560` 再用有限生成元支撑和标准抛物子群约化消除有限秩。
   关键识别 `Tits.lean:1519–1645` 从真实嵌入、区间同构、正规化唯一性
   得到。

在全部 34 个本地解模块中，源码扫描没有发现显式 `axiom`、
`sorry/admit`、`native_decide`、自定义 elaborator 或关闭内核检查；
唯一 `sorry` 在题面。扫描命令与结果见 `logs/source-integrity.log`。
JSON 的三个 `permitted_axioms` 是允许运行的策略。

## 归属、环境及复核

`closure.json` 保存 34 个 OAI 模块和 1 个 comparator 的导入图、
Git blob、SHA-256、pin 及边界，共 1,835,113 字节；目录 JSON 在
`metadata/closure/`。KL 子树为 `truncated: false`，没有依赖曾被截断
的全仓递归树。`provenance.json` 补记相邻 JSON、上游工具链/依赖配置、
外部定义原文件的 GitHub 目录 blob 归属。

上游 `upstream/lean-toolchain` 为 Lean 4.34.1；
`upstream/lake-manifest.json` 的 Mathlib pin 如上。初次尝试时，pack 0.7.2
配置的 Mathlib 与 elan 路径都是坏链接，PATH 及已知小范围替代位置均无 Lean，
实际探测保存在 `logs/environment.log`；对实际入口与 `MainAxioms.lean`
的尝试退出 2，见 `logs/main-axioms-verify.log`，未进入 elaboration。

2026-11-10 的独立终审重放时，共享 pack workspace 已可运行 Lean 4.31.0。
同一个验证命令对两个入口均报 `unknown module prefix 'OAI'` 并退出 2，
见 `../review/lean-replay.log` 与 `../review/current-environment.log`。
这个后续结果更新了环境失败的阶段，仍未检验主定理正文，不能据此
断言上游 API 不兼容、通过编译或最终传递公理集。没有安装依赖或重建库。

环境修复后，应在**匹配上述 pin 且本地模块已构建**的项目中运行
`lake env lean MainAxioms.lean`，并将最终定理的 `#print axioms`
输出与策略列表比较。
