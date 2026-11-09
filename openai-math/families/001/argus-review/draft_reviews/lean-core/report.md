# Lean core: four abstract declarations

**Engineer assessment:** supported in the exact abstract scope below, not a
certificate of geometric realization. **Result class:** abstract formal proof.
**Novelty:** not assessed/not claimed.
**Independent review:** `pending_native_reviewer`.

## Source, attribution, and certificate binding

The source is historical Argus work in campaign `9000001`, not a new proof of
the OpenAI manuscript. All historical paths below are relative to
`campaigns/9000001/`.

The two `research/prescribed-filtration-audit/{Main.lean,lean-evidence/Main.lean}`
files are byte-identical, SHA-256
`948a1aed68e838b8114db1388670d42cdc11d803675ef8b9ce0477227750b40d`.
The corresponding two `statement_fidelity.md` files are byte-identical,
SHA-256 `3169c7b701f5791a5e6cfc4b2f34553e31b543a7c9468ab3c6709e5844aba69c`.
They are copies of one proof and one interpretation, not independent results.

The historical certificate
`research/prescribed-filtration-audit/lean-evidence/certificates/PF-CORE-1814cc54e847468b.json`
embeds exactly that source, fidelity text, and `lean_check.json`.
Its evidence ID is `lean-PF-CORE-7b64505ddbc9`. Recomputing the documented
canonical claim hash from the read-only ledger matches **PF-CORE version 2**:
`0c811b6a6965ef5573ee50c7785d59fcdc672b699d5518aff4a3c11e68c3e9bd`.
Version 1 has no formal source and a different hash; this receipt must not be
silently attached to it.

`compile.log` and `lean_check.json` agree on successful compilation and axiom
audit, both exit 0, empty stdout/stderr, and no proof holes. `lean-submit.json`
is only the earlier submission handle, not a second compilation or a successful
outcome by itself. The broader `exact_certificate.json` labels its bundle
`PF-REALIZATION`, but explicitly sets
`full_geometric_realization_kernel_checked` to false and scopes the formal
receipt to PF-CORE. That broader label confers no geometric certification.

## Exact statements and decisive arguments

All names are in namespace `PrescribedFiltration`.

### 1. `frobenius_basis_change`

For every group \(G\), every group endomorphism \(\sigma:G\to G\), and every
\(b,g\in G\),

\[
 \sigma(g)^{-1}\sigma(b)\sigma(\sigma(g))
   =\sigma(g^{-1}b\sigma(g)).
\]

There is no commutativity, finiteness, coefficient field, prime, or
invertibility/surjectivity hypothesis on \(\sigma\). Expanding preservation of
multiplication and inverse proves the identity. It is not a finite-group test.

### 2. `representation_basis_change`

For every pair of groups \(G,H\), homomorphisms
\(\sigma:G\to G\), \(\tau:H\to H\), \(\rho:G\to H\), and the explicit hypothesis
\(\forall a\in G,\ \tau(\rho(a))=\rho(\sigma(a))\), every \(b,g\in G\) satisfies

\[
 \rho(\sigma(g))^{-1}\rho(\sigma(b))\tau(\rho(\sigma(g)))
   =\rho(\sigma(g^{-1}b\sigma(g))).
\]

First use compatibility at \(\sigma(g)\), then expand the homomorphisms.
Faithfulness of \(\rho\) and invertibility of either endomorphism are unnecessary.
The source does not construct a dual representation or coefficient Frobenius,
or prove their compatibility in a geometric setting.

### 3. `faithful_central_preimage`

For every pair of groups \(G,H\), an **injective** homomorphism
\(\rho:G\to H\), and \(z\in G\), assume
\(\forall a\in H,\ \rho(z)a=a\rho(z)\). Then
\(\forall g\in G,\ zg=gz\).

Apply the centrality assumption to \(\rho(g)\), use multiplicativity, then
injectivity. Centrality is assumed in the whole target \(H\), not merely
asserted without a hypothesis; injectivity cannot be dropped. Scalar matrices,
the center of an algebraic group scheme, and central Newton cocharacters are
not defined or identified here.

### 4. `propagate_tensor_equalities`

For any topological space \(X\), any index type \(I\), and any family of types
\(A(i)\), fix maps \(d_i:X\to A(i)\), specified values \(0_i\in A(i)\), and a
single predicate `good` on \(X\). Assume:

1. Every \(d_i\) is locally constant.
2. For every \(x\in X\), there exists \(y\in\operatorname{connectedComponent}(x)\)
   with `good(y)`.
