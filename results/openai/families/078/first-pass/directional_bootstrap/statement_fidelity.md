# Statement fidelity: DB_FINITE_CORE

The source is `research/directional_bootstrap/Main.lean`, namespace
`DirectionalBootstrap`. It formalizes the finite normalization and
simultaneous trimming core, not the planar projection theorem or an
analytic limit.

## Objects and quantifiers

`blockMass p I J` is the sum of a real matrix over two finite index sets.
`two_sided_core` quantifies over arbitrary finite row and column types,
an entrywise nonnegative real matrix `p`, two nonnegative reference
weight vectors `mu,nu` each summing to one, and any real `delta >= 0`.
The matrix need not itself have mass one and need not be a product.
It proves existence of one pair of row/column subsets `I,J` for which:

- the retained matrix mass is nonnegative;
- it is at least the original total mass minus `2*delta`;
- every surviving row has raw mass at least `delta*mu a`;
- every surviving column has raw mass at least `delta*nu b`.

The same subsets work for all events tested afterwards. If the original
mass is `m>0`, taking `delta=m/4` guarantees mass at least `m/2`.
Empty subsets are allowed when the lower mass bound is nonpositive.
Nonempty probability index types follow automatically from the
normalization hypotheses, not from an unstated instance.

`reciprocal_retained_cap` quantifies over an arbitrary row type, a finite
column type, a finite set `I` of rows, a real matrix `g`, real reference
weights `mu`, a real cap, and strictly positive `r,v`. Its hypotheses are
a strictly positive parent weight and the per-row sum inequality
`sum_b g(a,b) <= cap*mu(a)`. Its conclusion divides the sum over that
parent by `parentWeight*r*v` and bounds it by `cap/(r*v)`. No inverse
parent weight remains. The theorem does not impose probability
normalization on `g`: in the application it is the raw nonnegative
matrix of incidences satisfying the common event, separation, and one
target direction interval. The geometrical implication giving its
row inequality must be proved separately.

`fiber_cap_from_core` quantifies over five real scalars: an event mass,
the positive surviving row mass, a reference mass, a nonnegative cap,
and a strictly positive threshold. A lower row floor and an upper
event cap imply the normalized conditional cap `cap/delta`.
The normalization by the total mass of the core cancels, so the lemma
also applies to its columns. Applying it to every tested bin supplies
simultaneous two-pin caps on the one core produced above.

`mesh_exponent_loss` states the exact real inequality

`s*a - 4*mesh <= s*(a+eLeft-eChild)-2*(eLeft+eRight)`,

for `0<=s<=1` and each error at most `mesh`. This includes the physical
case of nonnegative depth errors, but does not require their
nonnegativity. The parameters encode
`j_-=j-eLeft`, `j_+=j+eRight`, `b_-=j+a-eChild`.
The logarithmic losses from prefix mass estimates are additional
terms, not silently included in this algebraic inequality.

## Relation to the manuscript

The reciprocal cap is the normalization step in
`07-rate-transfer.tex:951-967`; `r` is the original common-event
retention on an `A_j` parent and `v` is its subsequent separation
retention. The core theorem justifies, independently of any product
assumption, a common uniform trim under both pins. It also provides the
degree floors used in the actual-marginal product replacement.
The mesh inequality applies to lines 1007-1021 using their unchanged
global tree atoms.

No declaration asserts Ren--Wang, Taylor approximation, the no-strip
condition, entropy-profile extraction, differentiability, integration,
or the Bochner--Riesz theorem. These remain analytical proof obligations
in `report.md`. The formal claim is only `DB_FINITE_CORE`; compilation
cannot certify `DB_MAIN` or `DB_APPLICATION`.
