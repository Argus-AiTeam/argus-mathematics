# Arbitrary-index relator alignment: algebraic scope and proof

The target is the word-level part of `lem:aligned-presentation` and
`lem:exact-counts`, in the staged September 23, 2026 manuscript,
`build/sections/presentation.tex`, lines 112--205. The earlier reduction
from a two-dimensional classifying space is a separate, unverified input.
The model, localized degree, quadratic estimate, finite-quotient solver,
compactness, and small-transport claims are not conclusions of this work.

## Scope settled from the sources

The manuscript explicitly uses **left** integral group-ring modules and
direct sums, not products. Its initial relators normally generate the
presentation kernel, in addition to having a boundary isomorphism.
Both properties are necessary inputs; a boundary basis alone need not
present the group. Distinct indices are retained even for equal words.
The source cites Fox, *Free differential calculus II* (1954), Section 2,
transformation (III), as prior art for relator operations. No novelty is
claimed for that operation, and no theorem from Fox is needed below.
The manuscript cites Hatcher, *Algebraic Topology* (2002), Propositions
0.17--0.18, for the upstream CW reduction. That reduction and that
external citation are not independently certified here. The project Wiki
index contains no entry for this particular relator-alignment argument.

Matrix multiplication alone is an insufficient route: it proves neither
finite word realization nor equality of normal closures. Finite tests
cannot replace the universal argument.

## Universal algebraic statement

Let W be a group of finite words modulo free cancellation (in fact any
group suffices), let e:W -> Gamma be surjective, and put
Lambda = Z[Gamma]. Let M be a left Lambda-module. A path-chain map d
satisfies

    d(ab) = d(a) + delta(e(a)) d(b),

where delta(g) is the group-ring basis element at g. In the generator
graph this is the usual chain of the path starting at the identity.
No commutativity of Gamma or Lambda is assumed.

Coordinates are used only for the cycle submodule: an injective linear
map C:Lambda^(I) x Lambda^(I) -> M embeds the old cycles and new loop
edges into the full chain module. No extension of cycle coordinates to
all nonclosed paths is assumed. The projection p to the extra edges
satisfies p C(x,y)=(projection_T(x),y). This is the coordinate identity
coming from the prescribed S-cycles and the T and U loop edges.

Suppose relators a_r and b_i have value one, and their boundaries are
the columns of (A,1), where A:Lambda^(R) ~= Lambda^(I).
Suppose also that their normal closure is the presentation kernel.
There exist final finite relator words a'_r,b'_i with exactly the same
normal closure and

    d(a'_r) = (0,-A e_r),    d(b'_i) = (e_i,0).

Their complete boundary map is an isomorphism. If I=D disjoint-union T,
the b'_z are the distinguished relators. On the other relators,
projection to T and the auxiliary I coordinates is diag(1_T,-A), an
isomorphism. These assertions permit empty, infinite, or uncountable
index sets.

## Word realization and normal closure

For e(b)=1 the cocycle identity gives d(b^-1)=-d(b) and

    d(v b v^-1) = delta(e(v)) d(b).

It also gives d(bc)=d(b)+d(c) when both words have value one.
For any finitely supported coefficients c in Lambda^(J), expand each
coefficient as a finite integer combination of group elements. Lift
each group element to W using surjectivity of e. A finite product of
the corresponding conjugates, inverses, and repetitions has value one,
lies in the normal closure of the unchanged relators, and has boundary
sum_j c_j d(b_j). This uses no infinite word or uniform support bound.

For a changing family a_r, choose such a correction c_r and replace
a_r by a_r c_r, leaving all b_j unchanged. Every new word is in the old
normal closure. Conversely each correction is in the new normal closure,
because all its source relators b_j are unchanged. Hence
a_r=(a_r c_r)c_r^-1 is in the new normal closure. This proves equality
of normal closures, not merely equality of boundary spans.

Apply this construction to the second block with coefficients A^-1,
then to the first block with coefficients -A, then to the second block
with coefficients A^-1 again. The boundaries at the three stages are

    (A e_r,0),       (e_i,e_i);
    (0,-A e_r),      (e_i,e_i);
    (0,-A e_r),      (e_i,0).

The same unchanged-block argument applies at each stage. The column of
an inverse linear map on a direct sum is itself an element of a direct
sum, so every one of these operations is finite even when the families
are uncountable. No commuting of group-ring coefficients is involved.

## Exact translated counts

Let f:J->W be the final family and B:Lambda^(J)->M its injective
boundary map. For any finite expression

    z = product_k v_k f(j_k)^(sign_k) v_k^-1

with signs +1 or -1, all factors have value one. Therefore

    d(z) = B(sum_k sign_k delta(e(v_k)) e_(j_k)).

If d(z)=d(f(j0)), injectivity forces the coefficient vector to equal
e_(j0). Taking j0 to be the index of rho_z is exactly the manuscript's
translated signed-count identity. It holds for every such expression,
not only for a specially chosen one.

This is an algebraic verification theorem conditional on the specified
actual presentation and path-chain cocycle. It is not a proof of the
Eilenberg--Ganea counterexample, nor a claim of a new literature theorem.

## What the certificate adds and how to replay it

The initial project ledger had no certificate for this bridge. The
new evidence is a universal kernel-checked theorem about actual finite
relator words and presentation kernels, rather than a matrix computation.
`RelatorAlignment.presentation_alignment` includes the full boundary
basis, ordinary projection isomorphism, and exact-count conclusion.
Its separate fidelity document states the precise ambient-chain
hypotheses and the interfaces that remain unproved.

From the campaign root, replay the universal proof and then the exact
noncommutative word certificate:

```bash
$WORKSPACE/argus-live-update/.venv/bin/python -m argus_skill.verticals.math.lean_evidence verify research/relator_alignment/Main.lean --statement-fidelity research/relator_alignment/statement_fidelity.md --claim RELATOR_ALIGNMENT --project-root .
$WORKSPACE/argus-live-update/.venv/bin/python research/relator_alignment/verify.py
```

The script checks the current source/fidelity bindings to the real
archived Lean run and replays explicit free-word identities over the
nonabelian free group F(a,b). Those finite identities are an orientation
and implementation check, not the proof of universality. The script does
not itself rerun the compiler; the first command is required for an
independent compiler replay. The recorded Jacobian computation is only
a bounded conjugated-loop path illustration, with its exact typed
payload and result retained separately.

No false assertion was identified in these two algebraic targets.
The full aligned-presentation lemma still depends on the unverified
upstream reduction, and the main theorem remains open in the proof
graph. Independent Reviewer replay and statement-fidelity assessment
have not been performed by the Engineer.
