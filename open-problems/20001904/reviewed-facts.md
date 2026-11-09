# Cross-campaign reviewed facts

Facts, not instructions. Entries appear in Manager review order.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `family-obstruction.md 给出了正则水平、环境完备性、Clairaut 首积分、转向渐近、曲率与法向 Jacobi 方程的完整推导。`
- `Wronskian 恒等式和积分发散严格产生位于不同参数值的两个 Jacobi 零点，覆盖全部规定的光滑正值单调有限极限剖面。`

Fact: For every prescribed smooth, positive, monotone warped-plane profile with a finite limiting value, the profile-independent Wronskian divergence mechanism forces a nontrivial Jacobi field to have two zeros at distinct parameter values, so the entire family necessarily contains conjugate points. This excludes that bounded monotone warped-plane family as a source of the sought counterexample, but does not exclude other profiles or geometric mechanisms.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `family-obstruction.md 直接证明完备性和两个端点量词，并由 A_lambda>=lambda^2>=1/16、边界单胞估计和 146 单胞试验场得到 Q<-1。`
- `同一论证用 Picone 恒等式将负指数转化为每个冻结参数上的非零两零法 Jacobi 场，无数值采样或有限参数替代。`
- `MATH_STATE.json 与 PROOF_GRAPH.json 将冻结族见证标为被反驳、障碍标为成立，同时保持原始目标开放；pinned math-state check 返回无问题。`

Fact: 对于给定公式且 λ∈[1/4,1/2] 的冻结周期透镜族，中心完整测地线上的正单胞平均曲率会在足够长区间累积出负指数；Picone 恒等式因此对每个参数产生非零的两零点 Jacobi 场，统一排除了该族的无共轭点候选，但不排除其他周期透镜或一般局部变形。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `Bangert–Emmerich arXiv:1201.2883v2 的 Theorem 2 及其前置定义已与归档全文独立对照。`
- `periodic-cylinder-rigidity.md 给出了商空间完备性、覆盖下共轭点等价性、两端面积增长和 K=-1 矛盾的完整解析证明。`

Fact: 对于精确 y-周期、负端 h=e^x、正端 h=c 的正交完备度量，若无共轭点，则商圆柱的两端球面积增长为次二次，Bangert–Emmerich 圆柱刚性定理迫使度量平坦；这与尖点区域 K=-1 矛盾。因此该构造类不可能产生所求反例，但非周期或仅渐近满足端模型的情形仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `精确 Wronskian 论证给出两零 Jacobi 场；统一严格界将整个共轭段置于 rho=1 区域。`
- `已检查原始问题、冻结族定义及完整解析证明。`

Fact: 对冻结参数域 ε∈(0,e^-2] 内的非周期走廊族，每个参数值都存在非零的两零 Jacobi 场，且对应共轭段严格位于 ρ=1 走廊内；因此该族全部存在共轭点，不能作为原问题的反例。此结论仅排除该冻结族，原始存在性问题仍开放。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `The frozen formulas define a smooth positive complete metric on R^2 and two distinct complete unit-speed horizontal geodesics.`
- `For t<4 the joining vertical segment has length e^t, while at t_n=n!-15 it has length at most 1+2^-n<=17/16.`
- `On the first-cell turning orbit D_4=0 and the perturbation has vanishing derivatives through order two, preserving the geodesic, curvature coefficient, and nonzero Jacobi field with zeros at two distinct parameters.`
- `Gulliver's primary Theorems 1-3 and Riccati inequality were inspected and require hypotheses not established for this sparse chain.`

Fact: This frozen factorial sparse-chain construction is exactly ruled out: although it gives a smooth positive complete metric with two distinct complete geodesics that approach each other at one end and repeatedly remain uniformly close at the other, its preserved turning-orbit second jet retains a nonzero Jacobi field vanishing at two distinct parameters, so the metric has conjugate points. Gulliver's no-conjugate-points results do not certify the construction because their required hypotheses are unestablished. This exhausts only this specific frozen family and is not a counterexample to the original open problem.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `复核 exact-exhaustion.md 中的曲率界、穿越长度、双曲缓冲、严格 Riccati 不等式和全局 Jacobi 比较。`
- `重新推导 Abel 散射公式及全参数严格负导数界，并检查径向情形、两种符号及支撑边界。`

