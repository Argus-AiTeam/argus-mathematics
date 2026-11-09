# Trace-character: Engineer review of the existing draft

**Role:** Engineer evidence analyst, not the native independent Reviewer.  
**Assessment date:** 2026-11-07.  
**Classification:** reproduction/formal verification, a failed residue-field
shortcut, and a possible abstract generalization; **novelty is not asserted**.  
**Native independent acceptance:** pending; this report does not self-accept.

## 1. Scoped finding

The existing draft supports the **conditional, universal algebra theorem**
`RootCharacter.root_character_of_class`. Its argument retains nilpotents,
constructs the elementary-kernel working quotient, proves both required lift
existence statements, and constructs the character for both cyclic and symmetric
residual image. Character existence is a conclusion, not a disguised hypothesis.
The finite tests are supplementary, not the proof.

This is **partial support for the manuscript's full root-character lemma**:
the formal theorem assumes the operator identities and parity conclusions that
the manuscript must first establish, and does not construct its arithmetic
finite unramified quotient. Neither `D_TRACE_INPUTS`, `D_COEFFICIENTS`, nor any
downstream converse, density, or mean-rank main theorem is established here.
No counterexample to the manuscript has been obtained.

| Scope | Engineer finding |
|---|---|
| Abstract trace-to-character theorem under the listed identities | Supported |
| Split-square invariance and elementary residual kernel | Supported |
| Order-three and normalizing-transposition lift existence | Supported, not assumed in the main theorem |
| Both residual images, with nonreduced coefficients retained | Supported |
| Historical Lean compilation of the exact preserved source | Supported historical evidence; not a fresh run |
| Translation of the conditional algebraic conclusion | Supported |
| Entire arithmetic manuscript lemma, including its inputs and ramification | Partial |
| Residue-field shortcut as a replacement for the coefficient algebra | Unsupported/failed |
| `D_TRACE_INPUTS`, `D_COEFFICIENTS`, downstream main theorems | Not established by this draft |

## 2. Inputs, source attribution, and evidence binding

All paths beginning `old/` below abbreviate
`campaigns/9000006/`.
The reviewed unit is `old/research/trace-character/`.

Read: its principal `report.md`, all of `Main.lean`, `verify.py`,
`exact_certificate.json`, historical `lean_check.json`, `compile.log`,
`lean-submission.json`, the certificate
`certificates/V_TRACE_CHARACTER-890c4fddf20553a9.json`, both Jacobian discovery
records, the typed Jacobian contract, payload, and output. The two
`statement-fidelity.md` / `statement_fidelity.md` spellings are byte-identical:
one body was read, both paths were compared, and the certificate's embedded
body was checked against the preserved file.

The parent has already verified the full snapshot/manifest inventory and the
old ledger's version binding. Those checks were not repeated, and no old
ledger was reread or changed. The certificate itself was inspected:

- Subject: claim `V_TRACE_CHARACTER`, content hash
  `a6feb70abd47185b638ce227c8600086105516b6aa81d97b140f61189fc0b3ac`
  (v2, not empty-formal-source v1).
- Mechanical evidence: `lean-V_TRACE_CHARACTER-199c5fb5b450`,
  tier `mechanical`, verdict `supports`.
- Its embedded Lean source equals preserved `Main.lean` byte-for-byte; SHA-256:
  `63b99f14eefaf1b0bb01946be0f0d5c6b50760e7058873011c4cc0655d243641`.
- Its embedded fidelity document equals the preserved document; SHA-256:
  `b461b2452ceaae12d5278b798d37d8fa21fd3b919eb398c2f7787767e2001fe6`.
- Its `lean_check` object equals standalone `lean_check.json` exactly.
- Per the parent's completed version reconciliation, historical independent
  evidence `judgement-V_TRACE_CHARACTER-016f1d822e6f` also binds that v2 claim
  hash. This is historical supporting judgment, not native acceptance of the
  present review or of family completion. Historical graph labels cannot
  override this version-bound evidence.

### Manuscript reference

`old/research/openai_manuscript` is a directory containing manuscript symlinks,
not a metadata JSON file or a separate Argus draft. Its density-manuscript
symlink resolves to
`openai-math/preprints/Goldfelds-analytic-density-conjecture-and-the-2-converse-for-elliptic-curves-October-7-2026`.

