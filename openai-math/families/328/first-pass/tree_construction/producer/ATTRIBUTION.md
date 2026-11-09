# Producer library provenance

The `OAI/` Lean sources are a compatibility port of the producer-side transitive
import closure of `lean/OAI/Analysis/Nonexpansive/TreeProducer.lean` from
[OpenAI's `openai/math`](https://github.com/openai/math), pinned at commit
`4eaee87548250b2682affda7d05d947c05554bae` (2026-10-30).
They remain under the upstream Apache License, Version 2.0. The complete upstream
license and any upstream notice are retained in `upstream/`; original file
headers are retained. The unmodified retrieved source files are also retained
under `upstream/lean/`.

`source_manifest.json` records every fetched module, its direct imports, and the
SHA-256 of its pinned upstream source. No other upstream source closure is
included. Local modifications are limited to compatibility with Lean/Mathlib
4.31.0 and are recorded separately in `PORTING.md`.

This port claims no mathematical novelty. Compiler results refer to the local
ported sources, not to the presence of upstream sources or upstream artifacts.
