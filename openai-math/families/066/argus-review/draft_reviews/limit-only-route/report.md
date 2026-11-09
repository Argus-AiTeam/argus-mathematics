# The retired limit-only route

**Assessment:** the inference from a small defect to exact containment
is invalid. Its retirement is justified. This rejects an attempted
proof route, not a manuscript assertion.

## Exact object being assessed

`R_LC_LIMIT_ONLY` targets `C_LC_EXACT_BRIDGE`, with obligation
`L_LC_SUBLEVEL`. It is recorded in both old ledger and graph;
`verification.md:59-65` gives its reason for retirement:

> The bound e(lambda)=O(lambda) permits e(lambda)=lambda>0 and cannot
> establish exact containment.

There is no separate mathematical claim ID for this route, so it
must not be lost by treating the 15 claim IDs as a draft-unit count.
Nor is it another copy of the successful scalar strict-comparison proof.

## Decisive argument and supported conclusion

The premise `0<=e(lambda)<=C*lambda` for all small positive
`lambda` is compatible with `C=1` and `e(lambda)=lambda`.
The defect then tends to zero but is never zero at a positive
parameter. This exact countermodel refutes the logical inference.
It is not a construction of valuations violating either paper.

Similarly, limiting a sequence of finitely generated ordinary
minimizers would not by itself establish finite generation of an
unidentified constrained limit. The successful route instead proves
a strict fixed-parameter inequality and identifies a constrained
valuation with an **actual** ordinary klt minimizer.

Both manuscripts explicitly distinguish convergence from exact
realization. The failed inference is attributed to the old Argus
route, not to them. No external theorem, Lean compilation, finite
enumeration or new search is needed to check this countermodel.

## Status and reuse

The old graph marks this route ruled out, consistently with the
ledger's explicit retirement reason. The active review ledger
records the same obstruction in `R_OLD_LIMIT_ONLY`; it is not
reopened. The full exact-containment goal is not refuted by
retiring this route, because a different route supplies the
strict comparison.

There is no unresolved question about the insufficiency of the
displayed premise. Whether particular geometrically defined
defects vanish needs additional information, supplied in the
other units rather than inferred from this countermodel.
This elementary logical observation has no claimed novelty.
