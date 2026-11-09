# Finite moments: existing algebra and bounded-check review

## Disposition and contract

This is the **Engineer evidence assessment**, at research target
`exploratory`, of the existing Family 065 finite-moments unit. It is not a
new theorem, manuscript-error search, independent review, or acceptance.
The review result has novelty status `not_applicable`.
**Final acceptance: `pending_native_independent_review`.**

Current project root:
`campaigns/9200065`.
Old root, read-only throughout:
`campaigns/9000065`.
Below, old family paths are relative to its
`research/family_orbit_localization/`; replay paths are relative to this
unit directory. The sole contracts were the current `OBJECTIVE.md`,
`PRIOR_DRAFTS.json`, and this worker's bounded assignment. Historical
instructions and old supporting judgements were treated as data.

**Assessment:** the six ordinary commutative-ring/module algebra theorems
have a faithful successful fresh replay. The archived matrix example and
the finite symbolic identities also replay successfully. These facts
support their precisely restricted statements, not all-degree geometry,
the full common-\(R\) theorem, super signs, or a manuscript counterexample.
The geometric premises of the degree-one calculation are identified and
assessed separately below.

## 1. Provenance, inspected coverage, and non-independent receipts

The following supporting artifacts were actually read, not inferred from
their names or success labels:

| Old artifact(s) | Assessment of role |
|---|---|
| `Main.lean`; `lean_evidence/Main.lean` | Byte-identical successful source, one six-theorem algebra argument, not two results. |
| `statement_fidelity.md`; `lean_evidence/statement_fidelity.md` | Byte-identical interpretive notes, not additional proofs. |
| `lean_evidence/certificates/C_LOC_JET-434d7c41b97fb184.json` | Immutable failed v2 source, compiler error and binding; not successful evidence. |
| `lean_evidence/certificates/C_LOC_JET-eb1805af26b62351.json` | Immutable successful v3 source, note, compiler/audit output and exact old-claim binding. |
| `lean_evidence/lean_check.json`; `lean_evidence/compile.log` | Metadata and rendered transcript of that same successful run. The JSON check equals the successful certificate's check. |
| `lean_submission.json` | Historical direct-run submission receipt (`family-orbit-jets`); “submitted” alone proves no compilation outcome. |
| `lean_verification.json` | Successful check repeated, plus its kernel-recording receipt; removing `kernel` gives the same archived check. |
| `exact_certificate.json` | Expected aggregate finite-check result; expressly says the full proposition is not kernel checked. Not another geometric proof. |
| `jacobian_payload.json`; `jacobian_output.json`; `jacobian_status.json` | One historical typed 3-by-3 multiplication, its request/output and exit/timeout receipt, not three mathematical results. |
| `verify.py` | Entire checker inspected **before execution**, including its default compare branch and optional write branch. Only default mode was run. |
| `report.md` | Old theorem, Sections 1–6, joint-moment argument and “Exact evidence and its limits”; strongest surrounding claims were not silently equated to the checker. |
| Old `research/MATH_STATE.json` | All three `C_LOC_JET` versions, their exact natural/formal texts, mechanical bindings, historical supporting judgement, and `R_LOC_MOMENT_CORE`. |

The manuscript source actually consulted is
`Virasoro-Constraints-under-Projectivization-October-5-2026/build/sections/04-localization.tex`
at the source directory in the read-only manuscript manifest. Its SHA-256
is `43700b503d66994d32306311f50f9f78ea32b51c580d6824d15f9675691dbd52`,
matching that manifest's revision
`4eaee87548250b2682affda7d05d947c05554bae`. Lines 218–241 contain the
finite denominator and independent-dummy-scalar convention; specifically
lines 236–237 say to use **joint moments and independent dummy scalars**.

`replay/provenance_before.json` preserves the old version texts, old
evidence records, every listed artifact's size/hash, and exact binding
comparisons. `replay/preservation_check.json` verifies all **26** listed
old artifact byte hashes unchanged after the replays. Fingerprinting all
26 is preservation checking, not a claim that this one unit mathematically
reviews every other unit. No snapshot, manifest, manuscript, old ledger,
old certificate, current index, graph, Wiki, or other unit report was
edited.

