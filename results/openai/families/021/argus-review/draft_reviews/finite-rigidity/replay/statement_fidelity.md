# Statement fidelity: finite partial-incidence rigidity

The source is `Main.lean`, namespace `PartialIncidence`, for ledger claim
`C_INVERSE_FINITE`. It proves universal finite combinatorial and arithmetic
theorems. It is not a formalization of the entire Jacobsthal theorem, the
entire inverse proposition, the real-algebraic curve decomposition, or the
asymptotic sampling argument.

## Objects and quantifiers

`Point`, `Cell`, and `PrimeIndex` are arbitrary types; `X`, `C`, `P`, `A`,
`E`, and `L` are finite sets of the appropriate types. Predicates can be
arbitrary. Classical decidability is used to form their finite filters.
No prime or point is universally required to participate in an incidence.
Different points may have completely different incident prime sets.

`rowCount X rel c` counts points of `X` satisfying `rel c`.
`mass C X rel` is the sum of those counts.
`overlap C rel x y` counts cells containing both points.
These definitions are actual finite cardinalities, not supplied numbers.

## Principal declarations

`partial_collision_bound` assumes that every distinct pair of points
occurs together in at most `B` cells. It proves

```
mass^2 <= |C| * (B*|X|*(|X|-1) + mass).
```

In particular the diagonal contribution is `mass`, not `|X|` or zero.
`energy_identity`, `energy_bound`, and `transpose_mass` prove the
double-counting statements rather than assuming them.
`partial_collision_bound_loose` replaces `|X|*(|X|-1)` by `|X|^2`.

`partial_incidence_forces_alignment` has an actual full incidence
predicate `full p x` and separate cell predicate `rel c x`. Its
assumptions are:

1. Distinct point pairs share at most `B` cells.
2. Every full incidence is either at a member of `A`, at a member of
   `E`, or covered by a cell with the same `primeOf` label.
3. Every point has at least `r` full incidences.
4. The cell mass is at most `|P|*|X|`.
5. `|E|+t <= r`, and
   `|C|*(B*|X|^2+|P|*|X|) < ((r-|E|-t)*|X|)^2`.

It concludes `t < |A|`. Neither `A` nor `E` need be disjoint or
subsets of `P`; this only makes the covering bound more conservative.
In the modular application, `A` is the set of aligning isolated
primes and `E` consists of primes dividing the primitive line
denominator. The mass bound follows from at most one occupied slope
per point and prime; it is an explicit hypothesis, not a fact about
arbitrary cell systems.

`no_rich_nonstructured_line` has the same hypotheses, plus the
following conditional nonstructuredness hypothesis: if `t < |A|`,
no full incidence at a prime of `A` is allowed. It proves `False`.
For the application, the height and CRT argument puts the intercept
in the pre-fixed rational list as soon as its alignment count
exceeds `t`; the definition of nonstructuredness then supplies this
conditional hypothesis. Lean proves the two-stage contradiction,
but does not silently prove the geometric height argument.

`fixed_list_packing` exchanges the roles of primes and rational
labels. It assumes each rational label has at least `t` aligning
prime labels, distinct rational labels share at most `B` such
primes, and `2*|P|*B <= t^2`. It concludes

```
|L|*t^2 <= 2*|P|^2.
```

`common_alignment_determinant` proves, for arbitrary integers, that
two alignment divisibilities imply divisibility of
`A1*D2-A2*D1`. Nonvanishing of that determinant for distinct reduced
rationals and its height estimate are supplied by the report's
elementary rational arithmetic, not assumed in the finite packing
theorem as an alignment conclusion.

## Modular and CRT arithmetic

`same_slope_same_residue` is universal over a field. For two points
on `d*y=a*x+b` with the same incidence `y+s*x=ap`, it assumes
`d*ap != b` and proves their `x` coordinates equal. It derives
the nonzero coefficient needed for cancellation. At a prime
modulus the field is `ZMod p`; unalignment gives the displayed
nonzero right side. The passage from integer congruences to that
field, and the bound on the number of prime divisors of an integer
difference, are explicit arguments in the report.

`line_g_divides_q` assumes integer coprimality of `g` and `a` and
the equation `(g*D)*b = a*q + g*A`; it proves `g` divides `q`.

`line_nonaligned_prime_divides_g` assumes a prime integer `ell`
divides `q` but does not divide `D*b-A`, together with the same
line equation. It proves `ell` divides `g`.

`squarefree_exception_product` takes an actual finite set of
pairwise coprime prime integers, each dividing `q` and not dividing
`D*b-A`. It proves their product divides `g`.
`squarefree_exception_height` additionally assumes `g>0`, `D>=0`
and proves `D*product <= g*D`. It does not assume the desired
height bound or squarefreeness of either denominator. Its finite
pairwise-coprime support hypothesis is exactly what distinct
prime divisors of the manuscript's squarefree `q` supply. In
fact this divisibility lemma is valid for such a support even
without requiring `q` itself squarefree.

`prime_product_forces_zero` takes any finite pairwise-coprime
integer factors, each dividing an integer value, and assumes
that value's natural absolute value is smaller than the natural
absolute value of their product. It proves the value is zero.
The coefficient-lattice construction and the polynomial value
bound that feed this criterion are established in prose.

`marked_abscissa_constant` proves the displayed degree arithmetic
for every natural degree at least two.
`structural_exponent_margin` proves the three strict rational
exponent inequalities for every rational `alpha < 1/5`.
It is not a formal proof about limits or real curve topology.

## What remains outside the kernel

The report proves the interpolation-lattice existence argument,
the coefficient-independent nonlinear lattice-point estimate,
rational-line extraction and height bounds, integer-rounding
bridge to the manuscript's parameters, and the handling of
whole-box harmonic measure and fixed-width limits. These must
be read by Reviewer. Kernel success certifies the substantive
finite partial-incidence core above, not those untranslated
arguments, novelty, significance, or the manuscript's other
global dependencies.

`verify.py` checks the advertised exact fixtures and numerical
inequalities separately. It does not replace these universal
proofs by passing examples.
