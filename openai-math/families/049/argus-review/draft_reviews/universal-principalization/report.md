# Universal principalization — engineering assessment

**Claim:** `C_GLOBAL_PRINCIPAL`, version 1, ledger content hash
`7b6c137d55a52efaad967d056719c3a8397f800def0af62bea0804f0fb5843df`.
**Engineering verdict:** supported in its stated algebraic scope.
**Independent review required:** yes. This assessment grants no acceptance.

## Contract, sources, version, and attribution

This assesses exactly Theorem 1 of the old engineering draft, not the entire
October manuscript or its geometric obstruction. The governing contract is the
current `OBJECTIVE.md` and the unit assignment in `research/DRAFT_REVIEW_INDEX.json`.
Historical ledger verdicts and Reviewer labels are inputs, not authority.

Paths below use:

- `SC = families/049/first-pass/stable_core_certificate`
- `FS = SC/formal_sources/OAI/AlgebraicGeometry/StableCoordinate`

The preserved draft is `SC/report.md`, §1, SHA-256
`68b969f393762d6b834c6b0e03ce5a1eb82a2e8944c97af14313184acecbd875`.
Its exact formal statement is `IndependentStableCore.universal_principalization`
in `SC/Main.lean:17–59`. The old ledger and graph assign this algebraic
extension to `C_GLOBAL_PRINCIPAL`; this report does not adopt their status labels.

The comparison source is OpenAI, *A stable coordinate that is not a coordinate
in four variables*, October 5, 2026, `sections/04-bundle.tex`, lemma
`bun:principalization`, at source revision
`4eaee87548250b2682affda7d05d947c05554bae`. Its SHA-256
`332df2ac44774e20ab0c4b4d988c1274c7579b9ae0f4d1112199b4f50b217414`
was checked against campaign 9100049's existing `MANUSCRIPTS.json`.
That source proves the particular principalization over its field-based
determinant domain by localization and a boundary argument. The arbitrary-ring,
arbitrary-`t` witnesses assessed here belong to the old Argus engineering
draft; they should not be attributed as a printed theorem of that manuscript.
The supporting OAI Lean implementation is reused, not an independent new result.

## Exact claim

Let \(R\) be any commutative ring with identity, with no nontriviality,
domain, characteristic, or reducedness assumption. For
\(a,d,b,c,t\in R\) satisfying \(ac-bd=1\), put
\[
 s=dc-abt,\quad v=a^2t-d^2,\quad f=t-s^2,\quad g=bd-sab.
\]
Then the ordinary ideals, not merely their radicals, satisfy
\[
 (f,g)=(v).
\]
Here \(t\) is arbitrary. In particular neither an auxiliary variable nor a
specific polynomial \(ab+u^2\) is a hypothesis.

## Checked argument

Write \(H=ac-bd\) and \(\rho=H-1\), and set
\[
 A=c^2-b^2t,\qquad r=a^2(ac-3bd),\qquad
 q=d^2(3ac-bd)+rt.
\]
Expansion in the free **integer** polynomial ring gives
\[
 \begin{aligned}
 f-Av
 &=t\{1-a^2c^2+2abcd-b^2d^2\}
   =t(1-H^2)=-t\rho(\rho+2),\\
 g-b^2v&=bd(1-H)=-bd\rho,\\
 rA+qb^2
 &=a^3c^3-3a^2bc^2d+3ab^2cd^2-b^3d^3=H^3.
 \end{aligned}
\]
These also verify the signs of both residuals in the old draft. Under the
single hypothesis \(H=1\), they become
\[
 f=Av,\qquad g=b^2v,\qquad rf+qg=(rA+qb^2)v=v.
\]
The first two identities give \((f,g)\subseteq(v)\); the last gives
\((v)\subseteq(f,g)\). No factor was cancelled and no denominator was
introduced. The integers 2 and 3 are coefficients, not quantities to be inverted.
Thus substitution proves the claim in every characteristic and in rings with
zero divisors or nilpotents.

The zero ring is genuinely included: Lean's `CommRing` hypothesis does not
include `Nontrivial`, and when \(0=1\) every displayed identity and both ideal
inclusions remain valid. There is no implicit appeal to a point or a proper
prime ideal in that case.

The boundary \(a=0\) is retained even over a non-domain. The determinant
identity gives \(bd=-1\); hence \(g=-1\), \(v=-d^2\), and
\((-b^2)v=b^2d^2=1\). Both ideals are then the unit ideal. This boundary
calculation corroborates, but is unnecessary for, the global witnesses.