### Historical version sequence

The natural statement is identical in v1, v2 and v3: a finite nilpotent
inverse over every commutative ring, finite joint linear naturality, and
arbitrary finite multilinear contraction, explicitly only the even-class
algebraic core and not virtual localization.

| Version | Formal content and actual outcome |
|---|---|
| v1 | Natural statement only; no formal source or compiler success to attribute to this version. |
| v2 | Formal proof source SHA-256 `46f0d2dde16c980ddf1ef8626aa1d3a36c32df43a27108d17a57592d84d6231a`; compile exit **1**, 6,349 ms. The attempted `simp [mul_pow, hν]` leaves `⊢ (-(ν * u)) ^ N = 0`. Hole scan was empty but compilation failed and no axiom audit ran. Its mechanical verdict is `inconclusive`, bound to old claim hash `d739b8a9f550ef8e9f7bfcad36ed9e93e6423b8eb32d6665512349312d7d0586`. |
| v3 | Only that proof step changes to `simp only [mul_pow, hν, mul_zero, zero_mul]`. Same theorem statements. Compile exit **0**, audit exit **0**, hole list `[]`, 15,798 ms. Successful archive `C_LOC_JET-eb1805af26b62351.json` binds old claim hash `5f2031c7e3cbecbcb58a483d3d0920d92de2da6128f971963293805357d0765d`. |

The unsuccessful script is a genuine historical proof-submission failure,
not a counterexample to its algebra statement. v3 fixes the submission.
The later old “reviewer supports” ledger judgement is historical opinion,
not this campaign's independent acceptance.

## 2. Exact formal claims, quantifiers, and argument

Namespace: `FamilyOrbitLocalization`. There are **six theorems**, plus the
definition
\[
G(u,\nu,N)=u\sum_{j=0}^{N-1}(-\nu u)^j
\quad\text{(`nilpotentResolvent`).}
\]
There are no geometric definitions hidden behind these symbols.

1. **`finite_geometric_remainder`.** For every type \(A\) with
   `CommRing A`, every \(x\in A\), and every \(N\in\mathbb N\),
   \[
   (1-x)\sum_{j<N}x^j=1-x^N.
   \]
   The proof is induction, with the successor sum expansion and a ring
   identity. \(N=0\) is included: both sides are zero.

2. **`nilpotent_resolvent_inverse`.** For every commutative ring \(A\),
   \(t,u,\nu\in A\), and \(N\in\mathbb N\), **assuming**
   \(tu=1\) and \(\nu^N=0\),
   \[
   (t+\nu)G(u,\nu,N)=1.
   \]
   Commutativity gives \((-\nu u)^N=0\); also
   \((t+\nu)u=1-(-\nu u)\). The preceding remainder identity proves the
   result. Nilpotence and the chosen inverse are inputs, not conclusions
   about any cohomology class.

3. **`nilpotent_resolvent_unique`.** With exactly those hypotheses, for
   every \(v\in A\) additionally satisfying \((t+\nu)v=1\),
   \[
   v=G(u,\nu,N).
   \]
   Multiply \(v\) by the verified inverse identity and use
   commutativity to apply the hypothesis on \(v\). This is not a theorem
   about arbitrary noncommutative rings and one-sided inverses.

4. **`joint_moment_naturality`.** For every commutative scalar ring \(K\),
   additive commutative groups \(V,W,U\) equipped with \(K\)-module
   structures, every finite type \(J\), \(K\)-linear maps
   \(P:V\to W\), \(L:W\to U\), scalars \(c:J\to K\), and vectors
   \(h:J\to V\),
   \[
   L\left(\sum_{j:J}c_jP(h_j)\right)
     =\sum_{j:J}c_j(L\circ P)(h_j).
   \]
   The proof uses preservation of finite sums and scalar multiplication.
   \(J\) can be the entire joint tuple of flag orders.

