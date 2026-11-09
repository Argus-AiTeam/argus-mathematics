# Main-theorem certification

The target is Theorem `thm:main` of the staged September 23, 2026
manuscript, not an auxiliary arithmetic lemma: a separable unital complex
C*-algebra admitting a normalized 2-quasitrace and a fixed pair of positive
contractions with defect at least 1/144 for every normalized 2-quasitrace.
The matrix extension must preserve the upper-left corner; its matrix unit
has value two, not one.

## Source grounding

The staged files `build/01-introduction.tex` (Theorem `thm:main`),
`02-preliminaries.tex` (Theorem `thm:existence`), `03-scaling.tex`
(Lemmas `lem:incidence`, `lem:scaling`), `04-bundles.tex`
(Proposition `prop:bundle-test`), `05-algebra.tex`
(Theorem `thm:construction`, Lemma `lem:defect`), and
`06-conclusion.tex` supply the proof route.

The upstream source is
<https://github.com/openai/math/tree/4eaee87548250b2682affda7d05d947c05554bae/lean>.
Its actual theorem is
`OAI.Kaplansky.kaplansky_quasitrace_counterexample`, in
`OAI/Analysis/Kaplansky/Main.lean`. It imports the construction
`ActualAlgebra.lean` and the dimension-state-to-quasitrace theorem
`OAI/Analysis/Cuntz/Quasitrace.lean`. The separate
`ComparatorChallenges/KaplanskyQuasitrace.lean` contains a placeholder
and is not a proof source.

`lean/docs/294.md` describes the full universal defect result. Direct
inspection of `ActualAlgebra.lean` confirms that the constructed algebra
is a 48-by-48 amplification and that its defect bound holds for every
normalized 1-quasitrace, which is stronger than the required universal
2-quasitrace clause. Existence of a 2-quasitrace is a separate obligation.
This inspection alone does not establish a kernel-checked theorem.

## Compatible-history investigation

A bounded independent source-history investigation inspected the requested
commit and the parentless initial public commit
`adc7f1241b42e322a6451854ab7e4b4c146bf78a` (October 6, 2026).
Both `lean/lean-toolchain` files specify `leanprover/lean4:v4.34.1`.
The Lake file fixes that toolchain and pins Mathlib to
`d13f23b723b8a846827a245b89c10fc7d3f11612`.
Path histories for `lean/lean-toolchain`, `lean/OAI/Analysis/Kaplansky`,
and `lean/docs/294.md` contain only the initial commit in the inspected
ancestry and default branch. Thus no as-pinned Lean 4.31.0-compatible
revision was found. This is a bounded history finding, not a proof that
a port is impossible.

The local `lean --version` reports Lean 4.31.0, commit
`68218e876d2a38b1985b8590fff244a83c321783`. A faithful certification
must actually compile on that version, inspect transitive axioms, and
pass independent statement-fidelity review. Toolchain mismatch, static
absence of `sorry`, and arithmetic tests are not substitutes.

## Current mathematical status

The full formal main theorem now compiles under Lean 4.31.0, including
all 123 necessary OAI modules. Native `lean_evidence verify --claim C294_MAIN`
returned exit zero, `proof_holes=[]`, and axiom-audit exit zero. The
main theorem's transitive axioms are exactly `propext`, `Classical.choice`,
and `Quot.sound`. The ledger derives `C294_MAIN` version 2 as
`closed_kernel`, with no undischarged assumptions.

The archived claim certificate is
`certificates/C294_MAIN-9f656e417523899a.json`. The separate
`exact_certificate.json` binds all original and ported source hashes,
the wrapper, its statement-fidelity document, the verifier, and the
native compiler record. This replaces the earlier partial-build
checkpoints with verification of the full quantified counterexample,
and transports the source pinned to Lean 4.34.1 to the required 4.31.0.
It is a verified port of the actual upstream proof, not a new
mathematical construction or an independent replacement proof.

No staged mathematical assertion has been refuted. Independent replay
and statement-fidelity approval remain the Host Reviewer's obligations;
the Engineer has not marked Reviewer acceptance. Graph nodes remain
open for that review, and auxiliary ledger claims have not been
individually promoted merely because the main theorem compiled.
The campaign remains publishable/exploratory. Neither novelty nor
publication significance is established by this source reconstruction.

## Mathematical dependency chain