The reference manifest is
`campaigns/9100006/MANUSCRIPTS.json`,
revision `4eaee87548250b2682affda7d05d947c05554bae`. The specific
`build/sections/06-traces.tex` reached through the old symlink has SHA-256
`40d5a0ed9e1873c86a07680021120deb429e19e46c8e24409b269c31489d541f`,
exactly the manifest's hash. Thus no different staged revision was encountered
for this passage. The symlink itself is not an immutable historical checkout;
the content-hash match is the basis for the present source-fidelity claim.

The necessary source passages are:

- Lines 310–365: characteristic-zero systems, integral Fourier lattice,
  finite-accuracy continuity, and the **whole reduced operator orbit**.
- Lines 368–416, Lemma `tc:trace-algebra`: trace identities, fresh-prime
  coefficient tests, and persistence under further tests.
- Lines 644–751, Lemma `tc:root-character`: nilpotents, parity assertions,
  elementary factorization, character construction, and ramification.

The manuscript already supplies the trace-character structure, coinvariant
argument, cyclic/symmetric cases, and explicit warning against discarding
nilpotents. Argus supplies a formal reconstruction, explicit algebraic lift
formulas, and finite adversarial tests. Its arbitrary-group/ring formulation
may be an abstract strengthening of the fixed finite-stage proof, but is not
presented here as a new theorem or a literature novelty claim. Refuting the
old field-reduction route does not refute this manuscript.

## 3. Exact mathematical statement and quantifiers

Let \(G\) be any group, \(A\) a commutative ring with Lean instance
`CharP A 2`, \(\pi:G\to D_3=\mathrm{DihedralGroup}(3)\) a homomorphism,
and \(t:G\to A\). There is no finiteness assumption on \(G\) or \(A\), nor
a field, domain, reducedness, localness, or faithful-representation assumption.
`CharP A 2` specifies characteristic exactly two; it does not include the
zero ring. A zero operator algebra, if relevant to a zero vector, is a
separate trivial case rather than a case of that literal Lean hypothesis.

In the convention used, `r i` acts on \(\mathbf Z/3\) as \(x\mapsto x+i\)
and `sr i` as \(x\mapsto-x-i\). Split means residual identity, root means
`r 1` or `r 2`, and simple means one of the three `sr i`.

The hypotheses are, with the displayed quantifiers applying to **all**
elements, not only Frobenius representatives or coefficient 1:

1. \(\forall c,x,\ t(cxc^{-1})=t(x)\).
2. \(t(1)=0\).
3. \(\forall x,y,\ t(x)t(y)=t(xy)+t(xy^{-1})\).
4. \(\forall x,\ \pi(x)=1\Rightarrow t(x)=0\).
5. \(\forall x,\ \pi(x)\in\{r1,r2\}\Rightarrow t(x)^2=1\).
6. \(\forall x,y,\ \pi(x),\pi(y)\text{ simple}\Rightarrow t(x)t(y)=0\).
7. \(\exists g,\ \pi(g)=r1\).

The image of \(\pi\) is then the rotation subgroup \(C_3\) or all of \(S_3\).
Surjectivity onto \(S_3\) is not required. In matching parity the manuscript's
vanishing of every nonroot implies hypotheses 4 and 6; in opposite parity its
split vanishing and two-simple product rule give exactly those hypotheses.
Simple traces in opposite parity are **not** assumed zero.

Conclusion:
\[
 \exists\alpha:G\longrightarrow A^\times\text{ a homomorphism},\qquad
 \forall g,\ \alpha(g)^2=1,\qquad
 \forall g\text{ root},\ (\alpha(g):A)=t(g).
\]
“Order two” means exponent **dividing** two: nontriviality or exact order two
is not proved. The conclusion does not identify \(\alpha\) with \(t\) on
nonroots. It does not assert uniqueness, canonicity, continuity, finite image,
or an arithmetic ramification bound for arbitrary \(G,A\).

## 4. Decisive universal argument

### 4.1 Split squares and the quotient

For split \(u\), apply the product identity to \(xu,u\). Since \(t(u)=0\),
\[
 0=t(xu^2)+t(x),\qquad t(xu^2)=t(x).
\]
Let \(K\) be the subgroup generated by squares of elements of \(\ker\pi\),
**not** by all squares in \(G\). Conjugating a generator gives another
kernel square, so \(K\) is normal. Invariance under its generators extends
to products and inverses, and \(K\subseteq\ker\pi\).

