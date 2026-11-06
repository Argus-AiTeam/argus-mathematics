# Statement fidelity: PF-CORE

This document describes exactly the four declarations in
`research/prescribed-filtration-audit/Main.lean`. The ledger claim is
`PF-CORE`, not `PF-REALIZATION`.

## Algebraic declarations

`frobenius_basis_change` in namespace `PrescribedFiltration` quantifies over an arbitrary
group G, an arbitrary multiplicative homomorphism sigma:G->G, and any
b,g in G. It proves

    sigma(g)^-1 sigma(b) sigma(sigma(g))
      = sigma(g^-1 b sigma(g)).

It does not assume sigma is invertible. Frobenius on the coefficient
isocrystal is an allowed instance. This is a universal group identity,
not a calculation in a finite group.

`representation_basis_change` in namespace `PrescribedFiltration` quantifies over two
groups G,H, homomorphisms sigma, tau and rho, the explicit compatibility
tau(rho(a))=rho(sigma(a)) for every a, and b,g in G. It proves the image
of the same change-of-basis identity in H. In the application H is the
group of invertible cohomological matrices, rho is the dual
representation, and tau is coefficient Frobenius. The theorem does not
construct these geometric objects or assert their compatibility without
the stated hypothesis.

`faithful_central_preimage` in namespace `PrescribedFiltration` quantifies over groups
G,H, an injective homomorphism rho, and z in G whose image commutes with
every element of H. It proves that z commutes with every element of G.
Taking H=GL gives the center condition needed in PR Proposition 3.1.1.
Identifying the center of GL with scalar matrices is not formalized
here and is not needed in this abstract statement.

## Topological declaration

`propagate_tensor_equalities` in namespace `PrescribedFiltration` quantifies over every
topological space X, every index type I, every family of value types A(i),
and every indexed map discrepancy(i):X->A(i). Each map is hypothesized
to be locally constant. A value zero(i) is specified for each index;
no additive structure or finiteness of I is assumed.

One good-point predicate is fixed on X. Every connected component must
contain a good point. At every good point **all** the indexed maps have
their specified zero values. The conclusion says that every indexed
map is identically zero on X. The same discrepancy maps are retained
throughout; there is no replacement of the universal quasi-isogeny
when the index changes.

For the geometric interpretation, X is the underlying topological space
of the perfect reduced marked RZ space, I indexes the tensor, ell != p,
and a finite reduction level. A(i) is the corresponding constant finite
etale tensor module. The good points are specializations of the initial
lift's at-p Hecke orbit. These geometric identifications, local
constancy, orbit-component coverage, and the existence and compatibility
of the universal algebraic quasi-isogeny are established in the prose
argument using the explicitly listed external theorems. They are **not**
hypotheses discharged by Lean.

## Exclusions

The formal source contains no definition of an abelian variety,
crystalline representation, local Shimura variety, integral tensor
torsor, or admissible filtration. It does not prove or refute the
realization lemma, the constrained-filtration theorem, the
balanced-Weil dichotomy, the rationality conjecture, or the companion
CM Hodge theorem in the kernel.

The full realization argument is a mathematical proof relative to
the external geometric results in `realization_proof.md`. Its independent
review and novelty assessment are separate from compiler acceptance.
The symbolic matrix family and the p=2 integral-lattice obstruction
belong to `verify.py`, not to these Lean declarations.