5. **`joint_dressing_naturality`.** Under the same ring/module/finite
   index hypotheses, for every linear \(L:W\to U\), family of linear
   maps \(D_j:V\to W\), and \(h:J\to V\),
   \[
   L\left(\sum_jD_j(h_j)\right)=\sum_j(L\circ D_j)(h_j).
   \]
   Again this is finite-sum linearity. It permits, but does not construct
   or geometrically identify, a vector \(h_j\) already containing an
   entire connected correspondence.

6. **`all_flag_contraction`.** For every commutative \(K\), finite type
   \(I\) with `DecidableEq I`, \(K\)-modules \(V_i,W\) with the stated
   additive group structures, finite types \(J_i\), multilinear
   \(F:(\prod_i V_i)\to W\), scalars \(c_i:J_i\to K\), and vectors
   \(h_i:J_i\to V_i\),
   \[
   F\left(i\mapsto\sum_{j:J_i}c_{ij}h_{ij}\right)
   =\sum_{q:\prod_iJ_i}
       \left(\prod_i c_{i,q_i}\right)
       F(i\mapsto h_{i,q_i}).
   \]
   `F.map_sum` expands the choices; `F.map_smul_univ` extracts their
   scalar product. This proves distributivity, not independence of
   geometric endpoint data.

**Edge cases and scope.** No field, domain, characteristic-zero,
nontriviality, or positive \(N\) assumption is present. For the inverse
claims at \(N=0\), \(\nu^0=0\) forces \(1=0\); hence these hypotheses
are impossible in a nontrivial ring and valid only in the trivial-ring
case, where the conclusion also holds. There is no erroneous inverse of
zero in a nontrivial ring. Empty \(J\) gives the zero-sum identities.
Empty \(I\) has one empty choice and scalar product one; if some \(J_i\)
is empty for a nonempty \(I\), multilinearity with a zero input matches
the empty choice sum. The quantified finite types impose no fixed bound
on the number of flags or truncation orders, but assert nothing about
infinite sums or convergence.

### Fidelity judgement, separate from compilation

The preserved fidelity note accurately describes these six statements
**as even algebra**. The source has no grading: its commutative scalars
model ordinary even tangent classes. It contains neither super
permutation/Koszul signs nor categorical diagonal classes. An actual
geometric contraction must separately be shown to give the required
linear/multilinear maps, with any signs already in those maps.

In particular, linear naturality does not prove a projection formula or
compatible virtual pullback. It never replaces a joint pushed tensor by
products of marginal pushes. The general factorial/derivative Taylor
notation in old report equation (7) is also not defined in Lean:
the six theorems work over arbitrary commutative rings, whereas the
derivative formulation uses the rational/complex coefficient setting.

There are no GW moduli, obstruction theories, virtual classes,
ancestor classes, \(S\), symplectic \(R\), translations, quantization,
integral curve-label arguments, or all-genus assembly in this source.
“All orders” here means every **finite algebraic** \(N,I,J_i\), not a
kernel proof of Proposition `loc:factorization`. The old route
`R_LOC_MOMENT_CORE` itself also requires `L_LOC_GLUE`, separately from
`C_LOC_JET`; the compiler cannot discharge that geometric obligation.

## 3. Fresh Lean replay, real binding, and trust boundary

The successful old source and fidelity note were copied **without any
repair or rewriting** to `replay/Main.lean` and
`replay/statement_fidelity.md`. Native verification made its canonical
copies in `replay/lean_evidence/`, which are also byte-identical.
The submitted outer source was a working copy; it was removed during
the final recorded-evidence check, as explained below. The canonical
compiled source, fidelity note and immutable certificate are retained.

* Source SHA-256:
  `b4cb6a378265f41042862a298836d0e5639b7a8e8bc5d192b0d4b6f57a3bdd1f`.
* Fidelity SHA-256:
  `1c5dd38b2fce621ff14a5f8b0ac5f9a834eec1c57076b78e6b3224fba622819a`.
