# Uniform interval gap: assessment

## Disposition and claim

**Supported, including sharpness within the stated width-restricted class.**
Coverage, the uniform gap and the affine optimality certificate have both
mathematical proofs and fresh mechanical corroboration. They do not establish
an optimal analytic moment saving or a novelty claim.

The source is the old Argus report's Theorem 2 and Section 6, in
`families/023/first-pass/exceptional_moments`.
Its three formal declarations are `multiple_in_uniform_interval`,
`uniform_gram_gap`, and `interval_gap_optimal` in `Main.lean`.
They are part of the old `C_EXPONENTS` source family, not three independent
experiments or externally attributed theorems.

Precisely:

* For every real `a` with `0<a<=1/2`, there is a natural `k` with
  `7/5 <= k*a < 19/10`.
* For every real `z in [7/5,19/10]`,

  ```
  max(z-2/3, (z+max(1,2-2*z/3)-2/3)/2)
      <= 2*z/3 - 1/30.
  ```

* If real interval endpoints `l,u` and a proposed common gap `g` obey
  `u-l>=1/2`, `u+3*g<=2`, and `-3*l+6*g<=-4`, then `g<=1/30`.
  The pair `l=7/5,u=19/10` attains `g=1/30` for both actual gap
  functions. This yields the claimed optimality among intervals of width
  at least `1/2` on which the actual two gaps are at least `g`.

The last interpretation requires the short argument below translating actual
endpoint gaps into the affine constraints. The Lean declaration directly
proves the constrained implication, not a theorem quantifying over an undefined
predicate called "covering interval." Width at least `1/2` is a sufficient
coverage mechanism; no necessity or optimality over all narrower
integer-multiple-covering sets is asserted.

## Decisive mathematical proof

For coverage, take `k=ceil((7/5)/a)`. The ceiling bounds give
`7/5 <= k*a < 7/5+a <=19/10`. Division and multiplication use `a>0`;
the claim does not include `a=0`. There is no uniform bound on `k` as
`a` tends to zero without the additional fixed-degree hypothesis.

Subtracting the two exponents from the target `2*z/3` gives

```
diagonal gap       D(z) = (2-z)/3
off-diagonal gap   O(z) = (3*z-4)/6   if z<=3/2
                         (z-1)/6     if z>=3/2.
```

The two off-diagonal branches agree at `z=3/2`, with value `1/12`.
On `[7/5,3/2]` the smallest off-diagonal gap is `1/30`, at `7/5`.
On `[3/2,19/10]` it is at least `1/12`.
The smallest diagonal gap is `1/30`, at `19/10`.
This proves the bound on the entire closed interval and identifies the
two endpoint obstructions. Sampling interior points is unnecessary.

For sharpness first consider an interval with an actual common gap
`g>0` and width at least `1/2`. The diagonal constraint at `u`
gives `u+3*g<=2`, hence `u<2` and `l<=u-1/2<3/2`.
Thus the lower off-diagonal branch really applies at `l`, and
`O(l)>=g` gives `-3*l+6*g<=-4`. If `g<=0`, the desired
upper bound is immediate.

Put all three constraints in `<=` form:

```
 l - u       <= -1/2
     u + 3*g <=  2
-3*l   + 6*g <= -4.
```

Multiplying respectively by `1/5`, `1/5`, `1/15` and adding cancels
`l,u` and gives `g<=1/30`. All multipliers are nonnegative.
At `(l,u,g)=(7/5,19/10,1/30)` these rows are tight, and the actual
high-branch constraint is also satisfied. Consequently the claimed
width-restricted optimum, not merely an LP relaxation bound, is attained.

## Typed computation, failures and fresh replay

The historical discovery and contract files concern
`optimization.linear.rational_general_optimum.compute`.
The original `jacobian_payload.json` was refused at operation validation:
`INVALID_REQUEST`, stage `operation_validation`, code
`general_linear_program.normalization_admission`; normalization would
exceed the declared simplex-basis admission limit. Its adapter exit was `2`.
This is not infeasibility or a failed mathematical claim.

The smaller `jacobian_gap_payload.json` expresses the three-variable
closed rational optimization above, with additional nonnegative lower bounds
on all three variables. Those bounds do not remove its attained optimum;
the hand dual argument proves the upper bound without them.
The inherited successful output and
the rational dual certificate are different presentations of the same
calculation, not independent analytic results.

For this review a small discovery search was made and the exact typed contract
of the general-form operation was inspected. The neighboring standard-form
operation was inspected but not executed or forced onto the problem.
Exactly one current mathematical operation was then run through the isolated
Argus adapter:

```
$WORKSPACE/argus-live-update/.venv/bin/python \
  -m argus_skill.tools.jacobian run \
  --operation optimization.linear.rational_general_optimum.compute \
  --payload-file research/draft_reviews/jacobian_gap_payload.json
```

The exact payload is a byte-identical copy of the old successful payload.
The response reports Jacobian server **0.14.0**, protocol **2025-11-25**,
and typed status **OPTIMAL**, with primal point
`(7/5,19/10,1/30)`. Adapter exit is `0`, no timeout occurred
(explicit bound 110 seconds), and no structured adapter error was returned.
The payload, full typed response and measured invocation status are preserved
separately in `../jacobian_gap_payload.json`,
`../jacobian_gap_output.json`, and `jacobian_replay_invocation.json`.
No Jacobian package was imported into the Argus environment.

The unmodified copied `../verify.py` independently checks exact rational
primal feasibility, row/bound dual signs, complementary slackness,
stationarity, payload binding, server/protocol binding and strong duality.
Its default full replay exited `0`; result: `../verification_result.json`.
Thus solver trust is not needed for this particular optimum.

The same Lean run described in `../universal-exponents/report.md` freshly
compiled all three declarations with Lean 4.31.0, using the prebuilt
Mathlib workspace, compiler and audit exits `0`, and no proof holes.
The certificate is
`../certificates/C_EXPONENTS-17c57f67c7fcda79.json`.
No duplicate compiler run was made just to attach another status label.
Compilation establishes the encoded real implications; the branch/interval
interpretation above is a separate mathematical reading.

## Attribution, dependencies and limits

The interval argument and hand dual certificate are in the old Argus draft.
The report presents them as a quantitative replacement for its account of a
qualitative manuscript choice `4/3<z<2`. This review verifies that calculation;
it has not established that the improvement is historically original.
The classical analytic inputs are not needed to prove these real inequalities.
They are needed before the inequalities describe a character moment.

No concrete gap was found in this unit. Unsupported strengthenings would be:
an optimal `eta=1/30` in `prop:dual`, optimality across other analytic estimates
or all narrower covering intervals, or a bounded copy degree without a
factor-count hypothesis. None is licensed by the certificate.
Native independent Reviewer acceptance remains pending.
