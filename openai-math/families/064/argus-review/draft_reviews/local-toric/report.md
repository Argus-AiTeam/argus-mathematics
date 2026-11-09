# Engineer old-draft review: local-toric

**Status:** review-ready; exploratory; independent acceptance remains
`pending_native_reviewer`. This is a reproduction of existing work, not new
mathematics or an independent Reviewer judgement.

## Exact source, claim and hypotheses

Source workspace:
`campaigns/9000064`.
The reference manuscript revision is
`4eaee87548250b2682affda7d05d947c05554bae`; no manuscript passage was needed or
read for this bounded calculation.

The old ledger's `C_LOCAL_TORIC_064`, version 1, has statement hash
`4904509ffea627a93d9421cb63e9620f8488f8acd184b268c9f3bac53878c428`:

> For coefficients (2,2,3) and exponent 6, the normalized vertical orthant has
> lattice index 6 and initial cone index 3. Inserting rays (2,1,0) then (1,2,0)
> gives exactly three unimodular cones, each with vertical height one. This is
> one exact local calculation, not a counterexample or verification of
> prop:log-model.

Precisely, fix
`L = {v in Z^3 : 2v1 + 2v2 + 3v3 = 0 modulo 6}`,
the nonnegative orthant, and the integral-on-`L` height
`h(v) = (2v1 + 2v2 + 3v3)/6`. Use the initial rays
`r1=(3,0,0)`, `r2=(0,3,0)`, `r3=(0,0,2)`, with star insertions
`u=(2,1,0)` and then `v=(1,2,0)`. These fixed arithmetic data, not a
mu-constant hypothesis, supported resolution, or MMP existence theorem, are
the hypotheses of the checked example.

The substantive sources are `research/log-model-audit/verify.py`
(SHA-256 `dac10a34b9dd2492e30c5ef09a4290432db2ac2da34cebe06a1603adeeb36e39`)
and `exact_certificate.json`
(`259950cb50f91d8df79cb89813bf50f330b3080f1cf51b76ea93a01235a27d66`).
All seven requested artifacts were read:

| Old artifact | Assessment and role |
| --- | --- |
| `verify.py` | Exact integer/Fraction assertions for this certificate, its two subdivisions, and saved Smith transformations; not a universal checker. |
| `exact_certificate.json` | Consistent finite data with an explicit local-only scope. Its global MMP warning is not an assumption needed for this finite result. |
| `jacobian_adapter_status.json` | Historical exit 0, operation ID, and 45-second bound; not evidence of present availability. |
| `jacobian_contract.json` | Historical read-only, transformation-certified Smith operation, bounded to 16 by 16 input matrices. |
| `jacobian_discovery.json` | Historical three-candidate discovery; not a theorem or a current probe. |
| `jacobian_payload.json` | The exact integer matrix `A` below, with string-valued entries and domain `ZZ`. |
| `jacobian_result.json` | Saved full Smith transformations; their identities can be checked without trusting a historical server connection. |

Per the parent's index, the checker and exact certificate are manifest-covered;
the five historical Jacobian records have measured workspace hashes, not
invented snapshot provenance. `replay/source_integrity.json` records all seven
source hashes, their agreement with that index, and unchanged before/after/final
hashes. The snapshot/archive was not modified or independently re-audited here.

## Decisive finite arithmetic

The congruence map has image of order
`6/gcd(6,2,2,3)=6`. The proposed basis columns
`(1,-1,0), (0,3,0), (0,0,2)` have weighted sums `0,6,6` and determinant `6`.
They lie in `L` and therefore form a basis of this index-six lattice.
Writing the initial rays in that basis gives

```text
A = [[3,0,0], [1,1,0], [0,0,1]],  det(A)=3.
```

The initial ambient determinant is `18`, so its index relative to `L` is
`18/6=3`, not 18. The first insertion has initial barycentric coordinates
`(2/3,1/3,0)` and splits the cone into relative indices `2` and `1`.
For the index-two cone `(u,r2,r3)`, the second insertion has coordinates
`(1/2,1/2,0)`; in the other cone `(r1,u,r3)` its coordinates are
`(-1,2,0)`, so that cone is unaffected. The final maximal cones are exactly

```text
(r1,u,r3), (u,v,r3), (v,r2,r3).
```

Each has ambient determinant `6` and relative index `1`; their relative
indices sum to the initial index `3`. These are unimodular cones in `L`.
The complete nonnegative height-one set is

```text
(0,0,2), (0,3,0), (1,2,0), (2,1,0), (3,0,0).
```

All five ray heights are exactly `1`. Integrality of `h` on `L` also makes
these height-one rays primitive in `L`. Thus the associated vertical
multiplicities are all one. The copied checker verifies the actual fan
subdivisions and compares the final cone set without imposing certificate
list order; this is stronger than merely matching cone counts.

## Real checker replay and side effects

