<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/brand/argus-logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/brand/argus-logo-light.svg">
    <img src="assets/brand/argus-logo-dark.svg" width="420" alt="Argus">
  </picture>
</p>

<h1 align="center">Argus Mathematics</h1>

<p align="center">
  <b>Argus</b> 自治研究智能体产出的数学成果<br>
  <a href="README.md">English</a> ·
  <a href="openai-math/">OpenAI 论文集</a> ·
  <a href="open-problems/">开放问题成果包</a> ·
  <a href="https://github.com/Argus-AiTeam/argus-counterexample-runtime">运行时</a>
</p>

## 内容

| 部分 | 内容 | 入口 |
| :--- | :--- | :--- |
| **[`openai-math/`](openai-math/)** | 用 Argus 处理 OpenAI [`openai/math`](https://github.com/openai/math) 论文集的全部 373 个结果家族（721 篇论文），每条结论都对照原文核查过。结果分三类：**改进**，142 个家族对 OpenAI 原文结论有改进，其中 63 个家族的关键一步经过独立验证；**挑错**，找到 3 处小问题，没有数学错误；**复核**，229 个家族独立复核了 OpenAI 的结果。 | [报告](openai-math/README.zh-CN.md) · [Report](openai-math/README.md) · [家族索引](openai-math/INDEX.md) |
| **[`open-problems/`](open-problems/)** | 84 个关于开放问题和猜想的成果包，每个包都有技术报告（PDF + TeX），以及证书或验证脚本。 | [目录](open-problems/README.zh-CN.md) · [Catalog](open-problems/README.md) · [`results.json`](open-problems/results.json) |

## OpenAI 论文集上的重点成果

| 家族 | 结果 |
| :--- | :--- |
| [`127`](openai-math/families/127/) | 多项式阈值函数的平均敏感度：OpenAI 主定理 `I(f) ≤ 8d√n` 改进为 **`4d√n`**，耦合常数 4 是最优的 |
| [`332`](openai-math/families/332/) | ℓ₁ 的度量 Markov 余型：OpenAI 的 `N₂(ℓ₁) ≤ 12√21` 改进为 **`6√14`**，平坦性常数 18 是最优的 |
| [`175`](openai-math/families/175/) | 舍入：OpenAI 的主要常数 `25·512⁴` 改进为 **`25·96⁴`** |
| [`318`](openai-math/families/318/) | 色分裂：OpenAI 把"弱色分裂在高度 3 是否成立"留作未解问题。结合 OpenAI 的两个定理可以推出，**它在 p = 5 时不成立**（仍需专家审阅） |
| [`374`](openai-math/families/374/)、[`363`](openai-math/families/363/)、[`028`](openai-math/families/028/)、[`039`](openai-math/families/039/) | 常数从 162 降到最优的 1；gain 次数从 5 降到 3（最优）；指数中去掉一个 `d` 因子；条件从 `dw<1/16` 放宽到 `dw<1/3` |

完整列表见[报告](openai-math/README.zh-CN.md)，每一条的核查记录见 [`verification.json`](openai-math/verification.json)。

## 目录结构

```
openai-math/
  README.md, README.zh-CN.md   报告
  INDEX.md                     373 个家族的索引及结论
  families/NNN/                各家族的 Argus 底稿（first-pass/、argus-review/）及说明
  verification.json            逐条核查记录（原文出处、核查方式、结论）
  ledger.json                  各家族台账
open-problems/
  README.md, README.zh-CN.md   84 个成果包的目录
  <ID>/                        每个结果一个包（报告 PDF/TeX、证书、验证脚本）
  results.json, usage-audit.json, docs/
scripts/verify_artifacts.py    按 SHA256SUMS 校验每个文件
```

## 校验

```bash
python -m pip install -r requirements.txt
python scripts/verify_artifacts.py
```

## 版权

Copyright © 2026 Argus AI Team。详见 [LICENSE](LICENSE) 和 [CITATION.cff](CITATION.cff)。从 OpenAI 仓库移植的 Lean 代码仍适用其 Apache-2.0 许可。