Fact: 该冻结径向单透镜的 Abel 散射角在整个 Clairaut 参数域严格递减，因此有向理想端点唯一确定测地线，排除了该剖面产生重复端点见证的可能；这一穷尽结论仅适用于该冻结剖面，原始存在性问题仍开放。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `在完整测地线 gamma(t)=(0,-2t,t) 上精确核验 J(t)=sin(t) partial_x 的 Jacobi 方程及两个不同零点。`

Fact: 冻结的振幅 2 常核心剪切桥具有共轭点：完整单位速测地线 gamma(t)=(0,-2t,t) 上存在非零 Jacobi 场 J(t)=sin(t) partial_x，并在两个不同点消失。因此，该构造不能作为无共轭点目标的反例；这一结论只排除该冻结构造，不排除剪切导数保持非零的相关构造。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `任意支撑重入行程必交替，球间长度至少为 1；精确 Riccati 递推在每次进入前给出严格正裕量并在离球后保持正斜率。`
- `足点顺序和闭合方程推出 |a-d|<tau|a-C|，继而 |a|<1/8；这与半径 asinh(1/4) 的首球避轴条件直接矛盾。`

Fact: 在 c=1/8、等冲量双透镜、指定物理顺序且球间缓冲至少为 1 的冻结域内，所有重入行程均无共轭点，但闭合条件强制 |a|<1/8，而首球避轴条件要求 |a|>1/4，因此该域不可能产生所求反例；不等冲量或更长透镜行程仍未排除，原问题保持开放。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `research/routes/unequal-impact-two-lens/exact-exhaustion.md gives an exact full-domain derivation covering both side choices, exceptional closure values, physical order, support geometry, and axis avoidance.`
- `The pinned Jacobian symbolic-matrix contract was inspected before independently rerunning the recorded payload; the exact product verifies the stated Mobius normalization.`
- `The previously reviewed single-lens scattering and itinerary-independent unit-gap Riccati certificates apply with unchanged hypotheses.`

Fact: An exact full-domain analysis rules out the two-copy route built from the reviewed Gulliver lens profile with the unit support-gap certificate: physical ordering and support separation force q < e^-1 k1k2, while same-side closure intersects a support ball and opposite-side axis avoidance requires q > (16/17)k1k2. The same incompatible product bounds persist for unequal impulses, so the obstruction is structural rather than an equal-impulse coincidence. This conclusion does not cover three or more copies or different lens profiles, and the original conjecture remains open.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `The frozen domain covers all impacts 0<c1,c2,c3<1/4, both positive sequential scales, and all relative sides modulo positive dilation and reflection.`
- `Physical order and consecutive unit support gaps give the exact upper bounds on both placement scales; these are necessary for every placement satisfying all pairwise gaps.`
- `Direct substitution verifies all four sign branches, every exceptional closure or normalization value, and all three support-to-axis distance formulas.`
- `The arbitrary-reentry Riccati argument uses every relevant pairwise unit gap and does not assume alternation or a finite itinerary.`
- `The required math-state check returned no issues; the campaign proof graph correctly leaves the original counterexample claim open, and citation status has no blocking assumptions.`

Fact: The frozen three-copy Gulliver profile is exactly exhausted: across all impacts, positive sequential scales, and relative-side branches modulo dilation and reflection, consecutive unit support gaps impose incompatible placement-scale and axis-avoidance constraints. The obstruction also applies to arbitrary reentry without assuming alternation or a finite itinerary. This rules out only the reviewed three-copy domain; the original counterexample problem remains open.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `frozen-family.md fixes the complete domain 1<=A<=3/2 and an explicit smooth compact annular bump with exact hyperbolic pole and exterior.`
- `exact-exhaustion.md proves smoothness, completeness, positive curvature somewhere, K<1, and a comparison argument excluding conjugate points along every complete geodesic.`
- `The full-impact Abel derivative estimate gives a positive bracket margin of 829/1024, hence strict scattering injectivity and refutation of the frozen-family witness claim.`