* Both hashes and the exact archived texts match the old successful
  immutable certificate, not the failed v2 source.

A separate auxiliary claim **`C_REPLAY_ALG` v1** was registered through
current native `math_state claim --formal-file`, in existing context
`CTX_REVIEW`. Its natural statement enumerates exactly the six algebraic
statements and exclusions above; its formal text is the copied file.
The actual native command and statement are in
`replay/lean_registration.status.json`, its raw stdout, and
`replay/auxiliary_claim.json`. This is a reproduction claim, not a new
mathematical finding or a formalization of review completeness.

The actual command used the explicit latest interpreter:

```text
$WORKSPACE/argus-latest/.venv/bin/python
  -m argus_skill.verticals.math.lean_evidence verify
  <current-root>/research/draft_reviews/finite-moments/replay/Main.lean
  --statement-fidelity <current-root>/research/draft_reviews/finite-moments/replay/statement_fidelity.md
  --claim C_REPLAY_ALG --project-root <current-root>
  --artifact-dir <current-root>/research/draft_reviews/finite-moments/replay/lean_evidence
  --timeout 45
```

`PYTHONDONTWRITEBYTECODE=1` was set. No lakefile was created and no Mathlib
installation or build was attempted.

| Fresh observation, 2026-11-07 | Actual outcome |
|---|---|
| Workspace | `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0` |
| Lean | `4.31.0`, `x86_64-unknown-linux-gnu`, commit `68218e876d2a38b1985b8590fff244a83c321783`, Release |
| Lake | `5.0.0-src+68218e8` (Lean 4.31.0) |
| elan | `4.2.3 (b6cec7e10 2026-06-08)` |
| Compilation | `success`, exit **0**, empty stderr |
| Hole scan | `proof_holes: []` |
| Axiom audit | Exit **0**, empty stdout/stderr; latest `lean_axiom_audit.lean` |
| Compiler-plus-audit measurement | **15,642 ms**; outer native command 15,780 ms |
| Warning | Only the preserved unnecessary `<;>` sequencing linter warning at 23:58 |

The exact new immutable compiler certificate is:

`research/draft_reviews/finite-moments/replay/lean_evidence/certificates/C_REPLAY_ALG-7e08dff9817827b1.json`

It records evidence `lean-C_REPLAY_ALG-5ab078207bd5`, mechanically
supporting only claim hash
`da696744b3693cb44465be8b4e90af4f4d4297d816d7b234ecbab2631c8c94e6`.
`replay/lean_binding.json` checks the current claim, certificate subject,
archived source/note texts, old successful archive and every copied
byte/hash. All twelve binding comparisons are true.

The copied fidelity note intentionally still names old `C_LOC_JET`; its
contents were not rewritten to relabel an old proof. The new certificate
and native ledger bind the unchanged source/note to the separately
registered auxiliary claim. Native metadata expressly leaves
`statement_fidelity.verified_by` null: compilation is **not** a semantic
fidelity decision. The judgement in Section 2 is this worker's
source-specific assessment, still requiring independent review.

The axiom audit elaborates at trust level zero and checks source-added
axiom declarations. It found none; this is not a claim that all imported
Mathlib results have no foundational axioms. The trusted boundary includes
Lean's kernel, the installed Lean/Mathlib environment and its standard
foundations. No geometric external assumptions are encoded on this
auxiliary claim.

The real compiler/audit transcript is `replay/lean_evidence/compile.log`;
structured check and exact native stdout/stderr/status are retained
beside it. The final `lean_evidence check` initially reported
`lean_result_missing` for the redundant outer `replay/Main.lean`:
the native result names its canonical `lean_evidence/Main.lean`, not
both byte-identical paths. The Engineer removed only that redundant
current working copy and made successful helper cleanup explicit.
No old source, compiler result, certificate or fidelity text was edited;
no compiler verdict was copied to an unrecorded path and the unchanged
proof was not recompiled. Only the canonical, actually compiled `.lean`
source remains for the recorded-evidence gate.

## 4. Default finite replay and what its computations establish