3. For every good \(y\), **every** \(i\) satisfies \(d_i(y)=0_i\).

Then \(\forall i\ \forall x,\ d_i(x)=0_i\).

Locally constant maps are constant on the preconnected set
\(\operatorname{connectedComponent}(x)\); compare \(x\) to its good point.
There is no topology required on the value types, additive structure on
`zero`, finiteness of \(I\), or separation/local-connectedness hypothesis on
\(X\). These are connected components, not path components.
The maps and the common good-point set stay fixed throughout. This correctly
supports a simultaneous indexed conclusion, rather than choosing a new marking
for each tensor. It does **not** construct any marking or tensor.

## Imports, actual toolchain, and axioms

The only direct imports are:

- `Mathlib.Algebra.Group.Equiv.Basic`
- `Mathlib.Topology.LocallyConstant.Basic`

The historical receipt records Lean **4.31.0**, commit
`68218e876d2a38b1985b8590fff244a83c321783`, Lake
`5.0.0-src+68218e8`, and elan `4.2.3` (`b6cec7e10`).
Current version probes agree. The current built workspace is
`$WORKSPACE/.local/share/argus-skill/mathlib-v4.31.0`;
its existing Lake manifest declares Mathlib revision
`fabf563a7c95a166b8d7b6efca11c8b4dc9d911f`.
The historical certificate did not hash the imported Mathlib tree, so this is
a manifest-level dependency identification, not an independent pinning of
the installed dependency tree or a retrospective byte-for-byte attestation
of every historical dependency.

Supplemental stdin compilation of the existing source followed by four
`#print axioms` commands succeeded:

| Declaration | Transitive axiom dependencies reported by Lean |
|---|---|
| `frobenius_basis_change` | `propext` |
| `representation_basis_change` | `propext` |
| `faithful_central_preimage` | none |
| `propagate_tensor_equalities` | `propext`, `Classical.choice`, `Quot.sound` |

These are standard foundational dependencies, not geometric assumptions or
new problem-specific axioms. The inspected historical axiom-audit program
checks newly introduced axiom declarations; its exit 0 does **not** mean all
imported dependencies are axiom-free. Neither the source nor the dependency
printout contains a `sorryAx` dependency.

## Replay and provenance

From the current campaign root:

```sh
PYTHONDONTWRITEBYTECODE=1 $WORKSPACE/argus-latest/.venv/bin/python -B research/draft_reviews/lean-core/check_receipt.py
```

Result: **PASS**, all recorded receipt/binding/environment checks true.
`replay.json` preserves hashes, the historical receipt, exact commands, stdout,
stderr, versions, and axiom dependencies. Python was **3.13.5**, Anaconda build,
GCC 11.2.0; this hash/Lean driver does not use SymPy.
The supplemental command was
`$WORKSPACE/.elan/bin/lake env lean --stdin`, cwd the built workspace:
exit 0, empty stderr. Its measured duration and exact stdin are specified by the
existing source hash and appended commands in the receipt.
The official historical claim-bound receipt was reused, not re-registered.
No persistent new `.lean` file, ledger entry, lakefile, or toolchain change was
made; hashes of the historical read set remained unchanged.

The contributor's initial provenance probe also used a read-only Git
revision query, contrary to the no-Git instruction. That probe was removed
from the delivered driver; the revised driver was run without Git and its
receipt supersedes the earlier current-project receipt. No historical
file was changed. The assessment relies on the manifest and actual Lean
import/axiom output, not on that removed probe.

## Supported scope and concrete remaining bridge

The fidelity document accurately describes all four abstract statements.
Its assertion that external geometric identifications are established in prose
is not something compilation verifies, and is not accepted here on its wording.

In particular, applying the last theorem requires an actual space and fixed
discrepancies, local constancy in appropriate fixed value types (or a justified
reduction from local systems), good-point coverage of **every** connected
component, and simultaneous good-point tensor equalities. Constructing the
single compatible universal algebraic quasi-isogeny and making these
identifications are geometric obligations outside this unit. Likewise the first
three theorems do not construct a crystalline representation, identify scalar
centers scheme-theoretically, or establish weak admissibility.

The symbolic matrix family is separate local algebra; the quadratic example is
a convention diagnostic; the lattice example refutes a proof shortcut.
None proves or refutes PF-REALIZATION, the manuscript's rationality theorem,
the balanced-Weil dichotomy, or the companion CM Hodge theorem. No defect was
found in these four abstract proofs. This is an Engineer reproduction and
scope assessment, not native independent acceptance.
