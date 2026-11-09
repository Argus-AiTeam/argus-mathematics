# Final-submission evidence map

## Object and current manuscript

The object under review is the universal algebra \(Q_n\) over
\(K=\mathbb Q(q)\), for every \(n\geq4\), separately for both well-typed
repairs in `OBJECTIVE.md`.  It is not a finite matrix image.  The theorem
under review is

`research/principal_ideal_factorial_recursion/uniform_defect_propagation/UNIFORM_DEFECT_PROPAGATION_THEOREM.md`.

Its current SHA-256 is
`9e098615067727c74e129b4f70cd48f6af52d68fc44b277b7ba4a85b6d02e266`.
The preceding reviewed hash was
`40d17ec6193441cf88552bd74aed3b3e09176a5f3b92eb60389f17a14b8bb471`.
The only manuscript change is the restoration of the omitted `+` in the
second branch of equation (15):

\[
(1-q)d_{j+1}^{(n)}d_l^{(n-1)}u
+q\,d_{l+1}^{(n)}d_{j+1}^{(n-1)}u.
\]

This is the formula already carried by the unchanged executable certificate
in its `uniform_formulas.insertion_l_gt_j` field.  That certificate's
SHA-256 is
`18e95df21bfa16f907ec4f5f986ecbff4b94b1bd291f938612be63adb629d0ee`.
No theorem, hypothesis, quantifier, implication, coefficient, or proof step
was otherwise changed.

## Positive acceptance criteria

| Criterion from `OBJECTIVE.md` | Exact mathematical location | Decisive replay evidence |
|---|---|---|
| Uniform finite spanning families | Theorem and equations (1)-(2); Sections 2-6 prove \(Q_ne=L_n\) and \(eQ_n=R_n\) for every \(n\geq4\) | `uniform-defect-propagation-certificate.json`, fields `theorem.left`, `theorem.right`, and `theorem.principal_bounds` |
| Derivation from the exact zipper relations | Section 1 derives the rank-four base and rank-five tail rule from the repaired presentations; Sections 2-5 use only braid identities, the common cubic consequence, and that exact tail rule | `base-and-candidate-transversals-certificate.json`; `q5-left-membership-certificate.json`; `q5-right-membership-certificate.json` |
| Termination and honest upper/lower bounds | Section 6 gives the strict defect-rank/multiset measure and inverse closure; Section 7 gives the ideal exact sequence | `uniform-defect-propagation-certificate.json`, field `termination`; `MATH_STATE.json`, claim `C-PRINCIPAL-BOUND-REDUCTION` |
| Explicit uniform dimension bound | Equations (2)-(3) and Section 7 prove \(\dim Q_n\leq(2n-1)!!+(n!/3)^2\); the BMW quotient and nonzero \(J_n\) give the honest lower bound \((2n-1)!!+1\) | `uniform-defect-propagation-certificate.json`, field `theorem`; the two current baseline replays below |
| Exact ranks 4-6 and all indexed critical templates | Section 8 separates exact characteristic-zero anchors from the finite-fiber replay and states that the all-rank conclusion is symbolic | `uniform-defect-propagation-certificate.json`, fields `exact_q4_base`, `q5_replay`, `q6_replay`, and `critical_pair_replay`; `q6-propagation-certificate.json` |
| Surviving BMW projection and nonzero \(X_3\) kernel | Section 7 proves \(Q_n/J_n\cong\operatorname{BMW}_n(q,-q^3)\), while the Burau model has nonzero rank-one \(X_3\) and \(X_4=0\) for both repairs | `research/final_certification/baseline_replay/twist-extension-verification.json`; `twist-extension-modular-verification.json` |

The exact certificate hashes are:

| Artifact | SHA-256 |
|---|---|
| `base-and-candidate-transversals-certificate.json` | `6cb8ed940c190d9e9c075c9ba191d454bb50961ee23f0fe55af6d3680fff29b7` |
| `q5_left_membership/q5-left-membership-certificate.json` | `091c514c05f30758178a9e89c509534b29a34a9ee31420da74309de027be25fc` |
| `q5_right_membership/q5-right-membership-certificate.json` | `88835443b7a4e66b7cd516271135736214738d37253c7edf5c5c9518548404e3` |
| `uniform_defect_propagation/uniform-defect-propagation-certificate.json` | `18e95df21bfa16f907ec4f5f986ecbff4b94b1bd291f938612be63adb629d0ee` |
| `uniform_defect_propagation/q6-propagation-certificate.json` | `a90410c26c3009ea5d4e19d23ca8d1ce868b1383a0698b720f996808599f08b2` |

