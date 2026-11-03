# Cross-campaign reviewed facts

Facts, not instructions. Entries appear in Manager review order.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1900020

Evidence refs:
- `独立完整域计数重新得到47,617,404个格点、28,947,904个本原首列和40,130,215个派生剪切。`
- `新选非中心u=137切片的32,853条记录在Python精确核与新编译C++分类器之间逐项一致：14,118个源门拒绝、18,735个严格越界、零目标相等、零未决。`
- `全域证书的门计数、结果计数和步数直方图形成精确分拆；全部17,196,247个通过源门的状态在第13至64步严格越界，低于195步证明界。`
- `MATH_STATE记录了问题的已知来源，并保持C_COUNTEREXAMPLE、C_INFINITE_OBSTRUCTION和C_D81_LEVEL_DEPENDENT_NON_SMITH_EMPTY为开放状态。`

Fact: 在固定高度21、参数从0到1的有限域中，穷尽分类未发现目标相等或未决状态；所有17,196,247个通过源门的状态均在第13至64步严格越界。该结论仅适用于这一有限域，不构成反例、无限非周期证书或全高度定理。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1900020

Evidence refs:
- `DERIVATION.md 给出两张完整零面的参数化、primitive wedge content、行列式方向及统一三嵌入不等式`
- `独立内存复跑生成的精确证书与保存的 zero-face-parametric-closure.json 内容一致`
- `记录的 Jacobian payload 独立返回 (17E-1)b-17na，并在 W_j=0 前缀关系下得到所需 Bézout 恒等式 -1`
- `权威 batch-root math-state 检查通过，campaign proof-graph gap 检查确认全局目标仍有未证命题`

Fact: 对所有 h≥4、j≥4，完整的 V_j=0 与 W_j=0 参数面均与入射 chamber 精确矛盾，因此反例若存在，必须位于 V_jW_j≠0 的纤维；这些纤维的存在性及原反例目标仍未解决。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1900020

Evidence refs:
- `透明外积与行列式计算给出 G_j=17*g_j、D_j=289*g_(j-1)*g_j*delta_j*(s_(j-1)*v_j+t_(j-1)*w_j)，从而得到要求的商和定向。`
- `去尺度关系 17*g*r=b*e+1、d=e*c+17*g*v、s=b*v+c*r、t=f*s+r 具有双向重构，并保留全部符号室、无界参数和特化相关内容。`
- `只读精确证书重跑成功；独立 Jacobian 只读重跑返回精确多项式 289*g*(S*v+T*w)。`
- `无截断构造证明 primitive Farey-plus-word 投影对任意正尺度和 primitive height 都有无限严格后继。`

Fact: 精确代数验证表明，行列式恒等式为 289g(Sv+Tw)，并支持相应的商、定向及去尺度双向重构。与此同时，primitive Farey-plus-word 投影在任意正尺度和 primitive height 下都有无限严格后继，因此该投影的无限延伸不能判定包含整除、规范化、精确楼函数、目标等式和单位平方后继等门条件的完整系统；这是一项可复用的路线局限，而非完整轨道存在性或排除结论。

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1900020

Evidence refs:
- `The shared terminal-basis and exact-next-target conventions were checked against the two-level complete classifier and imply an integer-valued functional with L(Z)=L(Zhat)=1.`
- `All nine trace-dual pairings and N(3*theta^2-3)=-81 were independently recomputed exactly, establishing the nonzero norm lower bound 1/81.`
- `The three exact root intervals, eight generalized-Vandermonde alternants, three Cramer numerators, and strict upper bound 2^-63 were independently checked without using the route verifier.`
- `The updated deterministic certificate reran successfully and states a cutoff-free exclusion for every h,j>=4 and every legal N,g,n in the canonical family.`

Fact: The canonical mixed-sign family is excluded without truncation for all h,j>=4 and all legal N,g,n: the two-level shared successor basis yields an integer-valued functional whose nonzero algebraic norm is at least 1/81, while exact root, alternant, and Cramer bounds force that norm below 2^-63, a strict contradiction. This establishes a global obstruction for the canonical family only; it neither excludes noncanonical nonzero fibers nor provides a counterexample to eventual periodicity.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1900020

Evidence refs:
- `The signed Cramer argument excludes abs(m)<=P(beta^(2^j))/Z(beta^(2^j)) for every h,j>=4 through the contradiction abs(N(xi))<2^-62<1/81.`