Before execution, source inspection found only four JSON reads relative to
`Path(__file__).resolve().parent`, computations/assertions, and one stdout
print. There is no file-writing or certificate-generation code.
Only the unmodified checker and its four necessary inputs were copied to
`replay/checker/`; discovery and contract records are not checker inputs.
From the project cwd the exact checker command was:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python research/draft_reviews/local-toric/replay/checker/verify.py
```

With an outer 30-second bound, it exited **0** in approximately **0.025 s**.
Stderr was empty. Its complete newly generated output, retained verbatim in
`replay/checker_stdout.json`, was:

```json
{"height_one_points": 5, "initial_cone_index": 3, "jacobian_smith_replayed": true, "regular_final_cones": 3, "result": "PASS", "result_class": "finite_verification", "scope": "one local toric chart, not prop:log-model"}
```

`replay/semantic_comparison.json` compares every summary field with the
preserved certificate and records the recomputed determinants, heights,
height-one enumeration and insertion coordinates. The comparison passes.
There is **no newly generated exact certificate**: stdout is a summary, not
another certificate schema. All five copied files remained byte-identical,
and no file appeared in the checker directory. All seven original files
remained unchanged. Capture files were written separately in this owned unit.
The exact command, bounds, exit and directory observations are in
`replay/checker_run.json`; raw stderr is `replay/checker_stderr.txt`.

The checker replays *saved* Jacobian transformations. Its PASS alone cannot
establish that Jacobian is currently available.

## Separate current isolated-adapter probe

CLI help was inspected first. Discovery returned only three candidates; the
current typed contract for `matrix.normal_form.smith.certified.compute` was
then inspected **before** the single mathematical run. Its exact integer,
full-basis transformation contract is suitable for the same `3 x 3` matrix
`A`, unlike a diagonal-only result. Input and output were additionally
validated against the inspected JSON schemas using
`jsonschema.Draft202012Validator` 4.26.0.

Exact substantive commands, again from the project cwd, were:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian find --query 'certified Smith normal form full unimodular transformations integer matrix' --limit 3
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian inspect --operation matrix.normal_form.smith.certified.compute
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run --operation matrix.normal_form.smith.certified.compute --payload-file research/draft_reviews/local-toric/replay/jacobian_payload.json --timeout 45
```

Each adapter process had a separate 60-second outer bound. Exactly **one**
mathematical operation was run; no direct Jacobian import, irrelevant fallback,
dependency installation, background shell, or durable runner was used or
needed. The payload is a dedicated JSON, byte-identical to the historical
payload, SHA-256
`b53c59451d0cafcb5949dac190e6174656232ff0875771abbca48b534df008e7`.

The fresh response reports **Jacobian 0.14.0**, MCP protocol
**2025-11-25**, transport **mcp-stdio**, adapter exit **0**, empty stderr,
no adapter/transport error, and no timeout. The mathematical run took
approximately **3.191 s** externally; the server reports `runtime_ms=1`.
Its output is `EXACT_INTEGER` and `FULL_MATRIX_TRANSFORMATIONS`:

```text
U = [[0,1,0], [0,0,1], [1,-3,3]]
V = [[1,-1,1], [0,1,-1], [0,1,0]]
U A V = diag(1,1,3),  det(U)=det(V)=1,  rank(A)=3.
```

The entire typed mathematical output equals the historical typed output;
runtime/request envelopes are not mistaken for mathematical content.
`replay/jacobian_verification.json` records schema validation and direct
integer checks of the source matrix, transformation identity, determinants,
rank and invariant factors. Current discovery, contract, exact payload,
typed result, and structured exit/error/timeout/transport observations are
retained as their separately named JSON files in `replay/`. Raw stderr files
are retained even when empty. Current success establishes only this bounded
operation's availability at the recorded time, not universal availability.

Both interpreters are **CPython 3.13.5**, Anaconda build, GCC 11.2.0, with
assertions enabled and optimization level zero. Both report **argus-skill
0.1.2** and **Pydantic 2.13.4**; the latest checker environment reports
**MCP 1.29.1**, while the required live-update adapter reports **MCP 1.29.0**.
Exact executable paths, build strings, version-query commands and validation
versions are in `replay/toolchain.json`. Bytecode writing was disabled.

## Attribution, open status and limits

This example belongs to the old Argus Engineer draft
(`engineer:gpt-6.1-sol`). The inherited independent judgement
`judgement-C_LOCAL_TORIC_064-148da9d4622d`, by
`reviewer:gpt-6.1-sol:e8b2ab07d537`, already **supports** this exact claim hash
and `research/log-model-audit/exact_certificate.json`. The source identity
and successful replay are compatible with that judgement, which is reused,
not presented as new independent acceptance.

No concrete arithmetic defect or unresolved local computational obligation
was found. The old proof graph's `open` label is retained as historical
metadata, not treated as overriding the claim-specific supporting judgement.
The work is a reproduction, with no novelty asserted and no claimed new
priority result; overall `novelty_status=not_applicable`.

No Lean source, formal statement or Lean certificate exists in this listed
draft, and **no Lean compiler was run**. Integer/Fraction Python assertions
and a checked typed Smith certificate are not a kernel proof of universal
geometry. This result proves neither a general subdivision theorem nor
global marking/gluing/projectivity, supported resolution, MMP existence or
termination, `prop:log-model`, or a manuscript counterexample. In particular,
the certificate's unresolved global MMP warning remains outside this unit;
the fresh adapter call does not close it. Native independent review of the
whole old-draft review is still pending.
