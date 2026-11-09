# Formal algebra and finite evidence

**Assessment: supported in the stated algebraic scope.** The unchanged source
compiled afresh, its axiom audit passed, and the exact Python and typed
Jacobian replays succeeded. None of these executions proves the geometric
finite-data theorem or a manuscript main theorem. Native independent
acceptance remains pending.

## Claim, attribution, and versions

This is Argus's algebraic extraction `C9000036-FROB`, latest version 4, from
the proof of `thm:finite-data` in the projective manuscript. That manuscript
is pinned by `../9100036/MANUSCRIPTS.json` to revision
`4eaee87548250b2682affda7d05d947c05554bae`. The old source, fidelity documents,
checker and certificates are inputs, not editable outputs.

The source contains 25 theorems and three definitions in `FrobeniusCore`.
Its current, review-local counterpart is
`replay/Main.lean`, recorded as `C9200036-ALG`. It is an unchanged copy, not a
new formalization or an additional mathematical result.

| Declaration group | Exact mathematical scope |
|---|---|
| `weight_reduction`, `reducedWeight`, `constant_weight_projection`, `coordinate_surjective` | Quotient/remainder powers in a commutative monoid; for positive natural `p`, the constant reduced coordinate selects precisely `p`-divisible weights; selecting a coordinate preserves an already given surjection. |
| `complement`, `complement_involutive`, `exponent_pair`, `degree_pair`, `truncated_rank`, `coordinate_exponent_sum` | Complementary exponents in `Fin n -> Fin p`, their degree pairing, cardinality `p^n`, and rational coordinate sums. This is character arithmetic, not a construction of bundles or Chern classes. |
| `jet_threshold` | For natural `n,k,p`, `k>0` and `p >= (2n+2)(k-1)` imply `(2n+1)(p-1) <= (2n+2)k floor(p/k)`. No primality assumption is needed. |
| `chord_step_identity`, `product_chord`, `explicit_uniform_error`, `explicit_rank_threshold` | A universal rational polynomial identity and a finite-product chord inequality for nonnegative rational factors; an explicit uniform `1/p` error and strict threshold for every rational `p>=1`. |
| `filtration_sum_bound`, `evaluation_dimension_bound`, `evaluated_filtration_dimension_bound` | Finite weighted sums and dimensions over any field, conditional on the specified injective linear maps. No geometric evaluation map is constructed. |
| `floor_count_factor`, `flagCount`, `flag_count_bound`, `rank_from_evaluations` | Exact integer evaluation counts and the bound `finrank(V) <= p^(2n) product_i(a_i+b_i/p)` from injections, `sum e_i=p^n`, `a_i>=0`, `b_i>=1`, and positive natural `p`. The numerical rank bound is derived, not an added axiom. |
| `product_mem_ideal_power`, `det_mem_power_of_columns`, `det_mem_power_of_rows` | In every commutative ring, entries in an ideal in each of a specified set of rows or columns force the determinant into the corresponding ideal power. No valuation, smooth point, or rank-reducing row operation is constructed. |
| `explicit_order_threshold`, `multiplicity_contradiction`, `finite_data_algebraic_obstruction` | Conditional rational scalar inequalities yield a contradiction. Their geometric rank and order hypotheses remain explicit interfaces. |

More precisely, put `A=product a_i`, `B=product(a_i+b_i)` and
`T(p)=product(a_i+b_i/p)`. The final theorem universally quantifies a finite
index set, nonnegative rational `a_i,b_i`, and rational
`p,epsilon,G,R,rho,nu`. Assuming

    p>=1, R>0, A<1/4, 80 epsilon<3/4,
    p>(B-A)/(1/4-A), p>2G/(3/4-80 epsilon),
    rho<=R T(p), R-rho<=nu,
    nu<=R(80 epsilon+2G/p),

it proves `False`. Here `G` denotes the source's scalar parameter `E`, to
avoid confusing the order error with the geometric rank error. The source
does not require `p` prime, nor does it quantify varieties, line bundles,
curves, sections, or a Frobenius morphism. The decisive final step is the
strict incompatibility `nu>3R/4` and `nu<3R/4`.

The fidelity document accurately states these domains and exclusions.
In particular, the determinant result is ideal-power membership; converting
it to order after residue-field row operations is prose geometry. The
filtration-to-product injection requires choices of linear splittings;
Lean assumes the resulting maps and their injectivity. This is not a
hidden proof of the existence of those maps.

The original `epsilon,r` may be real. The formal scalars are rational.
Strict real gaps allow a rational upper budget `eta>epsilon`; this may
increase the formal threshold. The exact original real-scalar threshold
is justified by the prose argument, not directly by this compilation.

## Fresh executions and their limits

The exact checker was inspected before execution. It uses standard-library
exact arithmetic, reads adjacent inputs, and writes no project files.
Its corruption tests modify in-memory copies only. The replay command was:

```bash
$WORKSPACE/argus-latest/.venv/bin/python -B \
  families/036/first-pass/frobenius_core/verify.py \
  --self-test
```