The old checker's default computes its result, reads the stored
`exact_certificate.json`, demands exact parsed-JSON equality, and prints
PASS. Its `--write-certificate` branch would write into old inputs:
**that flag was never used**. The sole default execution was

```text
PYTHONDONTWRITEBYTECODE=1
$WORKSPACE/argus-latest/.venv/bin/python
  families/065/first-pass/family_orbit_localization/verify.py
```

The current-root command, cwd and complete environment overrides are
preserved in `replay/finite/default.status.json`. Actual result:
exit **0**, no timeout, **2,096 ms**, 198 stdout bytes and **0 stderr
bytes**. Stdout:

> PASS: typed Jacobian replay; source-bound zero-hole Lean core; joint moments; exact degree-one common-R, translation and bridge checks. Geometric proof and novelty still require independent review.

Python was **3.13.5**, Anaconda build dated June 12, 2025, GCC 11.2.0;
SymPy was **1.14.0**. These are fresh-run versions; the old aggregate
certificate did not record Python/SymPy versions. Initially the latest environment lacked SymPy.
The wrapper failed before invoking old `verify.py`; an explicit logged
dependency preflight returned `ModuleNotFoundError`, exit 1. Only after
that failure, pinned SymPy 1.14.0 and mpmath 1.3.0 were installed under
this unit's `replay/dependencies/`, with cache/bytecode compilation
disabled and pip workspace confined to the unit and then removed.
The installation exited 0 in 743 ms; the global interpreter environment
was not changed. The actual successful default run used the recorded
unit-local `PYTHONPATH`. Two wrapper startup attempts also stopped on a
local `NameError` before launching any mathematical command; that wrapper
was corrected. Neither startup failure was an additional old-checker or
live Jacobian execution.
Their pre-execution scope and observed shell exits are recorded in
`replay/wrapper_startup_failures.json`; the separate actual dependency
failure has its own stdout/stderr/status under `replay/finite/`.

`replay/finite/archived_verify.py` is an exact source copy (SHA-256
`818a83d396ba78e16be47dfdf654f35f9a39ac54820b1599de3c7d8c30e88ece`).
`archived_exact_certificate.json` is the unchanged **expected** old
result, not falsely presented as fresh JSON emitted by the checker:
default stdout is only the PASS line. Its equality check, the actual
zero exit and inspected code connect the recorded measurements to those
expected exact values. Source binding to an old compiler receipt within
that script is separate from the fresh compilation in Section 3.

### 4.1 Joint \(X=\mathbb P^2\) correspondence, not marginal products

This example has \(B=\mathrm{pt}\), two flags **sharing** \(X=\mathbb
P^2\), multiplicities \(2,3\), and ring
\(\mathbb Q(\lambda,s,t,c_0,c_1,c_2)[h]/(h^3)\).
It is a different example from the \(W=\mathbb P^2,\ X=\mathbb P^1\)
coefficient below. Write
\[
a_{10}=-\lambda/2,\quad a_{20}=-\lambda/3,\quad
\nu_1=-h/2,\quad\nu_2=-h/3,\quad C=c_0+c_1h+c_2h^2.
\]
The push in code is the \(h^2\) coefficient, computed by the second
derivative at zero divided by two. It checks, as an exact rational
identity, the joint push of
\(C/((a_{10}+\nu_1-s)(a_{20}+\nu_2-t))\) against the full double
Taylor/moment sum with \(0\leq j,k\leq2\). The remainder is **0** for
arbitrary symbolic \(c_0,c_1,c_2,\lambda,s,t\) in the rational-function
setting. Derivatives act on the two dummy kernels, not on \(C\).

For \(C=1,\lambda=1,s=t=0\), the joint integrand is
\(6(1+h)^{-2}=6-12h+18h^2\) modulo \(h^3\), hence its push is **18**.
The separate pushes of \(-2(1+h)^{-1}\) and
\(-3(1+h)^{-1}\) are \(-2,-3\), whose product is **6**.
Thus products of marginals do not replace joint moments.

