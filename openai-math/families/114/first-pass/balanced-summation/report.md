# Balanced summation: exact scope and proof

**Result:** the balanced-summation lemma holds as stated for arbitrary positive
full-slice weights and arbitrary positive pair capacities. Lean 4.31.0 certifies
the complete spectral-signature closure, including capacities one and two,
addition by reflection, and fixing. Independent Reviewer acceptance is pending.

## Statement under audit

The source is `research/openai_manuscript/An-FPRAS-for-Common-Integer-Polymatroid-Bases-with-Binary-Capacities-October-5-2026/build/sections/signatures.tex`,
Definition `def:integer-signatures` and Lemma `lem:balanced-summation`.
The input is an arbitrary strictly positive real weight on the **entire**
integer slice of a finite box, extended by zero off that slice. The removal
test is required only at box-valid displays of total two above the slice.
Paired coordinates have equal positive integer capacities. No factorization,
laminarity, additional log-concavity, or nondegeneracy of a test matrix is
assumed.

The audited conclusion is preservation of the removal signature under the
unweighted sum over each pair `(k, M-k)`, including `M=1` and `M=2`.
Reflection gives the addition version. This is not a proof of the FPRAS.

## Scope and prior result

The manuscript already states this general closure and supplies the
cumulative-sum proof below. Its attribution to an earlier induction is not
used as a premise or independently certified here: the closure is proved
directly. No claim of a new mathematical closure theorem is made. The
improvement over the supplied proof is a universal, kernel-checkable
certification, rather than a bounded search or an identity check.

A targeted lookup of the inherited project Wiki index found no relevant
polymatroid, Lorentzian, or quadratic-signature result. No external
mathematical proposition is needed by this proof.

## Universal quadratic argument

Write `B(x,y)` for a symmetric real bilinear form. Its positive index is at
most one precisely when, for every `u` with `B(u,u)>0`, the form is
nonpositive on the hyperplane `B(v,u)=0`. For a finite real symmetric matrix,
this is equivalent to having at most one positive eigenvalue. Consequently

```
B(v,v) <= B(v,u)^2 / B(u,u).
```

We also need the genuine null-axis consequence, not an assumed positive
diagonal: if `B(e,e)=0` and `B(e,w) != 0` for some `w`, then
`B(v,v)<=0` whenever `B(v,e)=0`. To see this without limits, suppose
`B(v,v)>0`. Project `w` off `v`, obtaining `w'` orthogonal to `v`.
Then every `w'+t e` is orthogonal to `v`, so
`B(w',w')+2t B(w',e)<=0` for every real `t`. This forces
`B(w',e)=B(w,e)=0`, a contradiction.

Fix one remaining box-valid display `z` of total `r-M+2`. For
`0 <= k <= M`, partition its original removal test at `(z,k,M-k)` as

```
N_k = [ V_k        S_(k-1)   S_k       ]
      [ S_(k-1)^T  u_(k-1)   u_k       ].
      [ S_k^T      u_k       u_(k+1)   ]
```

Here `S_l(i)=F(z-e_i,l,M-1-l)` and
`u_k=F(z,k-1,M-1-k)`. Zero extension gives `S_-1=S_M=0` and
`u_k=0` outside `1 <= k <= M-1`. For `M>=2`, strict positivity
on the full slice gives `u_k>0` at **every** interior index: all
coordinates of each corresponding profile are box-valid, and its total is
exactly `r`.

For `M=1`, both tests have the same off-diagonal column `S_0` and
a null paired axis. If `S_0!=0`, the null-axis consequence makes
`V_0+V_1` nonpositive on `a.S_0=0`. If `S_0=0`, positivity
forces every coordinate of `z` to vanish (a positive coordinate would
give a strictly positive entry of `S_0`). Every old double removal
is then invalid, so both `V_k` vanish. This includes vacuous or empty
slices and zero-capacity old coordinates.

For `M>=2`, take an arbitrary old vector `a` with
`a.(sum_l S_l)=0`. Put

```
g_k = (a.(sum_(l=0)^(k-1) S_l)) / u_k   (1 <= k <= M-1),
g_k = 0                                (otherwise).
```

Including the two endpoints, the exact identity is

```
a.S_l = u_(l+1) g_(l+1) - u_l g_l  (0 <= l <= M-1).
```