With CPython **3.13.5**, exit **0**, `replay/python_result.json` records:
five universal sparse-polynomial identities over the rationals; 73 basis
monomials in the five declared `(n,p)` cases; 78 frame-test executions;
625 two-by-two polynomial matrices, 516 with nonzero determinant; 80 nonzero
GF(3) tensors; two scalar fixtures; and all eleven corruptions rejected.
The frame tests are not exhaustive general linear groups or 78 independent
theorems. Exact polynomial expansion certifies the five identities
universally; the enumerations remain finite experiments.

The scalar fixtures use `(n,p)=(2,269)` and `(3,11)`, with thresholds 266 and
8 respectively. They are rational budget checks, not constructions of the
prohibited geometric data. The tensor experiment uses the unadapted bases
`(1+x,1+2x)` and `(1+y,1+2y)`. All displayed basis vectors have order zero,
but their spans contain `x` and `y`, and the tensor space contains `xy` of
order two. This rejects a tempting *replacement* argument using displayed
basis orders; it does not refute the manuscript's order-adapted argument.

The review-local Lean invocation was:

```bash
$WORKSPACE/argus-latest/.venv/bin/python \
  -m argus_skill.verticals.math.lean_evidence verify \
  research/draft_reviews/formal-algebra/replay/Main.lean \
  --statement-fidelity research/draft_reviews/formal-algebra/replay/statement_fidelity.md \
  --artifact-dir research/draft_reviews/formal-algebra/replay \
  --claim C9200036-ALG \
  --project-root campaigns/9200036 \
  --timeout 90
```

The real toolchain was **Lean 4.31.0**, commit `68218e876d2a38b1985b8590fff244a83c321783`,
**Lake 5.0.0-src+68218e8**, and **elan 4.2.3**. The prebuilt workspace was
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`; no new Lake project
or dependency installation was used. Both compilation and the independent
axiom-audit command exited **0**, with `proof_holes=[]`, empty diagnostics
and no environment failure. Recorded duration was 20,702 ms.

The official result and source/fidelity hashes are in `replay/lean_check.json`.
The archived certificate is
`replay/certificates/C9200036-ALG-28019a08f2ffe6d6.json`. Its source and
fidelity hashes equal those of the old successful certificate. Neither
input was edited during or after the run. The trusted boundary includes
Lean's kernel, the installed Mathlib environment and its standard logical
axioms; the audit does not mean that no classical reasoning was used.
The source introduces no geometric axiom.

## Jacobian: one bounded typed operation

Current discovery returned five candidate operations. The exact typed
contract for `prime_field.matrix.rank.compute` was inspected before one
execution through the required isolated adapter:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.tools.jacobian run \
  --operation prime_field.matrix.rank.compute \
  --payload-file research/draft_reviews/formal-algebra/replay/jacobian_rank_payload.json
```

The dedicated JSON payload is exactly

```json
{"matrix":{"prime":3,"columns":7,"entries":[[1,0,0,1,0,0,1],[0,1,0,0,1,0,0],[0,0,1,0,0,1,0]]}}
```

The typed output, preserving that source matrix, is in
`replay/jacobian_rank_result.json`: prime **3**, rank **3**, server
**Jacobian 0.14.0**, protocol **2025-11-25**, transport `mcp-stdio`,
reported operation runtime **1 ms**. Adapter exit was **0**; no structured
error, timeout, transport failure, or incomplete result occurred.
The first three columns form the identity, and there are only three rows.
This is a finite torus-quotient illustration, not evidence about all
characteristics, slopes, or vector-bundle filtrations.

The old discovery records and the unused symbolic determinant contract
were also inspected. The latter is a bounded rational-function operation
over `QQ`, not arbitrary local rings in varying characteristic. No
determinant execution is recorded or inferred from its contract.

## Supersession, external assumptions, and final scope

The old claim has four versions, not four results. Version 1 has no formal
statement; version 2 first records universal algebra; version 3 adds exact
evaluation counts and rank derivation from injections; version 4 corrects
the formal source while retaining version 3's natural statement.
Certificates `f0ee25c8d529ecdd` and `30dd06f7c45e2a2c` bind versions 2 and
3 respectively and record compiler type errors, exit 1, with no successful
axiom audit. They are superseded development failures, not refutations.
Certificate `7aac2d34fd95560e` binds version 4 and records success.

The uppercase/lowercase fidelity documents are identical copies;
`lean_check.json`, the successful certificate and `compile.log` describe
the same old run. Historical `reviewer:41e8b874f58e` supported that algebra
certificate. That is stronger prior evidence than the report's stale
pending-review prose, but it does not accept this review.

No specialized external geometric result is assumed by these Lean
declarations. Langer, spreading, Quot schemes, global Frobenius filtration,
flag injections and external-product orders belong to the separate
geometric unit. The old bounded-only proof route was correctly retired:
finite outputs cannot settle those universal geometric obligations.

This is a faithful extraction and certification of standard algebra plus
finite adversarial tests. Novelty is not established or needed for its
supported scope. The mathematical strength has not increased over the old
successful source; the fresh run establishes current reproducibility and
preserves the certification boundary.