The manuscript's retained-bundle calculation uses
`d0 = 64 m 4^R`, `d_j = 4^j d0`, old multiplicities divided by four,
and fresh multiplicity `15 d_j / 4`. Sixteen block-diagonal maps handle
subspaces of dimension at most `m`; eight maps into the fresh block
handle larger subspaces. The respective incidence expressions are
`(5/2)sD - 27s^2` and `(43/2)sd - 11s^2`. Their lower bounds use
`D >= 64m`, `s <= m` in the first case and `m < s <= d` in the second.
The prefix base dimension is less than `(20/3)md`, rather than the
dimension of the entire projective product.

The scaling lemma minimizes
`log det(I + sum T_i P T_i*) - (3/2) log det P`. Expansion by a factor
of two supplies coercive compact sublevels. The Gram-determinant
expansion makes its restriction to every nonconstant positive-definite
geodesic strictly convex, and consequently gives a unique, continuously
varying minimizer. At that minimizer, with `Q = I + sum T_i P T_i*`,
the maps `sqrt(2/3) Q^(-1/2) T_i P^(1/2)` have column sum one and
row sum `(2/3)(I - Q^(-1)) <= 2/3`. The order of these factors is
essential.

For the retained bundle `G`, the total trivial multiplicity is
`h0 = (4/3)md0(1 - 4^(-(R+1))) < 2md0`. Each nontrivial line's
total multiplicity is exactly its project's dimension `K_i`.
Thus the product of the degree-`K_i` powers of the hyperplane classes
is a nonzero Chern class of degree `p = sum K_i`. Splitting off more
than `h0` trivial directions would leave a complement of rank less
than `p`, an impossibility. The upstream proof implements the needed
no-large-frame conclusion by relative homology and twisted sections;
it need not construct a Chern-class API to prove that conclusion.

Bounded forward shifts give a single tuple over all positive `(m,R)`
tests and all their base points. The generated unital algebra is
separable even though the ambient product need not be. An arbitrary
matrix pair of orthogonal isometries would admit a finite-degree
polynomial approximation. Finite propagation sends the level-zero
input to the retained levels, giving a forbidden independent frame.
This quantifier order is why a finite list of tested matrix sizes
would not suffice.

The diagonal pair in `lem:defect` has entries `H_(i-1), 1-J_(i-1)`
and `u_i, 1-v_i`, where `u_i=x_i*x_i`, `v_i=x_i x_i*`, and `H,J`
are the corresponding partial sums. Linearity is used only for
distinct diagonal corners and for scalar translations of individual
self-adjoint elements. Square symmetry identifies the corner values
of `u_i` and `v_i`. The defect telescopes to
`phi(1) - phi(J_N) >= (1-c)phi(1) = (1-c)/(2N)`.
For `N=24`, `c=2/3`, this is exactly `1/144`. This conditional
calculation by itself establishes neither existence of a quasitrace
nor the existence of the required algebra.

The existence branch is supplied in the upstream proof by a normalized
state on the actual Cuntz monoid, lower-semicontinuous regularization,
spectral integration, and compatible corner values. The literature
statement at `arxiv:2309.17412v2`, Theorem 2.3, was opened and agrees
with the manuscript, including normalized 2-quasitraces and absence
of stable proper infiniteness (not stable finiteness). An excerpt is
available at `mr_theorem_2_3_excerpt.txt` for the independent Reviewer's
attribution of assumption `MR_THEOREM_2_3` on `C294_EXISTENCE`; the
Engineer has not self-certified that citation. This literature
assumption is not a premise of the kernel-verified `C294_MAIN`.

## Measured compilation progress

The necessary OAI dependency closure has 123 modules and 1,501,612 bytes.
Comment-aware inspection found no `sorry`, `admit`, `axiom`, `unsafe`,
or `native_decide` token in that closure. This is a static observation,
not a transitive axiom certificate.

The first real Lean 4.31.0 build compiled `OAI.Analysis.Cuntz.Content`
and stopped at `OAI.Algebra.OrderedStates.RationalCone`, lines 154 and
165. In both cases `s.smul_mem_iff` resolves to the submodule lemma
requiring a nonzero scalar, rather than the positive-scalar cone lemma.
The installed `ConvexCone.smul_mem_iff` has the required statement.
An explicitly recorded two-occurrence backport qualifies those uses as
`s.toConvexCone.smul_mem_iff`, leaving every mathematical statement and
the exact acquired upstream files unchanged. Derived port files live
separately under `ported/`. The build resumes only the already compiled
unchanged prefix.