Set `v_k=(a,g_k,-g_k)`. Its bilinear products with the two
paired axes are `u_(k-1)(g_k-g_(k-1))` and
`u_(k+1)(g_(k+1)-g_k)`. If either axis has positive square,
projection onto that axis, followed by addition of a nonnegative term,
gives

```
N_k(v_k,v_k) <= u_(k-1)(g_k-g_(k-1))^2
                + u_(k+1)(g_k-g_(k+1))^2.
```

If both axis squares vanish, `k` is interior and `u_k>0`.
The sum of the two axes has square `2u_k>0` and is orthogonal
to `v_k`, proving the same inequality with right side zero. In
particular this handles the middle test when `M=2`; it must not
be omitted or treated as a positive-diagonal case.

Expansion and the cumulative identity give the local energy inequality

```
a.V_k.a + 2u_k g_k^2
           - u_(k-1) g_(k-1)^2 - u_(k+1) g_(k+1)^2 <= 0.
```

Summing over the **entire** interval `0 <= k <= M` cancels
the energy terms, including the endpoints. Hence `sum_k V_k`
is nonpositive on one common hyperplane. This implies positive index
at most one: any positive-definite two-dimensional subspace would
intersect that hyperplane nontrivially.

Every profile on the remaining valid slice has a positive summand for
every balanced choice. One-pair closure can therefore be iterated over
any finite list of disjoint equal-capacity pairs.

Finally `z_i -> m_i-z_i` bijects the original slice with the complementary
slice, turns additions into removals, and takes `(k,M-k)` to
`(M-k,k)`. Reindexing this finite sum proves the addition statement.
Fixing a coordinate restricts every relevant test to a principal
submatrix and preserves positivity on the resulting valid slice.

## Exact formal scope

`Main.lean` proves the complete closure for every finite old coordinate
type, every integer total, every finite list of positive pair capacities,
and every positive full-slice real weight. It also proves positivity and
zero extension of the output, reflection for addition, and coordinate
fixing. The final declarations are
`balanced_pairs_removal_spectral`, `balanced_pairs_addition_spectral`,
`fixing_removal_spectral`, and `fixing_addition_spectral`.

The spectral encoding is not an extra signature assumption:
`signature_iff_eigenvalues` proves that the working bilinear predicate is
equivalent to uniqueness of a positive eigenvalue index in Mathlib's
complete orthonormal eigenbasis, counting multiplicity. The exact
quantifiers and the recursive disjoint-pair coordinate presentation are
documented in `statement_fidelity.md`.

`verify.py` replays the polynomial identity, exact rational inertia
controls, and eight finite configurations, and authenticates the
source-bound real compiler result. The finite cases include capacity one,
capacity two's null-axis middle test, capacity three, two disjoint pairs,
zero old capacities, empty slices, and an empty remaining coordinate set.
These experiments are deliberately classified as finite evidence only.
The retained Jacobian request and typed answer concern the matrix with
zero diagonal and unit off-diagonal entries in dimension four; its exact
inertia is `(1,3,0)`. An earlier rejected request is retained as an adapter
error, not a mathematical conclusion.

The official, claim-bound Lean 4.31.0 run succeeded with `exit_code=0`
and `proof_holes=[]`. Its immutable claim certificate is
`certificates/C_BALANCED-0db48a75dbe67495.json`; the derived formal claim
status is `closed_kernel`. The four principal declarations depend only
on `propext`, `Classical.choice`, and `Quot.sound`. The source and this
statement's fidelity document are bound into the actual compiler result,
not inferred from a successful arithmetic test.

No assertion of the audited lemma was falsified. Independent acceptance,
statement-fidelity assessment, and any publication-level novelty
assessment belong to the Host-invoked Reviewer. The graph deliberately
keeps its independent-review flags false. This bounded mission does not
terminate the broader counterexample campaign or certify the complete
FPRAS.

To replay the exact arithmetic and authenticate the current proof certificate,
run from the campaign root:

```
$WORKSPACE/argus-live-update/.venv/bin/python research/balanced-summation/verify.py
```

For an independent fresh compiler replay, the native command is:

```
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/balanced-summation/Main.lean --statement-fidelity research/balanced-summation/statement_fidelity.md --claim C_BALANCED --project-root .
```

The official ledger checks were run against
`campaigns/9000114`, not the
shared batch root; both exited zero. Adding the formal source changed the
claim version. The checker's stale goal reference on the superseded route
was repaired without changing the mathematical assertion or its
obligations; `R_BALANCED_FORMAL_CERTIFICATION` is the current route.
