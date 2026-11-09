# Certification of the existing recognition implementation

## Question and scope

Does `openai/math` revision
`4eaee87548250b2682affda7d05d947c05554bae` prove, without additional
mathematical assumptions, the staged uniform bounded-height theorem and its
quasi-isometric recognition consequence?

The native upstream toolchain is **Lean 4.34.1**, not the campaign's
Lean 4.31.0 target for newly authored formal mathematics. No port of the
upstream dependency tree is assumed.

The primary-source scope description, `lean/docs/255.md` at that revision,
says:

> The formalization proves quasi-isometric recognition of virtually polycyclic
> groups: every finitely generated group quasi-isometric to a finitely
> generated virtually polycyclic group is itself virtually polycyclic.

It also describes bounded-height control for the stated unimodular solvable
Lie models. This is a claim to be tested, not a mathematical assumption.
`lean/lean-toolchain` at the same revision reads
`leanprover/lean4:v4.34.1`.

## Literal staged targets

In `build/introduction.tex`, Theorem `thm:recognition` states:

> Let \(P\) be a finitely generated virtually polycyclic group, and let \(H\)
> be any finitely generated group. If \(H\) and \(P\) are quasi-isometric,
> then \(H\) is virtually polycyclic.

No solvability hypothesis on \(H\) is permitted.

Theorem `thm:bounded-height` quantifies over **every** connected simply
connected real-triangulable unimodular Lie group \(G\). Its height map is
the homomorphism to
\(W=\mathfrak g/\bigcap_j\ker\chi_j\), with the \(\chi_j\) the diagonal
characters of the adjoint representation. It asserts the quantifier order
\[
 \exists\,\mathcal A_G\leq\mathrm{GL}(W)\text{ finite}\quad
 \forall K\geq1,\ C\geq0\quad \exists B=B(G,K,C)\quad
 \forall F\text{ a }(K,C)\text{ self quasi-isometry}\quad
 \exists A_F\in\mathcal A_G\quad\forall g\in G,
\]
\[
 \|\pi F(g)-\pi F(1)-A_F\pi(g)\|\leq B.
\]
The slope group must precede the quasi-isometry constants, and the bound
must be uniform over all maps with those constants.

The manuscript's proposed recognition route is:
Lie-model reduction; bounded height; a corrected height homomorphism for
a finite-index subgroup of \(H\); polynomial growth of each finitely
generated subgroup of its kernel; elementary amenability; finiteness and
duality; virtual polycyclicity. The height route passes through stationary
slopes, affine chart profiles and global uniform sublinear control, then
boundary measures to obtain a bounded error. These are separate mathematical
obligations, not consequences of a source inventory or a successful build.

## Initial environment observations

The staged manuscript is a link to the assigned local `openai/math`
snapshot. The snapshot's `lean` directory exists; its `.lake` directory
was not present at the first probe. Lean 4.34.1 and Lean 4.31.0 are installed.
The assigned built Mathlib 4.31.0 workspace exists. These observations do
not yet establish the availability of the pinned native dependencies.

The inherited project wiki index has no entry matching polycyclic groups,
quasi-isometries, or bounded height. No prior project result has been
found that settles this question.

## Source-level findings

The detailed source investigation is
[`upstream/findings.md`](upstream/findings.md). Its inventories cover
2,679 transitive OAI modules (232,617 lines) and 74 effective patched Gromov
modules (26,820 lines). All OAI source identities matched the pinned GitHub
metadata. No explicit `axiom`, `constant`, `opaque`, `sorry`, `sorryAx`, or
`admit` declaration/token was located by the comment/string-stripped source
scan. These are finite source measurements, **not** a theorem-specific
kernel axiom footprint. In particular, "no located explicit postulate" must
not be restated as "only standard logical axioms."

The exported entry declarations are `group_recognition`,
`uniform_lattice_recognition`, `recognition_and_lattice`,
`lattice_recognition`, `main_uniform_bounded_height`,
`uniform_bounded_height`, and
`uniform_bounded_height_of_published_inputs`, all in namespace
`OAI.PolycyclicRecognition`. Their complete literal source signatures are
preserved in `upstream/source_inventory.json` and
`upstream/theorem_statements.json`.

The source trace supports the following distinctions:

| Requirement | What the actual source says | What remains unchecked |
| --- | --- | --- |
| Finite generation and arbitrary comparison group | `group_recognition` assumes `Group.FG` for both groups and no solvability of the comparison group. | Elaboration and complete proof acceptance. |
| Canonical height | The quotient is the intersection of kernels of actual diagonal adjoint characters. A linear equivalence gives arbitrary normed coordinates; exponential identities constrain the height homomorphism. | The transitive proofs constructing and identifying these objects. |
| Full Lie-model class | The original lattice model need not be real triangular; the height theorem requires real triangularity and unimodularity. There is no abelian-by-abelian restriction in the entry signatures. | The record requires analytic `LieGroup ... ⊤`; a smooth-to-analytic model bridge is not a kernel-checked part of this audit. |
| Finite slope group | One finite subgroup is quantified before `K,C`. | Its entire construction and proof of finiteness. |
| Uniformity | A nonnegative `B` is quantified before every `SelfQuasiIsometry` with those `K,C`. | The geometric proof establishing that uniform bound. |
| Published inputs | Some compatibility wrappers genuinely assume `PublishedRecognitionInputs`. The definitive entry declarations instead invoke source proof providers. | A parameter named `Input` is not an axiom, but neither is its source provider an accepted proof without elaboration. |
| Gromov theorem | The actual recognition entry supplies an external Gromov theorem through a word-ball conversion. | The patched Gromov proof and its native dependencies. |