This is **not a manuscript counterexample**. The exact primary source
explicitly prescribes the joint data and independent dummy variables,
and the old report itself disclaims that attack at lines 346–347.
The calculation diagnoses a hypothetical incorrect replacement, not a
false assertion present in that manuscript.

### 4.2 One admissible degree-one \(W=\mathbb P^2\) coefficient

Here \(B=\mathrm{pt}, E=\mathbb C^2, W=\mathbb P^2, X=\mathbb P^1\),
the integral label is \((0,1)\), and \(\lambda\) is inverted. In the fixed
basis \((1_B,1_X,h_X)\), the target computation uses
\(p^2(p+\lambda)=0\), and the push of an integrand \(f(q)\) is
\[
f(-\lambda)/\lambda^2+f'(0)/\lambda-f(0)/\lambda^2.
\]
For the three spanning polynomial insertions it verifies
\[
S_W^{(1)}P(p)=-\frac{P(p-z)}{(p-z)^2(p+\lambda-z)}.
\]
It constructs the fixed \(X\) two-point term, extracts the regular
constant shift from \(zS_W^{(1)}1\), subtracts the block term and obtains
\[
u^{(1)}=(\lambda^{-2},-\lambda^{-2},0),\qquad
r(z)=
\begin{pmatrix}
0&-\dfrac{2\lambda+z}{\lambda^2(\lambda+z)^2}
 &\dfrac1{\lambda(\lambda+z)}\\
-\dfrac1{\lambda^2(\lambda-z)}&0&0\\
\dfrac1{\lambda^2(\lambda-z)^2}&0&0
\end{pmatrix}.
\]
With
\[
g=\operatorname{diag}\left(\lambda^{-2},
  \begin{pmatrix}-\lambda^{-2}&\lambda^{-1}\\
                  \lambda^{-1}&0\end{pmatrix}\right),
\qquad M^*=g^{-1}M^Tg,
\]
the exact checked identities are:

* \(r(z)\) has no pole at \(z=0\) over \(\mathbb Q(\lambda)\).
* \(r(-z)^*+r(z)=0\), the **degree-one/first-order** symplectic identity,
  not the full nonlinear all-degree identity.
* The translation is
  \[
  x(z)=\left(
  (\lambda+z)^{-2}-\lambda^{-2},
  -\frac z{\lambda^2(\lambda-z)},
  \frac z{\lambda^2(\lambda-z)^2}\right)^T
  =z\,r(z)(1,1,0)^T.
  \]
* \((r(w)^*+r(z))/(w+z)\) is regular at the origin and equals the
  independently assembled end-to-end leg-Euler bridge matrix.
* Ends assembled using \(a_X=\lambda+h,\ a_B=-\lambda-h\),
  \(e_B=\lambda^2,\ e_X=\lambda+h\), and twice-pointed moving Euler
  \(\lambda^2(\lambda+h)\) agree with the extracted background.

Symplectic, translation, end and bridge residuals are exactly zero
matrices of the recorded sizes. These comparisons are algebraically
substantive: the end/bridge expressions use the leg inputs rather than
merely defining themselves to equal the matrix residual. Nevertheless,
both constructions use asserted geometric inputs.

### Geometric input fidelity, not disguised computational derivation

The old report's “Exact evidence” discussion, lines 587–625, supplies the
meaning of those inputs. The checker itself does **not** construct the
following moduli or prove their cotangent/Euler formulas:

1. The ambient degree-one evaluation space is
   \(\operatorname{Bl}_{\Delta}(\mathbb P^2\times\mathbb P^2)\), with
   \(\psi_2=p_1-p_2\), and its birational evaluation pushforward is the
   fundamental class. The old report explains the cotangent formula:
   universal-line cotangent \(-2p_2-c_1(S)\) plus collision divisor
   \(p_1+p_2+c_1(S)\) gives \(p_1-p_2\). Its incidence/blowup description
   is consistent with the exceptional choice of a line when the two
   evaluation points collide. There is no mismatch between that prose
   and `integrand = P(q)/(z-p+q)`. The program assumes the birational
   pushforward, rather than calculating the blowup geometry.