All paths in this table are relative to
`research/principal_ideal_factorial_recursion/`.

## Current baseline replay

Both immutable supervisor verifiers were rerun without modifying the reviewed
baseline.  The generated files are byte-identical to the supervisor evidence:

| Replay | SHA-256 | Result |
|---|---|---|
| `baseline_replay/twist-extension-verification.json` | `314e34be2dc785d7e4ae6372e97e55bfa31a748945479640976cf45b6275a6f7` | passed; byte-identical |
| `baseline_replay/twist-extension-modular-verification.json` | `8247481edcbeee05dcd91bde475aeaeec29d57c4bb0ccebd756c58eabf90bcd1` | passed; byte-identical |

The representation evidence proves survival of the BMW projection and a
nonzero \(X_3\) kernel.  It is not used to infer universal
finite-dimensionality.

## Sealed independent reviews

The two prior reviews remain distinct and are not substituted for the required
current-hash integrated review:

1. Mathematical correctness and statement alignment: `activity.jsonl`,
   timestamp `2026-09-04T12:03:00Z`, kind
   `sealed_universal_fd_acceptance_reconciled`, sealed mission
   `3b60b5cf8ba5`; corresponding ledger judgements are by
   `reviewer:copilot-uniform-round-1`.
2. Public-source novelty and specialist significance: `activity.jsonl`,
   timestamp `2026-09-04T12:54:41Z`, kind
   `independent_novelty_significance_acceptance`; corresponding ledger
   judgements and seven source attributions are by
   `reviewer:novelty-significance-l2`.

The reviewed public-priority record is
`research/novelty_significance/RESULT.md` (SHA-256
`3f6e61273e0c8b31314210fe4617558e484c3d85b32f2b120d815249daae7214`);
its reproducible search record is `QUERY_LOG.md` (SHA-256
`99bed597fe3949858779ce437dd8b00bc5adad2827870f0341d2d1b7086aab93`).
The frozen primary-source snapshot under
`research/novelty_significance/source_cache/` was not rebuilt.

The repository-separation certificate is
`research/novelty_significance/public-repository-comparison-certificate.json`
(SHA-256
`37783963328a422e906e4747c80ece3c22a10bceb9c3588658763f2573b49551`).
It proves that the public repository relation forces \(X_3=0\) and hence
implies the campaign relations.  Equivalently, the canonical quotient map is
from the campaign quotient onto the public repository quotient, not conversely.
The nonzero Burau \(X_3\) separates the converse.

## Statement and publication boundary for final review

The natural statement is: for both repairs and every finite \(n\geq4\), the
universal presented algebra \(Q_n\) is finite-dimensional over
\(\mathbb Q(q)\), with

\[
(2n-1)!!+1\leq\dim Q_n\leq(2n-1)!!+(n!/3)^2.
\]

The proof object is the prose algebraic induction and exact certificates above;
there is no Lean formalization.  The upper bound is not asserted to be an exact
dimension formula.  The rank-four through rank-six calculations are anchors
and exhaustive template replays, not the source of the all-rank quantifier.

Permitted publication wording is:

> In the fixed public corpus and reproducible searches completed on
> 2026-09-04, no equivalent all-rank statement, two-sided principal-ideal
> defect method, or dimension bound was found.  The result is a substantive
> specialist structural theorem.  Absolute originality and unpublished
> priority are unresolved because the 2004 BIRS attribution and the
> undisclosed Bigelow--Moos work cannot be compared at theorem level.

The distinct final-submission Reviewer must inspect `OBJECTIVE.md`, the current
theorem hash, the five decisive certificates, both baseline replays, both
sealed review records, `RESULT.md`, `QUERY_LOG.md`, the frozen primary-source
comparison, and the repository-separation certificate.  A `done` verdict must
explicitly decide whether the scoped public-corpus novelty and disclosed
Bigelow--Moos boundary suffice for publication; a generic priority caveat is
not a decision.
