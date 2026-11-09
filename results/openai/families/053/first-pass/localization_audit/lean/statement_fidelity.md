# Statement fidelity: localization arithmetic, not virtual geometry

This source formalizes only claim `C53_LOC_NUMERICS`. It does not formalize
`C53_LOCALIZATION`, the existence of an obstruction theory, Hodge index,
Riemann--Roch as a geometric theorem, a tensor realization, or Chow
vanishing. All geometric uses of these arithmetic statements are in
`research/localization_audit/REPORT.md`.

The namespace is `LocalizationAudit`. The integer parameter `q` is b-1.
The definitions `chi`, `surfaceSquare`, `t`, `nu`, `lengthN`, and
`virtualRank` are respectively q^2, 8q^2, 25q^2-1, t-1, nu+3s, and
2t+chi-3. They are defined on every integer; the assertions needing the
manuscript genus range explicitly assume q>=4.

* `chi_lower_bound`, `rank_gap`, `numerical_parameters`, and
  `branch_thresholds` prove the uniform virtual-rank gap, parameter
  identities, and the length thresholds for the four ordered branches.
  The lengths supplied by geometry are N, nu, nu, and nu-s. The theorem
  does not assert that these are all geometric fixed loci.
* `high_index_exists` quantifies over rational a,b,s with s>0 and
  a+b=3s. Its conclusion s<a or s<b is only the numerical high-index
  selection, not obstruction-map surjectivity.
* `support_factorization` is an identity for all rational q,p.
* `integral_support_bound` quantifies over integers q,n and rational p.
  It assumes q>=1, 2q<=p<=8q^2-2q, and
  8q^2(2n+p)<=p^2, and concludes n<=-q. In the geometric application
  p=K.P, n=P(P-K)/2 is integral, and the last hypothesis is Hodge index.
  Those geometric facts are not proved by Lean.
* `short_length_exclusion` quantifies over all integers t,n,k, assumes
  n<t, and concludes 4t-2k<2(3t-k-n). The support interpretation of
  this inequality is not encoded.
* `blockCost` assigns cost 2 to k=1, cost 4 to k=2, and 2(k-1)
  otherwise. `block_budget` assumes k>=1, proves 4k<=3 cost(k),
  and proves equality if and only if k=3. `slack` is 3 cost(k)-4k.
  `slack_sum_nonneg` and `zero_slack_only_triples` quantify over
  arbitrary finite lists of positive block sizes. The latter says
  zero total slack forces every size to be 3. Geometry supplies the
  cost hypotheses and the zero total slack.
* `based_trace_cancellation` and `riemann_roch_rank` are rational
  polynomial identities only. In the second theorem `nu,l1d,l2d,kd,
  dsq,chi` are independent rational scalars, representing the indicated
  intersections when the identity is applied in the report.

No external axioms or manuscript statements are added. The imported
Mathlib facts and the Lean kernel check the algebra. Correct translation
of these statements, their geometric hypotheses, the prose proof, and
independent review are not compiler verdicts.