`Main.lean:36–109` proves these facts. Its separate
`square_subgroup_factorization` declaration states the subgroup inclusion,
containment of the squares, and trace invariance; the descended trace on
the particular quotient \(G/K\) is a mathematical consequence of those facts,
not a separately named quotient construction in that declaration.

The main formal proof instead explicitly uses the possibly larger subgroup
\[
 N=\{u:\pi(u)=1,\ \forall x,\ t(xu)=t(x)\}.
\]
It proves \(N\) normal and containing all kernel squares. In
`root_character` it constructs \(Q=G/N\), the descended residual map \(p\),
and descended trace \(v\) using quotient lifts, checks all `TraceData`
identities on \(Q\), and proves
\(\forall a\in\ker p,\ a^2=1\). This elementary-kernel property is **derived**,
not assumed for the original group. Every exponent-two group is abelian,
since \((ab)^{-1}=ab=b^{-1}a^{-1}=ba\); `kernel_comm` supplies this step.

### 4.2 Order-three lift

Work in \(Q\) and denote its elementary residual kernel by \(H\).
If \(g\) maps to `r 1`, then \(g^3\in H\), hence \(g^6=1\).
The formula \(R=g^4\) gives \(\pi(R)=r1\), \(R^3=1\).
The nonidentity residual image also ensures its actual order is three.
`rotation_lift` proves the formula without a finite-group classification
or an imported splitting theorem.

The trace identity at \(1,R\) gives \(t(R^{-1})=t(R)\). Since
\(R^2=R^{-1}\), its application at \(R,R\), together with \(t(R)^2=1\),
gives \(t(R)=1\). The source uses \(R,R^2\) instead; both arguments have
the same content and preserve the coefficient algebra.

### 4.3 The kernel character

Define \(\beta(a)=t(aR)\) for \(a\in H\).
The identity at \(a,R\) and split vanishing give
\(t(aR^2)=t(aR)\). For \(a,b\in H\), the second term in the product
identity for \(aR,bR\) is split and vanishes. Put
\(c=aRbR^{-1}\in H\). Then
\[
 \beta(a)\beta(b)=t(cR^2)=t(cR)=t(aRb)
                =t(baR)=t(abR)=\beta(ab).
\]
The cyclic trace identity and commutativity of \(H\) justify the last
equalities; this is not an assumed coinvariant character. Root squares
give \(\beta(a)^2=1\), and the class identity makes \(\beta\) invariant
under conjugation by \(R\).

### 4.4 Normalizing transposition lift, without an involution assumption

In the \(S_3\) case choose an arbitrary \(x\) mapping to `sr 0` and set
\[
 a=xRx^{-1}R,\quad b=R^{-1}aR,\quad c=R^{-2}aR^2,\quad s=bx.
\]
Here \(a,b,c\in H\). Since \(aR^{-1}=xRx^{-1}\) has cube one,
\(abc=1\). Commutativity in \(H\) and \(b^2=1\) yield
\[
 sRs^{-1}=bacR^{-1}=R^{-1}.
\]
This is precisely the constructive `normalizer_lift` proof
(`Main.lean:134–163`). It assumes the already-proved elementary-kernel
property and an arbitrary residual transposition preimage, **not** the
normalizer lift it is required to produce. A transposition in the image
can be adjusted by a rotation to have image `sr 0`.

The lift \(s\) need not have order two. It has \(s^2\in H\), potentially
nontrivial. Class invariance and equality of the two root cosets give
invariance of \(\beta\) under \(s\). The two-simple product identity at
\(s,sR\) gives
\[
 0=t(s)t(sR)=t(s^2R)+t(R)=\beta(s^2)+1,
\]
so \(\beta(s^2)=1\). This kills the actual extension obstruction; assuming
\(s^2=1\) instead would have been an unjustified shortcut.

### 4.5 Assembly, both residual images, and units

