# Statement fidelity: the universal finite capacity reduction

Claim `SC_FINITE` is the finite weighted-cover implication in the report,
not the scalar-limit proposition, a theorem about hyperbolic groups, or a
numerical exponent check.

The source declares `weightedCover`, `hybridBound`, `intervalCapacity`, and
`colorClass` inside the namespace `SeparatedCapacity`.

`SeparatedCapacity.weightedCover` quantifies over arbitrary finite atom,
bin, and candidate types `A`, `B`, `Y`. Atom weights `ell` are real,
nonnegative and sum to one. The real array `active` is nonnegative.
The bin array has column sums at most the positive multiplicity bound in
applications; the theorem itself does not need its entries to be binary.
The nonnegative real coefficients `coeff` give coverage at least one on
every bin/atom row. The conclusion bounds the number of bins by the
multiplicity times the weighted candidate sum. In the application,
`active` and `bin` are zero/one interval and radial-bin incidences.

`SeparatedCapacity.hybridBound` proves the general real-algebra implication
for arbitrary finite candidate types. It assumes `N >= 0`, `m,E,lam,Lam > 0`,
nonnegative detector and small-range masses, the covering inequality,
detector squared mass at most `E`, and pointwise linear and quadratic
capacity bounds. It concludes the minimum of the two lower bounds in
equation (4) of the report. Cauchy--Schwarz is applied to an arbitrary
finite vector, not to one fixed size.

`SeparatedCapacity.intervalCapacity` joins these results without assuming
the desired conclusion. For every candidate it forms the actual normalized
overlap `t_y = sum_a ell_a active_ay` and the actual capacity
`min(lam*t_y, Lam*t_y^2)`. A decidable predicate `large` must satisfy the
two threshold inequalities against `lam` and `Lam*t_y`. Coverage is required
for every bin/atom row with coefficient one on large candidates and the
detector on small ones. Thus all the marking, finite row summation,
threshold-branch matching, energy comparison, and capacity lower bound
are in the compiler-checked implication. The geometric proof supplies
these rows; they are not proved by the compiler.

`SeparatedCapacity.colorClass` quantifies over every positive integer
number of colors and every coloring of a finite candidate type. It proves
that some class carries at least the average capacity. The analytic
packing argument supplies a proper coloring of the distance graph, so
that this class is separated. Properness and geometric separation are
not encoded in this arithmetic pigeonhole theorem.

Cutting an arbitrary real interval at its finitely many range endpoints
gives exactly the finite normalized atom weights used above; cut points
have zero length. This identification, the construction of the detector
from macroscopic paths and expansions, and the uniformity of geometric
constants are proved in `report.md`, not formalized here. The formal theorem
therefore checks the whole finite capacity reduction under its stated
row hypotheses, not the entire analytic or topological argument.

The standard Lean axioms for Mathlib's real-number theory are allowed.
There are no user axioms, placeholders, admitted proofs, finite-only
quantifier replacements, or assumptions asserting the capacity conclusion.
