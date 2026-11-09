# Exact examples and bounded computations

**Assessment:** the supplied exact calculations replay successfully. They establish the listed examples and symbolic identities, not the center-independent density theorem, general curve inequality, or eventual interpolation.

## Inputs, provenance and replay

The examples are old Argus constructions in A04 section 7 and A05 `exact_certificate.json`; their original comparison theorem is OpenAI's September 24, 2026 manuscript at revision `4eaee87548250b2682affda7d05d947c05554bae`. A29 `verify.py` was read in full before execution. Current claim: `C_EXACT_EXAMPLES_017`.

The unchanged old checker was run read-only using `$WORKSPACE/argus-latest/.venv/bin/python -B` (Python 3.13.5), exit **0**. Its actual JSON output is [replay.json](replay.json). The script uses exact `Fraction` arithmetic and its own polynomial operations, not floating-point numerical ranks. It checks three configurations, two parametrized curves, the inadmissible flat obstruction, 30 finite local-count cases, the old Jacobian payload/output, and the binding of the **historical** Lean result. This last step is not a fresh compiler invocation; the separate Lean unit supplies that.

## Every configuration and curve

All configurations use `m=2`, `w0=1`, `v0=2`, `sigma=1/100`, `w1=4000000`, `w2=100000000000000`, `L0=4`, `C*=640000`.

| Configuration | Exact hypotheses checked |
|---|---|
| `(1,0,0),(1,3,6)`, `theta=3/5` | Coordinatewise distinct, original ambient ratio `9/25` and one-fiber ratio `18/25`; flat occupancies `(1,1,2)`. All original sigma slack conditions hold. |
| `(1,i,j)`, `i,j` in `{0,1}`, `theta=2/5` | Occupancies `(2,2,4)` and ambient ratio `8/25`; satisfies extension density slack but fails original coordinatewise distinctness. |
| `(1,0,0),(1,1,1),(2,0,0)`, `theta=3/5` | Occupancies `(1,1,2)`, ambient ratio `27/50`; original total single-fiber comparison is `27/25>1`, and the original Y=1 condition fails. This is an extension example, not an original-theorem counterexample. |

For each configuration the code enumerates **all six** oriented equal-cardinality subset pairs: singleton pairs `(1,0),(2,0),(2,1)`, and pairs `({0,2},{0,1}),({1,2},{0,1}),({1,2},{0,2})`. The minimum ratio is `1200000` at `theta=3/5` and `800000` at `theta=2/5`, both larger than `C*`. This verifies these numerical weights, not the existence of successive thresholds in all dimensions.

For the nodal curve

    Y=1, X1=s^2-1, X2=s(s^2-1),

the identity `X2^2=X1^2(X1+1)` and rational inverse `s=X2/X1` identify the function field and normalization parameter. At `(1,0,0)`, the polynomial gcd is `s^2-1`: both `s=-1` and `s=1` occur, each with orders `(infinity,1,1)`. At `(1,3,6)`, the gcd is `s-2`, giving the third branch and the same orders. These gcds exhaust all complex preimages, not merely rational points searched. Polynomial coordinates have their only pole at infinity, of orders `(0,-2,-3)`. Consequently

    D=1/2000000,  S=9/500000000000000.

For

    Y=1+s, X1=s, X2=s-s^2/2,

the inverse is `s=Y-1`. At the first center, `t=s`, `X1-log(1+s)` starts with `s^2/2`, and `X2-log(1+s)` starts with `-s^3/3`: the exact orders are `(1,2,3)`. The second center has no preimage. Infinity is the only pole, with coordinate orders `(-1,-1,-2)`, so `D=1` and `S=9/500000000000000`.

The code truncates logarithmic series at degree 8 but demands an actually nonzero coefficient for each claimed finite order. It permits infinite order only when the coordinate and the logarithmic displacement are identically zero. Therefore it does not mistake a zero finite Taylor truncation for infinite contact. Both curves satisfy the reported inequality with large slack; they give no evidence about sharpness.

## Jacobian: generic rank and specialization

The old request/response are A06/A07. A small live discovery was followed by inspection of `matrix.symbolic.rank.compute`, whose typed contract accepts a nonempty rectangular matrix of at most eight rows/columns over an explicitly ordered rational-function field, with canonical sparse rational numerator/denominator entries. Exactly one bounded replay was then executed through the mandated isolated adapter:

    $WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.tools.jacobian run

The exact payload is [jacobian/payload.json](jacobian/payload.json), copied without alteration from A06; the full typed response is [jacobian/response.json](jacobian/response.json). Server **0.14.0**, protocol **2025-11-25**, operation `matrix.symbolic.rank.compute`, returned `{"method":"EXACT_SYMBOLIC_ROW_REDUCTION","rank":2,"pivot_columns":[0,1]}` over `QQ(y,b,c)`, runtime 22 ms, adapter exit 0. There was no structured error, timeout, incomplete output or UNKNOWN.

The columns are `(y,1,1)`, `(0,1,0)`, `(yc,b,c)`. The third is `c` times the first plus `(b-c)` times the second, and the two-column minor in the last two rows is the constant `-1`. The checker verifies these polynomial identities independently. Generic rational-function rank alone would not establish every specialization; the polynomial relation and constant minor do so here. Neither argument proves a curve-valuation or sheaf-cohomology statement.

## What remains finite

Six positive cost vectors, in dimensions 1-3, at five thresholds give the **30** strict lattice-count regressions. They cannot prove the universal volume inequality; that is established by the cube argument in the multiplicity unit. Likewise the grids only check occupancy hypotheses, not all degrees of their interpolation maps. A05's historical `new_reduction`/`publishable` labels are not outputs justified by this finite checker.

There are no external geometric assumptions in these arithmetic examples. The exact live and historical outputs support only this scoped computation unit. Native independent replay remains required.
