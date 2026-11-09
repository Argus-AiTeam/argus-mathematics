# Exact odd-square audit

## Mathematical target and present scope

The target is the universal assertion that, for every odd integer `u>1`,
there is no sign-coefficient `h` in `Z[C_(4u^2)]` with `h h*=4u^2`.
Here star reverses group elements and conjugates coefficients; the scalar
is supported at the group identity. A search at one order is not this theorem.

The universal obstruction now has a genuine Lean 4.31.0 kernel certificate:
`certificates/C_ODD_SQUARE-5ceed16c4a9c5103.json`. Compilation and the
transitive axiom audit both returned zero, with `proof_holes=[]`.
The ledger derives `C_ODD_SQUARE` as `closed_kernel`, with no undischarged
assumptions. This is a replay of released mathematics, not a new proof.
No false load-bearing manuscript assertion has been established.
Independent Reviewer acceptance and the publishable/novelty boundary remain open.

## Scope and prior result

The staged source is OpenAI, *The circulant Hadamard conjecture*,
September 23, 2026. Its `products.tex`, `lem:comparison` and
`prop:alternating`, and `contradiction.tex`, `eq:three-elements` through
`eq:last-sum`, are the load-bearing nonclassical route.

A primary-source lookup found actual proof modules, not just the
`sorry` in `lean/ComparatorChallenges/CirculantHadamard.lean`:

`https://github.com/openai/math/tree/adc7f1241b42e322a6451854ab7e4b4c146bf78a/lean/OAI/LinearAlgebra/CirculantHadamard`

In particular `BinaryContradiction.binary_sign_norm_impossible` states the
actual integer cyclic-ring obstruction, with `u>1`, `Odd u`, sign
coefficients, and the full scalar norm equation. It derives the three
odd-torsion statements rather than assuming them. The repository declares
Lean 4.34.1. The assigned certification environment is Lean 4.31.0, so
compatibility and a real compiler replay must be established separately.

This discovery changes the strongest relevant prior result: a fresh replay
would be an independent certification of an already released proof, not a
new proof of the conjecture. No novelty claim follows from locating it.
The web search's prose describing the conjecture as solved was not used
as mathematical evidence. No external literature theorem is assumed by
the exact experiments.

The first unmodified replay failed at a newer simplifier name
`ite_eq_right` in `MatrixBridge.lean:124`. Replacing it by `if_neg`
preserved the statement and proved the same branch under Lean 4.31.0.
The next failure exposed a broader coefficient API change:
the older group-ring extensionality lemma targets a coercion to functions,
whereas the released proofs use explicit `.coeff`. The local
`Lean431Compat.lean` supplies a proved coefficient extensionality lemma
and aliases for the old convolution lemmas. That bridge and
`CyclicRing.lean` both passed the real Lean 4.31.0 compiler.
These are tooling compatibility failures, not refutations of the manuscript.

## Universal certification and reproducibility

All **52** dependency modules compiled under Lean **4.31.0**. The official,
claim-bound run subsequently compiled the exact all-parameters theorem and
completed its environment axiom audit, both with exit code zero. Its
**18,152 ms** compiler-and-audit result is archived with the exact source
and statement-fidelity text. The four complete transitive axiom sets are
each exactly `{propext, Classical.choice, Quot.sound}`: no `sorryAx`,
arithmetic oracle, nonexistence axiom, or assumption of the disputed
alternating-product conclusion occurs.

The source hash is
`8c82f61f68f11a3c5bf921511c64dd91791953797e9e8e38bdf395ce91f2fe03`;
the fidelity hash is
`0975559cd979f88c7c1586f66c2bac649786ae0a05b266c059b3c77a2ee928f6`.
The first genuine compiler run also passed, but the binding checker
refused a document naming the theorem only by its qualified name.
Adding the explicit unqualified declaration name changed no mathematical
reading; a fresh complete official run then recorded the certificate.
`lean_first_compile.json` preserves the refused first binding.