2. The fixed space is
   \(\overline M_{0,2}(\mathbb P^1,1)=\mathbb P^1\times\mathbb P^1\)
   with \(\psi_2=h_1-h_2\). This agrees with the polynomial used in its
   truncated descendant sum; \(h_i^2=0\) makes that sum finite.
   Again the code does not derive this moduli identification.
3. The inverse Euler twist is \(\lambda^{-2}\), as in the old report.
   This is consistent with the fixed normal
   \(N_X=\mathcal O(1)\otimes\mathbb C_\lambda\):
   a degree-one map has two sections and no \(H^1\), with this scalar
   weight. The code inserts the twist and twisted metric as formulas.
   Its leg factor \(\lambda^2(\lambda+h)\) is exactly the \(m=1\),
   rank-two trivial-bundle specialization of old equation (1a), not
   a computational derivation or test for every multiplicity.

Thus the inputs have inspected, coherent prose bases in the old report;
the calculation is a **conditional exact coefficient check**, not
independent geometric derivation or a fabricated all-degree proof.
No specific contradiction in these bounded input formulas was found.
Independent assessment of their geometric interpretation, and of the
general gluing claims, remains outside what the compiler/checker certifies.

## 5. Sole live Jacobian replay of the archived 3-by-3 example

The exact current operation contract was inspected once and saved in
`replay/jacobian/contract.stdout.json`: operation
`matrix.symbolic.multiply.compute`, server **0.14.0**, protocol
**2025-11-25**. It computes a row-column product over one shared ordered
\(\mathbb Q(t_1,\ldots,t_n)\), using canonical sparse rational
numerator/monic denominator entries and compatible nonempty bounded
matrices. No other operation or search was run by this unit.

The copied payload is byte-identical to old `jacobian_payload.json`,
SHA-256 `1fd00d3b63f48e67ac76ba1715cf623947118ed284af37376ba15a8bdd0703c4`.
The historical status also reports adapter exit 0 with a 75-second
timeout bound, finished `2026-11-05T14:07:40.479543+00:00`; its typed
output is the identity, with server runtime 23 ms and the same
server/protocol versions. The old default checker checks that archived
request/result correspondence; it does not itself call the live server.
The single actual run used the required adapter interpreter:

```text
$WORKSPACE/argus-live-update/.venv/bin/python
  -m argus_skill.tools.jacobian run
  --operation matrix.symbolic.multiply.compute
  --payload-file <current-root>/research/draft_reviews/finite-moments/replay/jacobian/payload.json
  --timeout 75
```

Actual exit **0**, empty stderr, no structured error, no timeout;
adapter wall time **3,250 ms**, server-reported runtime **22 ms**.
Raw typed JSON is preserved without reformatting as
`replay/jacobian/run.stdout.json`; exact command and status are in
`run.status.json` and `adapter_status.json`. These include the actual
server/protocol metadata and the 75-second adapter/110-second outer
bounds. No timeout/UNKNOWN/error was converted into a conclusion, and
there was **no second live run**.

The input and result are
\[
A=\begin{pmatrix}t&1&0\\0&t&1\\0&0&t\end{pmatrix},\qquad
B=\begin{pmatrix}t^{-1}&-t^{-2}&t^{-3}\\0&t^{-1}&-t^{-2}\\0&0&t^{-1}\end{pmatrix},
\qquad AB=I_3.
\]
The independent decoder in `replay/replay_evidence.py` reconstructs
exact SymPy rationals from the typed sparse data. All entries of
`left*right-returned`, `returned-I_3` and `returned-archived_product`
are zero. The returned mathematical typed matrix equals the archived
typed matrix exactly; the entire receipt is not required to match its
historical runtime. Results are in
`replay/jacobian/independent_comparison.json`.

