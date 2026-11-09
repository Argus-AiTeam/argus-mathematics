# Statement fidelity

`Main.lean` is an independent Lean 4.31 formalization of specified
algebraic and universal-property parts of the couniversality audit.
It is **not** a formalization of strict higher categories, the Gray
tensor, the Street nerve, weak homotopy equivalences, or the complete
couniversality theorem. It does not import the incompatible public
OpenAI development.

## Declarations

`CouniversalityAudit.edge` is the generator `(a,b)` of the free abelian
group on ordered pairs, except that it is zero when `a=b`.
`edge_identity_iff` quantifies over every partially ordered set and
every triple `a <= b <= c`. It proves
`[a,c] - [a,b] = [b,c]` if and only if `a=b` or `b=c`.
There is no bound on the poset or on its cardinality. Only weakly
increasing pairs are used in this interpretation.

`normalized` takes a list to its generator in the free abelian group
on all lists when it has no repeated entries, and to zero otherwise.
On the weakly increasing tuples in the mathematical proof, this is
exactly the usual normalized-simplex bracket. It is not a definition
of a differential, nor does the formalization assert that an arbitrary
unordered list is an ordered simplex.
`normalized_repeat` and `normalized_last_duplicate` prove the specified
repeated-tuple vanishings.

`AppendControl f g` means that for every comparable pair `x <= y`,
either `f(x)=g(x)` or `g(x)=g(y)`.
`append_control_iff_edge_identities` proves that, for monotone `g`
and pointwise `f <= g`, this is equivalent to all the corresponding
normalized edge identities. It constructs the necessity as well as
the sufficiency of this algebraic criterion.
`terminal_correction` quantifies over every poset, monotone `g`,
every function `f` satisfying this control condition, every finite
list `l`, and every `u <= v`, assuming every entry of `l` is at most
`u`. It proves

```
[f(l),f(u),g(v)] - [f(l),f(u),g(u)]
  = [g(l),g(u),g(v)].
```

In the prism proof this is `B-B'=G`. There is no bound on list
length, so this is not finite testing of dimensions. Monotonicity of
`f` and `f <= g` are not needed for this isolated equality; those
additional hypotheses are needed in the mathematical proof to make
the displayed tuples positive ordered simplices.

`sieve_constancy_implies_control` proves, for every lower subset `A`,
that `f=g` on `A` and constancy of `g` on its complement imply
`AppendControl f g`. These are constructed consequences of the
manuscript's hypotheses, not new assumptions for the original prism.

`glue_along_adjunction` quantifies over arbitrary categories, an actual
adjunction `L : C -> D` left adjoint to `R`, an actual categorical
pushout `Y` of `X <- A -> B`, an arbitrary target `Z` in `D`, and
arbitrary compatible maps `s : L(X) -> Z`, `p : L(B) -> Z`.
It constructs the unique `q : L(Y) -> Z` restricting to `s,p`.
There is no monomorphism, freeness, cofibrancy, or dimension
restriction. It proves the universal-property mechanism used to glue
whole cylinders. It does **not** construct the particular
strict-category adjunction or its finite-dimensional restriction;
those are separate mathematical obligations in the report.

## Trust and limits

The source imports Mathlib and uses no custom axioms, `sorry`,
`admit`, or `native_decide`. The five main declarations print their
axiom dependencies. Kernel checking establishes these statements,
not the identification of their abstract objects with the full
manuscript construction.

The associated ledger claim for a compiler run must therefore be an
algebraic or universal-property claim, not `C_COUNIVERSAL`.
A compiling source cannot by itself close the categorical,
topological, literature, novelty, or independent-review obligations.
