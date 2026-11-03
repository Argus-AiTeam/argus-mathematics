# Evidence for 2141

- Audit cutoff: 2026-08-27.
- Candidate: `refuted`; alignment `exact`.
- Evidence level: `formal_artifact`; review status: `unreviewed`.

## Public sources and locator

- Current public `main` statement:
  https://github.com/ShouqiaoW/erdos/blob/main/486/lean/Erdos486/Statement.lean
- Current public `main` final theorem:
  https://github.com/ShouqiaoW/erdos/blob/main/486/lean/Erdos486/Main.lean
- Current public `main` workflow:
  https://github.com/ShouqiaoW/erdos/blob/main/.github/workflows/erdos486-lean.yml
- Dated GitHub Actions record:
  https://github.com/ShouqiaoW/erdos/actions/runs/29565958267
- Locator: `Statement.lean` declarations `survivors`, `HasLogDensity`, and
  `Erdos486Assertion`; `Main.lean` theorem `erdos486_negative`; workflow steps
  "Reject proof placeholders" and `leanprover/lean-action`; Actions record
  created 2026-07-17 08:18:15 UTC and completed successfully at 08:21:56 UTC.

## Statement fidelity and formal result

The current public statement defines survivors using the strict activation
condition \(n<m\), then quantifies over every set \(A\) and every family of
residue sets \(X_n\). Its logarithmic average is the same normalized reciprocal
sum as the audited claim. The final public theorem is:

```text
theorem erdos486_negative : ¬ Erdos486Assertion
```

The stronger public proposition constructs one fixed infinite \(A\), fixed
residue sets \(X_n\), and one resulting survivor set \(B\), with
\[
 \liminf L_B\le177/200<49/50\le\limsup L_B.
\]
This is genuine nonconvergence for one fixed congruence system, not a system
that changes with the cutoff.

## Build record and limitation

The public workflow rejects `sorry`, `admit`, `axiom`, and `sorryAx` before
running the full Lean build. The dated Actions record is named "Erdos 486 Lean
CI", has display title "Add complete Lean proof for Erdos Problem 486", and
reports both `completed` and `success`.

The current branch files and the dated build record are public but have
different temporal roles: the files show the statement available at the audit
cutoff, while the Actions page records a successful build on 2026-07-17. This
evidence supports a machine-checked proposed solution; it is not presented as
peer review or independent community acceptance. Independent Reviewer
verification is still required.