This illustrates \(A=tI+J\), \(J^3=0\), in the commutative subalgebra
generated by \(J\) and scalar matrices over \(\mathbb Q(t)\). The full
matrix ring is not commutative and is not directly the arbitrary
`CommRing` instance of the Lean theorem. The live example proves neither
all orders nor a geometric tangent-class claim; that distinction avoids
using one matrix test as a universal proof.

## 6. Per-assertion support, obligations, attribution, and novelty

The accompanying `verdict.json` gives separate support/open status for
each theorem, the matrix, the joint example, the degree-one algebra,
its geometric inputs, and the manuscript-scope statement.

* **Six algebra statements:** standard finite geometric-series,
  linearity and multilinearity identities; inspected proofs and
  successfully replayed formalization. No internal algebraic gap was
  found under the exact hypotheses. Independent statement-fidelity
  acceptance remains pending.
* **Matrix and joint example:** exact bounded reproductions of old
  Argus computations, not additional universal proofs or new
  contributions. The 18-versus-6 comparison does not attack a literal
  manuscript assertion.
* **Degree-one checks:** exact agreement of the specified rational
  formulas, conditional on the old geometric inputs assessed above.
  The code never proves those inputs merely by labelling its output
  “geometry.”
* **Outstanding geometric bridge:** one must actually identify the
  joint pushed correspondences, prove geometric nilpotence and
  projection/virtual-gluing compatibility, and supply any super signs
  before using the six algebra theorems in the all-degree argument.
  This is concrete missing scope of these certificates, not evidence
  that the surrounding geometry is false.
* **Beyond this unit:** arbitrary nontrivial base/bundle, all integral
  labels and completions, every leg multiplicity, all-degree common
  \(R\), all-genus ancestors, Virasoro transfer and complete-intersection
  sewing are not established by these finite replays. Their existing
  prose assessments belong to the other indexed units. This unit is
  not family completion.

Attribution is to the existing Argus Family 065 draft/checker and its
unchanged formal source; this worker produced reproduction evidence
and an assessment, not the original mathematical claims. The algebra is
known, and its Lean proof explicitly relies on standard Mathlib
sum/multilinear identities. No verified novelty is attributed to the
matrix or coefficient examples, and no new originality investigation
was undertaken. Any stronger old geometric contribution or arbitrary-\(E\)
strengthening is outside this unit's novelty judgement; successful
replay does not establish its novelty. There is no verified new
manuscript error here.

## 7. Ledger isolation and official current-root checks

Only native registration of `C_REPLAY_ALG` v1 and its real compiler
evidence changed this worker's current ledger records. No judgement was
added and no claim was self-accepted. `C_REVIEW` is unchanged, with
**no mechanical evidence**, as recorded before/after in
`replay/preservation_check.json`. Neither an old nor the new algebra
certificate was attached as mechanical evidence for review completeness.
The index and graph were not modified; the graph still has seven open,
unconfirmed assessment nodes.

After **each** ledger write, both required official checks were run
against the explicit current root using
`$WORKSPACE/argus-latest/.venv/bin/python`. They were run once
more at the end of replay work:

```text
python -m argus_skill.verticals.math.math_state check --project-root <current-root>
python -m argus_skill.verticals.math.proof_graph_check check --project-root <current-root>
```

Here `python` denotes that explicit latest interpreter, not PATH lookup.

| Stage | `math_state check` exit | `proof_graph_check check` exit |
|---|---:|---:|
| After auxiliary registration | **0** | **0** |
| After fresh compiler evidence recording | **0** | **0** |
| Final current-root checks | **0** | **0** |

Every math-state stdout is `{"ok": true, "issues": []}`; graph stdout is
`proof graph valid: 7 node(s)`. Exact commands, root, times, stdout,
stderr and exits are under `replay/checks/{post_registration,post_lean,final}/`.
These are structural/evidence-binding checks, **not acceptance of the
unit, the family review, or a manuscript**. All mathematical commands
were expected to finish under two minutes and did so; no background
agent or Reviewer was spawned.

This assigned unit's evidence and assessment are ready for the
Host-invoked independent Reviewer. Final acceptance remains pending.