Use the section \(\sigma(r i)=R^i\),
\(\sigma(sr i)=sR^i\), with \(i=0,1,2\).
Its multiplicative defect is 1, except for two simple arguments, when
it is \(s^2\). Both defects have \(\beta\)-value 1. Its conjugation action
also preserves \(\beta\). Thus
\[
 f(g)=\beta\bigl(g\sigma(\pi(g))^{-1}\bigr)
\]
is multiplicative. The formal `assemble_character` checks this calculation,
and `elementary_character` supplies all its section/cocycle hypotheses
rather than leaving them as assumptions of the final result.

If there is no transposition preimage, the formal proof shows that every
residual image is a rotation and uses only the three rotation section
values. This covers \(C_3\), not merely the \(S_3\) case with an implicit
surjectivity assumption.

Root-coset equality follows from the section and
\(t(aR^2)=t(aR)\). Since \(f(g)^2=1\), each value is its own inverse,
so `root_character` constructs the required homomorphism to `Aˣ`.
The quotient by its kernel has exponent two; in the finite-input case
it is a finite elementary abelian group. No passage to a residue field
or a reduced quotient occurs at any step.

### 4.6 Ramification: the exact formal limit

`pullback_unramified` proves only
\(\rho(u)=1\Rightarrow(\alpha\circ\rho)(u)=1\).
This preserves a **supplied** inertia-killing condition. It contains no
Galois groups, inertia subgroups, topology, or finite-quotient existence
theorem. A supplied continuous map from \(G_{\mathbb Q}\) to a finite group
killing inertia outside \(S\cup U\) gives, by ordinary pullback and Galois
correspondence, a finite elementary extension with that support. The
continuity, finite-image input, and Galois-correspondence interpretation
are not formalized by these declarations.

Accordingly there is no internal quotient/lift-existence gap in the
abstract proof. The genuine fidelity boundary is the arithmetic
realization of its assumptions, not an assumed character in Lean.

## 5. Exact formal declarations and historical compiler evidence

These are declaration types from the preserved source, in namespace
`RootCharacter`; proof bodies are omitted here, not replaced by axioms.
Ambient variables are exactly:

```lean
variable {G A : Type*} [Group G] [CommRing A] [CharP A 2]
variable {π : G →* D3} {t : G → A}
```

`D3 := DihedralGroup 3`,
`IsRoot q := q = r 1 ∨ q = r 2`, and
`IsSimple q := ∃ i, q = sr i`.

```lean
structure TraceData (π : G →* D3) (t : G → A) : Prop where
  one : t 1 = 0
  cyclic : ∀ x y, t (x * y) = t (y * x)
  product : ∀ x y, t x * t y = t (x * y) + t (x * y⁻¹)
  split : ∀ x, π x = 1 → t x = 0
  root : ∀ x, IsRoot (π x) → t x ^ 2 = 1
  simple : ∀ x y, IsSimple (π x) → IsSimple (π y) → t x * t y = 0

theorem square_subgroup_factorization (T : TraceData π t) :
    kernelSquares π ≤ π.ker ∧
      (∀ u, π u = 1 → u ^ 2 ∈ kernelSquares π) ∧
      ∀ u ∈ kernelSquares π, ∀ x, t (x * u) = t x

lemma rotation_lift (e2 : ∀ a : G, π a = 1 → a ^ 2 = 1)
    (hrot : ∃ g, π g = r 1) : ∃ R : G, π R = r 1 ∧ R ^ 3 = 1

lemma normalizer_lift (e2 : ∀ a : G, π a = 1 → a ^ 2 = 1)
    {R x : G} (hR : π R = r 1) (hR3 : R ^ 3 = 1) (hx : π x = sr 0) :
    ∃ s : G, π s = sr 0 ∧ s * R * s⁻¹ = R⁻¹

theorem elementary_factorization (T : TraceData π t) :
    ∃ N : Subgroup G, N.Normal ∧ N ≤ π.ker ∧
      (∀ u, π u = 1 → u ^ 2 ∈ N) ∧
      ∀ u ∈ N, ∀ x, t (x * u) = t x

theorem root_character (T : TraceData π t) (hrot : ∃ g, π g = r 1) :
    ∃ α : G →* Aˣ, (∀ g, α g ^ 2 = 1) ∧
      ∀ g, IsRoot (π g) → (α g : A) = t g

theorem pullback_unramified {K B : Type*} [Group K] [Monoid B]
    (ρ : K →* G) (α : G →* B) (u : K) (hu : ρ u = 1) :
    (α.comp ρ) u = 1

theorem character_quotient_exponent_two (α : G →* Aˣ)
    (hα : ∀ g, α g ^ 2 = 1) (q : G ⧸ α.ker) : q ^ 2 = 1

theorem root_character_of_class
    (hc : ∀ c x, t (c * x * c⁻¹) = t x)
    (h1 : t 1 = 0)
    (hm : ∀ x y, t x * t y = t (x * y) + t (x * y⁻¹))
    (hz : ∀ x, π x = 1 → t x = 0)
    (hr : ∀ x, IsRoot (π x) → t x ^ 2 = 1)
    (hs : ∀ x y, IsSimple (π x) → IsSimple (π y) → t x * t y = 0)
    (hrot : ∃ g, π g = r 1) :
    ∃ α : G →* Aˣ, (∀ g, α g ^ 2 = 1) ∧
      ∀ g, IsRoot (π g) → (α g : A) = t g
```