The full source path, not merely a conditional assembly, supplies the
named metric, Remez, Cartan, ergodic-decomposition, and reduced-cohomology
inputs. Consequently it would be incorrect to announce an extra axiom
simply because a low-level theorem takes one of these inputs. It would
also be incorrect to announce an unconditional kernel proof simply
because a theorem body supplies that input.

The native Mathlib revision is
`d13f23b723b8a846827a245b89c10fc7d3f11612`. The Gromov base revision is
`8db79f13cf211b570e3116301d91379fbc01cf3e`, with the exact upstream
`lean/patches/gromov-lean4341.patch`. The compatibility patch adds
`Gromov/PolynomialGrowth.lean`; its absence from the unpatched base is
**not** a mathematical defect or an unfulfilled import in the intended
patched source.

## Native measurement and decisive blocker

The source investigator executed the installed native compiler through
stdin, requesting `#check @...` and `#print axioms ...` for all seven
exports. Its version was:

```text
Lean (version 4.34.1, x86_64-unknown-linux-gnu, commit 5045d0056413266e57c625dcd7c365b10e377c52, Release)
```

It exited **1 before any theorem or axiom query**, reporting:

```text
object file 'openai-math/lean/OAI/GroupTheory/PolycyclicRecognition/Recognition.olean' of module OAI.GroupTheory.PolycyclicRecognition.Recognition does not exist
```

The exact command, stdin, environment, stdout, stderr, exit status, and
path probes are in `upstream/native_query.json`. No axiom list was obtained;
its value is **unknown, not the empty list**. A native Lean executable is
available, but the assigned source has no compiled entry module or `.lake`
workspace, and the probed native Mathlib cache is absent. The available
Mathlib 4.31.0 cache has a different Mathlib revision and cannot be passed
off as the native 4.34.1 dependency environment.

Recompiling 2,679 custom modules plus missing compatible dependencies, or
porting them to 4.31.0, is not a reuse of an available native proof build.
Neither was attempted. This local prerequisite failure does not determine
whether the proof source elaborates elsewhere, nor whether the mathematical
theorems are true.

## Other bounded investigations and their limits

The actual boundary-measure proof and deterministic affinity criterion
were read against the staged statement. This reading produced no exact
counterexample. It does not certify their proofs.

Jacobian discovery and contract inspection are preserved in
`jacobian_discovery.json` and `jacobian_contract.json` (server 0.14.0,
protocol 2025-11-25). The inspected operation,
`lie_algebra.chevalley_eilenberg.complex.compute`, concerns structure
constants over **GF(p)**, not real Lie groups or Lean dependency graphs.
No payload was submitted: using a finite-field homology computation as
evidence for the present theorem would substitute an inapplicable problem.
There is no Jacobian mathematical verdict.

A targeted lookup of the manuscript's
Kropholler--Martinez-Perez--Nucinkis finiteness citation found candidate
primary PDFs, but the Southampton endpoint returned HTTP 401 and the CORE
copy returned HTTP 403. The search service's summary is not a reading of
Theorem 1.1 and is not used as mathematical evidence. No judgement about
that citation, and no theorem relying on it, is certified here. The
upstream definitive recognition path is separately described as
`RecognitionWithoutKMN`; a different proof organization alone does not
refute the staged citation.

## Replay and classification

Run from this directory:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python verify.py
```

`verify.py` checks the archived pinned custom-source closure, exact exported
signature text, effective Gromov source identities, and recorded native
failure. It writes `exact_certificate.json`. Exit **2** explicitly means
**full-theorem certification remains blocked**, not a passing mathematical
certificate; exit 1 denotes invalid/missing replay evidence. The source
archive is for inspection and replay, not newly authored Lean mathematics.
No `Main.lean` or unchecked 4.31.0 formalization is supplied.

The script does not repeat the already failed native import while its
compiled entry prerequisite is absent. If compatible compiled import roots
become available, `--native-lean-path` permits the same native query. Even
successful query output still requires provenance binding to the pinned
proof sources and independent statement-fidelity review.

**Result:** the source presents the intended strong interfaces and no
located problem-specific postulates, but a complete transitive kernel
axiom footprint and full statement-faithful theorem certification have
**not** been obtained. No literal staged mathematical assertion has been
shown false, so no `F_<LABEL>` refutation is manufactured. The result is a
**partial source audit with a real native-build blocker**, not an exact
counterexample, new theorem, publishable verification, or completed
campaign. Independent Reviewer assessment remains the Host's responsibility.
