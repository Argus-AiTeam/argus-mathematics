<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="assets/brand/argus-logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="assets/brand/argus-logo-light.svg">
    <img src="assets/brand/argus-logo-dark.svg" width="420" alt="Argus">
  </picture>
</p>

<h1 align="center">Argus Mathematics</h1>

<p align="center">
  Mathematical results produced by the <b>Argus</b> autonomous research agent<br>
  <a href="README.zh-CN.md">中文</a> ·
  <a href="openai-math/">OpenAI collection</a> ·
  <a href="open-problems/">Open-problem packages</a> ·
  <a href="https://github.com/Argus-AiTeam/argus-counterexample-runtime">Runtime</a>
</p>

## Contents

| Collection | What it contains | Start here |
| :--- | :--- | :--- |
| **[`openai-math/`](openai-math/)** | Argus applied to all 373 result families of OpenAI's [`openai/math`](https://github.com/openai/math) collection (721 manuscripts). Every claim was verified against the source. Three categories: **improvements** over OpenAI's stated results in 142 families (63 with the key step independently checked); **errors found**: 3 minor issues, no mathematical error; **verification** of OpenAI's results in 229 families. | [Report](openai-math/README.md) · [报告](openai-math/README.zh-CN.md) · [Family index](openai-math/INDEX.md) |
| **[`open-problems/`](open-problems/)** | 84 result packages on open problems and conjectures. Each package has a technical report (PDF + TeX) and certificates or verifiers. | [Catalog](open-problems/README.md) · [目录](open-problems/README.zh-CN.md) · [`results.json`](open-problems/results.json) |

## Headline results on the OpenAI collection

| Family | Result |
| :--- | :--- |
| [`127`](openai-math/families/127/) | Average sensitivity of polynomial threshold functions: OpenAI's main theorem `I(f) ≤ 8d√n` improves to **`4d√n`**, and the coupling constant 4 is optimal. |
| [`332`](openai-math/families/332/) | Metric Markov cotype of ℓ₁: OpenAI's `N₂(ℓ₁) ≤ 12√21` improves to **`6√14`**, and the flatness constant 18 is optimal. |
| [`175`](openai-math/families/175/) | Rounding: OpenAI's main constant `25·512⁴` improves to **`25·96⁴`**. |
| [`318`](openai-math/families/318/) | Chromatic splitting: OpenAI leaves open whether weak chromatic splitting holds at height 3; combining two OpenAI theorems shows **it fails at p = 5**. This needs expert review. |
| [`374`](openai-math/families/374/), [`363`](openai-math/families/363/), [`028`](openai-math/families/028/), [`039`](openai-math/families/039/) | Optimal constant 1 instead of 162; 3 gains suffice instead of 5 (optimal); one factor `d` removed from an exponent; condition `dw<1/16` relaxed to `dw<1/3`. |

The full list is in the [report](openai-math/README.md#3-improvements-over-openais-stated-results), and every item is in [`verification.json`](openai-math/verification.json).

## Repository layout

```
openai-math/
  README.md, README.zh-CN.md   report
  INDEX.md                     373-family index with results
  families/NNN/                Argus drafts per family (first-pass/, argus-review/) + README
  verification.json            item-by-item verification (baseline, check, verdict)
  ledger.json                  per-family ledger
open-problems/
  README.md, README.zh-CN.md   catalog of the 84 packages
  <ID>/                        one package per result (report PDF/TeX, certificates, verifiers)
  results.json, usage-audit.json, docs/
scripts/verify_artifacts.py    checks every file against SHA256SUMS
```

## Verify

```bash
python -m pip install -r requirements.txt
python scripts/verify_artifacts.py
```

## Rights

Copyright © 2026 Argus AI Team. See [LICENSE](LICENSE) and [CITATION.cff](CITATION.cff). Lean code ported from OpenAI's repository remains under its Apache-2.0 license.