Fact: A signed Cramer argument establishes a small-trace exclusion: for every h,j>=4, candidates with abs(m)<=P(beta^(2^j))/Z(beta^(2^j)) are impossible, since they imply abs(N(xi))<2^-62<1/81. This is a necessary condition, not a resolution of the unrestricted large-trace construction; no accepted D81 seed or all-level continuation certificate has been established.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1900020

Evidence refs:
- `research/routes/d81-large-trace-target-exact-continuation/DERIVATION.md: the determinant classification and independent-limit argument exclude fixed finite-period two-mode branches.`
- `research/routes/d81-large-trace-target-exact-continuation/two-mode-continuation.json: read-only recomputation reproduced six uniform oriented cases, 24 floor pairs, four equality suffixes, and six coefficientwise instances; target and forced-successor first-coordinate equalities fail.`

Fact: For the D81 large-trace target exact-continuation construction, determinant classification and an independent-limit argument exclude fixed finite-period two-mode branches. Exact recomputation also found that the target and forced-successor first-coordinate equalities fail in the examined cases. This exclusion is supported by an independently reviewed prose proof, not a kernel-checked theorem; unrestricted large-trace continuation and the original counterexample objective remain unresolved.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1900020

Evidence refs:
- `two-edge-lattice-factorization/DERIVATION.md establishes the column-lattice equivalence and exhaustive fixed-row obstruction.`
- `two-edge-factorization.json and its read-only verifier give four algebraic target pairs and zero accepted pairs.`

Fact: In the two-edge lattice-factorization construction with inverse row (-16,17,-17) at h=5, j=4, the column-lattice reduction yields four algebraic target pairs, but none is admissible: all fail the incoming chamber, the next full L1 gate, and the prescribed next word's first floor. Thus algebraic target identities alone do not establish dynamical admissibility in this construction. The fixed-row obstruction does not exclude other inverse rows or certify an accepted seed or infinite continuation.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1900020

Evidence refs:
- `The exact verifier and independent rational-interval, HNF-multiplication and reciprocal-floor-sum computations establish zero incoming-strip values throughout that interval.`
- `research/SCOPE.md, Karpenkov arXiv:2101.12627v2 pages 2-3 and the complete edge classifier support the recurrence and scoped statement.`

Fact: The h=5, j=4 construction is impossible under the specified incoming and saturated-normalization conditions: a unimodular remainder frame and integral norm bound the admissible E range, and exact verification plus independent computations exclude incoming-strip values throughout that range. This exclusion does not resolve other boundaries or the original conjecture, and no admissible counterexample or all-level unbounded-digit certificate was obtained.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1900020

Evidence refs:
- `DERIVATION.md and fixed-order.json establish index 57804535277, fixed-basis unit invariance, and an admissible first-target seed.`
- `The pinned HNF rerun confirmed its unimodular matrix identity. A separate reciprocal floor-sum computation reproduced zero necessary successor pairs, supporting the universal two-target exclusion.`

Fact: For Lambda=Z[theta^16], with index 57804535277, h=5 and j0=4, an admissible first-target seed exists, but an exact level-5 norm/HNF argument excludes every two-target seed in the prescribed C_j,Z_j four-step family. An independent reciprocal floor-sum computation also found zero necessary successor pairs. This exclusion is restricted to that construction; it does not settle the original conjecture, and no infinite nonperiodic orbit was obtained.

## Source campaign: /home/argustest/zimo/counterexample-batch-1/campaigns/1900020

Evidence refs:
- `Independent execution of verify_arithmetic_correction.py recomputed true floors through state 91 and established contraction for every nonnegative nonzero weight on 88-to-91 and recovery on 85-to-91.`
- `research/routes/d229-amortized-height-escape/DERIVATION.md proves H(s)^2 <= Norm(x^2+y^2+z^2) <= 27 H(s)^2 and norm-one multiplier invariance.`

Fact: For the tested recurrence orbit, the return from state 88 to state 91 contracts every fixed diagonal quadratic form with nonnegative, nonzero weights, refuting the criterion requiring growth on every original section return from state 38. Recovery over states 85 to 91 shows that grouping returns can avoid this particular finite obstruction, but does not establish an all-future induction, infinite return coverage, or unbounded escape. Separately, the norm of x²+y²+z² lies between H(s)² and 27H(s)² and is invariant under norm-one multiplication.