`TraceData`'s cyclic identity is equivalent to class invariance for a group;
the principal wrapper uses the proved direction `cyclic_of_class`.
The declarations' hypotheses and conclusions match the conditional algebra
read in Section 3. They do **not** prove the preceding operator bounds or
turn the manuscript's whole root-character lemma into an unconditional theorem.

The reused historical compilation record has:

- Lean **4.31.0**, `x86_64-unknown-linux-gnu`, commit
  `68218e876d2a38b1985b8590fff244a83c321783`, Release.
- Lake **5.0.0-src+68218e8**; elan **4.2.3**
  (`b6cec7e10`, 2026-06-08).
- Workspace `$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`;
  source imports `Mathlib`. No separate Mathlib commit is supplied by the
  inspected certificate, so none is invented here.
- `set_option autoImplicit false`;
  `set_option maxHeartbeats 1000000` (a heartbeat limit, not a wall timeout).
- Compiler command:
  `$WORKSPACE/.elan/bin/lake env lean old/research/trace-character/Main.lean`,
  with `old/` expanded as above and cwd the Mathlib workspace.
- Historical compiler exit **0**, audit exit **0**, `proof_holes=[]`,
  empty stderr, duration **22730 ms**. Warnings are unused-variable,
  unused-simp, or redundant-tactic lint warnings, not errors.
- Historical axiom-audit command:
  `$WORKSPACE/.elan/bin/lake env lean --run $WORKSPACE/argus-live-update/argus_skill/tools/lean_axiom_audit.lean old/research/trace-character/Main.lean`.
- The printed axiom lists for `root_character_of_class`,
  `square_subgroup_factorization`, `normalizer_lift`, and
  `character_quotient_exponent_two` are all exactly
  `[propext, Classical.choice, Quot.sound]`.
- Historical submission receipt: task `trace-character-lean-9000006`,
  run `trace-character-lean-9000006-1793884253398867591`, mode `direct`,
  timeout **600 seconds**. The receipt is submission provenance; the
  compiler/audit result is the success evidence.

No Lean source was created or modified and **no fresh Lean compiler or axiom
audit was run**. Compiler success, source binding, statement fidelity, and
arithmetic applicability are four different questions; only the first two
are mechanical historical facts.

## 6. One fresh finite replay

The old verifier was read before execution. It imports only standard-library
modules, writes no files, and offers `--emit` for stdout rather than an output
path. It was imported unchanged with bytecode disabled and its default `main()`
was called **once**. The computational invocation was:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python - <<'PY'
import contextlib, importlib.util, io, json, sys, time
from pathlib import Path
sys.dont_write_bytecode = True
old = Path('families/006/first-pass/trace-character')
spec = importlib.util.spec_from_file_location('trace_character_old_verifier', old / 'verify.py')
verifier = importlib.util.module_from_spec(spec)
spec.loader.exec_module(verifier)
sys.argv = [str(old / 'verify.py')]
stdout = io.StringIO()
start = time.monotonic()
with contextlib.redirect_stdout(stdout):
    verifier.main()