For the October specialization let
\[
 C=k[a,d,b,c,u]/(ac-bd-1),\qquad
 (x,y,z,u)=(ab,dc,db,u),\qquad t=ab+u^2.
\]
Then \(s=dc-ab(ab+u^2)\), and \(f,g\) are the images of
\(x-s_B^2+u^2,\ z-s_Bx\), where \(s_B=y-x(x+u^2)\).
The image ideal is therefore \((a^3b+a^2u^2-d^2)\).
This substitution is an algebraic consequence; the theorem alone does not
prove that \(B\to C\) is injective or that a base action lifts.

## Dependency and evidence map

| Obligation | Inspected source/evidence | Engineering assessment |
|---|---|---|
| Universal quantification and exact ideal equality | `SC/Main.lean`, `IndependentStableCore.universal_principalization` | Supported: `[CommRing R]`, arbitrary five elements, only `hdet`; no `IsDomain` or `Nontrivial`. |
| Signed residuals and reverse inclusion | `SC/report.md` §1 (4)–(6); `Main.lean` local facts `hf`, `hg`, `hv` | Supported by the expansions above and both explicit ideal inclusions. |
| Symbolic local algebra | `SC/exact_certificate.json`, checks `global_f0_factor`, `global_g0_factor`, `global_bezout`, `global_reverse_ideal`; `SC/verify.py:151–165` | Relevant exact identities; not a substitute for quantifier/statement inspection. The common replay is assigned to the coordinator. |
| Undeleted boundary | Same certificate, `boundary_a_zero_g0`, `boundary_a_zero_v_unit` | Supported algebraically without deleting a component. |
| Particular October principalization | `FS/ObstructionPrincipalization.lean`, `map_I_eq_span_v`, `baseMap_factor_of_mem_I`; imported `BundlePrincipalization.lean` | Existing specialized proof, not another mathematical unit. |
| Base-map injectivity | `FS/BundleCharts.lean`, `baseMap_injective`; `ObstructionPrincipalization.lean`, `baseMap_injective` | A separate proved ingredient; it is not asserted by the universal ideal theorem. |
| Source comparison | October `04-bundle.tex`, `bun:principalization` | The old manuscript uses \(t=ab+u^2\), a field-based domain, an \(a\)-chart, and primes containing \(a\). |

### Formal evidence boundary

The existing source-bound compiler record
`SC/lean_verification_result.json` and certificate
`SC/certificates/C_STABLE_CORE_VERIFY-1f2393b585c126fe.json` record Lean
4.31.0, commit `68218e876d2a38b1985b8590fff244a83c321783`, in the
Mathlib v4.31.0 workspace, Lake `5.0.0-src+68218e8`, exit 0,
`proof_holes=[]`, and axiom-audit exit 0.
For this declaration the printed axioms are only `propext` and `Quot.sound`.
The certificate's main subject is composite claim `C_STABLE_CORE_VERIFY`
version 3, not an additional formalization of every prose conclusion.

Read-only fingerprint checks in this assessment verified:

| File | SHA-256 |
|---|---|
| `SC/Main.lean` | `fea7d30d06349b4e15bc63852970443a958b8e4f99e38ac09a8897f7a27bb916` |
| `SC/statement_fidelity.md` | `683a28a67564cb14f2809d0e8844ff0ce781a563c205df47eb2ec7e0d84df0ed` |
| `SC/exact_certificate.json` | `104d3503ab1d34038b0d5a9a2dc633a6a223769866f4107570a3aa51815799c9` |
| archived compiler certificate | `f93ec4e9eb00260bdfef04b169e6274fbcc6a60a2025f8813e4f100dc82e979c` |

The current Main/fidelity hashes match the archived compiler record; the
certificate's embedded source and fidelity text also match byte for byte.
This is honest use of an **old source-bound run**, not a claim that this
assessor freshly compiled Lean. Fresh Main compilation and the common
81-check replay are separately assigned; neither was duplicated here.
The `statement_fidelity.md` description of this declaration agrees with its
actual binder list and conclusion.

## Components, gaps, and significance

| Component | Verdict | Limit |
|---|---|---|
| Exact ideal equality over every commutative unital ring, including the zero ring | supported | No mathematical gap found in this component. |
| Explicit, denominator-free witnesses and arbitrary \(t\) | supported | A real expansion of scope relative to the source-verified October lemma. |
| Full geometric bundle/action conclusions from this identity alone | partial | The identity proves only ideal principalization; injection, bundle charts, domain facts, and action lifting are separate dependencies. |
| Global novelty or publishability | unresolved | **Novelty: `not_asserted`.** Only the comparison with the cited October version was verified. |

There is no invalid algebraic component identified. External mathematical
hypotheses are exactly commutativity, an identity, and \(ac-bd=1\).
The formal evidence additionally trusts the Lean kernel and its imported
library; no extra mathematical axiom appears in the archived printed axiom
list. The larger manuscript and the whole old-draft review are not certified
by this unit. Final independent review and acceptance remain with the Host.