The remaining compatibility edits preserve the mathematical statements:
the older Complex import path; proved coefficient/convolution aliases;
the older algebra-hom extensionality arity; the actual principal-ideal
and DVR indices in the older equivalence list; `ENat.le_coe_iff`;
the older integral-contraction APIs; and explicit conditional,
coefficient, and reflexivity reductions. No extra hypothesis or axiom
was introduced.

| Manuscript surface | Compiled proof surface |
|---|---|
| `local.tex`, `lem:local-ring` | `CyclotomicLocalBase.lean`, `RamifiedLocal.lean` |
| `products.tex`, `lem:comparison` | `LocalComparison.local_character_comparison` |
| `products.tex`, `prop:alternating` | `alternatingProduct_odd_torsion` |
| `contradiction.tex`, actual sign-row evaluations | `BinaryEvaluation.lean`, `BinaryLocalFamily.lean` |
| `contradiction.tex`, first-order maps and final sum | `FirstOrderResidue.lean`, `BinaryContradiction.lean` |
| Exact odd-square objective | `Audit9000179.odd_square_obstruction` in `Main.lean` |

`formal_build_manifest.json` binds every source and compiled dependency
by SHA-256 and records the exact import closure. `verify.py` checks these
hashes, the archived real compiler result, both formal input hashes, and
all four permitted axiom sets before classifying the result as universal.
Its finite arithmetic and Jacobian checks remain separately identified.
The script does not itself rerun Lean or perform independent review.

From the campaign root, an independent compiler replay is:

```bash
P=$WORKSPACE/argus-live-update/.venv/bin/python
$P research/odd_square_audit/replay_formal.py build --force
LEAN_PATH="$PWD/research/odd_square_audit/formal" $P -m argus_skill.verticals.math.lean_evidence verify research/odd_square_audit/Main.lean --statement-fidelity research/odd_square_audit/statement_fidelity.md --claim C_ODD_SQUARE --project-root .
$P research/odd_square_audit/verify.py
$P -m argus_skill.verticals.math.math_state check --project-root "$(pwd -P)"
$P -m argus_skill.verticals.math.proof_graph_check check --project-root "$(pwd -P)"
```

Use the assigned durable runner if a forced rebuild is expected to exceed
two minutes. The verifier is pinned to the dependency snapshot actually
used by this official run. A changed snapshot requires a fresh official
run and explicit review of the snapshot pin in `verify.py`, not merely
regenerating JSON against an old compiler result.
`--write-certificate --lean-certificate PATH` rebinds an official archive
within that certified snapshot.

Compared with the strongest prior result, there is **no claim of increased
mathematical strength**: the pinned primary release already contains the
universal proof. Compared with this campaign's earlier finite checkpoint,
the improvement is a real all-parameter compiler certificate on the
required older toolchain, with a faithful target and audited axiom closure.
Its honest classification is `known_result` with
`verification_class=universal_formal_verification`; novelty is not claimed.
The proof graph therefore keeps every Reviewer flag false and every
node unclosed pending the host's independent review. This does not meet
the campaign's verified-new publishable stopping condition.

## Character comparison: hypothesis-sensitive proof audit

Let `A` be exactly the unramified cyclotomic localization in
`local.tex`, `lem:local-ring`. For `F K=p^e b` in `A[C_(p^e)]`,
the augmentations and all root evaluations are nonzero.
At `e=1`, the integral augmentation valuations sum to one, so one
augmentation is a unit. Congruence of evaluation at `rho` and at one
then gives a residue-one unit ratio for that factor; the two ratios
multiply to one and give the other.