elapsed = time.monotonic() - start
# The wrapper serialized this stdout, elapsed time, and the model records
# already compared by main() to the owned finite-replay.json.
PY
```

The wrapper's serialization, not the verifier, created
`research/draft_reviews/trace-character/finite-replay.json`.
No verifier copy, bytecode, old output, ledger write, background shell, or
Jacobian adapter call was made. This bounded computation took
**0.047151338309049606 seconds** inside the wrapper, so no over-two-minute
Argus submission was needed.

**Exit status: 0.** Exact verifier stdout:

```json
{"status": "pass", "models": 6, "valid_traces_replayed": 13, "general_proof": "RootCharacter.root_character_of_class", "proof_holes": []}
```

Default `main()` asserts equality of its entire newly computed dictionary
with old `exact_certificate.json`, then checks the historical formal record's
success, exits, proof-hole list, source hash, and both fidelity spellings.
The model records in the new output are the historical records whose exact
equality with the computed records was asserted, not a second enumeration.

The four-element ring uses bit encodings \(0,1,\epsilon,1+\epsilon\).
Its ring-law loop checks 64 triples, and it explicitly checks
\(\epsilon\ne0,\ \epsilon^2=0,\ 1+\epsilon\ne1,\ (1+\epsilon)^2=1\).
For each group, all class functions in the necessary split/root/simple value
domains are enumerated. Validity tests the trace identity on every ordered
element pair. Every accepted trace undergoes square-quotient, lift, and
character reconstruction, including multiplicativity on every quotient pair.

| Model | Order | Candidates | Valid opposite | Matching subset | Nontrivial root units | Nonzero simple values | Kernel-square subgroup order |
|---|---:|---:|---:|---:|---:|---:|---:|
| `C3_x_C4` | 12 | 256 | 2 | 2 | 1 | 0 | 2 |
| `C3_semidirect_C4` | 12 | 16 | 1 | 1 | 0 | 0 | 1 |
| `S3_x_C2` | 12 | 16 | 2 | 2 | 1 | 0 | 1 |
| `A4_x_C2` | 24 | 16 | 2 | 2 | 1 | 0 | 1 |
| `S4_x_C2` | 48 | 64 | 4 | 2 | 2 | 2 | 1 |
| `SL2_F3_x_C2` | 48 | 256 | 2 | 2 | 1 | 0 | 2 |
| **Total** | — | **624** | **13** | **11** | **6** | **2** | — |

The last model is the explicit \((Q_8\rtimes C_3)\times C_2\):
its residual kernel is nonabelian before the square quotient, and rotation
acts nontrivially. Rotation also acts nontrivially in the `A4` and `S4`
models. The `C3_semidirect_C4` model has only order-four simple lifts;
`S4_x_C2` also contains order-four simple elements. The two additional
opposite-only traces on `S4_x_C2` have nonzero nilpotent simple values.
Matching counts are a subset of the 13, not another 11 distinct traces.

**Deviations and limits.** Import/stdout capture changed no algorithm or
input. The old serialized `result_class="new_theorem"` was retained for
the verifier's equality comparison but is **not endorsed** in this review's
classification. These are precisely six finite groups over one coefficient
ring, not an exhaustive search over groups, rings, nilpotence depths, or
arithmetic representations. Printed `general_proof` and `proof_holes` fields
do not mean Python compiled a theorem: that part checks an archived record.

## 7. Failed field reduction and bounded Jacobian fixture

The invalid shortcut is replacing the full coefficient algebra by its residue
field. In \(A=\mathbf F_2[\epsilon]/(\epsilon^2)\),
\(1+\epsilon\ne1\) is a square-one unit but reduces to 1. Thus a field-level
trace character can erase the nontrivial character values that must be
retained. In any reduced characteristic-two ring,
\((a-1)^2=0\) forces a square-one element to be 1; imposing reducedness would
remove exactly the phenomenon at issue.

The archived Jacobian operation is only
`crossed_product.multiply.compute`, server **0.14.0**, protocol
**2025-11-25**. Its inspected contract allows \(|Q|\le16\), lattice rank
\(\le8\), support pairs \(\le1024\), scalar work \(\le80000\).
Discovery hits with `NEEDS_MORE_TYPED_REQUIREMENTS` are not theorem evidence.

The actual old payload is a complete, reusable bounded fixture:

```json
{
  "left": {
    "presentation": {
      "characteristic": 2,
      "cosets": ["e", "s"],
      "identity_coset": "e",
      "lattice_basis": [],
      "quotient_multiplication": [["e", "s"], ["s", "e"]],
      "action_matrices": [[], []],
      "cocycle_table": [[[], []], [[], []]]
    },
    "terms": [
      {"coefficient": 1, "coset": "e", "exponents": []},
      {"coefficient": 1, "coset": "s", "exponents": []}
    ]
  },
  "right": {
    "presentation": {
      "characteristic": 2,
      "cosets": ["e", "s"],
      "identity_coset": "e",
      "lattice_basis": [],
      "quotient_multiplication": [["e", "s"], ["s", "e"]],
      "action_matrices": [[], []],
      "cocycle_table": [[[], []], [[], []]]
    },
    "terms": [
      {"coefficient": 1, "coset": "e", "exponents": []},
      {"coefficient": 1, "coset": "s", "exponents": []}
    ]
  }
}
```

It has quotient \(C_2\), rank 0, and four support pairs. Expected product:
the same presentation with `terms: []`, since \((e+s)^2=0\) in
\(\mathbf F_2[C_2]\). Here \(\epsilon=e+s\ne0\) and
\(1+\epsilon=s\ne e\), while \(s^2=e\).
The unmodified payload also resides at
`old/research/trace-character/jacobian-payload.json`.

The fresh Python replay checks payload/output binding and recomputes this
convolution locally; **it does not contact Jacobian**. Its reported adapter
exit 0, timeout false, and null structured error are historical summary
fields (some returned as constants by the old checker), not new process
observations. The old output records runtime 0 ms and an empty product;
this certifies neither the universal group theorem nor any arithmetic input.
Any fresh Jacobian operation belongs to the parent, not this review.

## 8. Concrete remaining obligations

### `D_TRACE_INPUTS`: not established

1. **`A_TRACE_IDENTITIES`: full-orbit identities.** Construct the indicated
   commutative operator algebra on the integral, reduced orbit and prove
   class invariance, \(t(1)=0\), the determinant-eliminated product identity,
   and repeated-root \(t(u)^2=1\) as operator equalities after every further
   allowed test. A check at coefficient 1, finitely many primes, or in a
   residue field does not supply these hypotheses. The manuscript's
   `tc:trace-algebra` argument and characteristic-zero representation inputs
   are the source claims, not conclusions of this formalization.
2. **`A_PARITY_BOUNDS`: uniform valuation implications.** Establish the
   coefficient/shell bounds and their persistence under further probes.
   The source's matching argument uses the added nonroot cost of at least
   \(1/2\) plus integral valuation to force vanishing; its opposite argument
   uses split or two-simple cost at least 1 after the normalization loss
   \(e_U=1/2\). Repeated-root Hecke cancellation must give the identity on the
   entire orbit, not just one tested index. These arithmetic bounds and
   moving-precision uniformity were not proved or experimentally established
   by the draft's six group models.
3. **`A_UNRAMIFIED_QUOTIENT`: common arithmetic quotient.** At the actual
   fixed stage/accuracy, prove simultaneous factorization of the trace action
   and residual representation through one finite continuous quotient
   unramified outside \(S\cup U\). Integral-lattice and continuity assertions
   in the source must justify this input. The formal square quotient is a
   quotient of an already supplied group and does not prove that arithmetic
   starting object exists. No compatibility across infinitely many stages
   is claimed by this review.

### `D_COEFFICIENTS` and downstream scope: not established

The coefficient construction, normalized integral valuation bounds, and
leading-symbol/nonvanishing detection needed for the operator tests remain
upstream obligations. A weighted genus identity from the other draft unit
would supply at most one ingredient; it is not the complete
`D_COEFFICIENTS` statement. This unit proves neither those coefficient
estimates nor their application to every admissible source/test.

Consequently this unit does not establish the manuscript's pointwise
2-converse (`D_CONVERSE` and its residual cases), prime-substitution and
interpolation applications, analytic density theorem (`D_DENSITY`),
or the mean analytic rank theorem (`M_MEAN`) and its independent moment,
comparison, counting, Jensen, and tail inputs. The parent accounts for the
remaining individual `D_*`/`M_*` target statements; they are not silently
promoted by the supported abstract lemma.

**Bottom line:** the existing algebra argument is sound in its stated
conditional scope, has correctly bound historical formal evidence, and
survives the exact finite replay. The important open boundary is concrete
arithmetic input verification, not failure of the nilpotent-aware character
construction. Native independent review and acceptance remain pending.
