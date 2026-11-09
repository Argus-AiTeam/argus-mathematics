# Statement fidelity: RELATOR_ALIGNMENT and EXACT_COUNTS

This document describes `RelatorAlignment.presentation_alignment` in
`Main.lean` and its supporting declarations. The target is the algebraic
part of the staged `lem:aligned-presentation` after stabilization, together
with `lem:exact-counts`. It does not describe the manuscript's main theorem
as formalized or independently proved.

## Objects and hypotheses

All types and groups are universally quantified. There is no `Fintype`,
`Finite`, enumeration, cardinality bound, or commutativity instance on a
group or its group ring. `RingOf G` is exactly `MonoidAlgebra Int G`, with
its possibly noncommutative convolution multiplication.
`FreeModule G J` is the direct sum `J ->_0 RingOf G`, never a full product.
The relator families have arbitrary types R and I, with I=D disjoint-union T.
D need not even be finite for the certified algebraic theorem.

W is a group and e:W->G a surjective group homomorphism. For the manuscript
specialize W to the free group on all stabilized generators and e to
evaluation in Gamma. Elements of that free group are finite words modulo
free cancellation; there is no completed or infinite-word group here.

M is the full chain module, or any additive commutative group with a
left `RingOf G`-module structure. `PathChain e M` is a map d on W whose
single structural hypothesis is the actual path concatenation identity

    d(a*b) = d(a) + delta(e(a)) * d(b).

Here `delta(g)` is the group-ring basis element at g, acting on the left.
`chain_one`, `chain_zpow_closed`, and `chain_conjugate` derive the
identity, integer-power, and conjugation formulas; these formulas are
not additional assumptions. This is the canonical concatenation identity
for chains of paths in the generator graph. Constructing that graph and
its cellular chain functor is not itself encoded in this file.

A is a linear equivalence from `FreeModule G R` to `FreeModule G I`.
An injective linear map C embeds two copies of `FreeModule G I` into M.
Its range is the cycle module in the manuscript application. In
particular, **d is not assumed to take nonclosed paths into cycle
coordinates**, and no splitting of the cycle submodule inside M is
assumed. This distinction matters over a general group ring.

The map p is projection from M to the T and auxiliary-I edge coordinates.
The explicit input identity `p.comp C = projectOrdinary` means

    p(C(x,y)) = (the T-coordinates of x, y).

In the manuscript C(x,y) inserts the chosen old cycle basis (the
prescribed S-cycles and T loop edges) and the auxiliary U loop edges.
The D-basis has no T or U coordinates, so the displayed compatibility
is a coordinate fact of that input, not an assumption that the final
ordinary relator map is invertible.

The initial families a:R->W and b:I->W have e-value one. Their chains
are respectively `C(A(e_r),0)` and `C(0,e_i)`. The genuine presentation
hypothesis is `closurePair a b = e.ker`, where `closurePair` is the
normal closure of the union of the two indexed ranges. It is not replaced
by equality of boundary spans.

## Finite words and preservation of the actual presentation

`Term W J` has a conjugator in W, a relator index in J, and an integer
exponent. `word b l` evaluates a **finite List** of these terms as a
product of conjugated integer powers. Integer powers stand for finite
repetitions or inverse repetitions. This permits exactly the finite
normal expressions in the manuscript and also integer exponents.

`counts_surjective` proves that every element of the direct-sum module
is the translated coefficient vector of such a finite list, using
surjectivity of e and the finite supports in both direct sums.
`chain_word` proves that evaluating the list in relator words has
precisely its asserted boundary. `word_mem_normal` proves membership
in every normal subgroup containing the source relators.

`normalClosure_shear` proves equality of the old and new normal
closures. It proves both inclusions by recovering a changing word
from the new word and the inverse correction; it does not assume
presentation equivalence. `shear_first` and `shear_second` combine
this fact with finite word realization. `three_word_shears` applies
them, in order, to the second block with A inverse, the first block
with -A, and the second block with A inverse again. These are precisely
the successive precompositions P,Q,P in the manuscript.

`finite_normal_expression` also proves that every member of a normal
closure has an actual finite List expression. `presentation_expression`
specializes this to every e-trivial word of an actual two-block
presentation. Thus existence of normal expressions is not hidden in
an assumption of the translated-count theorem.

## Conclusions

`presentation_alignment` produces final word families a',b', all trivial
under e, with the **same actual presentation kernel** and boundaries

    d(a'_r) = C(0,-A(e_r)),   d(b'_i) = C(e_i,0).

The D-indexed `b'(inl z)` are the distinguished relators. Their
boundaries equal the prescribed cycles once the input coordinate
identification `C(e_(inl z),0)=[z]` is made.

`complete_boundary_isomorphism` identifies the full final boundary map
with C composed with `fullEquiv A`, an explicit equivalence sending
(x,y) to (y,-A(x)). `complete_boundary_basis` proves injectivity and
equality of its range with the range of C. Thus it is a basis of the
same cycle module, not a purported isomorphism onto all edge chains.

`ordinary_projection_isomorphism` identifies the projected ordinary
boundary map, in the order T then R, with the equivalence

    (t,r) -> (t,-A(r)).

It proves the full direct-sum isomorphism, not only an injective finite
submatrix. The ordinary words are b' at T indices and a' at R indices;
the D-indexed distinguished words are excluded.

`exact_translated_counts` states that for **every** finite list l, word
z, and relator index j0, if the evaluated word of l is z and
d(z)=d(b(j0)), and the complete boundary map is injective, then
`counts e l = single j0 1`. The main theorem supplies that injectivity
for its final family. Each list term contributes exactly
`single index (MonoidAlgebra.single (e conjugator) exponent)`.
For exponents +1 and -1 and j0 the index of rho_z, this is literally
the manuscript's sum of `sign * bar(u) * e_r` equal to `e_rho_z`.
No accidental right action or inversion of bar(u) is used.

## Unproved interfaces and result classification

The theorem starts from the actual stabilized presentation and the given
cycle embedding. It does not formalize the construction of that input
from a two-dimensional K(Gamma,1), collapse of an infinite maximal tree,
adjoining the original S or auxiliary U generators, or the preceding
invertible generator substitution. These upstream CW and stabilization
arguments remain prose dependencies of the **full manuscript lemma**.
The earlier unstabilized input can be stabilized by adjoining identity
generators with their own definition relators, exactly as in the
manuscript; that standard step is not relabelled as kernel-checked here.

Nor does this file prove the geometric model, small transport,
localized degree, uniform estimates, finite-quotient solvability,
compactness, or the Eilenberg--Ganea conclusion. Those remain open
nodes in `research/PROOF_GRAPH.json`. The contribution is an independent
universal formal verification of this word-level algebraic bridge.
It is not a finite search extrapolated to arbitrary index sets, not a
counterexample, and not a claim that the verified algebra is novel in
the mathematical literature.

The source contains no user axioms, placeholders, or unsafe proof
shortcuts. The printed axiom dependencies of the two principal theorems
are the standard `propext`, `Classical.choice`, and `Quot.sound`.
Statement fidelity itself requires independent human/Reviewer reading;
compilation does not check the truth of this document.