At `e>=2`, evaluation at a primitive `p^e`-th root gives valuations
whose sum is `e`. At least one is at least one, even though these
ramified valuations need not be integers. For that factor, division by
the monic cyclotomic polynomial leaves a remainder with coefficients
in `pA`. Projection to `C_(p^(e-1))` sends the cyclotomic polynomial
to `p`, so its projection is coefficientwise divisible by `p`.
Divide that projected factor, and only that factor, by `p`.
The new product is `p^(e-1)b`. Both evaluation ratios are unchanged:
evaluation at one and at `rho` factors through this projection, and
the scalar cancels in the ratio of the divided factor. Subsequent
steps may divide the other factor. No requirement of keeping the
same divided factor was found.

The equality of scalar valuation and cyclic exponent is essential.
For `F=p-2J` in `Z[C_p]`, `F F*=p^2` and `F(rho)/F(1)=-1`.
This is the manuscript's own excluded case, not a counterexample to
`lem:comparison`.

## Alternating product and binary contradiction

At every maximal ideal above `p|u`, pair the evaluations in the
`p`-direction. Comparison makes each edge ratio a local unit of residue
one, hence the same is true of the alternating product. At the other
maximal ideals the norm `u^2` is a unit. Intersection of the localizations
gives integrality of the product. Every complex image has absolute
value one because the alternating exponents sum to zero. Kronecker's
criterion gives torsion. Residue one above each `p|u` forces `p`-power
order, hence odd order. With two different prime divisors it forces
order one. With one prime, `x=p^a X` really gives
`Delta(x)=rho_p^(-1)`; setting every alternating product equal to one
would be an invalid strengthening.

The sign array gives the integral elements `c,d,g`, all of norm `u^2`.
Writing `b=(H1+H3)/2` and
`H2+i H3=(1+i)J+2U` gives

```
d-c = -2b,
g-c = (i-1)b - (H2+i H3),
(d-c)/2 + (g-c)/(1+i) = -J - (1-i)(b+U).
```

These are coefficientwise identities. `verify.py` checks all sixteen
sign quadruples without dividing by `c`, so coefficients for which
`c=0` are not silently discarded.

In the one localization above two, every character value `c_S` is
a unit. Division by it gives exactly the manuscript's first-order
identity. The maps `1+tL -> L mod n`, for `t=2` and `t=1+i`,
are genuine homomorphisms: multiplication contributes
`L+M+tLM` and inversion contributes `-L/(1+tL)`.
Both alternating ratio products have odd order and residue one, hence
equal one. Applying the two maps and adding leaves the residue of
`sum_S (-1)^|S| J_S/c_S`. All nontrivial character values of `J`
are zero; its trivial value is the odd unit `u^2`. This is the stated
contradiction, provided all preceding universal inputs are certified.

## Exact experiments and their limitations

Run `python3 research/odd_square_audit/verify.py` to replay the
arithmetic certificate. It preserves the order-four witness and the
nontrivial single-prime example. It also enumerates every possible
integer coefficient vector of identity norm coefficient nine in
`Z[C_9]`: the square partitions are `9`, `4+4+1`,
`4+1+1+1+1+1`, and nine ones. For each actual scalar-norm solution,
it checks coefficientwise projection divisibility, the descended norm,
and the exact order-three character ratio. This is a finite
adversarial check, not a universal verification.

The exact search examined **34,802** coefficient vectors and found **108**
scalar-norm solutions. Each of the three possible character-ratio
exponents occurred **36** times. All sixteen sign quadruples satisfied
the coefficient identities, including the cases with zero coefficient
`c`. These are measured finite results, not evidence that no larger
counterexample exists.

The bounded Jacobian request evaluates
`4(t^3+2)(t^9-1)` at the nine-cycle permutation matrix. This is exactly
`F^2-9` for the matching-exponent example
`F=3-2(1+t^3+t^6)` in `Z[C_9]`.
Only a completed exact zero output supports this particular identity;
an adapter failure or timeout supports no mathematical conclusion.

The actual adapter run completed on Jacobian **0.14.0**, protocol
**2025-11-25**, in **6 ms**, with the exact zero matrix over `QQ`.
Its exact payload and full typed result are retained in
`jacobian_payload.json` and `jacobian_output.json`.
