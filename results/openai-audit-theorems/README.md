# First-pass artifacts from Argus's work on `openai/math`

This directory holds raw first-pass artifacts for 28 of the 373 families: Argus proof graphs (`PROOF_GRAPH.json`, `MATH_STATE.json`), drafts, verifiers and Lean sources. They are exploratory working material, not reviewed findings.

- `refutes` verdicts inside these files refute statements that **Argus itself proposed**: shortcuts, extensions and test claims. They are not errors in OpenAI's manuscripts. See [`docs/openai-claims-checked.md`](../../docs/openai-claims-checked.md).
- Each Lean file checks a delimited core lemma. Its scope is stated in the accompanying `statement_fidelity.md`.
- For which results the systematic review supports, see [`docs/openai-math-audit-findings.md`](../../docs/openai-math-audit-findings.md), §3.

---

本目录收录 Argus 对 `openai/math` 第一轮工作中，373 个家族里 28 个家族的原始材料：论证图（`PROOF_GRAPH.json`、`MATH_STATE.json`）、底稿、验证脚本和 Lean 源码。这些是探索性的工作材料，不是经过审查的结论。

- 文件中的 `refutes` 判定，反驳的是 **Argus 自己提出**的捷径、推广和测试命题，不是 OpenAI 论文的错误。详见 [`docs/openai-claims-checked.zh-CN.md`](../../docs/openai-claims-checked.zh-CN.md)。
- 每个 Lean 文件只验证划定好的一个核心引理，范围写在随附的 `statement_fidelity.md` 中。
- 哪些结果得到了系统复核的支持，见 [`docs/openai-math-audit-findings.zh-CN.md`](../../docs/openai-math-audit-findings.zh-CN.md) §3。