Fact: For the explicit smooth compact annular bump over the full amplitude interval 1≤A≤3/2, every complete geodesic has no conjugate points, while the Abel derivative bracket remains positive by at least 829/1024. Consequently, the scattering angle is strictly monotone and the proposed repeated-endpoint witness cannot occur in this frozen family. This is a family-specific obstruction, not a result for all radial compact perturbations.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `已检查 exact-exhaustion.md 中覆盖任意有符号、多峰、漂移支撑剖面的解析变分证明及光滑尖锐逼近`
- `已独立重跑 replay_exact_identity.py 的精确代数证书`
- `已核对 Gulliver 主值条件、原问题文本及已记录的开放状态`

Fact: 全部主值支路的 width-one Gulliver-certified 径向类均不能产生所需的不同测地线：对任意有符号、多峰且支撑可漂移的剖面，Abel 增益与 Jacobi 传递系数精确相等，并统一严格小于 1，因此散射严格单调。光滑逼近表明该界尖锐。该结论穷尽了这一径向机制，但非径向机制及原开放问题仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `冻结文档给出光滑、嵌入、单侧的 beta 及紧支撑共形族；独立推导确认 beta 为测地线当且仅当 lambda=1`
- `曲率计算给出 K=-1+128 sin(1/32)>1，独立 Jacobian 重放仅确认精确有理 Taylor 余量 3071/1536`
- `Busemann 对齐及两端显式路径估计分别证明负向距离趋零和正向距离具有有限 limsup`
- `精确结果明确把无共轭点命题保留为开放，并未把条件比较写成全局证明`

Fact: 在该紧支撑共形族中，beta 成为测地线的唯一参数是 lambda=1；该参数下曲率峰值严格大于 1，因此依赖 K<=1 的 Sturm/Riccati 充分判据不适用，而无共轭点性质仍未解决。与此同时，Busemann 对齐与显式路径估计已确认负向距离趋于零、正向距离具有有限上极限。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `negative-witness.md derives the exact curvature identity, global flat-step bounds, strictly negative index form, and the resulting two-zero nonzero normal Jacobi field on the complete geodesic beta.`
- `The independent standard-library replay reproduced the strict curvature-integral and index bounds over the full prescribed domain.`
- `The installed interval.expression.box_enclosure.compute contract matches the payload, and its typed enclosure gives a strictly positive lower bound for 4*sin(B)*cos(B)-B on 1/64<=B<=1/60.`

Fact: For the frozen λ=1 cubic-blister metric g₁, the complete geodesic β has curvature integral strictly greater than 481976087/149869440 > 3, while the two hyperbolic ramp contributions to the index are strictly less than 3. Consequently, β admits a strictly negative index form and a nonzero normal Jacobi field with two zeros, disproving that g₁ has no conjugate points. This conclusion applies only to the frozen λ=1 family; the broader counterexample problem remains open.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/20001904

Evidence refs:
- `The frozen family fixes the degree-four Hermite profile, coefficient box, and both cutoffs before screening.`
- `The six positive rational weights annihilate all five Hermite second-derivative directions and force the strict weighted curvature-gate upper bound -1682398/35756721.`
- `Independent exact replay reproduced all five zero moments and the strict negative bound.`

Fact: For the frozen degree-four Hermite family over the full coefficient box, six positive rational weights simultaneously eliminate all five coefficient-dependent second-derivative directions and yield a strictly negative weighted curvature-gate bound. Consequently, every coefficient choice violates the preregistered pointwise curvature certificate at one of six exact points, exhausting this specific correction family while leaving higher-degree or mechanism-distinct corrections and the original conjugate-point question unresolved.