The final real build compiled all 123 modules and the exact main wrapper,
including
`Cuntz.Quasitrace`, actual singular subdivision, the full continuous
matrix-scaling construction, Hermitian bundle frames, sphere homology,
integral projective-space calculations, open incidence, and retained-bundle
multiplicity identities.
Real and imaginary parts of corner maps were transported explicitly
using their scalar formulas. The small-chain monomorphism instance
was proved degreewise using the existing coproduct functor's
monomorphism preservation. The newer finite-support standard-simplex
representation was replaced by the installed library's finite-coordinate
`stdSimplex`, the actual domain of its singular simplices; its metric is
the inherited subtype metric. Small-chain inclusion identities use
explicit functoriality rather than newer simplifier behavior. Conditional,
set-membership, and coproduct-generator lemma renames are also recorded
as exact replacements in `verify.py`. None of the intermediate partial
builds alone established the full theorem; the final wrapper compilation
and native axiom audit now supply that formal conclusion.

For the finite-coordinate simplex interface, affine interpolation is
the explicit sum of nonnegative, unit-total weights. Its vertex,
reindexing, composition, and barycenter identities are proved by finite
sums and the existing linear pushforward. Three convex-hull helpers
are specialized to finite coordinate types because the older simplex
representation requires that parameter; every application in the
singular-chain proof has such a type. This does not restrict simplex
degree or any main-theorem quantifier. This representation-level
specialization, like the rest of statement fidelity, requires independent
review and is not hidden as a mere lemma rename. Matrix-square-root
continuity explicitly bundles the existing operator-norm matrix
structures into a C*-algebra; no additional hypothesis is assumed.

The sphere calculation uses the installed one-coordinate continuous
linear equivalence in place of its newer convenience API. Paths are
transported explicitly under the stereographic overlap homeomorphism,
retaining the ordered negative and positive components. The projective
homology exactness arguments use the installed vanishing-of-both-maps
criterion, derived from the same zero-object hypotheses. A path in an
arbitrary product of nonzero complex scalars is constructed coordinatewise;
no finiteness assumption is added to its index type.

In the older library, the additive structure inferred for a bounded-product
sum retains the already present coordinatewise nontriviality instance.
The auxiliary coordinate-evaluation-of-a-sum lemma therefore retains that
section hypothesis instead of using the newer `omit` directive. Its column
and row applications already carry exactly that hypothesis. This change
does not add an assumption to the constructed algebra theorem or to
`MainTarget`; independent review must still check this source-level difference.

The retained-stage continuity proof explicitly names its canonical
`smoothTestBundleCore` total space and the retained core's projection theorem.
This resolves older instance inference without changing either total-space
topology or the stage map. Inverse trivializations use the installed global
coordinate formula, including compatibility of the real and complex scalar
restrictions, rather than the newer base-set-dependent convenience lemma.

The initial source-free route reference became stale when the claim was
bound to the actual Lean wrapper. Its retirement reason is retained;
the official checker also rejects stale references on retired routes,
so that retired reference alone was rebound to the unchanged mathematical
statement's current formal version. The active route is
`R294_UPSTREAM_FORMAL`.

## Replay

From the campaign root, the default invocation validates the pinned source
manifest, regenerates the explicit compatibility port, reuses only the
unchanged successful module prefix, and recompiles the main wrapper:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python research/certification/verify.py
```

For an independent source rebuild rather than prefix reuse, append
`--rebuild`. Both forms inspect the main theorem's actual transitive
axiom report. The optional `--fetch` mode only acquires the fixed-commit
source closure; it is not a proof.

The native ledger-attaching command uses the installed CLI's positional
source argument and the same prebuilt library/module paths:

```bash
export ELAN_TOOLCHAIN=leanprover/lean4:v4.31.0
export LEAN_PATH="$PWD/research/certification/olean:$(cd $WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0 && lake env printenv LEAN_PATH)"
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/certification/Main.lean --project-root . --claim C294_MAIN --statement-fidelity research/certification/statement_fidelity.md --no-lake
```

`Main.lean` and `statement_fidelity.md` were unchanged throughout the
successful native run and still match its archived hashes. An independent
Reviewer must read the latter against the staged theorem and actual
quasitrace, matrix-extension, and positivity definitions; compilation does
not perform that translation check. The explicit finite-coordinate helper
specializations and retained nontriviality instance above are part of
that review, not concealed deviations.

## Handoff gate

After the native ledger update and final graph-evidence update, the official
checks at `2026-11-05T16:50:53Z` used project root
`campaigns/9000294`.
`math_state check` returned zero with no issues; `proof_graph_check check`
returned zero with ten valid nodes. These are campaign-local structural
checks, not independent mathematical review.

`citation_check status` still reports `MR_THEOREM_2_3` on `C294_EXISTENCE`
as `unchecked` and returns one. Its independent attribution must be completed
before Reviewer acceptance. No independent Reviewer has yet approved the
manuscript translation, and neither a novelty verdict nor overall campaign
completion is claimed.
